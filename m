Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40557 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbaJBRJP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2014 13:09:15 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH v2 4/4] ath10k: add tracing for tx info
Date: Thu, 2 Oct 2014 22:39:38 +0530
Message-ID: <1412269778-1045-5-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20141002_190920_674470_7EF9E30D)
In-Reply-To: <1412269778-1045-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1412269778-1045-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The tx info such as msdu_id, frame len, vdev id and tid are reported
to user space by tracepoint. This is useful for collecting tx
statistics.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt_tx.c |  1 +
 drivers/net/wireless/ath/ath10k/trace.h  | 60 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/txrx.c   |  1 +
 3 files changed, 62 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index bd87a35..fdfb171 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -557,6 +557,7 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	skb_cb->htt.txbuf->cmd_tx.frags_paddr = __cpu_to_le32(frags_paddr);
 	skb_cb->htt.txbuf->cmd_tx.peerid = __cpu_to_le32(HTT_INVALID_PEERID);
 
+	trace_ath10k_htt_tx(ar, msdu_id, msdu->len, vdev_id, tid);
 	ath10k_dbg(ar, ATH10K_DBG_HTT,
 		   "htt tx flags0 %hhu flags1 %hu len %d id %hu frags_paddr %08x, msdu_paddr %08x vdev %hhu tid %hhu\n",
 		   flags0, flags1, msdu->len, msdu_id, frags_paddr,
diff --git a/drivers/net/wireless/ath/ath10k/trace.h b/drivers/net/wireless/ath/ath10k/trace.h
index 3841667..33b9bf4 100644
--- a/drivers/net/wireless/ath/ath10k/trace.h
+++ b/drivers/net/wireless/ath/ath10k/trace.h
@@ -310,6 +310,66 @@ TRACE_EVENT(ath10k_htt_rx_desc,
 		__entry->len
 	 )
 );
+
+TRACE_EVENT(ath10k_htt_tx,
+	    TP_PROTO(struct ath10k *ar, u16 msdu_id, u16 msdu_len,
+		     u8 vdev_id, u8 tid),
+
+	TP_ARGS(ar, msdu_id, msdu_len, vdev_id, tid),
+
+	TP_STRUCT__entry(
+		__string(device, dev_name(ar->dev))
+		__string(driver, dev_driver_string(ar->dev))
+		__field(u16, msdu_id)
+		__field(u16, msdu_len)
+		__field(u8, vdev_id)
+		__field(u8, tid)
+	),
+
+	TP_fast_assign(
+		__assign_str(device, dev_name(ar->dev));
+		__assign_str(driver, dev_driver_string(ar->dev));
+		__entry->msdu_id = msdu_id;
+		__entry->msdu_len = msdu_len;
+		__entry->vdev_id = vdev_id;
+		__entry->tid = tid;
+	),
+
+	TP_printk(
+		"%s %s msdu_id %d msdu_len %d vdev_id %d tid %d",
+		__get_str(driver),
+		__get_str(device),
+		__entry->msdu_id,
+		__entry->msdu_len,
+		__entry->vdev_id,
+		__entry->tid
+	 )
+);
+
+TRACE_EVENT(ath10k_txrx_tx_unref,
+	    TP_PROTO(struct ath10k *ar, u16 msdu_id),
+
+	TP_ARGS(ar, msdu_id),
+
+	TP_STRUCT__entry(
+		__string(device, dev_name(ar->dev))
+		__string(driver, dev_driver_string(ar->dev))
+		__field(u16, msdu_id)
+	),
+
+	TP_fast_assign(
+		__assign_str(device, dev_name(ar->dev));
+		__assign_str(driver, dev_driver_string(ar->dev));
+		__entry->msdu_id = msdu_id;
+	),
+
+	TP_printk(
+		"%s %s msdu_id %d",
+		__get_str(driver),
+		__get_str(device),
+		__entry->msdu_id
+	 )
+);
 #endif /* _TRACE_H_ || TRACE_HEADER_MULTI_READ*/
 
 /* we don't want to use include/trace/events */
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index a0cbc21..f9c90e3 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -78,6 +78,7 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 
 	info = IEEE80211_SKB_CB(msdu);
 	memset(&info->status, 0, sizeof(info->status));
+	trace_ath10k_txrx_tx_unref(ar, tx_done->msdu_id);
 
 	if (tx_done->discard) {
 		ieee80211_free_txskb(htt->ar->hw, msdu);
-- 
2.1.1

