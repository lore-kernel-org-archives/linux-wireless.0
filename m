Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59361 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762430Ab2FVRSu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 13:18:50 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6/6] mac80211: trace debug messages
Date: Fri, 22 Jun 2012 19:18:45 +0200
Message-Id: <1340385525-14487-7-git-send-email-johannes@sipsolutions.net> (sfid-20120622_191859_405362_1FAA8C29)
In-Reply-To: <1340385525-14487-1-git-send-email-johannes@sipsolutions.net>
References: <1340385525-14487-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It can be very useful to have all debug messages
available when debugging, but hard to correlate
between different sources, so add a trace event
for all mac80211 debug messages.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/Kconfig |   13 ++++++++++
 net/mac80211/debug.h |   18 ++++++++++++++
 net/mac80211/trace.c |   66 ++++++++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/trace.h |   39 +++++++++++++++++++++++++++++
 4 files changed, 136 insertions(+)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 7475e26..63af254 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -107,6 +107,19 @@ config MAC80211_DEBUGFS
 
 	  Say N unless you know you need this.
 
+config MAC80211_MESSAGE_TRACING
+	bool "Trace all mac80211 debug messages"
+	depends on MAC80211
+	---help---
+	  Select this option to have mac80211 register the
+	  mac80211_msg trace subsystem with tracepoints to
+	  collect all debugging messages, independent of
+	  printing them into the kernel log.
+
+	  The overhead in this option is that all the messages
+	  need to be present in the binary and formatted at
+	  runtime for tracing.
+
 menuconfig MAC80211_DEBUG_MENU
 	bool "Select mac80211 debugging features"
 	depends on MAC80211
diff --git a/net/mac80211/debug.h b/net/mac80211/debug.h
index dd5b5d0..ea799c3 100644
--- a/net/mac80211/debug.h
+++ b/net/mac80211/debug.h
@@ -1,5 +1,6 @@
 #ifndef __MAC80211_DEBUG_H
 #define __MAC80211_DEBUG_H
+#include <net/cfg80211.h>
 
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 #define MAC80211_IBSS_DEBUG 1
@@ -63,7 +64,23 @@
 
 #define DEBUG
 
+#ifdef CONFIG_MAC80211_MESSAGE_TRACING
+void __sdata_info(const char *fmt, ...) __printf(1, 2);
+void __sdata_dbg(bool print, const char *fmt, ...) __printf(2, 3);
+void __sdata_err(const char *fmt, ...) __printf(1, 2);
+void __wiphy_dbg(struct wiphy *wiphy, bool print, const char *fmt, ...)
+	__printf(3, 4);
+
 #define _sdata_info(sdata, fmt, ...)					\
+	__sdata_info("%s: " fmt, (sdata)->name, ##__VA_ARGS__)
+#define _sdata_dbg(print, sdata, fmt, ...)				\
+	__sdata_dbg(print, "%s: " fmt, (sdata)->name, ##__VA_ARGS__)
+#define _sdata_err(sdata, fmt, ...)					\
+	__sdata_err("%s: " fmt, (sdata)->name, ##__VA_ARGS__)
+#define _wiphy_dbg(print, wiphy, fmt, ...)				\
+	__wiphy_dbg(wiphy, print, fmt, ##__VA_ARGS__)
+#else
+#define _sdata_info(print, sdata, fmt, ...)				\
 do {									\
 	pr_info("%s: " fmt,						\
 		(sdata)->name, ##__VA_ARGS__);				\
@@ -87,6 +104,7 @@ do {									\
 	if (print)							\
 		wiphy_dbg((wiphy), fmt, ##__VA_ARGS__);			\
 } while (0)
+#endif
 
 #define sdata_info(sdata, fmt, ...)					\
 	_sdata_info(sdata, fmt, ##__VA_ARGS__)
diff --git a/net/mac80211/trace.c b/net/mac80211/trace.c
index 943da6e..386e45d 100644
--- a/net/mac80211/trace.c
+++ b/net/mac80211/trace.c
@@ -3,7 +3,73 @@
 
 /* sparse isn't too happy with all macros... */
 #ifndef __CHECKER__
+#include <net/cfg80211.h>
 #include "driver-ops.h"
+#include "debug.h"
 #define CREATE_TRACE_POINTS
 #include "trace.h"
+
+#ifdef CONFIG_MAC80211_MESSAGE_TRACING
+void __sdata_info(const char *fmt, ...)
+{
+	struct va_format vaf = {
+		.fmt = fmt,
+	};
+	va_list args;
+
+	va_start(args, fmt);
+	vaf.va = &args;
+
+	pr_info("%pV", &vaf);
+	trace_mac80211_info(&vaf);
+	va_end(args);
+}
+
+void __sdata_dbg(bool print, const char *fmt, ...)
+{
+	struct va_format vaf = {
+		.fmt = fmt,
+	};
+	va_list args;
+
+	va_start(args, fmt);
+	vaf.va = &args;
+
+	if (print)
+		pr_debug("%pV", &vaf);
+	trace_mac80211_dbg(&vaf);
+	va_end(args);
+}
+
+void __sdata_err(const char *fmt, ...)
+{
+	struct va_format vaf = {
+		.fmt = fmt,
+	};
+	va_list args;
+
+	va_start(args, fmt);
+	vaf.va = &args;
+
+	pr_err("%pV", &vaf);
+	trace_mac80211_err(&vaf);
+	va_end(args);
+}
+
+void __wiphy_dbg(struct wiphy *wiphy, bool print, const char *fmt, ...)
+{
+	struct va_format vaf = {
+		.fmt = fmt,
+	};
+	va_list args;
+
+	va_start(args, fmt);
+	vaf.va = &args;
+
+	if (print)
+		wiphy_dbg(wiphy, "%pV", &vaf);
+	trace_mac80211_dbg(&vaf);
+	va_end(args);
+}
+#endif
 #endif
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 392bcc9..2e60f4a 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1632,6 +1632,45 @@ TRACE_EVENT(stop_queue,
 		LOCAL_PR_ARG, __entry->queue, __entry->reason
 	)
 );
+
+#ifdef CONFIG_MAC80211_MESSAGE_TRACING
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
+#endif
+
 #endif /* !__MAC80211_DRIVER_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
-- 
1.7.10

