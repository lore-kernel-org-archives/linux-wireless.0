Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:52938 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861AbaICT5P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:57:15 -0400
Received: by mail-we0-f179.google.com with SMTP id t60so9052659wes.38
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 12:57:14 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 30/36] iwlwifi: mvm: correct firmware disassoc command sequence
Date: Wed,  3 Sep 2014 22:56:18 +0300
Message-Id: <1409774184-24665-30-git-send-email-egrumbach@gmail.com> (sfid-20140903_220113_627902_480D6E6F)
In-Reply-To: <540771E5.6080908@gmail.com>
References: <540771E5.6080908@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The firmware would like to have a MAC context (unassoc)
before the AP station is removed (we do this) but would
like to keep the BSSID until after it is removed, so we
need to send two commands - one with the BSSID before
and one without the BSSID after.

In order to do this, we need to store the BSSID as it
will have been cleared by mac80211 by the time we get
notified of the disassociation. Also pass it around as
an override to the various functions needing it, and
keep taking it from the mac80211 data otherwise. This
avoids having to keep track of the BSSID in all modes.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c       |  2 +-
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c | 34 +++++++++++++++++------------
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 34 +++++++++++++++++++++++------
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  8 ++++++-
 4 files changed, 55 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 607dfdb..c17be0f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -702,7 +702,7 @@ static int iwl_mvm_d3_reprogram(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		return ret;
 	rcu_assign_pointer(mvm->fw_id_to_mac_id[mvmvif->ap_sta_id], ap_sta);
 
-	ret = iwl_mvm_mac_ctxt_changed(mvm, vif, false);
+	ret = iwl_mvm_mac_ctxt_changed(mvm, vif, false, NULL);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 7171d17..115bb36 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -590,6 +590,7 @@ static void iwl_mvm_mac_ctxt_set_ht_flags(struct iwl_mvm *mvm,
 static void iwl_mvm_mac_ctxt_cmd_common(struct iwl_mvm *mvm,
 					struct ieee80211_vif *vif,
 					struct iwl_mac_ctx_cmd *cmd,
+					const u8 *bssid_override,
 					u32 action)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
@@ -597,6 +598,7 @@ static void iwl_mvm_mac_ctxt_cmd_common(struct iwl_mvm *mvm,
 	bool ht_enabled = !!(vif->bss_conf.ht_operation_mode &
 			     IEEE80211_HT_OP_MODE_PROTECTION);
 	u8 cck_ack_rates, ofdm_ack_rates;
+	const u8 *bssid = bssid_override ?: vif->bss_conf.bssid;
 	int i;
 
 	cmd->id_and_color = cpu_to_le32(FW_CMD_ID_AND_COLOR(mvmvif->id,
@@ -629,8 +631,9 @@ static void iwl_mvm_mac_ctxt_cmd_common(struct iwl_mvm *mvm,
 	cmd->tsf_id = cpu_to_le32(mvmvif->tsf_id);
 
 	memcpy(cmd->node_addr, vif->addr, ETH_ALEN);
-	if (vif->bss_conf.bssid)
-		memcpy(cmd->bssid_addr, vif->bss_conf.bssid, ETH_ALEN);
+
+	if (bssid)
+		memcpy(cmd->bssid_addr, bssid, ETH_ALEN);
 	else
 		eth_broadcast_addr(cmd->bssid_addr);
 
@@ -699,7 +702,8 @@ static int iwl_mvm_mac_ctxt_send_cmd(struct iwl_mvm *mvm,
 
 static int iwl_mvm_mac_ctxt_cmd_sta(struct iwl_mvm *mvm,
 				    struct ieee80211_vif *vif,
-				    u32 action, bool force_assoc_off)
+				    u32 action, bool force_assoc_off,
+				    const u8 *bssid_override)
 {
 	struct iwl_mac_ctx_cmd cmd = {};
 	struct iwl_mac_data_sta *ctxt_sta;
@@ -707,7 +711,7 @@ static int iwl_mvm_mac_ctxt_cmd_sta(struct iwl_mvm *mvm,
 	WARN_ON(vif->type != NL80211_IFTYPE_STATION);
 
 	/* Fill the common data for all mac context types */
-	iwl_mvm_mac_ctxt_cmd_common(mvm, vif, &cmd, action);
+	iwl_mvm_mac_ctxt_cmd_common(mvm, vif, &cmd, bssid_override, action);
 
 	if (vif->p2p) {
 		struct ieee80211_p2p_noa_attr *noa =
@@ -788,7 +792,7 @@ static int iwl_mvm_mac_ctxt_cmd_listener(struct iwl_mvm *mvm,
 
 	WARN_ON(vif->type != NL80211_IFTYPE_MONITOR);
 
-	iwl_mvm_mac_ctxt_cmd_common(mvm, vif, &cmd, action);
+	iwl_mvm_mac_ctxt_cmd_common(mvm, vif, &cmd, NULL, action);
 
 	cmd.filter_flags = cpu_to_le32(MAC_FILTER_IN_PROMISC |
 				       MAC_FILTER_IN_CONTROL_AND_MGMT |
@@ -809,7 +813,7 @@ static int iwl_mvm_mac_ctxt_cmd_ibss(struct iwl_mvm *mvm,
 
 	WARN_ON(vif->type != NL80211_IFTYPE_ADHOC);
 
-	iwl_mvm_mac_ctxt_cmd_common(mvm, vif, &cmd, action);
+	iwl_mvm_mac_ctxt_cmd_common(mvm, vif, &cmd, NULL, action);
 
 	cmd.filter_flags = cpu_to_le32(MAC_FILTER_IN_BEACON |
 				       MAC_FILTER_IN_PROBE_REQUEST);
@@ -848,7 +852,7 @@ static int iwl_mvm_mac_ctxt_cmd_p2p_device(struct iwl_mvm *mvm,
 
 	WARN_ON(vif->type != NL80211_IFTYPE_P2P_DEVICE);
 
-	iwl_mvm_mac_ctxt_cmd_common(mvm, vif, &cmd, action);
+	iwl_mvm_mac_ctxt_cmd_common(mvm, vif, &cmd, NULL, action);
 
 	cmd.protection_flags |= cpu_to_le32(MAC_PROT_FLG_TGG_PROTECT);
 
@@ -1076,7 +1080,7 @@ static int iwl_mvm_mac_ctxt_cmd_ap(struct iwl_mvm *mvm,
 	WARN_ON(vif->type != NL80211_IFTYPE_AP || vif->p2p);
 
 	/* Fill the common data for all mac context types */
-	iwl_mvm_mac_ctxt_cmd_common(mvm, vif, &cmd, action);
+	iwl_mvm_mac_ctxt_cmd_common(mvm, vif, &cmd, NULL, action);
 
 	/*
 	 * pass probe requests and beacons from other APs (needed
@@ -1102,7 +1106,7 @@ static int iwl_mvm_mac_ctxt_cmd_go(struct iwl_mvm *mvm,
 	WARN_ON(vif->type != NL80211_IFTYPE_AP || !vif->p2p);
 
 	/* Fill the common data for all mac context types */
-	iwl_mvm_mac_ctxt_cmd_common(mvm, vif, &cmd, action);
+	iwl_mvm_mac_ctxt_cmd_common(mvm, vif, &cmd, NULL, action);
 
 	/*
 	 * pass probe requests and beacons from other APs (needed
@@ -1125,12 +1129,14 @@ static int iwl_mvm_mac_ctxt_cmd_go(struct iwl_mvm *mvm,
 }
 
 static int iwl_mvm_mac_ctx_send(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-				u32 action, bool force_assoc_off)
+				u32 action, bool force_assoc_off,
+				const u8 *bssid_override)
 {
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
 		return iwl_mvm_mac_ctxt_cmd_sta(mvm, vif, action,
-						force_assoc_off);
+						force_assoc_off,
+						bssid_override);
 		break;
 	case NL80211_IFTYPE_AP:
 		if (!vif->p2p)
@@ -1161,7 +1167,7 @@ int iwl_mvm_mac_ctxt_add(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 		return -EIO;
 
 	ret = iwl_mvm_mac_ctx_send(mvm, vif, FW_CTXT_ACTION_ADD,
-				   true);
+				   true, NULL);
 	if (ret)
 		return ret;
 
@@ -1173,7 +1179,7 @@ int iwl_mvm_mac_ctxt_add(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 }
 
 int iwl_mvm_mac_ctxt_changed(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-			     bool force_assoc_off)
+			     bool force_assoc_off, const u8 *bssid_override)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 
@@ -1182,7 +1188,7 @@ int iwl_mvm_mac_ctxt_changed(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		return -EIO;
 
 	return iwl_mvm_mac_ctx_send(mvm, vif, FW_CTXT_ACTION_MODIFY,
-				    force_assoc_off);
+				    force_assoc_off, bssid_override);
 }
 
 int iwl_mvm_mac_ctxt_remove(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 3bbeedf..ea79f1a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1451,10 +1451,23 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 	if (changes & BSS_CHANGED_ASSOC && bss_conf->assoc)
 		iwl_mvm_mac_ctxt_recalc_tsf_id(mvm, vif);
 
-	ret = iwl_mvm_mac_ctxt_changed(mvm, vif, false);
+	/*
+	 * If we're not associated yet, take the (new) BSSID before associating
+	 * so the firmware knows. If we're already associated, then use the old
+	 * BSSID here, and we'll send a cleared one later in the CHANGED_ASSOC
+	 * branch for disassociation below.
+	 */
+	if (changes & BSS_CHANGED_BSSID && !mvmvif->associated)
+		memcpy(mvmvif->bssid, bss_conf->bssid, ETH_ALEN);
+
+	ret = iwl_mvm_mac_ctxt_changed(mvm, vif, false, mvmvif->bssid);
 	if (ret)
 		IWL_ERR(mvm, "failed to update MAC %pM\n", vif->addr);
 
+	/* after sending it once, adopt mac80211 data */
+	memcpy(mvmvif->bssid, bss_conf->bssid, ETH_ALEN);
+	mvmvif->associated = bss_conf->assoc;
+
 	if (changes & BSS_CHANGED_ASSOC) {
 		if (bss_conf->assoc) {
 			/* add quota for this interface */
@@ -1516,6 +1529,13 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 
 			if (vif->p2p)
 				iwl_mvm_unref(mvm, IWL_MVM_REF_P2P_CLIENT);
+
+			/* this will take the cleared BSSID from bss_conf */
+			ret = iwl_mvm_mac_ctxt_changed(mvm, vif, false, NULL);
+			if (ret)
+				IWL_ERR(mvm,
+					"failed to update MAC %pM (clear after unassoc)\n",
+					vif->addr);
 		}
 
 		iwl_mvm_recalc_multicast(mvm);
@@ -1627,7 +1647,7 @@ static int iwl_mvm_start_ap_ibss(struct ieee80211_hw *hw,
 
 	/* Need to update the P2P Device MAC (only GO, IBSS is single vif) */
 	if (vif->p2p && mvm->p2p_device_vif)
-		iwl_mvm_mac_ctxt_changed(mvm, mvm->p2p_device_vif, false);
+		iwl_mvm_mac_ctxt_changed(mvm, mvm->p2p_device_vif, false, NULL);
 
 	iwl_mvm_ref(mvm, IWL_MVM_REF_AP_IBSS);
 
@@ -1685,7 +1705,7 @@ static void iwl_mvm_stop_ap_ibss(struct ieee80211_hw *hw,
 
 	/* Need to update the P2P Device MAC (only GO, IBSS is single vif) */
 	if (vif->p2p && mvm->p2p_device_vif)
-		iwl_mvm_mac_ctxt_changed(mvm, mvm->p2p_device_vif, false);
+		iwl_mvm_mac_ctxt_changed(mvm, mvm->p2p_device_vif, false, NULL);
 
 	iwl_mvm_update_quotas(mvm, NULL);
 	iwl_mvm_send_rm_bcast_sta(mvm, &mvmvif->bcast_sta);
@@ -1712,7 +1732,7 @@ iwl_mvm_bss_info_changed_ap_ibss(struct iwl_mvm *mvm,
 
 	if (changes & (BSS_CHANGED_ERP_CTS_PROT | BSS_CHANGED_HT |
 		       BSS_CHANGED_BANDWIDTH) &&
-	    iwl_mvm_mac_ctxt_changed(mvm, vif, false))
+	    iwl_mvm_mac_ctxt_changed(mvm, vif, false, NULL))
 		IWL_ERR(mvm, "failed to update MAC %pM\n", vif->addr);
 
 	/* Need to send a new beacon template to the FW */
@@ -2123,7 +2143,7 @@ static int iwl_mvm_mac_conf_tx(struct ieee80211_hw *hw,
 		int ret;
 
 		mutex_lock(&mvm->mutex);
-		ret = iwl_mvm_mac_ctxt_changed(mvm, vif, false);
+		ret = iwl_mvm_mac_ctxt_changed(mvm, vif, false, NULL);
 		mutex_unlock(&mvm->mutex);
 		return ret;
 	}
@@ -2745,7 +2765,7 @@ static int __iwl_mvm_assign_vif_chanctx(struct iwl_mvm *mvm,
 	if ((vif->type == NL80211_IFTYPE_AP) ||
 	    (switching_chanctx && (vif->type == NL80211_IFTYPE_STATION))) {
 		iwl_mvm_update_quotas(mvm, NULL);
-		iwl_mvm_mac_ctxt_changed(mvm, vif, false);
+		iwl_mvm_mac_ctxt_changed(mvm, vif, false, NULL);
 	}
 
 	if (vif->csa_active && vif->type == NL80211_IFTYPE_STATION) {
@@ -2830,7 +2850,7 @@ static void __iwl_mvm_unassign_vif_chanctx(struct iwl_mvm *mvm,
 		if (!WARN_ON(!mvmsta))
 			iwl_mvm_sta_modify_disable_tx(mvm, mvmsta, true);
 
-		iwl_mvm_mac_ctxt_changed(mvm, vif, true);
+		iwl_mvm_mac_ctxt_changed(mvm, vif, true, NULL);
 		break;
 	default:
 		break;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index b66a8af..43f5364 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -320,6 +320,9 @@ struct iwl_mvm_vif_bf_data {
  * @id: between 0 and 3
  * @color: to solve races upon MAC addition and removal
  * @ap_sta_id: the sta_id of the AP - valid only if VIF type is STA
+ * @bssid: BSSID for this (client) interface
+ * @associated: indicates that we're currently associated, used only for
+ *	managing the firmware state in iwl_mvm_bss_info_changed_station()
  * @uploaded: indicates the MAC context has been added to the device
  * @ap_ibss_active: indicates that AP/IBSS is configured and that the interface
  *	should get quota etc.
@@ -341,6 +344,9 @@ struct iwl_mvm_vif {
 	u16 color;
 	u8 ap_sta_id;
 
+	u8 bssid[ETH_ALEN];
+	bool associated;
+
 	bool uploaded;
 	bool ap_ibss_active;
 	bool pm_enabled;
@@ -897,7 +903,7 @@ int iwl_mvm_mac_ctxt_init(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 void iwl_mvm_mac_ctxt_release(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 int iwl_mvm_mac_ctxt_add(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 int iwl_mvm_mac_ctxt_changed(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-			     bool force_assoc_off);
+			     bool force_assoc_off, const u8 *bssid_override);
 int iwl_mvm_mac_ctxt_remove(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 u32 iwl_mvm_mac_get_queues_mask(struct iwl_mvm *mvm,
 				struct ieee80211_vif *vif);
-- 
1.9.1

