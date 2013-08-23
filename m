Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51225 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754881Ab3HWWcu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 18:32:50 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 5/5] b43: call PCIe up and down functions
Date: Sat, 24 Aug 2013 00:32:34 +0200
Message-Id: <1377297154-14525-5-git-send-email-hauke@hauke-m.de> (sfid-20130824_003255_401804_5BC2B9B6)
In-Reply-To: <1377297154-14525-1-git-send-email-hauke@hauke-m.de>
References: <1377297154-14525-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tell the PCIe host core when the wifi is activated.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/b43/main.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 0e933bb..ccd24f0a 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4645,6 +4645,19 @@ static void b43_wireless_core_exit(struct b43_wldev *dev)
 	b43_maskset32(dev, B43_MMIO_MACCTL, ~B43_MACCTL_PSM_RUN,
 		      B43_MACCTL_PSM_JMP0);
 
+	switch (dev->dev->bus_type) {
+#ifdef CONFIG_B43_BCMA
+	case B43_BUS_BCMA:
+		bcma_core_pci_down(dev->dev->bdev->bus);
+		break;
+#endif
+#ifdef CONFIG_B43_SSB
+	case B43_BUS_SSB:
+		/* TODO */
+		break;
+#endif
+	}
+
 	b43_dma_free(dev);
 	b43_pio_free(dev);
 	b43_chip_exit(dev);
@@ -4684,6 +4697,7 @@ static int b43_wireless_core_init(struct b43_wldev *dev)
 	case B43_BUS_BCMA:
 		bcma_core_pci_irq_ctl(&dev->dev->bdev->bus->drv_pci[0],
 				      dev->dev->bdev, true);
+		bcma_core_pci_up(dev->dev->bdev->bus);
 		break;
 #endif
 #ifdef CONFIG_B43_SSB
-- 
1.7.10.4

