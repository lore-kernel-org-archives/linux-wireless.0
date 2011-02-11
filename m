Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61641 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab1BKAsn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 19:48:43 -0500
Received: by fxm20 with SMTP id 20so2116442fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 10 Feb 2011 16:48:42 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH for-2.6.38] p54pci: update receive dma buffers before and after processing
Date: Fri, 11 Feb 2011 01:48:42 +0100
Cc: linville@tuxdriver.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201102110148.43155.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Documentation/DMA-API-HOWTO.txt states:

"DMA transfers need to be synced properly in order for
the cpu and device to see the most uptodate and correct
copy of the DMA buffer."

Cc: <stable@kernel.org>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
Embarrassingly, this bug is unique to p54 and has been around
since 2.6.25. This tells us something interesting about our
userbase.
---
diff --git a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
index 1eacba4..0494d7b 100644
--- a/drivers/net/wireless/p54/p54pci.c
+++ b/drivers/net/wireless/p54/p54pci.c
@@ -199,6 +199,7 @@ static void p54p_check_rx_ring(struct ieee80211_hw *dev, u32 *index,
 	while (i != idx) {
 		u16 len;
 		struct sk_buff *skb;
+		dma_addr_t dma_addr;
 		desc = &ring[i];
 		len = le16_to_cpu(desc->len);
 		skb = rx_buf[i];
@@ -216,17 +217,20 @@ static void p54p_check_rx_ring(struct ieee80211_hw *dev, u32 *index,
 
 			len = priv->common.rx_mtu;
 		}
+		dma_addr = le32_to_cpu(desc->host_addr);
+		pci_dma_sync_single_for_cpu(priv->pdev, dma_addr,
+			priv->common.rx_mtu + 32, PCI_DMA_FROMDEVICE);
 		skb_put(skb, len);
 
 		if (p54_rx(dev, skb)) {
-			pci_unmap_single(priv->pdev,
-					 le32_to_cpu(desc->host_addr),
-					 priv->common.rx_mtu + 32,
-					 PCI_DMA_FROMDEVICE);
+			pci_unmap_single(priv->pdev, dma_addr,
+				priv->common.rx_mtu + 32, PCI_DMA_FROMDEVICE);
 			rx_buf[i] = NULL;
-			desc->host_addr = 0;
+			desc->host_addr = cpu_to_le32(0);
 		} else {
 			skb_trim(skb, 0);
+			pci_dma_sync_single_for_device(priv->pdev, dma_addr,
+				priv->common.rx_mtu + 32, PCI_DMA_FROMDEVICE);
 			desc->len = cpu_to_le16(priv->common.rx_mtu + 32);
 		}
 
