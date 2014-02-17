Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:58987 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbaBQJiA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 04:38:00 -0500
Received: by mail-ea0-f174.google.com with SMTP id z10so3669848ead.5
        for <linux-wireless@vger.kernel.org>; Mon, 17 Feb 2014 01:37:59 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC/RFT 5/7] ath10k: batch htt tx/rx completions
Date: Mon, 17 Feb 2014 10:32:41 +0100
Message-Id: <1392629563-31046-6-git-send-email-michal.kazior@tieto.com> (sfid-20140217_103810_040370_76434104)
In-Reply-To: <1392629563-31046-1-git-send-email-michal.kazior@tieto.com>
References: <1392629563-31046-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HTT Rx endpoint processes both frame rx
indications and frame tx completion indications.

Those completions typically come in batches and
may be mixed so it makes sense to defer processing
hoping to get a bunch of them and take advantage
of hot caches.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt.h    |   8 ++
 drivers/net/wireless/ath/ath10k/htt_rx.c | 138 +++++++++++++++++++++----------
 drivers/net/wireless/ath/ath10k/htt_tx.c |   5 +-
 drivers/net/wireless/ath/ath10k/txrx.c   |   4 +-
 4 files changed, 107 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 782a449..c36151c 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1282,6 +1282,12 @@ struct ath10k_htt {
 	 * used to avoid further failures */
 	bool rx_confused;
 	struct tasklet_struct rx_replenish_task;
+
+	/* This is used to group tx/rx completions separately and process them
+	 * in batches to reduce cache stalls */
+	struct tasklet_struct txrx_compl_task;
+	struct sk_buff_head tx_compl_q;
+	struct sk_buff_head rx_compl_q;
 };
 
 #define RX_HTT_HDR_STATUS_LEN 64
@@ -1353,4 +1359,6 @@ int ath10k_htt_tx_alloc_msdu_id(struct ath10k_htt *htt);
 void ath10k_htt_tx_free_msdu_id(struct ath10k_htt *htt, u16 msdu_id);
 int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *);
 int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *);
+void ath10k_htt_txrx_compl_task(unsigned long ptr);
+
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 371bed6..d3051e3 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -237,6 +237,10 @@ void ath10k_htt_rx_detach(struct ath10k_htt *htt)
 
 	del_timer_sync(&htt->rx_ring.refill_retry_timer);
 	tasklet_kill(&htt->rx_replenish_task);
+	tasklet_kill(&htt->txrx_compl_task);
+
+	skb_queue_purge(&htt->tx_compl_q);
+	skb_queue_purge(&htt->rx_compl_q);
 
 	while (sw_rd_idx != __le32_to_cpu(*(htt->rx_ring.alloc_idx.vaddr))) {
 		struct sk_buff *skb =
@@ -270,7 +274,7 @@ static inline struct sk_buff *ath10k_htt_rx_netbuf_pop(struct ath10k_htt *htt)
 	int idx;
 	struct sk_buff *msdu;
 
-	spin_lock_bh(&htt->rx_ring.lock);
+	lockdep_assert_held(&htt->rx_ring.lock);
 
 	if (ath10k_htt_rx_ring_elems(htt) == 0)
 		ath10k_warn("htt rx ring is empty!\n");
@@ -283,7 +287,6 @@ static inline struct sk_buff *ath10k_htt_rx_netbuf_pop(struct ath10k_htt *htt)
 	htt->rx_ring.sw_rd_idx.msdu_payld = idx;
 	htt->rx_ring.fill_cnt--;
 
-	spin_unlock_bh(&htt->rx_ring.lock);
 	return msdu;
 }
 
@@ -307,6 +310,8 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 	struct sk_buff *msdu;
 	struct htt_rx_desc *rx_desc;
 
+	lockdep_assert_held(&htt->rx_ring.lock);
+
 	if (ath10k_htt_rx_ring_elems(htt) == 0)
 		ath10k_warn("htt rx ring is empty!\n");
 
@@ -529,6 +534,12 @@ int ath10k_htt_rx_attach(struct ath10k_htt *htt)
 	tasklet_init(&htt->rx_replenish_task, ath10k_htt_rx_replenish_task,
 		     (unsigned long)htt);
 
+	skb_queue_head_init(&htt->tx_compl_q);
+	skb_queue_head_init(&htt->rx_compl_q);
+
+	tasklet_init(&htt->txrx_compl_task, ath10k_htt_txrx_compl_task,
+		     (unsigned long)htt);
+
 	ath10k_dbg(ATH10K_DBG_BOOT, "htt rx ring size %d fill_level %d\n",
 		   htt->rx_ring.size, htt->rx_ring.fill_level);
 	return 0;
@@ -888,6 +899,8 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 	u8 *fw_desc;
 	int i, j;
 
+	lockdep_assert_held(&htt->rx_ring.lock);
+
 	memset(&info, 0, sizeof(info));
 
 	fw_desc_len = __le16_to_cpu(rx->prefix.fw_rx_desc_bytes);
@@ -1024,8 +1037,11 @@ static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt,
 
 	msdu_head = NULL;
 	msdu_tail = NULL;
+
+	spin_lock_bh(&htt->rx_ring.lock);
 	msdu_chaining = ath10k_htt_rx_amsdu_pop(htt, &fw_desc, &fw_desc_len,
 						&msdu_head, &msdu_tail);
+	spin_unlock_bh(&htt->rx_ring.lock);
 
 	ath10k_dbg(ATH10K_DBG_HTT_DUMP, "htt rx frag ahead\n");
 
@@ -1117,6 +1133,45 @@ end:
 	}
 }
 
+static void ath10k_htt_rx_frm_tx_compl(struct ath10k *ar,
+				       struct sk_buff *skb)
+{
+	struct ath10k_htt *htt = &ar->htt;
+	struct htt_resp *resp = (struct htt_resp *)skb->data;
+	struct htt_tx_done tx_done = {};
+	int status = MS(resp->data_tx_completion.flags, HTT_DATA_TX_STATUS);
+	__le16 msdu_id;
+	int i;
+
+	lockdep_assert_held(&htt->tx_lock);
+
+	switch (status) {
+	case HTT_DATA_TX_STATUS_NO_ACK:
+		tx_done.no_ack = true;
+		break;
+	case HTT_DATA_TX_STATUS_OK:
+		break;
+	case HTT_DATA_TX_STATUS_DISCARD:
+	case HTT_DATA_TX_STATUS_POSTPONE:
+	case HTT_DATA_TX_STATUS_DOWNLOAD_FAIL:
+		tx_done.discard = true;
+		break;
+	default:
+		ath10k_warn("unhandled tx completion status %d\n", status);
+		tx_done.discard = true;
+		break;
+	}
+
+	ath10k_dbg(ATH10K_DBG_HTT, "htt tx completion num_msdus %d\n",
+		   resp->data_tx_completion.num_msdus);
+
+	for (i = 0; i < resp->data_tx_completion.num_msdus; i++) {
+		msdu_id = resp->data_tx_completion.msdus[i];
+		tx_done.msdu_id = __le16_to_cpu(msdu_id);
+		ath10k_txrx_tx_unref(htt, &tx_done);
+	}
+}
+
 void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct ath10k_htt *htt = &ar->htt;
@@ -1135,10 +1190,12 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 		complete(&htt->target_version_received);
 		break;
 	}
-	case HTT_T2H_MSG_TYPE_RX_IND: {
-		ath10k_htt_rx_handler(htt, &resp->rx_ind);
-		break;
-	}
+	case HTT_T2H_MSG_TYPE_RX_IND:
+		spin_lock_bh(&htt->rx_ring.lock);
+		__skb_queue_tail(&htt->rx_compl_q, skb);
+		spin_unlock_bh(&htt->rx_ring.lock);
+		tasklet_schedule(&htt->txrx_compl_task);
+		return;
 	case HTT_T2H_MSG_TYPE_PEER_MAP: {
 		struct htt_peer_map_event ev = {
 			.vdev_id = resp->peer_map.vdev_id,
@@ -1156,11 +1213,11 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 		break;
 	}
 	case HTT_T2H_MSG_TYPE_MGMT_TX_COMPLETION: {
+		struct htt_resp *resp = (struct htt_resp *)skb->data;
 		struct htt_tx_done tx_done = {};
 		int status = __le32_to_cpu(resp->mgmt_tx_completion.status);
 
-		tx_done.msdu_id =
-			__le32_to_cpu(resp->mgmt_tx_completion.desc_id);
+		tx_done.msdu_id = __le32_to_cpu(resp->mgmt_tx_completion.desc_id);
 
 		switch (status) {
 		case HTT_MGMT_TX_STATUS_OK:
@@ -1173,44 +1230,17 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 			break;
 		}
 
+		spin_lock_bh(&htt->tx_lock);
 		ath10k_txrx_tx_unref(htt, &tx_done);
+		spin_unlock_bh(&htt->tx_lock);
 		break;
 	}
-	case HTT_T2H_MSG_TYPE_TX_COMPL_IND: {
-		struct htt_tx_done tx_done = {};
-		int status = MS(resp->data_tx_completion.flags,
-				HTT_DATA_TX_STATUS);
-		__le16 msdu_id;
-		int i;
-
-		switch (status) {
-		case HTT_DATA_TX_STATUS_NO_ACK:
-			tx_done.no_ack = true;
-			break;
-		case HTT_DATA_TX_STATUS_OK:
-			break;
-		case HTT_DATA_TX_STATUS_DISCARD:
-		case HTT_DATA_TX_STATUS_POSTPONE:
-		case HTT_DATA_TX_STATUS_DOWNLOAD_FAIL:
-			tx_done.discard = true;
-			break;
-		default:
-			ath10k_warn("unhandled tx completion status %d\n",
-				    status);
-			tx_done.discard = true;
-			break;
-		}
-
-		ath10k_dbg(ATH10K_DBG_HTT, "htt tx completion num_msdus %d\n",
-			   resp->data_tx_completion.num_msdus);
-
-		for (i = 0; i < resp->data_tx_completion.num_msdus; i++) {
-			msdu_id = resp->data_tx_completion.msdus[i];
-			tx_done.msdu_id = __le16_to_cpu(msdu_id);
-			ath10k_txrx_tx_unref(htt, &tx_done);
-		}
-		break;
-	}
+	case HTT_T2H_MSG_TYPE_TX_COMPL_IND:
+		spin_lock_bh(&htt->tx_lock);
+		__skb_queue_tail(&htt->tx_compl_q, skb);
+		spin_unlock_bh(&htt->tx_lock);
+		tasklet_schedule(&htt->txrx_compl_task);
+		return;
 	case HTT_T2H_MSG_TYPE_SEC_IND: {
 		struct ath10k *ar = htt->ar;
 		struct htt_security_indication *ev = &resp->security_indication;
@@ -1250,3 +1280,25 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 	/* Free the indication buffer */
 	dev_kfree_skb_any(skb);
 }
+
+void ath10k_htt_txrx_compl_task(unsigned long ptr)
+{
+	struct ath10k_htt *htt = (struct ath10k_htt *)ptr;
+	struct htt_resp *resp;
+	struct sk_buff *skb;
+
+	spin_lock_bh(&htt->tx_lock);
+	while ((skb = __skb_dequeue(&htt->tx_compl_q))) {
+		ath10k_htt_rx_frm_tx_compl(htt->ar, skb);
+		dev_kfree_skb_any(skb);
+	}
+	spin_unlock_bh(&htt->tx_lock);
+
+	spin_lock_bh(&htt->rx_ring.lock);
+	while ((skb = __skb_dequeue(&htt->rx_compl_q))) {
+		resp = (struct htt_resp *)skb->data;
+		ath10k_htt_rx_handler(htt, &resp->rx_ind);
+		dev_kfree_skb_any(skb);
+	}
+	spin_unlock_bh(&htt->rx_ring.lock);
+}
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 0e24f51..2d10ab1 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -125,9 +125,7 @@ static void ath10k_htt_tx_cleanup_pending(struct ath10k_htt *htt)
 	struct htt_tx_done tx_done = {0};
 	int msdu_id;
 
-	/* No locks needed. Called after communication with the device has
-	 * been stopped. */
-
+	spin_lock_bh(&htt->tx_lock);
 	for (msdu_id = 0; msdu_id < htt->max_num_pending_tx; msdu_id++) {
 		if (!test_bit(msdu_id, htt->used_msdu_ids))
 			continue;
@@ -140,6 +138,7 @@ static void ath10k_htt_tx_cleanup_pending(struct ath10k_htt *htt)
 
 		ath10k_txrx_tx_unref(htt, &tx_done);
 	}
+	spin_unlock_bh(&htt->tx_lock);
 }
 
 void ath10k_htt_tx_detach(struct ath10k_htt *htt)
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 0158ce0..aecc46c 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -52,6 +52,8 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 	struct ath10k_skb_cb *skb_cb;
 	struct sk_buff *msdu;
 
+	lockdep_assert_held(&htt->tx_lock);
+
 	ath10k_dbg(ATH10K_DBG_HTT, "htt tx completion msdu_id %u discard %d no_ack %d\n",
 		   tx_done->msdu_id, !!tx_done->discard, !!tx_done->no_ack);
 
@@ -91,13 +93,11 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 	/* we do not own the msdu anymore */
 
 exit:
-	spin_lock_bh(&htt->tx_lock);
 	htt->pending_tx[tx_done->msdu_id] = NULL;
 	ath10k_htt_tx_free_msdu_id(htt, tx_done->msdu_id);
 	__ath10k_htt_tx_dec_pending(htt);
 	if (htt->num_pending_tx == 0)
 		wake_up(&htt->empty_tx_wq);
-	spin_unlock_bh(&htt->tx_lock);
 }
 
 static const u8 rx_legacy_rate_idx[] = {
-- 
1.8.5.3

