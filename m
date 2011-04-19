Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3823 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550Ab1DSJBg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 05:01:36 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 4/5] staging: brcm80211: removed ASSERTs from hnddma.c
 and sbutils.c
Date: Tue, 19 Apr 2011 11:01:15 +0200
Message-ID: <1303203676-20165-5-git-send-email-rvossen@broadcom.com>
In-Reply-To: <1303203676-20165-1-git-send-email-rvossen@broadcom.com>
References: <1303203676-20165-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/util/hnddma.c  |    2 --
 drivers/staging/brcm80211/util/sbutils.c |   16 +---------------
 2 files changed, 1 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/brcm80211/util/hnddma.c b/drivers/staging/brcm80211/util/hnddma.c
index 7d9a99d..f6b5df9 100644
--- a/drivers/staging/brcm80211/util/hnddma.c
+++ b/drivers/staging/brcm80211/util/hnddma.c
@@ -1644,8 +1644,6 @@ static void dma64_txrotate(dma_info_t *di)
 			  - di->xmtptrbase) & D64_XS1_AD_MASK), dma64dd_t));
 	rot = TXD(ad - di->txin);
 
-	ASSERT(rot < di->ntxd);
-
 	/* full-ring case is a lot harder - don't worry about this */
 	if (rot >= (di->ntxd - nactive)) {
 		DMA_ERROR(("%s: dma_txrotate: ring full - punt\n", di->name));
diff --git a/drivers/staging/brcm80211/util/sbutils.c b/drivers/staging/brcm80211/util/sbutils.c
index 21dde8e..9384055 100644
--- a/drivers/staging/brcm80211/util/sbutils.c
+++ b/drivers/staging/brcm80211/util/sbutils.c
@@ -95,7 +95,6 @@ static u32 _sb_coresba(si_info_t *sii)
 		sbaddr = (u32)(unsigned long)sii->curmap;
 		break;
 	default:
-		ASSERT(0);
 		break;
 	}
 
@@ -152,10 +151,6 @@ uint sb_corereg(si_t *sih, uint coreidx, uint regoff, uint mask, uint val)
 
 	sii = SI_INFO(sih);
 
-	ASSERT(GOODIDX(coreidx));
-	ASSERT(regoff < SI_CORE_SIZE);
-	ASSERT((val & ~mask) == 0);
-
 	if (coreidx >= SI_MAXCORES)
 		return 0;
 
@@ -169,7 +164,6 @@ uint sb_corereg(si_t *sih, uint coreidx, uint regoff, uint mask, uint val)
 		r = (u32 *) ((unsigned char *) sb_setcoreidx(&sii->pub, coreidx) +
 				regoff);
 	}
-	ASSERT(r != NULL);
 
 	/* mask and set */
 	if (mask || val) {
@@ -251,7 +245,6 @@ static uint _sb_scan(si_info_t *sii, u32 sba, void *regs, uint bus, u32 sbba,
 				/* Older chips */
 				SI_ERROR(("sb_chip2numcores: unsupported chip "
 						  "0x%x\n", sii->pub.chip));
-				ASSERT(0);
 				numcores = 1;
 			}
 
@@ -327,11 +320,8 @@ void *sb_setcoreidx(si_t *sih, uint coreidx)
 
 	/*
 	 * If the user has provided an interrupt mask enabled function,
-	 * then assert interrupts are disabled before switching the core.
+	 * then interrupts should be disabled before switching the core.
 	 */
-	ASSERT((sii->intrsenabled_fn == NULL)
-	       || !(*(sii)->intrsenabled_fn) ((sii)->intr_arg));
-
 	sii->curmap = _sb_setcoreidx(sii, coreidx);
 	sii->curidx = coreidx;
 
@@ -353,13 +343,11 @@ static void *_sb_setcoreidx(si_info_t *sii, uint coreidx)
 		/* map new one */
 		if (!sii->regs[coreidx]) {
 			sii->regs[coreidx] = (void *)sbaddr;
-			ASSERT(GOODREGS(sii->regs[coreidx]));
 		}
 		regs = sii->regs[coreidx];
 		break;
 #endif				/* BCMSDIO */
 	default:
-		ASSERT(0);
 		regs = NULL;
 		break;
 	}
@@ -375,7 +363,6 @@ void sb_core_disable(si_t *sih, u32 bits)
 
 	sii = SI_INFO(sih);
 
-	ASSERT(GOODREGS(sii->curmap));
 	sb = REGS2SB(sii->curmap);
 
 	/* if core is already in reset, just return */
@@ -433,7 +420,6 @@ void sb_core_reset(si_t *sih, u32 bits, u32 resetbits)
 	volatile u32 dummy;
 
 	sii = SI_INFO(sih);
-	ASSERT(GOODREGS(sii->curmap));
 	sb = REGS2SB(sii->curmap);
 
 	/*
-- 
1.7.1


