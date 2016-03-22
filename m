Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57602 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbcCVLxw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2016 07:53:52 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
	"Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>
Subject: [PATCH 5/9] ath10k: speedup htt rx descriptor processing for rx_ind
Date: Tue, 22 Mar 2016 17:22:15 +0530
Message-ID: <1458647539-17213-6-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20160322_125355_423614_ACA13229)
In-Reply-To: <1458647539-17213-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1458647539-17213-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In follow up patch, htt rx descriptors will be reused instead of
dealloc and refill. To achieve that htt rx indication messages
should not be deferred and should be processed in pci tasklet itself.
Also from rx indication message, mpdu_count alone is used. So it is
maintained as atomic variable and all rx amsdu handlers are done
processed from txrx tasklet. This change get rid of rx_compl_q usage.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt.h    |  1 +
 drivers/net/wireless/ath/ath10k/htt_rx.c | 39 +++++++++++++++-----------------
 2 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 76c4bae..27a65ec 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1663,6 +1663,7 @@ struct ath10k_htt {
 	 * used to avoid further failures */
 	bool rx_confused;
 	struct tasklet_struct rx_replenish_task;
+	atomic_t num_mpdus_ready;
 
 	/* This is used to group tx/rx completions separately and process them
 	 * in batches to reduce cache stalls */
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 3fdbfee..dde2237 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -526,6 +526,7 @@ int ath10k_htt_rx_alloc(struct ath10k_htt *htt)
 	skb_queue_head_init(&htt->rx_compl_q);
 	skb_queue_head_init(&htt->rx_in_ord_compl_q);
 	skb_queue_head_init(&htt->tx_fetch_ind_q);
+	atomic_set(&htt->num_mpdus_ready, 0);
 
 	tasklet_init(&htt->txrx_compl_task, ath10k_htt_txrx_compl_task,
 		     (unsigned long)htt);
@@ -1564,8 +1565,8 @@ static int ath10k_htt_rx_handle_amsdu(struct ath10k_htt *htt)
 	return 0;
 }
 
-static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
-				  struct htt_rx_indication *rx)
+static void ath10k_htt_rx_proc_rx_ind(struct ath10k_htt *htt,
+				      struct htt_rx_indication *rx)
 {
 	struct ath10k *ar = htt->ar;
 	struct htt_rx_indication_mpdu_range *mpdu_ranges;
@@ -1584,19 +1585,16 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
 	for (i = 0; i < num_mpdu_ranges; i++)
 		mpdu_count += mpdu_ranges[i].mpdu_count;
 
-	while (mpdu_count--) {
-		if (ath10k_htt_rx_handle_amsdu(htt) < 0)
-			break;
-	}
+	atomic_add(mpdu_count, &htt->num_mpdus_ready);
 
-	tasklet_schedule(&htt->rx_replenish_task);
+	tasklet_schedule(&htt->txrx_compl_task);
 }
 
 static void ath10k_htt_rx_frag_handler(struct ath10k_htt *htt)
 {
-	ath10k_htt_rx_handle_amsdu(htt);
+	atomic_inc(&htt->num_mpdus_ready);
 
-	tasklet_schedule(&htt->rx_replenish_task);
+	tasklet_schedule(&htt->txrx_compl_task);
 }
 
 static void ath10k_htt_rx_tx_compl_ind(struct ath10k *ar,
@@ -2250,9 +2248,8 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 		break;
 	}
 	case HTT_T2H_MSG_TYPE_RX_IND:
-		skb_queue_tail(&htt->rx_compl_q, skb);
-		tasklet_schedule(&htt->txrx_compl_task);
-		return;
+		ath10k_htt_rx_proc_rx_ind(htt, &resp->rx_ind);
+		break;
 	case HTT_T2H_MSG_TYPE_PEER_MAP: {
 		struct htt_peer_map_event ev = {
 			.vdev_id = resp->peer_map.vdev_id,
@@ -2419,19 +2416,15 @@ static void ath10k_htt_txrx_compl_task(unsigned long ptr)
 	struct sk_buff_head rx_q;
 	struct sk_buff_head rx_ind_q;
 	struct sk_buff_head tx_ind_q;
-	struct htt_resp *resp;
 	struct sk_buff *skb;
 	unsigned long flags;
+	int num_mpdus;
 
 	__skb_queue_head_init(&rx_q);
 	__skb_queue_head_init(&rx_ind_q);
 	__skb_queue_head_init(&tx_ind_q);
 
 
-	spin_lock_irqsave(&htt->rx_compl_q.lock, flags);
-	skb_queue_splice_init(&htt->rx_compl_q, &rx_q);
-	spin_unlock_irqrestore(&htt->rx_compl_q.lock, flags);
-
 	spin_lock_irqsave(&htt->rx_in_ord_compl_q.lock, flags);
 	skb_queue_splice_init(&htt->rx_in_ord_compl_q, &rx_ind_q);
 	spin_unlock_irqrestore(&htt->rx_in_ord_compl_q.lock, flags);
@@ -2455,10 +2448,12 @@ static void ath10k_htt_txrx_compl_task(unsigned long ptr)
 
 	ath10k_mac_tx_push_pending(ar);
 
-	while ((skb = __skb_dequeue(&rx_q))) {
-		resp = (struct htt_resp *)skb->data;
-		ath10k_htt_rx_handler(htt, &resp->rx_ind);
-		dev_kfree_skb_any(skb);
+	num_mpdus = atomic_read(&htt->num_mpdus_ready);
+	atomic_sub(num_mpdus, &htt->num_mpdus_ready);
+
+	while (num_mpdus--) {
+		if (ath10k_htt_rx_handle_amsdu(htt))
+			break;
 	}
 
 	while ((skb = __skb_dequeue(&rx_ind_q))) {
@@ -2467,4 +2462,6 @@ static void ath10k_htt_txrx_compl_task(unsigned long ptr)
 		spin_unlock_bh(&htt->rx_ring.lock);
 		dev_kfree_skb_any(skb);
 	}
+
+	tasklet_schedule(&htt->rx_replenish_task);
 }
-- 
2.7.4

