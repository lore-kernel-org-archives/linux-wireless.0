Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43838 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436Ab1KWUcx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 15:32:53 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so2078525iag.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Nov 2011 12:32:53 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: devel@lists.open80211s.org, Thomas Pedersen <thomas@cozybit.com>,
	johannes@sipsolutions.net, linville@tuxdriver.com
Subject: [PATCH 7/7] mac80211: clean up rx_h_mesh_fwding
Date: Wed, 23 Nov 2011 12:32:26 -0800
Message-Id: <1322080347-7644-8-git-send-email-thomas@cozybit.com> (sfid-20111123_213256_873601_E54172A4)
In-Reply-To: <1322080347-7644-1-git-send-email-thomas@cozybit.com>
References: <1322080347-7644-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lose about two levels of unnecessary indentation.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/rx.c |   88 +++++++++++++++++++++++-----------------------------
 1 files changed, 39 insertions(+), 49 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index ac09f55..a166c3c 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1895,15 +1895,16 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
 static ieee80211_rx_result
 ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 {
-	struct ieee80211_hdr *hdr;
+	struct ieee80211_hdr *fwd_hdr, *hdr;
+	struct ieee80211_tx_info *info;
 	struct ieee80211s_hdr *mesh_hdr;
-	unsigned int hdrlen;
 	struct sk_buff *skb = rx->skb, *fwd_skb;
 	struct ieee80211_local *local = rx->local;
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	__le16 reason = cpu_to_le16(WLAN_REASON_MESH_PATH_NOFORWARD);
-	u16 q;
+	u16 q, hdrlen;
 
 	hdr = (struct ieee80211_hdr *) skb->data;
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
@@ -1919,7 +1920,6 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 		return RX_CONTINUE;
 
 	if (!mesh_hdr->ttl)
-		/* illegal frame */
 		return RX_DROP_MONITOR;
 
 	if (mesh_hdr->flags & MESH_FLAGS_AE) {
@@ -1955,58 +1955,48 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 
 	q = ieee80211_select_queue_cooked(local, skb, hdr);
 	if (ieee80211_queue_stopped(&local->hw, q)) {
-		IEEE80211_IFSTA_MESH_CTR_INC(&sdata->u.mesh,
-					     dropped_frames_congestion);
+		IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, dropped_frames_congestion);
 		return RX_DROP_MONITOR;
 	}
 	skb_set_queue_mapping(skb, q);
-	mesh_hdr->ttl--;
 
-	if (status->rx_flags & IEEE80211_RX_RA_MATCH) {
-		if (!mesh_hdr->ttl)
-			IEEE80211_IFSTA_MESH_CTR_INC(&rx->sdata->u.mesh,
-						     dropped_frames_ttl);
-		else {
-			struct ieee80211_hdr *fwd_hdr;
-			struct ieee80211_tx_info *info;
-
-			fwd_skb = skb_copy(skb, GFP_ATOMIC);
-
-			if (!fwd_skb && net_ratelimit())
-				printk(KERN_DEBUG "%s: failed to clone mesh frame\n",
-						   sdata->name);
-			if (!fwd_skb)
-				goto out;
-
-			fwd_hdr =  (struct ieee80211_hdr *) fwd_skb->data;
-			info = IEEE80211_SKB_CB(fwd_skb);
-			memset(info, 0, sizeof(*info));
-			info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
-			info->control.vif = &rx->sdata->vif;
-			info->control.jiffies = jiffies;
-			if (is_multicast_ether_addr(fwd_hdr->addr1)) {
-				IEEE80211_IFSTA_MESH_CTR_INC(&sdata->u.mesh,
-								fwded_mcast);
-				memcpy(fwd_hdr->addr2, sdata->vif.addr, ETH_ALEN);
-			} else {
-				if (mesh_nexthop_lookup(fwd_skb, sdata)) {
-				/* can't resolve next hop, send a PERR */
-					mesh_path_error_tx(sdata->u.mesh.mshcfg.element_ttl,
-							   fwd_hdr->addr3, 0, reason,
-							   fwd_hdr->addr2, sdata);
-					sdata->u.mesh.mshstats.dropped_frames_no_route++;
-					return RX_DROP_MONITOR;
-				}
+	if (!(status->rx_flags & IEEE80211_RX_RA_MATCH))
+		goto out;
 
-				IEEE80211_IFSTA_MESH_CTR_INC(&sdata->u.mesh,
-								fwded_unicast);
-			}
-			IEEE80211_IFSTA_MESH_CTR_INC(&sdata->u.mesh,
-						     fwded_frames);
-			ieee80211_add_pending_skb(local, fwd_skb);
-		}
+	if (!--mesh_hdr->ttl) {
+		IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, dropped_frames_ttl);
+		return RX_DROP_MONITOR;
+	}
+
+	fwd_skb = skb_copy(skb, GFP_ATOMIC);
+	if (!fwd_skb) {
+		if (net_ratelimit())
+			printk(KERN_DEBUG "%s: failed to clone mesh frame\n",
+					sdata->name);
+		goto out;
+	}
+
+	fwd_hdr =  (struct ieee80211_hdr *) fwd_skb->data;
+	info = IEEE80211_SKB_CB(fwd_skb);
+	memset(info, 0, sizeof(*info));
+	info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
+	info->control.vif = &rx->sdata->vif;
+	info->control.jiffies = jiffies;
+	if (is_multicast_ether_addr(fwd_hdr->addr1)) {
+		IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, fwded_mcast);
+		memcpy(fwd_hdr->addr2, sdata->vif.addr, ETH_ALEN);
+	} else if (!mesh_nexthop_lookup(fwd_skb, sdata)) {
+		IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, fwded_unicast);
+	} else {
+		/* unable to resolve next hop */
+		mesh_path_error_tx(ifmsh->mshcfg.element_ttl, fwd_hdr->addr3,
+				    0, reason, fwd_hdr->addr2, sdata);
+		IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, dropped_frames_no_route);
+		return RX_DROP_MONITOR;
 	}
 
+	IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, fwded_frames);
+	ieee80211_add_pending_skb(local, fwd_skb);
  out:
 	if (is_multicast_ether_addr(hdr->addr1) ||
 	    sdata->dev->flags & IFF_PROMISC)
-- 
1.7.5.4

