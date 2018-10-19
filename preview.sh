#!/bin/sh

#####################################################################
## Preview video-generator script 					                #
## Develop by Yoandy (yoandypv@gmail.com).                          #
## Based on FFmpeg, ImageMagick & Convert                           #
#####################################################################

## Configuration variables

# Input video in first script parameter

originalVideo=$1

# Compression ratio of image and specimen generator, to downsize of video
scaleRatio=-1:120

# Number of frames to capture from the original video (starting by first)
numberOfFramesToCapture=100

# Text to put into a final video
waterMark="Sample sign"

################################################################

# Main Program

# Step 1: Get images from original video 
ffmpeg -i $originalVideo -r 1 -vf scale=$scaleRatio -t $numberOfFramesToCapture  -vcodec png capture-%d.png
#ffmpeg -i lodging.mp4 -r 1 -t 1 -vcodec png capture-%d.png


# Step 2: Sign the image with watermark
for x in *.png; do 
  convert $x -gravity SouthEast -pointsize 20 -fill white -annotate +10+10 $waterMark mod-$x
  rm $x
done

# Step 3: Generate the specimen video
ffmpeg -start_number 1 -i mod-capture-%d.png -framerate 25 -pattern_type sequence -start_number 1234 -r 4 -vcodec mpeg4 "spec-"$originalVideo

# Step 4: Clean the workspace
for x in *.png; do 
  rm $x
done


#ffmpeg -loop 1 -i capture-1.png-mod.png -c:v libx264 -t 220 -pix_fmt yuv420p out.mp4

