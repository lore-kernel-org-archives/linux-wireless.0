Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38702 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934552Ab1IOTcM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 15:32:12 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 23/27] iwlagn: add support for v2 of temperature offset calibration
Date: Thu, 15 Sep 2011 11:46:50 -0700
Message-Id: <1316112414-6341-24-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110915_213219_459857_84D15C64)
In-Reply-To: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For 2000 series of NICs, version 2 of temperature offset calibration
should be used.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-2000.c      |    4 ++
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h   |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |   45 ++++++++++++++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-commands.h  |    8 ++++
 drivers/net/wireless/iwlwifi/iwl-core.h      |    2 +
 drivers/net/wireless/iwlwifi/iwl-eeprom.h    |    5 ++-
 6 files changed, 62 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 5a87010..db88958 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -264,6 +264,7 @@ static struct iwl_bt_params iwl2030_bt_params = {
 	.base_params = &iwl2000_base_params,			\
 	.need_dc_calib = true,					\
 	.need_temp_offset_calib = true,				\
+	.temp_offset_v2 = true,					\
 	.led_mode = IWL_LED_RF_STATE,				\
 	.iq_invert = true					\
 
@@ -296,6 +297,7 @@ struct iwl_cfg iwl2000_2bgn_d_cfg = {
 	.bt_params = &iwl2030_bt_params,			\
 	.need_dc_calib = true,					\
 	.need_temp_offset_calib = true,				\
+	.temp_offset_v2 = true,					\
 	.led_mode = IWL_LED_RF_STATE,				\
 	.adv_pm = true,						\
 	.iq_invert = true					\
@@ -322,6 +324,7 @@ struct iwl_cfg iwl2030_2bg_cfg = {
 	.base_params = &iwl2000_base_params,			\
 	.need_dc_calib = true,					\
 	.need_temp_offset_calib = true,				\
+	.temp_offset_v2 = true,					\
 	.led_mode = IWL_LED_RF_STATE,				\
 	.adv_pm = true,						\
 	.rx_with_siso_diversity = true,				\
@@ -350,6 +353,7 @@ struct iwl_cfg iwl105_bgn_cfg = {
 	.bt_params = &iwl2030_bt_params,			\
 	.need_dc_calib = true,					\
 	.need_temp_offset_calib = true,				\
+	.temp_offset_v2 = true,					\
 	.led_mode = IWL_LED_RF_STATE,				\
 	.adv_pm = true,						\
 	.rx_with_siso_diversity = true,				\
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
index f9630a3..c013598 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
@@ -74,8 +74,8 @@
 static inline s32 iwl_temp_calib_to_offset(struct iwl_priv *priv)
 {
 	u16 temperature, voltage;
-	__le16 *temp_calib =
-		(__le16 *)iwl_eeprom_query_addr(priv, EEPROM_TEMPERATURE);
+	__le16 *temp_calib = (__le16 *)iwl_eeprom_query_addr(priv,
+				EEPROM_KELVIN_TEMPERATURE);
 
 	temperature = le16_to_cpu(temp_calib[0]);
 	voltage = le16_to_cpu(temp_calib[1]);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index ea31d76..564d1fc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -164,7 +164,7 @@ static int iwlagn_set_temperature_offset_calib(struct iwl_priv *priv)
 {
 	struct iwl_calib_temperature_offset_cmd cmd;
 	__le16 *offset_calib =
-		(__le16 *)iwl_eeprom_query_addr(priv, EEPROM_TEMPERATURE);
+		(__le16 *)iwl_eeprom_query_addr(priv, EEPROM_RAW_TEMPERATURE);
 
 	memset(&cmd, 0, sizeof(cmd));
 	iwl_set_calib_hdr(&cmd.hdr, IWL_PHY_CALIBRATE_TEMP_OFFSET_CMD);
@@ -178,6 +178,41 @@ static int iwlagn_set_temperature_offset_calib(struct iwl_priv *priv)
 			     (u8 *)&cmd, sizeof(cmd));
 }
 
+static int iwlagn_set_temperature_offset_calib_v2(struct iwl_priv *priv)
+{
+	struct iwl_calib_temperature_offset_v2_cmd cmd;
+	__le16 *offset_calib_high = (__le16 *)iwl_eeprom_query_addr(priv,
+				     EEPROM_KELVIN_TEMPERATURE);
+	__le16 *offset_calib_low =
+		(__le16 *)iwl_eeprom_query_addr(priv, EEPROM_RAW_TEMPERATURE);
+	__le16 *voltage_reading =
+		(__le16 *)iwl_eeprom_query_addr(priv, EEPROM_VOLTAGE_READING);
+
+	memset(&cmd, 0, sizeof(cmd));
+	iwl_set_calib_hdr(&cmd.hdr, IWL_PHY_CALIBRATE_TEMP_OFFSET_CMD);
+	memcpy(&cmd.radio_sensor_offset_high, offset_calib_high,
+		sizeof(offset_calib_high));
+	memcpy(&cmd.radio_sensor_offset_low, offset_calib_low,
+		sizeof(offset_calib_low));
+	if (!(cmd.radio_sensor_offset_low)) {
+		IWL_DEBUG_CALIB(priv, "no info in EEPROM, use default\n");
+		cmd.radio_sensor_offset_low = DEFAULT_RADIO_SENSOR_OFFSET;
+		cmd.radio_sensor_offset_high = DEFAULT_RADIO_SENSOR_OFFSET;
+	}
+	memcpy(&cmd.burntVoltageRef, voltage_reading,
+		sizeof(voltage_reading));
+
+	IWL_DEBUG_CALIB(priv, "Radio sensor offset high: %d\n",
+			le16_to_cpu(cmd.radio_sensor_offset_high));
+	IWL_DEBUG_CALIB(priv, "Radio sensor offset low: %d\n",
+			le16_to_cpu(cmd.radio_sensor_offset_low));
+	IWL_DEBUG_CALIB(priv, "Voltage Ref: %d\n",
+			le16_to_cpu(cmd.burntVoltageRef));
+
+	return iwl_calib_set(&priv->calib_results[IWL_CALIB_TEMP_OFFSET],
+			     (u8 *)&cmd, sizeof(cmd));
+}
+
 static int iwlagn_send_calib_cfg(struct iwl_priv *priv)
 {
 	struct iwl_calib_cfg_cmd calib_cfg_cmd;
@@ -263,8 +298,12 @@ int iwlagn_init_alive_start(struct iwl_priv *priv)
 	 * temperature offset calibration is only needed for runtime ucode,
 	 * so prepare the value now.
 	 */
-	if (priv->cfg->need_temp_offset_calib)
-		return iwlagn_set_temperature_offset_calib(priv);
+	if (priv->cfg->need_temp_offset_calib) {
+		if (priv->cfg->temp_offset_v2)
+			return iwlagn_set_temperature_offset_calib_v2(priv);
+		else
+			return iwlagn_set_temperature_offset_calib(priv);
+	}
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 82bfef4..64593aa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -3263,6 +3263,14 @@ struct iwl_calib_temperature_offset_cmd {
 	__le16 reserved;
 } __packed;
 
+struct iwl_calib_temperature_offset_v2_cmd {
+	struct iwl_calib_hdr hdr;
+	__le16 radio_sensor_offset_high;
+	__le16 radio_sensor_offset_low;
+	__le16 burntVoltageRef;
+	__le16 reserved;
+} __packed;
+
 /* IWL_PHY_CALIBRATE_CHAIN_NOISE_RESET_CMD */
 struct iwl_calib_chain_noise_reset_cmd {
 	struct iwl_calib_hdr hdr;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 549dc46..6d7ad45 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -193,6 +193,7 @@ struct iwl_ht_params {
  * @rx_with_siso_diversity: 1x1 device with rx antenna diversity
  * @internal_wimax_coex: internal wifi/wimax combo device
  * @iq_invert: I/Q inversion
+ * @temp_offset_v2: support v2 of temperature offset calibration
  *
  * We enable the driver to be backward compatible wrt API version. The
  * driver specifies which APIs it supports (with @ucode_api_max being the
@@ -230,6 +231,7 @@ struct iwl_cfg {
 	const bool rx_with_siso_diversity;
 	const bool internal_wimax_coex;
 	const bool iq_invert;
+	const bool temp_offset_v2;
 };
 
 /***************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index e2b5e0e..325753e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -167,7 +167,10 @@ struct iwl_eeprom_enhanced_txpwr {
 #define EEPROM_XTAL		((2*0x128) | EEPROM_CALIB_ALL)
 
 /* temperature */
-#define EEPROM_TEMPERATURE ((2*0x12A) | EEPROM_CALIB_ALL)
+#define EEPROM_VOLTAGE_READING		((2*0x1) | EEPROM_CALIB_ALL)
+#define EEPROM_KELVIN_TEMPERATURE	((2*0x12A) | EEPROM_CALIB_ALL)
+#define EEPROM_RAW_TEMPERATURE		((2*0x12B) | EEPROM_CALIB_ALL)
+
 
 /* agn links */
 #define EEPROM_LINK_HOST             (2*0x64)
-- 
1.7.0.4

