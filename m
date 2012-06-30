Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53865 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103Ab2F3NRu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jun 2012 09:17:50 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com
Cc: brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 10/18] brcmsmac: use chip and package id constants from bcma
Date: Sat, 30 Jun 2012 15:16:13 +0200
Message-Id: <1341062181-28071-11-git-send-email-hauke@hauke-m.de> (sfid-20120630_151755_314441_C828FFF7)
In-Reply-To: <1341062181-28071-1-git-send-email-hauke@hauke-m.de>
References: <1341062181-28071-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch depends on addin the chip IDs to bcma done in this commit in
my pending patch series for bcma.
Author: Hauke Mehrtens <hauke@hauke-m.de>
Date:   Sun Jun 3 18:17:57 2012 +0200

    bcma: add constants for chip ids

Acked-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h  |   10 ----------
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |   12 ++++++------
 .../net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c  |   10 +++++-----
 .../net/wireless/brcm80211/brcmsmac/phy/phy_n.c    |   20 ++++++++++----------
 drivers/net/wireless/brcm80211/brcmsmac/pmu.c      |   12 ++++++------
 5 files changed, 27 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
index 3a5358c..89562c1 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
@@ -88,16 +88,6 @@
 #define	CLKD_OTP		0x000f0000
 #define	CLKD_OTP_SHIFT		16
 
-/* Package IDs */
-#define	BCM4717_PKG_ID		9	/* 4717 package id */
-#define	BCM4718_PKG_ID		10	/* 4718 package id */
-#define BCM43224_FAB_SMIC	0xa	/* the chip is manufactured by SMIC */
-
-/* these are router chips */
-#define	BCM4716_CHIP_ID		0x4716	/* 4716 chipcommon chipid */
-#define	BCM47162_CHIP_ID	47162	/* 47162 chipcommon chipid */
-#define	BCM4748_CHIP_ID		0x4748	/* 4716 chipcommon chipid (OTP, RBBU) */
-
 /* dynamic clock control defines */
 #define	LPOMINFREQ		25000	/* low power oscillator min */
 #define	LPOMAXFREQ		43000	/* low power oscillator max */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 8776fbc..478b374 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -2126,8 +2126,8 @@ void brcms_b_switch_macfreq(struct brcms_hardware *wlc_hw, u8 spurmode)
 {
 	struct bcma_device *core = wlc_hw->d11core;
 
-	if ((ai_get_chip_id(wlc_hw->sih) == BCM43224_CHIP_ID) ||
-	    (ai_get_chip_id(wlc_hw->sih) == BCM43225_CHIP_ID)) {
+	if ((ai_get_chip_id(wlc_hw->sih) == BCMA_CHIP_ID_BCM43224) ||
+	    (ai_get_chip_id(wlc_hw->sih) == BCMA_CHIP_ID_BCM43225)) {
 		if (spurmode == WL_SPURAVOID_ON2) {	/* 126Mhz */
 			bcma_write16(core, D11REGOFFS(tsf_clk_frac_l), 0x2082);
 			bcma_write16(core, D11REGOFFS(tsf_clk_frac_h), 0x8);
@@ -2791,7 +2791,7 @@ void brcms_b_core_phypll_ctl(struct brcms_hardware *wlc_hw, bool on)
 	tmp = 0;
 
 	if (on) {
-		if ((ai_get_chip_id(wlc_hw->sih) == BCM4313_CHIP_ID)) {
+		if ((ai_get_chip_id(wlc_hw->sih) == BCMA_CHIP_ID_BCM4313)) {
 			bcma_set32(core, D11REGOFFS(clk_ctl_st),
 				   CCS_ERSRC_REQ_HT |
 				   CCS_ERSRC_REQ_D11PLL |
@@ -4528,7 +4528,7 @@ static int brcms_b_attach(struct brcms_c_info *wlc, struct bcma_device *core,
 	else
 		wlc_hw->_nbands = 1;
 
-	if ((ai_get_chip_id(wlc_hw->sih) == BCM43225_CHIP_ID))
+	if ((ai_get_chip_id(wlc_hw->sih) == BCMA_CHIP_ID_BCM43225))
 		wlc_hw->_nbands = 1;
 
 	/* BMAC_NOTE: remove init of pub values when brcms_c_attach()
@@ -5036,7 +5036,7 @@ static void brcms_b_hw_up(struct brcms_hardware *wlc_hw)
 	wlc_hw->wlc->pub->hw_up = true;
 
 	if ((wlc_hw->boardflags & BFL_FEM)
-	    && (ai_get_chip_id(wlc_hw->sih) == BCM4313_CHIP_ID)) {
+	    && (ai_get_chip_id(wlc_hw->sih) == BCMA_CHIP_ID_BCM4313)) {
 		if (!
 		    (wlc_hw->boardrev >= 0x1250
 		     && (wlc_hw->boardflags & BFL_FEM_BT)))
@@ -5130,7 +5130,7 @@ int brcms_c_up(struct brcms_c_info *wlc)
 	}
 
 	if ((wlc->pub->boardflags & BFL_FEM)
-	    && (ai_get_chip_id(wlc->hw->sih) == BCM4313_CHIP_ID)) {
+	    && (ai_get_chip_id(wlc->hw->sih) == BCMA_CHIP_ID_BCM4313)) {
 		if (wlc->pub->boardrev >= 0x1250
 		    && (wlc->pub->boardflags & BFL_FEM_BT))
 			brcms_b_mhf(wlc->hw, MHF5, MHF5_4313_GPIOCTRL,
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
index 264f8c4..d16cbec 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -837,7 +837,7 @@ wlc_phy_table_addr(struct brcms_phy *pi, uint tbl_id, uint tbl_offset,
 	pi->tbl_data_hi = tblDataHi;
 	pi->tbl_data_lo = tblDataLo;
 
-	if (pi->sh->chip == BCM43224_CHIP_ID &&
+	if (pi->sh->chip == BCMA_CHIP_ID_BCM43224 &&
 	    pi->sh->chiprev == 1) {
 		pi->tbl_addr = tblAddr;
 		pi->tbl_save_id = tbl_id;
@@ -847,7 +847,7 @@ wlc_phy_table_addr(struct brcms_phy *pi, uint tbl_id, uint tbl_offset,
 
 void wlc_phy_table_data_write(struct brcms_phy *pi, uint width, u32 val)
 {
-	if ((pi->sh->chip == BCM43224_CHIP_ID) &&
+	if ((pi->sh->chip == BCMA_CHIP_ID_BCM43224) &&
 	    (pi->sh->chiprev == 1) &&
 	    (pi->tbl_save_id == NPHY_TBL_ID_ANTSWCTRLLUT)) {
 		read_phy_reg(pi, pi->tbl_data_lo);
@@ -881,7 +881,7 @@ wlc_phy_write_table(struct brcms_phy *pi, const struct phytbl_info *ptbl_info,
 
 	for (idx = 0; idx < ptbl_info->tbl_len; idx++) {
 
-		if ((pi->sh->chip == BCM43224_CHIP_ID) &&
+		if ((pi->sh->chip == BCMA_CHIP_ID_BCM43224) &&
 		    (pi->sh->chiprev == 1) &&
 		    (tbl_id == NPHY_TBL_ID_ANTSWCTRLLUT)) {
 			read_phy_reg(pi, tblDataLo);
@@ -918,7 +918,7 @@ wlc_phy_read_table(struct brcms_phy *pi, const struct phytbl_info *ptbl_info,
 
 	for (idx = 0; idx < ptbl_info->tbl_len; idx++) {
 
-		if ((pi->sh->chip == BCM43224_CHIP_ID) &&
+		if ((pi->sh->chip == BCMA_CHIP_ID_BCM43224) &&
 		    (pi->sh->chiprev == 1)) {
 			(void)read_phy_reg(pi, tblDataLo);
 
@@ -2894,7 +2894,7 @@ const u8 *wlc_phy_get_ofdm_rate_lookup(void)
 
 void wlc_lcnphy_epa_switch(struct brcms_phy *pi, bool mode)
 {
-	if ((pi->sh->chip == BCM4313_CHIP_ID) &&
+	if ((pi->sh->chip == BCMA_CHIP_ID_BCM4313) &&
 	    (pi->sh->boardflags & BFL_FEM)) {
 		if (mode) {
 			u16 txant = 0;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
index a4ae93e..14da744 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
@@ -19309,8 +19309,8 @@ void wlc_phy_init_nphy(struct brcms_phy *pi)
 		pi->measure_hold |= PHY_HOLD_FOR_NOT_ASSOC;
 
 	if ((ISNPHY(pi)) && (NREV_GE(pi->pubpi.phy_rev, 5)) &&
-	    ((pi->sh->chippkg == BCM4717_PKG_ID) ||
-	     (pi->sh->chippkg == BCM4718_PKG_ID))) {
+	    ((pi->sh->chippkg == BCMA_PKG_ID_BCM4717) ||
+	     (pi->sh->chippkg == BCMA_PKG_ID_BCM4718))) {
 		if ((pi->sh->boardflags & BFL_EXTLNA) &&
 		    (CHSPEC_IS2G(pi->radio_chanspec)))
 			ai_cc_reg(pi->sh->sih,
@@ -20751,11 +20751,11 @@ wlc_phy_chanspec_radio2056_setup(struct brcms_phy *pi,
 				cascbias = 0x20;
 
 				if ((pi->sh->chip ==
-				     BCM43224_CHIP_ID)
+				     BCMA_CHIP_ID_BCM43224)
 				    || (pi->sh->chip ==
-					BCM43225_CHIP_ID)) {
+					BCMA_CHIP_ID_BCM43225)) {
 					if (pi->sh->chippkg ==
-					    BCM43224_FAB_SMIC) {
+					    BCMA_PKG_ID_BCM43224_FAB_SMIC) {
 						bias = 0x2a;
 						cascbias = 0x38;
 					}
@@ -20863,9 +20863,9 @@ wlc_phy_chanspec_radio2056_setup(struct brcms_phy *pi,
 
 			cascbias = 0x30;
 
-			if ((pi->sh->chip == BCM43224_CHIP_ID) ||
-			    (pi->sh->chip == BCM43225_CHIP_ID)) {
-				if (pi->sh->chippkg == BCM43224_FAB_SMIC)
+			if ((pi->sh->chip == BCMA_CHIP_ID_BCM43224) ||
+			    (pi->sh->chip == BCMA_CHIP_ID_BCM43225)) {
+				if (pi->sh->chippkg == BCMA_PKG_ID_BCM43224_FAB_SMIC)
 					cascbias = 0x35;
 			}
 
@@ -21193,8 +21193,8 @@ wlc_phy_chanspec_nphy_setup(struct brcms_phy *pi, u16 chanspec,
 		bcma_pmu_spuravoid_pllupdate(&sii->icbus->drv_cc, spuravoid);
 		wlapi_bmac_core_phypll_ctl(pi->sh->physhim, true);
 
-		if ((pi->sh->chip == BCM43224_CHIP_ID) ||
-		    (pi->sh->chip == BCM43225_CHIP_ID)) {
+		if ((pi->sh->chip == BCMA_CHIP_ID_BCM43224) ||
+		    (pi->sh->chip == BCMA_CHIP_ID_BCM43225)) {
 			if (spuravoid == 1) {
 				bcma_write16(pi->d11core,
 					     D11REGOFFS(tsf_clk_frac_l),
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pmu.c b/drivers/net/wireless/brcm80211/brcmsmac/pmu.c
index 6b4344f..7e9df56 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pmu.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pmu.c
@@ -103,9 +103,9 @@ u16 si_pmu_fast_pwrup_delay(struct si_pub *sih)
 	uint delay = PMU_MAX_TRANSITION_DLY;
 
 	switch (ai_get_chip_id(sih)) {
-	case BCM43224_CHIP_ID:
-	case BCM43225_CHIP_ID:
-	case BCM4313_CHIP_ID:
+	case BCMA_CHIP_ID_BCM43224:
+	case BCMA_CHIP_ID_BCM43225:
+	case BCMA_CHIP_ID_BCM4313:
 		delay = 3700;
 		break;
 	default:
@@ -156,9 +156,9 @@ u32 si_pmu_alp_clock(struct si_pub *sih)
 		return clock;
 
 	switch (ai_get_chip_id(sih)) {
-	case BCM43224_CHIP_ID:
-	case BCM43225_CHIP_ID:
-	case BCM4313_CHIP_ID:
+	case BCMA_CHIP_ID_BCM43224:
+	case BCMA_CHIP_ID_BCM43225:
+	case BCMA_CHIP_ID_BCM4313:
 		/* always 20Mhz */
 		clock = 20000 * 1000;
 		break;
-- 
1.7.9.5

