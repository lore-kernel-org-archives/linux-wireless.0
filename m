Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58854 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754899Ab1GPQ4M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jul 2011 12:56:12 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: ralf@linux-mips.org, linux-wireless@vger.kernel.org,
	zajec5@gmail.com, linux-mips@linux-mips.org
Cc: jonas.gorski@gmail.com, mb@bu3sch.de, george@znau.edu.ua,
	arend@broadcom.com, b43-dev@lists.infradead.org,
	bernhardloos@googlemail.com, arnd@arndb.de,
	julian.calaby@gmail.com, sshtylyov@mvista.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 03/11] bcma: add functions to scan cores needed on SoCs
Date: Sat, 16 Jul 2011 18:55:34 +0200
Message-Id: <1310835342-18877-4-git-send-email-hauke@hauke-m.de> (sfid-20110716_185625_889934_94EBB5C8)
In-Reply-To: <1310835342-18877-1-git-send-email-hauke@hauke-m.de>
References: <1310835342-18877-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The chip common and mips core have to be setup early in the boot
process to get the cpu clock.
bcma_bus_early_register() gets pointers to some space to store the core
data and searches for the chip common and mips core and initializes
chip common. After that was done and the kernel is out of early boot we
just have to run bcma_bus_register() and it will search for the other
cores, initialize and register them.
The cores are getting the same numbers as before.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/bcma_private.h                 |    7 ++
 drivers/bcma/driver_chipcommon.c            |    5 ++
 drivers/bcma/driver_pci.c                   |    3 +
 drivers/bcma/main.c                         |   45 +++++++++++++
 drivers/bcma/scan.c                         |   95 +++++++++++++++++++++++++--
 include/linux/bcma/bcma.h                   |    1 +
 include/linux/bcma/bcma_driver_chipcommon.h |    1 +
 7 files changed, 151 insertions(+), 6 deletions(-)

diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index 2f72e9c..830386c 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -15,9 +15,16 @@ struct bcma_bus;
 /* main.c */
 extern int bcma_bus_register(struct bcma_bus *bus);
 extern void bcma_bus_unregister(struct bcma_bus *bus);
+int __init bcma_bus_early_register(struct bcma_bus *bus,
+				   struct bcma_device *core_cc,
+				   struct bcma_device *core_mips);
 
 /* scan.c */
 int bcma_bus_scan(struct bcma_bus *bus);
+int __init bcma_bus_scan_early(struct bcma_bus *bus,
+			       struct bcma_device_id *match,
+			       struct bcma_device *core);
+void bcma_init_bus(struct bcma_bus *bus);
 
 #ifdef CONFIG_BCMA_HOST_PCI
 /* host_pci.c */
diff --git a/drivers/bcma/driver_chipcommon.c b/drivers/bcma/driver_chipcommon.c
index 6061022..70321c6 100644
--- a/drivers/bcma/driver_chipcommon.c
+++ b/drivers/bcma/driver_chipcommon.c
@@ -23,6 +23,9 @@ static inline u32 bcma_cc_write32_masked(struct bcma_drv_cc *cc, u16 offset,
 
 void bcma_core_chipcommon_init(struct bcma_drv_cc *cc)
 {
+	if (cc->setup_done)
+		return;
+
 	if (cc->core->id.rev >= 11)
 		cc->status = bcma_cc_read32(cc, BCMA_CC_CHIPSTAT);
 	cc->capabilities = bcma_cc_read32(cc, BCMA_CC_CAP);
@@ -38,6 +41,8 @@ void bcma_core_chipcommon_init(struct bcma_drv_cc *cc)
 		bcma_pmu_init(cc);
 	if (cc->capabilities & BCMA_CC_CAP_PCTL)
 		pr_err("Power control not implemented!\n");
+
+	cc->setup_done = true;
 }
 
 /* Set chip watchdog reset timer to fire in 'ticks' backplane cycles */
diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
index e757e4e..f7378b3 100644
--- a/drivers/bcma/driver_pci.c
+++ b/drivers/bcma/driver_pci.c
@@ -159,5 +159,8 @@ static void bcma_pcicore_serdes_workaround(struct bcma_drv_pci *pc)
 
 void bcma_core_pci_init(struct bcma_drv_pci *pc)
 {
+	if (pc->setup_done)
+		return;
 	bcma_pcicore_serdes_workaround(pc);
+	pc->setup_done = true;
 }
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index be52344..e6c308c 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -159,6 +159,51 @@ void bcma_bus_unregister(struct bcma_bus *bus)
 }
 EXPORT_SYMBOL_GPL(bcma_bus_unregister);
 
+int __init bcma_bus_early_register(struct bcma_bus *bus,
+				   struct bcma_device *core_cc,
+				   struct bcma_device *core_mips)
+{
+	int err;
+	struct bcma_device *core;
+	struct bcma_device_id match;
+
+	bcma_init_bus(bus);
+
+	match.manuf = BCMA_MANUF_BCM;
+	match.id = BCMA_CORE_CHIPCOMMON;
+	match.class = BCMA_CL_SIM;
+	match.rev = BCMA_ANY_REV;
+
+	/* Scan for devices (cores) */
+	err = bcma_bus_scan_early(bus, &match, core_cc);
+	if (err) {
+		pr_err("Failed to scan for common core: %d\n", err);
+		return -1;
+	}
+
+	match.manuf = BCMA_MANUF_MIPS;
+	match.id = BCMA_CORE_MIPS_74K;
+	match.class = BCMA_CL_SIM;
+	match.rev = BCMA_ANY_REV;
+
+	err = bcma_bus_scan_early(bus, &match, core_mips);
+	if (err) {
+		pr_err("Failed to scan for mips core: %d\n", err);
+		return -1;
+	}
+
+	/* Init CC core */
+	core = bcma_find_core(bus, BCMA_CORE_CHIPCOMMON);
+	if (core) {
+		bus->drv_cc.core = core;
+		bcma_core_chipcommon_init(&bus->drv_cc);
+	}
+
+	pr_info("Early bus registered\n");
+
+	return 0;
+}
+
 int __bcma_driver_register(struct bcma_driver *drv, struct module *owner)
 {
 	drv->drv.name = drv->name;
diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index 7970553..bf9f806 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -200,7 +200,20 @@ static s32 bcma_erom_get_addr_desc(struct bcma_bus *bus, u32 **eromptr,
 	return addrl;
 }
 
+static struct bcma_device *bcma_find_core_by_index(struct bcma_bus *bus,
+						   u16 index)
+{
+	struct bcma_device *core;
+
+	list_for_each_entry(core, &bus->cores, list) {
+		if (core->core_index == index)
+			return core;
+	}
+	return NULL;
+}
+
 static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
+			      struct bcma_device_id *match, int core_num,
 			      struct bcma_device *core)
 {
 	s32 tmp;
@@ -251,6 +264,21 @@ static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
 		return -ENXIO;
 	}
 
+	if (bcma_find_core_by_index(bus, core_num)) {
+		bcma_erom_skip_component(bus, eromptr);
+		return -ENODEV;
+	}
+
+	if (match && ((match->manuf != BCMA_ANY_MANUF &&
+	      match->manuf != core->id.manuf) ||
+	     (match->id != BCMA_ANY_ID && match->id != core->id.id) ||
+	     (match->rev != BCMA_ANY_REV && match->rev != core->id.rev) ||
+	     (match->class != BCMA_ANY_CLASS && match->class != core->id.class)
+	    )) {
+		bcma_erom_skip_component(bus, eromptr);
+		return -ENODEV;
+	}
+
 	/* get & parse master ports */
 	for (i = 0; i < ports[0]; i++) {
 		u32 mst_port_d = bcma_erom_get_mst_port(bus, eromptr);
@@ -312,10 +340,13 @@ static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
 	return 0;
 }
 
-static void bcma_init_bus(struct bcma_bus *bus)
+void bcma_init_bus(struct bcma_bus *bus)
 {
 	s32 tmp;
 
+	if (bus->init_done)
+		return;
+
 	INIT_LIST_HEAD(&bus->cores);
 	bus->nr_cores = 0;
 
@@ -325,6 +356,7 @@ static void bcma_init_bus(struct bcma_bus *bus)
 	bus->chipinfo.id = (tmp & BCMA_CC_ID_ID) >> BCMA_CC_ID_ID_SHIFT;
 	bus->chipinfo.rev = (tmp & BCMA_CC_ID_REV) >> BCMA_CC_ID_REV_SHIFT;
 	bus->chipinfo.pkg = (tmp & BCMA_CC_ID_PKG) >> BCMA_CC_ID_PKG_SHIFT;
+	bus->init_done = true;
 }
 
 int bcma_bus_scan(struct bcma_bus *bus)
@@ -332,7 +364,7 @@ int bcma_bus_scan(struct bcma_bus *bus)
 	u32 erombase;
 	u32 __iomem *eromptr, *eromend;
 
-	int err;
+	int err, core_num = 0;
 
 	bcma_init_bus(bus);
 
@@ -349,23 +381,74 @@ int bcma_bus_scan(struct bcma_bus *bus)
 		INIT_LIST_HEAD(&core->list);
 		core->bus = bus;
 
-		err = bcma_get_next_core(bus, &eromptr, core);
-		if (err == -ENXIO)
+		err = bcma_get_next_core(bus, &eromptr, NULL, core_num, core);
+		if (err == -ENODEV) {
+			core_num++;
+			continue;
+		} else if (err == -ENXIO)
 			continue;
 		else if (err == -ESPIPE)
 			break;
 		else if (err < 0)
 			return err;
 
+		core->core_index = core_num++;
+		bus->nr_cores++;
+
 		pr_info("Core %d found: %s "
 			"(manuf 0x%03X, id 0x%03X, rev 0x%02X, class 0x%X)\n",
-			bus->nr_cores, bcma_device_name(&core->id),
+			core->core_index, bcma_device_name(&core->id),
 			core->id.manuf, core->id.id, core->id.rev,
 			core->id.class);
 
-		core->core_index = bus->nr_cores++;
 		list_add(&core->list, &bus->cores);
 	}
 
 	return 0;
 }
+
+int __init bcma_bus_scan_early(struct bcma_bus *bus,
+			       struct bcma_device_id *match,
+			       struct bcma_device *core)
+{
+	u32 erombase;
+	u32 __iomem *eromptr, *eromend;
+
+	int err, core_num = 0;
+
+	erombase = bcma_scan_read32(bus, 0, BCMA_CC_EROM);
+	eromptr = bus->mmio;
+	eromend = eromptr + BCMA_CORE_SIZE / sizeof(u32);
+
+	bcma_scan_switch_core(bus, erombase);
+
+	while (eromptr < eromend) {
+		memset(core, 0, sizeof(*core));
+		INIT_LIST_HEAD(&core->list);
+		core->bus = bus;
+
+		err = bcma_get_next_core(bus, &eromptr, match, core_num, core);
+		if (err == -ENODEV) {
+			core_num++;
+			continue;
+		} else if (err == -ENXIO)
+			continue;
+		else if (err == -ESPIPE)
+			break;
+		else if (err < 0)
+			return err;
+
+		core->core_index = core_num++;
+		bus->nr_cores++;
+		pr_info("Core %d found: %s "
+			"(manuf 0x%03X, id 0x%03X, rev 0x%02X, class 0x%X)\n",
+			core->core_index, bcma_device_name(&core->id),
+			core->id.manuf, core->id.id, core->id.rev,
+			core->id.class);
+
+		list_add(&core->list, &bus->cores);
+		return 0;
+	}
+
+	return -ENODEV;
+}
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 08763e4..6bd7b7f 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -176,6 +176,7 @@ struct bcma_bus {
 	struct bcma_device *mapped_core;
 	struct list_head cores;
 	u8 nr_cores;
+	u8 init_done:1;
 
 	struct bcma_drv_cc drv_cc;
 	struct bcma_drv_pci drv_pci;
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index 083c3b6..837c176 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -258,6 +258,7 @@ struct bcma_drv_cc {
 	u32 status;
 	u32 capabilities;
 	u32 capabilities_ext;
+	u8 setup_done:1;
 	/* Fast Powerup Delay constant */
 	u16 fast_pwrup_delay;
 	struct bcma_chipcommon_pmu pmu;
-- 
1.7.4.1

