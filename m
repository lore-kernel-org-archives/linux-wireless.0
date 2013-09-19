Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39516 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518Ab3ITMry (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Sep 2013 08:47:54 -0400
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
Subject: [PATCH 33/51] DMA-API: net: nxp/lpc_eth: use
 dma_coerce_mask_and_coherent()
Message-Id: <E1VMmEd-0007jF-19@rmk-PC.arm.linux.org.uk> (sfid-20130920_144806_706699_B9D9CED4)
Date: Thu, 19 Sep 2013 22:58:03 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The code sequence:
	pldat->pdev->dev.coherent_dma_mask = 0xFFFFFFFF;
	pldat->pdev->dev.dma_mask = &pldat->pdev->dev.coherent_dma_mask;
bypasses the architectures check on the DMA mask.  It can be replaced
with dma_coerce_mask_and_coherent(), avoiding the direct initialization
of this mask.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/net/ethernet/nxp/lpc_eth.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index a061b93..ba3ca18 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -1399,8 +1399,10 @@ static int lpc_eth_drv_probe(struct platform_device *pdev)
 	}
 
 	if (pldat->dma_buff_base_v == 0) {
-		pldat->pdev->dev.coherent_dma_mask = 0xFFFFFFFF;
-		pldat->pdev->dev.dma_mask = &pldat->pdev->dev.coherent_dma_mask;
+		ret = dma_coerce_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+		if (ret)
+			goto err_out_free_irq;
+
 		pldat->dma_buff_size = PAGE_ALIGN(pldat->dma_buff_size);
 
 		/* Allocate a chunk of memory for the DMA ethernet buffers
-- 
1.7.4.4

