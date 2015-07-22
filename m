Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:35593 "EHLO
	mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbbGVUiq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 16:38:46 -0400
Received: by qkbm65 with SMTP id m65so107057233qkb.2
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2015 13:38:45 -0700 (PDT)
From: Marty Faltesek <mfaltesek@google.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, dgentry@google.com,
	apenwarr@google.com
Subject: [PATCH v2] ath10k: Improve performance by reducing tx_lock contention.
Date: Wed, 22 Jul 2015 16:38:24 -0400
Message-Id: <1437597504-25554-1-git-send-email-mfaltesek@google.com> (sfid-20150722_223852_206070_B892A016)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Qi Zhou <qizhou@google.com>

During tx completion, tx_lock is held for longer than required, preventing
efficient refill of htt->pending_tx. Refactor the code so that only MSDU
related operations are protected by the lock.

Improves downstream performance on a dual-core ARM Freescale LS1024A
(f.k.a. Mindspeed Comcerto 2000) AP with a 3x3 client from 495 to 580 Mbps.
Other CPU bound multicore systems may also benefit.

Signed-off-by: Denton Gentry <dgentry@google.com>
Signed-off-by: Avery Pennarun <apenwarr@google.com>
[mfaltesek@google.com: removed conflicting code for tracking msdu_ids.]
Signed-off-by: Marty Faltesek <mfaltesek@google.com>

---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 12 ++----------
 drivers/net/wireless/ath/ath10k/htt_tx.c |  8 ++------
 drivers/net/wireless/ath/ath10k/txrx.c   | 17 ++++++++---------
 3 files changed, 12 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 89eb16b..79e68fa 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1633,8 +1633,6 @@ static void ath10k_htt_rx_frm_tx_compl(struct ath10k *ar,
 	__le16 msdu_id;
 	int i;
 
-	lockdep_assert_held(&htt->tx_lock);
-
 	switch (status) {
 	case HTT_DATA_TX_STATUS_NO_ACK:
 		tx_done.no_ack = true;
@@ -2000,15 +1998,11 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 			break;
 		}
 
-		spin_lock_bh(&htt->tx_lock);
 		ath10k_txrx_tx_unref(htt, &tx_done);
-		spin_unlock_bh(&htt->tx_lock);
 		break;
 	}
 	case HTT_T2H_MSG_TYPE_TX_COMPL_IND:
-		spin_lock_bh(&htt->tx_lock);
-		__skb_queue_tail(&htt->tx_compl_q, skb);
-		spin_unlock_bh(&htt->tx_lock);
+		skb_queue_tail(&htt->tx_compl_q, skb);
 		tasklet_schedule(&htt->txrx_compl_task);
 		return;
 	case HTT_T2H_MSG_TYPE_SEC_IND: {
@@ -2093,12 +2087,10 @@ static void ath10k_htt_txrx_compl_task(unsigned long ptr)
 	struct htt_resp *resp;
 	struct sk_buff *skb;
 
-	spin_lock_bh(&htt->tx_lock);
-	while ((skb = __skb_dequeue(&htt->tx_compl_q))) {
+	while ((skb = skb_dequeue(&htt->tx_compl_q))) {
 		ath10k_htt_rx_frm_tx_compl(htt->ar, skb);
 		dev_kfree_skb_any(skb);
 	}
-	spin_unlock_bh(&htt->tx_lock);
 
 	spin_lock_bh(&htt->rx_ring.lock);
 	while ((skb = __skb_dequeue(&htt->rx_compl_q))) {
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index a60ef7d..262d657 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -112,9 +112,7 @@ static int ath10k_htt_tx_clean_up_pending(int msdu_id, void *skb, void *ctx)
 	tx_done.discard = 1;
 	tx_done.msdu_id = msdu_id;
 
-	spin_lock_bh(&htt->tx_lock);
 	ath10k_txrx_tx_unref(htt, &tx_done);
-	spin_unlock_bh(&htt->tx_lock);
 
 	return 0;
 }
@@ -355,12 +353,11 @@ int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 
 	spin_lock_bh(&htt->tx_lock);
 	res = ath10k_htt_tx_alloc_msdu_id(htt, msdu);
+	spin_unlock_bh(&htt->tx_lock);
 	if (res < 0) {
-		spin_unlock_bh(&htt->tx_lock);
 		goto err_tx_dec;
 	}
 	msdu_id = res;
-	spin_unlock_bh(&htt->tx_lock);
 
 	txdesc = ath10k_htc_alloc_skb(ar, len);
 	if (!txdesc) {
@@ -429,12 +426,11 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 
 	spin_lock_bh(&htt->tx_lock);
 	res = ath10k_htt_tx_alloc_msdu_id(htt, msdu);
+	spin_unlock_bh(&htt->tx_lock);
 	if (res < 0) {
-		spin_unlock_bh(&htt->tx_lock);
 		goto err_tx_dec;
 	}
 	msdu_id = res;
-	spin_unlock_bh(&htt->tx_lock);
 
 	prefetch_len = min(htt->prefetch_len, msdu->len);
 	prefetch_len = roundup(prefetch_len, 4);
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 826500b..40a8083 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -53,8 +53,6 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 	struct ath10k_skb_cb *skb_cb;
 	struct sk_buff *msdu;
 
-	lockdep_assert_held(&htt->tx_lock);
-
 	ath10k_dbg(ar, ATH10K_DBG_HTT,
 		   "htt tx completion msdu_id %u discard %d no_ack %d success %d\n",
 		   tx_done->msdu_id, !!tx_done->discard,
@@ -66,12 +64,19 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 		return;
 	}
 
+	spin_lock_bh(&htt->tx_lock);
 	msdu = idr_find(&htt->pending_tx, tx_done->msdu_id);
 	if (!msdu) {
 		ath10k_warn(ar, "received tx completion for invalid msdu_id: %d\n",
 			    tx_done->msdu_id);
+		spin_unlock_bh(&htt->tx_lock);
 		return;
 	}
+	ath10k_htt_tx_free_msdu_id(htt, tx_done->msdu_id);
+	__ath10k_htt_tx_dec_pending(htt);
+	if (htt->num_pending_tx == 0)
+		wake_up(&htt->empty_tx_wq);
+	spin_unlock_bh(&htt->tx_lock);
 
 	skb_cb = ATH10K_SKB_CB(msdu);
 
@@ -90,7 +95,7 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 
 	if (tx_done->discard) {
 		ieee80211_free_txskb(htt->ar->hw, msdu);
-		goto exit;
+		return;
 	}
 
 	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
@@ -104,12 +109,6 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 
 	ieee80211_tx_status(htt->ar->hw, msdu);
 	/* we do not own the msdu anymore */
-
-exit:
-	ath10k_htt_tx_free_msdu_id(htt, tx_done->msdu_id);
-	__ath10k_htt_tx_dec_pending(htt);
-	if (htt->num_pending_tx == 0)
-		wake_up(&htt->empty_tx_wq);
 }
 
 struct ath10k_peer *ath10k_peer_find(struct ath10k *ar, int vdev_id,
-- 
2.4.3.573.g4eafbef

