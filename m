Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2371 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276Ab1ECJg2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:28 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>
Subject: [PATCH 53/61] staging: brcm80211: replace hndcrc16 with
 crc-ccitt function
Date: Tue, 3 May 2011 11:35:53 +0200
Message-ID: <1304415361-7813-54-git-send-email-arend@broadcom.com> (sfid-20110503_114020_025202_17C58F3E)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The implementation of hndcrc16 is identical to that of the crc-ccitt
function available in linux kernel library functions. The driver now
uses the crc-ccitt function.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/Kconfig            |    1 +
 drivers/staging/brcm80211/include/bcmutils.h |    1 -
 drivers/staging/brcm80211/util/bcmotp.c      |    5 +-
 drivers/staging/brcm80211/util/bcmutils.c    |   66 --------------------------
 4 files changed, 4 insertions(+), 69 deletions(-)

diff --git a/drivers/staging/brcm80211/Kconfig b/drivers/staging/brcm80211/Kconfig
index af74699..37e028c 100644
--- a/drivers/staging/brcm80211/Kconfig
+++ b/drivers/staging/brcm80211/Kconfig
@@ -4,6 +4,7 @@ config BRCMSMAC
 	depends on PCI
 	depends on WLAN && MAC80211
 	select FW_LOADER
+	select CRC_CCITT
 	---help---
 	  This module adds support for PCIe wireless adapters based on Broadcom
 	  IEEE802.11n SoftMAC chipsets.  If you choose to build a module, it'll
diff --git a/drivers/staging/brcm80211/include/bcmutils.h b/drivers/staging/brcm80211/include/bcmutils.h
index f114e3d..0dd63a2 100644
--- a/drivers/staging/brcm80211/include/bcmutils.h
+++ b/drivers/staging/brcm80211/include/bcmutils.h
@@ -480,7 +480,6 @@ extern struct sk_buff *pktq_mdeq(struct pktq *pq, uint prec_bmp, int *prec_out);
 /* externs */
 /* crc */
 	extern u8 hndcrc8(u8 *p, uint nbytes, u8 crc);
-	extern u16 hndcrc16(u8 *p, uint nbytes, u16 crc);
 /* format/print */
 #if defined(BCMDBG)
 	extern int bcm_format_flags(const bcm_bit_desc_t *bd, u32 flags,
diff --git a/drivers/staging/brcm80211/util/bcmotp.c b/drivers/staging/brcm80211/util/bcmotp.c
index 2421785..d09628b 100644
--- a/drivers/staging/brcm80211/util/bcmotp.c
+++ b/drivers/staging/brcm80211/util/bcmotp.c
@@ -19,6 +19,7 @@
 #include <linux/string.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/crc-ccitt.h>
 
 #include <bcmdefs.h>
 #include <bcmdevs.h>
@@ -779,8 +780,8 @@ static int hndotp_nvread(void *oh, char *data, uint *len)
 			/* Bad length, try to find another chunk anyway */
 			rsz = 6;
 		}
-		if (hndcrc16((u8 *) &rawotp[i], rsz,
-			     CRC16_INIT_VALUE) == CRC16_GOOD_VALUE) {
+		if (crc_ccitt(CRC16_INIT_VALUE, (u8 *) &rawotp[i], rsz) ==
+			CRC16_GOOD_VALUE) {
 			/* Good crc, copy the vars */
 			gchunks++;
 			dsz = rsz - 6;
diff --git a/drivers/staging/brcm80211/util/bcmutils.c b/drivers/staging/brcm80211/util/bcmutils.c
index 68a0dc6..9265722 100644
--- a/drivers/staging/brcm80211/util/bcmutils.c
+++ b/drivers/staging/brcm80211/util/bcmutils.c
@@ -580,72 +580,6 @@ u8 hndcrc8(u8 *pdata,	/* pointer to array of data to process */
 	return crc;
 }
 
-/*******************************************************************************
- * crc16
- *
- * Computes a crc16 over the input data using the polynomial:
- *
- *       x^16 + x^12 +x^5 + 1
- *
- * The caller provides the initial value (either CRC16_INIT_VALUE
- * or the previous returned value) to allow for processing of
- * discontiguous blocks of data.  When generating the CRC the
- * caller is responsible for complementing the final return value
- * and inserting it into the byte stream.  When checking, a final
- * return value of CRC16_GOOD_VALUE indicates a valid CRC.
- *
- * Reference: Dallas Semiconductor Application Note 27
- *   Williams, Ross N., "A Painless Guide to CRC Error Detection Algorithms",
- *     ver 3, Aug 1993, ross@guest.adelaide.edu.au, Rocksoft Pty Ltd.,
- *     ftp://ftp.rocksoft.com/clients/rocksoft/papers/crc_v3.txt
- *
- * ****************************************************************************
- */
-
-static const u16 crc16_table[256] = {
-	0x0000, 0x1189, 0x2312, 0x329B, 0x4624, 0x57AD, 0x6536, 0x74BF,
-	0x8C48, 0x9DC1, 0xAF5A, 0xBED3, 0xCA6C, 0xDBE5, 0xE97E, 0xF8F7,
-	0x1081, 0x0108, 0x3393, 0x221A, 0x56A5, 0x472C, 0x75B7, 0x643E,
-	0x9CC9, 0x8D40, 0xBFDB, 0xAE52, 0xDAED, 0xCB64, 0xF9FF, 0xE876,
-	0x2102, 0x308B, 0x0210, 0x1399, 0x6726, 0x76AF, 0x4434, 0x55BD,
-	0xAD4A, 0xBCC3, 0x8E58, 0x9FD1, 0xEB6E, 0xFAE7, 0xC87C, 0xD9F5,
-	0x3183, 0x200A, 0x1291, 0x0318, 0x77A7, 0x662E, 0x54B5, 0x453C,
-	0xBDCB, 0xAC42, 0x9ED9, 0x8F50, 0xFBEF, 0xEA66, 0xD8FD, 0xC974,
-	0x4204, 0x538D, 0x6116, 0x709F, 0x0420, 0x15A9, 0x2732, 0x36BB,
-	0xCE4C, 0xDFC5, 0xED5E, 0xFCD7, 0x8868, 0x99E1, 0xAB7A, 0xBAF3,
-	0x5285, 0x430C, 0x7197, 0x601E, 0x14A1, 0x0528, 0x37B3, 0x263A,
-	0xDECD, 0xCF44, 0xFDDF, 0xEC56, 0x98E9, 0x8960, 0xBBFB, 0xAA72,
-	0x6306, 0x728F, 0x4014, 0x519D, 0x2522, 0x34AB, 0x0630, 0x17B9,
-	0xEF4E, 0xFEC7, 0xCC5C, 0xDDD5, 0xA96A, 0xB8E3, 0x8A78, 0x9BF1,
-	0x7387, 0x620E, 0x5095, 0x411C, 0x35A3, 0x242A, 0x16B1, 0x0738,
-	0xFFCF, 0xEE46, 0xDCDD, 0xCD54, 0xB9EB, 0xA862, 0x9AF9, 0x8B70,
-	0x8408, 0x9581, 0xA71A, 0xB693, 0xC22C, 0xD3A5, 0xE13E, 0xF0B7,
-	0x0840, 0x19C9, 0x2B52, 0x3ADB, 0x4E64, 0x5FED, 0x6D76, 0x7CFF,
-	0x9489, 0x8500, 0xB79B, 0xA612, 0xD2AD, 0xC324, 0xF1BF, 0xE036,
-	0x18C1, 0x0948, 0x3BD3, 0x2A5A, 0x5EE5, 0x4F6C, 0x7DF7, 0x6C7E,
-	0xA50A, 0xB483, 0x8618, 0x9791, 0xE32E, 0xF2A7, 0xC03C, 0xD1B5,
-	0x2942, 0x38CB, 0x0A50, 0x1BD9, 0x6F66, 0x7EEF, 0x4C74, 0x5DFD,
-	0xB58B, 0xA402, 0x9699, 0x8710, 0xF3AF, 0xE226, 0xD0BD, 0xC134,
-	0x39C3, 0x284A, 0x1AD1, 0x0B58, 0x7FE7, 0x6E6E, 0x5CF5, 0x4D7C,
-	0xC60C, 0xD785, 0xE51E, 0xF497, 0x8028, 0x91A1, 0xA33A, 0xB2B3,
-	0x4A44, 0x5BCD, 0x6956, 0x78DF, 0x0C60, 0x1DE9, 0x2F72, 0x3EFB,
-	0xD68D, 0xC704, 0xF59F, 0xE416, 0x90A9, 0x8120, 0xB3BB, 0xA232,
-	0x5AC5, 0x4B4C, 0x79D7, 0x685E, 0x1CE1, 0x0D68, 0x3FF3, 0x2E7A,
-	0xE70E, 0xF687, 0xC41C, 0xD595, 0xA12A, 0xB0A3, 0x8238, 0x93B1,
-	0x6B46, 0x7ACF, 0x4854, 0x59DD, 0x2D62, 0x3CEB, 0x0E70, 0x1FF9,
-	0xF78F, 0xE606, 0xD49D, 0xC514, 0xB1AB, 0xA022, 0x92B9, 0x8330,
-	0x7BC7, 0x6A4E, 0x58D5, 0x495C, 0x3DE3, 0x2C6A, 0x1EF1, 0x0F78
-};
-
-u16 hndcrc16(u8 *pdata,	/* pointer to array of data to process */
-	uint nbytes,	/* number of input data bytes to process */
-	u16 crc	/* either CRC16_INIT_VALUE or previous return value */
-    ) {
-	while (nbytes-- > 0)
-		CRC_INNER_LOOP(16, crc, *pdata++);
-	return crc;
-}
-
 static const u32 crc32_table[256] = {
 	0x00000000, 0x77073096, 0xEE0E612C, 0x990951BA,
 	0x076DC419, 0x706AF48F, 0xE963A535, 0x9E6495A3,
-- 
1.7.4.1


