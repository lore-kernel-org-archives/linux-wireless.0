Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47816 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759964Ab3BZV2L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2013 16:28:11 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/4] iwlwifi: mvm: fix AP/GO mode station removal
Date: Tue, 26 Feb 2013 22:27:55 +0100
Message-Id: <1361914077-18749-2-git-send-email-johannes@sipsolutions.net> (sfid-20130226_222817_203537_47B77C7F)
In-Reply-To: <1361914077-18749-1-git-send-email-johannes@sipsolutions.net>
References: <1361914034.8440.27.camel@jlt4.sipsolutions.net>
 <1361914077-18749-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When stations are removed while packets are in the queue,
we drain the queues first, and then remove the stations.
If this happens in AP mode while the interface is removed
the MAC context might be removed from the firmware before
we removed the station(s), resulting in a SYSASSERT 3421.
This is because we remove the MAC context from the FW in
stop_ap(), but only flush the station drain work later in
remove_interface().

Refactor the code a bit to have a common MAC context
removal preparation first to solve this.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index e8264e1..7e169b0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -557,11 +557,9 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 	return ret;
 }
 
-static void iwl_mvm_mac_remove_interface(struct ieee80211_hw *hw,
-					 struct ieee80211_vif *vif)
+static void iwl_mvm_prepare_mac_removal(struct iwl_mvm *mvm,
+					struct ieee80211_vif *vif)
 {
-	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	u32 tfd_msk = 0, ac;
 
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
@@ -594,12 +592,21 @@ static void iwl_mvm_mac_remove_interface(struct ieee80211_hw *hw,
 		 */
 		flush_work(&mvm->sta_drained_wk);
 	}
+}
+
+static void iwl_mvm_mac_remove_interface(struct ieee80211_hw *hw,
+					 struct ieee80211_vif *vif)
+{
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+
+	iwl_mvm_prepare_mac_removal(mvm, vif);
 
 	mutex_lock(&mvm->mutex);
 
 	/*
 	 * For AP/GO interface, the tear down of the resources allocated to the
-	 * interface should be handled as part of the bss_info_changed flow.
+	 * interface is be handled as part of the stop_ap flow.
 	 */
 	if (vif->type == NL80211_IFTYPE_AP) {
 		iwl_mvm_dealloc_int_sta(mvm, &mvmvif->bcast_sta);
@@ -763,6 +770,8 @@ static void iwl_mvm_stop_ap(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 
+	iwl_mvm_prepare_mac_removal(mvm, vif);
+
 	mutex_lock(&mvm->mutex);
 
 	mvmvif->ap_active = false;
-- 
1.8.0

