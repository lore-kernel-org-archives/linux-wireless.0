Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:49623 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754539AbaIHUxw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2014 16:53:52 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linux-wireless@vger.kernel.org
Cc: zajec5@gmail.com, Hauke Mehrtens <hauke@hauke-m.de>,
	linux-usb@vger.kernel.org
Subject: [PATCH 1/2] bcma: store more alternative addresses
Date: Mon,  8 Sep 2014 22:53:35 +0200
Message-Id: <1410209616-8518-1-git-send-email-hauke@hauke-m.de> (sfid-20140908_225356_965621_FE11B2BA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Each core could have more than one alternative address. There are cores
with 8 alternative addresses for different functions. The PHY control
in the Chip common B core is done through the 2. alternative address
and not the first one.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
CC: linux-usb@vger.kernel.org
---
 drivers/bcma/scan.c         | 9 +++++----
 drivers/usb/host/bcma-hcd.c | 2 +-
 include/linux/bcma/bcma.h   | 2 +-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index e9bd772..3cd5a5b 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -276,7 +276,7 @@ static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
 			      struct bcma_device *core)
 {
 	u32 tmp;
-	u8 i, j;
+	u8 i, j, k;
 	s32 cia, cib;
 	u8 ports[2], wrappers[2];
 
@@ -367,6 +367,7 @@ static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
 	core->addr = tmp;
 
 	/* get & parse slave ports */
+	k = 0;
 	for (i = 0; i < ports[1]; i++) {
 		for (j = 0; ; j++) {
 			tmp = bcma_erom_get_addr_desc(bus, eromptr,
@@ -376,9 +377,9 @@ static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
 				/* pr_debug("erom: slave port %d "
 				 * "has %d descriptors\n", i, j); */
 				break;
-			} else {
-				if (i == 0 && j == 0)
-					core->addr1 = tmp;
+			} else if (k < ARRAY_SIZE(core->addr_s)) {
+				core->addr_s[k] = tmp;
+				k++;
 			}
 		}
 	}
diff --git a/drivers/usb/host/bcma-hcd.c b/drivers/usb/host/bcma-hcd.c
index 205f4a3..cd6d0af 100644
--- a/drivers/usb/host/bcma-hcd.c
+++ b/drivers/usb/host/bcma-hcd.c
@@ -237,7 +237,7 @@ static int bcma_hcd_probe(struct bcma_device *dev)
 	bcma_hcd_init_chip(dev);
 
 	/* In AI chips EHCI is addrspace 0, OHCI is 1 */
-	ohci_addr = dev->addr1;
+	ohci_addr = dev->addr_s[0];
 	if ((chipinfo->id == 0x5357 || chipinfo->id == 0x4749)
 	    && chipinfo->rev == 0)
 		ohci_addr = 0x18009000;
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 0272e49..ad44711 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -267,7 +267,7 @@ struct bcma_device {
 	u8 core_unit;
 
 	u32 addr;
-	u32 addr1;
+	u32 addr_s[8];
 	u32 wrap;
 
 	void __iomem *io_addr;
-- 
1.9.1

