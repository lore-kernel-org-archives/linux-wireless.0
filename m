Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:36539 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754120AbZKTUFJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 15:05:09 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 12/19] iwlwifi: update supported PCI_ID list for 5xx0 series
Date: Fri, 20 Nov 2009 12:05:03 -0800
Message-Id: <1258747510-21233-13-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1258747510-21233-1-git-send-email-reinette.chatre@intel.com>
References: <1258747510-21233-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Update the PCI_ID list for 5xx0 series.
Remove all the PCI_IDs which never made into production or not longer in
production.

Also make sure the supported bands(a/b/g/n) match specified PCI_IDs

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |   29 ++++++++++--
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   74 ++++++++++++++++++++++++-------
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    3 +-
 3 files changed, 84 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index bbde208..e2f8615 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1601,12 +1601,12 @@ struct iwl_cfg iwl5300_agn_cfg = {
 	.sm_ps_mode = WLAN_HT_CAP_SM_PS_DISABLED,
 };
 
-struct iwl_cfg iwl5100_bg_cfg = {
-	.name = "5100BG",
+struct iwl_cfg iwl5100_bgn_cfg = {
+	.name = "5100BGN",
 	.fw_name_pre = IWL5000_FW_PRE,
 	.ucode_api_max = IWL5000_UCODE_API_MAX,
 	.ucode_api_min = IWL5000_UCODE_API_MIN,
-	.sku = IWL_SKU_G,
+	.sku = IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl5000_ops,
 	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
@@ -1642,7 +1642,6 @@ struct iwl_cfg iwl5100_abg_cfg = {
 	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
 	.set_l0s = true,
 	.use_bsm = false,
-	.ht_greenfield_support = true,
 	.led_compensation = 51,
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 };
@@ -1719,6 +1718,28 @@ struct iwl_cfg iwl5150_agn_cfg = {
 	.sm_ps_mode = WLAN_HT_CAP_SM_PS_DISABLED,
 };
 
+struct iwl_cfg iwl5150_abg_cfg = {
+	.name = "5150ABG",
+	.fw_name_pre = IWL5150_FW_PRE,
+	.ucode_api_max = IWL5150_UCODE_API_MAX,
+	.ucode_api_min = IWL5150_UCODE_API_MIN,
+	.sku = IWL_SKU_A|IWL_SKU_G,
+	.ops = &iwl5150_ops,
+	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
+	.eeprom_ver = EEPROM_5050_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_5050_TX_POWER_VERSION,
+	.num_of_queues = IWL50_NUM_QUEUES,
+	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
+	.mod_params = &iwl50_mod_params,
+	.valid_tx_ant = ANT_A,
+	.valid_rx_ant = ANT_AB,
+	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
+	.set_l0s = true,
+	.use_bsm = false,
+	.led_compensation = 51,
+	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
+};
+
 MODULE_FIRMWARE(IWL5000_MODULE_FIRMWARE(IWL5000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL5150_MODULE_FIRMWARE(IWL5150_UCODE_API_MAX));
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 8a39e0f..75f911b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3542,23 +3542,63 @@ static struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x4230, PCI_ANY_ID, iwl4965_agn_cfg)},
 #endif /* CONFIG_IWL4965 */
 #ifdef CONFIG_IWL5000
-	{IWL_PCI_DEVICE(0x4232, 0x1205, iwl5100_bg_cfg)},
-	{IWL_PCI_DEVICE(0x4232, 0x1305, iwl5100_bg_cfg)},
-	{IWL_PCI_DEVICE(0x4232, 0x1206, iwl5100_abg_cfg)},
-	{IWL_PCI_DEVICE(0x4232, 0x1306, iwl5100_abg_cfg)},
-	{IWL_PCI_DEVICE(0x4232, 0x1326, iwl5100_abg_cfg)},
-	{IWL_PCI_DEVICE(0x4237, 0x1216, iwl5100_abg_cfg)},
-	{IWL_PCI_DEVICE(0x4232, PCI_ANY_ID, iwl5100_agn_cfg)},
-	{IWL_PCI_DEVICE(0x4235, PCI_ANY_ID, iwl5300_agn_cfg)},
-	{IWL_PCI_DEVICE(0x4236, PCI_ANY_ID, iwl5300_agn_cfg)},
-	{IWL_PCI_DEVICE(0x4237, PCI_ANY_ID, iwl5100_agn_cfg)},
-/* 5350 WiFi/WiMax */
-	{IWL_PCI_DEVICE(0x423A, 0x1001, iwl5350_agn_cfg)},
-	{IWL_PCI_DEVICE(0x423A, 0x1021, iwl5350_agn_cfg)},
-	{IWL_PCI_DEVICE(0x423B, 0x1011, iwl5350_agn_cfg)},
-/* 5150 Wifi/WiMax */
-	{IWL_PCI_DEVICE(0x423C, PCI_ANY_ID, iwl5150_agn_cfg)},
-	{IWL_PCI_DEVICE(0x423D, PCI_ANY_ID, iwl5150_agn_cfg)},
+/* 5100 Series WiFi */
+	{IWL_PCI_DEVICE(0x4232, 0x1201, iwl5100_agn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x4232, 0x1301, iwl5100_agn_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x4232, 0x1204, iwl5100_agn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x4232, 0x1304, iwl5100_agn_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x4232, 0x1205, iwl5100_bgn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x4232, 0x1305, iwl5100_bgn_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x4232, 0x1206, iwl5100_abg_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x4232, 0x1306, iwl5100_abg_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x4232, 0x1221, iwl5100_agn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x4232, 0x1321, iwl5100_agn_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x4232, 0x1224, iwl5100_agn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x4232, 0x1324, iwl5100_agn_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x4232, 0x1225, iwl5100_bgn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x4232, 0x1325, iwl5100_bgn_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x4232, 0x1226, iwl5100_abg_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x4232, 0x1326, iwl5100_abg_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x4237, 0x1211, iwl5100_agn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x4237, 0x1311, iwl5100_agn_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x4237, 0x1214, iwl5100_agn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x4237, 0x1314, iwl5100_agn_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x4237, 0x1215, iwl5100_bgn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x4237, 0x1315, iwl5100_bgn_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x4237, 0x1216, iwl5100_abg_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x4237, 0x1316, iwl5100_abg_cfg)}, /* Half Mini Card */
+
+/* 5300 Series WiFi */
+	{IWL_PCI_DEVICE(0x4235, 0x1021, iwl5300_agn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x4235, 0x1121, iwl5300_agn_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x4235, 0x1024, iwl5300_agn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x4235, 0x1124, iwl5300_agn_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x4235, 0x1001, iwl5300_agn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x4235, 0x1101, iwl5300_agn_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x4235, 0x1004, iwl5300_agn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x4235, 0x1104, iwl5300_agn_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x4236, 0x1011, iwl5300_agn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x4236, 0x1111, iwl5300_agn_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x4236, 0x1014, iwl5300_agn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x4236, 0x1114, iwl5300_agn_cfg)}, /* Half Mini Card */
+
+/* 5350 Series WiFi/WiMax */
+	{IWL_PCI_DEVICE(0x423A, 0x1001, iwl5350_agn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x423A, 0x1021, iwl5350_agn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x423B, 0x1011, iwl5350_agn_cfg)}, /* Mini Card */
+
+/* 5150 Series Wifi/WiMax */
+	{IWL_PCI_DEVICE(0x423C, 0x1201, iwl5150_agn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x423C, 0x1301, iwl5150_agn_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x423C, 0x1206, iwl5150_abg_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x423C, 0x1306, iwl5150_abg_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x423C, 0x1221, iwl5150_agn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x423C, 0x1321, iwl5150_agn_cfg)}, /* Half Mini Card */
+
+	{IWL_PCI_DEVICE(0x423D, 0x1211, iwl5150_agn_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x423D, 0x1311, iwl5150_agn_cfg)}, /* Half Mini Card */
+	{IWL_PCI_DEVICE(0x423D, 0x1216, iwl5150_abg_cfg)}, /* Mini Card */
+	{IWL_PCI_DEVICE(0x423D, 0x1316, iwl5150_abg_cfg)}, /* Half Mini Card */
 
 /* 6x00 Series */
 	{IWL_PCI_DEVICE(0x422B, 0x1101, iwl6000_3agn_cfg)},
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 4ded190..2673e9a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -52,9 +52,10 @@ extern struct iwl_cfg iwl4965_agn_cfg;
 extern struct iwl_cfg iwl5300_agn_cfg;
 extern struct iwl_cfg iwl5100_agn_cfg;
 extern struct iwl_cfg iwl5350_agn_cfg;
-extern struct iwl_cfg iwl5100_bg_cfg;
+extern struct iwl_cfg iwl5100_bgn_cfg;
 extern struct iwl_cfg iwl5100_abg_cfg;
 extern struct iwl_cfg iwl5150_agn_cfg;
+extern struct iwl_cfg iwl5150_abg_cfg;
 extern struct iwl_cfg iwl6000i_2agn_cfg;
 extern struct iwl_cfg iwl6000i_2abg_cfg;
 extern struct iwl_cfg iwl6000i_2bg_cfg;
-- 
1.5.6.3

