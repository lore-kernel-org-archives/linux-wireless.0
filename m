Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43031 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbZAFX0A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 18:26:00 -0500
Subject: [PATCH] mac80211: clarify alignment docs, fix up alignment
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 07 Jan 2009 00:26:10 +0100
Message-Id: <1231284370.22613.0.camel@johannes> (sfid-20090107_002607_246543_F9F4AD1F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Not all drivers are capable of passing properly aligned frames,
in particular with mesh networking no hardware will support
completely aligning it correctly.

This patch adds code to align the data payload to a 4-byte 
boundary in memory for those platforms that require this, or
when CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT is set.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 Documentation/DocBook/mac80211.tmpl |    4 -
 net/mac80211/rx.c                   |  110 +++++++++++++++++++++++++-----------
 2 files changed, 79 insertions(+), 35 deletions(-)

--- wireless-testing.orig/Documentation/DocBook/mac80211.tmpl	2009-01-06 23:26:47.000000000 +0100
+++ wireless-testing/Documentation/DocBook/mac80211.tmpl	2009-01-06 23:26:51.000000000 +0100
@@ -164,8 +164,8 @@ usage should require reading the full do
 !Pinclude/net/mac80211.h Frame format
       </sect1>
       <sect1>
-        <title>Alignment issues</title>
-        <para>TBD</para>
+        <title>Packet alignment</title>
+!Pnet/mac80211/rx.c Packet alignment
       </sect1>
       <sect1>
         <title>Calling into mac80211 from interrupts</title>
--- wireless-testing.orig/net/mac80211/rx.c	2009-01-06 23:18:13.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2009-01-07 00:14:34.000000000 +0100
@@ -102,7 +102,7 @@ ieee80211_rx_radiotap_len(struct ieee802
 	return len;
 }
 
-/**
+/*
  * ieee80211_add_rx_radiotap_header - add radiotap header
  *
  * add a radiotap header containing all the fields which the hardware provided.
@@ -372,39 +372,50 @@ static void ieee80211_parse_qos(struct i
 	rx->skb->priority = (tid > 7) ? 0 : tid;
 }
 
-static void ieee80211_verify_ip_alignment(struct ieee80211_rx_data *rx)
+/**
+ * DOC: Packet alignment
+ *
+ * Drivers always need to pass packets that are aligned to two-byte boundaries
+ * to the stack.
+ *
+ * Additionally, should, if possible, align the payload data in a way that
+ * guarantees that the contained IP header is aligned to a four-byte
+ * boundary. In the case of regular frames, this simply means aligning the
+ * payload to a four-byte boundary (because either the IP header is directly
+ * contained, or IV/RFC1042 headers that have a length divisible by four are
+ * in front of it).
+ *
+ * With A-MSDU frames, however, the payload data address must yield two modulo
+ * four because there are 14-byte 802.3 headers within the A-MSDU frames that
+ * push the IP header further back to a multiple of four again. Thankfully, the
+ * specs were sane enough this time around to require padding each A-MSDU
+ * subframe to a length that is a multiple of four.
+ *
+ * Padding like Atheros hardware adds which is inbetween the 802.11 header and
+ * the payload is not supported, the driver is required to move the 802.11
+ * header to be directly in front of the payload in that case.
+ */
+static void ieee80211_verify_alignment(struct ieee80211_rx_data *rx)
 {
-#ifdef CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 	int hdrlen;
 
+#ifndef CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT
+	return;
+#endif
+
+	if (WARN_ONCE((unsigned long)rx->skb->data & 1,
+		      "unaligned packet at 0x%p\n", rx->skb->data))
+		return;
+
 	if (!ieee80211_is_data_present(hdr->frame_control))
 		return;
 
-	/*
-	 * Drivers are required to align the payload data in a way that
-	 * guarantees that the contained IP header is aligned to a four-
-	 * byte boundary. In the case of regular frames, this simply means
-	 * aligning the payload to a four-byte boundary (because either
-	 * the IP header is directly contained, or IV/RFC1042 headers that
-	 * have a length divisible by four are in front of it.
-	 *
-	 * With A-MSDU frames, however, the payload data address must
-	 * yield two modulo four because there are 14-byte 802.3 headers
-	 * within the A-MSDU frames that push the IP header further back
-	 * to a multiple of four again. Thankfully, the specs were sane
-	 * enough this time around to require padding each A-MSDU subframe
-	 * to a length that is a multiple of four.
-	 *
-	 * Padding like atheros hardware adds which is inbetween the 802.11
-	 * header and the payload is not supported, the driver is required
-	 * to move the 802.11 header further back in that case.
-	 */
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	if (rx->flags & IEEE80211_RX_AMSDU)
 		hdrlen += ETH_HLEN;
-	WARN_ON_ONCE(((unsigned long)(rx->skb->data + hdrlen)) & 3);
-#endif
+	WARN_ONCE(((unsigned long)(rx->skb->data + hdrlen)) & 3,
+		  "unaligned IP payload at 0x%p\n", rx->skb->data + hdrlen);
 }
 
 
@@ -1279,10 +1290,37 @@ ieee80211_deliver_skb(struct ieee80211_r
 	}
 
 	if (skb) {
-		/* deliver to local stack */
-		skb->protocol = eth_type_trans(skb, dev);
-		memset(skb->cb, 0, sizeof(skb->cb));
-		netif_rx(skb);
+		int align __maybe_unused;
+
+#if defined(CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT) || !defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
+		/*
+		 * 'align' will only take the values 0 or 2 here
+		 * since all frames are required to be aligned
+		 * to 2-byte boundaries when being passed to
+		 * mac80211. That also explains the __skb_push()
+		 * below.
+		 */
+		align = (unsigned long)skb->data & 4;
+		if (align) {
+			if (WARN_ON(skb_headroom(skb) < 3)) {
+				dev_kfree_skb(skb);
+				skb = NULL;
+			} else {
+				u8 *data = skb->data;
+				size_t len = skb->len;
+				u8 *new = __skb_push(skb, align);
+				memmove(new, data, len);
+				__skb_trim(skb, len);
+			}
+		}
+#endif
+
+		if (skb) {
+			/* deliver to local stack */
+			skb->protocol = eth_type_trans(skb, dev);
+			memset(skb->cb, 0, sizeof(skb->cb));
+			netif_rx(skb);
+		}
 	}
 
 	if (xmit_skb) {
@@ -1352,14 +1390,20 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx
 		if (remaining <= subframe_len + padding)
 			frame = skb;
 		else {
-			frame = dev_alloc_skb(local->hw.extra_tx_headroom +
-					      subframe_len);
+			/*
+			 * Allocate and reserve two bytes more for payload
+			 * alignment since sizeof(struct ethhdr) is 14.
+			 */
+			frame = dev_alloc_skb(
+				ALIGN(local->hw.extra_tx_headroom, 4) +
+				subframe_len + 2);
 
 			if (frame == NULL)
 				return RX_DROP_UNUSABLE;
 
-			skb_reserve(frame, local->hw.extra_tx_headroom +
-				    sizeof(struct ethhdr));
+			skb_reserve(frame,
+				    ALIGN(local->hw.extra_tx_headroom, 4) +
+				    sizeof(struct ethhdr) + 2);
 			memcpy(skb_put(frame, ntohs(len)), skb->data,
 				ntohs(len));
 
@@ -1971,7 +2015,7 @@ static void __ieee80211_rx_handle_packet
 		rx.flags |= IEEE80211_RX_IN_SCAN;
 
 	ieee80211_parse_qos(&rx);
-	ieee80211_verify_ip_alignment(&rx);
+	ieee80211_verify_alignment(&rx);
 
 	skb = rx.skb;
 


