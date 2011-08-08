Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3095 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224Ab1HHN7f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:35 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 61/82] staging: brcm80211: remove dma_addrwidth()
 function
Date: Mon, 8 Aug 2011 15:58:45 +0200
Message-ID: <1312811946-16713-62-git-send-email-arend@broadcom.com> (sfid-20110808_160043_066665_ED891D94)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function dma_addrwidth() always returns the same value so
it is redundant. As such it has been removed.

Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/dma.c  |   23 -----------------------
 drivers/staging/brcm80211/brcmsmac/dma.h  |    6 ------
 drivers/staging/brcm80211/brcmsmac/main.c |    7 -------
 3 files changed, 0 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index e662023..27b07ce 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -159,15 +159,9 @@
 #define D64_RX_FRM_STS_DSCRCNT	0x0f000000  /* no. of descriptors used - 1 */
 #define D64_RX_FRM_STS_DATATYPE	0xf0000000	/* core-dependent data type */
 
-#define	DMADDRWIDTH_30  30	/* 30-bit addressing capability */
-#define	DMADDRWIDTH_32  32	/* 32-bit addressing capability */
-#define	DMADDRWIDTH_63  63	/* 64-bit addressing capability */
-#define	DMADDRWIDTH_64  64	/* 64-bit addressing capability */
-
 #define DMA64_DD_PARITY(dd) \
 	parity32((dd)->addrlow ^ (dd)->addrhigh ^ (dd)->ctrl1 ^ (dd)->ctrl2)
 
-
 /*
  * packet headroom necessary to accommodate the largest header
  * in the system, (i.e TXOFF). By doing, we avoid the need to
@@ -1936,23 +1930,6 @@ static void dma64_txrotate(struct dma_info *di)
 	      di->xmtptrbase + I2B(di->txout, struct dma64desc));
 }
 
-uint dma_addrwidth(struct si_pub *sih, void *dmaregs)
-{
-	/* Perform 64-bit checks only if we want to advertise 64-bit (> 32bit) capability) */
-	/* DMA engine is 64-bit capable */
-	if ((ai_core_sflags(sih, 0, 0) & SISF_DMA64) == SISF_DMA64) {
-		/* backplane are 64-bit capable */
-		if (ai_backplane64(sih))
-			/* If bus is System Backplane or PCIE then we can access 64-bits */
-			if ((sih->bustype == SI_BUS) ||
-			    ((sih->bustype == PCI_BUS) &&
-			     (sih->buscoretype == PCIE_CORE_ID)))
-				return DMADDRWIDTH_64;
-	}
-	/* DMA hardware not supported by this driver */
-	return DMADDRWIDTH_64;
-}
-
 /*
  * Mac80211 initiated actions sometimes require packets in the DMA queue to be
  * modified. The modified portion of the packet is not under control of the DMA
diff --git a/drivers/staging/brcm80211/brcmsmac/dma.h b/drivers/staging/brcm80211/brcmsmac/dma.h
index 4a33028..f75a020 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.h
+++ b/drivers/staging/brcm80211/brcmsmac/dma.h
@@ -178,12 +178,6 @@ extern const struct di_fcn_s dma64proc;
 #define dma_txcommitted(di)		(dma64proc.txcommitted(di))
 
 
-/* return addresswidth allowed
- * This needs to be done after SB attach but before dma attach.
- * SB attach provides ability to probe backplane and dma core capabilities
- * This info is needed by DMA_ALLOC_CONSISTENT in dma attach
- */
-extern uint dma_addrwidth(struct si_pub *sih, void *dmaregs);
 void dma_walk_packets(struct dma_pub *dmah, void (*callback_fnc)
 		      (void *pkt, void *arg_a), void *arg_a);
 
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index d2551e9..e7a166f 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -861,14 +861,7 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 	snprintf(name, sizeof(name), "wl%d", unit);
 
 	if (wlc_hw->di[0] == 0) {	/* Init FIFOs */
-		uint addrwidth;
 		int dma_attach_err = 0;
-		/* Find out the DMA addressing capability and let OS know
-		 * All the channels within one DMA core have 'common-minimum' same
-		 * capability
-		 */
-		addrwidth =
-		    dma_addrwidth(wlc_hw->sih, DMAREG(wlc_hw, DMA_TX, 0));
 
 		/*
 		 * FIFO 0
-- 
1.7.4.1


