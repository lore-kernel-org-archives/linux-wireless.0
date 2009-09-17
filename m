Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:62030 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758576AbZIQRn4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2009 13:43:56 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 09/13] iwlwifi: update PCI Subsystem ID for 1000 series
Date: Thu, 17 Sep 2009 10:43:52 -0700
Message-Id: <1253209436-2309-10-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1253209436-2309-1-git-send-email-reinette.chatre@intel.com>
References: <1253209436-2309-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Update PCI Subsystem ID for 1000 series based on HW SKU. Adding new SKU
for "BG" only devices.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |   20 ++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   14 ++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    1 +
 3 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 4da99d1..4abfc84 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -165,3 +165,23 @@ struct iwl_cfg iwl1000_bgn_cfg = {
 	.led_compensation = 51,
 };
 
+struct iwl_cfg iwl1000_bg_cfg = {
+	.name = "1000 Series BG",
+	.fw_name_pre = IWL1000_FW_PRE,
+	.ucode_api_max = IWL1000_UCODE_API_MAX,
+	.ucode_api_min = IWL1000_UCODE_API_MIN,
+	.sku = IWL_SKU_G,
+	.ops = &iwl1000_ops,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
+	.mod_params = &iwl50_mod_params,
+	.valid_tx_ant = ANT_A,
+	.valid_rx_ant = ANT_AB,
+	.need_pll_cfg = true,
+	.max_ll_items = OTP_MAX_LL_ITEMS_1000,
+	.shadow_ram_support = false,
+	.ht_greenfield_support = true,
+	.led_compensation = 51,
+};
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index cc7a5a9..b29e44f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3085,8 +3085,18 @@ static struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x0088, PCI_ANY_ID, iwl6050_3agn_cfg)},
 	{IWL_PCI_DEVICE(0x0089, PCI_ANY_ID, iwl6050_2agn_cfg)},
 /* 1000 Series WiFi */
-	{IWL_PCI_DEVICE(0x0083, PCI_ANY_ID, iwl1000_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0084, PCI_ANY_ID, iwl1000_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0083, 0x1205, iwl1000_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0083, 0x1305, iwl1000_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0083, 0x1225, iwl1000_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0083, 0x1325, iwl1000_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0084, 0x1215, iwl1000_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0084, 0x1315, iwl1000_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0083, 0x1206, iwl1000_bg_cfg)},
+	{IWL_PCI_DEVICE(0x0083, 0x1306, iwl1000_bg_cfg)},
+	{IWL_PCI_DEVICE(0x0083, 0x1226, iwl1000_bg_cfg)},
+	{IWL_PCI_DEVICE(0x0083, 0x1326, iwl1000_bg_cfg)},
+	{IWL_PCI_DEVICE(0x0084, 0x1216, iwl1000_bg_cfg)},
+	{IWL_PCI_DEVICE(0x0084, 0x1316, iwl1000_bg_cfg)},
 #endif /* CONFIG_IWL5000 */
 
 	{0}
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 0c80692..cca4c6a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -62,6 +62,7 @@ extern struct iwl_cfg iwl6000_3agn_cfg;
 extern struct iwl_cfg iwl6050_2agn_cfg;
 extern struct iwl_cfg iwl6050_3agn_cfg;
 extern struct iwl_cfg iwl1000_bgn_cfg;
+extern struct iwl_cfg iwl1000_bg_cfg;
 
 struct iwl_tx_queue;
 
-- 
1.5.6.3

