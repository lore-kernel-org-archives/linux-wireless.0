Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:61377 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbaH1NPg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2014 09:15:36 -0400
Received: by mail-la0-f48.google.com with SMTP id gl10so897041lab.7
        for <linux-wireless@vger.kernel.org>; Thu, 28 Aug 2014 06:15:34 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: add device/driver strings to tracepoints
Date: Thu, 28 Aug 2014 15:05:35 +0200
Message-Id: <1409231135-16233-1-git-send-email-michal.kazior@tieto.com> (sfid-20140828_151545_455937_4AE70BB4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes it easier to log and debug via tracing
with more than 1 ath10k device on a system.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
Not sure if pulling core.h in trace.h and using ar
pointer is the best approach here. Alternative is
to not pull core.h and pass ar->dev directly to
trace functions. Thoughts?

 drivers/net/wireless/ath/ath10k/debug.c  |  10 +--
 drivers/net/wireless/ath/ath10k/htt_rx.c |   2 +-
 drivers/net/wireless/ath/ath10k/trace.h  | 105 +++++++++++++++++++++++--------
 drivers/net/wireless/ath/ath10k/wmi.c    |  10 +--
 4 files changed, 89 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index f3f0a80..d922ef4 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -117,7 +117,7 @@ int ath10k_info(struct ath10k *ar, const char *fmt, ...)
 	va_start(args, fmt);
 	vaf.va = &args;
 	ret = dev_info(ar->dev, "%pV", &vaf);
-	trace_ath10k_log_info(&vaf);
+	trace_ath10k_log_info(ar, &vaf);
 	va_end(args);
 
 	return ret;
@@ -153,7 +153,7 @@ int ath10k_err(struct ath10k *ar, const char *fmt, ...)
 	va_start(args, fmt);
 	vaf.va = &args;
 	ret = dev_err(ar->dev, "%pV", &vaf);
-	trace_ath10k_log_err(&vaf);
+	trace_ath10k_log_err(ar, &vaf);
 	va_end(args);
 
 	return ret;
@@ -170,7 +170,7 @@ int ath10k_warn(struct ath10k *ar, const char *fmt, ...)
 	va_start(args, fmt);
 	vaf.va = &args;
 	dev_warn_ratelimited(ar->dev, "%pV", &vaf);
-	trace_ath10k_log_warn(&vaf);
+	trace_ath10k_log_warn(ar, &vaf);
 
 	va_end(args);
 
@@ -1223,7 +1223,7 @@ void ath10k_dbg(struct ath10k *ar, enum ath10k_debug_mask mask,
 	if (ath10k_debug_mask & mask)
 		dev_printk(KERN_DEBUG, ar->dev, "%pV", &vaf);
 
-	trace_ath10k_log_dbg(mask, &vaf);
+	trace_ath10k_log_dbg(ar, mask, &vaf);
 
 	va_end(args);
 }
@@ -1242,7 +1242,7 @@ void ath10k_dbg_dump(struct ath10k *ar,
 	}
 
 	/* tracing code doesn't like null strings :/ */
-	trace_ath10k_log_dbg_dump(msg ? msg : "", prefix ? prefix : "",
+	trace_ath10k_log_dbg_dump(ar, msg ? msg : "", prefix ? prefix : "",
 				  buf, len);
 }
 EXPORT_SYMBOL(ath10k_dbg_dump);
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 30927b1..57e1fe7 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1654,7 +1654,7 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 		/* FIX THIS */
 		break;
 	case HTT_T2H_MSG_TYPE_STATS_CONF:
-		trace_ath10k_htt_stats(skb->data, skb->len);
+		trace_ath10k_htt_stats(ar, skb->data, skb->len);
 		break;
 	case HTT_T2H_MSG_TYPE_TX_INSPECT_IND:
 		/* Firmware can return tx frames if it's unable to fully
diff --git a/drivers/net/wireless/ath/ath10k/trace.h b/drivers/net/wireless/ath/ath10k/trace.h
index 4eb2ecb..574b75a 100644
--- a/drivers/net/wireless/ath/ath10k/trace.h
+++ b/drivers/net/wireless/ath/ath10k/trace.h
@@ -18,6 +18,7 @@
 #if !defined(_TRACE_H_) || defined(TRACE_HEADER_MULTI_READ)
 
 #include <linux/tracepoint.h>
+#include "core.h"
 
 #define _TRACE_H_
 
@@ -39,59 +40,79 @@ static inline void trace_ ## name(proto) {}
 #define ATH10K_MSG_MAX 200
 
 DECLARE_EVENT_CLASS(ath10k_log_event,
-	TP_PROTO(struct va_format *vaf),
-	TP_ARGS(vaf),
+	TP_PROTO(struct ath10k *ar, struct va_format *vaf),
+	TP_ARGS(ar, vaf),
 	TP_STRUCT__entry(
+		__string(device, dev_name(ar->dev))
+		__string(driver, dev_driver_string(ar->dev))
 		__dynamic_array(char, msg, ATH10K_MSG_MAX)
 	),
 	TP_fast_assign(
+		__assign_str(device, dev_name(ar->dev));
+		__assign_str(driver, dev_driver_string(ar->dev));
 		WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
 				       ATH10K_MSG_MAX,
 				       vaf->fmt,
 				       *vaf->va) >= ATH10K_MSG_MAX);
 	),
-	TP_printk("%s", __get_str(msg))
+	TP_printk(
+		"%s %s %s",
+		__get_str(driver),
+		__get_str(device),
+		__get_str(msg)
+	)
 );
 
 DEFINE_EVENT(ath10k_log_event, ath10k_log_err,
-	     TP_PROTO(struct va_format *vaf),
-	     TP_ARGS(vaf)
+	     TP_PROTO(struct ath10k *ar, struct va_format *vaf),
+	     TP_ARGS(ar, vaf)
 );
 
 DEFINE_EVENT(ath10k_log_event, ath10k_log_warn,
-	     TP_PROTO(struct va_format *vaf),
-	     TP_ARGS(vaf)
+	     TP_PROTO(struct ath10k *ar, struct va_format *vaf),
+	     TP_ARGS(ar, vaf)
 );
 
 DEFINE_EVENT(ath10k_log_event, ath10k_log_info,
-	     TP_PROTO(struct va_format *vaf),
-	     TP_ARGS(vaf)
+	     TP_PROTO(struct ath10k *ar, struct va_format *vaf),
+	     TP_ARGS(ar, vaf)
 );
 
 TRACE_EVENT(ath10k_log_dbg,
-	TP_PROTO(unsigned int level, struct va_format *vaf),
-	TP_ARGS(level, vaf),
+	TP_PROTO(struct ath10k *ar, unsigned int level, struct va_format *vaf),
+	TP_ARGS(ar, level, vaf),
 	TP_STRUCT__entry(
+		__string(device, dev_name(ar->dev))
+		__string(driver, dev_driver_string(ar->dev))
 		__field(unsigned int, level)
 		__dynamic_array(char, msg, ATH10K_MSG_MAX)
 	),
 	TP_fast_assign(
+		__assign_str(device, dev_name(ar->dev));
+		__assign_str(driver, dev_driver_string(ar->dev));
 		__entry->level = level;
 		WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
 				       ATH10K_MSG_MAX,
 				       vaf->fmt,
 				       *vaf->va) >= ATH10K_MSG_MAX);
 	),
-	TP_printk("%s", __get_str(msg))
+	TP_printk(
+		"%s %s %s",
+		__get_str(driver),
+		__get_str(device),
+		__get_str(msg)
+	)
 );
 
 TRACE_EVENT(ath10k_log_dbg_dump,
-	TP_PROTO(const char *msg, const char *prefix,
+	TP_PROTO(struct ath10k *ar, const char *msg, const char *prefix,
 		 const void *buf, size_t buf_len),
 
-	TP_ARGS(msg, prefix, buf, buf_len),
+	TP_ARGS(ar, msg, prefix, buf, buf_len),
 
 	TP_STRUCT__entry(
+		__string(device, dev_name(ar->dev))
+		__string(driver, dev_driver_string(ar->dev))
 		__string(msg, msg)
 		__string(prefix, prefix)
 		__field(size_t, buf_len)
@@ -99,6 +120,8 @@ TRACE_EVENT(ath10k_log_dbg_dump,
 	),
 
 	TP_fast_assign(
+		__assign_str(device, dev_name(ar->dev));
+		__assign_str(driver, dev_driver_string(ar->dev));
 		__assign_str(msg, msg);
 		__assign_str(prefix, prefix);
 		__entry->buf_len = buf_len;
@@ -106,16 +129,22 @@ TRACE_EVENT(ath10k_log_dbg_dump,
 	),
 
 	TP_printk(
-		"%s/%s\n", __get_str(prefix), __get_str(msg)
+		"%s %s %s/%s\n",
+		__get_str(driver),
+		__get_str(device),
+		__get_str(prefix),
+		__get_str(msg)
 	)
 );
 
 TRACE_EVENT(ath10k_wmi_cmd,
-	TP_PROTO(int id, void *buf, size_t buf_len, int ret),
+	TP_PROTO(struct ath10k *ar, int id, void *buf, size_t buf_len, int ret),
 
-	TP_ARGS(id, buf, buf_len, ret),
+	TP_ARGS(ar, id, buf, buf_len, ret),
 
 	TP_STRUCT__entry(
+		__string(device, dev_name(ar->dev))
+		__string(driver, dev_driver_string(ar->dev))
 		__field(unsigned int, id)
 		__field(size_t, buf_len)
 		__dynamic_array(u8, buf, buf_len)
@@ -123,6 +152,8 @@ TRACE_EVENT(ath10k_wmi_cmd,
 	),
 
 	TP_fast_assign(
+		__assign_str(device, dev_name(ar->dev));
+		__assign_str(driver, dev_driver_string(ar->dev));
 		__entry->id = id;
 		__entry->buf_len = buf_len;
 		__entry->ret = ret;
@@ -130,7 +161,9 @@ TRACE_EVENT(ath10k_wmi_cmd,
 	),
 
 	TP_printk(
-		"id %d len %zu ret %d",
+		"%s %s id %d len %zu ret %d",
+		__get_str(driver),
+		__get_str(device),
 		__entry->id,
 		__entry->buf_len,
 		__entry->ret
@@ -138,67 +171,85 @@ TRACE_EVENT(ath10k_wmi_cmd,
 );
 
 TRACE_EVENT(ath10k_wmi_event,
-	TP_PROTO(int id, void *buf, size_t buf_len),
+	TP_PROTO(struct ath10k *ar, int id, void *buf, size_t buf_len),
 
-	TP_ARGS(id, buf, buf_len),
+	TP_ARGS(ar, id, buf, buf_len),
 
 	TP_STRUCT__entry(
+		__string(device, dev_name(ar->dev))
+		__string(driver, dev_driver_string(ar->dev))
 		__field(unsigned int, id)
 		__field(size_t, buf_len)
 		__dynamic_array(u8, buf, buf_len)
 	),
 
 	TP_fast_assign(
+		__assign_str(device, dev_name(ar->dev));
+		__assign_str(driver, dev_driver_string(ar->dev));
 		__entry->id = id;
 		__entry->buf_len = buf_len;
 		memcpy(__get_dynamic_array(buf), buf, buf_len);
 	),
 
 	TP_printk(
-		"id %d len %zu",
+		"%s %s id %d len %zu",
+		__get_str(driver),
+		__get_str(device),
 		__entry->id,
 		__entry->buf_len
 	)
 );
 
 TRACE_EVENT(ath10k_htt_stats,
-	TP_PROTO(void *buf, size_t buf_len),
+	TP_PROTO(struct ath10k *ar, void *buf, size_t buf_len),
 
-	TP_ARGS(buf, buf_len),
+	TP_ARGS(ar, buf, buf_len),
 
 	TP_STRUCT__entry(
+		__string(device, dev_name(ar->dev))
+		__string(driver, dev_driver_string(ar->dev))
 		__field(size_t, buf_len)
 		__dynamic_array(u8, buf, buf_len)
 	),
 
 	TP_fast_assign(
+		__assign_str(device, dev_name(ar->dev));
+		__assign_str(driver, dev_driver_string(ar->dev));
 		__entry->buf_len = buf_len;
 		memcpy(__get_dynamic_array(buf), buf, buf_len);
 	),
 
 	TP_printk(
-		"len %zu",
+		"%s %s len %zu",
+		__get_str(driver),
+		__get_str(device),
 		__entry->buf_len
 	)
 );
 
 TRACE_EVENT(ath10k_wmi_dbglog,
-	TP_PROTO(void *buf, size_t buf_len),
+	TP_PROTO(struct ath10k *ar, void *buf, size_t buf_len),
 
-	TP_ARGS(buf, buf_len),
+	TP_ARGS(ar, buf, buf_len),
 
 	TP_STRUCT__entry(
+		__string(device, dev_name(ar->dev))
+		__string(driver, dev_driver_string(ar->dev))
 		__field(size_t, buf_len)
 		__dynamic_array(u8, buf, buf_len)
 	),
 
 	TP_fast_assign(
+		__assign_str(device, dev_name(ar->dev));
+		__assign_str(driver, dev_driver_string(ar->dev));
 		__entry->buf_len = buf_len;
 		memcpy(__get_dynamic_array(buf), buf, buf_len);
 	),
 
 	TP_printk(
-		"len %zu",
+		"%s %s len %zu",
+		__get_str(driver),
+		__get_str(device),
 		__entry->buf_len
 	)
 );
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index e500a3c..b13ccf6 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -666,7 +666,7 @@ static int ath10k_wmi_cmd_send_nowait(struct ath10k *ar, struct sk_buff *skb,
 
 	memset(skb_cb, 0, sizeof(*skb_cb));
 	ret = ath10k_htc_send(&ar->htc, ar->wmi.eid, skb);
-	trace_ath10k_wmi_cmd(cmd_id, skb->data, skb->len, ret);
+	trace_ath10k_wmi_cmd(ar, cmd_id, skb->data, skb->len, ret);
 
 	if (ret)
 		goto err_pull;
@@ -1288,7 +1288,7 @@ static int ath10k_wmi_event_debug_mesg(struct ath10k *ar, struct sk_buff *skb)
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi event debug mesg len %d\n",
 		   skb->len);
 
-	trace_ath10k_wmi_dbglog(skb->data, skb->len);
+	trace_ath10k_wmi_dbglog(ar, skb->data, skb->len);
 
 	return 0;
 }
@@ -2371,7 +2371,7 @@ static void ath10k_wmi_main_process_rx(struct ath10k *ar, struct sk_buff *skb)
 	if (skb_pull(skb, sizeof(struct wmi_cmd_hdr)) == NULL)
 		return;
 
-	trace_ath10k_wmi_event(id, skb->data, skb->len);
+	trace_ath10k_wmi_event(ar, id, skb->data, skb->len);
 
 	switch (id) {
 	case WMI_MGMT_RX_EVENTID:
@@ -2487,7 +2487,7 @@ static void ath10k_wmi_10x_process_rx(struct ath10k *ar, struct sk_buff *skb)
 	if (skb_pull(skb, sizeof(struct wmi_cmd_hdr)) == NULL)
 		return;
 
-	trace_ath10k_wmi_event(id, skb->data, skb->len);
+	trace_ath10k_wmi_event(ar, id, skb->data, skb->len);
 
 	switch (id) {
 	case WMI_10X_MGMT_RX_EVENTID:
@@ -2594,7 +2594,7 @@ static void ath10k_wmi_10_2_process_rx(struct ath10k *ar, struct sk_buff *skb)
 	if (skb_pull(skb, sizeof(struct wmi_cmd_hdr)) == NULL)
 		return;
 
-	trace_ath10k_wmi_event(id, skb->data, skb->len);
+	trace_ath10k_wmi_event(ar, id, skb->data, skb->len);
 
 	switch (id) {
 	case WMI_10_2_MGMT_RX_EVENTID:
-- 
1.8.5.3

