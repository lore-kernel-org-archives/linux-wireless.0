Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:58823 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753010Ab3JANps (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 09:45:48 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: implement SMPS for AP
Date: Tue,  1 Oct 2013 16:45:43 +0300
Message-Id: <1380635144-12875-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20131001_154552_593349_347408B4)
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
This patch was sent long ago. I fixed VLAN handling
---
 net/mac80211/cfg.c            |  108 +++++++++++++++++++++++++++++++++++++++--
 net/mac80211/debugfs_netdev.c |   25 ++++++----
 net/mac80211/ht.c             |   41 ++++++++++++----
 net/mac80211/ieee80211_i.h    |   15 ++++--
 net/mac80211/iface.c          |    2 +
 net/mac80211/mlme.c           |    2 +-
 net/mac80211/sta_info.c       |   72 +++++++++++++++++++++++++++
 net/mac80211/sta_info.h       |    5 ++
 net/mac80211/status.c         |   31 +++++++-----
 net/mac80211/util.c           |   25 ++++++++++
 10 files changed, 288 insertions(+), 38 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index befb23f..2720373 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1059,6 +1059,7 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	/* abort any running channel switch */
 	sdata->vif.csa_active = false;
 	cancel_work_sync(&sdata->csa_finalize_work);
+	cancel_work_sync(&sdata->u.ap.request_smps_work);
 
 	/* turn off carrier for this interface and dependent VLANs */
 	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
@@ -1553,6 +1554,20 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 
 	mutex_unlock(&local->sta_mtx);
 
+	if ((sdata->vif.type == NL80211_IFTYPE_AP ||
+	     sdata->vif.type == NL80211_IFTYPE_AP_VLAN) &&
+	    sta->known_smps_mode != sta->sdata->bss->req_smps &&
+	    test_sta_flag(sta, WLAN_STA_AUTHORIZED) &&
+	    sta_info_tx_streams(sta) != 1) {
+		ht_dbg(sta->sdata,
+		       "%pM just authorized and MIMO capable - update SMPS\n",
+		       sta->sta.addr);
+		ieee80211_send_smps_action(sta->sdata,
+			sta->sdata->bss->req_smps,
+			sta->sta.addr,
+			sta->sdata->vif.bss_conf.bssid);
+	}
+
 	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
 	    params->sta_flags_mask & BIT(NL80211_STA_FLAG_AUTHORIZED)) {
 		ieee80211_recalc_ps(local, -1);
@@ -2337,8 +2352,92 @@ static int ieee80211_testmode_dump(struct wiphy *wiphy,
 }
 #endif
 
-int __ieee80211_request_smps(struct ieee80211_sub_if_data *sdata,
-			     enum ieee80211_smps_mode smps_mode)
+int __ieee80211_request_smps_ap(struct ieee80211_sub_if_data *sdata,
+				enum ieee80211_smps_mode smps_mode)
+{
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
+			/*
+			 * Only stations associated to our AP and
+			 * associated VLANs
+			 */
+			if (sta->sdata->bss != &sdata->u.ap)
+				continue;
+
+			/* This station doesn't support MIMO - skip it */
+			if (sta_info_tx_streams(sta) == 1)
+				continue;
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
+	return 0;
+}
+
+int __ieee80211_request_smps_mgd(struct ieee80211_sub_if_data *sdata,
+				 enum ieee80211_smps_mode smps_mode)
 {
 	const u8 *ap;
 	enum ieee80211_smps_mode old_req;
@@ -2346,6 +2445,9 @@ int __ieee80211_request_smps(struct ieee80211_sub_if_data *sdata,
 
 	lockdep_assert_held(&sdata->wdev.mtx);
 
+	if (WARN_ON_ONCE(sdata->vif.type != NL80211_IFTYPE_STATION))
+		return -EINVAL;
+
 	old_req = sdata->u.mgd.req_smps;
 	sdata->u.mgd.req_smps = smps_mode;
 
@@ -2402,7 +2504,7 @@ static int ieee80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 
 	/* no change, but if automatic follow powersave */
 	sdata_lock(sdata);
-	__ieee80211_request_smps(sdata, sdata->u.mgd.req_smps);
+	__ieee80211_request_smps_mgd(sdata, sdata->u.mgd.req_smps);
 	sdata_unlock(sdata);
 
 	if (local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS)
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index ebde2fb..46ba3fb 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -227,12 +227,15 @@ static int ieee80211_set_smps(struct ieee80211_sub_if_data *sdata,
 	    target_mode == IEEE80211_SMPS_DYNAMIC)
 		return -EINVAL;
 
-	/* supported only on managed interfaces for now */
-	if (sdata->vif.type != NL80211_IFTYPE_STATION)
+	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
+	    sdata->vif.type != NL80211_IFTYPE_AP)
 		return -EOPNOTSUPP;
 
 	sdata_lock(sdata);
-	err = __ieee80211_request_smps(sdata, smps_mode);
+	if (sdata->vif.type == NL80211_IFTYPE_STATION)
+		err = __ieee80211_request_smps_mgd(sdata, smps_mode);
+	else
+		err = __ieee80211_request_smps_ap(sdata, smps_mode);
 	sdata_unlock(sdata);
 
 	return err;
@@ -248,12 +251,15 @@ static const char *smps_modes[IEEE80211_SMPS_NUM_MODES] = {
 static ssize_t ieee80211_if_fmt_smps(const struct ieee80211_sub_if_data *sdata,
 				     char *buf, int buflen)
 {
-	if (sdata->vif.type != NL80211_IFTYPE_STATION)
-		return -EOPNOTSUPP;
-
-	return snprintf(buf, buflen, "request: %s\nused: %s\n",
-			smps_modes[sdata->u.mgd.req_smps],
-			smps_modes[sdata->smps_mode]);
+	if (sdata->vif.type == NL80211_IFTYPE_STATION)
+		return snprintf(buf, buflen, "request: %s\nused: %s\n",
+				smps_modes[sdata->u.mgd.req_smps],
+				smps_modes[sdata->smps_mode]);
+	if (sdata->vif.type == NL80211_IFTYPE_AP)
+		return snprintf(buf, buflen, "request: %s\nused: %s\n",
+				smps_modes[sdata->u.ap.req_smps],
+				smps_modes[sdata->smps_mode]);
+	return -EINVAL;
 }
 
 static ssize_t ieee80211_if_parse_smps(struct ieee80211_sub_if_data *sdata,
@@ -566,6 +572,7 @@ static void add_sta_files(struct ieee80211_sub_if_data *sdata)
 static void add_ap_files(struct ieee80211_sub_if_data *sdata)
 {
 	DEBUGFS_ADD(num_mcast_sta);
+	DEBUGFS_ADD_MODE(smps, 0600);
 	DEBUGFS_ADD(num_sta_ps);
 	DEBUGFS_ADD(dtim_count);
 	DEBUGFS_ADD(num_buffered_multicast);
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 529bf58..9a8be8f 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -448,14 +448,25 @@ int ieee80211_send_smps_action(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
-void ieee80211_request_smps_work(struct work_struct *work)
+void ieee80211_request_smps_mgd_work(struct work_struct *work)
 {
 	struct ieee80211_sub_if_data *sdata =
 		container_of(work, struct ieee80211_sub_if_data,
 			     u.mgd.request_smps_work);
 
 	sdata_lock(sdata);
-	__ieee80211_request_smps(sdata, sdata->u.mgd.driver_smps_mode);
+	__ieee80211_request_smps_mgd(sdata, sdata->u.mgd.driver_smps_mode);
+	sdata_unlock(sdata);
+}
+
+void ieee80211_request_smps_ap_work(struct work_struct *work)
+{
+	struct ieee80211_sub_if_data *sdata =
+		container_of(work, struct ieee80211_sub_if_data,
+			     u.ap.request_smps_work);
+
+	sdata_lock(sdata);
+	__ieee80211_request_smps_ap(sdata, sdata->u.ap.driver_smps_mode);
 	sdata_unlock(sdata);
 }
 
@@ -464,19 +475,29 @@ void ieee80211_request_smps(struct ieee80211_vif *vif,
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 
-	if (WARN_ON(vif->type != NL80211_IFTYPE_STATION))
+	if (WARN_ON_ONCE(vif->type != NL80211_IFTYPE_STATION &&
+			 vif->type != NL80211_IFTYPE_AP))
 		return;
 
 	if (WARN_ON(smps_mode == IEEE80211_SMPS_OFF))
 		smps_mode = IEEE80211_SMPS_AUTOMATIC;
 
-	if (sdata->u.mgd.driver_smps_mode == smps_mode)
-		return;
-
-	sdata->u.mgd.driver_smps_mode = smps_mode;
-
-	ieee80211_queue_work(&sdata->local->hw,
-			     &sdata->u.mgd.request_smps_work);
+	if (vif->type == NL80211_IFTYPE_STATION) {
+		if (sdata->u.mgd.driver_smps_mode == smps_mode)
+			return;
+		sdata->u.mgd.driver_smps_mode = smps_mode;
+		ieee80211_queue_work(&sdata->local->hw,
+				     &sdata->u.mgd.request_smps_work);
+	} else {
+		/* AUTOMATIC is meaningless in AP mode */
+		if (WARN_ON_ONCE(smps_mode == IEEE80211_SMPS_AUTOMATIC))
+			return;
+		if (sdata->u.ap.driver_smps_mode == smps_mode)
+			return;
+		sdata->u.ap.driver_smps_mode = smps_mode;
+		ieee80211_queue_work(&sdata->local->hw,
+				     &sdata->u.ap.request_smps_work);
+	}
 }
 /* this might change ... don't want non-open drivers using it */
 EXPORT_SYMBOL_GPL(ieee80211_request_smps);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d604e16..09ebb73 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -262,6 +262,10 @@ struct ieee80211_if_ap {
 
 	struct ps_data ps;
 	atomic_t num_mcast_sta; /* number of stations receiving multicast */
+	enum ieee80211_smps_mode req_smps, /* requested smps mode */
+			 driver_smps_mode; /* smps mode request */
+
+	struct work_struct request_smps_work;
 };
 
 struct ieee80211_if_wds {
@@ -1436,7 +1440,10 @@ void ieee80211_send_delba(struct ieee80211_sub_if_data *sdata,
 int ieee80211_send_smps_action(struct ieee80211_sub_if_data *sdata,
 			       enum ieee80211_smps_mode smps, const u8 *da,
 			       const u8 *bssid);
-void ieee80211_request_smps_work(struct work_struct *work);
+void ieee80211_request_smps_ap_work(struct work_struct *work);
+void ieee80211_request_smps_mgd_work(struct work_struct *work);
+bool ieee80211_smps_is_restrictive(enum ieee80211_smps_mode smps_mode_old,
+				   enum ieee80211_smps_mode smps_mode_new);
 
 void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 				     u16 initiator, u16 reason, bool stop);
@@ -1631,8 +1638,10 @@ void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 u32 ieee80211_sta_get_rates(struct ieee80211_sub_if_data *sdata,
 			    struct ieee802_11_elems *elems,
 			    enum ieee80211_band band, u32 *basic_rates);
-int __ieee80211_request_smps(struct ieee80211_sub_if_data *sdata,
-			     enum ieee80211_smps_mode smps_mode);
+int __ieee80211_request_smps_mgd(struct ieee80211_sub_if_data *sdata,
+				 enum ieee80211_smps_mode smps_mode);
+int __ieee80211_request_smps_ap(struct ieee80211_sub_if_data *sdata,
+				enum ieee80211_smps_mode smps_mode);
 void ieee80211_recalc_smps(struct ieee80211_sub_if_data *sdata);
 
 size_t ieee80211_ie_split(const u8 *ies, size_t ielen,
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index e1e484d..68016ef 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1304,6 +1304,8 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 	case NL80211_IFTYPE_AP:
 		skb_queue_head_init(&sdata->u.ap.ps.bc_buf);
 		INIT_LIST_HEAD(&sdata->u.ap.vlans);
+		INIT_WORK(&sdata->u.ap.request_smps_work,
+			  ieee80211_request_smps_ap_work);
 		sdata->vif.bss_conf.bssid = sdata->vif.addr;
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index ed84af6..fb140f2 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3697,7 +3697,7 @@ void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
 		  ieee80211_beacon_connection_loss_work);
 	INIT_WORK(&ifmgd->csa_connection_drop_work,
 		  ieee80211_csa_connection_drop_work);
-	INIT_WORK(&ifmgd->request_smps_work, ieee80211_request_smps_work);
+	INIT_WORK(&ifmgd->request_smps_work, ieee80211_request_smps_mgd_work);
 	setup_timer(&ifmgd->timer, ieee80211_sta_timer,
 		    (unsigned long) sdata);
 	setup_timer(&ifmgd->bcn_mon_timer, ieee80211_sta_bcn_mon_timer,
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 9c97237..a6cd1e5 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -385,6 +385,30 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 		sta->last_seq_ctrl[i] = cpu_to_le16(USHRT_MAX);
 
 	sta->sta.smps_mode = IEEE80211_SMPS_OFF;
+	if (sdata->vif.type == NL80211_IFTYPE_AP ||
+	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
+		struct ieee80211_supported_band *sband =
+			local->hw.wiphy->bands[ieee80211_get_sdata_band(sdata)];
+		u8 smps = (sband->ht_cap.cap & IEEE80211_HT_CAP_SM_PS) >>
+				IEEE80211_HT_CAP_SM_PS_SHIFT;
+		/*
+		 * Assume that hostapd advertises our caps in the beacon and
+		 * this is the known_smps_mode for a station that just assciated
+		 */
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
 
@@ -1069,6 +1093,19 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 
 	ieee80211_add_pending_skbs_fn(local, &pending, clear_sta_ps_flags, sta);
 
+	/* This station just woke up and isn't aware of our SMPS state */
+	if (!ieee80211_smps_is_restrictive(sta->known_smps_mode,
+					   sdata->smps_mode) &&
+	    sta->known_smps_mode != sdata->bss->req_smps &&
+	    sta_info_tx_streams(sta) != 1) {
+		ht_dbg(sdata,
+		       "%pM just woke up and MIMO capable - update SMPS\n",
+		       sta->sta.addr);
+		ieee80211_send_smps_action(sdata, sdata->bss->req_smps,
+					   sta->sta.addr,
+					   sdata->vif.bss_conf.bssid);
+	}
+
 	local->total_ps_buffered -= buffered;
 
 	sta_info_recalc_tim(sta);
@@ -1520,3 +1557,38 @@ int sta_info_move_state(struct sta_info *sta,
 
 	return 0;
 }
+
+u8 sta_info_tx_streams(struct sta_info *sta)
+{
+	struct ieee80211_sta_ht_cap *ht_cap = &sta->sta.ht_cap;
+	u8 rx_streams;
+
+	if (!sta->sta.ht_cap.ht_supported)
+		return 1;
+
+	if (sta->sta.vht_cap.vht_supported) {
+		int i;
+		u16 tx_mcs_map =
+			le16_to_cpu(sta->sta.vht_cap.vht_mcs.tx_mcs_map);
+
+		for (i = 7; i <= 0; i--)
+			if ((tx_mcs_map & (0x3 << (i * 2))) !=
+			    IEEE80211_VHT_MCS_NOT_SUPPORTED)
+				return i + 1;
+	}
+
+	if (ht_cap->mcs.rx_mask[3])
+		rx_streams = 4;
+	else if (ht_cap->mcs.rx_mask[2])
+		rx_streams = 3;
+	else if (ht_cap->mcs.rx_mask[1])
+		rx_streams = 2;
+	else
+		rx_streams = 1;
+
+	if (!(ht_cap->mcs.tx_params & IEEE80211_HT_MCS_TX_RX_DIFF))
+		return rx_streams;
+
+	return ((ht_cap->mcs.tx_params & IEEE80211_HT_MCS_TX_MAX_STREAMS_MASK)
+			>> IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT) + 1;
+}
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 9013969..390d249 100644
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
+u8 sta_info_tx_streams(struct sta_info *sta);
 
 void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta);
 void ieee80211_sta_ps_deliver_poll_response(struct sta_info *sta);
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 368837f..1ced74c 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -191,29 +191,36 @@ static void ieee80211_frame_acked(struct sta_info *sta, struct sk_buff *skb)
 	if (ieee80211_is_action(mgmt->frame_control) &&
 	    mgmt->u.action.category == WLAN_CATEGORY_HT &&
 	    mgmt->u.action.u.ht_smps.action == WLAN_HT_ACTION_SMPS &&
-	    sdata->vif.type == NL80211_IFTYPE_STATION &&
 	    ieee80211_sdata_running(sdata)) {
-		/*
-		 * This update looks racy, but isn't -- if we come
-		 * here we've definitely got a station that we're
-		 * talking to, and on a managed interface that can
-		 * only be the AP. And the only other place updating
-		 * this variable in managed mode is before association.
-		 */
+		enum ieee80211_smps_mode smps_mode;
+
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
+			/*
+			 * This update looks racy, but isn't -- if we come
+			 * here we've definitely got a station that we're
+			 * talking to, and on a managed interface that can
+			 * only be the AP. And the only other place updating
+			 * this variable in managed mode is before association.
+			 */
+			sdata->smps_mode = smps_mode;
+			ieee80211_queue_work(&local->hw, &sdata->recalc_smps);
+		} else if (sdata->vif.type == NL80211_IFTYPE_AP ||
+			   sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
+			sta->known_smps_mode = smps_mode;
+		}
 	}
 }
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 75a1685..47aca3b 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2292,3 +2292,28 @@ void ieee80211_radar_detected(struct ieee80211_hw *hw)
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

