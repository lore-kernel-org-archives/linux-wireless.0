Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:34658 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbaBCU6r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:58:47 -0500
Received: by mail-ee0-f43.google.com with SMTP id c41so3848593eek.2
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:58:46 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 21/62] iwlwifi: mvm: BT Coex - change SMPS settings in AP mode
Date: Mon,  3 Feb 2014 22:57:27 +0200
Message-Id: <1391461088-8082-21-git-send-email-egrumbach@gmail.com> (sfid-20140203_220009_519810_82813957)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Based on the Bluetooth activity grading, we can stop using
the shared antenna and ask the stations to honor the new
SMPS state.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c |   85 ++++++++++++++++++----------
 drivers/net/wireless/iwlwifi/mvm/utils.c   |    7 ++-
 2 files changed, 60 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
index d38c4ae..ed20f4e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
@@ -568,29 +568,74 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 	struct iwl_mvm *mvm = data->mvm;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	enum ieee80211_smps_mode smps_mode;
+	u32 bt_activity_grading;
 	int ave_rssi;
 
 	lockdep_assert_held(&mvm->mutex);
 
-	if (vif->type != NL80211_IFTYPE_STATION &&
-	    vif->type != NL80211_IFTYPE_AP)
-		return;
+	switch (vif->type) {
+	case NL80211_IFTYPE_STATION:
+		/* default smps_mode for BSS / P2P client is AUTOMATIC */
+		smps_mode = IEEE80211_SMPS_AUTOMATIC;
+		data->num_bss_ifaces++;
+
+		/*
+		 * Count unassoc BSSes, relax SMSP constraints
+		 * and disable reduced Tx Power
+		 */
+		if (!vif->bss_conf.assoc) {
+			iwl_mvm_update_smps(mvm, vif, IWL_MVM_SMPS_REQ_BT_COEX,
+					    smps_mode);
+			if (iwl_mvm_bt_coex_reduced_txp(mvm,
+							mvmvif->ap_sta_id,
+							false))
+				IWL_ERR(mvm, "Couldn't send BT_CONFIG cmd\n");
+			return;
+		}
+		break;
+	case NL80211_IFTYPE_AP:
+		/* default smps_mode for AP / GO is OFF */
+		smps_mode = IEEE80211_SMPS_OFF;
+		if (!mvmvif->ap_ibss_active) {
+			iwl_mvm_update_smps(mvm, vif, IWL_MVM_SMPS_REQ_BT_COEX,
+					    smps_mode);
+			return;
+		}
 
-	smps_mode = IEEE80211_SMPS_AUTOMATIC;
+		/* the Ack / Cts kill mask must be default if AP / GO */
+		data->reduced_tx_power = false;
+		break;
+	default:
+		return;
+	}
 
 	chanctx_conf = rcu_dereference(vif->chanctx_conf);
 
 	/* If channel context is invalid or not on 2.4GHz .. */
 	if ((!chanctx_conf ||
 	     chanctx_conf->def.chan->band != IEEE80211_BAND_2GHZ)) {
-		/* ... and it is an associated STATION, relax constraints */
-		if (vif->type == NL80211_IFTYPE_STATION && vif->bss_conf.assoc)
-			iwl_mvm_update_smps(mvm, vif, IWL_MVM_SMPS_REQ_BT_COEX,
-					    smps_mode);
-		iwl_mvm_bt_coex_enable_rssi_event(mvm, vif, false, 0);
+		/* ... relax constraints and disable rssi events */
+		iwl_mvm_update_smps(mvm, vif, IWL_MVM_SMPS_REQ_BT_COEX,
+				    smps_mode);
+		if (vif->type == NL80211_IFTYPE_STATION)
+			iwl_mvm_bt_coex_enable_rssi_event(mvm, vif, false, 0);
 		return;
 	}
 
+	bt_activity_grading = le32_to_cpu(data->notif->bt_activity_grading);
+	if (bt_activity_grading >= BT_HIGH_TRAFFIC)
+		smps_mode = IEEE80211_SMPS_STATIC;
+	else if (bt_activity_grading >= BT_LOW_TRAFFIC)
+		smps_mode = vif->type == NL80211_IFTYPE_AP ?
+				IEEE80211_SMPS_OFF :
+				IEEE80211_SMPS_DYNAMIC;
+	IWL_DEBUG_COEX(data->mvm,
+		       "mac %d: bt_status %d bt_activity_grading %d smps_req %d\n",
+		       mvmvif->id, data->notif->bt_status, bt_activity_grading,
+		       smps_mode);
+
+	iwl_mvm_update_smps(mvm, vif, IWL_MVM_SMPS_REQ_BT_COEX, smps_mode);
+
 	/* low latency is always primary */
 	if (iwl_mvm_vif_low_latency(mvmvif)) {
 		data->primary_ll = true;
@@ -603,9 +648,6 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 		if (!mvmvif->ap_ibss_active)
 			return;
 
-		/* the Ack / Cts kill mask must be default if AP / GO */
-		data->reduced_tx_power = false;
-
 		if (chanctx_conf == data->primary)
 			return;
 
@@ -623,12 +665,6 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 		return;
 	}
 
-	data->num_bss_ifaces++;
-
-	/* we are now a STA / P2P Client, and take associated ones only */
-	if (!vif->bss_conf.assoc)
-		return;
-
 	/*
 	 * STA / P2P Client, try to be primary if first vif. If we are in low
 	 * latency mode, we are already in primary and just don't do much
@@ -639,19 +675,6 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 		/* if secondary is not NULL, it might be a GO */
 		data->secondary = chanctx_conf;
 
-	if (le32_to_cpu(data->notif->bt_activity_grading) >= BT_HIGH_TRAFFIC)
-		smps_mode = IEEE80211_SMPS_STATIC;
-	else if (le32_to_cpu(data->notif->bt_activity_grading) >=
-		 BT_LOW_TRAFFIC)
-		smps_mode = IEEE80211_SMPS_DYNAMIC;
-
-	IWL_DEBUG_COEX(data->mvm,
-		       "mac %d: bt_status %d bt_activity_grading %d smps_req %d\n",
-		       mvmvif->id,  data->notif->bt_status,
-		       data->notif->bt_activity_grading, smps_mode);
-
-	iwl_mvm_update_smps(mvm, vif, IWL_MVM_SMPS_REQ_BT_COEX, smps_mode);
-
 	/* don't reduce the Tx power if in loose scheme */
 	if (iwl_get_coex_type(mvm, vif) == BT_COEX_LOOSE_LUT ||
 	    mvm->cfg->bt_shared_single_ant) {
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index c7ee2f3..1aadede 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -514,7 +514,7 @@ void iwl_mvm_update_smps(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			 enum ieee80211_smps_mode smps_request)
 {
 	struct iwl_mvm_vif *mvmvif;
-	enum ieee80211_smps_mode smps_mode = IEEE80211_SMPS_AUTOMATIC;
+	enum ieee80211_smps_mode smps_mode;
 	int i;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -523,6 +523,11 @@ void iwl_mvm_update_smps(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	if (num_of_ant(iwl_fw_valid_rx_ant(mvm->fw)) == 1)
 		return;
 
+	if (vif->type == NL80211_IFTYPE_AP)
+		smps_mode = IEEE80211_SMPS_OFF;
+	else
+		smps_mode = IEEE80211_SMPS_AUTOMATIC;
+
 	mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	mvmvif->smps_requests[req_type] = smps_request;
 	for (i = 0; i < NUM_IWL_MVM_SMPS_REQ; i++) {
-- 
1.7.9.5

