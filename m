Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3563 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472Ab1HONen (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 09:34:43 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 08/15] staging: brcm80211: replace BUS_SWAP32 macro with
 cpu_to_le32()
Date: Mon, 15 Aug 2011 15:34:20 +0200
Message-ID: <1313415267-5264-9-git-send-email-arend@broadcom.com> (sfid-20110815_153455_495165_97B57EA6)
In-Reply-To: <1313415267-5264-1-git-send-email-arend@broadcom.com>
References: <1313415267-5264-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The macro BUS_SWAP32(a) expanded to (a) which was fine for a little
endian system. For big endian platform this should do as the name
implies. As the driver is intended for PCI which is little-endian
the macro cpu_to_le32() can be used instead.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/dma.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index 64d311f..aa4d9cf 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -580,10 +580,10 @@ dma64_dd_upd(struct dma_info *di, struct dma64desc *ddring,
 #else
 	if ((di->dataoffsetlow == 0) || !(pa & PCI32ADDR_HIGH)) {
 #endif				/* defined(__mips__) && defined(IL_BIGENDIAN) */
-		ddring[outidx].addrlow = BUS_SWAP32(pa + di->dataoffsetlow);
-		ddring[outidx].addrhigh = BUS_SWAP32(di->dataoffsethigh);
-		ddring[outidx].ctrl1 = BUS_SWAP32(*flags);
-		ddring[outidx].ctrl2 = BUS_SWAP32(ctrl2);
+		ddring[outidx].addrlow = cpu_to_le32(pa + di->dataoffsetlow);
+		ddring[outidx].addrhigh = cpu_to_le32(di->dataoffsethigh);
+		ddring[outidx].ctrl1 = cpu_to_le32(*flags);
+		ddring[outidx].ctrl2 = cpu_to_le32(ctrl2);
 	} else {
 		/* address extension for 32-bit PCI */
 		u32 ae;
@@ -592,15 +592,15 @@ dma64_dd_upd(struct dma_info *di, struct dma64desc *ddring,
 		pa &= ~PCI32ADDR_HIGH;
 
 		ctrl2 |= (ae << D64_CTRL2_AE_SHIFT) & D64_CTRL2_AE;
-		ddring[outidx].addrlow = BUS_SWAP32(pa + di->dataoffsetlow);
-		ddring[outidx].addrhigh = BUS_SWAP32(di->dataoffsethigh);
-		ddring[outidx].ctrl1 = BUS_SWAP32(*flags);
-		ddring[outidx].ctrl2 = BUS_SWAP32(ctrl2);
+		ddring[outidx].addrlow = cpu_to_le32(pa + di->dataoffsetlow);
+		ddring[outidx].addrhigh = cpu_to_le32(di->dataoffsethigh);
+		ddring[outidx].ctrl1 = cpu_to_le32(*flags);
+		ddring[outidx].ctrl2 = cpu_to_le32(ctrl2);
 	}
 	if (di->dma.dmactrlflags & DMA_CTRL_PEN) {
 		if (DMA64_DD_PARITY(&ddring[outidx]))
 			ddring[outidx].ctrl2 =
-			     BUS_SWAP32(ctrl2 | D64_CTRL2_PARITY);
+			     cpu_to_le32(ctrl2 | D64_CTRL2_PARITY);
 	}
 }
 
@@ -1339,7 +1339,7 @@ int dma_txfast(struct dma_pub *pub, struct sk_buff *p0, bool commit)
 	/* if last txd eof not set, fix it */
 	if (!(flags & D64_CTRL1_EOF))
 		di->txd64[PREVTXD(txout)].ctrl1 =
-		     BUS_SWAP32(flags | D64_CTRL1_IOC | D64_CTRL1_EOF);
+		     cpu_to_le32(flags | D64_CTRL1_IOC | D64_CTRL1_EOF);
 
 	/* save the packet */
 	di->txp[PREVTXD(txout)] = p0;
@@ -1424,7 +1424,7 @@ struct sk_buff *dma_getnexttxp(struct dma_pub *pub, enum txd_range range)
 		struct dma_seg_map *map = NULL;
 		uint size, j, nsegs;
 
-		pa = BUS_SWAP32(di->txd64[i].addrlow) - di->dataoffsetlow;
+		pa = cpu_to_le32(di->txd64[i].addrlow) - di->dataoffsetlow;
 
 		if (DMASGLIST_ENAB) {
 			map = &di->txp_dmah[i];
@@ -1432,7 +1432,7 @@ struct sk_buff *dma_getnexttxp(struct dma_pub *pub, enum txd_range range)
 			nsegs = map->nsegs;
 		} else {
 			size =
-			    (BUS_SWAP32(di->txd64[i].ctrl2) &
+			    (cpu_to_le32(di->txd64[i].ctrl2) &
 			     D64_CTRL2_BC_MASK);
 			nsegs = 1;
 		}
@@ -1487,7 +1487,7 @@ static struct sk_buff *dma64_getnextrxp(struct dma_info *di, bool forceall)
 	rxp = di->rxp[i];
 	di->rxp[i] = NULL;
 
-	pa = BUS_SWAP32(di->rxd64[i].addrlow) - di->dataoffsetlow;
+	pa = cpu_to_le32(di->rxd64[i].addrlow) - di->dataoffsetlow;
 
 	/* clear this packet from the descriptor ring */
 	pci_unmap_single(di->pbus, pa, di->rxbufsize, PCI_DMA_FROMDEVICE);
-- 
1.7.4.1


