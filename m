Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51876 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753590AbdDNJFM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Apr 2017 05:05:12 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 14 Apr 2017 12:02:10 +0300
Message-Id: <20170414090210.31397-27-luca@coelho.fi> (sfid-20170414_110519_902184_90616A0E)
In-Reply-To: <20170414090210.31397-1-luca@coelho.fi>
References: <20170414090210.31397-1-luca@coelho.fi>
Subject: [PATCH v2 26/26] iwlwifi: pcie: alloc queues dynamically
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Change queue allocation to be dynamic. On transport init only
the command queue is being allocated. Other queues are allocated
on demand.
This is due to the huge amount of queues we will soon enable (512)
and as a preparation for TX Virtual Queue Manager feature (TVQM),
where firmware will assign the actual queue number on demand.
This includes also allocation of the byte count table per queue
and not as a contiguous chunk of memory.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  13 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |   5 +-
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |   2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   5 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  | 179 +++++++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |  68 ++------
 6 files changed, 199 insertions(+), 73 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index bb7b25976e90..405ae3799f5e 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -241,6 +241,7 @@ struct iwl_pcie_first_tb_buf {
  * @wd_timeout: queue watchdog timeout (jiffies) - per queue
  * @frozen: tx stuck queue timer is frozen
  * @frozen_expiry_remainder: remember how long until the timer fires
+ * @bc_tbl: byte count table of the queue (relevant only for gen2 transport)
  * @write_ptr: 1-st empty entry (index) host_w
  * @read_ptr: last used entry (index) host_r
  * @dma_addr:  physical addr for BD's
@@ -280,6 +281,7 @@ struct iwl_txq {
 	int block;
 	unsigned long wd_timeout;
 	struct sk_buff_head overflow_q;
+	struct iwl_dma_ptr bc_tbl;
 
 	int write_ptr;
 	int read_ptr;
@@ -769,6 +771,13 @@ void iwl_pcie_txq_free_tfd(struct iwl_trans *trans, struct iwl_txq *txq);
 int iwl_queue_space(const struct iwl_txq *q);
 int iwl_pcie_apm_stop_master(struct iwl_trans *trans);
 void iwl_pcie_conf_msix_hw(struct iwl_trans_pcie *trans_pcie);
+int iwl_pcie_txq_init(struct iwl_trans *trans, struct iwl_txq *txq,
+		      int slots_num, u32 txq_id);
+int iwl_pcie_txq_alloc(struct iwl_trans *trans,
+		       struct iwl_txq *txq, int slots_num, u32 txq_id);
+int iwl_pcie_alloc_dma_ptr(struct iwl_trans *trans,
+			   struct iwl_dma_ptr *ptr, size_t size);
+void iwl_pcie_free_dma_ptr(struct iwl_trans *trans, struct iwl_dma_ptr *ptr);
 
 /* transport gen 2 exported functions */
 int iwl_trans_pcie_gen2_start_fw(struct iwl_trans *trans,
@@ -786,5 +795,7 @@ int iwl_trans_pcie_gen2_send_hcmd(struct iwl_trans *trans,
 void iwl_trans_pcie_gen2_stop_device(struct iwl_trans *trans,
 				     bool low_power);
 void _iwl_trans_pcie_gen2_stop_device(struct iwl_trans *trans, bool low_power);
-
+void iwl_pcie_gen2_txq_unmap(struct iwl_trans *trans, int txq_id);
+void iwl_pcie_gen2_tx_free(struct iwl_trans *trans);
+void iwl_pcie_gen2_tx_stop(struct iwl_trans *trans);
 #endif /* __iwl_trans_int_pcie_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 0338c5f41ce6..f98f2d2b8a1b 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1419,8 +1419,11 @@ static void iwl_pcie_irq_handle_error(struct iwl_trans *trans)
 	iwl_trans_fw_error(trans);
 	local_bh_enable();
 
-	for (i = 0; i < trans->cfg->base_params->num_of_queues; i++)
+	for (i = 0; i < trans->cfg->base_params->num_of_queues; i++) {
+		if (!trans_pcie->txq[i])
+			continue;
 		del_timer(&trans_pcie->txq[i]->stuck_timer);
+	}
 
 	clear_bit(STATUS_SYNC_HCMD_ACTIVE, &trans->status);
 	wake_up(&trans_pcie->wait_command_queue);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
index 4d5d35501fdc..ef8f563a48d9 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
@@ -177,7 +177,7 @@ void _iwl_trans_pcie_gen2_stop_device(struct iwl_trans *trans, bool low_power)
 	if (test_and_clear_bit(STATUS_DEVICE_ENABLED, &trans->status)) {
 		IWL_DEBUG_INFO(trans,
 			       "DEVICE_ENABLED bit was set and is now cleared\n");
-		iwl_pcie_tx_stop(trans);
+		iwl_pcie_gen2_tx_stop(trans);
 		iwl_pcie_rx_stop(trans);
 	}
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 6a565d35f071..ed1034e58cb4 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1813,7 +1813,10 @@ void iwl_trans_pcie_free(struct iwl_trans *trans)
 
 	iwl_pcie_synchronize_irqs(trans);
 
-	iwl_pcie_tx_free(trans);
+	if (trans->cfg->gen2)
+		iwl_pcie_gen2_tx_free(trans);
+	else
+		iwl_pcie_tx_free(trans);
 	iwl_pcie_rx_free(trans);
 
 	if (trans_pcie->msix_enabled) {
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index b938a6a3b169..446e837613a5 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -56,22 +56,42 @@
 #include "internal.h"
 #include "mvm/fw-api.h"
 
+ /*
+ * iwl_pcie_gen2_tx_stop - Stop all Tx DMA channels
+ */
+void iwl_pcie_gen2_tx_stop(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	int txq_id;
+
+	/*
+	 * This function can be called before the op_mode disabled the
+	 * queues. This happens when we have an rfkill interrupt.
+	 * Since we stop Tx altogether - mark the queues as stopped.
+	 */
+	memset(trans_pcie->queue_stopped, 0, sizeof(trans_pcie->queue_stopped));
+	memset(trans_pcie->queue_used, 0, sizeof(trans_pcie->queue_used));
+
+	/* Unmap DMA from host system and free skb's */
+	for (txq_id = 0; txq_id < ARRAY_SIZE(trans_pcie->txq); txq_id++) {
+		if (!trans_pcie->txq[txq_id])
+			continue;
+		iwl_pcie_gen2_txq_unmap(trans, txq_id);
+	}
+}
+
 /*
  * iwl_pcie_txq_update_byte_tbl - Set up entry in Tx byte-count array
  */
-static void iwl_pcie_gen2_update_byte_tbl(struct iwl_trans *trans,
-					  struct iwl_txq *txq, u16 byte_cnt,
-					   int num_tbs)
+static void iwl_pcie_gen2_update_byte_tbl(struct iwl_txq *txq, u16 byte_cnt,
+					  int num_tbs)
 {
-	struct iwlagn_scd_bc_tbl *scd_bc_tbl;
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwlagn_scd_bc_tbl *scd_bc_tbl = txq->bc_tbl.addr;
 	int write_ptr = txq->write_ptr;
 	u8 filled_tfd_size, num_fetch_chunks;
 	u16 len = byte_cnt;
 	__le16 bc_ent;
 
-	scd_bc_tbl = trans_pcie->scd_bc_tbls.addr;
-
 	len = DIV_ROUND_UP(len, 4);
 
 	if (WARN_ON(len > 0xFFF || write_ptr >= TFD_QUEUE_SIZE_MAX))
@@ -90,7 +110,7 @@ static void iwl_pcie_gen2_update_byte_tbl(struct iwl_trans *trans,
 	num_fetch_chunks = DIV_ROUND_UP(filled_tfd_size, 64) - 1;
 
 	bc_ent = cpu_to_le16(len | (num_fetch_chunks << 12));
-	scd_bc_tbl[txq->id].tfd_offset[write_ptr] = bc_ent;
+	scd_bc_tbl->tfd_offset[write_ptr] = bc_ent;
 }
 
 /*
@@ -192,7 +212,7 @@ static int iwl_pcie_gen2_set_tb(struct iwl_trans *trans,
 	struct iwl_tfh_tb *tb = &tfd->tbs[idx];
 
 	/* Each TFD can point to a maximum max_tbs Tx buffers */
-	if (tfd->num_tbs >= trans_pcie->max_tbs) {
+	if (le16_to_cpu(tfd->num_tbs) >= trans_pcie->max_tbs) {
 		IWL_ERR(trans, "Error can not send more than %d chunks\n",
 			trans_pcie->max_tbs);
 		return -EINVAL;
@@ -334,7 +354,7 @@ int iwl_trans_pcie_gen2_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	}
 
 	/* Set up entry for this TFD in Tx byte-count array */
-	iwl_pcie_gen2_update_byte_tbl(trans, txq, le16_to_cpu(tx_cmd->len),
+	iwl_pcie_gen2_update_byte_tbl(txq, le16_to_cpu(tx_cmd->len),
 				      iwl_pcie_gen2_get_num_tbs(trans, tfd));
 
 	/* start timer if queue currently empty */
@@ -781,26 +801,99 @@ void iwl_pcie_gen2_txq_unmap(struct iwl_trans *trans, int txq_id)
 	iwl_wake_queue(trans, txq);
 }
 
+/*
+ * iwl_pcie_txq_free - Deallocate DMA queue.
+ * @txq: Transmit queue to deallocate.
+ *
+ * Empty queue by removing and destroying all BD's.
+ * Free all buffers.
+ * 0-fill, but do not free "txq" descriptor structure.
+ */
+static void iwl_pcie_gen2_txq_free(struct iwl_trans *trans, int txq_id)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_txq *txq = trans_pcie->txq[txq_id];
+	struct device *dev = trans->dev;
+	int i;
+
+	if (WARN_ON(!txq))
+		return;
+
+	iwl_pcie_gen2_txq_unmap(trans, txq_id);
+
+	/* De-alloc array of command/tx buffers */
+	if (txq_id == trans_pcie->cmd_queue)
+		for (i = 0; i < txq->n_window; i++) {
+			kzfree(txq->entries[i].cmd);
+			kzfree(txq->entries[i].free_buf);
+		}
+
+	/* De-alloc circular buffer of TFDs */
+	if (txq->tfds) {
+		dma_free_coherent(dev,
+				  trans_pcie->tfd_size * TFD_QUEUE_SIZE_MAX,
+				  txq->tfds, txq->dma_addr);
+		dma_free_coherent(dev,
+				  sizeof(*txq->first_tb_bufs) * txq->n_window,
+				  txq->first_tb_bufs, txq->first_tb_dma);
+	}
+
+	kfree(txq->entries);
+
+	del_timer_sync(&txq->stuck_timer);
+
+	iwl_pcie_free_dma_ptr(trans, &txq->bc_tbl);
+	kfree(txq);
+	trans_pcie->txq[txq_id] = NULL;
+
+	clear_bit(txq_id, trans_pcie->queue_used);
+}
+
 int iwl_trans_pcie_dyn_txq_alloc(struct iwl_trans *trans,
 				 struct iwl_tx_queue_cfg_cmd *cmd,
 				 int cmd_id,
 				 unsigned int timeout)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_txq *txq = trans_pcie->txq[cmd->scd_queue];
+	struct iwl_txq *txq;
 	struct iwl_host_cmd hcmd = {
 		.id = cmd_id,
 		.len = { sizeof(*cmd) },
 		.data = { cmd, },
 		.flags = 0,
 	};
+	int ret, qid = cmd->scd_queue;
 	u16 ssn = le16_to_cpu(cmd->ssn);
 
+	txq = kzalloc(sizeof(*txq), GFP_KERNEL);
+	if (!txq)
+		return -ENOMEM;
+	ret = iwl_pcie_alloc_dma_ptr(trans, &txq->bc_tbl,
+				     sizeof(struct iwlagn_scd_bc_tbl));
+	if (ret) {
+		IWL_ERR(trans, "Scheduler BC Table allocation failed\n");
+		kfree(txq);
+		return -ENOMEM;
+	}
+
 	if (test_and_set_bit(cmd->scd_queue, trans_pcie->queue_used)) {
 		WARN_ONCE(1, "queue %d already used", cmd->scd_queue);
 		return -EINVAL;
 	}
 
+	trans_pcie->txq[qid] = txq;
+
+	ret = iwl_pcie_txq_alloc(trans, txq, TFD_TX_CMD_SLOTS, qid);
+	if (ret) {
+		IWL_ERR(trans, "Tx %d queue init failed\n", qid);
+		goto error;
+	}
+	ret = iwl_pcie_txq_init(trans, txq, TFD_TX_CMD_SLOTS, qid);
+	if (ret) {
+		IWL_ERR(trans, "Tx %d queue alloc failed\n", qid);
+		goto error;
+	}
+
 	txq->wd_timeout = msecs_to_jiffies(timeout);
 
 	/*
@@ -816,12 +909,14 @@ int iwl_trans_pcie_dyn_txq_alloc(struct iwl_trans *trans,
 			    cmd->scd_queue, ssn & 0xff);
 
 	cmd->tfdq_addr = cpu_to_le64(txq->dma_addr);
-	cmd->byte_cnt_addr = cpu_to_le64(trans_pcie->scd_bc_tbls.dma +
-					 cmd->scd_queue *
-					 sizeof(struct iwlagn_scd_bc_tbl));
-	cmd->cb_size = cpu_to_le64(TFD_QUEUE_CB_SIZE(TFD_QUEUE_SIZE_MAX));
+	cmd->byte_cnt_addr = cpu_to_le64(txq->bc_tbl.dma);
+	cmd->cb_size = cpu_to_le32(TFD_QUEUE_CB_SIZE(TFD_QUEUE_SIZE_MAX));
 
 	return iwl_trans_send_cmd(trans, &hcmd);
+
+error:
+	iwl_pcie_gen2_txq_free(trans, cmd->scd_queue);
+	return -ENOMEM;
 }
 
 void iwl_trans_pcie_dyn_txq_free(struct iwl_trans *trans, int queue)
@@ -845,3 +940,57 @@ void iwl_trans_pcie_dyn_txq_free(struct iwl_trans *trans, int queue)
 	IWL_DEBUG_TX_QUEUES(trans, "Deactivate queue %d\n", queue);
 }
 
+void iwl_pcie_gen2_tx_free(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	int i;
+
+	memset(trans_pcie->queue_used, 0, sizeof(trans_pcie->queue_used));
+
+	/* Free all TX queues */
+	for (i = 0; i < ARRAY_SIZE(trans_pcie->txq); i++) {
+		if (!trans_pcie->txq[i])
+			continue;
+
+		iwl_pcie_gen2_txq_free(trans, i);
+	}
+}
+
+int iwl_pcie_gen2_tx_init(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_txq *cmd_queue;
+	int txq_id = trans_pcie->cmd_queue, ret;
+
+	/* alloc and init the command queue */
+	if (!trans_pcie->txq[txq_id]) {
+		cmd_queue = kzalloc(sizeof(*cmd_queue), GFP_KERNEL);
+		if (!cmd_queue) {
+			IWL_ERR(trans, "Not enough memory for command queue\n");
+			return -ENOMEM;
+		}
+		trans_pcie->txq[txq_id] = cmd_queue;
+		ret = iwl_pcie_txq_alloc(trans, cmd_queue, TFD_CMD_SLOTS,
+					 txq_id);
+		if (ret) {
+			IWL_ERR(trans, "Tx %d queue init failed\n", txq_id);
+			goto error;
+		}
+	} else {
+		cmd_queue = trans_pcie->txq[txq_id];
+	}
+
+	ret = iwl_pcie_txq_init(trans, cmd_queue, TFD_CMD_SLOTS, txq_id);
+	if (ret) {
+		IWL_ERR(trans, "Tx %d queue alloc failed\n", txq_id);
+		goto error;
+	}
+	set_bit(txq_id, trans_pcie->queue_used);
+
+	return 0;
+
+error:
+	iwl_pcie_gen2_tx_free(trans);
+	return ret;
+}
+
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 9ea92ac3920e..df31e14bc33d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -126,8 +126,8 @@ static int iwl_queue_init(struct iwl_txq *q, int slots_num, u32 id)
 	return 0;
 }
 
-static int iwl_pcie_alloc_dma_ptr(struct iwl_trans *trans,
-				  struct iwl_dma_ptr *ptr, size_t size)
+int iwl_pcie_alloc_dma_ptr(struct iwl_trans *trans,
+			   struct iwl_dma_ptr *ptr, size_t size)
 {
 	if (WARN_ON(ptr->addr))
 		return -EINVAL;
@@ -140,8 +140,7 @@ static int iwl_pcie_alloc_dma_ptr(struct iwl_trans *trans,
 	return 0;
 }
 
-static void iwl_pcie_free_dma_ptr(struct iwl_trans *trans,
-				  struct iwl_dma_ptr *ptr)
+void iwl_pcie_free_dma_ptr(struct iwl_trans *trans, struct iwl_dma_ptr *ptr)
 {
 	if (unlikely(!ptr->addr))
 		return;
@@ -484,9 +483,8 @@ static int iwl_pcie_txq_build_tfd(struct iwl_trans *trans, struct iwl_txq *txq,
 	return num_tbs;
 }
 
-static int iwl_pcie_txq_alloc(struct iwl_trans *trans,
-			       struct iwl_txq *txq, int slots_num,
-			       u32 txq_id)
+int iwl_pcie_txq_alloc(struct iwl_trans *trans, struct iwl_txq *txq,
+		       int slots_num, u32 txq_id)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	size_t tfd_sz = trans_pcie->tfd_size * TFD_QUEUE_SIZE_MAX;
@@ -551,8 +549,8 @@ static int iwl_pcie_txq_alloc(struct iwl_trans *trans,
 
 }
 
-static int iwl_pcie_txq_init(struct iwl_trans *trans, struct iwl_txq *txq,
-			      int slots_num, u32 txq_id)
+int iwl_pcie_txq_init(struct iwl_trans *trans, struct iwl_txq *txq,
+		      int slots_num, u32 txq_id)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int ret;
@@ -778,6 +776,13 @@ void iwl_trans_pcie_tx_reset(struct iwl_trans *trans)
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int txq_id;
 
+	/*
+	 * we should never get here in gen2 trans mode return early to avoid
+	 * having invalid accesses
+	 */
+	if (WARN_ON_ONCE(trans->cfg->gen2))
+		return;
+
 	for (txq_id = 0; txq_id < trans->cfg->base_params->num_of_queues;
 	     txq_id++) {
 		struct iwl_txq *txq = trans_pcie->txq[txq_id];
@@ -1025,51 +1030,6 @@ int iwl_pcie_tx_init(struct iwl_trans *trans)
 	return ret;
 }
 
-int iwl_pcie_gen2_tx_init(struct iwl_trans *trans)
-{
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	int ret;
-	int txq_id, slots_num;
-	bool alloc = false;
-
-	if (!trans_pcie->txq_memory) {
-		/* TODO: change this when moving to new TX alloc model */
-		ret = iwl_pcie_tx_alloc(trans);
-		if (ret)
-			goto error;
-		alloc = true;
-	}
-
-	spin_lock(&trans_pcie->irq_lock);
-
-	/* Tell NIC where to find the "keep warm" buffer */
-	iwl_write_direct32(trans, FH_KW_MEM_ADDR_REG,
-			   trans_pcie->kw.dma >> 4);
-
-	spin_unlock(&trans_pcie->irq_lock);
-
-	/* TODO: remove this when moving to new TX alloc model */
-	for (txq_id = 0; txq_id < trans->cfg->base_params->num_of_queues;
-	     txq_id++) {
-		slots_num = (txq_id == trans_pcie->cmd_queue) ?
-					TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
-		ret = iwl_pcie_txq_init(trans, trans_pcie->txq[txq_id],
-					slots_num, txq_id);
-		if (ret) {
-			IWL_ERR(trans, "Tx %d queue init failed\n", txq_id);
-			goto error;
-		}
-	}
-
-	return 0;
-
-error:
-	/* Upon error, free only if we allocated something */
-	if (alloc)
-		iwl_pcie_tx_free(trans);
-	return ret;
-}
-
 static inline void iwl_pcie_txq_progress(struct iwl_txq *txq)
 {
 	lockdep_assert_held(&txq->lock);
-- 
2.11.0
