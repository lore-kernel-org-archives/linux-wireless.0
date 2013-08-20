Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:52305 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875Ab3HTLM2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Aug 2013 07:12:28 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [RFC 2/2] mac80211: implement SMPS for AP
Date: Tue, 20 Aug 2013 14:12:19 +0300
Message-Id: <1376997139-6228-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20130820_131232_190461_D5FCAB1C)
In-Reply-To: <1376997139-6228-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1376997139-6228-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the driver requests to move to STATIC or DYNAMIC SMPS,
we send an action frame to each associated station and
reconfigure the channel context / driver.
Of course, non-MIMO stations are ignored.

The beacon isn't updated. The association response will
include the original capabilities. Stations that associate
while in non-OFF SMPS mode will get an action frame right
after association to inform them about our current state.
Note that we wait until the end of the EAPOL. Sending an
action frame before the EAPOL is finished can be an issue
for a few clients. Clients aren't likely to send EAPOL
frames in MIMO anyway.

When the SMPS configuration gets more permissive (e.g.
STATIC -> OFF), we don't wake up stations that are asleep
We remember that they don't know about the change and send
the action frame when they wake up.

When the SMPS configuration gets more restrictive (e.g.
OFF -> STATIC), we set the TIM bit for every sleeping STA.
uAPSD stations might send MIMO until they poll the action
frame, but this is for a short period of time.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/cfg.c            |   91 +++++++++++++++++++++++++++++++++++++++++
 net/mac80211/debugfs_netdev.c |    1 +
 net/mac80211/ht.c             |    3 ++
 net/mac80211/ieee80211_i.h    |    3 ++
 net/mac80211/sta_info.c       |   56 +++++++++++++++++++++++++
 net/mac80211/sta_info.h       |    5 +++
 net/mac80211/status.c         |   15 ++++---
 net/mac80211/util.c           |   25 +++++++++++
 8 files changed, 194 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index bd6b38c..0e00c83 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1553,6 +1553,19 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 
 	mutex_unlock(&local->sta_mtx);
 
+	if (sdata->vif.type == NL80211_IFTYPE_AP &&
+	    sta->known_smps_mode != sta->sdata->smps_mode &&
+	    test_sta_flag(sta, WLAN_STA_AUTHORIZED) &&
+	    sta_info_tx_chains(sta) != 1) {
+		ht_dbg(sta->sdata,
+		       "%pM just authorized and MIMO capable - update SMPS\n",
+		       sta->sta.addr);
+		ieee80211_send_smps_action(sta->sdata,
+			sta->sdata->u.ap.req_smps,
+			sta->sta.addr,
+			sta->sdata->vif.bss_conf.bssid);
+	}
+
 	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
 	    params->sta_flags_mask & BIT(NL80211_STA_FLAG_AUTHORIZED)) {
 		ieee80211_recalc_ps(local, -1);
@@ -2340,6 +2353,84 @@ static int ieee80211_testmode_dump(struct wiphy *wiphy,
 int __ieee80211_request_smps_ap(struct ieee80211_sub_if_data *sdata,
 				enum ieee80211_smps_mode smps_mode)
 {
+	struct sta_info *sta;
+	enum ieee80211_smps_mode old_req;
+	int i;
+
+	if (WARN_ON_ONCE(sdata->vif.type != NL80211_IFTYPE_AP))
+		return -EINVAL;
+
+	if (sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_20_NOHT)
+		return 0;
+
+	old_req = sdata->u.ap.req_smps;
+	sdata->u.ap.req_smps = smps_mode;
+
+	/* AUTOMATIC doesn't mean much for AP - don't allow it */
+	if (old_req == smps_mode ||
+	    smps_mode == IEEE80211_SMPS_AUTOMATIC)
+		return 0;
+
+	 /* If no associated stations, there's no need to do anything */
+	if (!atomic_read(&sdata->u.ap.num_mcast_sta)) {
+		sdata->smps_mode = smps_mode;
+		ieee80211_queue_work(&sdata->local->hw, &sdata->recalc_smps);
+		return 0;
+	}
+
+	ht_dbg(sdata,
+	       "SMSP %d requested in AP mode, sending Action frame to %d stations\n",
+	       smps_mode, atomic_read(&sdata->u.ap.num_mcast_sta));
+
+	mutex_lock(&sdata->local->sta_mtx);
+	for (i = 0; i < STA_HASH_SIZE; i++) {
+		for (sta = rcu_dereference_protected(sdata->local->sta_hash[i],
+				lockdep_is_held(&sdata->local->sta_mtx));
+		     sta;
+		     sta = rcu_dereference_protected(sta->hnext,
+				lockdep_is_held(&sdata->local->sta_mtx))) {
+			if (sta->sdata != sdata)
+				continue;
+
+			/* This station doesn't support MIMO - skip it */
+			if (sta_info_tx_chains(sta) == 1) {
+				ht_dbg(sdata,
+				       "Won't send SMPS to non-MIMO capable STA %pM\n",
+				       sta->sta.addr);
+				continue;
+			}
+
+			/*
+			 * Don't wake up a STA just to send the action frame
+			 * unless we are getting more restrictive.
+			 */
+			if (test_sta_flag(sta, WLAN_STA_PS_STA) &&
+			    !ieee80211_smps_is_restrictive(sta->known_smps_mode,
+							   smps_mode)) {
+				ht_dbg(sdata,
+				       "Won't send SMPS to sleeping STA %pM\n",
+				       sta->sta.addr);
+				continue;
+			}
+
+			/*
+			 * If the STA is not authorized, wait until it gets
+			 * authorized and the action frame will be sent then.
+			 */
+			if (!test_sta_flag(sta, WLAN_STA_AUTHORIZED))
+				continue;
+
+			ht_dbg(sdata, "Sending SMPS to %pM\n", sta->sta.addr);
+			ieee80211_send_smps_action(sdata, smps_mode,
+						   sta->sta.addr,
+						   sdata->vif.bss_conf.bssid);
+		}
+	}
+	mutex_unlock(&sdata->local->sta_mtx);
+
+	sdata->smps_mode = smps_mode;
+	ieee80211_queue_work(&sdata->local->hw, &sdata->recalc_smps);
+
 	return 0;
 }
 
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 7609e47..4e9ec9e 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -569,6 +569,7 @@ static void add_sta_files(struct ieee80211_sub_if_data *sdata)
 static void add_ap_files(struct ieee80211_sub_if_data *sdata)
 {
 	DEBUGFS_ADD(num_mcast_sta);
+	DEBUGFS_ADD_MODE(smps, 0600);
 	DEBUGFS_ADD(num_sta_ps);
 	DEBUGFS_ADD(dtim_count);
 	DEBUGFS_ADD(num_buffered_multicast);
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 2c85b96..9a8be8f 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -489,6 +489,9 @@ void ieee80211_request_smps(struct ieee80211_vif *vif,
 		ieee80211_queue_work(&sdata->local->hw,
 				     &sdata->u.mgd.request_smps_work);
 	} else {
+		/* AUTOMATIC is meaningless in AP mode */
+		if (WARN_ON_ONCE(smps_mode == IEEE80211_SMPS_AUTOMATIC))
+			return;
 		if (sdata->u.ap.driver_smps_mode == smps_mode)
 			return;
 		sdata->u.ap.driver_smps_mode = smps_mode;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 7c68eac..85387cb 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1445,6 +1445,9 @@ int ieee80211_send_smps_action(struct ieee80211_sub_if_data *sdata,
 			       const u8 *bssid);
 void ieee80211_request_smps_ap_work(struct work_struct *work);
 void ieee80211_request_smps_mgd_work(struct work_struct *work);
+bool ieee80211_smps_is_restrictive(enum ieee80211_smps_mode smps_mode_old,
+				   enum ieee80211_smps_mode smps_mode_new);
+
 
 void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 				     u16 initiator, u16 reason, bool stop);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 9c97237..74c88ba 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -385,6 +385,25 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 		sta->last_seq_ctrl[i] = cpu_to_le16(USHRT_MAX);
 
 	sta->sta.smps_mode = IEEE80211_SMPS_OFF;
+	if (sdata->vif.type == NL80211_IFTYPE_AP) {
+		struct ieee80211_supported_band *sband =
+			local->hw.wiphy->bands[ieee80211_get_sdata_band(sdata)];
+		u8 smps = (sband->ht_cap.cap & IEEE80211_HT_CAP_SM_PS) >>
+				IEEE80211_HT_CAP_SM_PS_SHIFT;
+		switch (smps) {
+		case WLAN_HT_SMPS_CONTROL_DISABLED:
+			sta->known_smps_mode = IEEE80211_SMPS_OFF;
+			break;
+		case WLAN_HT_SMPS_CONTROL_STATIC:
+			sta->known_smps_mode = IEEE80211_SMPS_STATIC;
+			break;
+		case WLAN_HT_SMPS_CONTROL_DYNAMIC:
+			sta->known_smps_mode = IEEE80211_SMPS_DYNAMIC;
+			break;
+		default:
+			WARN_ON(1);
+		}
+	}
 
 	sta_dbg(sdata, "Allocated STA %pM\n", sta->sta.addr);
 
@@ -1069,6 +1088,19 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 
 	ieee80211_add_pending_skbs_fn(local, &pending, clear_sta_ps_flags, sta);
 
+	/* This station just woke up and isn't aware of our SMPS state */
+	if (!ieee80211_smps_is_restrictive(sta->known_smps_mode,
+					   sdata->smps_mode) &&
+	    sta->known_smps_mode != sdata->smps_mode &&
+	    sta_info_tx_chains(sta) != 1) {
+		ht_dbg(sdata,
+		       "%pM just woke up and MIMO capable - update SMPS\n",
+		       sta->sta.addr);
+		ieee80211_send_smps_action(sdata, sdata->smps_mode,
+					   sta->sta.addr,
+					   sdata->vif.bss_conf.bssid);
+	}
+
 	local->total_ps_buffered -= buffered;
 
 	sta_info_recalc_tim(sta);
@@ -1520,3 +1552,27 @@ int sta_info_move_state(struct sta_info *sta,
 
 	return 0;
 }
+
+u8 sta_info_tx_chains(struct sta_info *sta)
+{
+	struct ieee80211_sta_ht_cap *ht_cap = &sta->sta.ht_cap;
+	u8 rx_chains;
+
+	if (!sta->sta.ht_cap.ht_supported)
+		return 1;
+
+	if (ht_cap->mcs.rx_mask[3])
+		rx_chains = 4;
+	else if (ht_cap->mcs.rx_mask[2])
+		rx_chains = 3;
+	else if (ht_cap->mcs.rx_mask[1])
+		rx_chains = 2;
+	else
+		rx_chains = 1;
+
+	if (!(ht_cap->mcs.tx_params & IEEE80211_HT_MCS_TX_RX_DIFF))
+		return rx_chains;
+
+	return ((ht_cap->mcs.tx_params & IEEE80211_HT_MCS_TX_MAX_STREAMS_MASK)
+			>> IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT) + 1;
+}
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 9013969..240aef2 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -301,6 +301,8 @@ struct sta_ampdu_mlme {
  * @chains: chains ever used for RX from this station
  * @chain_signal_last: last signal (per chain)
  * @chain_signal_avg: signal average (per chain)
+ * @known_smps_mode: the smps_mode the client thinks we are in. Relevant for
+ *	AP only.
  */
 struct sta_info {
 	/* General information, mostly static */
@@ -411,6 +413,8 @@ struct sta_info {
 	unsigned int lost_packets;
 	unsigned int beacon_loss_count;
 
+	enum ieee80211_smps_mode known_smps_mode;
+
 	/* keep last! */
 	struct ieee80211_sta sta;
 };
@@ -613,6 +617,7 @@ void sta_set_rate_info_rx(struct sta_info *sta,
 			  struct rate_info *rinfo);
 void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
 			  unsigned long exp_time);
+u8 sta_info_tx_chains(struct sta_info *sta);
 
 void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta);
 void ieee80211_sta_ps_deliver_poll_response(struct sta_info *sta);
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 368837f..7746cd0 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -191,8 +191,8 @@ static void ieee80211_frame_acked(struct sta_info *sta, struct sk_buff *skb)
 	if (ieee80211_is_action(mgmt->frame_control) &&
 	    mgmt->u.action.category == WLAN_CATEGORY_HT &&
 	    mgmt->u.action.u.ht_smps.action == WLAN_HT_ACTION_SMPS &&
-	    sdata->vif.type == NL80211_IFTYPE_STATION &&
 	    ieee80211_sdata_running(sdata)) {
+		enum ieee80211_smps_mode smps_mode;
 		/*
 		 * This update looks racy, but isn't -- if we come
 		 * here we've definitely got a station that we're
@@ -202,18 +202,23 @@ static void ieee80211_frame_acked(struct sta_info *sta, struct sk_buff *skb)
 		 */
 		switch (mgmt->u.action.u.ht_smps.smps_control) {
 		case WLAN_HT_SMPS_CONTROL_DYNAMIC:
-			sdata->smps_mode = IEEE80211_SMPS_DYNAMIC;
+			smps_mode = IEEE80211_SMPS_DYNAMIC;
 			break;
 		case WLAN_HT_SMPS_CONTROL_STATIC:
-			sdata->smps_mode = IEEE80211_SMPS_STATIC;
+			smps_mode = IEEE80211_SMPS_STATIC;
 			break;
 		case WLAN_HT_SMPS_CONTROL_DISABLED:
 		default: /* shouldn't happen since we don't send that */
-			sdata->smps_mode = IEEE80211_SMPS_OFF;
+			smps_mode = IEEE80211_SMPS_OFF;
 			break;
 		}
 
-		ieee80211_queue_work(&local->hw, &sdata->recalc_smps);
+		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
+			sdata->smps_mode = smps_mode;
+			ieee80211_queue_work(&local->hw, &sdata->recalc_smps);
+		} else if (sdata->vif.type == NL80211_IFTYPE_AP) {
+			sta->known_smps_mode = smps_mode;
+		}
 	}
 }
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index d23c5a7..dad8262 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2295,3 +2295,28 @@ void ieee80211_radar_detected(struct ieee80211_hw *hw)
 	ieee80211_queue_work(hw, &local->radar_detected_work);
 }
 EXPORT_SYMBOL(ieee80211_radar_detected);
+
+/*
+ * Returns true if smps_mode_new is strictly more restrictive than
+ * smps_mode_old.
+ */
+bool ieee80211_smps_is_restrictive(enum ieee80211_smps_mode smps_mode_old,
+				   enum ieee80211_smps_mode smps_mode_new)
+{
+	if (WARN_ON_ONCE(smps_mode_old == IEEE80211_SMPS_AUTOMATIC ||
+			 smps_mode_new == IEEE80211_SMPS_AUTOMATIC))
+		return false;
+
+	switch (smps_mode_old) {
+	case IEEE80211_SMPS_STATIC:
+		return false;
+	case IEEE80211_SMPS_DYNAMIC:
+		return smps_mode_new == IEEE80211_SMPS_STATIC;
+	case IEEE80211_SMPS_OFF:
+		return smps_mode_new != IEEE80211_SMPS_OFF;
+	default:
+		WARN_ON(1);
+	}
+
+	return false;
+}
-- 
1.7.10.4

