Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3081 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754624Ab1LLXPq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 18:15:46 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 03/15] brcm80211: smac: use bcma core access function in
 srom.c
Date: Mon, 12 Dec 2011 15:15:01 -0800
Message-ID: <1323731713-14942-4-git-send-email-frankyl@broadcom.com> (sfid-20111213_001613_885731_9DC84880)
In-Reply-To: <1323731713-14942-1-git-send-email-frankyl@broadcom.com>
References: <1323731713-14942-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The code in srom.c now uses the core access function provided by
BCMA so no need to pass __iomem pointer any longer.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |    2 +-
 drivers/net/wireless/brcm80211/brcmsmac/srom.c    |   50 ++++++--------------
 drivers/net/wireless/brcm80211/brcmsmac/srom.h    |    2 +-
 3 files changed, 17 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index a54cf32..bb12ebc 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -725,7 +725,7 @@ static struct si_info *ai_doattach(struct si_info *sii,
 		goto exit;
 
 	/* Init nvram from sprom/otp if they exist */
-	if (srom_var_init(&sii->pub, cc))
+	if (srom_var_init(&sii->pub))
 		goto exit;
 
 	ai_nvram_process(sii);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/srom.c b/drivers/net/wireless/brcm80211/brcmsmac/srom.c
index 95eb620..6109215 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/srom.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/srom.c
@@ -586,17 +586,6 @@ static const struct brcms_sromvar perpath_pci_sromvars[] = {
  * shared between devices. */
 static u8 brcms_srom_crc8_table[CRC8_TABLE_SIZE];
 
-static u8 __iomem *
-srom_window_address(struct si_pub *sih, u8 __iomem *curmap)
-{
-	if (ai_get_ccrev(sih) < 32)
-		return curmap + PCI_BAR0_SPROM_OFFSET;
-	if (ai_get_cccaps(sih) & CC_CAP_SROM)
-		return curmap + PCI_16KB0_CCREGS_OFFSET + CC_SROM_OTP;
-
-	return NULL;
-}
-
 static uint mask_shift(u16 mask)
 {
 	uint i;
@@ -779,17 +768,27 @@ _initvars_srom_pci(u8 sromrev, u16 *srom, struct list_head *var_list)
  * Return 0 on success, nonzero on error.
  */
 static int
-sprom_read_pci(struct si_pub *sih, u8 __iomem *sprom, uint wordoff,
-	       u16 *buf, uint nwords, bool check_crc)
+sprom_read_pci(struct si_pub *sih, u16 *buf, uint nwords, bool check_crc)
 {
 	int err = 0;
 	uint i;
 	u8 *bbuf = (u8 *)buf; /* byte buffer */
 	uint nbytes = nwords << 1;
+	struct bcma_device *core;
+	uint sprom_offset;
+
+	/* determine core to read */
+	if (ai_get_ccrev(sih) < 32) {
+		core = ai_findcore(sih, BCMA_CORE_80211, 0);
+		sprom_offset = PCI_BAR0_SPROM_OFFSET;
+	} else {
+		core = ai_findcore(sih, BCMA_CORE_CHIPCOMMON, 0);
+		sprom_offset = CHIPCREGOFFS(sromotp);
+	}
 
 	/* read the sprom in bytes */
 	for (i = 0; i < nbytes; i++)
-		bbuf[i] = readb(sprom+i);
+		bbuf[i] = bcma_read8(core, sprom_offset+i);
 
 	if (buf[0] == 0xffff)
 		/*
@@ -851,10 +850,9 @@ static int otp_read_pci(struct si_pub *sih, u16 *buf, uint nwords)
  * Initialize nonvolatile variable table from sprom.
  * Return 0 on success, nonzero on error.
  */
-static int initvars_srom_pci(struct si_pub *sih, void __iomem *curmap)
+int srom_var_init(struct si_pub *sih)
 {
 	u16 *srom;
-	u8 __iomem *sromwindow;
 	u8 sromrev = 0;
 	u32 sr;
 	int err = 0;
@@ -866,12 +864,9 @@ static int initvars_srom_pci(struct si_pub *sih, void __iomem *curmap)
 	if (!srom)
 		return -ENOMEM;
 
-	sromwindow = srom_window_address(sih, curmap);
-
 	crc8_populate_lsb(brcms_srom_crc8_table, SROM_CRC8_POLY);
 	if (ai_is_sprom_available(sih)) {
-		err = sprom_read_pci(sih, sromwindow, 0, srom,
-				     SROM4_WORDS, true);
+		err = sprom_read_pci(sih, srom, SROM4_WORDS, true);
 
 		if (err == 0)
 			/* srom read and passed crc */
@@ -921,21 +916,6 @@ void srom_free_vars(struct si_pub *sih)
 		kfree(entry);
 	}
 }
-/*
- * Initialize local vars from the right source for this platform.
- * Return 0 on success, nonzero on error.
- */
-int srom_var_init(struct si_pub *sih, void __iomem *curmap)
-{
-	uint len;
-
-	len = 0;
-
-	if (curmap != NULL)
-		return initvars_srom_pci(sih, curmap);
-
-	return -EINVAL;
-}
 
 /*
  * Search the name=value vars for a specific one and return its value.
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/srom.h b/drivers/net/wireless/brcm80211/brcmsmac/srom.h
index c81df97..f2a58f2 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/srom.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/srom.h
@@ -20,7 +20,7 @@
 #include "types.h"
 
 /* Prototypes */
-extern int srom_var_init(struct si_pub *sih, void __iomem *curmap);
+extern int srom_var_init(struct si_pub *sih);
 extern void srom_free_vars(struct si_pub *sih);
 
 extern int srom_read(struct si_pub *sih, uint bus, void *curmap,
-- 
1.7.5.4


