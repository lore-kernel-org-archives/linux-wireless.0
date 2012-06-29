Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58893 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab2F2MKQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 08:10:16 -0400
Received: by bkcji2 with SMTP id ji2so2898054bkc.19
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jun 2012 05:10:14 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Joe Perches <joe@perches.com>, Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V2] bcma: use custom printing functions
Date: Fri, 29 Jun 2012 14:10:09 +0200
Message-Id: <1340971809-23703-1-git-send-email-zajec5@gmail.com> (sfid-20120629_141021_511230_79320E28)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Having bus number printed makes it much easier to anaylze logs on
systems with more buses. For example Netgear WNDR4500 has 3 AMBA buses
in total, which makes standard log really messy.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V2: don't create "bus" variable when it's not really helpful
don't brak strings

John: this applies on top of 5 patches accepted in the
[PATCH 0/8] bcma misc updates
patchset.

So:
wireless-testing +
	bcma: extend workaround for bcm4331
	bcma: add constants for chip ids
	bcma: add PCI ID for BCM43224
	bcma: complete workaround for BCMA43224 and BCM4313
	bcma: add bcma_pmu_spuravoid_pllupdate()

And then:
bcma: use custom printing functions
applies cleanly :)
---
 drivers/bcma/bcma_private.h          |    8 ++++++++
 drivers/bcma/core.c                  |   10 +++++-----
 drivers/bcma/driver_chipcommon.c     |    5 ++---
 drivers/bcma/driver_chipcommon_pmu.c |   22 ++++++++++------------
 drivers/bcma/driver_mips.c           |   16 ++++++++--------
 drivers/bcma/driver_pci_host.c       |   10 ++++++----
 drivers/bcma/host_pci.c              |    2 +-
 drivers/bcma/main.c                  |   19 ++++++++++---------
 drivers/bcma/scan.c                  |   24 +++++++++++-------------
 drivers/bcma/sprom.c                 |    2 +-
 10 files changed, 62 insertions(+), 56 deletions(-)

diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index b81755b..b1ada3a 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -10,6 +10,14 @@
 
 #define BCMA_CORE_SIZE		0x1000
 
+/* We use pr_fmt, so call printk directly */
+#define bcma_err(bus, fmt, ...) \
+	printk(KERN_ERR KBUILD_MODNAME " bus%d: " fmt, (bus)->num, ##__VA_ARGS__)
+#define bcma_warn(bus, fmt, ...) \
+	printk(KERN_WARNING KBUILD_MODNAME " bus%d: " fmt, (bus)->num, ##__VA_ARGS__)
+#define bcma_info(bus, fmt, ...) \
+	printk(KERN_INFO KBUILD_MODNAME " bus%d: " fmt, (bus)->num, ##__VA_ARGS__)
+
 struct bcma_bus;
 
 /* main.c */
diff --git a/drivers/bcma/core.c b/drivers/bcma/core.c
index bc6e892..4a49e59 100644
--- a/drivers/bcma/core.c
+++ b/drivers/bcma/core.c
@@ -75,7 +75,7 @@ void bcma_core_set_clockmode(struct bcma_device *core,
 			udelay(10);
 		}
 		if (i)
-			pr_err("HT force timeout\n");
+			bcma_err(core->bus, "HT force timeout\n");
 		break;
 	case BCMA_CLKMODE_DYNAMIC:
 		bcma_set32(core, BCMA_CLKCTLST, ~BCMA_CLKCTLST_FORCEHT);
@@ -102,9 +102,9 @@ void bcma_core_pll_ctl(struct bcma_device *core, u32 req, u32 status, bool on)
 			udelay(10);
 		}
 		if (i)
-			pr_err("PLL enable timeout\n");
+			bcma_err(core->bus, "PLL enable timeout\n");
 	} else {
-		pr_warn("Disabling PLL not supported yet!\n");
+		bcma_warn(core->bus, "Disabling PLL not supported yet!\n");
 	}
 }
 EXPORT_SYMBOL_GPL(bcma_core_pll_ctl);
@@ -120,8 +120,8 @@ u32 bcma_core_dma_translation(struct bcma_device *core)
 		else
 			return BCMA_DMA_TRANSLATION_DMA32_CMT;
 	default:
-		pr_err("DMA translation unknown for host %d\n",
-		       core->bus->hosttype);
+		bcma_err(core->bus, "DMA translation unknown for host %d\n",
+		         core->bus->hosttype);
 	}
 	return BCMA_DMA_TRANSLATION_NONE;
 }
diff --git a/drivers/bcma/driver_chipcommon.c b/drivers/bcma/driver_chipcommon.c
index e9f1b3f..61c19ce 100644
--- a/drivers/bcma/driver_chipcommon.c
+++ b/drivers/bcma/driver_chipcommon.c
@@ -44,7 +44,7 @@ void bcma_core_chipcommon_init(struct bcma_drv_cc *cc)
 	if (cc->capabilities & BCMA_CC_CAP_PMU)
 		bcma_pmu_init(cc);
 	if (cc->capabilities & BCMA_CC_CAP_PCTL)
-		pr_err("Power control not implemented!\n");
+		bcma_err(cc->core->bus, "Power control not implemented!\n");
 
 	if (cc->core->id.rev >= 16) {
 		if (cc->core->bus->sprom.leddc_on_time &&
@@ -137,8 +137,7 @@ void bcma_chipco_serial_init(struct bcma_drv_cc *cc)
 				       | BCMA_CC_CORECTL_UARTCLKEN);
 		}
 	} else {
-		pr_err("serial not supported on this device ccrev: 0x%x\n",
-		       ccrev);
+		bcma_err(bus, "serial not supported on this device ccrev: 0x%x\n", ccrev);
 		return;
 	}
 
diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
index 2a3da19..1af1d74 100644
--- a/drivers/bcma/driver_chipcommon_pmu.c
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -86,8 +86,8 @@ static void bcma_pmu_resources_init(struct bcma_drv_cc *cc)
 	case BCMA_CHIP_ID_BCM43225:
 		break;
 	default:
-		pr_err("PMU resource config unknown for device 0x%04X\n",
-			bus->chipinfo.id);
+		bcma_err(bus, "PMU resource config unknown for device 0x%04X\n",
+			 bus->chipinfo.id);
 	}
 
 	/* Set the resource masks. */
@@ -171,8 +171,8 @@ void bcma_pmu_workarounds(struct bcma_drv_cc *cc)
 	case BCMA_CHIP_ID_BCM43225:
 		break;
 	default:
-		pr_err("Workarounds unknown for device 0x%04X\n",
-			bus->chipinfo.id);
+		bcma_err(bus, "Workarounds unknown for device 0x%04X\n",
+			 bus->chipinfo.id);
 	}
 }
 
@@ -221,9 +221,8 @@ u32 bcma_pmu_alp_clock(struct bcma_drv_cc *cc)
 		/* always 25Mhz */
 		return 25000 * 1000;
 	default:
-		pr_warn("No ALP clock specified for %04X device, "
-			"pmu rev. %d, using default %d Hz\n",
-			bus->chipinfo.id, cc->pmu.rev, BCMA_CC_PMU_ALP_CLOCK);
+		bcma_warn(bus, "No ALP clock specified for %04X device, pmu rev. %d, using default %d Hz\n",
+			  bus->chipinfo.id, cc->pmu.rev, BCMA_CC_PMU_ALP_CLOCK);
 	}
 	return BCMA_CC_PMU_ALP_CLOCK;
 }
@@ -291,9 +290,8 @@ u32 bcma_pmu_get_clockcontrol(struct bcma_drv_cc *cc)
 	case BCMA_CHIP_ID_BCM53572:
 		return 75000000;
 	default:
-		pr_warn("No backplane clock specified for %04X device, "
-			"pmu rev. %d, using default %d Hz\n",
-			bus->chipinfo.id, cc->pmu.rev, BCMA_CC_PMU_HT_CLOCK);
+		bcma_warn(bus, "No backplane clock specified for %04X device, pmu rev. %d, using default %d Hz\n",
+			  bus->chipinfo.id, cc->pmu.rev, BCMA_CC_PMU_HT_CLOCK);
 	}
 	return BCMA_CC_PMU_HT_CLOCK;
 }
@@ -527,8 +525,8 @@ void bcma_pmu_spuravoid_pllupdate(struct bcma_drv_cc *cc, int spuravoid)
 		tmp = 1 << 10;
 		break;
 	default:
-		pr_err("unknown spuravoidance settings for chip 0x%04X, not"
-		       " changing PLL\n", bus->chipinfo.id);
+		bcma_err(bus, "Unknown spuravoidance settings for chip 0x%04X, not changing PLL\n",
+			 bus->chipinfo.id);
 		break;
 	}
 
diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
index 73ed301..ef34ed2 100644
--- a/drivers/bcma/driver_mips.c
+++ b/drivers/bcma/driver_mips.c
@@ -143,8 +143,8 @@ static void bcma_core_mips_set_irq(struct bcma_device *dev, unsigned int irq)
 			     1 << irqflag);
 	}
 
-	pr_info("set_irq: core 0x%04x, irq %d => %d\n",
-		dev->id.id, oldirq + 2, irq + 2);
+	bcma_info(bus, "set_irq: core 0x%04x, irq %d => %d\n",
+		  dev->id.id, oldirq + 2, irq + 2);
 }
 
 static void bcma_core_mips_print_irq(struct bcma_device *dev, unsigned int irq)
@@ -173,7 +173,7 @@ u32 bcma_cpu_clock(struct bcma_drv_mips *mcore)
 	if (bus->drv_cc.capabilities & BCMA_CC_CAP_PMU)
 		return bcma_pmu_get_clockcpu(&bus->drv_cc);
 
-	pr_err("No PMU available, need this to get the cpu clock\n");
+	bcma_err(bus, "No PMU available, need this to get the cpu clock\n");
 	return 0;
 }
 EXPORT_SYMBOL(bcma_cpu_clock);
@@ -185,10 +185,10 @@ static void bcma_core_mips_flash_detect(struct bcma_drv_mips *mcore)
 	switch (bus->drv_cc.capabilities & BCMA_CC_CAP_FLASHT) {
 	case BCMA_CC_FLASHT_STSER:
 	case BCMA_CC_FLASHT_ATSER:
-		pr_err("Serial flash not supported.\n");
+		bcma_err(bus, "Serial flash not supported.\n");
 		break;
 	case BCMA_CC_FLASHT_PARA:
-		pr_info("found parallel flash.\n");
+		bcma_info(bus, "found parallel flash.\n");
 		bus->drv_cc.pflash.window = 0x1c000000;
 		bus->drv_cc.pflash.window_size = 0x02000000;
 
@@ -199,7 +199,7 @@ static void bcma_core_mips_flash_detect(struct bcma_drv_mips *mcore)
 			bus->drv_cc.pflash.buswidth = 2;
 		break;
 	default:
-		pr_err("flash not supported.\n");
+		bcma_err(bus, "flash not supported.\n");
 	}
 }
 
@@ -209,7 +209,7 @@ void bcma_core_mips_init(struct bcma_drv_mips *mcore)
 	struct bcma_device *core;
 	bus = mcore->core->bus;
 
-	pr_info("Initializing MIPS core...\n");
+	bcma_info(bus, "Initializing MIPS core...\n");
 
 	if (!mcore->setup_done)
 		mcore->assigned_irqs = 1;
@@ -244,7 +244,7 @@ void bcma_core_mips_init(struct bcma_drv_mips *mcore)
 			break;
 		}
 	}
-	pr_info("IRQ reconfiguration done\n");
+	bcma_info(bus, "IRQ reconfiguration done\n");
 	bcma_core_mips_dump_irq(bus);
 
 	if (mcore->setup_done)
diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
index d6e8a37..cbae2c2 100644
--- a/drivers/bcma/driver_pci_host.c
+++ b/drivers/bcma/driver_pci_host.c
@@ -36,7 +36,7 @@ bool __devinit bcma_core_pci_is_in_hostmode(struct bcma_drv_pci *pc)
 		return false;
 
 	if (bus->sprom.boardflags_lo & BCMA_CORE_PCI_BFL_NOPCI) {
-		pr_info("This PCI core is disabled and not working\n");
+		bcma_info(bus, "This PCI core is disabled and not working\n");
 		return false;
 	}
 
@@ -341,6 +341,7 @@ static u8 __devinit bcma_find_pci_capability(struct bcma_drv_pci *pc,
  */
 static void __devinit bcma_core_pci_enable_crs(struct bcma_drv_pci *pc)
 {
+	struct bcma_bus *bus = pc->core->bus;
 	u8 cap_ptr, root_ctrl, root_cap, dev;
 	u16 val16;
 	int i;
@@ -379,7 +380,8 @@ static void __devinit bcma_core_pci_enable_crs(struct bcma_drv_pci *pc)
 				udelay(10);
 			}
 			if (val16 == 0x1)
-				pr_err("PCI: Broken device in slot %d\n", dev);
+				bcma_err(bus, "PCI: Broken device in slot %d\n",
+					 dev);
 		}
 	}
 }
@@ -392,11 +394,11 @@ void __devinit bcma_core_pci_hostmode_init(struct bcma_drv_pci *pc)
 	u32 pci_membase_1G;
 	unsigned long io_map_base;
 
-	pr_info("PCIEcore in host mode found\n");
+	bcma_info(bus, "PCIEcore in host mode found\n");
 
 	pc_host = kzalloc(sizeof(*pc_host), GFP_KERNEL);
 	if (!pc_host)  {
-		pr_err("can not allocate memory");
+		bcma_err(bus, "can not allocate memory");
 		return;
 	}
 
diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index c693c0b..9f0147c 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -188,7 +188,7 @@ static int __devinit bcma_host_pci_probe(struct pci_dev *dev,
 
 	/* SSB needed additional powering up, do we have any AMBA PCI cards? */
 	if (!pci_is_pcie(dev))
-		pr_err("PCI card detected, report problems.\n");
+		bcma_err(bus, "PCI card detected, report problems.\n");
 
 	/* Map MMIO */
 	err = -ENOMEM;
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 7e138ec..7ff4bac 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -118,8 +118,9 @@ static int bcma_register_cores(struct bcma_bus *bus)
 
 		err = device_register(&core->dev);
 		if (err) {
-			pr_err("Could not register dev for core 0x%03X\n",
-			       core->id.id);
+			bcma_err(bus,
+				 "Could not register dev for core 0x%03X\n",
+				 core->id.id);
 			continue;
 		}
 		core->dev_registered = true;
@@ -151,7 +152,7 @@ int __devinit bcma_bus_register(struct bcma_bus *bus)
 	/* Scan for devices (cores) */
 	err = bcma_bus_scan(bus);
 	if (err) {
-		pr_err("Failed to scan: %d\n", err);
+		bcma_err(bus, "Failed to scan: %d\n", err);
 		return -1;
 	}
 
@@ -179,14 +180,14 @@ int __devinit bcma_bus_register(struct bcma_bus *bus)
 	/* Try to get SPROM */
 	err = bcma_sprom_get(bus);
 	if (err == -ENOENT) {
-		pr_err("No SPROM available\n");
+		bcma_err(bus, "No SPROM available\n");
 	} else if (err)
-		pr_err("Failed to get SPROM: %d\n", err);
+		bcma_err(bus, "Failed to get SPROM: %d\n", err);
 
 	/* Register found cores */
 	bcma_register_cores(bus);
 
-	pr_info("Bus registered\n");
+	bcma_info(bus, "Bus registered\n");
 
 	return 0;
 }
@@ -214,7 +215,7 @@ int __init bcma_bus_early_register(struct bcma_bus *bus,
 	/* Scan for chip common core */
 	err = bcma_bus_scan_early(bus, &match, core_cc);
 	if (err) {
-		pr_err("Failed to scan for common core: %d\n", err);
+		bcma_err(bus, "Failed to scan for common core: %d\n", err);
 		return -1;
 	}
 
@@ -226,7 +227,7 @@ int __init bcma_bus_early_register(struct bcma_bus *bus,
 	/* Scan for mips core */
 	err = bcma_bus_scan_early(bus, &match, core_mips);
 	if (err) {
-		pr_err("Failed to scan for mips core: %d\n", err);
+		bcma_err(bus, "Failed to scan for mips core: %d\n", err);
 		return -1;
 	}
 
@@ -244,7 +245,7 @@ int __init bcma_bus_early_register(struct bcma_bus *bus,
 		bcma_core_mips_init(&bus->drv_mips);
 	}
 
-	pr_info("Early bus registered\n");
+	bcma_info(bus, "Early bus registered\n");
 
 	return 0;
 }
diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index a342058..a0272bb 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -340,7 +340,7 @@ static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
 		if (tmp <= 0) {
 			return -EILSEQ;
 		} else {
-			pr_info("Bridge found\n");
+			bcma_info(bus, "Bridge found\n");
 			return -ENXIO;
 		}
 	}
@@ -427,8 +427,8 @@ void bcma_init_bus(struct bcma_bus *bus)
 	chipinfo->id = (tmp & BCMA_CC_ID_ID) >> BCMA_CC_ID_ID_SHIFT;
 	chipinfo->rev = (tmp & BCMA_CC_ID_REV) >> BCMA_CC_ID_REV_SHIFT;
 	chipinfo->pkg = (tmp & BCMA_CC_ID_PKG) >> BCMA_CC_ID_PKG_SHIFT;
-	pr_info("Found chip with id 0x%04X, rev 0x%02X and package 0x%02X\n",
-		chipinfo->id, chipinfo->rev, chipinfo->pkg);
+	bcma_info(bus, "Found chip with id 0x%04X, rev 0x%02X and package 0x%02X\n",
+		  chipinfo->id, chipinfo->rev, chipinfo->pkg);
 
 	bus->init_done = true;
 }
@@ -482,11 +482,10 @@ int bcma_bus_scan(struct bcma_bus *bus)
 		other_core = bcma_find_core_reverse(bus, core->id.id);
 		core->core_unit = (other_core == NULL) ? 0 : other_core->core_unit + 1;
 
-		pr_info("Core %d found: %s "
-			"(manuf 0x%03X, id 0x%03X, rev 0x%02X, class 0x%X)\n",
-			core->core_index, bcma_device_name(&core->id),
-			core->id.manuf, core->id.id, core->id.rev,
-			core->id.class);
+		bcma_info(bus, "Core %d found: %s (manuf 0x%03X, id 0x%03X, rev 0x%02X, class 0x%X)\n",
+			  core->core_index, bcma_device_name(&core->id),
+			  core->id.manuf, core->id.id, core->id.rev,
+			  core->id.class);
 
 		list_add(&core->list, &bus->cores);
 	}
@@ -538,11 +537,10 @@ int __init bcma_bus_scan_early(struct bcma_bus *bus,
 
 		core->core_index = core_num++;
 		bus->nr_cores++;
-		pr_info("Core %d found: %s "
-			"(manuf 0x%03X, id 0x%03X, rev 0x%02X, class 0x%X)\n",
-			core->core_index, bcma_device_name(&core->id),
-			core->id.manuf, core->id.id, core->id.rev,
-			core->id.class);
+		bcma_info(bus, "Core %d found: %s (manuf 0x%03X, id 0x%03X, rev 0x%02X, class 0x%X)\n",
+			  core->core_index, bcma_device_name(&core->id),
+			  core->id.manuf, core->id.id, core->id.rev,
+			  core->id.class);
 
 		list_add(&core->list, &bus->cores);
 		err = 0;
diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
index e1eb598..26464b8 100644
--- a/drivers/bcma/sprom.c
+++ b/drivers/bcma/sprom.c
@@ -64,7 +64,7 @@ static int bcma_fill_sprom_with_fallback(struct bcma_bus *bus,
 		 " platform.\n", bus->sprom.revision);
 	return 0;
 fail:
-	pr_warn("Using fallback SPROM failed (err %d)\n", err);
+	bcma_warn(bus, "Using fallback SPROM failed (err %d)\n", err);
 	return err;
 }
 
-- 
1.7.7

