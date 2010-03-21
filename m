Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50400 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab0CUAOx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Mar 2010 20:14:53 -0400
Date: Sat, 20 Mar 2010 19:14:51 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Michael Buesch <mb@bu3sch.de>,
	John W Linville <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] ssb: Implement virtual SPROM on disk
Message-ID: <4ba564fb.PfAZePu8tStyxs44%Larry.Finger@lwfinger.net>
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
 
@@ -613,6 +614,39 @@ static int sprom_extract(struct ssb_bus
 	return 0;
 }
 
+static int ssb_get_vsprom(struct device *dev, u16 *buf, size_t size)
+{
+	/* Use the firmware load facility to get the disk image of an SPROM */
+	const struct firmware *blob;
+	int err;
+	int i;
+
+	err = request_firmware(&blob, "ssb/vsprom_image", dev);
+	if (err) {
+		printk(KERN_ERR "ssb: The BCM43XX device does not have an "
+		       "SPROM built in, and the virtual SPROM file is not"
+		       " available.\n");
+		printk(KERN_ERR "ssb: Please go to "
+		       "http://wireless.kernel.org/en/users/Drivers/b43 "
+		       "and download the utility to create the file.\n");
+		return err;
+	}
+	if (blob->size != size * 2) {
+		printk(KERN_ERR "ssb: The virtual SPROM file has the wrong"
+		       " size\n");
+		return -ENOENT;
+	}
+	for (i = 0; i < size; i++)
+		buf[i] = blob->data[2 * i + 1] << 8 | blob->data[2 * i];
+	err = sprom_check_crc(buf, size);
+	if (err) {
+		printk(KERN_ERR "ssb: Invalid CRC for virtual SPROM\n");
+		return err;
+	}
+
+	return 0;
+}
+
 static int ssb_pci_sprom_get(struct ssb_bus *bus,
 			     struct ssb_sprom *sprom)
 {
@@ -620,8 +654,18 @@ static int ssb_pci_sprom_get(struct ssb_
 	int err = -ENOMEM;
 	u16 *buf;
 
-	if (!ssb_is_sprom_available(bus))
-		return -ENODEV;
+	if (!ssb_is_sprom_available(bus)) {
+		buf = kcalloc(SSB_SPROMSIZE_WORDS_R4, sizeof(u16),
+			      GFP_KERNEL);
+		if (!buf)
+			return -ENOMEM;
+		bus->sprom_size = SSB_SPROMSIZE_WORDS_R4;
+		if (ssb_get_vsprom(&bus->host_pci->dev, buf, bus->sprom_size)) {
+			err = -ENODEV;
+			goto out_free;
+		}
+		goto extract;
+	}
 
 	buf = kcalloc(SSB_SPROMSIZE_WORDS_R123, sizeof(u16), GFP_KERNEL);
 	if (!buf)
@@ -653,6 +697,7 @@ static int ssb_pci_sprom_get(struct ssb_
 				   " SPROM CRC (corrupt SPROM)\n");
 		}
 	}
+extract:
 	err = sprom_extract(bus, sprom, buf, bus->sprom_size);
 
 out_free:
