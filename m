Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:41809 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754133AbZB0QBA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 11:01:00 -0500
From: Michael Buesch <mb@bu3sch.de>
To: linville@tuxdriver.com
Date: Fri, 27 Feb 2009 16:59:05 +0100
Cc: linux-wireless@vger.kernel.org,
	Florian Fainelli <florian@openwrt.org>
MIME-Version: 1.0
Message-Id: <200902271659.06122.mb@bu3sch.de> (sfid-20090227_170113_592142_C84B6866)
Subject: [PATCH] ssb: Add SPROM fallback support
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds SSB functionality to register a fallback SPROM image from the
architecture setup code.

Weird architectures exist that have half-assed SSB devices without SPROM attached to
their PCI busses. The architecture can register a fallback SPROM image that is
used if no SPROM is found on the SSB device.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: Florian Fainelli <florian@openwrt.org>

---

John, please merge in the next feature window.
The actual user of this interface will be merged through the mips tree.


Index: wireless-testing/drivers/ssb/pci.c
===================================================================
--- wireless-testing.orig/drivers/ssb/pci.c	2009-01-23 17:08:11.000000000 +0100
+++ wireless-testing/drivers/ssb/pci.c	2009-02-27 16:47:16.000000000 +0100
@@ -564,6 +564,7 @@ static int sprom_extract(struct ssb_bus 
 static int ssb_pci_sprom_get(struct ssb_bus *bus,
 			     struct ssb_sprom *sprom)
 {
+	const struct ssb_sprom *fallback;
 	int err = -ENOMEM;
 	u16 *buf;
 
@@ -583,12 +584,23 @@ static int ssb_pci_sprom_get(struct ssb_
 		bus->sprom_size = SSB_SPROMSIZE_WORDS_R4;
 		sprom_do_read(bus, buf);
 		err = sprom_check_crc(buf, bus->sprom_size);
-		if (err)
+		if (err) {
+			/* All CRC attempts failed.
+			 * Maybe there is no SPROM on the device?
+			 * If we have a fallback, use that. */
+			fallback = ssb_get_fallback_sprom();
+			if (fallback) {
+				memcpy(sprom, fallback, sizeof(*sprom));
+				err = 0;
+				goto out_free;
+			}
 			ssb_printk(KERN_WARNING PFX "WARNING: Invalid"
 				   " SPROM CRC (corrupt SPROM)\n");
+		}
 	}
 	err = sprom_extract(bus, sprom, buf, bus->sprom_size);
 
+out_free:
 	kfree(buf);
 out:
 	return err;
Index: wireless-testing/drivers/ssb/sprom.c
===================================================================
--- wireless-testing.orig/drivers/ssb/sprom.c	2008-12-26 22:47:35.000000000 +0100
+++ wireless-testing/drivers/ssb/sprom.c	2009-02-27 16:47:16.000000000 +0100
@@ -14,6 +14,9 @@
 #include "ssb_private.h"
 
 
+static const struct ssb_sprom *fallback_sprom;
+
+
 static int sprom2hex(const u16 *sprom, char *buf, size_t buf_len,
 		     size_t sprom_size_words)
 {
@@ -131,3 +134,36 @@ out:
 		return res;
 	return err ? err : count;
 }
+
+/**
+ * ssb_arch_set_fallback_sprom - Set a fallback SPROM for use if no SPROM is found.
+ *
+ * @sprom: The SPROM data structure to register.
+ *
+ * With this function the architecture implementation may register a fallback
+ * SPROM data structure. The fallback is only used for PCI based SSB devices,
+ * where no valid SPROM can be found in the shadow registers.
+ *
+ * This function is useful for weird architectures that have a half-assed SSB device
+ * hardwired to their PCI bus.
+ *
+ * Note that it does only work with PCI attached SSB devices. PCMCIA devices currently
+ * don't use this fallback.
+ * Architectures must provide the SPROM for native SSB devices anyway,
+ * so the fallback also isn't used for native devices.
+ *
+ * This function is available for architecture code, only. So it is not exported.
+ */
+int ssb_arch_set_fallback_sprom(const struct ssb_sprom *sprom)
+{
+	if (fallback_sprom)
+		return -EEXIST;
+	fallback_sprom = sprom;
+
+	return 0;
+}
+
+const struct ssb_sprom *ssb_get_fallback_sprom(void)
+{
+	return fallback_sprom;
+}
Index: wireless-testing/drivers/ssb/ssb_private.h
===================================================================
--- wireless-testing.orig/drivers/ssb/ssb_private.h	2008-12-26 22:47:35.000000000 +0100
+++ wireless-testing/drivers/ssb/ssb_private.h	2009-02-27 16:47:16.000000000 +0100
@@ -131,6 +131,7 @@ ssize_t ssb_attr_sprom_store(struct ssb_
 			     const char *buf, size_t count,
 			     int (*sprom_check_crc)(const u16 *sprom, size_t size),
 			     int (*sprom_write)(struct ssb_bus *bus, const u16 *sprom));
+extern const struct ssb_sprom *ssb_get_fallback_sprom(void);
 
 
 /* core.c */
Index: wireless-testing/include/linux/ssb/ssb.h
===================================================================
--- wireless-testing.orig/include/linux/ssb/ssb.h	2009-02-04 19:45:14.000000000 +0100
+++ wireless-testing/include/linux/ssb/ssb.h	2009-02-27 16:47:16.000000000 +0100
@@ -339,6 +339,10 @@ extern int ssb_bus_pcmciabus_register(st
 
 extern void ssb_bus_unregister(struct ssb_bus *bus);
 
+/* Set a fallback SPROM.
+ * See kdoc at the function definition for complete documentation. */
+extern int ssb_arch_set_fallback_sprom(const struct ssb_sprom *sprom);
+
 /* Suspend a SSB bus.
  * Call this from the parent bus suspend routine. */
 extern int ssb_bus_suspend(struct ssb_bus *bus);


-- 
Greetings, Michael.
