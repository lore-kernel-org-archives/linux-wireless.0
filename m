Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:51129 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618AbZKTLQO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 06:16:14 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: [PATCH RFC] ssb: Generic SPROM override for devices without SPROM
Date: Fri, 20 Nov 2009 12:12:19 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	Oncaphillis <oncaphillis@snafu.de>,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200911201212.19588.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds a generic mechanism for overriding the SPROM mechanism
on devices without SPROM hardware.

There currently is a major problem with this:
It tries to deduce a MAC address from various hardware parameters. But
currently it will result in the same MAC address for machines of the same
type. Does somebody have an idea of some device-instance specific serial
number or something similar that could be hashed into the MAC?


Index: wireless-testing/drivers/ssb/pci.c
===================================================================
--- wireless-testing.orig/drivers/ssb/pci.c	2009-11-19 18:34:42.000000000 +0100
+++ wireless-testing/drivers/ssb/pci.c	2009-11-19 18:37:27.000000000 +0100
@@ -252,6 +252,9 @@ static int sprom_do_read(struct ssb_bus 
 {
 	int i;
 
+	if (!bus->sprom_size)
+		return -ENODEV;
+
 	for (i = 0; i < bus->sprom_size; i++)
 		sprom[i] = ioread16(bus->mmio + SSB_SPROM_BASE + (i * 2));
 
@@ -265,6 +268,9 @@ static int sprom_do_write(struct ssb_bus
 	u32 spromctl;
 	u16 size = bus->sprom_size;
 
+	if (!size)
+		return -ENODEV;
+
 	ssb_printk(KERN_NOTICE PFX "Writing SPROM. Do NOT turn off the power! Please stand by...\n");
 	err = pci_read_config_dword(pdev, SSB_SPROMCTL, &spromctl);
 	if (err)
@@ -616,10 +622,17 @@ static int sprom_extract(struct ssb_bus 
 static int ssb_pci_sprom_get(struct ssb_bus *bus,
 			     struct ssb_sprom *sprom)
 {
-	const struct ssb_sprom *fallback;
-	int err = -ENOMEM;
+	int err;
 	u16 *buf;
 
+	bus->sprom_size = 0;
+	err = ssb_find_sprom_override(bus, sprom);
+	if (!err) {
+		ssb_printk(KERN_INFO PFX "Overriding SPROM image\n");
+		return 0;
+	}
+
+	err = -ENOMEM;
 	buf = kcalloc(SSB_SPROMSIZE_WORDS_R123, sizeof(u16), GFP_KERNEL);
 	if (!buf)
 		goto out;
@@ -637,22 +650,12 @@ static int ssb_pci_sprom_get(struct ssb_
 		sprom_do_read(bus, buf);
 		err = sprom_check_crc(buf, bus->sprom_size);
 		if (err) {
-			/* All CRC attempts failed.
-			 * Maybe there is no SPROM on the device?
-			 * If we have a fallback, use that. */
-			fallback = ssb_get_fallback_sprom();
-			if (fallback) {
-				memcpy(sprom, fallback, sizeof(*sprom));
-				err = 0;
-				goto out_free;
-			}
 			ssb_printk(KERN_WARNING PFX "WARNING: Invalid"
 				   " SPROM CRC (corrupt SPROM)\n");
 		}
 	}
 	err = sprom_extract(bus, sprom, buf, bus->sprom_size);
 
-out_free:
 	kfree(buf);
 out:
 	return err;
Index: wireless-testing/drivers/ssb/sprom.c
===================================================================
--- wireless-testing.orig/drivers/ssb/sprom.c	2009-11-19 18:34:42.000000000 +0100
+++ wireless-testing/drivers/ssb/sprom.c	2009-11-19 18:37:27.000000000 +0100
@@ -13,8 +13,13 @@
 
 #include "ssb_private.h"
 
+#include <linux/list.h>
+#include <linux/spinlock.h>
 
-static const struct ssb_sprom *fallback_sprom;
+
+/* List of registered SPROM overrides. */
+static LIST_HEAD(override_list);
+static DEFINE_SPINLOCK(override_list_lock);
 
 
 static int sprom2hex(const u16 *sprom, char *buf, size_t buf_len,
@@ -135,35 +140,34 @@ out:
 	return err ? err : count;
 }
 
-/**
- * ssb_arch_set_fallback_sprom - Set a fallback SPROM for use if no SPROM is found.
- *
- * @sprom: The SPROM data structure to register.
- *
- * With this function the architecture implementation may register a fallback
- * SPROM data structure. The fallback is only used for PCI based SSB devices,
- * where no valid SPROM can be found in the shadow registers.
- *
- * This function is useful for weird architectures that have a half-assed SSB device
- * hardwired to their PCI bus.
- *
- * Note that it does only work with PCI attached SSB devices. PCMCIA devices currently
- * don't use this fallback.
- * Architectures must provide the SPROM for native SSB devices anyway,
- * so the fallback also isn't used for native devices.
- *
- * This function is available for architecture code, only. So it is not exported.
- */
-int ssb_arch_set_fallback_sprom(const struct ssb_sprom *sprom)
-{
-	if (fallback_sprom)
-		return -EEXIST;
-	fallback_sprom = sprom;
+void ssb_register_sprom_override(struct ssb_sprom_override *ovr)
+{
+	spin_lock(&override_list_lock);
+	list_add_tail(&ovr->list, &override_list);
+	spin_unlock(&override_list_lock);
+}
+EXPORT_SYMBOL(ssb_register_sprom_override);
 
-	return 0;
+void ssb_unregister_sprom_override(struct ssb_sprom_override *ovr)
+{
+	spin_lock(&override_list_lock);
+	list_del(&ovr->list);
+	spin_unlock(&override_list_lock);
 }
+EXPORT_SYMBOL(ssb_unregister_sprom_override);
 
-const struct ssb_sprom *ssb_get_fallback_sprom(void)
+int ssb_find_sprom_override(struct ssb_bus *bus, struct ssb_sprom *buf)
 {
-	return fallback_sprom;
+	struct ssb_sprom_override *ovr;
+	int err = -ENODEV;
+
+	spin_lock(&override_list_lock);
+	list_for_each_entry(ovr, &override_list, list) {
+		err = ovr->probe(bus, buf);
+		if (!err)
+			break;
+	}
+	spin_unlock(&override_list_lock);
+
+	return err;
 }
Index: wireless-testing/drivers/ssb/ssb_private.h
===================================================================
--- wireless-testing.orig/drivers/ssb/ssb_private.h	2009-11-19 18:34:42.000000000 +0100
+++ wireless-testing/drivers/ssb/ssb_private.h	2009-11-19 18:37:27.000000000 +0100
@@ -171,7 +171,7 @@ ssize_t ssb_attr_sprom_store(struct ssb_
 			     const char *buf, size_t count,
 			     int (*sprom_check_crc)(const u16 *sprom, size_t size),
 			     int (*sprom_write)(struct ssb_bus *bus, const u16 *sprom));
-extern const struct ssb_sprom *ssb_get_fallback_sprom(void);
+extern int ssb_find_sprom_override(struct ssb_bus *bus, struct ssb_sprom *buf);
 
 
 /* core.c */
Index: wireless-testing/include/linux/ssb/ssb.h
===================================================================
--- wireless-testing.orig/include/linux/ssb/ssb.h	2009-11-19 18:34:42.000000000 +0100
+++ wireless-testing/include/linux/ssb/ssb.h	2009-11-19 18:37:27.000000000 +0100
@@ -394,9 +394,20 @@ extern int ssb_bus_sdiobus_register(stru
 
 extern void ssb_bus_unregister(struct ssb_bus *bus);
 
-/* Set a fallback SPROM.
- * See kdoc at the function definition for complete documentation. */
-extern int ssb_arch_set_fallback_sprom(const struct ssb_sprom *sprom);
+/** struct ssb_sprom_override - SPROM override handler
+ * @probe: Callback function used to probe for a SPROM override.
+ *	Puts the override image into "buf" and returns 0.
+ *	If there's no need to override the image, nonzero is returned.
+ *	This callback runs in atomic context.
+ * @list: Used internally in ssb. Do not use in the device driver.
+ */
+struct ssb_sprom_override {
+	int (*probe)(struct ssb_bus *bus, struct ssb_sprom *buf);
+	struct list_head list;
+};
+
+extern void ssb_register_sprom_override(struct ssb_sprom_override *ovr);
+extern void ssb_unregister_sprom_override(struct ssb_sprom_override *ovr);
 
 /* Suspend a SSB bus.
  * Call this from the parent bus suspend routine. */
Index: wireless-testing/drivers/ssb/b43_pci_bridge.c
===================================================================
--- wireless-testing.orig/drivers/ssb/b43_pci_bridge.c	2009-11-19 18:34:42.000000000 +0100
+++ wireless-testing/drivers/ssb/b43_pci_bridge.c	2009-11-20 12:04:09.000000000 +0100
@@ -5,13 +5,15 @@
  * because of its small size we include it in the SSB core
  * instead of creating a standalone module.
  *
- * Copyright 2007  Michael Buesch <mb@bu3sch.de>
+ * Copyright 2007-2009  Michael Buesch <mb@bu3sch.de>
  *
  * Licensed under the GNU/GPL. See COPYING for details.
  */
 
 #include <linux/pci.h>
 #include <linux/ssb/ssb.h>
+#include <linux/etherdevice.h>
+#include <linux/jhash.h>
 
 #include "ssb_private.h"
 
@@ -36,6 +38,76 @@ static const struct pci_device_id b43_pc
 };
 MODULE_DEVICE_TABLE(pci, b43_pci_bridge_tbl);
 
+
+static void pcidev_deduce_mac_address(struct pci_dev *pdev,
+				      struct ssb_sprom *sprom,
+				      const char *oui)
+{
+	u32 hash = 0x63E72B6D;
+
+	hash = jhash(&pdev->device, sizeof(pdev->device), hash);
+	hash = jhash(&pdev->subsystem_device, sizeof(pdev->subsystem_device), hash);
+	hash = jhash(&pdev->devfn, sizeof(pdev->devfn), hash);
+	//TODO: Need machine specific seed
+
+	sprom->il0mac[3] = hash;
+	sprom->il0mac[4] = hash >> 8;
+	sprom->il0mac[5] = hash >> 16;
+	memcpy(sprom->il0mac, oui, 3);
+	memcpy(sprom->et0mac, sprom->il0mac, ETH_ALEN);
+	memcpy(sprom->et1mac, sprom->il0mac, ETH_ALEN);
+}
+
+#define IS_PDEV(pdev, _vendor, _device, _subvendor, _subdevice)		( \
+	(pdev->vendor == PCI_VENDOR_ID_##_vendor) &&			\
+	(pdev->device == _device) &&					\
+	(pdev->subsystem_vendor == PCI_VENDOR_ID_##_subvendor) &&	\
+	(pdev->subsystem_device == _subdevice)				)
+
+static int b43_sprom_override_probe(struct ssb_bus *bus,
+				    struct ssb_sprom *sprom)
+{
+	struct pci_dev *pdev;
+
+	if (bus->bustype != SSB_BUSTYPE_PCI)
+		return -ENODEV;
+	pdev = bus->host_pci;
+
+	if (IS_PDEV(pdev, BROADCOM, 0x4315, FOXCONN, 0xE01B)) {
+		static const struct ssb_sprom image = {
+			.revision		= 0x02,
+			.board_rev		= 0x17,
+			.country_code		= 0x0,
+			.ant_available_bg 	= 0x3,
+			.pa0b0			= 0x15ae,
+			.pa0b1			= 0xfa85,
+			.pa0b2			= 0xfe8d,
+			.pa1b0			= 0xffff,
+			.pa1b1			= 0xffff,
+			.pa1b2			= 0xffff,
+			.gpio0			= 0xff,
+			.gpio1			= 0xff,
+			.gpio2			= 0xff,
+			.gpio3			= 0xff,
+			.maxpwr_bg		= 0x004c,
+			.itssi_bg		= 0x00,
+			.boardflags_lo		= 0x2848,
+			.boardflags_hi		= 0x0000,
+		};//FIXME This image is not the right one.
+
+		memcpy(sprom, &image, sizeof(*sprom));
+		pcidev_deduce_mac_address(pdev, sprom, "\x00\x15\x58");
+
+		return 0;
+	}
+
+	return -ENODEV;
+}
+
+static struct ssb_sprom_override b43_sprom_override = {
+	.probe		= b43_sprom_override_probe,
+};
+
 static struct pci_driver b43_pci_bridge_driver = {
 	.name = "b43-pci-bridge",
 	.id_table = b43_pci_bridge_tbl,
@@ -44,10 +116,20 @@ static struct pci_driver b43_pci_bridge_
 
 int __init b43_pci_ssb_bridge_init(void)
 {
-	return ssb_pcihost_register(&b43_pci_bridge_driver);
+	int err;
+
+	ssb_register_sprom_override(&b43_sprom_override);
+	err = ssb_pcihost_register(&b43_pci_bridge_driver);
+	if (err) {
+		ssb_unregister_sprom_override(&b43_sprom_override);
+		return err;
+	}
+
+	return 0;
 }
 
 void __exit b43_pci_ssb_bridge_exit(void)
 {
 	ssb_pcihost_unregister(&b43_pci_bridge_driver);
+	ssb_unregister_sprom_override(&b43_sprom_override);
 }

-- 
Greetings, Michael.
