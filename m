Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:54883 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbaEGTyB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 15:54:01 -0400
Received: by mail-wi0-f175.google.com with SMTP id f8so5926048wiw.14
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 12:53:59 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 17/23] iwlwifi: pcie: get rid of q->n_bd
Date: Wed,  7 May 2014 22:52:54 +0300
Message-Id: <1399492380-12050-17-git-send-email-egrumbach@gmail.com> (sfid-20140507_215425_670989_4F924C88)
In-Reply-To: <536A8EE3.2050906@gmail.com>
References: <536A8EE3.2050906@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This variable always tracks a constant value (256) so there's
no need to have it. Removing it simplifies code generation,
reducing the .text size (by about 240 bytes on x86-64.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/internal.h | 17 +++----
 drivers/net/wireless/iwlwifi/pcie/rx.c       |  2 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c    |  4 +-
 drivers/net/wireless/iwlwifi/pcie/tx.c       | 75 +++++++++++++---------------
 4 files changed, 45 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index 1b95d85..ab21aee 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -117,21 +117,19 @@ struct iwl_dma_ptr {
 /**
  * iwl_queue_inc_wrap - increment queue index, wrap back to beginning
  * @index -- current index
- * @n_bd -- total number of entries in queue (must be power of 2)
  */
-static inline int iwl_queue_inc_wrap(int index, int n_bd)
+static inline int iwl_queue_inc_wrap(int index)
 {
-	return ++index & (n_bd - 1);
+	return ++index & (TFD_QUEUE_SIZE_MAX - 1);
 }
 
 /**
  * iwl_queue_dec_wrap - decrement queue index, wrap back to end
  * @index -- current index
- * @n_bd -- total number of entries in queue (must be power of 2)
  */
-static inline int iwl_queue_dec_wrap(int index, int n_bd)
+static inline int iwl_queue_dec_wrap(int index)
 {
-	return --index & (n_bd - 1);
+	return --index & (TFD_QUEUE_SIZE_MAX - 1);
 }
 
 struct iwl_cmd_meta {
@@ -145,13 +143,13 @@ struct iwl_cmd_meta {
  *
  * Contains common data for Rx and Tx queues.
  *
- * Note the difference between n_bd and n_window: the hardware
- * always assumes 256 descriptors, so n_bd is always 256 (unless
+ * Note the difference between TFD_QUEUE_SIZE_MAX and n_window: the hardware
+ * always assumes 256 descriptors, so TFD_QUEUE_SIZE_MAX is always 256 (unless
  * there might be HW changes in the future). For the normal TX
  * queues, n_window, which is the size of the software queue data
  * is also 256; however, for the command queue, n_window is only
  * 32 since we don't need so many commands pending. Since the HW
- * still uses 256 BDs for DMA though, n_bd stays 256. As a result,
+ * still uses 256 BDs for DMA though, TFD_QUEUE_SIZE_MAX stays 256. As a result,
  * the software buffers (in the variables @meta, @txb in struct
  * iwl_txq) only have 32 entries, while the HW buffers (@tfds in
  * the same struct) have 256.
@@ -162,7 +160,6 @@ struct iwl_cmd_meta {
  * data is a window overlayed over the HW queue.
  */
 struct iwl_queue {
-	int n_bd;              /* number of BDs in this queue */
 	int write_ptr;       /* 1-st empty entry (index) host_w*/
 	int read_ptr;         /* last used entry (index) host_r*/
 	/* use for monitoring and recovering the stuck queue */
diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 4a26a08..a2698e5 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -850,7 +850,7 @@ static u32 iwl_pcie_int_cause_ict(struct iwl_trans *trans)
 				trans_pcie->ict_index, read);
 		trans_pcie->ict_tbl[trans_pcie->ict_index] = 0;
 		trans_pcie->ict_index =
-			iwl_queue_inc_wrap(trans_pcie->ict_index, ICT_COUNT);
+			((trans_pcie->ict_index + 1) & (ICT_COUNT - 1));
 
 		read = le32_to_cpu(trans_pcie->ict_tbl[trans_pcie->ict_index]);
 		trace_iwlwifi_dev_ict_read(trans->dev, trans_pcie->ict_index,
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index f98ef1e..a6f8622 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1337,8 +1337,8 @@ static int iwl_trans_pcie_wait_txq_empty(struct iwl_trans *trans, u32 txq_bm)
 		IWL_ERR(trans,
 			"Q %d is %sactive and mapped to fifo %d ra_tid 0x%04x [%d,%d]\n",
 			cnt, active ? "" : "in", fifo, tbl_dw,
-			iwl_read_prph(trans,
-				      SCD_QUEUE_RDPTR(cnt)) & (txq->q.n_bd - 1),
+			iwl_read_prph(trans, SCD_QUEUE_RDPTR(cnt)) &
+				(TFD_QUEUE_SIZE_MAX - 1),
 			iwl_read_prph(trans, SCD_QUEUE_WRPTR(cnt)));
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 16ebc4a..93709fe 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -70,20 +70,20 @@ static int iwl_queue_space(const struct iwl_queue *q)
 
 	/*
 	 * To avoid ambiguity between empty and completely full queues, there
-	 * should always be less than q->n_bd elements in the queue.
-	 * If q->n_window is smaller than q->n_bd, there is no need to reserve
-	 * any queue entries for this purpose.
+	 * should always be less than TFD_QUEUE_SIZE_MAX elements in the queue.
+	 * If q->n_window is smaller than TFD_QUEUE_SIZE_MAX, there is no need
+	 * to reserve any queue entries for this purpose.
 	 */
-	if (q->n_window < q->n_bd)
+	if (q->n_window < TFD_QUEUE_SIZE_MAX)
 		max = q->n_window;
 	else
-		max = q->n_bd - 1;
+		max = TFD_QUEUE_SIZE_MAX - 1;
 
 	/*
-	 * q->n_bd is a power of 2, so the following is equivalent to modulo by
-	 * q->n_bd and is well defined for negative dividends.
+	 * TFD_QUEUE_SIZE_MAX is a power of 2, so the following is equivalent to
+	 * modulo by TFD_QUEUE_SIZE_MAX and is well defined.
 	 */
-	used = (q->write_ptr - q->read_ptr) & (q->n_bd - 1);
+	used = (q->write_ptr - q->read_ptr) & (TFD_QUEUE_SIZE_MAX - 1);
 
 	if (WARN_ON(used > max))
 		return 0;
@@ -94,17 +94,11 @@ static int iwl_queue_space(const struct iwl_queue *q)
 /*
  * iwl_queue_init - Initialize queue's high/low-water and read/write indexes
  */
-static int iwl_queue_init(struct iwl_queue *q, int count, int slots_num, u32 id)
+static int iwl_queue_init(struct iwl_queue *q, int slots_num, u32 id)
 {
-	q->n_bd = count;
 	q->n_window = slots_num;
 	q->id = id;
 
-	/* count must be power-of-two size, otherwise iwl_queue_inc_wrap
-	 * and iwl_queue_dec_wrap are broken. */
-	if (WARN_ON(!is_power_of_2(count)))
-		return -EINVAL;
-
 	/* slots_num must be power-of-two size, otherwise
 	 * get_cmd_index is broken. */
 	if (WARN_ON(!is_power_of_2(slots_num)))
@@ -197,13 +191,13 @@ static void iwl_pcie_txq_stuck_timer(unsigned long data)
 		IWL_ERR(trans,
 			"Q %d is %sactive and mapped to fifo %d ra_tid 0x%04x [%d,%d]\n",
 			i, active ? "" : "in", fifo, tbl_dw,
-			iwl_read_prph(trans,
-				      SCD_QUEUE_RDPTR(i)) & (txq->q.n_bd - 1),
+			iwl_read_prph(trans, SCD_QUEUE_RDPTR(i)) &
+				(TFD_QUEUE_SIZE_MAX - 1),
 			iwl_read_prph(trans, SCD_QUEUE_WRPTR(i)));
 	}
 
 	for (i = q->read_ptr; i != q->write_ptr;
-	     i = iwl_queue_inc_wrap(i, q->n_bd))
+	     i = iwl_queue_inc_wrap(i))
 		IWL_ERR(trans, "scratch %d = 0x%08x\n", i,
 			le32_to_cpu(txq->scratchbufs[i].scratch));
 
@@ -425,13 +419,17 @@ static void iwl_pcie_txq_free_tfd(struct iwl_trans *trans, struct iwl_txq *txq)
 {
 	struct iwl_tfd *tfd_tmp = txq->tfds;
 
-	/* rd_ptr is bounded by n_bd and idx is bounded by n_window */
+	/* rd_ptr is bounded by TFD_QUEUE_SIZE_MAX and
+	 * idx is bounded by n_window
+	 */
 	int rd_ptr = txq->q.read_ptr;
 	int idx = get_cmd_index(&txq->q, rd_ptr);
 
 	lockdep_assert_held(&txq->lock);
 
-	/* We have only q->n_window txq->entries, but we use q->n_bd tfds */
+	/* We have only q->n_window txq->entries, but we use
+	 * TFD_QUEUE_SIZE_MAX tfds
+	 */
 	iwl_pcie_tfd_unmap(trans, &txq->entries[idx].meta, &tfd_tmp[rd_ptr]);
 
 	/* free SKB */
@@ -565,8 +563,7 @@ static int iwl_pcie_txq_init(struct iwl_trans *trans, struct iwl_txq *txq,
 	BUILD_BUG_ON(TFD_QUEUE_SIZE_MAX & (TFD_QUEUE_SIZE_MAX - 1));
 
 	/* Initialize queue's high/low-water marks, and head/tail indexes */
-	ret = iwl_queue_init(&txq->q, TFD_QUEUE_SIZE_MAX, slots_num,
-			txq_id);
+	ret = iwl_queue_init(&txq->q, slots_num, txq_id);
 	if (ret)
 		return ret;
 
@@ -591,15 +588,12 @@ static void iwl_pcie_txq_unmap(struct iwl_trans *trans, int txq_id)
 	struct iwl_txq *txq = &trans_pcie->txq[txq_id];
 	struct iwl_queue *q = &txq->q;
 
-	if (!q->n_bd)
-		return;
-
 	spin_lock_bh(&txq->lock);
 	while (q->write_ptr != q->read_ptr) {
 		IWL_DEBUG_TX_REPLY(trans, "Q %d Free %d\n",
 				   txq_id, q->read_ptr);
 		iwl_pcie_txq_free_tfd(trans, txq);
-		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd);
+		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr);
 	}
 	txq->active = false;
 	spin_unlock_bh(&txq->lock);
@@ -636,10 +630,12 @@ static void iwl_pcie_txq_free(struct iwl_trans *trans, int txq_id)
 		}
 
 	/* De-alloc circular buffer of TFDs */
-	if (txq->q.n_bd) {
-		dma_free_coherent(dev, sizeof(struct iwl_tfd) *
-				  txq->q.n_bd, txq->tfds, txq->q.dma_addr);
+	if (txq->tfds) {
+		dma_free_coherent(dev,
+				  sizeof(struct iwl_tfd) * TFD_QUEUE_SIZE_MAX,
+				  txq->tfds, txq->q.dma_addr);
 		txq->q.dma_addr = 0;
+		txq->tfds = NULL;
 
 		dma_free_coherent(dev,
 				  sizeof(*txq->scratchbufs) * txq->q.n_window,
@@ -948,8 +944,7 @@ void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_txq *txq = &trans_pcie->txq[txq_id];
-	/* n_bd is usually 256 => n_bd - 1 = 0xff */
-	int tfd_num = ssn & (txq->q.n_bd - 1);
+	int tfd_num = ssn & (TFD_QUEUE_SIZE_MAX - 1);
 	struct iwl_queue *q = &txq->q;
 	int last_to_free;
 
@@ -973,12 +968,12 @@ void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 
 	/*Since we free until index _not_ inclusive, the one before index is
 	 * the last we will free. This one must be used */
-	last_to_free = iwl_queue_dec_wrap(tfd_num, q->n_bd);
+	last_to_free = iwl_queue_dec_wrap(tfd_num);
 
 	if (!iwl_queue_used(q, last_to_free)) {
 		IWL_ERR(trans,
 			"%s: Read index for DMA queue txq id (%d), last_to_free %d is out of range [0-%d] %d %d.\n",
-			__func__, txq_id, last_to_free, q->n_bd,
+			__func__, txq_id, last_to_free, TFD_QUEUE_SIZE_MAX,
 			q->write_ptr, q->read_ptr);
 		goto out;
 	}
@@ -988,7 +983,7 @@ void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 
 	for (;
 	     q->read_ptr != tfd_num;
-	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
+	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr)) {
 
 		if (WARN_ON_ONCE(txq->entries[txq->q.read_ptr].skb == NULL))
 			continue;
@@ -1027,16 +1022,16 @@ static void iwl_pcie_cmdq_reclaim(struct iwl_trans *trans, int txq_id, int idx)
 
 	lockdep_assert_held(&txq->lock);
 
-	if ((idx >= q->n_bd) || (!iwl_queue_used(q, idx))) {
+	if ((idx >= TFD_QUEUE_SIZE_MAX) || (!iwl_queue_used(q, idx))) {
 		IWL_ERR(trans,
 			"%s: Read index for DMA queue txq id (%d), index %d is out of range [0-%d] %d %d.\n",
-			__func__, txq_id, idx, q->n_bd,
+			__func__, txq_id, idx, TFD_QUEUE_SIZE_MAX,
 			q->write_ptr, q->read_ptr);
 		return;
 	}
 
-	for (idx = iwl_queue_inc_wrap(idx, q->n_bd); q->read_ptr != idx;
-	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
+	for (idx = iwl_queue_inc_wrap(idx); q->read_ptr != idx;
+	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr)) {
 
 		if (nfreed++ > 0) {
 			IWL_ERR(trans, "HCMD skipped: index (%d) %d %d\n",
@@ -1445,7 +1440,7 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 	}
 
 	/* Increment and update queue's write index */
-	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
+	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr);
 	iwl_pcie_txq_inc_wr_ptr(trans, txq);
 
 	spin_unlock_irqrestore(&trans_pcie->reg_lock, flags);
@@ -1788,7 +1783,7 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		mod_timer(&txq->stuck_timer, jiffies + trans_pcie->wd_timeout);
 
 	/* Tell device the write index *just past* this latest filled TFD */
-	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
+	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr);
 	if (!wait_write_ptr)
 		iwl_pcie_txq_inc_wr_ptr(trans, txq);
 
-- 
1.8.3.2

