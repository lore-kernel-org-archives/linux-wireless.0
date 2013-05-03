Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:51671 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758613Ab3ECCgc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 22:36:32 -0400
Received: by mail-pd0-f180.google.com with SMTP id t10so669852pdi.11
        for <linux-wireless@vger.kernel.org>; Thu, 02 May 2013 19:36:32 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>, me@bobcopeland.com,
	open80211s <devel@lists.open80211s.org>
Subject: [RFC 10/12] mac08211: add shared-mbss receive path handling
Date: Thu,  2 May 2013 19:34:00 -0700
Message-Id: <1367548442-8229-11-git-send-email-thomas@cozybit.com> (sfid-20130503_043635_691616_A75ED61E)
In-Reply-To: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
References: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bob Copeland <me@bobcopeland.com>

If a destination interface is participating in a shared mbss, then
receive data frames on the correct interface (or all for mcast) when
passing frames to upper layers.

Signed-off-by: Bob Copeland <bob@cozybit.com>
---
 net/mac80211/rx.c |   56 +++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 52 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 850bfe3..f705210 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -594,19 +594,22 @@ static int ieee80211_get_mmie_keyidx(struct sk_buff *skb)
 static ieee80211_rx_result ieee80211_rx_mesh_check(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
-	char *dev_addr = rx->sdata->vif.addr;
+	struct mesh_local_bss *mbss = mbss(rx->sdata);
+
+	if (!mbss)
+		return RX_DROP_MONITOR;
 
 	if (ieee80211_is_data(hdr->frame_control)) {
 		if (is_multicast_ether_addr(hdr->addr1)) {
 			if (ieee80211_has_tods(hdr->frame_control) ||
 			    !ieee80211_has_fromds(hdr->frame_control))
 				return RX_DROP_MONITOR;
-			if (ether_addr_equal(hdr->addr3, dev_addr))
+			if (mesh_bss_matches_addr(mbss, hdr->addr3))
 				return RX_DROP_MONITOR;
 		} else {
 			if (!ieee80211_has_a4(hdr->frame_control))
 				return RX_DROP_MONITOR;
-			if (ether_addr_equal(hdr->addr4, dev_addr))
+			if (mesh_bss_matches_addr(mbss, hdr->addr4))
 				return RX_DROP_MONITOR;
 		}
 	}
@@ -2074,7 +2077,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 
 	/* Frame has reached destination.  Don't forward */
 	if (!is_multicast_ether_addr(hdr->addr1) &&
-	    ether_addr_equal(sdata->vif.addr, hdr->addr3))
+	    mesh_bss_matches_addr(mbss, hdr->addr3))
 		return RX_CONTINUE;
 
 	if (!--mesh_hdr->ttl) {
@@ -2157,6 +2160,7 @@ static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
+	struct ieee80211_sub_if_data *tmp_sdata;
 	struct ieee80211_local *local = rx->local;
 	struct net_device *dev = sdata->dev;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
@@ -2183,6 +2187,19 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 		return RX_DROP_MONITOR;
 	}
 
+	if (ieee80211_vif_is_mesh(&rx->sdata->vif) &&
+	    !is_multicast_ether_addr(hdr->addr1)) {
+		u8 *dest = ieee80211_get_DA(hdr);
+
+		/* deliver unicast frames to the dest netif */
+		tmp_sdata = mesh_bss_find_if(mbss(sdata), dest);
+		if (tmp_sdata && tmp_sdata != sdata) {
+			local = tmp_sdata->local;
+			rx->sdata = tmp_sdata;
+			dev = tmp_sdata->dev;
+		}
+	}
+
 	err = __ieee80211_data_to_8023(rx, &port_control);
 	if (unlikely(err))
 		return RX_DROP_UNUSABLE;
@@ -2198,6 +2215,37 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 		rx->sdata = sdata;
 	}
 
+	if (ieee80211_vif_is_mesh(&rx->sdata->vif)) {
+		struct mesh_local_bss *mbss = mbss(sdata);
+		struct sk_buff *skb = rx->skb, *fwd_skb;
+		u8 *dest = ((struct ethhdr *)rx->skb->data)->h_dest;
+
+		if (is_multicast_ether_addr(dest)) {
+			/* deliver mcast frames to all other interfaces */
+			list_for_each_entry_rcu(tmp_sdata, &mbss->if_list,
+						u.mesh.if_list) {
+
+				if (sdata == tmp_sdata)
+					continue;
+
+				fwd_skb = skb_copy(skb, GFP_ATOMIC);
+				if (!fwd_skb)
+					break;
+
+				dev = tmp_sdata->dev;
+				fwd_skb->dev = dev;
+				rx->skb = fwd_skb;
+				rx->sdata = tmp_sdata;
+				dev->stats.rx_packets++;
+				dev->stats.rx_bytes += rx->skb->len;
+				ieee80211_deliver_skb(rx);
+			}
+			rx->sdata = sdata;
+			rx->skb = skb;
+			dev = sdata->dev;
+		}
+	}
+
 	rx->skb->dev = dev;
 
 	dev->stats.rx_packets++;
-- 
1.7.10.4

