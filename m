Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbbEZTS2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 15:18:28 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 16/39] iwlwifi: mvm: BT Coex - remove useless code
Date: Tue, 26 May 2015 22:17:29 +0300
Message-Id: <1432667872-18092-16-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150526_213348_422095_BA38F5E7)
In-Reply-To: <1432667798.26624.3.camel@intel.com>
References: <1432667798.26624.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we don't need to configure the Ack / CTS kill mask
anymore in the new API, we don't need to iterate all the
interfaces upon rssi event on one of the interfaces.
Remove that code.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex.c | 43 ---------------------------------
 1 file changed, 43 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index 13a0a03..03dab95 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -770,49 +770,10 @@ int iwl_mvm_rx_bt_coex_notif(struct iwl_mvm *mvm,
 	return 0;
 }
 
-static void iwl_mvm_bt_rssi_iterator(void *_data, u8 *mac,
-				   struct ieee80211_vif *vif)
-{
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	struct iwl_bt_iterator_data *data = _data;
-	struct iwl_mvm *mvm = data->mvm;
-
-	struct ieee80211_sta *sta;
-	struct iwl_mvm_sta *mvmsta;
-
-	struct ieee80211_chanctx_conf *chanctx_conf;
-
-	rcu_read_lock();
-	chanctx_conf = rcu_dereference(vif->chanctx_conf);
-	/* If channel context is invalid or not on 2.4GHz - don't count it */
-	if (!chanctx_conf ||
-	    chanctx_conf->def.chan->band != IEEE80211_BAND_2GHZ) {
-		rcu_read_unlock();
-		return;
-	}
-	rcu_read_unlock();
-
-	if (vif->type != NL80211_IFTYPE_STATION ||
-	    mvmvif->ap_sta_id == IWL_MVM_STATION_COUNT)
-		return;
-
-	sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[mvmvif->ap_sta_id],
-					lockdep_is_held(&mvm->mutex));
-
-	/* This can happen if the station has been removed right now */
-	if (IS_ERR_OR_NULL(sta))
-		return;
-
-	mvmsta = iwl_mvm_sta_from_mac80211(sta);
-}
-
 void iwl_mvm_bt_rssi_event(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			   enum ieee80211_rssi_event_data rssi_event)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	struct iwl_bt_iterator_data data = {
-		.mvm = mvm,
-	};
 	int ret;
 
 	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_BT_COEX_SPLIT)) {
@@ -853,10 +814,6 @@ void iwl_mvm_bt_rssi_event(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	if (ret)
 		IWL_ERR(mvm, "couldn't send BT_CONFIG HCMD upon RSSI event\n");
-
-	ieee80211_iterate_active_interfaces_atomic(
-		mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
-		iwl_mvm_bt_rssi_iterator, &data);
 }
 
 #define LINK_QUAL_AGG_TIME_LIMIT_DEF	(4000)
-- 
2.1.4

