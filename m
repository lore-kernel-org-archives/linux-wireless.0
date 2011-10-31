Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:39712 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051Ab1JaHMz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Oct 2011 03:12:55 -0400
Received: by mail-pz0-f42.google.com with SMTP id 36so17635694pzk.1
        for <linux-wireless@vger.kernel.org>; Mon, 31 Oct 2011 00:12:55 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH v2 4/4] mac80211: Populate QoS header on mesh frames sent to gates.
Date: Mon, 31 Oct 2011 00:12:41 -0700
Message-Id: <1320045161-16144-4-git-send-email-thomas@cozybit.com> (sfid-20111031_081258_888240_05CBFD97)
In-Reply-To: <1320045161-16144-1-git-send-email-thomas@cozybit.com>
References: <1320045161-16144-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

Also set correct skb queue mapping once next hop is known, and set
txinfo jiffies when forwarding.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh_hwmp.c    |    5 ++++-
 net/mac80211/mesh_pathtbl.c |    5 +++++
 net/mac80211/rx.c           |    8 +++++---
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index b7d9dfd..d46109b 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -1028,8 +1028,11 @@ int mesh_nexthop_lookup(struct sk_buff *skb,
 					PREQ_Q_F_START | PREQ_Q_F_REFRESH);
 		}
 		next_hop = rcu_dereference(mpath->next_hop);
-		if (next_hop)
+		if (next_hop) {
 			memcpy(hdr->addr1, next_hop->sta.addr, ETH_ALEN);
+			skb_set_queue_mapping(skb,
+				ieee80211_select_queue(sdata, skb));
+		}
 		else
 			err = -ENOENT;
 	} else {
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 332b5ff1..9d2f55f 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -270,6 +270,11 @@ static void prepare_for_gate(struct sk_buff *skb, char *dst_addr,
 	memcpy(hdr->addr1, next_hop, ETH_ALEN);
 	rcu_read_unlock();
 	memcpy(hdr->addr3, dst_addr, ETH_ALEN);
+
+	/*  once next hop is set we can set qos header */
+	skb_set_queue_mapping(skb,
+			ieee80211_select_queue(gate_mpath->sdata, skb));
+	ieee80211_set_qos_hdr(gate_mpath->sdata, skb);
 }
 
 /**
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 0995685..00b3db7 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1964,12 +1964,10 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 			memset(info, 0, sizeof(*info));
 			info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
 			info->control.vif = &rx->sdata->vif;
+			info->control.jiffies = jiffies;
 			if (is_multicast_ether_addr(fwd_hdr->addr1)) {
 				IEEE80211_IFSTA_MESH_CTR_INC(&sdata->u.mesh,
 								fwded_mcast);
-				skb_set_queue_mapping(fwd_skb,
-					ieee80211_select_queue(sdata, fwd_skb));
-				ieee80211_set_qos_hdr(sdata, fwd_skb);
 			} else {
 				int err;
 				/*
@@ -1990,6 +1988,10 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 			}
 			IEEE80211_IFSTA_MESH_CTR_INC(&sdata->u.mesh,
 						     fwded_frames);
+
+			/* next hop is now known, update the queue mapping */
+			skb_set_queue_mapping(fwd_skb,
+				ieee80211_select_queue(sdata, fwd_skb));
 			ieee80211_add_pending_skb(local, fwd_skb);
 		}
 	}
-- 
1.7.5.4

