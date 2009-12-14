Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:13894 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932763AbZLNWMR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 17:12:17 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>, stable@kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/6] iwlwifi: fix more eeprom endian bugs
Date: Mon, 14 Dec 2009 14:12:09 -0800
Message-Id: <1260828733-22726-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1260828733-22726-1-git-send-email-reinette.chatre@intel.com>
References: <1260828733-22726-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

I've also for a long time had a problem with the
temperature calculation code, which I had fixed
by byte-swapping the values, and now it turns out
that was the correct fix after all.

Also, any use of iwl_eeprom_query_addr() that is
for more than a u8 must be cast to little endian,
and some structs as well.

Fix all this. Again, no real impact on platforms
that already are little endian.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: stable@kernel.org
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
This fix is needed in 2.6.32 but does not apply in this form.
A rebased version will be provided after this
patch has been merged into 2.6.33.

 drivers/net/wireless/iwlwifi/iwl-4965.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h |   14 +++++++++-----
 drivers/net/wireless/iwlwifi/iwl-5000.c    |    7 ++++---
 drivers/net/wireless/iwlwifi/iwl-eeprom.h  |    4 ++--
 4 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 386513b..484c5fd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1204,7 +1204,7 @@ static int iwl4965_fill_txpower_tbl(struct iwl_priv *priv, u8 band, u16 channel,
 	iwl4965_interpolate_chan(priv, channel, &ch_eeprom_info);
 
 	/* calculate tx gain adjustment based on power supply voltage */
-	voltage = priv->calib_info->voltage;
+	voltage = le16_to_cpu(priv->calib_info->voltage);
 	init_voltage = (s32)le32_to_cpu(priv->card_alive_init.voltage);
 	voltage_compensation =
 	    iwl4965_get_voltage_compensation(voltage, init_voltage);
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
index 4ef6804..bc056e9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
@@ -92,11 +92,15 @@
 
 static inline s32 iwl_temp_calib_to_offset(struct iwl_priv *priv)
 {
-	u16 *temp_calib = (u16 *)iwl_eeprom_query_addr(priv,
-						       EEPROM_5000_TEMPERATURE);
-	/* offset =  temperature -  voltage / coef */
-	s32 offset = (s32)(temp_calib[0] - temp_calib[1] / IWL_5150_VOLTAGE_TO_TEMPERATURE_COEFF);
-	return offset;
+	u16 temperature, voltage;
+	__le16 *temp_calib =
+		(__le16 *)iwl_eeprom_query_addr(priv, EEPROM_5000_TEMPERATURE);
+
+	temperature = le16_to_cpu(temp_calib[0]);
+	voltage = le16_to_cpu(temp_calib[1]);
+
+	/* offset = temp - volt / coeff */
+	return (s32)(temperature - voltage / IWL_5150_VOLTAGE_TO_TEMPERATURE_COEFF);
 }
 
 /* Fixed (non-configurable) rx data from phy */
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index e2f8615..33a5866 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -333,14 +333,15 @@ static void iwl5000_set_ct_threshold(struct iwl_priv *priv)
 static int iwl5000_set_Xtal_calib(struct iwl_priv *priv)
 {
 	struct iwl_calib_xtal_freq_cmd cmd;
-	u16 *xtal_calib = (u16 *)iwl_eeprom_query_addr(priv, EEPROM_5000_XTAL);
+	__le16 *xtal_calib =
+		(__le16 *)iwl_eeprom_query_addr(priv, EEPROM_5000_XTAL);
 
 	cmd.hdr.op_code = IWL_PHY_CALIBRATE_CRYSTAL_FRQ_CMD;
 	cmd.hdr.first_group = 0;
 	cmd.hdr.groups_num = 1;
 	cmd.hdr.data_valid = 1;
-	cmd.cap_pin1 = (u8)xtal_calib[0];
-	cmd.cap_pin2 = (u8)xtal_calib[1];
+	cmd.cap_pin1 = le16_to_cpu(xtal_calib[0]);
+	cmd.cap_pin2 = le16_to_cpu(xtal_calib[1]);
 	return iwl_calib_set(&priv->calib_results[IWL_CALIB_XTAL],
 			     (u8 *)&cmd, sizeof(cmd));
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 5cd2b66..0cd9c02 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -137,7 +137,7 @@ struct iwl_eeprom_channel {
  *
  */
 struct iwl_eeprom_enhanced_txpwr {
-	u16 common;
+	__le16 common;
 	s8 chain_a_max;
 	s8 chain_b_max;
 	s8 chain_c_max;
@@ -360,7 +360,7 @@ struct iwl_eeprom_calib_subband_info {
 struct iwl_eeprom_calib_info {
 	u8 saturation_power24;	/* half-dBm (e.g. "34" = 17 dBm) */
 	u8 saturation_power52;	/* half-dBm */
-	s16 voltage;		/* signed */
+	__le16 voltage;		/* signed */
 	struct iwl_eeprom_calib_subband_info
 		band_info[EEPROM_TX_POWER_BANDS];
 } __attribute__ ((packed));
-- 
1.5.6.3

