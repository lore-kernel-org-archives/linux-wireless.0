Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2234 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632AbXJJBik (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2007 21:38:40 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: stable@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, warmcat <andy@warmcat.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] Improve sanity checks on injected packets
Date: Tue,  9 Oct 2007 21:30:40 -0400
Message-Id: <1191979843181-git-send-email-linville@tuxdriver.com> (sfid-20071010_023842_939719_E3F863F9)
In-Reply-To: <11919798433964-git-send-email-linville@tuxdriver.com>
References: <11919798433964-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: warmcat <andy@warmcat.com>

Michael Wu noticed that the skb length checking is not taken care of enough when
a packet is presented on the Monitor interface for injection.

This patch improves the sanity checking and removes fake offsets placed
into the skb network and transport header.

Signed-off-by: Andy Green <andy@warmcat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/ieee80211.c |   48 ++++++++++++++++++++++++++-------------------
 1 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 9b9d716..ad73a40 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -1680,46 +1680,54 @@ int ieee80211_monitor_start_xmit(struct sk_buff *skb,
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
 
 
-- 
1.5.2.4

