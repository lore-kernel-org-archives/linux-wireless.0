Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:44219 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867AbaEORF2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 13:05:28 -0400
Received: by mail-wg0-f43.google.com with SMTP id l18so3788869wgh.14
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 10:05:27 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 21/24] iwlwifi: mvm: BT Coex - send channel inhibition before association
Date: Thu, 15 May 2014 20:04:38 +0300
Message-Id: <1400173481-9047-21-git-send-email-egrumbach@gmail.com> (sfid-20140515_190557_359911_E6603373)
In-Reply-To: <5374F373.6040902@gmail.com>
References: <5374F373.6040902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The firmware needs to know on what channel we run before we
set the association bit in the MAC context. Change a bit the
flow to achieve this.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex.c     | 47 +++++++++++------------------
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  2 +-
 2 files changed, 18 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index 3833f2c..cbad3ef 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -801,23 +801,10 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
+		/* Count BSSes vifs */
+		data->num_bss_ifaces++;
 		/* default smps_mode for BSS / P2P client is AUTOMATIC */
 		smps_mode = IEEE80211_SMPS_AUTOMATIC;
-		data->num_bss_ifaces++;
-
-		/*
-		 * Count unassoc BSSes, relax SMSP constraints
-		 * and disable reduced Tx Power
-		 */
-		if (!vif->bss_conf.assoc) {
-			iwl_mvm_update_smps(mvm, vif, IWL_MVM_SMPS_REQ_BT_COEX,
-					    smps_mode);
-			if (iwl_mvm_bt_coex_reduced_txp(mvm,
-							mvmvif->ap_sta_id,
-							false))
-				IWL_ERR(mvm, "Couldn't send BT_CONFIG cmd\n");
-			return;
-		}
 		break;
 	case NL80211_IFTYPE_AP:
 		/* default smps_mode for AP / GO is OFF */
@@ -843,6 +830,7 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 		/* ... relax constraints and disable rssi events */
 		iwl_mvm_update_smps(mvm, vif, IWL_MVM_SMPS_REQ_BT_COEX,
 				    smps_mode);
+		data->reduced_tx_power = false;
 		if (vif->type == NL80211_IFTYPE_STATION)
 			iwl_mvm_bt_coex_enable_rssi_event(mvm, vif, false, 0);
 		return;
@@ -855,6 +843,11 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 		smps_mode = vif->type == NL80211_IFTYPE_AP ?
 				IEEE80211_SMPS_OFF :
 				IEEE80211_SMPS_DYNAMIC;
+
+	/* relax SMPS contraints for next association */
+	if (!vif->bss_conf.assoc)
+		smps_mode = IEEE80211_SMPS_AUTOMATIC;
+
 	IWL_DEBUG_COEX(data->mvm,
 		       "mac %d: bt_status %d bt_activity_grading %d smps_req %d\n",
 		       mvmvif->id, data->notif->bt_status, bt_activity_grading,
@@ -901,26 +894,21 @@ static void iwl_mvm_bt_notif_iterator(void *_data, u8 *mac,
 		/* if secondary is not NULL, it might be a GO */
 		data->secondary = chanctx_conf;
 
-	/* don't reduce the Tx power if in loose scheme */
+	/*
+	 * don't reduce the Tx power if one of these is true:
+	 *  we are in LOOSE
+	 *  single share antenna product
+	 *  BT is active
+	 *  we are associated
+	 */
 	if (iwl_get_coex_type(mvm, vif) == BT_COEX_LOOSE_LUT ||
-	    mvm->cfg->bt_shared_single_ant) {
+	    mvm->cfg->bt_shared_single_ant || !vif->bss_conf.assoc ||
+	    !data->notif->bt_status) {
 		data->reduced_tx_power = false;
 		iwl_mvm_bt_coex_enable_rssi_event(mvm, vif, false, 0);
 		return;
 	}
 
-	/* reduced Txpower only if BT is on, so ...*/
-	if (!data->notif->bt_status) {
-		/* ... cancel reduced Tx power ... */
-		if (iwl_mvm_bt_coex_reduced_txp(mvm, mvmvif->ap_sta_id, false))
-			IWL_ERR(mvm, "Couldn't send BT_CONFIG cmd\n");
-		data->reduced_tx_power = false;
-
-		/* ... and there is no need to get reports on RSSI any more. */
-		iwl_mvm_bt_coex_enable_rssi_event(mvm, vif, false, 0);
-		return;
-	}
-
 	/* try to get the avg rssi from fw */
 	ave_rssi = mvmvif->bf_data.ave_beacon_signal;
 
@@ -1037,7 +1025,6 @@ static void iwl_mvm_bt_coex_notif_handle(struct iwl_mvm *mvm)
 		IWL_ERR(mvm, "Failed to update the ctrl_kill_msk\n");
 }
 
-/* upon association, the fw will send in BT Coex notification */
 int iwl_mvm_rx_bt_coex_notif(struct iwl_mvm *mvm,
 			     struct iwl_rx_cmd_buffer *rxb,
 			     struct iwl_device_cmd *dev_cmd)
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 137228b..22a445f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2186,10 +2186,10 @@ static void iwl_mvm_change_chanctx(struct ieee80211_hw *hw,
 		return;
 
 	mutex_lock(&mvm->mutex);
+	iwl_mvm_bt_coex_vif_change(mvm);
 	iwl_mvm_phy_ctxt_changed(mvm, phy_ctxt, &ctx->min_def,
 				 ctx->rx_chains_static,
 				 ctx->rx_chains_dynamic);
-	iwl_mvm_bt_coex_vif_change(mvm);
 	mutex_unlock(&mvm->mutex);
 }
 
-- 
1.8.3.2

