Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40998 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab0DYWaa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Apr 2010 18:30:30 -0400
Date: Sun, 25 Apr 2010 17:30:28 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [RFC/RFT] ssb: Avoid system hang when SPROM read fails
Message-ID: <4bd4c284.WBohOsmgdwRzw5JC%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In kernel Bugzilla #15825, the OP reports a case of intermittent reading
of the SPROM. If such reads fail, the box hangs. Thanks to careful testing
by bugzillakernelorg@lez.ath.cx has shown that the first read of the
SPROM returns 0xFFFF with the hang happening on the next read.

The source of the read failure is still under investigation; however,
this patch does avoid the system hang.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

Does this patch avoid the system hang on your box?

Larry
---

===================================================================
--- wireless-testing.orig/drivers/ssb/pci.c
+++ wireless-testing/drivers/ssb/pci.c
@@ -253,6 +253,11 @@ static int sprom_do_read(struct ssb_bus
 {
 	int i;
 
+	/* Check if SPROM can be read */
+	if (ioread16(bus->mmio + SSB_SPROM_BASE) == 0xFFFF) {
+		ssb_printk(KERN_ERR PFX "Unable to read SPROM\n");
+		return -ENODEV;
+	}
 	for (i = 0; i < bus->sprom_size; i++)
 		sprom[i] = ioread16(bus->mmio + SSB_SPROM_BASE + (i * 2));
 
@@ -625,17 +630,23 @@ static int ssb_pci_sprom_get(struct ssb_
 	if (!buf)
 		goto out;
 	bus->sprom_size = SSB_SPROMSIZE_WORDS_R123;
-	sprom_do_read(bus, buf);
+	err = sprom_do_read(bus, buf);
+	if (err)
+		goto out_free;
 	err = sprom_check_crc(buf, bus->sprom_size);
 	if (err) {
 		/* try for a 440 byte SPROM - revision 4 and higher */
 		kfree(buf);
 		buf = kcalloc(SSB_SPROMSIZE_WORDS_R4, sizeof(u16),
 			      GFP_KERNEL);
-		if (!buf)
+		if (!buf) {
+			err = -ENOMEM;
 			goto out;
+		}
 		bus->sprom_size = SSB_SPROMSIZE_WORDS_R4;
-		sprom_do_read(bus, buf);
+		err = sprom_do_read(bus, buf);
+		if (err)
+			goto out_free;
 		err = sprom_check_crc(buf, bus->sprom_size);
 		if (err) {
 			/* All CRC attempts failed.
