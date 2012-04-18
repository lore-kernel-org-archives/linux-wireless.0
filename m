Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:59648 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624Ab2DROpw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 10:45:52 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 14/15] iwlwifi: improve TX cache footprint
Date: Wed, 18 Apr 2012 07:41:16 -0700
Message-Id: <1334760077-5714-15-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120418_165904_045800_6BA608AC)
In-Reply-To: <1334760077-5714-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334760077-5714-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Having cmd[], meta[] and skbs[] as separate arrays
in the TX queue structure is cache inefficient as
we need the data for a given entry together.

To improve this, create an array with these three
members (allocate meta as part of that struct) so
we have the data we need together located together
improving cache footprint.

The downside is that we need to allocate a lot of
memory in one chunk, about 10KiB (on 64-bit) which
isn't very efficient.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |   29 +++++----
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |   31 +++++-----
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |   65 ++++++---------------
 4 files changed, 52 insertions(+), 75 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index 7caa875..c7f8f40 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -179,30 +179,33 @@ struct iwl_queue {
 				* space less than this */
 };
 
+#define TFD_TX_CMD_SLOTS 256
+#define TFD_CMD_SLOTS 32
+
+struct iwl_pcie_tx_queue_entry {
+	struct iwl_device_cmd *cmd;
+	struct sk_buff *skb;
+	struct iwl_cmd_meta meta;
+};
+
 /**
  * struct iwl_tx_queue - Tx Queue for DMA
  * @q: generic Rx/Tx queue descriptor
- * @bd: base of circular buffer of TFDs
- * @cmd: array of command/TX buffer pointers
- * @meta: array of meta data for each command/tx buffer
- * @dma_addr_cmd: physical address of cmd/tx buffer array
- * @txb: array of per-TFD driver data
- * lock: queue lock
- * @time_stamp: time (in jiffies) of last read_ptr change
+ * @tfds: transmit frame descriptors (DMA memory)
+ * @entries: transmit entries (driver state)
+ * @lock: queue lock
+ * @stuck_timer: timer that fires if queue gets stuck
+ * @trans_pcie: pointer back to transport (for timer)
  * @need_update: indicates need to update read/write index
+ * @active: stores if queue is active
  *
  * A Tx queue consists of circular buffer of BDs (a.k.a. TFDs, transmit frame
  * descriptors) and required locking structures.
  */
-#define TFD_TX_CMD_SLOTS 256
-#define TFD_CMD_SLOTS 32
-
 struct iwl_tx_queue {
 	struct iwl_queue q;
 	struct iwl_tfd *tfds;
-	struct iwl_device_cmd **cmd;
-	struct iwl_cmd_meta *meta;
-	struct sk_buff **skbs;
+	struct iwl_pcie_tx_queue_entry *entries;
 	spinlock_t lock;
 	struct timer_list stuck_timer;
 	struct iwl_trans_pcie *trans_pcie;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 390490b..47c1f0a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -425,7 +425,7 @@ static void iwl_rx_handle_rxbuf(struct iwl_trans *trans,
 		cmd_index = get_cmd_index(&txq->q, index);
 
 		if (reclaim)
-			cmd = txq->cmd[cmd_index];
+			cmd = txq->entries[cmd_index].cmd;
 		else
 			cmd = NULL;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index bb0a314..1b2aed6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -58,7 +58,7 @@ void iwl_trans_txq_update_byte_cnt_tbl(struct iwl_trans *trans,
 	u16 len = byte_cnt + IWL_TX_CRC_SIZE + IWL_TX_DELIMITER_SIZE;
 	__le16 bc_ent;
 	struct iwl_tx_cmd *tx_cmd =
-		(struct iwl_tx_cmd *) txq->cmd[txq->q.write_ptr]->payload;
+		(void *) txq->entries[txq->q.write_ptr].cmd->payload;
 
 	scd_bc_tbl = trans_pcie->scd_bc_tbls.addr;
 
@@ -221,13 +221,14 @@ void iwlagn_txq_free_tfd(struct iwl_trans *trans, struct iwl_tx_queue *txq,
 
 	lockdep_assert_held(&txq->lock);
 
-	iwlagn_unmap_tfd(trans, &txq->meta[index], &tfd_tmp[index], dma_dir);
+	iwlagn_unmap_tfd(trans, &txq->entries[index].meta,
+			 &tfd_tmp[index], dma_dir);
 
 	/* free SKB */
-	if (txq->skbs) {
+	if (txq->entries) {
 		struct sk_buff *skb;
 
-		skb = txq->skbs[index];
+		skb = txq->entries[index].skb;
 
 		/* Can be called from irqs-disabled context
 		 * If skb is not NULL, it means that the whole queue is being
@@ -235,7 +236,7 @@ void iwlagn_txq_free_tfd(struct iwl_trans *trans, struct iwl_tx_queue *txq,
 		 */
 		if (skb) {
 			iwl_op_mode_free_skb(trans->op_mode, skb);
-			txq->skbs[index] = NULL;
+			txq->entries[index].skb = NULL;
 		}
 	}
 }
@@ -358,7 +359,7 @@ static void iwlagn_txq_inval_byte_cnt_tbl(struct iwl_trans *trans,
 	u8 sta_id = 0;
 	__le16 bc_ent;
 	struct iwl_tx_cmd *tx_cmd =
-		(struct iwl_tx_cmd *) txq->cmd[txq->q.read_ptr]->payload;
+		(void *)txq->entries[txq->q.read_ptr].cmd->payload;
 
 	WARN_ON(read_ptr >= TFD_QUEUE_SIZE_MAX);
 
@@ -578,8 +579,8 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 	}
 
 	idx = get_cmd_index(q, q->write_ptr);
-	out_cmd = txq->cmd[idx];
-	out_meta = &txq->meta[idx];
+	out_cmd = txq->entries[idx].cmd;
+	out_meta = &txq->entries[idx].meta;
 
 	memset(out_meta, 0, sizeof(*out_meta));	/* re-initialize to NULL */
 	if (cmd->flags & CMD_WANT_SKB)
@@ -772,8 +773,8 @@ void iwl_tx_cmd_complete(struct iwl_trans *trans, struct iwl_rx_cmd_buffer *rxb,
 	spin_lock(&txq->lock);
 
 	cmd_index = get_cmd_index(&txq->q, index);
-	cmd = txq->cmd[cmd_index];
-	meta = &txq->meta[cmd_index];
+	cmd = txq->entries[cmd_index].cmd;
+	meta = &txq->entries[cmd_index].meta;
 
 	iwlagn_unmap_tfd(trans, meta, &txq->tfds[index],
 			 DMA_BIDIRECTIONAL);
@@ -905,8 +906,8 @@ cancel:
 		 * in later, it will possibly set an invalid
 		 * address (cmd->meta.source).
 		 */
-		trans_pcie->txq[trans_pcie->cmd_queue].meta[cmd_idx].flags &=
-							~CMD_WANT_SKB;
+		trans_pcie->txq[trans_pcie->cmd_queue].
+			entries[cmd_idx].meta.flags &= ~CMD_WANT_SKB;
 	}
 
 	if (cmd->resp_pkt) {
@@ -961,12 +962,12 @@ int iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
 	     q->read_ptr != index;
 	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
 
-		if (WARN_ON_ONCE(txq->skbs[txq->q.read_ptr] == NULL))
+		if (WARN_ON_ONCE(txq->entries[txq->q.read_ptr].skb == NULL))
 			continue;
 
-		__skb_queue_tail(skbs, txq->skbs[txq->q.read_ptr]);
+		__skb_queue_tail(skbs, txq->entries[txq->q.read_ptr].skb);
 
-		txq->skbs[txq->q.read_ptr] = NULL;
+		txq->entries[txq->q.read_ptr].skb = NULL;
 
 		iwlagn_txq_inval_byte_cnt_tbl(trans, txq);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index bc610f9..e6401e8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -333,7 +333,7 @@ static int iwl_trans_txq_alloc(struct iwl_trans *trans,
 	int i;
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
-	if (WARN_ON(txq->meta || txq->cmd || txq->skbs || txq->tfds))
+	if (WARN_ON(txq->entries || txq->tfds))
 		return -EINVAL;
 
 	setup_timer(&txq->stuck_timer, iwl_trans_pcie_queue_stuck_timer,
@@ -342,35 +342,22 @@ static int iwl_trans_txq_alloc(struct iwl_trans *trans,
 
 	txq->q.n_window = slots_num;
 
-	txq->meta = kcalloc(slots_num, sizeof(txq->meta[0]), GFP_KERNEL);
-	txq->cmd = kcalloc(slots_num, sizeof(txq->cmd[0]), GFP_KERNEL);
+	txq->entries = kcalloc(slots_num,
+			       sizeof(struct iwl_pcie_tx_queue_entry),
+			       GFP_KERNEL);
 
-	if (!txq->meta || !txq->cmd)
+	if (!txq->entries)
 		goto error;
 
 	if (txq_id == trans_pcie->cmd_queue)
 		for (i = 0; i < slots_num; i++) {
-			txq->cmd[i] = kmalloc(sizeof(struct iwl_device_cmd),
-						GFP_KERNEL);
-			if (!txq->cmd[i])
+			txq->entries[i].cmd =
+				kmalloc(sizeof(struct iwl_device_cmd),
+					GFP_KERNEL);
+			if (!txq->entries[i].cmd)
 				goto error;
 		}
 
-	/* Alloc driver data array and TFD circular buffer */
-	/* Driver private data, only for Tx (not command) queues,
-	 * not shared with device. */
-	if (txq_id != trans_pcie->cmd_queue) {
-		txq->skbs = kcalloc(TFD_QUEUE_SIZE_MAX, sizeof(txq->skbs[0]),
-				    GFP_KERNEL);
-		if (!txq->skbs) {
-			IWL_ERR(trans, "kmalloc for auxiliary BD "
-				  "structures failed\n");
-			goto error;
-		}
-	} else {
-		txq->skbs = NULL;
-	}
-
 	/* Circular buffer of transmit frame descriptors (TFDs),
 	 * shared with device */
 	txq->tfds = dma_alloc_coherent(trans->dev, tfd_sz,
@@ -383,17 +370,11 @@ static int iwl_trans_txq_alloc(struct iwl_trans *trans,
 
 	return 0;
 error:
-	kfree(txq->skbs);
-	txq->skbs = NULL;
-	/* since txq->cmd has been zeroed,
-	 * all non allocated cmd[i] will be NULL */
-	if (txq->cmd && txq_id == trans_pcie->cmd_queue)
+	if (txq->entries && txq_id == trans_pcie->cmd_queue)
 		for (i = 0; i < slots_num; i++)
-			kfree(txq->cmd[i]);
-	kfree(txq->meta);
-	kfree(txq->cmd);
-	txq->meta = NULL;
-	txq->cmd = NULL;
+			kfree(txq->entries[i].cmd);
+	kfree(txq->entries);
+	txq->entries = NULL;
 
 	return -ENOMEM;
 
@@ -405,7 +386,6 @@ static int iwl_trans_txq_init(struct iwl_trans *trans, struct iwl_tx_queue *txq,
 	int ret;
 
 	txq->need_update = 0;
-	memset(txq->meta, 0, sizeof(txq->meta[0]) * slots_num);
 
 	/* TFD_QUEUE_SIZE_MAX must be power-of-two size, otherwise
 	 * iwl_queue_inc_wrap and iwl_queue_dec_wrap are broken. */
@@ -483,7 +463,7 @@ static void iwl_tx_queue_free(struct iwl_trans *trans, int txq_id)
 
 	if (txq_id == trans_pcie->cmd_queue)
 		for (i = 0; i < txq->q.n_window; i++)
-			kfree(txq->cmd[i]);
+			kfree(txq->entries[i].cmd);
 
 	/* De-alloc circular buffer of TFDs */
 	if (txq->q.n_bd) {
@@ -492,15 +472,8 @@ static void iwl_tx_queue_free(struct iwl_trans *trans, int txq_id)
 		memset(&txq->q.dma_addr, 0, sizeof(txq->q.dma_addr));
 	}
 
-	/* De-alloc array of per-TFD driver data */
-	kfree(txq->skbs);
-	txq->skbs = NULL;
-
-	/* deallocate arrays */
-	kfree(txq->cmd);
-	kfree(txq->meta);
-	txq->cmd = NULL;
-	txq->meta = NULL;
+	kfree(txq->entries);
+	txq->entries = NULL;
 
 	del_timer_sync(&txq->stuck_timer);
 
@@ -1295,15 +1268,15 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	spin_lock(&txq->lock);
 
 	/* Set up driver data for this TFD */
-	txq->skbs[q->write_ptr] = skb;
-	txq->cmd[q->write_ptr] = dev_cmd;
+	txq->entries[q->write_ptr].skb = skb;
+	txq->entries[q->write_ptr].cmd = dev_cmd;
 
 	dev_cmd->hdr.cmd = REPLY_TX;
 	dev_cmd->hdr.sequence = cpu_to_le16((u16)(QUEUE_TO_SEQ(txq_id) |
 				INDEX_TO_SEQ(q->write_ptr)));
 
 	/* Set up first empty entry in queue's array of Tx/cmd buffers */
-	out_meta = &txq->meta[q->write_ptr];
+	out_meta = &txq->entries[q->write_ptr].meta;
 
 	/*
 	 * Use the first empty entry in this queue's command buffer array
-- 
1.7.0.4

