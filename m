Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:59146 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757545Ab2I2SkZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Sep 2012 14:40:25 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	brcm80211-dev-list@broadcom.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] bcma: add an extra pcie core struct
Date: Sat, 29 Sep 2012 20:40:18 +0200
Message-Id: <1348944018-23414-1-git-send-email-hauke@hauke-m.de> (sfid-20120929_204028_247415_76CE3A6B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The BCM4706 has two PCIe host controller on the bcma bus. For PCIe
client mode it is assumed that there is only one PCIe controller so the
PCIe driver, like b43 and brcmsmac are accessing the first PCIe
controller when they want to issue a operation on the host controller.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_pci_host.c                    |    4 ++++
 drivers/bcma/main.c                               |   25 ++++++++++++++++++---
 drivers/net/wireless/b43/main.c                   |    2 +-
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |    4 ++--
 drivers/net/wireless/brcm80211/brcmsmac/main.c    |    2 +-
 include/linux/bcma/bcma.h                         |    2 +-
 6 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
index 9baf886..63172c9 100644
--- a/drivers/bcma/driver_pci_host.c
+++ b/drivers/bcma/driver_pci_host.c
@@ -452,6 +452,8 @@ void __devinit bcma_core_pci_hostmode_init(struct bcma_drv_pci *pc)
 			pc_host->mem_resource.start = BCMA_SOC_PCI_MEM;
 			pc_host->mem_resource.end = BCMA_SOC_PCI_MEM +
 						    BCMA_SOC_PCI_MEM_SZ - 1;
+			pc_host->io_resource.start = 0x100;
+			pc_host->io_resource.end = 0x47F;
 			pci_membase_1G = BCMA_SOC_PCIE_DMA_H32;
 			pcicore_write32(pc, BCMA_CORE_PCI_SBTOPCI0,
 					tmp | BCMA_SOC_PCI_MEM);
@@ -459,6 +461,8 @@ void __devinit bcma_core_pci_hostmode_init(struct bcma_drv_pci *pc)
 			pc_host->mem_resource.start = BCMA_SOC_PCI1_MEM;
 			pc_host->mem_resource.end = BCMA_SOC_PCI1_MEM +
 						    BCMA_SOC_PCI_MEM_SZ - 1;
+			pc_host->io_resource.start = 0x480;
+			pc_host->io_resource.end = 0x7FF;
 			pci_membase_1G = BCMA_SOC_PCIE1_DMA_H32;
 			pc_host->host_cfg_addr = BCMA_SOC_PCI1_CFG;
 			pcicore_write32(pc, BCMA_CORE_PCI_SBTOPCI0,
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 432aeee..c9aa581 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -81,6 +81,18 @@ struct bcma_device *bcma_find_core(struct bcma_bus *bus, u16 coreid)
 }
 EXPORT_SYMBOL_GPL(bcma_find_core);
 
+static struct bcma_device *bcma_find_core_unit(struct bcma_bus *bus, u16 coreid,
+					       u8 unit)
+{
+	struct bcma_device *core;
+
+	list_for_each_entry(core, &bus->cores, list) {
+		if (core->id.id == coreid && core->core_unit == unit)
+			return core;
+	}
+	return NULL;
+}
+
 static void bcma_release_core_dev(struct device *dev)
 {
 	struct bcma_device *core = container_of(dev, struct bcma_device, dev);
@@ -197,10 +209,17 @@ int __devinit bcma_bus_register(struct bcma_bus *bus)
 	}
 
 	/* Init PCIE core */
-	core = bcma_find_core(bus, BCMA_CORE_PCIE);
+	core = bcma_find_core_unit(bus, BCMA_CORE_PCIE, 0);
+	if (core) {
+		bus->drv_pci[0].core = core;
+		bcma_core_pci_init(&bus->drv_pci[0]);
+	}
+
+	/* Init PCIE core */
+	core = bcma_find_core_unit(bus, BCMA_CORE_PCIE, 1);
 	if (core) {
-		bus->drv_pci.core = core;
-		bcma_core_pci_init(&bus->drv_pci);
+		bus->drv_pci[1].core = core;
+		bcma_core_pci_init(&bus->drv_pci[1]);
 	}
 
 	/* Init GBIT MAC COMMON core */
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 73730e9..7358ea2 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4652,7 +4652,7 @@ static int b43_wireless_core_init(struct b43_wldev *dev)
 	switch (dev->dev->bus_type) {
 #ifdef CONFIG_B43_BCMA
 	case B43_BUS_BCMA:
-		bcma_core_pci_irq_ctl(&dev->dev->bdev->bus->drv_pci,
+		bcma_core_pci_irq_ctl(&dev->dev->bdev->bus->drv_pci[0],
 				      dev->dev->bdev, true);
 		break;
 #endif
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index b89f127..de96290 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -692,7 +692,7 @@ void ai_pci_up(struct si_pub *sih)
 	sii = container_of(sih, struct si_info, pub);
 
 	if (sii->icbus->hosttype == BCMA_HOSTTYPE_PCI)
-		bcma_core_pci_extend_L1timer(&sii->icbus->drv_pci, true);
+		bcma_core_pci_extend_L1timer(&sii->icbus->drv_pci[0], true);
 }
 
 /* Unconfigure and/or apply various WARs when going down */
@@ -703,7 +703,7 @@ void ai_pci_down(struct si_pub *sih)
 	sii = container_of(sih, struct si_info, pub);
 
 	if (sii->icbus->hosttype == BCMA_HOSTTYPE_PCI)
-		bcma_core_pci_extend_L1timer(&sii->icbus->drv_pci, false);
+		bcma_core_pci_extend_L1timer(&sii->icbus->drv_pci[0], false);
 }
 
 /* Enable BT-COEX & Ex-PA for 4313 */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 75086b3..565c15a 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -5077,7 +5077,7 @@ static int brcms_b_up_prep(struct brcms_hardware *wlc_hw)
 	 * Configure pci/pcmcia here instead of in brcms_c_attach()
 	 * to allow mfg hotswap:  down, hotswap (chip power cycle), up.
 	 */
-	bcma_core_pci_irq_ctl(&wlc_hw->d11core->bus->drv_pci, wlc_hw->d11core,
+	bcma_core_pci_irq_ctl(&wlc_hw->d11core->bus->drv_pci[0], wlc_hw->d11core,
 			      true);
 
 	/*
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 1954a4e..b264c66 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -251,7 +251,7 @@ struct bcma_bus {
 	u8 num;
 
 	struct bcma_drv_cc drv_cc;
-	struct bcma_drv_pci drv_pci;
+	struct bcma_drv_pci drv_pci[2];
 	struct bcma_drv_mips drv_mips;
 	struct bcma_drv_gmac_cmn drv_gmac_cmn;
 
-- 
1.7.9.5

