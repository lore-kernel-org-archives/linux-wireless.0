Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:18631 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934481Ab1IOTcL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 15:32:11 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 24/27] iwlagn: use iwl_eeprom_calib_hdr structure
Date: Thu, 15 Sep 2011 11:46:51 -0700
Message-Id: <1316112414-6341-25-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110915_213236_953333_8FEFBA09)
In-Reply-To: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For retrieve calibration hdr related information, instead of using structure in
one place and #define in other place, unify the method to use data structure.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c   |    6 +-----
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |    9 +++++----
 drivers/net/wireless/iwlwifi/iwl-eeprom.h    |    7 ++++++-
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 1301887..e8b324c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -96,11 +96,7 @@ void iwlagn_temperature(struct iwl_priv *priv)
 
 u16 iwlagn_eeprom_calib_version(struct iwl_priv *priv)
 {
-	struct iwl_eeprom_calib_hdr {
-		u8 version;
-		u8 pa_type;
-		u16 voltage;
-	} *hdr;
+	struct iwl_eeprom_calib_hdr *hdr;
 
 	hdr = (struct iwl_eeprom_calib_hdr *)iwl_eeprom_query_addr(priv,
 							EEPROM_CALIB_ALL);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 564d1fc..5f8d7b6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -185,11 +185,12 @@ static int iwlagn_set_temperature_offset_calib_v2(struct iwl_priv *priv)
 				     EEPROM_KELVIN_TEMPERATURE);
 	__le16 *offset_calib_low =
 		(__le16 *)iwl_eeprom_query_addr(priv, EEPROM_RAW_TEMPERATURE);
-	__le16 *voltage_reading =
-		(__le16 *)iwl_eeprom_query_addr(priv, EEPROM_VOLTAGE_READING);
+	struct iwl_eeprom_calib_hdr *hdr;
 
 	memset(&cmd, 0, sizeof(cmd));
 	iwl_set_calib_hdr(&cmd.hdr, IWL_PHY_CALIBRATE_TEMP_OFFSET_CMD);
+	hdr = (struct iwl_eeprom_calib_hdr *)iwl_eeprom_query_addr(priv,
+							EEPROM_CALIB_ALL);
 	memcpy(&cmd.radio_sensor_offset_high, offset_calib_high,
 		sizeof(offset_calib_high));
 	memcpy(&cmd.radio_sensor_offset_low, offset_calib_low,
@@ -199,8 +200,8 @@ static int iwlagn_set_temperature_offset_calib_v2(struct iwl_priv *priv)
 		cmd.radio_sensor_offset_low = DEFAULT_RADIO_SENSOR_OFFSET;
 		cmd.radio_sensor_offset_high = DEFAULT_RADIO_SENSOR_OFFSET;
 	}
-	memcpy(&cmd.burntVoltageRef, voltage_reading,
-		sizeof(voltage_reading));
+	memcpy(&cmd.burntVoltageRef, &hdr->voltage,
+		sizeof(hdr->voltage));
 
 	IWL_DEBUG_CALIB(priv, "Radio sensor offset high: %d\n",
 			le16_to_cpu(cmd.radio_sensor_offset_high));
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 325753e..c94747e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -163,11 +163,16 @@ struct iwl_eeprom_enhanced_txpwr {
 } __packed;
 
 /* calibration */
+struct iwl_eeprom_calib_hdr {
+	u8 version;
+	u8 pa_type;
+	__le16 voltage;
+} __packed;
+
 #define EEPROM_CALIB_ALL	(INDIRECT_ADDRESS | INDIRECT_CALIBRATION)
 #define EEPROM_XTAL		((2*0x128) | EEPROM_CALIB_ALL)
 
 /* temperature */
-#define EEPROM_VOLTAGE_READING		((2*0x1) | EEPROM_CALIB_ALL)
 #define EEPROM_KELVIN_TEMPERATURE	((2*0x12A) | EEPROM_CALIB_ALL)
 #define EEPROM_RAW_TEMPERATURE		((2*0x12B) | EEPROM_CALIB_ALL)
 
-- 
1.7.0.4

