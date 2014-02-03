Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:54685 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbaBCU7t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:59:49 -0500
Received: by mail-ee0-f49.google.com with SMTP id d17so3881338eek.8
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:59:48 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 58/62] iwlwifi: mvm: don't send the beacon filtering command from iterator
Date: Mon,  3 Feb 2014 22:58:04 +0200
Message-Id: <1391461088-8082-58-git-send-email-egrumbach@gmail.com> (sfid-20140203_220008_996376_E5921E6D)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The firmware doesn't allow per-vif beacon filtering: we can
use beacon filtering for one vif only. So remember which
vif has beacon filtering enabled in the iterator, and send
the command outside the iterator.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/power.c |   58 +++++++++++++++++++++++++-----
 1 file changed, 49 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index 20bc376..15c9c78 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -417,13 +417,10 @@ static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 #endif /* CONFIG_IWLWIFI_DEBUGFS */
 }
 
-static int iwl_mvm_power_mac_update_mode(struct iwl_mvm *mvm,
+static int _iwl_mvm_power_mac_update_mode(struct iwl_mvm *mvm,
 					 struct ieee80211_vif *vif)
 {
-	int ret;
-	bool ba_enable;
 	struct iwl_mac_power_cmd cmd = {};
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 
 	if (vif->type != NL80211_IFTYPE_STATION)
 		return 0;
@@ -435,8 +432,19 @@ static int iwl_mvm_power_mac_update_mode(struct iwl_mvm *mvm,
 	iwl_mvm_power_build_cmd(mvm, vif, &cmd);
 	iwl_mvm_power_log(mvm, &cmd);
 
-	ret = iwl_mvm_send_cmd_pdu(mvm, MAC_PM_POWER_TABLE, CMD_SYNC,
-				   sizeof(cmd), &cmd);
+	return iwl_mvm_send_cmd_pdu(mvm, MAC_PM_POWER_TABLE, CMD_SYNC,
+				    sizeof(cmd), &cmd);
+}
+
+static int iwl_mvm_power_mac_update_mode(struct iwl_mvm *mvm,
+					 struct ieee80211_vif *vif)
+
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	bool ba_enable;
+	int ret;
+
+	ret = _iwl_mvm_power_mac_update_mode(mvm, vif);
 	if (ret)
 		return ret;
 
@@ -544,13 +552,24 @@ int iwl_mvm_power_uapsd_misbehaving_ap_notif(struct iwl_mvm *mvm,
 	return 0;
 }
 
+struct iwl_mvm_power_iterator {
+	struct iwl_mvm *mvm;
+	struct ieee80211_vif *bf_vif;
+};
+
 static void iwl_mvm_power_binding_iterator(void *_data, u8 *mac,
 					   struct ieee80211_vif *vif)
 {
-	struct iwl_mvm *mvm = _data;
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_mvm_power_iterator *power_iterator = _data;
+	struct iwl_mvm *mvm = power_iterator->mvm;
 	int ret;
 
-	ret = iwl_mvm_power_mac_update_mode(mvm, vif);
+	ret = _iwl_mvm_power_mac_update_mode(mvm, vif);
+
+	if (mvmvif->bf_data.bf_enabled && !WARN_ON(power_iterator->bf_vif))
+		power_iterator->bf_vif = vif;
+
 	WARN_ONCE(ret, "Failed to update power parameters on a specific vif\n");
 }
 
@@ -558,6 +577,14 @@ static void _iwl_mvm_power_update_binding(struct iwl_mvm *mvm,
 					  struct ieee80211_vif *vif,
 					  bool assign)
 {
+	bool ba_enable;
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_mvm_power_iterator power_it = {
+		.mvm = mvm,
+	};
+
+	lockdep_assert_held(&mvm->mutex);
+
 	if (vif->type == NL80211_IFTYPE_MONITOR) {
 		int ret = _iwl_mvm_power_update_device(mvm, assign);
 		mvm->ps_prevented = assign;
@@ -567,7 +594,20 @@ static void _iwl_mvm_power_update_binding(struct iwl_mvm *mvm,
 	ieee80211_iterate_active_interfaces(mvm->hw,
 					    IEEE80211_IFACE_ITER_NORMAL,
 					    iwl_mvm_power_binding_iterator,
-					    mvm);
+					    &power_it);
+
+	if (!power_it.bf_vif)
+		return;
+
+	vif = power_it.bf_vif;
+	mvmvif = iwl_mvm_vif_from_mac80211(vif);
+
+	ba_enable = !(iwlmvm_mod_params.power_scheme == IWL_POWER_SCHEME_CAM ||
+		      mvm->ps_prevented || mvm->bound_vif_cnt > 1 ||
+		      !vif->bss_conf.ps || iwl_mvm_vif_low_latency(mvmvif));
+
+	WARN_ON_ONCE(iwl_mvm_update_beacon_abort(mvm, power_it.bf_vif,
+						 ba_enable));
 }
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-- 
1.7.9.5

