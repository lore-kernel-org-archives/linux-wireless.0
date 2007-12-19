Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:51734 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751243AbXLSGRQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 01:17:16 -0500
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 5/6] rtl8180: reduce lock during TX
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Andrea Merello <andreamrl@tiscali.it>
Date: Wed, 19 Dec 2007 01:17:36 -0500
Message-ID: <20071219061736.4885.80801.stgit@tetra.sourmilk.net> (sfid-20071219_061723_875517_FBCBAFCC)
In-Reply-To: <20071219061735.4885.1535.stgit@tetra.sourmilk.net>
References: <20071219061735.4885.1535.stgit@tetra.sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrea Merello <andreamrl@tiscali.it>

There is no need to hold lock during rts duration and plcp length calculation.
Also fix missing endianness conversion for plcp length.

Signed-off-by: Andrea Merello <andreamrl@tiscali.it>
Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/rtl8180_dev.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rtl8180_dev.c b/drivers/net/wireless/rtl8180_dev.c
index 058f30f..3ab4922 100644
--- a/drivers/net/wireless/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl8180_dev.c
@@ -210,6 +210,8 @@ static int rtl8180_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
 	unsigned int idx, prio;
 	dma_addr_t mapping;
 	u32 tx_flags;
+	u16 plcp_len = 0;
+	__le16 rts_duration = 0;
 
 	prio = control->queue;
 	ring = &priv->tx_ring[prio];
@@ -233,24 +235,26 @@ static int rtl8180_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
 	*((struct ieee80211_tx_control **) skb->cb) =
 		kmemdup(control, sizeof(*control), GFP_ATOMIC);
 
-	spin_lock_irqsave(&priv->lock, flags);
-	idx = (ring->idx + skb_queue_len(&ring->queue)) % ring->entries;
-	entry = &ring->desc[idx];
-
 	if (control->flags & IEEE80211_TXCTL_USE_RTS_CTS)
-		entry->rts_duration =
-			ieee80211_rts_duration(dev, priv->if_id, skb->len, control);
+		rts_duration = ieee80211_rts_duration(dev, priv->if_id, skb->len, control);
 
 	if (!priv->r8185) {
 		unsigned int remainder;
 
-		entry->plcp_len =
-			DIV_ROUND_UP(16 * (skb->len + 4), (control->rate->rate * 2) / 10);
-		remainder = (16 * (skb->len + 4)) % ((control->rate->rate * 2) / 10);
+		plcp_len = DIV_ROUND_UP(16 * (skb->len + 4),
+					(control->rate->rate * 2) / 10);
+		remainder = (16 * (skb->len + 4)) %
+			    ((control->rate->rate * 2) / 10);
 		if (remainder > 0 && remainder <= 6)
-			entry->plcp_len |= 1 << 15;
+			plcp_len |= 1 << 15;
 	}
 
+	spin_lock_irqsave(&priv->lock, flags);
+	idx = (ring->idx + skb_queue_len(&ring->queue)) % ring->entries;
+	entry = &ring->desc[idx];
+
+	entry->rts_duration = rts_duration;
+	entry->plcp_len = cpu_to_le16(plcp_len);
 	entry->tx_buf = cpu_to_le32(mapping);
 	entry->frame_len = cpu_to_le32(skb->len);
 	entry->flags2 = control->alt_retry_rate != -1 ?


