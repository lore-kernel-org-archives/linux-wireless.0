Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47747 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754858Ab1AVASU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 19:18:20 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/14] iwlagn: remove reference to gen2a and gen2b
Date: Fri, 21 Jan 2011 16:06:37 -0800
Message-Id: <1295654809-5790-3-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1295654809-5790-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1295654809-5790-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Since 6005, 6030 and 6150 series are offical released, remove the reference
to gen2x and use the product number instead.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c   |   52 ++++++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |   16 +++++---
 2 files changed, 36 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index af505bc..c195674 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -67,13 +67,13 @@
 #define _IWL6050_MODULE_FIRMWARE(api) IWL6050_FW_PRE #api ".ucode"
 #define IWL6050_MODULE_FIRMWARE(api) _IWL6050_MODULE_FIRMWARE(api)
 
-#define IWL6000G2A_FW_PRE "iwlwifi-6000g2a-"
-#define _IWL6000G2A_MODULE_FIRMWARE(api) IWL6000G2A_FW_PRE #api ".ucode"
-#define IWL6000G2A_MODULE_FIRMWARE(api) _IWL6000G2A_MODULE_FIRMWARE(api)
+#define IWL6005_FW_PRE "iwlwifi-6000g2a-"
+#define _IWL6005_MODULE_FIRMWARE(api) IWL6005_FW_PRE #api ".ucode"
+#define IWL6005_MODULE_FIRMWARE(api) _IWL6005_MODULE_FIRMWARE(api)
 
-#define IWL6000G2B_FW_PRE "iwlwifi-6000g2b-"
-#define _IWL6000G2B_MODULE_FIRMWARE(api) IWL6000G2B_FW_PRE #api ".ucode"
-#define IWL6000G2B_MODULE_FIRMWARE(api) _IWL6000G2B_MODULE_FIRMWARE(api)
+#define IWL6030_FW_PRE "iwlwifi-6000g2b-"
+#define _IWL6030_MODULE_FIRMWARE(api) IWL6030_FW_PRE #api ".ucode"
+#define IWL6030_MODULE_FIRMWARE(api) _IWL6030_MODULE_FIRMWARE(api)
 
 static void iwl6000_set_ct_threshold(struct iwl_priv *priv)
 {
@@ -90,7 +90,7 @@ static void iwl6050_additional_nic_config(struct iwl_priv *priv)
 				CSR_GP_DRIVER_REG_BIT_CALIB_VERSION6);
 }
 
-static void iwl6050g2_additional_nic_config(struct iwl_priv *priv)
+static void iwl6150_additional_nic_config(struct iwl_priv *priv)
 {
 	/* Indicate calibration version to uCode. */
 	if (priv->cfg->ops->lib->eeprom_ops.calib_version(priv) >= 6)
@@ -354,7 +354,7 @@ static struct iwl_lib_ops iwl6000_lib = {
 	}
 };
 
-static struct iwl_lib_ops iwl6000g2b_lib = {
+static struct iwl_lib_ops iwl6030_lib = {
 	.set_hw_params = iwl6000_hw_set_hw_params,
 	.txq_update_byte_cnt_tbl = iwlagn_txq_update_byte_cnt_tbl,
 	.txq_inval_byte_cnt_tbl = iwlagn_txq_inval_byte_cnt_tbl,
@@ -430,8 +430,8 @@ static struct iwl_nic_ops iwl6050_nic_ops = {
 	.additional_nic_config = &iwl6050_additional_nic_config,
 };
 
-static struct iwl_nic_ops iwl6050g2_nic_ops = {
-	.additional_nic_config = &iwl6050g2_additional_nic_config,
+static struct iwl_nic_ops iwl6150_nic_ops = {
+	.additional_nic_config = &iwl6150_additional_nic_config,
 };
 
 static const struct iwl_ops iwl6000_ops = {
@@ -451,17 +451,17 @@ static const struct iwl_ops iwl6050_ops = {
 	.ieee80211_ops = &iwlagn_hw_ops,
 };
 
-static const struct iwl_ops iwl6050g2_ops = {
+static const struct iwl_ops iwl6150_ops = {
 	.lib = &iwl6000_lib,
 	.hcmd = &iwlagn_hcmd,
 	.utils = &iwlagn_hcmd_utils,
 	.led = &iwlagn_led_ops,
-	.nic = &iwl6050g2_nic_ops,
+	.nic = &iwl6150_nic_ops,
 	.ieee80211_ops = &iwlagn_hw_ops,
 };
 
-static const struct iwl_ops iwl6000g2b_ops = {
-	.lib = &iwl6000g2b_lib,
+static const struct iwl_ops iwl6030_ops = {
+	.lib = &iwl6030_lib,
 	.hcmd = &iwlagn_bt_hcmd,
 	.utils = &iwlagn_hcmd_utils,
 	.led = &iwlagn_led_ops,
@@ -555,11 +555,11 @@ static struct iwl_bt_params iwl6000_bt_params = {
 };
 
 #define IWL_DEVICE_6005						\
-	.fw_name_pre = IWL6000G2A_FW_PRE,			\
+	.fw_name_pre = IWL6005_FW_PRE,			\
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,		\
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,		\
-	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,		\
-	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,	\
+	.eeprom_ver = EEPROM_6005_EEPROM_VERSION,		\
+	.eeprom_calib_ver = EEPROM_6005_TX_POWER_VERSION,	\
 	.ops = &iwl6000_ops,					\
 	.mod_params = &iwlagn_mod_params,			\
 	.base_params = &iwl6000_g2_base_params,			\
@@ -584,12 +584,12 @@ struct iwl_cfg iwl6005_2bg_cfg = {
 };
 
 #define IWL_DEVICE_6030						\
-	.fw_name_pre = IWL6000G2B_FW_PRE,			\
+	.fw_name_pre = IWL6030_FW_PRE,			\
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,		\
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,		\
-	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,		\
-	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,	\
-	.ops = &iwl6000g2b_ops,					\
+	.eeprom_ver = EEPROM_6030_EEPROM_VERSION,		\
+	.eeprom_calib_ver = EEPROM_6030_TX_POWER_VERSION,	\
+	.ops = &iwl6030_ops,					\
 	.mod_params = &iwlagn_mod_params,			\
 	.base_params = &iwl6000_g2_base_params,			\
 	.bt_params = &iwl6000_bt_params,			\
@@ -706,9 +706,9 @@ struct iwl_cfg iwl6150_bgn_cfg = {
 	.fw_name_pre = IWL6050_FW_PRE,
 	.ucode_api_max = IWL6050_UCODE_API_MAX,
 	.ucode_api_min = IWL6050_UCODE_API_MIN,
-	.eeprom_ver = EEPROM_6050G2_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_6050G2_TX_POWER_VERSION,
-	.ops = &iwl6050g2_ops,
+	.eeprom_ver = EEPROM_6150_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_6150_TX_POWER_VERSION,
+	.ops = &iwl6150_ops,
 	.mod_params = &iwlagn_mod_params,
 	.base_params = &iwl6050_base_params,
 	.ht_params = &iwl6000_ht_params,
@@ -734,5 +734,5 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 
 MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL6050_MODULE_FIRMWARE(IWL6050_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL6000G2A_MODULE_FIRMWARE(IWL6000G2_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL6000G2B_MODULE_FIRMWARE(IWL6000G2_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL6005_MODULE_FIRMWARE(IWL6000G2_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL6030_MODULE_FIRMWARE(IWL6000G2_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 9e6f313..4f4cd4f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -247,13 +247,17 @@ struct iwl_eeprom_enhanced_txpwr {
 #define EEPROM_6050_TX_POWER_VERSION    (4)
 #define EEPROM_6050_EEPROM_VERSION	(0x532)
 
-/* 6x50g2 Specific */
-#define EEPROM_6050G2_TX_POWER_VERSION    (6)
-#define EEPROM_6050G2_EEPROM_VERSION	(0x553)
+/* 6150 Specific */
+#define EEPROM_6150_TX_POWER_VERSION    (6)
+#define EEPROM_6150_EEPROM_VERSION	(0x553)
 
-/* 6x00g2 Specific */
-#define EEPROM_6000G2_TX_POWER_VERSION    (6)
-#define EEPROM_6000G2_EEPROM_VERSION	(0x709)
+/* 6x05 Specific */
+#define EEPROM_6005_TX_POWER_VERSION    (6)
+#define EEPROM_6005_EEPROM_VERSION	(0x709)
+
+/* 6x30 Specific */
+#define EEPROM_6030_TX_POWER_VERSION    (6)
+#define EEPROM_6030_EEPROM_VERSION	(0x709)
 
 /* OTP */
 /* lower blocks contain EEPROM image and calibration data */
-- 
1.7.0.4

