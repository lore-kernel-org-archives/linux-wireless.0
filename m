Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40086 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab1KDELc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 00:11:32 -0400
Received: by mail-yw0-f46.google.com with SMTP id 7so2077492ywf.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Nov 2011 21:11:32 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	johannes@sipsolutions.net, linville@tuxdriver.com
Subject: [PATCH v4 4/4] mac80211: simplify mesh frame queue mapping and QoS
Date: Thu,  3 Nov 2011 21:11:13 -0700
Message-Id: <1320379873-30884-4-git-send-email-thomas@cozybit.com> (sfid-20111104_051136_204932_92E7F069)
In-Reply-To: <1320379873-30884-1-git-send-email-thomas@cozybit.com>
References: <1320379873-30884-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

We only need to set the skb queue twice:

1. by the netdev, on local TX.
2. when forwarding a mesh frame.

We only need to set the qos header twice:

1. by mac80211, on local TX.
2. when putting a frame on the mpath->frame_queue

We also don't need the RA in order to set the proper queue mapping since
all mesh STAs are QoS, indicate this and do it once when the frame is
received. Also fixes an issue where the QoS header and queue mapping was not
set for unicast forwarded frames.

Signed-off-by: Javier Cardona <javier@cozybit.com>
Signed-off-by: Thomas Pedersen <thomas@cozybit.com>

---
v4: simplify skb_set_queue and set_qos_hdr calls (Thomas)

I'm sneaking this revision in since John hasn't applied these yet. Sorry for
any inconvenince, but I figured this would be better than submitting a
different patch later which reverts 80% of v3. These
changes take this patch from 14 insertions(+), 4 deletions(-) to:

 net/mac80211/mesh_hwmp.c    |    1 +
 net/mac80211/mesh_pathtbl.c |    3 ---
 net/mac80211/rx.c           |    5 ++---
 net/mac80211/wme.c          |    2 +-
 4 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index b22b223..a7afb2d 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -1043,6 +1043,7 @@ int mesh_nexthop_lookup(struct sk_buff *skb,
 			skb_to_free = skb_dequeue(&mpath->frame_queue);
 
 		info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
+		ieee80211_set_qos_hdr(sdata, skb);
 		skb_queue_tail(&mpath->frame_queue, skb);
 		if (skb_to_free)
 			mesh_path_discard_frame(skb_to_free, sdata);
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 332b5ff1..a861652 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -213,7 +213,6 @@ void mesh_path_assign_nexthop(struct mesh_path *mpath, struct sta_info *sta)
 	struct ieee80211_hdr *hdr;
 	struct sk_buff_head tmpq;
 	unsigned long flags;
-	struct ieee80211_sub_if_data *sdata = mpath->sdata;
 
 	rcu_assign_pointer(mpath->next_hop, sta);
 
@@ -224,8 +223,6 @@ void mesh_path_assign_nexthop(struct mesh_path *mpath, struct sta_info *sta)
 	while ((skb = __skb_dequeue(&mpath->frame_queue)) != NULL) {
 		hdr = (struct ieee80211_hdr *) skb->data;
 		memcpy(hdr->addr1, sta->sta.addr, ETH_ALEN);
-		skb_set_queue_mapping(skb, ieee80211_select_queue(sdata, skb));
-		ieee80211_set_qos_hdr(sdata, skb);
 		__skb_queue_tail(&tmpq, skb);
 	}
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 45ace14..8f11888 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1941,6 +1941,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	    compare_ether_addr(sdata->vif.addr, hdr->addr3) == 0)
 		return RX_CONTINUE;
 
+	skb_set_queue_mapping(skb, ieee80211_select_queue(sdata, skb));
 	mesh_hdr->ttl--;
 
 	if (status->rx_flags & IEEE80211_RX_RA_MATCH) {
@@ -1965,12 +1966,10 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
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
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index a440a4a..c6c5ee8 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -83,7 +83,7 @@ u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 		break;
 #ifdef CONFIG_MAC80211_MESH
 	case NL80211_IFTYPE_MESH_POINT:
-		ra = skb->data;
+		qos = true;
 		break;
 #endif
 	case NL80211_IFTYPE_STATION:
-- 
1.7.5.4

