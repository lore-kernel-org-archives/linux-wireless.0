Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39351 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366Ab3ITLs3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Sep 2013 07:48:29 -0400
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
Cc: Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 17/51] DMA-API: block: nvme-core: replace
 dma_set_mask()+dma_set_coherent_mask() with new
 helper
Message-Id: <E1VMlz6-0007h9-WF@rmk-PC.arm.linux.org.uk> (sfid-20130920_134841_135706_DFEEE670)
Date: Thu, 19 Sep 2013 22:42:00 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace the following sequence:

	dma_set_mask(dev, mask);
	dma_set_coherent_mask(dev, mask);

with a call to the new helper dma_set_mask_and_coherent().

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/block/nvme-core.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index da52092..26d03fa 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -1949,12 +1949,9 @@ static int nvme_dev_map(struct nvme_dev *dev)
 	if (pci_request_selected_regions(pdev, bars, "nvme"))
 		goto disable_pci;
 
-	if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(64)))
-		dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64));
-	else if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(32)))
-		dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
-	else
-		goto disable_pci;
+	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)) &&
+	    dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32)))
+		goto disable;
 
 	pci_set_drvdata(pdev, dev);
 	dev->bar = ioremap(pci_resource_start(pdev, 0), 8192);
@@ -2168,6 +2165,7 @@ static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	INIT_LIST_HEAD(&dev->namespaces);
 	dev->pci_dev = pdev;
+
 	result = nvme_set_instance(dev);
 	if (result)
 		goto free;
-- 
1.7.4.4

