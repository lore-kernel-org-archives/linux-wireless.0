Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:57148 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742AbZK3RMO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 12:12:14 -0500
Date: Mon, 30 Nov 2009 18:12:20 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 04/12] mwl8k: fix addr4 zeroing and payload overwrite on DMA header creation
Message-ID: <20091130171220.GG20214@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When inserting a DMA header into a packet for transmission,
mwl8k_add_dma_header() would blindly zero the addr4 field, which
is not a good idea if the packet being transmitted is actually a
4-address packet.

Also, if the transmitted packet was a 4-address with QoS packet,
the memmove() to do the needed header reshuffling would inadvertently
overwrite the first two bytes of the packet payload with the QoS field.

This fixes both of these issues.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   29 +++++++++++++++--------------
 1 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 8eed851..0c90d85 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -728,35 +728,36 @@ static inline void mwl8k_remove_dma_header(struct sk_buff *skb, __le16 qos)
 static inline void mwl8k_add_dma_header(struct sk_buff *skb)
 {
 	struct ieee80211_hdr *wh;
-	u32 hdrlen, pktlen;
+	int hdrlen;
 	struct mwl8k_dma_data *tr;
 
+	/*
+	 * Add a firmware DMA header; the firmware requires that we
+	 * present a 2-byte payload length followed by a 4-address
+	 * header (without QoS field), followed (optionally) by any
+	 * WEP/ExtIV header (but only filled in for CCMP).
+	 */
 	wh = (struct ieee80211_hdr *)skb->data;
+
 	hdrlen = ieee80211_hdrlen(wh->frame_control);
-	pktlen = skb->len;
+	if (hdrlen != sizeof(*tr))
+		skb_push(skb, sizeof(*tr) - hdrlen);
 
-	/*
-	 * Copy up/down the 802.11 header; the firmware requires
-	 * we present a 2-byte payload length followed by a
-	 * 4-address header (w/o QoS), followed (optionally) by
-	 * any WEP/ExtIV header (but only filled in for CCMP).
-	 */
-	if (hdrlen != sizeof(struct mwl8k_dma_data))
-		skb_push(skb, sizeof(struct mwl8k_dma_data) - hdrlen);
+	if (ieee80211_is_data_qos(wh->frame_control))
+		hdrlen -= 2;
 
 	tr = (struct mwl8k_dma_data *)skb->data;
 	if (wh != &tr->wh)
 		memmove(&tr->wh, wh, hdrlen);
-
-	/* Clear addr4 */
-	memset(tr->wh.addr4, 0, ETH_ALEN);
+	if (hdrlen != sizeof(tr->wh))
+		memset(((void *)&tr->wh) + hdrlen, 0, sizeof(tr->wh) - hdrlen);
 
 	/*
 	 * Firmware length is the length of the fully formed "802.11
 	 * payload".  That is, everything except for the 802.11 header.
 	 * This includes all crypto material including the MIC.
 	 */
-	tr->fwlen = cpu_to_le16(pktlen - hdrlen);
+	tr->fwlen = cpu_to_le16(skb->len - sizeof(*tr));
 }
 
 
-- 
1.5.6.4
