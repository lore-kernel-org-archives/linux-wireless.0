Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53115 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758087Ab3BFXQp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 18:16:45 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: simplify idle handling
Date: Thu,  7 Feb 2013 00:17:06 +0100
Message-Id: <1360192626-13998-1-git-send-email-johannes@sipsolutions.net> (sfid-20130207_001654_967351_CB04CCD5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Now that we have channel contexts, idle is (pretty
much) equivalent to not having a channel context.
Change the code to use this relation so that there
no longer is a need for a lot of idle recalculate
calls everywhere.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/chan.c        |  9 +++++
 net/mac80211/ibss.c        |  8 ----
 net/mac80211/ieee80211_i.h |  3 --
 net/mac80211/iface.c       | 94 ++++++----------------------------------------
 net/mac80211/mlme.c        | 34 -----------------
 5 files changed, 21 insertions(+), 127 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 1bfe0a8..e3dfe6c 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -91,6 +91,8 @@ ieee80211_new_chanctx(struct ieee80211_local *local,
 
 	list_add_rcu(&ctx->list, &local->chanctx_list);
 
+	ieee80211_recalc_idle(local);
+
 	return ctx;
 }
 
@@ -110,6 +112,8 @@ static void ieee80211_free_chanctx(struct ieee80211_local *local,
 
 	list_del_rcu(&ctx->list);
 	kfree_rcu(ctx, rcu_head);
+
+	ieee80211_recalc_idle(local);
 }
 
 static int ieee80211_assign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
@@ -128,6 +132,8 @@ static int ieee80211_assign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 	ctx->refcount++;
 
 	ieee80211_recalc_txpower(sdata);
+	sdata->vif.bss_conf.idle = false;
+	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_IDLE);
 
 	return 0;
 }
@@ -175,6 +181,9 @@ static void ieee80211_unassign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 	ctx->refcount--;
 	rcu_assign_pointer(sdata->vif.chanctx_conf, NULL);
 
+	sdata->vif.bss_conf.idle = true;
+	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_IDLE);
+
 	drv_unassign_vif_chanctx(local, sdata, ctx);
 
 	if (ctx->refcount > 0) {
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 055fa94..2db1f2b 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1108,10 +1108,6 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 
 	mutex_unlock(&sdata->u.ibss.mtx);
 
-	mutex_lock(&sdata->local->mtx);
-	ieee80211_recalc_idle(sdata->local);
-	mutex_unlock(&sdata->local->mtx);
-
 	/*
 	 * 802.11n-2009 9.13.3.1: In an IBSS, the HT Protection field is
 	 * reserved, but an HT STA shall protect HT transmissions as though
@@ -1209,9 +1205,5 @@ int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
 
 	mutex_unlock(&sdata->u.ibss.mtx);
 
-	mutex_lock(&local->mtx);
-	ieee80211_recalc_idle(sdata->local);
-	mutex_unlock(&local->mtx);
-
 	return 0;
 }
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 39e746f..75bbb40 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -689,9 +689,6 @@ struct ieee80211_sub_if_data {
 
 	char name[IFNAMSIZ];
 
-	/* to detect idle changes */
-	bool old_idle;
-
 	/* Fragment table for host-based reassembly */
 	struct ieee80211_fragment_entry	fragments[IEEE80211_FRAGMENT_MAX];
 	unsigned int fragment_next;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 3ece8eb..40ff030 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -78,8 +78,7 @@ void ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata)
 		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_TXPOWER);
 }
 
-static u32 ieee80211_idle_off(struct ieee80211_local *local,
-			      const char *reason)
+static u32 ieee80211_idle_off(struct ieee80211_local *local)
 {
 	if (!(local->hw.conf.flags & IEEE80211_CONF_IDLE))
 		return 0;
@@ -99,106 +98,45 @@ static u32 ieee80211_idle_on(struct ieee80211_local *local)
 	return IEEE80211_CONF_CHANGE_IDLE;
 }
 
-static u32 __ieee80211_recalc_idle(struct ieee80211_local *local)
+void ieee80211_recalc_idle(struct ieee80211_local *local)
 {
-	struct ieee80211_sub_if_data *sdata;
-	int count = 0;
-	bool working = false, scanning = false;
+	bool working = false, scanning, active;
 	unsigned int led_trig_start = 0, led_trig_stop = 0;
 	struct ieee80211_roc_work *roc;
+	u32 change;
 
-#ifdef CONFIG_PROVE_LOCKING
-	WARN_ON(debug_locks && !lockdep_rtnl_is_held() &&
-		!lockdep_is_held(&local->iflist_mtx));
-#endif
 	lockdep_assert_held(&local->mtx);
 
-	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (!ieee80211_sdata_running(sdata)) {
-			sdata->vif.bss_conf.idle = true;
-			continue;
-		}
-
-		sdata->old_idle = sdata->vif.bss_conf.idle;
-
-		/* do not count disabled managed interfaces */
-		if (sdata->vif.type == NL80211_IFTYPE_STATION &&
-		    !sdata->u.mgd.associated &&
-		    !sdata->u.mgd.auth_data &&
-		    !sdata->u.mgd.assoc_data) {
-			sdata->vif.bss_conf.idle = true;
-			continue;
-		}
-		/* do not count unused IBSS interfaces */
-		if (sdata->vif.type == NL80211_IFTYPE_ADHOC &&
-		    !sdata->u.ibss.ssid_len) {
-			sdata->vif.bss_conf.idle = true;
-			continue;
-		}
-
-		if (sdata->vif.type == NL80211_IFTYPE_P2P_DEVICE)
-			continue;
-
-		/* count everything else */
-		sdata->vif.bss_conf.idle = false;
-		count++;
-	}
+	active = !list_empty(&local->chanctx_list);
 
 	if (!local->ops->remain_on_channel) {
 		list_for_each_entry(roc, &local->roc_list, list) {
 			working = true;
-			roc->sdata->vif.bss_conf.idle = false;
+			break;
 		}
 	}
 
 	scanning = test_bit(SCAN_SW_SCANNING, &local->scanning) ||
 		   test_bit(SCAN_ONCHANNEL_SCANNING, &local->scanning);
 
-	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (sdata->vif.type == NL80211_IFTYPE_MONITOR ||
-		    sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
-		    sdata->vif.type == NL80211_IFTYPE_P2P_DEVICE)
-			continue;
-		if (sdata->old_idle == sdata->vif.bss_conf.idle)
-			continue;
-		if (!ieee80211_sdata_running(sdata))
-			continue;
-		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_IDLE);
-	}
-
 	if (working || scanning)
 		led_trig_start |= IEEE80211_TPT_LEDTRIG_FL_WORK;
 	else
 		led_trig_stop |= IEEE80211_TPT_LEDTRIG_FL_WORK;
 
-	if (count)
+	if (active)
 		led_trig_start |= IEEE80211_TPT_LEDTRIG_FL_CONNECTED;
 	else
 		led_trig_stop |= IEEE80211_TPT_LEDTRIG_FL_CONNECTED;
 
 	ieee80211_mod_tpt_led_trig(local, led_trig_start, led_trig_stop);
 
-	if (working)
-		return ieee80211_idle_off(local, "working");
-	if (scanning)
-		return ieee80211_idle_off(local, "scanning");
-	if (!count)
-		return ieee80211_idle_on(local);
+	if (working || scanning || active)
+		change = ieee80211_idle_off(local);
 	else
-		return ieee80211_idle_off(local, "in use");
-
-	return 0;
-}
-
-void ieee80211_recalc_idle(struct ieee80211_local *local)
-{
-	u32 chg;
-
-	mutex_lock(&local->iflist_mtx);
-	chg = __ieee80211_recalc_idle(local);
-	mutex_unlock(&local->iflist_mtx);
-	if (chg)
-		ieee80211_hw_config(local, chg);
+		change = ieee80211_idle_on(local);
+	if (change)
+		ieee80211_hw_config(local, change);
 }
 
 static int ieee80211_change_mtu(struct net_device *dev, int new_mtu)
@@ -692,10 +630,6 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 	if (sdata->flags & IEEE80211_SDATA_PROMISC)
 		atomic_inc(&local->iff_promiscs);
 
-	mutex_lock(&local->mtx);
-	hw_reconf_flags |= __ieee80211_recalc_idle(local);
-	mutex_unlock(&local->mtx);
-
 	if (coming_up)
 		local->open_count++;
 
@@ -888,10 +822,6 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 
 	sdata->bss = NULL;
 
-	mutex_lock(&local->mtx);
-	hw_reconf_flags |= __ieee80211_recalc_idle(local);
-	mutex_unlock(&local->mtx);
-
 	ieee80211_recalc_ps(local, -1);
 
 	if (local->open_count == 0) {
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c0934e5..66a392c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1791,7 +1791,6 @@ EXPORT_SYMBOL(ieee80211_ap_probereq_get);
 static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	struct ieee80211_local *local = sdata->local;
 	u8 frame_buf[IEEE80211_DEAUTH_FRAME_LEN];
 
 	mutex_lock(&ifmgd->mtx);
@@ -1811,10 +1810,6 @@ static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata)
 	 * but that's not a problem.
 	 */
 	cfg80211_send_deauth(sdata->dev, frame_buf, IEEE80211_DEAUTH_FRAME_LEN);
-
-	mutex_lock(&local->mtx);
-	ieee80211_recalc_idle(local);
-	mutex_unlock(&local->mtx);
 }
 
 static void ieee80211_beacon_connection_loss_work(struct work_struct *work)
@@ -2047,10 +2042,6 @@ ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
 
 	ieee80211_set_disassoc(sdata, 0, 0, false, NULL);
 
-	mutex_lock(&sdata->local->mtx);
-	ieee80211_recalc_idle(sdata->local);
-	mutex_unlock(&sdata->local->mtx);
-
 	return RX_MGMT_CFG80211_DEAUTH;
 }
 
@@ -2078,10 +2069,6 @@ ieee80211_rx_mgmt_disassoc(struct ieee80211_sub_if_data *sdata,
 
 	ieee80211_set_disassoc(sdata, 0, 0, false, NULL);
 
-	mutex_lock(&sdata->local->mtx);
-	ieee80211_recalc_idle(sdata->local);
-	mutex_unlock(&sdata->local->mtx);
-
 	return RX_MGMT_CFG80211_DISASSOC;
 }
 
@@ -2865,7 +2852,6 @@ static void ieee80211_sta_timer(unsigned long data)
 static void ieee80211_sta_connection_lost(struct ieee80211_sub_if_data *sdata,
 					  u8 *bssid, u8 reason, bool tx)
 {
-	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	u8 frame_buf[IEEE80211_DEAUTH_FRAME_LEN];
 
@@ -2879,10 +2865,6 @@ static void ieee80211_sta_connection_lost(struct ieee80211_sub_if_data *sdata,
 	 */
 	cfg80211_send_deauth(sdata->dev, frame_buf, IEEE80211_DEAUTH_FRAME_LEN);
 
-	mutex_lock(&local->mtx);
-	ieee80211_recalc_idle(local);
-	mutex_unlock(&local->mtx);
-
 	mutex_lock(&ifmgd->mtx);
 }
 
@@ -3153,10 +3135,6 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 	}
 
 	mutex_unlock(&ifmgd->mtx);
-
-	mutex_lock(&local->mtx);
-	ieee80211_recalc_idle(local);
-	mutex_unlock(&local->mtx);
 }
 
 static void ieee80211_sta_bcn_mon_timer(unsigned long data)
@@ -3670,10 +3648,6 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 			return -ENOMEM;
 	}
 
-	mutex_lock(&local->mtx);
-	ieee80211_recalc_idle(sdata->local);
-	mutex_unlock(&local->mtx);
-
 	if (new_sta) {
 		u32 rates = 0, basic_rates = 0;
 		bool have_higher_than_11mbit;
@@ -4164,10 +4138,6 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 	mutex_unlock(&ifmgd->mtx);
 
  out:
-	mutex_lock(&sdata->local->mtx);
-	ieee80211_recalc_idle(sdata->local);
-	mutex_unlock(&sdata->local->mtx);
-
 	if (sent_frame)
 		__cfg80211_send_deauth(sdata->dev, frame_buf,
 				       IEEE80211_DEAUTH_FRAME_LEN);
@@ -4208,10 +4178,6 @@ int ieee80211_mgd_disassoc(struct ieee80211_sub_if_data *sdata,
 	__cfg80211_send_disassoc(sdata->dev, frame_buf,
 				 IEEE80211_DEAUTH_FRAME_LEN);
 
-	mutex_lock(&sdata->local->mtx);
-	ieee80211_recalc_idle(sdata->local);
-	mutex_unlock(&sdata->local->mtx);
-
 	return 0;
 }
 
-- 
1.8.0

