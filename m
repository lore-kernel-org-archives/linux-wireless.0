Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39369 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444Ab3ITLxv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Sep 2013 07:53:51 -0400
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
Cc: Eilon Greenstein <eilong@broadcom.com>
Subject: [PATCH 10/51] DMA-API: net: broadcom/bnx2x: replace
 dma_set_mask()+dma_set_coherent_mask() with new
 helper
Message-Id: <E1VMlsJ-0007g8-UO@rmk-PC.arm.linux.org.uk> (sfid-20130920_135407_991445_CE64A5B8)
Date: Thu, 19 Sep 2013 22:34:59 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace the following sequence:

	dma_set_mask(dev, mask);
	dma_set_coherent_mask(dev, mask);

with a call to the new helper dma_set_mask_and_coherent().

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 2f8dbbb..e6c3e66 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -12072,13 +12072,9 @@ static int bnx2x_set_coherency_mask(struct bnx2x *bp)
 {
 	struct device *dev = &bp->pdev->dev;
 
-	if (dma_set_mask(dev, DMA_BIT_MASK(64)) == 0) {
+	if (dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64)) == 0) {
 		bp->flags |= USING_DAC_FLAG;
-		if (dma_set_coherent_mask(dev, DMA_BIT_MASK(64)) != 0) {
-			dev_err(dev, "dma_set_coherent_mask failed, aborting\n");
-			return -EIO;
-		}
-	} else if (dma_set_mask(dev, DMA_BIT_MASK(32)) != 0) {
+	} else if (dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32)) != 0) {
 		dev_err(dev, "System does not support DMA, aborting\n");
 		return -EIO;
 	}
-- 
1.7.4.4

