Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:53049 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab2L0Lw5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Dec 2012 06:52:57 -0500
Subject: [PATCH 6/7] ath6kl: add tracing support to log functions
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com
Date: Thu, 27 Dec 2012 13:44:52 +0200
Message-ID: <20121227114452.27069.55695.stgit@localhost6.localdomain6> (sfid-20121227_125306_413366_4D4277A9)
In-Reply-To: <20121227114156.27069.30223.stgit@localhost6.localdomain6>
References: <20121227114156.27069.30223.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All log messages are now sent through tracing interface as well if
ATH6KL_TRACING is enabled.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.h |    4 +++
 drivers/net/wireless/ath/ath6kl/trace.c |    3 +++
 drivers/net/wireless/ath/ath6kl/trace.h |   37 +++++++++++++++++++++++++++++++
 3 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.h b/drivers/net/wireless/ath/ath6kl/debug.h
index 06f47f5..b6c7ff1 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.h
+++ b/drivers/net/wireless/ath/ath6kl/debug.h
@@ -19,6 +19,7 @@
 #define DEBUG_H
 
 #include "hif.h"
+#include "trace.h"
 
 enum ATH6K_DEBUG_MASK {
 	ATH6KL_DBG_CREDIT	= BIT(0),
@@ -63,6 +64,7 @@ static inline __printf(1,2) int ath6kl_info(const char *fmt, ...)
 	va_start(args, fmt);
 	vaf.va = &args;
 	ret = ath6kl_printk(KERN_INFO, "%pV", &vaf);
+	trace_ath6kl_log_info(&vaf);
 	va_end(args);
 
 	return ret;
@@ -79,6 +81,7 @@ static inline __printf(1,2) int ath6kl_err(const char *fmt, ...)
 	va_start(args, fmt);
 	vaf.va = &args;
 	ret = ath6kl_printk(KERN_ERR, "%pV", &vaf);
+	trace_ath6kl_log_err(&vaf);
 	va_end(args);
 
 	return ret;
@@ -95,6 +98,7 @@ static inline __printf(1,2) int ath6kl_warn(const char *fmt, ...)
 	va_start(args, fmt);
 	vaf.va = &args;
 	ret = ath6kl_printk(KERN_WARNING, "%pV", &vaf);
+	trace_ath6kl_log_warn(&vaf);
 	va_end(args);
 
 	return ret;
diff --git a/drivers/net/wireless/ath/ath6kl/trace.c b/drivers/net/wireless/ath/ath6kl/trace.c
index adc74a0..68eece7 100644
--- a/drivers/net/wireless/ath/ath6kl/trace.c
+++ b/drivers/net/wireless/ath/ath6kl/trace.c
@@ -21,3 +21,6 @@
 
 EXPORT_TRACEPOINT_SYMBOL(ath6kl_sdio_wr);
 EXPORT_TRACEPOINT_SYMBOL(ath6kl_sdio_rd);
+EXPORT_TRACEPOINT_SYMBOL(ath6kl_log_info);
+EXPORT_TRACEPOINT_SYMBOL(ath6kl_log_warn);
+EXPORT_TRACEPOINT_SYMBOL(ath6kl_log_err);
diff --git a/drivers/net/wireless/ath/ath6kl/trace.h b/drivers/net/wireless/ath/ath6kl/trace.h
index f5838e0..8278143 100644
--- a/drivers/net/wireless/ath/ath6kl/trace.h
+++ b/drivers/net/wireless/ath/ath6kl/trace.h
@@ -24,6 +24,11 @@ static inline unsigned int ath6kl_get_wmi_id(void *buf, size_t buf_len)
 #undef TRACE_EVENT
 #define TRACE_EVENT(name, proto, ...) \
 static inline void trace_ ## name(proto) {}
+#undef DECLARE_EVENT_CLASS
+#define DECLARE_EVENT_CLASS(...)
+#undef DEFINE_EVENT
+#define DEFINE_EVENT(evt_class, name, proto, ...) \
+static inline void trace_ ## name(proto) {}
 #endif /* !CONFIG_ATH6KL_TRACING || __CHECKER__ */
 
 #undef TRACE_SYSTEM
@@ -192,6 +197,38 @@ TRACE_EVENT(ath6kl_htc_tx,
 	)
 );
 
+#define ATH6KL_MSG_MAX 200
+
+DECLARE_EVENT_CLASS(ath6kl_log_event,
+	TP_PROTO(struct va_format *vaf),
+	TP_ARGS(vaf),
+	TP_STRUCT__entry(
+		__dynamic_array(char, msg, ATH6KL_MSG_MAX)
+	),
+	TP_fast_assign(
+		WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
+				       ATH6KL_MSG_MAX,
+				       vaf->fmt,
+				       *vaf->va) >= ATH6KL_MSG_MAX);
+	),
+	TP_printk("%s", __get_str(msg))
+);
+
+DEFINE_EVENT(ath6kl_log_event, ath6kl_log_err,
+	     TP_PROTO(struct va_format *vaf),
+	     TP_ARGS(vaf)
+);
+
+DEFINE_EVENT(ath6kl_log_event, ath6kl_log_warn,
+	     TP_PROTO(struct va_format *vaf),
+	     TP_ARGS(vaf)
+);
+
+DEFINE_EVENT(ath6kl_log_event, ath6kl_log_info,
+	     TP_PROTO(struct va_format *vaf),
+	     TP_ARGS(vaf)
+);
+
 #endif /* _ ATH6KL_TRACE_H || TRACE_HEADER_MULTI_READ*/
 
 /* we don't want to use include/trace/events */

