Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64527 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356AbbDBGlY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2015 02:41:24 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/31] iwlwifi: mvm: continue (with error) CSA on GO time event failure
Date: Thu,  2 Apr 2015 09:40:49 +0300
Message-Id: <1427956879-11725-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150402_084127_076132_071A9B5E)
In-Reply-To: <1427956656.8122.2.camel@egrumbacBox>
References: <1427956656.8122.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If, on a GO, the CSA time event fails to be scheduled, continue the
flow towards mac80211's state machine so it doesn't get stuck, but
report an error later on the post switch which will cause mac80211
to tear down the operation. This ensures nothing gets stuck due to
the scheduling failure.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c   |  8 ++++++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h        |  2 ++
 drivers/net/wireless/iwlwifi/mvm/time-event.c | 16 ++++++++++------
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 302c8cc..5f26557 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -3646,6 +3646,8 @@ static int iwl_mvm_pre_channel_switch(struct ieee80211_hw *hw,
 
 	mutex_lock(&mvm->mutex);
 
+	mvmvif->csa_failed = false;
+
 	IWL_DEBUG_MAC80211(mvm, "pre CSA to freq %d\n",
 			   chsw->chandef.center_freq1);
 
@@ -3721,6 +3723,12 @@ static int iwl_mvm_post_channel_switch(struct ieee80211_hw *hw,
 
 	mutex_lock(&mvm->mutex);
 
+	if (mvmvif->csa_failed) {
+		mvmvif->csa_failed = false;
+		ret = -EIO;
+		goto out_unlock;
+	}
+
 	if (vif->type == NL80211_IFTYPE_STATION) {
 		struct iwl_mvm_sta *mvmsta;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 432265e..4903dec 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -354,6 +354,7 @@ struct iwl_mvm_vif_bf_data {
  * @beacon_stats: beacon statistics, containing the # of received beacons,
  *	# of received beacons accumulated over FW restart, and the current
  *	average signal of beacons retrieved from the firmware
+ * @csa_failed: CSA failed to schedule time event, report an error later
  */
 struct iwl_mvm_vif {
 	struct iwl_mvm *mvm;
@@ -433,6 +434,7 @@ struct iwl_mvm_vif {
 
 	/* Indicates that CSA countdown may be started */
 	bool csa_countdown;
+	bool csa_failed;
 };
 
 static inline struct iwl_mvm_vif *
diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.c b/drivers/net/wireless/iwlwifi/mvm/time-event.c
index 8d179ab..98c8d70 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@ -196,19 +196,23 @@ iwl_mvm_te_handle_notify_csa(struct iwl_mvm *mvm,
 			     struct iwl_mvm_time_event_data *te_data,
 			     struct iwl_time_event_notif *notif)
 {
-	if (!le32_to_cpu(notif->status)) {
-		if (te_data->vif->type == NL80211_IFTYPE_STATION)
-			ieee80211_connection_loss(te_data->vif);
+	struct ieee80211_vif *vif = te_data->vif;
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+
+	if (!notif->status)
 		IWL_DEBUG_TE(mvm, "CSA time event failed to start\n");
-		iwl_mvm_te_clear_data(mvm, te_data);
-		return;
-	}
 
 	switch (te_data->vif->type) {
 	case NL80211_IFTYPE_AP:
+		if (!notif->status)
+			mvmvif->csa_failed = true;
 		iwl_mvm_csa_noa_start(mvm);
 		break;
 	case NL80211_IFTYPE_STATION:
+		if (!notif->status) {
+			ieee80211_connection_loss(te_data->vif);
+			break;
+		}
 		iwl_mvm_csa_client_absent(mvm, te_data->vif);
 		ieee80211_chswitch_done(te_data->vif, true);
 		break;
-- 
1.9.1

