Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:48127 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbaGFJhV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 05:37:21 -0400
Received: by mail-wi0-f173.google.com with SMTP id cc10so14479930wib.12
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 02:37:19 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 37/40] iwlwifi: disable PSM on vifs with associated TDLS peers
Date: Sun,  6 Jul 2014 12:36:13 +0300
Message-Id: <1404639376-3792-37-git-send-email-egrumbach@gmail.com> (sfid-20140706_115953_608735_5F9421EE)
In-Reply-To: <53B917DC.5050902@gmail.com>
References: <53B917DC.5050902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

The FW does not support PSM on a vif with associated TDLS peers. Disable
PSM when the first peer joins and re-enable it when the last leaves.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 31 +++++++++++++++++++++++++++--
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  3 +++
 drivers/net/wireless/iwlwifi/mvm/power.c    | 17 +++++++++++++---
 3 files changed, 46 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 1acad83..8aa6fa4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1843,9 +1843,10 @@ static void iwl_mvm_sta_pre_rcu_remove(struct ieee80211_hw *hw,
 	mutex_unlock(&mvm->mutex);
 }
 
-static int iwl_mvm_tdls_sta_count(struct iwl_mvm *mvm)
+int iwl_mvm_tdls_sta_count(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 {
 	struct ieee80211_sta *sta;
+	struct iwl_mvm_sta *mvmsta;
 	int count = 0;
 	int i;
 
@@ -1857,12 +1858,33 @@ static int iwl_mvm_tdls_sta_count(struct iwl_mvm *mvm)
 		if (!sta || IS_ERR(sta) || !sta->tdls)
 			continue;
 
+		if (vif) {
+			mvmsta = iwl_mvm_sta_from_mac80211(sta);
+			if (mvmsta->vif != vif)
+				continue;
+		}
+
 		count++;
 	}
 
 	return count;
 }
 
+static void iwl_mvm_recalc_tdls_state(struct iwl_mvm *mvm,
+				      struct ieee80211_vif *vif,
+				      bool sta_added)
+{
+	int tdls_sta_cnt = iwl_mvm_tdls_sta_count(mvm, vif);
+
+	/*
+	 * Disable ps when the first TDLS sta is added and re-enable it
+	 * when the last TDLS sta is removed
+	 */
+	if ((tdls_sta_cnt == 1 && sta_added) ||
+	    (tdls_sta_cnt == 0 && !sta_added))
+		iwl_mvm_power_update_mac(mvm);
+}
+
 static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 				 struct ieee80211_vif *vif,
 				 struct ieee80211_sta *sta,
@@ -1904,7 +1926,8 @@ static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 
 		if (sta->tdls &&
 		    (vif->p2p ||
-		     iwl_mvm_tdls_sta_count(mvm) == IWL_MVM_TDLS_STA_COUNT ||
+		     iwl_mvm_tdls_sta_count(mvm, NULL) ==
+						IWL_MVM_TDLS_STA_COUNT ||
 		     iwl_mvm_phy_ctx_count(mvm) > 1)) {
 			IWL_DEBUG_MAC80211(mvm, "refusing TDLS sta\n");
 			ret = -EBUSY;
@@ -1912,6 +1935,8 @@ static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 		}
 
 		ret = iwl_mvm_add_sta(mvm, vif, sta);
+		if (sta->tdls && ret == 0)
+			iwl_mvm_recalc_tdls_state(mvm, vif, true);
 	} else if (old_state == IEEE80211_STA_NONE &&
 		   new_state == IEEE80211_STA_AUTH) {
 		/*
@@ -1946,6 +1971,8 @@ static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 	} else if (old_state == IEEE80211_STA_NONE &&
 		   new_state == IEEE80211_STA_NOTEXIST) {
 		ret = iwl_mvm_rm_sta(mvm, vif, sta);
+		if (sta->tdls)
+			iwl_mvm_recalc_tdls_state(mvm, vif, false);
 	} else {
 		ret = -EIO;
 	}
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index c75b958..785e523 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1098,6 +1098,9 @@ void iwl_mvm_set_hw_ctkill_state(struct iwl_mvm *mvm, bool state);
 int iwl_mvm_sf_update(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		      bool added_vif);
 
+/* TDLS */
+int iwl_mvm_tdls_sta_count(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
+
 void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error);
 
 #endif /* __IWL_MVM_H__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index 3b582dd..2b2d108 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -483,6 +483,7 @@ int iwl_mvm_power_uapsd_misbehaving_ap_notif(struct iwl_mvm *mvm,
 }
 
 struct iwl_power_vifs {
+	struct iwl_mvm *mvm;
 	struct ieee80211_vif *bf_vif;
 	struct ieee80211_vif *bss_vif;
 	struct ieee80211_vif *p2p_vif;
@@ -492,6 +493,8 @@ struct iwl_power_vifs {
 	bool bss_active;
 	bool ap_active;
 	bool monitor_active;
+	bool bss_tdls;
+	bool p2p_tdls;
 };
 
 static void iwl_mvm_power_iterator(void *_data, u8 *mac,
@@ -528,6 +531,8 @@ static void iwl_mvm_power_iterator(void *_data, u8 *mac,
 		/* only a single MAC of the same type */
 		WARN_ON(power_iterator->p2p_vif);
 		power_iterator->p2p_vif = vif;
+		power_iterator->p2p_tdls =
+			!!iwl_mvm_tdls_sta_count(power_iterator->mvm, vif);
 		if (mvmvif->phy_ctxt)
 			if (mvmvif->phy_ctxt->id < MAX_PHYS)
 				power_iterator->p2p_active = true;
@@ -537,6 +542,8 @@ static void iwl_mvm_power_iterator(void *_data, u8 *mac,
 		/* only a single MAC of the same type */
 		WARN_ON(power_iterator->bss_vif);
 		power_iterator->bss_vif = vif;
+		power_iterator->bss_tdls =
+			!!iwl_mvm_tdls_sta_count(power_iterator->mvm, vif);
 		if (mvmvif->phy_ctxt)
 			if (mvmvif->phy_ctxt->id < MAX_PHYS)
 				power_iterator->bss_active = true;
@@ -579,13 +586,15 @@ iwl_mvm_power_set_pm(struct iwl_mvm *mvm,
 		ap_mvmvif = iwl_mvm_vif_from_mac80211(vifs->ap_vif);
 
 	/* enable PM on bss if bss stand alone */
-	if (vifs->bss_active && !vifs->p2p_active && !vifs->ap_active) {
+	if (vifs->bss_active && !vifs->p2p_active && !vifs->ap_active &&
+	    !vifs->bss_tdls) {
 		bss_mvmvif->pm_enabled = true;
 		return;
 	}
 
 	/* enable PM on p2p if p2p stand alone */
-	if (vifs->p2p_active && !vifs->bss_active && !vifs->ap_active) {
+	if (vifs->p2p_active && !vifs->bss_active && !vifs->ap_active &&
+	    !vifs->p2p_tdls) {
 		if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_P2P_PM)
 			p2p_mvmvif->pm_enabled = true;
 		return;
@@ -811,7 +820,9 @@ int iwl_mvm_disable_beacon_filter(struct iwl_mvm *mvm,
 int iwl_mvm_power_update_mac(struct iwl_mvm *mvm)
 {
 	struct iwl_mvm_vif *mvmvif;
-	struct iwl_power_vifs vifs = {};
+	struct iwl_power_vifs vifs = {
+		.mvm = mvm,
+	};
 	bool ba_enable;
 	int ret;
 
-- 
1.8.3.2

