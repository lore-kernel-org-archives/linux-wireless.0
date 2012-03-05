Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11459 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965000Ab2CEUiE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 15:38:04 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 06/33] iwlwifi: introduce per-queue locks
Date: Mon,  5 Mar 2012 11:24:24 -0800
Message-Id: <1330975491-19680-7-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120305_213811_232364_8B2465E3)
In-Reply-To: <1330975491-19680-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330975491-19680-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of (ab)using the sta_lock, make the
transport layer lock its own TX queue data
structures with a lock per queue. This also
unifies with the cmd queue lock.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    2 +
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |   20 ++++++++-----
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |   31 +++++++++++++--------
 drivers/net/wireless/iwlwifi/iwl-trans.h          |    2 -
 4 files changed, 33 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index 5b26b71..b102946 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -169,6 +169,7 @@ struct iwl_queue {
  * @meta: array of meta data for each command/tx buffer
  * @dma_addr_cmd: physical address of cmd/tx buffer array
  * @txb: array of per-TFD driver data
+ * lock: queue lock
  * @time_stamp: time (in jiffies) of last read_ptr change
  * @need_update: indicates need to update read/write index
  * @sched_retry: indicates queue is high-throughput aggregation (HT AGG) enabled
@@ -187,6 +188,7 @@ struct iwl_tx_queue {
 	struct iwl_device_cmd **cmd;
 	struct iwl_cmd_meta *meta;
 	struct sk_buff **skbs;
+	spinlock_t lock;
 	unsigned long time_stamp;
 	u8 need_update;
 	u8 sched_retry;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index 82e3448..1cb1dd2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -217,6 +217,8 @@ void iwlagn_txq_free_tfd(struct iwl_trans *trans, struct iwl_tx_queue *txq,
 {
 	struct iwl_tfd *tfd_tmp = txq->tfds;
 
+	lockdep_assert_held(&txq->lock);
+
 	iwlagn_unmap_tfd(trans, &txq->meta[index], &tfd_tmp[index], dma_dir);
 
 	/* free SKB */
@@ -621,7 +623,6 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 	struct iwl_device_cmd *out_cmd;
 	struct iwl_cmd_meta *out_meta;
 	dma_addr_t phys_addr;
-	unsigned long flags;
 	u32 idx;
 	u16 copy_size, cmd_size;
 	bool is_ct_kill = false;
@@ -680,10 +681,10 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 		return -EIO;
 	}
 
-	spin_lock_irqsave(&trans->hcmd_lock, flags);
+	spin_lock_bh(&txq->lock);
 
 	if (iwl_queue_space(q) < ((cmd->flags & CMD_ASYNC) ? 2 : 1)) {
-		spin_unlock_irqrestore(&trans->hcmd_lock, flags);
+		spin_unlock_bh(&txq->lock);
 
 		IWL_ERR(trans, "No space in command queue\n");
 		is_ct_kill = iwl_check_for_ct_kill(priv(trans));
@@ -790,7 +791,7 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 	iwl_txq_update_write_ptr(trans, txq);
 
  out:
-	spin_unlock_irqrestore(&trans->hcmd_lock, flags);
+	spin_unlock_bh(&txq->lock);
 	return idx;
 }
 
@@ -809,6 +810,8 @@ static void iwl_hcmd_queue_reclaim(struct iwl_trans *trans, int txq_id,
 	struct iwl_queue *q = &txq->q;
 	int nfreed = 0;
 
+	lockdep_assert_held(&txq->lock);
+
 	if ((idx >= q->n_bd) || (iwl_queue_used(q, idx) == 0)) {
 		IWL_ERR(trans, "%s: Read index for DMA queue txq id (%d), "
 			  "index %d is out of range [0-%d] %d %d.\n", __func__,
@@ -850,7 +853,6 @@ void iwl_tx_cmd_complete(struct iwl_trans *trans, struct iwl_rx_mem_buffer *rxb,
 	struct iwl_cmd_meta *meta;
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_tx_queue *txq = &trans_pcie->txq[trans->shrd->cmd_queue];
-	unsigned long flags;
 
 	/* If a Tx command is being handled and it isn't in the actual
 	 * command queue then there a command routing bug has been introduced
@@ -864,6 +866,8 @@ void iwl_tx_cmd_complete(struct iwl_trans *trans, struct iwl_rx_mem_buffer *rxb,
 		return;
 	}
 
+	spin_lock(&txq->lock);
+
 	cmd_index = get_cmd_index(&txq->q, index);
 	cmd = txq->cmd[cmd_index];
 	meta = &txq->meta[cmd_index];
@@ -880,8 +884,6 @@ void iwl_tx_cmd_complete(struct iwl_trans *trans, struct iwl_rx_mem_buffer *rxb,
 		rxb->page = NULL;
 	}
 
-	spin_lock_irqsave(&trans->hcmd_lock, flags);
-
 	iwl_hcmd_queue_reclaim(trans, txq_id, index);
 
 	if (!(meta->flags & CMD_ASYNC)) {
@@ -898,7 +900,7 @@ void iwl_tx_cmd_complete(struct iwl_trans *trans, struct iwl_rx_mem_buffer *rxb,
 
 	meta->flags = 0;
 
-	spin_unlock_irqrestore(&trans->hcmd_lock, flags);
+	spin_unlock(&txq->lock);
 }
 
 #define HOST_COMPLETE_TIMEOUT (2 * HZ)
@@ -1041,6 +1043,8 @@ int iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
 	if (WARN_ON(txq_id == trans->shrd->cmd_queue))
 		return 0;
 
+	lockdep_assert_held(&txq->lock);
+
 	/*Since we free until index _not_ inclusive, the one before index is
 	 * the last we will free. This one must be used */
 	last_to_free = iwl_queue_dec_wrap(index, q->n_bd);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 9f8b239..f47426a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -390,6 +390,8 @@ static int iwl_trans_txq_init(struct iwl_trans *trans, struct iwl_tx_queue *txq,
 	if (ret)
 		return ret;
 
+	spin_lock_init(&txq->lock);
+
 	/*
 	 * Tell nic where to find circular buffer of Tx Frame Descriptors for
 	 * given Tx queue, and enable the DMA channel used for that queue.
@@ -409,8 +411,6 @@ static void iwl_tx_queue_unmap(struct iwl_trans *trans, int txq_id)
 	struct iwl_tx_queue *txq = &trans_pcie->txq[txq_id];
 	struct iwl_queue *q = &txq->q;
 	enum dma_data_direction dma_dir;
-	unsigned long flags;
-	spinlock_t *lock;
 
 	if (!q->n_bd)
 		return;
@@ -418,22 +418,19 @@ static void iwl_tx_queue_unmap(struct iwl_trans *trans, int txq_id)
 	/* In the command queue, all the TBs are mapped as BIDI
 	 * so unmap them as such.
 	 */
-	if (txq_id == trans->shrd->cmd_queue) {
+	if (txq_id == trans->shrd->cmd_queue)
 		dma_dir = DMA_BIDIRECTIONAL;
-		lock = &trans->hcmd_lock;
-	} else {
+	else
 		dma_dir = DMA_TO_DEVICE;
-		lock = &trans->shrd->sta_lock;
-	}
 
-	spin_lock_irqsave(lock, flags);
+	spin_lock_bh(&txq->lock);
 	while (q->write_ptr != q->read_ptr) {
 		/* The read_ptr needs to bound by q->n_window */
 		iwlagn_txq_free_tfd(trans, txq, get_cmd_index(q, q->read_ptr),
 				    dma_dir);
 		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd);
 	}
-	spin_unlock_irqrestore(lock, flags);
+	spin_unlock_bh(&txq->lock);
 }
 
 /**
@@ -1358,6 +1355,8 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	txq = &trans_pcie->txq[txq_id];
 	q = &txq->q;
 
+	spin_lock(&txq->lock);
+
 	/* In AGG mode, the index in the ring must correspond to the WiFi
 	 * sequence number. This is a HW requirements to help the SCD to parse
 	 * the BA.
@@ -1404,7 +1403,7 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 				    &dev_cmd->hdr, firstlen,
 				    DMA_BIDIRECTIONAL);
 	if (unlikely(dma_mapping_error(trans->dev, txcmd_phys)))
-		return -1;
+		goto out_err;
 	dma_unmap_addr_set(out_meta, mapping, txcmd_phys);
 	dma_unmap_len_set(out_meta, len, firstlen);
 
@@ -1426,7 +1425,7 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 					 dma_unmap_addr(out_meta, mapping),
 					 dma_unmap_len(out_meta, len),
 					 DMA_BIDIRECTIONAL);
-			return -1;
+			goto out_err;
 		}
 	}
 
@@ -1481,7 +1480,11 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 			iwl_stop_queue(trans, txq, "Queue is full");
 		}
 	}
+	spin_unlock(&txq->lock);
 	return 0;
+ out_err:
+	spin_unlock(&txq->lock);
+	return -1;
 }
 
 static int iwl_trans_pcie_start_hw(struct iwl_trans *trans)
@@ -1560,6 +1563,8 @@ static int iwl_trans_pcie_reclaim(struct iwl_trans *trans, int sta_id, int tid,
 	int tfd_num = ssn & (txq->q.n_bd - 1);
 	int freed = 0;
 
+	spin_lock(&txq->lock);
+
 	txq->time_stamp = jiffies;
 
 	if (unlikely(txq_id >= IWLAGN_FIRST_AMPDU_QUEUE &&
@@ -1574,6 +1579,7 @@ static int iwl_trans_pcie_reclaim(struct iwl_trans *trans, int sta_id, int tid,
 		IWL_DEBUG_TX_QUEUES(trans, "Bad queue mapping txq_id %d, "
 			"agg_txq[sta_id[tid] %d", txq_id,
 			trans_pcie->agg_txq[sta_id][tid]);
+		spin_unlock(&txq->lock);
 		return 1;
 	}
 
@@ -1587,6 +1593,8 @@ static int iwl_trans_pcie_reclaim(struct iwl_trans *trans, int sta_id, int tid,
 		   status != TX_STATUS_FAIL_PASSIVE_NO_RX))
 			iwl_wake_queue(trans, txq, "Packets reclaimed");
 	}
+
+	spin_unlock(&txq->lock);
 	return 0;
 }
 
@@ -2267,7 +2275,6 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd,
 	trans->ops = &trans_ops_pcie;
 	trans->shrd = shrd;
 	trans_pcie->trans = trans;
-	spin_lock_init(&trans->hcmd_lock);
 	spin_lock_init(&trans_pcie->irq_lock);
 
 	/* W/A - seems to solve weird behavior. We need to remove this if we
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 4e7e6c0..e2f21cf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -309,7 +309,6 @@ enum iwl_trans_state {
  * @ops - pointer to iwl_trans_ops
  * @op_mode - pointer to the op_mode
  * @shrd - pointer to iwl_shared which holds shared data from the upper layer
- * @hcmd_lock: protects HCMD
  * @reg_lock - protect hw register access
  * @dev - pointer to struct device * that represents the device
  * @irq - the irq number for the device
@@ -326,7 +325,6 @@ struct iwl_trans {
 	struct iwl_op_mode *op_mode;
 	struct iwl_shared *shrd;
 	enum iwl_trans_state state;
-	spinlock_t hcmd_lock;
 	spinlock_t reg_lock;
 
 	struct device *dev;
-- 
1.7.0.4

