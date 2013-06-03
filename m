Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:49188 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757860Ab3FCX2I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 19:28:08 -0400
Received: by mail-pb0-f47.google.com with SMTP id rr4so6336868pbb.6
        for <linux-wireless@vger.kernel.org>; Mon, 03 Jun 2013 16:28:07 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 1/2] mac80211: fix mesh deadlock
Date: Mon,  3 Jun 2013 16:25:42 -0700
Message-Id: <1370301943-13867-1-git-send-email-thomas@cozybit.com> (sfid-20130604_012812_870629_ABDC396A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch "cfg80211/mac80211: use cfg80211 wdev mutex in
mac80211" introduced several deadlocks by converting the
ifmsh->mtx to wdev->mtx. Solve these by:

1. drop the cancel_work_sync() in ieee80211_stop_mesh().
   Instead make the mesh work conditional on whether the mesh
   is running or not.
2. lock the mesh work with sdata_lock() to protect beacon
   updates and prevent races with wdev->mesh_id_len or
   cfg80211.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh.c       |   29 +++++++++++++++++------------
 net/mac80211/mesh_plink.c |    7 +------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 73a597b..d5faf91 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -579,9 +579,7 @@ static void ieee80211_mesh_housekeeping(struct ieee80211_sub_if_data *sdata)
 	mesh_path_expire(sdata);
 
 	changed = mesh_accept_plinks_update(sdata);
-	sdata_lock(sdata);
 	ieee80211_mbss_info_change_notify(sdata, changed);
-	sdata_unlock(sdata);
 
 	mod_timer(&ifmsh->housekeeping_timer,
 		  round_jiffies(jiffies +
@@ -788,12 +786,10 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 	sdata->vif.bss_conf.enable_beacon = false;
 	clear_bit(SDATA_STATE_OFFCHANNEL_BEACON_STOPPED, &sdata->state);
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
-	sdata_lock(sdata);
 	bcn = rcu_dereference_protected(ifmsh->beacon,
 					lockdep_is_held(&sdata->wdev.mtx));
 	rcu_assign_pointer(ifmsh->beacon, NULL);
 	kfree_rcu(bcn, rcu_head);
-	sdata_unlock(sdata);
 
 	/* flush STAs and mpaths on this iface */
 	sta_info_flush(sdata);
@@ -806,14 +802,6 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 	del_timer_sync(&sdata->u.mesh.housekeeping_timer);
 	del_timer_sync(&sdata->u.mesh.mesh_path_root_timer);
 	del_timer_sync(&sdata->u.mesh.mesh_path_timer);
-	/*
-	 * If the timer fired while we waited for it, it will have
-	 * requeued the work. Now the work will be running again
-	 * but will not rearm the timer again because it checks
-	 * whether the interface is running, which, at this point,
-	 * it no longer is.
-	 */
-	cancel_work_sync(&sdata->work);
 
 	local->fif_other_bss--;
 	atomic_dec(&local->iff_allmultis);
@@ -954,6 +942,12 @@ void ieee80211_mesh_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_mgmt *mgmt;
 	u16 stype;
 
+	sdata_lock(sdata);
+
+	/* mesh already went down */
+	if (!sdata->wdev.mesh_id_len)
+		goto out;
+
 	rx_status = IEEE80211_SKB_RXCB(skb);
 	mgmt = (struct ieee80211_mgmt *) skb->data;
 	stype = le16_to_cpu(mgmt->frame_control) & IEEE80211_FCTL_STYPE;
@@ -971,12 +965,20 @@ void ieee80211_mesh_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 		ieee80211_mesh_rx_mgmt_action(sdata, mgmt, skb->len, rx_status);
 		break;
 	}
+out:
+	sdata_unlock(sdata);
 }
 
 void ieee80211_mesh_work(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 
+	sdata_lock(sdata);
+
+	/* mesh already went down */
+	if (!sdata->wdev.mesh_id_len)
+		goto out;
+
 	if (ifmsh->preq_queue_len &&
 	    time_after(jiffies,
 		       ifmsh->last_preq + msecs_to_jiffies(ifmsh->mshcfg.dot11MeshHWMPpreqMinInterval)))
@@ -996,6 +998,9 @@ void ieee80211_mesh_work(struct ieee80211_sub_if_data *sdata)
 
 	if (test_and_clear_bit(MESH_WORK_DRIFT_ADJUST, &ifmsh->wrkq_flags))
 		mesh_sync_adjust_tbtt(sdata);
+
+out:
+	sdata_unlock(sdata);
 }
 
 void ieee80211_mesh_notify_scan_completed(struct ieee80211_local *local)
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 6c4da99..09bebed 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -517,9 +517,7 @@ void mesh_neighbour_update(struct ieee80211_sub_if_data *sdata,
 	ieee80211_mps_frame_release(sta, elems);
 out:
 	rcu_read_unlock();
-	sdata_lock(sdata);
 	ieee80211_mbss_info_change_notify(sdata, changed);
-	sdata_unlock(sdata);
 }
 
 static void mesh_plink_timer(unsigned long data)
@@ -1070,9 +1068,6 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 
 	rcu_read_unlock();
 
-	if (changed) {
-		sdata_lock(sdata);
+	if (changed)
 		ieee80211_mbss_info_change_notify(sdata, changed);
-		sdata_unlock(sdata);
-	}
 }
-- 
1.7.10.4

