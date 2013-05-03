Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f49.google.com ([209.85.210.49]:45403 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab3ECCgU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 22:36:20 -0400
Received: by mail-da0-f49.google.com with SMTP id p5so590102dak.36
        for <linux-wireless@vger.kernel.org>; Thu, 02 May 2013 19:36:20 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>, me@bobcopeland.com,
	open80211s <devel@lists.open80211s.org>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [RFC 05/12] mac80211: forward frames on correct mbss-shared interface
Date: Thu,  2 May 2013 19:33:55 -0700
Message-Id: <1367548442-8229-6-git-send-email-thomas@cozybit.com> (sfid-20130503_043623_514496_5D53FEF0)
In-Reply-To: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
References: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A forwarded frame may have a destination STA which resides
on a vif other than the RX interface. Have
mesh_nexthop_lookup() fill in the right outgoing sdata in
the skb control block.

Also update the congestion detection logic to take into
account a possibly different outgoing interface.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/rx.c |   47 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 15 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 4e7886d..d86f0df 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2077,13 +2077,6 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	    ether_addr_equal(sdata->vif.addr, hdr->addr3))
 		return RX_CONTINUE;
 
-	q = ieee80211_select_queue_80211(sdata, skb, hdr);
-	if (ieee80211_queue_stopped(&local->hw, q)) {
-		IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, dropped_frames_congestion);
-		return RX_DROP_MONITOR;
-	}
-	skb_set_queue_mapping(skb, q);
-
 	if (!--mesh_hdr->ttl) {
 		IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, dropped_frames_ttl);
 		goto out;
@@ -2106,21 +2099,45 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
 	info->control.vif = &rx->sdata->vif;
 	info->control.jiffies = jiffies;
+
+	/* unicast frame may go out on a different HW, so resolve now */
+	if (!is_multicast_ether_addr(fwd_hdr->addr1)) {
+		if (!mesh_nexthop_lookup(mbss, fwd_skb))
+			/* next hop may be on a different interface */
+			local = vif_to_sdata(info->control.vif)->local;
+		else {
+			/* unable to resolve next hop */
+			mesh_path_error_tx(sdata, ifmsh->mshcfg.element_ttl,
+					   fwd_hdr->addr3, 0, reason,
+					   fwd_hdr->addr2);
+			IEEE80211_IFSTA_MESH_CTR_INC(ifmsh,
+						     dropped_frames_no_route);
+			kfree_skb(fwd_skb);
+			return RX_DROP_MONITOR;
+	       }
+	}
+
+	/*
+	 * note: ifmsh still points to RX iface (for forwarded frame
+	 * statistics), while local is sending HW
+	 */
+	q = ieee80211_select_queue_80211(vif_to_sdata(info->control.vif),
+					 fwd_skb, fwd_hdr);
+	if (ieee80211_queue_stopped(&local->hw, q)) {
+		IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, dropped_frames_congestion);
+		kfree_skb(fwd_skb);
+		return RX_DROP_MONITOR;
+	}
+	skb_set_queue_mapping(fwd_skb, q);
+
 	if (is_multicast_ether_addr(fwd_hdr->addr1)) {
 		IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, fwded_mcast);
 		memcpy(fwd_hdr->addr2, sdata->vif.addr, ETH_ALEN);
 		/* update power mode indication when forwarding */
 		ieee80211_mps_set_frame_flags(sdata, NULL, fwd_hdr);
-	} else if (!mesh_nexthop_lookup(mbss, fwd_skb)) {
+	} else {
 		/* mesh power mode flags updated in mesh_nexthop_lookup */
 		IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, fwded_unicast);
-	} else {
-		/* unable to resolve next hop */
-		mesh_path_error_tx(sdata, ifmsh->mshcfg.element_ttl,
-				   fwd_hdr->addr3, 0, reason, fwd_hdr->addr2);
-		IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, dropped_frames_no_route);
-		kfree_skb(fwd_skb);
-		return RX_DROP_MONITOR;
 	}
 
 	IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, fwded_frames);
-- 
1.7.10.4

