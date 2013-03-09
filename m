Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:44874 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197Ab3CINFq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Mar 2013 08:05:46 -0500
Subject: [PATCH v2 6/7] ath6kl: add tracing support to log functions
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org
Date: Sat, 09 Mar 2013 15:05:43 +0200
Message-ID: <20130309130543.13371.23618.stgit@localhost6.localdomain6> (sfid-20130309_140548_759221_C01C8A9C)
In-Reply-To: <20130309130223.13371.75809.stgit@localhost6.localdomain6>
References: <20130309130223.13371.75809.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All log messages are now sent through tracing interface as well if
ATH6KL_TRACING is enabled.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.c |    3 +++
 drivers/net/wireless/ath/ath6kl/debug.h |    1 +
 drivers/net/wireless/ath/ath6kl/trace.h |   37 +++++++++++++++++++++++++++++++
 3 files changed, 41 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 494ecfd..d032e95 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -67,6 +67,7 @@ int ath6kl_info(const char *fmt, ...)
 	va_start(args, fmt);
 	vaf.va = &args;
 	ret = ath6kl_printk(KERN_INFO, "%pV", &vaf);
+	trace_ath6kl_log_info(&vaf);
 	va_end(args);
 
 	return ret;
@@ -84,6 +85,7 @@ int ath6kl_err(const char *fmt, ...)
 	va_start(args, fmt);
 	vaf.va = &args;
 	ret = ath6kl_printk(KERN_ERR, "%pV", &vaf);
+	trace_ath6kl_log_err(&vaf);
 	va_end(args);
 
 	return ret;
@@ -101,6 +103,7 @@ int ath6kl_warn(const char *fmt, ...)
 	va_start(args, fmt);
 	vaf.va = &args;
 	ret = ath6kl_printk(KERN_WARNING, "%pV", &vaf);
+	trace_ath6kl_log_warn(&vaf);
 	va_end(args);
 
 	return ret;
diff --git a/drivers/net/wireless/ath/ath6kl/debug.h b/drivers/net/wireless/ath/ath6kl/debug.h
index 653f2e9..806f4d2 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.h
+++ b/drivers/net/wireless/ath/ath6kl/debug.h
@@ -19,6 +19,7 @@
 #define DEBUG_H
 
 #include "hif.h"
+#include "trace.h"
 
 enum ATH6K_DEBUG_MASK {
 	ATH6KL_DBG_CREDIT	= BIT(0),
diff --git a/drivers/net/wireless/ath/ath6kl/trace.h b/drivers/net/wireless/ath/ath6kl/trace.h
index 306d58d..ea55b2a 100644
--- a/drivers/net/wireless/ath/ath6kl/trace.h
+++ b/drivers/net/wireless/ath/ath6kl/trace.h
@@ -25,6 +25,11 @@ static inline unsigned int ath6kl_get_wmi_id(void *buf, size_t buf_len)
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
@@ -241,6 +246,38 @@ TRACE_EVENT(ath6kl_htc_tx,
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

