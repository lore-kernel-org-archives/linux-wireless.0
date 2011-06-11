Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:1999 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758602Ab1FKOzn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jun 2011 10:55:43 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 14/18] iwlagn: generic temperature location in EEPROM
Date: Sat, 11 Jun 2011 07:25:48 -0700
Message-Id: <1307802352-16398-15-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110611_165553_172317_D116185C)
In-Reply-To: <1307802352-16398-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1307802352-16398-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Temperature location in EEPROM is generic to all devices

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h    |    6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
index 05ad476..f9630a3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
@@ -75,7 +75,7 @@ static inline s32 iwl_temp_calib_to_offset(struct iwl_priv *priv)
 {
 	u16 temperature, voltage;
 	__le16 *temp_calib =
-		(__le16 *)iwl_eeprom_query_addr(priv, EEPROM_5000_TEMPERATURE);
+		(__le16 *)iwl_eeprom_query_addr(priv, EEPROM_TEMPERATURE);
 
 	temperature = le16_to_cpu(temp_calib[0]);
 	voltage = le16_to_cpu(temp_calib[1]);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index e916157..4be7a0f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -197,7 +197,7 @@ static int iwlagn_set_temperature_offset_calib(struct iwl_priv *priv)
 {
 	struct iwl_calib_temperature_offset_cmd cmd;
 	__le16 *offset_calib =
-		(__le16 *)iwl_eeprom_query_addr(priv, EEPROM_5000_TEMPERATURE);
+		(__le16 *)iwl_eeprom_query_addr(priv, EEPROM_TEMPERATURE);
 	cmd.hdr.op_code = IWL_PHY_CALIBRATE_TEMP_OFFSET_CMD;
 	cmd.hdr.first_group = 0;
 	cmd.hdr.groups_num = 1;
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 2d70053..3dcb0a0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -166,12 +166,12 @@ struct iwl_eeprom_enhanced_txpwr {
 #define EEPROM_5000_TX_POWER_VERSION    (4)
 #define EEPROM_5000_EEPROM_VERSION	(0x11A)
 
-/* 5000 and up calibration */
+/* calibration */
 #define EEPROM_CALIB_ALL	(INDIRECT_ADDRESS | INDIRECT_CALIBRATION)
 #define EEPROM_XTAL		((2*0x128) | EEPROM_CALIB_ALL)
 
-/* 5000 temperature */
-#define EEPROM_5000_TEMPERATURE ((2*0x12A) | EEPROM_CALIB_ALL)
+/* temperature */
+#define EEPROM_TEMPERATURE ((2*0x12A) | EEPROM_CALIB_ALL)
 
 /* agn links */
 #define EEPROM_LINK_HOST             (2*0x64)
-- 
1.7.0.4

