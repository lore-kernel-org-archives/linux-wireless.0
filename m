Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:19787 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760Ab1KYUIT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Nov 2011 15:08:19 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 4/7] iwlagn: allow up to uCode API 6 for 6000 devices
Date: Fri, 25 Nov 2011 11:11:45 -0800
Message-Id: <1322248308-5113-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111125_210824_596899_6D7F070E)
In-Reply-To: <1322248308-5113-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1322248308-5113-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since the uCode hasn't been released (yet?),
warn only if using older than API 4, but load
anything up to API 6.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 09f0378..617ad1c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -46,11 +46,12 @@
 #include "iwl-cfg.h"
 
 /* Highest firmware API version supported */
-#define IWL6000_UCODE_API_MAX 4
+#define IWL6000_UCODE_API_MAX 6
 #define IWL6050_UCODE_API_MAX 5
 #define IWL6000G2_UCODE_API_MAX 6
 
 /* Oldest version we won't warn about */
+#define IWL6000_UCODE_API_OK 4
 #define IWL6000G2_UCODE_API_OK 5
 
 /* Lowest firmware API version supported */
@@ -457,6 +458,7 @@ struct iwl_cfg iwl130_bg_cfg = {
 #define IWL_DEVICE_6000i					\
 	.fw_name_pre = IWL6000_FW_PRE,				\
 	.ucode_api_max = IWL6000_UCODE_API_MAX,			\
+	.ucode_api_ok = IWL6000_UCODE_API_OK,			\
 	.ucode_api_min = IWL6000_UCODE_API_MIN,			\
 	.valid_tx_ant = ANT_BC,		/* .cfg overwrite */	\
 	.valid_rx_ant = ANT_BC,		/* .cfg overwrite */	\
@@ -535,6 +537,7 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.name = "Intel(R) Centrino(R) Ultimate-N 6300 AGN",
 	.fw_name_pre = IWL6000_FW_PRE,
 	.ucode_api_max = IWL6000_UCODE_API_MAX,
+	.ucode_api_ok = IWL6000_UCODE_API_OK,
 	.ucode_api_min = IWL6000_UCODE_API_MIN,
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6000_TX_POWER_VERSION,
@@ -544,7 +547,7 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.led_mode = IWL_LED_BLINK,
 };
 
-MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_OK));
 MODULE_FIRMWARE(IWL6050_MODULE_FIRMWARE(IWL6050_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL6005_MODULE_FIRMWARE(IWL6000G2_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL6030_MODULE_FIRMWARE(IWL6000G2_UCODE_API_MAX));
-- 
1.7.0.4

