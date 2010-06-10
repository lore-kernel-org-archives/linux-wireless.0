Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42749 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679Ab0FJI0D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jun 2010 04:26:03 -0400
Message-Id: <20100610082229.253761719@sipsolutions.net>
Date: Thu, 10 Jun 2010 10:21:31 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 03/23] mac80211: use common work struct
References: <20100610082128.641664439@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

IBSS, managed and mesh modes all have their
own work struct, and in the future we want
to also use it in other modes to process
frames from the now common skb queue.

This also makes the skb queue and work safe
to use from other interface types.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ibss.c         |   13 ++++++-------
 net/mac80211/ieee80211_i.h  |    4 +---
 net/mac80211/iface.c        |    6 ++----
 net/mac80211/mesh.c         |   22 +++++++++-------------
 net/mac80211/mesh_hwmp.c    |    4 ++--
 net/mac80211/mesh_pathtbl.c |    4 ++--
 net/mac80211/mlme.c         |   12 +++++-------
 net/mac80211/pm.c           |    2 ++
 8 files changed, 29 insertions(+), 38 deletions(-)

--- wireless-testing.orig/net/mac80211/ibss.c	2010-06-09 17:21:06.000000000 +0200
+++ wireless-testing/net/mac80211/ibss.c	2010-06-09 17:21:07.000000000 +0200
@@ -761,7 +761,7 @@ static void ieee80211_ibss_rx_queued_mgm
 static void ieee80211_ibss_work(struct work_struct *work)
 {
 	struct ieee80211_sub_if_data *sdata =
-		container_of(work, struct ieee80211_sub_if_data, u.ibss.work);
+		container_of(work, struct ieee80211_sub_if_data, work);
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_ibss *ifibss;
 	struct sk_buff *skb;
@@ -804,7 +804,7 @@ static void ieee80211_queue_ibss_work(st
 	struct ieee80211_local *local = sdata->local;
 
 	set_bit(IEEE80211_IBSS_REQ_RUN, &ifibss->request);
-	ieee80211_queue_work(&local->hw, &ifibss->work);
+	ieee80211_queue_work(&local->hw, &sdata->work);
 }
 
 static void ieee80211_ibss_timer(unsigned long data)
@@ -827,7 +827,6 @@ void ieee80211_ibss_quiesce(struct ieee8
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 
-	cancel_work_sync(&ifibss->work);
 	if (del_timer_sync(&ifibss->timer))
 		ifibss->timer_running = true;
 }
@@ -847,7 +846,7 @@ void ieee80211_ibss_setup_sdata(struct i
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 
-	INIT_WORK(&ifibss->work, ieee80211_ibss_work);
+	INIT_WORK(&sdata->work, ieee80211_ibss_work);
 	setup_timer(&ifibss->timer, ieee80211_ibss_timer,
 		    (unsigned long) sdata);
 }
@@ -890,7 +889,7 @@ ieee80211_ibss_rx_mgmt(struct ieee80211_
 	case IEEE80211_STYPE_PROBE_REQ:
 	case IEEE80211_STYPE_AUTH:
 		skb_queue_tail(&sdata->skb_queue, skb);
-		ieee80211_queue_work(&local->hw, &sdata->u.ibss.work);
+		ieee80211_queue_work(&local->hw, &sdata->work);
 		return RX_QUEUED;
 	}
 
@@ -956,7 +955,7 @@ int ieee80211_ibss_join(struct ieee80211
 	ieee80211_recalc_idle(sdata->local);
 
 	set_bit(IEEE80211_IBSS_REQ_RUN, &sdata->u.ibss.request);
-	ieee80211_queue_work(&sdata->local->hw, &sdata->u.ibss.work);
+	ieee80211_queue_work(&sdata->local->hw, &sdata->work);
 
 	return 0;
 }
@@ -967,7 +966,7 @@ int ieee80211_ibss_leave(struct ieee8021
 
 	del_timer_sync(&sdata->u.ibss.timer);
 	clear_bit(IEEE80211_IBSS_REQ_RUN, &sdata->u.ibss.request);
-	cancel_work_sync(&sdata->u.ibss.work);
+	cancel_work_sync(&sdata->work);
 	clear_bit(IEEE80211_IBSS_REQ_RUN, &sdata->u.ibss.request);
 
 	sta_info_flush(sdata->local, sdata);
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-06-09 17:21:06.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-06-09 17:21:07.000000000 +0200
@@ -325,7 +325,6 @@ struct ieee80211_if_managed {
 	struct timer_list conn_mon_timer;
 	struct timer_list bcn_mon_timer;
 	struct timer_list chswitch_timer;
-	struct work_struct work;
 	struct work_struct monitor_work;
 	struct work_struct chswitch_work;
 	struct work_struct beacon_connection_loss_work;
@@ -384,7 +383,6 @@ enum ieee80211_ibss_request {
 
 struct ieee80211_if_ibss {
 	struct timer_list timer;
-	struct work_struct work;
 
 	unsigned long request;
 	unsigned long last_scan_completed;
@@ -412,7 +410,6 @@ struct ieee80211_if_ibss {
 };
 
 struct ieee80211_if_mesh {
-	struct work_struct work;
 	struct timer_list housekeeping_timer;
 	struct timer_list mesh_path_timer;
 	struct timer_list mesh_path_root_timer;
@@ -512,6 +509,7 @@ struct ieee80211_sub_if_data {
 
 	u16 sequence_number;
 
+	struct work_struct work;
 	struct sk_buff_head skb_queue;
 
 	/*
--- wireless-testing.orig/net/mac80211/mlme.c	2010-06-09 17:21:06.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2010-06-09 17:21:07.000000000 +0200
@@ -1653,7 +1653,7 @@ ieee80211_rx_result ieee80211_sta_rx_mgm
 	case IEEE80211_STYPE_DISASSOC:
 	case IEEE80211_STYPE_ACTION:
 		skb_queue_tail(&sdata->skb_queue, skb);
-		ieee80211_queue_work(&local->hw, &sdata->u.mgd.work);
+		ieee80211_queue_work(&local->hw, &sdata->work);
 		return RX_QUEUED;
 	}
 
@@ -1816,13 +1816,13 @@ static void ieee80211_sta_timer(unsigned
 		return;
 	}
 
-	ieee80211_queue_work(&local->hw, &ifmgd->work);
+	ieee80211_queue_work(&local->hw, &sdata->work);
 }
 
 static void ieee80211_sta_work(struct work_struct *work)
 {
 	struct ieee80211_sub_if_data *sdata =
-		container_of(work, struct ieee80211_sub_if_data, u.mgd.work);
+		container_of(work, struct ieee80211_sub_if_data, work);
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd;
 	struct sk_buff *skb;
@@ -1943,8 +1943,7 @@ static void ieee80211_restart_sta_timer(
 		ieee80211_queue_work(&sdata->local->hw,
 			   &sdata->u.mgd.monitor_work);
 		/* and do all the other regular work too */
-		ieee80211_queue_work(&sdata->local->hw,
-			   &sdata->u.mgd.work);
+		ieee80211_queue_work(&sdata->local->hw, &sdata->work);
 	}
 }
 
@@ -1959,7 +1958,6 @@ void ieee80211_sta_quiesce(struct ieee80
 	 * time -- the code here is properly synchronised.
 	 */
 
-	cancel_work_sync(&ifmgd->work);
 	cancel_work_sync(&ifmgd->beacon_connection_loss_work);
 	if (del_timer_sync(&ifmgd->timer))
 		set_bit(TMR_RUNNING_TIMER, &ifmgd->timers_running);
@@ -1991,7 +1989,7 @@ void ieee80211_sta_setup_sdata(struct ie
 	struct ieee80211_if_managed *ifmgd;
 
 	ifmgd = &sdata->u.mgd;
-	INIT_WORK(&ifmgd->work, ieee80211_sta_work);
+	INIT_WORK(&sdata->work, ieee80211_sta_work);
 	INIT_WORK(&ifmgd->monitor_work, ieee80211_sta_monitor_work);
 	INIT_WORK(&ifmgd->chswitch_work, ieee80211_chswitch_work);
 	INIT_WORK(&ifmgd->beacon_connection_loss_work,
--- wireless-testing.orig/net/mac80211/iface.c	2010-06-09 17:21:06.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2010-06-09 17:21:07.000000000 +0200
@@ -460,17 +460,14 @@ static int ieee80211_stop(struct net_dev
 		 * whether the interface is running, which, at this point,
 		 * it no longer is.
 		 */
-		cancel_work_sync(&sdata->u.mgd.work);
 		cancel_work_sync(&sdata->u.mgd.chswitch_work);
 		cancel_work_sync(&sdata->u.mgd.monitor_work);
 		cancel_work_sync(&sdata->u.mgd.beacon_connection_loss_work);
 
 		/* fall through */
 	case NL80211_IFTYPE_ADHOC:
-		if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
+		if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
 			del_timer_sync(&sdata->u.ibss.timer);
-			cancel_work_sync(&sdata->u.ibss.work);
-		}
 		/* fall through */
 	case NL80211_IFTYPE_MESH_POINT:
 		if (ieee80211_vif_is_mesh(&sdata->vif)) {
@@ -485,6 +482,7 @@ static int ieee80211_stop(struct net_dev
 		}
 		/* fall through */
 	default:
+		cancel_work_sync(&sdata->work);
 		/*
 		 * When we get here, the interface is marked down.
 		 * Call synchronize_rcu() to wait for the RX path
--- wireless-testing.orig/net/mac80211/mesh.c	2010-06-09 17:21:06.000000000 +0200
+++ wireless-testing/net/mac80211/mesh.c	2010-06-09 17:21:07.000000000 +0200
@@ -54,7 +54,7 @@ static void ieee80211_mesh_housekeeping_
 		return;
 	}
 
-	ieee80211_queue_work(&local->hw, &ifmsh->work);
+	ieee80211_queue_work(&local->hw, &sdata->work);
 }
 
 /**
@@ -345,7 +345,7 @@ static void ieee80211_mesh_path_timer(un
 		return;
 	}
 
-	ieee80211_queue_work(&local->hw, &ifmsh->work);
+	ieee80211_queue_work(&local->hw, &sdata->work);
 }
 
 static void ieee80211_mesh_path_root_timer(unsigned long data)
@@ -362,7 +362,7 @@ static void ieee80211_mesh_path_root_tim
 		return;
 	}
 
-	ieee80211_queue_work(&local->hw, &ifmsh->work);
+	ieee80211_queue_work(&local->hw, &sdata->work);
 }
 
 void ieee80211_mesh_root_setup(struct ieee80211_if_mesh *ifmsh)
@@ -484,9 +484,6 @@ void ieee80211_mesh_quiesce(struct ieee8
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 
-	/* might restart the timer but that doesn't matter */
-	cancel_work_sync(&ifmsh->work);
-
 	/* use atomic bitops in case both timers fire at the same time */
 
 	if (del_timer_sync(&ifmsh->housekeeping_timer))
@@ -518,7 +515,7 @@ void ieee80211_start_mesh(struct ieee802
 
 	set_bit(MESH_WORK_HOUSEKEEPING, &ifmsh->wrkq_flags);
 	ieee80211_mesh_root_setup(ifmsh);
-	ieee80211_queue_work(&local->hw, &ifmsh->work);
+	ieee80211_queue_work(&local->hw, &sdata->work);
 	sdata->vif.bss_conf.beacon_int = MESH_DEFAULT_BEACON_INTERVAL;
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON |
 						BSS_CHANGED_BEACON_ENABLED |
@@ -536,7 +533,7 @@ void ieee80211_stop_mesh(struct ieee8021
 	 * whether the interface is running, which, at this point,
 	 * it no longer is.
 	 */
-	cancel_work_sync(&sdata->u.mesh.work);
+	cancel_work_sync(&sdata->work);
 }
 
 static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
@@ -630,7 +627,7 @@ static void ieee80211_mesh_rx_queued_mgm
 static void ieee80211_mesh_work(struct work_struct *work)
 {
 	struct ieee80211_sub_if_data *sdata =
-		container_of(work, struct ieee80211_sub_if_data, u.mesh.work);
+		container_of(work, struct ieee80211_sub_if_data, work);
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct sk_buff *skb;
@@ -669,7 +666,7 @@ void ieee80211_mesh_notify_scan_complete
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list)
 		if (ieee80211_vif_is_mesh(&sdata->vif))
-			ieee80211_queue_work(&local->hw, &sdata->u.mesh.work);
+			ieee80211_queue_work(&local->hw, &sdata->work);
 	rcu_read_unlock();
 }
 
@@ -677,7 +674,7 @@ void ieee80211_mesh_init_sdata(struct ie
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 
-	INIT_WORK(&ifmsh->work, ieee80211_mesh_work);
+	INIT_WORK(&sdata->work, ieee80211_mesh_work);
 	setup_timer(&ifmsh->housekeeping_timer,
 		    ieee80211_mesh_housekeeping_timer,
 		    (unsigned long) sdata);
@@ -726,7 +723,6 @@ ieee80211_rx_result
 ieee80211_mesh_rx_mgmt(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee80211_mgmt *mgmt;
 	u16 fc;
 
@@ -741,7 +737,7 @@ ieee80211_mesh_rx_mgmt(struct ieee80211_
 	case IEEE80211_STYPE_PROBE_RESP:
 	case IEEE80211_STYPE_BEACON:
 		skb_queue_tail(&sdata->skb_queue, skb);
-		ieee80211_queue_work(&local->hw, &ifmsh->work);
+		ieee80211_queue_work(&local->hw, &sdata->work);
 		return RX_QUEUED;
 	}
 
--- wireless-testing.orig/net/mac80211/mesh_hwmp.c	2010-06-09 17:20:51.000000000 +0200
+++ wireless-testing/net/mac80211/mesh_hwmp.c	2010-06-09 17:21:07.000000000 +0200
@@ -805,14 +805,14 @@ static void mesh_queue_preq(struct mesh_
 	spin_unlock(&ifmsh->mesh_preq_queue_lock);
 
 	if (time_after(jiffies, ifmsh->last_preq + min_preq_int_jiff(sdata)))
-		ieee80211_queue_work(&sdata->local->hw, &ifmsh->work);
+		ieee80211_queue_work(&sdata->local->hw, &sdata->work);
 
 	else if (time_before(jiffies, ifmsh->last_preq)) {
 		/* avoid long wait if did not send preqs for a long time
 		 * and jiffies wrapped around
 		 */
 		ifmsh->last_preq = jiffies - min_preq_int_jiff(sdata) - 1;
-		ieee80211_queue_work(&sdata->local->hw, &ifmsh->work);
+		ieee80211_queue_work(&sdata->local->hw, &sdata->work);
 	} else
 		mod_timer(&ifmsh->mesh_path_timer, ifmsh->last_preq +
 						min_preq_int_jiff(sdata));
--- wireless-testing.orig/net/mac80211/mesh_pathtbl.c	2010-06-09 17:20:51.000000000 +0200
+++ wireless-testing/net/mac80211/mesh_pathtbl.c	2010-06-09 17:21:07.000000000 +0200
@@ -315,7 +315,7 @@ int mesh_path_add(u8 *dst, struct ieee80
 	read_unlock(&pathtbl_resize_lock);
 	if (grow) {
 		set_bit(MESH_WORK_GROW_MPATH_TABLE,  &ifmsh->wrkq_flags);
-		ieee80211_queue_work(&local->hw, &ifmsh->work);
+		ieee80211_queue_work(&local->hw, &sdata->work);
 	}
 	return 0;
 
@@ -425,7 +425,7 @@ int mpp_path_add(u8 *dst, u8 *mpp, struc
 	read_unlock(&pathtbl_resize_lock);
 	if (grow) {
 		set_bit(MESH_WORK_GROW_MPP_TABLE,  &ifmsh->wrkq_flags);
-		ieee80211_queue_work(&local->hw, &ifmsh->work);
+		ieee80211_queue_work(&local->hw, &sdata->work);
 	}
 	return 0;
 
--- wireless-testing.orig/net/mac80211/pm.c	2010-06-09 17:21:05.000000000 +0200
+++ wireless-testing/net/mac80211/pm.c	2010-06-09 17:21:07.000000000 +0200
@@ -64,6 +64,8 @@ int __ieee80211_suspend(struct ieee80211
 
 	/* remove all interfaces */
 	list_for_each_entry(sdata, &local->interfaces, list) {
+		cancel_work_sync(&sdata->work);
+
 		switch(sdata->vif.type) {
 		case NL80211_IFTYPE_STATION:
 			ieee80211_sta_quiesce(sdata);


