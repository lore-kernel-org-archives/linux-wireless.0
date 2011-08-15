Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2726 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481Ab1HONeo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 09:34:44 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 07/15] staging: brcm80211: remove PHYSADDR macro from
 dma.c
Date: Mon, 15 Aug 2011 15:34:19 +0200
Message-ID: <1313415267-5264-8-git-send-email-arend@broadcom.com> (sfid-20110815_153454_209192_FEE06685)
In-Reply-To: <1313415267-5264-1-git-send-email-arend@broadcom.com>
References: <1313415267-5264-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Four macros with PHYSADDR name prefix are not doing a lot and
complicate code readability. These have been expanded in the source
code and consequently removed the definitions.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/dma.c |   95 +++++++++---------------------
 1 files changed, 29 insertions(+), 66 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index 9ac3867..64d311f 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -196,14 +196,6 @@
 
 #define	DMA_NONE(args)
 
-#define PHYSADDRHI(_pa) (0)
-#define PHYSADDRHISET(_pa, _val)
-#define PHYSADDRLO(_pa) ((_pa))
-#define PHYSADDRLOSET(_pa, _val) \
-	do { \
-		(_pa) = (_val);			\
-	} while (0)
-
 #define d64txregs	dregs.d64_u.txregs_64
 #define d64rxregs	dregs.d64_u.rxregs_64
 #define txd64		dregs.d64_u.txd_64
@@ -522,16 +514,14 @@ struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 	}
 
 	if ((di->ddoffsetlow != 0) && !di->addrext) {
-		if (PHYSADDRLO(di->txdpa) > SI_PCI_DMA_SZ) {
+		if (di->txdpa > SI_PCI_DMA_SZ) {
 			DMA_ERROR(("%s: dma_attach: txdpa 0x%x: addrext not "
-				   "supported\n", di->name,
-				   (u32)PHYSADDRLO(di->txdpa)));
+				   "supported\n", di->name, (u32)di->txdpa));
 			goto fail;
 		}
-		if (PHYSADDRLO(di->rxdpa) > SI_PCI_DMA_SZ) {
+		if (di->rxdpa > SI_PCI_DMA_SZ) {
 			DMA_ERROR(("%s: dma_attach: rxdpa 0x%x: addrext not "
-				   "supported\n", di->name,
-				   (u32)PHYSADDRLO(di->rxdpa)));
+				   "supported\n", di->name, (u32)di->rxdpa));
 			goto fail;
 		}
 	}
@@ -586,28 +576,24 @@ dma64_dd_upd(struct dma_info *di, struct dma64desc *ddring,
 	/* PCI bus with big(>1G) physical address, use address extension */
 #if defined(__mips__) && defined(IL_BIGENDIAN)
 	if ((di->dataoffsetlow == SI_SDRAM_SWAPPED)
-	    || !(PHYSADDRLO(pa) & PCI32ADDR_HIGH)) {
+	    || !(pa & PCI32ADDR_HIGH)) {
 #else
-	if ((di->dataoffsetlow == 0) || !(PHYSADDRLO(pa) & PCI32ADDR_HIGH)) {
+	if ((di->dataoffsetlow == 0) || !(pa & PCI32ADDR_HIGH)) {
 #endif				/* defined(__mips__) && defined(IL_BIGENDIAN) */
-		ddring[outidx].addrlow =
-		     BUS_SWAP32(PHYSADDRLO(pa) + di->dataoffsetlow);
-		ddring[outidx].addrhigh =
-		     BUS_SWAP32(PHYSADDRHI(pa) + di->dataoffsethigh);
+		ddring[outidx].addrlow = BUS_SWAP32(pa + di->dataoffsetlow);
+		ddring[outidx].addrhigh = BUS_SWAP32(di->dataoffsethigh);
 		ddring[outidx].ctrl1 = BUS_SWAP32(*flags);
 		ddring[outidx].ctrl2 = BUS_SWAP32(ctrl2);
 	} else {
 		/* address extension for 32-bit PCI */
 		u32 ae;
 
-		ae = (PHYSADDRLO(pa) & PCI32ADDR_HIGH) >> PCI32ADDR_HIGH_SHIFT;
-		PHYSADDRLO(pa) &= ~PCI32ADDR_HIGH;
+		ae = (pa & PCI32ADDR_HIGH) >> PCI32ADDR_HIGH_SHIFT;
+		pa &= ~PCI32ADDR_HIGH;
 
 		ctrl2 |= (ae << D64_CTRL2_AE_SHIFT) & D64_CTRL2_AE;
-		ddring[outidx].addrlow =
-		     BUS_SWAP32(PHYSADDRLO(pa) + di->dataoffsetlow);
-		ddring[outidx].addrhigh =
-		     BUS_SWAP32(0 + di->dataoffsethigh);
+		ddring[outidx].addrlow = BUS_SWAP32(pa + di->dataoffsetlow);
+		ddring[outidx].addrhigh = BUS_SWAP32(di->dataoffsethigh);
 		ddring[outidx].ctrl1 = BUS_SWAP32(*flags);
 		ddring[outidx].ctrl2 = BUS_SWAP32(ctrl2);
 	}
@@ -716,45 +702,36 @@ _dma_ddtable_init(struct dma_info *di, uint direction, unsigned long pa)
 {
 	if (!di->aligndesc_4k) {
 		if (direction == DMA_TX)
-			di->xmtptrbase = PHYSADDRLO(pa);
+			di->xmtptrbase = pa;
 		else
-			di->rcvptrbase = PHYSADDRLO(pa);
+			di->rcvptrbase = pa;
 	}
 
 	if ((di->ddoffsetlow == 0)
-	    || !(PHYSADDRLO(pa) & PCI32ADDR_HIGH)) {
+	    || !(pa & PCI32ADDR_HIGH)) {
 		if (direction == DMA_TX) {
-			W_REG(&di->d64txregs->addrlow,
-			      (PHYSADDRLO(pa) + di->ddoffsetlow));
-			W_REG(&di->d64txregs->addrhigh,
-			      (PHYSADDRHI(pa) + di->ddoffsethigh));
+			W_REG(&di->d64txregs->addrlow, pa + di->ddoffsetlow);
+			W_REG(&di->d64txregs->addrhigh, di->ddoffsethigh);
 		} else {
-			W_REG(&di->d64rxregs->addrlow,
-			      (PHYSADDRLO(pa) + di->ddoffsetlow));
-			W_REG(&di->d64rxregs->addrhigh,
-				(PHYSADDRHI(pa) + di->ddoffsethigh));
+			W_REG(&di->d64rxregs->addrlow, pa + di->ddoffsetlow);
+			W_REG(&di->d64rxregs->addrhigh, di->ddoffsethigh);
 		}
 	} else {
 		/* DMA64 32bits address extension */
 		u32 ae;
 
 		/* shift the high bit(s) from pa to ae */
-		ae = (PHYSADDRLO(pa) & PCI32ADDR_HIGH) >>
-		    PCI32ADDR_HIGH_SHIFT;
-		PHYSADDRLO(pa) &= ~PCI32ADDR_HIGH;
+		ae = (pa & PCI32ADDR_HIGH) >> PCI32ADDR_HIGH_SHIFT;
+		pa &= ~PCI32ADDR_HIGH;
 
 		if (direction == DMA_TX) {
-			W_REG(&di->d64txregs->addrlow,
-			      (PHYSADDRLO(pa) + di->ddoffsetlow));
-			W_REG(&di->d64txregs->addrhigh,
-			      di->ddoffsethigh);
+			W_REG(&di->d64txregs->addrlow, pa + di->ddoffsetlow);
+			W_REG(&di->d64txregs->addrhigh, di->ddoffsethigh);
 			SET_REG(&di->d64txregs->control,
 				D64_XC_AE, (ae << D64_XC_AE_SHIFT));
 		} else {
-			W_REG(&di->d64rxregs->addrlow,
-			      (PHYSADDRLO(pa) + di->ddoffsetlow));
-			W_REG(&di->d64rxregs->addrhigh,
-			      di->ddoffsethigh);
+			W_REG(&di->d64rxregs->addrlow, pa + di->ddoffsetlow);
+			W_REG(&di->d64rxregs->addrhigh, di->ddoffsethigh);
 			SET_REG(&di->d64rxregs->control,
 				D64_RC_AE, (ae << D64_RC_AE_SHIFT));
 		}
@@ -1196,9 +1173,7 @@ static bool dma64_alloc(struct dma_info *di, uint direction)
 		di->txd64 = (struct dma64desc *)
 					roundup((unsigned long)va, align);
 		di->txdalign = (uint) ((s8 *)di->txd64 - (s8 *) va);
-		PHYSADDRLOSET(di->txdpa,
-			      PHYSADDRLO(di->txdpaorig) + di->txdalign);
-		PHYSADDRHISET(di->txdpa, PHYSADDRHI(di->txdpaorig));
+		di->txdpa = di->txdpaorig + di->txdalign;
 		di->txdalloc = alloced;
 	} else {
 		va = dma_ringalloc(di, D64RINGALIGN, size, &align_bits,
@@ -1212,9 +1187,7 @@ static bool dma64_alloc(struct dma_info *di, uint direction)
 		di->rxd64 = (struct dma64desc *)
 					roundup((unsigned long)va, align);
 		di->rxdalign = (uint) ((s8 *)di->rxd64 - (s8 *) va);
-		PHYSADDRLOSET(di->rxdpa,
-			      PHYSADDRLO(di->rxdpaorig) + di->rxdalign);
-		PHYSADDRHISET(di->rxdpa, PHYSADDRHI(di->rxdpaorig));
+		di->rxdpa = di->rxdpaorig + di->rxdalign;
 		di->rxdalloc = alloced;
 	}
 
@@ -1451,12 +1424,7 @@ struct sk_buff *dma_getnexttxp(struct dma_pub *pub, enum txd_range range)
 		struct dma_seg_map *map = NULL;
 		uint size, j, nsegs;
 
-		PHYSADDRLOSET(pa,
-			      (BUS_SWAP32(di->txd64[i].addrlow) -
-			       di->dataoffsetlow));
-		PHYSADDRHISET(pa,
-			      (BUS_SWAP32(di->txd64[i].addrhigh) -
-			       di->dataoffsethigh));
+		pa = BUS_SWAP32(di->txd64[i].addrlow) - di->dataoffsetlow;
 
 		if (DMASGLIST_ENAB) {
 			map = &di->txp_dmah[i];
@@ -1519,12 +1487,7 @@ static struct sk_buff *dma64_getnextrxp(struct dma_info *di, bool forceall)
 	rxp = di->rxp[i];
 	di->rxp[i] = NULL;
 
-	PHYSADDRLOSET(pa,
-		      (BUS_SWAP32(di->rxd64[i].addrlow) -
-		       di->dataoffsetlow));
-	PHYSADDRHISET(pa,
-		      (BUS_SWAP32(di->rxd64[i].addrhigh) -
-		       di->dataoffsethigh));
+	pa = BUS_SWAP32(di->rxd64[i].addrlow) - di->dataoffsetlow;
 
 	/* clear this packet from the descriptor ring */
 	pci_unmap_single(di->pbus, pa, di->rxbufsize, PCI_DMA_FROMDEVICE);
-- 
1.7.4.1


