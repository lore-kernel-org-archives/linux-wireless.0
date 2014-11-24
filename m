Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:52996 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932327AbaKXOgm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:36:42 -0500
Received: by mail-wi0-f178.google.com with SMTP id hi2so5996415wib.5
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:36:41 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 65/75] iwlwifi: mvm: refactor wowlan and netdetect configuration when suspending
Date: Mon, 24 Nov 2014 16:34:41 +0200
Message-Id: <1416839691-28533-65-git-send-email-egrumbach@gmail.com> (sfid-20141124_153736_923486_800F328B)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

We need to send a WOWLAN_CONFIGURATION command also for netdetect and
configure the rfkill release trigger if needed.  To do so, refactor
the code that configures wowlan and netdetect when suspending and send
the WOWLAN_CONFIGURATION command also for net_detect.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c | 67 +++++++++++++++++++++++------------
 1 file changed, 45 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 3c66028..fe27193 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -878,6 +878,10 @@ iwl_mvm_wowlan_config(struct iwl_mvm *mvm,
 	};
 	int ret;
 
+	ret = iwl_mvm_switch_to_d3(mvm);
+	if (ret)
+		return ret;
+
 	ret = iwl_mvm_d3_reprogram(mvm, vif, ap_sta);
 	if (ret)
 		return ret;
@@ -962,6 +966,33 @@ out:
 	return ret;
 }
 
+static int
+iwl_mvm_netdetect_config(struct iwl_mvm *mvm,
+			 struct cfg80211_wowlan *wowlan,
+			 struct cfg80211_sched_scan_request *nd_config,
+			 struct ieee80211_vif *vif)
+{
+	struct iwl_wowlan_config_cmd_v3 wowlan_config_cmd = {};
+	int ret;
+
+	ret = iwl_mvm_switch_to_d3(mvm);
+	if (ret)
+		return ret;
+
+	/* rfkill release can be either for wowlan or netdetect */
+	if (wowlan->rfkill_release)
+		wowlan_config_cmd.common.wakeup_filter |=
+			cpu_to_le32(IWL_WOWLAN_WAKEUP_RF_KILL_DEASSERT);
+
+	ret = iwl_mvm_send_wowlan_config_cmd(mvm, &wowlan_config_cmd);
+	if (ret)
+		return ret;
+
+	ret = iwl_mvm_scan_offload_start(mvm, vif, nd_config, &mvm->nd_ies);
+
+	return ret;
+}
+
 static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 			     struct cfg80211_wowlan *wowlan,
 			     bool test)
@@ -970,7 +1001,6 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 	struct ieee80211_vif *vif = NULL;
 	struct iwl_mvm_vif *mvmvif = NULL;
 	struct ieee80211_sta *ap_sta = NULL;
-	struct iwl_wowlan_config_cmd_v3 wowlan_config_cmd = {};
 	struct iwl_d3_manager_config d3_cfg_cmd_data = {
 		/*
 		 * Program the minimum sleep time to 10 seconds, as many
@@ -1007,8 +1037,20 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 
 	mvmvif = iwl_mvm_vif_from_mac80211(vif);
 
-	/* if we're associated, this is wowlan */
-	if (mvmvif->ap_sta_id != IWL_MVM_STATION_COUNT) {
+	if (mvmvif->ap_sta_id == IWL_MVM_STATION_COUNT) {
+		/* if we're not associated, this must be netdetect */
+		if (!wowlan->nd_config && !mvm->nd_config) {
+			ret = 1;
+			goto out_noreset;
+		}
+
+		ret = iwl_mvm_netdetect_config(
+			mvm, wowlan, wowlan->nd_config ?: mvm->nd_config, vif);
+		if (ret)
+			goto out;
+	} else {
+		struct iwl_wowlan_config_cmd_v3 wowlan_config_cmd = {};
+
 		ap_sta = rcu_dereference_protected(
 			mvm->fw_id_to_mac_id[mvmvif->ap_sta_id],
 			lockdep_is_held(&mvm->mutex));
@@ -1021,29 +1063,10 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 						vif, mvmvif, ap_sta);
 		if (ret)
 			goto out_noreset;
-
-		ret = iwl_mvm_switch_to_d3(mvm);
-		if (ret)
-			goto out;
-
 		ret = iwl_mvm_wowlan_config(mvm, wowlan, &wowlan_config_cmd,
 					    vif, mvmvif, ap_sta);
 		if (ret)
 			goto out;
-	} else if (wowlan->nd_config || mvm->nd_config) {
-		ret = iwl_mvm_switch_to_d3(mvm);
-		if (ret)
-			goto out;
-
-		ret = iwl_mvm_scan_offload_start(
-			mvm, vif,
-			wowlan->nd_config ?: mvm->nd_config,
-			&mvm->nd_ies);
-		if (ret)
-			goto out;
-	} else {
-		ret = 1;
-		goto out_noreset;
 	}
 
 	ret = iwl_mvm_power_update_device(mvm);
-- 
1.9.1

