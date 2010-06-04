Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757036Ab0FDCi3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jun 2010 22:38:29 -0400
Message-Id: <201006040237.o542bOww001409@imap1.linux-foundation.org>
Subject: [patch 1/5] ssb: add dma_dev to ssb_device structure
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org,
	fujita.tomonori@lab.ntt.co.jp, Larry.Finger@lwfinger.net,
	davem@davemloft.net, mb@bu3sch.de, stefano.brivio@polimi.it,
	zambrano@broadcom.com
From: akpm@linux-foundation.org
Date: Thu, 03 Jun 2010 19:37:27 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Add dma_dev, a pointer to struct device, to struct ssb_device.  We pass it
to the generic DMA API with SSB_BUSTYPE_PCI and SSB_BUSTYPE_SSB. 
ssb_devices_register() sets up it properly.

This is preparation for replacing the ssb bus specific DMA API (ssb_dma_*)
with the generic DMA API.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Michael Buesch <mb@bu3sch.de>
Cc: Gary Zambrano <zambrano@broadcom.com>
Cc: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W. Linville <linville@tuxdriver.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ssb/main.c      |    2 ++
 include/linux/ssb/ssb.h |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/ssb/main.c~ssb-add-dma_dev-to-ssb_device-structure drivers/ssb/main.c
--- a/drivers/ssb/main.c~ssb-add-dma_dev-to-ssb_device-structure
+++ a/drivers/ssb/main.c
@@ -486,6 +486,7 @@ static int ssb_devices_register(struct s
 #ifdef CONFIG_SSB_PCIHOST
 			sdev->irq = bus->host_pci->irq;
 			dev->parent = &bus->host_pci->dev;
+			sdev->dma_dev = dev->parent;
 #endif
 			break;
 		case SSB_BUSTYPE_PCMCIA:
@@ -501,6 +502,7 @@ static int ssb_devices_register(struct s
 			break;
 		case SSB_BUSTYPE_SSB:
 			dev->dma_mask = &dev->coherent_dma_mask;
+			sdev->dma_dev = dev;
 			break;
 		}
 
diff -puN include/linux/ssb/ssb.h~ssb-add-dma_dev-to-ssb_device-structure include/linux/ssb/ssb.h
--- a/include/linux/ssb/ssb.h~ssb-add-dma_dev-to-ssb_device-structure
+++ a/include/linux/ssb/ssb.h
@@ -167,7 +167,7 @@ struct ssb_device {
 	 * is an optimization. */
 	const struct ssb_bus_ops *ops;
 
-	struct device *dev;
+	struct device *dev, *dma_dev;
 
 	struct ssb_bus *bus;
 	struct ssb_device_id id;
_
