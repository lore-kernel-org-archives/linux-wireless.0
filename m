Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m12-18.163.com ([220.181.12.18]:34052 "EHLO m12-18.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbcAPNIJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jan 2016 08:08:09 -0500
From: Jia-Ju Bai <baijiaju1990@163.com>
To: andrea.merello@gmail.com, Larry.Finger@lwfinger.net,
	flamingice@sourmilk.net, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Jia-Ju Bai <baijiaju1990@163.com>
Subject: [PATCH resend] rtl818x_pci: Fix a memory leak in rtl8180_init_rx_ring
Date: Sat, 16 Jan 2016 21:07:12 +0800
Message-Id: <1452949632-16329-1-git-send-email-baijiaju1990@163.com> (sfid-20160116_140814_668318_36EF1645)
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


