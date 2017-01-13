Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49500 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751296AbdAMIhx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 03:37:53 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] wext: uninline point wrappers
Date: Fri, 13 Jan 2017 09:37:48 +0100
Message-Id: <20170113083748.20069-1-johannes@sipsolutions.net> (sfid-20170113_093757_020625_ED1577FE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

With 78, 111 and 85 bytes respectively, the functions
iwe_stream_add_event(), iwe_stream_add_point() and
iwe_stream_add_value() really shouldn't be inlines.

It appears that at least my compiler already decided
the same, and created a single instance of each one
of them for each file using it, but that's still a
number of instances in the system overall, which this
reduces.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/iw_handler.h | 67 +++++-------------------------------------------
 net/wireless/wext-core.c | 67 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 74 insertions(+), 60 deletions(-)

diff --git a/include/net/iw_handler.h b/include/net/iw_handler.h
index c2aa73e5e6bb..2509728650bd 100644
--- a/include/net/iw_handler.h
+++ b/include/net/iw_handler.h
@@ -505,25 +505,8 @@ static inline int iwe_stream_event_len_adjust(struct iw_request_info *info,
 /*
  * Wrapper to add an Wireless Event to a stream of events.
  */
-static inline char *
-iwe_stream_add_event(struct iw_request_info *info, char *stream, char *ends,
-		     struct iw_event *iwe, int event_len)
-{
-	int lcp_len = iwe_stream_lcp_len(info);
-
-	event_len = iwe_stream_event_len_adjust(info, event_len);
-
-	/* Check if it's possible */
-	if(likely((stream + event_len) < ends)) {
-		iwe->len = event_len;
-		/* Beware of alignement issues on 64 bits */
-		memcpy(stream, (char *) iwe, IW_EV_LCP_PK_LEN);
-		memcpy(stream + lcp_len, &iwe->u,
-		       event_len - lcp_len);
-		stream += event_len;
-	}
-	return stream;
-}
+char *iwe_stream_add_event(struct iw_request_info *info, char *stream,
+			   char *ends, struct iw_event *iwe, int event_len);
 
 static inline char *
 iwe_stream_add_event_check(struct iw_request_info *info, char *stream,
@@ -541,27 +524,8 @@ iwe_stream_add_event_check(struct iw_request_info *info, char *stream,
  * Wrapper to add an short Wireless Event containing a pointer to a
  * stream of events.
  */
-static inline char *
-iwe_stream_add_point(struct iw_request_info *info, char *stream, char *ends,
-		     struct iw_event *iwe, char *extra)
-{
-	int event_len = iwe_stream_point_len(info) + iwe->u.data.length;
-	int point_len = iwe_stream_point_len(info);
-	int lcp_len   = iwe_stream_lcp_len(info);
-
-	/* Check if it's possible */
-	if(likely((stream + event_len) < ends)) {
-		iwe->len = event_len;
-		memcpy(stream, (char *) iwe, IW_EV_LCP_PK_LEN);
-		memcpy(stream + lcp_len,
-		       ((char *) &iwe->u) + IW_EV_POINT_OFF,
-		       IW_EV_POINT_PK_LEN - IW_EV_LCP_PK_LEN);
-		if (iwe->u.data.length && extra)
-			memcpy(stream + point_len, extra, iwe->u.data.length);
-		stream += event_len;
-	}
-	return stream;
-}
+char *iwe_stream_add_point(struct iw_request_info *info, char *stream,
+			   char *ends, struct iw_event *iwe, char *extra);
 
 static inline char *
 iwe_stream_add_point_check(struct iw_request_info *info, char *stream,
@@ -580,25 +544,8 @@ iwe_stream_add_point_check(struct iw_request_info *info, char *stream,
  * Be careful, this one is tricky to use properly :
  * At the first run, you need to have (value = event + IW_EV_LCP_LEN).
  */
-static inline char *
-iwe_stream_add_value(struct iw_request_info *info, char *event, char *value,
-		     char *ends, struct iw_event *iwe, int event_len)
-{
-	int lcp_len = iwe_stream_lcp_len(info);
-
-	/* Don't duplicate LCP */
-	event_len -= IW_EV_LCP_LEN;
-
-	/* Check if it's possible */
-	if(likely((value + event_len) < ends)) {
-		/* Add new value */
-		memcpy(value, &iwe->u, event_len);
-		value += event_len;
-		/* Patch LCP */
-		iwe->len = value - event;
-		memcpy(event, (char *) iwe, lcp_len);
-	}
-	return value;
-}
+char *iwe_stream_add_value(struct iw_request_info *info, char *event,
+			   char *value, char *ends, struct iw_event *iwe,
+			   int event_len);
 
 #endif	/* _IW_HANDLER_H */
diff --git a/net/wireless/wext-core.c b/net/wireless/wext-core.c
index 6250b1cfcde5..1a4db6790e20 100644
--- a/net/wireless/wext-core.c
+++ b/net/wireless/wext-core.c
@@ -1119,3 +1119,70 @@ int compat_wext_handle_ioctl(struct net *net, unsigned int cmd,
 	return ret;
 }
 #endif
+
+char *iwe_stream_add_event(struct iw_request_info *info, char *stream,
+			   char *ends, struct iw_event *iwe, int event_len)
+{
+	int lcp_len = iwe_stream_lcp_len(info);
+
+	event_len = iwe_stream_event_len_adjust(info, event_len);
+
+	/* Check if it's possible */
+	if (likely((stream + event_len) < ends)) {
+		iwe->len = event_len;
+		/* Beware of alignement issues on 64 bits */
+		memcpy(stream, (char *) iwe, IW_EV_LCP_PK_LEN);
+		memcpy(stream + lcp_len, &iwe->u,
+		       event_len - lcp_len);
+		stream += event_len;
+	}
+
+	return stream;
+}
+EXPORT_SYMBOL(iwe_stream_add_event);
+
+char *iwe_stream_add_point(struct iw_request_info *info, char *stream,
+			   char *ends, struct iw_event *iwe, char *extra)
+{
+	int event_len = iwe_stream_point_len(info) + iwe->u.data.length;
+	int point_len = iwe_stream_point_len(info);
+	int lcp_len   = iwe_stream_lcp_len(info);
+
+	/* Check if it's possible */
+	if (likely((stream + event_len) < ends)) {
+		iwe->len = event_len;
+		memcpy(stream, (char *) iwe, IW_EV_LCP_PK_LEN);
+		memcpy(stream + lcp_len,
+		       ((char *) &iwe->u) + IW_EV_POINT_OFF,
+		       IW_EV_POINT_PK_LEN - IW_EV_LCP_PK_LEN);
+		if (iwe->u.data.length && extra)
+			memcpy(stream + point_len, extra, iwe->u.data.length);
+		stream += event_len;
+	}
+
+	return stream;
+}
+EXPORT_SYMBOL(iwe_stream_add_point);
+
+char *iwe_stream_add_value(struct iw_request_info *info, char *event,
+			   char *value, char *ends, struct iw_event *iwe,
+			   int event_len)
+{
+	int lcp_len = iwe_stream_lcp_len(info);
+
+	/* Don't duplicate LCP */
+	event_len -= IW_EV_LCP_LEN;
+
+	/* Check if it's possible */
+	if (likely((value + event_len) < ends)) {
+		/* Add new value */
+		memcpy(value, &iwe->u, event_len);
+		value += event_len;
+		/* Patch LCP */
+		iwe->len = value - event;
+		memcpy(event, (char *) iwe, lcp_len);
+	}
+
+	return value;
+}
+EXPORT_SYMBOL(iwe_stream_add_value);
-- 
2.9.3
