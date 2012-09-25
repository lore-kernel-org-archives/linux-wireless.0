Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59471 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab2IYIIH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2012 04:08:07 -0400
Received: by bkcjk13 with SMTP id jk13so1369228bkc.19
        for <linux-wireless@vger.kernel.org>; Tue, 25 Sep 2012 01:08:06 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH V2] bcma: change delays to follow timers-howto guide
Date: Tue, 25 Sep 2012 10:17:22 +0200
Message-Id: <1348561042-13637-1-git-send-email-zajec5@gmail.com> (sfid-20120925_100814_723809_69453166)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/core.c                  |    2 +-
 drivers/bcma/driver_chipcommon_pmu.c |    5 ++++-
 drivers/bcma/driver_pci.c            |    6 +++---
 drivers/bcma/driver_pci_host.c       |    8 ++++----
 4 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/bcma/core.c b/drivers/bcma/core.c
index 63c8b47..03bbe10 100644
--- a/drivers/bcma/core.c
+++ b/drivers/bcma/core.c
@@ -65,7 +65,7 @@ void bcma_core_set_clockmode(struct bcma_device *core,
 	switch (clkmode) {
 	case BCMA_CLKMODE_FAST:
 		bcma_set32(core, BCMA_CLKCTLST, BCMA_CLKCTLST_FORCEHT);
-		udelay(64);
+		usleep_range(64, 300);
 		for (i = 0; i < 1500; i++) {
 			if (bcma_read32(core, BCMA_CLKCTLST) &
 			    BCMA_CLKCTLST_HAVEHT) {
diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
index 8b8f2f3..201faf1 100644
--- a/drivers/bcma/driver_chipcommon_pmu.c
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -76,7 +76,10 @@ static void bcma_pmu_resources_init(struct bcma_drv_cc *cc)
 	if (max_msk)
 		bcma_cc_write32(cc, BCMA_CC_PMU_MAXRES_MSK, max_msk);
 
-	/* Add some delay; allow resources to come up and settle. */
+	/*
+	 * Add some delay; allow resources to come up and settle.
+	 * Delay is required for SoC (early init).
+	 */
 	mdelay(2);
 }
 
diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
index c32ebd5..c39ee6d 100644
--- a/drivers/bcma/driver_pci.c
+++ b/drivers/bcma/driver_pci.c
@@ -51,7 +51,7 @@ static void bcma_pcie_mdio_set_phy(struct bcma_drv_pci *pc, u8 phy)
 		v = pcicore_read32(pc, BCMA_CORE_PCI_MDIO_CONTROL);
 		if (v & BCMA_CORE_PCI_MDIOCTL_ACCESS_DONE)
 			break;
-		msleep(1);
+		usleep_range(1000, 2000);
 	}
 }
 
@@ -92,7 +92,7 @@ static u16 bcma_pcie_mdio_read(struct bcma_drv_pci *pc, u8 device, u8 address)
 			ret = pcicore_read32(pc, BCMA_CORE_PCI_MDIO_DATA);
 			break;
 		}
-		msleep(1);
+		usleep_range(1000, 2000);
 	}
 	pcicore_write32(pc, BCMA_CORE_PCI_MDIO_CONTROL, 0);
 	return ret;
@@ -132,7 +132,7 @@ static void bcma_pcie_mdio_write(struct bcma_drv_pci *pc, u8 device,
 		v = pcicore_read32(pc, BCMA_CORE_PCI_MDIO_CONTROL);
 		if (v & BCMA_CORE_PCI_MDIOCTL_ACCESS_DONE)
 			break;
-		msleep(1);
+		usleep_range(1000, 2000);
 	}
 	pcicore_write32(pc, BCMA_CORE_PCI_MDIO_CONTROL, 0);
 }
diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
index cbae2c2..9baf886 100644
--- a/drivers/bcma/driver_pci_host.c
+++ b/drivers/bcma/driver_pci_host.c
@@ -425,9 +425,9 @@ void __devinit bcma_core_pci_hostmode_init(struct bcma_drv_pci *pc)
 	pc_host->io_resource.flags = IORESOURCE_IO | IORESOURCE_PCI_FIXED;
 
 	/* Reset RC */
-	udelay(3000);
+	usleep_range(3000, 5000);
 	pcicore_write32(pc, BCMA_CORE_PCI_CTL, BCMA_CORE_PCI_CTL_RST_OE);
-	udelay(1000);
+	usleep_range(1000, 2000);
 	pcicore_write32(pc, BCMA_CORE_PCI_CTL, BCMA_CORE_PCI_CTL_RST |
 			BCMA_CORE_PCI_CTL_RST_OE);
 
@@ -481,7 +481,7 @@ void __devinit bcma_core_pci_hostmode_init(struct bcma_drv_pci *pc)
 	 * before issuing configuration requests to PCI Express
 	 * devices.
 	 */
-	udelay(100000);
+	msleep(100);
 
 	bcma_core_pci_enable_crs(pc);
 
@@ -501,7 +501,7 @@ void __devinit bcma_core_pci_hostmode_init(struct bcma_drv_pci *pc)
 	set_io_port_base(pc_host->pci_controller.io_map_base);
 	/* Give some time to the PCI controller to configure itself with the new
 	 * values. Not waiting at this point causes crashes of the machine. */
-	mdelay(10);
+	usleep_range(10000, 15000);
 	register_pci_controller(&pc_host->pci_controller);
 	return;
 }
-- 
1.7.7

