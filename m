Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:53532 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab2HKT5Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Aug 2012 15:57:25 -0400
Received: by ggdk6 with SMTP id k6so2482623ggd.19
        for <linux-wireless@vger.kernel.org>; Sat, 11 Aug 2012 12:57:24 -0700 (PDT)
Date: Sat, 11 Aug 2012 14:57:18 -0500
From: "Saul St. John" <saul.stjohn@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: [RFC v2 1/2] bcma: register cc core driver, device
Message-ID: <a1cc0878686e6fec894c6ee044e4d4f0c4230b0c.1344713431.git.saul.stjohn@gmail.com> (sfid-20120811_215728_614326_29471C5B)
References: <cover.1344713431.git.saul.stjohn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1344713431.git.saul.stjohn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds a device driver for the ChipCommon core ("bcma-cc-core"),
registers that driver during module initialization, and registers the CC
device if present with device_register().

Tested on a MacBookPro8,2 with BCM4331. Suspend/resume works for me.

Signed-off-by: Saul St. John <saul.stjohn@gmail.com>
---
 drivers/bcma/bcma_private.h                 |    1 +
 drivers/bcma/driver_chipcommon.c            |   51 +++++++++++------
 drivers/bcma/main.c                         |   79 ++++++++++++++-------------
 include/linux/bcma/bcma_driver_chipcommon.h |    2 -
 4 files changed, 75 insertions(+), 58 deletions(-)

diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index 3cf9cc9..19b97f9 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -46,6 +46,7 @@ int bcma_sprom_get(struct bcma_bus *bus);
 #ifdef CONFIG_BCMA_DRIVER_MIPS
 void bcma_chipco_serial_init(struct bcma_drv_cc *cc);
 #endif /* CONFIG_BCMA_DRIVER_MIPS */
+extern struct bcma_driver bcma_core_cc_driver;
 
 /* driver_chipcommon_pmu.c */
 u32 bcma_pmu_alp_clock(struct bcma_drv_cc *cc);
diff --git a/drivers/bcma/driver_chipcommon.c b/drivers/bcma/driver_chipcommon.c
index a4c3ebc..8c2013c 100644
--- a/drivers/bcma/driver_chipcommon.c
+++ b/drivers/bcma/driver_chipcommon.c
@@ -22,35 +22,34 @@ static inline u32 bcma_cc_write32_masked(struct bcma_drv_cc *cc, u16 offset,
 	return value;
 }
 
-void bcma_core_chipcommon_init(struct bcma_drv_cc *cc)
+static int bcma_core_cc_initialize(struct bcma_device *core)
 {
 	u32 leddc_on = 10;
 	u32 leddc_off = 90;
 
-	if (cc->setup_done)
-		return;
+	struct bcma_drv_cc *cc = &core->bus->drv_cc;
 
-	if (cc->core->id.rev >= 11)
-		cc->status = bcma_cc_read32(cc, BCMA_CC_CHIPSTAT);
-	cc->capabilities = bcma_cc_read32(cc, BCMA_CC_CAP);
-	if (cc->core->id.rev >= 35)
-		cc->capabilities_ext = bcma_cc_read32(cc, BCMA_CC_CAP_EXT);
+	if (core->id.rev >= 11)
+		cc->status = bcma_read32(core, BCMA_CC_CHIPSTAT);
+	cc->capabilities = bcma_read32(core, BCMA_CC_CAP);
+	if (core->id.rev >= 35)
+		cc->capabilities_ext = bcma_read32(core, BCMA_CC_CAP_EXT);
 
-	if (cc->core->id.rev >= 20) {
-		bcma_cc_write32(cc, BCMA_CC_GPIOPULLUP, 0);
-		bcma_cc_write32(cc, BCMA_CC_GPIOPULLDOWN, 0);
+	if (core->id.rev >= 20) {
+		bcma_write32(core, BCMA_CC_GPIOPULLUP, 0);
+		bcma_write32(core, BCMA_CC_GPIOPULLDOWN, 0);
 	}
 
 	if (cc->capabilities & BCMA_CC_CAP_PMU)
 		bcma_pmu_init(cc);
 	if (cc->capabilities & BCMA_CC_CAP_PCTL)
-		bcma_err(cc->core->bus, "Power control not implemented!\n");
+		bcma_err(core->bus, "Power control not implemented!\n");
 
-	if (cc->core->id.rev >= 16) {
-		if (cc->core->bus->sprom.leddc_on_time &&
-		    cc->core->bus->sprom.leddc_off_time) {
-			leddc_on = cc->core->bus->sprom.leddc_on_time;
-			leddc_off = cc->core->bus->sprom.leddc_off_time;
+	if (core->id.rev >= 16) {
+		if (core->bus->sprom.leddc_on_time &&
+		    core->bus->sprom.leddc_off_time) {
+			leddc_on = core->bus->sprom.leddc_on_time;
+			leddc_off = core->bus->sprom.leddc_off_time;
 		}
 		bcma_cc_write32(cc, BCMA_CC_GPIOTIMER,
 			((leddc_on << BCMA_CC_GPIOTIMER_ONTIME_SHIFT) |
@@ -58,8 +57,26 @@ void bcma_core_chipcommon_init(struct bcma_drv_cc *cc)
 	}
 
 	cc->setup_done = true;
+	return 0;
 }
 
+static struct bcma_device_id bcma_core_cc_id_table[] = {
+	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_CHIPCOMMON,
+		  BCMA_ANY_REV, BCMA_ANY_CLASS),
+	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_4706_CHIPCOMMON,
+		  BCMA_ANY_REV, BCMA_ANY_CLASS),
+	BCMA_CORETABLE_END
+};
+
+struct bcma_driver bcma_core_cc_driver = {
+	.name     = "bcma-cc-core",
+	.probe    = bcma_core_cc_initialize,
+	.id_table = bcma_core_cc_id_table,
+#ifdef CONFIG_PM
+	.resume   = bcma_core_cc_initialize,
+#endif
+};
+
 /* Set chip watchdog reset timer to fire in 'ticks' backplane cycles */
 void bcma_chipco_watchdog_timer_set(struct bcma_drv_cc *cc, u32 ticks)
 {
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 758af9c..498733b 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -90,13 +90,44 @@ static void bcma_release_core_dev(struct device *dev)
 	kfree(core);
 }
 
+static void bcma_register_core(struct bcma_device *core)
+{
+	int err;
+
+	core->dev.release = bcma_release_core_dev;
+	core->dev.bus = &bcma_bus_type;
+	dev_set_name(&core->dev, "bcma%d:%d",
+		     core->bus->num, core->core_index);
+
+	switch (core->bus->hosttype) {
+	case BCMA_HOSTTYPE_PCI:
+		core->dev.parent = &core->bus->host_pci->dev;
+		core->dma_dev = &core->bus->host_pci->dev;
+		core->irq = core->bus->host_pci->irq;
+		break;
+	case BCMA_HOSTTYPE_SOC:
+		core->dev.dma_mask = &core->dev.coherent_dma_mask;
+		core->dma_dev = &core->dev;
+		break;
+	case BCMA_HOSTTYPE_SDIO:
+		break;
+	}
+
+	err = device_register(&core->dev);
+	if (err) {
+		bcma_err(core->bus,
+			 "Could not register dev for core 0x%03X\n",
+			 core->id.id);
+	}
+	core->dev_registered = true;
+}
+
 static int bcma_register_cores(struct bcma_bus *bus)
 {
 	struct bcma_device *core;
-	int err, dev_id = 0;
 
 	list_for_each_entry(core, &bus->cores, list) {
-		/* We support that cores ourself */
+		/* We support these cores ourself */
 		switch (core->id.id) {
 		case BCMA_CORE_4706_CHIPCOMMON:
 		case BCMA_CORE_CHIPCOMMON:
@@ -106,34 +137,7 @@ static int bcma_register_cores(struct bcma_bus *bus)
 		case BCMA_CORE_4706_MAC_GBIT_COMMON:
 			continue;
 		}
-
-		core->dev.release = bcma_release_core_dev;
-		core->dev.bus = &bcma_bus_type;
-		dev_set_name(&core->dev, "bcma%d:%d", bus->num, dev_id);
-
-		switch (bus->hosttype) {
-		case BCMA_HOSTTYPE_PCI:
-			core->dev.parent = &bus->host_pci->dev;
-			core->dma_dev = &bus->host_pci->dev;
-			core->irq = bus->host_pci->irq;
-			break;
-		case BCMA_HOSTTYPE_SOC:
-			core->dev.dma_mask = &core->dev.coherent_dma_mask;
-			core->dma_dev = &core->dev;
-			break;
-		case BCMA_HOSTTYPE_SDIO:
-			break;
-		}
-
-		err = device_register(&core->dev);
-		if (err) {
-			bcma_err(bus,
-				 "Could not register dev for core 0x%03X\n",
-				 core->id.id);
-			continue;
-		}
-		core->dev_registered = true;
-		dev_id++;
+		bcma_register_core(core);
 	}
 
 	return 0;
@@ -143,7 +147,7 @@ static void bcma_unregister_cores(struct bcma_bus *bus)
 {
 	struct bcma_device *core;
 
-	list_for_each_entry(core, &bus->cores, list) {
+	list_for_each_entry_reverse(core, &bus->cores, list) {
 		if (core->dev_registered)
 			device_unregister(&core->dev);
 	}
@@ -169,7 +173,7 @@ int __devinit bcma_bus_register(struct bcma_bus *bus)
 	core = bcma_find_core(bus, bcma_cc_core_id(bus));
 	if (core) {
 		bus->drv_cc.core = core;
-		bcma_core_chipcommon_init(&bus->drv_cc);
+		bcma_register_core(core);
 	}
 
 	/* Init MIPS core */
@@ -251,7 +255,7 @@ int __init bcma_bus_early_register(struct bcma_bus *bus,
 	core = bcma_find_core(bus, bcma_cc_core_id(bus));
 	if (core) {
 		bus->drv_cc.core = core;
-		bcma_core_chipcommon_init(&bus->drv_cc);
+		bcma_register_core(core);
 	}
 
 	/* Init MIPS core */
@@ -286,12 +290,6 @@ int bcma_bus_resume(struct bcma_bus *bus)
 {
 	struct bcma_device *core;
 
-	/* Init CC core */
-	if (bus->drv_cc.core) {
-		bus->drv_cc.setup_done = false;
-		bcma_core_chipcommon_init(&bus->drv_cc);
-	}
-
 	list_for_each_entry(core, &bus->cores, list) {
 		struct device_driver *drv = core->dev.driver;
 		if (drv) {
@@ -381,6 +379,8 @@ static int __init bcma_modinit(void)
 	if (err)
 		return err;
 
+	bcma_driver_register(&bcma_core_cc_driver);
+
 #ifdef CONFIG_BCMA_HOST_PCI
 	err = bcma_host_pci_init();
 	if (err) {
@@ -398,6 +398,7 @@ static void __exit bcma_modexit(void)
 #ifdef CONFIG_BCMA_HOST_PCI
 	bcma_host_pci_exit();
 #endif
+	bcma_driver_unregister(&bcma_core_cc_driver);
 	bus_unregister(&bcma_bus_type);
 }
 module_exit(bcma_modexit)
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index d323a4b..f6e5858 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -469,8 +469,6 @@ struct bcma_drv_cc {
 #define bcma_cc_maskset32(cc, offset, mask, set) \
 	bcma_cc_write32(cc, offset, (bcma_cc_read32(cc, offset) & (mask)) | (set))
 
-extern void bcma_core_chipcommon_init(struct bcma_drv_cc *cc);
-
 extern void bcma_chipco_suspend(struct bcma_drv_cc *cc);
 extern void bcma_chipco_resume(struct bcma_drv_cc *cc);
 
-- 
1.7.10.4

