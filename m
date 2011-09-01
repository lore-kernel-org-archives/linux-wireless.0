Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4154 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598Ab1IAJRj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 05:17:39 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 25/30] staging: brcm80211: removed redundant SI_INFO()
 macro from softmac
Date: Thu, 1 Sep 2011 11:17:15 +0200
Message-ID: <1314868640-9425-26-git-send-email-rvossen@broadcom.com> (sfid-20110901_111809_319029_50A42BCB)
In-Reply-To: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
References: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/aiutils.c |   80 +++++++++++++-------------
 drivers/staging/brcm80211/brcmsmac/aiutils.h |    3 -
 drivers/staging/brcm80211/brcmsmac/nicpci.c  |    4 +-
 3 files changed, 43 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index e98eb27..48489ce 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -485,7 +485,8 @@ static void ai_hwfixup(struct si_info *sii)
 /* parse the enumeration rom to identify all cores */
 static void ai_scan(struct si_pub *sih, struct chipcregs *cc)
 {
-	struct si_info *sii = SI_INFO(sih);
+	struct si_info *sii = (struct si_info *)sih;
+
 	u32 erombase, *eromptr, *eromlim;
 	void *regs = cc;
 
@@ -678,7 +679,7 @@ static void ai_scan(struct si_pub *sih, struct chipcregs *cc)
  */
 void *ai_setcoreidx(struct si_pub *sih, uint coreidx)
 {
-	struct si_info *sii = SI_INFO(sih);
+	struct si_info *sii = (struct si_info *)sih;
 	u32 addr = sii->coresba[coreidx];
 	u32 wrap = sii->wrapba[coreidx];
 
@@ -706,7 +707,7 @@ u32 ai_addrspace(struct si_pub *sih, uint asidx)
 	struct si_info *sii;
 	uint cidx;
 
-	sii = SI_INFO(sih);
+	sii = (struct si_info *)sih;
 	cidx = sii->curidx;
 
 	if (asidx == 0)
@@ -726,7 +727,7 @@ u32 ai_addrspacesize(struct si_pub *sih, uint asidx)
 	struct si_info *sii;
 	uint cidx;
 
-	sii = SI_INFO(sih);
+	sii = (struct si_info *)sih;
 	cidx = sii->curidx;
 
 	if (asidx == 0)
@@ -745,7 +746,7 @@ uint ai_flag(struct si_pub *sih)
 	struct si_info *sii;
 	struct aidmp *ai;
 
-	sii = SI_INFO(sih);
+	sii = (struct si_info *)sih;
 	ai = sii->curwrap;
 
 	return R_REG(&ai->oobselouta30) & 0x1f;
@@ -760,7 +761,7 @@ uint ai_corevendor(struct si_pub *sih)
 	struct si_info *sii;
 	u32 cia;
 
-	sii = SI_INFO(sih);
+	sii = (struct si_info *)sih;
 	cia = sii->cia[sii->curidx];
 	return (cia & CIA_MFG_MASK) >> CIA_MFG_SHIFT;
 }
@@ -770,7 +771,7 @@ uint ai_corerev(struct si_pub *sih)
 	struct si_info *sii;
 	u32 cib;
 
-	sii = SI_INFO(sih);
+	sii = (struct si_info *)sih;
 	cib = sii->cib[sii->curidx];
 	return (cib & CIB_REV_MASK) >> CIB_REV_SHIFT;
 }
@@ -780,7 +781,7 @@ bool ai_iscoreup(struct si_pub *sih)
 	struct si_info *sii;
 	struct aidmp *ai;
 
-	sii = SI_INFO(sih);
+	sii = (struct si_info *)sih;
 	ai = sii->curwrap;
 
 	return (((R_REG(&ai->ioctrl) & (SICF_FGC | SICF_CLOCK_EN)) ==
@@ -794,7 +795,7 @@ void ai_core_cflags_wo(struct si_pub *sih, u32 mask, u32 val)
 	struct aidmp *ai;
 	u32 w;
 
-	sii = SI_INFO(sih);
+	sii = (struct si_info *)sih;
 
 	ai = sii->curwrap;
 
@@ -810,7 +811,7 @@ u32 ai_core_cflags(struct si_pub *sih, u32 mask, u32 val)
 	struct aidmp *ai;
 	u32 w;
 
-	sii = SI_INFO(sih);
+	sii = (struct si_info *)sih;
 	ai = sii->curwrap;
 
 	if (mask || val) {
@@ -849,7 +850,7 @@ u32 ai_core_sflags(struct si_pub *sih, u32 mask, u32 val)
 	struct aidmp *ai;
 	u32 w;
 
-	sii = SI_INFO(sih);
+	sii = (struct si_info *)sih;
 	ai = sii->curwrap;
 
 	if (mask || val) {
@@ -1184,7 +1185,7 @@ void ai_detach(struct si_pub *sih)
 	struct si_pub *si_local = NULL;
 	memcpy(&si_local, &sih, sizeof(struct si_pub **));
 
-	sii = SI_INFO(sih);
+	sii = (struct si_info *)sih;
 
 	if (sii == NULL)
 		return;
@@ -1205,7 +1206,7 @@ ai_register_intr_callback(struct si_pub *sih, void *intrsoff_fn,
 {
 	struct si_info *sii;
 
-	sii = SI_INFO(sih);
+	sii = (struct si_info *)sih;
 	sii->intr_arg = intr_arg;
 	sii->intrsoff_fn = (u32 (*)(void *)) intrsoff_fn;
 	sii->intrsrestore_fn = (void (*) (void *, u32)) intrsrestore_fn;
@@ -1220,7 +1221,7 @@ void ai_deregister_intr_callback(struct si_pub *sih)
 {
 	struct si_info *sii;
 
-	sii = SI_INFO(sih);
+	sii = (struct si_info *)sih;
 	sii->intrsoff_fn = NULL;
 }
 
@@ -1228,7 +1229,7 @@ uint ai_coreid(struct si_pub *sih)
 {
 	struct si_info *sii;
 
-	sii = SI_INFO(sih);
+	sii = (struct si_info *)sih;
 	return sii->coreid[sii->curidx];
 }
 
@@ -1236,7 +1237,7 @@ uint ai_coreidx(struct si_pub *sih)
 {
 	struct si_info *sii;
 
-	sii = SI_INFO(sih);
+	sii = (struct si_info *)sih;
 	return sii->curidx;
 }
 
@@ -1252,7 +1253,7 @@ uint ai_findcoreidx(struct si_pub *sih, uint coreid, uint coreunit)
 	uint found;
 	uint i;
 
-	sii = SI_INFO(sih);
+	sii = (struct si_info *)sih;
 
 	found = 0;
 
@@ -1290,7 +1291,7 @@ void *ai_switch_core(struct si_pub *sih, uint coreid, uint *origidx,
 	void *cc;
 	struct si_info *sii;
 
-	sii = SI_INFO(sih);
+	sii = (struct si_info *)sih;
 
 	if (SI_FAST(sii)) {
 		/* Overloading the origidx variable to remember the coreid,
@@ -1314,7 +1315,7 @@ void ai_restore_core(struct si_pub *sih, uint coreid, uint intr_val)
 {
 	struct si_info *sii;
 
-	sii = SI_INFO(sih);
+	sii = (struct si_info *)sih;
 	if (SI_FAST(sii)
 	    && ((coreid == CC_CORE_ID) || (coreid == sih->buscoretype)))
 		return;
@@ -1325,7 +1326,7 @@ void ai_restore_core(struct si_pub *sih, uint coreid, uint intr_val)
 
 void ai_write_wrapperreg(struct si_pub *sih, u32 offset, u32 val)
 {
-	struct si_info *sii = SI_INFO(sih);
+	struct si_info *sii = (struct si_info *)sih;
 	u32 *w = (u32 *) sii->curwrap;
 	W_REG(w + (offset / 4), val);
 	return;
@@ -1351,7 +1352,7 @@ uint ai_corereg(struct si_pub *sih, uint coreidx, uint regoff, uint mask,
 	bool fast = false;
 	struct si_info *sii;
 
-	sii = SI_INFO(sih);
+	sii = (struct si_info *)sih;
 
 	if (coreidx >= SI_MAXCORES)
 		return 0;
@@ -1418,7 +1419,7 @@ void ai_core_disable(struct si_pub *sih, u32 bits)
 	u32 dummy;
 	struct aidmp *ai;
 
-	sii = SI_INFO(sih);
+	sii = (struct si_info *)sih;
 
 	ai = sii->curwrap;
 
@@ -1445,7 +1446,7 @@ void ai_core_reset(struct si_pub *sih, u32 bits, u32 resetbits)
 	struct aidmp *ai;
 	u32 dummy;
 
-	sii = SI_INFO(sih);
+	sii = (struct si_info *)sih;
 	ai = sii->curwrap;
 
 	/*
@@ -1564,7 +1565,7 @@ void ai_clkctl_init(struct si_pub *sih)
 	if (!CCCTL_ENAB(sih))
 		return;
 
-	sii = SI_INFO(sih);
+	sii = (struct si_info *)sih;
 	fast = SI_FAST(sii);
 	if (!fast) {
 		origidx = sii->curidx;
@@ -1602,7 +1603,7 @@ u16 ai_clkctl_fast_pwrup_delay(struct si_pub *sih)
 	uint intr_val = 0;
 	bool fast;
 
-	sii = SI_INFO(sih);
+	sii = (struct si_info *)sih;
 	if (PMUCTL_ENAB(sih)) {
 		INTR_OFF(sii, intr_val);
 		fpdelay = si_pmu_fast_pwrup_delay(sih);
@@ -1645,7 +1646,7 @@ int ai_clkctl_xtal(struct si_pub *sih, uint what, bool on)
 	struct si_info *sii;
 	u32 in, out, outen;
 
-	sii = SI_INFO(sih);
+	sii = (struct si_info *)sih;
 
 	/* pcie core doesn't have any mapping to control the xtal pu */
 	if (PCIE(sii))
@@ -1800,7 +1801,7 @@ bool ai_clkctl_cc(struct si_pub *sih, uint mode)
 {
 	struct si_info *sii;
 
-	sii = SI_INFO(sih);
+	sii = (struct si_info *)sih;
 
 	/* chipcommon cores prior to rev6 don't support dynamic clock control */
 	if (sih->ccrev < 6)
@@ -1821,8 +1822,9 @@ int ai_devpath(struct si_pub *sih, char *path, int size)
 		return -1;
 
 	slen = snprintf(path, (size_t) size, "pci/%u/%u/",
-		(((SI_INFO(sih))->pbus))->bus->number,
-		PCI_SLOT(((struct pci_dev *)((SI_INFO(sih))->pbus))->devfn));
+		((struct si_info *)sih)->pbus->bus->number,
+		PCI_SLOT(((struct pci_dev *)
+				(((struct si_info *)(sih))->pbus))->devfn));
 
 	if (slen < 0 || slen >= size) {
 		path[0] = '\0';
@@ -1886,7 +1888,7 @@ bool ai_pci_war16165(struct si_pub *sih)
 {
 	struct si_info *sii;
 
-	sii = SI_INFO(sih);
+	sii = (struct si_info *)sih;
 
 	return PCI(sii) && (sih->buscorerev <= 10);
 }
@@ -1895,7 +1897,7 @@ void ai_pci_up(struct si_pub *sih)
 {
 	struct si_info *sii;
 
-	sii = SI_INFO(sih);
+	sii = (struct si_info *)sih;
 
 	if (PCI_FORCEHT(sii))
 		_ai_clkctl_cc(sii, CLK_FAST);
@@ -1910,7 +1912,7 @@ void ai_pci_sleep(struct si_pub *sih)
 {
 	struct si_info *sii;
 
-	sii = SI_INFO(sih);
+	sii = (struct si_info *)sih;
 
 	pcicore_sleep(sii->pch);
 }
@@ -1920,7 +1922,7 @@ void ai_pci_down(struct si_pub *sih)
 {
 	struct si_info *sii;
 
-	sii = SI_INFO(sih);
+	sii = (struct si_info *)sih;
 
 	/* release FORCEHT since chip is going to "down" state */
 	if (PCI_FORCEHT(sii))
@@ -1940,7 +1942,7 @@ void ai_pci_setup(struct si_pub *sih, uint coremask)
 	u32 siflag = 0, w;
 	uint idx = 0;
 
-	sii = SI_INFO(sih);
+	sii = (struct si_info *)sih;
 
 	if (PCI(sii)) {
 		/* get current core index */
@@ -1983,7 +1985,7 @@ int ai_pci_fixcfg(struct si_pub *sih)
 {
 	uint origidx;
 	void *regs = NULL;
-	struct si_info *sii = SI_INFO(sih);
+	struct si_info *sii = (struct si_info *)sih;
 
 	/* Fixup PI in SROM shadow area to enable the correct PCI core access */
 	/* save the current index */
@@ -2019,7 +2021,7 @@ void ai_chipcontrl_epa4331(struct si_pub *sih, bool on)
 	uint origidx;
 	u32 val;
 
-	sii = SI_INFO(sih);
+	sii = (struct si_info *)sih;
 	origidx = ai_coreidx(sih);
 
 	cc = (struct chipcregs *) ai_setcore(sih, CC_CORE_ID, 0);
@@ -2051,7 +2053,7 @@ void ai_epa_4313war(struct si_pub *sih)
 	struct chipcregs *cc;
 	uint origidx;
 
-	sii = SI_INFO(sih);
+	sii = (struct si_info *)sih;
 	origidx = ai_coreidx(sih);
 
 	cc = ai_setcore(sih, CC_CORE_ID, 0);
@@ -2069,7 +2071,7 @@ bool ai_deviceremoved(struct si_pub *sih)
 	u32 w;
 	struct si_info *sii;
 
-	sii = SI_INFO(sih);
+	sii = (struct si_info *)sih;
 
 	pci_read_config_dword(sii->pbus, PCI_VENDOR_ID, &w);
 	if ((w & 0xFFFF) != PCI_VENDOR_ID_BROADCOM)
@@ -2089,7 +2091,7 @@ bool ai_is_sprom_available(struct si_pub *sih)
 		if ((sih->cccaps & CC_CAP_SROM) == 0)
 			return false;
 
-		sii = SI_INFO(sih);
+		sii = (struct si_info *)sih;
 		origidx = sii->curidx;
 		cc = ai_setcoreidx(sih, SI_CC_IDX);
 		sromctrl = R_REG(&cc->sromcontrol);
diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.h b/drivers/staging/brcm80211/brcmsmac/aiutils.h
index b1f2c38..fcf38b8 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.h
@@ -243,9 +243,6 @@
 #define	BCM47162_CHIP_ID	47162	/* 47162 chipcommon chipid */
 #define	BCM4748_CHIP_ID		0x4748	/* 4716 chipcommon chipid (OTP, RBBU) */
 
-
-#define	SI_INFO(sih)	((struct si_info *)sih)
-
 #define	GOODCOREADDR(x, b) \
 	(((x) >= (b)) && ((x) < ((b) + SI_MAXCORES * SI_CORE_SIZE)) && \
 		IS_ALIGNED((x), SI_CORE_SIZE))
diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.c b/drivers/staging/brcm80211/brcmsmac/nicpci.c
index b34fe7d..6bffca0 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.c
@@ -784,7 +784,7 @@ void pcicore_down(struct pcicore_info *pi, int state)
 /* precondition: current core is sii->buscoretype */
 static void pcicore_fixcfg(struct pcicore_info *pi, u16 *reg16)
 {
-	struct si_info *sii = SI_INFO(pi->sih);
+	struct si_info *sii = (struct si_info *)(pi->sih);
 	u16 val16;
 	uint pciidx;
 
@@ -814,7 +814,7 @@ void pcicore_pci_setup(struct pcicore_info *pi, struct sbpciregs *pciregs)
 
 	OR_REG(&pciregs->sbtopci2, SBTOPCI_PREF | SBTOPCI_BURST);
 
-	if (SI_INFO(pi->sih)->pub.buscorerev >= 11) {
+	if (((struct si_info *)(pi->sih))->pub.buscorerev >= 11) {
 		OR_REG(&pciregs->sbtopci2, SBTOPCI_RC_READMULTI);
 		w = R_REG(&pciregs->clkrun);
 		W_REG(&pciregs->clkrun, w | PCI_CLKRUN_DSBL);
-- 
1.7.4.1


