Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:51549 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaETKh0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 06:37:26 -0400
Received: by mail-wi0-f179.google.com with SMTP id bs8so666438wib.12
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2014 03:37:24 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Avri Altman <avri.altman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] iwlwifi: mvm: don't filter out the first beacon
Date: Tue, 20 May 2014 13:37:18 +0300
Message-Id: <1400582238-18601-1-git-send-email-egrumbach@gmail.com> (sfid-20140520_123729_514530_4981B18D)
In-Reply-To: <537B2FF7.5070908@gmail.com>
References: <537B2FF7.5070908@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avri Altman <avri.altman@intel.com>

Enabling beacon filtering should be done only after a beacon
has been received. Doing that too early will cause
disconnections.
This has already been fixed, but the fix didn't take care
about the case where the beacon is received after the
association, it waited only for association which is not
enough.

Signed-off-by: Avri Altman <avri.altman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 13 +++---
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  5 ---
 drivers/net/wireless/iwlwifi/mvm/power.c    | 63 +++++++++--------------------
 3 files changed, 27 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index b41dc84..712d460 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1350,9 +1350,12 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 		IWL_DEBUG_MAC80211(mvm, "cqm info_changed");
 		/* reset cqm events tracking */
 		mvmvif->bf_data.last_cqm_event = 0;
-		ret = iwl_mvm_update_beacon_filter(mvm, vif, false, CMD_SYNC);
-		if (ret)
-			IWL_ERR(mvm, "failed to update CQM thresholds\n");
+		if (mvmvif->bf_data.bf_enabled) {
+			ret = iwl_mvm_enable_beacon_filter(mvm, vif, CMD_SYNC);
+			if (ret)
+				IWL_ERR(mvm,
+					"failed to update CQM thresholds\n");
+		}
 	}
 
 	if (changes & BSS_CHANGED_ARP_FILTER) {
@@ -1708,9 +1711,7 @@ static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 	} else if (old_state == IEEE80211_STA_ASSOC &&
 		   new_state == IEEE80211_STA_AUTHORIZED) {
 		/* enable beacon filtering */
-		if (vif->bss_conf.dtim_period)
-			WARN_ON(iwl_mvm_enable_beacon_filter(mvm, vif,
-							     CMD_SYNC));
+		WARN_ON(iwl_mvm_enable_beacon_filter(mvm, vif, CMD_SYNC));
 		ret = 0;
 	} else if (old_state == IEEE80211_STA_AUTHORIZED &&
 		   new_state == IEEE80211_STA_ASSOC) {
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index f1ec098..f8c376a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -971,11 +971,6 @@ int iwl_mvm_disable_beacon_filter(struct iwl_mvm *mvm,
 				  u32 flags);
 int iwl_mvm_update_beacon_abort(struct iwl_mvm *mvm,
 				struct ieee80211_vif *vif, bool enable);
-int iwl_mvm_update_beacon_filter(struct iwl_mvm *mvm,
-				 struct ieee80211_vif *vif,
-				 bool force,
-				 u32 flags);
-
 /* SMPS */
 void iwl_mvm_update_smps(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 				enum iwl_mvm_smps_type_request req_type,
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index 6b636ea..3634237 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -123,28 +123,6 @@ void iwl_mvm_beacon_filter_set_cqm_params(struct iwl_mvm *mvm,
 	cmd->ba_enable_beacon_abort = cpu_to_le32(mvmvif->bf_data.ba_enabled);
 }
 
-int iwl_mvm_update_beacon_abort(struct iwl_mvm *mvm,
-				struct ieee80211_vif *vif, bool enable)
-{
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	struct iwl_beacon_filter_cmd cmd = {
-		IWL_BF_CMD_CONFIG_DEFAULTS,
-		.bf_enable_beacon_filter = cpu_to_le32(1),
-		.ba_enable_beacon_abort = cpu_to_le32(enable),
-	};
-
-	if (!mvmvif->bf_data.bf_enabled)
-		return 0;
-
-	if (mvm->cur_ucode == IWL_UCODE_WOWLAN)
-		cmd.ba_escape_timer = cpu_to_le32(IWL_BA_ESCAPE_TIMER_D3);
-
-	mvmvif->bf_data.ba_enabled = enable;
-	iwl_mvm_beacon_filter_set_cqm_params(mvm, vif, &cmd);
-	iwl_mvm_beacon_filter_debugfs_parameters(vif, &cmd);
-	return iwl_mvm_beacon_filter_send_cmd(mvm, &cmd, CMD_SYNC);
-}
-
 static void iwl_mvm_power_log(struct iwl_mvm *mvm,
 			      struct iwl_mac_power_cmd *cmd)
 {
@@ -790,7 +768,7 @@ static int _iwl_mvm_enable_beacon_filter(struct iwl_mvm *mvm,
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	int ret;
 
-	if (mvmvif != mvm->bf_allowed_vif ||
+	if (mvmvif != mvm->bf_allowed_vif || !vif->bss_conf.dtim_period ||
 	    vif->type != NL80211_IFTYPE_STATION || vif->p2p)
 		return 0;
 
@@ -818,6 +796,25 @@ int iwl_mvm_enable_beacon_filter(struct iwl_mvm *mvm,
 	return _iwl_mvm_enable_beacon_filter(mvm, vif, &cmd, flags, false);
 }
 
+int iwl_mvm_update_beacon_abort(struct iwl_mvm *mvm,
+				struct ieee80211_vif *vif, bool enable)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_beacon_filter_cmd cmd = {
+		IWL_BF_CMD_CONFIG_DEFAULTS,
+		.bf_enable_beacon_filter = cpu_to_le32(1),
+	};
+
+	if (!mvmvif->bf_data.bf_enabled)
+		return 0;
+
+	if (mvm->cur_ucode == IWL_UCODE_WOWLAN)
+		cmd.ba_escape_timer = cpu_to_le32(IWL_BA_ESCAPE_TIMER_D3);
+
+	mvmvif->bf_data.ba_enabled = enable;
+	return _iwl_mvm_enable_beacon_filter(mvm, vif, &cmd, 0, false);
+}
+
 int iwl_mvm_disable_beacon_filter(struct iwl_mvm *mvm,
 				  struct ieee80211_vif *vif,
 				  u32 flags)
@@ -895,26 +892,6 @@ int iwl_mvm_update_d0i3_power_mode(struct iwl_mvm *mvm,
 	return ret;
 }
 
-int iwl_mvm_update_beacon_filter(struct iwl_mvm *mvm,
-				 struct ieee80211_vif *vif,
-				 bool force,
-				 u32 flags)
-{
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-
-	if (mvmvif != mvm->bf_allowed_vif)
-		return 0;
-
-	if (!mvmvif->bf_data.bf_enabled) {
-		/* disable beacon filtering explicitly if force is true */
-		if (force)
-			return iwl_mvm_disable_beacon_filter(mvm, vif, flags);
-		return 0;
-	}
-
-	return iwl_mvm_enable_beacon_filter(mvm, vif, flags);
-}
-
 int iwl_power_legacy_set_cam_mode(struct iwl_mvm *mvm)
 {
 	struct iwl_powertable_cmd cmd = {
-- 
1.8.3.2

