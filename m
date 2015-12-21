Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:2928 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbbLUUvJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 15:51:09 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/45] iwlwifi: mvm: cleanup roc te on restart cleanup
Date: Mon, 21 Dec 2015 22:50:10 +0200
Message-Id: <1450731046-2796-9-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151221_215203_406916_307BFC91)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

iwl_mvm_restart_cleanup() calls ieee80211_remain_on_channel_expired()
on cleanup, but it doesn't clean the actual roc time
events, resulting in failure of further ROC attempts.

Refactor iwl_mvm_stop_roc() a bit, and add a new function
to only cleanup the roc time events (without sending further
commands).

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  1 +
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    | 38 ++++++++++++++--------
 .../net/wireless/intel/iwlwifi/mvm/time-event.h    |  1 +
 3 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 09afb6d..f428f1c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -967,6 +967,7 @@ static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 	mvm->calibrating = false;
 
 	/* just in case one was running */
+	iwl_mvm_cleanup_roc_te(mvm);
 	ieee80211_remain_on_channel_expired(mvm->hw);
 
 	/*
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index 87a04c3..924dd6a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -792,11 +792,9 @@ int iwl_mvm_start_p2p_roc(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	return iwl_mvm_time_event_send_add(mvm, vif, te_data, &time_cmd);
 }
 
-void iwl_mvm_stop_roc(struct iwl_mvm *mvm)
+static struct iwl_mvm_time_event_data *iwl_mvm_get_roc_te(struct iwl_mvm *mvm)
 {
-	struct iwl_mvm_vif *mvmvif = NULL;
 	struct iwl_mvm_time_event_data *te_data;
-	bool is_p2p = false;
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -810,11 +808,8 @@ void iwl_mvm_stop_roc(struct iwl_mvm *mvm)
 	 * request
 	 */
 	list_for_each_entry(te_data, &mvm->time_event_list, list) {
-		if (te_data->vif->type == NL80211_IFTYPE_P2P_DEVICE) {
-			mvmvif = iwl_mvm_vif_from_mac80211(te_data->vif);
-			is_p2p = true;
-			goto remove_te;
-		}
+		if (te_data->vif->type == NL80211_IFTYPE_P2P_DEVICE)
+			goto out;
 	}
 
 	/* There can only be at most one AUX ROC time event, we just use the
@@ -823,18 +818,35 @@ void iwl_mvm_stop_roc(struct iwl_mvm *mvm)
 	te_data = list_first_entry_or_null(&mvm->aux_roc_te_list,
 					   struct iwl_mvm_time_event_data,
 					   list);
+out:
+	spin_unlock_bh(&mvm->time_event_lock);
+	return te_data;
+}
+
+void iwl_mvm_cleanup_roc_te(struct iwl_mvm *mvm)
+{
+	struct iwl_mvm_time_event_data *te_data;
+	u32 uid;
+
+	te_data = iwl_mvm_get_roc_te(mvm);
 	if (te_data)
-		mvmvif = iwl_mvm_vif_from_mac80211(te_data->vif);
+		__iwl_mvm_remove_time_event(mvm, te_data, &uid);
+}
 
-remove_te:
-	spin_unlock_bh(&mvm->time_event_lock);
+void iwl_mvm_stop_roc(struct iwl_mvm *mvm)
+{
+	struct iwl_mvm_vif *mvmvif;
+	struct iwl_mvm_time_event_data *te_data;
 
-	if (!mvmvif) {
+	te_data = iwl_mvm_get_roc_te(mvm);
+	if (!te_data) {
 		IWL_WARN(mvm, "No remain on channel event\n");
 		return;
 	}
 
-	if (is_p2p)
+	mvmvif = iwl_mvm_vif_from_mac80211(te_data->vif);
+
+	if (te_data->vif->type == NL80211_IFTYPE_P2P_DEVICE)
 		iwl_mvm_remove_time_event(mvm, mvmvif, te_data);
 	else
 		iwl_mvm_remove_aux_roc_te(mvm, mvmvif, te_data);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.h b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.h
index 61d7cd7..99d9a35 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.h
@@ -215,6 +215,7 @@ void iwl_mvm_remove_time_event(struct iwl_mvm *mvm,
 void iwl_mvm_te_clear_data(struct iwl_mvm *mvm,
 			   struct iwl_mvm_time_event_data *te_data);
 
+void iwl_mvm_cleanup_roc_te(struct iwl_mvm *mvm);
 void iwl_mvm_roc_done_wk(struct work_struct *wk);
 
 /**
-- 
2.5.0

