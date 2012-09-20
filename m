Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:52134 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab2ITGmL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2012 02:42:11 -0400
Received: by weyx8 with SMTP id x8so1054680wey.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Sep 2012 23:42:10 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: use udelay for short waits
Date: Thu, 20 Sep 2012 08:42:19 +0200
Message-Id: <1348123339-15210-1-git-send-email-zajec5@gmail.com> (sfid-20120920_084215_013540_4D8DA715)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

msleep shouldn't be used for less than 20ms

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/driver_pci.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
index c32ebd5..e78e6a8 100644
--- a/drivers/bcma/driver_pci.c
+++ b/drivers/bcma/driver_pci.c
@@ -51,7 +51,7 @@ static void bcma_pcie_mdio_set_phy(struct bcma_drv_pci *pc, u8 phy)
 		v = pcicore_read32(pc, BCMA_CORE_PCI_MDIO_CONTROL);
 		if (v & BCMA_CORE_PCI_MDIOCTL_ACCESS_DONE)
 			break;
-		msleep(1);
+		udelay(1000);
 	}
 }
 
@@ -92,7 +92,7 @@ static u16 bcma_pcie_mdio_read(struct bcma_drv_pci *pc, u8 device, u8 address)
 			ret = pcicore_read32(pc, BCMA_CORE_PCI_MDIO_DATA);
 			break;
 		}
-		msleep(1);
+		udelay(1000);
 	}
 	pcicore_write32(pc, BCMA_CORE_PCI_MDIO_CONTROL, 0);
 	return ret;
@@ -132,7 +132,7 @@ static void bcma_pcie_mdio_write(struct bcma_drv_pci *pc, u8 device,
 		v = pcicore_read32(pc, BCMA_CORE_PCI_MDIO_CONTROL);
 		if (v & BCMA_CORE_PCI_MDIOCTL_ACCESS_DONE)
 			break;
-		msleep(1);
+		udelay(1000);
 	}
 	pcicore_write32(pc, BCMA_CORE_PCI_MDIO_CONTROL, 0);
 }
-- 
1.7.7

