Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:22322 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222AbZEUUhx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 16:37:53 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/3] iwlwifi: Temperature sensor voltage reading for 5150
Date: Thu, 21 May 2009 13:44:23 -0700
Message-Id: <1242938663-7937-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1242938663-7937-3-git-send-email-reinette.chatre@intel.com>
References: <1242938663-7937-1-git-send-email-reinette.chatre@intel.com>
 <1242938663-7937-2-git-send-email-reinette.chatre@intel.com>
 <1242938663-7937-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

The temperature measurement by uCode for 5150 and 5000 are different
        CSR_HW_REV_TYPE_5150: temperature sensor output voltage
        CSR_HW_REV_TYPE_5000: temperature in Celsius
temperature related operation for 5150 is measured by temperature sensor
output voltage; additional conversion is required for set and store
the temperature.

To make sure support different HW design; implement _ops method for
temperature related functions (temperature reading and set ct kill
threshold)

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c    |   14 +++-
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h |   12 +++
 drivers/net/wireless/iwlwifi/iwl-5000.c    |  108 ++++++++++++++++++++++------
 drivers/net/wireless/iwlwifi/iwl-core.h    |   28 +++++---
 drivers/net/wireless/iwlwifi/iwl-rx.c      |    4 +-
 5 files changed, 131 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index a98ff4e..97131e6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -788,6 +788,12 @@ static struct iwl_sensitivity_ranges iwl4965_sensitivity = {
 	.nrg_th_ofdm = 100,
 };
 
+static void iwl4965_set_ct_threshold(struct iwl_priv *priv)
+{
+	/* want Kelvin */
+	priv->hw_params.ct_kill_threshold = CELSIUS_TO_KELVIN(CT_KILL_THRESHOLD);
+}
+
 /**
  * iwl4965_hw_set_hw_params
  *
@@ -822,7 +828,8 @@ static int iwl4965_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.rx_chains_num = 2;
 	priv->hw_params.valid_tx_ant = ANT_A | ANT_B;
 	priv->hw_params.valid_rx_ant = ANT_A | ANT_B;
-	priv->hw_params.ct_kill_threshold = CELSIUS_TO_KELVIN(CT_KILL_THRESHOLD);
+	if (priv->cfg->ops->lib->temp_ops.set_ct_kill)
+		priv->cfg->ops->lib->temp_ops.set_ct_kill(priv);
 
 	priv->hw_params.sens = &iwl4965_sensitivity;
 
@@ -2331,9 +2338,12 @@ static struct iwl_lib_ops iwl4965_lib = {
 	},
 	.send_tx_power	= iwl4965_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
-	.temperature = iwl4965_temperature_calib,
 	.post_associate = iwl_post_associate,
 	.config_ap = iwl_config_ap,
+	.temp_ops = {
+		.temperature = iwl4965_temperature_calib,
+		.set_ct_kill = iwl4965_set_ct_threshold,
+	},
 };
 
 static struct iwl_ops iwl4965_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
index 15cac70..4ef6804 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
@@ -87,6 +87,18 @@
 #define IWL50_NUM_AMPDU_QUEUES		  10
 #define IWL50_FIRST_AMPDU_QUEUE		  10
 
+/* 5150 only */
+#define IWL_5150_VOLTAGE_TO_TEMPERATURE_COEFF	(-5)
+
+static inline s32 iwl_temp_calib_to_offset(struct iwl_priv *priv)
+{
+	u16 *temp_calib = (u16 *)iwl_eeprom_query_addr(priv,
+						       EEPROM_5000_TEMPERATURE);
+	/* offset =  temperature -  voltage / coef */
+	s32 offset = (s32)(temp_calib[0] - temp_calib[1] / IWL_5150_VOLTAGE_TO_TEMPERATURE_COEFF);
+	return offset;
+}
+
 /* Fixed (non-configurable) rx data from phy */
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 72090e0..3681315 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -434,15 +434,19 @@ static const u8 *iwl5000_eeprom_query_addr(const struct iwl_priv *priv,
 	return &priv->eeprom[address];
 }
 
-static s32 iwl5150_get_ct_threshold(struct iwl_priv *priv)
+static void iwl5150_set_ct_threshold(struct iwl_priv *priv)
 {
-	const s32 volt2temp_coef = -5;
-	u16 *temp_calib = (u16 *)iwl_eeprom_query_addr(priv,
-						EEPROM_5000_TEMPERATURE);
-	/* offset =  temperate -  voltage / coef */
-	s32 offset = temp_calib[0] - temp_calib[1] / volt2temp_coef;
-	s32 threshold = (s32)CELSIUS_TO_KELVIN(CT_KILL_THRESHOLD) - offset;
-	return threshold * volt2temp_coef;
+	const s32 volt2temp_coef = IWL_5150_VOLTAGE_TO_TEMPERATURE_COEFF;
+	s32 threshold = (s32)CELSIUS_TO_KELVIN(CT_KILL_THRESHOLD) -
+			iwl_temp_calib_to_offset(priv);
+
+	priv->hw_params.ct_kill_threshold = threshold * volt2temp_coef;
+}
+
+static void iwl5000_set_ct_threshold(struct iwl_priv *priv)
+{
+	/* want Celsius */
+	priv->hw_params.ct_kill_threshold = CT_KILL_THRESHOLD;
 }
 
 /*
@@ -868,17 +872,8 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.valid_tx_ant = priv->cfg->valid_tx_ant;
 	priv->hw_params.valid_rx_ant = priv->cfg->valid_rx_ant;
 
-	switch (priv->hw_rev & CSR_HW_REV_TYPE_MSK) {
-	case CSR_HW_REV_TYPE_5150:
-		/* 5150 wants in Kelvin */
-		priv->hw_params.ct_kill_threshold =
-				iwl5150_get_ct_threshold(priv);
-		break;
-	default:
-		/* all others want Celsius */
-		priv->hw_params.ct_kill_threshold = CT_KILL_THRESHOLD;
-		break;
-	}
+	if (priv->cfg->ops->lib->temp_ops.set_ct_kill)
+		priv->cfg->ops->lib->temp_ops.set_ct_kill(priv);
 
 	/* Set initial calibration set */
 	switch (priv->hw_rev & CSR_HW_REV_TYPE_MSK) {
@@ -900,7 +895,6 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 		break;
 	}
 
-
 	return 0;
 }
 
@@ -1434,6 +1428,17 @@ static void iwl5000_temperature(struct iwl_priv *priv)
 	priv->temperature = le32_to_cpu(priv->statistics.general.temperature);
 }
 
+static void iwl5150_temperature(struct iwl_priv *priv)
+{
+	u32 vt = 0;
+	s32 offset =  iwl_temp_calib_to_offset(priv);
+
+	vt = le32_to_cpu(priv->statistics.general.temperature);
+	vt = vt / IWL_5150_VOLTAGE_TO_TEMPERATURE_COEFF + offset;
+	/* now vt hold the temperature in Kelvin */
+	priv->temperature = KELVIN_TO_CELSIUS(vt);
+}
+
 /* Calc max signal level (dBm) among 3 possible receivers */
 int iwl5000_calc_rssi(struct iwl_priv *priv,
 			     struct iwl_rx_phy_res *rx_resp)
@@ -1511,7 +1516,6 @@ struct iwl_lib_ops iwl5000_lib = {
 	.init_alive_start = iwl5000_init_alive_start,
 	.alive_notify = iwl5000_alive_notify,
 	.send_tx_power = iwl5000_send_tx_power,
-	.temperature = iwl5000_temperature,
 	.update_chain_flags = iwl_update_chain_flags,
 	.apm_ops = {
 		.init =	iwl5000_apm_init,
@@ -1538,6 +1542,59 @@ struct iwl_lib_ops iwl5000_lib = {
 	},
 	.post_associate = iwl_post_associate,
 	.config_ap = iwl_config_ap,
+	.temp_ops = {
+		.temperature = iwl5000_temperature,
+		.set_ct_kill = iwl5000_set_ct_threshold,
+	 },
+};
+
+static struct iwl_lib_ops iwl5150_lib = {
+	.set_hw_params = iwl5000_hw_set_hw_params,
+	.txq_update_byte_cnt_tbl = iwl5000_txq_update_byte_cnt_tbl,
+	.txq_inval_byte_cnt_tbl = iwl5000_txq_inval_byte_cnt_tbl,
+	.txq_set_sched = iwl5000_txq_set_sched,
+	.txq_agg_enable = iwl5000_txq_agg_enable,
+	.txq_agg_disable = iwl5000_txq_agg_disable,
+	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
+	.txq_free_tfd = iwl_hw_txq_free_tfd,
+	.txq_init = iwl_hw_tx_queue_init,
+	.rx_handler_setup = iwl5000_rx_handler_setup,
+	.setup_deferred_work = iwl5000_setup_deferred_work,
+	.is_valid_rtc_data_addr = iwl5000_hw_valid_rtc_data_addr,
+	.load_ucode = iwl5000_load_ucode,
+	.init_alive_start = iwl5000_init_alive_start,
+	.alive_notify = iwl5000_alive_notify,
+	.send_tx_power = iwl5000_send_tx_power,
+	.update_chain_flags = iwl_update_chain_flags,
+	.apm_ops = {
+		.init =	iwl5000_apm_init,
+		.reset = iwl5000_apm_reset,
+		.stop = iwl5000_apm_stop,
+		.config = iwl5000_nic_config,
+		.set_pwr_src = iwl_set_pwr_src,
+	},
+	.eeprom_ops = {
+		.regulatory_bands = {
+			EEPROM_5000_REG_BAND_1_CHANNELS,
+			EEPROM_5000_REG_BAND_2_CHANNELS,
+			EEPROM_5000_REG_BAND_3_CHANNELS,
+			EEPROM_5000_REG_BAND_4_CHANNELS,
+			EEPROM_5000_REG_BAND_5_CHANNELS,
+			EEPROM_5000_REG_BAND_24_FAT_CHANNELS,
+			EEPROM_5000_REG_BAND_52_FAT_CHANNELS
+		},
+		.verify_signature  = iwlcore_eeprom_verify_signature,
+		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
+		.release_semaphore = iwlcore_eeprom_release_semaphore,
+		.calib_version	= iwl5000_eeprom_calib_version,
+		.query_addr = iwl5000_eeprom_query_addr,
+	},
+	.post_associate = iwl_post_associate,
+	.config_ap = iwl_config_ap,
+	.temp_ops = {
+		.temperature = iwl5150_temperature,
+		.set_ct_kill = iwl5150_set_ct_threshold,
+	 },
 };
 
 struct iwl_ops iwl5000_ops = {
@@ -1547,6 +1604,13 @@ struct iwl_ops iwl5000_ops = {
 	.smgmt = &iwl5000_station_mgmt,
 };
 
+static struct iwl_ops iwl5150_ops = {
+	.lib = &iwl5150_lib,
+	.hcmd = &iwl5000_hcmd,
+	.utils = &iwl5000_hcmd_utils,
+	.smgmt = &iwl5000_station_mgmt,
+};
+
 struct iwl_mod_params iwl50_mod_params = {
 	.num_of_queues = IWL50_NUM_QUEUES,
 	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
@@ -1642,7 +1706,7 @@ struct iwl_cfg iwl5150_agn_cfg = {
 	.ucode_api_max = IWL5150_UCODE_API_MAX,
 	.ucode_api_min = IWL5150_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
-	.ops = &iwl5000_ops,
+	.ops = &iwl5150_ops,
 	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
 	.eeprom_ver = EEPROM_5050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5050_TX_POWER_VERSION,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index f3544ea..a0ed415 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -112,6 +112,19 @@ struct iwl_hcmd_utils_ops {
 			  struct iwl_rx_phy_res *rx_resp);
 };
 
+struct iwl_apm_ops {
+	int (*init)(struct iwl_priv *priv);
+	int (*reset)(struct iwl_priv *priv);
+	void (*stop)(struct iwl_priv *priv);
+	void (*config)(struct iwl_priv *priv);
+	int (*set_pwr_src)(struct iwl_priv *priv, enum iwl_pwr_src src);
+};
+
+struct iwl_temp_ops {
+	void (*temperature)(struct iwl_priv *priv);
+	void (*set_ct_kill)(struct iwl_priv *priv);
+};
+
 struct iwl_lib_ops {
 	/* set hw dependent parameters */
 	int (*set_hw_params)(struct iwl_priv *priv);
@@ -149,23 +162,20 @@ struct iwl_lib_ops {
 	int (*is_valid_rtc_data_addr)(u32 addr);
 	/* 1st ucode load */
 	int (*load_ucode)(struct iwl_priv *priv);
-	 /* power management */
-	struct {
-		int (*init)(struct iwl_priv *priv);
-		int (*reset)(struct iwl_priv *priv);
-		void (*stop)(struct iwl_priv *priv);
-		void (*config)(struct iwl_priv *priv);
-		int (*set_pwr_src)(struct iwl_priv *priv, enum iwl_pwr_src src);
-	} apm_ops;
+	/* power management */
+	struct iwl_apm_ops apm_ops;
+
 	/* power */
 	int (*send_tx_power) (struct iwl_priv *priv);
 	void (*update_chain_flags)(struct iwl_priv *priv);
-	void (*temperature) (struct iwl_priv *priv);
 	void (*post_associate) (struct iwl_priv *priv);
 	void (*config_ap) (struct iwl_priv *priv);
 
 	/* eeprom operations (as defined in iwl-eeprom.h) */
 	struct iwl_eeprom_ops eeprom_ops;
+
+	/* temperature */
+	struct iwl_temp_ops temp_ops;
 };
 
 struct iwl_ops {
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index fae8426..73739cf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -582,8 +582,8 @@ void iwl_rx_statistics(struct iwl_priv *priv,
 
 	iwl_leds_background(priv);
 
-	if (priv->cfg->ops->lib->temperature && change)
-		priv->cfg->ops->lib->temperature(priv);
+	if (priv->cfg->ops->lib->temp_ops.temperature && change)
+		priv->cfg->ops->lib->temp_ops.temperature(priv);
 }
 EXPORT_SYMBOL(iwl_rx_statistics);
 
-- 
1.5.6.3

