Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:44775 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab0LLDd7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Dec 2010 22:33:59 -0500
Date: Sat, 11 Dec 2010 21:34:25 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] ssb: Attempt recovery from corrupt sprom
Message-ID: <4d0442c1.5R+Q6u6bksIzTSW6%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Current code defaults to SPROM revision 1 if there is a CRC error. In at
least one known case, most of the corrupt contents are reasonable and
it is possible to extract the correct MAC address and TX power settings
from what is read. With this patch, an attempt is made to match the
apparent revision number with certain SPROM signatures. For those revisions
without such a feature, a reasonable guess is made. If the apparent
revision is invalid, or if the signature does not match, the previous
behavior is kept.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is 2.6.38 material.

Thanks,

Larry
---

Index: wireless-testing/drivers/ssb/pci.c
===================================================================
--- wireless-testing.orig/drivers/ssb/pci.c
+++ wireless-testing/drivers/ssb/pci.c
@@ -661,6 +661,7 @@ static int ssb_pci_sprom_get(struct ssb_
 	const struct ssb_sprom *fallback;
 	int err;
 	u16 *buf;
+	u16 revision;
 
 	if (!ssb_is_sprom_available(bus)) {
 		ssb_printk(KERN_ERR PFX "No SPROM available!\n");
@@ -712,6 +713,52 @@ static int ssb_pci_sprom_get(struct ssb_
 			}
 			ssb_printk(KERN_WARNING PFX "WARNING: Invalid"
 				   " SPROM CRC (corrupt SPROM)\n");
+			/* At this point, we have a faulty SPROM image.
+			 * In case only part of it is corrupt, try to
+			 * determine what rev we might have */
+			revision = buf[SPOFF(SSB_SPROMSIZE_WORDS_R4)] & 0x00FF;
+			switch (revision) {
+			case 4:
+			case 5:
+				/* Rev 4 and 5 have 0x5372 at byte offset
+				 * SSB_SPROM4_SIG */
+				if (buf[SPOFF(SSB_SPROM4_SIG)] == 0x5372)
+					sprom->revision = revision;
+				break;
+			case 8:
+				/* Rev has 0x5372 at byte offset
+				 * SSB_SPROM8_SIG */
+				if (buf[SPOFF(SSB_SPROM8_SIG)] == 0x5372)
+					sprom->revision = revision;
+				break;
+			default:
+				/* Try a rev 1, 2, or 3 size. This test will
+				 * not be robust as these versions have no
+				 * signature value */
+				revision = buf[SPOFF(SSB_SPROMSIZE_WORDS_R123)]
+					   & 0x00FF;
+				switch (revision) {
+				case 1:
+					/* Rev 1 will have 0xFFFF in the board
+					 * flags high position */
+					if (buf[SPOFF(SSB_SPROM2_BFLHI)] ==
+					    0xFFFF)
+						sprom->revision = revision;
+					break;
+				case 2:
+				case 3:
+					/* Revs 2 and 3 will not have 0xFFFF in
+					 * the board flags high position */
+					if (buf[SPOFF(SSB_SPROM2_BFLHI)] !=
+					    0xFFFF)
+						sprom->revision = revision;
+					break;
+				default:
+					/* The revision is not reasonable */
+					break;
+				}
+				break;
+			}
 		}
 	}
 	err = sprom_extract(bus, sprom, buf, bus->sprom_size);
Index: wireless-testing/include/linux/ssb/ssb_regs.h
===================================================================
--- wireless-testing.orig/include/linux/ssb/ssb_regs.h
+++ wireless-testing/include/linux/ssb/ssb_regs.h
@@ -266,6 +266,7 @@
 #define  SSB_SPROM3_OFDMGPO		0x107A	/* G-PHY OFDM Power Offset (4 bytes, BigEndian) */
 
 /* SPROM Revision 4 */
+#define SSB_SPROM4_SIG			0x0040	/* Rev 4/5 signature */
 #define SSB_SPROM4_BFLLO		0x0044	/* Boardflags (low 16 bits) */
 #define SSB_SPROM4_BFLHI		0x0046  /* Board Flags Hi */
 #define SSB_SPROM4_IL0MAC		0x004C	/* 6 byte MAC address for a/b/g/n */
@@ -369,6 +370,7 @@
 #define  SSB_SPROM5_GPIOB_P3_SHIFT	8
 
 /* SPROM Revision 8 */
+#define SSB_SPROM8_SIG			0x0080	/* Rev 8 signature */
 #define SSB_SPROM8_BOARDREV		0x0082	/* Board revision */
 #define SSB_SPROM8_BFLLO		0x0084	/* Board flags (bits 0-15) */
 #define SSB_SPROM8_BFLHI		0x0086	/* Board flags (bits 16-31) */
