Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:60606 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbXKIICT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 03:02:19 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	tomas.winkler@intel.com, flamingice@sourmilk.net,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 06/14] mac80211: adding 802.11n essential A-MSDU Rx capability
Date: Fri,  9 Nov 2007 10:01:58 +0200
Message-Id: <11945953313491-git-send-email-ron.rindjunsky@intel.com> (sfid-20071109_080236_537785_962440D7)
In-Reply-To: <11945953312456-git-send-email-ron.rindjunsky@intel.com>
References: <1194595326527-git-send-email-ron.rindjunsky@intel.com>
 <11945953311871-git-send-email-ron.rindjunsky@intel.com>
 <11945953312850-git-send-email-ron.rindjunsky@intel.com>
 <11945953312367-git-send-email-ron.rindjunsky@intel.com>
 <1194595331658-git-send-email-ron.rindjunsky@intel.com>
 <11945953312456-git-send-email-ron.rindjunsky@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the ability to receive and handle A-MSDU frames.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/rx.c          |  220 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 221 insertions(+), 0 deletions(-)

Index: wl2_6_24_HT/net/mac80211/ieee80211_i.h
===================================================================
--- wl2_6_24_HT.orig/net/mac80211/ieee80211_i.h
+++ wl2_6_24_HT/net/mac80211/ieee80211_i.h
@@ -157,6 +157,7 @@ struct ieee80211_txrx_data {
 			int load;
 			u32 tkip_iv32;
 			u16 tkip_iv16;
+			u16 amsdu_frame;
 		} rx;
 	} u;
 };
Index: wl2_6_24_HT/net/mac80211/rx.c
===================================================================
--- wl2_6_24_HT.orig/net/mac80211/rx.c
+++ wl2_6_24_HT/net/mac80211/rx.c
@@ -243,6 +243,10 @@ ieee80211_rx_h_parse_qos(struct ieee8021
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
@@ -1007,6 +1011,219 @@ ieee80211_rx_h_drop_unencrypted(struct i
 	return TXRX_CONTINUE;
 }
 
+#ifdef CONFIG_MAC80211_HT
+
+static ieee80211_txrx_result
+ieee80211_rx_h_data_agg(struct ieee80211_txrx_data *rx)
+{
+	struct net_device *dev = rx->dev;
+	struct ieee80211_local *local = rx->local;
+	u16 fc, hdrlen, ethertype;
+	u8 *payload;
+	struct sk_buff *skb = rx->skb, *skb2, *frame = NULL;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	const struct ethhdr *eth;
+	int remaining;
+	u8 dst[ETH_ALEN];
+	u8 src[ETH_ALEN];
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) rx->skb->data;
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
+	hdrlen = ieee80211_get_hdrlen(fc);
+
+	switch (fc & (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) {
+	case IEEE80211_FCTL_TODS:
+		/* BSSID SA DA */
+		if (unlikely(sdata->type != IEEE80211_IF_TYPE_AP &&
+		    sdata->type != IEEE80211_IF_TYPE_VLAN)) {
+			printk(KERN_DEBUG "%s: dropped ToDS frame (BSSID=%s"
+			       " SA=%s DA=%s)\n",
+			       dev->name, print_mac(mac, hdr->addr1),
+			       print_mac(mac, hdr->addr2),
+			       print_mac(mac, hdr->addr3));
+			return TXRX_DROP;
+		}
+		break;
+	case (IEEE80211_FCTL_TODS|IEEE80211_FCTL_FROMDS):
+		/* RA TA DA SA */
+		if (unlikely(sdata->type != IEEE80211_IF_TYPE_WDS)) {
+			printk(KERN_DEBUG "%s: dropped FromDS&ToDS frame"
+			       " (RA=%s TA=%s DA=%s SA=%s)\n",
+			       rx->dev->name, print_mac(mac, hdr->addr1),
+			       print_mac(mac, hdr->addr2),
+			       print_mac(mac, hdr->addr3),
+			       print_mac(mac, hdr->addr4));
+			return TXRX_DROP;
+		}
+		break;
+	case IEEE80211_FCTL_FROMDS:
+		/* DA BSSID SA */
+		if (sdata->type != IEEE80211_IF_TYPE_STA)
+			return TXRX_DROP;
+		break;
+	case 0:
+		/* DA SA BSSID */
+		if (sdata->type != IEEE80211_IF_TYPE_IBSS) {
+			if (net_ratelimit())
+				printk(KERN_DEBUG "%s: dropped IBSS frame"
+				       " (DA=%s SA=%s BSSID=%s)\n",
+				       dev->name, print_mac(mac, hdr->addr1),
+				       print_mac(mac, hdr->addr2),
+				       print_mac(mac, hdr->addr3));
+			return TXRX_DROP;
+		}
+		break;
+	}
+
+	if (unlikely((skb->len - hdrlen) < 8)) {
+		if (net_ratelimit())
+			printk(KERN_DEBUG "%s: RX too short data frame "
+			       "payload\n", dev->name);
+		return TXRX_DROP;
+	}
+
+	eth = (struct ethhdr *) skb_pull(skb, hdrlen);
+
+	payload = skb->data;
+	ethertype = (payload[6] << 8) | payload[7];
+
+	if (likely((compare_ether_addr(payload, rfc1042_header) == 0 &&
+	    ethertype != ETH_P_AARP && ethertype != ETH_P_IPX) ||
+	    compare_ether_addr(payload,
+	    bridge_tunnel_header) == 0))
+		eth = (struct ethhdr *) skb_pull(skb, 8);
+
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
+		if (remaining  <= subframe_len + padding)
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
+		skb2 = NULL;
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
+		if (local->bridge_packets &&
+		    (sdata->type == IEEE80211_IF_TYPE_AP ||
+		     sdata->type == IEEE80211_IF_TYPE_VLAN) &&
+		     (rx->flags & IEEE80211_TXRXD_RXRA_MATCH)) {
+			if (is_multicast_ether_addr(frame->data)) {
+				/* send multicast frames both to higher layers
+				 * in local net stack and back to the wireless
+				 * media */
+				skb2 = skb_copy(frame, GFP_ATOMIC);
+				if (!skb2)
+					printk(KERN_DEBUG "%s: failed to clone"
+					       " multicast frame\n", dev->name);
+			} else {
+				struct sta_info *dsta;
+
+				dsta = sta_info_get(local, frame->data);
+				if (dsta && !dsta->dev)
+					printk(KERN_DEBUG "Station with null "
+					       "dev structure!\n");
+				else if (dsta && dsta->dev == dev) {
+					/* Destination station is associated
+					 *to this AP, so send the frame
+					 * directly to it and do not pass
+					 * the frame to local net stack.
+					 */
+					skb2 = frame;
+					frame = NULL;
+				}
+				if (dsta)
+					sta_info_put(dsta);
+			}
+		}
+		if (frame) {
+			/* deliver to local stack */
+			skb_set_network_header(frame, 0);
+			frame->protocol = eth_type_trans(frame, dev);
+			frame->priority = skb->priority;
+			netif_rx(frame);
+		}
+
+		if (skb2) {
+			/* send to wireless media */
+			skb2->protocol = __constant_htons(ETH_P_802_3);
+			skb_set_network_header(skb2, 0);
+			skb_set_mac_header(skb2, 0);
+			skb2->priority = skb->priority;
+			skb2->dev = dev;
+			dev_queue_xmit(skb2);
+		}
+	}
+
+	return TXRX_QUEUED;
+}
+
+#endif /* CONFIG_MAC80211_HT */
+
 static ieee80211_txrx_result
 ieee80211_rx_h_data(struct ieee80211_txrx_data *rx)
 {
@@ -1343,6 +1560,9 @@ ieee80211_rx_handler ieee80211_rx_handle
 	ieee80211_rx_h_remove_qos_control,
 	ieee80211_rx_h_802_1x_pae,
 	ieee80211_rx_h_drop_unencrypted,
+#ifdef CONFIG_MAC80211_HT
+	ieee80211_rx_h_data_agg,
+#endif /* CONFIG_MAC80211_HT */
 	ieee80211_rx_h_data,
 	ieee80211_rx_h_mgmt,
 	NULL
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
