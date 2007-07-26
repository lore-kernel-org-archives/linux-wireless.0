Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:59668 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753345AbXGZMK6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2007 08:10:58 -0400
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id 92B7E8CAD8
	for <linux-wireless@vger.kernel.org>; Thu, 26 Jul 2007 14:10:53 +0200 (CEST)
Received: from meerkat.home.warmcat.com (unknown [192.168.0.242])
	by armbox7.home.warmcat.com (Postfix) with ESMTP id 531771044E
	for <linux-wireless@vger.kernel.org>; Thu, 26 Jul 2007 12:12:40 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by meerkat.home.warmcat.com (Postfix) with ESMTP id E076213639A2
	for <linux-wireless@vger.kernel.org>; Thu, 26 Jul 2007 13:10:56 +0100 (BST)
From: warmcat <andy@warmcat.com>
Subject: [PATCH 2/2] Improve sanity checks on injected packets
To: linux-wireless@vger.kernel.org
Date: Thu, 26 Jul 2007 13:10:56 +0100
Message-ID: <20070726121056.11153.32846.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu noticed that the skb length checking is not taken care of enough when
a packet is presented on the Monitor interface for injection.

This patch improves the sanity checking and removes fake offsets placed
into the skb network and transport header.

Signed-off-by: Andy Green <andy@warmcat.com>
---

 net/mac80211/ieee80211.c |   48 +++++++++++++++++++++++++++-------------------
 1 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 6f5c001..7dda339 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -1691,46 +1691,54 @@ int ieee80211_monitor_start_xmit(struct sk_buff *skb,
 	struct ieee80211_tx_packet_data *pkt_data;
 	struct ieee80211_radiotap_header *prthdr =
 		(struct ieee80211_radiotap_header *)skb->data;
-	u16 len;
+	u16 len_rthdr;
 
-	/*
-	 * there must be a radiotap header at the
-	 * start in this case
-	 */
-	if (unlikely(prthdr->it_version)) {
-		/* only version 0 is supported */
-		dev_kfree_skb(skb);
-		return NETDEV_TX_OK;
-	}
+	/* check for not even having the fixed radiotap header part */
+	if (unlikely(skb->len < sizeof(struct ieee80211_radiotap_header)))
+		goto fail; /* too short to be possibly valid */
+
+	/* is it a header version we can trust to find length from? */
+	if (unlikely(prthdr->it_version))
+		goto fail; /* only version 0 is supported */
+
+	/* then there must be a radiotap header with a length we can use */
+	len_rthdr = ieee80211_get_radiotap_len(skb);
+
+	/* does the skb contain enough to deliver on the alleged length? */
+	if (unlikely(skb->len < len_rthdr))
+		goto fail; /* skb too short for claimed rt header extent */
 
 	skb->dev = local->mdev;
 
 	pkt_data = (struct ieee80211_tx_packet_data *)skb->cb;
 	memset(pkt_data, 0, sizeof(*pkt_data));
+	/* needed because we set skb device to master */
 	pkt_data->ifindex = dev->ifindex;
+
 	pkt_data->mgmt_iface = 0;
 	pkt_data->do_not_encrypt = 1;
 
-	/* above needed because we set skb device to master */
-
 	/*
 	 * fix up the pointers accounting for the radiotap
 	 * header still being in there.  We are being given
 	 * a precooked IEEE80211 header so no need for
 	 * normal processing
 	 */
-	len = le16_to_cpu(get_unaligned(&prthdr->it_len));
-	skb_set_mac_header(skb, len);
-	skb_set_network_header(skb, len + sizeof(struct ieee80211_hdr));
-	skb_set_transport_header(skb, len + sizeof(struct ieee80211_hdr));
-
+	skb_set_mac_header(skb, len_rthdr);
 	/*
-	 * pass the radiotap header up to
-	 * the next stage intact
+	 * these are just fixed to the end of the rt area since we
+	 * don't have any better information and at this point, nobody cares
 	 */
-	dev_queue_xmit(skb);
+	skb_set_network_header(skb, len_rthdr);
+	skb_set_transport_header(skb, len_rthdr);
 
+	/* pass the radiotap header up to the next stage intact */
+	dev_queue_xmit(skb);
 	return NETDEV_TX_OK;
+
+fail:
+	dev_kfree_skb(skb);
+	return NETDEV_TX_OK; /* meaning, we dealt with the skb */
 }
 
 

