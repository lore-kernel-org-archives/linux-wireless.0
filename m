Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu0-omc2-s27.blu0.hotmail.com ([65.55.111.102]:56352 "EHLO
	blu0-omc2-s27.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753613Ab3AKGYT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2013 01:24:19 -0500
Message-ID: <BLU0-SMTP192A924AF0576BE01AD99ACAC290@phx.gbl> (sfid-20130111_072421_835952_C6B7BF0A)
From: Nathan Hintz <nlhintz@hotmail.com>
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, hauke@hauke-m.de,
	Nathan Hintz <nlhintz@hotmail.com>
Subject: [PATCH] bcma: update pci configuration for bcm4706/bcm4716
Date: Thu, 10 Jan 2013 22:24:03 -0800
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update the PCI configuration for BCM4706 and BCM4716 per the 2011
Broadcom SDK.

Signed-off-by: Nathan Hintz <nlhintz@hotmail.com>
---
 drivers/bcma/driver_pci_host.c       |   13 ++++++++++++-
 include/linux/bcma/bcma_driver_pci.h |    2 ++
 2 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
index af0c9fa..88f8687 100644
--- a/drivers/bcma/driver_pci_host.c
+++ b/drivers/bcma/driver_pci_host.c
@@ -426,7 +426,7 @@ void bcma_core_pci_hostmode_init(struct bcma_drv_pci *pc)
 	/* Reset RC */
 	usleep_range(3000, 5000);
 	pcicore_write32(pc, BCMA_CORE_PCI_CTL, BCMA_CORE_PCI_CTL_RST_OE);
-	usleep_range(1000, 2000);
+	msleep(50);
 	pcicore_write32(pc, BCMA_CORE_PCI_CTL, BCMA_CORE_PCI_CTL_RST |
 			BCMA_CORE_PCI_CTL_RST_OE);
 
@@ -488,6 +488,17 @@ void bcma_core_pci_hostmode_init(struct bcma_drv_pci *pc)
 
 	bcma_core_pci_enable_crs(pc);
 
+	if (bus->chipinfo.id == BCMA_CHIP_ID_BCM4706 ||
+	    bus->chipinfo.id == BCMA_CHIP_ID_BCM4716) {
+		u16 val16;
+		bcma_extpci_read_config(pc, 0, 0, BCMA_CORE_PCI_CFG_DEVCTRL,
+					&val16, sizeof(val16));
+		val16 |= (2 << 5);	/* Max payload size of 512 */
+		val16 |= (2 << 12);	/* MRRS 512 */
+		bcma_extpci_write_config(pc, 0, 0, BCMA_CORE_PCI_CFG_DEVCTRL,
+					 &val16, sizeof(val16));
+	}
+
 	/* Enable PCI bridge BAR0 memory & master access */
 	tmp = PCI_COMMAND_MASTER | PCI_COMMAND_MEMORY;
 	bcma_extpci_write_config(pc, 0, 0, PCI_COMMAND, &tmp, sizeof(tmp));
diff --git a/include/linux/bcma/bcma_driver_pci.h b/include/linux/bcma/bcma_driver_pci.h
index c48d98d..424760f 100644
--- a/include/linux/bcma/bcma_driver_pci.h
+++ b/include/linux/bcma/bcma_driver_pci.h
@@ -179,6 +179,8 @@ struct pci_dev;
 #define BCMA_CORE_PCI_CFG_FUN_MASK		7	/* Function mask */
 #define BCMA_CORE_PCI_CFG_OFF_MASK		0xfff	/* Register mask */
 
+#define BCMA_CORE_PCI_CFG_DEVCTRL		0xd8
+
 /* PCIE Root Capability Register bits (Host mode only) */
 #define BCMA_CORE_PCI_RC_CRS_VISIBILITY		0x0001
 
-- 
1.7.7.6

