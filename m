Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:60811 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517Ab3FAL1L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Jun 2013 07:27:11 -0400
Subject: [PATCH v2 24/29] ath10k: add trace.h
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k-devel@qca.qualcomm.com
Date: Sat, 01 Jun 2013 14:27:07 +0300
Message-ID: <20130601112707.32443.53130.stgit@localhost6.localdomain6> (sfid-20130601_132714_896631_701636A1)
In-Reply-To: <20130601111820.32443.46794.stgit@localhost6.localdomain6>
References: <20130601111820.32443.46794.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/trace.h |  170 +++++++++++++++++++++++++++++++
 1 file changed, 170 insertions(+)
 create mode 100644 drivers/net/wireless/ath/ath10k/trace.h

diff --git a/drivers/net/wireless/ath/ath10k/trace.h b/drivers/net/wireless/ath/ath10k/trace.h
new file mode 100644
index 0000000..85e806b
--- /dev/null
+++ b/drivers/net/wireless/ath/ath10k/trace.h
@@ -0,0 +1,170 @@
+/*
+ * Copyright (c) 2005-2011 Atheros Communications Inc.
+ * Copyright (c) 2011-2013 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#if !defined(_TRACE_H_) || defined(TRACE_HEADER_MULTI_READ)
+
+#include <linux/tracepoint.h>
+
+#define _TRACE_H_
+
+/* create empty functions when tracing is disabled */
+#if !defined(CONFIG_ATH10K_TRACING)
+#undef TRACE_EVENT
+#define TRACE_EVENT(name, proto, ...) \
+static inline void trace_ ## name(proto) {}
+#undef DECLARE_EVENT_CLASS
+#define DECLARE_EVENT_CLASS(...)
+#undef DEFINE_EVENT
+#define DEFINE_EVENT(evt_class, name, proto, ...) \
+static inline void trace_ ## name(proto) {}
+#endif /* !CONFIG_ATH10K_TRACING || __CHECKER__ */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM ath10k
+
+#define ATH10K_MSG_MAX 200
+
+DECLARE_EVENT_CLASS(ath10k_log_event,
+	TP_PROTO(struct va_format *vaf),
+	TP_ARGS(vaf),
+	TP_STRUCT__entry(
+		__dynamic_array(char, msg, ATH10K_MSG_MAX)
+	),
+	TP_fast_assign(
+		WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
+				       ATH10K_MSG_MAX,
+				       vaf->fmt,
+				       *vaf->va) >= ATH10K_MSG_MAX);
+	),
+	TP_printk("%s", __get_str(msg))
+);
+
+DEFINE_EVENT(ath10k_log_event, ath10k_log_err,
+	     TP_PROTO(struct va_format *vaf),
+	     TP_ARGS(vaf)
+);
+
+DEFINE_EVENT(ath10k_log_event, ath10k_log_warn,
+	     TP_PROTO(struct va_format *vaf),
+	     TP_ARGS(vaf)
+);
+
+DEFINE_EVENT(ath10k_log_event, ath10k_log_info,
+	     TP_PROTO(struct va_format *vaf),
+	     TP_ARGS(vaf)
+);
+
+TRACE_EVENT(ath10k_log_dbg,
+	TP_PROTO(unsigned int level, struct va_format *vaf),
+	TP_ARGS(level, vaf),
+	TP_STRUCT__entry(
+		__field(unsigned int, level)
+		__dynamic_array(char, msg, ATH10K_MSG_MAX)
+	),
+	TP_fast_assign(
+		__entry->level = level;
+		WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
+				       ATH10K_MSG_MAX,
+				       vaf->fmt,
+				       *vaf->va) >= ATH10K_MSG_MAX);
+	),
+	TP_printk("%s", __get_str(msg))
+);
+
+TRACE_EVENT(ath10k_log_dbg_dump,
+	TP_PROTO(const char *msg, const char *prefix,
+		 const void *buf, size_t buf_len),
+
+	TP_ARGS(msg, prefix, buf, buf_len),
+
+	TP_STRUCT__entry(
+		__string(msg, msg)
+		__string(prefix, prefix)
+		__field(size_t, buf_len)
+		__dynamic_array(u8, buf, buf_len)
+	),
+
+	TP_fast_assign(
+		__assign_str(msg, msg);
+		__assign_str(prefix, prefix);
+		__entry->buf_len = buf_len;
+		memcpy(__get_dynamic_array(buf), buf, buf_len);
+	),
+
+	TP_printk(
+		"%s/%s\n", __get_str(prefix), __get_str(msg)
+	)
+);
+
+TRACE_EVENT(ath10k_wmi_cmd,
+	TP_PROTO(int id, void *buf, size_t buf_len),
+
+	TP_ARGS(id, buf, buf_len),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, id)
+		__field(size_t, buf_len)
+		__dynamic_array(u8, buf, buf_len)
+	),
+
+	TP_fast_assign(
+		__entry->id = id;
+		__entry->buf_len = buf_len;
+		memcpy(__get_dynamic_array(buf), buf, buf_len);
+	),
+
+	TP_printk(
+		"id %d len %zu",
+		__entry->id,
+		__entry->buf_len
+	)
+);
+
+TRACE_EVENT(ath10k_wmi_event,
+	TP_PROTO(int id, void *buf, size_t buf_len),
+
+	TP_ARGS(id, buf, buf_len),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, id)
+		__field(size_t, buf_len)
+		__dynamic_array(u8, buf, buf_len)
+	),
+
+	TP_fast_assign(
+		__entry->id = id;
+		__entry->buf_len = buf_len;
+		memcpy(__get_dynamic_array(buf), buf, buf_len);
+	),
+
+	TP_printk(
+		"id %d len %zu",
+		__entry->id,
+		__entry->buf_len
+	)
+);
+
+#endif /* _TRACE_H_ || TRACE_HEADER_MULTI_READ*/
+
+/* we don't want to use include/trace/events */
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE trace
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>

