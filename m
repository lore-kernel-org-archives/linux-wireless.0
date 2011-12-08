Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1511 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182Ab1LHXHM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 18:07:12 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 17/23] brcm80211: smac: use bcma function for register
 access in dma.c
Date: Thu, 8 Dec 2011 15:06:53 -0800
Message-ID: <1323385619-7454-18-git-send-email-frankyl@broadcom.com> (sfid-20111209_000725_611520_8054F6D7)
In-Reply-To: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
References: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The dma.c source file now uses the register access functions
provided by bcma.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/dma.c  |  174 +++++++++++++-----------
 drivers/net/wireless/brcm80211/brcmsmac/dma.h  |    3 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c |   22 ++--
 3 files changed, 108 insertions(+), 91 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/dma.c b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
index 0c5f31b..dfcd9cf 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/dma.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
@@ -27,6 +27,13 @@
 #include "soc.h"
 
 /*
+ * dma register field offset calculation
+ */
+#define DMA64REGOFFS(field)		offsetof(struct dma64regs, field)
+#define DMA64TXREGOFFS(di, field)	(di->d64txregbase + DMA64REGOFFS(field))
+#define DMA64RXREGOFFS(di, field)	(di->d64rxregbase + DMA64REGOFFS(field))
+
+/*
  * DMA hardware requires each descriptor ring to be 8kB aligned, and fit within
  * a contiguous 8kB physical address.
  */
@@ -227,9 +234,9 @@ struct dma_info {
 	bool addrext;	/* this dma engine supports DmaExtendedAddrChanges */
 
 	/* 64-bit dma tx engine registers */
-	struct dma64regs __iomem *d64txregs;
+	uint d64txregbase;
 	/* 64-bit dma rx engine registers */
-	struct dma64regs __iomem *d64rxregs;
+	uint d64rxregbase;
 	/* pointer to dma64 tx descriptor ring */
 	struct dma64desc *txd64;
 	/* pointer to dma64 rx descriptor ring */
@@ -376,15 +383,16 @@ static uint _dma_ctrlflags(struct dma_info *di, uint mask, uint flags)
 	if (dmactrlflags & DMA_CTRL_PEN) {
 		u32 control;
 
-		control = R_REG(&di->d64txregs->control);
-		W_REG(&di->d64txregs->control,
+		control = bcma_read32(di->d11core, DMA64TXREGOFFS(di, control));
+		bcma_write32(di->d11core, DMA64TXREGOFFS(di, control),
 		      control | D64_XC_PD);
-		if (R_REG(&di->d64txregs->control) & D64_XC_PD)
+		if (bcma_read32(di->d11core, DMA64TXREGOFFS(di, control)) &
+		    D64_XC_PD)
 			/* We *can* disable it so it is supported,
 			 * restore control register
 			 */
-			W_REG(&di->d64txregs->control,
-			control);
+			bcma_write32(di->d11core, DMA64TXREGOFFS(di, control),
+				     control);
 		else
 			/* Not supported, don't allow it to be enabled */
 			dmactrlflags &= ~DMA_CTRL_PEN;
@@ -395,12 +403,12 @@ static uint _dma_ctrlflags(struct dma_info *di, uint mask, uint flags)
 	return dmactrlflags;
 }
 
-static bool _dma64_addrext(struct dma64regs __iomem *dma64regs)
+static bool _dma64_addrext(struct dma_info *di, uint ctrl_offset)
 {
 	u32 w;
-	OR_REG(&dma64regs->control, D64_XC_AE);
-	w = R_REG(&dma64regs->control);
-	AND_REG(&dma64regs->control, ~D64_XC_AE);
+	bcma_set32(di->d11core, ctrl_offset, D64_XC_AE);
+	w = bcma_read32(di->d11core, ctrl_offset);
+	bcma_mask32(di->d11core, ctrl_offset, ~D64_XC_AE);
 	return (w & D64_XC_AE) == D64_XC_AE;
 }
 
@@ -413,13 +421,13 @@ static bool _dma_isaddrext(struct dma_info *di)
 	/* DMA64 supports full 32- or 64-bit operation. AE is always valid */
 
 	/* not all tx or rx channel are available */
-	if (di->d64txregs != NULL) {
-		if (!_dma64_addrext(di->d64txregs))
+	if (di->d64txregbase != 0) {
+		if (!_dma64_addrext(di, DMA64TXREGOFFS(di, control)))
 			DMA_ERROR("%s: DMA64 tx doesn't have AE set\n",
 				  di->name);
 		return true;
-	} else if (di->d64rxregs != NULL) {
-		if (!_dma64_addrext(di->d64rxregs))
+	} else if (di->d64rxregbase != 0) {
+		if (!_dma64_addrext(di, DMA64RXREGOFFS(di, control)))
 			DMA_ERROR("%s: DMA64 rx doesn't have AE set\n",
 				  di->name);
 		return true;
@@ -433,14 +441,14 @@ static bool _dma_descriptor_align(struct dma_info *di)
 	u32 addrl;
 
 	/* Check to see if the descriptors need to be aligned on 4K/8K or not */
-	if (di->d64txregs != NULL) {
-		W_REG(&di->d64txregs->addrlow, 0xff0);
-		addrl = R_REG(&di->d64txregs->addrlow);
+	if (di->d64txregbase != 0) {
+		bcma_write32(di->d11core, DMA64TXREGOFFS(di, addrlow), 0xff0);
+		addrl = bcma_read32(di->d11core, DMA64TXREGOFFS(di, addrlow));
 		if (addrl != 0)
 			return false;
-	} else if (di->d64rxregs != NULL) {
-		W_REG(&di->d64rxregs->addrlow, 0xff0);
-		addrl = R_REG(&di->d64rxregs->addrlow);
+	} else if (di->d64rxregbase != 0) {
+		bcma_write32(di->d11core, DMA64RXREGOFFS(di, addrlow), 0xff0);
+		addrl = bcma_read32(di->d11core, DMA64RXREGOFFS(di, addrlow));
 		if (addrl != 0)
 			return false;
 	}
@@ -558,8 +566,7 @@ static bool _dma_alloc(struct dma_info *di, uint direction)
 
 struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 			   struct bcma_device *d11core,
-			   void __iomem *dmaregstx, void __iomem *dmaregsrx,
-			   uint ntxd, uint nrxd,
+			   uint txregbase, uint rxregbase, uint ntxd, uint nrxd,
 			   uint rxbufsize, int rxextheadroom,
 			   uint nrxpost, uint rxoffset, uint *msg_level)
 {
@@ -576,10 +583,10 @@ struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 
 	di->dma64 = ((ai_core_sflags(sih, 0, 0) & SISF_DMA64) == SISF_DMA64);
 
-	/* init dma reg pointer */
+	/* init dma reg info */
 	di->d11core = d11core;
-	di->d64txregs = (struct dma64regs __iomem *) dmaregstx;
-	di->d64rxregs = (struct dma64regs __iomem *) dmaregsrx;
+	di->d64txregbase = txregbase;
+	di->d64rxregbase = rxregbase;
 
 	/*
 	 * Default flags (which can be changed by the driver calling
@@ -588,10 +595,11 @@ struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 	 */
 	_dma_ctrlflags(di, DMA_CTRL_ROC | DMA_CTRL_PEN, 0);
 
-	DMA_TRACE("%s: %s flags 0x%x ntxd %d nrxd %d rxbufsize %d rxextheadroom %d nrxpost %d rxoffset %d dmaregstx %p dmaregsrx %p\n",
-		  name, "DMA64",
+	DMA_TRACE("%s: %s flags 0x%x ntxd %d nrxd %d "
+		  "rxbufsize %d rxextheadroom %d nrxpost %d rxoffset %d "
+		  "txregbase %u rxregbase %u\n", name, "DMA64",
 		  di->dma.dmactrlflags, ntxd, nrxd, rxbufsize,
-		  rxextheadroom, nrxpost, rxoffset, dmaregstx, dmaregsrx);
+		  rxextheadroom, nrxpost, rxoffset, txregbase, rxregbase);
 
 	/* make a private copy of our callers name */
 	strncpy(di->name, name, MAXNAMEL);
@@ -783,11 +791,15 @@ _dma_ddtable_init(struct dma_info *di, uint direction, dma_addr_t pa)
 	if ((di->ddoffsetlow == 0)
 	    || !(pa & PCI32ADDR_HIGH)) {
 		if (direction == DMA_TX) {
-			W_REG(&di->d64txregs->addrlow, pa + di->ddoffsetlow);
-			W_REG(&di->d64txregs->addrhigh, di->ddoffsethigh);
+			bcma_write32(di->d11core, DMA64TXREGOFFS(di, addrlow),
+				     pa + di->ddoffsetlow);
+			bcma_write32(di->d11core, DMA64TXREGOFFS(di, addrhigh),
+				     di->ddoffsethigh);
 		} else {
-			W_REG(&di->d64rxregs->addrlow, pa + di->ddoffsetlow);
-			W_REG(&di->d64rxregs->addrhigh, di->ddoffsethigh);
+			bcma_write32(di->d11core, DMA64RXREGOFFS(di, addrlow),
+				     pa + di->ddoffsetlow);
+			bcma_write32(di->d11core, DMA64RXREGOFFS(di, addrhigh),
+				     di->ddoffsethigh);
 		}
 	} else {
 		/* DMA64 32bits address extension */
@@ -798,15 +810,19 @@ _dma_ddtable_init(struct dma_info *di, uint direction, dma_addr_t pa)
 		pa &= ~PCI32ADDR_HIGH;
 
 		if (direction == DMA_TX) {
-			W_REG(&di->d64txregs->addrlow, pa + di->ddoffsetlow);
-			W_REG(&di->d64txregs->addrhigh, di->ddoffsethigh);
-			SET_REG(&di->d64txregs->control,
-				D64_XC_AE, (ae << D64_XC_AE_SHIFT));
+			bcma_write32(di->d11core, DMA64TXREGOFFS(di, addrlow),
+				     pa + di->ddoffsetlow);
+			bcma_write32(di->d11core, DMA64TXREGOFFS(di, addrhigh),
+				     di->ddoffsethigh);
+			bcma_maskset32(di->d11core, DMA64TXREGOFFS(di, control),
+				       D64_XC_AE, (ae << D64_XC_AE_SHIFT));
 		} else {
-			W_REG(&di->d64rxregs->addrlow, pa + di->ddoffsetlow);
-			W_REG(&di->d64rxregs->addrhigh, di->ddoffsethigh);
-			SET_REG(&di->d64rxregs->control,
-				D64_RC_AE, (ae << D64_RC_AE_SHIFT));
+			bcma_write32(di->d11core, DMA64RXREGOFFS(di, addrlow),
+				     pa + di->ddoffsetlow);
+			bcma_write32(di->d11core, DMA64RXREGOFFS(di, addrhigh),
+				     di->ddoffsethigh);
+			bcma_maskset32(di->d11core, DMA64RXREGOFFS(di, control),
+				       D64_RC_AE, (ae << D64_RC_AE_SHIFT));
 		}
 	}
 }
@@ -818,9 +834,9 @@ static void _dma_rxenable(struct dma_info *di)
 
 	DMA_TRACE("%s:\n", di->name);
 
-	control =
-	    (R_REG(&di->d64rxregs->control) & D64_RC_AE) |
-	    D64_RC_RE;
+	control = D64_RC_RE | (bcma_read32(di->d11core,
+					   DMA64RXREGOFFS(di, control)) &
+			       D64_RC_AE);
 
 	if ((dmactrlflags & DMA_CTRL_PEN) == 0)
 		control |= D64_RC_PD;
@@ -828,7 +844,7 @@ static void _dma_rxenable(struct dma_info *di)
 	if (dmactrlflags & DMA_CTRL_ROC)
 		control |= D64_RC_OC;
 
-	W_REG(&di->d64rxregs->control,
+	bcma_write32(di->d11core, DMA64RXREGOFFS(di, control),
 		((di->rxoffset << D64_RC_RO_SHIFT) | control));
 }
 
@@ -871,7 +887,8 @@ static struct sk_buff *dma64_getnextrxp(struct dma_info *di, bool forceall)
 		return NULL;
 
 	curr =
-	    B2I(((R_REG(&di->d64rxregs->status0) & D64_RS0_CD_MASK) -
+	    B2I(((bcma_read32(di->d11core,
+			      DMA64RXREGOFFS(di, status0)) & D64_RS0_CD_MASK) -
 		 di->rcvptrbase) & D64_RS0_CD_MASK, struct dma64desc);
 
 	/* ignore curr if forceall */
@@ -953,12 +970,12 @@ int dma_rx(struct dma_pub *pub, struct sk_buff_head *skb_list)
 		if (resid > 0) {
 			uint cur;
 			cur =
-			    B2I(((R_REG(&di->d64rxregs->status0) &
-				  D64_RS0_CD_MASK) -
-				 di->rcvptrbase) & D64_RS0_CD_MASK,
-				struct dma64desc);
+			    B2I(((bcma_read32(di->d11core,
+					      DMA64RXREGOFFS(di, status0)) &
+				  D64_RS0_CD_MASK) - di->rcvptrbase) &
+				D64_RS0_CD_MASK, struct dma64desc);
 			DMA_ERROR("rxin %d rxout %d, hw_curr %d\n",
-				  di->rxin, di->rxout, cur);
+				   di->rxin, di->rxout, cur);
 		}
 #endif				/* BCMDBG */
 
@@ -986,8 +1003,10 @@ static bool dma64_rxidle(struct dma_info *di)
 	if (di->nrxd == 0)
 		return true;
 
-	return ((R_REG(&di->d64rxregs->status0) & D64_RS0_CD_MASK) ==
-		(R_REG(&di->d64rxregs->ptr) & D64_RS0_CD_MASK));
+	return ((bcma_read32(di->d11core,
+			     DMA64RXREGOFFS(di, status0)) & D64_RS0_CD_MASK) ==
+		(bcma_read32(di->d11core, DMA64RXREGOFFS(di, ptr)) &
+		 D64_RS0_CD_MASK));
 }
 
 /*
@@ -1070,7 +1089,7 @@ bool dma_rxfill(struct dma_pub *pub)
 	di->rxout = rxout;
 
 	/* update the chip lastdscr pointer */
-	W_REG(&di->d64rxregs->ptr,
+	bcma_write32(di->d11core, DMA64RXREGOFFS(di, ptr),
 	      di->rcvptrbase + I2B(rxout, struct dma64desc));
 
 	return ring_empty;
@@ -1131,7 +1150,7 @@ void dma_txinit(struct dma_pub *pub)
 
 	if ((di->dma.dmactrlflags & DMA_CTRL_PEN) == 0)
 		control |= D64_XC_PD;
-	OR_REG(&di->d64txregs->control, control);
+	bcma_set32(di->d11core, DMA64TXREGOFFS(di, control), control);
 
 	/* DMA engine with alignment requirement requires table to be inited
 	 * before enabling the engine
@@ -1149,7 +1168,7 @@ void dma_txsuspend(struct dma_pub *pub)
 	if (di->ntxd == 0)
 		return;
 
-	OR_REG(&di->d64txregs->control, D64_XC_SE);
+	bcma_set32(di->d11core, DMA64TXREGOFFS(di, control), D64_XC_SE);
 }
 
 void dma_txresume(struct dma_pub *pub)
@@ -1161,7 +1180,7 @@ void dma_txresume(struct dma_pub *pub)
 	if (di->ntxd == 0)
 		return;
 
-	AND_REG(&di->d64txregs->control, ~D64_XC_SE);
+	bcma_mask32(di->d11core, DMA64TXREGOFFS(di, control), ~D64_XC_SE);
 }
 
 bool dma_txsuspended(struct dma_pub *pub)
@@ -1169,8 +1188,9 @@ bool dma_txsuspended(struct dma_pub *pub)
 	struct dma_info *di = (struct dma_info *)pub;
 
 	return (di->ntxd == 0) ||
-	    ((R_REG(&di->d64txregs->control) & D64_XC_SE) ==
-	     D64_XC_SE);
+	       ((bcma_read32(di->d11core,
+			     DMA64TXREGOFFS(di, control)) & D64_XC_SE) ==
+		D64_XC_SE);
 }
 
 void dma_txreclaim(struct dma_pub *pub, enum txd_range range)
@@ -1203,16 +1223,17 @@ bool dma_txreset(struct dma_pub *pub)
 		return true;
 
 	/* suspend tx DMA first */
-	W_REG(&di->d64txregs->control, D64_XC_SE);
+	bcma_write32(di->d11core, DMA64TXREGOFFS(di, control), D64_XC_SE);
 	SPINWAIT(((status =
-		   (R_REG(&di->d64txregs->status0) & D64_XS0_XS_MASK))
-		  != D64_XS0_XS_DISABLED) && (status != D64_XS0_XS_IDLE)
-		 && (status != D64_XS0_XS_STOPPED), 10000);
+		   (bcma_read32(di->d11core, DMA64TXREGOFFS(di, status0)) &
+		    D64_XS0_XS_MASK)) != D64_XS0_XS_DISABLED) &&
+		  (status != D64_XS0_XS_IDLE) && (status != D64_XS0_XS_STOPPED),
+		 10000);
 
-	W_REG(&di->d64txregs->control, 0);
+	bcma_write32(di->d11core, DMA64TXREGOFFS(di, control), 0);
 	SPINWAIT(((status =
-		   (R_REG(&di->d64txregs->status0) & D64_XS0_XS_MASK))
-		  != D64_XS0_XS_DISABLED), 10000);
+		   (bcma_read32(di->d11core, DMA64TXREGOFFS(di, status0)) &
+		    D64_XS0_XS_MASK)) != D64_XS0_XS_DISABLED), 10000);
 
 	/* wait for the last transaction to complete */
 	udelay(300);
@@ -1228,10 +1249,10 @@ bool dma_rxreset(struct dma_pub *pub)
 	if (di->nrxd == 0)
 		return true;
 
-	W_REG(&di->d64rxregs->control, 0);
+	bcma_write32(di->d11core, DMA64RXREGOFFS(di, control), 0);
 	SPINWAIT(((status =
-		   (R_REG(&di->d64rxregs->status0) & D64_RS0_RS_MASK))
-		  != D64_RS0_RS_DISABLED), 10000);
+		   (bcma_read32(di->d11core, DMA64RXREGOFFS(di, status0)) &
+		    D64_RS0_RS_MASK)) != D64_RS0_RS_DISABLED), 10000);
 
 	return status == D64_RS0_RS_DISABLED;
 }
@@ -1293,7 +1314,7 @@ int dma_txfast(struct dma_pub *pub, struct sk_buff *p, bool commit)
 
 	/* kick the chip */
 	if (commit)
-		W_REG(&di->d64txregs->ptr,
+		bcma_write32(di->d11core, DMA64TXREGOFFS(di, ptr),
 		      di->xmtptrbase + I2B(txout, struct dma64desc));
 
 	/* tx flow control */
@@ -1341,16 +1362,15 @@ struct sk_buff *dma_getnexttxp(struct dma_pub *pub, enum txd_range range)
 	if (range == DMA_RANGE_ALL)
 		end = di->txout;
 	else {
-		struct dma64regs __iomem *dregs = di->d64txregs;
-
-		end = (u16) (B2I(((R_REG(&dregs->status0) &
-				 D64_XS0_CD_MASK) -
-				 di->xmtptrbase) & D64_XS0_CD_MASK,
-				 struct dma64desc));
+		end = (u16) (B2I(((bcma_read32(di->d11core,
+					       DMA64TXREGOFFS(di, status0)) &
+				   D64_XS0_CD_MASK) - di->xmtptrbase) &
+				 D64_XS0_CD_MASK, struct dma64desc));
 
 		if (range == DMA_RANGE_TRANSFERED) {
 			active_desc =
-			    (u16) (R_REG(&dregs->status1) &
+				(u16)(bcma_read32(di->d11core,
+						  DMA64TXREGOFFS(di, status1)) &
 				      D64_XS1_AD_MASK);
 			active_desc =
 			    (active_desc - di->xmtptrbase) & D64_XS0_CD_MASK;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/dma.h b/drivers/net/wireless/brcm80211/brcmsmac/dma.h
index 2d59ad6..cc269ee 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/dma.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/dma.h
@@ -76,8 +76,7 @@ struct dma_pub {
 
 extern struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 				  struct bcma_device *d11core,
-				  void __iomem *dmaregstx,
-				  void __iomem *dmaregsrx,
+				  uint txregbase, uint rxregbase,
 				  uint ntxd, uint nrxd,
 				  uint rxbufsize, int rxextheadroom,
 				  uint nrxpost, uint rxoffset, uint *msg_level);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index f2491bd..43172b3 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -1065,14 +1065,12 @@ brcms_c_mhfdef(struct brcms_c_info *wlc, u16 *mhfs, u16 mhf2_init)
 	}
 }
 
-static struct dma64regs __iomem *
-dmareg(struct brcms_hardware *hw, uint direction, uint fifonum)
+static uint
+dmareg(uint direction, uint fifonum)
 {
-	struct d11regs __iomem *regs = hw->d11core->bus->mmio;
-
 	if (direction == DMA_TX)
-		return &(regs->fifo64regs[fifonum].dmaxmt);
-	return &(regs->fifo64regs[fifonum].dmarcv);
+		return offsetof(struct d11regs, fifo64regs[fifonum].dmaxmt);
+	return offsetof(struct d11regs, fifo64regs[fifonum].dmarcv);
 }
 
 static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
@@ -1099,8 +1097,8 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 		 * RX: RX_FIFO (RX data packets)
 		 */
 		wlc_hw->di[0] = dma_attach(name, wlc_hw->sih, wlc_hw->d11core,
-					   (wme ? dmareg(wlc_hw, DMA_TX, 0) :
-					    NULL), dmareg(wlc_hw, DMA_RX, 0),
+					   (wme ? dmareg(DMA_TX, 0) : 0),
+					   dmareg(DMA_RX, 0),
 					   (wme ? NTXD : 0), NRXD,
 					   RXBUFSZ, -1, NRXBUFPOST,
 					   BRCMS_HWRXOFF, &brcm_msg_level);
@@ -1113,7 +1111,7 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 		 * RX: UNUSED
 		 */
 		wlc_hw->di[1] = dma_attach(name, wlc_hw->sih, wlc_hw->d11core,
-					   dmareg(wlc_hw, DMA_TX, 1), NULL,
+					   dmareg(DMA_TX, 1), 0,
 					   NTXD, 0, 0, -1, 0, 0,
 					   &brcm_msg_level);
 		dma_attach_err |= (NULL == wlc_hw->di[1]);
@@ -1124,7 +1122,7 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 		 * RX: UNUSED
 		 */
 		wlc_hw->di[2] = dma_attach(name, wlc_hw->sih, wlc_hw->d11core,
-					   dmareg(wlc_hw, DMA_TX, 2), NULL,
+					   dmareg(DMA_TX, 2), 0,
 					   NTXD, 0, 0, -1, 0, 0,
 					   &brcm_msg_level);
 		dma_attach_err |= (NULL == wlc_hw->di[2]);
@@ -1134,8 +1132,8 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 		 *   (legacy) TX_CTL_FIFO (TX control & mgmt packets)
 		 */
 		wlc_hw->di[3] = dma_attach(name, wlc_hw->sih, wlc_hw->d11core,
-					   dmareg(wlc_hw, DMA_TX, 3),
-					   NULL, NTXD, 0, 0, -1,
+					   dmareg(DMA_TX, 3),
+					   0, NTXD, 0, 0, -1,
 					   0, 0, &brcm_msg_level);
 		dma_attach_err |= (NULL == wlc_hw->di[3]);
 /* Cleaner to leave this as if with AP defined */
-- 
1.7.5.4


