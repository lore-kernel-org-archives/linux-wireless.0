Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:52653 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758874AbZJPB2j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2009 21:28:39 -0400
Received: by ewy4 with SMTP id 4so1162289ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2009 18:28:03 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>, andrey@cozybit.com,
	johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, rpaulo@gmail.com, dreamfly281@gmail.com
Subject: [PATCH] mac80211: Learn about mesh portals from multicast traffic
Date: Thu, 15 Oct 2009 18:10:51 -0700
Message-Id: <1255655451-28830-1-git-send-email-javier@cozybit.com>
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mesh portals proxy traffic for nodes external to the mesh.  When a
proxied frame is received by a mesh interface, it should update its mesh
portal table.  This was only happening for unicast frames.  With this
change we also learn about mesh portals from proxied multicast frames.

Signed-off-by: Javier Cardona <javier@cozybit.com>

---
 net/mac80211/rx.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 7170bf4..5c385e3 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1504,19 +1504,28 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 		/* illegal frame */
 		return RX_DROP_MONITOR;
 
-	if (!is_multicast_ether_addr(hdr->addr1) &&
-			(mesh_hdr->flags & MESH_FLAGS_AE_A5_A6)) {
+	if (mesh_hdr->flags & MESH_FLAGS_AE) {
 		struct mesh_path *mppath;
+		char *proxied_addr;
+		char *mpp_addr;
+
+		if (is_multicast_ether_addr(hdr->addr1)) {
+			mpp_addr = hdr->addr3;
+			proxied_addr = mesh_hdr->eaddr1;
+		} else {
+			mpp_addr = hdr->addr4;
+			proxied_addr = mesh_hdr->eaddr2;
+		}
 
 		rcu_read_lock();
-		mppath = mpp_path_lookup(mesh_hdr->eaddr2, sdata);
+		mppath = mpp_path_lookup(proxied_addr, sdata);
 		if (!mppath) {
-			mpp_path_add(mesh_hdr->eaddr2, hdr->addr4, sdata);
+			mpp_path_add(proxied_addr, mpp_addr, sdata);
 		} else {
 			spin_lock_bh(&mppath->state_lock);
 			mppath->exp_time = jiffies;
-			if (compare_ether_addr(mppath->mpp, hdr->addr4) != 0)
-				memcpy(mppath->mpp, hdr->addr4, ETH_ALEN);
+			if (compare_ether_addr(mppath->mpp, mpp_addr) != 0)
+				memcpy(mppath->mpp, mpp_addr, ETH_ALEN);
 			spin_unlock_bh(&mppath->state_lock);
 		}
 		rcu_read_unlock();
-- 
1.6.0.4

