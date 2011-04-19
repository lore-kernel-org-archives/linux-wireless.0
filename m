Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3830 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753620Ab1DSJBg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 05:01:36 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 3/5] staging: brcm80211: removed ASSERTs from siutils.c
Date: Tue, 19 Apr 2011 11:01:14 +0200
Message-ID: <1303203676-20165-4-git-send-email-rvossen@broadcom.com>
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
 drivers/staging/brcm80211/util/siutils.c |   49 +++--------------------------
 1 files changed, 5 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/brcm80211/util/siutils.c b/drivers/staging/brcm80211/util/siutils.c
index 6e307d1..7f6061d 100644
--- a/drivers/staging/brcm80211/util/siutils.c
+++ b/drivers/staging/brcm80211/util/siutils.c
@@ -156,7 +156,6 @@ static bool si_buscore_setup(si_info_t *sii, chipcregs_t *cc, uint bustype,
 	uint pciidx, pcieidx, pcirev, pcierev;
 
 	cc = si_setcoreidx(&sii->pub, SI_CC_IDX);
-	ASSERT(cc);
 
 	/* get chipcommon rev */
 	sii->pub.ccrev = (int)si_corerev(&sii->pub);
@@ -292,7 +291,6 @@ static __used void si_nvram_process(si_info_t *sii, char *pvars)
 
 	if (sii->pub.boardtype == 0) {
 		SI_ERROR(("si_doattach: unknown board type\n"));
-		ASSERT(sii->pub.boardtype);
 	}
 
 	sii->pub.boardflags = getintvar(pvars, "boardflags");
@@ -309,8 +307,6 @@ static si_info_t *si_doattach(si_info_t *sii, uint devid,
 	chipcregs_t *cc;
 	uint origidx;
 
-	ASSERT(GOODREGS(regs));
-
 	memset((unsigned char *) sii, 0, sizeof(si_info_t));
 
 	savewin = 0;
@@ -431,13 +427,11 @@ void si_deregister_intr_callback(si_t *sih)
 
 uint si_flag(si_t *sih)
 {
-	ASSERT(0);
 	return 0;
 }
 
 void si_setint(si_t *sih, int siflag)
 {
-	ASSERT(0);
 }
 
 uint si_coreidx(si_t *sih)
@@ -512,7 +506,6 @@ void *si_switch_core(si_t *sih, uint coreid, uint *origidx, uint *intr_val)
 	INTR_OFF(sii, *intr_val);
 	*origidx = sii->curidx;
 	cc = si_setcore(sih, coreid, 0);
-	ASSERT(cc != NULL);
 
 	return cc;
 }
@@ -533,13 +526,11 @@ void si_restore_core(si_t *sih, uint coreid, uint intr_val)
 
 u32 si_core_cflags(si_t *sih, u32 mask, u32 val)
 {
-	ASSERT(0);
 	return 0;
 }
 
 u32 si_core_sflags(si_t *sih, u32 mask, u32 val)
 {
-	ASSERT(0);
 	return 0;
 }
 
@@ -615,8 +606,6 @@ static uint si_slowclk_src(si_info_t *sii)
 	chipcregs_t *cc;
 	u32 val;
 
-	ASSERT(SI_FAST(sii) || si_coreid(&sii->pub) == CC_CORE_ID);
-
 	if (sii->pub.ccrev < 6) {
 		if (sii->pub.bustype == PCI_BUS) {
 			pci_read_config_dword(sii->pbus, PCI_GPIO_OUT,
@@ -632,17 +621,15 @@ static uint si_slowclk_src(si_info_t *sii)
 		return SCC_SS_XTAL;
 }
 
-/* return the ILP (slowclock) min or max frequency */
+/*
+ * return the ILP (slowclock) min or max frequency
+ * precondition: we've established the chip has dynamic clk control
+ */
 static uint si_slowclk_freq(si_info_t *sii, bool max_freq, chipcregs_t *cc)
 {
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
@@ -663,8 +650,6 @@ static uint si_slowclk_freq(si_info_t *sii, bool max_freq, chipcregs_t *cc)
 		else if (slowclk == SCC_SS_PCI)
 			return max_freq ? (PCIMAXFREQ / div)
 				: (PCIMINFREQ / div);
-		else
-			ASSERT(0);
 	} else {
 		/* Chipc rev 10 is InstaClock */
 		div = R_REG(&cc->system_clk_ctl) >> SYCC_CD_SHIFT;
@@ -724,7 +709,6 @@ void si_clkctl_init(si_t *sih)
 		if (cc == NULL)
 			return;
 	}
-	ASSERT(cc != NULL);
 
 	/* set all Instaclk chip ILP to 1 MHz */
 	if (sih->ccrev >= 10)
@@ -772,7 +756,6 @@ u16 si_clkctl_fast_pwrup_delay(si_t *sih)
 		if (cc == NULL)
 			goto done;
 	}
-	ASSERT(cc != NULL);
 
 	slowminfreq = si_slowclk_freq(sii, false, cc);
 	fpdelay = (((R_REG(&cc->pll_on_delay) + 2) * 1000000) +
@@ -896,9 +879,6 @@ static bool _si_clkctl_cc(si_info_t *sii, uint mode)
 	if (sii->pub.ccrev < 6)
 		return false;
 
-	/* Chips with ccrev 10 are EOL and they don't have SYCC_HR which we use below */
-	ASSERT(sii->pub.ccrev != 10);
-
 	if (!fast) {
 		INTR_OFF(sii, intr_val);
 		origidx = sii->curidx;
@@ -914,7 +894,6 @@ static bool _si_clkctl_cc(si_info_t *sii, uint mode)
 		if (cc == NULL)
 			goto done;
 	}
-	ASSERT(cc != NULL);
 
 	if (!CCCTL_ENAB(&sii->pub) && (sii->pub.ccrev < 20))
 		goto done;
@@ -937,7 +916,6 @@ static bool _si_clkctl_cc(si_info_t *sii, uint mode)
 			u32 htavail = CCS_HTAVAIL;
 			SPINWAIT(((R_REG(&cc->clk_ctl_st) & htavail)
 				  == 0), PMU_MAX_TRANSITION_DLY);
-			ASSERT(R_REG(&cc->clk_ctl_st) & htavail);
 		} else {
 			udelay(PLL_DELAY);
 		}
@@ -963,7 +941,7 @@ static bool _si_clkctl_cc(si_info_t *sii, uint mode)
 		break;
 
 	default:
-		ASSERT(0);
+		break;
 	}
 
  done:
@@ -979,9 +957,6 @@ int si_devpath(si_t *sih, char *path, int size)
 {
 	int slen;
 
-	ASSERT(path != NULL);
-	ASSERT(size >= SI_DEVPATH_BUFSZ);
-
 	if (!path || size <= 0)
 		return -1;
 
@@ -991,7 +966,6 @@ int si_devpath(si_t *sih, char *path, int size)
 		slen = snprintf(path, (size_t) size, "sb/%u/", si_coreidx(sih));
 		break;
 	case PCI_BUS:
-		ASSERT((SI_INFO(sih))->pbus != NULL);
 		slen = snprintf(path, (size_t) size, "pci/%u/%u/",
 			((struct pci_dev *)((SI_INFO(sih))->pbus))->bus->number,
 			PCI_SLOT(
@@ -1005,7 +979,6 @@ int si_devpath(si_t *sih, char *path, int size)
 
 	default:
 		slen = -1;
-		ASSERT(0);
 		break;
 	}
 
@@ -1099,14 +1072,12 @@ void si_sdio_init(si_t *sih)
 
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
 
@@ -1195,9 +1166,6 @@ void si_pci_setup(si_t *sih, uint coremask)
 	if (sii->pub.bustype != PCI_BUS)
 		return;
 
-	ASSERT(PCI(sii) || PCIE(sii));
-	ASSERT(sii->pub.buscoreidx != BADIDX);
-
 	if (PCI(sii)) {
 		/* get current core index */
 		idx = sii->curidx;
@@ -1254,8 +1222,6 @@ int si_pci_fixcfg(si_t *sih)
 
 	si_info_t *sii = SI_INFO(sih);
 
-	ASSERT(sii->pub.bustype == PCI_BUS);
-
 	/* Fixup PI in SROM shadow area to enable the correct PCI core access */
 	/* save the current index */
 	origidx = si_coreidx(&sii->pub);
@@ -1265,12 +1231,10 @@ int si_pci_fixcfg(si_t *sih)
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
@@ -1318,8 +1282,6 @@ socram_banksize(si_info_t *sii, sbsocramregs_t *regs, u8 index,
 	uint banksize, bankinfo;
 	uint bankidx = index | (mem_type << SOCRAM_BANKIDX_MEMTYPE_SHIFT);
 
-	ASSERT(mem_type <= SOCRAM_MEMTYPE_DEVRAM);
-
 	W_REG(&regs->bankidx, bankidx);
 	bankinfo = R_REG(&regs->bankinfo);
 	banksize =
@@ -1454,7 +1416,6 @@ bool si_deviceremoved(si_t *sih)
 
 	switch (sih->bustype) {
 	case PCI_BUS:
-		ASSERT(sii->pbus != NULL);
 		pci_read_config_dword(sii->pbus, PCI_CFG_VID, &w);
 		if ((w & 0xFFFF) != PCI_VENDOR_ID_BROADCOM)
 			return true;
-- 
1.7.1


