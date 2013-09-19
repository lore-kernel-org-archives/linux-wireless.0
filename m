Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39164 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab3ITK7c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Sep 2013 06:59:32 -0400
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
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: [PATCH 49/51] ARM: 7796/1: scsi: Use dma_max_pfn(dev) helper for
 bounce_limit calculations
Message-Id: <E1VMnrK-0002Dw-Vk@rmk-PC.arm.linux.org.uk> (sfid-20130920_125935_931885_31A59A1E)
Date: Fri, 20 Sep 2013 00:42:06 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Santosh Shilimkar <santosh.shilimkar@ti.com>

DMA bounce limit is the maximum direct DMA'able memory beyond which
bounce buffers has to be used to perform dma operations. SCSI driver
relies on dma_mask but its calculation is based on max_*pfn which
don't have uniform meaning across architectures. So make use of
dma_max_pfn() which is expected to return the DMAable maximum pfn
value across architectures.

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/scsi/scsi_lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d1549b7..7bd7f0d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1684,7 +1684,7 @@ u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
 
 	host_dev = scsi_get_device(shost);
 	if (host_dev && host_dev->dma_mask)
-		bounce_limit = *host_dev->dma_mask;
+		bounce_limit = dma_max_pfn(host_dev) << PAGE_SHIFT;
 
 	return bounce_limit;
 }
-- 
1.7.4.4

