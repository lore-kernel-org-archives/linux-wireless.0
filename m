Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:56325 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab1IAUFl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 16:05:41 -0400
Received: by pzk37 with SMTP id 37so3463263pzk.1
        for <linux-wireless@vger.kernel.org>; Thu, 01 Sep 2011 13:05:41 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH] mac80211: Stop forwarding mesh traffic when tx queues are full
Date: Thu,  1 Sep 2011 13:05:33 -0700
Message-Id: <1314907533-27486-1-git-send-email-javier@cozybit.com> (sfid-20110901_220545_671217_B0445E6E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tx flow control for non-mesh modes of operation only needs to act on the
net device queues: when the hardware queues are full we stop accepting
traffic from the net device.  In mesh, however, we also need to stop
forwarding traffic.  This patch checks the hardware queues before
attempting to forward a mesh frame.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
This approach was suggested by Johannes after he NACKed "ath5k: Invoke irqsafe
version of ieee80211_tx_status() to avoid deadlock"

 net/mac80211/debugfs_netdev.c |    3 +++
 net/mac80211/ieee80211_i.h    |    1 +
 net/mac80211/rx.c             |    6 ++++++
 3 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 6e8eab7..dd04629 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -340,6 +340,8 @@ IEEE80211_IF_FILE(fwded_mcast, u.mesh.mshstats.fwded_mcast, DEC);
 IEEE80211_IF_FILE(fwded_unicast, u.mesh.mshstats.fwded_unicast, DEC);
 IEEE80211_IF_FILE(fwded_frames, u.mesh.mshstats.fwded_frames, DEC);
 IEEE80211_IF_FILE(dropped_frames_ttl, u.mesh.mshstats.dropped_frames_ttl, DEC);
+IEEE80211_IF_FILE(dropped_frames_congestion,
+		u.mesh.mshstats.dropped_frames_congestion, DEC);
 IEEE80211_IF_FILE(dropped_frames_no_route,
 		u.mesh.mshstats.dropped_frames_no_route, DEC);
 IEEE80211_IF_FILE(estab_plinks, u.mesh.mshstats.estab_plinks, ATOMIC);
@@ -463,6 +465,7 @@ static void add_mesh_stats(struct ieee80211_sub_if_data *sdata)
 	MESHSTATS_ADD(fwded_frames);
 	MESHSTATS_ADD(dropped_frames_ttl);
 	MESHSTATS_ADD(dropped_frames_no_route);
+	MESHSTATS_ADD(dropped_frames_congestion);
 	MESHSTATS_ADD(estab_plinks);
 #undef MESHSTATS_ADD
 }
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c204cee..e7be86a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -261,6 +261,7 @@ struct mesh_stats {
 	__u32 fwded_frames;		/* Mesh total forwarded frames */
 	__u32 dropped_frames_ttl;	/* Not transmitted since mesh_ttl == 0*/
 	__u32 dropped_frames_no_route;	/* Not transmitted, no route found */
+	__u32 dropped_frames_congestion;/* Not forwarded due to congestion */
 	atomic_t estab_plinks;
 };
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index f45fd2f..7c503f2 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1847,6 +1847,12 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 		/* illegal frame */
 		return RX_DROP_MONITOR;
 
+	if (local->queue_stop_reasons[skb_get_queue_mapping(skb)]) {
+		IEEE80211_IFSTA_MESH_CTR_INC(&sdata->u.mesh,
+						dropped_frames_congestion);
+		return RX_DROP_MONITOR;
+	}
+
 	if (mesh_hdr->flags & MESH_FLAGS_AE) {
 		struct mesh_path *mppath;
 		char *proxied_addr;
-- 
1.7.6

