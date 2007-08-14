Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:50353
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765541AbXHNRA6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 13:00:58 -0400
Message-Id: <20070814165749.665285000@bu3sch.de>
References: <20070814165746.863593000@bu3sch.de>
Date: Tue, 14 Aug 2007 18:57:52 +0200
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: [patch 6/7] ssb: Add debugging for buspower
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Always make sure buspower is applied, when accessing the PCI MMIO space.
Otherwise this can result in crashes.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: ssb-merge-new/drivers/ssb/main.c
===================================================================
--- ssb-merge-new.orig/drivers/ssb/main.c	2007-08-13 17:33:23.000000000 +0200
+++ ssb-merge-new/drivers/ssb/main.c	2007-08-13 17:33:34.000000000 +0200
@@ -131,6 +131,9 @@ static void ssb_bus_suspend(struct ssb_b
 #ifdef CONFIG_SSB_DRIVER_PCICORE
 	bus->pcicore.setup_done = 0;
 #endif
+#ifdef CONFIG_SSB_DEBUG
+	bus->powered_up = 0;
+#endif
 }
 
 static int ssb_device_suspend(struct device *dev, pm_message_t state)
@@ -486,9 +489,14 @@ static int ssb_attach_queued_buses(void)
 		 * is too early in boot for embedded systems
 		 * (no udelay() available). So do it here in attach stage.
 		 */
+		err = ssb_bus_powerup(bus, 0);
+		if (err)
+			goto error;
 		ssb_pcicore_init(&bus->pcicore);
+		ssb_bus_may_powerdown(bus);
 
 		err = ssb_devices_register(bus);
+error:
 		if (err) {
 			drop_them_all = 1;
 			list_del(&bus->list);
@@ -586,11 +594,17 @@ static int ssb_bus_register(struct ssb_b
 		goto err_pci_exit;
 
 	/* Initialize basic system devices (if available) */
+	err = ssb_bus_powerup(bus, 0);
+	if (err)
+		goto err_pcmcia_exit;
 	ssb_chipcommon_init(&bus->chipco);
 	ssb_mipscore_init(&bus->mipscore);
 	err = ssb_fetch_invariants(bus, get_invariants);
-	if (err)
+	if (err) {
+		ssb_bus_may_powerdown(bus);
 		goto err_pcmcia_exit;
+	}
+	ssb_bus_may_powerdown(bus);
 
 	/* Queue it for attach.
 	 * See the comment at the ssb_is_early_boot definition. */
@@ -1012,24 +1026,27 @@ EXPORT_SYMBOL(ssb_dma_set_mask);
 int ssb_bus_may_powerdown(struct ssb_bus *bus)
 {
 	struct ssb_chipcommon *cc;
-	int err;
+	int err = 0;
 
 	/* On buses where more than one core may be working
 	 * at a time, we must not powerdown stuff if there are
 	 * still cores that may want to run. */
 	if (bus->bustype == SSB_BUSTYPE_SSB)
-		return 0;
+		goto out;
 
 	cc = &bus->chipco;
 	ssb_chipco_set_clockmode(cc, SSB_CLKMODE_SLOW);
 	err = ssb_pci_xtal(bus, SSB_GPIO_XTAL | SSB_GPIO_PLL, 0);
 	if (err)
 		goto error;
-
-	return 0;
+out:
+#ifdef CONFIG_SSB_DEBUG
+	bus->powered_up = 0;
+#endif
+	return err;
 error:
 	ssb_printk(KERN_ERR PFX "Bus powerdown failed\n");
-	return err;
+	goto out;
 }
 EXPORT_SYMBOL(ssb_bus_may_powerdown);
 
@@ -1046,6 +1063,9 @@ int ssb_bus_powerup(struct ssb_bus *bus,
 	mode = dynamic_pctl ? SSB_CLKMODE_DYNAMIC : SSB_CLKMODE_FAST;
 	ssb_chipco_set_clockmode(cc, mode);
 
+#ifdef CONFIG_SSB_DEBUG
+	bus->powered_up = 1;
+#endif
 	return 0;
 error:
 	ssb_printk(KERN_ERR PFX "Bus powerup failed\n");
Index: ssb-merge-new/drivers/ssb/pci.c
===================================================================
--- ssb-merge-new.orig/drivers/ssb/pci.c	2007-08-11 20:25:54.000000000 +0200
+++ ssb-merge-new/drivers/ssb/pci.c	2007-08-13 17:33:34.000000000 +0200
@@ -499,10 +499,34 @@ out:
 	return err;
 }
 
+#ifdef CONFIG_SSB_DEBUG
+static int ssb_pci_assert_buspower(struct ssb_bus *bus)
+{
+	if (likely(bus->powered_up))
+		return 0;
+
+	printk(KERN_ERR PFX "FATAL ERROR: Bus powered down "
+	       "while accessing PCI MMIO space\n");
+	if (bus->power_warn_count <= 10) {
+		bus->power_warn_count++;
+		dump_stack();
+	}
+
+	return -ENODEV;
+}
+#else /* DEBUG */
+static inline int ssb_pci_assert_buspower(struct ssb_bus *bus)
+{
+	return 0;
+}
+#endif /* DEBUG */
+
 static u16 ssb_pci_read16(struct ssb_device *dev, u16 offset)
 {
 	struct ssb_bus *bus = dev->bus;
 
+	if (unlikely(ssb_pci_assert_buspower(bus)))
+		return 0xFFFF;
 	if (unlikely(bus->mapped_device != dev)) {
 		if (unlikely(ssb_pci_switch_core(bus, dev)))
 			return 0xFFFF;
@@ -514,6 +538,8 @@ static u32 ssb_pci_read32(struct ssb_dev
 {
 	struct ssb_bus *bus = dev->bus;
 
+	if (unlikely(ssb_pci_assert_buspower(bus)))
+		return 0xFFFFFFFF;
 	if (unlikely(bus->mapped_device != dev)) {
 		if (unlikely(ssb_pci_switch_core(bus, dev)))
 			return 0xFFFFFFFF;
@@ -525,6 +551,8 @@ static void ssb_pci_write16(struct ssb_d
 {
 	struct ssb_bus *bus = dev->bus;
 
+	if (unlikely(ssb_pci_assert_buspower(bus)))
+		return;
 	if (unlikely(bus->mapped_device != dev)) {
 		if (unlikely(ssb_pci_switch_core(bus, dev)))
 			return;
@@ -536,6 +564,8 @@ static void ssb_pci_write32(struct ssb_d
 {
 	struct ssb_bus *bus = dev->bus;
 
+	if (unlikely(ssb_pci_assert_buspower(bus)))
+		return;
 	if (unlikely(bus->mapped_device != dev)) {
 		if (unlikely(ssb_pci_switch_core(bus, dev)))
 			return;
Index: ssb-merge-new/include/linux/ssb/ssb.h
===================================================================
--- ssb-merge-new.orig/include/linux/ssb/ssb.h	2007-08-11 20:26:09.000000000 +0200
+++ ssb-merge-new/include/linux/ssb/ssb.h	2007-08-13 17:33:34.000000000 +0200
@@ -319,8 +319,13 @@ struct ssb_bus {
 	/* Contents of the SPROM. */
 	struct ssb_sprom sprom;
 
-	/* Internal. */
+	/* Internal-only stuff follows. Do not touch. */
 	struct list_head list;
+#ifdef CONFIG_SSB_DEBUG
+	/* Is the bus already powered up? */
+	bool powered_up;
+	int power_warn_count;
+#endif /* DEBUG */
 };
 
 /* The initialization-invariants. */

-- 

