Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45645 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557Ab2GEIZC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 04:25:02 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/9] iwlwifi: configure the queues from the op_mode
Date: Thu,  5 Jul 2012 10:24:47 +0200
Message-Id: <1341476695-6889-2-git-send-email-johannes@sipsolutions.net> (sfid-20120705_102517_392432_997AB991)
In-Reply-To: <1341476695-6889-1-git-send-email-johannes@sipsolutions.net>
References: <1341476695-6889-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since the op_mode defines the queue mapping, let it do it
completely through the API functions.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/commands.h  |   40 +++++++++++++++++-
 drivers/net/wireless/iwlwifi/dvm/dev.h       |   16 --------
 drivers/net/wireless/iwlwifi/dvm/main.c      |   56 +-------------------------
 drivers/net/wireless/iwlwifi/dvm/ucode.c     |   37 +++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-trans.h     |   27 ++++++++-----
 drivers/net/wireless/iwlwifi/pcie/internal.h |    3 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c    |   22 ++--------
 7 files changed, 98 insertions(+), 103 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/commands.h b/drivers/net/wireless/iwlwifi/dvm/commands.h
index 64811cd..97bea16f3 100644
--- a/drivers/net/wireless/iwlwifi/dvm/commands.h
+++ b/drivers/net/wireless/iwlwifi/dvm/commands.h
@@ -190,6 +190,44 @@ enum {
 	REPLY_MAX = 0xff
 };
 
+/*
+ * Minimum number of queues. MAX_NUM is defined in hw specific files.
+ * Set the minimum to accommodate
+ *  - 4 standard TX queues
+ *  - the command queue
+ *  - 4 PAN TX queues
+ *  - the PAN multicast queue, and
+ *  - the AUX (TX during scan dwell) queue.
+ */
+#define IWL_MIN_NUM_QUEUES	11
+
+/*
+ * Command queue depends on iPAN support.
+ */
+#define IWL_DEFAULT_CMD_QUEUE_NUM	4
+#define IWL_IPAN_CMD_QUEUE_NUM		9
+
+#define IWL_TX_FIFO_BK		0	/* shared */
+#define IWL_TX_FIFO_BE		1
+#define IWL_TX_FIFO_VI		2	/* shared */
+#define IWL_TX_FIFO_VO		3
+#define IWL_TX_FIFO_BK_IPAN	IWL_TX_FIFO_BK
+#define IWL_TX_FIFO_BE_IPAN	4
+#define IWL_TX_FIFO_VI_IPAN	IWL_TX_FIFO_VI
+#define IWL_TX_FIFO_VO_IPAN	5
+/* re-uses the VO FIFO, uCode will properly flush/schedule */
+#define IWL_TX_FIFO_AUX		5
+#define IWL_TX_FIFO_UNUSED	255
+
+#define IWLAGN_CMD_FIFO_NUM	7
+
+/*
+ * This queue number is required for proper operation
+ * because the ucode will stop/start the scheduler as
+ * required.
+ */
+#define IWL_IPAN_MCAST_QUEUE	8
+
 /******************************************************************************
  * (0)
  * Commonly used structures and definitions:
@@ -755,8 +793,6 @@ struct iwl_qosparam_cmd {
 #define IWLAGN_BROADCAST_ID	15
 #define	IWLAGN_STATION_COUNT	16
 
-#define	IWL_INVALID_STATION 	255
-#define IWL_MAX_TID_COUNT	8
 #define IWL_TID_NON_QOS IWL_MAX_TID_COUNT
 
 #define STA_FLG_TX_RATE_MSK		cpu_to_le32(1 << 2)
diff --git a/drivers/net/wireless/iwlwifi/dvm/dev.h b/drivers/net/wireless/iwlwifi/dvm/dev.h
index 54cf085..054f728 100644
--- a/drivers/net/wireless/iwlwifi/dvm/dev.h
+++ b/drivers/net/wireless/iwlwifi/dvm/dev.h
@@ -90,22 +90,6 @@
 
 #define IWL_NUM_SCAN_RATES         (2)
 
-/*
- * Minimum number of queues. MAX_NUM is defined in hw specific files.
- * Set the minimum to accommodate
- *  - 4 standard TX queues
- *  - the command queue
- *  - 4 PAN TX queues
- *  - the PAN multicast queue, and
- *  - the AUX (TX during scan dwell) queue.
- */
-#define IWL_MIN_NUM_QUEUES	11
-
-/*
- * Command queue depends on iPAN support.
- */
-#define IWL_DEFAULT_CMD_QUEUE_NUM	4
-#define IWL_IPAN_CMD_QUEUE_NUM		9
 
 #define IEEE80211_DATA_LEN              2304
 #define IEEE80211_4ADDR_LEN             30
diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index abfd791..612f05d 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -518,49 +518,6 @@ static void iwl_bg_tx_flush(struct work_struct *work)
  * queue/FIFO/AC mapping definitions
  */
 
-#define IWL_TX_FIFO_BK		0	/* shared */
-#define IWL_TX_FIFO_BE		1
-#define IWL_TX_FIFO_VI		2	/* shared */
-#define IWL_TX_FIFO_VO		3
-#define IWL_TX_FIFO_BK_IPAN	IWL_TX_FIFO_BK
-#define IWL_TX_FIFO_BE_IPAN	4
-#define IWL_TX_FIFO_VI_IPAN	IWL_TX_FIFO_VI
-#define IWL_TX_FIFO_VO_IPAN	5
-/* re-uses the VO FIFO, uCode will properly flush/schedule */
-#define IWL_TX_FIFO_AUX		5
-#define IWL_TX_FIFO_UNUSED	-1
-
-#define IWLAGN_CMD_FIFO_NUM	7
-
-/*
- * This queue number is required for proper operation
- * because the ucode will stop/start the scheduler as
- * required.
- */
-#define IWL_IPAN_MCAST_QUEUE	8
-
-static const u8 iwlagn_default_queue_to_tx_fifo[] = {
-	IWL_TX_FIFO_VO,
-	IWL_TX_FIFO_VI,
-	IWL_TX_FIFO_BE,
-	IWL_TX_FIFO_BK,
-	IWLAGN_CMD_FIFO_NUM,
-};
-
-static const u8 iwlagn_ipan_queue_to_tx_fifo[] = {
-	IWL_TX_FIFO_VO,
-	IWL_TX_FIFO_VI,
-	IWL_TX_FIFO_BE,
-	IWL_TX_FIFO_BK,
-	IWL_TX_FIFO_BK_IPAN,
-	IWL_TX_FIFO_BE_IPAN,
-	IWL_TX_FIFO_VI_IPAN,
-	IWL_TX_FIFO_VO_IPAN,
-	IWL_TX_FIFO_BE_IPAN,
-	IWLAGN_CMD_FIFO_NUM,
-	IWL_TX_FIFO_AUX,
-};
-
 static const u8 iwlagn_bss_ac_to_fifo[] = {
 	IWL_TX_FIFO_VO,
 	IWL_TX_FIFO_VI,
@@ -1350,6 +1307,7 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	else
 		trans_cfg.queue_watchdog_timeout = IWL_WATCHDOG_DISABLED;
 	trans_cfg.command_names = iwl_dvm_cmd_strings;
+	trans_cfg.cmd_fifo = IWLAGN_CMD_FIFO_NUM;
 
 	WARN_ON(sizeof(priv->transport_queue_stop) * BITS_PER_BYTE <
 		priv->cfg->base_params->num_of_queues);
@@ -1363,15 +1321,9 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	if (ucode_flags & IWL_UCODE_TLV_FLAGS_PAN) {
 		priv->sta_key_max_num = STA_KEY_MAX_NUM_PAN;
 		trans_cfg.cmd_queue = IWL_IPAN_CMD_QUEUE_NUM;
-		trans_cfg.queue_to_fifo = iwlagn_ipan_queue_to_tx_fifo;
-		trans_cfg.n_queue_to_fifo =
-			ARRAY_SIZE(iwlagn_ipan_queue_to_tx_fifo);
 	} else {
 		priv->sta_key_max_num = STA_KEY_MAX_NUM;
 		trans_cfg.cmd_queue = IWL_DEFAULT_CMD_QUEUE_NUM;
-		trans_cfg.queue_to_fifo = iwlagn_default_queue_to_tx_fifo;
-		trans_cfg.n_queue_to_fifo =
-			ARRAY_SIZE(iwlagn_default_queue_to_tx_fifo);
 	}
 
 	/* Configure transport layer */
@@ -1460,9 +1412,6 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 		ucode_flags &= ~IWL_UCODE_TLV_FLAGS_P2P;
 		priv->sta_key_max_num = STA_KEY_MAX_NUM;
 		trans_cfg.cmd_queue = IWL_DEFAULT_CMD_QUEUE_NUM;
-		trans_cfg.queue_to_fifo = iwlagn_default_queue_to_tx_fifo;
-		trans_cfg.n_queue_to_fifo =
-			ARRAY_SIZE(iwlagn_default_queue_to_tx_fifo);
 
 		/* Configure transport layer again*/
 		iwl_trans_configure(priv->trans, &trans_cfg);
@@ -1480,9 +1429,6 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 		atomic_set(&priv->queue_stop_count[i], 0);
 	}
 
-	WARN_ON(trans_cfg.queue_to_fifo[trans_cfg.cmd_queue] !=
-						IWLAGN_CMD_FIFO_NUM);
-
 	if (iwl_init_drv(priv))
 		goto out_free_eeprom;
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/ucode.c b/drivers/net/wireless/iwlwifi/dvm/ucode.c
index b3a314b..6d8d6dd 100644
--- a/drivers/net/wireless/iwlwifi/dvm/ucode.c
+++ b/drivers/net/wireless/iwlwifi/dvm/ucode.c
@@ -226,13 +226,50 @@ int iwl_send_bt_env(struct iwl_priv *priv, u8 action, u8 type)
 	return ret;
 }
 
+static const u8 iwlagn_default_queue_to_tx_fifo[] = {
+	IWL_TX_FIFO_VO,
+	IWL_TX_FIFO_VI,
+	IWL_TX_FIFO_BE,
+	IWL_TX_FIFO_BK,
+};
+
+static const u8 iwlagn_ipan_queue_to_tx_fifo[] = {
+	IWL_TX_FIFO_VO,
+	IWL_TX_FIFO_VI,
+	IWL_TX_FIFO_BE,
+	IWL_TX_FIFO_BK,
+	IWL_TX_FIFO_BK_IPAN,
+	IWL_TX_FIFO_BE_IPAN,
+	IWL_TX_FIFO_VI_IPAN,
+	IWL_TX_FIFO_VO_IPAN,
+	IWL_TX_FIFO_BE_IPAN,
+	IWL_TX_FIFO_UNUSED,
+	IWL_TX_FIFO_AUX,
+};
 
 static int iwl_alive_notify(struct iwl_priv *priv)
 {
+	const u8 *queue_to_txf;
+	u8 n_queues;
 	int ret;
+	int i;
 
 	iwl_trans_fw_alive(priv->trans);
 
+	if (priv->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PAN &&
+	    priv->eeprom_data->sku & EEPROM_SKU_CAP_IPAN_ENABLE) {
+		n_queues = ARRAY_SIZE(iwlagn_ipan_queue_to_tx_fifo);
+		queue_to_txf = iwlagn_ipan_queue_to_tx_fifo;
+	} else {
+		n_queues = ARRAY_SIZE(iwlagn_default_queue_to_tx_fifo);
+		queue_to_txf = iwlagn_default_queue_to_tx_fifo;
+	}
+
+	for (i = 0; i < n_queues; i++)
+		if (queue_to_txf[i] != IWL_TX_FIFO_UNUSED)
+			iwl_trans_ac_txq_enable(priv->trans, i,
+						queue_to_txf[i]);
+
 	priv->passive_no_rx = false;
 	priv->transport_queue_stop = 0;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 00efde8..867d8e1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -290,16 +290,17 @@ static inline struct page *rxb_steal_page(struct iwl_rx_cmd_buffer *r)
  * currently supports
  */
 #define IWL_MAX_HW_QUEUES		32
+#define IWL_INVALID_STATION	255
+#define IWL_MAX_TID_COUNT	8
+#define IWL_FRAME_LIMIT	64
 
 /**
  * struct iwl_trans_config - transport configuration
  *
  * @op_mode: pointer to the upper layer.
- * @queue_to_fifo: queue to FIFO mapping to set up by
- *	default
- * @n_queue_to_fifo: number of queues to set up
  * @cmd_queue: the index of the command queue.
  *	Must be set before start_fw.
+ * @cmd_fifo: the fifo for host commands
  * @no_reclaim_cmds: Some devices erroneously don't set the
  *	SEQ_RX_FRAME bit on some notifications, this is the
  *	list of such notifications to filter. Max length is
@@ -314,10 +315,9 @@ static inline struct page *rxb_steal_page(struct iwl_rx_cmd_buffer *r)
  */
 struct iwl_trans_config {
 	struct iwl_op_mode *op_mode;
-	const u8 *queue_to_fifo;
-	u8 n_queue_to_fifo;
 
 	u8 cmd_queue;
+	u8 cmd_fifo;
 	const u8 *no_reclaim_cmds;
 	int n_no_reclaim_cmds;
 
@@ -355,9 +355,9 @@ struct iwl_trans;
  *	Must be atomic
  * @reclaim: free packet until ssn. Returns a list of freed packets.
  *	Must be atomic
- * @txq_enable: setup a tx queue for AMPDU - will be called once the HW is
- *	ready and a successful ADDBA response has been received.
- *	May sleep
+ * @txq_enable: setup a queue. To setup an AC queue, use the
+ *	iwl_trans_ac_txq_enable wrapper. fw_alive must have been called before
+ *	this one. The op_mode must not configure the HCMD queue. May sleep.
  * @txq_disable: de-configure a Tx queue to send AMPDUs
  *	Must be atomic
  * @wait_tx_queue_empty: wait until all tx queues are empty
@@ -497,9 +497,9 @@ static inline void iwl_trans_fw_alive(struct iwl_trans *trans)
 {
 	might_sleep();
 
-	trans->ops->fw_alive(trans);
-
 	trans->state = IWL_TRANS_FW_ALIVE;
+
+	trans->ops->fw_alive(trans);
 }
 
 static inline int iwl_trans_start_fw(struct iwl_trans *trans,
@@ -593,6 +593,13 @@ static inline void iwl_trans_txq_enable(struct iwl_trans *trans, int queue,
 				 frame_limit, ssn);
 }
 
+static inline void iwl_trans_ac_txq_enable(struct iwl_trans *trans, int queue,
+					   int fifo)
+{
+	iwl_trans_txq_enable(trans, queue, fifo, IWL_INVALID_STATION,
+			     IWL_MAX_TID_COUNT, IWL_FRAME_LIMIT, 0);
+}
+
 static inline int iwl_trans_wait_tx_queue_empty(struct iwl_trans *trans)
 {
 	WARN_ONCE(trans->state != IWL_TRANS_FW_ALIVE,
diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index 5024fb6..d9694c5 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -269,10 +269,9 @@ struct iwl_trans_pcie {
 	wait_queue_head_t ucode_write_waitq;
 	unsigned long status;
 	u8 cmd_queue;
+	u8 cmd_fifo;
 	u8 n_no_reclaim_cmds;
 	u8 no_reclaim_cmds[MAX_NO_RECLAIM_CMDS];
-	u8 setup_q_to_fifo[IWL_MAX_HW_QUEUES];
-	u8 n_q_to_fifo;
 
 	bool rx_buf_size_8k;
 	u32 rx_page_order;
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 42f369d..bac0eb0 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1059,7 +1059,7 @@ static void iwl_tx_start(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	u32 a;
-	int i, chan;
+	int chan;
 	u32 reg_val;
 
 	/* make sure all queue are not stopped/used */
@@ -1091,12 +1091,8 @@ static void iwl_tx_start(struct iwl_trans *trans)
 	 */
 	iwl_write_prph(trans, SCD_CHAINEXT_EN, 0);
 
-	for (i = 0; i < trans_pcie->n_q_to_fifo; i++) {
-		int fifo = trans_pcie->setup_q_to_fifo[i];
-
-		iwl_trans_pcie_txq_enable(trans, i, fifo, IWL_INVALID_STATION,
-					  IWL_TID_NON_QOS, SCD_FRAME_LIMIT, 0);
-	}
+	iwl_trans_ac_txq_enable(trans, trans_pcie->cmd_queue,
+				trans_pcie->cmd_fifo);
 
 	/* Activate all Tx DMA/FIFO channels */
 	iwl_trans_txq_set_sched(trans, IWL_MASK(0, 7));
@@ -1528,6 +1524,7 @@ static void iwl_trans_pcie_configure(struct iwl_trans *trans,
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	trans_pcie->cmd_queue = trans_cfg->cmd_queue;
+	trans_pcie->cmd_fifo = trans_cfg->cmd_fifo;
 	if (WARN_ON(trans_cfg->n_no_reclaim_cmds > MAX_NO_RECLAIM_CMDS))
 		trans_pcie->n_no_reclaim_cmds = 0;
 	else
@@ -1536,17 +1533,6 @@ static void iwl_trans_pcie_configure(struct iwl_trans *trans,
 		memcpy(trans_pcie->no_reclaim_cmds, trans_cfg->no_reclaim_cmds,
 		       trans_pcie->n_no_reclaim_cmds * sizeof(u8));
 
-	trans_pcie->n_q_to_fifo = trans_cfg->n_queue_to_fifo;
-
-	if (WARN_ON(trans_pcie->n_q_to_fifo > IWL_MAX_HW_QUEUES))
-		trans_pcie->n_q_to_fifo = IWL_MAX_HW_QUEUES;
-
-	/* at least the command queue must be mapped */
-	WARN_ON(!trans_pcie->n_q_to_fifo);
-
-	memcpy(trans_pcie->setup_q_to_fifo, trans_cfg->queue_to_fifo,
-	       trans_pcie->n_q_to_fifo * sizeof(u8));
-
 	trans_pcie->rx_buf_size_8k = trans_cfg->rx_buf_size_8k;
 	if (trans_pcie->rx_buf_size_8k)
 		trans_pcie->rx_page_order = get_order(8 * 1024);
-- 
1.7.10

