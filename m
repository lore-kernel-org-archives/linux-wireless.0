Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c1.cosetrain.com ([213.239.209.213]:40895 "EHLO
	mail.cosetrain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752032AbZAZUjS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 15:39:18 -0500
From: Florian Sesser <flomaillist@cosetrain.com>
To: linux-wireless@vger.kernel.org
Cc: Florian Sesser <flomaillist@cosetrain.com>
Subject: [PATCH 3/6] mac80211: Modularized mesh_hwmp.c
Date: Mon, 26 Jan 2009 21:39:12 +0100
Message-Id: <e236615740b8ce8c9515c14aac3a2d9d93806a98.1233001802.git.flomaillist@cosetrain.com> (sfid-20090126_213927_189051_52B47541)
In-Reply-To: <3202b18e8531aa78c29636c163de20875ae1a9cf.1233001802.git.flomaillist@cosetrain.com>
References: <497E1B90.4060803@cosetrain.com>
 <abd4234c03d59a65d3eb9259821d705899a08612.1233001802.git.flomaillist@cosetrain.com>
 <3202b18e8531aa78c29636c163de20875ae1a9cf.1233001802.git.flomaillist@cosetrain.com>
In-Reply-To: <abd4234c03d59a65d3eb9259821d705899a08612.1233001802.git.flomaillist@cosetrain.com>
References: <abd4234c03d59a65d3eb9259821d705899a08612.1233001802.git.flomaillist@cosetrain.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Separate mesh_hwmp.c into own module, which is
loaded automatically as the default path selection
protocol.

Signed-off-by: Florian Sesser <flomaillist@cosetrain.com>
---
 net/mac80211/mesh_hwmp.c    |   81 +++++++++++++++++++++++++------------------
 net/mac80211/mesh_pathtbl.c |   45 ++++++++++++++++++++++--
 net/mac80211/tx.c           |    4 ++-
 3 files changed, 91 insertions(+), 39 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 4f862b2..25c2159 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -7,12 +7,17 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/module.h>
+#include <net/mac80211.h>
+#include "ieee80211_i.h"
 #include "mesh.h"
 
 #define TEST_FRAME_LEN	8192
 #define MAX_METRIC	0xffffffff
 #define ARITH_SHIFT	8
 
+static struct mesh_path_sel_algo mesh_path_sel_hwmp;
+
 /* Number of frames buffered per destination for unresolved destinations */
 #define MESH_FRAME_QUEUE_LEN	10
 #define MAX_PREQ_QUEUE_LEN	64
@@ -69,16 +74,9 @@ static inline u32 u32_field_get(u8 *preq_elem, int offset, bool ae)
 	MSEC_TO_TU(s->u.mesh.mshcfg.dot11MeshHWMPactivePathTimeout)
 #define min_preq_int_jiff(s) \
 	(msecs_to_jiffies(s->u.mesh.mshcfg.dot11MeshHWMPpreqMinInterval))
-#define max_preq_retries(s) (s->u.mesh.mshcfg.dot11MeshHWMPmaxPREQretries)
 #define disc_timeout_jiff(s) \
 	msecs_to_jiffies(sdata->u.mesh.mshcfg.min_discovery_timeout)
 
-enum mpath_frame_type {
-	MPATH_PREQ = 0,
-	MPATH_PREP,
-	MPATH_PERR
-};
-
 static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 		u8 *orig_addr, __le32 orig_dsn, u8 dst_flags, u8 *dst,
 		__le32 dst_dsn, u8 *da, u8 hop_count, u8 ttl, __le32 lifetime,
@@ -679,7 +677,7 @@ static void mesh_queue_preq(struct mesh_path *mpath, u8 flags)
  *
  * @sdata: local mesh subif
  */
-void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata)
+static void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mesh_preq_queue *preq_node;
@@ -769,7 +767,7 @@ enddiscovery:
  * sent when the path is resolved. This means the caller must not free the skb
  * in this case.
  */
-int mesh_nexthop_lookup(struct sk_buff *skb,
+static int mesh_nexthop_lookup(struct sk_buff *skb,
 			struct ieee80211_sub_if_data *sdata)
 {
 	struct sk_buff *skb_to_free = NULL;
@@ -827,32 +825,47 @@ endlookup:
 	return err;
 }
 
-void mesh_path_timer(unsigned long data)
+static void hwmp_start (struct ieee80211_if_mesh *sta) {
+	/* init variables etc */
+}
+
+static void hwmp_stop (struct ieee80211_if_mesh *sta) {
+	/* finish, clean up */
+}
+
+static struct mesh_path_sel_ops mesh_path_sel_hwmp_ops = {
+		.path_start_discovery_fn = &mesh_path_start_discovery,
+		.nexthop_lookup_fn = &mesh_nexthop_lookup,
+		.path_error_tx_fn = &mesh_path_error_tx,
+		.path_timer_fn = &mesh_path_timer,
+		.queue_preq_fn = &mesh_queue_preq,
+		.rx_path_sel_frame_fn = &mesh_rx_path_sel_frame,
+		.path_sel_start_fn = &hwmp_start,
+		.path_sel_stop_fn = &hwmp_stop,
+};
+
+static struct mesh_path_sel_algo mesh_path_sel_hwmp = {
+	.name = "mesh_hwmp",
+	.id = 0x000FACFF,
+	.ops = &mesh_path_sel_hwmp_ops,
+	.owner = THIS_MODULE,
+};
+
+static int __init init_mesh_hwmp(void)
 {
-	struct ieee80211_sub_if_data *sdata;
-	struct mesh_path *mpath;
+	/* init code here */
+	mesh_path_sel_algo_register(&mesh_path_sel_hwmp);
 
-	rcu_read_lock();
-	mpath = (struct mesh_path *) data;
-	mpath = rcu_dereference(mpath);
-	if (!mpath)
-		goto endmpathtimer;
-	spin_lock_bh(&mpath->state_lock);
-	sdata = mpath->sdata;
-	if (mpath->flags & MESH_PATH_RESOLVED ||
-			(!(mpath->flags & MESH_PATH_RESOLVING)))
-		mpath->flags &= ~(MESH_PATH_RESOLVING | MESH_PATH_RESOLVED);
-	else if (mpath->discovery_retries < max_preq_retries(sdata)) {
-		++mpath->discovery_retries;
-		mpath->discovery_timeout *= 2;
-		mesh_queue_preq(mpath, 0);
-	} else {
-		mpath->flags = 0;
-		mpath->exp_time = jiffies;
-		mesh_path_flush_pending(mpath);
-	}
+	return 0;
+}
 
-	spin_unlock_bh(&mpath->state_lock);
-endmpathtimer:
-	rcu_read_unlock();
+static void __exit cleanup_mesh_hwmp(void)
+{
+	/* cleanup code here */
+	mesh_path_sel_algo_unregister(&mesh_path_sel_hwmp);
 }
+
+MODULE_LICENSE("GPL");
+module_init(init_mesh_hwmp);
+module_exit(cleanup_mesh_hwmp);
+
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 3c72557..c1f01fe 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -26,7 +26,7 @@
 				time_after(jiffies, mpath->exp_time) && \
 				!(mpath->flags & MESH_PATH_FIXED))
 
-struct mpath_node {
+		struct mpath_node {
 	struct hlist_node list;
 	struct rcu_head rcu;
 	/* This indirection allows two different tables to point to the same
@@ -57,6 +57,7 @@ void mesh_path_assign_nexthop(struct mesh_path *mpath, struct sta_info *sta)
 {
 	rcu_assign_pointer(mpath->next_hop, sta);
 }
+EXPORT_SYMBOL(mesh_path_assign_nexthop);
 
 
 /**
@@ -94,6 +95,7 @@ struct mesh_path *mesh_path_lookup(u8 *dst, struct ieee80211_sub_if_data *sdata)
 	}
 	return NULL;
 }
+EXPORT_SYMBOL(mesh_path_lookup);
 
 struct mesh_path *mpp_path_lookup(u8 *dst, struct ieee80211_sub_if_data *sdata)
 {
@@ -253,7 +255,7 @@ err_path_alloc:
 	atomic_dec(&sdata->u.mesh.mpaths);
 	return err;
 }
-
+EXPORT_SYMBOL(mesh_path_add);
 
 int mpp_path_add(u8 *dst, u8 *mpp, struct ieee80211_sub_if_data *sdata)
 {
@@ -366,7 +368,7 @@ void mesh_plink_broken(struct sta_info *sta)
 			mpath->flags &= ~MESH_PATH_ACTIVE;
 			++mpath->dsn;
 			spin_unlock_bh(&mpath->state_lock);
-			mesh_path_error_tx(mpath->dst,
+			sdata->u.mesh.mesh_pp->ops->path_error_tx_fn(mpath->dst,
 					cpu_to_le32(mpath->dsn),
 					sdata->dev->broadcast, sdata);
 		} else
@@ -484,6 +486,7 @@ void mesh_path_tx_pending(struct mesh_path *mpath)
 			(mpath->flags & MESH_PATH_ACTIVE))
 		dev_queue_xmit(skb);
 }
+EXPORT_SYMBOL(mesh_path_tx_pending);
 
 /**
  * mesh_path_discard_frame - discard a frame whose path could not be resolved
@@ -511,12 +514,13 @@ void mesh_path_discard_frame(struct sk_buff *skb,
 		mpath = mesh_path_lookup(da, sdata);
 		if (mpath)
 			dsn = ++mpath->dsn;
-		mesh_path_error_tx(skb->data, cpu_to_le32(dsn), ra, sdata);
+		sdata->u.mesh.mesh_pp->ops->path_error_tx_fn(skb->data, cpu_to_le32(dsn), ra, sdata);
 	}
 
 	kfree_skb(skb);
 	sdata->u.mesh.mshstats.dropped_frames_no_route++;
 }
+EXPORT_SYMBOL(mesh_path_discard_frame);
 
 /**
  * mesh_path_flush_pending - free the pending queue of a mesh path
@@ -637,3 +641,36 @@ void mesh_pathtbl_unregister(void)
 	mesh_table_free(mesh_paths, true);
 	mesh_table_free(mpp_paths, true);
 }
+
+/* Moved here from mesh_hwmp.c: */
+void mesh_path_timer(unsigned long data)
+{
+	struct ieee80211_sub_if_data *sdata;
+	struct mesh_path *mpath;
+
+	rcu_read_lock();
+	mpath = (struct mesh_path *) data;
+	mpath = rcu_dereference(mpath);
+	if (!mpath)
+		goto endmpathtimer;
+	spin_lock_bh(&mpath->state_lock);
+	sdata = mpath->sdata;
+	if (mpath->flags & MESH_PATH_RESOLVED ||
+			(!(mpath->flags & MESH_PATH_RESOLVING)))
+		mpath->flags &= ~(MESH_PATH_RESOLVING | MESH_PATH_RESOLVED);
+	else if (mpath->discovery_retries < max_preq_retries(sdata)) {
+		++mpath->discovery_retries;
+		mpath->discovery_timeout *= 2;
+		sdata->u.mesh.mesh_pp->ops->queue_preq_fn(mpath, 0);
+	} else {
+		mpath->flags = 0;
+		mpath->exp_time = jiffies;
+		mesh_path_flush_pending(mpath);
+	}
+
+	spin_unlock_bh(&mpath->state_lock);
+endmpathtimer:
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL(mesh_path_timer);
+
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 7b013fb..a486c87 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1351,11 +1351,13 @@ int ieee80211_master_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	    ieee80211_is_data(hdr->frame_control)) {
 		if (is_multicast_ether_addr(hdr->addr3))
 			memcpy(hdr->addr1, hdr->addr3, ETH_ALEN);
+#ifdef CONFIG_MAC80211_MESH
 		else
-			if (mesh_nexthop_lookup(skb, osdata)) {
+			if (osdata->u.mesh.mesh_pp->ops->nexthop_lookup_fn(skb, osdata)) {
 				dev_put(odev);
 				return 0;
 			}
+#endif
 		if (memcmp(odev->dev_addr, hdr->addr4, ETH_ALEN) != 0)
 			IEEE80211_IFSTA_MESH_CTR_INC(&osdata->u.mesh,
 							    fwded_frames);
-- 
1.5.6.5

