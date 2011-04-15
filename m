Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4105 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586Ab1DOMki (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 08:40:38 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] staging: brcm80211: removed ASSERTs from util dir,
 part 2
Date: Fri, 15 Apr 2011 14:40:31 +0200
Message-ID: <1302871231-8739-3-git-send-email-rvossen@broadcom.com>
In-Reply-To: <1302871231-8739-1-git-send-email-rvossen@broadcom.com>
References: <1302871231-8739-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/util/bcmutils.c |    4 --
 drivers/staging/brcm80211/util/bcmwifi.c  |    4 --
 drivers/staging/brcm80211/util/hnddma.c   |   62 ++--------------------------
 drivers/staging/brcm80211/util/nicpci.c   |   14 +------
 drivers/staging/brcm80211/util/qmath.c    |    1 -
 5 files changed, 6 insertions(+), 79 deletions(-)

diff --git a/drivers/staging/brcm80211/util/bcmutils.c b/drivers/staging/brcm80211/util/bcmutils.c
index 6958ff7..fcb091e 100644
--- a/drivers/staging/brcm80211/util/bcmutils.c
+++ b/drivers/staging/brcm80211/util/bcmutils.c
@@ -281,8 +281,6 @@ void pktq_flush(struct pktq *pq, bool dir,
 	int prec;
 	for (prec = 0; prec < pq->num_prec; prec++)
 		pktq_pflush(pq, prec, dir, fn, arg);
-	if (fn == NULL)
-		ASSERT(pq->len == 0);
 }
 #endif /* BRCM_FULLMAC */
 
@@ -290,8 +288,6 @@ void pktq_init(struct pktq *pq, int num_prec, int max_len)
 {
 	int prec;
 
-	ASSERT(num_prec > 0 && num_prec <= PKTQ_MAX_PREC);
-
 	/* pq is variable size; only zero out what's requested */
 	memset(pq, 0,
 	      offsetof(struct pktq, q) + (sizeof(struct pktq_prec) * num_prec));
diff --git a/drivers/staging/brcm80211/util/bcmwifi.c b/drivers/staging/brcm80211/util/bcmwifi.c
index d82c2b2..d15efd3 100644
--- a/drivers/staging/brcm80211/util/bcmwifi.c
+++ b/drivers/staging/brcm80211/util/bcmwifi.c
@@ -59,8 +59,6 @@ u8 wf_chspec_ctlchan(chanspec_t chspec)
 	if (CHSPEC_CTL_SB(chspec) == WL_CHANSPEC_CTL_SB_NONE) {
 		return CHSPEC_CHANNEL(chspec);
 	} else {
-		/* we only support 40MHZ with sidebands */
-		ASSERT(CHSPEC_BW(chspec) == WL_CHANSPEC_BW_40);
 		/* chanspec channel holds the centre frequency, use that and the
 		 * side band information to reconstruct the control channel number
 		 */
@@ -68,8 +66,6 @@ u8 wf_chspec_ctlchan(chanspec_t chspec)
 			/* control chan is the upper 20 MHZ SB of the 40MHZ channel */
 			ctl_chan = UPPER_20_SB(CHSPEC_CHANNEL(chspec));
 		} else {
-			ASSERT(CHSPEC_CTL_SB(chspec) ==
-			       WL_CHANSPEC_CTL_SB_LOWER);
 			/* control chan is the lower 20 MHZ SB of the 40MHZ channel */
 			ctl_chan = LOWER_20_SB(CHSPEC_CHANNEL(chspec));
 		}
diff --git a/drivers/staging/brcm80211/util/hnddma.c b/drivers/staging/brcm80211/util/hnddma.c
index f3a1e45..54ac9d8 100644
--- a/drivers/staging/brcm80211/util/hnddma.c
+++ b/drivers/staging/brcm80211/util/hnddma.c
@@ -292,24 +292,9 @@ struct hnddma_pub *dma_attach(char *name, si_t *sih,
 	}
 
 	di->msg_level = msg_level ? msg_level : &dma_msg_level;
-
-	/* old chips w/o sb is no longer supported */
-	ASSERT(sih != NULL);
-
 	di->dma64 = ((ai_core_sflags(sih, 0, 0) & SISF_DMA64) == SISF_DMA64);
 
-	/* check arguments */
-	ASSERT(ISPOWEROF2(ntxd));
-	ASSERT(ISPOWEROF2(nrxd));
-
-	if (nrxd == 0)
-		ASSERT(dmaregsrx == NULL);
-	if (ntxd == 0)
-		ASSERT(dmaregstx == NULL);
-
 	/* init dma reg pointer */
-	ASSERT(ntxd <= D64MAXDD);
-	ASSERT(nrxd <= D64MAXDD);
 	di->d64txregs = (dma64regs_t *) dmaregstx;
 	di->d64rxregs = (dma64regs_t *) dmaregsrx;
 	di->hnddma.di_fn = (const di_fcn_t *)&dma64proc;
@@ -488,8 +473,6 @@ dma64_dd_upd(dma_info_t *di, dma64dd_t *ddring, dmaaddr_t pa, uint outidx,
 #else
 	if ((di->dataoffsetlow == 0) || !(PHYSADDRLO(pa) & PCI32ADDR_HIGH)) {
 #endif				/* defined(__mips__) && defined(IL_BIGENDIAN) */
-		ASSERT((PHYSADDRHI(pa) & PCI64ADDR_HIGH) == 0);
-
 		W_SM(&ddring[outidx].addrlow,
 		     BUS_SWAP32(PHYSADDRLO(pa) + di->dataoffsetlow));
 		W_SM(&ddring[outidx].addrhigh,
@@ -499,11 +482,8 @@ dma64_dd_upd(dma_info_t *di, dma64dd_t *ddring, dmaaddr_t pa, uint outidx,
 	} else {
 		/* address extension for 32-bit PCI */
 		u32 ae;
-		ASSERT(di->addrext);
-
 		ae = (PHYSADDRLO(pa) & PCI32ADDR_HIGH) >> PCI32ADDR_HIGH_SHIFT;
 		PHYSADDRLO(pa) &= ~PCI32ADDR_HIGH;
-		ASSERT(PHYSADDRHI(pa) == 0);
 
 		ctrl2 |= (ae << D64_CTRL2_AE_SHIFT) & D64_CTRL2_AE;
 		W_SM(&ddring[outidx].addrlow,
@@ -544,10 +524,6 @@ static void _dma_detach(dma_info_t *di)
 
 	DMA_TRACE(("%s: dma_detach\n", di->name));
 
-	/* shouldn't be here if descriptors are unreclaimed */
-	ASSERT(di->txin == di->txout);
-	ASSERT(di->rxin == di->rxout);
-
 	/* free dma descriptor rings */
 	if (di->txd64)
 		pci_free_consistent(di->pbus, di->txdalloc,
@@ -602,14 +578,14 @@ static bool _dma_isaddrext(dma_info_t *di)
 		if (!_dma64_addrext(di->d64txregs)) {
 			DMA_ERROR(("%s: _dma_isaddrext: DMA64 tx doesn't have "
 				   "AE set\n", di->name));
-			ASSERT(0);
+			return false;
 		}
 		return true;
 	} else if (di->d64rxregs != NULL) {
 		if (!_dma64_addrext(di->d64rxregs)) {
 			DMA_ERROR(("%s: _dma_isaddrext: DMA64 rx doesn't have "
 				   "AE set\n", di->name));
-			ASSERT(0);
+			return false;
 		}
 		return true;
 	}
@@ -642,8 +618,6 @@ static void _dma_ddtable_init(dma_info_t *di, uint direction, dmaaddr_t pa)
 	} else {
 		/* DMA64 32bits address extension */
 		u32 ae;
-		ASSERT(di->addrext);
-		ASSERT(PHYSADDRHI(pa) == 0);
 
 		/* shift the high bit(s) from pa to ae */
 		ae = (PHYSADDRLO(pa) & PCI32ADDR_HIGH) >>
@@ -783,7 +757,6 @@ static void *BCMFASTPATH _dma_rx(dma_info_t *di)
 #ifdef BCMDBG
 		if (resid > 0) {
 			uint cur;
-			ASSERT(p == NULL);
 			cur =
 			    B2I(((R_REG(&di->d64rxregs->status0) &
 				  D64_RS0_CD_MASK) -
@@ -874,10 +847,7 @@ static bool BCMFASTPATH _dma_rxfill(dma_info_t *di)
 		pa = pci_map_single(di->pbus, p->data,
 			di->rxbufsize, PCI_DMA_FROMDEVICE);
 
-		ASSERT(IS_ALIGNED(PHYSADDRLO(pa), 4));
-
 		/* save the free packet pointer */
-		ASSERT(di->rxp[rxout] == NULL);
 		di->rxp[rxout] = p;
 
 		/* reset flags for each descriptor */
@@ -1019,8 +989,6 @@ static uint _dma_ctrlflags(dma_info_t *di, uint mask, uint flags)
 		return 0;
 	}
 
-	ASSERT((flags & ~mask) == 0);
-
 	dmactrlflags &= ~mask;
 	dmactrlflags |= flags;
 
@@ -1053,9 +1021,6 @@ static unsigned long _dma_getvar(dma_info_t *di, const char *name)
 {
 	if (!strcmp(name, "&txavail"))
 		return (unsigned long)&(di->hnddma.txavail);
-	else {
-		ASSERT(0);
-	}
 	return 0;
 }
 
@@ -1063,8 +1028,6 @@ static
 u8 dma_align_sizetobits(uint size)
 {
 	u8 bitpos = 0;
-	ASSERT(size);
-	ASSERT(!(size & (size - 1)));
 	while (size >>= 1) {
 		bitpos++;
 	}
@@ -1230,12 +1193,8 @@ static bool dma64_alloc(dma_info_t *di, uint direction)
 		di->txdalign = (uint) ((s8 *)di->txd64 - (s8 *) va);
 		PHYSADDRLOSET(di->txdpa,
 			      PHYSADDRLO(di->txdpaorig) + di->txdalign);
-		/* Make sure that alignment didn't overflow */
-		ASSERT(PHYSADDRLO(di->txdpa) >= PHYSADDRLO(di->txdpaorig));
-
 		PHYSADDRHISET(di->txdpa, PHYSADDRHI(di->txdpaorig));
 		di->txdalloc = alloced;
-		ASSERT(IS_ALIGNED((unsigned long)di->txd64, align));
 	} else {
 		va = dma_ringalloc(di, D64RINGALIGN, size, &align_bits,
 			&alloced, &di->rxdpaorig);
@@ -1248,12 +1207,8 @@ static bool dma64_alloc(dma_info_t *di, uint direction)
 		di->rxdalign = (uint) ((s8 *)di->rxd64 - (s8 *) va);
 		PHYSADDRLOSET(di->rxdpa,
 			      PHYSADDRLO(di->rxdpaorig) + di->rxdalign);
-		/* Make sure that alignment didn't overflow */
-		ASSERT(PHYSADDRLO(di->rxdpa) >= PHYSADDRLO(di->rxdpaorig));
-
 		PHYSADDRHISET(di->rxdpa, PHYSADDRHI(di->rxdpaorig));
 		di->rxdalloc = alloced;
-		ASSERT(IS_ALIGNED((unsigned long)di->rxd64, align));
 	}
 
 	return true;
@@ -1396,7 +1351,6 @@ static int dma64_txunframed(dma_info_t *di, void *buf, uint len, bool commit)
 		flags |= D64_CTRL1_EOT;
 
 	dma64_dd_upd(di, di->txd64, pa, txout, &flags, len);
-	ASSERT(di->txp[txout] == NULL);
 
 	/* save the buffer pointer - used by dma_getpos */
 	di->txp[txout] = buf;
@@ -1501,7 +1455,6 @@ static int BCMFASTPATH dma64_txfast(dma_info_t *di, struct sk_buff *p0,
 				pa = map->segs[j - 1].addr;
 			}
 			dma64_dd_upd(di, di->txd64, pa, txout, &flags, len);
-			ASSERT(di->txp[txout] == NULL);
 
 			txout = NEXTTXD(txout);
 		}
@@ -1642,15 +1595,13 @@ static void *BCMFASTPATH dma64_getnexttxp(dma_info_t *di, txd_range_t range)
 	return NULL;
 }
 
+/* if forcing, dma engine must be disabled */
 static void *BCMFASTPATH dma64_getnextrxp(dma_info_t *di, bool forceall)
 {
 	uint i, curr;
 	void *rxp;
 	dmaaddr_t pa;
 
-	/* if forcing, dma engine must be disabled */
-	ASSERT(!forceall || !dma64_rxenabled(di));
-
 	i = di->rxin;
 
 	/* return if no packets posted */
@@ -1667,7 +1618,6 @@ static void *BCMFASTPATH dma64_getnextrxp(dma_info_t *di, bool forceall)
 
 	/* get the packet pointer that corresponds to the rx descriptor */
 	rxp = di->rxp[i];
-	ASSERT(rxp);
 	di->rxp[i] = NULL;
 
 	PHYSADDRLOSET(pa,
@@ -1699,6 +1649,7 @@ static bool _dma64_addrext(dma64regs_t *dma64regs)
 
 /*
  * Rotate all active tx dma ring entries "forward" by (ActiveDescriptor - txin).
+ * precondition: tx dma should be suspended/idle
  */
 static void dma64_txrotate(dma_info_t *di)
 {
@@ -1709,8 +1660,6 @@ static void dma64_txrotate(dma_info_t *di)
 	u32 w;
 	u16 first, last;
 
-	ASSERT(dma64_txsuspendedidle(di));
-
 	nactive = _dma_txactive(di);
 	ad = (u16) (B2I
 		       ((((R_REG(&di->d64txregs->status1) &
@@ -1753,7 +1702,6 @@ static void dma64_txrotate(dma_info_t *di)
 		W_SM(&di->txd64[old].addrhigh, BUS_SWAP32(0xdeadbeef));
 
 		/* move the corresponding txp[] entry */
-		ASSERT(di->txp[new] == NULL);
 		di->txp[new] = di->txp[old];
 
 		/* Move the map */
@@ -1789,7 +1737,7 @@ uint dma_addrwidth(si_t *sih, void *dmaregs)
 			     (sih->buscoretype == PCIE_CORE_ID)))
 				return DMADDRWIDTH_64;
 	}
-	ASSERT(0); /* DMA hardware not supported by this driver*/
+	/* DMA hardware not supported by this driver*/
 	return DMADDRWIDTH_64;
 }
 
diff --git a/drivers/staging/brcm80211/util/nicpci.c b/drivers/staging/brcm80211/util/nicpci.c
index 8f80999..1e9ed15 100644
--- a/drivers/staging/brcm80211/util/nicpci.c
+++ b/drivers/staging/brcm80211/util/nicpci.c
@@ -83,8 +83,6 @@ void *pcicore_init(si_t *sih, void *pdev, void *regs)
 {
 	pcicore_info_t *pi;
 
-	ASSERT(sih->bustype == PCI_BUS);
-
 	/* alloc pcicore_info_t */
 	pi = kzalloc(sizeof(pcicore_info_t), GFP_ATOMIC);
 	if (pi == NULL) {
@@ -101,7 +99,6 @@ void *pcicore_init(si_t *sih, void *pdev, void *regs)
 		cap_ptr =
 		    pcicore_find_pci_capability(pi->dev, PCI_CAP_PCIECAP_ID,
 						NULL, NULL);
-		ASSERT(cap_ptr);
 		pi->pciecap_lcreg_offset = cap_ptr + PCIE_CAP_LINKCTRL_OFFSET;
 	} else
 		pi->regs.pciregs = (struct sbpciregs *) regs;
@@ -187,8 +184,6 @@ pcie_readreg(sbpcieregs_t *pcieregs, uint addrtype,
 {
 	uint retval = 0xFFFFFFFF;
 
-	ASSERT(pcieregs != NULL);
-
 	switch (addrtype) {
 	case PCIE_CONFIGREGS:
 		W_REG((&pcieregs->configaddr), offset);
@@ -201,7 +196,6 @@ pcie_readreg(sbpcieregs_t *pcieregs, uint addrtype,
 		retval = R_REG(&(pcieregs->pcieinddata));
 		break;
 	default:
-		ASSERT(0);
 		break;
 	}
 
@@ -212,8 +206,6 @@ uint
 pcie_writereg(sbpcieregs_t *pcieregs, uint addrtype,
 	      uint offset, uint val)
 {
-	ASSERT(pcieregs != NULL);
-
 	switch (addrtype) {
 	case PCIE_CONFIGREGS:
 		W_REG((&pcieregs->configaddr), offset);
@@ -224,7 +216,6 @@ pcie_writereg(sbpcieregs_t *pcieregs, uint addrtype,
 		W_REG((&pcieregs->pcieinddata), val);
 		break;
 	default:
-		ASSERT(0);
 		break;
 	}
 	return 0;
@@ -384,7 +375,6 @@ static void pcie_extendL1timer(pcicore_info_t *pi, bool extend)
 static void pcie_clkreq_upd(pcicore_info_t *pi, uint state)
 {
 	si_t *sih = pi->sih;
-	ASSERT(PCIE_PUB(sih));
 
 	switch (state) {
 	case SI_DOATTACH:
@@ -416,7 +406,6 @@ static void pcie_clkreq_upd(pcicore_info_t *pi, uint state)
 		}
 		break;
 	default:
-		ASSERT(0);
 		break;
 	}
 }
@@ -529,13 +518,12 @@ static void pcie_misc_config_fixup(pcicore_info_t *pi)
 
 /* quick hack for testing */
 /* Needs to happen when coming out of 'standby'/'hibernate' */
+/* precondition: pi->sih->buscorerev == 7 */
 static void pcie_war_noplldown(pcicore_info_t *pi)
 {
 	sbpcieregs_t *pcieregs = pi->regs.pcieregs;
 	u16 *reg16;
 
-	ASSERT(pi->sih->buscorerev == 7);
-
 	/* turn off serdes PLL down */
 	ai_corereg(pi->sih, SI_CC_IDX, offsetof(chipcregs_t, chipcontrol),
 		   CHIPCTRL_4321_PLL_DOWN, CHIPCTRL_4321_PLL_DOWN);
diff --git a/drivers/staging/brcm80211/util/qmath.c b/drivers/staging/brcm80211/util/qmath.c
index 40c9929..e9cb2fe 100644
--- a/drivers/staging/brcm80211/util/qmath.c
+++ b/drivers/staging/brcm80211/util/qmath.c
@@ -555,7 +555,6 @@ void qm_log10(s32 N, s16 qN, s16 *log10N, s16 *qLog10N)
 	/* Logerithm of negative values is undefined.
 	 * assert N is greater than 0.
 	 */
-	/* ASSERT(N > 0); */
 
 	/* normalize the N. */
 	s16norm = qm_norm32(N);
-- 
1.7.1


