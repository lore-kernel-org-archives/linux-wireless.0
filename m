Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2088 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757987Ab1F2Xss (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:48 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 005/119] staging: brcm80211: make use of linux error
 codes in srom.c
Date: Wed, 29 Jun 2011 16:46:29 -0700
Message-ID: <1309391303-22741-6-git-send-email-frankyl@broadcom.com> (sfid-20110630_015033_686997_561785DA)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The source file srom.c used meaningless non-zero numbers to return
upon error conditions. These have been replaced by linux error codes.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/srom.c |   36 +++++++++++++----------------
 1 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/srom.c b/drivers/staging/brcm80211/brcmsmac/srom.c
index 31aa84d..34c19ef 100644
--- a/drivers/staging/brcm80211/brcmsmac/srom.c
+++ b/drivers/staging/brcm80211/brcmsmac/srom.c
@@ -870,7 +870,7 @@ int srom_var_init(struct si_pub *sih, uint bustype, void *curmap,
 	if (curmap != NULL && bustype == PCI_BUS)
 		return initvars_srom_pci(sih, curmap, vars, count);
 
-	return -1;
+	return -EINVAL;
 }
 
 /* In chips with chipcommon rev 32 and later, the srom is in chipcommon,
@@ -935,7 +935,7 @@ sprom_read_pci(struct si_pub *sih, u16 *sprom, uint wordoff,
 		if (sih->ccrev > 31 && ISSIM_ENAB(sih)) {
 			/* use indirect since direct is too slow on QT */
 			if ((sih->cccaps & CC_CAP_SROM) == 0)
-				return 1;
+				return -ENODEV;
 
 			ccregs = (void *)((u8 *) sprom - CC_SROM_OTP);
 			buf[i] =
@@ -953,7 +953,7 @@ sprom_read_pci(struct si_pub *sih, u16 *sprom, uint wordoff,
 
 	/* bypass crc checking for simulation to allow srom hack */
 	if (ISSIM_ENAB(sih))
-		return err;
+		return 0;
 
 	if (check_crc) {
 
@@ -962,7 +962,7 @@ sprom_read_pci(struct si_pub *sih, u16 *sprom, uint wordoff,
 			 * is blank, regardless of the rest of the content, so declare
 			 * it bad.
 			 */
-			return 1;
+			return -ENODATA;
 		}
 
 		/* fixup the endianness so crc8 will pass */
@@ -970,7 +970,7 @@ sprom_read_pci(struct si_pub *sih, u16 *sprom, uint wordoff,
 		if (brcmu_crc8((u8 *) buf, nwords * 2, CRC8_INIT_VALUE) !=
 		    CRC8_GOOD_VALUE) {
 			/* DBG only pci always read srom4 first, then srom8/9 */
-			err = 1;
+			err = -EIO;
 		}
 		/* now correct the endianness of the byte array */
 		ltoh16_buf(buf, nwords * 2);
@@ -987,7 +987,7 @@ static int otp_read_pci(struct si_pub *sih, u16 *buf, uint bufsz)
 
 	otp = kzalloc(OTP_SZ_MAX, GFP_ATOMIC);
 	if (otp == NULL) {
-		return -EBADE;
+		return -ENOMEM;
 	}
 
 	err = otp_read_region(sih, OTP_HW_RGN, (u16 *) otp, &sz);
@@ -1002,14 +1002,14 @@ static int otp_read_pci(struct si_pub *sih, u16 *buf, uint bufsz)
 		 * is blank, regardless of the rest of the content, so declare
 		 * it bad.
 		 */
-		return 1;
+		return -ENODATA;
 	}
 
 	/* fixup the endianness so crc8 will pass */
 	htol16_buf(buf, bufsz);
 	if (brcmu_crc8((u8 *) buf, SROM4_WORDS * 2, CRC8_INIT_VALUE) !=
 	    CRC8_GOOD_VALUE) {
-		err = 1;
+		err = -EIO;
 	}
 	/* now correct the endianness of the byte array */
 	ltoh16_buf(buf, bufsz);
@@ -1219,13 +1219,12 @@ static int initvars_srom_pci(struct si_pub *sih, void *curmap, char **vars,
 	 */
 	srom = kmalloc(SROM_MAX, GFP_ATOMIC);
 	if (!srom)
-		return -2;
+		return -ENOMEM;
 
 	sromwindow = (u16 *) SROM_OFFSET(sih);
 	if (ai_is_sprom_available(sih)) {
-		err =
-		    sprom_read_pci(sih, sromwindow, 0, srom, SROM_WORDS,
-				   true);
+		err = sprom_read_pci(sih, sromwindow, 0, srom, SROM_WORDS,
+				     true);
 
 		if ((srom[SROM4_SIGN] == SROM4_SIGNATURE) ||
 		    (((sih->buscoretype == PCIE_CORE_ID)
@@ -1233,9 +1232,8 @@ static int initvars_srom_pci(struct si_pub *sih, void *curmap, char **vars,
 		     || ((sih->buscoretype == PCI_CORE_ID)
 			 && (sih->buscorerev >= 0xe)))) {
 			/* sromrev >= 4, read more */
-			err =
-			    sprom_read_pci(sih, sromwindow, 0, srom,
-					   SROM4_WORDS, true);
+			err = sprom_read_pci(sih, sromwindow, 0, srom,
+					     SROM4_WORDS, true);
 			sromrev = srom[SROM4_CRCREV] & 0xff;
 		} else if (err == 0) {
 			/* srom is good and is rev < 4 */
@@ -1253,12 +1251,10 @@ static int initvars_srom_pci(struct si_pub *sih, void *curmap, char **vars,
 		if (err == 0)
 			/* OTP only contain SROM rev8/rev9 for now */
 			sromrev = srom[SROM4_CRCREV] & 0xff;
-		else
-			err = 1;
 	}
 #else
 	else
-		err = 1;
+		err = -ENODEV;
 #endif
 
 	if (!err) {
@@ -1267,13 +1263,13 @@ static int initvars_srom_pci(struct si_pub *sih, void *curmap, char **vars,
 
 		/* srom version check: Current valid versions: 1, 2, 3, 4, 5, 8, 9 */
 		if ((sr & 0x33e) == 0) {
-			err = -2;
+			err = -EINVAL;
 			goto errout;
 		}
 
 		base = kmalloc(MAXSZ_NVRAM_VARS, GFP_ATOMIC);
 		if (!base) {
-			err = -2;
+			err = -ENOMEM;
 			goto errout;
 		}
 
-- 
1.7.1


