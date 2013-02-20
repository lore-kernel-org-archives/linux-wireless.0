Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:59369 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964958Ab3BTUQO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 15:16:14 -0500
Message-ID: <1361391373.2223.9.camel@joe-AO722> (sfid-20130220_211811_239437_4D5EF061)
Subject: [PATCH 2/2] ssb: Convert ssb_printk to ssb_<level>
From: Joe Perches <joe@perches.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	=?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Wed, 20 Feb 2013 12:16:13 -0800
In-Reply-To: <51252132.3050603@hauke-m.de>
References: <1361021140-19871-1-git-send-email-hauke@hauke-m.de>
	 <CACna6ryaMfZ9x7VWHnRR9RF0wSN0A+H6vr3AC103Sn4G1XZdKQ@mail.gmail.com>
	 <1361381489.3065.1.camel@joe-AO722> <51250E6B.3030308@lwfinger.net>
	 <1361384969.2219.4.camel@joe-AO722> <51252132.3050603@hauke-m.de>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use a more current logging style.

Convert ssb_dbprint to ssb_dbg too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/ssb/driver_chipcommon.c     |  2 +-
 drivers/ssb/driver_chipcommon_pmu.c | 41 +++++++++++++---------------
 drivers/ssb/driver_mipscore.c       | 25 ++++++++---------
 drivers/ssb/driver_pcicore.c        | 15 +++++------
 drivers/ssb/embedded.c              |  5 ++--
 drivers/ssb/main.c                  | 51 +++++++++++++++--------------------
 drivers/ssb/pci.c                   | 53 +++++++++++++++++--------------------
 drivers/ssb/pcmcia.c                | 46 ++++++++++++++------------------
 drivers/ssb/scan.c                  | 31 ++++++++--------------
 drivers/ssb/sprom.c                 |  4 +--
 drivers/ssb/ssb_private.h           | 19 ++++++++++---
 11 files changed, 135 insertions(+), 157 deletions(-)

diff --git a/drivers/ssb/driver_chipcommon.c b/drivers/ssb/driver_chipcommon.c
index 71098a7..7cb7d2c 100644
--- a/drivers/ssb/driver_chipcommon.c
+++ b/drivers/ssb/driver_chipcommon.c
@@ -354,7 +354,7 @@ void ssb_chipcommon_init(struct ssb_chipcommon *cc)
 
 	if (cc->dev->id.revision >= 11)
 		cc->status = chipco_read32(cc, SSB_CHIPCO_CHIPSTAT);
-	ssb_dprintk(KERN_INFO PFX "chipcommon status is 0x%x\n", cc->status);
+	ssb_dbg("chipcommon status is 0x%x\n", cc->status);
 
 	if (cc->dev->id.revision >= 20) {
 		chipco_write32(cc, SSB_CHIPCO_GPIOPULLUP, 0);
diff --git a/drivers/ssb/driver_chipcommon_pmu.c b/drivers/ssb/driver_chipcommon_pmu.c
index a43415a..a45d20b 100644
--- a/drivers/ssb/driver_chipcommon_pmu.c
+++ b/drivers/ssb/driver_chipcommon_pmu.c
@@ -110,8 +110,8 @@ static void ssb_pmu0_pllinit_r0(struct ssb_chipcommon *cc,
 		return;
 	}
 
-	ssb_printk(KERN_INFO PFX "Programming PLL to %u.%03u MHz\n",
-		   (crystalfreq / 1000), (crystalfreq % 1000));
+	ssb_info("Programming PLL to %u.%03u MHz\n",
+		 crystalfreq / 1000, crystalfreq % 1000);
 
 	/* First turn the PLL off. */
 	switch (bus->chip_id) {
@@ -138,7 +138,7 @@ static void ssb_pmu0_pllinit_r0(struct ssb_chipcommon *cc,
 	}
 	tmp = chipco_read32(cc, SSB_CHIPCO_CLKCTLST);
 	if (tmp & SSB_CHIPCO_CLKCTLST_HAVEHT)
-		ssb_printk(KERN_EMERG PFX "Failed to turn the PLL off!\n");
+		ssb_emerg("Failed to turn the PLL off!\n");
 
 	/* Set PDIV in PLL control 0. */
 	pllctl = ssb_chipco_pll_read(cc, SSB_PMU0_PLLCTL0);
@@ -249,8 +249,8 @@ static void ssb_pmu1_pllinit_r0(struct ssb_chipcommon *cc,
 		return;
 	}
 
-	ssb_printk(KERN_INFO PFX "Programming PLL to %u.%03u MHz\n",
-		   (crystalfreq / 1000), (crystalfreq % 1000));
+	ssb_info("Programming PLL to %u.%03u MHz\n",
+		 crystalfreq / 1000, crystalfreq % 1000);
 
 	/* First turn the PLL off. */
 	switch (bus->chip_id) {
@@ -275,7 +275,7 @@ static void ssb_pmu1_pllinit_r0(struct ssb_chipcommon *cc,
 	}
 	tmp = chipco_read32(cc, SSB_CHIPCO_CLKCTLST);
 	if (tmp & SSB_CHIPCO_CLKCTLST_HAVEHT)
-		ssb_printk(KERN_EMERG PFX "Failed to turn the PLL off!\n");
+		ssb_emerg("Failed to turn the PLL off!\n");
 
 	/* Set p1div and p2div. */
 	pllctl = ssb_chipco_pll_read(cc, SSB_PMU1_PLLCTL0);
@@ -349,9 +349,8 @@ static void ssb_pmu_pll_init(struct ssb_chipcommon *cc)
 	case 43222:
 		break;
 	default:
-		ssb_printk(KERN_ERR PFX
-			   "ERROR: PLL init unknown for device %04X\n",
-			   bus->chip_id);
+		ssb_err("ERROR: PLL init unknown for device %04X\n",
+			bus->chip_id);
 	}
 }
 
@@ -472,9 +471,8 @@ static void ssb_pmu_resources_init(struct ssb_chipcommon *cc)
 		max_msk = 0xFFFFF;
 		break;
 	default:
-		ssb_printk(KERN_ERR PFX
-			   "ERROR: PMU resource config unknown for device %04X\n",
-			   bus->chip_id);
+		ssb_err("ERROR: PMU resource config unknown for device %04X\n",
+			bus->chip_id);
 	}
 
 	if (updown_tab) {
@@ -526,8 +524,8 @@ void ssb_pmu_init(struct ssb_chipcommon *cc)
 	pmucap = chipco_read32(cc, SSB_CHIPCO_PMU_CAP);
 	cc->pmu.rev = (pmucap & SSB_CHIPCO_PMU_CAP_REVISION);
 
-	ssb_dprintk(KERN_DEBUG PFX "Found rev %u PMU (capabilities 0x%08X)\n",
-		    cc->pmu.rev, pmucap);
+	ssb_dbg("Found rev %u PMU (capabilities 0x%08X)\n",
+		cc->pmu.rev, pmucap);
 
 	if (cc->pmu.rev == 1)
 		chipco_mask32(cc, SSB_CHIPCO_PMU_CTL,
@@ -638,9 +636,8 @@ u32 ssb_pmu_get_alp_clock(struct ssb_chipcommon *cc)
 	case 0x5354:
 		ssb_pmu_get_alp_clock_clk0(cc);
 	default:
-		ssb_printk(KERN_ERR PFX
-			   "ERROR: PMU alp clock unknown for device %04X\n",
-			   bus->chip_id);
+		ssb_err("ERROR: PMU alp clock unknown for device %04X\n",
+			bus->chip_id);
 		return 0;
 	}
 }
@@ -654,9 +651,8 @@ u32 ssb_pmu_get_cpu_clock(struct ssb_chipcommon *cc)
 		/* 5354 chip uses a non programmable PLL of frequency 240MHz */
 		return 240000000;
 	default:
-		ssb_printk(KERN_ERR PFX
-			   "ERROR: PMU cpu clock unknown for device %04X\n",
-			   bus->chip_id);
+		ssb_err("ERROR: PMU cpu clock unknown for device %04X\n",
+			bus->chip_id);
 		return 0;
 	}
 }
@@ -669,9 +665,8 @@ u32 ssb_pmu_get_controlclock(struct ssb_chipcommon *cc)
 	case 0x5354:
 		return 120000000;
 	default:
-		ssb_printk(KERN_ERR PFX
-			   "ERROR: PMU controlclock unknown for device %04X\n",
-			   bus->chip_id);
+		ssb_err("ERROR: PMU controlclock unknown for device %04X\n",
+			bus->chip_id);
 		return 0;
 	}
 }
diff --git a/drivers/ssb/driver_mipscore.c b/drivers/ssb/driver_mipscore.c
index 33b37da..fa385a3 100644
--- a/drivers/ssb/driver_mipscore.c
+++ b/drivers/ssb/driver_mipscore.c
@@ -167,21 +167,22 @@ static void set_irq(struct ssb_device *dev, unsigned int irq)
 		irqflag |= (ipsflag & ~ipsflag_irq_mask[irq]);
 		ssb_write32(mdev, SSB_IPSFLAG, irqflag);
 	}
-	ssb_dprintk(KERN_INFO PFX
-		    "set_irq: core 0x%04x, irq %d => %d\n",
-		    dev->id.coreid, oldirq+2, irq+2);
+	ssb_dbg("set_irq: core 0x%04x, irq %d => %d\n",
+		dev->id.coreid, oldirq+2, irq+2);
 }
 
 static void print_irq(struct ssb_device *dev, unsigned int irq)
 {
-	int i;
 	static const char *irq_name[] = {"2(S)", "3", "4", "5", "6", "D", "I"};
-	ssb_dprintk(KERN_INFO PFX
-		"core 0x%04x, irq :", dev->id.coreid);
-	for (i = 0; i <= 6; i++) {
-		ssb_dprintk(" %s%s", irq_name[i], i==irq?"*":" ");
-	}
-	ssb_dprintk("\n");
+	ssb_dbg("core 0x%04x, irq : %s%s %s%s %s%s %s%s %s%s %s%s %s%s\n",
+		dev->id.coreid,
+		irq_name[0], irq == 0 ? "*" : " ",
+		irq_name[1], irq == 1 ? "*" : " ",
+		irq_name[2], irq == 2 ? "*" : " ",
+		irq_name[3], irq == 3 ? "*" : " ",
+		irq_name[4], irq == 4 ? "*" : " ",
+		irq_name[5], irq == 5 ? "*" : " ",
+		irq_name[6], irq == 6 ? "*" : " ");
 }
 
 static void dump_irq(struct ssb_bus *bus)
@@ -286,7 +287,7 @@ void ssb_mipscore_init(struct ssb_mipscore *mcore)
 	if (!mcore->dev)
 		return; /* We don't have a MIPS core */
 
-	ssb_dprintk(KERN_INFO PFX "Initializing MIPS core...\n");
+	ssb_dbg("Initializing MIPS core...\n");
 
 	bus = mcore->dev->bus;
 	hz = ssb_clockspeed(bus);
@@ -334,7 +335,7 @@ void ssb_mipscore_init(struct ssb_mipscore *mcore)
 			break;
 		}
 	}
-	ssb_dprintk(KERN_INFO PFX "after irq reconfiguration\n");
+	ssb_dbg("after irq reconfiguration\n");
 	dump_irq(bus);
 
 	ssb_mips_serial_init(mcore);
diff --git a/drivers/ssb/driver_pcicore.c b/drivers/ssb/driver_pcicore.c
index 59801d2..d75b72b 100644
--- a/drivers/ssb/driver_pcicore.c
+++ b/drivers/ssb/driver_pcicore.c
@@ -263,8 +263,7 @@ int ssb_pcicore_plat_dev_init(struct pci_dev *d)
 		return -ENODEV;
 	}
 
-	ssb_printk(KERN_INFO "PCI: Fixing up device %s\n",
-		   pci_name(d));
+	ssb_info("PCI: Fixing up device %s\n", pci_name(d));
 
 	/* Fix up interrupt lines */
 	d->irq = ssb_mips_irq(extpci_core->dev) + 2;
@@ -285,12 +284,12 @@ static void ssb_pcicore_fixup_pcibridge(struct pci_dev *dev)
 	if (dev->bus->number != 0 || PCI_SLOT(dev->devfn) != 0)
 		return;
 
-	ssb_printk(KERN_INFO "PCI: Fixing up bridge %s\n", pci_name(dev));
+	ssb_info("PCI: Fixing up bridge %s\n", pci_name(dev));
 
 	/* Enable PCI bridge bus mastering and memory space */
 	pci_set_master(dev);
 	if (pcibios_enable_device(dev, ~0) < 0) {
-		ssb_printk(KERN_ERR "PCI: SSB bridge enable failed\n");
+		ssb_err("PCI: SSB bridge enable failed\n");
 		return;
 	}
 
@@ -299,8 +298,8 @@ static void ssb_pcicore_fixup_pcibridge(struct pci_dev *dev)
 
 	/* Make sure our latency is high enough to handle the devices behind us */
 	lat = 168;
-	ssb_printk(KERN_INFO "PCI: Fixing latency timer of device %s to %u\n",
-		   pci_name(dev), lat);
+	ssb_info("PCI: Fixing latency timer of device %s to %u\n",
+		 pci_name(dev), lat);
 	pci_write_config_byte(dev, PCI_LATENCY_TIMER, lat);
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_ANY_ID, PCI_ANY_ID, ssb_pcicore_fixup_pcibridge);
@@ -323,7 +322,7 @@ static void ssb_pcicore_init_hostmode(struct ssb_pcicore *pc)
 		return;
 	extpci_core = pc;
 
-	ssb_dprintk(KERN_INFO PFX "PCIcore in host mode found\n");
+	ssb_dbg("PCIcore in host mode found\n");
 	/* Reset devices on the external PCI bus */
 	val = SSB_PCICORE_CTL_RST_OE;
 	val |= SSB_PCICORE_CTL_CLK_OE;
@@ -338,7 +337,7 @@ static void ssb_pcicore_init_hostmode(struct ssb_pcicore *pc)
 	udelay(1); /* Assertion time demanded by the PCI standard */
 
 	if (pc->dev->bus->has_cardbus_slot) {
-		ssb_dprintk(KERN_INFO PFX "CardBus slot detected\n");
+		ssb_dbg("CardBus slot detected\n");
 		pc->cardbusmode = 1;
 		/* GPIO 1 resets the bridge */
 		ssb_gpio_out(pc->dev->bus, 1, 1);
diff --git a/drivers/ssb/embedded.c b/drivers/ssb/embedded.c
index bb18d76..55e1011 100644
--- a/drivers/ssb/embedded.c
+++ b/drivers/ssb/embedded.c
@@ -57,9 +57,8 @@ int ssb_watchdog_register(struct ssb_bus *bus)
 					     bus->busnumber, &wdt,
 					     sizeof(wdt));
 	if (IS_ERR(pdev)) {
-		ssb_dprintk(KERN_INFO PFX
-			    "can not register watchdog device, err: %li\n",
-			    PTR_ERR(pdev));
+		ssb_dbg("can not register watchdog device, err: %li\n",
+			PTR_ERR(pdev));
 		return PTR_ERR(pdev);
 	}
 
diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index 3b645b8..812775a 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -275,8 +275,8 @@ int ssb_devices_thaw(struct ssb_freeze_context *ctx)
 
 		err = sdrv->probe(sdev, &sdev->id);
 		if (err) {
-			ssb_printk(KERN_ERR PFX "Failed to thaw device %s\n",
-				   dev_name(sdev->dev));
+			ssb_err("Failed to thaw device %s\n",
+				dev_name(sdev->dev));
 			result = err;
 		}
 		ssb_device_put(sdev);
@@ -447,10 +447,9 @@ void ssb_bus_unregister(struct ssb_bus *bus)
 
 	err = ssb_gpio_unregister(bus);
 	if (err == -EBUSY)
-		ssb_dprintk(KERN_ERR PFX "Some GPIOs are still in use.\n");
+		ssb_dbg("Some GPIOs are still in use\n");
 	else if (err)
-		ssb_dprintk(KERN_ERR PFX
-			    "Can not unregister GPIO driver: %i\n", err);
+		ssb_dbg("Can not unregister GPIO driver: %i\n", err);
 
 	ssb_buses_lock();
 	ssb_devices_unregister(bus);
@@ -497,8 +496,7 @@ static int ssb_devices_register(struct ssb_bus *bus)
 
 		devwrap = kzalloc(sizeof(*devwrap), GFP_KERNEL);
 		if (!devwrap) {
-			ssb_printk(KERN_ERR PFX
-				   "Could not allocate device\n");
+			ssb_err("Could not allocate device\n");
 			err = -ENOMEM;
 			goto error;
 		}
@@ -537,9 +535,7 @@ static int ssb_devices_register(struct ssb_bus *bus)
 		sdev->dev = dev;
 		err = device_register(dev);
 		if (err) {
-			ssb_printk(KERN_ERR PFX
-				   "Could not register %s\n",
-				   dev_name(dev));
+			ssb_err("Could not register %s\n", dev_name(dev));
 			/* Set dev to NULL to not unregister
 			 * dev on error unwinding. */
 			sdev->dev = NULL;
@@ -825,10 +821,9 @@ static int ssb_bus_register(struct ssb_bus *bus,
 	ssb_mipscore_init(&bus->mipscore);
 	err = ssb_gpio_init(bus);
 	if (err == -ENOTSUPP)
-		ssb_dprintk(KERN_DEBUG PFX "GPIO driver not activated\n");
+		ssb_dbg("GPIO driver not activated\n");
 	else if (err)
-		ssb_dprintk(KERN_ERR PFX
-			   "Error registering GPIO driver: %i\n", err);
+		ssb_dbg("Error registering GPIO driver: %i\n", err);
 	err = ssb_fetch_invariants(bus, get_invariants);
 	if (err) {
 		ssb_bus_may_powerdown(bus);
@@ -878,11 +873,11 @@ int ssb_bus_pcibus_register(struct ssb_bus *bus, struct pci_dev *host_pci)
 
 	err = ssb_bus_register(bus, ssb_pci_get_invariants, 0);
 	if (!err) {
-		ssb_printk(KERN_INFO PFX "Sonics Silicon Backplane found on "
-			   "PCI device %s\n", dev_name(&host_pci->dev));
+		ssb_info("Sonics Silicon Backplane found on PCI device %s\n",
+			 dev_name(&host_pci->dev));
 	} else {
-		ssb_printk(KERN_ERR PFX "Failed to register PCI version"
-			   " of SSB with error %d\n", err);
+		ssb_err("Failed to register PCI version of SSB with error %d\n",
+			err);
 	}
 
 	return err;
@@ -903,8 +898,8 @@ int ssb_bus_pcmciabus_register(struct ssb_bus *bus,
 
 	err = ssb_bus_register(bus, ssb_pcmcia_get_invariants, baseaddr);
 	if (!err) {
-		ssb_printk(KERN_INFO PFX "Sonics Silicon Backplane found on "
-			   "PCMCIA device %s\n", pcmcia_dev->devname);
+		ssb_info("Sonics Silicon Backplane found on PCMCIA device %s\n",
+			 pcmcia_dev->devname);
 	}
 
 	return err;
@@ -925,8 +920,8 @@ int ssb_bus_sdiobus_register(struct ssb_bus *bus, struct sdio_func *func,
 
 	err = ssb_bus_register(bus, ssb_sdio_get_invariants, ~0);
 	if (!err) {
-		ssb_printk(KERN_INFO PFX "Sonics Silicon Backplane found on "
-			   "SDIO device %s\n", sdio_func_id(func));
+		ssb_info("Sonics Silicon Backplane found on SDIO device %s\n",
+			 sdio_func_id(func));
 	}
 
 	return err;
@@ -944,8 +939,8 @@ int ssb_bus_ssbbus_register(struct ssb_bus *bus, unsigned long baseaddr,
 
 	err = ssb_bus_register(bus, get_invariants, baseaddr);
 	if (!err) {
-		ssb_printk(KERN_INFO PFX "Sonics Silicon Backplane found at "
-			   "address 0x%08lX\n", baseaddr);
+		ssb_info("Sonics Silicon Backplane found at address 0x%08lX\n",
+			 baseaddr);
 	}
 
 	return err;
@@ -1339,7 +1334,7 @@ out:
 #endif
 	return err;
 error:
-	ssb_printk(KERN_ERR PFX "Bus powerdown failed\n");
+	ssb_err("Bus powerdown failed\n");
 	goto out;
 }
 EXPORT_SYMBOL(ssb_bus_may_powerdown);
@@ -1362,7 +1357,7 @@ int ssb_bus_powerup(struct ssb_bus *bus, bool dynamic_pctl)
 
 	return 0;
 error:
-	ssb_printk(KERN_ERR PFX "Bus powerup failed\n");
+	ssb_err("Bus powerup failed\n");
 	return err;
 }
 EXPORT_SYMBOL(ssb_bus_powerup);
@@ -1470,15 +1465,13 @@ static int __init ssb_modinit(void)
 
 	err = b43_pci_ssb_bridge_init();
 	if (err) {
-		ssb_printk(KERN_ERR "Broadcom 43xx PCI-SSB-bridge "
-			   "initialization failed\n");
+		ssb_err("Broadcom 43xx PCI-SSB-bridge initialization failed\n");
 		/* don't fail SSB init because of this */
 		err = 0;
 	}
 	err = ssb_gige_init();
 	if (err) {
-		ssb_printk(KERN_ERR "SSB Broadcom Gigabit Ethernet "
-			   "driver initialization failed\n");
+		ssb_err("SSB Broadcom Gigabit Ethernet driver initialization failed\n");
 		/* don't fail SSB init because of this */
 		err = 0;
 	}
diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
index 4ec0bdb..6d6e7b9 100644
--- a/drivers/ssb/pci.c
+++ b/drivers/ssb/pci.c
@@ -56,7 +56,7 @@ int ssb_pci_switch_coreidx(struct ssb_bus *bus, u8 coreidx)
 	}
 	return 0;
 error:
-	ssb_printk(KERN_ERR PFX "Failed to switch to core %u\n", coreidx);
+	ssb_err("Failed to switch to core %u\n", coreidx);
 	return -ENODEV;
 }
 
@@ -67,10 +67,9 @@ int ssb_pci_switch_core(struct ssb_bus *bus,
 	unsigned long flags;
 
 #if SSB_VERBOSE_PCICORESWITCH_DEBUG
-	ssb_printk(KERN_INFO PFX
-		   "Switching to %s core, index %d\n",
-		   ssb_core_name(dev->id.coreid),
-		   dev->core_index);
+	ssb_info("Switching to %s core, index %d\n",
+		 ssb_core_name(dev->id.coreid),
+		 dev->core_index);
 #endif
 
 	spin_lock_irqsave(&bus->bar_lock, flags);
@@ -287,7 +286,7 @@ static int sprom_do_write(struct ssb_bus *bus, const u16 *sprom)
 	u32 spromctl;
 	u16 size = bus->sprom_size;
 
-	ssb_printk(KERN_NOTICE PFX "Writing SPROM. Do NOT turn off the power! Please stand by...\n");
+	ssb_notice("Writing SPROM. Do NOT turn off the power! Please stand by...\n");
 	err = pci_read_config_dword(pdev, SSB_SPROMCTL, &spromctl);
 	if (err)
 		goto err_ctlreg;
@@ -295,17 +294,17 @@ static int sprom_do_write(struct ssb_bus *bus, const u16 *sprom)
 	err = pci_write_config_dword(pdev, SSB_SPROMCTL, spromctl);
 	if (err)
 		goto err_ctlreg;
-	ssb_printk(KERN_NOTICE PFX "[ 0%%");
+	ssb_notice("[ 0%%");
 	msleep(500);
 	for (i = 0; i < size; i++) {
 		if (i == size / 4)
-			ssb_printk("25%%");
+			ssb_cont("25%%");
 		else if (i == size / 2)
-			ssb_printk("50%%");
+			ssb_cont("50%%");
 		else if (i == (size * 3) / 4)
-			ssb_printk("75%%");
+			ssb_cont("75%%");
 		else if (i % 2)
-			ssb_printk(".");
+			ssb_cont(".");
 		writew(sprom[i], bus->mmio + bus->sprom_offset + (i * 2));
 		mmiowb();
 		msleep(20);
@@ -318,12 +317,12 @@ static int sprom_do_write(struct ssb_bus *bus, const u16 *sprom)
 	if (err)
 		goto err_ctlreg;
 	msleep(500);
-	ssb_printk("100%% ]\n");
-	ssb_printk(KERN_NOTICE PFX "SPROM written.\n");
+	ssb_cont("100%% ]\n");
+	ssb_notice("SPROM written\n");
 
 	return 0;
 err_ctlreg:
-	ssb_printk(KERN_ERR PFX "Could not access SPROM control register.\n");
+	ssb_err("Could not access SPROM control register.\n");
 	return err;
 }
 
@@ -735,7 +734,7 @@ static int sprom_extract(struct ssb_bus *bus, struct ssb_sprom *out,
 	memset(out, 0, sizeof(*out));
 
 	out->revision = in[size - 1] & 0x00FF;
-	ssb_dprintk(KERN_DEBUG PFX "SPROM revision %d detected.\n", out->revision);
+	ssb_dbg("SPROM revision %d detected\n", out->revision);
 	memset(out->et0mac, 0xFF, 6);		/* preset et0 and et1 mac */
 	memset(out->et1mac, 0xFF, 6);
 
@@ -744,7 +743,7 @@ static int sprom_extract(struct ssb_bus *bus, struct ssb_sprom *out,
 		 * number stored in the SPROM.
 		 * Always extract r1. */
 		out->revision = 1;
-		ssb_dprintk(KERN_DEBUG PFX "SPROM treated as revision %d\n", out->revision);
+		ssb_dbg("SPROM treated as revision %d\n", out->revision);
 	}
 
 	switch (out->revision) {
@@ -761,9 +760,8 @@ static int sprom_extract(struct ssb_bus *bus, struct ssb_sprom *out,
 		sprom_extract_r8(out, in);
 		break;
 	default:
-		ssb_printk(KERN_WARNING PFX "Unsupported SPROM"
-			   " revision %d detected. Will extract"
-			   " v1\n", out->revision);
+		ssb_warn("Unsupported SPROM revision %d detected. Will extract v1\n",
+			 out->revision);
 		out->revision = 1;
 		sprom_extract_r123(out, in);
 	}
@@ -783,7 +781,7 @@ static int ssb_pci_sprom_get(struct ssb_bus *bus,
 	u16 *buf;
 
 	if (!ssb_is_sprom_available(bus)) {
-		ssb_printk(KERN_ERR PFX "No SPROM available!\n");
+		ssb_err("No SPROM available!\n");
 		return -ENODEV;
 	}
 	if (bus->chipco.dev) {	/* can be unavailable! */
@@ -802,7 +800,7 @@ static int ssb_pci_sprom_get(struct ssb_bus *bus,
 	} else {
 		bus->sprom_offset = SSB_SPROM_BASE1;
 	}
-	ssb_dprintk(KERN_INFO PFX "SPROM offset is 0x%x\n", bus->sprom_offset);
+	ssb_dbg("SPROM offset is 0x%x\n", bus->sprom_offset);
 
 	buf = kcalloc(SSB_SPROMSIZE_WORDS_R123, sizeof(u16), GFP_KERNEL);
 	if (!buf)
@@ -827,18 +825,15 @@ static int ssb_pci_sprom_get(struct ssb_bus *bus,
 			 * available for this device in some other storage */
 			err = ssb_fill_sprom_with_fallback(bus, sprom);
 			if (err) {
-				ssb_printk(KERN_WARNING PFX "WARNING: Using"
-					   " fallback SPROM failed (err %d)\n",
-					   err);
+				ssb_warn("WARNING: Using fallback SPROM failed (err %d)\n",
+					 err);
 			} else {
-				ssb_dprintk(KERN_DEBUG PFX "Using SPROM"
-					    " revision %d provided by"
-					    " platform.\n", sprom->revision);
+				ssb_dbg("Using SPROM revision %d provided by platform\n",
+					sprom->revision);
 				err = 0;
 				goto out_free;
 			}
-			ssb_printk(KERN_WARNING PFX "WARNING: Invalid"
-				   " SPROM CRC (corrupt SPROM)\n");
+			ssb_warn("WARNING: Invalid SPROM CRC (corrupt SPROM)\n");
 		}
 	}
 	err = sprom_extract(bus, sprom, buf, bus->sprom_size);
diff --git a/drivers/ssb/pcmcia.c b/drivers/ssb/pcmcia.c
index fbafed5..b413e01 100644
--- a/drivers/ssb/pcmcia.c
+++ b/drivers/ssb/pcmcia.c
@@ -143,7 +143,7 @@ int ssb_pcmcia_switch_coreidx(struct ssb_bus *bus,
 
 	return 0;
 error:
-	ssb_printk(KERN_ERR PFX "Failed to switch to core %u\n", coreidx);
+	ssb_err("Failed to switch to core %u\n", coreidx);
 	return err;
 }
 
@@ -153,10 +153,9 @@ int ssb_pcmcia_switch_core(struct ssb_bus *bus,
 	int err;
 
 #if SSB_VERBOSE_PCMCIACORESWITCH_DEBUG
-	ssb_printk(KERN_INFO PFX
-		   "Switching to %s core, index %d\n",
-		   ssb_core_name(dev->id.coreid),
-		   dev->core_index);
+	ssb_info("Switching to %s core, index %d\n",
+		 ssb_core_name(dev->id.coreid),
+		 dev->core_index);
 #endif
 
 	err = ssb_pcmcia_switch_coreidx(bus, dev->core_index);
@@ -192,7 +191,7 @@ int ssb_pcmcia_switch_segment(struct ssb_bus *bus, u8 seg)
 
 	return 0;
 error:
-	ssb_printk(KERN_ERR PFX "Failed to switch pcmcia segment\n");
+	ssb_err("Failed to switch pcmcia segment\n");
 	return err;
 }
 
@@ -549,44 +548,39 @@ static int ssb_pcmcia_sprom_write_all(struct ssb_bus *bus, const u16 *sprom)
 	bool failed = 0;
 	size_t size = SSB_PCMCIA_SPROM_SIZE;
 
-	ssb_printk(KERN_NOTICE PFX
-		   "Writing SPROM. Do NOT turn off the power! "
-		   "Please stand by...\n");
+	ssb_notice("Writing SPROM. Do NOT turn off the power! Please stand by...\n");
 	err = ssb_pcmcia_sprom_command(bus, SSB_PCMCIA_SPROMCTL_WRITEEN);
 	if (err) {
-		ssb_printk(KERN_NOTICE PFX
-			   "Could not enable SPROM write access.\n");
+		ssb_notice("Could not enable SPROM write access\n");
 		return -EBUSY;
 	}
-	ssb_printk(KERN_NOTICE PFX "[ 0%%");
+	ssb_notice("[ 0%%");
 	msleep(500);
 	for (i = 0; i < size; i++) {
 		if (i == size / 4)
-			ssb_printk("25%%");
+			ssb_cont("25%%");
 		else if (i == size / 2)
-			ssb_printk("50%%");
+			ssb_cont("50%%");
 		else if (i == (size * 3) / 4)
-			ssb_printk("75%%");
+			ssb_cont("75%%");
 		else if (i % 2)
-			ssb_printk(".");
+			ssb_cont(".");
 		err = ssb_pcmcia_sprom_write(bus, i, sprom[i]);
 		if (err) {
-			ssb_printk(KERN_NOTICE PFX
-				   "Failed to write to SPROM.\n");
+			ssb_notice("Failed to write to SPROM\n");
 			failed = 1;
 			break;
 		}
 	}
 	err = ssb_pcmcia_sprom_command(bus, SSB_PCMCIA_SPROMCTL_WRITEDIS);
 	if (err) {
-		ssb_printk(KERN_NOTICE PFX
-			   "Could not disable SPROM write access.\n");
+		ssb_notice("Could not disable SPROM write access\n");
 		failed = 1;
 	}
 	msleep(500);
 	if (!failed) {
-		ssb_printk("100%% ]\n");
-		ssb_printk(KERN_NOTICE PFX "SPROM written.\n");
+		ssb_cont("100%% ]\n");
+		ssb_notice("SPROM written\n");
 	}
 
 	return failed ? -EBUSY : 0;
@@ -700,7 +694,7 @@ static int ssb_pcmcia_do_get_invariants(struct pcmcia_device *p_dev,
 	return -ENOSPC; /* continue with next entry */
 
 error:
-	ssb_printk(KERN_ERR PFX
+	ssb_err(
 		   "PCMCIA: Failed to fetch device invariants: %s\n",
 		   error_description);
 	return -ENODEV;
@@ -722,7 +716,7 @@ int ssb_pcmcia_get_invariants(struct ssb_bus *bus,
 	res = pcmcia_loop_tuple(bus->host_pcmcia, CISTPL_FUNCE,
 				ssb_pcmcia_get_mac, sprom);
 	if (res != 0) {
-		ssb_printk(KERN_ERR PFX
+		ssb_err(
 			"PCMCIA: Failed to fetch MAC address\n");
 		return -ENODEV;
 	}
@@ -733,7 +727,7 @@ int ssb_pcmcia_get_invariants(struct ssb_bus *bus,
 	if ((res == 0) || (res == -ENOSPC))
 		return 0;
 
-	ssb_printk(KERN_ERR PFX
+	ssb_err(
 			"PCMCIA: Failed to fetch device invariants\n");
 	return -ENODEV;
 }
@@ -843,6 +837,6 @@ int ssb_pcmcia_init(struct ssb_bus *bus)
 
 	return 0;
 error:
-	ssb_printk(KERN_ERR PFX "Failed to initialize PCMCIA host device\n");
+	ssb_err("Failed to initialize PCMCIA host device\n");
 	return err;
 }
diff --git a/drivers/ssb/scan.c b/drivers/ssb/scan.c
index ab4627c..b9429df 100644
--- a/drivers/ssb/scan.c
+++ b/drivers/ssb/scan.c
@@ -125,8 +125,7 @@ static u16 pcidev_to_chipid(struct pci_dev *pci_dev)
 		chipid_fallback = 0x4401;
 		break;
 	default:
-		ssb_printk(KERN_ERR PFX
-			   "PCI-ID not in fallback list\n");
+		ssb_err("PCI-ID not in fallback list\n");
 	}
 
 	return chipid_fallback;
@@ -152,8 +151,7 @@ static u8 chipid_to_nrcores(u16 chipid)
 	case 0x4704:
 		return 9;
 	default:
-		ssb_printk(KERN_ERR PFX
-			   "CHIPID not in nrcores fallback list\n");
+		ssb_err("CHIPID not in nrcores fallback list\n");
 	}
 
 	return 1;
@@ -320,15 +318,13 @@ int ssb_bus_scan(struct ssb_bus *bus,
 			bus->chip_package = 0;
 		}
 	}
-	ssb_printk(KERN_INFO PFX "Found chip with id 0x%04X, rev 0x%02X and "
-		   "package 0x%02X\n", bus->chip_id, bus->chip_rev,
-		   bus->chip_package);
+	ssb_info("Found chip with id 0x%04X, rev 0x%02X and package 0x%02X\n",
+		 bus->chip_id, bus->chip_rev, bus->chip_package);
 	if (!bus->nr_devices)
 		bus->nr_devices = chipid_to_nrcores(bus->chip_id);
 	if (bus->nr_devices > ARRAY_SIZE(bus->devices)) {
-		ssb_printk(KERN_ERR PFX
-			   "More than %d ssb cores found (%d)\n",
-			   SSB_MAX_NR_CORES, bus->nr_devices);
+		ssb_err("More than %d ssb cores found (%d)\n",
+			SSB_MAX_NR_CORES, bus->nr_devices);
 		goto err_unmap;
 	}
 	if (bus->bustype == SSB_BUSTYPE_SSB) {
@@ -370,8 +366,7 @@ int ssb_bus_scan(struct ssb_bus *bus,
 			nr_80211_cores++;
 			if (nr_80211_cores > 1) {
 				if (!we_support_multiple_80211_cores(bus)) {
-					ssb_dprintk(KERN_INFO PFX "Ignoring additional "
-						    "802.11 core\n");
+					ssb_dbg("Ignoring additional 802.11 core\n");
 					continue;
 				}
 			}
@@ -379,8 +374,7 @@ int ssb_bus_scan(struct ssb_bus *bus,
 		case SSB_DEV_EXTIF:
 #ifdef CONFIG_SSB_DRIVER_EXTIF
 			if (bus->extif.dev) {
-				ssb_printk(KERN_WARNING PFX
-					   "WARNING: Multiple EXTIFs found\n");
+				ssb_warn("WARNING: Multiple EXTIFs found\n");
 				break;
 			}
 			bus->extif.dev = dev;
@@ -388,8 +382,7 @@ int ssb_bus_scan(struct ssb_bus *bus,
 			break;
 		case SSB_DEV_CHIPCOMMON:
 			if (bus->chipco.dev) {
-				ssb_printk(KERN_WARNING PFX
-					   "WARNING: Multiple ChipCommon found\n");
+				ssb_warn("WARNING: Multiple ChipCommon found\n");
 				break;
 			}
 			bus->chipco.dev = dev;
@@ -398,8 +391,7 @@ int ssb_bus_scan(struct ssb_bus *bus,
 		case SSB_DEV_MIPS_3302:
 #ifdef CONFIG_SSB_DRIVER_MIPS
 			if (bus->mipscore.dev) {
-				ssb_printk(KERN_WARNING PFX
-					   "WARNING: Multiple MIPS cores found\n");
+				ssb_warn("WARNING: Multiple MIPS cores found\n");
 				break;
 			}
 			bus->mipscore.dev = dev;
@@ -420,8 +412,7 @@ int ssb_bus_scan(struct ssb_bus *bus,
 				}
 			}
 			if (bus->pcicore.dev) {
-				ssb_printk(KERN_WARNING PFX
-					   "WARNING: Multiple PCI(E) cores found\n");
+				ssb_warn("WARNING: Multiple PCI(E) cores found\n");
 				break;
 			}
 			bus->pcicore.dev = dev;
diff --git a/drivers/ssb/sprom.c b/drivers/ssb/sprom.c
index 80d366f..a3b2364 100644
--- a/drivers/ssb/sprom.c
+++ b/drivers/ssb/sprom.c
@@ -127,13 +127,13 @@ ssize_t ssb_attr_sprom_store(struct ssb_bus *bus,
 		goto out_kfree;
 	err = ssb_devices_freeze(bus, &freeze);
 	if (err) {
-		ssb_printk(KERN_ERR PFX "SPROM write: Could not freeze all devices\n");
+		ssb_err("SPROM write: Could not freeze all devices\n");
 		goto out_unlock;
 	}
 	res = sprom_write(bus, sprom);
 	err = ssb_devices_thaw(&freeze);
 	if (err)
-		ssb_printk(KERN_ERR PFX "SPROM write: Could not thaw all devices\n");
+		ssb_err("SPROM write: Could not thaw all devices\n");
 out_unlock:
 	mutex_unlock(&bus->sprom_mutex);
 out_kfree:
diff --git a/drivers/ssb/ssb_private.h b/drivers/ssb/ssb_private.h
index 466171b..4671f17 100644
--- a/drivers/ssb/ssb_private.h
+++ b/drivers/ssb/ssb_private.h
@@ -9,16 +9,27 @@
 #define PFX	"ssb: "
 
 #ifdef CONFIG_SSB_SILENT
-# define ssb_printk(fmt, x...)	do { /* nothing */ } while (0)
+# define ssb_printk(fmt, ...)					\
+	do { if (0) printk(fmt, ##__VA_ARGS__); } while (0)
 #else
-# define ssb_printk		printk
+# define ssb_printk(fmt, ...)					\
+	printk(fmt, ##__VA_ARGS__)
 #endif /* CONFIG_SSB_SILENT */
 
+#define ssb_emerg(fmt, ...)	ssb_printk(KERN_EMERG PFX fmt, ##__VA_ARGS__)
+#define ssb_err(fmt, ...)	ssb_printk(KERN_ERR PFX fmt, ##__VA_ARGS__)
+#define ssb_warn(fmt, ...)	ssb_printk(KERN_WARNING PFX fmt, ##__VA_ARGS__)
+#define ssb_notice(fmt, ...)	ssb_printk(KERN_NOTICE PFX fmt, ##__VA_ARGS__)
+#define ssb_info(fmt, ...)	ssb_printk(KERN_INFO PFX fmt, ##__VA_ARGS__)
+#define ssb_cont(fmt, ...)	ssb_printk(KERN_CONT fmt, ##__VA_ARGS__)
+
 /* dprintk: Debugging printk; vanishes for non-debug compilation */
 #ifdef CONFIG_SSB_DEBUG
-# define ssb_dprintk(fmt, x...)	ssb_printk(fmt , ##x)
+# define ssb_dbg(fmt, ...)					\
+	ssb_printk(KERN_DEBUG PFX fmt, ##__VA_ARGS__)
 #else
-# define ssb_dprintk(fmt, x...)	do { /* nothing */ } while (0)
+# define ssb_dbg(fmt, ...)					\
+	do { if (0) printk(KERN_DEBUG PFX fmt, ##__VA_ARGS__); } while (0)
 #endif
 
 #ifdef CONFIG_SSB_DEBUG
-- 
1.8.1.2.459.gbcd45b4.dirty



