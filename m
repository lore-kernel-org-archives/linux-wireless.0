Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:41899 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753551Ab1CYObh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2011 10:31:37 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/12] iwlagn: use 6030 configuration for 6035 series
Date: Fri, 25 Mar 2011 07:14:06 -0700
Message-Id: <1301062456-17249-3-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1301062456-17249-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1301062456-17249-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

6035 series of devices should use the same uCode as 6030 series,
change it.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-2000.c |   31 -------------------------------
 drivers/net/wireless/iwlwifi/iwl-6000.c |   16 ++++++++++++++++
 2 files changed, 16 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index d7b6126..b1dbe93 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -471,37 +471,6 @@ struct iwl_cfg iwl2030_2bg_cfg = {
 	IWL_DEVICE_2030,
 };
 
-#define IWL_DEVICE_6035						\
-	.fw_name_pre = IWL2030_FW_PRE,				\
-	.ucode_api_max = IWL2030_UCODE_API_MAX,			\
-	.ucode_api_min = IWL2030_UCODE_API_MIN,			\
-	.eeprom_ver = EEPROM_6035_EEPROM_VERSION,		\
-	.eeprom_calib_ver = EEPROM_6035_TX_POWER_VERSION,	\
-	.ops = &iwl2030_ops,					\
-	.mod_params = &iwlagn_mod_params,			\
-	.base_params = &iwl2030_base_params,			\
-	.bt_params = &iwl2030_bt_params,			\
-	.need_dc_calib = true,					\
-	.need_temp_offset_calib = true,				\
-	.led_mode = IWL_LED_RF_STATE,				\
-	.adv_pm = true						\
-
-struct iwl_cfg iwl6035_2agn_cfg = {
-	.name = "2000 Series 2x2 AGN/BT",
-	IWL_DEVICE_6035,
-	.ht_params = &iwl2000_ht_params,
-};
-
-struct iwl_cfg iwl6035_2abg_cfg = {
-	.name = "2000 Series 2x2 ABG/BT",
-	IWL_DEVICE_6035,
-};
-
-struct iwl_cfg iwl6035_2bg_cfg = {
-	.name = "2000 Series 2x2 BG/BT",
-	IWL_DEVICE_6035,
-};
-
 #define IWL_DEVICE_200						\
 	.fw_name_pre = IWL200_FW_PRE,				\
 	.ucode_api_max = IWL200_UCODE_API_MAX,			\
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index a745b01..40e0226 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -613,6 +613,22 @@ struct iwl_cfg iwl6030_2bg_cfg = {
 	IWL_DEVICE_6030,
 };
 
+struct iwl_cfg iwl6035_2agn_cfg = {
+	.name = "6035 Series 2x2 AGN/BT",
+	IWL_DEVICE_6030,
+	.ht_params = &iwl6000_ht_params,
+};
+
+struct iwl_cfg iwl6035_2abg_cfg = {
+	.name = "6035 Series 2x2 ABG/BT",
+	IWL_DEVICE_6030,
+};
+
+struct iwl_cfg iwl6035_2bg_cfg = {
+	.name = "6035 Series 2x2 BG/BT",
+	IWL_DEVICE_6030,
+};
+
 struct iwl_cfg iwl1030_bgn_cfg = {
 	.name = "Intel(R) Centrino(R) Wireless-N 1030 BGN",
 	IWL_DEVICE_6030,
-- 
1.7.0.4

