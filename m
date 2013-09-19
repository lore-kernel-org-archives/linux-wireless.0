Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39456 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428Ab3ITMNv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Sep 2013 08:13:51 -0400
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
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 29/51] DMA-API: ata: pata_octeon_cf: convert to use
 dma_coerce_mask_and_coherent()
Message-Id: <E1VMmAk-0007iq-IU@rmk-PC.arm.linux.org.uk> (sfid-20130920_141404_812206_9A7F6CA5)
Date: Thu, 19 Sep 2013 22:54:02 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Convert this code sequence:
	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(64);
	pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
to use dma_coerce_mask_and_coherent() to avoid bypassing the architecture
check on the DMA mask.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/ata/pata_octeon_cf.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/pata_octeon_cf.c b/drivers/ata/pata_octeon_cf.c
index c51bbb9..6231d43 100644
--- a/drivers/ata/pata_octeon_cf.c
+++ b/drivers/ata/pata_octeon_cf.c
@@ -1014,8 +1014,9 @@ static int octeon_cf_probe(struct platform_device *pdev)
 	}
 	cf_port->c0 = ap->ioaddr.ctl_addr;
 
-	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(64);
-	pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
+	rv = dma_coerce_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (rv)
+		return ret;
 
 	ata_port_desc(ap, "cmd %p ctl %p", base, ap->ioaddr.ctl_addr);
 
-- 
1.7.4.4

