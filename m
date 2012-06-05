Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56946 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756895Ab2FENyi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 09:54:38 -0400
Message-ID: <1338904477.4514.46.camel@jlt3.sipsolutions.net> (sfid-20120605_155441_808766_F14DC0C8)
Subject: [PATCH 3.5] iwlwifi: use correct supported firmware for 6035 and
 6000g2
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 05 Jun 2012 15:54:37 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

My patch

   iwlwifi: use correct released ucode version

did not correctly report supported firmware
for the 6035 device. This patch fixes it. The
minimum supported firmware version for 6035
is v6.

Also correct the minimum supported firmware
version for the 6000g2 series of devices.

Cc: stable@kernel.org
Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 19f7ee8..055a96d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -35,17 +35,20 @@
 #define IWL6000_UCODE_API_MAX 6
 #define IWL6050_UCODE_API_MAX 5
 #define IWL6000G2_UCODE_API_MAX 6
+#define IWL6035_UCODE_API_MAX 6
 
 /* Oldest version we won't warn about */
 #define IWL6000_UCODE_API_OK 4
 #define IWL6000G2_UCODE_API_OK 5
 #define IWL6050_UCODE_API_OK 5
 #define IWL6000G2B_UCODE_API_OK 6
+#define IWL6035_UCODE_API_OK 6
 
 /* Lowest firmware API version supported */
 #define IWL6000_UCODE_API_MIN 4
 #define IWL6050_UCODE_API_MIN 4
-#define IWL6000G2_UCODE_API_MIN 4
+#define IWL6000G2_UCODE_API_MIN 5
+#define IWL6035_UCODE_API_MIN 6
 
 /* EEPROM versions */
 #define EEPROM_6000_TX_POWER_VERSION	(4)
@@ -227,9 +230,27 @@ const struct iwl_cfg iwl6030_2bg_cfg = {
 	IWL_DEVICE_6030,
 };
 
+#define IWL_DEVICE_6035						\
+	.fw_name_pre = IWL6030_FW_PRE,				\
+	.ucode_api_max = IWL6035_UCODE_API_MAX,			\
+	.ucode_api_ok = IWL6035_UCODE_API_OK,			\
+	.ucode_api_min = IWL6035_UCODE_API_MIN,			\
+	.device_family = IWL_DEVICE_FAMILY_6030,		\
+	.max_inst_size = IWL60_RTC_INST_SIZE,			\
+	.max_data_size = IWL60_RTC_DATA_SIZE,			\
+	.eeprom_ver = EEPROM_6030_EEPROM_VERSION,		\
+	.eeprom_calib_ver = EEPROM_6030_TX_POWER_VERSION,	\
+	.base_params = &iwl6000_g2_base_params,			\
+	.bt_params = &iwl6000_bt_params,			\
+	.eeprom_params = &iwl6000_eeprom_params,		\
+	.need_temp_offset_calib = true,				\
+	.led_mode = IWL_LED_RF_STATE,				\
+	.adv_pm = true						\
+
+
 const struct iwl_cfg iwl6035_2agn_cfg = {
 	.name = "Intel(R) Centrino(R) Advanced-N 6235 AGN",
-	IWL_DEVICE_6030,
+	IWL_DEVICE_6035,
 	.ht_params = &iwl6000_ht_params,
 };
 
-- 
1.7.10



