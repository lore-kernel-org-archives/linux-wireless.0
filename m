Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:42556 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403AbaBEVhr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Feb 2014 16:37:47 -0500
Received: by mail-ea0-f176.google.com with SMTP id h14so515619eaj.7
        for <linux-wireless@vger.kernel.org>; Wed, 05 Feb 2014 13:37:46 -0800 (PST)
From: andrea merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	"andrea.merello" <andrea.merello@gmail.com>
Subject: [PATCH 2/4]  Add error check for pci_map_single return value in rtl8180 RX path
Date: Wed,  5 Feb 2014 22:38:05 +0100
Message-Id: <1391636287-17712-3-git-send-email-andrea.merello@gmail.com> (sfid-20140205_223753_576131_4527CE61)
In-Reply-To: <1391636287-17712-1-git-send-email-andrea.merello@gmail.com>
References: <1391636287-17712-1-git-send-email-andrea.merello@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "andrea.merello" <andrea.merello@gmail.com>

In original code the old RX DMA buffer is unmapped and processed and at the end
of the isr a new buffer is mapped with pci_map_single and attached to the RX
descriptor.

If pci_map_single fails then the RX descriptor remains with no valid DMA buffer
attached.
In this condition the DMA will target where it shouldn't with obvious evil
consequences.

Simply avoiding re-arming the descriptor will prevent buggy DMA but it will
result soon in RX stuck.

This patch move the DMA mapping of the new buffer at the beginning of the ISR
(and it adds error check for pci_map_single success/fail).

If the DMA mapping fails then we do not unmap the old buffer and we re-arm the
descriptor without processing it, with the old DMA buffer still attached.

In this way we lose the currently RX-ed packet, but whenever next calls to
pci_map_single will succeed again,then the RX process will go on without stuck.

Signed-off-by: andrea.merello <andrea.merello@gmail.com>
Signed-off-by: andrea merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 79b9398..1c6ac25 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -107,6 +107,7 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
 	struct rtl8180_priv *priv = dev->priv;
 	unsigned int count = 32;
 	u8 signal, agc, sq;
+	dma_addr_t mapping;
 
 	while (count--) {
 		struct rtl8180_rx_desc *entry = &priv->rx_ring[priv->rx_idx];
@@ -128,6 +129,17 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
 			if (unlikely(!new_skb))
 				goto done;
 
+			mapping = pci_map_single(priv->pdev,
+					       skb_tail_pointer(new_skb),
+					       MAX_RX_SIZE, PCI_DMA_FROMDEVICE);
+
+			if (pci_dma_mapping_error(priv->pdev, mapping)) {
+				kfree_skb(new_skb);
+				dev_err(&priv->pdev->dev, "RX DMA map error\n");
+
+				goto done;
+			}
+
 			pci_unmap_single(priv->pdev,
 					 *((dma_addr_t *)skb->cb),
 					 MAX_RX_SIZE, PCI_DMA_FROMDEVICE);
@@ -158,9 +170,7 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
 
 			skb = new_skb;
 			priv->rx_buf[priv->rx_idx] = skb;
-			*((dma_addr_t *) skb->cb) =
-				pci_map_single(priv->pdev, skb_tail_pointer(skb),
-					       MAX_RX_SIZE, PCI_DMA_FROMDEVICE);
+			*((dma_addr_t *) skb->cb) = mapping;
 		}
 
 	done:
-- 
1.8.3.2

