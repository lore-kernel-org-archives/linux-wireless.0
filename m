Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1249 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757515Ab1JRMD2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 08:03:28 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 10/15] brcm80211: smac: avoid sprom endianess
 conversions for crc8 check
Date: Tue, 18 Oct 2011 14:03:06 +0200
Message-ID: <1318939391-19495-11-git-send-email-arend@broadcom.com> (sfid-20111018_140338_217294_9210317C)
In-Reply-To: <1318939391-19495-1-git-send-email-arend@broadcom.com>
References: <1318939391-19495-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The data from the sprom consists of u16 values stored in little
endian notation over which a crc8 was determined. To validate this
the buffer needed to be converted for big-endian systems. Reading
the sprom data is now done per byte so conversion is only done
after a successful crc8 check.

Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/srom.c |   69 ++++++++++-------------
 1 files changed, 30 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/srom.c b/drivers/net/wireless/brcm80211/brcmsmac/srom.c
index a884fe0..66aa0e7 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/srom.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/srom.c
@@ -586,14 +586,13 @@ static const struct brcms_sromvar perpath_pci_sromvars[] = {
  * shared between devices. */
 static u8 brcms_srom_crc8_table[CRC8_TABLE_SIZE];
 
-static u16 __iomem *
+static u8 __iomem *
 srom_window_address(struct si_pub *sih, u8 __iomem *curmap)
 {
 	if (sih->ccrev < 32)
-		return (u16 __iomem *)(curmap + PCI_BAR0_SPROM_OFFSET);
+		return curmap + PCI_BAR0_SPROM_OFFSET;
 	if (sih->cccaps & CC_CAP_SROM)
-		return (u16 __iomem *)
-		       (curmap + PCI_16KB0_CCREGS_OFFSET + CC_SROM_OTP);
+		return curmap + PCI_16KB0_CCREGS_OFFSET + CC_SROM_OTP;
 
 	return NULL;
 }
@@ -782,37 +781,34 @@ _initvars_srom_pci(u8 sromrev, u16 *srom, struct list_head *var_list)
  * Return 0 on success, nonzero on error.
  */
 static int
-sprom_read_pci(struct si_pub *sih, u16 __iomem *sprom, uint wordoff,
+sprom_read_pci(struct si_pub *sih, u8 __iomem *sprom, uint wordoff,
 	       u16 *buf, uint nwords, bool check_crc)
 {
 	int err = 0;
 	uint i;
+	u8 *bbuf = (u8 *)buf; /* byte buffer */
+	uint nbytes = nwords << 1;
 
-	/* read the sprom */
-	for (i = 0; i < nwords; i++)
-		buf[i] = R_REG(&sprom[wordoff + i]);
+	/* read the sprom in bytes */
+	for (i = 0; i < nbytes; i++)
+		bbuf[i] = readb(sprom+i);
 
-	if (check_crc) {
-
-		if (buf[0] == 0xffff)
-			/*
-			 * The hardware thinks that an srom that starts with
-			 * 0xffff is blank, regardless of the rest of the
-			 * content, so declare it bad.
-			 */
-			return -ENODATA;
-
-		/* fixup the endianness so crc8 will pass */
-		htol16_buf(buf, nwords * 2);
-		if (crc8(brcms_srom_crc8_table, (u8 *) buf, nwords * 2,
-			 CRC8_INIT_VALUE) !=
-			 CRC8_GOOD_VALUE(brcms_srom_crc8_table))
-			/* DBG only pci always read srom4 first, then srom8/9 */
-			err = -EIO;
+	if (buf[0] == 0xffff)
+		/*
+		 * The hardware thinks that an srom that starts with
+		 * 0xffff is blank, regardless of the rest of the
+		 * content, so declare it bad.
+		 */
+		return -ENODATA;
 
+	if (check_crc &&
+	    crc8(brcms_srom_crc8_table, bbuf, nbytes, CRC8_INIT_VALUE) !=
+		 CRC8_GOOD_VALUE(brcms_srom_crc8_table))
+		err = -EIO;
+	else
 		/* now correct the endianness of the byte array */
-		ltoh16_buf(buf, nwords * 2);
-	}
+		ltoh16_buf(buf, nbytes);
+
 	return err;
 }
 
@@ -859,7 +855,7 @@ static int otp_read_pci(struct si_pub *sih, u16 *buf, uint bufsz)
 static int initvars_srom_pci(struct si_pub *sih, void __iomem *curmap)
 {
 	u16 *srom;
-	u16 __iomem *sromwindow;
+	u8 __iomem *sromwindow;
 	u8 sromrev = 0;
 	u32 sr;
 	int err = 0;
@@ -875,18 +871,13 @@ static int initvars_srom_pci(struct si_pub *sih, void __iomem *curmap)
 
 	crc8_populate_lsb(brcms_srom_crc8_table, SROM_CRC8_POLY);
 	if (ai_is_sprom_available(sih)) {
-		err = sprom_read_pci(sih, sromwindow, 0, srom, SROM_WORDS,
-				     true);
-
-		if ((sih->buscoretype == PCIE_CORE_ID && sih->buscorerev >= 6)
-		     || (sih->buscoretype == PCI_CORE_ID &&
-			 sih->buscorerev >= 0xe)) {
-			err = sprom_read_pci(sih, sromwindow, 0, srom,
-					     SROM4_WORDS, true);
+		err = sprom_read_pci(sih, sromwindow, 0, srom,
+				     SROM4_WORDS, true);
+
+		if (err == 0)
+			/* srom read and passed crc */
+			/* top word of sprom contains version and crc8 */
 			sromrev = srom[SROM4_CRCREV] & 0xff;
-		} else {
-			err = -EIO;
-		}
 	} else {
 		/* Use OTP if SPROM not available */
 		err = otp_read_pci(sih, srom, SROM_MAX);
-- 
1.7.4.1


