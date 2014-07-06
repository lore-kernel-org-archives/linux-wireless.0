Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:55846 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbaGFJhF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 05:37:05 -0400
Received: by mail-wg0-f52.google.com with SMTP id b13so3084188wgh.11
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 02:37:04 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 28/40] iwlwifi: mvm: remove update type argument from quota update
Date: Sun,  6 Jul 2014 12:36:04 +0300
Message-Id: <1404639376-3792-28-git-send-email-egrumbach@gmail.com> (sfid-20140706_115953_969566_8E73B688)
In-Reply-To: <53B917DC.5050902@gmail.com>
References: <53B917DC.5050902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It turns out that adding the update type argument was pointless as
quota update is never called from the add_interface() callback.
Therefore, IWL_MVM_QUOTA_UPDATE_TYPE_NEW isn't actually needed and
then only a "disabled_vif" argument is needed for the upcoming CSA
work.

Remove the whole enum iwl_mvm_quota_update_type and pass the right
arguments (always NULL for disabled vif right now) to the function
in all current call sites.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 27 ++++++++++-----------------
 drivers/net/wireless/iwlwifi/mvm/mvm.h      | 25 ++-----------------------
 drivers/net/wireless/iwlwifi/mvm/quota.c    | 26 ++++++--------------------
 drivers/net/wireless/iwlwifi/mvm/utils.c    |  3 +--
 4 files changed, 19 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 71353bd..72f82a3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -834,8 +834,7 @@ static void iwl_mvm_mac_restart_complete(struct ieee80211_hw *hw)
 
 	clear_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status);
 	iwl_mvm_d0i3_enable_tx(mvm, NULL);
-	ret = iwl_mvm_update_quotas(mvm, NULL,
-				    IWL_MVM_QUOTA_UPDATE_TYPE_REGULAR);
+	ret = iwl_mvm_update_quotas(mvm, NULL);
 	if (ret)
 		IWL_ERR(mvm, "Failed to update quotas after restart (%d)\n",
 			ret);
@@ -1422,8 +1421,7 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 	if (changes & BSS_CHANGED_ASSOC) {
 		if (bss_conf->assoc) {
 			/* add quota for this interface */
-			ret = iwl_mvm_update_quotas(mvm, vif,
-					    IWL_MVM_QUOTA_UPDATE_TYPE_NEW);
+			ret = iwl_mvm_update_quotas(mvm, NULL);
 			if (ret) {
 				IWL_ERR(mvm, "failed to update quotas\n");
 				return;
@@ -1471,8 +1469,7 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 				mvm->d0i3_ap_sta_id = IWL_MVM_STATION_COUNT;
 			mvmvif->ap_sta_id = IWL_MVM_STATION_COUNT;
 			/* remove quota for this interface */
-			ret = iwl_mvm_update_quotas(mvm, NULL,
-					    IWL_MVM_QUOTA_UPDATE_TYPE_REGULAR);
+			ret = iwl_mvm_update_quotas(mvm, NULL);
 			if (ret)
 				IWL_ERR(mvm, "failed to update quotas\n");
 
@@ -1571,7 +1568,7 @@ static int iwl_mvm_start_ap_ibss(struct ieee80211_hw *hw,
 	/* power updated needs to be done before quotas */
 	iwl_mvm_power_update_mac(mvm);
 
-	ret = iwl_mvm_update_quotas(mvm, vif, IWL_MVM_QUOTA_UPDATE_TYPE_NEW);
+	ret = iwl_mvm_update_quotas(mvm, NULL);
 	if (ret)
 		goto out_quota_failed;
 
@@ -1620,7 +1617,7 @@ static void iwl_mvm_stop_ap_ibss(struct ieee80211_hw *hw,
 	if (vif->p2p && mvm->p2p_device_vif)
 		iwl_mvm_mac_ctxt_changed(mvm, mvm->p2p_device_vif, false);
 
-	iwl_mvm_update_quotas(mvm, NULL, IWL_MVM_QUOTA_UPDATE_TYPE_REGULAR);
+	iwl_mvm_update_quotas(mvm, NULL);
 	iwl_mvm_send_rm_bcast_sta(mvm, &mvmvif->bcast_sta);
 	iwl_mvm_binding_remove_vif(mvm, vif);
 
@@ -2406,15 +2403,14 @@ static int iwl_mvm_assign_vif_chanctx(struct ieee80211_hw *hw,
 	 */
 	if (vif->type == NL80211_IFTYPE_MONITOR) {
 		mvmvif->monitor_active = true;
-		ret = iwl_mvm_update_quotas(mvm, vif,
-					    IWL_MVM_QUOTA_UPDATE_TYPE_NEW);
+		ret = iwl_mvm_update_quotas(mvm, NULL);
 		if (ret)
 			goto out_remove_binding;
 	}
 
 	/* Handle binding during CSA */
 	if (vif->type == NL80211_IFTYPE_AP) {
-		iwl_mvm_update_quotas(mvm, vif, IWL_MVM_QUOTA_UPDATE_TYPE_NEW);
+		iwl_mvm_update_quotas(mvm, NULL);
 		iwl_mvm_mac_ctxt_changed(mvm, vif, false);
 	}
 
@@ -2446,8 +2442,7 @@ static void iwl_mvm_unassign_vif_chanctx(struct ieee80211_hw *hw,
 		goto out_unlock;
 	case NL80211_IFTYPE_MONITOR:
 		mvmvif->monitor_active = false;
-		iwl_mvm_update_quotas(mvm, NULL,
-				      IWL_MVM_QUOTA_UPDATE_TYPE_REGULAR);
+		iwl_mvm_update_quotas(mvm, NULL);
 		break;
 	case NL80211_IFTYPE_AP:
 		/* This part is triggered only during CSA */
@@ -2455,8 +2450,7 @@ static void iwl_mvm_unassign_vif_chanctx(struct ieee80211_hw *hw,
 			goto out_unlock;
 
 		mvmvif->ap_ibss_active = false;
-		iwl_mvm_update_quotas(mvm, NULL,
-				      IWL_MVM_QUOTA_UPDATE_TYPE_REGULAR);
+		iwl_mvm_update_quotas(mvm, NULL);
 	default:
 		break;
 	}
@@ -2520,8 +2514,7 @@ static int __iwl_mvm_mac_testmode_cmd(struct iwl_mvm *mvm,
 		mvm->noa_duration = noa_duration;
 		mvm->noa_vif = vif;
 
-		return iwl_mvm_update_quotas(mvm, NULL,
-					     IWL_MVM_QUOTA_UPDATE_TYPE_REGULAR);
+		return iwl_mvm_update_quotas(mvm, NULL);
 	case IWL_MVM_TM_CMD_SET_BEACON_FILTER:
 		/* must be associated client vif - ignore authorized */
 		if (!vif || vif->type != NL80211_IFTYPE_STATION ||
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 55e42f4..5fedd55 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -844,29 +844,8 @@ int iwl_mvm_binding_add_vif(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 int iwl_mvm_binding_remove_vif(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 
 /* Quota management */
-
-/**
- * enum iwl_mvm_quota_update_type - quota update type
-
- * @IWL_MVM_QUOTA_UPDATE_TYPE_REGULAR: regular quota update, use the
- *	existing vifs (ie. no new vif nor a disabled vif is passed).
- * @IWL_MVM_QUOTA_UPDATE_TYPE_NEW: a new vif is being added to the
- *	quota calculation and needs to be treated differently.
- * @IWL_MVM_QUOTA_UPDATE_TYPE_DISABLED: temporarily disable a vif from
- *	the quota calculation.  The mvm mutex must remain held for the
- *	entire time during which the vif is to remain disabled,
- *	otherwise there is no guarantee that another code flow will
- *	not reenable it accidentally (by updating the quotas without
- *	marking the vif as disabled).
- */
-enum iwl_mvm_quota_update_type {
-	IWL_MVM_QUOTA_UPDATE_TYPE_REGULAR,
-	IWL_MVM_QUOTA_UPDATE_TYPE_NEW,
-	IWL_MVM_QUOTA_UPDATE_TYPE_DISABLED,
-};
-
-int iwl_mvm_update_quotas(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-			  enum iwl_mvm_quota_update_type type);
+int iwl_mvm_update_quotas(struct iwl_mvm *mvm,
+			  struct ieee80211_vif *disabled_vif);
 
 /* Scanning */
 int iwl_mvm_scan_request(struct iwl_mvm *mvm,
diff --git a/drivers/net/wireless/iwlwifi/mvm/quota.c b/drivers/net/wireless/iwlwifi/mvm/quota.c
index 6de0c63..4e20b3c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/quota.c
+++ b/drivers/net/wireless/iwlwifi/mvm/quota.c
@@ -73,7 +73,7 @@ struct iwl_mvm_quota_iterator_data {
 	int colors[MAX_BINDINGS];
 	int low_latency[MAX_BINDINGS];
 	int n_low_latency_bindings;
-	struct ieee80211_vif *skip_vif;
+	struct ieee80211_vif *disabled_vif;
 };
 
 static void iwl_mvm_quota_iterator(void *_data, u8 *mac,
@@ -83,14 +83,8 @@ static void iwl_mvm_quota_iterator(void *_data, u8 *mac,
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	u16 id;
 
-	/*
-	 * We'll account for the new interface (if any) below,
-	 * skip it here in case we're not called from within
-	 * the add_interface callback (otherwise it won't show
-	 * up in iteration)
-	 * Also skip disabled interfaces here immediately.
-	 */
-	if (vif == data->skip_vif)
+	/* skip disabled interfaces here immediately */
+	if (vif == data->disabled_vif)
 		return;
 
 	if (!mvmvif->phy_ctxt)
@@ -172,15 +166,15 @@ static void iwl_mvm_adjust_quota_for_noa(struct iwl_mvm *mvm,
 #endif
 }
 
-int iwl_mvm_update_quotas(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-			  enum iwl_mvm_quota_update_type type)
+int iwl_mvm_update_quotas(struct iwl_mvm *mvm,
+			  struct ieee80211_vif *disabled_vif)
 {
 	struct iwl_time_quota_cmd cmd = {};
 	int i, idx, ret, num_active_macs, quota, quota_rem, n_non_lowlat;
 	struct iwl_mvm_quota_iterator_data data = {
 		.n_interfaces = {},
 		.colors = { -1, -1, -1, -1 },
-		.skip_vif = vif,
+		.disabled_vif = disabled_vif,
 	};
 
 	lockdep_assert_held(&mvm->mutex);
@@ -192,17 +186,9 @@ int iwl_mvm_update_quotas(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	/* iterator data above must match */
 	BUILD_BUG_ON(MAX_BINDINGS != 4);
 
-	if (WARN_ON_ONCE((type != IWL_MVM_QUOTA_UPDATE_TYPE_REGULAR && !vif) ||
-			 (type == IWL_MVM_QUOTA_UPDATE_TYPE_REGULAR && vif)))
-		return -EINVAL;
-
 	ieee80211_iterate_active_interfaces_atomic(
 		mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
 		iwl_mvm_quota_iterator, &data);
-	if (type == IWL_MVM_QUOTA_UPDATE_TYPE_NEW) {
-		data.skip_vif = NULL;
-		iwl_mvm_quota_iterator(&data, vif->addr, vif);
-	}
 
 	/*
 	 * The FW's scheduling session consists of
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index 98ff649..ac249da 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -631,8 +631,7 @@ int iwl_mvm_update_low_latency(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	mvmvif->low_latency = value;
 
-	res = iwl_mvm_update_quotas(mvm, NULL,
-				    IWL_MVM_QUOTA_UPDATE_TYPE_REGULAR);
+	res = iwl_mvm_update_quotas(mvm, NULL);
 	if (res)
 		return res;
 
-- 
1.8.3.2

