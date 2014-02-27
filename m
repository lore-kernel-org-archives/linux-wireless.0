Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:56833 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaB0HZG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 02:25:06 -0500
Received: by mail-ee0-f51.google.com with SMTP id t10so1131347eei.24
        for <linux-wireless@vger.kernel.org>; Wed, 26 Feb 2014 23:25:04 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 5/8] ath10k: batch htt tx/rx completions
Date: Thu, 27 Feb 2014 08:19:44 +0100
Message-Id: <1393485587-16879-6-git-send-email-michal.kazior@tieto.com> (sfid-20140227_082517_078218_5DE0846C)
In-Reply-To: <1393485587-16879-1-git-send-email-michal.kazior@tieto.com>
References: <1392629563-31046-1-git-send-email-michal.kazior@tieto.com>
 <1393485587-16879-1-git-send-email-michal.kazior@tieto.com>
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
v2:
 * split locking related changes into next patch
 * remove code that didn't belong here

 drivers/net/wireless/ath/ath10k/htt.h    |   8 +++
 drivers/net/wireless/ath/ath10k/htt_rx.c | 116 ++++++++++++++++++++-----------
 2 files changed, 85 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 2b76cb5..0743b8b 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1283,6 +1283,12 @@ struct ath10k_htt {
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
@@ -1354,4 +1360,6 @@ int ath10k_htt_tx_alloc_msdu_id(struct ath10k_htt *htt);
 void ath10k_htt_tx_free_msdu_id(struct ath10k_htt *htt, u16 msdu_id);
 int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *);
 int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *);
+void ath10k_htt_txrx_compl_task(unsigned long ptr);
+
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index fcd00f6..1141f6c 100644
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
@@ -529,6 +533,12 @@ int ath10k_htt_rx_attach(struct ath10k_htt *htt)
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
@@ -1123,6 +1133,43 @@ end:
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
@@ -1141,10 +1188,10 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 		complete(&htt->target_version_received);
 		break;
 	}
-	case HTT_T2H_MSG_TYPE_RX_IND: {
-		ath10k_htt_rx_handler(htt, &resp->rx_ind);
-		break;
-	}
+	case HTT_T2H_MSG_TYPE_RX_IND:
+		skb_queue_tail(&htt->rx_compl_q, skb);
+		tasklet_schedule(&htt->txrx_compl_task);
+		return;
 	case HTT_T2H_MSG_TYPE_PEER_MAP: {
 		struct htt_peer_map_event ev = {
 			.vdev_id = resp->peer_map.vdev_id,
@@ -1179,44 +1226,17 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
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
@@ -1256,3 +1276,21 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
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
+	while ((skb = skb_dequeue(&htt->tx_compl_q))) {
+		ath10k_htt_rx_frm_tx_compl(htt->ar, skb);
+		dev_kfree_skb_any(skb);
+	}
+
+	while ((skb = skb_dequeue(&htt->rx_compl_q))) {
+		resp = (struct htt_resp *)skb->data;
+		ath10k_htt_rx_handler(htt, &resp->rx_ind);
+		dev_kfree_skb_any(skb);
+	}
+}
-- 
1.8.5.3

