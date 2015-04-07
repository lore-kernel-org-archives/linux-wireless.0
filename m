Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:47543 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752969AbbDGDNy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Apr 2015 23:13:54 -0400
Date: Mon, 6 Apr 2015 23:13:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] mac80211: Move message tracepoints to their own header
Message-ID: <20150406231357.2b8e452d@grimm.local.home> (sfid-20150407_051413_304225_FD96045C)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Every tracing file must have its own TRACE_SYSTEM defined.
The mac80211 tracepoint header broke this and add in the middle
of the file had:

 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM mac80211_msg

Unfortunately, this broke new code in the ftrace infrastructure.
Moving the mac80211_msg into its own trace file with its own
TRACE_SYSTEM defined fixes the issue.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/mac80211/trace.c     |  1 +
 net/mac80211/trace.h     | 38 ----------------------------------
 net/mac80211/trace_msg.h | 53 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 54 insertions(+), 38 deletions(-)
 create mode 100644 net/mac80211/trace_msg.h

diff --git a/net/mac80211/trace.c b/net/mac80211/trace.c
index 386e45d8a958..edfe0c170a1c 100644
--- a/net/mac80211/trace.c
+++ b/net/mac80211/trace.c
@@ -8,6 +8,7 @@
 #include "debug.h"
 #define CREATE_TRACE_POINTS
 #include "trace.h"
+#include "trace_msg.h"
 
 #ifdef CONFIG_MAC80211_MESSAGE_TRACING
 void __sdata_info(const char *fmt, ...)
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 263a9561eb26..755a5388dbca 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -2312,44 +2312,6 @@ TRACE_EVENT(drv_tdls_recv_channel_switch,
 	)
 );
 
-#ifdef CONFIG_MAC80211_MESSAGE_TRACING
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM mac80211_msg
-
-#define MAX_MSG_LEN	100
-
-DECLARE_EVENT_CLASS(mac80211_msg_event,
-	TP_PROTO(struct va_format *vaf),
-
-	TP_ARGS(vaf),
-
-	TP_STRUCT__entry(
-		__dynamic_array(char, msg, MAX_MSG_LEN)
-	),
-
-	TP_fast_assign(
-		WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
-				       MAX_MSG_LEN, vaf->fmt,
-				       *vaf->va) >= MAX_MSG_LEN);
-	),
-
-	TP_printk("%s", __get_str(msg))
-);
-
-DEFINE_EVENT(mac80211_msg_event, mac80211_info,
-	TP_PROTO(struct va_format *vaf),
-	TP_ARGS(vaf)
-);
-DEFINE_EVENT(mac80211_msg_event, mac80211_dbg,
-	TP_PROTO(struct va_format *vaf),
-	TP_ARGS(vaf)
-);
-DEFINE_EVENT(mac80211_msg_event, mac80211_err,
-	TP_PROTO(struct va_format *vaf),
-	TP_ARGS(vaf)
-);
-#endif
-
 #endif /* !__MAC80211_DRIVER_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/net/mac80211/trace_msg.h b/net/mac80211/trace_msg.h
new file mode 100644
index 000000000000..768f7c22a190
--- /dev/null
+++ b/net/mac80211/trace_msg.h
@@ -0,0 +1,53 @@
+#ifdef CONFIG_MAC80211_MESSAGE_TRACING
+
+#if !defined(__MAC80211_MSG_DRIVER_TRACE) || defined(TRACE_HEADER_MULTI_READ)
+#define __MAC80211_MSG_DRIVER_TRACE
+
+#include <linux/tracepoint.h>
+#include <net/mac80211.h>
+#include "ieee80211_i.h"
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM mac80211_msg
+
+#define MAX_MSG_LEN	100
+
+DECLARE_EVENT_CLASS(mac80211_msg_event,
+	TP_PROTO(struct va_format *vaf),
+
+	TP_ARGS(vaf),
+
+	TP_STRUCT__entry(
+		__dynamic_array(char, msg, MAX_MSG_LEN)
+	),
+
+	TP_fast_assign(
+		WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
+				       MAX_MSG_LEN, vaf->fmt,
+				       *vaf->va) >= MAX_MSG_LEN);
+	),
+
+	TP_printk("%s", __get_str(msg))
+);
+
+DEFINE_EVENT(mac80211_msg_event, mac80211_info,
+	TP_PROTO(struct va_format *vaf),
+	TP_ARGS(vaf)
+);
+DEFINE_EVENT(mac80211_msg_event, mac80211_dbg,
+	TP_PROTO(struct va_format *vaf),
+	TP_ARGS(vaf)
+);
+DEFINE_EVENT(mac80211_msg_event, mac80211_err,
+	TP_PROTO(struct va_format *vaf),
+	TP_ARGS(vaf)
+);
+#endif /* !__MAC80211_MSG_DRIVER_TRACE || TRACE_HEADER_MULTI_READ */
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE trace_msg
+#include <trace/define_trace.h>
+
+#endif
-- 
1.8.3.1

