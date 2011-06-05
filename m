Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33006 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755834Ab1FEWIO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jun 2011 18:08:14 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linux-wireless@vger.kernel.org, linux-mips@linux-mips.org
Cc: zajec5@gmail.com, mb@bu3sch.de, george@znau.edu.ua,
	arend@broadcom.com, b43-dev@lists.infradead.org,
	bernhardloos@googlemail.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC][PATCH 01/10] bcma: Use array to store cores.
Date: Mon,  6 Jun 2011 00:07:29 +0200
Message-Id: <1307311658-15853-2-git-send-email-hauke@hauke-m.de> (sfid-20110606_000821_318423_EF95F49F)
In-Reply-To: <1307311658-15853-1-git-send-email-hauke@hauke-m.de>
References: <1307311658-15853-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using bcma on a embedded device it is initialized very early at
boot. We have to do so as the cpu and interrupt management and all
other devices are attached to this bus and it has to be initialized so
early. In that stage we can not allocate memory or sleep, just use the
memory on the stack and in the text segment as the kernel is not
initialized far enough. This patch removed the kzallocs from the scan
code. Some earlier version of the bcma implementation and the normal
ssb implementation are doing it like this.
The __bcma_dev_wrapper struct is used as the container for the device
struct as bcma_device will be too big if it includes struct device.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/main.c       |   86 ++++++++++++++++++++++++++++----------------
 drivers/bcma/scan.c       |   58 +++++++++++-------------------
 include/linux/bcma/bcma.h |   16 ++++++--
 3 files changed, 89 insertions(+), 71 deletions(-)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index a2f6b18..b0e7f5e 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -17,23 +17,27 @@ static int bcma_device_remove(struct device *dev);
 
 static ssize_t manuf_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
-	struct bcma_device *core = container_of(dev, struct bcma_device, dev);
-	return sprintf(buf, "0x%03X\n", core->id.manuf);
+	struct __bcma_dev_wrapper *wrapper = container_of(dev,
+						struct __bcma_dev_wrapper, dev);
+	return sprintf(buf, "0x%03X\n", wrapper->core->id.manuf);
 }
 static ssize_t id_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
-	struct bcma_device *core = container_of(dev, struct bcma_device, dev);
-	return sprintf(buf, "0x%03X\n", core->id.id);
+	struct __bcma_dev_wrapper *wrapper = container_of(dev,
+						struct __bcma_dev_wrapper, dev);
+	return sprintf(buf, "0x%03X\n", wrapper->core->id.id);
 }
 static ssize_t rev_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
-	struct bcma_device *core = container_of(dev, struct bcma_device, dev);
-	return sprintf(buf, "0x%02X\n", core->id.rev);
+	struct __bcma_dev_wrapper *wrapper = container_of(dev,
+						struct __bcma_dev_wrapper, dev);
+	return sprintf(buf, "0x%02X\n", wrapper->core->id.rev);
 }
 static ssize_t class_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
-	struct bcma_device *core = container_of(dev, struct bcma_device, dev);
-	return sprintf(buf, "0x%X\n", core->id.class);
+	struct __bcma_dev_wrapper *wrapper = container_of(dev,
+						struct __bcma_dev_wrapper, dev);
+	return sprintf(buf, "0x%X\n", wrapper->core->id.class);
 }
 static struct device_attribute bcma_device_attrs[] = {
 	__ATTR_RO(manuf),
@@ -53,27 +57,30 @@ static struct bus_type bcma_bus_type = {
 
 static struct bcma_device *bcma_find_core(struct bcma_bus *bus, u16 coreid)
 {
-	struct bcma_device *core;
-
-	list_for_each_entry(core, &bus->cores, list) {
-		if (core->id.id == coreid)
-			return core;
+	u8 i;
+	for (i = 0; i < bus->nr_cores; i++) {
+		if (bus->cores[i].id.id == coreid)
+			return &bus->cores[i];
 	}
 	return NULL;
 }
 
 static void bcma_release_core_dev(struct device *dev)
 {
-	struct bcma_device *core = container_of(dev, struct bcma_device, dev);
-	kfree(core);
+	struct __bcma_dev_wrapper *wrapper = container_of(dev,
+						struct __bcma_dev_wrapper, dev);
+	kfree(wrapper);
 }
 
 static int bcma_register_cores(struct bcma_bus *bus)
 {
 	struct bcma_device *core;
-	int err, dev_id = 0;
+	struct __bcma_dev_wrapper *wrapper;
+	int i, err, dev_id = 0;
+
+	for (i = 0; i < bus->nr_cores; i++) {
+		core = &(bus->cores[i]);
 
-	list_for_each_entry(core, &bus->cores, list) {
 		/* We support that cores ourself */
 		switch (core->id.id) {
 		case BCMA_CORE_CHIPCOMMON:
@@ -82,28 +89,37 @@ static int bcma_register_cores(struct bcma_bus *bus)
 			continue;
 		}
 
-		core->dev.release = bcma_release_core_dev;
-		core->dev.bus = &bcma_bus_type;
-		dev_set_name(&core->dev, "bcma%d:%d", 0/*bus->num*/, dev_id);
+		wrapper = kzalloc(sizeof(*wrapper), GFP_KERNEL);
+		if (!wrapper) {
+			pr_err("Could not allocate wrapper for core 0x%03X\n",
+			       core->id.id);
+			continue;
+		}
+
+		wrapper->core = core;
+		wrapper->dev.release = bcma_release_core_dev;
+		wrapper->dev.bus = &bcma_bus_type;
+		dev_set_name(&wrapper->dev, "bcma%d:%d", 0/*bus->num*/, dev_id);
 
 		switch (bus->hosttype) {
 		case BCMA_HOSTTYPE_PCI:
-			core->dev.parent = &bus->host_pci->dev;
-			core->dma_dev = &bus->host_pci->dev;
-			core->irq = bus->host_pci->irq;
+			wrapper->dev.parent = &bus->host_pci->dev;
+			wrapper->core->dma_dev = &bus->host_pci->dev;
+			wrapper->core->irq = bus->host_pci->irq;
 			break;
 		case BCMA_HOSTTYPE_NONE:
 		case BCMA_HOSTTYPE_SDIO:
 			break;
 		}
 
-		err = device_register(&core->dev);
+		err = device_register(&wrapper->dev);
 		if (err) {
 			pr_err("Could not register dev for core 0x%03X\n",
 			       core->id.id);
+			kfree(wrapper);
 			continue;
 		}
-		core->dev_registered = true;
+		core->dev = &wrapper->dev;
 		dev_id++;
 	}
 
@@ -113,10 +129,12 @@ static int bcma_register_cores(struct bcma_bus *bus)
 static void bcma_unregister_cores(struct bcma_bus *bus)
 {
 	struct bcma_device *core;
+	int i;
 
-	list_for_each_entry(core, &bus->cores, list) {
-		if (core->dev_registered)
-			device_unregister(&core->dev);
+	for (i = 0; i < bus->nr_cores; i++) {
+		core = &(bus->cores[i]);
+		if (core->dev)
+			device_unregister(core->dev);
 	}
 }
 
@@ -179,7 +197,9 @@ EXPORT_SYMBOL_GPL(bcma_driver_unregister);
 
 static int bcma_bus_match(struct device *dev, struct device_driver *drv)
 {
-	struct bcma_device *core = container_of(dev, struct bcma_device, dev);
+	struct __bcma_dev_wrapper *wrapper = container_of(dev,
+						struct __bcma_dev_wrapper, dev);
+	struct bcma_device *core = wrapper->core;
 	struct bcma_driver *adrv = container_of(drv, struct bcma_driver, drv);
 	const struct bcma_device_id *cid = &core->id;
 	const struct bcma_device_id *did;
@@ -196,7 +216,9 @@ static int bcma_bus_match(struct device *dev, struct device_driver *drv)
 
 static int bcma_device_probe(struct device *dev)
 {
-	struct bcma_device *core = container_of(dev, struct bcma_device, dev);
+	struct __bcma_dev_wrapper *wrapper = container_of(dev,
+						struct __bcma_dev_wrapper, dev);
+	struct bcma_device *core = wrapper->core;
 	struct bcma_driver *adrv = container_of(dev->driver, struct bcma_driver,
 					       drv);
 	int err = 0;
@@ -209,7 +231,9 @@ static int bcma_device_probe(struct device *dev)
 
 static int bcma_device_remove(struct device *dev)
 {
-	struct bcma_device *core = container_of(dev, struct bcma_device, dev);
+	struct __bcma_dev_wrapper *wrapper = container_of(dev,
+						struct __bcma_dev_wrapper, dev);
+	struct bcma_device *core = wrapper->core;
 	struct bcma_driver *adrv = container_of(dev->driver, struct bcma_driver,
 					       drv);
 
diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index 40d7dcc..70b39f7 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -211,9 +211,6 @@ int bcma_bus_scan(struct bcma_bus *bus)
 	s32 tmp;
 	u8 i, j;
 
-	int err;
-
-	INIT_LIST_HEAD(&bus->cores);
 	bus->nr_cores = 0;
 
 	bcma_scan_switch_core(bus, BCMA_ADDR_BASE);
@@ -230,11 +227,8 @@ int bcma_bus_scan(struct bcma_bus *bus)
 	bcma_scan_switch_core(bus, erombase);
 
 	while (eromptr < eromend) {
-		struct bcma_device *core = kzalloc(sizeof(*core), GFP_KERNEL);
-		if (!core)
-			return -ENOMEM;
-		INIT_LIST_HEAD(&core->list);
-		core->bus = bus;
+		struct bcma_device core = { };
+		core.bus = bus;
 
 		/* get CIs */
 		cia = bcma_erom_get_ci(bus, &eromptr);
@@ -242,27 +236,24 @@ int bcma_bus_scan(struct bcma_bus *bus)
 			bcma_erom_push_ent(&eromptr);
 			if (bcma_erom_is_end(bus, &eromptr))
 				break;
-			err= -EILSEQ;
-			goto out;
+			return -EILSEQ;
 		}
 		cib = bcma_erom_get_ci(bus, &eromptr);
-		if (cib < 0) {
-			err= -EILSEQ;
-			goto out;
-		}
+		if (cib < 0)
+			return -EILSEQ;
 
 		/* parse CIs */
-		core->id.class = (cia & SCAN_CIA_CLASS) >> SCAN_CIA_CLASS_SHIFT;
-		core->id.id = (cia & SCAN_CIA_ID) >> SCAN_CIA_ID_SHIFT;
-		core->id.manuf = (cia & SCAN_CIA_MANUF) >> SCAN_CIA_MANUF_SHIFT;
+		core.id.class = (cia & SCAN_CIA_CLASS) >> SCAN_CIA_CLASS_SHIFT;
+		core.id.id = (cia & SCAN_CIA_ID) >> SCAN_CIA_ID_SHIFT;
+		core.id.manuf = (cia & SCAN_CIA_MANUF) >> SCAN_CIA_MANUF_SHIFT;
 		ports[0] = (cib & SCAN_CIB_NMP) >> SCAN_CIB_NMP_SHIFT;
 		ports[1] = (cib & SCAN_CIB_NSP) >> SCAN_CIB_NSP_SHIFT;
 		wrappers[0] = (cib & SCAN_CIB_NMW) >> SCAN_CIB_NMW_SHIFT;
 		wrappers[1] = (cib & SCAN_CIB_NSW) >> SCAN_CIB_NSW_SHIFT;
-		core->id.rev = (cib & SCAN_CIB_REV) >> SCAN_CIB_REV_SHIFT;
+		core.id.rev = (cib & SCAN_CIB_REV) >> SCAN_CIB_REV_SHIFT;
 
-		if (((core->id.manuf == BCMA_MANUF_ARM) &&
-		     (core->id.id == 0xFFF)) ||
+		if (((core.id.manuf == BCMA_MANUF_ARM) &&
+		     (core.id.id == 0xFFF)) ||
 		    (ports[1] == 0)) {
 			bcma_erom_skip_component(bus, &eromptr);
 			continue;
@@ -285,10 +276,8 @@ int bcma_bus_scan(struct bcma_bus *bus)
 		/* get & parse master ports */
 		for (i = 0; i < ports[0]; i++) {
 			u32 mst_port_d = bcma_erom_get_mst_port(bus, &eromptr);
-			if (mst_port_d < 0) {
-				err= -EILSEQ;
-				goto out;
-			}
+			if (mst_port_d < 0)
+				return -EILSEQ;
 		}
 
 		/* get & parse slave ports */
@@ -303,7 +292,7 @@ int bcma_bus_scan(struct bcma_bus *bus)
 					break;
 				} else {
 					if (i == 0 && j == 0)
-						core->addr = tmp;
+						core.addr = tmp;
 				}
 			}
 		}
@@ -320,7 +309,7 @@ int bcma_bus_scan(struct bcma_bus *bus)
 					break;
 				} else {
 					if (i == 0 && j == 0)
-						core->wrap = tmp;
+						core.wrap = tmp;
 				}
 			}
 		}
@@ -338,22 +327,19 @@ int bcma_bus_scan(struct bcma_bus *bus)
 					break;
 				} else {
 					if (wrappers[0] == 0 && !i && !j)
-						core->wrap = tmp;
+						core.wrap = tmp;
 				}
 			}
 		}
 
 		pr_info("Core %d found: %s "
 			"(manuf 0x%03X, id 0x%03X, rev 0x%02X, class 0x%X)\n",
-			bus->nr_cores, bcma_device_name(&core->id),
-			core->id.manuf, core->id.id, core->id.rev,
-			core->id.class);
-
-		core->core_index = bus->nr_cores++;
-		list_add(&core->list, &bus->cores);
-		continue;
-out:
-		return err;
+			bus->nr_cores, bcma_device_name(&core.id),
+			core.id.manuf, core.id.id, core.id.rev,
+			core.id.class);
+
+		core.core_index = bus->nr_cores;
+		bus->cores[bus->nr_cores++] = core;
 	}
 
 	return 0;
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 27a27a7..3dc5302 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -118,14 +118,23 @@ struct bcma_host_ops {
 
 #define BCMA_MAX_NR_CORES		16
 
+/* 1) It is not allowed to put struct device statically in bcma_device
+ * 2) We can not just use pointer to struct device because we use container_of
+ * 3) We do not have pointer to struct bcma_device in struct device
+ * Solution: use such a dummy wrapper
+ */
+struct __bcma_dev_wrapper {
+	struct device dev;
+	struct bcma_device *core;
+};
+
 struct bcma_device {
 	struct bcma_bus *bus;
 	struct bcma_device_id id;
 
-	struct device dev;
+	struct device *dev;
 	struct device *dma_dev;
 	unsigned int irq;
-	bool dev_registered;
 
 	u8 core_index;
 
@@ -133,7 +142,6 @@ struct bcma_device {
 	u32 wrap;
 
 	void *drvdata;
-	struct list_head list;
 };
 
 static inline void *bcma_get_drvdata(struct bcma_device *core)
@@ -182,7 +190,7 @@ struct bcma_bus {
 	struct bcma_chipinfo chipinfo;
 
 	struct bcma_device *mapped_core;
-	struct list_head cores;
+	struct bcma_device cores[BCMA_MAX_NR_CORES];
 	u8 nr_cores;
 
 	struct bcma_drv_cc drv_cc;
-- 
1.7.4.1

