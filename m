Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:23966 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932684AbbLPOXk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 09:23:40 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/2] iwlwifi: mvm: protect RCU dereference in iwl_mvm_get_key_sta_id
Date: Wed, 16 Dec 2015 16:23:37 +0200
Message-Id: <1450275817-16938-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151216_152344_351915_02C88EB1)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E91F275@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E91F275@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Properly protect the RCU dereference in iwl_mvm_get_key_sta_id() when
coming from iwl_mvm_update_tkip_key() which cannot hold the mvm->mutex
by moving the call into the RCU critical section.
Modify the check to use rcu_dereference_check() to permit this.

Fixes: 9513c5e18a0d ("iwlwifi: mvm: Avoid dereferencing sta if it was already flushed")
Reported-by: Laura Abbott <labbott@redhat.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/sta.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 354acbd..2b976b1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -1222,8 +1222,8 @@ static u8 iwl_mvm_get_key_sta_id(struct iwl_mvm *mvm,
 	    mvmvif->ap_sta_id != IWL_MVM_STATION_COUNT) {
 		u8 sta_id = mvmvif->ap_sta_id;
 
-		sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[sta_id],
-						lockdep_is_held(&mvm->mutex));
+		sta = rcu_dereference_check(mvm->fw_id_to_mac_id[sta_id],
+					    lockdep_is_held(&mvm->mutex));
 		/*
 		 * It is possible that the 'sta' parameter is NULL,
 		 * for example when a GTK is removed - the sta_id will then
@@ -1590,14 +1590,15 @@ void iwl_mvm_update_tkip_key(struct iwl_mvm *mvm,
 			     u16 *phase1key)
 {
 	struct iwl_mvm_sta *mvm_sta;
-	u8 sta_id = iwl_mvm_get_key_sta_id(mvm, vif, sta);
+	u8 sta_id;
 	bool mcast = !(keyconf->flags & IEEE80211_KEY_FLAG_PAIRWISE);
 
-	if (WARN_ON_ONCE(sta_id == IWL_MVM_STATION_COUNT))
-		return;
-
 	rcu_read_lock();
 
+	sta_id = iwl_mvm_get_key_sta_id(mvm, vif, sta);
+	if (WARN_ON_ONCE(sta_id == IWL_MVM_STATION_COUNT))
+		goto unlock;
+
 	if (!sta) {
 		sta = rcu_dereference(mvm->fw_id_to_mac_id[sta_id]);
 		if (WARN_ON(IS_ERR_OR_NULL(sta))) {
@@ -1609,6 +1610,8 @@ void iwl_mvm_update_tkip_key(struct iwl_mvm *mvm,
 	mvm_sta = iwl_mvm_sta_from_mac80211(sta);
 	iwl_mvm_send_sta_key(mvm, mvm_sta, keyconf, mcast,
 			     iv32, phase1key, CMD_ASYNC, keyconf->hw_key_idx);
+
+ unlock:
 	rcu_read_unlock();
 }
 
-- 
2.5.0

