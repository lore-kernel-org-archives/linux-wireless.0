Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41042 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752310AbdG1O0t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 10:26:49 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 28 Jul 2017 17:23:35 +0300
Message-Id: <20170728142337.19183-23-luca@coelho.fi> (sfid-20170728_162700_601308_16208E58)
In-Reply-To: <20170728142337.19183-1-luca@coelho.fi>
References: <20170728142337.19183-1-luca@coelho.fi>
Subject: [PATCH 22/24] iwlwifi: mvm: rename p2p-specific sta functions to include p2p in the names
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

The iwl_mvm_add_bcast_sta() and the iwl_mvm_rm_bcast_sta() functions
are only called in P2P flows.  Add _p2p_ to the function names to make
this explicit.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      | 4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h      | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index b8373923cfa9..d0fd46f9597c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1428,7 +1428,7 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 		if (ret)
 			goto out_unref_phy;
 
-		ret = iwl_mvm_add_bcast_sta(mvm, vif);
+		ret = iwl_mvm_add_p2p_bcast_sta(mvm, vif);
 		if (ret)
 			goto out_unbind;
 
@@ -1558,7 +1558,7 @@ static void iwl_mvm_mac_remove_interface(struct ieee80211_hw *hw,
 
 	if (vif->type == NL80211_IFTYPE_P2P_DEVICE) {
 		mvm->p2p_device_vif = NULL;
-		iwl_mvm_rm_bcast_sta(mvm, vif);
+		iwl_mvm_rm_p2p_bcast_sta(mvm, vif);
 		iwl_mvm_binding_remove_vif(mvm, vif);
 		iwl_mvm_phy_ctxt_unref(mvm, mvmvif->phy_ctxt);
 		mvmvif->phy_ctxt = NULL;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index b196acd18252..5c707c62f1dc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -2106,7 +2106,7 @@ int iwl_mvm_alloc_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
  * @mvm: the mvm component
  * @vif: the interface to which the broadcast station is added
  * @bsta: the broadcast station to add. */
-int iwl_mvm_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
+int iwl_mvm_add_p2p_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mvm_int_sta *bsta = &mvmvif->bcast_sta;
@@ -2137,7 +2137,7 @@ void iwl_mvm_dealloc_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
  * Send the FW a request to remove the station from it's internal data
  * structures, and in addition remove it from the local data structure.
  */
-int iwl_mvm_rm_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
+int iwl_mvm_rm_p2p_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 {
 	int ret;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
index 05fecbe87da4..6f1d358f3008 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
@@ -533,9 +533,9 @@ void iwl_mvm_del_aux_sta(struct iwl_mvm *mvm);
 
 int iwl_mvm_alloc_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 int iwl_mvm_send_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
-int iwl_mvm_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
+int iwl_mvm_add_p2p_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 int iwl_mvm_send_rm_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
-int iwl_mvm_rm_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
+int iwl_mvm_rm_p2p_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 int iwl_mvm_add_mcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 int iwl_mvm_rm_mcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 int iwl_mvm_allocate_int_sta(struct iwl_mvm *mvm,
-- 
2.13.2
