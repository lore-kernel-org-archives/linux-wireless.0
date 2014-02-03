Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:55378 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaBCU7w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:59:52 -0500
Received: by mail-ea0-f177.google.com with SMTP id n15so3975206ead.8
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:59:51 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 62/62] iwlwifi: mvm: refactor power code
Date: Mon,  3 Feb 2014 22:58:08 +0200
Message-Id: <1391461088-8082-62-git-send-email-egrumbach@gmail.com> (sfid-20140203_223006_950755_9AF89301)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The main complexity of the power code is that it needs to
take into account the firmware limitations.
These limitations state that we need to have a global
picture of the vifs present in the system to be able to
decide if we can enable power management on a specific vif.

Even device power save (as opposed to vif power management)
must be disabled in certain circumstances (monitor vif).

Refactor the current code to make this clearer by defining
a function that explicitely computes these constraints.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c          |    2 +-
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c |    2 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c    |   19 +--
 drivers/net/wireless/iwlwifi/mvm/mvm.h         |    9 +-
 drivers/net/wireless/iwlwifi/mvm/power.c       |  169 ++++++++++++++----------
 drivers/net/wireless/iwlwifi/mvm/utils.c       |    2 +-
 6 files changed, 117 insertions(+), 86 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index a9850aa..e3a9cec 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -1195,7 +1195,7 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 	if (ret)
 		goto out;
 
-	ret = iwl_mvm_power_mac_update_mode(mvm, vif);
+	ret = iwl_mvm_power_update_mac(mvm, vif);
 	if (ret)
 		goto out;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
index 9c0708e..29b4396 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
@@ -185,7 +185,7 @@ static ssize_t iwl_dbgfs_pm_params_write(struct ieee80211_vif *vif, char *buf,
 
 	mutex_lock(&mvm->mutex);
 	iwl_dbgfs_update_pm(mvm, vif, param, val);
-	ret = iwl_mvm_power_mac_update_mode(mvm, vif);
+	ret = iwl_mvm_power_update_mac(mvm, vif);
 	mutex_unlock(&mvm->mutex);
 
 	return ret ?: count;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 9d29069..b9b6bfb 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -717,7 +717,9 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 	if (ret)
 		goto out_release;
 
-	iwl_mvm_power_mac_update_mode(mvm, vif);
+	ret = iwl_mvm_power_update_mac(mvm, vif);
+	if (ret)
+		goto out_release;
 
 	/* beacon filtering */
 	ret = iwl_mvm_disable_beacon_filter(mvm, vif, CMD_SYNC);
@@ -867,6 +869,7 @@ static void iwl_mvm_mac_remove_interface(struct ieee80211_hw *hw,
 	if (mvm->vif_count && vif->type != NL80211_IFTYPE_P2P_DEVICE)
 		mvm->vif_count--;
 
+	iwl_mvm_power_update_mac(mvm, vif);
 	iwl_mvm_mac_ctxt_remove(mvm, vif);
 
 out_release:
@@ -1231,7 +1234,7 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 					  &mvmvif->time_event_data);
 	} else if (changes & (BSS_CHANGED_PS | BSS_CHANGED_P2P_PS |
 			      BSS_CHANGED_QOS)) {
-		ret = iwl_mvm_power_mac_update_mode(mvm, vif);
+		ret = iwl_mvm_power_update_mac(mvm, vif);
 		if (ret)
 			IWL_ERR(mvm, "failed to update power mode\n");
 	}
@@ -1298,7 +1301,7 @@ static int iwl_mvm_start_ap_ibss(struct ieee80211_hw *hw,
 
 	/* power updated needs to be done before quotas */
 	mvm->bound_vif_cnt++;
-	iwl_mvm_power_update_binding(mvm, vif, true);
+	iwl_mvm_power_update_mac(mvm, vif);
 
 	ret = iwl_mvm_update_quotas(mvm, vif);
 	if (ret)
@@ -1317,7 +1320,7 @@ static int iwl_mvm_start_ap_ibss(struct ieee80211_hw *hw,
 
 out_quota_failed:
 	mvm->bound_vif_cnt--;
-	iwl_mvm_power_update_binding(mvm, vif, false);
+	iwl_mvm_power_update_mac(mvm, vif);
 	mvmvif->ap_ibss_active = false;
 	iwl_mvm_send_rm_bcast_sta(mvm, &mvmvif->bcast_sta);
 out_unbind:
@@ -1354,7 +1357,7 @@ static void iwl_mvm_stop_ap_ibss(struct ieee80211_hw *hw,
 	iwl_mvm_binding_remove_vif(mvm, vif);
 
 	mvm->bound_vif_cnt--;
-	iwl_mvm_power_update_binding(mvm, vif, false);
+	iwl_mvm_power_update_mac(mvm, vif);
 
 	iwl_mvm_mac_ctxt_remove(mvm, vif);
 
@@ -2088,7 +2091,7 @@ static int iwl_mvm_assign_vif_chanctx(struct ieee80211_hw *hw,
 	 * otherwise fw will complain.
 	 */
 	mvm->bound_vif_cnt++;
-	iwl_mvm_power_update_binding(mvm, vif, true);
+	iwl_mvm_power_update_mac(mvm, vif);
 
 	/* Setting the quota at this stage is only required for monitor
 	 * interfaces. For the other types, the bss_info changed flow
@@ -2106,7 +2109,7 @@ static int iwl_mvm_assign_vif_chanctx(struct ieee80211_hw *hw,
  out_remove_binding:
 	iwl_mvm_binding_remove_vif(mvm, vif);
 	mvm->bound_vif_cnt--;
-	iwl_mvm_power_update_binding(mvm, vif, false);
+	iwl_mvm_power_update_mac(mvm, vif);
  out_unlock:
 	mutex_unlock(&mvm->mutex);
 	if (ret)
@@ -2139,7 +2142,7 @@ static void iwl_mvm_unassign_vif_chanctx(struct ieee80211_hw *hw,
 
 	iwl_mvm_binding_remove_vif(mvm, vif);
 	mvm->bound_vif_cnt--;
-	iwl_mvm_power_update_binding(mvm, vif, false);
+	iwl_mvm_power_update_mac(mvm, vif);
 
 out_unlock:
 	mvmvif->phy_ctxt = NULL;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index bf6b602..ab6e1e9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -588,7 +588,9 @@ struct iwl_mvm {
 	u8 bound_vif_cnt;
 
 	/* Indicate if device power save is allowed */
-	bool ps_prevented;
+	bool ps_disabled;
+	/* Indicate if device power management is allowed */
+	bool pm_disabled;
 };
 
 /* Extract MVM priv from op_mode and _hw */
@@ -812,11 +814,8 @@ int iwl_mvm_send_lq_cmd(struct iwl_mvm *mvm, struct iwl_lq_cmd *lq, bool init);
 /* power management */
 int iwl_power_legacy_set_cam_mode(struct iwl_mvm *mvm);
 
-int iwl_mvm_power_mac_update_mode(struct iwl_mvm *mvm,
-				  struct ieee80211_vif *vif);
 int iwl_mvm_power_update_device(struct iwl_mvm *mvm);
-void iwl_mvm_power_update_binding(struct iwl_mvm *mvm,
-				  struct ieee80211_vif *vif, bool assign);
+int iwl_mvm_power_update_mac(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 int iwl_mvm_power_mac_dbgfs_read(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 				 char *buf, int bufsz);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index 5671b83..4da1ea4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -298,8 +298,7 @@ static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 	keep_alive = DIV_ROUND_UP(keep_alive, MSEC_PER_SEC);
 	cmd->keep_alive_seconds = cpu_to_le16(keep_alive);
 
-	if (iwlmvm_mod_params.power_scheme == IWL_POWER_SCHEME_CAM ||
-	    mvm->ps_prevented)
+	if (mvm->ps_disabled)
 		return;
 
 	cmd->flags |= cpu_to_le16(POWER_FLAGS_POWER_SAVE_ENA_MSK);
@@ -309,8 +308,8 @@ static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 	    mvmvif->dbgfs_pm.disable_power_off)
 		cmd->flags &= cpu_to_le16(~POWER_FLAGS_POWER_SAVE_ENA_MSK);
 #endif
-	if (!vif->bss_conf.ps || mvm->bound_vif_cnt > 1 ||
-	    iwl_mvm_vif_low_latency(mvmvif))
+	if (!vif->bss_conf.ps || iwl_mvm_vif_low_latency(mvmvif) ||
+	    mvm->pm_disabled)
 		return;
 
 	cmd->flags |= cpu_to_le16(POWER_FLAGS_POWER_MANAGEMENT_ENA_MSK);
@@ -417,7 +416,7 @@ static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 #endif /* CONFIG_IWLWIFI_DEBUGFS */
 }
 
-static int _iwl_mvm_power_mac_update_mode(struct iwl_mvm *mvm,
+static int iwl_mvm_power_send_cmd(struct iwl_mvm *mvm,
 					 struct ieee80211_vif *vif)
 {
 	struct iwl_mac_power_cmd cmd = {};
@@ -439,39 +438,22 @@ static int _iwl_mvm_power_mac_update_mode(struct iwl_mvm *mvm,
 				    sizeof(cmd), &cmd);
 }
 
-int iwl_mvm_power_mac_update_mode(struct iwl_mvm *mvm,
-				  struct ieee80211_vif *vif)
-
-{
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	bool ba_enable;
-	int ret;
-
-	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PM_CMD_SUPPORT))
-		return 0;
-
-	ret = _iwl_mvm_power_mac_update_mode(mvm, vif);
-	if (ret)
-		return ret;
-
-	ba_enable = !(iwlmvm_mod_params.power_scheme == IWL_POWER_SCHEME_CAM ||
-		      mvm->ps_prevented || mvm->bound_vif_cnt > 1 ||
-		      !vif->bss_conf.ps || iwl_mvm_vif_low_latency(mvmvif));
-
-	return iwl_mvm_update_beacon_abort(mvm, vif, ba_enable);
-}
-
-static int _iwl_mvm_power_update_device(struct iwl_mvm *mvm, bool force_disable)
+int iwl_mvm_power_update_device(struct iwl_mvm *mvm)
 {
 	struct iwl_device_power_cmd cmd = {
 		.flags = cpu_to_le16(DEVICE_POWER_FLAGS_POWER_SAVE_ENA_MSK),
 	};
 
+	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PM_CMD_SUPPORT))
+		return 0;
+
 	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_DEVICE_PS_CMD))
 		return 0;
 
-	if (iwlmvm_mod_params.power_scheme == IWL_POWER_SCHEME_CAM ||
-	    force_disable)
+	if (iwlmvm_mod_params.power_scheme == IWL_POWER_SCHEME_CAM)
+		mvm->ps_disabled = true;
+
+	if (mvm->ps_disabled)
 		cmd.flags |= cpu_to_le16(DEVICE_POWER_FLAGS_CAM_MSK);
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
@@ -488,14 +470,6 @@ static int _iwl_mvm_power_update_device(struct iwl_mvm *mvm, bool force_disable)
 				    &cmd);
 }
 
-int iwl_mvm_power_update_device(struct iwl_mvm *mvm)
-{
-	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PM_CMD_SUPPORT))
-		return 0;
-
-	return _iwl_mvm_power_update_device(mvm, false);
-}
-
 void iwl_mvm_power_vif_assoc(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
@@ -534,64 +508,119 @@ int iwl_mvm_power_uapsd_misbehaving_ap_notif(struct iwl_mvm *mvm,
 	return 0;
 }
 
-struct iwl_mvm_power_iterator {
-	struct iwl_mvm *mvm;
+struct iwl_power_constraint {
 	struct ieee80211_vif *bf_vif;
+	struct ieee80211_vif *bss_vif;
+	bool pm_disabled;
+	bool ps_disabled;
 };
 
-static void iwl_mvm_power_binding_iterator(void *_data, u8 *mac,
-					   struct ieee80211_vif *vif)
+static void iwl_mvm_power_iterator(void *_data, u8 *mac,
+				   struct ieee80211_vif *vif)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	struct iwl_mvm_power_iterator *power_iterator = _data;
-	struct iwl_mvm *mvm = power_iterator->mvm;
-	int ret;
+	struct iwl_power_constraint *power_iterator = _data;
+
+	switch (ieee80211_vif_type_p2p(vif)) {
+	case NL80211_IFTYPE_P2P_DEVICE:
+		break;
+
+	case NL80211_IFTYPE_P2P_GO:
+	case NL80211_IFTYPE_AP:
+		/* no BSS power mgmt if we have an active AP */
+		if (mvmvif->ap_ibss_active)
+			power_iterator->pm_disabled = true;
+		break;
+
+	case NL80211_IFTYPE_MONITOR:
+		/* no BSS power mgmt and no device power save */
+		power_iterator->pm_disabled = true;
+		power_iterator->ps_disabled = true;
+		break;
+
+	case NL80211_IFTYPE_P2P_CLIENT:
+		/* no BSS power mgmt if we have a P2P client*/
+		power_iterator->pm_disabled = true;
+		break;
+
+	case NL80211_IFTYPE_STATION:
+		/* we should have only one BSS vif */
+		WARN_ON(power_iterator->bss_vif);
+		power_iterator->bss_vif = vif;
+
+		if (mvmvif->bf_data.bf_enabled &&
+		    !WARN_ON(power_iterator->bf_vif))
+			power_iterator->bf_vif = vif;
+		break;
+
+	default:
+		break;
+	}
+}
 
-	ret = _iwl_mvm_power_mac_update_mode(mvm, vif);
+static void
+iwl_mvm_power_get_global_constraint(struct iwl_mvm *mvm,
+				    struct iwl_power_constraint *constraint)
+{
+	lockdep_assert_held(&mvm->mutex);
+
+	if (iwlmvm_mod_params.power_scheme == IWL_POWER_SCHEME_CAM) {
+		constraint->pm_disabled = true;
+		constraint->ps_disabled = true;
+	}
 
-	if (mvmvif->bf_data.bf_enabled && !WARN_ON(power_iterator->bf_vif))
-		power_iterator->bf_vif = vif;
+	ieee80211_iterate_active_interfaces_atomic(mvm->hw,
+					    IEEE80211_IFACE_ITER_NORMAL,
+					    iwl_mvm_power_iterator, constraint);
 
-	WARN_ONCE(ret, "Failed to update power parameters on a specific vif\n");
+	/* TODO: remove this and determine this variable in the iterator */
+	if (mvm->bound_vif_cnt > 1)
+		constraint->pm_disabled = true;
 }
 
-void iwl_mvm_power_update_binding(struct iwl_mvm *mvm,
-				  struct ieee80211_vif *vif, bool assign)
+int iwl_mvm_power_update_mac(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 {
-	bool ba_enable;
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	struct iwl_mvm_power_iterator power_it = {
-		.mvm = mvm,
-	};
+	struct iwl_power_constraint constraint = {};
+	bool ba_enable;
+	int ret;
 
 	lockdep_assert_held(&mvm->mutex);
 
 	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PM_CMD_SUPPORT))
-		return;
+		return 0;
+
+	iwl_mvm_power_get_global_constraint(mvm, &constraint);
+	mvm->ps_disabled = constraint.ps_disabled;
+	mvm->pm_disabled = constraint.pm_disabled;
 
+	/* don't update device power state unless we add / remove monitor */
 	if (vif->type == NL80211_IFTYPE_MONITOR) {
-		int ret = _iwl_mvm_power_update_device(mvm, assign);
-		mvm->ps_prevented = assign;
-		WARN_ONCE(ret, "Failed to update power device state\n");
+		ret = iwl_mvm_power_update_device(mvm);
+		if (ret)
+			return ret;
 	}
 
-	ieee80211_iterate_active_interfaces(mvm->hw,
-					    IEEE80211_IFACE_ITER_NORMAL,
-					    iwl_mvm_power_binding_iterator,
-					    &power_it);
+	ret = iwl_mvm_power_send_cmd(mvm, vif);
+	if (ret)
+		return ret;
 
-	if (!power_it.bf_vif)
-		return;
+	if (constraint.bss_vif && vif != constraint.bss_vif) {
+		ret = iwl_mvm_power_send_cmd(mvm, constraint.bss_vif);
+		if (ret)
+			return ret;
+	}
+
+	if (!constraint.bf_vif)
+		return 0;
 
-	vif = power_it.bf_vif;
+	vif = constraint.bf_vif;
 	mvmvif = iwl_mvm_vif_from_mac80211(vif);
 
-	ba_enable = !(iwlmvm_mod_params.power_scheme == IWL_POWER_SCHEME_CAM ||
-		      mvm->ps_prevented || mvm->bound_vif_cnt > 1 ||
+	ba_enable = !(constraint.pm_disabled || constraint.ps_disabled ||
 		      !vif->bss_conf.ps || iwl_mvm_vif_low_latency(mvmvif));
 
-	WARN_ON_ONCE(iwl_mvm_update_beacon_abort(mvm, power_it.bf_vif,
-						 ba_enable));
+	return iwl_mvm_update_beacon_abort(mvm, constraint.bf_vif, ba_enable);
 }
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index d4d9010..7440ffa 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -564,5 +564,5 @@ int iwl_mvm_update_low_latency(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	iwl_mvm_bt_coex_vif_change(mvm);
 
-	return iwl_mvm_power_mac_update_mode(mvm, vif);
+	return iwl_mvm_power_update_mac(mvm, vif);
 }
-- 
1.7.9.5

