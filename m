Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2391 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106Ab1ECJgR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:17 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: [PATCH 23/61] staging: brcm80211: removed ASSERTs from util
 dir, part 2
Date: Tue, 3 May 2011 11:35:23 +0200
Message-ID: <1304415361-7813-24-git-send-email-arend@broadcom.com> (sfid-20110503_113838_647099_77D1DC5E)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>


Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/util/aiutils.c  |   29 -----------
 drivers/staging/brcm80211/util/bcmutils.c |    4 --
 drivers/staging/brcm80211/util/bcmwifi.c  |    3 -
 drivers/staging/brcm80211/util/hnddma.c   |   57 +----------------------
 drivers/staging/brcm80211/util/hndpmu.c   |   74 +----------------------------
 drivers/staging/brcm80211/util/nicpci.c   |   13 -----
 drivers/staging/brcm80211/util/qmath.c    |    5 --
 drivers/staging/brcm80211/util/siutils.c  |   57 +---------------------
 8 files changed, 4 insertions(+), 238 deletions(-)

diff --git a/drivers/staging/brcm80211/util/aiutils.c b/drivers/staging/brcm80211/util/aiutils.c
index 5708690..ba205ce 100644
--- a/drivers/staging/brcm80211/util/aiutils.c
+++ b/drivers/staging/brcm80211/util/aiutils.c
@@ -138,7 +138,6 @@ void ai_scan(si_t *sih, void *regs, uint devid)
 	default:
 		SI_ERROR(("Don't know how to do AXI enumertion on bus %d\n",
 			  sih->bustype));
-		ASSERT(0);
 		return;
 	}
 	eromlim = eromptr + (ER_REMAPCONTROL / sizeof(u32));
@@ -322,24 +321,15 @@ void *ai_setcoreidx(si_t *sih, uint coreidx)
 	if (coreidx >= sii->numcores)
 		return NULL;
 
-	/*
-	 * If the user has provided an interrupt mask enabled function,
-	 * then assert interrupts are disabled before switching the core.
-	 */
-	ASSERT((sii->intrsenabled_fn == NULL)
-	       || !(*(sii)->intrsenabled_fn) ((sii)->intr_arg));
-
 	switch (sih->bustype) {
 	case SI_BUS:
 		/* map new one */
 		if (!sii->regs[coreidx]) {
 			sii->regs[coreidx] = REG_MAP(addr, SI_CORE_SIZE);
-			ASSERT(GOODREGS(sii->regs[coreidx]));
 		}
 		sii->curmap = regs = sii->regs[coreidx];
 		if (!sii->wrappers[coreidx]) {
 			sii->wrappers[coreidx] = REG_MAP(wrap, SI_CORE_SIZE);
-			ASSERT(GOODREGS(sii->wrappers[coreidx]));
 		}
 		sii->curwrap = sii->wrappers[coreidx];
 		break;
@@ -359,7 +349,6 @@ void *ai_setcoreidx(si_t *sih, uint coreidx)
 		break;
 
 	default:
-		ASSERT(0);
 		regs = NULL;
 		break;
 	}
@@ -494,10 +483,6 @@ uint ai_corereg(si_t *sih, uint coreidx, uint regoff, uint mask, uint val)
 
 	sii = SI_INFO(sih);
 
-	ASSERT(GOODIDX(coreidx));
-	ASSERT(regoff < SI_CORE_SIZE);
-	ASSERT((val & ~mask) == 0);
-
 	if (coreidx >= SI_MAXCORES)
 		return 0;
 
@@ -508,7 +493,6 @@ uint ai_corereg(si_t *sih, uint coreidx, uint regoff, uint mask, uint val)
 		if (!sii->regs[coreidx]) {
 			sii->regs[coreidx] = REG_MAP(sii->coresba[coreidx],
 						     SI_CORE_SIZE);
-			ASSERT(GOODREGS(sii->regs[coreidx]));
 		}
 		r = (u32 *) ((unsigned char *) sii->regs[coreidx] + regoff);
 	} else if (sih->bustype == PCI_BUS) {
@@ -548,7 +532,6 @@ uint ai_corereg(si_t *sih, uint coreidx, uint regoff, uint mask, uint val)
 		r = (u32 *) ((unsigned char *) ai_setcoreidx(&sii->pub, coreidx) +
 				regoff);
 	}
-	ASSERT(r != NULL);
 
 	/* mask and set */
 	if (mask || val) {
@@ -578,7 +561,6 @@ void ai_core_disable(si_t *sih, u32 bits)
 
 	sii = SI_INFO(sih);
 
-	ASSERT(GOODREGS(sii->curwrap));
 	ai = sii->curwrap;
 
 	/* if core is already in reset, just return */
@@ -605,7 +587,6 @@ void ai_core_reset(si_t *sih, u32 bits, u32 resetbits)
 	volatile u32 dummy;
 
 	sii = SI_INFO(sih);
-	ASSERT(GOODREGS(sii->curwrap));
 	ai = sii->curwrap;
 
 	/*
@@ -640,11 +621,8 @@ void ai_core_cflags_wo(si_t *sih, u32 mask, u32 val)
 		return;
 	}
 
-	ASSERT(GOODREGS(sii->curwrap));
 	ai = sii->curwrap;
 
-	ASSERT((val & ~mask) == 0);
-
 	if (mask || val) {
 		w = ((R_REG(&ai->ioctrl) & ~mask) | val);
 		W_REG(&ai->ioctrl, w);
@@ -664,11 +642,8 @@ u32 ai_core_cflags(si_t *sih, u32 mask, u32 val)
 		return 0;
 	}
 
-	ASSERT(GOODREGS(sii->curwrap));
 	ai = sii->curwrap;
 
-	ASSERT((val & ~mask) == 0);
-
 	if (mask || val) {
 		w = ((R_REG(&ai->ioctrl) & ~mask) | val);
 		W_REG(&ai->ioctrl, w);
@@ -689,12 +664,8 @@ u32 ai_core_sflags(si_t *sih, u32 mask, u32 val)
 		return 0;
 	}
 
-	ASSERT(GOODREGS(sii->curwrap));
 	ai = sii->curwrap;
 
-	ASSERT((val & ~mask) == 0);
-	ASSERT((mask & ~SISF_CORE_BITS) == 0);
-
 	if (mask || val) {
 		w = ((R_REG(&ai->iostatus) & ~mask) | val);
 		W_REG(&ai->iostatus, w);
diff --git a/drivers/staging/brcm80211/util/bcmutils.c b/drivers/staging/brcm80211/util/bcmutils.c
index 2aead97..e23e2e9 100644
--- a/drivers/staging/brcm80211/util/bcmutils.c
+++ b/drivers/staging/brcm80211/util/bcmutils.c
@@ -280,8 +280,6 @@ void pktq_flush(struct pktq *pq, bool dir,
 	int prec;
 	for (prec = 0; prec < pq->num_prec; prec++)
 		pktq_pflush(pq, prec, dir, fn, arg);
-	if (fn == NULL)
-		ASSERT(pq->len == 0);
 }
 #endif /* BRCM_FULLMAC */
 
@@ -289,8 +287,6 @@ void pktq_init(struct pktq *pq, int num_prec, int max_len)
 {
 	int prec;
 
-	ASSERT(num_prec > 0 && num_prec <= PKTQ_MAX_PREC);
-
 	/* pq is variable size; only zero out what's requested */
 	memset(pq, 0,
 	      offsetof(struct pktq, q) + (sizeof(struct pktq_prec) * num_prec));
diff --git a/drivers/staging/brcm80211/util/bcmwifi.c b/drivers/staging/brcm80211/util/bcmwifi.c
index d82c2b2..b03cb4a 100644
--- a/drivers/staging/brcm80211/util/bcmwifi.c
+++ b/drivers/staging/brcm80211/util/bcmwifi.c
@@ -60,7 +60,6 @@ u8 wf_chspec_ctlchan(chanspec_t chspec)
 		return CHSPEC_CHANNEL(chspec);
 	} else {
 		/* we only support 40MHZ with sidebands */
-		ASSERT(CHSPEC_BW(chspec) == WL_CHANSPEC_BW_40);
 		/* chanspec channel holds the centre frequency, use that and the
 		 * side band information to reconstruct the control channel number
 		 */
@@ -68,8 +67,6 @@ u8 wf_chspec_ctlchan(chanspec_t chspec)
 			/* control chan is the upper 20 MHZ SB of the 40MHZ channel */
 			ctl_chan = UPPER_20_SB(CHSPEC_CHANNEL(chspec));
 		} else {
-			ASSERT(CHSPEC_CTL_SB(chspec) ==
-			       WL_CHANSPEC_CTL_SB_LOWER);
 			/* control chan is the lower 20 MHZ SB of the 40MHZ channel */
 			ctl_chan = LOWER_20_SB(CHSPEC_CHANNEL(chspec));
 		}
diff --git a/drivers/staging/brcm80211/util/hnddma.c b/drivers/staging/brcm80211/util/hnddma.c
index 0684fb1..950d862 100644
--- a/drivers/staging/brcm80211/util/hnddma.c
+++ b/drivers/staging/brcm80211/util/hnddma.c
@@ -293,23 +293,9 @@ struct hnddma_pub *dma_attach(char *name, si_t *sih,
 
 	di->msg_level = msg_level ? msg_level : &dma_msg_level;
 
-	/* old chips w/o sb is no longer supported */
-	ASSERT(sih != NULL);
-
 	di->dma64 = ((si_core_sflags(sih, 0, 0) & SISF_DMA64) == SISF_DMA64);
 
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
@@ -488,7 +474,6 @@ dma64_dd_upd(dma_info_t *di, dma64dd_t *ddring, dmaaddr_t pa, uint outidx,
 #else
 	if ((di->dataoffsetlow == 0) || !(PHYSADDRLO(pa) & PCI32ADDR_HIGH)) {
 #endif				/* defined(__mips__) && defined(IL_BIGENDIAN) */
-		ASSERT((PHYSADDRHI(pa) & PCI64ADDR_HIGH) == 0);
 
 		W_SM(&ddring[outidx].addrlow,
 		     BUS_SWAP32(PHYSADDRLO(pa) + di->dataoffsetlow));
@@ -499,11 +484,9 @@ dma64_dd_upd(dma_info_t *di, dma64dd_t *ddring, dmaaddr_t pa, uint outidx,
 	} else {
 		/* address extension for 32-bit PCI */
 		u32 ae;
-		ASSERT(di->addrext);
 
 		ae = (PHYSADDRLO(pa) & PCI32ADDR_HIGH) >> PCI32ADDR_HIGH_SHIFT;
 		PHYSADDRLO(pa) &= ~PCI32ADDR_HIGH;
-		ASSERT(PHYSADDRHI(pa) == 0);
 
 		ctrl2 |= (ae << D64_CTRL2_AE_SHIFT) & D64_CTRL2_AE;
 		W_SM(&ddring[outidx].addrlow,
@@ -544,10 +527,6 @@ static void _dma_detach(dma_info_t *di)
 
 	DMA_TRACE(("%s: dma_detach\n", di->name));
 
-	/* shouldn't be here if descriptors are unreclaimed */
-	ASSERT(di->txin == di->txout);
-	ASSERT(di->rxin == di->rxout);
-
 	/* free dma descriptor rings */
 	if (di->txd64)
 		pci_free_consistent(di->pbus, di->txdalloc,
@@ -602,14 +581,12 @@ static bool _dma_isaddrext(dma_info_t *di)
 		if (!_dma64_addrext(di->d64txregs)) {
 			DMA_ERROR(("%s: _dma_isaddrext: DMA64 tx doesn't have "
 				   "AE set\n", di->name));
-			ASSERT(0);
 		}
 		return true;
 	} else if (di->d64rxregs != NULL) {
 		if (!_dma64_addrext(di->d64rxregs)) {
 			DMA_ERROR(("%s: _dma_isaddrext: DMA64 rx doesn't have "
 				   "AE set\n", di->name));
-			ASSERT(0);
 		}
 		return true;
 	}
@@ -642,8 +619,6 @@ static void _dma_ddtable_init(dma_info_t *di, uint direction, dmaaddr_t pa)
 	} else {
 		/* DMA64 32bits address extension */
 		u32 ae;
-		ASSERT(di->addrext);
-		ASSERT(PHYSADDRHI(pa) == 0);
 
 		/* shift the high bit(s) from pa to ae */
 		ae = (PHYSADDRLO(pa) & PCI32ADDR_HIGH) >>
@@ -783,7 +758,6 @@ static void *BCMFASTPATH _dma_rx(dma_info_t *di)
 #ifdef BCMDBG
 		if (resid > 0) {
 			uint cur;
-			ASSERT(p == NULL);
 			cur =
 			    B2I(((R_REG(&di->d64rxregs->status0) &
 				  D64_RS0_CD_MASK) -
@@ -874,10 +848,7 @@ static bool BCMFASTPATH _dma_rxfill(dma_info_t *di)
 		pa = pci_map_single(di->pbus, p->data,
 			di->rxbufsize, PCI_DMA_FROMDEVICE);
 
-		ASSERT(IS_ALIGNED(PHYSADDRLO(pa), 4));
-
 		/* save the free packet pointer */
-		ASSERT(di->rxp[rxout] == NULL);
 		di->rxp[rxout] = p;
 
 		/* reset flags for each descriptor */
@@ -1019,8 +990,6 @@ static uint _dma_ctrlflags(dma_info_t *di, uint mask, uint flags)
 		return 0;
 	}
 
-	ASSERT((flags & ~mask) == 0);
-
 	dmactrlflags &= ~mask;
 	dmactrlflags |= flags;
 
@@ -1053,9 +1022,6 @@ static unsigned long _dma_getvar(dma_info_t *di, const char *name)
 {
 	if (!strcmp(name, "&txavail"))
 		return (unsigned long)&(di->hnddma.txavail);
-	else {
-		ASSERT(0);
-	}
 	return 0;
 }
 
@@ -1063,8 +1029,6 @@ static
 u8 dma_align_sizetobits(uint size)
 {
 	u8 bitpos = 0;
-	ASSERT(size);
-	ASSERT(!(size & (size - 1)));
 	while (size >>= 1) {
 		bitpos++;
 	}
@@ -1230,12 +1194,8 @@ static bool dma64_alloc(dma_info_t *di, uint direction)
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
@@ -1248,12 +1208,8 @@ static bool dma64_alloc(dma_info_t *di, uint direction)
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
@@ -1396,7 +1352,6 @@ static int dma64_txunframed(dma_info_t *di, void *buf, uint len, bool commit)
 		flags |= D64_CTRL1_EOT;
 
 	dma64_dd_upd(di, di->txd64, pa, txout, &flags, len);
-	ASSERT(di->txp[txout] == NULL);
 
 	/* save the buffer pointer - used by dma_getpos */
 	di->txp[txout] = buf;
@@ -1501,7 +1456,6 @@ static int BCMFASTPATH dma64_txfast(dma_info_t *di, struct sk_buff *p0,
 				pa = map->segs[j - 1].addr;
 			}
 			dma64_dd_upd(di, di->txd64, pa, txout, &flags, len);
-			ASSERT(di->txp[txout] == NULL);
 
 			txout = NEXTTXD(txout);
 		}
@@ -1648,9 +1602,6 @@ static void *BCMFASTPATH dma64_getnextrxp(dma_info_t *di, bool forceall)
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
@@ -1709,8 +1659,6 @@ static void dma64_txrotate(dma_info_t *di)
 	u32 w;
 	u16 first, last;
 
-	ASSERT(dma64_txsuspendedidle(di));
-
 	nactive = _dma_txactive(di);
 	ad = (u16) (B2I
 		       ((((R_REG(&di->d64txregs->status1) &
@@ -1718,8 +1666,6 @@ static void dma64_txrotate(dma_info_t *di)
 			  - di->xmtptrbase) & D64_XS1_AD_MASK), dma64dd_t));
 	rot = TXD(ad - di->txin);
 
-	ASSERT(rot < di->ntxd);
-
 	/* full-ring case is a lot harder - don't worry about this */
 	if (rot >= (di->ntxd - nactive)) {
 		DMA_ERROR(("%s: dma_txrotate: ring full - punt\n", di->name));
@@ -1753,7 +1699,6 @@ static void dma64_txrotate(dma_info_t *di)
 		W_SM(&di->txd64[old].addrhigh, BUS_SWAP32(0xdeadbeef));
 
 		/* move the corresponding txp[] entry */
-		ASSERT(di->txp[new] == NULL);
 		di->txp[new] = di->txp[old];
 
 		/* Move the map */
@@ -1789,7 +1734,7 @@ uint dma_addrwidth(si_t *sih, void *dmaregs)
 			     (sih->buscoretype == PCIE_CORE_ID)))
 				return DMADDRWIDTH_64;
 	}
-	ASSERT(0); /* DMA hardware not supported by this driver*/
+	/* DMA hardware not supported by this driver*/
 	return DMADDRWIDTH_64;
 }
 
diff --git a/drivers/staging/brcm80211/util/hndpmu.c b/drivers/staging/brcm80211/util/hndpmu.c
index 8426a27..2518b63 100644
--- a/drivers/staging/brcm80211/util/hndpmu.c
+++ b/drivers/staging/brcm80211/util/hndpmu.c
@@ -107,12 +107,9 @@ void si_pmu_set_switcher_voltage(si_t *sih, u8 bb_voltage, u8 rf_voltage)
 	chipcregs_t *cc;
 	uint origidx;
 
-	ASSERT(sih->cccaps & CC_CAP_PMU);
-
 	/* Remember original core before switch to chipc */
 	origidx = si_coreidx(sih);
 	cc = si_setcoreidx(sih, SI_CC_IDX);
-	ASSERT(cc != NULL);
 
 	W_REG(&cc->regcontrol_addr, 0x01);
 	W_REG(&cc->regcontrol_data, (u32) (bb_voltage & 0x1f) << 22);
@@ -129,8 +126,6 @@ void si_pmu_set_ldo_voltage(si_t *sih, u8 ldo, u8 voltage)
 	u8 sr_cntl_shift = 0, rc_shift = 0, shift = 0, mask = 0;
 	u8 addr = 0;
 
-	ASSERT(sih->cccaps & CC_CAP_PMU);
-
 	switch (sih->chip) {
 	case BCM4336_CHIP_ID:
 		switch (ldo) {
@@ -150,7 +145,6 @@ void si_pmu_set_ldo_voltage(si_t *sih, u8 ldo, u8 voltage)
 			mask = 0xf;
 			break;
 		default:
-			ASSERT(false);
 			return;
 		}
 		break;
@@ -162,12 +156,10 @@ void si_pmu_set_ldo_voltage(si_t *sih, u8 ldo, u8 voltage)
 			mask = 0x1f;
 			break;
 		default:
-			ASSERT(false);
 			break;
 		}
 		break;
 	default:
-		ASSERT(false);
 		return;
 	}
 
@@ -192,12 +184,10 @@ u16 si_pmu_fast_pwrup_delay(si_t *sih)
 	chn[0] = 0;		/* to suppress compile error */
 #endif
 
-	ASSERT(sih->cccaps & CC_CAP_PMU);
 
 	/* Remember original core before switch to chipc */
 	origidx = si_coreidx(sih);
 	cc = si_setcoreidx(sih, SI_CC_IDX);
-	ASSERT(cc != NULL);
 
 	switch (sih->chip) {
 	case BCM43224_CHIP_ID:
@@ -265,12 +255,9 @@ u32 si_pmu_force_ilp(si_t *sih, bool force)
 	uint origidx;
 	u32 oldpmucontrol;
 
-	ASSERT(sih->cccaps & CC_CAP_PMU);
-
 	/* Remember original core before switch to chipc */
 	origidx = si_coreidx(sih);
 	cc = si_setcoreidx(sih, SI_CC_IDX);
-	ASSERT(cc != NULL);
 
 	oldpmucontrol = R_REG(&cc->pmucontrol);
 	if (force)
@@ -689,12 +676,9 @@ void si_pmu_res_init(si_t *sih)
 	char name[8], *val;
 	uint i, rsrcs;
 
-	ASSERT(sih->cccaps & CC_CAP_PMU);
-
 	/* Remember original core before switch to chipc */
 	origidx = si_coreidx(sih);
 	cc = si_setcoreidx(sih, SI_CC_IDX);
-	ASSERT(cc != NULL);
 
 	switch (sih->chip) {
 	case BCM4329_CHIP_ID:
@@ -768,7 +752,6 @@ void si_pmu_res_init(si_t *sih)
 
 	/* Program up/down timers */
 	while (pmu_res_updown_table_sz--) {
-		ASSERT(pmu_res_updown_table != NULL);
 		PMU_MSG(("Changing rsrc %d res_updn_timer to 0x%x\n",
 			 pmu_res_updown_table[pmu_res_updown_table_sz].resnum,
 			 pmu_res_updown_table[pmu_res_updown_table_sz].updown));
@@ -792,7 +775,6 @@ void si_pmu_res_init(si_t *sih)
 
 	/* Program resource dependencies table */
 	while (pmu_res_depend_table_sz--) {
-		ASSERT(pmu_res_depend_table != NULL);
 		if (pmu_res_depend_table[pmu_res_depend_table_sz].filter != NULL
 		    && !(pmu_res_depend_table[pmu_res_depend_table_sz].
 			 filter) (sih))
@@ -823,7 +805,6 @@ void si_pmu_res_init(si_t *sih)
 					[pmu_res_depend_table_sz].depend_mask);
 				break;
 			default:
-				ASSERT(0);
 				break;
 			}
 		}
@@ -1112,7 +1093,6 @@ static const pmu1_xtaltab0_t *si_pmu1_xtaltab0(si_t *sih)
 			 bcm_chipname(sih->chip, chn, 8)));
 		break;
 	}
-	ASSERT(0);
 	return NULL;
 }
 
@@ -1144,7 +1124,6 @@ static const pmu1_xtaltab0_t *si_pmu1_xtaldef0(si_t *sih)
 			 bcm_chipname(sih->chip, chn, 8)));
 		break;
 	}
-	ASSERT(0);
 	return NULL;
 }
 
@@ -1172,7 +1151,6 @@ static u32 si_pmu1_pllfvco0(si_t *sih)
 			 bcm_chipname(sih->chip, chn, 8)));
 		break;
 	}
-	ASSERT(0);
 	return 0;
 }
 
@@ -1192,8 +1170,6 @@ si_pmu1_alpclk0(si_t *sih, chipcregs_t *cc)
 	/* Could not find it so assign a default value */
 	if (xt == NULL || xt->fref == 0)
 		xt = si_pmu1_xtaldef0(sih);
-	ASSERT(xt != NULL && xt->fref != 0);
-
 	return xt->fref * 1000;
 }
 
@@ -1256,7 +1232,6 @@ static void si_pmu1_pllinit0(si_t *sih, chipcregs_t *cc, u32 xtal)
 			  PMURES_BIT(RES4329_HT_AVAIL)));
 		SPINWAIT(R_REG(&cc->clk_ctl_st) & CCS_HTAVAIL,
 			 PMU_MAX_TRANSITION_DLY);
-		ASSERT(!(R_REG(&cc->clk_ctl_st) & CCS_HTAVAIL));
 		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL4);
 		if (xt->fref == 38400)
 			tmp = 0x200024C0;
@@ -1301,7 +1276,6 @@ static void si_pmu1_pllinit0(si_t *sih, chipcregs_t *cc, u32 xtal)
 		udelay(100);
 		SPINWAIT(R_REG(&cc->clk_ctl_st) & CCS_HTAVAIL,
 			 PMU_MAX_TRANSITION_DLY);
-		ASSERT(!(R_REG(&cc->clk_ctl_st) & CCS_HTAVAIL));
 		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL4);
 		tmp = 0x200005c0;
 		W_REG(&cc->pllcontrol_data, tmp);
@@ -1317,7 +1291,6 @@ static void si_pmu1_pllinit0(si_t *sih, chipcregs_t *cc, u32 xtal)
 		udelay(100);
 		SPINWAIT(R_REG(&cc->clk_ctl_st) & CCS_HTAVAIL,
 			 PMU_MAX_TRANSITION_DLY);
-		ASSERT(!(R_REG(&cc->clk_ctl_st) & CCS_HTAVAIL));
 		break;
 
 	case BCM4330_CHIP_ID:
@@ -1330,11 +1303,10 @@ static void si_pmu1_pllinit0(si_t *sih, chipcregs_t *cc, u32 xtal)
 		udelay(100);
 		SPINWAIT(R_REG(&cc->clk_ctl_st) & CCS_HTAVAIL,
 			 PMU_MAX_TRANSITION_DLY);
-		ASSERT(!(R_REG(&cc->clk_ctl_st) & CCS_HTAVAIL));
 		break;
 
 	default:
-		ASSERT(0);
+		break;
 	}
 
 	PMU_MSG(("Done masking\n"));
@@ -1468,12 +1440,9 @@ void si_pmu_pll_init(si_t *sih, uint xtalfreq)
 	char chn[8];
 #endif
 
-	ASSERT(sih->cccaps & CC_CAP_PMU);
-
 	/* Remember original core before switch to chipc */
 	origidx = si_coreidx(sih);
 	cc = si_setcoreidx(sih, SI_CC_IDX);
-	ASSERT(cc != NULL);
 
 	switch (sih->chip) {
 	case BCM4329_CHIP_ID:
@@ -1518,12 +1487,9 @@ u32 si_pmu_alp_clock(si_t *sih)
 	char chn[8];
 #endif
 
-	ASSERT(sih->cccaps & CC_CAP_PMU);
-
 	/* Remember original core before switch to chipc */
 	origidx = si_coreidx(sih);
 	cc = si_setcoreidx(sih, SI_CC_IDX);
-	ASSERT(cc != NULL);
 
 	switch (sih->chip) {
 	case BCM43224_CHIP_ID:
@@ -1630,12 +1596,9 @@ u32 si_pmu_si_clock(si_t *sih)
 	char chn[8];
 #endif
 
-	ASSERT(sih->cccaps & CC_CAP_PMU);
-
 	/* Remember original core before switch to chipc */
 	origidx = si_coreidx(sih);
 	cc = si_setcoreidx(sih, SI_CC_IDX);
-	ASSERT(cc != NULL);
 
 	switch (sih->chip) {
 	case BCM43224_CHIP_ID:
@@ -1706,8 +1669,6 @@ u32 si_pmu_cpu_clock(si_t *sih)
 	uint origidx;
 	u32 clock;
 
-	ASSERT(sih->cccaps & CC_CAP_PMU);
-
 	if ((sih->pmurev >= 5) &&
 	    !((sih->chip == BCM4329_CHIP_ID) ||
 	      (sih->chip == BCM4319_CHIP_ID) ||
@@ -1731,7 +1692,6 @@ u32 si_pmu_cpu_clock(si_t *sih)
 		/* Remember original core before switch to chipc */
 		origidx = si_coreidx(sih);
 		cc = si_setcoreidx(sih, SI_CC_IDX);
-		ASSERT(cc != NULL);
 
 		clock = si_pmu5_clock(sih, cc, pll, PMU5_MAINPLL_CPU);
 
@@ -1750,8 +1710,6 @@ u32 si_pmu_mem_clock(si_t *sih)
 	uint origidx;
 	u32 clock;
 
-	ASSERT(sih->cccaps & CC_CAP_PMU);
-
 	if ((sih->pmurev >= 5) &&
 	    !((sih->chip == BCM4329_CHIP_ID) ||
 	      (sih->chip == BCM4319_CHIP_ID) ||
@@ -1775,7 +1733,6 @@ u32 si_pmu_mem_clock(si_t *sih)
 		/* Remember original core before switch to chipc */
 		origidx = si_coreidx(sih);
 		cc = si_setcoreidx(sih, SI_CC_IDX);
-		ASSERT(cc != NULL);
 
 		clock = si_pmu5_clock(sih, cc, pll, PMU5_MAINPLL_MEM);
 
@@ -1802,7 +1759,6 @@ u32 si_pmu_ilp_clock(si_t *sih)
 		u32 start, end, delta;
 		u32 origidx = si_coreidx(sih);
 		chipcregs_t *cc = si_setcoreidx(sih, SI_CC_IDX);
-		ASSERT(cc != NULL);
 		start = R_REG(&cc->pmutimer);
 		mdelay(ILP_CALC_DUR);
 		end = R_REG(&cc->pmutimer);
@@ -1932,12 +1888,9 @@ void si_pmu_init(si_t *sih)
 	chipcregs_t *cc;
 	uint origidx;
 
-	ASSERT(sih->cccaps & CC_CAP_PMU);
-
 	/* Remember original core before switch to chipc */
 	origidx = si_coreidx(sih);
 	cc = si_setcoreidx(sih, SI_CC_IDX);
-	ASSERT(cc != NULL);
 
 	if (sih->pmurev == 1)
 		AND_REG(&cc->pmucontrol, ~PCTL_NOILP_ON_WAIT);
@@ -2021,8 +1974,6 @@ void si_pmu_otp_power(si_t *sih, bool on)
 	uint origidx;
 	u32 rsrcs = 0;	/* rsrcs to turn on/off OTP power */
 
-	ASSERT(sih->cccaps & CC_CAP_PMU);
-
 	/* Don't do anything if OTP is disabled */
 	if (si_is_otp_disabled(sih)) {
 		PMU_MSG(("si_pmu_otp_power: OTP is disabled\n"));
@@ -2032,7 +1983,6 @@ void si_pmu_otp_power(si_t *sih, bool on)
 	/* Remember original core before switch to chipc */
 	origidx = si_coreidx(sih);
 	cc = si_setcoreidx(sih, SI_CC_IDX);
-	ASSERT(cc != NULL);
 
 	switch (sih->chip) {
 	case BCM4329_CHIP_ID:
@@ -2066,7 +2016,6 @@ void si_pmu_otp_power(si_t *sih, bool on)
 			OR_REG(&cc->min_res_mask, (rsrcs | deps));
 			SPINWAIT(!(R_REG(&cc->res_state) & rsrcs),
 				 PMU_MAX_TRANSITION_DLY);
-			ASSERT(R_REG(&cc->res_state) & rsrcs);
 		} else {
 			PMU_MSG(("Removing rsrc 0x%x from min_res_mask\n",
 				 rsrcs | deps));
@@ -2075,7 +2024,6 @@ void si_pmu_otp_power(si_t *sih, bool on)
 
 		SPINWAIT((((otps = R_REG(&cc->otpstatus)) & OTPS_READY) !=
 			  (on ? OTPS_READY : 0)), 100);
-		ASSERT((otps & OTPS_READY) == (on ? OTPS_READY : 0));
 		if ((otps & OTPS_READY) != (on ? OTPS_READY : 0))
 			PMU_MSG(("OTP ready bit not %s after wait\n",
 				 (on ? "ON" : "OFF")));
@@ -2090,12 +2038,9 @@ void si_pmu_rcal(si_t *sih)
 	chipcregs_t *cc;
 	uint origidx;
 
-	ASSERT(sih->cccaps & CC_CAP_PMU);
-
 	/* Remember original core before switch to chipc */
 	origidx = si_coreidx(sih);
 	cc = si_setcoreidx(sih, SI_CC_IDX);
-	ASSERT(cc != NULL);
 
 	switch (sih->chip) {
 	case BCM4329_CHIP_ID:{
@@ -2114,7 +2059,6 @@ void si_pmu_rcal(si_t *sih)
 			/* Wait for completion */
 			SPINWAIT(0 == (R_REG(&cc->chipstatus) & 0x08),
 				 10 * 1000 * 1000);
-			ASSERT(R_REG(&cc->chipstatus) & 0x08);
 
 			/* Drop the LSB to convert from 5 bit code to 4 bit code */
 			rcal_code =
@@ -2173,7 +2117,6 @@ void si_pmu_spuravoid(si_t *sih, u8 spuravoid)
 	/* Remember original core before switch to chipc */
 	cc = (chipcregs_t *) si_switch_core(sih, CC_CORE_ID, &origidx,
 					    &intr_val);
-	ASSERT(cc != NULL);
 
 	/* force the HT off  */
 	if (sih->chip == BCM4336_CHIP_ID) {
@@ -2183,7 +2126,6 @@ void si_pmu_spuravoid(si_t *sih, u8 spuravoid)
 		/* wait for the ht to really go away */
 		SPINWAIT(((R_REG(&cc->clk_ctl_st) & CCS_HTAVAIL) == 0),
 			 10000);
-		ASSERT((R_REG(&cc->clk_ctl_st) & CCS_HTAVAIL) == 0);
 	}
 
 	/* update the pll changes */
@@ -2405,7 +2347,6 @@ bool si_pmu_is_otp_powered(si_t *sih)
 	/* Remember original core before switch to chipc */
 	idx = si_coreidx(sih);
 	cc = si_setcoreidx(sih, SI_CC_IDX);
-	ASSERT(cc != NULL);
 
 	switch (sih->chip) {
 	case BCM4329_CHIP_ID:
@@ -2454,7 +2395,6 @@ void si_pmu_sprom_enable(si_t *sih, bool enable)
 	/* Remember original core before switch to chipc */
 	origidx = si_coreidx(sih);
 	cc = si_setcoreidx(sih, SI_CC_IDX);
-	ASSERT(cc != NULL);
 
 	/* Return to original core */
 	si_setcoreidx(sih, origidx);
@@ -2465,8 +2405,6 @@ void si_pmu_chip_init(si_t *sih)
 {
 	uint origidx;
 
-	ASSERT(sih->cccaps & CC_CAP_PMU);
-
 	/* Gate off SPROM clock and chip select signals */
 	si_pmu_sprom_enable(sih, false);
 
@@ -2480,8 +2418,6 @@ void si_pmu_chip_init(si_t *sih)
 /* initialize PMU switch/regulators */
 void si_pmu_swreg_init(si_t *sih)
 {
-	ASSERT(sih->cccaps & CC_CAP_PMU);
-
 	switch (sih->chip) {
 	case BCM4336_CHIP_ID:
 		/* Reduce CLDO PWM output voltage to 1.2V */
@@ -2506,8 +2442,6 @@ void si_pmu_swreg_init(si_t *sih)
 
 void si_pmu_radio_enable(si_t *sih, bool enable)
 {
-	ASSERT(sih->cccaps & CC_CAP_PMU);
-
 	switch (sih->chip) {
 	case BCM4319_CHIP_ID:
 		if (enable)
@@ -2527,12 +2461,9 @@ si_pmu_waitforclk_on_backplane(si_t *sih, u32 clk, u32 delay)
 	chipcregs_t *cc;
 	uint origidx;
 
-	ASSERT(sih->cccaps & CC_CAP_PMU);
-
 	/* Remember original core before switch to chipc */
 	origidx = si_coreidx(sih);
 	cc = si_setcoreidx(sih, SI_CC_IDX);
-	ASSERT(cc != NULL);
 
 	if (delay)
 		SPINWAIT(((R_REG(&cc->pmustatus) & clk) != clk), delay);
@@ -2559,12 +2490,9 @@ u32 si_pmu_measure_alpclk(si_t *sih)
 	if (sih->pmurev < 10)
 		return 0;
 
-	ASSERT(sih->cccaps & CC_CAP_PMU);
-
 	/* Remember original core before switch to chipc */
 	origidx = si_coreidx(sih);
 	cc = si_setcoreidx(sih, SI_CC_IDX);
-	ASSERT(cc != NULL);
 
 	if (R_REG(&cc->pmustatus) & PST_EXTLPOAVAIL) {
 		u32 ilp_ctr, alp_hz;
diff --git a/drivers/staging/brcm80211/util/nicpci.c b/drivers/staging/brcm80211/util/nicpci.c
index 6eabbed..81a7d69 100644
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
@@ -100,7 +98,6 @@ void *pcicore_init(si_t *sih, void *pdev, void *regs)
 		pi->regs.pcieregs = (sbpcieregs_t *) regs;
 		cap_ptr = pcicore_find_pci_capability(pi->dev, PCI_CAP_ID_EXP,
 						      NULL, NULL);
-		ASSERT(cap_ptr);
 		pi->pciecap_lcreg_offset = cap_ptr + PCIE_CAP_LINKCTRL_OFFSET;
 	} else
 		pi->regs.pciregs = (struct sbpciregs *) regs;
@@ -186,8 +183,6 @@ pcie_readreg(sbpcieregs_t *pcieregs, uint addrtype,
 {
 	uint retval = 0xFFFFFFFF;
 
-	ASSERT(pcieregs != NULL);
-
 	switch (addrtype) {
 	case PCIE_CONFIGREGS:
 		W_REG((&pcieregs->configaddr), offset);
@@ -200,7 +195,6 @@ pcie_readreg(sbpcieregs_t *pcieregs, uint addrtype,
 		retval = R_REG(&(pcieregs->pcieinddata));
 		break;
 	default:
-		ASSERT(0);
 		break;
 	}
 
@@ -211,8 +205,6 @@ uint
 pcie_writereg(sbpcieregs_t *pcieregs, uint addrtype,
 	      uint offset, uint val)
 {
-	ASSERT(pcieregs != NULL);
-
 	switch (addrtype) {
 	case PCIE_CONFIGREGS:
 		W_REG((&pcieregs->configaddr), offset);
@@ -223,7 +215,6 @@ pcie_writereg(sbpcieregs_t *pcieregs, uint addrtype,
 		W_REG((&pcieregs->pcieinddata), val);
 		break;
 	default:
-		ASSERT(0);
 		break;
 	}
 	return 0;
@@ -383,7 +374,6 @@ static void pcie_extendL1timer(pcicore_info_t *pi, bool extend)
 static void pcie_clkreq_upd(pcicore_info_t *pi, uint state)
 {
 	si_t *sih = pi->sih;
-	ASSERT(PCIE_PUB(sih));
 
 	switch (state) {
 	case SI_DOATTACH:
@@ -415,7 +405,6 @@ static void pcie_clkreq_upd(pcicore_info_t *pi, uint state)
 		}
 		break;
 	default:
-		ASSERT(0);
 		break;
 	}
 }
@@ -533,8 +522,6 @@ static void pcie_war_noplldown(pcicore_info_t *pi)
 	sbpcieregs_t *pcieregs = pi->regs.pcieregs;
 	u16 *reg16;
 
-	ASSERT(pi->sih->buscorerev == 7);
-
 	/* turn off serdes PLL down */
 	si_corereg(pi->sih, SI_CC_IDX, offsetof(chipcregs_t, chipcontrol),
 		   CHIPCTRL_4321_PLL_DOWN, CHIPCTRL_4321_PLL_DOWN);
diff --git a/drivers/staging/brcm80211/util/qmath.c b/drivers/staging/brcm80211/util/qmath.c
index 40c9929..8b4a5b1 100644
--- a/drivers/staging/brcm80211/util/qmath.c
+++ b/drivers/staging/brcm80211/util/qmath.c
@@ -552,11 +552,6 @@ void qm_log10(s32 N, s16 qN, s16 *log10N, s16 *qLog10N)
 	u16 u16offset;
 	s32 s32log;
 
-	/* Logerithm of negative values is undefined.
-	 * assert N is greater than 0.
-	 */
-	/* ASSERT(N > 0); */
-
 	/* normalize the N. */
 	s16norm = qm_norm32(N);
 	N = N << s16norm;
diff --git a/drivers/staging/brcm80211/util/siutils.c b/drivers/staging/brcm80211/util/siutils.c
index 9e181d6..202a8cff 100644
--- a/drivers/staging/brcm80211/util/siutils.c
+++ b/drivers/staging/brcm80211/util/siutils.c
@@ -172,7 +172,6 @@ static bool si_buscore_setup(si_info_t *sii, chipcregs_t *cc, uint bustype,
 	uint pciidx, pcieidx, pcirev, pcierev;
 
 	cc = si_setcoreidx(&sii->pub, SI_CC_IDX);
-	ASSERT(cc);
 
 	/* get chipcommon rev */
 	sii->pub.ccrev = (int)si_corerev(&sii->pub);
@@ -357,7 +356,6 @@ static __used void si_nvram_process(si_info_t *sii, char *pvars)
 
 	if (sii->pub.boardtype == 0) {
 		SI_ERROR(("si_doattach: unknown board type\n"));
-		ASSERT(sii->pub.boardtype);
 	}
 
 	sii->pub.boardflags = getintvar(pvars, "boardflags");
@@ -375,8 +373,6 @@ static si_info_t *si_doattach(si_info_t *sii, uint devid,
 	chipcregs_t *cc;
 	uint origidx;
 
-	ASSERT(GOODREGS(regs));
-
 	memset((unsigned char *) sii, 0, sizeof(si_info_t));
 
 	savewin = 0;
@@ -452,8 +448,6 @@ static si_info_t *si_doattach(si_info_t *sii, uint devid,
 	char *pvars = NULL;
 	uint origidx;
 
-	ASSERT(GOODREGS(regs));
-
 	memset((unsigned char *) sii, 0, sizeof(si_info_t));
 
 	savewin = 0;
@@ -588,7 +582,6 @@ static si_info_t *si_doattach(si_info_t *sii, uint devid,
 	si_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, gpiotimerval), ~0, w);
 
 	if (PCIE(sii)) {
-		ASSERT(sii->pch != NULL);
 		pcicore_attach(sii->pch, pvars, SI_DOATTACH);
 	}
 
@@ -702,7 +695,6 @@ uint si_flag(si_t *sih)
 	if (sih->socitype == SOCI_AI)
 		return ai_flag(sih);
 	else {
-		ASSERT(0);
 		return 0;
 	}
 }
@@ -711,8 +703,6 @@ void si_setint(si_t *sih, int siflag)
 {
 	if (sih->socitype == SOCI_AI)
 		ai_setint(sih, siflag);
-	else
-		ASSERT(0);
 }
 
 #ifndef BCMSDIO
@@ -743,10 +733,7 @@ uint si_corerev(si_t *sih)
 {
 	if (sih->socitype == SOCI_AI)
 		return ai_corerev(sih);
-	else {
-		ASSERT(0);
-		return 0;
-	}
+	return 0;
 }
 #endif
 
@@ -790,7 +777,6 @@ void *si_setcore(si_t *sih, uint coreid, uint coreunit)
 #ifdef BCMSDIO
 		return sb_setcoreidx(sih, idx);
 #else
-		ASSERT(0);
 		return NULL;
 #endif
 	}
@@ -802,7 +788,6 @@ void *si_setcoreidx(si_t *sih, uint coreidx)
 	if (sih->socitype == SOCI_AI)
 		return ai_setcoreidx(sih, coreidx);
 	else {
-		ASSERT(0);
 		return NULL;
 	}
 }
@@ -830,7 +815,6 @@ void *si_switch_core(si_t *sih, uint coreid, uint *origidx, uint *intr_val)
 	INTR_OFF(sii, *intr_val);
 	*origidx = sii->curidx;
 	cc = si_setcore(sih, coreid, 0);
-	ASSERT(cc != NULL);
 
 	return cc;
 }
@@ -854,7 +838,6 @@ u32 si_core_cflags(si_t *sih, u32 mask, u32 val)
 	if (sih->socitype == SOCI_AI)
 		return ai_core_cflags(sih, mask, val);
 	else {
-		ASSERT(0);
 		return 0;
 	}
 }
@@ -864,7 +847,6 @@ u32 si_core_sflags(si_t *sih, u32 mask, u32 val)
 	if (sih->socitype == SOCI_AI)
 		return ai_core_sflags(sih, mask, val);
 	else {
-		ASSERT(0);
 		return 0;
 	}
 }
@@ -877,7 +859,6 @@ bool si_iscoreup(si_t *sih)
 #ifdef BCMSDIO
 		return sb_iscoreup(sih);
 #else
-		ASSERT(0);
 		return false;
 #endif
 	}
@@ -900,7 +881,6 @@ uint si_corereg(si_t *sih, uint coreidx, uint regoff, uint mask, uint val)
 #ifdef BCMSDIO
 		return sb_corereg(sih, coreidx, regoff, mask, val);
 #else
-		ASSERT(0);
 		return 0;
 #endif
 	}
@@ -1020,8 +1000,6 @@ static uint si_slowclk_src(si_info_t *sii)
 	chipcregs_t *cc;
 	u32 val;
 
-	ASSERT(SI_FAST(sii) || si_coreid(&sii->pub) == CC_CORE_ID);
-
 	if (sii->pub.ccrev < 6) {
 		if (sii->pub.bustype == PCI_BUS) {
 			pci_read_config_dword(sii->pbus, PCI_GPIO_OUT,
@@ -1043,11 +1021,6 @@ static uint si_slowclk_freq(si_info_t *sii, bool max_freq, chipcregs_t *cc)
 	u32 slowclk;
 	uint div;
 
-	ASSERT(SI_FAST(sii) || si_coreid(&sii->pub) == CC_CORE_ID);
-
-	/* shouldn't be here unless we've established the chip has dynamic clk control */
-	ASSERT(R_REG(&cc->capabilities) & CC_CAP_PWR_CTL);
-
 	slowclk = si_slowclk_src(sii);
 	if (sii->pub.ccrev < 6) {
 		if (slowclk == SCC_SS_PCI)
@@ -1068,8 +1041,6 @@ static uint si_slowclk_freq(si_info_t *sii, bool max_freq, chipcregs_t *cc)
 		else if (slowclk == SCC_SS_PCI)
 			return max_freq ? (PCIMAXFREQ / div)
 				: (PCIMINFREQ / div);
-		else
-			ASSERT(0);
 	} else {
 		/* Chipc rev 10 is InstaClock */
 		div = R_REG(&cc->system_clk_ctl) >> SYCC_CD_SHIFT;
@@ -1129,7 +1100,6 @@ void si_clkctl_init(si_t *sih)
 		if (cc == NULL)
 			return;
 	}
-	ASSERT(cc != NULL);
 
 	/* set all Instaclk chip ILP to 1 MHz */
 	if (sih->ccrev >= 10)
@@ -1177,7 +1147,6 @@ u16 si_clkctl_fast_pwrup_delay(si_t *sih)
 		if (cc == NULL)
 			goto done;
 	}
-	ASSERT(cc != NULL);
 
 	slowminfreq = si_slowclk_freq(sii, false, cc);
 	fpdelay = (((R_REG(&cc->pll_on_delay) + 2) * 1000000) +
@@ -1303,9 +1272,6 @@ static bool _si_clkctl_cc(si_info_t *sii, uint mode)
 	if (sii->pub.ccrev < 6)
 		return false;
 
-	/* Chips with ccrev 10 are EOL and they don't have SYCC_HR which we use below */
-	ASSERT(sii->pub.ccrev != 10);
-
 	if (!fast) {
 		INTR_OFF(sii, intr_val);
 		origidx = sii->curidx;
@@ -1321,7 +1287,6 @@ static bool _si_clkctl_cc(si_info_t *sii, uint mode)
 		if (cc == NULL)
 			goto done;
 	}
-	ASSERT(cc != NULL);
 
 	if (!CCCTL_ENAB(&sii->pub) && (sii->pub.ccrev < 20))
 		goto done;
@@ -1344,7 +1309,6 @@ static bool _si_clkctl_cc(si_info_t *sii, uint mode)
 			u32 htavail = CCS_HTAVAIL;
 			SPINWAIT(((R_REG(&cc->clk_ctl_st) & htavail)
 				  == 0), PMU_MAX_TRANSITION_DLY);
-			ASSERT(R_REG(&cc->clk_ctl_st) & htavail);
 		} else {
 			udelay(PLL_DELAY);
 		}
@@ -1370,7 +1334,7 @@ static bool _si_clkctl_cc(si_info_t *sii, uint mode)
 		break;
 
 	default:
-		ASSERT(0);
+		break;
 	}
 
  done:
@@ -1386,9 +1350,6 @@ int si_devpath(si_t *sih, char *path, int size)
 {
 	int slen;
 
-	ASSERT(path != NULL);
-	ASSERT(size >= SI_DEVPATH_BUFSZ);
-
 	if (!path || size <= 0)
 		return -1;
 
@@ -1398,7 +1359,6 @@ int si_devpath(si_t *sih, char *path, int size)
 		slen = snprintf(path, (size_t) size, "sb/%u/", si_coreidx(sih));
 		break;
 	case PCI_BUS:
-		ASSERT((SI_INFO(sih))->pbus != NULL);
 		slen = snprintf(path, (size_t) size, "pci/%u/%u/",
 			((struct pci_dev *)((SI_INFO(sih))->pbus))->bus->number,
 			PCI_SLOT(
@@ -1413,7 +1373,6 @@ int si_devpath(si_t *sih, char *path, int size)
 #endif
 	default:
 		slen = -1;
-		ASSERT(0);
 		break;
 	}
 
@@ -1507,14 +1466,12 @@ void si_sdio_init(si_t *sih)
 
 		/* get the current core index */
 		idx = sii->curidx;
-		ASSERT(idx == si_findcoreidx(sih, D11_CORE_ID, 0));
 
 		/* switch to sdio core */
 		sdpregs = (sdpcmd_regs_t *) si_setcore(sih, PCMCIA_CORE_ID, 0);
 		if (!sdpregs)
 			sdpregs =
 			    (sdpcmd_regs_t *) si_setcore(sih, SDIOD_CORE_ID, 0);
-		ASSERT(sdpregs);
 
 		SI_MSG(("si_sdio_init: For PCMCIA/SDIO Corerev %d, enable ints from core %d " "through SD core %d (%p)\n", sih->buscorerev, idx, sii->curidx, sdpregs));
 
@@ -1604,9 +1561,6 @@ void si_pci_setup(si_t *sih, uint coremask)
 	if (sii->pub.bustype != PCI_BUS)
 		return;
 
-	ASSERT(PCI(sii) || PCIE(sii));
-	ASSERT(sii->pub.buscoreidx != BADIDX);
-
 	if (PCI(sii)) {
 		/* get current core index */
 		idx = sii->curidx;
@@ -1663,8 +1617,6 @@ int si_pci_fixcfg(si_t *sih)
 
 	si_info_t *sii = SI_INFO(sih);
 
-	ASSERT(sii->pub.bustype == PCI_BUS);
-
 	/* Fixup PI in SROM shadow area to enable the correct PCI core access */
 	/* save the current index */
 	origidx = si_coreidx(&sii->pub);
@@ -1674,12 +1626,10 @@ int si_pci_fixcfg(si_t *sih)
 		pcieregs =
 		    (sbpcieregs_t *) si_setcore(&sii->pub, PCIE_CORE_ID, 0);
 		regs = pcieregs;
-		ASSERT(pcieregs != NULL);
 		reg16 = &pcieregs->sprom[SRSH_PI_OFFSET];
 	} else if (sii->pub.buscoretype == PCI_CORE_ID) {
 		pciregs = (struct sbpciregs *)si_setcore(&sii->pub, PCI_CORE_ID, 0);
 		regs = pciregs;
-		ASSERT(pciregs != NULL);
 		reg16 = &pciregs->sprom[SRSH_PI_OFFSET];
 	}
 	pciidx = si_coreidx(&sii->pub);
@@ -1727,8 +1677,6 @@ socram_banksize(si_info_t *sii, sbsocramregs_t *regs, u8 index,
 	uint banksize, bankinfo;
 	uint bankidx = index | (mem_type << SOCRAM_BANKIDX_MEMTYPE_SHIFT);
 
-	ASSERT(mem_type <= SOCRAM_MEMTYPE_DEVRAM);
-
 	W_REG(&regs->bankidx, bankidx);
 	bankinfo = R_REG(&regs->bankinfo);
 	banksize =
@@ -1863,7 +1811,6 @@ bool si_deviceremoved(si_t *sih)
 
 	switch (sih->bustype) {
 	case PCI_BUS:
-		ASSERT(sii->pbus != NULL);
 		pci_read_config_dword(sii->pbus, PCI_VENDOR_ID, &w);
 		if ((w & 0xFFFF) != PCI_VENDOR_ID_BROADCOM)
 			return true;
-- 
1.7.4.1


