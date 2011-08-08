Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1856 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389Ab1HHN7i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:38 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 76/82] staging: brcm80211: removed void * from ai_
 functions
Date: Mon, 8 Aug 2011 15:59:00 +0200
Message-ID: <1312811946-16713-77-git-send-email-arend@broadcom.com> (sfid-20110808_160006_719466_76701837)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. Replaced void * by less generic pointer types.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/aiutils.c |   46 +++++++++++++-------------
 drivers/staging/brcm80211/brcmsmac/aiutils.h |    5 +--
 drivers/staging/brcm80211/brcmsmac/pmu.c     |    4 +-
 3 files changed, 26 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index 9cfb492..3d392a3 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -483,16 +483,16 @@ static void ai_hwfixup(struct si_info *sii)
 }
 
 /* parse the enumeration rom to identify all cores */
-void ai_scan(struct si_pub *sih, void *regs)
+void ai_scan(struct si_pub *sih, struct chipcregs *cc)
 {
 	struct si_info *sii = SI_INFO(sih);
-	struct chipcregs *cc = (struct chipcregs *) regs;
 	u32 erombase, *eromptr, *eromlim;
+	void *regs = cc;
 
 	erombase = R_REG(&cc->eromptr);
 
 	/* Set wrappers address */
-	sii->curwrap = (void *)((unsigned long)regs + SI_CORE_SIZE);
+	sii->curwrap = (void *)((unsigned long)cc + SI_CORE_SIZE);
 
 	/* Now point the window at the erom */
 	pci_write_config_dword(sii->pbus, PCI_BAR0_WIN, erombase);
@@ -671,7 +671,10 @@ void ai_scan(struct si_pub *sih, void *regs)
 
 /*
  * This function changes the logical "focus" to the indicated core.
- * Return the current core's virtual address.
+ * Return the current core's virtual address. Since each core starts with the
+ * same set of registers (BIST, clock control, etc), the returned address
+ * contains the first register of this 'common' register block (not to be
+ * confused with 'common core').
  */
 void *ai_setcoreidx(struct si_pub *sih, uint coreidx)
 {
@@ -864,8 +867,7 @@ static struct si_info *ai_doattach(struct si_info *sii, void *regs,
 				   struct pci_dev *sdh,
 				   char **vars, uint *varsz);
 static bool ai_buscore_prep(struct si_info *sii);
-static bool ai_buscore_setup(struct si_info *sii, struct chipcregs *cc,
-			     u32 savewin, uint *origidx, void *regs);
+static bool ai_buscore_setup(struct si_info *sii, u32 savewin, uint *origidx);
 static void ai_nvram_process(struct si_info *sii, char *pvars);
 
 /* dev path concatenation util */
@@ -916,12 +918,12 @@ static bool ai_buscore_prep(struct si_info *sii)
 }
 
 static bool
-ai_buscore_setup(struct si_info *sii, struct chipcregs *cc, u32 savewin,
-		 uint *origidx, void *regs)
+ai_buscore_setup(struct si_info *sii, u32 savewin, uint *origidx)
 {
 	bool pci, pcie;
 	uint i;
 	uint pciidx, pcieidx, pcirev, pcierev;
+	struct chipcregs *cc;
 
 	cc = ai_setcoreidx(&sii->pub, SI_CC_IDX);
 
@@ -977,7 +979,7 @@ ai_buscore_setup(struct si_info *sii, struct chipcregs *cc, u32 savewin,
 
 		/* find the core idx before entering this func. */
 		if ((savewin && (savewin == sii->coresba[i])) ||
-		    (regs == sii->regs[i]))
+		    (cc == sii->regs[i]))
 			*origidx = i;
 	}
 
@@ -1003,9 +1005,8 @@ ai_buscore_setup(struct si_info *sii, struct chipcregs *cc, u32 savewin,
 	/* fixup necessary chip/core configurations */
 	if (SI_FAST(sii)) {
 		if (!sii->pch) {
-			sii->pch = (void *)pcicore_init(
-				&sii->pub, sii->pbus,
-				(void *)PCIEREGS(sii));
+			sii->pch = pcicore_init(&sii->pub, sii->pbus,
+						(void *)PCIEREGS(sii));
 			if (sii->pch == NULL)
 				return false;
 		}
@@ -1108,7 +1109,7 @@ static struct si_info *ai_doattach(struct si_info *sii,
 	if (socitype == SOCI_AI) {
 		SI_MSG(("Found chip type AI (0x%08x)\n", w));
 		/* pass chipc address instead of original core base */
-		ai_scan(&sii->pub, (void *)cc);
+		ai_scan(&sii->pub, cc);
 	} else {
 		SI_ERROR(("Found chip of unknown type (0x%08x)\n", w));
 		return NULL;
@@ -1120,13 +1121,13 @@ static struct si_info *ai_doattach(struct si_info *sii,
 	}
 	/* bus/core/clk setup */
 	origidx = SI_CC_IDX;
-	if (!ai_buscore_setup(sii, cc, savewin, &origidx, regs)) {
+	if (!ai_buscore_setup(sii, savewin, &origidx)) {
 		SI_ERROR(("si_doattach: si_buscore_setup failed\n"));
 		goto exit;
 	}
 
 	/* Init nvram from sprom/otp if they exist */
-	if (srom_var_init(&sii->pub, regs, vars, varsz)) {
+	if (srom_var_init(&sii->pub, cc, vars, varsz)) {
 		SI_ERROR(("si_doattach: srom_var_init failed: bad srom\n"));
 		goto exit;
 	}
@@ -1327,9 +1328,9 @@ void *ai_switch_core(struct si_pub *sih, uint coreid, uint *origidx,
 		 */
 		*origidx = coreid;
 		if (coreid == CC_CORE_ID)
-			return (void *)CCREGS_FAST(sii);
+			return CCREGS_FAST(sii);
 		else if (coreid == sih->buscoretype)
-			return (void *)PCIEREGS(sii);
+			return PCIEREGS(sii);
 	}
 	INTR_OFF(sii, *intr_val);
 	*origidx = sii->curidx;
@@ -1553,9 +1554,8 @@ ai_slowclk_freq(struct si_info *sii, bool max_freq, struct chipcregs *cc)
 	return 0;
 }
 
-static void ai_clkctl_setdelay(struct si_info *sii, void *chipcregs)
+static void ai_clkctl_setdelay(struct si_info *sii, struct chipcregs *cc)
 {
-	struct chipcregs *cc = (struct chipcregs *) chipcregs;
 	uint slowmaxfreq, pll_delay, slowclk;
 	uint pll_on_delay, fref_sel_delay;
 
@@ -1611,7 +1611,7 @@ void ai_clkctl_init(struct si_pub *sih)
 		SET_REG(&cc->system_clk_ctl, SYCC_CD_MASK,
 			(ILP_DIV_1MHZ << SYCC_CD_SHIFT));
 
-	ai_clkctl_setdelay(sii, (void *)cc);
+	ai_clkctl_setdelay(sii, cc);
 
 	if (!fast)
 		ai_setcoreidx(sih, origidx);
@@ -1979,7 +1979,7 @@ void ai_pci_down(struct si_pub *sih)
 void ai_pci_setup(struct si_pub *sih, uint coremask)
 {
 	struct si_info *sii;
-	void *regs = NULL;
+	struct sbpciregs *regs = NULL;
 	u32 siflag = 0, w;
 	uint idx = 0;
 
@@ -2025,7 +2025,7 @@ void ai_pci_setup(struct si_pub *sih, uint coremask)
 int ai_pci_fixcfg(struct si_pub *sih)
 {
 	uint origidx;
-	void *regs = NULL;
+	struct sbpciregs *regs = NULL;
 
 	struct si_info *sii = SI_INFO(sih);
 
@@ -2095,7 +2095,7 @@ void ai_epa_4313war(struct si_pub *sih)
 	sii = SI_INFO(sih);
 	origidx = ai_coreidx(sih);
 
-	cc = (struct chipcregs *) ai_setcore(sih, CC_CORE_ID, 0);
+	cc = ai_setcore(sih, CC_CORE_ID, 0);
 
 	/* EPA Fix */
 	W_REG(&cc->gpiocontrol,
diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.h b/drivers/staging/brcm80211/brcmsmac/aiutils.h
index 101ab92..84c6901 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.h
@@ -468,7 +468,7 @@ struct si_info {
 	/* check if interrupts are enabled */
 	bool (*intrsenabled_fn) (void *intr_arg);
 
-	void *pch;		/* PCI/E core handle */
+	struct pcicore_info *pch; /* PCI/E core handle */
 
 	char *vars;
 	uint varsz;
@@ -495,15 +495,12 @@ struct si_info {
 };
 
 /* AMBA Interconnect exported externs */
-extern void ai_scan(struct si_pub *sih, void *regs);
-
 extern uint ai_flag(struct si_pub *sih);
 extern void ai_setint(struct si_pub *sih, int siflag);
 extern uint ai_coreidx(struct si_pub *sih);
 extern uint ai_corevendor(struct si_pub *sih);
 extern uint ai_corerev(struct si_pub *sih);
 extern bool ai_iscoreup(struct si_pub *sih);
-extern void *ai_setcoreidx(struct si_pub *sih, uint coreidx);
 extern u32 ai_core_cflags(struct si_pub *sih, u32 mask, u32 val);
 extern void ai_core_cflags_wo(struct si_pub *sih, u32 mask, u32 val);
 extern u32 ai_core_sflags(struct si_pub *sih, u32 mask, u32 val);
diff --git a/drivers/staging/brcm80211/brcmsmac/pmu.c b/drivers/staging/brcm80211/brcmsmac/pmu.c
index f5e1085..cdeaa4e 100644
--- a/drivers/staging/brcm80211/brcmsmac/pmu.c
+++ b/drivers/staging/brcm80211/brcmsmac/pmu.c
@@ -320,8 +320,8 @@ void si_pmu_spuravoid(struct si_pub *sih, u8 spuravoid)
 	uint origidx, intr_val;
 
 	/* Remember original core before switch to chipc */
-	cc = (struct chipcregs *) ai_switch_core(sih, CC_CORE_ID, &origidx,
-					    &intr_val);
+	cc = (struct chipcregs *)
+			ai_switch_core(sih, CC_CORE_ID, &origidx, &intr_val);
 
 	/* update the pll changes */
 	si_pmu_spuravoid_pllupdate(sih, cc, spuravoid);
-- 
1.7.4.1


