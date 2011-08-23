Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2103 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067Ab1HWMOU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 08:14:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 2/8] staging: brcm80211: make use of crc8 library
 function
Date: Tue, 23 Aug 2011 14:13:54 +0200
Message-ID: <1314101640-4229-3-git-send-email-arend@broadcom.com> (sfid-20110823_141436_123712_1C5F6A62)
In-Reply-To: <1314101640-4229-1-git-send-email-arend@broadcom.com>
References: <1314101640-4229-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The crc8 function is now available as a library function provided
by kernel module crc8.ko. The function has been removed from brcmutil
module and srom.c now uses crc8 library function.

Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/Kconfig               |    1 +
 drivers/staging/brcm80211/brcmsmac/srom.c       |   20 +++++-
 drivers/staging/brcm80211/brcmutil/utils.c      |   69 -----------------------
 drivers/staging/brcm80211/include/brcmu_utils.h |    5 --
 4 files changed, 17 insertions(+), 78 deletions(-)

diff --git a/drivers/staging/brcm80211/Kconfig b/drivers/staging/brcm80211/Kconfig
index ef77b44..816a7af 100644
--- a/drivers/staging/brcm80211/Kconfig
+++ b/drivers/staging/brcm80211/Kconfig
@@ -11,6 +11,7 @@ config BRCMSMAC
 	select BRCMUTIL
 	select FW_LOADER
 	select CRC_CCITT
+	select CRC8
 	---help---
 	  This module adds support for PCIe wireless adapters based on Broadcom
 	  IEEE802.11n SoftMAC chipsets.  If you choose to build a module, it'll
diff --git a/drivers/staging/brcm80211/brcmsmac/srom.c b/drivers/staging/brcm80211/brcmsmac/srom.c
index 7a17f59..90e2ac8 100644
--- a/drivers/staging/brcm80211/brcmsmac/srom.c
+++ b/drivers/staging/brcm80211/brcmsmac/srom.c
@@ -18,6 +18,7 @@
 #include <linux/string.h>
 #include <linux/io.h>
 #include <linux/etherdevice.h>
+#include <linux/crc8.h>
 #include <stdarg.h>
 
 #include <chipcommon.h>
@@ -39,6 +40,13 @@
 #define WRITE_WORD_DELAY	20
 #endif
 
+/*
+ * SROM CRC8 polynomial value:
+ *
+ * x^8 + x^7 +x^6 + x^4 + x^2 + 1
+ */
+#define SROM_CRC8_POLY		0xAB
+
 /* Maximum srom: 6 Kilobits == 768 bytes */
 #define	SROM_MAX		768
 
@@ -782,6 +790,8 @@ static const struct brcms_sromvar perpath_pci_sromvars[] = {
 	{NULL, 0, 0, 0, 0}
 };
 
+static u8 srom_crc8_table[CRC8_TABLE_SIZE];
+
 static void _initvars_srom_pci(u8 sromrev, u16 *srom, uint off,
 			       struct brcms_varbuf *b);
 static int initvars_srom_pci(struct si_pub *sih, void *curmap, char **vars,
@@ -919,8 +929,8 @@ sprom_read_pci(struct si_pub *sih, u16 *sprom, uint wordoff,
 
 		/* fixup the endianness so crc8 will pass */
 		htol16_buf(buf, nwords * 2);
-		if (brcmu_crc8((u8 *) buf, nwords * 2, CRC8_INIT_VALUE) !=
-		    CRC8_GOOD_VALUE)
+		if (crc8(srom_crc8_table, (u8 *) buf, nwords * 2,
+			 CRC8_INIT_VALUE) != CRC8_GOOD_VALUE(srom_crc8_table))
 			/* DBG only pci always read srom4 first, then srom8/9 */
 			err = -EIO;
 
@@ -957,8 +967,8 @@ static int otp_read_pci(struct si_pub *sih, u16 *buf, uint bufsz)
 
 	/* fixup the endianness so crc8 will pass */
 	htol16_buf(buf, bufsz);
-	if (brcmu_crc8((u8 *) buf, SROM4_WORDS * 2, CRC8_INIT_VALUE) !=
-	    CRC8_GOOD_VALUE)
+	if (crc8(srom_crc8_table, (u8 *) buf, SROM4_WORDS * 2,
+		 CRC8_INIT_VALUE) != CRC8_GOOD_VALUE(srom_crc8_table))
 		err = -EIO;
 
 	/* now correct the endianness of the byte array */
@@ -1174,6 +1184,8 @@ static int initvars_srom_pci(struct si_pub *sih, void *curmap, char **vars,
 		return -ENOMEM;
 
 	sromwindow = (u16 *) SROM_OFFSET(sih);
+
+	crc8_populate_lsb(srom_crc8_table, SROM_CRC8_POLY);
 	if (ai_is_sprom_available(sih)) {
 		err = sprom_read_pci(sih, sromwindow, 0, srom, SROM_WORDS,
 				     true);
diff --git a/drivers/staging/brcm80211/brcmutil/utils.c b/drivers/staging/brcm80211/brcmutil/utils.c
index 7b4d658..6280ec1 100644
--- a/drivers/staging/brcm80211/brcmutil/utils.c
+++ b/drivers/staging/brcm80211/brcmutil/utils.c
@@ -431,75 +431,6 @@ int brcmu_iovar_lencheck(const struct brcmu_iovar *vi, void *arg, int len,
 }
 EXPORT_SYMBOL(brcmu_iovar_lencheck);
 
-/*******************************************************************************
- * crc8
- *
- * Computes a crc8 over the input data using the polynomial:
- *
- *       x^8 + x^7 +x^6 + x^4 + x^2 + 1
- *
- * The caller provides the initial value (either CRC8_INIT_VALUE
- * or the previous returned value) to allow for processing of
- * discontiguous blocks of data.  When generating the CRC the
- * caller is responsible for complementing the final return value
- * and inserting it into the byte stream.  When checking, a final
- * return value of CRC8_GOOD_VALUE indicates a valid CRC.
- *
- * Reference: Dallas Semiconductor Application Note 27
- *   Williams, Ross N., "A Painless Guide to CRC Error Detection Algorithms",
- *     ver 3, Aug 1993, ross@guest.adelaide.edu.au, Rocksoft Pty Ltd.,
- *     ftp://ftp.rocksoft.com/clients/rocksoft/papers/crc_v3.txt
- *
- * ****************************************************************************
- */
-
-static const u8 crc8_table[256] = {
-	0x00, 0xF7, 0xB9, 0x4E, 0x25, 0xD2, 0x9C, 0x6B,
-	0x4A, 0xBD, 0xF3, 0x04, 0x6F, 0x98, 0xD6, 0x21,
-	0x94, 0x63, 0x2D, 0xDA, 0xB1, 0x46, 0x08, 0xFF,
-	0xDE, 0x29, 0x67, 0x90, 0xFB, 0x0C, 0x42, 0xB5,
-	0x7F, 0x88, 0xC6, 0x31, 0x5A, 0xAD, 0xE3, 0x14,
-	0x35, 0xC2, 0x8C, 0x7B, 0x10, 0xE7, 0xA9, 0x5E,
-	0xEB, 0x1C, 0x52, 0xA5, 0xCE, 0x39, 0x77, 0x80,
-	0xA1, 0x56, 0x18, 0xEF, 0x84, 0x73, 0x3D, 0xCA,
-	0xFE, 0x09, 0x47, 0xB0, 0xDB, 0x2C, 0x62, 0x95,
-	0xB4, 0x43, 0x0D, 0xFA, 0x91, 0x66, 0x28, 0xDF,
-	0x6A, 0x9D, 0xD3, 0x24, 0x4F, 0xB8, 0xF6, 0x01,
-	0x20, 0xD7, 0x99, 0x6E, 0x05, 0xF2, 0xBC, 0x4B,
-	0x81, 0x76, 0x38, 0xCF, 0xA4, 0x53, 0x1D, 0xEA,
-	0xCB, 0x3C, 0x72, 0x85, 0xEE, 0x19, 0x57, 0xA0,
-	0x15, 0xE2, 0xAC, 0x5B, 0x30, 0xC7, 0x89, 0x7E,
-	0x5F, 0xA8, 0xE6, 0x11, 0x7A, 0x8D, 0xC3, 0x34,
-	0xAB, 0x5C, 0x12, 0xE5, 0x8E, 0x79, 0x37, 0xC0,
-	0xE1, 0x16, 0x58, 0xAF, 0xC4, 0x33, 0x7D, 0x8A,
-	0x3F, 0xC8, 0x86, 0x71, 0x1A, 0xED, 0xA3, 0x54,
-	0x75, 0x82, 0xCC, 0x3B, 0x50, 0xA7, 0xE9, 0x1E,
-	0xD4, 0x23, 0x6D, 0x9A, 0xF1, 0x06, 0x48, 0xBF,
-	0x9E, 0x69, 0x27, 0xD0, 0xBB, 0x4C, 0x02, 0xF5,
-	0x40, 0xB7, 0xF9, 0x0E, 0x65, 0x92, 0xDC, 0x2B,
-	0x0A, 0xFD, 0xB3, 0x44, 0x2F, 0xD8, 0x96, 0x61,
-	0x55, 0xA2, 0xEC, 0x1B, 0x70, 0x87, 0xC9, 0x3E,
-	0x1F, 0xE8, 0xA6, 0x51, 0x3A, 0xCD, 0x83, 0x74,
-	0xC1, 0x36, 0x78, 0x8F, 0xE4, 0x13, 0x5D, 0xAA,
-	0x8B, 0x7C, 0x32, 0xC5, 0xAE, 0x59, 0x17, 0xE0,
-	0x2A, 0xDD, 0x93, 0x64, 0x0F, 0xF8, 0xB6, 0x41,
-	0x60, 0x97, 0xD9, 0x2E, 0x45, 0xB2, 0xFC, 0x0B,
-	0xBE, 0x49, 0x07, 0xF0, 0x9B, 0x6C, 0x22, 0xD5,
-	0xF4, 0x03, 0x4D, 0xBA, 0xD1, 0x26, 0x68, 0x9F
-};
-
-u8 brcmu_crc8(u8 *pdata,	/* pointer to array of data to process */
-	      uint nbytes,	/* number of input data bytes to process */
-	      u8 crc	/* either CRC8_INIT_VALUE or previous return value */
-	) {
-	/* loop over the buffer data */
-	while (nbytes-- > 0)
-		crc = crc8_table[(crc ^ *pdata++) & 0xff];
-
-	return crc;
-}
-EXPORT_SYMBOL(brcmu_crc8);
-
 /*
  * Traverse a string of 1-byte tag/1-byte length/variable-length value
  * triples, returning a pointer to the substring whose first element
diff --git a/drivers/staging/brcm80211/include/brcmu_utils.h b/drivers/staging/brcm80211/include/brcmu_utils.h
index da13e24..ff8f363 100644
--- a/drivers/staging/brcm80211/include/brcmu_utils.h
+++ b/drivers/staging/brcm80211/include/brcmu_utils.h
@@ -246,8 +246,6 @@ extern int brcmu_iovar_lencheck(const struct brcmu_iovar *table, void *arg,
 #define MODSUB_POW2(x, y, bound) (((x) - (y)) & ((bound) - 1))
 
 /* crc defines */
-#define CRC8_INIT_VALUE  0xff	/* Initial CRC8 checksum value */
-#define CRC8_GOOD_VALUE  0x9f	/* Good final CRC8 checksum value */
 #define CRC16_INIT_VALUE 0xffff	/* Initial CRC16 checksum value */
 #define CRC16_GOOD_VALUE 0xf0b8	/* Good final CRC16 checksum value */
 
@@ -268,9 +266,6 @@ struct brcmu_tlv {
 #define ETHER_ADDR_STR_LEN	18
 
 /* externs */
-/* crc */
-extern u8 brcmu_crc8(u8 *p, uint nbytes, u8 crc);
-
 /* format/print */
 #if defined(BCMDBG)
 extern int brcmu_format_flags(const struct brcmu_bit_desc *bd, u32 flags,
-- 
1.7.4.1


