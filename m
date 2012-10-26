Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:34552 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933290Ab2JZOYG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 10:24:06 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 08/18] brcmsmac: Add support for writing debug messages to the trace buffer
Date: Fri, 26 Oct 2012 09:23:23 -0500
Message-Id: <1351261413-20821-9-git-send-email-seth.forshee@canonical.com> (sfid-20121026_162413_117798_2A080173)
In-Reply-To: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
References: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a new brcmsmac_msg trace system to enable writing of debug messages
to the trace buffer, and add BRCMS_* macros for storing device debug
messages in the trace buffer in addition to the printk log buffer.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/Makefile   |    3 +-
 .../net/wireless/brcm80211/brcmsmac/brcms_debug.c  |   44 +++++++++++++
 .../net/wireless/brcm80211/brcmsmac/brcms_debug.h  |   40 ++++++++++++
 .../brcm80211/brcmsmac/brcms_trace_events.h        |   68 +++++++++++++++++++-
 4 files changed, 151 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/brcms_debug.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/brcms_debug.h

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/Makefile b/drivers/net/wireless/brcm80211/brcmsmac/Makefile
index e227c4c..4126023 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/Makefile
+++ b/drivers/net/wireless/brcm80211/brcmsmac/Makefile
@@ -40,7 +40,8 @@ BRCMSMAC_OFILES := \
 	phy/phytbl_n.o \
 	phy/phy_qmath.o \
 	dma.o \
-	brcms_trace_events.o
+	brcms_trace_events.o \
+	brcms_debug.o
 
 MODULEPFX := brcmsmac
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/brcms_debug.c b/drivers/net/wireless/brcm80211/brcmsmac/brcms_debug.c
new file mode 100644
index 0000000..11ea96c
--- /dev/null
+++ b/drivers/net/wireless/brcm80211/brcmsmac/brcms_debug.c
@@ -0,0 +1,44 @@
+#include <linux/net.h>
+#include "types.h"
+#include "brcms_debug.h"
+#include "brcms_trace_events.h"
+
+#define __brcms_fn(fn)						\
+void __brcms_ ##fn(struct device *dev, const char *fmt, ...)	\
+{								\
+	struct va_format vaf = {				\
+		.fmt = fmt,					\
+	};							\
+	va_list args;						\
+								\
+	va_start(args, fmt);					\
+	vaf.va = &args;						\
+	dev_ ##fn(dev, "%pV", &vaf);				\
+	trace_brcms_ ##fn(&vaf);				\
+	va_end(args);						\
+}
+
+__brcms_fn(info)
+__brcms_fn(warn)
+__brcms_fn(err)
+__brcms_fn(crit)
+
+#if defined(CONFIG_BRCMDBG) || defined(CONFIG_BRCM_TRACING)
+void __brcms_dbg(struct device *dev, u32 level, const char *func,
+		 const char *fmt, ...)
+{
+	struct va_format vaf = {
+		.fmt = fmt,
+	};
+	va_list args;
+
+	va_start(args, fmt);
+	vaf.va = &args;
+#ifdef CONFIG_BRCMDBG
+	if (brcm_have_debug_level(level) && net_ratelimit())
+		dev_err(dev, "%s %pV", func, &vaf);
+#endif
+	trace_brcms_dbg(level, func, &vaf);
+	va_end(args);
+}
+#endif
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/brcms_debug.h b/drivers/net/wireless/brcm80211/brcmsmac/brcms_debug.h
new file mode 100644
index 0000000..ab7f516
--- /dev/null
+++ b/drivers/net/wireless/brcm80211/brcmsmac/brcms_debug.h
@@ -0,0 +1,40 @@
+#ifndef _BRCMS_DEBUG_H_
+#define _BRCMS_DEBUG_H_
+
+#include <linux/device.h>
+#include <linux/bcma/bcma.h>
+#include <net/cfg80211.h>
+#include <net/mac80211.h>
+#include "main.h"
+#include "mac80211_if.h"
+
+void __brcms_info(struct device *dev, const char *fmt, ...);
+void __brcms_warn(struct device *dev, const char *fmt, ...);
+void __brcms_err(struct device *dev, const char *fmt, ...);
+void __brcms_crit(struct device *dev, const char *fmt, ...);
+
+#if defined(CONFIG_BRCMDBG) || defined(CONFIG_BRCM_TRACING)
+void __brcms_dbg(struct device *dev, u32 level, const char *func,
+		 const char *fmt, ...);
+#else
+static inline void __brcms_dbg(struct device *dev, u32 level,
+			       const char *func, const char *fmt, ...)
+{
+}
+#endif
+
+/*
+ * Debug macros cannot be used when wlc is uninitialized. Generally
+ * this means any code that could run before brcms_c_attach() has
+ * returned successfully probably shouldn't use the following macros.
+ */
+
+#define BRCMS_DBG(core, l, f, a...)	__brcms_dbg(&(core)->dev, l, __func__, f, ##a)
+#define BRCMS_INFO(core, f, a...)	__brcms_info(&(core)->dev, f, ##a)
+#define BRCMS_WARN(core, f, a...)	__brcms_warn(&(core)->dev, f, ##a)
+#define BRCMS_ERR(core, f, a...)	__brcms_err(&(core)->dev, f, ##a)
+#define BRCMS_CRIT(core, f, a...)	__brcms_crit(&(core)->dev, f, ##a)
+
+#define BRCMS_DBG_INFO(core, f, a...)	BRCMS_DBG(core, BRCM_DL_INFO, f, ##a)
+
+#endif /* _BRCMS_DEBUG_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_events.h b/drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_events.h
index bcf6969..a9aed1f 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_events.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/brcms_trace_events.h
@@ -14,9 +14,6 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM brcmsmac
-
 #if !defined(__TRACE_BRCMSMAC_H) || defined(TRACE_HEADER_MULTI_READ)
 
 #define __TRACE_BRCMSMAC_H
@@ -28,8 +25,16 @@
 #undef TRACE_EVENT
 #define TRACE_EVENT(name, proto, ...) \
 static inline void trace_ ## name(proto) {}
+#undef DECLARE_EVENT_CLASS
+#define DECLARE_EVENT_CLASS(...)
+#undef DEFINE_EVENT
+#define DEFINE_EVENT(evt_class, name, proto, ...) \
+static inline void trace_ ## name(proto) {}
 #endif
 
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM brcmsmac
+
 /*
  * We define a tracepoint, its arguments, its printk format and its
  * 'fast binary record' layout.
@@ -78,6 +83,63 @@ TRACE_EVENT(brcms_dpc,
 	)
 );
 
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM brcmsmac_msg
+
+#define MAX_MSG_LEN	100
+
+DECLARE_EVENT_CLASS(brcms_msg_event,
+	TP_PROTO(struct va_format *vaf),
+	TP_ARGS(vaf),
+	TP_STRUCT__entry(
+		__dynamic_array(char, msg, MAX_MSG_LEN)
+	),
+	TP_fast_assign(
+		WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
+				       MAX_MSG_LEN, vaf->fmt,
+				       *vaf->va) >= MAX_MSG_LEN);
+	),
+	TP_printk("%s", __get_str(msg))
+);
+
+DEFINE_EVENT(brcms_msg_event, brcms_info,
+	TP_PROTO(struct va_format *vaf),
+	TP_ARGS(vaf)
+);
+
+DEFINE_EVENT(brcms_msg_event, brcms_warn,
+	TP_PROTO(struct va_format *vaf),
+	TP_ARGS(vaf)
+);
+
+DEFINE_EVENT(brcms_msg_event, brcms_err,
+	TP_PROTO(struct va_format *vaf),
+	TP_ARGS(vaf)
+);
+
+DEFINE_EVENT(brcms_msg_event, brcms_crit,
+	TP_PROTO(struct va_format *vaf),
+	TP_ARGS(vaf)
+);
+
+TRACE_EVENT(brcms_dbg,
+	TP_PROTO(u32 level, const char *func, struct va_format *vaf),
+	TP_ARGS(level, func, vaf),
+	TP_STRUCT__entry(
+		__field(u32, level)
+		__string(func, func)
+		__dynamic_array(char, msg, MAX_MSG_LEN)
+	),
+	TP_fast_assign(
+		__entry->level = level;
+		__assign_str(func, func);
+		WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
+				       MAX_MSG_LEN, vaf->fmt,
+				       *vaf->va) >= MAX_MSG_LEN);
+	),
+	TP_printk("%s: %s", __get_str(func), __get_str(msg))
+);
+
 #endif /* __TRACE_BRCMSMAC_H */
 
 #ifdef CONFIG_BRCM_TRACING
-- 
1.7.9.5

