Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:37157 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbaGFJhP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 05:37:15 -0400
Received: by mail-wg0-f50.google.com with SMTP id x13so2068013wgg.21
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 02:37:14 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 34/40] iwlwifi: mvm: Use CS tx block bit for AP/GO
Date: Sun,  6 Jul 2014 12:36:10 +0300
Message-Id: <1404639376-3792-34-git-send-email-egrumbach@gmail.com> (sfid-20140706_115952_364269_C47720E5)
In-Reply-To: <53B917DC.5050902@gmail.com>
References: <53B917DC.5050902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

An AP/GO may perform the channel switch slightly before its stations.
This scenario may result in packet loss, since the transmission may start
before the client is actually on a new channel. In order to prevent
potential packet loss disable tx to all the stations when the channel
switch flow starts. Clear the disable_tx bit when a station is seen on a
target channel, or after IWL_MVM_CS_UNBLOCK_TX_TIMEOUT beacons on a new
channel. In addition call ieee80211_sta_block_awake in order to inform
mac80211 that the frames for this station should be buffered.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c | 25 +++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 11 ++++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  8 +++++
 drivers/net/wireless/iwlwifi/mvm/rx.c       | 17 +++++++++
 drivers/net/wireless/iwlwifi/mvm/sta.c      | 54 +++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/sta.h      | 10 ++++++
 drivers/net/wireless/iwlwifi/mvm/tx.c       | 14 ++++++--
 7 files changed, 136 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index a176d00..96b9cf8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -1237,6 +1237,7 @@ int iwl_mvm_rx_beacon_notif(struct iwl_mvm *mvm,
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_mvm_tx_resp *beacon_notify_hdr;
 	struct ieee80211_vif *csa_vif;
+	struct ieee80211_vif *tx_blocked_vif;
 	u64 tsf;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -1267,6 +1268,30 @@ int iwl_mvm_rx_beacon_notif(struct iwl_mvm *mvm,
 	if (unlikely(csa_vif && csa_vif->csa_active))
 		iwl_mvm_csa_count_down(mvm, csa_vif, mvm->ap_last_beacon_gp2);
 
+	tx_blocked_vif = rcu_dereference_protected(mvm->csa_tx_blocked_vif,
+						lockdep_is_held(&mvm->mutex));
+	if (unlikely(tx_blocked_vif)) {
+		struct iwl_mvm_vif *mvmvif =
+			iwl_mvm_vif_from_mac80211(tx_blocked_vif);
+
+		/*
+		 * The channel switch is started and we have blocked the
+		 * stations. If this is the first beacon (the timeout wasn't
+		 * set), set the unblock timeout, otherwise countdown
+		 */
+		if (!mvm->csa_tx_block_bcn_timeout)
+			mvm->csa_tx_block_bcn_timeout =
+				IWL_MVM_CS_UNBLOCK_TX_TIMEOUT;
+		else
+			mvm->csa_tx_block_bcn_timeout--;
+
+		/* Check if the timeout is expired, and unblock tx */
+		if (mvm->csa_tx_block_bcn_timeout == 0) {
+			iwl_mvm_modify_all_sta_disable_tx(mvm, mvmvif, false);
+			RCU_INIT_POINTER(mvm->csa_tx_blocked_vif, NULL);
+		}
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 4a0350f..5ed6fb3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1614,6 +1614,11 @@ static void iwl_mvm_stop_ap_ibss(struct ieee80211_hw *hw,
 		RCU_INIT_POINTER(mvm->csa_vif, NULL);
 	}
 
+	if (rcu_access_pointer(mvm->csa_tx_blocked_vif) == vif) {
+		RCU_INIT_POINTER(mvm->csa_tx_blocked_vif, NULL);
+		mvm->csa_tx_block_bcn_timeout = 0;
+	}
+
 	mvmvif->ap_ibss_active = false;
 	mvm->ap_last_beacon_gp2 = 0;
 
@@ -2491,6 +2496,12 @@ static void __iwl_mvm_unassign_vif_chanctx(struct iwl_mvm *mvm,
 		if (!vif->csa_active || !mvmvif->ap_ibss_active)
 			goto out;
 
+		/* Set CS bit on all the stations */
+		iwl_mvm_modify_all_sta_disable_tx(mvm, mvmvif, true);
+
+		/* Save blocked iface, the timeout is set on the next beacon */
+		rcu_assign_pointer(mvm->csa_tx_blocked_vif, vif);
+
 		mvmvif->ap_ibss_active = false;
 		break;
 	case NL80211_IFTYPE_STATION:
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index db496c5..7b308c4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -95,6 +95,12 @@
  */
 #define IWL_MVM_CHANNEL_SWITCH_MARGIN 4
 
+/*
+ * Number of beacons to transmit on a new channel until we unblock tx to
+ * the stations, even if we didn't identify them on a new channel
+ */
+#define IWL_MVM_CS_UNBLOCK_TX_TIMEOUT 3
+
 enum iwl_mvm_tx_fifo {
 	IWL_MVM_TX_FIFO_BK = 0,
 	IWL_MVM_TX_FIFO_BE,
@@ -671,6 +677,8 @@ struct iwl_mvm {
 	bool ps_disabled;
 
 	struct ieee80211_vif __rcu *csa_vif;
+	struct ieee80211_vif __rcu *csa_tx_blocked_vif;
+	u8 csa_tx_block_bcn_timeout;
 
 	/* system time of last beacon (for AP/GO interface) */
 	u32 ap_last_beacon_gp2;
diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index cf72769..4b98987 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -259,6 +259,23 @@ int iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 	memset(&rx_status, 0, sizeof(rx_status));
 
 	/*
+	 * We have tx blocked stations (with CS bit). If we heard frames from
+	 * a blocked station on a new channel we can TX to it again.
+	 */
+	if (unlikely(mvm->csa_tx_block_bcn_timeout)) {
+		struct ieee80211_sta *sta;
+
+		rcu_read_lock();
+
+		sta = ieee80211_find_sta(
+			rcu_dereference(mvm->csa_tx_blocked_vif), hdr->addr2);
+		if (sta)
+			iwl_mvm_sta_modify_disable_tx_ap(mvm, sta, false);
+
+		rcu_read_unlock();
+	}
+
+	/*
 	 * drop the packet if it has failed being decrypted by HW
 	 */
 	if (iwl_mvm_set_mac80211_rx_flag(mvm, hdr, &rx_status, rx_pkt_status)) {
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index d3a6cf7..8128139 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -1468,3 +1468,57 @@ void iwl_mvm_sta_modify_disable_tx(struct iwl_mvm *mvm,
 	if (ret)
 		IWL_ERR(mvm, "Failed to send ADD_STA command (%d)\n", ret);
 }
+
+void iwl_mvm_sta_modify_disable_tx_ap(struct iwl_mvm *mvm,
+				      struct ieee80211_sta *sta,
+				      bool disable)
+{
+	struct iwl_mvm_sta *mvm_sta = iwl_mvm_sta_from_mac80211(sta);
+
+	spin_lock_bh(&mvm_sta->lock);
+
+	if (mvm_sta->disable_tx == disable) {
+		spin_unlock_bh(&mvm_sta->lock);
+		return;
+	}
+
+	mvm_sta->disable_tx = disable;
+
+	/*
+	 * Tell mac80211 to start/stop queueing tx for this station,
+	 * but don't stop queueing if there are still pending frames
+	 * for this station.
+	 */
+	if (disable || !atomic_read(&mvm->pending_frames[mvm_sta->sta_id]))
+		ieee80211_sta_block_awake(mvm->hw, sta, disable);
+
+	iwl_mvm_sta_modify_disable_tx(mvm, mvm_sta, disable);
+
+	spin_unlock_bh(&mvm_sta->lock);
+}
+
+void iwl_mvm_modify_all_sta_disable_tx(struct iwl_mvm *mvm,
+				       struct iwl_mvm_vif *mvmvif,
+				       bool disable)
+{
+	struct ieee80211_sta *sta;
+	struct iwl_mvm_sta *mvm_sta;
+	int i;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	/* Block/unblock all the stations of the given mvmvif */
+	for (i = 0; i < IWL_MVM_STATION_COUNT; i++) {
+		sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[i],
+						lockdep_is_held(&mvm->mutex));
+		if (IS_ERR_OR_NULL(sta))
+			continue;
+
+		mvm_sta = iwl_mvm_sta_from_mac80211(sta);
+		if (mvm_sta->mac_id_n_color !=
+		    FW_CMD_ID_AND_COLOR(mvmvif->id, mvmvif->color))
+			continue;
+
+		iwl_mvm_sta_modify_disable_tx_ap(mvm, sta, disable);
+	}
+}
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.h b/drivers/net/wireless/iwlwifi/mvm/sta.h
index 10c1a53..3b1c8bd 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.h
@@ -73,6 +73,7 @@
 #include "rs.h"
 
 struct iwl_mvm;
+struct iwl_mvm_vif;
 
 /**
  * DOC: station table - introduction
@@ -295,6 +296,7 @@ static inline u16 iwl_mvm_tid_queued(struct iwl_mvm_tid_data *tid_data)
  * @tid_data: per tid data. Look at %iwl_mvm_tid_data.
  * @tx_protection: reference counter for controlling the Tx protection.
  * @tt_tx_protection: is thermal throttling enable Tx protection?
+ * @disable_tx: is tx to this STA disabled?
  *
  * When mac80211 creates a station it reserves some space (hw->sta_data_size)
  * in the structure for use by driver. This structure is placed in that
@@ -317,6 +319,8 @@ struct iwl_mvm_sta {
 	/* Temporary, until the new TLC will control the Tx protection */
 	s8 tx_protection;
 	bool tt_tx_protection;
+
+	bool disable_tx;
 };
 
 static inline struct iwl_mvm_sta *
@@ -406,5 +410,11 @@ int iwl_mvm_drain_sta(struct iwl_mvm *mvm, struct iwl_mvm_sta *mvmsta,
 		      bool drain);
 void iwl_mvm_sta_modify_disable_tx(struct iwl_mvm *mvm,
 				   struct iwl_mvm_sta *mvmsta, bool disable);
+void iwl_mvm_sta_modify_disable_tx_ap(struct iwl_mvm *mvm,
+				      struct ieee80211_sta *sta,
+				      bool disable);
+void iwl_mvm_modify_all_sta_disable_tx(struct iwl_mvm *mvm,
+				       struct iwl_mvm_vif *mvmvif,
+				       bool disable);
 
 #endif /* __sta_h__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index fa87a4b..f5c0982 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -727,13 +727,21 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 		goto out;
 
 	if (mvmsta && mvmsta->vif->type == NL80211_IFTYPE_AP) {
+
 		/*
-		 * If there are no pending frames for this STA, notify
-		 * mac80211 that this station can go to sleep in its
+		 * If there are no pending frames for this STA and
+		 * the tx to this station is not disabled, notify
+		 * mac80211 that this station can now wake up in its
 		 * STA table.
 		 * If mvmsta is not NULL, sta is valid.
 		 */
-		ieee80211_sta_block_awake(mvm->hw, sta, false);
+
+		spin_lock_bh(&mvmsta->lock);
+
+		if (!mvmsta->disable_tx)
+			ieee80211_sta_block_awake(mvm->hw, sta, false);
+
+		spin_unlock_bh(&mvmsta->lock);
 	}
 
 	if (PTR_ERR(sta) == -EBUSY || PTR_ERR(sta) == -ENOENT) {
-- 
1.8.3.2

