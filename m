Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:6273 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbZKZGAQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 01:00:16 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [RFC 1/2] wireless: add ieee80211_asmdu_to_8023s
Date: Thu, 26 Nov 2009 14:03:32 +0800
Message-Id: <1259215413-16753-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move the A-MSDU handling code from mac80211 to cfg80211 so that more
drivers can use it. The new created function ieee80211_asmdu_to_8023s
converts an A-MSDU frame to a list of 802.3 frames.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 include/net/cfg80211.h |   12 +++++
 net/mac80211/rx.c      |  107 ++++++++++-------------------------------------
 net/wireless/util.c    |  105 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 140 insertions(+), 84 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0884b9a..ad31b55 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1593,6 +1593,18 @@ int ieee80211_data_from_8023(struct sk_buff *skb, u8 *addr,
 			     enum nl80211_iftype iftype, u8 *bssid, bool qos);
 
 /**
+ * ieee80211_asmdu_to_8023s - decode an IEEE 802.11n A-MSDU frame
+ *
+ * @skb: The input IEEE 802.11n A-MSDU frame.
+ * @list: The output list of 802.3 frames. It must be allocated and
+ *      initialized by by the caller.
+ * @addr: The device MAC address.
+ * @iftype: The device interface type.
+ */
+int ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
+                             u8 *addr, enum nl80211_iftype iftype);
+
+/**
  * cfg80211_classify8021d - determine the 802.1p/1d tag for a data frame
  * @skb: the data frame
  */
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 57b8a0a..34ab25d 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1556,16 +1556,11 @@ static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
 {
 	struct net_device *dev = rx->sdata->dev;
-	struct ieee80211_local *local = rx->local;
-	u16 ethertype;
-	u8 *payload;
-	struct sk_buff *skb = rx->skb, *frame = NULL;
+	struct sk_buff *skb = rx->skb;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	__le16 fc = hdr->frame_control;
-	const struct ethhdr *eth;
-	int remaining, err;
-	u8 dst[ETH_ALEN];
-	u8 src[ETH_ALEN];
+	int err;
+	struct sk_buff_head frame_list;
 
 	if (unlikely(!ieee80211_is_data(fc)))
 		return RX_CONTINUE;
@@ -1576,92 +1571,36 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
 	if (!(rx->flags & IEEE80211_RX_AMSDU))
 		return RX_CONTINUE;
 
-	err = __ieee80211_data_to_8023(rx);
-	if (unlikely(err))
+	if (ieee80211_has_a4(hdr->frame_control) &&
+	    rx->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
+	    !rx->sdata->u.vlan.sta)
 		return RX_DROP_UNUSABLE;
 
-	skb->dev = dev;
-
-	dev->stats.rx_packets++;
-	dev->stats.rx_bytes += skb->len;
-
-	/* skip the wrapping header */
-	eth = (struct ethhdr *) skb_pull(skb, sizeof(struct ethhdr));
-	if (!eth)
+	if (is_multicast_ether_addr(hdr->addr1) &&
+	    ((rx->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
+	      rx->sdata->u.vlan.sta) ||
+	     (rx->sdata->vif.type == NL80211_IFTYPE_STATION &&
+	      rx->sdata->u.mgd.use_4addr)))
 		return RX_DROP_UNUSABLE;
 
-	while (skb != frame) {
-		u8 padding;
-		__be16 len = eth->h_proto;
-		unsigned int subframe_len = sizeof(struct ethhdr) + ntohs(len);
-
-		remaining = skb->len;
-		memcpy(dst, eth->h_dest, ETH_ALEN);
-		memcpy(src, eth->h_source, ETH_ALEN);
-
-		padding = ((4 - subframe_len) & 0x3);
-		/* the last MSDU has no padding */
-		if (subframe_len > remaining)
-			return RX_DROP_UNUSABLE;
-
-		skb_pull(skb, sizeof(struct ethhdr));
-		/* if last subframe reuse skb */
-		if (remaining <= subframe_len + padding)
-			frame = skb;
-		else {
-			/*
-			 * Allocate and reserve two bytes more for payload
-			 * alignment since sizeof(struct ethhdr) is 14.
-			 */
-			frame = dev_alloc_skb(
-				ALIGN(local->hw.extra_tx_headroom, 4) +
-				subframe_len + 2);
-
-			if (frame == NULL)
-				return RX_DROP_UNUSABLE;
+	skb->dev = dev;
+	skb_queue_head_init(&frame_list);
 
-			skb_reserve(frame,
-				    ALIGN(local->hw.extra_tx_headroom, 4) +
-				    sizeof(struct ethhdr) + 2);
-			memcpy(skb_put(frame, ntohs(len)), skb->data,
-				ntohs(len));
+	err = ieee80211_amsdu_to_8023s(skb, &frame_list, dev->dev_addr,
+				       rx->sdata->vif.type);
+	if (err)
+		return RX_DROP_UNUSABLE;
 
-			eth = (struct ethhdr *) skb_pull(skb, ntohs(len) +
-							padding);
-			if (!eth) {
-				dev_kfree_skb(frame);
-				return RX_DROP_UNUSABLE;
-			}
-		}
+	dev->stats.rx_packets++;
+	dev->stats.rx_bytes += skb->len;
 
-		skb_reset_network_header(frame);
-		frame->dev = dev;
-		frame->priority = skb->priority;
-		rx->skb = frame;
-
-		payload = frame->data;
-		ethertype = (payload[6] << 8) | payload[7];
-
-		if (likely((compare_ether_addr(payload, rfc1042_header) == 0 &&
-			    ethertype != ETH_P_AARP && ethertype != ETH_P_IPX) ||
-			   compare_ether_addr(payload,
-					      bridge_tunnel_header) == 0)) {
-			/* remove RFC1042 or Bridge-Tunnel
-			 * encapsulation and replace EtherType */
-			skb_pull(frame, 6);
-			memcpy(skb_push(frame, ETH_ALEN), src, ETH_ALEN);
-			memcpy(skb_push(frame, ETH_ALEN), dst, ETH_ALEN);
-		} else {
-			memcpy(skb_push(frame, sizeof(__be16)),
-			       &len, sizeof(__be16));
-			memcpy(skb_push(frame, ETH_ALEN), src, ETH_ALEN);
-			memcpy(skb_push(frame, ETH_ALEN), dst, ETH_ALEN);
-		}
+	while (!skb_queue_empty(&frame_list)) {
+		rx->skb = skb_dequeue(&frame_list);
 
 		if (!ieee80211_frame_allowed(rx, fc)) {
-			if (skb == frame) /* last frame */
+			if (skb == rx->skb) /* last frame */
 				return RX_DROP_UNUSABLE;
-			dev_kfree_skb(frame);
+			dev_kfree_skb(rx->skb);
 			continue;
 		}
 
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 59361fd..8ed98d7 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -497,6 +497,111 @@ int ieee80211_data_from_8023(struct sk_buff *skb, u8 *addr,
 }
 EXPORT_SYMBOL(ieee80211_data_from_8023);
 
+/**
+ * ieee80211_asmdu_to_8023s - decode an IEEE 802.11n A-MSDU frame
+ *
+ * Decode an IEEE 802.11n A-MSDU frame and convert it to a list of
+ * 802.3 frames. This function returns 0 on succeess. In this case,
+ * we optimize the code to reuse the @skb to hold the last 802.3
+ * frame in the @list.
+ *
+ * @skb: The input IEEE 802.11n A-MSDU frame.
+ * @list: The output list of 802.3 frames. It must be allocated and
+ *	initialized by by the caller.
+ * @addr: The device MAC address.
+ * @iftype: The device interface type.
+ */
+int ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
+			     u8 *addr, enum nl80211_iftype iftype)
+{
+	struct sk_buff *frame = NULL;
+	u16 ethertype;
+	u8 *payload;
+	const struct ethhdr *eth;
+	int remaining, err;
+	u8 dst[ETH_ALEN], src[ETH_ALEN];
+
+	err = ieee80211_data_to_8023(skb, addr, iftype);
+	if (err)
+		return err;
+
+	/* skip the wrapping header */
+	eth = (struct ethhdr *) skb_pull(skb, sizeof(struct ethhdr));
+	if (!eth)
+		return -1;
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
+		padding = (4 - subframe_len) & 0x3;
+		/* the last MSDU has no padding */
+		if (subframe_len > remaining)
+			goto purge;
+
+		skb_pull(skb, sizeof(struct ethhdr));
+		/* reuse skb for the last subframe */
+		if (remaining <= subframe_len + padding)
+			frame = skb;
+		else {
+			/*
+			 * Allocate and reserve two bytes more for payload
+			 * alignment since sizeof(struct ethhdr) is 14.
+			 */
+			frame = dev_alloc_skb(subframe_len + 2);
+			if (!frame)
+				goto purge;
+
+			skb_reserve(frame, sizeof(struct ethhdr) + 2);
+			memcpy(skb_put(frame, ntohs(len)), skb->data,
+				ntohs(len));
+
+			eth = (struct ethhdr *)skb_pull(skb, ntohs(len) +
+							padding);
+			if (!eth) {
+				dev_kfree_skb(frame);
+				goto purge;
+			}
+		}
+
+		skb_reset_network_header(frame);
+		frame->dev = skb->dev;
+		frame->priority = skb->priority;
+
+		payload = frame->data;
+		ethertype = (payload[6] << 8) | payload[7];
+
+		if (likely((compare_ether_addr(payload, rfc1042_header) == 0 &&
+			    ethertype != ETH_P_AARP && ethertype != ETH_P_IPX) ||
+			   compare_ether_addr(payload,
+					      bridge_tunnel_header) == 0)) {
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
+		skb_queue_tail(list, frame);
+	}
+
+	return 0;
+
+ purge:
+	skb_queue_purge(list);
+	return -1;
+}
+EXPORT_SYMBOL(ieee80211_amsdu_to_8023s);
+
 /* Given a data frame determine the 802.1p/1d tag to use. */
 unsigned int cfg80211_classify8021d(struct sk_buff *skb)
 {
-- 
1.6.0.4

