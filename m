Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3196 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754770Ab1JUNzi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 09:55:38 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 17/17] brcm80211: smac: change buffer endianess convert
 function interface
Date: Fri, 21 Oct 2011 15:55:19 +0200
Message-ID: <1319205319-16891-18-git-send-email-arend@broadcom.com> (sfid-20111021_155545_755950_93EC6B9F)
In-Reply-To: <1319205319-16891-1-git-send-email-arend@broadcom.com>
References: <1319205319-16891-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The buffer endianess conversion functions in srom.c had a size
argument giving number of bytes but the function converts words.
Providing the number of words to the function is more sensible
so that is done in this patch.

Reported-by: Pavel Roskin <proski@gnu.org>
Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/srom.c |   33 +++++++++++-------------
 1 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/srom.c b/drivers/net/wireless/brcm80211/brcmsmac/srom.c
index 8f1cf2f..0539a6a 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/srom.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/srom.c
@@ -617,18 +617,16 @@ static uint mask_width(u16 mask)
 	return 0;
 }
 
-static inline void le16_to_cpu_buf(u16 *buf, unsigned int size)
+static inline void le16_to_cpu_buf(u16 *buf, uint nwords)
 {
-	size /= 2;
-	while (size--)
-		*(buf + size) = le16_to_cpu(*(__le16 *)(buf + size));
+	while (nwords--)
+		*(buf + nwords) = le16_to_cpu(*(__le16 *)(buf + nwords));
 }
 
-static inline void cpu_to_le16_buf(u16 *buf, unsigned int size)
+static inline void cpu_to_le16_buf(u16 *buf, uint nwords)
 {
-	size /= 2;
-	while (size--)
-		*(__le16 *)(buf + size) = cpu_to_le16(*(buf + size));
+	while (nwords--)
+		*(__le16 *)(buf + nwords) = cpu_to_le16(*(buf + nwords));
 }
 
 /*
@@ -807,12 +805,12 @@ sprom_read_pci(struct si_pub *sih, u8 __iomem *sprom, uint wordoff,
 		err = -EIO;
 	else
 		/* now correct the endianness of the byte array */
-		le16_to_cpu_buf(buf, nbytes);
+		le16_to_cpu_buf(buf, nwords);
 
 	return err;
 }
 
-static int otp_read_pci(struct si_pub *sih, u16 *buf, uint bufsz)
+static int otp_read_pci(struct si_pub *sih, u16 *buf, uint nwords)
 {
 	u8 *otp;
 	uint sz = OTP_SZ_MAX / 2;	/* size in words */
@@ -824,7 +822,8 @@ static int otp_read_pci(struct si_pub *sih, u16 *buf, uint bufsz)
 
 	err = otp_read_region(sih, OTP_HW_RGN, (u16 *) otp, &sz);
 
-	memcpy(buf, otp, bufsz);
+	sz = min_t(uint, sz, nwords);
+	memcpy(buf, otp, sz * 2);
 
 	kfree(otp);
 
@@ -836,14 +835,12 @@ static int otp_read_pci(struct si_pub *sih, u16 *buf, uint bufsz)
 		 */
 		return -ENODATA;
 
-	/* fixup the endianness so crc8 will pass */
-	cpu_to_le16_buf(buf, bufsz);
-	if (crc8(brcms_srom_crc8_table, (u8 *) buf, SROM4_WORDS * 2,
+	if (crc8(brcms_srom_crc8_table, (u8 *) buf, sz * 2,
 		 CRC8_INIT_VALUE) != CRC8_GOOD_VALUE(brcms_srom_crc8_table))
 		err = -EIO;
-
-	/* now correct the endianness of the byte array */
-	le16_to_cpu_buf(buf, bufsz);
+	else
+		/* now correct the endianness of the byte array */
+		le16_to_cpu_buf(buf, sz);
 
 	return err;
 }
@@ -880,7 +877,7 @@ static int initvars_srom_pci(struct si_pub *sih, void __iomem *curmap)
 			sromrev = srom[SROM4_CRCREV] & 0xff;
 	} else {
 		/* Use OTP if SPROM not available */
-		err = otp_read_pci(sih, srom, SROM_MAX);
+		err = otp_read_pci(sih, srom, SROM4_WORDS);
 		if (err == 0)
 			/* OTP only contain SROM rev8/rev9 for now */
 			sromrev = srom[SROM4_CRCREV] & 0xff;
-- 
1.7.4.1


