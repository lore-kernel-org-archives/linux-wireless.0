Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f190.google.com ([209.85.216.190]:57543 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbZGGBBE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 21:01:04 -0400
Received: by pxi28 with SMTP id 28so3894879pxi.33
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jul 2009 18:01:08 -0700 (PDT)
From: javier@cozybit.com
To: linux-wireless@vger.kernel.org
Cc: devel@lists.open80211s.org, johannes@sipsolutions.net,
	Javier Cardona <javier@cozybit.com>,
	Andrey Yurovsky <andrey@cozybit.com>
Subject: [PATCH] Fix regression in mesh forwarding path.
Date: Mon,  6 Jul 2009 17:52:21 -0700
Message-Id: <1246927941-27148-1-git-send-email-javier@cozybit.com>
In-Reply-To: <1246927662-25461-1-git-send-email-javier@cozybit.com>
References: <1246927662-25461-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

The removal of the master netdev broke the mesh forwarding path.  This patch
fixes it by using the new internal 'pending' queue.

As a result of this change, mesh forwarding no longer does the inefficient
802.11 -> 802.3 -> 802.11 conversion that was done before.

Signed-off-by: Javier Cardona <javier@cozybit.com>
Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
---
 net/mac80211/mesh_hwmp.c    |    3 ++-
 net/mac80211/mesh_pathtbl.c |    7 +++++--
 net/mac80211/rx.c           |   17 +++++++++++++++--
 net/mac80211/tx.c           |    3 ---
 4 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index f49ef28..c31fe79 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -784,7 +784,6 @@ int mesh_nexthop_lookup(struct sk_buff *skb,
 		mesh_path_add(dst_addr, sdata);
 		mpath = mesh_path_lookup(dst_addr, sdata);
 		if (!mpath) {
-			dev_kfree_skb(skb);
 			sdata->u.mesh.mshstats.dropped_frames_no_route++;
 			err = -ENOSPC;
 			goto endlookup;
@@ -804,6 +803,7 @@ int mesh_nexthop_lookup(struct sk_buff *skb,
 		memcpy(hdr->addr1, mpath->next_hop->sta.addr,
 				ETH_ALEN);
 	} else {
+		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 		if (!(mpath->flags & MESH_PATH_RESOLVING)) {
 			/* Start discovery only if it is not running yet */
 			mesh_queue_preq(mpath, PREQ_Q_F_START);
@@ -815,6 +815,7 @@ int mesh_nexthop_lookup(struct sk_buff *skb,
 			skb_unlink(skb_to_free, &mpath->frame_queue);
 		}
 
+		info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
 		skb_queue_tail(&mpath->frame_queue, skb);
 		if (skb_to_free)
 			mesh_path_discard_frame(skb_to_free, sdata);
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 3c72557..ac7d823 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -14,6 +14,7 @@
 #include <linux/string.h>
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
+#include "wme.h"
 #include "mesh.h"
 
 /* There will be initially 2^INIT_PATHS_SIZE_ORDER buckets */
@@ -481,8 +482,10 @@ void mesh_path_tx_pending(struct mesh_path *mpath)
 	struct sk_buff *skb;
 
 	while ((skb = skb_dequeue(&mpath->frame_queue)) &&
-			(mpath->flags & MESH_PATH_ACTIVE))
-		dev_queue_xmit(skb);
+			(mpath->flags & MESH_PATH_ACTIVE)) {
+		ieee80211_select_queue(mpath->sdata->local, skb);
+		ieee80211_add_pending_skb(mpath->sdata->local, skb);
+	}
 }
 
 /**
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 91747be..e3b58a4 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1485,10 +1485,12 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	unsigned int hdrlen;
 	struct sk_buff *skb = rx->skb, *fwd_skb;
 	struct ieee80211_local *local = rx->local;
+	struct ieee80211_sub_if_data *sdata;
 
 	hdr = (struct ieee80211_hdr *) skb->data;
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	mesh_hdr = (struct ieee80211s_hdr *) (skb->data + hdrlen);
+	sdata = IEEE80211_DEV_TO_SUB_IF(rx->dev);
 
 	if (!ieee80211_is_data(hdr->frame_control))
 		return RX_CONTINUE;
@@ -1498,10 +1500,8 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 		return RX_DROP_MONITOR;
 
 	if (mesh_hdr->flags & MESH_FLAGS_AE_A5_A6){
-		struct ieee80211_sub_if_data *sdata;
 		struct mesh_path *mppath;
 
-		sdata = IEEE80211_DEV_TO_SUB_IF(rx->dev);
 		rcu_read_lock();
 		mppath = mpp_path_lookup(mesh_hdr->eaddr2, sdata);
 		if (!mppath) {
@@ -1546,6 +1546,19 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 			memset(info, 0, sizeof(*info));
 			info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
 			fwd_skb->iif = rx->dev->ifindex;
+			if (is_multicast_ether_addr(fwd_hdr->addr3))
+				memcpy(fwd_hdr->addr1, fwd_hdr->addr3,
+						ETH_ALEN);
+			else {
+				int err = mesh_nexthop_lookup(fwd_skb, sdata);
+				/* Failed to immediately resolve next hop:
+				 * fwded frame was dropped or will be added
+				 * later to the pending skb queue.  */
+				if (err)
+					return RX_DROP_MONITOR;
+			}
+			IEEE80211_IFSTA_MESH_CTR_INC(&sdata->u.mesh,
+						     fwded_frames);
 			ieee80211_select_queue(local, fwd_skb);
 			ieee80211_add_pending_skb(local, fwd_skb);
 		}
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 66d9a42..969a4b2 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1399,9 +1399,6 @@ static void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
 				dev_put(sdata->dev);
 				return;
 			}
-		if (memcmp(sdata->dev->dev_addr, hdr->addr4, ETH_ALEN) != 0)
-			IEEE80211_IFSTA_MESH_CTR_INC(&sdata->u.mesh,
-						     fwded_frames);
 	} else if (unlikely(sdata->vif.type == NL80211_IFTYPE_MONITOR)) {
 		int hdrlen;
 		u16 len_rthdr;
-- 
1.5.4.3

