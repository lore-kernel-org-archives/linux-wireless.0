Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47903 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab0G2UWm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 16:22:42 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/2] rtl8180: use NAPI for bottom-half processing
Date: Thu, 29 Jul 2010 16:14:14 -0400
Message-Id: <1280434454-3597-2-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1280434454-3597-1-git-send-email-linville@tuxdriver.com>
References: <1280434454-3597-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/rtl818x/rtl8180_dev.c |  130 +++++++++++++++-------------
 1 files changed, 71 insertions(+), 59 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180_dev.c b/drivers/net/wireless/rtl818x/rtl8180_dev.c
index d8b186a..b89daec 100644
--- a/drivers/net/wireless/rtl818x/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180_dev.c
@@ -99,19 +99,68 @@ void rtl8180_write_phy(struct ieee80211_hw *dev, u8 addr, u32 data)
 	}
 }
 
-static void rtl8180_handle_rx(struct ieee80211_hw *dev)
+static void rtl8180_handle_tx(struct ieee80211_hw *dev)
 {
 	struct rtl8180_priv *priv = dev->priv;
-	unsigned int count = 32;
+	struct rtl8180_tx_ring *ring;
+	int prio;
+
+	spin_lock(&priv->lock);
+
+	for (prio = 3; prio >= 0; prio--) {
+		ring = &priv->tx_ring[prio];
+
+		while (skb_queue_len(&ring->queue)) {
+			struct rtl8180_tx_desc *entry = &ring->desc[ring->idx];
+			struct sk_buff *skb;
+			struct ieee80211_tx_info *info;
+			u32 flags = le32_to_cpu(entry->flags);
+
+			if (flags & RTL818X_TX_DESC_FLAG_OWN)
+				break;
+
+			ring->idx = (ring->idx + 1) % ring->entries;
+			skb = __skb_dequeue(&ring->queue);
+			pci_unmap_single(priv->pdev, le32_to_cpu(entry->tx_buf),
+					 skb->len, PCI_DMA_TODEVICE);
+
+			info = IEEE80211_SKB_CB(skb);
+			ieee80211_tx_info_clear_status(info);
+
+			if (!(info->flags & IEEE80211_TX_CTL_NO_ACK) &&
+			    (flags & RTL818X_TX_DESC_FLAG_TX_OK))
+				info->flags |= IEEE80211_TX_STAT_ACK;
+
+			info->status.rates[0].count = (flags & 0xFF) + 1;
+			info->status.rates[1].idx = -1;
+
+			ieee80211_tx_status(dev, skb);
+			if (ring->entries - skb_queue_len(&ring->queue) == 2)
+				ieee80211_wake_queue(dev, prio);
+		}
+	}
+
+	spin_unlock(&priv->lock);
+}
+
+static int rtl8180_poll(struct napi_struct *napi, int budget)
+{
+	struct ieee80211_hw *dev =
+		container_of(napi, struct ieee80211_hw, napi);
+	struct rtl8180_priv *priv = dev->priv;
+	unsigned int count = 0;
 	u8 signal, agc, sq;
 
-	while (count--) {
+	/* handle pending Tx queue cleanup */
+	rtl8180_handle_tx(dev);
+
+	while (count++ < budget) {
 		struct rtl8180_rx_desc *entry = &priv->rx_ring[priv->rx_idx];
 		struct sk_buff *skb = priv->rx_buf[priv->rx_idx];
 		u32 flags = le32_to_cpu(entry->flags);
 
 		if (flags & RTL818X_RX_DESC_FLAG_OWN)
-			return;
+			break;
 
 		if (unlikely(flags & (RTL818X_RX_DESC_FLAG_DMA_FAIL |
 				      RTL818X_RX_DESC_FLAG_FOF |
@@ -151,7 +200,7 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
 				rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
 
 			memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
-			ieee80211_rx_irqsafe(dev, skb);
+			ieee80211_rx(dev, skb);
 
 			skb = new_skb;
 			priv->rx_buf[priv->rx_idx] = skb;
@@ -168,41 +217,16 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
 			entry->flags |= cpu_to_le32(RTL818X_RX_DESC_FLAG_EOR);
 		priv->rx_idx = (priv->rx_idx + 1) % 32;
 	}
-}
-
-static void rtl8180_handle_tx(struct ieee80211_hw *dev, unsigned int prio)
-{
-	struct rtl8180_priv *priv = dev->priv;
-	struct rtl8180_tx_ring *ring = &priv->tx_ring[prio];
-
-	while (skb_queue_len(&ring->queue)) {
-		struct rtl8180_tx_desc *entry = &ring->desc[ring->idx];
-		struct sk_buff *skb;
-		struct ieee80211_tx_info *info;
-		u32 flags = le32_to_cpu(entry->flags);
-
-		if (flags & RTL818X_TX_DESC_FLAG_OWN)
-			return;
-
-		ring->idx = (ring->idx + 1) % ring->entries;
-		skb = __skb_dequeue(&ring->queue);
-		pci_unmap_single(priv->pdev, le32_to_cpu(entry->tx_buf),
-				 skb->len, PCI_DMA_TODEVICE);
-
-		info = IEEE80211_SKB_CB(skb);
-		ieee80211_tx_info_clear_status(info);
-
-		if (!(info->flags & IEEE80211_TX_CTL_NO_ACK) &&
-		    (flags & RTL818X_TX_DESC_FLAG_TX_OK))
-			info->flags |= IEEE80211_TX_STAT_ACK;
 
-		info->status.rates[0].count = (flags & 0xFF) + 1;
-		info->status.rates[1].idx = -1;
+	if (count < budget) {
+		/* disable polling */
+		napi_complete(napi);
 
-		ieee80211_tx_status_irqsafe(dev, skb);
-		if (ring->entries - skb_queue_len(&ring->queue) == 2)
-			ieee80211_wake_queue(dev, prio);
+		/* enable interrupts */
+		rtl818x_iowrite16(priv, &priv->map->INT_MASK, 0xFFFF);
 	}
+
+	return count;
 }
 
 static irqreturn_t rtl8180_interrupt(int irq, void *dev_id)
@@ -211,31 +235,17 @@ static irqreturn_t rtl8180_interrupt(int irq, void *dev_id)
 	struct rtl8180_priv *priv = dev->priv;
 	u16 reg;
 
-	spin_lock(&priv->lock);
 	reg = rtl818x_ioread16(priv, &priv->map->INT_STATUS);
-	if (unlikely(reg == 0xFFFF)) {
-		spin_unlock(&priv->lock);
+	if (unlikely(reg == 0xFFFF))
 		return IRQ_HANDLED;
-	}
 
 	rtl818x_iowrite16(priv, &priv->map->INT_STATUS, reg);
 
-	if (reg & (RTL818X_INT_TXB_OK | RTL818X_INT_TXB_ERR))
-		rtl8180_handle_tx(dev, 3);
-
-	if (reg & (RTL818X_INT_TXH_OK | RTL818X_INT_TXH_ERR))
-		rtl8180_handle_tx(dev, 2);
-
-	if (reg & (RTL818X_INT_TXN_OK | RTL818X_INT_TXN_ERR))
-		rtl8180_handle_tx(dev, 1);
-
-	if (reg & (RTL818X_INT_TXL_OK | RTL818X_INT_TXL_ERR))
-		rtl8180_handle_tx(dev, 0);
-
-	if (reg & (RTL818X_INT_RX_OK | RTL818X_INT_RX_ERR))
-		rtl8180_handle_rx(dev);
+	/* disable interrupts */
+	rtl818x_iowrite16(priv, &priv->map->INT_MASK, 0);
 
-	spin_unlock(&priv->lock);
+	/* enable polling */
+	napi_schedule(&dev->napi);
 
 	return IRQ_HANDLED;
 }
@@ -247,7 +257,6 @@ static int rtl8180_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 	struct rtl8180_priv *priv = dev->priv;
 	struct rtl8180_tx_ring *ring;
 	struct rtl8180_tx_desc *entry;
-	unsigned long flags;
 	unsigned int idx, prio;
 	dma_addr_t mapping;
 	u32 tx_flags;
@@ -294,7 +303,7 @@ static int rtl8180_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 			plcp_len |= 1 << 15;
 	}
 
-	spin_lock_irqsave(&priv->lock, flags);
+	spin_lock(&priv->lock);
 
 	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
 		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
@@ -318,7 +327,7 @@ static int rtl8180_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 	if (ring->entries - skb_queue_len(&ring->queue) < 2)
 		ieee80211_stop_queue(dev, prio);
 
-	spin_unlock_irqrestore(&priv->lock, flags);
+	spin_unlock(&priv->lock);
 
 	rtl818x_iowrite8(priv, &priv->map->TX_DMA_POLLING, (1 << (prio + 4)));
 
@@ -861,6 +870,7 @@ static const struct ieee80211_ops rtl8180_ops = {
 	.prepare_multicast	= rtl8180_prepare_multicast,
 	.configure_filter	= rtl8180_configure_filter,
 	.get_tsf		= rtl8180_get_tsf,
+	.napi_poll		= rtl8180_poll,
 };
 
 static void rtl8180_eeprom_register_read(struct eeprom_93cx6 *eeprom)
@@ -992,6 +1002,8 @@ static int __devinit rtl8180_probe(struct pci_dev *pdev,
 	dev->queues = 1;
 	dev->max_signal = 65;
 
+	dev->napi_weight = 64;
+
 	reg = rtl818x_ioread32(priv, &priv->map->TX_CONF);
 	reg &= RTL818X_TX_CONF_HWVER_MASK;
 	switch (reg) {
-- 
1.7.1.1

