Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48656 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932879Ab2FVNOt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 09:14:49 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6/6] mac80211: trace debug messages
Date: Fri, 22 Jun 2012 15:14:42 +0200
Message-Id: <1340370882-9258-7-git-send-email-johannes@sipsolutions.net> (sfid-20120622_151500_764611_9B410A86)
In-Reply-To: <1340370882-9258-1-git-send-email-johannes@sipsolutions.net>
References: <1340370882-9258-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It can be very useful to have all debug messages
available when debugging, but hard to correlate
between different sources, so add a trace event
for all mac80211 debug messages.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/Kconfig |   13 +++++++++++++
 net/mac80211/debug.h |   11 +++++++++++
 net/mac80211/trace.c |   36 ++++++++++++++++++++++++++++++++++++
 net/mac80211/trace.h |   26 ++++++++++++++++++++++++++
 4 files changed, 86 insertions(+)

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
index b2f4d2d..1bed034 100644
--- a/net/mac80211/debug.h
+++ b/net/mac80211/debug.h
@@ -1,5 +1,6 @@
 #ifndef __MAC80211_DEBUG_H
 #define __MAC80211_DEBUG_H
+#include <net/cfg80211.h>
 
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 #define MAC80211_IBSS_DEBUG 1
@@ -56,6 +57,15 @@
 #endif
 
 
+#ifdef CONFIG_MAC80211_MESSAGE_TRACING
+void __sdata_info(bool print, const char *fmt, ...);
+void __wiphy_info(struct wiphy *wiphy, bool print, const char *fmt, ...);
+
+#define _sdata_info(print, sdata, fmt, ...)				\
+	__sdata_info(print, "%s: " fmt, (sdata)->name, ##__VA_ARGS__)
+#define _wiphy_info(print, wiphy, fmt, ...)				\
+	__wiphy_info(wiphy, print, fmt, ##__VA_ARGS__)
+#else
 #define _sdata_info(print, sdata, fmt, ...)				\
 do {									\
 	if (print)							\
@@ -67,6 +77,7 @@ do {									\
 	if (print)							\
 		wiphy_info((wiphy), fmt "\n", ##__VA_ARGS__);		\
 } while (0)
+#endif
 
 #define sdata_info(sdata, fmt, ...)					\
 	_sdata_info(1, sdata, fmt, ##__VA_ARGS__)
diff --git a/net/mac80211/trace.c b/net/mac80211/trace.c
index 943da6e..e61383b 100644
--- a/net/mac80211/trace.c
+++ b/net/mac80211/trace.c
@@ -3,7 +3,43 @@
 
 /* sparse isn't too happy with all macros... */
 #ifndef __CHECKER__
+#include <net/cfg80211.h>
 #include "driver-ops.h"
+#include "debug.h"
 #define CREATE_TRACE_POINTS
 #include "trace.h"
+
+#ifdef CONFIG_MAC80211_MESSAGE_TRACING
+void __sdata_info(bool print, const char *fmt, ...)
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
+		pr_info("%pV\n", &vaf);
+	trace_mac80211_msg(&vaf);
+	va_end(args);
+}
+
+void __wiphy_info(struct wiphy *wiphy, bool print, const char *fmt, ...)
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
+		wiphy_info(wiphy, "%pV\n", &vaf);
+	trace_mac80211_msg(&vaf);
+	va_end(args);
+}
+#endif
 #endif
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 392bcc9..b205aad 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1632,6 +1632,32 @@ TRACE_EVENT(stop_queue,
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
+TRACE_EVENT(mac80211_msg,
+	TP_PROTO(struct va_format *vaf),
+
+	TP_ARGS(vaf),
+
+        TP_STRUCT__entry(
+		__dynamic_array(char, msg, MAX_MSG_LEN)
+        ),
+
+	TP_fast_assign(
+		WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
+				       MAX_MSG_LEN, vaf->fmt,
+				       *vaf->va) >= MAX_MSG_LEN);
+	),
+
+	TP_printk("%s", (char *)__get_dynamic_array(msg))
+);
+#endif
+
 #endif /* !__MAC80211_DRIVER_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
-- 
1.7.10

