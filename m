Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48154 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194Ab1KBT1k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Nov 2011 15:27:40 -0400
Received: by vcge1 with SMTP id e1so482274vcg.19
        for <linux-wireless@vger.kernel.org>; Wed, 02 Nov 2011 12:27:39 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH v3 4/4] mac80211: Populate QoS header on mesh frames sent to gates.
Date: Wed,  2 Nov 2011 12:27:27 -0700
Message-Id: <1320262047-5389-4-git-send-email-thomas@cozybit.com> (sfid-20111102_202757_472181_C91850F8)
In-Reply-To: <1320262047-5389-1-git-send-email-thomas@cozybit.com>
References: <1320262047-5389-1-git-send-email-thomas@cozybit.com>
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
index b22b223..c4d8efe 100644
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
index 45ace14..302c866 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1965,12 +1965,10 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
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
@@ -1991,6 +1989,10 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
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

