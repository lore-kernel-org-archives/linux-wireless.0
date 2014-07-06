Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:43410 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbaGFJg7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 05:36:59 -0400
Received: by mail-wi0-f176.google.com with SMTP id n3so14530103wiv.3
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 02:36:58 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 24/40] iwlwifi: mvm: let iwl_mvm_update_quotas disregard a disabled vif
Date: Sun,  6 Jul 2014 12:36:00 +0300
Message-Id: <1404639376-3792-24-git-send-email-egrumbach@gmail.com> (sfid-20140706_115954_430133_E6C9C59B)
In-Reply-To: <53B917DC.5050902@gmail.com>
References: <53B917DC.5050902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

In some cases (e.g. when we're doing a channel switch), we may need to
disable the quota of a vif temporarily.  In order to do so, add an
argument to the iwl_mvm_update_quotas() function to tell if the passed
vif is a new one or if it should be disregarded.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 28 +++++++++++++++++-----------
 drivers/net/wireless/iwlwifi/mvm/mvm.h      | 24 +++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/mvm/quota.c    | 26 +++++++++++++++++++-------
 drivers/net/wireless/iwlwifi/mvm/utils.c    |  3 ++-
 4 files changed, 61 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 522aa03..71353bd 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -834,7 +834,8 @@ static void iwl_mvm_mac_restart_complete(struct ieee80211_hw *hw)
 
 	clear_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status);
 	iwl_mvm_d0i3_enable_tx(mvm, NULL);
-	ret = iwl_mvm_update_quotas(mvm, NULL);
+	ret = iwl_mvm_update_quotas(mvm, NULL,
+				    IWL_MVM_QUOTA_UPDATE_TYPE_REGULAR);
 	if (ret)
 		IWL_ERR(mvm, "Failed to update quotas after restart (%d)\n",
 			ret);
@@ -1421,7 +1422,8 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 	if (changes & BSS_CHANGED_ASSOC) {
 		if (bss_conf->assoc) {
 			/* add quota for this interface */
-			ret = iwl_mvm_update_quotas(mvm, vif);
+			ret = iwl_mvm_update_quotas(mvm, vif,
+					    IWL_MVM_QUOTA_UPDATE_TYPE_NEW);
 			if (ret) {
 				IWL_ERR(mvm, "failed to update quotas\n");
 				return;
@@ -1469,7 +1471,8 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 				mvm->d0i3_ap_sta_id = IWL_MVM_STATION_COUNT;
 			mvmvif->ap_sta_id = IWL_MVM_STATION_COUNT;
 			/* remove quota for this interface */
-			ret = iwl_mvm_update_quotas(mvm, NULL);
+			ret = iwl_mvm_update_quotas(mvm, NULL,
+					    IWL_MVM_QUOTA_UPDATE_TYPE_REGULAR);
 			if (ret)
 				IWL_ERR(mvm, "failed to update quotas\n");
 
@@ -1568,7 +1571,7 @@ static int iwl_mvm_start_ap_ibss(struct ieee80211_hw *hw,
 	/* power updated needs to be done before quotas */
 	iwl_mvm_power_update_mac(mvm);
 
-	ret = iwl_mvm_update_quotas(mvm, vif);
+	ret = iwl_mvm_update_quotas(mvm, vif, IWL_MVM_QUOTA_UPDATE_TYPE_NEW);
 	if (ret)
 		goto out_quota_failed;
 
@@ -1617,7 +1620,7 @@ static void iwl_mvm_stop_ap_ibss(struct ieee80211_hw *hw,
 	if (vif->p2p && mvm->p2p_device_vif)
 		iwl_mvm_mac_ctxt_changed(mvm, mvm->p2p_device_vif, false);
 
-	iwl_mvm_update_quotas(mvm, NULL);
+	iwl_mvm_update_quotas(mvm, NULL, IWL_MVM_QUOTA_UPDATE_TYPE_REGULAR);
 	iwl_mvm_send_rm_bcast_sta(mvm, &mvmvif->bcast_sta);
 	iwl_mvm_binding_remove_vif(mvm, vif);
 
@@ -2403,14 +2406,15 @@ static int iwl_mvm_assign_vif_chanctx(struct ieee80211_hw *hw,
 	 */
 	if (vif->type == NL80211_IFTYPE_MONITOR) {
 		mvmvif->monitor_active = true;
-		ret = iwl_mvm_update_quotas(mvm, vif);
+		ret = iwl_mvm_update_quotas(mvm, vif,
+					    IWL_MVM_QUOTA_UPDATE_TYPE_NEW);
 		if (ret)
 			goto out_remove_binding;
 	}
 
 	/* Handle binding during CSA */
 	if (vif->type == NL80211_IFTYPE_AP) {
-		iwl_mvm_update_quotas(mvm, vif);
+		iwl_mvm_update_quotas(mvm, vif, IWL_MVM_QUOTA_UPDATE_TYPE_NEW);
 		iwl_mvm_mac_ctxt_changed(mvm, vif, false);
 	}
 
@@ -2442,7 +2446,8 @@ static void iwl_mvm_unassign_vif_chanctx(struct ieee80211_hw *hw,
 		goto out_unlock;
 	case NL80211_IFTYPE_MONITOR:
 		mvmvif->monitor_active = false;
-		iwl_mvm_update_quotas(mvm, NULL);
+		iwl_mvm_update_quotas(mvm, NULL,
+				      IWL_MVM_QUOTA_UPDATE_TYPE_REGULAR);
 		break;
 	case NL80211_IFTYPE_AP:
 		/* This part is triggered only during CSA */
@@ -2450,8 +2455,8 @@ static void iwl_mvm_unassign_vif_chanctx(struct ieee80211_hw *hw,
 			goto out_unlock;
 
 		mvmvif->ap_ibss_active = false;
-		iwl_mvm_update_quotas(mvm, NULL);
-		/*TODO: bt_coex notification here? */
+		iwl_mvm_update_quotas(mvm, NULL,
+				      IWL_MVM_QUOTA_UPDATE_TYPE_REGULAR);
 	default:
 		break;
 	}
@@ -2515,7 +2520,8 @@ static int __iwl_mvm_mac_testmode_cmd(struct iwl_mvm *mvm,
 		mvm->noa_duration = noa_duration;
 		mvm->noa_vif = vif;
 
-		return iwl_mvm_update_quotas(mvm, NULL);
+		return iwl_mvm_update_quotas(mvm, NULL,
+					     IWL_MVM_QUOTA_UPDATE_TYPE_REGULAR);
 	case IWL_MVM_TM_CMD_SET_BEACON_FILTER:
 		/* must be associated client vif - ignore authorized */
 		if (!vif || vif->type != NL80211_IFTYPE_STATION ||
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 927346e..55e42f4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -844,7 +844,29 @@ int iwl_mvm_binding_add_vif(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 int iwl_mvm_binding_remove_vif(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 
 /* Quota management */
-int iwl_mvm_update_quotas(struct iwl_mvm *mvm, struct ieee80211_vif *newvif);
+
+/**
+ * enum iwl_mvm_quota_update_type - quota update type
+
+ * @IWL_MVM_QUOTA_UPDATE_TYPE_REGULAR: regular quota update, use the
+ *	existing vifs (ie. no new vif nor a disabled vif is passed).
+ * @IWL_MVM_QUOTA_UPDATE_TYPE_NEW: a new vif is being added to the
+ *	quota calculation and needs to be treated differently.
+ * @IWL_MVM_QUOTA_UPDATE_TYPE_DISABLED: temporarily disable a vif from
+ *	the quota calculation.  The mvm mutex must remain held for the
+ *	entire time during which the vif is to remain disabled,
+ *	otherwise there is no guarantee that another code flow will
+ *	not reenable it accidentally (by updating the quotas without
+ *	marking the vif as disabled).
+ */
+enum iwl_mvm_quota_update_type {
+	IWL_MVM_QUOTA_UPDATE_TYPE_REGULAR,
+	IWL_MVM_QUOTA_UPDATE_TYPE_NEW,
+	IWL_MVM_QUOTA_UPDATE_TYPE_DISABLED,
+};
+
+int iwl_mvm_update_quotas(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+			  enum iwl_mvm_quota_update_type type);
 
 /* Scanning */
 int iwl_mvm_scan_request(struct iwl_mvm *mvm,
diff --git a/drivers/net/wireless/iwlwifi/mvm/quota.c b/drivers/net/wireless/iwlwifi/mvm/quota.c
index ba68d7b..75d2c95b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/quota.c
+++ b/drivers/net/wireless/iwlwifi/mvm/quota.c
@@ -73,7 +73,8 @@ struct iwl_mvm_quota_iterator_data {
 	int colors[MAX_BINDINGS];
 	int low_latency[MAX_BINDINGS];
 	int n_low_latency_bindings;
-	struct ieee80211_vif *new_vif;
+	struct ieee80211_vif *vif;
+	enum iwl_mvm_quota_update_type type;
 };
 
 static void iwl_mvm_quota_iterator(void *_data, u8 *mac,
@@ -89,7 +90,7 @@ static void iwl_mvm_quota_iterator(void *_data, u8 *mac,
 	 * the add_interface callback (otherwise it won't show
 	 * up in iteration)
 	 */
-	if (vif == data->new_vif)
+	if (data->type == IWL_MVM_QUOTA_UPDATE_TYPE_NEW && vif == data->vif)
 		return;
 
 	if (!mvmvif->phy_ctxt)
@@ -109,6 +110,10 @@ static void iwl_mvm_quota_iterator(void *_data, u8 *mac,
 	else
 		WARN_ON_ONCE(data->colors[id] != mvmvif->phy_ctxt->color);
 
+	if (data->type == IWL_MVM_QUOTA_UPDATE_TYPE_DISABLED &&
+	    vif == data->vif)
+		return;
+
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
 		if (vif->bss_conf.assoc)
@@ -171,14 +176,16 @@ static void iwl_mvm_adjust_quota_for_noa(struct iwl_mvm *mvm,
 #endif
 }
 
-int iwl_mvm_update_quotas(struct iwl_mvm *mvm, struct ieee80211_vif *newvif)
+int iwl_mvm_update_quotas(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+			  enum iwl_mvm_quota_update_type type)
 {
 	struct iwl_time_quota_cmd cmd = {};
 	int i, idx, ret, num_active_macs, quota, quota_rem, n_non_lowlat;
 	struct iwl_mvm_quota_iterator_data data = {
 		.n_interfaces = {},
 		.colors = { -1, -1, -1, -1 },
-		.new_vif = newvif,
+		.vif = vif,
+		.type = type,
 	};
 
 	lockdep_assert_held(&mvm->mutex);
@@ -190,12 +197,17 @@ int iwl_mvm_update_quotas(struct iwl_mvm *mvm, struct ieee80211_vif *newvif)
 	/* iterator data above must match */
 	BUILD_BUG_ON(MAX_BINDINGS != 4);
 
+	if (WARN_ON_ONCE((type != IWL_MVM_QUOTA_UPDATE_TYPE_REGULAR && !vif) ||
+			 (type == IWL_MVM_QUOTA_UPDATE_TYPE_REGULAR && vif)))
+		return -EINVAL;
+
 	ieee80211_iterate_active_interfaces_atomic(
 		mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
 		iwl_mvm_quota_iterator, &data);
-	if (newvif) {
-		data.new_vif = NULL;
-		iwl_mvm_quota_iterator(&data, newvif->addr, newvif);
+	if (type == IWL_MVM_QUOTA_UPDATE_TYPE_NEW) {
+		data.vif = NULL;
+		data.type = IWL_MVM_QUOTA_UPDATE_TYPE_REGULAR;
+		iwl_mvm_quota_iterator(&data, vif->addr, vif);
 	}
 
 	/*
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index ac249da..98ff649 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -631,7 +631,8 @@ int iwl_mvm_update_low_latency(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	mvmvif->low_latency = value;
 
-	res = iwl_mvm_update_quotas(mvm, NULL);
+	res = iwl_mvm_update_quotas(mvm, NULL,
+				    IWL_MVM_QUOTA_UPDATE_TYPE_REGULAR);
 	if (res)
 		return res;
 
-- 
1.8.3.2

