Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:36261 "EHLO
	mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbcCRC1R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 22:27:17 -0400
Received: by mail-pf0-f175.google.com with SMTP id u190so146235747pfb.3
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 19:27:16 -0700 (PDT)
From: Julian Calaby <julian.calaby@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Jia-Ju Bai <baijiaju1990@163.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Andrea Merello <andrea.merello@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH MOREWORK 14/19] rtl818x_pci: Fix a memory leak in rtl8180_init_rx_ring
Date: Fri, 18 Mar 2016 13:27:09 +1100
Message-Id: <4920ab8faf66e456a1fad1e79607d15a04cbb029.1458262312.git.julian.calaby@gmail.com> (sfid-20160318_032721_426752_F4064B1B)
In-Reply-To: <cover.1458262312.git.julian.calaby@gmail.com>
References: <cover.1458262312.git.julian.calaby@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jia-Ju Bai <baijiaju1990@163.com>

When dev_alloc_skb or pci_dma_mapping_error in rtl8180_init_rx_ring fails,
the memory allocated by pci_zalloc_consistent is not freed.

This patch fixes the bug by adding pci_free_consistent
in error handling code.

Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
Signed-off-by: Julian Calaby <julian.calaby@gmail.com>

---

Could someone else please review this?

In particular, immediately after the call to pci_zalloc_coherent(), it
fails if the result is null or if '(unsigned long)result & 0xFF'.

Is the second arm of the or statement possible, and if so, should we be
pci_free_coherent()ing the result there too?

I've had a quick scout around and this check seems to be particular to
realtek drivers.

Thanks,

Julian Calaby
---
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
index c76af5d..a8a23d5 100644
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
2.7.0

