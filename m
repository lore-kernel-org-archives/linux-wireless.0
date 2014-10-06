Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:24769 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbaJFN0F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2014 09:26:05 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/4] ath10k: add tracepoint for wmi mgmt tx frames
Date: Mon, 6 Oct 2014 18:57:01 +0530
Message-ID: <1412602024-31706-2-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20141006_152609_769241_1BC5F2E3)
In-Reply-To: <1412602024-31706-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1412602024-31706-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

Although frame contents were printed via dbg_dump
already it was not possible to easily filter them
out for processing.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/trace.h | 27 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c   |  1 +
 2 files changed, 28 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/trace.h b/drivers/net/wireless/ath/ath10k/trace.h
index 33b9bf4..04236d6 100644
--- a/drivers/net/wireless/ath/ath10k/trace.h
+++ b/drivers/net/wireless/ath/ath10k/trace.h
@@ -370,6 +370,33 @@ TRACE_EVENT(ath10k_txrx_tx_unref,
 		__entry->msdu_id
 	 )
 );
+
+TRACE_EVENT(ath10k_wmi_mgmt_tx,
+	    TP_PROTO(struct ath10k *ar, void *data, size_t len),
+
+	TP_ARGS(ar, data, len),
+
+	TP_STRUCT__entry(
+		__string(device, dev_name(ar->dev))
+		__string(driver, dev_driver_string(ar->dev))
+		__field(size_t, len)
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
+		"%s %s len %zu\n",
+		__get_str(driver),
+		__get_str(device),
+		__entry->len
+	)
+);
 #endif /* _TRACE_H_ || TRACE_HEADER_MULTI_READ*/
 
 /* we don't want to use include/trace/events */
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index c145b98..6cf4bfc 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -834,6 +834,7 @@ int ath10k_wmi_mgmt_tx(struct ath10k *ar, struct sk_buff *skb)
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi mgmt tx skb %p len %d ftype %02x stype %02x\n",
 		   wmi_skb, wmi_skb->len, fc & IEEE80211_FCTL_FTYPE,
 		   fc & IEEE80211_FCTL_STYPE);
+	trace_ath10k_wmi_mgmt_tx(ar, skb->data, skb->len);
 
 	/* Send the management frame buffer to the target */
 	ret = ath10k_wmi_cmd_send(ar, wmi_skb, ar->wmi.cmd->mgmt_tx_cmdid);
-- 
2.1.2

