Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34245 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755925AbZAWVmt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 16:42:49 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Samuel Ortiz <samuel.ortiz@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 06/15] iwl3945: Use iwlcore TX queue management routines
Date: Fri, 23 Jan 2009 13:45:14 -0800
Message-Id: <1232747123-7261-7-git-send-email-reinette.chatre@intel.com> (sfid-20090123_224258_656302_D42AB0A0)
In-Reply-To: <1232747123-7261-6-git-send-email-reinette.chatre@intel.com>
References: <>
 <1232747123-7261-1-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-2-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-3-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-4-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-5-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-6-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <samuel.ortiz@intel.com>

By adding an additional hw_params (tfd_size) and a new iwl_lib ops (txq_init),
we can now use the iwlcore TX queue management routines.
We had to add a new hw_params because we need to allocate the right DMA buffer
for TFDs, and those have a different sizes depending if you're on 3945 or agn.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    8 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 +
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    2 +
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   32 ++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    7 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 +
 drivers/net/wireless/iwlwifi/iwl-tx.c       |   49 ++-----
 drivers/net/wireless/iwlwifi/iwl3945-base.c |  204 ---------------------------
 8 files changed, 60 insertions(+), 246 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 22770f4..2689113 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1068,8 +1068,8 @@ static int iwl3945_txq_ctx_reset(struct iwl_priv *priv)
 	for (txq_id = 0; txq_id < TFD_QUEUE_MAX; txq_id++) {
 		slots_num = (txq_id == IWL_CMD_QUEUE_NUM) ?
 				TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
-		rc = iwl3945_tx_queue_init(priv, &priv->txq[txq_id], slots_num,
-				txq_id);
+		rc = iwl_tx_queue_init(priv, &priv->txq[txq_id], slots_num,
+				       txq_id);
 		if (rc) {
 			IWL_ERR(priv, "Tx %d queue init failed\n", txq_id);
 			goto error;
@@ -1258,7 +1258,7 @@ void iwl3945_hw_txq_ctx_free(struct iwl_priv *priv)
 
 	/* Tx queues */
 	for (txq_id = 0; txq_id < TFD_QUEUE_MAX; txq_id++)
-		iwl3945_tx_queue_free(priv, &priv->txq[txq_id]);
+		iwl_tx_queue_free(priv, txq_id);
 }
 
 void iwl3945_hw_txq_ctx_stop(struct iwl_priv *priv)
@@ -2491,6 +2491,7 @@ int iwl3945_hw_set_hw_params(struct iwl_priv *priv)
 		return -ENOMEM;
 	}
 
+	priv->hw_params.tfd_size = sizeof(struct iwl3945_tfd);
 	priv->hw_params.rx_buf_size = IWL_RX_BUF_SIZE_3K;
 	priv->hw_params.max_pkt_size = 2342;
 	priv->hw_params.max_rxq_size = RX_QUEUE_SIZE;
@@ -2705,6 +2706,7 @@ static int iwl3945_load_bsm(struct iwl_priv *priv)
 static struct iwl_lib_ops iwl3945_lib = {
 	.txq_attach_buf_to_tfd = iwl3945_hw_txq_attach_buf_to_tfd,
 	.txq_free_tfd = iwl3945_hw_txq_free_tfd,
+	.txq_init = iwl3945_hw_tx_queue_init,
 	.load_ucode = iwl3945_load_bsm,
 	.apm_ops = {
 		.init = iwl3945_apm_init,
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index b2985e2..d7d956d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -815,6 +815,7 @@ static int iwl4965_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.dma_chnl_num = FH49_TCSR_CHNL_NUM;
 	priv->hw_params.scd_bc_tbls_size =
 			IWL49_NUM_QUEUES * sizeof(struct iwl4965_scd_bc_tbl);
+	priv->hw_params.tfd_size = sizeof(struct iwl_tfd);
 	priv->hw_params.max_stations = IWL4965_STATION_COUNT;
 	priv->hw_params.bcast_sta_id = IWL4965_BROADCAST_ID;
 	priv->hw_params.max_data_size = IWL49_RTC_DATA_SIZE;
@@ -2297,6 +2298,7 @@ static struct iwl_lib_ops iwl4965_lib = {
 	.txq_agg_disable = iwl4965_txq_agg_disable,
 	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
 	.txq_free_tfd = iwl_hw_txq_free_tfd,
+	.txq_init = iwl_hw_tx_queue_init,
 	.rx_handler_setup = iwl4965_rx_handler_setup,
 	.setup_deferred_work = iwl4965_setup_deferred_work,
 	.cancel_deferred_work = iwl4965_cancel_deferred_work,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 04c2585..89d92a8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -837,6 +837,7 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.dma_chnl_num = FH50_TCSR_CHNL_NUM;
 	priv->hw_params.scd_bc_tbls_size =
 			IWL50_NUM_QUEUES * sizeof(struct iwl5000_scd_bc_tbl);
+	priv->hw_params.tfd_size = sizeof(struct iwl_tfd);
 	priv->hw_params.max_stations = IWL5000_STATION_COUNT;
 	priv->hw_params.bcast_sta_id = IWL5000_BROADCAST_ID;
 	priv->hw_params.max_data_size = IWL50_RTC_DATA_SIZE;
@@ -1494,6 +1495,7 @@ static struct iwl_lib_ops iwl5000_lib = {
 	.txq_agg_disable = iwl5000_txq_agg_disable,
 	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
 	.txq_free_tfd = iwl_hw_txq_free_tfd,
+	.txq_init = iwl_hw_tx_queue_init,
 	.rx_handler_setup = iwl5000_rx_handler_setup,
 	.setup_deferred_work = iwl5000_setup_deferred_work,
 	.is_valid_rtc_data_addr = iwl5000_hw_valid_rtc_data_addr,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 4ce3d6a..5c6b3fe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -592,6 +592,38 @@ int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv,
 	return 0;
 }
 
+/*
+ * Tell nic where to find circular buffer of Tx Frame Descriptors for
+ * given Tx queue, and enable the DMA channel used for that queue.
+ *
+ * 4965 supports up to 16 Tx queues in DRAM, mapped to up to 8 Tx DMA
+ * channels supported in hardware.
+ */
+int iwl_hw_tx_queue_init(struct iwl_priv *priv,
+			 struct iwl_tx_queue *txq)
+{
+	int ret;
+	unsigned long flags;
+	int txq_id = txq->q.id;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	ret = iwl_grab_nic_access(priv);
+	if (ret) {
+		spin_unlock_irqrestore(&priv->lock, flags);
+		return ret;
+	}
+
+	/* Circular buffer (TFD queue in DRAM) physical base address */
+	iwl_write_direct32(priv, FH_MEM_CBBC_QUEUE(txq_id),
+			     txq->q.dma_addr >> 8);
+
+	iwl_release_nic_access(priv);
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	return 0;
+}
+
+
 /******************************************************************************
  *
  * Misc. internal state and helper functions
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 409caaa..9a35080 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -116,6 +116,8 @@ struct iwl_lib_ops {
 				     u16 len, u8 reset, u8 pad);
 	void (*txq_free_tfd)(struct iwl_priv *priv,
 			     struct iwl_tx_queue *txq);
+	int (*txq_init)(struct iwl_priv *priv,
+			struct iwl_tx_queue *txq);
 	/* aggregations */
 	int (*txq_agg_enable)(struct iwl_priv *priv, int txq_id, int tx_fifo,
 			      int sta_id, int tid, u16 ssn_idx);
@@ -264,7 +266,12 @@ int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv,
 				 dma_addr_t addr, u16 len, u8 reset, u8 pad);
 int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb);
 void iwl_hw_txq_ctx_free(struct iwl_priv *priv);
+int iwl_hw_tx_queue_init(struct iwl_priv *priv,
+			 struct iwl_tx_queue *txq);
 int iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq);
+int iwl_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
+		      int slots_num, u32 txq_id);
+void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id);
 int iwl_tx_agg_start(struct iwl_priv *priv, const u8 *ra, u16 tid, u16 *ssn);
 int iwl_tx_agg_stop(struct iwl_priv *priv , const u8 *ra, u16 tid);
 int iwl_txq_check_empty(struct iwl_priv *priv, int sta_id, u8 tid, int txq_id);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 78ce4f4..5aa22d6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -567,6 +567,7 @@ struct iwl_sensitivity_ranges {
  * @max_txq_num: Max # Tx queues supported
  * @dma_chnl_num: Number of Tx DMA/FIFO channels
  * @scd_bc_tbls_size: size of scheduler byte count tables
+ * @tfd_size: TFD size
  * @tx/rx_chains_num: Number of TX/RX chains
  * @valid_tx/rx_ant: usable antennas
  * @max_rxq_size: Max # Rx frames in Rx queue (must be power-of-2)
@@ -587,6 +588,7 @@ struct iwl_hw_params {
 	u8 max_txq_num;
 	u8 dma_chnl_num;
 	u16 scd_bc_tbls_size;
+	u32 tfd_size;
 	u8  tx_chains_num;
 	u8  rx_chains_num;
 	u8  valid_tx_ant;
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 83e9f32..58118c8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -131,7 +131,7 @@ EXPORT_SYMBOL(iwl_txq_update_write_ptr);
  * Free all buffers.
  * 0-fill, but do not free "txq" descriptor structure.
  */
-static void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id)
+void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id)
 {
 	struct iwl_tx_queue *txq = &priv->txq[txq_id];
 	struct iwl_queue *q = &txq->q;
@@ -154,7 +154,7 @@ static void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id)
 
 	/* De-alloc circular buffer of TFDs */
 	if (txq->q.n_bd)
-		pci_free_consistent(dev, sizeof(struct iwl_tfd) *
+		pci_free_consistent(dev, priv->hw_params.tfd_size *
 				    txq->q.n_bd, txq->tfds, txq->q.dma_addr);
 
 	/* De-alloc array of per-TFD driver data */
@@ -164,7 +164,7 @@ static void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id)
 	/* 0-fill queue descriptor structure */
 	memset(txq, 0, sizeof(*txq));
 }
-
+EXPORT_SYMBOL(iwl_tx_queue_free);
 
 /**
  * iwl_cmd_queue_free - Deallocate DMA queue.
@@ -295,12 +295,12 @@ static int iwl_tx_queue_alloc(struct iwl_priv *priv,
 	/* Circular buffer of transmit frame descriptors (TFDs),
 	 * shared with device */
 	txq->tfds = pci_alloc_consistent(dev,
-			sizeof(struct iwl_tfd) * TFD_QUEUE_SIZE_MAX,
+			priv->hw_params.tfd_size * TFD_QUEUE_SIZE_MAX,
 			&txq->q.dma_addr);
 
 	if (!txq->tfds) {
 		IWL_ERR(priv, "pci_alloc_consistent(%zd) failed\n",
-			  sizeof(struct iwl_tfd) * TFD_QUEUE_SIZE_MAX);
+			  priv->hw_params.tfd_size * TFD_QUEUE_SIZE_MAX);
 		goto error;
 	}
 	txq->q.id = id;
@@ -314,42 +314,11 @@ static int iwl_tx_queue_alloc(struct iwl_priv *priv,
 	return -ENOMEM;
 }
 
-/*
- * Tell nic where to find circular buffer of Tx Frame Descriptors for
- * given Tx queue, and enable the DMA channel used for that queue.
- *
- * 4965 supports up to 16 Tx queues in DRAM, mapped to up to 8 Tx DMA
- * channels supported in hardware.
- */
-static int iwl_hw_tx_queue_init(struct iwl_priv *priv,
-				struct iwl_tx_queue *txq)
-{
-	int ret;
-	unsigned long flags;
-	int txq_id = txq->q.id;
-
-	spin_lock_irqsave(&priv->lock, flags);
-	ret = iwl_grab_nic_access(priv);
-	if (ret) {
-		spin_unlock_irqrestore(&priv->lock, flags);
-		return ret;
-	}
-
-	/* Circular buffer (TFD queue in DRAM) physical base address */
-	iwl_write_direct32(priv, FH_MEM_CBBC_QUEUE(txq_id),
-			     txq->q.dma_addr >> 8);
-
-	iwl_release_nic_access(priv);
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	return 0;
-}
-
 /**
  * iwl_tx_queue_init - Allocate and initialize one tx/cmd queue
  */
-static int iwl_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
-			     int slots_num, u32 txq_id)
+int iwl_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
+		      int slots_num, u32 txq_id)
 {
 	int i, len;
 	int ret;
@@ -391,7 +360,7 @@ static int iwl_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 	iwl_queue_init(priv, &txq->q, TFD_QUEUE_SIZE_MAX, slots_num, txq_id);
 
 	/* Tell device where to find queue */
-	iwl_hw_tx_queue_init(priv, txq);
+	priv->cfg->ops->lib->txq_init(priv, txq);
 
 	return 0;
 err:
@@ -406,6 +375,8 @@ err:
 	}
 	return -ENOMEM;
 }
+EXPORT_SYMBOL(iwl_tx_queue_init);
+
 /**
  * iwl_hw_txq_ctx_free - Free TXQ Context
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index bc10e2a..14f9523 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -93,210 +93,6 @@ struct iwl_mod_params iwl3945_mod_params = {
 	/* the rest are 0 by default */
 };
 
-/*************** DMA-QUEUE-GENERAL-FUNCTIONS  *****
- * DMA services
- *
- * Theory of operation
- *
- * A Tx or Rx queue resides in host DRAM, and is comprised of a circular buffer
- * of buffer descriptors, each of which points to one or more data buffers for
- * the device to read from or fill.  Driver and device exchange status of each
- * queue via "read" and "write" pointers.  Driver keeps minimum of 2 empty
- * entries in each circular buffer, to protect against confusing empty and full
- * queue states.
- *
- * The device reads or writes the data in the queues via the device's several
- * DMA/FIFO channels.  Each queue is mapped to a single DMA channel.
- *
- * For Tx queue, there are low mark and high mark limits. If, after queuing
- * the packet for Tx, free space become < low mark, Tx queue stopped. When
- * reclaiming packets (on 'tx done IRQ), if free space become > high mark,
- * Tx queue resumed.
- *
- * The 3945 operates with six queues:  One receive queue, one transmit queue
- * (#4) for sending commands to the device firmware, and four transmit queues
- * (#0-3) for data tx via EDCA.  An additional 2 HCCA queues are unused.
- ***************************************************/
-
-/**
- * iwl3945_queue_init - Initialize queue's high/low-water and read/write indexes
- */
-static int iwl3945_queue_init(struct iwl_priv *priv, struct iwl_queue *q,
-			  int count, int slots_num, u32 id)
-{
-	q->n_bd = count;
-	q->n_window = slots_num;
-	q->id = id;
-
-	/* count must be power-of-two size, otherwise iwl_queue_inc_wrap
-	 * and iwl_queue_dec_wrap are broken. */
-	BUG_ON(!is_power_of_2(count));
-
-	/* slots_num must be power-of-two size, otherwise
-	 * get_cmd_index is broken. */
-	BUG_ON(!is_power_of_2(slots_num));
-
-	q->low_mark = q->n_window / 4;
-	if (q->low_mark < 4)
-		q->low_mark = 4;
-
-	q->high_mark = q->n_window / 8;
-	if (q->high_mark < 2)
-		q->high_mark = 2;
-
-	q->write_ptr = q->read_ptr = 0;
-
-	return 0;
-}
-
-/**
- * iwl3945_tx_queue_alloc - Alloc driver data and TFD CB for one Tx/cmd queue
- */
-static int iwl3945_tx_queue_alloc(struct iwl_priv *priv,
-			      struct iwl_tx_queue *txq, u32 id)
-{
-	struct pci_dev *dev = priv->pci_dev;
-
-	/* Driver private data, only for Tx (not command) queues,
-	 * not shared with device. */
-	if (id != IWL_CMD_QUEUE_NUM) {
-		txq->txb = kmalloc(sizeof(txq->txb[0]) *
-				   TFD_QUEUE_SIZE_MAX, GFP_KERNEL);
-		if (!txq->txb) {
-			IWL_ERR(priv, "kmalloc for auxiliary BD "
-				  "structures failed\n");
-			goto error;
-		}
-	} else
-		txq->txb = NULL;
-
-	/* Circular buffer of transmit frame descriptors (TFDs),
-	 * shared with device */
-	txq->tfds = pci_alloc_consistent(dev,
-				sizeof(struct iwl3945_tfd) * TFD_QUEUE_SIZE_MAX,
-				&txq->q.dma_addr);
-
-	if (!txq->tfds) {
-		IWL_ERR(priv, "pci_alloc_consistent(%zd) failed\n",
-			  sizeof(struct iwl3945_tfd) * TFD_QUEUE_SIZE_MAX);
-		goto error;
-	}
-	txq->q.id = id;
-
-	return 0;
-
- error:
-	kfree(txq->txb);
-	txq->txb = NULL;
-
-	return -ENOMEM;
-}
-
-/**
- * iwl3945_tx_queue_init - Allocate and initialize one tx/cmd queue
- */
-int iwl3945_tx_queue_init(struct iwl_priv *priv,
-		      struct iwl_tx_queue *txq, int slots_num, u32 txq_id)
-{
-	int len, i;
-	int rc = 0;
-
-	/*
-	 * Alloc buffer array for commands (Tx or other types of commands).
-	 * For the command queue (#4), allocate command space + one big
-	 * command for scan, since scan command is very huge; the system will
-	 * not have two scans at the same time, so only one is needed.
-	 * For data Tx queues (all other queues), no super-size command
-	 * space is needed.
-	 */
-	len = sizeof(struct iwl_cmd);
-	for (i = 0; i <= slots_num; i++) {
-		if (i == slots_num) {
-			if (txq_id == IWL_CMD_QUEUE_NUM)
-				len += IWL_MAX_SCAN_SIZE;
-			else
-				continue;
-		}
-
-		txq->cmd[i] = kmalloc(len, GFP_KERNEL);
-		if (!txq->cmd[i])
-			goto err;
-	}
-
-	/* Alloc driver data array and TFD circular buffer */
-	rc = iwl3945_tx_queue_alloc(priv, txq, txq_id);
-	if (rc)
-		goto err;
-
-	txq->need_update = 0;
-
-	/* TFD_QUEUE_SIZE_MAX must be power-of-two size, otherwise
-	 * iwl_queue_inc_wrap and iwl_queue_dec_wrap are broken. */
-	BUILD_BUG_ON(TFD_QUEUE_SIZE_MAX & (TFD_QUEUE_SIZE_MAX - 1));
-
-	/* Initialize queue high/low-water, head/tail indexes */
-	iwl3945_queue_init(priv, &txq->q, TFD_QUEUE_SIZE_MAX, slots_num, txq_id);
-
-	/* Tell device where to find queue, enable DMA channel. */
-	iwl3945_hw_tx_queue_init(priv, txq);
-
-	return 0;
-err:
-	for (i = 0; i < slots_num; i++) {
-		kfree(txq->cmd[i]);
-		txq->cmd[i] = NULL;
-	}
-
-	if (txq_id == IWL_CMD_QUEUE_NUM) {
-		kfree(txq->cmd[slots_num]);
-		txq->cmd[slots_num] = NULL;
-	}
-	return -ENOMEM;
-}
-
-/**
- * iwl3945_tx_queue_free - Deallocate DMA queue.
- * @txq: Transmit queue to deallocate.
- *
- * Empty queue by removing and destroying all BD's.
- * Free all buffers.
- * 0-fill, but do not free "txq" descriptor structure.
- */
-void iwl3945_tx_queue_free(struct iwl_priv *priv, struct iwl_tx_queue *txq)
-{
-	struct iwl_queue *q = &txq->q;
-	struct pci_dev *dev = priv->pci_dev;
-	int len, i;
-
-	if (q->n_bd == 0)
-		return;
-
-	/* first, empty all BD's */
-	for (; q->write_ptr != q->read_ptr;
-	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd))
-		priv->cfg->ops->lib->txq_free_tfd(priv, txq);
-
-	len = sizeof(struct iwl_cmd) * q->n_window;
-	if (q->id == IWL_CMD_QUEUE_NUM)
-		len += IWL_MAX_SCAN_SIZE;
-
-	/* De-alloc array of command/tx buffers */
-	for (i = 0; i < TFD_TX_CMD_SLOTS; i++)
-		kfree(txq->cmd[i]);
-
-	/* De-alloc circular buffer of TFDs */
-	if (txq->q.n_bd)
-		pci_free_consistent(dev, sizeof(struct iwl3945_tfd) *
-				    txq->q.n_bd, txq->tfds, txq->q.dma_addr);
-
-	/* De-alloc array of per-TFD driver data */
-	kfree(txq->txb);
-	txq->txb = NULL;
-
-	/* 0-fill queue descriptor structure */
-	memset(txq, 0, sizeof(*txq));
-}
-
 /*************** STATION TABLE MANAGEMENT ****
  * mac80211 should be examined to determine if sta_info is duplicating
  * the functionality provided here
-- 
1.5.4.3

