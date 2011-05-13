Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:60915 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660Ab1EMSRz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 14:17:55 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2] mwifiex: use ieee80211_amsdu_to_8023s routine
Date: Fri, 13 May 2011 11:22:32 -0700
Message-Id: <1305310952-19572-2-git-send-email-bzhao@marvell.com> (sfid-20110513_201801_240274_F2BBF87A)
In-Reply-To: <1305310952-19572-1-git-send-email-bzhao@marvell.com>
References: <1305310952-19572-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

mwifiex was using its own implementation of converting 802.11n
AMSDU to 802.3s.  This patch removes mwifiex specific
implementation and uses existing ieee80211_amsdu_to_8023s
routine.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
This patch depends on the cfg80211 patch:
"[PATCH v2] cfg80211: make stripping of 802.11 header optional from AMSDU"

v2: Call ieee80211_amsdu_to_8023s with has_80211_header set to 'false'

 drivers/net/wireless/mwifiex/11n_aggr.c |  125 -------------------------------
 drivers/net/wireless/mwifiex/sta_rx.c   |   22 +++++-
 2 files changed, 20 insertions(+), 127 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index 2b2cca5..d3d5e08 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -136,131 +136,6 @@ mwifiex_11n_form_amsdu_txpd(struct mwifiex_private *priv,
 }
 
 /*
- * Counts the number of subframes in an aggregate packet.
- *
- * This function parses an aggregate packet buffer, looking for
- * subframes and counting the number of such subframe found. The
- * function automatically skips the DA/SA fields at the beginning
- * of each subframe and padding at the end.
- */
-static int
-mwifiex_11n_get_num_aggr_pkts(u8 *data, int total_pkt_len)
-{
-	int pkt_count = 0, pkt_len, pad;
-
-	while (total_pkt_len > 0) {
-		/* Length will be in network format, change it to host */
-		pkt_len = ntohs((*(__be16 *)(data + 2 * ETH_ALEN)));
-		pad = (((pkt_len + sizeof(struct ethhdr)) & 3)) ?
-			(4 - ((pkt_len + sizeof(struct ethhdr)) & 3)) : 0;
-		data += pkt_len + pad + sizeof(struct ethhdr);
-		total_pkt_len -= pkt_len + pad + sizeof(struct ethhdr);
-		++pkt_count;
-	}
-
-	return pkt_count;
-}
-
-/*
- * De-aggregate received packets.
- *
- * This function parses the received aggregate buffer, extracts each subframe,
- * strips off the SNAP header from them and sends the data portion for further
- * processing.
- *
- * Each subframe body is copied onto a separate buffer, which are freed by
- * upper layer after processing. The function also performs sanity tests on
- * the received buffer.
- */
-int mwifiex_11n_deaggregate_pkt(struct mwifiex_private *priv,
-				struct sk_buff *skb)
-{
-	u16 pkt_len;
-	int total_pkt_len;
-	u8 *data;
-	int pad;
-	struct mwifiex_rxinfo *rx_info = MWIFIEX_SKB_RXCB(skb);
-	struct rxpd *local_rx_pd = (struct rxpd *) skb->data;
-	struct sk_buff *skb_daggr;
-	struct mwifiex_rxinfo *rx_info_daggr;
-	int ret = -1;
-	struct rx_packet_hdr *rx_pkt_hdr;
-	struct mwifiex_adapter *adapter = priv->adapter;
-	u8 rfc1042_eth_hdr[ETH_ALEN] = { 0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00};
-
-	data = (u8 *) (local_rx_pd + local_rx_pd->rx_pkt_offset);
-	total_pkt_len = local_rx_pd->rx_pkt_length;
-
-	/* Sanity test */
-	if (total_pkt_len > MWIFIEX_RX_DATA_BUF_SIZE) {
-		dev_err(adapter->dev, "total pkt len greater than buffer"
-		       " size %d\n", total_pkt_len);
-		return -1;
-	}
-
-	rx_info->use_count = mwifiex_11n_get_num_aggr_pkts(data, total_pkt_len);
-
-	while (total_pkt_len > 0) {
-		rx_pkt_hdr = (struct rx_packet_hdr *) data;
-		/* Length will be in network format, change it to host */
-		pkt_len = ntohs((*(__be16 *) (data + 2 * ETH_ALEN)));
-		if (pkt_len > total_pkt_len) {
-			dev_err(adapter->dev, "pkt_len %d > total_pkt_len %d\n",
-			       total_pkt_len, pkt_len);
-			break;
-		}
-
-		pad = (((pkt_len + sizeof(struct ethhdr)) & 3)) ?
-			(4 - ((pkt_len + sizeof(struct ethhdr)) & 3)) : 0;
-
-		total_pkt_len -= pkt_len + pad + sizeof(struct ethhdr);
-
-		if (memcmp(&rx_pkt_hdr->rfc1042_hdr,
-			   rfc1042_eth_hdr, sizeof(rfc1042_eth_hdr)) == 0) {
-			memmove(data + LLC_SNAP_LEN, data, 2 * ETH_ALEN);
-			data += LLC_SNAP_LEN;
-			pkt_len += sizeof(struct ethhdr) - LLC_SNAP_LEN;
-		} else {
-			*(u16 *) (data + 2 * ETH_ALEN) = (u16) 0;
-			pkt_len += sizeof(struct ethhdr);
-		}
-
-		skb_daggr = dev_alloc_skb(pkt_len);
-		if (!skb_daggr) {
-			dev_err(adapter->dev, "%s: failed to alloc skb_daggr\n",
-			       __func__);
-			return -1;
-		}
-		rx_info_daggr = MWIFIEX_SKB_RXCB(skb_daggr);
-
-		rx_info_daggr->bss_index = rx_info->bss_index;
-		skb_daggr->tstamp = skb->tstamp;
-		rx_info_daggr->parent = skb;
-		skb_daggr->priority = skb->priority;
-		skb_put(skb_daggr, pkt_len);
-		memcpy(skb_daggr->data, data, pkt_len);
-
-		ret = mwifiex_recv_packet(adapter, skb_daggr);
-
-		switch (ret) {
-		case -EINPROGRESS:
-			break;
-		case -1:
-			dev_err(adapter->dev, "deaggr: host_to_card failed\n");
-		case 0:
-			mwifiex_recv_packet_complete(adapter, skb_daggr, ret);
-			break;
-		default:
-			break;
-		}
-
-		data += pkt_len + pad;
-	}
-
-	return ret;
-}
-
-/*
  * Create aggregated packet.
  *
  * This function creates an aggregated MSDU packet, by combining buffers
diff --git a/drivers/net/wireless/mwifiex/sta_rx.c b/drivers/net/wireless/mwifiex/sta_rx.c
index e047f0d..1fdddec 100644
--- a/drivers/net/wireless/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/mwifiex/sta_rx.c
@@ -141,10 +141,28 @@ int mwifiex_process_sta_rx_packet(struct mwifiex_adapter *adapter,
 		dev_kfree_skb_any(skb);
 		return ret;
 	}
+
 	if (local_rx_pd->rx_pkt_type == PKT_TYPE_AMSDU) {
-		mwifiex_11n_deaggregate_pkt(priv, skb);
-		return ret;
+		struct sk_buff_head list;
+		struct sk_buff *rx_skb;
+
+		__skb_queue_head_init(&list);
+
+		skb_pull(skb, local_rx_pd->rx_pkt_offset);
+		skb_trim(skb, local_rx_pd->rx_pkt_length);
+
+		ieee80211_amsdu_to_8023s(skb, &list, priv->curr_addr,
+				priv->wdev->iftype, 0, false);
+
+		while (!skb_queue_empty(&list)) {
+			rx_skb = __skb_dequeue(&list);
+			ret = mwifiex_recv_packet(adapter, rx_skb);
+			if (ret == -1)
+				dev_err(adapter->dev, "Rx of A-MSDU failed");
+		}
+		return 0;
 	}
+
 	/*
 	 * If the packet is not an unicast packet then send the packet
 	 * directly to os. Don't pass thru rx reordering
-- 
1.7.0.2

