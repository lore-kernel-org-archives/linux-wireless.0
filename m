Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.176]:36279 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757317AbYCCUUn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2008 15:20:43 -0500
Received: by el-out-1112.google.com with SMTP id v27so330530ele.17
        for <linux-wireless@vger.kernel.org>; Mon, 03 Mar 2008 12:20:41 -0800 (PST)
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Fri, 29 Feb 2008 14:30:32 -0800
Subject: [PATCH 05/10] mac80211: clean up use of endianness conversion functions
Message-ID: <47cc5d96.27f8720a.1adb.7693@mx.google.com> (sfid-20080303_202059_687216_20FEF69C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 net/mac80211/mesh_hwmp.c  |   30 +++++++++++++++---------------
 net/mac80211/mesh_plink.c |    2 +-
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 3ee46e4..c8c7d9a 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -449,9 +449,9 @@ static void hwmp_preq_frame_process(struct net_device *dev,
 		ttl = ifsta->mshcfg.dot11MeshTTL;
 		if (ttl != 0)
 			mesh_path_sel_frame_tx(MPATH_PREP, 0, dst_addr,
-				__cpu_to_le32(dst_dsn), 0, orig_addr,
-				__cpu_to_le32(orig_dsn), mgmt->sa, 0, ttl,
-				__cpu_to_le32(lifetime), __cpu_to_le32(metric),
+				cpu_to_le32(dst_dsn), 0, orig_addr,
+				cpu_to_le32(orig_dsn), mgmt->sa, 0, ttl,
+				cpu_to_le32(lifetime), cpu_to_le32(metric),
 				0, dev);
 		else
 			ifsta->mshstats.dropped_frames_ttl++;
@@ -472,10 +472,10 @@ static void hwmp_preq_frame_process(struct net_device *dev,
 		preq_id = PREQ_IE_PREQ_ID(preq_elem);
 		hopcount = PREQ_IE_HOPCOUNT(preq_elem) + 1;
 		mesh_path_sel_frame_tx(MPATH_PREQ, flags, orig_addr,
-				__cpu_to_le32(orig_dsn), dst_flags, dst_addr,
-				__cpu_to_le32(dst_dsn), dev->broadcast,
-				hopcount, ttl, __cpu_to_le32(lifetime),
-				__cpu_to_le32(metric), __cpu_to_le32(preq_id),
+				cpu_to_le32(orig_dsn), dst_flags, dst_addr,
+				cpu_to_le32(dst_dsn), dev->broadcast,
+				hopcount, ttl, cpu_to_le32(lifetime),
+				cpu_to_le32(metric), cpu_to_le32(preq_id),
 				dev);
 		ifsta->mshstats.fwded_frames++;
 	}
@@ -531,9 +531,9 @@ static void hwmp_prep_frame_process(struct net_device *dev,
 	orig_dsn = PREP_IE_ORIG_DSN(prep_elem);
 
 	mesh_path_sel_frame_tx(MPATH_PREP, flags, orig_addr,
-		__cpu_to_le32(orig_dsn), 0, dst_addr,
-		__cpu_to_le32(dst_dsn), mpath->next_hop->addr, hopcount, ttl,
-		__cpu_to_le32(lifetime), __cpu_to_le32(metric),
+		cpu_to_le32(orig_dsn), 0, dst_addr,
+		cpu_to_le32(dst_dsn), mpath->next_hop->addr, hopcount, ttl,
+		cpu_to_le32(lifetime), cpu_to_le32(metric),
 		0, dev);
 	rcu_read_unlock();
 	sdata->u.sta.mshstats.fwded_frames++;
@@ -566,7 +566,7 @@ static void hwmp_perr_frame_process(struct net_device *dev,
 			mpath->flags &= ~MESH_PATH_ACTIVE;
 			mpath->dsn = dst_dsn;
 			spin_unlock_bh(&mpath->state_lock);
-			mesh_path_error_tx(dst_addr, __cpu_to_le32(dst_dsn),
+			mesh_path_error_tx(dst_addr, cpu_to_le32(dst_dsn),
 					   dev->broadcast, dev);
 		} else
 			spin_unlock_bh(&mpath->state_lock);
@@ -745,10 +745,10 @@ void mesh_path_start_discovery(struct net_device *dev)
 
 	spin_unlock_bh(&mpath->state_lock);
 	mesh_path_sel_frame_tx(MPATH_PREQ, 0, dev->dev_addr,
-			__cpu_to_le32(ifsta->dsn), dst_flags, mpath->dst,
-			__cpu_to_le32(mpath->dsn), dev->broadcast, 0,
-			ttl, __cpu_to_le32(lifetime), 0,
-			__cpu_to_le32(ifsta->preq_id++), dev);
+			cpu_to_le32(ifsta->dsn), dst_flags, mpath->dst,
+			cpu_to_le32(mpath->dsn), dev->broadcast, 0,
+			ttl, cpu_to_le32(lifetime), 0,
+			cpu_to_le32(ifsta->preq_id++), dev);
 	mod_timer(&mpath->timer, jiffies + mpath->discovery_timeout);
 
 enddiscovery:
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 307c90e..23d951a 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -557,7 +557,7 @@ void mesh_rx_plink_frame(struct net_device *dev, struct ieee80211_mgmt *mgmt,
 
 	mpl_dbg("Mesh plink (peer, state, llid, plid, event): %s %d %d %d %d\n",
 			print_mac(mac, mgmt->sa), sta->plink_state,
-			__le16_to_cpu(sta->llid), __le16_to_cpu(sta->plid),
+			le16_to_cpu(sta->llid), le16_to_cpu(sta->plid),
 			event);
 	reason = 0;
 	switch (sta->plink_state) {
-- 
1.5.2.5



