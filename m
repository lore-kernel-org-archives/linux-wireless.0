Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54099 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436Ab1KWUcv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 15:32:51 -0500
Received: by mail-yx0-f174.google.com with SMTP id q3so1826068yen.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Nov 2011 12:32:51 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: devel@lists.open80211s.org, Thomas Pedersen <thomas@cozybit.com>,
	johannes@sipsolutions.net, linville@tuxdriver.com
Subject: [PATCH 6/7] mac80211: don't initiate path discovery when forwarding frame with unknown DA
Date: Wed, 23 Nov 2011 12:32:25 -0800
Message-Id: <1322080347-7644-7-git-send-email-thomas@cozybit.com> (sfid-20111123_213256_276901_BDFC7A24)
In-Reply-To: <1322080347-7644-1-git-send-email-thomas@cozybit.com>
References: <1322080347-7644-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We used to initiate a path discovery when receiving a frame for which
there is no forwarding information. To cut down on PREQ spam, just send
a (gated) PERR in response.

Also separate path discovery logic from nexthop querying. This patch
means we no longer queue frames when forwarding, so kill the PERR TX
stuff in discard_frame().

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh.h         |    2 +
 net/mac80211/mesh_hwmp.c    |  111 ++++++++++++++++++++++++++-----------------
 net/mac80211/mesh_pathtbl.c |   27 ----------
 net/mac80211/rx.c           |   14 +++--
 net/mac80211/tx.c           |    2 +-
 5 files changed, 79 insertions(+), 77 deletions(-)

diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 622cc96..bd14bd2 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -233,6 +233,8 @@ void ieee80211_mesh_root_setup(struct ieee80211_if_mesh *ifmsh);
 /* Mesh paths */
 int mesh_nexthop_lookup(struct sk_buff *skb,
 		struct ieee80211_sub_if_data *sdata);
+int mesh_nexthop_resolve(struct sk_buff *skb,
+			 struct ieee80211_sub_if_data *sdata);
 void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata);
 struct mesh_path *mesh_path_lookup(u8 *dst,
 		struct ieee80211_sub_if_data *sdata);
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index fe93386..73abb75 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -982,72 +982,97 @@ enddiscovery:
 	kfree(preq_node);
 }
 
-/**
- * mesh_nexthop_lookup - put the appropriate next hop on a mesh frame
+/* mesh_nexthop_resolve - lookup next hop for given skb and start path
+ * discovery if no forwarding information is found.
  *
  * @skb: 802.11 frame to be sent
  * @sdata: network subif the frame will be sent through
  *
- * Returns: 0 if the next hop was found. Nonzero otherwise. If no next hop is
- * found, the function will start a path discovery and queue the frame so it is
- * sent when the path is resolved. This means the caller must not free the skb
- * in this case.
+ * Returns: 0 if the next hop was found and -ENOENT if the frame was queued.
+ * skb is freeed here if no mpath could be allocated.
  */
-int mesh_nexthop_lookup(struct sk_buff *skb,
-			struct ieee80211_sub_if_data *sdata)
+int mesh_nexthop_resolve(struct sk_buff *skb,
+			 struct ieee80211_sub_if_data *sdata)
 {
-	struct sk_buff *skb_to_free = NULL;
-	struct mesh_path *mpath;
-	struct sta_info *next_hop;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct mesh_path *mpath;
+	struct sk_buff *skb_to_free = NULL;
 	u8 *target_addr = hdr->addr3;
 	int err = 0;
 
 	rcu_read_lock();
-	mpath = mesh_path_lookup(target_addr, sdata);
+	err = mesh_nexthop_lookup(skb, sdata);
+	if (!err)
+		goto endlookup;
 
+	/* no nexthop found, start resolving */
+	mpath = mesh_path_lookup(target_addr, sdata);
 	if (!mpath) {
 		mesh_path_add(target_addr, sdata);
 		mpath = mesh_path_lookup(target_addr, sdata);
 		if (!mpath) {
-			sdata->u.mesh.mshstats.dropped_frames_no_route++;
+			mesh_path_discard_frame(skb, sdata);
 			err = -ENOSPC;
 			goto endlookup;
 		}
 	}
 
-	if (mpath->flags & MESH_PATH_ACTIVE) {
-		if (time_after(jiffies,
-			       mpath->exp_time -
-			       msecs_to_jiffies(sdata->u.mesh.mshcfg.path_refresh_time)) &&
-		    !memcmp(sdata->vif.addr, hdr->addr4, ETH_ALEN) &&
-		    !(mpath->flags & MESH_PATH_RESOLVING) &&
-		    !(mpath->flags & MESH_PATH_FIXED)) {
-			mesh_queue_preq(mpath,
-					PREQ_Q_F_START | PREQ_Q_F_REFRESH);
-		}
-		next_hop = rcu_dereference(mpath->next_hop);
-		if (next_hop) {
-			memcpy(hdr->addr1, next_hop->sta.addr, ETH_ALEN);
-			memcpy(hdr->addr2, sdata->vif.addr, ETH_ALEN);
-		} else
-			err = -ENOENT;
-	} else {
-		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-		if (!(mpath->flags & MESH_PATH_RESOLVING)) {
-			/* Start discovery only if it is not running yet */
-			mesh_queue_preq(mpath, PREQ_Q_F_START);
-		}
+	if (!(mpath->flags & MESH_PATH_RESOLVING))
+		mesh_queue_preq(mpath, PREQ_Q_F_START);
+
+	if (skb_queue_len(&mpath->frame_queue) >= MESH_FRAME_QUEUE_LEN)
+		skb_to_free = skb_dequeue(&mpath->frame_queue);
+
+	info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
+	ieee80211_set_qos_hdr(sdata, skb);
+	skb_queue_tail(&mpath->frame_queue, skb);
+	err = -ENOENT;
+	if (skb_to_free)
+		mesh_path_discard_frame(skb_to_free, sdata);
+
+endlookup:
+	rcu_read_unlock();
+	return err;
+}
+/**
+ * mesh_nexthop_lookup - put the appropriate next hop on a mesh frame. Calling
+ * this function is considered "using" the associated mpath, so preempt a path
+ * refresh if this mpath expires soon.
+ *
+ * @skb: 802.11 frame to be sent
+ * @sdata: network subif the frame will be sent through
+ *
+ * Returns: 0 if the next hop was found. Nonzero otherwise.
+ */
+int mesh_nexthop_lookup(struct sk_buff *skb,
+			struct ieee80211_sub_if_data *sdata)
+{
+	struct mesh_path *mpath;
+	struct sta_info *next_hop;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	u8 *target_addr = hdr->addr3;
+	int err = -ENOENT;
 
-		if (skb_queue_len(&mpath->frame_queue) >= MESH_FRAME_QUEUE_LEN)
-			skb_to_free = skb_dequeue(&mpath->frame_queue);
+	rcu_read_lock();
+	mpath = mesh_path_lookup(target_addr, sdata);
+
+	if (!mpath || !(mpath->flags & MESH_PATH_ACTIVE))
+		goto endlookup;
+
+	if (time_after(jiffies,
+		       mpath->exp_time -
+		       msecs_to_jiffies(sdata->u.mesh.mshcfg.path_refresh_time)) &&
+	    !memcmp(sdata->vif.addr, hdr->addr4, ETH_ALEN) &&
+	    !(mpath->flags & MESH_PATH_RESOLVING) &&
+	    !(mpath->flags & MESH_PATH_FIXED))
+		mesh_queue_preq(mpath, PREQ_Q_F_START | PREQ_Q_F_REFRESH);
 
-		info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
-		ieee80211_set_qos_hdr(sdata, skb);
-		skb_queue_tail(&mpath->frame_queue, skb);
-		if (skb_to_free)
-			mesh_path_discard_frame(skb_to_free, sdata);
-		err = -ENOENT;
+	next_hop = rcu_dereference(mpath->next_hop);
+	if (next_hop) {
+		memcpy(hdr->addr1, next_hop->sta.addr, ETH_ALEN);
+		memcpy(hdr->addr2, sdata->vif.addr, ETH_ALEN);
+		err = 0;
 	}
 
 endlookup:
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 4c50d8a..edf167e 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -973,38 +973,11 @@ int mesh_path_send_to_gates(struct mesh_path *mpath)
  * @skb: frame to discard
  * @sdata: network subif the frame was to be sent through
  *
- * If the frame was being forwarded from another MP, a PERR frame will be sent
- * to the precursor.  The precursor's address (i.e. the previous hop) was saved
- * in addr1 of the frame-to-be-forwarded, and would only be overwritten once
- * the destination is successfully resolved.
- *
  * Locking: the function must me called within a rcu_read_lock region
  */
 void mesh_path_discard_frame(struct sk_buff *skb,
 			     struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	struct mesh_path *mpath;
-	u32 sn = 0;
-	__le16 reason = cpu_to_le16(WLAN_REASON_MESH_PATH_NOFORWARD);
-
-	if (memcmp(hdr->addr4, sdata->vif.addr, ETH_ALEN) != 0) {
-		u8 *ra, *da;
-
-		da = hdr->addr3;
-		ra = hdr->addr2;
-		rcu_read_lock();
-		mpath = mesh_path_lookup(da, sdata);
-		if (mpath) {
-			spin_lock_bh(&mpath->state_lock);
-			sn = ++mpath->sn;
-			spin_unlock_bh(&mpath->state_lock);
-		}
-		rcu_read_unlock();
-		mesh_path_error_tx(sdata->u.mesh.mshcfg.element_ttl, da,
-				   cpu_to_le32(sn), reason, ra, sdata);
-	}
-
 	kfree_skb(skb);
 	sdata->u.mesh.mshstats.dropped_frames_no_route++;
 }
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 9da4528..ac09f55 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1902,6 +1902,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	struct ieee80211_local *local = rx->local;
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
+	__le16 reason = cpu_to_le16(WLAN_REASON_MESH_PATH_NOFORWARD);
 	u16 q;
 
 	hdr = (struct ieee80211_hdr *) skb->data;
@@ -1988,13 +1989,14 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 								fwded_mcast);
 				memcpy(fwd_hdr->addr2, sdata->vif.addr, ETH_ALEN);
 			} else {
-				int err;
-				err = mesh_nexthop_lookup(fwd_skb, sdata);
-				/* Failed to immediately resolve next hop:
-				 * fwded frame was dropped or will be added
-				 * later to the pending skb queue.  */
-				if (err)
+				if (mesh_nexthop_lookup(fwd_skb, sdata)) {
+				/* can't resolve next hop, send a PERR */
+					mesh_path_error_tx(sdata->u.mesh.mshcfg.element_ttl,
+							   fwd_hdr->addr3, 0, reason,
+							   fwd_hdr->addr2, sdata);
+					sdata->u.mesh.mshstats.dropped_frames_no_route++;
 					return RX_DROP_MONITOR;
+				}
 
 				IEEE80211_IFSTA_MESH_CTR_INC(&sdata->u.mesh,
 								fwded_unicast);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 6ec3194..75eadce 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1459,7 +1459,7 @@ void ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 	if (ieee80211_vif_is_mesh(&sdata->vif) &&
 	    ieee80211_is_data(hdr->frame_control) &&
 		!is_multicast_ether_addr(hdr->addr1))
-			if (mesh_nexthop_lookup(skb, sdata)) {
+			if (mesh_nexthop_resolve(skb, sdata)) {
 				/* skb queued: don't free */
 				rcu_read_unlock();
 				return;
-- 
1.7.5.4

