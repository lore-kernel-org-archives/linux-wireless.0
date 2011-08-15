Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2704 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753455Ab1HONem (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 09:34:42 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 06/15] staging: brcm80211: remove W_SM and R_SM macros
 from dma.c
Date: Mon, 15 Aug 2011 15:34:18 +0200
Message-ID: <1313415267-5264-7-git-send-email-arend@broadcom.com> (sfid-20110815_153449_087790_FFD152A5)
In-Reply-To: <1313415267-5264-1-git-send-email-arend@broadcom.com>
References: <1313415267-5264-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The macros W_SM and R_SM are not doing much conversion of the macro
parameters and complicate code readability without good cause. It
is more clear to remove usage of the macros expanding it in the source
code.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/dma.c |   54 ++++++++++++++----------------
 1 files changed, 25 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index 815329c..9ac3867 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -219,9 +219,6 @@ static uint dma_msg_level;
 
 #define	DI_INFO(dmah)	((dma_info_t *)dmah)
 
-#define R_SM(r)		(*(r))
-#define W_SM(r, v)	(*(r) = (v))
-
 /* One physical DMA segment */
 struct dma_seg {
 	unsigned long addr;
@@ -593,13 +590,12 @@ dma64_dd_upd(struct dma_info *di, struct dma64desc *ddring,
 #else
 	if ((di->dataoffsetlow == 0) || !(PHYSADDRLO(pa) & PCI32ADDR_HIGH)) {
 #endif				/* defined(__mips__) && defined(IL_BIGENDIAN) */
-
-		W_SM(&ddring[outidx].addrlow,
-		     BUS_SWAP32(PHYSADDRLO(pa) + di->dataoffsetlow));
-		W_SM(&ddring[outidx].addrhigh,
-		     BUS_SWAP32(PHYSADDRHI(pa) + di->dataoffsethigh));
-		W_SM(&ddring[outidx].ctrl1, BUS_SWAP32(*flags));
-		W_SM(&ddring[outidx].ctrl2, BUS_SWAP32(ctrl2));
+		ddring[outidx].addrlow =
+		     BUS_SWAP32(PHYSADDRLO(pa) + di->dataoffsetlow);
+		ddring[outidx].addrhigh =
+		     BUS_SWAP32(PHYSADDRHI(pa) + di->dataoffsethigh);
+		ddring[outidx].ctrl1 = BUS_SWAP32(*flags);
+		ddring[outidx].ctrl2 = BUS_SWAP32(ctrl2);
 	} else {
 		/* address extension for 32-bit PCI */
 		u32 ae;
@@ -608,17 +604,17 @@ dma64_dd_upd(struct dma_info *di, struct dma64desc *ddring,
 		PHYSADDRLO(pa) &= ~PCI32ADDR_HIGH;
 
 		ctrl2 |= (ae << D64_CTRL2_AE_SHIFT) & D64_CTRL2_AE;
-		W_SM(&ddring[outidx].addrlow,
-		     BUS_SWAP32(PHYSADDRLO(pa) + di->dataoffsetlow));
-		W_SM(&ddring[outidx].addrhigh,
-		     BUS_SWAP32(0 + di->dataoffsethigh));
-		W_SM(&ddring[outidx].ctrl1, BUS_SWAP32(*flags));
-		W_SM(&ddring[outidx].ctrl2, BUS_SWAP32(ctrl2));
+		ddring[outidx].addrlow =
+		     BUS_SWAP32(PHYSADDRLO(pa) + di->dataoffsetlow);
+		ddring[outidx].addrhigh =
+		     BUS_SWAP32(0 + di->dataoffsethigh);
+		ddring[outidx].ctrl1 = BUS_SWAP32(*flags);
+		ddring[outidx].ctrl2 = BUS_SWAP32(ctrl2);
 	}
 	if (di->dma.dmactrlflags & DMA_CTRL_PEN) {
 		if (DMA64_DD_PARITY(&ddring[outidx]))
-			W_SM(&ddring[outidx].ctrl2,
-			     BUS_SWAP32(ctrl2 | D64_CTRL2_PARITY));
+			ddring[outidx].ctrl2 =
+			     BUS_SWAP32(ctrl2 | D64_CTRL2_PARITY);
 	}
 }
 
@@ -1369,8 +1365,8 @@ int dma_txfast(struct dma_pub *pub, struct sk_buff *p0, bool commit)
 
 	/* if last txd eof not set, fix it */
 	if (!(flags & D64_CTRL1_EOF))
-		W_SM(&di->txd64[PREVTXD(txout)].ctrl1,
-		     BUS_SWAP32(flags | D64_CTRL1_IOC | D64_CTRL1_EOF));
+		di->txd64[PREVTXD(txout)].ctrl1 =
+		     BUS_SWAP32(flags | D64_CTRL1_IOC | D64_CTRL1_EOF);
 
 	/* save the packet */
 	di->txp[PREVTXD(txout)] = p0;
@@ -1456,10 +1452,10 @@ struct sk_buff *dma_getnexttxp(struct dma_pub *pub, enum txd_range range)
 		uint size, j, nsegs;
 
 		PHYSADDRLOSET(pa,
-			      (BUS_SWAP32(R_SM(&di->txd64[i].addrlow)) -
+			      (BUS_SWAP32(di->txd64[i].addrlow) -
 			       di->dataoffsetlow));
 		PHYSADDRHISET(pa,
-			      (BUS_SWAP32(R_SM(&di->txd64[i].addrhigh)) -
+			      (BUS_SWAP32(di->txd64[i].addrhigh) -
 			       di->dataoffsethigh));
 
 		if (DMASGLIST_ENAB) {
@@ -1468,14 +1464,14 @@ struct sk_buff *dma_getnexttxp(struct dma_pub *pub, enum txd_range range)
 			nsegs = map->nsegs;
 		} else {
 			size =
-			    (BUS_SWAP32(R_SM(&di->txd64[i].ctrl2)) &
+			    (BUS_SWAP32(di->txd64[i].ctrl2) &
 			     D64_CTRL2_BC_MASK);
 			nsegs = 1;
 		}
 
 		for (j = nsegs; j > 0; j--) {
-			W_SM(&di->txd64[i].addrlow, 0xdeadbeef);
-			W_SM(&di->txd64[i].addrhigh, 0xdeadbeef);
+			di->txd64[i].addrlow = 0xdeadbeef;
+			di->txd64[i].addrhigh = 0xdeadbeef;
 
 			txp = di->txp[i];
 			di->txp[i] = NULL;
@@ -1524,17 +1520,17 @@ static struct sk_buff *dma64_getnextrxp(struct dma_info *di, bool forceall)
 	di->rxp[i] = NULL;
 
 	PHYSADDRLOSET(pa,
-		      (BUS_SWAP32(R_SM(&di->rxd64[i].addrlow)) -
+		      (BUS_SWAP32(di->rxd64[i].addrlow) -
 		       di->dataoffsetlow));
 	PHYSADDRHISET(pa,
-		      (BUS_SWAP32(R_SM(&di->rxd64[i].addrhigh)) -
+		      (BUS_SWAP32(di->rxd64[i].addrhigh) -
 		       di->dataoffsethigh));
 
 	/* clear this packet from the descriptor ring */
 	pci_unmap_single(di->pbus, pa, di->rxbufsize, PCI_DMA_FROMDEVICE);
 
-	W_SM(&di->rxd64[i].addrlow, 0xdeadbeef);
-	W_SM(&di->rxd64[i].addrhigh, 0xdeadbeef);
+	di->rxd64[i].addrlow = 0xdeadbeef;
+	di->rxd64[i].addrhigh = 0xdeadbeef;
 
 	di->rxin = NEXTRXD(i);
 
-- 
1.7.4.1


