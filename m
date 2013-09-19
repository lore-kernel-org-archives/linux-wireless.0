Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39658 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab3ITPGX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Sep 2013 11:06:23 -0400
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
Subject: [PATCH 35/51] DMA-API: parport: parport_pc.c: use
 dma_coerce_mask_and_coherent()
Message-Id: <E1VMmGZ-0007jU-99@rmk-PC.arm.linux.org.uk> (sfid-20130920_170633_322435_64F4B5AE)
Date: Thu, 19 Sep 2013 23:00:03 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The code sequence:
	dev->coherent_dma_mask = DMA_BIT_MASK(24);
	dev->dma_mask = &dev->coherent_dma_mask;
bypasses the architectures check on the DMA mask.  It can be replaced
with dma_coerce_mask_and_coherent(), avoiding the direct initialization
of this mask.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/parport/parport_pc.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index 903e128..9637615 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -2004,6 +2004,7 @@ struct parport *parport_pc_probe_port(unsigned long int base,
 	struct resource	*ECR_res = NULL;
 	struct resource	*EPP_res = NULL;
 	struct platform_device *pdev = NULL;
+	int ret;
 
 	if (!dev) {
 		/* We need a physical device to attach to, but none was
@@ -2014,8 +2015,11 @@ struct parport *parport_pc_probe_port(unsigned long int base,
 			return NULL;
 		dev = &pdev->dev;
 
-		dev->coherent_dma_mask = DMA_BIT_MASK(24);
-		dev->dma_mask = &dev->coherent_dma_mask;
+		ret = dma_coerce_mask_and_coherent(dev, DMA_BIT_MASK(24));
+		if (ret) {
+			dev_err(dev, "Unable to set coherent dma mask: disabling DMA\n");
+			dma = PARPORT_DMA_NONE;
+		}
 	}
 
 	ops = kmalloc(sizeof(struct parport_operations), GFP_KERNEL);
-- 
1.7.4.4

