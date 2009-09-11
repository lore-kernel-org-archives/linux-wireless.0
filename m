Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:49357 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831AbZIKRiT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 13:38:19 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 05/13] iwlwifi: separate set_hw_params function for 6000 series
Date: Fri, 11 Sep 2009 10:38:11 -0700
Message-Id: <1252690699-25796-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1252690699-25796-1-git-send-email-reinette.chatre@intel.com>
References: <1252690699-25796-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Separate set_hw_params() function for 6000
series from 5000/1000 series because:
    1) 6000 series use different set of sensitivity range table
    2) 6000 series has different uCode image size

Also include the new sensitivity parameters needed by sensitivity
algorithm.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c  |   12 +----
 drivers/net/wireless/iwlwifi/iwl-6000.c  |   71 +++++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-calib.c |    2 +-
 3 files changed, 73 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index ea215bb..e4acfc3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -833,16 +833,8 @@ int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.max_stations = IWL5000_STATION_COUNT;
 	priv->hw_params.bcast_sta_id = IWL5000_BROADCAST_ID;
 
-	switch (priv->hw_rev & CSR_HW_REV_TYPE_MSK) {
-	case CSR_HW_REV_TYPE_6x00:
-	case CSR_HW_REV_TYPE_6x50:
-		priv->hw_params.max_data_size = IWL60_RTC_DATA_SIZE;
-		priv->hw_params.max_inst_size = IWL60_RTC_INST_SIZE;
-		break;
-	default:
-		priv->hw_params.max_data_size = IWL50_RTC_DATA_SIZE;
-		priv->hw_params.max_inst_size = IWL50_RTC_INST_SIZE;
-	}
+	priv->hw_params.max_data_size = IWL50_RTC_DATA_SIZE;
+	priv->hw_params.max_inst_size = IWL50_RTC_INST_SIZE;
 
 	priv->hw_params.max_bsm_size = 0;
 	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 36655c2..957205c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -44,6 +44,7 @@
 #include "iwl-sta.h"
 #include "iwl-helpers.h"
 #include "iwl-5000-hw.h"
+#include "iwl-6000-hw.h"
 
 /* Highest firmware API version supported */
 #define IWL6000_UCODE_API_MAX 4
@@ -100,8 +101,76 @@ static void iwl6000_nic_config(struct iwl_priv *priv)
 	/* else do nothing, uCode configured */
 }
 
+static struct iwl_sensitivity_ranges iwl6000_sensitivity = {
+	.min_nrg_cck = 97,
+	.max_nrg_cck = 0, /* not used, set to 0 */
+	.auto_corr_min_ofdm = 80,
+	.auto_corr_min_ofdm_mrc = 128,
+	.auto_corr_min_ofdm_x1 = 105,
+	.auto_corr_min_ofdm_mrc_x1 = 192,
+
+	.auto_corr_max_ofdm = 145,
+	.auto_corr_max_ofdm_mrc = 232,
+	.auto_corr_max_ofdm_x1 = 145,
+	.auto_corr_max_ofdm_mrc_x1 = 232,
+
+	.auto_corr_min_cck = 125,
+	.auto_corr_max_cck = 175,
+	.auto_corr_min_cck_mrc = 160,
+	.auto_corr_max_cck_mrc = 310,
+	.nrg_th_cck = 97,
+	.nrg_th_ofdm = 100,
+};
+
+static int iwl6000_hw_set_hw_params(struct iwl_priv *priv)
+{
+	if ((priv->cfg->mod_params->num_of_queues > IWL50_NUM_QUEUES) ||
+	    (priv->cfg->mod_params->num_of_queues < IWL_MIN_NUM_QUEUES)) {
+		IWL_ERR(priv,
+			"invalid queues_num, should be between %d and %d\n",
+			IWL_MIN_NUM_QUEUES, IWL50_NUM_QUEUES);
+		return -EINVAL;
+	}
+
+	priv->hw_params.max_txq_num = priv->cfg->mod_params->num_of_queues;
+	priv->hw_params.dma_chnl_num = FH50_TCSR_CHNL_NUM;
+	priv->hw_params.scd_bc_tbls_size =
+			IWL50_NUM_QUEUES * sizeof(struct iwl5000_scd_bc_tbl);
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
+			BIT(IWL_CALIB_XTAL)		|
+			BIT(IWL_CALIB_LO)		|
+			BIT(IWL_CALIB_TX_IQ) 		|
+			BIT(IWL_CALIB_TX_IQ_PERD)	|
+			BIT(IWL_CALIB_BASE_BAND);
+
+	return 0;
+}
+
 static struct iwl_lib_ops iwl6000_lib = {
-	.set_hw_params = iwl5000_hw_set_hw_params,
+	.set_hw_params = iwl6000_hw_set_hw_params,
 	.txq_update_byte_cnt_tbl = iwl5000_txq_update_byte_cnt_tbl,
 	.txq_inval_byte_cnt_tbl = iwl5000_txq_inval_byte_cnt_tbl,
 	.txq_set_sched = iwl5000_txq_set_sched,
diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.c b/drivers/net/wireless/iwlwifi/iwl-calib.c
index c4b565a..6e73317 100644
--- a/drivers/net/wireless/iwlwifi/iwl-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.c
@@ -516,7 +516,7 @@ void iwl_init_sensitivity(struct iwl_priv *priv)
 	for (i = 0; i < NRG_NUM_PREV_STAT_L; i++)
 		data->nrg_silence_rssi[i] = 0;
 
-	data->auto_corr_ofdm = 90;
+	data->auto_corr_ofdm =  ranges->auto_corr_min_ofdm;
 	data->auto_corr_ofdm_mrc = ranges->auto_corr_min_ofdm_mrc;
 	data->auto_corr_ofdm_x1  = ranges->auto_corr_min_ofdm_x1;
 	data->auto_corr_ofdm_mrc_x1 = ranges->auto_corr_min_ofdm_mrc_x1;
-- 
1.5.6.3

