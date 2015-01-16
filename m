Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62075 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbbAPM6n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 07:58:43 -0500
Received: by mail-wi0-f172.google.com with SMTP id bs8so3909693wib.5
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2015 04:58:41 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: use idr api for msdu_ids
Date: Fri, 16 Jan 2015 13:58:12 +0100
Message-Id: <1421413092-6649-1-git-send-email-michal.kazior@tieto.com> (sfid-20150116_135846_539107_8DC5095C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HTT Tx protocol uses arbitrary host assigned ids
too associate with MSDUs when delivering
completions.

Instead of rolling out own id generation scheme
use the tools provided in kernel.

This should have little to no effect on
performance.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt.h    |  7 ++-
 drivers/net/wireless/ath/ath10k/htt_tx.c | 78 ++++++++++----------------------
 drivers/net/wireless/ath/ath10k/txrx.c   |  9 +++-
 3 files changed, 35 insertions(+), 59 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 8809b37..3c487eb 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1251,12 +1251,11 @@ struct ath10k_htt {
 
 	unsigned int prefetch_len;
 
-	/* Protects access to %pending_tx, %used_msdu_ids */
+	/* Protects access to pending_tx, num_pending_tx */
 	spinlock_t tx_lock;
 	int max_num_pending_tx;
 	int num_pending_tx;
-	struct sk_buff **pending_tx;
-	unsigned long *used_msdu_ids; /* bitmap */
+	struct idr pending_tx;
 	wait_queue_head_t empty_tx_wq;
 	struct dma_pool *tx_pool;
 
@@ -1345,7 +1344,7 @@ int ath10k_htt_h2t_aggr_cfg_msg(struct ath10k_htt *htt,
 				u8 max_subfrms_amsdu);
 
 void __ath10k_htt_tx_dec_pending(struct ath10k_htt *htt);
-int ath10k_htt_tx_alloc_msdu_id(struct ath10k_htt *htt);
+int ath10k_htt_tx_alloc_msdu_id(struct ath10k_htt *htt, struct sk_buff *skb);
 void ath10k_htt_tx_free_msdu_id(struct ath10k_htt *htt, u16 msdu_id);
 int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *);
 int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *);
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 5c64139..2a8667e 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -56,21 +56,18 @@ exit:
 	return ret;
 }
 
-int ath10k_htt_tx_alloc_msdu_id(struct ath10k_htt *htt)
+int ath10k_htt_tx_alloc_msdu_id(struct ath10k_htt *htt, struct sk_buff *skb)
 {
 	struct ath10k *ar = htt->ar;
-	int msdu_id;
+	int ret;
 
 	lockdep_assert_held(&htt->tx_lock);
 
-	msdu_id = find_first_zero_bit(htt->used_msdu_ids,
-				      htt->max_num_pending_tx);
-	if (msdu_id == htt->max_num_pending_tx)
-		return -ENOBUFS;
+	ret = idr_alloc(&htt->pending_tx, skb, 0, 0x10000, GFP_ATOMIC);
+
+	ath10k_dbg(ar, ATH10K_DBG_HTT, "htt tx alloc msdu_id %d\n", ret);
 
-	ath10k_dbg(ar, ATH10K_DBG_HTT, "htt tx alloc msdu_id %d\n", msdu_id);
-	__set_bit(msdu_id, htt->used_msdu_ids);
-	return msdu_id;
+	return ret;
 }
 
 void ath10k_htt_tx_free_msdu_id(struct ath10k_htt *htt, u16 msdu_id)
@@ -79,74 +76,53 @@ void ath10k_htt_tx_free_msdu_id(struct ath10k_htt *htt, u16 msdu_id)
 
 	lockdep_assert_held(&htt->tx_lock);
 
-	if (!test_bit(msdu_id, htt->used_msdu_ids))
-		ath10k_warn(ar, "trying to free unallocated msdu_id %d\n",
-			    msdu_id);
-
 	ath10k_dbg(ar, ATH10K_DBG_HTT, "htt tx free msdu_id %hu\n", msdu_id);
-	__clear_bit(msdu_id, htt->used_msdu_ids);
+
+	idr_remove(&htt->pending_tx, msdu_id);
 }
 
 int ath10k_htt_tx_alloc(struct ath10k_htt *htt)
 {
 	struct ath10k *ar = htt->ar;
 
-	spin_lock_init(&htt->tx_lock);
-
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "htt tx max num pending tx %d\n",
 		   htt->max_num_pending_tx);
 
-	htt->pending_tx = kzalloc(sizeof(*htt->pending_tx) *
-				  htt->max_num_pending_tx, GFP_KERNEL);
-	if (!htt->pending_tx)
-		return -ENOMEM;
-
-	htt->used_msdu_ids = kzalloc(sizeof(unsigned long) *
-				     BITS_TO_LONGS(htt->max_num_pending_tx),
-				     GFP_KERNEL);
-	if (!htt->used_msdu_ids) {
-		kfree(htt->pending_tx);
-		return -ENOMEM;
-	}
+	spin_lock_init(&htt->tx_lock);
+	idr_init(&htt->pending_tx);
 
 	htt->tx_pool = dma_pool_create("ath10k htt tx pool", htt->ar->dev,
 				       sizeof(struct ath10k_htt_txbuf), 4, 0);
 	if (!htt->tx_pool) {
-		kfree(htt->used_msdu_ids);
-		kfree(htt->pending_tx);
+		idr_destroy(&htt->pending_tx);
 		return -ENOMEM;
 	}
 
 	return 0;
 }
 
-static void ath10k_htt_tx_free_pending(struct ath10k_htt *htt)
+static int ath10k_htt_tx_clean_up_pending(int msdu_id, void *skb, void *ctx)
 {
-	struct ath10k *ar = htt->ar;
+	struct ath10k *ar = ctx;
+	struct ath10k_htt *htt = &ar->htt;
 	struct htt_tx_done tx_done = {0};
-	int msdu_id;
-
-	spin_lock_bh(&htt->tx_lock);
-	for (msdu_id = 0; msdu_id < htt->max_num_pending_tx; msdu_id++) {
-		if (!test_bit(msdu_id, htt->used_msdu_ids))
-			continue;
 
-		ath10k_dbg(ar, ATH10K_DBG_HTT, "force cleanup msdu_id %hu\n",
-			   msdu_id);
+	ath10k_dbg(ar, ATH10K_DBG_HTT, "force cleanup msdu_id %hu\n", msdu_id);
 
-		tx_done.discard = 1;
-		tx_done.msdu_id = msdu_id;
+	tx_done.discard = 1;
+	tx_done.msdu_id = msdu_id;
 
-		ath10k_txrx_tx_unref(htt, &tx_done);
-	}
+	spin_lock_bh(&htt->tx_lock);
+	ath10k_txrx_tx_unref(htt, &tx_done);
 	spin_unlock_bh(&htt->tx_lock);
+
+	return 0;
 }
 
 void ath10k_htt_tx_free(struct ath10k_htt *htt)
 {
-	ath10k_htt_tx_free_pending(htt);
-	kfree(htt->pending_tx);
-	kfree(htt->used_msdu_ids);
+	idr_for_each(&htt->pending_tx, ath10k_htt_tx_clean_up_pending, htt->ar);
+	idr_destroy(&htt->pending_tx);
 	dma_pool_destroy(htt->tx_pool);
 }
 
@@ -378,13 +354,12 @@ int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	len += sizeof(cmd->mgmt_tx);
 
 	spin_lock_bh(&htt->tx_lock);
-	res = ath10k_htt_tx_alloc_msdu_id(htt);
+	res = ath10k_htt_tx_alloc_msdu_id(htt, msdu);
 	if (res < 0) {
 		spin_unlock_bh(&htt->tx_lock);
 		goto err_tx_dec;
 	}
 	msdu_id = res;
-	htt->pending_tx[msdu_id] = msdu;
 	spin_unlock_bh(&htt->tx_lock);
 
 	txdesc = ath10k_htc_alloc_skb(ar, len);
@@ -423,7 +398,6 @@ err_free_txdesc:
 	dev_kfree_skb_any(txdesc);
 err_free_msdu_id:
 	spin_lock_bh(&htt->tx_lock);
-	htt->pending_tx[msdu_id] = NULL;
 	ath10k_htt_tx_free_msdu_id(htt, msdu_id);
 	spin_unlock_bh(&htt->tx_lock);
 err_tx_dec:
@@ -455,13 +429,12 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 		goto err;
 
 	spin_lock_bh(&htt->tx_lock);
-	res = ath10k_htt_tx_alloc_msdu_id(htt);
+	res = ath10k_htt_tx_alloc_msdu_id(htt, msdu);
 	if (res < 0) {
 		spin_unlock_bh(&htt->tx_lock);
 		goto err_tx_dec;
 	}
 	msdu_id = res;
-	htt->pending_tx[msdu_id] = msdu;
 	spin_unlock_bh(&htt->tx_lock);
 
 	prefetch_len = min(htt->prefetch_len, msdu->len);
@@ -595,7 +568,6 @@ err_free_txbuf:
 		      skb_cb->htt.txbuf_paddr);
 err_free_msdu_id:
 	spin_lock_bh(&htt->tx_lock);
-	htt->pending_tx[msdu_id] = NULL;
 	ath10k_htt_tx_free_msdu_id(htt, msdu_id);
 	spin_unlock_bh(&htt->tx_lock);
 err_tx_dec:
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 7579de8..3f00cec 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -64,7 +64,13 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 		return;
 	}
 
-	msdu = htt->pending_tx[tx_done->msdu_id];
+	msdu = idr_find(&htt->pending_tx, tx_done->msdu_id);
+	if (!msdu) {
+		ath10k_warn(ar, "received tx completion for invalid msdu_id: %d\n",
+			    tx_done->msdu_id);
+		return;
+	}
+
 	skb_cb = ATH10K_SKB_CB(msdu);
 
 	dma_unmap_single(dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
@@ -95,7 +101,6 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 	/* we do not own the msdu anymore */
 
 exit:
-	htt->pending_tx[tx_done->msdu_id] = NULL;
 	ath10k_htt_tx_free_msdu_id(htt, tx_done->msdu_id);
 	__ath10k_htt_tx_dec_pending(htt);
 	if (htt->num_pending_tx == 0)
-- 
1.8.5.3

