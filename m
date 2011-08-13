Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32836 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064Ab1HMSS4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:18:56 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 38/60] iwlagn: remove unused parameters from hw_params
Date: Sat, 13 Aug 2011 10:38:14 -0700
Message-Id: <1313257116-2697-39-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_201929_436543_10C16477)
In-Reply-To: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Some of them weren't used at all, the others always had the same value since
the driver split.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c     |    4 ----
 drivers/net/wireless/iwlwifi/iwl-2000.c     |    4 ----
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    8 --------
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    4 ----
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    4 ----
 drivers/net/wireless/iwlwifi/iwl-commands.h |    1 -
 drivers/net/wireless/iwlwifi/iwl-core.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h   |    9 ---------
 drivers/net/wireless/iwlwifi/iwl-trans.c    |    9 ++++++---
 9 files changed, 7 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 554d8ac..13dc94b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -130,10 +130,6 @@ static int iwl1000_hw_set_hw_params(struct iwl_priv *priv)
 			iwlagn_mod_params.num_of_queues;
 
 	hw_params(priv).max_txq_num = priv->cfg->base_params->num_of_queues;
-	hw_params(priv).scd_bc_tbls_size =
-			priv->cfg->base_params->num_of_queues *
-			sizeof(struct iwlagn_scd_bc_tbl);
-	hw_params(priv).tfd_size = sizeof(struct iwl_tfd);
 	hw_params(priv).max_stations = IWLAGN_STATION_COUNT;
 	priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id = IWLAGN_BROADCAST_ID;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 4e6eb89..ee7cce8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -127,10 +127,6 @@ static int iwl2000_hw_set_hw_params(struct iwl_priv *priv)
 			iwlagn_mod_params.num_of_queues;
 
 	hw_params(priv).max_txq_num = priv->cfg->base_params->num_of_queues;
-	hw_params(priv).scd_bc_tbls_size =
-		priv->cfg->base_params->num_of_queues *
-		sizeof(struct iwlagn_scd_bc_tbl);
-	hw_params(priv).tfd_size = sizeof(struct iwl_tfd);
 	hw_params(priv).max_stations = IWLAGN_STATION_COUNT;
 	priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id = IWLAGN_BROADCAST_ID;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 1049aed..d6a7f26 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -158,10 +158,6 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 			iwlagn_mod_params.num_of_queues;
 
 	hw_params(priv).max_txq_num = priv->cfg->base_params->num_of_queues;
-	hw_params(priv).scd_bc_tbls_size =
-			priv->cfg->base_params->num_of_queues *
-			sizeof(struct iwlagn_scd_bc_tbl);
-	hw_params(priv).tfd_size = sizeof(struct iwl_tfd);
 	hw_params(priv).max_stations = IWLAGN_STATION_COUNT;
 	priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id = IWLAGN_BROADCAST_ID;
 
@@ -201,10 +197,6 @@ static int iwl5150_hw_set_hw_params(struct iwl_priv *priv)
 			iwlagn_mod_params.num_of_queues;
 
 	hw_params(priv).max_txq_num = priv->cfg->base_params->num_of_queues;
-	hw_params(priv).scd_bc_tbls_size =
-			priv->cfg->base_params->num_of_queues *
-			sizeof(struct iwlagn_scd_bc_tbl);
-	hw_params(priv).tfd_size = sizeof(struct iwl_tfd);
 	hw_params(priv).max_stations = IWLAGN_STATION_COUNT;
 	priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id = IWLAGN_BROADCAST_ID;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 3965c3d..ab5d3c5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -147,10 +147,6 @@ static int iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 			iwlagn_mod_params.num_of_queues;
 
 	hw_params(priv).max_txq_num = priv->cfg->base_params->num_of_queues;
-	hw_params(priv).scd_bc_tbls_size =
-			priv->cfg->base_params->num_of_queues *
-			sizeof(struct iwlagn_scd_bc_tbl);
-	hw_params(priv).tfd_size = sizeof(struct iwl_tfd);
 	hw_params(priv).max_stations = IWLAGN_STATION_COUNT;
 	priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id = IWLAGN_BROADCAST_ID;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 14f72dc..0dec6a3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3255,8 +3255,6 @@ static u32 iwl_hw_detect(struct iwl_priv *priv)
 
 static int iwl_set_hw_params(struct iwl_priv *priv)
 {
-	hw_params(priv).max_rxq_size = RX_QUEUE_SIZE;
-	hw_params(priv).max_rxq_log = RX_QUEUE_SIZE_LOG;
 	if (iwlagn_mod_params.amsdu_size_8K)
 		hw_params(priv).rx_page_order =
 			get_order(IWL_RX_BUF_SIZE_8K);
@@ -3264,8 +3262,6 @@ static int iwl_set_hw_params(struct iwl_priv *priv)
 		hw_params(priv).rx_page_order =
 			get_order(IWL_RX_BUF_SIZE_4K);
 
-	hw_params(priv).max_beacon_itrvl = IWL_MAX_UCODE_BEACON_INTERVAL;
-
 	if (iwlagn_mod_params.disable_11n)
 		priv->cfg->sku &= ~EEPROM_SKU_CAP_11N_ENABLE;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index b478206..2e8b386 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -673,7 +673,6 @@ struct iwl_rxon_assoc_cmd {
 
 #define IWL_CONN_MAX_LISTEN_INTERVAL	10
 #define IWL_MAX_UCODE_BEACON_INTERVAL	4 /* 4096 */
-#define IWL39_MAX_UCODE_BEACON_INTERVAL	1 /* 1024 */
 
 /*
  * REPLY_RXON_TIMING = 0x14 (command, has simple generic response)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index cfc23c2..048c8e2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -359,7 +359,7 @@ int iwl_send_rxon_timing(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 		beacon_int = le16_to_cpu(ctx->timing.beacon_interval);
 	} else {
 		beacon_int = iwl_adjust_beacon_interval(beacon_int,
-			hw_params(priv).max_beacon_itrvl * TIME_UNIT);
+			IWL_MAX_UCODE_BEACON_INTERVAL * TIME_UNIT);
 		ctx->timing.beacon_interval = cpu_to_le16(beacon_int);
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 1229eb3..7145e48 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -121,12 +121,8 @@ struct iwl_mod_params {
 /**
  * struct iwl_hw_params
  * @max_txq_num: Max # Tx queues supported
- * @scd_bc_tbls_size: size of scheduler byte count tables
- * @tfd_size: TFD size
  * @tx/rx_chains_num: Number of TX/RX chains
  * @valid_tx/rx_ant: usable antennas
- * @max_rxq_size: Max # Rx frames in Rx queue (must be power-of-2)
- * @max_rxq_log: Log-base-2 of max_rxq_size
  * @rx_page_order: Rx buffer page order
  * @rx_wrt_ptr_reg: FH{39}_RSCSR_CHNL0_WPTR
  * @max_stations:
@@ -142,18 +138,13 @@ struct iwl_mod_params {
  */
 struct iwl_hw_params {
 	u8 max_txq_num;
-	u16 scd_bc_tbls_size;
-	u32 tfd_size;
 	u8  tx_chains_num;
 	u8  rx_chains_num;
 	u8  valid_tx_ant;
 	u8  valid_rx_ant;
-	u16 max_rxq_size;
-	u16 max_rxq_log;
 	u32 rx_page_order;
 	u8  max_stations;
 	u8  ht40_channel;
-	u8  max_beacon_itrvl;	/* in 1024 ms */
 	u32 max_inst_size;
 	u32 max_data_size;
 	u32 ct_kill_threshold; /* value in hw-dependent units */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 2ffacb2..4f3fdca 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -302,7 +302,7 @@ static int iwl_trans_txq_alloc(struct iwl_trans *trans,
 				struct iwl_tx_queue *txq, int slots_num,
 				u32 txq_id)
 {
-	size_t tfd_sz = hw_params(trans).tfd_size * TFD_QUEUE_SIZE_MAX;
+	size_t tfd_sz = sizeof(struct iwl_tfd) * TFD_QUEUE_SIZE_MAX;
 	int i;
 
 	if (WARN_ON(txq->meta || txq->cmd || txq->txb || txq->tfds))
@@ -448,7 +448,7 @@ static void iwl_tx_queue_free(struct iwl_trans *trans, int txq_id)
 
 	/* De-alloc circular buffer of TFDs */
 	if (txq->q.n_bd) {
-		dma_free_coherent(dev, hw_params(trans).tfd_size *
+		dma_free_coherent(dev, sizeof(struct iwl_tfd) *
 				  txq->q.n_bd, txq->tfds, txq->q.dma_addr);
 		memset(&txq->q.dma_addr, 0, sizeof(txq->q.dma_addr));
 	}
@@ -509,6 +509,9 @@ static int iwl_trans_tx_alloc(struct iwl_trans *trans)
 	struct iwl_trans_pcie *trans_pcie =
 		IWL_TRANS_GET_PCIE_TRANS(trans);
 
+	u16 scd_bc_tbls_size = priv->cfg->base_params->num_of_queues *
+			sizeof(struct iwlagn_scd_bc_tbl);
+
 	/*It is not allowed to alloc twice, so warn when this happens.
 	 * We cannot rely on the previous allocation, so free and fail */
 	if (WARN_ON(priv->txq)) {
@@ -517,7 +520,7 @@ static int iwl_trans_tx_alloc(struct iwl_trans *trans)
 	}
 
 	ret = iwlagn_alloc_dma_ptr(trans, &trans_pcie->scd_bc_tbls,
-				hw_params(trans).scd_bc_tbls_size);
+				   scd_bc_tbls_size);
 	if (ret) {
 		IWL_ERR(trans, "Scheduler BC Table allocation failed\n");
 		goto error;
-- 
1.7.0.4

