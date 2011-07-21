Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:47950 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016Ab1GUP0q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 11:26:46 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/25] iwlagn: radio sensor offset in le16 format
Date: Thu, 21 Jul 2011 07:50:10 -0700
Message-Id: <1311259828-8415-8-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110721_172729_089886_0A70C633)
In-Reply-To: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For temperature offset calibration, send radio sensor offset in le16 format

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-commands.h  |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index f5f5f06..667cfb7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -167,12 +167,12 @@ static int iwlagn_set_temperature_offset_calib(struct iwl_priv *priv)
 
 	memset(&cmd, 0, sizeof(cmd));
 	iwl_set_calib_hdr(&cmd.hdr, IWL_PHY_CALIBRATE_TEMP_OFFSET_CMD);
-	cmd.radio_sensor_offset = le16_to_cpu(offset_calib[1]);
+	memcpy(&cmd.radio_sensor_offset, offset_calib, sizeof(offset_calib));
 	if (!(cmd.radio_sensor_offset))
 		cmd.radio_sensor_offset = DEFAULT_RADIO_SENSOR_OFFSET;
 
 	IWL_DEBUG_CALIB(priv, "Radio sensor offset: %d\n",
-			cmd.radio_sensor_offset);
+			le16_to_cpu(cmd.radio_sensor_offset));
 	return iwl_calib_set(&priv->calib_results[IWL_CALIB_TEMP_OFFSET],
 			     (u8 *)&cmd, sizeof(cmd));
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index d7f20c8..80174d1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -3237,11 +3237,11 @@ struct iwl_calib_xtal_freq_cmd {
 	u8 pad[2];
 } __packed;
 
-#define DEFAULT_RADIO_SENSOR_OFFSET    2700
+#define DEFAULT_RADIO_SENSOR_OFFSET    cpu_to_le16(2700)
 struct iwl_calib_temperature_offset_cmd {
 	struct iwl_calib_hdr hdr;
-	s16 radio_sensor_offset;
-	s16 reserved;
+	__le16 radio_sensor_offset;
+	__le16 reserved;
 } __packed;
 
 /* IWL_PHY_CALIBRATE_CHAIN_NOISE_RESET_CMD */
-- 
1.7.0.4

