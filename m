Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:65106 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab0CUXWt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Mar 2010 19:22:49 -0400
Date: Sun, 21 Mar 2010 18:22:45 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Michael Buesch <mb@bu3sch.de>,
	John W Linville <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH V2] ssb: Implement virtual SPROM on disk
Message-ID: <4ba6aa45.z5Wso1NMth9eMeFG%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some recent BCM43XX devices lack an on-board SPROM. The pertinent data
from the SPROM could be included in the kernel; however, this presents
a problem in the generation of a unique, reproducible MAC address. The
solution has been to create a utility that generates a virtual SPROM
image with a random MAC address. This image is stored in the firmware
area, and loaded using the asyncronous firmware load facility.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Michael,

I think this patch eliminates the need for the fallback sprom code; however,
I have not touched that facility yet.

Larry
---
V2 - make virstual SPROM loading asynchronous.

Index: wireless-testing/drivers/ssb/pci.c
===================================================================
--- wireless-testing.orig/drivers/ssb/pci.c
+++ wireless-testing/drivers/ssb/pci.c
@@ -19,6 +19,7 @@
 #include <linux/ssb/ssb_regs.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
+#include <linux/firmware.h>
 
 #include "ssb_private.h"
 
@@ -613,6 +614,53 @@ static int sprom_extract(struct ssb_bus
 	return 0;
 }
 
+static void ssb_vsprom_load_failed(void)
+{
+	printk(KERN_ERR "ssb: The BCM43XX device does not have an "
+	       "SPROM built in, and the virtual SPROM file is not"
+	       " available.\n");
+	printk(KERN_ERR "ssb: Please go to "
+	       "http://wireless.kernel.org/en/users/Drivers/b43 "
+	       "and download the utility to create the file.\n");
+}
+
+static void ssb_get_vsprom(const struct firmware *fw, void *context)
+{
+	/* Second part of asynchronous firmware load */
+	int i;
+	u16 *buf;
+	size_t size = SSB_SPROMSIZE_WORDS_R4;
+	struct ssb_bus *bus = context;
+
+	if (!fw) {
+		ssb_vsprom_load_failed();
+		return;
+	}
+	buf = kcalloc(size, sizeof(u16), GFP_KERNEL);
+	if (!buf) {
+		printk(KERN_ERR "ssb: no memory for virtual sprom\n");
+		goto out;
+	}
+	if (fw->size != size * 2) {
+		printk(KERN_ERR "ssb: The virtual SPROM file has the wrong"
+		       " size\n");
+		goto out_free;
+	}
+	for (i = 0; i < size; i++)
+		buf[i] = fw->data[2 * i + 1] << 8 | fw->data[2 * i];
+	if(sprom_check_crc(buf, size)) {
+		printk(KERN_ERR "ssb: Invalid CRC for virtual SPROM\n");
+		goto out_free;
+	}
+	sprom_extract(bus, &bus->sprom, buf, size);
+	printk(KERN_DEBUG "ssb: revision %d\n", bus->sprom.revision);
+
+out_free:
+	kfree(buf);
+out:
+	release_firmware(fw);
+}
+
 static int ssb_pci_sprom_get(struct ssb_bus *bus,
 			     struct ssb_sprom *sprom)
 {
@@ -620,8 +668,17 @@ static int ssb_pci_sprom_get(struct ssb_
 	int err = -ENOMEM;
 	u16 *buf;
 
-	if (!ssb_is_sprom_available(bus))
-		return -ENODEV;
+	if (!ssb_is_sprom_available(bus)) {
+		/* This device has no SPROM. Try for a virtual version */
+		err = request_firmware_nowait(THIS_MODULE,
+			FW_ACTION_HOTPLUG, "ssb/vsprom_image",
+			&bus->host_pci->dev, GFP_KERNEL, bus, ssb_get_vsprom);
+		if (err) {
+			ssb_vsprom_load_failed();
+			return err;
+		}
+		return 0;
+	}
 
 	buf = kcalloc(SSB_SPROMSIZE_WORDS_R123, sizeof(u16), GFP_KERNEL);
 	if (!buf)
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c
+++ wireless-testing/drivers/net/wireless/b43/main.c
@@ -4858,7 +4858,17 @@ static int b43_one_core_attach(struct ss
 static void b43_sprom_fixup(struct ssb_bus *bus)
 {
 	struct pci_dev *pdev;
+	int i;
 
+	/* The sprom contents may be loaded asynchronously. Check that the
+	 * revision is set before proceeding */
+	for (i = 0; i < 1000; i++) {
+		if (bus->sprom.revision)
+			break;
+		msleep(1);
+	}
+	if (i == 1000)
+		printk(KERN_INFO "b43: No sprom image loaded\n");
 	/* boardflags workarounds */
 	if (bus->boardinfo.vendor == SSB_BOARDVENDOR_DELL &&
 	    bus->chip_id == 0x4301 && bus->boardinfo.rev == 0x74)
