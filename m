Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fifo99.com ([67.223.236.141]:52589 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660AbZHROCU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 10:02:20 -0400
From: Daniel Walker <dwalker@fifo99.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Daniel Walker <dwalker@fifo99.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Andrey Yurovsky <andrey@cozybit.com>,
	Javier Cardona <javier@cozybit.com>,
	linux-wireless@vger.kernel.org,
	Sven-Thorsten Dietrich <sven@thebigcorporation.com>
Subject: [PATCH] net: wireless: mesh: Add multicast and unicast stat counters
Date: Tue, 18 Aug 2009 07:02:26 -0700
Message-Id: <1250604146-10140-1-git-send-email-dwalker@fifo99.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I added two new stat counters to count if each forwarded frame is
either multicast or unicast. This expands on the current fwded_frames
stat counter which should be equal to the total of these two new
counters.

The new counters are called "fwded_mcast" and "fwded_unicast".

CC: Johannes Berg <johannes@sipsolutions.net>
CC: David S. Miller <davem@davemloft.net>
CC: John W. Linville <linville@tuxdriver.com>
CC: Luis R. Rodriguez <lrodriguez@atheros.com>
CC: Andrey Yurovsky <andrey@cozybit.com>
CC: Javier Cardona <javier@cozybit.com>
CC: linux-wireless@vger.kernel.org
CC: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
Signed-off-by: Daniel Walker <dwalker@fifo99.com>
---
 net/mac80211/debugfs_netdev.c |    6 ++++++
 net/mac80211/ieee80211_i.h    |    6 +++++-
 net/mac80211/mesh_hwmp.c      |    4 ++++
 net/mac80211/rx.c             |    9 +++++++--
 4 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index e9ec6ca..00f7c6e 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -116,6 +116,8 @@ IEEE80211_IF_FILE(peer, u.wds.remote_addr, MAC);
 
 #ifdef CONFIG_MAC80211_MESH
 /* Mesh stats attributes */
+IEEE80211_IF_FILE(fwded_mcast, u.mesh.mshstats.fwded_mcast, DEC);
+IEEE80211_IF_FILE(fwded_unicast, u.mesh.mshstats.fwded_unicast, DEC);
 IEEE80211_IF_FILE(fwded_frames, u.mesh.mshstats.fwded_frames, DEC);
 IEEE80211_IF_FILE(dropped_frames_ttl, u.mesh.mshstats.dropped_frames_ttl, DEC);
 IEEE80211_IF_FILE(dropped_frames_no_route,
@@ -205,6 +207,8 @@ static void add_mesh_stats(struct ieee80211_sub_if_data *sdata)
 {
 	sdata->mesh_stats_dir = debugfs_create_dir("mesh_stats",
 				sdata->debugfsdir);
+	MESHSTATS_ADD(mcast_frames);
+	MESHSTATS_ADD(unicast_frames);
 	MESHSTATS_ADD(fwded_frames);
 	MESHSTATS_ADD(dropped_frames_ttl);
 	MESHSTATS_ADD(dropped_frames_no_route);
@@ -327,6 +331,8 @@ static void del_monitor_files(struct ieee80211_sub_if_data *sdata)
 
 static void del_mesh_stats(struct ieee80211_sub_if_data *sdata)
 {
+	MESHSTATS_DEL(mcast_frames);
+	MESHSTATS_DEL(unicast_frames);
 	MESHSTATS_DEL(fwded_frames);
 	MESHSTATS_DEL(dropped_frames_ttl);
 	MESHSTATS_DEL(dropped_frames_no_route);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d6bd7dd..82c39d9 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -212,7 +212,9 @@ struct ieee80211_if_vlan {
 };
 
 struct mesh_stats {
-	__u32 fwded_frames;		/* Mesh forwarded frames */
+	__u32 fwded_mcast;		/* Mesh forwarded multicast frames */
+	__u32 fwded_unicast;		/* Mesh forwarded unicast frames */
+	__u32 fwded_frames;		/* Mesh total forwarded frames */
 	__u32 dropped_frames_ttl;	/* Not transmitted since mesh_ttl == 0*/
 	__u32 dropped_frames_no_route;	/* Not transmitted, no route found */
 	atomic_t estab_plinks;
@@ -506,6 +508,8 @@ struct ieee80211_sub_if_data {
 #ifdef CONFIG_MAC80211_MESH
 	struct dentry *mesh_stats_dir;
 	struct {
+		struct dentry *fwded_mcast;
+		struct dentry *fwded_unicast;
 		struct dentry *fwded_frames;
 		struct dentry *dropped_frames_ttl;
 		struct dentry *dropped_frames_no_route;
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index e1a763e..593ea64 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -478,6 +478,8 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 				hopcount, ttl, cpu_to_le32(lifetime),
 				cpu_to_le32(metric), cpu_to_le32(preq_id),
 				sdata);
+		
+		ifmsh->mshstats.fwded_mcast++;
 		ifmsh->mshstats.fwded_frames++;
 	}
 }
@@ -536,6 +538,8 @@ static void hwmp_prep_frame_process(struct ieee80211_sub_if_data *sdata,
 		cpu_to_le32(lifetime), cpu_to_le32(metric),
 		0, sdata);
 	rcu_read_unlock();
+
+	sdata->u.mesh.mshstats.fwded_unicast++;
 	sdata->u.mesh.mshstats.fwded_frames++;
 	return;
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 25a669c..cf21f57 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1543,16 +1543,21 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 			info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
 			info->control.vif = &rx->sdata->vif;
 			ieee80211_select_queue(local, fwd_skb);
-			if (is_multicast_ether_addr(fwd_hdr->addr3))
+			if (is_multicast_ether_addr(fwd_hdr->addr3)) {
 				memcpy(fwd_hdr->addr1, fwd_hdr->addr3,
 						ETH_ALEN);
-			else {
+				IEEE80211_IFSTA_MESH_CTR_INC(&sdata->u.mesh,
+							     fwded_mcast);
+			} else {
 				int err = mesh_nexthop_lookup(fwd_skb, sdata);
 				/* Failed to immediately resolve next hop:
 				 * fwded frame was dropped or will be added
 				 * later to the pending skb queue.  */
 				if (err)
 					return RX_DROP_MONITOR;
+
+				IEEE80211_IFSTA_MESH_CTR_INC(&sdata->u.mesh,
+							     fwded_unicast);
 			}
 			IEEE80211_IFSTA_MESH_CTR_INC(&sdata->u.mesh,
 						     fwded_frames);
-- 
1.5.6.3

