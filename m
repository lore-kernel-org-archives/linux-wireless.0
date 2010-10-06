Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:22045 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759175Ab0JFPXz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 11:23:55 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 6/6] iwlagn: define 130 series of WiFi/BT combo devices
Date: Wed,  6 Oct 2010 08:23:13 -0700
Message-Id: <1286378593-7509-7-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1286378593-7509-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1286378593-7509-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

add new structures and defines need to identify 130 devices.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |   44 +++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   10 +++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h  |    2 +
 3 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 5866ad8..43ec898 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -53,11 +53,13 @@
 #define IWL6000_UCODE_API_MAX 4
 #define IWL6050_UCODE_API_MAX 5
 #define IWL6000G2_UCODE_API_MAX 5
+#define IWL130_UCODE_API_MAX 5
 
 /* Lowest firmware API version supported */
 #define IWL6000_UCODE_API_MIN 4
 #define IWL6050_UCODE_API_MIN 4
 #define IWL6000G2_UCODE_API_MIN 4
+#define IWL130_UCODE_API_MIN 5
 
 #define IWL6000_FW_PRE "iwlwifi-6000-"
 #define _IWL6000_MODULE_FIRMWARE(api) IWL6000_FW_PRE #api ".ucode"
@@ -75,6 +77,9 @@
 #define _IWL6000G2B_MODULE_FIRMWARE(api) IWL6000G2B_FW_PRE #api ".ucode"
 #define IWL6000G2B_MODULE_FIRMWARE(api) _IWL6000G2B_MODULE_FIRMWARE(api)
 
+#define IWL130_FW_PRE "iwlwifi-130-"
+#define _IWL100_MODULE_FIRMWARE(api) IWL130_FW_PRE #api ".ucode"
+#define IWL100_MODULE_FIRMWARE(api) _IWL130_MODULE_FIRMWARE(api)
 
 static void iwl6000_set_ct_threshold(struct iwl_priv *priv)
 {
@@ -810,6 +815,45 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.need_dc_calib = true,
 };
 
+struct iwl_cfg iwl130_bgn_cfg = {
+	.name = "Intel(R) 130 Series 1x1 BGN",
+	.fw_name_pre = IWL6000G2B_FW_PRE,
+	.ucode_api_max = IWL130_UCODE_API_MAX,
+	.ucode_api_min = IWL130_UCODE_API_MIN,
+	.sku = IWL_SKU_G|IWL_SKU_N,
+	.valid_tx_ant = ANT_A,
+	.valid_rx_ant = ANT_A,
+	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
+	.ops = &iwl6000g2b_ops,
+	.mod_params = &iwlagn_mod_params,
+	.base_params = &iwl6000_base_params,
+	.bt_params = &iwl6000_bt_params,
+	.ht_params = &iwl6000_ht_params,
+	.need_dc_calib = true,
+	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
+	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
+};
+
+struct iwl_cfg iwl130_bg_cfg = {
+	.name = "Intel(R) 130 Series 1x2 BG",
+	.fw_name_pre = IWL6000G2B_FW_PRE,
+	.ucode_api_max = IWL130_UCODE_API_MAX,
+	.ucode_api_min = IWL130_UCODE_API_MIN,
+	.sku = IWL_SKU_G,
+	.valid_tx_ant = ANT_A,
+	.valid_rx_ant = ANT_A,
+	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
+	.ops = &iwl6000g2b_ops,
+	.mod_params = &iwlagn_mod_params,
+	.base_params = &iwl6000_base_params,
+	.bt_params = &iwl6000_bt_params,
+	.need_dc_calib = true,
+	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
+	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
+};
+
 MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL6050_MODULE_FIRMWARE(IWL6050_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL6000G2A_MODULE_FIRMWARE(IWL6000G2_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 080121d..a6dce61 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4822,11 +4822,21 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x0084, 0x1216, iwl1000_bg_cfg)},
 	{IWL_PCI_DEVICE(0x0084, 0x1316, iwl1000_bg_cfg)},
 
+/* 100 Series WiFi */
 	{IWL_PCI_DEVICE(0x08AE, 0x1005, iwl100_bgn_cfg)},
 	{IWL_PCI_DEVICE(0x08AF, 0x1015, iwl100_bgn_cfg)},
 	{IWL_PCI_DEVICE(0x08AE, 0x1025, iwl100_bgn_cfg)},
 	{IWL_PCI_DEVICE(0x08AE, 0x1007, iwl100_bg_cfg)},
 	{IWL_PCI_DEVICE(0x08AE, 0x1017, iwl100_bg_cfg)},
+
+/* 130 Series WiFi */
+	{IWL_PCI_DEVICE(0x0896, 0x5005, iwl130_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0896, 0x5007, iwl130_bg_cfg)},
+	{IWL_PCI_DEVICE(0x0897, 0x5015, iwl130_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0897, 0x5017, iwl130_bg_cfg)},
+	{IWL_PCI_DEVICE(0x0896, 0x5025, iwl130_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0896, 0x5027, iwl130_bg_cfg)},
+
 #endif /* CONFIG_IWL5000 */
 
 	{0}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index d5dc824..eb3812a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -94,6 +94,8 @@ extern struct iwl_cfg iwl1000_bgn_cfg;
 extern struct iwl_cfg iwl1000_bg_cfg;
 extern struct iwl_cfg iwl100_bgn_cfg;
 extern struct iwl_cfg iwl100_bg_cfg;
+extern struct iwl_cfg iwl130_bgn_cfg;
+extern struct iwl_cfg iwl130_bg_cfg;
 
 extern struct iwl_mod_params iwlagn_mod_params;
 extern struct iwl_hcmd_ops iwlagn_hcmd;
-- 
1.7.0.4

