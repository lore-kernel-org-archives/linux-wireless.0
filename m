Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64967 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757303Ab0LBQhD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 11:37:03 -0500
Date: Thu, 02 Dec 2010 10:36:53 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [RFC/RFT] ssb: Attempt to recover from SPROM CRC error
Message-ID: <4cf7cb25.SwkH7gALTG7E00Zb%Larry.Finger@lwfinger.net>
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

Could you please test this patch with your card?

Thanks,

Larry
---

Index: linux-2.6/drivers/ssb/pci.c
===================================================================
--- linux-2.6.orig/drivers/ssb/pci.c
+++ linux-2.6/drivers/ssb/pci.c
@@ -620,6 +620,7 @@ static int ssb_pci_sprom_get(struct ssb_
 	const struct ssb_sprom *fallback;
 	int err = -ENOMEM;
 	u16 *buf;
+	u16 revision;
 
 	if (!ssb_is_sprom_available(bus)) {
 		ssb_printk(KERN_ERR PFX "No SPROM available!\n");
@@ -671,6 +672,50 @@ static int ssb_pci_sprom_get(struct ssb_
 			}
 			ssb_printk(KERN_WARNING PFX "WARNING: Invalid"
 				   " SPROM CRC (corrupt SPROM)\n");
+			/* At this point, we have a faulty SPROM image.
+			 * In case only part of it is corrupt, try to
+			 * determine what rev we might have */
+			revision = buf[SSB_SPROMSIZE_WORDS_R4 - 1] & 0x00FF;
+			switch (revision) {
+			case 4:
+			case 5:
+				/* Rev 4 and 5 have 0x5372 at byte offset
+				 * SSB_SPROM4_SIG */
+				if (buf[SSB_SPROM4_SIG >> 1] == 0x5372)
+					sprom->revision = revision;
+				break;
+			case 8:
+				/* Rev has 0x5372 at byte offset
+				 * SSB_SPROM8_SIG */
+				if (buf[SSB_SPROM8_SIG >> 1] == 0x5372)
+					sprom->revision = revision;
+				break;
+			default:
+				/* Try a rev 1, 2, or 3 size. This test will
+				 * not be robust as these versions have no
+				 * signature value */
+				revision = buf[SSB_SPROMSIZE_WORDS_R123 - 1] &
+					   0x00FF;
+				switch (revision) {
+				case 1:
+					/* Rev 1 will have 0xFFFF in the board
+					 * flags high position */
+					if (buf[SSB_SPROM2_BFLHI>>1] == 0xFFFF)
+						sprom->revision = revision;
+					break;
+				case 2:
+				case 3:
+					/* Revs 2 and 3 will not have 0xFFFF in
+					 * the board flags high position */
+					if (buf[SSB_SPROM2_BFLHI>>1] != 0xFFFF)
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
Index: linux-2.6/include/linux/ssb/ssb_regs.h
===================================================================
--- linux-2.6.orig/include/linux/ssb/ssb_regs.h
+++ linux-2.6/include/linux/ssb/ssb_regs.h
@@ -266,6 +266,7 @@
 #define  SSB_SPROM3_OFDMGPO		0x107A	/* G-PHY OFDM Power Offset (4 bytes, BigEndian) */
 
 /* SPROM Revision 4 */
+#define SSB_SPROM4_SIG			0x0040	/* Rev 4/5 signature */
 #define SSB_SPROM4_BFLLO		0x0044	/* Boardflags (low 16 bits) */
 #define SSB_SPROM4_BFLHI		0x0046  /* Board Flags Hi */
 #define SSB_SPROM4_IL0MAC		0x004C	/* 6 byte MAC address for a/b/g/n */
@@ -329,6 +330,7 @@
 #define  SSB_SPROM5_GPIOB_P3_SHIFT	8
 
 /* SPROM Revision 8 */
+#define SSB_SPROM8_SIG			0x0080	/* Rev 8 signature */
 #define SSB_SPROM8_BOARDREV		0x0082	/* Board revision */
 #define SSB_SPROM8_BFLLO		0x0084	/* Board flags (bits 0-15) */
 #define SSB_SPROM8_BFLHI		0x0086	/* Board flags (bits 16-31) */
