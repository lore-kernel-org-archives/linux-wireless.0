Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:16558 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaJFQrN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2014 12:47:13 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 2/2] ath10k: add tracing for frame transmission
Date: Mon, 6 Oct 2014 22:18:38 +0530
Message-ID: <1412614118-17205-2-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20141006_184716_272583_6152BD11)
In-Reply-To: <1412614118-17205-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1412614118-17205-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support to send management and data frames to user space
by tracing for packet inspection.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |  3 +++
 drivers/net/wireless/ath/ath10k/trace.h  | 42 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c    |  2 ++
 3 files changed, 47 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 7add88e..4dbb2dd 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -291,6 +291,9 @@ static inline struct sk_buff *ath10k_htt_rx_netbuf_pop(struct ath10k_htt *htt)
 	htt->rx_ring.sw_rd_idx.msdu_payld = idx;
 	htt->rx_ring.fill_cnt--;
 
+	trace_ath10k_htt_rx_pop_msdu(ar, msdu->data, msdu->len +
+				     skb_tailroom(msdu));
+
 	return msdu;
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/trace.h b/drivers/net/wireless/ath/ath10k/trace.h
index dbf7bc9..8e37573 100644
--- a/drivers/net/wireless/ath/ath10k/trace.h
+++ b/drivers/net/wireless/ath/ath10k/trace.h
@@ -375,6 +375,48 @@ TRACE_EVENT(ath10k_txrx_tx_unref,
 		__entry->msdu_id
 	 )
 );
+
+DECLARE_EVENT_CLASS(ath10k_data_event,
+		    TP_PROTO(struct ath10k *ar, void *data, size_t len),
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
+
+DEFINE_EVENT(ath10k_data_event, ath10k_htt_rx_pop_msdu,
+	     TP_PROTO(struct ath10k *ar, void *data, size_t len),
+	     TP_ARGS(ar, data, len)
+);
+
+DEFINE_EVENT(ath10k_data_event, ath10k_wmi_mgmt_tx,
+	     TP_PROTO(struct ath10k *ar, void *data, size_t len),
+	     TP_ARGS(ar, data, len)
+);
+
+DEFINE_EVENT(ath10k_data_event, ath10k_wmi_bcn_tx,
+	     TP_PROTO(struct ath10k *ar, void *data, size_t len),
+	     TP_ARGS(ar, data, len)
+);
 #endif /* _TRACE_H_ || TRACE_HEADER_MULTI_READ*/
 
 /* we don't want to use include/trace/events */
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index c145b98..54042bf 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -834,6 +834,7 @@ int ath10k_wmi_mgmt_tx(struct ath10k *ar, struct sk_buff *skb)
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi mgmt tx skb %p len %d ftype %02x stype %02x\n",
 		   wmi_skb, wmi_skb->len, fc & IEEE80211_FCTL_FTYPE,
 		   fc & IEEE80211_FCTL_STYPE);
+	trace_ath10k_wmi_mgmt_tx(ar, skb->data, skb->len);
 
 	/* Send the management frame buffer to the target */
 	ret = ath10k_wmi_cmd_send(ar, wmi_skb, ar->wmi.cmd->mgmt_tx_cmdid);
@@ -1892,6 +1893,7 @@ static void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 		arvif->beacon = bcn;
 		arvif->beacon_sent = false;
 
+		trace_ath10k_wmi_bcn_tx(ar, bcn->data, bcn->len);
 		ath10k_wmi_tx_beacon_nowait(arvif);
 skip:
 		spin_unlock_bh(&ar->data_lock);
-- 
2.1.2

