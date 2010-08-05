Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39230 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758647Ab0HEPCk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Aug 2010 11:02:40 -0400
Subject: [PATCH] mac80211: per interface idle notification
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 17:02:38 +0200
Message-ID: <1281020558.4058.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Sometimes we don't just need to know whether or
not the device is idle, but also per interface.
This adds that reporting capability to mac80211.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     |    6 +++++
 net/mac80211/ibss.c        |    8 +++++-
 net/mac80211/ieee80211_i.h |    3 ++
 net/mac80211/iface.c       |   53 ++++++++++++++++++++++++++++++++++++++-------
 net/mac80211/mlme.c        |   17 ++++++++++++--
 net/mac80211/scan.c        |    2 +
 net/mac80211/work.c        |    8 +++---
 7 files changed, 81 insertions(+), 16 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2010-08-05 16:11:44.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2010-08-05 16:12:39.000000000 +0200
@@ -149,6 +149,7 @@ struct ieee80211_low_level_stats {
  * @BSS_CHANGED_ARP_FILTER: Hardware ARP filter address list or state changed.
  * @BSS_CHANGED_QOS: QoS for this association was enabled/disabled. Note
  *	that it is only ever disabled for station mode.
+ * @BSS_CHANGED_IDLE: Idle changed for this BSS/interface.
  */
 enum ieee80211_bss_change {
 	BSS_CHANGED_ASSOC		= 1<<0,
@@ -165,6 +166,7 @@ enum ieee80211_bss_change {
 	BSS_CHANGED_IBSS		= 1<<11,
 	BSS_CHANGED_ARP_FILTER		= 1<<12,
 	BSS_CHANGED_QOS			= 1<<13,
+	BSS_CHANGED_IDLE		= 1<<14,
 
 	/* when adding here, make sure to change ieee80211_reconfig */
 };
@@ -223,6 +225,9 @@ enum ieee80211_bss_change {
  *	hardware must not perform any ARP filtering. Note, that the filter will
  *	be enabled also in promiscuous mode.
  * @qos: This is a QoS-enabled BSS.
+ * @idle: This interface is idle. There's also a global idle flag in the
+ *	hardware config which may be more appropriate depending on what
+ *	your driver/device needs to do.
  */
 struct ieee80211_bss_conf {
 	const u8 *bssid;
@@ -247,6 +252,7 @@ struct ieee80211_bss_conf {
 	u8 arp_addr_cnt;
 	bool arp_filter_enabled;
 	bool qos;
+	bool idle;
 };
 
 /**
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-08-05 16:12:31.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-08-05 16:12:39.000000000 +0200
@@ -497,6 +497,9 @@ struct ieee80211_sub_if_data {
 	 */
 	bool ht_opmode_valid;
 
+	/* to detect idle changes */
+	bool old_idle;
+
 	/* Fragment table for host-based reassembly */
 	struct ieee80211_fragment_entry	fragments[IEEE80211_FRAGMENT_MAX];
 	unsigned int fragment_next;
--- wireless-testing.orig/net/mac80211/iface.c	2010-08-05 16:07:38.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2010-08-05 16:12:39.000000000 +0200
@@ -307,7 +307,9 @@ static int ieee80211_open(struct net_dev
 	if (sdata->flags & IEEE80211_SDATA_PROMISC)
 		atomic_inc(&local->iff_promiscs);
 
+	mutex_lock(&local->mtx);
 	hw_reconf_flags |= __ieee80211_recalc_idle(local);
+	mutex_unlock(&local->mtx);
 
 	local->open_count++;
 	if (hw_reconf_flags) {
@@ -514,7 +516,9 @@ static int ieee80211_stop(struct net_dev
 
 	sdata->bss = NULL;
 
+	mutex_lock(&local->mtx);
 	hw_reconf_flags |= __ieee80211_recalc_idle(local);
+	mutex_unlock(&local->mtx);
 
 	ieee80211_recalc_ps(local, -1);
 
@@ -1195,28 +1199,61 @@ u32 __ieee80211_recalc_idle(struct ieee8
 {
 	struct ieee80211_sub_if_data *sdata;
 	int count = 0;
+	bool working = false, scanning = false;
+	struct ieee80211_work *wk;
 
-	if (!list_empty(&local->work_list))
-		return ieee80211_idle_off(local, "working");
-
-	if (local->scanning)
-		return ieee80211_idle_off(local, "scanning");
+#ifdef CONFIG_PROVE_LOCKING
+	WARN_ON(debug_locks && !lockdep_rtnl_is_held() &&
+		!lockdep_is_held(&local->iflist_mtx));
+#endif
+	lockdep_assert_held(&local->mtx);
 
 	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (!ieee80211_sdata_running(sdata))
+		if (!ieee80211_sdata_running(sdata)) {
+			sdata->vif.bss_conf.idle = true;
 			continue;
+		}
+
+		sdata->old_idle = sdata->vif.bss_conf.idle;
+
 		/* do not count disabled managed interfaces */
 		if (sdata->vif.type == NL80211_IFTYPE_STATION &&
-		    !sdata->u.mgd.associated)
+		    !sdata->u.mgd.associated) {
+			sdata->vif.bss_conf.idle = true;
 			continue;
+		}
 		/* do not count unused IBSS interfaces */
 		if (sdata->vif.type == NL80211_IFTYPE_ADHOC &&
-		    !sdata->u.ibss.ssid_len)
+		    !sdata->u.ibss.ssid_len) {
+			sdata->vif.bss_conf.idle = true;
 			continue;
+		}
 		/* count everything else */
 		count++;
 	}
 
+	list_for_each_entry(wk, &local->work_list, list) {
+		working = true;
+		wk->sdata->vif.bss_conf.idle = false;
+	}
+
+	if (local->scan_sdata) {
+		scanning = true;
+		local->scan_sdata->vif.bss_conf.idle = false;
+	}
+
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (sdata->old_idle == sdata->vif.bss_conf.idle)
+			continue;
+		if (!ieee80211_sdata_running(sdata))
+			continue;
+		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_IDLE);
+	}
+
+	if (working)
+		return ieee80211_idle_off(local, "working");
+	if (scanning)
+		return ieee80211_idle_off(local, "scanning");
 	if (!count)
 		return ieee80211_idle_on(local);
 	else
--- wireless-testing.orig/net/mac80211/scan.c	2010-08-05 16:12:31.000000000 +0200
+++ wireless-testing/net/mac80211/scan.c	2010-08-05 16:12:39.000000000 +0200
@@ -305,7 +305,9 @@ void ieee80211_scan_completed(struct iee
 	ieee80211_offchannel_return(local, true);
 
  done:
+	mutex_lock(&local->mtx);
 	ieee80211_recalc_idle(local);
+	mutex_unlock(&local->mtx);
 	ieee80211_mlme_notify_scan_completed(local);
 	ieee80211_ibss_notify_scan_completed(local);
 	ieee80211_mesh_notify_scan_completed(local);
--- wireless-testing.orig/net/mac80211/work.c	2010-08-05 16:12:31.000000000 +0200
+++ wireless-testing/net/mac80211/work.c	2010-08-05 16:12:39.000000000 +0200
@@ -888,10 +888,10 @@ static void ieee80211_work_work(struct w
 	while ((skb = skb_dequeue(&local->work_skb_queue)))
 		ieee80211_work_rx_queued_mgmt(local, skb);
 
-	ieee80211_recalc_idle(local);
-
 	mutex_lock(&local->mtx);
 
+	ieee80211_recalc_idle(local);
+
 	list_for_each_entry_safe(wk, tmp, &local->work_list, list) {
 		bool started = wk->started;
 
@@ -1001,10 +1001,10 @@ static void ieee80211_work_work(struct w
 					     &local->scan_work,
 					     round_jiffies_relative(0));
 
-	mutex_unlock(&local->mtx);
-
 	ieee80211_recalc_idle(local);
 
+	mutex_unlock(&local->mtx);
+
 	list_for_each_entry_safe(wk, tmp, &free_work, list) {
 		wk->done(wk, NULL);
 		list_del(&wk->list);
--- wireless-testing.orig/net/mac80211/mlme.c	2010-08-05 16:12:31.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2010-08-05 16:22:42.000000000 +0200
@@ -1103,8 +1103,11 @@ static void __ieee80211_connection_loss(
 	printk(KERN_DEBUG "Connection to AP %pM lost.\n", bssid);
 
 	ieee80211_set_disassoc(sdata, true);
-	ieee80211_recalc_idle(local);
 	mutex_unlock(&ifmgd->mtx);
+
+	mutex_lock(&local->mtx);
+	ieee80211_recalc_idle(local);
+	mutex_unlock(&local->mtx);
 	/*
 	 * must be outside lock due to cfg80211,
 	 * but that's not a problem.
@@ -1173,7 +1176,9 @@ ieee80211_rx_mgmt_deauth(struct ieee8021
 			sdata->name, bssid, reason_code);
 
 	ieee80211_set_disassoc(sdata, true);
+	mutex_lock(&sdata->local->mtx);
 	ieee80211_recalc_idle(sdata->local);
+	mutex_unlock(&sdata->local->mtx);
 
 	return RX_MGMT_CFG80211_DEAUTH;
 }
@@ -1203,7 +1208,9 @@ ieee80211_rx_mgmt_disassoc(struct ieee80
 			sdata->name, mgmt->sa, reason_code);
 
 	ieee80211_set_disassoc(sdata, true);
+	mutex_lock(&sdata->local->mtx);
 	ieee80211_recalc_idle(sdata->local);
+	mutex_unlock(&sdata->local->mtx);
 	return RX_MGMT_CFG80211_DISASSOC;
 }
 
@@ -1840,8 +1847,10 @@ void ieee80211_sta_work(struct ieee80211
 				" after %dms, disconnecting.\n",
 				bssid, (1000 * IEEE80211_PROBE_WAIT)/HZ);
 			ieee80211_set_disassoc(sdata, true);
-			ieee80211_recalc_idle(local);
 			mutex_unlock(&ifmgd->mtx);
+			mutex_lock(&local->mtx);
+			ieee80211_recalc_idle(local);
+			mutex_unlock(&local->mtx);
 			/*
 			 * must be outside lock due to cfg80211,
 			 * but that's not a problem.
@@ -2319,7 +2328,9 @@ int ieee80211_mgd_deauth(struct ieee8021
 	if (assoc_bss)
 		sta_info_destroy_addr(sdata, bssid);
 
+	mutex_lock(&sdata->local->mtx);
 	ieee80211_recalc_idle(sdata->local);
+	mutex_unlock(&sdata->local->mtx);
 
 	return 0;
 }
@@ -2357,7 +2368,9 @@ int ieee80211_mgd_disassoc(struct ieee80
 			cookie, !req->local_state_change);
 	sta_info_destroy_addr(sdata, bssid);
 
+	mutex_lock(&sdata->local->mtx);
 	ieee80211_recalc_idle(sdata->local);
+	mutex_unlock(&sdata->local->mtx);
 
 	return 0;
 }
--- wireless-testing.orig/net/mac80211/ibss.c	2010-08-05 16:11:12.000000000 +0200
+++ wireless-testing/net/mac80211/ibss.c	2010-08-05 16:22:05.000000000 +0200
@@ -920,12 +920,14 @@ int ieee80211_ibss_join(struct ieee80211
 	memcpy(sdata->u.ibss.ssid, params->ssid, IEEE80211_MAX_SSID_LEN);
 	sdata->u.ibss.ssid_len = params->ssid_len;
 
+	mutex_unlock(&sdata->u.ibss.mtx);
+
+	mutex_lock(&sdata->local->mtx);
 	ieee80211_recalc_idle(sdata->local);
+	mutex_unlock(&sdata->local->mtx);
 
 	ieee80211_queue_work(&sdata->local->hw, &sdata->work);
 
-	mutex_unlock(&sdata->u.ibss.mtx);
-
 	return 0;
 }
 
@@ -980,7 +982,9 @@ int ieee80211_ibss_leave(struct ieee8021
 
 	mutex_unlock(&sdata->u.ibss.mtx);
 
+	mutex_lock(&local->mtx);
 	ieee80211_recalc_idle(sdata->local);
+	mutex_unlock(&local->mtx);
 
 	return 0;
 }


