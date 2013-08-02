Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:39958 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab3HBPiV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Aug 2013 11:38:21 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH 5/7] mac80211: add support for CSA in IBSS mode
Date: Fri,  2 Aug 2013 17:38:04 +0200
Message-Id: <1375457886-7275-6-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130802_173829_590667_14148B69)
In-Reply-To: <1375457886-7275-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1375457886-7275-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ths function adds the channel switch announcement implementation for the
IBSS code. It is triggered by userspace (mac80211/cfg) or by external
channel switch announcement, which have to be adopted. Both CSAs in
beacons and action frames are supported. As for AP mode, the channel
switch is applied after some time. However in IBSS mode, the channel
switch IEs are generated in the kernel.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 net/mac80211/cfg.c         |   84 +++++---
 net/mac80211/ibss.c        |  475 ++++++++++++++++++++++++++++++++++++++------
 net/mac80211/ieee80211_i.h |    2 +
 net/mac80211/iface.c       |    4 +
 net/mac80211/rx.c          |   36 +++-
 net/mac80211/tx.c          |   34 +++-
 6 files changed, 537 insertions(+), 98 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 44449ce..e603450 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2852,30 +2852,35 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
 	if (!ieee80211_sdata_running(sdata))
 		return;
 
-	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_AP))
-		return;
-
 	sdata->radar_required = sdata->csa_radar_required;
 	err = ieee80211_vif_change_channel(sdata, &local->csa_chandef,
 					   &changed);
 	if (WARN_ON(err < 0))
 		return;
 
-	err = ieee80211_assign_beacon(sdata, sdata->u.ap.next_beacon);
-	if (err < 0)
+	ieee80211_bss_info_change_notify(sdata, changed);
+
+	if (sdata->vif.type == NL80211_IFTYPE_AP) {
+		err = ieee80211_assign_beacon(sdata, sdata->u.ap.next_beacon);
+		if (err < 0)
+			return;
+		changed |= err;
+		kfree(sdata->u.ap.next_beacon);
+		sdata->u.ap.next_beacon = NULL;
+
+		ieee80211_bss_info_change_notify(sdata, err);
+	} else if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
+		ieee80211_ibss_finish_csa(sdata);
+	} else {
+		WARN_ON(1);
 		return;
-
-	changed |= err;
-	kfree(sdata->u.ap.next_beacon);
-	sdata->u.ap.next_beacon = NULL;
+	}
 	sdata->vif.csa_active = false;
 
 	ieee80211_wake_queues_by_reason(&sdata->local->hw,
 					IEEE80211_MAX_QUEUE_MAP,
 					IEEE80211_QUEUE_STOP_REASON_CSA);
 
-	ieee80211_bss_info_change_notify(sdata, changed);
-
 	cfg80211_ch_switch_notify(sdata->dev, &local->csa_chandef);
 }
 
@@ -2923,20 +2928,56 @@ static int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	if (sdata->vif.csa_active)
 		return -EBUSY;
 
-	/* only handle AP for now. */
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP:
+		sdata->csa_counter_offset_beacon =
+			params->counter_offset_beacon;
+		sdata->csa_counter_offset_presp = params->counter_offset_presp;
+		sdata->u.ap.next_beacon =
+			cfg80211_beacon_dup(&params->beacon_after);
+		if (!sdata->u.ap.next_beacon)
+			return -ENOMEM;
+
+		err = ieee80211_assign_beacon(sdata, &params->beacon_csa);
+		if (err < 0) {
+			kfree(sdata->u.ap.next_beacon);
+			return err;
+		}
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		if (!sdata->vif.bss_conf.ibss_joined)
+			return -EINVAL;
+
+		if (params->chandef.width != sdata->u.ibss.chandef.width)
+			return -EINVAL;
+
+		switch (params->chandef.width) {
+		case NL80211_CHAN_WIDTH_40:
+			if (cfg80211_get_chandef_type(&params->chandef) !=
+			    cfg80211_get_chandef_type(&sdata->u.ibss.chandef))
+				return -EINVAL;
+		case NL80211_CHAN_WIDTH_5:
+		case NL80211_CHAN_WIDTH_10:
+		case NL80211_CHAN_WIDTH_20_NOHT:
+		case NL80211_CHAN_WIDTH_20:
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		/* changes into another band are not supported */
+		if (sdata->u.ibss.chandef.chan->band !=
+		    params->chandef.chan->band)
+			return -EINVAL;
+
+		err = ieee80211_ibss_csa_beacon(sdata, params);
+		if (err < 0)
+			return err;
 		break;
 	default:
 		return -EOPNOTSUPP;
 	}
 
-	sdata->u.ap.next_beacon = cfg80211_beacon_dup(&params->beacon_after);
-	if (!sdata->u.ap.next_beacon)
-		return -ENOMEM;
-
-	sdata->csa_counter_offset_beacon = params->counter_offset_beacon;
-	sdata->csa_counter_offset_presp = params->counter_offset_presp;
 	sdata->csa_radar_required = params->radar_required;
 
 	if (params->block_tx)
@@ -2944,10 +2985,6 @@ static int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 				IEEE80211_MAX_QUEUE_MAP,
 				IEEE80211_QUEUE_STOP_REASON_CSA);
 
-	err = ieee80211_assign_beacon(sdata, &params->beacon_csa);
-	if (err < 0)
-		return err;
-
 	local->csa_chandef = params->chandef;
 	sdata->vif.csa_active = true;
 
@@ -3001,7 +3038,8 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			need_offchan = true;
 		if (!ieee80211_is_action(mgmt->frame_control) ||
 		    mgmt->u.action.category == WLAN_CATEGORY_PUBLIC ||
-		    mgmt->u.action.category == WLAN_CATEGORY_SELF_PROTECTED)
+		    mgmt->u.action.category == WLAN_CATEGORY_SELF_PROTECTED ||
+		    mgmt->u.action.category == WLAN_CATEGORY_SPECTRUM_MGMT)
 			break;
 		rcu_read_lock();
 		sta = sta_info_get(sdata, mgmt->da);
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 29f1a7b..4a10e00 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -34,12 +34,15 @@
 
 #define IEEE80211_IBSS_MAX_STA_ENTRIES 128
 
+static int ieee80211_sta_active_ibss(struct ieee80211_sub_if_data *sdata);
+
 static struct beacon_data *
 ieee80211_ibss_build_presp(struct ieee80211_sub_if_data *sdata,
 			   const int beacon_int, const u32 basic_rates,
 			   const u16 capability, u64 tsf,
 			   struct cfg80211_chan_def *chandef,
-			   bool *have_higher_than_11mbit)
+			   bool *have_higher_than_11mbit,
+			   struct cfg80211_csa_settings *csa_settings)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct ieee80211_local *local = sdata->local;
@@ -59,6 +62,7 @@ ieee80211_ibss_build_presp(struct ieee80211_sub_if_data *sdata,
 		    2 + 8 /* max Supported Rates */ +
 		    3 /* max DS params */ +
 		    4 /* IBSS params */ +
+		    5 /* Channel Switch Announcement */ +
 		    2 + (IEEE80211_MAX_SUPP_RATES - 8) +
 		    2 + sizeof(struct ieee80211_ht_cap) +
 		    2 + sizeof(struct ieee80211_ht_operation) +
@@ -135,6 +139,16 @@ ieee80211_ibss_build_presp(struct ieee80211_sub_if_data *sdata,
 	*pos++ = 0;
 	*pos++ = 0;
 
+	if (csa_settings) {
+		*pos++ = WLAN_EID_CHANNEL_SWITCH;
+		*pos++ = 3;
+		*pos++ = csa_settings->block_tx ? 1 : 0;
+		*pos++ = ieee80211_frequency_to_channel(
+				csa_settings->chandef.chan->center_freq);
+		sdata->csa_counter_offset_beacon = (pos - presp->head);
+		*pos++ = csa_settings->count;
+	}
+
 	/* put the remaining rates in WLAN_EID_EXT_SUPP_RATES */
 	if (rates_n > 8) {
 		*pos++ = WLAN_EID_EXT_SUPP_RATES;
@@ -273,7 +287,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 
 	presp = ieee80211_ibss_build_presp(sdata, beacon_int, basic_rates,
 					   capability, tsf, &chandef,
-					   &have_higher_than_11mbit);
+					   &have_higher_than_11mbit, NULL);
 	if (!presp)
 		return;
 
@@ -391,6 +405,110 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 				  tsf, false);
 }
 
+/* must hold sdata lock */
+int ieee80211_ibss_csa_beacon(struct ieee80211_sub_if_data *sdata,
+			      struct cfg80211_csa_settings *csa_settings)
+{
+	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+	struct beacon_data *presp, *old_presp;
+	struct cfg80211_bss *cbss;
+	const struct cfg80211_bss_ies *ies;
+	u16 capability;
+	u64 tsf;
+	int ret = 0;
+
+	sdata_assert_lock(sdata);
+
+	capability = WLAN_CAPABILITY_IBSS;
+
+	if (ifibss->privacy)
+		capability |= WLAN_CAPABILITY_PRIVACY;
+
+	cbss = cfg80211_get_bss(sdata->local->hw.wiphy, ifibss->chandef.chan,
+				ifibss->bssid, ifibss->ssid,
+				ifibss->ssid_len, WLAN_CAPABILITY_IBSS |
+				WLAN_CAPABILITY_PRIVACY,
+				capability);
+
+	if (WARN_ON(!cbss)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	rcu_read_lock();
+	ies = rcu_dereference(cbss->ies);
+	tsf = ies->tsf;
+	rcu_read_unlock();
+	cfg80211_put_bss(sdata->local->hw.wiphy, cbss);
+
+	old_presp = rcu_dereference_protected(ifibss->presp,
+					  lockdep_is_held(&sdata->wdev.mtx));
+
+	presp = ieee80211_ibss_build_presp(sdata,
+					   sdata->vif.bss_conf.beacon_int,
+					   sdata->vif.bss_conf.basic_rates,
+					   capability, tsf, &ifibss->chandef,
+					   NULL, csa_settings);
+	if (!presp) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	rcu_assign_pointer(ifibss->presp, presp);
+	if (old_presp)
+		kfree_rcu(old_presp, rcu_head);
+
+	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
+ out:
+	return ret;
+}
+
+int ieee80211_ibss_finish_csa(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+	struct cfg80211_bss *cbss;
+	int err;
+	u16 capability;
+
+	sdata_lock(sdata);
+	/* update cfg80211 bss information with the new channel */
+	if (!is_zero_ether_addr(ifibss->bssid)) {
+		capability = WLAN_CAPABILITY_IBSS;
+
+		if (ifibss->privacy)
+			capability |= WLAN_CAPABILITY_PRIVACY;
+
+		cbss = cfg80211_get_bss(sdata->local->hw.wiphy,
+					ifibss->chandef.chan,
+					ifibss->bssid, ifibss->ssid,
+					ifibss->ssid_len, WLAN_CAPABILITY_IBSS |
+					WLAN_CAPABILITY_PRIVACY,
+					capability);
+		/* XXX: should not really modify cfg80211 data */
+		if (cbss) {
+			cbss->channel = sdata->local->csa_chandef.chan;
+			cfg80211_put_bss(sdata->local->hw.wiphy, cbss);
+		}
+	}
+
+	ifibss->chandef = sdata->local->csa_chandef;
+
+	/* generate the beacon */
+	err = ieee80211_ibss_csa_beacon(sdata, NULL);
+	sdata_unlock(sdata);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
+void ieee80211_ibss_stop(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+
+	cancel_work_sync(&ifibss->csa_connection_drop_work);
+}
+
 static struct sta_info *ieee80211_ibss_finish_sta(struct sta_info *sta)
 	__acquires(RCU)
 {
@@ -474,6 +592,265 @@ ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata, const u8 *bssid,
 	return ieee80211_ibss_finish_sta(sta);
 }
 
+static void ieee80211_ibss_disconnect(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+	struct ieee80211_local *local = sdata->local;
+	struct cfg80211_bss *cbss;
+	struct beacon_data *presp;
+	struct sta_info *sta;
+	int active_ibss;
+	u16 capability;
+
+	active_ibss = ieee80211_sta_active_ibss(sdata);
+
+	if (!active_ibss && !is_zero_ether_addr(ifibss->bssid)) {
+		capability = WLAN_CAPABILITY_IBSS;
+
+		if (ifibss->privacy)
+			capability |= WLAN_CAPABILITY_PRIVACY;
+
+		cbss = cfg80211_get_bss(local->hw.wiphy, ifibss->chandef.chan,
+					ifibss->bssid, ifibss->ssid,
+					ifibss->ssid_len, WLAN_CAPABILITY_IBSS |
+					WLAN_CAPABILITY_PRIVACY,
+					capability);
+
+		if (cbss) {
+			cfg80211_unlink_bss(local->hw.wiphy, cbss);
+			cfg80211_put_bss(sdata->local->hw.wiphy, cbss);
+		}
+	}
+
+	ifibss->state = IEEE80211_IBSS_MLME_SEARCH;
+
+	sta_info_flush(sdata);
+
+	spin_lock_bh(&ifibss->incomplete_lock);
+	while (!list_empty(&ifibss->incomplete_stations)) {
+		sta = list_first_entry(&ifibss->incomplete_stations,
+				       struct sta_info, list);
+		list_del(&sta->list);
+		spin_unlock_bh(&ifibss->incomplete_lock);
+
+		sta_info_free(local, sta);
+		spin_lock_bh(&ifibss->incomplete_lock);
+	}
+	spin_unlock_bh(&ifibss->incomplete_lock);
+
+	netif_carrier_off(sdata->dev);
+
+	sdata->vif.bss_conf.ibss_joined = false;
+	sdata->vif.bss_conf.ibss_creator = false;
+	sdata->vif.bss_conf.enable_beacon = false;
+	sdata->vif.bss_conf.ssid_len = 0;
+
+	/* remove beacon */
+	presp = rcu_dereference_protected(ifibss->presp,
+					  lockdep_is_held(&sdata->wdev.mtx));
+	RCU_INIT_POINTER(sdata->u.ibss.presp, NULL);
+	if (presp)
+		kfree_rcu(presp, rcu_head);
+
+	clear_bit(SDATA_STATE_OFFCHANNEL_BEACON_STOPPED, &sdata->state);
+	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED |
+						BSS_CHANGED_IBSS);
+}
+
+static void ieee80211_csa_connection_drop_work(struct work_struct *work)
+{
+	struct ieee80211_sub_if_data *sdata =
+		container_of(work, struct ieee80211_sub_if_data,
+			     u.ibss.csa_connection_drop_work);
+
+	ieee80211_ibss_disconnect(sdata);
+	synchronize_rcu();
+	skb_queue_purge(&sdata->skb_queue);
+
+	/* trigger a scan to find another IBSS network to join */
+	ieee80211_queue_work(&sdata->local->hw, &sdata->work);
+}
+
+static bool
+ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
+				  struct ieee802_11_elems *elems,
+				  bool beacon)
+{
+	struct cfg80211_csa_settings params;
+	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	struct ieee80211_chanctx *chanctx;
+	enum nl80211_channel_type ch_type;
+	int err, num_chanctx;
+	u32 sta_flags;
+	u8 mode;
+
+	if (sdata->vif.csa_active)
+		return true;
+
+	if (!sdata->vif.bss_conf.ibss_joined)
+		return false;
+
+	sta_flags = IEEE80211_STA_DISABLE_VHT;
+	switch (ifibss->chandef.width) {
+	case NL80211_CHAN_WIDTH_5:
+	case NL80211_CHAN_WIDTH_10:
+	case NL80211_CHAN_WIDTH_20_NOHT:
+		sta_flags |= IEEE80211_STA_DISABLE_HT;
+		/* fall through */
+	case NL80211_CHAN_WIDTH_20:
+		sta_flags |= IEEE80211_STA_DISABLE_40MHZ;
+		break;
+	default:
+		break;
+	}
+
+	memset(&params, 0, sizeof(params));
+	err = ieee80211_parse_ch_switch_ie(sdata, elems, beacon,
+					   ifibss->chandef.chan->band,
+					   sta_flags, &params.count,
+					   &mode, &params.chandef);
+
+	/* can't switch to destination channel, fail */
+	if (err < 0)
+		goto disconnect;
+
+	/* did not contain a CSA */
+	if (err)
+		return false;
+
+	if (ifibss->chandef.chan->band != params.chandef.chan->band)
+		goto disconnect;
+
+	switch (ifibss->chandef.width) {
+	case NL80211_CHAN_WIDTH_20_NOHT:
+	case NL80211_CHAN_WIDTH_20:
+	case NL80211_CHAN_WIDTH_40:
+		/* keep our current HT mode (HT20/HT40+/HT40-), even if
+		 * another mode  has been announced. The mode is not adopted
+		 * within the beacon while doing CSA and we should therefore
+		 * keep the mode which we announce.
+		 */
+		ch_type = cfg80211_get_chandef_type(&ifibss->chandef);
+		cfg80211_chandef_create(&params.chandef, params.chandef.chan,
+					ch_type);
+		break;
+	case NL80211_CHAN_WIDTH_5:
+	case NL80211_CHAN_WIDTH_10:
+		if (WARN_ON(params.chandef.width != ifibss->chandef.width))
+			sdata_info(sdata,
+				   "received channel switch from incompatible channel width (%d MHz, width:%d, CF1/2: %d/%d MHz), disconnecting\n",
+				   params.chandef.chan->center_freq,
+				   params.chandef.width,
+				   params.chandef.center_freq1,
+				   params.chandef.center_freq2);
+			goto disconnect;
+		break;
+	default:
+		/* should not happen, sta_flags should prevent VHT modes. */
+		WARN_ON(1);
+		goto disconnect;
+	}
+
+	if (!cfg80211_chandef_usable(sdata->local->hw.wiphy, &params.chandef,
+				     IEEE80211_CHAN_DISABLED)) {
+		sdata_info(sdata,
+			   "network switches to unsupported channel (%d MHz, width:%d, CF1/2: %d/%d MHz), disconnecting\n",
+			   params.chandef.chan->center_freq,
+			   params.chandef.width,
+			   params.chandef.center_freq1,
+			   params.chandef.center_freq2);
+		goto disconnect;
+	}
+
+	err = cfg80211_chandef_dfs_required(sdata->local->hw.wiphy,
+					    &params.chandef);
+	if (err < 0)
+		goto disconnect;
+	if (err) {
+		params.radar_required = true;
+
+		/* TODO: IBSS-DFS not (yet) supported, disconnect. */
+		goto disconnect;
+	}
+
+	rcu_read_lock();
+	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+	if (!chanctx_conf) {
+		rcu_read_unlock();
+		goto disconnect;
+	}
+
+	/* don't handle for multi-VIF cases */
+	chanctx = container_of(chanctx_conf, struct ieee80211_chanctx, conf);
+	if (chanctx->refcount > 1) {
+		rcu_read_unlock();
+		goto disconnect;
+	}
+	num_chanctx = 0;
+	list_for_each_entry_rcu(chanctx, &sdata->local->chanctx_list, list)
+		num_chanctx++;
+
+	if (num_chanctx > 1) {
+		rcu_read_unlock();
+		goto disconnect;
+	}
+	rcu_read_unlock();
+
+	/* all checks done, now perform the channel switch. */
+	ibss_dbg(sdata,
+		 "received channel switch announcement to go to channel %d MHz\n",
+		 params.chandef.chan->center_freq);
+
+	params.block_tx = !!mode;
+
+	ieee80211_ibss_csa_beacon(sdata, &params);
+	sdata->csa_radar_required = params.radar_required;
+
+	if (params.block_tx)
+		ieee80211_stop_queues_by_reason(&sdata->local->hw,
+				IEEE80211_MAX_QUEUE_MAP,
+				IEEE80211_QUEUE_STOP_REASON_CSA);
+
+	sdata->local->csa_chandef = params.chandef;
+	sdata->vif.csa_active = true;
+
+	ieee80211_bss_info_change_notify(sdata, err);
+	drv_channel_switch_beacon(sdata, &params.chandef);
+
+	return true;
+disconnect:
+	ibss_dbg(sdata, "Can't handle channel switch, disconnect\n");
+	ieee80211_queue_work(&sdata->local->hw,
+			     &ifibss->csa_connection_drop_work);
+
+	return true;
+}
+
+static void
+ieee80211_rx_mgmt_spectrum_mgmt(struct ieee80211_sub_if_data *sdata,
+				struct ieee80211_mgmt *mgmt, size_t len,
+				struct ieee80211_rx_status *rx_status,
+				struct ieee802_11_elems *elems)
+{
+	int required_len;
+
+	if (len < IEEE80211_MIN_ACTION_SIZE + 1)
+		return;
+
+	/* CSA is the only action we handle for now */
+	if (mgmt->u.action.u.measurement.action_code !=
+	    WLAN_ACTION_SPCT_CHL_SWITCH)
+		return;
+
+	required_len = IEEE80211_MIN_ACTION_SIZE +
+		       sizeof(mgmt->u.action.u.chan_switch);
+	if (len < required_len)
+		return;
+
+	ieee80211_ibss_process_chanswitch(sdata, elems, false);
+}
+
 static void ieee80211_rx_mgmt_deauth_ibss(struct ieee80211_sub_if_data *sdata,
 					  struct ieee80211_mgmt *mgmt,
 					  size_t len)
@@ -636,10 +1013,6 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 
 	/* check if we need to merge IBSS */
 
-	/* we use a fixed BSSID */
-	if (sdata->u.ibss.fixed_bssid)
-		goto put_bss;
-
 	/* not an IBSS */
 	if (!(cbss->capability & WLAN_CAPABILITY_IBSS))
 		goto put_bss;
@@ -655,10 +1028,18 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 				sdata->u.ibss.ssid_len))
 		goto put_bss;
 
+	/* process channel switch */
+	if (ieee80211_ibss_process_chanswitch(sdata, elems, true))
+		goto put_bss;
+
 	/* same BSSID */
 	if (ether_addr_equal(cbss->bssid, sdata->u.ibss.bssid))
 		goto put_bss;
 
+	/* we use a fixed BSSID */
+	if (sdata->u.ibss.fixed_bssid)
+		goto put_bss;
+
 	if (ieee80211_have_rx_timestamp(rx_status)) {
 		/* time when timestamp field was received */
 		rx_timestamp =
@@ -1040,6 +1421,8 @@ void ieee80211_ibss_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_rx_status *rx_status;
 	struct ieee80211_mgmt *mgmt;
 	u16 fc;
+	struct ieee802_11_elems elems;
+	int ies_len;
 
 	rx_status = IEEE80211_SKB_RXCB(skb);
 	mgmt = (struct ieee80211_mgmt *) skb->data;
@@ -1065,6 +1448,27 @@ void ieee80211_ibss_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 	case IEEE80211_STYPE_DEAUTH:
 		ieee80211_rx_mgmt_deauth_ibss(sdata, mgmt, skb->len);
 		break;
+	case IEEE80211_STYPE_ACTION:
+		switch (mgmt->u.action.category) {
+		case WLAN_CATEGORY_SPECTRUM_MGMT:
+			ies_len = skb->len -
+				  offsetof(struct ieee80211_mgmt,
+					   u.action.u.chan_switch.variable);
+
+			if (ies_len < 0)
+				break;
+
+			ieee802_11_parse_elems(
+				mgmt->u.action.u.chan_switch.variable,
+				ies_len, true, &elems);
+
+			if (elems.parse_error)
+				break;
+
+			ieee80211_rx_mgmt_spectrum_mgmt(sdata, mgmt, skb->len,
+							rx_status, &elems);
+			break;
+		}
 	}
 
  mgmt_out:
@@ -1131,6 +1535,8 @@ void ieee80211_ibss_setup_sdata(struct ieee80211_sub_if_data *sdata)
 		    (unsigned long) sdata);
 	INIT_LIST_HEAD(&ifibss->incomplete_stations);
 	spin_lock_init(&ifibss->incomplete_lock);
+	INIT_WORK(&ifibss->csa_connection_drop_work,
+		  ieee80211_csa_connection_drop_work);
 }
 
 /* scan finished notification */
@@ -1229,72 +1635,19 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
-	struct ieee80211_local *local = sdata->local;
-	struct cfg80211_bss *cbss;
-	u16 capability;
-	int active_ibss;
-	struct sta_info *sta;
-	struct beacon_data *presp;
 
-	active_ibss = ieee80211_sta_active_ibss(sdata);
+	ieee80211_ibss_disconnect(sdata);
 
-	if (!active_ibss && !is_zero_ether_addr(ifibss->bssid)) {
-		capability = WLAN_CAPABILITY_IBSS;
-
-		if (ifibss->privacy)
-			capability |= WLAN_CAPABILITY_PRIVACY;
-
-		cbss = cfg80211_get_bss(local->hw.wiphy, ifibss->chandef.chan,
-					ifibss->bssid, ifibss->ssid,
-					ifibss->ssid_len, WLAN_CAPABILITY_IBSS |
-					WLAN_CAPABILITY_PRIVACY,
-					capability);
-
-		if (cbss) {
-			cfg80211_unlink_bss(local->hw.wiphy, cbss);
-			cfg80211_put_bss(local->hw.wiphy, cbss);
-		}
-	}
-
-	ifibss->state = IEEE80211_IBSS_MLME_SEARCH;
-	memset(ifibss->bssid, 0, ETH_ALEN);
 	ifibss->ssid_len = 0;
-
-	sta_info_flush(sdata);
-
-	spin_lock_bh(&ifibss->incomplete_lock);
-	while (!list_empty(&ifibss->incomplete_stations)) {
-		sta = list_first_entry(&ifibss->incomplete_stations,
-				       struct sta_info, list);
-		list_del(&sta->list);
-		spin_unlock_bh(&ifibss->incomplete_lock);
-
-		sta_info_free(local, sta);
-		spin_lock_bh(&ifibss->incomplete_lock);
-	}
-	spin_unlock_bh(&ifibss->incomplete_lock);
-
-	netif_carrier_off(sdata->dev);
-
+	memset(ifibss->bssid, 0, ETH_ALEN);
 	/* remove beacon */
 	kfree(sdata->u.ibss.ie);
-	presp = rcu_dereference_protected(ifibss->presp,
-					  lockdep_is_held(&sdata->wdev.mtx));
-	RCU_INIT_POINTER(sdata->u.ibss.presp, NULL);
 
 	/* on the next join, re-program HT parameters */
 	memset(&ifibss->ht_capa, 0, sizeof(ifibss->ht_capa));
 	memset(&ifibss->ht_capa_mask, 0, sizeof(ifibss->ht_capa_mask));
 
-	sdata->vif.bss_conf.ibss_joined = false;
-	sdata->vif.bss_conf.ibss_creator = false;
-	sdata->vif.bss_conf.enable_beacon = false;
-	sdata->vif.bss_conf.ssid_len = 0;
-	clear_bit(SDATA_STATE_OFFCHANNEL_BEACON_STOPPED, &sdata->state);
-	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED |
-						BSS_CHANGED_IBSS);
 	synchronize_rcu();
-	kfree(presp);
 
 	skb_queue_purge(&sdata->skb_queue);
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 1275bde..dbbd124 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -490,6 +490,7 @@ struct ieee80211_if_managed {
 
 struct ieee80211_if_ibss {
 	struct timer_list timer;
+	struct work_struct csa_connection_drop_work;
 
 	unsigned long last_scan_completed;
 
@@ -1336,6 +1337,7 @@ void ieee80211_ibss_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 int ieee80211_ibss_csa_beacon(struct ieee80211_sub_if_data *sdata,
 			      struct cfg80211_csa_settings *csa_settings);
 int ieee80211_ibss_finish_csa(struct ieee80211_sub_if_data *sdata);
+void ieee80211_ibss_stop(struct ieee80211_sub_if_data *sdata);
 
 /* mesh code */
 void ieee80211_mesh_work(struct ieee80211_sub_if_data *sdata);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 7ca534b..a8bce73 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -763,6 +763,10 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		ieee80211_mgd_stop(sdata);
 
+	if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+		ieee80211_ibss_stop(sdata);
+
+
 	/*
 	 * Remove all stations associated with this interface.
 	 *
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 0ac7512..59595d6 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2396,7 +2396,8 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 		return RX_DROP_UNUSABLE;
 
 	if (!rx->sta && mgmt->u.action.category != WLAN_CATEGORY_PUBLIC &&
-	    mgmt->u.action.category != WLAN_CATEGORY_SELF_PROTECTED)
+	    mgmt->u.action.category != WLAN_CATEGORY_SELF_PROTECTED &&
+	    mgmt->u.action.category != WLAN_CATEGORY_SPECTRUM_MGMT)
 		return RX_DROP_UNUSABLE;
 
 	if (!(status->rx_flags & IEEE80211_RX_RA_MATCH))
@@ -2560,31 +2561,46 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 
 		goto queue;
 	case WLAN_CATEGORY_SPECTRUM_MGMT:
-		if (status->band != IEEE80211_BAND_5GHZ)
-			break;
-
-		if (sdata->vif.type != NL80211_IFTYPE_STATION)
-			break;
-
 		/* verify action_code is present */
 		if (len < IEEE80211_MIN_ACTION_SIZE + 1)
 			break;
 
 		switch (mgmt->u.action.u.measurement.action_code) {
 		case WLAN_ACTION_SPCT_MSR_REQ:
+			if (status->band != IEEE80211_BAND_5GHZ)
+				break;
+
 			if (len < (IEEE80211_MIN_ACTION_SIZE +
 				   sizeof(mgmt->u.action.u.measurement)))
 				break;
+
+			if (sdata->vif.type != NL80211_IFTYPE_STATION)
+				break;
+
 			ieee80211_process_measurement_req(sdata, mgmt, len);
 			goto handled;
-		case WLAN_ACTION_SPCT_CHL_SWITCH:
-			if (sdata->vif.type != NL80211_IFTYPE_STATION)
+		case WLAN_ACTION_SPCT_CHL_SWITCH: {
+			u8 *bssid;
+			if (len < (IEEE80211_MIN_ACTION_SIZE +
+				   sizeof(mgmt->u.action.u.chan_switch)))
 				break;
 
-			if (!ether_addr_equal(mgmt->bssid, sdata->u.mgd.bssid))
+			if (sdata->vif.type != NL80211_IFTYPE_STATION &&
+			    sdata->vif.type != NL80211_IFTYPE_ADHOC)
+				break;
+
+			if (sdata->vif.type == NL80211_IFTYPE_STATION)
+				bssid = sdata->u.mgd.bssid;
+			else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+				bssid = sdata->u.ibss.bssid;
+			else
+				break;
+
+			if (!ether_addr_equal(mgmt->bssid, bssid))
 				break;
 
 			goto queue;
+			}
 		}
 		break;
 	case WLAN_CATEGORY_SA_QUERY:
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0e42322..ab5e151 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2353,15 +2353,28 @@ static void ieee80211_update_csa(struct ieee80211_sub_if_data *sdata,
 	struct probe_resp *resp;
 	int counter_offset_beacon = sdata->csa_counter_offset_beacon;
 	int counter_offset_presp = sdata->csa_counter_offset_presp;
+	u8 *beacon_data;
+	size_t beacon_data_len;
+
+	if (sdata->vif.type == NL80211_IFTYPE_AP) {
+		beacon_data = beacon->tail;
+		beacon_data_len = beacon->tail_len;
+	} else if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
+		beacon_data = beacon->head;
+		beacon_data_len = beacon->head_len;
+	} else {
+		return;
+	}
+	if (WARN_ON(counter_offset_beacon >= beacon_data_len))
+		return;
 
 	/* warn if the driver did not check for/react to csa completeness */
-	if (WARN_ON(((u8 *)beacon->tail)[counter_offset_beacon] == 0))
+	if (WARN_ON(beacon_data[counter_offset_beacon] == 0))
 		return;
 
-	((u8 *)beacon->tail)[counter_offset_beacon]--;
+	beacon_data[counter_offset_beacon]--;
 
-	if (sdata->vif.type == NL80211_IFTYPE_AP &&
-	    counter_offset_presp) {
+	if (sdata->vif.type == NL80211_IFTYPE_AP && counter_offset_presp) {
 		rcu_read_lock();
 		resp = rcu_dereference(sdata->u.ap.probe_resp);
 
@@ -2396,6 +2409,15 @@ bool ieee80211_csa_is_complete(struct ieee80211_vif *vif)
 			goto out;
 		beacon_data = beacon->tail;
 		beacon_data_len = beacon->tail_len;
+	} else if (vif->type == NL80211_IFTYPE_ADHOC) {
+		struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+
+		beacon = rcu_dereference(ifibss->presp);
+		if (!beacon)
+			goto out;
+
+		beacon_data = beacon->head;
+		beacon_data_len = beacon->head_len;
 	} else {
 		WARN_ON(1);
 		goto out;
@@ -2480,6 +2502,10 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 		if (!presp)
 			goto out;
 
+		if (sdata->vif.csa_active)
+			ieee80211_update_csa(sdata, presp);
+
+
 		skb = dev_alloc_skb(local->tx_headroom + presp->head_len);
 		if (!skb)
 			goto out;
-- 
1.7.10.4

