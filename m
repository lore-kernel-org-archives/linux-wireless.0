Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3828 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597Ab1DSJBg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 05:01:36 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 1/5] staging: brcm80211: removed ASSERTs from aiutils.c
Date: Tue, 19 Apr 2011 11:01:12 +0200
Message-ID: <1303203676-20165-2-git-send-email-rvossen@broadcom.com>
In-Reply-To: <1303203676-20165-1-git-send-email-rvossen@broadcom.com>
References: <1303203676-20165-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/aiutils.c |   78 ++------------------------
 1 files changed, 5 insertions(+), 73 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index f055c4f..3807d3f 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -147,7 +147,6 @@ void ai_scan(si_t *sih, void *regs, uint devid)
 	default:
 		SI_ERROR(("Don't know how to do AXI enumertion on bus %d\n",
 			  sih->bustype));
-		ASSERT(0);
 		return;
 	}
 	eromlim = eromptr + (ER_REMAPCONTROL / sizeof(u32));
@@ -331,24 +330,15 @@ void *ai_setcoreidx(si_t *sih, uint coreidx)
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
@@ -368,7 +358,6 @@ void *ai_setcoreidx(si_t *sih, uint coreidx)
 		break;
 
 	default:
-		ASSERT(0);
 		regs = NULL;
 		break;
 	}
@@ -489,11 +478,8 @@ void ai_core_cflags_wo(si_t *sih, u32 mask, u32 val)
 		return;
 	}
 
-	ASSERT(GOODREGS(sii->curwrap));
 	ai = sii->curwrap;
 
-	ASSERT((val & ~mask) == 0);
-
 	if (mask || val) {
 		w = ((R_REG(&ai->ioctrl) & ~mask) | val);
 		W_REG(&ai->ioctrl, w);
@@ -513,11 +499,8 @@ u32 ai_core_cflags(si_t *sih, u32 mask, u32 val)
 		return 0;
 	}
 
-	ASSERT(GOODREGS(sii->curwrap));
 	ai = sii->curwrap;
 
-	ASSERT((val & ~mask) == 0);
-
 	if (mask || val) {
 		w = ((R_REG(&ai->ioctrl) & ~mask) | val);
 		W_REG(&ai->ioctrl, w);
@@ -538,12 +521,8 @@ u32 ai_core_sflags(si_t *sih, u32 mask, u32 val)
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
@@ -623,7 +602,6 @@ static bool ai_buscore_setup(si_info_t *sii, chipcregs_t *cc, uint bustype,
 	uint pciidx, pcieidx, pcirev, pcierev;
 
 	cc = ai_setcoreidx(&sii->pub, SI_CC_IDX);
-	ASSERT(cc);
 
 	/* get chipcommon rev */
 	sii->pub.ccrev = (int)ai_corerev(&sii->pub);
@@ -769,7 +747,6 @@ static __used void ai_nvram_process(si_info_t *sii, char *pvars)
 
 	if (sii->pub.boardtype == 0) {
 		SI_ERROR(("si_doattach: unknown board type\n"));
-		ASSERT(sii->pub.boardtype);
 	}
 
 	sii->pub.boardflags = getintvar(pvars, "boardflags");
@@ -786,8 +763,6 @@ static si_info_t *ai_doattach(si_info_t *sii, uint devid,
 	uint socitype;
 	uint origidx;
 
-	ASSERT(GOODREGS(regs));
-
 	memset((unsigned char *) sii, 0, sizeof(si_info_t));
 
 	savewin = 0;
@@ -924,7 +899,6 @@ static si_info_t *ai_doattach(si_info_t *sii, uint devid,
 	ai_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, gpiotimerval), ~0, w);
 
 	if (PCIE(sii)) {
-		ASSERT(sii->pch != NULL);
 		pcicore_attach(sii->pch, pvars, SI_DOATTACH);
 	}
 
@@ -1116,8 +1090,6 @@ void *ai_switch_core(si_t *sih, uint coreid, uint *origidx, uint *intr_val)
 	INTR_OFF(sii, *intr_val);
 	*origidx = sii->curidx;
 	cc = ai_setcore(sih, coreid, 0);
-	ASSERT(cc != NULL);
-
 	return cc;
 }
 
@@ -1164,10 +1136,6 @@ uint ai_corereg(si_t *sih, uint coreidx, uint regoff, uint mask, uint val)
 
 	sii = SI_INFO(sih);
 
-	ASSERT(GOODIDX(coreidx));
-	ASSERT(regoff < SI_CORE_SIZE);
-	ASSERT((val & ~mask) == 0);
-
 	if (coreidx >= SI_MAXCORES)
 		return 0;
 
@@ -1178,7 +1146,6 @@ uint ai_corereg(si_t *sih, uint coreidx, uint regoff, uint mask, uint val)
 		if (!sii->regs[coreidx]) {
 			sii->regs[coreidx] = REG_MAP(sii->coresba[coreidx],
 						     SI_CORE_SIZE);
-			ASSERT(GOODREGS(sii->regs[coreidx]));
 		}
 		r = (u32 *) ((unsigned char *) sii->regs[coreidx] + regoff);
 	} else if (sih->bustype == PCI_BUS) {
@@ -1221,7 +1188,6 @@ uint ai_corereg(si_t *sih, uint coreidx, uint regoff, uint mask, uint val)
 		r = (u32 *) ((unsigned char *) ai_setcoreidx(&sii->pub, coreidx)
 				+ regoff);
 	}
-	ASSERT(r != NULL);
 
 	/* mask and set */
 	if (mask || val) {
@@ -1251,7 +1217,6 @@ void ai_core_disable(si_t *sih, u32 bits)
 
 	sii = SI_INFO(sih);
 
-	ASSERT(GOODREGS(sii->curwrap));
 	ai = sii->curwrap;
 
 	/* if core is already in reset, just return */
@@ -1278,7 +1243,6 @@ void ai_core_reset(si_t *sih, u32 bits, u32 resetbits)
 	u32 dummy;
 
 	sii = SI_INFO(sih);
-	ASSERT(GOODREGS(sii->curwrap));
 	ai = sii->curwrap;
 
 	/*
@@ -1306,8 +1270,6 @@ static uint ai_slowclk_src(si_info_t *sii)
 	chipcregs_t *cc;
 	u32 val;
 
-	ASSERT(SI_FAST(sii) || ai_coreid(&sii->pub) == CC_CORE_ID);
-
 	if (sii->pub.ccrev < 6) {
 		if (sii->pub.bustype == PCI_BUS) {
 			pci_read_config_dword(sii->pbus, PCI_GPIO_OUT,
@@ -1323,20 +1285,15 @@ static uint ai_slowclk_src(si_info_t *sii)
 		return SCC_SS_XTAL;
 }
 
-/* return the ILP (slowclock) min or max frequency */
+/*
+* return the ILP (slowclock) min or max frequency
+* precondition: we've established the chip has dynamic clk control
+*/
 static uint ai_slowclk_freq(si_info_t *sii, bool max_freq, chipcregs_t *cc)
 {
 	u32 slowclk;
 	uint div;
 
-	ASSERT(SI_FAST(sii) || ai_coreid(&sii->pub) == CC_CORE_ID);
-
-	/*
-	 * shouldn't be here unless we've established
-	 * the chip has dynamic clk control
-	 */
-	ASSERT(R_REG(&cc->capabilities) & CC_CAP_PWR_CTL);
-
 	slowclk = ai_slowclk_src(sii);
 	if (sii->pub.ccrev < 6) {
 		if (slowclk == SCC_SS_PCI)
@@ -1357,8 +1314,6 @@ static uint ai_slowclk_freq(si_info_t *sii, bool max_freq, chipcregs_t *cc)
 		else if (slowclk == SCC_SS_PCI)
 			return max_freq ? (PCIMAXFREQ / div)
 				: (PCIMINFREQ / div);
-		else
-			ASSERT(0);
 	} else {
 		/* Chipc rev 10 is InstaClock */
 		div = R_REG(&cc->system_clk_ctl) >> SYCC_CD_SHIFT;
@@ -1420,7 +1375,6 @@ void ai_clkctl_init(si_t *sih)
 		if (cc == NULL)
 			return;
 	}
-	ASSERT(cc != NULL);
 
 	/* set all Instaclk chip ILP to 1 MHz */
 	if (sih->ccrev >= 10)
@@ -1471,7 +1425,6 @@ u16 ai_clkctl_fast_pwrup_delay(si_t *sih)
 		if (cc == NULL)
 			goto done;
 	}
-	ASSERT(cc != NULL);
 
 	slowminfreq = ai_slowclk_freq(sii, false, cc);
 	fpdelay = (((R_REG(&cc->pll_on_delay) + 2) * 1000000) +
@@ -1592,12 +1545,6 @@ static bool _ai_clkctl_cc(si_info_t *sii, uint mode)
 	if (sii->pub.ccrev < 6)
 		return false;
 
-	/*
-	 * Chips with ccrev 10 are EOL and they
-	 * don't have SYCC_HR which we use below
-	 */
-	ASSERT(sii->pub.ccrev != 10);
-
 	if (!fast) {
 		INTR_OFF(sii, intr_val);
 		origidx = sii->curidx;
@@ -1613,7 +1560,6 @@ static bool _ai_clkctl_cc(si_info_t *sii, uint mode)
 		if (cc == NULL)
 			goto done;
 	}
-	ASSERT(cc != NULL);
 
 	if (!CCCTL_ENAB(&sii->pub) && (sii->pub.ccrev < 20))
 		goto done;
@@ -1639,7 +1585,6 @@ static bool _ai_clkctl_cc(si_info_t *sii, uint mode)
 			u32 htavail = CCS_HTAVAIL;
 			SPINWAIT(((R_REG(&cc->clk_ctl_st) & htavail)
 				  == 0), PMU_MAX_TRANSITION_DLY);
-			ASSERT(R_REG(&cc->clk_ctl_st) & htavail);
 		} else {
 			udelay(PLL_DELAY);
 		}
@@ -1668,7 +1613,7 @@ static bool _ai_clkctl_cc(si_info_t *sii, uint mode)
 		break;
 
 	default:
-		ASSERT(0);
+		break;
 	}
 
  done:
@@ -1684,9 +1629,6 @@ int ai_devpath(si_t *sih, char *path, int size)
 {
 	int slen;
 
-	ASSERT(path != NULL);
-	ASSERT(size >= SI_DEVPATH_BUFSZ);
-
 	if (!path || size <= 0)
 		return -1;
 
@@ -1696,7 +1638,6 @@ int ai_devpath(si_t *sih, char *path, int size)
 		slen = snprintf(path, (size_t) size, "sb/%u/", ai_coreidx(sih));
 		break;
 	case PCI_BUS:
-		ASSERT((SI_INFO(sih))->pbus != NULL);
 		slen = snprintf(path, (size_t) size, "pci/%u/%u/",
 			((struct pci_dev *)((SI_INFO(sih))->pbus))->bus->number,
 			PCI_SLOT(
@@ -1705,7 +1646,6 @@ int ai_devpath(si_t *sih, char *path, int size)
 
 	default:
 		slen = -1;
-		ASSERT(0);
 		break;
 	}
 
@@ -1858,9 +1798,6 @@ void ai_pci_setup(si_t *sih, uint coremask)
 	if (sii->pub.bustype != PCI_BUS)
 		return;
 
-	ASSERT(PCI(sii) || PCIE(sii));
-	ASSERT(sii->pub.buscoreidx != BADIDX);
-
 	if (PCI(sii)) {
 		/* get current core index */
 		idx = sii->curidx;
@@ -1917,8 +1854,6 @@ int ai_pci_fixcfg(si_t *sih)
 
 	si_info_t *sii = SI_INFO(sih);
 
-	ASSERT(sii->pub.bustype == PCI_BUS);
-
 	/* Fixup PI in SROM shadow area to enable the correct PCI core access */
 	/* save the current index */
 	origidx = ai_coreidx(&sii->pub);
@@ -1927,12 +1862,10 @@ int ai_pci_fixcfg(si_t *sih)
 	if (sii->pub.buscoretype == PCIE_CORE_ID) {
 		pcieregs = ai_setcore(&sii->pub, PCIE_CORE_ID, 0);
 		regs = pcieregs;
-		ASSERT(pcieregs != NULL);
 		reg16 = &pcieregs->sprom[SRSH_PI_OFFSET];
 	} else if (sii->pub.buscoretype == PCI_CORE_ID) {
 		pciregs = ai_setcore(&sii->pub, PCI_CORE_ID, 0);
 		regs = pciregs;
-		ASSERT(pciregs != NULL);
 		reg16 = &pciregs->sprom[SRSH_PI_OFFSET];
 	}
 	pciidx = ai_coreidx(&sii->pub);
@@ -2034,7 +1967,6 @@ bool ai_deviceremoved(si_t *sih)
 
 	switch (sih->bustype) {
 	case PCI_BUS:
-		ASSERT(sii->pbus != NULL);
 		pci_read_config_dword(sii->pbus, PCI_CFG_VID, &w);
 		if ((w & 0xFFFF) != PCI_VENDOR_ID_BROADCOM)
 			return true;
-- 
1.7.1


