Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:42884 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758AbZKWTMg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 14:12:36 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ssb: Fix SPROM writing
Date: Mon, 23 Nov 2009 20:12:13 +0100
Cc: bcm43xx-dev@lists.berlios.de,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	Nicholas Betcher <nbetcher@gmail.com>
MIME-Version: 1.0
Message-Id: <200911232012.14182.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The SPROM writing routines were broken since we rewrote the suspend
handling on wireless devices, because SPROM writing depended on suspend.

This patch changes it and freezes devices with the driver remove(), probe()
callbacks instead. This also simplifies the whole logics a lot.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Tested on BCM4306


Index: wireless-testing/drivers/ssb/main.c
===================================================================
--- wireless-testing.orig/drivers/ssb/main.c	2009-11-06 21:45:29.000000000 +0100
+++ wireless-testing/drivers/ssb/main.c	2009-11-23 19:59:24.000000000 +0100
@@ -140,6 +140,19 @@ static void ssb_device_put(struct ssb_de
 		put_device(dev->dev);
 }
 
+static inline struct ssb_driver *ssb_driver_get(struct ssb_driver *drv)
+{
+	if (drv)
+		get_driver(&drv->drv);
+	return drv;
+}
+
+static inline void ssb_driver_put(struct ssb_driver *drv)
+{
+	if (drv)
+		put_driver(&drv->drv);
+}
+
 static int ssb_device_resume(struct device *dev)
 {
 	struct ssb_device *ssb_dev = dev_to_ssb_dev(dev);
@@ -210,90 +223,81 @@ int ssb_bus_suspend(struct ssb_bus *bus)
 EXPORT_SYMBOL(ssb_bus_suspend);
 
 #ifdef CONFIG_SSB_SPROM
-int ssb_devices_freeze(struct ssb_bus *bus)
+/** ssb_devices_freeze - Freeze all devices on the bus.
+ *
+ * After freezing no device driver will be handling a device
+ * on this bus anymore. ssb_devices_thaw() must be called after
+ * a successful freeze to reactivate the devices.
+ *
+ * @bus: The bus.
+ * @ctx: Context structure. Pass this to ssb_devices_thaw().
+ */
+int ssb_devices_freeze(struct ssb_bus *bus, struct ssb_freeze_context *ctx)
 {
-	struct ssb_device *dev;
-	struct ssb_driver *drv;
-	int err = 0;
-	int i;
-	pm_message_t state = PMSG_FREEZE;
+	struct ssb_device *sdev;
+	struct ssb_driver *sdrv;
+	unsigned int i;
+
+	memset(ctx, 0, sizeof(*ctx));
+	ctx->bus = bus;
+	SSB_WARN_ON(bus->nr_devices > ARRAY_SIZE(ctx->device_frozen));
 
-	/* First check that we are capable to freeze all devices. */
 	for (i = 0; i < bus->nr_devices; i++) {
-		dev = &(bus->devices[i]);
-		if (!dev->dev ||
-		    !dev->dev->driver ||
-		    !device_is_registered(dev->dev))
-			continue;
-		drv = drv_to_ssb_drv(dev->dev->driver);
-		if (!drv)
+		sdev = ssb_device_get(&bus->devices[i]);
+
+		if (!sdev->dev || !sdev->dev->driver ||
+		    !device_is_registered(sdev->dev)) {
+			ssb_device_put(sdev);
 			continue;
-		if (!drv->suspend) {
-			/* Nope, can't suspend this one. */
-			return -EOPNOTSUPP;
 		}
-	}
-	/* Now suspend all devices */
-	for (i = 0; i < bus->nr_devices; i++) {
-		dev = &(bus->devices[i]);
-		if (!dev->dev ||
-		    !dev->dev->driver ||
-		    !device_is_registered(dev->dev))
-			continue;
-		drv = drv_to_ssb_drv(dev->dev->driver);
-		if (!drv)
+		sdrv = ssb_driver_get(drv_to_ssb_drv(sdev->dev->driver));
+		if (!sdrv || SSB_WARN_ON(!sdrv->remove)) {
+			ssb_device_put(sdev);
 			continue;
-		err = drv->suspend(dev, state);
-		if (err) {
-			ssb_printk(KERN_ERR PFX "Failed to freeze device %s\n",
-				   dev_name(dev->dev));
-			goto err_unwind;
 		}
+		sdrv->remove(sdev);
+		ctx->device_frozen[i] = 1;
 	}
 
 	return 0;
-err_unwind:
-	for (i--; i >= 0; i--) {
-		dev = &(bus->devices[i]);
-		if (!dev->dev ||
-		    !dev->dev->driver ||
-		    !device_is_registered(dev->dev))
-			continue;
-		drv = drv_to_ssb_drv(dev->dev->driver);
-		if (!drv)
-			continue;
-		if (drv->resume)
-			drv->resume(dev);
-	}
-	return err;
 }
 
-int ssb_devices_thaw(struct ssb_bus *bus)
+/** ssb_devices_thaw - Unfreeze all devices on the bus.
+ *
+ * This will re-attach the device drivers and re-init the devices.
+ *
+ * @ctx: The context structure from ssb_devices_freeze()
+ */
+int ssb_devices_thaw(struct ssb_freeze_context *ctx)
 {
-	struct ssb_device *dev;
-	struct ssb_driver *drv;
-	int err;
-	int i;
+	struct ssb_bus *bus = ctx->bus;
+	struct ssb_device *sdev;
+	struct ssb_driver *sdrv;
+	unsigned int i;
+	int err, result = 0;
 
 	for (i = 0; i < bus->nr_devices; i++) {
-		dev = &(bus->devices[i]);
-		if (!dev->dev ||
-		    !dev->dev->driver ||
-		    !device_is_registered(dev->dev))
+		if (!ctx->device_frozen[i])
 			continue;
-		drv = drv_to_ssb_drv(dev->dev->driver);
-		if (!drv)
+		sdev = &bus->devices[i];
+
+		if (SSB_WARN_ON(!sdev->dev || !sdev->dev->driver))
 			continue;
-		if (SSB_WARN_ON(!drv->resume))
+		sdrv = drv_to_ssb_drv(sdev->dev->driver);
+		if (SSB_WARN_ON(!sdrv || !sdrv->probe))
 			continue;
-		err = drv->resume(dev);
+
+		err = sdrv->probe(sdev, &sdev->id);
 		if (err) {
 			ssb_printk(KERN_ERR PFX "Failed to thaw device %s\n",
-				   dev_name(dev->dev));
+				   dev_name(sdev->dev));
+			result = err;
 		}
+		ssb_driver_put(sdrv);
+		ssb_device_put(sdev);
 	}
 
-	return 0;
+	return result;
 }
 #endif /* CONFIG_SSB_SPROM */
 
Index: wireless-testing/drivers/ssb/sprom.c
===================================================================
--- wireless-testing.orig/drivers/ssb/sprom.c	2009-11-23 13:31:12.000000000 +0100
+++ wireless-testing/drivers/ssb/sprom.c	2009-11-23 14:24:57.000000000 +0100
@@ -90,6 +90,7 @@ ssize_t ssb_attr_sprom_store(struct ssb_
 	u16 *sprom;
 	int res = 0, err = -ENOMEM;
 	size_t sprom_size_words = bus->sprom_size;
+	struct ssb_freeze_context freeze;
 
 	sprom = kcalloc(bus->sprom_size, sizeof(u16), GFP_KERNEL);
 	if (!sprom)
@@ -111,18 +112,13 @@ ssize_t ssb_attr_sprom_store(struct ssb_
 	err = -ERESTARTSYS;
 	if (mutex_lock_interruptible(&bus->sprom_mutex))
 		goto out_kfree;
-	err = ssb_devices_freeze(bus);
-	if (err == -EOPNOTSUPP) {
-		ssb_printk(KERN_ERR PFX "SPROM write: Could not freeze devices. "
-			   "No suspend support. Is CONFIG_PM enabled?\n");
-		goto out_unlock;
-	}
+	err = ssb_devices_freeze(bus, &freeze);
 	if (err) {
 		ssb_printk(KERN_ERR PFX "SPROM write: Could not freeze all devices\n");
 		goto out_unlock;
 	}
 	res = sprom_write(bus, sprom);
-	err = ssb_devices_thaw(bus);
+	err = ssb_devices_thaw(&freeze);
 	if (err)
 		ssb_printk(KERN_ERR PFX "SPROM write: Could not thaw all devices\n");
 out_unlock:
Index: wireless-testing/drivers/ssb/ssb_private.h
===================================================================
--- wireless-testing.orig/drivers/ssb/ssb_private.h	2009-11-23 13:31:12.000000000 +0100
+++ wireless-testing/drivers/ssb/ssb_private.h	2009-11-23 14:08:16.000000000 +0100
@@ -176,13 +176,21 @@ extern const struct ssb_sprom *ssb_get_f
 
 /* core.c */
 extern u32 ssb_calc_clock_rate(u32 plltype, u32 n, u32 m);
-extern int ssb_devices_freeze(struct ssb_bus *bus);
-extern int ssb_devices_thaw(struct ssb_bus *bus);
 extern struct ssb_bus *ssb_pci_dev_to_bus(struct pci_dev *pdev);
 int ssb_for_each_bus_call(unsigned long data,
 			  int (*func)(struct ssb_bus *bus, unsigned long data));
 extern struct ssb_bus *ssb_pcmcia_dev_to_bus(struct pcmcia_device *pdev);
 
+struct ssb_freeze_context {
+	/* Pointer to the bus */
+	struct ssb_bus *bus;
+	/* Boolean list to indicate whether a device is frozen on this bus. */
+	bool device_frozen[SSB_MAX_NR_CORES];
+};
+extern int ssb_devices_freeze(struct ssb_bus *bus, struct ssb_freeze_context *ctx);
+extern int ssb_devices_thaw(struct ssb_freeze_context *ctx);
+
+
 
 /* b43_pci_bridge.c */
 #ifdef CONFIG_SSB_B43_PCI_BRIDGE

-- 
Greetings, Michael.
