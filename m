Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:4314 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371AbbFCHcA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 03:32:00 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/15] iwlwifi: mvm: simplify iwl_mvm_stop_roc()
Date: Wed,  3 Jun 2015 10:31:31 +0300
Message-Id: <1433316696-4612-10-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150603_093350_428780_B0098DE3)
In-Reply-To: <1433316253.25661.3.camel@intel.com>
References: <1433316253.25661.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

As pointed out by smatch, there's no need for a loop that always
immediately terminates. Use an if statement instead and while at
it clean up the mvmvif initialization.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/time-event.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.c b/drivers/net/wireless/iwlwifi/mvm/time-event.c
index a7448cf..d24b6a8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@ -797,13 +797,12 @@ int iwl_mvm_start_p2p_roc(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 void iwl_mvm_stop_roc(struct iwl_mvm *mvm)
 {
-	struct iwl_mvm_vif *mvmvif;
+	struct iwl_mvm_vif *mvmvif = NULL;
 	struct iwl_mvm_time_event_data *te_data;
 	bool is_p2p = false;
 
 	lockdep_assert_held(&mvm->mutex);
 
-	mvmvif = NULL;
 	spin_lock_bh(&mvm->time_event_lock);
 
 	/*
@@ -821,17 +820,14 @@ void iwl_mvm_stop_roc(struct iwl_mvm *mvm)
 		}
 	}
 
-	/*
-	 * Iterate over the list of aux roc time events and find the time
-	 * event that is associated with a BSS interface.
-	 * This assumes that a BSS interface can have only a single time
-	 * event at any given time and this time event corresponds to a ROC
-	 * request
+	/* There can only be at most one AUX ROC time event, we just use the
+	 * list to simplify/unify code. Remove it if it exists.
 	 */
-	list_for_each_entry(te_data, &mvm->aux_roc_te_list, list) {
+	te_data = list_first_entry_or_null(&mvm->aux_roc_te_list,
+					   struct iwl_mvm_time_event_data,
+					   list);
+	if (te_data)
 		mvmvif = iwl_mvm_vif_from_mac80211(te_data->vif);
-		goto remove_te;
-	}
 
 remove_te:
 	spin_unlock_bh(&mvm->time_event_lock);
-- 
2.1.4

