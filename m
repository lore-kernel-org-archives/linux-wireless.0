Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:16173 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932511AbXCZWlG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2007 18:41:06 -0400
Subject: [patch 3/5] A-MSDU Rx aggregation support
From: mohamed <mabbas@linux.intel.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Content-Type: text/plain
Date: Mon, 26 Mar 2007 04:40:00 -0700
Message-Id: <1174909200.1364.56.camel@dell-4965.jf.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add A-MSDU Rx aggregation support.

To support IEEE 802.11n, we need to be able to process A-MSDU frames. 
The present of the HT control field indicates it is A-MSDU frame. 
This patch adds support to discover and process A-MSDU frames.

Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>

diff -Nupr wireless-dev/net/mac80211/ieee80211.c
wireless-dev-new/net/mac80211/ieee80211.c
--- wireless-dev/net/mac80211/ieee80211.c	2007-03-27 00:36:24.000000000
-0700
+++ wireless-dev-new/net/mac80211/ieee80211.c	2007-03-27
01:54:48.000000000 -0700
@@ -2446,6 +2446,143 @@ static inline int ieee80211_bssid_match(
 }
 
 
+inline static unsigned int calc_pad_len(unsigned int len) 
+{ 
+	return (4 - len % 4) % 4; 
+}
+
+inline static int is_agg_frame(struct sk_buff *skb, u16 fc)
+{
+	u8 *p = skb->data + ieee80211_get_hdrlen(fc) - 2;
+
+	if (!(fc & IEEE80211_STYPE_QOS_DATA));
+		return 0;
+
+	if (*p & QOS_CONTROL_A_MSDU_PRESENT)
+		return 1;
+	else
+		return 0;
+}
+
+static ieee80211_txrx_result
+ieee80211_rx_h_data_agg(struct ieee80211_txrx_data *rx)
+{
+	struct net_device *dev = rx->dev;
+	struct ieee80211_local *local = rx->local;
+	u16 fc, hdrlen, ethertype;
+	u8 *payload;
+	struct sk_buff *skb = rx->skb, *skb2, *frame;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	const struct ethhdr* eth;
+
+	fc = rx->fc;
+	if (unlikely((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA))
+		return TXRX_CONTINUE;
+
+	if (unlikely(!WLAN_FC_DATA_PRESENT(fc)))
+		return TXRX_DROP;
+
+	if (!is_agg_frame(skb, fc))
+		return TXRX_CONTINUE;
+
+	hdrlen = ieee80211_get_hdrlen(fc);
+
+	payload = skb->data + hdrlen;
+
+	if (unlikely(skb->len - hdrlen < 8)) {
+		if (net_ratelimit()) {
+			printk(KERN_DEBUG "%s: RX too short data frame "
+				"payload\n", dev->name);
+		}
+		return TXRX_DROP;
+	}
+
+	ethertype = (payload[6] << 8) | payload[7];
+
+	if (likely((memcmp(payload, rfc1042_header, 6) == 0 &&
+		ethertype != ETH_P_AARP && ethertype != ETH_P_IPX) ||
+		memcmp(payload, bridge_tunnel_header, 6) == 0)) {
+		/* remove RFC1042 or Bridge-Tunnel encapsulation and
+		* replace EtherType */	
+		skb_pull(skb, hdrlen + 6);
+	} else {
+		skb_pull(skb, hdrlen);
+	}
+
+	eth = (struct ethhdr*)skb->data;
+
+	while ((u8*)eth < skb->data + skb->len) {
+        	unsigned int eth_len = sizeof(struct ethhdr) + 
+						ntohs(eth->h_proto);
+        
+		frame = dev_alloc_skb(3000);
+
+		if (frame == NULL) 
+			return TXRX_DROP;
+
+		frame->mac.raw = frame->data;
+		memcpy(skb_put(frame, eth_len), (u8*)eth, eth_len);
+
+		frame->dev = dev;
+
+		skb2 = NULL;
+
+		sdata->stats.rx_packets++;
+		sdata->stats.rx_bytes += frame->len;
+
+		if (local->bridge_packets && 
+		    (sdata->type == IEEE80211_IF_TYPE_AP ||
+		     sdata->type == IEEE80211_IF_TYPE_VLAN) && 
+                    rx->u.rx.ra_match) {
+			if (is_multicast_ether_addr(frame->data)) {
+				/* send multicast frames both to higher layers
+				* in local net stack and back to the wireless 
+				* media */
+				skb2 = skb_copy(frame, GFP_ATOMIC);
+				if (!skb2)
+					printk(KERN_DEBUG "%s: failed to clone "
+					"multicast frame\n", dev->name);
+			} else {
+				struct sta_info *dsta;
+				dsta = sta_info_get(local, frame->data);
+				if (dsta && !dsta->dev) {
+					printk(KERN_DEBUG "Station with null "
+					"dev structure!\n");
+                        	} else if (dsta && dsta->dev == dev) {
+                                	/* Destination station is associated 
+					* to this AP, so send the frame
+					* directly to it and do not pass 
+					* the frame to local net stack.
+					*/
+					skb2 = skb;
+					skb = NULL;
+				}
+				if (dsta)
+					sta_info_put(dsta);
+			}
+		}
+		if (frame) {
+			/* deliver to local stack */
+			frame->protocol = eth_type_trans(frame, dev);
+			memset(frame->cb, 0, sizeof(frame->cb));
+			netif_rx(frame);
+		}
+
+		if (skb2) {
+			/* send to wireless media */
+			skb2->protocol = __constant_htons(ETH_P_802_3);
+			skb2->mac.raw = skb2->nh.raw = skb2->data;
+			dev_queue_xmit(skb2);
+		}
+
+		eth = (struct ethhdr*)((u8*)eth + eth_len 
+					+ calc_pad_len(eth_len));
+	}
+
+	dev_kfree_skb(skb);
+        return TXRX_QUEUED;
+}
+
 static ieee80211_txrx_result
 ieee80211_rx_h_data(struct ieee80211_txrx_data *rx)
 {
@@ -4373,6 +4510,7 @@ static ieee80211_rx_handler ieee80211_rx
 	ieee80211_rx_h_remove_qos_control,
 	ieee80211_rx_h_802_1x_pae,
 	ieee80211_rx_h_drop_unencrypted,
+	ieee80211_rx_h_data_agg,
 	ieee80211_rx_h_data,
 	ieee80211_rx_h_mgmt,
 	NULL
diff -Nupr wireless-dev/net/mac80211/wme.h
wireless-dev-new/net/mac80211/wme.h
--- wireless-dev/net/mac80211/wme.h	2007-03-22 11:40:17.000000000 -0700
+++ wireless-dev-new/net/mac80211/wme.h	2007-03-27 01:48:34.000000000
-0700
@@ -24,6 +24,8 @@
 
 #define QOS_CONTROL_TAG1D_MASK 0x07
 
+#define QOS_CONTROL_A_MSDU_PRESENT 0x80
+
 ieee80211_txrx_result
 ieee80211_rx_h_parse_qos(struct ieee80211_txrx_data *rx);
 
