Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:53947 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027AbbLUUwb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 15:52:31 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 36/45] iwlwifi: mvm: change iwl_mvm_get_key_sta_id() to return the station
Date: Mon, 21 Dec 2015 22:50:37 +0200
Message-Id: <1450731046-2796-36-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151221_220100_507907_9065AFD8)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The code in iwl_mvm_update_tkip_key() is now pretty much duplicated
with the code in iwl_mvm_get_key_sta_id() doing the station ID lookup
again after it was already done. Change iwl_mvm_get_key_sta_id() to
iwl_mvm_get_key_sta(), returning the mvm_sta pointer, to allow that
duplicate code to be removed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 53 ++++++++++++----------------
 1 file changed, 22 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index bfa4699..2c9675b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1228,17 +1228,14 @@ static int iwl_mvm_set_fw_key_idx(struct iwl_mvm *mvm)
 	return max_offs;
 }
 
-static u8 iwl_mvm_get_key_sta_id(struct iwl_mvm *mvm,
-				 struct ieee80211_vif *vif,
-				 struct ieee80211_sta *sta)
+static struct iwl_mvm_sta *iwl_mvm_get_key_sta(struct iwl_mvm *mvm,
+					       struct ieee80211_vif *vif,
+					       struct ieee80211_sta *sta)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 
-	if (sta) {
-		struct iwl_mvm_sta *mvm_sta = iwl_mvm_sta_from_mac80211(sta);
-
-		return mvm_sta->sta_id;
-	}
+	if (sta)
+		return iwl_mvm_sta_from_mac80211(sta);
 
 	/*
 	 * The device expects GTKs for station interfaces to be
@@ -1257,12 +1254,12 @@ static u8 iwl_mvm_get_key_sta_id(struct iwl_mvm *mvm,
 		 * be the AP ID, and no station was passed by mac80211.
 		 */
 		if (IS_ERR_OR_NULL(sta))
-			return IWL_MVM_STATION_COUNT;
+			return NULL;
 
-		return sta_id;
+		return iwl_mvm_sta_from_mac80211(sta);
 	}
 
-	return IWL_MVM_STATION_COUNT;
+	return NULL;
 }
 
 static int iwl_mvm_send_sta_key(struct iwl_mvm *mvm,
@@ -1479,6 +1476,7 @@ int iwl_mvm_set_sta_key(struct iwl_mvm *mvm,
 			u8 key_offset)
 {
 	bool mcast = !(keyconf->flags & IEEE80211_KEY_FLAG_PAIRWISE);
+	struct iwl_mvm_sta *mvm_sta;
 	u8 sta_id;
 	int ret;
 	static const u8 __maybe_unused zero_addr[ETH_ALEN] = {0};
@@ -1486,11 +1484,12 @@ int iwl_mvm_set_sta_key(struct iwl_mvm *mvm,
 	lockdep_assert_held(&mvm->mutex);
 
 	/* Get the station id from the mvm local station table */
-	sta_id = iwl_mvm_get_key_sta_id(mvm, vif, sta);
-	if (sta_id == IWL_MVM_STATION_COUNT) {
-		IWL_ERR(mvm, "Failed to find station id\n");
+	mvm_sta = iwl_mvm_get_key_sta(mvm, vif, sta);
+	if (!mvm_sta) {
+		IWL_ERR(mvm, "Failed to find station\n");
 		return -EINVAL;
 	}
+	sta_id = mvm_sta->sta_id;
 
 	if (keyconf->cipher == WLAN_CIPHER_SUITE_AES_CMAC) {
 		ret = iwl_mvm_send_sta_igtk(mvm, keyconf, sta_id, false);
@@ -1566,13 +1565,14 @@ int iwl_mvm_remove_sta_key(struct iwl_mvm *mvm,
 			   struct ieee80211_key_conf *keyconf)
 {
 	bool mcast = !(keyconf->flags & IEEE80211_KEY_FLAG_PAIRWISE);
-	u8 sta_id;
+	struct iwl_mvm_sta *mvm_sta;
+	u8 sta_id = IWL_MVM_STATION_COUNT;
 	int ret, i;
 
 	lockdep_assert_held(&mvm->mutex);
 
-	/* Get the station id from the mvm local station table */
-	sta_id = iwl_mvm_get_key_sta_id(mvm, vif, sta);
+	/* Get the station from the mvm local station table */
+	mvm_sta = iwl_mvm_get_key_sta(mvm, vif, sta);
 
 	IWL_DEBUG_WEP(mvm, "mvm remove dynamic key: idx=%d sta=%d\n",
 		      keyconf->keyidx, sta_id);
@@ -1593,11 +1593,13 @@ int iwl_mvm_remove_sta_key(struct iwl_mvm *mvm,
 	}
 	mvm->fw_key_deleted[keyconf->hw_key_idx] = 0;
 
-	if (sta_id == IWL_MVM_STATION_COUNT) {
+	if (!mvm_sta) {
 		IWL_DEBUG_WEP(mvm, "station non-existent, early return.\n");
 		return 0;
 	}
 
+	sta_id = mvm_sta->sta_id;
+
 	ret = __iwl_mvm_remove_sta_key(mvm, sta_id, keyconf, mcast);
 	if (ret)
 		return ret;
@@ -1617,24 +1619,13 @@ void iwl_mvm_update_tkip_key(struct iwl_mvm *mvm,
 			     u16 *phase1key)
 {
 	struct iwl_mvm_sta *mvm_sta;
-	u8 sta_id;
 	bool mcast = !(keyconf->flags & IEEE80211_KEY_FLAG_PAIRWISE);
 
 	rcu_read_lock();
 
-	sta_id = iwl_mvm_get_key_sta_id(mvm, vif, sta);
-	if (WARN_ON_ONCE(sta_id == IWL_MVM_STATION_COUNT))
+	mvm_sta = iwl_mvm_get_key_sta(mvm, vif, sta);
+	if (WARN_ON_ONCE(!mvm_sta))
 		goto unlock;
-
-	if (!sta) {
-		sta = rcu_dereference(mvm->fw_id_to_mac_id[sta_id]);
-		if (WARN_ON(IS_ERR_OR_NULL(sta))) {
-			rcu_read_unlock();
-			return;
-		}
-	}
-
-	mvm_sta = iwl_mvm_sta_from_mac80211(sta);
 	iwl_mvm_send_sta_key(mvm, mvm_sta, keyconf, mcast,
 			     iv32, phase1key, CMD_ASYNC, keyconf->hw_key_idx);
 
-- 
2.5.0

