Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2115 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934693Ab1JENUo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 09:20:44 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 05/15] staging: brcm80211: change parameter in driver
 variable lookup
Date: Wed, 5 Oct 2011 15:20:04 +0200
Message-ID: <1317820814-7083-6-git-send-email-arend@broadcom.com> (sfid-20111005_152049_746046_DE8B60B6)
In-Reply-To: <1317820814-7083-1-git-send-email-arend@broadcom.com>
References: <1317820814-7083-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The functions getvar() and getintvar() had to pass the buffer
containing the driver variables. Now they pass the structure
containing this buffer hiding what type of buffer/container
is used for storing the driver variables.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/aiutils.c     |   18 +-
 drivers/staging/brcm80211/brcmsmac/antsel.c      |   15 +-
 drivers/staging/brcm80211/brcmsmac/channel.c     |    2 +-
 drivers/staging/brcm80211/brcmsmac/main.c        |   29 ++--
 drivers/staging/brcm80211/brcmsmac/nicpci.c      |    4 +-
 drivers/staging/brcm80211/brcmsmac/nicpci.h      |    2 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c |   62 +++----
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c   |  223 +++++++++++-----------
 drivers/staging/brcm80211/brcmsmac/phy_shim.c    |    8 +-
 drivers/staging/brcm80211/brcmsmac/phy_shim.h    |    4 +-
 drivers/staging/brcm80211/brcmsmac/pub.h         |    4 +-
 drivers/staging/brcm80211/brcmsmac/srom.c        |   11 +-
 drivers/staging/brcm80211/brcmsmac/stf.c         |    4 +-
 13 files changed, 190 insertions(+), 196 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index 8d4024e..d44f619 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -1012,7 +1012,7 @@ ai_buscore_setup(struct si_info *sii, u32 savewin, uint *origidx)
 /*
  * get boardtype and boardrev
  */
-static __used void ai_nvram_process(struct si_info *sii, char *pvars)
+static __used void ai_nvram_process(struct si_info *sii)
 {
 	uint w = 0;
 
@@ -1021,7 +1021,7 @@ static __used void ai_nvram_process(struct si_info *sii, char *pvars)
 
 	sii->pub.boardvendor = w & 0xffff;
 	sii->pub.boardtype = (w >> 16) & 0xffff;
-	sii->pub.boardflags = getintvar(pvars, "boardflags");
+	sii->pub.boardflags = getintvar(&sii->pub, "boardflags");
 }
 
 static struct si_info *ai_doattach(struct si_info *sii,
@@ -1031,7 +1031,6 @@ static struct si_info *ai_doattach(struct si_info *sii,
 	struct si_pub *sih = &sii->pub;
 	u32 w, savewin;
 	struct chipcregs __iomem *cc;
-	char *pvars = NULL;
 	uint socitype;
 	uint origidx;
 
@@ -1095,8 +1094,9 @@ static struct si_info *ai_doattach(struct si_info *sii,
 	if (srom_var_init(&sii->pub, cc, vars, varsz))
 		goto exit;
 
-	pvars = vars ? *vars : NULL;
-	ai_nvram_process(sii, pvars);
+	sii->vars = vars ? *vars : NULL;
+	sii->varsz = varsz ? *varsz : 0;
+	ai_nvram_process(sii);
 
 	/* === NVRAM, clock is ready === */
 	cc = (struct chipcregs __iomem *) ai_setcore(sih, CC_CORE_ID, 0);
@@ -1109,7 +1109,7 @@ static struct si_info *ai_doattach(struct si_info *sii,
 		u32 xtalfreq;
 		si_pmu_init(sih);
 		si_pmu_chip_init(sih);
-		xtalfreq = getintvar(pvars, "xtalfreq");
+		xtalfreq = getintvar(sih, "xtalfreq");
 		/* If xtalfreq var not available, try to measure it */
 		if (xtalfreq == 0)
 			xtalfreq = si_pmu_measure_alpclk(sih);
@@ -1119,14 +1119,14 @@ static struct si_info *ai_doattach(struct si_info *sii,
 	}
 
 	/* setup the GPIO based LED powersave register */
-	w = getintvar(pvars, "leddc");
+	w = getintvar(sih, "leddc");
 	if (w == 0)
 		w = DEFAULT_GPIOTIMERVAL;
 	ai_corereg(sih, SI_CC_IDX, offsetof(struct chipcregs, gpiotimerval),
 		   ~0, w);
 
 	if (PCIE(sii))
-		pcicore_attach(sii->pch, pvars, SI_DOATTACH);
+		pcicore_attach(sii->pch, SI_DOATTACH);
 
 	if (sih->chip == BCM43224_CHIP_ID) {
 		/*
@@ -1191,8 +1191,6 @@ ai_attach(void __iomem *regs, struct pci_dev *sdh, char **vars, uint *varsz)
 		kfree(sii);
 		return NULL;
 	}
-	sii->vars = vars ? *vars : NULL;
-	sii->varsz = varsz ? *varsz : 0;
 
 	return (struct si_pub *) sii;
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/antsel.c b/drivers/staging/brcm80211/brcmsmac/antsel.c
index c2aa47b..eedcdb6 100644
--- a/drivers/staging/brcm80211/brcmsmac/antsel.c
+++ b/drivers/staging/brcm80211/brcmsmac/antsel.c
@@ -108,6 +108,7 @@ brcms_c_antsel_init_cfg(struct antsel_info *asi, struct brcms_antselcfg *antsel,
 struct antsel_info *brcms_c_antsel_attach(struct brcms_c_info *wlc)
 {
 	struct antsel_info *asi;
+	struct si_pub *sih = wlc->hw->sih;
 
 	asi = kzalloc(sizeof(struct antsel_info), GFP_ATOMIC);
 	if (!asi)
@@ -117,7 +118,7 @@ struct antsel_info *brcms_c_antsel_attach(struct brcms_c_info *wlc)
 	asi->pub = wlc->pub;
 	asi->antsel_type = ANTSEL_NA;
 	asi->antsel_avail = false;
-	asi->antsel_antswitch = (u8) getintvar(asi->pub->vars, "antswitch");
+	asi->antsel_antswitch = (u8) getintvar(sih, "antswitch");
 
 	if ((asi->pub->sromrev >= 4) && (asi->antsel_antswitch != 0)) {
 		switch (asi->antsel_antswitch) {
@@ -127,12 +128,12 @@ struct antsel_info *brcms_c_antsel_attach(struct brcms_c_info *wlc)
 			/* 4321/2 board with 2x3 switch logic */
 			asi->antsel_type = ANTSEL_2x3;
 			/* Antenna selection availability */
-			if (((u16) getintvar(asi->pub->vars, "aa2g") == 7) ||
-			    ((u16) getintvar(asi->pub->vars, "aa5g") == 7)) {
+			if (((u16) getintvar(sih, "aa2g") == 7) ||
+			    ((u16) getintvar(sih, "aa5g") == 7)) {
 				asi->antsel_avail = true;
 			} else if (
-				(u16) getintvar(asi->pub->vars, "aa2g") == 3 ||
-				(u16) getintvar(asi->pub->vars, "aa5g") == 3) {
+				(u16) getintvar(sih, "aa2g") == 3 ||
+				(u16) getintvar(sih, "aa5g") == 3) {
 				asi->antsel_avail = false;
 			} else {
 				asi->antsel_avail = false;
@@ -145,8 +146,8 @@ struct antsel_info *brcms_c_antsel_attach(struct brcms_c_info *wlc)
 			break;
 		}
 	} else if ((asi->pub->sromrev == 4) &&
-		   ((u16) getintvar(asi->pub->vars, "aa2g") == 7) &&
-		   ((u16) getintvar(asi->pub->vars, "aa5g") == 0)) {
+		   ((u16) getintvar(sih, "aa2g") == 7) &&
+		   ((u16) getintvar(sih, "aa5g") == 0)) {
 		/* hack to match old 4321CB2 cards with 2of3 antenna switch */
 		asi->antsel_type = ANTSEL_2x3;
 		asi->antsel_avail = true;
diff --git a/drivers/staging/brcm80211/brcmsmac/channel.c b/drivers/staging/brcm80211/brcmsmac/channel.c
index 2127c27..53066fb 100644
--- a/drivers/staging/brcm80211/brcmsmac/channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/channel.c
@@ -1088,7 +1088,7 @@ struct brcms_cm_info *brcms_c_channel_mgr_attach(struct brcms_c_info *wlc)
 	wlc->cmi = wlc_cm;
 
 	/* store the country code for passing up as a regulatory hint */
-	ccode = getvar(wlc->pub->vars, "ccode");
+	ccode = getvar(wlc->hw->sih, "ccode");
 	if (ccode)
 		strncpy(wlc->pub->srom_ccode, ccode, BRCM_CNTRY_BUF_SZ - 1);
 
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 100e6ec..f2339a5 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -1990,7 +1990,7 @@ static char *brcms_c_get_macaddr(struct brcms_hardware *wlc_hw)
 	char *macaddr;
 
 	/* If macaddr exists, use it (Sromrev4, CIS, ...). */
-	macaddr = getvar(wlc_hw->vars, varname);
+	macaddr = getvar(wlc_hw->sih, varname);
 	if (macaddr != NULL)
 		return macaddr;
 
@@ -1999,7 +1999,7 @@ static char *brcms_c_get_macaddr(struct brcms_hardware *wlc_hw)
 	else
 		varname = "il0macaddr";
 
-	macaddr = getvar(wlc_hw->vars, varname);
+	macaddr = getvar(wlc_hw->sih, varname);
 	if (macaddr == NULL)
 		wiphy_err(wlc_hw->wlc->wiphy, "wl%d: wlc_get_macaddr: macaddr "
 			  "getvar(%s) not found\n", wlc_hw->unit, varname);
@@ -4593,13 +4593,13 @@ static int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device,
 	 * than those the BIOS recognizes for devices on PCMCIA_BUS,
 	 * SDIO_BUS, and SROMless devices on PCI_BUS.
 	 */
-	var = getvar(vars, "vendid");
+	var = getvar(wlc_hw->sih, "vendid");
 	if (var && !kstrtoul(var, 0, &res)) {
 		vendor = (u16)res;
 		wiphy_err(wiphy, "Overriding vendor id = 0x%x\n",
 			  vendor);
 	}
-	var = getvar(vars, "devid");
+	var = getvar(wlc_hw->sih, "devid");
 	if (var && !kstrtoul(var, 0, &res)) {
 		u16 devid = (u16)res;
 		if (devid != 0xffff) {
@@ -4656,7 +4656,7 @@ static int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device,
 	}
 
 	/* get the board rev, used just below */
-	j = getintvar(vars, "boardrev");
+	j = getintvar(wlc_hw->sih, "boardrev");
 	/* promote srom boardrev of 0xFF to 1 */
 	if (j == BOARDREV_PROMOTABLE)
 		j = BOARDREV_PROMOTED;
@@ -4668,9 +4668,9 @@ static int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device,
 		err = 15;
 		goto fail;
 	}
-	wlc_hw->sromrev = (u8) getintvar(vars, "sromrev");
-	wlc_hw->boardflags = (u32) getintvar(vars, "boardflags");
-	wlc_hw->boardflags2 = (u32) getintvar(vars, "boardflags2");
+	wlc_hw->sromrev = (u8) getintvar(wlc_hw->sih, "sromrev");
+	wlc_hw->boardflags = (u32) getintvar(wlc_hw->sih, "boardflags");
+	wlc_hw->boardflags2 = (u32) getintvar(wlc_hw->sih, "boardflags2");
 
 	if (wlc_hw->boardflags & BFL_NOPLLDOWN)
 		brcms_b_pllreq(wlc_hw, true, BRCMS_PLLREQ_SHARED);
@@ -4920,15 +4920,16 @@ static bool brcms_c_attach_stf_ant_init(struct brcms_c_info *wlc)
 	uint unit;
 	char *vars;
 	int bandtype;
+	struct si_pub *sih = wlc->hw->sih;
 
 	unit = wlc->pub->unit;
 	vars = wlc->pub->vars;
 	bandtype = wlc->band->bandtype;
 
 	/* get antennas available */
-	aa = (s8) getintvar(vars, bandtype == BRCM_BAND_5G ? "aa5g" : "aa2g");
+	aa = (s8) getintvar(sih, bandtype == BRCM_BAND_5G ? "aa5g" : "aa2g");
 	if (aa == 0)
-		aa = (s8) getintvar(vars,
+		aa = (s8) getintvar(sih,
 				    bandtype == BRCM_BAND_5G ? "aa1" : "aa0");
 	if ((aa < 1) || (aa > 15)) {
 		wiphy_err(wlc->wiphy, "wl%d: %s: Invalid antennas available in"
@@ -4947,8 +4948,8 @@ static bool brcms_c_attach_stf_ant_init(struct brcms_c_info *wlc)
 	}
 
 	/* Compute Antenna Gain */
-	wlc->band->antgain =
-	    (s8) getintvar(vars, bandtype == BRCM_BAND_5G ? "ag1" : "ag0");
+	wlc->band->antgain = (s8) getintvar(sih, bandtype == BRCM_BAND_5G ?
+					    "ag1" : "ag0");
 	brcms_c_attach_antgain_init(wlc);
 
 	return true;
@@ -5114,9 +5115,9 @@ brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 
 	/* set maximum allowed duty cycle */
 	wlc->tx_duty_cycle_ofdm =
-	    (u16) getintvar(pub->vars, "tx_duty_cycle_ofdm");
+	    (u16) getintvar(wlc->hw->sih, "tx_duty_cycle_ofdm");
 	wlc->tx_duty_cycle_cck =
-	    (u16) getintvar(pub->vars, "tx_duty_cycle_cck");
+	    (u16) getintvar(wlc->hw->sih, "tx_duty_cycle_cck");
 
 	brcms_c_stf_phy_chain_calc(wlc);
 
diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.c b/drivers/staging/brcm80211/brcmsmac/nicpci.c
index 460b105..57721a0 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.c
@@ -719,13 +719,13 @@ static void pcie_war_pci_setup(struct pcicore_info *pi)
 }
 
 /* ***** Functions called during driver state changes ***** */
-void pcicore_attach(struct pcicore_info *pi, char *pvars, int state)
+void pcicore_attach(struct pcicore_info *pi, int state)
 {
 	struct si_pub *sih = pi->sih;
 
 	/* Determine if this board needs override */
 	if (PCIE_ASPM(sih)) {
-		if ((u32)getintvar(pvars, "boardflags2") & BFL2_PCIEWAR_OVR)
+		if ((u32)getintvar(sih, "boardflags2") & BFL2_PCIEWAR_OVR)
 			pi->pcie_war_aspm_ovr = PCIE_ASPM_DISAB;
 		else
 			pi->pcie_war_aspm_ovr = PCIE_ASPM_ENAB;
diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.h b/drivers/staging/brcm80211/brcmsmac/nicpci.h
index 2d41aab..58aa80d 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.h
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.h
@@ -65,7 +65,7 @@ extern struct pcicore_info *pcicore_init(struct si_pub *sih,
 					 struct pci_dev *pdev,
 					 void __iomem *regs);
 extern void pcicore_deinit(struct pcicore_info *pch);
-extern void pcicore_attach(struct pcicore_info *pch, char *pvars, int state);
+extern void pcicore_attach(struct pcicore_info *pch, int state);
 extern void pcicore_hwup(struct pcicore_info *pch);
 extern void pcicore_up(struct pcicore_info *pch, int state);
 extern void pcicore_sleep(struct pcicore_info *pch);
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
index dbeeeba..d84e1cf 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -4817,27 +4817,25 @@ static bool wlc_phy_txpwr_srom_read_lcnphy(struct brcms_phy *pi)
 	s8 txpwr = 0;
 	int i;
 	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	struct phy_shim_info *shim = pi->sh->physhim;
 
 	if (CHSPEC_IS2G(pi->radio_chanspec)) {
 		u16 cckpo = 0;
 		u32 offset_ofdm, offset_mcs;
 
 		pi_lcn->lcnphy_tr_isolation_mid =
-			(u8) wlapi_getintvar(pi->vars, "triso2g");
+			(u8)wlapi_getintvar(shim, "triso2g");
 
 		pi_lcn->lcnphy_rx_power_offset =
-			(u8) wlapi_getintvar(pi->vars, "rxpo2g");
+			(u8)wlapi_getintvar(shim, "rxpo2g");
 
-		pi->txpa_2g[0] = (s16) wlapi_getintvar(pi->vars, "pa0b0");
-		pi->txpa_2g[1] = (s16) wlapi_getintvar(pi->vars, "pa0b1");
-		pi->txpa_2g[2] = (s16) wlapi_getintvar(pi->vars, "pa0b2");
+		pi->txpa_2g[0] = (s16)wlapi_getintvar(shim, "pa0b0");
+		pi->txpa_2g[1] = (s16)wlapi_getintvar(shim, "pa0b1");
+		pi->txpa_2g[2] = (s16)wlapi_getintvar(shim, "pa0b2");
 
-		pi_lcn->lcnphy_rssi_vf =
-				(u8) wlapi_getintvar(pi->vars, "rssismf2g");
-		pi_lcn->lcnphy_rssi_vc =
-				(u8) wlapi_getintvar(pi->vars, "rssismc2g");
-		pi_lcn->lcnphy_rssi_gs =
-				(u8) wlapi_getintvar(pi->vars, "rssisav2g");
+		pi_lcn->lcnphy_rssi_vf = (u8)wlapi_getintvar(shim, "rssismf2g");
+		pi_lcn->lcnphy_rssi_vc = (u8)wlapi_getintvar(shim, "rssismc2g");
+		pi_lcn->lcnphy_rssi_gs = (u8)wlapi_getintvar(shim, "rssisav2g");
 
 		pi_lcn->lcnphy_rssi_vf_lowtemp = pi_lcn->lcnphy_rssi_vf;
 		pi_lcn->lcnphy_rssi_vc_lowtemp = pi_lcn->lcnphy_rssi_vc;
@@ -4847,7 +4845,7 @@ static bool wlc_phy_txpwr_srom_read_lcnphy(struct brcms_phy *pi)
 		pi_lcn->lcnphy_rssi_vc_hightemp = pi_lcn->lcnphy_rssi_vc;
 		pi_lcn->lcnphy_rssi_gs_hightemp = pi_lcn->lcnphy_rssi_gs;
 
-		txpwr = (s8) wlapi_getintvar(pi->vars, "maxp2ga0");
+		txpwr = (s8)wlapi_getintvar(shim, "maxp2ga0");
 		pi->tx_srom_max_2g = txpwr;
 
 		for (i = 0; i < PWRTBL_NUM_COEFF; i++) {
@@ -4855,7 +4853,7 @@ static bool wlc_phy_txpwr_srom_read_lcnphy(struct brcms_phy *pi)
 			pi->txpa_2g_high_temp[i] = pi->txpa_2g[i];
 		}
 
-		cckpo = (u16) wlapi_getintvar(pi->vars, "cck2gpo");
+		cckpo = (u16)wlapi_getintvar(shim, "cck2gpo");
 		if (cckpo) {
 			uint max_pwr_chan = txpwr;
 
@@ -4865,8 +4863,7 @@ static bool wlc_phy_txpwr_srom_read_lcnphy(struct brcms_phy *pi)
 				cckpo >>= 4;
 			}
 
-			offset_ofdm =
-				(u32) wlapi_getintvar(pi->vars, "ofdm2gpo");
+			offset_ofdm = (u32)wlapi_getintvar(shim, "ofdm2gpo");
 			for (i = TXP_FIRST_OFDM; i <= TXP_LAST_OFDM; i++) {
 				pi->tx_srom_max_rate_2g[i] =
 					max_pwr_chan -
@@ -4876,13 +4873,12 @@ static bool wlc_phy_txpwr_srom_read_lcnphy(struct brcms_phy *pi)
 		} else {
 			u8 opo = 0;
 
-			opo = (u8) wlapi_getintvar(pi->vars, "opo");
+			opo = (u8)wlapi_getintvar(shim, "opo");
 
 			for (i = TXP_FIRST_CCK; i <= TXP_LAST_CCK; i++)
 				pi->tx_srom_max_rate_2g[i] = txpwr;
 
-			offset_ofdm =
-				(u32) wlapi_getintvar(pi->vars, "ofdm2gpo");
+			offset_ofdm = (u32)wlapi_getintvar(shim, "ofdm2gpo");
 
 			for (i = TXP_FIRST_OFDM; i <= TXP_LAST_OFDM; i++) {
 				pi->tx_srom_max_rate_2g[i] = txpwr -
@@ -4890,9 +4886,9 @@ static bool wlc_phy_txpwr_srom_read_lcnphy(struct brcms_phy *pi)
 				offset_ofdm >>= 4;
 			}
 			offset_mcs =
-				wlapi_getintvar(pi->vars, "mcs2gpo1") << 16;
+				wlapi_getintvar(shim, "mcs2gpo1") << 16;
 			offset_mcs |=
-				(u16) wlapi_getintvar(pi->vars, "mcs2gpo0");
+				(u16) wlapi_getintvar(shim, "mcs2gpo0");
 			pi_lcn->lcnphy_mcs20_po = offset_mcs;
 			for (i = TXP_FIRST_SISO_MCS_20;
 			     i <= TXP_LAST_SISO_MCS_20; i++) {
@@ -4903,30 +4899,30 @@ static bool wlc_phy_txpwr_srom_read_lcnphy(struct brcms_phy *pi)
 		}
 
 		pi_lcn->lcnphy_rawtempsense =
-			(u16) wlapi_getintvar(pi->vars, "rawtempsense");
+			(u16)wlapi_getintvar(shim, "rawtempsense");
 		pi_lcn->lcnphy_measPower =
-			(u8) wlapi_getintvar(pi->vars, "measpower");
+			(u8)wlapi_getintvar(shim, "measpower");
 		pi_lcn->lcnphy_tempsense_slope =
-			(u8) wlapi_getintvar(pi->vars, "tempsense_slope");
+			(u8)wlapi_getintvar(shim, "tempsense_slope");
 		pi_lcn->lcnphy_hw_iqcal_en =
-			(bool) wlapi_getintvar(pi->vars, "hw_iqcal_en");
+			(bool)wlapi_getintvar(shim, "hw_iqcal_en");
 		pi_lcn->lcnphy_iqcal_swp_dis =
-			(bool) wlapi_getintvar(pi->vars, "iqcal_swp_dis");
+			(bool)wlapi_getintvar(shim, "iqcal_swp_dis");
 		pi_lcn->lcnphy_tempcorrx =
-			(u8) wlapi_getintvar(pi->vars, "tempcorrx");
+			(u8)wlapi_getintvar(shim, "tempcorrx");
 		pi_lcn->lcnphy_tempsense_option =
-			(u8) wlapi_getintvar(pi->vars, "tempsense_option");
+			(u8)wlapi_getintvar(shim, "tempsense_option");
 		pi_lcn->lcnphy_freqoffset_corr =
-			(u8) wlapi_getintvar(pi->vars, "freqoffset_corr");
-		if ((u8) getintvar(pi->vars, "aa2g") > 1)
+			(u8)wlapi_getintvar(shim, "freqoffset_corr");
+		if ((u8)wlapi_getintvar(shim, "aa2g") > 1)
 			wlc_phy_ant_rxdiv_set((struct brcms_phy_pub *) pi,
-					      (u8) getintvar(pi->vars,
-							     "aa2g"));
+					      (u8) wlapi_getintvar(shim,
+								   "aa2g"));
 	}
 	pi_lcn->lcnphy_cck_dig_filt_type = -1;
-	if (wlapi_getvar(pi->vars, "cckdigfilttype")) {
+	if (wlapi_getvar(shim, "cckdigfilttype")) {
 		s16 temp;
-		temp = (s16) wlapi_getintvar(pi->vars, "cckdigfilttype");
+		temp = (s16)wlapi_getintvar(shim, "cckdigfilttype");
 		if (temp >= 0)
 			pi_lcn->lcnphy_cck_dig_filt_type = temp;
 	}
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
index c410bf0..a4417e9 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
@@ -14383,29 +14383,30 @@ static void wlc_phy_txpwr_srom_read_ppr_nphy(struct brcms_phy *pi)
 {
 	u16 bw40po, cddpo, stbcpo, bwduppo;
 	uint band_num;
+	struct phy_shim_info *shim = pi->sh->physhim;
 
 	if (pi->sh->sromrev >= 9)
 		return;
 
-	bw40po = (u16) wlapi_getintvar(pi->vars, "bw40po");
+	bw40po = (u16) wlapi_getintvar(shim, "bw40po");
 	pi->bw402gpo = bw40po & 0xf;
 	pi->bw405gpo = (bw40po & 0xf0) >> 4;
 	pi->bw405glpo = (bw40po & 0xf00) >> 8;
 	pi->bw405ghpo = (bw40po & 0xf000) >> 12;
 
-	cddpo = (u16) wlapi_getintvar(pi->vars, "cddpo");
+	cddpo = (u16) wlapi_getintvar(shim, "cddpo");
 	pi->cdd2gpo = cddpo & 0xf;
 	pi->cdd5gpo = (cddpo & 0xf0) >> 4;
 	pi->cdd5glpo = (cddpo & 0xf00) >> 8;
 	pi->cdd5ghpo = (cddpo & 0xf000) >> 12;
 
-	stbcpo = (u16) wlapi_getintvar(pi->vars, "stbcpo");
+	stbcpo = (u16) wlapi_getintvar(shim, "stbcpo");
 	pi->stbc2gpo = stbcpo & 0xf;
 	pi->stbc5gpo = (stbcpo & 0xf0) >> 4;
 	pi->stbc5glpo = (stbcpo & 0xf00) >> 8;
 	pi->stbc5ghpo = (stbcpo & 0xf000) >> 12;
 
-	bwduppo = (u16) wlapi_getintvar(pi->vars, "bwduppo");
+	bwduppo = (u16) wlapi_getintvar(shim, "bwduppo");
 	pi->bwdup2gpo = bwduppo & 0xf;
 	pi->bwdup5gpo = (bwduppo & 0xf0) >> 4;
 	pi->bwdup5glpo = (bwduppo & 0xf00) >> 8;
@@ -14417,188 +14418,186 @@ static void wlc_phy_txpwr_srom_read_ppr_nphy(struct brcms_phy *pi)
 		case 0:
 
 			pi->nphy_txpid2g[PHY_CORE_0] =
-				(u8) wlapi_getintvar(pi->vars, "txpid2ga0");
+				(u8) wlapi_getintvar(shim, "txpid2ga0");
 			pi->nphy_txpid2g[PHY_CORE_1] =
-				(u8) wlapi_getintvar(pi->vars, "txpid2ga1");
+				(u8) wlapi_getintvar(shim, "txpid2ga1");
 			pi->nphy_pwrctrl_info[PHY_CORE_0].max_pwr_2g =
-				(s8) wlapi_getintvar(pi->vars, "maxp2ga0");
+				(s8) wlapi_getintvar(shim, "maxp2ga0");
 			pi->nphy_pwrctrl_info[PHY_CORE_1].max_pwr_2g =
-				(s8) wlapi_getintvar(pi->vars, "maxp2ga1");
+				(s8) wlapi_getintvar(shim, "maxp2ga1");
 			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_2g_a1 =
-				(s16) wlapi_getintvar(pi->vars, "pa2gw0a0");
+				(s16) wlapi_getintvar(shim, "pa2gw0a0");
 			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_2g_a1 =
-				(s16) wlapi_getintvar(pi->vars, "pa2gw0a1");
+				(s16) wlapi_getintvar(shim, "pa2gw0a1");
 			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_2g_b0 =
-				(s16) wlapi_getintvar(pi->vars, "pa2gw1a0");
+				(s16) wlapi_getintvar(shim, "pa2gw1a0");
 			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_2g_b0 =
-				(s16) wlapi_getintvar(pi->vars, "pa2gw1a1");
+				(s16) wlapi_getintvar(shim, "pa2gw1a1");
 			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_2g_b1 =
-				(s16) wlapi_getintvar(pi->vars, "pa2gw2a0");
+				(s16) wlapi_getintvar(shim, "pa2gw2a0");
 			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_2g_b1 =
-				(s16) wlapi_getintvar(pi->vars, "pa2gw2a1");
+				(s16) wlapi_getintvar(shim, "pa2gw2a1");
 			pi->nphy_pwrctrl_info[PHY_CORE_0].idle_targ_2g =
-				(s8) wlapi_getintvar(pi->vars, "itt2ga0");
+				(s8) wlapi_getintvar(shim, "itt2ga0");
 			pi->nphy_pwrctrl_info[PHY_CORE_1].idle_targ_2g =
-				(s8) wlapi_getintvar(pi->vars, "itt2ga1");
+				(s8) wlapi_getintvar(shim, "itt2ga1");
 
-			pi->cck2gpo =
-				(u16) wlapi_getintvar(pi->vars, "cck2gpo");
-			pi->ofdm2gpo =
-				(u32) wlapi_getintvar(pi->vars, "ofdm2gpo");
+			pi->cck2gpo = (u16) wlapi_getintvar(shim, "cck2gpo");
+
+			pi->ofdm2gpo = (u32) wlapi_getintvar(shim, "ofdm2gpo");
 
 			pi->mcs2gpo[0] =
-				(u16) wlapi_getintvar(pi->vars, "mcs2gpo0");
+				(u16) wlapi_getintvar(shim, "mcs2gpo0");
 			pi->mcs2gpo[1] =
-				(u16) wlapi_getintvar(pi->vars, "mcs2gpo1");
+				(u16) wlapi_getintvar(shim, "mcs2gpo1");
 			pi->mcs2gpo[2] =
-				(u16) wlapi_getintvar(pi->vars, "mcs2gpo2");
+				(u16) wlapi_getintvar(shim, "mcs2gpo2");
 			pi->mcs2gpo[3] =
-				(u16) wlapi_getintvar(pi->vars, "mcs2gpo3");
+				(u16) wlapi_getintvar(shim, "mcs2gpo3");
 			pi->mcs2gpo[4] =
-				(u16) wlapi_getintvar(pi->vars, "mcs2gpo4");
+				(u16) wlapi_getintvar(shim, "mcs2gpo4");
 			pi->mcs2gpo[5] =
-				(u16) wlapi_getintvar(pi->vars, "mcs2gpo5");
+				(u16) wlapi_getintvar(shim, "mcs2gpo5");
 			pi->mcs2gpo[6] =
-				(u16) wlapi_getintvar(pi->vars, "mcs2gpo6");
+				(u16) wlapi_getintvar(shim, "mcs2gpo6");
 			pi->mcs2gpo[7] =
-				(u16) wlapi_getintvar(pi->vars, "mcs2gpo7");
+				(u16) wlapi_getintvar(shim, "mcs2gpo7");
 			break;
 		case 1:
 
 			pi->nphy_txpid5g[PHY_CORE_0] =
-				(u8) wlapi_getintvar(pi->vars, "txpid5ga0");
+				(u8) wlapi_getintvar(shim, "txpid5ga0");
 			pi->nphy_txpid5g[PHY_CORE_1] =
-				(u8) wlapi_getintvar(pi->vars, "txpid5ga1");
+				(u8) wlapi_getintvar(shim, "txpid5ga1");
 			pi->nphy_pwrctrl_info[PHY_CORE_0].max_pwr_5gm =
-				(s8) wlapi_getintvar(pi->vars, "maxp5ga0");
+				(s8) wlapi_getintvar(shim, "maxp5ga0");
 			pi->nphy_pwrctrl_info[PHY_CORE_1].max_pwr_5gm =
-				(s8) wlapi_getintvar(pi->vars, "maxp5ga1");
+				(s8) wlapi_getintvar(shim, "maxp5ga1");
 			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_5gm_a1 =
-				(s16) wlapi_getintvar(pi->vars, "pa5gw0a0");
+				(s16) wlapi_getintvar(shim, "pa5gw0a0");
 			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_5gm_a1 =
-				(s16) wlapi_getintvar(pi->vars, "pa5gw0a1");
+				(s16) wlapi_getintvar(shim, "pa5gw0a1");
 			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_5gm_b0 =
-				(s16) wlapi_getintvar(pi->vars, "pa5gw1a0");
+				(s16) wlapi_getintvar(shim, "pa5gw1a0");
 			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_5gm_b0 =
-				(s16) wlapi_getintvar(pi->vars, "pa5gw1a1");
+				(s16) wlapi_getintvar(shim, "pa5gw1a1");
 			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_5gm_b1 =
-				(s16) wlapi_getintvar(pi->vars, "pa5gw2a0");
+				(s16) wlapi_getintvar(shim, "pa5gw2a0");
 			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_5gm_b1 =
-				(s16) wlapi_getintvar(pi->vars, "pa5gw2a1");
+				(s16) wlapi_getintvar(shim, "pa5gw2a1");
 			pi->nphy_pwrctrl_info[PHY_CORE_0].idle_targ_5gm =
-				(s8) wlapi_getintvar(pi->vars, "itt5ga0");
+				(s8) wlapi_getintvar(shim, "itt5ga0");
 			pi->nphy_pwrctrl_info[PHY_CORE_1].idle_targ_5gm =
-				(s8) wlapi_getintvar(pi->vars, "itt5ga1");
+				(s8) wlapi_getintvar(shim, "itt5ga1");
 
-			pi->ofdm5gpo =
-				(u32) wlapi_getintvar(pi->vars, "ofdm5gpo");
+			pi->ofdm5gpo = (u32) wlapi_getintvar(shim, "ofdm5gpo");
 
 			pi->mcs5gpo[0] =
-				(u16) wlapi_getintvar(pi->vars, "mcs5gpo0");
+				(u16) wlapi_getintvar(shim, "mcs5gpo0");
 			pi->mcs5gpo[1] =
-				(u16) wlapi_getintvar(pi->vars, "mcs5gpo1");
+				(u16) wlapi_getintvar(shim, "mcs5gpo1");
 			pi->mcs5gpo[2] =
-				(u16) wlapi_getintvar(pi->vars, "mcs5gpo2");
+				(u16) wlapi_getintvar(shim, "mcs5gpo2");
 			pi->mcs5gpo[3] =
-				(u16) wlapi_getintvar(pi->vars, "mcs5gpo3");
+				(u16) wlapi_getintvar(shim, "mcs5gpo3");
 			pi->mcs5gpo[4] =
-				(u16) wlapi_getintvar(pi->vars, "mcs5gpo4");
+				(u16) wlapi_getintvar(shim, "mcs5gpo4");
 			pi->mcs5gpo[5] =
-				(u16) wlapi_getintvar(pi->vars, "mcs5gpo5");
+				(u16) wlapi_getintvar(shim, "mcs5gpo5");
 			pi->mcs5gpo[6] =
-				(u16) wlapi_getintvar(pi->vars, "mcs5gpo6");
+				(u16) wlapi_getintvar(shim, "mcs5gpo6");
 			pi->mcs5gpo[7] =
-				(u16) wlapi_getintvar(pi->vars, "mcs5gpo7");
+				(u16) wlapi_getintvar(shim, "mcs5gpo7");
 			break;
 		case 2:
 
 			pi->nphy_txpid5gl[0] =
-				(u8) wlapi_getintvar(pi->vars, "txpid5gla0");
+				(u8) wlapi_getintvar(shim, "txpid5gla0");
 			pi->nphy_txpid5gl[1] =
-				(u8) wlapi_getintvar(pi->vars, "txpid5gla1");
+				(u8) wlapi_getintvar(shim, "txpid5gla1");
 			pi->nphy_pwrctrl_info[0].max_pwr_5gl =
-				(s8) wlapi_getintvar(pi->vars, "maxp5gla0");
+				(s8) wlapi_getintvar(shim, "maxp5gla0");
 			pi->nphy_pwrctrl_info[1].max_pwr_5gl =
-				(s8) wlapi_getintvar(pi->vars, "maxp5gla1");
+				(s8) wlapi_getintvar(shim, "maxp5gla1");
 			pi->nphy_pwrctrl_info[0].pwrdet_5gl_a1 =
-				(s16) wlapi_getintvar(pi->vars, "pa5glw0a0");
+				(s16) wlapi_getintvar(shim, "pa5glw0a0");
 			pi->nphy_pwrctrl_info[1].pwrdet_5gl_a1 =
-				(s16) wlapi_getintvar(pi->vars, "pa5glw0a1");
+				(s16) wlapi_getintvar(shim, "pa5glw0a1");
 			pi->nphy_pwrctrl_info[0].pwrdet_5gl_b0 =
-				(s16) wlapi_getintvar(pi->vars, "pa5glw1a0");
+				(s16) wlapi_getintvar(shim, "pa5glw1a0");
 			pi->nphy_pwrctrl_info[1].pwrdet_5gl_b0 =
-				(s16) wlapi_getintvar(pi->vars, "pa5glw1a1");
+				(s16) wlapi_getintvar(shim, "pa5glw1a1");
 			pi->nphy_pwrctrl_info[0].pwrdet_5gl_b1 =
-				(s16) wlapi_getintvar(pi->vars, "pa5glw2a0");
+				(s16) wlapi_getintvar(shim, "pa5glw2a0");
 			pi->nphy_pwrctrl_info[1].pwrdet_5gl_b1 =
-				(s16) wlapi_getintvar(pi->vars, "pa5glw2a1");
+				(s16) wlapi_getintvar(shim, "pa5glw2a1");
 			pi->nphy_pwrctrl_info[0].idle_targ_5gl = 0;
 			pi->nphy_pwrctrl_info[1].idle_targ_5gl = 0;
 
 			pi->ofdm5glpo =
-				(u32) wlapi_getintvar(pi->vars, "ofdm5glpo");
+				(u32) wlapi_getintvar(shim, "ofdm5glpo");
 
 			pi->mcs5glpo[0] =
-				(u16) wlapi_getintvar(pi->vars, "mcs5glpo0");
+				(u16) wlapi_getintvar(shim, "mcs5glpo0");
 			pi->mcs5glpo[1] =
-				(u16) wlapi_getintvar(pi->vars, "mcs5glpo1");
+				(u16) wlapi_getintvar(shim, "mcs5glpo1");
 			pi->mcs5glpo[2] =
-				(u16) wlapi_getintvar(pi->vars, "mcs5glpo2");
+				(u16) wlapi_getintvar(shim, "mcs5glpo2");
 			pi->mcs5glpo[3] =
-				(u16) wlapi_getintvar(pi->vars, "mcs5glpo3");
+				(u16) wlapi_getintvar(shim, "mcs5glpo3");
 			pi->mcs5glpo[4] =
-				(u16) wlapi_getintvar(pi->vars, "mcs5glpo4");
+				(u16) wlapi_getintvar(shim, "mcs5glpo4");
 			pi->mcs5glpo[5] =
-				(u16) wlapi_getintvar(pi->vars, "mcs5glpo5");
+				(u16) wlapi_getintvar(shim, "mcs5glpo5");
 			pi->mcs5glpo[6] =
-				(u16) wlapi_getintvar(pi->vars, "mcs5glpo6");
+				(u16) wlapi_getintvar(shim, "mcs5glpo6");
 			pi->mcs5glpo[7] =
-				(u16) wlapi_getintvar(pi->vars, "mcs5glpo7");
+				(u16) wlapi_getintvar(shim, "mcs5glpo7");
 			break;
 		case 3:
 
 			pi->nphy_txpid5gh[0] =
-				(u8) wlapi_getintvar(pi->vars, "txpid5gha0");
+				(u8) wlapi_getintvar(shim, "txpid5gha0");
 			pi->nphy_txpid5gh[1] =
-				(u8) wlapi_getintvar(pi->vars, "txpid5gha1");
+				(u8) wlapi_getintvar(shim, "txpid5gha1");
 			pi->nphy_pwrctrl_info[0].max_pwr_5gh =
-				(s8) wlapi_getintvar(pi->vars, "maxp5gha0");
+				(s8) wlapi_getintvar(shim, "maxp5gha0");
 			pi->nphy_pwrctrl_info[1].max_pwr_5gh =
-				(s8) wlapi_getintvar(pi->vars, "maxp5gha1");
+				(s8) wlapi_getintvar(shim, "maxp5gha1");
 			pi->nphy_pwrctrl_info[0].pwrdet_5gh_a1 =
-				(s16) wlapi_getintvar(pi->vars, "pa5ghw0a0");
+				(s16) wlapi_getintvar(shim, "pa5ghw0a0");
 			pi->nphy_pwrctrl_info[1].pwrdet_5gh_a1 =
-				(s16) wlapi_getintvar(pi->vars, "pa5ghw0a1");
+				(s16) wlapi_getintvar(shim, "pa5ghw0a1");
 			pi->nphy_pwrctrl_info[0].pwrdet_5gh_b0 =
-				(s16) wlapi_getintvar(pi->vars, "pa5ghw1a0");
+				(s16) wlapi_getintvar(shim, "pa5ghw1a0");
 			pi->nphy_pwrctrl_info[1].pwrdet_5gh_b0 =
-				(s16) wlapi_getintvar(pi->vars, "pa5ghw1a1");
+				(s16) wlapi_getintvar(shim, "pa5ghw1a1");
 			pi->nphy_pwrctrl_info[0].pwrdet_5gh_b1 =
-				(s16) wlapi_getintvar(pi->vars, "pa5ghw2a0");
+				(s16) wlapi_getintvar(shim, "pa5ghw2a0");
 			pi->nphy_pwrctrl_info[1].pwrdet_5gh_b1 =
-				(s16) wlapi_getintvar(pi->vars, "pa5ghw2a1");
+				(s16) wlapi_getintvar(shim, "pa5ghw2a1");
 			pi->nphy_pwrctrl_info[0].idle_targ_5gh = 0;
 			pi->nphy_pwrctrl_info[1].idle_targ_5gh = 0;
 
 			pi->ofdm5ghpo =
-				(u32) wlapi_getintvar(pi->vars, "ofdm5ghpo");
+				(u32) wlapi_getintvar(shim, "ofdm5ghpo");
 
 			pi->mcs5ghpo[0] =
-				(u16) wlapi_getintvar(pi->vars, "mcs5ghpo0");
+				(u16) wlapi_getintvar(shim, "mcs5ghpo0");
 			pi->mcs5ghpo[1] =
-				(u16) wlapi_getintvar(pi->vars, "mcs5ghpo1");
+				(u16) wlapi_getintvar(shim, "mcs5ghpo1");
 			pi->mcs5ghpo[2] =
-				(u16) wlapi_getintvar(pi->vars, "mcs5ghpo2");
+				(u16) wlapi_getintvar(shim, "mcs5ghpo2");
 			pi->mcs5ghpo[3] =
-				(u16) wlapi_getintvar(pi->vars, "mcs5ghpo3");
+				(u16) wlapi_getintvar(shim, "mcs5ghpo3");
 			pi->mcs5ghpo[4] =
-				(u16) wlapi_getintvar(pi->vars, "mcs5ghpo4");
+				(u16) wlapi_getintvar(shim, "mcs5ghpo4");
 			pi->mcs5ghpo[5] =
-				(u16) wlapi_getintvar(pi->vars, "mcs5ghpo5");
+				(u16) wlapi_getintvar(shim, "mcs5ghpo5");
 			pi->mcs5ghpo[6] =
-				(u16) wlapi_getintvar(pi->vars, "mcs5ghpo6");
+				(u16) wlapi_getintvar(shim, "mcs5ghpo6");
 			pi->mcs5ghpo[7] =
-				(u16) wlapi_getintvar(pi->vars, "mcs5ghpo7");
+				(u16) wlapi_getintvar(shim, "mcs5ghpo7");
 			break;
 		}
 	}
@@ -14608,41 +14607,37 @@ static void wlc_phy_txpwr_srom_read_ppr_nphy(struct brcms_phy *pi)
 
 static bool wlc_phy_txpwr_srom_read_nphy(struct brcms_phy *pi)
 {
-
-	pi->antswitch = (u8) wlapi_getintvar(pi->vars, "antswitch");
-	pi->aa2g = (u8) wlapi_getintvar(pi->vars, "aa2g");
-	pi->aa5g = (u8) wlapi_getintvar(pi->vars, "aa5g");
-
-	pi->srom_fem2g.tssipos = (u8) wlapi_getintvar(pi->vars, "tssipos2g");
-	pi->srom_fem2g.extpagain =
-			(u8) wlapi_getintvar(pi->vars, "extpagain2g");
-	pi->srom_fem2g.pdetrange =
-			(u8) wlapi_getintvar(pi->vars, "pdetrange2g");
-	pi->srom_fem2g.triso = (u8) wlapi_getintvar(pi->vars, "triso2g");
-	pi->srom_fem2g.antswctrllut =
-			(u8) wlapi_getintvar(pi->vars, "antswctl2g");
-
-	pi->srom_fem5g.tssipos = (u8) wlapi_getintvar(pi->vars, "tssipos5g");
-	pi->srom_fem5g.extpagain =
-			(u8) wlapi_getintvar(pi->vars, "extpagain5g");
-	pi->srom_fem5g.pdetrange =
-			(u8) wlapi_getintvar(pi->vars, "pdetrange5g");
-	pi->srom_fem5g.triso = (u8) wlapi_getintvar(pi->vars, "triso5g");
-	if (wlapi_getvar(pi->vars, "antswctl5g"))
+	struct phy_shim_info *shim = pi->sh->physhim;
+
+	pi->antswitch = (u8) wlapi_getintvar(shim, "antswitch");
+	pi->aa2g = (u8) wlapi_getintvar(shim, "aa2g");
+	pi->aa5g = (u8) wlapi_getintvar(shim, "aa5g");
+
+	pi->srom_fem2g.tssipos = (u8) wlapi_getintvar(shim, "tssipos2g");
+	pi->srom_fem2g.extpagain = (u8) wlapi_getintvar(shim, "extpagain2g");
+	pi->srom_fem2g.pdetrange = (u8) wlapi_getintvar(shim, "pdetrange2g");
+	pi->srom_fem2g.triso = (u8) wlapi_getintvar(shim, "triso2g");
+	pi->srom_fem2g.antswctrllut = (u8) wlapi_getintvar(shim, "antswctl2g");
+
+	pi->srom_fem5g.tssipos = (u8) wlapi_getintvar(shim, "tssipos5g");
+	pi->srom_fem5g.extpagain = (u8) wlapi_getintvar(shim, "extpagain5g");
+	pi->srom_fem5g.pdetrange = (u8) wlapi_getintvar(shim, "pdetrange5g");
+	pi->srom_fem5g.triso = (u8) wlapi_getintvar(shim, "triso5g");
+	if (wlapi_getvar(shim, "antswctl5g"))
 		pi->srom_fem5g.antswctrllut =
-			(u8) wlapi_getintvar(pi->vars, "antswctl5g");
+			(u8) wlapi_getintvar(shim, "antswctl5g");
 	else
 		pi->srom_fem5g.antswctrllut =
-			(u8) wlapi_getintvar(pi->vars, "antswctl2g");
+			(u8) wlapi_getintvar(shim, "antswctl2g");
 
 	wlc_phy_txpower_ipa_upd(pi);
 
 	pi->phy_txcore_disable_temp =
-			(s16) wlapi_getintvar(pi->vars, "tempthresh");
+			(s16) wlapi_getintvar(shim, "tempthresh");
 	if (pi->phy_txcore_disable_temp == 0)
 		pi->phy_txcore_disable_temp = PHY_CHAIN_TX_DISABLE_TEMP;
 
-	pi->phy_tempsense_offset = (s8) wlapi_getintvar(pi->vars, "tempoffset");
+	pi->phy_tempsense_offset = (s8) wlapi_getintvar(shim, "tempoffset");
 	if (pi->phy_tempsense_offset != 0) {
 		if (pi->phy_tempsense_offset >
 		    (NPHY_SROM_TEMPSHIFT + NPHY_SROM_MAXTEMPOFFSET))
@@ -14658,7 +14653,7 @@ static bool wlc_phy_txpwr_srom_read_nphy(struct brcms_phy *pi)
 		pi->phy_txcore_disable_temp - PHY_HYSTERESIS_DELTATEMP;
 
 	pi->phycal_tempdelta =
-			(u8) wlapi_getintvar(pi->vars, "phycal_tempdelta");
+			(u8) wlapi_getintvar(shim, "phycal_tempdelta");
 	if (pi->phycal_tempdelta > NPHY_CAL_MAXTEMPDELTA)
 		pi->phycal_tempdelta = 0;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy_shim.c b/drivers/staging/brcm80211/brcmsmac/phy_shim.c
index 0be07ed..57122fc 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy_shim.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy_shim.c
@@ -216,11 +216,11 @@ wlapi_copyto_objmem(struct phy_shim_info *physhim, uint offset, const void *buf,
 	brcms_b_copyto_objmem(physhim->wlc_hw, offset, buf, l, sel);
 }
 
-char *wlapi_getvar(char *vars, const char *name)
+char *wlapi_getvar(struct phy_shim_info *physhim, const char *name)
 {
-	return getvar(vars, name);
+	return getvar(physhim->wlc_hw->sih, name);
 }
-int wlapi_getintvar(char *vars, const char *name)
+int wlapi_getintvar(struct phy_shim_info *physhim, const char *name)
 {
-	return getintvar(vars, name);
+	return getintvar(physhim->wlc_hw->sih, name);
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/phy_shim.h b/drivers/staging/brcm80211/brcmsmac/phy_shim.h
index 35fe993..ca76153 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy_shim.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy_shim.h
@@ -178,7 +178,7 @@ extern void wlapi_copyto_objmem(struct phy_shim_info *physhim, uint,
 extern void wlapi_high_update_phy_mode(struct phy_shim_info *physhim,
 				       u32 phy_mode);
 extern u16 wlapi_bmac_get_txant(struct phy_shim_info *physhim);
-extern char *wlapi_getvar(char *vars, const char *name);
-extern int wlapi_getintvar(char *vars, const char *name);
+extern char *wlapi_getvar(struct phy_shim_info *physhim, const char *name);
+extern int wlapi_getintvar(struct phy_shim_info *physhim, const char *name);
 
 #endif				/* _BRCM_PHY_SHIM_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
index b69833e..d1639b4 100644
--- a/drivers/staging/brcm80211/brcmsmac/pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -356,8 +356,8 @@ extern void brcms_c_ampdu_flush(struct brcms_c_info *wlc,
 			    struct ieee80211_sta *sta, u16 tid);
 extern void brcms_c_ampdu_tx_operational(struct brcms_c_info *wlc, u8 tid,
 					 u8 ba_wsize, uint max_rx_ampdu_bytes);
-extern char *getvar(char *vars, const char *name);
-extern int getintvar(char *vars, const char *name);
+extern char *getvar(struct si_pub *sih, const char *name);
+extern int getintvar(struct si_pub *sih, const char *name);
 
 /* wlc_phy.c helper functions */
 extern void brcms_c_set_ps_ctrl(struct brcms_c_info *wlc);
diff --git a/drivers/staging/brcm80211/brcmsmac/srom.c b/drivers/staging/brcm80211/brcmsmac/srom.c
index 02dbd98..524f1cc 100644
--- a/drivers/staging/brcm80211/brcmsmac/srom.c
+++ b/drivers/staging/brcm80211/brcmsmac/srom.c
@@ -1247,10 +1247,13 @@ int srom_var_init(struct si_pub *sih, void __iomem *curmap, char **vars,
  * Search the name=value vars for a specific one and return its value.
  * Returns NULL if not found.
  */
-char *getvar(char *vars, const char *name)
+char *getvar(struct si_pub *sih, const char *name)
 {
 	char *s;
 	int len;
+	struct si_info *sii;
+
+	sii = (struct si_info *)sih;
 
 	if (!name)
 		return NULL;
@@ -1260,7 +1263,7 @@ char *getvar(char *vars, const char *name)
 		return NULL;
 
 	/* first look in vars[] */
-	for (s = vars; s && *s;) {
+	for (s = sii->vars; s && *s;) {
 		if ((memcmp(s, name, len) == 0) && (s[len] == '='))
 			return &s[len + 1];
 
@@ -1275,12 +1278,12 @@ char *getvar(char *vars, const char *name)
  * Search the vars for a specific one and return its value as
  * an integer. Returns 0 if not found.
  */
-int getintvar(char *vars, const char *name)
+int getintvar(struct si_pub *sih, const char *name)
 {
 	char *val;
 	unsigned long res;
 
-	val = getvar(vars, name);
+	val = getvar(sih, name);
 	if (val && !kstrtoul(val, 0, &res))
 		return res;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/stf.c b/drivers/staging/brcm80211/brcmsmac/stf.c
index 9460cd1..3ce9049 100644
--- a/drivers/staging/brcm80211/brcmsmac/stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/stf.c
@@ -373,8 +373,8 @@ void brcms_c_stf_phy_txant_upd(struct brcms_c_info *wlc)
 void brcms_c_stf_phy_chain_calc(struct brcms_c_info *wlc)
 {
 	/* get available rx/tx chains */
-	wlc->stf->hw_txchain = (u8) getintvar(wlc->pub->vars, "txchain");
-	wlc->stf->hw_rxchain = (u8) getintvar(wlc->pub->vars, "rxchain");
+	wlc->stf->hw_txchain = (u8) getintvar(wlc->hw->sih, "txchain");
+	wlc->stf->hw_rxchain = (u8) getintvar(wlc->hw->sih, "rxchain");
 
 	/* these parameter are intended to be used for all PHY types */
 	if (wlc->stf->hw_txchain == 0 || wlc->stf->hw_txchain == 0xf) {
-- 
1.7.4.1


