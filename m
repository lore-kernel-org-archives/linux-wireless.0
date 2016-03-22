Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57435 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbcCVLw4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2016 07:52:56 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
	"Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>
Subject: [PATCH 1/9] ath10k: speedup htt rx descriptor processing for tx completion
Date: Tue, 22 Mar 2016 17:22:11 +0530
Message-ID: <1458647539-17213-2-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20160322_125300_118285_36A80B34)
In-Reply-To: <1458647539-17213-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1458647539-17213-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To optimize CPU usage htt rx descriptors will be reused instead of
refilling it for htt rx copy engine (CE5). To support that all htt rx
indications should be processed at same context. FIFO queue is used
to maintain tx completion status for each msdu. This helps to retain
the order of tx completion.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt.h    | 18 ++++++++---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 55 +++++++++++++++++++-------------
 drivers/net/wireless/ath/ath10k/htt_tx.c | 14 +++++++-
 drivers/net/wireless/ath/ath10k/txrx.c   | 12 +++----
 4 files changed, 64 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index d196bcc..76c4bae 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -22,6 +22,7 @@
 #include <linux/interrupt.h>
 #include <linux/dmapool.h>
 #include <linux/hashtable.h>
+#include <linux/kfifo.h>
 #include <net/mac80211.h>
 
 #include "htc.h"
@@ -1526,10 +1527,15 @@ struct htt_resp {
 /*** host side structures follow ***/
 
 struct htt_tx_done {
-	u32 msdu_id;
-	bool discard;
-	bool no_ack;
-	bool success;
+	u16 msdu_id;
+	u16 status;
+};
+
+enum htt_tx_compl_state {
+	HTT_TX_COMPL_STATE_NONE,
+	HTT_TX_COMPL_STATE_ACK,
+	HTT_TX_COMPL_STATE_NOACK,
+	HTT_TX_COMPL_STATE_DISCARD,
 };
 
 struct htt_peer_map_event {
@@ -1650,6 +1656,9 @@ struct ath10k_htt {
 	struct idr pending_tx;
 	wait_queue_head_t empty_tx_wq;
 
+	/* FIFO for storing tx done status {ack, no-ack, discard} and msdu id */
+	DECLARE_KFIFO_PTR(txdone_fifo, struct htt_tx_done);
+
 	/* set if host-fw communication goes haywire
 	 * used to avoid further failures */
 	bool rx_confused;
@@ -1658,7 +1667,6 @@ struct ath10k_htt {
 	/* This is used to group tx/rx completions separately and process them
 	 * in batches to reduce cache stalls */
 	struct tasklet_struct txrx_compl_task;
-	struct sk_buff_head tx_compl_q;
 	struct sk_buff_head rx_compl_q;
 	struct sk_buff_head rx_in_ord_compl_q;
 	struct sk_buff_head tx_fetch_ind_q;
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 2da8ccf..855ff4a 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -226,7 +226,6 @@ void ath10k_htt_rx_free(struct ath10k_htt *htt)
 	tasklet_kill(&htt->rx_replenish_task);
 	tasklet_kill(&htt->txrx_compl_task);
 
-	skb_queue_purge(&htt->tx_compl_q);
 	skb_queue_purge(&htt->rx_compl_q);
 	skb_queue_purge(&htt->rx_in_ord_compl_q);
 	skb_queue_purge(&htt->tx_fetch_ind_q);
@@ -567,7 +566,6 @@ int ath10k_htt_rx_alloc(struct ath10k_htt *htt)
 	tasklet_init(&htt->rx_replenish_task, ath10k_htt_rx_replenish_task,
 		     (unsigned long)htt);
 
-	skb_queue_head_init(&htt->tx_compl_q);
 	skb_queue_head_init(&htt->rx_compl_q);
 	skb_queue_head_init(&htt->rx_in_ord_compl_q);
 	skb_queue_head_init(&htt->tx_fetch_ind_q);
@@ -1678,7 +1676,7 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 	}
 }
 
-static void ath10k_htt_rx_frm_tx_compl(struct ath10k *ar,
+static void ath10k_htt_rx_tx_compl_ind(struct ath10k *ar,
 				       struct sk_buff *skb)
 {
 	struct ath10k_htt *htt = &ar->htt;
@@ -1690,19 +1688,19 @@ static void ath10k_htt_rx_frm_tx_compl(struct ath10k *ar,
 
 	switch (status) {
 	case HTT_DATA_TX_STATUS_NO_ACK:
-		tx_done.no_ack = true;
+		tx_done.status = HTT_TX_COMPL_STATE_NOACK;
 		break;
 	case HTT_DATA_TX_STATUS_OK:
-		tx_done.success = true;
+		tx_done.status = HTT_TX_COMPL_STATE_ACK;
 		break;
 	case HTT_DATA_TX_STATUS_DISCARD:
 	case HTT_DATA_TX_STATUS_POSTPONE:
 	case HTT_DATA_TX_STATUS_DOWNLOAD_FAIL:
-		tx_done.discard = true;
+		tx_done.status = HTT_TX_COMPL_STATE_DISCARD;
 		break;
 	default:
 		ath10k_warn(ar, "unhandled tx completion status %d\n", status);
-		tx_done.discard = true;
+		tx_done.status = HTT_TX_COMPL_STATE_DISCARD;
 		break;
 	}
 
@@ -1712,7 +1710,20 @@ static void ath10k_htt_rx_frm_tx_compl(struct ath10k *ar,
 	for (i = 0; i < resp->data_tx_completion.num_msdus; i++) {
 		msdu_id = resp->data_tx_completion.msdus[i];
 		tx_done.msdu_id = __le16_to_cpu(msdu_id);
-		ath10k_txrx_tx_unref(htt, &tx_done);
+
+		/* kfifo_put: In practice firmware shouldn't fire off per-CE
+		 * interrupt and main interrupt (MSI/-X range case) for the same
+		 * HTC service so it should be safe to use kfifo_put w/o lock.
+		 *
+		 * From kfifo_put() documentation:
+		 *  Note that with only one concurrent reader and one concurrent
+		 *  writer, you don't need extra locking to use these macro.
+		 */
+		if (!kfifo_put(&htt->txdone_fifo, tx_done)) {
+			ath10k_warn(ar, "txdone fifo overrun, msdu_id %d status %d\n",
+				    tx_done.msdu_id, tx_done.status);
+			ath10k_txrx_tx_unref(htt, &tx_done);
+		}
 	}
 }
 
@@ -2338,19 +2349,18 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 	case HTT_T2H_MSG_TYPE_MGMT_TX_COMPLETION: {
 		struct htt_tx_done tx_done = {};
 		int status = __le32_to_cpu(resp->mgmt_tx_completion.status);
-
 		tx_done.msdu_id =
 			__le32_to_cpu(resp->mgmt_tx_completion.desc_id);
 
 		switch (status) {
 		case HTT_MGMT_TX_STATUS_OK:
-			tx_done.success = true;
+			tx_done.status = HTT_TX_COMPL_STATE_ACK;
 			break;
 		case HTT_MGMT_TX_STATUS_RETRY:
-			tx_done.no_ack = true;
+			tx_done.status = HTT_TX_COMPL_STATE_NOACK;
 			break;
 		case HTT_MGMT_TX_STATUS_DROP:
-			tx_done.discard = true;
+			tx_done.status = HTT_TX_COMPL_STATE_DISCARD;
 			break;
 		}
 
@@ -2364,9 +2374,9 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 		break;
 	}
 	case HTT_T2H_MSG_TYPE_TX_COMPL_IND:
-		skb_queue_tail(&htt->tx_compl_q, skb);
+		ath10k_htt_rx_tx_compl_ind(htt->ar, skb);
 		tasklet_schedule(&htt->txrx_compl_task);
-		return;
+		break;
 	case HTT_T2H_MSG_TYPE_SEC_IND: {
 		struct ath10k *ar = htt->ar;
 		struct htt_security_indication *ev = &resp->security_indication;
@@ -2475,7 +2485,7 @@ static void ath10k_htt_txrx_compl_task(unsigned long ptr)
 {
 	struct ath10k_htt *htt = (struct ath10k_htt *)ptr;
 	struct ath10k *ar = htt->ar;
-	struct sk_buff_head tx_q;
+	struct htt_tx_done tx_done = {};
 	struct sk_buff_head rx_q;
 	struct sk_buff_head rx_ind_q;
 	struct sk_buff_head tx_ind_q;
@@ -2483,14 +2493,10 @@ static void ath10k_htt_txrx_compl_task(unsigned long ptr)
 	struct sk_buff *skb;
 	unsigned long flags;
 
-	__skb_queue_head_init(&tx_q);
 	__skb_queue_head_init(&rx_q);
 	__skb_queue_head_init(&rx_ind_q);
 	__skb_queue_head_init(&tx_ind_q);
 
-	spin_lock_irqsave(&htt->tx_compl_q.lock, flags);
-	skb_queue_splice_init(&htt->tx_compl_q, &tx_q);
-	spin_unlock_irqrestore(&htt->tx_compl_q.lock, flags);
 
 	spin_lock_irqsave(&htt->rx_compl_q.lock, flags);
 	skb_queue_splice_init(&htt->rx_compl_q, &rx_q);
@@ -2504,10 +2510,13 @@ static void ath10k_htt_txrx_compl_task(unsigned long ptr)
 	skb_queue_splice_init(&htt->tx_fetch_ind_q, &tx_ind_q);
 	spin_unlock_irqrestore(&htt->tx_fetch_ind_q.lock, flags);
 
-	while ((skb = __skb_dequeue(&tx_q))) {
-		ath10k_htt_rx_frm_tx_compl(htt->ar, skb);
-		dev_kfree_skb_any(skb);
-	}
+	/* kfifo_get: called only within txrx_tasklet so it's neatly serialized.
+	 * From kfifo_get() documentation:
+	 *  Note that with only one concurrent reader and one concurrent writer,
+	 *  you don't need extra locking to use these macro.
+	 */
+	while (kfifo_get(&htt->txdone_fifo, &tx_done))
+		ath10k_txrx_tx_unref(htt, &tx_done);
 
 	while ((skb = __skb_dequeue(&tx_ind_q))) {
 		ath10k_htt_rx_tx_fetch_ind(ar, skb);
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index b2ae122..9baa2e6 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -339,8 +339,18 @@ int ath10k_htt_tx_alloc(struct ath10k_htt *htt)
 		goto free_frag_desc;
 	}
 
+	size = roundup_pow_of_two(htt->max_num_pending_tx);
+	ret = kfifo_alloc(&htt->txdone_fifo, size, GFP_KERNEL);
+	if (ret) {
+		ath10k_err(ar, "failed to alloc txdone fifo: %d\n", ret);
+		goto free_txq;
+	}
+
 	return 0;
 
+free_txq:
+	ath10k_htt_tx_free_txq(htt);
+
 free_frag_desc:
 	ath10k_htt_tx_free_cont_frag_desc(htt);
 
@@ -364,8 +374,8 @@ static int ath10k_htt_tx_clean_up_pending(int msdu_id, void *skb, void *ctx)
 
 	ath10k_dbg(ar, ATH10K_DBG_HTT, "force cleanup msdu_id %hu\n", msdu_id);
 
-	tx_done.discard = 1;
 	tx_done.msdu_id = msdu_id;
+	tx_done.status = HTT_TX_COMPL_STATE_DISCARD;
 
 	ath10k_txrx_tx_unref(htt, &tx_done);
 
@@ -388,6 +398,8 @@ void ath10k_htt_tx_free(struct ath10k_htt *htt)
 
 	ath10k_htt_tx_free_txq(htt);
 	ath10k_htt_tx_free_cont_frag_desc(htt);
+	WARN_ON(!kfifo_is_empty(&htt->txdone_fifo));
+	kfifo_free(&htt->txdone_fifo);
 }
 
 void ath10k_htt_htc_tx_complete(struct ath10k *ar, struct sk_buff *skb)
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 48e26cd..9369411 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -61,9 +61,8 @@ int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 	struct sk_buff *msdu;
 
 	ath10k_dbg(ar, ATH10K_DBG_HTT,
-		   "htt tx completion msdu_id %u discard %d no_ack %d success %d\n",
-		   tx_done->msdu_id, !!tx_done->discard,
-		   !!tx_done->no_ack, !!tx_done->success);
+		   "htt tx completion msdu_id %u status %d\n",
+		   tx_done->msdu_id, tx_done->status);
 
 	if (tx_done->msdu_id >= htt->max_num_pending_tx) {
 		ath10k_warn(ar, "warning: msdu_id %d too big, ignoring\n",
@@ -101,7 +100,7 @@ int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 	memset(&info->status, 0, sizeof(info->status));
 	trace_ath10k_txrx_tx_unref(ar, tx_done->msdu_id);
 
-	if (tx_done->discard) {
+	if (tx_done->status == HTT_TX_COMPL_STATE_DISCARD) {
 		ieee80211_free_txskb(htt->ar->hw, msdu);
 		return 0;
 	}
@@ -109,10 +108,11 @@ int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
 		info->flags |= IEEE80211_TX_STAT_ACK;
 
-	if (tx_done->no_ack)
+	if (tx_done->status == HTT_TX_COMPL_STATE_NOACK)
 		info->flags &= ~IEEE80211_TX_STAT_ACK;
 
-	if (tx_done->success && (info->flags & IEEE80211_TX_CTL_NO_ACK))
+	if ((tx_done->status == HTT_TX_COMPL_STATE_ACK) &&
+	    (info->flags & IEEE80211_TX_CTL_NO_ACK))
 		info->flags |= IEEE80211_TX_STAT_NOACK_TRANSMITTED;
 
 	ieee80211_tx_status(htt->ar->hw, msdu);
-- 
2.7.4

