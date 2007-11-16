Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43731 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757544AbXKPLya (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2007 06:54:30 -0500
Subject: [PATCH] mac80211: remove more forgotten code
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 16 Nov 2007 02:17:07 +0100
Message-Id: <1195175827.8147.89.camel@johannes.berg> (sfid-20071116_115438_337234_8CA3CB30)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hopefully that's the rest. Seems I didn't do a very thorough job
removing the management interface.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/tx.c |   58 ------------------------------------------------------
 1 file changed, 58 deletions(-)

--- everything.orig/net/mac80211/tx.c	2007-11-16 02:13:58.771947319 +0100
+++ everything/net/mac80211/tx.c	2007-11-16 02:14:05.211960123 +0100
@@ -1527,64 +1527,6 @@ int ieee80211_subif_start_xmit(struct sk
 	return ret;
 }
 
-/*
- * This is the transmit routine for the 802.11 type interfaces
- * called by upper layers of the linux networking
- * stack when it has a frame to transmit
- */
-int ieee80211_mgmt_start_xmit(struct sk_buff *skb, struct net_device *dev)
-{
-	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_tx_packet_data *pkt_data;
-	struct ieee80211_hdr *hdr;
-	u16 fc;
-
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-
-	if (skb->len < 10) {
-		dev_kfree_skb(skb);
-		return 0;
-	}
-
-	if (skb_headroom(skb) < sdata->local->tx_headroom) {
-		if (pskb_expand_head(skb, sdata->local->tx_headroom,
-				     0, GFP_ATOMIC)) {
-			dev_kfree_skb(skb);
-			return 0;
-		}
-	}
-
-	hdr = (struct ieee80211_hdr *) skb->data;
-	fc = le16_to_cpu(hdr->frame_control);
-
-	pkt_data = (struct ieee80211_tx_packet_data *) skb->cb;
-	memset(pkt_data, 0, sizeof(struct ieee80211_tx_packet_data));
-	pkt_data->ifindex = sdata->dev->ifindex;
-
-	skb->priority = 20; /* use hardcoded priority for mgmt TX queue */
-	skb->dev = sdata->local->mdev;
-
-	/*
-	 * We're using the protocol field of the the frame control header
-	 * to request TX callback for hostapd. BIT(1) is checked.
-	 */
-	if ((fc & BIT(1)) == BIT(1)) {
-		pkt_data->flags |= IEEE80211_TXPD_REQ_TX_STATUS;
-		fc &= ~BIT(1);
-		hdr->frame_control = cpu_to_le16(fc);
-	}
-
-	if (!(fc & IEEE80211_FCTL_PROTECTED))
-		pkt_data->flags |= IEEE80211_TXPD_DO_NOT_ENCRYPT;
-
-	dev->stats.tx_packets++;
-	dev->stats.tx_bytes += skb->len;
-
-	dev_queue_xmit(skb);
-
-	return 0;
-}
-
 /* helper functions for pending packets for when queues are stopped */
 
 void ieee80211_clear_tx_pending(struct ieee80211_local *local)


