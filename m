Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:60424 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314Ab1HMSSb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:18:31 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/60] iwlagn: cmd_queue moves to iwl_shared
Date: Sat, 13 Aug 2011 10:37:44 -0700
Message-Id: <1313257116-2697-9-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_201838_915375_2E0F5CFA)
In-Reply-To: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since it is used by all the layers, it needs to move to iwl_shared.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c           |    4 +-
 drivers/net/wireless/iwlwifi/iwl-core.c          |    4 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h           |    3 --
 drivers/net/wireless/iwlwifi/iwl-prph.h          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h        |    3 ++
 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c |   23 +++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-trans.c         |    8 +++---
 8 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 048ccba..6db9085 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1103,7 +1103,7 @@ int iwlagn_wait_tx_queue_empty(struct iwl_priv *priv)
 
 	/* waiting for all the tx frames complete might take a while */
 	for (cnt = 0; cnt < hw_params(priv).max_txq_num; cnt++) {
-		if (cnt == priv->cmd_queue)
+		if (cnt == priv->shrd->cmd_queue)
 			continue;
 		txq = &priv->txq[cnt];
 		q = &txq->q;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index ba658b3..46958f2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1245,10 +1245,10 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 
 	if (ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PAN) {
 		priv->sta_key_max_num = STA_KEY_MAX_NUM_PAN;
-		priv->cmd_queue = IWL_IPAN_CMD_QUEUE_NUM;
+		priv->shrd->cmd_queue = IWL_IPAN_CMD_QUEUE_NUM;
 	} else {
 		priv->sta_key_max_num = STA_KEY_MAX_NUM;
-		priv->cmd_queue = IWL_DEFAULT_CMD_QUEUE_NUM;
+		priv->shrd->cmd_queue = IWL_DEFAULT_CMD_QUEUE_NUM;
 	}
 
 	/*
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 2aeafa1..02b70dc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1818,14 +1818,14 @@ void iwl_bg_watchdog(unsigned long data)
 		return;
 
 	/* monitor and check for stuck cmd queue */
-	if (iwl_check_stuck_queue(priv, priv->cmd_queue))
+	if (iwl_check_stuck_queue(priv, priv->shrd->cmd_queue))
 		return;
 
 	/* monitor and check for other stuck queues */
 	if (iwl_is_any_associated(priv)) {
 		for (cnt = 0; cnt < hw_params(priv).max_txq_num; cnt++) {
 			/* skip as we already checked the command queue */
-			if (cnt == priv->cmd_queue)
+			if (cnt == priv->shrd->cmd_queue)
 				continue;
 			if (iwl_check_stuck_queue(priv, cnt))
 				return;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 4dfe84b..7394bb1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1239,9 +1239,6 @@ struct iwl_priv {
 	/* microcode/device supports multiple contexts */
 	u8 valid_contexts;
 
-	/* command queue number */
-	u8 cmd_queue;
-
 	/* max number of station keys */
 	u8 sta_key_max_num;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index 40f6dd4..bebdd82 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -218,7 +218,7 @@
 
 #define SCD_QUEUECHAIN_SEL_ALL(priv)	\
 	(((1<<hw_params(priv).max_txq_num) - 1) &\
-	(~(1<<(priv)->cmd_queue)))
+	(~(1<<(priv)->shrd->cmd_queue)))
 
 #define SCD_BASE			(PRPH_BASE + 0xa02c00)
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 483785c..0562174 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -143,6 +143,7 @@ struct iwl_hw_params {
  *
  * @dbg_level_dev: dbg level set per device. Prevails on
  *	iwlagn_mod_params.debug_level if set (!= 0)
+ * @cmd_queue: command queue number
  * @bus: pointer to the bus layer data
  * @priv: pointer to the upper layer data
  * @hw_params: see struct iwl_hw_params
@@ -152,6 +153,8 @@ struct iwl_shared {
 	u32 dbg_level_dev;
 #endif /* CONFIG_IWLWIFI_DEBUG */
 
+	u8 cmd_queue;
+
 	struct iwl_bus *bus;
 	struct iwl_priv *priv;
 	struct iwl_hw_params hw_params;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
index a6b2b1d..b751f52 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
@@ -349,7 +349,7 @@ void iwlagn_txq_inval_byte_cnt_tbl(struct iwl_priv *priv,
 
 	WARN_ON(read_ptr >= TFD_QUEUE_SIZE_MAX);
 
-	if (txq_id != priv->cmd_queue)
+	if (txq_id != priv->shrd->cmd_queue)
 		sta_id = txq->cmd[read_ptr]->cmd.tx.sta_id;
 
 	bc_ent = cpu_to_le16(1 | (sta_id << 12));
@@ -526,7 +526,7 @@ int iwl_trans_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
  */
 static int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 {
-	struct iwl_tx_queue *txq = &priv->txq[priv->cmd_queue];
+	struct iwl_tx_queue *txq = &priv->txq[priv->shrd->cmd_queue];
 	struct iwl_queue *q = &txq->q;
 	struct iwl_device_cmd *out_cmd;
 	struct iwl_cmd_meta *out_meta;
@@ -618,8 +618,9 @@ static int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 
 	out_cmd->hdr.cmd = cmd->id;
 	out_cmd->hdr.flags = 0;
-	out_cmd->hdr.sequence = cpu_to_le16(QUEUE_TO_SEQ(priv->cmd_queue) |
-					    INDEX_TO_SEQ(q->write_ptr));
+	out_cmd->hdr.sequence =
+		cpu_to_le16(QUEUE_TO_SEQ(priv->shrd->cmd_queue) |
+					 INDEX_TO_SEQ(q->write_ptr));
 
 	/* and copy the data that needs to be copied */
 
@@ -638,7 +639,7 @@ static int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 			get_cmd_string(out_cmd->hdr.cmd),
 			out_cmd->hdr.cmd,
 			le16_to_cpu(out_cmd->hdr.sequence), cmd_size,
-			q->write_ptr, idx, priv->cmd_queue);
+			q->write_ptr, idx, priv->shrd->cmd_queue);
 
 	phys_addr = dma_map_single(priv->bus->dev, &out_cmd->hdr, copy_size,
 				DMA_BIDIRECTIONAL);
@@ -752,17 +753,17 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	int cmd_index;
 	struct iwl_device_cmd *cmd;
 	struct iwl_cmd_meta *meta;
-	struct iwl_tx_queue *txq = &priv->txq[priv->cmd_queue];
+	struct iwl_tx_queue *txq = &priv->txq[priv->shrd->cmd_queue];
 	unsigned long flags;
 
 	/* If a Tx command is being handled and it isn't in the actual
 	 * command queue then there a command routing bug has been introduced
 	 * in the queue management code. */
-	if (WARN(txq_id != priv->cmd_queue,
+	if (WARN(txq_id != priv->shrd->cmd_queue,
 		 "wrong command queue %d (should be %d), sequence 0x%X readp=%d writep=%d\n",
-		  txq_id, priv->cmd_queue, sequence,
-		  priv->txq[priv->cmd_queue].q.read_ptr,
-		  priv->txq[priv->cmd_queue].q.write_ptr)) {
+		  txq_id, priv->shrd->cmd_queue, sequence,
+		  priv->txq[priv->shrd->cmd_queue].q.read_ptr,
+		  priv->txq[priv->shrd->cmd_queue].q.write_ptr)) {
 		iwl_print_hex_error(priv, pkt, 32);
 		return;
 	}
@@ -1002,7 +1003,7 @@ cancel:
 		 * in later, it will possibly set an invalid
 		 * address (cmd->meta.source).
 		 */
-		priv->txq[priv->cmd_queue].meta[cmd_idx].flags &=
+		priv->txq[priv->shrd->cmd_queue].meta[cmd_idx].flags &=
 							~CMD_WANT_SKB;
 	}
 fail:
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 9212838..7a689df 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -311,7 +311,7 @@ static int iwl_trans_txq_alloc(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 	/* Alloc driver data array and TFD circular buffer */
 	/* Driver private data, only for Tx (not command) queues,
 	 * not shared with device. */
-	if (txq_id != priv->cmd_queue) {
+	if (txq_id != priv->shrd->cmd_queue) {
 		txq->txb = kzalloc(sizeof(txq->txb[0]) *
 				   TFD_QUEUE_SIZE_MAX, GFP_KERNEL);
 		if (!txq->txb) {
@@ -515,7 +515,7 @@ static int iwl_trans_tx_alloc(struct iwl_priv *priv)
 
 	/* Alloc and init all Tx queues, including the command queue (#4/#9) */
 	for (txq_id = 0; txq_id < hw_params(priv).max_txq_num; txq_id++) {
-		slots_num = (txq_id == priv->cmd_queue) ?
+		slots_num = (txq_id == priv->shrd->cmd_queue) ?
 					TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
 		ret = iwl_trans_txq_alloc(priv, &priv->txq[txq_id], slots_num,
 				       txq_id);
@@ -558,7 +558,7 @@ static int iwl_tx_init(struct iwl_priv *priv)
 
 	/* Alloc and init all Tx queues, including the command queue (#4/#9) */
 	for (txq_id = 0; txq_id < hw_params(priv).max_txq_num; txq_id++) {
-		slots_num = (txq_id == priv->cmd_queue) ?
+		slots_num = (txq_id == priv->shrd->cmd_queue) ?
 					TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
 		ret = iwl_trans_txq_init(priv, &priv->txq[txq_id], slots_num,
 				       txq_id);
@@ -841,7 +841,7 @@ static void iwl_trans_tx_start(struct iwl_priv *priv)
 	else
 		queue_to_fifo = iwlagn_default_queue_to_tx_fifo;
 
-	iwl_trans_set_wr_ptrs(priv, priv->cmd_queue, 0);
+	iwl_trans_set_wr_ptrs(priv, priv->shrd->cmd_queue, 0);
 
 	/* make sure all queue are not stopped */
 	memset(&priv->queue_stopped[0], 0, sizeof(priv->queue_stopped));
-- 
1.7.0.4

