Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:56631 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbaCVRuN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Mar 2014 13:50:13 -0400
Received: by mail-ee0-f53.google.com with SMTP id b57so2906431eek.40
        for <linux-wireless@vger.kernel.org>; Sat, 22 Mar 2014 10:50:12 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: andrea.merello@gmail.com, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net, bernhard@schiffner-limbach.de,
	dan.carpenter@oracle.com
Subject: [PATCH 2/2] rtl8180: rationalize TX queues
Date: Sat, 22 Mar 2014 18:51:20 +0100
Message-Id: <1395510680-17119-1-git-send-email-andrea.merello@gmail.com> (sfid-20140322_185019_042312_49BD20B3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On currently supported HW there are four TX queues (three for normal
packets and one for beacons).

The driver uses just one TX queue, and declare to mac80211 to
support just one queue, but it allocates coherent memory for all
queues.
Furthermore the TX is code is written assumimg four queues exists,
and even if we decide to enable more queues in future, its mapping
rule to mac80211 is fixed.

This means we have memory waste on rtl8180/rtl8185, and we have also
not enough flexibility to add support for boards (rtl8187se) that
will use more queues.

This patch changes things in order to allocate coherent memory only
for the queues effectively used and it make it possible to specify
how to map hardware queues on mac80211 queues, that will be used
by rtl8187se code as soon it will be merged.

Note: even if the beacon queue is currently unused, this should
change, so I kept it.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c     | 58 +++++++++++++++++++-------
 drivers/net/wireless/rtl818x/rtl8180/rtl8180.h |  7 +++-
 2 files changed, 49 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 091eb2e..767e104 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -85,6 +85,30 @@ static const struct ieee80211_channel rtl818x_channels[] = {
 	{ .center_freq = 2484 },
 };
 
+/* Queues for rtl8180/rtl8185 cards
+ *
+ * name | reg  |  prio
+ *  BC  |  7   |   3
+ *  HI  |  6   |   0
+ *  NO  |  5   |   1
+ *  LO  |  4   |   2
+ *
+ * The complete map for DMA kick reg using all queue is:
+ * static const int rtl8180_queues_map[RTL8180_NR_TX_QUEUES] = {6, 5, 4, 7};
+ *
+ * .. but .. Because the mac80211 needs at least 4 queues for QoS or
+ * otherwise QoS can't be done, we use just one.
+ * Beacon queue could be used, but this is not finished yet.
+ * Actual map is:
+ *
+ * name | reg  |  prio
+ *  BC  |  7   |   1  <- currently not used yet.
+ *  HI  |  6   |   x  <- not used
+ *  NO  |  5   |   x  <- not used
+ *  LO  |  4   |   0  <- used
+ */
+
+static const int rtl8180_queues_map[RTL8180_NR_TX_QUEUES] = {4, 7};
 
 void rtl8180_write_phy(struct ieee80211_hw *dev, u8 addr, u32 data)
 {
@@ -235,12 +259,6 @@ static irqreturn_t rtl8180_interrupt(int irq, void *dev_id)
 	rtl818x_iowrite16(priv, &priv->map->INT_STATUS, reg);
 
 	if (reg & (RTL818X_INT_TXB_OK | RTL818X_INT_TXB_ERR))
-		rtl8180_handle_tx(dev, 3);
-
-	if (reg & (RTL818X_INT_TXH_OK | RTL818X_INT_TXH_ERR))
-		rtl8180_handle_tx(dev, 2);
-
-	if (reg & (RTL818X_INT_TXN_OK | RTL818X_INT_TXN_ERR))
 		rtl8180_handle_tx(dev, 1);
 
 	if (reg & (RTL818X_INT_TXL_OK | RTL818X_INT_TXL_ERR))
@@ -264,7 +282,7 @@ static void rtl8180_tx(struct ieee80211_hw *dev,
 	struct rtl8180_tx_ring *ring;
 	struct rtl8180_tx_desc *entry;
 	unsigned long flags;
-	unsigned int idx, prio;
+	unsigned int idx, prio, hw_prio;
 	dma_addr_t mapping;
 	u32 tx_flags;
 	u8 rc_flags;
@@ -354,7 +372,11 @@ static void rtl8180_tx(struct ieee80211_hw *dev,
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	rtl818x_iowrite8(priv, &priv->map->TX_DMA_POLLING, (1 << (prio + 4)));
+	hw_prio = rtl8180_queues_map[prio];
+
+	rtl818x_iowrite8(priv, &priv->map->TX_DMA_POLLING,
+			 (1 << hw_prio) | /* ring to poll  */
+			 (1<<1) | (1<<2));/* stopped rings */
 }
 
 void rtl8180_set_anaparam(struct rtl8180_priv *priv, u32 anaparam)
@@ -447,9 +469,7 @@ static int rtl8180_init_hw(struct ieee80211_hw *dev)
 		rtl8180_set_anaparam(priv, priv->anaparam);
 
 	rtl818x_iowrite32(priv, &priv->map->RDSAR, priv->rx_ring_dma);
-	rtl818x_iowrite32(priv, &priv->map->TBDA, priv->tx_ring[3].dma);
-	rtl818x_iowrite32(priv, &priv->map->THPDA, priv->tx_ring[2].dma);
-	rtl818x_iowrite32(priv, &priv->map->TNPDA, priv->tx_ring[1].dma);
+	rtl818x_iowrite32(priv, &priv->map->TBDA, priv->tx_ring[1].dma);
 	rtl818x_iowrite32(priv, &priv->map->TLPDA, priv->tx_ring[0].dma);
 
 	/* TODO: necessary? specs indicate not */
@@ -627,7 +647,7 @@ static int rtl8180_start(struct ieee80211_hw *dev)
 	if (ret)
 		return ret;
 
-	for (i = 0; i < 4; i++)
+	for (i = 0; i < (dev->queues + 1); i++)
 		if ((ret = rtl8180_init_tx_ring(dev, i, 16)))
 			goto err_free_rings;
 
@@ -722,7 +742,7 @@ static int rtl8180_start(struct ieee80211_hw *dev)
 
  err_free_rings:
 	rtl8180_free_rx_ring(dev);
-	for (i = 0; i < 4; i++)
+	for (i = 0; i < (dev->queues + 1); i++)
 		if (priv->tx_ring[i].desc)
 			rtl8180_free_tx_ring(dev, i);
 
@@ -752,7 +772,7 @@ static void rtl8180_stop(struct ieee80211_hw *dev)
 	free_irq(priv->pdev->irq, dev);
 
 	rtl8180_free_rx_ring(dev);
-	for (i = 0; i < 4; i++)
+	for (i = 0; i < (dev->queues + 1); i++)
 		rtl8180_free_tx_ring(dev, i);
 }
 
@@ -1215,7 +1235,6 @@ static int rtl8180_probe(struct pci_dev *pdev,
 	dev->vif_data_size = sizeof(struct rtl8180_vif);
 	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 					BIT(NL80211_IFTYPE_ADHOC);
-	dev->queues = 1;
 	dev->max_signal = 65;
 
 	reg = rtl818x_ioread32(priv, &priv->map->TX_CONF);
@@ -1246,6 +1265,15 @@ static int rtl8180_probe(struct pci_dev *pdev,
 		goto err_iounmap;
 	}
 
+	/* we declare to MAC80211 all the queues except for beacon queue
+	 * that will be eventually handled by DRV.
+	 * TX rings are arranged in such a way that lower is the IDX,
+	 * higher is the priority, in order to achieve direct mapping
+	 * with mac80211, however the beacon queue is an exception and it
+	 * is mapped on the highst tx ring IDX.
+	 */
+	dev->queues = RTL8180_NR_TX_QUEUES - 1;
+
 	if (priv->chip_family != RTL818X_CHIP_FAMILY_RTL8180) {
 		priv->band.n_bitrates = ARRAY_SIZE(rtl818x_rates);
 		pci_try_set_mwi(pdev);
diff --git a/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h b/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h
index 26383d7..ad64c5e 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h
+++ b/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h
@@ -24,6 +24,11 @@
 #define ANAPARAM_PWR1_SHIFT	20
 #define ANAPARAM_PWR1_MASK	(0x7F << ANAPARAM_PWR1_SHIFT)
 
+/* rtl8180/rtl8185 have 3 queue + beacon queue.
+ * mac80211 can use just one, + beacon = 2 tot.
+ */
+#define RTL8180_NR_TX_QUEUES 2
+
 struct rtl8180_tx_desc {
 	__le32 flags;
 	__le16 rts_duration;
@@ -75,7 +80,7 @@ struct rtl8180_priv {
 	dma_addr_t rx_ring_dma;
 	unsigned int rx_idx;
 	struct sk_buff *rx_buf[32];
-	struct rtl8180_tx_ring tx_ring[4];
+	struct rtl8180_tx_ring tx_ring[RTL8180_NR_TX_QUEUES];
 	struct ieee80211_channel channels[14];
 	struct ieee80211_rate rates[12];
 	struct ieee80211_supported_band band;
-- 
1.8.3.2

