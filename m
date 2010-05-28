Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60660 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555Ab0E1S5i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 May 2010 14:57:38 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.71)
	(envelope-from <johannes@sipsolutions.net>)
	id 1OI4kS-00047v-WE
	for linux-wireless@vger.kernel.org; Fri, 28 May 2010 20:57:37 +0200
Message-Id: <20100528185505.006300120@sipsolutions.net>
Date: Fri, 28 May 2010 20:53:05 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 3/7] mac80211: use common work struct
References: <20100528185302.639535282@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

IBSS, managed and mesh modes all have their
own work struct, and in the future we want
to also use it in other modes to process
frames from the now common skb queue.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ibss.c         |   14 +++++++-------
 net/mac80211/ieee80211_i.h  |    4 +---
 net/mac80211/iface.c        |    4 ++--
 net/mac80211/mesh.c         |   21 ++++++++++-----------
 net/mac80211/mesh_hwmp.c    |    4 ++--
 net/mac80211/mesh_pathtbl.c |    4 ++--
 net/mac80211/mlme.c         |   13 ++++++-------
 7 files changed, 30 insertions(+), 34 deletions(-)

--- wireless-testing.orig/net/mac80211/ibss.c	2010-05-28 20:36:59.000000000 +0200
+++ wireless-testing/net/mac80211/ibss.c	2010-05-28 20:37:06.000000000 +0200
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
@@ -827,7 +827,7 @@ void ieee80211_ibss_quiesce(struct ieee8
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 
-	cancel_work_sync(&ifibss->work);
+	cancel_work_sync(&sdata->work);
 	if (del_timer_sync(&ifibss->timer))
 		ifibss->timer_running = true;
 }
@@ -847,7 +847,7 @@ void ieee80211_ibss_setup_sdata(struct i
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 
-	INIT_WORK(&ifibss->work, ieee80211_ibss_work);
+	INIT_WORK(&sdata->work, ieee80211_ibss_work);
 	setup_timer(&ifibss->timer, ieee80211_ibss_timer,
 		    (unsigned long) sdata);
 }
@@ -890,7 +890,7 @@ ieee80211_ibss_rx_mgmt(struct ieee80211_
 	case IEEE80211_STYPE_PROBE_REQ:
 	case IEEE80211_STYPE_AUTH:
 		skb_queue_tail(&sdata->skb_queue, skb);
-		ieee80211_queue_work(&local->hw, &sdata->u.ibss.work);
+		ieee80211_queue_work(&local->hw, &sdata->work);
 		return RX_QUEUED;
 	}
 
@@ -956,7 +956,7 @@ int ieee80211_ibss_join(struct ieee80211
 	ieee80211_recalc_idle(sdata->local);
 
 	set_bit(IEEE80211_IBSS_REQ_RUN, &sdata->u.ibss.request);
-	ieee80211_queue_work(&sdata->local->hw, &sdata->u.ibss.work);
+	ieee80211_queue_work(&sdata->local->hw, &sdata->work);
 
 	return 0;
 }
@@ -967,7 +967,7 @@ int ieee80211_ibss_leave(struct ieee8021
 
 	del_timer_sync(&sdata->u.ibss.timer);
 	clear_bit(IEEE80211_IBSS_REQ_RUN, &sdata->u.ibss.request);
-	cancel_work_sync(&sdata->u.ibss.work);
+	cancel_work_sync(&sdata->work);
 	clear_bit(IEEE80211_IBSS_REQ_RUN, &sdata->u.ibss.request);
 
 	sta_info_flush(sdata->local, sdata);
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-05-28 20:36:59.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-05-28 20:37:06.000000000 +0200
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
--- wireless-testing.orig/net/mac80211/mlme.c	2010-05-28 20:36:59.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2010-05-28 20:37:06.000000000 +0200
@@ -1653,7 +1653,7 @@ ieee80211_rx_result ieee80211_sta_rx_mgm
 	case IEEE80211_STYPE_DISASSOC:
 	case IEEE80211_STYPE_ACTION:
 		skb_queue_tail(&sdata->skb_queue, skb);
-		ieee80211_queue_work(&local->hw, &sdata->u.mgd.work);
+		ieee80211_queue_work(&local->hw, &sdata->work);
 		return RX_QUEUED;
 	}
 
@@ -1779,13 +1779,13 @@ static void ieee80211_sta_timer(unsigned
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
@@ -1906,8 +1906,7 @@ static void ieee80211_restart_sta_timer(
 		ieee80211_queue_work(&sdata->local->hw,
 			   &sdata->u.mgd.monitor_work);
 		/* and do all the other regular work too */
-		ieee80211_queue_work(&sdata->local->hw,
-			   &sdata->u.mgd.work);
+		ieee80211_queue_work(&sdata->local->hw, &sdata->work);
 	}
 }
 
@@ -1922,7 +1921,7 @@ void ieee80211_sta_quiesce(struct ieee80
 	 * time -- the code here is properly synchronised.
 	 */
 
-	cancel_work_sync(&ifmgd->work);
+	cancel_work_sync(&sdata->work);
 	cancel_work_sync(&ifmgd->beacon_connection_loss_work);
 	if (del_timer_sync(&ifmgd->timer))
 		set_bit(TMR_RUNNING_TIMER, &ifmgd->timers_running);
@@ -1954,7 +1953,7 @@ void ieee80211_sta_setup_sdata(struct ie
 	struct ieee80211_if_managed *ifmgd;
 
 	ifmgd = &sdata->u.mgd;
-	INIT_WORK(&ifmgd->work, ieee80211_sta_work);
+	INIT_WORK(&sdata->work, ieee80211_sta_work);
 	INIT_WORK(&ifmgd->monitor_work, ieee80211_sta_monitor_work);
 	INIT_WORK(&ifmgd->chswitch_work, ieee80211_chswitch_work);
 	INIT_WORK(&ifmgd->beacon_connection_loss_work,
--- wireless-testing.orig/net/mac80211/iface.c	2010-05-28 20:36:59.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2010-05-28 20:37:06.000000000 +0200
@@ -461,7 +461,7 @@ static int ieee80211_stop(struct net_dev
 		 * whether the interface is running, which, at this point,
 		 * it no longer is.
 		 */
-		cancel_work_sync(&sdata->u.mgd.work);
+		cancel_work_sync(&sdata->work);
 		cancel_work_sync(&sdata->u.mgd.chswitch_work);
 		cancel_work_sync(&sdata->u.mgd.monitor_work);
 		cancel_work_sync(&sdata->u.mgd.beacon_connection_loss_work);
@@ -470,7 +470,7 @@ static int ieee80211_stop(struct net_dev
 	case NL80211_IFTYPE_ADHOC:
 		if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
 			del_timer_sync(&sdata->u.ibss.timer);
-			cancel_work_sync(&sdata->u.ibss.work);
+			cancel_work_sync(&sdata->work);
 		}
 		/* fall through */
 	case NL80211_IFTYPE_MESH_POINT:
--- wireless-testing.orig/net/mac80211/mesh.c	2010-05-28 20:36:59.000000000 +0200
+++ wireless-testing/net/mac80211/mesh.c	2010-05-28 20:37:06.000000000 +0200
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
@@ -485,7 +485,7 @@ void ieee80211_mesh_quiesce(struct ieee8
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 
 	/* might restart the timer but that doesn't matter */
-	cancel_work_sync(&ifmsh->work);
+	cancel_work_sync(&sdata->work);
 
 	/* use atomic bitops in case both timers fire at the same time */
 
@@ -518,7 +518,7 @@ void ieee80211_start_mesh(struct ieee802
 
 	set_bit(MESH_WORK_HOUSEKEEPING, &ifmsh->wrkq_flags);
 	ieee80211_mesh_root_setup(ifmsh);
-	ieee80211_queue_work(&local->hw, &ifmsh->work);
+	ieee80211_queue_work(&local->hw, &sdata->work);
 	sdata->vif.bss_conf.beacon_int = MESH_DEFAULT_BEACON_INTERVAL;
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON |
 						BSS_CHANGED_BEACON_ENABLED |
@@ -536,7 +536,7 @@ void ieee80211_stop_mesh(struct ieee8021
 	 * whether the interface is running, which, at this point,
 	 * it no longer is.
 	 */
-	cancel_work_sync(&sdata->u.mesh.work);
+	cancel_work_sync(&sdata->work);
 }
 
 static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
@@ -630,7 +630,7 @@ static void ieee80211_mesh_rx_queued_mgm
 static void ieee80211_mesh_work(struct work_struct *work)
 {
 	struct ieee80211_sub_if_data *sdata =
-		container_of(work, struct ieee80211_sub_if_data, u.mesh.work);
+		container_of(work, struct ieee80211_sub_if_data, work);
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct sk_buff *skb;
@@ -669,7 +669,7 @@ void ieee80211_mesh_notify_scan_complete
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list)
 		if (ieee80211_vif_is_mesh(&sdata->vif))
-			ieee80211_queue_work(&local->hw, &sdata->u.mesh.work);
+			ieee80211_queue_work(&local->hw, &sdata->work);
 	rcu_read_unlock();
 }
 
@@ -677,7 +677,7 @@ void ieee80211_mesh_init_sdata(struct ie
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 
-	INIT_WORK(&ifmsh->work, ieee80211_mesh_work);
+	INIT_WORK(&sdata->work, ieee80211_mesh_work);
 	setup_timer(&ifmsh->housekeeping_timer,
 		    ieee80211_mesh_housekeeping_timer,
 		    (unsigned long) sdata);
@@ -726,7 +726,6 @@ ieee80211_rx_result
 ieee80211_mesh_rx_mgmt(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee80211_mgmt *mgmt;
 	u16 fc;
 
@@ -741,7 +740,7 @@ ieee80211_mesh_rx_mgmt(struct ieee80211_
 	case IEEE80211_STYPE_PROBE_RESP:
 	case IEEE80211_STYPE_BEACON:
 		skb_queue_tail(&sdata->skb_queue, skb);
-		ieee80211_queue_work(&local->hw, &ifmsh->work);
+		ieee80211_queue_work(&local->hw, &sdata->work);
 		return RX_QUEUED;
 	}
 
--- wireless-testing.orig/net/mac80211/mesh_hwmp.c	2010-05-28 20:35:59.000000000 +0200
+++ wireless-testing/net/mac80211/mesh_hwmp.c	2010-05-28 20:37:06.000000000 +0200
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
--- wireless-testing.orig/net/mac80211/mesh_pathtbl.c	2010-05-28 20:35:59.000000000 +0200
+++ wireless-testing/net/mac80211/mesh_pathtbl.c	2010-05-28 20:37:06.000000000 +0200
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
 


