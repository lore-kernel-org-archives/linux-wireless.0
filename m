Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:9726 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254Ab0H0Q4o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 12:56:44 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/27] iwlwifi: prepare for PAN queue/fifo assignment
Date: Fri, 27 Aug 2010 09:59:30 -0700
Message-Id: <1282928395-32762-3-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

PAN ucode will require a different queue assignment,
in particular queue 9 instead of 4 should be used for
commands.

This is required because the ucode will stop/start
queues 4 and 8 depending on the PAN state, since
queue 8 will be used for PAN multicast (after DTIM).

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h   |    1 +
 drivers/net/wireless/iwlwifi/iwl-3945.c      |   10 ++++----
 drivers/net/wireless/iwlwifi/iwl-4965.c      |    3 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c    |   12 ++++----
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |   31 +++++++++++++++++++----
 drivers/net/wireless/iwlwifi/iwl-agn.c       |    3 ++
 drivers/net/wireless/iwlwifi/iwl-core.c      |    4 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h       |   10 ++++---
 drivers/net/wireless/iwlwifi/iwl-hcmd.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h      |    9 ++++---
 drivers/net/wireless/iwlwifi/iwl-tx.c        |   34 +++++++++++++-------------
 drivers/net/wireless/iwlwifi/iwl3945-base.c  |    2 +
 13 files changed, 77 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
index a4a3194..65b5834 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -226,6 +226,7 @@ struct iwl3945_eeprom {
 
 /* 4 DATA + 1 CMD. There are 2 HCCA queues that are not used. */
 #define IWL39_NUM_QUEUES        5
+#define IWL39_CMD_QUEUE_NUM	4
 
 #define IWL_DEFAULT_TX_RETRY  15
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index f4aa229..f059b1d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -273,7 +273,7 @@ static void iwl3945_tx_queue_reclaim(struct iwl_priv *priv,
 	struct iwl_queue *q = &txq->q;
 	struct iwl_tx_info *tx_info;
 
-	BUG_ON(txq_id == IWL_CMD_QUEUE_NUM);
+	BUG_ON(txq_id == IWL39_CMD_QUEUE_NUM);
 
 	for (index = iwl_queue_inc_wrap(index, q->n_bd); q->read_ptr != index;
 		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
@@ -285,7 +285,7 @@ static void iwl3945_tx_queue_reclaim(struct iwl_priv *priv,
 	}
 
 	if (iwl_queue_space(q) > q->low_mark && (txq_id >= 0) &&
-			(txq_id != IWL_CMD_QUEUE_NUM) &&
+			(txq_id != IWL39_CMD_QUEUE_NUM) &&
 			priv->mac80211_registered)
 		iwl_wake_queue(priv, txq_id);
 }
@@ -760,7 +760,7 @@ void iwl3945_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 		data_retry_limit = IWL_DEFAULT_TX_RETRY;
 	tx_cmd->data_retry_limit = data_retry_limit;
 
-	if (tx_id >= IWL_CMD_QUEUE_NUM)
+	if (tx_id >= IWL39_CMD_QUEUE_NUM)
 		rts_retry_limit = 3;
 	else
 		rts_retry_limit = 7;
@@ -909,7 +909,7 @@ static int iwl3945_txq_ctx_reset(struct iwl_priv *priv)
 
 	/* Tx queue(s) */
 	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++) {
-		slots_num = (txq_id == IWL_CMD_QUEUE_NUM) ?
+		slots_num = (txq_id == IWL39_CMD_QUEUE_NUM) ?
 				TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
 		rc = iwl_tx_queue_init(priv, &priv->txq[txq_id], slots_num,
 				       txq_id);
@@ -1072,7 +1072,7 @@ void iwl3945_hw_txq_ctx_free(struct iwl_priv *priv)
 	if (priv->txq)
 		for (txq_id = 0; txq_id < priv->hw_params.max_txq_num;
 		     txq_id++)
-			if (txq_id == IWL_CMD_QUEUE_NUM)
+			if (txq_id == IWL39_CMD_QUEUE_NUM)
 				iwl_cmd_queue_free(priv);
 			else
 				iwl_tx_queue_free(priv, txq_id);
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 82f3230..cda389c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -576,7 +576,7 @@ static int iwl4965_alive_notify(struct iwl_priv *priv)
 	/* Activate all Tx DMA/FIFO channels */
 	priv->cfg->ops->lib->txq_set_sched(priv, IWL_MASK(0, 6));
 
-	iwl4965_set_wr_ptrs(priv, IWL_CMD_QUEUE_NUM, 0);
+	iwl4965_set_wr_ptrs(priv, IWL_DEFAULT_CMD_QUEUE_NUM, 0);
 
 	/* make sure all queue are not stopped */
 	memset(&priv->queue_stopped[0], 0, sizeof(priv->queue_stopped));
@@ -587,6 +587,7 @@ static int iwl4965_alive_notify(struct iwl_priv *priv)
 	priv->txq_ctx_active_msk = 0;
 	/* Map each Tx/cmd queue to its corresponding fifo */
 	BUILD_BUG_ON(ARRAY_SIZE(default_queue_to_tx_fifo) != 7);
+
 	for (i = 0; i < ARRAY_SIZE(default_queue_to_tx_fifo); i++) {
 		int ac = default_queue_to_tx_fifo[i];
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 531a7dc..f919977 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1479,7 +1479,7 @@ int iwlagn_wait_tx_queue_empty(struct iwl_priv *priv)
 
 	/* waiting for all the tx frames complete might take a while */
 	for (cnt = 0; cnt < priv->hw_params.max_txq_num; cnt++) {
-		if (cnt == IWL_CMD_QUEUE_NUM)
+		if (cnt == priv->cmd_queue)
 			continue;
 		txq = &priv->txq[cnt];
 		q = &txq->q;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index a51a7cf..88b7bbf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -118,7 +118,7 @@ void iwlagn_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
 
 	WARN_ON(len > 0xFFF || write_ptr >= TFD_QUEUE_SIZE_MAX);
 
-	if (txq_id != IWL_CMD_QUEUE_NUM) {
+	if (txq_id != priv->cmd_queue) {
 		sta_id = txq->cmd[txq->q.write_ptr]->cmd.tx.sta_id;
 		sec_ctl = txq->cmd[txq->q.write_ptr]->cmd.tx.sec_ctl;
 
@@ -155,7 +155,7 @@ void iwlagn_txq_inval_byte_cnt_tbl(struct iwl_priv *priv,
 
 	WARN_ON(read_ptr >= TFD_QUEUE_SIZE_MAX);
 
-	if (txq_id != IWL_CMD_QUEUE_NUM)
+	if (txq_id != priv->cmd_queue)
 		sta_id = txq->cmd[read_ptr]->cmd.tx.sta_id;
 
 	bc_ent = cpu_to_le16(1 | (sta_id << 12));
@@ -825,7 +825,7 @@ void iwlagn_hw_txq_ctx_free(struct iwl_priv *priv)
 	/* Tx queues */
 	if (priv->txq) {
 		for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++)
-			if (txq_id == IWL_CMD_QUEUE_NUM)
+			if (txq_id == priv->cmd_queue)
 				iwl_cmd_queue_free(priv);
 			else
 				iwl_tx_queue_free(priv, txq_id);
@@ -882,9 +882,9 @@ int iwlagn_txq_ctx_alloc(struct iwl_priv *priv)
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	/* Alloc and init all Tx queues, including the command queue (#4) */
+	/* Alloc and init all Tx queues, including the command queue (#4/#9) */
 	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++) {
-		slots_num = (txq_id == IWL_CMD_QUEUE_NUM) ?
+		slots_num = (txq_id == priv->cmd_queue) ?
 					TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
 		ret = iwl_tx_queue_init(priv, &priv->txq[txq_id], slots_num,
 				       txq_id);
@@ -922,7 +922,7 @@ void iwlagn_txq_ctx_reset(struct iwl_priv *priv)
 
 	/* Alloc and init all Tx queues, including the command queue (#4) */
 	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++) {
-		slots_num = txq_id == IWL_CMD_QUEUE_NUM ?
+		slots_num = txq_id == priv->cmd_queue ?
 			    TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
 		iwl_tx_queue_reset(priv, &priv->txq[txq_id], slots_num, txq_id);
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index f2499e1..a9ea7a1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -52,6 +52,19 @@ static const s8 iwlagn_default_queue_to_tx_fifo[] = {
 	IWL_TX_FIFO_UNUSED,
 };
 
+static const s8 iwlagn_ipan_queue_to_tx_fifo[] = {
+	IWL_TX_FIFO_VO,
+	IWL_TX_FIFO_VI,
+	IWL_TX_FIFO_BE,
+	IWL_TX_FIFO_BK,
+	IWL_TX_FIFO_UNUSED, /* FIXME */
+	IWL_TX_FIFO_UNUSED, /* FIXME */
+	IWL_TX_FIFO_UNUSED, /* FIXME */
+	IWL_TX_FIFO_UNUSED, /* FIXME */
+	IWL_TX_FIFO_UNUSED, /* FIXME */
+	IWLAGN_CMD_FIFO_NUM,
+};
+
 static struct iwl_wimax_coex_event_entry cu_priorities[COEX_NUM_OF_EVENTS] = {
 	{COEX_CU_UNASSOC_IDLE_RP, COEX_CU_UNASSOC_IDLE_WP,
 	 0, COEX_UNASSOC_IDLE_FLAGS},
@@ -376,6 +389,7 @@ static void iwlagn_send_bt_env(struct iwl_priv *priv, u8 action, u8 type)
 
 int iwlagn_alive_notify(struct iwl_priv *priv)
 {
+	const s8 *queues;
 	u32 a;
 	unsigned long flags;
 	int i, chan;
@@ -410,7 +424,7 @@ int iwlagn_alive_notify(struct iwl_priv *priv)
 			   reg_val | FH_TX_CHICKEN_BITS_SCD_AUTO_RETRY_EN);
 
 	iwl_write_prph(priv, IWLAGN_SCD_QUEUECHAIN_SEL,
-		IWLAGN_SCD_QUEUECHAIN_SEL_ALL(priv->hw_params.max_txq_num));
+		IWLAGN_SCD_QUEUECHAIN_SEL_ALL(priv));
 	iwl_write_prph(priv, IWLAGN_SCD_AGGR_SEL, 0);
 
 	/* initiate the queues */
@@ -436,7 +450,13 @@ int iwlagn_alive_notify(struct iwl_priv *priv)
 	/* Activate all Tx DMA/FIFO channels */
 	priv->cfg->ops->lib->txq_set_sched(priv, IWL_MASK(0, 7));
 
-	iwlagn_set_wr_ptrs(priv, IWL_CMD_QUEUE_NUM, 0);
+	/* map queues to FIFOs */
+	if (priv->valid_contexts != BIT(IWL_RXON_CTX_BSS))
+		queues = iwlagn_ipan_queue_to_tx_fifo;
+	else
+		queues = iwlagn_default_queue_to_tx_fifo;
+
+	iwlagn_set_wr_ptrs(priv, priv->cmd_queue, 0);
 
 	/* make sure all queue are not stopped */
 	memset(&priv->queue_stopped[0], 0, sizeof(priv->queue_stopped));
@@ -445,11 +465,12 @@ int iwlagn_alive_notify(struct iwl_priv *priv)
 
 	/* reset to 0 to enable all the queue first */
 	priv->txq_ctx_active_msk = 0;
-	/* map qos queues to fifos one-to-one */
+
 	BUILD_BUG_ON(ARRAY_SIZE(iwlagn_default_queue_to_tx_fifo) != 10);
+	BUILD_BUG_ON(ARRAY_SIZE(iwlagn_ipan_queue_to_tx_fifo) != 10);
 
-	for (i = 0; i < ARRAY_SIZE(iwlagn_default_queue_to_tx_fifo); i++) {
-		int ac = iwlagn_default_queue_to_tx_fifo[i];
+	for (i = 0; i < 10; i++) {
+		int ac = queues[i];
 
 		iwl_txq_ctx_activate(priv, i);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index e073069..cfc8e8d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3011,6 +3011,9 @@ static int __iwl_up(struct iwl_priv *priv)
 
 	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
 
+	/* must be initialised before iwl_hw_nic_init */
+	priv->cmd_queue = IWL_DEFAULT_CMD_QUEUE_NUM;
+
 	ret = iwlagn_hw_nic_init(priv);
 	if (ret) {
 		IWL_ERR(priv, "Unable to init nic\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index cc88401..f6aa5ce 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2757,14 +2757,14 @@ void iwl_bg_monitor_recover(unsigned long data)
 		return;
 
 	/* monitor and check for stuck cmd queue */
-	if (iwl_check_stuck_queue(priv, IWL_CMD_QUEUE_NUM))
+	if (iwl_check_stuck_queue(priv, priv->cmd_queue))
 		return;
 
 	/* monitor and check for other stuck queues */
 	if (iwl_is_any_associated(priv)) {
 		for (cnt = 0; cnt < priv->hw_params.max_txq_num; cnt++) {
 			/* skip as we already checked the command queue */
-			if (cnt == IWL_CMD_QUEUE_NUM)
+			if (cnt == priv->cmd_queue)
 				continue;
 			if (iwl_check_stuck_queue(priv, cnt))
 				return;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 6b18892..7cafb26 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -265,11 +265,10 @@ struct iwl_channel_info {
 #define IWL_MIN_NUM_QUEUES	10
 
 /*
- * Queue #4 is the command queue for 3945/4965/5x00/1000/6x00,
- * the driver maps it into the appropriate device FIFO for the
- * uCode.
+ * Command queue depends on iPAN support.
  */
-#define IWL_CMD_QUEUE_NUM	4
+#define IWL_DEFAULT_CMD_QUEUE_NUM	4
+#define IWL_IPAN_CMD_QUEUE_NUM		9
 
 /* Power management (not Tx power) structures */
 
@@ -1197,6 +1196,9 @@ struct iwl_priv {
 	/* microcode/device supports multiple contexts */
 	u8 valid_contexts;
 
+	/* command queue number */
+	u8 cmd_queue;
+
 	/* EEPROM MAC addresses */
 	struct mac_address addresses[2];
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index 1f15b3a..9fb2035 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -232,7 +232,7 @@ cancel:
 		 * in later, it will possibly set an invalid
 		 * address (cmd->meta.source).
 		 */
-		priv->txq[IWL_CMD_QUEUE_NUM].meta[cmd_idx].flags &=
+		priv->txq[priv->cmd_queue].meta[cmd_idx].flags &=
 							~CMD_WANT_SKB;
 	}
 fail:
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index b1f101c..5469655 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -306,7 +306,7 @@
  *     at a time, until receiving ACK from receiving station, or reaching
  *     retry limit and giving up.
  *
- *     The command queue (#4) must use this mode!
+ *     The command queue (#4/#9) must use this mode!
  *     This mode does not require use of the Byte Count table in host DRAM.
  *
  * Driver controls scheduler operation via 3 means:
@@ -322,7 +322,7 @@
  *     (1024 bytes for each queue).
  *
  * After receiving "Alive" response from uCode, driver must initialize
- * the scheduler (especially for queue #4, the command queue, otherwise
+ * the scheduler (especially for queue #4/#9, the command queue, otherwise
  * the driver can't issue commands!):
  */
 
@@ -555,8 +555,9 @@
 #define IWLAGN_SCD_TRANSLATE_TBL_OFFSET_QUEUE(x) \
 	((IWLAGN_SCD_TRANSLATE_TBL_OFFSET + ((x) * 2)) & 0xfffc)
 
-#define IWLAGN_SCD_QUEUECHAIN_SEL_ALL(x)		(((1<<(x)) - 1) &\
-	(~(1<<IWL_CMD_QUEUE_NUM)))
+#define IWLAGN_SCD_QUEUECHAIN_SEL_ALL(priv)	\
+	(((1<<(priv)->hw_params.max_txq_num) - 1) &\
+	(~(1<<(priv)->cmd_queue)))
 
 #define IWLAGN_SCD_BASE			(PRPH_BASE + 0xa02c00)
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index c308dab..347d3dc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -134,7 +134,7 @@ EXPORT_SYMBOL(iwl_tx_queue_free);
  */
 void iwl_cmd_queue_free(struct iwl_priv *priv)
 {
-	struct iwl_tx_queue *txq = &priv->txq[IWL_CMD_QUEUE_NUM];
+	struct iwl_tx_queue *txq = &priv->txq[priv->cmd_queue];
 	struct iwl_queue *q = &txq->q;
 	struct device *dev = &priv->pci_dev->dev;
 	int i;
@@ -271,7 +271,7 @@ static int iwl_tx_queue_alloc(struct iwl_priv *priv,
 
 	/* Driver private data, only for Tx (not command) queues,
 	 * not shared with device. */
-	if (id != IWL_CMD_QUEUE_NUM) {
+	if (id != priv->cmd_queue) {
 		txq->txb = kzalloc(sizeof(txq->txb[0]) *
 				   TFD_QUEUE_SIZE_MAX, GFP_KERNEL);
 		if (!txq->txb) {
@@ -314,13 +314,13 @@ int iwl_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 
 	/*
 	 * Alloc buffer array for commands (Tx or other types of commands).
-	 * For the command queue (#4), allocate command space + one big
+	 * For the command queue (#4/#9), allocate command space + one big
 	 * command for scan, since scan command is very huge; the system will
 	 * not have two scans at the same time, so only one is needed.
 	 * For normal Tx queues (all other queues), no super-size command
 	 * space is needed.
 	 */
-	if (txq_id == IWL_CMD_QUEUE_NUM)
+	if (txq_id == priv->cmd_queue)
 		actual_slots++;
 
 	txq->meta = kzalloc(sizeof(struct iwl_cmd_meta) * actual_slots,
@@ -355,7 +355,7 @@ int iwl_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 	 * need an swq_id so don't set one to catch errors, all others can
 	 * be set up to the identity mapping.
 	 */
-	if (txq_id != IWL_CMD_QUEUE_NUM)
+	if (txq_id != priv->cmd_queue)
 		txq->swq_id = txq_id;
 
 	/* TFD_QUEUE_SIZE_MAX must be power-of-two size, otherwise
@@ -385,7 +385,7 @@ void iwl_tx_queue_reset(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 {
 	int actual_slots = slots_num;
 
-	if (txq_id == IWL_CMD_QUEUE_NUM)
+	if (txq_id == priv->cmd_queue)
 		actual_slots++;
 
 	memset(txq->meta, 0, sizeof(struct iwl_cmd_meta) * actual_slots);
@@ -413,7 +413,7 @@ EXPORT_SYMBOL(iwl_tx_queue_reset);
  */
 int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 {
-	struct iwl_tx_queue *txq = &priv->txq[IWL_CMD_QUEUE_NUM];
+	struct iwl_tx_queue *txq = &priv->txq[priv->cmd_queue];
 	struct iwl_queue *q = &txq->q;
 	struct iwl_device_cmd *out_cmd;
 	struct iwl_cmd_meta *out_meta;
@@ -483,7 +483,7 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	 * information */
 
 	out_cmd->hdr.flags = 0;
-	out_cmd->hdr.sequence = cpu_to_le16(QUEUE_TO_SEQ(IWL_CMD_QUEUE_NUM) |
+	out_cmd->hdr.sequence = cpu_to_le16(QUEUE_TO_SEQ(priv->cmd_queue) |
 			INDEX_TO_SEQ(q->write_ptr));
 	if (cmd->flags & CMD_SIZE_HUGE)
 		out_cmd->hdr.sequence |= SEQ_HUGE_FRAME;
@@ -500,15 +500,15 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 				get_cmd_string(out_cmd->hdr.cmd),
 				out_cmd->hdr.cmd,
 				le16_to_cpu(out_cmd->hdr.sequence), fix_size,
-				q->write_ptr, idx, IWL_CMD_QUEUE_NUM);
-				break;
+				q->write_ptr, idx, priv->cmd_queue);
+		break;
 	default:
 		IWL_DEBUG_HC(priv, "Sending command %s (#%x), seq: 0x%04X, "
 				"%d bytes at %d[%d]:%d\n",
 				get_cmd_string(out_cmd->hdr.cmd),
 				out_cmd->hdr.cmd,
 				le16_to_cpu(out_cmd->hdr.sequence), fix_size,
-				q->write_ptr, idx, IWL_CMD_QUEUE_NUM);
+				q->write_ptr, idx, priv->cmd_queue);
 	}
 #endif
 	txq->need_update = 1;
@@ -587,16 +587,16 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	bool huge = !!(pkt->hdr.sequence & SEQ_HUGE_FRAME);
 	struct iwl_device_cmd *cmd;
 	struct iwl_cmd_meta *meta;
-	struct iwl_tx_queue *txq = &priv->txq[IWL_CMD_QUEUE_NUM];
+	struct iwl_tx_queue *txq = &priv->txq[priv->cmd_queue];
 
 	/* If a Tx command is being handled and it isn't in the actual
 	 * command queue then there a command routing bug has been introduced
 	 * in the queue management code. */
-	if (WARN(txq_id != IWL_CMD_QUEUE_NUM,
-		 "wrong command queue %d, sequence 0x%X readp=%d writep=%d\n",
-		  txq_id, sequence,
-		  priv->txq[IWL_CMD_QUEUE_NUM].q.read_ptr,
-		  priv->txq[IWL_CMD_QUEUE_NUM].q.write_ptr)) {
+	if (WARN(txq_id != priv->cmd_queue,
+		 "wrong command queue %d (should be %d), sequence 0x%X readp=%d writep=%d\n",
+		  txq_id, priv->cmd_queue, sequence,
+		  priv->txq[priv->cmd_queue].q.read_ptr,
+		  priv->txq[priv->cmd_queue].q.write_ptr)) {
 		iwl_print_hex_error(priv, pkt, 32);
 		return;
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 234d6b4..02e0a9b 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4001,6 +4001,8 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	priv = hw->priv;
 	SET_IEEE80211_DEV(hw, &pdev->dev);
 
+	priv->cmd_queue = IWL39_CMD_QUEUE_NUM;
+
 	/* 3945 has only one valid context */
 	priv->valid_contexts = BIT(IWL_RXON_CTX_BSS);
 
-- 
1.7.0.4

