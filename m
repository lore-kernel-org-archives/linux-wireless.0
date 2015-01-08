Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:49220 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756371AbbAHLSh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2015 06:18:37 -0500
Received: by mail-we0-f179.google.com with SMTP id q59so1876802wes.10
        for <linux-wireless@vger.kernel.org>; Thu, 08 Jan 2015 03:18:36 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/2] ath10k: implement diag event
Date: Thu,  8 Jan 2015 12:18:17 +0100
Message-Id: <1420715897-18706-3-git-send-email-michal.kazior@tieto.com> (sfid-20150108_121842_124089_CA535BF2)
In-Reply-To: <1420715897-18706-1-git-send-email-michal.kazior@tieto.com>
References: <1420715897-18706-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some firmware revisions may report this event as
part of their diagnostics.

This avoids `unknown event` warnings and adds
tracing for the event.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/trace.h   | 27 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 31 +++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/trace.h b/drivers/net/wireless/ath/ath10k/trace.h
index 1c541f7..5407887 100644
--- a/drivers/net/wireless/ath/ath10k/trace.h
+++ b/drivers/net/wireless/ath/ath10k/trace.h
@@ -494,6 +494,33 @@ TRACE_EVENT(ath10k_wmi_diag_container,
 	)
 );
 
+TRACE_EVENT(ath10k_wmi_diag,
+	    TP_PROTO(struct ath10k *ar, const void *data, size_t len),
+
+	TP_ARGS(ar, data, len),
+
+	TP_STRUCT__entry(
+		__string(device, dev_name(ar->dev))
+		__string(driver, dev_driver_string(ar->dev))
+		__field(u16, len)
+		__dynamic_array(u8, data, len)
+	),
+
+	TP_fast_assign(
+		__assign_str(device, dev_name(ar->dev));
+		__assign_str(driver, dev_driver_string(ar->dev));
+		__entry->len = len;
+		memcpy(__get_dynamic_array(data), data, len);
+	),
+
+	TP_printk(
+		"%s %s tlv diag len %d",
+		__get_str(driver),
+		__get_str(device),
+		__entry->len
+	)
+);
+
 #endif /* _TRACE_H_ || TRACE_HEADER_MULTI_READ*/
 
 /* we don't want to use include/trace/events */
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 46a9f50..a2ad886 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -224,6 +224,34 @@ static int ath10k_wmi_tlv_event_diag_data(struct ath10k *ar,
 	return 0;
 }
 
+static int ath10k_wmi_tlv_event_diag(struct ath10k *ar,
+				     struct sk_buff *skb)
+{
+	const void **tb;
+	const void *data;
+	int ret, len;
+
+	tb = ath10k_wmi_tlv_parse_alloc(ar, skb->data, skb->len, GFP_ATOMIC);
+	if (IS_ERR(tb)) {
+		ret = PTR_ERR(tb);
+		ath10k_warn(ar, "failed to parse tlv: %d\n", ret);
+		return ret;
+	}
+
+	data = tb[WMI_TLV_TAG_ARRAY_BYTE];
+	if (!data) {
+		kfree(tb);
+		return -EPROTO;
+	}
+	len = ath10k_wmi_tlv_len(data);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi tlv diag event len %d\n", len);
+	trace_ath10k_wmi_diag(ar, data, len);
+
+	kfree(tb);
+	return 0;
+}
+
 /***********/
 /* TLV ops */
 /***********/
@@ -339,6 +367,9 @@ static void ath10k_wmi_tlv_op_rx(struct ath10k *ar, struct sk_buff *skb)
 	case WMI_TLV_DIAG_DATA_CONTAINER_EVENTID:
 		ath10k_wmi_tlv_event_diag_data(ar, skb);
 		break;
+	case WMI_TLV_DIAG_EVENTID:
+		ath10k_wmi_tlv_event_diag(ar, skb);
+		break;
 	default:
 		ath10k_warn(ar, "Unknown eventid: %d\n", id);
 		break;
-- 
1.8.5.3

