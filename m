Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f48.google.com ([74.125.83.48]:34683 "EHLO
        mail-pg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751452AbdBUXZG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 18:25:06 -0500
Received: by mail-pg0-f48.google.com with SMTP id 1so24277295pgi.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Feb 2017 15:25:05 -0800 (PST)
From: Alexis Green <agreen@uniumwifi.com>
Message-ID: <58ACCC4B.2090008@cococorp.com> (sfid-20170222_002510_855761_173E0C7D)
Date: Tue, 21 Feb 2017 15:24:59 -0800
Reply-To: agreen@cococorp.com
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Jesse Jones <jjones@cococorp.com>
Subject: [PATCH] mac80211: Jitter HWMP MPATH reply frames to reduce collision,
 on dense networks.
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jesse Jones <jjones@uniumwifi.com>

When more than one station hears a broadcast request, it is possible that
multiple devices will reply at the same time, potentially causing
collision. This patch helps reduce this issue.

Signed-off-by: Alexis Green <agreen@uniumwifi.com>
Signed-off-by: Benjamin Morgan <bmorgan@uniumwifi.com>
---
 net/mac80211/ieee80211_i.h |  11 ++++
 net/mac80211/iface.c       |  58 +++++++++++++++++++++
 net/mac80211/mesh.c        |   2 +
 net/mac80211/mesh_hwmp.c   | 124 +++++++++++++++++++++++++++++++++++----------
 4 files changed, 168 insertions(+), 27 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 159a1a7..f422897 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -330,6 +330,11 @@ struct mesh_preq_queue {
 	u8 flags;
 };
 
+struct mesh_tx_queue {
+	struct list_head list;
+	struct sk_buff *skb;
+};
+
 struct ieee80211_roc_work {
 	struct list_head list;
 
@@ -670,6 +675,11 @@ struct ieee80211_if_mesh {
 	spinlock_t mesh_preq_queue_lock;
 	struct mesh_preq_queue preq_queue;
 	int preq_queue_len;
+	/* Spinlock for MPATH frame tx queue */
+	spinlock_t mesh_tx_queue_lock;
+	struct mesh_tx_queue tx_queue;
+	int tx_queue_len;
+
 	struct mesh_stats mshstats;
 	struct mesh_config mshcfg;
 	atomic_t estab_plinks;
@@ -919,6 +929,7 @@ struct ieee80211_sub_if_data {
 
 	struct work_struct work;
 	struct sk_buff_head skb_queue;
+	struct delayed_work tx_work;
 
 	u8 needed_rx_chains;
 	enum ieee80211_smps_mode smps_mode;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 40813dd..51d5cfa 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -778,6 +778,59 @@ static int ieee80211_open(struct net_device *dev)
 	return ieee80211_do_open(&sdata->wdev, true);
 }
 
+static void flush_tx_skbs(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct mesh_tx_queue *tx_node;
+
+	spin_lock_bh(&ifmsh->mesh_tx_queue_lock);
+
+	/* Note that this check is important because of the two-stage
+	 * way that ieee80211_if_mesh is initialized.
+	 */
+	if (ifmsh->tx_queue_len > 0) {
+		mhwmp_dbg(sdata, "flushing %d skbs", ifmsh->tx_queue_len);
+
+		while (!list_empty(&ifmsh->tx_queue.list)) {
+			tx_node = list_last_entry(&ifmsh->tx_queue.list,
+						  struct mesh_tx_queue, list);
+			kfree_skb(tx_node->skb);
+			list_del(&tx_node->list);
+			kfree(tx_node);
+		}
+		ifmsh->tx_queue_len = 0;
+	}
+
+	spin_unlock_bh(&ifmsh->mesh_tx_queue_lock);
+}
+
+static void mesh_jittered_tx(struct work_struct *wk)
+{
+	struct ieee80211_sub_if_data *sdata =
+		container_of(
+			     wk, struct ieee80211_sub_if_data,
+			     tx_work.work);
+
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct mesh_tx_queue *tx_node;
+
+	spin_lock_bh(&ifmsh->mesh_tx_queue_lock);
+
+	list_for_each_entry(tx_node, &ifmsh->tx_queue.list, list) {
+		ieee80211_tx_skb(sdata, tx_node->skb);
+	}
+
+	while (!list_empty(&ifmsh->tx_queue.list)) {
+		tx_node = list_last_entry(&ifmsh->tx_queue.list,
+					  struct mesh_tx_queue, list);
+		list_del(&tx_node->list);
+		kfree(tx_node);
+	}
+	ifmsh->tx_queue_len = 0;
+
+	spin_unlock_bh(&ifmsh->mesh_tx_queue_lock);
+}
+
 static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 			      bool going_down)
 {
@@ -881,6 +934,9 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 
 	cancel_delayed_work_sync(&sdata->dfs_cac_timer_work);
 
+	flush_tx_skbs(sdata);
+	cancel_delayed_work_sync(&sdata->tx_work);
+
 	if (sdata->wdev.cac_started) {
 		chandef = sdata->vif.bss_conf.chandef;
 		WARN_ON(local->suspended);
@@ -1846,6 +1902,8 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 			  ieee80211_dfs_cac_timer_work);
 	INIT_DELAYED_WORK(&sdata->dec_tailroom_needed_wk,
 			  ieee80211_delayed_tailroom_dec);
+	INIT_DELAYED_WORK(&sdata->tx_work,
+			  mesh_jittered_tx);
 
 	for (i = 0; i < NUM_NL80211_BANDS; i++) {
 		struct ieee80211_supported_band *sband;
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index c28b0af..f0d3cd9 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1381,6 +1381,8 @@ void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
 		    ieee80211_mesh_path_root_timer,
 		    (unsigned long) sdata);
 	INIT_LIST_HEAD(&ifmsh->preq_queue.list);
+	INIT_LIST_HEAD(&ifmsh->tx_queue.list);
+	spin_lock_init(&ifmsh->mesh_tx_queue_lock);
 	skb_queue_head_init(&ifmsh->ps.bc_buf);
 	spin_lock_init(&ifmsh->mesh_preq_queue_lock);
 	spin_lock_init(&ifmsh->sync_offset_lock);
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index b747c96..2f8ca4a 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -18,6 +18,7 @@
 #define ARITH_SHIFT	8
 
 #define MAX_PREQ_QUEUE_LEN	64
+#define MAX_TX_QUEUE_LEN	8
 
 static void mesh_queue_preq(struct mesh_path *, u8);
 
@@ -98,13 +99,15 @@ enum mpath_frame_type {
 
 static const u8 broadcast_addr[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 
-static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
-				  const u8 *orig_addr, u32 orig_sn,
-				  u8 target_flags, const u8 *target,
-				  u32 target_sn, const u8 *da,
-				  u8 hop_count, u8 ttl,
-				  u32 lifetime, u32 metric, u32 preq_id,
-				  struct ieee80211_sub_if_data *sdata)
+static struct sk_buff *alloc_mesh_path_sel_frame(enum mpath_frame_type action,
+						 u8 flags, const u8 *orig_addr,
+						 u32 orig_sn, u8 target_flags,
+						 const u8 *target,
+						 u32 target_sn, const u8 *da,
+						 u8 hop_count, u8 ttl,
+						 u32 lifetime, u32 metric,
+						 u32 preq_id,
+						 struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
@@ -117,7 +120,7 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 			    hdr_len +
 			    2 + 37); /* max HWMP IE */
 	if (!skb)
-		return -1;
+		return NULL;
 	skb_reserve(skb, local->tx_headroom);
 	mgmt = (struct ieee80211_mgmt *) skb_put(skb, hdr_len);
 	memset(mgmt, 0, hdr_len);
@@ -153,7 +156,7 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 		break;
 	default:
 		kfree_skb(skb);
-		return -ENOTSUPP;
+		return NULL;
 	}
 	*pos++ = ie_len;
 	*pos++ = flags;
@@ -192,10 +195,72 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 		pos += 4;
 	}
 
-	ieee80211_tx_skb(sdata, skb);
-	return 0;
+	return skb;
+}
+
+static void mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
+				   const u8 *orig_addr, u32 orig_sn,
+				   u8 target_flags, const u8 *target,
+				   u32 target_sn, const u8 *da,
+				   u8 hop_count, u8 ttl,
+				   u32 lifetime, u32 metric, u32 preq_id,
+				   struct ieee80211_sub_if_data *sdata)
+{
+	struct sk_buff *skb = alloc_mesh_path_sel_frame(action, flags,
+			orig_addr, orig_sn, target_flags, target, target_sn,
+			da, hop_count, ttl, lifetime, metric, preq_id, sdata);
+	if (skb)
+		ieee80211_tx_skb(sdata, skb);
 }
 
+static void mesh_path_sel_frame_tx_jittered(enum mpath_frame_type action,
+					    u8 flags, const u8 *orig_addr,
+					    u32 orig_sn, u8 target_flags,
+					    const u8 *target, u32 target_sn,
+					    const u8 *da, u8 hop_count, u8 ttl,
+					    u32 lifetime, u32 metric,
+					    u32 preq_id,
+					    struct ieee80211_sub_if_data *sdata)
+{
+	u32 jitter;
+	struct sk_buff *skb = alloc_mesh_path_sel_frame(action, flags,
+							orig_addr, orig_sn,
+							target_flags, target,
+							target_sn, da,
+							hop_count, ttl,
+							lifetime, metric,
+							preq_id, sdata);
+	if (skb) {
+		struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+		struct mesh_tx_queue *tx_node = kmalloc(
+				sizeof(struct mesh_tx_queue), GFP_ATOMIC);
+		if (!tx_node) {
+			mhwmp_dbg(sdata, "could not allocate mesh_hwmp tx node");
+			return;
+		}
+
+		spin_lock_bh(&ifmsh->mesh_tx_queue_lock);
+		if (ifmsh->tx_queue_len == MAX_TX_QUEUE_LEN) {
+			spin_unlock_bh(&ifmsh->mesh_tx_queue_lock);
+			kfree(tx_node);
+			kfree_skb(skb);
+			if (printk_ratelimit())
+				mhwmp_dbg(sdata, "mesh_hwmp tx node queue full");
+			return;
+		}
+
+		tx_node->skb = skb;
+		list_add_tail(&tx_node->list, &ifmsh->tx_queue.list);
+		++ifmsh->tx_queue_len;
+		spin_unlock_bh(&ifmsh->mesh_tx_queue_lock);
+
+		jitter = prandom_u32() % 25;
+
+		ieee80211_queue_delayed_work(
+				&sdata->local->hw,
+			    &sdata->tx_work, msecs_to_jiffies(jitter));
+	}
+}
 
 /*  Headroom is not adjusted.  Caller should ensure that skb has sufficient
  *  headroom in case the frame is encrypted. */
@@ -611,11 +676,13 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 		ttl = ifmsh->mshcfg.element_ttl;
 		if (ttl != 0) {
 			mhwmp_dbg(sdata, "replying to the PREQ\n");
-			mesh_path_sel_frame_tx(MPATH_PREP, 0, orig_addr,
-					       orig_sn, 0, target_addr,
-					       target_sn, mgmt->sa, 0, ttl,
-					       lifetime, target_metric, 0,
-					       sdata);
+			mesh_path_sel_frame_tx_jittered(MPATH_PREP, 0,
+							orig_addr, orig_sn,
+							0, target_addr,
+							target_sn, mgmt->sa,
+							0, ttl, lifetime,
+							target_metric, 0,
+							sdata);
 		} else {
 			ifmsh->mshstats.dropped_frames_ttl++;
 		}
@@ -643,10 +710,11 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 			target_sn = PREQ_IE_TARGET_SN(preq_elem);
 		}
 
-		mesh_path_sel_frame_tx(MPATH_PREQ, flags, orig_addr,
-				       orig_sn, target_flags, target_addr,
-				       target_sn, da, hopcount, ttl, lifetime,
-				       orig_metric, preq_id, sdata);
+		mesh_path_sel_frame_tx_jittered(MPATH_PREQ, flags, orig_addr,
+						orig_sn, target_flags,
+						target_addr, target_sn, da,
+						hopcount, ttl, lifetime,
+						orig_metric, preq_id, sdata);
 		if (!is_multicast_ether_addr(da))
 			ifmsh->mshstats.fwded_unicast++;
 		else
@@ -712,9 +780,10 @@ static void hwmp_prep_frame_process(struct ieee80211_sub_if_data *sdata,
 	target_sn = PREP_IE_TARGET_SN(prep_elem);
 	orig_sn = PREP_IE_ORIG_SN(prep_elem);
 
-	mesh_path_sel_frame_tx(MPATH_PREP, flags, orig_addr, orig_sn, 0,
-			       target_addr, target_sn, next_hop, hopcount,
-			       ttl, lifetime, metric, 0, sdata);
+	mesh_path_sel_frame_tx_jittered(MPATH_PREP, flags, orig_addr, orig_sn,
+					0, target_addr, target_sn, next_hop,
+					hopcount, ttl, lifetime, metric, 0,
+					sdata);
 	rcu_read_unlock();
 
 	sdata->u.mesh.mshstats.fwded_unicast++;
@@ -864,10 +933,11 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 	ttl--;
 
 	if (ifmsh->mshcfg.dot11MeshForwarding) {
-		mesh_path_sel_frame_tx(MPATH_RANN, flags, orig_addr,
-				       orig_sn, 0, NULL, 0, broadcast_addr,
-				       hopcount, ttl, interval,
-				       metric + metric_txsta, 0, sdata);
+		mesh_path_sel_frame_tx_jittered(MPATH_RANN, flags, orig_addr,
+						orig_sn, 0, NULL, 0,
+						broadcast_addr, hopcount, ttl,
+						interval, metric + metric_txsta,
+						0, sdata);
 	}
 
 	rcu_read_unlock();
