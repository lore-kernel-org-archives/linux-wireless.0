Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:52700 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756996AbdDRWRp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 18:17:45 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Apr 2017 01:17:07 +0300
Message-Id: <20170418221729.28372-4-luca@coelho.fi> (sfid-20170419_001755_437313_F40D20F8)
In-Reply-To: <20170418221729.28372-1-luca@coelho.fi>
References: <20170418221729.28372-1-luca@coelho.fi>
Subject: [PATCH 03/25] iwlwifi: pcie: get rid of txq id assignment
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

In TVQM mode the queue ID is assigned after enablement.
Get rid of assuming pre-defined TX queue ID in functions
that will be used by TVQM allocation path.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  4 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  | 50 +++++++++++++---------
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       | 33 +++++++-------
 3 files changed, 47 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 405ae3799f5e..b9e9e10c32fa 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -772,9 +772,9 @@ int iwl_queue_space(const struct iwl_txq *q);
 int iwl_pcie_apm_stop_master(struct iwl_trans *trans);
 void iwl_pcie_conf_msix_hw(struct iwl_trans_pcie *trans_pcie);
 int iwl_pcie_txq_init(struct iwl_trans *trans, struct iwl_txq *txq,
-		      int slots_num, u32 txq_id);
+		      int slots_num, bool cmd_queue);
 int iwl_pcie_txq_alloc(struct iwl_trans *trans,
-		       struct iwl_txq *txq, int slots_num, u32 txq_id);
+		       struct iwl_txq *txq, int slots_num,  bool cmd_queue);
 int iwl_pcie_alloc_dma_ptr(struct iwl_trans *trans,
 			   struct iwl_dma_ptr *ptr, size_t size);
 void iwl_pcie_free_dma_ptr(struct iwl_trans *trans, struct iwl_dma_ptr *ptr);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index 446e837613a5..0bc9522cf364 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -801,6 +801,27 @@ void iwl_pcie_gen2_txq_unmap(struct iwl_trans *trans, int txq_id)
 	iwl_wake_queue(trans, txq);
 }
 
+static void iwl_pcie_gen2_txq_free_memory(struct iwl_trans *trans,
+					  struct iwl_txq *txq)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct device *dev = trans->dev;
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
+	iwl_pcie_free_dma_ptr(trans, &txq->bc_tbl);
+	kfree(txq);
+}
+
 /*
  * iwl_pcie_txq_free - Deallocate DMA queue.
  * @txq: Transmit queue to deallocate.
@@ -813,7 +834,6 @@ static void iwl_pcie_gen2_txq_free(struct iwl_trans *trans, int txq_id)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_txq *txq = trans_pcie->txq[txq_id];
-	struct device *dev = trans->dev;
 	int i;
 
 	if (WARN_ON(!txq))
@@ -827,23 +847,10 @@ static void iwl_pcie_gen2_txq_free(struct iwl_trans *trans, int txq_id)
 			kzfree(txq->entries[i].cmd);
 			kzfree(txq->entries[i].free_buf);
 		}
-
-	/* De-alloc circular buffer of TFDs */
-	if (txq->tfds) {
-		dma_free_coherent(dev,
-				  trans_pcie->tfd_size * TFD_QUEUE_SIZE_MAX,
-				  txq->tfds, txq->dma_addr);
-		dma_free_coherent(dev,
-				  sizeof(*txq->first_tb_bufs) * txq->n_window,
-				  txq->first_tb_bufs, txq->first_tb_dma);
-	}
-
-	kfree(txq->entries);
-
 	del_timer_sync(&txq->stuck_timer);
 
-	iwl_pcie_free_dma_ptr(trans, &txq->bc_tbl);
-	kfree(txq);
+	iwl_pcie_gen2_txq_free_memory(trans, txq);
+
 	trans_pcie->txq[txq_id] = NULL;
 
 	clear_bit(txq_id, trans_pcie->queue_used);
@@ -882,13 +889,14 @@ int iwl_trans_pcie_dyn_txq_alloc(struct iwl_trans *trans,
 	}
 
 	trans_pcie->txq[qid] = txq;
+	trans_pcie->txq[qid]->id = qid;
 
-	ret = iwl_pcie_txq_alloc(trans, txq, TFD_TX_CMD_SLOTS, qid);
+	ret = iwl_pcie_txq_alloc(trans, txq, TFD_TX_CMD_SLOTS, false);
 	if (ret) {
 		IWL_ERR(trans, "Tx %d queue init failed\n", qid);
 		goto error;
 	}
-	ret = iwl_pcie_txq_init(trans, txq, TFD_TX_CMD_SLOTS, qid);
+	ret = iwl_pcie_txq_init(trans, txq, TFD_TX_CMD_SLOTS, false);
 	if (ret) {
 		IWL_ERR(trans, "Tx %d queue alloc failed\n", qid);
 		goto error;
@@ -970,8 +978,7 @@ int iwl_pcie_gen2_tx_init(struct iwl_trans *trans)
 			return -ENOMEM;
 		}
 		trans_pcie->txq[txq_id] = cmd_queue;
-		ret = iwl_pcie_txq_alloc(trans, cmd_queue, TFD_CMD_SLOTS,
-					 txq_id);
+		ret = iwl_pcie_txq_alloc(trans, cmd_queue, TFD_CMD_SLOTS, true);
 		if (ret) {
 			IWL_ERR(trans, "Tx %d queue init failed\n", txq_id);
 			goto error;
@@ -980,11 +987,12 @@ int iwl_pcie_gen2_tx_init(struct iwl_trans *trans)
 		cmd_queue = trans_pcie->txq[txq_id];
 	}
 
-	ret = iwl_pcie_txq_init(trans, cmd_queue, TFD_CMD_SLOTS, txq_id);
+	ret = iwl_pcie_txq_init(trans, cmd_queue, TFD_CMD_SLOTS, true);
 	if (ret) {
 		IWL_ERR(trans, "Tx %d queue alloc failed\n", txq_id);
 		goto error;
 	}
+	trans_pcie->txq[txq_id]->id = txq_id;
 	set_bit(txq_id, trans_pcie->queue_used);
 
 	return 0;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index df31e14bc33d..386950a2d616 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -102,10 +102,9 @@ int iwl_queue_space(const struct iwl_txq *q)
 /*
  * iwl_queue_init - Initialize queue's high/low-water and read/write indexes
  */
-static int iwl_queue_init(struct iwl_txq *q, int slots_num, u32 id)
+static int iwl_queue_init(struct iwl_txq *q, int slots_num)
 {
 	q->n_window = slots_num;
-	q->id = id;
 
 	/* slots_num must be power-of-two size, otherwise
 	 * get_cmd_index is broken. */
@@ -484,7 +483,7 @@ static int iwl_pcie_txq_build_tfd(struct iwl_trans *trans, struct iwl_txq *txq,
 }
 
 int iwl_pcie_txq_alloc(struct iwl_trans *trans, struct iwl_txq *txq,
-		       int slots_num, u32 txq_id)
+		       int slots_num, bool cmd_queue)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	size_t tfd_sz = trans_pcie->tfd_size * TFD_QUEUE_SIZE_MAX;
@@ -507,7 +506,7 @@ int iwl_pcie_txq_alloc(struct iwl_trans *trans, struct iwl_txq *txq,
 	if (!txq->entries)
 		goto error;
 
-	if (txq_id == trans_pcie->cmd_queue)
+	if (cmd_queue)
 		for (i = 0; i < slots_num; i++) {
 			txq->entries[i].cmd =
 				kmalloc(sizeof(struct iwl_device_cmd),
@@ -533,13 +532,11 @@ int iwl_pcie_txq_alloc(struct iwl_trans *trans, struct iwl_txq *txq,
 	if (!txq->first_tb_bufs)
 		goto err_free_tfds;
 
-	txq->id = txq_id;
-
 	return 0;
 err_free_tfds:
 	dma_free_coherent(trans->dev, tfd_sz, txq->tfds, txq->dma_addr);
 error:
-	if (txq->entries && txq_id == trans_pcie->cmd_queue)
+	if (txq->entries && cmd_queue)
 		for (i = 0; i < slots_num; i++)
 			kfree(txq->entries[i].cmd);
 	kfree(txq->entries);
@@ -550,9 +547,8 @@ int iwl_pcie_txq_alloc(struct iwl_trans *trans, struct iwl_txq *txq,
 }
 
 int iwl_pcie_txq_init(struct iwl_trans *trans, struct iwl_txq *txq,
-		      int slots_num, u32 txq_id)
+		      int slots_num, bool cmd_queue)
 {
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int ret;
 
 	txq->need_update = false;
@@ -562,13 +558,13 @@ int iwl_pcie_txq_init(struct iwl_trans *trans, struct iwl_txq *txq,
 	BUILD_BUG_ON(TFD_QUEUE_SIZE_MAX & (TFD_QUEUE_SIZE_MAX - 1));
 
 	/* Initialize queue's high/low-water marks, and head/tail indexes */
-	ret = iwl_queue_init(txq, slots_num, txq_id);
+	ret = iwl_queue_init(txq, slots_num);
 	if (ret)
 		return ret;
 
 	spin_lock_init(&txq->lock);
 
-	if (txq_id == trans_pcie->cmd_queue) {
+	if (cmd_queue) {
 		static struct lock_class_key iwl_pcie_cmd_queue_lock_class;
 
 		lockdep_set_class(&txq->lock, &iwl_pcie_cmd_queue_lock_class);
@@ -951,15 +947,17 @@ static int iwl_pcie_tx_alloc(struct iwl_trans *trans)
 	/* Alloc and init all Tx queues, including the command queue (#4/#9) */
 	for (txq_id = 0; txq_id < trans->cfg->base_params->num_of_queues;
 	     txq_id++) {
-		slots_num = (txq_id == trans_pcie->cmd_queue) ?
-					TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
+		bool cmd_queue = (txq_id == trans_pcie->cmd_queue);
+
+		slots_num = cmd_queue ? TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
 		trans_pcie->txq[txq_id] = &trans_pcie->txq_memory[txq_id];
 		ret = iwl_pcie_txq_alloc(trans, trans_pcie->txq[txq_id],
-					 slots_num, txq_id);
+					 slots_num, cmd_queue);
 		if (ret) {
 			IWL_ERR(trans, "Tx %d queue alloc failed\n", txq_id);
 			goto error;
 		}
+		trans_pcie->txq[txq_id]->id = txq_id;
 	}
 
 	return 0;
@@ -998,10 +996,11 @@ int iwl_pcie_tx_init(struct iwl_trans *trans)
 	/* Alloc and init all Tx queues, including the command queue (#4/#9) */
 	for (txq_id = 0; txq_id < trans->cfg->base_params->num_of_queues;
 	     txq_id++) {
-		slots_num = (txq_id == trans_pcie->cmd_queue) ?
-					TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
+		bool cmd_queue = (txq_id == trans_pcie->cmd_queue);
+
+		slots_num = cmd_queue ? TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
 		ret = iwl_pcie_txq_init(trans, trans_pcie->txq[txq_id],
-					slots_num, txq_id);
+					slots_num, cmd_queue);
 		if (ret) {
 			IWL_ERR(trans, "Tx %d queue init failed\n", txq_id);
 			goto error;
-- 
2.11.0
