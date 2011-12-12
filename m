Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3069 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754614Ab1LLXPq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 18:15:46 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 11/15] brcm80211: smac: remove mapped core related
 function from aiutils.c
Date: Mon, 12 Dec 2011 15:15:09 -0800
Message-ID: <1323731713-14942-12-git-send-email-frankyl@broadcom.com> (sfid-20111213_001554_576087_63D335F5)
In-Reply-To: <1323731713-14942-1-git-send-email-frankyl@broadcom.com>
References: <1323731713-14942-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

In aiutils.c the selected core was maintained by its index number. This
is obsolete using BCMA functions so several functions using that index
have been removed.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |  121 +--------------------
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h |    7 --
 drivers/net/wireless/brcm80211/brcmsmac/dma.c     |  101 +++++++++---------
 drivers/net/wireless/brcm80211/brcmsmac/main.c    |   14 +--
 4 files changed, 59 insertions(+), 184 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index a99a163..f78350a 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -477,50 +477,6 @@ static void ai_scan(struct si_pub *sih, struct bcma_bus *bus)
 	}
 }
 
-static struct bcma_device *ai_find_bcma_core(struct si_pub *sih, uint coreidx)
-{
-	struct si_info *sii = (struct si_info *)sih;
-	struct bcma_device *core;
-
-	list_for_each_entry(core, &sii->icbus->cores, list) {
-		if (core->core_index == coreidx)
-			return core;
-	}
-	return NULL;
-}
-/*
- * This function changes the logical "focus" to the indicated core.
- * Return the current core's virtual address. Since each core starts with the
- * same set of registers (BIST, clock control, etc), the returned address
- * contains the first register of this 'common' register block (not to be
- * confused with 'common core').
- */
-void __iomem *ai_setcoreidx(struct si_pub *sih, uint coreidx)
-{
-	struct si_info *sii = (struct si_info *)sih;
-	struct bcma_device *core;
-
-	if (sii->curidx != coreidx) {
-		core = ai_find_bcma_core(sih, coreidx);
-		if (core == NULL)
-			return NULL;
-
-		(void)bcma_aread32(core, BCMA_IOST);
-		sii->curidx = coreidx;
-	}
-	return sii->curmap;
-}
-
-uint ai_corerev(struct si_pub *sih)
-{
-	struct si_info *sii;
-	u32 cib;
-
-	sii = (struct si_info *)sih;
-	cib = sii->cib[sii->curidx];
-	return (cib & CIB_REV_MASK) >> CIB_REV_SHIFT;
-}
-
 /* return true if PCIE capability exists in the pci config space */
 static bool ai_ispcie(struct si_info *sii)
 {
@@ -579,9 +535,8 @@ ai_buscore_setup(struct si_info *sii, struct bcma_device *cc)
 	for (i = 0; i < sii->numcores; i++) {
 		uint cid, crev;
 
-		ai_setcoreidx(&sii->pub, i);
-		cid = ai_coreid(&sii->pub);
-		crev = ai_corerev(&sii->pub);
+		cid = sii->coreid[i];
+		crev = (sii->cib[i] & CIB_REV_MASK) >> CIB_REV_SHIFT;
 
 		if (cid == PCI_CORE_ID) {
 			pciidx = i;
@@ -804,22 +759,6 @@ void ai_detach(struct si_pub *sih)
 	kfree(sii);
 }
 
-uint ai_coreid(struct si_pub *sih)
-{
-	struct si_info *sii;
-
-	sii = (struct si_info *)sih;
-	return sii->coreid[sii->curidx];
-}
-
-uint ai_coreidx(struct si_pub *sih)
-{
-	struct si_info *sii;
-
-	sii = (struct si_info *)sih;
-	return sii->curidx;
-}
-
 /* return index of coreid or BADIDX if not found */
 struct bcma_device *ai_findcore(struct si_pub *sih, u16 coreid, u16 coreunit)
 {
@@ -842,45 +781,17 @@ struct bcma_device *ai_findcore(struct si_pub *sih, u16 coreid, u16 coreunit)
 }
 
 /*
- * This function changes logical "focus" to the indicated core;
- * must be called with interrupts off.
- * Moreover, callers should keep interrupts off during switching
- * out of and back to d11 core.
- */
-void __iomem *ai_setcore(struct si_pub *sih, uint coreid, uint coreunit)
-{
-	struct bcma_device *core;
-
-	core = ai_findcore(sih, coreid, coreunit);
-	if (core == NULL)
-		return NULL;
-
-	return ai_setcoreidx(sih, core->core_index);
-}
-
-/*
- * Switch to 'coreidx', issue a single arbitrary 32bit register mask&set
- * operation, switch back to the original core, and return the new value.
- *
- * When using the silicon backplane, no fiddling with interrupts or core
- * switches is needed.
- *
- * Also, when using pci/pcie, we can optimize away the core switching for pci
- * registers and (on newer pci cores) chipcommon registers.
+ * read/modify chipcommon core register.
  */
 uint ai_cc_reg(struct si_pub *sih, uint regoff, u32 mask, u32 val)
 {
 	struct bcma_device *cc;
-	uint origidx = 0;
 	u32 w;
 	struct si_info *sii;
 
 	sii = (struct si_info *)sih;
 	cc = sii->icbus->drv_cc.core;
 
-	/* save current core index */
-	origidx = ai_coreidx(&sii->pub);
-
 	/* mask and set */
 	if (mask || val) {
 		bcma_maskset32(cc, regoff, ~mask, val);
@@ -889,9 +800,6 @@ uint ai_cc_reg(struct si_pub *sih, uint regoff, u32 mask, u32 val)
 	/* readback */
 	w = bcma_read32(cc, regoff);
 
-	/* restore core index */
-	ai_setcoreidx(&sii->pub, origidx);
-
 	return w;
 }
 
@@ -1237,20 +1145,10 @@ void ai_pci_down(struct si_pub *sih)
 void ai_pci_setup(struct si_pub *sih, uint coremask)
 {
 	struct si_info *sii;
-	struct sbpciregs __iomem *regs = NULL;
 	u32 w;
-	uint idx = 0;
 
 	sii = (struct si_info *)sih;
 
-	if (PCI(sih)) {
-		/* get current core index */
-		idx = sii->curidx;
-
-		/* switch over to pci core */
-		regs = ai_setcoreidx(sih, sii->buscoreidx);
-	}
-
 	/*
 	 * Enable sb->pci interrupts.  Assume
 	 * PCI rev 2.3 support was added in pci core rev 6 and things changed..
@@ -1264,9 +1162,6 @@ void ai_pci_setup(struct si_pub *sih, uint coremask)
 
 	if (PCI(sih)) {
 		pcicore_pci_setup(sii->pch);
-
-		/* switch back to previous core */
-		ai_setcoreidx(sih, idx);
 	}
 }
 
@@ -1276,21 +1171,11 @@ void ai_pci_setup(struct si_pub *sih, uint coremask)
  */
 int ai_pci_fixcfg(struct si_pub *sih)
 {
-	uint origidx;
-	void __iomem *regs = NULL;
 	struct si_info *sii = (struct si_info *)sih;
 
 	/* Fixup PI in SROM shadow area to enable the correct PCI core access */
-	/* save the current index */
-	origidx = ai_coreidx(&sii->pub);
-
 	/* check 'pi' is correct and fix it if not */
-	regs = ai_setcore(&sii->pub, ai_get_buscoretype(sih), 0);
 	pcicore_fixcfg(sii->pch);
-
-	/* restore the original index */
-	ai_setcoreidx(&sii->pub, origidx);
-
 	pcicore_hwup(sii->pch);
 	return 0;
 }
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
index e37c9f4..6742758 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
@@ -221,19 +221,12 @@ struct si_info {
 /* AMBA Interconnect exported externs */
 extern struct bcma_device *ai_findcore(struct si_pub *sih,
 				       u16 coreid, u16 coreunit);
-extern uint ai_coreidx(struct si_pub *sih);
-extern uint ai_corerev(struct si_pub *sih);
 extern u32 ai_core_cflags(struct bcma_device *core, u32 mask, u32 val);
 
 /* === exported functions === */
 extern struct si_pub *ai_attach(struct bcma_bus *pbus);
 extern void ai_detach(struct si_pub *sih);
-extern uint ai_coreid(struct si_pub *sih);
-extern uint ai_corerev(struct si_pub *sih);
 extern uint ai_cc_reg(struct si_pub *sih, uint regoff, u32 mask, u32 val);
-extern uint ai_findcoreidx(struct si_pub *sih, uint coreid, uint coreunit);
-extern void __iomem *ai_setcoreidx(struct si_pub *sih, uint coreidx);
-extern void __iomem *ai_setcore(struct si_pub *sih, uint coreid, uint coreunit);
 extern void ai_pci_setup(struct si_pub *sih, uint coremask);
 extern void ai_clkctl_init(struct si_pub *sih);
 extern u16 ai_clkctl_fast_pwrup_delay(struct si_pub *sih);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/dma.c b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
index dab04bb..b4cf617 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/dma.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
@@ -227,7 +227,7 @@ struct dma_info {
 	uint *msg_level;	/* message level pointer */
 	char name[MAXNAMEL];	/* callers name for diag msgs */
 
-	struct bcma_device *d11core;
+	struct bcma_device *core;
 	struct device *dmadev;
 
 	bool dma64;	/* this dma engine is operating in 64-bit mode */
@@ -383,15 +383,15 @@ static uint _dma_ctrlflags(struct dma_info *di, uint mask, uint flags)
 	if (dmactrlflags & DMA_CTRL_PEN) {
 		u32 control;
 
-		control = bcma_read32(di->d11core, DMA64TXREGOFFS(di, control));
-		bcma_write32(di->d11core, DMA64TXREGOFFS(di, control),
+		control = bcma_read32(di->core, DMA64TXREGOFFS(di, control));
+		bcma_write32(di->core, DMA64TXREGOFFS(di, control),
 		      control | D64_XC_PD);
-		if (bcma_read32(di->d11core, DMA64TXREGOFFS(di, control)) &
+		if (bcma_read32(di->core, DMA64TXREGOFFS(di, control)) &
 		    D64_XC_PD)
 			/* We *can* disable it so it is supported,
 			 * restore control register
 			 */
-			bcma_write32(di->d11core, DMA64TXREGOFFS(di, control),
+			bcma_write32(di->core, DMA64TXREGOFFS(di, control),
 				     control);
 		else
 			/* Not supported, don't allow it to be enabled */
@@ -406,9 +406,9 @@ static uint _dma_ctrlflags(struct dma_info *di, uint mask, uint flags)
 static bool _dma64_addrext(struct dma_info *di, uint ctrl_offset)
 {
 	u32 w;
-	bcma_set32(di->d11core, ctrl_offset, D64_XC_AE);
-	w = bcma_read32(di->d11core, ctrl_offset);
-	bcma_mask32(di->d11core, ctrl_offset, ~D64_XC_AE);
+	bcma_set32(di->core, ctrl_offset, D64_XC_AE);
+	w = bcma_read32(di->core, ctrl_offset);
+	bcma_mask32(di->core, ctrl_offset, ~D64_XC_AE);
 	return (w & D64_XC_AE) == D64_XC_AE;
 }
 
@@ -442,13 +442,13 @@ static bool _dma_descriptor_align(struct dma_info *di)
 
 	/* Check to see if the descriptors need to be aligned on 4K/8K or not */
 	if (di->d64txregbase != 0) {
-		bcma_write32(di->d11core, DMA64TXREGOFFS(di, addrlow), 0xff0);
-		addrl = bcma_read32(di->d11core, DMA64TXREGOFFS(di, addrlow));
+		bcma_write32(di->core, DMA64TXREGOFFS(di, addrlow), 0xff0);
+		addrl = bcma_read32(di->core, DMA64TXREGOFFS(di, addrlow));
 		if (addrl != 0)
 			return false;
 	} else if (di->d64rxregbase != 0) {
-		bcma_write32(di->d11core, DMA64RXREGOFFS(di, addrlow), 0xff0);
-		addrl = bcma_read32(di->d11core, DMA64RXREGOFFS(di, addrlow));
+		bcma_write32(di->core, DMA64RXREGOFFS(di, addrlow), 0xff0);
+		addrl = bcma_read32(di->core, DMA64RXREGOFFS(di, addrlow));
 		if (addrl != 0)
 			return false;
 	}
@@ -565,12 +565,13 @@ static bool _dma_alloc(struct dma_info *di, uint direction)
 }
 
 struct dma_pub *dma_attach(char *name, struct si_pub *sih,
-			   struct bcma_device *d11core,
+			   struct bcma_device *core,
 			   uint txregbase, uint rxregbase, uint ntxd, uint nrxd,
 			   uint rxbufsize, int rxextheadroom,
 			   uint nrxpost, uint rxoffset, uint *msg_level)
 {
 	struct dma_info *di;
+	u8 rev = core->id.rev;
 	uint size;
 
 	/* allocate private info structure */
@@ -582,10 +583,10 @@ struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 
 
 	di->dma64 =
-		((bcma_aread32(d11core, BCMA_IOST) & SISF_DMA64) == SISF_DMA64);
+		((bcma_aread32(core, BCMA_IOST) & SISF_DMA64) == SISF_DMA64);
 
 	/* init dma reg info */
-	di->d11core = d11core;
+	di->core = core;
 	di->d64txregbase = txregbase;
 	di->d64rxregbase = rxregbase;
 
@@ -606,7 +607,7 @@ struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 	strncpy(di->name, name, MAXNAMEL);
 	di->name[MAXNAMEL - 1] = '\0';
 
-	di->dmadev = d11core->dma_dev;
+	di->dmadev = core->dma_dev;
 
 	/* save tunables */
 	di->ntxd = (u16) ntxd;
@@ -638,11 +639,11 @@ struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 	di->dataoffsetlow = di->ddoffsetlow;
 	di->dataoffsethigh = di->ddoffsethigh;
 	/* WAR64450 : DMACtl.Addr ext fields are not supported in SDIOD core. */
-	if ((ai_coreid(sih) == SDIOD_CORE_ID)
-	    && ((ai_corerev(sih) > 0) && (ai_corerev(sih) <= 2)))
+	if ((core->id.id == SDIOD_CORE_ID)
+	    && ((rev > 0) && (rev <= 2)))
 		di->addrext = 0;
-	else if ((ai_coreid(sih) == I2S_CORE_ID) &&
-		 ((ai_corerev(sih) == 0) || (ai_corerev(sih) == 1)))
+	else if ((core->id.id == I2S_CORE_ID) &&
+		 ((rev == 0) || (rev == 1)))
 		di->addrext = 0;
 	else
 		di->addrext = _dma_isaddrext(di);
@@ -792,14 +793,14 @@ _dma_ddtable_init(struct dma_info *di, uint direction, dma_addr_t pa)
 	if ((di->ddoffsetlow == 0)
 	    || !(pa & PCI32ADDR_HIGH)) {
 		if (direction == DMA_TX) {
-			bcma_write32(di->d11core, DMA64TXREGOFFS(di, addrlow),
+			bcma_write32(di->core, DMA64TXREGOFFS(di, addrlow),
 				     pa + di->ddoffsetlow);
-			bcma_write32(di->d11core, DMA64TXREGOFFS(di, addrhigh),
+			bcma_write32(di->core, DMA64TXREGOFFS(di, addrhigh),
 				     di->ddoffsethigh);
 		} else {
-			bcma_write32(di->d11core, DMA64RXREGOFFS(di, addrlow),
+			bcma_write32(di->core, DMA64RXREGOFFS(di, addrlow),
 				     pa + di->ddoffsetlow);
-			bcma_write32(di->d11core, DMA64RXREGOFFS(di, addrhigh),
+			bcma_write32(di->core, DMA64RXREGOFFS(di, addrhigh),
 				     di->ddoffsethigh);
 		}
 	} else {
@@ -811,18 +812,18 @@ _dma_ddtable_init(struct dma_info *di, uint direction, dma_addr_t pa)
 		pa &= ~PCI32ADDR_HIGH;
 
 		if (direction == DMA_TX) {
-			bcma_write32(di->d11core, DMA64TXREGOFFS(di, addrlow),
+			bcma_write32(di->core, DMA64TXREGOFFS(di, addrlow),
 				     pa + di->ddoffsetlow);
-			bcma_write32(di->d11core, DMA64TXREGOFFS(di, addrhigh),
+			bcma_write32(di->core, DMA64TXREGOFFS(di, addrhigh),
 				     di->ddoffsethigh);
-			bcma_maskset32(di->d11core, DMA64TXREGOFFS(di, control),
+			bcma_maskset32(di->core, DMA64TXREGOFFS(di, control),
 				       D64_XC_AE, (ae << D64_XC_AE_SHIFT));
 		} else {
-			bcma_write32(di->d11core, DMA64RXREGOFFS(di, addrlow),
+			bcma_write32(di->core, DMA64RXREGOFFS(di, addrlow),
 				     pa + di->ddoffsetlow);
-			bcma_write32(di->d11core, DMA64RXREGOFFS(di, addrhigh),
+			bcma_write32(di->core, DMA64RXREGOFFS(di, addrhigh),
 				     di->ddoffsethigh);
-			bcma_maskset32(di->d11core, DMA64RXREGOFFS(di, control),
+			bcma_maskset32(di->core, DMA64RXREGOFFS(di, control),
 				       D64_RC_AE, (ae << D64_RC_AE_SHIFT));
 		}
 	}
@@ -835,7 +836,7 @@ static void _dma_rxenable(struct dma_info *di)
 
 	DMA_TRACE("%s:\n", di->name);
 
-	control = D64_RC_RE | (bcma_read32(di->d11core,
+	control = D64_RC_RE | (bcma_read32(di->core,
 					   DMA64RXREGOFFS(di, control)) &
 			       D64_RC_AE);
 
@@ -845,7 +846,7 @@ static void _dma_rxenable(struct dma_info *di)
 	if (dmactrlflags & DMA_CTRL_ROC)
 		control |= D64_RC_OC;
 
-	bcma_write32(di->d11core, DMA64RXREGOFFS(di, control),
+	bcma_write32(di->core, DMA64RXREGOFFS(di, control),
 		((di->rxoffset << D64_RC_RO_SHIFT) | control));
 }
 
@@ -888,7 +889,7 @@ static struct sk_buff *dma64_getnextrxp(struct dma_info *di, bool forceall)
 		return NULL;
 
 	curr =
-	    B2I(((bcma_read32(di->d11core,
+	    B2I(((bcma_read32(di->core,
 			      DMA64RXREGOFFS(di, status0)) & D64_RS0_CD_MASK) -
 		 di->rcvptrbase) & D64_RS0_CD_MASK, struct dma64desc);
 
@@ -971,7 +972,7 @@ int dma_rx(struct dma_pub *pub, struct sk_buff_head *skb_list)
 		if (resid > 0) {
 			uint cur;
 			cur =
-			    B2I(((bcma_read32(di->d11core,
+			    B2I(((bcma_read32(di->core,
 					      DMA64RXREGOFFS(di, status0)) &
 				  D64_RS0_CD_MASK) - di->rcvptrbase) &
 				D64_RS0_CD_MASK, struct dma64desc);
@@ -1004,9 +1005,9 @@ static bool dma64_rxidle(struct dma_info *di)
 	if (di->nrxd == 0)
 		return true;
 
-	return ((bcma_read32(di->d11core,
+	return ((bcma_read32(di->core,
 			     DMA64RXREGOFFS(di, status0)) & D64_RS0_CD_MASK) ==
-		(bcma_read32(di->d11core, DMA64RXREGOFFS(di, ptr)) &
+		(bcma_read32(di->core, DMA64RXREGOFFS(di, ptr)) &
 		 D64_RS0_CD_MASK));
 }
 
@@ -1090,7 +1091,7 @@ bool dma_rxfill(struct dma_pub *pub)
 	di->rxout = rxout;
 
 	/* update the chip lastdscr pointer */
-	bcma_write32(di->d11core, DMA64RXREGOFFS(di, ptr),
+	bcma_write32(di->core, DMA64RXREGOFFS(di, ptr),
 	      di->rcvptrbase + I2B(rxout, struct dma64desc));
 
 	return ring_empty;
@@ -1151,7 +1152,7 @@ void dma_txinit(struct dma_pub *pub)
 
 	if ((di->dma.dmactrlflags & DMA_CTRL_PEN) == 0)
 		control |= D64_XC_PD;
-	bcma_set32(di->d11core, DMA64TXREGOFFS(di, control), control);
+	bcma_set32(di->core, DMA64TXREGOFFS(di, control), control);
 
 	/* DMA engine with alignment requirement requires table to be inited
 	 * before enabling the engine
@@ -1169,7 +1170,7 @@ void dma_txsuspend(struct dma_pub *pub)
 	if (di->ntxd == 0)
 		return;
 
-	bcma_set32(di->d11core, DMA64TXREGOFFS(di, control), D64_XC_SE);
+	bcma_set32(di->core, DMA64TXREGOFFS(di, control), D64_XC_SE);
 }
 
 void dma_txresume(struct dma_pub *pub)
@@ -1181,7 +1182,7 @@ void dma_txresume(struct dma_pub *pub)
 	if (di->ntxd == 0)
 		return;
 
-	bcma_mask32(di->d11core, DMA64TXREGOFFS(di, control), ~D64_XC_SE);
+	bcma_mask32(di->core, DMA64TXREGOFFS(di, control), ~D64_XC_SE);
 }
 
 bool dma_txsuspended(struct dma_pub *pub)
@@ -1189,7 +1190,7 @@ bool dma_txsuspended(struct dma_pub *pub)
 	struct dma_info *di = (struct dma_info *)pub;
 
 	return (di->ntxd == 0) ||
-	       ((bcma_read32(di->d11core,
+	       ((bcma_read32(di->core,
 			     DMA64TXREGOFFS(di, control)) & D64_XC_SE) ==
 		D64_XC_SE);
 }
@@ -1224,16 +1225,16 @@ bool dma_txreset(struct dma_pub *pub)
 		return true;
 
 	/* suspend tx DMA first */
-	bcma_write32(di->d11core, DMA64TXREGOFFS(di, control), D64_XC_SE);
+	bcma_write32(di->core, DMA64TXREGOFFS(di, control), D64_XC_SE);
 	SPINWAIT(((status =
-		   (bcma_read32(di->d11core, DMA64TXREGOFFS(di, status0)) &
+		   (bcma_read32(di->core, DMA64TXREGOFFS(di, status0)) &
 		    D64_XS0_XS_MASK)) != D64_XS0_XS_DISABLED) &&
 		  (status != D64_XS0_XS_IDLE) && (status != D64_XS0_XS_STOPPED),
 		 10000);
 
-	bcma_write32(di->d11core, DMA64TXREGOFFS(di, control), 0);
+	bcma_write32(di->core, DMA64TXREGOFFS(di, control), 0);
 	SPINWAIT(((status =
-		   (bcma_read32(di->d11core, DMA64TXREGOFFS(di, status0)) &
+		   (bcma_read32(di->core, DMA64TXREGOFFS(di, status0)) &
 		    D64_XS0_XS_MASK)) != D64_XS0_XS_DISABLED), 10000);
 
 	/* wait for the last transaction to complete */
@@ -1250,9 +1251,9 @@ bool dma_rxreset(struct dma_pub *pub)
 	if (di->nrxd == 0)
 		return true;
 
-	bcma_write32(di->d11core, DMA64RXREGOFFS(di, control), 0);
+	bcma_write32(di->core, DMA64RXREGOFFS(di, control), 0);
 	SPINWAIT(((status =
-		   (bcma_read32(di->d11core, DMA64RXREGOFFS(di, status0)) &
+		   (bcma_read32(di->core, DMA64RXREGOFFS(di, status0)) &
 		    D64_RS0_RS_MASK)) != D64_RS0_RS_DISABLED), 10000);
 
 	return status == D64_RS0_RS_DISABLED;
@@ -1315,7 +1316,7 @@ int dma_txfast(struct dma_pub *pub, struct sk_buff *p, bool commit)
 
 	/* kick the chip */
 	if (commit)
-		bcma_write32(di->d11core, DMA64TXREGOFFS(di, ptr),
+		bcma_write32(di->core, DMA64TXREGOFFS(di, ptr),
 		      di->xmtptrbase + I2B(txout, struct dma64desc));
 
 	/* tx flow control */
@@ -1363,14 +1364,14 @@ struct sk_buff *dma_getnexttxp(struct dma_pub *pub, enum txd_range range)
 	if (range == DMA_RANGE_ALL)
 		end = di->txout;
 	else {
-		end = (u16) (B2I(((bcma_read32(di->d11core,
+		end = (u16) (B2I(((bcma_read32(di->core,
 					       DMA64TXREGOFFS(di, status0)) &
 				   D64_XS0_CD_MASK) - di->xmtptrbase) &
 				 D64_XS0_CD_MASK, struct dma64desc));
 
 		if (range == DMA_RANGE_TRANSFERED) {
 			active_desc =
-				(u16)(bcma_read32(di->d11core,
+				(u16)(bcma_read32(di->core,
 						  DMA64TXREGOFFS(di, status1)) &
 				      D64_XS1_AD_MASK);
 			active_desc =
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 1c75e2f..f7ed340 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -1953,12 +1953,11 @@ static bool brcms_b_radio_read_hwdisabled(struct brcms_hardware *wlc_hw)
 		flags |= SICF_PCLKE;
 
 		/*
+		 * TODO: test suspend/resume
+		 *
 		 * AI chip doesn't restore bar0win2 on
 		 * hibernation/resume, need sw fixup
 		 */
-		if ((ai_get_chip_id(wlc_hw->sih) == BCM43224_CHIP_ID) ||
-		    (ai_get_chip_id(wlc_hw->sih) == BCM43225_CHIP_ID))
-			(void)ai_setcore(wlc_hw->sih, D11_CORE_ID, 0);
 
 		bcma_core_enable(wlc_hw->d11core, flags);
 		brcms_c_mctrl_reset(wlc_hw);
@@ -4484,8 +4483,6 @@ static int brcms_b_attach(struct brcms_c_info *wlc, struct bcma_device *core,
 	wlc_hw->vendorid = pcidev->vendor;
 	wlc_hw->deviceid = pcidev->device;
 
-	/* set bar0 window to point at D11 core */
-	(void)ai_setcore(wlc_hw->sih, D11_CORE_ID, 0);
 	wlc_hw->d11core = core;
 	wlc_hw->corerev = core->id.rev;
 
@@ -4606,7 +4603,7 @@ static int brcms_b_attach(struct brcms_c_info *wlc, struct bcma_device *core,
 		wlc_hw->band->bandtype = j ? BRCM_BAND_5G : BRCM_BAND_2G;
 		wlc->band->bandunit = j;
 		wlc->band->bandtype = j ? BRCM_BAND_5G : BRCM_BAND_2G;
-		wlc->core->coreidx = ai_coreidx(wlc_hw->sih);
+		wlc->core->coreidx = core->core_index;
 
 		wlc_hw->machwcap = bcma_read32(core, D11REGOFFS(machwcap));
 		wlc_hw->machwcap_backup = wlc_hw->machwcap;
@@ -5055,12 +5052,11 @@ static void brcms_b_hw_up(struct brcms_hardware *wlc_hw)
 	ai_pci_fixcfg(wlc_hw->sih);
 
 	/*
+	 * TODO: test suspend/resume
+	 *
 	 * AI chip doesn't restore bar0win2 on
 	 * hibernation/resume, need sw fixup
 	 */
-	if ((ai_get_chip_id(wlc_hw->sih) == BCM43224_CHIP_ID) ||
-	    (ai_get_chip_id(wlc_hw->sih) == BCM43225_CHIP_ID))
-		(void)ai_setcore(wlc_hw->sih, D11_CORE_ID, 0);
 
 	/*
 	 * Inform phy that a POR reset has occurred so
-- 
1.7.5.4


