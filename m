Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2278 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243Ab1ECJgU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: [PATCH 50/61] staging: brcm80211: removed ASSERTs from
 aiutils.c
Date: Tue, 3 May 2011 11:35:50 +0200
Message-ID: <1304415361-7813-51-git-send-email-arend@broadcom.com> (sfid-20110503_113753_057333_BA83B7F4)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/aiutils.c |   57 ++-----------------------
 1 files changed, 5 insertions(+), 52 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index c57b6c7..3d7a2d6 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -601,7 +601,6 @@ static bool ai_buscore_setup(si_info_t *sii, chipcregs_t *cc, uint bustype,
 	uint pciidx, pcieidx, pcirev, pcierev;
 
 	cc = ai_setcoreidx(&sii->pub, SI_CC_IDX);
-	ASSERT(cc);
 
 	/* get chipcommon rev */
 	sii->pub.ccrev = (int)ai_corerev(&sii->pub);
@@ -747,7 +746,6 @@ static __used void ai_nvram_process(si_info_t *sii, char *pvars)
 
 	if (sii->pub.boardtype == 0) {
 		SI_ERROR(("si_doattach: unknown board type\n"));
-		ASSERT(sii->pub.boardtype);
 	}
 
 	sii->pub.boardflags = getintvar(pvars, "boardflags");
@@ -764,8 +762,6 @@ static si_info_t *ai_doattach(si_info_t *sii, uint devid,
 	uint socitype;
 	uint origidx;
 
-	ASSERT(GOODREGS(regs));
-
 	memset((unsigned char *) sii, 0, sizeof(si_info_t));
 
 	savewin = 0;
@@ -902,7 +898,6 @@ static si_info_t *ai_doattach(si_info_t *sii, uint devid,
 	ai_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, gpiotimerval), ~0, w);
 
 	if (PCIE(sii)) {
-		ASSERT(sii->pch != NULL);
 		pcicore_attach(sii->pch, pvars, SI_DOATTACH);
 	}
 
@@ -1094,8 +1089,6 @@ void *ai_switch_core(si_t *sih, uint coreid, uint *origidx, uint *intr_val)
 	INTR_OFF(sii, *intr_val);
 	*origidx = sii->curidx;
 	cc = ai_setcore(sih, coreid, 0);
-	ASSERT(cc != NULL);
-
 	return cc;
 }
 
@@ -1142,10 +1135,6 @@ uint ai_corereg(si_t *sih, uint coreidx, uint regoff, uint mask, uint val)
 
 	sii = SI_INFO(sih);
 
-	ASSERT(GOODIDX(coreidx));
-	ASSERT(regoff < SI_CORE_SIZE);
-	ASSERT((val & ~mask) == 0);
-
 	if (coreidx >= SI_MAXCORES)
 		return 0;
 
@@ -1156,7 +1145,6 @@ uint ai_corereg(si_t *sih, uint coreidx, uint regoff, uint mask, uint val)
 		if (!sii->regs[coreidx]) {
 			sii->regs[coreidx] = REG_MAP(sii->coresba[coreidx],
 						     SI_CORE_SIZE);
-			ASSERT(GOODREGS(sii->regs[coreidx]));
 		}
 		r = (u32 *) ((unsigned char *) sii->regs[coreidx] + regoff);
 	} else if (sih->bustype == PCI_BUS) {
@@ -1199,7 +1187,6 @@ uint ai_corereg(si_t *sih, uint coreidx, uint regoff, uint mask, uint val)
 		r = (u32 *) ((unsigned char *) ai_setcoreidx(&sii->pub, coreidx)
 				+ regoff);
 	}
-	ASSERT(r != NULL);
 
 	/* mask and set */
 	if (mask || val) {
@@ -1229,7 +1216,6 @@ void ai_core_disable(si_t *sih, u32 bits)
 
 	sii = SI_INFO(sih);
 
-	ASSERT(GOODREGS(sii->curwrap));
 	ai = sii->curwrap;
 
 	/* if core is already in reset, just return */
@@ -1256,7 +1242,6 @@ void ai_core_reset(si_t *sih, u32 bits, u32 resetbits)
 	u32 dummy;
 
 	sii = SI_INFO(sih);
-	ASSERT(GOODREGS(sii->curwrap));
 	ai = sii->curwrap;
 
 	/*
@@ -1284,8 +1269,6 @@ static uint ai_slowclk_src(si_info_t *sii)
 	chipcregs_t *cc;
 	u32 val;
 
-	ASSERT(SI_FAST(sii) || ai_coreid(&sii->pub) == CC_CORE_ID);
-
 	if (sii->pub.ccrev < 6) {
 		if (sii->pub.bustype == PCI_BUS) {
 			pci_read_config_dword(sii->pbus, PCI_GPIO_OUT,
@@ -1301,20 +1284,15 @@ static uint ai_slowclk_src(si_info_t *sii)
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
@@ -1335,8 +1313,6 @@ static uint ai_slowclk_freq(si_info_t *sii, bool max_freq, chipcregs_t *cc)
 		else if (slowclk == SCC_SS_PCI)
 			return max_freq ? (PCIMAXFREQ / div)
 				: (PCIMINFREQ / div);
-		else
-			ASSERT(0);
 	} else {
 		/* Chipc rev 10 is InstaClock */
 		div = R_REG(&cc->system_clk_ctl) >> SYCC_CD_SHIFT;
@@ -1398,7 +1374,6 @@ void ai_clkctl_init(si_t *sih)
 		if (cc == NULL)
 			return;
 	}
-	ASSERT(cc != NULL);
 
 	/* set all Instaclk chip ILP to 1 MHz */
 	if (sih->ccrev >= 10)
@@ -1449,7 +1424,6 @@ u16 ai_clkctl_fast_pwrup_delay(si_t *sih)
 		if (cc == NULL)
 			goto done;
 	}
-	ASSERT(cc != NULL);
 
 	slowminfreq = ai_slowclk_freq(sii, false, cc);
 	fpdelay = (((R_REG(&cc->pll_on_delay) + 2) * 1000000) +
@@ -1570,12 +1544,6 @@ static bool _ai_clkctl_cc(si_info_t *sii, uint mode)
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
@@ -1591,7 +1559,6 @@ static bool _ai_clkctl_cc(si_info_t *sii, uint mode)
 		if (cc == NULL)
 			goto done;
 	}
-	ASSERT(cc != NULL);
 
 	if (!CCCTL_ENAB(&sii->pub) && (sii->pub.ccrev < 20))
 		goto done;
@@ -1617,7 +1584,6 @@ static bool _ai_clkctl_cc(si_info_t *sii, uint mode)
 			u32 htavail = CCS_HTAVAIL;
 			SPINWAIT(((R_REG(&cc->clk_ctl_st) & htavail)
 				  == 0), PMU_MAX_TRANSITION_DLY);
-			ASSERT(R_REG(&cc->clk_ctl_st) & htavail);
 		} else {
 			udelay(PLL_DELAY);
 		}
@@ -1646,7 +1612,7 @@ static bool _ai_clkctl_cc(si_info_t *sii, uint mode)
 		break;
 
 	default:
-		ASSERT(0);
+		break;
 	}
 
  done:
@@ -1662,9 +1628,6 @@ int ai_devpath(si_t *sih, char *path, int size)
 {
 	int slen;
 
-	ASSERT(path != NULL);
-	ASSERT(size >= SI_DEVPATH_BUFSZ);
-
 	if (!path || size <= 0)
 		return -1;
 
@@ -1674,7 +1637,6 @@ int ai_devpath(si_t *sih, char *path, int size)
 		slen = snprintf(path, (size_t) size, "sb/%u/", ai_coreidx(sih));
 		break;
 	case PCI_BUS:
-		ASSERT((SI_INFO(sih))->pbus != NULL);
 		slen = snprintf(path, (size_t) size, "pci/%u/%u/",
 			((struct pci_dev *)((SI_INFO(sih))->pbus))->bus->number,
 			PCI_SLOT(
@@ -1683,7 +1645,6 @@ int ai_devpath(si_t *sih, char *path, int size)
 
 	default:
 		slen = -1;
-		ASSERT(0);
 		break;
 	}
 
@@ -1836,9 +1797,6 @@ void ai_pci_setup(si_t *sih, uint coremask)
 	if (sii->pub.bustype != PCI_BUS)
 		return;
 
-	ASSERT(PCI(sii) || PCIE(sii));
-	ASSERT(sii->pub.buscoreidx != BADIDX);
-
 	if (PCI(sii)) {
 		/* get current core index */
 		idx = sii->curidx;
@@ -1895,8 +1853,6 @@ int ai_pci_fixcfg(si_t *sih)
 
 	si_info_t *sii = SI_INFO(sih);
 
-	ASSERT(sii->pub.bustype == PCI_BUS);
-
 	/* Fixup PI in SROM shadow area to enable the correct PCI core access */
 	/* save the current index */
 	origidx = ai_coreidx(&sii->pub);
@@ -1905,12 +1861,10 @@ int ai_pci_fixcfg(si_t *sih)
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
@@ -2012,7 +1966,6 @@ bool ai_deviceremoved(si_t *sih)
 
 	switch (sih->bustype) {
 	case PCI_BUS:
-		ASSERT(sii->pbus != NULL);
 		pci_read_config_dword(sii->pbus, PCI_VENDOR_ID, &w);
 		if ((w & 0xFFFF) != PCI_VENDOR_ID_BROADCOM)
 			return true;
-- 
1.7.4.1


