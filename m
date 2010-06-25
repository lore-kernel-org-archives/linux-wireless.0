Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:50072 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756826Ab0FYWnI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jun 2010 18:43:08 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/8] iwlwifi: enable DC calibration based on config parameter
Date: Fri, 25 Jun 2010 15:42:55 -0700
Message-Id: <1277505781-25268-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1277505781-25268-1-git-send-email-reinette.chatre@intel.com>
References: <1277505781-25268-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Different devices have different calibration requirement,
some need DC calibration and some don't; make it a cfg parameter
for easy management.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c   |    2 +
 drivers/net/wireless/iwlwifi/iwl-5000.c   |    5 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c   |  143 ++++-------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h   |    1 +
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |    3 +
 5 files changed, 29 insertions(+), 125 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index dba91e0..24743b9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -157,6 +157,8 @@ static int iwl1000_hw_set_hw_params(struct iwl_priv *priv)
 			BIT(IWL_CALIB_TX_IQ) 		|
 			BIT(IWL_CALIB_TX_IQ_PERD)	|
 			BIT(IWL_CALIB_BASE_BAND);
+	if (priv->cfg->need_dc_calib)
+		priv->hw_params.calib_init_cfg |= BIT(IWL_CALIB_DC);
 
 	priv->hw_params.beacon_time_tsf_bits = IWLAGN_EXT_BEACON_TIME_POS;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index c6ccc25..fa2dbb5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -249,10 +249,11 @@ static int iwl5150_hw_set_hw_params(struct iwl_priv *priv)
 	/* Set initial calibration set */
 	priv->hw_params.sens = &iwl5150_sensitivity;
 	priv->hw_params.calib_init_cfg =
-		BIT(IWL_CALIB_DC)		|
 		BIT(IWL_CALIB_LO)		|
 		BIT(IWL_CALIB_TX_IQ)		|
 		BIT(IWL_CALIB_BASE_BAND);
+	if (priv->cfg->need_dc_calib)
+		priv->hw_params.calib_init_cfg |= BIT(IWL_CALIB_DC);
 
 	priv->hw_params.beacon_time_tsf_bits = IWLAGN_EXT_BEACON_TIME_POS;
 
@@ -660,6 +661,7 @@ struct iwl_cfg iwl5150_agn_cfg = {
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
 	.chain_noise_calib_by_driver = true,
+	.need_dc_calib = true,
 };
 
 struct iwl_cfg iwl5150_abg_cfg = {
@@ -689,6 +691,7 @@ struct iwl_cfg iwl5150_abg_cfg = {
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
 	.chain_noise_calib_by_driver = true,
+	.need_dc_calib = true,
 };
 
 MODULE_FIRMWARE(IWL5000_MODULE_FIRMWARE(IWL5000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index afdeec5..c909a9c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -84,9 +84,10 @@ static void iwl6000_set_ct_threshold(struct iwl_priv *priv)
 }
 
 /* Indicate calibration version to uCode. */
-static void iwl6050_set_calib_version(struct iwl_priv *priv)
+static void iwl6000_set_calib_version(struct iwl_priv *priv)
 {
-	if (priv->cfg->ops->lib->eeprom_ops.calib_version(priv) >= 6)
+	if (priv->cfg->need_dc_calib &&
+	    (priv->cfg->ops->lib->eeprom_ops.calib_version(priv) >= 6))
 		iwl_set_bit(priv, CSR_GP_DRIVER_REG,
 				CSR_GP_DRIVER_REG_BIT_CALIB_VERSION6);
 }
@@ -186,53 +187,8 @@ static int iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 		BIT(IWL_CALIB_LO)		|
 		BIT(IWL_CALIB_TX_IQ)		|
 		BIT(IWL_CALIB_BASE_BAND);
-
-	priv->hw_params.beacon_time_tsf_bits = IWLAGN_EXT_BEACON_TIME_POS;
-
-	return 0;
-}
-
-static int iwl6050_hw_set_hw_params(struct iwl_priv *priv)
-{
-	if (priv->cfg->mod_params->num_of_queues >= IWL_MIN_NUM_QUEUES &&
-	    priv->cfg->mod_params->num_of_queues <= IWLAGN_NUM_QUEUES)
-		priv->cfg->num_of_queues =
-			priv->cfg->mod_params->num_of_queues;
-
-	priv->hw_params.max_txq_num = priv->cfg->num_of_queues;
-	priv->hw_params.dma_chnl_num = FH50_TCSR_CHNL_NUM;
-	priv->hw_params.scd_bc_tbls_size =
-			priv->cfg->num_of_queues *
-			sizeof(struct iwlagn_scd_bc_tbl);
-	priv->hw_params.tfd_size = sizeof(struct iwl_tfd);
-	priv->hw_params.max_stations = IWL5000_STATION_COUNT;
-	priv->hw_params.bcast_sta_id = IWL5000_BROADCAST_ID;
-
-	priv->hw_params.max_data_size = IWL60_RTC_DATA_SIZE;
-	priv->hw_params.max_inst_size = IWL60_RTC_INST_SIZE;
-
-	priv->hw_params.max_bsm_size = 0;
-	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
-					BIT(IEEE80211_BAND_5GHZ);
-	priv->hw_params.rx_wrt_ptr_reg = FH_RSCSR_CHNL0_WPTR;
-
-	priv->hw_params.tx_chains_num = num_of_ant(priv->cfg->valid_tx_ant);
-	priv->hw_params.rx_chains_num = num_of_ant(priv->cfg->valid_rx_ant);
-	priv->hw_params.valid_tx_ant = priv->cfg->valid_tx_ant;
-	priv->hw_params.valid_rx_ant = priv->cfg->valid_rx_ant;
-
-	if (priv->cfg->ops->lib->temp_ops.set_ct_kill)
-		priv->cfg->ops->lib->temp_ops.set_ct_kill(priv);
-
-	/* Set initial sensitivity parameters */
-	/* Set initial calibration set */
-	priv->hw_params.sens = &iwl6000_sensitivity;
-	priv->hw_params.calib_init_cfg =
-		BIT(IWL_CALIB_XTAL)		|
-		BIT(IWL_CALIB_DC)		|
-		BIT(IWL_CALIB_LO)		|
-		BIT(IWL_CALIB_TX_IQ)		|
-		BIT(IWL_CALIB_BASE_BAND);
+	if (priv->cfg->need_dc_calib)
+		priv->hw_params.calib_init_cfg |= BIT(IWL_CALIB_DC);
 
 	priv->hw_params.beacon_time_tsf_bits = IWLAGN_EXT_BEACON_TIME_POS;
 
@@ -359,6 +315,7 @@ static struct iwl_lib_ops iwl6000_lib = {
 	.temp_ops = {
 		.temperature = iwlagn_temperature,
 		.set_ct_kill = iwl6000_set_ct_threshold,
+		.set_calib_version = iwl6000_set_calib_version,
 	 },
 	.manage_ibss_station = iwlagn_manage_ibss_station,
 	.debugfs_ops = {
@@ -397,79 +354,6 @@ static const struct iwl_ops iwl6000g2b_ops = {
 	.led = &iwlagn_led_ops,
 };
 
-static struct iwl_lib_ops iwl6050_lib = {
-	.set_hw_params = iwl6050_hw_set_hw_params,
-	.txq_update_byte_cnt_tbl = iwlagn_txq_update_byte_cnt_tbl,
-	.txq_inval_byte_cnt_tbl = iwlagn_txq_inval_byte_cnt_tbl,
-	.txq_set_sched = iwlagn_txq_set_sched,
-	.txq_agg_enable = iwlagn_txq_agg_enable,
-	.txq_agg_disable = iwlagn_txq_agg_disable,
-	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
-	.txq_free_tfd = iwl_hw_txq_free_tfd,
-	.txq_init = iwl_hw_tx_queue_init,
-	.rx_handler_setup = iwlagn_rx_handler_setup,
-	.setup_deferred_work = iwlagn_setup_deferred_work,
-	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
-	.load_ucode = iwlagn_load_ucode,
-	.dump_nic_event_log = iwl_dump_nic_event_log,
-	.dump_nic_error_log = iwl_dump_nic_error_log,
-	.dump_csr = iwl_dump_csr,
-	.dump_fh = iwl_dump_fh,
-	.init_alive_start = iwlagn_init_alive_start,
-	.alive_notify = iwlagn_alive_notify,
-	.send_tx_power = iwlagn_send_tx_power,
-	.update_chain_flags = iwl_update_chain_flags,
-	.set_channel_switch = iwl6000_hw_channel_switch,
-	.apm_ops = {
-		.init = iwl_apm_init,
-		.stop = iwl_apm_stop,
-		.config = iwl6000_nic_config,
-		.set_pwr_src = iwl_set_pwr_src,
-	},
-	.eeprom_ops = {
-		.regulatory_bands = {
-			EEPROM_REG_BAND_1_CHANNELS,
-			EEPROM_REG_BAND_2_CHANNELS,
-			EEPROM_REG_BAND_3_CHANNELS,
-			EEPROM_REG_BAND_4_CHANNELS,
-			EEPROM_REG_BAND_5_CHANNELS,
-			EEPROM_6000_REG_BAND_24_HT40_CHANNELS,
-			EEPROM_REG_BAND_52_HT40_CHANNELS
-		},
-		.verify_signature  = iwlcore_eeprom_verify_signature,
-		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
-		.release_semaphore = iwlcore_eeprom_release_semaphore,
-		.calib_version	= iwlagn_eeprom_calib_version,
-		.query_addr = iwlagn_eeprom_query_addr,
-		.update_enhanced_txpower = iwlcore_eeprom_enhanced_txpower,
-	},
-	.post_associate = iwl_post_associate,
-	.isr = iwl_isr_ict,
-	.config_ap = iwl_config_ap,
-	.temp_ops = {
-		.temperature = iwlagn_temperature,
-		.set_ct_kill = iwl6000_set_ct_threshold,
-		.set_calib_version = iwl6050_set_calib_version,
-	 },
-	.manage_ibss_station = iwlagn_manage_ibss_station,
-	.debugfs_ops = {
-		.rx_stats_read = iwl_ucode_rx_stats_read,
-		.tx_stats_read = iwl_ucode_tx_stats_read,
-		.general_stats_read = iwl_ucode_general_stats_read,
-	},
-	.recover_from_tx_stall = iwl_bg_monitor_recover,
-	.check_plcp_health = iwl_good_plcp_health,
-	.check_ack_health = iwl_good_ack_health,
-};
-
-static const struct iwl_ops iwl6050_ops = {
-	.lib = &iwl6050_lib,
-	.hcmd = &iwlagn_hcmd,
-	.utils = &iwlagn_hcmd_utils,
-	.led = &iwlagn_led_ops,
-};
-
-
 struct iwl_cfg iwl6000g2a_2agn_cfg = {
 	.name = "6000 Series 2x2 AGN Gen2a",
 	.fw_name_pre = IWL6000G2A_FW_PRE,
@@ -505,6 +389,7 @@ struct iwl_cfg iwl6000g2a_2agn_cfg = {
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
 	.chain_noise_calib_by_driver = true,
+	.need_dc_calib = true,
 };
 
 struct iwl_cfg iwl6000g2a_2abg_cfg = {
@@ -537,6 +422,7 @@ struct iwl_cfg iwl6000g2a_2abg_cfg = {
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 512,
+	.need_dc_calib = true,
 };
 
 struct iwl_cfg iwl6000g2a_2bg_cfg = {
@@ -569,6 +455,7 @@ struct iwl_cfg iwl6000g2a_2bg_cfg = {
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 512,
+	.need_dc_calib = true,
 };
 
 struct iwl_cfg iwl6000g2b_2agn_cfg = {
@@ -603,6 +490,7 @@ struct iwl_cfg iwl6000g2b_2agn_cfg = {
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 512,
+	.need_dc_calib = true,
 };
 
 struct iwl_cfg iwl6000g2b_2abg_cfg = {
@@ -635,6 +523,7 @@ struct iwl_cfg iwl6000g2b_2abg_cfg = {
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 512,
+	.need_dc_calib = true,
 };
 
 struct iwl_cfg iwl6000g2b_2bgn_cfg = {
@@ -669,6 +558,7 @@ struct iwl_cfg iwl6000g2b_2bgn_cfg = {
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 512,
+	.need_dc_calib = true,
 };
 
 struct iwl_cfg iwl6000g2b_2bg_cfg = {
@@ -701,6 +591,7 @@ struct iwl_cfg iwl6000g2b_2bg_cfg = {
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 512,
+	.need_dc_calib = true,
 };
 
 struct iwl_cfg iwl6000g2b_bgn_cfg = {
@@ -735,6 +626,7 @@ struct iwl_cfg iwl6000g2b_bgn_cfg = {
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 512,
+	.need_dc_calib = true,
 };
 
 struct iwl_cfg iwl6000g2b_bg_cfg = {
@@ -767,6 +659,7 @@ struct iwl_cfg iwl6000g2b_bg_cfg = {
 	.chain_noise_scale = 1000,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 512,
+	.need_dc_calib = true,
 };
 
 /*
@@ -885,7 +778,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.ucode_api_max = IWL6050_UCODE_API_MAX,
 	.ucode_api_min = IWL6050_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
-	.ops = &iwl6050_ops,
+	.ops = &iwl6000_ops,
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_6050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6050_TX_POWER_VERSION,
@@ -914,6 +807,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
 	.chain_noise_calib_by_driver = true,
+	.need_dc_calib = true,
 };
 
 struct iwl_cfg iwl6050_2abg_cfg = {
@@ -922,7 +816,7 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 	.ucode_api_max = IWL6050_UCODE_API_MAX,
 	.ucode_api_min = IWL6050_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G,
-	.ops = &iwl6050_ops,
+	.ops = &iwl6000_ops,
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_6050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6050_TX_POWER_VERSION,
@@ -949,6 +843,7 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
 	.chain_noise_calib_by_driver = true,
+	.need_dc_calib = true,
 };
 
 struct iwl_cfg iwl6000_3agn_cfg = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 5e72d74..cdcb51d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -330,6 +330,7 @@ struct iwl_cfg {
 	const bool chain_noise_calib_by_driver;
 	u8 scan_rx_antennas[IEEE80211_NUM_BANDS];
 	u8 scan_tx_antennas[IEEE80211_NUM_BANDS];
+	const bool need_dc_calib;
 };
 
 /***************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index ee11452..a45d02e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -629,6 +629,9 @@ int iwl_eeprom_check_version(struct iwl_priv *priv)
 	    calib_ver < priv->cfg->eeprom_calib_ver)
 		goto err;
 
+	IWL_INFO(priv, "device EEPROM VER=0x%x, CALIB=0x%x\n",
+		 eeprom_ver, calib_ver);
+
 	return 0;
 err:
 	IWL_ERR(priv, "Unsupported (too old) EEPROM VER=0x%x < 0x%x CALIB=0x%x < 0x%x\n",
-- 
1.7.0.4

