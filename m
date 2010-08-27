Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56904 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab0H0Kht (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 06:37:49 -0400
Message-Id: <20100827103657.979409759@sipsolutions.net>
Date: Fri, 27 Aug 2010 12:35:54 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/6] mac80211: clean up ifdown/cleanup paths
References: <20100827103553.559128239@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's a lot of redundant code in mac80211's
interface cleanup/down, for example freeing
AP beacons is done both when the interface is
set DOWN as well as when it is torn down, of
which only the former has any effect.

Also, a bunch of things should be closer to
where they matter, like the MLME timers that
we should cancel when disassociating, rather
than only when the interface is set DOWN.

Clean up all this code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c |   89 +++++++++++++--------------------------------------
 net/mac80211/mlme.c  |    5 ++
 2 files changed, 28 insertions(+), 66 deletions(-)

--- wireless-testing.orig/net/mac80211/iface.c	2010-08-26 16:00:17.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2010-08-26 16:00:30.000000000 +0200
@@ -370,12 +370,9 @@ static int ieee80211_stop(struct net_dev
 	 * (because if we remove a STA after ops->remove_interface()
 	 * the driver will have removed the vif info already!)
 	 *
-	 * We could relax this and only unlink the stations from the
-	 * hash table and list but keep them on a per-sdata list that
-	 * will be inserted back again when the interface is brought
-	 * up again, but I don't currently see a use case for that,
-	 * except with WDS which gets a STA entry created when it is
-	 * brought up.
+	 * This is relevant only in AP, WDS and mesh modes, since in
+	 * all other modes we've already removed all stations when
+	 * disconnecting etc.
 	 */
 	sta_info_flush(local, sdata);
 
@@ -410,11 +407,21 @@ static int ieee80211_stop(struct net_dev
 		struct ieee80211_sub_if_data *vlan, *tmpsdata;
 		struct beacon_data *old_beacon = sdata->u.ap.beacon;
 
+		/* sdata_running will return false, so this will disable */
+		ieee80211_bss_info_change_notify(sdata,
+						 BSS_CHANGED_BEACON_ENABLED);
+
 		/* remove beacon */
 		rcu_assign_pointer(sdata->u.ap.beacon, NULL);
 		synchronize_rcu();
 		kfree(old_beacon);
 
+		/* free all potentially still buffered bcast frames */
+		while ((skb = skb_dequeue(&sdata->u.ap.ps_bc_buf))) {
+			local->total_ps_buffered--;
+			dev_kfree_skb(skb);
+		}
+
 		/* down all dependent devices, that is VLANs */
 		list_for_each_entry_safe(vlan, tmpsdata, &sdata->u.ap.vlans,
 					 u.vlan.list)
@@ -454,27 +461,6 @@ static int ieee80211_stop(struct net_dev
 
 		ieee80211_configure_filter(local);
 		break;
-	case NL80211_IFTYPE_STATION:
-		del_timer_sync(&sdata->u.mgd.chswitch_timer);
-		del_timer_sync(&sdata->u.mgd.timer);
-		del_timer_sync(&sdata->u.mgd.conn_mon_timer);
-		del_timer_sync(&sdata->u.mgd.bcn_mon_timer);
-		/*
-		 * If any of the timers fired while we waited for it, it will
-		 * have queued its work. Now the work will be running again
-		 * but will not rearm the timer again because it checks
-		 * whether the interface is running, which, at this point,
-		 * it no longer is.
-		 */
-		cancel_work_sync(&sdata->u.mgd.chswitch_work);
-		cancel_work_sync(&sdata->u.mgd.monitor_work);
-		cancel_work_sync(&sdata->u.mgd.beacon_connection_loss_work);
-
-		/* fall through */
-	case NL80211_IFTYPE_ADHOC:
-		if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
-			del_timer_sync(&sdata->u.ibss.timer);
-		/* fall through */
 	case NL80211_IFTYPE_MESH_POINT:
 		if (ieee80211_vif_is_mesh(&sdata->vif)) {
 			/* other_bss and allmulti are always set on mesh
@@ -502,17 +488,19 @@ static int ieee80211_stop(struct net_dev
 			ieee80211_scan_cancel(local);
 
 		/*
-		 * Disable beaconing for AP and mesh, IBSS can't
-		 * still be joined to a network at this point.
+		 * Disable beaconing here for mesh only, AP and IBSS
+		 * are already taken care of.
 		 */
-		if (sdata->vif.type == NL80211_IFTYPE_AP ||
-		    sdata->vif.type == NL80211_IFTYPE_MESH_POINT) {
+		if (sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
 			ieee80211_bss_info_change_notify(sdata,
 				BSS_CHANGED_BEACON_ENABLED);
-		}
 
-		/* free all remaining keys, there shouldn't be any */
+		/*
+		 * Free all remaining keys, there shouldn't be any,
+		 * except maybe group keys in AP more or WDS?
+		 */
 		ieee80211_free_keys(sdata);
+
 		drv_remove_interface(local, &sdata->vif);
 	}
 
@@ -593,8 +581,6 @@ static void ieee80211_teardown_sdata(str
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
-	struct beacon_data *beacon;
-	struct sk_buff *skb;
 	int flushed;
 	int i;
 
@@ -607,37 +593,8 @@ static void ieee80211_teardown_sdata(str
 		__skb_queue_purge(&sdata->fragments[i].skb_list);
 	sdata->fragment_next = 0;
 
-	switch (sdata->vif.type) {
-	case NL80211_IFTYPE_AP:
-		beacon = sdata->u.ap.beacon;
-		rcu_assign_pointer(sdata->u.ap.beacon, NULL);
-		synchronize_rcu();
-		kfree(beacon);
-
-		while ((skb = skb_dequeue(&sdata->u.ap.ps_bc_buf))) {
-			local->total_ps_buffered--;
-			dev_kfree_skb(skb);
-		}
-
-		break;
-	case NL80211_IFTYPE_MESH_POINT:
-		if (ieee80211_vif_is_mesh(&sdata->vif))
-			mesh_rmc_free(sdata);
-		break;
-	case NL80211_IFTYPE_ADHOC:
-		if (WARN_ON(sdata->u.ibss.presp))
-			kfree_skb(sdata->u.ibss.presp);
-		break;
-	case NL80211_IFTYPE_STATION:
-	case NL80211_IFTYPE_WDS:
-	case NL80211_IFTYPE_AP_VLAN:
-	case NL80211_IFTYPE_MONITOR:
-		break;
-	case NL80211_IFTYPE_UNSPECIFIED:
-	case NUM_NL80211_IFTYPES:
-		BUG();
-		break;
-	}
+	if (ieee80211_vif_is_mesh(&sdata->vif))
+		mesh_rmc_free(sdata);
 
 	flushed = sta_info_flush(local, sdata);
 	WARN_ON(flushed);
--- wireless-testing.orig/net/mac80211/mlme.c	2010-08-26 16:00:17.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2010-08-26 16:00:30.000000000 +0200
@@ -991,6 +991,11 @@ static void ieee80211_set_disassoc(struc
 
 	if (remove_sta)
 		sta_info_destroy_addr(sdata, bssid);
+
+	del_timer_sync(&sdata->u.mgd.conn_mon_timer);
+	del_timer_sync(&sdata->u.mgd.bcn_mon_timer);
+	del_timer_sync(&sdata->u.mgd.timer);
+	del_timer_sync(&sdata->u.mgd.chswitch_timer);
 }
 
 void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,


