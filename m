Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:13630 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857AbZJPVZ7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 17:25:59 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 09/10] iwlwifi: no chain noise support for 6x50 series
Date: Fri, 16 Oct 2009 14:25:57 -0700
Message-Id: <1255728358-29976-10-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1255728358-29976-1-git-send-email-reinette.chatre@intel.com>
References: <1255728358-29976-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

For initial bring up of 6x50 series NICs, no chain noise support in
uCode, this feature will be added in the later stage of development.

Two chain noise related functions are removed from 6x50 series:
1. gain computation
2. chain noise reset

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 887e4e3..b531813 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -232,6 +232,21 @@ static struct iwl_ops iwl6000_ops = {
 	.led = &iwlagn_led_ops,
 };
 
+static struct iwl_hcmd_utils_ops iwl6050_hcmd_utils = {
+	.get_hcmd_size = iwl5000_get_hcmd_size,
+	.build_addsta_hcmd = iwl5000_build_addsta_hcmd,
+	.rts_tx_cmd_flag = iwl5000_rts_tx_cmd_flag,
+	.calc_rssi = iwl5000_calc_rssi,
+};
+
+static struct iwl_ops iwl6050_ops = {
+	.ucode = &iwl5000_ucode,
+	.lib = &iwl6000_lib,
+	.hcmd = &iwl5000_hcmd,
+	.utils = &iwl6050_hcmd_utils,
+	.led = &iwlagn_led_ops,
+};
+
 
 /*
  * "h": Hybrid configuration, use both internal and external Power Amplifier
@@ -397,7 +412,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.ucode_api_max = IWL6050_UCODE_API_MAX,
 	.ucode_api_min = IWL6050_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
-	.ops = &iwl6000_ops,
+	.ops = &iwl6050_ops,
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_6050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
@@ -423,7 +438,7 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 	.ucode_api_max = IWL6050_UCODE_API_MAX,
 	.ucode_api_min = IWL6050_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G,
-	.ops = &iwl6000_ops,
+	.ops = &iwl6050_ops,
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_6050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
@@ -474,7 +489,7 @@ struct iwl_cfg iwl6050_3agn_cfg = {
 	.ucode_api_max = IWL6050_UCODE_API_MAX,
 	.ucode_api_min = IWL6050_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
-	.ops = &iwl6000_ops,
+	.ops = &iwl6050_ops,
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_6050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
-- 
1.5.6.3

