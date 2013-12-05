Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51760 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333Ab3LEMgE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 07:36:04 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/8] iwlwifi: mvm: use pre-RCU-sync sta removal operation
Date: Thu,  5 Dec 2013 13:35:50 +0100
Message-Id: <1386246956-14257-3-git-send-email-johannes@sipsolutions.net> (sfid-20131205_133616_593613_5D808647)
In-Reply-To: <1386246956-14257-1-git-send-email-johannes@sipsolutions.net>
References: <1386192610.5660.4.camel@jlt4.sipsolutions.net>
 <1386246956-14257-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

iwlmvm relies on the current mac80211 behaviour of allowing
station pointers to be valid for an RCU grace period after
returning from the sta_state() callback. To optimise these
cases, this behaviour is going away, so make the driver use
the new sta_pre_rcu_remove() method to clear the pointer in
the fw_id_to_mac_id[] array.

Since this may happen while the station is still present in
the firmware, don't set the pointer to NULL but to -ENOENT
to mark this particular case. In client mode, the station
is kept even longer (until marking the MAC as unassociated)
so the drain flow must take this new behavior into account.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c  | 13 ++++++++-----
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 23 +++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/sta.c      | 11 +++++++++--
 3 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 9864d71..fc570d0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -479,14 +479,17 @@ static ssize_t iwl_dbgfs_mac_params_read(struct file *file,
 	if (vif->type == NL80211_IFTYPE_STATION &&
 	    ap_sta_id != IWL_MVM_STATION_COUNT) {
 		struct ieee80211_sta *sta;
-		struct iwl_mvm_sta *mvm_sta;
 
 		sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[ap_sta_id],
 						lockdep_is_held(&mvm->mutex));
-		mvm_sta = (void *)sta->drv_priv;
-		pos += scnprintf(buf+pos, bufsz-pos,
-				 "ap_sta_id %d - reduced Tx power %d\n",
-				 ap_sta_id, mvm_sta->bt_reduced_txpower);
+		if (!IS_ERR_OR_NULL(sta)) {
+			struct iwl_mvm_sta *mvm_sta = (void *)sta->drv_priv;
+
+			pos += scnprintf(buf+pos, bufsz-pos,
+					 "ap_sta_id %d - reduced Tx power %d\n",
+					 ap_sta_id,
+					 mvm_sta->bt_reduced_txpower);
+		}
 	}
 
 	rcu_read_lock();
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index b56c989..241b8f4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1102,6 +1102,28 @@ static void iwl_mvm_mac_sta_notify(struct ieee80211_hw *hw,
 	}
 }
 
+static void iwl_mvm_sta_pre_rcu_remove(struct ieee80211_hw *hw,
+				       struct ieee80211_vif *vif,
+				       struct ieee80211_sta *sta)
+{
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	struct iwl_mvm_sta *mvm_sta = (void *)sta->drv_priv;
+
+	/*
+	 * This is called before mac80211 does RCU synchronisation,
+	 * so here we already invalidate our internal RCU-protected
+	 * station pointer. The rest of the code will thus no longer
+	 * be able to find the station this way, and we don't rely
+	 * on further RCU synchronisation after the sta_state()
+	 * callback deleted the station.
+	 */
+	mutex_lock(&mvm->mutex);
+	if (sta == rcu_access_pointer(mvm->fw_id_to_mac_id[mvm_sta->sta_id]))
+		rcu_assign_pointer(mvm->fw_id_to_mac_id[mvm_sta->sta_id],
+				   ERR_PTR(-ENOENT));
+	mutex_unlock(&mvm->mutex);
+}
+
 static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 				 struct ieee80211_vif *vif,
 				 struct ieee80211_sta *sta,
@@ -1748,6 +1770,7 @@ struct ieee80211_ops iwl_mvm_hw_ops = {
 	.bss_info_changed = iwl_mvm_bss_info_changed,
 	.hw_scan = iwl_mvm_mac_hw_scan,
 	.cancel_hw_scan = iwl_mvm_mac_cancel_hw_scan,
+	.sta_pre_rcu_remove = iwl_mvm_sta_pre_rcu_remove,
 	.sta_state = iwl_mvm_mac_sta_state,
 	.sta_notify = iwl_mvm_mac_sta_notify,
 	.allow_buffered_frames = iwl_mvm_mac_allow_buffered_frames,
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 3299523..1b6b4a6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -452,8 +452,15 @@ void iwl_mvm_sta_drained_wk(struct work_struct *wk)
 			rcu_dereference_protected(mvm->fw_id_to_mac_id[sta_id],
 						  lockdep_is_held(&mvm->mutex));
 
-		/* This station is in use */
-		if (!IS_ERR(sta))
+		/*
+		 * This station is in use or RCU-removed; the latter happens in
+		 * managed mode, where mac80211 removes the station before we
+		 * can remove it from firmware (we can only do that after the
+		 * MAC is marked unassociated), and possibly while the deauth
+		 * frame to disconnect from the AP is still queued. Then, the
+		 * station pointer is -ENOENT when the last skb is reclaimed.
+		 */
+		if (!IS_ERR(sta) || PTR_ERR(sta) == -ENOENT)
 			continue;
 
 		if (PTR_ERR(sta) == -EINVAL) {
-- 
1.8.4.rc3

