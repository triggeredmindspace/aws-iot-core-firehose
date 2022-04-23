resource "aws_iot_topic_rule" "rule" {
   name        = "iot_kinesis_s3_alltopics"
   description = "Example rule"
   enabled     = true
   sql        = "*"
   sql_version = "2016-03-23"

   firehose {
     delivery_stream_name = "mqtt-kinesis-firehose-stream-s3"
     role_arn             = aws_iam_role.iot.arn
     separator            = "\n"
    # role_arn       = aws_iam_role.role.arn
   }
 }

resource "aws_iam_role" "iot" {
  name = "iot_topic_firehose_analytics_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "iot.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "iot_firehose" {
  name = "iot-firehose-policy"
  role = "${aws_iam_role.iot.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "firehose:*"
      ],
      "Resource": [
        "${aws_kinesis_firehose_delivery_stream.alltopics_stream.arn}"
      ]
    }
  ]
}
EOF
}

