Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:32326 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753048AbXKZOVn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 09:21:43 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 06/15] mac80211: adding 802.11n essential A-MSDU Rx capability
Date: Mon, 26 Nov 2007 16:14:33 +0200
Message-Id: <119608649124-git-send-email-ron.rindjunsky@intel.com> (sfid-20071126_142157_540136_FC9C7CF5)
In-Reply-To: <11960864823402-git-send-email-ron.rindjunsky@intel.com>
References: <11960864823402-git-send-email-ron.rindjunsky@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the ability to receive and handle A-MSDU frames.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/rx.c          |  124 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 125 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9caf124..247af42 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -155,6 +155,7 @@ struct ieee80211_txrx_data {
 			int load;
 			u32 tkip_iv32;
 			u16 tkip_iv16;
+			u8  amsdu_frame;
 		} rx;
 	} u;
 };
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 6333c98..878ca20 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -243,6 +243,10 @@ ieee80211_rx_h_parse_qos(struct ieee80211_txrx_data *rx)
 		u8 *qc = data + ieee80211_get_hdrlen(rx->fc) - QOS_CONTROL_LEN;
 		/* frame has qos control */
 		tid = qc[0] & QOS_CONTROL_TID_MASK;
+		if (qc[0] & IEEE80211_QOS_CONTROL_A_MSDU_PRESENT)
+			rx->u.rx.amsdu_frame = 1;
+		else
+			rx->u.rx.amsdu_frame = 0;
 	} else {
 		if (unlikely((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT)) {
 			/* Separate TID for management frames */
@@ -1191,6 +1195,125 @@ ieee80211_deliver_skb(struct ieee80211_txrx_data *rx)
 }
 
 static ieee80211_txrx_result
+ieee80211_rx_h_amsdu(struct ieee80211_txrx_data *rx)
+{
+	struct net_device *dev = rx->dev;
+	struct ieee80211_local *local = rx->local;
+	u16 fc, ethertype;
+	u8 *payload;
+	struct sk_buff *skb = rx->skb, *frame = NULL;
+	const struct ethhdr *eth;
+	int remaining, err;
+	u8 dst[ETH_ALEN];
+	u8 src[ETH_ALEN];
+	DECLARE_MAC_BUF(mac);
+
+	fc = rx->fc;
+	if (unlikely((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA))
+		return TXRX_CONTINUE;
+
+	if (unlikely(!WLAN_FC_DATA_PRESENT(fc)))
+		return TXRX_DROP;
+
+	if (!rx->u.rx.amsdu_frame)
+		return TXRX_CONTINUE;
+
+	err = ieee80211_data_to_8023(rx);
+	if (unlikely(err))
+		return TXRX_DROP;
+
+	skb->dev = dev;
+
+	dev->stats.rx_packets++;
+	dev->stats.rx_bytes += skb->len;
+
+	/* skip the wrapping header */
+	eth = (struct ethhdr *) skb_pull(skb, sizeof(struct ethhdr));
+	if (!eth)
+		return TXRX_DROP;
+
+	while (skb != frame) {
+		u8 padding;
+		__be16 len = eth->h_proto;
+		unsigned int subframe_len = sizeof(struct ethhdr) + ntohs(len);
+
+		remaining = skb->len;
+		memcpy(dst, eth->h_dest, ETH_ALEN);
+		memcpy(src, eth->h_source, ETH_ALEN);
+
+		padding = ((4 - subframe_len) & 0x3);
+		/* the last MSDU has no padding */
+		if (subframe_len > remaining) {
+			printk(KERN_DEBUG "%s: wrong buffer size", dev->name);
+			return TXRX_DROP;
+		}
+
+		skb_pull(skb, sizeof(struct ethhdr));
+		/* if last subframe reuse skb */
+		if (remaining <= subframe_len + padding)
+			frame = skb;
+		else {
+			frame = dev_alloc_skb(local->hw.extra_tx_headroom +
+					      subframe_len);
+
+			if (frame == NULL)
+				return TXRX_DROP;
+
+			skb_reserve(frame, local->hw.extra_tx_headroom +
+				    sizeof(struct ethhdr));
+			memcpy(skb_put(frame, ntohs(len)), skb->data,
+				ntohs(len));
+
+			eth = (struct ethhdr *) skb_pull(skb, ntohs(len) +
+							padding);
+			if (!eth) {
+				printk(KERN_DEBUG "%s: wrong buffer size ",
+				       dev->name);
+				dev_kfree_skb(frame);
+				return TXRX_DROP;
+			}
+		}
+
+		skb_set_network_header(frame, 0);
+		frame->dev = dev;
+		frame->priority = skb->priority;
+		rx->skb = frame;
+
+		if ((ieee80211_drop_802_1x_pae(rx, 0)) ||
+		    (ieee80211_drop_unencrypted(rx, 0))) {
+			if (skb == frame) /* last frame */
+				return TXRX_DROP;
+			dev_kfree_skb(frame);
+			continue;
+		}
+
+		payload = frame->data;
+		ethertype = (payload[6] << 8) | payload[7];
+
+		if (likely((compare_ether_addr(payload, rfc1042_header) == 0 &&
+			ethertype != ETH_P_AARP && ethertype != ETH_P_IPX) ||
+			compare_ether_addr(payload,
+					   bridge_tunnel_header) == 0)) {
+			/* remove RFC1042 or Bridge-Tunnel
+			 * encapsulation and replace EtherType */
+			skb_pull(frame, 6);
+			memcpy(skb_push(frame, ETH_ALEN), src, ETH_ALEN);
+			memcpy(skb_push(frame, ETH_ALEN), dst, ETH_ALEN);
+		} else {
+			memcpy(skb_push(frame, sizeof(__be16)), &len,
+				sizeof(__be16));
+			memcpy(skb_push(frame, ETH_ALEN), src, ETH_ALEN);
+			memcpy(skb_push(frame, ETH_ALEN), dst, ETH_ALEN);
+		}
+
+
+		ieee80211_deliver_skb(rx);
+	}
+
+	return TXRX_QUEUED;
+}
+
+static ieee80211_txrx_result
 ieee80211_rx_h_data(struct ieee80211_txrx_data *rx)
 {
 	struct net_device *dev = rx->dev;
@@ -1373,6 +1496,7 @@ ieee80211_rx_handler ieee80211_rx_handlers[] =
 	 * are not passed to user space by these functions
 	 */
 	ieee80211_rx_h_remove_qos_control,
+	ieee80211_rx_h_amsdu,
 	ieee80211_rx_h_data,
 	ieee80211_rx_h_mgmt,
 	NULL
-- 
1.5.3.3
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
