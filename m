Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:28731 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754907Ab0BETeQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 14:34:16 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ben Cahill <ben.m.cahill@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/3] iwlwifi: Add chain_noise support for 6050
Date: Fri,  5 Feb 2010 11:33:47 -0800
Message-Id: <1265398428-8048-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1265398428-8048-1-git-send-email-reinette.chatre@intel.com>
References: <1265398428-8048-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Existing iwl6050_ops->iwl6050_hcmd_utils structure had no pointers to chain
noise functions (gain_computation and chain_noise_reset).  As it turns out,
by adding chain_noise_scale (see related patch), there is no need for separate
chain noise function, so simply use iwl6000_ops->iwl5000_hcmd_utils, and
remove those for 6050.

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |   19 ++-----------------
 1 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 1719825..782e23a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -277,21 +277,6 @@ static const struct iwl_ops iwl6000_ops = {
 	.led = &iwlagn_led_ops,
 };
 
-static struct iwl_hcmd_utils_ops iwl6050_hcmd_utils = {
-	.get_hcmd_size = iwl5000_get_hcmd_size,
-	.build_addsta_hcmd = iwl5000_build_addsta_hcmd,
-	.rts_tx_cmd_flag = iwl5000_rts_tx_cmd_flag,
-	.calc_rssi = iwl5000_calc_rssi,
-};
-
-static const struct iwl_ops iwl6050_ops = {
-	.ucode = &iwl5000_ucode,
-	.lib = &iwl6000_lib,
-	.hcmd = &iwl5000_hcmd,
-	.utils = &iwl6050_hcmd_utils,
-	.led = &iwlagn_led_ops,
-};
-
 /*
  * "i": Internal configuration, use internal Power Amplifier
  */
@@ -395,7 +380,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.ucode_api_max = IWL6050_UCODE_API_MAX,
 	.ucode_api_min = IWL6050_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
-	.ops = &iwl6050_ops,
+	.ops = &iwl6000_ops,
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_6050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
@@ -427,7 +412,7 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 	.ucode_api_max = IWL6050_UCODE_API_MAX,
 	.ucode_api_min = IWL6050_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G,
-	.ops = &iwl6050_ops,
+	.ops = &iwl6000_ops,
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_6050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
-- 
1.6.3.3

