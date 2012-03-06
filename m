Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20496 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031488Ab2CFWnf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 17:43:35 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 17/33] iwlwifi: remove max_txq_num from hw_params
Date: Tue,  6 Mar 2012 13:30:52 -0800
Message-Id: <1331069468-11074-18-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120306_234415_353517_AD6CE3D3)
In-Reply-To: <1331069468-11074-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331069468-11074-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This can be used directly from the config now.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c          |    2 -
 drivers/net/wireless/iwlwifi/iwl-2000.c          |    2 -
 drivers/net/wireless/iwlwifi/iwl-5000.c          |    4 --
 drivers/net/wireless/iwlwifi/iwl-6000.c          |    2 -
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.c          |    3 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h          |    4 --
 drivers/net/wireless/iwlwifi/iwl-shared.h        |    2 -
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |    3 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c    |   35 ++++++++++++++-------
 12 files changed, 30 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 5039a9a..c3e30b0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -122,8 +122,6 @@ static struct iwl_sensitivity_ranges iwl1000_sensitivity = {
 
 static void iwl1000_hw_set_hw_params(struct iwl_priv *priv)
 {
-	hw_params(priv).max_txq_num = cfg(priv)->base_params->num_of_queues;
-
 	hw_params(priv).ht40_channel =  BIT(IEEE80211_BAND_2GHZ);
 
 	hw_params(priv).tx_chains_num =
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index c173962..212f292 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -118,8 +118,6 @@ static struct iwl_sensitivity_ranges iwl2000_sensitivity = {
 
 static void iwl2000_hw_set_hw_params(struct iwl_priv *priv)
 {
-	hw_params(priv).max_txq_num = cfg(priv)->base_params->num_of_queues;
-
 	hw_params(priv).ht40_channel =  BIT(IEEE80211_BAND_2GHZ);
 
 	hw_params(priv).tx_chains_num =
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index fc6ec07..cbcec33 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -157,8 +157,6 @@ static void iwl5000_set_ct_threshold(struct iwl_priv *priv)
 
 static void iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 {
-	hw_params(priv).max_txq_num = cfg(priv)->base_params->num_of_queues;
-
 	hw_params(priv).ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
 					BIT(IEEE80211_BAND_5GHZ);
 
@@ -175,8 +173,6 @@ static void iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 
 static void iwl5150_hw_set_hw_params(struct iwl_priv *priv)
 {
-	hw_params(priv).max_txq_num = cfg(priv)->base_params->num_of_queues;
-
 	hw_params(priv).ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
 					BIT(IEEE80211_BAND_5GHZ);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index a64f0f2..b3ceaad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -139,8 +139,6 @@ static struct iwl_sensitivity_ranges iwl6000_sensitivity = {
 
 static void iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 {
-	hw_params(priv).max_txq_num = cfg(priv)->base_params->num_of_queues;
-
 	hw_params(priv).ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
 					BIT(IEEE80211_BAND_5GHZ);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index dd28785..ab2221d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -1129,7 +1129,7 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 	 * (in Tx queue's circular buffer) of first TFD/frame in window */
 	u16 ba_resp_scd_ssn = le16_to_cpu(ba_resp->scd_ssn);
 
-	if (scd_flow >= hw_params(priv).max_txq_num) {
+	if (scd_flow >= cfg(priv)->base_params->num_of_queues) {
 		IWL_ERR(priv,
 			"BUG_ON scd_flow is bigger than number of queues\n");
 		return 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index c5fcbdc..95ffa01 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1350,7 +1350,8 @@ void iwl_bg_watchdog(unsigned long data)
 
 	/* monitor and check for other stuck queues */
 	if (iwl_is_any_associated(priv)) {
-		for (cnt = 0; cnt < hw_params(priv).max_txq_num; cnt++) {
+		for (cnt = 0; cnt < cfg(priv)->base_params->num_of_queues;
+		     cnt++) {
 			/* skip as we already checked the command queue */
 			if (cnt == priv->shrd->cmd_queue)
 				continue;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index b9b6d62..8fefb43 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -834,7 +834,7 @@ static ssize_t iwl_dbgfs_traffic_log_read(struct file *file,
 
 	char *buf;
 	int bufsz = ((IWL_TRAFFIC_ENTRIES * IWL_TRAFFIC_ENTRY_SIZE * 64) * 2) +
-		(hw_params(priv).max_txq_num * 32 * 8) + 400;
+		(cfg(priv)->base_params->num_of_queues * 32 * 8) + 400;
 	const u8 *ptr;
 	ssize_t ret;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index a4d1101..75dc20b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -216,10 +216,6 @@
 #define SCD_TRANS_TBL_OFFSET_QUEUE(x) \
 	((SCD_TRANS_TBL_MEM_LOWER_BOUND + ((x) * 2)) & 0xfffc)
 
-#define SCD_QUEUECHAIN_SEL_ALL(priv)	\
-	(((1<<hw_params(priv).max_txq_num) - 1) &\
-	(~(1<<(priv)->shrd->cmd_queue)))
-
 #define SCD_BASE			(PRPH_BASE + 0xa02c00)
 
 #define SCD_SRAM_BASE_ADDR	(SCD_BASE + 0x0)
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index ab2e1f7..5fac263 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -160,7 +160,6 @@ struct iwl_mod_params {
  *
  * Holds the module parameters
  *
- * @max_txq_num: Max # Tx queues supported
  * @num_ampdu_queues: num of ampdu queues
  * @tx_chains_num: Number of TX chains
  * @rx_chains_num: Number of RX chains
@@ -176,7 +175,6 @@ struct iwl_mod_params {
  * @struct iwl_sensitivity_ranges: range of sensitivity values
  */
 struct iwl_hw_params {
-	u8  max_txq_num;
 	u8  num_ampdu_queues;
 	u8  tx_chains_num;
 	u8  rx_chains_num;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index f145621..6214855 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -1049,7 +1049,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 	if (inta & CSR_INT_BIT_WAKEUP) {
 		IWL_DEBUG_ISR(trans, "Wakeup interrupt\n");
 		iwl_rx_queue_update_write_ptr(trans, &trans_pcie->rxq);
-		for (i = 0; i < hw_params(trans).max_txq_num; i++)
+		for (i = 0; i < cfg(trans)->base_params->num_of_queues; i++)
 			iwl_txq_update_write_ptr(trans,
 						 &trans_pcie->txq[i]);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index 7feeb2d..9af5c8f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -595,7 +595,8 @@ static int iwlagn_txq_ctx_activate_free(struct iwl_trans *trans)
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int txq_id;
 
-	for (txq_id = 0; txq_id < hw_params(trans).max_txq_num; txq_id++)
+	for (txq_id = 0; txq_id < cfg(trans)->base_params->num_of_queues;
+	     txq_id++)
 		if (!test_and_set_bit(txq_id,
 					&trans_pcie->txq_ctx_active_msk))
 			return txq_id;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 6090e98..6da9972 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -78,6 +78,11 @@
 
 #define IWL_MASK(lo, hi) ((1 << (hi)) | ((1 << (hi)) - (1 << (lo))))
 
+#define SCD_QUEUECHAIN_SEL_ALL(trans)	\
+	(((1<<cfg(trans)->base_params->num_of_queues) - 1) &\
+	(~(1<<(trans)->shrd->cmd_queue)))
+
+
 static int iwl_trans_rx_alloc(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie =
@@ -492,7 +497,7 @@ static void iwl_trans_pcie_tx_free(struct iwl_trans *trans)
 	/* Tx queues */
 	if (trans_pcie->txq) {
 		for (txq_id = 0;
-		     txq_id < hw_params(trans).max_txq_num; txq_id++)
+		     txq_id < cfg(trans)->base_params->num_of_queues; txq_id++)
 			iwl_tx_queue_free(trans, txq_id);
 	}
 
@@ -517,7 +522,7 @@ static int iwl_trans_tx_alloc(struct iwl_trans *trans)
 	int txq_id, slots_num;
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
-	u16 scd_bc_tbls_size = hw_params(trans).max_txq_num *
+	u16 scd_bc_tbls_size = cfg(trans)->base_params->num_of_queues *
 			sizeof(struct iwlagn_scd_bc_tbl);
 
 	/*It is not allowed to alloc twice, so warn when this happens.
@@ -541,7 +546,7 @@ static int iwl_trans_tx_alloc(struct iwl_trans *trans)
 		goto error;
 	}
 
-	trans_pcie->txq = kcalloc(hw_params(trans).max_txq_num,
+	trans_pcie->txq = kcalloc(cfg(trans)->base_params->num_of_queues,
 				  sizeof(struct iwl_tx_queue), GFP_KERNEL);
 	if (!trans_pcie->txq) {
 		IWL_ERR(trans, "Not enough memory for txq\n");
@@ -550,7 +555,8 @@ static int iwl_trans_tx_alloc(struct iwl_trans *trans)
 	}
 
 	/* Alloc and init all Tx queues, including the command queue (#4/#9) */
-	for (txq_id = 0; txq_id < hw_params(trans).max_txq_num; txq_id++) {
+	for (txq_id = 0; txq_id < cfg(trans)->base_params->num_of_queues;
+	     txq_id++) {
 		slots_num = (txq_id == trans->shrd->cmd_queue) ?
 					TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
 		ret = iwl_trans_txq_alloc(trans, &trans_pcie->txq[txq_id],
@@ -595,7 +601,8 @@ static int iwl_tx_init(struct iwl_trans *trans)
 	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 
 	/* Alloc and init all Tx queues, including the command queue (#4/#9) */
-	for (txq_id = 0; txq_id < hw_params(trans).max_txq_num; txq_id++) {
+	for (txq_id = 0; txq_id < cfg(trans)->base_params->num_of_queues;
+	     txq_id++) {
 		slots_num = (txq_id == trans->shrd->cmd_queue) ?
 					TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
 		ret = iwl_trans_txq_init(trans, &trans_pcie->txq[txq_id],
@@ -1113,7 +1120,8 @@ static void iwl_tx_start(struct iwl_trans *trans)
 		a += 4)
 		iwl_write_targ_mem(trans, a, 0);
 	for (; a < trans_pcie->scd_base_addr +
-	       SCD_TRANS_TBL_OFFSET_QUEUE(hw_params(trans).max_txq_num);
+	       SCD_TRANS_TBL_OFFSET_QUEUE(
+				cfg(trans)->base_params->num_of_queues);
 	       a += 4)
 		iwl_write_targ_mem(trans, a, 0);
 
@@ -1136,7 +1144,7 @@ static void iwl_tx_start(struct iwl_trans *trans)
 	iwl_write_prph(trans, SCD_AGGR_SEL, 0);
 
 	/* initiate the queues */
-	for (i = 0; i < hw_params(trans).max_txq_num; i++) {
+	for (i = 0; i < cfg(trans)->base_params->num_of_queues; i++) {
 		iwl_write_prph(trans, SCD_QUEUE_RDPTR(i), 0);
 		iwl_write_direct32(trans, HBUS_TARG_WRPTR, 0 | (i << 8));
 		iwl_write_targ_mem(trans, trans_pcie->scd_base_addr +
@@ -1153,7 +1161,7 @@ static void iwl_tx_start(struct iwl_trans *trans)
 	}
 
 	iwl_write_prph(trans, SCD_INTERRUPT_MASK,
-			IWL_MASK(0, hw_params(trans).max_txq_num));
+			IWL_MASK(0, cfg(trans)->base_params->num_of_queues));
 
 	/* Activate all Tx DMA/FIFO channels */
 	iwl_trans_txq_set_sched(trans, IWL_MASK(0, 7));
@@ -1242,7 +1250,8 @@ static int iwl_trans_tx_stop(struct iwl_trans *trans)
 	}
 
 	/* Unmap DMA from host system and free skb's */
-	for (txq_id = 0; txq_id < hw_params(trans).max_txq_num; txq_id++)
+	for (txq_id = 0; txq_id < cfg(trans)->base_params->num_of_queues;
+	     txq_id++)
 		iwl_tx_queue_unmap(trans, txq_id);
 
 	return 0;
@@ -1700,7 +1709,7 @@ static int iwl_trans_pcie_wait_tx_queue_empty(struct iwl_trans *trans)
 	int ret = 0;
 
 	/* waiting for all the tx frames complete might take a while */
-	for (cnt = 0; cnt < hw_params(trans).max_txq_num; cnt++) {
+	for (cnt = 0; cnt < cfg(trans)->base_params->num_of_queues; cnt++) {
 		if (cnt == trans->shrd->cmd_queue)
 			continue;
 		txq = &trans_pcie->txq[cnt];
@@ -1946,7 +1955,9 @@ static ssize_t iwl_dbgfs_tx_queue_read(struct file *file,
 	int pos = 0;
 	int cnt;
 	int ret;
-	const size_t bufsz = sizeof(char) * 64 * hw_params(trans).max_txq_num;
+	size_t bufsz;
+
+	bufsz = sizeof(char) * 64 * cfg(trans)->base_params->num_of_queues;
 
 	if (!trans_pcie->txq) {
 		IWL_ERR(trans, "txq not ready\n");
@@ -1956,7 +1967,7 @@ static ssize_t iwl_dbgfs_tx_queue_read(struct file *file,
 	if (!buf)
 		return -ENOMEM;
 
-	for (cnt = 0; cnt < hw_params(trans).max_txq_num; cnt++) {
+	for (cnt = 0; cnt < cfg(trans)->base_params->num_of_queues; cnt++) {
 		txq = &trans_pcie->txq[cnt];
 		q = &txq->q;
 		pos += scnprintf(buf + pos, bufsz - pos,
-- 
1.7.0.4

