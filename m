Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:54156 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754536AbbCLNFx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:05:53 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 24/49] iwlwifi: mvm: always update the quota after association
Date: Thu, 12 Mar 2015 15:04:09 +0200
Message-Id: <1426165474-25586-24-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_143419_021767_94BAB384)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we associate we always need to update the quotas. This
fixes a bug for cases in which quotas weren't udapted after
association.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 20 ++++++++++----------
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  2 +-
 drivers/net/wireless/iwlwifi/mvm/quota.c    |  3 ++-
 drivers/net/wireless/iwlwifi/mvm/utils.c    |  2 +-
 4 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 7484724..7eab892 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1298,7 +1298,7 @@ static void iwl_mvm_restart_complete(struct iwl_mvm *mvm)
 
 	clear_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status);
 	iwl_mvm_d0i3_enable_tx(mvm, NULL);
-	ret = iwl_mvm_update_quotas(mvm, NULL);
+	ret = iwl_mvm_update_quotas(mvm, false, NULL);
 	if (ret)
 		IWL_ERR(mvm, "Failed to update quotas after restart (%d)\n",
 			ret);
@@ -1977,7 +1977,7 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 			       sizeof(mvmvif->beacon_stats));
 
 			/* add quota for this interface */
-			ret = iwl_mvm_update_quotas(mvm, NULL);
+			ret = iwl_mvm_update_quotas(mvm, true, NULL);
 			if (ret) {
 				IWL_ERR(mvm, "failed to update quotas\n");
 				return;
@@ -2029,7 +2029,7 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 				mvm->d0i3_ap_sta_id = IWL_MVM_STATION_COUNT;
 			mvmvif->ap_sta_id = IWL_MVM_STATION_COUNT;
 			/* remove quota for this interface */
-			ret = iwl_mvm_update_quotas(mvm, NULL);
+			ret = iwl_mvm_update_quotas(mvm, false, NULL);
 			if (ret)
 				IWL_ERR(mvm, "failed to update quotas\n");
 
@@ -2148,7 +2148,7 @@ static int iwl_mvm_start_ap_ibss(struct ieee80211_hw *hw,
 	/* power updated needs to be done before quotas */
 	iwl_mvm_power_update_mac(mvm);
 
-	ret = iwl_mvm_update_quotas(mvm, NULL);
+	ret = iwl_mvm_update_quotas(mvm, false, NULL);
 	if (ret)
 		goto out_quota_failed;
 
@@ -2214,7 +2214,7 @@ static void iwl_mvm_stop_ap_ibss(struct ieee80211_hw *hw,
 	if (vif->p2p && mvm->p2p_device_vif)
 		iwl_mvm_mac_ctxt_changed(mvm, mvm->p2p_device_vif, false, NULL);
 
-	iwl_mvm_update_quotas(mvm, NULL);
+	iwl_mvm_update_quotas(mvm, false, NULL);
 	iwl_mvm_send_rm_bcast_sta(mvm, vif);
 	iwl_mvm_binding_remove_vif(mvm, vif);
 
@@ -3247,14 +3247,14 @@ static int __iwl_mvm_assign_vif_chanctx(struct iwl_mvm *mvm,
 	 */
 	if (vif->type == NL80211_IFTYPE_MONITOR) {
 		mvmvif->monitor_active = true;
-		ret = iwl_mvm_update_quotas(mvm, NULL);
+		ret = iwl_mvm_update_quotas(mvm, false, NULL);
 		if (ret)
 			goto out_remove_binding;
 	}
 
 	/* Handle binding during CSA */
 	if (vif->type == NL80211_IFTYPE_AP) {
-		iwl_mvm_update_quotas(mvm, NULL);
+		iwl_mvm_update_quotas(mvm, false, NULL);
 		iwl_mvm_mac_ctxt_changed(mvm, vif, false, NULL);
 	}
 
@@ -3278,7 +3278,7 @@ static int __iwl_mvm_assign_vif_chanctx(struct iwl_mvm *mvm,
 
 		iwl_mvm_unref(mvm, IWL_MVM_REF_PROTECT_CSA);
 
-		iwl_mvm_update_quotas(mvm, NULL);
+		iwl_mvm_update_quotas(mvm, false, NULL);
 	}
 
 	goto out;
@@ -3351,7 +3351,7 @@ static void __iwl_mvm_unassign_vif_chanctx(struct iwl_mvm *mvm,
 		break;
 	}
 
-	iwl_mvm_update_quotas(mvm, disabled_vif);
+	iwl_mvm_update_quotas(mvm, false, disabled_vif);
 	iwl_mvm_binding_remove_vif(mvm, vif);
 
 out:
@@ -3543,7 +3543,7 @@ static int __iwl_mvm_mac_testmode_cmd(struct iwl_mvm *mvm,
 		mvm->noa_duration = noa_duration;
 		mvm->noa_vif = vif;
 
-		return iwl_mvm_update_quotas(mvm, NULL);
+		return iwl_mvm_update_quotas(mvm, false, NULL);
 	case IWL_MVM_TM_CMD_SET_BEACON_FILTER:
 		/* must be associated client vif - ignore authorized */
 		if (!vif || vif->type != NL80211_IFTYPE_STATION ||
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 4d44cf0..52135a4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1139,7 +1139,7 @@ int iwl_mvm_binding_add_vif(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 int iwl_mvm_binding_remove_vif(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 
 /* Quota management */
-int iwl_mvm_update_quotas(struct iwl_mvm *mvm,
+int iwl_mvm_update_quotas(struct iwl_mvm *mvm, bool force_upload,
 			  struct ieee80211_vif *disabled_vif);
 
 /* Scanning */
diff --git a/drivers/net/wireless/iwlwifi/mvm/quota.c b/drivers/net/wireless/iwlwifi/mvm/quota.c
index dbb2594..509a66d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/quota.c
+++ b/drivers/net/wireless/iwlwifi/mvm/quota.c
@@ -172,6 +172,7 @@ static void iwl_mvm_adjust_quota_for_noa(struct iwl_mvm *mvm,
 }
 
 int iwl_mvm_update_quotas(struct iwl_mvm *mvm,
+			  bool force_update,
 			  struct ieee80211_vif *disabled_vif)
 {
 	struct iwl_time_quota_cmd cmd = {};
@@ -309,7 +310,7 @@ int iwl_mvm_update_quotas(struct iwl_mvm *mvm,
 			  "zero quota on binding %d\n", i);
 	}
 
-	if (!send) {
+	if (!send && !force_update) {
 		/* don't send a practically unchanged command, the firmware has
 		 * to re-initialize a lot of state and that can have an adverse
 		 * impact on it
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index 2b9de63..435faee 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -857,7 +857,7 @@ int iwl_mvm_update_low_latency(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	mvmvif->low_latency = value;
 
-	res = iwl_mvm_update_quotas(mvm, NULL);
+	res = iwl_mvm_update_quotas(mvm, false, NULL);
 	if (res)
 		return res;
 
-- 
1.9.1

