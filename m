Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44910 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618Ab2D2AvS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2012 20:51:18 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 01/19] brcmsmac: use sprom from bcma
Date: Sun, 29 Apr 2012 02:50:25 +0200
Message-Id: <1335660643-26368-2-git-send-email-hauke@hauke-m.de> (sfid-20120429_025143_627590_305AD15B)
In-Reply-To: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
References: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

bcma now provides all sprom attributes needed by brcmsmac and also
parses them from the pci sprom ant otp.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c  |    4 +-
 drivers/net/wireless/brcm80211/brcmsmac/antsel.c   |   16 +-
 drivers/net/wireless/brcm80211/brcmsmac/channel.c  |    7 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |   66 ++--
 drivers/net/wireless/brcm80211/brcmsmac/nicpci.c   |    5 +-
 .../net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c  |   67 ++--
 .../net/wireless/brcm80211/brcmsmac/phy/phy_n.c    |  331 +++++++-------------
 drivers/net/wireless/brcm80211/brcmsmac/stf.c      |    6 +-
 8 files changed, 179 insertions(+), 323 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index c93ea35..f0cef23 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -564,6 +564,7 @@ static struct si_info *ai_doattach(struct si_info *sii,
 	u32 w, savewin;
 	struct bcma_device *cc;
 	uint socitype;
+	struct ssb_sprom *sprom = &pbus->sprom;
 
 	savewin = 0;
 
@@ -617,7 +618,8 @@ static struct si_info *ai_doattach(struct si_info *sii,
 	}
 
 	/* setup the GPIO based LED powersave register */
-	w = getintvar(sih, BRCMS_SROM_LEDDC);
+	w = (sprom->leddc_on_time << BCMA_CC_GPIOTIMER_ONTIME_SHIFT) |
+		 (sprom->leddc_off_time << BCMA_CC_GPIOTIMER_OFFTIME_SHIFT);
 	if (w == 0)
 		w = DEFAULT_GPIOTIMERVAL;
 	ai_cc_reg(sih, offsetof(struct chipcregs, gpiotimerval),
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/antsel.c b/drivers/net/wireless/brcm80211/brcmsmac/antsel.c
index a47ce25..55e12c3 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/antsel.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/antsel.c
@@ -108,7 +108,7 @@ brcms_c_antsel_init_cfg(struct antsel_info *asi, struct brcms_antselcfg *antsel,
 struct antsel_info *brcms_c_antsel_attach(struct brcms_c_info *wlc)
 {
 	struct antsel_info *asi;
-	struct si_pub *sih = wlc->hw->sih;
+	struct ssb_sprom *sprom = &wlc->hw->d11core->bus->sprom;
 
 	asi = kzalloc(sizeof(struct antsel_info), GFP_ATOMIC);
 	if (!asi)
@@ -118,7 +118,7 @@ struct antsel_info *brcms_c_antsel_attach(struct brcms_c_info *wlc)
 	asi->pub = wlc->pub;
 	asi->antsel_type = ANTSEL_NA;
 	asi->antsel_avail = false;
-	asi->antsel_antswitch = (u8) getintvar(sih, BRCMS_SROM_ANTSWITCH);
+	asi->antsel_antswitch = sprom->antswitch;
 
 	if ((asi->pub->sromrev >= 4) && (asi->antsel_antswitch != 0)) {
 		switch (asi->antsel_antswitch) {
@@ -128,12 +128,12 @@ struct antsel_info *brcms_c_antsel_attach(struct brcms_c_info *wlc)
 			/* 4321/2 board with 2x3 switch logic */
 			asi->antsel_type = ANTSEL_2x3;
 			/* Antenna selection availability */
-			if (((u16) getintvar(sih, BRCMS_SROM_AA2G) == 7) ||
-			    ((u16) getintvar(sih, BRCMS_SROM_AA5G) == 7)) {
+			if ((sprom->ant_available_bg == 7) ||
+			    (sprom->ant_available_a == 7)) {
 				asi->antsel_avail = true;
 			} else if (
-				(u16) getintvar(sih, BRCMS_SROM_AA2G) == 3 ||
-				(u16) getintvar(sih, BRCMS_SROM_AA5G) == 3) {
+				sprom->ant_available_bg == 3 ||
+				sprom->ant_available_a == 3) {
 				asi->antsel_avail = false;
 			} else {
 				asi->antsel_avail = false;
@@ -146,8 +146,8 @@ struct antsel_info *brcms_c_antsel_attach(struct brcms_c_info *wlc)
 			break;
 		}
 	} else if ((asi->pub->sromrev == 4) &&
-		   ((u16) getintvar(sih, BRCMS_SROM_AA2G) == 7) &&
-		   ((u16) getintvar(sih, BRCMS_SROM_AA5G) == 0)) {
+		   (sprom->ant_available_bg == 7) &&
+		   (sprom->ant_available_a == 0)) {
 		/* hack to match old 4321CB2 cards with 2of3 antenna switch */
 		asi->antsel_type = ANTSEL_2x3;
 		asi->antsel_avail = true;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
index 0efe88e..eb77ac3 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/channel.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
@@ -1110,7 +1110,7 @@ struct brcms_cm_info *brcms_c_channel_mgr_attach(struct brcms_c_info *wlc)
 	char country_abbrev[BRCM_CNTRY_BUF_SZ];
 	const struct country_info *country;
 	struct brcms_pub *pub = wlc->pub;
-	char *ccode;
+	struct ssb_sprom *sprom = &wlc->hw->d11core->bus->sprom;
 
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 
@@ -1122,9 +1122,8 @@ struct brcms_cm_info *brcms_c_channel_mgr_attach(struct brcms_c_info *wlc)
 	wlc->cmi = wlc_cm;
 
 	/* store the country code for passing up as a regulatory hint */
-	ccode = getvar(wlc->hw->sih, BRCMS_SROM_CCODE);
-	if (ccode && brcms_c_country_valid(ccode))
-		strncpy(wlc->pub->srom_ccode, ccode, BRCM_CNTRY_BUF_SZ - 1);
+	if (sprom->alpha2 && brcms_c_country_valid(sprom->alpha2))
+		strncpy(wlc->pub->srom_ccode, sprom->alpha2, sizeof(sprom->alpha2));
 
 	/*
 	 * internal country information which must match
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index b4d9279..b9ab8de 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -1882,27 +1882,20 @@ static bool brcms_c_validboardtype(struct brcms_hardware *wlc_hw)
 	return true;
 }
 
-static char *brcms_c_get_macaddr(struct brcms_hardware *wlc_hw)
+static void brcms_c_get_macaddr(struct brcms_hardware *wlc_hw, u8 etheraddr[ETH_ALEN])
 {
-	enum brcms_srom_id var_id = BRCMS_SROM_MACADDR;
-	char *macaddr;
+	struct ssb_sprom *sprom = &wlc_hw->d11core->bus->sprom;
 
 	/* If macaddr exists, use it (Sromrev4, CIS, ...). */
-	macaddr = getvar(wlc_hw->sih, var_id);
-	if (macaddr != NULL)
-		return macaddr;
+	if (!is_zero_ether_addr(sprom->il0mac)) {
+		memcpy(etheraddr, sprom->il0mac, 6);
+		return;
+	}
 
 	if (wlc_hw->_nbands > 1)
-		var_id = BRCMS_SROM_ET1MACADDR;
+		memcpy(etheraddr, sprom->et1mac, 6);
 	else
-		var_id = BRCMS_SROM_IL0MACADDR;
-
-	macaddr = getvar(wlc_hw->sih, var_id);
-	if (macaddr == NULL)
-		wiphy_err(wlc_hw->wlc->wiphy, "wl%d: wlc_get_macaddr: macaddr "
-			  "getvar(%d) not found\n", wlc_hw->unit, var_id);
-
-	return macaddr;
+		memcpy(etheraddr, sprom->il0mac, 6);
 }
 
 /* power both the pll and external oscillator on/off */
@@ -4436,13 +4429,13 @@ static int brcms_b_attach(struct brcms_c_info *wlc, struct bcma_device *core,
 			  uint unit, bool piomode)
 {
 	struct brcms_hardware *wlc_hw;
-	char *macaddr = NULL;
 	uint err = 0;
 	uint j;
 	bool wme = false;
 	struct shared_phy_params sha_params;
 	struct wiphy *wiphy = wlc->wiphy;
 	struct pci_dev *pcidev = core->bus->host_pci;
+	struct ssb_sprom *sprom = &core->bus->sprom;
 
 	BCMMSG(wlc->wiphy, "wl%d: vendor 0x%x device 0x%x\n", unit,
 	       pcidev->vendor,
@@ -4512,7 +4505,7 @@ static int brcms_b_attach(struct brcms_c_info *wlc, struct bcma_device *core,
 	}
 
 	/* get the board rev, used just below */
-	j = getintvar(wlc_hw->sih, BRCMS_SROM_BOARDREV);
+	j = sprom->board_rev;
 	/* promote srom boardrev of 0xFF to 1 */
 	if (j == BOARDREV_PROMOTABLE)
 		j = BOARDREV_PROMOTED;
@@ -4525,11 +4518,9 @@ static int brcms_b_attach(struct brcms_c_info *wlc, struct bcma_device *core,
 		err = 15;
 		goto fail;
 	}
-	wlc_hw->sromrev = (u8) getintvar(wlc_hw->sih, BRCMS_SROM_REV);
-	wlc_hw->boardflags = (u32) getintvar(wlc_hw->sih,
-					     BRCMS_SROM_BOARDFLAGS);
-	wlc_hw->boardflags2 = (u32) getintvar(wlc_hw->sih,
-					      BRCMS_SROM_BOARDFLAGS2);
+	wlc_hw->sromrev = sprom->revision;
+	wlc_hw->boardflags = sprom->boardflags_lo + (sprom->boardflags_hi << 16);
+	wlc_hw->boardflags2 = sprom->boardflags2_lo + (sprom->boardflags2_hi << 16);
 
 	if (wlc_hw->boardflags & BFL_NOPLLDOWN)
 		brcms_b_pllreq(wlc_hw, true, BRCMS_PLLREQ_SHARED);
@@ -4702,25 +4693,18 @@ static int brcms_b_attach(struct brcms_c_info *wlc, struct bcma_device *core,
 	 */
 
 	/* init etheraddr state variables */
-	macaddr = brcms_c_get_macaddr(wlc_hw);
-	if (macaddr == NULL) {
-		wiphy_err(wiphy, "wl%d: brcms_b_attach: macaddr not found\n",
-			  unit);
-		err = 21;
-		goto fail;
-	}
-	if (!mac_pton(macaddr, wlc_hw->etheraddr) ||
-	    is_broadcast_ether_addr(wlc_hw->etheraddr) ||
+	brcms_c_get_macaddr(wlc_hw, wlc_hw->etheraddr);
+	 
+	if (is_broadcast_ether_addr(wlc_hw->etheraddr) ||
 	    is_zero_ether_addr(wlc_hw->etheraddr)) {
-		wiphy_err(wiphy, "wl%d: brcms_b_attach: bad macaddr %s\n",
-			  unit, macaddr);
+		wiphy_err(wiphy, "wl%d: brcms_b_attach: bad macaddr\n",
+			  unit);
 		err = 22;
 		goto fail;
 	}
 
-	BCMMSG(wlc->wiphy, "deviceid 0x%x nbands %d board 0x%x macaddr: %s\n",
-	       wlc_hw->deviceid, wlc_hw->_nbands, ai_get_boardtype(wlc_hw->sih),
-	       macaddr);
+	BCMMSG(wlc->wiphy, "deviceid 0x%x nbands %d board 0x%x\n",
+	       wlc_hw->deviceid, wlc_hw->_nbands, ai_get_boardtype(wlc_hw->sih));
 
 	return err;
 
@@ -4770,16 +4754,16 @@ static bool brcms_c_attach_stf_ant_init(struct brcms_c_info *wlc)
 	int aa;
 	uint unit;
 	int bandtype;
-	struct si_pub *sih = wlc->hw->sih;
+	struct ssb_sprom *sprom = &wlc->hw->d11core->bus->sprom;
 
 	unit = wlc->pub->unit;
 	bandtype = wlc->band->bandtype;
 
 	/* get antennas available */
 	if (bandtype == BRCM_BAND_5G)
-		aa = (s8) getintvar(sih, BRCMS_SROM_AA5G);
+		aa = sprom->ant_available_a;
 	else
-		aa = (s8) getintvar(sih, BRCMS_SROM_AA2G);
+		aa = sprom->ant_available_bg;
 
 	if ((aa < 1) || (aa > 15)) {
 		wiphy_err(wlc->wiphy, "wl%d: %s: Invalid antennas available in"
@@ -4799,9 +4783,9 @@ static bool brcms_c_attach_stf_ant_init(struct brcms_c_info *wlc)
 
 	/* Compute Antenna Gain */
 	if (bandtype == BRCM_BAND_5G)
-		wlc->band->antgain = (s8) getintvar(sih, BRCMS_SROM_AG1);
+		wlc->band->antgain = sprom->antenna_gain.a1;
 	else
-		wlc->band->antgain = (s8) getintvar(sih, BRCMS_SROM_AG0);
+		wlc->band->antgain = sprom->antenna_gain.a0;
 
 	brcms_c_attach_antgain_init(wlc);
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
index 7fad6dc..239927c 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
@@ -714,7 +714,10 @@ static void pcie_war_pci_setup(struct pcicore_info *pi)
 void pcicore_attach(struct pcicore_info *pi, int state)
 {
 	struct si_pub *sih = pi->sih;
-	u32 bfl2 = (u32)getintvar(sih, BRCMS_SROM_BOARDFLAGS2);
+	struct ssb_sprom *sprom = &pi->core->bus->sprom;
+	u32 bfl2;
+	
+	bfl2 = sprom->boardflags2_lo + (sprom->boardflags2_hi << 16);
 
 	/* Determine if this board needs override */
 	if (PCIE_ASPM(sih)) {
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
index 0fce56235..abfd788 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -4817,28 +4817,23 @@ static bool wlc_phy_txpwr_srom_read_lcnphy(struct brcms_phy *pi)
 	s8 txpwr = 0;
 	int i;
 	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
-	struct phy_shim_info *shim = pi->sh->physhim;
+	struct ssb_sprom *sprom = &pi->d11core->bus->sprom;
 
 	if (CHSPEC_IS2G(pi->radio_chanspec)) {
 		u16 cckpo = 0;
 		u32 offset_ofdm, offset_mcs;
 
-		pi_lcn->lcnphy_tr_isolation_mid =
-			(u8)wlapi_getintvar(shim, BRCMS_SROM_TRISO2G);
+		pi_lcn->lcnphy_tr_isolation_mid = sprom->fem.ghz2.tr_iso;
 
-		pi_lcn->lcnphy_rx_power_offset =
-			(u8)wlapi_getintvar(shim, BRCMS_SROM_RXPO2G);
+		pi_lcn->lcnphy_rx_power_offset = sprom->rxpo2g;
 
-		pi->txpa_2g[0] = (s16)wlapi_getintvar(shim, BRCMS_SROM_PA0B0);
-		pi->txpa_2g[1] = (s16)wlapi_getintvar(shim, BRCMS_SROM_PA0B1);
-		pi->txpa_2g[2] = (s16)wlapi_getintvar(shim, BRCMS_SROM_PA0B2);
+		pi->txpa_2g[0] = sprom->pa0b0;
+		pi->txpa_2g[1] = sprom->pa0b1;
+		pi->txpa_2g[2] = sprom->pa0b2;
 
-		pi_lcn->lcnphy_rssi_vf =
-				(u8)wlapi_getintvar(shim, BRCMS_SROM_RSSISMF2G);
-		pi_lcn->lcnphy_rssi_vc =
-				(u8)wlapi_getintvar(shim, BRCMS_SROM_RSSISMC2G);
-		pi_lcn->lcnphy_rssi_gs =
-				(u8)wlapi_getintvar(shim, BRCMS_SROM_RSSISAV2G);
+		pi_lcn->lcnphy_rssi_vf = sprom->rssismf2g;
+		pi_lcn->lcnphy_rssi_vc = sprom->rssismc2g;
+		pi_lcn->lcnphy_rssi_gs = sprom->rssisav2g;
 
 		pi_lcn->lcnphy_rssi_vf_lowtemp = pi_lcn->lcnphy_rssi_vf;
 		pi_lcn->lcnphy_rssi_vc_lowtemp = pi_lcn->lcnphy_rssi_vc;
@@ -4848,7 +4843,7 @@ static bool wlc_phy_txpwr_srom_read_lcnphy(struct brcms_phy *pi)
 		pi_lcn->lcnphy_rssi_vc_hightemp = pi_lcn->lcnphy_rssi_vc;
 		pi_lcn->lcnphy_rssi_gs_hightemp = pi_lcn->lcnphy_rssi_gs;
 
-		txpwr = (s8)wlapi_getintvar(shim, BRCMS_SROM_MAXP2GA0);
+		txpwr = sprom->core_pwr_info[0].maxpwr_2g;
 		pi->tx_srom_max_2g = txpwr;
 
 		for (i = 0; i < PWRTBL_NUM_COEFF; i++) {
@@ -4856,8 +4851,8 @@ static bool wlc_phy_txpwr_srom_read_lcnphy(struct brcms_phy *pi)
 			pi->txpa_2g_high_temp[i] = pi->txpa_2g[i];
 		}
 
-		cckpo = (u16)wlapi_getintvar(shim, BRCMS_SROM_CCK2GPO);
-		offset_ofdm = (u32)wlapi_getintvar(shim, BRCMS_SROM_OFDM2GPO);
+		cckpo = sprom->cck2gpo;
+		offset_ofdm = sprom->ofdm2gpo;
 		if (cckpo) {
 			uint max_pwr_chan = txpwr;
 
@@ -4876,7 +4871,7 @@ static bool wlc_phy_txpwr_srom_read_lcnphy(struct brcms_phy *pi)
 		} else {
 			u8 opo = 0;
 
-			opo = (u8)wlapi_getintvar(shim, BRCMS_SROM_OPO);
+			opo = sprom->opo;
 
 			for (i = TXP_FIRST_CCK; i <= TXP_LAST_CCK; i++)
 				pi->tx_srom_max_rate_2g[i] = txpwr;
@@ -4886,12 +4881,8 @@ static bool wlc_phy_txpwr_srom_read_lcnphy(struct brcms_phy *pi)
 						((offset_ofdm & 0xf) * 2);
 				offset_ofdm >>= 4;
 			}
-			offset_mcs =
-				wlapi_getintvar(shim,
-						BRCMS_SROM_MCS2GPO1) << 16;
-			offset_mcs |=
-				(u16) wlapi_getintvar(shim,
-						      BRCMS_SROM_MCS2GPO0);
+			offset_mcs = sprom->mcs2gpo[1] << 16;
+			offset_mcs |= sprom->mcs2gpo[0];
 			pi_lcn->lcnphy_mcs20_po = offset_mcs;
 			for (i = TXP_FIRST_SISO_MCS_20;
 			     i <= TXP_LAST_SISO_MCS_20; i++) {
@@ -4901,25 +4892,17 @@ static bool wlc_phy_txpwr_srom_read_lcnphy(struct brcms_phy *pi)
 			}
 		}
 
-		pi_lcn->lcnphy_rawtempsense =
-			(u16)wlapi_getintvar(shim, BRCMS_SROM_RAWTEMPSENSE);
-		pi_lcn->lcnphy_measPower =
-			(u8)wlapi_getintvar(shim, BRCMS_SROM_MEASPOWER);
-		pi_lcn->lcnphy_tempsense_slope =
-			(u8)wlapi_getintvar(shim, BRCMS_SROM_TEMPSENSE_SLOPE);
-		pi_lcn->lcnphy_hw_iqcal_en =
-			(bool)wlapi_getintvar(shim, BRCMS_SROM_HW_IQCAL_EN);
-		pi_lcn->lcnphy_iqcal_swp_dis =
-			(bool)wlapi_getintvar(shim, BRCMS_SROM_IQCAL_SWP_DIS);
-		pi_lcn->lcnphy_tempcorrx =
-			(u8)wlapi_getintvar(shim, BRCMS_SROM_TEMPCORRX);
-		pi_lcn->lcnphy_tempsense_option =
-			(u8)wlapi_getintvar(shim, BRCMS_SROM_TEMPSENSE_OPTION);
-		pi_lcn->lcnphy_freqoffset_corr =
-			(u8)wlapi_getintvar(shim, BRCMS_SROM_FREQOFFSET_CORR);
-		if ((u8)wlapi_getintvar(shim, BRCMS_SROM_AA2G) > 1)
+		pi_lcn->lcnphy_rawtempsense = sprom->rawtempsense;
+		pi_lcn->lcnphy_measPower = sprom->measpower;
+		pi_lcn->lcnphy_tempsense_slope = sprom->tempsense_slope;
+		pi_lcn->lcnphy_hw_iqcal_en = sprom->hw_iqcal_en;
+		pi_lcn->lcnphy_iqcal_swp_dis = sprom->iqcal_swp_dis;
+		pi_lcn->lcnphy_tempcorrx = sprom->tempcorrx;
+		pi_lcn->lcnphy_tempsense_option = sprom->tempsense_option;
+		pi_lcn->lcnphy_freqoffset_corr = sprom->freqoffset_corr;
+		if (sprom->ant_available_bg > 1)
 			wlc_phy_ant_rxdiv_set((struct brcms_phy_pub *) pi,
-				(u8) wlapi_getintvar(shim, BRCMS_SROM_AA2G));
+				sprom->ant_available_bg);
 	}
 	pi_lcn->lcnphy_cck_dig_filt_type = -1;
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
index 812b6e3..c26387b 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
@@ -14386,30 +14386,30 @@ static void wlc_phy_txpwr_srom_read_ppr_nphy(struct brcms_phy *pi)
 {
 	u16 bw40po, cddpo, stbcpo, bwduppo;
 	uint band_num;
-	struct phy_shim_info *shim = pi->sh->physhim;
+	struct ssb_sprom *sprom = &pi->d11core->bus->sprom;
 
 	if (pi->sh->sromrev >= 9)
 		return;
 
-	bw40po = (u16) wlapi_getintvar(shim, BRCMS_SROM_BW40PO);
+	bw40po = sprom->bw40po;
 	pi->bw402gpo = bw40po & 0xf;
 	pi->bw405gpo = (bw40po & 0xf0) >> 4;
 	pi->bw405glpo = (bw40po & 0xf00) >> 8;
 	pi->bw405ghpo = (bw40po & 0xf000) >> 12;
 
-	cddpo = (u16) wlapi_getintvar(shim, BRCMS_SROM_CDDPO);
+	cddpo = sprom->cddpo;
 	pi->cdd2gpo = cddpo & 0xf;
 	pi->cdd5gpo = (cddpo & 0xf0) >> 4;
 	pi->cdd5glpo = (cddpo & 0xf00) >> 8;
 	pi->cdd5ghpo = (cddpo & 0xf000) >> 12;
 
-	stbcpo = (u16) wlapi_getintvar(shim, BRCMS_SROM_STBCPO);
+	stbcpo = sprom->stbcpo;
 	pi->stbc2gpo = stbcpo & 0xf;
 	pi->stbc5gpo = (stbcpo & 0xf0) >> 4;
 	pi->stbc5glpo = (stbcpo & 0xf00) >> 8;
 	pi->stbc5ghpo = (stbcpo & 0xf000) >> 12;
 
-	bwduppo = (u16) wlapi_getintvar(shim, BRCMS_SROM_BWDUPPO);
+	bwduppo = sprom->bwduppo;
 	pi->bwdup2gpo = bwduppo & 0xf;
 	pi->bwdup5gpo = (bwduppo & 0xf0) >> 4;
 	pi->bwdup5glpo = (bwduppo & 0xf00) >> 8;
@@ -14419,242 +14419,137 @@ static void wlc_phy_txpwr_srom_read_ppr_nphy(struct brcms_phy *pi)
 	     band_num++) {
 		switch (band_num) {
 		case 0:
-
 			pi->nphy_pwrctrl_info[PHY_CORE_0].max_pwr_2g =
-				(s8) wlapi_getintvar(shim,
-						     BRCMS_SROM_MAXP2GA0);
+				sprom->core_pwr_info[0].maxpwr_2g;
 			pi->nphy_pwrctrl_info[PHY_CORE_1].max_pwr_2g =
-				(s8) wlapi_getintvar(shim,
-						     BRCMS_SROM_MAXP2GA1);
+				sprom->core_pwr_info[1].maxpwr_2g;
 			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_2g_a1 =
-				(s16) wlapi_getintvar(shim,
-						      BRCMS_SROM_PA2GW0A0);
+				sprom->core_pwr_info[0].pa_2g[0];
 			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_2g_a1 =
-				(s16) wlapi_getintvar(shim,
-						      BRCMS_SROM_PA2GW0A1);
+				sprom->core_pwr_info[1].pa_2g[0];
 			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_2g_b0 =
-				(s16) wlapi_getintvar(shim,
-						      BRCMS_SROM_PA2GW1A0);
+				sprom->core_pwr_info[0].pa_2g[1];
 			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_2g_b0 =
-				(s16) wlapi_getintvar(shim,
-						      BRCMS_SROM_PA2GW1A1);
+				sprom->core_pwr_info[1].pa_2g[1];
 			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_2g_b1 =
-				(s16) wlapi_getintvar(shim,
-						      BRCMS_SROM_PA2GW2A0);
+				sprom->core_pwr_info[0].pa_2g[2];
 			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_2g_b1 =
-				(s16) wlapi_getintvar(shim,
-						      BRCMS_SROM_PA2GW2A1);
+				sprom->core_pwr_info[1].pa_2g[2];
 			pi->nphy_pwrctrl_info[PHY_CORE_0].idle_targ_2g =
-				(s8) wlapi_getintvar(shim, BRCMS_SROM_ITT2GA0);
+				sprom->core_pwr_info[0].itssi_2g;
 			pi->nphy_pwrctrl_info[PHY_CORE_1].idle_targ_2g =
-				(s8) wlapi_getintvar(shim, BRCMS_SROM_ITT2GA1);
-
-			pi->cck2gpo = (u16) wlapi_getintvar(shim,
-							    BRCMS_SROM_CCK2GPO);
-
-			pi->ofdm2gpo =
-				(u32) wlapi_getintvar(shim,
-						      BRCMS_SROM_OFDM2GPO);
-
-			pi->mcs2gpo[0] =
-				(u16) wlapi_getintvar(shim,
-						      BRCMS_SROM_MCS2GPO0);
-			pi->mcs2gpo[1] =
-				(u16) wlapi_getintvar(shim,
-						      BRCMS_SROM_MCS2GPO1);
-			pi->mcs2gpo[2] =
-				(u16) wlapi_getintvar(shim,
-						      BRCMS_SROM_MCS2GPO2);
-			pi->mcs2gpo[3] =
-				(u16) wlapi_getintvar(shim,
-						      BRCMS_SROM_MCS2GPO3);
-			pi->mcs2gpo[4] =
-				(u16) wlapi_getintvar(shim,
-						      BRCMS_SROM_MCS2GPO4);
-			pi->mcs2gpo[5] =
-				(u16) wlapi_getintvar(shim,
-						      BRCMS_SROM_MCS2GPO5);
-			pi->mcs2gpo[6] =
-				(u16) wlapi_getintvar(shim,
-						      BRCMS_SROM_MCS2GPO6);
-			pi->mcs2gpo[7] =
-				(u16) wlapi_getintvar(shim,
-						      BRCMS_SROM_MCS2GPO7);
+				sprom->core_pwr_info[1].itssi_2g;
+
+			pi->cck2gpo = sprom->cck2gpo;
+
+			pi->ofdm2gpo = sprom->ofdm2gpo;
+
+			pi->mcs2gpo[0] = sprom->mcs2gpo[0];
+			pi->mcs2gpo[1] = sprom->mcs2gpo[1];
+			pi->mcs2gpo[2] = sprom->mcs2gpo[2];
+			pi->mcs2gpo[3] = sprom->mcs2gpo[3];
+			pi->mcs2gpo[4] = sprom->mcs2gpo[4];
+			pi->mcs2gpo[5] = sprom->mcs2gpo[5];
+			pi->mcs2gpo[6] = sprom->mcs2gpo[6];
+			pi->mcs2gpo[7] = sprom->mcs2gpo[7];
 			break;
 		case 1:
 
 			pi->nphy_pwrctrl_info[PHY_CORE_0].max_pwr_5gm =
-				(s8) wlapi_getintvar(shim, BRCMS_SROM_MAXP5GA0);
+				sprom->core_pwr_info[0].maxpwr_5g;
 			pi->nphy_pwrctrl_info[PHY_CORE_1].max_pwr_5gm =
-				(s8) wlapi_getintvar(shim,
-						     BRCMS_SROM_MAXP5GA1);
+				sprom->core_pwr_info[1].maxpwr_5g;
 			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_5gm_a1 =
-				(s16) wlapi_getintvar(shim,
-						      BRCMS_SROM_PA5GW0A0);
+				sprom->core_pwr_info[0].pa_5g[0];
 			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_5gm_a1 =
-				(s16) wlapi_getintvar(shim,
-						      BRCMS_SROM_PA5GW0A1);
+				sprom->core_pwr_info[1].pa_5g[0];
 			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_5gm_b0 =
-				(s16) wlapi_getintvar(shim,
-						      BRCMS_SROM_PA5GW1A0);
+				sprom->core_pwr_info[0].pa_5g[1];
 			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_5gm_b0 =
-				(s16) wlapi_getintvar(shim,
-						      BRCMS_SROM_PA5GW1A1);
+				sprom->core_pwr_info[1].pa_5g[1];
 			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_5gm_b1 =
-				(s16) wlapi_getintvar(shim,
-						      BRCMS_SROM_PA5GW2A0);
+				sprom->core_pwr_info[0].pa_5g[2];
 			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_5gm_b1 =
-				(s16) wlapi_getintvar(shim,
-						      BRCMS_SROM_PA5GW2A1);
+				sprom->core_pwr_info[1].pa_5g[2];
 			pi->nphy_pwrctrl_info[PHY_CORE_0].idle_targ_5gm =
-				(s8) wlapi_getintvar(shim, BRCMS_SROM_ITT5GA0);
+				sprom->core_pwr_info[0].itssi_5g;
 			pi->nphy_pwrctrl_info[PHY_CORE_1].idle_targ_5gm =
-				(s8) wlapi_getintvar(shim, BRCMS_SROM_ITT5GA1);
-
-			pi->ofdm5gpo =
-				(u32) wlapi_getintvar(shim,
-						      BRCMS_SROM_OFDM5GPO);
-
-			pi->mcs5gpo[0] =
-				(u16) wlapi_getintvar(shim,
-						      BRCMS_SROM_MCS5GPO0);
-			pi->mcs5gpo[1] =
-				(u16) wlapi_getintvar(shim,
-						      BRCMS_SROM_MCS5GPO1);
-			pi->mcs5gpo[2] =
-				(u16) wlapi_getintvar(shim,
-						      BRCMS_SROM_MCS5GPO2);
-			pi->mcs5gpo[3] =
-				(u16) wlapi_getintvar(shim,
-						      BRCMS_SROM_MCS5GPO3);
-			pi->mcs5gpo[4] =
-				(u16) wlapi_getintvar(shim,
-						      BRCMS_SROM_MCS5GPO4);
-			pi->mcs5gpo[5] =
-				(u16) wlapi_getintvar(shim,
-						      BRCMS_SROM_MCS5GPO5);
-			pi->mcs5gpo[6] =
-				(u16) wlapi_getintvar(shim,
-						      BRCMS_SROM_MCS5GPO6);
-			pi->mcs5gpo[7] =
-				(u16) wlapi_getintvar(shim,
-						      BRCMS_SROM_MCS5GPO7);
+				sprom->core_pwr_info[1].itssi_5g;
+
+			pi->ofdm5gpo = sprom->ofdm5gpo;
+
+			pi->mcs5gpo[0] = sprom->mcs5gpo[0];
+			pi->mcs5gpo[1] = sprom->mcs5gpo[1];
+			pi->mcs5gpo[2] = sprom->mcs5gpo[2];
+			pi->mcs5gpo[3] = sprom->mcs5gpo[3];
+			pi->mcs5gpo[4] = sprom->mcs5gpo[4];
+			pi->mcs5gpo[5] = sprom->mcs5gpo[5];
+			pi->mcs5gpo[6] = sprom->mcs5gpo[6];
+			pi->mcs5gpo[7] = sprom->mcs5gpo[7];
 			break;
 		case 2:
 
 			pi->nphy_pwrctrl_info[0].max_pwr_5gl =
-				(s8) wlapi_getintvar(shim,
-						     BRCMS_SROM_MAXP5GLA0);
+				sprom->core_pwr_info[0].maxpwr_5gl;
 			pi->nphy_pwrctrl_info[1].max_pwr_5gl =
-				(s8) wlapi_getintvar(shim,
-						     BRCMS_SROM_MAXP5GLA1);
+				sprom->core_pwr_info[1].maxpwr_5gl;
 			pi->nphy_pwrctrl_info[0].pwrdet_5gl_a1 =
-				(s16) wlapi_getintvar(shim,
-						      BRCMS_SROM_PA5GLW0A0);
+				sprom->core_pwr_info[0].pa_5gl[0];
 			pi->nphy_pwrctrl_info[1].pwrdet_5gl_a1 =
-				(s16) wlapi_getintvar(shim,
-						      BRCMS_SROM_PA5GLW0A1);
+				sprom->core_pwr_info[1].pa_5gl[0];
 			pi->nphy_pwrctrl_info[0].pwrdet_5gl_b0 =
-				(s16) wlapi_getintvar(shim,
-						      BRCMS_SROM_PA5GLW1A0);
+				sprom->core_pwr_info[0].pa_5gl[1];
 			pi->nphy_pwrctrl_info[1].pwrdet_5gl_b0 =
-				(s16) wlapi_getintvar(shim,
-						      BRCMS_SROM_PA5GLW1A1);
+				sprom->core_pwr_info[1].pa_5gl[1];
 			pi->nphy_pwrctrl_info[0].pwrdet_5gl_b1 =
-				(s16) wlapi_getintvar(shim,
-						      BRCMS_SROM_PA5GLW2A0);
+				sprom->core_pwr_info[0].pa_5gl[2];
 			pi->nphy_pwrctrl_info[1].pwrdet_5gl_b1 =
-				(s16) wlapi_getintvar(shim,
-						      BRCMS_SROM_PA5GLW2A1);
+				sprom->core_pwr_info[1].pa_5gl[2];
 			pi->nphy_pwrctrl_info[0].idle_targ_5gl = 0;
 			pi->nphy_pwrctrl_info[1].idle_targ_5gl = 0;
 
-			pi->ofdm5glpo =
-				(u32) wlapi_getintvar(shim,
-						      BRCMS_SROM_OFDM5GLPO);
-
-			pi->mcs5glpo[0] =
-				(u16) wlapi_getintvar(shim,
-						      BRCMS_SROM_MCS5GLPO0);
-			pi->mcs5glpo[1] =
-				(u16) wlapi_getintvar(shim,
-						      BRCMS_SROM_MCS5GLPO1);
-			pi->mcs5glpo[2] =
-				(u16) wlapi_getintvar(shim,
-						      BRCMS_SROM_MCS5GLPO2);
-			pi->mcs5glpo[3] =
-				(u16) wlapi_getintvar(shim,
-						      BRCMS_SROM_MCS5GLPO3);
-			pi->mcs5glpo[4] =
-				(u16) wlapi_getintvar(shim,
-						      BRCMS_SROM_MCS5GLPO4);
-			pi->mcs5glpo[5] =
-				(u16) wlapi_getintvar(shim,
-						      BRCMS_SROM_MCS5GLPO5);
-			pi->mcs5glpo[6] =
-				(u16) wlapi_getintvar(shim,
-						      BRCMS_SROM_MCS5GLPO6);
-			pi->mcs5glpo[7] =
-				(u16) wlapi_getintvar(shim,
-						      BRCMS_SROM_MCS5GLPO7);
+			pi->ofdm5glpo = sprom->ofdm5glpo;
+
+			pi->mcs5glpo[0] = sprom->mcs5glpo[0];
+			pi->mcs5glpo[1] = sprom->mcs5glpo[1];
+			pi->mcs5glpo[2] = sprom->mcs5glpo[2];
+			pi->mcs5glpo[3] = sprom->mcs5glpo[3];
+			pi->mcs5glpo[4] = sprom->mcs5glpo[4];
+			pi->mcs5glpo[5] = sprom->mcs5glpo[5];
+			pi->mcs5glpo[6] = sprom->mcs5glpo[6];
+			pi->mcs5glpo[7] = sprom->mcs5glpo[7];
 			break;
 		case 3:
 
 			pi->nphy_pwrctrl_info[0].max_pwr_5gh =
-				(s8) wlapi_getintvar(shim,
-						     BRCMS_SROM_MAXP5GHA0);
+				sprom->core_pwr_info[0].maxpwr_5gh;
 			pi->nphy_pwrctrl_info[1].max_pwr_5gh =
-				(s8) wlapi_getintvar(shim,
-						     BRCMS_SROM_MAXP5GHA1);
+				sprom->core_pwr_info[1].maxpwr_5gh;
 			pi->nphy_pwrctrl_info[0].pwrdet_5gh_a1 =
-				(s16) wlapi_getintvar(shim,
-						      BRCMS_SROM_PA5GHW0A0);
+				sprom->core_pwr_info[0].pa_5gh[0];
 			pi->nphy_pwrctrl_info[1].pwrdet_5gh_a1 =
-				(s16) wlapi_getintvar(shim,
-						      BRCMS_SROM_PA5GHW0A1);
+				sprom->core_pwr_info[1].pa_5gh[0];
 			pi->nphy_pwrctrl_info[0].pwrdet_5gh_b0 =
-				(s16) wlapi_getintvar(shim,
-						      BRCMS_SROM_PA5GHW1A0);
+				sprom->core_pwr_info[0].pa_5gh[1];
 			pi->nphy_pwrctrl_info[1].pwrdet_5gh_b0 =
-				(s16) wlapi_getintvar(shim,
-						      BRCMS_SROM_PA5GHW1A1);
+				sprom->core_pwr_info[1].pa_5gh[1];
 			pi->nphy_pwrctrl_info[0].pwrdet_5gh_b1 =
-				(s16) wlapi_getintvar(shim,
-						      BRCMS_SROM_PA5GHW2A0);
+				sprom->core_pwr_info[0].pa_5gh[2];
 			pi->nphy_pwrctrl_info[1].pwrdet_5gh_b1 =
-				(s16) wlapi_getintvar(shim,
-						      BRCMS_SROM_PA5GHW2A1);
+				sprom->core_pwr_info[1].pa_5gh[2];
 			pi->nphy_pwrctrl_info[0].idle_targ_5gh = 0;
 			pi->nphy_pwrctrl_info[1].idle_targ_5gh = 0;
 
-			pi->ofdm5ghpo =
-				(u32) wlapi_getintvar(shim,
-						      BRCMS_SROM_OFDM5GHPO);
-
-			pi->mcs5ghpo[0] =
-				(u16) wlapi_getintvar(shim,
-						      BRCMS_SROM_MCS5GHPO0);
-			pi->mcs5ghpo[1] =
-				(u16) wlapi_getintvar(shim,
-						      BRCMS_SROM_MCS5GHPO1);
-			pi->mcs5ghpo[2] =
-				(u16) wlapi_getintvar(shim,
-						      BRCMS_SROM_MCS5GHPO2);
-			pi->mcs5ghpo[3] =
-				(u16) wlapi_getintvar(shim,
-						      BRCMS_SROM_MCS5GHPO3);
-			pi->mcs5ghpo[4] =
-				(u16) wlapi_getintvar(shim,
-						      BRCMS_SROM_MCS5GHPO4);
-			pi->mcs5ghpo[5] =
-				(u16) wlapi_getintvar(shim,
-						      BRCMS_SROM_MCS5GHPO5);
-			pi->mcs5ghpo[6] =
-				(u16) wlapi_getintvar(shim,
-						      BRCMS_SROM_MCS5GHPO6);
-			pi->mcs5ghpo[7] =
-				(u16) wlapi_getintvar(shim,
-						      BRCMS_SROM_MCS5GHPO7);
+			pi->ofdm5ghpo = sprom->ofdm5ghpo;
+
+			pi->mcs5ghpo[0] = sprom->mcs5ghpo[0];
+			pi->mcs5ghpo[1] = sprom->mcs5ghpo[1];
+			pi->mcs5ghpo[2] = sprom->mcs5ghpo[2];
+			pi->mcs5ghpo[3] = sprom->mcs5ghpo[3];
+			pi->mcs5ghpo[4] = sprom->mcs5ghpo[4];
+			pi->mcs5ghpo[5] = sprom->mcs5ghpo[5];
+			pi->mcs5ghpo[6] = sprom->mcs5ghpo[6];
+			pi->mcs5ghpo[7] = sprom->mcs5ghpo[7];
 			break;
 		}
 	}
@@ -14664,45 +14559,34 @@ static void wlc_phy_txpwr_srom_read_ppr_nphy(struct brcms_phy *pi)
 
 static bool wlc_phy_txpwr_srom_read_nphy(struct brcms_phy *pi)
 {
-	struct phy_shim_info *shim = pi->sh->physhim;
-
-	pi->antswitch = (u8) wlapi_getintvar(shim, BRCMS_SROM_ANTSWITCH);
-	pi->aa2g = (u8) wlapi_getintvar(shim, BRCMS_SROM_AA2G);
-	pi->aa5g = (u8) wlapi_getintvar(shim, BRCMS_SROM_AA5G);
-
-	pi->srom_fem2g.tssipos = (u8) wlapi_getintvar(shim,
-						      BRCMS_SROM_TSSIPOS2G);
-	pi->srom_fem2g.extpagain = (u8) wlapi_getintvar(shim,
-							BRCMS_SROM_EXTPAGAIN2G);
-	pi->srom_fem2g.pdetrange = (u8) wlapi_getintvar(shim,
-							BRCMS_SROM_PDETRANGE2G);
-	pi->srom_fem2g.triso = (u8) wlapi_getintvar(shim, BRCMS_SROM_TRISO2G);
-	pi->srom_fem2g.antswctrllut =
-			(u8) wlapi_getintvar(shim, BRCMS_SROM_ANTSWCTL2G);
-
-	pi->srom_fem5g.tssipos = (u8) wlapi_getintvar(shim,
-						      BRCMS_SROM_TSSIPOS5G);
-	pi->srom_fem5g.extpagain = (u8) wlapi_getintvar(shim,
-							BRCMS_SROM_EXTPAGAIN5G);
-	pi->srom_fem5g.pdetrange = (u8) wlapi_getintvar(shim,
-							BRCMS_SROM_PDETRANGE5G);
-	pi->srom_fem5g.triso = (u8) wlapi_getintvar(shim, BRCMS_SROM_TRISO5G);
-	if (wlapi_getvar(shim, BRCMS_SROM_ANTSWCTL5G))
-		pi->srom_fem5g.antswctrllut =
-			(u8) wlapi_getintvar(shim, BRCMS_SROM_ANTSWCTL5G);
+	struct ssb_sprom *sprom = &pi->d11core->bus->sprom;
+
+	pi->antswitch = sprom->antswitch;
+	pi->aa2g = sprom->ant_available_bg;
+	pi->aa5g = sprom->ant_available_a;
+
+	pi->srom_fem2g.tssipos = sprom->fem.ghz2.tssipos;
+	pi->srom_fem2g.extpagain = sprom->fem.ghz2.extpa_gain;
+	pi->srom_fem2g.pdetrange = sprom->fem.ghz2.pdet_range;
+	pi->srom_fem2g.triso = sprom->fem.ghz2.tr_iso;
+	pi->srom_fem2g.antswctrllut = sprom->fem.ghz2.antswlut;
+
+	pi->srom_fem5g.tssipos = sprom->fem.ghz5.tssipos;
+	pi->srom_fem5g.extpagain = sprom->fem.ghz5.extpa_gain;
+	pi->srom_fem5g.pdetrange = sprom->fem.ghz5.pdet_range;
+	pi->srom_fem5g.triso = sprom->fem.ghz5.tr_iso;
+	if (sprom->fem.ghz5.antswlut)
+		pi->srom_fem5g.antswctrllut = sprom->fem.ghz5.antswlut;
 	else
-		pi->srom_fem5g.antswctrllut =
-			(u8) wlapi_getintvar(shim, BRCMS_SROM_ANTSWCTL2G);
+		pi->srom_fem5g.antswctrllut = sprom->fem.ghz2.antswlut;
 
 	wlc_phy_txpower_ipa_upd(pi);
 
-	pi->phy_txcore_disable_temp =
-			(s16) wlapi_getintvar(shim, BRCMS_SROM_TEMPTHRESH);
+	pi->phy_txcore_disable_temp = sprom->tempthresh;
 	if (pi->phy_txcore_disable_temp == 0)
 		pi->phy_txcore_disable_temp = PHY_CHAIN_TX_DISABLE_TEMP;
 
-	pi->phy_tempsense_offset = (s8) wlapi_getintvar(shim,
-							BRCMS_SROM_TEMPOFFSET);
+	pi->phy_tempsense_offset = sprom->tempoffset;
 	if (pi->phy_tempsense_offset != 0) {
 		if (pi->phy_tempsense_offset >
 		    (NPHY_SROM_TEMPSHIFT + NPHY_SROM_MAXTEMPOFFSET))
@@ -14717,8 +14601,7 @@ static bool wlc_phy_txpwr_srom_read_nphy(struct brcms_phy *pi)
 	pi->phy_txcore_enable_temp =
 		pi->phy_txcore_disable_temp - PHY_HYSTERESIS_DELTATEMP;
 
-	pi->phycal_tempdelta =
-			(u8) wlapi_getintvar(shim, BRCMS_SROM_PHYCAL_TEMPDELTA);
+	pi->phycal_tempdelta = sprom->phycal_tempdelta;
 	if (pi->phycal_tempdelta > NPHY_CAL_MAXTEMPDELTA)
 		pi->phycal_tempdelta = 0;
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/stf.c b/drivers/net/wireless/brcm80211/brcmsmac/stf.c
index d8f528e..ed1d1aa 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/stf.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/stf.c
@@ -370,9 +370,11 @@ void brcms_c_stf_phy_txant_upd(struct brcms_c_info *wlc)
 
 void brcms_c_stf_phy_chain_calc(struct brcms_c_info *wlc)
 {
+	struct ssb_sprom *sprom = &wlc->hw->d11core->bus->sprom;
+
 	/* get available rx/tx chains */
-	wlc->stf->hw_txchain = (u8) getintvar(wlc->hw->sih, BRCMS_SROM_TXCHAIN);
-	wlc->stf->hw_rxchain = (u8) getintvar(wlc->hw->sih, BRCMS_SROM_RXCHAIN);
+	wlc->stf->hw_txchain = sprom->txchain;
+	wlc->stf->hw_rxchain = sprom->rxchain;
 
 	/* these parameter are intended to be used for all PHY types */
 	if (wlc->stf->hw_txchain == 0 || wlc->stf->hw_txchain == 0xf) {
-- 
1.7.9.5

