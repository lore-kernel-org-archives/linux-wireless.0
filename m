Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:20654 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754464Ab0A2TyK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2010 14:54:10 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 06/12] iwlwifi: update sensitivity calibration data for 1000 series
Date: Fri, 29 Jan 2010 11:53:56 -0800
Message-Id: <1264794842-8046-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1264794842-8046-1-git-send-email-reinette.chatre@intel.com>
References: <1264794842-8046-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Update sensitivity range values for 1000 series

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |   72 ++++++++++++++++++++++++++++++-
 1 files changed, 71 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 4281999..9d18206 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -89,8 +89,78 @@ static void iwl1000_nic_config(struct iwl_priv *priv)
 				~APMG_SVR_VOLTAGE_CONFIG_BIT_MSK);
 }
 
+static struct iwl_sensitivity_ranges iwl1000_sensitivity = {
+	.min_nrg_cck = 95,
+	.max_nrg_cck = 0, /* not used, set to 0 */
+	.auto_corr_min_ofdm = 90,
+	.auto_corr_min_ofdm_mrc = 170,
+	.auto_corr_min_ofdm_x1 = 120,
+	.auto_corr_min_ofdm_mrc_x1 = 240,
+
+	.auto_corr_max_ofdm = 120,
+	.auto_corr_max_ofdm_mrc = 210,
+	.auto_corr_max_ofdm_x1 = 155,
+	.auto_corr_max_ofdm_mrc_x1 = 290,
+
+	.auto_corr_min_cck = 125,
+	.auto_corr_max_cck = 200,
+	.auto_corr_min_cck_mrc = 170,
+	.auto_corr_max_cck_mrc = 400,
+	.nrg_th_cck = 95,
+	.nrg_th_ofdm = 95,
+
+	.barker_corr_th_min = 190,
+	.barker_corr_th_min_mrc = 390,
+	.nrg_th_cca = 62,
+};
+
+static int iwl1000_hw_set_hw_params(struct iwl_priv *priv)
+{
+	if (priv->cfg->mod_params->num_of_queues >= IWL_MIN_NUM_QUEUES &&
+	    priv->cfg->mod_params->num_of_queues <= IWL50_NUM_QUEUES)
+		priv->cfg->num_of_queues =
+			priv->cfg->mod_params->num_of_queues;
+
+	priv->hw_params.max_txq_num = priv->cfg->num_of_queues;
+	priv->hw_params.dma_chnl_num = FH50_TCSR_CHNL_NUM;
+	priv->hw_params.scd_bc_tbls_size =
+			priv->cfg->num_of_queues *
+			sizeof(struct iwl5000_scd_bc_tbl);
+	priv->hw_params.tfd_size = sizeof(struct iwl_tfd);
+	priv->hw_params.max_stations = IWL5000_STATION_COUNT;
+	priv->hw_params.bcast_sta_id = IWL5000_BROADCAST_ID;
+
+	priv->hw_params.max_data_size = IWL50_RTC_DATA_SIZE;
+	priv->hw_params.max_inst_size = IWL50_RTC_INST_SIZE;
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
+	priv->hw_params.sens = &iwl1000_sensitivity;
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
 static struct iwl_lib_ops iwl1000_lib = {
-	.set_hw_params = iwl5000_hw_set_hw_params,
+	.set_hw_params = iwl1000_hw_set_hw_params,
 	.txq_update_byte_cnt_tbl = iwl5000_txq_update_byte_cnt_tbl,
 	.txq_inval_byte_cnt_tbl = iwl5000_txq_inval_byte_cnt_tbl,
 	.txq_set_sched = iwl5000_txq_set_sched,
-- 
1.6.3.3

