Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4456 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756912Ab1F2Xsi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:38 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 015/119] staging: brcm80211: remove chip simulation
 specific code
Date: Wed, 29 Jun 2011 16:46:39 -0700
Message-ID: <1309391303-22741-16-git-send-email-frankyl@broadcom.com> (sfid-20110630_014855_237789_6A08BD55)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The driver contained several code paths specific to running the
driver against a simulated chip. This is not needed and removed.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/aiutils.h     |    2 -
 drivers/staging/brcm80211/brcmsmac/main.c        |    6 +--
 drivers/staging/brcm80211/brcmsmac/nicpci.c      |   39 ++++++--------
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |   38 +++++---------
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c   |    4 +-
 drivers/staging/brcm80211/brcmsmac/pmu.c         |   10 +---
 drivers/staging/brcm80211/brcmsmac/srom.c        |   61 +---------------------
 7 files changed, 37 insertions(+), 123 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.h b/drivers/staging/brcm80211/brcmsmac/aiutils.h
index 965eb94..b00780d 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.h
@@ -409,8 +409,6 @@ struct si_pub {
 #define SI_PCIDOWN	2
 #define SI_PCIUP	3
 
-#define	ISSIM_ENAB(sih)	0
-
 /* PMU clock/power control */
 #if defined(BCMPMUCTL)
 #define PMUCTL_ENAB(sih)	(BCMPMUCTL)
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index ca9f195..093f3bf 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -5480,10 +5480,8 @@ static void brcms_c_bss_default_init(struct brcms_c_info *wlc)
 
 	/* init default and target BSS with some sane initial values */
 	memset((char *)(bi), 0, sizeof(wlc_bss_info_t));
-	bi->beacon_period = ISSIM_ENAB(wlc->pub->sih) ? BEACON_INTERVAL_DEF_QT :
-	    BEACON_INTERVAL_DEFAULT;
-	bi->dtim_period = ISSIM_ENAB(wlc->pub->sih) ? DTIM_INTERVAL_DEF_QT :
-	    DTIM_INTERVAL_DEFAULT;
+	bi->beacon_period = BEACON_INTERVAL_DEFAULT;
+	bi->dtim_period = DTIM_INTERVAL_DEFAULT;
 
 	/* fill the default channel as the first valid channel
 	 * starting from the 2G channels
diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.c b/drivers/staging/brcm80211/brcmsmac/nicpci.c
index 5a19182..70d4173 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.c
@@ -596,28 +596,23 @@ static void pcie_war_aspm_clkreq(pcicore_info_t *pi)
 		return;
 
 	/* bypass this on QT or VSIM */
-	if (!ISSIM_ENAB(sih)) {
-
-		reg16 = &pcieregs->sprom[SRSH_ASPM_OFFSET];
-		val16 = R_REG(reg16);
+	reg16 = &pcieregs->sprom[SRSH_ASPM_OFFSET];
+	val16 = R_REG(reg16);
 
-		val16 &= ~SRSH_ASPM_ENB;
-		if (pi->pcie_war_aspm_ovr == PCIE_ASPM_ENAB)
-			val16 |= SRSH_ASPM_ENB;
-		else if (pi->pcie_war_aspm_ovr == PCIE_ASPM_L1_ENAB)
-			val16 |= SRSH_ASPM_L1_ENB;
-		else if (pi->pcie_war_aspm_ovr == PCIE_ASPM_L0s_ENAB)
-			val16 |= SRSH_ASPM_L0s_ENB;
+	val16 &= ~SRSH_ASPM_ENB;
+	if (pi->pcie_war_aspm_ovr == PCIE_ASPM_ENAB)
+		val16 |= SRSH_ASPM_ENB;
+	else if (pi->pcie_war_aspm_ovr == PCIE_ASPM_L1_ENAB)
+		val16 |= SRSH_ASPM_L1_ENB;
+	else if (pi->pcie_war_aspm_ovr == PCIE_ASPM_L0s_ENAB)
+		val16 |= SRSH_ASPM_L0s_ENB;
 
-		W_REG(reg16, val16);
+	W_REG(reg16, val16);
 
-		pci_read_config_dword(pi->dev, pi->pciecap_lcreg_offset,
-					&w);
-		w &= ~PCIE_ASPM_ENAB;
-		w |= pi->pcie_war_aspm_ovr;
-		pci_write_config_dword(pi->dev,
-					pi->pciecap_lcreg_offset, w);
-	}
+	pci_read_config_dword(pi->dev, pi->pciecap_lcreg_offset, &w);
+	w &= ~PCIE_ASPM_ENAB;
+	w |= pi->pcie_war_aspm_ovr;
+	pci_write_config_dword(pi->dev, pi->pciecap_lcreg_offset, w);
 
 	reg16 = &pcieregs->sprom[SRSH_CLKREQ_OFFSET_REV5];
 	val16 = R_REG(reg16);
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index dd56f10..a15c145 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -519,6 +519,7 @@ wlc_phy_t *wlc_phy_attach(shared_phy_t *sh, void *regs, int bandtype,
 	phy_info_t *pi;
 	u32 sflags = 0;
 	uint phyversion;
+	u32 idcode;
 	int i;
 
 	if (D11REV_IS(sh->corerev, 4))
@@ -589,27 +590,19 @@ wlc_phy_t *wlc_phy_attach(shared_phy_t *sh, void *regs, int bandtype,
 		}
 	}
 
-	if (ISSIM_ENAB(pi->sh->sih)) {
-		pi->pubpi.radioid = NORADIO_ID;
-		pi->pubpi.radiorev = 5;
-	} else {
-		u32 idcode;
-
-		wlc_phy_anacore((wlc_phy_t *) pi, ON);
-
-		idcode = wlc_phy_get_radio_ver(pi);
-		pi->pubpi.radioid =
-		    (idcode & IDCODE_ID_MASK) >> IDCODE_ID_SHIFT;
-		pi->pubpi.radiorev =
-		    (idcode & IDCODE_REV_MASK) >> IDCODE_REV_SHIFT;
-		pi->pubpi.radiover =
-		    (idcode & IDCODE_VER_MASK) >> IDCODE_VER_SHIFT;
-		if (!VALID_RADIO(pi, pi->pubpi.radioid)) {
-			goto err;
-		}
+	wlc_phy_anacore((wlc_phy_t *) pi, ON);
 
-		wlc_phy_switch_radio((wlc_phy_t *) pi, OFF);
-	}
+	idcode = wlc_phy_get_radio_ver(pi);
+	pi->pubpi.radioid =
+	    (idcode & IDCODE_ID_MASK) >> IDCODE_ID_SHIFT;
+	pi->pubpi.radiorev =
+	    (idcode & IDCODE_REV_MASK) >> IDCODE_REV_SHIFT;
+	pi->pubpi.radiover =
+	    (idcode & IDCODE_VER_MASK) >> IDCODE_VER_SHIFT;
+	if (!VALID_RADIO(pi, pi->pubpi.radioid))
+		goto err;
+
+	wlc_phy_switch_radio((wlc_phy_t *) pi, OFF);
 
 	wlc_set_phy_uninitted(pi);
 
@@ -1195,11 +1188,6 @@ void wlc_phy_do_dummy_tx(phy_info_t *pi, bool ofdm, bool pa_on)
 
 	i = 0;
 	count = ofdm ? 30 : 250;
-
-	if (ISSIM_ENAB(pi->sh->sih)) {
-		count *= 100;
-	}
-
 	while ((i++ < count)
 	       && (R_REG(&regs->txe_status) & (1 << 7))) {
 		udelay(10);
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
index ff0eb22..57fff0f 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
@@ -15369,9 +15369,7 @@ static void wlc_phy_workarounds_nphy(phy_info_t *pi)
 	if (pi->phyhang_avoid)
 		wlc_phy_stay_in_carriersearch_nphy(pi, true);
 
-	if (!ISSIM_ENAB(pi->sh->sih)) {
-		or_phy_reg(pi, 0xb1, NPHY_IQFlip_ADC1 | NPHY_IQFlip_ADC2);
-	}
+	or_phy_reg(pi, 0xb1, NPHY_IQFlip_ADC1 | NPHY_IQFlip_ADC2);
 
 	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 
diff --git a/drivers/staging/brcm80211/brcmsmac/pmu.c b/drivers/staging/brcm80211/brcmsmac/pmu.c
index 6508243..e8b2b81 100644
--- a/drivers/staging/brcm80211/brcmsmac/pmu.c
+++ b/drivers/staging/brcm80211/brcmsmac/pmu.c
@@ -203,7 +203,7 @@ u32 si_pmu_ilp_clock(struct si_pub *sih)
 {
 	static u32 ilpcycles_per_sec;
 
-	if (ISSIM_ENAB(sih) || !PMUCTL_ENAB(sih))
+	if (!PMUCTL_ENAB(sih))
 		return ILP_CLOCK;
 
 	if (ilpcycles_per_sec == 0) {
@@ -225,21 +225,15 @@ u16 si_pmu_fast_pwrup_delay(struct si_pub *sih)
 {
 	uint delay = PMU_MAX_TRANSITION_DLY;
 
-	/* Remember original core before switch to chipc */
-	origidx = ai_coreidx(sih);
-	cc = ai_setcoreidx(sih, SI_CC_IDX);
-
 	switch (sih->chip) {
 	case BCM43224_CHIP_ID:
 	case BCM43225_CHIP_ID:
 	case BCM4313_CHIP_ID:
-		delay = ISSIM_ENAB(sih) ? 70 : 3700;
+		delay = 3700;
 		break;
 	default:
 		break;
 	}
-	/* Return to original core */
-	ai_setcoreidx(sih, origidx);
 
 	return (u16) delay;
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/srom.c b/drivers/staging/brcm80211/brcmsmac/srom.c
index 34c19ef..de3e703 100644
--- a/drivers/staging/brcm80211/brcmsmac/srom.c
+++ b/drivers/staging/brcm80211/brcmsmac/srom.c
@@ -783,8 +783,6 @@ static int sprom_read_pci(struct si_pub *sih, u16 *sprom,
 #if defined(BCMNVRAMR)
 static int otp_read_pci(struct si_pub *sih, u16 *buf, uint bufsz);
 #endif
-static u16 srom_cc_cmd(struct si_pub *sih, void *ccregs, u32 cmd,
-			  uint wordoff, u16 data);
 
 static int initvars_table(char *start, char *end,
 			  char **vars, uint *count);
@@ -873,38 +871,6 @@ int srom_var_init(struct si_pub *sih, uint bustype, void *curmap,
 	return -EINVAL;
 }
 
-/* In chips with chipcommon rev 32 and later, the srom is in chipcommon,
- * not in the bus cores.
- */
-static u16
-srom_cc_cmd(struct si_pub *sih, void *ccregs, u32 cmd,
-	    uint wordoff, u16 data)
-{
-	chipcregs_t *cc = (chipcregs_t *) ccregs;
-	uint wait_cnt = 1000;
-
-	if ((cmd == SRC_OP_READ) || (cmd == SRC_OP_WRITE)) {
-		W_REG(&cc->sromaddress, wordoff * 2);
-		if (cmd == SRC_OP_WRITE)
-			W_REG(&cc->sromdata, data);
-	}
-
-	W_REG(&cc->sromcontrol, SRC_START | cmd);
-
-	while (wait_cnt--) {
-		if ((R_REG(&cc->sromcontrol) & SRC_BUSY) == 0)
-			break;
-	}
-
-	if (!wait_cnt) {
-		return 0xffff;
-	}
-	if (cmd == SRC_OP_READ)
-		return (u16) R_REG(&cc->sromdata);
-	else
-		return 0xffff;
-}
-
 static inline void ltoh16_buf(u16 *buf, unsigned int size)
 {
 	for (size /= 2; size; size--)
@@ -927,33 +893,10 @@ sprom_read_pci(struct si_pub *sih, u16 *sprom, uint wordoff,
 {
 	int err = 0;
 	uint i;
-	void *ccregs = NULL;
 
 	/* read the sprom */
-	for (i = 0; i < nwords; i++) {
-
-		if (sih->ccrev > 31 && ISSIM_ENAB(sih)) {
-			/* use indirect since direct is too slow on QT */
-			if ((sih->cccaps & CC_CAP_SROM) == 0)
-				return -ENODEV;
-
-			ccregs = (void *)((u8 *) sprom - CC_SROM_OTP);
-			buf[i] =
-			    srom_cc_cmd(sih, ccregs, SRC_OP_READ,
-					wordoff + i, 0);
-
-		} else {
-			if (ISSIM_ENAB(sih))
-				buf[i] = R_REG(&sprom[wordoff + i]);
-
-			buf[i] = R_REG(&sprom[wordoff + i]);
-		}
-
-	}
-
-	/* bypass crc checking for simulation to allow srom hack */
-	if (ISSIM_ENAB(sih))
-		return 0;
+	for (i = 0; i < nwords; i++)
+		buf[i] = R_REG(&sprom[wordoff + i]);
 
 	if (check_crc) {
 
-- 
1.7.1


