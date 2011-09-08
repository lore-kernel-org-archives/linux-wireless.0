Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:55031 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757633Ab1IHAuI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 20:50:08 -0400
Received: by mail-pz0-f42.google.com with SMTP id 37so370400pzk.1
        for <linux-wireless@vger.kernel.org>; Wed, 07 Sep 2011 17:50:08 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH v2 1/3] mac80211: Start implementing QoS support for mesh interfaces
Date: Wed,  7 Sep 2011 17:49:52 -0700
Message-Id: <1315442994-304-2-git-send-email-javier@cozybit.com> (sfid-20110908_025013_183163_CD014918)
In-Reply-To: <1315442994-304-1-git-send-email-javier@cozybit.com>
References: <1315442994-304-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to support QoS in mesh, we need to assign queue mapping only
after the next hop has been resolved, both for forwarded and locally
originated frames.  Also, now that this is fixed, remove the XXX comment
in ieee80211_select_queue().

Also, V-Shy Ho reported that the queue mapping was not being applied to
the forwarded frame (fwd_skb instead of skb).  Fixed that as well.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh_pathtbl.c |    4 ++++
 net/mac80211/rx.c           |   10 +++++-----
 net/mac80211/tx.c           |    4 ++++
 net/mac80211/wme.c          |    6 +-----
 4 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index ede4f52..b51fce6 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -14,6 +14,7 @@
 #include <linux/spinlock.h>
 #include <linux/string.h>
 #include <net/mac80211.h>
+#include "wme.h"
 #include "ieee80211_i.h"
 #include "mesh.h"
 
@@ -210,6 +211,7 @@ void mesh_path_assign_nexthop(struct mesh_path *mpath, struct sta_info *sta)
 	struct ieee80211_hdr *hdr;
 	struct sk_buff_head tmpq;
 	unsigned long flags;
+	struct ieee80211_sub_if_data *sdata = mpath->sdata;
 
 	rcu_assign_pointer(mpath->next_hop, sta);
 
@@ -220,6 +222,8 @@ void mesh_path_assign_nexthop(struct mesh_path *mpath, struct sta_info *sta)
 	while ((skb = __skb_dequeue(&mpath->frame_queue)) != NULL) {
 		hdr = (struct ieee80211_hdr *) skb->data;
 		memcpy(hdr->addr1, sta->sta.addr, ETH_ALEN);
+		skb_set_queue_mapping(skb, ieee80211_select_queue(sdata, skb));
+		ieee80211_set_qos_hdr(sdata->local, skb);
 		__skb_queue_tail(&tmpq, skb);
 	}
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index f45fd2f..1146991 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1902,13 +1902,13 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 			memset(info, 0, sizeof(*info));
 			info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
 			info->control.vif = &rx->sdata->vif;
-			skb_set_queue_mapping(skb,
-				ieee80211_select_queue(rx->sdata, fwd_skb));
-			ieee80211_set_qos_hdr(local, skb);
-			if (is_multicast_ether_addr(fwd_hdr->addr1))
+			if (is_multicast_ether_addr(fwd_hdr->addr1)) {
 				IEEE80211_IFSTA_MESH_CTR_INC(&sdata->u.mesh,
 								fwded_mcast);
-			else {
+				skb_set_queue_mapping(fwd_skb,
+					ieee80211_select_queue(sdata, fwd_skb));
+				ieee80211_set_qos_hdr(local, fwd_skb);
+			} else {
 				int err;
 				/*
 				 * Save TA to addr1 to send TA a path error if a
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0107263..4c567e1 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1878,6 +1878,10 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		rcu_read_unlock();
 	}
 
+	/* For mesh, the use of the QoS header is mandatory */
+	if (ieee80211_vif_is_mesh(&sdata->vif))
+		sta_flags |= WLAN_STA_WME;
+
 	/* receiver and we are QoS enabled, use a QoS type frame */
 	if ((sta_flags & WLAN_STA_WME) && local->hw.queues >= 4) {
 		fc |= cpu_to_le16(IEEE80211_STYPE_QOS_DATA);
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 7a49532..a9fee2b 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -83,11 +83,7 @@ u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 		break;
 #ifdef CONFIG_MAC80211_MESH
 	case NL80211_IFTYPE_MESH_POINT:
-		/*
-		 * XXX: This is clearly broken ... but already was before,
-		 * because ieee80211_fill_mesh_addresses() would clear A1
-		 * except for multicast addresses.
-		 */
+		ra = skb->data;
 		break;
 #endif
 	case NL80211_IFTYPE_STATION:
-- 
1.7.6

