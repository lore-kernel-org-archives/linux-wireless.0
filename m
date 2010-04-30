Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:50644 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757104Ab0D3XAg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Apr 2010 19:00:36 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 7/8] iwlwifi: set hw parameters based on device type
Date: Fri, 30 Apr 2010 16:00:24 -0700
Message-Id: <1272668425-3753-8-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1272668425-3753-1-git-send-email-reinette.chatre@intel.com>
References: <1272668425-3753-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Separate the hw_set_hw_params() function to per device based; different
devices can have different hardware parameters set, when separate the
function based on device type can avoid mistakes, give more flexibilities and
easier to read.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |   73 ++++++++++++++++++++++---------
 drivers/net/wireless/iwlwifi/iwl-6000.c |   70 +++++++++++++++++++++--------
 2 files changed, 103 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index e434936..115d3ea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -200,26 +200,57 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 
 	/* Set initial sensitivity parameters */
 	/* Set initial calibration set */
-	switch (priv->hw_rev & CSR_HW_REV_TYPE_MSK) {
-	case CSR_HW_REV_TYPE_5150:
-		priv->hw_params.sens = &iwl5150_sensitivity;
-		priv->hw_params.calib_init_cfg =
-			BIT(IWL_CALIB_DC)		|
-			BIT(IWL_CALIB_LO)		|
-			BIT(IWL_CALIB_TX_IQ) 		|
-			BIT(IWL_CALIB_BASE_BAND);
-
-		break;
-	default:
-		priv->hw_params.sens = &iwl5000_sensitivity;
-		priv->hw_params.calib_init_cfg =
-			BIT(IWL_CALIB_XTAL)		|
-			BIT(IWL_CALIB_LO)		|
-			BIT(IWL_CALIB_TX_IQ) 		|
-			BIT(IWL_CALIB_TX_IQ_PERD)	|
-			BIT(IWL_CALIB_BASE_BAND);
-		break;
-	}
+	priv->hw_params.sens = &iwl5000_sensitivity;
+	priv->hw_params.calib_init_cfg =
+		BIT(IWL_CALIB_XTAL)		|
+		BIT(IWL_CALIB_LO)		|
+		BIT(IWL_CALIB_TX_IQ)		|
+		BIT(IWL_CALIB_TX_IQ_PERD)	|
+		BIT(IWL_CALIB_BASE_BAND);
+
+	return 0;
+}
+
+static int iwl5150_hw_set_hw_params(struct iwl_priv *priv)
+{
+	if (priv->cfg->mod_params->num_of_queues >= IWL_MIN_NUM_QUEUES &&
+	    priv->cfg->mod_params->num_of_queues <= IWLAGN_NUM_QUEUES)
+		priv->cfg->num_of_queues =
+			priv->cfg->mod_params->num_of_queues;
+
+	priv->hw_params.max_txq_num = priv->cfg->num_of_queues;
+	priv->hw_params.dma_chnl_num = FH50_TCSR_CHNL_NUM;
+	priv->hw_params.scd_bc_tbls_size =
+			priv->cfg->num_of_queues *
+			sizeof(struct iwlagn_scd_bc_tbl);
+	priv->hw_params.tfd_size = sizeof(struct iwl_tfd);
+	priv->hw_params.max_stations = IWL5000_STATION_COUNT;
+	priv->hw_params.bcast_sta_id = IWL5000_BROADCAST_ID;
+
+	priv->hw_params.max_data_size = IWLAGN_RTC_DATA_SIZE;
+	priv->hw_params.max_inst_size = IWLAGN_RTC_INST_SIZE;
+
+	priv->hw_params.max_bsm_size = 0;
+	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
+					BIT(IEEE80211_BAND_5GHZ);
+	priv->hw_params.rx_wrt_ptr_reg = FH_RSCSR_CHNL0_WPTR;
+
+	priv->hw_params.tx_chains_num = num_of_ant(priv->cfg->valid_tx_ant);
+	priv->hw_params.rx_chains_num = num_of_ant(priv->cfg->valid_rx_ant);
+	priv->hw_params.valid_tx_ant = priv->cfg->valid_tx_ant;
+	priv->hw_params.valid_rx_ant = priv->cfg->valid_rx_ant;
+
+	if (priv->cfg->ops->lib->temp_ops.set_ct_kill)
+		priv->cfg->ops->lib->temp_ops.set_ct_kill(priv);
+
+	/* Set initial sensitivity parameters */
+	/* Set initial calibration set */
+	priv->hw_params.sens = &iwl5150_sensitivity;
+	priv->hw_params.calib_init_cfg =
+		BIT(IWL_CALIB_DC)		|
+		BIT(IWL_CALIB_LO)		|
+		BIT(IWL_CALIB_TX_IQ)		|
+		BIT(IWL_CALIB_BASE_BAND);
 
 	return 0;
 }
@@ -332,7 +363,7 @@ static struct iwl_lib_ops iwl5000_lib = {
 };
 
 static struct iwl_lib_ops iwl5150_lib = {
-	.set_hw_params = iwl5000_hw_set_hw_params,
+	.set_hw_params = iwl5150_hw_set_hw_params,
 	.txq_update_byte_cnt_tbl = iwlagn_txq_update_byte_cnt_tbl,
 	.txq_inval_byte_cnt_tbl = iwlagn_txq_inval_byte_cnt_tbl,
 	.txq_set_sched = iwlagn_txq_set_sched,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 7da23d3..c492650 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -176,24 +176,56 @@ static int iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 	/* Set initial sensitivity parameters */
 	/* Set initial calibration set */
 	priv->hw_params.sens = &iwl6000_sensitivity;
-	switch (priv->hw_rev & CSR_HW_REV_TYPE_MSK) {
-	case CSR_HW_REV_TYPE_6x50:
-		priv->hw_params.calib_init_cfg =
-			BIT(IWL_CALIB_XTAL)		|
-			BIT(IWL_CALIB_DC)		|
-			BIT(IWL_CALIB_LO)		|
-			BIT(IWL_CALIB_TX_IQ) 		|
-			BIT(IWL_CALIB_BASE_BAND);
-
-		break;
-	default:
-		priv->hw_params.calib_init_cfg =
-			BIT(IWL_CALIB_XTAL)		|
-			BIT(IWL_CALIB_LO)		|
-			BIT(IWL_CALIB_TX_IQ) 		|
-			BIT(IWL_CALIB_BASE_BAND);
-		break;
-	}
+	priv->hw_params.calib_init_cfg =
+		BIT(IWL_CALIB_XTAL)		|
+		BIT(IWL_CALIB_LO)		|
+		BIT(IWL_CALIB_TX_IQ)		|
+		BIT(IWL_CALIB_BASE_BAND);
+
+	return 0;
+}
+
+static int iwl6050_hw_set_hw_params(struct iwl_priv *priv)
+{
+	if (priv->cfg->mod_params->num_of_queues >= IWL_MIN_NUM_QUEUES &&
+	    priv->cfg->mod_params->num_of_queues <= IWLAGN_NUM_QUEUES)
+		priv->cfg->num_of_queues =
+			priv->cfg->mod_params->num_of_queues;
+
+	priv->hw_params.max_txq_num = priv->cfg->num_of_queues;
+	priv->hw_params.dma_chnl_num = FH50_TCSR_CHNL_NUM;
+	priv->hw_params.scd_bc_tbls_size =
+			priv->cfg->num_of_queues *
+			sizeof(struct iwlagn_scd_bc_tbl);
+	priv->hw_params.tfd_size = sizeof(struct iwl_tfd);
+	priv->hw_params.max_stations = IWL5000_STATION_COUNT;
+	priv->hw_params.bcast_sta_id = IWL5000_BROADCAST_ID;
+
+	priv->hw_params.max_data_size = IWL60_RTC_DATA_SIZE;
+	priv->hw_params.max_inst_size = IWL60_RTC_INST_SIZE;
+
+	priv->hw_params.max_bsm_size = 0;
+	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
+					BIT(IEEE80211_BAND_5GHZ);
+	priv->hw_params.rx_wrt_ptr_reg = FH_RSCSR_CHNL0_WPTR;
+
+	priv->hw_params.tx_chains_num = num_of_ant(priv->cfg->valid_tx_ant);
+	priv->hw_params.rx_chains_num = num_of_ant(priv->cfg->valid_rx_ant);
+	priv->hw_params.valid_tx_ant = priv->cfg->valid_tx_ant;
+	priv->hw_params.valid_rx_ant = priv->cfg->valid_rx_ant;
+
+	if (priv->cfg->ops->lib->temp_ops.set_ct_kill)
+		priv->cfg->ops->lib->temp_ops.set_ct_kill(priv);
+
+	/* Set initial sensitivity parameters */
+	/* Set initial calibration set */
+	priv->hw_params.sens = &iwl6000_sensitivity;
+	priv->hw_params.calib_init_cfg =
+		BIT(IWL_CALIB_XTAL)		|
+		BIT(IWL_CALIB_DC)		|
+		BIT(IWL_CALIB_LO)		|
+		BIT(IWL_CALIB_TX_IQ)		|
+		BIT(IWL_CALIB_BASE_BAND);
 
 	return 0;
 }
@@ -304,7 +336,7 @@ static const struct iwl_ops iwl6000_ops = {
 };
 
 static struct iwl_lib_ops iwl6050_lib = {
-	.set_hw_params = iwl6000_hw_set_hw_params,
+	.set_hw_params = iwl6050_hw_set_hw_params,
 	.txq_update_byte_cnt_tbl = iwlagn_txq_update_byte_cnt_tbl,
 	.txq_inval_byte_cnt_tbl = iwlagn_txq_inval_byte_cnt_tbl,
 	.txq_set_sched = iwlagn_txq_set_sched,
-- 
1.6.3.3

