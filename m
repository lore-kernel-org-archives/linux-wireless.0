Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:7405 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab0AQWRr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2010 17:17:47 -0500
Received: by fg-out-1718.google.com with SMTP id 22so468482fge.1
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jan 2010 14:17:42 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] p54pci: handle dma mapping errors
Date: Sun, 17 Jan 2010 23:17:29 +0100
Cc: John W Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201001172317.29783.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds error-paths to handle pci_dma_mapping errors.

Cc: <stable@kernel.org>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
I'm surprised that no-one thought about this before?!
---
diff --git a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
index a15962a..7446373 100644
--- a/drivers/net/wireless/p54/p54pci.c
+++ b/drivers/net/wireless/p54/p54pci.c
@@ -157,6 +157,14 @@ static void p54p_refill_rx_ring(struct ieee80211_hw *dev,
 						 skb_tail_pointer(skb),
 						 priv->common.rx_mtu + 32,
 						 PCI_DMA_FROMDEVICE);
+
+			if (pci_dma_mapping_error(priv->pdev, mapping)) {
+				dev_kfree_skb_any(skb);
+				dev_err(&priv->pdev->dev,
+					"RX DMA Mapping error\n");
+				break;
+			}
+
 			desc->host_addr = cpu_to_le32(mapping);
 			desc->device_addr = 0;	// FIXME: necessary?
 			desc->len = cpu_to_le16(priv->common.rx_mtu + 32);
@@ -317,14 +325,20 @@ static void p54p_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 	u32 device_idx, idx, i;
 
 	spin_lock_irqsave(&priv->lock, flags);
-
 	device_idx = le32_to_cpu(ring_control->device_idx[1]);
 	idx = le32_to_cpu(ring_control->host_idx[1]);
 	i = idx % ARRAY_SIZE(ring_control->tx_data);
 
-	priv->tx_buf_data[i] = skb;
 	mapping = pci_map_single(priv->pdev, skb->data, skb->len,
 				 PCI_DMA_TODEVICE);
+	if (pci_dma_mapping_error(priv->pdev, mapping)) {
+		spin_unlock_irqrestore(&priv->lock, flags);
+		p54_free_skb(dev, skb);
+		dev_err(&priv->pdev->dev, "TX DMA mapping error\n");
+		return ;
+	}
+	priv->tx_buf_data[i] = skb;
+
 	desc = &ring_control->tx_data[i];
 	desc->host_addr = cpu_to_le32(mapping);
 	desc->device_addr = ((struct p54_hdr *)skb->data)->req_id;
