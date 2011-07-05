Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1487 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754371Ab1GEWDV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 18:03:21 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 12/31] staging: brcm80211: replaced typedef phy_info_t
 by struct brcms_phy
Date: Wed, 6 Jul 2011 00:02:39 +0200
Message-ID: <1309903378-29021-13-git-send-email-arend@broadcom.com> (sfid-20110706_000354_825921_CF65D488)
In-Reply-To: <1309903378-29021-1-git-send-email-arend@broadcom.com>
References: <1309903378-29021-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |  249 +++++++------
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h |  248 +++++++------
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c |  342 +++++++++---------
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.h |    2 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c   |  431 +++++++++++-----------
 drivers/staging/brcm80211/brcmsmac/types.h       |    2 +-
 6 files changed, 648 insertions(+), 626 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index 57195a5..7c8bf17 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -121,29 +121,31 @@ const u8 ofdm_rate_lookup[] = {
 
 #define PHY_WREG_LIMIT	24
 
-static void wlc_set_phy_uninitted(phy_info_t *pi);
-static u32 wlc_phy_get_radio_ver(phy_info_t *pi);
+static void wlc_set_phy_uninitted(struct brcms_phy *pi);
+static u32 wlc_phy_get_radio_ver(struct brcms_phy *pi);
 static void wlc_phy_timercb_phycal(void *arg);
 
-static bool wlc_phy_noise_calc_phy(phy_info_t *pi, u32 *cmplx_pwr,
+static bool wlc_phy_noise_calc_phy(struct brcms_phy *pi, u32 *cmplx_pwr,
 				   s8 *pwr_ant);
 
-static void wlc_phy_cal_perical_mphase_schedule(phy_info_t *pi, uint delay);
-static void wlc_phy_noise_cb(phy_info_t *pi, u8 channel, s8 noise_dbm);
+static void wlc_phy_cal_perical_mphase_schedule(struct brcms_phy *pi,
+						uint delay);
+
+static void wlc_phy_noise_cb(struct brcms_phy *pi, u8 channel, s8 noise_dbm);
 static void wlc_phy_noise_sample_request(wlc_phy_t *pih, u8 reason,
 					 u8 ch);
 
-static void wlc_phy_txpower_reg_limit_calc(phy_info_t *pi,
+static void wlc_phy_txpower_reg_limit_calc(struct brcms_phy *pi,
 					   struct txpwr_limits *tp, chanspec_t);
-static bool wlc_phy_cal_txpower_recalc_sw(phy_info_t *pi);
+static bool wlc_phy_cal_txpower_recalc_sw(struct brcms_phy *pi);
 
-static s8 wlc_user_txpwr_antport_to_rfport(phy_info_t *pi, uint chan,
+static s8 wlc_user_txpwr_antport_to_rfport(struct brcms_phy *pi, uint chan,
 					     u32 band, u8 rate);
-static void wlc_phy_upd_env_txpwr_rate_limits(phy_info_t *pi, u32 band);
-static s8 wlc_phy_env_measure_vbat(phy_info_t *pi);
-static s8 wlc_phy_env_measure_temperature(phy_info_t *pi);
+static void wlc_phy_upd_env_txpwr_rate_limits(struct brcms_phy *pi, u32 band);
+static s8 wlc_phy_env_measure_vbat(struct brcms_phy *pi);
+static s8 wlc_phy_env_measure_temperature(struct brcms_phy *pi);
 
-char *phy_getvar(phy_info_t *pi, const char *name)
+char *phy_getvar(struct brcms_phy *pi, const char *name)
 {
 	char *vars = pi->vars;
 	char *s;
@@ -167,7 +169,7 @@ char *phy_getvar(phy_info_t *pi, const char *name)
 	return NULL;
 }
 
-int phy_getintvar(phy_info_t *pi, const char *name)
+int phy_getintvar(struct brcms_phy *pi, const char *name)
 {
 	char *val;
 
@@ -180,19 +182,19 @@ int phy_getintvar(phy_info_t *pi, const char *name)
 
 void wlc_phyreg_enter(wlc_phy_t *pih)
 {
-	phy_info_t *pi = (phy_info_t *) pih;
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
 	wlapi_bmac_ucode_wake_override_phyreg_set(pi->sh->physhim);
 }
 
 void wlc_phyreg_exit(wlc_phy_t *pih)
 {
-	phy_info_t *pi = (phy_info_t *) pih;
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
 	wlapi_bmac_ucode_wake_override_phyreg_clear(pi->sh->physhim);
 }
 
 void wlc_radioreg_enter(wlc_phy_t *pih)
 {
-	phy_info_t *pi = (phy_info_t *) pih;
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
 	wlapi_bmac_mctrl(pi->sh->physhim, MCTL_LOCK_RADIO, MCTL_LOCK_RADIO);
 
 	udelay(10);
@@ -200,7 +202,7 @@ void wlc_radioreg_enter(wlc_phy_t *pih)
 
 void wlc_radioreg_exit(wlc_phy_t *pih)
 {
-	phy_info_t *pi = (phy_info_t *) pih;
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
 	volatile u16 dummy;
 
 	dummy = R_REG(&pi->regs->phyversion);
@@ -208,7 +210,7 @@ void wlc_radioreg_exit(wlc_phy_t *pih)
 	wlapi_bmac_mctrl(pi->sh->physhim, MCTL_LOCK_RADIO, 0);
 }
 
-u16 read_radio_reg(phy_info_t *pi, u16 addr)
+u16 read_radio_reg(struct brcms_phy *pi, u16 addr)
 {
 	u16 data;
 
@@ -258,7 +260,7 @@ u16 read_radio_reg(phy_info_t *pi, u16 addr)
 	return data;
 }
 
-void write_radio_reg(phy_info_t *pi, u16 addr, u16 val)
+void write_radio_reg(struct brcms_phy *pi, u16 addr, u16 val)
 {
 	if (NORADIO_ENAB(pi->pubpi))
 		return;
@@ -282,7 +284,7 @@ void write_radio_reg(phy_info_t *pi, u16 addr, u16 val)
 	}
 }
 
-static u32 read_radio_id(phy_info_t *pi)
+static u32 read_radio_id(struct brcms_phy *pi)
 {
 	u32 id;
 
@@ -310,7 +312,7 @@ static u32 read_radio_id(phy_info_t *pi)
 	return id;
 }
 
-void and_radio_reg(phy_info_t *pi, u16 addr, u16 val)
+void and_radio_reg(struct brcms_phy *pi, u16 addr, u16 val)
 {
 	u16 rval;
 
@@ -321,7 +323,7 @@ void and_radio_reg(phy_info_t *pi, u16 addr, u16 val)
 	write_radio_reg(pi, addr, (rval & val));
 }
 
-void or_radio_reg(phy_info_t *pi, u16 addr, u16 val)
+void or_radio_reg(struct brcms_phy *pi, u16 addr, u16 val)
 {
 	u16 rval;
 
@@ -332,7 +334,7 @@ void or_radio_reg(phy_info_t *pi, u16 addr, u16 val)
 	write_radio_reg(pi, addr, (rval | val));
 }
 
-void xor_radio_reg(phy_info_t *pi, u16 addr, u16 mask)
+void xor_radio_reg(struct brcms_phy *pi, u16 addr, u16 mask)
 {
 	u16 rval;
 
@@ -343,7 +345,7 @@ void xor_radio_reg(phy_info_t *pi, u16 addr, u16 mask)
 	write_radio_reg(pi, addr, (rval ^ mask));
 }
 
-void mod_radio_reg(phy_info_t *pi, u16 addr, u16 mask, u16 val)
+void mod_radio_reg(struct brcms_phy *pi, u16 addr, u16 mask, u16 val)
 {
 	u16 rval;
 
@@ -354,12 +356,12 @@ void mod_radio_reg(phy_info_t *pi, u16 addr, u16 mask, u16 val)
 	write_radio_reg(pi, addr, (rval & ~mask) | (val & mask));
 }
 
-void write_phy_channel_reg(phy_info_t *pi, uint val)
+void write_phy_channel_reg(struct brcms_phy *pi, uint val)
 {
 	W_REG(&pi->regs->phychannel, val);
 }
 
-u16 read_phy_reg(phy_info_t *pi, u16 addr)
+u16 read_phy_reg(struct brcms_phy *pi, u16 addr)
 {
 	d11regs_t *regs;
 
@@ -371,7 +373,7 @@ u16 read_phy_reg(phy_info_t *pi, u16 addr)
 	return R_REG(&regs->phyregdata);
 }
 
-void write_phy_reg(phy_info_t *pi, u16 addr, u16 val)
+void write_phy_reg(struct brcms_phy *pi, u16 addr, u16 val)
 {
 	d11regs_t *regs;
 
@@ -394,7 +396,7 @@ void write_phy_reg(phy_info_t *pi, u16 addr, u16 val)
 #endif
 }
 
-void and_phy_reg(phy_info_t *pi, u16 addr, u16 val)
+void and_phy_reg(struct brcms_phy *pi, u16 addr, u16 val)
 {
 	d11regs_t *regs;
 
@@ -406,7 +408,7 @@ void and_phy_reg(phy_info_t *pi, u16 addr, u16 val)
 	pi->phy_wreg = 0;
 }
 
-void or_phy_reg(phy_info_t *pi, u16 addr, u16 val)
+void or_phy_reg(struct brcms_phy *pi, u16 addr, u16 val)
 {
 	d11regs_t *regs;
 
@@ -418,7 +420,7 @@ void or_phy_reg(phy_info_t *pi, u16 addr, u16 val)
 	pi->phy_wreg = 0;
 }
 
-void mod_phy_reg(phy_info_t *pi, u16 addr, u16 mask, u16 val)
+void mod_phy_reg(struct brcms_phy *pi, u16 addr, u16 mask, u16 val)
 {
 	d11regs_t *regs;
 
@@ -431,7 +433,7 @@ void mod_phy_reg(phy_info_t *pi, u16 addr, u16 mask, u16 val)
 	pi->phy_wreg = 0;
 }
 
-static void WLBANDINITFN(wlc_set_phy_uninitted) (phy_info_t *pi)
+static void WLBANDINITFN(wlc_set_phy_uninitted) (struct brcms_phy *pi)
 {
 	int i, j;
 
@@ -508,7 +510,7 @@ struct shared_phy *wlc_phy_shared_attach(struct shared_phy_params *shp)
 wlc_phy_t *wlc_phy_attach(struct shared_phy *sh, void *regs, int bandtype,
 			  char *vars, struct wiphy *wiphy)
 {
-	phy_info_t *pi;
+	struct brcms_phy *pi;
 	u32 sflags = 0;
 	uint phyversion;
 	u32 idcode;
@@ -533,7 +535,7 @@ wlc_phy_t *wlc_phy_attach(struct shared_phy *sh, void *regs, int bandtype,
 		return &pi->pubpi_ro;
 	}
 
-	pi = kzalloc(sizeof(phy_info_t), GFP_ATOMIC);
+	pi = kzalloc(sizeof(struct brcms_phy), GFP_ATOMIC);
 	if (pi == NULL) {
 		return NULL;
 	}
@@ -679,7 +681,7 @@ wlc_phy_t *wlc_phy_attach(struct shared_phy *sh, void *regs, int bandtype,
 
 void wlc_phy_detach(wlc_phy_t *pih)
 {
-	phy_info_t *pi = (phy_info_t *) pih;
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
 	if (pih) {
 		if (--pi->refcnt) {
@@ -707,7 +709,7 @@ bool
 wlc_phy_get_phyversion(wlc_phy_t *pih, u16 *phytype, u16 *phyrev,
 		       u16 *radioid, u16 *radiover)
 {
-	phy_info_t *pi = (phy_info_t *) pih;
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
 	*phytype = (u16) pi->pubpi.phy_type;
 	*phyrev = (u16) pi->pubpi.phy_rev;
 	*radioid = pi->pubpi.radioid;
@@ -718,19 +720,19 @@ wlc_phy_get_phyversion(wlc_phy_t *pih, u16 *phytype, u16 *phyrev,
 
 bool wlc_phy_get_encore(wlc_phy_t *pih)
 {
-	phy_info_t *pi = (phy_info_t *) pih;
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
 	return pi->pubpi.abgphy_encore;
 }
 
 u32 wlc_phy_get_coreflags(wlc_phy_t *pih)
 {
-	phy_info_t *pi = (phy_info_t *) pih;
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
 	return pi->pubpi.coreflags;
 }
 
 static void wlc_phy_timercb_phycal(void *arg)
 {
-	phy_info_t *pi = (phy_info_t *) arg;
+	struct brcms_phy *pi = (struct brcms_phy *) arg;
 	uint delay = 5;
 
 	if (PHY_PERICAL_MPHASE_PENDING(pi)) {
@@ -753,7 +755,7 @@ static void wlc_phy_timercb_phycal(void *arg)
 
 void wlc_phy_anacore(wlc_phy_t *pih, bool on)
 {
-	phy_info_t *pi = (phy_info_t *) pih;
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
 	if (ISNPHY(pi)) {
 		if (on) {
@@ -790,7 +792,7 @@ void wlc_phy_anacore(wlc_phy_t *pih, bool on)
 
 u32 wlc_phy_clk_bwbits(wlc_phy_t *pih)
 {
-	phy_info_t *pi = (phy_info_t *) pih;
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
 	u32 phy_bw_clkbits = 0;
 
@@ -815,14 +817,14 @@ u32 wlc_phy_clk_bwbits(wlc_phy_t *pih)
 
 void WLBANDINITFN(wlc_phy_por_inform) (wlc_phy_t *ppi)
 {
-	phy_info_t *pi = (phy_info_t *) ppi;
+	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
 	pi->phy_init_por = true;
 }
 
 void wlc_phy_edcrs_lock(wlc_phy_t *pih, bool lock)
 {
-	phy_info_t *pi = (phy_info_t *) pih;
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
 	pi->edcrs_threshold_lock = lock;
 
@@ -834,14 +836,14 @@ void wlc_phy_edcrs_lock(wlc_phy_t *pih, bool lock)
 
 void wlc_phy_initcal_enable(wlc_phy_t *pih, bool initcal)
 {
-	phy_info_t *pi = (phy_info_t *) pih;
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
 	pi->do_initcal = initcal;
 }
 
 void wlc_phy_hw_clk_state_upd(wlc_phy_t *pih, bool newstate)
 {
-	phy_info_t *pi = (phy_info_t *) pih;
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
 	if (!pi || !pi->sh)
 		return;
@@ -851,7 +853,7 @@ void wlc_phy_hw_clk_state_upd(wlc_phy_t *pih, bool newstate)
 
 void wlc_phy_hw_state_upd(wlc_phy_t *pih, bool newstate)
 {
-	phy_info_t *pi = (phy_info_t *) pih;
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
 	if (!pi || !pi->sh)
 		return;
@@ -863,7 +865,7 @@ void WLBANDINITFN(wlc_phy_init) (wlc_phy_t *pih, chanspec_t chanspec)
 {
 	u32 mc;
 	initfn_t phy_init = NULL;
-	phy_info_t *pi = (phy_info_t *) pih;
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
 	if (pi->init_in_progress)
 		return;
@@ -917,7 +919,7 @@ void WLBANDINITFN(wlc_phy_init) (wlc_phy_t *pih, chanspec_t chanspec)
 
 void wlc_phy_cal_init(wlc_phy_t *pih)
 {
-	phy_info_t *pi = (phy_info_t *) pih;
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
 	initfn_t cal_init = NULL;
 
 	if (WARN((R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC) != 0,
@@ -935,7 +937,7 @@ void wlc_phy_cal_init(wlc_phy_t *pih)
 
 int wlc_phy_down(wlc_phy_t *pih)
 {
-	phy_info_t *pi = (phy_info_t *) pih;
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
 	int callbacks = 0;
 
 	if (pi->phycal_timer
@@ -948,7 +950,7 @@ int wlc_phy_down(wlc_phy_t *pih)
 	return callbacks;
 }
 
-static u32 wlc_phy_get_radio_ver(phy_info_t *pi)
+static u32 wlc_phy_get_radio_ver(struct brcms_phy *pi)
 {
 	u32 ver;
 
@@ -958,7 +960,7 @@ static u32 wlc_phy_get_radio_ver(phy_info_t *pi)
 }
 
 void
-wlc_phy_table_addr(phy_info_t *pi, uint tbl_id, uint tbl_offset,
+wlc_phy_table_addr(struct brcms_phy *pi, uint tbl_id, uint tbl_offset,
 		   u16 tblAddr, u16 tblDataHi, u16 tblDataLo)
 {
 	write_phy_reg(pi, tblAddr, (tbl_id << 10) | tbl_offset);
@@ -974,7 +976,7 @@ wlc_phy_table_addr(phy_info_t *pi, uint tbl_id, uint tbl_offset,
 	}
 }
 
-void wlc_phy_table_data_write(phy_info_t *pi, uint width, u32 val)
+void wlc_phy_table_data_write(struct brcms_phy *pi, uint width, u32 val)
 {
 	if ((pi->sh->chip == BCM43224_CHIP_ID) &&
 	    (pi->sh->chiprev == 1) &&
@@ -997,7 +999,7 @@ void wlc_phy_table_data_write(phy_info_t *pi, uint width, u32 val)
 }
 
 void
-wlc_phy_write_table(phy_info_t *pi, const struct phytbl_info *ptbl_info,
+wlc_phy_write_table(struct brcms_phy *pi, const struct phytbl_info *ptbl_info,
 		    u16 tblAddr, u16 tblDataHi, u16 tblDataLo)
 {
 	uint idx;
@@ -1037,7 +1039,7 @@ wlc_phy_write_table(phy_info_t *pi, const struct phytbl_info *ptbl_info,
 }
 
 void
-wlc_phy_read_table(phy_info_t *pi, const struct phytbl_info *ptbl_info,
+wlc_phy_read_table(struct brcms_phy *pi, const struct phytbl_info *ptbl_info,
 		   u16 tblAddr, u16 tblDataHi, u16 tblDataLo)
 {
 	uint idx;
@@ -1075,7 +1077,7 @@ wlc_phy_read_table(phy_info_t *pi, const struct phytbl_info *ptbl_info,
 }
 
 uint
-wlc_phy_init_radio_regs_allbands(phy_info_t *pi,
+wlc_phy_init_radio_regs_allbands(struct brcms_phy *pi,
 				 struct radio_20xx_regs *radioregs)
 {
 	uint i = 0;
@@ -1093,7 +1095,7 @@ wlc_phy_init_radio_regs_allbands(phy_info_t *pi,
 }
 
 uint
-wlc_phy_init_radio_regs(phy_info_t *pi, struct radio_regs *radioregs,
+wlc_phy_init_radio_regs(struct brcms_phy *pi, struct radio_regs *radioregs,
 			u16 core_offset)
 {
 	uint i = 0;
@@ -1126,7 +1128,7 @@ wlc_phy_init_radio_regs(phy_info_t *pi, struct radio_regs *radioregs,
 	return i;
 }
 
-void wlc_phy_do_dummy_tx(phy_info_t *pi, bool ofdm, bool pa_on)
+void wlc_phy_do_dummy_tx(struct brcms_phy *pi, bool ofdm, bool pa_on)
 {
 #define	DUMMY_PKT_LEN	20
 	d11regs_t *regs = pi->regs;
@@ -1206,7 +1208,7 @@ void wlc_phy_do_dummy_tx(phy_info_t *pi, bool ofdm, bool pa_on)
 
 void wlc_phy_hold_upd(wlc_phy_t *pih, mbool id, bool set)
 {
-	phy_info_t *pi = (phy_info_t *) pih;
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
 	if (set) {
 		mboolset(pi->measure_hold, id);
@@ -1219,7 +1221,7 @@ void wlc_phy_hold_upd(wlc_phy_t *pih, mbool id, bool set)
 
 void wlc_phy_mute_upd(wlc_phy_t *pih, bool mute, mbool flags)
 {
-	phy_info_t *pi = (phy_info_t *) pih;
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
 	if (mute) {
 		mboolset(pi->measure_hold, PHY_HOLD_FOR_MUTE);
@@ -1234,7 +1236,7 @@ void wlc_phy_mute_upd(wlc_phy_t *pih, bool mute, mbool flags)
 
 void wlc_phy_clear_tssi(wlc_phy_t *pih)
 {
-	phy_info_t *pi = (phy_info_t *) pih;
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
 	if (ISNPHY(pi)) {
 		return;
@@ -1246,14 +1248,14 @@ void wlc_phy_clear_tssi(wlc_phy_t *pih)
 	}
 }
 
-static bool wlc_phy_cal_txpower_recalc_sw(phy_info_t *pi)
+static bool wlc_phy_cal_txpower_recalc_sw(struct brcms_phy *pi)
 {
 	return false;
 }
 
 void wlc_phy_switch_radio(wlc_phy_t *pih, bool on)
 {
-	phy_info_t *pi = (phy_info_t *) pih;
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
 	if (NORADIO_ENAB(pi->pubpi))
 		return;
@@ -1296,35 +1298,35 @@ void wlc_phy_switch_radio(wlc_phy_t *pih, bool on)
 
 u16 wlc_phy_bw_state_get(wlc_phy_t *ppi)
 {
-	phy_info_t *pi = (phy_info_t *) ppi;
+	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
 	return pi->bw;
 }
 
 void wlc_phy_bw_state_set(wlc_phy_t *ppi, u16 bw)
 {
-	phy_info_t *pi = (phy_info_t *) ppi;
+	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
 	pi->bw = bw;
 }
 
 void wlc_phy_chanspec_radio_set(wlc_phy_t *ppi, chanspec_t newch)
 {
-	phy_info_t *pi = (phy_info_t *) ppi;
+	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 	pi->radio_chanspec = newch;
 
 }
 
 chanspec_t wlc_phy_chanspec_get(wlc_phy_t *ppi)
 {
-	phy_info_t *pi = (phy_info_t *) ppi;
+	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
 	return pi->radio_chanspec;
 }
 
 void wlc_phy_chanspec_set(wlc_phy_t *ppi, chanspec_t chanspec)
 {
-	phy_info_t *pi = (phy_info_t *) ppi;
+	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 	u16 m_cur_channel;
 	chansetfn_t chanspec_set = NULL;
 
@@ -1357,7 +1359,7 @@ int wlc_phy_chanspec_freq2bandrange_lpssn(uint freq)
 	return range;
 }
 
-int wlc_phy_chanspec_bandrange_get(phy_info_t *pi, chanspec_t chanspec)
+int wlc_phy_chanspec_bandrange_get(struct brcms_phy *pi, chanspec_t chanspec)
 {
 	int range = -1;
 	uint channel = CHSPEC_CHANNEL(chanspec);
@@ -1374,7 +1376,7 @@ int wlc_phy_chanspec_bandrange_get(phy_info_t *pi, chanspec_t chanspec)
 
 void wlc_phy_chanspec_ch14_widefilter_set(wlc_phy_t *ppi, bool wide_filter)
 {
-	phy_info_t *pi = (phy_info_t *) ppi;
+	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
 	pi->channel_14_wide_filter = wide_filter;
 
@@ -1393,7 +1395,7 @@ int wlc_phy_channel2freq(uint channel)
 void
 wlc_phy_chanspec_band_validch(wlc_phy_t *ppi, uint band, chanvec_t *channels)
 {
-	phy_info_t *pi = (phy_info_t *) ppi;
+	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 	uint i;
 	uint channel;
 
@@ -1414,7 +1416,7 @@ wlc_phy_chanspec_band_validch(wlc_phy_t *ppi, uint band, chanvec_t *channels)
 
 chanspec_t wlc_phy_chanspec_band_firstch(wlc_phy_t *ppi, uint band)
 {
-	phy_info_t *pi = (phy_info_t *) ppi;
+	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 	uint i;
 	uint channel;
 	chanspec_t chspec;
@@ -1459,7 +1461,7 @@ chanspec_t wlc_phy_chanspec_band_firstch(wlc_phy_t *ppi, uint band)
 
 int wlc_phy_txpower_get(wlc_phy_t *ppi, uint *qdbm, bool *override)
 {
-	phy_info_t *pi = (phy_info_t *) ppi;
+	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
 	*qdbm = pi->tx_user_target[0];
 	if (override != NULL)
@@ -1470,7 +1472,7 @@ int wlc_phy_txpower_get(wlc_phy_t *ppi, uint *qdbm, bool *override)
 void wlc_phy_txpower_target_set(wlc_phy_t *ppi, struct txpwr_limits *txpwr)
 {
 	bool mac_enabled = false;
-	phy_info_t *pi = (phy_info_t *) ppi;
+	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
 	memcpy(&pi->tx_user_target[TXP_FIRST_CCK],
 	       &txpwr->cck[0], WLC_NUM_RATES_CCK);
@@ -1518,7 +1520,7 @@ void wlc_phy_txpower_target_set(wlc_phy_t *ppi, struct txpwr_limits *txpwr)
 
 int wlc_phy_txpower_set(wlc_phy_t *ppi, uint qdbm, bool override)
 {
-	phy_info_t *pi = (phy_info_t *) ppi;
+	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 	int i;
 
 	if (qdbm > 127)
@@ -1555,7 +1557,7 @@ void
 wlc_phy_txpower_sromlimit(wlc_phy_t *ppi, uint channel, u8 *min_pwr,
 			  u8 *max_pwr, int txp_rate_idx)
 {
-	phy_info_t *pi = (phy_info_t *) ppi;
+	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 	uint i;
 
 	*min_pwr = pi->min_txpower * WLC_TXPWR_DB_FACTOR;
@@ -1605,7 +1607,7 @@ void
 wlc_phy_txpower_sromlimit_max_get(wlc_phy_t *ppi, uint chan, u8 *max_txpwr,
 				  u8 *min_txpwr)
 {
-	phy_info_t *pi = (phy_info_t *) ppi;
+	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 	u8 tx_pwr_max = 0;
 	u8 tx_pwr_min = 255;
 	u8 max_num_rate;
@@ -1641,19 +1643,19 @@ wlc_phy_txpower_boardlimit_band(wlc_phy_t *ppi, uint bandunit, s32 *max_pwr,
 
 u8 wlc_phy_txpower_get_target_min(wlc_phy_t *ppi)
 {
-	phy_info_t *pi = (phy_info_t *) ppi;
+	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
 	return pi->tx_power_min;
 }
 
 u8 wlc_phy_txpower_get_target_max(wlc_phy_t *ppi)
 {
-	phy_info_t *pi = (phy_info_t *) ppi;
+	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
 	return pi->tx_power_max;
 }
 
-void wlc_phy_txpower_recalc_target(phy_info_t *pi)
+void wlc_phy_txpower_recalc_target(struct brcms_phy *pi)
 {
 	u8 maxtxpwr, mintxpwr, rate, pactrl;
 	uint target_chan;
@@ -1772,7 +1774,7 @@ void wlc_phy_txpower_recalc_target(phy_info_t *pi)
 }
 
 void
-wlc_phy_txpower_reg_limit_calc(phy_info_t *pi, struct txpwr_limits *txpwr,
+wlc_phy_txpower_reg_limit_calc(struct brcms_phy *pi, struct txpwr_limits *txpwr,
 			       chanspec_t chanspec)
 {
 	u8 tmp_txpwr_limit[2 * WLC_NUM_RATES_OFDM];
@@ -1926,21 +1928,21 @@ wlc_phy_txpower_reg_limit_calc(phy_info_t *pi, struct txpwr_limits *txpwr,
 
 void wlc_phy_txpwr_percent_set(wlc_phy_t *ppi, u8 txpwr_percent)
 {
-	phy_info_t *pi = (phy_info_t *) ppi;
+	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
 	pi->txpwr_percent = txpwr_percent;
 }
 
 void wlc_phy_machwcap_set(wlc_phy_t *ppi, u32 machwcap)
 {
-	phy_info_t *pi = (phy_info_t *) ppi;
+	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
 	pi->sh->machwcap = machwcap;
 }
 
 void wlc_phy_runbist_config(wlc_phy_t *ppi, bool start_end)
 {
-	phy_info_t *pi = (phy_info_t *) ppi;
+	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 	u16 rxc;
 	rxc = 0;
 
@@ -1972,7 +1974,7 @@ void
 wlc_phy_txpower_limit_set(wlc_phy_t *ppi, struct txpwr_limits *txpwr,
 			  chanspec_t chanspec)
 {
-	phy_info_t *pi = (phy_info_t *) ppi;
+	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
 	wlc_phy_txpower_reg_limit_calc(pi, txpwr, chanspec);
 
@@ -1996,19 +1998,19 @@ wlc_phy_txpower_limit_set(wlc_phy_t *ppi, struct txpwr_limits *txpwr,
 
 void wlc_phy_ofdm_rateset_war(wlc_phy_t *pih, bool war)
 {
-	phy_info_t *pi = (phy_info_t *) pih;
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
 	pi->ofdm_rateset_war = war;
 }
 
 void wlc_phy_bf_preempt_enable(wlc_phy_t *pih, bool bf_preempt)
 {
-	phy_info_t *pi = (phy_info_t *) pih;
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
 	pi->bf_preempt_4306 = bf_preempt;
 }
 
-void wlc_phy_txpower_update_shm(phy_info_t *pi)
+void wlc_phy_txpower_update_shm(struct brcms_phy *pi)
 {
 	int j;
 	if (ISNPHY(pi)) {
@@ -2061,7 +2063,7 @@ void wlc_phy_txpower_update_shm(phy_info_t *pi)
 
 bool wlc_phy_txpower_hw_ctrl_get(wlc_phy_t *ppi)
 {
-	phy_info_t *pi = (phy_info_t *) ppi;
+	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
 	if (ISNPHY(pi)) {
 		return pi->nphy_txpwrctrl;
@@ -2072,7 +2074,7 @@ bool wlc_phy_txpower_hw_ctrl_get(wlc_phy_t *ppi)
 
 void wlc_phy_txpower_hw_ctrl_set(wlc_phy_t *ppi, bool hwpwrctrl)
 {
-	phy_info_t *pi = (phy_info_t *) ppi;
+	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 	bool cur_hwpwrctrl = pi->hwpwrctrl;
 	bool suspend;
 
@@ -2108,7 +2110,7 @@ void wlc_phy_txpower_hw_ctrl_set(wlc_phy_t *ppi, bool hwpwrctrl)
 	}
 }
 
-void wlc_phy_txpower_ipa_upd(phy_info_t *pi)
+void wlc_phy_txpower_ipa_upd(struct brcms_phy *pi)
 {
 
 	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
@@ -2120,9 +2122,9 @@ void wlc_phy_txpower_ipa_upd(phy_info_t *pi)
 	}
 }
 
-static u32 wlc_phy_txpower_est_power_nphy(phy_info_t *pi);
+static u32 wlc_phy_txpower_est_power_nphy(struct brcms_phy *pi);
 
-static u32 wlc_phy_txpower_est_power_nphy(phy_info_t *pi)
+static u32 wlc_phy_txpower_est_power_nphy(struct brcms_phy *pi)
 {
 	s16 tx0_status, tx1_status;
 	u16 estPower1, estPower2;
@@ -2174,7 +2176,7 @@ static u32 wlc_phy_txpower_est_power_nphy(phy_info_t *pi)
 void
 wlc_phy_txpower_get_current(wlc_phy_t *ppi, tx_power_t *power, uint channel)
 {
-	phy_info_t *pi = (phy_info_t *) ppi;
+	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 	uint rate, num_rates;
 	u8 min_pwr, max_pwr;
 
@@ -2271,21 +2273,21 @@ wlc_phy_txpower_get_current(wlc_phy_t *ppi, tx_power_t *power, uint channel)
 
 void wlc_phy_antsel_type_set(wlc_phy_t *ppi, u8 antsel_type)
 {
-	phy_info_t *pi = (phy_info_t *) ppi;
+	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
 	pi->antsel_type = antsel_type;
 }
 
 bool wlc_phy_test_ison(wlc_phy_t *ppi)
 {
-	phy_info_t *pi = (phy_info_t *) ppi;
+	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
 	return pi->phytest_on;
 }
 
 void wlc_phy_ant_rxdiv_set(wlc_phy_t *ppi, u8 val)
 {
-	phy_info_t *pi = (phy_info_t *) ppi;
+	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 	bool suspend;
 
 	pi->sh->rx_antdiv = val;
@@ -2331,7 +2333,7 @@ void wlc_phy_ant_rxdiv_set(wlc_phy_t *ppi, u8 val)
 }
 
 static bool
-wlc_phy_noise_calc_phy(phy_info_t *pi, u32 *cmplx_pwr, s8 *pwr_ant)
+wlc_phy_noise_calc_phy(struct brcms_phy *pi, u32 *cmplx_pwr, s8 *pwr_ant)
 {
 	s8 cmplx_pwr_dbm[PHY_CORE_MAX];
 	u8 i;
@@ -2359,7 +2361,7 @@ wlc_phy_noise_calc_phy(phy_info_t *pi, u32 *cmplx_pwr, s8 *pwr_ant)
 static void
 wlc_phy_noise_sample_request(wlc_phy_t *pih, u8 reason, u8 ch)
 {
-	phy_info_t *pi = (phy_info_t *) pih;
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
 	s8 noise_dbm = PHY_NOISE_FIXED_VAL_NPHY;
 	bool sampling_in_progress = (pi->phynoise_state != 0);
 	bool wait_for_intr = true;
@@ -2500,7 +2502,7 @@ void wlc_phy_noise_sample_request_external(wlc_phy_t *pih)
 	wlc_phy_noise_sample_request(pih, PHY_NOISE_SAMPLE_EXTERNAL, channel);
 }
 
-static void wlc_phy_noise_cb(phy_info_t *pi, u8 channel, s8 noise_dbm)
+static void wlc_phy_noise_cb(struct brcms_phy *pi, u8 channel, s8 noise_dbm)
 {
 	if (!pi->phynoise_state)
 		return;
@@ -2521,7 +2523,7 @@ static void wlc_phy_noise_cb(phy_info_t *pi, u8 channel, s8 noise_dbm)
 
 }
 
-static s8 wlc_phy_noise_read_shmem(phy_info_t *pi)
+static s8 wlc_phy_noise_read_shmem(struct brcms_phy *pi)
 {
 	u32 cmplx_pwr[PHY_CORE_MAX];
 	s8 noise_dbm_ant[PHY_CORE_MAX];
@@ -2564,7 +2566,7 @@ static s8 wlc_phy_noise_read_shmem(phy_info_t *pi)
 
 void wlc_phy_noise_sample_intr(wlc_phy_t *pih)
 {
-	phy_info_t *pi = (phy_info_t *) pih;
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
 	u16 jssi_aux;
 	u8 channel = 0;
 	s8 noise_dbm = PHY_NOISE_FIXED_VAL_NPHY;
@@ -2679,7 +2681,7 @@ void wlc_phy_rssi_compute(wlc_phy_t *pih, void *ctx)
 	struct d11rxhdr *rxh = &wlc_rxhdr->rxhdr;
 	int rssi = le16_to_cpu(rxh->PhyRxStatus_1) & PRXS1_JSSI_MASK;
 	uint radioid = pih->radioid;
-	phy_info_t *pi = (phy_info_t *) pih;
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
 	if (NORADIO_ENAB(pi->pubpi)) {
 		rssi = WLC_RSSI_INVALID;
@@ -2694,7 +2696,7 @@ void wlc_phy_rssi_compute(wlc_phy_t *pih, void *ctx)
 
 	if (ISLCNPHY(pi)) {
 		u8 gidx = (le16_to_cpu(rxh->PhyRxStatus_2) & 0xFC00) >> 10;
-		struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+		struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 		if (rssi > 127)
 			rssi -= 256;
@@ -2734,8 +2736,8 @@ void wlc_phy_freqtrack_end(wlc_phy_t *pih)
 
 void wlc_phy_set_deaf(wlc_phy_t *ppi, bool user_flag)
 {
-	phy_info_t *pi;
-	pi = (phy_info_t *) ppi;
+	struct brcms_phy *pi;
+	pi = (struct brcms_phy *) ppi;
 
 	if (ISLCNPHY(pi))
 		wlc_lcnphy_deaf_mode(pi, true);
@@ -2745,7 +2747,7 @@ void wlc_phy_set_deaf(wlc_phy_t *ppi, bool user_flag)
 
 void wlc_phy_watchdog(wlc_phy_t *pih)
 {
-	phy_info_t *pi = (phy_info_t *) pih;
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
 	bool delay_phy_cal = false;
 	pi->sh->now++;
 
@@ -2810,7 +2812,7 @@ void wlc_phy_watchdog(wlc_phy_t *pih)
 
 void wlc_phy_BSSinit(wlc_phy_t *pih, bool bonlyap, int rssi)
 {
-	phy_info_t *pi = (phy_info_t *) pih;
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
 	uint i;
 	uint k;
 
@@ -2906,7 +2908,7 @@ void wlc_phy_cordic(fixed theta, cs32 *val)
 	val[0].q = val[0].q * signx;
 }
 
-void wlc_phy_cal_perical_mphase_reset(phy_info_t *pi)
+void wlc_phy_cal_perical_mphase_reset(struct brcms_phy *pi)
 {
 	wlapi_del_timer(pi->sh->physhim, pi->phycal_timer);
 
@@ -2915,7 +2917,8 @@ void wlc_phy_cal_perical_mphase_reset(phy_info_t *pi)
 	pi->mphase_txcal_cmdidx = 0;
 }
 
-static void wlc_phy_cal_perical_mphase_schedule(phy_info_t *pi, uint delay)
+static void
+wlc_phy_cal_perical_mphase_schedule(struct brcms_phy *pi, uint delay)
 {
 
 	if ((pi->nphy_perical != PHY_PERICAL_MPHASE) &&
@@ -2933,7 +2936,7 @@ void wlc_phy_cal_perical(wlc_phy_t *pih, u8 reason)
 	s16 nphy_currtemp = 0;
 	s16 delta_temp = 0;
 	bool do_periodic_cal = true;
-	phy_info_t *pi = (phy_info_t *) pih;
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
 	if (!ISNPHY(pi))
 		return;
@@ -3008,7 +3011,7 @@ void wlc_phy_cal_perical(wlc_phy_t *pih, u8 reason)
 	}
 }
 
-void wlc_phy_cal_perical_mphase_restart(phy_info_t *pi)
+void wlc_phy_cal_perical_mphase_restart(struct brcms_phy *pi)
 {
 	pi->mphase_cal_phase_id = MPHASE_CAL_STATE_INIT;
 	pi->mphase_txcal_cmdidx = 0;
@@ -3028,7 +3031,7 @@ u8 wlc_phy_nbits(s32 value)
 
 void wlc_phy_stf_chain_init(wlc_phy_t *pih, u8 txchain, u8 rxchain)
 {
-	phy_info_t *pi = (phy_info_t *) pih;
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
 	pi->sh->hw_phytxchain = txchain;
 	pi->sh->hw_phyrxchain = rxchain;
@@ -3039,7 +3042,7 @@ void wlc_phy_stf_chain_init(wlc_phy_t *pih, u8 txchain, u8 rxchain)
 
 void wlc_phy_stf_chain_set(wlc_phy_t *pih, u8 txchain, u8 rxchain)
 {
-	phy_info_t *pi = (phy_info_t *) pih;
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
 	pi->sh->phytxchain = txchain;
 
@@ -3051,7 +3054,7 @@ void wlc_phy_stf_chain_set(wlc_phy_t *pih, u8 txchain, u8 rxchain)
 
 void wlc_phy_stf_chain_get(wlc_phy_t *pih, u8 *txchain, u8 *rxchain)
 {
-	phy_info_t *pi = (phy_info_t *) pih;
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
 	*txchain = pi->sh->phytxchain;
 	*rxchain = pi->sh->phyrxchain;
@@ -3061,7 +3064,7 @@ u8 wlc_phy_stf_chain_active_get(wlc_phy_t *pih)
 {
 	s16 nphy_currtemp;
 	u8 active_bitmap;
-	phy_info_t *pi = (phy_info_t *) pih;
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
 	active_bitmap = (pi->phy_txcore_heatedup) ? 0x31 : 0x33;
 
@@ -3091,7 +3094,7 @@ u8 wlc_phy_stf_chain_active_get(wlc_phy_t *pih)
 
 s8 wlc_phy_stf_ssmode_get(wlc_phy_t *pih, chanspec_t chanspec)
 {
-	phy_info_t *pi = (phy_info_t *) pih;
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
 	u8 siso_mcs_id, cdd_mcs_id;
 
 	siso_mcs_id =
@@ -3113,7 +3116,7 @@ const u8 *wlc_phy_get_ofdm_rate_lookup(void)
 	return ofdm_rate_lookup;
 }
 
-void wlc_lcnphy_epa_switch(phy_info_t *pi, bool mode)
+void wlc_lcnphy_epa_switch(struct brcms_phy *pi, bool mode)
 {
 	if ((pi->sh->chip == BCM4313_CHIP_ID) &&
 	    (pi->sh->boardflags & BFL_FEM)) {
@@ -3151,7 +3154,7 @@ void wlc_lcnphy_epa_switch(phy_info_t *pi, bool mode)
 }
 
 static s8
-wlc_user_txpwr_antport_to_rfport(phy_info_t *pi, uint chan, u32 band,
+wlc_user_txpwr_antport_to_rfport(struct brcms_phy *pi, uint chan, u32 band,
 				 u8 rate)
 {
 	s8 offset = 0;
@@ -3161,7 +3164,7 @@ wlc_user_txpwr_antport_to_rfport(phy_info_t *pi, uint chan, u32 band,
 	return offset;
 }
 
-static s8 wlc_phy_env_measure_vbat(phy_info_t *pi)
+static s8 wlc_phy_env_measure_vbat(struct brcms_phy *pi)
 {
 	if (ISLCNPHY(pi))
 		return wlc_lcnphy_vbatsense(pi, 0);
@@ -3169,7 +3172,7 @@ static s8 wlc_phy_env_measure_vbat(phy_info_t *pi)
 		return 0;
 }
 
-static s8 wlc_phy_env_measure_temperature(phy_info_t *pi)
+static s8 wlc_phy_env_measure_temperature(struct brcms_phy *pi)
 {
 	if (ISLCNPHY(pi))
 		return wlc_lcnphy_tempsense_degree(pi, 0);
@@ -3177,7 +3180,7 @@ static s8 wlc_phy_env_measure_temperature(phy_info_t *pi)
 		return 0;
 }
 
-static void wlc_phy_upd_env_txpwr_rate_limits(phy_info_t *pi, u32 band)
+static void wlc_phy_upd_env_txpwr_rate_limits(struct brcms_phy *pi, u32 band)
 {
 	u8 i;
 	s8 temp, vbat;
@@ -3196,13 +3199,13 @@ void wlc_phy_ldpc_override_set(wlc_phy_t *ppi, bool ldpc)
 }
 
 void
-wlc_phy_get_pwrdet_offsets(phy_info_t *pi, s8 *cckoffset, s8 *ofdmoffset)
+wlc_phy_get_pwrdet_offsets(struct brcms_phy *pi, s8 *cckoffset, s8 *ofdmoffset)
 {
 	*cckoffset = 0;
 	*ofdmoffset = 0;
 }
 
-s8 wlc_phy_upd_rssi_offset(phy_info_t *pi, s8 rssi, chanspec_t chanspec)
+s8 wlc_phy_upd_rssi_offset(struct brcms_phy *pi, s8 rssi, chanspec_t chanspec)
 {
 
 	return rssi;
@@ -3210,7 +3213,7 @@ s8 wlc_phy_upd_rssi_offset(phy_info_t *pi, s8 rssi, chanspec_t chanspec)
 
 bool wlc_phy_txpower_ipa_ison(wlc_phy_t *ppi)
 {
-	phy_info_t *pi = (phy_info_t *) ppi;
+	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
 	if (ISNPHY(pi))
 		return wlc_phy_n_txpower_ipa_ison(pi);
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
index d8c86d9..6e4c2b1 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
@@ -49,16 +49,16 @@ struct brcms_phy_srom_fem {
 	u8 antswctrllut;	/* antswctrl lookup table configuration: 32 possible choices */
 };
 
-typedef void (*initfn_t) (phy_info_t *);
-typedef void (*chansetfn_t) (phy_info_t *, chanspec_t);
-typedef int (*longtrnfn_t) (phy_info_t *, int);
-typedef void (*txiqccgetfn_t) (phy_info_t *, u16 *, u16 *);
-typedef void (*txiqccsetfn_t) (phy_info_t *, u16, u16);
-typedef u16(*txloccgetfn_t) (phy_info_t *);
-typedef void (*radioloftgetfn_t) (phy_info_t *, u8 *, u8 *, u8 *,
+typedef void (*initfn_t) (struct brcms_phy *);
+typedef void (*chansetfn_t) (struct brcms_phy *, chanspec_t);
+typedef int (*longtrnfn_t) (struct brcms_phy *, int);
+typedef void (*txiqccgetfn_t) (struct brcms_phy *, u16 *, u16 *);
+typedef void (*txiqccsetfn_t) (struct brcms_phy *, u16, u16);
+typedef u16(*txloccgetfn_t) (struct brcms_phy *);
+typedef void (*radioloftgetfn_t) (struct brcms_phy *, u8 *, u8 *, u8 *,
 				  u8 *);
-typedef s32(*rxsigpwrfn_t) (phy_info_t *, s32);
-typedef void (*detachfn_t) (phy_info_t *);
+typedef s32(*rxsigpwrfn_t) (struct brcms_phy *, s32);
+typedef void (*detachfn_t) (struct brcms_phy *);
 
 #undef ISNPHY
 #undef ISLCNPHY
@@ -529,7 +529,7 @@ struct lcnphy_cal_results {
 };
 
 struct shared_phy {
-	struct phy_info *phy_head;
+	struct brcms_phy *phy_head;
 	uint unit;
 	struct si_pub *sih;
 	void *physhim;
@@ -593,19 +593,19 @@ struct phy_func_ptr {
 	detachfn_t detach;
 };
 
-struct phy_info {
+struct brcms_phy {
 	wlc_phy_t pubpi_ro;
 	struct shared_phy *sh;
 	struct phy_func_ptr pi_fptr;
 	void *pi_ptr;
 
 	union {
-		struct phy_info_lcnphy *pi_lcnphy;
+		struct brcms_phy_lcnphy *pi_lcnphy;
 	} u;
 	bool user_txpwr_at_rfport;
 
 	d11regs_t *regs;
-	struct phy_info *next;
+	struct brcms_phy *next;
 	char *vars;
 	wlc_phy_t pubpi;
 
@@ -982,98 +982,100 @@ extern struct radio_20xx_regs regs_2057_rev4[], regs_2057_rev5[],
 	      regs_2057_rev5v1[];
 extern struct radio_20xx_regs regs_2057_rev7[], regs_2057_rev8[];
 
-extern char *phy_getvar(phy_info_t *pi, const char *name);
-extern int phy_getintvar(phy_info_t *pi, const char *name);
+extern char *phy_getvar(struct brcms_phy *pi, const char *name);
+extern int phy_getintvar(struct brcms_phy *pi, const char *name);
 #define PHY_GETVAR(pi, name)	phy_getvar(pi, name)
 #define PHY_GETINTVAR(pi, name)	phy_getintvar(pi, name)
 
-extern u16 read_phy_reg(phy_info_t *pi, u16 addr);
-extern void write_phy_reg(phy_info_t *pi, u16 addr, u16 val);
-extern void and_phy_reg(phy_info_t *pi, u16 addr, u16 val);
-extern void or_phy_reg(phy_info_t *pi, u16 addr, u16 val);
-extern void mod_phy_reg(phy_info_t *pi, u16 addr, u16 mask, u16 val);
+extern u16 read_phy_reg(struct brcms_phy *pi, u16 addr);
+extern void write_phy_reg(struct brcms_phy *pi, u16 addr, u16 val);
+extern void and_phy_reg(struct brcms_phy *pi, u16 addr, u16 val);
+extern void or_phy_reg(struct brcms_phy *pi, u16 addr, u16 val);
+extern void mod_phy_reg(struct brcms_phy *pi, u16 addr, u16 mask, u16 val);
 
-extern u16 read_radio_reg(phy_info_t *pi, u16 addr);
-extern void or_radio_reg(phy_info_t *pi, u16 addr, u16 val);
-extern void and_radio_reg(phy_info_t *pi, u16 addr, u16 val);
-extern void mod_radio_reg(phy_info_t *pi, u16 addr, u16 mask,
+extern u16 read_radio_reg(struct brcms_phy *pi, u16 addr);
+extern void or_radio_reg(struct brcms_phy *pi, u16 addr, u16 val);
+extern void and_radio_reg(struct brcms_phy *pi, u16 addr, u16 val);
+extern void mod_radio_reg(struct brcms_phy *pi, u16 addr, u16 mask,
 			  u16 val);
-extern void xor_radio_reg(phy_info_t *pi, u16 addr, u16 mask);
+extern void xor_radio_reg(struct brcms_phy *pi, u16 addr, u16 mask);
 
-extern void write_radio_reg(phy_info_t *pi, u16 addr, u16 val);
+extern void write_radio_reg(struct brcms_phy *pi, u16 addr, u16 val);
 
 extern void wlc_phyreg_enter(wlc_phy_t *pih);
 extern void wlc_phyreg_exit(wlc_phy_t *pih);
 extern void wlc_radioreg_enter(wlc_phy_t *pih);
 extern void wlc_radioreg_exit(wlc_phy_t *pih);
 
-extern void wlc_phy_read_table(phy_info_t *pi,
+extern void wlc_phy_read_table(struct brcms_phy *pi,
 			       const struct phytbl_info *ptbl_info,
 			       u16 tblAddr, u16 tblDataHi,
 			       u16 tblDatalo);
-extern void wlc_phy_write_table(phy_info_t *pi,
+extern void wlc_phy_write_table(struct brcms_phy *pi,
 				const struct phytbl_info *ptbl_info,
 				u16 tblAddr, u16 tblDataHi, u16 tblDatalo);
-extern void wlc_phy_table_addr(phy_info_t *pi, uint tbl_id, uint tbl_offset,
-			       u16 tblAddr, u16 tblDataHi,
+extern void wlc_phy_table_addr(struct brcms_phy *pi, uint tbl_id,
+			       uint tbl_offset, u16 tblAddr, u16 tblDataHi,
 			       u16 tblDataLo);
-extern void wlc_phy_table_data_write(phy_info_t *pi, uint width, u32 val);
+extern void wlc_phy_table_data_write(struct brcms_phy *pi, uint width, u32 val);
 
-extern void write_phy_channel_reg(phy_info_t *pi, uint val);
-extern void wlc_phy_txpower_update_shm(phy_info_t *pi);
+extern void write_phy_channel_reg(struct brcms_phy *pi, uint val);
+extern void wlc_phy_txpower_update_shm(struct brcms_phy *pi);
 
 extern void wlc_phy_cordic(fixed theta, cs32 *val);
 extern u8 wlc_phy_nbits(s32 value);
 extern void wlc_phy_compute_dB(u32 *cmplx_pwr, s8 *p_dB, u8 core);
 
-extern uint wlc_phy_init_radio_regs_allbands(phy_info_t *pi,
+extern uint wlc_phy_init_radio_regs_allbands(struct brcms_phy *pi,
 					     struct radio_20xx_regs *radioregs);
-extern uint wlc_phy_init_radio_regs(phy_info_t *pi,
+extern uint wlc_phy_init_radio_regs(struct brcms_phy *pi,
 				    struct radio_regs *radioregs,
 				    u16 core_offset);
 
-extern void wlc_phy_txpower_ipa_upd(phy_info_t *pi);
+extern void wlc_phy_txpower_ipa_upd(struct brcms_phy *pi);
 
-extern void wlc_phy_do_dummy_tx(phy_info_t *pi, bool ofdm, bool pa_on);
+extern void wlc_phy_do_dummy_tx(struct brcms_phy *pi, bool ofdm, bool pa_on);
 extern void wlc_phy_papd_decode_epsilon(u32 epsilon, s32 *eps_real,
 					s32 *eps_imag);
 
-extern void wlc_phy_cal_perical_mphase_reset(phy_info_t *pi);
-extern void wlc_phy_cal_perical_mphase_restart(phy_info_t *pi);
+extern void wlc_phy_cal_perical_mphase_reset(struct brcms_phy *pi);
+extern void wlc_phy_cal_perical_mphase_restart(struct brcms_phy *pi);
 
-extern bool wlc_phy_attach_nphy(phy_info_t *pi);
-extern bool wlc_phy_attach_lcnphy(phy_info_t *pi);
+extern bool wlc_phy_attach_nphy(struct brcms_phy *pi);
+extern bool wlc_phy_attach_lcnphy(struct brcms_phy *pi);
 
-extern void wlc_phy_detach_lcnphy(phy_info_t *pi);
+extern void wlc_phy_detach_lcnphy(struct brcms_phy *pi);
 
-extern void wlc_phy_init_nphy(phy_info_t *pi);
-extern void wlc_phy_init_lcnphy(phy_info_t *pi);
+extern void wlc_phy_init_nphy(struct brcms_phy *pi);
+extern void wlc_phy_init_lcnphy(struct brcms_phy *pi);
 
-extern void wlc_phy_cal_init_nphy(phy_info_t *pi);
-extern void wlc_phy_cal_init_lcnphy(phy_info_t *pi);
+extern void wlc_phy_cal_init_nphy(struct brcms_phy *pi);
+extern void wlc_phy_cal_init_lcnphy(struct brcms_phy *pi);
 
-extern void wlc_phy_chanspec_set_nphy(phy_info_t *pi, chanspec_t chanspec);
-extern void wlc_phy_chanspec_set_lcnphy(phy_info_t *pi, chanspec_t chanspec);
-extern void wlc_phy_chanspec_set_fixup_lcnphy(phy_info_t *pi,
+extern void wlc_phy_chanspec_set_nphy(struct brcms_phy *pi,
+				      chanspec_t chanspec);
+extern void wlc_phy_chanspec_set_lcnphy(struct brcms_phy *pi,
+					chanspec_t chanspec);
+extern void wlc_phy_chanspec_set_fixup_lcnphy(struct brcms_phy *pi,
 					      chanspec_t chanspec);
 extern int wlc_phy_channel2freq(uint channel);
 extern int wlc_phy_chanspec_freq2bandrange_lpssn(uint);
-extern int wlc_phy_chanspec_bandrange_get(phy_info_t *, chanspec_t);
+extern int wlc_phy_chanspec_bandrange_get(struct brcms_phy *, chanspec_t);
 
-extern void wlc_lcnphy_set_tx_pwr_ctrl(phy_info_t *pi, u16 mode);
-extern s8 wlc_lcnphy_get_current_tx_pwr_idx(phy_info_t *pi);
+extern void wlc_lcnphy_set_tx_pwr_ctrl(struct brcms_phy *pi, u16 mode);
+extern s8 wlc_lcnphy_get_current_tx_pwr_idx(struct brcms_phy *pi);
 
-extern void wlc_phy_txpower_recalc_target_nphy(phy_info_t *pi);
-extern void wlc_lcnphy_txpower_recalc_target(phy_info_t *pi);
-extern void wlc_phy_txpower_recalc_target_lcnphy(phy_info_t *pi);
+extern void wlc_phy_txpower_recalc_target_nphy(struct brcms_phy *pi);
+extern void wlc_lcnphy_txpower_recalc_target(struct brcms_phy *pi);
+extern void wlc_phy_txpower_recalc_target_lcnphy(struct brcms_phy *pi);
 
-extern void wlc_lcnphy_set_tx_pwr_by_index(phy_info_t *pi, int index);
-extern void wlc_lcnphy_tx_pu(phy_info_t *pi, bool bEnable);
-extern void wlc_lcnphy_stop_tx_tone(phy_info_t *pi);
-extern void wlc_lcnphy_start_tx_tone(phy_info_t *pi, s32 f_kHz,
+extern void wlc_lcnphy_set_tx_pwr_by_index(struct brcms_phy *pi, int index);
+extern void wlc_lcnphy_tx_pu(struct brcms_phy *pi, bool bEnable);
+extern void wlc_lcnphy_stop_tx_tone(struct brcms_phy *pi);
+extern void wlc_lcnphy_start_tx_tone(struct brcms_phy *pi, s32 f_kHz,
 				     u16 max_val, bool iqcalmode);
 
-extern void wlc_phy_txpower_sromlimit_get_nphy(phy_info_t *pi, uint chan,
+extern void wlc_phy_txpower_sromlimit_get_nphy(struct brcms_phy *pi, uint chan,
 					       u8 *max_pwr, u8 rate_id);
 extern void wlc_phy_ofdm_to_mcs_powers_nphy(u8 *power, u8 rate_mcs_start,
 					    u8 rate_mcs_end,
@@ -1083,16 +1085,16 @@ extern void wlc_phy_mcs_to_ofdm_powers_nphy(u8 *power,
 					    u8 rate_ofdm_end,
 					    u8 rate_mcs_start);
 
-extern u16 wlc_lcnphy_tempsense(phy_info_t *pi, bool mode);
-extern s16 wlc_lcnphy_tempsense_new(phy_info_t *pi, bool mode);
-extern s8 wlc_lcnphy_tempsense_degree(phy_info_t *pi, bool mode);
-extern s8 wlc_lcnphy_vbatsense(phy_info_t *pi, bool mode);
-extern void wlc_phy_carrier_suppress_lcnphy(phy_info_t *pi);
-extern void wlc_lcnphy_crsuprs(phy_info_t *pi, int channel);
-extern void wlc_lcnphy_epa_switch(phy_info_t *pi, bool mode);
-extern void wlc_2064_vco_cal(phy_info_t *pi);
+extern u16 wlc_lcnphy_tempsense(struct brcms_phy *pi, bool mode);
+extern s16 wlc_lcnphy_tempsense_new(struct brcms_phy *pi, bool mode);
+extern s8 wlc_lcnphy_tempsense_degree(struct brcms_phy *pi, bool mode);
+extern s8 wlc_lcnphy_vbatsense(struct brcms_phy *pi, bool mode);
+extern void wlc_phy_carrier_suppress_lcnphy(struct brcms_phy *pi);
+extern void wlc_lcnphy_crsuprs(struct brcms_phy *pi, int channel);
+extern void wlc_lcnphy_epa_switch(struct brcms_phy *pi, bool mode);
+extern void wlc_2064_vco_cal(struct brcms_phy *pi);
 
-extern void wlc_phy_txpower_recalc_target(phy_info_t *pi);
+extern void wlc_phy_txpower_recalc_target(struct brcms_phy *pi);
 
 #define LCNPHY_TBL_ID_PAPDCOMPDELTATBL	0x18
 #define LCNPHY_TX_POWER_TABLE_SIZE	128
@@ -1106,25 +1108,26 @@ extern void wlc_phy_txpower_recalc_target(phy_info_t *pi);
 
 #define LCNPHY_TX_PWR_CTRL_TEMPBASED	0xE001
 
-extern void wlc_lcnphy_write_table(phy_info_t *pi,
+extern void wlc_lcnphy_write_table(struct brcms_phy *pi,
 				   const struct phytbl_info *pti);
-extern void wlc_lcnphy_read_table(phy_info_t *pi, struct phytbl_info *pti);
-extern void wlc_lcnphy_set_tx_iqcc(phy_info_t *pi, u16 a, u16 b);
-extern void wlc_lcnphy_set_tx_locc(phy_info_t *pi, u16 didq);
-extern void wlc_lcnphy_get_tx_iqcc(phy_info_t *pi, u16 *a, u16 *b);
-extern u16 wlc_lcnphy_get_tx_locc(phy_info_t *pi);
-extern void wlc_lcnphy_get_radio_loft(phy_info_t *pi, u8 *ei0,
+extern void wlc_lcnphy_read_table(struct brcms_phy *pi,
+				  struct phytbl_info *pti);
+extern void wlc_lcnphy_set_tx_iqcc(struct brcms_phy *pi, u16 a, u16 b);
+extern void wlc_lcnphy_set_tx_locc(struct brcms_phy *pi, u16 didq);
+extern void wlc_lcnphy_get_tx_iqcc(struct brcms_phy *pi, u16 *a, u16 *b);
+extern u16 wlc_lcnphy_get_tx_locc(struct brcms_phy *pi);
+extern void wlc_lcnphy_get_radio_loft(struct brcms_phy *pi, u8 *ei0,
 				      u8 *eq0, u8 *fi0, u8 *fq0);
-extern void wlc_lcnphy_calib_modes(phy_info_t *pi, uint mode);
-extern void wlc_lcnphy_deaf_mode(phy_info_t *pi, bool mode);
-extern bool wlc_phy_tpc_isenabled_lcnphy(phy_info_t *pi);
-extern void wlc_lcnphy_tx_pwr_update_npt(phy_info_t *pi);
+extern void wlc_lcnphy_calib_modes(struct brcms_phy *pi, uint mode);
+extern void wlc_lcnphy_deaf_mode(struct brcms_phy *pi, bool mode);
+extern bool wlc_phy_tpc_isenabled_lcnphy(struct brcms_phy *pi);
+extern void wlc_lcnphy_tx_pwr_update_npt(struct brcms_phy *pi);
 extern s32 wlc_lcnphy_tssi2dbm(s32 tssi, s32 a1, s32 b0, s32 b1);
-extern void wlc_lcnphy_get_tssi(phy_info_t *pi, s8 *ofdm_pwr,
+extern void wlc_lcnphy_get_tssi(struct brcms_phy *pi, s8 *ofdm_pwr,
 				s8 *cck_pwr);
 extern void wlc_lcnphy_tx_power_adjustment(wlc_phy_t *ppi);
 
-extern s32 wlc_lcnphy_rx_signal_power(phy_info_t *pi, s32 gain_index);
+extern s32 wlc_lcnphy_rx_signal_power(struct brcms_phy *pi, s32 gain_index);
 
 #define NPHY_MAX_HPVGA1_INDEX		10
 #define NPHY_DEF_HPVGA1_INDEXLIMIT	7
@@ -1135,8 +1138,9 @@ struct phy_iq_est {
 	u32 q_pwr;
 };
 
-extern void wlc_phy_stay_in_carriersearch_nphy(phy_info_t *pi, bool enable);
-extern void wlc_nphy_deaf_mode(phy_info_t *pi, bool mode);
+extern void wlc_phy_stay_in_carriersearch_nphy(struct brcms_phy *pi,
+					       bool enable);
+extern void wlc_nphy_deaf_mode(struct brcms_phy *pi, bool mode);
 
 #define wlc_phy_write_table_nphy(pi, pti)	wlc_phy_write_table(pi, pti, 0x72, \
 	0x74, 0x73)
@@ -1146,9 +1150,9 @@ extern void wlc_nphy_deaf_mode(phy_info_t *pi, bool mode);
 	0x72, 0x74, 0x73)
 #define wlc_nphy_table_data_write(pi, w, v)	wlc_phy_table_data_write((pi), (w), (v))
 
-extern void wlc_phy_table_read_nphy(phy_info_t *pi, u32, u32 l, u32 o,
+extern void wlc_phy_table_read_nphy(struct brcms_phy *pi, u32, u32 l, u32 o,
 				    u32 w, void *d);
-extern void wlc_phy_table_write_nphy(phy_info_t *pi, u32, u32, u32,
+extern void wlc_phy_table_write_nphy(struct brcms_phy *pi, u32, u32, u32,
 				     u32, const void *);
 
 #define	PHY_IPA(pi) \
@@ -1159,72 +1163,72 @@ extern void wlc_phy_table_write_nphy(phy_info_t *pi, u32, u32, u32,
 	if (((pi)->sh->bustype == PCI_BUS) && NREV_LT((pi)->pubpi.phy_rev, 3)) \
 		(void)R_REG(&(pi)->regs->maccontrol)
 
-extern void wlc_phy_cal_perical_nphy_run(phy_info_t *pi, u8 caltype);
-extern void wlc_phy_aci_reset_nphy(phy_info_t *pi);
-extern void wlc_phy_pa_override_nphy(phy_info_t *pi, bool en);
+extern void wlc_phy_cal_perical_nphy_run(struct brcms_phy *pi, u8 caltype);
+extern void wlc_phy_aci_reset_nphy(struct brcms_phy *pi);
+extern void wlc_phy_pa_override_nphy(struct brcms_phy *pi, bool en);
 
-extern u8 wlc_phy_get_chan_freq_range_nphy(phy_info_t *pi, uint chan);
-extern void wlc_phy_switch_radio_nphy(phy_info_t *pi, bool on);
+extern u8 wlc_phy_get_chan_freq_range_nphy(struct brcms_phy *pi, uint chan);
+extern void wlc_phy_switch_radio_nphy(struct brcms_phy *pi, bool on);
 
-extern void wlc_phy_stf_chain_upd_nphy(phy_info_t *pi);
+extern void wlc_phy_stf_chain_upd_nphy(struct brcms_phy *pi);
 
-extern void wlc_phy_force_rfseq_nphy(phy_info_t *pi, u8 cmd);
-extern s16 wlc_phy_tempsense_nphy(phy_info_t *pi);
+extern void wlc_phy_force_rfseq_nphy(struct brcms_phy *pi, u8 cmd);
+extern s16 wlc_phy_tempsense_nphy(struct brcms_phy *pi);
 
-extern u16 wlc_phy_classifier_nphy(phy_info_t *pi, u16 mask, u16 val);
+extern u16 wlc_phy_classifier_nphy(struct brcms_phy *pi, u16 mask, u16 val);
 
-extern void wlc_phy_rx_iq_est_nphy(phy_info_t *pi, struct phy_iq_est *est,
+extern void wlc_phy_rx_iq_est_nphy(struct brcms_phy *pi, struct phy_iq_est *est,
 				   u16 num_samps, u8 wait_time,
 				   u8 wait_for_crs);
 
-extern void wlc_phy_rx_iq_coeffs_nphy(phy_info_t *pi, u8 write,
+extern void wlc_phy_rx_iq_coeffs_nphy(struct brcms_phy *pi, u8 write,
 				      struct nphy_iq_comp *comp);
-extern void wlc_phy_aci_and_noise_reduction_nphy(phy_info_t *pi);
+extern void wlc_phy_aci_and_noise_reduction_nphy(struct brcms_phy *pi);
 
 extern void wlc_phy_rxcore_setstate_nphy(wlc_phy_t *pih, u8 rxcore_bitmask);
 extern u8 wlc_phy_rxcore_getstate_nphy(wlc_phy_t *pih);
 
-extern void wlc_phy_txpwrctrl_enable_nphy(phy_info_t *pi, u8 ctrl_type);
-extern void wlc_phy_txpwr_fixpower_nphy(phy_info_t *pi);
-extern void wlc_phy_txpwr_apply_nphy(phy_info_t *pi);
-extern void wlc_phy_txpwr_papd_cal_nphy(phy_info_t *pi);
-extern u16 wlc_phy_txpwr_idx_get_nphy(phy_info_t *pi);
+extern void wlc_phy_txpwrctrl_enable_nphy(struct brcms_phy *pi, u8 ctrl_type);
+extern void wlc_phy_txpwr_fixpower_nphy(struct brcms_phy *pi);
+extern void wlc_phy_txpwr_apply_nphy(struct brcms_phy *pi);
+extern void wlc_phy_txpwr_papd_cal_nphy(struct brcms_phy *pi);
+extern u16 wlc_phy_txpwr_idx_get_nphy(struct brcms_phy *pi);
 
-extern struct nphy_txgains wlc_phy_get_tx_gain_nphy(phy_info_t *pi);
-extern int wlc_phy_cal_txiqlo_nphy(phy_info_t *pi,
+extern struct nphy_txgains wlc_phy_get_tx_gain_nphy(struct brcms_phy *pi);
+extern int wlc_phy_cal_txiqlo_nphy(struct brcms_phy *pi,
 				   struct nphy_txgains target_gain,
 				   bool full, bool m);
-extern int wlc_phy_cal_rxiq_nphy(phy_info_t *pi,
+extern int wlc_phy_cal_rxiq_nphy(struct brcms_phy *pi,
 				 struct nphy_txgains target_gain,
 				 u8 type, bool d);
-extern void wlc_phy_txpwr_index_nphy(phy_info_t *pi, u8 core_mask,
+extern void wlc_phy_txpwr_index_nphy(struct brcms_phy *pi, u8 core_mask,
 				     s8 txpwrindex, bool res);
-extern void wlc_phy_rssisel_nphy(phy_info_t *pi, u8 core, u8 rssi_type);
-extern int wlc_phy_poll_rssi_nphy(phy_info_t *pi, u8 rssi_type,
+extern void wlc_phy_rssisel_nphy(struct brcms_phy *pi, u8 core, u8 rssi_type);
+extern int wlc_phy_poll_rssi_nphy(struct brcms_phy *pi, u8 rssi_type,
 				  s32 *rssi_buf, u8 nsamps);
-extern void wlc_phy_rssi_cal_nphy(phy_info_t *pi);
-extern int wlc_phy_aci_scan_nphy(phy_info_t *pi);
-extern void wlc_phy_cal_txgainctrl_nphy(phy_info_t *pi, s32 dBm_targetpower,
-					bool debug);
-extern int wlc_phy_tx_tone_nphy(phy_info_t *pi, u32 f_kHz, u16 max_val,
+extern void wlc_phy_rssi_cal_nphy(struct brcms_phy *pi);
+extern int wlc_phy_aci_scan_nphy(struct brcms_phy *pi);
+extern void wlc_phy_cal_txgainctrl_nphy(struct brcms_phy *pi,
+					s32 dBm_targetpower, bool debug);
+extern int wlc_phy_tx_tone_nphy(struct brcms_phy *pi, u32 f_kHz, u16 max_val,
 				u8 mode, u8, bool);
-extern void wlc_phy_stopplayback_nphy(phy_info_t *pi);
-extern void wlc_phy_est_tonepwr_nphy(phy_info_t *pi, s32 *qdBm_pwrbuf,
+extern void wlc_phy_stopplayback_nphy(struct brcms_phy *pi);
+extern void wlc_phy_est_tonepwr_nphy(struct brcms_phy *pi, s32 *qdBm_pwrbuf,
 				     u8 num_samps);
-extern void wlc_phy_radio205x_vcocal_nphy(phy_info_t *pi);
+extern void wlc_phy_radio205x_vcocal_nphy(struct brcms_phy *pi);
 
-extern int wlc_phy_rssi_compute_nphy(phy_info_t *pi,
+extern int wlc_phy_rssi_compute_nphy(struct brcms_phy *pi,
 				     struct brcms_d11rxhdr *wlc_rxh);
 
 #define NPHY_TESTPATTERN_BPHY_EVM   0
 #define NPHY_TESTPATTERN_BPHY_RFCS  1
 
-extern void wlc_phy_nphy_tkip_rifs_war(phy_info_t *pi, u8 rifs);
+extern void wlc_phy_nphy_tkip_rifs_war(struct brcms_phy *pi, u8 rifs);
 
-void wlc_phy_get_pwrdet_offsets(phy_info_t *pi, s8 *cckoffset,
+void wlc_phy_get_pwrdet_offsets(struct brcms_phy *pi, s8 *cckoffset,
 				s8 *ofdmoffset);
-extern s8 wlc_phy_upd_rssi_offset(phy_info_t *pi, s8 rssi,
+extern s8 wlc_phy_upd_rssi_offset(struct brcms_phy *pi, s8 rssi,
 				    chanspec_t chanspec);
 
-extern bool wlc_phy_n_txpower_ipa_ison(phy_info_t *pih);
+extern bool wlc_phy_n_txpower_ipa_ison(struct brcms_phy *pih);
 #endif				/* _BRCM_PHY_INT_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
index 47a0a1a..0c9ceb7 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -967,76 +967,79 @@ u16 LCNPHY_txdigfiltcoeffs_ofdm[LCNPHY_NUM_TX_DIG_FILTERS_OFDM]
 
 static u32 wlc_lcnphy_qdiv_roundup(u32 divident, u32 divisor,
 				      u8 precision);
-static void wlc_lcnphy_set_rx_gain_by_distribution(phy_info_t *pi,
+static void wlc_lcnphy_set_rx_gain_by_distribution(struct brcms_phy *pi,
 						   u16 ext_lna, u16 trsw,
 						   u16 biq2, u16 biq1,
 						   u16 tia, u16 lna2,
 						   u16 lna1);
-static void wlc_lcnphy_clear_tx_power_offsets(phy_info_t *pi);
-static void wlc_lcnphy_set_pa_gain(phy_info_t *pi, u16 gain);
-static void wlc_lcnphy_set_trsw_override(phy_info_t *pi, bool tx, bool rx);
-static void wlc_lcnphy_set_bbmult(phy_info_t *pi, u8 m0);
-static u8 wlc_lcnphy_get_bbmult(phy_info_t *pi);
-static void wlc_lcnphy_get_tx_gain(phy_info_t *pi,
+static void wlc_lcnphy_clear_tx_power_offsets(struct brcms_phy *pi);
+static void wlc_lcnphy_set_pa_gain(struct brcms_phy *pi, u16 gain);
+static void wlc_lcnphy_set_trsw_override(struct brcms_phy *pi, bool tx,
+					 bool rx);
+static void wlc_lcnphy_set_bbmult(struct brcms_phy *pi, u8 m0);
+static u8 wlc_lcnphy_get_bbmult(struct brcms_phy *pi);
+static void wlc_lcnphy_get_tx_gain(struct brcms_phy *pi,
 				   struct lcnphy_txgains *gains);
-static void wlc_lcnphy_set_tx_gain_override(phy_info_t *pi, bool bEnable);
-static void wlc_lcnphy_toggle_afe_pwdn(phy_info_t *pi);
-static void wlc_lcnphy_rx_gain_override_enable(phy_info_t *pi, bool enable);
-static void wlc_lcnphy_set_tx_gain(phy_info_t *pi,
+static void wlc_lcnphy_set_tx_gain_override(struct brcms_phy *pi, bool bEnable);
+static void wlc_lcnphy_toggle_afe_pwdn(struct brcms_phy *pi);
+static void wlc_lcnphy_rx_gain_override_enable(struct brcms_phy *pi,
+					       bool enable);
+static void wlc_lcnphy_set_tx_gain(struct brcms_phy *pi,
 				   struct lcnphy_txgains *target_gains);
-static bool wlc_lcnphy_rx_iq_est(phy_info_t *pi, u16 num_samps,
+static bool wlc_lcnphy_rx_iq_est(struct brcms_phy *pi, u16 num_samps,
 				 u8 wait_time, struct lcnphy_iq_est *iq_est);
-static bool wlc_lcnphy_calc_rx_iq_comp(phy_info_t *pi, u16 num_samps);
-static u16 wlc_lcnphy_get_pa_gain(phy_info_t *pi);
-static void wlc_lcnphy_afe_clk_init(phy_info_t *pi, u8 mode);
+static bool wlc_lcnphy_calc_rx_iq_comp(struct brcms_phy *pi, u16 num_samps);
+static u16 wlc_lcnphy_get_pa_gain(struct brcms_phy *pi);
+static void wlc_lcnphy_afe_clk_init(struct brcms_phy *pi, u8 mode);
 extern void wlc_lcnphy_tx_pwr_ctrl_init(wlc_phy_t *ppi);
-static void wlc_lcnphy_radio_2064_channel_tune_4313(phy_info_t *pi,
+static void wlc_lcnphy_radio_2064_channel_tune_4313(struct brcms_phy *pi,
 						    u8 channel);
 
-static void wlc_lcnphy_load_tx_gain_table(phy_info_t *pi,
+static void wlc_lcnphy_load_tx_gain_table(struct brcms_phy *pi,
 				  const struct lcnphy_tx_gain_tbl_entry *g);
 
-static void wlc_lcnphy_samp_cap(phy_info_t *pi, int clip_detect_algo,
+static void wlc_lcnphy_samp_cap(struct brcms_phy *pi, int clip_detect_algo,
 				u16 thresh, s16 *ptr, int mode);
 static int wlc_lcnphy_calc_floor(s16 coeff, int type);
-static void wlc_lcnphy_tx_iqlo_loopback(phy_info_t *pi,
+static void wlc_lcnphy_tx_iqlo_loopback(struct brcms_phy *pi,
 					u16 *values_to_save);
-static void wlc_lcnphy_tx_iqlo_loopback_cleanup(phy_info_t *pi,
+static void wlc_lcnphy_tx_iqlo_loopback_cleanup(struct brcms_phy *pi,
 						u16 *values_to_save);
-static void wlc_lcnphy_set_cc(phy_info_t *pi, int cal_type, s16 coeff_x,
+static void wlc_lcnphy_set_cc(struct brcms_phy *pi, int cal_type, s16 coeff_x,
 			      s16 coeff_y);
-static struct lcnphy_unsign16_struct wlc_lcnphy_get_cc(phy_info_t *pi,
+static struct lcnphy_unsign16_struct wlc_lcnphy_get_cc(struct brcms_phy *pi,
 						       int cal_type);
-static void wlc_lcnphy_a1(phy_info_t *pi, int cal_type,
+static void wlc_lcnphy_a1(struct brcms_phy *pi, int cal_type,
 			  int num_levels, int step_size_lg2);
-static void wlc_lcnphy_tx_iqlo_soft_cal_full(phy_info_t *pi);
+static void wlc_lcnphy_tx_iqlo_soft_cal_full(struct brcms_phy *pi);
 
-static void wlc_lcnphy_set_chanspec_tweaks(phy_info_t *pi,
+static void wlc_lcnphy_set_chanspec_tweaks(struct brcms_phy *pi,
 					   chanspec_t chanspec);
-static void wlc_lcnphy_agc_temp_init(phy_info_t *pi);
-static void wlc_lcnphy_temp_adj(phy_info_t *pi);
-static void wlc_lcnphy_clear_papd_comptable(phy_info_t *pi);
-static void wlc_lcnphy_baseband_init(phy_info_t *pi);
-static void wlc_lcnphy_radio_init(phy_info_t *pi);
-static void wlc_lcnphy_rc_cal(phy_info_t *pi);
-static void wlc_lcnphy_rcal(phy_info_t *pi);
-static void wlc_lcnphy_txrx_spur_avoidance_mode(phy_info_t *pi, bool enable);
-static int wlc_lcnphy_load_tx_iir_filter(phy_info_t *pi, bool is_ofdm,
+static void wlc_lcnphy_agc_temp_init(struct brcms_phy *pi);
+static void wlc_lcnphy_temp_adj(struct brcms_phy *pi);
+static void wlc_lcnphy_clear_papd_comptable(struct brcms_phy *pi);
+static void wlc_lcnphy_baseband_init(struct brcms_phy *pi);
+static void wlc_lcnphy_radio_init(struct brcms_phy *pi);
+static void wlc_lcnphy_rc_cal(struct brcms_phy *pi);
+static void wlc_lcnphy_rcal(struct brcms_phy *pi);
+static void wlc_lcnphy_txrx_spur_avoidance_mode(struct brcms_phy *pi,
+						bool enable);
+static int wlc_lcnphy_load_tx_iir_filter(struct brcms_phy *pi, bool is_ofdm,
 					 s16 filt_type);
-static void wlc_lcnphy_set_rx_iq_comp(phy_info_t *pi, u16 a, u16 b);
+static void wlc_lcnphy_set_rx_iq_comp(struct brcms_phy *pi, u16 a, u16 b);
 
-void wlc_lcnphy_write_table(phy_info_t *pi, const struct phytbl_info *pti)
+void wlc_lcnphy_write_table(struct brcms_phy *pi, const struct phytbl_info *pti)
 {
 	wlc_phy_write_table(pi, pti, 0x455, 0x457, 0x456);
 }
 
-void wlc_lcnphy_read_table(phy_info_t *pi, struct phytbl_info *pti)
+void wlc_lcnphy_read_table(struct brcms_phy *pi, struct phytbl_info *pti)
 {
 	wlc_phy_read_table(pi, pti, 0x455, 0x457, 0x456);
 }
 
 static void
-wlc_lcnphy_common_read_table(phy_info_t *pi, u32 tbl_id,
+wlc_lcnphy_common_read_table(struct brcms_phy *pi, u32 tbl_id,
 			     const void *tbl_ptr, u32 tbl_len,
 			     u32 tbl_width, u32 tbl_offset)
 {
@@ -1050,7 +1053,7 @@ wlc_lcnphy_common_read_table(phy_info_t *pi, u32 tbl_id,
 }
 
 static void
-wlc_lcnphy_common_write_table(phy_info_t *pi, u32 tbl_id,
+wlc_lcnphy_common_write_table(struct brcms_phy *pi, u32 tbl_id,
 			      const void *tbl_ptr, u32 tbl_len,
 			      u32 tbl_width, u32 tbl_offset)
 {
@@ -1110,10 +1113,10 @@ static int wlc_lcnphy_calc_floor(s16 coeff_x, int type)
 	return k;
 }
 
-s8 wlc_lcnphy_get_current_tx_pwr_idx(phy_info_t *pi)
+s8 wlc_lcnphy_get_current_tx_pwr_idx(struct brcms_phy *pi)
 {
 	s8 index;
-	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	if (txpwrctrl_off(pi))
 		index = pi_lcn->lcnphy_current_index;
@@ -1126,7 +1129,7 @@ s8 wlc_lcnphy_get_current_tx_pwr_idx(phy_info_t *pi)
 	return index;
 }
 
-static u32 wlc_lcnphy_measure_digital_power(phy_info_t *pi, u16 nsamples)
+static u32 wlc_lcnphy_measure_digital_power(struct brcms_phy *pi, u16 nsamples)
 {
 	struct lcnphy_iq_est iq_est = { 0, 0, 0 };
 
@@ -1135,7 +1138,7 @@ static u32 wlc_lcnphy_measure_digital_power(phy_info_t *pi, u16 nsamples)
 	return (iq_est.i_pwr + iq_est.q_pwr) / nsamples;
 }
 
-void wlc_lcnphy_crsuprs(phy_info_t *pi, int channel)
+void wlc_lcnphy_crsuprs(struct brcms_phy *pi, int channel)
 {
 	u16 afectrlovr, afectrlovrval;
 	afectrlovr = read_phy_reg(pi, 0x43b);
@@ -1166,7 +1169,7 @@ void wlc_lcnphy_crsuprs(phy_info_t *pi, int channel)
 	}
 }
 
-static void wlc_lcnphy_toggle_afe_pwdn(phy_info_t *pi)
+static void wlc_lcnphy_toggle_afe_pwdn(struct brcms_phy *pi)
 {
 	u16 save_AfeCtrlOvrVal, save_AfeCtrlOvr;
 
@@ -1183,7 +1186,8 @@ static void wlc_lcnphy_toggle_afe_pwdn(phy_info_t *pi)
 	write_phy_reg(pi, 0x43b, save_AfeCtrlOvr);
 }
 
-static void wlc_lcnphy_txrx_spur_avoidance_mode(phy_info_t *pi, bool enable)
+static void
+wlc_lcnphy_txrx_spur_avoidance_mode(struct brcms_phy *pi, bool enable)
 {
 	if (enable) {
 		write_phy_reg(pi, 0x942, 0x7);
@@ -1202,7 +1206,7 @@ static void wlc_lcnphy_txrx_spur_avoidance_mode(phy_info_t *pi, bool enable)
 	wlapi_switch_macfreq(pi->sh->physhim, enable);
 }
 
-void wlc_phy_chanspec_set_lcnphy(phy_info_t *pi, chanspec_t chanspec)
+void wlc_phy_chanspec_set_lcnphy(struct brcms_phy *pi, chanspec_t chanspec)
 {
 	u8 channel = CHSPEC_CHANNEL(chanspec);
 
@@ -1239,7 +1243,7 @@ void wlc_phy_chanspec_set_lcnphy(phy_info_t *pi, chanspec_t chanspec)
 
 }
 
-static void wlc_lcnphy_set_dac_gain(phy_info_t *pi, u16 dac_gain)
+static void wlc_lcnphy_set_dac_gain(struct brcms_phy *pi, u16 dac_gain)
 {
 	u16 dac_ctrl;
 
@@ -1250,7 +1254,7 @@ static void wlc_lcnphy_set_dac_gain(phy_info_t *pi, u16 dac_gain)
 
 }
 
-static void wlc_lcnphy_set_tx_gain_override(phy_info_t *pi, bool bEnable)
+static void wlc_lcnphy_set_tx_gain_override(struct brcms_phy *pi, bool bEnable)
 {
 	u16 bit = bEnable ? 1 : 0;
 
@@ -1261,7 +1265,7 @@ static void wlc_lcnphy_set_tx_gain_override(phy_info_t *pi, bool bEnable)
 	mod_phy_reg(pi, 0x43b, (0x1 << 6), bit << 6);
 }
 
-static u16 wlc_lcnphy_get_pa_gain(phy_info_t *pi)
+static u16 wlc_lcnphy_get_pa_gain(struct brcms_phy *pi)
 {
 	u16 pa_gain;
 
@@ -1272,8 +1276,8 @@ static u16 wlc_lcnphy_get_pa_gain(phy_info_t *pi)
 	return pa_gain;
 }
 
-static void
-wlc_lcnphy_set_tx_gain(phy_info_t *pi, struct lcnphy_txgains *target_gains)
+static void wlc_lcnphy_set_tx_gain(struct brcms_phy *pi,
+				   struct lcnphy_txgains *target_gains)
 {
 	u16 pa_gain = wlc_lcnphy_get_pa_gain(pi);
 
@@ -1298,7 +1302,7 @@ wlc_lcnphy_set_tx_gain(phy_info_t *pi, struct lcnphy_txgains *target_gains)
 	wlc_lcnphy_enable_tx_gain_override(pi);
 }
 
-static void wlc_lcnphy_set_bbmult(phy_info_t *pi, u8 m0)
+static void wlc_lcnphy_set_bbmult(struct brcms_phy *pi, u8 m0)
 {
 	u16 m0m1 = (u16) m0 << 8;
 	struct phytbl_info tab;
@@ -1311,7 +1315,7 @@ static void wlc_lcnphy_set_bbmult(phy_info_t *pi, u8 m0)
 	wlc_lcnphy_write_table(pi, &tab);
 }
 
-static void wlc_lcnphy_clear_tx_power_offsets(phy_info_t *pi)
+static void wlc_lcnphy_clear_tx_power_offsets(struct brcms_phy *pi)
 {
 	u32 data_buf[64];
 	struct phytbl_info tab;
@@ -1340,7 +1344,8 @@ enum lcnphy_tssi_mode {
 	LCNPHY_TSSI_EXT
 };
 
-static void wlc_lcnphy_set_tssi_mux(phy_info_t *pi, enum lcnphy_tssi_mode pos)
+static void
+wlc_lcnphy_set_tssi_mux(struct brcms_phy *pi, enum lcnphy_tssi_mode pos)
 {
 	mod_phy_reg(pi, 0x4d7, (0x1 << 0), (0x1) << 0);
 
@@ -1379,7 +1384,7 @@ static void wlc_lcnphy_set_tssi_mux(phy_info_t *pi, enum lcnphy_tssi_mode pos)
 	}
 }
 
-static u16 wlc_lcnphy_rfseq_tbl_adc_pwrup(phy_info_t *pi)
+static u16 wlc_lcnphy_rfseq_tbl_adc_pwrup(struct brcms_phy *pi)
 {
 	u16 N1, N2, N3, N4, N5, N6, N;
 	N1 = ((read_phy_reg(pi, 0x4a5) & (0xff << 0))
@@ -1400,10 +1405,10 @@ static u16 wlc_lcnphy_rfseq_tbl_adc_pwrup(phy_info_t *pi)
 	return N;
 }
 
-static void wlc_lcnphy_pwrctrl_rssiparams(phy_info_t *pi)
+static void wlc_lcnphy_pwrctrl_rssiparams(struct brcms_phy *pi)
 {
 	u16 auxpga_vmid, auxpga_vmid_temp, auxpga_gain_temp;
-	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	auxpga_vmid =
 	    (2 << 8) | (pi_lcn->lcnphy_rssi_vc << 4) | pi_lcn->lcnphy_rssi_vf;
@@ -1444,7 +1449,7 @@ static void wlc_lcnphy_pwrctrl_rssiparams(phy_info_t *pi)
 	mod_radio_reg(pi, RADIO_2064_REG082, (1 << 5), (1 << 5));
 }
 
-static void wlc_lcnphy_tssi_setup(phy_info_t *pi)
+static void wlc_lcnphy_tssi_setup(struct brcms_phy *pi)
 {
 	struct phytbl_info tab;
 	u32 rfseq, ind;
@@ -1558,10 +1563,10 @@ static void wlc_lcnphy_tssi_setup(phy_info_t *pi)
 	wlc_lcnphy_pwrctrl_rssiparams(pi);
 }
 
-void wlc_lcnphy_tx_pwr_update_npt(phy_info_t *pi)
+void wlc_lcnphy_tx_pwr_update_npt(struct brcms_phy *pi)
 {
 	u16 tx_cnt, tx_total, npt;
-	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	tx_total = wlc_lcnphy_total_tx_frames(pi);
 	tx_cnt = tx_total - pi_lcn->lcnphy_tssi_tx_cnt;
@@ -1588,9 +1593,9 @@ s32 wlc_lcnphy_tssi2dbm(s32 tssi, s32 a1, s32 b0, s32 b1)
 	return p;
 }
 
-static void wlc_lcnphy_txpower_reset_npt(phy_info_t *pi)
+static void wlc_lcnphy_txpower_reset_npt(struct brcms_phy *pi)
 {
-	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 	if (wlc_lcnphy_tempsense_based_pwr_ctrl_enabled(pi))
 		return;
 
@@ -1598,7 +1603,7 @@ static void wlc_lcnphy_txpower_reset_npt(phy_info_t *pi)
 	pi_lcn->lcnphy_tssi_npt = LCNPHY_TX_PWR_CTRL_START_NPT;
 }
 
-void wlc_lcnphy_txpower_recalc_target(phy_info_t *pi)
+void wlc_lcnphy_txpower_recalc_target(struct brcms_phy *pi)
 {
 	struct phytbl_info tab;
 	u32 rate_table[WLC_NUM_RATES_CCK + WLC_NUM_RATES_OFDM +
@@ -1629,7 +1634,7 @@ void wlc_lcnphy_txpower_recalc_target(phy_info_t *pi)
 	}
 }
 
-static void wlc_lcnphy_set_tx_pwr_soft_ctrl(phy_info_t *pi, s8 index)
+static void wlc_lcnphy_set_tx_pwr_soft_ctrl(struct brcms_phy *pi, s8 index)
 {
 	u32 cck_offset[4] = { 22, 22, 22, 22 };
 	u32 ofdm_offset, reg_offset_cck;
@@ -1682,13 +1687,13 @@ static void wlc_lcnphy_set_tx_pwr_soft_ctrl(phy_info_t *pi, s8 index)
 
 }
 
-static s8 wlc_lcnphy_tempcompensated_txpwrctrl(phy_info_t *pi)
+static s8 wlc_lcnphy_tempcompensated_txpwrctrl(struct brcms_phy *pi)
 {
 	s8 index, delta_brd, delta_temp, new_index, tempcorrx;
 	s16 manp, meas_temp, temp_diff;
 	bool neg = 0;
 	u16 temp;
-	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	if (wlc_lcnphy_tssi_based_pwr_ctrl_enabled(pi))
 		return pi_lcn->lcnphy_current_index;
@@ -1747,7 +1752,7 @@ static s8 wlc_lcnphy_tempcompensated_txpwrctrl(phy_info_t *pi)
 	return new_index;
 }
 
-static u16 wlc_lcnphy_set_tx_pwr_ctrl_mode(phy_info_t *pi, u16 mode)
+static u16 wlc_lcnphy_set_tx_pwr_ctrl_mode(struct brcms_phy *pi, u16 mode)
 {
 
 	u16 current_mode = mode;
@@ -1760,11 +1765,11 @@ static u16 wlc_lcnphy_set_tx_pwr_ctrl_mode(phy_info_t *pi, u16 mode)
 	return current_mode;
 }
 
-void wlc_lcnphy_set_tx_pwr_ctrl(phy_info_t *pi, u16 mode)
+void wlc_lcnphy_set_tx_pwr_ctrl(struct brcms_phy *pi, u16 mode)
 {
 	u16 old_mode = wlc_lcnphy_get_tx_pwr_ctrl(pi);
 	s8 index;
-	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	mode = wlc_lcnphy_set_tx_pwr_ctrl_mode(pi, mode);
 	old_mode = wlc_lcnphy_set_tx_pwr_ctrl_mode(pi, old_mode);
@@ -1811,7 +1816,7 @@ void wlc_lcnphy_set_tx_pwr_ctrl(phy_info_t *pi, u16 mode)
 	}
 }
 
-static bool wlc_lcnphy_iqcal_wait(phy_info_t *pi)
+static bool wlc_lcnphy_iqcal_wait(struct brcms_phy *pi)
 {
 	uint delay_count = 0;
 
@@ -1827,7 +1832,7 @@ static bool wlc_lcnphy_iqcal_wait(phy_info_t *pi)
 }
 
 static void
-wlc_lcnphy_tx_iqlo_cal(phy_info_t *pi,
+wlc_lcnphy_tx_iqlo_cal(struct brcms_phy *pi,
 		       struct lcnphy_txgains *target_gains,
 		       enum lcnphy_cal_mode cal_mode, bool keep_tone)
 {
@@ -1861,7 +1866,7 @@ wlc_lcnphy_tx_iqlo_cal(phy_info_t *pi,
 	struct lcnphy_txgains old_gains;
 	uint i, n_cal_cmds = 0, n_cal_start = 0;
 	u16 *values_to_save;
-	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	if (NORADIO_ENAB(pi->pubpi))
 		return;
@@ -2066,7 +2071,7 @@ static void wlc_lcnphy_idle_tssi_est(wlc_phy_t *ppi)
 {
 	bool suspend, tx_gain_override_old;
 	struct lcnphy_txgains old_gains;
-	phy_info_t *pi = (phy_info_t *) ppi;
+	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 	u16 idleTssi, idleTssi0_2C, idleTssi0_OB, idleTssi0_regvalue_OB,
 	    idleTssi0_regvalue_2C;
 	u16 SAVE_txpwrctrl = wlc_lcnphy_get_tx_pwr_ctrl(pi);
@@ -2078,7 +2083,7 @@ static void wlc_lcnphy_idle_tssi_est(wlc_phy_t *ppi)
 	idleTssi = read_phy_reg(pi, 0x4ab);
 	suspend =
 	    (0 ==
-	     (R_REG(&((phy_info_t *) pi)->regs->maccontrol) &
+	     (R_REG(&((struct brcms_phy *) pi)->regs->maccontrol) &
 	      MCTL_EN_MAC));
 	if (!suspend)
 		wlapi_suspend_mac_and_wait(pi->sh->physhim);
@@ -2128,7 +2133,7 @@ static void wlc_lcnphy_idle_tssi_est(wlc_phy_t *ppi)
 		wlapi_enable_mac(pi->sh->physhim);
 }
 
-static void wlc_lcnphy_vbat_temp_sense_setup(phy_info_t *pi, u8 mode)
+static void wlc_lcnphy_vbat_temp_sense_setup(struct brcms_phy *pi, u8 mode)
 {
 	bool suspend;
 	u16 save_txpwrCtrlEn;
@@ -2141,7 +2146,7 @@ static void wlc_lcnphy_vbat_temp_sense_setup(phy_info_t *pi, u8 mode)
 	u16 values_to_save[14];
 	s8 index;
 	int i;
-	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 	udelay(999);
 
 	save_reg007 = (u8) read_radio_reg(pi, RADIO_2064_REG007);
@@ -2278,7 +2283,7 @@ void WLBANDINITFN(wlc_lcnphy_tx_pwr_ctrl_init) (wlc_phy_t *ppi)
 	s32 a1, b0, b1;
 	s32 tssi, pwr, maxtargetpwr, mintargetpwr;
 	bool suspend;
-	phy_info_t *pi = (phy_info_t *) ppi;
+	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
 	suspend =
 	    (0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
@@ -2348,7 +2353,7 @@ void WLBANDINITFN(wlc_lcnphy_tx_pwr_ctrl_init) (wlc_phy_t *ppi)
 		wlapi_enable_mac(pi->sh->physhim);
 }
 
-static u8 wlc_lcnphy_get_bbmult(phy_info_t *pi)
+static u8 wlc_lcnphy_get_bbmult(struct brcms_phy *pi)
 {
 	u16 m0m1;
 	struct phytbl_info tab;
@@ -2363,7 +2368,7 @@ static u8 wlc_lcnphy_get_bbmult(phy_info_t *pi)
 	return (u8) ((m0m1 & 0xff00) >> 8);
 }
 
-static void wlc_lcnphy_set_pa_gain(phy_info_t *pi, u16 gain)
+static void wlc_lcnphy_set_pa_gain(struct brcms_phy *pi, u16 gain)
 {
 	mod_phy_reg(pi, 0x4fb,
 		    LCNPHY_txgainctrlovrval1_pagain_ovr_val1_MASK,
@@ -2374,7 +2379,7 @@ static void wlc_lcnphy_set_pa_gain(phy_info_t *pi, u16 gain)
 }
 
 void
-wlc_lcnphy_get_radio_loft(phy_info_t *pi,
+wlc_lcnphy_get_radio_loft(struct brcms_phy *pi,
 			  u8 *ei0, u8 *eq0, u8 *fi0, u8 *fq0)
 {
 	*ei0 = LCNPHY_IQLOCC_READ(read_radio_reg(pi, RADIO_2064_REG089));
@@ -2383,7 +2388,8 @@ wlc_lcnphy_get_radio_loft(phy_info_t *pi,
 	*fq0 = LCNPHY_IQLOCC_READ(read_radio_reg(pi, RADIO_2064_REG08C));
 }
 
-static void wlc_lcnphy_get_tx_gain(phy_info_t *pi, struct lcnphy_txgains *gains)
+static void
+wlc_lcnphy_get_tx_gain(struct brcms_phy *pi, struct lcnphy_txgains *gains)
 {
 	u16 dac_gain;
 
@@ -2402,7 +2408,7 @@ static void wlc_lcnphy_get_tx_gain(phy_info_t *pi, struct lcnphy_txgains *gains)
 	}
 }
 
-void wlc_lcnphy_set_tx_iqcc(phy_info_t *pi, u16 a, u16 b)
+void wlc_lcnphy_set_tx_iqcc(struct brcms_phy *pi, u16 a, u16 b)
 {
 	struct phytbl_info tab;
 	u16 iqcc[2];
@@ -2418,7 +2424,7 @@ void wlc_lcnphy_set_tx_iqcc(phy_info_t *pi, u16 a, u16 b)
 	wlc_lcnphy_write_table(pi, &tab);
 }
 
-void wlc_lcnphy_set_tx_locc(phy_info_t *pi, u16 didq)
+void wlc_lcnphy_set_tx_locc(struct brcms_phy *pi, u16 didq)
 {
 	struct phytbl_info tab;
 
@@ -2430,14 +2436,14 @@ void wlc_lcnphy_set_tx_locc(phy_info_t *pi, u16 didq)
 	wlc_lcnphy_write_table(pi, &tab);
 }
 
-void wlc_lcnphy_set_tx_pwr_by_index(phy_info_t *pi, int index)
+void wlc_lcnphy_set_tx_pwr_by_index(struct brcms_phy *pi, int index)
 {
 	struct phytbl_info tab;
 	u16 a, b;
 	u8 bb_mult;
 	u32 bbmultiqcomp, txgain, locoeffs, rfpower;
 	struct lcnphy_txgains gains;
-	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	pi_lcn->lcnphy_tx_power_idx_override = (s8) index;
 	pi_lcn->lcnphy_current_index = (u8) index;
@@ -2489,7 +2495,7 @@ void wlc_lcnphy_set_tx_pwr_by_index(phy_info_t *pi, int index)
 	}
 }
 
-static void wlc_lcnphy_set_trsw_override(phy_info_t *pi, bool tx, bool rx)
+static void wlc_lcnphy_set_trsw_override(struct brcms_phy *pi, bool tx, bool rx)
 {
 
 	mod_phy_reg(pi, 0x44d,
@@ -2499,7 +2505,7 @@ static void wlc_lcnphy_set_trsw_override(phy_info_t *pi, bool tx, bool rx)
 	or_phy_reg(pi, 0x44c, (0x1 << 1) | (0x1 << 0));
 }
 
-static void wlc_lcnphy_clear_papd_comptable(phy_info_t *pi)
+static void wlc_lcnphy_clear_papd_comptable(struct brcms_phy *pi)
 {
 	u32 j;
 	struct phytbl_info tab;
@@ -2519,7 +2525,7 @@ static void wlc_lcnphy_clear_papd_comptable(phy_info_t *pi)
 }
 
 static void
-wlc_lcnphy_set_rx_gain_by_distribution(phy_info_t *pi,
+wlc_lcnphy_set_rx_gain_by_distribution(struct brcms_phy *pi,
 				       u16 trsw,
 				       u16 ext_lna,
 				       u16 biq2,
@@ -2553,7 +2559,8 @@ wlc_lcnphy_set_rx_gain_by_distribution(phy_info_t *pi,
 
 }
 
-static void wlc_lcnphy_rx_gain_override_enable(phy_info_t *pi, bool enable)
+static void
+wlc_lcnphy_rx_gain_override_enable(struct brcms_phy *pi, bool enable)
 {
 	u16 ebit = enable ? 1 : 0;
 
@@ -2578,7 +2585,7 @@ static void wlc_lcnphy_rx_gain_override_enable(phy_info_t *pi, bool enable)
 	}
 }
 
-void wlc_lcnphy_tx_pu(phy_info_t *pi, bool bEnable)
+void wlc_lcnphy_tx_pu(struct brcms_phy *pi, bool bEnable)
 {
 	if (!bEnable) {
 
@@ -2656,7 +2663,7 @@ void wlc_lcnphy_tx_pu(phy_info_t *pi, bool bEnable)
 }
 
 static void
-wlc_lcnphy_run_samples(phy_info_t *pi,
+wlc_lcnphy_run_samples(struct brcms_phy *pi,
 		       u16 num_samps,
 		       u16 num_loops, u16 wait, bool iqcalmode)
 {
@@ -2682,7 +2689,7 @@ wlc_lcnphy_run_samples(phy_info_t *pi,
 	or_radio_reg(pi, RADIO_2064_REG112, 0x6);
 }
 
-void wlc_lcnphy_deaf_mode(phy_info_t *pi, bool mode)
+void wlc_lcnphy_deaf_mode(struct brcms_phy *pi, bool mode)
 {
 
 	u8 phybw40;
@@ -2707,7 +2714,7 @@ void wlc_lcnphy_deaf_mode(phy_info_t *pi, bool mode)
 }
 
 void
-wlc_lcnphy_start_tx_tone(phy_info_t *pi, s32 f_kHz, u16 max_val,
+wlc_lcnphy_start_tx_tone(struct brcms_phy *pi, s32 f_kHz, u16 max_val,
 			 bool iqcalmode)
 {
 	u8 phy_bw;
@@ -2718,7 +2725,7 @@ wlc_lcnphy_start_tx_tone(phy_info_t *pi, s32 f_kHz, u16 max_val,
 	u32 data_buf[64];
 	u16 i_samp, q_samp;
 	struct phytbl_info tab;
-	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	pi->phy_tx_tone_freq = f_kHz;
 
@@ -2770,10 +2777,10 @@ wlc_lcnphy_start_tx_tone(phy_info_t *pi, s32 f_kHz, u16 max_val,
 	wlc_lcnphy_run_samples(pi, num_samps, 0xffff, 0, iqcalmode);
 }
 
-void wlc_lcnphy_stop_tx_tone(phy_info_t *pi)
+void wlc_lcnphy_stop_tx_tone(struct brcms_phy *pi)
 {
 	s16 playback_status;
-	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	pi->phy_tx_tone_freq = 0;
 	if (pi_lcn->lcnphy_spurmod) {
@@ -2801,13 +2808,13 @@ void wlc_lcnphy_stop_tx_tone(phy_info_t *pi)
 	wlc_lcnphy_deaf_mode(pi, false);
 }
 
-static void wlc_lcnphy_clear_trsw_override(phy_info_t *pi)
+static void wlc_lcnphy_clear_trsw_override(struct brcms_phy *pi)
 {
 
 	and_phy_reg(pi, 0x44c, (u16) ~((0x1 << 1) | (0x1 << 0)));
 }
 
-void wlc_lcnphy_get_tx_iqcc(phy_info_t *pi, u16 *a, u16 *b)
+void wlc_lcnphy_get_tx_iqcc(struct brcms_phy *pi, u16 *a, u16 *b)
 {
 	u16 iqcc[2];
 	struct phytbl_info tab;
@@ -2823,7 +2830,7 @@ void wlc_lcnphy_get_tx_iqcc(phy_info_t *pi, u16 *a, u16 *b)
 	*b = iqcc[1];
 }
 
-u16 wlc_lcnphy_get_tx_locc(phy_info_t *pi)
+u16 wlc_lcnphy_get_tx_locc(struct brcms_phy *pi)
 {
 	struct phytbl_info tab;
 	u16 didq;
@@ -2838,7 +2845,7 @@ u16 wlc_lcnphy_get_tx_locc(phy_info_t *pi)
 	return didq;
 }
 
-static void wlc_lcnphy_txpwrtbl_iqlo_cal(phy_info_t *pi)
+static void wlc_lcnphy_txpwrtbl_iqlo_cal(struct brcms_phy *pi)
 {
 
 	struct lcnphy_txgains target_gains, old_gains;
@@ -2849,7 +2856,7 @@ static void wlc_lcnphy_txpwrtbl_iqlo_cal(phy_info_t *pi)
 	u16 SAVE_txpwrctrl = wlc_lcnphy_get_tx_pwr_ctrl(pi);
 	struct phytbl_info tab;
 	u8 ei0, eq0, fi0, fq0;
-	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	wlc_lcnphy_get_tx_gain(pi, &old_gains);
 	save_pa_gain = wlc_lcnphy_get_pa_gain(pi);
@@ -2952,7 +2959,7 @@ static void wlc_lcnphy_txpwrtbl_iqlo_cal(phy_info_t *pi)
 		wlc_lcnphy_set_tx_pwr_by_index(pi, SAVE_txpwrindex);
 }
 
-s16 wlc_lcnphy_tempsense_new(phy_info_t *pi, bool mode)
+s16 wlc_lcnphy_tempsense_new(struct brcms_phy *pi, bool mode)
 {
 	u16 tempsenseval1, tempsenseval2;
 	s16 avg = 0;
@@ -2997,13 +3004,13 @@ s16 wlc_lcnphy_tempsense_new(phy_info_t *pi, bool mode)
 	return avg;
 }
 
-u16 wlc_lcnphy_tempsense(phy_info_t *pi, bool mode)
+u16 wlc_lcnphy_tempsense(struct brcms_phy *pi, bool mode)
 {
 	u16 tempsenseval1, tempsenseval2;
 	s32 avg = 0;
 	bool suspend = 0;
 	u16 SAVE_txpwrctrl = wlc_lcnphy_get_tx_pwr_ctrl(pi);
-	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	if (NORADIO_ENAB(pi->pubpi))
 		return -1;
@@ -3058,7 +3065,7 @@ u16 wlc_lcnphy_tempsense(phy_info_t *pi, bool mode)
 	return (u16) avg;
 }
 
-s8 wlc_lcnphy_tempsense_degree(phy_info_t *pi, bool mode)
+s8 wlc_lcnphy_tempsense_degree(struct brcms_phy *pi, bool mode)
 {
 	s32 degree = wlc_lcnphy_tempsense_new(pi, mode);
 	degree =
@@ -3067,7 +3074,7 @@ s8 wlc_lcnphy_tempsense_degree(phy_info_t *pi, bool mode)
 	return (s8) degree;
 }
 
-s8 wlc_lcnphy_vbatsense(phy_info_t *pi, bool mode)
+s8 wlc_lcnphy_vbatsense(struct brcms_phy *pi, bool mode)
 {
 	u16 vbatsenseval;
 	s32 avg = 0;
@@ -3103,7 +3110,7 @@ s8 wlc_lcnphy_vbatsense(phy_info_t *pi, bool mode)
 	return (s8) avg;
 }
 
-static void wlc_lcnphy_afe_clk_init(phy_info_t *pi, u8 mode)
+static void wlc_lcnphy_afe_clk_init(struct brcms_phy *pi, u8 mode)
 {
 	u8 phybw40;
 	phybw40 = CHSPEC_IS40(pi->radio_chanspec);
@@ -3118,7 +3125,7 @@ static void wlc_lcnphy_afe_clk_init(phy_info_t *pi, u8 mode)
 }
 
 static bool
-wlc_lcnphy_rx_iq_est(phy_info_t *pi,
+wlc_lcnphy_rx_iq_est(struct brcms_phy *pi,
 		     u16 num_samps,
 		     u8 wait_time, struct lcnphy_iq_est *iq_est)
 {
@@ -3164,7 +3171,7 @@ wlc_lcnphy_rx_iq_est(phy_info_t *pi,
 	return result;
 }
 
-static bool wlc_lcnphy_calc_rx_iq_comp(phy_info_t *pi, u16 num_samps)
+static bool wlc_lcnphy_calc_rx_iq_comp(struct brcms_phy *pi, u16 num_samps)
 {
 #define LCNPHY_MIN_RXIQ_PWR 2
 	bool result;
@@ -3174,7 +3181,7 @@ static bool wlc_lcnphy_calc_rx_iq_comp(phy_info_t *pi, u16 num_samps)
 	s16 iq_nbits, qq_nbits, arsh, brsh;
 	s32 iq;
 	u32 ii, qq;
-	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	a0_new = ((read_phy_reg(pi, 0x645) & (0x3ff << 0)) >> 0);
 	b0_new = ((read_phy_reg(pi, 0x646) & (0x3ff << 0)) >> 0);
@@ -3250,7 +3257,8 @@ static bool wlc_lcnphy_calc_rx_iq_comp(phy_info_t *pi, u16 num_samps)
 }
 
 static bool
-wlc_lcnphy_rx_iq_cal(phy_info_t *pi, const struct lcnphy_rx_iqcomp *iqcomp,
+wlc_lcnphy_rx_iq_cal(struct brcms_phy *pi,
+		     const struct lcnphy_rx_iqcomp *iqcomp,
 		     int iqcomp_sz, bool tx_switch, bool rx_switch, int module,
 		     int tx_gain_idx)
 {
@@ -3267,7 +3275,7 @@ wlc_lcnphy_rx_iq_cal(phy_info_t *pi, const struct lcnphy_rx_iqcomp *iqcomp,
 	u16 old_sslpnCalibClkEnCtrl, old_sslpnRxFeClkEnCtrl;
 	u16 values_to_save[11];
 	s16 *ptr;
-	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	ptr = kmalloc(sizeof(s16) * 131, GFP_ATOMIC);
 	if (NULL == ptr) {
@@ -3418,18 +3426,18 @@ wlc_lcnphy_rx_iq_cal(phy_info_t *pi, const struct lcnphy_rx_iqcomp *iqcomp,
 	return result;
 }
 
-static void wlc_lcnphy_temp_adj(phy_info_t *pi)
+static void wlc_lcnphy_temp_adj(struct brcms_phy *pi)
 {
 	if (NORADIO_ENAB(pi->pubpi))
 		return;
 }
 
-static void wlc_lcnphy_glacial_timer_based_cal(phy_info_t *pi)
+static void wlc_lcnphy_glacial_timer_based_cal(struct brcms_phy *pi)
 {
 	bool suspend;
 	s8 index;
 	u16 SAVE_pwrctrl = wlc_lcnphy_get_tx_pwr_ctrl(pi);
-	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 	suspend =
 	    (0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
 	if (!suspend)
@@ -3449,7 +3457,7 @@ static void wlc_lcnphy_glacial_timer_based_cal(phy_info_t *pi)
 
 }
 
-static void wlc_lcnphy_periodic_cal(phy_info_t *pi)
+static void wlc_lcnphy_periodic_cal(struct brcms_phy *pi)
 {
 	bool suspend, full_cal;
 	const struct lcnphy_rx_iqcomp *rx_iqcomp;
@@ -3459,7 +3467,7 @@ static void wlc_lcnphy_periodic_cal(phy_info_t *pi)
 	struct phytbl_info tab;
 	s32 a1, b0, b1;
 	s32 tssi, pwr, maxtargetpwr, mintargetpwr;
-	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	if (NORADIO_ENAB(pi->pubpi))
 		return;
@@ -3521,11 +3529,11 @@ static void wlc_lcnphy_periodic_cal(phy_info_t *pi)
 		wlapi_enable_mac(pi->sh->physhim);
 }
 
-void wlc_lcnphy_calib_modes(phy_info_t *pi, uint mode)
+void wlc_lcnphy_calib_modes(struct brcms_phy *pi, uint mode)
 {
 	u16 temp_new;
 	int temp1, temp2, temp_diff;
-	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	switch (mode) {
 	case PHY_PERICAL_CHAN:
@@ -3560,7 +3568,7 @@ void wlc_lcnphy_calib_modes(phy_info_t *pi, uint mode)
 	}
 }
 
-void wlc_lcnphy_get_tssi(phy_info_t *pi, s8 *ofdm_pwr, s8 *cck_pwr)
+void wlc_lcnphy_get_tssi(struct brcms_phy *pi, s8 *ofdm_pwr, s8 *cck_pwr)
 {
 	s8 cck_offset;
 	u16 status;
@@ -3582,16 +3590,17 @@ void wlc_lcnphy_get_tssi(phy_info_t *pi, s8 *ofdm_pwr, s8 *cck_pwr)
 	}
 }
 
-void WLBANDINITFN(wlc_phy_cal_init_lcnphy) (phy_info_t *pi)
+void WLBANDINITFN(wlc_phy_cal_init_lcnphy) (struct brcms_phy *pi)
 {
 	return;
 
 }
 
-static void wlc_lcnphy_set_chanspec_tweaks(phy_info_t *pi, chanspec_t chanspec)
+static void
+wlc_lcnphy_set_chanspec_tweaks(struct brcms_phy *pi, chanspec_t chanspec)
 {
 	u8 channel = CHSPEC_CHANNEL(chanspec);
-	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	if (NORADIO_ENAB(pi->pubpi))
 		return;
@@ -3644,8 +3653,8 @@ void wlc_lcnphy_tx_power_adjustment(wlc_phy_t *ppi)
 {
 	s8 index;
 	u16 index2;
-	phy_info_t *pi = (phy_info_t *) ppi;
-	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	struct brcms_phy *pi = (struct brcms_phy *) ppi;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 	u16 SAVE_txpwrctrl = wlc_lcnphy_get_tx_pwr_ctrl(pi);
 	if (wlc_lcnphy_tempsense_based_pwr_ctrl_enabled(pi) && SAVE_txpwrctrl) {
 		index = wlc_lcnphy_tempcompensated_txpwrctrl(pi);
@@ -3657,7 +3666,7 @@ void wlc_lcnphy_tx_power_adjustment(wlc_phy_t *ppi)
 	}
 }
 
-static void wlc_lcnphy_set_rx_iq_comp(phy_info_t *pi, u16 a, u16 b)
+static void wlc_lcnphy_set_rx_iq_comp(struct brcms_phy *pi, u16 a, u16 b)
 {
 	mod_phy_reg(pi, 0x645, (0x3ff << 0), (a) << 0);
 
@@ -3673,10 +3682,10 @@ static void wlc_lcnphy_set_rx_iq_comp(phy_info_t *pi, u16 a, u16 b)
 
 }
 
-void WLBANDINITFN(wlc_phy_init_lcnphy) (phy_info_t *pi)
+void WLBANDINITFN(wlc_phy_init_lcnphy) (struct brcms_phy *pi)
 {
 	u8 phybw40;
-	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 	phybw40 = CHSPEC_IS40(pi->radio_chanspec);
 
 	pi_lcn->lcnphy_cal_counter = 0;
@@ -3723,7 +3732,7 @@ void WLBANDINITFN(wlc_phy_init_lcnphy) (phy_info_t *pi)
 }
 
 static void
-wlc_lcnphy_tx_iqlo_loopback(phy_info_t *pi, u16 *values_to_save)
+wlc_lcnphy_tx_iqlo_loopback(struct brcms_phy *pi, u16 *values_to_save)
 {
 	u16 vmid;
 	int i;
@@ -3816,14 +3825,14 @@ wlc_lcnphy_tx_iqlo_loopback(phy_info_t *pi, u16 *values_to_save)
 }
 
 static void
-wlc_lcnphy_samp_cap(phy_info_t *pi, int clip_detect_algo, u16 thresh,
+wlc_lcnphy_samp_cap(struct brcms_phy *pi, int clip_detect_algo, u16 thresh,
 		    s16 *ptr, int mode)
 {
 	u32 curval1, curval2, stpptr, curptr, strptr, val;
 	u16 sslpnCalibClkEnCtrl, timer;
 	u16 old_sslpnCalibClkEnCtrl;
 	s16 imag, real;
-	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	timer = 0;
 	old_sslpnCalibClkEnCtrl = read_phy_reg(pi, 0x6da);
@@ -3892,7 +3901,7 @@ wlc_lcnphy_samp_cap(phy_info_t *pi, int clip_detect_algo, u16 thresh,
 	W_REG(&pi->regs->psm_corectlsts, curval1);
 }
 
-static void wlc_lcnphy_tx_iqlo_soft_cal_full(phy_info_t *pi)
+static void wlc_lcnphy_tx_iqlo_soft_cal_full(struct brcms_phy *pi)
 {
 	struct lcnphy_unsign16_struct iqcc0, locc2, locc3, locc4;
 
@@ -3915,7 +3924,7 @@ static void wlc_lcnphy_tx_iqlo_soft_cal_full(phy_info_t *pi)
 }
 
 static void
-wlc_lcnphy_set_cc(phy_info_t *pi, int cal_type, s16 coeff_x, s16 coeff_y)
+wlc_lcnphy_set_cc(struct brcms_phy *pi, int cal_type, s16 coeff_x, s16 coeff_y)
 {
 	u16 di0dq0;
 	u16 x, y, data_rf;
@@ -3960,7 +3969,7 @@ wlc_lcnphy_set_cc(phy_info_t *pi, int cal_type, s16 coeff_x, s16 coeff_y)
 }
 
 static struct lcnphy_unsign16_struct
-wlc_lcnphy_get_cc(phy_info_t *pi, int cal_type)
+wlc_lcnphy_get_cc(struct brcms_phy *pi, int cal_type)
 {
 	u16 a, b, didq;
 	u8 di0, dq0, ei, eq, fi, fq;
@@ -3995,7 +4004,8 @@ wlc_lcnphy_get_cc(phy_info_t *pi, int cal_type)
 }
 
 static void
-wlc_lcnphy_a1(phy_info_t *pi, int cal_type, int num_levels, int step_size_lg2)
+wlc_lcnphy_a1(struct brcms_phy *pi, int cal_type, int num_levels,
+	      int step_size_lg2)
 {
 	const struct lcnphy_spb_tone *phy_c1;
 	struct lcnphy_spb_tone phy_c2;
@@ -4193,7 +4203,7 @@ wlc_lcnphy_a1(phy_info_t *pi, int cal_type, int num_levels, int step_size_lg2)
 }
 
 static void
-wlc_lcnphy_tx_iqlo_loopback_cleanup(phy_info_t *pi, u16 *values_to_save)
+wlc_lcnphy_tx_iqlo_loopback_cleanup(struct brcms_phy *pi, u16 *values_to_save)
 {
 	int i;
 
@@ -4208,7 +4218,7 @@ wlc_lcnphy_tx_iqlo_loopback_cleanup(phy_info_t *pi, u16 *values_to_save)
 }
 
 static void
-WLBANDINITFN(wlc_lcnphy_load_tx_gain_table) (phy_info_t *pi,
+WLBANDINITFN(wlc_lcnphy_load_tx_gain_table) (struct brcms_phy *pi,
 			const struct lcnphy_tx_gain_tbl_entry *gain_table) {
 	u32 j;
 	struct phytbl_info tab;
@@ -4243,7 +4253,7 @@ WLBANDINITFN(wlc_lcnphy_load_tx_gain_table) (phy_info_t *pi,
 	}
 }
 
-static void wlc_lcnphy_load_rfpower(phy_info_t *pi)
+static void wlc_lcnphy_load_rfpower(struct brcms_phy *pi)
 {
 	struct phytbl_info tab;
 	u32 val, bbmult, rfgain;
@@ -4292,7 +4302,7 @@ static void wlc_lcnphy_load_rfpower(phy_info_t *pi)
 	}
 }
 
-static void WLBANDINITFN(wlc_lcnphy_tbl_init) (phy_info_t *pi)
+static void WLBANDINITFN(wlc_lcnphy_tbl_init) (struct brcms_phy *pi)
 {
 	uint idx;
 	u8 phybw40;
@@ -4387,10 +4397,10 @@ static void WLBANDINITFN(wlc_lcnphy_tbl_init) (phy_info_t *pi)
 	wlc_lcnphy_clear_papd_comptable(pi);
 }
 
-static void WLBANDINITFN(wlc_lcnphy_rev0_baseband_init) (phy_info_t *pi)
+static void WLBANDINITFN(wlc_lcnphy_rev0_baseband_init) (struct brcms_phy *pi)
 {
 	u16 afectrl1;
-	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	write_radio_reg(pi, RADIO_2064_REG11C, 0x0);
 
@@ -4434,7 +4444,7 @@ static void WLBANDINITFN(wlc_lcnphy_rev0_baseband_init) (phy_info_t *pi)
 
 }
 
-static void WLBANDINITFN(wlc_lcnphy_rev2_baseband_init) (phy_info_t *pi)
+static void WLBANDINITFN(wlc_lcnphy_rev2_baseband_init) (struct brcms_phy *pi)
 {
 	if (CHSPEC_IS5G(pi->radio_chanspec)) {
 		mod_phy_reg(pi, 0x416, (0xff << 0), 80 << 0);
@@ -4443,12 +4453,12 @@ static void WLBANDINITFN(wlc_lcnphy_rev2_baseband_init) (phy_info_t *pi)
 	}
 }
 
-static void wlc_lcnphy_agc_temp_init(phy_info_t *pi)
+static void wlc_lcnphy_agc_temp_init(struct brcms_phy *pi)
 {
 	s16 temp;
 	struct phytbl_info tab;
 	u32 tableBuffer[2];
-	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	if (NORADIO_ENAB(pi->pubpi))
 		return;
@@ -4504,7 +4514,7 @@ static void wlc_lcnphy_agc_temp_init(phy_info_t *pi)
 
 }
 
-static void WLBANDINITFN(wlc_lcnphy_bu_tweaks) (phy_info_t *pi)
+static void WLBANDINITFN(wlc_lcnphy_bu_tweaks) (struct brcms_phy *pi)
 {
 	if (NORADIO_ENAB(pi->pubpi))
 		return;
@@ -4559,7 +4569,7 @@ static void WLBANDINITFN(wlc_lcnphy_bu_tweaks) (phy_info_t *pi)
 	}
 }
 
-static void WLBANDINITFN(wlc_lcnphy_baseband_init) (phy_info_t *pi)
+static void WLBANDINITFN(wlc_lcnphy_baseband_init) (struct brcms_phy *pi)
 {
 
 	wlc_lcnphy_tbl_init(pi);
@@ -4569,7 +4579,7 @@ static void WLBANDINITFN(wlc_lcnphy_baseband_init) (phy_info_t *pi)
 	wlc_lcnphy_bu_tweaks(pi);
 }
 
-static void WLBANDINITFN(wlc_radio_2064_init) (phy_info_t *pi)
+static void WLBANDINITFN(wlc_radio_2064_init) (struct brcms_phy *pi)
 {
 	u32 i;
 	struct lcnphy_radio_regs *lcnphyregs = NULL;
@@ -4630,7 +4640,7 @@ static void WLBANDINITFN(wlc_radio_2064_init) (phy_info_t *pi)
 	wlc_lcnphy_rc_cal(pi);
 }
 
-static void WLBANDINITFN(wlc_lcnphy_radio_init) (phy_info_t *pi)
+static void WLBANDINITFN(wlc_lcnphy_radio_init) (struct brcms_phy *pi)
 {
 	if (NORADIO_ENAB(pi->pubpi))
 		return;
@@ -4638,7 +4648,7 @@ static void WLBANDINITFN(wlc_lcnphy_radio_init) (phy_info_t *pi)
 	wlc_radio_2064_init(pi);
 }
 
-static void wlc_lcnphy_rcal(phy_info_t *pi)
+static void wlc_lcnphy_rcal(struct brcms_phy *pi)
 {
 	u8 rcal_value;
 
@@ -4669,7 +4679,7 @@ static void wlc_lcnphy_rcal(phy_info_t *pi)
 	and_radio_reg(pi, RADIO_2064_REG057, 0xFE);
 }
 
-static void wlc_lcnphy_rc_cal(phy_info_t *pi)
+static void wlc_lcnphy_rc_cal(struct brcms_phy *pi)
 {
 	u8 dflt_rc_cal_val;
 	u16 flt_val;
@@ -4692,11 +4702,11 @@ static void wlc_lcnphy_rc_cal(phy_info_t *pi)
 	return;
 }
 
-static bool wlc_phy_txpwr_srom_read_lcnphy(phy_info_t *pi)
+static bool wlc_phy_txpwr_srom_read_lcnphy(struct brcms_phy *pi)
 {
 	s8 txpwr = 0;
 	int i;
-	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	if (CHSPEC_IS2G(pi->radio_chanspec)) {
 		u16 cckpo = 0;
@@ -4814,7 +4824,7 @@ static bool wlc_phy_txpwr_srom_read_lcnphy(phy_info_t *pi)
 	return true;
 }
 
-void wlc_2064_vco_cal(phy_info_t *pi)
+void wlc_2064_vco_cal(struct brcms_phy *pi)
 {
 	u8 calnrst;
 
@@ -4830,7 +4840,7 @@ void wlc_2064_vco_cal(phy_info_t *pi)
 }
 
 static void
-wlc_lcnphy_radio_2064_channel_tune_4313(phy_info_t *pi, u8 channel)
+wlc_lcnphy_radio_2064_channel_tune_4313(struct brcms_phy *pi, u8 channel)
 {
 	uint i;
 	const struct chan_info_2064_lcnphy *ci;
@@ -4995,7 +5005,7 @@ wlc_lcnphy_radio_2064_channel_tune_4313(phy_info_t *pi, u8 channel)
 	}
 }
 
-bool wlc_phy_tpc_isenabled_lcnphy(phy_info_t *pi)
+bool wlc_phy_tpc_isenabled_lcnphy(struct brcms_phy *pi)
 {
 	if (wlc_lcnphy_tempsense_based_pwr_ctrl_enabled(pi))
 		return 0;
@@ -5004,7 +5014,7 @@ bool wlc_phy_tpc_isenabled_lcnphy(phy_info_t *pi)
 			wlc_lcnphy_get_tx_pwr_ctrl((pi)));
 }
 
-void wlc_phy_txpower_recalc_target_lcnphy(phy_info_t *pi)
+void wlc_phy_txpower_recalc_target_lcnphy(struct brcms_phy *pi)
 {
 	u16 pwr_ctrl;
 	if (wlc_lcnphy_tempsense_based_pwr_ctrl_enabled(pi)) {
@@ -5020,16 +5030,16 @@ void wlc_phy_txpower_recalc_target_lcnphy(phy_info_t *pi)
 		return;
 }
 
-void wlc_phy_detach_lcnphy(phy_info_t *pi)
+void wlc_phy_detach_lcnphy(struct brcms_phy *pi)
 {
 	kfree(pi->u.pi_lcnphy);
 }
 
-bool wlc_phy_attach_lcnphy(phy_info_t *pi)
+bool wlc_phy_attach_lcnphy(struct brcms_phy *pi)
 {
-	struct phy_info_lcnphy *pi_lcn;
+	struct brcms_phy_lcnphy *pi_lcn;
 
-	pi->u.pi_lcnphy = kzalloc(sizeof(struct phy_info_lcnphy), GFP_ATOMIC);
+	pi->u.pi_lcnphy = kzalloc(sizeof(struct brcms_phy_lcnphy), GFP_ATOMIC);
 	if (pi->u.pi_lcnphy == NULL) {
 		return false;
 	}
@@ -5072,7 +5082,7 @@ bool wlc_phy_attach_lcnphy(phy_info_t *pi)
 	return true;
 }
 
-static void wlc_lcnphy_set_rx_gain(phy_info_t *pi, u32 gain)
+static void wlc_lcnphy_set_rx_gain(struct brcms_phy *pi, u32 gain)
 {
 	u16 trsw, ext_lna, lna1, lna2, tia, biq0, biq1, gain0_15, gain16_19;
 
@@ -5102,12 +5112,12 @@ static void wlc_lcnphy_set_rx_gain(phy_info_t *pi, u32 gain)
 	wlc_lcnphy_rx_gain_override_enable(pi, true);
 }
 
-static u32 wlc_lcnphy_get_receive_power(phy_info_t *pi, s32 *gain_index)
+static u32 wlc_lcnphy_get_receive_power(struct brcms_phy *pi, s32 *gain_index)
 {
 	u32 received_power = 0;
 	s32 max_index = 0;
 	u32 gain_code = 0;
-	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	max_index = 36;
 	if (*gain_index >= 0)
@@ -5138,7 +5148,7 @@ static u32 wlc_lcnphy_get_receive_power(phy_info_t *pi, s32 *gain_index)
 	return received_power;
 }
 
-s32 wlc_lcnphy_rx_signal_power(phy_info_t *pi, s32 gain_index)
+s32 wlc_lcnphy_rx_signal_power(struct brcms_phy *pi, s32 gain_index)
 {
 	s32 gain = 0;
 	s32 nominal_power_db;
@@ -5146,7 +5156,7 @@ s32 wlc_lcnphy_rx_signal_power(phy_info_t *pi, s32 gain_index)
 	    input_power_db;
 	s32 received_power, temperature;
 	uint freq;
-	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	received_power = wlc_lcnphy_get_receive_power(pi, &gain_index);
 
@@ -5210,7 +5220,7 @@ s32 wlc_lcnphy_rx_signal_power(phy_info_t *pi, s32 gain_index)
 }
 
 static int
-wlc_lcnphy_load_tx_iir_filter(phy_info_t *pi, bool is_ofdm, s16 filt_type)
+wlc_lcnphy_load_tx_iir_filter(struct brcms_phy *pi, bool is_ofdm, s16 filt_type)
 {
 	s16 filt_index = -1;
 	int j;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.h
index b21a29b..f4a8ab0 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.h
@@ -19,7 +19,7 @@
 
 #include <types.h>
 
-struct phy_info_lcnphy {
+struct brcms_phy_lcnphy {
 	int lcnphy_txrf_sp_9_override;
 	u8 lcnphy_full_cal_channel;
 	u8 lcnphy_cal_counter;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
index e6fe8b7..6e2417e 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
@@ -14085,118 +14085,118 @@ static u8 ant_sw_ctrl_tbl_rev8_2057v7_core0[] = {
 static u8 ant_sw_ctrl_tbl_rev8_2057v7_core1[] = {
 	0x09, 0x0a, 0x09, 0x0a, 0x15, 0x16 };
 
-static bool wlc_phy_chan2freq_nphy(phy_info_t *pi, uint channel, int *f,
+static bool wlc_phy_chan2freq_nphy(struct brcms_phy *pi, uint channel, int *f,
 				   struct chan_info_nphy_radio2057 **t0,
 				   struct chan_info_nphy_radio205x **t1,
 				   struct chan_info_nphy_radio2057_rev5 **t2,
 				   struct chan_info_nphy_2055 **t3);
-static void wlc_phy_chanspec_nphy_setup(phy_info_t *pi, chanspec_t chans,
+static void wlc_phy_chanspec_nphy_setup(struct brcms_phy *pi, chanspec_t chans,
 					const struct nphy_sfo_cfg *c);
 
-static void wlc_phy_adjust_rx_analpfbw_nphy(phy_info_t *pi,
+static void wlc_phy_adjust_rx_analpfbw_nphy(struct brcms_phy *pi,
 					    u16 reduction_factr);
-static void wlc_phy_adjust_min_noisevar_nphy(phy_info_t *pi, int ntones, int *,
-					     u32 *buf);
-static void wlc_phy_adjust_crsminpwr_nphy(phy_info_t *pi, u8 minpwr);
-static void wlc_phy_txlpfbw_nphy(phy_info_t *pi);
-static void wlc_phy_spurwar_nphy(phy_info_t *pi);
-
-static void wlc_phy_radio_preinit_2055(phy_info_t *pi);
-static void wlc_phy_radio_init_2055(phy_info_t *pi);
-static void wlc_phy_radio_postinit_2055(phy_info_t *pi);
-static void wlc_phy_radio_preinit_205x(phy_info_t *pi);
-static void wlc_phy_radio_init_2056(phy_info_t *pi);
-static void wlc_phy_radio_postinit_2056(phy_info_t *pi);
-static void wlc_phy_radio_init_2057(phy_info_t *pi);
-static void wlc_phy_radio_postinit_2057(phy_info_t *pi);
-static void wlc_phy_workarounds_nphy(phy_info_t *pi);
-static void wlc_phy_workarounds_nphy_gainctrl(phy_info_t *pi);
-static void wlc_phy_workarounds_nphy_gainctrl_2057_rev5(phy_info_t *pi);
-static void wlc_phy_workarounds_nphy_gainctrl_2057_rev6(phy_info_t *pi);
-static void wlc_phy_adjust_lnagaintbl_nphy(phy_info_t *pi);
-
-static void wlc_phy_restore_rssical_nphy(phy_info_t *pi);
-static void wlc_phy_reapply_txcal_coeffs_nphy(phy_info_t *pi);
-static void wlc_phy_tx_iq_war_nphy(phy_info_t *pi);
-static int wlc_phy_cal_rxiq_nphy_rev3(phy_info_t *pi, struct nphy_txgains tg,
-				      u8 type, bool d);
-static void wlc_phy_rxcal_gainctrl_nphy_rev5(phy_info_t *pi, u8 rxcore,
+static void wlc_phy_adjust_min_noisevar_nphy(struct brcms_phy *pi,
+					     int ntones, int *, u32 *buf);
+static void wlc_phy_adjust_crsminpwr_nphy(struct brcms_phy *pi, u8 minpwr);
+static void wlc_phy_txlpfbw_nphy(struct brcms_phy *pi);
+static void wlc_phy_spurwar_nphy(struct brcms_phy *pi);
+
+static void wlc_phy_radio_preinit_2055(struct brcms_phy *pi);
+static void wlc_phy_radio_init_2055(struct brcms_phy *pi);
+static void wlc_phy_radio_postinit_2055(struct brcms_phy *pi);
+static void wlc_phy_radio_preinit_205x(struct brcms_phy *pi);
+static void wlc_phy_radio_init_2056(struct brcms_phy *pi);
+static void wlc_phy_radio_postinit_2056(struct brcms_phy *pi);
+static void wlc_phy_radio_init_2057(struct brcms_phy *pi);
+static void wlc_phy_radio_postinit_2057(struct brcms_phy *pi);
+static void wlc_phy_workarounds_nphy(struct brcms_phy *pi);
+static void wlc_phy_workarounds_nphy_gainctrl(struct brcms_phy *pi);
+static void wlc_phy_workarounds_nphy_gainctrl_2057_rev5(struct brcms_phy *pi);
+static void wlc_phy_workarounds_nphy_gainctrl_2057_rev6(struct brcms_phy *pi);
+static void wlc_phy_adjust_lnagaintbl_nphy(struct brcms_phy *pi);
+
+static void wlc_phy_restore_rssical_nphy(struct brcms_phy *pi);
+static void wlc_phy_reapply_txcal_coeffs_nphy(struct brcms_phy *pi);
+static void wlc_phy_tx_iq_war_nphy(struct brcms_phy *pi);
+static int wlc_phy_cal_rxiq_nphy_rev3(struct brcms_phy *pi,
+				      struct nphy_txgains tg, u8 type, bool d);
+static void wlc_phy_rxcal_gainctrl_nphy_rev5(struct brcms_phy *pi, u8 rxcore,
 					     u16 *rg, u8 type);
-static void wlc_phy_update_mimoconfig_nphy(phy_info_t *pi, s32 preamble);
-static void wlc_phy_savecal_nphy(phy_info_t *pi);
-static void wlc_phy_restorecal_nphy(phy_info_t *pi);
-static void wlc_phy_resetcca_nphy(phy_info_t *pi);
-
-static void wlc_phy_txpwrctrl_config_nphy(phy_info_t *pi);
-static void wlc_phy_internal_cal_txgain_nphy(phy_info_t *pi);
-static void wlc_phy_precal_txgain_nphy(phy_info_t *pi);
-static void wlc_phy_update_txcal_ladder_nphy(phy_info_t *pi, u16 core);
-
-static void wlc_phy_extpa_set_tx_digi_filts_nphy(phy_info_t *pi);
-static void wlc_phy_ipa_set_tx_digi_filts_nphy(phy_info_t *pi);
-static void wlc_phy_ipa_restore_tx_digi_filts_nphy(phy_info_t *pi);
-static u16 wlc_phy_ipa_get_bbmult_nphy(phy_info_t *pi);
-static void wlc_phy_ipa_set_bbmult_nphy(phy_info_t *pi, u8 m0, u8 m1);
-static u32 *wlc_phy_get_ipa_gaintbl_nphy(phy_info_t *pi);
-
-static void wlc_phy_a1_nphy(phy_info_t *pi, u8 core, u32 winsz, u32,
+static void wlc_phy_update_mimoconfig_nphy(struct brcms_phy *pi, s32 preamble);
+static void wlc_phy_savecal_nphy(struct brcms_phy *pi);
+static void wlc_phy_restorecal_nphy(struct brcms_phy *pi);
+static void wlc_phy_resetcca_nphy(struct brcms_phy *pi);
+
+static void wlc_phy_txpwrctrl_config_nphy(struct brcms_phy *pi);
+static void wlc_phy_internal_cal_txgain_nphy(struct brcms_phy *pi);
+static void wlc_phy_precal_txgain_nphy(struct brcms_phy *pi);
+static void wlc_phy_update_txcal_ladder_nphy(struct brcms_phy *pi, u16 core);
+
+static void wlc_phy_extpa_set_tx_digi_filts_nphy(struct brcms_phy *pi);
+static void wlc_phy_ipa_set_tx_digi_filts_nphy(struct brcms_phy *pi);
+static void wlc_phy_ipa_restore_tx_digi_filts_nphy(struct brcms_phy *pi);
+static u16 wlc_phy_ipa_get_bbmult_nphy(struct brcms_phy *pi);
+static void wlc_phy_ipa_set_bbmult_nphy(struct brcms_phy *pi, u8 m0, u8 m1);
+static u32 *wlc_phy_get_ipa_gaintbl_nphy(struct brcms_phy *pi);
+
+static void wlc_phy_a1_nphy(struct brcms_phy *pi, u8 core, u32 winsz, u32,
 			    u32 e);
-static u8 wlc_phy_a3_nphy(phy_info_t *pi, u8 start_gain, u8 core);
-static void wlc_phy_a2_nphy(phy_info_t *pi, struct nphy_ipa_txcalgains *,
+static u8 wlc_phy_a3_nphy(struct brcms_phy *pi, u8 start_gain, u8 core);
+static void wlc_phy_a2_nphy(struct brcms_phy *pi, struct nphy_ipa_txcalgains *,
 			    enum phy_cal_mode, u8);
-static void wlc_phy_papd_cal_cleanup_nphy(phy_info_t *pi,
+static void wlc_phy_papd_cal_cleanup_nphy(struct brcms_phy *pi,
 				struct nphy_papd_restore_state *state);
-static void wlc_phy_papd_cal_setup_nphy(phy_info_t *pi,
+static void wlc_phy_papd_cal_setup_nphy(struct brcms_phy *pi,
 				struct nphy_papd_restore_state *state, u8);
 
-static void wlc_phy_clip_det_nphy(phy_info_t *pi, u8 write, u16 *vals);
+static void wlc_phy_clip_det_nphy(struct brcms_phy *pi, u8 write, u16 *vals);
 
-static void wlc_phy_set_rfseq_nphy(phy_info_t *pi, u8 cmd, u8 *evts,
+static void wlc_phy_set_rfseq_nphy(struct brcms_phy *pi, u8 cmd, u8 *evts,
 				   u8 *dlys, u8 len);
 
-static u16 wlc_phy_read_lpf_bw_ctl_nphy(phy_info_t *pi, u16 offset);
+static u16 wlc_phy_read_lpf_bw_ctl_nphy(struct brcms_phy *pi, u16 offset);
 
 static void
-wlc_phy_rfctrl_override_nphy_rev7(phy_info_t *pi, u16 field, u16 value,
+wlc_phy_rfctrl_override_nphy_rev7(struct brcms_phy *pi, u16 field, u16 value,
 				  u8 core_mask, u8 off,
 				  u8 override_id);
 
-static void wlc_phy_rssi_cal_nphy_rev2(phy_info_t *pi, u8 rssi_type);
-static void wlc_phy_rssi_cal_nphy_rev3(phy_info_t *pi);
+static void wlc_phy_rssi_cal_nphy_rev2(struct brcms_phy *pi, u8 rssi_type);
+static void wlc_phy_rssi_cal_nphy_rev3(struct brcms_phy *pi);
 
-static bool wlc_phy_txpwr_srom_read_nphy(phy_info_t *pi);
+static bool wlc_phy_txpwr_srom_read_nphy(struct brcms_phy *pi);
 static void wlc_phy_txpwr_nphy_srom_convert(u8 *srom_max,
 					    u16 *pwr_offset,
 					    u8 tmp_max_pwr, u8 rate_start,
 					    u8 rate_end);
 
-static void wlc_phy_txpwr_limit_to_tbl_nphy(phy_info_t *pi);
-static void wlc_phy_txpwrctrl_coeff_setup_nphy(phy_info_t *pi);
-static void wlc_phy_txpwrctrl_idle_tssi_nphy(phy_info_t *pi);
-static void wlc_phy_txpwrctrl_pwr_setup_nphy(phy_info_t *pi);
+static void wlc_phy_txpwr_limit_to_tbl_nphy(struct brcms_phy *pi);
+static void wlc_phy_txpwrctrl_coeff_setup_nphy(struct brcms_phy *pi);
+static void wlc_phy_txpwrctrl_idle_tssi_nphy(struct brcms_phy *pi);
+static void wlc_phy_txpwrctrl_pwr_setup_nphy(struct brcms_phy *pi);
 
-static bool wlc_phy_txpwr_ison_nphy(phy_info_t *pi);
-static u8 wlc_phy_txpwr_idx_cur_get_nphy(phy_info_t *pi, u8 core);
-static void wlc_phy_txpwr_idx_cur_set_nphy(phy_info_t *pi, u8 idx0,
+static bool wlc_phy_txpwr_ison_nphy(struct brcms_phy *pi);
+static u8 wlc_phy_txpwr_idx_cur_get_nphy(struct brcms_phy *pi, u8 core);
+static void wlc_phy_txpwr_idx_cur_set_nphy(struct brcms_phy *pi, u8 idx0,
 					   u8 idx1);
-static void wlc_phy_a4(phy_info_t *pi, bool full_cal);
+static void wlc_phy_a4(struct brcms_phy *pi, bool full_cal);
 
-static u16 wlc_phy_radio205x_rcal(phy_info_t *pi);
+static u16 wlc_phy_radio205x_rcal(struct brcms_phy *pi);
 
-static u16 wlc_phy_radio2057_rccal(phy_info_t *pi);
+static u16 wlc_phy_radio2057_rccal(struct brcms_phy *pi);
 
-static u16 wlc_phy_gen_load_samples_nphy(phy_info_t *pi, u32 f_kHz,
+static u16 wlc_phy_gen_load_samples_nphy(struct brcms_phy *pi, u32 f_kHz,
 					    u16 max_val,
 					    u8 dac_test_mode);
-static void wlc_phy_loadsampletable_nphy(phy_info_t *pi, cs32 *tone_buf,
+static void wlc_phy_loadsampletable_nphy(struct brcms_phy *pi, cs32 *tone_buf,
 					 u16 num_samps);
-static void wlc_phy_runsamples_nphy(phy_info_t *pi, u16 n, u16 lps,
+static void wlc_phy_runsamples_nphy(struct brcms_phy *pi, u16 n, u16 lps,
 				    u16 wait, u8 iq, u8 dac_test_mode,
 				    bool modify_bbmult);
 
 bool wlc_phy_bist_check_phy(wlc_phy_t *pih)
 {
-	phy_info_t *pi = (phy_info_t *) pih;
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
 	u32 phybist0, phybist1, phybist2, phybist3, phybist4;
 
 	if (NREV_GE(pi->pubpi.phy_rev, 16))
@@ -14216,7 +14216,7 @@ bool wlc_phy_bist_check_phy(wlc_phy_t *pih)
 	return false;
 }
 
-static void WLBANDINITFN(wlc_phy_bphy_init_nphy) (phy_info_t *pi)
+static void WLBANDINITFN(wlc_phy_bphy_init_nphy) (struct brcms_phy *pi)
 {
 	u16 addr, val;
 
@@ -14245,7 +14245,7 @@ static void WLBANDINITFN(wlc_phy_bphy_init_nphy) (phy_info_t *pi)
 }
 
 void
-wlc_phy_table_write_nphy(phy_info_t *pi, u32 id, u32 len, u32 offset,
+wlc_phy_table_write_nphy(struct brcms_phy *pi, u32 id, u32 len, u32 offset,
 			 u32 width, const void *data)
 {
 	struct phytbl_info tbl;
@@ -14259,7 +14259,7 @@ wlc_phy_table_write_nphy(phy_info_t *pi, u32 id, u32 len, u32 offset,
 }
 
 void
-wlc_phy_table_read_nphy(phy_info_t *pi, u32 id, u32 len, u32 offset,
+wlc_phy_table_read_nphy(struct brcms_phy *pi, u32 id, u32 len, u32 offset,
 			u32 width, void *data)
 {
 	struct phytbl_info tbl;
@@ -14272,7 +14272,8 @@ wlc_phy_table_read_nphy(phy_info_t *pi, u32 id, u32 len, u32 offset,
 	wlc_phy_read_table_nphy(pi, &tbl);
 }
 
-static void WLBANDINITFN(wlc_phy_static_table_download_nphy) (phy_info_t *pi)
+static void
+WLBANDINITFN(wlc_phy_static_table_download_nphy) (struct brcms_phy *pi)
 {
 	uint idx;
 
@@ -14295,7 +14296,7 @@ static void WLBANDINITFN(wlc_phy_static_table_download_nphy) (phy_info_t *pi)
 	}
 }
 
-static void WLBANDINITFN(wlc_phy_tbl_init_nphy) (phy_info_t *pi)
+static void WLBANDINITFN(wlc_phy_tbl_init_nphy) (struct brcms_phy *pi)
 {
 	uint idx = 0;
 	u8 antswctrllut;
@@ -14417,13 +14418,13 @@ static void WLBANDINITFN(wlc_phy_tbl_init_nphy) (phy_info_t *pi)
 }
 
 static void
-wlc_phy_write_txmacreg_nphy(phy_info_t *pi, u16 holdoff, u16 delay)
+wlc_phy_write_txmacreg_nphy(struct brcms_phy *pi, u16 holdoff, u16 delay)
 {
 	write_phy_reg(pi, 0x77, holdoff);
 	write_phy_reg(pi, 0xb4, delay);
 }
 
-void wlc_phy_nphy_tkip_rifs_war(phy_info_t *pi, u8 rifs)
+void wlc_phy_nphy_tkip_rifs_war(struct brcms_phy *pi, u8 rifs)
 {
 	u16 holdoff, delay;
 
@@ -14444,7 +14445,7 @@ void wlc_phy_nphy_tkip_rifs_war(phy_info_t *pi, u8 rifs)
 	}
 }
 
-bool wlc_phy_attach_nphy(phy_info_t *pi)
+bool wlc_phy_attach_nphy(struct brcms_phy *pi)
 {
 	uint i;
 
@@ -14503,7 +14504,7 @@ bool wlc_phy_attach_nphy(phy_info_t *pi)
 	return true;
 }
 
-static void wlc_phy_txpwrctrl_config_nphy(phy_info_t *pi)
+static void wlc_phy_txpwrctrl_config_nphy(struct brcms_phy *pi)
 {
 
 	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
@@ -14523,7 +14524,7 @@ static void wlc_phy_txpwrctrl_config_nphy(phy_info_t *pi)
 		pi->phy_5g_pwrgain = true;
 }
 
-void WLBANDINITFN(wlc_phy_init_nphy) (phy_info_t *pi)
+void WLBANDINITFN(wlc_phy_init_nphy) (struct brcms_phy *pi)
 {
 	u16 val;
 	u16 clip1_ths[2];
@@ -14924,7 +14925,7 @@ void WLBANDINITFN(wlc_phy_init_nphy) (phy_info_t *pi)
 
 }
 
-static void wlc_phy_update_mimoconfig_nphy(phy_info_t *pi, s32 preamble)
+static void wlc_phy_update_mimoconfig_nphy(struct brcms_phy *pi, s32 preamble)
 {
 	bool gf_preamble = false;
 	u16 val;
@@ -14943,7 +14944,7 @@ static void wlc_phy_update_mimoconfig_nphy(phy_info_t *pi, s32 preamble)
 	write_phy_reg(pi, 0xed, val);
 }
 
-static void wlc_phy_resetcca_nphy(phy_info_t *pi)
+static void wlc_phy_resetcca_nphy(struct brcms_phy *pi)
 {
 	u16 val;
 
@@ -14959,7 +14960,7 @@ static void wlc_phy_resetcca_nphy(phy_info_t *pi)
 	wlc_phy_force_rfseq_nphy(pi, NPHY_RFSEQ_RESET2RX);
 }
 
-void wlc_phy_pa_override_nphy(phy_info_t *pi, bool en)
+void wlc_phy_pa_override_nphy(struct brcms_phy *pi, bool en)
 {
 	u16 rfctrlintc_override_val;
 
@@ -14988,7 +14989,7 @@ void wlc_phy_pa_override_nphy(phy_info_t *pi, bool en)
 
 }
 
-void wlc_phy_stf_chain_upd_nphy(phy_info_t *pi)
+void wlc_phy_stf_chain_upd_nphy(struct brcms_phy *pi)
 {
 
 	u16 txrx_chain =
@@ -15028,7 +15029,7 @@ void wlc_phy_rxcore_setstate_nphy(wlc_phy_t *pih, u8 rxcore_bitmask)
 	u16 regval;
 	u16 tbl_buf[16];
 	uint i;
-	phy_info_t *pi = (phy_info_t *) pih;
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
 	u16 tbl_opcode;
 	bool suspend;
 
@@ -15107,7 +15108,7 @@ void wlc_phy_rxcore_setstate_nphy(wlc_phy_t *pih, u8 rxcore_bitmask)
 u8 wlc_phy_rxcore_getstate_nphy(wlc_phy_t *pih)
 {
 	u16 regval, rxen_bits;
-	phy_info_t *pi = (phy_info_t *) pih;
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
 	regval = read_phy_reg(pi, 0xa2);
 	rxen_bits = (regval >> 4) & 0xf;
@@ -15115,12 +15116,12 @@ u8 wlc_phy_rxcore_getstate_nphy(wlc_phy_t *pih)
 	return (u8) rxen_bits;
 }
 
-bool wlc_phy_n_txpower_ipa_ison(phy_info_t *pi)
+bool wlc_phy_n_txpower_ipa_ison(struct brcms_phy *pi)
 {
 	return PHY_IPA(pi);
 }
 
-static void wlc_phy_txpwr_limit_to_tbl_nphy(phy_info_t *pi)
+static void wlc_phy_txpwr_limit_to_tbl_nphy(struct brcms_phy *pi)
 {
 	u8 idx, idx2, i, delta_ind;
 
@@ -15214,11 +15215,12 @@ static void wlc_phy_txpwr_limit_to_tbl_nphy(phy_info_t *pi)
 	}
 }
 
-void wlc_phy_cal_init_nphy(phy_info_t *pi)
+void wlc_phy_cal_init_nphy(struct brcms_phy *pi)
 {
 }
 
-static void wlc_phy_war_force_trsw_to_R_cliplo_nphy(phy_info_t *pi, u8 core)
+static void
+wlc_phy_war_force_trsw_to_R_cliplo_nphy(struct brcms_phy *pi, u8 core)
 {
 	if (core == PHY_CORE_0) {
 		write_phy_reg(pi, 0x38, 0x4);
@@ -15237,7 +15239,7 @@ static void wlc_phy_war_force_trsw_to_R_cliplo_nphy(phy_info_t *pi, u8 core)
 	}
 }
 
-static void wlc_phy_war_txchain_upd_nphy(phy_info_t *pi, u8 txchain)
+static void wlc_phy_war_txchain_upd_nphy(struct brcms_phy *pi, u8 txchain)
 {
 	u8 txchain0, txchain1;
 
@@ -15252,7 +15254,7 @@ static void wlc_phy_war_txchain_upd_nphy(phy_info_t *pi, u8 txchain)
 	}
 }
 
-static void wlc_phy_workarounds_nphy(phy_info_t *pi)
+static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 {
 	u8 rfseq_rx2tx_events[] = {
 		NPHY_RFSEQ_CMD_NOP,
@@ -16325,7 +16327,7 @@ static void wlc_phy_workarounds_nphy(phy_info_t *pi)
 		wlc_phy_stay_in_carriersearch_nphy(pi, false);
 }
 
-static void wlc_phy_workarounds_nphy_gainctrl(phy_info_t *pi)
+static void wlc_phy_workarounds_nphy_gainctrl(struct brcms_phy *pi)
 {
 	u16 w1th, hpf_code, currband;
 	int ctr;
@@ -16945,7 +16947,7 @@ static void wlc_phy_workarounds_nphy_gainctrl(phy_info_t *pi)
 	}
 }
 
-static void wlc_phy_workarounds_nphy_gainctrl_2057_rev5(phy_info_t *pi)
+static void wlc_phy_workarounds_nphy_gainctrl_2057_rev5(struct brcms_phy *pi)
 {
 	s8 lna1_gain_db[] = { 8, 13, 17, 22 };
 	s8 lna2_gain_db[] = { -2, 7, 11, 15 };
@@ -17000,7 +17002,7 @@ static void wlc_phy_workarounds_nphy_gainctrl_2057_rev5(phy_info_t *pi)
 	}
 }
 
-static void wlc_phy_workarounds_nphy_gainctrl_2057_rev6(phy_info_t *pi)
+static void wlc_phy_workarounds_nphy_gainctrl_2057_rev6(struct brcms_phy *pi)
 {
 	u16 currband;
 	s8 lna1G_gain_db_rev7[] = { 9, 14, 19, 24 };
@@ -17206,7 +17208,7 @@ static void wlc_phy_workarounds_nphy_gainctrl_2057_rev6(phy_info_t *pi)
 
 }
 
-static void wlc_phy_adjust_lnagaintbl_nphy(phy_info_t *pi)
+static void wlc_phy_adjust_lnagaintbl_nphy(struct brcms_phy *pi)
 {
 	uint core;
 	int ctr;
@@ -17269,7 +17271,7 @@ static void wlc_phy_adjust_lnagaintbl_nphy(phy_info_t *pi)
 		wlc_phy_stay_in_carriersearch_nphy(pi, false);
 }
 
-void wlc_phy_switch_radio_nphy(phy_info_t *pi, bool on)
+void wlc_phy_switch_radio_nphy(struct brcms_phy *pi, bool on)
 {
 	if (on) {
 		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
@@ -17352,7 +17354,7 @@ void wlc_phy_switch_radio_nphy(phy_info_t *pi, bool on)
 	}
 }
 
-static void wlc_phy_radio_preinit_2055(phy_info_t *pi)
+static void wlc_phy_radio_preinit_2055(struct brcms_phy *pi)
 {
 
 	and_phy_reg(pi, 0x78, ~RFCC_POR_FORCE);
@@ -17361,12 +17363,12 @@ static void wlc_phy_radio_preinit_2055(phy_info_t *pi)
 	or_phy_reg(pi, 0x78, RFCC_POR_FORCE);
 }
 
-static void wlc_phy_radio_init_2055(phy_info_t *pi)
+static void wlc_phy_radio_init_2055(struct brcms_phy *pi)
 {
 	wlc_phy_init_radio_regs(pi, regs_2055, RADIO_DEFAULT_CORE);
 }
 
-static void wlc_phy_radio_postinit_2055(phy_info_t *pi)
+static void wlc_phy_radio_postinit_2055(struct brcms_phy *pi)
 {
 
 	and_radio_reg(pi, RADIO_2055_MASTER_CNTRL1,
@@ -17431,7 +17433,7 @@ static void wlc_phy_radio_postinit_2055(phy_info_t *pi)
 	udelay(2);
 }
 
-static void wlc_phy_radio_preinit_205x(phy_info_t *pi)
+static void wlc_phy_radio_preinit_205x(struct brcms_phy *pi)
 {
 
 	and_phy_reg(pi, 0x78, ~RFCC_CHIP0_PU);
@@ -17442,7 +17444,7 @@ static void wlc_phy_radio_preinit_205x(phy_info_t *pi)
 
 }
 
-static void wlc_phy_radio_init_2056(phy_info_t *pi)
+static void wlc_phy_radio_init_2056(struct brcms_phy *pi)
 {
 	struct radio_regs *regs_SYN_2056_ptr = NULL;
 	struct radio_regs *regs_TX_2056_ptr = NULL;
@@ -17505,7 +17507,7 @@ static void wlc_phy_radio_init_2056(phy_info_t *pi)
 	wlc_phy_init_radio_regs(pi, regs_RX_2056_ptr, (u16) RADIO_2056_RX1);
 }
 
-static void wlc_phy_radio_postinit_2056(phy_info_t *pi)
+static void wlc_phy_radio_postinit_2056(struct brcms_phy *pi)
 {
 	mod_radio_reg(pi, RADIO_2056_SYN_COM_CTRL, 0xb, 0xb);
 
@@ -17530,7 +17532,7 @@ static void wlc_phy_radio_postinit_2056(phy_info_t *pi)
 	}
 }
 
-static void wlc_phy_radio_init_2057(phy_info_t *pi)
+static void wlc_phy_radio_init_2057(struct brcms_phy *pi)
 {
 	struct radio_20xx_regs *regs_2057_ptr = NULL;
 
@@ -17571,7 +17573,7 @@ static void wlc_phy_radio_init_2057(phy_info_t *pi)
 	wlc_phy_init_radio_regs_allbands(pi, regs_2057_ptr);
 }
 
-static void wlc_phy_radio_postinit_2057(phy_info_t *pi)
+static void wlc_phy_radio_postinit_2057(struct brcms_phy *pi)
 {
 
 	mod_radio_reg(pi, RADIO_2057_XTALPUOVR_PINCTRL, 0x1, 0x1);
@@ -17591,7 +17593,7 @@ static void wlc_phy_radio_postinit_2057(phy_info_t *pi)
 }
 
 static bool
-wlc_phy_chan2freq_nphy(phy_info_t *pi, uint channel, int *f,
+wlc_phy_chan2freq_nphy(struct brcms_phy *pi, uint channel, int *f,
 		       struct chan_info_nphy_radio2057 **t0,
 		       struct chan_info_nphy_radio205x **t1,
 		       struct chan_info_nphy_radio2057_rev5 **t2,
@@ -17759,7 +17761,7 @@ wlc_phy_chan2freq_nphy(phy_info_t *pi, uint channel, int *f,
 	return false;
 }
 
-u8 wlc_phy_get_chan_freq_range_nphy(phy_info_t *pi, uint channel)
+u8 wlc_phy_get_chan_freq_range_nphy(struct brcms_phy *pi, uint channel)
 {
 	int freq;
 	struct chan_info_nphy_radio2057 *t0 = NULL;
@@ -17788,7 +17790,8 @@ u8 wlc_phy_get_chan_freq_range_nphy(phy_info_t *pi, uint channel)
 }
 
 static void
-wlc_phy_chanspec_radio2055_setup(phy_info_t *pi, struct chan_info_nphy_2055 *ci)
+wlc_phy_chanspec_radio2055_setup(struct brcms_phy *pi,
+				 struct chan_info_nphy_2055 *ci)
 {
 
 	write_radio_reg(pi, RADIO_2055_PLL_REF, ci->RF_pll_ref);
@@ -17850,7 +17853,7 @@ wlc_phy_chanspec_radio2055_setup(phy_info_t *pi, struct chan_info_nphy_2055 *ci)
 }
 
 static void
-wlc_phy_chanspec_radio2056_setup(phy_info_t *pi,
+wlc_phy_chanspec_radio2056_setup(struct brcms_phy *pi,
 				 const struct chan_info_nphy_radio205x *ci)
 {
 	struct radio_regs *regs_SYN_2056_ptr = NULL;
@@ -18166,7 +18169,7 @@ wlc_phy_chanspec_radio2056_setup(phy_info_t *pi,
 	wlc_phy_radio205x_vcocal_nphy(pi);
 }
 
-void wlc_phy_radio205x_vcocal_nphy(phy_info_t *pi)
+void wlc_phy_radio205x_vcocal_nphy(struct brcms_phy *pi)
 {
 	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 		mod_radio_reg(pi, RADIO_2057_RFPLL_MISC_EN, 0x01, 0x0);
@@ -18187,7 +18190,7 @@ void wlc_phy_radio205x_vcocal_nphy(phy_info_t *pi)
 
 #define MAX_205x_RCAL_WAITLOOPS 10000
 
-static u16 wlc_phy_radio205x_rcal(phy_info_t *pi)
+static u16 wlc_phy_radio205x_rcal(struct brcms_phy *pi)
 {
 	u16 rcal_reg = 0;
 	int i;
@@ -18293,7 +18296,7 @@ static u16 wlc_phy_radio205x_rcal(phy_info_t *pi)
 }
 
 static void
-wlc_phy_chanspec_radio2057_setup(phy_info_t *pi,
+wlc_phy_chanspec_radio2057_setup(struct brcms_phy *pi,
 			const struct chan_info_nphy_radio2057 *ci,
 			const struct chan_info_nphy_radio2057_rev5 *ci2)
 {
@@ -18488,7 +18491,7 @@ wlc_phy_chanspec_radio2057_setup(phy_info_t *pi,
 	wlc_phy_radio205x_vcocal_nphy(pi);
 }
 
-static u16 wlc_phy_radio2057_rccal(phy_info_t *pi)
+static u16 wlc_phy_radio2057_rccal(struct brcms_phy *pi)
 {
 	u16 rccal_valid;
 	int i;
@@ -18572,7 +18575,7 @@ static u16 wlc_phy_radio2057_rccal(phy_info_t *pi)
 }
 
 static void
-wlc_phy_adjust_rx_analpfbw_nphy(phy_info_t *pi, u16 reduction_factr)
+wlc_phy_adjust_rx_analpfbw_nphy(struct brcms_phy *pi, u16 reduction_factr)
 {
 	if (NREV_GE(pi->pubpi.phy_rev, 3) && NREV_LT(pi->pubpi.phy_rev, 7)) {
 		if ((CHSPEC_CHANNEL(pi->radio_chanspec) == 11) &&
@@ -18600,8 +18603,8 @@ wlc_phy_adjust_rx_analpfbw_nphy(phy_info_t *pi, u16 reduction_factr)
 }
 
 static void
-wlc_phy_adjust_min_noisevar_nphy(phy_info_t *pi, int ntones, int *tone_id_buf,
-				 u32 *noise_var_buf)
+wlc_phy_adjust_min_noisevar_nphy(struct brcms_phy *pi, int ntones,
+				 int *tone_id_buf, u32 *noise_var_buf)
 {
 	int i;
 	u32 offset;
@@ -18649,7 +18652,7 @@ wlc_phy_adjust_min_noisevar_nphy(phy_info_t *pi, int ntones, int *tone_id_buf,
 	}
 }
 
-static void wlc_phy_adjust_crsminpwr_nphy(phy_info_t *pi, u8 minpwr)
+static void wlc_phy_adjust_crsminpwr_nphy(struct brcms_phy *pi, u8 minpwr)
 {
 	u16 regval;
 
@@ -18700,7 +18703,7 @@ static void wlc_phy_adjust_crsminpwr_nphy(phy_info_t *pi, u8 minpwr)
 	}
 }
 
-static void wlc_phy_txlpfbw_nphy(phy_info_t *pi)
+static void wlc_phy_txlpfbw_nphy(struct brcms_phy *pi)
 {
 	u8 tx_lpf_bw = 0;
 
@@ -18739,7 +18742,7 @@ static void wlc_phy_txlpfbw_nphy(phy_info_t *pi)
 	}
 }
 
-static void wlc_phy_spurwar_nphy(phy_info_t *pi)
+static void wlc_phy_spurwar_nphy(struct brcms_phy *pi)
 {
 	u16 cur_channel = 0;
 	int nphy_adj_tone_id_buf[] = { 57, 58 };
@@ -18911,7 +18914,7 @@ static void wlc_phy_spurwar_nphy(phy_info_t *pi)
 }
 
 static void
-wlc_phy_chanspec_nphy_setup(phy_info_t *pi, chanspec_t chanspec,
+wlc_phy_chanspec_nphy_setup(struct brcms_phy *pi, chanspec_t chanspec,
 			    const struct nphy_sfo_cfg *ci)
 {
 	u16 val;
@@ -19046,7 +19049,7 @@ wlc_phy_chanspec_nphy_setup(phy_info_t *pi, chanspec_t chanspec,
 	wlc_phy_spurwar_nphy(pi);
 }
 
-void wlc_phy_chanspec_set_nphy(phy_info_t *pi, chanspec_t chanspec)
+void wlc_phy_chanspec_set_nphy(struct brcms_phy *pi, chanspec_t chanspec)
 {
 	int freq;
 	struct chan_info_nphy_radio2057 *t0 = NULL;
@@ -19129,7 +19132,7 @@ void wlc_phy_chanspec_set_nphy(phy_info_t *pi, chanspec_t chanspec)
 
 }
 
-static void wlc_phy_savecal_nphy(phy_info_t *pi)
+static void wlc_phy_savecal_nphy(struct brcms_phy *pi)
 {
 	void *tbl_ptr;
 	int coreNum;
@@ -19278,7 +19281,7 @@ static void wlc_phy_savecal_nphy(phy_info_t *pi)
 		wlc_phy_stay_in_carriersearch_nphy(pi, false);
 }
 
-static void wlc_phy_restorecal_nphy(phy_info_t *pi)
+static void wlc_phy_restorecal_nphy(struct brcms_phy *pi)
 {
 	u16 *loft_comp;
 	u16 txcal_coeffs_bphy[4];
@@ -19479,7 +19482,7 @@ static void wlc_phy_restorecal_nphy(phy_info_t *pi)
 
 void wlc_phy_antsel_init(wlc_phy_t *ppi, bool lut_init)
 {
-	phy_info_t *pi = (phy_info_t *) ppi;
+	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 	u16 mask = 0xfc00;
 	u32 mc = 0;
 
@@ -19537,7 +19540,7 @@ void wlc_phy_antsel_init(wlc_phy_t *ppi, bool lut_init)
 	}
 }
 
-u16 wlc_phy_classifier_nphy(phy_info_t *pi, u16 mask, u16 val)
+u16 wlc_phy_classifier_nphy(struct brcms_phy *pi, u16 mask, u16 val)
 {
 	u16 curr_ctl, new_ctl;
 	bool suspended = false;
@@ -19562,7 +19565,7 @@ u16 wlc_phy_classifier_nphy(phy_info_t *pi, u16 mask, u16 val)
 	return new_ctl;
 }
 
-static void wlc_phy_clip_det_nphy(phy_info_t *pi, u8 write, u16 *vals)
+static void wlc_phy_clip_det_nphy(struct brcms_phy *pi, u8 write, u16 *vals)
 {
 
 	if (write == 0) {
@@ -19574,7 +19577,7 @@ static void wlc_phy_clip_det_nphy(phy_info_t *pi, u8 write, u16 *vals)
 	}
 }
 
-void wlc_phy_force_rfseq_nphy(phy_info_t *pi, u8 cmd)
+void wlc_phy_force_rfseq_nphy(struct brcms_phy *pi, u8 cmd)
 {
 	u16 trigger_mask, status_mask;
 	u16 orig_RfseqCoreActv;
@@ -19619,7 +19622,7 @@ void wlc_phy_force_rfseq_nphy(phy_info_t *pi, u8 cmd)
 }
 
 static void
-wlc_phy_set_rfseq_nphy(phy_info_t *pi, u8 cmd, u8 *events, u8 *dlys,
+wlc_phy_set_rfseq_nphy(struct brcms_phy *pi, u8 cmd, u8 *events, u8 *dlys,
 		       u8 len)
 {
 	u32 t1_offset, t2_offset;
@@ -19650,7 +19653,7 @@ wlc_phy_set_rfseq_nphy(phy_info_t *pi, u8 cmd, u8 *events, u8 *dlys,
 		wlc_phy_stay_in_carriersearch_nphy(pi, false);
 }
 
-static u16 wlc_phy_read_lpf_bw_ctl_nphy(phy_info_t *pi, u16 offset)
+static u16 wlc_phy_read_lpf_bw_ctl_nphy(struct brcms_phy *pi, u16 offset)
 {
 	u16 lpf_bw_ctl_val = 0;
 	u16 rx2tx_lpf_rc_lut_offset = 0;
@@ -19674,7 +19677,7 @@ static u16 wlc_phy_read_lpf_bw_ctl_nphy(phy_info_t *pi, u16 offset)
 }
 
 static void
-wlc_phy_rfctrl_override_nphy_rev7(phy_info_t *pi, u16 field, u16 value,
+wlc_phy_rfctrl_override_nphy_rev7(struct brcms_phy *pi, u16 field, u16 value,
 				  u8 core_mask, u8 off, u8 override_id)
 {
 	u8 core_num;
@@ -19944,7 +19947,7 @@ wlc_phy_rfctrl_override_nphy_rev7(phy_info_t *pi, u16 field, u16 value,
 }
 
 static void
-wlc_phy_rfctrl_override_nphy(phy_info_t *pi, u16 field, u16 value,
+wlc_phy_rfctrl_override_nphy(struct brcms_phy *pi, u16 field, u16 value,
 			     u8 core_mask, u8 off)
 {
 	u8 core_num;
@@ -20190,7 +20193,7 @@ wlc_phy_rfctrl_override_nphy(phy_info_t *pi, u16 field, u16 value,
 }
 
 static void
-wlc_phy_rfctrl_override_1tomany_nphy(phy_info_t *pi, u16 cmd, u16 value,
+wlc_phy_rfctrl_override_1tomany_nphy(struct brcms_phy *pi, u16 cmd, u16 value,
 				     u8 core_mask, u8 off)
 {
 	u16 rfmxgain = 0, lpfgain = 0;
@@ -20276,7 +20279,7 @@ wlc_phy_rfctrl_override_1tomany_nphy(phy_info_t *pi, u16 cmd, u16 value,
 }
 
 static void
-wlc_phy_scale_offset_rssi_nphy(phy_info_t *pi, u16 scale, s8 offset,
+wlc_phy_scale_offset_rssi_nphy(struct brcms_phy *pi, u16 scale, s8 offset,
 			       u8 coresel, u8 rail, u8 rssi_type)
 {
 	u16 valuetostuff;
@@ -20416,7 +20419,7 @@ wlc_phy_scale_offset_rssi_nphy(phy_info_t *pi, u16 scale, s8 offset,
 	}
 }
 
-void wlc_phy_rssisel_nphy(phy_info_t *pi, u8 core_code, u8 rssi_type)
+void wlc_phy_rssisel_nphy(struct brcms_phy *pi, u8 core_code, u8 rssi_type)
 {
 	u16 mask, val;
 	u16 afectrlovr_rssi_val, rfctrlcmd_rxen_val, rfctrlcmd_coresel_val,
@@ -20720,7 +20723,7 @@ void wlc_phy_rssisel_nphy(phy_info_t *pi, u8 core_code, u8 rssi_type)
 }
 
 int
-wlc_phy_poll_rssi_nphy(phy_info_t *pi, u8 rssi_type, s32 *rssi_buf,
+wlc_phy_poll_rssi_nphy(struct brcms_phy *pi, u8 rssi_type, s32 *rssi_buf,
 		       u8 nsamps)
 {
 	s16 rssi0, rssi1;
@@ -20819,7 +20822,7 @@ wlc_phy_poll_rssi_nphy(phy_info_t *pi, u8 rssi_type, s32 *rssi_buf,
 	return rssi_out_val;
 }
 
-s16 wlc_phy_tempsense_nphy(phy_info_t *pi)
+s16 wlc_phy_tempsense_nphy(struct brcms_phy *pi)
 {
 	u16 core1_txrf_iqcal1_save, core1_txrf_iqcal2_save;
 	u16 core2_txrf_iqcal1_save, core2_txrf_iqcal2_save;
@@ -21093,7 +21096,7 @@ s16 wlc_phy_tempsense_nphy(phy_info_t *pi)
 }
 
 static void
-wlc_phy_set_rssi_2055_vcm(phy_info_t *pi, u8 rssi_type, u8 *vcm_buf)
+wlc_phy_set_rssi_2055_vcm(struct brcms_phy *pi, u8 rssi_type, u8 *vcm_buf)
 {
 	u8 core;
 
@@ -21147,7 +21150,7 @@ wlc_phy_set_rssi_2055_vcm(phy_info_t *pi, u8 rssi_type, u8 *vcm_buf)
 	}
 }
 
-void wlc_phy_rssi_cal_nphy(phy_info_t *pi)
+void wlc_phy_rssi_cal_nphy(struct brcms_phy *pi)
 {
 	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
 
@@ -21159,7 +21162,7 @@ void wlc_phy_rssi_cal_nphy(phy_info_t *pi)
 	}
 }
 
-static void wlc_phy_rssi_cal_nphy_rev2(phy_info_t *pi, u8 rssi_type)
+static void wlc_phy_rssi_cal_nphy_rev2(struct brcms_phy *pi, u8 rssi_type)
 {
 	s32 target_code;
 	u16 classif_state;
@@ -21367,7 +21370,7 @@ static void wlc_phy_rssi_cal_nphy_rev2(phy_info_t *pi, u8 rssi_type)
 }
 
 int
-wlc_phy_rssi_compute_nphy(phy_info_t *pi, struct brcms_d11rxhdr *wlc_rxh)
+wlc_phy_rssi_compute_nphy(struct brcms_phy *pi, struct brcms_d11rxhdr *wlc_rxh)
 {
 	struct d11rxhdr *rxh = &wlc_rxh->rxhdr;
 	s16 rxpwr, rxpwr0, rxpwr1;
@@ -21407,7 +21410,7 @@ wlc_phy_rssi_compute_nphy(phy_info_t *pi, struct brcms_d11rxhdr *wlc_rxh)
 }
 
 static void
-wlc_phy_rfctrlintc_override_nphy(phy_info_t *pi, u8 field, u16 value,
+wlc_phy_rfctrlintc_override_nphy(struct brcms_phy *pi, u8 field, u16 value,
 				 u8 core_code)
 {
 	u16 mask;
@@ -21642,7 +21645,7 @@ wlc_phy_rfctrlintc_override_nphy(phy_info_t *pi, u8 field, u16 value,
 	}
 }
 
-static void wlc_phy_rssi_cal_nphy_rev3(phy_info_t *pi)
+static void wlc_phy_rssi_cal_nphy_rev3(struct brcms_phy *pi)
 {
 	u16 classif_state;
 	u16 clip_state[2];
@@ -22129,7 +22132,7 @@ static void wlc_phy_rssi_cal_nphy_rev3(phy_info_t *pi)
 	wlc_phy_clip_det_nphy(pi, 1, clip_state);
 }
 
-static void wlc_phy_restore_rssical_nphy(phy_info_t *pi)
+static void wlc_phy_restore_rssical_nphy(struct brcms_phy *pi)
 {
 	if (CHSPEC_IS2G(pi->radio_chanspec)) {
 		if (pi->nphy_rssical_chanspec_2G == 0)
@@ -22236,7 +22239,7 @@ static void wlc_phy_restore_rssical_nphy(phy_info_t *pi)
 }
 
 static u16
-wlc_phy_gen_load_samples_nphy(phy_info_t *pi, u32 f_kHz, u16 max_val,
+wlc_phy_gen_load_samples_nphy(struct brcms_phy *pi, u32 f_kHz, u16 max_val,
 			      u8 dac_test_mode)
 {
 	u8 phy_bw, is_phybw40;
@@ -22285,7 +22288,7 @@ wlc_phy_gen_load_samples_nphy(phy_info_t *pi, u32 f_kHz, u16 max_val,
 }
 
 int
-wlc_phy_tx_tone_nphy(phy_info_t *pi, u32 f_kHz, u16 max_val,
+wlc_phy_tx_tone_nphy(struct brcms_phy *pi, u32 f_kHz, u16 max_val,
 		     u8 iqmode, u8 dac_test_mode, bool modify_bbmult)
 {
 	u16 num_samps;
@@ -22305,7 +22308,7 @@ wlc_phy_tx_tone_nphy(phy_info_t *pi, u32 f_kHz, u16 max_val,
 }
 
 static void
-wlc_phy_loadsampletable_nphy(phy_info_t *pi, cs32 *tone_buf,
+wlc_phy_loadsampletable_nphy(struct brcms_phy *pi, cs32 *tone_buf,
 			     u16 num_samps)
 {
 	u16 t;
@@ -22333,7 +22336,7 @@ wlc_phy_loadsampletable_nphy(phy_info_t *pi, cs32 *tone_buf,
 }
 
 static void
-wlc_phy_runsamples_nphy(phy_info_t *pi, u16 num_samps, u16 loops,
+wlc_phy_runsamples_nphy(struct brcms_phy *pi, u16 num_samps, u16 loops,
 			u16 wait, u8 iqmode, u8 dac_test_mode,
 			bool modify_bbmult)
 {
@@ -22420,7 +22423,7 @@ wlc_phy_runsamples_nphy(phy_info_t *pi, u16 num_samps, u16 loops,
 	write_phy_reg(pi, 0xa1, orig_RfseqCoreActv);
 }
 
-void wlc_phy_stopplayback_nphy(phy_info_t *pi)
+void wlc_phy_stopplayback_nphy(struct brcms_phy *pi)
 {
 	u16 playback_status;
 	u16 bb_mult;
@@ -22462,7 +22465,7 @@ void wlc_phy_stopplayback_nphy(phy_info_t *pi)
 		wlc_phy_stay_in_carriersearch_nphy(pi, false);
 }
 
-struct nphy_txgains wlc_phy_get_tx_gain_nphy(phy_info_t *pi)
+struct nphy_txgains wlc_phy_get_tx_gain_nphy(struct brcms_phy *pi)
 {
 	u16 base_idx[2], curr_gain[2];
 	u8 core_no;
@@ -22620,7 +22623,7 @@ struct nphy_txgains wlc_phy_get_tx_gain_nphy(phy_info_t *pi)
 }
 
 static void
-wlc_phy_iqcal_gainparams_nphy(phy_info_t *pi, u16 core_no,
+wlc_phy_iqcal_gainparams_nphy(struct brcms_phy *pi, u16 core_no,
 			      struct nphy_txgains target_gain,
 			      struct nphy_iqcal_params *params)
 {
@@ -22683,7 +22686,7 @@ wlc_phy_iqcal_gainparams_nphy(phy_info_t *pi, u16 core_no,
 	}
 }
 
-static void wlc_phy_txcal_radio_setup_nphy(phy_info_t *pi)
+static void wlc_phy_txcal_radio_setup_nphy(struct brcms_phy *pi)
 {
 	u16 jtag_core, core;
 
@@ -22993,7 +22996,7 @@ static void wlc_phy_txcal_radio_setup_nphy(phy_info_t *pi)
 	}
 }
 
-static void wlc_phy_txcal_radio_cleanup_nphy(phy_info_t *pi)
+static void wlc_phy_txcal_radio_cleanup_nphy(struct brcms_phy *pi)
 {
 	u16 jtag_core, core;
 
@@ -23131,7 +23134,7 @@ static void wlc_phy_txcal_radio_cleanup_nphy(phy_info_t *pi)
 	}
 }
 
-static void wlc_phy_txcal_physetup_nphy(phy_info_t *pi)
+static void wlc_phy_txcal_physetup_nphy(struct brcms_phy *pi)
 {
 	u16 val, mask;
 
@@ -23283,7 +23286,7 @@ static void wlc_phy_txcal_physetup_nphy(phy_info_t *pi)
 	}
 }
 
-static void wlc_phy_txcal_phycleanup_nphy(phy_info_t *pi)
+static void wlc_phy_txcal_phycleanup_nphy(struct brcms_phy *pi)
 {
 	u16 mask;
 
@@ -23365,7 +23368,7 @@ static void wlc_phy_txcal_phycleanup_nphy(phy_info_t *pi)
 #define NPHY_TEST_TONE_FREQ_20MHz 2500
 
 void
-wlc_phy_est_tonepwr_nphy(phy_info_t *pi, s32 *qdBm_pwrbuf, u8 num_samps)
+wlc_phy_est_tonepwr_nphy(struct brcms_phy *pi, s32 *qdBm_pwrbuf, u8 num_samps)
 {
 	u16 tssi_reg;
 	s32 temp, pwrindex[2];
@@ -23412,7 +23415,7 @@ wlc_phy_est_tonepwr_nphy(phy_info_t *pi, s32 *qdBm_pwrbuf, u8 num_samps)
 				(u32) pwrindex[1], 32, &qdBm_pwrbuf[1]);
 }
 
-static void wlc_phy_internal_cal_txgain_nphy(phy_info_t *pi)
+static void wlc_phy_internal_cal_txgain_nphy(struct brcms_phy *pi)
 {
 	u16 txcal_gain[2];
 
@@ -23436,7 +23439,7 @@ static void wlc_phy_internal_cal_txgain_nphy(phy_info_t *pi)
 				 txcal_gain);
 }
 
-static void wlc_phy_precal_txgain_nphy(phy_info_t *pi)
+static void wlc_phy_precal_txgain_nphy(struct brcms_phy *pi)
 {
 	bool save_bbmult = false;
 	u8 txcal_index_2057_rev5n7 = 0;
@@ -23524,7 +23527,8 @@ static void wlc_phy_precal_txgain_nphy(phy_info_t *pi)
 }
 
 void
-wlc_phy_cal_txgainctrl_nphy(phy_info_t *pi, s32 dBm_targetpower, bool debug)
+wlc_phy_cal_txgainctrl_nphy(struct brcms_phy *pi, s32 dBm_targetpower,
+			    bool debug)
 {
 	int gainctrl_loopidx;
 	uint core;
@@ -23691,7 +23695,7 @@ wlc_phy_cal_txgainctrl_nphy(phy_info_t *pi, s32 dBm_targetpower, bool debug)
 		wlc_phy_stay_in_carriersearch_nphy(pi, false);
 }
 
-static void wlc_phy_update_txcal_ladder_nphy(phy_info_t *pi, u16 core)
+static void wlc_phy_update_txcal_ladder_nphy(struct brcms_phy *pi, u16 core)
 {
 	int index;
 	u32 bbmult_scale;
@@ -23733,7 +23737,7 @@ static void wlc_phy_update_txcal_ladder_nphy(phy_info_t *pi, u16 core)
 	}
 }
 
-void wlc_phy_cal_perical_nphy_run(phy_info_t *pi, u8 caltype)
+void wlc_phy_cal_perical_nphy_run(struct brcms_phy *pi, u8 caltype)
 {
 	struct nphy_txgains target_gain;
 	u8 tx_pwr_ctrl_state;
@@ -23985,7 +23989,7 @@ void wlc_phy_cal_perical_nphy_run(phy_info_t *pi, u8 caltype)
 }
 
 int
-wlc_phy_cal_txiqlo_nphy(phy_info_t *pi, struct nphy_txgains target_gain,
+wlc_phy_cal_txiqlo_nphy(struct brcms_phy *pi, struct nphy_txgains target_gain,
 			bool fullcal, bool mphase)
 {
 	u16 val;
@@ -24355,7 +24359,7 @@ wlc_phy_cal_txiqlo_nphy(phy_info_t *pi, struct nphy_txgains target_gain,
 	return bcmerror;
 }
 
-static void wlc_phy_reapply_txcal_coeffs_nphy(phy_info_t *pi)
+static void wlc_phy_reapply_txcal_coeffs_nphy(struct brcms_phy *pi)
 {
 	u16 tbl_buf[7];
 
@@ -24390,7 +24394,7 @@ static void wlc_phy_reapply_txcal_coeffs_nphy(phy_info_t *pi)
 	}
 }
 
-static void wlc_phy_tx_iq_war_nphy(phy_info_t *pi)
+static void wlc_phy_tx_iq_war_nphy(struct brcms_phy *pi)
 {
 	struct nphy_iq_comp tx_comp;
 
@@ -24403,7 +24407,8 @@ static void wlc_phy_tx_iq_war_nphy(phy_info_t *pi)
 }
 
 void
-wlc_phy_rx_iq_coeffs_nphy(phy_info_t *pi, u8 write, struct nphy_iq_comp *pcomp)
+wlc_phy_rx_iq_coeffs_nphy(struct brcms_phy *pi, u8 write,
+			  struct nphy_iq_comp *pcomp)
 {
 	if (write) {
 		write_phy_reg(pi, 0x9a, pcomp->a0);
@@ -24419,8 +24424,8 @@ wlc_phy_rx_iq_coeffs_nphy(phy_info_t *pi, u8 write, struct nphy_iq_comp *pcomp)
 }
 
 void
-wlc_phy_rx_iq_est_nphy(phy_info_t *pi, struct phy_iq_est *est, u16 num_samps,
-		       u8 wait_time, u8 wait_for_crs)
+wlc_phy_rx_iq_est_nphy(struct brcms_phy *pi, struct phy_iq_est *est,
+		       u16 num_samps, u8 wait_time, u8 wait_for_crs)
 {
 	u8 core;
 
@@ -24453,7 +24458,7 @@ wlc_phy_rx_iq_est_nphy(phy_info_t *pi, struct phy_iq_est *est, u16 num_samps,
 }
 
 #define CAL_RETRY_CNT 2
-static void wlc_phy_calc_rx_iq_comp_nphy(phy_info_t *pi, u8 core_mask)
+static void wlc_phy_calc_rx_iq_comp_nphy(struct brcms_phy *pi, u8 core_mask)
 {
 	u8 curr_core;
 	struct phy_iq_est est[PHY_CORE_MAX];
@@ -24577,7 +24582,7 @@ static void wlc_phy_calc_rx_iq_comp_nphy(phy_info_t *pi, u8 core_mask)
 	wlc_phy_rx_iq_coeffs_nphy(pi, 1, &new_comp);
 }
 
-static void wlc_phy_rxcal_radio_setup_nphy(phy_info_t *pi, u8 rx_core)
+static void wlc_phy_rxcal_radio_setup_nphy(struct brcms_phy *pi, u8 rx_core)
 {
 	u16 offtune_val;
 	u16 bias_g = 0;
@@ -24874,7 +24879,7 @@ static void wlc_phy_rxcal_radio_setup_nphy(phy_info_t *pi, u8 rx_core)
 	}
 }
 
-static void wlc_phy_rxcal_radio_cleanup_nphy(phy_info_t *pi, u8 rx_core)
+static void wlc_phy_rxcal_radio_cleanup_nphy(struct brcms_phy *pi, u8 rx_core)
 {
 	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 		if (rx_core == PHY_CORE_0) {
@@ -25044,7 +25049,7 @@ static void wlc_phy_rxcal_radio_cleanup_nphy(phy_info_t *pi, u8 rx_core)
 	}
 }
 
-static void wlc_phy_rxcal_physetup_nphy(phy_info_t *pi, u8 rx_core)
+static void wlc_phy_rxcal_physetup_nphy(struct brcms_phy *pi, u8 rx_core)
 {
 	u8 tx_core;
 	u16 rx_antval, tx_antval;
@@ -25171,7 +25176,7 @@ static void wlc_phy_rxcal_physetup_nphy(phy_info_t *pi, u8 rx_core)
 	}
 }
 
-static void wlc_phy_rxcal_phycleanup_nphy(phy_info_t *pi, u8 rx_core)
+static void wlc_phy_rxcal_phycleanup_nphy(struct brcms_phy *pi, u8 rx_core)
 {
 
 	write_phy_reg(pi, 0xa2, pi->tx_rx_cal_phy_saveregs[0]);
@@ -25198,7 +25203,7 @@ static void wlc_phy_rxcal_phycleanup_nphy(phy_info_t *pi, u8 rx_core)
 }
 
 static void
-wlc_phy_rxcal_gainctrl_nphy_rev5(phy_info_t *pi, u8 rx_core,
+wlc_phy_rxcal_gainctrl_nphy_rev5(struct brcms_phy *pi, u8 rx_core,
 				 u16 *rxgain, u8 cal_type)
 {
 
@@ -25406,14 +25411,14 @@ wlc_phy_rxcal_gainctrl_nphy_rev5(phy_info_t *pi, u8 rx_core,
 }
 
 static void
-wlc_phy_rxcal_gainctrl_nphy(phy_info_t *pi, u8 rx_core, u16 *rxgain,
+wlc_phy_rxcal_gainctrl_nphy(struct brcms_phy *pi, u8 rx_core, u16 *rxgain,
 			    u8 cal_type)
 {
 	wlc_phy_rxcal_gainctrl_nphy_rev5(pi, rx_core, rxgain, cal_type);
 }
 
 static u8
-wlc_phy_rc_sweep_nphy(phy_info_t *pi, u8 core_idx, u8 loopback_type)
+wlc_phy_rc_sweep_nphy(struct brcms_phy *pi, u8 core_idx, u8 loopback_type)
 {
 	u32 target_bws[2] = { 9500, 21000 };
 	u32 ref_tones[2] = { 3000, 6000 };
@@ -25653,9 +25658,9 @@ wlc_phy_rc_sweep_nphy(phy_info_t *pi, u8 core_idx, u8 loopback_type)
 }
 
 #define WAIT_FOR_SCOPE	4000
-static int
-wlc_phy_cal_rxiq_nphy_rev3(phy_info_t *pi, struct nphy_txgains target_gain,
-			   u8 cal_type, bool debug)
+static int wlc_phy_cal_rxiq_nphy_rev3(struct brcms_phy *pi,
+				      struct nphy_txgains target_gain,
+				      u8 cal_type, bool debug)
 {
 	u16 orig_BBConfig;
 	u8 core_no, rx_core;
@@ -25811,8 +25816,8 @@ wlc_phy_cal_rxiq_nphy_rev3(phy_info_t *pi, struct nphy_txgains target_gain,
 }
 
 static int
-wlc_phy_cal_rxiq_nphy_rev2(phy_info_t *pi, struct nphy_txgains target_gain,
-			   bool debug)
+wlc_phy_cal_rxiq_nphy_rev2(struct brcms_phy *pi,
+			   struct nphy_txgains target_gain, bool debug)
 {
 	struct phy_iq_est est[PHY_CORE_MAX];
 	u8 core_num, rx_core, tx_core;
@@ -26037,7 +26042,7 @@ wlc_phy_cal_rxiq_nphy_rev2(phy_info_t *pi, struct nphy_txgains target_gain,
 }
 
 int
-wlc_phy_cal_rxiq_nphy(phy_info_t *pi, struct nphy_txgains target_gain,
+wlc_phy_cal_rxiq_nphy(struct brcms_phy *pi, struct nphy_txgains target_gain,
 		      u8 cal_type, bool debug)
 {
 	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
@@ -26052,7 +26057,7 @@ wlc_phy_cal_rxiq_nphy(phy_info_t *pi, struct nphy_txgains target_gain,
 	}
 }
 
-static void wlc_phy_extpa_set_tx_digi_filts_nphy(phy_info_t *pi)
+static void wlc_phy_extpa_set_tx_digi_filts_nphy(struct brcms_phy *pi)
 {
 	int j, type = 2;
 	u16 addr_offset = 0x2c5;
@@ -26063,7 +26068,7 @@ static void wlc_phy_extpa_set_tx_digi_filts_nphy(phy_info_t *pi)
 	}
 }
 
-static void wlc_phy_ipa_set_tx_digi_filts_nphy(phy_info_t *pi)
+static void wlc_phy_ipa_set_tx_digi_filts_nphy(struct brcms_phy *pi)
 {
 	int j, type;
 	u16 addr_offset[] = { 0x186, 0x195,
@@ -26101,7 +26106,7 @@ static void wlc_phy_ipa_set_tx_digi_filts_nphy(phy_info_t *pi)
 	}
 }
 
-static void wlc_phy_ipa_restore_tx_digi_filts_nphy(phy_info_t *pi)
+static void wlc_phy_ipa_restore_tx_digi_filts_nphy(struct brcms_phy *pi)
 {
 	int j;
 
@@ -26118,7 +26123,7 @@ static void wlc_phy_ipa_restore_tx_digi_filts_nphy(phy_info_t *pi)
 	}
 }
 
-static u16 wlc_phy_ipa_get_bbmult_nphy(phy_info_t *pi)
+static u16 wlc_phy_ipa_get_bbmult_nphy(struct brcms_phy *pi)
 {
 	u16 m0m1;
 
@@ -26127,7 +26132,7 @@ static u16 wlc_phy_ipa_get_bbmult_nphy(phy_info_t *pi)
 	return m0m1;
 }
 
-static void wlc_phy_ipa_set_bbmult_nphy(phy_info_t *pi, u8 m0, u8 m1)
+static void wlc_phy_ipa_set_bbmult_nphy(struct brcms_phy *pi, u8 m0, u8 m1)
 {
 	u16 m0m1 = (u16) ((m0 << 8) | m1);
 
@@ -26135,7 +26140,7 @@ static void wlc_phy_ipa_set_bbmult_nphy(phy_info_t *pi, u8 m0, u8 m1)
 	wlc_phy_table_write_nphy(pi, 15, 1, 95, 16, &m0m1);
 }
 
-static u32 *wlc_phy_get_ipa_gaintbl_nphy(phy_info_t *pi)
+static u32 *wlc_phy_get_ipa_gaintbl_nphy(struct brcms_phy *pi)
 {
 	u32 *tx_pwrctrl_tbl = NULL;
 
@@ -26198,7 +26203,7 @@ static u32 *wlc_phy_get_ipa_gaintbl_nphy(phy_info_t *pi)
 }
 
 static void
-wlc_phy_papd_cal_setup_nphy(phy_info_t *pi,
+wlc_phy_papd_cal_setup_nphy(struct brcms_phy *pi,
 			    struct nphy_papd_restore_state *state, u8 core)
 {
 	s32 tone_freq;
@@ -26468,7 +26473,7 @@ wlc_phy_papd_cal_setup_nphy(phy_info_t *pi,
 }
 
 static void
-wlc_phy_papd_cal_cleanup_nphy(phy_info_t *pi,
+wlc_phy_papd_cal_cleanup_nphy(struct brcms_phy *pi,
 			      struct nphy_papd_restore_state *state)
 {
 	u8 core;
@@ -26595,7 +26600,7 @@ wlc_phy_papd_cal_cleanup_nphy(phy_info_t *pi,
 }
 
 static void
-wlc_phy_a1_nphy(phy_info_t *pi, u8 core, u32 winsz, u32 start,
+wlc_phy_a1_nphy(struct brcms_phy *pi, u8 core, u32 winsz, u32 start,
 		u32 end)
 {
 	u32 *buf, *src, *dst, sz;
@@ -26647,7 +26652,7 @@ wlc_phy_a1_nphy(phy_info_t *pi, u8 core, u32 winsz, u32 start,
 }
 
 static void
-wlc_phy_a2_nphy(phy_info_t *pi, struct nphy_ipa_txcalgains *txgains,
+wlc_phy_a2_nphy(struct brcms_phy *pi, struct nphy_ipa_txcalgains *txgains,
 		enum phy_cal_mode cal_mode, u8 core)
 {
 	u16 phy_a1, phy_a2, phy_a3;
@@ -26936,7 +26941,7 @@ wlc_phy_a2_nphy(phy_info_t *pi, struct nphy_ipa_txcalgains *txgains,
 	}
 }
 
-static u8 wlc_phy_a3_nphy(phy_info_t *pi, u8 start_gain, u8 core)
+static u8 wlc_phy_a3_nphy(struct brcms_phy *pi, u8 start_gain, u8 core)
 {
 	int phy_a1;
 	int phy_a2;
@@ -27097,7 +27102,7 @@ static u8 wlc_phy_a3_nphy(phy_info_t *pi, u8 start_gain, u8 core)
 
 }
 
-static void wlc_phy_a4(phy_info_t *pi, bool full_cal)
+static void wlc_phy_a4(struct brcms_phy *pi, bool full_cal)
 {
 	struct nphy_ipa_txcalgains phy_b1[2];
 	struct nphy_papd_restore_state phy_b2;
@@ -27386,7 +27391,7 @@ static void wlc_phy_a4(phy_info_t *pi, bool full_cal)
 	}
 }
 
-void wlc_phy_txpwr_fixpower_nphy(phy_info_t *pi)
+void wlc_phy_txpwr_fixpower_nphy(struct brcms_phy *pi)
 {
 	uint core;
 	u32 txgain;
@@ -27598,7 +27603,7 @@ wlc_phy_mcs_to_ofdm_powers_nphy(u8 *power, u8 rate_ofdm_start,
 	}
 }
 
-void wlc_phy_txpwr_apply_nphy(phy_info_t *pi)
+void wlc_phy_txpwr_apply_nphy(struct brcms_phy *pi)
 {
 	uint rate1, rate2, band_num;
 	u8 tmp_bw40po = 0, tmp_cddpo = 0, tmp_stbcpo = 0;
@@ -27796,7 +27801,7 @@ void wlc_phy_txpwr_apply_nphy(phy_info_t *pi)
 	return;
 }
 
-static void wlc_phy_txpwr_srom_read_ppr_nphy(phy_info_t *pi)
+static void wlc_phy_txpwr_srom_read_ppr_nphy(struct brcms_phy *pi)
 {
 	u16 bw40po, cddpo, stbcpo, bwduppo;
 	uint band_num;
@@ -28004,7 +28009,7 @@ static void wlc_phy_txpwr_srom_read_ppr_nphy(phy_info_t *pi)
 	wlc_phy_txpwr_apply_nphy(pi);
 }
 
-static bool wlc_phy_txpwr_srom_read_nphy(phy_info_t *pi)
+static bool wlc_phy_txpwr_srom_read_nphy(struct brcms_phy *pi)
 {
 
 	pi->antswitch = (u8) PHY_GETINTVAR(pi, "antswitch");
@@ -28064,7 +28069,7 @@ static bool wlc_phy_txpwr_srom_read_nphy(phy_info_t *pi)
 	return true;
 }
 
-void wlc_phy_txpower_recalc_target_nphy(phy_info_t *pi)
+void wlc_phy_txpower_recalc_target_nphy(struct brcms_phy *pi)
 {
 	u8 tx_pwr_ctrl_state;
 	wlc_phy_txpwr_limit_to_tbl_nphy(pi);
@@ -28084,7 +28089,7 @@ void wlc_phy_txpower_recalc_target_nphy(phy_info_t *pi)
 		wlapi_bmac_mctrl(pi->sh->physhim, MCTL_PHYLOCK, 0);
 }
 
-static void wlc_phy_txpwrctrl_coeff_setup_nphy(phy_info_t *pi)
+static void wlc_phy_txpwrctrl_coeff_setup_nphy(struct brcms_phy *pi)
 {
 	u32 idx;
 	u16 iqloCalbuf[7];
@@ -28155,7 +28160,7 @@ static void wlc_phy_txpwrctrl_coeff_setup_nphy(phy_info_t *pi)
 		wlc_phy_stay_in_carriersearch_nphy(pi, false);
 }
 
-static void wlc_phy_ipa_internal_tssi_setup_nphy(phy_info_t *pi)
+static void wlc_phy_ipa_internal_tssi_setup_nphy(struct brcms_phy *pi)
 {
 	u8 core;
 
@@ -28265,7 +28270,7 @@ static void wlc_phy_ipa_internal_tssi_setup_nphy(phy_info_t *pi)
 	}
 }
 
-static void wlc_phy_txpwrctrl_idle_tssi_nphy(phy_info_t *pi)
+static void wlc_phy_txpwrctrl_idle_tssi_nphy(struct brcms_phy *pi)
 {
 	s32 rssi_buf[4];
 	s32 int_val;
@@ -28331,7 +28336,7 @@ static void wlc_phy_txpwrctrl_idle_tssi_nphy(phy_info_t *pi)
 
 }
 
-static void wlc_phy_txpwrctrl_pwr_setup_nphy(phy_info_t *pi)
+static void wlc_phy_txpwrctrl_pwr_setup_nphy(struct brcms_phy *pi)
 {
 	u32 idx;
 	s16 a1[2], b0[2], b1[2];
@@ -28568,13 +28573,13 @@ static void wlc_phy_txpwrctrl_pwr_setup_nphy(phy_info_t *pi)
 		wlc_phy_stay_in_carriersearch_nphy(pi, false);
 }
 
-static bool wlc_phy_txpwr_ison_nphy(phy_info_t *pi)
+static bool wlc_phy_txpwr_ison_nphy(struct brcms_phy *pi)
 {
 	return read_phy_reg((pi), 0x1e7) & ((0x1 << 15) |
 					     (0x1 << 14) | (0x1 << 13));
 }
 
-static u8 wlc_phy_txpwr_idx_cur_get_nphy(phy_info_t *pi, u8 core)
+static u8 wlc_phy_txpwr_idx_cur_get_nphy(struct brcms_phy *pi, u8 core)
 {
 	u16 tmp;
 	tmp = read_phy_reg(pi, ((core == PHY_CORE_0) ? 0x1ed : 0x1ee));
@@ -28584,7 +28589,7 @@ static u8 wlc_phy_txpwr_idx_cur_get_nphy(phy_info_t *pi, u8 core)
 }
 
 static void
-wlc_phy_txpwr_idx_cur_set_nphy(phy_info_t *pi, u8 idx0, u8 idx1)
+wlc_phy_txpwr_idx_cur_set_nphy(struct brcms_phy *pi, u8 idx0, u8 idx1)
 {
 	mod_phy_reg(pi, 0x1e7, (0x7f << 0), idx0);
 
@@ -28592,7 +28597,7 @@ wlc_phy_txpwr_idx_cur_set_nphy(phy_info_t *pi, u8 idx0, u8 idx1)
 		mod_phy_reg(pi, 0x222, (0xff << 0), idx1);
 }
 
-u16 wlc_phy_txpwr_idx_get_nphy(phy_info_t *pi)
+u16 wlc_phy_txpwr_idx_get_nphy(struct brcms_phy *pi)
 {
 	u16 tmp;
 	u16 pwr_idx[2];
@@ -28614,7 +28619,7 @@ u16 wlc_phy_txpwr_idx_get_nphy(phy_info_t *pi)
 	return tmp;
 }
 
-void wlc_phy_txpwr_papd_cal_nphy(phy_info_t *pi)
+void wlc_phy_txpwr_papd_cal_nphy(struct brcms_phy *pi)
 {
 	if (PHY_IPA(pi)
 	    && (pi->nphy_force_papd_cal
@@ -28630,7 +28635,7 @@ void wlc_phy_txpwr_papd_cal_nphy(phy_info_t *pi)
 	}
 }
 
-void wlc_phy_txpwrctrl_enable_nphy(phy_info_t *pi, u8 ctrl_type)
+void wlc_phy_txpwrctrl_enable_nphy(struct brcms_phy *pi, u8 ctrl_type)
 {
 	u16 mask = 0, val = 0, ishw = 0;
 	u8 ctr;
@@ -28776,7 +28781,7 @@ void wlc_phy_txpwrctrl_enable_nphy(phy_info_t *pi, u8 ctrl_type)
 }
 
 void
-wlc_phy_txpwr_index_nphy(phy_info_t *pi, u8 core_mask, s8 txpwrindex,
+wlc_phy_txpwr_index_nphy(struct brcms_phy *pi, u8 core_mask, s8 txpwrindex,
 			 bool restore_cals)
 {
 	u8 core, txpwrctl_tbl;
@@ -29015,7 +29020,7 @@ wlc_phy_txpwr_index_nphy(phy_info_t *pi, u8 core_mask, s8 txpwrindex,
 }
 
 void
-wlc_phy_txpower_sromlimit_get_nphy(phy_info_t *pi, uint chan, u8 *max_pwr,
+wlc_phy_txpower_sromlimit_get_nphy(struct brcms_phy *pi, uint chan, u8 *max_pwr,
 				   u8 txp_rate_idx)
 {
 	u8 chan_freq_range;
@@ -29042,7 +29047,7 @@ wlc_phy_txpower_sromlimit_get_nphy(phy_info_t *pi, uint chan, u8 *max_pwr,
 	return;
 }
 
-void wlc_phy_stay_in_carriersearch_nphy(phy_info_t *pi, bool enable)
+void wlc_phy_stay_in_carriersearch_nphy(struct brcms_phy *pi, bool enable)
 {
 	u16 clip_off[] = { 0xffff, 0xffff };
 
@@ -29070,7 +29075,7 @@ void wlc_phy_stay_in_carriersearch_nphy(phy_info_t *pi, bool enable)
 	}
 }
 
-void wlc_nphy_deaf_mode(phy_info_t *pi, bool mode)
+void wlc_nphy_deaf_mode(struct brcms_phy *pi, bool mode)
 {
 	wlapi_suspend_mac_and_wait(pi->sh->physhim);
 
diff --git a/drivers/staging/brcm80211/brcmsmac/types.h b/drivers/staging/brcm80211/brcmsmac/types.h
index 9ab7fe2..32eb429 100644
--- a/drivers/staging/brcm80211/brcmsmac/types.h
+++ b/drivers/staging/brcm80211/brcmsmac/types.h
@@ -370,6 +370,7 @@ struct tx_status;
 struct d11rxhdr;
 struct brcms_d11rxhdr;
 struct txpwr_limits;
+struct brcms_phy;
 
 typedef volatile struct intctrlregs intctrlregs_t;
 typedef volatile struct pio2regs pio2regs_t;
@@ -385,7 +386,6 @@ typedef u32 ratespec_t;
 typedef struct tx_power tx_power_t;
 typedef struct chanvec chanvec_t;
 typedef struct phy_pub wlc_phy_t;
-typedef struct phy_info phy_info_t;
 typedef s32 fixed;
 typedef struct _cs32 cs32;
 typedef volatile union pmqreg pmqreg_t;
-- 
1.7.4.1


