Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:52526 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932757AbcCQJUy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 05:20:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Kalle Valo <kvalo@codeaurora.org>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] bcma: use of_dma_configure() to set initial dma mask
Date: Thu, 17 Mar 2016 10:20:21 +0100
Message-Id: <1458206432-3039552-2-git-send-email-arnd@arndb.de> (sfid-20160317_102133_610049_CFE78A28)
In-Reply-To: <1458206432-3039552-1-git-send-email-arnd@arndb.de>
References: <1458206432-3039552-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While fixing another bug, I noticed that bcma manually sets up
a dma_mask pointer for its child devices. We have a generic
helper for that now, which should be able to cope better with
any variations that might be needed to deal with cache coherency,
unusual DMA address offsets, iommus, or limited DMA masks, none
of which are currently handled here.

This changes the core to use the of_dma_configure(), like
we do for platform devices that are probed directly from
DT.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---

This patch needs to be tested to ensure we don't introduce
regressions, and should probably go into 4.7 as a cleanup.
---
 drivers/bcma/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 1f635471f318..57d223a7a720 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -209,6 +209,8 @@ static void bcma_of_fill_device(struct platform_device *parent,
 		core->dev.of_node = node;
 
 	core->irq = bcma_of_get_irq(parent, core, 0);
+
+	of_dma_configure(core->dev, node);
 }
 
 unsigned int bcma_core_irq(struct bcma_device *core, int num)
@@ -248,12 +250,12 @@ void bcma_prepare_core(struct bcma_bus *bus, struct bcma_device *core)
 		core->irq = bus->host_pci->irq;
 		break;
 	case BCMA_HOSTTYPE_SOC:
-		core->dev.dma_mask = &core->dev.coherent_dma_mask;
-		if (bus->host_pdev) {
+		if (IS_ENABLED(CONFIG_OF) && bus->host_pdev) {
 			core->dma_dev = &bus->host_pdev->dev;
 			core->dev.parent = &bus->host_pdev->dev;
 			bcma_of_fill_device(bus->host_pdev, core);
 		} else {
+			core->dev.dma_mask = &core->dev.coherent_dma_mask;
 			core->dma_dev = &core->dev;
 		}
 		break;
-- 
2.7.0

