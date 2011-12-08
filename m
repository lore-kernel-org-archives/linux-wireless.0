Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2831 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984Ab1LHXHY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 18:07:24 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 16/23] brcm80211: smac: use DMA-API calls for descriptor
 allocations
Date: Thu, 8 Dec 2011 15:06:52 -0800
Message-ID: <1323385619-7454-17-git-send-email-frankyl@broadcom.com> (sfid-20111209_000739_530004_695FD6B2)
In-Reply-To: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
References: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Using BCMA hides the specifics about the host interface. The
driver is now using the DMA-API to do dma related calls. BCMA
provides the device object to use in the DMA-API calls.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/dma.c  |   47 +++++++++++++-----------
 drivers/net/wireless/brcm80211/brcmsmac/dma.h  |   10 +++--
 drivers/net/wireless/brcm80211/brcmsmac/main.c |    8 ++--
 3 files changed, 35 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/dma.c b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
index 3a60eb8..0c5f31b 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/dma.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
@@ -220,7 +220,8 @@ struct dma_info {
 	uint *msg_level;	/* message level pointer */
 	char name[MAXNAMEL];	/* callers name for diag msgs */
 
-	struct pci_dev *pbus;		/* bus handle */
+	struct bcma_device *d11core;
+	struct device *dmadev;
 
 	bool dma64;	/* this dma engine is operating in 64-bit mode */
 	bool addrext;	/* this dma engine supports DmaExtendedAddrChanges */
@@ -450,7 +451,7 @@ static bool _dma_descriptor_align(struct dma_info *di)
  * Descriptor table must start at the DMA hardware dictated alignment, so
  * allocated memory must be large enough to support this requirement.
  */
-static void *dma_alloc_consistent(struct pci_dev *pdev, uint size,
+static void *dma_alloc_consistent(struct dma_info *di, uint size,
 				  u16 align_bits, uint *alloced,
 				  dma_addr_t *pap)
 {
@@ -460,7 +461,7 @@ static void *dma_alloc_consistent(struct pci_dev *pdev, uint size,
 			size += align;
 		*alloced = size;
 	}
-	return pci_alloc_consistent(pdev, size, pap);
+	return dma_alloc_coherent(di->dmadev, size, pap, GFP_ATOMIC);
 }
 
 static
@@ -486,7 +487,7 @@ static void *dma_ringalloc(struct dma_info *di, u32 boundary, uint size,
 	u32 desc_strtaddr;
 	u32 alignbytes = 1 << *alignbits;
 
-	va = dma_alloc_consistent(di->pbus, size, *alignbits, alloced, descpa);
+	va = dma_alloc_consistent(di, size, *alignbits, alloced, descpa);
 
 	if (NULL == va)
 		return NULL;
@@ -495,8 +496,8 @@ static void *dma_ringalloc(struct dma_info *di, u32 boundary, uint size,
 	if (((desc_strtaddr + size - 1) & boundary) != (desc_strtaddr
 							& boundary)) {
 		*alignbits = dma_align_sizetobits(size);
-		pci_free_consistent(di->pbus, size, va, *descpa);
-		va = dma_alloc_consistent(di->pbus, size, *alignbits,
+		dma_free_coherent(di->dmadev, size, va, *descpa);
+		va = dma_alloc_consistent(di, size, *alignbits,
 			alloced, descpa);
 	}
 	return va;
@@ -556,10 +557,11 @@ static bool _dma_alloc(struct dma_info *di, uint direction)
 }
 
 struct dma_pub *dma_attach(char *name, struct si_pub *sih,
-		     void __iomem *dmaregstx, void __iomem *dmaregsrx,
-		     uint ntxd, uint nrxd,
-		     uint rxbufsize, int rxextheadroom,
-		     uint nrxpost, uint rxoffset, uint *msg_level)
+			   struct bcma_device *d11core,
+			   void __iomem *dmaregstx, void __iomem *dmaregsrx,
+			   uint ntxd, uint nrxd,
+			   uint rxbufsize, int rxextheadroom,
+			   uint nrxpost, uint rxoffset, uint *msg_level)
 {
 	struct dma_info *di;
 	uint size;
@@ -575,6 +577,7 @@ struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 	di->dma64 = ((ai_core_sflags(sih, 0, 0) & SISF_DMA64) == SISF_DMA64);
 
 	/* init dma reg pointer */
+	di->d11core = d11core;
 	di->d64txregs = (struct dma64regs __iomem *) dmaregstx;
 	di->d64rxregs = (struct dma64regs __iomem *) dmaregsrx;
 
@@ -594,7 +597,7 @@ struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 	strncpy(di->name, name, MAXNAMEL);
 	di->name[MAXNAMEL - 1] = '\0';
 
-	di->pbus = ((struct si_info *)sih)->pcibus;
+	di->dmadev = d11core->dma_dev;
 
 	/* save tunables */
 	di->ntxd = (u16) ntxd;
@@ -749,13 +752,13 @@ void dma_detach(struct dma_pub *pub)
 
 	/* free dma descriptor rings */
 	if (di->txd64)
-		pci_free_consistent(di->pbus, di->txdalloc,
-				    ((s8 *)di->txd64 - di->txdalign),
-				    (di->txdpaorig));
+		dma_free_coherent(di->dmadev, di->txdalloc,
+				  ((s8 *)di->txd64 - di->txdalign),
+				  (di->txdpaorig));
 	if (di->rxd64)
-		pci_free_consistent(di->pbus, di->rxdalloc,
-				    ((s8 *)di->rxd64 - di->rxdalign),
-				    (di->rxdpaorig));
+		dma_free_coherent(di->dmadev, di->rxdalloc,
+				  ((s8 *)di->rxd64 - di->rxdalign),
+				  (di->rxdpaorig));
 
 	/* free packet pointer vectors */
 	kfree(di->txp);
@@ -882,7 +885,7 @@ static struct sk_buff *dma64_getnextrxp(struct dma_info *di, bool forceall)
 	pa = le32_to_cpu(di->rxd64[i].addrlow) - di->dataoffsetlow;
 
 	/* clear this packet from the descriptor ring */
-	pci_unmap_single(di->pbus, pa, di->rxbufsize, PCI_DMA_FROMDEVICE);
+	dma_unmap_single(di->dmadev, pa, di->rxbufsize, DMA_FROM_DEVICE);
 
 	di->rxd64[i].addrlow = cpu_to_le32(0xdeadbeef);
 	di->rxd64[i].addrhigh = cpu_to_le32(0xdeadbeef);
@@ -1048,8 +1051,8 @@ bool dma_rxfill(struct dma_pub *pub)
 		 */
 		*(u32 *) (p->data) = 0;
 
-		pa = pci_map_single(di->pbus, p->data,
-			di->rxbufsize, PCI_DMA_FROMDEVICE);
+		pa = dma_map_single(di->dmadev, p->data, di->rxbufsize,
+				    DMA_FROM_DEVICE);
 
 		/* save the free packet pointer */
 		di->rxp[rxout] = p;
@@ -1267,7 +1270,7 @@ int dma_txfast(struct dma_pub *pub, struct sk_buff *p, bool commit)
 		goto outoftxd;
 
 	/* get physical address of buffer start */
-	pa = pci_map_single(di->pbus, data, len, PCI_DMA_TODEVICE);
+	pa = dma_map_single(di->dmadev, data, len, DMA_TO_DEVICE);
 
 	/* With a DMA segment list, Descriptor table is filled
 	 * using the segment list instead of looping over
@@ -1376,7 +1379,7 @@ struct sk_buff *dma_getnexttxp(struct dma_pub *pub, enum txd_range range)
 		txp = di->txp[i];
 		di->txp[i] = NULL;
 
-		pci_unmap_single(di->pbus, pa, size, PCI_DMA_TODEVICE);
+		dma_unmap_single(di->dmadev, pa, size, DMA_TO_DEVICE);
 	}
 
 	di->txin = i;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/dma.h b/drivers/net/wireless/brcm80211/brcmsmac/dma.h
index d317c7c..2d59ad6 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/dma.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/dma.h
@@ -75,10 +75,12 @@ struct dma_pub {
 };
 
 extern struct dma_pub *dma_attach(char *name, struct si_pub *sih,
-			    void __iomem *dmaregstx, void __iomem *dmaregsrx,
-			    uint ntxd, uint nrxd,
-			    uint rxbufsize, int rxextheadroom,
-			    uint nrxpost, uint rxoffset, uint *msg_level);
+				  struct bcma_device *d11core,
+				  void __iomem *dmaregstx,
+				  void __iomem *dmaregsrx,
+				  uint ntxd, uint nrxd,
+				  uint rxbufsize, int rxextheadroom,
+				  uint nrxpost, uint rxoffset, uint *msg_level);
 
 void dma_rxinit(struct dma_pub *pub);
 int dma_rx(struct dma_pub *pub, struct sk_buff_head *skb_list);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index f4a6465..f2491bd 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -1098,7 +1098,7 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 		 * TX: TX_AC_BK_FIFO (TX AC Background data packets)
 		 * RX: RX_FIFO (RX data packets)
 		 */
-		wlc_hw->di[0] = dma_attach(name, wlc_hw->sih,
+		wlc_hw->di[0] = dma_attach(name, wlc_hw->sih, wlc_hw->d11core,
 					   (wme ? dmareg(wlc_hw, DMA_TX, 0) :
 					    NULL), dmareg(wlc_hw, DMA_RX, 0),
 					   (wme ? NTXD : 0), NRXD,
@@ -1112,7 +1112,7 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 		 *   (legacy) TX_DATA_FIFO (TX data packets)
 		 * RX: UNUSED
 		 */
-		wlc_hw->di[1] = dma_attach(name, wlc_hw->sih,
+		wlc_hw->di[1] = dma_attach(name, wlc_hw->sih, wlc_hw->d11core,
 					   dmareg(wlc_hw, DMA_TX, 1), NULL,
 					   NTXD, 0, 0, -1, 0, 0,
 					   &brcm_msg_level);
@@ -1123,7 +1123,7 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 		 * TX: TX_AC_VI_FIFO (TX AC Video data packets)
 		 * RX: UNUSED
 		 */
-		wlc_hw->di[2] = dma_attach(name, wlc_hw->sih,
+		wlc_hw->di[2] = dma_attach(name, wlc_hw->sih, wlc_hw->d11core,
 					   dmareg(wlc_hw, DMA_TX, 2), NULL,
 					   NTXD, 0, 0, -1, 0, 0,
 					   &brcm_msg_level);
@@ -1133,7 +1133,7 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 		 * TX: TX_AC_VO_FIFO (TX AC Voice data packets)
 		 *   (legacy) TX_CTL_FIFO (TX control & mgmt packets)
 		 */
-		wlc_hw->di[3] = dma_attach(name, wlc_hw->sih,
+		wlc_hw->di[3] = dma_attach(name, wlc_hw->sih, wlc_hw->d11core,
 					   dmareg(wlc_hw, DMA_TX, 3),
 					   NULL, NTXD, 0, 0, -1,
 					   0, 0, &brcm_msg_level);
-- 
1.7.5.4


