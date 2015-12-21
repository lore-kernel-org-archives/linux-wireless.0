Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:53947 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027AbbLUUwk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 15:52:40 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Ayala Beker <ayala.beker@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 41/45] iwlwifi: mvm: Change number of associated stations when station becomes associated
Date: Mon, 21 Dec 2015 22:50:42 +0200
Message-Id: <1450731046-2796-41-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151221_220100_175275_101E2F07)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ayala Beker <ayala.beker@intel.com>

Currently, the number of associated stations gets updated when adding
a new station or removing it. This is incorrect as it's possible that
a station was inserted before it was associated
Fix this by increasing/decreasing ap_assoc_sta_count whenever
a station transitions in/out the associated state.

Signed-off-by: Ayala Beker <ayala.beker@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 14 ++++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      |  5 -----
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 53415dc..296b9c5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2248,7 +2248,6 @@ static void iwl_mvm_sta_pre_rcu_remove(struct ieee80211_hw *hw,
 				       struct ieee80211_sta *sta)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mvm_sta *mvm_sta = iwl_mvm_sta_from_mac80211(sta);
 
 	/*
@@ -2264,11 +2263,6 @@ static void iwl_mvm_sta_pre_rcu_remove(struct ieee80211_hw *hw,
 		rcu_assign_pointer(mvm->fw_id_to_mac_id[mvm_sta->sta_id],
 				   ERR_PTR(-ENOENT));
 
-	if (mvm_sta->vif->type == NL80211_IFTYPE_AP) {
-		mvmvif->ap_assoc_sta_count--;
-		iwl_mvm_mac_ctxt_changed(mvm, vif, false, NULL);
-	}
-
 	mutex_unlock(&mvm->mutex);
 }
 
@@ -2380,6 +2374,10 @@ static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 		ret = 0;
 	} else if (old_state == IEEE80211_STA_AUTH &&
 		   new_state == IEEE80211_STA_ASSOC) {
+		if (vif->type == NL80211_IFTYPE_AP) {
+			mvmvif->ap_assoc_sta_count++;
+			iwl_mvm_mac_ctxt_changed(mvm, vif, false, NULL);
+		}
 		ret = iwl_mvm_update_sta(mvm, vif, sta);
 		if (ret == 0)
 			iwl_mvm_rs_rate_init(mvm, sta,
@@ -2406,6 +2404,10 @@ static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 		ret = 0;
 	} else if (old_state == IEEE80211_STA_ASSOC &&
 		   new_state == IEEE80211_STA_AUTH) {
+		if (vif->type == NL80211_IFTYPE_AP) {
+			mvmvif->ap_assoc_sta_count--;
+			iwl_mvm_mac_ctxt_changed(mvm, vif, false, NULL);
+		}
 		ret = 0;
 	} else if (old_state == IEEE80211_STA_AUTH &&
 		   new_state == IEEE80211_STA_NONE) {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 2c9675b..b556e33 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -278,11 +278,6 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 	if (sta_id == IWL_MVM_STATION_COUNT)
 		return -ENOSPC;
 
-	if (vif->type == NL80211_IFTYPE_AP) {
-		mvmvif->ap_assoc_sta_count++;
-		iwl_mvm_mac_ctxt_changed(mvm, vif, false, NULL);
-	}
-
 	spin_lock_init(&mvm_sta->lock);
 
 	mvm_sta->sta_id = sta_id;
-- 
2.5.0

