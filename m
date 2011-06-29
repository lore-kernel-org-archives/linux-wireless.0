Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1912 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755436Ab1F2Xsm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:42 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 113/119] staging: brcm80211: W_REG macro cleanup in
 fullmac SDIO
Date: Wed, 29 Jun 2011 16:48:17 -0700
Message-ID: <1309391303-22741-114-git-send-email-frankyl@broadcom.com> (sfid-20110630_014905_342820_07F1F81C)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. W_REG was defined the same for both big and little endian systems.
Replaced W_REG on two spots with its expansion.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |   18 +++++-------------
 1 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index cdc57f9..ba57481 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -51,22 +51,13 @@
 	})
 #endif				/* __mips__ */
 
-#define W_REG(r, v, typ) do { \
-		brcmf_sdcard_reg_write(NULL, (r), sizeof(typ), (v)); \
-	} while (0)
 #else				/* __BIG_ENDIAN */
 #define R_REG(r, typ) \
 	brcmf_sdcard_reg_read(NULL, (r), sizeof(typ))
-#define W_REG(r, v, typ) do { \
-		brcmf_sdcard_reg_write(NULL, (r), sizeof(typ), (v)); \
-	} while (0)
 #endif				/* __BIG_ENDIAN */
 
-#define AND_REG(r, v, typ)	W_REG((r), R_REG(r, typ) & (v), typ)
-#define OR_REG(r, v, typ)	W_REG((r), R_REG(r, typ) | (v), typ)
-
-#define SET_REG(r, mask, val, typ) \
-		W_REG((r), ((R_REG(r) & ~(mask)) | (val)), typ)
+#define OR_REG(r, v, typ) \
+	brcmf_sdcard_reg_write(NULL, (r), sizeof(typ), R_REG(r, typ) | (v))
 
 #ifdef BCMDBG
 
@@ -609,7 +600,7 @@ struct brcmf_bus {
 	uint console_addr;	/* Console address from shared struct */
 #endif				/* BCMDBG */
 
-	uint regfails;		/* Count of R_REG/W_REG failures */
+	uint regfails;		/* Count of R_REG failures */
 
 	uint clkstate;		/* State of sd and backplane clock(s) */
 	bool activity;		/* Activity flag for clock down */
@@ -850,7 +841,8 @@ w_sdreg32(struct brcmf_bus *bus, u32 regval, u32 reg_offset, u32 *retryvar)
 {
 	*retryvar = 0;
 	do {
-		W_REG(bus->ci->buscorebase + reg_offset, regval, u32);
+		brcmf_sdcard_reg_write(NULL, bus->ci->buscorebase + reg_offset,
+				       sizeof(u32), regval);
 	} while (brcmf_sdcard_regfail(bus->card) &&
 		 (++(*retryvar) <= retry_limit));
 	if (*retryvar) {
-- 
1.7.1


