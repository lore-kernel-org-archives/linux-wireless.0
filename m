Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2126 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab1IBOAz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Sep 2011 10:00:55 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 12/12] staging: brcm80211: cleaned up softmac srom macro
Date: Fri, 2 Sep 2011 16:00:39 +0200
Message-ID: <1314972039-27098-13-git-send-email-rvossen@broadcom.com> (sfid-20110902_160059_712541_A26E832B)
In-Reply-To: <1314972039-27098-1-git-send-email-rvossen@broadcom.com>
References: <1314972039-27098-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Substituted macro.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/srom.c |   22 +++++++++-------------
 1 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/srom.c b/drivers/staging/brcm80211/brcmsmac/srom.c
index c8f6897..165b88d 100644
--- a/drivers/staging/brcm80211/brcmsmac/srom.c
+++ b/drivers/staging/brcm80211/brcmsmac/srom.c
@@ -28,18 +28,6 @@
 #include "otp.h"
 #include "srom.h"
 
-#define SROM_OFFSET(sih) ((sih->ccrev > 31) ? \
-	(((sih->cccaps & CC_CAP_SROM) == 0) ? NULL : \
-	 ((u8 *)curmap + PCI_16KB0_CCREGS_OFFSET + CC_SROM_OTP)) : \
-	((u8 *)curmap + PCI_BAR0_SPROM_OFFSET))
-
-#if defined(BCMDBG)
-/* 500 ms after write enable/disable toggle */
-#define WRITE_ENABLE_DELAY	500
-/* 20 ms between each word write */
-#define WRITE_WORD_DELAY	20
-#endif
-
 /*
  * SROM CRC8 polynomial value:
  *
@@ -792,6 +780,14 @@ static const struct brcms_sromvar perpath_pci_sromvars[] = {
 
 static u8 srom_crc8_table[CRC8_TABLE_SIZE];
 
+static u8 *srom_window_address(struct si_pub *sih, void *curmap)
+{
+	return sih->ccrev > 31 ?
+	       (((sih->cccaps & CC_CAP_SROM) == 0) ? NULL :
+	       ((u8 *)curmap + PCI_16KB0_CCREGS_OFFSET + CC_SROM_OTP)) :
+	       ((u8 *)curmap + PCI_BAR0_SPROM_OFFSET);
+}
+
 /* Parse SROM and create name=value pairs. 'srom' points to
  * the SROM word array. 'off' specifies the offset of the
  * first word 'srom' points to, which should be either 0 or
@@ -1147,7 +1143,7 @@ static int initvars_srom_pci(struct si_pub *sih, void *curmap, char **vars,
 	if (!srom)
 		return -ENOMEM;
 
-	sromwindow = (u16 *) SROM_OFFSET(sih);
+	sromwindow = (u16 *) srom_window_address(sih, curmap);
 
 	crc8_populate_lsb(srom_crc8_table, SROM_CRC8_POLY);
 	if (ai_is_sprom_available(sih)) {
-- 
1.7.4.1


