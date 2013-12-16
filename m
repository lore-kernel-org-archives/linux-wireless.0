Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:41589 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab3LPWBF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 17:01:05 -0500
Received: by mail-ob0-f180.google.com with SMTP id wo20so5369937obc.25
        for <linux-wireless@vger.kernel.org>; Mon, 16 Dec 2013 14:01:05 -0800 (PST)
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	brcm80211-dev-list@broadcom.com,
	"John W. Linville" <linville@tuxdriver.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Arend van Spriel <arend@broadcom.com>,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [RFC PATCH 1/8] mac80211: Move dynamic PS data out of common code
Date: Mon, 16 Dec 2013 16:00:53 -0600
Message-Id: <1387231260-2849-2-git-send-email-seth.forshee@canonical.com> (sfid-20131216_230112_998807_5D5DB07D)
In-Reply-To: <1387231260-2849-1-git-send-email-seth.forshee@canonical.com>
References: <1387231260-2849-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The timers and work structs for dynamic powersave are used only
for managed interfaces, so move them to ieee80211_if_managed and
deal with them only in sections of code specifically dealing with
managed mode interfaces.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 net/mac80211/ieee80211_i.h | 11 +++---
 net/mac80211/iface.c       |  3 --
 net/mac80211/main.c        |  7 ----
 net/mac80211/mlme.c        | 89 +++++++++++++++++++++++++++++++---------------
 net/mac80211/offchannel.c  |  6 ++--
 net/mac80211/pm.c          | 17 +++++----
 net/mac80211/rx.c          | 10 +-----
 net/mac80211/status.c      |  4 +--
 net/mac80211/tx.c          |  4 +--
 net/mac80211/util.c        | 11 ++++++
 10 files changed, 94 insertions(+), 68 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ed5bf8b..785d1b8 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -387,10 +387,13 @@ struct ieee80211_if_managed {
 	struct timer_list conn_mon_timer;
 	struct timer_list bcn_mon_timer;
 	struct timer_list chswitch_timer;
+	struct timer_list dynamic_ps_timer;
 	struct work_struct monitor_work;
 	struct work_struct chswitch_work;
 	struct work_struct beacon_connection_loss_work;
 	struct work_struct csa_connection_drop_work;
+	struct work_struct dynamic_ps_enable_work;
+	struct work_struct dynamic_ps_disable_work;
 
 	unsigned long beacon_timeout;
 	unsigned long probe_timeout;
@@ -1188,9 +1191,6 @@ struct ieee80211_local {
 	 * interface (and monitors) in PS, this then points there.
 	 */
 	struct ieee80211_sub_if_data *ps_sdata;
-	struct work_struct dynamic_ps_enable_work;
-	struct work_struct dynamic_ps_disable_work;
-	struct timer_list dynamic_ps_timer;
 	struct notifier_block network_latency_notifier;
 	struct notifier_block ifa_notifier;
 	struct notifier_block ifa6_notifier;
@@ -1363,6 +1363,7 @@ void ieee80211_send_pspoll(struct ieee80211_local *local,
 			   struct ieee80211_sub_if_data *sdata);
 void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency);
 void ieee80211_recalc_ps_vif(struct ieee80211_sub_if_data *sdata);
+void ieee80211_mgd_notify_rx(struct ieee80211_rx_data *rx);
 int ieee80211_max_network_latency(struct notifier_block *nb,
 				  unsigned long data, void *dummy);
 int ieee80211_set_arp_filter(struct ieee80211_sub_if_data *sdata);
@@ -1594,6 +1595,7 @@ static inline int __ieee80211_resume(struct ieee80211_hw *hw)
 extern void *mac80211_wiphy_privid; /* for wiphy privid */
 u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
 			enum nl80211_iftype type);
+void ieee80211_notify_rx(struct ieee80211_rx_data *rx);
 int ieee80211_frame_duration(enum ieee80211_band band, size_t len,
 			     int rate, int erp, int short_preamble,
 			     int shift);
@@ -1654,9 +1656,6 @@ static inline void ieee802_11_parse_elems(const u8 *start, size_t len,
 	ieee802_11_parse_elems_crc(start, len, action, elems, 0, 0);
 }
 
-void ieee80211_dynamic_ps_enable_work(struct work_struct *work);
-void ieee80211_dynamic_ps_disable_work(struct work_struct *work);
-void ieee80211_dynamic_ps_timer(unsigned long data);
 void ieee80211_send_nullfunc(struct ieee80211_local *local,
 			     struct ieee80211_sub_if_data *sdata,
 			     int powersave);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 7aa9f9d..784b651 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -816,9 +816,6 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		netif_addr_unlock_bh(sdata->dev);
 	}
 
-	del_timer_sync(&local->dynamic_ps_timer);
-	cancel_work_sync(&local->dynamic_ps_enable_work);
-
 	cancel_work_sync(&sdata->recalc_smps);
 	sdata->vif.csa_active = false;
 	cancel_work_sync(&sdata->csa_finalize_work);
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index fa34cd2..4ab607c 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -614,13 +614,6 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	INIT_WORK(&local->reconfig_filter, ieee80211_reconfig_filter);
 	local->smps_mode = IEEE80211_SMPS_OFF;
 
-	INIT_WORK(&local->dynamic_ps_enable_work,
-		  ieee80211_dynamic_ps_enable_work);
-	INIT_WORK(&local->dynamic_ps_disable_work,
-		  ieee80211_dynamic_ps_disable_work);
-	setup_timer(&local->dynamic_ps_timer,
-		    ieee80211_dynamic_ps_timer, (unsigned long) local);
-
 	INIT_WORK(&local->sched_scan_stopped_work,
 		  ieee80211_sched_scan_stopped_work);
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 900ead3..4ec8c0a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1139,6 +1139,7 @@ static void ieee80211_enable_ps(struct ieee80211_local *local,
 				struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_conf *conf = &local->hw.conf;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	/*
 	 * If we are scanning right now then the parameters will
@@ -1149,7 +1150,7 @@ static void ieee80211_enable_ps(struct ieee80211_local *local,
 
 	if (conf->dynamic_ps_timeout > 0 &&
 	    !(local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS)) {
-		mod_timer(&local->dynamic_ps_timer, jiffies +
+		mod_timer(&ifmgd->dynamic_ps_timer, jiffies +
 			  msecs_to_jiffies(conf->dynamic_ps_timeout));
 	} else {
 		if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)
@@ -1164,17 +1165,19 @@ static void ieee80211_enable_ps(struct ieee80211_local *local,
 	}
 }
 
-static void ieee80211_change_ps(struct ieee80211_local *local)
+static void ieee80211_change_ps(struct ieee80211_sub_if_data *sdata, bool ps_enable)
 {
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_conf *conf = &local->hw.conf;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
-	if (local->ps_sdata) {
-		ieee80211_enable_ps(local, local->ps_sdata);
+	if (ps_enable) {
+		ieee80211_enable_ps(local, sdata);
 	} else if (conf->flags & IEEE80211_CONF_PS) {
 		conf->flags &= ~IEEE80211_CONF_PS;
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
-		del_timer_sync(&local->dynamic_ps_timer);
-		cancel_work_sync(&local->dynamic_ps_enable_work);
+		del_timer_sync(&ifmgd->dynamic_ps_timer);
+		cancel_work_sync(&ifmgd->dynamic_ps_enable_work);
 	}
 }
 
@@ -1211,7 +1214,7 @@ static bool ieee80211_powersave_allowed(struct ieee80211_sub_if_data *sdata)
 /* need to hold RTNL or interface lock */
 void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
 {
-	struct ieee80211_sub_if_data *sdata, *found = NULL;
+	struct ieee80211_sub_if_data *sdata, *old_ps_sdata, *found = NULL;
 	int count = 0;
 	int timeout;
 
@@ -1220,6 +1223,8 @@ void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
 		return;
 	}
 
+	old_ps_sdata = local->ps_sdata;
+
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		if (!ieee80211_sdata_running(sdata))
 			continue;
@@ -1284,7 +1289,10 @@ void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
 		local->ps_sdata = NULL;
 	}
 
-	ieee80211_change_ps(local);
+	if (local->ps_sdata)
+		ieee80211_change_ps(local->ps_sdata, true);
+	else if (old_ps_sdata)
+		ieee80211_change_ps(old_ps_sdata, false);
 }
 
 void ieee80211_recalc_ps_vif(struct ieee80211_sub_if_data *sdata)
@@ -1297,11 +1305,12 @@ void ieee80211_recalc_ps_vif(struct ieee80211_sub_if_data *sdata)
 	}
 }
 
-void ieee80211_dynamic_ps_disable_work(struct work_struct *work)
+static void ieee80211_dynamic_ps_disable_work(struct work_struct *work)
 {
-	struct ieee80211_local *local =
-		container_of(work, struct ieee80211_local,
-			     dynamic_ps_disable_work);
+	struct ieee80211_sub_if_data *sdata =
+		container_of(work, struct ieee80211_sub_if_data,
+			     u.mgd.dynamic_ps_disable_work);
+	struct ieee80211_local *local = sdata->local;
 
 	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
 		local->hw.conf.flags &= ~IEEE80211_CONF_PS;
@@ -1313,29 +1322,27 @@ void ieee80211_dynamic_ps_disable_work(struct work_struct *work)
 					IEEE80211_QUEUE_STOP_REASON_PS);
 }
 
-void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
+static void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 {
-	struct ieee80211_local *local =
-		container_of(work, struct ieee80211_local,
-			     dynamic_ps_enable_work);
-	struct ieee80211_sub_if_data *sdata = local->ps_sdata;
-	struct ieee80211_if_managed *ifmgd;
+	struct ieee80211_sub_if_data *sdata =
+		container_of(work, struct ieee80211_sub_if_data,
+			     u.mgd.dynamic_ps_enable_work);
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	unsigned long flags;
 	int q;
 
 	/* can only happen when PS was just disabled anyway */
-	if (!sdata)
+	if (!local->ps_sdata)
 		return;
 
-	ifmgd = &sdata->u.mgd;
-
 	if (local->hw.conf.flags & IEEE80211_CONF_PS)
 		return;
 
 	if (local->hw.conf.dynamic_ps_timeout > 0) {
 		/* don't enter PS if TX frames are pending */
 		if (drv_tx_frames_pending(local)) {
-			mod_timer(&local->dynamic_ps_timer, jiffies +
+			mod_timer(&ifmgd->dynamic_ps_timer, jiffies +
 				  msecs_to_jiffies(
 				  local->hw.conf.dynamic_ps_timeout));
 			return;
@@ -1351,7 +1358,7 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 			if (local->queue_stop_reasons[q]) {
 				spin_unlock_irqrestore(&local->queue_stop_reason_lock,
 						       flags);
-				mod_timer(&local->dynamic_ps_timer, jiffies +
+				mod_timer(&ifmgd->dynamic_ps_timer, jiffies +
 					  msecs_to_jiffies(
 					  local->hw.conf.dynamic_ps_timeout));
 				return;
@@ -1363,7 +1370,7 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 	if ((local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) &&
 	    !(ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED)) {
 		if (drv_tx_frames_pending(local)) {
-			mod_timer(&local->dynamic_ps_timer, jiffies +
+			mod_timer(&ifmgd->dynamic_ps_timer, jiffies +
 				  msecs_to_jiffies(
 				  local->hw.conf.dynamic_ps_timeout));
 		} else {
@@ -1382,14 +1389,30 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 	}
 }
 
-void ieee80211_dynamic_ps_timer(unsigned long data)
+static void ieee80211_dynamic_ps_timer(unsigned long data)
 {
-	struct ieee80211_local *local = (void *) data;
+	struct ieee80211_sub_if_data *sdata = (void *)data;
+	struct ieee80211_local *local = sdata->local;
 
 	if (local->quiescing || local->suspended)
 		return;
 
-	ieee80211_queue_work(&local->hw, &local->dynamic_ps_enable_work);
+	ieee80211_queue_work(&local->hw, &sdata->u.mgd.dynamic_ps_enable_work);
+}
+
+void ieee80211_mgd_notify_rx(struct ieee80211_rx_data *rx)
+{
+	struct ieee80211_sub_if_data *sdata = rx->sdata;
+	struct ieee80211_local *local = rx->local;
+
+	if (local->ps_sdata && local->hw.conf.dynamic_ps_timeout > 0 &&
+	    !is_multicast_ether_addr(
+		    ((struct ethhdr *)rx->skb->data)->h_dest) &&
+	    (!local->scanning &&
+	     !test_bit(SDATA_STATE_OFFCHANNEL, &sdata->state))) {
+			mod_timer(&sdata->u.mgd.dynamic_ps_timer, jiffies +
+			 msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
+	}
 }
 
 void ieee80211_dfs_cac_timer_work(struct work_struct *work)
@@ -1719,8 +1742,8 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 
 	sdata->ap_power_level = IEEE80211_UNSET_POWER_LEVEL;
 
-	del_timer_sync(&local->dynamic_ps_timer);
-	cancel_work_sync(&local->dynamic_ps_enable_work);
+	del_timer_sync(&ifmgd->dynamic_ps_timer);
+	cancel_work_sync(&ifmgd->dynamic_ps_enable_work);
 
 	/* Disable ARP filtering */
 	if (sdata->vif.bss_conf.arp_addr_cnt)
@@ -3506,6 +3529,10 @@ void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
 	INIT_WORK(&ifmgd->csa_connection_drop_work,
 		  ieee80211_csa_connection_drop_work);
 	INIT_WORK(&ifmgd->request_smps_work, ieee80211_request_smps_mgd_work);
+	INIT_WORK(&ifmgd->dynamic_ps_enable_work,
+		  ieee80211_dynamic_ps_enable_work);
+	INIT_WORK(&ifmgd->dynamic_ps_disable_work,
+		  ieee80211_dynamic_ps_disable_work);
 	setup_timer(&ifmgd->timer, ieee80211_sta_timer,
 		    (unsigned long) sdata);
 	setup_timer(&ifmgd->bcn_mon_timer, ieee80211_sta_bcn_mon_timer,
@@ -3514,6 +3541,8 @@ void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
 		    (unsigned long) sdata);
 	setup_timer(&ifmgd->chswitch_timer, ieee80211_chswitch_timer,
 		    (unsigned long) sdata);
+	setup_timer(&ifmgd->dynamic_ps_timer, ieee80211_dynamic_ps_timer,
+		    (unsigned long) sdata);
 
 	ifmgd->flags = 0;
 	ifmgd->powersave = sdata->wdev.ps;
@@ -4361,6 +4390,7 @@ void ieee80211_mgd_stop(struct ieee80211_sub_if_data *sdata)
 	cancel_work_sync(&ifmgd->request_smps_work);
 	cancel_work_sync(&ifmgd->csa_connection_drop_work);
 	cancel_work_sync(&ifmgd->chswitch_work);
+	cancel_work_sync(&ifmgd->dynamic_ps_enable_work);
 
 	sdata_lock(sdata);
 	if (ifmgd->assoc_data) {
@@ -4371,6 +4401,7 @@ void ieee80211_mgd_stop(struct ieee80211_sub_if_data *sdata)
 	if (ifmgd->auth_data)
 		ieee80211_destroy_auth_data(sdata, false);
 	del_timer_sync(&ifmgd->timer);
+	del_timer_sync(&ifmgd->dynamic_ps_timer);
 	sdata_unlock(sdata);
 }
 
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 0c2a294..2049a0a 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -33,11 +33,11 @@ static void ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata)
 
 	/* FIXME: what to do when local->pspolling is true? */
 
-	del_timer_sync(&local->dynamic_ps_timer);
+	del_timer_sync(&ifmgd->dynamic_ps_timer);
 	del_timer_sync(&ifmgd->bcn_mon_timer);
 	del_timer_sync(&ifmgd->conn_mon_timer);
 
-	cancel_work_sync(&local->dynamic_ps_enable_work);
+	cancel_work_sync(&ifmgd->dynamic_ps_enable_work);
 
 	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
 		local->offchannel_ps_enabled = true;
@@ -94,7 +94,7 @@ static void ieee80211_offchannel_ps_disable(struct ieee80211_sub_if_data *sdata)
 		 * the AP that we are awake.
 		 */
 		ieee80211_send_nullfunc(local, sdata, 0);
-		mod_timer(&local->dynamic_ps_timer, jiffies +
+		mod_timer(&sdata->u.mgd.dynamic_ps_timer, jiffies +
 			  msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
 	}
 
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 3401262..894c497 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -52,13 +52,6 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 	/* Don't try to run timers while suspended. */
 	del_timer_sync(&local->sta_cleanup);
 
-	 /*
-	 * Note that this particular timer doesn't need to be
-	 * restarted at resume.
-	 */
-	cancel_work_sync(&local->dynamic_ps_enable_work);
-	del_timer_sync(&local->dynamic_ps_timer);
-
 	local->wowlan = wowlan && local->open_count;
 	if (local->wowlan) {
 		int err = drv_suspend(local, wowlan);
@@ -106,6 +99,16 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 		    sdata->vif.type == NL80211_IFTYPE_MONITOR)
 			continue;
 
+		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
+			struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+			 /*
+			 * Note that this particular timer doesn't need to be
+			 * restarted at resume.
+			 */
+			cancel_work_sync(&ifmgd->dynamic_ps_enable_work);
+			del_timer_sync(&ifmgd->dynamic_ps_timer);
+		}
+
 		drv_remove_interface(local, sdata);
 	}
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 2dfa755..5707566 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2212,7 +2212,6 @@ static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
-	struct ieee80211_local *local = rx->local;
 	struct net_device *dev = sdata->dev;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 	__le16 fc = hdr->frame_control;
@@ -2258,14 +2257,7 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 	dev->stats.rx_packets++;
 	dev->stats.rx_bytes += rx->skb->len;
 
-	if (local->ps_sdata && local->hw.conf.dynamic_ps_timeout > 0 &&
-	    !is_multicast_ether_addr(
-		    ((struct ethhdr *)rx->skb->data)->h_dest) &&
-	    (!local->scanning &&
-	     !test_bit(SDATA_STATE_OFFCHANNEL, &sdata->state))) {
-			mod_timer(&local->dynamic_ps_timer, jiffies +
-			 msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
-	}
+	ieee80211_notify_rx(rx);
 
 	ieee80211_deliver_skb(rx);
 
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 1ee85c4..3298fe9 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -740,8 +740,8 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 			local->ps_sdata->u.mgd.flags |=
 					IEEE80211_STA_NULLFUNC_ACKED;
 		} else
-			mod_timer(&local->dynamic_ps_timer, jiffies +
-					msecs_to_jiffies(10));
+			mod_timer(&local->ps_sdata->u.mgd.dynamic_ps_timer,
+				  jiffies + msecs_to_jiffies(10));
 	}
 
 	ieee80211_report_used_skb(local, skb, false);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 6d59e21..0ffc2066 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -253,14 +253,14 @@ ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
 						IEEE80211_QUEUE_STOP_REASON_PS);
 		ifmgd->flags &= ~IEEE80211_STA_NULLFUNC_ACKED;
 		ieee80211_queue_work(&local->hw,
-				     &local->dynamic_ps_disable_work);
+				     &ifmgd->dynamic_ps_disable_work);
 	}
 
 	/* Don't restart the timer if we're not disassociated */
 	if (!ifmgd->associated)
 		return TX_CONTINUE;
 
-	mod_timer(&local->dynamic_ps_timer, jiffies +
+	mod_timer(&ifmgd->dynamic_ps_timer, jiffies +
 		  msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
 
 	return TX_CONTINUE;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 875e172..010cd2c 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -95,6 +95,17 @@ u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
 	return NULL;
 }
 
+void ieee80211_notify_rx(struct ieee80211_rx_data *rx)
+{
+	switch(rx->sdata->vif.type) {
+	case NL80211_IFTYPE_MONITOR:
+		ieee80211_mgd_notify_rx(rx);
+		break;
+	default:
+		break;
+	}
+}
+
 void ieee80211_tx_set_protected(struct ieee80211_tx_data *tx)
 {
 	struct sk_buff *skb;
-- 
1.8.3.2

