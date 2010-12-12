Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:45289 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab0LLDfH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Dec 2010 22:35:07 -0500
Date: Sat, 11 Dec 2010 21:35:35 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] ssb: Save sprom image for dump of device at alternate location
Message-ID: <4d044307.Ipm73VWEgifFrF0m%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some recent Broadcom devices in netbooks have an SPROM that is located
at 0x0800, not the normal location of 0x1000. Initial reading of the
SPROM has been solved in a previous commit; however, dumping to a console
no longer works. This difficulty is fixed by saving the SPROM image
from the initial read, and only freeing that memory at module unload.

Uploading a new SPROM image is not supported for these devices.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is 2.6.38 material.

Larry
---
 
Index: wireless-testing/drivers/ssb/pci.c
===================================================================
--- wireless-testing.orig/drivers/ssb/pci.c
+++ wireless-testing/drivers/ssb/pci.c
@@ -709,7 +709,7 @@ static int ssb_pci_sprom_get(struct ssb_
 			if (fallback) {
 				memcpy(sprom, fallback, sizeof(*sprom));
 				err = 0;
-				goto out_free;
+				goto out;
 			}
 			ssb_printk(KERN_WARNING PFX "WARNING: Invalid"
 				   " SPROM CRC (corrupt SPROM)\n");
@@ -763,8 +763,8 @@ static int ssb_pci_sprom_get(struct ssb_
 	}
 	err = sprom_extract(bus, sprom, buf, bus->sprom_size);
 
-out_free:
-	kfree(buf);
+out:
+	bus->sprom_data = buf;
 	return err;
 }
 
@@ -1013,6 +1013,7 @@ void ssb_pci_exit(struct ssb_bus *bus)
 	if (bus->bustype != SSB_BUSTYPE_PCI)
 		return;
 
+	kfree(bus->sprom_data);
 	pdev = bus->host_pci;
 	device_remove_file(&pdev->dev, &dev_attr_ssb_sprom);
 }
Index: wireless-testing/drivers/ssb/sprom.c
===================================================================
--- wireless-testing.orig/drivers/ssb/sprom.c
+++ wireless-testing/drivers/ssb/sprom.c
@@ -72,24 +72,29 @@ ssize_t ssb_attr_sprom_show(struct ssb_b
 	ssize_t count = 0;
 	size_t sprom_size_words = bus->sprom_size;
 
-	sprom = kcalloc(sprom_size_words, sizeof(u16), GFP_KERNEL);
-	if (!sprom)
-		goto out;
-
-	/* Use interruptible locking, as the SPROM write might
-	 * be holding the lock for several seconds. So allow userspace
-	 * to cancel operation. */
-	err = -ERESTARTSYS;
-	if (mutex_lock_interruptible(&bus->sprom_mutex))
-		goto out_kfree;
-	err = sprom_read(bus, sprom);
-	mutex_unlock(&bus->sprom_mutex);
-
+	if (bus->sprom_data) {
+		sprom = bus->sprom_data;
+		err = 0;
+	} else {
+		sprom = kcalloc(sprom_size_words, sizeof(u16), GFP_KERNEL);
+		if (!sprom)
+			goto out;
+
+		/* Use interruptible locking, as the SPROM write might
+		 * be holding the lock for several seconds. So allow userspace
+		 * to cancel operation. */
+		err = -ERESTARTSYS;
+		if (mutex_lock_interruptible(&bus->sprom_mutex))
+			goto out_kfree;
+		err = sprom_read(bus, sprom);
+		mutex_unlock(&bus->sprom_mutex);
+	}
 	if (!err)
 		count = sprom2hex(sprom, buf, PAGE_SIZE, sprom_size_words);
 
 out_kfree:
-	kfree(sprom);
+	if (!bus->sprom_data)
+		kfree(sprom);
 out:
 	return err ? err : count;
 }
@@ -105,6 +110,8 @@ ssize_t ssb_attr_sprom_store(struct ssb_
 	size_t sprom_size_words = bus->sprom_size;
 	struct ssb_freeze_context freeze;
 
+	if (bus->sprom_offset < SSB_SPROM_BASE1)
+		return -EINVAL;
 	sprom = kcalloc(bus->sprom_size, sizeof(u16), GFP_KERNEL);
 	if (!sprom)
 		goto out;
Index: wireless-testing/include/linux/ssb/ssb.h
===================================================================
--- wireless-testing.orig/include/linux/ssb/ssb.h
+++ wireless-testing/include/linux/ssb/ssb.h
@@ -311,6 +311,7 @@ struct ssb_bus {
 	u16 chip_rev;
 	u16 sprom_offset;
 	u16 sprom_size;		/* number of words in sprom */
+	u16 *sprom_data;	/* saved sprom raw data */
 	u8 chip_package;
 
 	/* List of devices (cores) on the backplane. */
