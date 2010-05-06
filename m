Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46203 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757530Ab0EFUbq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 16:31:46 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/2] rtl8180: assign sequence numbers in the driver
Date: Thu,  6 May 2010 16:26:23 -0400
Message-Id: <1273177583-10643-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a step towards support for beaconing modes of operation.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/rtl818x/rtl8180.h     |    3 +++
 drivers/net/wireless/rtl818x/rtl8180_dev.c |   10 ++++++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180.h b/drivers/net/wireless/rtl818x/rtl8180.h
index de3844f..b92d678 100644
--- a/drivers/net/wireless/rtl818x/rtl8180.h
+++ b/drivers/net/wireless/rtl818x/rtl8180.h
@@ -78,6 +78,9 @@ struct rtl8180_priv {
 	u32 anaparam;
 	u16 rfparam;
 	u8 csthreshold;
+
+	/* sequence # */
+	u16 seqno;
 };
 
 void rtl8180_write_phy(struct ieee80211_hw *dev, u8 addr, u32 data);
diff --git a/drivers/net/wireless/rtl818x/rtl8180_dev.c b/drivers/net/wireless/rtl818x/rtl8180_dev.c
index a93eedc..a6fb9a6 100644
--- a/drivers/net/wireless/rtl818x/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180_dev.c
@@ -234,6 +234,7 @@ static irqreturn_t rtl8180_interrupt(int irq, void *dev_id)
 static int rtl8180_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct rtl8180_priv *priv = dev->priv;
 	struct rtl8180_tx_ring *ring;
 	struct rtl8180_tx_desc *entry;
@@ -285,6 +286,14 @@ static int rtl8180_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 	}
 
 	spin_lock_irqsave(&priv->lock, flags);
+
+	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
+		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
+			priv->seqno += 0x10;
+		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
+		hdr->seq_ctrl |= cpu_to_le16(priv->seqno);
+	}
+
 	idx = (ring->idx + skb_queue_len(&ring->queue)) % ring->entries;
 	entry = &ring->desc[idx];
 
@@ -299,6 +308,7 @@ static int rtl8180_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 	__skb_queue_tail(&ring->queue, skb);
 	if (ring->entries - skb_queue_len(&ring->queue) < 2)
 		ieee80211_stop_queue(dev, prio);
+
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	rtl818x_iowrite8(priv, &priv->map->TX_DMA_POLLING, (1 << (prio + 4)));
-- 
1.6.6.1

