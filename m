Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2955 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754033Ab1GEWDU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 18:03:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 29/31] staging: brcm80211: remove macro WLBANDINITFN
 from brcmsmac
Date: Wed, 6 Jul 2011 00:02:56 +0200
Message-ID: <1309903378-29021-30-git-send-email-arend@broadcom.com> (sfid-20110706_000335_343168_6B7B99C6)
In-Reply-To: <1309903378-29021-1-git-send-email-arend@broadcom.com>
References: <1309903378-29021-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The macro WLBANDINITFN does nothing meaningful in the brcmsmac
driver and has been removed.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/bmac.c        |   12 ++++++------
 drivers/staging/brcm80211/brcmsmac/main.c        |    4 ++--
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |    6 +++---
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c |   22 +++++++++++-----------
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c   |    8 ++++----
 drivers/staging/brcm80211/brcmsmac/types.h       |    2 --
 6 files changed, 26 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/bmac.c b/drivers/staging/brcm80211/brcmsmac/bmac.c
index 225178e..b25c517 100644
--- a/drivers/staging/brcm80211/brcmsmac/bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/bmac.c
@@ -176,7 +176,7 @@ static void brcms_b_update_slot_timing(struct brcms_hardware *wlc_hw,
 	}
 }
 
-static void WLBANDINITFN(brcms_c_ucode_bsinit) (struct brcms_hardware *wlc_hw)
+static void brcms_c_ucode_bsinit(struct brcms_hardware *wlc_hw)
 {
 	struct wiphy *wiphy = wlc_hw->wlc->wiphy;
 
@@ -209,7 +209,7 @@ static void WLBANDINITFN(brcms_c_ucode_bsinit) (struct brcms_hardware *wlc_hw)
 }
 
 /* switch to new band but leave it inactive */
-static u32 WLBANDINITFN(brcms_c_setband_inact) (struct brcms_c_info *wlc,
+static u32 brcms_c_setband_inact(struct brcms_c_info *wlc,
 					    uint bandunit)
 {
 	struct brcms_hardware *wlc_hw = wlc->hw;
@@ -1671,7 +1671,7 @@ brcms_b_write_hw_bcntemplates(struct brcms_hardware *wlc_hw, void *bcn,
 	}
 }
 
-static void WLBANDINITFN(brcms_b_upd_synthpu) (struct brcms_hardware *wlc_hw)
+static void brcms_b_upd_synthpu(struct brcms_hardware *wlc_hw)
 {
 	u16 v;
 	struct brcms_c_info *wlc = wlc_hw->wlc;
@@ -1690,7 +1690,7 @@ static void WLBANDINITFN(brcms_b_upd_synthpu) (struct brcms_hardware *wlc_hw)
 
 /* band-specific init */
 static void
-WLBANDINITFN(brcms_b_bsinit) (struct brcms_c_info *wlc, chanspec_t chanspec)
+brcms_b_bsinit(struct brcms_c_info *wlc, chanspec_t chanspec)
 {
 	struct brcms_hardware *wlc_hw = wlc->hw;
 
@@ -1833,7 +1833,7 @@ void brcms_b_phy_reset(struct brcms_hardware *wlc_hw)
 
 /* switch to and initialize new band */
 static void
-WLBANDINITFN(brcms_b_setband) (struct brcms_hardware *wlc_hw, uint bandunit,
+brcms_b_setband(struct brcms_hardware *wlc_hw, uint bandunit,
 				chanspec_t chanspec) {
 	struct brcms_c_info *wlc = wlc_hw->wlc;
 	u32 macintmask;
@@ -1870,7 +1870,7 @@ WLBANDINITFN(brcms_b_setband) (struct brcms_hardware *wlc_hw, uint bandunit,
 }
 
 /* low-level band switch utility routine */
-void WLBANDINITFN(brcms_c_setxband) (struct brcms_hardware *wlc_hw,
+void brcms_c_setxband(struct brcms_hardware *wlc_hw,
 				     uint bandunit)
 {
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d: bandunit %d\n", wlc_hw->unit,
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 7c06026..1763c45 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -1024,7 +1024,7 @@ static void brcms_c_bandinit_ordered(struct brcms_c_info *wlc,
 }
 
 /* band-specific init */
-static void WLBANDINITFN(brcms_c_bsinit) (struct brcms_c_info *wlc)
+static void brcms_c_bsinit(struct brcms_c_info *wlc)
 {
 	BCMMSG(wlc->wiphy, "wl%d: bandunit %d\n",
 		 wlc->pub->unit, wlc->band->bandunit);
@@ -1041,7 +1041,7 @@ static void WLBANDINITFN(brcms_c_bsinit) (struct brcms_c_info *wlc)
 }
 
 /* switch to and initialize new band */
-static void WLBANDINITFN(brcms_c_setband) (struct brcms_c_info *wlc,
+static void brcms_c_setband(struct brcms_c_info *wlc,
 					   uint bandunit)
 {
 	int idx;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index 7b1b584..17012fb 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -433,7 +433,7 @@ void mod_phy_reg(struct brcms_phy *pi, u16 addr, u16 mask, u16 val)
 	pi->phy_wreg = 0;
 }
 
-static void WLBANDINITFN(wlc_set_phy_uninitted) (struct brcms_phy *pi)
+static void wlc_set_phy_uninitted(struct brcms_phy *pi)
 {
 	int i, j;
 
@@ -816,7 +816,7 @@ u32 wlc_phy_clk_bwbits(struct brcms_phy_pub *pih)
 	return phy_bw_clkbits;
 }
 
-void WLBANDINITFN(wlc_phy_por_inform) (struct brcms_phy_pub *ppi)
+void wlc_phy_por_inform(struct brcms_phy_pub *ppi)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
@@ -862,7 +862,7 @@ void wlc_phy_hw_state_upd(struct brcms_phy_pub *pih, bool newstate)
 	pi->sh->up = newstate;
 }
 
-void WLBANDINITFN(wlc_phy_init) (struct brcms_phy_pub *pih, chanspec_t chanspec)
+void wlc_phy_init(struct brcms_phy_pub *pih, chanspec_t chanspec)
 {
 	u32 mc;
 	initfn_t phy_init = NULL;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
index 41ac681..6a3fbe6 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -2269,7 +2269,7 @@ static void wlc_lcnphy_vbat_temp_sense_setup(struct brcms_phy *pi, u8 mode)
 	udelay(999);
 }
 
-static void WLBANDINITFN(wlc_lcnphy_tx_pwr_ctrl_init) (struct brcms_phy_pub *ppi)
+static void wlc_lcnphy_tx_pwr_ctrl_init(struct brcms_phy_pub *ppi)
 {
 	struct lcnphy_txgains tx_gains;
 	u8 bbmult;
@@ -3585,7 +3585,7 @@ void wlc_lcnphy_get_tssi(struct brcms_phy *pi, s8 *ofdm_pwr, s8 *cck_pwr)
 	}
 }
 
-void WLBANDINITFN(wlc_phy_cal_init_lcnphy) (struct brcms_phy *pi)
+void wlc_phy_cal_init_lcnphy(struct brcms_phy *pi)
 {
 	return;
 
@@ -3677,7 +3677,7 @@ static void wlc_lcnphy_set_rx_iq_comp(struct brcms_phy *pi, u16 a, u16 b)
 
 }
 
-void WLBANDINITFN(wlc_phy_init_lcnphy) (struct brcms_phy *pi)
+void wlc_phy_init_lcnphy(struct brcms_phy *pi)
 {
 	u8 phybw40;
 	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
@@ -4213,7 +4213,7 @@ wlc_lcnphy_tx_iqlo_loopback_cleanup(struct brcms_phy *pi, u16 *values_to_save)
 }
 
 static void
-WLBANDINITFN(wlc_lcnphy_load_tx_gain_table) (struct brcms_phy *pi,
+wlc_lcnphy_load_tx_gain_table(struct brcms_phy *pi,
 			const struct lcnphy_tx_gain_tbl_entry *gain_table) {
 	u32 j;
 	struct phytbl_info tab;
@@ -4297,7 +4297,7 @@ static void wlc_lcnphy_load_rfpower(struct brcms_phy *pi)
 	}
 }
 
-static void WLBANDINITFN(wlc_lcnphy_tbl_init) (struct brcms_phy *pi)
+static void wlc_lcnphy_tbl_init(struct brcms_phy *pi)
 {
 	uint idx;
 	u8 phybw40;
@@ -4392,7 +4392,7 @@ static void WLBANDINITFN(wlc_lcnphy_tbl_init) (struct brcms_phy *pi)
 	wlc_lcnphy_clear_papd_comptable(pi);
 }
 
-static void WLBANDINITFN(wlc_lcnphy_rev0_baseband_init) (struct brcms_phy *pi)
+static void wlc_lcnphy_rev0_baseband_init(struct brcms_phy *pi)
 {
 	u16 afectrl1;
 	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
@@ -4439,7 +4439,7 @@ static void WLBANDINITFN(wlc_lcnphy_rev0_baseband_init) (struct brcms_phy *pi)
 
 }
 
-static void WLBANDINITFN(wlc_lcnphy_rev2_baseband_init) (struct brcms_phy *pi)
+static void wlc_lcnphy_rev2_baseband_init(struct brcms_phy *pi)
 {
 	if (CHSPEC_IS5G(pi->radio_chanspec)) {
 		mod_phy_reg(pi, 0x416, (0xff << 0), 80 << 0);
@@ -4509,7 +4509,7 @@ static void wlc_lcnphy_agc_temp_init(struct brcms_phy *pi)
 
 }
 
-static void WLBANDINITFN(wlc_lcnphy_bu_tweaks) (struct brcms_phy *pi)
+static void wlc_lcnphy_bu_tweaks(struct brcms_phy *pi)
 {
 	if (NORADIO_ENAB(pi->pubpi))
 		return;
@@ -4564,7 +4564,7 @@ static void WLBANDINITFN(wlc_lcnphy_bu_tweaks) (struct brcms_phy *pi)
 	}
 }
 
-static void WLBANDINITFN(wlc_lcnphy_baseband_init) (struct brcms_phy *pi)
+static void wlc_lcnphy_baseband_init(struct brcms_phy *pi)
 {
 
 	wlc_lcnphy_tbl_init(pi);
@@ -4574,7 +4574,7 @@ static void WLBANDINITFN(wlc_lcnphy_baseband_init) (struct brcms_phy *pi)
 	wlc_lcnphy_bu_tweaks(pi);
 }
 
-static void WLBANDINITFN(wlc_radio_2064_init) (struct brcms_phy *pi)
+static void wlc_radio_2064_init(struct brcms_phy *pi)
 {
 	u32 i;
 	struct lcnphy_radio_regs *lcnphyregs = NULL;
@@ -4635,7 +4635,7 @@ static void WLBANDINITFN(wlc_radio_2064_init) (struct brcms_phy *pi)
 	wlc_lcnphy_rc_cal(pi);
 }
 
-static void WLBANDINITFN(wlc_lcnphy_radio_init) (struct brcms_phy *pi)
+static void wlc_lcnphy_radio_init(struct brcms_phy *pi)
 {
 	if (NORADIO_ENAB(pi->pubpi))
 		return;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
index 8e19bd0..f8e4192 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
@@ -14216,7 +14216,7 @@ bool wlc_phy_bist_check_phy(struct brcms_phy_pub *pih)
 	return false;
 }
 
-static void WLBANDINITFN(wlc_phy_bphy_init_nphy) (struct brcms_phy *pi)
+static void wlc_phy_bphy_init_nphy(struct brcms_phy *pi)
 {
 	u16 addr, val;
 
@@ -14273,7 +14273,7 @@ wlc_phy_table_read_nphy(struct brcms_phy *pi, u32 id, u32 len, u32 offset,
 }
 
 static void
-WLBANDINITFN(wlc_phy_static_table_download_nphy) (struct brcms_phy *pi)
+wlc_phy_static_table_download_nphy(struct brcms_phy *pi)
 {
 	uint idx;
 
@@ -14296,7 +14296,7 @@ WLBANDINITFN(wlc_phy_static_table_download_nphy) (struct brcms_phy *pi)
 	}
 }
 
-static void WLBANDINITFN(wlc_phy_tbl_init_nphy) (struct brcms_phy *pi)
+static void wlc_phy_tbl_init_nphy(struct brcms_phy *pi)
 {
 	uint idx = 0;
 	u8 antswctrllut;
@@ -14524,7 +14524,7 @@ static void wlc_phy_txpwrctrl_config_nphy(struct brcms_phy *pi)
 		pi->phy_5g_pwrgain = true;
 }
 
-void WLBANDINITFN(wlc_phy_init_nphy) (struct brcms_phy *pi)
+void wlc_phy_init_nphy(struct brcms_phy *pi)
 {
 	u16 val;
 	u16 clip1_ths[2];
diff --git a/drivers/staging/brcm80211/brcmsmac/types.h b/drivers/staging/brcm80211/brcmsmac/types.h
index d8514c3..bbf2189 100644
--- a/drivers/staging/brcm80211/brcmsmac/types.h
+++ b/drivers/staging/brcm80211/brcmsmac/types.h
@@ -244,8 +244,6 @@
 #define RXBND		8	/* max # frames to process in brcms_c_recv() */
 #define TXSBND		8	/* max # tx status to process in wlc_txstatus() */
 
-#define WLBANDINITFN(_fn)	_fn
-
 #define BAND_5G(bt)	((bt) == BRCM_BAND_5G)
 #define BAND_2G(bt)	((bt) == BRCM_BAND_2G)
 
-- 
1.7.4.1


