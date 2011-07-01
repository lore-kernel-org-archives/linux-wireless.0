Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:7398 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755501Ab1GAPxD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2011 11:53:03 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/11] iwlagn: add correct firmware name for 135 series
Date: Fri,  1 Jul 2011 08:19:57 -0700
Message-Id: <1309533605-25774-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110701_175313_468084_5131E734)
In-Reply-To: <1309533605-25774-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1309533605-25774-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

135 series are WiFi/BT combo and require different uCode from 105 series.
[A
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-2000.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 64ed1f2..76a3e42 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -50,11 +50,13 @@
 #define IWL2030_UCODE_API_MAX 5
 #define IWL2000_UCODE_API_MAX 5
 #define IWL105_UCODE_API_MAX 5
+#define IWL135_UCODE_API_MAX 5
 
 /* Lowest firmware API version supported */
 #define IWL2030_UCODE_API_MIN 5
 #define IWL2000_UCODE_API_MIN 5
 #define IWL105_UCODE_API_MIN 5
+#define IWL135_UCODE_API_MIN 5
 
 #define IWL2030_FW_PRE "iwlwifi-2030-"
 #define IWL2030_MODULE_FIRMWARE(api) IWL2030_FW_PRE __stringify(api) ".ucode"
@@ -65,6 +67,9 @@
 #define IWL105_FW_PRE "iwlwifi-105-"
 #define IWL105_MODULE_FIRMWARE(api) IWL105_FW_PRE __stringify(api) ".ucode"
 
+#define IWL135_FW_PRE "iwlwifi-135-"
+#define IWL135_MODULE_FIRMWARE(api) IWL135_FW_PRE #api ".ucode"
+
 static void iwl2000_set_ct_threshold(struct iwl_priv *priv)
 {
 	/* want Celsius */
@@ -344,9 +349,9 @@ struct iwl_cfg iwl105_bgn_cfg = {
 };
 
 #define IWL_DEVICE_135						\
-	.fw_name_pre = IWL105_FW_PRE,				\
-	.ucode_api_max = IWL105_UCODE_API_MAX,			\
-	.ucode_api_min = IWL105_UCODE_API_MIN,			\
+	.fw_name_pre = IWL135_FW_PRE,				\
+	.ucode_api_max = IWL135_UCODE_API_MAX,			\
+	.ucode_api_min = IWL135_UCODE_API_MIN,			\
 	.eeprom_ver = EEPROM_2000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
 	.ops = &iwl135_ops,					\
@@ -359,12 +364,12 @@ struct iwl_cfg iwl105_bgn_cfg = {
 	.rx_with_siso_diversity = true				\
 
 struct iwl_cfg iwl135_bg_cfg = {
-	.name = "105 Series 1x1 BG/BT",
+	.name = "135 Series 1x1 BG/BT",
 	IWL_DEVICE_135,
 };
 
 struct iwl_cfg iwl135_bgn_cfg = {
-	.name = "105 Series 1x1 BGN/BT",
+	.name = "135 Series 1x1 BGN/BT",
 	IWL_DEVICE_135,
 	.ht_params = &iwl2000_ht_params,
 };
@@ -372,3 +377,4 @@ struct iwl_cfg iwl135_bgn_cfg = {
 MODULE_FIRMWARE(IWL2000_MODULE_FIRMWARE(IWL2000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL2030_MODULE_FIRMWARE(IWL2030_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL105_MODULE_FIRMWARE(IWL105_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL135_MODULE_FIRMWARE(IWL135_UCODE_API_MAX));
-- 
1.7.0.4

