#!/bin/bash

set -x -e

URL="http://pkg.4paradigm.com:81/fedb/spark_dailybuild/"
VERSION=`date +"%Y-%m-%d"`-`git rev-parse --short HEAD`
FILE=fespark-3.0.0-bin-$VERSION.tgz

mv ./spark-3.0.0-bin-llvm-spark.tgz $FILE
echo "Uploading $FILE to $URL"

CSRF=$(curl $URL 2>/dev/null| grep '"token"' | sed 's:.*"token">\(.*\)</span>:\1:')
FILENAME=$(basename $FILE)
curl -XPOST $URL -H "Token: $CSRF" -H 'Upload: true'  -F "$FILENAME=@$FILE"

if [ $? -ne 0 ]; then
    echo "Upload package failed"
    exit 1
fi
