Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:7292 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483AbZA2TGW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2009 14:06:22 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Jay Sternberg <jay.e.sternberg@linux.intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 6/7] iwlwifi: remove chain noise calibration functions from 6000 family
Date: Thu, 29 Jan 2009 11:09:16 -0800
Message-Id: <1233256157-21290-7-git-send-email-reinette.chatre@intel.com> (sfid-20090129_200630_968829_FCB863A1)
In-Reply-To: <1233256157-21290-6-git-send-email-reinette.chatre@intel.com>
References: <>
 <1233256157-21290-1-git-send-email-reinette.chatre@intel.com>
 <1233256157-21290-2-git-send-email-reinette.chatre@intel.com>
 <1233256157-21290-3-git-send-email-reinette.chatre@intel.com>
 <1233256157-21290-4-git-send-email-reinette.chatre@intel.com>
 <1233256157-21290-5-git-send-email-reinette.chatre@intel.com>
 <1233256157-21290-6-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jay Sternberg <jay.e.sternberg@linux.intel.com>

redefine structures that contain function pointer for chain noise reset
and chain noise gain for the 6000 family since these are not needed.

Signed-off-by: Jay Sternberg <jay.e.sternberg@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c  |   23 ++++++++++++++++++-----
 drivers/net/wireless/iwlwifi/iwl-calib.c |    5 +++--
 2 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index af70070..edfa5e1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -61,13 +61,26 @@
 #define _IWL6050_MODULE_FIRMWARE(api) IWL6050_FW_PRE #api ".ucode"
 #define IWL6050_MODULE_FIRMWARE(api) _IWL6050_MODULE_FIRMWARE(api)
 
+static struct iwl_hcmd_utils_ops iwl6000_hcmd_utils = {
+	.get_hcmd_size = iwl5000_get_hcmd_size,
+	.build_addsta_hcmd = iwl5000_build_addsta_hcmd,
+	.rts_tx_cmd_flag = iwl5000_rts_tx_cmd_flag,
+	.calc_rssi = iwl5000_calc_rssi,
+};
+
+static struct iwl_ops iwl6000_ops = {
+	.lib = &iwl5000_lib,
+	.hcmd = &iwl5000_hcmd,
+	.utils = &iwl6000_hcmd_utils,
+};
+
 struct iwl_cfg iwl6000_2ag_cfg = {
 	.name = "6000 Series 2x2 AG",
 	.fw_name_pre = IWL6000_FW_PRE,
 	.ucode_api_max = IWL6000_UCODE_API_MAX,
 	.ucode_api_min = IWL6000_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G,
-	.ops = &iwl5000_ops,
+	.ops = &iwl6000_ops,
 	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
@@ -83,7 +96,7 @@ struct iwl_cfg iwl6000_2agn_cfg = {
 	.ucode_api_max = IWL6000_UCODE_API_MAX,
 	.ucode_api_min = IWL6000_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
-	.ops = &iwl5000_ops,
+	.ops = &iwl6000_ops,
 	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
@@ -99,7 +112,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.ucode_api_max = IWL6050_UCODE_API_MAX,
 	.ucode_api_min = IWL6050_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
-	.ops = &iwl5000_ops,
+	.ops = &iwl6000_ops,
 	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
@@ -115,7 +128,7 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.ucode_api_max = IWL6000_UCODE_API_MAX,
 	.ucode_api_min = IWL6000_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
-	.ops = &iwl5000_ops,
+	.ops = &iwl6000_ops,
 	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
@@ -131,7 +144,7 @@ struct iwl_cfg iwl6050_3agn_cfg = {
 	.ucode_api_max = IWL6050_UCODE_API_MAX,
 	.ucode_api_min = IWL6050_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
-	.ops = &iwl5000_ops,
+	.ops = &iwl6000_ops,
 	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.c b/drivers/net/wireless/iwlwifi/iwl-calib.c
index d06c577..d95797a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.c
@@ -846,8 +846,9 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv,
 	IWL_DEBUG_CALIB(priv, "min_average_noise = %d, antenna %d\n",
 			min_average_noise, min_average_noise_antenna_i);
 
-	priv->cfg->ops->utils->gain_computation(priv, average_noise,
-		min_average_noise_antenna_i, min_average_noise);
+	if (priv->cfg->ops->utils->gain_computation)
+		priv->cfg->ops->utils->gain_computation(priv, average_noise,
+			min_average_noise_antenna_i, min_average_noise);
 
 	/* Some power changes may have been made during the calibration.
 	 * Update and commit the RXON
-- 
1.5.4.3

