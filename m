Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:57099 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751956AbbJEOhP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 10:37:15 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Oct 2015 17:36:38 +0300
Message-Id: <1444055820-27506-7-git-send-email-luca@coelho.fi> (sfid-20151005_163813_874958_84E8084C)
In-Reply-To: <1444050759.27220.15.camel@coelho.fi>
References: <1444050759.27220.15.camel@coelho.fi>
Subject: [PATCH 07/29] iwlwifi: mvm: Correctly update MAC context on add/del station
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

Commit "iwlwifi: mvm: don't ask beacons when AP vif and no
assoc sta" directly called iwl_mvm_mac_ctxt_cmd_ap() to update the
MAC context when adding/removing a station. However, this ignores
the case that the vif is actually a P2P GO.

Fix this by calling iwl_mvm_mac_ctxt_changed() that handles P2P GO
case as well.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c | 6 +++---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 2 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h      | 4 ----
 drivers/net/wireless/iwlwifi/mvm/sta.c      | 2 +-
 4 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 5af0090..3615650 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -1126,9 +1126,9 @@ static void iwl_mvm_mac_ctxt_cmd_fill_ap(struct iwl_mvm *mvm,
 	ctxt_ap->beacon_template = cpu_to_le32(mvmvif->id);
 }
 
-int iwl_mvm_mac_ctxt_cmd_ap(struct iwl_mvm *mvm,
-			    struct ieee80211_vif *vif,
-			    u32 action)
+static int iwl_mvm_mac_ctxt_cmd_ap(struct iwl_mvm *mvm,
+				   struct ieee80211_vif *vif,
+				   u32 action)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mac_ctx_cmd cmd = {};
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 4c497fe..d7275a5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2616,7 +2616,7 @@ static void iwl_mvm_sta_pre_rcu_remove(struct ieee80211_hw *hw,
 
 	if (mvm_sta->vif->type == NL80211_IFTYPE_AP) {
 		mvmvif->ap_assoc_sta_count--;
-		iwl_mvm_mac_ctxt_cmd_ap(mvm, vif, FW_CTXT_ACTION_MODIFY);
+		iwl_mvm_mac_ctxt_changed(mvm, vif, false, NULL);
 	}
 
 	mutex_unlock(&mvm->mutex);
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index cf1f514..5e02736 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1129,10 +1129,6 @@ void iwl_mvm_mac_ctxt_recalc_tsf_id(struct iwl_mvm *mvm,
 				    struct ieee80211_vif *vif);
 unsigned long iwl_mvm_get_used_hw_queues(struct iwl_mvm *mvm,
 					 struct ieee80211_vif *exclude_vif);
-int iwl_mvm_mac_ctxt_cmd_ap(struct iwl_mvm *mvm,
-			    struct ieee80211_vif *vif,
-			    u32 action);
-
 /* Bindings */
 int iwl_mvm_binding_add_vif(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 int iwl_mvm_binding_remove_vif(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 18ca030..4967990 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -277,7 +277,7 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 
 	if (vif->type == NL80211_IFTYPE_AP) {
 		mvmvif->ap_assoc_sta_count++;
-		iwl_mvm_mac_ctxt_cmd_ap(mvm, vif, FW_CTXT_ACTION_MODIFY);
+		iwl_mvm_mac_ctxt_changed(mvm, vif, false, NULL);
 	}
 
 	spin_lock_init(&mvm_sta->lock);
-- 
2.5.3

