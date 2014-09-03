Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:58975 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125AbaICT5W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:57:22 -0400
Received: by mail-wg0-f49.google.com with SMTP id y10so9015903wgg.8
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 12:57:21 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 35/36] iwlwifi: mvm: clean up broadcast station handling
Date: Wed,  3 Sep 2014 22:56:23 +0300
Message-Id: <1409774184-24665-35-git-send-email-egrumbach@gmail.com> (sfid-20140903_215754_634687_68D753AD)
In-Reply-To: <540771E5.6080908@gmail.com>
References: <540771E5.6080908@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Unify all the functions that handle the per-interface broadcast
station and make them have mvm and vif parameters. While at it,
add a new function to allocate the broadcast station instead of
open-coding it, and make the combined alloc+send and free+send
functions use the alloc/free & send functions.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 26 ++++--------
 drivers/net/wireless/iwlwifi/mvm/sta.c      | 61 ++++++++++++++++++++---------
 drivers/net/wireless/iwlwifi/mvm/sta.h      | 15 +++----
 3 files changed, 57 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index ac2b11a..78ed6bc 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -971,19 +971,7 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 	 */
 	if (vif->type == NL80211_IFTYPE_AP ||
 	    vif->type == NL80211_IFTYPE_ADHOC) {
-		u32 qmask = iwl_mvm_mac_get_queues_mask(mvm, vif);
-
-		/*
-		 * The firmware defines the TFD queue mask to only be relevant
-		 * for *unicast* queues, so the multicast (CAB) queue should
-		 * be excluded.
-		 */
-		if (vif->type == NL80211_IFTYPE_AP)
-			qmask &= ~BIT(vif->cab_queue);
-
-		ret = iwl_mvm_allocate_int_sta(mvm, &mvmvif->bcast_sta,
-					       qmask,
-					       ieee80211_vif_type_p2p(vif));
+		ret = iwl_mvm_alloc_bcast_sta(mvm, vif);
 		if (ret) {
 			IWL_ERR(mvm, "Failed to allocate bcast sta\n");
 			goto out_release;
@@ -1031,7 +1019,7 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 		if (ret)
 			goto out_unref_phy;
 
-		ret = iwl_mvm_add_bcast_sta(mvm, vif, &mvmvif->bcast_sta);
+		ret = iwl_mvm_add_bcast_sta(mvm, vif);
 		if (ret)
 			goto out_unbind;
 
@@ -1128,13 +1116,13 @@ static void iwl_mvm_mac_remove_interface(struct ieee80211_hw *hw,
 			mvm->noa_duration = 0;
 		}
 #endif
-		iwl_mvm_dealloc_int_sta(mvm, &mvmvif->bcast_sta);
+		iwl_mvm_dealloc_bcast_sta(mvm, vif);
 		goto out_release;
 	}
 
 	if (vif->type == NL80211_IFTYPE_P2P_DEVICE) {
 		mvm->p2p_device_vif = NULL;
-		iwl_mvm_rm_bcast_sta(mvm, &mvmvif->bcast_sta);
+		iwl_mvm_rm_bcast_sta(mvm, vif);
 		iwl_mvm_binding_remove_vif(mvm, vif);
 		iwl_mvm_phy_ctxt_unref(mvm, mvmvif->phy_ctxt);
 		mvmvif->phy_ctxt = NULL;
@@ -1633,7 +1621,7 @@ static int iwl_mvm_start_ap_ibss(struct ieee80211_hw *hw,
 
 	/* Send the bcast station. At this stage the TBTT and DTIM time events
 	 * are added and applied to the scheduler */
-	ret = iwl_mvm_send_bcast_sta(mvm, vif, &mvmvif->bcast_sta);
+	ret = iwl_mvm_send_add_bcast_sta(mvm, vif);
 	if (ret)
 		goto out_unbind;
 
@@ -1665,7 +1653,7 @@ static int iwl_mvm_start_ap_ibss(struct ieee80211_hw *hw,
 out_quota_failed:
 	iwl_mvm_power_update_mac(mvm);
 	mvmvif->ap_ibss_active = false;
-	iwl_mvm_send_rm_bcast_sta(mvm, &mvmvif->bcast_sta);
+	iwl_mvm_send_rm_bcast_sta(mvm, vif);
 out_unbind:
 	iwl_mvm_binding_remove_vif(mvm, vif);
 out_remove:
@@ -1710,7 +1698,7 @@ static void iwl_mvm_stop_ap_ibss(struct ieee80211_hw *hw,
 		iwl_mvm_mac_ctxt_changed(mvm, mvm->p2p_device_vif, false, NULL);
 
 	iwl_mvm_update_quotas(mvm, NULL);
-	iwl_mvm_send_rm_bcast_sta(mvm, &mvmvif->bcast_sta);
+	iwl_mvm_send_rm_bcast_sta(mvm, vif);
 	iwl_mvm_binding_remove_vif(mvm, vif);
 
 	iwl_mvm_power_update_mac(mvm);
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index ccfc256..ef61979 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -558,10 +558,10 @@ int iwl_mvm_add_aux_sta(struct iwl_mvm *mvm)
  * @vif: the interface to which the broadcast station is added
  * @bsta: the broadcast station to add.
  */
-int iwl_mvm_send_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-			   struct iwl_mvm_int_sta *bsta)
+int iwl_mvm_send_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_mvm_int_sta *bsta = &mvmvif->bcast_sta;
 	static const u8 _baddr[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
 	const u8 *baddr = _baddr;
 
@@ -579,19 +579,40 @@ int iwl_mvm_send_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 /* Send the FW a request to remove the station from it's internal data
  * structures, but DO NOT remove the entry from the local data structures. */
-int iwl_mvm_send_rm_bcast_sta(struct iwl_mvm *mvm,
-			      struct iwl_mvm_int_sta *bsta)
+int iwl_mvm_send_rm_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 {
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	int ret;
 
 	lockdep_assert_held(&mvm->mutex);
 
-	ret = iwl_mvm_rm_sta_common(mvm, bsta->sta_id);
+	ret = iwl_mvm_rm_sta_common(mvm, mvmvif->bcast_sta.sta_id);
 	if (ret)
 		IWL_WARN(mvm, "Failed sending remove station\n");
 	return ret;
 }
 
+int iwl_mvm_alloc_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	u32 qmask;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	qmask = iwl_mvm_mac_get_queues_mask(mvm, vif);
+
+	/*
+	 * The firmware defines the TFD queue mask to only be relevant
+	 * for *unicast* queues, so the multicast (CAB) queue shouldn't
+	 * be included.
+	 */
+	if (vif->type == NL80211_IFTYPE_AP)
+		qmask &= ~BIT(vif->cab_queue);
+
+	return iwl_mvm_allocate_int_sta(mvm, &mvmvif->bcast_sta, qmask,
+					ieee80211_vif_type_p2p(vif));
+}
+
 /* Allocate a new station entry for the broadcast station to the given vif,
  * and send it to the FW.
  * Note that each P2P mac should have its own broadcast station.
@@ -599,45 +620,47 @@ int iwl_mvm_send_rm_bcast_sta(struct iwl_mvm *mvm,
  * @mvm: the mvm component
  * @vif: the interface to which the broadcast station is added
  * @bsta: the broadcast station to add. */
-int iwl_mvm_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-			  struct iwl_mvm_int_sta *bsta)
+int iwl_mvm_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	static const u8 baddr[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
-	u32 qmask;
+	struct iwl_mvm_int_sta *bsta = &mvmvif->bcast_sta;
 	int ret;
 
 	lockdep_assert_held(&mvm->mutex);
 
-	qmask = iwl_mvm_mac_get_queues_mask(mvm, vif);
-	ret = iwl_mvm_allocate_int_sta(mvm, bsta, qmask,
-				       ieee80211_vif_type_p2p(vif));
+	ret = iwl_mvm_alloc_bcast_sta(mvm, vif);
 	if (ret)
 		return ret;
 
-	ret = iwl_mvm_add_int_sta_common(mvm, bsta, baddr,
-					 mvmvif->id, mvmvif->color);
+	ret = iwl_mvm_send_add_bcast_sta(mvm, vif);
 
 	if (ret)
 		iwl_mvm_dealloc_int_sta(mvm, bsta);
+
 	return ret;
 }
 
+void iwl_mvm_dealloc_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+
+	iwl_mvm_dealloc_int_sta(mvm, &mvmvif->bcast_sta);
+}
+
 /*
  * Send the FW a request to remove the station from it's internal data
  * structures, and in addition remove it from the local data structure.
  */
-int iwl_mvm_rm_bcast_sta(struct iwl_mvm *mvm, struct iwl_mvm_int_sta *bsta)
+int iwl_mvm_rm_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 {
 	int ret;
 
 	lockdep_assert_held(&mvm->mutex);
 
-	ret = iwl_mvm_rm_sta_common(mvm, bsta->sta_id);
-	if (ret)
-		return ret;
+	ret = iwl_mvm_send_rm_bcast_sta(mvm, vif);
+
+	iwl_mvm_dealloc_bcast_sta(mvm, vif);
 
-	iwl_mvm_dealloc_int_sta(mvm, bsta);
 	return ret;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.h b/drivers/net/wireless/iwlwifi/mvm/sta.h
index ea4985e..15984fe 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.h
@@ -393,13 +393,14 @@ int iwl_mvm_allocate_int_sta(struct iwl_mvm *mvm, struct iwl_mvm_int_sta *sta,
 			     u32 qmask, enum nl80211_iftype iftype);
 void iwl_mvm_dealloc_int_sta(struct iwl_mvm *mvm,
 			     struct iwl_mvm_int_sta *sta);
-int iwl_mvm_send_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-			   struct iwl_mvm_int_sta *bsta);
-int iwl_mvm_send_rm_bcast_sta(struct iwl_mvm *mvm,
-			      struct iwl_mvm_int_sta *bsta);
-int iwl_mvm_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-			  struct iwl_mvm_int_sta *bsta);
-int iwl_mvm_rm_bcast_sta(struct iwl_mvm *mvm, struct iwl_mvm_int_sta *bsta);
+
+int iwl_mvm_alloc_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
+int iwl_mvm_send_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
+int iwl_mvm_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
+int iwl_mvm_send_rm_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
+int iwl_mvm_rm_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
+void iwl_mvm_dealloc_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
+
 void iwl_mvm_sta_drained_wk(struct work_struct *wk);
 void iwl_mvm_sta_modify_ps_wake(struct iwl_mvm *mvm,
 				struct ieee80211_sta *sta);
-- 
1.9.1

