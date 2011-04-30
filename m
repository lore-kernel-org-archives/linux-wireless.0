Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:11717 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757788Ab1D3Qks (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Apr 2011 12:40:48 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/14] iwlagn: new 105 series device
Date: Sat, 30 Apr 2011 09:17:34 -0700
Message-Id: <1304180260-13875-9-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110430_184107_059632_E038545D)
In-Reply-To: <1304180260-13875-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1304180260-13875-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Correction for new 105 series devices

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-2000.c |   58 +++++++++++++++---------------
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   30 ++++++++--------
 drivers/net/wireless/iwlwifi/iwl-agn.h  |    8 ++--
 3 files changed, 48 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index e76e02c..f90d6af 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -51,12 +51,12 @@
 /* Highest firmware API version supported */
 #define IWL2030_UCODE_API_MAX 5
 #define IWL2000_UCODE_API_MAX 5
-#define IWL200_UCODE_API_MAX 5
+#define IWL105_UCODE_API_MAX 5
 
 /* Lowest firmware API version supported */
 #define IWL2030_UCODE_API_MIN 5
 #define IWL2000_UCODE_API_MIN 5
-#define IWL200_UCODE_API_MIN 5
+#define IWL105_UCODE_API_MIN 5
 
 #define IWL2030_FW_PRE "iwlwifi-2030-"
 #define IWL2030_MODULE_FIRMWARE(api) IWL2030_FW_PRE #api ".ucode"
@@ -64,8 +64,8 @@
 #define IWL2000_FW_PRE "iwlwifi-2000-"
 #define IWL2000_MODULE_FIRMWARE(api) IWL2000_FW_PRE #api ".ucode"
 
-#define IWL200_FW_PRE "iwlwifi-200-"
-#define IWL200_MODULE_FIRMWARE(api) IWL200_FW_PRE #api ".ucode"
+#define IWL105_FW_PRE "iwlwifi-105-"
+#define IWL105_MODULE_FIRMWARE(api) IWL105_FW_PRE #api ".ucode"
 
 static void iwl2000_set_ct_threshold(struct iwl_priv *priv)
 {
@@ -312,13 +312,13 @@ static const struct iwl_ops iwl2030_ops = {
 	.utils = &iwlagn_hcmd_utils,
 };
 
-static const struct iwl_ops iwl200_ops = {
+static const struct iwl_ops iwl105_ops = {
 	.lib = &iwl2000_lib,
 	.hcmd = &iwlagn_hcmd,
 	.utils = &iwlagn_hcmd_utils,
 };
 
-static const struct iwl_ops iwl230_ops = {
+static const struct iwl_ops iwl135_ops = {
 	.lib = &iwl2000_lib,
 	.hcmd = &iwlagn_bt_hcmd,
 	.utils = &iwlagn_hcmd_utils,
@@ -429,13 +429,13 @@ struct iwl_cfg iwl2030_2bg_cfg = {
 	IWL_DEVICE_2030,
 };
 
-#define IWL_DEVICE_200						\
-	.fw_name_pre = IWL200_FW_PRE,				\
-	.ucode_api_max = IWL200_UCODE_API_MAX,			\
-	.ucode_api_min = IWL200_UCODE_API_MIN,			\
+#define IWL_DEVICE_105						\
+	.fw_name_pre = IWL105_FW_PRE,				\
+	.ucode_api_max = IWL105_UCODE_API_MAX,			\
+	.ucode_api_min = IWL105_UCODE_API_MIN,			\
 	.eeprom_ver = EEPROM_2000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
-	.ops = &iwl200_ops,					\
+	.ops = &iwl105_ops,					\
 	.mod_params = &iwlagn_mod_params,			\
 	.base_params = &iwl2000_base_params,			\
 	.need_dc_calib = true,					\
@@ -444,24 +444,24 @@ struct iwl_cfg iwl2030_2bg_cfg = {
 	.adv_pm = true,						\
 	.rx_with_siso_diversity = true				\
 
-struct iwl_cfg iwl200_bg_cfg = {
-	.name = "200 Series 1x1 BG",
-	IWL_DEVICE_200,
+struct iwl_cfg iwl105_bg_cfg = {
+	.name = "105 Series 1x1 BG",
+	IWL_DEVICE_105,
 };
 
-struct iwl_cfg iwl200_bgn_cfg = {
-	.name = "200 Series 1x1 BGN",
-	IWL_DEVICE_200,
+struct iwl_cfg iwl105_bgn_cfg = {
+	.name = "105 Series 1x1 BGN",
+	IWL_DEVICE_105,
 	.ht_params = &iwl2000_ht_params,
 };
 
-#define IWL_DEVICE_230						\
-	.fw_name_pre = IWL200_FW_PRE,				\
-	.ucode_api_max = IWL200_UCODE_API_MAX,			\
-	.ucode_api_min = IWL200_UCODE_API_MIN,			\
+#define IWL_DEVICE_135						\
+	.fw_name_pre = IWL105_FW_PRE,				\
+	.ucode_api_max = IWL105_UCODE_API_MAX,			\
+	.ucode_api_min = IWL105_UCODE_API_MIN,			\
 	.eeprom_ver = EEPROM_2000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
-	.ops = &iwl230_ops,					\
+	.ops = &iwl135_ops,					\
 	.mod_params = &iwlagn_mod_params,			\
 	.base_params = &iwl2030_base_params,			\
 	.bt_params = &iwl2030_bt_params,			\
@@ -471,17 +471,17 @@ struct iwl_cfg iwl200_bgn_cfg = {
 	.adv_pm = true,						\
 	.rx_with_siso_diversity = true				\
 
-struct iwl_cfg iwl230_bg_cfg = {
-	.name = "200 Series 1x1 BG/BT",
-	IWL_DEVICE_230,
+struct iwl_cfg iwl135_bg_cfg = {
+	.name = "105 Series 1x1 BG/BT",
+	IWL_DEVICE_135,
 };
 
-struct iwl_cfg iwl230_bgn_cfg = {
-	.name = "200 Series 1x1 BGN/BT",
-	IWL_DEVICE_230,
+struct iwl_cfg iwl135_bgn_cfg = {
+	.name = "105 Series 1x1 BGN/BT",
+	IWL_DEVICE_135,
 	.ht_params = &iwl2000_ht_params,
 };
 
 MODULE_FIRMWARE(IWL2000_MODULE_FIRMWARE(IWL2000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL2030_MODULE_FIRMWARE(IWL2030_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL200_MODULE_FIRMWARE(IWL200_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL105_MODULE_FIRMWARE(IWL105_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 395d1ad..8232245 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4129,21 +4129,21 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x088F, 0x4266, iwl6035_2bg_cfg)},
 	{IWL_PCI_DEVICE(0x088E, 0x4466, iwl6035_2bg_cfg)},
 
-/* 200 Series */
-	{IWL_PCI_DEVICE(0x0894, 0x0022, iwl200_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0895, 0x0222, iwl200_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0894, 0x0422, iwl200_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0894, 0x0026, iwl200_bg_cfg)},
-	{IWL_PCI_DEVICE(0x0895, 0x0226, iwl200_bg_cfg)},
-	{IWL_PCI_DEVICE(0x0894, 0x0426, iwl200_bg_cfg)},
-
-/* 230 Series */
-	{IWL_PCI_DEVICE(0x0892, 0x0062, iwl230_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0893, 0x0262, iwl230_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0892, 0x0462, iwl230_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0892, 0x0066, iwl230_bg_cfg)},
-	{IWL_PCI_DEVICE(0x0893, 0x0266, iwl230_bg_cfg)},
-	{IWL_PCI_DEVICE(0x0892, 0x0466, iwl230_bg_cfg)},
+/* 105 Series */
+	{IWL_PCI_DEVICE(0x0894, 0x0022, iwl105_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0895, 0x0222, iwl105_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0894, 0x0422, iwl105_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0894, 0x0026, iwl105_bg_cfg)},
+	{IWL_PCI_DEVICE(0x0895, 0x0226, iwl105_bg_cfg)},
+	{IWL_PCI_DEVICE(0x0894, 0x0426, iwl105_bg_cfg)},
+
+/* 135 Series */
+	{IWL_PCI_DEVICE(0x0892, 0x0062, iwl135_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0893, 0x0262, iwl135_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0892, 0x0462, iwl135_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0892, 0x0066, iwl135_bg_cfg)},
+	{IWL_PCI_DEVICE(0x0893, 0x0266, iwl135_bg_cfg)},
+	{IWL_PCI_DEVICE(0x0892, 0x0466, iwl135_bg_cfg)},
 
 	{0}
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 7d8e16e..9d644d4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -102,10 +102,10 @@ extern struct iwl_cfg iwl2030_2bg_cfg;
 extern struct iwl_cfg iwl6035_2agn_cfg;
 extern struct iwl_cfg iwl6035_2abg_cfg;
 extern struct iwl_cfg iwl6035_2bg_cfg;
-extern struct iwl_cfg iwl200_bg_cfg;
-extern struct iwl_cfg iwl200_bgn_cfg;
-extern struct iwl_cfg iwl230_bg_cfg;
-extern struct iwl_cfg iwl230_bgn_cfg;
+extern struct iwl_cfg iwl105_bg_cfg;
+extern struct iwl_cfg iwl105_bgn_cfg;
+extern struct iwl_cfg iwl135_bg_cfg;
+extern struct iwl_cfg iwl135_bgn_cfg;
 
 extern struct iwl_mod_params iwlagn_mod_params;
 extern struct iwl_hcmd_ops iwlagn_hcmd;
-- 
1.7.0.4

