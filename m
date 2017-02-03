Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:38002 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752286AbdBCOkM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Feb 2017 09:40:12 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  3 Feb 2017 16:38:00 +0200
Message-Id: <20170203143812.7525-14-luca@coelho.fi> (sfid-20170203_154033_382551_3005DCCB)
In-Reply-To: <20170203143812.7525-1-luca@coelho.fi>
References: <20170203143812.7525-1-luca@coelho.fi>
Subject: [PATCH 13/25] iwlwifi: mvm: set AID to firmware only for associated stations
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The firmware will soon actually look at the AID field, and
when it does that it'll try to ensure that the AID is never
changing. Due to the way the station is added, it may start
with an invalid AID before it's associated, so to ensure a
constant AID (once it becomes non-zero), track the station
state and set the AID only when the station is associated
and when it disassociates.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 6 ++++--
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      | 3 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h      | 1 +
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 8d519c3f45bd..72102566a02b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2552,6 +2552,7 @@ static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_mvm_sta *mvm_sta = iwl_mvm_sta_from_mac80211(sta);
 	int ret;
 
 	IWL_DEBUG_MAC80211(mvm, "station %pM state change %d->%d\n",
@@ -2580,8 +2581,6 @@ static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 	if (old_state == IEEE80211_STA_NONE &&
 	    new_state == IEEE80211_STA_NOTEXIST &&
 	    iwl_mvm_is_dqa_supported(mvm)) {
-		struct iwl_mvm_sta *mvm_sta = iwl_mvm_sta_from_mac80211(sta);
-
 		iwl_mvm_purge_deferred_tx_frames(mvm, mvm_sta);
 		flush_work(&mvm->add_stream_wk);
 
@@ -2592,6 +2591,9 @@ static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 	}
 
 	mutex_lock(&mvm->mutex);
+	/* track whether or not the station is associated */
+	mvm_sta->associated = new_state >= IEEE80211_STA_ASSOC;
+
 	if (old_state == IEEE80211_STA_NOTEXIST &&
 	    new_state == IEEE80211_STA_NONE) {
 		/*
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 962920861ccf..4afd52f8d9c3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -202,7 +202,8 @@ int iwl_mvm_sta_send_to_fw(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		cpu_to_le32(agg_size << STA_FLG_MAX_AGG_SIZE_SHIFT);
 	add_sta_cmd.station_flags |=
 		cpu_to_le32(mpdu_dens << STA_FLG_AGG_MPDU_DENS_SHIFT);
-	add_sta_cmd.assoc_id = cpu_to_le16(sta->aid);
+	if (mvm_sta->associated)
+		add_sta_cmd.assoc_id = cpu_to_le16(sta->aid);
 
 	if (sta->wme) {
 		add_sta_cmd.modify_mask |= STA_MODIFY_UAPSD_ACS;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
index b45c7b9937c8..4be34f902278 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
@@ -437,6 +437,7 @@ struct iwl_mvm_sta {
 	bool disable_tx;
 	bool tlc_amsdu;
 	bool sleeping;
+	bool associated;
 	u8 agg_tids;
 	u8 sleep_tx_count;
 	u8 avg_energy;
-- 
2.11.0
