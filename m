Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2955 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609Ab1GEWDM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 18:03:12 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 13/31] staging: brcm80211: replaced typedef wlc_phy_t
 with struct brcms_phy_pub
Date: Wed, 6 Jul 2011 00:02:40 +0200
Message-ID: <1309903378-29021-14-git-send-email-arend@broadcom.com> (sfid-20110706_000329_863908_35737F81)
In-Reply-To: <1309903378-29021-1-git-send-email-arend@broadcom.com>
References: <1309903378-29021-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>


Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/bmac.c        |    2 +-
 drivers/staging/brcm80211/brcmsmac/main.h        |    4 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |  170 +++++++++++-----------
 drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h |  155 +++++++++++---------
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h |   21 ++--
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c |   21 ++--
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c   |   49 ++++---
 drivers/staging/brcm80211/brcmsmac/stf.c         |    2 +-
 drivers/staging/brcm80211/brcmsmac/types.h       |    1 -
 9 files changed, 223 insertions(+), 202 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/bmac.c b/drivers/staging/brcm80211/brcmsmac/bmac.c
index b506d16..b0446d8 100644
--- a/drivers/staging/brcm80211/brcmsmac/bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/bmac.c
@@ -1796,7 +1796,7 @@ void brcms_b_macphyclk_set(struct brcms_c_hw_info *wlc_hw, bool clk)
 
 void brcms_b_phy_reset(struct brcms_c_hw_info *wlc_hw)
 {
-	wlc_phy_t *pih = wlc_hw->band->pi;
+	struct brcms_phy_pub *pih = wlc_hw->band->pi;
 	u32 phy_bw_clkbits;
 	bool phy_in_reset = false;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index 1501a4b..6b8b4d2 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -369,7 +369,7 @@ struct brcms_c_band {
 	u16 phyrev;
 	u16 radioid;
 	u16 radiorev;
-	wlc_phy_t *pi;		/* pointer to phy specific information */
+	struct brcms_phy_pub *pi; /* pointer to phy specific information */
 	bool abgphy_encore;
 
 	u8 gmode;		/* currently active gmode */
@@ -475,7 +475,7 @@ struct brcms_c_hwband {
 	u16 phyrev;
 	u16 radioid;
 	u16 radiorev;
-	wlc_phy_t *pi;		/* pointer to phy specific information */
+	struct brcms_phy_pub *pi; /* pointer to phy specific information */
 	bool abgphy_encore;
 };
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index 7c8bf17..43a1dc5 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -132,7 +132,7 @@ static void wlc_phy_cal_perical_mphase_schedule(struct brcms_phy *pi,
 						uint delay);
 
 static void wlc_phy_noise_cb(struct brcms_phy *pi, u8 channel, s8 noise_dbm);
-static void wlc_phy_noise_sample_request(wlc_phy_t *pih, u8 reason,
+static void wlc_phy_noise_sample_request(struct brcms_phy_pub *pih, u8 reason,
 					 u8 ch);
 
 static void wlc_phy_txpower_reg_limit_calc(struct brcms_phy *pi,
@@ -180,19 +180,19 @@ int phy_getintvar(struct brcms_phy *pi, const char *name)
 	return simple_strtoul(val, NULL, 0);
 }
 
-void wlc_phyreg_enter(wlc_phy_t *pih)
+void wlc_phyreg_enter(struct brcms_phy_pub *pih)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 	wlapi_bmac_ucode_wake_override_phyreg_set(pi->sh->physhim);
 }
 
-void wlc_phyreg_exit(wlc_phy_t *pih)
+void wlc_phyreg_exit(struct brcms_phy_pub *pih)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 	wlapi_bmac_ucode_wake_override_phyreg_clear(pi->sh->physhim);
 }
 
-void wlc_radioreg_enter(wlc_phy_t *pih)
+void wlc_radioreg_enter(struct brcms_phy_pub *pih)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 	wlapi_bmac_mctrl(pi->sh->physhim, MCTL_LOCK_RADIO, MCTL_LOCK_RADIO);
@@ -200,7 +200,7 @@ void wlc_radioreg_enter(wlc_phy_t *pih)
 	udelay(10);
 }
 
-void wlc_radioreg_exit(wlc_phy_t *pih)
+void wlc_radioreg_exit(struct brcms_phy_pub *pih)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 	volatile u16 dummy;
@@ -507,8 +507,9 @@ struct shared_phy *wlc_phy_shared_attach(struct shared_phy_params *shp)
 	return sh;
 }
 
-wlc_phy_t *wlc_phy_attach(struct shared_phy *sh, void *regs, int bandtype,
-			  char *vars, struct wiphy *wiphy)
+struct brcms_phy_pub *
+wlc_phy_attach(struct shared_phy *sh, void *regs, int bandtype,
+	       char *vars, struct wiphy *wiphy)
 {
 	struct brcms_phy *pi;
 	u32 sflags = 0;
@@ -584,7 +585,7 @@ wlc_phy_t *wlc_phy_attach(struct shared_phy *sh, void *regs, int bandtype,
 		}
 	}
 
-	wlc_phy_anacore((wlc_phy_t *) pi, ON);
+	wlc_phy_anacore((struct brcms_phy_pub *) pi, ON);
 
 	idcode = wlc_phy_get_radio_ver(pi);
 	pi->pubpi.radioid =
@@ -596,7 +597,7 @@ wlc_phy_t *wlc_phy_attach(struct shared_phy *sh, void *regs, int bandtype,
 	if (!VALID_RADIO(pi, pi->pubpi.radioid))
 		goto err;
 
-	wlc_phy_switch_radio((wlc_phy_t *) pi, OFF);
+	wlc_phy_switch_radio((struct brcms_phy_pub *) pi, OFF);
 
 	wlc_set_phy_uninitted(pi);
 
@@ -670,7 +671,7 @@ wlc_phy_t *wlc_phy_attach(struct shared_phy *sh, void *regs, int bandtype,
 
 	pi->vars = (char *)&pi->vars;
 
-	memcpy(&pi->pubpi_ro, &pi->pubpi, sizeof(wlc_phy_t));
+	memcpy(&pi->pubpi_ro, &pi->pubpi, sizeof(struct brcms_phy_pub));
 
 	return &pi->pubpi_ro;
 
@@ -679,7 +680,7 @@ wlc_phy_t *wlc_phy_attach(struct shared_phy *sh, void *regs, int bandtype,
 	return NULL;
 }
 
-void wlc_phy_detach(wlc_phy_t *pih)
+void wlc_phy_detach(struct brcms_phy_pub *pih)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
@@ -706,7 +707,7 @@ void wlc_phy_detach(wlc_phy_t *pih)
 }
 
 bool
-wlc_phy_get_phyversion(wlc_phy_t *pih, u16 *phytype, u16 *phyrev,
+wlc_phy_get_phyversion(struct brcms_phy_pub *pih, u16 *phytype, u16 *phyrev,
 		       u16 *radioid, u16 *radiover)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
@@ -718,13 +719,13 @@ wlc_phy_get_phyversion(wlc_phy_t *pih, u16 *phytype, u16 *phyrev,
 	return true;
 }
 
-bool wlc_phy_get_encore(wlc_phy_t *pih)
+bool wlc_phy_get_encore(struct brcms_phy_pub *pih)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 	return pi->pubpi.abgphy_encore;
 }
 
-u32 wlc_phy_get_coreflags(wlc_phy_t *pih)
+u32 wlc_phy_get_coreflags(struct brcms_phy_pub *pih)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 	return pi->pubpi.coreflags;
@@ -753,7 +754,7 @@ static void wlc_phy_timercb_phycal(void *arg)
 
 }
 
-void wlc_phy_anacore(wlc_phy_t *pih, bool on)
+void wlc_phy_anacore(struct brcms_phy_pub *pih, bool on)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
@@ -790,7 +791,7 @@ void wlc_phy_anacore(wlc_phy_t *pih, bool on)
 	}
 }
 
-u32 wlc_phy_clk_bwbits(wlc_phy_t *pih)
+u32 wlc_phy_clk_bwbits(struct brcms_phy_pub *pih)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
@@ -815,14 +816,14 @@ u32 wlc_phy_clk_bwbits(wlc_phy_t *pih)
 	return phy_bw_clkbits;
 }
 
-void WLBANDINITFN(wlc_phy_por_inform) (wlc_phy_t *ppi)
+void WLBANDINITFN(wlc_phy_por_inform) (struct brcms_phy_pub *ppi)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
 	pi->phy_init_por = true;
 }
 
-void wlc_phy_edcrs_lock(wlc_phy_t *pih, bool lock)
+void wlc_phy_edcrs_lock(struct brcms_phy_pub *pih, bool lock)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
@@ -834,14 +835,14 @@ void wlc_phy_edcrs_lock(wlc_phy_t *pih, bool lock)
 	write_phy_reg(pi, 0x22f, 0x3c0);
 }
 
-void wlc_phy_initcal_enable(wlc_phy_t *pih, bool initcal)
+void wlc_phy_initcal_enable(struct brcms_phy_pub *pih, bool initcal)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
 	pi->do_initcal = initcal;
 }
 
-void wlc_phy_hw_clk_state_upd(wlc_phy_t *pih, bool newstate)
+void wlc_phy_hw_clk_state_upd(struct brcms_phy_pub *pih, bool newstate)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
@@ -851,7 +852,7 @@ void wlc_phy_hw_clk_state_upd(wlc_phy_t *pih, bool newstate)
 	pi->sh->clk = newstate;
 }
 
-void wlc_phy_hw_state_upd(wlc_phy_t *pih, bool newstate)
+void wlc_phy_hw_state_upd(struct brcms_phy_pub *pih, bool newstate)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
@@ -861,7 +862,7 @@ void wlc_phy_hw_state_upd(wlc_phy_t *pih, bool newstate)
 	pi->sh->up = newstate;
 }
 
-void WLBANDINITFN(wlc_phy_init) (wlc_phy_t *pih, chanspec_t chanspec)
+void WLBANDINITFN(wlc_phy_init) (struct brcms_phy_pub *pih, chanspec_t chanspec)
 {
 	u32 mc;
 	initfn_t phy_init = NULL;
@@ -900,7 +901,7 @@ void WLBANDINITFN(wlc_phy_init) (wlc_phy_t *pih, chanspec_t chanspec)
 
 	pi->nphy_gain_boost = true;
 
-	wlc_phy_switch_radio((wlc_phy_t *) pi, ON);
+	wlc_phy_switch_radio((struct brcms_phy_pub *) pi, ON);
 
 	(*phy_init) (pi);
 
@@ -912,12 +913,12 @@ void WLBANDINITFN(wlc_phy_init) (wlc_phy_t *pih, chanspec_t chanspec)
 	if (!(ISNPHY(pi)))
 		wlc_phy_txpower_update_shm(pi);
 
-	wlc_phy_ant_rxdiv_set((wlc_phy_t *) pi, pi->sh->rx_antdiv);
+	wlc_phy_ant_rxdiv_set((struct brcms_phy_pub *) pi, pi->sh->rx_antdiv);
 
 	pi->init_in_progress = false;
 }
 
-void wlc_phy_cal_init(wlc_phy_t *pih)
+void wlc_phy_cal_init(struct brcms_phy_pub *pih)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 	initfn_t cal_init = NULL;
@@ -935,7 +936,7 @@ void wlc_phy_cal_init(wlc_phy_t *pih)
 	}
 }
 
-int wlc_phy_down(wlc_phy_t *pih)
+int wlc_phy_down(struct brcms_phy_pub *pih)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 	int callbacks = 0;
@@ -1206,7 +1207,7 @@ void wlc_phy_do_dummy_tx(struct brcms_phy *pi, bool ofdm, bool pa_on)
 	}
 }
 
-void wlc_phy_hold_upd(wlc_phy_t *pih, mbool id, bool set)
+void wlc_phy_hold_upd(struct brcms_phy_pub *pih, mbool id, bool set)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
@@ -1219,7 +1220,7 @@ void wlc_phy_hold_upd(wlc_phy_t *pih, mbool id, bool set)
 	return;
 }
 
-void wlc_phy_mute_upd(wlc_phy_t *pih, bool mute, mbool flags)
+void wlc_phy_mute_upd(struct brcms_phy_pub *pih, bool mute, mbool flags)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
@@ -1234,7 +1235,7 @@ void wlc_phy_mute_upd(wlc_phy_t *pih, bool mute, mbool flags)
 	return;
 }
 
-void wlc_phy_clear_tssi(wlc_phy_t *pih)
+void wlc_phy_clear_tssi(struct brcms_phy_pub *pih)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
@@ -1253,7 +1254,7 @@ static bool wlc_phy_cal_txpower_recalc_sw(struct brcms_phy *pi)
 	return false;
 }
 
-void wlc_phy_switch_radio(wlc_phy_t *pih, bool on)
+void wlc_phy_switch_radio(struct brcms_phy_pub *pih, bool on)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
@@ -1296,35 +1297,35 @@ void wlc_phy_switch_radio(wlc_phy_t *pih, bool on)
 	}
 }
 
-u16 wlc_phy_bw_state_get(wlc_phy_t *ppi)
+u16 wlc_phy_bw_state_get(struct brcms_phy_pub *ppi)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
 	return pi->bw;
 }
 
-void wlc_phy_bw_state_set(wlc_phy_t *ppi, u16 bw)
+void wlc_phy_bw_state_set(struct brcms_phy_pub *ppi, u16 bw)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
 	pi->bw = bw;
 }
 
-void wlc_phy_chanspec_radio_set(wlc_phy_t *ppi, chanspec_t newch)
+void wlc_phy_chanspec_radio_set(struct brcms_phy_pub *ppi, chanspec_t newch)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 	pi->radio_chanspec = newch;
 
 }
 
-chanspec_t wlc_phy_chanspec_get(wlc_phy_t *ppi)
+chanspec_t wlc_phy_chanspec_get(struct brcms_phy_pub *ppi)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
 	return pi->radio_chanspec;
 }
 
-void wlc_phy_chanspec_set(wlc_phy_t *ppi, chanspec_t chanspec)
+void wlc_phy_chanspec_set(struct brcms_phy_pub *ppi, chanspec_t chanspec)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 	u16 m_cur_channel;
@@ -1374,7 +1375,8 @@ int wlc_phy_chanspec_bandrange_get(struct brcms_phy *pi, chanspec_t chanspec)
 	return range;
 }
 
-void wlc_phy_chanspec_ch14_widefilter_set(wlc_phy_t *ppi, bool wide_filter)
+void wlc_phy_chanspec_ch14_widefilter_set(struct brcms_phy_pub *ppi,
+					  bool wide_filter)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
@@ -1393,7 +1395,8 @@ int wlc_phy_channel2freq(uint channel)
 }
 
 void
-wlc_phy_chanspec_band_validch(wlc_phy_t *ppi, uint band, chanvec_t *channels)
+wlc_phy_chanspec_band_validch(struct brcms_phy_pub *ppi, uint band,
+			      chanvec_t *channels)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 	uint i;
@@ -1414,7 +1417,7 @@ wlc_phy_chanspec_band_validch(wlc_phy_t *ppi, uint band, chanvec_t *channels)
 	}
 }
 
-chanspec_t wlc_phy_chanspec_band_firstch(wlc_phy_t *ppi, uint band)
+chanspec_t wlc_phy_chanspec_band_firstch(struct brcms_phy_pub *ppi, uint band)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 	uint i;
@@ -1459,7 +1462,7 @@ chanspec_t wlc_phy_chanspec_band_firstch(wlc_phy_t *ppi, uint band)
 	return (chanspec_t) INVCHANSPEC;
 }
 
-int wlc_phy_txpower_get(wlc_phy_t *ppi, uint *qdbm, bool *override)
+int wlc_phy_txpower_get(struct brcms_phy_pub *ppi, uint *qdbm, bool *override)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
@@ -1469,7 +1472,8 @@ int wlc_phy_txpower_get(wlc_phy_t *ppi, uint *qdbm, bool *override)
 	return 0;
 }
 
-void wlc_phy_txpower_target_set(wlc_phy_t *ppi, struct txpwr_limits *txpwr)
+void wlc_phy_txpower_target_set(struct brcms_phy_pub *ppi,
+				struct txpwr_limits *txpwr)
 {
 	bool mac_enabled = false;
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
@@ -1518,7 +1522,7 @@ void wlc_phy_txpower_target_set(wlc_phy_t *ppi, struct txpwr_limits *txpwr)
 		wlapi_enable_mac(pi->sh->physhim);
 }
 
-int wlc_phy_txpower_set(wlc_phy_t *ppi, uint qdbm, bool override)
+int wlc_phy_txpower_set(struct brcms_phy_pub *ppi, uint qdbm, bool override)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 	int i;
@@ -1554,7 +1558,7 @@ int wlc_phy_txpower_set(wlc_phy_t *ppi, uint qdbm, bool override)
 }
 
 void
-wlc_phy_txpower_sromlimit(wlc_phy_t *ppi, uint channel, u8 *min_pwr,
+wlc_phy_txpower_sromlimit(struct brcms_phy_pub *ppi, uint channel, u8 *min_pwr,
 			  u8 *max_pwr, int txp_rate_idx)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
@@ -1604,8 +1608,8 @@ wlc_phy_txpower_sromlimit(wlc_phy_t *ppi, uint channel, u8 *min_pwr,
 }
 
 void
-wlc_phy_txpower_sromlimit_max_get(wlc_phy_t *ppi, uint chan, u8 *max_txpwr,
-				  u8 *min_txpwr)
+wlc_phy_txpower_sromlimit_max_get(struct brcms_phy_pub *ppi, uint chan,
+				  u8 *max_txpwr, u8 *min_txpwr)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 	u8 tx_pwr_max = 0;
@@ -1635,20 +1639,20 @@ wlc_phy_txpower_sromlimit_max_get(wlc_phy_t *ppi, uint chan, u8 *max_txpwr,
 }
 
 void
-wlc_phy_txpower_boardlimit_band(wlc_phy_t *ppi, uint bandunit, s32 *max_pwr,
-				s32 *min_pwr, u32 *step_pwr)
+wlc_phy_txpower_boardlimit_band(struct brcms_phy_pub *ppi, uint bandunit,
+				s32 *max_pwr, s32 *min_pwr, u32 *step_pwr)
 {
 	return;
 }
 
-u8 wlc_phy_txpower_get_target_min(wlc_phy_t *ppi)
+u8 wlc_phy_txpower_get_target_min(struct brcms_phy_pub *ppi)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
 	return pi->tx_power_min;
 }
 
-u8 wlc_phy_txpower_get_target_max(wlc_phy_t *ppi)
+u8 wlc_phy_txpower_get_target_max(struct brcms_phy_pub *ppi)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
@@ -1723,7 +1727,8 @@ void wlc_phy_txpower_recalc_target(struct brcms_phy *pi)
 
 		{
 
-			wlc_phy_txpower_sromlimit((wlc_phy_t *) pi, target_chan,
+			wlc_phy_txpower_sromlimit((struct brcms_phy_pub *) pi,
+						  target_chan,
 						  &mintxpwr, &maxtxpwr, rate);
 
 			maxtxpwr = min(maxtxpwr, pi->txpwr_limit[rate]);
@@ -1926,21 +1931,21 @@ wlc_phy_txpower_reg_limit_calc(struct brcms_phy *pi, struct txpwr_limits *txpwr,
 	}
 }
 
-void wlc_phy_txpwr_percent_set(wlc_phy_t *ppi, u8 txpwr_percent)
+void wlc_phy_txpwr_percent_set(struct brcms_phy_pub *ppi, u8 txpwr_percent)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
 	pi->txpwr_percent = txpwr_percent;
 }
 
-void wlc_phy_machwcap_set(wlc_phy_t *ppi, u32 machwcap)
+void wlc_phy_machwcap_set(struct brcms_phy_pub *ppi, u32 machwcap)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
 	pi->sh->machwcap = machwcap;
 }
 
-void wlc_phy_runbist_config(wlc_phy_t *ppi, bool start_end)
+void wlc_phy_runbist_config(struct brcms_phy_pub *ppi, bool start_end)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 	u16 rxc;
@@ -1971,7 +1976,7 @@ void wlc_phy_runbist_config(wlc_phy_t *ppi, bool start_end)
 }
 
 void
-wlc_phy_txpower_limit_set(wlc_phy_t *ppi, struct txpwr_limits *txpwr,
+wlc_phy_txpower_limit_set(struct brcms_phy_pub *ppi, struct txpwr_limits *txpwr,
 			  chanspec_t chanspec)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
@@ -1996,14 +2001,14 @@ wlc_phy_txpower_limit_set(wlc_phy_t *ppi, struct txpwr_limits *txpwr,
 	wlapi_enable_mac(pi->sh->physhim);
 }
 
-void wlc_phy_ofdm_rateset_war(wlc_phy_t *pih, bool war)
+void wlc_phy_ofdm_rateset_war(struct brcms_phy_pub *pih, bool war)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
 	pi->ofdm_rateset_war = war;
 }
 
-void wlc_phy_bf_preempt_enable(wlc_phy_t *pih, bool bf_preempt)
+void wlc_phy_bf_preempt_enable(struct brcms_phy_pub *pih, bool bf_preempt)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
@@ -2061,7 +2066,7 @@ void wlc_phy_txpower_update_shm(struct brcms_phy *pi)
 	}
 }
 
-bool wlc_phy_txpower_hw_ctrl_get(wlc_phy_t *ppi)
+bool wlc_phy_txpower_hw_ctrl_get(struct brcms_phy_pub *ppi)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
@@ -2072,7 +2077,7 @@ bool wlc_phy_txpower_hw_ctrl_get(wlc_phy_t *ppi)
 	}
 }
 
-void wlc_phy_txpower_hw_ctrl_set(wlc_phy_t *ppi, bool hwpwrctrl)
+void wlc_phy_txpower_hw_ctrl_set(struct brcms_phy_pub *ppi, bool hwpwrctrl)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 	bool cur_hwpwrctrl = pi->hwpwrctrl;
@@ -2174,7 +2179,8 @@ static u32 wlc_phy_txpower_est_power_nphy(struct brcms_phy *pi)
 }
 
 void
-wlc_phy_txpower_get_current(wlc_phy_t *ppi, tx_power_t *power, uint channel)
+wlc_phy_txpower_get_current(struct brcms_phy_pub *ppi, tx_power_t *power,
+			    uint channel)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 	uint rate, num_rates;
@@ -2215,9 +2221,9 @@ wlc_phy_txpower_get_current(wlc_phy_t *ppi, tx_power_t *power, uint channel)
 		u32 est_pout;
 
 		wlapi_suspend_mac_and_wait(pi->sh->physhim);
-		wlc_phyreg_enter((wlc_phy_t *) pi);
+		wlc_phyreg_enter((struct brcms_phy_pub *) pi);
 		est_pout = wlc_phy_txpower_est_power_nphy(pi);
-		wlc_phyreg_exit((wlc_phy_t *) pi);
+		wlc_phyreg_exit((struct brcms_phy_pub *) pi);
 		wlapi_enable_mac(pi->sh->physhim);
 
 		power->est_Pout[0] = (est_pout >> 8) & 0xff;
@@ -2271,21 +2277,21 @@ wlc_phy_txpower_get_current(wlc_phy_t *ppi, tx_power_t *power, uint channel)
 	}
 }
 
-void wlc_phy_antsel_type_set(wlc_phy_t *ppi, u8 antsel_type)
+void wlc_phy_antsel_type_set(struct brcms_phy_pub *ppi, u8 antsel_type)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
 	pi->antsel_type = antsel_type;
 }
 
-bool wlc_phy_test_ison(wlc_phy_t *ppi)
+bool wlc_phy_test_ison(struct brcms_phy_pub *ppi)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
 	return pi->phytest_on;
 }
 
-void wlc_phy_ant_rxdiv_set(wlc_phy_t *ppi, u8 val)
+void wlc_phy_ant_rxdiv_set(struct brcms_phy_pub *ppi, u8 val)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 	bool suspend;
@@ -2359,7 +2365,7 @@ wlc_phy_noise_calc_phy(struct brcms_phy *pi, u32 *cmplx_pwr, s8 *pwr_ant)
 }
 
 static void
-wlc_phy_noise_sample_request(wlc_phy_t *pih, u8 reason, u8 ch)
+wlc_phy_noise_sample_request(struct brcms_phy_pub *pih, u8 reason, u8 ch)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 	s8 noise_dbm = PHY_NOISE_FIXED_VAL_NPHY;
@@ -2493,7 +2499,7 @@ wlc_phy_noise_sample_request(wlc_phy_t *pih, u8 reason, u8 ch)
 
 }
 
-void wlc_phy_noise_sample_request_external(wlc_phy_t *pih)
+void wlc_phy_noise_sample_request_external(struct brcms_phy_pub *pih)
 {
 	u8 channel;
 
@@ -2564,7 +2570,7 @@ static s8 wlc_phy_noise_read_shmem(struct brcms_phy *pi)
 
 }
 
-void wlc_phy_noise_sample_intr(wlc_phy_t *pih)
+void wlc_phy_noise_sample_intr(struct brcms_phy_pub *pih)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 	u16 jssi_aux;
@@ -2675,7 +2681,7 @@ void wlc_phy_compute_dB(u32 *cmplx_pwr, s8 *p_cmplx_pwr_dB, u8 core)
 	}
 }
 
-void wlc_phy_rssi_compute(wlc_phy_t *pih, void *ctx)
+void wlc_phy_rssi_compute(struct brcms_phy_pub *pih, void *ctx)
 {
 	struct brcms_d11rxhdr *wlc_rxhdr = (struct brcms_d11rxhdr *) ctx;
 	struct d11rxhdr *rxh = &wlc_rxhdr->rxhdr;
@@ -2724,17 +2730,17 @@ void wlc_phy_rssi_compute(wlc_phy_t *pih, void *ctx)
 	wlc_rxhdr->rssi = (s8) rssi;
 }
 
-void wlc_phy_freqtrack_start(wlc_phy_t *pih)
+void wlc_phy_freqtrack_start(struct brcms_phy_pub *pih)
 {
 	return;
 }
 
-void wlc_phy_freqtrack_end(wlc_phy_t *pih)
+void wlc_phy_freqtrack_end(struct brcms_phy_pub *pih)
 {
 	return;
 }
 
-void wlc_phy_set_deaf(wlc_phy_t *ppi, bool user_flag)
+void wlc_phy_set_deaf(struct brcms_phy_pub *ppi, bool user_flag)
 {
 	struct brcms_phy *pi;
 	pi = (struct brcms_phy *) ppi;
@@ -2745,7 +2751,7 @@ void wlc_phy_set_deaf(wlc_phy_t *ppi, bool user_flag)
 		wlc_nphy_deaf_mode(pi, true);
 }
 
-void wlc_phy_watchdog(wlc_phy_t *pih)
+void wlc_phy_watchdog(struct brcms_phy_pub *pih)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 	bool delay_phy_cal = false;
@@ -2755,7 +2761,7 @@ void wlc_phy_watchdog(wlc_phy_t *pih)
 		return;
 
 	if (!(SCAN_RM_IN_PROGRESS(pi) || PLT_INPROG_PHY(pi))) {
-		wlc_phy_noise_sample_request((wlc_phy_t *) pi,
+		wlc_phy_noise_sample_request((struct brcms_phy_pub *) pi,
 					     PHY_NOISE_SAMPLE_MON,
 					     CHSPEC_CHANNEL(pi->
 							    radio_chanspec));
@@ -2786,7 +2792,7 @@ void wlc_phy_watchdog(wlc_phy_t *pih)
 		    (pi->nphy_perical != PHY_PERICAL_MANUAL) &&
 		    ((pi->sh->now - pi->nphy_perical_last) >=
 		     pi->sh->glacial_timer))
-			wlc_phy_cal_perical((wlc_phy_t *) pi,
+			wlc_phy_cal_perical((struct brcms_phy_pub *) pi,
 					    PHY_PERICAL_WATCHDOG);
 
 		wlc_phy_txpwr_papd_cal_nphy(pi);
@@ -2810,7 +2816,7 @@ void wlc_phy_watchdog(wlc_phy_t *pih)
 	}
 }
 
-void wlc_phy_BSSinit(wlc_phy_t *pih, bool bonlyap, int rssi)
+void wlc_phy_BSSinit(struct brcms_phy_pub *pih, bool bonlyap, int rssi)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 	uint i;
@@ -2931,7 +2937,7 @@ wlc_phy_cal_perical_mphase_schedule(struct brcms_phy *pi, uint delay)
 	wlapi_add_timer(pi->sh->physhim, pi->phycal_timer, delay, 0);
 }
 
-void wlc_phy_cal_perical(wlc_phy_t *pih, u8 reason)
+void wlc_phy_cal_perical(struct brcms_phy_pub *pih, u8 reason)
 {
 	s16 nphy_currtemp = 0;
 	s16 delta_temp = 0;
@@ -3029,7 +3035,7 @@ u8 wlc_phy_nbits(s32 value)
 	return nbits;
 }
 
-void wlc_phy_stf_chain_init(wlc_phy_t *pih, u8 txchain, u8 rxchain)
+void wlc_phy_stf_chain_init(struct brcms_phy_pub *pih, u8 txchain, u8 rxchain)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
@@ -3040,7 +3046,7 @@ void wlc_phy_stf_chain_init(wlc_phy_t *pih, u8 txchain, u8 rxchain)
 	pi->pubpi.phy_corenum = (u8) PHY_BITSCNT(pi->sh->phyrxchain);
 }
 
-void wlc_phy_stf_chain_set(wlc_phy_t *pih, u8 txchain, u8 rxchain)
+void wlc_phy_stf_chain_set(struct brcms_phy_pub *pih, u8 txchain, u8 rxchain)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
@@ -3052,7 +3058,7 @@ void wlc_phy_stf_chain_set(wlc_phy_t *pih, u8 txchain, u8 rxchain)
 	pi->pubpi.phy_corenum = (u8) PHY_BITSCNT(pi->sh->phyrxchain);
 }
 
-void wlc_phy_stf_chain_get(wlc_phy_t *pih, u8 *txchain, u8 *rxchain)
+void wlc_phy_stf_chain_get(struct brcms_phy_pub *pih, u8 *txchain, u8 *rxchain)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
@@ -3060,7 +3066,7 @@ void wlc_phy_stf_chain_get(wlc_phy_t *pih, u8 *txchain, u8 *rxchain)
 	*rxchain = pi->sh->phyrxchain;
 }
 
-u8 wlc_phy_stf_chain_active_get(wlc_phy_t *pih)
+u8 wlc_phy_stf_chain_active_get(struct brcms_phy_pub *pih)
 {
 	s16 nphy_currtemp;
 	u8 active_bitmap;
@@ -3092,7 +3098,7 @@ u8 wlc_phy_stf_chain_active_get(wlc_phy_t *pih)
 	return active_bitmap;
 }
 
-s8 wlc_phy_stf_ssmode_get(wlc_phy_t *pih, chanspec_t chanspec)
+s8 wlc_phy_stf_ssmode_get(struct brcms_phy_pub *pih, chanspec_t chanspec)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 	u8 siso_mcs_id, cdd_mcs_id;
@@ -3193,7 +3199,7 @@ static void wlc_phy_upd_env_txpwr_rate_limits(struct brcms_phy *pi, u32 band)
 
 }
 
-void wlc_phy_ldpc_override_set(wlc_phy_t *ppi, bool ldpc)
+void wlc_phy_ldpc_override_set(struct brcms_phy_pub *ppi, bool ldpc)
 {
 	return;
 }
@@ -3211,7 +3217,7 @@ s8 wlc_phy_upd_rssi_offset(struct brcms_phy *pi, s8 rssi, chanspec_t chanspec)
 	return rssi;
 }
 
-bool wlc_phy_txpower_ipa_ison(wlc_phy_t *ppi)
+bool wlc_phy_txpower_ipa_ison(struct brcms_phy_pub *ppi)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
index d1d03a6..a2df6b4 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
@@ -177,107 +177,118 @@ struct shared_phy_params {
 
 
 extern struct shared_phy *wlc_phy_shared_attach(struct shared_phy_params *shp);
-extern wlc_phy_t *wlc_phy_attach(struct shared_phy *sh, void *regs,
+extern struct brcms_phy_pub *wlc_phy_attach(struct shared_phy *sh, void *regs,
 				 int bandtype, char *vars, struct wiphy *wiphy);
-extern void wlc_phy_detach(wlc_phy_t *ppi);
+extern void wlc_phy_detach(struct brcms_phy_pub *ppi);
 
-extern bool wlc_phy_get_phyversion(wlc_phy_t *pih, u16 *phytype,
+extern bool wlc_phy_get_phyversion(struct brcms_phy_pub *pih, u16 *phytype,
 				   u16 *phyrev, u16 *radioid,
 				   u16 *radiover);
-extern bool wlc_phy_get_encore(wlc_phy_t *pih);
-extern u32 wlc_phy_get_coreflags(wlc_phy_t *pih);
+extern bool wlc_phy_get_encore(struct brcms_phy_pub *pih);
+extern u32 wlc_phy_get_coreflags(struct brcms_phy_pub *pih);
 
-extern void wlc_phy_hw_clk_state_upd(wlc_phy_t *ppi, bool newstate);
-extern void wlc_phy_hw_state_upd(wlc_phy_t *ppi, bool newstate);
-extern void wlc_phy_init(wlc_phy_t *ppi, chanspec_t chanspec);
-extern void wlc_phy_watchdog(wlc_phy_t *ppi);
-extern int wlc_phy_down(wlc_phy_t *ppi);
-extern u32 wlc_phy_clk_bwbits(wlc_phy_t *pih);
-extern void wlc_phy_cal_init(wlc_phy_t *ppi);
-extern void wlc_phy_antsel_init(wlc_phy_t *ppi, bool lut_init);
+extern void wlc_phy_hw_clk_state_upd(struct brcms_phy_pub *ppi, bool newstate);
+extern void wlc_phy_hw_state_upd(struct brcms_phy_pub *ppi, bool newstate);
+extern void wlc_phy_init(struct brcms_phy_pub *ppi, chanspec_t chanspec);
+extern void wlc_phy_watchdog(struct brcms_phy_pub *ppi);
+extern int wlc_phy_down(struct brcms_phy_pub *ppi);
+extern u32 wlc_phy_clk_bwbits(struct brcms_phy_pub *pih);
+extern void wlc_phy_cal_init(struct brcms_phy_pub *ppi);
+extern void wlc_phy_antsel_init(struct brcms_phy_pub *ppi, bool lut_init);
 
-extern void wlc_phy_chanspec_set(wlc_phy_t *ppi, chanspec_t chanspec);
-extern chanspec_t wlc_phy_chanspec_get(wlc_phy_t *ppi);
-extern void wlc_phy_chanspec_radio_set(wlc_phy_t *ppi, chanspec_t newch);
-extern u16 wlc_phy_bw_state_get(wlc_phy_t *ppi);
-extern void wlc_phy_bw_state_set(wlc_phy_t *ppi, u16 bw);
+extern void wlc_phy_chanspec_set(struct brcms_phy_pub *ppi,
+				 chanspec_t chanspec);
+extern chanspec_t wlc_phy_chanspec_get(struct brcms_phy_pub *ppi);
+extern void wlc_phy_chanspec_radio_set(struct brcms_phy_pub *ppi,
+				       chanspec_t newch);
+extern u16 wlc_phy_bw_state_get(struct brcms_phy_pub *ppi);
+extern void wlc_phy_bw_state_set(struct brcms_phy_pub *ppi, u16 bw);
 
-extern void wlc_phy_rssi_compute(wlc_phy_t *pih, void *ctx);
-extern void wlc_phy_por_inform(wlc_phy_t *ppi);
-extern void wlc_phy_noise_sample_intr(wlc_phy_t *ppi);
-extern bool wlc_phy_bist_check_phy(wlc_phy_t *ppi);
+extern void wlc_phy_rssi_compute(struct brcms_phy_pub *pih, void *ctx);
+extern void wlc_phy_por_inform(struct brcms_phy_pub *ppi);
+extern void wlc_phy_noise_sample_intr(struct brcms_phy_pub *ppi);
+extern bool wlc_phy_bist_check_phy(struct brcms_phy_pub *ppi);
 
-extern void wlc_phy_set_deaf(wlc_phy_t *ppi, bool user_flag);
+extern void wlc_phy_set_deaf(struct brcms_phy_pub *ppi, bool user_flag);
 
-extern void wlc_phy_switch_radio(wlc_phy_t *ppi, bool on);
-extern void wlc_phy_anacore(wlc_phy_t *ppi, bool on);
+extern void wlc_phy_switch_radio(struct brcms_phy_pub *ppi, bool on);
+extern void wlc_phy_anacore(struct brcms_phy_pub *ppi, bool on);
 
 
-extern void wlc_phy_BSSinit(wlc_phy_t *ppi, bool bonlyap, int rssi);
+extern void wlc_phy_BSSinit(struct brcms_phy_pub *ppi, bool bonlyap, int rssi);
 
-extern void wlc_phy_chanspec_ch14_widefilter_set(wlc_phy_t *ppi,
+extern void wlc_phy_chanspec_ch14_widefilter_set(struct brcms_phy_pub *ppi,
 						 bool wide_filter);
-extern void wlc_phy_chanspec_band_validch(wlc_phy_t *ppi, uint band,
+extern void wlc_phy_chanspec_band_validch(struct brcms_phy_pub *ppi, uint band,
 					  chanvec_t *channels);
-extern chanspec_t wlc_phy_chanspec_band_firstch(wlc_phy_t *ppi, uint band);
+extern chanspec_t wlc_phy_chanspec_band_firstch(struct brcms_phy_pub *ppi,
+						uint band);
 
-extern void wlc_phy_txpower_sromlimit(wlc_phy_t *ppi, uint chan,
+extern void wlc_phy_txpower_sromlimit(struct brcms_phy_pub *ppi, uint chan,
 				      u8 *_min_, u8 *_max_, int rate);
-extern void wlc_phy_txpower_sromlimit_max_get(wlc_phy_t *ppi, uint chan,
-					      u8 *_max_, u8 *_min_);
-extern void wlc_phy_txpower_boardlimit_band(wlc_phy_t *ppi, uint band, s32 *,
-					    s32 *, u32 *);
-extern void wlc_phy_txpower_limit_set(wlc_phy_t *ppi, struct txpwr_limits *,
+extern void wlc_phy_txpower_sromlimit_max_get(struct brcms_phy_pub *ppi,
+					      uint chan, u8 *_max_, u8 *_min_);
+extern void wlc_phy_txpower_boardlimit_band(struct brcms_phy_pub *ppi,
+					    uint band, s32 *, s32 *, u32 *);
+extern void wlc_phy_txpower_limit_set(struct brcms_phy_pub *ppi,
+				      struct txpwr_limits *,
 				      chanspec_t chanspec);
-extern int wlc_phy_txpower_get(wlc_phy_t *ppi, uint *qdbm, bool *override);
-extern int wlc_phy_txpower_set(wlc_phy_t *ppi, uint qdbm, bool override);
-extern void wlc_phy_txpower_target_set(wlc_phy_t *ppi, struct txpwr_limits *);
-extern bool wlc_phy_txpower_hw_ctrl_get(wlc_phy_t *ppi);
-extern void wlc_phy_txpower_hw_ctrl_set(wlc_phy_t *ppi, bool hwpwrctrl);
-extern u8 wlc_phy_txpower_get_target_min(wlc_phy_t *ppi);
-extern u8 wlc_phy_txpower_get_target_max(wlc_phy_t *ppi);
-extern bool wlc_phy_txpower_ipa_ison(wlc_phy_t *pih);
-
-extern void wlc_phy_stf_chain_init(wlc_phy_t *pih, u8 txchain,
+extern int wlc_phy_txpower_get(struct brcms_phy_pub *ppi, uint *qdbm,
+			       bool *override);
+extern int wlc_phy_txpower_set(struct brcms_phy_pub *ppi, uint qdbm,
+			       bool override);
+extern void wlc_phy_txpower_target_set(struct brcms_phy_pub *ppi,
+				       struct txpwr_limits *);
+extern bool wlc_phy_txpower_hw_ctrl_get(struct brcms_phy_pub *ppi);
+extern void wlc_phy_txpower_hw_ctrl_set(struct brcms_phy_pub *ppi,
+					bool hwpwrctrl);
+extern u8 wlc_phy_txpower_get_target_min(struct brcms_phy_pub *ppi);
+extern u8 wlc_phy_txpower_get_target_max(struct brcms_phy_pub *ppi);
+extern bool wlc_phy_txpower_ipa_ison(struct brcms_phy_pub *pih);
+
+extern void wlc_phy_stf_chain_init(struct brcms_phy_pub *pih, u8 txchain,
 				   u8 rxchain);
-extern void wlc_phy_stf_chain_set(wlc_phy_t *pih, u8 txchain,
+extern void wlc_phy_stf_chain_set(struct brcms_phy_pub *pih, u8 txchain,
 				  u8 rxchain);
-extern void wlc_phy_stf_chain_get(wlc_phy_t *pih, u8 *txchain,
+extern void wlc_phy_stf_chain_get(struct brcms_phy_pub *pih, u8 *txchain,
 				  u8 *rxchain);
-extern u8 wlc_phy_stf_chain_active_get(wlc_phy_t *pih);
-extern s8 wlc_phy_stf_ssmode_get(wlc_phy_t *pih, chanspec_t chanspec);
-extern void wlc_phy_ldpc_override_set(wlc_phy_t *ppi, bool val);
+extern u8 wlc_phy_stf_chain_active_get(struct brcms_phy_pub *pih);
+extern s8 wlc_phy_stf_ssmode_get(struct brcms_phy_pub *pih,
+				 chanspec_t chanspec);
+extern void wlc_phy_ldpc_override_set(struct brcms_phy_pub *ppi, bool val);
 
-extern void wlc_phy_cal_perical(wlc_phy_t *ppi, u8 reason);
-extern void wlc_phy_noise_sample_request_external(wlc_phy_t *ppi);
-extern void wlc_phy_edcrs_lock(wlc_phy_t *pih, bool lock);
-extern void wlc_phy_cal_papd_recal(wlc_phy_t *ppi);
+extern void wlc_phy_cal_perical(struct brcms_phy_pub *ppi, u8 reason);
+extern void wlc_phy_noise_sample_request_external(struct brcms_phy_pub *ppi);
+extern void wlc_phy_edcrs_lock(struct brcms_phy_pub *pih, bool lock);
+extern void wlc_phy_cal_papd_recal(struct brcms_phy_pub *ppi);
 
-extern void wlc_phy_ant_rxdiv_set(wlc_phy_t *ppi, u8 val);
-extern void wlc_phy_clear_tssi(wlc_phy_t *ppi);
-extern void wlc_phy_hold_upd(wlc_phy_t *ppi, mbool id, bool val);
-extern void wlc_phy_mute_upd(wlc_phy_t *ppi, bool val, mbool flags);
+extern void wlc_phy_ant_rxdiv_set(struct brcms_phy_pub *ppi, u8 val);
+extern void wlc_phy_clear_tssi(struct brcms_phy_pub *ppi);
+extern void wlc_phy_hold_upd(struct brcms_phy_pub *ppi, mbool id, bool val);
+extern void wlc_phy_mute_upd(struct brcms_phy_pub *ppi, bool val, mbool flags);
 
-extern void wlc_phy_antsel_type_set(wlc_phy_t *ppi, u8 antsel_type);
+extern void wlc_phy_antsel_type_set(struct brcms_phy_pub *ppi, u8 antsel_type);
 
-extern void wlc_phy_txpower_get_current(wlc_phy_t *ppi, tx_power_t *power,
-					uint channel);
+extern void wlc_phy_txpower_get_current(struct brcms_phy_pub *ppi,
+					tx_power_t *power, uint channel);
 
-extern void wlc_phy_initcal_enable(wlc_phy_t *pih, bool initcal);
-extern bool wlc_phy_test_ison(wlc_phy_t *ppi);
-extern void wlc_phy_txpwr_percent_set(wlc_phy_t *ppi, u8 txpwr_percent);
-extern void wlc_phy_ofdm_rateset_war(wlc_phy_t *pih, bool war);
-extern void wlc_phy_bf_preempt_enable(wlc_phy_t *pih, bool bf_preempt);
-extern void wlc_phy_machwcap_set(wlc_phy_t *ppi, u32 machwcap);
+extern void wlc_phy_initcal_enable(struct brcms_phy_pub *pih, bool initcal);
+extern bool wlc_phy_test_ison(struct brcms_phy_pub *ppi);
+extern void wlc_phy_txpwr_percent_set(struct brcms_phy_pub *ppi,
+				      u8 txpwr_percent);
+extern void wlc_phy_ofdm_rateset_war(struct brcms_phy_pub *pih, bool war);
+extern void wlc_phy_bf_preempt_enable(struct brcms_phy_pub *pih,
+				      bool bf_preempt);
+extern void wlc_phy_machwcap_set(struct brcms_phy_pub *ppi, u32 machwcap);
 
-extern void wlc_phy_runbist_config(wlc_phy_t *ppi, bool start_end);
+extern void wlc_phy_runbist_config(struct brcms_phy_pub *ppi, bool start_end);
 
-extern void wlc_phy_freqtrack_start(wlc_phy_t *ppi);
-extern void wlc_phy_freqtrack_end(wlc_phy_t *ppi);
+extern void wlc_phy_freqtrack_start(struct brcms_phy_pub *ppi);
+extern void wlc_phy_freqtrack_end(struct brcms_phy_pub *ppi);
 
 extern const u8 *wlc_phy_get_ofdm_rate_lookup(void);
 
-extern s8 wlc_phy_get_tx_power_offset_by_mcs(wlc_phy_t *ppi,
+extern s8 wlc_phy_get_tx_power_offset_by_mcs(struct brcms_phy_pub *ppi,
 					       u8 mcs_offset);
-extern s8 wlc_phy_get_tx_power_offset(wlc_phy_t *ppi, u8 tbl_offset);
+extern s8 wlc_phy_get_tx_power_offset(struct brcms_phy_pub *ppi, u8 tbl_offset);
 #endif				/* _BRCM_PHY_HAL_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
index 6e4c2b1..4659503 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
@@ -565,7 +565,7 @@ struct shared_phy {
 	bool _rifs_phy;
 };
 
-struct phy_pub {
+struct brcms_phy_pub {
 	uint phy_type;
 	uint phy_rev;
 	u8 phy_corenum;
@@ -594,7 +594,7 @@ struct phy_func_ptr {
 };
 
 struct brcms_phy {
-	wlc_phy_t pubpi_ro;
+	struct brcms_phy_pub pubpi_ro;
 	struct shared_phy *sh;
 	struct phy_func_ptr pi_fptr;
 	void *pi_ptr;
@@ -607,7 +607,7 @@ struct brcms_phy {
 	d11regs_t *regs;
 	struct brcms_phy *next;
 	char *vars;
-	wlc_phy_t pubpi;
+	struct brcms_phy_pub pubpi;
 
 	bool do_initcal;
 	bool phytest_on;
@@ -1002,10 +1002,10 @@ extern void xor_radio_reg(struct brcms_phy *pi, u16 addr, u16 mask);
 
 extern void write_radio_reg(struct brcms_phy *pi, u16 addr, u16 val);
 
-extern void wlc_phyreg_enter(wlc_phy_t *pih);
-extern void wlc_phyreg_exit(wlc_phy_t *pih);
-extern void wlc_radioreg_enter(wlc_phy_t *pih);
-extern void wlc_radioreg_exit(wlc_phy_t *pih);
+extern void wlc_phyreg_enter(struct brcms_phy_pub *pih);
+extern void wlc_phyreg_exit(struct brcms_phy_pub *pih);
+extern void wlc_radioreg_enter(struct brcms_phy_pub *pih);
+extern void wlc_radioreg_exit(struct brcms_phy_pub *pih);
 
 extern void wlc_phy_read_table(struct brcms_phy *pi,
 			       const struct phytbl_info *ptbl_info,
@@ -1125,7 +1125,7 @@ extern void wlc_lcnphy_tx_pwr_update_npt(struct brcms_phy *pi);
 extern s32 wlc_lcnphy_tssi2dbm(s32 tssi, s32 a1, s32 b0, s32 b1);
 extern void wlc_lcnphy_get_tssi(struct brcms_phy *pi, s8 *ofdm_pwr,
 				s8 *cck_pwr);
-extern void wlc_lcnphy_tx_power_adjustment(wlc_phy_t *ppi);
+extern void wlc_lcnphy_tx_power_adjustment(struct brcms_phy_pub *ppi);
 
 extern s32 wlc_lcnphy_rx_signal_power(struct brcms_phy *pi, s32 gain_index);
 
@@ -1185,8 +1185,9 @@ extern void wlc_phy_rx_iq_coeffs_nphy(struct brcms_phy *pi, u8 write,
 				      struct nphy_iq_comp *comp);
 extern void wlc_phy_aci_and_noise_reduction_nphy(struct brcms_phy *pi);
 
-extern void wlc_phy_rxcore_setstate_nphy(wlc_phy_t *pih, u8 rxcore_bitmask);
-extern u8 wlc_phy_rxcore_getstate_nphy(wlc_phy_t *pih);
+extern void wlc_phy_rxcore_setstate_nphy(struct brcms_phy_pub *pih,
+					 u8 rxcore_bitmask);
+extern u8 wlc_phy_rxcore_getstate_nphy(struct brcms_phy_pub *pih);
 
 extern void wlc_phy_txpwrctrl_enable_nphy(struct brcms_phy *pi, u8 ctrl_type);
 extern void wlc_phy_txpwr_fixpower_nphy(struct brcms_phy *pi);
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
index 0c9ceb7..70e79fc 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -991,7 +991,7 @@ static bool wlc_lcnphy_rx_iq_est(struct brcms_phy *pi, u16 num_samps,
 static bool wlc_lcnphy_calc_rx_iq_comp(struct brcms_phy *pi, u16 num_samps);
 static u16 wlc_lcnphy_get_pa_gain(struct brcms_phy *pi);
 static void wlc_lcnphy_afe_clk_init(struct brcms_phy *pi, u8 mode);
-extern void wlc_lcnphy_tx_pwr_ctrl_init(wlc_phy_t *ppi);
+extern void wlc_lcnphy_tx_pwr_ctrl_init(struct brcms_phy_pub *ppi);
 static void wlc_lcnphy_radio_2064_channel_tune_4313(struct brcms_phy *pi,
 						    u8 channel);
 
@@ -1210,7 +1210,7 @@ void wlc_phy_chanspec_set_lcnphy(struct brcms_phy *pi, chanspec_t chanspec)
 {
 	u8 channel = CHSPEC_CHANNEL(chanspec);
 
-	wlc_phy_chanspec_radio_set((wlc_phy_t *) pi, chanspec);
+	wlc_phy_chanspec_radio_set((struct brcms_phy_pub *) pi, chanspec);
 
 	wlc_lcnphy_set_chanspec_tweaks(pi, pi->radio_chanspec);
 
@@ -2067,7 +2067,7 @@ wlc_lcnphy_tx_iqlo_cal(struct brcms_phy *pi,
 
 }
 
-static void wlc_lcnphy_idle_tssi_est(wlc_phy_t *ppi)
+static void wlc_lcnphy_idle_tssi_est(struct brcms_phy_pub *ppi)
 {
 	bool suspend, tx_gain_override_old;
 	struct lcnphy_txgains old_gains;
@@ -2275,7 +2275,7 @@ static void wlc_lcnphy_vbat_temp_sense_setup(struct brcms_phy *pi, u8 mode)
 	udelay(999);
 }
 
-void WLBANDINITFN(wlc_lcnphy_tx_pwr_ctrl_init) (wlc_phy_t *ppi)
+void WLBANDINITFN(wlc_lcnphy_tx_pwr_ctrl_init) (struct brcms_phy_pub *ppi)
 {
 	struct lcnphy_txgains tx_gains;
 	u8 bbmult;
@@ -3501,7 +3501,7 @@ static void wlc_lcnphy_periodic_cal(struct brcms_phy *pi)
 
 	if (wlc_lcnphy_tssi_based_pwr_ctrl_enabled(pi)) {
 
-		wlc_lcnphy_idle_tssi_est((wlc_phy_t *) pi);
+		wlc_lcnphy_idle_tssi_est((struct brcms_phy_pub *) pi);
 
 		b0 = pi->txpa_2g[0];
 		b1 = pi->txpa_2g[1];
@@ -3563,7 +3563,8 @@ void wlc_lcnphy_calib_modes(struct brcms_phy *pi, uint mode)
 		break;
 	case LCNPHY_PERICAL_TEMPBASED_TXPWRCTRL:
 		if (wlc_lcnphy_tempsense_based_pwr_ctrl_enabled(pi))
-			wlc_lcnphy_tx_power_adjustment((wlc_phy_t *) pi);
+			wlc_lcnphy_tx_power_adjustment(
+						(struct brcms_phy_pub *) pi);
 		break;
 	}
 }
@@ -3649,7 +3650,7 @@ wlc_lcnphy_set_chanspec_tweaks(struct brcms_phy *pi, chanspec_t chanspec)
 	write_phy_reg(pi, 0x44a, 0x80);
 }
 
-void wlc_lcnphy_tx_power_adjustment(wlc_phy_t *ppi)
+void wlc_lcnphy_tx_power_adjustment(struct brcms_phy_pub *ppi)
 {
 	s8 index;
 	u16 index2;
@@ -3705,9 +3706,9 @@ void WLBANDINITFN(wlc_phy_init_lcnphy) (struct brcms_phy *pi)
 	wlc_lcnphy_radio_init(pi);
 
 	if (CHSPEC_IS2G(pi->radio_chanspec))
-		wlc_lcnphy_tx_pwr_ctrl_init((wlc_phy_t *) pi);
+		wlc_lcnphy_tx_pwr_ctrl_init((struct brcms_phy_pub *) pi);
 
-	wlc_phy_chanspec_set((wlc_phy_t *) pi, pi->radio_chanspec);
+	wlc_phy_chanspec_set((struct brcms_phy_pub *) pi, pi->radio_chanspec);
 
 	si_pmu_regcontrol(pi->sh->sih, 0, 0xf, 0x9);
 
@@ -4808,7 +4809,7 @@ static bool wlc_phy_txpwr_srom_read_lcnphy(struct brcms_phy *pi)
 		pi_lcn->lcnphy_freqoffset_corr =
 		    (u8) PHY_GETINTVAR(pi, "freqoffset_corr");
 		if ((u8) getintvar(pi->vars, "aa2g") > 1)
-			wlc_phy_ant_rxdiv_set((wlc_phy_t *) pi,
+			wlc_phy_ant_rxdiv_set((struct brcms_phy_pub *) pi,
 					      (u8) getintvar(pi->vars,
 								"aa2g"));
 	}
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
index 6e2417e..bc66c7f 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
@@ -14194,7 +14194,7 @@ static void wlc_phy_runsamples_nphy(struct brcms_phy *pi, u16 n, u16 lps,
 				    u16 wait, u8 iq, u8 dac_test_mode,
 				    bool modify_bbmult);
 
-bool wlc_phy_bist_check_phy(wlc_phy_t *pih)
+bool wlc_phy_bist_check_phy(struct brcms_phy_pub *pih)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 	u32 phybist0, phybist1, phybist2, phybist3, phybist4;
@@ -14832,7 +14832,7 @@ void WLBANDINITFN(wlc_phy_init_nphy) (struct brcms_phy *pi)
 	}
 
 	if (pi->sh->phyrxchain != 0x3) {
-		wlc_phy_rxcore_setstate_nphy((wlc_phy_t *) pi,
+		wlc_phy_rxcore_setstate_nphy((struct brcms_phy_pub *) pi,
 					     pi->sh->phyrxchain);
 	}
 
@@ -14871,7 +14871,8 @@ void WLBANDINITFN(wlc_phy_init_nphy) (struct brcms_phy *pi)
 			target_gain = wlc_phy_get_tx_gain_nphy(pi);
 
 			if (pi->antsel_type == ANTSEL_2x3)
-				wlc_phy_antsel_init((wlc_phy_t *) pi, true);
+				wlc_phy_antsel_init((struct brcms_phy_pub *) pi,
+						    true);
 
 			if (pi->nphy_perical != PHY_PERICAL_MPHASE) {
 				wlc_phy_rssi_cal_nphy(pi);
@@ -14901,7 +14902,7 @@ void WLBANDINITFN(wlc_phy_init_nphy) (struct brcms_phy *pi)
 			} else if (pi->mphase_cal_phase_id ==
 				   MPHASE_CAL_STATE_IDLE) {
 
-				wlc_phy_cal_perical((wlc_phy_t *) pi,
+				wlc_phy_cal_perical((struct brcms_phy_pub *) pi,
 						    PHY_PERICAL_PHYINIT);
 			}
 		} else {
@@ -15024,7 +15025,7 @@ void wlc_phy_stf_chain_upd_nphy(struct brcms_phy *pi)
 	}
 }
 
-void wlc_phy_rxcore_setstate_nphy(wlc_phy_t *pih, u8 rxcore_bitmask)
+void wlc_phy_rxcore_setstate_nphy(struct brcms_phy_pub *pih, u8 rxcore_bitmask)
 {
 	u16 regval;
 	u16 tbl_buf[16];
@@ -15105,7 +15106,7 @@ void wlc_phy_rxcore_setstate_nphy(wlc_phy_t *pih, u8 rxcore_bitmask)
 		wlapi_enable_mac(pi->sh->physhim);
 }
 
-u8 wlc_phy_rxcore_getstate_nphy(wlc_phy_t *pih)
+u8 wlc_phy_rxcore_getstate_nphy(struct brcms_phy_pub *pih)
 {
 	u16 regval, rxen_bits;
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
@@ -17281,14 +17282,14 @@ void wlc_phy_switch_radio_nphy(struct brcms_phy *pi, bool on)
 				wlc_phy_radio_postinit_2057(pi);
 			}
 
-			wlc_phy_chanspec_set((wlc_phy_t *) pi,
+			wlc_phy_chanspec_set((struct brcms_phy_pub *) pi,
 					     pi->radio_chanspec);
 		} else if (NREV_GE(pi->pubpi.phy_rev, 3)) {
 			wlc_phy_radio_preinit_205x(pi);
 			wlc_phy_radio_init_2056(pi);
 			wlc_phy_radio_postinit_2056(pi);
 
-			wlc_phy_chanspec_set((wlc_phy_t *) pi,
+			wlc_phy_chanspec_set((struct brcms_phy_pub *) pi,
 					     pi->radio_chanspec);
 		} else {
 			wlc_phy_radio_preinit_2055(pi);
@@ -17406,7 +17407,7 @@ static void wlc_phy_radio_postinit_2055(struct brcms_phy *pi)
 	and_radio_reg(pi, RADIO_2055_CAL_LPO_CNTRL,
 		      ~(RADIO_2055_CAL_LPO_ENABLE));
 
-	wlc_phy_chanspec_set((wlc_phy_t *) pi, pi->radio_chanspec);
+	wlc_phy_chanspec_set((struct brcms_phy_pub *) pi, pi->radio_chanspec);
 
 	write_radio_reg(pi, RADIO_2055_CORE1_RXBB_LPF, 9);
 	write_radio_reg(pi, RADIO_2055_CORE2_RXBB_LPF, 9);
@@ -19065,7 +19066,7 @@ void wlc_phy_chanspec_set_nphy(struct brcms_phy *pi, chanspec_t chanspec)
 	    (pi, CHSPEC_CHANNEL(chanspec), &freq, &t0, &t1, &t2, &t3))
 		return;
 
-	wlc_phy_chanspec_radio_set((wlc_phy_t *) pi, chanspec);
+	wlc_phy_chanspec_radio_set((struct brcms_phy_pub *) pi, chanspec);
 
 	if (CHSPEC_BW(chanspec) != pi->bw)
 		wlapi_bmac_bw_set(pi->sh->physhim, CHSPEC_BW(chanspec));
@@ -19480,7 +19481,7 @@ static void wlc_phy_restorecal_nphy(struct brcms_phy *pi)
 	}
 }
 
-void wlc_phy_antsel_init(wlc_phy_t *ppi, bool lut_init)
+void wlc_phy_antsel_init(struct brcms_phy_pub *ppi, bool lut_init)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 	u16 mask = 0xfc00;
@@ -21784,7 +21785,8 @@ static void wlc_phy_rssi_cal_nphy_rev3(struct brcms_phy *pi)
 		}
 	}
 
-	rxcore_state = wlc_phy_rxcore_getstate_nphy((wlc_phy_t *) pi);
+	rxcore_state = wlc_phy_rxcore_getstate_nphy(
+						(struct brcms_phy_pub *) pi);
 
 	vcm_level_max = 8;
 
@@ -23774,7 +23776,7 @@ void wlc_phy_cal_perical_nphy_run(struct brcms_phy *pi, u8 caltype)
 
 	wlapi_suspend_mac_and_wait(pi->sh->physhim);
 
-	wlc_phyreg_enter((wlc_phy_t *) pi);
+	wlc_phyreg_enter((struct brcms_phy_pub *) pi);
 
 	if ((pi->mphase_cal_phase_id == MPHASE_CAL_STATE_IDLE) ||
 	    (pi->mphase_cal_phase_id == MPHASE_CAL_STATE_INIT)) {
@@ -23797,7 +23799,7 @@ void wlc_phy_cal_perical_nphy_run(struct brcms_phy *pi, u8 caltype)
 	wlc_phy_txpwrctrl_enable_nphy(pi, PHY_TPC_HW_OFF);
 
 	if (pi->antsel_type == ANTSEL_2x3)
-		wlc_phy_antsel_init((wlc_phy_t *) pi, true);
+		wlc_phy_antsel_init((struct brcms_phy_pub *) pi, true);
 
 	mphase = (pi->mphase_cal_phase_id != MPHASE_CAL_STATE_IDLE);
 	if (!mphase) {
@@ -23814,12 +23816,12 @@ void wlc_phy_cal_perical_nphy_run(struct brcms_phy *pi, u8 caltype)
 			if (PHY_IPA(pi))
 				wlc_phy_a4(pi, true);
 
-			wlc_phyreg_exit((wlc_phy_t *) pi);
+			wlc_phyreg_exit((struct brcms_phy_pub *) pi);
 			wlapi_enable_mac(pi->sh->physhim);
 			wlapi_bmac_write_shm(pi->sh->physhim, M_CTS_DURATION,
 					     10000);
 			wlapi_suspend_mac_and_wait(pi->sh->physhim);
-			wlc_phyreg_enter((wlc_phy_t *) pi);
+			wlc_phyreg_enter((struct brcms_phy_pub *) pi);
 
 			if (0 == wlc_phy_cal_rxiq_nphy(pi, target_gain,
 							     (pi->
@@ -23984,7 +23986,7 @@ void wlc_phy_cal_perical_nphy_run(struct brcms_phy *pi, u8 caltype)
 	}
 
 	wlc_phy_txpwrctrl_enable_nphy(pi, tx_pwr_ctrl_state);
-	wlc_phyreg_exit((wlc_phy_t *) pi);
+	wlc_phyreg_exit((struct brcms_phy_pub *) pi);
 	wlapi_enable_mac(pi->sh->physhim);
 }
 
@@ -25694,7 +25696,8 @@ static int wlc_phy_cal_rxiq_nphy_rev3(struct brcms_phy *pi,
 
 	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x110, 16, cal_gain);
 
-	rxcore_state = wlc_phy_rxcore_getstate_nphy((wlc_phy_t *) pi);
+	rxcore_state = wlc_phy_rxcore_getstate_nphy(
+						(struct brcms_phy_pub *) pi);
 
 	for (rx_core = 0; rx_core < pi->pubpi.phy_corenum; rx_core++) {
 
@@ -25729,8 +25732,8 @@ static int wlc_phy_cal_rxiq_nphy_rev3(struct brcms_phy *pi,
 			if (rx_core == PHY_CORE_1) {
 
 				if (rxcore_state == 1) {
-					wlc_phy_rxcore_setstate_nphy((wlc_phy_t
-								      *) pi, 3);
+					wlc_phy_rxcore_setstate_nphy(
+						(struct brcms_phy_pub *) pi, 3);
 				}
 
 				wlc_phy_rxcal_gainctrl_nphy(pi, rx_core, NULL,
@@ -25741,9 +25744,9 @@ static int wlc_phy_cal_rxiq_nphy_rev3(struct brcms_phy *pi,
 				pi->nphy_rccal_value = best_rccal[rx_core];
 
 				if (rxcore_state == 1) {
-					wlc_phy_rxcore_setstate_nphy((wlc_phy_t
-								      *) pi,
-								     rxcore_state);
+					wlc_phy_rxcore_setstate_nphy(
+						(struct brcms_phy_pub *) pi,
+						rxcore_state);
 				}
 			}
 		}
diff --git a/drivers/staging/brcm80211/brcmsmac/stf.c b/drivers/staging/brcm80211/brcmsmac/stf.c
index d83d3a3..3d5979b 100644
--- a/drivers/staging/brcm80211/brcmsmac/stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/stf.c
@@ -72,7 +72,7 @@ static void brcms_c_stf_stbc_rx_ht_update(struct brcms_c_info *wlc, int val)
 /* every WLC_TEMPSENSE_PERIOD seconds temperature check to decide whether to turn on/off txchain */
 void brcms_c_tempsense_upd(struct brcms_c_info *wlc)
 {
-	wlc_phy_t *pi = wlc->band->pi;
+	struct brcms_phy_pub *pi = wlc->band->pi;
 	uint active_chains, txchain;
 
 	/* Check if the chip is too hot. Disable one Tx chain, if it is */
diff --git a/drivers/staging/brcm80211/brcmsmac/types.h b/drivers/staging/brcm80211/brcmsmac/types.h
index 32eb429..9e9fe56 100644
--- a/drivers/staging/brcm80211/brcmsmac/types.h
+++ b/drivers/staging/brcm80211/brcmsmac/types.h
@@ -385,7 +385,6 @@ typedef struct brcms_rateset wlc_rateset_t;
 typedef u32 ratespec_t;
 typedef struct tx_power tx_power_t;
 typedef struct chanvec chanvec_t;
-typedef struct phy_pub wlc_phy_t;
 typedef s32 fixed;
 typedef struct _cs32 cs32;
 typedef volatile union pmqreg pmqreg_t;
-- 
1.7.4.1


