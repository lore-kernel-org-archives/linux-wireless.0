Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2820 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807Ab1HHN70 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:26 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 39/82] staging: brcm80211: remove MIPS specific 'sync'
 instruction in fullmac
Date: Mon, 8 Aug 2011 15:58:23 +0200
Message-ID: <1312811946-16713-40-git-send-email-arend@broadcom.com> (sfid-20110808_160231_006208_8E71DDB6)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

This instruction was required for the bcm4716/bcm4322, but since the
fullmac driver only supports bcm4329, it could be removed. After that,
the R_REG macro's were identical and thus were reduced to just 1 R_REG
macro.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 8576e33..77ac59f 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -35,26 +35,8 @@
 #include "sdio_host.h"
 
 /* register access macros */
-#ifndef __BIG_ENDIAN
-#ifndef __mips__
 #define R_REG(r, typ) \
 	brcmf_sdcard_reg_read(NULL, (r), sizeof(typ))
-#else				/* __mips__ */
-#define R_REG(r, typ) \
-	({ \
-		__typeof(*(r)) __osl_v; \
-		__asm__ __volatile__("sync"); \
-		__osl_v = brcmf_sdcard_reg_read(NULL, (r),\
-					  sizeof(typ)); \
-		__asm__ __volatile__("sync"); \
-		__osl_v; \
-	})
-#endif				/* __mips__ */
-
-#else				/* __BIG_ENDIAN */
-#define R_REG(r, typ) \
-	brcmf_sdcard_reg_read(NULL, (r), sizeof(typ))
-#endif				/* __BIG_ENDIAN */
 
 #define OR_REG(r, v, typ) \
 	brcmf_sdcard_reg_write(NULL, (r), sizeof(typ), R_REG(r, typ) | (v))
-- 
1.7.4.1


