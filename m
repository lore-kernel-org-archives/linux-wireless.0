Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:12096 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461Ab1GHQUj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2011 12:20:39 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 13/21] iwlagn: use bt handler for 2030 and 135 series devices
Date: Fri,  8 Jul 2011 08:46:21 -0700
Message-Id: <1310139989-27661-14-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110708_182045_265017_08D846C2)
In-Reply-To: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For bt combo devices, need to use bt enabled handlers and functions

Reported-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-2000.c |   25 +++++++++++++++++++++++--
 1 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index b2b054f..21b68b2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -168,6 +168,27 @@ static int iwl2000_hw_set_hw_params(struct iwl_priv *priv)
 static struct iwl_lib_ops iwl2000_lib = {
 	.set_hw_params = iwl2000_hw_set_hw_params,
 	.rx_handler_setup = iwlagn_rx_handler_setup,
+	.setup_deferred_work = iwlagn_setup_deferred_work,
+	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
+	.nic_config = iwl2000_nic_config,
+	.eeprom_ops = {
+		.regulatory_bands = {
+			EEPROM_REG_BAND_1_CHANNELS,
+			EEPROM_REG_BAND_2_CHANNELS,
+			EEPROM_REG_BAND_3_CHANNELS,
+			EEPROM_REG_BAND_4_CHANNELS,
+			EEPROM_REG_BAND_5_CHANNELS,
+			EEPROM_6000_REG_BAND_24_HT40_CHANNELS,
+			EEPROM_REGULATORY_BAND_NO_HT40,
+		},
+		.update_enhanced_txpower = iwlcore_eeprom_enhanced_txpower,
+	},
+	.temperature = iwlagn_temperature,
+};
+
+static struct iwl_lib_ops iwl2030_lib = {
+	.set_hw_params = iwl2000_hw_set_hw_params,
+	.rx_handler_setup = iwlagn_bt_rx_handler_setup,
 	.setup_deferred_work = iwlagn_bt_setup_deferred_work,
 	.cancel_deferred_work = iwlagn_bt_cancel_deferred_work,
 	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
@@ -193,7 +214,7 @@ static const struct iwl_ops iwl2000_ops = {
 };
 
 static const struct iwl_ops iwl2030_ops = {
-	.lib = &iwl2000_lib,
+	.lib = &iwl2030_lib,
 	.utils = &iwlagn_hcmd_utils,
 };
 
@@ -203,7 +224,7 @@ static const struct iwl_ops iwl105_ops = {
 };
 
 static const struct iwl_ops iwl135_ops = {
-	.lib = &iwl2000_lib,
+	.lib = &iwl2030_lib,
 	.utils = &iwlagn_hcmd_utils,
 };
 
-- 
1.7.0.4

