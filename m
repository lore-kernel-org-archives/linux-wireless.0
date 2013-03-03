Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1547 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983Ab3CCLpw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Mar 2013 06:45:52 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 02/13] brcmfmac: introduce tracepoints for message
 logging
Date: Sun, 3 Mar 2013 12:45:21 +0100
Message-ID: <1362311132-29561-3-git-send-email-arend@broadcom.com> (sfid-20130303_124557_868305_0D2CEB77)
In-Reply-To: <1362311132-29561-1-git-send-email-arend@broadcom.com>
References: <1362311132-29561-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Inspired by tracing functionality added by Seth Forshee in the
brcmsmac driver, this patch adds similar functionality to brcmfmac.

Reviewed-by: Piotr Haber <phaber@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/Makefile   |    2 +
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |   33 ++++++++
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c  |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h  |   21 +++--
 .../net/wireless/brcm80211/brcmfmac/tracepoint.c   |   22 +++++
 .../net/wireless/brcm80211/brcmfmac/tracepoint.h   |   87 ++++++++++++++++++++
 6 files changed, 159 insertions(+), 7 deletions(-)
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/tracepoint.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/tracepoint.h

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/Makefile b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
index 756e19f..7428273 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/Makefile
+++ b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
@@ -39,3 +39,5 @@ brcmfmac-$(CONFIG_BRCMFMAC_USB) += \
 		usb.o
 brcmfmac-$(CONFIG_BRCMDBG) += \
 		dhd_dbg.o
+brcmfmac-$(CONFIG_BRCM_TRACING) += \
+		tracepoint.o
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index 4544342..be0787c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -24,6 +24,7 @@
 #include "dhd_proto.h"
 #include "dhd_dbg.h"
 #include "fwil.h"
+#include "tracepoint.h"
 
 #define PKTFILTER_BUF_SIZE		128
 #define BRCMF_ARPOL_MODE		0xb	/* agent|snoop|peer_autoreply */
@@ -373,3 +374,35 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 done:
 	return err;
 }
+
+#ifdef CONFIG_BRCM_TRACING
+void __brcmf_err(const char *func, const char *fmt, ...)
+{
+	struct va_format vaf = {
+		.fmt = fmt,
+	};
+	va_list args;
+
+	va_start(args, fmt);
+	vaf.va = &args;
+	pr_err("%s: %pV", func, &vaf);
+	trace_brcmf_err(func, &vaf);
+	va_end(args);
+}
+#endif
+#if defined(CONFIG_BRCM_TRACING) || defined(CONFIG_BRCMDBG)
+void __brcmf_dbg(u32 level, const char *func, const char *fmt, ...)
+{
+	struct va_format vaf = {
+		.fmt = fmt,
+	};
+	va_list args;
+
+	va_start(args, fmt);
+	vaf.va = &args;
+	if (brcmf_msg_level & level)
+		pr_debug("%s %pV", func, &vaf);
+	trace_brcmf_dbg(level, func, &vaf);
+	va_end(args);
+}
+#endif
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
index 57671ed..50f2938 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
@@ -22,6 +22,7 @@
 #include "dhd.h"
 #include "dhd_bus.h"
 #include "dhd_dbg.h"
+#include "tracepoint.h"
 
 static struct dentry *root_folder;
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
index bc013cb..0a1806f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
@@ -43,6 +43,7 @@
  * debugging is not selected. When debugging the driver error
  * messages are as important as other tracing or even more so.
  */
+#ifndef CONFIG_BRCM_TRACING
 #ifdef CONFIG_BRCMDBG
 #define brcmf_err(fmt, ...)	pr_err("%s: " fmt, __func__, ##__VA_ARGS__)
 #else
@@ -52,15 +53,21 @@
 			pr_err("%s: " fmt, __func__, ##__VA_ARGS__);	\
 	} while (0)
 #endif
+#else
+__printf(2, 3)
+void __brcmf_err(const char *func, const char *fmt, ...);
+#define brcmf_err(fmt, ...) \
+	__brcmf_err(__func__, fmt, ##__VA_ARGS__)
+#endif
 
-#if defined(DEBUG)
-
+#if defined(DEBUG) || defined(CONFIG_BRCM_TRACING)
+__printf(3, 4)
+void __brcmf_dbg(u32 level, const char *func, const char *fmt, ...);
 #define brcmf_dbg(level, fmt, ...)				\
 do {								\
-	if (brcmf_msg_level & BRCMF_##level##_VAL)		\
-		pr_debug("%s: " fmt, __func__, ##__VA_ARGS__);	\
+	__brcmf_dbg(BRCMF_##level##_VAL, __func__,		\
+		    fmt, ##__VA_ARGS__);			\
 } while (0)
-
 #define BRCMF_DATA_ON()		(brcmf_msg_level & BRCMF_DATA_VAL)
 #define BRCMF_CTL_ON()		(brcmf_msg_level & BRCMF_CTL_VAL)
 #define BRCMF_HDRS_ON()		(brcmf_msg_level & BRCMF_HDRS_VAL)
@@ -69,7 +76,7 @@ do {								\
 #define BRCMF_EVENT_ON()	(brcmf_msg_level & BRCMF_EVENT_VAL)
 #define BRCMF_FIL_ON()		(brcmf_msg_level & BRCMF_FIL_VAL)
 
-#else	/* (defined DEBUG) || (defined DEBUG) */
+#else /* defined(DEBUG) || defined(CONFIG_BRCM_TRACING) */
 
 #define brcmf_dbg(level, fmt, ...) no_printk(fmt, ##__VA_ARGS__)
 
@@ -81,7 +88,7 @@ do {								\
 #define BRCMF_EVENT_ON()	0
 #define BRCMF_FIL_ON()		0
 
-#endif				/* defined(DEBUG) */
+#endif /* defined(DEBUG) || defined(CONFIG_BRCM_TRACING) */
 
 #define brcmf_dbg_hex_dump(test, data, len, fmt, ...)			\
 do {									\
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/tracepoint.c b/drivers/net/wireless/brcm80211/brcmfmac/tracepoint.c
new file mode 100644
index 0000000..b505db4
--- /dev/null
+++ b/drivers/net/wireless/brcm80211/brcmfmac/tracepoint.c
@@ -0,0 +1,22 @@
+/*
+ * Copyright (c) 2012 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/module.h> /* bug in tracepoint.h, it should include this */
+
+#ifndef __CHECKER__
+#define CREATE_TRACE_POINTS
+#include "tracepoint.h"
+#endif
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/tracepoint.h b/drivers/net/wireless/brcm80211/brcmfmac/tracepoint.h
new file mode 100644
index 0000000..35efc7a
--- /dev/null
+++ b/drivers/net/wireless/brcm80211/brcmfmac/tracepoint.h
@@ -0,0 +1,87 @@
+/*
+ * Copyright (c) 2013 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#if !defined(BRCMF_TRACEPOINT_H_) || defined(TRACE_HEADER_MULTI_READ)
+#define BRCMF_TRACEPOINT_H_
+
+#include <linux/types.h>
+#include <linux/tracepoint.h>
+
+#ifndef CONFIG_BRCM_TRACING
+
+#undef TRACE_EVENT
+#define TRACE_EVENT(name, proto, ...) \
+static inline void trace_ ## name(proto) {}
+
+#undef DECLARE_EVENT_CLASS
+#define DECLARE_EVENT_CLASS(...)
+
+#undef DEFINE_EVENT
+#define DEFINE_EVENT(evt_class, name, proto, ...) \
+static inline void trace_ ## name(proto) {}
+
+#endif /* CONFIG_BRCM_TRACING */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM	brcmfmac
+
+#define MAX_MSG_LEN		100
+
+TRACE_EVENT(brcmf_err,
+	TP_PROTO(const char *func, struct va_format *vaf),
+	TP_ARGS(func, vaf),
+	TP_STRUCT__entry(
+		__string(func, func)
+		__dynamic_array(char, msg, MAX_MSG_LEN)
+	),
+	TP_fast_assign(
+		__assign_str(func, func);
+		WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
+				       MAX_MSG_LEN, vaf->fmt,
+				       *vaf->va) >= MAX_MSG_LEN);
+	),
+	TP_printk("%s: %s", __get_str(func), __get_str(msg))
+);
+
+TRACE_EVENT(brcmf_dbg,
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
+#ifdef CONFIG_BRCM_TRACING
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE tracepoint
+
+#include <trace/define_trace.h>
+
+#endif /* CONFIG_BRCM_TRACING */
+
+#endif /* BRCMF_TRACEPOINT_H_ */
-- 
1.7.6


