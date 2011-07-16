Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:7249 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755485Ab1GPPcO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jul 2011 11:32:14 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/18] iwlagn: remove dual-indirect call to simply the code
Date: Sat, 16 Jul 2011 07:56:27 -0700
Message-Id: <1310828199-18000-8-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110716_173225_473912_13C52B58)
In-Reply-To: <1310828199-18000-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1310828199-18000-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After driver split, no need to make the code so complex

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c    |    8 +----
 drivers/net/wireless/iwlwifi/iwl-2000.c    |   24 +++--------------
 drivers/net/wireless/iwlwifi/iwl-5000.c    |   14 ++--------
 drivers/net/wireless/iwlwifi/iwl-6000.c    |   38 ++++++++-------------------
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c     |   20 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-core.h    |    8 +----
 drivers/net/wireless/iwlwifi/iwl-eeprom.c  |   10 +++---
 drivers/net/wireless/iwlwifi/iwl-rx.c      |    6 ++--
 9 files changed, 41 insertions(+), 89 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 2f56b34..e21f718 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -186,10 +186,6 @@ static struct iwl_lib_ops iwl1000_lib = {
 	.temperature = iwlagn_temperature,
 };
 
-static const struct iwl_ops iwl1000_ops = {
-	.lib = &iwl1000_lib,
-};
-
 static struct iwl_base_params iwl1000_base_params = {
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
@@ -217,7 +213,7 @@ static struct iwl_ht_params iwl1000_ht_params = {
 	.ucode_api_min = IWL1000_UCODE_API_MIN,			\
 	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_1000_TX_POWER_VERSION,	\
-	.ops = &iwl1000_ops,					\
+	.lib = &iwl1000_lib,					\
 	.base_params = &iwl1000_base_params,			\
 	.led_mode = IWL_LED_BLINK
 
@@ -238,7 +234,7 @@ struct iwl_cfg iwl1000_bg_cfg = {
 	.ucode_api_min = IWL100_UCODE_API_MIN,			\
 	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_1000_TX_POWER_VERSION,	\
-	.ops = &iwl1000_ops,					\
+	.lib = &iwl1000_lib,					\
 	.base_params = &iwl1000_base_params,			\
 	.led_mode = IWL_LED_RF_STATE,				\
 	.rx_with_siso_diversity = true
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 32ac865..f72f619 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -208,22 +208,6 @@ static struct iwl_lib_ops iwl2030_lib = {
 	.temperature = iwlagn_temperature,
 };
 
-static const struct iwl_ops iwl2000_ops = {
-	.lib = &iwl2000_lib,
-};
-
-static const struct iwl_ops iwl2030_ops = {
-	.lib = &iwl2030_lib,
-};
-
-static const struct iwl_ops iwl105_ops = {
-	.lib = &iwl2000_lib,
-};
-
-static const struct iwl_ops iwl135_ops = {
-	.lib = &iwl2030_lib,
-};
-
 static struct iwl_base_params iwl2000_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
@@ -282,7 +266,7 @@ static struct iwl_bt_params iwl2030_bt_params = {
 	.ucode_api_min = IWL2000_UCODE_API_MIN,			\
 	.eeprom_ver = EEPROM_2000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
-	.ops = &iwl2000_ops,					\
+	.lib = &iwl2000_lib,					\
 	.base_params = &iwl2000_base_params,			\
 	.need_dc_calib = true,					\
 	.need_temp_offset_calib = true,				\
@@ -307,7 +291,7 @@ struct iwl_cfg iwl2000_2bg_cfg = {
 	.ucode_api_min = IWL2030_UCODE_API_MIN,			\
 	.eeprom_ver = EEPROM_2000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
-	.ops = &iwl2030_ops,					\
+	.lib = &iwl2030_lib,					\
 	.base_params = &iwl2030_base_params,			\
 	.bt_params = &iwl2030_bt_params,			\
 	.need_dc_calib = true,					\
@@ -333,7 +317,7 @@ struct iwl_cfg iwl2030_2bg_cfg = {
 	.ucode_api_min = IWL105_UCODE_API_MIN,			\
 	.eeprom_ver = EEPROM_2000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
-	.ops = &iwl105_ops,					\
+	.lib = &iwl2000_lib,					\
 	.base_params = &iwl2000_base_params,			\
 	.need_dc_calib = true,					\
 	.need_temp_offset_calib = true,				\
@@ -358,7 +342,7 @@ struct iwl_cfg iwl105_bgn_cfg = {
 	.ucode_api_min = IWL135_UCODE_API_MIN,			\
 	.eeprom_ver = EEPROM_2000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
-	.ops = &iwl135_ops,					\
+	.lib = &iwl2030_lib,					\
 	.base_params = &iwl2030_base_params,			\
 	.bt_params = &iwl2030_bt_params,			\
 	.need_dc_calib = true,					\
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 5564893..33b383c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -360,14 +360,6 @@ static struct iwl_lib_ops iwl5150_lib = {
 	.temperature = iwl5150_temperature,
 };
 
-static const struct iwl_ops iwl5000_ops = {
-	.lib = &iwl5000_lib,
-};
-
-static const struct iwl_ops iwl5150_ops = {
-	.lib = &iwl5150_lib,
-};
-
 static struct iwl_base_params iwl5000_base_params = {
 	.eeprom_size = IWLAGN_EEPROM_IMG_SIZE,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
@@ -390,7 +382,7 @@ static struct iwl_ht_params iwl5000_ht_params = {
 	.ucode_api_min = IWL5000_UCODE_API_MIN,			\
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,	\
-	.ops = &iwl5000_ops,					\
+	.lib = &iwl5000_lib,					\
 	.base_params = &iwl5000_base_params,			\
 	.led_mode = IWL_LED_BLINK
 
@@ -433,7 +425,7 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.ucode_api_min = IWL5000_UCODE_API_MIN,
 	.eeprom_ver = EEPROM_5050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5050_TX_POWER_VERSION,
-	.ops = &iwl5000_ops,
+	.lib = &iwl5000_lib,
 	.base_params = &iwl5000_base_params,
 	.ht_params = &iwl5000_ht_params,
 	.led_mode = IWL_LED_BLINK,
@@ -446,7 +438,7 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.ucode_api_min = IWL5150_UCODE_API_MIN,			\
 	.eeprom_ver = EEPROM_5050_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_5050_TX_POWER_VERSION,	\
-	.ops = &iwl5150_ops,					\
+	.lib = &iwl5150_lib,					\
 	.base_params = &iwl5000_base_params,			\
 	.need_dc_calib = true,					\
 	.led_mode = IWL_LED_BLINK,				\
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 80f1ef6..f6b309d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -106,9 +106,9 @@ static void iwl6000_nic_config(struct iwl_priv *priv)
 			     CSR_GP_DRIVER_REG_BIT_RADIO_SKU_2x2_IPA);
 	}
 	/* do additional nic configuration if needed */
-	if (priv->cfg->ops->nic &&
-		priv->cfg->ops->nic->additional_nic_config) {
-			priv->cfg->ops->nic->additional_nic_config(priv);
+	if (priv->cfg->nic &&
+		priv->cfg->nic->additional_nic_config) {
+			priv->cfg->nic->additional_nic_config(priv);
 	}
 }
 
@@ -311,24 +311,6 @@ static struct iwl_nic_ops iwl6150_nic_ops = {
 	.additional_nic_config = &iwl6150_additional_nic_config,
 };
 
-static const struct iwl_ops iwl6000_ops = {
-	.lib = &iwl6000_lib,
-};
-
-static const struct iwl_ops iwl6050_ops = {
-	.lib = &iwl6000_lib,
-	.nic = &iwl6050_nic_ops,
-};
-
-static const struct iwl_ops iwl6150_ops = {
-	.lib = &iwl6000_lib,
-	.nic = &iwl6150_nic_ops,
-};
-
-static const struct iwl_ops iwl6030_ops = {
-	.lib = &iwl6030_lib,
-};
-
 static struct iwl_base_params iwl6000_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
@@ -402,7 +384,7 @@ static struct iwl_bt_params iwl6000_bt_params = {
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,		\
 	.eeprom_ver = EEPROM_6005_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_6005_TX_POWER_VERSION,	\
-	.ops = &iwl6000_ops,					\
+	.lib = &iwl6000_lib,					\
 	.base_params = &iwl6000_g2_base_params,			\
 	.need_dc_calib = true,					\
 	.need_temp_offset_calib = true,				\
@@ -430,7 +412,7 @@ struct iwl_cfg iwl6005_2bg_cfg = {
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,		\
 	.eeprom_ver = EEPROM_6030_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_6030_TX_POWER_VERSION,	\
-	.ops = &iwl6030_ops,					\
+	.lib = &iwl6030_lib,					\
 	.base_params = &iwl6000_g2_base_params,			\
 	.bt_params = &iwl6000_bt_params,			\
 	.need_dc_calib = true,					\
@@ -511,7 +493,7 @@ struct iwl_cfg iwl130_bg_cfg = {
 	.valid_rx_ant = ANT_BC,		/* .cfg overwrite */	\
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_6000_TX_POWER_VERSION,	\
-	.ops = &iwl6000_ops,					\
+	.lib = &iwl6000_lib,					\
 	.base_params = &iwl6000_base_params,			\
 	.pa_type = IWL_PA_INTERNAL,				\
 	.led_mode = IWL_LED_BLINK
@@ -538,7 +520,8 @@ struct iwl_cfg iwl6000i_2bg_cfg = {
 	.ucode_api_min = IWL6050_UCODE_API_MIN,			\
 	.valid_tx_ant = ANT_AB,		/* .cfg overwrite */	\
 	.valid_rx_ant = ANT_AB,		/* .cfg overwrite */	\
-	.ops = &iwl6050_ops,					\
+	.lib = &iwl6000_lib,					\
+	.nic = &iwl6050_nic_ops,				\
 	.eeprom_ver = EEPROM_6050_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_6050_TX_POWER_VERSION,	\
 	.base_params = &iwl6050_base_params,			\
@@ -561,7 +544,8 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 	.fw_name_pre = IWL6050_FW_PRE,				\
 	.ucode_api_max = IWL6050_UCODE_API_MAX,			\
 	.ucode_api_min = IWL6050_UCODE_API_MIN,			\
-	.ops = &iwl6150_ops,					\
+	.lib = &iwl6000_lib,					\
+	.nic = &iwl6150_nic_ops,				\
 	.eeprom_ver = EEPROM_6150_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_6150_TX_POWER_VERSION,	\
 	.base_params = &iwl6050_base_params,			\
@@ -587,7 +571,7 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.ucode_api_min = IWL6000_UCODE_API_MIN,
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6000_TX_POWER_VERSION,
-	.ops = &iwl6000_ops,
+	.lib = &iwl6000_lib,
 	.base_params = &iwl6000_base_params,
 	.ht_params = &iwl6000_ht_params,
 	.need_dc_calib = true,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index b282190..d4a6010 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -711,7 +711,7 @@ int iwlagn_hw_nic_init(struct iwl_priv *priv)
 
 	iwlagn_set_pwr_vmain(priv);
 
-	priv->cfg->ops->lib->nic_config(priv);
+	priv->cfg->lib->nic_config(priv);
 
 	/* Allocate the RX queue, or reset if it is already allocated */
 	trans_rx_init(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index dceb450..41c3e15 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -375,7 +375,7 @@ static void iwl_continuous_event_trace(struct iwl_priv *priv)
 	u32 next_entry; /* index of next entry to be written by uCode */
 
 	base = priv->device_pointers.error_event_table;
-	if (priv->cfg->ops->lib->is_valid_rtc_data_addr(base)) {
+	if (priv->cfg->lib->is_valid_rtc_data_addr(base)) {
 		capacity = iwl_read_targ_mem(priv, base);
 		num_wraps = iwl_read_targ_mem(priv, base + (2 * sizeof(u32)));
 		mode = iwl_read_targ_mem(priv, base + (1 * sizeof(u32)));
@@ -1614,7 +1614,7 @@ void iwl_dump_nic_error_log(struct iwl_priv *priv)
 			base = priv->_agn.inst_errlog_ptr;
 	}
 
-	if (!priv->cfg->ops->lib->is_valid_rtc_data_addr(base)) {
+	if (!priv->cfg->lib->is_valid_rtc_data_addr(base)) {
 		IWL_ERR(priv,
 			"Not valid error log pointer 0x%08X for %s uCode\n",
 			base,
@@ -1805,7 +1805,7 @@ int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 			base = priv->_agn.inst_evtlog_ptr;
 	}
 
-	if (!priv->cfg->ops->lib->is_valid_rtc_data_addr(base)) {
+	if (!priv->cfg->lib->is_valid_rtc_data_addr(base)) {
 		IWL_ERR(priv,
 			"Invalid event log pointer 0x%08X for %s uCode\n",
 			base,
@@ -2939,7 +2939,7 @@ static void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
 	if (!iwl_is_associated_ctx(ctx))
 		goto out;
 
-	if (!priv->cfg->ops->lib->set_channel_switch)
+	if (!priv->cfg->lib->set_channel_switch)
 		goto out;
 
 	ch = channel->hw_value;
@@ -2991,7 +2991,7 @@ static void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
 	 */
 	set_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status);
 	priv->switch_channel = cpu_to_le16(ch);
-	if (priv->cfg->ops->lib->set_channel_switch(priv, ch_switch)) {
+	if (priv->cfg->lib->set_channel_switch(priv, ch_switch)) {
 		clear_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status);
 		priv->switch_channel = 0;
 		ieee80211_chswitch_done(ctx->vif, false);
@@ -3198,8 +3198,8 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 
 	iwl_setup_scan_deferred_work(priv);
 
-	if (priv->cfg->ops->lib->setup_deferred_work)
-		priv->cfg->ops->lib->setup_deferred_work(priv);
+	if (priv->cfg->lib->setup_deferred_work)
+		priv->cfg->lib->setup_deferred_work(priv);
 
 	init_timer(&priv->statistics_periodic);
 	priv->statistics_periodic.data = (unsigned long)priv;
@@ -3216,8 +3216,8 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 
 static void iwl_cancel_deferred_work(struct iwl_priv *priv)
 {
-	if (priv->cfg->ops->lib->cancel_deferred_work)
-		priv->cfg->ops->lib->cancel_deferred_work(priv);
+	if (priv->cfg->lib->cancel_deferred_work)
+		priv->cfg->lib->cancel_deferred_work(priv);
 
 	cancel_work_sync(&priv->run_time_calib_work);
 	cancel_work_sync(&priv->beacon_update);
@@ -3397,7 +3397,7 @@ static int iwl_set_hw_params(struct iwl_priv *priv)
 		priv->cfg->sku &= ~EEPROM_SKU_CAP_11N_ENABLE;
 
 	/* Device-specific setup */
-	return priv->cfg->ops->lib->set_hw_params(priv);
+	return priv->cfg->lib->set_hw_params(priv);
 }
 
 static const u8 iwlagn_bss_ac_to_fifo[] = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 692c30c..d6d2760 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -108,11 +108,6 @@ struct iwl_nic_ops {
 	void (*additional_nic_config)(struct iwl_priv *priv);
 };
 
-struct iwl_ops {
-	const struct iwl_lib_ops *lib;
-	const struct iwl_nic_ops *nic;
-};
-
 struct iwl_mod_params {
 	int sw_crypto;		/* def: 0 = using hardware encryption */
 	int num_of_queues;	/* def: HW dependent */
@@ -247,7 +242,8 @@ struct iwl_cfg {
 	u16  sku;
 	u16  eeprom_ver;
 	u16  eeprom_calib_ver;
-	const struct iwl_ops *ops;
+	const struct iwl_lib_ops *lib;
+	const struct iwl_nic_ops *nic;
 	/* params not likely to change within a device family */
 	struct iwl_base_params *base_params;
 	/* params likely to change within a device family */
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index eee97bc..19d31a5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -543,7 +543,7 @@ static void iwl_init_band_reference(const struct iwl_priv *priv,
 			const struct iwl_eeprom_channel **eeprom_ch_info,
 			const u8 **eeprom_ch_index)
 {
-	u32 offset = priv->cfg->ops->lib->
+	u32 offset = priv->cfg->lib->
 			eeprom_ops.regulatory_bands[eep_band - 1];
 	switch (eep_band) {
 	case 1:		/* 2.4GHz band */
@@ -749,9 +749,9 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 	}
 
 	/* Check if we do have HT40 channels */
-	if (priv->cfg->ops->lib->eeprom_ops.regulatory_bands[5] ==
+	if (priv->cfg->lib->eeprom_ops.regulatory_bands[5] ==
 	    EEPROM_REGULATORY_BAND_NO_HT40 &&
-	    priv->cfg->ops->lib->eeprom_ops.regulatory_bands[6] ==
+	    priv->cfg->lib->eeprom_ops.regulatory_bands[6] ==
 	    EEPROM_REGULATORY_BAND_NO_HT40)
 		return 0;
 
@@ -787,8 +787,8 @@ int iwl_init_channel_map(struct iwl_priv *priv)
 	 * driver need to process addition information
 	 * to determine the max channel tx power limits
 	 */
-	if (priv->cfg->ops->lib->eeprom_ops.update_enhanced_txpower)
-		priv->cfg->ops->lib->eeprom_ops.update_enhanced_txpower(priv);
+	if (priv->cfg->lib->eeprom_ops.update_enhanced_txpower)
+		priv->cfg->lib->eeprom_ops.update_enhanced_txpower(priv);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index c5eb379..bd63b78 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -624,8 +624,8 @@ static void iwl_rx_statistics(struct iwl_priv *priv,
 		iwl_rx_calc_noise(priv);
 		queue_work(priv->workqueue, &priv->run_time_calib_work);
 	}
-	if (priv->cfg->ops->lib->temperature && change)
-		priv->cfg->ops->lib->temperature(priv);
+	if (priv->cfg->lib->temperature && change)
+		priv->cfg->lib->temperature(priv);
 }
 
 static void iwl_rx_reply_statistics(struct iwl_priv *priv,
@@ -1103,7 +1103,7 @@ void iwl_setup_rx_handlers(struct iwl_priv *priv)
 	handlers[REPLY_COMPRESSED_BA]		= iwlagn_rx_reply_compressed_ba;
 
 	/* Set up hardware specific Rx handlers */
-	priv->cfg->ops->lib->rx_handler_setup(priv);
+	priv->cfg->lib->rx_handler_setup(priv);
 }
 
 void iwl_rx_dispatch(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
-- 
1.7.0.4

