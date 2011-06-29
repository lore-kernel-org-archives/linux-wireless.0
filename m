Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2067 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757960Ab1F2Xss (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:48 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 003/119] staging: brcm80211: remove flash related code
 from initvars_srom_pci()
Date: Wed, 29 Jun 2011 16:46:27 -0700
Message-ID: <1309391303-22741-4-git-send-email-frankyl@broadcom.com> (sfid-20110630_015023_586238_EBD82A8B)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The function initvars_srom_pci() has fallback to obtain drivers settings
from flash when no srom device is present. However, this driver does not
support flash so the fallback code can be removed.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/srom.c |   67 ++++++++---------------------
 1 files changed, 18 insertions(+), 49 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/srom.c b/drivers/staging/brcm80211/brcmsmac/srom.c
index 1117f91..5b5306a 100644
--- a/drivers/staging/brcm80211/brcmsmac/srom.c
+++ b/drivers/staging/brcm80211/brcmsmac/srom.c
@@ -1212,14 +1212,10 @@ static int initvars_srom_pci(struct si_pub *sih, void *curmap, char **vars,
 	u32 sr;
 	varbuf_t b;
 	char *vp, *base = NULL;
-	bool flash = false;
 	int err = 0;
 
 	/*
-	 * Apply CRC over SROM content regardless SROM is present or not,
-	 * and use variable <devpath>sromrev's existence in flash to decide
-	 * if we should return an error when CRC fails or read SROM variables
-	 * from flash.
+	 * Apply CRC over SROM content regardless SROM is present or not.
 	 */
 	srom = kmalloc(SROM_MAX, GFP_ATOMIC);
 	if (!srom)
@@ -1265,60 +1261,33 @@ static int initvars_srom_pci(struct si_pub *sih, void *curmap, char **vars,
 		err = 1;
 #endif
 
-	/*
-	 * We want internal/wltest driver to come up with default
-	 * sromvars so we can program a blank SPROM/OTP.
-	 */
-	if (err) {
-		char *value;
-		u32 val;
-		val = 0;
-
-		value = ai_getdevpathvar(sih, "sromrev");
-		if (value) {
-			sromrev = (u8) simple_strtoul(value, NULL, 0);
-			flash = true;
-			goto varscont;
-		}
+	if (!err) {
+		/* Bitmask for the sromrev */
+		sr = 1 << sromrev;
 
-		value = ai_getnvramflvar(sih, "sromrev");
-		if (value) {
-			err = 0;
+		/* srom version check: Current valid versions: 1, 2, 3, 4, 5, 8, 9 */
+		if ((sr & 0x33e) == 0) {
+			err = -2;
 			goto errout;
 		}
 
-		{
-			err = -1;
+		base = kmalloc(MAXSZ_NVRAM_VARS, GFP_ATOMIC);
+		if (!base) {
+			err = -2;
 			goto errout;
 		}
-	}
-
- varscont:
-	/* Bitmask for the sromrev */
-	sr = 1 << sromrev;
 
-	/* srom version check: Current valid versions: 1, 2, 3, 4, 5, 8, 9 */
-	if ((sr & 0x33e) == 0) {
-		err = -2;
-		goto errout;
-	}
-
-	base = kmalloc(MAXSZ_NVRAM_VARS, GFP_ATOMIC);
-	if (!base) {
-		err = -2;
-		goto errout;
-	}
+		varbuf_init(&b, base, MAXSZ_NVRAM_VARS);
 
-	varbuf_init(&b, base, MAXSZ_NVRAM_VARS);
+		/* parse SROM into name=value pairs. */
+		_initvars_srom_pci(sromrev, srom, 0, &b);
 
-	/* parse SROM into name=value pairs. */
-	_initvars_srom_pci(sromrev, srom, 0, &b);
+		/* final nullbyte terminator */
+		vp = b.buf;
+		*vp++ = '\0';
 
-	/* final nullbyte terminator */
-	vp = b.buf;
-	*vp++ = '\0';
-
-	err = initvars_table(base, vp, vars, count);
+		err = initvars_table(base, vp, vars, count);
+	}
 
 errout:
 	if (base)
-- 
1.7.1


