Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43838 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463Ab1KWUcn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 15:32:43 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so2078525iag.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Nov 2011 12:32:43 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: devel@lists.open80211s.org, Thomas Pedersen <thomas@cozybit.com>,
	johannes@sipsolutions.net, linville@tuxdriver.com
Subject: [PATCH 2/7] mac80211: failed forwarded mesh frame addressing
Date: Wed, 23 Nov 2011 12:32:21 -0800
Message-Id: <1322080347-7644-3-git-send-email-thomas@cozybit.com> (sfid-20111123_213247_142222_F0CD24A6)
In-Reply-To: <1322080347-7644-1-git-send-email-thomas@cozybit.com>
References: <1322080347-7644-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't write the TA until next hop is actually known, since we might need
the original TA for sending a PERR. Previously we would send a PERR to
ourself if path resolution for a forwarded frame failed.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh_hwmp.c    |    5 +++--
 net/mac80211/mesh_pathtbl.c |    6 ++++--
 net/mac80211/rx.c           |    8 +-------
 3 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index ce3db27..1b13135 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -1029,9 +1029,10 @@ int mesh_nexthop_lookup(struct sk_buff *skb,
 					PREQ_Q_F_START | PREQ_Q_F_REFRESH);
 		}
 		next_hop = rcu_dereference(mpath->next_hop);
-		if (next_hop)
+		if (next_hop) {
 			memcpy(hdr->addr1, next_hop->sta.addr, ETH_ALEN);
-		else
+			memcpy(hdr->addr2, sdata->vif.addr, ETH_ALEN);
+		} else
 			err = -ENOENT;
 	} else {
 		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 7bd2a76..4c50d8a 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -221,6 +221,7 @@ void mesh_path_assign_nexthop(struct mesh_path *mpath, struct sta_info *sta)
 	while ((skb = __skb_dequeue(&mpath->frame_queue)) != NULL) {
 		hdr = (struct ieee80211_hdr *) skb->data;
 		memcpy(hdr->addr1, sta->sta.addr, ETH_ALEN);
+		memcpy(hdr->addr2, mpath->sdata->vif.addr, ETH_ALEN);
 		__skb_queue_tail(&tmpq, skb);
 	}
 
@@ -264,6 +265,7 @@ static void prepare_for_gate(struct sk_buff *skb, char *dst_addr,
 	next_hop = rcu_dereference(gate_mpath->next_hop)->sta.addr;
 	memcpy(hdr->addr1, next_hop, ETH_ALEN);
 	rcu_read_unlock();
+	memcpy(hdr->addr2, gate_mpath->sdata->vif.addr, ETH_ALEN);
 	memcpy(hdr->addr3, dst_addr, ETH_ALEN);
 }
 
@@ -990,7 +992,7 @@ void mesh_path_discard_frame(struct sk_buff *skb,
 		u8 *ra, *da;
 
 		da = hdr->addr3;
-		ra = hdr->addr1;
+		ra = hdr->addr2;
 		rcu_read_lock();
 		mpath = mesh_path_lookup(da, sdata);
 		if (mpath) {
@@ -999,7 +1001,7 @@ void mesh_path_discard_frame(struct sk_buff *skb,
 			spin_unlock_bh(&mpath->state_lock);
 		}
 		rcu_read_unlock();
-		mesh_path_error_tx(sdata->u.mesh.mshcfg.element_ttl, skb->data,
+		mesh_path_error_tx(sdata->u.mesh.mshcfg.element_ttl, da,
 				   cpu_to_le32(sn), reason, ra, sdata);
 	}
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index d1a8869..eef5302 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1977,7 +1977,6 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 				goto out;
 
 			fwd_hdr =  (struct ieee80211_hdr *) fwd_skb->data;
-			memcpy(fwd_hdr->addr2, sdata->vif.addr, ETH_ALEN);
 			info = IEEE80211_SKB_CB(fwd_skb);
 			memset(info, 0, sizeof(*info));
 			info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
@@ -1986,14 +1985,9 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 			if (is_multicast_ether_addr(fwd_hdr->addr1)) {
 				IEEE80211_IFSTA_MESH_CTR_INC(&sdata->u.mesh,
 								fwded_mcast);
+				memcpy(fwd_hdr->addr2, sdata->vif.addr, ETH_ALEN);
 			} else {
 				int err;
-				/*
-				 * Save TA to addr1 to send TA a path error if a
-				 * suitable next hop is not found
-				 */
-				memcpy(fwd_hdr->addr1, fwd_hdr->addr2,
-						ETH_ALEN);
 				err = mesh_nexthop_lookup(fwd_skb, sdata);
 				/* Failed to immediately resolve next hop:
 				 * fwded frame was dropped or will be added
-- 
1.7.5.4

