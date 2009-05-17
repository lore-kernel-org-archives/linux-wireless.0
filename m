Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53122 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbZEQJkt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2009 05:40:49 -0400
Subject: [PATCH v2] mac80211: cancel/restart all timers across
 suspend/resume
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1242391067.5799.53.camel@johannes.local>
References: <1242391067.5799.53.camel@johannes.local>
Content-Type: text/plain
Date: Sun, 17 May 2009 11:40:42 +0200
Message-Id: <1242553242.10005.76.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We forgot to cancel all timers in mac80211 when suspending.
In particular we forgot to deal with some things that can
cause hardware reconfiguration -- while it is down.

While at it we go ahead and add a warning in ieee80211_sta_work()
if its run while the suspend->resume cycle is in effect. This
should not happen and if it does it would indicate there is
a bug lurking in either mac80211 or mac80211 drivers.

With this now wpa_supplicant doesn't blink when I go to suspend
and resume where as before there where issues with some timers
running during the suspend->resume cycle. This caused a lot of
incorrect assumptions and would at times bring back the device
in an incoherent, but mostly recoverable, state.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
v2: fix bit number confusion Luis found

 net/mac80211/ibss.c        |   29 ++++++++++++++++
 net/mac80211/ieee80211_i.h |   26 ++++++++++++++
 net/mac80211/mesh.c        |   40 ++++++++++++++++++++++
 net/mac80211/mesh.h        |   12 ++++++
 net/mac80211/mesh_hwmp.c   |    8 +++-
 net/mac80211/mesh_plink.c  |   21 +++++++++++
 net/mac80211/mlme.c        |   59 +++++++++++++++++++++++++++++++++
 net/mac80211/pm.c          |   80 ++++++++++++++++++++++++++++++++++-----------
 net/mac80211/scan.c        |   18 ++++++++++
 net/mac80211/sta_info.c    |    3 +
 net/mac80211/sta_info.h    |    1 
 net/mac80211/util.c        |   43 ++++++++++++++++++++++++
 12 files changed, 321 insertions(+), 19 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-05-15 12:43:11.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-05-17 11:39:47.000000000 +0200
@@ -293,6 +293,7 @@ struct ieee80211_if_managed {
 	int auth_tries; /* retries for auth req */
 	int assoc_tries; /* retries for assoc req */
 
+	unsigned long timers_running; /* used for quiesce/restart */
 	bool powersave; /* powersave requested for this iface */
 
 	unsigned long request;
@@ -333,6 +334,9 @@ struct ieee80211_if_ibss {
 
 	unsigned long request;
 	unsigned long last_scan_completed;
+
+	bool timer_running;
+
 	bool fixed_bssid;
 	bool fixed_channel;
 
@@ -358,6 +362,8 @@ struct ieee80211_if_mesh {
 	struct timer_list mesh_path_timer;
 	struct sk_buff_head skb_queue;
 
+	unsigned long timers_running;
+
 	bool housekeeping;
 
 	u8 mesh_id[IEEE80211_MAX_MESH_ID_LEN];
@@ -609,6 +615,21 @@ struct ieee80211_local {
 	unsigned int filter_flags; /* FIF_* */
 	struct iw_statistics wstats;
 	bool tim_in_locked_section; /* see ieee80211_beacon_get() */
+
+	/*
+	 * suspended is true if we finished all the suspend _and_ we have
+	 * not yet come up from resume. This is to be used by mac80211
+	 * to ensure driver sanity during suspend and mac80211's own
+	 * sanity. It can eventually be used for WoW as well.
+	 */
+	bool suspended;
+
+	/*
+	 * quiescing is true during the suspend process _only_ to
+	 * ease timer cancelling etc.
+	 */
+	bool quiescing;
+
 	int tx_headroom; /* required headroom for hardware/radiotap */
 
 	/* Tasklet and skb queue to process calls from IRQ mode. All frames
@@ -941,6 +962,8 @@ int ieee80211_max_network_latency(struct
 void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 				      struct ieee80211_channel_sw_ie *sw_elem,
 				      struct ieee80211_bss *bss);
+void ieee80211_sta_quiesce(struct ieee80211_sub_if_data *sdata);
+void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata);
 
 /* IBSS code */
 void ieee80211_ibss_notify_scan_completed(struct ieee80211_local *local);
@@ -953,6 +976,8 @@ struct sta_info *ieee80211_ibss_add_sta(
 int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 			struct cfg80211_ibss_params *params);
 int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata);
+void ieee80211_ibss_quiesce(struct ieee80211_sub_if_data *sdata);
+void ieee80211_ibss_restart(struct ieee80211_sub_if_data *sdata);
 
 /* scan/BSS handling */
 void ieee80211_scan_work(struct work_struct *work);
@@ -963,6 +988,7 @@ int ieee80211_request_scan(struct ieee80
 int ieee80211_scan_results(struct ieee80211_local *local,
 			   struct iw_request_info *info,
 			   char *buf, size_t len);
+void ieee80211_scan_cancel(struct ieee80211_local *local);
 ieee80211_rx_result
 ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata,
 		  struct sk_buff *skb,
--- wireless-testing.orig/net/mac80211/mlme.c	2009-05-15 12:43:11.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-05-17 11:39:57.000000000 +0200
@@ -37,6 +37,9 @@
 #define IEEE80211_PROBE_IDLE_TIME (60 * HZ)
 #define IEEE80211_RETRY_AUTH_INTERVAL (1 * HZ)
 
+#define TMR_RUNNING_TIMER	0
+#define TMR_RUNNING_CHANSW	1
+
 /* utils */
 static int ecw2cw(int ecw)
 {
@@ -517,6 +520,11 @@ static void ieee80211_chswitch_timer(uns
 		(struct ieee80211_sub_if_data *) data;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
+	if (sdata->local->quiescing) {
+		set_bit(TMR_RUNNING_CHANSW, &ifmgd->timers_running);
+		return;
+	}
+
 	queue_work(sdata->local->hw.workqueue, &ifmgd->chswitch_work);
 }
 
@@ -710,6 +718,9 @@ void ieee80211_dynamic_ps_timer(unsigned
 {
 	struct ieee80211_local *local = (void *) data;
 
+	if (local->quiescing)
+		return;
+
 	queue_work(local->hw.workqueue, &local->dynamic_ps_enable_work);
 }
 
@@ -2101,6 +2112,11 @@ static void ieee80211_sta_timer(unsigned
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
 
+	if (local->quiescing) {
+		set_bit(TMR_RUNNING_TIMER, &ifmgd->timers_running);
+		return;
+	}
+
 	set_bit(IEEE80211_STA_REQ_RUN, &ifmgd->request);
 	queue_work(local->hw.workqueue, &ifmgd->work);
 }
@@ -2233,6 +2249,17 @@ static void ieee80211_sta_work(struct wo
 
 	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_STATION))
 		return;
+
+	/*
+	 * Nothing should have been stuffed into the workqueue during
+	 * the suspend->resume cycle. If this WARN is seen then there
+	 * is a bug with either the driver suspend or something in
+	 * mac80211 stuffing into the workqueue which we haven't yet
+	 * cleared during mac80211's suspend cycle.
+	 */
+	if (WARN_ON(local->suspended))
+		return;
+
 	ifmgd = &sdata->u.mgd;
 
 	while ((skb = skb_dequeue(&ifmgd->skb_queue)))
@@ -2300,6 +2327,38 @@ static void ieee80211_restart_sta_timer(
 	}
 }
 
+#ifdef CONFIG_PM
+void ieee80211_sta_quiesce(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+
+	/*
+	 * we need to use atomic bitops for the running bits
+	 * only because both timers might fire at the same
+	 * time -- the code here is properly synchronised.
+	 */
+
+	cancel_work_sync(&ifmgd->work);
+	cancel_work_sync(&ifmgd->beacon_loss_work);
+	if (del_timer_sync(&ifmgd->timer))
+		set_bit(TMR_RUNNING_TIMER, &ifmgd->timers_running);
+
+	cancel_work_sync(&ifmgd->chswitch_work);
+	if (del_timer_sync(&ifmgd->chswitch_timer))
+		set_bit(TMR_RUNNING_CHANSW, &ifmgd->timers_running);
+}
+
+void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+
+	if (test_and_clear_bit(TMR_RUNNING_TIMER, &ifmgd->timers_running))
+		add_timer(&ifmgd->timer);
+	if (test_and_clear_bit(TMR_RUNNING_CHANSW, &ifmgd->timers_running))
+		add_timer(&ifmgd->chswitch_timer);
+}
+#endif
+
 /* interface setup */
 void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
 {
--- wireless-testing.orig/net/mac80211/pm.c	2009-05-15 12:42:57.000000000 +0200
+++ wireless-testing/net/mac80211/pm.c	2009-05-17 11:39:47.000000000 +0200
@@ -2,6 +2,7 @@
 #include <net/rtnetlink.h>
 
 #include "ieee80211_i.h"
+#include "mesh.h"
 #include "driver-ops.h"
 #include "led.h"
 
@@ -13,11 +14,30 @@ int __ieee80211_suspend(struct ieee80211
 	struct sta_info *sta;
 	unsigned long flags;
 
+	ieee80211_scan_cancel(local);
+
 	ieee80211_stop_queues_by_reason(hw,
 			IEEE80211_QUEUE_STOP_REASON_SUSPEND);
 
+	/* flush out all packets */
+	synchronize_net();
+
+	local->quiescing = true;
+	/* make quiescing visible to timers everywhere */
+	mb();
+
 	flush_workqueue(local->hw.workqueue);
 
+	/* Don't try to run timers while suspended. */
+	del_timer_sync(&local->sta_cleanup);
+
+	 /*
+	 * Note that this particular timer doesn't need to be
+	 * restarted at resume.
+	 */
+	cancel_work_sync(&local->dynamic_ps_enable_work);
+	del_timer_sync(&local->dynamic_ps_timer);
+
 	/* disable keys */
 	list_for_each_entry(sdata, &local->interfaces, list)
 		ieee80211_disable_keys(sdata);
@@ -35,10 +55,20 @@ int __ieee80211_suspend(struct ieee80211
 
 	rcu_read_unlock();
 
+	/* flush again, in case driver queued work */
+	flush_workqueue(local->hw.workqueue);
+
+	/* stop hardware - this must stop RX */
+	if (local->open_count) {
+		ieee80211_led_radio(local, false);
+		drv_stop(local);
+	}
+
 	/* remove STAs */
-	if (local->ops->sta_notify) {
-		spin_lock_irqsave(&local->sta_lock, flags);
-		list_for_each_entry(sta, &local->sta_list, list) {
+	spin_lock_irqsave(&local->sta_lock, flags);
+	list_for_each_entry(sta, &local->sta_list, list) {
+		if (local->ops->sta_notify) {
+			sdata = sta->sdata;
 			if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 				sdata = container_of(sdata->bss,
 					     struct ieee80211_sub_if_data,
@@ -47,29 +77,43 @@ int __ieee80211_suspend(struct ieee80211
 			drv_sta_notify(local, &sdata->vif, STA_NOTIFY_REMOVE,
 				       &sta->sta);
 		}
-		spin_unlock_irqrestore(&local->sta_lock, flags);
+
+		mesh_plink_quiesce(sta);
 	}
+	spin_unlock_irqrestore(&local->sta_lock, flags);
 
 	/* remove all interfaces */
 	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
-		    sdata->vif.type != NL80211_IFTYPE_MONITOR &&
-		    netif_running(sdata->dev)) {
-			conf.vif = &sdata->vif;
-			conf.type = sdata->vif.type;
-			conf.mac_addr = sdata->dev->dev_addr;
-			drv_remove_interface(local, &conf);
+		switch(sdata->vif.type) {
+		case NL80211_IFTYPE_STATION:
+			ieee80211_sta_quiesce(sdata);
+			break;
+		case NL80211_IFTYPE_ADHOC:
+			ieee80211_ibss_quiesce(sdata);
+			break;
+		case NL80211_IFTYPE_MESH_POINT:
+			ieee80211_mesh_quiesce(sdata);
+			break;
+		case NL80211_IFTYPE_AP_VLAN:
+		case NL80211_IFTYPE_MONITOR:
+			/* don't tell driver about this */
+			continue;
+		default:
+			break;
 		}
-	}
 
-	/* flush again, in case driver queued work */
-	flush_workqueue(local->hw.workqueue);
+		if (!netif_running(sdata->dev))
+			continue;
 
-	/* stop hardware */
-	if (local->open_count) {
-		ieee80211_led_radio(local, false);
-		drv_stop(local);
+		conf.vif = &sdata->vif;
+		conf.type = sdata->vif.type;
+		conf.mac_addr = sdata->dev->dev_addr;
+		drv_remove_interface(local, &conf);
 	}
+
+	local->suspended = true;
+	local->quiescing = false;
+
 	return 0;
 }
 
--- wireless-testing.orig/net/mac80211/util.c	2009-05-15 12:42:57.000000000 +0200
+++ wireless-testing/net/mac80211/util.c	2009-05-17 11:39:47.000000000 +0200
@@ -1034,6 +1034,13 @@ int ieee80211_reconfig(struct ieee80211_
 	struct sta_info *sta;
 	unsigned long flags;
 	int res;
+	bool from_suspend = local->suspended;
+
+	/*
+	 * We're going to start the hardware, at that point
+	 * we are no longer suspended and can RX frames.
+	 */
+	local->suspended = false;
 
 	/* restart hardware */
 	if (local->open_count) {
@@ -1058,6 +1065,7 @@ int ieee80211_reconfig(struct ieee80211_
 	if (local->ops->sta_notify) {
 		spin_lock_irqsave(&local->sta_lock, flags);
 		list_for_each_entry(sta, &local->sta_list, list) {
+			sdata = sta->sdata;
 			if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 				sdata = container_of(sdata->bss,
 					     struct ieee80211_sub_if_data,
@@ -1128,5 +1136,40 @@ int ieee80211_reconfig(struct ieee80211_
 	ieee80211_wake_queues_by_reason(hw,
 			IEEE80211_QUEUE_STOP_REASON_SUSPEND);
 
+	/*
+	 * If this is for hw restart things are still running.
+	 * We may want to change that later, however.
+	 */
+	if (!from_suspend)
+		return 0;
+
+#ifdef CONFIG_PM
+	local->suspended = false;
+
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		switch(sdata->vif.type) {
+		case NL80211_IFTYPE_STATION:
+			ieee80211_sta_restart(sdata);
+			break;
+		case NL80211_IFTYPE_ADHOC:
+			ieee80211_ibss_restart(sdata);
+			break;
+		case NL80211_IFTYPE_MESH_POINT:
+			ieee80211_mesh_restart(sdata);
+			break;
+		default:
+			break;
+		}
+	}
+
+	add_timer(&local->sta_cleanup);
+
+	spin_lock_irqsave(&local->sta_lock, flags);
+	list_for_each_entry(sta, &local->sta_list, list)
+		mesh_plink_restart(sta);
+	spin_unlock_irqrestore(&local->sta_lock, flags);
+#else
+	WARN_ON(1);
+#endif
 	return 0;
 }
--- wireless-testing.orig/net/mac80211/ibss.c	2009-05-15 12:42:57.000000000 +0200
+++ wireless-testing/net/mac80211/ibss.c	2009-05-15 12:43:11.000000000 +0200
@@ -737,6 +737,9 @@ static void ieee80211_ibss_work(struct w
 	struct ieee80211_if_ibss *ifibss;
 	struct sk_buff *skb;
 
+	if (WARN_ON(local->suspended))
+		return;
+
 	if (!netif_running(sdata->dev))
 		return;
 
@@ -773,10 +776,36 @@ static void ieee80211_ibss_timer(unsigne
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct ieee80211_local *local = sdata->local;
 
+	if (local->quiescing) {
+		ifibss->timer_running = true;
+		return;
+	}
+
 	set_bit(IEEE80211_IBSS_REQ_RUN, &ifibss->request);
 	queue_work(local->hw.workqueue, &ifibss->work);
 }
 
+#ifdef CONFIG_PM
+void ieee80211_ibss_quiesce(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+
+	cancel_work_sync(&ifibss->work);
+	if (del_timer_sync(&ifibss->timer))
+		ifibss->timer_running = true;
+}
+
+void ieee80211_ibss_restart(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+
+	if (ifibss->timer_running) {
+		add_timer(&ifibss->timer);
+		ifibss->timer_running = false;
+	}
+}
+#endif
+
 void ieee80211_ibss_setup_sdata(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
--- wireless-testing.orig/net/mac80211/mesh.h	2009-05-15 12:42:57.000000000 +0200
+++ wireless-testing/net/mac80211/mesh.h	2009-05-15 12:43:11.000000000 +0200
@@ -267,6 +267,8 @@ void mesh_path_timer(unsigned long data)
 void mesh_path_flush_by_nexthop(struct sta_info *sta);
 void mesh_path_discard_frame(struct sk_buff *skb,
 		struct ieee80211_sub_if_data *sdata);
+void mesh_path_quiesce(struct ieee80211_sub_if_data *sdata);
+void mesh_path_restart(struct ieee80211_sub_if_data *sdata);
 
 #ifdef CONFIG_MAC80211_MESH
 extern int mesh_allocated;
@@ -294,10 +296,20 @@ static inline void mesh_path_activate(st
 
 void ieee80211_mesh_notify_scan_completed(struct ieee80211_local *local);
 
+void ieee80211_mesh_quiesce(struct ieee80211_sub_if_data *sdata);
+void ieee80211_mesh_restart(struct ieee80211_sub_if_data *sdata);
+void mesh_plink_quiesce(struct sta_info *sta);
+void mesh_plink_restart(struct sta_info *sta);
 #else
 #define mesh_allocated	0
 static inline void
 ieee80211_mesh_notify_scan_completed(struct ieee80211_local *local) {}
+static inline void ieee80211_mesh_quiesce(struct ieee80211_sub_if_data *sdata)
+{}
+static inline void ieee80211_mesh_restart(struct ieee80211_sub_if_data *sdata)
+{}
+static inline void mesh_plink_quiesce(struct sta_info *sta) {}
+static inline void mesh_plink_restart(struct sta_info *sta) {}
 #endif
 
 #endif /* IEEE80211S_H */
--- wireless-testing.orig/net/mac80211/mesh.c	2009-05-15 12:42:57.000000000 +0200
+++ wireless-testing/net/mac80211/mesh.c	2009-05-15 12:43:11.000000000 +0200
@@ -21,6 +21,9 @@
 #define CAPAB_OFFSET 17
 #define ACCEPT_PLINKS 0x80
 
+#define TMR_RUNNING_HK	0
+#define TMR_RUNNING_MP	1
+
 int mesh_allocated;
 static struct kmem_cache *rm_cache;
 
@@ -45,6 +48,12 @@ static void ieee80211_mesh_housekeeping_
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 
 	ifmsh->housekeeping = true;
+
+	if (local->quiescing) {
+		set_bit(TMR_RUNNING_HK, &ifmsh->timers_running);
+		return;
+	}
+
 	queue_work(local->hw.workqueue, &ifmsh->work);
 }
 
@@ -343,6 +352,11 @@ static void ieee80211_mesh_path_timer(un
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee80211_local *local = sdata->local;
 
+	if (local->quiescing) {
+		set_bit(TMR_RUNNING_MP, &ifmsh->timers_running);
+		return;
+	}
+
 	queue_work(local->hw.workqueue, &ifmsh->work);
 }
 
@@ -424,6 +438,32 @@ static void ieee80211_mesh_housekeeping(
 		  round_jiffies(jiffies + IEEE80211_MESH_HOUSEKEEPING_INTERVAL));
 }
 
+#ifdef CONFIG_PM
+void ieee80211_mesh_quiesce(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+
+	/* might restart the timer but that doesn't matter */
+	cancel_work_sync(&ifmsh->work);
+
+	/* use atomic bitops in case both timers fire at the same time */
+
+	if (del_timer_sync(&ifmsh->housekeeping_timer))
+		set_bit(TMR_RUNNING_HK, &ifmsh->timers_running);
+	if (del_timer_sync(&ifmsh->mesh_path_timer))
+		set_bit(TMR_RUNNING_MP, &ifmsh->timers_running);
+}
+
+void ieee80211_mesh_restart(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+
+	if (test_and_clear_bit(TMR_RUNNING_HK, &ifmsh->timers_running))
+		add_timer(&ifmsh->housekeeping_timer);
+	if (test_and_clear_bit(TMR_RUNNING_MP, &ifmsh->timers_running))
+		add_timer(&ifmsh->mesh_path_timer);
+}
+#endif
 
 void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 {
--- wireless-testing.orig/net/mac80211/scan.c	2009-05-15 12:42:56.000000000 +0200
+++ wireless-testing/net/mac80211/scan.c	2009-05-15 12:43:11.000000000 +0200
@@ -631,3 +631,21 @@ int ieee80211_request_internal_scan(stru
 	mutex_unlock(&local->scan_mtx);
 	return ret;
 }
+
+void ieee80211_scan_cancel(struct ieee80211_local *local)
+{
+	bool swscan;
+
+	cancel_delayed_work_sync(&local->scan_work);
+
+	/*
+	 * Only call this function when a scan can't be
+	 * queued -- mostly at suspend under RTNL.
+	 */
+	mutex_lock(&local->scan_mtx);
+	swscan = local->sw_scanning;
+	mutex_unlock(&local->scan_mtx);
+
+	if (swscan)
+		ieee80211_scan_completed(&local->hw, true);
+}
--- wireless-testing.orig/net/mac80211/sta_info.c	2009-05-15 12:42:57.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.c	2009-05-15 12:43:11.000000000 +0200
@@ -608,6 +608,9 @@ static void sta_info_cleanup(unsigned lo
 		sta_info_cleanup_expire_buffered(local, sta);
 	rcu_read_unlock();
 
+	if (local->quiescing)
+		return;
+
 	local->sta_cleanup.expires =
 		round_jiffies(jiffies + STA_INFO_CLEANUP_INTERVAL);
 	add_timer(&local->sta_cleanup);
--- wireless-testing.orig/net/mac80211/mesh_plink.c	2009-05-15 12:42:56.000000000 +0200
+++ wireless-testing/net/mac80211/mesh_plink.c	2009-05-15 12:43:11.000000000 +0200
@@ -266,6 +266,11 @@ static void mesh_plink_timer(unsigned lo
 	 */
 	sta = (struct sta_info *) data;
 
+	if (sta->sdata->local->quiescing) {
+		sta->plink_timer_was_running = true;
+		return;
+	}
+
 	spin_lock_bh(&sta->lock);
 	if (sta->ignore_plink_timer) {
 		sta->ignore_plink_timer = false;
@@ -322,6 +327,22 @@ static void mesh_plink_timer(unsigned lo
 	}
 }
 
+#ifdef CONFIG_PM
+void mesh_plink_quiesce(struct sta_info *sta)
+{
+	if (del_timer_sync(&sta->plink_timer))
+		sta->plink_timer_was_running = true;
+}
+
+void mesh_plink_restart(struct sta_info *sta)
+{
+	if (sta->plink_timer_was_running) {
+		add_timer(&sta->plink_timer);
+		sta->plink_timer_was_running = false;
+	}
+}
+#endif
+
 static inline void mesh_plink_timer_set(struct sta_info *sta, int timeout)
 {
 	sta->plink_timer.expires = jiffies + (HZ * timeout / 1000);
--- wireless-testing.orig/net/mac80211/sta_info.h	2009-05-15 12:42:57.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.h	2009-05-15 12:43:11.000000000 +0200
@@ -293,6 +293,7 @@ struct sta_info {
 	__le16 reason;
 	u8 plink_retries;
 	bool ignore_plink_timer;
+	bool plink_timer_was_running;
 	enum plink_state plink_state;
 	u32 plink_timeout;
 	struct timer_list plink_timer;
--- wireless-testing.orig/net/mac80211/mesh_hwmp.c	2009-05-15 12:42:57.000000000 +0200
+++ wireless-testing/net/mac80211/mesh_hwmp.c	2009-05-15 12:43:11.000000000 +0200
@@ -836,8 +836,14 @@ void mesh_path_timer(unsigned long data)
 	mpath = rcu_dereference(mpath);
 	if (!mpath)
 		goto endmpathtimer;
-	spin_lock_bh(&mpath->state_lock);
 	sdata = mpath->sdata;
+
+	if (sdata->local->quiescing) {
+		rcu_read_unlock();
+		return;
+	}
+
+	spin_lock_bh(&mpath->state_lock);
 	if (mpath->flags & MESH_PATH_RESOLVED ||
 			(!(mpath->flags & MESH_PATH_RESOLVING)))
 		mpath->flags &= ~(MESH_PATH_RESOLVING | MESH_PATH_RESOLVED);


