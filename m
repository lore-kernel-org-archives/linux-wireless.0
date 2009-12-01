Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:13884 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbZLACPS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 21:15:18 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v4 1/2] wireless: add ieee80211_amsdu_to_8023s
Date: Tue,  1 Dec 2009 10:18:37 +0800
Message-Id: <1259633918-17517-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move the A-MSDU handling code from mac80211 to cfg80211 so that more
drivers can use it. The new created function ieee80211_amsdu_to_8023s
converts an A-MSDU frame to a list of 802.3 frames.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
V2: use __ version of sk_buff_head operations and mark addr const
V3: add parameter extra_headroom to ieee80211_amsdu_to_8023s
    consume the input skb in ieee80211_amsdu_to_8023s
V4: make ieee80211_amsdu_to_8023s void

 include/net/cfg80211.h |   22 +++++++++-
 net/mac80211/rx.c      |  106 +++++++++---------------------------------------
 net/wireless/util.c    |   99 +++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 137 insertions(+), 90 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0884b9a..542a477 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1578,7 +1578,7 @@ unsigned int ieee80211_hdrlen(__le16 fc);
  * @addr: the device MAC address
  * @iftype: the virtual interface type
  */
-int ieee80211_data_to_8023(struct sk_buff *skb, u8 *addr,
+int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
 			   enum nl80211_iftype iftype);
 
 /**
@@ -1589,10 +1589,28 @@ int ieee80211_data_to_8023(struct sk_buff *skb, u8 *addr,
  * @bssid: the network bssid (used only for iftype STATION and ADHOC)
  * @qos: build 802.11 QoS data frame
  */
-int ieee80211_data_from_8023(struct sk_buff *skb, u8 *addr,
+int ieee80211_data_from_8023(struct sk_buff *skb, const u8 *addr,
 			     enum nl80211_iftype iftype, u8 *bssid, bool qos);
 
 /**
+ * ieee80211_amsdu_to_8023s - decode an IEEE 802.11n A-MSDU frame
+ *
+ * Decode an IEEE 802.11n A-MSDU frame and convert it to a list of
+ * 802.3 frames. The @list will be empty if the decode fails. The
+ * @skb is consumed after the function returns.
+ *
+ * @skb: The input IEEE 802.11n A-MSDU frame.
+ * @list: The output list of 802.3 frames. It must be allocated and
+ *	initialized by by the caller.
+ * @addr: The device MAC address.
+ * @iftype: The device interface type.
+ * @extra_headroom: The hardware extra headroom for SKBs in the @list.
+ */
+void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
+			      const u8 *addr, enum nl80211_iftype iftype,
+			      const unsigned int extra_headroom);
+
+/**
  * cfg80211_classify8021d - determine the 802.1p/1d tag for a data frame
  * @skb: the data frame
  */
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 57b8a0a..fa12eb5 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1556,16 +1556,10 @@ static ieee80211_rx_result debug_noinline
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
+	struct sk_buff_head frame_list;
 
 	if (unlikely(!ieee80211_is_data(fc)))
 		return RX_CONTINUE;
@@ -1576,94 +1570,34 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
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
+	skb->dev = dev;
+	__skb_queue_head_init(&frame_list);
 
-		padding = ((4 - subframe_len) & 0x3);
-		/* the last MSDU has no padding */
-		if (subframe_len > remaining)
-			return RX_DROP_UNUSABLE;
+	ieee80211_amsdu_to_8023s(skb, &frame_list, dev->dev_addr,
+				 rx->sdata->vif.type,
+				 rx->local->hw.extra_tx_headroom);
 
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
-
-			skb_reserve(frame,
-				    ALIGN(local->hw.extra_tx_headroom, 4) +
-				    sizeof(struct ethhdr) + 2);
-			memcpy(skb_put(frame, ntohs(len)), skb->data,
-				ntohs(len));
-
-			eth = (struct ethhdr *) skb_pull(skb, ntohs(len) +
-							padding);
-			if (!eth) {
-				dev_kfree_skb(frame);
-				return RX_DROP_UNUSABLE;
-			}
-		}
-
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
+		rx->skb = __skb_dequeue(&frame_list);
 
 		if (!ieee80211_frame_allowed(rx, fc)) {
-			if (skb == frame) /* last frame */
-				return RX_DROP_UNUSABLE;
-			dev_kfree_skb(frame);
+			dev_kfree_skb(rx->skb);
 			continue;
 		}
+		dev->stats.rx_packets++;
+		dev->stats.rx_bytes += rx->skb->len;
 
 		ieee80211_deliver_skb(rx);
 	}
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 59361fd..3555aee 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -285,7 +285,7 @@ static int ieee80211_get_mesh_hdrlen(struct ieee80211s_hdr *meshhdr)
 	}
 }
 
-int ieee80211_data_to_8023(struct sk_buff *skb, u8 *addr,
+int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
 			   enum nl80211_iftype iftype)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
@@ -383,7 +383,7 @@ int ieee80211_data_to_8023(struct sk_buff *skb, u8 *addr,
 }
 EXPORT_SYMBOL(ieee80211_data_to_8023);
 
-int ieee80211_data_from_8023(struct sk_buff *skb, u8 *addr,
+int ieee80211_data_from_8023(struct sk_buff *skb, const u8 *addr,
 			     enum nl80211_iftype iftype, u8 *bssid, bool qos)
 {
 	struct ieee80211_hdr hdr;
@@ -497,6 +497,101 @@ int ieee80211_data_from_8023(struct sk_buff *skb, u8 *addr,
 }
 EXPORT_SYMBOL(ieee80211_data_from_8023);
 
+
+void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
+			      const u8 *addr, enum nl80211_iftype iftype,
+			      const unsigned int extra_headroom)
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
+		goto out;
+
+	/* skip the wrapping header */
+	eth = (struct ethhdr *) skb_pull(skb, sizeof(struct ethhdr));
+	if (!eth)
+		goto out;
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
+			unsigned int hlen = ALIGN(extra_headroom, 4);
+			/*
+			 * Allocate and reserve two bytes more for payload
+			 * alignment since sizeof(struct ethhdr) is 14.
+			 */
+			frame = dev_alloc_skb(hlen + subframe_len + 2);
+			if (!frame)
+				goto purge;
+
+			skb_reserve(frame, hlen + sizeof(struct ethhdr) + 2);
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
+		__skb_queue_tail(list, frame);
+	}
+
+	return;
+
+ purge:
+	__skb_queue_purge(list);
+ out:
+	dev_kfree_skb(skb);
+}
+EXPORT_SYMBOL(ieee80211_amsdu_to_8023s);
+
 /* Given a data frame determine the 802.1p/1d tag to use. */
 unsigned int cfg80211_classify8021d(struct sk_buff *skb)
 {
-- 
1.6.0.4

