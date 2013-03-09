Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:58677 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143Ab3CINFK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Mar 2013 08:05:10 -0500
Subject: [PATCH v2 1/7] ath6kl: add tracing support and tracing points for wmi
 packets
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org
Date: Sat, 09 Mar 2013 15:05:06 +0200
Message-ID: <20130309130506.13371.70928.stgit@localhost6.localdomain6> (sfid-20130309_140522_150952_F3EA73C9)
In-Reply-To: <20130309130223.13371.75809.stgit@localhost6.localdomain6>
References: <20130309130223.13371.75809.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add basic tracing infrastructure support to ath6kl and which can be
enabled with CONFIG_ATH6KL_TRACING.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/Kconfig  |    9 +++
 drivers/net/wireless/ath/ath6kl/Makefile |    5 ++
 drivers/net/wireless/ath/ath6kl/trace.c  |   18 ++++++
 drivers/net/wireless/ath/ath6kl/trace.h  |   87 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/txrx.c   |    3 +
 drivers/net/wireless/ath/ath6kl/wmi.c    |    3 +
 6 files changed, 125 insertions(+)
 create mode 100644 drivers/net/wireless/ath/ath6kl/trace.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/trace.h

diff --git a/drivers/net/wireless/ath/ath6kl/Kconfig b/drivers/net/wireless/ath/ath6kl/Kconfig
index 630c83d..e39e586 100644
--- a/drivers/net/wireless/ath/ath6kl/Kconfig
+++ b/drivers/net/wireless/ath/ath6kl/Kconfig
@@ -30,6 +30,15 @@ config ATH6KL_DEBUG
 	---help---
 	  Enables debug support
 
+config ATH6KL_TRACING
+	bool "Atheros ath6kl tracing support"
+	depends on ATH6KL
+	depends on EVENT_TRACING
+	---help---
+	  Select this to ath6kl use tracing infrastructure.
+
+	  If unsure, say Y to make it easier to debug problems.
+
 config ATH6KL_REGDOMAIN
 	bool "Atheros ath6kl regdomain support"
 	depends on ATH6KL
diff --git a/drivers/net/wireless/ath/ath6kl/Makefile b/drivers/net/wireless/ath/ath6kl/Makefile
index cab0ec0..dc2b3b4 100644
--- a/drivers/net/wireless/ath/ath6kl/Makefile
+++ b/drivers/net/wireless/ath/ath6kl/Makefile
@@ -35,10 +35,15 @@ ath6kl_core-y += txrx.o
 ath6kl_core-y += wmi.o
 ath6kl_core-y += core.o
 ath6kl_core-y += recovery.o
+
 ath6kl_core-$(CONFIG_NL80211_TESTMODE) += testmode.o
+ath6kl_core-$(CONFIG_ATH6KL_TRACING) += trace.o
 
 obj-$(CONFIG_ATH6KL_SDIO) += ath6kl_sdio.o
 ath6kl_sdio-y += sdio.o
 
 obj-$(CONFIG_ATH6KL_USB) += ath6kl_usb.o
 ath6kl_usb-y += usb.o
+
+# for tracing framework to find trace.h
+CFLAGS_trace.o := -I$(src)
diff --git a/drivers/net/wireless/ath/ath6kl/trace.c b/drivers/net/wireless/ath/ath6kl/trace.c
new file mode 100644
index 0000000..4118a29
--- /dev/null
+++ b/drivers/net/wireless/ath/ath6kl/trace.c
@@ -0,0 +1,18 @@
+/*
+ * Copyright (c) 2012 Qualcomm Atheros, Inc.
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
+#define CREATE_TRACE_POINTS
+#include "trace.h"
diff --git a/drivers/net/wireless/ath/ath6kl/trace.h b/drivers/net/wireless/ath/ath6kl/trace.h
new file mode 100644
index 0000000..0787619
--- /dev/null
+++ b/drivers/net/wireless/ath/ath6kl/trace.h
@@ -0,0 +1,87 @@
+#if !defined(_ATH6KL_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
+
+#include <net/cfg80211.h>
+#include <linux/skbuff.h>
+#include <linux/tracepoint.h>
+#include "wmi.h"
+
+#if !defined(_ATH6KL_TRACE_H)
+static inline unsigned int ath6kl_get_wmi_id(void *buf, size_t buf_len)
+{
+	struct wmi_cmd_hdr *hdr = buf;
+
+	if (buf_len < sizeof(*hdr))
+		return 0;
+
+	return le16_to_cpu(hdr->cmd_id);
+}
+#endif /* __ATH6KL_TRACE_H */
+
+#define _ATH6KL_TRACE_H
+
+/* create empty functions when tracing is disabled */
+#if !defined(CONFIG_ATH6KL_TRACING)
+#undef TRACE_EVENT
+#define TRACE_EVENT(name, proto, ...) \
+static inline void trace_ ## name(proto) {}
+#endif /* !CONFIG_ATH6KL_TRACING || __CHECKER__ */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM ath6kl
+
+TRACE_EVENT(ath6kl_wmi_cmd,
+	TP_PROTO(void *buf, size_t buf_len),
+
+	TP_ARGS(buf, buf_len),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, id)
+		__field(size_t, buf_len)
+		__dynamic_array(u8, buf, buf_len)
+	),
+
+	TP_fast_assign(
+		__entry->id = ath6kl_get_wmi_id(buf, buf_len);
+		__entry->buf_len = buf_len;
+		memcpy(__get_dynamic_array(buf), buf, buf_len);
+	),
+
+	TP_printk(
+		"id %d len %d",
+		__entry->id, __entry->buf_len
+	)
+);
+
+TRACE_EVENT(ath6kl_wmi_event,
+	TP_PROTO(void *buf, size_t buf_len),
+
+	TP_ARGS(buf, buf_len),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, id)
+		__field(size_t, buf_len)
+		__dynamic_array(u8, buf, buf_len)
+	),
+
+	TP_fast_assign(
+		__entry->id = ath6kl_get_wmi_id(buf, buf_len);
+		__entry->buf_len = buf_len;
+		memcpy(__get_dynamic_array(buf), buf, buf_len);
+	),
+
+	TP_printk(
+		"id %d len %d",
+		__entry->id, __entry->buf_len
+	)
+);
+
+#endif /* _ ATH6KL_TRACE_H || TRACE_HEADER_MULTI_READ*/
+
+/* we don't want to use include/trace/events */
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE trace
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 78b3692..43dbdaa 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -20,6 +20,7 @@
 #include "core.h"
 #include "debug.h"
 #include "htc-ops.h"
+#include "trace.h"
 
 /*
  * tid - tid_mux0..tid_mux3
@@ -288,6 +289,8 @@ int ath6kl_control_tx(void *devt, struct sk_buff *skb,
 	int status = 0;
 	struct ath6kl_cookie *cookie = NULL;
 
+	trace_ath6kl_wmi_cmd(skb->data, skb->len);
+
 	if (WARN_ON_ONCE(ar->state == ATH6KL_STATE_WOW)) {
 		dev_kfree_skb(skb);
 		return -EACCES;
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index d76b5bd..31a3081 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -20,6 +20,7 @@
 #include "core.h"
 #include "debug.h"
 #include "testmode.h"
+#include "trace.h"
 #include "../regd.h"
 #include "../regd_common.h"
 
@@ -4086,6 +4087,8 @@ int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
 		return -EINVAL;
 	}
 
+	trace_ath6kl_wmi_event(skb->data, skb->len);
+
 	return ath6kl_wmi_proc_events(wmi, skb);
 }
 

