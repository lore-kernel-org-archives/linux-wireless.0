Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40437 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934045AbXCWNmg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 09:42:36 -0400
Subject: [PATCH] fix information leak in wireless extensions on 64-bit  platforms
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>, stable@kernel.org
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jean Tourrilhes <jt@hpl.hp.com>
Content-Type: text/plain
Date: Fri, 23 Mar 2007 10:06:27 +0100
Message-Id: <1174640787.3588.65.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wireless extensions on 64-bit platforms leak information from the kernel
stack due to padding in structs that is copied. This affects any
wireless event stream including scan results and so hence is available
to unprivileged users.

This patch is a quick fix for this that simply zeroes out the padding in
the structs before copying them until Jean comes up with the promised
better fix, at which time he can revert this one along with his new
patch.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: stable@kernel.org
Cc: linux-wireless@vger.kernel.org
Cc: Jean Tourrilhes <jt@hpl.hp.com>

---
 include/net/iw_handler.h |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- wireless-dev.orig/include/net/iw_handler.h	2007-03-17 20:19:45.369309540 +0100
+++ wireless-dev/include/net/iw_handler.h	2007-03-17 20:19:59.429309540 +0100
@@ -484,6 +484,9 @@ iwe_stream_add_event(char *	stream,		/* 
 		     struct iw_event *iwe,	/* Payload */
 		     int	event_len)	/* Real size of payload */
 {
+	/* clear padding */
+	memset((char*)iwe + 4, 0, IW_EV_LCP_LEN - 4);
+
 	/* Check if it's possible */
 	if(likely((stream + event_len) < ends)) {
 		iwe->len = event_len;
@@ -505,6 +508,10 @@ iwe_stream_add_point(char *	stream,		/* 
 		     char *	extra)		/* More payload */
 {
 	int	event_len = IW_EV_POINT_LEN + iwe->u.data.length;
+
+	/* clear padding */
+	memset((char*)iwe + 4, 0, IW_EV_LCP_LEN - 4);
+
 	/* Check if it's possible */
 	if(likely((stream + event_len) < ends)) {
 		iwe->len = event_len;
@@ -531,6 +538,9 @@ iwe_stream_add_value(char *	event,		/* E
 		     struct iw_event *iwe,	/* Payload */
 		     int	event_len)	/* Real size of payload */
 {
+	/* clear padding */
+	memset((char*)iwe + 4, 0, IW_EV_LCP_LEN - 4);
+
 	/* Don't duplicate LCP */
 	event_len -= IW_EV_LCP_LEN;
 
@@ -558,6 +568,9 @@ iwe_stream_check_add_event(char *	stream
 			   int		event_len,	/* Size of payload */
 			   int *	perr)		/* Error report */
 {
+	/* clear padding */
+	memset((char*)iwe + 4, 0, IW_EV_LCP_LEN - 4);
+
 	/* Check if it's possible, set error if not */
 	if(likely((stream + event_len) < ends)) {
 		iwe->len = event_len;
@@ -582,6 +595,10 @@ iwe_stream_check_add_point(char *	stream
 			   int *	perr)		/* Error report */
 {
 	int	event_len = IW_EV_POINT_LEN + iwe->u.data.length;
+
+	/* clear padding */
+	memset((char*)iwe + 4, 0, IW_EV_LCP_LEN - 4);
+
 	/* Check if it's possible */
 	if(likely((stream + event_len) < ends)) {
 		iwe->len = event_len;
@@ -611,6 +628,9 @@ iwe_stream_check_add_value(char *	event,
 			   int		event_len,	/* Size of payload */
 			   int *	perr)		/* Error report */
 {
+	/* clear padding */
+	memset((char*)iwe + 4, 0, IW_EV_LCP_LEN - 4);
+
 	/* Don't duplicate LCP */
 	event_len -= IW_EV_LCP_LEN;
 


