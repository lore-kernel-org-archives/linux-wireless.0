Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51486 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755057AbdDMP2J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 11:28:09 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 13 Apr 2017 18:25:05 +0300
Message-Id: <20170413152507.9648-25-luca@coelho.fi> (sfid-20170413_172856_287917_BDCED084)
In-Reply-To: <20170413152507.9648-1-luca@coelho.fi>
References: <20170413152507.9648-1-luca@coelho.fi>
Subject: [PATCH 24/26] iwlwifi: pcie: prepare for dynamic queue allocation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

In a000 transport we will allocate queues dynamically.
Right now queue are allocated as one big chunk of memory
and accessed as such.
The dynamic allocation of the queues will require accessing
the queues as pointers.
In order to keep simplicity of pre-a000 tx queues handling,
keep allocating and freeing the memory in the same style,
but move to access the queues in the various functions as
individual pointers.
Dynamic allocation for the a000 devices will be in a separate
patch.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/pcie/ctxt-info.c    |  2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  3 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |  4 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    | 12 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  | 14 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       | 81 +++++++++++-----------
 6 files changed, 58 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
index 312ee0481ec5..854d61888f4d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
@@ -235,7 +235,7 @@ int iwl_pcie_ctxt_info_init(struct iwl_trans *trans,
 
 	/* initialize TX command queue */
 	ctxt_info->hcmd_cfg.cmd_queue_addr =
-		cpu_to_le64(trans_pcie->txq[trans_pcie->cmd_queue].dma_addr);
+		cpu_to_le64(trans_pcie->txq[trans_pcie->cmd_queue]->dma_addr);
 	ctxt_info->hcmd_cfg.cmd_queue_size =
 		TFD_QUEUE_CB_SIZE(TFD_QUEUE_SIZE_MAX);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 2266f3aa67aa..cdc2b0a938a1 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -411,7 +411,8 @@ struct iwl_trans_pcie {
 	struct iwl_dma_ptr scd_bc_tbls;
 	struct iwl_dma_ptr kw;
 
-	struct iwl_txq *txq;
+	struct iwl_txq *txq_memory;
+	struct iwl_txq *txq[IWL_MAX_HW_QUEUES];
 	unsigned long queue_used[BITS_TO_LONGS(IWL_MAX_HW_QUEUES)];
 	unsigned long queue_stopped[BITS_TO_LONGS(IWL_MAX_HW_QUEUES)];
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index c6178d36698c..0338c5f41ce6 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1094,7 +1094,7 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 				bool emergency)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_txq *txq = &trans_pcie->txq[trans_pcie->cmd_queue];
+	struct iwl_txq *txq = trans_pcie->txq[trans_pcie->cmd_queue];
 	bool page_stolen = false;
 	int max_len = PAGE_SIZE << trans_pcie->rx_page_order;
 	u32 offset = 0;
@@ -1420,7 +1420,7 @@ static void iwl_pcie_irq_handle_error(struct iwl_trans *trans)
 	local_bh_enable();
 
 	for (i = 0; i < trans->cfg->base_params->num_of_queues; i++)
-		del_timer(&trans_pcie->txq[i].stuck_timer);
+		del_timer(&trans_pcie->txq[i]->stuck_timer);
 
 	clear_bit(STATUS_SYNC_HCMD_ACTIVE, &trans->status);
 	wake_up(&trans_pcie->wait_command_queue);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index d39ca944f484..ccc9280d845a 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1983,7 +1983,7 @@ static void iwl_trans_pcie_freeze_txq_timer(struct iwl_trans *trans,
 	int queue;
 
 	for_each_set_bit(queue, &txqs, BITS_PER_LONG) {
-		struct iwl_txq *txq = &trans_pcie->txq[queue];
+		struct iwl_txq *txq = trans_pcie->txq[queue];
 		unsigned long now;
 
 		spin_lock_bh(&txq->lock);
@@ -2035,7 +2035,7 @@ static void iwl_trans_pcie_block_txq_ptrs(struct iwl_trans *trans, bool block)
 	int i;
 
 	for (i = 0; i < trans->cfg->base_params->num_of_queues; i++) {
-		struct iwl_txq *txq = &trans_pcie->txq[i];
+		struct iwl_txq *txq = trans_pcie->txq[i];
 
 		if (i == trans_pcie->cmd_queue)
 			continue;
@@ -2108,7 +2108,7 @@ static int iwl_trans_pcie_wait_txq_empty(struct iwl_trans *trans, u32 txq_bm)
 			continue;
 
 		IWL_DEBUG_TX_QUEUES(trans, "Emptying queue %d...\n", cnt);
-		txq = &trans_pcie->txq[cnt];
+		txq = trans_pcie->txq[cnt];
 		wr_ptr = ACCESS_ONCE(txq->write_ptr);
 
 		while (txq->read_ptr != ACCESS_ONCE(txq->write_ptr) &&
@@ -2299,7 +2299,7 @@ static ssize_t iwl_dbgfs_tx_queue_read(struct file *file,
 
 	bufsz = sizeof(char) * 75 * trans->cfg->base_params->num_of_queues;
 
-	if (!trans_pcie->txq)
+	if (!trans_pcie->txq_memory)
 		return -EAGAIN;
 
 	buf = kzalloc(bufsz, GFP_KERNEL);
@@ -2307,7 +2307,7 @@ static ssize_t iwl_dbgfs_tx_queue_read(struct file *file,
 		return -ENOMEM;
 
 	for (cnt = 0; cnt < trans->cfg->base_params->num_of_queues; cnt++) {
-		txq = &trans_pcie->txq[cnt];
+		txq = trans_pcie->txq[cnt];
 		pos += scnprintf(buf + pos, bufsz - pos,
 				"hwq %.2d: read=%u write=%u use=%d stop=%d need_update=%d frozen=%d%s\n",
 				cnt, txq->read_ptr, txq->write_ptr,
@@ -2724,7 +2724,7 @@ static struct iwl_trans_dump_data
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_fw_error_dump_data *data;
-	struct iwl_txq *cmdq = &trans_pcie->txq[trans_pcie->cmd_queue];
+	struct iwl_txq *cmdq = trans_pcie->txq[trans_pcie->cmd_queue];
 	struct iwl_fw_error_dump_txcmd *txcmd;
 	struct iwl_trans_dump_data *dump_data;
 	u32 len, num_rbs;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index 2019ccda31c4..b938a6a3b169 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -301,7 +301,7 @@ int iwl_trans_pcie_gen2_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_tx_cmd_gen2 *tx_cmd = (void *)dev_cmd->payload;
 	struct iwl_cmd_meta *out_meta;
-	struct iwl_txq *txq = &trans_pcie->txq[txq_id];
+	struct iwl_txq *txq = trans_pcie->txq[txq_id];
 	void *tfd;
 
 	if (WARN_ONCE(!test_bit(txq_id, trans_pcie->queue_used),
@@ -374,7 +374,7 @@ static int iwl_pcie_gen2_enqueue_hcmd(struct iwl_trans *trans,
 				      struct iwl_host_cmd *cmd)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_txq *txq = &trans_pcie->txq[trans_pcie->cmd_queue];
+	struct iwl_txq *txq = trans_pcie->txq[trans_pcie->cmd_queue];
 	struct iwl_device_cmd *out_cmd;
 	struct iwl_cmd_meta *out_meta;
 	unsigned long flags;
@@ -617,6 +617,7 @@ static int iwl_pcie_gen2_send_hcmd_sync(struct iwl_trans *trans,
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	const char *cmd_str = iwl_get_cmd_string(trans, cmd->id);
+	struct iwl_txq *txq = trans_pcie->txq[trans_pcie->cmd_queue];
 	int cmd_idx;
 	int ret;
 
@@ -653,8 +654,6 @@ static int iwl_pcie_gen2_send_hcmd_sync(struct iwl_trans *trans,
 					   &trans->status),
 				 HOST_COMPLETE_TIMEOUT);
 	if (!ret) {
-		struct iwl_txq *txq = &trans_pcie->txq[trans_pcie->cmd_queue];
-
 		IWL_ERR(trans, "Error sending %s: time out after %dms.\n",
 			cmd_str, jiffies_to_msecs(HOST_COMPLETE_TIMEOUT));
 
@@ -702,8 +701,7 @@ static int iwl_pcie_gen2_send_hcmd_sync(struct iwl_trans *trans,
 		 * in later, it will possibly set an invalid
 		 * address (cmd->meta.source).
 		 */
-		trans_pcie->txq[trans_pcie->cmd_queue].
-			entries[cmd_idx].meta.flags &= ~CMD_WANT_SKB;
+		txq->entries[cmd_idx].meta.flags &= ~CMD_WANT_SKB;
 	}
 
 	if (cmd->resp_pkt) {
@@ -750,7 +748,7 @@ int iwl_trans_pcie_gen2_send_hcmd(struct iwl_trans *trans,
 void iwl_pcie_gen2_txq_unmap(struct iwl_trans *trans, int txq_id)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_txq *txq = &trans_pcie->txq[txq_id];
+	struct iwl_txq *txq = trans_pcie->txq[txq_id];
 
 	spin_lock_bh(&txq->lock);
 	while (txq->write_ptr != txq->read_ptr) {
@@ -789,7 +787,7 @@ int iwl_trans_pcie_dyn_txq_alloc(struct iwl_trans *trans,
 				 unsigned int timeout)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_txq *txq = &trans_pcie->txq[cmd->scd_queue];
+	struct iwl_txq *txq = trans_pcie->txq[cmd->scd_queue];
 	struct iwl_host_cmd hcmd = {
 		.id = cmd_id,
 		.len = { sizeof(*cmd) },
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 5af6eb98eb43..9ea92ac3920e 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -298,12 +298,12 @@ void iwl_pcie_txq_check_wrptrs(struct iwl_trans *trans)
 	int i;
 
 	for (i = 0; i < trans->cfg->base_params->num_of_queues; i++) {
-		struct iwl_txq *txq = &trans_pcie->txq[i];
+		struct iwl_txq *txq = trans_pcie->txq[i];
 
 		spin_lock_bh(&txq->lock);
-		if (trans_pcie->txq[i].need_update) {
+		if (txq->need_update) {
 			iwl_pcie_txq_inc_wr_ptr(trans, txq);
-			trans_pcie->txq[i].need_update = false;
+			txq->need_update = false;
 		}
 		spin_unlock_bh(&txq->lock);
 	}
@@ -622,7 +622,7 @@ static void iwl_pcie_clear_cmd_in_flight(struct iwl_trans *trans)
 static void iwl_pcie_txq_unmap(struct iwl_trans *trans, int txq_id)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_txq *txq = &trans_pcie->txq[txq_id];
+	struct iwl_txq *txq = trans_pcie->txq[txq_id];
 
 	spin_lock_bh(&txq->lock);
 	while (txq->write_ptr != txq->read_ptr) {
@@ -678,7 +678,7 @@ static void iwl_pcie_txq_unmap(struct iwl_trans *trans, int txq_id)
 static void iwl_pcie_txq_free(struct iwl_trans *trans, int txq_id)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_txq *txq = &trans_pcie->txq[txq_id];
+	struct iwl_txq *txq = trans_pcie->txq[txq_id];
 	struct device *dev = trans->dev;
 	int i;
 
@@ -780,7 +780,7 @@ void iwl_trans_pcie_tx_reset(struct iwl_trans *trans)
 
 	for (txq_id = 0; txq_id < trans->cfg->base_params->num_of_queues;
 	     txq_id++) {
-		struct iwl_txq *txq = &trans_pcie->txq[txq_id];
+		struct iwl_txq *txq = trans_pcie->txq[txq_id];
 		if (trans->cfg->use_tfh)
 			iwl_write_direct64(trans,
 					   FH_MEM_CBBC_QUEUE(trans, txq_id),
@@ -860,7 +860,7 @@ int iwl_pcie_tx_stop(struct iwl_trans *trans)
 	memset(trans_pcie->queue_used, 0, sizeof(trans_pcie->queue_used));
 
 	/* This can happen: start_hw, stop_device */
-	if (!trans_pcie->txq)
+	if (!trans_pcie->txq_memory)
 		return 0;
 
 	/* Unmap DMA from host system and free skb's */
@@ -884,14 +884,17 @@ void iwl_pcie_tx_free(struct iwl_trans *trans)
 	memset(trans_pcie->queue_used, 0, sizeof(trans_pcie->queue_used));
 
 	/* Tx queues */
-	if (trans_pcie->txq) {
+	if (trans_pcie->txq_memory) {
 		for (txq_id = 0;
-		     txq_id < trans->cfg->base_params->num_of_queues; txq_id++)
+		     txq_id < trans->cfg->base_params->num_of_queues;
+		     txq_id++) {
 			iwl_pcie_txq_free(trans, txq_id);
+			trans_pcie->txq[txq_id] = NULL;
+		}
 	}
 
-	kfree(trans_pcie->txq);
-	trans_pcie->txq = NULL;
+	kfree(trans_pcie->txq_memory);
+	trans_pcie->txq_memory = NULL;
 
 	iwl_pcie_free_dma_ptr(trans, &trans_pcie->kw);
 
@@ -913,7 +916,7 @@ static int iwl_pcie_tx_alloc(struct iwl_trans *trans)
 
 	/*It is not allowed to alloc twice, so warn when this happens.
 	 * We cannot rely on the previous allocation, so free and fail */
-	if (WARN_ON(trans_pcie->txq)) {
+	if (WARN_ON(trans_pcie->txq_memory)) {
 		ret = -EINVAL;
 		goto error;
 	}
@@ -932,9 +935,9 @@ static int iwl_pcie_tx_alloc(struct iwl_trans *trans)
 		goto error;
 	}
 
-	trans_pcie->txq = kcalloc(trans->cfg->base_params->num_of_queues,
-				  sizeof(struct iwl_txq), GFP_KERNEL);
-	if (!trans_pcie->txq) {
+	trans_pcie->txq_memory = kcalloc(trans->cfg->base_params->num_of_queues,
+					 sizeof(struct iwl_txq), GFP_KERNEL);
+	if (!trans_pcie->txq_memory) {
 		IWL_ERR(trans, "Not enough memory for txq\n");
 		ret = -ENOMEM;
 		goto error;
@@ -945,8 +948,9 @@ static int iwl_pcie_tx_alloc(struct iwl_trans *trans)
 	     txq_id++) {
 		slots_num = (txq_id == trans_pcie->cmd_queue) ?
 					TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
-		ret = iwl_pcie_txq_alloc(trans, &trans_pcie->txq[txq_id],
-					  slots_num, txq_id);
+		trans_pcie->txq[txq_id] = &trans_pcie->txq_memory[txq_id];
+		ret = iwl_pcie_txq_alloc(trans, trans_pcie->txq[txq_id],
+					 slots_num, txq_id);
 		if (ret) {
 			IWL_ERR(trans, "Tx %d queue alloc failed\n", txq_id);
 			goto error;
@@ -968,7 +972,7 @@ int iwl_pcie_tx_init(struct iwl_trans *trans)
 	int txq_id, slots_num;
 	bool alloc = false;
 
-	if (!trans_pcie->txq) {
+	if (!trans_pcie->txq_memory) {
 		ret = iwl_pcie_tx_alloc(trans);
 		if (ret)
 			goto error;
@@ -991,8 +995,8 @@ int iwl_pcie_tx_init(struct iwl_trans *trans)
 	     txq_id++) {
 		slots_num = (txq_id == trans_pcie->cmd_queue) ?
 					TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
-		ret = iwl_pcie_txq_init(trans, &trans_pcie->txq[txq_id],
-					 slots_num, txq_id);
+		ret = iwl_pcie_txq_init(trans, trans_pcie->txq[txq_id],
+					slots_num, txq_id);
 		if (ret) {
 			IWL_ERR(trans, "Tx %d queue init failed\n", txq_id);
 			goto error;
@@ -1005,7 +1009,7 @@ int iwl_pcie_tx_init(struct iwl_trans *trans)
 		 * Circular buffer (TFD queue in DRAM) physical base address
 		 */
 		iwl_write_direct32(trans, FH_MEM_CBBC_QUEUE(trans, txq_id),
-				   trans_pcie->txq[txq_id].dma_addr >> 8);
+				   trans_pcie->txq[txq_id]->dma_addr >> 8);
 	}
 
 	iwl_set_bits_prph(trans, SCD_GP_CTRL, SCD_GP_CTRL_AUTO_ACTIVE_MODE);
@@ -1028,7 +1032,7 @@ int iwl_pcie_gen2_tx_init(struct iwl_trans *trans)
 	int txq_id, slots_num;
 	bool alloc = false;
 
-	if (!trans_pcie->txq) {
+	if (!trans_pcie->txq_memory) {
 		/* TODO: change this when moving to new TX alloc model */
 		ret = iwl_pcie_tx_alloc(trans);
 		if (ret)
@@ -1049,7 +1053,7 @@ int iwl_pcie_gen2_tx_init(struct iwl_trans *trans)
 	     txq_id++) {
 		slots_num = (txq_id == trans_pcie->cmd_queue) ?
 					TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
-		ret = iwl_pcie_txq_init(trans, &trans_pcie->txq[txq_id],
+		ret = iwl_pcie_txq_init(trans, trans_pcie->txq[txq_id],
 					slots_num, txq_id);
 		if (ret) {
 			IWL_ERR(trans, "Tx %d queue init failed\n", txq_id);
@@ -1095,7 +1099,7 @@ void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 			    struct sk_buff_head *skbs)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_txq *txq = &trans_pcie->txq[txq_id];
+	struct iwl_txq *txq = trans_pcie->txq[txq_id];
 	int tfd_num = ssn & (TFD_QUEUE_SIZE_MAX - 1);
 	int last_to_free;
 
@@ -1252,7 +1256,7 @@ static int iwl_pcie_set_cmd_in_flight(struct iwl_trans *trans,
 static void iwl_pcie_cmdq_reclaim(struct iwl_trans *trans, int txq_id, int idx)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_txq *txq = &trans_pcie->txq[txq_id];
+	struct iwl_txq *txq = trans_pcie->txq[txq_id];
 	unsigned long flags;
 	int nfreed = 0;
 
@@ -1319,7 +1323,7 @@ void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, u16 ssn,
 			       unsigned int wdg_timeout)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_txq *txq = &trans_pcie->txq[txq_id];
+	struct iwl_txq *txq = trans_pcie->txq[txq_id];
 	int fifo = -1;
 
 	if (test_and_set_bit(txq_id, trans_pcie->queue_used))
@@ -1412,7 +1416,7 @@ void iwl_trans_pcie_txq_set_shared_mode(struct iwl_trans *trans, u32 txq_id,
 					bool shared_mode)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_txq *txq = &trans_pcie->txq[txq_id];
+	struct iwl_txq *txq = trans_pcie->txq[txq_id];
 
 	txq->ampdu = !shared_mode;
 }
@@ -1425,8 +1429,8 @@ void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int txq_id,
 			SCD_TX_STTS_QUEUE_OFFSET(txq_id);
 	static const u32 zero_val[4] = {};
 
-	trans_pcie->txq[txq_id].frozen_expiry_remainder = 0;
-	trans_pcie->txq[txq_id].frozen = false;
+	trans_pcie->txq[txq_id]->frozen_expiry_remainder = 0;
+	trans_pcie->txq[txq_id]->frozen = false;
 
 	/*
 	 * Upon HW Rfkill - we stop the device, and then stop the queues
@@ -1448,7 +1452,7 @@ void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int txq_id,
 	}
 
 	iwl_pcie_txq_unmap(trans, txq_id);
-	trans_pcie->txq[txq_id].ampdu = false;
+	trans_pcie->txq[txq_id]->ampdu = false;
 
 	IWL_DEBUG_TX_QUEUES(trans, "Deactivate queue %d\n", txq_id);
 }
@@ -1468,7 +1472,7 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 				 struct iwl_host_cmd *cmd)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_txq *txq = &trans_pcie->txq[trans_pcie->cmd_queue];
+	struct iwl_txq *txq = trans_pcie->txq[trans_pcie->cmd_queue];
 	struct iwl_device_cmd *out_cmd;
 	struct iwl_cmd_meta *out_meta;
 	unsigned long flags;
@@ -1753,16 +1757,15 @@ void iwl_pcie_hcmd_complete(struct iwl_trans *trans,
 	struct iwl_device_cmd *cmd;
 	struct iwl_cmd_meta *meta;
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_txq *txq = &trans_pcie->txq[trans_pcie->cmd_queue];
+	struct iwl_txq *txq = trans_pcie->txq[trans_pcie->cmd_queue];
 
 	/* If a Tx command is being handled and it isn't in the actual
 	 * command queue then there a command routing bug has been introduced
 	 * in the queue management code. */
 	if (WARN(txq_id != trans_pcie->cmd_queue,
 		 "wrong command queue %d (should be %d), sequence 0x%X readp=%d writep=%d\n",
-		 txq_id, trans_pcie->cmd_queue, sequence,
-		 trans_pcie->txq[trans_pcie->cmd_queue].read_ptr,
-		 trans_pcie->txq[trans_pcie->cmd_queue].write_ptr)) {
+		 txq_id, trans_pcie->cmd_queue, sequence, txq->read_ptr,
+		 txq->write_ptr)) {
 		iwl_print_hex_error(trans, pkt, 32);
 		return;
 	}
@@ -1846,6 +1849,7 @@ static int iwl_pcie_send_hcmd_sync(struct iwl_trans *trans,
 				   struct iwl_host_cmd *cmd)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_txq *txq = trans_pcie->txq[trans_pcie->cmd_queue];
 	int cmd_idx;
 	int ret;
 
@@ -1886,8 +1890,6 @@ static int iwl_pcie_send_hcmd_sync(struct iwl_trans *trans,
 					   &trans->status),
 				 HOST_COMPLETE_TIMEOUT);
 	if (!ret) {
-		struct iwl_txq *txq = &trans_pcie->txq[trans_pcie->cmd_queue];
-
 		IWL_ERR(trans, "Error sending %s: time out after %dms.\n",
 			iwl_get_cmd_string(trans, cmd->id),
 			jiffies_to_msecs(HOST_COMPLETE_TIMEOUT));
@@ -1938,8 +1940,7 @@ static int iwl_pcie_send_hcmd_sync(struct iwl_trans *trans,
 		 * in later, it will possibly set an invalid
 		 * address (cmd->meta.source).
 		 */
-		trans_pcie->txq[trans_pcie->cmd_queue].
-			entries[cmd_idx].meta.flags &= ~CMD_WANT_SKB;
+		txq->entries[cmd_idx].meta.flags &= ~CMD_WANT_SKB;
 	}
 
 	if (cmd->resp_pkt) {
@@ -2293,7 +2294,7 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	u16 wifi_seq;
 	bool amsdu;
 
-	txq = &trans_pcie->txq[txq_id];
+	txq = trans_pcie->txq[txq_id];
 
 	if (WARN_ONCE(!test_bit(txq_id, trans_pcie->queue_used),
 		      "TX on unused queue %d\n", txq_id))
-- 
2.11.0
