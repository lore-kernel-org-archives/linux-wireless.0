Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:40419 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab3LPWBJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 17:01:09 -0500
Received: by mail-ob0-f182.google.com with SMTP id wp4so5552874obc.27
        for <linux-wireless@vger.kernel.org>; Mon, 16 Dec 2013 14:01:09 -0800 (PST)
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	brcm80211-dev-list@broadcom.com,
	"John W. Linville" <linville@tuxdriver.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Arend van Spriel <arend@broadcom.com>,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [RFC PATCH 4/8] mac80211: Use PS module for managed mode powersave
Date: Mon, 16 Dec 2013 16:00:56 -0600
Message-Id: <1387231260-2849-5-git-send-email-seth.forshee@canonical.com> (sfid-20131216_230116_798151_421324D4)
In-Reply-To: <1387231260-2849-1-git-send-email-seth.forshee@canonical.com>
References: <1387231260-2849-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Convert the managed mode code to manipulate interface PS states
rather than changing the hw PS state directly. The off-channel
and scan code must be updated at the same time in order to avoid
conflicts with the PS module.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 net/mac80211/cfg.c         |   9 +--
 net/mac80211/ieee80211_i.h |  10 +--
 net/mac80211/iface.c       |   8 ++-
 net/mac80211/mlme.c        | 173 +++++++++++++++++----------------------------
 net/mac80211/offchannel.c  |  57 +++++----------
 net/mac80211/scan.c        |  14 ++++
 net/mac80211/status.c      |  13 ++--
 net/mac80211/tx.c          |  12 ++--
 net/mac80211/util.c        |  47 +++++++++---
 9 files changed, 159 insertions(+), 184 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index f80e8c4..40040ad 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -552,7 +552,7 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 		sinfo->bss_param.flags |= BSS_PARAM_FLAGS_SHORT_PREAMBLE;
 	if (sdata->vif.bss_conf.use_short_slot)
 		sinfo->bss_param.flags |= BSS_PARAM_FLAGS_SHORT_SLOT_TIME;
-	sinfo->bss_param.dtim_period = sdata->local->hw.conf.ps_dtim_period;
+	sinfo->bss_param.dtim_period = sdata->vif.ps_dtim_period;
 	sinfo->bss_param.beacon_interval = sdata->vif.bss_conf.beacon_int;
 
 	sinfo->sta_flags.set = 0;
@@ -1596,7 +1596,7 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 
 	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
 	    params->sta_flags_mask & BIT(NL80211_STA_FLAG_AUTHORIZED)) {
-		ieee80211_recalc_ps(local, -1);
+		ieee80211_recalc_ps(sdata);
 		ieee80211_recalc_ps_vif(sdata);
 	}
 
@@ -2532,10 +2532,7 @@ static int ieee80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	__ieee80211_request_smps_mgd(sdata, sdata->u.mgd.req_smps);
 	sdata_unlock(sdata);
 
-	if (local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS)
-		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
-
-	ieee80211_recalc_ps(local, -1);
+	ieee80211_recalc_ps(sdata);
 	ieee80211_recalc_ps_vif(sdata);
 
 	return 0;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a489676..4b0750f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -394,6 +394,7 @@ struct ieee80211_if_managed {
 	struct work_struct csa_connection_drop_work;
 	struct work_struct dynamic_ps_enable_work;
 	struct work_struct dynamic_ps_disable_work;
+	enum ieee80211_vif_ps_mode offchannel_ps_mode;
 
 	unsigned long beacon_timeout;
 	unsigned long probe_timeout;
@@ -1186,12 +1187,6 @@ struct ieee80211_local {
 				*/
 
 	bool pspolling;
-	bool offchannel_ps_enabled;
-	/*
-	 * PS can only be enabled when we have exactly one managed
-	 * interface (and monitors) in PS, this then points there.
-	 */
-	struct ieee80211_sub_if_data *ps_sdata;
 	struct notifier_block network_latency_notifier;
 	struct notifier_block ifa_notifier;
 	struct notifier_block ifa6_notifier;
@@ -1362,7 +1357,8 @@ int ieee80211_mgd_disassoc(struct ieee80211_sub_if_data *sdata,
 			   struct cfg80211_disassoc_request *req);
 void ieee80211_send_pspoll(struct ieee80211_local *local,
 			   struct ieee80211_sub_if_data *sdata);
-void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency);
+void ieee80211_recalc_ps(struct ieee80211_sub_if_data *sdata);
+void ieee80211_mgd_recalc_ps(struct ieee80211_sub_if_data *sdata);
 void ieee80211_recalc_ps_vif(struct ieee80211_sub_if_data *sdata);
 void ieee80211_mgd_notify_rx(struct ieee80211_rx_data *rx);
 int ieee80211_max_network_latency(struct notifier_block *nb,
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 784b651..6444a50 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -682,7 +682,7 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 	if (hw_reconf_flags)
 		ieee80211_hw_config(local, hw_reconf_flags);
 
-	ieee80211_recalc_ps(local, -1);
+	ieee80211_ps_vif_open(sdata);
 
 	if (sdata->vif.type == NL80211_IFTYPE_MONITOR ||
 	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
@@ -943,6 +943,8 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		return;
 	}
 
+	ieee80211_ps_vif_close(sdata);
+
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP_VLAN:
 		break;
@@ -963,8 +965,6 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 			drv_remove_interface(local, sdata);
 	}
 
-	ieee80211_recalc_ps(local, -1);
-
 	if (local->open_count == 0) {
 		ieee80211_stop_device(local);
 
@@ -1609,6 +1609,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 		strlcpy(sdata->name, name, IFNAMSIZ);
 		ieee80211_assign_perm_addr(local, wdev->address, type);
 		memcpy(sdata->vif.addr, wdev->address, ETH_ALEN);
+		ieee80211_ps_init_vif(sdata);
 	} else {
 		if (local->hw.queues >= IEEE80211_NUM_ACS)
 			txqs = IEEE80211_NUM_ACS;
@@ -1644,6 +1645,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 		ndev->ieee80211_ptr = &sdata->wdev;
 		memcpy(sdata->vif.addr, ndev->dev_addr, ETH_ALEN);
 		memcpy(sdata->name, ndev->name, IFNAMSIZ);
+		ieee80211_ps_init_vif(sdata);
 
 		sdata->dev = ndev;
 	}
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 4ec8c0a..6deb080 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1138,7 +1138,7 @@ static u32 ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
 static void ieee80211_enable_ps(struct ieee80211_local *local,
 				struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_conf *conf = &local->hw.conf;
+	struct ieee80211_vif *vif = &sdata->vif;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	/*
@@ -1148,36 +1148,38 @@ static void ieee80211_enable_ps(struct ieee80211_local *local,
 	if (local->scanning)
 		return;
 
-	if (conf->dynamic_ps_timeout > 0 &&
+	vif->dynamic_ps_active = vif->dynamic_ps_timeout > 0;
+	if (vif->dynamic_ps_active &&
 	    !(local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS)) {
 		mod_timer(&ifmgd->dynamic_ps_timer, jiffies +
-			  msecs_to_jiffies(conf->dynamic_ps_timeout));
+			  msecs_to_jiffies(vif->dynamic_ps_timeout));
 	} else {
-		if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)
+		if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) {
+			ieee80211_vif_set_ps_mode(sdata,
+						  IEEE80211_VIF_PS_AWAKE_PM);
 			ieee80211_send_nullfunc(local, sdata, 1);
+		}
 
 		if ((local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) &&
 		    (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS))
 			return;
 
-		conf->flags |= IEEE80211_CONF_PS;
-		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+		ieee80211_vif_set_ps_mode(sdata, IEEE80211_VIF_PS_DOZE);
 	}
 }
 
 static void ieee80211_change_ps(struct ieee80211_sub_if_data *sdata, bool ps_enable)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_conf *conf = &local->hw.conf;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	if (ps_enable) {
 		ieee80211_enable_ps(local, sdata);
-	} else if (conf->flags & IEEE80211_CONF_PS) {
-		conf->flags &= ~IEEE80211_CONF_PS;
-		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+	} else if (sdata->vif.ps_mode < IEEE80211_VIF_PS_AWAKE) {
 		del_timer_sync(&ifmgd->dynamic_ps_timer);
 		cancel_work_sync(&ifmgd->dynamic_ps_enable_work);
+		sdata->vif.dynamic_ps_active = false;
+		ieee80211_vif_set_ps_mode(sdata, IEEE80211_VIF_PS_AWAKE);
 	}
 }
 
@@ -1212,44 +1214,20 @@ static bool ieee80211_powersave_allowed(struct ieee80211_sub_if_data *sdata)
 }
 
 /* need to hold RTNL or interface lock */
-void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
+void ieee80211_mgd_recalc_ps(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_sub_if_data *sdata, *old_ps_sdata, *found = NULL;
-	int count = 0;
-	int timeout;
-
-	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_PS)) {
-		local->ps_sdata = NULL;
-		return;
-	}
-
-	old_ps_sdata = local->ps_sdata;
-
-	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (!ieee80211_sdata_running(sdata))
-			continue;
-		if (sdata->vif.type == NL80211_IFTYPE_AP) {
-			/* If an AP vif is found, then disable PS
-			 * by setting the count to zero thereby setting
-			 * ps_sdata to NULL.
-			 */
-			count = 0;
-			break;
-		}
-		if (sdata->vif.type != NL80211_IFTYPE_STATION)
-			continue;
-		found = sdata;
-		count++;
-	}
+	struct ieee80211_local *local = sdata->local;
+	bool ps_enable = false;
 
-	if (count == 1 && ieee80211_powersave_allowed(found)) {
+	if (local->hw.flags & IEEE80211_HW_SUPPORTS_PS &&
+	    ieee80211_powersave_allowed(sdata)) {
+		struct ieee80211_vif *vif = &sdata->vif;
+		int latency, timeout;
 		s32 beaconint_us;
 
-		if (latency < 0)
-			latency = pm_qos_request(PM_QOS_NETWORK_LATENCY);
-
+		latency = pm_qos_request(PM_QOS_NETWORK_LATENCY);
 		beaconint_us = ieee80211_tu_to_usec(
-					found->vif.bss_conf.beacon_int);
+					sdata->vif.bss_conf.beacon_int);
 
 		timeout = local->dynamic_ps_forced_timeout;
 		if (timeout < 0) {
@@ -1266,13 +1244,11 @@ void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
 			else
 				timeout = 100;
 		}
-		local->hw.conf.dynamic_ps_timeout = timeout;
+		vif->dynamic_ps_timeout = timeout;
 
-		if (beaconint_us > latency) {
-			local->ps_sdata = NULL;
-		} else {
+		if (latency >= beaconint_us) {
 			int maxslp = 1;
-			u8 dtimper = found->u.mgd.dtim_period;
+			u8 dtimper = sdata->u.mgd.dtim_period;
 
 			/* If the TIM IE is invalid, pretend the value is 1 */
 			if (!dtimper)
@@ -1281,18 +1257,13 @@ void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
 				maxslp = min_t(int, dtimper,
 						    latency / beaconint_us);
 
-			local->hw.conf.max_sleep_period = maxslp;
-			local->hw.conf.ps_dtim_period = dtimper;
-			local->ps_sdata = found;
+			vif->max_sleep_period = maxslp;
+			vif->ps_dtim_period = dtimper;
+			ps_enable = true;
 		}
-	} else {
-		local->ps_sdata = NULL;
 	}
 
-	if (local->ps_sdata)
-		ieee80211_change_ps(local->ps_sdata, true);
-	else if (old_ps_sdata)
-		ieee80211_change_ps(old_ps_sdata, false);
+	ieee80211_change_ps(sdata, ps_enable);
 }
 
 void ieee80211_recalc_ps_vif(struct ieee80211_sub_if_data *sdata)
@@ -1310,14 +1281,11 @@ static void ieee80211_dynamic_ps_disable_work(struct work_struct *work)
 	struct ieee80211_sub_if_data *sdata =
 		container_of(work, struct ieee80211_sub_if_data,
 			     u.mgd.dynamic_ps_disable_work);
-	struct ieee80211_local *local = sdata->local;
 
-	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
-		local->hw.conf.flags &= ~IEEE80211_CONF_PS;
-		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
-	}
+	if (sdata->vif.ps_mode < IEEE80211_VIF_PS_AWAKE)
+		ieee80211_vif_set_ps_mode(sdata, IEEE80211_VIF_PS_AWAKE);
 
-	ieee80211_wake_queues_by_reason(&local->hw,
+	ieee80211_wake_queues_by_reason(&sdata->local->hw,
 					IEEE80211_MAX_QUEUE_MAP,
 					IEEE80211_QUEUE_STOP_REASON_PS);
 }
@@ -1330,21 +1298,23 @@ static void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	unsigned long flags;
-	int q;
+	int q, n_queues;
 
-	/* can only happen when PS was just disabled anyway */
-	if (!local->ps_sdata)
+	if (!sdata->vif.dynamic_ps_active ||
+	    sdata->vif.ps_mode == IEEE80211_VIF_PS_DOZE)
 		return;
 
-	if (local->hw.conf.flags & IEEE80211_CONF_PS)
-		return;
-
-	if (local->hw.conf.dynamic_ps_timeout > 0) {
-		/* don't enter PS if TX frames are pending */
+	if (sdata->vif.dynamic_ps_timeout > 0) {
+		/*
+		 * don't enter PS if TX frames are pending
+		 *
+		 * XXX: Ideally we should be checking only for frames on
+		 * this interface.
+		 */
 		if (drv_tx_frames_pending(local)) {
 			mod_timer(&ifmgd->dynamic_ps_timer, jiffies +
 				  msecs_to_jiffies(
-				  local->hw.conf.dynamic_ps_timeout));
+				  sdata->vif.dynamic_ps_timeout));
 			return;
 		}
 
@@ -1353,14 +1323,18 @@ static void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 		 * dynamic_ps_timer expiry. Postpone the ps timer if it
 		 * is not the actual idle state.
 		 */
+		n_queues = IEEE80211_NUM_ACS;
+		if (local->hw.queues < n_queues)
+			n_queues = 1;
+
 		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
-		for (q = 0; q < local->hw.queues; q++) {
+		for (q = 0; q < n_queues; q++) {
 			if (local->queue_stop_reasons[q]) {
 				spin_unlock_irqrestore(&local->queue_stop_reason_lock,
 						       flags);
 				mod_timer(&ifmgd->dynamic_ps_timer, jiffies +
 					  msecs_to_jiffies(
-					  local->hw.conf.dynamic_ps_timeout));
+					  sdata->vif.dynamic_ps_timeout));
 				return;
 			}
 		}
@@ -1372,8 +1346,10 @@ static void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 		if (drv_tx_frames_pending(local)) {
 			mod_timer(&ifmgd->dynamic_ps_timer, jiffies +
 				  msecs_to_jiffies(
-				  local->hw.conf.dynamic_ps_timeout));
+				  sdata->vif.dynamic_ps_timeout));
 		} else {
+			ieee80211_vif_set_ps_mode(sdata,
+						  IEEE80211_VIF_PS_AWAKE_PM);
 			ieee80211_send_nullfunc(local, sdata, 1);
 			/* Flush to get the tx status of nullfunc frame */
 			ieee80211_flush_queues(local, sdata);
@@ -1384,8 +1360,7 @@ static void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 	      (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)) ||
 	    (ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED)) {
 		ifmgd->flags &= ~IEEE80211_STA_NULLFUNC_ACKED;
-		local->hw.conf.flags |= IEEE80211_CONF_PS;
-		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+		ieee80211_vif_set_ps_mode(sdata, IEEE80211_VIF_PS_DOZE);
 	}
 }
 
@@ -1403,15 +1378,16 @@ static void ieee80211_dynamic_ps_timer(unsigned long data)
 void ieee80211_mgd_notify_rx(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
+	struct ieee80211_vif *vif = &sdata->vif;
 	struct ieee80211_local *local = rx->local;
 
-	if (local->ps_sdata && local->hw.conf.dynamic_ps_timeout > 0 &&
+	if (vif->dynamic_ps_active &&
 	    !is_multicast_ether_addr(
 		    ((struct ethhdr *)rx->skb->data)->h_dest) &&
 	    (!local->scanning &&
 	     !test_bit(SDATA_STATE_OFFCHANNEL, &sdata->state))) {
 			mod_timer(&sdata->u.mgd.dynamic_ps_timer, jiffies +
-			 msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
+				  msecs_to_jiffies(vif->dynamic_ps_timeout));
 	}
 }
 
@@ -1660,7 +1636,7 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 	ieee80211_bss_info_change_notify(sdata, bss_info_changed);
 
 	mutex_lock(&local->iflist_mtx);
-	ieee80211_recalc_ps(local, -1);
+	ieee80211_mgd_recalc_ps(sdata);
 	mutex_unlock(&local->iflist_mtx);
 
 	ieee80211_recalc_smps(sdata);
@@ -1695,11 +1671,8 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	 * to do it before sending disassoc, as otherwise the null-packet
 	 * won't be valid.
 	 */
-	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
-		local->hw.conf.flags &= ~IEEE80211_CONF_PS;
-		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
-	}
-	local->ps_sdata = NULL;
+	sdata->vif.dynamic_ps_active = false;
+	ieee80211_vif_set_ps_mode(sdata, IEEE80211_VIF_PS_AWAKE);
 
 	/* disable per-vif ps */
 	ieee80211_recalc_ps_vif(sdata);
@@ -1804,7 +1777,7 @@ static void ieee80211_reset_ap_probe(struct ieee80211_sub_if_data *sdata)
 	__ieee80211_stop_poll(sdata);
 
 	mutex_lock(&local->iflist_mtx);
-	ieee80211_recalc_ps(local, -1);
+	ieee80211_mgd_recalc_ps(sdata);
 	mutex_unlock(&local->iflist_mtx);
 
 	if (sdata->local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR)
@@ -1946,7 +1919,7 @@ static void ieee80211_mgd_probe_ap(struct ieee80211_sub_if_data *sdata,
 		goto out;
 
 	mutex_lock(&sdata->local->iflist_mtx);
-	ieee80211_recalc_ps(sdata->local, -1);
+	ieee80211_mgd_recalc_ps(sdata);
 	mutex_unlock(&sdata->local->iflist_mtx);
 
 	ifmgd->probe_send_count = 0;
@@ -2921,12 +2894,9 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 							elems.tim_len,
 							ifmgd->aid);
 		if (directed_tim) {
-			if (local->hw.conf.dynamic_ps_timeout > 0) {
-				if (local->hw.conf.flags & IEEE80211_CONF_PS) {
-					local->hw.conf.flags &= ~IEEE80211_CONF_PS;
-					ieee80211_hw_config(local,
-							    IEEE80211_CONF_CHANGE_PS);
-				}
+			if (sdata->vif.dynamic_ps_active) {
+				ieee80211_vif_set_ps_mode(sdata,
+							  IEEE80211_VIF_PS_AWAKE);
 				ieee80211_send_nullfunc(local, sdata, 0);
 			} else if (!local->pspolling && sdata->u.mgd.powersave) {
 				local->pspolling = true;
@@ -3015,7 +2985,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		ifmgd->have_beacon = true;
 
 		mutex_lock(&local->iflist_mtx);
-		ieee80211_recalc_ps(local, -1);
+		ieee80211_mgd_recalc_ps(sdata);
 		mutex_unlock(&local->iflist_mtx);
 
 		ieee80211_recalc_ps_vif(sdata);
@@ -3570,21 +3540,6 @@ void ieee80211_mlme_notify_scan_completed(struct ieee80211_local *local)
 	rcu_read_unlock();
 }
 
-int ieee80211_max_network_latency(struct notifier_block *nb,
-				  unsigned long data, void *dummy)
-{
-	s32 latency_usec = (s32) data;
-	struct ieee80211_local *local =
-		container_of(nb, struct ieee80211_local,
-			     network_latency_notifier);
-
-	mutex_lock(&local->iflist_mtx);
-	ieee80211_recalc_ps(local, latency_usec);
-	mutex_unlock(&local->iflist_mtx);
-
-	return 0;
-}
-
 static u8 ieee80211_ht_vht_rx_chains(struct ieee80211_sub_if_data *sdata,
 				     struct cfg80211_bss *cbss)
 {
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 2049a0a..5802c00 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -29,8 +29,6 @@ static void ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
-	local->offchannel_ps_enabled = false;
-
 	/* FIXME: what to do when local->pspolling is true? */
 
 	del_timer_sync(&ifmgd->dynamic_ps_timer);
@@ -39,13 +37,9 @@ static void ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata)
 
 	cancel_work_sync(&ifmgd->dynamic_ps_enable_work);
 
-	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
-		local->offchannel_ps_enabled = true;
-		local->hw.conf.flags &= ~IEEE80211_CONF_PS;
-		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
-	}
-
-	if (!local->offchannel_ps_enabled ||
+	ifmgd->offchannel_ps_mode = sdata->vif.ps_mode;
+	ieee80211_vif_set_ps_mode(sdata, IEEE80211_VIF_PS_AWAKE_PM);
+	if (ifmgd->offchannel_ps_mode != IEEE80211_VIF_PS_DOZE ||
 	    !(local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK))
 		/*
 		 * If power save was enabled, no need to send a nullfunc
@@ -64,38 +58,23 @@ static void ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata)
 static void ieee80211_offchannel_ps_disable(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	enum ieee80211_vif_ps_mode mode = ifmgd->offchannel_ps_mode;
 
-	if (!local->ps_sdata)
-		ieee80211_send_nullfunc(local, sdata, 0);
-	else if (local->offchannel_ps_enabled) {
-		/*
-		 * In !IEEE80211_HW_PS_NULLFUNC_STACK case the hardware
-		 * will send a nullfunc frame with the powersave bit set
-		 * even though the AP already knows that we are sleeping.
-		 * This could be avoided by sending a null frame with power
-		 * save bit disabled before enabling the power save, but
-		 * this doesn't gain anything.
-		 *
-		 * When IEEE80211_HW_PS_NULLFUNC_STACK is enabled, no need
-		 * to send a nullfunc frame because AP already knows that
-		 * we are sleeping, let's just enable power save mode in
-		 * hardware.
-		 */
-		/* TODO:  Only set hardware if CONF_PS changed?
-		 * TODO:  Should we set offchannel_ps_enabled to false?
-		 */
-		local->hw.conf.flags |= IEEE80211_CONF_PS;
-		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
-	} else if (local->hw.conf.dynamic_ps_timeout > 0) {
-		/*
-		 * If IEEE80211_CONF_PS was not set and the dynamic_ps_timer
-		 * had been running before leaving the operating channel,
-		 * restart the timer now and send a nullfunc frame to inform
-		 * the AP that we are awake.
-		 */
+	/*
+	 * If mode is AWAKE_PM we may have started off-channel during a
+	 * transition to powersave. The AP should already think we're in
+	 * powersave, so go straight to DOZE.
+	 */
+	if (mode == IEEE80211_VIF_PS_AWAKE_PM)
+		mode = IEEE80211_VIF_PS_DOZE;
+
+	ieee80211_vif_set_ps_mode(sdata, mode);
+	if (mode == IEEE80211_VIF_PS_AWAKE) {
 		ieee80211_send_nullfunc(local, sdata, 0);
-		mod_timer(&sdata->u.mgd.dynamic_ps_timer, jiffies +
-			  msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
+		if (sdata->vif.dynamic_ps_active)
+			mod_timer(&ifmgd->dynamic_ps_timer, jiffies +
+				  msecs_to_jiffies(sdata->vif.dynamic_ps_timeout));
 	}
 
 	ieee80211_sta_reset_beacon_monitor(sdata);
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 4d73c46..b0e538e 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -345,6 +345,8 @@ EXPORT_SYMBOL(ieee80211_scan_completed);
 
 static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 {
+	struct ieee80211_sub_if_data *sdata;
+
 	/* Software scan is not supported in multi-channel cases */
 	if (local->use_chanctx)
 		return -EOPNOTSUPP;
@@ -378,6 +380,11 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 	/* We need to set power level at maximum rate for scanning. */
 	ieee80211_hw_config(local, 0);
 
+	sdata = rcu_dereference_protected(local->scan_sdata,
+					  lockdep_is_held(&local->mtx));
+	if (sdata && sdata->vif.ps_mode != IEEE80211_VIF_PS_AWAKE)
+		ieee80211_vif_set_ps_mode(sdata, IEEE80211_VIF_PS_AWAKE);
+
 	ieee80211_queue_delayed_work(&local->hw,
 				     &local->scan_work, 0);
 
@@ -726,6 +733,8 @@ static void ieee80211_scan_state_suspend(struct ieee80211_local *local,
 static void ieee80211_scan_state_resume(struct ieee80211_local *local,
 					unsigned long *next_delay)
 {
+	struct ieee80211_sub_if_data *sdata;
+
 	ieee80211_offchannel_stop_vifs(local);
 
 	if (local->ops->flush) {
@@ -737,6 +746,11 @@ static void ieee80211_scan_state_resume(struct ieee80211_local *local,
 	/* remember when we left the operating channel */
 	local->leave_oper_channel_time = jiffies;
 
+	sdata = rcu_dereference_protected(local->scan_sdata,
+					  lockdep_is_held(&local->mtx));
+	if (sdata && sdata->vif.ps_mode != IEEE80211_VIF_PS_AWAKE)
+		ieee80211_vif_set_ps_mode(sdata, IEEE80211_VIF_PS_AWAKE);
+
 	/* advance to the next channel to be scanned */
 	local->next_scan_state = SCAN_SET_CHANNEL;
 }
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 3298fe9..5e001e0 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -732,15 +732,16 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 			local->dot11FailedCount++;
 	}
 
+	sdata = IEEE80211_DEV_TO_SUB_IF(skb->dev);
 	if (ieee80211_is_nullfunc(fc) && ieee80211_has_pm(fc) &&
 	    (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) &&
 	    !(info->flags & IEEE80211_TX_CTL_INJECTED) &&
-	    local->ps_sdata && !(local->scanning)) {
-		if (info->flags & IEEE80211_TX_STAT_ACK) {
-			local->ps_sdata->u.mgd.flags |=
-					IEEE80211_STA_NULLFUNC_ACKED;
-		} else
-			mod_timer(&local->ps_sdata->u.mgd.dynamic_ps_timer,
+	    sdata->vif.ps_mode < IEEE80211_VIF_PS_AWAKE &&
+	    !(local->scanning)) {
+		if (info->flags & IEEE80211_TX_STAT_ACK)
+			sdata->u.mgd.flags |= IEEE80211_STA_NULLFUNC_ACKED;
+		else
+			mod_timer(&sdata->u.mgd.dynamic_ps_timer,
 				  jiffies + msecs_to_jiffies(10));
 	}
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0ffc2066..995fae4 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -198,6 +198,7 @@ static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_local *local = tx->local;
+	struct ieee80211_sub_if_data *sdata = tx->sdata;
 	struct ieee80211_if_managed *ifmgd;
 
 	/* driver doesn't support power save */
@@ -209,14 +210,15 @@ ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
 		return TX_CONTINUE;
 
 	/* dynamic power save disabled */
-	if (local->hw.conf.dynamic_ps_timeout <= 0)
+	if (sdata->vif.dynamic_ps_timeout <= 0)
 		return TX_CONTINUE;
 
 	/* we are scanning, don't enable power save */
 	if (local->scanning)
 		return TX_CONTINUE;
 
-	if (!local->ps_sdata)
+	if (!sdata->vif.dynamic_ps_active &&
+	    sdata->vif.ps_mode == IEEE80211_VIF_PS_AWAKE)
 		return TX_CONTINUE;
 
 	/* No point if we're going to suspend */
@@ -227,7 +229,7 @@ ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
 	if (tx->sdata->vif.type != NL80211_IFTYPE_STATION)
 		return TX_CONTINUE;
 
-	ifmgd = &tx->sdata->u.mgd;
+	ifmgd = &sdata->u.mgd;
 
 	/*
 	 * Don't wakeup from power save if u-apsd is enabled, voip ac has
@@ -247,7 +249,7 @@ ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
 	    skb_get_queue_mapping(tx->skb) == IEEE80211_AC_VO)
 		return TX_CONTINUE;
 
-	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
+	if (sdata->vif.ps_mode == IEEE80211_VIF_PS_DOZE) {
 		ieee80211_stop_queues_by_reason(&local->hw,
 						IEEE80211_MAX_QUEUE_MAP,
 						IEEE80211_QUEUE_STOP_REASON_PS);
@@ -261,7 +263,7 @@ ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
 		return TX_CONTINUE;
 
 	mod_timer(&ifmgd->dynamic_ps_timer, jiffies +
-		  msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
+		  msecs_to_jiffies(sdata->vif.dynamic_ps_timeout));
 
 	return TX_CONTINUE;
 }
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 010cd2c..9542295 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1664,7 +1664,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		}
 	}
 
-	ieee80211_recalc_ps(local, -1);
+	ieee80211_recalc_ps(sdata);
 
 	/*
 	 * The sta might be in psm against the ap (e.g. because
@@ -1672,15 +1672,15 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	 * explicitly send a null packet in order to make sure
 	 * it'll sync against the ap (and get out of psm).
 	 */
-	if (!(local->hw.conf.flags & IEEE80211_CONF_PS)) {
-		list_for_each_entry(sdata, &local->interfaces, list) {
-			if (sdata->vif.type != NL80211_IFTYPE_STATION)
-				continue;
-			if (!sdata->u.mgd.associated)
-				continue;
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (sdata->vif.type != NL80211_IFTYPE_STATION)
+			continue;
+		if (!sdata->u.mgd.associated)
+			continue;
+		if (sdata->vif.ps_mode != IEEE80211_VIF_PS_AWAKE)
+			continue;
 
-			ieee80211_send_nullfunc(local, sdata, 0);
-		}
+		ieee80211_send_nullfunc(local, sdata, 0);
 	}
 
 	/* APs are now beaconing, add back stations */
@@ -1795,6 +1795,17 @@ void ieee80211_resume_disconnect(struct ieee80211_vif *vif)
 }
 EXPORT_SYMBOL_GPL(ieee80211_resume_disconnect);
 
+void ieee80211_recalc_ps(struct ieee80211_sub_if_data *sdata)
+{
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_STATION:
+		ieee80211_mgd_recalc_ps(sdata);
+		break;
+	default:
+		break;
+	}
+}
+
 void ieee80211_recalc_smps(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
@@ -1835,6 +1846,24 @@ void ieee80211_recalc_min_chandef(struct ieee80211_sub_if_data *sdata)
 	mutex_unlock(&local->chanctx_mtx);
 }
 
+int ieee80211_max_network_latency(struct notifier_block *nb,
+				  unsigned long data, void *dummy)
+{
+	struct ieee80211_local *local =
+		container_of(nb, struct ieee80211_local,
+			     network_latency_notifier);
+	struct ieee80211_sub_if_data *sdata;
+
+	mutex_lock(&local->iflist_mtx);
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		if (ieee80211_sdata_running(sdata))
+			ieee80211_recalc_ps(sdata);
+	}
+	mutex_unlock(&local->iflist_mtx);
+
+	return 0;
+}
+
 static bool ieee80211_id_in_list(const u8 *ids, int n_ids, u8 id)
 {
 	int i;
-- 
1.8.3.2

