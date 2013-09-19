Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39246 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab3ITLMC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Sep 2013 07:12:02 -0400
In-Reply-To: <20130919212235.GD12758@n2100.arm.linux.org.uk>
References: <20130919212235.GD12758@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: alsa-devel@alsa-project.org, b43-dev@lists.infradead.org,
	devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
	dri-devel@lists.freedesktop.org, e1000-devel@lists.sourceforge.net,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-fbdev@vger.kernel.org,
	linux-ide@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-omap@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-tegra@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
	uclinux-dist-devel@blackfin.uclinux.org
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH 43/51] DMA-API: dma: edma.c: no need to explicitly initialize
 DMA masks
Message-Id: <E1VMnRj-0007sg-1Z@rmk-PC.arm.linux.org.uk> (sfid-20130920_131213_439366_939D7707)
Date: Fri, 20 Sep 2013 00:15:39 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

register_platform_device_full() can setup the DMA mask provided the
appropriate member is set in struct platform_device_info.  So lets
make that be the case.  This avoids a direct reference to the DMA
masks by this driver.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/dma/edma.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index ff50ff4..7f9fe30 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -702,11 +702,13 @@ static struct platform_device *pdev0, *pdev1;
 static const struct platform_device_info edma_dev_info0 = {
 	.name = "edma-dma-engine",
 	.id = 0,
+	.dma_mask = DMA_BIT_MASK(32),
 };
 
 static const struct platform_device_info edma_dev_info1 = {
 	.name = "edma-dma-engine",
 	.id = 1,
+	.dma_mask = DMA_BIT_MASK(32),
 };
 
 static int edma_init(void)
@@ -720,8 +722,6 @@ static int edma_init(void)
 			ret = PTR_ERR(pdev0);
 			goto out;
 		}
-		pdev0->dev.dma_mask = &pdev0->dev.coherent_dma_mask;
-		pdev0->dev.coherent_dma_mask = DMA_BIT_MASK(32);
 	}
 
 	if (EDMA_CTLRS == 2) {
@@ -731,8 +731,6 @@ static int edma_init(void)
 			platform_device_unregister(pdev0);
 			ret = PTR_ERR(pdev1);
 		}
-		pdev1->dev.dma_mask = &pdev1->dev.coherent_dma_mask;
-		pdev1->dev.coherent_dma_mask = DMA_BIT_MASK(32);
 	}
 
 out:
-- 
1.7.4.4

