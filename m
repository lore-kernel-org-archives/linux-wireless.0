Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39429 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575Ab3ITMKO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Sep 2013 08:10:14 -0400
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
Cc: Vinod Koul <vinod.koul@intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 27/51] DMA-API: provide a helper to setup DMA masks
Message-Id: <E1VMm8o-0007iV-Ac@rmk-PC.arm.linux.org.uk> (sfid-20130920_141027_712726_17C1426E)
Date: Thu, 19 Sep 2013 22:52:02 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Many drivers contain code such as:

	dev->dma_mask = &dev->coherent_dma_mask;
	dev->coherent_dma_mask = MASK;

Let's move this pattern out of drivers and have the DMA API provide a
helper for it.  This helper uses dma_set_mask_and_coherent() to allow
platform issues to be properly dealt with via dma_set_mask()/
dma_is_supported().

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 include/linux/dma-mapping.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index ec951f9..27d1421 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -111,6 +111,16 @@ static inline int dma_set_mask_and_coherent(struct device *dev, u64 mask)
 	return rc;
 }
 
+/*
+ * Similar to the above, except it deals with the case where the device
+ * does not have dev->dma_mask appropriately setup.
+ */
+static inline int dma_coerce_mask_and_coherent(struct device *dev, u64 mask)
+{
+	dev->dma_mask = &dev->coherent_dma_mask;
+	return dma_set_mask_and_coherent(dev, mask);
+}
+
 extern u64 dma_get_required_mask(struct device *dev);
 
 static inline unsigned int dma_get_max_seg_size(struct device *dev)
-- 
1.7.4.4

