Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58128 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757952Ab3GZI3i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:29:38 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 14/30] iwlwifi: mvm: remove the default calibration values for 7000
Date: Fri, 26 Jul 2013 10:28:31 +0200
Message-Id: <1374827327-3464-15-git-send-email-johannes@sipsolutions.net> (sfid-20130726_103018_957456_30D3D803)
In-Reply-To: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
References: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The fw is now able to run TX_IQ_SKEW and RX_IQ_SKEW by
itself. No need for default values any more.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Dor Shaish <dor.shaish@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw.c | 55 -----------------------------------
 1 file changed, 55 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index cd7c003..c76299a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -78,22 +78,6 @@
 
 #define UCODE_VALID_OK	cpu_to_le32(0x1)
 
-/* Default calibration values for WkP - set to INIT image w/o running */
-static const u8 wkp_calib_values_rx_iq_skew[] = { 0x00, 0x00, 0x01, 0x00 };
-static const u8 wkp_calib_values_tx_iq_skew[] = { 0x01, 0x00, 0x00, 0x00 };
-
-struct iwl_calib_default_data {
-	u16 size;
-	void *data;
-};
-
-#define CALIB_SIZE_N_DATA(_buf) {.size = sizeof(_buf), .data = &_buf}
-
-static const struct iwl_calib_default_data wkp_calib_default_data[12] = {
-	[9] = CALIB_SIZE_N_DATA(wkp_calib_values_tx_iq_skew),
-	[11] = CALIB_SIZE_N_DATA(wkp_calib_values_rx_iq_skew),
-};
-
 struct iwl_mvm_alive_data {
 	bool valid;
 	u32 scd_base_addr;
@@ -248,40 +232,6 @@ static int iwl_send_phy_cfg_cmd(struct iwl_mvm *mvm)
 				    sizeof(phy_cfg_cmd), &phy_cfg_cmd);
 }
 
-static int iwl_set_default_calibrations(struct iwl_mvm *mvm)
-{
-	u8 cmd_raw[16]; /* holds the variable size commands */
-	struct iwl_set_calib_default_cmd *cmd =
-		(struct iwl_set_calib_default_cmd *)cmd_raw;
-	int ret, i;
-
-	/* Setting default values for calibrations we don't run */
-	for (i = 0; i < ARRAY_SIZE(wkp_calib_default_data); i++) {
-		u16 cmd_len;
-
-		if (wkp_calib_default_data[i].size == 0)
-			continue;
-
-		memset(cmd_raw, 0, sizeof(cmd_raw));
-		cmd_len = wkp_calib_default_data[i].size + sizeof(cmd);
-		cmd->calib_index = cpu_to_le16(i);
-		cmd->length = cpu_to_le16(wkp_calib_default_data[i].size);
-		if (WARN_ONCE(cmd_len > sizeof(cmd_raw),
-			      "Need to enlarge cmd_raw to %d\n", cmd_len))
-			break;
-		memcpy(cmd->data, wkp_calib_default_data[i].data,
-		       wkp_calib_default_data[i].size);
-		ret = iwl_mvm_send_cmd_pdu(mvm, SET_CALIB_DEFAULT_CMD, 0,
-					   sizeof(*cmd) +
-					   wkp_calib_default_data[i].size,
-					   cmd);
-		if (ret)
-			return ret;
-	}
-
-	return 0;
-}
-
 int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 {
 	struct iwl_notification_wait calib_wait;
@@ -342,11 +292,6 @@ int iwl_run_init_mvm_ucode(struct iwl_mvm *mvm, bool read_nvm)
 	if (ret)
 		goto error;
 
-	/* need to set default values */
-	ret = iwl_set_default_calibrations(mvm);
-	if (ret)
-		goto error;
-
 	/*
 	 * Send phy configurations command to init uCode
 	 * to start the 16.0 uCode init image internal calibrations.
-- 
1.8.0

