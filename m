Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:57083 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751530AbbJEOhJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 10:37:09 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Oct 2015 17:36:34 +0300
Message-Id: <1444055820-27506-3-git-send-email-luca@coelho.fi> (sfid-20151005_163717_973041_7041ED20)
In-Reply-To: <1444050759.27220.15.camel@coelho.fi>
References: <1444050759.27220.15.camel@coelho.fi>
Subject: [PATCH 03/29] iwlwifi: mvm: correct skip-over-DTIM implementation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The formula used in D0i3 should also be used in D3, instead of
the hardcoded value.

Additionally, the formula is actually wrong - if the calculation
yields 0 then 1 should be used instead of disabling entirely.
Also need to add 1 since the firmware needs 3 to skip 2, etc.

To make all this clearer, centralize the calculation into a
single function.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/power.c | 74 ++++++++++++++++++++------------
 1 file changed, 46 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index 4645877..21a858d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -7,6 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2015        Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -33,6 +34,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2015        Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -306,13 +308,50 @@ static bool iwl_mvm_power_is_radar(struct ieee80211_vif *vif)
 	return radar_detect;
 }
 
+static void iwl_mvm_power_config_skip_dtim(struct iwl_mvm *mvm,
+					   struct ieee80211_vif *vif,
+					   struct iwl_mac_power_cmd *cmd,
+					   bool host_awake)
+{
+	int dtimper = vif->bss_conf.dtim_period ?: 1;
+	int skip;
+
+	/* disable, in case we're supposed to override */
+	cmd->skip_dtim_periods = 0;
+	cmd->flags &= ~cpu_to_le16(POWER_FLAGS_SKIP_OVER_DTIM_MSK);
+
+	if (iwl_mvm_power_is_radar(vif))
+		return;
+
+	if (dtimper >= 10)
+		return;
+
+	/* TODO: check that multicast wake lock is off */
+
+	if (host_awake) {
+		if (iwlmvm_mod_params.power_scheme != IWL_POWER_SCHEME_LP)
+			return;
+		skip = 2;
+	} else {
+		int dtimper_tu = dtimper * vif->bss_conf.beacon_int;
+
+		if (WARN_ON(!dtimper_tu))
+			return;
+		/* configure skip over dtim up to 306TU - 314 msec */
+		skip = max_t(u8, 1, 306 / dtimper_tu);
+	}
+
+	/* the firmware really expects "look at every X DTIMs", so add 1 */
+	cmd->skip_dtim_periods = 1 + skip;
+	cmd->flags |= cpu_to_le16(POWER_FLAGS_SKIP_OVER_DTIM_MSK);
+}
+
 static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 				    struct ieee80211_vif *vif,
 				    struct iwl_mac_power_cmd *cmd)
 {
 	int dtimper, bi;
 	int keep_alive;
-	bool radar_detect = false;
 	struct iwl_mvm_vif *mvmvif __maybe_unused =
 		iwl_mvm_vif_from_mac80211(vif);
 
@@ -350,16 +389,8 @@ static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 		cmd->lprx_rssi_threshold = POWER_LPRX_RSSI_THRESHOLD;
 	}
 
-	/* Check if radar detection is required on current channel */
-	radar_detect = iwl_mvm_power_is_radar(vif);
-
-	/* Check skip over DTIM conditions */
-	if (!radar_detect && (dtimper < 10) &&
-	    (iwlmvm_mod_params.power_scheme == IWL_POWER_SCHEME_LP ||
-	     mvm->cur_ucode == IWL_UCODE_WOWLAN)) {
-		cmd->flags |= cpu_to_le16(POWER_FLAGS_SKIP_OVER_DTIM_MSK);
-		cmd->skip_dtim_periods = 3;
-	}
+	iwl_mvm_power_config_skip_dtim(mvm, vif, cmd,
+				       mvm->cur_ucode != IWL_UCODE_WOWLAN);
 
 	if (mvm->cur_ucode != IWL_UCODE_WOWLAN) {
 		cmd->rx_data_timeout =
@@ -964,24 +995,11 @@ int iwl_mvm_update_d0i3_power_mode(struct iwl_mvm *mvm,
 		return 0;
 
 	iwl_mvm_power_build_cmd(mvm, vif, &cmd);
-	if (enable) {
-		/* configure skip over dtim up to 306TU - 314 msec */
-		int dtimper = vif->bss_conf.dtim_period ?: 1;
-		int dtimper_tu = dtimper * vif->bss_conf.beacon_int;
-		bool radar_detect = iwl_mvm_power_is_radar(vif);
 
-		if (WARN_ON(!dtimper_tu))
-			return 0;
-
-		/* Check skip over DTIM conditions */
-		/* TODO: check that multicast wake lock is off */
-		if (!radar_detect && (dtimper < 10)) {
-			cmd.skip_dtim_periods = 306 / dtimper_tu;
-			if (cmd.skip_dtim_periods)
-				cmd.flags |= cpu_to_le16(
-					POWER_FLAGS_SKIP_OVER_DTIM_MSK);
-		}
-	}
+	/* when enabling D0i3, override the skip-over-dtim configuration */
+	if (enable)
+		iwl_mvm_power_config_skip_dtim(mvm, vif, &cmd, false);
+
 	iwl_mvm_power_log(mvm, &cmd);
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	memcpy(&mvmvif->mac_pwr_cmd, &cmd, sizeof(cmd));
-- 
2.5.3

