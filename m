Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47935 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313Ab3ISWz5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Sep 2013 18:55:57 -0400
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
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Bruce Allan <bruce.w.allan@intel.com>,
	Carolyn Wyborny <carolyn.wyborny@intel.com>,
	Don Skidmore <donald.c.skidmore@intel.com>,
	Greg Rose <gregory.v.rose@intel.com>,
	Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
	Alex Duyck <alexander.h.duyck@intel.com>,
	John Ronciak <john.ronciak@intel.com>,
	Tushar Dave <tushar.n.dave@intel.com>
Subject: [PATCH 08/51] DMA-API: net: intel/ixgbevf: fix 32-bit DMA mask
 handling
Message-Id: <E1VMlqN-0007fw-MQ@rmk-PC.arm.linux.org.uk> (sfid-20130920_005602_493983_35699367)
Date: Thu, 19 Sep 2013 22:32:59 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The fallback to 32-bit DMA mask is rather odd:
	if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(64)) &&
	    !dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64))) {
		pci_using_dac = 1;
	} else {
		err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
		if (err) {
			err = dma_set_coherent_mask(&pdev->dev,
						    DMA_BIT_MASK(32));
			if (err) {
				dev_err(&pdev->dev, "No usable DMA "
					"configuration, aborting\n");
				goto err_dma;
			}
		}
		pci_using_dac = 0;
	}
This means we only set the coherent DMA mask in the fallback path if
the DMA mask set failed, which is silly.  This fixes it to set the
coherent DMA mask only if dma_set_mask() succeeded, and to error out
if either fails.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 59a62bb..e34c2da 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -3326,19 +3326,14 @@ static int ixgbevf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		return err;
 
-	if (!dma_set_mask(&pdev->dev, DMA_BIT_MASK(64)) &&
-	    !dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64))) {
+	if (!dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64))) {
 		pci_using_dac = 1;
 	} else {
-		err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
+		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 		if (err) {
-			err = dma_set_coherent_mask(&pdev->dev,
-						    DMA_BIT_MASK(32));
-			if (err) {
-				dev_err(&pdev->dev, "No usable DMA "
-					"configuration, aborting\n");
-				goto err_dma;
-			}
+			dev_err(&pdev->dev, "No usable DMA "
+				"configuration, aborting\n");
+			goto err_dma;
 		}
 		pci_using_dac = 0;
 	}
-- 
1.7.4.4

