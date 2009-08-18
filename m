Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f196.google.com ([209.85.216.196]:33935 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbZHRSKv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 14:10:51 -0400
Received: by pxi34 with SMTP id 34so1959933pxi.4
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2009 11:10:52 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Daniel Walker <dwalker@fifo99.com>,
	Javier Cardona <javier@cozybit.com>, andrey@cozybit.com,
	johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org
Subject: [PATCH] mac80211: New stat counters for multicast and unicast forwarded frames
Date: Tue, 18 Aug 2009 10:59:00 -0700
Message-Id: <1250618340-32129-1-git-send-email-javier@cozybit.com>
In-Reply-To: <445f43ac0908181108g490934c1ib0c805859cba1e44@mail.gmail.com>
References: <445f43ac0908181108g490934c1ib0c805859cba1e44@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Walker <dwalker@fifo99.com>

This expands on the current fwded_frames stat counter which should be equal to
the total of these two new counters.  The new counters are called "fwded_mcast"
and "fwded_unicast".

Signed-off-by: Daniel Walker <dwalker@fifo99.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/debugfs_netdev.c |    6 ++++++
 net/mac80211/ieee80211_i.h    |    6 +++++-
 net/mac80211/mesh_hwmp.c      |    3 +++
 net/mac80211/rx.c             |    8 +++++++-
 4 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index e9ec6ca..61234e7 100644
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
+	MESHSTATS_ADD(fwded_mcast);
+	MESHSTATS_ADD(fwded_unicast);
 	MESHSTATS_ADD(fwded_frames);
 	MESHSTATS_ADD(dropped_frames_ttl);
 	MESHSTATS_ADD(dropped_frames_no_route);
@@ -327,6 +331,8 @@ static void del_monitor_files(struct ieee80211_sub_if_data *sdata)
 
 static void del_mesh_stats(struct ieee80211_sub_if_data *sdata)
 {
+	MESHSTATS_DEL(fwded_mcast);
+	MESHSTATS_DEL(fwded_unicast);
 	MESHSTATS_DEL(fwded_frames);
 	MESHSTATS_DEL(dropped_frames_ttl);
 	MESHSTATS_DEL(dropped_frames_no_route);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a07f017..93e618a 100644
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
index 7aeba00..e12a786 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -497,6 +497,7 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 				hopcount, ttl, cpu_to_le32(lifetime),
 				cpu_to_le32(metric), cpu_to_le32(preq_id),
 				sdata);
+		ifmsh->mshstats.fwded_mcast++;
 		ifmsh->mshstats.fwded_frames++;
 	}
 }
@@ -555,6 +556,8 @@ static void hwmp_prep_frame_process(struct ieee80211_sub_if_data *sdata,
 		cpu_to_le32(lifetime), cpu_to_le32(metric),
 		0, sdata);
 	rcu_read_unlock();
+
+	sdata->u.mesh.mshstats.fwded_unicast++;
 	sdata->u.mesh.mshstats.fwded_frames++;
 	return;
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 4cd9e45..7065fd7 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1550,7 +1550,10 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 			info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
 			info->control.vif = &rx->sdata->vif;
 			ieee80211_select_queue(local, fwd_skb);
-			if (!is_multicast_ether_addr(fwd_hdr->addr1)) {
+			if (is_multicast_ether_addr(fwd_hdr->addr1))
+				IEEE80211_IFSTA_MESH_CTR_INC(&sdata->u.mesh,
+								fwded_mcast);
+			else {
 				int err;
 				/*
 				 * Save TA to addr1 to send TA a path error if a
@@ -1564,6 +1567,9 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 				 * later to the pending skb queue.  */
 				if (err)
 					return RX_DROP_MONITOR;
+
+				IEEE80211_IFSTA_MESH_CTR_INC(&sdata->u.mesh,
+								fwded_unicast);
 			}
 			IEEE80211_IFSTA_MESH_CTR_INC(&sdata->u.mesh,
 						     fwded_frames);
-- 
1.5.4.3

