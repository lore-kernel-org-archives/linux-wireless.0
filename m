Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3066 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167Ab1IEIrz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Sep 2011 04:47:55 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH V2 12/12] staging: brcm80211: cleaned up softmac srom
 macro
Date: Mon, 5 Sep 2011 10:47:35 +0200
Message-ID: <1315212455-29426-1-git-send-email-rvossen@broadcom.com> (sfid-20110905_104802_012801_F1A561F2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Substituted macro.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reported-by: Joe Perches <joe@perches.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/srom.c |   24 +++++++++++-------------
 1 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/srom.c b/drivers/staging/brcm80211/brcmsmac/srom.c
index c8f6897..5bf0732 100644
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
@@ -792,6 +780,16 @@ static const struct brcms_sromvar perpath_pci_sromvars[] = {
 
 static u8 srom_crc8_table[CRC8_TABLE_SIZE];
 
+static u16 *srom_window_address(struct si_pub *sih, u8 *curmap)
+{
+	if (sih->ccrev < 32)
+		return (u16 *)(curmap + PCI_BAR0_SPROM_OFFSET);
+	if (sih->cccaps & CC_CAP_SROM)
+		return (u16 *)(curmap + PCI_16KB0_CCREGS_OFFSET + CC_SROM_OTP);
+
+	return NULL;
+}
+
 /* Parse SROM and create name=value pairs. 'srom' points to
  * the SROM word array. 'off' specifies the offset of the
  * first word 'srom' points to, which should be either 0 or
@@ -1147,7 +1145,7 @@ static int initvars_srom_pci(struct si_pub *sih, void *curmap, char **vars,
 	if (!srom)
 		return -ENOMEM;
 
-	sromwindow = (u16 *) SROM_OFFSET(sih);
+	sromwindow = srom_window_address(sih, curmap);
 
 	crc8_populate_lsb(srom_crc8_table, SROM_CRC8_POLY);
 	if (ai_is_sprom_available(sih)) {
-- 
1.7.4.1


