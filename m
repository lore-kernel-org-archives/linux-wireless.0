Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:5408 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755181AbZIQRn4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2009 13:43:56 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/13] iwlwifi: update PCI Subsystem ID for 6000 series
Date: Thu, 17 Sep 2009 10:43:53 -0700
Message-Id: <1253209436-2309-11-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1253209436-2309-1-git-send-email-reinette.chatre@intel.com>
References: <1253209436-2309-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Update PCI Subsystem ID for 60x0 series based on HW SKU. Adding new SKU
for "ABG" and "BG" only devices.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |  105 +++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   43 +++++++++---
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    5 ++
 3 files changed, 142 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 92faac0..73ca012 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -260,6 +260,48 @@ struct iwl_cfg iwl6000h_2agn_cfg = {
 	.use_rts_for_ht = true, /* use rts/cts protection */
 };
 
+struct iwl_cfg iwl6000h_2abg_cfg = {
+	.name = "6000 Series 2x2 ABG",
+	.fw_name_pre = IWL6000_FW_PRE,
+	.ucode_api_max = IWL6000_UCODE_API_MAX,
+	.ucode_api_min = IWL6000_UCODE_API_MIN,
+	.sku = IWL_SKU_A|IWL_SKU_G,
+	.ops = &iwl6000_ops,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
+	.mod_params = &iwl50_mod_params,
+	.valid_tx_ant = ANT_AB,
+	.valid_rx_ant = ANT_AB,
+	.need_pll_cfg = false,
+	.pa_type = IWL_PA_HYBRID,
+	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
+	.shadow_ram_support = true,
+	.ht_greenfield_support = true,
+	.led_compensation = 51,
+};
+
+struct iwl_cfg iwl6000h_2bg_cfg = {
+	.name = "6000 Series 2x2 BG",
+	.fw_name_pre = IWL6000_FW_PRE,
+	.ucode_api_max = IWL6000_UCODE_API_MAX,
+	.ucode_api_min = IWL6000_UCODE_API_MIN,
+	.sku = IWL_SKU_G,
+	.ops = &iwl6000_ops,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
+	.mod_params = &iwl50_mod_params,
+	.valid_tx_ant = ANT_AB,
+	.valid_rx_ant = ANT_AB,
+	.need_pll_cfg = false,
+	.pa_type = IWL_PA_HYBRID,
+	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
+	.shadow_ram_support = true,
+	.ht_greenfield_support = true,
+	.led_compensation = 51,
+};
+
 /*
  * "i": Internal configuration, use internal Power Amplifier
  */
@@ -285,6 +327,48 @@ struct iwl_cfg iwl6000i_2agn_cfg = {
 	.use_rts_for_ht = true, /* use rts/cts protection */
 };
 
+struct iwl_cfg iwl6000i_2abg_cfg = {
+	.name = "6000 Series 2x2 ABG",
+	.fw_name_pre = IWL6000_FW_PRE,
+	.ucode_api_max = IWL6000_UCODE_API_MAX,
+	.ucode_api_min = IWL6000_UCODE_API_MIN,
+	.sku = IWL_SKU_A|IWL_SKU_G,
+	.ops = &iwl6000_ops,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
+	.mod_params = &iwl50_mod_params,
+	.valid_tx_ant = ANT_BC,
+	.valid_rx_ant = ANT_BC,
+	.need_pll_cfg = false,
+	.pa_type = IWL_PA_INTERNAL,
+	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
+	.shadow_ram_support = true,
+	.ht_greenfield_support = true,
+	.led_compensation = 51,
+};
+
+struct iwl_cfg iwl6000i_2bg_cfg = {
+	.name = "6000 Series 2x2 BG",
+	.fw_name_pre = IWL6000_FW_PRE,
+	.ucode_api_max = IWL6000_UCODE_API_MAX,
+	.ucode_api_min = IWL6000_UCODE_API_MIN,
+	.sku = IWL_SKU_G,
+	.ops = &iwl6000_ops,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
+	.mod_params = &iwl50_mod_params,
+	.valid_tx_ant = ANT_BC,
+	.valid_rx_ant = ANT_BC,
+	.need_pll_cfg = false,
+	.pa_type = IWL_PA_INTERNAL,
+	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
+	.shadow_ram_support = true,
+	.ht_greenfield_support = true,
+	.led_compensation = 51,
+};
+
 struct iwl_cfg iwl6050_2agn_cfg = {
 	.name = "6050 Series 2x2 AGN",
 	.fw_name_pre = IWL6050_FW_PRE,
@@ -307,6 +391,27 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.use_rts_for_ht = true, /* use rts/cts protection */
 };
 
+struct iwl_cfg iwl6050_2abg_cfg = {
+	.name = "6050 Series 2x2 ABG",
+	.fw_name_pre = IWL6050_FW_PRE,
+	.ucode_api_max = IWL6050_UCODE_API_MAX,
+	.ucode_api_min = IWL6050_UCODE_API_MIN,
+	.sku = IWL_SKU_A|IWL_SKU_G,
+	.ops = &iwl6000_ops,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
+	.mod_params = &iwl50_mod_params,
+	.valid_tx_ant = ANT_AB,
+	.valid_rx_ant = ANT_AB,
+	.need_pll_cfg = false,
+	.pa_type = IWL_PA_SYSTEM,
+	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
+	.shadow_ram_support = true,
+	.ht_greenfield_support = true,
+	.led_compensation = 51,
+};
+
 struct iwl_cfg iwl6000_3agn_cfg = {
 	.name = "6000 Series 3x3 AGN",
 	.fw_name_pre = IWL6000_FW_PRE,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index b29e44f..d39467f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3073,17 +3073,38 @@ static struct pci_device_id iwl_hw_card_ids[] = {
 /* 5150 Wifi/WiMax */
 	{IWL_PCI_DEVICE(0x423C, PCI_ANY_ID, iwl5150_agn_cfg)},
 	{IWL_PCI_DEVICE(0x423D, PCI_ANY_ID, iwl5150_agn_cfg)},
-/* 6000/6050 Series */
-	{IWL_PCI_DEVICE(0x008D, PCI_ANY_ID, iwl6000h_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x008E, PCI_ANY_ID, iwl6000h_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x422B, PCI_ANY_ID, iwl6000_3agn_cfg)},
-	{IWL_PCI_DEVICE(0x422C, PCI_ANY_ID, iwl6000i_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x4238, PCI_ANY_ID, iwl6000_3agn_cfg)},
-	{IWL_PCI_DEVICE(0x4239, PCI_ANY_ID, iwl6000i_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x0086, PCI_ANY_ID, iwl6050_3agn_cfg)},
-	{IWL_PCI_DEVICE(0x0087, PCI_ANY_ID, iwl6050_2agn_cfg)},
-	{IWL_PCI_DEVICE(0x0088, PCI_ANY_ID, iwl6050_3agn_cfg)},
-	{IWL_PCI_DEVICE(0x0089, PCI_ANY_ID, iwl6050_2agn_cfg)},
+
+/* 6x00 Series */
+	{IWL_PCI_DEVICE(0x008D, 0x1301, iwl6000h_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x008D, 0x1321, iwl6000h_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x008D, 0x1326, iwl6000h_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x008D, 0x1306, iwl6000h_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x008D, 0x1307, iwl6000h_2bg_cfg)},
+	{IWL_PCI_DEVICE(0x008E, 0x1311, iwl6000h_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x008E, 0x1316, iwl6000h_2abg_cfg)},
+
+	{IWL_PCI_DEVICE(0x422B, 0x1101, iwl6000_3agn_cfg)},
+	{IWL_PCI_DEVICE(0x422B, 0x1121, iwl6000_3agn_cfg)},
+	{IWL_PCI_DEVICE(0x422C, 0x1301, iwl6000i_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x422C, 0x1306, iwl6000i_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x422C, 0x1307, iwl6000i_2bg_cfg)},
+	{IWL_PCI_DEVICE(0x422C, 0x1321, iwl6000i_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x422C, 0x1326, iwl6000i_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x4238, 0x1111, iwl6000_3agn_cfg)},
+	{IWL_PCI_DEVICE(0x4239, 0x1311, iwl6000i_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x4239, 0x1316, iwl6000i_2abg_cfg)},
+
+/* 6x50 WiFi/WiMax Series */
+	{IWL_PCI_DEVICE(0x0086, 0x1101, iwl6050_3agn_cfg)},
+	{IWL_PCI_DEVICE(0x0086, 0x1121, iwl6050_3agn_cfg)},
+	{IWL_PCI_DEVICE(0x0087, 0x1301, iwl6050_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x0087, 0x1306, iwl6050_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x0087, 0x1321, iwl6050_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x0087, 0x1326, iwl6050_2abg_cfg)},
+	{IWL_PCI_DEVICE(0x0088, 0x1111, iwl6050_3agn_cfg)},
+	{IWL_PCI_DEVICE(0x0089, 0x1311, iwl6050_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x0089, 0x1316, iwl6050_2abg_cfg)},
+
 /* 1000 Series WiFi */
 	{IWL_PCI_DEVICE(0x0083, 0x1205, iwl1000_bgn_cfg)},
 	{IWL_PCI_DEVICE(0x0083, 0x1305, iwl1000_bgn_cfg)},
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index cca4c6a..3ea97be 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -57,9 +57,14 @@ extern struct iwl_cfg iwl5100_bg_cfg;
 extern struct iwl_cfg iwl5100_abg_cfg;
 extern struct iwl_cfg iwl5150_agn_cfg;
 extern struct iwl_cfg iwl6000h_2agn_cfg;
+extern struct iwl_cfg iwl6000h_2abg_cfg;
+extern struct iwl_cfg iwl6000h_2bg_cfg;
 extern struct iwl_cfg iwl6000i_2agn_cfg;
+extern struct iwl_cfg iwl6000i_2abg_cfg;
+extern struct iwl_cfg iwl6000i_2bg_cfg;
 extern struct iwl_cfg iwl6000_3agn_cfg;
 extern struct iwl_cfg iwl6050_2agn_cfg;
+extern struct iwl_cfg iwl6050_2abg_cfg;
 extern struct iwl_cfg iwl6050_3agn_cfg;
 extern struct iwl_cfg iwl1000_bgn_cfg;
 extern struct iwl_cfg iwl1000_bg_cfg;
-- 
1.5.6.3

