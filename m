Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:47836 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753684AbXHaE65 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2007 00:58:57 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 5/6] adm8211: Improve TX path
Date: Fri, 31 Aug 2007 00:56:18 -0400
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Message-Id: <200708310056.18619.flamingice@sourmilk.net>
In-Reply-To: <20070831045328.3700.81232.stgit@magic.sourmilk.net>
References: <20070831045328.3700.81232.stgit@magic.sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8";
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

This patch makes the TX path a little better.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/adm8211.c |   59 ++++++++++++++++++++++------------------
 drivers/net/wireless/adm8211.h |    6 ++--
 2 files changed, 35 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index 4af3008..872b032 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -335,40 +335,44 @@ static int adm8211_get_tx_stats(struct ieee80211_hw *dev,
 static void adm8211_interrupt_tci(struct ieee80211_hw *dev)
 {
 	struct adm8211_priv *priv = dev->priv;
-	unsigned dirty_tx;
+	unsigned int dirty_tx;
 
 	spin_lock(&priv->lock);
 
 	for (dirty_tx = priv->dirty_tx; priv->cur_tx - dirty_tx; dirty_tx++) {
-		unsigned entry = dirty_tx % priv->tx_ring_size;
+		unsigned int entry = dirty_tx % priv->tx_ring_size;
 		u32 status = le32_to_cpu(priv->tx_ring[entry].status);
+		struct adm8211_tx_ring_info *info;
+		struct sk_buff *skb;
 
 		if (status & TDES0_CONTROL_OWN ||
 		    !(status & TDES0_CONTROL_DONE))
 			break;
 
+		info = &priv->tx_buffers[entry];
+		skb = info->skb;
+
 		/* TODO: check TDES0_STATUS_TUF and TDES0_STATUS_TRO */
 
-		pci_unmap_single(priv->pdev, priv->tx_buffers[entry].mapping,
-				 priv->tx_buffers[entry].skb->len,
-				 PCI_DMA_TODEVICE);
+		pci_unmap_single(priv->pdev, info->mapping,
+				 info->skb->len, PCI_DMA_TODEVICE);
 
-		if (priv->tx_buffers[entry].tx_control.flags &
-		    IEEE80211_TXCTL_REQ_TX_STATUS) {
+		if (info->tx_control.flags & IEEE80211_TXCTL_REQ_TX_STATUS) {
 			struct ieee80211_tx_status tx_status = {{0}};
 			struct ieee80211_hdr *hdr;
-			size_t hdrlen = ieee80211_get_hdrlen(le16_to_cpu(priv->tx_buffers[entry].hdr.frame_control));
-			hdr = (struct ieee80211_hdr *) skb_pull(priv->tx_buffers[entry].skb,
-								sizeof(struct adm8211_tx_hdr) - hdrlen);
-			memcpy(hdr, &priv->tx_buffers[entry].hdr, hdrlen);
-			memcpy(&tx_status.control, &priv->tx_buffers[entry].tx_control, sizeof(tx_status.control));
+			size_t hdrlen = info->hdrlen;
+
+			skb_pull(skb, sizeof(struct adm8211_tx_hdr));
+			hdr = (struct ieee80211_hdr *)skb_push(skb, hdrlen);
+			memcpy(hdr, skb->cb, hdrlen);
+			memcpy(&tx_status.control, &info->tx_control,
+			       sizeof(tx_status.control));
 			if (!(status & TDES0_STATUS_ES))
 				tx_status.flags |= IEEE80211_TX_STATUS_ACK;
-			ieee80211_tx_status_irqsafe(dev, priv->tx_buffers[entry].skb,
-						    &tx_status);
+			ieee80211_tx_status_irqsafe(dev, skb, &tx_status);
 		} else
-			dev_kfree_skb_irq(priv->tx_buffers[entry].skb);
-		priv->tx_buffers[entry].skb = NULL;
+			dev_kfree_skb_irq(skb);
+		info->skb = NULL;
 	}
 
 	if (priv->cur_tx - dirty_tx < priv->tx_ring_size - 2)
@@ -384,7 +388,7 @@ static void adm8211_interrupt_rci(struct ieee80211_hw *dev)
 	struct adm8211_priv *priv = dev->priv;
 	unsigned int entry = priv->cur_rx % priv->rx_ring_size;
 	u32 status;
-	unsigned pktlen;
+	unsigned int pktlen;
 	struct sk_buff *skb, *newskb;
 	unsigned int limit = priv->rx_ring_size;
 	static const u8 rate_tbl[] = {10, 20, 55, 110, 220};
@@ -1614,12 +1618,12 @@ static void adm8211_calc_durations(int *dur, int *plcp, size_t payload_len, int
 static void adm8211_tx_raw(struct ieee80211_hw *dev, struct sk_buff *skb,
 			   u16 plcp_signal,
 			   struct ieee80211_tx_control *control,
-			   struct ieee80211_hdr *hdr)
+			   size_t hdrlen)
 {
 	struct adm8211_priv *priv = dev->priv;
 	unsigned long flags;
 	dma_addr_t mapping;
-	unsigned entry;
+	unsigned int entry;
 	u32 flag;
 
 	mapping = pci_map_single(priv->pdev, skb->data, skb->len,
@@ -1640,7 +1644,7 @@ static void adm8211_tx_raw(struct ieee80211_hw *dev, struct sk_buff *skb,
 	priv->tx_buffers[entry].skb = skb;
 	priv->tx_buffers[entry].mapping = mapping;
 	memcpy(&priv->tx_buffers[entry].tx_control, control, sizeof(*control));
-	memcpy(&priv->tx_buffers[entry].hdr, hdr, sizeof(*hdr));
+	priv->tx_buffers[entry].hdrlen = hdrlen;
 	priv->tx_ring[entry].buffer1 = cpu_to_le32(mapping);
 
 	if (entry == priv->tx_ring_size - 1)
@@ -1667,7 +1671,7 @@ static int adm8211_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
 	u16 fc;
 	size_t payload_len, hdrlen;
 	int plcp, dur, len, plcp_signal, short_preamble;
-	struct ieee80211_hdr hdr;
+	struct ieee80211_hdr *hdr;
 
 	if (control->tx_rate < 0) {
 		short_preamble = 1;
@@ -1677,19 +1681,20 @@ static int adm8211_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
 		plcp_signal = control->tx_rate;
 	}
 
-	memcpy(&hdr, skb->data, sizeof(hdr));
-
-	fc = le16_to_cpu(hdr.frame_control) & ~IEEE80211_FCTL_PROTECTED;
+	hdr = (struct ieee80211_hdr *)skb->data;
+	fc = le16_to_cpu(hdr->frame_control) & ~IEEE80211_FCTL_PROTECTED;
 	hdrlen = ieee80211_get_hdrlen(fc);
+	memcpy(skb->cb, skb->data, hdrlen);
+	hdr = (struct ieee80211_hdr *)skb->cb;
 	skb_pull(skb, hdrlen);
 	payload_len = skb->len;
 
 	txhdr = (struct adm8211_tx_hdr *) skb_push(skb, sizeof(*txhdr));
 	memset(txhdr, 0, sizeof(*txhdr));
-	memcpy(txhdr->da, ieee80211_get_DA(&hdr), ETH_ALEN);
+	memcpy(txhdr->da, ieee80211_get_DA(hdr), ETH_ALEN);
 	txhdr->signal = plcp_signal;
 	txhdr->frame_body_size = cpu_to_le16(payload_len);
-	txhdr->frame_control = hdr.frame_control;
+	txhdr->frame_control = hdr->frame_control;
 
 	len = hdrlen + payload_len + FCS_LEN;
 	if (fc & IEEE80211_FCTL_PROTECTED)
@@ -1716,7 +1721,7 @@ static int adm8211_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
 
 	txhdr->retry_limit = control->retry_limit;
 
-	adm8211_tx_raw(dev, skb, plcp_signal, control, &hdr);
+	adm8211_tx_raw(dev, skb, plcp_signal, control, hdrlen);
 
 	return NETDEV_TX_OK;
 }
diff --git a/drivers/net/wireless/adm8211.h b/drivers/net/wireless/adm8211.h
index 926c66d..795d895 100644
--- a/drivers/net/wireless/adm8211.h
+++ b/drivers/net/wireless/adm8211.h
@@ -444,7 +444,7 @@ struct adm8211_tx_ring_info {
 	struct sk_buff *skb;
 	dma_addr_t mapping;
 	struct ieee80211_tx_control tx_control;
-	struct ieee80211_hdr hdr;
+	size_t hdrlen;
 };
 
 #define PLCP_SIGNAL_1M		0x0a
@@ -599,8 +599,8 @@ struct adm8211_priv {
 	dma_addr_t tx_ring_dma;
 	struct adm8211_rx_ring_info *rx_buffers;
 	struct adm8211_tx_ring_info *tx_buffers;
-	unsigned rx_ring_size, tx_ring_size;
-	unsigned cur_tx, dirty_tx, cur_rx;
+	unsigned int rx_ring_size, tx_ring_size;
+	unsigned int cur_tx, dirty_tx, cur_rx;
 
 	struct ieee80211_low_level_stats stats;
 	struct ieee80211_hw_mode modes[1];

