Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4768 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755168Ab1HZNT5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 09:19:57 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 07/13] staging: brcm80211: removed unused code in dma.c
Date: Fri, 26 Aug 2011 15:19:34 +0200
Message-ID: <1314364780-9462-8-git-send-email-rvossen@broadcom.com> (sfid-20110826_152017_616069_2BCFC0CC)
In-Reply-To: <1314364780-9462-1-git-send-email-rvossen@broadcom.com>
References: <1314364780-9462-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. Preprocessor symbol BCMDMASGLISTOSL was never defined.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/dma.c |  138 +++++-------------------------
 1 files changed, 22 insertions(+), 116 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index 05dad9f..e53088e 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -207,18 +207,6 @@ static uint dma_msg_level;
 
 #define	DI_INFO(dmah)	((dma_info_t *)dmah)
 
-/* One physical DMA segment */
-struct dma_seg {
-	unsigned long addr;
-	u32 length;
-};
-
-struct dma_seg_map {
-	uint origsize;	/* Size of the virtual packet */
-	uint nsegs;
-	struct dma_seg segs[MAX_DMA_SEGS];
-};
-
 /*
  * DMA Descriptor
  * Descriptors are only read by the hardware, never written back.
@@ -261,7 +249,6 @@ struct dma_info {
 	u16 txout;		/* index of next descriptor to post */
 	/* pointer to parallel array of pointers to packets */
 	struct sk_buff **txp;
-	struct dma_seg_map *txp_dmah;	/* DMA MAP meta-data handle */
 	/* Aligned physical address of descriptor ring */
 	unsigned long txdpa;
 	/* Original physical address of descriptor ring */
@@ -278,7 +265,6 @@ struct dma_info {
 	u16 rxout;	/* index of next descriptor to post */
 	/* pointer to parallel array of pointers to packets */
 	struct sk_buff **rxp;
-	struct dma_seg_map *rxp_dmah;	/* DMA MAP meta-data handle */
 	/* Aligned physical address of descriptor ring */
 	unsigned long rxdpa;
 	/* Original physical address of descriptor ring */
@@ -312,16 +298,6 @@ struct dma_info {
 	bool aligndesc_4k;
 };
 
-/*
- * DMA Scatter-gather list is supported. Note this is limited to TX
- * direction only
- */
-#ifdef BCMDMASGLISTOSL
-#define DMASGLIST_ENAB true
-#else
-#define DMASGLIST_ENAB false
-#endif				/* BCMDMASGLISTOSL */
-
 /* descriptor bumping macros */
 /* faster than %, but n must be power of 2 */
 #define	XXD(x, n)	((x) & ((n) - 1))
@@ -524,23 +500,6 @@ struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 		   di->ddoffsethigh, di->dataoffsetlow, di->dataoffsethigh,
 		   di->addrext));
 
-	/* allocate DMA mapping vectors */
-	if (DMASGLIST_ENAB) {
-		if (ntxd) {
-			size = ntxd * sizeof(struct dma_seg_map);
-			di->txp_dmah = kzalloc(size, GFP_ATOMIC);
-			if (di->txp_dmah == NULL)
-				goto fail;
-		}
-
-		if (nrxd) {
-			size = nrxd * sizeof(struct dma_seg_map);
-			di->rxp_dmah = kzalloc(size, GFP_ATOMIC);
-			if (di->rxp_dmah == NULL)
-				goto fail;
-		}
-	}
-
 	return (struct dma_pub *) di;
 
  fail:
@@ -635,12 +594,6 @@ void dma_detach(struct dma_pub *pub)
 	kfree(di->txp);
 	kfree(di->rxp);
 
-	/* free tx packet DMA handles */
-	kfree(di->txp_dmah);
-
-	/* free rx packet DMA handles */
-	kfree(di->rxp_dmah);
-
 	/* free our private info structure */
 	kfree(di);
 
@@ -910,10 +863,6 @@ bool dma_rxfill(struct dma_pub *pub)
 		 */
 		*(u32 *) (p->data) = 0;
 
-		if (DMASGLIST_ENAB)
-			memset(&di->rxp_dmah[rxout], 0,
-				sizeof(struct dma_seg_map));
-
 		pa = pci_map_single(di->pbus, p->data,
 			di->rxbufsize, PCI_DMA_FROMDEVICE);
 
@@ -1265,9 +1214,6 @@ int dma_txfast(struct dma_pub *pub, struct sk_buff *p0, bool commit)
 	 * allocating and initializing transmit descriptor entries.
 	 */
 	for (p = p0; p; p = next) {
-		uint nsegs, j;
-		struct dma_seg_map *map;
-
 		data = p->data;
 		len = p->len;
 		next = p->next;
@@ -1280,53 +1226,25 @@ int dma_txfast(struct dma_pub *pub, struct sk_buff *p0, bool commit)
 			continue;
 
 		/* get physical address of buffer start */
-		if (DMASGLIST_ENAB)
-			memset(&di->txp_dmah[txout], 0,
-				sizeof(struct dma_seg_map));
-
 		pa = pci_map_single(di->pbus, data, len, PCI_DMA_TODEVICE);
 
-		if (DMASGLIST_ENAB) {
-			map = &di->txp_dmah[txout];
-
-			/* See if all the segments can be accounted for */
-			if (map->nsegs >
-			    (uint) (di->ntxd - NTXDACTIVE(di->txin, di->txout) -
-				    1))
-				goto outoftxd;
-
-			nsegs = map->nsegs;
-		} else
-			nsegs = 1;
-
-		for (j = 1; j <= nsegs; j++) {
-			flags = 0;
-			if (p == p0 && j == 1)
-				flags |= D64_CTRL1_SOF;
+		flags = 0;
+		if (p == p0)
+			flags |= D64_CTRL1_SOF;
 
-			/* With a DMA segment list, Descriptor table is filled
-			 * using the segment list instead of looping over
-			 * buffers in multi-chain DMA. Therefore, EOF for SGLIST
-			 * is when end of segment list is reached.
-			 */
-			if ((!DMASGLIST_ENAB && next == NULL) ||
-			    (DMASGLIST_ENAB && j == nsegs))
-				flags |= (D64_CTRL1_IOC | D64_CTRL1_EOF);
-			if (txout == (di->ntxd - 1))
-				flags |= D64_CTRL1_EOT;
-
-			if (DMASGLIST_ENAB) {
-				len = map->segs[j - 1].length;
-				pa = map->segs[j - 1].addr;
-			}
-			dma64_dd_upd(di, di->txd64, pa, txout, &flags, len);
+		/* With a DMA segment list, Descriptor table is filled
+		 * using the segment list instead of looping over
+		 * buffers in multi-chain DMA. Therefore, EOF for SGLIST
+		 * is when end of segment list is reached.
+		 */
+		if (next == NULL)
+			flags |= (D64_CTRL1_IOC | D64_CTRL1_EOF);
+		if (txout == (di->ntxd - 1))
+			flags |= D64_CTRL1_EOT;
 
-			txout = NEXTTXD(txout);
-		}
+		dma64_dd_upd(di, di->txd64, pa, txout, &flags, len);
 
-		/* See above. No need to loop over individual buffers */
-		if (DMASGLIST_ENAB)
-			break;
+		txout = NEXTTXD(txout);
 	}
 
 	/* if last txd eof not set, fix it */
@@ -1414,31 +1332,19 @@ struct sk_buff *dma_getnexttxp(struct dma_pub *pub, enum txd_range range)
 
 	for (i = start; i != end && !txp; i = NEXTTXD(i)) {
 		unsigned long pa;
-		struct dma_seg_map *map = NULL;
-		uint size, j, nsegs;
+		uint size;
 
 		pa = cpu_to_le32(di->txd64[i].addrlow) - di->dataoffsetlow;
 
-		if (DMASGLIST_ENAB) {
-			map = &di->txp_dmah[i];
-			size = map->origsize;
-			nsegs = map->nsegs;
-		} else {
-			size =
-			    (cpu_to_le32(di->txd64[i].ctrl2) &
-			     D64_CTRL2_BC_MASK);
-			nsegs = 1;
-		}
+		size =
+		    (cpu_to_le32(di->txd64[i].ctrl2) &
+		     D64_CTRL2_BC_MASK);
 
-		for (j = nsegs; j > 0; j--) {
-			di->txd64[i].addrlow = 0xdeadbeef;
-			di->txd64[i].addrhigh = 0xdeadbeef;
+		di->txd64[i].addrlow = 0xdeadbeef;
+		di->txd64[i].addrhigh = 0xdeadbeef;
 
-			txp = di->txp[i];
-			di->txp[i] = NULL;
-			if (j > 1)
-				i = NEXTTXD(i);
-		}
+		txp = di->txp[i];
+		di->txp[i] = NULL;
 
 		pci_unmap_single(di->pbus, pa, size, PCI_DMA_TODEVICE);
 	}
-- 
1.7.4.1


