Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44585 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798Ab2D2AFV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2012 20:05:21 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org,
	linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
	arend@broadcom.com, m@bues.ch, ralf@linux-mips.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/8] bcma: add boardinfo struct
Date: Sun, 29 Apr 2012 02:04:08 +0200
Message-Id: <1335657853-23925-4-git-send-email-hauke@hauke-m.de> (sfid-20120429_020525_755890_D0EEDB52)
In-Reply-To: <1335657853-23925-1-git-send-email-hauke@hauke-m.de>
References: <1335657853-23925-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This struct contains information about the board, the chip is running
on. The struct is filled for PCIe devices and SoCs. This information is
used by b43 and will be used by brcmsmac soon.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 arch/mips/bcm47xx/setup.c                    |    2 ++
 arch/mips/bcm47xx/sprom.c                    |   12 ++++++++++++
 arch/mips/include/asm/mach-bcm47xx/bcm47xx.h |    4 ++++
 drivers/bcma/host_pci.c                      |    3 +++
 drivers/net/wireless/b43/bus.c               |    4 +---
 include/linux/bcma/bcma.h                    |    7 +++++++
 6 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/arch/mips/bcm47xx/setup.c b/arch/mips/bcm47xx/setup.c
index 53cdb72..9ef46d2 100644
--- a/arch/mips/bcm47xx/setup.c
+++ b/arch/mips/bcm47xx/setup.c
@@ -190,6 +190,8 @@ static void __init bcm47xx_register_bcma(void)
 	err = bcma_host_soc_register(&bcm47xx_bus.bcma);
 	if (err)
 		panic("Failed to initialize BCMA bus (err %d)", err);
+
+	bcm47xx_fill_bcma_boardinfo(&bcm47xx_bus.bcma.bus.boardinfo, NULL);
 }
 #endif
 
diff --git a/arch/mips/bcm47xx/sprom.c b/arch/mips/bcm47xx/sprom.c
index 279991a..a29d207 100644
--- a/arch/mips/bcm47xx/sprom.c
+++ b/arch/mips/bcm47xx/sprom.c
@@ -630,3 +630,15 @@ void bcm47xx_fill_ssb_boardinfo(struct ssb_boardinfo *boardinfo,
 	nvram_read_u16(prefix, NULL, "boardtype", &boardinfo->type, 0);
 }
 #endif
+
+#ifdef CONFIG_BCM47XX_BCMA
+void bcm47xx_fill_bcma_boardinfo(struct bcma_boardinfo *boardinfo,
+				 const char *prefix)
+{
+	nvram_read_u16(prefix, NULL, "boardvendor", &boardinfo->vendor, 0);
+	if (!boardinfo->vendor)
+		boardinfo->vendor = SSB_BOARDVENDOR_BCM;
+
+	nvram_read_u16(prefix, NULL, "boardtype", &boardinfo->type, 0);
+}
+#endif
diff --git a/arch/mips/include/asm/mach-bcm47xx/bcm47xx.h b/arch/mips/include/asm/mach-bcm47xx/bcm47xx.h
index 42887c6..26fdaf4 100644
--- a/arch/mips/include/asm/mach-bcm47xx/bcm47xx.h
+++ b/arch/mips/include/asm/mach-bcm47xx/bcm47xx.h
@@ -51,5 +51,9 @@ void bcm47xx_fill_sprom_ethernet(struct ssb_sprom *sprom, const char *prefix);
 void bcm47xx_fill_ssb_boardinfo(struct ssb_boardinfo *boardinfo,
 				const char *prefix);
 #endif
+#ifdef CONFIG_BCM47XX_BCMA
+void bcm47xx_fill_bcma_boardinfo(struct bcma_boardinfo *boardinfo,
+				 const char *prefix);
+#endif
 
 #endif /* __ASM_BCM47XX_H */
diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index e3928d6..3a93563 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -201,6 +201,9 @@ static int __devinit bcma_host_pci_probe(struct pci_dev *dev,
 	bus->hosttype = BCMA_HOSTTYPE_PCI;
 	bus->ops = &bcma_host_pci_ops;
 
+	bus->boardinfo.vendor = bus->host_pci->subsystem_vendor;
+	bus->boardinfo.type = bus->host_pci->subsystem_device;
+
 	/* Register */
 	err = bcma_bus_register(bus);
 	if (err)
diff --git a/drivers/net/wireless/b43/bus.c b/drivers/net/wireless/b43/bus.c
index 8f3c0a8..565fdbd 100644
--- a/drivers/net/wireless/b43/bus.c
+++ b/drivers/net/wireless/b43/bus.c
@@ -107,11 +107,9 @@ struct b43_bus_dev *b43_bus_dev_bcma_init(struct bcma_device *core)
 	dev->dma_dev = core->dma_dev;
 	dev->irq = core->irq;
 
-	/*
 	dev->board_vendor = core->bus->boardinfo.vendor;
 	dev->board_type = core->bus->boardinfo.type;
-	dev->board_rev = core->bus->boardinfo.rev;
-	*/
+	dev->board_rev = core->bus->sprom.board_rev;
 
 	dev->chip_id = core->bus->chipinfo.id;
 	dev->chip_rev = core->bus->chipinfo.rev;
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 5af9a07..747f2ca 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -26,6 +26,11 @@ struct bcma_chipinfo {
 	u8 pkg;
 };
 
+struct bcma_boardinfo {
+	u16 vendor;
+	u16 type;
+};
+
 enum bcma_clkmode {
 	BCMA_CLKMODE_FAST,
 	BCMA_CLKMODE_DYNAMIC,
@@ -198,6 +203,8 @@ struct bcma_bus {
 
 	struct bcma_chipinfo chipinfo;
 
+	struct bcma_boardinfo boardinfo;
+
 	struct bcma_device *mapped_core;
 	struct list_head cores;
 	u8 nr_cores;
-- 
1.7.9.5

