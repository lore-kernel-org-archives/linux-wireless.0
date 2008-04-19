Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:36312 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756069AbYDSOZA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Apr 2008 10:25:00 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] ssb: Allow reading of 440-byte SPROM that is not rev 4
Date: Sat, 19 Apr 2008 16:24:09 +0200
Cc: Larry.Finger@lwfinger.net, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200804191624.09660.mb@bu3sch.de> (sfid-20080419_152509_782304_E979330D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Larry.Finger@lwfinger.net

The current code checks for the special signature that signifies
a revision 4 SPROM. Now that a rev. 8 SPROM with a 440-byte length
has been found that may not have any special code, this check could
be relaxed. With this patch, if the CRC is incorrect for a 256-byte
SPROM, the code will immediately check for a 440-byte SPROM. If there
is still a CRC error, the size is set to 440 bytes, which allows dumping
of most of any 512-byte SPROM if one is encountered.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Michael Buesch <mb@bu3sch.de>
---

John, please apply this to 2.6.27


Index: wireless-testing/drivers/ssb/pci.c
===================================================================
--- wireless-testing.orig/drivers/ssb/pci.c
+++ wireless-testing/drivers/ssb/pci.c
@@ -505,17 +505,15 @@ static int ssb_pci_sprom_get(struct ssb_
 	sprom_do_read(bus, buf);
 	err = sprom_check_crc(buf, bus->sprom_size);
 	if (err) {
-		/* check for rev 4 sprom - has special signature */
-		if (buf[32] == 0x5372) {
-			kfree(buf);
-			buf = kcalloc(SSB_SPROMSIZE_WORDS_R4, sizeof(u16),
-				      GFP_KERNEL);
-			if (!buf)
-				goto out;
-			bus->sprom_size = SSB_SPROMSIZE_WORDS_R4;
-			sprom_do_read(bus, buf);
-			err = sprom_check_crc(buf, bus->sprom_size);
-		}
+		/* try for a 440 byte SPROM - revision 4 and higher */
+		kfree(buf);
+		buf = kcalloc(SSB_SPROMSIZE_WORDS_R4, sizeof(u16),
+			      GFP_KERNEL);
+		if (!buf)
+			goto out;
+		bus->sprom_size = SSB_SPROMSIZE_WORDS_R4;
+		sprom_do_read(bus, buf);
+		err = sprom_check_crc(buf, bus->sprom_size);
 		if (err)
 			ssb_printk(KERN_WARNING PFX "WARNING: Invalid"
 				   " SPROM CRC (corrupt SPROM)\n");

-- 
Greetings Michael.
