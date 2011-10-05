Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3161 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934716Ab1JENUl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 09:20:41 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 09/15] staging: brcm80211: use identifiers instead of
 string for srom lookup
Date: Wed, 5 Oct 2011 15:20:08 +0200
Message-ID: <1317820814-7083-10-git-send-email-arend@broadcom.com> (sfid-20111005_152053_838997_8B6CFF39)
In-Reply-To: <1317820814-7083-1-git-send-email-arend@broadcom.com>
References: <1317820814-7083-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver variables from srom are stored in memory with string
identifiers and the caller needed to use this string identifier
to retrieve a driver variable. The commit changes the calling
code replacing strings with enumerated identifiers.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/aiutils.c     |    4 +-
 drivers/staging/brcm80211/brcmsmac/antsel.c      |   14 +-
 drivers/staging/brcm80211/brcmsmac/channel.c     |    2 +-
 drivers/staging/brcm80211/brcmsmac/main.c        |   35 ++-
 drivers/staging/brcm80211/brcmsmac/nicpci.c      |    3 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c |   56 ++--
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c   |  296 ++++++++++++++--------
 drivers/staging/brcm80211/brcmsmac/phy_shim.c    |    8 +-
 drivers/staging/brcm80211/brcmsmac/phy_shim.h    |    5 +-
 drivers/staging/brcm80211/brcmsmac/pub.h         |  262 +++++++++++++++++++-
 drivers/staging/brcm80211/brcmsmac/srom.c        |  284 ++++++++++++++++++++-
 drivers/staging/brcm80211/brcmsmac/stf.c         |    4 +-
 12 files changed, 802 insertions(+), 171 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index 2bc4bb3..6086c26 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -1021,7 +1021,7 @@ static __used void ai_nvram_process(struct si_info *sii)
 
 	sii->pub.boardvendor = w & 0xffff;
 	sii->pub.boardtype = (w >> 16) & 0xffff;
-	sii->pub.boardflags = getintvar(&sii->pub, "boardflags");
+	sii->pub.boardflags = getintvar(&sii->pub, BRCMS_SROM_BOARDFLAGS);
 }
 
 static struct si_info *ai_doattach(struct si_info *sii,
@@ -1117,7 +1117,7 @@ static struct si_info *ai_doattach(struct si_info *sii,
 	}
 
 	/* setup the GPIO based LED powersave register */
-	w = getintvar(sih, "leddc");
+	w = getintvar(sih, BRCMS_SROM_LEDDC);
 	if (w == 0)
 		w = DEFAULT_GPIOTIMERVAL;
 	ai_corereg(sih, SI_CC_IDX, offsetof(struct chipcregs, gpiotimerval),
diff --git a/drivers/staging/brcm80211/brcmsmac/antsel.c b/drivers/staging/brcm80211/brcmsmac/antsel.c
index eedcdb6..edc4016 100644
--- a/drivers/staging/brcm80211/brcmsmac/antsel.c
+++ b/drivers/staging/brcm80211/brcmsmac/antsel.c
@@ -118,7 +118,7 @@ struct antsel_info *brcms_c_antsel_attach(struct brcms_c_info *wlc)
 	asi->pub = wlc->pub;
 	asi->antsel_type = ANTSEL_NA;
 	asi->antsel_avail = false;
-	asi->antsel_antswitch = (u8) getintvar(sih, "antswitch");
+	asi->antsel_antswitch = (u8) getintvar(sih, BRCMS_SROM_ANTSWITCH);
 
 	if ((asi->pub->sromrev >= 4) && (asi->antsel_antswitch != 0)) {
 		switch (asi->antsel_antswitch) {
@@ -128,12 +128,12 @@ struct antsel_info *brcms_c_antsel_attach(struct brcms_c_info *wlc)
 			/* 4321/2 board with 2x3 switch logic */
 			asi->antsel_type = ANTSEL_2x3;
 			/* Antenna selection availability */
-			if (((u16) getintvar(sih, "aa2g") == 7) ||
-			    ((u16) getintvar(sih, "aa5g") == 7)) {
+			if (((u16) getintvar(sih, BRCMS_SROM_AA2G) == 7) ||
+			    ((u16) getintvar(sih, BRCMS_SROM_AA5G) == 7)) {
 				asi->antsel_avail = true;
 			} else if (
-				(u16) getintvar(sih, "aa2g") == 3 ||
-				(u16) getintvar(sih, "aa5g") == 3) {
+				(u16) getintvar(sih, BRCMS_SROM_AA2G) == 3 ||
+				(u16) getintvar(sih, BRCMS_SROM_AA5G) == 3) {
 				asi->antsel_avail = false;
 			} else {
 				asi->antsel_avail = false;
@@ -146,8 +146,8 @@ struct antsel_info *brcms_c_antsel_attach(struct brcms_c_info *wlc)
 			break;
 		}
 	} else if ((asi->pub->sromrev == 4) &&
-		   ((u16) getintvar(sih, "aa2g") == 7) &&
-		   ((u16) getintvar(sih, "aa5g") == 0)) {
+		   ((u16) getintvar(sih, BRCMS_SROM_AA2G) == 7) &&
+		   ((u16) getintvar(sih, BRCMS_SROM_AA5G) == 0)) {
 		/* hack to match old 4321CB2 cards with 2of3 antenna switch */
 		asi->antsel_type = ANTSEL_2x3;
 		asi->antsel_avail = true;
diff --git a/drivers/staging/brcm80211/brcmsmac/channel.c b/drivers/staging/brcm80211/brcmsmac/channel.c
index 53066fb..a1b415d 100644
--- a/drivers/staging/brcm80211/brcmsmac/channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/channel.c
@@ -1088,7 +1088,7 @@ struct brcms_cm_info *brcms_c_channel_mgr_attach(struct brcms_c_info *wlc)
 	wlc->cmi = wlc_cm;
 
 	/* store the country code for passing up as a regulatory hint */
-	ccode = getvar(wlc->hw->sih, "ccode");
+	ccode = getvar(wlc->hw->sih, BRCMS_SROM_CCODE);
 	if (ccode)
 		strncpy(wlc->pub->srom_ccode, ccode, BRCM_CNTRY_BUF_SZ - 1);
 
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index cfa918d..5ec25e8 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -1986,23 +1986,23 @@ static bool brcms_c_validboardtype(struct brcms_hardware *wlc_hw)
 
 static char *brcms_c_get_macaddr(struct brcms_hardware *wlc_hw)
 {
-	const char *varname = "macaddr";
+	enum brcms_srom_id var_id = BRCMS_SROM_MACADDR;
 	char *macaddr;
 
 	/* If macaddr exists, use it (Sromrev4, CIS, ...). */
-	macaddr = getvar(wlc_hw->sih, varname);
+	macaddr = getvar(wlc_hw->sih, var_id);
 	if (macaddr != NULL)
 		return macaddr;
 
 	if (wlc_hw->_nbands > 1)
-		varname = "et1macaddr";
+		var_id = BRCMS_SROM_ET1MACADDR;
 	else
-		varname = "il0macaddr";
+		var_id = BRCMS_SROM_IL0MACADDR;
 
-	macaddr = getvar(wlc_hw->sih, varname);
+	macaddr = getvar(wlc_hw->sih, var_id);
 	if (macaddr == NULL)
 		wiphy_err(wlc_hw->wlc->wiphy, "wl%d: wlc_get_macaddr: macaddr "
-			  "getvar(%s) not found\n", wlc_hw->unit, varname);
+			  "getvar(%d) not found\n", wlc_hw->unit, var_id);
 
 	return macaddr;
 }
@@ -4633,7 +4633,7 @@ static int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device,
 	}
 
 	/* get the board rev, used just below */
-	j = getintvar(wlc_hw->sih, "boardrev");
+	j = getintvar(wlc_hw->sih, BRCMS_SROM_BOARDREV);
 	/* promote srom boardrev of 0xFF to 1 */
 	if (j == BOARDREV_PROMOTABLE)
 		j = BOARDREV_PROMOTED;
@@ -4645,9 +4645,11 @@ static int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device,
 		err = 15;
 		goto fail;
 	}
-	wlc_hw->sromrev = (u8) getintvar(wlc_hw->sih, "sromrev");
-	wlc_hw->boardflags = (u32) getintvar(wlc_hw->sih, "boardflags");
-	wlc_hw->boardflags2 = (u32) getintvar(wlc_hw->sih, "boardflags2");
+	wlc_hw->sromrev = (u8) getintvar(wlc_hw->sih, BRCMS_SROM_REV);
+	wlc_hw->boardflags = (u32) getintvar(wlc_hw->sih,
+					     BRCMS_SROM_BOARDFLAGS);
+	wlc_hw->boardflags2 = (u32) getintvar(wlc_hw->sih,
+					      BRCMS_SROM_BOARDFLAGS2);
 
 	if (wlc_hw->boardflags & BFL_NOPLLDOWN)
 		brcms_b_pllreq(wlc_hw, true, BRCMS_PLLREQ_SHARED);
@@ -4904,7 +4906,11 @@ static bool brcms_c_attach_stf_ant_init(struct brcms_c_info *wlc)
 	bandtype = wlc->band->bandtype;
 
 	/* get antennas available */
-	aa = (s8) getintvar(sih, bandtype == BRCM_BAND_5G ? "aa5g" : "aa2g");
+	if (bandtype == BRCM_BAND_5G)
+		aa = (s8) getintvar(sih, BRCMS_SROM_AA5G);
+	else
+		aa = (s8) getintvar(sih, BRCMS_SROM_AA2G);
+
 	if ((aa < 1) || (aa > 15)) {
 		wiphy_err(wlc->wiphy, "wl%d: %s: Invalid antennas available in"
 			  " srom (0x%x), using 3\n", unit, __func__, aa);
@@ -4922,8 +4928,11 @@ static bool brcms_c_attach_stf_ant_init(struct brcms_c_info *wlc)
 	}
 
 	/* Compute Antenna Gain */
-	wlc->band->antgain = (s8) getintvar(sih, bandtype == BRCM_BAND_5G ?
-					    "ag1" : "ag0");
+	if (bandtype == BRCM_BAND_5G)
+		wlc->band->antgain = (s8) getintvar(sih, BRCMS_SROM_AG1);
+	else
+		wlc->band->antgain = (s8) getintvar(sih, BRCMS_SROM_AG0);
+
 	brcms_c_attach_antgain_init(wlc);
 
 	return true;
diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.c b/drivers/staging/brcm80211/brcmsmac/nicpci.c
index 57721a0..0bcb267 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.c
@@ -722,10 +722,11 @@ static void pcie_war_pci_setup(struct pcicore_info *pi)
 void pcicore_attach(struct pcicore_info *pi, int state)
 {
 	struct si_pub *sih = pi->sih;
+	u32 bfl2 = (u32)getintvar(sih, BRCMS_SROM_BOARDFLAGS2);
 
 	/* Determine if this board needs override */
 	if (PCIE_ASPM(sih)) {
-		if ((u32)getintvar(sih, "boardflags2") & BFL2_PCIEWAR_OVR)
+		if (bfl2 & BFL2_PCIEWAR_OVR)
 			pi->pcie_war_aspm_ovr = PCIE_ASPM_DISAB;
 		else
 			pi->pcie_war_aspm_ovr = PCIE_ASPM_ENAB;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
index 4bcf305..a63aa99 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -4824,18 +4824,21 @@ static bool wlc_phy_txpwr_srom_read_lcnphy(struct brcms_phy *pi)
 		u32 offset_ofdm, offset_mcs;
 
 		pi_lcn->lcnphy_tr_isolation_mid =
-			(u8)wlapi_getintvar(shim, "triso2g");
+			(u8)wlapi_getintvar(shim, BRCMS_SROM_TRISO2G);
 
 		pi_lcn->lcnphy_rx_power_offset =
-			(u8)wlapi_getintvar(shim, "rxpo2g");
+			(u8)wlapi_getintvar(shim, BRCMS_SROM_RXPO2G);
 
-		pi->txpa_2g[0] = (s16)wlapi_getintvar(shim, "pa0b0");
-		pi->txpa_2g[1] = (s16)wlapi_getintvar(shim, "pa0b1");
-		pi->txpa_2g[2] = (s16)wlapi_getintvar(shim, "pa0b2");
+		pi->txpa_2g[0] = (s16)wlapi_getintvar(shim, BRCMS_SROM_PA0B0);
+		pi->txpa_2g[1] = (s16)wlapi_getintvar(shim, BRCMS_SROM_PA0B1);
+		pi->txpa_2g[2] = (s16)wlapi_getintvar(shim, BRCMS_SROM_PA0B2);
 
-		pi_lcn->lcnphy_rssi_vf = (u8)wlapi_getintvar(shim, "rssismf2g");
-		pi_lcn->lcnphy_rssi_vc = (u8)wlapi_getintvar(shim, "rssismc2g");
-		pi_lcn->lcnphy_rssi_gs = (u8)wlapi_getintvar(shim, "rssisav2g");
+		pi_lcn->lcnphy_rssi_vf =
+				(u8)wlapi_getintvar(shim, BRCMS_SROM_RSSISMF2G);
+		pi_lcn->lcnphy_rssi_vc =
+				(u8)wlapi_getintvar(shim, BRCMS_SROM_RSSISMC2G);
+		pi_lcn->lcnphy_rssi_gs =
+				(u8)wlapi_getintvar(shim, BRCMS_SROM_RSSISAV2G);
 
 		pi_lcn->lcnphy_rssi_vf_lowtemp = pi_lcn->lcnphy_rssi_vf;
 		pi_lcn->lcnphy_rssi_vc_lowtemp = pi_lcn->lcnphy_rssi_vc;
@@ -4845,7 +4848,7 @@ static bool wlc_phy_txpwr_srom_read_lcnphy(struct brcms_phy *pi)
 		pi_lcn->lcnphy_rssi_vc_hightemp = pi_lcn->lcnphy_rssi_vc;
 		pi_lcn->lcnphy_rssi_gs_hightemp = pi_lcn->lcnphy_rssi_gs;
 
-		txpwr = (s8)wlapi_getintvar(shim, "maxp2ga0");
+		txpwr = (s8)wlapi_getintvar(shim, BRCMS_SROM_MAXP2GA0);
 		pi->tx_srom_max_2g = txpwr;
 
 		for (i = 0; i < PWRTBL_NUM_COEFF; i++) {
@@ -4853,7 +4856,8 @@ static bool wlc_phy_txpwr_srom_read_lcnphy(struct brcms_phy *pi)
 			pi->txpa_2g_high_temp[i] = pi->txpa_2g[i];
 		}
 
-		cckpo = (u16)wlapi_getintvar(shim, "cck2gpo");
+		cckpo = (u16)wlapi_getintvar(shim, BRCMS_SROM_CCK2GPO);
+		offset_ofdm = (u32)wlapi_getintvar(shim, BRCMS_SROM_OFDM2GPO);
 		if (cckpo) {
 			uint max_pwr_chan = txpwr;
 
@@ -4863,7 +4867,6 @@ static bool wlc_phy_txpwr_srom_read_lcnphy(struct brcms_phy *pi)
 				cckpo >>= 4;
 			}
 
-			offset_ofdm = (u32)wlapi_getintvar(shim, "ofdm2gpo");
 			for (i = TXP_FIRST_OFDM; i <= TXP_LAST_OFDM; i++) {
 				pi->tx_srom_max_rate_2g[i] =
 					max_pwr_chan -
@@ -4873,22 +4876,22 @@ static bool wlc_phy_txpwr_srom_read_lcnphy(struct brcms_phy *pi)
 		} else {
 			u8 opo = 0;
 
-			opo = (u8)wlapi_getintvar(shim, "opo");
+			opo = (u8)wlapi_getintvar(shim, BRCMS_SROM_OPO);
 
 			for (i = TXP_FIRST_CCK; i <= TXP_LAST_CCK; i++)
 				pi->tx_srom_max_rate_2g[i] = txpwr;
 
-			offset_ofdm = (u32)wlapi_getintvar(shim, "ofdm2gpo");
-
 			for (i = TXP_FIRST_OFDM; i <= TXP_LAST_OFDM; i++) {
 				pi->tx_srom_max_rate_2g[i] = txpwr -
 						((offset_ofdm & 0xf) * 2);
 				offset_ofdm >>= 4;
 			}
 			offset_mcs =
-				wlapi_getintvar(shim, "mcs2gpo1") << 16;
+				wlapi_getintvar(shim,
+						BRCMS_SROM_MCS2GPO1) << 16;
 			offset_mcs |=
-				(u16) wlapi_getintvar(shim, "mcs2gpo0");
+				(u16) wlapi_getintvar(shim,
+						      BRCMS_SROM_MCS2GPO0);
 			pi_lcn->lcnphy_mcs20_po = offset_mcs;
 			for (i = TXP_FIRST_SISO_MCS_20;
 			     i <= TXP_LAST_SISO_MCS_20; i++) {
@@ -4899,25 +4902,24 @@ static bool wlc_phy_txpwr_srom_read_lcnphy(struct brcms_phy *pi)
 		}
 
 		pi_lcn->lcnphy_rawtempsense =
-			(u16)wlapi_getintvar(shim, "rawtempsense");
+			(u16)wlapi_getintvar(shim, BRCMS_SROM_RAWTEMPSENSE);
 		pi_lcn->lcnphy_measPower =
-			(u8)wlapi_getintvar(shim, "measpower");
+			(u8)wlapi_getintvar(shim, BRCMS_SROM_MEASPOWER);
 		pi_lcn->lcnphy_tempsense_slope =
-			(u8)wlapi_getintvar(shim, "tempsense_slope");
+			(u8)wlapi_getintvar(shim, BRCMS_SROM_TEMPSENSE_SLOPE);
 		pi_lcn->lcnphy_hw_iqcal_en =
-			(bool)wlapi_getintvar(shim, "hw_iqcal_en");
+			(bool)wlapi_getintvar(shim, BRCMS_SROM_HW_IQCAL_EN);
 		pi_lcn->lcnphy_iqcal_swp_dis =
-			(bool)wlapi_getintvar(shim, "iqcal_swp_dis");
+			(bool)wlapi_getintvar(shim, BRCMS_SROM_IQCAL_SWP_DIS);
 		pi_lcn->lcnphy_tempcorrx =
-			(u8)wlapi_getintvar(shim, "tempcorrx");
+			(u8)wlapi_getintvar(shim, BRCMS_SROM_TEMPCORRX);
 		pi_lcn->lcnphy_tempsense_option =
-			(u8)wlapi_getintvar(shim, "tempsense_option");
+			(u8)wlapi_getintvar(shim, BRCMS_SROM_TEMPSENSE_OPTION);
 		pi_lcn->lcnphy_freqoffset_corr =
-			(u8)wlapi_getintvar(shim, "freqoffset_corr");
-		if ((u8)wlapi_getintvar(shim, "aa2g") > 1)
+			(u8)wlapi_getintvar(shim, BRCMS_SROM_FREQOFFSET_CORR);
+		if ((u8)wlapi_getintvar(shim, BRCMS_SROM_AA2G) > 1)
 			wlc_phy_ant_rxdiv_set((struct brcms_phy_pub *) pi,
-					      (u8) wlapi_getintvar(shim,
-								   "aa2g"));
+				(u8) wlapi_getintvar(shim, BRCMS_SROM_AA2G));
 	}
 	pi_lcn->lcnphy_cck_dig_filt_type = -1;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
index a4417e9..cd19c2f 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
@@ -14388,25 +14388,25 @@ static void wlc_phy_txpwr_srom_read_ppr_nphy(struct brcms_phy *pi)
 	if (pi->sh->sromrev >= 9)
 		return;
 
-	bw40po = (u16) wlapi_getintvar(shim, "bw40po");
+	bw40po = (u16) wlapi_getintvar(shim, BRCMS_SROM_BW40PO);
 	pi->bw402gpo = bw40po & 0xf;
 	pi->bw405gpo = (bw40po & 0xf0) >> 4;
 	pi->bw405glpo = (bw40po & 0xf00) >> 8;
 	pi->bw405ghpo = (bw40po & 0xf000) >> 12;
 
-	cddpo = (u16) wlapi_getintvar(shim, "cddpo");
+	cddpo = (u16) wlapi_getintvar(shim, BRCMS_SROM_CDDPO);
 	pi->cdd2gpo = cddpo & 0xf;
 	pi->cdd5gpo = (cddpo & 0xf0) >> 4;
 	pi->cdd5glpo = (cddpo & 0xf00) >> 8;
 	pi->cdd5ghpo = (cddpo & 0xf000) >> 12;
 
-	stbcpo = (u16) wlapi_getintvar(shim, "stbcpo");
+	stbcpo = (u16) wlapi_getintvar(shim, BRCMS_SROM_STBCPO);
 	pi->stbc2gpo = stbcpo & 0xf;
 	pi->stbc5gpo = (stbcpo & 0xf0) >> 4;
 	pi->stbc5glpo = (stbcpo & 0xf00) >> 8;
 	pi->stbc5ghpo = (stbcpo & 0xf000) >> 12;
 
-	bwduppo = (u16) wlapi_getintvar(shim, "bwduppo");
+	bwduppo = (u16) wlapi_getintvar(shim, BRCMS_SROM_BWDUPPO);
 	pi->bwdup2gpo = bwduppo & 0xf;
 	pi->bwdup5gpo = (bwduppo & 0xf0) >> 4;
 	pi->bwdup5glpo = (bwduppo & 0xf00) >> 8;
@@ -14418,186 +14418,264 @@ static void wlc_phy_txpwr_srom_read_ppr_nphy(struct brcms_phy *pi)
 		case 0:
 
 			pi->nphy_txpid2g[PHY_CORE_0] =
-				(u8) wlapi_getintvar(shim, "txpid2ga0");
+				(u8) wlapi_getintvar(shim,
+						     BRCMS_SROM_TXPID2GA0);
 			pi->nphy_txpid2g[PHY_CORE_1] =
-				(u8) wlapi_getintvar(shim, "txpid2ga1");
+				(u8) wlapi_getintvar(shim,
+						     BRCMS_SROM_TXPID2GA1);
 			pi->nphy_pwrctrl_info[PHY_CORE_0].max_pwr_2g =
-				(s8) wlapi_getintvar(shim, "maxp2ga0");
+				(s8) wlapi_getintvar(shim,
+						     BRCMS_SROM_MAXP2GA0);
 			pi->nphy_pwrctrl_info[PHY_CORE_1].max_pwr_2g =
-				(s8) wlapi_getintvar(shim, "maxp2ga1");
+				(s8) wlapi_getintvar(shim,
+						     BRCMS_SROM_MAXP2GA1);
 			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_2g_a1 =
-				(s16) wlapi_getintvar(shim, "pa2gw0a0");
+				(s16) wlapi_getintvar(shim,
+						      BRCMS_SROM_PA2GW0A0);
 			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_2g_a1 =
-				(s16) wlapi_getintvar(shim, "pa2gw0a1");
+				(s16) wlapi_getintvar(shim,
+						      BRCMS_SROM_PA2GW0A1);
 			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_2g_b0 =
-				(s16) wlapi_getintvar(shim, "pa2gw1a0");
+				(s16) wlapi_getintvar(shim,
+						      BRCMS_SROM_PA2GW1A0);
 			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_2g_b0 =
-				(s16) wlapi_getintvar(shim, "pa2gw1a1");
+				(s16) wlapi_getintvar(shim,
+						      BRCMS_SROM_PA2GW1A1);
 			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_2g_b1 =
-				(s16) wlapi_getintvar(shim, "pa2gw2a0");
+				(s16) wlapi_getintvar(shim,
+						      BRCMS_SROM_PA2GW2A0);
 			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_2g_b1 =
-				(s16) wlapi_getintvar(shim, "pa2gw2a1");
+				(s16) wlapi_getintvar(shim,
+						      BRCMS_SROM_PA2GW2A1);
 			pi->nphy_pwrctrl_info[PHY_CORE_0].idle_targ_2g =
-				(s8) wlapi_getintvar(shim, "itt2ga0");
+				(s8) wlapi_getintvar(shim, BRCMS_SROM_ITT2GA0);
 			pi->nphy_pwrctrl_info[PHY_CORE_1].idle_targ_2g =
-				(s8) wlapi_getintvar(shim, "itt2ga1");
+				(s8) wlapi_getintvar(shim, BRCMS_SROM_ITT2GA1);
 
-			pi->cck2gpo = (u16) wlapi_getintvar(shim, "cck2gpo");
+			pi->cck2gpo = (u16) wlapi_getintvar(shim,
+							    BRCMS_SROM_CCK2GPO);
 
-			pi->ofdm2gpo = (u32) wlapi_getintvar(shim, "ofdm2gpo");
+			pi->ofdm2gpo =
+				(u32) wlapi_getintvar(shim,
+						      BRCMS_SROM_OFDM2GPO);
 
 			pi->mcs2gpo[0] =
-				(u16) wlapi_getintvar(shim, "mcs2gpo0");
+				(u16) wlapi_getintvar(shim,
+						      BRCMS_SROM_MCS2GPO0);
 			pi->mcs2gpo[1] =
-				(u16) wlapi_getintvar(shim, "mcs2gpo1");
+				(u16) wlapi_getintvar(shim,
+						      BRCMS_SROM_MCS2GPO1);
 			pi->mcs2gpo[2] =
-				(u16) wlapi_getintvar(shim, "mcs2gpo2");
+				(u16) wlapi_getintvar(shim,
+						      BRCMS_SROM_MCS2GPO2);
 			pi->mcs2gpo[3] =
-				(u16) wlapi_getintvar(shim, "mcs2gpo3");
+				(u16) wlapi_getintvar(shim,
+						      BRCMS_SROM_MCS2GPO3);
 			pi->mcs2gpo[4] =
-				(u16) wlapi_getintvar(shim, "mcs2gpo4");
+				(u16) wlapi_getintvar(shim,
+						      BRCMS_SROM_MCS2GPO4);
 			pi->mcs2gpo[5] =
-				(u16) wlapi_getintvar(shim, "mcs2gpo5");
+				(u16) wlapi_getintvar(shim,
+						      BRCMS_SROM_MCS2GPO5);
 			pi->mcs2gpo[6] =
-				(u16) wlapi_getintvar(shim, "mcs2gpo6");
+				(u16) wlapi_getintvar(shim,
+						      BRCMS_SROM_MCS2GPO6);
 			pi->mcs2gpo[7] =
-				(u16) wlapi_getintvar(shim, "mcs2gpo7");
+				(u16) wlapi_getintvar(shim,
+						      BRCMS_SROM_MCS2GPO7);
 			break;
 		case 1:
 
 			pi->nphy_txpid5g[PHY_CORE_0] =
-				(u8) wlapi_getintvar(shim, "txpid5ga0");
+				(u8) wlapi_getintvar(shim,
+						     BRCMS_SROM_TXPID5GA0);
 			pi->nphy_txpid5g[PHY_CORE_1] =
-				(u8) wlapi_getintvar(shim, "txpid5ga1");
+				(u8) wlapi_getintvar(shim,
+						     BRCMS_SROM_TXPID5GA1);
 			pi->nphy_pwrctrl_info[PHY_CORE_0].max_pwr_5gm =
-				(s8) wlapi_getintvar(shim, "maxp5ga0");
+				(s8) wlapi_getintvar(shim, BRCMS_SROM_MAXP5GA0);
 			pi->nphy_pwrctrl_info[PHY_CORE_1].max_pwr_5gm =
-				(s8) wlapi_getintvar(shim, "maxp5ga1");
+				(s8) wlapi_getintvar(shim,
+						     BRCMS_SROM_MAXP5GA1);
 			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_5gm_a1 =
-				(s16) wlapi_getintvar(shim, "pa5gw0a0");
+				(s16) wlapi_getintvar(shim,
+						      BRCMS_SROM_PA5GW0A0);
 			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_5gm_a1 =
-				(s16) wlapi_getintvar(shim, "pa5gw0a1");
+				(s16) wlapi_getintvar(shim,
+						      BRCMS_SROM_PA5GW0A1);
 			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_5gm_b0 =
-				(s16) wlapi_getintvar(shim, "pa5gw1a0");
+				(s16) wlapi_getintvar(shim,
+						      BRCMS_SROM_PA5GW1A0);
 			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_5gm_b0 =
-				(s16) wlapi_getintvar(shim, "pa5gw1a1");
+				(s16) wlapi_getintvar(shim,
+						      BRCMS_SROM_PA5GW1A1);
 			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_5gm_b1 =
-				(s16) wlapi_getintvar(shim, "pa5gw2a0");
+				(s16) wlapi_getintvar(shim,
+						      BRCMS_SROM_PA5GW2A0);
 			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_5gm_b1 =
-				(s16) wlapi_getintvar(shim, "pa5gw2a1");
+				(s16) wlapi_getintvar(shim,
+						      BRCMS_SROM_PA5GW2A1);
 			pi->nphy_pwrctrl_info[PHY_CORE_0].idle_targ_5gm =
-				(s8) wlapi_getintvar(shim, "itt5ga0");
+				(s8) wlapi_getintvar(shim, BRCMS_SROM_ITT5GA0);
 			pi->nphy_pwrctrl_info[PHY_CORE_1].idle_targ_5gm =
-				(s8) wlapi_getintvar(shim, "itt5ga1");
+				(s8) wlapi_getintvar(shim, BRCMS_SROM_ITT5GA1);
 
-			pi->ofdm5gpo = (u32) wlapi_getintvar(shim, "ofdm5gpo");
+			pi->ofdm5gpo =
+				(u32) wlapi_getintvar(shim,
+						      BRCMS_SROM_OFDM5GPO);
 
 			pi->mcs5gpo[0] =
-				(u16) wlapi_getintvar(shim, "mcs5gpo0");
+				(u16) wlapi_getintvar(shim,
+						      BRCMS_SROM_MCS5GPO0);
 			pi->mcs5gpo[1] =
-				(u16) wlapi_getintvar(shim, "mcs5gpo1");
+				(u16) wlapi_getintvar(shim,
+						      BRCMS_SROM_MCS5GPO1);
 			pi->mcs5gpo[2] =
-				(u16) wlapi_getintvar(shim, "mcs5gpo2");
+				(u16) wlapi_getintvar(shim,
+						      BRCMS_SROM_MCS5GPO2);
 			pi->mcs5gpo[3] =
-				(u16) wlapi_getintvar(shim, "mcs5gpo3");
+				(u16) wlapi_getintvar(shim,
+						      BRCMS_SROM_MCS5GPO3);
 			pi->mcs5gpo[4] =
-				(u16) wlapi_getintvar(shim, "mcs5gpo4");
+				(u16) wlapi_getintvar(shim,
+						      BRCMS_SROM_MCS5GPO4);
 			pi->mcs5gpo[5] =
-				(u16) wlapi_getintvar(shim, "mcs5gpo5");
+				(u16) wlapi_getintvar(shim,
+						      BRCMS_SROM_MCS5GPO5);
 			pi->mcs5gpo[6] =
-				(u16) wlapi_getintvar(shim, "mcs5gpo6");
+				(u16) wlapi_getintvar(shim,
+						      BRCMS_SROM_MCS5GPO6);
 			pi->mcs5gpo[7] =
-				(u16) wlapi_getintvar(shim, "mcs5gpo7");
+				(u16) wlapi_getintvar(shim,
+						      BRCMS_SROM_MCS5GPO7);
 			break;
 		case 2:
 
 			pi->nphy_txpid5gl[0] =
-				(u8) wlapi_getintvar(shim, "txpid5gla0");
+				(u8) wlapi_getintvar(shim,
+						     BRCMS_SROM_TXPID5GLA0);
 			pi->nphy_txpid5gl[1] =
-				(u8) wlapi_getintvar(shim, "txpid5gla1");
+				(u8) wlapi_getintvar(shim,
+						     BRCMS_SROM_TXPID5GLA1);
 			pi->nphy_pwrctrl_info[0].max_pwr_5gl =
-				(s8) wlapi_getintvar(shim, "maxp5gla0");
+				(s8) wlapi_getintvar(shim,
+						     BRCMS_SROM_MAXP5GLA0);
 			pi->nphy_pwrctrl_info[1].max_pwr_5gl =
-				(s8) wlapi_getintvar(shim, "maxp5gla1");
+				(s8) wlapi_getintvar(shim,
+						     BRCMS_SROM_MAXP5GLA1);
 			pi->nphy_pwrctrl_info[0].pwrdet_5gl_a1 =
-				(s16) wlapi_getintvar(shim, "pa5glw0a0");
+				(s16) wlapi_getintvar(shim,
+						      BRCMS_SROM_PA5GLW0A0);
 			pi->nphy_pwrctrl_info[1].pwrdet_5gl_a1 =
-				(s16) wlapi_getintvar(shim, "pa5glw0a1");
+				(s16) wlapi_getintvar(shim,
+						      BRCMS_SROM_PA5GLW0A1);
 			pi->nphy_pwrctrl_info[0].pwrdet_5gl_b0 =
-				(s16) wlapi_getintvar(shim, "pa5glw1a0");
+				(s16) wlapi_getintvar(shim,
+						      BRCMS_SROM_PA5GLW1A0);
 			pi->nphy_pwrctrl_info[1].pwrdet_5gl_b0 =
-				(s16) wlapi_getintvar(shim, "pa5glw1a1");
+				(s16) wlapi_getintvar(shim,
+						      BRCMS_SROM_PA5GLW1A1);
 			pi->nphy_pwrctrl_info[0].pwrdet_5gl_b1 =
-				(s16) wlapi_getintvar(shim, "pa5glw2a0");
+				(s16) wlapi_getintvar(shim,
+						      BRCMS_SROM_PA5GLW2A0);
 			pi->nphy_pwrctrl_info[1].pwrdet_5gl_b1 =
-				(s16) wlapi_getintvar(shim, "pa5glw2a1");
+				(s16) wlapi_getintvar(shim,
+						      BRCMS_SROM_PA5GLW2A1);
 			pi->nphy_pwrctrl_info[0].idle_targ_5gl = 0;
 			pi->nphy_pwrctrl_info[1].idle_targ_5gl = 0;
 
 			pi->ofdm5glpo =
-				(u32) wlapi_getintvar(shim, "ofdm5glpo");
+				(u32) wlapi_getintvar(shim,
+						      BRCMS_SROM_OFDM5GLPO);
 
 			pi->mcs5glpo[0] =
-				(u16) wlapi_getintvar(shim, "mcs5glpo0");
+				(u16) wlapi_getintvar(shim,
+						      BRCMS_SROM_MCS5GLPO0);
 			pi->mcs5glpo[1] =
-				(u16) wlapi_getintvar(shim, "mcs5glpo1");
+				(u16) wlapi_getintvar(shim,
+						      BRCMS_SROM_MCS5GLPO1);
 			pi->mcs5glpo[2] =
-				(u16) wlapi_getintvar(shim, "mcs5glpo2");
+				(u16) wlapi_getintvar(shim,
+						      BRCMS_SROM_MCS5GLPO2);
 			pi->mcs5glpo[3] =
-				(u16) wlapi_getintvar(shim, "mcs5glpo3");
+				(u16) wlapi_getintvar(shim,
+						      BRCMS_SROM_MCS5GLPO3);
 			pi->mcs5glpo[4] =
-				(u16) wlapi_getintvar(shim, "mcs5glpo4");
+				(u16) wlapi_getintvar(shim,
+						      BRCMS_SROM_MCS5GLPO4);
 			pi->mcs5glpo[5] =
-				(u16) wlapi_getintvar(shim, "mcs5glpo5");
+				(u16) wlapi_getintvar(shim,
+						      BRCMS_SROM_MCS5GLPO5);
 			pi->mcs5glpo[6] =
-				(u16) wlapi_getintvar(shim, "mcs5glpo6");
+				(u16) wlapi_getintvar(shim,
+						      BRCMS_SROM_MCS5GLPO6);
 			pi->mcs5glpo[7] =
-				(u16) wlapi_getintvar(shim, "mcs5glpo7");
+				(u16) wlapi_getintvar(shim,
+						      BRCMS_SROM_MCS5GLPO7);
 			break;
 		case 3:
 
 			pi->nphy_txpid5gh[0] =
-				(u8) wlapi_getintvar(shim, "txpid5gha0");
+				(u8) wlapi_getintvar(shim,
+						     BRCMS_SROM_TXPID5GHA0);
 			pi->nphy_txpid5gh[1] =
-				(u8) wlapi_getintvar(shim, "txpid5gha1");
+				(u8) wlapi_getintvar(shim,
+						     BRCMS_SROM_TXPID5GHA1);
 			pi->nphy_pwrctrl_info[0].max_pwr_5gh =
-				(s8) wlapi_getintvar(shim, "maxp5gha0");
+				(s8) wlapi_getintvar(shim,
+						     BRCMS_SROM_MAXP5GHA0);
 			pi->nphy_pwrctrl_info[1].max_pwr_5gh =
-				(s8) wlapi_getintvar(shim, "maxp5gha1");
+				(s8) wlapi_getintvar(shim,
+						     BRCMS_SROM_MAXP5GHA1);
 			pi->nphy_pwrctrl_info[0].pwrdet_5gh_a1 =
-				(s16) wlapi_getintvar(shim, "pa5ghw0a0");
+				(s16) wlapi_getintvar(shim,
+						      BRCMS_SROM_PA5GHW0A0);
 			pi->nphy_pwrctrl_info[1].pwrdet_5gh_a1 =
-				(s16) wlapi_getintvar(shim, "pa5ghw0a1");
+				(s16) wlapi_getintvar(shim,
+						      BRCMS_SROM_PA5GHW0A1);
 			pi->nphy_pwrctrl_info[0].pwrdet_5gh_b0 =
-				(s16) wlapi_getintvar(shim, "pa5ghw1a0");
+				(s16) wlapi_getintvar(shim,
+						      BRCMS_SROM_PA5GHW1A0);
 			pi->nphy_pwrctrl_info[1].pwrdet_5gh_b0 =
-				(s16) wlapi_getintvar(shim, "pa5ghw1a1");
+				(s16) wlapi_getintvar(shim,
+						      BRCMS_SROM_PA5GHW1A1);
 			pi->nphy_pwrctrl_info[0].pwrdet_5gh_b1 =
-				(s16) wlapi_getintvar(shim, "pa5ghw2a0");
+				(s16) wlapi_getintvar(shim,
+						      BRCMS_SROM_PA5GHW2A0);
 			pi->nphy_pwrctrl_info[1].pwrdet_5gh_b1 =
-				(s16) wlapi_getintvar(shim, "pa5ghw2a1");
+				(s16) wlapi_getintvar(shim,
+						      BRCMS_SROM_PA5GHW2A1);
 			pi->nphy_pwrctrl_info[0].idle_targ_5gh = 0;
 			pi->nphy_pwrctrl_info[1].idle_targ_5gh = 0;
 
 			pi->ofdm5ghpo =
-				(u32) wlapi_getintvar(shim, "ofdm5ghpo");
+				(u32) wlapi_getintvar(shim,
+						      BRCMS_SROM_OFDM5GHPO);
 
 			pi->mcs5ghpo[0] =
-				(u16) wlapi_getintvar(shim, "mcs5ghpo0");
+				(u16) wlapi_getintvar(shim,
+						      BRCMS_SROM_MCS5GHPO0);
 			pi->mcs5ghpo[1] =
-				(u16) wlapi_getintvar(shim, "mcs5ghpo1");
+				(u16) wlapi_getintvar(shim,
+						      BRCMS_SROM_MCS5GHPO1);
 			pi->mcs5ghpo[2] =
-				(u16) wlapi_getintvar(shim, "mcs5ghpo2");
+				(u16) wlapi_getintvar(shim,
+						      BRCMS_SROM_MCS5GHPO2);
 			pi->mcs5ghpo[3] =
-				(u16) wlapi_getintvar(shim, "mcs5ghpo3");
+				(u16) wlapi_getintvar(shim,
+						      BRCMS_SROM_MCS5GHPO3);
 			pi->mcs5ghpo[4] =
-				(u16) wlapi_getintvar(shim, "mcs5ghpo4");
+				(u16) wlapi_getintvar(shim,
+						      BRCMS_SROM_MCS5GHPO4);
 			pi->mcs5ghpo[5] =
-				(u16) wlapi_getintvar(shim, "mcs5ghpo5");
+				(u16) wlapi_getintvar(shim,
+						      BRCMS_SROM_MCS5GHPO5);
 			pi->mcs5ghpo[6] =
-				(u16) wlapi_getintvar(shim, "mcs5ghpo6");
+				(u16) wlapi_getintvar(shim,
+						      BRCMS_SROM_MCS5GHPO6);
 			pi->mcs5ghpo[7] =
-				(u16) wlapi_getintvar(shim, "mcs5ghpo7");
+				(u16) wlapi_getintvar(shim,
+						      BRCMS_SROM_MCS5GHPO7);
 			break;
 		}
 	}
@@ -14609,35 +14687,43 @@ static bool wlc_phy_txpwr_srom_read_nphy(struct brcms_phy *pi)
 {
 	struct phy_shim_info *shim = pi->sh->physhim;
 
-	pi->antswitch = (u8) wlapi_getintvar(shim, "antswitch");
-	pi->aa2g = (u8) wlapi_getintvar(shim, "aa2g");
-	pi->aa5g = (u8) wlapi_getintvar(shim, "aa5g");
-
-	pi->srom_fem2g.tssipos = (u8) wlapi_getintvar(shim, "tssipos2g");
-	pi->srom_fem2g.extpagain = (u8) wlapi_getintvar(shim, "extpagain2g");
-	pi->srom_fem2g.pdetrange = (u8) wlapi_getintvar(shim, "pdetrange2g");
-	pi->srom_fem2g.triso = (u8) wlapi_getintvar(shim, "triso2g");
-	pi->srom_fem2g.antswctrllut = (u8) wlapi_getintvar(shim, "antswctl2g");
-
-	pi->srom_fem5g.tssipos = (u8) wlapi_getintvar(shim, "tssipos5g");
-	pi->srom_fem5g.extpagain = (u8) wlapi_getintvar(shim, "extpagain5g");
-	pi->srom_fem5g.pdetrange = (u8) wlapi_getintvar(shim, "pdetrange5g");
-	pi->srom_fem5g.triso = (u8) wlapi_getintvar(shim, "triso5g");
-	if (wlapi_getvar(shim, "antswctl5g"))
+	pi->antswitch = (u8) wlapi_getintvar(shim, BRCMS_SROM_ANTSWITCH);
+	pi->aa2g = (u8) wlapi_getintvar(shim, BRCMS_SROM_AA2G);
+	pi->aa5g = (u8) wlapi_getintvar(shim, BRCMS_SROM_AA5G);
+
+	pi->srom_fem2g.tssipos = (u8) wlapi_getintvar(shim,
+						      BRCMS_SROM_TSSIPOS2G);
+	pi->srom_fem2g.extpagain = (u8) wlapi_getintvar(shim,
+							BRCMS_SROM_EXTPAGAIN2G);
+	pi->srom_fem2g.pdetrange = (u8) wlapi_getintvar(shim,
+							BRCMS_SROM_PDETRANGE2G);
+	pi->srom_fem2g.triso = (u8) wlapi_getintvar(shim, BRCMS_SROM_TRISO2G);
+	pi->srom_fem2g.antswctrllut =
+			(u8) wlapi_getintvar(shim, BRCMS_SROM_ANTSWCTL2G);
+
+	pi->srom_fem5g.tssipos = (u8) wlapi_getintvar(shim,
+						      BRCMS_SROM_TSSIPOS5G);
+	pi->srom_fem5g.extpagain = (u8) wlapi_getintvar(shim,
+							BRCMS_SROM_EXTPAGAIN5G);
+	pi->srom_fem5g.pdetrange = (u8) wlapi_getintvar(shim,
+							BRCMS_SROM_PDETRANGE5G);
+	pi->srom_fem5g.triso = (u8) wlapi_getintvar(shim, BRCMS_SROM_TRISO5G);
+	if (wlapi_getvar(shim, BRCMS_SROM_ANTSWCTL5G))
 		pi->srom_fem5g.antswctrllut =
-			(u8) wlapi_getintvar(shim, "antswctl5g");
+			(u8) wlapi_getintvar(shim, BRCMS_SROM_ANTSWCTL5G);
 	else
 		pi->srom_fem5g.antswctrllut =
-			(u8) wlapi_getintvar(shim, "antswctl2g");
+			(u8) wlapi_getintvar(shim, BRCMS_SROM_ANTSWCTL2G);
 
 	wlc_phy_txpower_ipa_upd(pi);
 
 	pi->phy_txcore_disable_temp =
-			(s16) wlapi_getintvar(shim, "tempthresh");
+			(s16) wlapi_getintvar(shim, BRCMS_SROM_TEMPTHRESH);
 	if (pi->phy_txcore_disable_temp == 0)
 		pi->phy_txcore_disable_temp = PHY_CHAIN_TX_DISABLE_TEMP;
 
-	pi->phy_tempsense_offset = (s8) wlapi_getintvar(shim, "tempoffset");
+	pi->phy_tempsense_offset = (s8) wlapi_getintvar(shim,
+							BRCMS_SROM_TEMPOFFSET);
 	if (pi->phy_tempsense_offset != 0) {
 		if (pi->phy_tempsense_offset >
 		    (NPHY_SROM_TEMPSHIFT + NPHY_SROM_MAXTEMPOFFSET))
@@ -14653,7 +14739,7 @@ static bool wlc_phy_txpwr_srom_read_nphy(struct brcms_phy *pi)
 		pi->phy_txcore_disable_temp - PHY_HYSTERESIS_DELTATEMP;
 
 	pi->phycal_tempdelta =
-			(u8) wlapi_getintvar(shim, "phycal_tempdelta");
+			(u8) wlapi_getintvar(shim, BRCMS_SROM_PHYCAL_TEMPDELTA);
 	if (pi->phycal_tempdelta > NPHY_CAL_MAXTEMPDELTA)
 		pi->phycal_tempdelta = 0;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy_shim.c b/drivers/staging/brcm80211/brcmsmac/phy_shim.c
index 57122fc..676222e 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy_shim.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy_shim.c
@@ -216,11 +216,11 @@ wlapi_copyto_objmem(struct phy_shim_info *physhim, uint offset, const void *buf,
 	brcms_b_copyto_objmem(physhim->wlc_hw, offset, buf, l, sel);
 }
 
-char *wlapi_getvar(struct phy_shim_info *physhim, const char *name)
+char *wlapi_getvar(struct phy_shim_info *physhim, enum brcms_srom_id id)
 {
-	return getvar(physhim->wlc_hw->sih, name);
+	return getvar(physhim->wlc_hw->sih, id);
 }
-int wlapi_getintvar(struct phy_shim_info *physhim, const char *name)
+int wlapi_getintvar(struct phy_shim_info *physhim, enum brcms_srom_id id)
 {
-	return getintvar(physhim->wlc_hw->sih, name);
+	return getintvar(physhim->wlc_hw->sih, id);
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/phy_shim.h b/drivers/staging/brcm80211/brcmsmac/phy_shim.h
index ca76153..8de549d 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy_shim.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy_shim.h
@@ -178,7 +178,8 @@ extern void wlapi_copyto_objmem(struct phy_shim_info *physhim, uint,
 extern void wlapi_high_update_phy_mode(struct phy_shim_info *physhim,
 				       u32 phy_mode);
 extern u16 wlapi_bmac_get_txant(struct phy_shim_info *physhim);
-extern char *wlapi_getvar(struct phy_shim_info *physhim, const char *name);
-extern int wlapi_getintvar(struct phy_shim_info *physhim, const char *name);
+extern char *wlapi_getvar(struct phy_shim_info *physhim, enum brcms_srom_id id);
+extern int wlapi_getintvar(struct phy_shim_info *physhim,
+			   enum brcms_srom_id id);
 
 #endif				/* _BRCM_PHY_SHIM_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
index d1639b4..8c9ac8f 100644
--- a/drivers/staging/brcm80211/brcmsmac/pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -21,6 +21,264 @@
 #include "types.h"
 #include "defs.h"
 
+enum brcms_srom_id {
+	BRCMS_SROM_NULL,
+	BRCMS_SROM_CONT,
+	BRCMS_SROM_AA2G,
+	BRCMS_SROM_AA5G,
+	BRCMS_SROM_AG0,
+	BRCMS_SROM_AG1,
+	BRCMS_SROM_AG2,
+	BRCMS_SROM_AG3,
+	BRCMS_SROM_ANTSWCTL2G,
+	BRCMS_SROM_ANTSWCTL5G,
+	BRCMS_SROM_ANTSWITCH,
+	BRCMS_SROM_BOARDFLAGS2,
+	BRCMS_SROM_BOARDFLAGS,
+	BRCMS_SROM_BOARDNUM,
+	BRCMS_SROM_BOARDREV,
+	BRCMS_SROM_BOARDTYPE,
+	BRCMS_SROM_BW40PO,
+	BRCMS_SROM_BWDUPPO,
+	BRCMS_SROM_BXA2G,
+	BRCMS_SROM_BXA5G,
+	BRCMS_SROM_CC,
+	BRCMS_SROM_CCK2GPO,
+	BRCMS_SROM_CCKBW202GPO,
+	BRCMS_SROM_CCKBW20UL2GPO,
+	BRCMS_SROM_CCODE,
+	BRCMS_SROM_CDDPO,
+	BRCMS_SROM_DEVID,
+	BRCMS_SROM_ET1MACADDR,
+	BRCMS_SROM_EXTPAGAIN2G,
+	BRCMS_SROM_EXTPAGAIN5G,
+	BRCMS_SROM_FREQOFFSET_CORR,
+	BRCMS_SROM_HW_IQCAL_EN,
+	BRCMS_SROM_IL0MACADDR,
+	BRCMS_SROM_IQCAL_SWP_DIS,
+	BRCMS_SROM_LEDBH0,
+	BRCMS_SROM_LEDBH1,
+	BRCMS_SROM_LEDBH2,
+	BRCMS_SROM_LEDBH3,
+	BRCMS_SROM_LEDDC,
+	BRCMS_SROM_LEGOFDM40DUPPO,
+	BRCMS_SROM_LEGOFDMBW202GPO,
+	BRCMS_SROM_LEGOFDMBW205GHPO,
+	BRCMS_SROM_LEGOFDMBW205GLPO,
+	BRCMS_SROM_LEGOFDMBW205GMPO,
+	BRCMS_SROM_LEGOFDMBW20UL2GPO,
+	BRCMS_SROM_LEGOFDMBW20UL5GHPO,
+	BRCMS_SROM_LEGOFDMBW20UL5GLPO,
+	BRCMS_SROM_LEGOFDMBW20UL5GMPO,
+	BRCMS_SROM_MACADDR,
+	BRCMS_SROM_MCS2GPO0,
+	BRCMS_SROM_MCS2GPO1,
+	BRCMS_SROM_MCS2GPO2,
+	BRCMS_SROM_MCS2GPO3,
+	BRCMS_SROM_MCS2GPO4,
+	BRCMS_SROM_MCS2GPO5,
+	BRCMS_SROM_MCS2GPO6,
+	BRCMS_SROM_MCS2GPO7,
+	BRCMS_SROM_MCS32PO,
+	BRCMS_SROM_MCS5GHPO0,
+	BRCMS_SROM_MCS5GHPO1,
+	BRCMS_SROM_MCS5GHPO2,
+	BRCMS_SROM_MCS5GHPO3,
+	BRCMS_SROM_MCS5GHPO4,
+	BRCMS_SROM_MCS5GHPO5,
+	BRCMS_SROM_MCS5GHPO6,
+	BRCMS_SROM_MCS5GHPO7,
+	BRCMS_SROM_MCS5GLPO0,
+	BRCMS_SROM_MCS5GLPO1,
+	BRCMS_SROM_MCS5GLPO2,
+	BRCMS_SROM_MCS5GLPO3,
+	BRCMS_SROM_MCS5GLPO4,
+	BRCMS_SROM_MCS5GLPO5,
+	BRCMS_SROM_MCS5GLPO6,
+	BRCMS_SROM_MCS5GLPO7,
+	BRCMS_SROM_MCS5GPO0,
+	BRCMS_SROM_MCS5GPO1,
+	BRCMS_SROM_MCS5GPO2,
+	BRCMS_SROM_MCS5GPO3,
+	BRCMS_SROM_MCS5GPO4,
+	BRCMS_SROM_MCS5GPO5,
+	BRCMS_SROM_MCS5GPO6,
+	BRCMS_SROM_MCS5GPO7,
+	BRCMS_SROM_MCSBW202GPO,
+	BRCMS_SROM_MCSBW205GHPO,
+	BRCMS_SROM_MCSBW205GLPO,
+	BRCMS_SROM_MCSBW205GMPO,
+	BRCMS_SROM_MCSBW20UL2GPO,
+	BRCMS_SROM_MCSBW20UL5GHPO,
+	BRCMS_SROM_MCSBW20UL5GLPO,
+	BRCMS_SROM_MCSBW20UL5GMPO,
+	BRCMS_SROM_MCSBW402GPO,
+	BRCMS_SROM_MCSBW405GHPO,
+	BRCMS_SROM_MCSBW405GLPO,
+	BRCMS_SROM_MCSBW405GMPO,
+	BRCMS_SROM_MEASPOWER,
+	BRCMS_SROM_OFDM2GPO,
+	BRCMS_SROM_OFDM5GHPO,
+	BRCMS_SROM_OFDM5GLPO,
+	BRCMS_SROM_OFDM5GPO,
+	BRCMS_SROM_OPO,
+	BRCMS_SROM_PA0B0,
+	BRCMS_SROM_PA0B1,
+	BRCMS_SROM_PA0B2,
+	BRCMS_SROM_PA0ITSSIT,
+	BRCMS_SROM_PA0MAXPWR,
+	BRCMS_SROM_PA1B0,
+	BRCMS_SROM_PA1B1,
+	BRCMS_SROM_PA1B2,
+	BRCMS_SROM_PA1HIB0,
+	BRCMS_SROM_PA1HIB1,
+	BRCMS_SROM_PA1HIB2,
+	BRCMS_SROM_PA1HIMAXPWR,
+	BRCMS_SROM_PA1ITSSIT,
+	BRCMS_SROM_PA1LOB0,
+	BRCMS_SROM_PA1LOB1,
+	BRCMS_SROM_PA1LOB2,
+	BRCMS_SROM_PA1LOMAXPWR,
+	BRCMS_SROM_PA1MAXPWR,
+	BRCMS_SROM_PDETRANGE2G,
+	BRCMS_SROM_PDETRANGE5G,
+	BRCMS_SROM_PHYCAL_TEMPDELTA,
+	BRCMS_SROM_RAWTEMPSENSE,
+	BRCMS_SROM_REGREV,
+	BRCMS_SROM_REV,
+	BRCMS_SROM_RSSISAV2G,
+	BRCMS_SROM_RSSISAV5G,
+	BRCMS_SROM_RSSISMC2G,
+	BRCMS_SROM_RSSISMC5G,
+	BRCMS_SROM_RSSISMF2G,
+	BRCMS_SROM_RSSISMF5G,
+	BRCMS_SROM_RXCHAIN,
+	BRCMS_SROM_RXPO2G,
+	BRCMS_SROM_RXPO5G,
+	BRCMS_SROM_STBCPO,
+	BRCMS_SROM_TEMPCORRX,
+	BRCMS_SROM_TEMPOFFSET,
+	BRCMS_SROM_TEMPSENSE_OPTION,
+	BRCMS_SROM_TEMPSENSE_SLOPE,
+	BRCMS_SROM_TEMPTHRESH,
+	BRCMS_SROM_TRI2G,
+	BRCMS_SROM_TRI5GH,
+	BRCMS_SROM_TRI5GL,
+	BRCMS_SROM_TRI5G,
+	BRCMS_SROM_TRISO2G,
+	BRCMS_SROM_TRISO5G,
+	BRCMS_SROM_TSSIPOS2G,
+	BRCMS_SROM_TSSIPOS5G,
+	BRCMS_SROM_TXCHAIN,
+	BRCMS_SROM_TXPID2GA0,
+	BRCMS_SROM_TXPID2GA1,
+	BRCMS_SROM_TXPID2GA2,
+	BRCMS_SROM_TXPID2GA3,
+	BRCMS_SROM_TXPID5GA0,
+	BRCMS_SROM_TXPID5GA1,
+	BRCMS_SROM_TXPID5GA2,
+	BRCMS_SROM_TXPID5GA3,
+	BRCMS_SROM_TXPID5GHA0,
+	BRCMS_SROM_TXPID5GHA1,
+	BRCMS_SROM_TXPID5GHA2,
+	BRCMS_SROM_TXPID5GHA3,
+	BRCMS_SROM_TXPID5GLA0,
+	BRCMS_SROM_TXPID5GLA1,
+	BRCMS_SROM_TXPID5GLA2,
+	BRCMS_SROM_TXPID5GLA3,
+	/*
+	 * per-path identifiers (see srom.c)
+	 */
+	BRCMS_SROM_ITT2GA0,
+	BRCMS_SROM_ITT2GA1,
+	BRCMS_SROM_ITT2GA2,
+	BRCMS_SROM_ITT2GA3,
+	BRCMS_SROM_ITT5GA0,
+	BRCMS_SROM_ITT5GA1,
+	BRCMS_SROM_ITT5GA2,
+	BRCMS_SROM_ITT5GA3,
+	BRCMS_SROM_MAXP2GA0,
+	BRCMS_SROM_MAXP2GA1,
+	BRCMS_SROM_MAXP2GA2,
+	BRCMS_SROM_MAXP2GA3,
+	BRCMS_SROM_MAXP5GA0,
+	BRCMS_SROM_MAXP5GA1,
+	BRCMS_SROM_MAXP5GA2,
+	BRCMS_SROM_MAXP5GA3,
+	BRCMS_SROM_MAXP5GHA0,
+	BRCMS_SROM_MAXP5GHA1,
+	BRCMS_SROM_MAXP5GHA2,
+	BRCMS_SROM_MAXP5GHA3,
+	BRCMS_SROM_MAXP5GLA0,
+	BRCMS_SROM_MAXP5GLA1,
+	BRCMS_SROM_MAXP5GLA2,
+	BRCMS_SROM_MAXP5GLA3,
+	BRCMS_SROM_PA2GW0A0,
+	BRCMS_SROM_PA2GW0A1,
+	BRCMS_SROM_PA2GW0A2,
+	BRCMS_SROM_PA2GW0A3,
+	BRCMS_SROM_PA2GW1A0,
+	BRCMS_SROM_PA2GW1A1,
+	BRCMS_SROM_PA2GW1A2,
+	BRCMS_SROM_PA2GW1A3,
+	BRCMS_SROM_PA2GW2A0,
+	BRCMS_SROM_PA2GW2A1,
+	BRCMS_SROM_PA2GW2A2,
+	BRCMS_SROM_PA2GW2A3,
+	BRCMS_SROM_PA2GW3A0,
+	BRCMS_SROM_PA2GW3A1,
+	BRCMS_SROM_PA2GW3A2,
+	BRCMS_SROM_PA2GW3A3,
+	BRCMS_SROM_PA5GHW0A0,
+	BRCMS_SROM_PA5GHW0A1,
+	BRCMS_SROM_PA5GHW0A2,
+	BRCMS_SROM_PA5GHW0A3,
+	BRCMS_SROM_PA5GHW1A0,
+	BRCMS_SROM_PA5GHW1A1,
+	BRCMS_SROM_PA5GHW1A2,
+	BRCMS_SROM_PA5GHW1A3,
+	BRCMS_SROM_PA5GHW2A0,
+	BRCMS_SROM_PA5GHW2A1,
+	BRCMS_SROM_PA5GHW2A2,
+	BRCMS_SROM_PA5GHW2A3,
+	BRCMS_SROM_PA5GHW3A0,
+	BRCMS_SROM_PA5GHW3A1,
+	BRCMS_SROM_PA5GHW3A2,
+	BRCMS_SROM_PA5GHW3A3,
+	BRCMS_SROM_PA5GLW0A0,
+	BRCMS_SROM_PA5GLW0A1,
+	BRCMS_SROM_PA5GLW0A2,
+	BRCMS_SROM_PA5GLW0A3,
+	BRCMS_SROM_PA5GLW1A0,
+	BRCMS_SROM_PA5GLW1A1,
+	BRCMS_SROM_PA5GLW1A2,
+	BRCMS_SROM_PA5GLW1A3,
+	BRCMS_SROM_PA5GLW2A0,
+	BRCMS_SROM_PA5GLW2A1,
+	BRCMS_SROM_PA5GLW2A2,
+	BRCMS_SROM_PA5GLW2A3,
+	BRCMS_SROM_PA5GLW3A0,
+	BRCMS_SROM_PA5GLW3A1,
+	BRCMS_SROM_PA5GLW3A2,
+	BRCMS_SROM_PA5GLW3A3,
+	BRCMS_SROM_PA5GW0A0,
+	BRCMS_SROM_PA5GW0A1,
+	BRCMS_SROM_PA5GW0A2,
+	BRCMS_SROM_PA5GW0A3,
+	BRCMS_SROM_PA5GW1A0,
+	BRCMS_SROM_PA5GW1A1,
+	BRCMS_SROM_PA5GW1A2,
+	BRCMS_SROM_PA5GW1A3,
+	BRCMS_SROM_PA5GW2A0,
+	BRCMS_SROM_PA5GW2A1,
+	BRCMS_SROM_PA5GW2A2,
+	BRCMS_SROM_PA5GW2A3,
+	BRCMS_SROM_PA5GW3A0,
+	BRCMS_SROM_PA5GW3A1,
+	BRCMS_SROM_PA5GW3A2,
+	BRCMS_SROM_PA5GW3A3,
+};
+
 #define	BRCMS_NUMRATES	16	/* max # of rates in a rateset */
 #define	D11_PHY_HDR_LEN	6	/* Phy header length - 6 bytes */
 
@@ -356,8 +614,8 @@ extern void brcms_c_ampdu_flush(struct brcms_c_info *wlc,
 			    struct ieee80211_sta *sta, u16 tid);
 extern void brcms_c_ampdu_tx_operational(struct brcms_c_info *wlc, u8 tid,
 					 u8 ba_wsize, uint max_rx_ampdu_bytes);
-extern char *getvar(struct si_pub *sih, const char *name);
-extern int getintvar(struct si_pub *sih, const char *name);
+extern char *getvar(struct si_pub *sih, enum brcms_srom_id id);
+extern int getintvar(struct si_pub *sih, enum brcms_srom_id id);
 
 /* wlc_phy.c helper functions */
 extern void brcms_c_set_ps_ctrl(struct brcms_c_info *wlc);
diff --git a/drivers/staging/brcm80211/brcmsmac/srom.c b/drivers/staging/brcm80211/brcmsmac/srom.c
index 524f1cc..c7a6e65 100644
--- a/drivers/staging/brcm80211/brcmsmac/srom.c
+++ b/drivers/staging/brcm80211/brcmsmac/srom.c
@@ -23,6 +23,7 @@
 
 #include <chipcommon.h>
 #include <brcmu_utils.h>
+#include "pub.h"
 #include "nicpci.h"
 #include "aiutils.h"
 #include "otp.h"
@@ -1243,18 +1244,289 @@ int srom_var_init(struct si_pub *sih, void __iomem *curmap, char **vars,
 	return -EINVAL;
 }
 
+struct srom_id_name {
+	enum brcms_srom_id id;
+	const char *name;
+};
+
+static const struct srom_id_name srom_id_map[] = {
+	{ BRCMS_SROM_AA2G, "aa2g" },
+	{ BRCMS_SROM_AA5G, "aa5g" },
+	{ BRCMS_SROM_AG0, "ag0" },
+	{ BRCMS_SROM_AG1, "ag1" },
+	{ BRCMS_SROM_AG2, "ag2" },
+	{ BRCMS_SROM_AG3, "ag3" },
+	{ BRCMS_SROM_ANTSWCTL2G, "antswctl2g" },
+	{ BRCMS_SROM_ANTSWCTL5G, "antswctl5g" },
+	{ BRCMS_SROM_ANTSWITCH, "antswitch" },
+	{ BRCMS_SROM_BOARDFLAGS2, "boardflags2" },
+	{ BRCMS_SROM_BOARDFLAGS, "boardflags" },
+	{ BRCMS_SROM_BOARDNUM, "boardnum" },
+	{ BRCMS_SROM_BOARDREV, "boardrev" },
+	{ BRCMS_SROM_BOARDTYPE, "boardtype" },
+	{ BRCMS_SROM_BW40PO, "bw40po" },
+	{ BRCMS_SROM_BWDUPPO, "bwduppo" },
+	{ BRCMS_SROM_BXA2G, "bxa2g" },
+	{ BRCMS_SROM_BXA5G, "bxa5g" },
+	{ BRCMS_SROM_CC, "cc" },
+	{ BRCMS_SROM_CCK2GPO, "cck2gpo" },
+	{ BRCMS_SROM_CCKBW202GPO, "cckbw202gpo" },
+	{ BRCMS_SROM_CCKBW20UL2GPO, "cckbw20ul2gpo" },
+	{ BRCMS_SROM_CCODE, "ccode" },
+	{ BRCMS_SROM_CDDPO, "cddpo" },
+	{ BRCMS_SROM_DEVID, "devid" },
+	{ BRCMS_SROM_ET1MACADDR, "et1macaddr" },
+	{ BRCMS_SROM_EXTPAGAIN2G, "extpagain2g" },
+	{ BRCMS_SROM_EXTPAGAIN5G, "extpagain5g" },
+	{ BRCMS_SROM_FREQOFFSET_CORR, "freqoffset_corr" },
+	{ BRCMS_SROM_HW_IQCAL_EN, "hw_iqcal_en" },
+	{ BRCMS_SROM_IL0MACADDR, "il0macaddr" },
+	{ BRCMS_SROM_IQCAL_SWP_DIS, "iqcal_swp_dis" },
+	{ BRCMS_SROM_LEDBH0, "ledbh0" },
+	{ BRCMS_SROM_LEDBH1, "ledbh1" },
+	{ BRCMS_SROM_LEDBH2, "ledbh2" },
+	{ BRCMS_SROM_LEDBH3, "ledbh3" },
+	{ BRCMS_SROM_LEDDC, "leddc" },
+	{ BRCMS_SROM_LEGOFDM40DUPPO, "legofdm40duppo" },
+	{ BRCMS_SROM_LEGOFDMBW202GPO, "legofdmbw202gpo" },
+	{ BRCMS_SROM_LEGOFDMBW205GHPO, "legofdmbw205ghpo" },
+	{ BRCMS_SROM_LEGOFDMBW205GLPO, "legofdmbw205glpo" },
+	{ BRCMS_SROM_LEGOFDMBW205GMPO, "legofdmbw205gmpo" },
+	{ BRCMS_SROM_LEGOFDMBW20UL2GPO, "legofdmbw20ul2gpo" },
+	{ BRCMS_SROM_LEGOFDMBW20UL5GHPO, "legofdmbw20ul5ghpo" },
+	{ BRCMS_SROM_LEGOFDMBW20UL5GLPO, "legofdmbw20ul5glpo" },
+	{ BRCMS_SROM_LEGOFDMBW20UL5GMPO, "legofdmbw20ul5gmpo" },
+	{ BRCMS_SROM_MACADDR, "macaddr" },
+	{ BRCMS_SROM_MCS2GPO0, "mcs2gpo0" },
+	{ BRCMS_SROM_MCS2GPO1, "mcs2gpo1" },
+	{ BRCMS_SROM_MCS2GPO2, "mcs2gpo2" },
+	{ BRCMS_SROM_MCS2GPO3, "mcs2gpo3" },
+	{ BRCMS_SROM_MCS2GPO4, "mcs2gpo4" },
+	{ BRCMS_SROM_MCS2GPO5, "mcs2gpo5" },
+	{ BRCMS_SROM_MCS2GPO6, "mcs2gpo6" },
+	{ BRCMS_SROM_MCS2GPO7, "mcs2gpo7" },
+	{ BRCMS_SROM_MCS32PO, "mcs32po" },
+	{ BRCMS_SROM_MCS5GHPO0, "mcs5ghpo0" },
+	{ BRCMS_SROM_MCS5GHPO1, "mcs5ghpo1" },
+	{ BRCMS_SROM_MCS5GHPO2, "mcs5ghpo2" },
+	{ BRCMS_SROM_MCS5GHPO3, "mcs5ghpo3" },
+	{ BRCMS_SROM_MCS5GHPO4, "mcs5ghpo4" },
+	{ BRCMS_SROM_MCS5GHPO5, "mcs5ghpo5" },
+	{ BRCMS_SROM_MCS5GHPO6, "mcs5ghpo6" },
+	{ BRCMS_SROM_MCS5GHPO7, "mcs5ghpo7" },
+	{ BRCMS_SROM_MCS5GLPO0, "mcs5glpo0" },
+	{ BRCMS_SROM_MCS5GLPO1, "mcs5glpo1" },
+	{ BRCMS_SROM_MCS5GLPO2, "mcs5glpo2" },
+	{ BRCMS_SROM_MCS5GLPO3, "mcs5glpo3" },
+	{ BRCMS_SROM_MCS5GLPO4, "mcs5glpo4" },
+	{ BRCMS_SROM_MCS5GLPO5, "mcs5glpo5" },
+	{ BRCMS_SROM_MCS5GLPO6, "mcs5glpo6" },
+	{ BRCMS_SROM_MCS5GLPO7, "mcs5glpo7" },
+	{ BRCMS_SROM_MCS5GPO0, "mcs5gpo0" },
+	{ BRCMS_SROM_MCS5GPO1, "mcs5gpo1" },
+	{ BRCMS_SROM_MCS5GPO2, "mcs5gpo2" },
+	{ BRCMS_SROM_MCS5GPO3, "mcs5gpo3" },
+	{ BRCMS_SROM_MCS5GPO4, "mcs5gpo4" },
+	{ BRCMS_SROM_MCS5GPO5, "mcs5gpo5" },
+	{ BRCMS_SROM_MCS5GPO6, "mcs5gpo6" },
+	{ BRCMS_SROM_MCS5GPO7, "mcs5gpo7" },
+	{ BRCMS_SROM_MCSBW202GPO, "mcsbw202gpo" },
+	{ BRCMS_SROM_MCSBW205GHPO, "mcsbw205ghpo" },
+	{ BRCMS_SROM_MCSBW205GLPO, "mcsbw205glpo" },
+	{ BRCMS_SROM_MCSBW205GMPO, "mcsbw205gmpo" },
+	{ BRCMS_SROM_MCSBW20UL2GPO, "mcsbw20ul2gpo" },
+	{ BRCMS_SROM_MCSBW20UL5GHPO, "mcsbw20ul5ghpo" },
+	{ BRCMS_SROM_MCSBW20UL5GLPO, "mcsbw20ul5glpo" },
+	{ BRCMS_SROM_MCSBW20UL5GMPO, "mcsbw20ul5gmpo" },
+	{ BRCMS_SROM_MCSBW402GPO, "mcsbw402gpo" },
+	{ BRCMS_SROM_MCSBW405GHPO, "mcsbw405ghpo" },
+	{ BRCMS_SROM_MCSBW405GLPO, "mcsbw405glpo" },
+	{ BRCMS_SROM_MCSBW405GMPO, "mcsbw405gmpo" },
+	{ BRCMS_SROM_MEASPOWER, "measpower" },
+	{ BRCMS_SROM_OFDM2GPO, "ofdm2gpo" },
+	{ BRCMS_SROM_OFDM5GHPO, "ofdm5ghpo" },
+	{ BRCMS_SROM_OFDM5GLPO, "ofdm5glpo" },
+	{ BRCMS_SROM_OFDM5GPO, "ofdm5gpo" },
+	{ BRCMS_SROM_OPO, "opo" },
+	{ BRCMS_SROM_PA0B0, "pa0b0" },
+	{ BRCMS_SROM_PA0B1, "pa0b1" },
+	{ BRCMS_SROM_PA0B2, "pa0b2" },
+	{ BRCMS_SROM_PA0ITSSIT, "pa0itssit" },
+	{ BRCMS_SROM_PA0MAXPWR, "pa0maxpwr" },
+	{ BRCMS_SROM_PA1B0, "pa1b0" },
+	{ BRCMS_SROM_PA1B1, "pa1b1" },
+	{ BRCMS_SROM_PA1B2, "pa1b2" },
+	{ BRCMS_SROM_PA1HIB0, "pa1hib0" },
+	{ BRCMS_SROM_PA1HIB1, "pa1hib1" },
+	{ BRCMS_SROM_PA1HIB2, "pa1hib2" },
+	{ BRCMS_SROM_PA1HIMAXPWR, "pa1himaxpwr" },
+	{ BRCMS_SROM_PA1ITSSIT, "pa1itssit" },
+	{ BRCMS_SROM_PA1LOB0, "pa1lob0" },
+	{ BRCMS_SROM_PA1LOB1, "pa1lob1" },
+	{ BRCMS_SROM_PA1LOB2, "pa1lob2" },
+	{ BRCMS_SROM_PA1LOMAXPWR, "pa1lomaxpwr" },
+	{ BRCMS_SROM_PA1MAXPWR, "pa1maxpwr" },
+	{ BRCMS_SROM_PDETRANGE2G, "pdetrange2g" },
+	{ BRCMS_SROM_PDETRANGE5G, "pdetrange5g" },
+	{ BRCMS_SROM_PHYCAL_TEMPDELTA, "phycal_tempdelta" },
+	{ BRCMS_SROM_RAWTEMPSENSE, "rawtempsense" },
+	{ BRCMS_SROM_REV, "sromrev" },
+	{ BRCMS_SROM_REGREV, "regrev" },
+	{ BRCMS_SROM_RSSISAV2G, "rssisav2g" },
+	{ BRCMS_SROM_RSSISAV5G, "rssisav5g" },
+	{ BRCMS_SROM_RSSISMC2G, "rssismc2g" },
+	{ BRCMS_SROM_RSSISMC5G, "rssismc5g" },
+	{ BRCMS_SROM_RSSISMF2G, "rssismf2g" },
+	{ BRCMS_SROM_RSSISMF5G, "rssismf5g" },
+	{ BRCMS_SROM_RXCHAIN, "rxchain" },
+	{ BRCMS_SROM_RXPO2G, "rxpo2g" },
+	{ BRCMS_SROM_RXPO5G, "rxpo5g" },
+	{ BRCMS_SROM_STBCPO, "stbcpo" },
+	{ BRCMS_SROM_TEMPCORRX, "tempcorrx" },
+	{ BRCMS_SROM_TEMPOFFSET, "tempoffset" },
+	{ BRCMS_SROM_TEMPSENSE_OPTION, "tempsense_option" },
+	{ BRCMS_SROM_TEMPSENSE_SLOPE, "tempsense_slope" },
+	{ BRCMS_SROM_TEMPTHRESH, "tempthresh" },
+	{ BRCMS_SROM_TRI2G, "tri2g" },
+	{ BRCMS_SROM_TRI5GH, "tri5gh" },
+	{ BRCMS_SROM_TRI5GL, "tri5gl" },
+	{ BRCMS_SROM_TRI5G, "tri5g" },
+	{ BRCMS_SROM_TRISO2G, "triso2g" },
+	{ BRCMS_SROM_TRISO5G, "triso5g" },
+	{ BRCMS_SROM_TSSIPOS2G, "tssipos2g" },
+	{ BRCMS_SROM_TSSIPOS5G, "tssipos5g" },
+	{ BRCMS_SROM_TXCHAIN, "txchain" },
+	{ BRCMS_SROM_TXPID2GA0, "txpid2ga0" },
+	{ BRCMS_SROM_TXPID2GA1, "txpid2ga1" },
+	{ BRCMS_SROM_TXPID2GA2, "txpid2ga2" },
+	{ BRCMS_SROM_TXPID2GA3, "txpid2ga3" },
+	{ BRCMS_SROM_TXPID5GA0, "txpid5ga0" },
+	{ BRCMS_SROM_TXPID5GA1, "txpid5ga1" },
+	{ BRCMS_SROM_TXPID5GA2, "txpid5ga2" },
+	{ BRCMS_SROM_TXPID5GA3, "txpid5ga3" },
+	{ BRCMS_SROM_TXPID5GHA0, "txpid5gha0" },
+	{ BRCMS_SROM_TXPID5GHA1, "txpid5gha1" },
+	{ BRCMS_SROM_TXPID5GHA2, "txpid5gha2" },
+	{ BRCMS_SROM_TXPID5GHA3, "txpid5gha3" },
+	{ BRCMS_SROM_TXPID5GLA0, "txpid5gla0" },
+	{ BRCMS_SROM_TXPID5GLA1, "txpid5gla1" },
+	{ BRCMS_SROM_TXPID5GLA2, "txpid5gla2" },
+	{ BRCMS_SROM_TXPID5GLA3, "txpid5gla3" },
+	{ BRCMS_SROM_ITT2GA0, "itt2ga0" },
+	{ BRCMS_SROM_ITT2GA1, "itt2ga1" },
+	{ BRCMS_SROM_ITT2GA2, "itt2ga2" },
+	{ BRCMS_SROM_ITT2GA3, "itt2ga3" },
+	{ BRCMS_SROM_ITT5GA0, "itt5ga0" },
+	{ BRCMS_SROM_ITT5GA1, "itt5ga1" },
+	{ BRCMS_SROM_ITT5GA2, "itt5ga2" },
+	{ BRCMS_SROM_ITT5GA3, "itt5ga3" },
+	{ BRCMS_SROM_MAXP2GA0, "maxp2ga0" },
+	{ BRCMS_SROM_MAXP2GA1, "maxp2ga1" },
+	{ BRCMS_SROM_MAXP2GA2, "maxp2ga2" },
+	{ BRCMS_SROM_MAXP2GA3, "maxp2ga3" },
+	{ BRCMS_SROM_MAXP5GA0, "maxp5ga0" },
+	{ BRCMS_SROM_MAXP5GA1, "maxp5ga1" },
+	{ BRCMS_SROM_MAXP5GA2, "maxp5ga2" },
+	{ BRCMS_SROM_MAXP5GA3, "maxp5ga3" },
+	{ BRCMS_SROM_MAXP5GHA0, "maxp5gha0" },
+	{ BRCMS_SROM_MAXP5GHA1, "maxp5gha1" },
+	{ BRCMS_SROM_MAXP5GHA2, "maxp5gha2" },
+	{ BRCMS_SROM_MAXP5GHA3, "maxp5gha3" },
+	{ BRCMS_SROM_MAXP5GLA0, "maxp5gla0" },
+	{ BRCMS_SROM_MAXP5GLA1, "maxp5gla1" },
+	{ BRCMS_SROM_MAXP5GLA2, "maxp5gla2" },
+	{ BRCMS_SROM_MAXP5GLA3, "maxp5gla3" },
+	{ BRCMS_SROM_PA2GW0A0, "pa2gw0a0" },
+	{ BRCMS_SROM_PA2GW0A1, "pa2gw0a1" },
+	{ BRCMS_SROM_PA2GW0A2, "pa2gw0a2" },
+	{ BRCMS_SROM_PA2GW0A3, "pa2gw0a3" },
+	{ BRCMS_SROM_PA2GW1A0, "pa2gw1a0" },
+	{ BRCMS_SROM_PA2GW1A1, "pa2gw1a1" },
+	{ BRCMS_SROM_PA2GW1A2, "pa2gw1a2" },
+	{ BRCMS_SROM_PA2GW1A3, "pa2gw1a3" },
+	{ BRCMS_SROM_PA2GW2A0, "pa2gw2a0" },
+	{ BRCMS_SROM_PA2GW2A1, "pa2gw2a1" },
+	{ BRCMS_SROM_PA2GW2A2, "pa2gw2a2" },
+	{ BRCMS_SROM_PA2GW2A3, "pa2gw2a3" },
+	{ BRCMS_SROM_PA2GW3A0, "pa2gw3a0" },
+	{ BRCMS_SROM_PA2GW3A1, "pa2gw3a1" },
+	{ BRCMS_SROM_PA2GW3A2, "pa2gw3a2" },
+	{ BRCMS_SROM_PA2GW3A3, "pa2gw3a3" },
+	{ BRCMS_SROM_PA5GHW0A0, "pa5ghw0a0" },
+	{ BRCMS_SROM_PA5GHW0A1, "pa5ghw0a1" },
+	{ BRCMS_SROM_PA5GHW0A2, "pa5ghw0a2" },
+	{ BRCMS_SROM_PA5GHW0A3, "pa5ghw0a3" },
+	{ BRCMS_SROM_PA5GHW1A0, "pa5ghw1a0" },
+	{ BRCMS_SROM_PA5GHW1A1, "pa5ghw1a1" },
+	{ BRCMS_SROM_PA5GHW1A2, "pa5ghw1a2" },
+	{ BRCMS_SROM_PA5GHW1A3, "pa5ghw1a3" },
+	{ BRCMS_SROM_PA5GHW2A0, "pa5ghw2a0" },
+	{ BRCMS_SROM_PA5GHW2A1, "pa5ghw2a1" },
+	{ BRCMS_SROM_PA5GHW2A2, "pa5ghw2a2" },
+	{ BRCMS_SROM_PA5GHW2A3, "pa5ghw2a3" },
+	{ BRCMS_SROM_PA5GHW3A0, "pa5ghw3a0" },
+	{ BRCMS_SROM_PA5GHW3A1, "pa5ghw3a1" },
+	{ BRCMS_SROM_PA5GHW3A2, "pa5ghw3a2" },
+	{ BRCMS_SROM_PA5GHW3A3, "pa5ghw3a3" },
+	{ BRCMS_SROM_PA5GLW0A0, "pa5glw0a0" },
+	{ BRCMS_SROM_PA5GLW0A1, "pa5glw0a1" },
+	{ BRCMS_SROM_PA5GLW0A2, "pa5glw0a2" },
+	{ BRCMS_SROM_PA5GLW0A3, "pa5glw0a3" },
+	{ BRCMS_SROM_PA5GLW1A0, "pa5glw1a0" },
+	{ BRCMS_SROM_PA5GLW1A1, "pa5glw1a1" },
+	{ BRCMS_SROM_PA5GLW1A2, "pa5glw1a2" },
+	{ BRCMS_SROM_PA5GLW1A3, "pa5glw1a3" },
+	{ BRCMS_SROM_PA5GLW2A0, "pa5glw2a0" },
+	{ BRCMS_SROM_PA5GLW2A1, "pa5glw2a1" },
+	{ BRCMS_SROM_PA5GLW2A2, "pa5glw2a2" },
+	{ BRCMS_SROM_PA5GLW2A3, "pa5glw2a3" },
+	{ BRCMS_SROM_PA5GLW3A0, "pa5glw3a0" },
+	{ BRCMS_SROM_PA5GLW3A1, "pa5glw3a1" },
+	{ BRCMS_SROM_PA5GLW3A2, "pa5glw3a2" },
+	{ BRCMS_SROM_PA5GLW3A3, "pa5glw3a3" },
+	{ BRCMS_SROM_PA5GW0A0, "pa5gw0a0" },
+	{ BRCMS_SROM_PA5GW0A1, "pa5gw0a1" },
+	{ BRCMS_SROM_PA5GW0A2, "pa5gw0a2" },
+	{ BRCMS_SROM_PA5GW0A3, "pa5gw0a3" },
+	{ BRCMS_SROM_PA5GW1A0, "pa5gw1a0" },
+	{ BRCMS_SROM_PA5GW1A1, "pa5gw1a1" },
+	{ BRCMS_SROM_PA5GW1A2, "pa5gw1a2" },
+	{ BRCMS_SROM_PA5GW1A3, "pa5gw1a3" },
+	{ BRCMS_SROM_PA5GW2A0, "pa5gw2a0" },
+	{ BRCMS_SROM_PA5GW2A1, "pa5gw2a1" },
+	{ BRCMS_SROM_PA5GW2A2, "pa5gw2a2" },
+	{ BRCMS_SROM_PA5GW2A3, "pa5gw2a3" },
+	{ BRCMS_SROM_PA5GW3A0, "pa5gw3a0" },
+	{ BRCMS_SROM_PA5GW3A1, "pa5gw3a1" },
+	{ BRCMS_SROM_PA5GW3A2, "pa5gw3a2" },
+	{ BRCMS_SROM_PA5GW3A3, "pa5gw3a3" },
+};
+
+static const char *get_varname(enum brcms_srom_id id)
+{
+	const struct srom_id_name *entry;
+	int i;
+
+	entry = &srom_id_map[0];
+	for (i = 0; i < ARRAY_SIZE(srom_id_map); i++) {
+		if (entry->id == id)
+			return entry->name;
+		entry++;
+	}
+	return NULL;
+}
+
 /*
  * Search the name=value vars for a specific one and return its value.
  * Returns NULL if not found.
  */
-char *getvar(struct si_pub *sih, const char *name)
+char *getvar(struct si_pub *sih, enum brcms_srom_id id)
 {
+	const char *name = get_varname(id);
 	char *s;
 	int len;
 	struct si_info *sii;
 
-	sii = (struct si_info *)sih;
-
 	if (!name)
 		return NULL;
 
@@ -1262,6 +1534,8 @@ char *getvar(struct si_pub *sih, const char *name)
 	if (len == 0)
 		return NULL;
 
+	sii = (struct si_info *)sih;
+
 	/* first look in vars[] */
 	for (s = sii->vars; s && *s;) {
 		if ((memcmp(s, name, len) == 0) && (s[len] == '='))
@@ -1278,12 +1552,12 @@ char *getvar(struct si_pub *sih, const char *name)
  * Search the vars for a specific one and return its value as
  * an integer. Returns 0 if not found.
  */
-int getintvar(struct si_pub *sih, const char *name)
+int getintvar(struct si_pub *sih, enum brcms_srom_id id)
 {
 	char *val;
 	unsigned long res;
 
-	val = getvar(sih, name);
+	val = getvar(sih, id);
 	if (val && !kstrtoul(val, 0, &res))
 		return res;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/stf.c b/drivers/staging/brcm80211/brcmsmac/stf.c
index 3ce9049..f1bd1bf 100644
--- a/drivers/staging/brcm80211/brcmsmac/stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/stf.c
@@ -373,8 +373,8 @@ void brcms_c_stf_phy_txant_upd(struct brcms_c_info *wlc)
 void brcms_c_stf_phy_chain_calc(struct brcms_c_info *wlc)
 {
 	/* get available rx/tx chains */
-	wlc->stf->hw_txchain = (u8) getintvar(wlc->hw->sih, "txchain");
-	wlc->stf->hw_rxchain = (u8) getintvar(wlc->hw->sih, "rxchain");
+	wlc->stf->hw_txchain = (u8) getintvar(wlc->hw->sih, BRCMS_SROM_TXCHAIN);
+	wlc->stf->hw_rxchain = (u8) getintvar(wlc->hw->sih, BRCMS_SROM_RXCHAIN);
 
 	/* these parameter are intended to be used for all PHY types */
 	if (wlc->stf->hw_txchain == 0 || wlc->stf->hw_txchain == 0xf) {
-- 
1.7.4.1


