Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:44689 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab2HBXsC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 19:48:02 -0400
Received: by ghrr11 with SMTP id r11so134525ghr.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Aug 2012 16:48:01 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 1/4] mac80211: leave mesh when stopping the netdev
Date: Thu,  2 Aug 2012 16:47:51 -0700
Message-Id: <1343951274-24956-1-git-send-email-thomas@cozybit.com> (sfid-20120803_014844_246305_22ABB341)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously, we would merely stop the beacon and fail to free any mesh
specific data structures on netdev down or unregister. Split mesh
beacon, data, timer, and work cancel steps into ieee80211_mesh_stop() to
avoid decrementing the filter counters twice, and call this in the
ndo_stop handler.

Also some improvements to ieee80211_mesh_stop():

 - flush mpath entries.
 - flush sta entries per-sdata so we don't remove entries belonging to
   other vifs on the same hw.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/iface.c |   12 ++++--------
 net/mac80211/mesh.c  |   16 +++++++++++++---
 net/mac80211/mesh.h  |    1 +
 3 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index bfb57dc..80e0765 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -689,6 +689,8 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		local->fif_probe_req--;
 	} else if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
 		local->fif_probe_req--;
+	} else if (ieee80211_vif_is_mesh(&sdata->vif)) {
+		local->fif_other_bss--;
 	}
 
 	netif_addr_lock_bh(sdata->dev);
@@ -733,6 +735,8 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		skb_queue_purge(&sdata->u.ap.ps_bc_buf);
 	} else if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 		ieee80211_mgd_stop(sdata);
+	} else if (ieee80211_vif_is_mesh(&sdata->vif)) {
+		ieee80211_mesh_stop(sdata);
 	}
 
 	if (going_down)
@@ -771,14 +775,6 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		skb_queue_purge(&sdata->skb_queue);
 
 		/*
-		 * Disable beaconing here for mesh only, AP and IBSS
-		 * are already taken care of.
-		 */
-		if (sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
-			ieee80211_bss_info_change_notify(sdata,
-				BSS_CHANGED_BEACON_ENABLED);
-
-		/*
 		 * Free all remaining keys, there shouldn't be any,
 		 * except maybe group keys in AP more or WDS?
 		 */
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 764593d..4dd74a0 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -611,14 +611,17 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 						BSS_CHANGED_BEACON_INT);
 }
 
-void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
+void ieee80211_mesh_stop(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 
+	/* stop the beacon */
 	ifmsh->mesh_id_len = 0;
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
-	sta_info_flush(local, NULL);
+
+	/* flush STAs and mpaths on this iface */
+	sta_info_flush(sdata->local, sdata);
+	mesh_path_flush_by_iface(sdata);
 
 	del_timer_sync(&sdata->u.mesh.housekeeping_timer);
 	del_timer_sync(&sdata->u.mesh.mesh_path_root_timer);
@@ -630,6 +633,13 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 	 * it no longer is.
 	 */
 	cancel_work_sync(&sdata->work);
+}
+
+void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+
+	ieee80211_mesh_stop(sdata);
 
 	local->fif_other_bss--;
 	atomic_dec(&local->iff_allmultis);
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index faaa39b..2a21da1 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -252,6 +252,7 @@ void ieee80211s_stop(void);
 void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata);
 void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata);
 void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata);
+void ieee80211_mesh_stop(struct ieee80211_sub_if_data *sdata);
 void ieee80211_mesh_root_setup(struct ieee80211_if_mesh *ifmsh);
 struct ieee80211_mesh_sync_ops *ieee80211_mesh_sync_ops_get(u8 method);
 
-- 
1.7.5.4

