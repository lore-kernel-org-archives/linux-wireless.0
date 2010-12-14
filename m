Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:43486 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758409Ab0LNARM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 19:17:12 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 14/14] iwlagn: code clean up to remove duplicate code
Date: Mon, 13 Dec 2010 16:09:32 -0800
Message-Id: <1292285372-11373-15-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1292285372-11373-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1292285372-11373-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Multiple devices use almost the same .cfg with minor differences.
Use macro and remove the duplication. By doing this, reduce
the chance for mistake while modify .cfg parameters

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |   65 +++----
 drivers/net/wireless/iwlwifi/iwl-5000.c |   89 +++------
 drivers/net/wireless/iwlwifi/iwl-6000.c |  319 +++++++++----------------------
 3 files changed, 151 insertions(+), 322 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 94521d4..ba78bc8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -276,60 +276,49 @@ static struct iwl_ht_params iwl1000_ht_params = {
 	.use_rts_for_aggregation = true, /* use rts/cts protection */
 };
 
+#define IWL_DEVICE_1000						\
+	.fw_name_pre = IWL1000_FW_PRE,				\
+	.ucode_api_max = IWL1000_UCODE_API_MAX,			\
+	.ucode_api_min = IWL1000_UCODE_API_MIN,			\
+	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,		\
+	.eeprom_calib_ver = EEPROM_1000_TX_POWER_VERSION,	\
+	.ops = &iwl1000_ops,					\
+	.mod_params = &iwlagn_mod_params,			\
+	.base_params = &iwl1000_base_params,			\
+	.led_mode = IWL_LED_BLINK
+
 struct iwl_cfg iwl1000_bgn_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N 1000 BGN",
-	.fw_name_pre = IWL1000_FW_PRE,
-	.ucode_api_max = IWL1000_UCODE_API_MAX,
-	.ucode_api_min = IWL1000_UCODE_API_MIN,
-	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_1000_TX_POWER_VERSION,
-	.ops = &iwl1000_ops,
-	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl1000_base_params,
+	IWL_DEVICE_1000,
 	.ht_params = &iwl1000_ht_params,
-	.led_mode = IWL_LED_BLINK,
 };
 
 struct iwl_cfg iwl1000_bg_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N 1000 BG",
-	.fw_name_pre = IWL1000_FW_PRE,
-	.ucode_api_max = IWL1000_UCODE_API_MAX,
-	.ucode_api_min = IWL1000_UCODE_API_MIN,
-	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_1000_TX_POWER_VERSION,
-	.ops = &iwl1000_ops,
-	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl1000_base_params,
-	.led_mode = IWL_LED_BLINK,
+	IWL_DEVICE_1000,
 };
 
+#define IWL_DEVICE_100						\
+	.fw_name_pre = IWL100_FW_PRE,				\
+	.ucode_api_max = IWL100_UCODE_API_MAX,			\
+	.ucode_api_min = IWL100_UCODE_API_MIN,			\
+	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,		\
+	.eeprom_calib_ver = EEPROM_1000_TX_POWER_VERSION,	\
+	.ops = &iwl1000_ops,					\
+	.mod_params = &iwlagn_mod_params,			\
+	.base_params = &iwl1000_base_params,			\
+	.led_mode = IWL_LED_RF_STATE,				\
+	.rx_with_siso_diversity = true
+
 struct iwl_cfg iwl100_bgn_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N 100 BGN",
-	.fw_name_pre = IWL100_FW_PRE,
-	.ucode_api_max = IWL100_UCODE_API_MAX,
-	.ucode_api_min = IWL100_UCODE_API_MIN,
-	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_1000_TX_POWER_VERSION,
-	.ops = &iwl1000_ops,
-	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl1000_base_params,
+	IWL_DEVICE_100,
 	.ht_params = &iwl1000_ht_params,
-	.led_mode = IWL_LED_RF_STATE,
-	.rx_with_siso_diversity = true,
 };
 
 struct iwl_cfg iwl100_bg_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N 100 BG",
-	.fw_name_pre = IWL100_FW_PRE,
-	.ucode_api_max = IWL100_UCODE_API_MAX,
-	.ucode_api_min = IWL100_UCODE_API_MIN,
-	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_1000_TX_POWER_VERSION,
-	.ops = &iwl1000_ops,
-	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl1000_base_params,
-	.led_mode = IWL_LED_RF_STATE,
-	.rx_with_siso_diversity = true,
+	IWL_DEVICE_100,
 };
 
 MODULE_FIRMWARE(IWL1000_MODULE_FIRMWARE(IWL1000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 34af9e0..79ab0a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -520,65 +520,44 @@ static struct iwl_ht_params iwl5000_ht_params = {
 	.use_rts_for_aggregation = true, /* use rts/cts protection */
 };
 
+#define IWL_DEVICE_5000						\
+	.fw_name_pre = IWL5000_FW_PRE,				\
+	.ucode_api_max = IWL5000_UCODE_API_MAX,			\
+	.ucode_api_min = IWL5000_UCODE_API_MIN,			\
+	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,		\
+	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,	\
+	.ops = &iwl5000_ops,					\
+	.mod_params = &iwlagn_mod_params,			\
+	.base_params = &iwl5000_base_params,			\
+	.led_mode = IWL_LED_BLINK
+
 struct iwl_cfg iwl5300_agn_cfg = {
 	.name = "Intel(R) Ultimate N WiFi Link 5300 AGN",
-	.fw_name_pre = IWL5000_FW_PRE,
-	.ucode_api_max = IWL5000_UCODE_API_MAX,
-	.ucode_api_min = IWL5000_UCODE_API_MIN,
-	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
-	.ops = &iwl5000_ops,
-	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl5000_base_params,
+	IWL_DEVICE_5000,
 	.ht_params = &iwl5000_ht_params,
-	.led_mode = IWL_LED_BLINK,
 };
 
 struct iwl_cfg iwl5100_bgn_cfg = {
 	.name = "Intel(R) WiFi Link 5100 BGN",
-	.fw_name_pre = IWL5000_FW_PRE,
-	.ucode_api_max = IWL5000_UCODE_API_MAX,
-	.ucode_api_min = IWL5000_UCODE_API_MIN,
+	IWL_DEVICE_5000,
 	.valid_tx_ant = ANT_B,		/* .cfg overwrite */
 	.valid_rx_ant = ANT_AB,		/* .cfg overwrite */
-	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
-	.ops = &iwl5000_ops,
-	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl5000_base_params,
 	.ht_params = &iwl5000_ht_params,
-	.led_mode = IWL_LED_BLINK,
 };
 
 struct iwl_cfg iwl5100_abg_cfg = {
 	.name = "Intel(R) WiFi Link 5100 ABG",
-	.fw_name_pre = IWL5000_FW_PRE,
-	.ucode_api_max = IWL5000_UCODE_API_MAX,
-	.ucode_api_min = IWL5000_UCODE_API_MIN,
+	IWL_DEVICE_5000,
 	.valid_tx_ant = ANT_B,		/* .cfg overwrite */
 	.valid_rx_ant = ANT_AB,		/* .cfg overwrite */
-	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
-	.ops = &iwl5000_ops,
-	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl5000_base_params,
-	.led_mode = IWL_LED_BLINK,
 };
 
 struct iwl_cfg iwl5100_agn_cfg = {
 	.name = "Intel(R) WiFi Link 5100 AGN",
-	.fw_name_pre = IWL5000_FW_PRE,
-	.ucode_api_max = IWL5000_UCODE_API_MAX,
-	.ucode_api_min = IWL5000_UCODE_API_MIN,
+	IWL_DEVICE_5000,
 	.valid_tx_ant = ANT_B,		/* .cfg overwrite */
 	.valid_rx_ant = ANT_AB,		/* .cfg overwrite */
-	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
-	.ops = &iwl5000_ops,
-	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl5000_base_params,
 	.ht_params = &iwl5000_ht_params,
-	.led_mode = IWL_LED_BLINK,
 };
 
 struct iwl_cfg iwl5350_agn_cfg = {
@@ -596,35 +575,29 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.internal_wimax_coex = true,
 };
 
+#define IWL_DEVICE_5150						\
+	.fw_name_pre = IWL5150_FW_PRE,				\
+	.ucode_api_max = IWL5150_UCODE_API_MAX,			\
+	.ucode_api_min = IWL5150_UCODE_API_MIN,			\
+	.eeprom_ver = EEPROM_5050_EEPROM_VERSION,		\
+	.eeprom_calib_ver = EEPROM_5050_TX_POWER_VERSION,	\
+	.ops = &iwl5150_ops,					\
+	.mod_params = &iwlagn_mod_params,			\
+	.base_params = &iwl5000_base_params,			\
+	.need_dc_calib = true,					\
+	.led_mode = IWL_LED_BLINK,				\
+	.internal_wimax_coex = true
+
 struct iwl_cfg iwl5150_agn_cfg = {
 	.name = "Intel(R) WiMAX/WiFi Link 5150 AGN",
-	.fw_name_pre = IWL5150_FW_PRE,
-	.ucode_api_max = IWL5150_UCODE_API_MAX,
-	.ucode_api_min = IWL5150_UCODE_API_MIN,
-	.eeprom_ver = EEPROM_5050_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_5050_TX_POWER_VERSION,
-	.ops = &iwl5150_ops,
-	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl5000_base_params,
+	IWL_DEVICE_5150,
 	.ht_params = &iwl5000_ht_params,
-	.need_dc_calib = true,
-	.led_mode = IWL_LED_BLINK,
-	.internal_wimax_coex = true,
+
 };
 
 struct iwl_cfg iwl5150_abg_cfg = {
 	.name = "Intel(R) WiMAX/WiFi Link 5150 ABG",
-	.fw_name_pre = IWL5150_FW_PRE,
-	.ucode_api_max = IWL5150_UCODE_API_MAX,
-	.ucode_api_min = IWL5150_UCODE_API_MIN,
-	.eeprom_ver = EEPROM_5050_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_5050_TX_POWER_VERSION,
-	.ops = &iwl5150_ops,
-	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl5000_base_params,
-	.need_dc_calib = true,
-	.led_mode = IWL_LED_BLINK,
-	.internal_wimax_coex = true,
+	IWL_DEVICE_5150,
 };
 
 MODULE_FIRMWARE(IWL5000_MODULE_FIRMWARE(IWL5000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index fe5f6d0..f4bec32 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -554,235 +554,156 @@ static struct iwl_bt_params iwl6000_bt_params = {
 	.bt_sco_disable = true,
 };
 
+#define IWL_DEVICE_6005						\
+	.fw_name_pre = IWL6000G2A_FW_PRE,			\
+	.ucode_api_max = IWL6000G2_UCODE_API_MAX,		\
+	.ucode_api_min = IWL6000G2_UCODE_API_MIN,		\
+	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,		\
+	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,	\
+	.ops = &iwl6000_ops,					\
+	.mod_params = &iwlagn_mod_params,			\
+	.base_params = &iwl6000_g2_base_params,			\
+	.need_dc_calib = true,					\
+	.need_temp_offset_calib = true,				\
+	.led_mode = IWL_LED_RF_STATE
+
 struct iwl_cfg iwl6005_2agn_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6205 AGN",
-	.fw_name_pre = IWL6000G2A_FW_PRE,
-	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
-	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
-	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
-	.ops = &iwl6000_ops,
-	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl6000_g2_base_params,
+	IWL_DEVICE_6005,
 	.ht_params = &iwl6000_ht_params,
-	.need_dc_calib = true,
-	.need_temp_offset_calib = true,
-	.led_mode = IWL_LED_RF_STATE,
 };
 
 struct iwl_cfg iwl6005_2abg_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6205 ABG",
-	.fw_name_pre = IWL6000G2A_FW_PRE,
-	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
-	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
-	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
-	.ops = &iwl6000_ops,
-	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl6000_g2_base_params,
-	.need_dc_calib = true,
-	.need_temp_offset_calib = true,
-	.led_mode = IWL_LED_RF_STATE,
+	IWL_DEVICE_6005,
 };
 
 struct iwl_cfg iwl6005_2bg_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6205 BG",
-	.fw_name_pre = IWL6000G2A_FW_PRE,
-	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
-	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
-	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
-	.ops = &iwl6000_ops,
-	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl6000_g2_base_params,
-	.need_dc_calib = true,
-	.need_temp_offset_calib = true,
-	.led_mode = IWL_LED_RF_STATE,
-};
+	IWL_DEVICE_6005,
+};
+
+#define IWL_DEVICE_6030						\
+	.fw_name_pre = IWL6000G2B_FW_PRE,			\
+	.ucode_api_max = IWL6000G2_UCODE_API_MAX,		\
+	.ucode_api_min = IWL6000G2_UCODE_API_MIN,		\
+	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,		\
+	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,	\
+	.ops = &iwl6000g2b_ops,					\
+	.mod_params = &iwlagn_mod_params,			\
+	.base_params = &iwl6000_g2_base_params,			\
+	.bt_params = &iwl6000_bt_params,			\
+	.need_dc_calib = true,					\
+	.need_temp_offset_calib = true,				\
+	.led_mode = IWL_LED_RF_STATE,				\
+	.adv_pm = true,						\
+	/*							\
+	 *Due to bluetooth, we transmit 2.4 GHz probes		\
+	 * only on antenna A					\
+	 */							\
+	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A
 
 struct iwl_cfg iwl6030_2agn_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6230 AGN",
-	.fw_name_pre = IWL6000G2B_FW_PRE,
-	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
-	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
-	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
-	.ops = &iwl6000g2b_ops,
-	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl6000_g2_base_params,
-	.bt_params = &iwl6000_bt_params,
+	IWL_DEVICE_6030,
 	.ht_params = &iwl6000_ht_params,
-	.need_dc_calib = true,
-	.need_temp_offset_calib = true,
-	.led_mode = IWL_LED_RF_STATE,
-	.adv_pm = true,
-	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
-	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 };
 
 struct iwl_cfg iwl6030_2abg_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6230 ABG",
-	.fw_name_pre = IWL6000G2B_FW_PRE,
-	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
-	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
-	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
-	.ops = &iwl6000g2b_ops,
-	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl6000_g2_base_params,
-	.bt_params = &iwl6000_bt_params,
-	.need_dc_calib = true,
-	.need_temp_offset_calib = true,
-	.led_mode = IWL_LED_RF_STATE,
-	.adv_pm = true,
-	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
-	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
+	IWL_DEVICE_6030,
 };
 
 struct iwl_cfg iwl6030_2bgn_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6230 BGN",
-	.fw_name_pre = IWL6000G2B_FW_PRE,
-	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
-	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
-	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
-	.ops = &iwl6000g2b_ops,
-	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl6000_g2_base_params,
-	.bt_params = &iwl6000_bt_params,
+	IWL_DEVICE_6030,
 	.ht_params = &iwl6000_ht_params,
-	.need_dc_calib = true,
-	.need_temp_offset_calib = true,
-	.led_mode = IWL_LED_RF_STATE,
-	.adv_pm = true,
-	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
-	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 };
 
 struct iwl_cfg iwl6030_2bg_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6230 BG",
-	.fw_name_pre = IWL6000G2B_FW_PRE,
-	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
-	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
-	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
-	.ops = &iwl6000g2b_ops,
-	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl6000_g2_base_params,
-	.bt_params = &iwl6000_bt_params,
-	.need_dc_calib = true,
-	.need_temp_offset_calib = true,
-	.led_mode = IWL_LED_RF_STATE,
-	.adv_pm = true,
-	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
-	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
+	IWL_DEVICE_6030,
 };
 
 struct iwl_cfg iwl1030_bgn_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N 1030 BGN",
-	.fw_name_pre = IWL6000G2B_FW_PRE,
-	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
-	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
-	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
-	.ops = &iwl6000g2b_ops,
-	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl6000_g2_base_params,
-	.bt_params = &iwl6000_bt_params,
+	IWL_DEVICE_6030,
 	.ht_params = &iwl6000_ht_params,
-	.need_dc_calib = true,
-	.need_temp_offset_calib = true,
-	.led_mode = IWL_LED_RF_STATE,
-	.adv_pm = true,
-	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
-	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 };
 
 struct iwl_cfg iwl1030_bg_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N 1030 BG",
-	.fw_name_pre = IWL6000G2B_FW_PRE,
-	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
-	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
-	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
-	.ops = &iwl6000g2b_ops,
-	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl6000_g2_base_params,
-	.bt_params = &iwl6000_bt_params,
-	.need_dc_calib = true,
-	.need_temp_offset_calib = true,
-	.led_mode = IWL_LED_RF_STATE,
-	.adv_pm = true,
-	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
-	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
+	IWL_DEVICE_6030,
+};
+
+struct iwl_cfg iwl130_bgn_cfg = {
+	.name = "Intel(R) Centrino(R) Wireless-N 130 BGN",
+	IWL_DEVICE_6030,
+	.ht_params = &iwl6000_ht_params,
+	.rx_with_siso_diversity = true,
+};
+
+struct iwl_cfg iwl130_bg_cfg = {
+	.name = "Intel(R) Centrino(R) Wireless-N 130 BG",
+	IWL_DEVICE_6030,
+	.rx_with_siso_diversity = true,
 };
 
 /*
  * "i": Internal configuration, use internal Power Amplifier
  */
+#define IWL_DEVICE_6000i					\
+	.fw_name_pre = IWL6000_FW_PRE,				\
+	.ucode_api_max = IWL6000_UCODE_API_MAX,			\
+	.ucode_api_min = IWL6000_UCODE_API_MIN,			\
+	.valid_tx_ant = ANT_BC,		/* .cfg overwrite */	\
+	.valid_rx_ant = ANT_BC,		/* .cfg overwrite */	\
+	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,		\
+	.eeprom_calib_ver = EEPROM_6000_TX_POWER_VERSION,	\
+	.ops = &iwl6000_ops,					\
+	.mod_params = &iwlagn_mod_params,			\
+	.base_params = &iwl6000_base_params,			\
+	.pa_type = IWL_PA_INTERNAL,				\
+	.led_mode = IWL_LED_BLINK
+
 struct iwl_cfg iwl6000i_2agn_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6200 AGN",
-	.fw_name_pre = IWL6000_FW_PRE,
-	.ucode_api_max = IWL6000_UCODE_API_MAX,
-	.ucode_api_min = IWL6000_UCODE_API_MIN,
-	.valid_tx_ant = ANT_BC,		/* .cfg overwrite */
-	.valid_rx_ant = ANT_BC,		/* .cfg overwrite */
-	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_6000_TX_POWER_VERSION,
-	.ops = &iwl6000_ops,
-	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl6000_base_params,
+	IWL_DEVICE_6000i,
 	.ht_params = &iwl6000_ht_params,
-	.pa_type = IWL_PA_INTERNAL,
-	.led_mode = IWL_LED_BLINK,
 };
 
 struct iwl_cfg iwl6000i_2abg_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6200 ABG",
-	.fw_name_pre = IWL6000_FW_PRE,
-	.ucode_api_max = IWL6000_UCODE_API_MAX,
-	.ucode_api_min = IWL6000_UCODE_API_MIN,
-	.valid_tx_ant = ANT_BC,		/* .cfg overwrite */
-	.valid_rx_ant = ANT_BC,		/* .cfg overwrite */
-	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_6000_TX_POWER_VERSION,
-	.ops = &iwl6000_ops,
-	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl6000_base_params,
-	.pa_type = IWL_PA_INTERNAL,
-	.led_mode = IWL_LED_BLINK,
+	IWL_DEVICE_6000i,
 };
 
 struct iwl_cfg iwl6000i_2bg_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6200 BG",
-	.fw_name_pre = IWL6000_FW_PRE,
-	.ucode_api_max = IWL6000_UCODE_API_MAX,
-	.ucode_api_min = IWL6000_UCODE_API_MIN,
-	.valid_tx_ant = ANT_BC,		/* .cfg overwrite */
-	.valid_rx_ant = ANT_BC,		/* .cfg overwrite */
-	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_6000_TX_POWER_VERSION,
-	.ops = &iwl6000_ops,
-	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl6000_base_params,
-	.pa_type = IWL_PA_INTERNAL,
-	.led_mode = IWL_LED_BLINK,
-};
+	IWL_DEVICE_6000i,
+};
+
+#define IWL_DEVICE_6050						\
+	.fw_name_pre = IWL6050_FW_PRE,				\
+	.ucode_api_max = IWL6050_UCODE_API_MAX,			\
+	.ucode_api_min = IWL6050_UCODE_API_MIN,			\
+	.ops = &iwl6050_ops,					\
+	.eeprom_ver = EEPROM_6050_EEPROM_VERSION,		\
+	.eeprom_calib_ver = EEPROM_6050_TX_POWER_VERSION,	\
+	.mod_params = &iwlagn_mod_params,			\
+	.base_params = &iwl6050_base_params,			\
+	.need_dc_calib = true,					\
+	.led_mode = IWL_LED_BLINK,				\
+	.internal_wimax_coex = true
 
 struct iwl_cfg iwl6050_2agn_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N + WiMAX 6250 AGN",
-	.fw_name_pre = IWL6050_FW_PRE,
-	.ucode_api_max = IWL6050_UCODE_API_MAX,
-	.ucode_api_min = IWL6050_UCODE_API_MIN,
-	.ops = &iwl6050_ops,
-	.eeprom_ver = EEPROM_6050_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_6050_TX_POWER_VERSION,
-	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl6050_base_params,
+	IWL_DEVICE_6050,
 	.ht_params = &iwl6000_ht_params,
-	.need_dc_calib = true,
-	.led_mode = IWL_LED_BLINK,
-	.internal_wimax_coex = true,
+};
+
+struct iwl_cfg iwl6050_2abg_cfg = {
+	.name = "Intel(R) Centrino(R) Advanced-N + WiMAX 6250 ABG",
+	IWL_DEVICE_6050,
 };
 
 struct iwl_cfg iwl6150_bgn_cfg = {
@@ -801,21 +722,6 @@ struct iwl_cfg iwl6150_bgn_cfg = {
 	.internal_wimax_coex = true,
 };
 
-struct iwl_cfg iwl6050_2abg_cfg = {
-	.name = "Intel(R) Centrino(R) Advanced-N + WiMAX 6250 ABG",
-	.fw_name_pre = IWL6050_FW_PRE,
-	.ucode_api_max = IWL6050_UCODE_API_MAX,
-	.ucode_api_min = IWL6050_UCODE_API_MIN,
-	.eeprom_ver = EEPROM_6050_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_6050_TX_POWER_VERSION,
-	.ops = &iwl6050_ops,
-	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl6050_base_params,
-	.need_dc_calib = true,
-	.led_mode = IWL_LED_BLINK,
-	.internal_wimax_coex = true,
-};
-
 struct iwl_cfg iwl6000_3agn_cfg = {
 	.name = "Intel(R) Centrino(R) Ultimate-N 6300 AGN",
 	.fw_name_pre = IWL6000_FW_PRE,
@@ -831,45 +737,6 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.led_mode = IWL_LED_BLINK,
 };
 
-struct iwl_cfg iwl130_bgn_cfg = {
-	.name = "Intel(R) Centrino(R) Wireless-N 130 BGN",
-	.fw_name_pre = IWL6000G2B_FW_PRE,
-	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
-	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
-	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
-	.ops = &iwl6000g2b_ops,
-	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl6000_g2_base_params,
-	.bt_params = &iwl6000_bt_params,
-	.ht_params = &iwl6000_ht_params,
-	.need_dc_calib = true,
-	.led_mode = IWL_LED_RF_STATE,
-	.adv_pm = true,
-	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
-	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
-	.rx_with_siso_diversity = true,
-};
-
-struct iwl_cfg iwl130_bg_cfg = {
-	.name = "Intel(R) Centrino(R) Wireless-N 130 BG",
-	.fw_name_pre = IWL6000G2B_FW_PRE,
-	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
-	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
-	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
-	.ops = &iwl6000g2b_ops,
-	.mod_params = &iwlagn_mod_params,
-	.base_params = &iwl6000_g2_base_params,
-	.bt_params = &iwl6000_bt_params,
-	.need_dc_calib = true,
-	.led_mode = IWL_LED_RF_STATE,
-	.adv_pm = true,
-	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
-	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
-	.rx_with_siso_diversity = true,
-};
-
 MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL6050_MODULE_FIRMWARE(IWL6050_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL6000G2A_MODULE_FIRMWARE(IWL6000G2_UCODE_API_MAX));
-- 
1.7.0.4

