Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754345Ab2BCMIc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 07:08:32 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 24/25] iwlegacy: remove struct il_tx_info
Date: Fri,  3 Feb 2012 13:07:24 +0100
Message-Id: <1328270845-16891-25-git-send-email-sgruszka@redhat.com> (sfid-20120203_130838_578167_9DB223AA)
In-Reply-To: <1328270845-16891-1-git-send-email-sgruszka@redhat.com>
References: <1328270845-16891-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's just wrapper to sk_buff pointers ...

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c |    4 +--
 drivers/net/wireless/iwlegacy/3945.c     |   18 +++++++---------
 drivers/net/wireless/iwlegacy/4965-mac.c |   33 ++++++++++++-----------------
 drivers/net/wireless/iwlegacy/4965.c     |   18 +++++++++-------
 drivers/net/wireless/iwlegacy/common.c   |   24 ++++++++++-----------
 drivers/net/wireless/iwlegacy/common.h   |   18 +--------------
 6 files changed, 46 insertions(+), 69 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index 40ce692..aa8f5c0 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -538,9 +538,7 @@ il3945_tx_skb(struct il_priv *il, struct sk_buff *skb)
 
 	idx = il_get_cmd_idx(q, q->write_ptr, 0);
 
-	/* Set up driver data for this TFD */
-	memset(&(txq->txb[q->write_ptr]), 0, sizeof(struct il_tx_info));
-	txq->txb[q->write_ptr].skb = skb;
+	txq->skbs[q->write_ptr] = skb;
 
 	/* Init first empty entry in queue's array of Tx/cmd buffers */
 	out_cmd = txq->cmd[idx];
diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index 7c21a57..6c1ae5f 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -293,16 +293,16 @@ il3945_tx_queue_reclaim(struct il_priv *il, int txq_id, int idx)
 {
 	struct il_tx_queue *txq = &il->txq[txq_id];
 	struct il_queue *q = &txq->q;
-	struct il_tx_info *tx_info;
+	struct sk_buff *skb;
 
 	BUG_ON(txq_id == IL39_CMD_QUEUE_NUM);
 
 	for (idx = il_queue_inc_wrap(idx, q->n_bd); q->read_ptr != idx;
 	     q->read_ptr = il_queue_inc_wrap(q->read_ptr, q->n_bd)) {
 
-		tx_info = &txq->txb[txq->q.read_ptr];
-		ieee80211_tx_status_irqsafe(il->hw, tx_info->skb);
-		tx_info->skb = NULL;
+		skb = txq->skbs[txq->q.read_ptr];
+		ieee80211_tx_status_irqsafe(il->hw, skb);
+		txq->skbs[txq->q.read_ptr] = NULL;
 		il->ops->lib->txq_free_tfd(il, txq);
 	}
 
@@ -336,7 +336,7 @@ il3945_hdl_tx(struct il_priv *il, struct il_rx_buf *rxb)
 	}
 
 	txq->time_stamp = jiffies;
-	info = IEEE80211_SKB_CB(txq->txb[txq->q.read_ptr].skb);
+	info = IEEE80211_SKB_CB(txq->skbs[txq->q.read_ptr]);
 	ieee80211_tx_info_clear_status(info);
 
 	/* Fill the MRR chain with some info about on-chip retransmissions */
@@ -660,15 +660,13 @@ il3945_hw_txq_free_tfd(struct il_priv *il, struct il_tx_queue *txq)
 				 PCI_DMA_TODEVICE);
 
 	/* free SKB */
-	if (txq->txb) {
-		struct sk_buff *skb;
-
-		skb = txq->txb[txq->q.read_ptr].skb;
+	if (txq->skbs) {
+		struct sk_buff *skb = txq->skbs[txq->q.read_ptr];
 
 		/* can be called from irqs-disabled context */
 		if (skb) {
 			dev_kfree_skb_any(skb);
-			txq->txb[txq->q.read_ptr].skb = NULL;
+			txq->skbs[txq->q.read_ptr] = NULL;
 		}
 	}
 }
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 49dd1e0..2a52e7b 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -1753,9 +1753,7 @@ il4965_tx_skb(struct il_priv *il, struct sk_buff *skb)
 
 	spin_unlock(&il->sta_lock);
 
-	/* Set up driver data for this TFD */
-	memset(&(txq->txb[q->write_ptr]), 0, sizeof(struct il_tx_info));
-	txq->txb[q->write_ptr].skb = skb;
+	txq->skbs[q->write_ptr] = skb;
 
 	/* Set up first empty entry in queue's array of Tx/cmd buffers */
 	out_cmd = txq->cmd[q->write_ptr];
@@ -2435,14 +2433,14 @@ il4965_non_agg_tx_status(struct il_priv *il, const u8 *addr1)
 }
 
 static void
-il4965_tx_status(struct il_priv *il, struct il_tx_info *tx_info, bool is_agg)
+il4965_tx_status(struct il_priv *il, struct sk_buff *skb, bool is_agg)
 {
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx_info->skb->data;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 
 	if (!is_agg)
 		il4965_non_agg_tx_status(il, hdr->addr1);
 
-	ieee80211_tx_status_irqsafe(il->hw, tx_info->skb);
+	ieee80211_tx_status_irqsafe(il->hw, skb);
 }
 
 int
@@ -2450,9 +2448,9 @@ il4965_tx_queue_reclaim(struct il_priv *il, int txq_id, int idx)
 {
 	struct il_tx_queue *txq = &il->txq[txq_id];
 	struct il_queue *q = &txq->q;
-	struct il_tx_info *tx_info;
 	int nfreed = 0;
 	struct ieee80211_hdr *hdr;
+	struct sk_buff *skb;
 
 	if (idx >= q->n_bd || il_queue_used(q, idx) == 0) {
 		IL_ERR("Read idx for DMA queue txq id (%d), idx %d, "
@@ -2464,19 +2462,18 @@ il4965_tx_queue_reclaim(struct il_priv *il, int txq_id, int idx)
 	for (idx = il_queue_inc_wrap(idx, q->n_bd); q->read_ptr != idx;
 	     q->read_ptr = il_queue_inc_wrap(q->read_ptr, q->n_bd)) {
 
-		tx_info = &txq->txb[txq->q.read_ptr];
+		skb = txq->skbs[txq->q.read_ptr];
 
-		if (WARN_ON_ONCE(tx_info->skb == NULL))
+		if (WARN_ON_ONCE(skb == NULL))
 			continue;
 
-		hdr = (struct ieee80211_hdr *)tx_info->skb->data;
+		hdr = (struct ieee80211_hdr *) skb->data;
 		if (ieee80211_is_data_qos(hdr->frame_control))
 			nfreed++;
 
-		il4965_tx_status(il, tx_info,
-				 txq_id >= IL4965_FIRST_AMPDU_QUEUE);
-		tx_info->skb = NULL;
+		il4965_tx_status(il, skb, txq_id >= IL4965_FIRST_AMPDU_QUEUE);
 
+		txq->skbs[txq->q.read_ptr] = NULL;
 		il->ops->lib->txq_free_tfd(il, txq);
 	}
 	return nfreed;
@@ -2540,7 +2537,7 @@ il4965_tx_status_reply_compressed_ba(struct il_priv *il, struct il_ht_agg *agg,
 
 	D_TX_REPLY("Bitmap %llx\n", (unsigned long long)bitmap);
 
-	info = IEEE80211_SKB_CB(il->txq[scd_flow].txb[agg->start_idx].skb);
+	info = IEEE80211_SKB_CB(il->txq[scd_flow].skbs[agg->start_idx]);
 	memset(&info->status, 0, sizeof(info->status));
 	info->flags |= IEEE80211_TX_STAT_ACK;
 	info->flags |= IEEE80211_TX_STAT_AMPDU;
@@ -3624,15 +3621,13 @@ il4965_hw_txq_free_tfd(struct il_priv *il, struct il_tx_queue *txq)
 				 PCI_DMA_TODEVICE);
 
 	/* free SKB */
-	if (txq->txb) {
-		struct sk_buff *skb;
-
-		skb = txq->txb[txq->q.read_ptr].skb;
+	if (txq->skbs) {
+		struct sk_buff *skb = txq->skbs[txq->q.read_ptr];
 
 		/* can be called from irqs-disabled context */
 		if (skb) {
 			dev_kfree_skb_any(skb);
-			txq->txb[txq->q.read_ptr].skb = NULL;
+			txq->skbs[txq->q.read_ptr] = NULL;
 		}
 	}
 }
diff --git a/drivers/net/wireless/iwlegacy/4965.c b/drivers/net/wireless/iwlegacy/4965.c
index cf1d016..17a6922 100644
--- a/drivers/net/wireless/iwlegacy/4965.c
+++ b/drivers/net/wireless/iwlegacy/4965.c
@@ -1873,7 +1873,7 @@ il4965_tx_status_reply_tx(struct il_priv *il, struct il_ht_agg *agg,
 		D_TX_REPLY("FrameCnt = %d, StartIdx=%d idx=%d\n",
 			   agg->frame_count, agg->start_idx, idx);
 
-		info = IEEE80211_SKB_CB(il->txq[txq_id].txb[idx].skb);
+		info = IEEE80211_SKB_CB(il->txq[txq_id].skbs[idx]);
 		info->status.rates[0].count = tx_resp->failure_frame + 1;
 		info->flags &= ~IEEE80211_TX_CTL_AMPDU;
 		info->flags |= il4965_tx_status_to_mac80211(status);
@@ -1888,6 +1888,7 @@ il4965_tx_status_reply_tx(struct il_priv *il, struct il_ht_agg *agg,
 		/* Two or more frames were attempted; expect block-ack */
 		u64 bitmap = 0;
 		int start = agg->start_idx;
+		struct sk_buff *skb;
 
 		/* Construct bit-map of pending frames within Tx win */
 		for (i = 0; i < agg->frame_count; i++) {
@@ -1905,12 +1906,10 @@ il4965_tx_status_reply_tx(struct il_priv *il, struct il_ht_agg *agg,
 			D_TX_REPLY("FrameCnt = %d, txq_id=%d idx=%d\n",
 				   agg->frame_count, txq_id, idx);
 
-			hdr = il_tx_queue_get_hdr(il, txq_id, idx);
-			if (!hdr) {
-				IL_ERR("BUG_ON idx doesn't point to valid skb"
-				       " idx=%d, txq_id=%d\n", idx, txq_id);
+			skb = il->txq[txq_id].skbs[idx];
+			if (WARN_ON_ONCE(skb == NULL))
 				return -1;
-			}
+			hdr = (struct ieee80211_hdr *) skb->data;
 
 			sc = le16_to_cpu(hdr->seq_ctrl);
 			if (idx != (SEQ_TO_SN(sc) & 0xff)) {
@@ -2018,6 +2017,7 @@ il4965_hdl_tx(struct il_priv *il, struct il_rx_buf *rxb)
 	int txq_id = SEQ_TO_QUEUE(sequence);
 	int idx = SEQ_TO_IDX(sequence);
 	struct il_tx_queue *txq = &il->txq[txq_id];
+	struct sk_buff *skb;
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_tx_info *info;
 	struct il4965_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
@@ -2036,10 +2036,12 @@ il4965_hdl_tx(struct il_priv *il, struct il_rx_buf *rxb)
 	}
 
 	txq->time_stamp = jiffies;
-	info = IEEE80211_SKB_CB(txq->txb[txq->q.read_ptr].skb);
+
+	skb = txq->skbs[txq->q.read_ptr];
+	info = IEEE80211_SKB_CB(skb);
 	memset(&info->status, 0, sizeof(info->status));
 
-	hdr = il_tx_queue_get_hdr(il, txq_id, idx);
+	hdr = (struct ieee80211_hdr *) skb->data;
 	if (ieee80211_is_data_qos(hdr->frame_control)) {
 		qc = ieee80211_get_qos_ctl(hdr);
 		tid = qc[0] & 0xf;
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 1173521..04ec38e 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -2755,8 +2755,8 @@ il_tx_queue_free(struct il_priv *il, int txq_id)
 				  txq->tfds, txq->q.dma_addr);
 
 	/* De-alloc array of per-TFD driver data */
-	kfree(txq->txb);
-	txq->txb = NULL;
+	kfree(txq->skbs);
+	txq->skbs = NULL;
 
 	/* deallocate arrays */
 	kfree(txq->cmd);
@@ -2930,23 +2930,21 @@ il_tx_queue_alloc(struct il_priv *il, struct il_tx_queue *txq, u32 id)
 	/* Driver ilate data, only for Tx (not command) queues,
 	 * not shared with device. */
 	if (id != il->cmd_queue) {
-		txq->txb = kcalloc(TFD_QUEUE_SIZE_MAX, sizeof(txq->txb[0]),
-				   GFP_KERNEL);
-		if (!txq->txb) {
-			IL_ERR("kmalloc for auxiliary BD "
-			       "structures failed\n");
+		txq->skbs = kcalloc(TFD_QUEUE_SIZE_MAX, sizeof(struct skb *),
+				    GFP_KERNEL);
+		if (!txq->skbs) {
+			IL_ERR("Fail to alloc skbs\n");
 			goto error;
 		}
-	} else {
-		txq->txb = NULL;
-	}
+	} else
+		txq->skbs = NULL;
 
 	/* Circular buffer of transmit frame descriptors (TFDs),
 	 * shared with device */
 	txq->tfds =
 	    dma_alloc_coherent(dev, tfd_sz, &txq->q.dma_addr, GFP_KERNEL);
 	if (!txq->tfds) {
-		IL_ERR("pci_alloc_consistent(%zd) failed\n", tfd_sz);
+		IL_ERR("Fail to alloc TFDs\n");
 		goto error;
 	}
 	txq->q.id = id;
@@ -2954,8 +2952,8 @@ il_tx_queue_alloc(struct il_priv *il, struct il_tx_queue *txq, u32 id)
 	return 0;
 
 error:
-	kfree(txq->txb);
-	txq->txb = NULL;
+	kfree(txq->skbs);
+	txq->skbs = NULL;
 
 	return -ENOMEM;
 }
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 21ed70a..527a1b9 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -143,11 +143,6 @@ struct il_queue {
 				 * space less than this */
 };
 
-/* One for each TFD */
-struct il_tx_info {
-	struct sk_buff *skb;
-};
-
 /**
  * struct il_tx_queue - Tx Queue for DMA
  * @q: generic Rx/Tx queue descriptor
@@ -155,7 +150,7 @@ struct il_tx_info {
  * @cmd: array of command/TX buffer pointers
  * @meta: array of meta data for each command/tx buffer
  * @dma_addr_cmd: physical address of cmd/tx buffer array
- * @txb: array of per-TFD driver data
+ * @skbs: array of per-TFD socket buffer pointers
  * @time_stamp: time (in jiffies) of last read_ptr change
  * @need_update: indicates need to update read/write idx
  * @sched_retry: indicates queue is high-throughput aggregation (HT AGG) enabled
@@ -171,7 +166,7 @@ struct il_tx_queue {
 	void *tfds;
 	struct il_device_cmd **cmd;
 	struct il_cmd_meta *meta;
-	struct il_tx_info *txb;
+	struct sk_buff **skbs;
 	unsigned long time_stamp;
 	u8 need_update;
 	u8 sched_retry;
@@ -1482,15 +1477,6 @@ il_txq_ctx_deactivate(struct il_priv *il, int txq_id)
 	clear_bit(txq_id, &il->txq_ctx_active_msk);
 }
 
-static inline struct ieee80211_hdr *
-il_tx_queue_get_hdr(struct il_priv *il, int txq_id, int idx)
-{
-	if (il->txq[txq_id].txb[idx].skb)
-		return (struct ieee80211_hdr *)il->txq[txq_id].txb[idx].skb->
-		    data;
-	return NULL;
-}
-
 static inline int
 il_is_associated(struct il_priv *il)
 {
-- 
1.7.1

