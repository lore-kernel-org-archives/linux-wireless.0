Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1183 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272Ab1IAJRg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 05:17:36 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 06/30] staging: brcm80211: removed static function
 declarations in dma.c
Date: Thu, 1 Sep 2011 11:16:56 +0200
Message-ID: <1314868640-9425-7-git-send-email-rvossen@broadcom.com> (sfid-20110901_111752_973479_DDB050CB)
In-Reply-To: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
References: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/dma.c |  580 ++++++++++++++----------------
 1 files changed, 279 insertions(+), 301 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index 42446cd..8859a77 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -197,16 +197,34 @@
 #define txd64		dregs.d64_u.txd_64
 #define rxd64		dregs.d64_u.rxd_64
 
-/*
- * default dma message level (if input msg_level
- * pointer is null in dma_attach())
- */
-static uint dma_msg_level;
-
 #define	MAXNAMEL	8	/* 8 char names */
 
 #define	DI_INFO(dmah)	((dma_info_t *)dmah)
 
+/* descriptor bumping macros */
+/* faster than %, but n must be power of 2 */
+#define	XXD(x, n)	((x) & ((n) - 1))
+
+#define	TXD(x)		XXD((x), di->ntxd)
+#define	RXD(x)		XXD((x), di->nrxd)
+#define	NEXTTXD(i)	TXD((i) + 1)
+#define	PREVTXD(i)	TXD((i) - 1)
+#define	NEXTRXD(i)	RXD((i) + 1)
+#define	PREVRXD(i)	RXD((i) - 1)
+
+#define	NTXDACTIVE(h, t)	TXD((t) - (h))
+#define	NRXDACTIVE(h, t)	RXD((t) - (h))
+
+/* macros to convert between byte offsets and indexes */
+#define	B2I(bytes, type)	((bytes) / sizeof(type))
+#define	I2B(index, type)	((index) * sizeof(type))
+
+#define	PCI32ADDR_HIGH		0xc0000000	/* address[31:30] */
+#define	PCI32ADDR_HIGH_SHIFT	30	/* address[31:30] */
+
+#define	PCI64ADDR_HIGH		0x80000000	/* address[63] */
+#define	PCI64ADDR_HIGH_SHIFT	31	/* address[63] */
+
 /*
  * DMA Descriptor
  * Descriptors are only read by the hardware, never written back.
@@ -298,51 +316,202 @@ struct dma_info {
 	bool aligndesc_4k;
 };
 
-/* descriptor bumping macros */
-/* faster than %, but n must be power of 2 */
-#define	XXD(x, n)	((x) & ((n) - 1))
+/*
+ * default dma message level (if input msg_level
+ * pointer is null in dma_attach())
+ */
+static uint dma_msg_level;
 
-#define	TXD(x)		XXD((x), di->ntxd)
-#define	RXD(x)		XXD((x), di->nrxd)
-#define	NEXTTXD(i)	TXD((i) + 1)
-#define	PREVTXD(i)	TXD((i) - 1)
-#define	NEXTRXD(i)	RXD((i) + 1)
-#define	PREVRXD(i)	RXD((i) - 1)
+static uint _dma_ctrlflags(struct dma_info *di, uint mask, uint flags)
+{
+	uint dmactrlflags = di->dma.dmactrlflags;
 
-#define	NTXDACTIVE(h, t)	TXD((t) - (h))
-#define	NRXDACTIVE(h, t)	RXD((t) - (h))
+	if (di == NULL) {
+		DMA_ERROR(("%s: _dma_ctrlflags: NULL dma handle\n", di->name));
+		return 0;
+	}
 
-/* macros to convert between byte offsets and indexes */
-#define	B2I(bytes, type)	((bytes) / sizeof(type))
-#define	I2B(index, type)	((index) * sizeof(type))
+	dmactrlflags &= ~mask;
+	dmactrlflags |= flags;
 
-#define	PCI32ADDR_HIGH		0xc0000000	/* address[31:30] */
-#define	PCI32ADDR_HIGH_SHIFT	30	/* address[31:30] */
+	/* If trying to enable parity, check if parity is actually supported */
+	if (dmactrlflags & DMA_CTRL_PEN) {
+		u32 control;
 
-#define	PCI64ADDR_HIGH		0x80000000	/* address[63] */
-#define	PCI64ADDR_HIGH_SHIFT	31	/* address[63] */
+		control = R_REG(&di->d64txregs->control);
+		W_REG(&di->d64txregs->control,
+		      control | D64_XC_PD);
+		if (R_REG(&di->d64txregs->control) & D64_XC_PD)
+			/* We *can* disable it so it is supported,
+			 * restore control register
+			 */
+			W_REG(&di->d64txregs->control,
+			control);
+		else
+			/* Not supported, don't allow it to be enabled */
+			dmactrlflags &= ~DMA_CTRL_PEN;
+	}
+
+	di->dma.dmactrlflags = dmactrlflags;
+
+	return dmactrlflags;
+}
+
+static bool _dma64_addrext(struct dma64regs *dma64regs)
+{
+	u32 w;
+	OR_REG(&dma64regs->control, D64_XC_AE);
+	w = R_REG(&dma64regs->control);
+	AND_REG(&dma64regs->control, ~D64_XC_AE);
+	return (w & D64_XC_AE) == D64_XC_AE;
+}
+
+/*
+ * return true if this dma engine supports DmaExtendedAddrChanges,
+ * otherwise false
+ */
+static bool _dma_isaddrext(struct dma_info *di)
+{
+	/* DMA64 supports full 32- or 64-bit operation. AE is always valid */
+
+	/* not all tx or rx channel are available */
+	if (di->d64txregs != NULL) {
+		if (!_dma64_addrext(di->d64txregs))
+			DMA_ERROR(("%s: _dma_isaddrext: DMA64 tx doesn't have "
+				   "AE set\n", di->name));
+		return true;
+	} else if (di->d64rxregs != NULL) {
+		if (!_dma64_addrext(di->d64rxregs))
+			DMA_ERROR(("%s: _dma_isaddrext: DMA64 rx doesn't have "
+				   "AE set\n", di->name));
+		return true;
+	}
+
+	return false;
+}
 
-/* Common prototypes */
-static bool _dma_isaddrext(struct dma_info *di);
-static bool _dma_descriptor_align(struct dma_info *di);
-static bool _dma_alloc(struct dma_info *di, uint direction);
-static void _dma_ddtable_init(struct dma_info *di, uint direction,
-			      dma_addr_t pa);
-static void _dma_rxenable(struct dma_info *di);
-static struct sk_buff *_dma_getnextrxp(struct dma_info *di, bool forceall);
-static uint _dma_ctrlflags(struct dma_info *di, uint mask, uint flags);
-static u8 dma_align_sizetobits(uint size);
+static bool _dma_descriptor_align(struct dma_info *di)
+{
+	u32 addrl;
+
+	/* Check to see if the descriptors need to be aligned on 4K/8K or not */
+	if (di->d64txregs != NULL) {
+		W_REG(&di->d64txregs->addrlow, 0xff0);
+		addrl = R_REG(&di->d64txregs->addrlow);
+		if (addrl != 0)
+			return false;
+	} else if (di->d64rxregs != NULL) {
+		W_REG(&di->d64rxregs->addrlow, 0xff0);
+		addrl = R_REG(&di->d64rxregs->addrlow);
+		if (addrl != 0)
+			return false;
+	}
+	return true;
+}
+
+void *dma_alloc_consistent(struct pci_dev *pdev, uint size, u16 align_bits,
+			       uint *alloced, dma_addr_t *pap)
+{
+	if (align_bits) {
+		u16 align = (1 << align_bits);
+		if (!IS_ALIGNED(PAGE_SIZE, align))
+			size += align;
+		*alloced = size;
+	}
+	return pci_alloc_consistent(pdev, size, pap);
+}
+
+static
+u8 dma_align_sizetobits(uint size)
+{
+	u8 bitpos = 0;
+	while (size >>= 1)
+		bitpos++;
+	return bitpos;
+}
+
+/* This function ensures that the DMA descriptor ring will not get allocated
+ * across Page boundary. If the allocation is done across the page boundary
+ * at the first time, then it is freed and the allocation is done at
+ * descriptor ring size aligned location. This will ensure that the ring will
+ * not cross page boundary
+ */
 static void *dma_ringalloc(struct dma_info *di, u32 boundary, uint size,
 			   u16 *alignbits, uint *alloced,
-			   dma_addr_t *descpa);
+			   dma_addr_t *descpa)
+{
+	void *va;
+	u32 desc_strtaddr;
+	u32 alignbytes = 1 << *alignbits;
 
-/* Prototypes for 64-bit routines */
-static bool dma64_alloc(struct dma_info *di, uint direction);
-static struct sk_buff *dma64_getnextrxp(struct dma_info *di, bool forceall);
-static bool dma64_rxidle(struct dma_info *di);
-static bool _dma64_addrext(struct dma64regs *dma64regs);
+	va = dma_alloc_consistent(di->pbus, size, *alignbits, alloced, descpa);
 
-static inline u32 parity32(u32 data);
+	if (NULL == va)
+		return NULL;
+
+	desc_strtaddr = (u32) roundup((unsigned long)va, alignbytes);
+	if (((desc_strtaddr + size - 1) & boundary) != (desc_strtaddr
+							& boundary)) {
+		*alignbits = dma_align_sizetobits(size);
+		pci_free_consistent(di->pbus, size, va, *descpa);
+		va = dma_alloc_consistent(di->pbus, size, *alignbits,
+			alloced, descpa);
+	}
+	return va;
+}
+
+static bool dma64_alloc(struct dma_info *di, uint direction)
+{
+	u16 size;
+	uint ddlen;
+	void *va;
+	uint alloced = 0;
+	u16 align;
+	u16 align_bits;
+
+	ddlen = sizeof(struct dma64desc);
+
+	size = (direction == DMA_TX) ? (di->ntxd * ddlen) : (di->nrxd * ddlen);
+	align_bits = di->dmadesc_align;
+	align = (1 << align_bits);
+
+	if (direction == DMA_TX) {
+		va = dma_ringalloc(di, D64RINGALIGN, size, &align_bits,
+			&alloced, &di->txdpaorig);
+		if (va == NULL) {
+			DMA_ERROR(("%s: dma64_alloc: DMA_ALLOC_CONSISTENT(ntxd)"
+				   " failed\n", di->name));
+			return false;
+		}
+		align = (1 << align_bits);
+		di->txd64 = (struct dma64desc *)
+					roundup((unsigned long)va, align);
+		di->txdalign = (uint) ((s8 *)di->txd64 - (s8 *) va);
+		di->txdpa = di->txdpaorig + di->txdalign;
+		di->txdalloc = alloced;
+	} else {
+		va = dma_ringalloc(di, D64RINGALIGN, size, &align_bits,
+			&alloced, &di->rxdpaorig);
+		if (va == NULL) {
+			DMA_ERROR(("%s: dma64_alloc: DMA_ALLOC_CONSISTENT(nrxd)"
+				   " failed\n", di->name));
+			return false;
+		}
+		align = (1 << align_bits);
+		di->rxd64 = (struct dma64desc *)
+					roundup((unsigned long)va, align);
+		di->rxdalign = (uint) ((s8 *)di->rxd64 - (s8 *) va);
+		di->rxdpa = di->rxdpaorig + di->rxdalign;
+		di->rxdalloc = alloced;
+	}
+
+	return true;
+}
+
+static bool _dma_alloc(struct dma_info *di, uint direction)
+{
+	return dma64_alloc(di, direction);
+}
 
 struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 		     void *dmaregstx, void *dmaregsrx, uint ntxd,
@@ -551,23 +720,6 @@ dma64_dd_upd(struct dma_info *di, struct dma64desc *ddring,
 	}
 }
 
-static bool _dma_alloc(struct dma_info *di, uint direction)
-{
-	return dma64_alloc(di, direction);
-}
-
-void *dma_alloc_consistent(struct pci_dev *pdev, uint size, u16 align_bits,
-			       uint *alloced, dma_addr_t *pap)
-{
-	if (align_bits) {
-		u16 align = (1 << align_bits);
-		if (!IS_ALIGNED(PAGE_SIZE, align))
-			size += align;
-		*alloced = size;
-	}
-	return pci_alloc_consistent(pdev, size, pap);
-}
-
 /* !! may be called with core in reset */
 void dma_detach(struct dma_pub *pub)
 {
@@ -594,49 +746,6 @@ void dma_detach(struct dma_pub *pub)
 
 }
 
-static bool _dma_descriptor_align(struct dma_info *di)
-{
-	u32 addrl;
-
-	/* Check to see if the descriptors need to be aligned on 4K/8K or not */
-	if (di->d64txregs != NULL) {
-		W_REG(&di->d64txregs->addrlow, 0xff0);
-		addrl = R_REG(&di->d64txregs->addrlow);
-		if (addrl != 0)
-			return false;
-	} else if (di->d64rxregs != NULL) {
-		W_REG(&di->d64rxregs->addrlow, 0xff0);
-		addrl = R_REG(&di->d64rxregs->addrlow);
-		if (addrl != 0)
-			return false;
-	}
-	return true;
-}
-
-/*
- * return true if this dma engine supports DmaExtendedAddrChanges,
- * otherwise false
- */
-static bool _dma_isaddrext(struct dma_info *di)
-{
-	/* DMA64 supports full 32- or 64-bit operation. AE is always valid */
-
-	/* not all tx or rx channel are available */
-	if (di->d64txregs != NULL) {
-		if (!_dma64_addrext(di->d64txregs))
-			DMA_ERROR(("%s: _dma_isaddrext: DMA64 tx doesn't have "
-				   "AE set\n", di->name));
-		return true;
-	} else if (di->d64rxregs != NULL) {
-		if (!_dma64_addrext(di->d64rxregs))
-			DMA_ERROR(("%s: _dma_isaddrext: DMA64 rx doesn't have "
-				   "AE set\n", di->name));
-		return true;
-	}
-
-	return false;
-}
-
 /* initialize descriptor table base address */
 static void
 _dma_ddtable_init(struct dma_info *di, uint direction, dma_addr_t pa)
@@ -679,6 +788,27 @@ _dma_ddtable_init(struct dma_info *di, uint direction, dma_addr_t pa)
 	}
 }
 
+static void _dma_rxenable(struct dma_info *di)
+{
+	uint dmactrlflags = di->dma.dmactrlflags;
+	u32 control;
+
+	DMA_TRACE(("%s: dma_rxenable\n", di->name));
+
+	control =
+	    (R_REG(&di->d64rxregs->control) & D64_RC_AE) |
+	    D64_RC_RE;
+
+	if ((dmactrlflags & DMA_CTRL_PEN) == 0)
+		control |= D64_RC_PD;
+
+	if (dmactrlflags & DMA_CTRL_ROC)
+		control |= D64_RC_OC;
+
+	W_REG(&di->d64rxregs->control,
+		((di->rxoffset << D64_RC_RO_SHIFT) | control));
+}
+
 void dma_rxinit(struct dma_pub *pub)
 {
 	struct dma_info *di = (struct dma_info *)pub;
@@ -705,25 +835,49 @@ void dma_rxinit(struct dma_pub *pub)
 		_dma_ddtable_init(di, DMA_RX, di->rxdpa);
 }
 
-static void _dma_rxenable(struct dma_info *di)
+static struct sk_buff *dma64_getnextrxp(struct dma_info *di, bool forceall)
 {
-	uint dmactrlflags = di->dma.dmactrlflags;
-	u32 control;
+	uint i, curr;
+	struct sk_buff *rxp;
+	dma_addr_t pa;
 
-	DMA_TRACE(("%s: dma_rxenable\n", di->name));
+	i = di->rxin;
 
-	control =
-	    (R_REG(&di->d64rxregs->control) & D64_RC_AE) |
-	    D64_RC_RE;
+	/* return if no packets posted */
+	if (i == di->rxout)
+		return NULL;
 
-	if ((dmactrlflags & DMA_CTRL_PEN) == 0)
-		control |= D64_RC_PD;
+	curr =
+	    B2I(((R_REG(&di->d64rxregs->status0) & D64_RS0_CD_MASK) -
+		 di->rcvptrbase) & D64_RS0_CD_MASK, struct dma64desc);
 
-	if (dmactrlflags & DMA_CTRL_ROC)
-		control |= D64_RC_OC;
+	/* ignore curr if forceall */
+	if (!forceall && (i == curr))
+		return NULL;
 
-	W_REG(&di->d64rxregs->control,
-		((di->rxoffset << D64_RC_RO_SHIFT) | control));
+	/* get the packet pointer that corresponds to the rx descriptor */
+	rxp = di->rxp[i];
+	di->rxp[i] = NULL;
+
+	pa = cpu_to_le32(di->rxd64[i].addrlow) - di->dataoffsetlow;
+
+	/* clear this packet from the descriptor ring */
+	pci_unmap_single(di->pbus, pa, di->rxbufsize, PCI_DMA_FROMDEVICE);
+
+	di->rxd64[i].addrlow = 0xdeadbeef;
+	di->rxd64[i].addrhigh = 0xdeadbeef;
+
+	di->rxin = NEXTRXD(i);
+
+	return rxp;
+}
+
+static struct sk_buff *_dma_getnextrxp(struct dma_info *di, bool forceall)
+{
+	if (di->nrxd == 0)
+		return NULL;
+
+	return dma64_getnextrxp(di, forceall);
 }
 
 /*
@@ -795,6 +949,17 @@ struct sk_buff *dma_rx(struct dma_pub *pub)
 	return head;
 }
 
+static bool dma64_rxidle(struct dma_info *di)
+{
+	DMA_TRACE(("%s: dma_rxidle\n", di->name));
+
+	if (di->nrxd == 0)
+		return true;
+
+	return ((R_REG(&di->d64rxregs->status0) & D64_RS0_CD_MASK) ==
+		(R_REG(&di->d64rxregs->ptr) & D64_RS0_CD_MASK));
+}
+
 /*
  * post receive buffers
  *  return false is refill failed completely and ring is empty this will stall
@@ -894,14 +1059,6 @@ void dma_rxreclaim(struct dma_pub *pub)
 		brcmu_pkt_buf_free_skb(p);
 }
 
-static struct sk_buff *_dma_getnextrxp(struct dma_info *di, bool forceall)
-{
-	if (di->nrxd == 0)
-		return NULL;
-
-	return dma64_getnextrxp(di, forceall);
-}
-
 void dma_counterreset(struct dma_pub *pub)
 {
 	/* reset all software counters */
@@ -910,41 +1067,6 @@ void dma_counterreset(struct dma_pub *pub)
 	pub->txnobuf = 0;
 }
 
-static uint _dma_ctrlflags(struct dma_info *di, uint mask, uint flags)
-{
-	uint dmactrlflags = di->dma.dmactrlflags;
-
-	if (di == NULL) {
-		DMA_ERROR(("%s: _dma_ctrlflags: NULL dma handle\n", di->name));
-		return 0;
-	}
-
-	dmactrlflags &= ~mask;
-	dmactrlflags |= flags;
-
-	/* If trying to enable parity, check if parity is actually supported */
-	if (dmactrlflags & DMA_CTRL_PEN) {
-		u32 control;
-
-		control = R_REG(&di->d64txregs->control);
-		W_REG(&di->d64txregs->control,
-		      control | D64_XC_PD);
-		if (R_REG(&di->d64txregs->control) & D64_XC_PD)
-			/* We *can* disable it so it is supported,
-			 * restore control register
-			 */
-			W_REG(&di->d64txregs->control,
-			control);
-		else
-			/* Not supported, don't allow it to be enabled */
-			dmactrlflags &= ~DMA_CTRL_PEN;
-	}
-
-	di->dma.dmactrlflags = dmactrlflags;
-
-	return dmactrlflags;
-}
-
 /* get the address of the var in order to change later */
 unsigned long dma_getvar(struct dma_pub *pub, const char *name)
 {
@@ -955,45 +1077,6 @@ unsigned long dma_getvar(struct dma_pub *pub, const char *name)
 	return 0;
 }
 
-static
-u8 dma_align_sizetobits(uint size)
-{
-	u8 bitpos = 0;
-	while (size >>= 1)
-		bitpos++;
-	return bitpos;
-}
-
-/* This function ensures that the DMA descriptor ring will not get allocated
- * across Page boundary. If the allocation is done across the page boundary
- * at the first time, then it is freed and the allocation is done at
- * descriptor ring size aligned location. This will ensure that the ring will
- * not cross page boundary
- */
-static void *dma_ringalloc(struct dma_info *di, u32 boundary, uint size,
-			   u16 *alignbits, uint *alloced,
-			   dma_addr_t *descpa)
-{
-	void *va;
-	u32 desc_strtaddr;
-	u32 alignbytes = 1 << *alignbits;
-
-	va = dma_alloc_consistent(di->pbus, size, *alignbits, alloced, descpa);
-
-	if (NULL == va)
-		return NULL;
-
-	desc_strtaddr = (u32) roundup((unsigned long)va, alignbytes);
-	if (((desc_strtaddr + size - 1) & boundary) != (desc_strtaddr
-							& boundary)) {
-		*alignbits = dma_align_sizetobits(size);
-		pci_free_consistent(di->pbus, size, va, *descpa);
-		va = dma_alloc_consistent(di->pbus, size, *alignbits,
-			alloced, descpa);
-	}
-	return va;
-}
-
 /* 64-bit DMA functions */
 
 void dma_txinit(struct dma_pub *pub)
@@ -1083,54 +1166,6 @@ void dma_txreclaim(struct dma_pub *pub, enum txd_range range)
 	}
 }
 
-static bool dma64_alloc(struct dma_info *di, uint direction)
-{
-	u16 size;
-	uint ddlen;
-	void *va;
-	uint alloced = 0;
-	u16 align;
-	u16 align_bits;
-
-	ddlen = sizeof(struct dma64desc);
-
-	size = (direction == DMA_TX) ? (di->ntxd * ddlen) : (di->nrxd * ddlen);
-	align_bits = di->dmadesc_align;
-	align = (1 << align_bits);
-
-	if (direction == DMA_TX) {
-		va = dma_ringalloc(di, D64RINGALIGN, size, &align_bits,
-			&alloced, &di->txdpaorig);
-		if (va == NULL) {
-			DMA_ERROR(("%s: dma64_alloc: DMA_ALLOC_CONSISTENT(ntxd)"
-				   " failed\n", di->name));
-			return false;
-		}
-		align = (1 << align_bits);
-		di->txd64 = (struct dma64desc *)
-					roundup((unsigned long)va, align);
-		di->txdalign = (uint) ((s8 *)di->txd64 - (s8 *) va);
-		di->txdpa = di->txdpaorig + di->txdalign;
-		di->txdalloc = alloced;
-	} else {
-		va = dma_ringalloc(di, D64RINGALIGN, size, &align_bits,
-			&alloced, &di->rxdpaorig);
-		if (va == NULL) {
-			DMA_ERROR(("%s: dma64_alloc: DMA_ALLOC_CONSISTENT(nrxd)"
-				   " failed\n", di->name));
-			return false;
-		}
-		align = (1 << align_bits);
-		di->rxd64 = (struct dma64desc *)
-					roundup((unsigned long)va, align);
-		di->rxdalign = (uint) ((s8 *)di->rxd64 - (s8 *) va);
-		di->rxdpa = di->rxdpaorig + di->rxdalign;
-		di->rxdalloc = alloced;
-	}
-
-	return true;
-}
-
 bool dma_txreset(struct dma_pub *pub)
 {
 	struct dma_info *di = (struct dma_info *)pub;
@@ -1157,17 +1192,6 @@ bool dma_txreset(struct dma_pub *pub)
 	return status == D64_XS0_XS_DISABLED;
 }
 
-static bool dma64_rxidle(struct dma_info *di)
-{
-	DMA_TRACE(("%s: dma_rxidle\n", di->name));
-
-	if (di->nrxd == 0)
-		return true;
-
-	return ((R_REG(&di->d64rxregs->status0) & D64_RS0_CD_MASK) ==
-		(R_REG(&di->d64rxregs->ptr) & D64_RS0_CD_MASK));
-}
-
 bool dma_rxreset(struct dma_pub *pub)
 {
 	struct dma_info *di = (struct dma_info *)pub;
@@ -1357,52 +1381,6 @@ struct sk_buff *dma_getnexttxp(struct dma_pub *pub, enum txd_range range)
 	return NULL;
 }
 
-static struct sk_buff *dma64_getnextrxp(struct dma_info *di, bool forceall)
-{
-	uint i, curr;
-	struct sk_buff *rxp;
-	dma_addr_t pa;
-
-	i = di->rxin;
-
-	/* return if no packets posted */
-	if (i == di->rxout)
-		return NULL;
-
-	curr =
-	    B2I(((R_REG(&di->d64rxregs->status0) & D64_RS0_CD_MASK) -
-		 di->rcvptrbase) & D64_RS0_CD_MASK, struct dma64desc);
-
-	/* ignore curr if forceall */
-	if (!forceall && (i == curr))
-		return NULL;
-
-	/* get the packet pointer that corresponds to the rx descriptor */
-	rxp = di->rxp[i];
-	di->rxp[i] = NULL;
-
-	pa = cpu_to_le32(di->rxd64[i].addrlow) - di->dataoffsetlow;
-
-	/* clear this packet from the descriptor ring */
-	pci_unmap_single(di->pbus, pa, di->rxbufsize, PCI_DMA_FROMDEVICE);
-
-	di->rxd64[i].addrlow = 0xdeadbeef;
-	di->rxd64[i].addrhigh = 0xdeadbeef;
-
-	di->rxin = NEXTRXD(i);
-
-	return rxp;
-}
-
-static bool _dma64_addrext(struct dma64regs *dma64regs)
-{
-	u32 w;
-	OR_REG(&dma64regs->control, D64_XC_AE);
-	w = R_REG(&dma64regs->control);
-	AND_REG(&dma64regs->control, ~D64_XC_AE);
-	return (w & D64_XC_AE) == D64_XC_AE;
-}
-
 /*
  * Mac80211 initiated actions sometimes require packets in the DMA queue to be
  * modified. The modified portion of the packet is not under control of the DMA
-- 
1.7.4.1


