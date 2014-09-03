Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:64779 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108AbaICT5X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:57:23 -0400
Received: by mail-wg0-f49.google.com with SMTP id y10so9029234wgg.20
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 12:57:22 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 36/36] iwlwifi: mvm: clean up AUX station handling
Date: Wed,  3 Sep 2014 22:56:24 +0300
Message-Id: <1409774184-24665-36-git-send-email-egrumbach@gmail.com> (sfid-20140903_220114_846722_C9F1A397)
In-Reply-To: <540771E5.6080908@gmail.com>
References: <540771E5.6080908@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The auxiliary station is being handled using the internal
station helper functions, clean that up and make the helpers
static.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  2 +-
 drivers/net/wireless/iwlwifi/mvm/sta.c      | 15 ++++++++++++---
 drivers/net/wireless/iwlwifi/mvm/sta.h      |  5 +----
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 78ed6bc..8d1d4b4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -886,7 +886,7 @@ static void iwl_mvm_mac_stop(struct ieee80211_hw *hw)
 	/* async_handlers_list is empty and will stay empty: HW is stopped */
 
 	/* the fw is stopped, the aux sta is dead: clean up driver state */
-	iwl_mvm_dealloc_int_sta(mvm, &mvm->aux_sta);
+	iwl_mvm_del_aux_sta(mvm);
 
 	mutex_unlock(&mvm->mutex);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index ef61979..dd9f3a4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -464,8 +464,9 @@ int iwl_mvm_rm_sta_id(struct iwl_mvm *mvm,
 	return ret;
 }
 
-int iwl_mvm_allocate_int_sta(struct iwl_mvm *mvm, struct iwl_mvm_int_sta *sta,
-			     u32 qmask, enum nl80211_iftype iftype)
+static int iwl_mvm_allocate_int_sta(struct iwl_mvm *mvm,
+				    struct iwl_mvm_int_sta *sta,
+				    u32 qmask, enum nl80211_iftype iftype)
 {
 	if (!test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status)) {
 		sta->sta_id = iwl_mvm_find_free_sta_id(mvm, iftype);
@@ -480,7 +481,8 @@ int iwl_mvm_allocate_int_sta(struct iwl_mvm *mvm, struct iwl_mvm_int_sta *sta,
 	return 0;
 }
 
-void iwl_mvm_dealloc_int_sta(struct iwl_mvm *mvm, struct iwl_mvm_int_sta *sta)
+static void iwl_mvm_dealloc_int_sta(struct iwl_mvm *mvm,
+				    struct iwl_mvm_int_sta *sta)
 {
 	RCU_INIT_POINTER(mvm->fw_id_to_mac_id[sta->sta_id], NULL);
 	memset(sta, 0, sizeof(struct iwl_mvm_int_sta));
@@ -550,6 +552,13 @@ int iwl_mvm_add_aux_sta(struct iwl_mvm *mvm)
 	return ret;
 }
 
+void iwl_mvm_del_aux_sta(struct iwl_mvm *mvm)
+{
+	lockdep_assert_held(&mvm->mutex);
+
+	iwl_mvm_dealloc_int_sta(mvm, &mvm->aux_sta);
+}
+
 /*
  * Send the add station command for the vif's broadcast station.
  * Assumes that the station was already allocated.
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.h b/drivers/net/wireless/iwlwifi/mvm/sta.h
index 15984fe..aeb3a7f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.h
@@ -389,10 +389,7 @@ int iwl_mvm_sta_tx_agg_flush(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			    struct ieee80211_sta *sta, u16 tid);
 
 int iwl_mvm_add_aux_sta(struct iwl_mvm *mvm);
-int iwl_mvm_allocate_int_sta(struct iwl_mvm *mvm, struct iwl_mvm_int_sta *sta,
-			     u32 qmask, enum nl80211_iftype iftype);
-void iwl_mvm_dealloc_int_sta(struct iwl_mvm *mvm,
-			     struct iwl_mvm_int_sta *sta);
+void iwl_mvm_del_aux_sta(struct iwl_mvm *mvm);
 
 int iwl_mvm_alloc_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 int iwl_mvm_send_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
-- 
1.9.1

