Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:59377 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752066AbaKJJKj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2014 04:10:39 -0500
From: Luca Coelho <luca@coelho.fi>
To: emmanuel.grumbach@intel.com
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Date: Mon, 10 Nov 2014 11:10:11 +0200
Message-Id: <1415610621-27438-7-git-send-email-luca@coelho.fi> (sfid-20141110_101108_180784_9A73DB1D)
In-Reply-To: <1415610621-27438-1-git-send-email-luca@coelho.fi>
References: <1415610621-27438-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 06/16] iwlwifi: mvm: Handle failed beacon transmissions during CSA
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

The spec requires to decrement the CSA counters based on TBTT,
regardless if the beacon was actually transmitted. Previously, the fw
would send beacon notifications only for successfully transmitted
beacons. This behavior resulted in inaccurate CSA countdown. In order
to address this issue, the fw was changed to send beacon
notifications also for not transmitted beacons. Such notifications
have TX_STATUS_INTERNAL_ABORT (0x92).
Don't start the CSA countdown before first successfully transmitted
beacon, in order to guarantee that the CSA is announced for a
required period.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c | 21 +++++++++++++++------
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 11 +++++++++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  3 +++
 3 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 0c5c0b0..b259beb 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -1219,17 +1219,25 @@ int iwl_mvm_mac_ctxt_remove(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 }
 
 static void iwl_mvm_csa_count_down(struct iwl_mvm *mvm,
-				   struct ieee80211_vif *csa_vif, u32 gp2)
+				   struct ieee80211_vif *csa_vif, u32 gp2,
+				   bool tx_success)
 {
 	struct iwl_mvm_vif *mvmvif =
 			iwl_mvm_vif_from_mac80211(csa_vif);
 
+	/* Don't start to countdown from a failed beacon */
+	if (!tx_success && !mvmvif->csa_countdown)
+		return;
+
+	mvmvif->csa_countdown = true;
+
 	if (!ieee80211_csa_is_complete(csa_vif)) {
 		int c = ieee80211_csa_update_counter(csa_vif);
 
 		iwl_mvm_mac_ctxt_beacon_changed(mvm, csa_vif);
 		if (csa_vif->p2p &&
-		    !iwl_mvm_te_scheduled(&mvmvif->time_event_data) && gp2) {
+		    !iwl_mvm_te_scheduled(&mvmvif->time_event_data) && gp2 &&
+		    tx_success) {
 			u32 rel_time = (c + 1) *
 				       csa_vif->bss_conf.beacon_int -
 				       IWL_MVM_CHANNEL_SWITCH_TIME_GO;
@@ -1256,6 +1264,7 @@ int iwl_mvm_rx_beacon_notif(struct iwl_mvm *mvm,
 	struct ieee80211_vif *csa_vif;
 	struct ieee80211_vif *tx_blocked_vif;
 	u64 tsf;
+	u16 status;
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -1272,18 +1281,18 @@ int iwl_mvm_rx_beacon_notif(struct iwl_mvm *mvm,
 		tsf = le64_to_cpu(beacon->tsf);
 	}
 
+	status = le16_to_cpu(beacon_notify_hdr->status.status) & TX_STATUS_MSK;
 	IWL_DEBUG_RX(mvm,
 		     "beacon status %#x retries:%d tsf:0x%16llX gp2:0x%X rate:%d\n",
-		     le16_to_cpu(beacon_notify_hdr->status.status) &
-								TX_STATUS_MSK,
-		     beacon_notify_hdr->failure_frame, tsf,
+		     status, beacon_notify_hdr->failure_frame, tsf,
 		     mvm->ap_last_beacon_gp2,
 		     le32_to_cpu(beacon_notify_hdr->initial_rate));
 
 	csa_vif = rcu_dereference_protected(mvm->csa_vif,
 					    lockdep_is_held(&mvm->mutex));
 	if (unlikely(csa_vif && csa_vif->csa_active))
-		iwl_mvm_csa_count_down(mvm, csa_vif, mvm->ap_last_beacon_gp2);
+		iwl_mvm_csa_count_down(mvm, csa_vif, mvm->ap_last_beacon_gp2,
+				       (status == TX_STATUS_SUCCESS));
 
 	tx_blocked_vif = rcu_dereference_protected(mvm->csa_tx_blocked_vif,
 						lockdep_is_held(&mvm->mutex));
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 10347d1..9cf90af 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2782,6 +2782,8 @@ static void __iwl_mvm_unassign_vif_chanctx(struct iwl_mvm *mvm,
 		if (!vif->csa_active || !mvmvif->ap_ibss_active)
 			goto out;
 
+		mvmvif->csa_countdown = false;
+
 		/* Set CS bit on all the stations */
 		iwl_mvm_modify_all_sta_disable_tx(mvm, mvmvif, true);
 
@@ -3037,6 +3039,7 @@ static int iwl_mvm_pre_channel_switch(struct ieee80211_hw *hw,
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	struct ieee80211_vif *csa_vif;
+	struct iwl_mvm_vif *mvmvif;
 	int ret;
 
 	mutex_lock(&mvm->mutex);
@@ -3056,6 +3059,14 @@ static int iwl_mvm_pre_channel_switch(struct ieee80211_hw *hw,
 		}
 
 		rcu_assign_pointer(mvm->csa_vif, vif);
+
+		mvmvif = iwl_mvm_vif_from_mac80211(vif);
+		if (WARN_ONCE(mvmvif->csa_countdown,
+			      "Previous CSA countdown didn't complete")) {
+			ret = -EBUSY;
+			goto out_unlock;
+		}
+
 		break;
 	default:
 		break;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index b153ced..d7b956a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -399,6 +399,9 @@ struct iwl_mvm_vif {
 
 	/* FW identified misbehaving AP */
 	u8 uapsd_misbehaving_bssid[ETH_ALEN];
+
+	/* Indicates that CSA countdown may be started */
+	bool csa_countdown;
 };
 
 static inline struct iwl_mvm_vif *
-- 
2.1.1

