Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39400 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419Ab3ITMG0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Sep 2013 08:06:26 -0400
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
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH 25/51] DMA-API: video: clcd: add dma_set_mask_and_coherent()
 call
Message-Id: <E1VMm6s-0007iD-2R@rmk-PC.arm.linux.org.uk> (sfid-20130920_140651_174975_FFC164B6)
Date: Thu, 19 Sep 2013 22:50:02 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The DMA API requires drivers to call the appropriate dma_set_mask()
functions before doing any DMA mapping.  Add this required call to
the AMBA PL08x driver.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/video/amba-clcd.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/video/amba-clcd.c b/drivers/video/amba-clcd.c
index 0a2cce7..afe4702 100644
--- a/drivers/video/amba-clcd.c
+++ b/drivers/video/amba-clcd.c
@@ -10,6 +10,7 @@
  *
  *  ARM PrimeCell PL110 Color LCD Controller
  */
+#include <linux/dma-mapping.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
@@ -551,6 +552,10 @@ static int clcdfb_probe(struct amba_device *dev, const struct amba_id *id)
 	if (!board)
 		return -EINVAL;
 
+	ret = dma_set_mask_and_coherent(&dev->dev, DMA_BIT_MASK(32));
+	if (ret)
+		goto out;
+
 	ret = amba_request_regions(dev, NULL);
 	if (ret) {
 		printk(KERN_ERR "CLCD: unable to reserve regs region\n");
-- 
1.7.4.4

