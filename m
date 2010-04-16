Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50641 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932588Ab0DPVwn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 17:52:43 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Shanyu Zhao <shanyu.zhao@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 09/21] iwlwifi: bring up 6000 Series 2x2 AGN Gen2 adapters
Date: Fri, 16 Apr 2010 14:52:26 -0700
Message-Id: <1271454758-14351-10-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1271454758-14351-1-git-send-email-reinette.chatre@intel.com>
References: <1271454758-14351-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shanyu Zhao <shanyu.zhao@intel.com>

This patch is to bring up 6000 Series 2x2 AGN Gen2 adapters.
Seperate various version numbers from 6000 Series definitions;
Add module firmware declaration for the new adapters;
Add additional device IDs and subsystem IDs;

Signed-off-by: Shanyu Zhao <shanyu.zhao@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c   |   20 +++++++++++++-------
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    7 ++++++-
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |    4 ++++
 4 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index f5d0665..63d27e3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -51,13 +51,14 @@
 /* Highest firmware API version supported */
 #define IWL6000_UCODE_API_MAX 4
 #define IWL6050_UCODE_API_MAX 4
+#define IWL6000G2_UCODE_API_MAX 4
 
 /* Lowest firmware API version supported */
 #define IWL6000_UCODE_API_MIN 4
 #define IWL6050_UCODE_API_MIN 4
+#define IWL6000G2_UCODE_API_MIN 4
 
 #define IWL6000_FW_PRE "iwlwifi-6000-"
-#define IWL6000_G2_FW_PRE "iwlwifi-6005-"
 #define _IWL6000_MODULE_FIRMWARE(api) IWL6000_FW_PRE #api ".ucode"
 #define IWL6000_MODULE_FIRMWARE(api) _IWL6000_MODULE_FIRMWARE(api)
 
@@ -65,6 +66,10 @@
 #define _IWL6050_MODULE_FIRMWARE(api) IWL6050_FW_PRE #api ".ucode"
 #define IWL6050_MODULE_FIRMWARE(api) _IWL6050_MODULE_FIRMWARE(api)
 
+#define IWL6000G2_FW_PRE "iwlwifi-6005-"
+#define _IWL6000G2_MODULE_FIRMWARE(api) IWL6000G2_FW_PRE #api ".ucode"
+#define IWL6000G2_MODULE_FIRMWARE(api) _IWL6000G2_MODULE_FIRMWARE(api)
+
 static void iwl6000_set_ct_threshold(struct iwl_priv *priv)
 {
 	/* want Celsius */
@@ -363,16 +368,16 @@ static const struct iwl_ops iwl6050_ops = {
 /*
  * "i": Internal configuration, use internal Power Amplifier
  */
-struct iwl_cfg iwl6000i_g2_2agn_cfg = {
+struct iwl_cfg iwl6000g2i_2agn_cfg = {
 	.name = "6000 Series 2x2 AGN Gen2",
-	.fw_name_pre = IWL6000_G2_FW_PRE,
-	.ucode_api_max = IWL6000_UCODE_API_MAX,
-	.ucode_api_min = IWL6000_UCODE_API_MIN,
+	.fw_name_pre = IWL6000G2_FW_PRE,
+	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
+	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl6000_ops,
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
-	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_6000_TX_POWER_VERSION,
+	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.mod_params = &iwlagn_mod_params,
@@ -600,3 +605,4 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 
 MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL6050_MODULE_FIRMWARE(IWL6050_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL6000G2_MODULE_FIRMWARE(IWL6000G2_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 3199818..e788722 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3835,7 +3835,12 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x4238, 0x1111, iwl6000_3agn_cfg)},
 	{IWL_PCI_DEVICE(0x4239, 0x1311, iwl6000i_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x4239, 0x1316, iwl6000i_2abg_cfg)},
-	{IWL_PCI_DEVICE(0x0082, 0x1201, iwl6000i_g2_2agn_cfg)},
+
+/* 6x00 Series Gen2 */
+	{IWL_PCI_DEVICE(0x0082, 0x1201, iwl6000g2i_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x0082, 0x1301, iwl6000g2i_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x0082, 0x1321, iwl6000g2i_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x0085, 0x1311, iwl6000g2i_2agn_cfg)},
 
 /* 6x50 WiFi/WiMax Series */
 	{IWL_PCI_DEVICE(0x0087, 0x1301, iwl6050_2agn_cfg)},
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index dc9d8ae..ff4b47c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -58,7 +58,7 @@ extern struct iwl_cfg iwl5100_abg_cfg;
 extern struct iwl_cfg iwl5150_agn_cfg;
 extern struct iwl_cfg iwl5150_abg_cfg;
 extern struct iwl_cfg iwl6000i_2agn_cfg;
-extern struct iwl_cfg iwl6000i_g2_2agn_cfg;
+extern struct iwl_cfg iwl6000g2i_2agn_cfg;
 extern struct iwl_cfg iwl6000i_2abg_cfg;
 extern struct iwl_cfg iwl6000i_2bg_cfg;
 extern struct iwl_cfg iwl6000_3agn_cfg;
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 9977d5e..95aa202 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -276,6 +276,10 @@ struct iwl_eeprom_enhanced_txpwr {
 #define EEPROM_6050_TX_POWER_VERSION    (4)
 #define EEPROM_6050_EEPROM_VERSION	(0x532)
 
+/* 6x00g2 Specific */
+#define EEPROM_6000G2_TX_POWER_VERSION    (6)
+#define EEPROM_6000G2_EEPROM_VERSION	(0x709)
+
 /* OTP */
 /* lower blocks contain EEPROM image and calibration data */
 #define OTP_LOW_IMAGE_SIZE		(2 * 512 * sizeof(u16)) /* 2 KB */
-- 
1.6.3.3

