Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:18631 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934556Ab1IOTcM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 15:32:12 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 26/27] iwlagn: fix stack corruption for temperature offset v2
Date: Thu, 15 Sep 2011 11:46:53 -0700
Message-Id: <1316112414-6341-27-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110915_213223_394120_4F403963)
In-Reply-To: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Same stack corruption problem as temperature offset

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index b5bae38..3e40429 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -187,9 +187,9 @@ static int iwlagn_set_temperature_offset_calib_v2(struct iwl_priv *priv)
 	hdr = (struct iwl_eeprom_calib_hdr *)iwl_eeprom_query_addr(priv,
 							EEPROM_CALIB_ALL);
 	memcpy(&cmd.radio_sensor_offset_high, offset_calib_high,
-		sizeof(offset_calib_high));
+		sizeof(*offset_calib_high));
 	memcpy(&cmd.radio_sensor_offset_low, offset_calib_low,
-		sizeof(offset_calib_low));
+		sizeof(*offset_calib_low));
 	if (!(cmd.radio_sensor_offset_low)) {
 		IWL_DEBUG_CALIB(priv, "no info in EEPROM, use default\n");
 		cmd.radio_sensor_offset_low = DEFAULT_RADIO_SENSOR_OFFSET;
-- 
1.7.0.4

