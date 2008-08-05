Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:36507 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622AbYHFPEr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 11:04:47 -0400
Received: by yx-out-2324.google.com with SMTP id 8so317572yxm.1
        for <linux-wireless@vger.kernel.org>; Wed, 06 Aug 2008 08:04:47 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Tue, 5 Aug 2008 19:34:52 +0200
Subject: [PATCH v3] mac80211: fix use of skb->cb for mesh forwarding
Message-ID: <4899bd8d.1dbf7e0a.351c.5d69@mx.google.com> (sfid-20080806_170452_088557_73A11FC4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now we deal with mesh forwarding before the 802.11->802.3 conversion, thus
eliminating a few unnecessary steps. The next hop lookup is called from
ieee80211_master_start_xmit() instead of subif_start_xmit(). Until the next hop
is found, RA in the frame will be all zeroes for frames originating from the
device. For forwarded frames, RA will contain the TA of the received frame,
which will be necessary to send a path error if a next hop is not found.

Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 net/mac80211/mesh.h         |    5 +--
 net/mac80211/mesh_hwmp.c    |   19 ++++---
 net/mac80211/mesh_pathtbl.c |   11 ++---
 net/mac80211/rx.c           |  116 +++++++++++++++++++++++++------------------
 net/mac80211/tx.c           |   45 +++++++++--------
 5 files changed, 106 insertions(+), 90 deletions(-)

diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 669eafa..7495fbb 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -214,8 +214,7 @@ void ieee80211s_stop(void);
 void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata);
 
 /* Mesh paths */
-int mesh_nexthop_lookup(u8 *next_hop, struct sk_buff *skb,
-		struct net_device *dev);
+int mesh_nexthop_lookup(struct sk_buff *skb, struct net_device *dev);
 void mesh_path_start_discovery(struct net_device *dev);
 struct mesh_path *mesh_path_lookup(u8 *dst, struct net_device *dev);
 struct mesh_path *mesh_path_lookup_by_idx(int idx, struct net_device *dev);
@@ -286,6 +285,4 @@ static inline void mesh_path_activate(struct mesh_path *mpath)
 #define mesh_allocated	0
 #endif
 
-#define MESH_PREQ(skb)	(skb->cb + 30)
-
 #endif /* IEEE80211S_H */
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 7fa149e..08aca44 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -758,29 +758,30 @@ enddiscovery:
 /**
  * ieee80211s_lookup_nexthop - put the appropriate next hop on a mesh frame
  *
- * @next_hop: output argument for next hop address
- * @skb: frame to be sent
+ * @skb: 802.11 frame to be sent
  * @dev: network device the frame will be sent through
+ * @fwd_frame: true if this frame was originally from a different host
  *
  * Returns: 0 if the next hop was found. Nonzero otherwise. If no next hop is
  * found, the function will start a path discovery and queue the frame so it is
  * sent when the path is resolved. This means the caller must not free the skb
  * in this case.
  */
-int mesh_nexthop_lookup(u8 *next_hop, struct sk_buff *skb,
-		struct net_device *dev)
+int mesh_nexthop_lookup(struct sk_buff *skb, struct net_device *dev)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct sk_buff *skb_to_free = NULL;
 	struct mesh_path *mpath;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	u8 *dst_addr = hdr->addr3;
 	int err = 0;
 
 	rcu_read_lock();
-	mpath = mesh_path_lookup(skb->data, dev);
+	mpath = mesh_path_lookup(dst_addr, dev);
 
 	if (!mpath) {
-		mesh_path_add(skb->data, dev);
-		mpath = mesh_path_lookup(skb->data, dev);
+		mesh_path_add(dst_addr, dev);
+		mpath = mesh_path_lookup(dst_addr, dev);
 		if (!mpath) {
 			dev_kfree_skb(skb);
 			sdata->u.sta.mshstats.dropped_frames_no_route++;
@@ -792,13 +793,13 @@ int mesh_nexthop_lookup(u8 *next_hop, struct sk_buff *skb,
 	if (mpath->flags & MESH_PATH_ACTIVE) {
 		if (time_after(jiffies, mpath->exp_time -
 			msecs_to_jiffies(sdata->u.sta.mshcfg.path_refresh_time))
-				&& skb->pkt_type != PACKET_OTHERHOST
+				&& !memcmp(dev->dev_addr, hdr->addr4, ETH_ALEN)
 				&& !(mpath->flags & MESH_PATH_RESOLVING)
 				&& !(mpath->flags & MESH_PATH_FIXED)) {
 			mesh_queue_preq(mpath,
 					PREQ_Q_F_START | PREQ_Q_F_REFRESH);
 		}
-		memcpy(next_hop, mpath->next_hop->addr,
+		memcpy(hdr->addr1, mpath->next_hop->addr,
 				ETH_ALEN);
 	} else {
 		if (!(mpath->flags & MESH_PATH_RESOLVING)) {
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 5f88a2e..838ee60 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -388,18 +388,15 @@ void mesh_path_tx_pending(struct mesh_path *mpath)
 void mesh_path_discard_frame(struct sk_buff *skb, struct net_device *dev)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct mesh_path *mpath;
 	u32 dsn = 0;
 
-	if (skb->pkt_type == PACKET_OTHERHOST) {
-		struct ieee80211s_hdr *prev_meshhdr;
-		int mshhdrlen;
+	if (memcmp(hdr->addr4, dev->dev_addr, ETH_ALEN) != 0) {
 		u8 *ra, *da;
 
-		prev_meshhdr = ((struct ieee80211s_hdr *)skb->cb);
-		mshhdrlen = ieee80211_get_mesh_hdrlen(prev_meshhdr);
-		da = skb->data;
-		ra = MESH_PREQ(skb);
+		da = hdr->addr3;
+		ra = hdr->addr2;
 		mpath = mesh_path_lookup(da, dev);
 		if (mpath)
 			dsn = ++mpath->dsn;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index a67ded3..60e9ea1 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1114,20 +1114,9 @@ ieee80211_data_to_8023(struct ieee80211_rx_data *rx)
 
 	hdrlen = ieee80211_get_hdrlen(fc);
 
-	if (ieee80211_vif_is_mesh(&sdata->vif)) {
-		int meshhdrlen = ieee80211_get_mesh_hdrlen(
+	if (ieee80211_vif_is_mesh(&sdata->vif))
+		hdrlen += ieee80211_get_mesh_hdrlen(
 				(struct ieee80211s_hdr *) (skb->data + hdrlen));
-		/* Copy on cb:
-		 *  - mesh header: to be used for mesh forwarding
-		 * decision. It will also be used as mesh header template at
-		 * tx.c:ieee80211_subif_start_xmit() if interface
-		 * type is mesh and skb->pkt_type == PACKET_OTHERHOST
-		 *  - ta: to be used if a RERR needs to be sent.
-		 */
-		memcpy(skb->cb, skb->data + hdrlen, meshhdrlen);
-		memcpy(MESH_PREQ(skb), hdr->addr2, ETH_ALEN);
-		hdrlen += meshhdrlen;
-	}
 
 	/* convert IEEE 802.11 header + possible LLC headers into Ethernet
 	 * header
@@ -1274,38 +1263,6 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 		}
 	}
 
-	/* Mesh forwarding */
-	if (ieee80211_vif_is_mesh(&sdata->vif)) {
-		u8 *mesh_ttl = &((struct ieee80211s_hdr *)skb->cb)->ttl;
-		(*mesh_ttl)--;
-
-		if (is_multicast_ether_addr(skb->data)) {
-			if (*mesh_ttl > 0) {
-				xmit_skb = skb_copy(skb, GFP_ATOMIC);
-				if (xmit_skb)
-					xmit_skb->pkt_type = PACKET_OTHERHOST;
-				else if (net_ratelimit())
-					printk(KERN_DEBUG "%s: failed to clone "
-					       "multicast frame\n", dev->name);
-			} else
-				IEEE80211_IFSTA_MESH_CTR_INC(&sdata->u.sta,
-							     dropped_frames_ttl);
-		} else if (skb->pkt_type != PACKET_OTHERHOST &&
-			compare_ether_addr(dev->dev_addr, skb->data) != 0) {
-			if (*mesh_ttl == 0) {
-				IEEE80211_IFSTA_MESH_CTR_INC(&sdata->u.sta,
-							     dropped_frames_ttl);
-				dev_kfree_skb(skb);
-				skb = NULL;
-			} else {
-				xmit_skb = skb;
-				xmit_skb->pkt_type = PACKET_OTHERHOST;
-				if (!(dev->flags & IFF_PROMISC))
-					skb  = NULL;
-			}
-		}
-	}
-
 	if (skb) {
 		/* deliver to local stack */
 		skb->protocol = eth_type_trans(skb, dev);
@@ -1436,6 +1393,63 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
 }
 
 static ieee80211_rx_result debug_noinline
+ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
+{
+	struct ieee80211_hdr *hdr;
+	struct ieee80211s_hdr *mesh_hdr;
+	unsigned int hdrlen;
+	struct sk_buff *skb = rx->skb, *fwd_skb;
+
+	hdr = (struct ieee80211_hdr *) skb->data;
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	mesh_hdr = (struct ieee80211s_hdr *) (skb->data + hdrlen);
+
+	if (!ieee80211_is_data(hdr->frame_control))
+		return RX_CONTINUE;
+
+	if (!mesh_hdr->ttl)
+		/* illegal frame */
+		return RX_DROP_MONITOR;
+
+	if (compare_ether_addr(rx->dev->dev_addr, hdr->addr3) == 0)
+		return RX_CONTINUE;
+
+	mesh_hdr->ttl--;
+
+	if (rx->flags & IEEE80211_RX_RA_MATCH) {
+		if (!mesh_hdr->ttl)
+			IEEE80211_IFSTA_MESH_CTR_INC(&rx->sdata->u.sta,
+						     dropped_frames_ttl);
+		else {
+			struct ieee80211_hdr *fwd_hdr;
+			fwd_skb = skb_copy(skb, GFP_ATOMIC);
+
+			if (!fwd_skb && net_ratelimit())
+				printk(KERN_DEBUG "%s: failed to clone mesh frame\n",
+						   rx->dev->name);
+
+			fwd_hdr =  (struct ieee80211_hdr *) fwd_skb->data;
+			/*
+			 * Save TA to addr1 to send TA a path error if a
+			 * suitable next hop is not found
+			 */
+			memcpy(fwd_hdr->addr1, fwd_hdr->addr2, ETH_ALEN);
+			memcpy(fwd_hdr->addr2, rx->dev->dev_addr, ETH_ALEN);
+			fwd_skb->dev = rx->local->mdev;
+			fwd_skb->iif = rx->dev->ifindex;
+			dev_queue_xmit(fwd_skb);
+		}
+	}
+
+	if (is_multicast_ether_addr(hdr->addr3) ||
+	    rx->dev->flags & IFF_PROMISC)
+		return RX_CONTINUE;
+	else
+		return RX_DROP_MONITOR;
+}
+
+
+static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 {
 	struct net_device *dev = rx->dev;
@@ -1668,10 +1682,12 @@ static void ieee80211_invoke_rx_handlers(struct ieee80211_sub_if_data *sdata,
 	rx->sdata = sdata;
 	rx->dev = sdata->dev;
 
-#define CALL_RXH(rxh)		\
-	res = rxh(rx);		\
-	if (res != RX_CONTINUE)	\
-		goto rxh_done;
+#define CALL_RXH(rxh)			\
+	do {				\
+		res = rxh(rx);		\
+		if (res != RX_CONTINUE)	\
+			goto rxh_done;  \
+	} while (0);
 
 	CALL_RXH(ieee80211_rx_h_passive_scan)
 	CALL_RXH(ieee80211_rx_h_check)
@@ -1683,6 +1699,8 @@ static void ieee80211_invoke_rx_handlers(struct ieee80211_sub_if_data *sdata,
 	/* must be after MMIC verify so header is counted in MPDU mic */
 	CALL_RXH(ieee80211_rx_h_remove_qos_control)
 	CALL_RXH(ieee80211_rx_h_amsdu)
+	if (ieee80211_vif_is_mesh(&sdata->vif))
+		CALL_RXH(ieee80211_rx_h_mesh_fwding);
 	CALL_RXH(ieee80211_rx_h_data)
 	CALL_RXH(ieee80211_rx_h_ctrl)
 	CALL_RXH(ieee80211_rx_h_mgmt)
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 771ec68..4788f7b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1301,6 +1301,7 @@ int ieee80211_master_start_xmit(struct sk_buff *skb,
 				struct net_device *dev)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct net_device *odev = NULL;
 	struct ieee80211_sub_if_data *osdata;
 	int headroom;
@@ -1328,6 +1329,20 @@ int ieee80211_master_start_xmit(struct sk_buff *skb,
 
 	osdata = IEEE80211_DEV_TO_SUB_IF(odev);
 
+	if (ieee80211_vif_is_mesh(&osdata->vif) &&
+	    ieee80211_is_data(hdr->frame_control)) {
+		if (ieee80211_is_data(hdr->frame_control)) {
+			if (is_multicast_ether_addr(hdr->addr3))
+				memcpy(hdr->addr1, hdr->addr3, ETH_ALEN);
+			else
+				if (mesh_nexthop_lookup(skb, odev))
+					return  0;
+			if (memcmp(odev->dev_addr, hdr->addr4, ETH_ALEN) != 0)
+				IEEE80211_IFSTA_MESH_CTR_INC(&osdata->u.sta,
+							     fwded_frames);
+		}
+	}
+
 	may_encrypt = !skb->do_not_encrypt;
 
 	headroom = osdata->local->tx_headroom;
@@ -1472,30 +1487,17 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
 	case IEEE80211_IF_TYPE_MESH_POINT:
 		fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS);
 		/* RA TA DA SA */
-		if (is_multicast_ether_addr(skb->data))
-			memcpy(hdr.addr1, skb->data, ETH_ALEN);
-		else if (mesh_nexthop_lookup(hdr.addr1, skb, dev))
-				return 0;
+		memset(hdr.addr1, 0, ETH_ALEN);
 		memcpy(hdr.addr2, dev->dev_addr, ETH_ALEN);
 		memcpy(hdr.addr3, skb->data, ETH_ALEN);
 		memcpy(hdr.addr4, skb->data + ETH_ALEN, ETH_ALEN);
-		if (skb->pkt_type == PACKET_OTHERHOST) {
-			/* Forwarded frame, keep mesh ttl and seqnum */
-			struct ieee80211s_hdr *prev_meshhdr;
-			prev_meshhdr = ((struct ieee80211s_hdr *)skb->cb);
-			meshhdrlen = ieee80211_get_mesh_hdrlen(prev_meshhdr);
-			memcpy(&mesh_hdr, prev_meshhdr, meshhdrlen);
-			sdata->u.sta.mshstats.fwded_frames++;
-		} else {
-			if (!sdata->u.sta.mshcfg.dot11MeshTTL) {
-				/* Do not send frames with mesh_ttl == 0 */
-				sdata->u.sta.mshstats.dropped_frames_ttl++;
-				ret = 0;
-				goto fail;
-			}
-			meshhdrlen = ieee80211_new_mesh_header(&mesh_hdr,
-							       sdata);
+		if (!sdata->u.sta.mshcfg.dot11MeshTTL) {
+			/* Do not send frames with mesh_ttl == 0 */
+			sdata->u.sta.mshstats.dropped_frames_ttl++;
+			ret = 0;
+			goto fail;
 		}
+		meshhdrlen = ieee80211_new_mesh_header(&mesh_hdr, sdata);
 		hdrlen = 30;
 		break;
 #endif
@@ -1543,7 +1545,8 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
 	 * Drop unicast frames to unauthorised stations unless they are
 	 * EAPOL frames from the local station.
 	 */
-	if (unlikely(!is_multicast_ether_addr(hdr.addr1) &&
+	if (!ieee80211_vif_is_mesh(&sdata->vif) &&
+		unlikely(!is_multicast_ether_addr(hdr.addr1) &&
 		      !(sta_flags & WLAN_STA_AUTHORIZED) &&
 		      !(ethertype == ETH_P_PAE &&
 		       compare_ether_addr(dev->dev_addr,
-- 
1.5.4.3



