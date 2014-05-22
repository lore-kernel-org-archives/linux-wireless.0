Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:50708 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbaEVHYP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 03:24:15 -0400
Received: by mail-wg0-f43.google.com with SMTP id l18so2942834wgh.2
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2014 00:24:13 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/11] iwlwifi: mvm: pass force_assoc_off all the way down to avoid hacks
Date: Thu, 22 May 2014 10:23:51 +0300
Message-Id: <1400743435-702-7-git-send-email-egrumbach@gmail.com> (sfid-20140522_092728_686274_0B52F9FA)
In-Reply-To: <537DA58C.5050003@gmail.com>
References: <537DA58C.5050003@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

In some cases, we need to force the association to be off in the
MAC_CONTEXT_CMD command we send to the firmware.  Instead of having to
hack the vif->bss_conf.assoc value, pass it all the way down the call
chain.

Additionally, for the iwl_mvm_mac_ctxt_add() case, we *always* set
forced_assoc_off to true, so we can remove the hack in the d3 code
that was forcing it to off by hacking the bss_conf.assoc value.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c       |  6 ++----
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c | 13 ++++++++-----
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 12 ++++++------
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  3 ++-
 4 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 7dc71f3..48c192d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -663,10 +663,8 @@ static int iwl_mvm_d3_reprogram(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	if (WARN_ON(!vif->bss_conf.assoc))
 		return -EINVAL;
-	/* hack */
-	vif->bss_conf.assoc = false;
+
 	ret = iwl_mvm_mac_ctxt_add(mvm, vif);
-	vif->bss_conf.assoc = true;
 	if (ret)
 		return ret;
 
@@ -702,7 +700,7 @@ static int iwl_mvm_d3_reprogram(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		return ret;
 	rcu_assign_pointer(mvm->fw_id_to_mac_id[mvmvif->ap_sta_id], ap_sta);
 
-	ret = iwl_mvm_mac_ctxt_changed(mvm, vif);
+	ret = iwl_mvm_mac_ctxt_changed(mvm, vif, false);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index fed012f..8b53027 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -1109,12 +1109,12 @@ static int iwl_mvm_mac_ctxt_cmd_go(struct iwl_mvm *mvm,
 }
 
 static int iwl_mvm_mac_ctx_send(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-				u32 action)
+				u32 action, bool force_assoc_off)
 {
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
 		return iwl_mvm_mac_ctxt_cmd_sta(mvm, vif, action,
-						action == FW_CTXT_ACTION_ADD);
+						force_assoc_off);
 		break;
 	case NL80211_IFTYPE_AP:
 		if (!vif->p2p)
@@ -1144,7 +1144,8 @@ int iwl_mvm_mac_ctxt_add(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 		      vif->addr, ieee80211_vif_type_p2p(vif)))
 		return -EIO;
 
-	ret = iwl_mvm_mac_ctx_send(mvm, vif, FW_CTXT_ACTION_ADD);
+	ret = iwl_mvm_mac_ctx_send(mvm, vif, FW_CTXT_ACTION_ADD,
+				   true);
 	if (ret)
 		return ret;
 
@@ -1155,7 +1156,8 @@ int iwl_mvm_mac_ctxt_add(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	return 0;
 }
 
-int iwl_mvm_mac_ctxt_changed(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
+int iwl_mvm_mac_ctxt_changed(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+			     bool force_assoc_off)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 
@@ -1163,7 +1165,8 @@ int iwl_mvm_mac_ctxt_changed(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 		      vif->addr, ieee80211_vif_type_p2p(vif)))
 		return -EIO;
 
-	return iwl_mvm_mac_ctx_send(mvm, vif, FW_CTXT_ACTION_MODIFY);
+	return iwl_mvm_mac_ctx_send(mvm, vif, FW_CTXT_ACTION_MODIFY,
+				    force_assoc_off);
 }
 
 int iwl_mvm_mac_ctxt_remove(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 7411f12..1146cfb 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1271,7 +1271,7 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 	if (changes & BSS_CHANGED_ASSOC && bss_conf->assoc)
 		iwl_mvm_mac_ctxt_recalc_tsf_id(mvm, vif);
 
-	ret = iwl_mvm_mac_ctxt_changed(mvm, vif);
+	ret = iwl_mvm_mac_ctxt_changed(mvm, vif, false);
 	if (ret)
 		IWL_ERR(mvm, "failed to update MAC %pM\n", vif->addr);
 
@@ -1431,7 +1431,7 @@ static int iwl_mvm_start_ap_ibss(struct ieee80211_hw *hw,
 
 	/* Need to update the P2P Device MAC (only GO, IBSS is single vif) */
 	if (vif->p2p && mvm->p2p_device_vif)
-		iwl_mvm_mac_ctxt_changed(mvm, mvm->p2p_device_vif);
+		iwl_mvm_mac_ctxt_changed(mvm, mvm->p2p_device_vif, false);
 
 	iwl_mvm_ref(mvm, IWL_MVM_REF_AP_IBSS);
 
@@ -1471,7 +1471,7 @@ static void iwl_mvm_stop_ap_ibss(struct ieee80211_hw *hw,
 
 	/* Need to update the P2P Device MAC (only GO, IBSS is single vif) */
 	if (vif->p2p && mvm->p2p_device_vif)
-		iwl_mvm_mac_ctxt_changed(mvm, mvm->p2p_device_vif);
+		iwl_mvm_mac_ctxt_changed(mvm, mvm->p2p_device_vif, false);
 
 	iwl_mvm_update_quotas(mvm, NULL);
 	iwl_mvm_send_rm_bcast_sta(mvm, &mvmvif->bcast_sta);
@@ -1498,7 +1498,7 @@ iwl_mvm_bss_info_changed_ap_ibss(struct iwl_mvm *mvm,
 
 	if (changes & (BSS_CHANGED_ERP_CTS_PROT | BSS_CHANGED_HT |
 		       BSS_CHANGED_BANDWIDTH) &&
-	    iwl_mvm_mac_ctxt_changed(mvm, vif))
+	    iwl_mvm_mac_ctxt_changed(mvm, vif, false))
 		IWL_ERR(mvm, "failed to update MAC %pM\n", vif->addr);
 
 	/* Need to send a new beacon template to the FW */
@@ -1799,7 +1799,7 @@ static int iwl_mvm_mac_conf_tx(struct ieee80211_hw *hw,
 		int ret;
 
 		mutex_lock(&mvm->mutex);
-		ret = iwl_mvm_mac_ctxt_changed(mvm, vif);
+		ret = iwl_mvm_mac_ctxt_changed(mvm, vif, false);
 		mutex_unlock(&mvm->mutex);
 		return ret;
 	}
@@ -2255,7 +2255,7 @@ static int iwl_mvm_assign_vif_chanctx(struct ieee80211_hw *hw,
 	/* Handle binding during CSA */
 	if (vif->type == NL80211_IFTYPE_AP) {
 		iwl_mvm_update_quotas(mvm, vif);
-		iwl_mvm_mac_ctxt_changed(mvm, vif);
+		iwl_mvm_mac_ctxt_changed(mvm, vif, false);
 	}
 
 	goto out_unlock;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 6ccc88b..da8dc14 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -814,7 +814,8 @@ void iwl_mvm_phy_ctxt_unref(struct iwl_mvm *mvm,
 int iwl_mvm_mac_ctxt_init(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 void iwl_mvm_mac_ctxt_release(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 int iwl_mvm_mac_ctxt_add(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
-int iwl_mvm_mac_ctxt_changed(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
+int iwl_mvm_mac_ctxt_changed(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+			     bool force_assoc_off);
 int iwl_mvm_mac_ctxt_remove(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 u32 iwl_mvm_mac_get_queues_mask(struct iwl_mvm *mvm,
 				struct ieee80211_vif *vif);
-- 
1.8.3.2

