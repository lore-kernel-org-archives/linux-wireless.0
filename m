Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34604 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab2HCTVk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2012 15:21:40 -0400
Received: by pbbrp8 with SMTP id rp8so1800271pbb.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Aug 2012 12:21:40 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH v2 1/4] mac80211: improve cleanup when leaving mesh
Date: Fri,  3 Aug 2012 12:21:32 -0700
Message-Id: <1344021695-12859-1-git-send-email-thomas@cozybit.com> (sfid-20120803_212145_263949_9F7EAA8C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is not necessary to stop the mesh beacon in the mac80211 ndo_stop
handler, since cfg80211 has already left the mesh on NETDEV_GOING_DOWN
notification.

Also some improvements to ieee80211_stop_mesh():

 - flush mpath entries.
 - flush sta entries per-sdata so we don't remove entries belonging to
   other vifs on the same hw.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>

---
v2: don't leave the mesh twice :) (Johannes)

 net/mac80211/iface.c |    8 --------
 net/mac80211/mesh.c  |    6 +++++-
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index bfb57dc..b6c5a92 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -771,14 +771,6 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
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
index 8557235..a01559d 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -616,9 +616,13 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_local *local = sdata->local;
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
-- 
1.7.5.4

