Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47718 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933241Ab3BLQCn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 11:02:43 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 14/15] iwlwifi: mvm: update station when marked associated
Date: Tue, 12 Feb 2013 17:02:06 +0100
Message-Id: <1360684927-1367-14-git-send-email-johannes@sipsolutions.net> (sfid-20130212_170255_320660_A3027A23)
In-Reply-To: <1360684927-1367-1-git-send-email-johannes@sipsolutions.net>
References: <1360684891.29913.4.camel@jlt4.sipsolutions.net>
 <1360684927-1367-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In managed mode, the HT/VHT capabilities aren't set when
the station is initially added, so update the station
when it is marked associated. In AP/GO mode, the station
will typically be added with full capabilities today,
but an upcoming change in hostapd may mean a similar
scenario as for managed mode, therefore do the update
unconditionally.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c       |  2 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  6 ++++--
 drivers/net/wireless/iwlwifi/mvm/sta.c      | 21 ++++++++++++++++-----
 drivers/net/wireless/iwlwifi/mvm/sta.h      |  6 +++++-
 4 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index a00267f..c64d864 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -490,7 +490,7 @@ static int iwl_mvm_d3_reprogram(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		return -EIO;
 	}
 
-	ret = iwl_mvm_sta_add_to_fw(mvm, ap_sta);
+	ret = iwl_mvm_sta_send_to_fw(mvm, ap_sta, false);
 	if (ret)
 		return ret;
 	rcu_assign_pointer(mvm->fw_id_to_mac_id[mvmvif->ap_sta_id], ap_sta);
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 6bfcb3b..5bdcbcf 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -926,8 +926,10 @@ static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 		ret = 0;
 	} else if (old_state == IEEE80211_STA_AUTH &&
 		   new_state == IEEE80211_STA_ASSOC) {
-		iwl_mvm_rs_rate_init(mvm, sta, mvmvif->phy_ctxt->channel->band);
-		ret = 0;
+		ret = iwl_mvm_update_sta(mvm, vif, sta);
+		if (ret == 0)
+			iwl_mvm_rs_rate_init(mvm, sta,
+					     mvmvif->phy_ctxt->channel->band);
 	} else if (old_state == IEEE80211_STA_ASSOC &&
 		   new_state == IEEE80211_STA_AUTHORIZED) {
 		ret = 0;
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 6b22bac..a1eb692 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -81,8 +81,9 @@ static int iwl_mvm_find_free_sta_id(struct iwl_mvm *mvm)
 	return IWL_MVM_STATION_COUNT;
 }
 
-/* add a NEW station to fw */
-int iwl_mvm_sta_add_to_fw(struct iwl_mvm *mvm, struct ieee80211_sta *sta)
+/* send station add/update command to firmware */
+int iwl_mvm_sta_send_to_fw(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
+			   bool update)
 {
 	struct iwl_mvm_sta *mvm_sta = (void *)sta->drv_priv;
 	struct iwl_mvm_add_sta_cmd add_sta_cmd;
@@ -94,8 +95,11 @@ int iwl_mvm_sta_add_to_fw(struct iwl_mvm *mvm, struct ieee80211_sta *sta)
 
 	add_sta_cmd.sta_id = mvm_sta->sta_id;
 	add_sta_cmd.mac_id_n_color = cpu_to_le32(mvm_sta->mac_id_n_color);
-	add_sta_cmd.tfd_queue_msk = cpu_to_le32(mvm_sta->tfd_queue_msk);
-	memcpy(&add_sta_cmd.addr, sta->addr, ETH_ALEN);
+	if (!update) {
+		add_sta_cmd.tfd_queue_msk = cpu_to_le32(mvm_sta->tfd_queue_msk);
+		memcpy(&add_sta_cmd.addr, sta->addr, ETH_ALEN);
+	}
+	add_sta_cmd.add_modify = update ? 1 : 0;
 
 	/* STA_FLG_FAT_EN_MSK ? */
 	/* STA_FLG_MIMO_EN_MSK ? */
@@ -181,7 +185,7 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 	/* for HW restart - need to reset the seq_number etc... */
 	memset(mvm_sta->tid_data, 0, sizeof(mvm_sta->tid_data));
 
-	ret = iwl_mvm_sta_add_to_fw(mvm, sta);
+	ret = iwl_mvm_sta_send_to_fw(mvm, sta, false);
 	if (ret)
 		return ret;
 
@@ -195,6 +199,13 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 	return 0;
 }
 
+int iwl_mvm_update_sta(struct iwl_mvm *mvm,
+		       struct ieee80211_vif *vif,
+		       struct ieee80211_sta *sta)
+{
+	return iwl_mvm_sta_send_to_fw(mvm, sta, true);
+}
+
 int iwl_mvm_drain_sta(struct iwl_mvm *mvm, struct iwl_mvm_sta *mvmsta,
 		      bool drain)
 {
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.h b/drivers/net/wireless/iwlwifi/mvm/sta.h
index 1bf3010..bdd7c5e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.h
@@ -309,10 +309,14 @@ struct iwl_mvm_int_sta {
 	u32 tfd_queue_msk;
 };
 
-int iwl_mvm_sta_add_to_fw(struct iwl_mvm *mvm, struct ieee80211_sta *sta);
+int iwl_mvm_sta_send_to_fw(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
+			   bool update);
 int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 		    struct ieee80211_vif *vif,
 		    struct ieee80211_sta *sta);
+int iwl_mvm_update_sta(struct iwl_mvm *mvm,
+		       struct ieee80211_vif *vif,
+		       struct ieee80211_sta *sta);
 int iwl_mvm_rm_sta(struct iwl_mvm *mvm,
 		   struct ieee80211_vif *vif,
 		   struct ieee80211_sta *sta);
-- 
1.8.0

