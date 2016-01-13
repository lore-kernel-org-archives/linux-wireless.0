Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m12-12.163.com ([220.181.12.12]:55996 "EHLO m12-12.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754303AbcAMOpK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2016 09:45:10 -0500
From: Jia-Ju Bai <baijiaju1990@163.com>
To: andrea.merello@gmail.com, Larry.Finger@lwfinger.net,
	flamingice@sourmilk.net, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Jia-Ju Bai <baijiaju1990@163.com>
Subject: [PATCH] rtl818x_pci: Fix a memory leak in rtl8180_init_rx_ring
Date: Wed, 13 Jan 2016 22:44:32 +0800
Message-Id: <1452696272-31229-1-git-send-email-baijiaju1990@163.com> (sfid-20160113_154532_067285_D305D695)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When dev_alloc_skb or pci_dma_mapping_error in rtl8180_init_rx_ring fails,
the memory allocated by pci_zalloc_consistent is not freed.

This patch fixes the bug by adding pci_free_consistent
in error handling code.

Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
---
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
index a43a16f..28479b1 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
@@ -1018,6 +1018,8 @@ static int rtl8180_init_rx_ring(struct ieee80211_hw *dev)
 		dma_addr_t *mapping;
 		entry = priv->rx_ring + priv->rx_ring_sz*i;
 		if (!skb) {
+			pci_free_consistent(priv->pdev, priv->rx_ring_sz * 32,
+					priv->rx_ring, priv->rx_ring_dma);
 			wiphy_err(dev->wiphy, "Cannot allocate RX skb\n");
 			return -ENOMEM;
 		}
@@ -1028,6 +1030,8 @@ static int rtl8180_init_rx_ring(struct ieee80211_hw *dev)
 
 		if (pci_dma_mapping_error(priv->pdev, *mapping)) {
 			kfree_skb(skb);
+			pci_free_consistent(priv->pdev, priv->rx_ring_sz * 32,
+					priv->rx_ring, priv->rx_ring_dma);
 			wiphy_err(dev->wiphy, "Cannot map DMA for RX skb\n");
 			return -ENOMEM;
 		}
-- 
1.7.9.5


