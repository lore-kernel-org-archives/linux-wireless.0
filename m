Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4822 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755196Ab1HZNT6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 09:19:58 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 13/13] staging: brcm80211: got rid of static function
 declarations in softmac phy
Date: Fri, 26 Aug 2011 15:19:40 +0200
Message-ID: <1314364780-9462-14-git-send-email-rvossen@broadcom.com> (sfid-20110826_152036_868080_F3CEDC12)
In-Reply-To: <1314364780-9462-1-git-send-email-rvossen@broadcom.com>
References: <1314364780-9462-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. Reshuffled functions so that the declarations were not necessary
anymore.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |  402 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c | 5650 +++---
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c   |22588 +++++++++++-----------
 3 files changed, 14218 insertions(+), 14422 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index bd602de..3955d6e 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -119,32 +119,6 @@ const u8 ofdm_rate_lookup[] = {
 
 #define PHY_WREG_LIMIT  24
 
-static void wlc_set_phy_uninitted(struct brcms_phy *pi);
-static u32 wlc_phy_get_radio_ver(struct brcms_phy *pi);
-static void wlc_phy_timercb_phycal(struct brcms_phy *pi);
-
-static bool wlc_phy_noise_calc_phy(struct brcms_phy *pi, u32 *cmplx_pwr,
-				   s8 *pwr_ant);
-
-static void wlc_phy_cal_perical_mphase_schedule(struct brcms_phy *pi,
-						uint delay);
-
-static void wlc_phy_noise_cb(struct brcms_phy *pi, u8 channel, s8 noise_dbm);
-static void wlc_phy_noise_sample_request(struct brcms_phy_pub *pih, u8 reason,
-					 u8 ch);
-
-static void wlc_phy_txpower_reg_limit_calc(struct brcms_phy *pi,
-					   struct txpwr_limits *tp,
-					   u16 chanspec);
-
-static bool wlc_phy_cal_txpower_recalc_sw(struct brcms_phy *pi);
-
-static s8 wlc_user_txpwr_antport_to_rfport(struct brcms_phy *pi, uint chan,
-					   u32 band, u8 rate);
-static void wlc_phy_upd_env_txpwr_rate_limits(struct brcms_phy *pi, u32 band);
-static s8 wlc_phy_env_measure_vbat(struct brcms_phy *pi);
-static s8 wlc_phy_env_measure_temperature(struct brcms_phy *pi);
-
 char *phy_getvar(struct brcms_phy *pi, const char *name)
 {
 	char *vars = pi->vars;
@@ -480,6 +454,37 @@ struct shared_phy *wlc_phy_shared_attach(struct shared_phy_params *shp)
 	return sh;
 }
 
+static void wlc_phy_timercb_phycal(struct brcms_phy *pi)
+{
+	uint delay = 5;
+
+	if (PHY_PERICAL_MPHASE_PENDING(pi)) {
+		if (!pi->sh->up) {
+			wlc_phy_cal_perical_mphase_reset(pi);
+			return;
+		}
+
+		if (SCAN_RM_IN_PROGRESS(pi) || PLT_INPROG_PHY(pi)) {
+
+			delay = 1000;
+			wlc_phy_cal_perical_mphase_restart(pi);
+		} else
+			wlc_phy_cal_perical_nphy_run(pi, PHY_PERICAL_AUTO);
+		wlapi_add_timer(pi->sh->physhim, pi->phycal_timer, delay, 0);
+		return;
+	}
+
+}
+
+static u32 wlc_phy_get_radio_ver(struct brcms_phy *pi)
+{
+	u32 ver;
+
+	ver = read_radio_id(pi);
+
+	return ver;
+}
+
 struct brcms_phy_pub *
 wlc_phy_attach(struct shared_phy *sh, struct d11regs *regs, int bandtype,
 	       char *vars, struct wiphy *wiphy)
@@ -692,28 +697,6 @@ u32 wlc_phy_get_coreflags(struct brcms_phy_pub *pih)
 	return pi->pubpi.coreflags;
 }
 
-static void wlc_phy_timercb_phycal(struct brcms_phy *pi)
-{
-	uint delay = 5;
-
-	if (PHY_PERICAL_MPHASE_PENDING(pi)) {
-		if (!pi->sh->up) {
-			wlc_phy_cal_perical_mphase_reset(pi);
-			return;
-		}
-
-		if (SCAN_RM_IN_PROGRESS(pi) || PLT_INPROG_PHY(pi)) {
-
-			delay = 1000;
-			wlc_phy_cal_perical_mphase_restart(pi);
-		} else
-			wlc_phy_cal_perical_nphy_run(pi, PHY_PERICAL_AUTO);
-		wlapi_add_timer(pi->sh->physhim, pi->phycal_timer, delay, 0);
-		return;
-	}
-
-}
-
 void wlc_phy_anacore(struct brcms_phy_pub *pih, bool on)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
@@ -909,15 +892,6 @@ int wlc_phy_down(struct brcms_phy_pub *pih)
 	return callbacks;
 }
 
-static u32 wlc_phy_get_radio_ver(struct brcms_phy *pi)
-{
-	u32 ver;
-
-	ver = read_radio_id(pi);
-
-	return ver;
-}
-
 void
 wlc_phy_table_addr(struct brcms_phy *pi, uint tbl_id, uint tbl_offset,
 		   u16 tblAddr, u16 tblDataHi, u16 tblDataLo)
@@ -1594,6 +1568,46 @@ u8 wlc_phy_txpower_get_target_max(struct brcms_phy_pub *ppi)
 	return pi->tx_power_max;
 }
 
+static s8 wlc_phy_env_measure_vbat(struct brcms_phy *pi)
+{
+	if (ISLCNPHY(pi))
+		return wlc_lcnphy_vbatsense(pi, 0);
+	else
+		return 0;
+}
+
+static s8 wlc_phy_env_measure_temperature(struct brcms_phy *pi)
+{
+	if (ISLCNPHY(pi))
+		return wlc_lcnphy_tempsense_degree(pi, 0);
+	else
+		return 0;
+}
+
+static void wlc_phy_upd_env_txpwr_rate_limits(struct brcms_phy *pi, u32 band)
+{
+	u8 i;
+	s8 temp, vbat;
+
+	for (i = 0; i < TXP_NUM_RATES; i++)
+		pi->txpwr_env_limit[i] = BRCMS_TXPWR_MAX;
+
+	vbat = wlc_phy_env_measure_vbat(pi);
+	temp = wlc_phy_env_measure_temperature(pi);
+
+}
+
+static s8
+wlc_user_txpwr_antport_to_rfport(struct brcms_phy *pi, uint chan, u32 band,
+				 u8 rate)
+{
+	s8 offset = 0;
+
+	if (!pi->user_txpwr_at_rfport)
+		return offset;
+	return offset;
+}
+
 void wlc_phy_txpower_recalc_target(struct brcms_phy *pi)
 {
 	u8 maxtxpwr, mintxpwr, rate, pactrl;
@@ -2274,6 +2288,123 @@ wlc_phy_noise_calc_phy(struct brcms_phy *pi, u32 *cmplx_pwr, s8 *pwr_ant)
 	return true;
 }
 
+static void wlc_phy_noise_cb(struct brcms_phy *pi, u8 channel, s8 noise_dbm)
+{
+	if (!pi->phynoise_state)
+		return;
+
+	if (pi->phynoise_state & PHY_NOISE_STATE_MON) {
+		if (pi->phynoise_chan_watchdog == channel) {
+			pi->sh->phy_noise_window[pi->sh->phy_noise_index] =
+				noise_dbm;
+			pi->sh->phy_noise_index =
+				MODINC(pi->sh->phy_noise_index, MA_WINDOW_SZ);
+		}
+		pi->phynoise_state &= ~PHY_NOISE_STATE_MON;
+	}
+
+	if (pi->phynoise_state & PHY_NOISE_STATE_EXTERNAL)
+		pi->phynoise_state &= ~PHY_NOISE_STATE_EXTERNAL;
+
+}
+
+static s8 wlc_phy_noise_read_shmem(struct brcms_phy *pi)
+{
+	u32 cmplx_pwr[PHY_CORE_MAX];
+	s8 noise_dbm_ant[PHY_CORE_MAX];
+	u16 lo, hi;
+	u32 cmplx_pwr_tot = 0;
+	s8 noise_dbm = PHY_NOISE_FIXED_VAL_NPHY;
+	u8 idx, core;
+
+	memset((u8 *) cmplx_pwr, 0, sizeof(cmplx_pwr));
+	memset((u8 *) noise_dbm_ant, 0, sizeof(noise_dbm_ant));
+
+	for (idx = 0, core = 0; core < pi->pubpi.phy_corenum; idx += 2,
+	     core++) {
+		lo = wlapi_bmac_read_shm(pi->sh->physhim, M_PWRIND_MAP(idx));
+		hi = wlapi_bmac_read_shm(pi->sh->physhim,
+					 M_PWRIND_MAP(idx + 1));
+		cmplx_pwr[core] = (hi << 16) + lo;
+		cmplx_pwr_tot += cmplx_pwr[core];
+		if (cmplx_pwr[core] == 0)
+			noise_dbm_ant[core] = PHY_NOISE_FIXED_VAL_NPHY;
+		else
+			cmplx_pwr[core] >>= PHY_NOISE_SAMPLE_LOG_NUM_UCODE;
+	}
+
+	if (cmplx_pwr_tot != 0)
+		wlc_phy_noise_calc_phy(pi, cmplx_pwr, noise_dbm_ant);
+
+	for (core = 0; core < pi->pubpi.phy_corenum; core++) {
+		pi->nphy_noise_win[core][pi->nphy_noise_index] =
+			noise_dbm_ant[core];
+
+		if (noise_dbm_ant[core] > noise_dbm)
+			noise_dbm = noise_dbm_ant[core];
+	}
+	pi->nphy_noise_index =
+		MODINC_POW2(pi->nphy_noise_index, PHY_NOISE_WINDOW_SZ);
+
+	return noise_dbm;
+
+}
+
+void wlc_phy_noise_sample_intr(struct brcms_phy_pub *pih)
+{
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
+	u16 jssi_aux;
+	u8 channel = 0;
+	s8 noise_dbm = PHY_NOISE_FIXED_VAL_NPHY;
+
+	if (ISLCNPHY(pi)) {
+		u32 cmplx_pwr, cmplx_pwr0, cmplx_pwr1;
+		u16 lo, hi;
+		s32 pwr_offset_dB, gain_dB;
+		u16 status_0, status_1;
+
+		jssi_aux = wlapi_bmac_read_shm(pi->sh->physhim, M_JSSI_AUX);
+		channel = jssi_aux & D11_CURCHANNEL_MAX;
+
+		lo = wlapi_bmac_read_shm(pi->sh->physhim, M_PWRIND_MAP0);
+		hi = wlapi_bmac_read_shm(pi->sh->physhim, M_PWRIND_MAP1);
+		cmplx_pwr0 = (hi << 16) + lo;
+
+		lo = wlapi_bmac_read_shm(pi->sh->physhim, M_PWRIND_MAP2);
+		hi = wlapi_bmac_read_shm(pi->sh->physhim, M_PWRIND_MAP3);
+		cmplx_pwr1 = (hi << 16) + lo;
+		cmplx_pwr = (cmplx_pwr0 + cmplx_pwr1) >> 6;
+
+		status_0 = 0x44;
+		status_1 = wlapi_bmac_read_shm(pi->sh->physhim, M_JSSI_0);
+		if ((cmplx_pwr > 0 && cmplx_pwr < 500)
+		    && ((status_1 & 0xc000) == 0x4000)) {
+
+			wlc_phy_compute_dB(&cmplx_pwr, &noise_dbm,
+					   pi->pubpi.phy_corenum);
+			pwr_offset_dB = (read_phy_reg(pi, 0x434) & 0xFF);
+			if (pwr_offset_dB > 127)
+				pwr_offset_dB -= 256;
+
+			noise_dbm += (s8) (pwr_offset_dB - 30);
+
+			gain_dB = (status_0 & 0x1ff);
+			noise_dbm -= (s8) (gain_dB);
+		} else {
+			noise_dbm = PHY_NOISE_FIXED_VAL_LCNPHY;
+		}
+	} else if (ISNPHY(pi)) {
+
+		jssi_aux = wlapi_bmac_read_shm(pi->sh->physhim, M_JSSI_AUX);
+		channel = jssi_aux & D11_CURCHANNEL_MAX;
+
+		noise_dbm = wlc_phy_noise_read_shmem(pi);
+	}
+
+	wlc_phy_noise_cb(pi, channel, noise_dbm);
+
+}
+
 static void
 wlc_phy_noise_sample_request(struct brcms_phy_pub *pih, u8 reason, u8 ch)
 {
@@ -2408,123 +2539,6 @@ void wlc_phy_noise_sample_request_external(struct brcms_phy_pub *pih)
 	wlc_phy_noise_sample_request(pih, PHY_NOISE_SAMPLE_EXTERNAL, channel);
 }
 
-static void wlc_phy_noise_cb(struct brcms_phy *pi, u8 channel, s8 noise_dbm)
-{
-	if (!pi->phynoise_state)
-		return;
-
-	if (pi->phynoise_state & PHY_NOISE_STATE_MON) {
-		if (pi->phynoise_chan_watchdog == channel) {
-			pi->sh->phy_noise_window[pi->sh->phy_noise_index] =
-				noise_dbm;
-			pi->sh->phy_noise_index =
-				MODINC(pi->sh->phy_noise_index, MA_WINDOW_SZ);
-		}
-		pi->phynoise_state &= ~PHY_NOISE_STATE_MON;
-	}
-
-	if (pi->phynoise_state & PHY_NOISE_STATE_EXTERNAL)
-		pi->phynoise_state &= ~PHY_NOISE_STATE_EXTERNAL;
-
-}
-
-static s8 wlc_phy_noise_read_shmem(struct brcms_phy *pi)
-{
-	u32 cmplx_pwr[PHY_CORE_MAX];
-	s8 noise_dbm_ant[PHY_CORE_MAX];
-	u16 lo, hi;
-	u32 cmplx_pwr_tot = 0;
-	s8 noise_dbm = PHY_NOISE_FIXED_VAL_NPHY;
-	u8 idx, core;
-
-	memset((u8 *) cmplx_pwr, 0, sizeof(cmplx_pwr));
-	memset((u8 *) noise_dbm_ant, 0, sizeof(noise_dbm_ant));
-
-	for (idx = 0, core = 0; core < pi->pubpi.phy_corenum; idx += 2,
-	     core++) {
-		lo = wlapi_bmac_read_shm(pi->sh->physhim, M_PWRIND_MAP(idx));
-		hi = wlapi_bmac_read_shm(pi->sh->physhim,
-					 M_PWRIND_MAP(idx + 1));
-		cmplx_pwr[core] = (hi << 16) + lo;
-		cmplx_pwr_tot += cmplx_pwr[core];
-		if (cmplx_pwr[core] == 0)
-			noise_dbm_ant[core] = PHY_NOISE_FIXED_VAL_NPHY;
-		else
-			cmplx_pwr[core] >>= PHY_NOISE_SAMPLE_LOG_NUM_UCODE;
-	}
-
-	if (cmplx_pwr_tot != 0)
-		wlc_phy_noise_calc_phy(pi, cmplx_pwr, noise_dbm_ant);
-
-	for (core = 0; core < pi->pubpi.phy_corenum; core++) {
-		pi->nphy_noise_win[core][pi->nphy_noise_index] =
-			noise_dbm_ant[core];
-
-		if (noise_dbm_ant[core] > noise_dbm)
-			noise_dbm = noise_dbm_ant[core];
-	}
-	pi->nphy_noise_index =
-		MODINC_POW2(pi->nphy_noise_index, PHY_NOISE_WINDOW_SZ);
-
-	return noise_dbm;
-
-}
-
-void wlc_phy_noise_sample_intr(struct brcms_phy_pub *pih)
-{
-	struct brcms_phy *pi = (struct brcms_phy *) pih;
-	u16 jssi_aux;
-	u8 channel = 0;
-	s8 noise_dbm = PHY_NOISE_FIXED_VAL_NPHY;
-
-	if (ISLCNPHY(pi)) {
-		u32 cmplx_pwr, cmplx_pwr0, cmplx_pwr1;
-		u16 lo, hi;
-		s32 pwr_offset_dB, gain_dB;
-		u16 status_0, status_1;
-
-		jssi_aux = wlapi_bmac_read_shm(pi->sh->physhim, M_JSSI_AUX);
-		channel = jssi_aux & D11_CURCHANNEL_MAX;
-
-		lo = wlapi_bmac_read_shm(pi->sh->physhim, M_PWRIND_MAP0);
-		hi = wlapi_bmac_read_shm(pi->sh->physhim, M_PWRIND_MAP1);
-		cmplx_pwr0 = (hi << 16) + lo;
-
-		lo = wlapi_bmac_read_shm(pi->sh->physhim, M_PWRIND_MAP2);
-		hi = wlapi_bmac_read_shm(pi->sh->physhim, M_PWRIND_MAP3);
-		cmplx_pwr1 = (hi << 16) + lo;
-		cmplx_pwr = (cmplx_pwr0 + cmplx_pwr1) >> 6;
-
-		status_0 = 0x44;
-		status_1 = wlapi_bmac_read_shm(pi->sh->physhim, M_JSSI_0);
-		if ((cmplx_pwr > 0 && cmplx_pwr < 500)
-		    && ((status_1 & 0xc000) == 0x4000)) {
-
-			wlc_phy_compute_dB(&cmplx_pwr, &noise_dbm,
-					   pi->pubpi.phy_corenum);
-			pwr_offset_dB = (read_phy_reg(pi, 0x434) & 0xFF);
-			if (pwr_offset_dB > 127)
-				pwr_offset_dB -= 256;
-
-			noise_dbm += (s8) (pwr_offset_dB - 30);
-
-			gain_dB = (status_0 & 0x1ff);
-			noise_dbm -= (s8) (gain_dB);
-		} else {
-			noise_dbm = PHY_NOISE_FIXED_VAL_LCNPHY;
-		}
-	} else if (ISNPHY(pi)) {
-
-		jssi_aux = wlapi_bmac_read_shm(pi->sh->physhim, M_JSSI_AUX);
-		channel = jssi_aux & D11_CURCHANNEL_MAX;
-
-		noise_dbm = wlc_phy_noise_read_shmem(pi);
-	}
-
-	wlc_phy_noise_cb(pi, channel, noise_dbm);
-
-}
-
 s8 lcnphy_gain_index_offset_for_pkt_rssi[] = {
 	8,
 	8,
@@ -2985,46 +2999,6 @@ void wlc_lcnphy_epa_switch(struct brcms_phy *pi, bool mode)
 	}
 }
 
-static s8
-wlc_user_txpwr_antport_to_rfport(struct brcms_phy *pi, uint chan, u32 band,
-				 u8 rate)
-{
-	s8 offset = 0;
-
-	if (!pi->user_txpwr_at_rfport)
-		return offset;
-	return offset;
-}
-
-static s8 wlc_phy_env_measure_vbat(struct brcms_phy *pi)
-{
-	if (ISLCNPHY(pi))
-		return wlc_lcnphy_vbatsense(pi, 0);
-	else
-		return 0;
-}
-
-static s8 wlc_phy_env_measure_temperature(struct brcms_phy *pi)
-{
-	if (ISLCNPHY(pi))
-		return wlc_lcnphy_tempsense_degree(pi, 0);
-	else
-		return 0;
-}
-
-static void wlc_phy_upd_env_txpwr_rate_limits(struct brcms_phy *pi, u32 band)
-{
-	u8 i;
-	s8 temp, vbat;
-
-	for (i = 0; i < TXP_NUM_RATES; i++)
-		pi->txpwr_env_limit[i] = BRCMS_TXPWR_MAX;
-
-	vbat = wlc_phy_env_measure_vbat(pi);
-	temp = wlc_phy_env_measure_temperature(pi);
-
-}
-
 void wlc_phy_ldpc_override_set(struct brcms_phy_pub *ppi, bool ldpc)
 {
 	return;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
index 47f96a9..941b7fa 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -965,71 +965,6 @@ u16 LCNPHY_txdigfiltcoeffs_ofdm[LCNPHY_NUM_TX_DIG_FILTERS_OFDM]
 #define FIXED_TXPWR 78
 #define LCNPHY_TEMPSENSE(val) ((s16)((val > 255) ? (val - 512) : val))
 
-static u32 wlc_lcnphy_qdiv_roundup(u32 divident, u32 divisor,
-				   u8 precision);
-static void wlc_lcnphy_set_rx_gain_by_distribution(struct brcms_phy *pi,
-						   u16 ext_lna, u16 trsw,
-						   u16 biq2, u16 biq1,
-						   u16 tia, u16 lna2,
-						   u16 lna1);
-static void wlc_lcnphy_clear_tx_power_offsets(struct brcms_phy *pi);
-static void wlc_lcnphy_set_pa_gain(struct brcms_phy *pi, u16 gain);
-static void wlc_lcnphy_set_trsw_override(struct brcms_phy *pi, bool tx,
-					 bool rx);
-static void wlc_lcnphy_set_bbmult(struct brcms_phy *pi, u8 m0);
-static u8 wlc_lcnphy_get_bbmult(struct brcms_phy *pi);
-static void wlc_lcnphy_get_tx_gain(struct brcms_phy *pi,
-				   struct lcnphy_txgains *gains);
-static void wlc_lcnphy_set_tx_gain_override(struct brcms_phy *pi, bool bEnable);
-static void wlc_lcnphy_toggle_afe_pwdn(struct brcms_phy *pi);
-static void wlc_lcnphy_rx_gain_override_enable(struct brcms_phy *pi,
-					       bool enable);
-static void wlc_lcnphy_set_tx_gain(struct brcms_phy *pi,
-				   struct lcnphy_txgains *target_gains);
-static bool wlc_lcnphy_rx_iq_est(struct brcms_phy *pi, u16 num_samps,
-				 u8 wait_time, struct lcnphy_iq_est *iq_est);
-static bool wlc_lcnphy_calc_rx_iq_comp(struct brcms_phy *pi, u16 num_samps);
-static u16 wlc_lcnphy_get_pa_gain(struct brcms_phy *pi);
-static void wlc_lcnphy_afe_clk_init(struct brcms_phy *pi, u8 mode);
-static void wlc_lcnphy_tx_pwr_ctrl_init(struct brcms_phy_pub *ppi);
-static void wlc_lcnphy_radio_2064_channel_tune_4313(struct brcms_phy *pi,
-						    u8 channel);
-
-static void wlc_lcnphy_load_tx_gain_table(
-	struct brcms_phy *pi,
-	const struct lcnphy_tx_gain_tbl_entry
-	*g);
-
-static void wlc_lcnphy_samp_cap(struct brcms_phy *pi, int clip_detect_algo,
-				u16 thresh, s16 *ptr, int mode);
-static int wlc_lcnphy_calc_floor(s16 coeff, int type);
-static void wlc_lcnphy_tx_iqlo_loopback(struct brcms_phy *pi,
-					u16 *values_to_save);
-static void wlc_lcnphy_tx_iqlo_loopback_cleanup(struct brcms_phy *pi,
-						u16 *values_to_save);
-static void wlc_lcnphy_set_cc(struct brcms_phy *pi, int cal_type, s16 coeff_x,
-			      s16 coeff_y);
-static struct lcnphy_unsign16_struct wlc_lcnphy_get_cc(struct brcms_phy *pi,
-						       int cal_type);
-static void wlc_lcnphy_a1(struct brcms_phy *pi, int cal_type,
-			  int num_levels, int step_size_lg2);
-static void wlc_lcnphy_tx_iqlo_soft_cal_full(struct brcms_phy *pi);
-
-static void wlc_lcnphy_set_chanspec_tweaks(struct brcms_phy *pi,
-					   u16 chanspec);
-static void wlc_lcnphy_agc_temp_init(struct brcms_phy *pi);
-static void wlc_lcnphy_temp_adj(struct brcms_phy *pi);
-static void wlc_lcnphy_clear_papd_comptable(struct brcms_phy *pi);
-static void wlc_lcnphy_baseband_init(struct brcms_phy *pi);
-static void wlc_lcnphy_radio_init(struct brcms_phy *pi);
-static void wlc_lcnphy_rc_cal(struct brcms_phy *pi);
-static void wlc_lcnphy_rcal(struct brcms_phy *pi);
-static void wlc_lcnphy_txrx_spur_avoidance_mode(struct brcms_phy *pi,
-						bool enable);
-static int wlc_lcnphy_load_tx_iir_filter(struct brcms_phy *pi, bool is_ofdm,
-					 s16 filt_type);
-static void wlc_lcnphy_set_rx_iq_comp(struct brcms_phy *pi, u16 a, u16 b);
-
 void wlc_lcnphy_write_table(struct brcms_phy *pi, const struct phytbl_info *pti)
 {
 	wlc_phy_write_table(pi, pti, 0x455, 0x457, 0x456);
@@ -1115,3062 +1050,3255 @@ static int wlc_lcnphy_calc_floor(s16 coeff_x, int type)
 	return k;
 }
 
-s8 wlc_lcnphy_get_current_tx_pwr_idx(struct brcms_phy *pi)
-{
-	s8 index;
-	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
-
-	if (txpwrctrl_off(pi))
-		index = pi_lcn->lcnphy_current_index;
-	else if (wlc_lcnphy_tssi_based_pwr_ctrl_enabled(pi))
-		index =	(s8) (wlc_lcnphy_get_current_tx_pwr_idx_if_pwrctrl_on(
-			      pi) / 2);
-	else
-		index = pi_lcn->lcnphy_current_index;
-	return index;
-}
-
-static u32 wlc_lcnphy_measure_digital_power(struct brcms_phy *pi, u16 nsamples)
-{
-	struct lcnphy_iq_est iq_est = { 0, 0, 0 };
-
-	if (!wlc_lcnphy_rx_iq_est(pi, nsamples, 32, &iq_est))
-		return 0;
-	return (iq_est.i_pwr + iq_est.q_pwr) / nsamples;
-}
-
-void wlc_lcnphy_crsuprs(struct brcms_phy *pi, int channel)
+static void
+wlc_lcnphy_get_tx_gain(struct brcms_phy *pi, struct lcnphy_txgains *gains)
 {
-	u16 afectrlovr, afectrlovrval;
-	afectrlovr = read_phy_reg(pi, 0x43b);
-	afectrlovrval = read_phy_reg(pi, 0x43c);
-	if (channel != 0) {
-		mod_phy_reg(pi, 0x43b, (0x1 << 1), (1) << 1);
+	u16 dac_gain;
 
-		mod_phy_reg(pi, 0x43c, (0x1 << 1), (0) << 1);
+	dac_gain = read_phy_reg(pi, 0x439) >> 0;
+	gains->dac_gain = (dac_gain & 0x380) >> 7;
 
-		mod_phy_reg(pi, 0x43b, (0x1 << 4), (1) << 4);
+	{
+		u16 rfgain0, rfgain1;
 
-		mod_phy_reg(pi, 0x43c, (0x1 << 6), (0) << 6);
+		rfgain0 = (read_phy_reg(pi, 0x4b5) & (0xffff << 0)) >> 0;
+		rfgain1 = (read_phy_reg(pi, 0x4fb) & (0x7fff << 0)) >> 0;
 
-		write_phy_reg(pi, 0x44b, 0xffff);
-		wlc_lcnphy_tx_pu(pi, 1);
+		gains->gm_gain = rfgain0 & 0xff;
+		gains->pga_gain = (rfgain0 >> 8) & 0xff;
+		gains->pad_gain = rfgain1 & 0xff;
+	}
+}
 
-		mod_phy_reg(pi, 0x634, (0xff << 8), (0) << 8);
 
-		or_phy_reg(pi, 0x6da, 0x0080);
+static void wlc_lcnphy_set_dac_gain(struct brcms_phy *pi, u16 dac_gain)
+{
+	u16 dac_ctrl;
 
-		or_phy_reg(pi, 0x00a, 0x228);
-	} else {
-		and_phy_reg(pi, 0x00a, ~(0x228));
+	dac_ctrl = (read_phy_reg(pi, 0x439) >> 0);
+	dac_ctrl = dac_ctrl & 0xc7f;
+	dac_ctrl = dac_ctrl | (dac_gain << 7);
+	mod_phy_reg(pi, 0x439, (0xfff << 0), (dac_ctrl) << 0);
 
-		and_phy_reg(pi, 0x6da, 0xFF7F);
-		write_phy_reg(pi, 0x43b, afectrlovr);
-		write_phy_reg(pi, 0x43c, afectrlovrval);
-	}
 }
 
-static void wlc_lcnphy_toggle_afe_pwdn(struct brcms_phy *pi)
+static void wlc_lcnphy_set_tx_gain_override(struct brcms_phy *pi, bool bEnable)
 {
-	u16 save_AfeCtrlOvrVal, save_AfeCtrlOvr;
-
-	save_AfeCtrlOvrVal = read_phy_reg(pi, 0x43c);
-	save_AfeCtrlOvr = read_phy_reg(pi, 0x43b);
+	u16 bit = bEnable ? 1 : 0;
 
-	write_phy_reg(pi, 0x43c, save_AfeCtrlOvrVal | 0x1);
-	write_phy_reg(pi, 0x43b, save_AfeCtrlOvr | 0x1);
+	mod_phy_reg(pi, 0x4b0, (0x1 << 7), bit << 7);
 
-	write_phy_reg(pi, 0x43c, save_AfeCtrlOvrVal & 0xfffe);
-	write_phy_reg(pi, 0x43b, save_AfeCtrlOvr & 0xfffe);
+	mod_phy_reg(pi, 0x4b0, (0x1 << 14), bit << 14);
 
-	write_phy_reg(pi, 0x43c, save_AfeCtrlOvrVal);
-	write_phy_reg(pi, 0x43b, save_AfeCtrlOvr);
+	mod_phy_reg(pi, 0x43b, (0x1 << 6), bit << 6);
 }
 
 static void
-wlc_lcnphy_txrx_spur_avoidance_mode(struct brcms_phy *pi, bool enable)
+wlc_lcnphy_rx_gain_override_enable(struct brcms_phy *pi, bool enable)
 {
-	if (enable) {
-		write_phy_reg(pi, 0x942, 0x7);
-		write_phy_reg(pi, 0x93b, ((1 << 13) + 23));
-		write_phy_reg(pi, 0x93c, ((1 << 13) + 1989));
+	u16 ebit = enable ? 1 : 0;
 
-		write_phy_reg(pi, 0x44a, 0x084);
-		write_phy_reg(pi, 0x44a, 0x080);
-		write_phy_reg(pi, 0x6d3, 0x2222);
-		write_phy_reg(pi, 0x6d3, 0x2220);
+	mod_phy_reg(pi, 0x4b0, (0x1 << 8), ebit << 8);
+
+	mod_phy_reg(pi, 0x44c, (0x1 << 0), ebit << 0);
+
+	if (LCNREV_LT(pi->pubpi.phy_rev, 2)) {
+		mod_phy_reg(pi, 0x44c, (0x1 << 4), ebit << 4);
+		mod_phy_reg(pi, 0x44c, (0x1 << 6), ebit << 6);
+		mod_phy_reg(pi, 0x4b0, (0x1 << 5), ebit << 5);
+		mod_phy_reg(pi, 0x4b0, (0x1 << 6), ebit << 6);
 	} else {
-		write_phy_reg(pi, 0x942, 0x0);
-		write_phy_reg(pi, 0x93b, ((0 << 13) + 23));
-		write_phy_reg(pi, 0x93c, ((0 << 13) + 1989));
+		mod_phy_reg(pi, 0x4b0, (0x1 << 12), ebit << 12);
+		mod_phy_reg(pi, 0x4b0, (0x1 << 13), ebit << 13);
+		mod_phy_reg(pi, 0x4b0, (0x1 << 5), ebit << 5);
+	}
+
+	if (CHSPEC_IS2G(pi->radio_chanspec)) {
+		mod_phy_reg(pi, 0x4b0, (0x1 << 10), ebit << 10);
+		mod_phy_reg(pi, 0x4e5, (0x1 << 3), ebit << 3);
 	}
-	wlapi_switch_macfreq(pi->sh->physhim, enable);
 }
 
-void wlc_phy_chanspec_set_lcnphy(struct brcms_phy *pi, u16 chanspec)
+static void
+wlc_lcnphy_set_rx_gain_by_distribution(struct brcms_phy *pi,
+				       u16 trsw,
+				       u16 ext_lna,
+				       u16 biq2,
+				       u16 biq1,
+				       u16 tia, u16 lna2, u16 lna1)
 {
-	u8 channel = CHSPEC_CHANNEL(chanspec);
-
-	wlc_phy_chanspec_radio_set((struct brcms_phy_pub *) pi, chanspec);
-
-	wlc_lcnphy_set_chanspec_tweaks(pi, pi->radio_chanspec);
-
-	or_phy_reg(pi, 0x44a, 0x44);
-	write_phy_reg(pi, 0x44a, 0x80);
-
-	wlc_lcnphy_radio_2064_channel_tune_4313(pi, channel);
-	udelay(1000);
-
-	wlc_lcnphy_toggle_afe_pwdn(pi);
+	u16 gain0_15, gain16_19;
 
-	write_phy_reg(pi, 0x657, lcnphy_sfo_cfg[channel - 1].ptcentreTs20);
-	write_phy_reg(pi, 0x658, lcnphy_sfo_cfg[channel - 1].ptcentreFactor);
+	gain16_19 = biq2 & 0xf;
+	gain0_15 = ((biq1 & 0xf) << 12) |
+		   ((tia & 0xf) << 8) |
+		   ((lna2 & 0x3) << 6) |
+		   ((lna2 &
+		     0x3) << 4) | ((lna1 & 0x3) << 2) | ((lna1 & 0x3) << 0);
 
-	if (CHSPEC_CHANNEL(pi->radio_chanspec) == 14) {
-		mod_phy_reg(pi, 0x448, (0x3 << 8), (2) << 8);
+	mod_phy_reg(pi, 0x4b6, (0xffff << 0), gain0_15 << 0);
+	mod_phy_reg(pi, 0x4b7, (0xf << 0), gain16_19 << 0);
+	mod_phy_reg(pi, 0x4b1, (0x3 << 11), lna1 << 11);
 
-		wlc_lcnphy_load_tx_iir_filter(pi, false, 3);
+	if (LCNREV_LT(pi->pubpi.phy_rev, 2)) {
+		mod_phy_reg(pi, 0x4b1, (0x1 << 9), ext_lna << 9);
+		mod_phy_reg(pi, 0x4b1, (0x1 << 10), ext_lna << 10);
 	} else {
-		mod_phy_reg(pi, 0x448, (0x3 << 8), (1) << 8);
+		mod_phy_reg(pi, 0x4b1, (0x1 << 10), 0 << 10);
 
-		wlc_lcnphy_load_tx_iir_filter(pi, false, 2);
-	}
+		mod_phy_reg(pi, 0x4b1, (0x1 << 15), 0 << 15);
 
-	wlc_lcnphy_load_tx_iir_filter(pi, true, 0);
+		mod_phy_reg(pi, 0x4b1, (0x1 << 9), ext_lna << 9);
+	}
 
-	mod_phy_reg(pi, 0x4eb, (0x7 << 3), (1) << 3);
+	mod_phy_reg(pi, 0x44d, (0x1 << 0), (!trsw) << 0);
 
 }
 
-static void wlc_lcnphy_set_dac_gain(struct brcms_phy *pi, u16 dac_gain)
+static void wlc_lcnphy_set_trsw_override(struct brcms_phy *pi, bool tx, bool rx)
 {
-	u16 dac_ctrl;
 
-	dac_ctrl = (read_phy_reg(pi, 0x439) >> 0);
-	dac_ctrl = dac_ctrl & 0xc7f;
-	dac_ctrl = dac_ctrl | (dac_gain << 7);
-	mod_phy_reg(pi, 0x439, (0xfff << 0), (dac_ctrl) << 0);
+	mod_phy_reg(pi, 0x44d,
+		    (0x1 << 1) |
+		    (0x1 << 0), (tx ? (0x1 << 1) : 0) | (rx ? (0x1 << 0) : 0));
 
+	or_phy_reg(pi, 0x44c, (0x1 << 1) | (0x1 << 0));
 }
 
-static void wlc_lcnphy_set_tx_gain_override(struct brcms_phy *pi, bool bEnable)
+static void wlc_lcnphy_clear_trsw_override(struct brcms_phy *pi)
 {
-	u16 bit = bEnable ? 1 : 0;
-
-	mod_phy_reg(pi, 0x4b0, (0x1 << 7), bit << 7);
 
-	mod_phy_reg(pi, 0x4b0, (0x1 << 14), bit << 14);
-
-	mod_phy_reg(pi, 0x43b, (0x1 << 6), bit << 6);
+	and_phy_reg(pi, 0x44c, (u16) ~((0x1 << 1) | (0x1 << 0)));
 }
 
-static u16 wlc_lcnphy_get_pa_gain(struct brcms_phy *pi)
+static void wlc_lcnphy_set_rx_iq_comp(struct brcms_phy *pi, u16 a, u16 b)
 {
-	u16 pa_gain;
-
-	pa_gain = (read_phy_reg(pi, 0x4fb) &
-		   LCNPHY_txgainctrlovrval1_pagain_ovr_val1_MASK) >>
-		  LCNPHY_txgainctrlovrval1_pagain_ovr_val1_SHIFT;
+	mod_phy_reg(pi, 0x645, (0x3ff << 0), (a) << 0);
 
-	return pa_gain;
-}
+	mod_phy_reg(pi, 0x646, (0x3ff << 0), (b) << 0);
 
-static void wlc_lcnphy_set_tx_gain(struct brcms_phy *pi,
-				   struct lcnphy_txgains *target_gains)
-{
-	u16 pa_gain = wlc_lcnphy_get_pa_gain(pi);
+	mod_phy_reg(pi, 0x647, (0x3ff << 0), (a) << 0);
 
-	mod_phy_reg(
-		pi, 0x4b5,
-		(0xffff << 0),
-		((target_gains->gm_gain) |
-		 (target_gains->pga_gain << 8)) <<
-		0);
-	mod_phy_reg(pi, 0x4fb,
-		    (0x7fff << 0),
-		    ((target_gains->pad_gain) | (pa_gain << 8)) << 0);
+	mod_phy_reg(pi, 0x648, (0x3ff << 0), (b) << 0);
 
-	mod_phy_reg(
-		pi, 0x4fc,
-		(0xffff << 0),
-		((target_gains->gm_gain) |
-		 (target_gains->pga_gain << 8)) <<
-		0);
-	mod_phy_reg(pi, 0x4fd,
-		    (0x7fff << 0),
-		    ((target_gains->pad_gain) | (pa_gain << 8)) << 0);
+	mod_phy_reg(pi, 0x649, (0x3ff << 0), (a) << 0);
 
-	wlc_lcnphy_set_dac_gain(pi, target_gains->dac_gain);
+	mod_phy_reg(pi, 0x64a, (0x3ff << 0), (b) << 0);
 
-	wlc_lcnphy_enable_tx_gain_override(pi);
 }
 
-static void wlc_lcnphy_set_bbmult(struct brcms_phy *pi, u8 m0)
+static bool
+wlc_lcnphy_rx_iq_est(struct brcms_phy *pi,
+		     u16 num_samps,
+		     u8 wait_time, struct lcnphy_iq_est *iq_est)
 {
-	u16 m0m1 = (u16) m0 << 8;
-	struct phytbl_info tab;
+	int wait_count = 0;
+	bool result = true;
+	u8 phybw40;
+	phybw40 = CHSPEC_IS40(pi->radio_chanspec);
 
-	tab.tbl_ptr = &m0m1;
-	tab.tbl_len = 1;
-	tab.tbl_id = LCNPHY_TBL_ID_IQLOCAL;
-	tab.tbl_offset = 87;
-	tab.tbl_width = 16;
-	wlc_lcnphy_write_table(pi, &tab);
-}
+	mod_phy_reg(pi, 0x6da, (0x1 << 5), (1) << 5);
 
-static void wlc_lcnphy_clear_tx_power_offsets(struct brcms_phy *pi)
-{
-	u32 data_buf[64];
-	struct phytbl_info tab;
+	mod_phy_reg(pi, 0x410, (0x1 << 3), (0) << 3);
 
-	memset(data_buf, 0, sizeof(data_buf));
+	mod_phy_reg(pi, 0x482, (0xffff << 0), (num_samps) << 0);
 
-	tab.tbl_id = LCNPHY_TBL_ID_TXPWRCTL;
-	tab.tbl_width = 32;
-	tab.tbl_ptr = data_buf;
+	mod_phy_reg(pi, 0x481, (0xff << 0), ((u16) wait_time) << 0);
 
-	if (!wlc_lcnphy_tempsense_based_pwr_ctrl_enabled(pi)) {
+	mod_phy_reg(pi, 0x481, (0x1 << 8), (0) << 8);
 
-		tab.tbl_len = 30;
-		tab.tbl_offset = LCNPHY_TX_PWR_CTRL_RATE_OFFSET;
-		wlc_lcnphy_write_table(pi, &tab);
-	}
+	mod_phy_reg(pi, 0x481, (0x1 << 9), (1) << 9);
 
-	tab.tbl_len = 64;
-	tab.tbl_offset = LCNPHY_TX_PWR_CTRL_MAC_OFFSET;
-	wlc_lcnphy_write_table(pi, &tab);
-}
+	while (read_phy_reg(pi, 0x481) & (0x1 << 9)) {
 
-enum lcnphy_tssi_mode {
-	LCNPHY_TSSI_PRE_PA,
-	LCNPHY_TSSI_POST_PA,
-	LCNPHY_TSSI_EXT
-};
+		if (wait_count > (10 * 500)) {
+			result = false;
+			goto cleanup;
+		}
+		udelay(100);
+		wait_count++;
+	}
 
-static void
-wlc_lcnphy_set_tssi_mux(struct brcms_phy *pi, enum lcnphy_tssi_mode pos)
-{
-	mod_phy_reg(pi, 0x4d7, (0x1 << 0), (0x1) << 0);
+	iq_est->iq_prod = ((u32) read_phy_reg(pi, 0x483) << 16) |
+			  (u32) read_phy_reg(pi, 0x484);
+	iq_est->i_pwr = ((u32) read_phy_reg(pi, 0x485) << 16) |
+			(u32) read_phy_reg(pi, 0x486);
+	iq_est->q_pwr = ((u32) read_phy_reg(pi, 0x487) << 16) |
+			(u32) read_phy_reg(pi, 0x488);
 
-	mod_phy_reg(pi, 0x4d7, (0x1 << 6), (1) << 6);
+cleanup:
+	mod_phy_reg(pi, 0x410, (0x1 << 3), (1) << 3);
 
-	if (LCNPHY_TSSI_POST_PA == pos) {
-		mod_phy_reg(pi, 0x4d9, (0x1 << 2), (0) << 2);
+	mod_phy_reg(pi, 0x6da, (0x1 << 5), (0) << 5);
 
-		mod_phy_reg(pi, 0x4d9, (0x1 << 3), (1) << 3);
+	return result;
+}
 
-		if (LCNREV_IS(pi->pubpi.phy_rev, 2)) {
-			mod_radio_reg(pi, RADIO_2064_REG086, 0x4, 0x4);
-		} else {
-			mod_radio_reg(pi, RADIO_2064_REG03A, 1, 0x1);
-			mod_radio_reg(pi, RADIO_2064_REG11A, 0x8, 0x8);
-		}
-	} else {
-		mod_phy_reg(pi, 0x4d9, (0x1 << 2), (0x1) << 2);
+static bool wlc_lcnphy_calc_rx_iq_comp(struct brcms_phy *pi, u16 num_samps)
+{
+#define LCNPHY_MIN_RXIQ_PWR 2
+	bool result;
+	u16 a0_new, b0_new;
+	struct lcnphy_iq_est iq_est = { 0, 0, 0 };
+	s32 a, b, temp;
+	s16 iq_nbits, qq_nbits, arsh, brsh;
+	s32 iq;
+	u32 ii, qq;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
-		mod_phy_reg(pi, 0x4d9, (0x1 << 3), (0) << 3);
+	a0_new = ((read_phy_reg(pi, 0x645) & (0x3ff << 0)) >> 0);
+	b0_new = ((read_phy_reg(pi, 0x646) & (0x3ff << 0)) >> 0);
+	mod_phy_reg(pi, 0x6d1, (0x1 << 2), (0) << 2);
 
-		if (LCNREV_IS(pi->pubpi.phy_rev, 2)) {
-			mod_radio_reg(pi, RADIO_2064_REG086, 0x4, 0x4);
-		} else {
-			mod_radio_reg(pi, RADIO_2064_REG03A, 1, 0);
-			mod_radio_reg(pi, RADIO_2064_REG11A, 0x8, 0x8);
-		}
-	}
-	mod_phy_reg(pi, 0x637, (0x3 << 14), (0) << 14);
+	mod_phy_reg(pi, 0x64b, (0x1 << 6), (1) << 6);
 
-	if (LCNPHY_TSSI_EXT == pos) {
-		write_radio_reg(pi, RADIO_2064_REG07F, 1);
-		mod_radio_reg(pi, RADIO_2064_REG005, 0x7, 0x2);
-		mod_radio_reg(pi, RADIO_2064_REG112, 0x80, 0x1 << 7);
-		mod_radio_reg(pi, RADIO_2064_REG028, 0x1f, 0x3);
-	}
-}
+	wlc_lcnphy_set_rx_iq_comp(pi, 0, 0);
 
-static u16 wlc_lcnphy_rfseq_tbl_adc_pwrup(struct brcms_phy *pi)
-{
-	u16 N1, N2, N3, N4, N5, N6, N;
-	N1 = ((read_phy_reg(pi, 0x4a5) & (0xff << 0))
-	      >> 0);
-	N2 = 1 << ((read_phy_reg(pi, 0x4a5) & (0x7 << 12))
-		   >> 12);
-	N3 = ((read_phy_reg(pi, 0x40d) & (0xff << 0))
-	      >> 0);
-	N4 = 1 << ((read_phy_reg(pi, 0x40d) & (0x7 << 8))
-		   >> 8);
-	N5 = ((read_phy_reg(pi, 0x4a2) & (0xff << 0))
-	      >> 0);
-	N6 = 1 << ((read_phy_reg(pi, 0x4a2) & (0x7 << 8))
-		   >> 8);
-	N = 2 * (N1 + N2 + N3 + N4 + 2 * (N5 + N6)) + 80;
-	if (N < 1600)
-		N = 1600;
-	return N;
-}
+	result = wlc_lcnphy_rx_iq_est(pi, num_samps, 32, &iq_est);
+	if (!result)
+		goto cleanup;
 
-static void wlc_lcnphy_pwrctrl_rssiparams(struct brcms_phy *pi)
-{
-	u16 auxpga_vmid, auxpga_vmid_temp, auxpga_gain_temp;
-	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	iq = (s32) iq_est.iq_prod;
+	ii = iq_est.i_pwr;
+	qq = iq_est.q_pwr;
 
-	auxpga_vmid = (2 << 8) |
-		      (pi_lcn->lcnphy_rssi_vc << 4) | pi_lcn->lcnphy_rssi_vf;
-	auxpga_vmid_temp = (2 << 8) | (8 << 4) | 4;
-	auxpga_gain_temp = 2;
+	if ((ii + qq) < LCNPHY_MIN_RXIQ_PWR) {
+		result = false;
+		goto cleanup;
+	}
 
-	mod_phy_reg(pi, 0x4d8, (0x1 << 0), (0) << 0);
+	iq_nbits = wlc_phy_nbits(iq);
+	qq_nbits = wlc_phy_nbits(qq);
 
-	mod_phy_reg(pi, 0x4d8, (0x1 << 1), (0) << 1);
+	arsh = 10 - (30 - iq_nbits);
+	if (arsh >= 0) {
+		a = (-(iq << (30 - iq_nbits)) + (ii >> (1 + arsh)));
+		temp = (s32) (ii >> arsh);
+		if (temp == 0)
+			return false;
+	} else {
+		a = (-(iq << (30 - iq_nbits)) + (ii << (-1 - arsh)));
+		temp = (s32) (ii << -arsh);
+		if (temp == 0)
+			return false;
+	}
+	a /= temp;
+	brsh = qq_nbits - 31 + 20;
+	if (brsh >= 0) {
+		b = (qq << (31 - qq_nbits));
+		temp = (s32) (ii >> brsh);
+		if (temp == 0)
+			return false;
+	} else {
+		b = (qq << (31 - qq_nbits));
+		temp = (s32) (ii << -brsh);
+		if (temp == 0)
+			return false;
+	}
+	b /= temp;
+	b -= a * a;
+	b = (s32) int_sqrt((unsigned long) b);
+	b -= (1 << 10);
+	a0_new = (u16) (a & 0x3ff);
+	b0_new = (u16) (b & 0x3ff);
+cleanup:
 
-	mod_phy_reg(pi, 0x4d7, (0x1 << 3), (0) << 3);
+	wlc_lcnphy_set_rx_iq_comp(pi, a0_new, b0_new);
 
-	mod_phy_reg(pi, 0x4db,
-		    (0x3ff << 0) |
-		    (0x7 << 12),
-		    (auxpga_vmid << 0) | (pi_lcn->lcnphy_rssi_gs << 12));
+	mod_phy_reg(pi, 0x64b, (0x1 << 0), (1) << 0);
 
-	mod_phy_reg(pi, 0x4dc,
-		    (0x3ff << 0) |
-		    (0x7 << 12),
-		    (auxpga_vmid << 0) | (pi_lcn->lcnphy_rssi_gs << 12));
+	mod_phy_reg(pi, 0x64b, (0x1 << 3), (1) << 3);
 
-	mod_phy_reg(pi, 0x40a,
-		    (0x3ff << 0) |
-		    (0x7 << 12),
-		    (auxpga_vmid << 0) | (pi_lcn->lcnphy_rssi_gs << 12));
+	pi_lcn->lcnphy_cal_results.rxiqcal_coeff_a0 = a0_new;
+	pi_lcn->lcnphy_cal_results.rxiqcal_coeff_b0 = b0_new;
 
-	mod_phy_reg(pi, 0x40b,
-		    (0x3ff << 0) |
-		    (0x7 << 12),
-		    (auxpga_vmid_temp << 0) | (auxpga_gain_temp << 12));
+	return result;
+}
 
-	mod_phy_reg(pi, 0x40c,
-		    (0x3ff << 0) |
-		    (0x7 << 12),
-		    (auxpga_vmid_temp << 0) | (auxpga_gain_temp << 12));
+static u32 wlc_lcnphy_measure_digital_power(struct brcms_phy *pi, u16 nsamples)
+{
+	struct lcnphy_iq_est iq_est = { 0, 0, 0 };
 
-	mod_radio_reg(pi, RADIO_2064_REG082, (1 << 5), (1 << 5));
+	if (!wlc_lcnphy_rx_iq_est(pi, nsamples, 32, &iq_est))
+		return 0;
+	return (iq_est.i_pwr + iq_est.q_pwr) / nsamples;
 }
 
-static void wlc_lcnphy_tssi_setup(struct brcms_phy *pi)
+static bool
+wlc_lcnphy_rx_iq_cal(struct brcms_phy *pi,
+		     const struct lcnphy_rx_iqcomp *iqcomp,
+		     int iqcomp_sz, bool tx_switch, bool rx_switch, int module,
+		     int tx_gain_idx)
 {
-	struct phytbl_info tab;
-	u32 rfseq, ind;
+	struct lcnphy_txgains old_gains;
+	u16 tx_pwr_ctrl;
+	u8 tx_gain_index_old = 0;
+	bool result = false, tx_gain_override_old = false;
+	u16 i, Core1TxControl_old, RFOverride0_old,
+	    RFOverrideVal0_old, rfoverride2_old, rfoverride2val_old,
+	    rfoverride3_old, rfoverride3val_old, rfoverride4_old,
+	    rfoverride4val_old, afectrlovr_old, afectrlovrval_old;
+	int tia_gain;
+	u32 received_power, rx_pwr_threshold;
+	u16 old_sslpnCalibClkEnCtrl, old_sslpnRxFeClkEnCtrl;
+	u16 values_to_save[11];
+	s16 *ptr;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
-	tab.tbl_id = LCNPHY_TBL_ID_TXPWRCTL;
-	tab.tbl_width = 32;
-	tab.tbl_ptr = &ind;
-	tab.tbl_len = 1;
-	tab.tbl_offset = 0;
-	for (ind = 0; ind < 128; ind++) {
-		wlc_lcnphy_write_table(pi, &tab);
-		tab.tbl_offset++;
-	}
-	tab.tbl_offset = 704;
-	for (ind = 0; ind < 128; ind++) {
-		wlc_lcnphy_write_table(pi, &tab);
-		tab.tbl_offset++;
+	ptr = kmalloc(sizeof(s16) * 131, GFP_ATOMIC);
+	if (NULL == ptr)
+		return false;
+	if (module == 2) {
+		while (iqcomp_sz--) {
+			if (iqcomp[iqcomp_sz].chan ==
+			    CHSPEC_CHANNEL(pi->radio_chanspec)) {
+				wlc_lcnphy_set_rx_iq_comp(pi,
+							  (u16)
+							  iqcomp[iqcomp_sz].a,
+							  (u16)
+							  iqcomp[iqcomp_sz].b);
+				result = true;
+				break;
+			}
+		}
+		goto cal_done;
 	}
-	mod_phy_reg(pi, 0x503, (0x1 << 0), (0) << 0);
 
-	mod_phy_reg(pi, 0x503, (0x1 << 2), (0) << 2);
+	if (module == 1) {
 
-	mod_phy_reg(pi, 0x503, (0x1 << 4), (1) << 4);
+		tx_pwr_ctrl = wlc_lcnphy_get_tx_pwr_ctrl(pi);
+		wlc_lcnphy_set_tx_pwr_ctrl(pi, LCNPHY_TX_PWR_CTRL_OFF);
 
-	wlc_lcnphy_set_tssi_mux(pi, LCNPHY_TSSI_EXT);
-	mod_phy_reg(pi, 0x4a4, (0x1 << 14), (0) << 14);
+		for (i = 0; i < 11; i++)
+			values_to_save[i] =
+				read_radio_reg(pi, rxiq_cal_rf_reg[i]);
+		Core1TxControl_old = read_phy_reg(pi, 0x631);
 
-	mod_phy_reg(pi, 0x4a4, (0x1 << 15), (1) << 15);
+		or_phy_reg(pi, 0x631, 0x0015);
 
-	mod_phy_reg(pi, 0x4d0, (0x1 << 5), (0) << 5);
+		RFOverride0_old = read_phy_reg(pi, 0x44c);
+		RFOverrideVal0_old = read_phy_reg(pi, 0x44d);
+		rfoverride2_old = read_phy_reg(pi, 0x4b0);
+		rfoverride2val_old = read_phy_reg(pi, 0x4b1);
+		rfoverride3_old = read_phy_reg(pi, 0x4f9);
+		rfoverride3val_old = read_phy_reg(pi, 0x4fa);
+		rfoverride4_old = read_phy_reg(pi, 0x938);
+		rfoverride4val_old = read_phy_reg(pi, 0x939);
+		afectrlovr_old = read_phy_reg(pi, 0x43b);
+		afectrlovrval_old = read_phy_reg(pi, 0x43c);
+		old_sslpnCalibClkEnCtrl = read_phy_reg(pi, 0x6da);
+		old_sslpnRxFeClkEnCtrl = read_phy_reg(pi, 0x6db);
 
-	mod_phy_reg(pi, 0x4a4, (0x1ff << 0), (0) << 0);
+		tx_gain_override_old = wlc_lcnphy_tx_gain_override_enabled(pi);
+		if (tx_gain_override_old) {
+			wlc_lcnphy_get_tx_gain(pi, &old_gains);
+			tx_gain_index_old = pi_lcn->lcnphy_current_index;
+		}
 
-	mod_phy_reg(pi, 0x4a5, (0xff << 0), (255) << 0);
+		wlc_lcnphy_set_tx_pwr_by_index(pi, tx_gain_idx);
 
-	mod_phy_reg(pi, 0x4a5, (0x7 << 12), (5) << 12);
+		mod_phy_reg(pi, 0x4f9, (0x1 << 0), 1 << 0);
+		mod_phy_reg(pi, 0x4fa, (0x1 << 0), 0 << 0);
 
-	mod_phy_reg(pi, 0x4a5, (0x7 << 8), (0) << 8);
+		mod_phy_reg(pi, 0x43b, (0x1 << 1), 1 << 1);
+		mod_phy_reg(pi, 0x43c, (0x1 << 1), 0 << 1);
 
-	mod_phy_reg(pi, 0x40d, (0xff << 0), (64) << 0);
+		write_radio_reg(pi, RADIO_2064_REG116, 0x06);
+		write_radio_reg(pi, RADIO_2064_REG12C, 0x07);
+		write_radio_reg(pi, RADIO_2064_REG06A, 0xd3);
+		write_radio_reg(pi, RADIO_2064_REG098, 0x03);
+		write_radio_reg(pi, RADIO_2064_REG00B, 0x7);
+		mod_radio_reg(pi, RADIO_2064_REG113, 1 << 4, 1 << 4);
+		write_radio_reg(pi, RADIO_2064_REG01D, 0x01);
+		write_radio_reg(pi, RADIO_2064_REG114, 0x01);
+		write_radio_reg(pi, RADIO_2064_REG02E, 0x10);
+		write_radio_reg(pi, RADIO_2064_REG12A, 0x08);
 
-	mod_phy_reg(pi, 0x40d, (0x7 << 8), (4) << 8);
+		mod_phy_reg(pi, 0x938, (0x1 << 0), 1 << 0);
+		mod_phy_reg(pi, 0x939, (0x1 << 0), 0 << 0);
+		mod_phy_reg(pi, 0x938, (0x1 << 1), 1 << 1);
+		mod_phy_reg(pi, 0x939, (0x1 << 1), 1 << 1);
+		mod_phy_reg(pi, 0x938, (0x1 << 2), 1 << 2);
+		mod_phy_reg(pi, 0x939, (0x1 << 2), 1 << 2);
+		mod_phy_reg(pi, 0x938, (0x1 << 3), 1 << 3);
+		mod_phy_reg(pi, 0x939, (0x1 << 3), 1 << 3);
+		mod_phy_reg(pi, 0x938, (0x1 << 5), 1 << 5);
+		mod_phy_reg(pi, 0x939, (0x1 << 5), 0 << 5);
 
-	mod_phy_reg(pi, 0x4a2, (0xff << 0), (64) << 0);
+		mod_phy_reg(pi, 0x43b, (0x1 << 0), 1 << 0);
+		mod_phy_reg(pi, 0x43c, (0x1 << 0), 0 << 0);
 
-	mod_phy_reg(pi, 0x4a2, (0x7 << 8), (4) << 8);
+		wlc_lcnphy_start_tx_tone(pi, 2000, 120, 0);
+		write_phy_reg(pi, 0x6da, 0xffff);
+		or_phy_reg(pi, 0x6db, 0x3);
+		wlc_lcnphy_set_trsw_override(pi, tx_switch, rx_switch);
+		wlc_lcnphy_rx_gain_override_enable(pi, true);
 
-	mod_phy_reg(pi, 0x4d0, (0x1ff << 6), (0) << 6);
+		tia_gain = 8;
+		rx_pwr_threshold = 950;
+		while (tia_gain > 0) {
+			tia_gain -= 1;
+			wlc_lcnphy_set_rx_gain_by_distribution(pi,
+							       0, 0, 2, 2,
+							       (u16)
+							       tia_gain, 1, 0);
+			udelay(500);
 
-	mod_phy_reg(pi, 0x4a8, (0xff << 0), (0x1) << 0);
+			received_power =
+				wlc_lcnphy_measure_digital_power(pi, 2000);
+			if (received_power < rx_pwr_threshold)
+				break;
+		}
+		result = wlc_lcnphy_calc_rx_iq_comp(pi, 0xffff);
 
-	wlc_lcnphy_clear_tx_power_offsets(pi);
+		wlc_lcnphy_stop_tx_tone(pi);
 
-	mod_phy_reg(pi, 0x4a6, (0x1 << 15), (1) << 15);
+		write_phy_reg(pi, 0x631, Core1TxControl_old);
 
-	mod_phy_reg(pi, 0x4a6, (0x1ff << 0), (0xff) << 0);
+		write_phy_reg(pi, 0x44c, RFOverrideVal0_old);
+		write_phy_reg(pi, 0x44d, RFOverrideVal0_old);
+		write_phy_reg(pi, 0x4b0, rfoverride2_old);
+		write_phy_reg(pi, 0x4b1, rfoverride2val_old);
+		write_phy_reg(pi, 0x4f9, rfoverride3_old);
+		write_phy_reg(pi, 0x4fa, rfoverride3val_old);
+		write_phy_reg(pi, 0x938, rfoverride4_old);
+		write_phy_reg(pi, 0x939, rfoverride4val_old);
+		write_phy_reg(pi, 0x43b, afectrlovr_old);
+		write_phy_reg(pi, 0x43c, afectrlovrval_old);
+		write_phy_reg(pi, 0x6da, old_sslpnCalibClkEnCtrl);
+		write_phy_reg(pi, 0x6db, old_sslpnRxFeClkEnCtrl);
 
-	mod_phy_reg(pi, 0x49a, (0x1ff << 0), (0xff) << 0);
+		wlc_lcnphy_clear_trsw_override(pi);
 
-	if (LCNREV_IS(pi->pubpi.phy_rev, 2)) {
-		mod_radio_reg(pi, RADIO_2064_REG028, 0xf, 0xe);
-		mod_radio_reg(pi, RADIO_2064_REG086, 0x4, 0x4);
-	} else {
-		mod_radio_reg(pi, RADIO_2064_REG03A, 0x1, 1);
-		mod_radio_reg(pi, RADIO_2064_REG11A, 0x8, 1 << 3);
-	}
+		mod_phy_reg(pi, 0x44c, (0x1 << 2), 0 << 2);
 
-	write_radio_reg(pi, RADIO_2064_REG025, 0xc);
+		for (i = 0; i < 11; i++)
+			write_radio_reg(pi, rxiq_cal_rf_reg[i],
+					values_to_save[i]);
 
-	if (LCNREV_IS(pi->pubpi.phy_rev, 2)) {
-		mod_radio_reg(pi, RADIO_2064_REG03A, 0x1, 1);
-	} else {
-		if (CHSPEC_IS2G(pi->radio_chanspec))
-			mod_radio_reg(pi, RADIO_2064_REG03A, 0x2, 1 << 1);
+		if (tx_gain_override_old)
+			wlc_lcnphy_set_tx_pwr_by_index(pi, tx_gain_index_old);
 		else
-			mod_radio_reg(pi, RADIO_2064_REG03A, 0x2, 0 << 1);
+			wlc_lcnphy_disable_tx_gain_override(pi);
+
+		wlc_lcnphy_set_tx_pwr_ctrl(pi, tx_pwr_ctrl);
+		wlc_lcnphy_rx_gain_override_enable(pi, false);
 	}
 
-	if (LCNREV_IS(pi->pubpi.phy_rev, 2))
-		mod_radio_reg(pi, RADIO_2064_REG03A, 0x2, 1 << 1);
-	else
-		mod_radio_reg(pi, RADIO_2064_REG03A, 0x4, 1 << 2);
+cal_done:
+	kfree(ptr);
+	return result;
+}
 
-	mod_radio_reg(pi, RADIO_2064_REG11A, 0x1, 1 << 0);
+s8 wlc_lcnphy_get_current_tx_pwr_idx(struct brcms_phy *pi)
+{
+	s8 index;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
-	mod_radio_reg(pi, RADIO_2064_REG005, 0x8, 1 << 3);
+	if (txpwrctrl_off(pi))
+		index = pi_lcn->lcnphy_current_index;
+	else if (wlc_lcnphy_tssi_based_pwr_ctrl_enabled(pi))
+		index =	(s8) (wlc_lcnphy_get_current_tx_pwr_idx_if_pwrctrl_on(
+			      pi) / 2);
+	else
+		index = pi_lcn->lcnphy_current_index;
+	return index;
+}
 
-	if (!wlc_lcnphy_tempsense_based_pwr_ctrl_enabled(pi))
-		mod_phy_reg(pi, 0x4d7,
-			    (0x1 << 3) | (0x7 << 12), 0 << 3 | 2 << 12);
+void wlc_lcnphy_crsuprs(struct brcms_phy *pi, int channel)
+{
+	u16 afectrlovr, afectrlovrval;
+	afectrlovr = read_phy_reg(pi, 0x43b);
+	afectrlovrval = read_phy_reg(pi, 0x43c);
+	if (channel != 0) {
+		mod_phy_reg(pi, 0x43b, (0x1 << 1), (1) << 1);
 
-	rfseq = wlc_lcnphy_rfseq_tbl_adc_pwrup(pi);
-	tab.tbl_id = LCNPHY_TBL_ID_RFSEQ;
-	tab.tbl_width = 16;
-	tab.tbl_ptr = &rfseq;
-	tab.tbl_len = 1;
-	tab.tbl_offset = 6;
-	wlc_lcnphy_write_table(pi, &tab);
+		mod_phy_reg(pi, 0x43c, (0x1 << 1), (0) << 1);
 
-	mod_phy_reg(pi, 0x938, (0x1 << 2), (1) << 2);
+		mod_phy_reg(pi, 0x43b, (0x1 << 4), (1) << 4);
 
-	mod_phy_reg(pi, 0x939, (0x1 << 2), (1) << 2);
+		mod_phy_reg(pi, 0x43c, (0x1 << 6), (0) << 6);
 
-	mod_phy_reg(pi, 0x4a4, (0x1 << 12), (1) << 12);
+		write_phy_reg(pi, 0x44b, 0xffff);
+		wlc_lcnphy_tx_pu(pi, 1);
 
-	mod_phy_reg(pi, 0x4d7, (0x1 << 2), (1) << 2);
+		mod_phy_reg(pi, 0x634, (0xff << 8), (0) << 8);
 
-	mod_phy_reg(pi, 0x4d7, (0xf << 8), (0) << 8);
+		or_phy_reg(pi, 0x6da, 0x0080);
 
-	wlc_lcnphy_pwrctrl_rssiparams(pi);
+		or_phy_reg(pi, 0x00a, 0x228);
+	} else {
+		and_phy_reg(pi, 0x00a, ~(0x228));
+
+		and_phy_reg(pi, 0x6da, 0xFF7F);
+		write_phy_reg(pi, 0x43b, afectrlovr);
+		write_phy_reg(pi, 0x43c, afectrlovrval);
+	}
 }
 
-void wlc_lcnphy_tx_pwr_update_npt(struct brcms_phy *pi)
+static void wlc_lcnphy_toggle_afe_pwdn(struct brcms_phy *pi)
 {
-	u16 tx_cnt, tx_total, npt;
-	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
-
-	tx_total = wlc_lcnphy_total_tx_frames(pi);
-	tx_cnt = tx_total - pi_lcn->lcnphy_tssi_tx_cnt;
-	npt = wlc_lcnphy_get_tx_pwr_npt(pi);
+	u16 save_AfeCtrlOvrVal, save_AfeCtrlOvr;
 
-	if (tx_cnt > (1 << npt)) {
+	save_AfeCtrlOvrVal = read_phy_reg(pi, 0x43c);
+	save_AfeCtrlOvr = read_phy_reg(pi, 0x43b);
 
-		pi_lcn->lcnphy_tssi_tx_cnt = tx_total;
+	write_phy_reg(pi, 0x43c, save_AfeCtrlOvrVal | 0x1);
+	write_phy_reg(pi, 0x43b, save_AfeCtrlOvr | 0x1);
 
-		pi_lcn->lcnphy_tssi_idx = wlc_lcnphy_get_current_tx_pwr_idx(pi);
-		pi_lcn->lcnphy_tssi_npt = npt;
+	write_phy_reg(pi, 0x43c, save_AfeCtrlOvrVal & 0xfffe);
+	write_phy_reg(pi, 0x43b, save_AfeCtrlOvr & 0xfffe);
 
-	}
+	write_phy_reg(pi, 0x43c, save_AfeCtrlOvrVal);
+	write_phy_reg(pi, 0x43b, save_AfeCtrlOvr);
 }
 
-s32 wlc_lcnphy_tssi2dbm(s32 tssi, s32 a1, s32 b0, s32 b1)
+static void
+wlc_lcnphy_txrx_spur_avoidance_mode(struct brcms_phy *pi, bool enable)
 {
-	s32 a, b, p;
-
-	a = 32768 + (a1 * tssi);
-	b = (1024 * b0) + (64 * b1 * tssi);
-	p = ((2 * b) + a) / (2 * a);
+	if (enable) {
+		write_phy_reg(pi, 0x942, 0x7);
+		write_phy_reg(pi, 0x93b, ((1 << 13) + 23));
+		write_phy_reg(pi, 0x93c, ((1 << 13) + 1989));
 
-	return p;
+		write_phy_reg(pi, 0x44a, 0x084);
+		write_phy_reg(pi, 0x44a, 0x080);
+		write_phy_reg(pi, 0x6d3, 0x2222);
+		write_phy_reg(pi, 0x6d3, 0x2220);
+	} else {
+		write_phy_reg(pi, 0x942, 0x0);
+		write_phy_reg(pi, 0x93b, ((0 << 13) + 23));
+		write_phy_reg(pi, 0x93c, ((0 << 13) + 1989));
+	}
+	wlapi_switch_macfreq(pi->sh->physhim, enable);
 }
 
-static void wlc_lcnphy_txpower_reset_npt(struct brcms_phy *pi)
+static void
+wlc_lcnphy_set_chanspec_tweaks(struct brcms_phy *pi, u16 chanspec)
 {
+	u8 channel = CHSPEC_CHANNEL(chanspec);
 	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
-	if (wlc_lcnphy_tempsense_based_pwr_ctrl_enabled(pi))
-		return;
 
-	pi_lcn->lcnphy_tssi_idx = LCNPHY_TX_PWR_CTRL_START_INDEX_2G_4313;
-	pi_lcn->lcnphy_tssi_npt = LCNPHY_TX_PWR_CTRL_START_NPT;
-}
+	if (channel == 14)
+		mod_phy_reg(pi, 0x448, (0x3 << 8), (2) << 8);
+	else
+		mod_phy_reg(pi, 0x448, (0x3 << 8), (1) << 8);
 
-void wlc_lcnphy_txpower_recalc_target(struct brcms_phy *pi)
-{
-	struct phytbl_info tab;
-	u32 rate_table[BRCMS_NUM_RATES_CCK + BRCMS_NUM_RATES_OFDM +
-		       BRCMS_NUM_RATES_MCS_1_STREAM];
-	uint i, j;
-	if (wlc_lcnphy_tempsense_based_pwr_ctrl_enabled(pi))
-		return;
+	pi_lcn->lcnphy_bandedge_corr = 2;
+	if (channel == 1)
+		pi_lcn->lcnphy_bandedge_corr = 4;
 
-	for (i = 0, j = 0; i < ARRAY_SIZE(rate_table); i++, j++) {
+	if (channel == 1 || channel == 2 || channel == 3 ||
+	    channel == 4 || channel == 9 ||
+	    channel == 10 || channel == 11 || channel == 12) {
+		si_pmu_pllcontrol(pi->sh->sih, 0x2, 0xffffffff, 0x03000c04);
+		si_pmu_pllcontrol(pi->sh->sih, 0x3, 0xffffff, 0x0);
+		si_pmu_pllcontrol(pi->sh->sih, 0x4, 0xffffffff, 0x200005c0);
 
-		if (i == BRCMS_NUM_RATES_CCK + BRCMS_NUM_RATES_OFDM)
-			j = TXP_FIRST_MCS_20_SISO;
+		si_pmu_pllupd(pi->sh->sih);
+		write_phy_reg(pi, 0x942, 0);
+		wlc_lcnphy_txrx_spur_avoidance_mode(pi, false);
+		pi_lcn->lcnphy_spurmod = 0;
+		mod_phy_reg(pi, 0x424, (0xff << 8), (0x1b) << 8);
 
-		rate_table[i] = (u32) ((s32) (-pi->tx_power_offset[j]));
-	}
+		write_phy_reg(pi, 0x425, 0x5907);
+	} else {
+		si_pmu_pllcontrol(pi->sh->sih, 0x2, 0xffffffff, 0x03140c04);
+		si_pmu_pllcontrol(pi->sh->sih, 0x3, 0xffffff, 0x333333);
+		si_pmu_pllcontrol(pi->sh->sih, 0x4, 0xffffffff, 0x202c2820);
 
-	tab.tbl_id = LCNPHY_TBL_ID_TXPWRCTL;
-	tab.tbl_width = 32;
-	tab.tbl_len = ARRAY_SIZE(rate_table);
-	tab.tbl_ptr = rate_table;
-	tab.tbl_offset = LCNPHY_TX_PWR_CTRL_RATE_OFFSET;
-	wlc_lcnphy_write_table(pi, &tab);
+		si_pmu_pllupd(pi->sh->sih);
+		write_phy_reg(pi, 0x942, 0);
+		wlc_lcnphy_txrx_spur_avoidance_mode(pi, true);
 
-	if (wlc_lcnphy_get_target_tx_pwr(pi) != pi->tx_power_min) {
-		wlc_lcnphy_set_target_tx_pwr(pi, pi->tx_power_min);
+		pi_lcn->lcnphy_spurmod = 0;
+		mod_phy_reg(pi, 0x424, (0xff << 8), (0x1f) << 8);
 
-		wlc_lcnphy_txpower_reset_npt(pi);
+		write_phy_reg(pi, 0x425, 0x590a);
 	}
+
+	or_phy_reg(pi, 0x44a, 0x44);
+	write_phy_reg(pi, 0x44a, 0x80);
 }
 
-static void wlc_lcnphy_set_tx_pwr_soft_ctrl(struct brcms_phy *pi, s8 index)
+static void
+wlc_lcnphy_radio_2064_channel_tune_4313(struct brcms_phy *pi, u8 channel)
 {
-	u32 cck_offset[4] = { 22, 22, 22, 22 };
-	u32 ofdm_offset, reg_offset_cck;
-	int i;
-	u16 index2;
-	struct phytbl_info tab;
-
-	if (wlc_lcnphy_tssi_based_pwr_ctrl_enabled(pi))
-		return;
-
-	mod_phy_reg(pi, 0x4a4, (0x1 << 14), (0x1) << 14);
+	uint i;
+	const struct chan_info_2064_lcnphy *ci;
+	u8 rfpll_doubler = 0;
+	u8 pll_pwrup, pll_pwrup_ovr;
+	s32 qFxtal, qFref, qFvco, qFcal;
+	u8 d15, d16, f16, e44, e45;
+	u32 div_int, div_frac, fvco3, fpfd, fref3, fcal_div;
+	u16 loop_bw, d30, setCount;
 
-	mod_phy_reg(pi, 0x4a4, (0x1 << 14), (0x0) << 14);
+	ci = &chan_info_2064_lcnphy[0];
+	rfpll_doubler = 1;
 
-	or_phy_reg(pi, 0x6da, 0x0040);
+	mod_radio_reg(pi, RADIO_2064_REG09D, 0x4, 0x1 << 2);
 
-	reg_offset_cck = 0;
-	for (i = 0; i < 4; i++)
-		cck_offset[i] -= reg_offset_cck;
-	tab.tbl_id = LCNPHY_TBL_ID_TXPWRCTL;
-	tab.tbl_width = 32;
-	tab.tbl_len = 4;
-	tab.tbl_ptr = cck_offset;
-	tab.tbl_offset = LCNPHY_TX_PWR_CTRL_RATE_OFFSET;
-	wlc_lcnphy_write_table(pi, &tab);
-	ofdm_offset = 0;
-	tab.tbl_len = 1;
-	tab.tbl_ptr = &ofdm_offset;
-	for (i = 836; i < 862; i++) {
-		tab.tbl_offset = i;
-		wlc_lcnphy_write_table(pi, &tab);
+	write_radio_reg(pi, RADIO_2064_REG09E, 0xf);
+	if (!rfpll_doubler) {
+		loop_bw = PLL_2064_LOOP_BW;
+		d30 = PLL_2064_D30;
+	} else {
+		loop_bw = PLL_2064_LOOP_BW_DOUBLER;
+		d30 = PLL_2064_D30_DOUBLER;
 	}
 
-	mod_phy_reg(pi, 0x4a4, (0x1 << 15), (0x1) << 15);
+	if (CHSPEC_IS2G(pi->radio_chanspec)) {
+		for (i = 0; i < ARRAY_SIZE(chan_info_2064_lcnphy); i++)
+			if (chan_info_2064_lcnphy[i].chan == channel)
+				break;
 
-	mod_phy_reg(pi, 0x4a4, (0x1 << 14), (0x1) << 14);
+		if (i >= ARRAY_SIZE(chan_info_2064_lcnphy))
+			return;
 
-	mod_phy_reg(pi, 0x4a4, (0x1 << 13), (0x1) << 13);
+		ci = &chan_info_2064_lcnphy[i];
+	}
 
-	mod_phy_reg(pi, 0x4b0, (0x1 << 7), (0) << 7);
+	write_radio_reg(pi, RADIO_2064_REG02A, ci->logen_buftune);
 
-	mod_phy_reg(pi, 0x43b, (0x1 << 6), (0) << 6);
+	mod_radio_reg(pi, RADIO_2064_REG030, 0x3, ci->logen_rccr_tx);
 
-	mod_phy_reg(pi, 0x4a9, (0x1 << 15), (1) << 15);
+	mod_radio_reg(pi, RADIO_2064_REG091, 0x3, ci->txrf_mix_tune_ctrl);
 
-	index2 = (u16) (index * 2);
-	mod_phy_reg(pi, 0x4a9, (0x1ff << 0), (index2) << 0);
+	mod_radio_reg(pi, RADIO_2064_REG038, 0xf, ci->pa_input_tune_g);
 
-	mod_phy_reg(pi, 0x6a3, (0x1 << 4), (0) << 4);
+	mod_radio_reg(pi, RADIO_2064_REG030, 0x3 << 2,
+		      (ci->logen_rccr_rx) << 2);
 
-}
+	mod_radio_reg(pi, RADIO_2064_REG05E, 0xf, ci->pa_rxrf_lna1_freq_tune);
 
-static s8 wlc_lcnphy_tempcompensated_txpwrctrl(struct brcms_phy *pi)
-{
-	s8 index, delta_brd, delta_temp, new_index, tempcorrx;
-	s16 manp, meas_temp, temp_diff;
-	bool neg = 0;
-	u16 temp;
-	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	mod_radio_reg(pi, RADIO_2064_REG05E, (0xf) << 4,
+		      (ci->pa_rxrf_lna2_freq_tune) << 4);
 
-	if (wlc_lcnphy_tssi_based_pwr_ctrl_enabled(pi))
-		return pi_lcn->lcnphy_current_index;
+	write_radio_reg(pi, RADIO_2064_REG06C, ci->rxrf_rxrf_spare1);
 
-	index = FIXED_TXPWR;
+	pll_pwrup = (u8) read_radio_reg(pi, RADIO_2064_REG044);
+	pll_pwrup_ovr = (u8) read_radio_reg(pi, RADIO_2064_REG12B);
 
-	if (pi_lcn->lcnphy_tempsense_slope == 0)
-		return index;
+	or_radio_reg(pi, RADIO_2064_REG044, 0x07);
 
-	temp = (u16) wlc_lcnphy_tempsense(pi, 0);
-	meas_temp = LCNPHY_TEMPSENSE(temp);
+	or_radio_reg(pi, RADIO_2064_REG12B, (0x07) << 1);
+	e44 = 0;
+	e45 = 0;
 
-	if (pi->tx_power_min != 0)
-		delta_brd = (pi_lcn->lcnphy_measPower - pi->tx_power_min);
+	fpfd = rfpll_doubler ? (pi->xtalfreq << 1) : (pi->xtalfreq);
+	if (pi->xtalfreq > 26000000)
+		e44 = 1;
+	if (pi->xtalfreq > 52000000)
+		e45 = 1;
+	if (e44 == 0)
+		fcal_div = 1;
+	else if (e45 == 0)
+		fcal_div = 2;
 	else
-		delta_brd = 0;
+		fcal_div = 4;
+	fvco3 = (ci->freq * 3);
+	fref3 = 2 * fpfd;
 
-	manp = LCNPHY_TEMPSENSE(pi_lcn->lcnphy_rawtempsense);
-	temp_diff = manp - meas_temp;
-	if (temp_diff < 0) {
-		neg = 1;
-		temp_diff = -temp_diff;
-	}
+	qFxtal = wlc_lcnphy_qdiv_roundup(pi->xtalfreq, PLL_2064_MHZ, 16);
+	qFref = wlc_lcnphy_qdiv_roundup(fpfd, PLL_2064_MHZ, 16);
+	qFcal = pi->xtalfreq * fcal_div / PLL_2064_MHZ;
+	qFvco = wlc_lcnphy_qdiv_roundup(fvco3, 2, 16);
 
-	delta_temp = (s8) wlc_lcnphy_qdiv_roundup((u32) (temp_diff * 192),
-						  (u32) (pi_lcn->
-							 lcnphy_tempsense_slope
-							 * 10), 0);
-	if (neg)
-		delta_temp = -delta_temp;
+	write_radio_reg(pi, RADIO_2064_REG04F, 0x02);
 
-	if (pi_lcn->lcnphy_tempsense_option == 3
-	    && LCNREV_IS(pi->pubpi.phy_rev, 0))
-		delta_temp = 0;
-	if (pi_lcn->lcnphy_tempcorrx > 31)
-		tempcorrx = (s8) (pi_lcn->lcnphy_tempcorrx - 64);
-	else
-		tempcorrx = (s8) pi_lcn->lcnphy_tempcorrx;
-	if (LCNREV_IS(pi->pubpi.phy_rev, 1))
-		tempcorrx = 4;
-	new_index =
-		index + delta_brd + delta_temp - pi_lcn->lcnphy_bandedge_corr;
-	new_index += tempcorrx;
+	d15 = (pi->xtalfreq * fcal_div * 4 / 5) / PLL_2064_MHZ - 1;
+	write_radio_reg(pi, RADIO_2064_REG052, (0x07 & (d15 >> 2)));
+	write_radio_reg(pi, RADIO_2064_REG053, (d15 & 0x3) << 5);
 
-	if (LCNREV_IS(pi->pubpi.phy_rev, 1))
-		index = 127;
+	d16 = (qFcal * 8 / (d15 + 1)) - 1;
+	write_radio_reg(pi, RADIO_2064_REG051, d16);
 
-	if (new_index < 0 || new_index > 126)
-		return index;
+	f16 = ((d16 + 1) * (d15 + 1)) / qFcal;
+	setCount = f16 * 3 * (ci->freq) / 32 - 1;
+	mod_radio_reg(pi, RADIO_2064_REG053, (0x0f << 0),
+		      (u8) (setCount >> 8));
 
-	return new_index;
-}
+	or_radio_reg(pi, RADIO_2064_REG053, 0x10);
+	write_radio_reg(pi, RADIO_2064_REG054, (u8) (setCount & 0xff));
 
-static u16 wlc_lcnphy_set_tx_pwr_ctrl_mode(struct brcms_phy *pi, u16 mode)
-{
+	div_int = ((fvco3 * (PLL_2064_MHZ >> 4)) / fref3) << 4;
 
-	u16 current_mode = mode;
-	if (wlc_lcnphy_tempsense_based_pwr_ctrl_enabled(pi) &&
-	    mode == LCNPHY_TX_PWR_CTRL_HW)
-		current_mode = LCNPHY_TX_PWR_CTRL_TEMPBASED;
-	if (wlc_lcnphy_tssi_based_pwr_ctrl_enabled(pi) &&
-	    mode == LCNPHY_TX_PWR_CTRL_TEMPBASED)
-		current_mode = LCNPHY_TX_PWR_CTRL_HW;
-	return current_mode;
-}
+	div_frac = ((fvco3 * (PLL_2064_MHZ >> 4)) % fref3) << 4;
+	while (div_frac >= fref3) {
+		div_int++;
+		div_frac -= fref3;
+	}
+	div_frac = wlc_lcnphy_qdiv_roundup(div_frac, fref3, 20);
 
-void wlc_lcnphy_set_tx_pwr_ctrl(struct brcms_phy *pi, u16 mode)
-{
-	u16 old_mode = wlc_lcnphy_get_tx_pwr_ctrl(pi);
-	s8 index;
-	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	mod_radio_reg(pi, RADIO_2064_REG045, (0x1f << 0),
+		      (u8) (div_int >> 4));
+	mod_radio_reg(pi, RADIO_2064_REG046, (0x1f << 4),
+		      (u8) (div_int << 4));
+	mod_radio_reg(pi, RADIO_2064_REG046, (0x0f << 0),
+		      (u8) (div_frac >> 16));
+	write_radio_reg(pi, RADIO_2064_REG047, (u8) (div_frac >> 8) & 0xff);
+	write_radio_reg(pi, RADIO_2064_REG048, (u8) div_frac & 0xff);
 
-	mode = wlc_lcnphy_set_tx_pwr_ctrl_mode(pi, mode);
-	old_mode = wlc_lcnphy_set_tx_pwr_ctrl_mode(pi, old_mode);
+	write_radio_reg(pi, RADIO_2064_REG040, 0xfb);
 
-	mod_phy_reg(pi, 0x6da, (0x1 << 6),
-		    ((LCNPHY_TX_PWR_CTRL_HW == mode) ? 1 : 0) << 6);
+	write_radio_reg(pi, RADIO_2064_REG041, 0x9A);
+	write_radio_reg(pi, RADIO_2064_REG042, 0xA3);
+	write_radio_reg(pi, RADIO_2064_REG043, 0x0C);
 
-	mod_phy_reg(pi, 0x6a3, (0x1 << 4),
-		    ((LCNPHY_TX_PWR_CTRL_HW == mode) ? 0 : 1) << 4);
+	{
+		u8 h29, h23, c28, d29, h28_ten, e30, h30_ten, cp_current;
+		u16 c29, c38, c30, g30, d28;
+		c29 = loop_bw;
+		d29 = 200;
+		c38 = 1250;
+		h29 = d29 / c29;
+		h23 = 1;
+		c28 = 30;
+		d28 = (((PLL_2064_HIGH_END_KVCO - PLL_2064_LOW_END_KVCO) *
+			(fvco3 / 2 - PLL_2064_LOW_END_VCO)) /
+		       (PLL_2064_HIGH_END_VCO - PLL_2064_LOW_END_VCO))
+		      + PLL_2064_LOW_END_KVCO;
+		h28_ten = (d28 * 10) / c28;
+		c30 = 2640;
+		e30 = (d30 - 680) / 490;
+		g30 = 680 + (e30 * 490);
+		h30_ten = (g30 * 10) / c30;
+		cp_current = ((c38 * h29 * h23 * 100) / h28_ten) / h30_ten;
+		mod_radio_reg(pi, RADIO_2064_REG03C, 0x3f, cp_current);
+	}
+	if (channel >= 1 && channel <= 5)
+		write_radio_reg(pi, RADIO_2064_REG03C, 0x8);
+	else
+		write_radio_reg(pi, RADIO_2064_REG03C, 0x7);
+	write_radio_reg(pi, RADIO_2064_REG03D, 0x3);
 
-	if (old_mode != mode) {
-		if (LCNPHY_TX_PWR_CTRL_HW == old_mode) {
+	mod_radio_reg(pi, RADIO_2064_REG044, 0x0c, 0x0c);
+	udelay(1);
 
-			wlc_lcnphy_tx_pwr_update_npt(pi);
+	wlc_2064_vco_cal(pi);
 
-			wlc_lcnphy_clear_tx_power_offsets(pi);
-		}
-		if (LCNPHY_TX_PWR_CTRL_HW == mode) {
+	write_radio_reg(pi, RADIO_2064_REG044, pll_pwrup);
+	write_radio_reg(pi, RADIO_2064_REG12B, pll_pwrup_ovr);
+	if (LCNREV_IS(pi->pubpi.phy_rev, 1)) {
+		write_radio_reg(pi, RADIO_2064_REG038, 3);
+		write_radio_reg(pi, RADIO_2064_REG091, 7);
+	}
+}
 
-			wlc_lcnphy_txpower_recalc_target(pi);
+static int
+wlc_lcnphy_load_tx_iir_filter(struct brcms_phy *pi, bool is_ofdm, s16 filt_type)
+{
+	s16 filt_index = -1;
+	int j;
 
-			wlc_lcnphy_set_start_tx_pwr_idx(pi,
-							pi_lcn->
-							lcnphy_tssi_idx);
-			wlc_lcnphy_set_tx_pwr_npt(pi, pi_lcn->lcnphy_tssi_npt);
-			mod_radio_reg(pi, RADIO_2064_REG11F, 0x4, 0);
+	u16 addr[] = {
+		0x910,
+		0x91e,
+		0x91f,
+		0x924,
+		0x925,
+		0x926,
+		0x920,
+		0x921,
+		0x927,
+		0x928,
+		0x929,
+		0x922,
+		0x923,
+		0x930,
+		0x931,
+		0x932
+	};
 
-			pi_lcn->lcnphy_tssi_tx_cnt =
-				wlc_lcnphy_total_tx_frames(pi);
+	u16 addr_ofdm[] = {
+		0x90f,
+		0x900,
+		0x901,
+		0x906,
+		0x907,
+		0x908,
+		0x902,
+		0x903,
+		0x909,
+		0x90a,
+		0x90b,
+		0x904,
+		0x905,
+		0x90c,
+		0x90d,
+		0x90e
+	};
 
-			wlc_lcnphy_disable_tx_gain_override(pi);
-			pi_lcn->lcnphy_tx_power_idx_override = -1;
-		} else
-			wlc_lcnphy_enable_tx_gain_override(pi);
+	if (!is_ofdm) {
+		for (j = 0; j < LCNPHY_NUM_TX_DIG_FILTERS_CCK; j++) {
+			if (filt_type == LCNPHY_txdigfiltcoeffs_cck[j][0]) {
+				filt_index = (s16) j;
+				break;
+			}
+		}
 
-		mod_phy_reg(pi, 0x4a4,
-			    ((0x1 << 15) | (0x1 << 14) | (0x1 << 13)), mode);
-		if (mode == LCNPHY_TX_PWR_CTRL_TEMPBASED) {
-			index = wlc_lcnphy_tempcompensated_txpwrctrl(pi);
-			wlc_lcnphy_set_tx_pwr_soft_ctrl(pi, index);
-			pi_lcn->lcnphy_current_index = (s8)
-						       ((read_phy_reg(pi,
-								      0x4a9) &
-							 0xFF) / 2);
+		if (filt_index != -1) {
+			for (j = 0; j < LCNPHY_NUM_DIG_FILT_COEFFS; j++)
+				write_phy_reg(pi, addr[j],
+					      LCNPHY_txdigfiltcoeffs_cck
+					      [filt_index][j + 1]);
+		}
+	} else {
+		for (j = 0; j < LCNPHY_NUM_TX_DIG_FILTERS_OFDM; j++) {
+			if (filt_type == LCNPHY_txdigfiltcoeffs_ofdm[j][0]) {
+				filt_index = (s16) j;
+				break;
+			}
+		}
+
+		if (filt_index != -1) {
+			for (j = 0; j < LCNPHY_NUM_DIG_FILT_COEFFS; j++)
+				write_phy_reg(pi, addr_ofdm[j],
+					      LCNPHY_txdigfiltcoeffs_ofdm
+					      [filt_index][j + 1]);
 		}
 	}
+
+	return (filt_index != -1) ? 0 : -1;
 }
 
-static bool wlc_lcnphy_iqcal_wait(struct brcms_phy *pi)
+void wlc_phy_chanspec_set_lcnphy(struct brcms_phy *pi, u16 chanspec)
 {
-	uint delay_count = 0;
+	u8 channel = CHSPEC_CHANNEL(chanspec);
 
-	while (wlc_lcnphy_iqcal_active(pi)) {
-		udelay(100);
-		delay_count++;
+	wlc_phy_chanspec_radio_set((struct brcms_phy_pub *) pi, chanspec);
 
-		if (delay_count > (10 * 500))
-			break;
-	}
+	wlc_lcnphy_set_chanspec_tweaks(pi, pi->radio_chanspec);
 
-	return (0 == wlc_lcnphy_iqcal_active(pi));
-}
+	or_phy_reg(pi, 0x44a, 0x44);
+	write_phy_reg(pi, 0x44a, 0x80);
 
-static void
-wlc_lcnphy_tx_iqlo_cal(struct brcms_phy *pi,
-		       struct lcnphy_txgains *target_gains,
-		       enum lcnphy_cal_mode cal_mode, bool keep_tone)
-{
+	wlc_lcnphy_radio_2064_channel_tune_4313(pi, channel);
+	udelay(1000);
 
-	struct lcnphy_txgains cal_gains, temp_gains;
-	u16 hash;
-	u8 band_idx;
-	int j;
-	u16 ncorr_override[5];
-	u16 syst_coeffs[] = { 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
-			      0x0000, 0x0000, 0x0000, 0x0000, 0x0000};
+	wlc_lcnphy_toggle_afe_pwdn(pi);
 
-	u16 commands_fullcal[] = {
-		0x8434, 0x8334, 0x8084, 0x8267, 0x8056, 0x8234
-	};
+	write_phy_reg(pi, 0x657, lcnphy_sfo_cfg[channel - 1].ptcentreTs20);
+	write_phy_reg(pi, 0x658, lcnphy_sfo_cfg[channel - 1].ptcentreFactor);
 
-	u16 commands_recal[] = {
-		0x8434, 0x8334, 0x8084, 0x8267, 0x8056, 0x8234
-	};
+	if (CHSPEC_CHANNEL(pi->radio_chanspec) == 14) {
+		mod_phy_reg(pi, 0x448, (0x3 << 8), (2) << 8);
 
-	u16 command_nums_fullcal[] = {
-		0x7a97, 0x7a97, 0x7a97, 0x7a87, 0x7a87, 0x7b97
-	};
+		wlc_lcnphy_load_tx_iir_filter(pi, false, 3);
+	} else {
+		mod_phy_reg(pi, 0x448, (0x3 << 8), (1) << 8);
 
-	u16 command_nums_recal[] = {
-		0x7a97, 0x7a97, 0x7a97, 0x7a87, 0x7a87, 0x7b97
-	};
-	u16 *command_nums = command_nums_fullcal;
+		wlc_lcnphy_load_tx_iir_filter(pi, false, 2);
+	}
 
-	u16 *start_coeffs = NULL, *cal_cmds = NULL, cal_type, diq_start;
-	u16 tx_pwr_ctrl_old, save_txpwrctrlrfctrl2;
-	u16 save_sslpnCalibClkEnCtrl, save_sslpnRxFeClkEnCtrl;
-	bool tx_gain_override_old;
-	struct lcnphy_txgains old_gains;
-	uint i, n_cal_cmds = 0, n_cal_start = 0;
-	u16 *values_to_save;
-	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	wlc_lcnphy_load_tx_iir_filter(pi, true, 0);
 
-	values_to_save = kmalloc(sizeof(u16) * 20, GFP_ATOMIC);
-	if (NULL == values_to_save)
-		return;
+	mod_phy_reg(pi, 0x4eb, (0x7 << 3), (1) << 3);
 
-	save_sslpnRxFeClkEnCtrl = read_phy_reg(pi, 0x6db);
-	save_sslpnCalibClkEnCtrl = read_phy_reg(pi, 0x6da);
+}
 
-	or_phy_reg(pi, 0x6da, 0x40);
-	or_phy_reg(pi, 0x6db, 0x3);
+static u16 wlc_lcnphy_get_pa_gain(struct brcms_phy *pi)
+{
+	u16 pa_gain;
 
-	switch (cal_mode) {
-	case LCNPHY_CAL_FULL:
-		start_coeffs = syst_coeffs;
-		cal_cmds = commands_fullcal;
-		n_cal_cmds = ARRAY_SIZE(commands_fullcal);
-		break;
+	pa_gain = (read_phy_reg(pi, 0x4fb) &
+		   LCNPHY_txgainctrlovrval1_pagain_ovr_val1_MASK) >>
+		  LCNPHY_txgainctrlovrval1_pagain_ovr_val1_SHIFT;
 
-	case LCNPHY_CAL_RECAL:
-		start_coeffs = syst_coeffs;
-		cal_cmds = commands_recal;
-		n_cal_cmds = ARRAY_SIZE(commands_recal);
-		command_nums = command_nums_recal;
-		break;
+	return pa_gain;
+}
 
-	default:
-		break;
-	}
+static void wlc_lcnphy_set_tx_gain(struct brcms_phy *pi,
+				   struct lcnphy_txgains *target_gains)
+{
+	u16 pa_gain = wlc_lcnphy_get_pa_gain(pi);
 
-	wlc_lcnphy_common_write_table(pi, LCNPHY_TBL_ID_IQLOCAL,
-				      start_coeffs, 11, 16, 64);
+	mod_phy_reg(
+		pi, 0x4b5,
+		(0xffff << 0),
+		((target_gains->gm_gain) |
+		 (target_gains->pga_gain << 8)) <<
+		0);
+	mod_phy_reg(pi, 0x4fb,
+		    (0x7fff << 0),
+		    ((target_gains->pad_gain) | (pa_gain << 8)) << 0);
 
-	write_phy_reg(pi, 0x6da, 0xffff);
-	mod_phy_reg(pi, 0x503, (0x1 << 3), (1) << 3);
+	mod_phy_reg(
+		pi, 0x4fc,
+		(0xffff << 0),
+		((target_gains->gm_gain) |
+		 (target_gains->pga_gain << 8)) <<
+		0);
+	mod_phy_reg(pi, 0x4fd,
+		    (0x7fff << 0),
+		    ((target_gains->pad_gain) | (pa_gain << 8)) << 0);
 
-	tx_pwr_ctrl_old = wlc_lcnphy_get_tx_pwr_ctrl(pi);
+	wlc_lcnphy_set_dac_gain(pi, target_gains->dac_gain);
 
-	mod_phy_reg(pi, 0x4a4, (0x1 << 12), (1) << 12);
+	wlc_lcnphy_enable_tx_gain_override(pi);
+}
 
-	wlc_lcnphy_set_tx_pwr_ctrl(pi, LCNPHY_TX_PWR_CTRL_OFF);
+static void wlc_lcnphy_set_bbmult(struct brcms_phy *pi, u8 m0)
+{
+	u16 m0m1 = (u16) m0 << 8;
+	struct phytbl_info tab;
 
-	save_txpwrctrlrfctrl2 = read_phy_reg(pi, 0x4db);
+	tab.tbl_ptr = &m0m1;
+	tab.tbl_len = 1;
+	tab.tbl_id = LCNPHY_TBL_ID_IQLOCAL;
+	tab.tbl_offset = 87;
+	tab.tbl_width = 16;
+	wlc_lcnphy_write_table(pi, &tab);
+}
 
-	mod_phy_reg(pi, 0x4db, (0x3ff << 0), (0x2a6) << 0);
+static void wlc_lcnphy_clear_tx_power_offsets(struct brcms_phy *pi)
+{
+	u32 data_buf[64];
+	struct phytbl_info tab;
 
-	mod_phy_reg(pi, 0x4db, (0x7 << 12), (2) << 12);
+	memset(data_buf, 0, sizeof(data_buf));
 
-	wlc_lcnphy_tx_iqlo_loopback(pi, values_to_save);
+	tab.tbl_id = LCNPHY_TBL_ID_TXPWRCTL;
+	tab.tbl_width = 32;
+	tab.tbl_ptr = data_buf;
 
-	tx_gain_override_old = wlc_lcnphy_tx_gain_override_enabled(pi);
-	if (tx_gain_override_old)
-		wlc_lcnphy_get_tx_gain(pi, &old_gains);
+	if (!wlc_lcnphy_tempsense_based_pwr_ctrl_enabled(pi)) {
 
-	if (!target_gains) {
-		if (!tx_gain_override_old)
-			wlc_lcnphy_set_tx_pwr_by_index(pi,
-						       pi_lcn->lcnphy_tssi_idx);
-		wlc_lcnphy_get_tx_gain(pi, &temp_gains);
-		target_gains = &temp_gains;
+		tab.tbl_len = 30;
+		tab.tbl_offset = LCNPHY_TX_PWR_CTRL_RATE_OFFSET;
+		wlc_lcnphy_write_table(pi, &tab);
 	}
 
-	hash = (target_gains->gm_gain << 8) |
-	       (target_gains->pga_gain << 4) | (target_gains->pad_gain);
+	tab.tbl_len = 64;
+	tab.tbl_offset = LCNPHY_TX_PWR_CTRL_MAC_OFFSET;
+	wlc_lcnphy_write_table(pi, &tab);
+}
 
-	band_idx = (CHSPEC_IS5G(pi->radio_chanspec) ? 1 : 0);
+enum lcnphy_tssi_mode {
+	LCNPHY_TSSI_PRE_PA,
+	LCNPHY_TSSI_POST_PA,
+	LCNPHY_TSSI_EXT
+};
 
-	cal_gains = *target_gains;
-	memset(ncorr_override, 0, sizeof(ncorr_override));
-	for (j = 0; j < iqcal_gainparams_numgains_lcnphy[band_idx]; j++) {
-		if (hash == tbl_iqcal_gainparams_lcnphy[band_idx][j][0]) {
-			cal_gains.gm_gain =
-				tbl_iqcal_gainparams_lcnphy[band_idx][j][1];
-			cal_gains.pga_gain =
-				tbl_iqcal_gainparams_lcnphy[band_idx][j][2];
-			cal_gains.pad_gain =
-				tbl_iqcal_gainparams_lcnphy[band_idx][j][3];
-			memcpy(ncorr_override,
-			       &tbl_iqcal_gainparams_lcnphy[band_idx][j][3],
-			       sizeof(ncorr_override));
-			break;
-		}
-	}
+static void
+wlc_lcnphy_set_tssi_mux(struct brcms_phy *pi, enum lcnphy_tssi_mode pos)
+{
+	mod_phy_reg(pi, 0x4d7, (0x1 << 0), (0x1) << 0);
 
-	wlc_lcnphy_set_tx_gain(pi, &cal_gains);
+	mod_phy_reg(pi, 0x4d7, (0x1 << 6), (1) << 6);
 
-	write_phy_reg(pi, 0x453, 0xaa9);
-	write_phy_reg(pi, 0x93d, 0xc0);
+	if (LCNPHY_TSSI_POST_PA == pos) {
+		mod_phy_reg(pi, 0x4d9, (0x1 << 2), (0) << 2);
 
-	wlc_lcnphy_common_write_table(pi, LCNPHY_TBL_ID_IQLOCAL,
-				      lcnphy_iqcal_loft_gainladder,
-				      ARRAY_SIZE(lcnphy_iqcal_loft_gainladder),
-				      16, 0);
+		mod_phy_reg(pi, 0x4d9, (0x1 << 3), (1) << 3);
 
-	wlc_lcnphy_common_write_table(pi, LCNPHY_TBL_ID_IQLOCAL,
-				      lcnphy_iqcal_ir_gainladder,
-				      ARRAY_SIZE(
-					      lcnphy_iqcal_ir_gainladder), 16,
-				      32);
+		if (LCNREV_IS(pi->pubpi.phy_rev, 2)) {
+			mod_radio_reg(pi, RADIO_2064_REG086, 0x4, 0x4);
+		} else {
+			mod_radio_reg(pi, RADIO_2064_REG03A, 1, 0x1);
+			mod_radio_reg(pi, RADIO_2064_REG11A, 0x8, 0x8);
+		}
+	} else {
+		mod_phy_reg(pi, 0x4d9, (0x1 << 2), (0x1) << 2);
 
-	if (pi->phy_tx_tone_freq) {
+		mod_phy_reg(pi, 0x4d9, (0x1 << 3), (0) << 3);
 
-		wlc_lcnphy_stop_tx_tone(pi);
-		udelay(5);
-		wlc_lcnphy_start_tx_tone(pi, 3750, 88, 1);
-	} else {
-		wlc_lcnphy_start_tx_tone(pi, 3750, 88, 1);
+		if (LCNREV_IS(pi->pubpi.phy_rev, 2)) {
+			mod_radio_reg(pi, RADIO_2064_REG086, 0x4, 0x4);
+		} else {
+			mod_radio_reg(pi, RADIO_2064_REG03A, 1, 0);
+			mod_radio_reg(pi, RADIO_2064_REG11A, 0x8, 0x8);
+		}
 	}
+	mod_phy_reg(pi, 0x637, (0x3 << 14), (0) << 14);
 
-	write_phy_reg(pi, 0x6da, 0xffff);
+	if (LCNPHY_TSSI_EXT == pos) {
+		write_radio_reg(pi, RADIO_2064_REG07F, 1);
+		mod_radio_reg(pi, RADIO_2064_REG005, 0x7, 0x2);
+		mod_radio_reg(pi, RADIO_2064_REG112, 0x80, 0x1 << 7);
+		mod_radio_reg(pi, RADIO_2064_REG028, 0x1f, 0x3);
+	}
+}
 
-	for (i = n_cal_start; i < n_cal_cmds; i++) {
-		u16 zero_diq = 0;
-		u16 best_coeffs[11];
-		u16 command_num;
+static u16 wlc_lcnphy_rfseq_tbl_adc_pwrup(struct brcms_phy *pi)
+{
+	u16 N1, N2, N3, N4, N5, N6, N;
+	N1 = ((read_phy_reg(pi, 0x4a5) & (0xff << 0))
+	      >> 0);
+	N2 = 1 << ((read_phy_reg(pi, 0x4a5) & (0x7 << 12))
+		   >> 12);
+	N3 = ((read_phy_reg(pi, 0x40d) & (0xff << 0))
+	      >> 0);
+	N4 = 1 << ((read_phy_reg(pi, 0x40d) & (0x7 << 8))
+		   >> 8);
+	N5 = ((read_phy_reg(pi, 0x4a2) & (0xff << 0))
+	      >> 0);
+	N6 = 1 << ((read_phy_reg(pi, 0x4a2) & (0x7 << 8))
+		   >> 8);
+	N = 2 * (N1 + N2 + N3 + N4 + 2 * (N5 + N6)) + 80;
+	if (N < 1600)
+		N = 1600;
+	return N;
+}
 
-		cal_type = (cal_cmds[i] & 0x0f00) >> 8;
+static void wlc_lcnphy_pwrctrl_rssiparams(struct brcms_phy *pi)
+{
+	u16 auxpga_vmid, auxpga_vmid_temp, auxpga_gain_temp;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
-		command_num = command_nums[i];
-		if (ncorr_override[cal_type])
-			command_num =
-				ncorr_override[cal_type] << 8 | (command_num &
-								 0xff);
+	auxpga_vmid = (2 << 8) |
+		      (pi_lcn->lcnphy_rssi_vc << 4) | pi_lcn->lcnphy_rssi_vf;
+	auxpga_vmid_temp = (2 << 8) | (8 << 4) | 4;
+	auxpga_gain_temp = 2;
 
-		write_phy_reg(pi, 0x452, command_num);
+	mod_phy_reg(pi, 0x4d8, (0x1 << 0), (0) << 0);
 
-		if ((cal_type == 3) || (cal_type == 4)) {
-			wlc_lcnphy_common_read_table(pi, LCNPHY_TBL_ID_IQLOCAL,
-						     &diq_start, 1, 16, 69);
+	mod_phy_reg(pi, 0x4d8, (0x1 << 1), (0) << 1);
 
-			wlc_lcnphy_common_write_table(pi, LCNPHY_TBL_ID_IQLOCAL,
-						      &zero_diq, 1, 16, 69);
-		}
+	mod_phy_reg(pi, 0x4d7, (0x1 << 3), (0) << 3);
 
-		write_phy_reg(pi, 0x451, cal_cmds[i]);
+	mod_phy_reg(pi, 0x4db,
+		    (0x3ff << 0) |
+		    (0x7 << 12),
+		    (auxpga_vmid << 0) | (pi_lcn->lcnphy_rssi_gs << 12));
 
-		if (!wlc_lcnphy_iqcal_wait(pi))
-			goto cleanup;
+	mod_phy_reg(pi, 0x4dc,
+		    (0x3ff << 0) |
+		    (0x7 << 12),
+		    (auxpga_vmid << 0) | (pi_lcn->lcnphy_rssi_gs << 12));
 
-		wlc_lcnphy_common_read_table(pi, LCNPHY_TBL_ID_IQLOCAL,
-					     best_coeffs,
-					     ARRAY_SIZE(best_coeffs), 16, 96);
-		wlc_lcnphy_common_write_table(pi, LCNPHY_TBL_ID_IQLOCAL,
-					      best_coeffs,
-					      ARRAY_SIZE(best_coeffs), 16, 64);
+	mod_phy_reg(pi, 0x40a,
+		    (0x3ff << 0) |
+		    (0x7 << 12),
+		    (auxpga_vmid << 0) | (pi_lcn->lcnphy_rssi_gs << 12));
 
-		if ((cal_type == 3) || (cal_type == 4))
-			wlc_lcnphy_common_write_table(pi, LCNPHY_TBL_ID_IQLOCAL,
-						      &diq_start, 1, 16, 69);
-		wlc_lcnphy_common_read_table(pi, LCNPHY_TBL_ID_IQLOCAL,
-					     pi_lcn->lcnphy_cal_results.
-					     txiqlocal_bestcoeffs,
-					     ARRAY_SIZE(pi_lcn->
-							lcnphy_cal_results.
-							txiqlocal_bestcoeffs),
-					     16, 96);
-	}
+	mod_phy_reg(pi, 0x40b,
+		    (0x3ff << 0) |
+		    (0x7 << 12),
+		    (auxpga_vmid_temp << 0) | (auxpga_gain_temp << 12));
 
-	wlc_lcnphy_common_read_table(pi, LCNPHY_TBL_ID_IQLOCAL,
-				     pi_lcn->lcnphy_cal_results.
-				     txiqlocal_bestcoeffs,
-				     ARRAY_SIZE(pi_lcn->lcnphy_cal_results.
-						txiqlocal_bestcoeffs), 16, 96);
-	pi_lcn->lcnphy_cal_results.txiqlocal_bestcoeffs_valid = true;
+	mod_phy_reg(pi, 0x40c,
+		    (0x3ff << 0) |
+		    (0x7 << 12),
+		    (auxpga_vmid_temp << 0) | (auxpga_gain_temp << 12));
 
-	wlc_lcnphy_common_write_table(pi, LCNPHY_TBL_ID_IQLOCAL,
-				      &pi_lcn->lcnphy_cal_results.
-				      txiqlocal_bestcoeffs[0], 4, 16, 80);
+	mod_radio_reg(pi, RADIO_2064_REG082, (1 << 5), (1 << 5));
+}
 
-	wlc_lcnphy_common_write_table(pi, LCNPHY_TBL_ID_IQLOCAL,
-				      &pi_lcn->lcnphy_cal_results.
-				      txiqlocal_bestcoeffs[5], 2, 16, 85);
+static void wlc_lcnphy_tssi_setup(struct brcms_phy *pi)
+{
+	struct phytbl_info tab;
+	u32 rfseq, ind;
 
-cleanup:
-	wlc_lcnphy_tx_iqlo_loopback_cleanup(pi, values_to_save);
-	kfree(values_to_save);
+	tab.tbl_id = LCNPHY_TBL_ID_TXPWRCTL;
+	tab.tbl_width = 32;
+	tab.tbl_ptr = &ind;
+	tab.tbl_len = 1;
+	tab.tbl_offset = 0;
+	for (ind = 0; ind < 128; ind++) {
+		wlc_lcnphy_write_table(pi, &tab);
+		tab.tbl_offset++;
+	}
+	tab.tbl_offset = 704;
+	for (ind = 0; ind < 128; ind++) {
+		wlc_lcnphy_write_table(pi, &tab);
+		tab.tbl_offset++;
+	}
+	mod_phy_reg(pi, 0x503, (0x1 << 0), (0) << 0);
 
-	if (!keep_tone)
-		wlc_lcnphy_stop_tx_tone(pi);
+	mod_phy_reg(pi, 0x503, (0x1 << 2), (0) << 2);
 
-	write_phy_reg(pi, 0x4db, save_txpwrctrlrfctrl2);
+	mod_phy_reg(pi, 0x503, (0x1 << 4), (1) << 4);
 
-	write_phy_reg(pi, 0x453, 0);
+	wlc_lcnphy_set_tssi_mux(pi, LCNPHY_TSSI_EXT);
+	mod_phy_reg(pi, 0x4a4, (0x1 << 14), (0) << 14);
 
-	if (tx_gain_override_old)
-		wlc_lcnphy_set_tx_gain(pi, &old_gains);
-	wlc_lcnphy_set_tx_pwr_ctrl(pi, tx_pwr_ctrl_old);
+	mod_phy_reg(pi, 0x4a4, (0x1 << 15), (1) << 15);
 
-	write_phy_reg(pi, 0x6da, save_sslpnCalibClkEnCtrl);
-	write_phy_reg(pi, 0x6db, save_sslpnRxFeClkEnCtrl);
+	mod_phy_reg(pi, 0x4d0, (0x1 << 5), (0) << 5);
 
-}
+	mod_phy_reg(pi, 0x4a4, (0x1ff << 0), (0) << 0);
 
-static void wlc_lcnphy_idle_tssi_est(struct brcms_phy_pub *ppi)
-{
-	bool suspend, tx_gain_override_old;
-	struct lcnphy_txgains old_gains;
-	struct brcms_phy *pi = (struct brcms_phy *) ppi;
-	u16 idleTssi, idleTssi0_2C, idleTssi0_OB, idleTssi0_regvalue_OB,
-	    idleTssi0_regvalue_2C;
-	u16 SAVE_txpwrctrl = wlc_lcnphy_get_tx_pwr_ctrl(pi);
-	u16 SAVE_lpfgain = read_radio_reg(pi, RADIO_2064_REG112);
-	u16 SAVE_jtag_bb_afe_switch =
-		read_radio_reg(pi, RADIO_2064_REG007) & 1;
-	u16 SAVE_jtag_auxpga = read_radio_reg(pi, RADIO_2064_REG0FF) & 0x10;
-	u16 SAVE_iqadc_aux_en = read_radio_reg(pi, RADIO_2064_REG11F) & 4;
-	idleTssi = read_phy_reg(pi, 0x4ab);
-	suspend =
-		(0 ==
-		 (R_REG(&((struct brcms_phy *) pi)->regs->maccontrol) &
-		  MCTL_EN_MAC));
-	if (!suspend)
-		wlapi_suspend_mac_and_wait(pi->sh->physhim);
-	wlc_lcnphy_set_tx_pwr_ctrl(pi, LCNPHY_TX_PWR_CTRL_OFF);
+	mod_phy_reg(pi, 0x4a5, (0xff << 0), (255) << 0);
 
-	tx_gain_override_old = wlc_lcnphy_tx_gain_override_enabled(pi);
-	wlc_lcnphy_get_tx_gain(pi, &old_gains);
+	mod_phy_reg(pi, 0x4a5, (0x7 << 12), (5) << 12);
 
-	wlc_lcnphy_enable_tx_gain_override(pi);
-	wlc_lcnphy_set_tx_pwr_by_index(pi, 127);
-	write_radio_reg(pi, RADIO_2064_REG112, 0x6);
-	mod_radio_reg(pi, RADIO_2064_REG007, 0x1, 1);
-	mod_radio_reg(pi, RADIO_2064_REG0FF, 0x10, 1 << 4);
-	mod_radio_reg(pi, RADIO_2064_REG11F, 0x4, 1 << 2);
-	wlc_lcnphy_tssi_setup(pi);
-	wlc_phy_do_dummy_tx(pi, true, OFF);
-	idleTssi = ((read_phy_reg(pi, 0x4ab) & (0x1ff << 0))
-		    >> 0);
-
-	idleTssi0_2C = ((read_phy_reg(pi, 0x63e) & (0x1ff << 0))
-			>> 0);
-
-	if (idleTssi0_2C >= 256)
-		idleTssi0_OB = idleTssi0_2C - 256;
-	else
-		idleTssi0_OB = idleTssi0_2C + 256;
-
-	idleTssi0_regvalue_OB = idleTssi0_OB;
-	if (idleTssi0_regvalue_OB >= 256)
-		idleTssi0_regvalue_2C = idleTssi0_regvalue_OB - 256;
-	else
-		idleTssi0_regvalue_2C = idleTssi0_regvalue_OB + 256;
-	mod_phy_reg(pi, 0x4a6, (0x1ff << 0), (idleTssi0_regvalue_2C) << 0);
+	mod_phy_reg(pi, 0x4a5, (0x7 << 8), (0) << 8);
 
-	mod_phy_reg(pi, 0x44c, (0x1 << 12), (0) << 12);
+	mod_phy_reg(pi, 0x40d, (0xff << 0), (64) << 0);
 
-	wlc_lcnphy_set_tx_gain_override(pi, tx_gain_override_old);
-	wlc_lcnphy_set_tx_gain(pi, &old_gains);
-	wlc_lcnphy_set_tx_pwr_ctrl(pi, SAVE_txpwrctrl);
+	mod_phy_reg(pi, 0x40d, (0x7 << 8), (4) << 8);
 
-	write_radio_reg(pi, RADIO_2064_REG112, SAVE_lpfgain);
-	mod_radio_reg(pi, RADIO_2064_REG007, 0x1, SAVE_jtag_bb_afe_switch);
-	mod_radio_reg(pi, RADIO_2064_REG0FF, 0x10, SAVE_jtag_auxpga);
-	mod_radio_reg(pi, RADIO_2064_REG11F, 0x4, SAVE_iqadc_aux_en);
-	mod_radio_reg(pi, RADIO_2064_REG112, 0x80, 1 << 7);
-	if (!suspend)
-		wlapi_enable_mac(pi->sh->physhim);
-}
+	mod_phy_reg(pi, 0x4a2, (0xff << 0), (64) << 0);
 
-static void wlc_lcnphy_vbat_temp_sense_setup(struct brcms_phy *pi, u8 mode)
-{
-	bool suspend;
-	u16 save_txpwrCtrlEn;
-	u8 auxpga_vmidcourse, auxpga_vmidfine, auxpga_gain;
-	u16 auxpga_vmid;
-	struct phytbl_info tab;
-	u32 val;
-	u8 save_reg007, save_reg0FF, save_reg11F, save_reg005, save_reg025,
-	   save_reg112;
-	u16 values_to_save[14];
-	s8 index;
-	int i;
-	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
-	udelay(999);
+	mod_phy_reg(pi, 0x4a2, (0x7 << 8), (4) << 8);
 
-	save_reg007 = (u8) read_radio_reg(pi, RADIO_2064_REG007);
-	save_reg0FF = (u8) read_radio_reg(pi, RADIO_2064_REG0FF);
-	save_reg11F = (u8) read_radio_reg(pi, RADIO_2064_REG11F);
-	save_reg005 = (u8) read_radio_reg(pi, RADIO_2064_REG005);
-	save_reg025 = (u8) read_radio_reg(pi, RADIO_2064_REG025);
-	save_reg112 = (u8) read_radio_reg(pi, RADIO_2064_REG112);
+	mod_phy_reg(pi, 0x4d0, (0x1ff << 6), (0) << 6);
 
-	for (i = 0; i < 14; i++)
-		values_to_save[i] = read_phy_reg(pi, tempsense_phy_regs[i]);
-	suspend = (0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
-	if (!suspend)
-		wlapi_suspend_mac_and_wait(pi->sh->physhim);
-	save_txpwrCtrlEn = read_radio_reg(pi, 0x4a4);
+	mod_phy_reg(pi, 0x4a8, (0xff << 0), (0x1) << 0);
 
-	wlc_lcnphy_set_tx_pwr_ctrl(pi, LCNPHY_TX_PWR_CTRL_OFF);
-	index = pi_lcn->lcnphy_current_index;
-	wlc_lcnphy_set_tx_pwr_by_index(pi, 127);
-	mod_radio_reg(pi, RADIO_2064_REG007, 0x1, 0x1);
-	mod_radio_reg(pi, RADIO_2064_REG0FF, 0x10, 0x1 << 4);
-	mod_radio_reg(pi, RADIO_2064_REG11F, 0x4, 0x1 << 2);
-	mod_phy_reg(pi, 0x503, (0x1 << 0), (0) << 0);
+	wlc_lcnphy_clear_tx_power_offsets(pi);
 
-	mod_phy_reg(pi, 0x503, (0x1 << 2), (0) << 2);
+	mod_phy_reg(pi, 0x4a6, (0x1 << 15), (1) << 15);
 
-	mod_phy_reg(pi, 0x4a4, (0x1 << 14), (0) << 14);
+	mod_phy_reg(pi, 0x4a6, (0x1ff << 0), (0xff) << 0);
 
-	mod_phy_reg(pi, 0x4a4, (0x1 << 15), (0) << 15);
+	mod_phy_reg(pi, 0x49a, (0x1ff << 0), (0xff) << 0);
 
-	mod_phy_reg(pi, 0x4d0, (0x1 << 5), (0) << 5);
+	if (LCNREV_IS(pi->pubpi.phy_rev, 2)) {
+		mod_radio_reg(pi, RADIO_2064_REG028, 0xf, 0xe);
+		mod_radio_reg(pi, RADIO_2064_REG086, 0x4, 0x4);
+	} else {
+		mod_radio_reg(pi, RADIO_2064_REG03A, 0x1, 1);
+		mod_radio_reg(pi, RADIO_2064_REG11A, 0x8, 1 << 3);
+	}
 
-	mod_phy_reg(pi, 0x4a5, (0xff << 0), (255) << 0);
+	write_radio_reg(pi, RADIO_2064_REG025, 0xc);
 
-	mod_phy_reg(pi, 0x4a5, (0x7 << 12), (5) << 12);
+	if (LCNREV_IS(pi->pubpi.phy_rev, 2)) {
+		mod_radio_reg(pi, RADIO_2064_REG03A, 0x1, 1);
+	} else {
+		if (CHSPEC_IS2G(pi->radio_chanspec))
+			mod_radio_reg(pi, RADIO_2064_REG03A, 0x2, 1 << 1);
+		else
+			mod_radio_reg(pi, RADIO_2064_REG03A, 0x2, 0 << 1);
+	}
 
-	mod_phy_reg(pi, 0x4a5, (0x7 << 8), (0) << 8);
+	if (LCNREV_IS(pi->pubpi.phy_rev, 2))
+		mod_radio_reg(pi, RADIO_2064_REG03A, 0x2, 1 << 1);
+	else
+		mod_radio_reg(pi, RADIO_2064_REG03A, 0x4, 1 << 2);
 
-	mod_phy_reg(pi, 0x40d, (0xff << 0), (64) << 0);
+	mod_radio_reg(pi, RADIO_2064_REG11A, 0x1, 1 << 0);
 
-	mod_phy_reg(pi, 0x40d, (0x7 << 8), (6) << 8);
+	mod_radio_reg(pi, RADIO_2064_REG005, 0x8, 1 << 3);
 
-	mod_phy_reg(pi, 0x4a2, (0xff << 0), (64) << 0);
+	if (!wlc_lcnphy_tempsense_based_pwr_ctrl_enabled(pi))
+		mod_phy_reg(pi, 0x4d7,
+			    (0x1 << 3) | (0x7 << 12), 0 << 3 | 2 << 12);
 
-	mod_phy_reg(pi, 0x4a2, (0x7 << 8), (6) << 8);
+	rfseq = wlc_lcnphy_rfseq_tbl_adc_pwrup(pi);
+	tab.tbl_id = LCNPHY_TBL_ID_RFSEQ;
+	tab.tbl_width = 16;
+	tab.tbl_ptr = &rfseq;
+	tab.tbl_len = 1;
+	tab.tbl_offset = 6;
+	wlc_lcnphy_write_table(pi, &tab);
 
-	mod_phy_reg(pi, 0x4d9, (0x7 << 4), (2) << 4);
+	mod_phy_reg(pi, 0x938, (0x1 << 2), (1) << 2);
 
-	mod_phy_reg(pi, 0x4d9, (0x7 << 8), (3) << 8);
+	mod_phy_reg(pi, 0x939, (0x1 << 2), (1) << 2);
 
-	mod_phy_reg(pi, 0x4d9, (0x7 << 12), (1) << 12);
+	mod_phy_reg(pi, 0x4a4, (0x1 << 12), (1) << 12);
 
-	mod_phy_reg(pi, 0x4da, (0x1 << 12), (0) << 12);
+	mod_phy_reg(pi, 0x4d7, (0x1 << 2), (1) << 2);
 
-	mod_phy_reg(pi, 0x4da, (0x1 << 13), (1) << 13);
+	mod_phy_reg(pi, 0x4d7, (0xf << 8), (0) << 8);
 
-	mod_phy_reg(pi, 0x4a6, (0x1 << 15), (1) << 15);
+	wlc_lcnphy_pwrctrl_rssiparams(pi);
+}
 
-	write_radio_reg(pi, RADIO_2064_REG025, 0xC);
+void wlc_lcnphy_tx_pwr_update_npt(struct brcms_phy *pi)
+{
+	u16 tx_cnt, tx_total, npt;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
-	mod_radio_reg(pi, RADIO_2064_REG005, 0x8, 0x1 << 3);
+	tx_total = wlc_lcnphy_total_tx_frames(pi);
+	tx_cnt = tx_total - pi_lcn->lcnphy_tssi_tx_cnt;
+	npt = wlc_lcnphy_get_tx_pwr_npt(pi);
 
-	mod_phy_reg(pi, 0x938, (0x1 << 2), (1) << 2);
+	if (tx_cnt > (1 << npt)) {
 
-	mod_phy_reg(pi, 0x939, (0x1 << 2), (1) << 2);
+		pi_lcn->lcnphy_tssi_tx_cnt = tx_total;
 
-	mod_phy_reg(pi, 0x4a4, (0x1 << 12), (1) << 12);
+		pi_lcn->lcnphy_tssi_idx = wlc_lcnphy_get_current_tx_pwr_idx(pi);
+		pi_lcn->lcnphy_tssi_npt = npt;
 
-	val = wlc_lcnphy_rfseq_tbl_adc_pwrup(pi);
-	tab.tbl_id = LCNPHY_TBL_ID_RFSEQ;
-	tab.tbl_width = 16;
-	tab.tbl_len = 1;
-	tab.tbl_ptr = &val;
-	tab.tbl_offset = 6;
-	wlc_lcnphy_write_table(pi, &tab);
-	if (mode == TEMPSENSE) {
-		mod_phy_reg(pi, 0x4d7, (0x1 << 3), (1) << 3);
+	}
+}
 
-		mod_phy_reg(pi, 0x4d7, (0x7 << 12), (1) << 12);
+s32 wlc_lcnphy_tssi2dbm(s32 tssi, s32 a1, s32 b0, s32 b1)
+{
+	s32 a, b, p;
 
-		auxpga_vmidcourse = 8;
-		auxpga_vmidfine = 0x4;
-		auxpga_gain = 2;
-		mod_radio_reg(pi, RADIO_2064_REG082, 0x20, 1 << 5);
-	} else {
-		mod_phy_reg(pi, 0x4d7, (0x1 << 3), (1) << 3);
+	a = 32768 + (a1 * tssi);
+	b = (1024 * b0) + (64 * b1 * tssi);
+	p = ((2 * b) + a) / (2 * a);
 
-		mod_phy_reg(pi, 0x4d7, (0x7 << 12), (3) << 12);
+	return p;
+}
 
-		auxpga_vmidcourse = 7;
-		auxpga_vmidfine = 0xa;
-		auxpga_gain = 2;
-	}
-	auxpga_vmid =
-		(u16) ((2 << 8) | (auxpga_vmidcourse << 4) | auxpga_vmidfine);
-	mod_phy_reg(pi, 0x4d8, (0x1 << 0), (1) << 0);
+static void wlc_lcnphy_txpower_reset_npt(struct brcms_phy *pi)
+{
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	if (wlc_lcnphy_tempsense_based_pwr_ctrl_enabled(pi))
+		return;
 
-	mod_phy_reg(pi, 0x4d8, (0x3ff << 2), (auxpga_vmid) << 2);
+	pi_lcn->lcnphy_tssi_idx = LCNPHY_TX_PWR_CTRL_START_INDEX_2G_4313;
+	pi_lcn->lcnphy_tssi_npt = LCNPHY_TX_PWR_CTRL_START_NPT;
+}
 
-	mod_phy_reg(pi, 0x4d8, (0x1 << 1), (1) << 1);
+void wlc_lcnphy_txpower_recalc_target(struct brcms_phy *pi)
+{
+	struct phytbl_info tab;
+	u32 rate_table[BRCMS_NUM_RATES_CCK + BRCMS_NUM_RATES_OFDM +
+		       BRCMS_NUM_RATES_MCS_1_STREAM];
+	uint i, j;
+	if (wlc_lcnphy_tempsense_based_pwr_ctrl_enabled(pi))
+		return;
 
-	mod_phy_reg(pi, 0x4d8, (0x7 << 12), (auxpga_gain) << 12);
+	for (i = 0, j = 0; i < ARRAY_SIZE(rate_table); i++, j++) {
 
-	mod_phy_reg(pi, 0x4d0, (0x1 << 5), (1) << 5);
+		if (i == BRCMS_NUM_RATES_CCK + BRCMS_NUM_RATES_OFDM)
+			j = TXP_FIRST_MCS_20_SISO;
 
-	write_radio_reg(pi, RADIO_2064_REG112, 0x6);
+		rate_table[i] = (u32) ((s32) (-pi->tx_power_offset[j]));
+	}
 
-	wlc_phy_do_dummy_tx(pi, true, OFF);
-	if (!tempsense_done(pi))
-		udelay(10);
+	tab.tbl_id = LCNPHY_TBL_ID_TXPWRCTL;
+	tab.tbl_width = 32;
+	tab.tbl_len = ARRAY_SIZE(rate_table);
+	tab.tbl_ptr = rate_table;
+	tab.tbl_offset = LCNPHY_TX_PWR_CTRL_RATE_OFFSET;
+	wlc_lcnphy_write_table(pi, &tab);
 
-	write_radio_reg(pi, RADIO_2064_REG007, (u16) save_reg007);
-	write_radio_reg(pi, RADIO_2064_REG0FF, (u16) save_reg0FF);
-	write_radio_reg(pi, RADIO_2064_REG11F, (u16) save_reg11F);
-	write_radio_reg(pi, RADIO_2064_REG005, (u16) save_reg005);
-	write_radio_reg(pi, RADIO_2064_REG025, (u16) save_reg025);
-	write_radio_reg(pi, RADIO_2064_REG112, (u16) save_reg112);
-	for (i = 0; i < 14; i++)
-		write_phy_reg(pi, tempsense_phy_regs[i], values_to_save[i]);
-	wlc_lcnphy_set_tx_pwr_by_index(pi, (int)index);
+	if (wlc_lcnphy_get_target_tx_pwr(pi) != pi->tx_power_min) {
+		wlc_lcnphy_set_target_tx_pwr(pi, pi->tx_power_min);
 
-	write_radio_reg(pi, 0x4a4, save_txpwrCtrlEn);
-	if (!suspend)
-		wlapi_enable_mac(pi->sh->physhim);
-	udelay(999);
+		wlc_lcnphy_txpower_reset_npt(pi);
+	}
 }
 
-static void wlc_lcnphy_tx_pwr_ctrl_init(struct brcms_phy_pub *ppi)
+static void wlc_lcnphy_set_tx_pwr_soft_ctrl(struct brcms_phy *pi, s8 index)
 {
-	struct lcnphy_txgains tx_gains;
-	u8 bbmult;
+	u32 cck_offset[4] = { 22, 22, 22, 22 };
+	u32 ofdm_offset, reg_offset_cck;
+	int i;
+	u16 index2;
 	struct phytbl_info tab;
-	s32 a1, b0, b1;
-	s32 tssi, pwr, maxtargetpwr, mintargetpwr;
-	bool suspend;
-	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
-	suspend =
-		(0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
-	if (!suspend)
-		wlapi_suspend_mac_and_wait(pi->sh->physhim);
+	if (wlc_lcnphy_tssi_based_pwr_ctrl_enabled(pi))
+		return;
 
-	if (!pi->hwpwrctrl_capable) {
-		if (CHSPEC_IS2G(pi->radio_chanspec)) {
-			tx_gains.gm_gain = 4;
-			tx_gains.pga_gain = 12;
-			tx_gains.pad_gain = 12;
-			tx_gains.dac_gain = 0;
-
-			bbmult = 150;
-		} else {
-			tx_gains.gm_gain = 7;
-			tx_gains.pga_gain = 15;
-			tx_gains.pad_gain = 14;
-			tx_gains.dac_gain = 0;
-
-			bbmult = 150;
-		}
-		wlc_lcnphy_set_tx_gain(pi, &tx_gains);
-		wlc_lcnphy_set_bbmult(pi, bbmult);
-		wlc_lcnphy_vbat_temp_sense_setup(pi, TEMPSENSE);
-	} else {
+	mod_phy_reg(pi, 0x4a4, (0x1 << 14), (0x1) << 14);
 
-		wlc_lcnphy_idle_tssi_est(ppi);
+	mod_phy_reg(pi, 0x4a4, (0x1 << 14), (0x0) << 14);
 
-		wlc_lcnphy_clear_tx_power_offsets(pi);
+	or_phy_reg(pi, 0x6da, 0x0040);
 
-		b0 = pi->txpa_2g[0];
-		b1 = pi->txpa_2g[1];
-		a1 = pi->txpa_2g[2];
-		maxtargetpwr = wlc_lcnphy_tssi2dbm(10, a1, b0, b1);
-		mintargetpwr = wlc_lcnphy_tssi2dbm(125, a1, b0, b1);
+	reg_offset_cck = 0;
+	for (i = 0; i < 4; i++)
+		cck_offset[i] -= reg_offset_cck;
+	tab.tbl_id = LCNPHY_TBL_ID_TXPWRCTL;
+	tab.tbl_width = 32;
+	tab.tbl_len = 4;
+	tab.tbl_ptr = cck_offset;
+	tab.tbl_offset = LCNPHY_TX_PWR_CTRL_RATE_OFFSET;
+	wlc_lcnphy_write_table(pi, &tab);
+	ofdm_offset = 0;
+	tab.tbl_len = 1;
+	tab.tbl_ptr = &ofdm_offset;
+	for (i = 836; i < 862; i++) {
+		tab.tbl_offset = i;
+		wlc_lcnphy_write_table(pi, &tab);
+	}
 
-		tab.tbl_id = LCNPHY_TBL_ID_TXPWRCTL;
-		tab.tbl_width = 32;
-		tab.tbl_ptr = &pwr;
-		tab.tbl_len = 1;
-		tab.tbl_offset = 0;
-		for (tssi = 0; tssi < 128; tssi++) {
-			pwr = wlc_lcnphy_tssi2dbm(tssi, a1, b0, b1);
+	mod_phy_reg(pi, 0x4a4, (0x1 << 15), (0x1) << 15);
 
-			pwr = (pwr < mintargetpwr) ? mintargetpwr : pwr;
-			wlc_lcnphy_write_table(pi, &tab);
-			tab.tbl_offset++;
-		}
+	mod_phy_reg(pi, 0x4a4, (0x1 << 14), (0x1) << 14);
 
-		mod_phy_reg(pi, 0x410, (0x1 << 7), (0) << 7);
+	mod_phy_reg(pi, 0x4a4, (0x1 << 13), (0x1) << 13);
 
-		write_phy_reg(pi, 0x4a8, 10);
+	mod_phy_reg(pi, 0x4b0, (0x1 << 7), (0) << 7);
 
-		wlc_lcnphy_set_target_tx_pwr(pi, LCN_TARGET_PWR);
+	mod_phy_reg(pi, 0x43b, (0x1 << 6), (0) << 6);
 
-		wlc_lcnphy_set_tx_pwr_ctrl(pi, LCNPHY_TX_PWR_CTRL_HW);
-	}
-	if (!suspend)
-		wlapi_enable_mac(pi->sh->physhim);
-}
+	mod_phy_reg(pi, 0x4a9, (0x1 << 15), (1) << 15);
 
-static u8 wlc_lcnphy_get_bbmult(struct brcms_phy *pi)
-{
-	u16 m0m1;
-	struct phytbl_info tab;
+	index2 = (u16) (index * 2);
+	mod_phy_reg(pi, 0x4a9, (0x1ff << 0), (index2) << 0);
 
-	tab.tbl_ptr = &m0m1;
-	tab.tbl_len = 1;
-	tab.tbl_id = LCNPHY_TBL_ID_IQLOCAL;
-	tab.tbl_offset = 87;
-	tab.tbl_width = 16;
-	wlc_lcnphy_read_table(pi, &tab);
+	mod_phy_reg(pi, 0x6a3, (0x1 << 4), (0) << 4);
 
-	return (u8) ((m0m1 & 0xff00) >> 8);
 }
 
-static void wlc_lcnphy_set_pa_gain(struct brcms_phy *pi, u16 gain)
+static s8 wlc_lcnphy_tempcompensated_txpwrctrl(struct brcms_phy *pi)
 {
-	mod_phy_reg(pi, 0x4fb,
-		    LCNPHY_txgainctrlovrval1_pagain_ovr_val1_MASK,
-		    gain << LCNPHY_txgainctrlovrval1_pagain_ovr_val1_SHIFT);
-	mod_phy_reg(pi, 0x4fd,
-		    LCNPHY_stxtxgainctrlovrval1_pagain_ovr_val1_MASK,
-		    gain << LCNPHY_stxtxgainctrlovrval1_pagain_ovr_val1_SHIFT);
-}
+	s8 index, delta_brd, delta_temp, new_index, tempcorrx;
+	s16 manp, meas_temp, temp_diff;
+	bool neg = 0;
+	u16 temp;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
-void
-wlc_lcnphy_get_radio_loft(struct brcms_phy *pi,
-			  u8 *ei0, u8 *eq0, u8 *fi0, u8 *fq0)
-{
-	*ei0 = LCNPHY_IQLOCC_READ(read_radio_reg(pi, RADIO_2064_REG089));
-	*eq0 = LCNPHY_IQLOCC_READ(read_radio_reg(pi, RADIO_2064_REG08A));
-	*fi0 = LCNPHY_IQLOCC_READ(read_radio_reg(pi, RADIO_2064_REG08B));
-	*fq0 = LCNPHY_IQLOCC_READ(read_radio_reg(pi, RADIO_2064_REG08C));
-}
+	if (wlc_lcnphy_tssi_based_pwr_ctrl_enabled(pi))
+		return pi_lcn->lcnphy_current_index;
 
-static void
-wlc_lcnphy_get_tx_gain(struct brcms_phy *pi, struct lcnphy_txgains *gains)
-{
-	u16 dac_gain;
+	index = FIXED_TXPWR;
 
-	dac_gain = read_phy_reg(pi, 0x439) >> 0;
-	gains->dac_gain = (dac_gain & 0x380) >> 7;
+	if (pi_lcn->lcnphy_tempsense_slope == 0)
+		return index;
 
-	{
-		u16 rfgain0, rfgain1;
+	temp = (u16) wlc_lcnphy_tempsense(pi, 0);
+	meas_temp = LCNPHY_TEMPSENSE(temp);
 
-		rfgain0 = (read_phy_reg(pi, 0x4b5) & (0xffff << 0)) >> 0;
-		rfgain1 = (read_phy_reg(pi, 0x4fb) & (0x7fff << 0)) >> 0;
+	if (pi->tx_power_min != 0)
+		delta_brd = (pi_lcn->lcnphy_measPower - pi->tx_power_min);
+	else
+		delta_brd = 0;
 
-		gains->gm_gain = rfgain0 & 0xff;
-		gains->pga_gain = (rfgain0 >> 8) & 0xff;
-		gains->pad_gain = rfgain1 & 0xff;
+	manp = LCNPHY_TEMPSENSE(pi_lcn->lcnphy_rawtempsense);
+	temp_diff = manp - meas_temp;
+	if (temp_diff < 0) {
+		neg = 1;
+		temp_diff = -temp_diff;
 	}
-}
 
-void wlc_lcnphy_set_tx_iqcc(struct brcms_phy *pi, u16 a, u16 b)
-{
-	struct phytbl_info tab;
-	u16 iqcc[2];
+	delta_temp = (s8) wlc_lcnphy_qdiv_roundup((u32) (temp_diff * 192),
+						  (u32) (pi_lcn->
+							 lcnphy_tempsense_slope
+							 * 10), 0);
+	if (neg)
+		delta_temp = -delta_temp;
 
-	iqcc[0] = a;
-	iqcc[1] = b;
+	if (pi_lcn->lcnphy_tempsense_option == 3
+	    && LCNREV_IS(pi->pubpi.phy_rev, 0))
+		delta_temp = 0;
+	if (pi_lcn->lcnphy_tempcorrx > 31)
+		tempcorrx = (s8) (pi_lcn->lcnphy_tempcorrx - 64);
+	else
+		tempcorrx = (s8) pi_lcn->lcnphy_tempcorrx;
+	if (LCNREV_IS(pi->pubpi.phy_rev, 1))
+		tempcorrx = 4;
+	new_index =
+		index + delta_brd + delta_temp - pi_lcn->lcnphy_bandedge_corr;
+	new_index += tempcorrx;
 
-	tab.tbl_id = LCNPHY_TBL_ID_IQLOCAL;
-	tab.tbl_width = 16;
-	tab.tbl_ptr = iqcc;
-	tab.tbl_len = 2;
-	tab.tbl_offset = 80;
-	wlc_lcnphy_write_table(pi, &tab);
+	if (LCNREV_IS(pi->pubpi.phy_rev, 1))
+		index = 127;
+
+	if (new_index < 0 || new_index > 126)
+		return index;
+
+	return new_index;
 }
 
-void wlc_lcnphy_set_tx_locc(struct brcms_phy *pi, u16 didq)
+static u16 wlc_lcnphy_set_tx_pwr_ctrl_mode(struct brcms_phy *pi, u16 mode)
 {
-	struct phytbl_info tab;
 
-	tab.tbl_id = LCNPHY_TBL_ID_IQLOCAL;
-	tab.tbl_width = 16;
-	tab.tbl_ptr = &didq;
-	tab.tbl_len = 1;
-	tab.tbl_offset = 85;
-	wlc_lcnphy_write_table(pi, &tab);
+	u16 current_mode = mode;
+	if (wlc_lcnphy_tempsense_based_pwr_ctrl_enabled(pi) &&
+	    mode == LCNPHY_TX_PWR_CTRL_HW)
+		current_mode = LCNPHY_TX_PWR_CTRL_TEMPBASED;
+	if (wlc_lcnphy_tssi_based_pwr_ctrl_enabled(pi) &&
+	    mode == LCNPHY_TX_PWR_CTRL_TEMPBASED)
+		current_mode = LCNPHY_TX_PWR_CTRL_HW;
+	return current_mode;
 }
 
-void wlc_lcnphy_set_tx_pwr_by_index(struct brcms_phy *pi, int index)
+void wlc_lcnphy_set_tx_pwr_ctrl(struct brcms_phy *pi, u16 mode)
 {
-	struct phytbl_info tab;
-	u16 a, b;
-	u8 bb_mult;
-	u32 bbmultiqcomp, txgain, locoeffs, rfpower;
-	struct lcnphy_txgains gains;
+	u16 old_mode = wlc_lcnphy_get_tx_pwr_ctrl(pi);
+	s8 index;
 	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
-	pi_lcn->lcnphy_tx_power_idx_override = (s8) index;
-	pi_lcn->lcnphy_current_index = (u8) index;
-
-	tab.tbl_id = LCNPHY_TBL_ID_TXPWRCTL;
-	tab.tbl_width = 32;
-	tab.tbl_len = 1;
+	mode = wlc_lcnphy_set_tx_pwr_ctrl_mode(pi, mode);
+	old_mode = wlc_lcnphy_set_tx_pwr_ctrl_mode(pi, old_mode);
 
-	wlc_lcnphy_set_tx_pwr_ctrl(pi, LCNPHY_TX_PWR_CTRL_OFF);
+	mod_phy_reg(pi, 0x6da, (0x1 << 6),
+		    ((LCNPHY_TX_PWR_CTRL_HW == mode) ? 1 : 0) << 6);
 
-	tab.tbl_offset = LCNPHY_TX_PWR_CTRL_IQ_OFFSET + index;
-	tab.tbl_ptr = &bbmultiqcomp;
-	wlc_lcnphy_read_table(pi, &tab);
+	mod_phy_reg(pi, 0x6a3, (0x1 << 4),
+		    ((LCNPHY_TX_PWR_CTRL_HW == mode) ? 0 : 1) << 4);
 
-	tab.tbl_offset = LCNPHY_TX_PWR_CTRL_GAIN_OFFSET + index;
-	tab.tbl_width = 32;
-	tab.tbl_ptr = &txgain;
-	wlc_lcnphy_read_table(pi, &tab);
+	if (old_mode != mode) {
+		if (LCNPHY_TX_PWR_CTRL_HW == old_mode) {
 
-	gains.gm_gain = (u16) (txgain & 0xff);
-	gains.pga_gain = (u16) (txgain >> 8) & 0xff;
-	gains.pad_gain = (u16) (txgain >> 16) & 0xff;
-	gains.dac_gain = (u16) (bbmultiqcomp >> 28) & 0x07;
-	wlc_lcnphy_set_tx_gain(pi, &gains);
-	wlc_lcnphy_set_pa_gain(pi, (u16) (txgain >> 24) & 0x7f);
+			wlc_lcnphy_tx_pwr_update_npt(pi);
 
-	bb_mult = (u8) ((bbmultiqcomp >> 20) & 0xff);
-	wlc_lcnphy_set_bbmult(pi, bb_mult);
+			wlc_lcnphy_clear_tx_power_offsets(pi);
+		}
+		if (LCNPHY_TX_PWR_CTRL_HW == mode) {
 
-	wlc_lcnphy_enable_tx_gain_override(pi);
+			wlc_lcnphy_txpower_recalc_target(pi);
 
-	if (!wlc_lcnphy_tempsense_based_pwr_ctrl_enabled(pi)) {
+			wlc_lcnphy_set_start_tx_pwr_idx(pi,
+							pi_lcn->
+							lcnphy_tssi_idx);
+			wlc_lcnphy_set_tx_pwr_npt(pi, pi_lcn->lcnphy_tssi_npt);
+			mod_radio_reg(pi, RADIO_2064_REG11F, 0x4, 0);
 
-		a = (u16) ((bbmultiqcomp >> 10) & 0x3ff);
-		b = (u16) (bbmultiqcomp & 0x3ff);
-		wlc_lcnphy_set_tx_iqcc(pi, a, b);
+			pi_lcn->lcnphy_tssi_tx_cnt =
+				wlc_lcnphy_total_tx_frames(pi);
 
-		tab.tbl_offset = LCNPHY_TX_PWR_CTRL_LO_OFFSET + index;
-		tab.tbl_ptr = &locoeffs;
-		wlc_lcnphy_read_table(pi, &tab);
-
-		wlc_lcnphy_set_tx_locc(pi, (u16) locoeffs);
-
-		tab.tbl_offset = LCNPHY_TX_PWR_CTRL_PWR_OFFSET + index;
-		tab.tbl_ptr = &rfpower;
-		wlc_lcnphy_read_table(pi, &tab);
-		mod_phy_reg(pi, 0x6a6, (0x1fff << 0), (rfpower * 8) << 0);
+			wlc_lcnphy_disable_tx_gain_override(pi);
+			pi_lcn->lcnphy_tx_power_idx_override = -1;
+		} else
+			wlc_lcnphy_enable_tx_gain_override(pi);
 
+		mod_phy_reg(pi, 0x4a4,
+			    ((0x1 << 15) | (0x1 << 14) | (0x1 << 13)), mode);
+		if (mode == LCNPHY_TX_PWR_CTRL_TEMPBASED) {
+			index = wlc_lcnphy_tempcompensated_txpwrctrl(pi);
+			wlc_lcnphy_set_tx_pwr_soft_ctrl(pi, index);
+			pi_lcn->lcnphy_current_index = (s8)
+						       ((read_phy_reg(pi,
+								      0x4a9) &
+							 0xFF) / 2);
+		}
 	}
 }
 
-static void wlc_lcnphy_set_trsw_override(struct brcms_phy *pi, bool tx, bool rx)
+static void
+wlc_lcnphy_tx_iqlo_loopback(struct brcms_phy *pi, u16 *values_to_save)
 {
+	u16 vmid;
+	int i;
+	for (i = 0; i < 20; i++)
+		values_to_save[i] =
+			read_radio_reg(pi, iqlo_loopback_rf_regs[i]);
 
-	mod_phy_reg(pi, 0x44d,
-		    (0x1 << 1) |
-		    (0x1 << 0), (tx ? (0x1 << 1) : 0) | (rx ? (0x1 << 0) : 0));
-
-	or_phy_reg(pi, 0x44c, (0x1 << 1) | (0x1 << 0));
-}
-
-static void wlc_lcnphy_clear_papd_comptable(struct brcms_phy *pi)
-{
-	u32 j;
-	struct phytbl_info tab;
-	u32 temp_offset[128];
-	tab.tbl_ptr = temp_offset;
-	tab.tbl_len = 128;
-	tab.tbl_id = LCNPHY_TBL_ID_PAPDCOMPDELTATBL;
-	tab.tbl_width = 32;
-	tab.tbl_offset = 0;
+	mod_phy_reg(pi, 0x44c, (0x1 << 12), 1 << 12);
+	mod_phy_reg(pi, 0x44d, (0x1 << 14), 1 << 14);
 
-	memset(temp_offset, 0, sizeof(temp_offset));
-	for (j = 1; j < 128; j += 2)
-		temp_offset[j] = 0x80000;
+	mod_phy_reg(pi, 0x44c, (0x1 << 11), 1 << 11);
+	mod_phy_reg(pi, 0x44d, (0x1 << 13), 0 << 13);
 
-	wlc_lcnphy_write_table(pi, &tab);
-	return;
-}
+	mod_phy_reg(pi, 0x43b, (0x1 << 1), 1 << 1);
+	mod_phy_reg(pi, 0x43c, (0x1 << 1), 0 << 1);
 
-static void
-wlc_lcnphy_set_rx_gain_by_distribution(struct brcms_phy *pi,
-				       u16 trsw,
-				       u16 ext_lna,
-				       u16 biq2,
-				       u16 biq1,
-				       u16 tia, u16 lna2, u16 lna1)
-{
-	u16 gain0_15, gain16_19;
+	mod_phy_reg(pi, 0x43b, (0x1 << 0), 1 << 0);
+	mod_phy_reg(pi, 0x43c, (0x1 << 0), 0 << 0);
 
-	gain16_19 = biq2 & 0xf;
-	gain0_15 = ((biq1 & 0xf) << 12) |
-		   ((tia & 0xf) << 8) |
-		   ((lna2 & 0x3) << 6) |
-		   ((lna2 &
-		     0x3) << 4) | ((lna1 & 0x3) << 2) | ((lna1 & 0x3) << 0);
+	if (LCNREV_IS(pi->pubpi.phy_rev, 2))
+		and_radio_reg(pi, RADIO_2064_REG03A, 0xFD);
+	else
+		and_radio_reg(pi, RADIO_2064_REG03A, 0xF9);
+	or_radio_reg(pi, RADIO_2064_REG11A, 0x1);
 
-	mod_phy_reg(pi, 0x4b6, (0xffff << 0), gain0_15 << 0);
-	mod_phy_reg(pi, 0x4b7, (0xf << 0), gain16_19 << 0);
-	mod_phy_reg(pi, 0x4b1, (0x3 << 11), lna1 << 11);
+	or_radio_reg(pi, RADIO_2064_REG036, 0x01);
+	or_radio_reg(pi, RADIO_2064_REG11A, 0x18);
+	udelay(20);
 
-	if (LCNREV_LT(pi->pubpi.phy_rev, 2)) {
-		mod_phy_reg(pi, 0x4b1, (0x1 << 9), ext_lna << 9);
-		mod_phy_reg(pi, 0x4b1, (0x1 << 10), ext_lna << 10);
+	if (LCNREV_IS(pi->pubpi.phy_rev, 2)) {
+		if (CHSPEC_IS5G(pi->radio_chanspec))
+			mod_radio_reg(pi, RADIO_2064_REG03A, 1, 0);
+		else
+			or_radio_reg(pi, RADIO_2064_REG03A, 1);
 	} else {
-		mod_phy_reg(pi, 0x4b1, (0x1 << 10), 0 << 10);
+		if (CHSPEC_IS5G(pi->radio_chanspec))
+			mod_radio_reg(pi, RADIO_2064_REG03A, 3, 1);
+		else
+			or_radio_reg(pi, RADIO_2064_REG03A, 0x3);
+	}
 
-		mod_phy_reg(pi, 0x4b1, (0x1 << 15), 0 << 15);
+	udelay(20);
 
-		mod_phy_reg(pi, 0x4b1, (0x1 << 9), ext_lna << 9);
+	write_radio_reg(pi, RADIO_2064_REG025, 0xF);
+	if (LCNREV_IS(pi->pubpi.phy_rev, 2)) {
+		if (CHSPEC_IS5G(pi->radio_chanspec))
+			mod_radio_reg(pi, RADIO_2064_REG028, 0xF, 0x4);
+		else
+			mod_radio_reg(pi, RADIO_2064_REG028, 0xF, 0x6);
+	} else {
+		if (CHSPEC_IS5G(pi->radio_chanspec))
+			mod_radio_reg(pi, RADIO_2064_REG028, 0x1e, 0x4 << 1);
+		else
+			mod_radio_reg(pi, RADIO_2064_REG028, 0x1e, 0x6 << 1);
 	}
 
-	mod_phy_reg(pi, 0x44d, (0x1 << 0), (!trsw) << 0);
+	udelay(20);
 
-}
+	write_radio_reg(pi, RADIO_2064_REG005, 0x8);
+	or_radio_reg(pi, RADIO_2064_REG112, 0x80);
+	udelay(20);
 
-static void
-wlc_lcnphy_rx_gain_override_enable(struct brcms_phy *pi, bool enable)
-{
-	u16 ebit = enable ? 1 : 0;
+	or_radio_reg(pi, RADIO_2064_REG0FF, 0x10);
+	or_radio_reg(pi, RADIO_2064_REG11F, 0x44);
+	udelay(20);
 
-	mod_phy_reg(pi, 0x4b0, (0x1 << 8), ebit << 8);
+	or_radio_reg(pi, RADIO_2064_REG00B, 0x7);
+	or_radio_reg(pi, RADIO_2064_REG113, 0x10);
+	udelay(20);
 
-	mod_phy_reg(pi, 0x44c, (0x1 << 0), ebit << 0);
+	write_radio_reg(pi, RADIO_2064_REG007, 0x1);
+	udelay(20);
 
-	if (LCNREV_LT(pi->pubpi.phy_rev, 2)) {
-		mod_phy_reg(pi, 0x44c, (0x1 << 4), ebit << 4);
-		mod_phy_reg(pi, 0x44c, (0x1 << 6), ebit << 6);
-		mod_phy_reg(pi, 0x4b0, (0x1 << 5), ebit << 5);
-		mod_phy_reg(pi, 0x4b0, (0x1 << 6), ebit << 6);
-	} else {
-		mod_phy_reg(pi, 0x4b0, (0x1 << 12), ebit << 12);
-		mod_phy_reg(pi, 0x4b0, (0x1 << 13), ebit << 13);
-		mod_phy_reg(pi, 0x4b0, (0x1 << 5), ebit << 5);
-	}
+	vmid = 0x2A6;
+	mod_radio_reg(pi, RADIO_2064_REG0FC, 0x3 << 0, (vmid >> 8) & 0x3);
+	write_radio_reg(pi, RADIO_2064_REG0FD, (vmid & 0xff));
+	or_radio_reg(pi, RADIO_2064_REG11F, 0x44);
+	udelay(20);
 
-	if (CHSPEC_IS2G(pi->radio_chanspec)) {
-		mod_phy_reg(pi, 0x4b0, (0x1 << 10), ebit << 10);
-		mod_phy_reg(pi, 0x4e5, (0x1 << 3), ebit << 3);
-	}
+	or_radio_reg(pi, RADIO_2064_REG0FF, 0x10);
+	udelay(20);
+	write_radio_reg(pi, RADIO_2064_REG012, 0x02);
+	or_radio_reg(pi, RADIO_2064_REG112, 0x06);
+	write_radio_reg(pi, RADIO_2064_REG036, 0x11);
+	write_radio_reg(pi, RADIO_2064_REG059, 0xcc);
+	write_radio_reg(pi, RADIO_2064_REG05C, 0x2e);
+	write_radio_reg(pi, RADIO_2064_REG078, 0xd7);
+	write_radio_reg(pi, RADIO_2064_REG092, 0x15);
 }
 
-void wlc_lcnphy_tx_pu(struct brcms_phy *pi, bool bEnable)
+static bool wlc_lcnphy_iqcal_wait(struct brcms_phy *pi)
 {
-	if (!bEnable) {
+	uint delay_count = 0;
 
-		and_phy_reg(pi, 0x43b, ~(u16) ((0x1 << 1) | (0x1 << 4)));
+	while (wlc_lcnphy_iqcal_active(pi)) {
+		udelay(100);
+		delay_count++;
 
-		mod_phy_reg(pi, 0x43c, (0x1 << 1), 1 << 1);
+		if (delay_count > (10 * 500))
+			break;
+	}
 
-		and_phy_reg(pi, 0x44c,
-			    ~(u16) ((0x1 << 3) |
-				    (0x1 << 5) |
-				    (0x1 << 12) |
-				    (0x1 << 0) | (0x1 << 1) | (0x1 << 2)));
+	return (0 == wlc_lcnphy_iqcal_active(pi));
+}
 
-		and_phy_reg(pi, 0x44d,
-			    ~(u16) ((0x1 << 3) | (0x1 << 5) | (0x1 << 14)));
-		mod_phy_reg(pi, 0x44d, (0x1 << 2), 1 << 2);
+static void
+wlc_lcnphy_tx_iqlo_loopback_cleanup(struct brcms_phy *pi, u16 *values_to_save)
+{
+	int i;
 
-		mod_phy_reg(pi, 0x44d, (0x1 << 1) | (0x1 << 0), (0x1 << 0));
+	and_phy_reg(pi, 0x44c, 0x0 >> 11);
 
-		and_phy_reg(pi, 0x4f9,
-			    ~(u16) ((0x1 << 0) | (0x1 << 1) | (0x1 << 2)));
+	and_phy_reg(pi, 0x43b, 0xC);
 
-		and_phy_reg(pi, 0x4fa,
-			    ~(u16) ((0x1 << 0) | (0x1 << 1) | (0x1 << 2)));
-	} else {
+	for (i = 0; i < 20; i++)
+		write_radio_reg(pi, iqlo_loopback_rf_regs[i],
+				values_to_save[i]);
+}
 
-		mod_phy_reg(pi, 0x43b, (0x1 << 1), 1 << 1);
-		mod_phy_reg(pi, 0x43c, (0x1 << 1), 0 << 1);
+static void
+wlc_lcnphy_tx_iqlo_cal(struct brcms_phy *pi,
+		       struct lcnphy_txgains *target_gains,
+		       enum lcnphy_cal_mode cal_mode, bool keep_tone)
+{
 
-		mod_phy_reg(pi, 0x43b, (0x1 << 4), 1 << 4);
-		mod_phy_reg(pi, 0x43c, (0x1 << 6), 0 << 6);
+	struct lcnphy_txgains cal_gains, temp_gains;
+	u16 hash;
+	u8 band_idx;
+	int j;
+	u16 ncorr_override[5];
+	u16 syst_coeffs[] = { 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+			      0x0000, 0x0000, 0x0000, 0x0000, 0x0000};
 
-		mod_phy_reg(pi, 0x44c, (0x1 << 12), 1 << 12);
-		mod_phy_reg(pi, 0x44d, (0x1 << 14), 1 << 14);
+	u16 commands_fullcal[] = {
+		0x8434, 0x8334, 0x8084, 0x8267, 0x8056, 0x8234
+	};
 
-		wlc_lcnphy_set_trsw_override(pi, true, false);
+	u16 commands_recal[] = {
+		0x8434, 0x8334, 0x8084, 0x8267, 0x8056, 0x8234
+	};
 
-		mod_phy_reg(pi, 0x44d, (0x1 << 2), 0 << 2);
-		mod_phy_reg(pi, 0x44c, (0x1 << 2), 1 << 2);
+	u16 command_nums_fullcal[] = {
+		0x7a97, 0x7a97, 0x7a97, 0x7a87, 0x7a87, 0x7b97
+	};
 
-		if (CHSPEC_IS2G(pi->radio_chanspec)) {
+	u16 command_nums_recal[] = {
+		0x7a97, 0x7a97, 0x7a97, 0x7a87, 0x7a87, 0x7b97
+	};
+	u16 *command_nums = command_nums_fullcal;
 
-			mod_phy_reg(pi, 0x44c, (0x1 << 3), 1 << 3);
-			mod_phy_reg(pi, 0x44d, (0x1 << 3), 1 << 3);
+	u16 *start_coeffs = NULL, *cal_cmds = NULL, cal_type, diq_start;
+	u16 tx_pwr_ctrl_old, save_txpwrctrlrfctrl2;
+	u16 save_sslpnCalibClkEnCtrl, save_sslpnRxFeClkEnCtrl;
+	bool tx_gain_override_old;
+	struct lcnphy_txgains old_gains;
+	uint i, n_cal_cmds = 0, n_cal_start = 0;
+	u16 *values_to_save;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
-			mod_phy_reg(pi, 0x44c, (0x1 << 5), 1 << 5);
-			mod_phy_reg(pi, 0x44d, (0x1 << 5), 0 << 5);
+	values_to_save = kmalloc(sizeof(u16) * 20, GFP_ATOMIC);
+	if (NULL == values_to_save)
+		return;
 
-			mod_phy_reg(pi, 0x4f9, (0x1 << 1), 1 << 1);
-			mod_phy_reg(pi, 0x4fa, (0x1 << 1), 1 << 1);
+	save_sslpnRxFeClkEnCtrl = read_phy_reg(pi, 0x6db);
+	save_sslpnCalibClkEnCtrl = read_phy_reg(pi, 0x6da);
 
-			mod_phy_reg(pi, 0x4f9, (0x1 << 2), 1 << 2);
-			mod_phy_reg(pi, 0x4fa, (0x1 << 2), 1 << 2);
+	or_phy_reg(pi, 0x6da, 0x40);
+	or_phy_reg(pi, 0x6db, 0x3);
 
-			mod_phy_reg(pi, 0x4f9, (0x1 << 0), 1 << 0);
-			mod_phy_reg(pi, 0x4fa, (0x1 << 0), 1 << 0);
-		} else {
-
-			mod_phy_reg(pi, 0x44c, (0x1 << 3), 1 << 3);
-			mod_phy_reg(pi, 0x44d, (0x1 << 3), 0 << 3);
-
-			mod_phy_reg(pi, 0x44c, (0x1 << 5), 1 << 5);
-			mod_phy_reg(pi, 0x44d, (0x1 << 5), 1 << 5);
-
-			mod_phy_reg(pi, 0x4f9, (0x1 << 1), 1 << 1);
-			mod_phy_reg(pi, 0x4fa, (0x1 << 1), 0 << 1);
+	switch (cal_mode) {
+	case LCNPHY_CAL_FULL:
+		start_coeffs = syst_coeffs;
+		cal_cmds = commands_fullcal;
+		n_cal_cmds = ARRAY_SIZE(commands_fullcal);
+		break;
 
-			mod_phy_reg(pi, 0x4f9, (0x1 << 2), 1 << 2);
-			mod_phy_reg(pi, 0x4fa, (0x1 << 2), 0 << 2);
+	case LCNPHY_CAL_RECAL:
+		start_coeffs = syst_coeffs;
+		cal_cmds = commands_recal;
+		n_cal_cmds = ARRAY_SIZE(commands_recal);
+		command_nums = command_nums_recal;
+		break;
 
-			mod_phy_reg(pi, 0x4f9, (0x1 << 0), 1 << 0);
-			mod_phy_reg(pi, 0x4fa, (0x1 << 0), 0 << 0);
-		}
+	default:
+		break;
 	}
-}
 
-static void
-wlc_lcnphy_run_samples(struct brcms_phy *pi,
-		       u16 num_samps,
-		       u16 num_loops, u16 wait, bool iqcalmode)
-{
+	wlc_lcnphy_common_write_table(pi, LCNPHY_TBL_ID_IQLOCAL,
+				      start_coeffs, 11, 16, 64);
 
-	or_phy_reg(pi, 0x6da, 0x8080);
+	write_phy_reg(pi, 0x6da, 0xffff);
+	mod_phy_reg(pi, 0x503, (0x1 << 3), (1) << 3);
 
-	mod_phy_reg(pi, 0x642, (0x7f << 0), (num_samps - 1) << 0);
-	if (num_loops != 0xffff)
-		num_loops--;
-	mod_phy_reg(pi, 0x640, (0xffff << 0), num_loops << 0);
+	tx_pwr_ctrl_old = wlc_lcnphy_get_tx_pwr_ctrl(pi);
 
-	mod_phy_reg(pi, 0x641, (0xffff << 0), wait << 0);
+	mod_phy_reg(pi, 0x4a4, (0x1 << 12), (1) << 12);
 
-	if (iqcalmode) {
+	wlc_lcnphy_set_tx_pwr_ctrl(pi, LCNPHY_TX_PWR_CTRL_OFF);
 
-		and_phy_reg(pi, 0x453, (u16) ~(0x1 << 15));
-		or_phy_reg(pi, 0x453, (0x1 << 15));
-	} else {
-		write_phy_reg(pi, 0x63f, 1);
-		wlc_lcnphy_tx_pu(pi, 1);
-	}
+	save_txpwrctrlrfctrl2 = read_phy_reg(pi, 0x4db);
 
-	or_radio_reg(pi, RADIO_2064_REG112, 0x6);
-}
+	mod_phy_reg(pi, 0x4db, (0x3ff << 0), (0x2a6) << 0);
 
-void wlc_lcnphy_deaf_mode(struct brcms_phy *pi, bool mode)
-{
+	mod_phy_reg(pi, 0x4db, (0x7 << 12), (2) << 12);
 
-	u8 phybw40;
-	phybw40 = CHSPEC_IS40(pi->radio_chanspec);
+	wlc_lcnphy_tx_iqlo_loopback(pi, values_to_save);
 
-	if (LCNREV_LT(pi->pubpi.phy_rev, 2)) {
-		mod_phy_reg(pi, 0x4b0, (0x1 << 5), (mode) << 5);
-		mod_phy_reg(pi, 0x4b1, (0x1 << 9), 0 << 9);
-	} else {
-		mod_phy_reg(pi, 0x4b0, (0x1 << 5), (mode) << 5);
-		mod_phy_reg(pi, 0x4b1, (0x1 << 9), 0 << 9);
-	}
+	tx_gain_override_old = wlc_lcnphy_tx_gain_override_enabled(pi);
+	if (tx_gain_override_old)
+		wlc_lcnphy_get_tx_gain(pi, &old_gains);
 
-	if (phybw40 == 0) {
-		mod_phy_reg((pi), 0x410,
-			    (0x1 << 6) |
-			    (0x1 << 5),
-			    ((CHSPEC_IS2G(
-				      pi->radio_chanspec)) ? (!mode) : 0) <<
-			    6 | (!mode) << 5);
-		mod_phy_reg(pi, 0x410, (0x1 << 7), (mode) << 7);
+	if (!target_gains) {
+		if (!tx_gain_override_old)
+			wlc_lcnphy_set_tx_pwr_by_index(pi,
+						       pi_lcn->lcnphy_tssi_idx);
+		wlc_lcnphy_get_tx_gain(pi, &temp_gains);
+		target_gains = &temp_gains;
 	}
-}
-
-void
-wlc_lcnphy_start_tx_tone(struct brcms_phy *pi, s32 f_kHz, u16 max_val,
-			 bool iqcalmode)
-{
-	u8 phy_bw;
-	u16 num_samps, t, k;
-	u32 bw;
-	s32 theta = 0, rot = 0;
-	struct cordic_iq tone_samp;
-	u32 data_buf[64];
-	u16 i_samp, q_samp;
-	struct phytbl_info tab;
-	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
-	pi->phy_tx_tone_freq = f_kHz;
+	hash = (target_gains->gm_gain << 8) |
+	       (target_gains->pga_gain << 4) | (target_gains->pad_gain);
 
-	wlc_lcnphy_deaf_mode(pi, true);
+	band_idx = (CHSPEC_IS5G(pi->radio_chanspec) ? 1 : 0);
 
-	phy_bw = 40;
-	if (pi_lcn->lcnphy_spurmod) {
-		write_phy_reg(pi, 0x942, 0x2);
-		write_phy_reg(pi, 0x93b, 0x0);
-		write_phy_reg(pi, 0x93c, 0x0);
-		wlc_lcnphy_txrx_spur_avoidance_mode(pi, false);
+	cal_gains = *target_gains;
+	memset(ncorr_override, 0, sizeof(ncorr_override));
+	for (j = 0; j < iqcal_gainparams_numgains_lcnphy[band_idx]; j++) {
+		if (hash == tbl_iqcal_gainparams_lcnphy[band_idx][j][0]) {
+			cal_gains.gm_gain =
+				tbl_iqcal_gainparams_lcnphy[band_idx][j][1];
+			cal_gains.pga_gain =
+				tbl_iqcal_gainparams_lcnphy[band_idx][j][2];
+			cal_gains.pad_gain =
+				tbl_iqcal_gainparams_lcnphy[band_idx][j][3];
+			memcpy(ncorr_override,
+			       &tbl_iqcal_gainparams_lcnphy[band_idx][j][3],
+			       sizeof(ncorr_override));
+			break;
+		}
 	}
 
-	if (f_kHz) {
-		k = 1;
-		do {
-			bw = phy_bw * 1000 * k;
-			num_samps = bw / ABS(f_kHz);
-			k++;
-		} while ((num_samps * (u32) (ABS(f_kHz))) != bw);
-	} else
-		num_samps = 2;
+	wlc_lcnphy_set_tx_gain(pi, &cal_gains);
 
-	rot = ((f_kHz * 36) / phy_bw) / 100;
-	theta = 0;
+	write_phy_reg(pi, 0x453, 0xaa9);
+	write_phy_reg(pi, 0x93d, 0xc0);
 
-	for (t = 0; t < num_samps; t++) {
+	wlc_lcnphy_common_write_table(pi, LCNPHY_TBL_ID_IQLOCAL,
+				      lcnphy_iqcal_loft_gainladder,
+				      ARRAY_SIZE(lcnphy_iqcal_loft_gainladder),
+				      16, 0);
 
-		tone_samp = cordic_calc_iq(theta);
+	wlc_lcnphy_common_write_table(pi, LCNPHY_TBL_ID_IQLOCAL,
+				      lcnphy_iqcal_ir_gainladder,
+				      ARRAY_SIZE(
+					      lcnphy_iqcal_ir_gainladder), 16,
+				      32);
 
-		theta += rot;
+	if (pi->phy_tx_tone_freq) {
 
-		i_samp = (u16) (FLOAT(tone_samp.i * max_val) & 0x3ff);
-		q_samp = (u16) (FLOAT(tone_samp.q * max_val) & 0x3ff);
-		data_buf[t] = (i_samp << 10) | q_samp;
+		wlc_lcnphy_stop_tx_tone(pi);
+		udelay(5);
+		wlc_lcnphy_start_tx_tone(pi, 3750, 88, 1);
+	} else {
+		wlc_lcnphy_start_tx_tone(pi, 3750, 88, 1);
 	}
 
-	mod_phy_reg(pi, 0x6d6, (0x3 << 0), 0 << 0);
-
-	mod_phy_reg(pi, 0x6da, (0x1 << 3), 1 << 3);
+	write_phy_reg(pi, 0x6da, 0xffff);
 
-	tab.tbl_ptr = data_buf;
-	tab.tbl_len = num_samps;
-	tab.tbl_id = LCNPHY_TBL_ID_SAMPLEPLAY;
-	tab.tbl_offset = 0;
-	tab.tbl_width = 32;
-	wlc_lcnphy_write_table(pi, &tab);
+	for (i = n_cal_start; i < n_cal_cmds; i++) {
+		u16 zero_diq = 0;
+		u16 best_coeffs[11];
+		u16 command_num;
 
-	wlc_lcnphy_run_samples(pi, num_samps, 0xffff, 0, iqcalmode);
-}
+		cal_type = (cal_cmds[i] & 0x0f00) >> 8;
 
-void wlc_lcnphy_stop_tx_tone(struct brcms_phy *pi)
-{
-	s16 playback_status;
-	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+		command_num = command_nums[i];
+		if (ncorr_override[cal_type])
+			command_num =
+				ncorr_override[cal_type] << 8 | (command_num &
+								 0xff);
 
-	pi->phy_tx_tone_freq = 0;
-	if (pi_lcn->lcnphy_spurmod) {
-		write_phy_reg(pi, 0x942, 0x7);
-		write_phy_reg(pi, 0x93b, 0x2017);
-		write_phy_reg(pi, 0x93c, 0x27c5);
-		wlc_lcnphy_txrx_spur_avoidance_mode(pi, true);
-	}
+		write_phy_reg(pi, 0x452, command_num);
 
-	playback_status = read_phy_reg(pi, 0x644);
-	if (playback_status & (0x1 << 0)) {
-		wlc_lcnphy_tx_pu(pi, 0);
-		mod_phy_reg(pi, 0x63f, (0x1 << 1), 1 << 1);
-	} else if (playback_status & (0x1 << 1))
-		mod_phy_reg(pi, 0x453, (0x1 << 15), 0 << 15);
+		if ((cal_type == 3) || (cal_type == 4)) {
+			wlc_lcnphy_common_read_table(pi, LCNPHY_TBL_ID_IQLOCAL,
+						     &diq_start, 1, 16, 69);
 
-	mod_phy_reg(pi, 0x6d6, (0x3 << 0), 1 << 0);
+			wlc_lcnphy_common_write_table(pi, LCNPHY_TBL_ID_IQLOCAL,
+						      &zero_diq, 1, 16, 69);
+		}
 
-	mod_phy_reg(pi, 0x6da, (0x1 << 3), 0 << 3);
+		write_phy_reg(pi, 0x451, cal_cmds[i]);
 
-	mod_phy_reg(pi, 0x6da, (0x1 << 7), 0 << 7);
+		if (!wlc_lcnphy_iqcal_wait(pi))
+			goto cleanup;
 
-	and_radio_reg(pi, RADIO_2064_REG112, 0xFFF9);
+		wlc_lcnphy_common_read_table(pi, LCNPHY_TBL_ID_IQLOCAL,
+					     best_coeffs,
+					     ARRAY_SIZE(best_coeffs), 16, 96);
+		wlc_lcnphy_common_write_table(pi, LCNPHY_TBL_ID_IQLOCAL,
+					      best_coeffs,
+					      ARRAY_SIZE(best_coeffs), 16, 64);
 
-	wlc_lcnphy_deaf_mode(pi, false);
-}
+		if ((cal_type == 3) || (cal_type == 4))
+			wlc_lcnphy_common_write_table(pi, LCNPHY_TBL_ID_IQLOCAL,
+						      &diq_start, 1, 16, 69);
+		wlc_lcnphy_common_read_table(pi, LCNPHY_TBL_ID_IQLOCAL,
+					     pi_lcn->lcnphy_cal_results.
+					     txiqlocal_bestcoeffs,
+					     ARRAY_SIZE(pi_lcn->
+							lcnphy_cal_results.
+							txiqlocal_bestcoeffs),
+					     16, 96);
+	}
 
-static void wlc_lcnphy_clear_trsw_override(struct brcms_phy *pi)
-{
+	wlc_lcnphy_common_read_table(pi, LCNPHY_TBL_ID_IQLOCAL,
+				     pi_lcn->lcnphy_cal_results.
+				     txiqlocal_bestcoeffs,
+				     ARRAY_SIZE(pi_lcn->lcnphy_cal_results.
+						txiqlocal_bestcoeffs), 16, 96);
+	pi_lcn->lcnphy_cal_results.txiqlocal_bestcoeffs_valid = true;
 
-	and_phy_reg(pi, 0x44c, (u16) ~((0x1 << 1) | (0x1 << 0)));
-}
+	wlc_lcnphy_common_write_table(pi, LCNPHY_TBL_ID_IQLOCAL,
+				      &pi_lcn->lcnphy_cal_results.
+				      txiqlocal_bestcoeffs[0], 4, 16, 80);
 
-void wlc_lcnphy_get_tx_iqcc(struct brcms_phy *pi, u16 *a, u16 *b)
-{
-	u16 iqcc[2];
-	struct phytbl_info tab;
+	wlc_lcnphy_common_write_table(pi, LCNPHY_TBL_ID_IQLOCAL,
+				      &pi_lcn->lcnphy_cal_results.
+				      txiqlocal_bestcoeffs[5], 2, 16, 85);
 
-	tab.tbl_ptr = iqcc;
-	tab.tbl_len = 2;
-	tab.tbl_id = 0;
-	tab.tbl_offset = 80;
-	tab.tbl_width = 16;
-	wlc_lcnphy_read_table(pi, &tab);
+cleanup:
+	wlc_lcnphy_tx_iqlo_loopback_cleanup(pi, values_to_save);
+	kfree(values_to_save);
 
-	*a = iqcc[0];
-	*b = iqcc[1];
-}
+	if (!keep_tone)
+		wlc_lcnphy_stop_tx_tone(pi);
 
-u16 wlc_lcnphy_get_tx_locc(struct brcms_phy *pi)
-{
-	struct phytbl_info tab;
-	u16 didq;
+	write_phy_reg(pi, 0x4db, save_txpwrctrlrfctrl2);
 
-	tab.tbl_id = 0;
-	tab.tbl_width = 16;
-	tab.tbl_ptr = &didq;
-	tab.tbl_len = 1;
-	tab.tbl_offset = 85;
-	wlc_lcnphy_read_table(pi, &tab);
+	write_phy_reg(pi, 0x453, 0);
+
+	if (tx_gain_override_old)
+		wlc_lcnphy_set_tx_gain(pi, &old_gains);
+	wlc_lcnphy_set_tx_pwr_ctrl(pi, tx_pwr_ctrl_old);
+
+	write_phy_reg(pi, 0x6da, save_sslpnCalibClkEnCtrl);
+	write_phy_reg(pi, 0x6db, save_sslpnRxFeClkEnCtrl);
 
-	return didq;
 }
 
-static void wlc_lcnphy_txpwrtbl_iqlo_cal(struct brcms_phy *pi)
+static void wlc_lcnphy_idle_tssi_est(struct brcms_phy_pub *ppi)
 {
-
-	struct lcnphy_txgains target_gains, old_gains;
-	u8 save_bb_mult;
-	u16 a, b, didq, save_pa_gain = 0;
-	uint idx, SAVE_txpwrindex = 0xFF;
-	u32 val;
+	bool suspend, tx_gain_override_old;
+	struct lcnphy_txgains old_gains;
+	struct brcms_phy *pi = (struct brcms_phy *) ppi;
+	u16 idleTssi, idleTssi0_2C, idleTssi0_OB, idleTssi0_regvalue_OB,
+	    idleTssi0_regvalue_2C;
 	u16 SAVE_txpwrctrl = wlc_lcnphy_get_tx_pwr_ctrl(pi);
-	struct phytbl_info tab;
-	u8 ei0, eq0, fi0, fq0;
-	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	u16 SAVE_lpfgain = read_radio_reg(pi, RADIO_2064_REG112);
+	u16 SAVE_jtag_bb_afe_switch =
+		read_radio_reg(pi, RADIO_2064_REG007) & 1;
+	u16 SAVE_jtag_auxpga = read_radio_reg(pi, RADIO_2064_REG0FF) & 0x10;
+	u16 SAVE_iqadc_aux_en = read_radio_reg(pi, RADIO_2064_REG11F) & 4;
+	idleTssi = read_phy_reg(pi, 0x4ab);
+	suspend =
+		(0 ==
+		 (R_REG(&((struct brcms_phy *) pi)->regs->maccontrol) &
+		  MCTL_EN_MAC));
+	if (!suspend)
+		wlapi_suspend_mac_and_wait(pi->sh->physhim);
+	wlc_lcnphy_set_tx_pwr_ctrl(pi, LCNPHY_TX_PWR_CTRL_OFF);
 
+	tx_gain_override_old = wlc_lcnphy_tx_gain_override_enabled(pi);
 	wlc_lcnphy_get_tx_gain(pi, &old_gains);
-	save_pa_gain = wlc_lcnphy_get_pa_gain(pi);
 
-	save_bb_mult = wlc_lcnphy_get_bbmult(pi);
+	wlc_lcnphy_enable_tx_gain_override(pi);
+	wlc_lcnphy_set_tx_pwr_by_index(pi, 127);
+	write_radio_reg(pi, RADIO_2064_REG112, 0x6);
+	mod_radio_reg(pi, RADIO_2064_REG007, 0x1, 1);
+	mod_radio_reg(pi, RADIO_2064_REG0FF, 0x10, 1 << 4);
+	mod_radio_reg(pi, RADIO_2064_REG11F, 0x4, 1 << 2);
+	wlc_lcnphy_tssi_setup(pi);
+	wlc_phy_do_dummy_tx(pi, true, OFF);
+	idleTssi = ((read_phy_reg(pi, 0x4ab) & (0x1ff << 0))
+		    >> 0);
 
-	if (SAVE_txpwrctrl == LCNPHY_TX_PWR_CTRL_OFF)
-		SAVE_txpwrindex = wlc_lcnphy_get_current_tx_pwr_idx(pi);
+	idleTssi0_2C = ((read_phy_reg(pi, 0x63e) & (0x1ff << 0))
+			>> 0);
 
-	wlc_lcnphy_set_tx_pwr_ctrl(pi, LCNPHY_TX_PWR_CTRL_OFF);
+	if (idleTssi0_2C >= 256)
+		idleTssi0_OB = idleTssi0_2C - 256;
+	else
+		idleTssi0_OB = idleTssi0_2C + 256;
 
-	target_gains.gm_gain = 7;
-	target_gains.pga_gain = 0;
-	target_gains.pad_gain = 21;
-	target_gains.dac_gain = 0;
-	wlc_lcnphy_set_tx_gain(pi, &target_gains);
-	wlc_lcnphy_set_tx_pwr_by_index(pi, 16);
+	idleTssi0_regvalue_OB = idleTssi0_OB;
+	if (idleTssi0_regvalue_OB >= 256)
+		idleTssi0_regvalue_2C = idleTssi0_regvalue_OB - 256;
+	else
+		idleTssi0_regvalue_2C = idleTssi0_regvalue_OB + 256;
+	mod_phy_reg(pi, 0x4a6, (0x1ff << 0), (idleTssi0_regvalue_2C) << 0);
 
-	if (LCNREV_IS(pi->pubpi.phy_rev, 1) || pi_lcn->lcnphy_hw_iqcal_en) {
+	mod_phy_reg(pi, 0x44c, (0x1 << 12), (0) << 12);
 
-		wlc_lcnphy_set_tx_pwr_by_index(pi, 30);
+	wlc_lcnphy_set_tx_gain_override(pi, tx_gain_override_old);
+	wlc_lcnphy_set_tx_gain(pi, &old_gains);
+	wlc_lcnphy_set_tx_pwr_ctrl(pi, SAVE_txpwrctrl);
 
-		wlc_lcnphy_tx_iqlo_cal(pi, &target_gains,
-				       (pi_lcn->
-					lcnphy_recal ? LCNPHY_CAL_RECAL :
-					LCNPHY_CAL_FULL), false);
-	} else {
-		wlc_lcnphy_tx_iqlo_soft_cal_full(pi);
-	}
+	write_radio_reg(pi, RADIO_2064_REG112, SAVE_lpfgain);
+	mod_radio_reg(pi, RADIO_2064_REG007, 0x1, SAVE_jtag_bb_afe_switch);
+	mod_radio_reg(pi, RADIO_2064_REG0FF, 0x10, SAVE_jtag_auxpga);
+	mod_radio_reg(pi, RADIO_2064_REG11F, 0x4, SAVE_iqadc_aux_en);
+	mod_radio_reg(pi, RADIO_2064_REG112, 0x80, 1 << 7);
+	if (!suspend)
+		wlapi_enable_mac(pi->sh->physhim);
+}
 
-	wlc_lcnphy_get_radio_loft(pi, &ei0, &eq0, &fi0, &fq0);
-	if ((ABS((s8) fi0) == 15) && (ABS((s8) fq0) == 15)) {
-		if (CHSPEC_IS5G(pi->radio_chanspec)) {
-			target_gains.gm_gain = 255;
-			target_gains.pga_gain = 255;
-			target_gains.pad_gain = 0xf0;
-			target_gains.dac_gain = 0;
-		} else {
-			target_gains.gm_gain = 7;
-			target_gains.pga_gain = 45;
-			target_gains.pad_gain = 186;
-			target_gains.dac_gain = 0;
-		}
+static void wlc_lcnphy_vbat_temp_sense_setup(struct brcms_phy *pi, u8 mode)
+{
+	bool suspend;
+	u16 save_txpwrCtrlEn;
+	u8 auxpga_vmidcourse, auxpga_vmidfine, auxpga_gain;
+	u16 auxpga_vmid;
+	struct phytbl_info tab;
+	u32 val;
+	u8 save_reg007, save_reg0FF, save_reg11F, save_reg005, save_reg025,
+	   save_reg112;
+	u16 values_to_save[14];
+	s8 index;
+	int i;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	udelay(999);
 
-		if (LCNREV_IS(pi->pubpi.phy_rev, 1)
-		    || pi_lcn->lcnphy_hw_iqcal_en) {
+	save_reg007 = (u8) read_radio_reg(pi, RADIO_2064_REG007);
+	save_reg0FF = (u8) read_radio_reg(pi, RADIO_2064_REG0FF);
+	save_reg11F = (u8) read_radio_reg(pi, RADIO_2064_REG11F);
+	save_reg005 = (u8) read_radio_reg(pi, RADIO_2064_REG005);
+	save_reg025 = (u8) read_radio_reg(pi, RADIO_2064_REG025);
+	save_reg112 = (u8) read_radio_reg(pi, RADIO_2064_REG112);
 
-			target_gains.pga_gain = 0;
-			target_gains.pad_gain = 30;
-			wlc_lcnphy_set_tx_pwr_by_index(pi, 16);
-			wlc_lcnphy_tx_iqlo_cal(pi, &target_gains,
-					       LCNPHY_CAL_FULL, false);
-		} else {
-			wlc_lcnphy_tx_iqlo_soft_cal_full(pi);
-		}
-	}
+	for (i = 0; i < 14; i++)
+		values_to_save[i] = read_phy_reg(pi, tempsense_phy_regs[i]);
+	suspend = (0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
+	if (!suspend)
+		wlapi_suspend_mac_and_wait(pi->sh->physhim);
+	save_txpwrCtrlEn = read_radio_reg(pi, 0x4a4);
 
-	wlc_lcnphy_get_tx_iqcc(pi, &a, &b);
+	wlc_lcnphy_set_tx_pwr_ctrl(pi, LCNPHY_TX_PWR_CTRL_OFF);
+	index = pi_lcn->lcnphy_current_index;
+	wlc_lcnphy_set_tx_pwr_by_index(pi, 127);
+	mod_radio_reg(pi, RADIO_2064_REG007, 0x1, 0x1);
+	mod_radio_reg(pi, RADIO_2064_REG0FF, 0x10, 0x1 << 4);
+	mod_radio_reg(pi, RADIO_2064_REG11F, 0x4, 0x1 << 2);
+	mod_phy_reg(pi, 0x503, (0x1 << 0), (0) << 0);
 
-	didq = wlc_lcnphy_get_tx_locc(pi);
+	mod_phy_reg(pi, 0x503, (0x1 << 2), (0) << 2);
 
-	tab.tbl_id = LCNPHY_TBL_ID_TXPWRCTL;
-	tab.tbl_width = 32;
-	tab.tbl_ptr = &val;
+	mod_phy_reg(pi, 0x4a4, (0x1 << 14), (0) << 14);
 
-	tab.tbl_len = 1;
-	tab.tbl_offset = LCNPHY_TX_PWR_CTRL_RATE_OFFSET;
+	mod_phy_reg(pi, 0x4a4, (0x1 << 15), (0) << 15);
 
-	for (idx = 0; idx < 128; idx++) {
-		tab.tbl_offset = LCNPHY_TX_PWR_CTRL_IQ_OFFSET + idx;
+	mod_phy_reg(pi, 0x4d0, (0x1 << 5), (0) << 5);
 
-		wlc_lcnphy_read_table(pi, &tab);
-		val = (val & 0xfff00000) |
-		      ((u32) (a & 0x3FF) << 10) | (b & 0x3ff);
-		wlc_lcnphy_write_table(pi, &tab);
+	mod_phy_reg(pi, 0x4a5, (0xff << 0), (255) << 0);
 
-		val = didq;
-		tab.tbl_offset = LCNPHY_TX_PWR_CTRL_LO_OFFSET + idx;
-		wlc_lcnphy_write_table(pi, &tab);
-	}
+	mod_phy_reg(pi, 0x4a5, (0x7 << 12), (5) << 12);
 
-	pi_lcn->lcnphy_cal_results.txiqlocal_a = a;
-	pi_lcn->lcnphy_cal_results.txiqlocal_b = b;
-	pi_lcn->lcnphy_cal_results.txiqlocal_didq = didq;
-	pi_lcn->lcnphy_cal_results.txiqlocal_ei0 = ei0;
-	pi_lcn->lcnphy_cal_results.txiqlocal_eq0 = eq0;
-	pi_lcn->lcnphy_cal_results.txiqlocal_fi0 = fi0;
-	pi_lcn->lcnphy_cal_results.txiqlocal_fq0 = fq0;
+	mod_phy_reg(pi, 0x4a5, (0x7 << 8), (0) << 8);
 
-	wlc_lcnphy_set_bbmult(pi, save_bb_mult);
-	wlc_lcnphy_set_pa_gain(pi, save_pa_gain);
-	wlc_lcnphy_set_tx_gain(pi, &old_gains);
+	mod_phy_reg(pi, 0x40d, (0xff << 0), (64) << 0);
 
-	if (SAVE_txpwrctrl != LCNPHY_TX_PWR_CTRL_OFF)
-		wlc_lcnphy_set_tx_pwr_ctrl(pi, SAVE_txpwrctrl);
-	else
-		wlc_lcnphy_set_tx_pwr_by_index(pi, SAVE_txpwrindex);
-}
+	mod_phy_reg(pi, 0x40d, (0x7 << 8), (6) << 8);
 
-s16 wlc_lcnphy_tempsense_new(struct brcms_phy *pi, bool mode)
-{
-	u16 tempsenseval1, tempsenseval2;
-	s16 avg = 0;
-	bool suspend = 0;
+	mod_phy_reg(pi, 0x4a2, (0xff << 0), (64) << 0);
 
-	if (mode == 1) {
-		suspend =
-			(0 ==
-			 (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
-		if (!suspend)
-			wlapi_suspend_mac_and_wait(pi->sh->physhim);
-		wlc_lcnphy_vbat_temp_sense_setup(pi, TEMPSENSE);
-	}
-	tempsenseval1 = read_phy_reg(pi, 0x476) & 0x1FF;
-	tempsenseval2 = read_phy_reg(pi, 0x477) & 0x1FF;
+	mod_phy_reg(pi, 0x4a2, (0x7 << 8), (6) << 8);
 
-	if (tempsenseval1 > 255)
-		avg = (s16) (tempsenseval1 - 512);
-	else
-		avg = (s16) tempsenseval1;
+	mod_phy_reg(pi, 0x4d9, (0x7 << 4), (2) << 4);
 
-	if (tempsenseval2 > 255)
-		avg += (s16) (tempsenseval2 - 512);
-	else
-		avg += (s16) tempsenseval2;
+	mod_phy_reg(pi, 0x4d9, (0x7 << 8), (3) << 8);
 
-	avg /= 2;
+	mod_phy_reg(pi, 0x4d9, (0x7 << 12), (1) << 12);
 
-	if (mode == 1) {
+	mod_phy_reg(pi, 0x4da, (0x1 << 12), (0) << 12);
 
-		mod_phy_reg(pi, 0x448, (0x1 << 14), (1) << 14);
+	mod_phy_reg(pi, 0x4da, (0x1 << 13), (1) << 13);
 
-		udelay(100);
-		mod_phy_reg(pi, 0x448, (0x1 << 14), (0) << 14);
+	mod_phy_reg(pi, 0x4a6, (0x1 << 15), (1) << 15);
 
-		if (!suspend)
-			wlapi_enable_mac(pi->sh->physhim);
-	}
-	return avg;
-}
-
-u16 wlc_lcnphy_tempsense(struct brcms_phy *pi, bool mode)
-{
-	u16 tempsenseval1, tempsenseval2;
-	s32 avg = 0;
-	bool suspend = 0;
-	u16 SAVE_txpwrctrl = wlc_lcnphy_get_tx_pwr_ctrl(pi);
-	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	write_radio_reg(pi, RADIO_2064_REG025, 0xC);
 
-	if (mode == 1) {
-		suspend =
-			(0 ==
-			 (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
-		if (!suspend)
-			wlapi_suspend_mac_and_wait(pi->sh->physhim);
-		wlc_lcnphy_vbat_temp_sense_setup(pi, TEMPSENSE);
-	}
-	tempsenseval1 = read_phy_reg(pi, 0x476) & 0x1FF;
-	tempsenseval2 = read_phy_reg(pi, 0x477) & 0x1FF;
+	mod_radio_reg(pi, RADIO_2064_REG005, 0x8, 0x1 << 3);
 
-	if (tempsenseval1 > 255)
-		avg = (int)(tempsenseval1 - 512);
-	else
-		avg = (int)tempsenseval1;
+	mod_phy_reg(pi, 0x938, (0x1 << 2), (1) << 2);
 
-	if (pi_lcn->lcnphy_tempsense_option == 1 || pi->hwpwrctrl_capable) {
-		if (tempsenseval2 > 255)
-			avg = (int)(avg - tempsenseval2 + 512);
-		else
-			avg = (int)(avg - tempsenseval2);
-	} else {
-		if (tempsenseval2 > 255)
-			avg = (int)(avg + tempsenseval2 - 512);
-		else
-			avg = (int)(avg + tempsenseval2);
-		avg = avg / 2;
-	}
-	if (avg < 0)
-		avg = avg + 512;
+	mod_phy_reg(pi, 0x939, (0x1 << 2), (1) << 2);
 
-	if (pi_lcn->lcnphy_tempsense_option == 2)
-		avg = tempsenseval1;
+	mod_phy_reg(pi, 0x4a4, (0x1 << 12), (1) << 12);
 
-	if (mode)
-		wlc_lcnphy_set_tx_pwr_ctrl(pi, SAVE_txpwrctrl);
+	val = wlc_lcnphy_rfseq_tbl_adc_pwrup(pi);
+	tab.tbl_id = LCNPHY_TBL_ID_RFSEQ;
+	tab.tbl_width = 16;
+	tab.tbl_len = 1;
+	tab.tbl_ptr = &val;
+	tab.tbl_offset = 6;
+	wlc_lcnphy_write_table(pi, &tab);
+	if (mode == TEMPSENSE) {
+		mod_phy_reg(pi, 0x4d7, (0x1 << 3), (1) << 3);
 
-	if (mode == 1) {
+		mod_phy_reg(pi, 0x4d7, (0x7 << 12), (1) << 12);
 
-		mod_phy_reg(pi, 0x448, (0x1 << 14), (1) << 14);
+		auxpga_vmidcourse = 8;
+		auxpga_vmidfine = 0x4;
+		auxpga_gain = 2;
+		mod_radio_reg(pi, RADIO_2064_REG082, 0x20, 1 << 5);
+	} else {
+		mod_phy_reg(pi, 0x4d7, (0x1 << 3), (1) << 3);
 
-		udelay(100);
-		mod_phy_reg(pi, 0x448, (0x1 << 14), (0) << 14);
+		mod_phy_reg(pi, 0x4d7, (0x7 << 12), (3) << 12);
 
-		if (!suspend)
-			wlapi_enable_mac(pi->sh->physhim);
+		auxpga_vmidcourse = 7;
+		auxpga_vmidfine = 0xa;
+		auxpga_gain = 2;
 	}
-	return (u16) avg;
-}
+	auxpga_vmid =
+		(u16) ((2 << 8) | (auxpga_vmidcourse << 4) | auxpga_vmidfine);
+	mod_phy_reg(pi, 0x4d8, (0x1 << 0), (1) << 0);
 
-s8 wlc_lcnphy_tempsense_degree(struct brcms_phy *pi, bool mode)
-{
-	s32 degree = wlc_lcnphy_tempsense_new(pi, mode);
-	degree =
-		((degree <<
-		  10) + LCN_TEMPSENSE_OFFSET + (LCN_TEMPSENSE_DEN >> 1))
-		/ LCN_TEMPSENSE_DEN;
-	return (s8) degree;
-}
+	mod_phy_reg(pi, 0x4d8, (0x3ff << 2), (auxpga_vmid) << 2);
 
-s8 wlc_lcnphy_vbatsense(struct brcms_phy *pi, bool mode)
-{
-	u16 vbatsenseval;
-	s32 avg = 0;
-	bool suspend = 0;
+	mod_phy_reg(pi, 0x4d8, (0x1 << 1), (1) << 1);
 
-	if (mode == 1) {
-		suspend =
-			(0 ==
-			 (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
-		if (!suspend)
-			wlapi_suspend_mac_and_wait(pi->sh->physhim);
-		wlc_lcnphy_vbat_temp_sense_setup(pi, VBATSENSE);
-	}
+	mod_phy_reg(pi, 0x4d8, (0x7 << 12), (auxpga_gain) << 12);
 
-	vbatsenseval = read_phy_reg(pi, 0x475) & 0x1FF;
+	mod_phy_reg(pi, 0x4d0, (0x1 << 5), (1) << 5);
 
-	if (vbatsenseval > 255)
-		avg = (s32) (vbatsenseval - 512);
-	else
-		avg = (s32) vbatsenseval;
+	write_radio_reg(pi, RADIO_2064_REG112, 0x6);
 
-	avg =	(avg * LCN_VBAT_SCALE_NOM +
-		 (LCN_VBAT_SCALE_DEN >> 1)) / LCN_VBAT_SCALE_DEN;
+	wlc_phy_do_dummy_tx(pi, true, OFF);
+	if (!tempsense_done(pi))
+		udelay(10);
 
-	if (mode == 1) {
-		if (!suspend)
-			wlapi_enable_mac(pi->sh->physhim);
-	}
-	return (s8) avg;
+	write_radio_reg(pi, RADIO_2064_REG007, (u16) save_reg007);
+	write_radio_reg(pi, RADIO_2064_REG0FF, (u16) save_reg0FF);
+	write_radio_reg(pi, RADIO_2064_REG11F, (u16) save_reg11F);
+	write_radio_reg(pi, RADIO_2064_REG005, (u16) save_reg005);
+	write_radio_reg(pi, RADIO_2064_REG025, (u16) save_reg025);
+	write_radio_reg(pi, RADIO_2064_REG112, (u16) save_reg112);
+	for (i = 0; i < 14; i++)
+		write_phy_reg(pi, tempsense_phy_regs[i], values_to_save[i]);
+	wlc_lcnphy_set_tx_pwr_by_index(pi, (int)index);
+
+	write_radio_reg(pi, 0x4a4, save_txpwrCtrlEn);
+	if (!suspend)
+		wlapi_enable_mac(pi->sh->physhim);
+	udelay(999);
 }
 
-static void wlc_lcnphy_afe_clk_init(struct brcms_phy *pi, u8 mode)
+static void wlc_lcnphy_tx_pwr_ctrl_init(struct brcms_phy_pub *ppi)
 {
-	u8 phybw40;
-	phybw40 = CHSPEC_IS40(pi->radio_chanspec);
+	struct lcnphy_txgains tx_gains;
+	u8 bbmult;
+	struct phytbl_info tab;
+	s32 a1, b0, b1;
+	s32 tssi, pwr, maxtargetpwr, mintargetpwr;
+	bool suspend;
+	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
-	mod_phy_reg(pi, 0x6d1, (0x1 << 7), (1) << 7);
+	suspend =
+		(0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
+	if (!suspend)
+		wlapi_suspend_mac_and_wait(pi->sh->physhim);
 
-	if (((mode == AFE_CLK_INIT_MODE_PAPD) && (phybw40 == 0)) ||
-	    (mode == AFE_CLK_INIT_MODE_TXRX2X))
-		write_phy_reg(pi, 0x6d0, 0x7);
+	if (!pi->hwpwrctrl_capable) {
+		if (CHSPEC_IS2G(pi->radio_chanspec)) {
+			tx_gains.gm_gain = 4;
+			tx_gains.pga_gain = 12;
+			tx_gains.pad_gain = 12;
+			tx_gains.dac_gain = 0;
 
-	wlc_lcnphy_toggle_afe_pwdn(pi);
-}
+			bbmult = 150;
+		} else {
+			tx_gains.gm_gain = 7;
+			tx_gains.pga_gain = 15;
+			tx_gains.pad_gain = 14;
+			tx_gains.dac_gain = 0;
 
-static bool
-wlc_lcnphy_rx_iq_est(struct brcms_phy *pi,
-		     u16 num_samps,
-		     u8 wait_time, struct lcnphy_iq_est *iq_est)
-{
-	int wait_count = 0;
-	bool result = true;
-	u8 phybw40;
-	phybw40 = CHSPEC_IS40(pi->radio_chanspec);
+			bbmult = 150;
+		}
+		wlc_lcnphy_set_tx_gain(pi, &tx_gains);
+		wlc_lcnphy_set_bbmult(pi, bbmult);
+		wlc_lcnphy_vbat_temp_sense_setup(pi, TEMPSENSE);
+	} else {
 
-	mod_phy_reg(pi, 0x6da, (0x1 << 5), (1) << 5);
+		wlc_lcnphy_idle_tssi_est(ppi);
 
-	mod_phy_reg(pi, 0x410, (0x1 << 3), (0) << 3);
+		wlc_lcnphy_clear_tx_power_offsets(pi);
 
-	mod_phy_reg(pi, 0x482, (0xffff << 0), (num_samps) << 0);
+		b0 = pi->txpa_2g[0];
+		b1 = pi->txpa_2g[1];
+		a1 = pi->txpa_2g[2];
+		maxtargetpwr = wlc_lcnphy_tssi2dbm(10, a1, b0, b1);
+		mintargetpwr = wlc_lcnphy_tssi2dbm(125, a1, b0, b1);
 
-	mod_phy_reg(pi, 0x481, (0xff << 0), ((u16) wait_time) << 0);
+		tab.tbl_id = LCNPHY_TBL_ID_TXPWRCTL;
+		tab.tbl_width = 32;
+		tab.tbl_ptr = &pwr;
+		tab.tbl_len = 1;
+		tab.tbl_offset = 0;
+		for (tssi = 0; tssi < 128; tssi++) {
+			pwr = wlc_lcnphy_tssi2dbm(tssi, a1, b0, b1);
 
-	mod_phy_reg(pi, 0x481, (0x1 << 8), (0) << 8);
+			pwr = (pwr < mintargetpwr) ? mintargetpwr : pwr;
+			wlc_lcnphy_write_table(pi, &tab);
+			tab.tbl_offset++;
+		}
 
-	mod_phy_reg(pi, 0x481, (0x1 << 9), (1) << 9);
+		mod_phy_reg(pi, 0x410, (0x1 << 7), (0) << 7);
 
-	while (read_phy_reg(pi, 0x481) & (0x1 << 9)) {
+		write_phy_reg(pi, 0x4a8, 10);
 
-		if (wait_count > (10 * 500)) {
-			result = false;
-			goto cleanup;
-		}
-		udelay(100);
-		wait_count++;
+		wlc_lcnphy_set_target_tx_pwr(pi, LCN_TARGET_PWR);
+
+		wlc_lcnphy_set_tx_pwr_ctrl(pi, LCNPHY_TX_PWR_CTRL_HW);
 	}
+	if (!suspend)
+		wlapi_enable_mac(pi->sh->physhim);
+}
 
-	iq_est->iq_prod = ((u32) read_phy_reg(pi, 0x483) << 16) |
-			  (u32) read_phy_reg(pi, 0x484);
-	iq_est->i_pwr = ((u32) read_phy_reg(pi, 0x485) << 16) |
-			(u32) read_phy_reg(pi, 0x486);
-	iq_est->q_pwr = ((u32) read_phy_reg(pi, 0x487) << 16) |
-			(u32) read_phy_reg(pi, 0x488);
+static u8 wlc_lcnphy_get_bbmult(struct brcms_phy *pi)
+{
+	u16 m0m1;
+	struct phytbl_info tab;
 
-cleanup:
-	mod_phy_reg(pi, 0x410, (0x1 << 3), (1) << 3);
+	tab.tbl_ptr = &m0m1;
+	tab.tbl_len = 1;
+	tab.tbl_id = LCNPHY_TBL_ID_IQLOCAL;
+	tab.tbl_offset = 87;
+	tab.tbl_width = 16;
+	wlc_lcnphy_read_table(pi, &tab);
 
-	mod_phy_reg(pi, 0x6da, (0x1 << 5), (0) << 5);
+	return (u8) ((m0m1 & 0xff00) >> 8);
+}
 
-	return result;
+static void wlc_lcnphy_set_pa_gain(struct brcms_phy *pi, u16 gain)
+{
+	mod_phy_reg(pi, 0x4fb,
+		    LCNPHY_txgainctrlovrval1_pagain_ovr_val1_MASK,
+		    gain << LCNPHY_txgainctrlovrval1_pagain_ovr_val1_SHIFT);
+	mod_phy_reg(pi, 0x4fd,
+		    LCNPHY_stxtxgainctrlovrval1_pagain_ovr_val1_MASK,
+		    gain << LCNPHY_stxtxgainctrlovrval1_pagain_ovr_val1_SHIFT);
 }
 
-static bool wlc_lcnphy_calc_rx_iq_comp(struct brcms_phy *pi, u16 num_samps)
+void
+wlc_lcnphy_get_radio_loft(struct brcms_phy *pi,
+			  u8 *ei0, u8 *eq0, u8 *fi0, u8 *fq0)
 {
-#define LCNPHY_MIN_RXIQ_PWR 2
-	bool result;
-	u16 a0_new, b0_new;
-	struct lcnphy_iq_est iq_est = { 0, 0, 0 };
-	s32 a, b, temp;
-	s16 iq_nbits, qq_nbits, arsh, brsh;
-	s32 iq;
-	u32 ii, qq;
+	*ei0 = LCNPHY_IQLOCC_READ(read_radio_reg(pi, RADIO_2064_REG089));
+	*eq0 = LCNPHY_IQLOCC_READ(read_radio_reg(pi, RADIO_2064_REG08A));
+	*fi0 = LCNPHY_IQLOCC_READ(read_radio_reg(pi, RADIO_2064_REG08B));
+	*fq0 = LCNPHY_IQLOCC_READ(read_radio_reg(pi, RADIO_2064_REG08C));
+}
+
+void wlc_lcnphy_set_tx_iqcc(struct brcms_phy *pi, u16 a, u16 b)
+{
+	struct phytbl_info tab;
+	u16 iqcc[2];
+
+	iqcc[0] = a;
+	iqcc[1] = b;
+
+	tab.tbl_id = LCNPHY_TBL_ID_IQLOCAL;
+	tab.tbl_width = 16;
+	tab.tbl_ptr = iqcc;
+	tab.tbl_len = 2;
+	tab.tbl_offset = 80;
+	wlc_lcnphy_write_table(pi, &tab);
+}
+
+void wlc_lcnphy_set_tx_locc(struct brcms_phy *pi, u16 didq)
+{
+	struct phytbl_info tab;
+
+	tab.tbl_id = LCNPHY_TBL_ID_IQLOCAL;
+	tab.tbl_width = 16;
+	tab.tbl_ptr = &didq;
+	tab.tbl_len = 1;
+	tab.tbl_offset = 85;
+	wlc_lcnphy_write_table(pi, &tab);
+}
+
+void wlc_lcnphy_set_tx_pwr_by_index(struct brcms_phy *pi, int index)
+{
+	struct phytbl_info tab;
+	u16 a, b;
+	u8 bb_mult;
+	u32 bbmultiqcomp, txgain, locoeffs, rfpower;
+	struct lcnphy_txgains gains;
 	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
-	a0_new = ((read_phy_reg(pi, 0x645) & (0x3ff << 0)) >> 0);
-	b0_new = ((read_phy_reg(pi, 0x646) & (0x3ff << 0)) >> 0);
-	mod_phy_reg(pi, 0x6d1, (0x1 << 2), (0) << 2);
+	pi_lcn->lcnphy_tx_power_idx_override = (s8) index;
+	pi_lcn->lcnphy_current_index = (u8) index;
 
-	mod_phy_reg(pi, 0x64b, (0x1 << 6), (1) << 6);
+	tab.tbl_id = LCNPHY_TBL_ID_TXPWRCTL;
+	tab.tbl_width = 32;
+	tab.tbl_len = 1;
 
-	wlc_lcnphy_set_rx_iq_comp(pi, 0, 0);
+	wlc_lcnphy_set_tx_pwr_ctrl(pi, LCNPHY_TX_PWR_CTRL_OFF);
 
-	result = wlc_lcnphy_rx_iq_est(pi, num_samps, 32, &iq_est);
-	if (!result)
-		goto cleanup;
+	tab.tbl_offset = LCNPHY_TX_PWR_CTRL_IQ_OFFSET + index;
+	tab.tbl_ptr = &bbmultiqcomp;
+	wlc_lcnphy_read_table(pi, &tab);
 
-	iq = (s32) iq_est.iq_prod;
-	ii = iq_est.i_pwr;
-	qq = iq_est.q_pwr;
+	tab.tbl_offset = LCNPHY_TX_PWR_CTRL_GAIN_OFFSET + index;
+	tab.tbl_width = 32;
+	tab.tbl_ptr = &txgain;
+	wlc_lcnphy_read_table(pi, &tab);
 
-	if ((ii + qq) < LCNPHY_MIN_RXIQ_PWR) {
-		result = false;
-		goto cleanup;
-	}
+	gains.gm_gain = (u16) (txgain & 0xff);
+	gains.pga_gain = (u16) (txgain >> 8) & 0xff;
+	gains.pad_gain = (u16) (txgain >> 16) & 0xff;
+	gains.dac_gain = (u16) (bbmultiqcomp >> 28) & 0x07;
+	wlc_lcnphy_set_tx_gain(pi, &gains);
+	wlc_lcnphy_set_pa_gain(pi, (u16) (txgain >> 24) & 0x7f);
 
-	iq_nbits = wlc_phy_nbits(iq);
-	qq_nbits = wlc_phy_nbits(qq);
+	bb_mult = (u8) ((bbmultiqcomp >> 20) & 0xff);
+	wlc_lcnphy_set_bbmult(pi, bb_mult);
 
-	arsh = 10 - (30 - iq_nbits);
-	if (arsh >= 0) {
-		a = (-(iq << (30 - iq_nbits)) + (ii >> (1 + arsh)));
-		temp = (s32) (ii >> arsh);
-		if (temp == 0)
-			return false;
-	} else {
-		a = (-(iq << (30 - iq_nbits)) + (ii << (-1 - arsh)));
-		temp = (s32) (ii << -arsh);
-		if (temp == 0)
-			return false;
-	}
-	a /= temp;
-	brsh = qq_nbits - 31 + 20;
-	if (brsh >= 0) {
-		b = (qq << (31 - qq_nbits));
-		temp = (s32) (ii >> brsh);
-		if (temp == 0)
-			return false;
-	} else {
-		b = (qq << (31 - qq_nbits));
-		temp = (s32) (ii << -brsh);
-		if (temp == 0)
-			return false;
-	}
-	b /= temp;
-	b -= a * a;
-	b = (s32) int_sqrt((unsigned long) b);
-	b -= (1 << 10);
-	a0_new = (u16) (a & 0x3ff);
-	b0_new = (u16) (b & 0x3ff);
-cleanup:
+	wlc_lcnphy_enable_tx_gain_override(pi);
 
-	wlc_lcnphy_set_rx_iq_comp(pi, a0_new, b0_new);
+	if (!wlc_lcnphy_tempsense_based_pwr_ctrl_enabled(pi)) {
 
-	mod_phy_reg(pi, 0x64b, (0x1 << 0), (1) << 0);
+		a = (u16) ((bbmultiqcomp >> 10) & 0x3ff);
+		b = (u16) (bbmultiqcomp & 0x3ff);
+		wlc_lcnphy_set_tx_iqcc(pi, a, b);
 
-	mod_phy_reg(pi, 0x64b, (0x1 << 3), (1) << 3);
+		tab.tbl_offset = LCNPHY_TX_PWR_CTRL_LO_OFFSET + index;
+		tab.tbl_ptr = &locoeffs;
+		wlc_lcnphy_read_table(pi, &tab);
 
-	pi_lcn->lcnphy_cal_results.rxiqcal_coeff_a0 = a0_new;
-	pi_lcn->lcnphy_cal_results.rxiqcal_coeff_b0 = b0_new;
+		wlc_lcnphy_set_tx_locc(pi, (u16) locoeffs);
 
-	return result;
+		tab.tbl_offset = LCNPHY_TX_PWR_CTRL_PWR_OFFSET + index;
+		tab.tbl_ptr = &rfpower;
+		wlc_lcnphy_read_table(pi, &tab);
+		mod_phy_reg(pi, 0x6a6, (0x1fff << 0), (rfpower * 8) << 0);
+
+	}
 }
 
-static bool
-wlc_lcnphy_rx_iq_cal(struct brcms_phy *pi,
-		     const struct lcnphy_rx_iqcomp *iqcomp,
-		     int iqcomp_sz, bool tx_switch, bool rx_switch, int module,
-		     int tx_gain_idx)
+static void wlc_lcnphy_clear_papd_comptable(struct brcms_phy *pi)
 {
-	struct lcnphy_txgains old_gains;
-	u16 tx_pwr_ctrl;
-	u8 tx_gain_index_old = 0;
-	bool result = false, tx_gain_override_old = false;
-	u16 i, Core1TxControl_old, RFOverride0_old,
-	    RFOverrideVal0_old, rfoverride2_old, rfoverride2val_old,
-	    rfoverride3_old, rfoverride3val_old, rfoverride4_old,
-	    rfoverride4val_old, afectrlovr_old, afectrlovrval_old;
-	int tia_gain;
-	u32 received_power, rx_pwr_threshold;
-	u16 old_sslpnCalibClkEnCtrl, old_sslpnRxFeClkEnCtrl;
-	u16 values_to_save[11];
-	s16 *ptr;
-	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	u32 j;
+	struct phytbl_info tab;
+	u32 temp_offset[128];
+	tab.tbl_ptr = temp_offset;
+	tab.tbl_len = 128;
+	tab.tbl_id = LCNPHY_TBL_ID_PAPDCOMPDELTATBL;
+	tab.tbl_width = 32;
+	tab.tbl_offset = 0;
 
-	ptr = kmalloc(sizeof(s16) * 131, GFP_ATOMIC);
-	if (NULL == ptr)
-		return false;
-	if (module == 2) {
-		while (iqcomp_sz--) {
-			if (iqcomp[iqcomp_sz].chan ==
-			    CHSPEC_CHANNEL(pi->radio_chanspec)) {
-				wlc_lcnphy_set_rx_iq_comp(pi,
-							  (u16)
-							  iqcomp[iqcomp_sz].a,
-							  (u16)
-							  iqcomp[iqcomp_sz].b);
-				result = true;
-				break;
-			}
-		}
-		goto cal_done;
-	}
+	memset(temp_offset, 0, sizeof(temp_offset));
+	for (j = 1; j < 128; j += 2)
+		temp_offset[j] = 0x80000;
 
-	if (module == 1) {
+	wlc_lcnphy_write_table(pi, &tab);
+	return;
+}
 
-		tx_pwr_ctrl = wlc_lcnphy_get_tx_pwr_ctrl(pi);
-		wlc_lcnphy_set_tx_pwr_ctrl(pi, LCNPHY_TX_PWR_CTRL_OFF);
+void wlc_lcnphy_tx_pu(struct brcms_phy *pi, bool bEnable)
+{
+	if (!bEnable) {
 
-		for (i = 0; i < 11; i++)
-			values_to_save[i] =
-				read_radio_reg(pi, rxiq_cal_rf_reg[i]);
-		Core1TxControl_old = read_phy_reg(pi, 0x631);
+		and_phy_reg(pi, 0x43b, ~(u16) ((0x1 << 1) | (0x1 << 4)));
 
-		or_phy_reg(pi, 0x631, 0x0015);
+		mod_phy_reg(pi, 0x43c, (0x1 << 1), 1 << 1);
 
-		RFOverride0_old = read_phy_reg(pi, 0x44c);
-		RFOverrideVal0_old = read_phy_reg(pi, 0x44d);
-		rfoverride2_old = read_phy_reg(pi, 0x4b0);
-		rfoverride2val_old = read_phy_reg(pi, 0x4b1);
-		rfoverride3_old = read_phy_reg(pi, 0x4f9);
-		rfoverride3val_old = read_phy_reg(pi, 0x4fa);
-		rfoverride4_old = read_phy_reg(pi, 0x938);
-		rfoverride4val_old = read_phy_reg(pi, 0x939);
-		afectrlovr_old = read_phy_reg(pi, 0x43b);
-		afectrlovrval_old = read_phy_reg(pi, 0x43c);
-		old_sslpnCalibClkEnCtrl = read_phy_reg(pi, 0x6da);
-		old_sslpnRxFeClkEnCtrl = read_phy_reg(pi, 0x6db);
+		and_phy_reg(pi, 0x44c,
+			    ~(u16) ((0x1 << 3) |
+				    (0x1 << 5) |
+				    (0x1 << 12) |
+				    (0x1 << 0) | (0x1 << 1) | (0x1 << 2)));
 
-		tx_gain_override_old = wlc_lcnphy_tx_gain_override_enabled(pi);
-		if (tx_gain_override_old) {
-			wlc_lcnphy_get_tx_gain(pi, &old_gains);
-			tx_gain_index_old = pi_lcn->lcnphy_current_index;
-		}
+		and_phy_reg(pi, 0x44d,
+			    ~(u16) ((0x1 << 3) | (0x1 << 5) | (0x1 << 14)));
+		mod_phy_reg(pi, 0x44d, (0x1 << 2), 1 << 2);
 
-		wlc_lcnphy_set_tx_pwr_by_index(pi, tx_gain_idx);
+		mod_phy_reg(pi, 0x44d, (0x1 << 1) | (0x1 << 0), (0x1 << 0));
 
-		mod_phy_reg(pi, 0x4f9, (0x1 << 0), 1 << 0);
-		mod_phy_reg(pi, 0x4fa, (0x1 << 0), 0 << 0);
+		and_phy_reg(pi, 0x4f9,
+			    ~(u16) ((0x1 << 0) | (0x1 << 1) | (0x1 << 2)));
+
+		and_phy_reg(pi, 0x4fa,
+			    ~(u16) ((0x1 << 0) | (0x1 << 1) | (0x1 << 2)));
+	} else {
 
 		mod_phy_reg(pi, 0x43b, (0x1 << 1), 1 << 1);
 		mod_phy_reg(pi, 0x43c, (0x1 << 1), 0 << 1);
 
-		write_radio_reg(pi, RADIO_2064_REG116, 0x06);
-		write_radio_reg(pi, RADIO_2064_REG12C, 0x07);
-		write_radio_reg(pi, RADIO_2064_REG06A, 0xd3);
-		write_radio_reg(pi, RADIO_2064_REG098, 0x03);
-		write_radio_reg(pi, RADIO_2064_REG00B, 0x7);
-		mod_radio_reg(pi, RADIO_2064_REG113, 1 << 4, 1 << 4);
-		write_radio_reg(pi, RADIO_2064_REG01D, 0x01);
-		write_radio_reg(pi, RADIO_2064_REG114, 0x01);
-		write_radio_reg(pi, RADIO_2064_REG02E, 0x10);
-		write_radio_reg(pi, RADIO_2064_REG12A, 0x08);
+		mod_phy_reg(pi, 0x43b, (0x1 << 4), 1 << 4);
+		mod_phy_reg(pi, 0x43c, (0x1 << 6), 0 << 6);
 
-		mod_phy_reg(pi, 0x938, (0x1 << 0), 1 << 0);
-		mod_phy_reg(pi, 0x939, (0x1 << 0), 0 << 0);
-		mod_phy_reg(pi, 0x938, (0x1 << 1), 1 << 1);
-		mod_phy_reg(pi, 0x939, (0x1 << 1), 1 << 1);
-		mod_phy_reg(pi, 0x938, (0x1 << 2), 1 << 2);
-		mod_phy_reg(pi, 0x939, (0x1 << 2), 1 << 2);
-		mod_phy_reg(pi, 0x938, (0x1 << 3), 1 << 3);
-		mod_phy_reg(pi, 0x939, (0x1 << 3), 1 << 3);
-		mod_phy_reg(pi, 0x938, (0x1 << 5), 1 << 5);
-		mod_phy_reg(pi, 0x939, (0x1 << 5), 0 << 5);
+		mod_phy_reg(pi, 0x44c, (0x1 << 12), 1 << 12);
+		mod_phy_reg(pi, 0x44d, (0x1 << 14), 1 << 14);
 
-		mod_phy_reg(pi, 0x43b, (0x1 << 0), 1 << 0);
-		mod_phy_reg(pi, 0x43c, (0x1 << 0), 0 << 0);
+		wlc_lcnphy_set_trsw_override(pi, true, false);
 
-		wlc_lcnphy_start_tx_tone(pi, 2000, 120, 0);
-		write_phy_reg(pi, 0x6da, 0xffff);
-		or_phy_reg(pi, 0x6db, 0x3);
-		wlc_lcnphy_set_trsw_override(pi, tx_switch, rx_switch);
-		wlc_lcnphy_rx_gain_override_enable(pi, true);
+		mod_phy_reg(pi, 0x44d, (0x1 << 2), 0 << 2);
+		mod_phy_reg(pi, 0x44c, (0x1 << 2), 1 << 2);
 
-		tia_gain = 8;
-		rx_pwr_threshold = 950;
-		while (tia_gain > 0) {
-			tia_gain -= 1;
-			wlc_lcnphy_set_rx_gain_by_distribution(pi,
-							       0, 0, 2, 2,
-							       (u16)
-							       tia_gain, 1, 0);
-			udelay(500);
+		if (CHSPEC_IS2G(pi->radio_chanspec)) {
 
-			received_power =
-				wlc_lcnphy_measure_digital_power(pi, 2000);
-			if (received_power < rx_pwr_threshold)
-				break;
-		}
-		result = wlc_lcnphy_calc_rx_iq_comp(pi, 0xffff);
+			mod_phy_reg(pi, 0x44c, (0x1 << 3), 1 << 3);
+			mod_phy_reg(pi, 0x44d, (0x1 << 3), 1 << 3);
 
-		wlc_lcnphy_stop_tx_tone(pi);
+			mod_phy_reg(pi, 0x44c, (0x1 << 5), 1 << 5);
+			mod_phy_reg(pi, 0x44d, (0x1 << 5), 0 << 5);
 
-		write_phy_reg(pi, 0x631, Core1TxControl_old);
+			mod_phy_reg(pi, 0x4f9, (0x1 << 1), 1 << 1);
+			mod_phy_reg(pi, 0x4fa, (0x1 << 1), 1 << 1);
 
-		write_phy_reg(pi, 0x44c, RFOverrideVal0_old);
-		write_phy_reg(pi, 0x44d, RFOverrideVal0_old);
-		write_phy_reg(pi, 0x4b0, rfoverride2_old);
-		write_phy_reg(pi, 0x4b1, rfoverride2val_old);
-		write_phy_reg(pi, 0x4f9, rfoverride3_old);
-		write_phy_reg(pi, 0x4fa, rfoverride3val_old);
-		write_phy_reg(pi, 0x938, rfoverride4_old);
-		write_phy_reg(pi, 0x939, rfoverride4val_old);
-		write_phy_reg(pi, 0x43b, afectrlovr_old);
-		write_phy_reg(pi, 0x43c, afectrlovrval_old);
-		write_phy_reg(pi, 0x6da, old_sslpnCalibClkEnCtrl);
-		write_phy_reg(pi, 0x6db, old_sslpnRxFeClkEnCtrl);
+			mod_phy_reg(pi, 0x4f9, (0x1 << 2), 1 << 2);
+			mod_phy_reg(pi, 0x4fa, (0x1 << 2), 1 << 2);
 
-		wlc_lcnphy_clear_trsw_override(pi);
+			mod_phy_reg(pi, 0x4f9, (0x1 << 0), 1 << 0);
+			mod_phy_reg(pi, 0x4fa, (0x1 << 0), 1 << 0);
+		} else {
 
-		mod_phy_reg(pi, 0x44c, (0x1 << 2), 0 << 2);
+			mod_phy_reg(pi, 0x44c, (0x1 << 3), 1 << 3);
+			mod_phy_reg(pi, 0x44d, (0x1 << 3), 0 << 3);
 
-		for (i = 0; i < 11; i++)
-			write_radio_reg(pi, rxiq_cal_rf_reg[i],
-					values_to_save[i]);
+			mod_phy_reg(pi, 0x44c, (0x1 << 5), 1 << 5);
+			mod_phy_reg(pi, 0x44d, (0x1 << 5), 1 << 5);
 
-		if (tx_gain_override_old)
-			wlc_lcnphy_set_tx_pwr_by_index(pi, tx_gain_index_old);
-		else
-			wlc_lcnphy_disable_tx_gain_override(pi);
+			mod_phy_reg(pi, 0x4f9, (0x1 << 1), 1 << 1);
+			mod_phy_reg(pi, 0x4fa, (0x1 << 1), 0 << 1);
 
-		wlc_lcnphy_set_tx_pwr_ctrl(pi, tx_pwr_ctrl);
-		wlc_lcnphy_rx_gain_override_enable(pi, false);
-	}
+			mod_phy_reg(pi, 0x4f9, (0x1 << 2), 1 << 2);
+			mod_phy_reg(pi, 0x4fa, (0x1 << 2), 0 << 2);
 
-cal_done:
-	kfree(ptr);
-	return result;
+			mod_phy_reg(pi, 0x4f9, (0x1 << 0), 1 << 0);
+			mod_phy_reg(pi, 0x4fa, (0x1 << 0), 0 << 0);
+		}
+	}
 }
 
-static void wlc_lcnphy_temp_adj(struct brcms_phy *pi)
+static void
+wlc_lcnphy_run_samples(struct brcms_phy *pi,
+		       u16 num_samps,
+		       u16 num_loops, u16 wait, bool iqcalmode)
 {
+
+	or_phy_reg(pi, 0x6da, 0x8080);
+
+	mod_phy_reg(pi, 0x642, (0x7f << 0), (num_samps - 1) << 0);
+	if (num_loops != 0xffff)
+		num_loops--;
+	mod_phy_reg(pi, 0x640, (0xffff << 0), num_loops << 0);
+
+	mod_phy_reg(pi, 0x641, (0xffff << 0), wait << 0);
+
+	if (iqcalmode) {
+
+		and_phy_reg(pi, 0x453, (u16) ~(0x1 << 15));
+		or_phy_reg(pi, 0x453, (0x1 << 15));
+	} else {
+		write_phy_reg(pi, 0x63f, 1);
+		wlc_lcnphy_tx_pu(pi, 1);
+	}
+
+	or_radio_reg(pi, RADIO_2064_REG112, 0x6);
 }
 
-static void wlc_lcnphy_glacial_timer_based_cal(struct brcms_phy *pi)
+void wlc_lcnphy_deaf_mode(struct brcms_phy *pi, bool mode)
 {
-	bool suspend;
-	s8 index;
-	u16 SAVE_pwrctrl = wlc_lcnphy_get_tx_pwr_ctrl(pi);
-	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
-	suspend =
-		(0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
-	if (!suspend)
-		wlapi_suspend_mac_and_wait(pi->sh->physhim);
-	wlc_lcnphy_deaf_mode(pi, true);
-	pi->phy_lastcal = pi->sh->now;
-	pi->phy_forcecal = false;
-	index = pi_lcn->lcnphy_current_index;
 
-	wlc_lcnphy_txpwrtbl_iqlo_cal(pi);
+	u8 phybw40;
+	phybw40 = CHSPEC_IS40(pi->radio_chanspec);
 
-	wlc_lcnphy_set_tx_pwr_by_index(pi, index);
-	wlc_lcnphy_set_tx_pwr_ctrl(pi, SAVE_pwrctrl);
-	wlc_lcnphy_deaf_mode(pi, false);
-	if (!suspend)
-		wlapi_enable_mac(pi->sh->physhim);
+	if (LCNREV_LT(pi->pubpi.phy_rev, 2)) {
+		mod_phy_reg(pi, 0x4b0, (0x1 << 5), (mode) << 5);
+		mod_phy_reg(pi, 0x4b1, (0x1 << 9), 0 << 9);
+	} else {
+		mod_phy_reg(pi, 0x4b0, (0x1 << 5), (mode) << 5);
+		mod_phy_reg(pi, 0x4b1, (0x1 << 9), 0 << 9);
+	}
 
+	if (phybw40 == 0) {
+		mod_phy_reg((pi), 0x410,
+			    (0x1 << 6) |
+			    (0x1 << 5),
+			    ((CHSPEC_IS2G(
+				      pi->radio_chanspec)) ? (!mode) : 0) <<
+			    6 | (!mode) << 5);
+		mod_phy_reg(pi, 0x410, (0x1 << 7), (mode) << 7);
+	}
 }
 
-static void wlc_lcnphy_periodic_cal(struct brcms_phy *pi)
+void
+wlc_lcnphy_start_tx_tone(struct brcms_phy *pi, s32 f_kHz, u16 max_val,
+			 bool iqcalmode)
 {
-	bool suspend, full_cal;
-	const struct lcnphy_rx_iqcomp *rx_iqcomp;
-	int rx_iqcomp_sz;
-	u16 SAVE_pwrctrl = wlc_lcnphy_get_tx_pwr_ctrl(pi);
-	s8 index;
+	u8 phy_bw;
+	u16 num_samps, t, k;
+	u32 bw;
+	s32 theta = 0, rot = 0;
+	struct cordic_iq tone_samp;
+	u32 data_buf[64];
+	u16 i_samp, q_samp;
 	struct phytbl_info tab;
-	s32 a1, b0, b1;
-	s32 tssi, pwr, maxtargetpwr, mintargetpwr;
 	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
-	pi->phy_lastcal = pi->sh->now;
-	pi->phy_forcecal = false;
-	full_cal =
-		(pi_lcn->lcnphy_full_cal_channel !=
-		 CHSPEC_CHANNEL(pi->radio_chanspec));
-	pi_lcn->lcnphy_full_cal_channel = CHSPEC_CHANNEL(pi->radio_chanspec);
-	index = pi_lcn->lcnphy_current_index;
-
-	suspend =
-		(0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
-	if (!suspend) {
-		wlapi_bmac_write_shm(pi->sh->physhim, M_CTS_DURATION, 10000);
-		wlapi_suspend_mac_and_wait(pi->sh->physhim);
-	}
+	pi->phy_tx_tone_freq = f_kHz;
 
 	wlc_lcnphy_deaf_mode(pi, true);
 
-	wlc_lcnphy_txpwrtbl_iqlo_cal(pi);
+	phy_bw = 40;
+	if (pi_lcn->lcnphy_spurmod) {
+		write_phy_reg(pi, 0x942, 0x2);
+		write_phy_reg(pi, 0x93b, 0x0);
+		write_phy_reg(pi, 0x93c, 0x0);
+		wlc_lcnphy_txrx_spur_avoidance_mode(pi, false);
+	}
 
-	rx_iqcomp = lcnphy_rx_iqcomp_table_rev0;
-	rx_iqcomp_sz = ARRAY_SIZE(lcnphy_rx_iqcomp_table_rev0);
+	if (f_kHz) {
+		k = 1;
+		do {
+			bw = phy_bw * 1000 * k;
+			num_samps = bw / ABS(f_kHz);
+			k++;
+		} while ((num_samps * (u32) (ABS(f_kHz))) != bw);
+	} else
+		num_samps = 2;
 
-	if (LCNREV_IS(pi->pubpi.phy_rev, 1))
-		wlc_lcnphy_rx_iq_cal(pi, NULL, 0, true, false, 1, 40);
-	else
-		wlc_lcnphy_rx_iq_cal(pi, NULL, 0, true, false, 1, 127);
+	rot = ((f_kHz * 36) / phy_bw) / 100;
+	theta = 0;
 
-	if (wlc_lcnphy_tssi_based_pwr_ctrl_enabled(pi)) {
+	for (t = 0; t < num_samps; t++) {
 
-		wlc_lcnphy_idle_tssi_est((struct brcms_phy_pub *) pi);
+		tone_samp = cordic_calc_iq(theta);
 
-		b0 = pi->txpa_2g[0];
-		b1 = pi->txpa_2g[1];
-		a1 = pi->txpa_2g[2];
-		maxtargetpwr = wlc_lcnphy_tssi2dbm(10, a1, b0, b1);
-		mintargetpwr = wlc_lcnphy_tssi2dbm(125, a1, b0, b1);
+		theta += rot;
 
-		tab.tbl_id = LCNPHY_TBL_ID_TXPWRCTL;
-		tab.tbl_width = 32;
-		tab.tbl_ptr = &pwr;
-		tab.tbl_len = 1;
-		tab.tbl_offset = 0;
-		for (tssi = 0; tssi < 128; tssi++) {
-			pwr = wlc_lcnphy_tssi2dbm(tssi, a1, b0, b1);
-			pwr = (pwr < mintargetpwr) ? mintargetpwr : pwr;
-			wlc_lcnphy_write_table(pi, &tab);
-			tab.tbl_offset++;
-		}
+		i_samp = (u16) (FLOAT(tone_samp.i * max_val) & 0x3ff);
+		q_samp = (u16) (FLOAT(tone_samp.q * max_val) & 0x3ff);
+		data_buf[t] = (i_samp << 10) | q_samp;
 	}
 
-	wlc_lcnphy_set_tx_pwr_by_index(pi, index);
-	wlc_lcnphy_set_tx_pwr_ctrl(pi, SAVE_pwrctrl);
-	wlc_lcnphy_deaf_mode(pi, false);
-	if (!suspend)
-		wlapi_enable_mac(pi->sh->physhim);
+	mod_phy_reg(pi, 0x6d6, (0x3 << 0), 0 << 0);
+
+	mod_phy_reg(pi, 0x6da, (0x1 << 3), 1 << 3);
+
+	tab.tbl_ptr = data_buf;
+	tab.tbl_len = num_samps;
+	tab.tbl_id = LCNPHY_TBL_ID_SAMPLEPLAY;
+	tab.tbl_offset = 0;
+	tab.tbl_width = 32;
+	wlc_lcnphy_write_table(pi, &tab);
+
+	wlc_lcnphy_run_samples(pi, num_samps, 0xffff, 0, iqcalmode);
 }
 
-void wlc_lcnphy_calib_modes(struct brcms_phy *pi, uint mode)
+void wlc_lcnphy_stop_tx_tone(struct brcms_phy *pi)
 {
-	u16 temp_new;
-	int temp1, temp2, temp_diff;
+	s16 playback_status;
 	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
-	switch (mode) {
-	case PHY_PERICAL_CHAN:
-		break;
-	case PHY_FULLCAL:
-		wlc_lcnphy_periodic_cal(pi);
+	pi->phy_tx_tone_freq = 0;
+	if (pi_lcn->lcnphy_spurmod) {
+		write_phy_reg(pi, 0x942, 0x7);
+		write_phy_reg(pi, 0x93b, 0x2017);
+		write_phy_reg(pi, 0x93c, 0x27c5);
+		wlc_lcnphy_txrx_spur_avoidance_mode(pi, true);
+	}
+
+	playback_status = read_phy_reg(pi, 0x644);
+	if (playback_status & (0x1 << 0)) {
+		wlc_lcnphy_tx_pu(pi, 0);
+		mod_phy_reg(pi, 0x63f, (0x1 << 1), 1 << 1);
+	} else if (playback_status & (0x1 << 1))
+		mod_phy_reg(pi, 0x453, (0x1 << 15), 0 << 15);
+
+	mod_phy_reg(pi, 0x6d6, (0x3 << 0), 1 << 0);
+
+	mod_phy_reg(pi, 0x6da, (0x1 << 3), 0 << 3);
+
+	mod_phy_reg(pi, 0x6da, (0x1 << 7), 0 << 7);
+
+	and_radio_reg(pi, RADIO_2064_REG112, 0xFFF9);
+
+	wlc_lcnphy_deaf_mode(pi, false);
+}
+
+static void
+wlc_lcnphy_set_cc(struct brcms_phy *pi, int cal_type, s16 coeff_x, s16 coeff_y)
+{
+	u16 di0dq0;
+	u16 x, y, data_rf;
+	int k;
+	switch (cal_type) {
+	case 0:
+		wlc_lcnphy_set_tx_iqcc(pi, coeff_x, coeff_y);
 		break;
-	case PHY_PERICAL_PHYINIT:
-		wlc_lcnphy_periodic_cal(pi);
+	case 2:
+		di0dq0 = (coeff_x & 0xff) << 8 | (coeff_y & 0xff);
+		wlc_lcnphy_set_tx_locc(pi, di0dq0);
 		break;
-	case PHY_PERICAL_WATCHDOG:
-		if (wlc_lcnphy_tempsense_based_pwr_ctrl_enabled(pi)) {
-			temp_new = wlc_lcnphy_tempsense(pi, 0);
-			temp1 = LCNPHY_TEMPSENSE(temp_new);
-			temp2 = LCNPHY_TEMPSENSE(pi_lcn->lcnphy_cal_temper);
-			temp_diff = temp1 - temp2;
-			if ((pi_lcn->lcnphy_cal_counter > 90) ||
-			    (temp_diff > 60) || (temp_diff < -60)) {
-				wlc_lcnphy_glacial_timer_based_cal(pi);
-				wlc_2064_vco_cal(pi);
-				pi_lcn->lcnphy_cal_temper = temp_new;
-				pi_lcn->lcnphy_cal_counter = 0;
-			} else
-				pi_lcn->lcnphy_cal_counter++;
-		}
+	case 3:
+		k = wlc_lcnphy_calc_floor(coeff_x, 0);
+		y = 8 + k;
+		k = wlc_lcnphy_calc_floor(coeff_x, 1);
+		x = 8 - k;
+		data_rf = (x * 16 + y);
+		write_radio_reg(pi, RADIO_2064_REG089, data_rf);
+		k = wlc_lcnphy_calc_floor(coeff_y, 0);
+		y = 8 + k;
+		k = wlc_lcnphy_calc_floor(coeff_y, 1);
+		x = 8 - k;
+		data_rf = (x * 16 + y);
+		write_radio_reg(pi, RADIO_2064_REG08A, data_rf);
 		break;
-	case LCNPHY_PERICAL_TEMPBASED_TXPWRCTRL:
-		if (wlc_lcnphy_tempsense_based_pwr_ctrl_enabled(pi))
-			wlc_lcnphy_tx_power_adjustment(
-				(struct brcms_phy_pub *) pi);
+	case 4:
+		k = wlc_lcnphy_calc_floor(coeff_x, 0);
+		y = 8 + k;
+		k = wlc_lcnphy_calc_floor(coeff_x, 1);
+		x = 8 - k;
+		data_rf = (x * 16 + y);
+		write_radio_reg(pi, RADIO_2064_REG08B, data_rf);
+		k = wlc_lcnphy_calc_floor(coeff_y, 0);
+		y = 8 + k;
+		k = wlc_lcnphy_calc_floor(coeff_y, 1);
+		x = 8 - k;
+		data_rf = (x * 16 + y);
+		write_radio_reg(pi, RADIO_2064_REG08C, data_rf);
 		break;
 	}
 }
 
-void wlc_lcnphy_get_tssi(struct brcms_phy *pi, s8 *ofdm_pwr, s8 *cck_pwr)
+static struct lcnphy_unsign16_struct
+wlc_lcnphy_get_cc(struct brcms_phy *pi, int cal_type)
 {
-	s8 cck_offset;
-	u16 status;
-	status = (read_phy_reg(pi, 0x4ab));
-	if (wlc_lcnphy_tssi_based_pwr_ctrl_enabled(pi) &&
-	    (status  & (0x1 << 15))) {
-		*ofdm_pwr = (s8) (((read_phy_reg(pi, 0x4ab) & (0x1ff << 0))
-				   >> 0) >> 1);
-
-		if (wlc_phy_tpc_isenabled_lcnphy(pi))
-			cck_offset = pi->tx_power_offset[TXP_FIRST_CCK];
-		else
-			cck_offset = 0;
-
-		*cck_pwr = *ofdm_pwr + cck_offset;
-	} else {
-		*cck_pwr = 0;
-		*ofdm_pwr = 0;
+	u16 a, b, didq;
+	u8 di0, dq0, ei, eq, fi, fq;
+	struct lcnphy_unsign16_struct cc;
+	cc.re = 0;
+	cc.im = 0;
+	switch (cal_type) {
+	case 0:
+		wlc_lcnphy_get_tx_iqcc(pi, &a, &b);
+		cc.re = a;
+		cc.im = b;
+		break;
+	case 2:
+		didq = wlc_lcnphy_get_tx_locc(pi);
+		di0 = (((didq & 0xff00) << 16) >> 24);
+		dq0 = (((didq & 0x00ff) << 24) >> 24);
+		cc.re = (u16) di0;
+		cc.im = (u16) dq0;
+		break;
+	case 3:
+		wlc_lcnphy_get_radio_loft(pi, &ei, &eq, &fi, &fq);
+		cc.re = (u16) ei;
+		cc.im = (u16) eq;
+		break;
+	case 4:
+		wlc_lcnphy_get_radio_loft(pi, &ei, &eq, &fi, &fq);
+		cc.re = (u16) fi;
+		cc.im = (u16) fq;
+		break;
 	}
-}
-
-void wlc_phy_cal_init_lcnphy(struct brcms_phy *pi)
-{
-	return;
-
+	return cc;
 }
 
 static void
-wlc_lcnphy_set_chanspec_tweaks(struct brcms_phy *pi, u16 chanspec)
+wlc_lcnphy_samp_cap(struct brcms_phy *pi, int clip_detect_algo, u16 thresh,
+		    s16 *ptr, int mode)
 {
-	u8 channel = CHSPEC_CHANNEL(chanspec);
+	u32 curval1, curval2, stpptr, curptr, strptr, val;
+	u16 sslpnCalibClkEnCtrl, timer;
+	u16 old_sslpnCalibClkEnCtrl;
+	s16 imag, real;
 	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
-	if (channel == 14)
-		mod_phy_reg(pi, 0x448, (0x3 << 8), (2) << 8);
-	else
-		mod_phy_reg(pi, 0x448, (0x3 << 8), (1) << 8);
+	timer = 0;
+	old_sslpnCalibClkEnCtrl = read_phy_reg(pi, 0x6da);
 
-	pi_lcn->lcnphy_bandedge_corr = 2;
-	if (channel == 1)
-		pi_lcn->lcnphy_bandedge_corr = 4;
+	curval1 = R_REG(&pi->regs->psm_corectlsts);
+	ptr[130] = 0;
+	W_REG(&pi->regs->psm_corectlsts, ((1 << 6) | curval1));
 
-	if (channel == 1 || channel == 2 || channel == 3 ||
-	    channel == 4 || channel == 9 ||
-	    channel == 10 || channel == 11 || channel == 12) {
-		si_pmu_pllcontrol(pi->sh->sih, 0x2, 0xffffffff, 0x03000c04);
-		si_pmu_pllcontrol(pi->sh->sih, 0x3, 0xffffff, 0x0);
-		si_pmu_pllcontrol(pi->sh->sih, 0x4, 0xffffffff, 0x200005c0);
+	W_REG(&pi->regs->smpl_clct_strptr, 0x7E00);
+	W_REG(&pi->regs->smpl_clct_stpptr, 0x8000);
+	udelay(20);
+	curval2 = R_REG(&pi->regs->psm_phy_hdr_param);
+	W_REG(&pi->regs->psm_phy_hdr_param, curval2 | 0x30);
 
-		si_pmu_pllupd(pi->sh->sih);
-		write_phy_reg(pi, 0x942, 0);
-		wlc_lcnphy_txrx_spur_avoidance_mode(pi, false);
-		pi_lcn->lcnphy_spurmod = 0;
-		mod_phy_reg(pi, 0x424, (0xff << 8), (0x1b) << 8);
+	write_phy_reg(pi, 0x555, 0x0);
+	write_phy_reg(pi, 0x5a6, 0x5);
 
-		write_phy_reg(pi, 0x425, 0x5907);
-	} else {
-		si_pmu_pllcontrol(pi->sh->sih, 0x2, 0xffffffff, 0x03140c04);
-		si_pmu_pllcontrol(pi->sh->sih, 0x3, 0xffffff, 0x333333);
-		si_pmu_pllcontrol(pi->sh->sih, 0x4, 0xffffffff, 0x202c2820);
+	write_phy_reg(pi, 0x5a2, (u16) (mode | mode << 6));
+	write_phy_reg(pi, 0x5cf, 3);
+	write_phy_reg(pi, 0x5a5, 0x3);
+	write_phy_reg(pi, 0x583, 0x0);
+	write_phy_reg(pi, 0x584, 0x0);
+	write_phy_reg(pi, 0x585, 0x0fff);
+	write_phy_reg(pi, 0x586, 0x0000);
 
-		si_pmu_pllupd(pi->sh->sih);
-		write_phy_reg(pi, 0x942, 0);
-		wlc_lcnphy_txrx_spur_avoidance_mode(pi, true);
+	write_phy_reg(pi, 0x580, 0x4501);
 
-		pi_lcn->lcnphy_spurmod = 0;
-		mod_phy_reg(pi, 0x424, (0xff << 8), (0x1f) << 8);
+	sslpnCalibClkEnCtrl = read_phy_reg(pi, 0x6da);
+	write_phy_reg(pi, 0x6da, (u32) (sslpnCalibClkEnCtrl | 0x2008));
+	stpptr = R_REG(&pi->regs->smpl_clct_stpptr);
+	curptr = R_REG(&pi->regs->smpl_clct_curptr);
+	do {
+		udelay(10);
+		curptr = R_REG(&pi->regs->smpl_clct_curptr);
+		timer++;
+	} while ((curptr != stpptr) && (timer < 500));
 
-		write_phy_reg(pi, 0x425, 0x590a);
-	}
+	W_REG(&pi->regs->psm_phy_hdr_param, 0x2);
+	strptr = 0x7E00;
+	W_REG(&pi->regs->tplatewrptr, strptr);
+	while (strptr < 0x8000) {
+		val = R_REG(&pi->regs->tplatewrdata);
+		imag = ((val >> 16) & 0x3ff);
+		real = ((val) & 0x3ff);
+		if (imag > 511)
+			imag -= 1024;
 
-	or_phy_reg(pi, 0x44a, 0x44);
-	write_phy_reg(pi, 0x44a, 0x80);
-}
+		if (real > 511)
+			real -= 1024;
 
-void wlc_lcnphy_tx_power_adjustment(struct brcms_phy_pub *ppi)
-{
-	s8 index;
-	u16 index2;
-	struct brcms_phy *pi = (struct brcms_phy *) ppi;
-	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
-	u16 SAVE_txpwrctrl = wlc_lcnphy_get_tx_pwr_ctrl(pi);
-	if (wlc_lcnphy_tempsense_based_pwr_ctrl_enabled(pi) &&
-	    SAVE_txpwrctrl) {
-		index = wlc_lcnphy_tempcompensated_txpwrctrl(pi);
-		index2 = (u16) (index * 2);
-		mod_phy_reg(pi, 0x4a9, (0x1ff << 0), (index2) << 0);
+		if (pi_lcn->lcnphy_iqcal_swp_dis)
+			ptr[(strptr - 0x7E00) / 4] = real;
+		else
+			ptr[(strptr - 0x7E00) / 4] = imag;
 
-		pi_lcn->lcnphy_current_index =
-			(s8)((read_phy_reg(pi, 0x4a9) & 0xFF) / 2);
+		if (clip_detect_algo) {
+			if (imag > thresh || imag < -thresh) {
+				strptr = 0x8000;
+				ptr[130] = 1;
+			}
+		}
+
+		strptr += 4;
 	}
+
+	write_phy_reg(pi, 0x6da, old_sslpnCalibClkEnCtrl);
+	W_REG(&pi->regs->psm_phy_hdr_param, curval2);
+	W_REG(&pi->regs->psm_corectlsts, curval1);
 }
 
-static void wlc_lcnphy_set_rx_iq_comp(struct brcms_phy *pi, u16 a, u16 b)
+static void
+wlc_lcnphy_a1(struct brcms_phy *pi, int cal_type, int num_levels,
+	      int step_size_lg2)
 {
-	mod_phy_reg(pi, 0x645, (0x3ff << 0), (a) << 0);
+	const struct lcnphy_spb_tone *phy_c1;
+	struct lcnphy_spb_tone phy_c2;
+	struct lcnphy_unsign16_struct phy_c3;
+	int phy_c4, phy_c5, k, l, j, phy_c6;
+	u16 phy_c7, phy_c8, phy_c9;
+	s16 phy_c10, phy_c11, phy_c12, phy_c13, phy_c14, phy_c15, phy_c16;
+	s16 *ptr, phy_c17;
+	s32 phy_c18, phy_c19;
+	u32 phy_c20, phy_c21;
+	bool phy_c22, phy_c23, phy_c24, phy_c25;
+	u16 phy_c26, phy_c27;
+	u16 phy_c28, phy_c29, phy_c30;
+	u16 phy_c31;
+	u16 *phy_c32;
+	phy_c21 = 0;
+	phy_c10 = phy_c13 = phy_c14 = phy_c8 = 0;
+	ptr = kmalloc(sizeof(s16) * 131, GFP_ATOMIC);
+	if (NULL == ptr)
+		return;
 
-	mod_phy_reg(pi, 0x646, (0x3ff << 0), (b) << 0);
+	phy_c32 = kmalloc(sizeof(u16) * 20, GFP_ATOMIC);
+	if (NULL == phy_c32) {
+		kfree(ptr);
+		return;
+	}
+	phy_c26 = read_phy_reg(pi, 0x6da);
+	phy_c27 = read_phy_reg(pi, 0x6db);
+	phy_c31 = read_radio_reg(pi, RADIO_2064_REG026);
+	write_phy_reg(pi, 0x93d, 0xC0);
 
-	mod_phy_reg(pi, 0x647, (0x3ff << 0), (a) << 0);
+	wlc_lcnphy_start_tx_tone(pi, 3750, 88, 0);
+	write_phy_reg(pi, 0x6da, 0xffff);
+	or_phy_reg(pi, 0x6db, 0x3);
 
-	mod_phy_reg(pi, 0x648, (0x3ff << 0), (b) << 0);
+	wlc_lcnphy_tx_iqlo_loopback(pi, phy_c32);
+	udelay(500);
+	phy_c28 = read_phy_reg(pi, 0x938);
+	phy_c29 = read_phy_reg(pi, 0x4d7);
+	phy_c30 = read_phy_reg(pi, 0x4d8);
+	or_phy_reg(pi, 0x938, 0x1 << 2);
+	or_phy_reg(pi, 0x4d7, 0x1 << 2);
+	or_phy_reg(pi, 0x4d7, 0x1 << 3);
+	mod_phy_reg(pi, 0x4d7, (0x7 << 12), 0x2 << 12);
+	or_phy_reg(pi, 0x4d8, 1 << 0);
+	or_phy_reg(pi, 0x4d8, 1 << 1);
+	mod_phy_reg(pi, 0x4d8, (0x3ff << 2), 0x23A << 2);
+	mod_phy_reg(pi, 0x4d8, (0x7 << 12), 0x7 << 12);
+	phy_c1 = &lcnphy_spb_tone_3750[0];
+	phy_c4 = 32;
 
-	mod_phy_reg(pi, 0x649, (0x3ff << 0), (a) << 0);
+	if (num_levels == 0) {
+		if (cal_type != 0)
+			num_levels = 4;
+		else
+			num_levels = 9;
+	}
+	if (step_size_lg2 == 0) {
+		if (cal_type != 0)
+			step_size_lg2 = 3;
+		else
+			step_size_lg2 = 8;
+	}
 
-	mod_phy_reg(pi, 0x64a, (0x3ff << 0), (b) << 0);
+	phy_c7 = (1 << step_size_lg2);
+	phy_c3 = wlc_lcnphy_get_cc(pi, cal_type);
+	phy_c15 = (s16) phy_c3.re;
+	phy_c16 = (s16) phy_c3.im;
+	if (cal_type == 2) {
+		if (phy_c3.re > 127)
+			phy_c15 = phy_c3.re - 256;
+		if (phy_c3.im > 127)
+			phy_c16 = phy_c3.im - 256;
+	}
+	wlc_lcnphy_set_cc(pi, cal_type, phy_c15, phy_c16);
+	udelay(20);
+	for (phy_c8 = 0; phy_c7 != 0 && phy_c8 < num_levels; phy_c8++) {
+		phy_c23 = 1;
+		phy_c22 = 0;
+		switch (cal_type) {
+		case 0:
+			phy_c10 = 511;
+			break;
+		case 2:
+			phy_c10 = 127;
+			break;
+		case 3:
+			phy_c10 = 15;
+			break;
+		case 4:
+			phy_c10 = 15;
+			break;
+		}
 
-}
+		phy_c9 = read_phy_reg(pi, 0x93d);
+		phy_c9 = 2 * phy_c9;
+		phy_c24 = 0;
+		phy_c5 = 7;
+		phy_c25 = 1;
+		while (1) {
+			write_radio_reg(pi, RADIO_2064_REG026,
+					(phy_c5 & 0x7) | ((phy_c5 & 0x7) << 4));
+			udelay(50);
+			phy_c22 = 0;
+			ptr[130] = 0;
+			wlc_lcnphy_samp_cap(pi, 1, phy_c9, &ptr[0], 2);
+			if (ptr[130] == 1)
+				phy_c22 = 1;
+			if (phy_c22)
+				phy_c5 -= 1;
+			if ((phy_c22 != phy_c24) && (!phy_c25))
+				break;
+			if (!phy_c22)
+				phy_c5 += 1;
+			if (phy_c5 <= 0 || phy_c5 >= 7)
+				break;
+			phy_c24 = phy_c22;
+			phy_c25 = 0;
+		}
 
-void wlc_phy_init_lcnphy(struct brcms_phy *pi)
-{
-	u8 phybw40;
-	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
-	phybw40 = CHSPEC_IS40(pi->radio_chanspec);
+		if (phy_c5 < 0)
+			phy_c5 = 0;
+		else if (phy_c5 > 7)
+			phy_c5 = 7;
 
-	pi_lcn->lcnphy_cal_counter = 0;
-	pi_lcn->lcnphy_cal_temper = pi_lcn->lcnphy_rawtempsense;
+		for (k = -phy_c7; k <= phy_c7; k += phy_c7) {
+			for (l = -phy_c7; l <= phy_c7; l += phy_c7) {
+				phy_c11 = phy_c15 + k;
+				phy_c12 = phy_c16 + l;
 
-	or_phy_reg(pi, 0x44a, 0x80);
-	and_phy_reg(pi, 0x44a, 0x7f);
+				if (phy_c11 < -phy_c10)
+					phy_c11 = -phy_c10;
+				else if (phy_c11 > phy_c10)
+					phy_c11 = phy_c10;
+				if (phy_c12 < -phy_c10)
+					phy_c12 = -phy_c10;
+				else if (phy_c12 > phy_c10)
+					phy_c12 = phy_c10;
+				wlc_lcnphy_set_cc(pi, cal_type, phy_c11,
+						  phy_c12);
+				udelay(20);
+				wlc_lcnphy_samp_cap(pi, 0, 0, ptr, 2);
 
-	wlc_lcnphy_afe_clk_init(pi, AFE_CLK_INIT_MODE_TXRX2X);
+				phy_c18 = 0;
+				phy_c19 = 0;
+				for (j = 0; j < 128; j++) {
+					if (cal_type != 0)
+						phy_c6 = j % phy_c4;
+					else
+						phy_c6 = (2 * j) % phy_c4;
 
-	write_phy_reg(pi, 0x60a, 160);
+					phy_c2.re = phy_c1[phy_c6].re;
+					phy_c2.im = phy_c1[phy_c6].im;
+					phy_c17 = ptr[j];
+					phy_c18 = phy_c18 + phy_c17 * phy_c2.re;
+					phy_c19 = phy_c19 + phy_c17 * phy_c2.im;
+				}
 
-	write_phy_reg(pi, 0x46a, 25);
+				phy_c18 = phy_c18 >> 10;
+				phy_c19 = phy_c19 >> 10;
+				phy_c20 = ((phy_c18 * phy_c18) +
+					   (phy_c19 * phy_c19));
 
-	wlc_lcnphy_baseband_init(pi);
+				if (phy_c23 || phy_c20 < phy_c21) {
+					phy_c21 = phy_c20;
+					phy_c13 = phy_c11;
+					phy_c14 = phy_c12;
+				}
+				phy_c23 = 0;
+			}
+		}
+		phy_c23 = 1;
+		phy_c15 = phy_c13;
+		phy_c16 = phy_c14;
+		phy_c7 = phy_c7 >> 1;
+		wlc_lcnphy_set_cc(pi, cal_type, phy_c15, phy_c16);
+		udelay(20);
+	}
+	goto cleanup;
+cleanup:
+	wlc_lcnphy_tx_iqlo_loopback_cleanup(pi, phy_c32);
+	wlc_lcnphy_stop_tx_tone(pi);
+	write_phy_reg(pi, 0x6da, phy_c26);
+	write_phy_reg(pi, 0x6db, phy_c27);
+	write_phy_reg(pi, 0x938, phy_c28);
+	write_phy_reg(pi, 0x4d7, phy_c29);
+	write_phy_reg(pi, 0x4d8, phy_c30);
+	write_radio_reg(pi, RADIO_2064_REG026, phy_c31);
 
-	wlc_lcnphy_radio_init(pi);
+	kfree(phy_c32);
+	kfree(ptr);
+}
 
-	if (CHSPEC_IS2G(pi->radio_chanspec))
-		wlc_lcnphy_tx_pwr_ctrl_init((struct brcms_phy_pub *) pi);
+void wlc_lcnphy_get_tx_iqcc(struct brcms_phy *pi, u16 *a, u16 *b)
+{
+	u16 iqcc[2];
+	struct phytbl_info tab;
 
-	wlc_phy_chanspec_set((struct brcms_phy_pub *) pi, pi->radio_chanspec);
+	tab.tbl_ptr = iqcc;
+	tab.tbl_len = 2;
+	tab.tbl_id = 0;
+	tab.tbl_offset = 80;
+	tab.tbl_width = 16;
+	wlc_lcnphy_read_table(pi, &tab);
 
-	si_pmu_regcontrol(pi->sh->sih, 0, 0xf, 0x9);
+	*a = iqcc[0];
+	*b = iqcc[1];
+}
 
-	si_pmu_chipcontrol(pi->sh->sih, 0, 0xffffffff, 0x03CDDDDD);
+static void wlc_lcnphy_tx_iqlo_soft_cal_full(struct brcms_phy *pi)
+{
+	struct lcnphy_unsign16_struct iqcc0, locc2, locc3, locc4;
 
-	if ((pi->sh->boardflags & BFL_FEM)
-	    && wlc_lcnphy_tempsense_based_pwr_ctrl_enabled(pi))
-		wlc_lcnphy_set_tx_pwr_by_index(pi, FIXED_TXPWR);
+	wlc_lcnphy_set_cc(pi, 0, 0, 0);
+	wlc_lcnphy_set_cc(pi, 2, 0, 0);
+	wlc_lcnphy_set_cc(pi, 3, 0, 0);
+	wlc_lcnphy_set_cc(pi, 4, 0, 0);
 
-	wlc_lcnphy_agc_temp_init(pi);
+	wlc_lcnphy_a1(pi, 4, 0, 0);
+	wlc_lcnphy_a1(pi, 3, 0, 0);
+	wlc_lcnphy_a1(pi, 2, 3, 2);
+	wlc_lcnphy_a1(pi, 0, 5, 8);
+	wlc_lcnphy_a1(pi, 2, 2, 1);
+	wlc_lcnphy_a1(pi, 0, 4, 3);
 
-	wlc_lcnphy_temp_adj(pi);
+	iqcc0 = wlc_lcnphy_get_cc(pi, 0);
+	locc2 = wlc_lcnphy_get_cc(pi, 2);
+	locc3 = wlc_lcnphy_get_cc(pi, 3);
+	locc4 = wlc_lcnphy_get_cc(pi, 4);
+}
 
-	mod_phy_reg(pi, 0x448, (0x1 << 14), (1) << 14);
+u16 wlc_lcnphy_get_tx_locc(struct brcms_phy *pi)
+{
+	struct phytbl_info tab;
+	u16 didq;
 
-	udelay(100);
-	mod_phy_reg(pi, 0x448, (0x1 << 14), (0) << 14);
+	tab.tbl_id = 0;
+	tab.tbl_width = 16;
+	tab.tbl_ptr = &didq;
+	tab.tbl_len = 1;
+	tab.tbl_offset = 85;
+	wlc_lcnphy_read_table(pi, &tab);
 
-	wlc_lcnphy_set_tx_pwr_ctrl(pi, LCNPHY_TX_PWR_CTRL_HW);
-	pi_lcn->lcnphy_noise_samples = LCNPHY_NOISE_SAMPLES_DEFAULT;
-	wlc_lcnphy_calib_modes(pi, PHY_PERICAL_PHYINIT);
+	return didq;
 }
 
-static void
-wlc_lcnphy_tx_iqlo_loopback(struct brcms_phy *pi, u16 *values_to_save)
+static void wlc_lcnphy_txpwrtbl_iqlo_cal(struct brcms_phy *pi)
 {
-	u16 vmid;
-	int i;
-	for (i = 0; i < 20; i++)
-		values_to_save[i] =
-			read_radio_reg(pi, iqlo_loopback_rf_regs[i]);
 
-	mod_phy_reg(pi, 0x44c, (0x1 << 12), 1 << 12);
-	mod_phy_reg(pi, 0x44d, (0x1 << 14), 1 << 14);
+	struct lcnphy_txgains target_gains, old_gains;
+	u8 save_bb_mult;
+	u16 a, b, didq, save_pa_gain = 0;
+	uint idx, SAVE_txpwrindex = 0xFF;
+	u32 val;
+	u16 SAVE_txpwrctrl = wlc_lcnphy_get_tx_pwr_ctrl(pi);
+	struct phytbl_info tab;
+	u8 ei0, eq0, fi0, fq0;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
-	mod_phy_reg(pi, 0x44c, (0x1 << 11), 1 << 11);
-	mod_phy_reg(pi, 0x44d, (0x1 << 13), 0 << 13);
+	wlc_lcnphy_get_tx_gain(pi, &old_gains);
+	save_pa_gain = wlc_lcnphy_get_pa_gain(pi);
 
-	mod_phy_reg(pi, 0x43b, (0x1 << 1), 1 << 1);
-	mod_phy_reg(pi, 0x43c, (0x1 << 1), 0 << 1);
+	save_bb_mult = wlc_lcnphy_get_bbmult(pi);
 
-	mod_phy_reg(pi, 0x43b, (0x1 << 0), 1 << 0);
-	mod_phy_reg(pi, 0x43c, (0x1 << 0), 0 << 0);
+	if (SAVE_txpwrctrl == LCNPHY_TX_PWR_CTRL_OFF)
+		SAVE_txpwrindex = wlc_lcnphy_get_current_tx_pwr_idx(pi);
 
-	if (LCNREV_IS(pi->pubpi.phy_rev, 2))
-		and_radio_reg(pi, RADIO_2064_REG03A, 0xFD);
-	else
-		and_radio_reg(pi, RADIO_2064_REG03A, 0xF9);
-	or_radio_reg(pi, RADIO_2064_REG11A, 0x1);
+	wlc_lcnphy_set_tx_pwr_ctrl(pi, LCNPHY_TX_PWR_CTRL_OFF);
 
-	or_radio_reg(pi, RADIO_2064_REG036, 0x01);
-	or_radio_reg(pi, RADIO_2064_REG11A, 0x18);
-	udelay(20);
+	target_gains.gm_gain = 7;
+	target_gains.pga_gain = 0;
+	target_gains.pad_gain = 21;
+	target_gains.dac_gain = 0;
+	wlc_lcnphy_set_tx_gain(pi, &target_gains);
+	wlc_lcnphy_set_tx_pwr_by_index(pi, 16);
 
-	if (LCNREV_IS(pi->pubpi.phy_rev, 2)) {
-		if (CHSPEC_IS5G(pi->radio_chanspec))
-			mod_radio_reg(pi, RADIO_2064_REG03A, 1, 0);
-		else
-			or_radio_reg(pi, RADIO_2064_REG03A, 1);
-	} else {
-		if (CHSPEC_IS5G(pi->radio_chanspec))
-			mod_radio_reg(pi, RADIO_2064_REG03A, 3, 1);
-		else
-			or_radio_reg(pi, RADIO_2064_REG03A, 0x3);
-	}
+	if (LCNREV_IS(pi->pubpi.phy_rev, 1) || pi_lcn->lcnphy_hw_iqcal_en) {
 
-	udelay(20);
+		wlc_lcnphy_set_tx_pwr_by_index(pi, 30);
 
-	write_radio_reg(pi, RADIO_2064_REG025, 0xF);
-	if (LCNREV_IS(pi->pubpi.phy_rev, 2)) {
-		if (CHSPEC_IS5G(pi->radio_chanspec))
-			mod_radio_reg(pi, RADIO_2064_REG028, 0xF, 0x4);
-		else
-			mod_radio_reg(pi, RADIO_2064_REG028, 0xF, 0x6);
+		wlc_lcnphy_tx_iqlo_cal(pi, &target_gains,
+				       (pi_lcn->
+					lcnphy_recal ? LCNPHY_CAL_RECAL :
+					LCNPHY_CAL_FULL), false);
 	} else {
-		if (CHSPEC_IS5G(pi->radio_chanspec))
-			mod_radio_reg(pi, RADIO_2064_REG028, 0x1e, 0x4 << 1);
-		else
-			mod_radio_reg(pi, RADIO_2064_REG028, 0x1e, 0x6 << 1);
+		wlc_lcnphy_tx_iqlo_soft_cal_full(pi);
 	}
 
-	udelay(20);
+	wlc_lcnphy_get_radio_loft(pi, &ei0, &eq0, &fi0, &fq0);
+	if ((ABS((s8) fi0) == 15) && (ABS((s8) fq0) == 15)) {
+		if (CHSPEC_IS5G(pi->radio_chanspec)) {
+			target_gains.gm_gain = 255;
+			target_gains.pga_gain = 255;
+			target_gains.pad_gain = 0xf0;
+			target_gains.dac_gain = 0;
+		} else {
+			target_gains.gm_gain = 7;
+			target_gains.pga_gain = 45;
+			target_gains.pad_gain = 186;
+			target_gains.dac_gain = 0;
+		}
 
-	write_radio_reg(pi, RADIO_2064_REG005, 0x8);
-	or_radio_reg(pi, RADIO_2064_REG112, 0x80);
-	udelay(20);
+		if (LCNREV_IS(pi->pubpi.phy_rev, 1)
+		    || pi_lcn->lcnphy_hw_iqcal_en) {
 
-	or_radio_reg(pi, RADIO_2064_REG0FF, 0x10);
-	or_radio_reg(pi, RADIO_2064_REG11F, 0x44);
-	udelay(20);
+			target_gains.pga_gain = 0;
+			target_gains.pad_gain = 30;
+			wlc_lcnphy_set_tx_pwr_by_index(pi, 16);
+			wlc_lcnphy_tx_iqlo_cal(pi, &target_gains,
+					       LCNPHY_CAL_FULL, false);
+		} else {
+			wlc_lcnphy_tx_iqlo_soft_cal_full(pi);
+		}
+	}
 
-	or_radio_reg(pi, RADIO_2064_REG00B, 0x7);
-	or_radio_reg(pi, RADIO_2064_REG113, 0x10);
-	udelay(20);
+	wlc_lcnphy_get_tx_iqcc(pi, &a, &b);
 
-	write_radio_reg(pi, RADIO_2064_REG007, 0x1);
-	udelay(20);
+	didq = wlc_lcnphy_get_tx_locc(pi);
 
-	vmid = 0x2A6;
-	mod_radio_reg(pi, RADIO_2064_REG0FC, 0x3 << 0, (vmid >> 8) & 0x3);
-	write_radio_reg(pi, RADIO_2064_REG0FD, (vmid & 0xff));
-	or_radio_reg(pi, RADIO_2064_REG11F, 0x44);
-	udelay(20);
+	tab.tbl_id = LCNPHY_TBL_ID_TXPWRCTL;
+	tab.tbl_width = 32;
+	tab.tbl_ptr = &val;
 
-	or_radio_reg(pi, RADIO_2064_REG0FF, 0x10);
-	udelay(20);
-	write_radio_reg(pi, RADIO_2064_REG012, 0x02);
-	or_radio_reg(pi, RADIO_2064_REG112, 0x06);
-	write_radio_reg(pi, RADIO_2064_REG036, 0x11);
-	write_radio_reg(pi, RADIO_2064_REG059, 0xcc);
-	write_radio_reg(pi, RADIO_2064_REG05C, 0x2e);
-	write_radio_reg(pi, RADIO_2064_REG078, 0xd7);
-	write_radio_reg(pi, RADIO_2064_REG092, 0x15);
-}
+	tab.tbl_len = 1;
+	tab.tbl_offset = LCNPHY_TX_PWR_CTRL_RATE_OFFSET;
 
-static void
-wlc_lcnphy_samp_cap(struct brcms_phy *pi, int clip_detect_algo, u16 thresh,
-		    s16 *ptr, int mode)
-{
-	u32 curval1, curval2, stpptr, curptr, strptr, val;
-	u16 sslpnCalibClkEnCtrl, timer;
-	u16 old_sslpnCalibClkEnCtrl;
-	s16 imag, real;
-	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	for (idx = 0; idx < 128; idx++) {
+		tab.tbl_offset = LCNPHY_TX_PWR_CTRL_IQ_OFFSET + idx;
 
-	timer = 0;
-	old_sslpnCalibClkEnCtrl = read_phy_reg(pi, 0x6da);
+		wlc_lcnphy_read_table(pi, &tab);
+		val = (val & 0xfff00000) |
+		      ((u32) (a & 0x3FF) << 10) | (b & 0x3ff);
+		wlc_lcnphy_write_table(pi, &tab);
 
-	curval1 = R_REG(&pi->regs->psm_corectlsts);
-	ptr[130] = 0;
-	W_REG(&pi->regs->psm_corectlsts, ((1 << 6) | curval1));
+		val = didq;
+		tab.tbl_offset = LCNPHY_TX_PWR_CTRL_LO_OFFSET + idx;
+		wlc_lcnphy_write_table(pi, &tab);
+	}
 
-	W_REG(&pi->regs->smpl_clct_strptr, 0x7E00);
-	W_REG(&pi->regs->smpl_clct_stpptr, 0x8000);
-	udelay(20);
-	curval2 = R_REG(&pi->regs->psm_phy_hdr_param);
-	W_REG(&pi->regs->psm_phy_hdr_param, curval2 | 0x30);
+	pi_lcn->lcnphy_cal_results.txiqlocal_a = a;
+	pi_lcn->lcnphy_cal_results.txiqlocal_b = b;
+	pi_lcn->lcnphy_cal_results.txiqlocal_didq = didq;
+	pi_lcn->lcnphy_cal_results.txiqlocal_ei0 = ei0;
+	pi_lcn->lcnphy_cal_results.txiqlocal_eq0 = eq0;
+	pi_lcn->lcnphy_cal_results.txiqlocal_fi0 = fi0;
+	pi_lcn->lcnphy_cal_results.txiqlocal_fq0 = fq0;
 
-	write_phy_reg(pi, 0x555, 0x0);
-	write_phy_reg(pi, 0x5a6, 0x5);
+	wlc_lcnphy_set_bbmult(pi, save_bb_mult);
+	wlc_lcnphy_set_pa_gain(pi, save_pa_gain);
+	wlc_lcnphy_set_tx_gain(pi, &old_gains);
 
-	write_phy_reg(pi, 0x5a2, (u16) (mode | mode << 6));
-	write_phy_reg(pi, 0x5cf, 3);
-	write_phy_reg(pi, 0x5a5, 0x3);
-	write_phy_reg(pi, 0x583, 0x0);
-	write_phy_reg(pi, 0x584, 0x0);
-	write_phy_reg(pi, 0x585, 0x0fff);
-	write_phy_reg(pi, 0x586, 0x0000);
+	if (SAVE_txpwrctrl != LCNPHY_TX_PWR_CTRL_OFF)
+		wlc_lcnphy_set_tx_pwr_ctrl(pi, SAVE_txpwrctrl);
+	else
+		wlc_lcnphy_set_tx_pwr_by_index(pi, SAVE_txpwrindex);
+}
 
-	write_phy_reg(pi, 0x580, 0x4501);
+s16 wlc_lcnphy_tempsense_new(struct brcms_phy *pi, bool mode)
+{
+	u16 tempsenseval1, tempsenseval2;
+	s16 avg = 0;
+	bool suspend = 0;
 
-	sslpnCalibClkEnCtrl = read_phy_reg(pi, 0x6da);
-	write_phy_reg(pi, 0x6da, (u32) (sslpnCalibClkEnCtrl | 0x2008));
-	stpptr = R_REG(&pi->regs->smpl_clct_stpptr);
-	curptr = R_REG(&pi->regs->smpl_clct_curptr);
-	do {
-		udelay(10);
-		curptr = R_REG(&pi->regs->smpl_clct_curptr);
-		timer++;
-	} while ((curptr != stpptr) && (timer < 500));
+	if (mode == 1) {
+		suspend =
+			(0 ==
+			 (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
+		if (!suspend)
+			wlapi_suspend_mac_and_wait(pi->sh->physhim);
+		wlc_lcnphy_vbat_temp_sense_setup(pi, TEMPSENSE);
+	}
+	tempsenseval1 = read_phy_reg(pi, 0x476) & 0x1FF;
+	tempsenseval2 = read_phy_reg(pi, 0x477) & 0x1FF;
 
-	W_REG(&pi->regs->psm_phy_hdr_param, 0x2);
-	strptr = 0x7E00;
-	W_REG(&pi->regs->tplatewrptr, strptr);
-	while (strptr < 0x8000) {
-		val = R_REG(&pi->regs->tplatewrdata);
-		imag = ((val >> 16) & 0x3ff);
-		real = ((val) & 0x3ff);
-		if (imag > 511)
-			imag -= 1024;
+	if (tempsenseval1 > 255)
+		avg = (s16) (tempsenseval1 - 512);
+	else
+		avg = (s16) tempsenseval1;
 
-		if (real > 511)
-			real -= 1024;
+	if (tempsenseval2 > 255)
+		avg += (s16) (tempsenseval2 - 512);
+	else
+		avg += (s16) tempsenseval2;
 
-		if (pi_lcn->lcnphy_iqcal_swp_dis)
-			ptr[(strptr - 0x7E00) / 4] = real;
-		else
-			ptr[(strptr - 0x7E00) / 4] = imag;
+	avg /= 2;
 
-		if (clip_detect_algo) {
-			if (imag > thresh || imag < -thresh) {
-				strptr = 0x8000;
-				ptr[130] = 1;
-			}
-		}
+	if (mode == 1) {
 
-		strptr += 4;
-	}
+		mod_phy_reg(pi, 0x448, (0x1 << 14), (1) << 14);
 
-	write_phy_reg(pi, 0x6da, old_sslpnCalibClkEnCtrl);
-	W_REG(&pi->regs->psm_phy_hdr_param, curval2);
-	W_REG(&pi->regs->psm_corectlsts, curval1);
+		udelay(100);
+		mod_phy_reg(pi, 0x448, (0x1 << 14), (0) << 14);
+
+		if (!suspend)
+			wlapi_enable_mac(pi->sh->physhim);
+	}
+	return avg;
 }
 
-static void wlc_lcnphy_tx_iqlo_soft_cal_full(struct brcms_phy *pi)
+u16 wlc_lcnphy_tempsense(struct brcms_phy *pi, bool mode)
 {
-	struct lcnphy_unsign16_struct iqcc0, locc2, locc3, locc4;
+	u16 tempsenseval1, tempsenseval2;
+	s32 avg = 0;
+	bool suspend = 0;
+	u16 SAVE_txpwrctrl = wlc_lcnphy_get_tx_pwr_ctrl(pi);
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
-	wlc_lcnphy_set_cc(pi, 0, 0, 0);
-	wlc_lcnphy_set_cc(pi, 2, 0, 0);
-	wlc_lcnphy_set_cc(pi, 3, 0, 0);
-	wlc_lcnphy_set_cc(pi, 4, 0, 0);
+	if (mode == 1) {
+		suspend =
+			(0 ==
+			 (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
+		if (!suspend)
+			wlapi_suspend_mac_and_wait(pi->sh->physhim);
+		wlc_lcnphy_vbat_temp_sense_setup(pi, TEMPSENSE);
+	}
+	tempsenseval1 = read_phy_reg(pi, 0x476) & 0x1FF;
+	tempsenseval2 = read_phy_reg(pi, 0x477) & 0x1FF;
 
-	wlc_lcnphy_a1(pi, 4, 0, 0);
-	wlc_lcnphy_a1(pi, 3, 0, 0);
-	wlc_lcnphy_a1(pi, 2, 3, 2);
-	wlc_lcnphy_a1(pi, 0, 5, 8);
-	wlc_lcnphy_a1(pi, 2, 2, 1);
-	wlc_lcnphy_a1(pi, 0, 4, 3);
+	if (tempsenseval1 > 255)
+		avg = (int)(tempsenseval1 - 512);
+	else
+		avg = (int)tempsenseval1;
 
-	iqcc0 = wlc_lcnphy_get_cc(pi, 0);
-	locc2 = wlc_lcnphy_get_cc(pi, 2);
-	locc3 = wlc_lcnphy_get_cc(pi, 3);
-	locc4 = wlc_lcnphy_get_cc(pi, 4);
-}
+	if (pi_lcn->lcnphy_tempsense_option == 1 || pi->hwpwrctrl_capable) {
+		if (tempsenseval2 > 255)
+			avg = (int)(avg - tempsenseval2 + 512);
+		else
+			avg = (int)(avg - tempsenseval2);
+	} else {
+		if (tempsenseval2 > 255)
+			avg = (int)(avg + tempsenseval2 - 512);
+		else
+			avg = (int)(avg + tempsenseval2);
+		avg = avg / 2;
+	}
+	if (avg < 0)
+		avg = avg + 512;
 
-static void
-wlc_lcnphy_set_cc(struct brcms_phy *pi, int cal_type, s16 coeff_x, s16 coeff_y)
-{
-	u16 di0dq0;
-	u16 x, y, data_rf;
-	int k;
-	switch (cal_type) {
-	case 0:
-		wlc_lcnphy_set_tx_iqcc(pi, coeff_x, coeff_y);
-		break;
-	case 2:
-		di0dq0 = (coeff_x & 0xff) << 8 | (coeff_y & 0xff);
-		wlc_lcnphy_set_tx_locc(pi, di0dq0);
-		break;
-	case 3:
-		k = wlc_lcnphy_calc_floor(coeff_x, 0);
-		y = 8 + k;
-		k = wlc_lcnphy_calc_floor(coeff_x, 1);
-		x = 8 - k;
-		data_rf = (x * 16 + y);
-		write_radio_reg(pi, RADIO_2064_REG089, data_rf);
-		k = wlc_lcnphy_calc_floor(coeff_y, 0);
-		y = 8 + k;
-		k = wlc_lcnphy_calc_floor(coeff_y, 1);
-		x = 8 - k;
-		data_rf = (x * 16 + y);
-		write_radio_reg(pi, RADIO_2064_REG08A, data_rf);
-		break;
-	case 4:
-		k = wlc_lcnphy_calc_floor(coeff_x, 0);
-		y = 8 + k;
-		k = wlc_lcnphy_calc_floor(coeff_x, 1);
-		x = 8 - k;
-		data_rf = (x * 16 + y);
-		write_radio_reg(pi, RADIO_2064_REG08B, data_rf);
-		k = wlc_lcnphy_calc_floor(coeff_y, 0);
-		y = 8 + k;
-		k = wlc_lcnphy_calc_floor(coeff_y, 1);
-		x = 8 - k;
-		data_rf = (x * 16 + y);
-		write_radio_reg(pi, RADIO_2064_REG08C, data_rf);
-		break;
+	if (pi_lcn->lcnphy_tempsense_option == 2)
+		avg = tempsenseval1;
+
+	if (mode)
+		wlc_lcnphy_set_tx_pwr_ctrl(pi, SAVE_txpwrctrl);
+
+	if (mode == 1) {
+
+		mod_phy_reg(pi, 0x448, (0x1 << 14), (1) << 14);
+
+		udelay(100);
+		mod_phy_reg(pi, 0x448, (0x1 << 14), (0) << 14);
+
+		if (!suspend)
+			wlapi_enable_mac(pi->sh->physhim);
 	}
+	return (u16) avg;
 }
 
-static struct lcnphy_unsign16_struct
-wlc_lcnphy_get_cc(struct brcms_phy *pi, int cal_type)
+s8 wlc_lcnphy_tempsense_degree(struct brcms_phy *pi, bool mode)
 {
-	u16 a, b, didq;
-	u8 di0, dq0, ei, eq, fi, fq;
-	struct lcnphy_unsign16_struct cc;
-	cc.re = 0;
-	cc.im = 0;
-	switch (cal_type) {
-	case 0:
-		wlc_lcnphy_get_tx_iqcc(pi, &a, &b);
-		cc.re = a;
-		cc.im = b;
-		break;
-	case 2:
-		didq = wlc_lcnphy_get_tx_locc(pi);
-		di0 = (((didq & 0xff00) << 16) >> 24);
-		dq0 = (((didq & 0x00ff) << 24) >> 24);
-		cc.re = (u16) di0;
-		cc.im = (u16) dq0;
-		break;
-	case 3:
-		wlc_lcnphy_get_radio_loft(pi, &ei, &eq, &fi, &fq);
-		cc.re = (u16) ei;
-		cc.im = (u16) eq;
-		break;
-	case 4:
-		wlc_lcnphy_get_radio_loft(pi, &ei, &eq, &fi, &fq);
-		cc.re = (u16) fi;
-		cc.im = (u16) fq;
-		break;
-	}
-	return cc;
+	s32 degree = wlc_lcnphy_tempsense_new(pi, mode);
+	degree =
+		((degree <<
+		  10) + LCN_TEMPSENSE_OFFSET + (LCN_TEMPSENSE_DEN >> 1))
+		/ LCN_TEMPSENSE_DEN;
+	return (s8) degree;
 }
 
-static void
-wlc_lcnphy_a1(struct brcms_phy *pi, int cal_type, int num_levels,
-	      int step_size_lg2)
+s8 wlc_lcnphy_vbatsense(struct brcms_phy *pi, bool mode)
 {
-	const struct lcnphy_spb_tone *phy_c1;
-	struct lcnphy_spb_tone phy_c2;
-	struct lcnphy_unsign16_struct phy_c3;
-	int phy_c4, phy_c5, k, l, j, phy_c6;
-	u16 phy_c7, phy_c8, phy_c9;
-	s16 phy_c10, phy_c11, phy_c12, phy_c13, phy_c14, phy_c15, phy_c16;
-	s16 *ptr, phy_c17;
-	s32 phy_c18, phy_c19;
-	u32 phy_c20, phy_c21;
-	bool phy_c22, phy_c23, phy_c24, phy_c25;
-	u16 phy_c26, phy_c27;
-	u16 phy_c28, phy_c29, phy_c30;
-	u16 phy_c31;
-	u16 *phy_c32;
-	phy_c21 = 0;
-	phy_c10 = phy_c13 = phy_c14 = phy_c8 = 0;
-	ptr = kmalloc(sizeof(s16) * 131, GFP_ATOMIC);
-	if (NULL == ptr)
-		return;
+	u16 vbatsenseval;
+	s32 avg = 0;
+	bool suspend = 0;
 
-	phy_c32 = kmalloc(sizeof(u16) * 20, GFP_ATOMIC);
-	if (NULL == phy_c32) {
-		kfree(ptr);
-		return;
+	if (mode == 1) {
+		suspend =
+			(0 ==
+			 (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
+		if (!suspend)
+			wlapi_suspend_mac_and_wait(pi->sh->physhim);
+		wlc_lcnphy_vbat_temp_sense_setup(pi, VBATSENSE);
 	}
-	phy_c26 = read_phy_reg(pi, 0x6da);
-	phy_c27 = read_phy_reg(pi, 0x6db);
-	phy_c31 = read_radio_reg(pi, RADIO_2064_REG026);
-	write_phy_reg(pi, 0x93d, 0xC0);
 
-	wlc_lcnphy_start_tx_tone(pi, 3750, 88, 0);
-	write_phy_reg(pi, 0x6da, 0xffff);
-	or_phy_reg(pi, 0x6db, 0x3);
+	vbatsenseval = read_phy_reg(pi, 0x475) & 0x1FF;
 
-	wlc_lcnphy_tx_iqlo_loopback(pi, phy_c32);
-	udelay(500);
-	phy_c28 = read_phy_reg(pi, 0x938);
-	phy_c29 = read_phy_reg(pi, 0x4d7);
-	phy_c30 = read_phy_reg(pi, 0x4d8);
-	or_phy_reg(pi, 0x938, 0x1 << 2);
-	or_phy_reg(pi, 0x4d7, 0x1 << 2);
-	or_phy_reg(pi, 0x4d7, 0x1 << 3);
-	mod_phy_reg(pi, 0x4d7, (0x7 << 12), 0x2 << 12);
-	or_phy_reg(pi, 0x4d8, 1 << 0);
-	or_phy_reg(pi, 0x4d8, 1 << 1);
-	mod_phy_reg(pi, 0x4d8, (0x3ff << 2), 0x23A << 2);
-	mod_phy_reg(pi, 0x4d8, (0x7 << 12), 0x7 << 12);
-	phy_c1 = &lcnphy_spb_tone_3750[0];
-	phy_c4 = 32;
+	if (vbatsenseval > 255)
+		avg = (s32) (vbatsenseval - 512);
+	else
+		avg = (s32) vbatsenseval;
 
-	if (num_levels == 0) {
-		if (cal_type != 0)
-			num_levels = 4;
-		else
-			num_levels = 9;
-	}
-	if (step_size_lg2 == 0) {
-		if (cal_type != 0)
-			step_size_lg2 = 3;
-		else
-			step_size_lg2 = 8;
+	avg =	(avg * LCN_VBAT_SCALE_NOM +
+		 (LCN_VBAT_SCALE_DEN >> 1)) / LCN_VBAT_SCALE_DEN;
+
+	if (mode == 1) {
+		if (!suspend)
+			wlapi_enable_mac(pi->sh->physhim);
 	}
+	return (s8) avg;
+}
 
-	phy_c7 = (1 << step_size_lg2);
-	phy_c3 = wlc_lcnphy_get_cc(pi, cal_type);
-	phy_c15 = (s16) phy_c3.re;
-	phy_c16 = (s16) phy_c3.im;
-	if (cal_type == 2) {
-		if (phy_c3.re > 127)
-			phy_c15 = phy_c3.re - 256;
-		if (phy_c3.im > 127)
-			phy_c16 = phy_c3.im - 256;
+static void wlc_lcnphy_afe_clk_init(struct brcms_phy *pi, u8 mode)
+{
+	u8 phybw40;
+	phybw40 = CHSPEC_IS40(pi->radio_chanspec);
+
+	mod_phy_reg(pi, 0x6d1, (0x1 << 7), (1) << 7);
+
+	if (((mode == AFE_CLK_INIT_MODE_PAPD) && (phybw40 == 0)) ||
+	    (mode == AFE_CLK_INIT_MODE_TXRX2X))
+		write_phy_reg(pi, 0x6d0, 0x7);
+
+	wlc_lcnphy_toggle_afe_pwdn(pi);
+}
+
+static void wlc_lcnphy_temp_adj(struct brcms_phy *pi)
+{
+}
+
+static void wlc_lcnphy_glacial_timer_based_cal(struct brcms_phy *pi)
+{
+	bool suspend;
+	s8 index;
+	u16 SAVE_pwrctrl = wlc_lcnphy_get_tx_pwr_ctrl(pi);
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	suspend =
+		(0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
+	if (!suspend)
+		wlapi_suspend_mac_and_wait(pi->sh->physhim);
+	wlc_lcnphy_deaf_mode(pi, true);
+	pi->phy_lastcal = pi->sh->now;
+	pi->phy_forcecal = false;
+	index = pi_lcn->lcnphy_current_index;
+
+	wlc_lcnphy_txpwrtbl_iqlo_cal(pi);
+
+	wlc_lcnphy_set_tx_pwr_by_index(pi, index);
+	wlc_lcnphy_set_tx_pwr_ctrl(pi, SAVE_pwrctrl);
+	wlc_lcnphy_deaf_mode(pi, false);
+	if (!suspend)
+		wlapi_enable_mac(pi->sh->physhim);
+
+}
+
+static void wlc_lcnphy_periodic_cal(struct brcms_phy *pi)
+{
+	bool suspend, full_cal;
+	const struct lcnphy_rx_iqcomp *rx_iqcomp;
+	int rx_iqcomp_sz;
+	u16 SAVE_pwrctrl = wlc_lcnphy_get_tx_pwr_ctrl(pi);
+	s8 index;
+	struct phytbl_info tab;
+	s32 a1, b0, b1;
+	s32 tssi, pwr, maxtargetpwr, mintargetpwr;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+
+	pi->phy_lastcal = pi->sh->now;
+	pi->phy_forcecal = false;
+	full_cal =
+		(pi_lcn->lcnphy_full_cal_channel !=
+		 CHSPEC_CHANNEL(pi->radio_chanspec));
+	pi_lcn->lcnphy_full_cal_channel = CHSPEC_CHANNEL(pi->radio_chanspec);
+	index = pi_lcn->lcnphy_current_index;
+
+	suspend =
+		(0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
+	if (!suspend) {
+		wlapi_bmac_write_shm(pi->sh->physhim, M_CTS_DURATION, 10000);
+		wlapi_suspend_mac_and_wait(pi->sh->physhim);
 	}
-	wlc_lcnphy_set_cc(pi, cal_type, phy_c15, phy_c16);
-	udelay(20);
-	for (phy_c8 = 0; phy_c7 != 0 && phy_c8 < num_levels; phy_c8++) {
-		phy_c23 = 1;
-		phy_c22 = 0;
-		switch (cal_type) {
-		case 0:
-			phy_c10 = 511;
-			break;
-		case 2:
-			phy_c10 = 127;
-			break;
-		case 3:
-			phy_c10 = 15;
-			break;
-		case 4:
-			phy_c10 = 15;
-			break;
-		}
 
-		phy_c9 = read_phy_reg(pi, 0x93d);
-		phy_c9 = 2 * phy_c9;
-		phy_c24 = 0;
-		phy_c5 = 7;
-		phy_c25 = 1;
-		while (1) {
-			write_radio_reg(pi, RADIO_2064_REG026,
-					(phy_c5 & 0x7) | ((phy_c5 & 0x7) << 4));
-			udelay(50);
-			phy_c22 = 0;
-			ptr[130] = 0;
-			wlc_lcnphy_samp_cap(pi, 1, phy_c9, &ptr[0], 2);
-			if (ptr[130] == 1)
-				phy_c22 = 1;
-			if (phy_c22)
-				phy_c5 -= 1;
-			if ((phy_c22 != phy_c24) && (!phy_c25))
-				break;
-			if (!phy_c22)
-				phy_c5 += 1;
-			if (phy_c5 <= 0 || phy_c5 >= 7)
-				break;
-			phy_c24 = phy_c22;
-			phy_c25 = 0;
-		}
+	wlc_lcnphy_deaf_mode(pi, true);
 
-		if (phy_c5 < 0)
-			phy_c5 = 0;
-		else if (phy_c5 > 7)
-			phy_c5 = 7;
+	wlc_lcnphy_txpwrtbl_iqlo_cal(pi);
 
-		for (k = -phy_c7; k <= phy_c7; k += phy_c7) {
-			for (l = -phy_c7; l <= phy_c7; l += phy_c7) {
-				phy_c11 = phy_c15 + k;
-				phy_c12 = phy_c16 + l;
+	rx_iqcomp = lcnphy_rx_iqcomp_table_rev0;
+	rx_iqcomp_sz = ARRAY_SIZE(lcnphy_rx_iqcomp_table_rev0);
 
-				if (phy_c11 < -phy_c10)
-					phy_c11 = -phy_c10;
-				else if (phy_c11 > phy_c10)
-					phy_c11 = phy_c10;
-				if (phy_c12 < -phy_c10)
-					phy_c12 = -phy_c10;
-				else if (phy_c12 > phy_c10)
-					phy_c12 = phy_c10;
-				wlc_lcnphy_set_cc(pi, cal_type, phy_c11,
-						  phy_c12);
-				udelay(20);
-				wlc_lcnphy_samp_cap(pi, 0, 0, ptr, 2);
+	if (LCNREV_IS(pi->pubpi.phy_rev, 1))
+		wlc_lcnphy_rx_iq_cal(pi, NULL, 0, true, false, 1, 40);
+	else
+		wlc_lcnphy_rx_iq_cal(pi, NULL, 0, true, false, 1, 127);
 
-				phy_c18 = 0;
-				phy_c19 = 0;
-				for (j = 0; j < 128; j++) {
-					if (cal_type != 0)
-						phy_c6 = j % phy_c4;
-					else
-						phy_c6 = (2 * j) % phy_c4;
+	if (wlc_lcnphy_tssi_based_pwr_ctrl_enabled(pi)) {
 
-					phy_c2.re = phy_c1[phy_c6].re;
-					phy_c2.im = phy_c1[phy_c6].im;
-					phy_c17 = ptr[j];
-					phy_c18 = phy_c18 + phy_c17 * phy_c2.re;
-					phy_c19 = phy_c19 + phy_c17 * phy_c2.im;
-				}
+		wlc_lcnphy_idle_tssi_est((struct brcms_phy_pub *) pi);
+
+		b0 = pi->txpa_2g[0];
+		b1 = pi->txpa_2g[1];
+		a1 = pi->txpa_2g[2];
+		maxtargetpwr = wlc_lcnphy_tssi2dbm(10, a1, b0, b1);
+		mintargetpwr = wlc_lcnphy_tssi2dbm(125, a1, b0, b1);
+
+		tab.tbl_id = LCNPHY_TBL_ID_TXPWRCTL;
+		tab.tbl_width = 32;
+		tab.tbl_ptr = &pwr;
+		tab.tbl_len = 1;
+		tab.tbl_offset = 0;
+		for (tssi = 0; tssi < 128; tssi++) {
+			pwr = wlc_lcnphy_tssi2dbm(tssi, a1, b0, b1);
+			pwr = (pwr < mintargetpwr) ? mintargetpwr : pwr;
+			wlc_lcnphy_write_table(pi, &tab);
+			tab.tbl_offset++;
+		}
+	}
+
+	wlc_lcnphy_set_tx_pwr_by_index(pi, index);
+	wlc_lcnphy_set_tx_pwr_ctrl(pi, SAVE_pwrctrl);
+	wlc_lcnphy_deaf_mode(pi, false);
+	if (!suspend)
+		wlapi_enable_mac(pi->sh->physhim);
+}
+
+void wlc_lcnphy_calib_modes(struct brcms_phy *pi, uint mode)
+{
+	u16 temp_new;
+	int temp1, temp2, temp_diff;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+
+	switch (mode) {
+	case PHY_PERICAL_CHAN:
+		break;
+	case PHY_FULLCAL:
+		wlc_lcnphy_periodic_cal(pi);
+		break;
+	case PHY_PERICAL_PHYINIT:
+		wlc_lcnphy_periodic_cal(pi);
+		break;
+	case PHY_PERICAL_WATCHDOG:
+		if (wlc_lcnphy_tempsense_based_pwr_ctrl_enabled(pi)) {
+			temp_new = wlc_lcnphy_tempsense(pi, 0);
+			temp1 = LCNPHY_TEMPSENSE(temp_new);
+			temp2 = LCNPHY_TEMPSENSE(pi_lcn->lcnphy_cal_temper);
+			temp_diff = temp1 - temp2;
+			if ((pi_lcn->lcnphy_cal_counter > 90) ||
+			    (temp_diff > 60) || (temp_diff < -60)) {
+				wlc_lcnphy_glacial_timer_based_cal(pi);
+				wlc_2064_vco_cal(pi);
+				pi_lcn->lcnphy_cal_temper = temp_new;
+				pi_lcn->lcnphy_cal_counter = 0;
+			} else
+				pi_lcn->lcnphy_cal_counter++;
+		}
+		break;
+	case LCNPHY_PERICAL_TEMPBASED_TXPWRCTRL:
+		if (wlc_lcnphy_tempsense_based_pwr_ctrl_enabled(pi))
+			wlc_lcnphy_tx_power_adjustment(
+				(struct brcms_phy_pub *) pi);
+		break;
+	}
+}
+
+void wlc_lcnphy_get_tssi(struct brcms_phy *pi, s8 *ofdm_pwr, s8 *cck_pwr)
+{
+	s8 cck_offset;
+	u16 status;
+	status = (read_phy_reg(pi, 0x4ab));
+	if (wlc_lcnphy_tssi_based_pwr_ctrl_enabled(pi) &&
+	    (status  & (0x1 << 15))) {
+		*ofdm_pwr = (s8) (((read_phy_reg(pi, 0x4ab) & (0x1ff << 0))
+				   >> 0) >> 1);
 
-				phy_c18 = phy_c18 >> 10;
-				phy_c19 = phy_c19 >> 10;
-				phy_c20 = ((phy_c18 * phy_c18) +
-					   (phy_c19 * phy_c19));
+		if (wlc_phy_tpc_isenabled_lcnphy(pi))
+			cck_offset = pi->tx_power_offset[TXP_FIRST_CCK];
+		else
+			cck_offset = 0;
 
-				if (phy_c23 || phy_c20 < phy_c21) {
-					phy_c21 = phy_c20;
-					phy_c13 = phy_c11;
-					phy_c14 = phy_c12;
-				}
-				phy_c23 = 0;
-			}
-		}
-		phy_c23 = 1;
-		phy_c15 = phy_c13;
-		phy_c16 = phy_c14;
-		phy_c7 = phy_c7 >> 1;
-		wlc_lcnphy_set_cc(pi, cal_type, phy_c15, phy_c16);
-		udelay(20);
+		*cck_pwr = *ofdm_pwr + cck_offset;
+	} else {
+		*cck_pwr = 0;
+		*ofdm_pwr = 0;
 	}
-	goto cleanup;
-cleanup:
-	wlc_lcnphy_tx_iqlo_loopback_cleanup(pi, phy_c32);
-	wlc_lcnphy_stop_tx_tone(pi);
-	write_phy_reg(pi, 0x6da, phy_c26);
-	write_phy_reg(pi, 0x6db, phy_c27);
-	write_phy_reg(pi, 0x938, phy_c28);
-	write_phy_reg(pi, 0x4d7, phy_c29);
-	write_phy_reg(pi, 0x4d8, phy_c30);
-	write_radio_reg(pi, RADIO_2064_REG026, phy_c31);
-
-	kfree(phy_c32);
-	kfree(ptr);
 }
 
-static void
-wlc_lcnphy_tx_iqlo_loopback_cleanup(struct brcms_phy *pi, u16 *values_to_save)
+void wlc_phy_cal_init_lcnphy(struct brcms_phy *pi)
 {
-	int i;
+	return;
 
-	and_phy_reg(pi, 0x44c, 0x0 >> 11);
+}
 
-	and_phy_reg(pi, 0x43b, 0xC);
+void wlc_lcnphy_tx_power_adjustment(struct brcms_phy_pub *ppi)
+{
+	s8 index;
+	u16 index2;
+	struct brcms_phy *pi = (struct brcms_phy *) ppi;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	u16 SAVE_txpwrctrl = wlc_lcnphy_get_tx_pwr_ctrl(pi);
+	if (wlc_lcnphy_tempsense_based_pwr_ctrl_enabled(pi) &&
+	    SAVE_txpwrctrl) {
+		index = wlc_lcnphy_tempcompensated_txpwrctrl(pi);
+		index2 = (u16) (index * 2);
+		mod_phy_reg(pi, 0x4a9, (0x1ff << 0), (index2) << 0);
 
-	for (i = 0; i < 20; i++)
-		write_radio_reg(pi, iqlo_loopback_rf_regs[i],
-				values_to_save[i]);
+		pi_lcn->lcnphy_current_index =
+			(s8)((read_phy_reg(pi, 0x4a9) & 0xFF) / 2);
+	}
 }
 
 static void
@@ -4188,75 +4316,241 @@ wlc_lcnphy_load_tx_gain_table(struct brcms_phy *pi,
 	else
 		pa_gain = 0x70;
 
-	if (pi->sh->boardflags & BFL_FEM)
-		pa_gain = 0x10;
-	tab.tbl_id = LCNPHY_TBL_ID_TXPWRCTL;
-	tab.tbl_width = 32;
-	tab.tbl_len = 1;
-	tab.tbl_ptr = &val;
+	if (pi->sh->boardflags & BFL_FEM)
+		pa_gain = 0x10;
+	tab.tbl_id = LCNPHY_TBL_ID_TXPWRCTL;
+	tab.tbl_width = 32;
+	tab.tbl_len = 1;
+	tab.tbl_ptr = &val;
+
+	for (j = 0; j < 128; j++) {
+		gm_gain = gain_table[j].gm;
+		val = (((u32) pa_gain << 24) |
+		       (gain_table[j].pad << 16) |
+		       (gain_table[j].pga << 8) | gm_gain);
+
+		tab.tbl_offset = LCNPHY_TX_PWR_CTRL_GAIN_OFFSET + j;
+		wlc_lcnphy_write_table(pi, &tab);
+
+		val = (gain_table[j].dac << 28) | (gain_table[j].bb_mult << 20);
+		tab.tbl_offset = LCNPHY_TX_PWR_CTRL_IQ_OFFSET + j;
+		wlc_lcnphy_write_table(pi, &tab);
+	}
+}
+
+static void wlc_lcnphy_load_rfpower(struct brcms_phy *pi)
+{
+	struct phytbl_info tab;
+	u32 val, bbmult, rfgain;
+	u8 index;
+	u8 scale_factor = 1;
+	s16 temp, temp1, temp2, qQ, qQ1, qQ2, shift;
+
+	tab.tbl_id = LCNPHY_TBL_ID_TXPWRCTL;
+	tab.tbl_width = 32;
+	tab.tbl_len = 1;
+
+	for (index = 0; index < 128; index++) {
+		tab.tbl_ptr = &bbmult;
+		tab.tbl_offset = LCNPHY_TX_PWR_CTRL_IQ_OFFSET + index;
+		wlc_lcnphy_read_table(pi, &tab);
+		bbmult = bbmult >> 20;
+
+		tab.tbl_ptr = &rfgain;
+		tab.tbl_offset = LCNPHY_TX_PWR_CTRL_GAIN_OFFSET + index;
+		wlc_lcnphy_read_table(pi, &tab);
+
+		qm_log10((s32) (bbmult), 0, &temp1, &qQ1);
+		qm_log10((s32) (1 << 6), 0, &temp2, &qQ2);
+
+		if (qQ1 < qQ2) {
+			temp2 = qm_shr16(temp2, qQ2 - qQ1);
+			qQ = qQ1;
+		} else {
+			temp1 = qm_shr16(temp1, qQ1 - qQ2);
+			qQ = qQ2;
+		}
+		temp = qm_sub16(temp1, temp2);
+
+		if (qQ >= 4)
+			shift = qQ - 4;
+		else
+			shift = 4 - qQ;
+
+		val = (((index << shift) + (5 * temp) +
+			(1 << (scale_factor + shift - 3))) >> (scale_factor +
+							       shift - 2));
+
+		tab.tbl_ptr = &val;
+		tab.tbl_offset = LCNPHY_TX_PWR_CTRL_PWR_OFFSET + index;
+		wlc_lcnphy_write_table(pi, &tab);
+	}
+}
+
+static void wlc_lcnphy_bu_tweaks(struct brcms_phy *pi)
+{
+	or_phy_reg(pi, 0x805, 0x1);
+
+	mod_phy_reg(pi, 0x42f, (0x7 << 0), (0x3) << 0);
+
+	mod_phy_reg(pi, 0x030, (0x7 << 0), (0x3) << 0);
+
+	write_phy_reg(pi, 0x414, 0x1e10);
+	write_phy_reg(pi, 0x415, 0x0640);
+
+	mod_phy_reg(pi, 0x4df, (0xff << 8), -9 << 8);
+
+	or_phy_reg(pi, 0x44a, 0x44);
+	write_phy_reg(pi, 0x44a, 0x80);
+	mod_phy_reg(pi, 0x434, (0xff << 0), (0xFD) << 0);
+
+	mod_phy_reg(pi, 0x420, (0xff << 0), (16) << 0);
+
+	if (!(pi->sh->boardrev < 0x1204))
+		mod_radio_reg(pi, RADIO_2064_REG09B, 0xF0, 0xF0);
+
+	write_phy_reg(pi, 0x7d6, 0x0902);
+	mod_phy_reg(pi, 0x429, (0xf << 0), (0x9) << 0);
+
+	mod_phy_reg(pi, 0x429, (0x3f << 4), (0xe) << 4);
+
+	if (LCNREV_IS(pi->pubpi.phy_rev, 1)) {
+		mod_phy_reg(pi, 0x423, (0xff << 0), (0x46) << 0);
+
+		mod_phy_reg(pi, 0x411, (0xff << 0), (1) << 0);
+
+		mod_phy_reg(pi, 0x434, (0xff << 0), (0xFF) << 0);
+
+		mod_phy_reg(pi, 0x656, (0xf << 0), (2) << 0);
+
+		mod_phy_reg(pi, 0x44d, (0x1 << 2), (1) << 2);
+
+		mod_radio_reg(pi, RADIO_2064_REG0F7, 0x4, 0x4);
+		mod_radio_reg(pi, RADIO_2064_REG0F1, 0x3, 0);
+		mod_radio_reg(pi, RADIO_2064_REG0F2, 0xF8, 0x90);
+		mod_radio_reg(pi, RADIO_2064_REG0F3, 0x3, 0x2);
+		mod_radio_reg(pi, RADIO_2064_REG0F3, 0xf0, 0xa0);
+
+		mod_radio_reg(pi, RADIO_2064_REG11F, 0x2, 0x2);
+
+		wlc_lcnphy_clear_tx_power_offsets(pi);
+		mod_phy_reg(pi, 0x4d0, (0x1ff << 6), (10) << 6);
+
+	}
+}
+
+static void wlc_lcnphy_rcal(struct brcms_phy *pi)
+{
+	u8 rcal_value;
+
+	and_radio_reg(pi, RADIO_2064_REG05B, 0xfD);
+
+	or_radio_reg(pi, RADIO_2064_REG004, 0x40);
+	or_radio_reg(pi, RADIO_2064_REG120, 0x10);
+
+	or_radio_reg(pi, RADIO_2064_REG078, 0x80);
+	or_radio_reg(pi, RADIO_2064_REG129, 0x02);
+
+	or_radio_reg(pi, RADIO_2064_REG057, 0x01);
+
+	or_radio_reg(pi, RADIO_2064_REG05B, 0x02);
+	mdelay(5);
+	SPINWAIT(!wlc_radio_2064_rcal_done(pi), 10 * 1000 * 1000);
+
+	if (wlc_radio_2064_rcal_done(pi)) {
+		rcal_value = (u8) read_radio_reg(pi, RADIO_2064_REG05C);
+		rcal_value = rcal_value & 0x1f;
+	}
+
+	and_radio_reg(pi, RADIO_2064_REG05B, 0xfD);
+
+	and_radio_reg(pi, RADIO_2064_REG057, 0xFE);
+}
+
+static void wlc_lcnphy_rc_cal(struct brcms_phy *pi)
+{
+	u8 dflt_rc_cal_val;
+	u16 flt_val;
+
+	dflt_rc_cal_val = 7;
+	if (LCNREV_IS(pi->pubpi.phy_rev, 1))
+		dflt_rc_cal_val = 11;
+	flt_val =
+		(dflt_rc_cal_val << 10) | (dflt_rc_cal_val << 5) |
+		(dflt_rc_cal_val);
+	write_phy_reg(pi, 0x933, flt_val);
+	write_phy_reg(pi, 0x934, flt_val);
+	write_phy_reg(pi, 0x935, flt_val);
+	write_phy_reg(pi, 0x936, flt_val);
+	write_phy_reg(pi, 0x937, (flt_val & 0x1FF));
+
+	return;
+}
+
+static void wlc_radio_2064_init(struct brcms_phy *pi)
+{
+	u32 i;
+	struct lcnphy_radio_regs *lcnphyregs = NULL;
+
+	lcnphyregs = lcnphy_radio_regs_2064;
+
+	for (i = 0; lcnphyregs[i].address != 0xffff; i++)
+		if (CHSPEC_IS5G(pi->radio_chanspec) && lcnphyregs[i].do_init_a)
+			write_radio_reg(pi,
+					((lcnphyregs[i].address & 0x3fff) |
+					 RADIO_DEFAULT_CORE),
+					(u16) lcnphyregs[i].init_a);
+		else if (lcnphyregs[i].do_init_g)
+			write_radio_reg(pi,
+					((lcnphyregs[i].address & 0x3fff) |
+					 RADIO_DEFAULT_CORE),
+					(u16) lcnphyregs[i].init_g);
+
+	write_radio_reg(pi, RADIO_2064_REG032, 0x62);
+	write_radio_reg(pi, RADIO_2064_REG033, 0x19);
 
-	for (j = 0; j < 128; j++) {
-		gm_gain = gain_table[j].gm;
-		val = (((u32) pa_gain << 24) |
-		       (gain_table[j].pad << 16) |
-		       (gain_table[j].pga << 8) | gm_gain);
+	write_radio_reg(pi, RADIO_2064_REG090, 0x10);
 
-		tab.tbl_offset = LCNPHY_TX_PWR_CTRL_GAIN_OFFSET + j;
-		wlc_lcnphy_write_table(pi, &tab);
+	write_radio_reg(pi, RADIO_2064_REG010, 0x00);
 
-		val = (gain_table[j].dac << 28) | (gain_table[j].bb_mult << 20);
-		tab.tbl_offset = LCNPHY_TX_PWR_CTRL_IQ_OFFSET + j;
-		wlc_lcnphy_write_table(pi, &tab);
+	if (LCNREV_IS(pi->pubpi.phy_rev, 1)) {
+
+		write_radio_reg(pi, RADIO_2064_REG060, 0x7f);
+		write_radio_reg(pi, RADIO_2064_REG061, 0x72);
+		write_radio_reg(pi, RADIO_2064_REG062, 0x7f);
 	}
-}
 
-static void wlc_lcnphy_load_rfpower(struct brcms_phy *pi)
-{
-	struct phytbl_info tab;
-	u32 val, bbmult, rfgain;
-	u8 index;
-	u8 scale_factor = 1;
-	s16 temp, temp1, temp2, qQ, qQ1, qQ2, shift;
+	write_radio_reg(pi, RADIO_2064_REG01D, 0x02);
+	write_radio_reg(pi, RADIO_2064_REG01E, 0x06);
 
-	tab.tbl_id = LCNPHY_TBL_ID_TXPWRCTL;
-	tab.tbl_width = 32;
-	tab.tbl_len = 1;
+	mod_phy_reg(pi, 0x4ea, (0x7 << 0), 0 << 0);
 
-	for (index = 0; index < 128; index++) {
-		tab.tbl_ptr = &bbmult;
-		tab.tbl_offset = LCNPHY_TX_PWR_CTRL_IQ_OFFSET + index;
-		wlc_lcnphy_read_table(pi, &tab);
-		bbmult = bbmult >> 20;
+	mod_phy_reg(pi, 0x4ea, (0x7 << 3), 1 << 3);
 
-		tab.tbl_ptr = &rfgain;
-		tab.tbl_offset = LCNPHY_TX_PWR_CTRL_GAIN_OFFSET + index;
-		wlc_lcnphy_read_table(pi, &tab);
+	mod_phy_reg(pi, 0x4ea, (0x7 << 6), 2 << 6);
 
-		qm_log10((s32) (bbmult), 0, &temp1, &qQ1);
-		qm_log10((s32) (1 << 6), 0, &temp2, &qQ2);
+	mod_phy_reg(pi, 0x4ea, (0x7 << 9), 3 << 9);
 
-		if (qQ1 < qQ2) {
-			temp2 = qm_shr16(temp2, qQ2 - qQ1);
-			qQ = qQ1;
-		} else {
-			temp1 = qm_shr16(temp1, qQ1 - qQ2);
-			qQ = qQ2;
-		}
-		temp = qm_sub16(temp1, temp2);
+	mod_phy_reg(pi, 0x4ea, (0x7 << 12), 4 << 12);
 
-		if (qQ >= 4)
-			shift = qQ - 4;
-		else
-			shift = 4 - qQ;
+	write_phy_reg(pi, 0x4ea, 0x4688);
 
-		val = (((index << shift) + (5 * temp) +
-			(1 << (scale_factor + shift - 3))) >> (scale_factor +
-							       shift - 2));
+	mod_phy_reg(pi, 0x4eb, (0x7 << 0), 2 << 0);
 
-		tab.tbl_ptr = &val;
-		tab.tbl_offset = LCNPHY_TX_PWR_CTRL_PWR_OFFSET + index;
-		wlc_lcnphy_write_table(pi, &tab);
-	}
+	mod_phy_reg(pi, 0x4eb, (0x7 << 6), 0 << 6);
+
+	mod_phy_reg(pi, 0x46a, (0xffff << 0), 25 << 0);
+
+	wlc_lcnphy_set_tx_locc(pi, 0);
+
+	wlc_lcnphy_rcal(pi);
+
+	wlc_lcnphy_rc_cal(pi);
+}
+
+static void wlc_lcnphy_radio_init(struct brcms_phy *pi)
+{
+	wlc_radio_2064_init(pi);
 }
 
 static void wlc_lcnphy_tbl_init(struct brcms_phy *pi)
@@ -4460,58 +4754,6 @@ static void wlc_lcnphy_agc_temp_init(struct brcms_phy *pi)
 
 }
 
-static void wlc_lcnphy_bu_tweaks(struct brcms_phy *pi)
-{
-	or_phy_reg(pi, 0x805, 0x1);
-
-	mod_phy_reg(pi, 0x42f, (0x7 << 0), (0x3) << 0);
-
-	mod_phy_reg(pi, 0x030, (0x7 << 0), (0x3) << 0);
-
-	write_phy_reg(pi, 0x414, 0x1e10);
-	write_phy_reg(pi, 0x415, 0x0640);
-
-	mod_phy_reg(pi, 0x4df, (0xff << 8), -9 << 8);
-
-	or_phy_reg(pi, 0x44a, 0x44);
-	write_phy_reg(pi, 0x44a, 0x80);
-	mod_phy_reg(pi, 0x434, (0xff << 0), (0xFD) << 0);
-
-	mod_phy_reg(pi, 0x420, (0xff << 0), (16) << 0);
-
-	if (!(pi->sh->boardrev < 0x1204))
-		mod_radio_reg(pi, RADIO_2064_REG09B, 0xF0, 0xF0);
-
-	write_phy_reg(pi, 0x7d6, 0x0902);
-	mod_phy_reg(pi, 0x429, (0xf << 0), (0x9) << 0);
-
-	mod_phy_reg(pi, 0x429, (0x3f << 4), (0xe) << 4);
-
-	if (LCNREV_IS(pi->pubpi.phy_rev, 1)) {
-		mod_phy_reg(pi, 0x423, (0xff << 0), (0x46) << 0);
-
-		mod_phy_reg(pi, 0x411, (0xff << 0), (1) << 0);
-
-		mod_phy_reg(pi, 0x434, (0xff << 0), (0xFF) << 0);
-
-		mod_phy_reg(pi, 0x656, (0xf << 0), (2) << 0);
-
-		mod_phy_reg(pi, 0x44d, (0x1 << 2), (1) << 2);
-
-		mod_radio_reg(pi, RADIO_2064_REG0F7, 0x4, 0x4);
-		mod_radio_reg(pi, RADIO_2064_REG0F1, 0x3, 0);
-		mod_radio_reg(pi, RADIO_2064_REG0F2, 0xF8, 0x90);
-		mod_radio_reg(pi, RADIO_2064_REG0F3, 0x3, 0x2);
-		mod_radio_reg(pi, RADIO_2064_REG0F3, 0xf0, 0xa0);
-
-		mod_radio_reg(pi, RADIO_2064_REG11F, 0x2, 0x2);
-
-		wlc_lcnphy_clear_tx_power_offsets(pi);
-		mod_phy_reg(pi, 0x4d0, (0x1ff << 6), (10) << 6);
-
-	}
-}
-
 static void wlc_lcnphy_baseband_init(struct brcms_phy *pi)
 {
 
@@ -4522,118 +4764,53 @@ static void wlc_lcnphy_baseband_init(struct brcms_phy *pi)
 	wlc_lcnphy_bu_tweaks(pi);
 }
 
-static void wlc_radio_2064_init(struct brcms_phy *pi)
+void wlc_phy_init_lcnphy(struct brcms_phy *pi)
 {
-	u32 i;
-	struct lcnphy_radio_regs *lcnphyregs = NULL;
-
-	lcnphyregs = lcnphy_radio_regs_2064;
-
-	for (i = 0; lcnphyregs[i].address != 0xffff; i++)
-		if (CHSPEC_IS5G(pi->radio_chanspec) && lcnphyregs[i].do_init_a)
-			write_radio_reg(pi,
-					((lcnphyregs[i].address & 0x3fff) |
-					 RADIO_DEFAULT_CORE),
-					(u16) lcnphyregs[i].init_a);
-		else if (lcnphyregs[i].do_init_g)
-			write_radio_reg(pi,
-					((lcnphyregs[i].address & 0x3fff) |
-					 RADIO_DEFAULT_CORE),
-					(u16) lcnphyregs[i].init_g);
-
-	write_radio_reg(pi, RADIO_2064_REG032, 0x62);
-	write_radio_reg(pi, RADIO_2064_REG033, 0x19);
-
-	write_radio_reg(pi, RADIO_2064_REG090, 0x10);
-
-	write_radio_reg(pi, RADIO_2064_REG010, 0x00);
-
-	if (LCNREV_IS(pi->pubpi.phy_rev, 1)) {
-
-		write_radio_reg(pi, RADIO_2064_REG060, 0x7f);
-		write_radio_reg(pi, RADIO_2064_REG061, 0x72);
-		write_radio_reg(pi, RADIO_2064_REG062, 0x7f);
-	}
-
-	write_radio_reg(pi, RADIO_2064_REG01D, 0x02);
-	write_radio_reg(pi, RADIO_2064_REG01E, 0x06);
-
-	mod_phy_reg(pi, 0x4ea, (0x7 << 0), 0 << 0);
-
-	mod_phy_reg(pi, 0x4ea, (0x7 << 3), 1 << 3);
-
-	mod_phy_reg(pi, 0x4ea, (0x7 << 6), 2 << 6);
-
-	mod_phy_reg(pi, 0x4ea, (0x7 << 9), 3 << 9);
-
-	mod_phy_reg(pi, 0x4ea, (0x7 << 12), 4 << 12);
-
-	write_phy_reg(pi, 0x4ea, 0x4688);
-
-	mod_phy_reg(pi, 0x4eb, (0x7 << 0), 2 << 0);
-
-	mod_phy_reg(pi, 0x4eb, (0x7 << 6), 0 << 6);
-
-	mod_phy_reg(pi, 0x46a, (0xffff << 0), 25 << 0);
-
-	wlc_lcnphy_set_tx_locc(pi, 0);
-
-	wlc_lcnphy_rcal(pi);
-
-	wlc_lcnphy_rc_cal(pi);
-}
+	u8 phybw40;
+	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
+	phybw40 = CHSPEC_IS40(pi->radio_chanspec);
 
-static void wlc_lcnphy_radio_init(struct brcms_phy *pi)
-{
-	wlc_radio_2064_init(pi);
-}
+	pi_lcn->lcnphy_cal_counter = 0;
+	pi_lcn->lcnphy_cal_temper = pi_lcn->lcnphy_rawtempsense;
 
-static void wlc_lcnphy_rcal(struct brcms_phy *pi)
-{
-	u8 rcal_value;
+	or_phy_reg(pi, 0x44a, 0x80);
+	and_phy_reg(pi, 0x44a, 0x7f);
 
-	and_radio_reg(pi, RADIO_2064_REG05B, 0xfD);
+	wlc_lcnphy_afe_clk_init(pi, AFE_CLK_INIT_MODE_TXRX2X);
 
-	or_radio_reg(pi, RADIO_2064_REG004, 0x40);
-	or_radio_reg(pi, RADIO_2064_REG120, 0x10);
+	write_phy_reg(pi, 0x60a, 160);
 
-	or_radio_reg(pi, RADIO_2064_REG078, 0x80);
-	or_radio_reg(pi, RADIO_2064_REG129, 0x02);
+	write_phy_reg(pi, 0x46a, 25);
 
-	or_radio_reg(pi, RADIO_2064_REG057, 0x01);
+	wlc_lcnphy_baseband_init(pi);
 
-	or_radio_reg(pi, RADIO_2064_REG05B, 0x02);
-	mdelay(5);
-	SPINWAIT(!wlc_radio_2064_rcal_done(pi), 10 * 1000 * 1000);
+	wlc_lcnphy_radio_init(pi);
 
-	if (wlc_radio_2064_rcal_done(pi)) {
-		rcal_value = (u8) read_radio_reg(pi, RADIO_2064_REG05C);
-		rcal_value = rcal_value & 0x1f;
-	}
+	if (CHSPEC_IS2G(pi->radio_chanspec))
+		wlc_lcnphy_tx_pwr_ctrl_init((struct brcms_phy_pub *) pi);
 
-	and_radio_reg(pi, RADIO_2064_REG05B, 0xfD);
+	wlc_phy_chanspec_set((struct brcms_phy_pub *) pi, pi->radio_chanspec);
 
-	and_radio_reg(pi, RADIO_2064_REG057, 0xFE);
-}
+	si_pmu_regcontrol(pi->sh->sih, 0, 0xf, 0x9);
 
-static void wlc_lcnphy_rc_cal(struct brcms_phy *pi)
-{
-	u8 dflt_rc_cal_val;
-	u16 flt_val;
+	si_pmu_chipcontrol(pi->sh->sih, 0, 0xffffffff, 0x03CDDDDD);
 
-	dflt_rc_cal_val = 7;
-	if (LCNREV_IS(pi->pubpi.phy_rev, 1))
-		dflt_rc_cal_val = 11;
-	flt_val =
-		(dflt_rc_cal_val << 10) | (dflt_rc_cal_val << 5) |
-		(dflt_rc_cal_val);
-	write_phy_reg(pi, 0x933, flt_val);
-	write_phy_reg(pi, 0x934, flt_val);
-	write_phy_reg(pi, 0x935, flt_val);
-	write_phy_reg(pi, 0x936, flt_val);
-	write_phy_reg(pi, 0x937, (flt_val & 0x1FF));
+	if ((pi->sh->boardflags & BFL_FEM)
+	    && wlc_lcnphy_tempsense_based_pwr_ctrl_enabled(pi))
+		wlc_lcnphy_set_tx_pwr_by_index(pi, FIXED_TXPWR);
 
-	return;
+	wlc_lcnphy_agc_temp_init(pi);
+
+	wlc_lcnphy_temp_adj(pi);
+
+	mod_phy_reg(pi, 0x448, (0x1 << 14), (1) << 14);
+
+	udelay(100);
+	mod_phy_reg(pi, 0x448, (0x1 << 14), (0) << 14);
+
+	wlc_lcnphy_set_tx_pwr_ctrl(pi, LCNPHY_TX_PWR_CTRL_HW);
+	pi_lcn->lcnphy_noise_samples = LCNPHY_NOISE_SAMPLES_DEFAULT;
+	wlc_lcnphy_calib_modes(pi, PHY_PERICAL_PHYINIT);
 }
 
 static bool wlc_phy_txpwr_srom_read_lcnphy(struct brcms_phy *pi)
@@ -4772,170 +4949,6 @@ void wlc_2064_vco_cal(struct brcms_phy *pi)
 	mod_radio_reg(pi, RADIO_2064_REG057, 1 << 3, 0);
 }
 
-static void
-wlc_lcnphy_radio_2064_channel_tune_4313(struct brcms_phy *pi, u8 channel)
-{
-	uint i;
-	const struct chan_info_2064_lcnphy *ci;
-	u8 rfpll_doubler = 0;
-	u8 pll_pwrup, pll_pwrup_ovr;
-	s32 qFxtal, qFref, qFvco, qFcal;
-	u8 d15, d16, f16, e44, e45;
-	u32 div_int, div_frac, fvco3, fpfd, fref3, fcal_div;
-	u16 loop_bw, d30, setCount;
-
-	ci = &chan_info_2064_lcnphy[0];
-	rfpll_doubler = 1;
-
-	mod_radio_reg(pi, RADIO_2064_REG09D, 0x4, 0x1 << 2);
-
-	write_radio_reg(pi, RADIO_2064_REG09E, 0xf);
-	if (!rfpll_doubler) {
-		loop_bw = PLL_2064_LOOP_BW;
-		d30 = PLL_2064_D30;
-	} else {
-		loop_bw = PLL_2064_LOOP_BW_DOUBLER;
-		d30 = PLL_2064_D30_DOUBLER;
-	}
-
-	if (CHSPEC_IS2G(pi->radio_chanspec)) {
-		for (i = 0; i < ARRAY_SIZE(chan_info_2064_lcnphy); i++)
-			if (chan_info_2064_lcnphy[i].chan == channel)
-				break;
-
-		if (i >= ARRAY_SIZE(chan_info_2064_lcnphy))
-			return;
-
-		ci = &chan_info_2064_lcnphy[i];
-	}
-
-	write_radio_reg(pi, RADIO_2064_REG02A, ci->logen_buftune);
-
-	mod_radio_reg(pi, RADIO_2064_REG030, 0x3, ci->logen_rccr_tx);
-
-	mod_radio_reg(pi, RADIO_2064_REG091, 0x3, ci->txrf_mix_tune_ctrl);
-
-	mod_radio_reg(pi, RADIO_2064_REG038, 0xf, ci->pa_input_tune_g);
-
-	mod_radio_reg(pi, RADIO_2064_REG030, 0x3 << 2,
-		      (ci->logen_rccr_rx) << 2);
-
-	mod_radio_reg(pi, RADIO_2064_REG05E, 0xf, ci->pa_rxrf_lna1_freq_tune);
-
-	mod_radio_reg(pi, RADIO_2064_REG05E, (0xf) << 4,
-		      (ci->pa_rxrf_lna2_freq_tune) << 4);
-
-	write_radio_reg(pi, RADIO_2064_REG06C, ci->rxrf_rxrf_spare1);
-
-	pll_pwrup = (u8) read_radio_reg(pi, RADIO_2064_REG044);
-	pll_pwrup_ovr = (u8) read_radio_reg(pi, RADIO_2064_REG12B);
-
-	or_radio_reg(pi, RADIO_2064_REG044, 0x07);
-
-	or_radio_reg(pi, RADIO_2064_REG12B, (0x07) << 1);
-	e44 = 0;
-	e45 = 0;
-
-	fpfd = rfpll_doubler ? (pi->xtalfreq << 1) : (pi->xtalfreq);
-	if (pi->xtalfreq > 26000000)
-		e44 = 1;
-	if (pi->xtalfreq > 52000000)
-		e45 = 1;
-	if (e44 == 0)
-		fcal_div = 1;
-	else if (e45 == 0)
-		fcal_div = 2;
-	else
-		fcal_div = 4;
-	fvco3 = (ci->freq * 3);
-	fref3 = 2 * fpfd;
-
-	qFxtal = wlc_lcnphy_qdiv_roundup(pi->xtalfreq, PLL_2064_MHZ, 16);
-	qFref = wlc_lcnphy_qdiv_roundup(fpfd, PLL_2064_MHZ, 16);
-	qFcal = pi->xtalfreq * fcal_div / PLL_2064_MHZ;
-	qFvco = wlc_lcnphy_qdiv_roundup(fvco3, 2, 16);
-
-	write_radio_reg(pi, RADIO_2064_REG04F, 0x02);
-
-	d15 = (pi->xtalfreq * fcal_div * 4 / 5) / PLL_2064_MHZ - 1;
-	write_radio_reg(pi, RADIO_2064_REG052, (0x07 & (d15 >> 2)));
-	write_radio_reg(pi, RADIO_2064_REG053, (d15 & 0x3) << 5);
-
-	d16 = (qFcal * 8 / (d15 + 1)) - 1;
-	write_radio_reg(pi, RADIO_2064_REG051, d16);
-
-	f16 = ((d16 + 1) * (d15 + 1)) / qFcal;
-	setCount = f16 * 3 * (ci->freq) / 32 - 1;
-	mod_radio_reg(pi, RADIO_2064_REG053, (0x0f << 0),
-		      (u8) (setCount >> 8));
-
-	or_radio_reg(pi, RADIO_2064_REG053, 0x10);
-	write_radio_reg(pi, RADIO_2064_REG054, (u8) (setCount & 0xff));
-
-	div_int = ((fvco3 * (PLL_2064_MHZ >> 4)) / fref3) << 4;
-
-	div_frac = ((fvco3 * (PLL_2064_MHZ >> 4)) % fref3) << 4;
-	while (div_frac >= fref3) {
-		div_int++;
-		div_frac -= fref3;
-	}
-	div_frac = wlc_lcnphy_qdiv_roundup(div_frac, fref3, 20);
-
-	mod_radio_reg(pi, RADIO_2064_REG045, (0x1f << 0),
-		      (u8) (div_int >> 4));
-	mod_radio_reg(pi, RADIO_2064_REG046, (0x1f << 4),
-		      (u8) (div_int << 4));
-	mod_radio_reg(pi, RADIO_2064_REG046, (0x0f << 0),
-		      (u8) (div_frac >> 16));
-	write_radio_reg(pi, RADIO_2064_REG047, (u8) (div_frac >> 8) & 0xff);
-	write_radio_reg(pi, RADIO_2064_REG048, (u8) div_frac & 0xff);
-
-	write_radio_reg(pi, RADIO_2064_REG040, 0xfb);
-
-	write_radio_reg(pi, RADIO_2064_REG041, 0x9A);
-	write_radio_reg(pi, RADIO_2064_REG042, 0xA3);
-	write_radio_reg(pi, RADIO_2064_REG043, 0x0C);
-
-	{
-		u8 h29, h23, c28, d29, h28_ten, e30, h30_ten, cp_current;
-		u16 c29, c38, c30, g30, d28;
-		c29 = loop_bw;
-		d29 = 200;
-		c38 = 1250;
-		h29 = d29 / c29;
-		h23 = 1;
-		c28 = 30;
-		d28 = (((PLL_2064_HIGH_END_KVCO - PLL_2064_LOW_END_KVCO) *
-			(fvco3 / 2 - PLL_2064_LOW_END_VCO)) /
-		       (PLL_2064_HIGH_END_VCO - PLL_2064_LOW_END_VCO))
-		      + PLL_2064_LOW_END_KVCO;
-		h28_ten = (d28 * 10) / c28;
-		c30 = 2640;
-		e30 = (d30 - 680) / 490;
-		g30 = 680 + (e30 * 490);
-		h30_ten = (g30 * 10) / c30;
-		cp_current = ((c38 * h29 * h23 * 100) / h28_ten) / h30_ten;
-		mod_radio_reg(pi, RADIO_2064_REG03C, 0x3f, cp_current);
-	}
-	if (channel >= 1 && channel <= 5)
-		write_radio_reg(pi, RADIO_2064_REG03C, 0x8);
-	else
-		write_radio_reg(pi, RADIO_2064_REG03C, 0x7);
-	write_radio_reg(pi, RADIO_2064_REG03D, 0x3);
-
-	mod_radio_reg(pi, RADIO_2064_REG044, 0x0c, 0x0c);
-	udelay(1);
-
-	wlc_2064_vco_cal(pi);
-
-	write_radio_reg(pi, RADIO_2064_REG044, pll_pwrup);
-	write_radio_reg(pi, RADIO_2064_REG12B, pll_pwrup_ovr);
-	if (LCNREV_IS(pi->pubpi.phy_rev, 1)) {
-		write_radio_reg(pi, RADIO_2064_REG038, 3);
-		write_radio_reg(pi, RADIO_2064_REG091, 7);
-	}
-}
-
 bool wlc_phy_tpc_isenabled_lcnphy(struct brcms_phy *pi)
 {
 	if (wlc_lcnphy_tempsense_based_pwr_ctrl_enabled(pi))
@@ -5148,80 +5161,3 @@ s32 wlc_lcnphy_rx_signal_power(struct brcms_phy *pi, s32 gain_index)
 
 	return input_power_db;
 }
-
-static int
-wlc_lcnphy_load_tx_iir_filter(struct brcms_phy *pi, bool is_ofdm, s16 filt_type)
-{
-	s16 filt_index = -1;
-	int j;
-
-	u16 addr[] = {
-		0x910,
-		0x91e,
-		0x91f,
-		0x924,
-		0x925,
-		0x926,
-		0x920,
-		0x921,
-		0x927,
-		0x928,
-		0x929,
-		0x922,
-		0x923,
-		0x930,
-		0x931,
-		0x932
-	};
-
-	u16 addr_ofdm[] = {
-		0x90f,
-		0x900,
-		0x901,
-		0x906,
-		0x907,
-		0x908,
-		0x902,
-		0x903,
-		0x909,
-		0x90a,
-		0x90b,
-		0x904,
-		0x905,
-		0x90c,
-		0x90d,
-		0x90e
-	};
-
-	if (!is_ofdm) {
-		for (j = 0; j < LCNPHY_NUM_TX_DIG_FILTERS_CCK; j++) {
-			if (filt_type == LCNPHY_txdigfiltcoeffs_cck[j][0]) {
-				filt_index = (s16) j;
-				break;
-			}
-		}
-
-		if (filt_index != -1) {
-			for (j = 0; j < LCNPHY_NUM_DIG_FILT_COEFFS; j++)
-				write_phy_reg(pi, addr[j],
-					      LCNPHY_txdigfiltcoeffs_cck
-					      [filt_index][j + 1]);
-		}
-	} else {
-		for (j = 0; j < LCNPHY_NUM_TX_DIG_FILTERS_OFDM; j++) {
-			if (filt_type == LCNPHY_txdigfiltcoeffs_ofdm[j][0]) {
-				filt_index = (s16) j;
-				break;
-			}
-		}
-
-		if (filt_index != -1) {
-			for (j = 0; j < LCNPHY_NUM_DIG_FILT_COEFFS; j++)
-				write_phy_reg(pi, addr_ofdm[j],
-					      LCNPHY_txdigfiltcoeffs_ofdm
-					      [filt_index][j + 1]);
-		}
-	}
-
-	return (filt_index != -1) ? 0 : -1;
-}
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
index c5b7ad4..cdf6185 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
@@ -159,6 +159,22 @@
 #define CCTRL5357_EXTPA            (1<<14) /* extPA in ChipControl 1, bit 14 */
 #define CCTRL5357_ANT_MUX_2o3      (1<<15) /* 2o3 in ChipControl 1, bit 15 */
 
+#define NPHY_CAL_TSSISAMPS      64
+#define NPHY_TEST_TONE_FREQ_40MHz 4000
+#define NPHY_TEST_TONE_FREQ_20MHz 2500
+
+#define MAX_205x_RCAL_WAITLOOPS 10000
+
+#define NPHY_RXCAL_TONEAMP 181
+#define NPHY_RXCAL_TONEFREQ_40MHz 4000
+#define NPHY_RXCAL_TONEFREQ_20MHz 2000
+
+#define TXFILT_SHAPING_OFDM20   0
+#define TXFILT_SHAPING_OFDM40   1
+#define TXFILT_SHAPING_CCK      2
+#define TXFILT_DEFAULT_OFDM20   3
+#define TXFILT_DEFAULT_OFDM40   4
+
 struct nphy_iqcal_params {
 	u16 txlpf;
 	u16 txgm;
@@ -238,10 +254,6 @@ struct nphy_ipa_txrxgain nphy_ipa_rxcal_gaintbl_2GHz_rev7[] = {
 	{0, 0, 6, 3, 0, 10}
 };
 
-#define NPHY_RXCAL_TONEAMP 181
-#define NPHY_RXCAL_TONEFREQ_40MHz 4000
-#define NPHY_RXCAL_TONEFREQ_20MHz 2000
-
 enum {
 	NPHY_RXCAL_GAIN_INIT = 0,
 	NPHY_RXCAL_GAIN_UP,
@@ -254,12 +266,6 @@ enum {
 	  (0x1 << 14) |	\
 	  (0x1 << 13)))
 
-#define TXFILT_SHAPING_OFDM20   0
-#define TXFILT_SHAPING_OFDM40   1
-#define TXFILT_SHAPING_CCK      2
-#define TXFILT_DEFAULT_OFDM20   3
-#define TXFILT_DEFAULT_OFDM40   4
-
 u16 NPHY_IPA_REV4_txdigi_filtcoeffs[][NPHY_NUM_DIG_FILT_COEFFS] = {
 	{-377, 137, -407, 208, -1527, 956, 93, 186, 93,
 	 230, -44, 230, 201, -191, 201},
@@ -14107,120 +14113,6 @@ static u8 ant_sw_ctrl_tbl_rev8_2057v7_core1[] = {
 	0x09, 0x0a, 0x09, 0x0a, 0x15, 0x16
 };
 
-static bool wlc_phy_chan2freq_nphy(struct brcms_phy *pi, uint channel, int *f,
-				   struct chan_info_nphy_radio2057 **t0,
-				   struct chan_info_nphy_radio205x **t1,
-				   struct chan_info_nphy_radio2057_rev5 **t2,
-				   struct chan_info_nphy_2055 **t3);
-static void wlc_phy_chanspec_nphy_setup(struct brcms_phy *pi, u16 chans,
-					const struct nphy_sfo_cfg *c);
-
-static void wlc_phy_adjust_rx_analpfbw_nphy(struct brcms_phy *pi,
-					    u16 reduction_factr);
-static void wlc_phy_adjust_min_noisevar_nphy(struct brcms_phy *pi,
-					     int ntones, int *, u32 *buf);
-static void wlc_phy_adjust_crsminpwr_nphy(struct brcms_phy *pi, u8 minpwr);
-static void wlc_phy_txlpfbw_nphy(struct brcms_phy *pi);
-static void wlc_phy_spurwar_nphy(struct brcms_phy *pi);
-
-static void wlc_phy_radio_preinit_2055(struct brcms_phy *pi);
-static void wlc_phy_radio_init_2055(struct brcms_phy *pi);
-static void wlc_phy_radio_postinit_2055(struct brcms_phy *pi);
-static void wlc_phy_radio_preinit_205x(struct brcms_phy *pi);
-static void wlc_phy_radio_init_2056(struct brcms_phy *pi);
-static void wlc_phy_radio_postinit_2056(struct brcms_phy *pi);
-static void wlc_phy_radio_init_2057(struct brcms_phy *pi);
-static void wlc_phy_radio_postinit_2057(struct brcms_phy *pi);
-static void wlc_phy_workarounds_nphy(struct brcms_phy *pi);
-static void wlc_phy_workarounds_nphy_gainctrl(struct brcms_phy *pi);
-static void wlc_phy_workarounds_nphy_gainctrl_2057_rev5(struct brcms_phy *pi);
-static void wlc_phy_workarounds_nphy_gainctrl_2057_rev6(struct brcms_phy *pi);
-static void wlc_phy_adjust_lnagaintbl_nphy(struct brcms_phy *pi);
-
-static void wlc_phy_restore_rssical_nphy(struct brcms_phy *pi);
-static void wlc_phy_reapply_txcal_coeffs_nphy(struct brcms_phy *pi);
-static void wlc_phy_tx_iq_war_nphy(struct brcms_phy *pi);
-static int wlc_phy_cal_rxiq_nphy_rev3(struct brcms_phy *pi,
-				      struct nphy_txgains tg, u8 type, bool d);
-static void wlc_phy_rxcal_gainctrl_nphy_rev5(struct brcms_phy *pi, u8 rxcore,
-					     u16 *rg, u8 type);
-static void wlc_phy_update_mimoconfig_nphy(struct brcms_phy *pi, s32 preamble);
-static void wlc_phy_savecal_nphy(struct brcms_phy *pi);
-static void wlc_phy_restorecal_nphy(struct brcms_phy *pi);
-static void wlc_phy_resetcca_nphy(struct brcms_phy *pi);
-
-static void wlc_phy_txpwrctrl_config_nphy(struct brcms_phy *pi);
-static void wlc_phy_internal_cal_txgain_nphy(struct brcms_phy *pi);
-static void wlc_phy_precal_txgain_nphy(struct brcms_phy *pi);
-static void wlc_phy_update_txcal_ladder_nphy(struct brcms_phy *pi, u16 core);
-
-static void wlc_phy_extpa_set_tx_digi_filts_nphy(struct brcms_phy *pi);
-static void wlc_phy_ipa_set_tx_digi_filts_nphy(struct brcms_phy *pi);
-static void wlc_phy_ipa_restore_tx_digi_filts_nphy(struct brcms_phy *pi);
-static u16 wlc_phy_ipa_get_bbmult_nphy(struct brcms_phy *pi);
-static void wlc_phy_ipa_set_bbmult_nphy(struct brcms_phy *pi, u8 m0, u8 m1);
-static u32 *wlc_phy_get_ipa_gaintbl_nphy(struct brcms_phy *pi);
-
-static void wlc_phy_a1_nphy(struct brcms_phy *pi, u8 core, u32 winsz, u32,
-			    u32 e);
-static u8 wlc_phy_a3_nphy(struct brcms_phy *pi, u8 start_gain, u8 core);
-static void wlc_phy_a2_nphy(struct brcms_phy *pi, struct nphy_ipa_txcalgains *,
-			    enum phy_cal_mode, u8);
-
-static void
-wlc_phy_papd_cal_cleanup_nphy(struct brcms_phy *pi,
-			      struct nphy_papd_restore_state *state);
-
-static void wlc_phy_papd_cal_setup_nphy(struct brcms_phy *pi,
-					struct nphy_papd_restore_state *state,
-					u8);
-
-static void wlc_phy_clip_det_nphy(struct brcms_phy *pi, u8 write, u16 *vals);
-
-static void wlc_phy_set_rfseq_nphy(struct brcms_phy *pi, u8 cmd, u8 *evts,
-				   u8 *dlys, u8 len);
-
-static u16 wlc_phy_read_lpf_bw_ctl_nphy(struct brcms_phy *pi, u16 offset);
-
-static void
-wlc_phy_rfctrl_override_nphy_rev7(struct brcms_phy *pi, u16 field, u16 value,
-				  u8 core_mask, u8 off,
-				  u8 override_id);
-
-static void wlc_phy_rssi_cal_nphy_rev2(struct brcms_phy *pi, u8 rssi_type);
-static void wlc_phy_rssi_cal_nphy_rev3(struct brcms_phy *pi);
-
-static bool wlc_phy_txpwr_srom_read_nphy(struct brcms_phy *pi);
-static void wlc_phy_txpwr_nphy_srom_convert(u8 *srom_max,
-					    u16 *pwr_offset,
-					    u8 tmp_max_pwr, u8 rate_start,
-					    u8 rate_end);
-
-static void wlc_phy_txpwr_limit_to_tbl_nphy(struct brcms_phy *pi);
-static void wlc_phy_txpwrctrl_coeff_setup_nphy(struct brcms_phy *pi);
-static void wlc_phy_txpwrctrl_idle_tssi_nphy(struct brcms_phy *pi);
-static void wlc_phy_txpwrctrl_pwr_setup_nphy(struct brcms_phy *pi);
-
-static bool wlc_phy_txpwr_ison_nphy(struct brcms_phy *pi);
-static u8 wlc_phy_txpwr_idx_cur_get_nphy(struct brcms_phy *pi, u8 core);
-static void wlc_phy_txpwr_idx_cur_set_nphy(struct brcms_phy *pi, u8 idx0,
-					   u8 idx1);
-static void wlc_phy_a4(struct brcms_phy *pi, bool full_cal);
-
-static u16 wlc_phy_radio205x_rcal(struct brcms_phy *pi);
-
-static u16 wlc_phy_radio2057_rccal(struct brcms_phy *pi);
-
-static u16 wlc_phy_gen_load_samples_nphy(struct brcms_phy *pi, u32 f_kHz,
-					 u16 max_val,
-					 u8 dac_test_mode);
-static void wlc_phy_loadsampletable_nphy(struct brcms_phy *pi,
-					 struct cordic_iq *tone_buf,
-					 u16 num_samps);
-static void wlc_phy_runsamples_nphy(struct brcms_phy *pi, u16 n, u16 lps,
-				    u16 wait, u8 iq, u8 dac_test_mode,
-				    bool modify_bbmult);
-
 bool wlc_phy_bist_check_phy(struct brcms_phy_pub *pih)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
@@ -14464,58 +14356,6 @@ void wlc_phy_nphy_tkip_rifs_war(struct brcms_phy *pi, u8 rifs)
 		pi->sh->_rifs_phy = rifs;
 }
 
-bool wlc_phy_attach_nphy(struct brcms_phy *pi)
-{
-	uint i;
-
-	if (NREV_GE(pi->pubpi.phy_rev, 3) && NREV_LT(pi->pubpi.phy_rev, 6))
-		pi->phyhang_avoid = true;
-
-	if (NREV_GE(pi->pubpi.phy_rev, 3) && NREV_LT(pi->pubpi.phy_rev, 7)) {
-		pi->nphy_gband_spurwar_en = true;
-		if (pi->sh->boardflags2 & BFL2_SPUR_WAR)
-			pi->nphy_aband_spurwar_en = true;
-	}
-	if (NREV_GE(pi->pubpi.phy_rev, 6) && NREV_LT(pi->pubpi.phy_rev, 7)) {
-		if (pi->sh->boardflags2 & BFL2_2G_SPUR_WAR)
-			pi->nphy_gband_spurwar2_en = true;
-	}
-
-	pi->n_preamble_override = AUTO;
-	if (NREV_IS(pi->pubpi.phy_rev, 3) || NREV_IS(pi->pubpi.phy_rev, 4))
-		pi->n_preamble_override = BRCMS_N_PREAMBLE_MIXEDMODE;
-
-	pi->nphy_txrx_chain = AUTO;
-	pi->phy_scraminit = AUTO;
-
-	pi->nphy_rxcalparams = 0x010100B5;
-
-	pi->nphy_perical = PHY_PERICAL_MPHASE;
-	pi->mphase_cal_phase_id = MPHASE_CAL_STATE_IDLE;
-	pi->mphase_txcal_numcmds = MPHASE_TXCAL_NUMCMDS;
-
-	pi->nphy_gain_boost = true;
-	pi->nphy_elna_gain_config = false;
-	pi->radio_is_on = false;
-
-	for (i = 0; i < pi->pubpi.phy_corenum; i++)
-		pi->nphy_txpwrindex[i].index = AUTO;
-
-	wlc_phy_txpwrctrl_config_nphy(pi);
-	if (pi->nphy_txpwrctrl == PHY_TPC_HW_ON)
-		pi->hwpwrctrl_capable = true;
-
-	pi->pi_fptr.init = wlc_phy_init_nphy;
-	pi->pi_fptr.calinit = wlc_phy_cal_init_nphy;
-	pi->pi_fptr.chanset = wlc_phy_chanspec_set_nphy;
-	pi->pi_fptr.txpwrrecalc = wlc_phy_txpower_recalc_target_nphy;
-
-	if (!wlc_phy_txpwr_srom_read_nphy(pi))
-		return false;
-
-	return true;
-}
-
 static void wlc_phy_txpwrctrl_config_nphy(struct brcms_phy *pi)
 {
 
@@ -14536,398 +14376,355 @@ static void wlc_phy_txpwrctrl_config_nphy(struct brcms_phy *pi)
 		pi->phy_5g_pwrgain = true;
 }
 
-static s32 get_rf_pwr_offset(struct brcms_phy *pi, s16 pga_gn, s16 pad_gn)
+static void wlc_phy_txpwr_srom_read_ppr_nphy(struct brcms_phy *pi)
 {
-	s32 rfpwr_offset = 0;
+	u16 bw40po, cddpo, stbcpo, bwduppo;
+	uint band_num;
 
-	if (CHSPEC_IS2G(pi->radio_chanspec)) {
-		if ((pi->pubpi.radiorev == 3) ||
-		    (pi->pubpi.radiorev == 4) ||
-		    (pi->pubpi.radiorev == 6))
-			rfpwr_offset = (s16)
-				       nphy_papd_padgain_dlt_2g_2057rev3n4
-				       [pad_gn];
-		else if (pi->pubpi.radiorev == 5)
-			rfpwr_offset = (s16)
-				       nphy_papd_padgain_dlt_2g_2057rev5
-				       [pad_gn];
-		else if ((pi->pubpi.radiorev == 7)
-			 || (pi->pubpi.radiorev ==
-			     8))
-			rfpwr_offset = (s16)
-				       nphy_papd_padgain_dlt_2g_2057rev7
-				       [pad_gn];
-	} else {
-		if ((pi->pubpi.radiorev == 3) ||
-		    (pi->pubpi.radiorev == 4) ||
-		    (pi->pubpi.radiorev == 6))
-			rfpwr_offset = (s16)
-				       nphy_papd_pgagain_dlt_5g_2057
-				       [pga_gn];
-		else if ((pi->pubpi.radiorev == 7)
-			 || (pi->pubpi.radiorev ==
-			     8))
-			rfpwr_offset = (s16)
-				       nphy_papd_pgagain_dlt_5g_2057rev7
-				       [pga_gn];
-	}
-	return rfpwr_offset;
-}
+	if (pi->sh->sromrev >= 9)
+		return;
 
-void wlc_phy_init_nphy(struct brcms_phy *pi)
-{
-	u16 val;
-	u16 clip1_ths[2];
-	struct nphy_txgains target_gain;
-	u8 tx_pwr_ctrl_state;
-	bool do_nphy_cal = false;
-	uint core;
-	uint origidx, intr_val;
-	struct d11regs *regs;
-	u32 d11_clk_ctl_st;
-	bool do_rssi_cal = false;
+	bw40po = (u16) PHY_GETINTVAR(pi, "bw40po");
+	pi->bw402gpo = bw40po & 0xf;
+	pi->bw405gpo = (bw40po & 0xf0) >> 4;
+	pi->bw405glpo = (bw40po & 0xf00) >> 8;
+	pi->bw405ghpo = (bw40po & 0xf000) >> 12;
 
-	core = 0;
+	cddpo = (u16) PHY_GETINTVAR(pi, "cddpo");
+	pi->cdd2gpo = cddpo & 0xf;
+	pi->cdd5gpo = (cddpo & 0xf0) >> 4;
+	pi->cdd5glpo = (cddpo & 0xf00) >> 8;
+	pi->cdd5ghpo = (cddpo & 0xf000) >> 12;
 
-	if (!(pi->measure_hold & PHY_HOLD_FOR_SCAN))
-		pi->measure_hold |= PHY_HOLD_FOR_NOT_ASSOC;
+	stbcpo = (u16) PHY_GETINTVAR(pi, "stbcpo");
+	pi->stbc2gpo = stbcpo & 0xf;
+	pi->stbc5gpo = (stbcpo & 0xf0) >> 4;
+	pi->stbc5glpo = (stbcpo & 0xf00) >> 8;
+	pi->stbc5ghpo = (stbcpo & 0xf000) >> 12;
 
-	if ((ISNPHY(pi)) && (NREV_GE(pi->pubpi.phy_rev, 5)) &&
-	    ((pi->sh->chippkg == BCM4717_PKG_ID) ||
-	     (pi->sh->chippkg == BCM4718_PKG_ID))) {
-		if ((pi->sh->boardflags & BFL_EXTLNA) &&
-		    (CHSPEC_IS2G(pi->radio_chanspec)))
-			ai_corereg(pi->sh->sih, SI_CC_IDX,
-				   offsetof(struct chipcregs, chipcontrol),
-				   0x40, 0x40);
-	}
+	bwduppo = (u16) PHY_GETINTVAR(pi, "bwduppo");
+	pi->bwdup2gpo = bwduppo & 0xf;
+	pi->bwdup5gpo = (bwduppo & 0xf0) >> 4;
+	pi->bwdup5glpo = (bwduppo & 0xf00) >> 8;
+	pi->bwdup5ghpo = (bwduppo & 0xf000) >> 12;
 
-	if ((pi->nphy_gband_spurwar2_en) && CHSPEC_IS2G(pi->radio_chanspec) &&
-	    CHSPEC_IS40(pi->radio_chanspec)) {
+	for (band_num = 0; band_num < (CH_2G_GROUP + CH_5G_GROUP);
+	     band_num++) {
+		switch (band_num) {
+		case 0:
 
-		regs = (struct d11regs *) ai_switch_core(pi->sh->sih,
-							 D11_CORE_ID, &origidx,
-							 &intr_val);
-		d11_clk_ctl_st = R_REG(&regs->clk_ctl_st);
-		AND_REG(&regs->clk_ctl_st,
-			~(CCS_FORCEHT | CCS_HTAREQ));
+			pi->nphy_txpid2g[PHY_CORE_0] =
+				(u8) PHY_GETINTVAR(pi, "txpid2ga0");
+			pi->nphy_txpid2g[PHY_CORE_1] =
+				(u8) PHY_GETINTVAR(pi, "txpid2ga1");
+			pi->nphy_pwrctrl_info[PHY_CORE_0].max_pwr_2g =
+				(s8) PHY_GETINTVAR(pi, "maxp2ga0");
+			pi->nphy_pwrctrl_info[PHY_CORE_1].max_pwr_2g =
+				(s8) PHY_GETINTVAR(pi, "maxp2ga1");
+			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_2g_a1 =
+				(s16) PHY_GETINTVAR(pi, "pa2gw0a0");
+			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_2g_a1 =
+				(s16) PHY_GETINTVAR(pi, "pa2gw0a1");
+			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_2g_b0 =
+				(s16) PHY_GETINTVAR(pi, "pa2gw1a0");
+			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_2g_b0 =
+				(s16) PHY_GETINTVAR(pi, "pa2gw1a1");
+			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_2g_b1 =
+				(s16) PHY_GETINTVAR(pi, "pa2gw2a0");
+			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_2g_b1 =
+				(s16) PHY_GETINTVAR(pi, "pa2gw2a1");
+			pi->nphy_pwrctrl_info[PHY_CORE_0].idle_targ_2g =
+				(s8) PHY_GETINTVAR(pi, "itt2ga0");
+			pi->nphy_pwrctrl_info[PHY_CORE_1].idle_targ_2g =
+				(s8) PHY_GETINTVAR(pi, "itt2ga1");
 
-		W_REG(&regs->clk_ctl_st, d11_clk_ctl_st);
+			pi->cck2gpo = (u16) PHY_GETINTVAR(pi, "cck2gpo");
 
-		ai_restore_core(pi->sh->sih, origidx, intr_val);
-	}
+			pi->ofdm2gpo = (u32) PHY_GETINTVAR(pi, "ofdm2gpo");
 
-	pi->use_int_tx_iqlo_cal_nphy =
-		(PHY_IPA(pi) ||
-		 (NREV_GE(pi->pubpi.phy_rev, 7) ||
-		  (NREV_GE(pi->pubpi.phy_rev, 5)
-		   && pi->sh->boardflags2 & BFL2_INTERNDET_TXIQCAL)));
+			pi->mcs2gpo[0] = (u16) PHY_GETINTVAR(pi, "mcs2gpo0");
+			pi->mcs2gpo[1] = (u16) PHY_GETINTVAR(pi, "mcs2gpo1");
+			pi->mcs2gpo[2] = (u16) PHY_GETINTVAR(pi, "mcs2gpo2");
+			pi->mcs2gpo[3] = (u16) PHY_GETINTVAR(pi, "mcs2gpo3");
+			pi->mcs2gpo[4] = (u16) PHY_GETINTVAR(pi, "mcs2gpo4");
+			pi->mcs2gpo[5] = (u16) PHY_GETINTVAR(pi, "mcs2gpo5");
+			pi->mcs2gpo[6] = (u16) PHY_GETINTVAR(pi, "mcs2gpo6");
+			pi->mcs2gpo[7] = (u16) PHY_GETINTVAR(pi, "mcs2gpo7");
+			break;
+		case 1:
 
-	pi->internal_tx_iqlo_cal_tapoff_intpa_nphy = false;
+			pi->nphy_txpid5g[PHY_CORE_0] =
+				(u8) PHY_GETINTVAR(pi, "txpid5ga0");
+			pi->nphy_txpid5g[PHY_CORE_1] =
+				(u8) PHY_GETINTVAR(pi, "txpid5ga1");
+			pi->nphy_pwrctrl_info[PHY_CORE_0].max_pwr_5gm =
+				(s8) PHY_GETINTVAR(pi, "maxp5ga0");
+			pi->nphy_pwrctrl_info[PHY_CORE_1].max_pwr_5gm =
+				(s8) PHY_GETINTVAR(pi, "maxp5ga1");
+			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_5gm_a1 =
+				(s16) PHY_GETINTVAR(pi, "pa5gw0a0");
+			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_5gm_a1 =
+				(s16) PHY_GETINTVAR(pi, "pa5gw0a1");
+			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_5gm_b0 =
+				(s16) PHY_GETINTVAR(pi, "pa5gw1a0");
+			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_5gm_b0 =
+				(s16) PHY_GETINTVAR(pi, "pa5gw1a1");
+			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_5gm_b1 =
+				(s16) PHY_GETINTVAR(pi, "pa5gw2a0");
+			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_5gm_b1 =
+				(s16) PHY_GETINTVAR(pi, "pa5gw2a1");
+			pi->nphy_pwrctrl_info[PHY_CORE_0].idle_targ_5gm =
+				(s8) PHY_GETINTVAR(pi, "itt5ga0");
+			pi->nphy_pwrctrl_info[PHY_CORE_1].idle_targ_5gm =
+				(s8) PHY_GETINTVAR(pi, "itt5ga1");
 
-	pi->nphy_deaf_count = 0;
+			pi->ofdm5gpo = (u32) PHY_GETINTVAR(pi, "ofdm5gpo");
 
-	wlc_phy_tbl_init_nphy(pi);
+			pi->mcs5gpo[0] = (u16) PHY_GETINTVAR(pi, "mcs5gpo0");
+			pi->mcs5gpo[1] = (u16) PHY_GETINTVAR(pi, "mcs5gpo1");
+			pi->mcs5gpo[2] = (u16) PHY_GETINTVAR(pi, "mcs5gpo2");
+			pi->mcs5gpo[3] = (u16) PHY_GETINTVAR(pi, "mcs5gpo3");
+			pi->mcs5gpo[4] = (u16) PHY_GETINTVAR(pi, "mcs5gpo4");
+			pi->mcs5gpo[5] = (u16) PHY_GETINTVAR(pi, "mcs5gpo5");
+			pi->mcs5gpo[6] = (u16) PHY_GETINTVAR(pi, "mcs5gpo6");
+			pi->mcs5gpo[7] = (u16) PHY_GETINTVAR(pi, "mcs5gpo7");
+			break;
+		case 2:
 
-	pi->nphy_crsminpwr_adjusted = false;
-	pi->nphy_noisevars_adjusted = false;
+			pi->nphy_txpid5gl[0] =
+				(u8) PHY_GETINTVAR(pi, "txpid5gla0");
+			pi->nphy_txpid5gl[1] =
+				(u8) PHY_GETINTVAR(pi, "txpid5gla1");
+			pi->nphy_pwrctrl_info[0].max_pwr_5gl =
+				(s8) PHY_GETINTVAR(pi, "maxp5gla0");
+			pi->nphy_pwrctrl_info[1].max_pwr_5gl =
+				(s8) PHY_GETINTVAR(pi, "maxp5gla1");
+			pi->nphy_pwrctrl_info[0].pwrdet_5gl_a1 =
+				(s16) PHY_GETINTVAR(pi, "pa5glw0a0");
+			pi->nphy_pwrctrl_info[1].pwrdet_5gl_a1 =
+				(s16) PHY_GETINTVAR(pi, "pa5glw0a1");
+			pi->nphy_pwrctrl_info[0].pwrdet_5gl_b0 =
+				(s16) PHY_GETINTVAR(pi, "pa5glw1a0");
+			pi->nphy_pwrctrl_info[1].pwrdet_5gl_b0 =
+				(s16) PHY_GETINTVAR(pi, "pa5glw1a1");
+			pi->nphy_pwrctrl_info[0].pwrdet_5gl_b1 =
+				(s16) PHY_GETINTVAR(pi, "pa5glw2a0");
+			pi->nphy_pwrctrl_info[1].pwrdet_5gl_b1 =
+				(s16) PHY_GETINTVAR(pi, "pa5glw2a1");
+			pi->nphy_pwrctrl_info[0].idle_targ_5gl = 0;
+			pi->nphy_pwrctrl_info[1].idle_targ_5gl = 0;
 
-	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-		write_phy_reg(pi, 0xe7, 0);
-		write_phy_reg(pi, 0xec, 0);
-		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-			write_phy_reg(pi, 0x342, 0);
-			write_phy_reg(pi, 0x343, 0);
-			write_phy_reg(pi, 0x346, 0);
-			write_phy_reg(pi, 0x347, 0);
-		}
-		write_phy_reg(pi, 0xe5, 0);
-		write_phy_reg(pi, 0xe6, 0);
-	} else {
-		write_phy_reg(pi, 0xec, 0);
-	}
+			pi->ofdm5glpo = (u32) PHY_GETINTVAR(pi, "ofdm5glpo");
 
-	write_phy_reg(pi, 0x91, 0);
-	write_phy_reg(pi, 0x92, 0);
-	if (NREV_LT(pi->pubpi.phy_rev, 6)) {
-		write_phy_reg(pi, 0x93, 0);
-		write_phy_reg(pi, 0x94, 0);
-	}
+			pi->mcs5glpo[0] =
+				(u16) PHY_GETINTVAR(pi, "mcs5glpo0");
+			pi->mcs5glpo[1] =
+				(u16) PHY_GETINTVAR(pi, "mcs5glpo1");
+			pi->mcs5glpo[2] =
+				(u16) PHY_GETINTVAR(pi, "mcs5glpo2");
+			pi->mcs5glpo[3] =
+				(u16) PHY_GETINTVAR(pi, "mcs5glpo3");
+			pi->mcs5glpo[4] =
+				(u16) PHY_GETINTVAR(pi, "mcs5glpo4");
+			pi->mcs5glpo[5] =
+				(u16) PHY_GETINTVAR(pi, "mcs5glpo5");
+			pi->mcs5glpo[6] =
+				(u16) PHY_GETINTVAR(pi, "mcs5glpo6");
+			pi->mcs5glpo[7] =
+				(u16) PHY_GETINTVAR(pi, "mcs5glpo7");
+			break;
+		case 3:
 
-	and_phy_reg(pi, 0xa1, ~3);
+			pi->nphy_txpid5gh[0] =
+				(u8) PHY_GETINTVAR(pi, "txpid5gha0");
+			pi->nphy_txpid5gh[1] =
+				(u8) PHY_GETINTVAR(pi, "txpid5gha1");
+			pi->nphy_pwrctrl_info[0].max_pwr_5gh =
+				(s8) PHY_GETINTVAR(pi, "maxp5gha0");
+			pi->nphy_pwrctrl_info[1].max_pwr_5gh =
+				(s8) PHY_GETINTVAR(pi, "maxp5gha1");
+			pi->nphy_pwrctrl_info[0].pwrdet_5gh_a1 =
+				(s16) PHY_GETINTVAR(pi, "pa5ghw0a0");
+			pi->nphy_pwrctrl_info[1].pwrdet_5gh_a1 =
+				(s16) PHY_GETINTVAR(pi, "pa5ghw0a1");
+			pi->nphy_pwrctrl_info[0].pwrdet_5gh_b0 =
+				(s16) PHY_GETINTVAR(pi, "pa5ghw1a0");
+			pi->nphy_pwrctrl_info[1].pwrdet_5gh_b0 =
+				(s16) PHY_GETINTVAR(pi, "pa5ghw1a1");
+			pi->nphy_pwrctrl_info[0].pwrdet_5gh_b1 =
+				(s16) PHY_GETINTVAR(pi, "pa5ghw2a0");
+			pi->nphy_pwrctrl_info[1].pwrdet_5gh_b1 =
+				(s16) PHY_GETINTVAR(pi, "pa5ghw2a1");
+			pi->nphy_pwrctrl_info[0].idle_targ_5gh = 0;
+			pi->nphy_pwrctrl_info[1].idle_targ_5gh = 0;
 
-	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-		write_phy_reg(pi, 0x8f, 0);
-		write_phy_reg(pi, 0xa5, 0);
-	} else {
-		write_phy_reg(pi, 0xa5, 0);
-	}
+			pi->ofdm5ghpo = (u32) PHY_GETINTVAR(pi, "ofdm5ghpo");
 
-	if (NREV_IS(pi->pubpi.phy_rev, 2))
-		mod_phy_reg(pi, 0xdc, 0x00ff, 0x3b);
-	else if (NREV_LT(pi->pubpi.phy_rev, 2))
-		mod_phy_reg(pi, 0xdc, 0x00ff, 0x40);
+			pi->mcs5ghpo[0] =
+				(u16) PHY_GETINTVAR(pi, "mcs5ghpo0");
+			pi->mcs5ghpo[1] =
+				(u16) PHY_GETINTVAR(pi, "mcs5ghpo1");
+			pi->mcs5ghpo[2] =
+				(u16) PHY_GETINTVAR(pi, "mcs5ghpo2");
+			pi->mcs5ghpo[3] =
+				(u16) PHY_GETINTVAR(pi, "mcs5ghpo3");
+			pi->mcs5ghpo[4] =
+				(u16) PHY_GETINTVAR(pi, "mcs5ghpo4");
+			pi->mcs5ghpo[5] =
+				(u16) PHY_GETINTVAR(pi, "mcs5ghpo5");
+			pi->mcs5ghpo[6] =
+				(u16) PHY_GETINTVAR(pi, "mcs5ghpo6");
+			pi->mcs5ghpo[7] =
+				(u16) PHY_GETINTVAR(pi, "mcs5ghpo7");
+			break;
+		}
+	}
 
-	write_phy_reg(pi, 0x203, 32);
-	write_phy_reg(pi, 0x201, 32);
+	wlc_phy_txpwr_apply_nphy(pi);
+}
 
-	if (pi->sh->boardflags2 & BFL2_SKWRKFEM_BRD)
-		write_phy_reg(pi, 0x20d, 160);
-	else
-		write_phy_reg(pi, 0x20d, 184);
+static bool wlc_phy_txpwr_srom_read_nphy(struct brcms_phy *pi)
+{
 
-	write_phy_reg(pi, 0x13a, 200);
+	pi->antswitch = (u8) PHY_GETINTVAR(pi, "antswitch");
+	pi->aa2g = (u8) PHY_GETINTVAR(pi, "aa2g");
+	pi->aa5g = (u8) PHY_GETINTVAR(pi, "aa5g");
 
-	write_phy_reg(pi, 0x70, 80);
+	pi->srom_fem2g.tssipos = (u8) PHY_GETINTVAR(pi, "tssipos2g");
+	pi->srom_fem2g.extpagain = (u8) PHY_GETINTVAR(pi, "extpagain2g");
+	pi->srom_fem2g.pdetrange = (u8) PHY_GETINTVAR(pi, "pdetrange2g");
+	pi->srom_fem2g.triso = (u8) PHY_GETINTVAR(pi, "triso2g");
+	pi->srom_fem2g.antswctrllut = (u8) PHY_GETINTVAR(pi, "antswctl2g");
 
-	write_phy_reg(pi, 0x1ff, 48);
+	pi->srom_fem5g.tssipos = (u8) PHY_GETINTVAR(pi, "tssipos5g");
+	pi->srom_fem5g.extpagain = (u8) PHY_GETINTVAR(pi, "extpagain5g");
+	pi->srom_fem5g.pdetrange = (u8) PHY_GETINTVAR(pi, "pdetrange5g");
+	pi->srom_fem5g.triso = (u8) PHY_GETINTVAR(pi, "triso5g");
+	if (PHY_GETVAR(pi, "antswctl5g"))
+		pi->srom_fem5g.antswctrllut =
+			(u8) PHY_GETINTVAR(pi, "antswctl5g");
+	else
+		pi->srom_fem5g.antswctrllut =
+			(u8) PHY_GETINTVAR(pi, "antswctl2g");
 
-	if (NREV_LT(pi->pubpi.phy_rev, 8))
-		wlc_phy_update_mimoconfig_nphy(pi, pi->n_preamble_override);
+	wlc_phy_txpower_ipa_upd(pi);
 
-	wlc_phy_stf_chain_upd_nphy(pi);
+	pi->phy_txcore_disable_temp = (s16) PHY_GETINTVAR(pi, "tempthresh");
+	if (pi->phy_txcore_disable_temp == 0)
+		pi->phy_txcore_disable_temp = PHY_CHAIN_TX_DISABLE_TEMP;
 
-	if (NREV_LT(pi->pubpi.phy_rev, 2)) {
-		write_phy_reg(pi, 0x180, 0xaa8);
-		write_phy_reg(pi, 0x181, 0x9a4);
+	pi->phy_tempsense_offset = (s8) PHY_GETINTVAR(pi, "tempoffset");
+	if (pi->phy_tempsense_offset != 0) {
+		if (pi->phy_tempsense_offset >
+		    (NPHY_SROM_TEMPSHIFT + NPHY_SROM_MAXTEMPOFFSET))
+			pi->phy_tempsense_offset = NPHY_SROM_MAXTEMPOFFSET;
+		else if (pi->phy_tempsense_offset < (NPHY_SROM_TEMPSHIFT +
+						     NPHY_SROM_MINTEMPOFFSET))
+			pi->phy_tempsense_offset = NPHY_SROM_MINTEMPOFFSET;
+		else
+			pi->phy_tempsense_offset -= NPHY_SROM_TEMPSHIFT;
 	}
 
-	if (PHY_IPA(pi)) {
-		for (core = 0; core < pi->pubpi.phy_corenum; core++) {
+	pi->phy_txcore_enable_temp =
+		pi->phy_txcore_disable_temp - PHY_HYSTERESIS_DELTATEMP;
 
-			mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x297 :
-				    0x29b, (0x1 << 0), (1) << 0);
+	pi->phycal_tempdelta = (u8) PHY_GETINTVAR(pi, "phycal_tempdelta");
+	if (pi->phycal_tempdelta > NPHY_CAL_MAXTEMPDELTA)
+		pi->phycal_tempdelta = 0;
 
-			mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x298 :
-				    0x29c, (0x1ff << 7),
-				    (pi->nphy_papd_epsilon_offset[core]) << 7);
+	wlc_phy_txpwr_srom_read_ppr_nphy(pi);
 
-		}
+	return true;
+}
 
-		wlc_phy_ipa_set_tx_digi_filts_nphy(pi);
-	} else if (NREV_GE(pi->pubpi.phy_rev, 5)) {
-		wlc_phy_extpa_set_tx_digi_filts_nphy(pi);
-	}
+bool wlc_phy_attach_nphy(struct brcms_phy *pi)
+{
+	uint i;
 
-	wlc_phy_workarounds_nphy(pi);
+	if (NREV_GE(pi->pubpi.phy_rev, 3) && NREV_LT(pi->pubpi.phy_rev, 6))
+		pi->phyhang_avoid = true;
 
-	wlapi_bmac_phyclk_fgc(pi->sh->physhim, ON);
+	if (NREV_GE(pi->pubpi.phy_rev, 3) && NREV_LT(pi->pubpi.phy_rev, 7)) {
+		pi->nphy_gband_spurwar_en = true;
+		if (pi->sh->boardflags2 & BFL2_SPUR_WAR)
+			pi->nphy_aband_spurwar_en = true;
+	}
+	if (NREV_GE(pi->pubpi.phy_rev, 6) && NREV_LT(pi->pubpi.phy_rev, 7)) {
+		if (pi->sh->boardflags2 & BFL2_2G_SPUR_WAR)
+			pi->nphy_gband_spurwar2_en = true;
+	}
 
-	val = read_phy_reg(pi, 0x01);
-	write_phy_reg(pi, 0x01, val | BBCFG_RESETCCA);
-	write_phy_reg(pi, 0x01, val & (~BBCFG_RESETCCA));
-	wlapi_bmac_phyclk_fgc(pi->sh->physhim, OFF);
+	pi->n_preamble_override = AUTO;
+	if (NREV_IS(pi->pubpi.phy_rev, 3) || NREV_IS(pi->pubpi.phy_rev, 4))
+		pi->n_preamble_override = BRCMS_N_PREAMBLE_MIXEDMODE;
 
-	wlapi_bmac_macphyclk_set(pi->sh->physhim, ON);
+	pi->nphy_txrx_chain = AUTO;
+	pi->phy_scraminit = AUTO;
 
-	wlc_phy_pa_override_nphy(pi, OFF);
-	wlc_phy_force_rfseq_nphy(pi, NPHY_RFSEQ_RX2TX);
-	wlc_phy_force_rfseq_nphy(pi, NPHY_RFSEQ_RESET2RX);
-	wlc_phy_pa_override_nphy(pi, ON);
+	pi->nphy_rxcalparams = 0x010100B5;
 
-	wlc_phy_classifier_nphy(pi, 0, 0);
-	wlc_phy_clip_det_nphy(pi, 0, clip1_ths);
+	pi->nphy_perical = PHY_PERICAL_MPHASE;
+	pi->mphase_cal_phase_id = MPHASE_CAL_STATE_IDLE;
+	pi->mphase_txcal_numcmds = MPHASE_TXCAL_NUMCMDS;
 
-	if (CHSPEC_IS2G(pi->radio_chanspec))
-		wlc_phy_bphy_init_nphy(pi);
+	pi->nphy_gain_boost = true;
+	pi->nphy_elna_gain_config = false;
+	pi->radio_is_on = false;
 
-	tx_pwr_ctrl_state = pi->nphy_txpwrctrl;
-	wlc_phy_txpwrctrl_enable_nphy(pi, PHY_TPC_HW_OFF);
+	for (i = 0; i < pi->pubpi.phy_corenum; i++)
+		pi->nphy_txpwrindex[i].index = AUTO;
 
-	wlc_phy_txpwr_fixpower_nphy(pi);
+	wlc_phy_txpwrctrl_config_nphy(pi);
+	if (pi->nphy_txpwrctrl == PHY_TPC_HW_ON)
+		pi->hwpwrctrl_capable = true;
 
-	wlc_phy_txpwrctrl_idle_tssi_nphy(pi);
+	pi->pi_fptr.init = wlc_phy_init_nphy;
+	pi->pi_fptr.calinit = wlc_phy_cal_init_nphy;
+	pi->pi_fptr.chanset = wlc_phy_chanspec_set_nphy;
+	pi->pi_fptr.txpwrrecalc = wlc_phy_txpower_recalc_target_nphy;
 
-	wlc_phy_txpwrctrl_pwr_setup_nphy(pi);
+	if (!wlc_phy_txpwr_srom_read_nphy(pi))
+		return false;
 
-	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-		u32 *tx_pwrctrl_tbl = NULL;
-		u16 idx;
-		s16 pga_gn = 0;
-		s16 pad_gn = 0;
-		s32 rfpwr_offset;
-
-		if (PHY_IPA(pi)) {
-			tx_pwrctrl_tbl = wlc_phy_get_ipa_gaintbl_nphy(pi);
-		} else {
-			if (CHSPEC_IS5G(pi->radio_chanspec)) {
-				if (NREV_IS(pi->pubpi.phy_rev, 3))
-					tx_pwrctrl_tbl =
-						nphy_tpc_5GHz_txgain_rev3;
-				else if (NREV_IS(pi->pubpi.phy_rev, 4))
-					tx_pwrctrl_tbl =
-						(pi->srom_fem5g.extpagain ==
-						 3) ?
-						nphy_tpc_5GHz_txgain_HiPwrEPA :
-						nphy_tpc_5GHz_txgain_rev4;
-				else
-					tx_pwrctrl_tbl =
-						nphy_tpc_5GHz_txgain_rev5;
-			} else {
-				if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-					if (pi->pubpi.radiorev == 5)
-						tx_pwrctrl_tbl =
-						   nphy_tpc_txgain_epa_2057rev5;
-					else if (pi->pubpi.radiorev == 3)
-						tx_pwrctrl_tbl =
-						   nphy_tpc_txgain_epa_2057rev3;
-				} else {
-					if (NREV_GE(pi->pubpi.phy_rev, 5) &&
-					    (pi->srom_fem2g.extpagain == 3))
-						tx_pwrctrl_tbl =
-						       nphy_tpc_txgain_HiPwrEPA;
-					else
-						tx_pwrctrl_tbl =
-							nphy_tpc_txgain_rev3;
-				}
-			}
-		}
-
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_CORE1TXPWRCTL, 128,
-					 192, 32, tx_pwrctrl_tbl);
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_CORE2TXPWRCTL, 128,
-					 192, 32, tx_pwrctrl_tbl);
-
-		pi->nphy_gmval = (u16) ((*tx_pwrctrl_tbl >> 16) & 0x7000);
-
-		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-
-			for (idx = 0; idx < 128; idx++) {
-				pga_gn = (tx_pwrctrl_tbl[idx] >> 24) & 0xf;
-				pad_gn = (tx_pwrctrl_tbl[idx] >> 19) & 0x1f;
-				rfpwr_offset = get_rf_pwr_offset(pi, pga_gn,
-								 pad_gn);
-				wlc_phy_table_write_nphy(
-					pi,
-					NPHY_TBL_ID_CORE1TXPWRCTL,
-					1, 576 + idx, 32,
-					&rfpwr_offset);
-				wlc_phy_table_write_nphy(
-					pi,
-					NPHY_TBL_ID_CORE2TXPWRCTL,
-					1, 576 + idx, 32,
-					&rfpwr_offset);
-			}
-		} else {
-
-			for (idx = 0; idx < 128; idx++) {
-				pga_gn = (tx_pwrctrl_tbl[idx] >> 24) & 0xf;
-				if (CHSPEC_IS2G(pi->radio_chanspec))
-					rfpwr_offset = (s16)
-						 nphy_papd_pga_gain_delta_ipa_2g
-								       [pga_gn];
-				else
-					rfpwr_offset = (s16)
-						 nphy_papd_pga_gain_delta_ipa_5g
-								       [pga_gn];
-
-				wlc_phy_table_write_nphy(
-					pi,
-					NPHY_TBL_ID_CORE1TXPWRCTL,
-					1, 576 + idx, 32,
-					&rfpwr_offset);
-				wlc_phy_table_write_nphy(
-					pi,
-					NPHY_TBL_ID_CORE2TXPWRCTL,
-					1, 576 + idx, 32,
-					&rfpwr_offset);
-			}
-
-		}
-	} else {
-
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_CORE1TXPWRCTL, 128,
-					 192, 32, nphy_tpc_txgain);
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_CORE2TXPWRCTL, 128,
-					 192, 32, nphy_tpc_txgain);
-	}
-
-	if (pi->sh->phyrxchain != 0x3)
-		wlc_phy_rxcore_setstate_nphy((struct brcms_phy_pub *) pi,
-					     pi->sh->phyrxchain);
-
-	if (PHY_PERICAL_MPHASE_PENDING(pi))
-		wlc_phy_cal_perical_mphase_restart(pi);
-
-	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-		do_rssi_cal = (CHSPEC_IS2G(pi->radio_chanspec)) ?
-			      (pi->nphy_rssical_chanspec_2G == 0) :
-			      (pi->nphy_rssical_chanspec_5G == 0);
-
-		if (do_rssi_cal)
-			wlc_phy_rssi_cal_nphy(pi);
-		else
-			wlc_phy_restore_rssical_nphy(pi);
-	} else {
-		wlc_phy_rssi_cal_nphy(pi);
-	}
-
-	if (!SCAN_RM_IN_PROGRESS(pi))
-		do_nphy_cal = (CHSPEC_IS2G(pi->radio_chanspec)) ?
-			      (pi->nphy_iqcal_chanspec_2G == 0) :
-			      (pi->nphy_iqcal_chanspec_5G == 0);
-
-	if (!pi->do_initcal)
-		do_nphy_cal = false;
-
-	if (do_nphy_cal) {
-
-		target_gain = wlc_phy_get_tx_gain_nphy(pi);
-
-		if (pi->antsel_type == ANTSEL_2x3)
-			wlc_phy_antsel_init((struct brcms_phy_pub *) pi,
-					    true);
-
-		if (pi->nphy_perical != PHY_PERICAL_MPHASE) {
-			wlc_phy_rssi_cal_nphy(pi);
-
-			if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-				pi->nphy_cal_orig_pwr_idx[0] =
-					pi->nphy_txpwrindex[PHY_CORE_0]
-					.
-					index_internal;
-				pi->nphy_cal_orig_pwr_idx[1] =
-					pi->nphy_txpwrindex[PHY_CORE_1]
-					.
-					index_internal;
-
-				wlc_phy_precal_txgain_nphy(pi);
-				target_gain =
-					wlc_phy_get_tx_gain_nphy(pi);
-			}
+	return true;
+}
 
-			if (wlc_phy_cal_txiqlo_nphy
-				    (pi, target_gain, true,
-				    false) == 0) {
-				if (wlc_phy_cal_rxiq_nphy
-					    (pi, target_gain, 2,
-					    false) == 0)
-					wlc_phy_savecal_nphy(pi);
+static s32 get_rf_pwr_offset(struct brcms_phy *pi, s16 pga_gn, s16 pad_gn)
+{
+	s32 rfpwr_offset = 0;
 
-			}
-		} else if (pi->mphase_cal_phase_id ==
-			   MPHASE_CAL_STATE_IDLE) {
-			wlc_phy_cal_perical((struct brcms_phy_pub *) pi,
-					    PHY_PERICAL_PHYINIT);
-		}
+	if (CHSPEC_IS2G(pi->radio_chanspec)) {
+		if ((pi->pubpi.radiorev == 3) ||
+		    (pi->pubpi.radiorev == 4) ||
+		    (pi->pubpi.radiorev == 6))
+			rfpwr_offset = (s16)
+				       nphy_papd_padgain_dlt_2g_2057rev3n4
+				       [pad_gn];
+		else if (pi->pubpi.radiorev == 5)
+			rfpwr_offset = (s16)
+				       nphy_papd_padgain_dlt_2g_2057rev5
+				       [pad_gn];
+		else if ((pi->pubpi.radiorev == 7)
+			 || (pi->pubpi.radiorev ==
+			     8))
+			rfpwr_offset = (s16)
+				       nphy_papd_padgain_dlt_2g_2057rev7
+				       [pad_gn];
 	} else {
-		wlc_phy_restorecal_nphy(pi);
+		if ((pi->pubpi.radiorev == 3) ||
+		    (pi->pubpi.radiorev == 4) ||
+		    (pi->pubpi.radiorev == 6))
+			rfpwr_offset = (s16)
+				       nphy_papd_pgagain_dlt_5g_2057
+				       [pga_gn];
+		else if ((pi->pubpi.radiorev == 7)
+			 || (pi->pubpi.radiorev ==
+			     8))
+			rfpwr_offset = (s16)
+				       nphy_papd_pgagain_dlt_5g_2057rev7
+				       [pga_gn];
 	}
-
-	wlc_phy_txpwrctrl_coeff_setup_nphy(pi);
-
-	wlc_phy_txpwrctrl_enable_nphy(pi, tx_pwr_ctrl_state);
-
-	wlc_phy_nphy_tkip_rifs_war(pi, pi->sh->_rifs_phy);
-
-	if (NREV_GE(pi->pubpi.phy_rev, 3) && NREV_LE(pi->pubpi.phy_rev, 6))
-
-		write_phy_reg(pi, 0x70, 50);
-
-	wlc_phy_txlpfbw_nphy(pi);
-
-	wlc_phy_spurwar_nphy(pi);
-
+	return rfpwr_offset;
 }
 
 static void wlc_phy_update_mimoconfig_nphy(struct brcms_phy *pi, s32 preamble)
@@ -14948,1387 +14745,727 @@ static void wlc_phy_update_mimoconfig_nphy(struct brcms_phy *pi, s32 preamble)
 	write_phy_reg(pi, 0xed, val);
 }
 
-static void wlc_phy_resetcca_nphy(struct brcms_phy *pi)
+static void wlc_phy_ipa_set_tx_digi_filts_nphy(struct brcms_phy *pi)
 {
-	u16 val;
-
-	wlapi_bmac_phyclk_fgc(pi->sh->physhim, ON);
+	int j, type;
+	u16 addr_offset[] = { 0x186, 0x195, 0x2c5};
 
-	val = read_phy_reg(pi, 0x01);
-	write_phy_reg(pi, 0x01, val | BBCFG_RESETCCA);
-	udelay(1);
-	write_phy_reg(pi, 0x01, val & (~BBCFG_RESETCCA));
+	for (type = 0; type < 3; type++) {
+		for (j = 0; j < NPHY_NUM_DIG_FILT_COEFFS; j++)
+			write_phy_reg(pi, addr_offset[type] + j,
+				      NPHY_IPA_REV4_txdigi_filtcoeffs[type][j]);
+	}
 
-	wlapi_bmac_phyclk_fgc(pi->sh->physhim, OFF);
+	if (IS40MHZ(pi)) {
+		for (j = 0; j < NPHY_NUM_DIG_FILT_COEFFS; j++)
+			write_phy_reg(pi, 0x186 + j,
+				      NPHY_IPA_REV4_txdigi_filtcoeffs[3][j]);
+	} else {
+		if (CHSPEC_IS5G(pi->radio_chanspec)) {
+			for (j = 0; j < NPHY_NUM_DIG_FILT_COEFFS; j++)
+				write_phy_reg(pi, 0x186 + j,
+					NPHY_IPA_REV4_txdigi_filtcoeffs[5][j]);
+		}
 
-	wlc_phy_force_rfseq_nphy(pi, NPHY_RFSEQ_RESET2RX);
+		if (CHSPEC_CHANNEL(pi->radio_chanspec) == 14) {
+			for (j = 0; j < NPHY_NUM_DIG_FILT_COEFFS; j++)
+				write_phy_reg(pi, 0x2c5 + j,
+					NPHY_IPA_REV4_txdigi_filtcoeffs[6][j]);
+		}
+	}
 }
 
-void wlc_phy_pa_override_nphy(struct brcms_phy *pi, bool en)
+static void wlc_phy_ipa_restore_tx_digi_filts_nphy(struct brcms_phy *pi)
 {
-	u16 rfctrlintc_override_val;
-
-	if (!en) {
-
-		pi->rfctrlIntc1_save = read_phy_reg(pi, 0x91);
-		pi->rfctrlIntc2_save = read_phy_reg(pi, 0x92);
-
-		if (NREV_GE(pi->pubpi.phy_rev, 7))
-			rfctrlintc_override_val = 0x1480;
-		else if (NREV_GE(pi->pubpi.phy_rev, 3))
-			rfctrlintc_override_val =
-				CHSPEC_IS5G(pi->radio_chanspec) ? 0x600 : 0x480;
-		else
-			rfctrlintc_override_val =
-				CHSPEC_IS5G(pi->radio_chanspec) ? 0x180 : 0x120;
-
-		write_phy_reg(pi, 0x91, rfctrlintc_override_val);
-		write_phy_reg(pi, 0x92, rfctrlintc_override_val);
-	} else {
-		write_phy_reg(pi, 0x91, pi->rfctrlIntc1_save);
-		write_phy_reg(pi, 0x92, pi->rfctrlIntc2_save);
-	}
-
-}
-
-void wlc_phy_stf_chain_upd_nphy(struct brcms_phy *pi)
-{
-
-	u16 txrx_chain =
-		(NPHY_RfseqCoreActv_TxRxChain0 | NPHY_RfseqCoreActv_TxRxChain1);
-	bool CoreActv_override = false;
-
-	if (pi->nphy_txrx_chain == BRCMS_N_TXRX_CHAIN0) {
-		txrx_chain = NPHY_RfseqCoreActv_TxRxChain0;
-		CoreActv_override = true;
-
-		if (NREV_LE(pi->pubpi.phy_rev, 2))
-			and_phy_reg(pi, 0xa0, ~0x20);
-	} else if (pi->nphy_txrx_chain == BRCMS_N_TXRX_CHAIN1) {
-		txrx_chain = NPHY_RfseqCoreActv_TxRxChain1;
-		CoreActv_override = true;
-
-		if (NREV_LE(pi->pubpi.phy_rev, 2))
-			or_phy_reg(pi, 0xa0, 0x20);
-	}
-
-	mod_phy_reg(pi, 0xa2, ((0xf << 0) | (0xf << 4)), txrx_chain);
+	int j;
 
-	if (CoreActv_override) {
-		pi->nphy_perical = PHY_PERICAL_DISABLE;
-		or_phy_reg(pi, 0xa1, NPHY_RfseqMode_CoreActv_override);
+	if (IS40MHZ(pi)) {
+		for (j = 0; j < NPHY_NUM_DIG_FILT_COEFFS; j++)
+			write_phy_reg(pi, 0x195 + j,
+				      NPHY_IPA_REV4_txdigi_filtcoeffs[4][j]);
 	} else {
-		pi->nphy_perical = PHY_PERICAL_MPHASE;
-		and_phy_reg(pi, 0xa1, ~NPHY_RfseqMode_CoreActv_override);
+		for (j = 0; j < NPHY_NUM_DIG_FILT_COEFFS; j++)
+			write_phy_reg(pi, 0x186 + j,
+				      NPHY_IPA_REV4_txdigi_filtcoeffs[3][j]);
 	}
 }
 
-void wlc_phy_rxcore_setstate_nphy(struct brcms_phy_pub *pih, u8 rxcore_bitmask)
+static void
+wlc_phy_set_rfseq_nphy(struct brcms_phy *pi, u8 cmd, u8 *events, u8 *dlys,
+		       u8 len)
 {
-	u16 regval;
-	u16 tbl_buf[16];
-	uint i;
-	struct brcms_phy *pi = (struct brcms_phy *) pih;
-	u16 tbl_opcode;
-	bool suspend;
-
-	pi->sh->phyrxchain = rxcore_bitmask;
-
-	if (!pi->sh->clk)
-		return;
-
-	suspend = (0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
-	if (!suspend)
-		wlapi_suspend_mac_and_wait(pi->sh->physhim);
+	u32 t1_offset, t2_offset;
+	u8 ctr;
+	u8 end_event =
+		NREV_GE(pi->pubpi.phy_rev,
+			3) ? NPHY_REV3_RFSEQ_CMD_END : NPHY_RFSEQ_CMD_END;
+	u8 end_dly = 1;
 
 	if (pi->phyhang_avoid)
 		wlc_phy_stay_in_carriersearch_nphy(pi, true);
 
-	regval = read_phy_reg(pi, 0xa2);
-	regval &= ~(0xf << 4);
-	regval |= ((u16) (rxcore_bitmask & 0x3)) << 4;
-	write_phy_reg(pi, 0xa2, regval);
-
-	if ((rxcore_bitmask & 0x3) != 0x3) {
-
-		write_phy_reg(pi, 0x20e, 1);
-
-		if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-			if (pi->rx2tx_biasentry == -1) {
-				wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_RFSEQ,
-							ARRAY_SIZE(tbl_buf), 80,
-							16, tbl_buf);
-
-				for (i = 0; i < ARRAY_SIZE(tbl_buf); i++) {
-					if (tbl_buf[i] ==
-					    NPHY_REV3_RFSEQ_CMD_CLR_RXRX_BIAS) {
-						pi->rx2tx_biasentry = (u8) i;
-						tbl_opcode =
-							NPHY_REV3_RFSEQ_CMD_NOP;
-						wlc_phy_table_write_nphy(
-							pi,
-							NPHY_TBL_ID_RFSEQ,
-							1, i,
-							16,
-							&tbl_opcode);
-						break;
-					} else if (tbl_buf[i] ==
-						   NPHY_REV3_RFSEQ_CMD_END)
-						break;
-				}
-			}
-		}
-	} else {
-
-		write_phy_reg(pi, 0x20e, 30);
+	t1_offset = cmd << 4;
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, len, t1_offset, 8,
+				 events);
+	t2_offset = t1_offset + 0x080;
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, len, t2_offset, 8,
+				 dlys);
 
-		if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-			if (pi->rx2tx_biasentry != -1) {
-				tbl_opcode = NPHY_REV3_RFSEQ_CMD_CLR_RXRX_BIAS;
-				wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ,
-							 1, pi->rx2tx_biasentry,
-							 16, &tbl_opcode);
-				pi->rx2tx_biasentry = -1;
-			}
-		}
+	for (ctr = len; ctr < 16; ctr++) {
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 1,
+					 t1_offset + ctr, 8, &end_event);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 1,
+					 t2_offset + ctr, 8, &end_dly);
 	}
 
-	wlc_phy_force_rfseq_nphy(pi, NPHY_RFSEQ_RESET2RX);
-
 	if (pi->phyhang_avoid)
 		wlc_phy_stay_in_carriersearch_nphy(pi, false);
-
-	if (!suspend)
-		wlapi_enable_mac(pi->sh->physhim);
 }
 
-u8 wlc_phy_rxcore_getstate_nphy(struct brcms_phy_pub *pih)
+static u16 wlc_phy_read_lpf_bw_ctl_nphy(struct brcms_phy *pi, u16 offset)
 {
-	u16 regval, rxen_bits;
-	struct brcms_phy *pi = (struct brcms_phy *) pih;
+	u16 lpf_bw_ctl_val = 0;
+	u16 rx2tx_lpf_rc_lut_offset = 0;
 
-	regval = read_phy_reg(pi, 0xa2);
-	rxen_bits = (regval >> 4) & 0xf;
+	if (offset == 0) {
+		if (CHSPEC_IS40(pi->radio_chanspec))
+			rx2tx_lpf_rc_lut_offset = 0x159;
+		else
+			rx2tx_lpf_rc_lut_offset = 0x154;
+	} else {
+		rx2tx_lpf_rc_lut_offset = offset;
+	}
+	wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_RFSEQ, 1,
+				(u32) rx2tx_lpf_rc_lut_offset, 16,
+				&lpf_bw_ctl_val);
 
-	return (u8) rxen_bits;
-}
+	lpf_bw_ctl_val = lpf_bw_ctl_val & 0x7;
 
-bool wlc_phy_n_txpower_ipa_ison(struct brcms_phy *pi)
-{
-	return PHY_IPA(pi);
+	return lpf_bw_ctl_val;
 }
 
-static void wlc_phy_txpwr_limit_to_tbl_nphy(struct brcms_phy *pi)
+static void
+wlc_phy_rfctrl_override_nphy_rev7(struct brcms_phy *pi, u16 field, u16 value,
+				  u8 core_mask, u8 off, u8 override_id)
 {
-	u8 idx, idx2, i, delta_ind;
-
-	for (idx = TXP_FIRST_CCK; idx <= TXP_LAST_CCK; idx++)
-		pi->adj_pwr_tbl_nphy[idx] = pi->tx_power_offset[idx];
-
-	for (i = 0; i < 4; i++) {
-		idx2 = 0;
-
-		delta_ind = 0;
-
-		switch (i) {
-		case 0:
-
-			if (CHSPEC_IS40(pi->radio_chanspec)
-			    && NPHY_IS_SROM_REINTERPRET) {
-				idx = TXP_FIRST_MCS_40_SISO;
-			} else {
-				idx = (CHSPEC_IS40(pi->radio_chanspec)) ?
-				      TXP_FIRST_OFDM_40_SISO : TXP_FIRST_OFDM;
-				delta_ind = 1;
-			}
-			break;
-
-		case 1:
-
-			idx = (CHSPEC_IS40(pi->radio_chanspec)) ?
-			      TXP_FIRST_MCS_40_CDD : TXP_FIRST_MCS_20_CDD;
-			break;
-
-		case 2:
-
-			idx = (CHSPEC_IS40(pi->radio_chanspec)) ?
-			      TXP_FIRST_MCS_40_STBC : TXP_FIRST_MCS_20_STBC;
-			break;
-
-		case 3:
-
-			idx = (CHSPEC_IS40(pi->radio_chanspec)) ?
-			      TXP_FIRST_MCS_40_SDM : TXP_FIRST_MCS_20_SDM;
-			break;
-		}
-
-		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-			pi->tx_power_offset[idx];
-		idx = idx + delta_ind;
-		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-			pi->tx_power_offset[idx];
-		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-			pi->tx_power_offset[idx];
-		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-			pi->tx_power_offset[idx++];
-
-		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-			pi->tx_power_offset[idx++];
-		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-			pi->tx_power_offset[idx];
-		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-			pi->tx_power_offset[idx];
-		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-			pi->tx_power_offset[idx++];
+	u8 core_num;
+	u16 addr = 0, en_addr = 0, val_addr = 0, en_mask = 0, val_mask = 0;
+	u8 val_shift = 0;
 
-		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-			pi->tx_power_offset[idx++];
-		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-			pi->tx_power_offset[idx];
-		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-			pi->tx_power_offset[idx];
-		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-			pi->tx_power_offset[idx++];
+	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+		en_mask = field;
+		for (core_num = 0; core_num < 2; core_num++) {
+			if (override_id == NPHY_REV7_RFCTRLOVERRIDE_ID0) {
 
-		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-			pi->tx_power_offset[idx];
-		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-			pi->tx_power_offset[idx++];
-		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-			pi->tx_power_offset[idx];
-		idx = idx + 1 - delta_ind;
-		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-			pi->tx_power_offset[idx];
-
-		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-			pi->tx_power_offset[idx];
-		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-			pi->tx_power_offset[idx];
-		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-			pi->tx_power_offset[idx];
-		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-			pi->tx_power_offset[idx];
-	}
-}
-
-void wlc_phy_cal_init_nphy(struct brcms_phy *pi)
-{
-}
-
-static void
-wlc_phy_war_force_trsw_to_R_cliplo_nphy(struct brcms_phy *pi, u8 core)
-{
-	if (core == PHY_CORE_0) {
-		write_phy_reg(pi, 0x38, 0x4);
-		if (CHSPEC_IS2G(pi->radio_chanspec))
-			write_phy_reg(pi, 0x37, 0x0060);
-		else
-			write_phy_reg(pi, 0x37, 0x1080);
-	} else if (core == PHY_CORE_1) {
-		write_phy_reg(pi, 0x2ae, 0x4);
-		if (CHSPEC_IS2G(pi->radio_chanspec))
-			write_phy_reg(pi, 0x2ad, 0x0060);
-		else
-			write_phy_reg(pi, 0x2ad, 0x1080);
-	}
-}
-
-static void wlc_phy_war_txchain_upd_nphy(struct brcms_phy *pi, u8 txchain)
-{
-	u8 txchain0, txchain1;
-
-	txchain0 = txchain & 0x1;
-	txchain1 = (txchain & 0x2) >> 1;
-	if (!txchain0)
-		wlc_phy_war_force_trsw_to_R_cliplo_nphy(pi, PHY_CORE_0);
-
-	if (!txchain1)
-		wlc_phy_war_force_trsw_to_R_cliplo_nphy(pi, PHY_CORE_1);
-}
-
-static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
-{
-	u8 rfseq_rx2tx_events[] = {
-		NPHY_RFSEQ_CMD_NOP,
-		NPHY_RFSEQ_CMD_RXG_FBW,
-		NPHY_RFSEQ_CMD_TR_SWITCH,
-		NPHY_RFSEQ_CMD_CLR_HIQ_DIS,
-		NPHY_RFSEQ_CMD_RXPD_TXPD,
-		NPHY_RFSEQ_CMD_TX_GAIN,
-		NPHY_RFSEQ_CMD_EXT_PA
-	};
-	u8 rfseq_rx2tx_dlys[] = { 8, 6, 6, 2, 4, 60, 1 };
-	u8 rfseq_tx2rx_events[] = {
-		NPHY_RFSEQ_CMD_NOP,
-		NPHY_RFSEQ_CMD_EXT_PA,
-		NPHY_RFSEQ_CMD_TX_GAIN,
-		NPHY_RFSEQ_CMD_RXPD_TXPD,
-		NPHY_RFSEQ_CMD_TR_SWITCH,
-		NPHY_RFSEQ_CMD_RXG_FBW,
-		NPHY_RFSEQ_CMD_CLR_HIQ_DIS
-	};
-	u8 rfseq_tx2rx_dlys[] = { 8, 6, 2, 4, 4, 6, 1 };
-	u8 rfseq_tx2rx_events_rev3[] = {
-		NPHY_REV3_RFSEQ_CMD_EXT_PA,
-		NPHY_REV3_RFSEQ_CMD_INT_PA_PU,
-		NPHY_REV3_RFSEQ_CMD_TX_GAIN,
-		NPHY_REV3_RFSEQ_CMD_RXPD_TXPD,
-		NPHY_REV3_RFSEQ_CMD_TR_SWITCH,
-		NPHY_REV3_RFSEQ_CMD_RXG_FBW,
-		NPHY_REV3_RFSEQ_CMD_CLR_HIQ_DIS,
-		NPHY_REV3_RFSEQ_CMD_END
-	};
-	u8 rfseq_tx2rx_dlys_rev3[] = { 8, 4, 2, 2, 4, 4, 6, 1 };
-	u8 rfseq_rx2tx_events_rev3[] = {
-		NPHY_REV3_RFSEQ_CMD_NOP,
-		NPHY_REV3_RFSEQ_CMD_RXG_FBW,
-		NPHY_REV3_RFSEQ_CMD_TR_SWITCH,
-		NPHY_REV3_RFSEQ_CMD_CLR_HIQ_DIS,
-		NPHY_REV3_RFSEQ_CMD_RXPD_TXPD,
-		NPHY_REV3_RFSEQ_CMD_TX_GAIN,
-		NPHY_REV3_RFSEQ_CMD_INT_PA_PU,
-		NPHY_REV3_RFSEQ_CMD_EXT_PA,
-		NPHY_REV3_RFSEQ_CMD_END
-	};
-	u8 rfseq_rx2tx_dlys_rev3[] = { 8, 6, 6, 4, 4, 18, 42, 1, 1 };
-
-	u8 rfseq_rx2tx_events_rev3_ipa[] = {
-		NPHY_REV3_RFSEQ_CMD_NOP,
-		NPHY_REV3_RFSEQ_CMD_RXG_FBW,
-		NPHY_REV3_RFSEQ_CMD_TR_SWITCH,
-		NPHY_REV3_RFSEQ_CMD_CLR_HIQ_DIS,
-		NPHY_REV3_RFSEQ_CMD_RXPD_TXPD,
-		NPHY_REV3_RFSEQ_CMD_TX_GAIN,
-		NPHY_REV3_RFSEQ_CMD_CLR_RXRX_BIAS,
-		NPHY_REV3_RFSEQ_CMD_INT_PA_PU,
-		NPHY_REV3_RFSEQ_CMD_END
-	};
-	u8 rfseq_rx2tx_dlys_rev3_ipa[] = { 8, 6, 6, 4, 4, 16, 43, 1, 1 };
-	u16 rfseq_rx2tx_dacbufpu_rev7[] = { 0x10f, 0x10f };
-
-	s16 alpha0, alpha1, alpha2;
-	s16 beta0, beta1, beta2;
-	u32 leg_data_weights, ht_data_weights, nss1_data_weights,
-	    stbc_data_weights;
-	u8 chan_freq_range = 0;
-	u16 dac_control = 0x0002;
-	u16 aux_adc_vmid_rev7_core0[] = { 0x8e, 0x96, 0x96, 0x96 };
-	u16 aux_adc_vmid_rev7_core1[] = { 0x8f, 0x9f, 0x9f, 0x96 };
-	u16 aux_adc_vmid_rev4[] = { 0xa2, 0xb4, 0xb4, 0x89 };
-	u16 aux_adc_vmid_rev3[] = { 0xa2, 0xb4, 0xb4, 0x89 };
-	u16 *aux_adc_vmid;
-	u16 aux_adc_gain_rev7[] = { 0x02, 0x02, 0x02, 0x02 };
-	u16 aux_adc_gain_rev4[] = { 0x02, 0x02, 0x02, 0x00 };
-	u16 aux_adc_gain_rev3[] = { 0x02, 0x02, 0x02, 0x00 };
-	u16 *aux_adc_gain;
-	u16 sk_adc_vmid[] = { 0xb4, 0xb4, 0xb4, 0x24 };
-	u16 sk_adc_gain[] = { 0x02, 0x02, 0x02, 0x02 };
-	s32 min_nvar_val = 0x18d;
-	s32 min_nvar_offset_6mbps = 20;
-	u8 pdetrange;
-	u8 triso;
-	u16 regval;
-	u16 afectrl_adc_ctrl1_rev7 = 0x20;
-	u16 afectrl_adc_ctrl2_rev7 = 0x0;
-	u16 rfseq_rx2tx_lpf_h_hpc_rev7 = 0x77;
-	u16 rfseq_tx2rx_lpf_h_hpc_rev7 = 0x77;
-	u16 rfseq_pktgn_lpf_h_hpc_rev7 = 0x77;
-	u16 rfseq_htpktgn_lpf_hpc_rev7[] = { 0x77, 0x11, 0x11 };
-	u16 rfseq_pktgn_lpf_hpc_rev7[] = { 0x11, 0x11 };
-	u16 rfseq_cckpktgn_lpf_hpc_rev7[] = { 0x11, 0x11 };
-	u16 ipalvlshift_3p3_war_en = 0;
-	u16 rccal_bcap_val, rccal_scap_val;
-	u16 rccal_tx20_11b_bcap = 0;
-	u16 rccal_tx20_11b_scap = 0;
-	u16 rccal_tx20_11n_bcap = 0;
-	u16 rccal_tx20_11n_scap = 0;
-	u16 rccal_tx40_11n_bcap = 0;
-	u16 rccal_tx40_11n_scap = 0;
-	u16 rx2tx_lpf_rc_lut_tx20_11b = 0;
-	u16 rx2tx_lpf_rc_lut_tx20_11n = 0;
-	u16 rx2tx_lpf_rc_lut_tx40_11n = 0;
-	u16 tx_lpf_bw_ofdm_20mhz = 0;
-	u16 tx_lpf_bw_ofdm_40mhz = 0;
-	u16 tx_lpf_bw_11b = 0;
-	u16 ipa2g_mainbias, ipa2g_casconv, ipa2g_biasfilt;
-	u16 txgm_idac_bleed = 0;
-	bool rccal_ovrd = false;
-	u16 freq;
-	int coreNum;
-
-	if (CHSPEC_IS5G(pi->radio_chanspec))
-		wlc_phy_classifier_nphy(pi, NPHY_ClassifierCtrl_cck_en, 0);
-	else
-		wlc_phy_classifier_nphy(pi, NPHY_ClassifierCtrl_cck_en, 1);
-
-	if (pi->phyhang_avoid)
-		wlc_phy_stay_in_carriersearch_nphy(pi, true);
-
-	or_phy_reg(pi, 0xb1, NPHY_IQFlip_ADC1 | NPHY_IQFlip_ADC2);
-
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-
-		if (NREV_IS(pi->pubpi.phy_rev, 7)) {
-			mod_phy_reg(pi, 0x221, (0x1 << 4), (1 << 4));
-
-			mod_phy_reg(pi, 0x160, (0x7f << 0), (32 << 0));
-			mod_phy_reg(pi, 0x160, (0x7f << 8), (39 << 8));
-			mod_phy_reg(pi, 0x161, (0x7f << 0), (46 << 0));
-			mod_phy_reg(pi, 0x161, (0x7f << 8), (51 << 8));
-			mod_phy_reg(pi, 0x162, (0x7f << 0), (55 << 0));
-			mod_phy_reg(pi, 0x162, (0x7f << 8), (58 << 8));
-			mod_phy_reg(pi, 0x163, (0x7f << 0), (60 << 0));
-			mod_phy_reg(pi, 0x163, (0x7f << 8), (62 << 8));
-			mod_phy_reg(pi, 0x164, (0x7f << 0), (62 << 0));
-			mod_phy_reg(pi, 0x164, (0x7f << 8), (63 << 8));
-			mod_phy_reg(pi, 0x165, (0x7f << 0), (63 << 0));
-			mod_phy_reg(pi, 0x165, (0x7f << 8), (64 << 8));
-			mod_phy_reg(pi, 0x166, (0x7f << 0), (64 << 0));
-			mod_phy_reg(pi, 0x166, (0x7f << 8), (64 << 8));
-			mod_phy_reg(pi, 0x167, (0x7f << 0), (64 << 0));
-			mod_phy_reg(pi, 0x167, (0x7f << 8), (64 << 8));
-		}
-
-		if (NREV_LE(pi->pubpi.phy_rev, 8)) {
-			write_phy_reg(pi, 0x23f, 0x1b0);
-			write_phy_reg(pi, 0x240, 0x1b0);
-		}
-
-		if (NREV_GE(pi->pubpi.phy_rev, 8))
-			mod_phy_reg(pi, 0xbd, (0xff << 0), (114 << 0));
-
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x00, 16,
-					 &dac_control);
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x10, 16,
-					 &dac_control);
-
-		wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_CMPMETRICDATAWEIGHTTBL,
-					1, 0, 32, &leg_data_weights);
-		leg_data_weights = leg_data_weights & 0xffffff;
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_CMPMETRICDATAWEIGHTTBL,
-					 1, 0, 32, &leg_data_weights);
-
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ,
-					 2, 0x15e, 16,
-					 rfseq_rx2tx_dacbufpu_rev7);
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x16e, 16,
-					 rfseq_rx2tx_dacbufpu_rev7);
-
-		if (PHY_IPA(pi))
-			wlc_phy_set_rfseq_nphy(pi, NPHY_RFSEQ_RX2TX,
-					       rfseq_rx2tx_events_rev3_ipa,
-					       rfseq_rx2tx_dlys_rev3_ipa,
-					       sizeof
-					       (rfseq_rx2tx_events_rev3_ipa) /
-					       sizeof
-					       (rfseq_rx2tx_events_rev3_ipa
-						[0]));
-
-		mod_phy_reg(pi, 0x299, (0x3 << 14), (0x1 << 14));
-		mod_phy_reg(pi, 0x29d, (0x3 << 14), (0x1 << 14));
-
-		tx_lpf_bw_ofdm_20mhz = wlc_phy_read_lpf_bw_ctl_nphy(pi, 0x154);
-		tx_lpf_bw_ofdm_40mhz = wlc_phy_read_lpf_bw_ctl_nphy(pi, 0x159);
-		tx_lpf_bw_11b = wlc_phy_read_lpf_bw_ctl_nphy(pi, 0x152);
-
-		if (PHY_IPA(pi)) {
-
-			if (((pi->pubpi.radiorev == 5)
-			     && (CHSPEC_IS40(pi->radio_chanspec) == 1))
-			    || (pi->pubpi.radiorev == 7)
-			    || (pi->pubpi.radiorev == 8)) {
-
-				rccal_bcap_val =
-					read_radio_reg(
-						pi,
-						RADIO_2057_RCCAL_BCAP_VAL);
-				rccal_scap_val =
-					read_radio_reg(
-						pi,
-						RADIO_2057_RCCAL_SCAP_VAL);
-
-				rccal_tx20_11b_bcap = rccal_bcap_val;
-				rccal_tx20_11b_scap = rccal_scap_val;
-
-				if ((pi->pubpi.radiorev == 5) &&
-				    (CHSPEC_IS40(pi->radio_chanspec) == 1)) {
-
-					rccal_tx20_11n_bcap = rccal_bcap_val;
-					rccal_tx20_11n_scap = rccal_scap_val;
-					rccal_tx40_11n_bcap = 0xc;
-					rccal_tx40_11n_scap = 0xc;
-
-					rccal_ovrd = true;
-
-				} else if ((pi->pubpi.radiorev == 7)
-					   || (pi->pubpi.radiorev == 8)) {
-
-					tx_lpf_bw_ofdm_20mhz = 4;
-					tx_lpf_bw_11b = 1;
-
-					if (CHSPEC_IS2G(pi->radio_chanspec)) {
-						rccal_tx20_11n_bcap = 0xc;
-						rccal_tx20_11n_scap = 0xc;
-						rccal_tx40_11n_bcap = 0xa;
-						rccal_tx40_11n_scap = 0xa;
-					} else {
-						rccal_tx20_11n_bcap = 0x14;
-						rccal_tx20_11n_scap = 0x14;
-						rccal_tx40_11n_bcap = 0xf;
-						rccal_tx40_11n_scap = 0xf;
-					}
-
-					rccal_ovrd = true;
-				}
-			}
-
-		} else {
-
-			if (pi->pubpi.radiorev == 5) {
-
-				tx_lpf_bw_ofdm_20mhz = 1;
-				tx_lpf_bw_ofdm_40mhz = 3;
-
-				rccal_bcap_val =
-					read_radio_reg(
-						pi,
-						RADIO_2057_RCCAL_BCAP_VAL);
-				rccal_scap_val =
-					read_radio_reg(
-						pi,
-						RADIO_2057_RCCAL_SCAP_VAL);
-
-				rccal_tx20_11b_bcap = rccal_bcap_val;
-				rccal_tx20_11b_scap = rccal_scap_val;
-
-				rccal_tx20_11n_bcap = 0x13;
-				rccal_tx20_11n_scap = 0x11;
-				rccal_tx40_11n_bcap = 0x13;
-				rccal_tx40_11n_scap = 0x11;
-
-				rccal_ovrd = true;
-			}
-		}
-
-		if (rccal_ovrd) {
-
-			rx2tx_lpf_rc_lut_tx20_11b =
-				(rccal_tx20_11b_bcap << 8) |
-				(rccal_tx20_11b_scap << 3) |
-				tx_lpf_bw_11b;
-			rx2tx_lpf_rc_lut_tx20_11n =
-				(rccal_tx20_11n_bcap << 8) |
-				(rccal_tx20_11n_scap << 3) |
-				tx_lpf_bw_ofdm_20mhz;
-			rx2tx_lpf_rc_lut_tx40_11n =
-				(rccal_tx40_11n_bcap << 8) |
-				(rccal_tx40_11n_scap << 3) |
-				tx_lpf_bw_ofdm_40mhz;
-
-			for (coreNum = 0; coreNum <= 1; coreNum++) {
-				wlc_phy_table_write_nphy(
-					pi, NPHY_TBL_ID_RFSEQ,
-					1,
-					0x152 + coreNum * 0x10,
-					16,
-					&rx2tx_lpf_rc_lut_tx20_11b);
-				wlc_phy_table_write_nphy(
-					pi, NPHY_TBL_ID_RFSEQ,
-					1,
-					0x153 + coreNum * 0x10,
-					16,
-					&rx2tx_lpf_rc_lut_tx20_11n);
-				wlc_phy_table_write_nphy(
-					pi, NPHY_TBL_ID_RFSEQ,
-					1,
-					0x154 + coreNum * 0x10,
-					16,
-					&rx2tx_lpf_rc_lut_tx20_11n);
-				wlc_phy_table_write_nphy(
-					pi, NPHY_TBL_ID_RFSEQ,
-					1,
-					0x155 + coreNum * 0x10,
-					16,
-					&rx2tx_lpf_rc_lut_tx40_11n);
-				wlc_phy_table_write_nphy(
-					pi, NPHY_TBL_ID_RFSEQ,
-					1,
-					0x156 + coreNum * 0x10,
-					16,
-					&rx2tx_lpf_rc_lut_tx40_11n);
-				wlc_phy_table_write_nphy(
-					pi, NPHY_TBL_ID_RFSEQ,
-					1,
-					0x157 + coreNum * 0x10,
-					16,
-					&rx2tx_lpf_rc_lut_tx40_11n);
-				wlc_phy_table_write_nphy(
-					pi, NPHY_TBL_ID_RFSEQ,
-					1,
-					0x158 + coreNum * 0x10,
-					16,
-					&rx2tx_lpf_rc_lut_tx40_11n);
-				wlc_phy_table_write_nphy(
-					pi, NPHY_TBL_ID_RFSEQ,
-					1,
-					0x159 + coreNum * 0x10,
-					16,
-					&rx2tx_lpf_rc_lut_tx40_11n);
-			}
-
-			wlc_phy_rfctrl_override_nphy_rev7(
-				pi, (0x1 << 4),
-				1, 0x3, 0,
-				NPHY_REV7_RFCTRLOVERRIDE_ID2);
-		}
-
-		write_phy_reg(pi, 0x32f, 0x3);
-
-		if ((pi->pubpi.radiorev == 4) || (pi->pubpi.radiorev == 6))
-			wlc_phy_rfctrl_override_nphy_rev7(
-				pi, (0x1 << 2),
-				1, 0x3, 0,
-				NPHY_REV7_RFCTRLOVERRIDE_ID0);
-
-		if ((pi->pubpi.radiorev == 3) || (pi->pubpi.radiorev == 4) ||
-		    (pi->pubpi.radiorev == 6)) {
-			if ((pi->sh->sromrev >= 8)
-			    && (pi->sh->boardflags2 & BFL2_IPALVLSHIFT_3P3))
-				ipalvlshift_3p3_war_en = 1;
-
-			if (ipalvlshift_3p3_war_en) {
-				write_radio_reg(pi, RADIO_2057_GPAIO_CONFIG,
-						0x5);
-				write_radio_reg(pi, RADIO_2057_GPAIO_SEL1,
-						0x30);
-				write_radio_reg(pi, RADIO_2057_GPAIO_SEL0, 0x0);
-				or_radio_reg(pi,
-					     RADIO_2057_RXTXBIAS_CONFIG_CORE0,
-					     0x1);
-				or_radio_reg(pi,
-					     RADIO_2057_RXTXBIAS_CONFIG_CORE1,
-					     0x1);
-
-				ipa2g_mainbias = 0x1f;
-
-				ipa2g_casconv = 0x6f;
-
-				ipa2g_biasfilt = 0xaa;
-			} else {
-
-				ipa2g_mainbias = 0x2b;
-
-				ipa2g_casconv = 0x7f;
-
-				ipa2g_biasfilt = 0xee;
-			}
-
-			if (CHSPEC_IS2G(pi->radio_chanspec)) {
-				for (coreNum = 0; coreNum <= 1; coreNum++) {
-					WRITE_RADIO_REG4(pi, RADIO_2057, CORE,
-							 coreNum, IPA2G_IMAIN,
-							 ipa2g_mainbias);
-					WRITE_RADIO_REG4(pi, RADIO_2057, CORE,
-							 coreNum, IPA2G_CASCONV,
-							 ipa2g_casconv);
-					WRITE_RADIO_REG4(pi, RADIO_2057, CORE,
-							 coreNum,
-							 IPA2G_BIAS_FILTER,
-							 ipa2g_biasfilt);
-				}
-			}
-		}
-
-		if (PHY_IPA(pi)) {
-			if (CHSPEC_IS2G(pi->radio_chanspec)) {
-				if ((pi->pubpi.radiorev == 3)
-				    || (pi->pubpi.radiorev == 4)
-				    || (pi->pubpi.radiorev == 6))
-					txgm_idac_bleed = 0x7f;
-
-				for (coreNum = 0; coreNum <= 1; coreNum++) {
-					if (txgm_idac_bleed != 0)
-						WRITE_RADIO_REG4(
-							pi, RADIO_2057,
-							CORE, coreNum,
-							TXGM_IDAC_BLEED,
-							txgm_idac_bleed);
+				switch (field) {
+				case (0x1 << 2):
+					en_addr = (core_num == 0) ? 0xe7 : 0xec;
+					val_addr = (core_num == 0) ? 0x7a :
+						   0x7d;
+					val_mask = (0x1 << 1);
+					val_shift = 1;
+					break;
+				case (0x1 << 3):
+					en_addr = (core_num == 0) ? 0xe7 : 0xec;
+					val_addr = (core_num == 0) ? 0x7a :
+						   0x7d;
+					val_mask = (0x1 << 2);
+					val_shift = 2;
+					break;
+				case (0x1 << 4):
+					en_addr = (core_num == 0) ? 0xe7 : 0xec;
+					val_addr = (core_num == 0) ? 0x7a :
+						   0x7d;
+					val_mask = (0x1 << 4);
+					val_shift = 4;
+					break;
+				case (0x1 << 5):
+					en_addr = (core_num == 0) ? 0xe7 : 0xec;
+					val_addr = (core_num == 0) ? 0x7a :
+						   0x7d;
+					val_mask = (0x1 << 5);
+					val_shift = 5;
+					break;
+				case (0x1 << 6):
+					en_addr = (core_num == 0) ? 0xe7 : 0xec;
+					val_addr = (core_num == 0) ? 0x7a :
+						   0x7d;
+					val_mask = (0x1 << 6);
+					val_shift = 6;
+					break;
+				case (0x1 << 7):
+					en_addr = (core_num == 0) ? 0xe7 : 0xec;
+					val_addr = (core_num == 0) ? 0x7a :
+						   0x7d;
+					val_mask = (0x1 << 7);
+					val_shift = 7;
+					break;
+				case (0x1 << 10):
+					en_addr = (core_num == 0) ? 0xe7 : 0xec;
+					val_addr = (core_num == 0) ? 0xf8 :
+						   0xfa;
+					val_mask = (0x7 << 4);
+					val_shift = 4;
+					break;
+				case (0x1 << 11):
+					en_addr = (core_num == 0) ? 0xe7 : 0xec;
+					val_addr = (core_num == 0) ? 0x7b :
+						   0x7e;
+					val_mask = (0xffff << 0);
+					val_shift = 0;
+					break;
+				case (0x1 << 12):
+					en_addr = (core_num == 0) ? 0xe7 : 0xec;
+					val_addr = (core_num == 0) ? 0x7c :
+						   0x7f;
+					val_mask = (0xffff << 0);
+					val_shift = 0;
+					break;
+				case (0x3 << 13):
+					en_addr = (core_num == 0) ? 0xe7 : 0xec;
+					val_addr = (core_num == 0) ? 0x348 :
+						   0x349;
+					val_mask = (0xff << 0);
+					val_shift = 0;
+					break;
+				case (0x1 << 13):
+					en_addr = (core_num == 0) ? 0xe7 : 0xec;
+					val_addr = (core_num == 0) ? 0x348 :
+						   0x349;
+					val_mask = (0xf << 0);
+					val_shift = 0;
+					break;
+				default:
+					addr = 0xffff;
+					break;
 				}
+			} else if (override_id ==
+				   NPHY_REV7_RFCTRLOVERRIDE_ID1) {
 
-				if (pi->pubpi.radiorev == 5) {
-
-					for (coreNum = 0; coreNum <= 1;
-					     coreNum++) {
-						WRITE_RADIO_REG4(pi, RADIO_2057,
-								 CORE, coreNum,
-								 IPA2G_CASCONV,
-								 0x13);
-						WRITE_RADIO_REG4(pi, RADIO_2057,
-								 CORE, coreNum,
-								 IPA2G_IMAIN,
-								 0x1f);
-						WRITE_RADIO_REG4(
-							pi, RADIO_2057,
-							CORE, coreNum,
-							IPA2G_BIAS_FILTER,
-							0xee);
-						WRITE_RADIO_REG4(pi, RADIO_2057,
-								 CORE, coreNum,
-								 PAD2G_IDACS,
-								 0x8a);
-						WRITE_RADIO_REG4(
-							pi, RADIO_2057,
-							CORE, coreNum,
-							PAD_BIAS_FILTER_BWS,
-							0x3e);
-					}
+				switch (field) {
+				case (0x1 << 1):
+					en_addr = (core_num == 0) ? 0x342 :
+						  0x343;
+					val_addr = (core_num == 0) ? 0x340 :
+						   0x341;
+					val_mask = (0x1 << 1);
+					val_shift = 1;
+					break;
+				case (0x1 << 3):
+					en_addr = (core_num == 0) ? 0x342 :
+						  0x343;
+					val_addr = (core_num == 0) ? 0x340 :
+						   0x341;
+					val_mask = (0x1 << 3);
+					val_shift = 3;
+					break;
+				case (0x1 << 5):
+					en_addr = (core_num == 0) ? 0x342 :
+						  0x343;
+					val_addr = (core_num == 0) ? 0x340 :
+						   0x341;
+					val_mask = (0x1 << 5);
+					val_shift = 5;
+					break;
+				case (0x1 << 4):
+					en_addr = (core_num == 0) ? 0x342 :
+						  0x343;
+					val_addr = (core_num == 0) ? 0x340 :
+						   0x341;
+					val_mask = (0x1 << 4);
+					val_shift = 4;
+					break;
+				case (0x1 << 2):
 
-				} else if ((pi->pubpi.radiorev == 7)
-					   || (pi->pubpi.radiorev == 8)) {
+					en_addr = (core_num == 0) ? 0x342 :
+						  0x343;
+					val_addr = (core_num == 0) ? 0x340 :
+						   0x341;
+					val_mask = (0x1 << 2);
+					val_shift = 2;
+					break;
+				case (0x1 << 7):
 
-					if (CHSPEC_IS40(pi->radio_chanspec) ==
-					    0) {
-						WRITE_RADIO_REG4(pi, RADIO_2057,
-								 CORE, 0,
-								 IPA2G_IMAIN,
-								 0x14);
-						WRITE_RADIO_REG4(pi, RADIO_2057,
-								 CORE, 1,
-								 IPA2G_IMAIN,
-								 0x12);
-					} else {
-						WRITE_RADIO_REG4(pi, RADIO_2057,
-								 CORE, 0,
-								 IPA2G_IMAIN,
-								 0x16);
-						WRITE_RADIO_REG4(pi, RADIO_2057,
-								 CORE, 1,
-								 IPA2G_IMAIN,
-								 0x16);
-					}
+					en_addr = (core_num == 0) ? 0x342 :
+						  0x343;
+					val_addr = (core_num == 0) ? 0x340 :
+						   0x341;
+					val_mask = (0x7 << 8);
+					val_shift = 8;
+					break;
+				case (0x1 << 11):
+					en_addr = (core_num == 0) ? 0x342 :
+						  0x343;
+					val_addr = (core_num == 0) ? 0x340 :
+						   0x341;
+					val_mask = (0x1 << 14);
+					val_shift = 14;
+					break;
+				case (0x1 << 10):
+					en_addr = (core_num == 0) ? 0x342 :
+						  0x343;
+					val_addr = (core_num == 0) ? 0x340 :
+						   0x341;
+					val_mask = (0x1 << 13);
+					val_shift = 13;
+					break;
+				case (0x1 << 9):
+					en_addr = (core_num == 0) ? 0x342 :
+						  0x343;
+					val_addr = (core_num == 0) ? 0x340 :
+						   0x341;
+					val_mask = (0x1 << 12);
+					val_shift = 12;
+					break;
+				case (0x1 << 8):
+					en_addr = (core_num == 0) ? 0x342 :
+						  0x343;
+					val_addr = (core_num == 0) ? 0x340 :
+						   0x341;
+					val_mask = (0x1 << 11);
+					val_shift = 11;
+					break;
+				case (0x1 << 6):
+					en_addr = (core_num == 0) ? 0x342 :
+						  0x343;
+					val_addr = (core_num == 0) ? 0x340 :
+						   0x341;
+					val_mask = (0x1 << 6);
+					val_shift = 6;
+					break;
+				case (0x1 << 0):
+					en_addr = (core_num == 0) ? 0x342 :
+						  0x343;
+					val_addr = (core_num == 0) ? 0x340 :
+						   0x341;
+					val_mask = (0x1 << 0);
+					val_shift = 0;
+					break;
+				default:
+					addr = 0xffff;
+					break;
 				}
+			} else if (override_id ==
+				   NPHY_REV7_RFCTRLOVERRIDE_ID2) {
 
-			} else {
-				freq = CHAN5G_FREQ(CHSPEC_CHANNEL(
-							pi->radio_chanspec));
-				if (((freq >= 5180) && (freq <= 5230))
-				    || ((freq >= 5745) && (freq <= 5805))) {
-					WRITE_RADIO_REG4(pi, RADIO_2057, CORE,
-							 0, IPA5G_BIAS_FILTER,
-							 0xff);
-					WRITE_RADIO_REG4(pi, RADIO_2057, CORE,
-							 1, IPA5G_BIAS_FILTER,
-							 0xff);
+				switch (field) {
+				case (0x1 << 3):
+					en_addr = (core_num == 0) ? 0x346 :
+						  0x347;
+					val_addr = (core_num == 0) ? 0x344 :
+						   0x345;
+					val_mask = (0x1 << 3);
+					val_shift = 3;
+					break;
+				case (0x1 << 1):
+					en_addr = (core_num == 0) ? 0x346 :
+						  0x347;
+					val_addr = (core_num == 0) ? 0x344 :
+						   0x345;
+					val_mask = (0x1 << 1);
+					val_shift = 1;
+					break;
+				case (0x1 << 0):
+					en_addr = (core_num == 0) ? 0x346 :
+						  0x347;
+					val_addr = (core_num == 0) ? 0x344 :
+						   0x345;
+					val_mask = (0x1 << 0);
+					val_shift = 0;
+					break;
+				case (0x1 << 2):
+					en_addr = (core_num == 0) ? 0x346 :
+						  0x347;
+					val_addr = (core_num == 0) ? 0x344 :
+						   0x345;
+					val_mask = (0x1 << 2);
+					val_shift = 2;
+					break;
+				case (0x1 << 4):
+					en_addr = (core_num == 0) ? 0x346 :
+						  0x347;
+					val_addr = (core_num == 0) ? 0x344 :
+						   0x345;
+					val_mask = (0x1 << 4);
+					val_shift = 4;
+					break;
+				default:
+					addr = 0xffff;
+					break;
 				}
 			}
-		} else {
 
-			if (pi->pubpi.radiorev != 5) {
-				for (coreNum = 0; coreNum <= 1; coreNum++) {
-					WRITE_RADIO_REG4(pi, RADIO_2057, CORE,
-							 coreNum,
-							 TXMIX2G_TUNE_BOOST_PU,
-							 0x61);
-					WRITE_RADIO_REG4(pi, RADIO_2057, CORE,
-							 coreNum,
-							 TXGM_IDAC_BLEED, 0x70);
-				}
-			}
-		}
+			if (off) {
+				and_phy_reg(pi, en_addr, ~en_mask);
+				and_phy_reg(pi, val_addr, ~val_mask);
+			} else {
 
-		if (pi->pubpi.radiorev == 4) {
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1,
-						 0x05, 16,
-						 &afectrl_adc_ctrl1_rev7);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1,
-						 0x15, 16,
-						 &afectrl_adc_ctrl1_rev7);
+				if ((core_mask == 0)
+				    || (core_mask & (1 << core_num))) {
+					or_phy_reg(pi, en_addr, en_mask);
 
-			for (coreNum = 0; coreNum <= 1; coreNum++) {
-				WRITE_RADIO_REG4(pi, RADIO_2057, CORE, coreNum,
-						 AFE_VCM_CAL_MASTER, 0x0);
-				WRITE_RADIO_REG4(pi, RADIO_2057, CORE, coreNum,
-						 AFE_SET_VCM_I, 0x3f);
-				WRITE_RADIO_REG4(pi, RADIO_2057, CORE, coreNum,
-						 AFE_SET_VCM_Q, 0x3f);
+					if (addr != 0xffff)
+						mod_phy_reg(pi, val_addr,
+							    val_mask,
+							    (value <<
+							     val_shift));
+				}
 			}
-		} else {
-			mod_phy_reg(pi, 0xa6, (0x1 << 2), (0x1 << 2));
-			mod_phy_reg(pi, 0x8f, (0x1 << 2), (0x1 << 2));
-			mod_phy_reg(pi, 0xa7, (0x1 << 2), (0x1 << 2));
-			mod_phy_reg(pi, 0xa5, (0x1 << 2), (0x1 << 2));
-
-			mod_phy_reg(pi, 0xa6, (0x1 << 0), 0);
-			mod_phy_reg(pi, 0x8f, (0x1 << 0), (0x1 << 0));
-			mod_phy_reg(pi, 0xa7, (0x1 << 0), 0);
-			mod_phy_reg(pi, 0xa5, (0x1 << 0), (0x1 << 0));
-
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1,
-						 0x05, 16,
-						 &afectrl_adc_ctrl2_rev7);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1,
-						 0x15, 16,
-						 &afectrl_adc_ctrl2_rev7);
-
-			mod_phy_reg(pi, 0xa6, (0x1 << 2), 0);
-			mod_phy_reg(pi, 0x8f, (0x1 << 2), 0);
-			mod_phy_reg(pi, 0xa7, (0x1 << 2), 0);
-			mod_phy_reg(pi, 0xa5, (0x1 << 2), 0);
 		}
+	}
+}
 
-		write_phy_reg(pi, 0x6a, 0x2);
-
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1, 256, 32,
-					 &min_nvar_offset_6mbps);
-
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x138, 16,
-					 &rfseq_pktgn_lpf_hpc_rev7);
-
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 1, 0x141, 16,
-					 &rfseq_pktgn_lpf_h_hpc_rev7);
-
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 3, 0x133, 16,
-					 &rfseq_htpktgn_lpf_hpc_rev7);
-
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x146, 16,
-					 &rfseq_cckpktgn_lpf_hpc_rev7);
+static void wlc_phy_adjust_lnagaintbl_nphy(struct brcms_phy *pi)
+{
+	uint core;
+	int ctr;
+	s16 gain_delta[2];
+	u8 curr_channel;
+	u16 minmax_gain[2];
+	u16 regval[4];
 
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 1, 0x123, 16,
-					 &rfseq_tx2rx_lpf_h_hpc_rev7);
+	if (pi->phyhang_avoid)
+		wlc_phy_stay_in_carriersearch_nphy(pi, true);
 
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 1, 0x12A, 16,
-					 &rfseq_rx2tx_lpf_h_hpc_rev7);
+	if (pi->nphy_gain_boost) {
+		if ((CHSPEC_IS2G(pi->radio_chanspec))) {
 
-		if (CHSPEC_IS40(pi->radio_chanspec) == 0) {
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1, 3,
-						 32, &min_nvar_val);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1,
-						 127, 32, &min_nvar_val);
+			gain_delta[0] = 6;
+			gain_delta[1] = 6;
 		} else {
-			min_nvar_val = noise_var_tbl_rev7[3];
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1, 3,
-						 32, &min_nvar_val);
 
-			min_nvar_val = noise_var_tbl_rev7[127];
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1,
-						 127, 32, &min_nvar_val);
+			curr_channel = CHSPEC_CHANNEL(pi->radio_chanspec);
+			gain_delta[0] =
+				(s16)
+				PHY_HW_ROUND(((nphy_lnagain_est0[0] *
+					       curr_channel) +
+					      nphy_lnagain_est0[1]), 13);
+			gain_delta[1] =
+				(s16)
+				PHY_HW_ROUND(((nphy_lnagain_est1[0] *
+					       curr_channel) +
+					      nphy_lnagain_est1[1]), 13);
 		}
+	} else {
 
-		wlc_phy_workarounds_nphy_gainctrl(pi);
-
-		pdetrange =
-			(CHSPEC_IS5G(pi->radio_chanspec)) ? pi->srom_fem5g.
-			pdetrange : pi->srom_fem2g.pdetrange;
-
-		if (pdetrange == 0) {
-			chan_freq_range =
-				wlc_phy_get_chan_freq_range_nphy(pi, 0);
-			if (chan_freq_range != WL_CHAN_FREQ_RANGE_2G) {
-				aux_adc_vmid_rev7_core0[3] = 0x70;
-				aux_adc_vmid_rev7_core1[3] = 0x70;
-				aux_adc_gain_rev7[3] = 2;
-			} else {
-				aux_adc_vmid_rev7_core0[3] = 0x80;
-				aux_adc_vmid_rev7_core1[3] = 0x80;
-				aux_adc_gain_rev7[3] = 3;
-			}
-		} else if (pdetrange == 1) {
-			if (chan_freq_range != WL_CHAN_FREQ_RANGE_2G) {
-				aux_adc_vmid_rev7_core0[3] = 0x7c;
-				aux_adc_vmid_rev7_core1[3] = 0x7c;
-				aux_adc_gain_rev7[3] = 2;
-			} else {
-				aux_adc_vmid_rev7_core0[3] = 0x8c;
-				aux_adc_vmid_rev7_core1[3] = 0x8c;
-				aux_adc_gain_rev7[3] = 1;
-			}
-		} else if (pdetrange == 2) {
-			if (pi->pubpi.radioid == BCM2057_ID) {
-				if ((pi->pubpi.radiorev == 5)
-				    || (pi->pubpi.radiorev == 7)
-				    || (pi->pubpi.radiorev == 8)) {
-					if (chan_freq_range ==
-					    WL_CHAN_FREQ_RANGE_2G) {
-						aux_adc_vmid_rev7_core0[3] =
-							0x8c;
-						aux_adc_vmid_rev7_core1[3] =
-							0x8c;
-						aux_adc_gain_rev7[3] = 0;
-					} else {
-						aux_adc_vmid_rev7_core0[3] =
-							0x96;
-						aux_adc_vmid_rev7_core1[3] =
-							0x96;
-						aux_adc_gain_rev7[3] = 0;
-					}
-				}
-			}
-
-		} else if (pdetrange == 3) {
-			if (chan_freq_range == WL_CHAN_FREQ_RANGE_2G) {
-				aux_adc_vmid_rev7_core0[3] = 0x89;
-				aux_adc_vmid_rev7_core1[3] = 0x89;
-				aux_adc_gain_rev7[3] = 0;
-			}
+		gain_delta[0] = 0;
+		gain_delta[1] = 0;
+	}
 
-		} else if (pdetrange == 5) {
+	for (core = 0; core < pi->pubpi.phy_corenum; core++) {
+		if (pi->nphy_elna_gain_config) {
 
-			if (chan_freq_range != WL_CHAN_FREQ_RANGE_2G) {
-				aux_adc_vmid_rev7_core0[3] = 0x80;
-				aux_adc_vmid_rev7_core1[3] = 0x80;
-				aux_adc_gain_rev7[3] = 3;
-			} else {
-				aux_adc_vmid_rev7_core0[3] = 0x70;
-				aux_adc_vmid_rev7_core1[3] = 0x70;
-				aux_adc_gain_rev7[3] = 2;
-			}
+			regval[0] = nphy_def_lnagains[2] + gain_delta[core];
+			regval[1] = nphy_def_lnagains[3] + gain_delta[core];
+			regval[2] = nphy_def_lnagains[3] + gain_delta[core];
+			regval[3] = nphy_def_lnagains[3] + gain_delta[core];
+		} else {
+			for (ctr = 0; ctr < 4; ctr++)
+				regval[ctr] =
+					nphy_def_lnagains[ctr] +
+					gain_delta[core];
 		}
+		wlc_phy_table_write_nphy(pi, core, 4, 8, 16, regval);
 
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4, 0x08, 16,
-					 &aux_adc_vmid_rev7_core0);
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4, 0x18, 16,
-					 &aux_adc_vmid_rev7_core1);
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4, 0x0c, 16,
-					 &aux_adc_gain_rev7);
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4, 0x1c, 16,
-					 &aux_adc_gain_rev7);
-
-	} else if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-
-		write_phy_reg(pi, 0x23f, 0x1f8);
-		write_phy_reg(pi, 0x240, 0x1f8);
-
-		wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_CMPMETRICDATAWEIGHTTBL,
-					1, 0, 32, &leg_data_weights);
-		leg_data_weights = leg_data_weights & 0xffffff;
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_CMPMETRICDATAWEIGHTTBL,
-					 1, 0, 32, &leg_data_weights);
-
-		alpha0 = 293;
-		alpha1 = 435;
-		alpha2 = 261;
-		beta0 = 366;
-		beta1 = 205;
-		beta2 = 32;
-		write_phy_reg(pi, 0x145, alpha0);
-		write_phy_reg(pi, 0x146, alpha1);
-		write_phy_reg(pi, 0x147, alpha2);
-		write_phy_reg(pi, 0x148, beta0);
-		write_phy_reg(pi, 0x149, beta1);
-		write_phy_reg(pi, 0x14a, beta2);
+		minmax_gain[core] =
+			(u16) (nphy_def_lnagains[2] + gain_delta[core] + 4);
+	}
 
-		write_phy_reg(pi, 0x38, 0xC);
-		write_phy_reg(pi, 0x2ae, 0xC);
+	mod_phy_reg(pi, 0x1e, (0xff << 0), (minmax_gain[0] << 0));
+	mod_phy_reg(pi, 0x34, (0xff << 0), (minmax_gain[1] << 0));
 
-		wlc_phy_set_rfseq_nphy(pi, NPHY_RFSEQ_TX2RX,
-				       rfseq_tx2rx_events_rev3,
-				       rfseq_tx2rx_dlys_rev3,
-				       sizeof(rfseq_tx2rx_events_rev3) /
-				       sizeof(rfseq_tx2rx_events_rev3[0]));
+	if (pi->phyhang_avoid)
+		wlc_phy_stay_in_carriersearch_nphy(pi, false);
+}
 
-		if (PHY_IPA(pi))
-			wlc_phy_set_rfseq_nphy(pi, NPHY_RFSEQ_RX2TX,
-					       rfseq_rx2tx_events_rev3_ipa,
-					       rfseq_rx2tx_dlys_rev3_ipa,
-					       sizeof
-					       (rfseq_rx2tx_events_rev3_ipa) /
-					       sizeof
-					       (rfseq_rx2tx_events_rev3_ipa
-						[0]));
+static void
+wlc_phy_war_force_trsw_to_R_cliplo_nphy(struct brcms_phy *pi, u8 core)
+{
+	if (core == PHY_CORE_0) {
+		write_phy_reg(pi, 0x38, 0x4);
+		if (CHSPEC_IS2G(pi->radio_chanspec))
+			write_phy_reg(pi, 0x37, 0x0060);
+		else
+			write_phy_reg(pi, 0x37, 0x1080);
+	} else if (core == PHY_CORE_1) {
+		write_phy_reg(pi, 0x2ae, 0x4);
+		if (CHSPEC_IS2G(pi->radio_chanspec))
+			write_phy_reg(pi, 0x2ad, 0x0060);
+		else
+			write_phy_reg(pi, 0x2ad, 0x1080);
+	}
+}
 
-		if ((pi->sh->hw_phyrxchain != 0x3) &&
-		    (pi->sh->hw_phyrxchain != pi->sh->hw_phytxchain)) {
+static void wlc_phy_war_txchain_upd_nphy(struct brcms_phy *pi, u8 txchain)
+{
+	u8 txchain0, txchain1;
 
-			if (PHY_IPA(pi)) {
-				rfseq_rx2tx_dlys_rev3[5] = 59;
-				rfseq_rx2tx_dlys_rev3[6] = 1;
-				rfseq_rx2tx_events_rev3[7] =
-					NPHY_REV3_RFSEQ_CMD_END;
-			}
+	txchain0 = txchain & 0x1;
+	txchain1 = (txchain & 0x2) >> 1;
+	if (!txchain0)
+		wlc_phy_war_force_trsw_to_R_cliplo_nphy(pi, PHY_CORE_0);
 
-			wlc_phy_set_rfseq_nphy(
-				pi, NPHY_RFSEQ_RX2TX,
-				rfseq_rx2tx_events_rev3,
-				rfseq_rx2tx_dlys_rev3,
-				sizeof(rfseq_rx2tx_events_rev3)	/
-				sizeof(rfseq_rx2tx_events_rev3[0]));
-		}
+	if (!txchain1)
+		wlc_phy_war_force_trsw_to_R_cliplo_nphy(pi, PHY_CORE_1);
+}
 
-		if (CHSPEC_IS2G(pi->radio_chanspec))
-			write_phy_reg(pi, 0x6a, 0x2);
-		else
-			write_phy_reg(pi, 0x6a, 0x9c40);
+static void wlc_phy_workarounds_nphy_gainctrl_2057_rev5(struct brcms_phy *pi)
+{
+	s8 lna1_gain_db[] = { 8, 13, 17, 22 };
+	s8 lna2_gain_db[] = { -2, 7, 11, 15 };
+	s8 tia_gain_db[] = { -4, -1, 2, 5, 5, 5, 5, 5, 5, 5 };
+	s8 tia_gainbits[] = {
+		0x0, 0x01, 0x02, 0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x03 };
 
-		mod_phy_reg(pi, 0x294, (0xf << 8), (7 << 8));
+	mod_phy_reg(pi, 0x1c, (0x1 << 13), (1 << 13));
+	mod_phy_reg(pi, 0x32, (0x1 << 13), (1 << 13));
 
-		if (CHSPEC_IS40(pi->radio_chanspec) == 0) {
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1, 3,
-						 32, &min_nvar_val);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1,
-						 127, 32, &min_nvar_val);
-		} else {
-			min_nvar_val = noise_var_tbl_rev3[3];
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1, 3,
-						 32, &min_nvar_val);
+	mod_phy_reg(pi, 0x289, (0xff << 0), (0x46 << 0));
 
-			min_nvar_val = noise_var_tbl_rev3[127];
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1,
-						 127, 32, &min_nvar_val);
-		}
+	mod_phy_reg(pi, 0x283, (0xff << 0), (0x3c << 0));
+	mod_phy_reg(pi, 0x280, (0xff << 0), (0x3c << 0));
 
-		wlc_phy_workarounds_nphy_gainctrl(pi);
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_GAIN1, 4, 0x8, 8,
+				 lna1_gain_db);
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_GAIN2, 4, 0x8, 8,
+				 lna1_gain_db);
 
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x00, 16,
-					 &dac_control);
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x10, 16,
-					 &dac_control);
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_GAIN1, 4, 0x10, 8,
+				 lna2_gain_db);
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_GAIN2, 4, 0x10, 8,
+				 lna2_gain_db);
 
-		pdetrange =
-			(CHSPEC_IS5G(pi->radio_chanspec)) ? pi->srom_fem5g.
-			pdetrange : pi->srom_fem2g.pdetrange;
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_GAIN1, 10, 0x20, 8,
+				 tia_gain_db);
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_GAIN2, 10, 0x20, 8,
+				 tia_gain_db);
 
-		if (pdetrange == 0) {
-			if (NREV_GE(pi->pubpi.phy_rev, 4)) {
-				aux_adc_vmid = aux_adc_vmid_rev4;
-				aux_adc_gain = aux_adc_gain_rev4;
-			} else {
-				aux_adc_vmid = aux_adc_vmid_rev3;
-				aux_adc_gain = aux_adc_gain_rev3;
-			}
-			chan_freq_range =
-				wlc_phy_get_chan_freq_range_nphy(pi, 0);
-			if (chan_freq_range != WL_CHAN_FREQ_RANGE_2G) {
-				switch (chan_freq_range) {
-				case WL_CHAN_FREQ_RANGE_5GL:
-					aux_adc_vmid[3] = 0x89;
-					aux_adc_gain[3] = 0;
-					break;
-				case WL_CHAN_FREQ_RANGE_5GM:
-					aux_adc_vmid[3] = 0x89;
-					aux_adc_gain[3] = 0;
-					break;
-				case WL_CHAN_FREQ_RANGE_5GH:
-					aux_adc_vmid[3] = 0x89;
-					aux_adc_gain[3] = 0;
-					break;
-				default:
-					break;
-				}
-			}
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
-						 0x08, 16, aux_adc_vmid);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
-						 0x18, 16, aux_adc_vmid);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
-						 0x0c, 16, aux_adc_gain);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
-						 0x1c, 16, aux_adc_gain);
-		} else if (pdetrange == 1) {
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
-						 0x08, 16, sk_adc_vmid);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
-						 0x18, 16, sk_adc_vmid);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
-						 0x0c, 16, sk_adc_gain);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
-						 0x1c, 16, sk_adc_gain);
-		} else if (pdetrange == 2) {
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_GAINBITS1, 10, 0x20, 8,
+				 tia_gainbits);
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_GAINBITS2, 10, 0x20, 8,
+				 tia_gainbits);
 
-			u16 bcm_adc_vmid[] = { 0xa2, 0xb4, 0xb4, 0x74 };
-			u16 bcm_adc_gain[] = { 0x02, 0x02, 0x02, 0x04 };
+	write_phy_reg(pi, 0x37, 0x74);
+	write_phy_reg(pi, 0x2ad, 0x74);
+	write_phy_reg(pi, 0x38, 0x18);
+	write_phy_reg(pi, 0x2ae, 0x18);
 
-			if (NREV_GE(pi->pubpi.phy_rev, 6)) {
-				chan_freq_range =
-					wlc_phy_get_chan_freq_range_nphy(pi, 0);
-				if (chan_freq_range != WL_CHAN_FREQ_RANGE_2G) {
-					bcm_adc_vmid[3] = 0x8e;
-					bcm_adc_gain[3] = 0x03;
-				} else {
-					bcm_adc_vmid[3] = 0x94;
-					bcm_adc_gain[3] = 0x03;
-				}
-			} else if (NREV_IS(pi->pubpi.phy_rev, 5)) {
-				bcm_adc_vmid[3] = 0x84;
-				bcm_adc_gain[3] = 0x02;
-			}
+	write_phy_reg(pi, 0x2b, 0xe8);
+	write_phy_reg(pi, 0x41, 0xe8);
 
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
-						 0x08, 16, bcm_adc_vmid);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
-						 0x18, 16, bcm_adc_vmid);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
-						 0x0c, 16, bcm_adc_gain);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
-						 0x1c, 16, bcm_adc_gain);
-		} else if (pdetrange == 3) {
-			chan_freq_range =
-				wlc_phy_get_chan_freq_range_nphy(pi, 0);
-			if ((NREV_GE(pi->pubpi.phy_rev, 4))
-			    && (chan_freq_range == WL_CHAN_FREQ_RANGE_2G)) {
+	if (CHSPEC_IS20(pi->radio_chanspec)) {
 
-				u16 auxadc_vmid[] = {
-					0xa2, 0xb4, 0xb4, 0x270
-				};
-				u16 auxadc_gain[] = {
-					0x02, 0x02, 0x02, 0x00
-				};
+		mod_phy_reg(pi, 0x300, (0x3f << 0), (0x12 << 0));
+		mod_phy_reg(pi, 0x301, (0x3f << 0), (0x12 << 0));
+	} else {
 
-				wlc_phy_table_write_nphy(pi,
-							 NPHY_TBL_ID_AFECTRL, 4,
-							 0x08, 16, auxadc_vmid);
-				wlc_phy_table_write_nphy(pi,
-							 NPHY_TBL_ID_AFECTRL, 4,
-							 0x18, 16, auxadc_vmid);
-				wlc_phy_table_write_nphy(pi,
-							 NPHY_TBL_ID_AFECTRL, 4,
-							 0x0c, 16, auxadc_gain);
-				wlc_phy_table_write_nphy(pi,
-							 NPHY_TBL_ID_AFECTRL, 4,
-							 0x1c, 16, auxadc_gain);
-			}
-		} else if ((pdetrange == 4) || (pdetrange == 5)) {
-			u16 bcm_adc_vmid[] = { 0xa2, 0xb4, 0xb4, 0x0 };
-			u16 bcm_adc_gain[] = { 0x02, 0x02, 0x02, 0x0 };
-			u16 Vmid[2], Av[2];
+		mod_phy_reg(pi, 0x300, (0x3f << 0), (0x10 << 0));
+		mod_phy_reg(pi, 0x301, (0x3f << 0), (0x10 << 0));
+	}
+}
+
+static void wlc_phy_workarounds_nphy_gainctrl_2057_rev6(struct brcms_phy *pi)
+{
+	u16 currband;
+	s8 lna1G_gain_db_rev7[] = { 9, 14, 19, 24 };
+	s8 *lna1_gain_db = NULL;
+	s8 *lna1_gain_db_2 = NULL;
+	s8 *lna2_gain_db = NULL;
+	s8 tiaA_gain_db_rev7[] = { -9, -6, -3, 0, 3, 3, 3, 3, 3, 3 };
+	s8 *tia_gain_db;
+	s8 tiaA_gainbits_rev7[] = { 0, 1, 2, 3, 4, 4, 4, 4, 4, 4 };
+	s8 *tia_gainbits;
+	u16 rfseqA_init_gain_rev7[] = { 0x624f, 0x624f };
+	u16 *rfseq_init_gain;
+	u16 init_gaincode;
+	u16 clip1hi_gaincode;
+	u16 clip1md_gaincode = 0;
+	u16 clip1md_gaincode_B;
+	u16 clip1lo_gaincode;
+	u16 clip1lo_gaincode_B;
+	u8 crsminl_th = 0;
+	u8 crsminu_th;
+	u16 nbclip_th = 0;
+	u8 w1clip_th;
+	u16 freq;
+	s8 nvar_baseline_offset0 = 0, nvar_baseline_offset1 = 0;
+	u8 chg_nbclip_th = 0;
 
-			chan_freq_range =
-				wlc_phy_get_chan_freq_range_nphy(pi, 0);
-			if (chan_freq_range != WL_CHAN_FREQ_RANGE_2G) {
-				Vmid[0] = (pdetrange == 4) ? 0x8e : 0x89;
-				Vmid[1] = (pdetrange == 4) ? 0x96 : 0x89;
-				Av[0] = (pdetrange == 4) ? 2 : 0;
-				Av[1] = (pdetrange == 4) ? 2 : 0;
-			} else {
-				Vmid[0] = (pdetrange == 4) ? 0x89 : 0x74;
-				Vmid[1] = (pdetrange == 4) ? 0x8b : 0x70;
-				Av[0] = (pdetrange == 4) ? 2 : 0;
-				Av[1] = (pdetrange == 4) ? 2 : 0;
-			}
+	mod_phy_reg(pi, 0x1c, (0x1 << 13), (1 << 13));
+	mod_phy_reg(pi, 0x32, (0x1 << 13), (1 << 13));
 
-			bcm_adc_vmid[3] = Vmid[0];
-			bcm_adc_gain[3] = Av[0];
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
-						 0x08, 16, bcm_adc_vmid);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
-						 0x0c, 16, bcm_adc_gain);
+	currband = read_phy_reg(pi, 0x09) & NPHY_BandControl_currentBand;
+	if (currband == 0) {
 
-			bcm_adc_vmid[3] = Vmid[1];
-			bcm_adc_gain[3] = Av[1];
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
-						 0x18, 16, bcm_adc_vmid);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
-						 0x1c, 16, bcm_adc_gain);
-		}
+		lna1_gain_db = lna1G_gain_db_rev7;
 
-		write_radio_reg(pi,
-				(RADIO_2056_RX_MIXA_MAST_BIAS | RADIO_2056_RX0),
-				0x0);
-		write_radio_reg(pi,
-				(RADIO_2056_RX_MIXA_MAST_BIAS | RADIO_2056_RX1),
-				0x0);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_GAIN1, 4, 8, 8,
+					 lna1_gain_db);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_GAIN2, 4, 8, 8,
+					 lna1_gain_db);
 
-		write_radio_reg(pi,
-				(RADIO_2056_RX_MIXA_BIAS_MAIN | RADIO_2056_RX0),
-				0x6);
-		write_radio_reg(pi,
-				(RADIO_2056_RX_MIXA_BIAS_MAIN | RADIO_2056_RX1),
-				0x6);
+		mod_phy_reg(pi, 0x283, (0xff << 0), (0x40 << 0));
 
-		write_radio_reg(pi,
-				(RADIO_2056_RX_MIXA_BIAS_AUX | RADIO_2056_RX0),
-				0x7);
-		write_radio_reg(pi,
-				(RADIO_2056_RX_MIXA_BIAS_AUX | RADIO_2056_RX1),
-				0x7);
+		if (CHSPEC_IS40(pi->radio_chanspec)) {
+			mod_phy_reg(pi, 0x280, (0xff << 0), (0x3e << 0));
+			mod_phy_reg(pi, 0x283, (0xff << 0), (0x3e << 0));
+		}
 
-		write_radio_reg(pi,
-				(RADIO_2056_RX_MIXA_LOB_BIAS | RADIO_2056_RX0),
-				0x88);
-		write_radio_reg(pi,
-				(RADIO_2056_RX_MIXA_LOB_BIAS | RADIO_2056_RX1),
-				0x88);
+		mod_phy_reg(pi, 0x289, (0xff << 0), (0x46 << 0));
 
-		write_radio_reg(pi,
-				(RADIO_2056_RX_MIXA_CMFB_IDAC | RADIO_2056_RX0),
-				0x0);
-		write_radio_reg(pi,
-				(RADIO_2056_RX_MIXA_CMFB_IDAC | RADIO_2056_RX1),
-				0x0);
+		if (CHSPEC_IS20(pi->radio_chanspec)) {
+			mod_phy_reg(pi, 0x300, (0x3f << 0), (13 << 0));
+			mod_phy_reg(pi, 0x301, (0x3f << 0), (13 << 0));
+		}
+	} else {
 
-		write_radio_reg(pi,
-				(RADIO_2056_RX_MIXG_CMFB_IDAC | RADIO_2056_RX0),
-				0x0);
-		write_radio_reg(pi,
-				(RADIO_2056_RX_MIXG_CMFB_IDAC | RADIO_2056_RX1),
-				0x0);
+		init_gaincode = 0x9e;
+		clip1hi_gaincode = 0x9e;
+		clip1md_gaincode_B = 0x24;
+		clip1lo_gaincode = 0x8a;
+		clip1lo_gaincode_B = 8;
+		rfseq_init_gain = rfseqA_init_gain_rev7;
 
-		triso =
-			(CHSPEC_IS5G(pi->radio_chanspec)) ? pi->srom_fem5g.
-			triso : pi->srom_fem2g.triso;
-		if (triso == 7) {
-			wlc_phy_war_force_trsw_to_R_cliplo_nphy(pi, PHY_CORE_0);
-			wlc_phy_war_force_trsw_to_R_cliplo_nphy(pi, PHY_CORE_1);
-		}
+		tia_gain_db = tiaA_gain_db_rev7;
+		tia_gainbits = tiaA_gainbits_rev7;
 
-		wlc_phy_war_txchain_upd_nphy(pi, pi->sh->hw_phytxchain);
+		freq = CHAN5G_FREQ(CHSPEC_CHANNEL(pi->radio_chanspec));
+		if (CHSPEC_IS20(pi->radio_chanspec)) {
 
-		if (((pi->sh->boardflags2 & BFL2_APLL_WAR) &&
-		     (CHSPEC_IS5G(pi->radio_chanspec))) ||
-		    (((pi->sh->boardflags2 & BFL2_GPLL_WAR) ||
-		      (pi->sh->boardflags2 & BFL2_GPLL_WAR2)) &&
-		     (CHSPEC_IS2G(pi->radio_chanspec)))) {
-			nss1_data_weights = 0x00088888;
-			ht_data_weights = 0x00088888;
-			stbc_data_weights = 0x00088888;
-		} else {
-			nss1_data_weights = 0x88888888;
-			ht_data_weights = 0x88888888;
-			stbc_data_weights = 0x88888888;
-		}
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_CMPMETRICDATAWEIGHTTBL,
-					 1, 1, 32, &nss1_data_weights);
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_CMPMETRICDATAWEIGHTTBL,
-					 1, 2, 32, &ht_data_weights);
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_CMPMETRICDATAWEIGHTTBL,
-					 1, 3, 32, &stbc_data_weights);
+			w1clip_th = 25;
+			clip1md_gaincode = 0x82;
 
-		if (NREV_IS(pi->pubpi.phy_rev, 4)) {
-			if (CHSPEC_IS5G(pi->radio_chanspec)) {
-				write_radio_reg(pi,
-						RADIO_2056_TX_GMBB_IDAC |
-						RADIO_2056_TX0, 0x70);
-				write_radio_reg(pi,
-						RADIO_2056_TX_GMBB_IDAC |
-						RADIO_2056_TX1, 0x70);
-			}
-		}
+			if ((freq <= 5080) || (freq == 5825)) {
 
-		if (!pi->edcrs_threshold_lock) {
-			write_phy_reg(pi, 0x224, 0x3eb);
-			write_phy_reg(pi, 0x225, 0x3eb);
-			write_phy_reg(pi, 0x226, 0x341);
-			write_phy_reg(pi, 0x227, 0x341);
-			write_phy_reg(pi, 0x228, 0x42b);
-			write_phy_reg(pi, 0x229, 0x42b);
-			write_phy_reg(pi, 0x22a, 0x381);
-			write_phy_reg(pi, 0x22b, 0x381);
-			write_phy_reg(pi, 0x22c, 0x42b);
-			write_phy_reg(pi, 0x22d, 0x42b);
-			write_phy_reg(pi, 0x22e, 0x381);
-			write_phy_reg(pi, 0x22f, 0x381);
-		}
+				s8 lna1A_gain_db_rev7[] = { 11, 16, 20, 24 };
+				s8 lna1A_gain_db_2_rev7[] = {
+					11, 17, 22, 25};
+				s8 lna2A_gain_db_rev7[] = { -1, 6, 10, 14 };
 
-		if (NREV_GE(pi->pubpi.phy_rev, 6)) {
+				crsminu_th = 0x3e;
+				lna1_gain_db = lna1A_gain_db_rev7;
+				lna1_gain_db_2 = lna1A_gain_db_2_rev7;
+				lna2_gain_db = lna2A_gain_db_rev7;
+			} else if ((freq >= 5500) && (freq <= 5700)) {
 
-			if (pi->sh->boardflags2 & BFL2_SINGLEANT_CCK)
-				wlapi_bmac_mhf(pi->sh->physhim, MHF4,
-					      MHF4_BPHY_TXCORE0,
-					      MHF4_BPHY_TXCORE0, BRCM_BAND_ALL);
-		}
-	} else {
+				s8 lna1A_gain_db_rev7[] = { 11, 17, 21, 25 };
+				s8 lna1A_gain_db_2_rev7[] = {
+					12, 18, 22, 26};
+				s8 lna2A_gain_db_rev7[] = { 1, 8, 12, 16 };
 
-		if (pi->sh->boardflags2 & BFL2_SKWRKFEM_BRD ||
-		    (pi->sh->boardtype == 0x8b)) {
-			uint i;
-			u8 war_dlys[] = { 1, 6, 6, 2, 4, 20, 1 };
-			for (i = 0; i < ARRAY_SIZE(rfseq_rx2tx_dlys); i++)
-				rfseq_rx2tx_dlys[i] = war_dlys[i];
-		}
+				crsminu_th = 0x45;
+				clip1md_gaincode_B = 0x14;
+				nbclip_th = 0xff;
+				chg_nbclip_th = 1;
+				lna1_gain_db = lna1A_gain_db_rev7;
+				lna1_gain_db_2 = lna1A_gain_db_2_rev7;
+				lna2_gain_db = lna2A_gain_db_rev7;
+			} else {
 
-		if (CHSPEC_IS5G(pi->radio_chanspec) && pi->phy_5g_pwrgain) {
-			and_radio_reg(pi, RADIO_2055_CORE1_TX_RF_SPARE, 0xf7);
-			and_radio_reg(pi, RADIO_2055_CORE2_TX_RF_SPARE, 0xf7);
+				s8 lna1A_gain_db_rev7[] = { 12, 18, 22, 26 };
+				s8 lna1A_gain_db_2_rev7[] = {
+					12, 18, 22, 26};
+				s8 lna2A_gain_db_rev7[] = { -1, 6, 10, 14 };
+
+				crsminu_th = 0x41;
+				lna1_gain_db = lna1A_gain_db_rev7;
+				lna1_gain_db_2 = lna1A_gain_db_2_rev7;
+				lna2_gain_db = lna2A_gain_db_rev7;
+			}
+
+			if (freq <= 4920) {
+				nvar_baseline_offset0 = 5;
+				nvar_baseline_offset1 = 5;
+			} else if ((freq > 4920) && (freq <= 5320)) {
+				nvar_baseline_offset0 = 3;
+				nvar_baseline_offset1 = 5;
+			} else if ((freq > 5320) && (freq <= 5700)) {
+				nvar_baseline_offset0 = 3;
+				nvar_baseline_offset1 = 2;
+			} else {
+				nvar_baseline_offset0 = 4;
+				nvar_baseline_offset1 = 0;
+			}
 		} else {
-			or_radio_reg(pi, RADIO_2055_CORE1_TX_RF_SPARE, 0x8);
-			or_radio_reg(pi, RADIO_2055_CORE2_TX_RF_SPARE, 0x8);
-		}
 
-		regval = 0x000a;
-		wlc_phy_table_write_nphy(pi, 8, 1, 0, 16, &regval);
-		wlc_phy_table_write_nphy(pi, 8, 1, 0x10, 16, &regval);
+			crsminu_th = 0x3a;
+			crsminl_th = 0x3a;
+			w1clip_th = 20;
 
-		if (NREV_LT(pi->pubpi.phy_rev, 3)) {
-			regval = 0xcdaa;
-			wlc_phy_table_write_nphy(pi, 8, 1, 0x02, 16, &regval);
-			wlc_phy_table_write_nphy(pi, 8, 1, 0x12, 16, &regval);
+			if ((freq >= 4920) && (freq <= 5320)) {
+				nvar_baseline_offset0 = 4;
+				nvar_baseline_offset1 = 5;
+			} else if ((freq > 5320) && (freq <= 5550)) {
+				nvar_baseline_offset0 = 4;
+				nvar_baseline_offset1 = 2;
+			} else {
+				nvar_baseline_offset0 = 5;
+				nvar_baseline_offset1 = 3;
+			}
 		}
 
-		if (NREV_LT(pi->pubpi.phy_rev, 2)) {
-			regval = 0x0000;
-			wlc_phy_table_write_nphy(pi, 8, 1, 0x08, 16, &regval);
-			wlc_phy_table_write_nphy(pi, 8, 1, 0x18, 16, &regval);
-
-			regval = 0x7aab;
-			wlc_phy_table_write_nphy(pi, 8, 1, 0x07, 16, &regval);
-			wlc_phy_table_write_nphy(pi, 8, 1, 0x17, 16, &regval);
+		write_phy_reg(pi, 0x20, init_gaincode);
+		write_phy_reg(pi, 0x2a7, init_gaincode);
 
-			regval = 0x0800;
-			wlc_phy_table_write_nphy(pi, 8, 1, 0x06, 16, &regval);
-			wlc_phy_table_write_nphy(pi, 8, 1, 0x16, 16, &regval);
-		}
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ,
+					 pi->pubpi.phy_corenum, 0x106, 16,
+					 rfseq_init_gain);
 
-		write_phy_reg(pi, 0xf8, 0x02d8);
-		write_phy_reg(pi, 0xf9, 0x0301);
-		write_phy_reg(pi, 0xfa, 0x02d8);
-		write_phy_reg(pi, 0xfb, 0x0301);
+		write_phy_reg(pi, 0x22, clip1hi_gaincode);
+		write_phy_reg(pi, 0x2a9, clip1hi_gaincode);
 
-		wlc_phy_set_rfseq_nphy(pi, NPHY_RFSEQ_RX2TX, rfseq_rx2tx_events,
-				       rfseq_rx2tx_dlys,
-				       sizeof(rfseq_rx2tx_events) /
-				       sizeof(rfseq_rx2tx_events[0]));
+		write_phy_reg(pi, 0x36, clip1md_gaincode_B);
+		write_phy_reg(pi, 0x2ac, clip1md_gaincode_B);
 
-		wlc_phy_set_rfseq_nphy(pi, NPHY_RFSEQ_TX2RX, rfseq_tx2rx_events,
-				       rfseq_tx2rx_dlys,
-				       sizeof(rfseq_tx2rx_events) /
-				       sizeof(rfseq_tx2rx_events[0]));
+		write_phy_reg(pi, 0x37, clip1lo_gaincode);
+		write_phy_reg(pi, 0x2ad, clip1lo_gaincode);
+		write_phy_reg(pi, 0x38, clip1lo_gaincode_B);
+		write_phy_reg(pi, 0x2ae, clip1lo_gaincode_B);
 
-		wlc_phy_workarounds_nphy_gainctrl(pi);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_GAIN1, 10, 0x20, 8,
+					 tia_gain_db);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_GAIN2, 10, 0x20, 8,
+					 tia_gain_db);
 
-		if (NREV_LT(pi->pubpi.phy_rev, 2)) {
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_GAINBITS1, 10, 0x20, 8,
+					 tia_gainbits);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_GAINBITS2, 10, 0x20, 8,
+					 tia_gainbits);
 
-			if (read_phy_reg(pi, 0xa0) & NPHY_MLenable)
-				wlapi_bmac_mhf(pi->sh->physhim, MHF3,
-					       MHF3_NPHY_MLADV_WAR,
-					       MHF3_NPHY_MLADV_WAR,
-					       BRCM_BAND_ALL);
+		mod_phy_reg(pi, 0x283, (0xff << 0), (crsminu_th << 0));
 
-		} else if (NREV_IS(pi->pubpi.phy_rev, 2)) {
-			write_phy_reg(pi, 0x1e3, 0x0);
-			write_phy_reg(pi, 0x1e4, 0x0);
+		if (chg_nbclip_th == 1) {
+			write_phy_reg(pi, 0x2b, nbclip_th);
+			write_phy_reg(pi, 0x41, nbclip_th);
 		}
 
-		if (NREV_LT(pi->pubpi.phy_rev, 2))
-			mod_phy_reg(pi, 0x90, (0x1 << 7), 0);
+		mod_phy_reg(pi, 0x300, (0x3f << 0), (w1clip_th << 0));
+		mod_phy_reg(pi, 0x301, (0x3f << 0), (w1clip_th << 0));
 
-		alpha0 = 293;
-		alpha1 = 435;
-		alpha2 = 261;
-		beta0 = 366;
-		beta1 = 205;
-		beta2 = 32;
-		write_phy_reg(pi, 0x145, alpha0);
-		write_phy_reg(pi, 0x146, alpha1);
-		write_phy_reg(pi, 0x147, alpha2);
-		write_phy_reg(pi, 0x148, beta0);
-		write_phy_reg(pi, 0x149, beta1);
-		write_phy_reg(pi, 0x14a, beta2);
+		mod_phy_reg(pi, 0x2e4,
+			    (0x3f << 0), (nvar_baseline_offset0 << 0));
 
-		if (NREV_LT(pi->pubpi.phy_rev, 3)) {
-			mod_phy_reg(pi, 0x142, (0xf << 12), 0);
+		mod_phy_reg(pi, 0x2e4,
+			    (0x3f << 6), (nvar_baseline_offset1 << 6));
 
-			write_phy_reg(pi, 0x192, 0xb5);
-			write_phy_reg(pi, 0x193, 0xa4);
-			write_phy_reg(pi, 0x194, 0x0);
-		}
+		if (CHSPEC_IS20(pi->radio_chanspec)) {
 
-		if (NREV_IS(pi->pubpi.phy_rev, 2))
-			mod_phy_reg(pi, 0x221,
-				    NPHY_FORCESIG_DECODEGATEDCLKS,
-				    NPHY_FORCESIG_DECODEGATEDCLKS);
-	}
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_GAIN1, 4, 8, 8,
+						 lna1_gain_db);
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_GAIN2, 4, 8, 8,
+						 lna1_gain_db_2);
 
-	if (pi->phyhang_avoid)
-		wlc_phy_stay_in_carriersearch_nphy(pi, false);
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_GAIN1, 4, 0x10,
+						 8, lna2_gain_db);
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_GAIN2, 4, 0x10,
+						 8, lna2_gain_db);
+
+			write_phy_reg(pi, 0x24, clip1md_gaincode);
+			write_phy_reg(pi, 0x2ab, clip1md_gaincode);
+		} else {
+			mod_phy_reg(pi, 0x280, (0xff << 0), (crsminl_th << 0));
+		}
+	}
 }
 
 static void wlc_phy_workarounds_nphy_gainctrl(struct brcms_phy *pi)
@@ -16954,11457 +16091,12206 @@ static void wlc_phy_workarounds_nphy_gainctrl(struct brcms_phy *pi)
 	}
 }
 
-static void wlc_phy_workarounds_nphy_gainctrl_2057_rev5(struct brcms_phy *pi)
+static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 {
-	s8 lna1_gain_db[] = { 8, 13, 17, 22 };
-	s8 lna2_gain_db[] = { -2, 7, 11, 15 };
-	s8 tia_gain_db[] = { -4, -1, 2, 5, 5, 5, 5, 5, 5, 5 };
-	s8 tia_gainbits[] = {
-		0x0, 0x01, 0x02, 0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x03 };
+	u8 rfseq_rx2tx_events[] = {
+		NPHY_RFSEQ_CMD_NOP,
+		NPHY_RFSEQ_CMD_RXG_FBW,
+		NPHY_RFSEQ_CMD_TR_SWITCH,
+		NPHY_RFSEQ_CMD_CLR_HIQ_DIS,
+		NPHY_RFSEQ_CMD_RXPD_TXPD,
+		NPHY_RFSEQ_CMD_TX_GAIN,
+		NPHY_RFSEQ_CMD_EXT_PA
+	};
+	u8 rfseq_rx2tx_dlys[] = { 8, 6, 6, 2, 4, 60, 1 };
+	u8 rfseq_tx2rx_events[] = {
+		NPHY_RFSEQ_CMD_NOP,
+		NPHY_RFSEQ_CMD_EXT_PA,
+		NPHY_RFSEQ_CMD_TX_GAIN,
+		NPHY_RFSEQ_CMD_RXPD_TXPD,
+		NPHY_RFSEQ_CMD_TR_SWITCH,
+		NPHY_RFSEQ_CMD_RXG_FBW,
+		NPHY_RFSEQ_CMD_CLR_HIQ_DIS
+	};
+	u8 rfseq_tx2rx_dlys[] = { 8, 6, 2, 4, 4, 6, 1 };
+	u8 rfseq_tx2rx_events_rev3[] = {
+		NPHY_REV3_RFSEQ_CMD_EXT_PA,
+		NPHY_REV3_RFSEQ_CMD_INT_PA_PU,
+		NPHY_REV3_RFSEQ_CMD_TX_GAIN,
+		NPHY_REV3_RFSEQ_CMD_RXPD_TXPD,
+		NPHY_REV3_RFSEQ_CMD_TR_SWITCH,
+		NPHY_REV3_RFSEQ_CMD_RXG_FBW,
+		NPHY_REV3_RFSEQ_CMD_CLR_HIQ_DIS,
+		NPHY_REV3_RFSEQ_CMD_END
+	};
+	u8 rfseq_tx2rx_dlys_rev3[] = { 8, 4, 2, 2, 4, 4, 6, 1 };
+	u8 rfseq_rx2tx_events_rev3[] = {
+		NPHY_REV3_RFSEQ_CMD_NOP,
+		NPHY_REV3_RFSEQ_CMD_RXG_FBW,
+		NPHY_REV3_RFSEQ_CMD_TR_SWITCH,
+		NPHY_REV3_RFSEQ_CMD_CLR_HIQ_DIS,
+		NPHY_REV3_RFSEQ_CMD_RXPD_TXPD,
+		NPHY_REV3_RFSEQ_CMD_TX_GAIN,
+		NPHY_REV3_RFSEQ_CMD_INT_PA_PU,
+		NPHY_REV3_RFSEQ_CMD_EXT_PA,
+		NPHY_REV3_RFSEQ_CMD_END
+	};
+	u8 rfseq_rx2tx_dlys_rev3[] = { 8, 6, 6, 4, 4, 18, 42, 1, 1 };
 
-	mod_phy_reg(pi, 0x1c, (0x1 << 13), (1 << 13));
-	mod_phy_reg(pi, 0x32, (0x1 << 13), (1 << 13));
+	u8 rfseq_rx2tx_events_rev3_ipa[] = {
+		NPHY_REV3_RFSEQ_CMD_NOP,
+		NPHY_REV3_RFSEQ_CMD_RXG_FBW,
+		NPHY_REV3_RFSEQ_CMD_TR_SWITCH,
+		NPHY_REV3_RFSEQ_CMD_CLR_HIQ_DIS,
+		NPHY_REV3_RFSEQ_CMD_RXPD_TXPD,
+		NPHY_REV3_RFSEQ_CMD_TX_GAIN,
+		NPHY_REV3_RFSEQ_CMD_CLR_RXRX_BIAS,
+		NPHY_REV3_RFSEQ_CMD_INT_PA_PU,
+		NPHY_REV3_RFSEQ_CMD_END
+	};
+	u8 rfseq_rx2tx_dlys_rev3_ipa[] = { 8, 6, 6, 4, 4, 16, 43, 1, 1 };
+	u16 rfseq_rx2tx_dacbufpu_rev7[] = { 0x10f, 0x10f };
 
-	mod_phy_reg(pi, 0x289, (0xff << 0), (0x46 << 0));
+	s16 alpha0, alpha1, alpha2;
+	s16 beta0, beta1, beta2;
+	u32 leg_data_weights, ht_data_weights, nss1_data_weights,
+	    stbc_data_weights;
+	u8 chan_freq_range = 0;
+	u16 dac_control = 0x0002;
+	u16 aux_adc_vmid_rev7_core0[] = { 0x8e, 0x96, 0x96, 0x96 };
+	u16 aux_adc_vmid_rev7_core1[] = { 0x8f, 0x9f, 0x9f, 0x96 };
+	u16 aux_adc_vmid_rev4[] = { 0xa2, 0xb4, 0xb4, 0x89 };
+	u16 aux_adc_vmid_rev3[] = { 0xa2, 0xb4, 0xb4, 0x89 };
+	u16 *aux_adc_vmid;
+	u16 aux_adc_gain_rev7[] = { 0x02, 0x02, 0x02, 0x02 };
+	u16 aux_adc_gain_rev4[] = { 0x02, 0x02, 0x02, 0x00 };
+	u16 aux_adc_gain_rev3[] = { 0x02, 0x02, 0x02, 0x00 };
+	u16 *aux_adc_gain;
+	u16 sk_adc_vmid[] = { 0xb4, 0xb4, 0xb4, 0x24 };
+	u16 sk_adc_gain[] = { 0x02, 0x02, 0x02, 0x02 };
+	s32 min_nvar_val = 0x18d;
+	s32 min_nvar_offset_6mbps = 20;
+	u8 pdetrange;
+	u8 triso;
+	u16 regval;
+	u16 afectrl_adc_ctrl1_rev7 = 0x20;
+	u16 afectrl_adc_ctrl2_rev7 = 0x0;
+	u16 rfseq_rx2tx_lpf_h_hpc_rev7 = 0x77;
+	u16 rfseq_tx2rx_lpf_h_hpc_rev7 = 0x77;
+	u16 rfseq_pktgn_lpf_h_hpc_rev7 = 0x77;
+	u16 rfseq_htpktgn_lpf_hpc_rev7[] = { 0x77, 0x11, 0x11 };
+	u16 rfseq_pktgn_lpf_hpc_rev7[] = { 0x11, 0x11 };
+	u16 rfseq_cckpktgn_lpf_hpc_rev7[] = { 0x11, 0x11 };
+	u16 ipalvlshift_3p3_war_en = 0;
+	u16 rccal_bcap_val, rccal_scap_val;
+	u16 rccal_tx20_11b_bcap = 0;
+	u16 rccal_tx20_11b_scap = 0;
+	u16 rccal_tx20_11n_bcap = 0;
+	u16 rccal_tx20_11n_scap = 0;
+	u16 rccal_tx40_11n_bcap = 0;
+	u16 rccal_tx40_11n_scap = 0;
+	u16 rx2tx_lpf_rc_lut_tx20_11b = 0;
+	u16 rx2tx_lpf_rc_lut_tx20_11n = 0;
+	u16 rx2tx_lpf_rc_lut_tx40_11n = 0;
+	u16 tx_lpf_bw_ofdm_20mhz = 0;
+	u16 tx_lpf_bw_ofdm_40mhz = 0;
+	u16 tx_lpf_bw_11b = 0;
+	u16 ipa2g_mainbias, ipa2g_casconv, ipa2g_biasfilt;
+	u16 txgm_idac_bleed = 0;
+	bool rccal_ovrd = false;
+	u16 freq;
+	int coreNum;
 
-	mod_phy_reg(pi, 0x283, (0xff << 0), (0x3c << 0));
-	mod_phy_reg(pi, 0x280, (0xff << 0), (0x3c << 0));
+	if (CHSPEC_IS5G(pi->radio_chanspec))
+		wlc_phy_classifier_nphy(pi, NPHY_ClassifierCtrl_cck_en, 0);
+	else
+		wlc_phy_classifier_nphy(pi, NPHY_ClassifierCtrl_cck_en, 1);
 
-	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_GAIN1, 4, 0x8, 8,
-				 lna1_gain_db);
-	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_GAIN2, 4, 0x8, 8,
-				 lna1_gain_db);
+	if (pi->phyhang_avoid)
+		wlc_phy_stay_in_carriersearch_nphy(pi, true);
 
-	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_GAIN1, 4, 0x10, 8,
-				 lna2_gain_db);
-	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_GAIN2, 4, 0x10, 8,
-				 lna2_gain_db);
+	or_phy_reg(pi, 0xb1, NPHY_IQFlip_ADC1 | NPHY_IQFlip_ADC2);
 
-	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_GAIN1, 10, 0x20, 8,
-				 tia_gain_db);
-	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_GAIN2, 10, 0x20, 8,
-				 tia_gain_db);
+	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 
-	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_GAINBITS1, 10, 0x20, 8,
-				 tia_gainbits);
-	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_GAINBITS2, 10, 0x20, 8,
-				 tia_gainbits);
+		if (NREV_IS(pi->pubpi.phy_rev, 7)) {
+			mod_phy_reg(pi, 0x221, (0x1 << 4), (1 << 4));
 
-	write_phy_reg(pi, 0x37, 0x74);
-	write_phy_reg(pi, 0x2ad, 0x74);
-	write_phy_reg(pi, 0x38, 0x18);
-	write_phy_reg(pi, 0x2ae, 0x18);
+			mod_phy_reg(pi, 0x160, (0x7f << 0), (32 << 0));
+			mod_phy_reg(pi, 0x160, (0x7f << 8), (39 << 8));
+			mod_phy_reg(pi, 0x161, (0x7f << 0), (46 << 0));
+			mod_phy_reg(pi, 0x161, (0x7f << 8), (51 << 8));
+			mod_phy_reg(pi, 0x162, (0x7f << 0), (55 << 0));
+			mod_phy_reg(pi, 0x162, (0x7f << 8), (58 << 8));
+			mod_phy_reg(pi, 0x163, (0x7f << 0), (60 << 0));
+			mod_phy_reg(pi, 0x163, (0x7f << 8), (62 << 8));
+			mod_phy_reg(pi, 0x164, (0x7f << 0), (62 << 0));
+			mod_phy_reg(pi, 0x164, (0x7f << 8), (63 << 8));
+			mod_phy_reg(pi, 0x165, (0x7f << 0), (63 << 0));
+			mod_phy_reg(pi, 0x165, (0x7f << 8), (64 << 8));
+			mod_phy_reg(pi, 0x166, (0x7f << 0), (64 << 0));
+			mod_phy_reg(pi, 0x166, (0x7f << 8), (64 << 8));
+			mod_phy_reg(pi, 0x167, (0x7f << 0), (64 << 0));
+			mod_phy_reg(pi, 0x167, (0x7f << 8), (64 << 8));
+		}
+
+		if (NREV_LE(pi->pubpi.phy_rev, 8)) {
+			write_phy_reg(pi, 0x23f, 0x1b0);
+			write_phy_reg(pi, 0x240, 0x1b0);
+		}
+
+		if (NREV_GE(pi->pubpi.phy_rev, 8))
+			mod_phy_reg(pi, 0xbd, (0xff << 0), (114 << 0));
 
-	write_phy_reg(pi, 0x2b, 0xe8);
-	write_phy_reg(pi, 0x41, 0xe8);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x00, 16,
+					 &dac_control);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x10, 16,
+					 &dac_control);
 
-	if (CHSPEC_IS20(pi->radio_chanspec)) {
+		wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_CMPMETRICDATAWEIGHTTBL,
+					1, 0, 32, &leg_data_weights);
+		leg_data_weights = leg_data_weights & 0xffffff;
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_CMPMETRICDATAWEIGHTTBL,
+					 1, 0, 32, &leg_data_weights);
 
-		mod_phy_reg(pi, 0x300, (0x3f << 0), (0x12 << 0));
-		mod_phy_reg(pi, 0x301, (0x3f << 0), (0x12 << 0));
-	} else {
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ,
+					 2, 0x15e, 16,
+					 rfseq_rx2tx_dacbufpu_rev7);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x16e, 16,
+					 rfseq_rx2tx_dacbufpu_rev7);
 
-		mod_phy_reg(pi, 0x300, (0x3f << 0), (0x10 << 0));
-		mod_phy_reg(pi, 0x301, (0x3f << 0), (0x10 << 0));
-	}
-}
+		if (PHY_IPA(pi))
+			wlc_phy_set_rfseq_nphy(pi, NPHY_RFSEQ_RX2TX,
+					       rfseq_rx2tx_events_rev3_ipa,
+					       rfseq_rx2tx_dlys_rev3_ipa,
+					       sizeof
+					       (rfseq_rx2tx_events_rev3_ipa) /
+					       sizeof
+					       (rfseq_rx2tx_events_rev3_ipa
+						[0]));
 
-static void wlc_phy_workarounds_nphy_gainctrl_2057_rev6(struct brcms_phy *pi)
-{
-	u16 currband;
-	s8 lna1G_gain_db_rev7[] = { 9, 14, 19, 24 };
-	s8 *lna1_gain_db = NULL;
-	s8 *lna1_gain_db_2 = NULL;
-	s8 *lna2_gain_db = NULL;
-	s8 tiaA_gain_db_rev7[] = { -9, -6, -3, 0, 3, 3, 3, 3, 3, 3 };
-	s8 *tia_gain_db;
-	s8 tiaA_gainbits_rev7[] = { 0, 1, 2, 3, 4, 4, 4, 4, 4, 4 };
-	s8 *tia_gainbits;
-	u16 rfseqA_init_gain_rev7[] = { 0x624f, 0x624f };
-	u16 *rfseq_init_gain;
-	u16 init_gaincode;
-	u16 clip1hi_gaincode;
-	u16 clip1md_gaincode = 0;
-	u16 clip1md_gaincode_B;
-	u16 clip1lo_gaincode;
-	u16 clip1lo_gaincode_B;
-	u8 crsminl_th = 0;
-	u8 crsminu_th;
-	u16 nbclip_th = 0;
-	u8 w1clip_th;
-	u16 freq;
-	s8 nvar_baseline_offset0 = 0, nvar_baseline_offset1 = 0;
-	u8 chg_nbclip_th = 0;
+		mod_phy_reg(pi, 0x299, (0x3 << 14), (0x1 << 14));
+		mod_phy_reg(pi, 0x29d, (0x3 << 14), (0x1 << 14));
 
-	mod_phy_reg(pi, 0x1c, (0x1 << 13), (1 << 13));
-	mod_phy_reg(pi, 0x32, (0x1 << 13), (1 << 13));
+		tx_lpf_bw_ofdm_20mhz = wlc_phy_read_lpf_bw_ctl_nphy(pi, 0x154);
+		tx_lpf_bw_ofdm_40mhz = wlc_phy_read_lpf_bw_ctl_nphy(pi, 0x159);
+		tx_lpf_bw_11b = wlc_phy_read_lpf_bw_ctl_nphy(pi, 0x152);
 
-	currband = read_phy_reg(pi, 0x09) & NPHY_BandControl_currentBand;
-	if (currband == 0) {
+		if (PHY_IPA(pi)) {
 
-		lna1_gain_db = lna1G_gain_db_rev7;
+			if (((pi->pubpi.radiorev == 5)
+			     && (CHSPEC_IS40(pi->radio_chanspec) == 1))
+			    || (pi->pubpi.radiorev == 7)
+			    || (pi->pubpi.radiorev == 8)) {
 
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_GAIN1, 4, 8, 8,
-					 lna1_gain_db);
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_GAIN2, 4, 8, 8,
-					 lna1_gain_db);
+				rccal_bcap_val =
+					read_radio_reg(
+						pi,
+						RADIO_2057_RCCAL_BCAP_VAL);
+				rccal_scap_val =
+					read_radio_reg(
+						pi,
+						RADIO_2057_RCCAL_SCAP_VAL);
 
-		mod_phy_reg(pi, 0x283, (0xff << 0), (0x40 << 0));
+				rccal_tx20_11b_bcap = rccal_bcap_val;
+				rccal_tx20_11b_scap = rccal_scap_val;
 
-		if (CHSPEC_IS40(pi->radio_chanspec)) {
-			mod_phy_reg(pi, 0x280, (0xff << 0), (0x3e << 0));
-			mod_phy_reg(pi, 0x283, (0xff << 0), (0x3e << 0));
-		}
+				if ((pi->pubpi.radiorev == 5) &&
+				    (CHSPEC_IS40(pi->radio_chanspec) == 1)) {
 
-		mod_phy_reg(pi, 0x289, (0xff << 0), (0x46 << 0));
+					rccal_tx20_11n_bcap = rccal_bcap_val;
+					rccal_tx20_11n_scap = rccal_scap_val;
+					rccal_tx40_11n_bcap = 0xc;
+					rccal_tx40_11n_scap = 0xc;
 
-		if (CHSPEC_IS20(pi->radio_chanspec)) {
-			mod_phy_reg(pi, 0x300, (0x3f << 0), (13 << 0));
-			mod_phy_reg(pi, 0x301, (0x3f << 0), (13 << 0));
-		}
-	} else {
+					rccal_ovrd = true;
 
-		init_gaincode = 0x9e;
-		clip1hi_gaincode = 0x9e;
-		clip1md_gaincode_B = 0x24;
-		clip1lo_gaincode = 0x8a;
-		clip1lo_gaincode_B = 8;
-		rfseq_init_gain = rfseqA_init_gain_rev7;
+				} else if ((pi->pubpi.radiorev == 7)
+					   || (pi->pubpi.radiorev == 8)) {
 
-		tia_gain_db = tiaA_gain_db_rev7;
-		tia_gainbits = tiaA_gainbits_rev7;
+					tx_lpf_bw_ofdm_20mhz = 4;
+					tx_lpf_bw_11b = 1;
 
-		freq = CHAN5G_FREQ(CHSPEC_CHANNEL(pi->radio_chanspec));
-		if (CHSPEC_IS20(pi->radio_chanspec)) {
+					if (CHSPEC_IS2G(pi->radio_chanspec)) {
+						rccal_tx20_11n_bcap = 0xc;
+						rccal_tx20_11n_scap = 0xc;
+						rccal_tx40_11n_bcap = 0xa;
+						rccal_tx40_11n_scap = 0xa;
+					} else {
+						rccal_tx20_11n_bcap = 0x14;
+						rccal_tx20_11n_scap = 0x14;
+						rccal_tx40_11n_bcap = 0xf;
+						rccal_tx40_11n_scap = 0xf;
+					}
 
-			w1clip_th = 25;
-			clip1md_gaincode = 0x82;
+					rccal_ovrd = true;
+				}
+			}
 
-			if ((freq <= 5080) || (freq == 5825)) {
+		} else {
 
-				s8 lna1A_gain_db_rev7[] = { 11, 16, 20, 24 };
-				s8 lna1A_gain_db_2_rev7[] = {
-					11, 17, 22, 25};
-				s8 lna2A_gain_db_rev7[] = { -1, 6, 10, 14 };
+			if (pi->pubpi.radiorev == 5) {
 
-				crsminu_th = 0x3e;
-				lna1_gain_db = lna1A_gain_db_rev7;
-				lna1_gain_db_2 = lna1A_gain_db_2_rev7;
-				lna2_gain_db = lna2A_gain_db_rev7;
-			} else if ((freq >= 5500) && (freq <= 5700)) {
+				tx_lpf_bw_ofdm_20mhz = 1;
+				tx_lpf_bw_ofdm_40mhz = 3;
 
-				s8 lna1A_gain_db_rev7[] = { 11, 17, 21, 25 };
-				s8 lna1A_gain_db_2_rev7[] = {
-					12, 18, 22, 26};
-				s8 lna2A_gain_db_rev7[] = { 1, 8, 12, 16 };
+				rccal_bcap_val =
+					read_radio_reg(
+						pi,
+						RADIO_2057_RCCAL_BCAP_VAL);
+				rccal_scap_val =
+					read_radio_reg(
+						pi,
+						RADIO_2057_RCCAL_SCAP_VAL);
 
-				crsminu_th = 0x45;
-				clip1md_gaincode_B = 0x14;
-				nbclip_th = 0xff;
-				chg_nbclip_th = 1;
-				lna1_gain_db = lna1A_gain_db_rev7;
-				lna1_gain_db_2 = lna1A_gain_db_2_rev7;
-				lna2_gain_db = lna2A_gain_db_rev7;
-			} else {
+				rccal_tx20_11b_bcap = rccal_bcap_val;
+				rccal_tx20_11b_scap = rccal_scap_val;
 
-				s8 lna1A_gain_db_rev7[] = { 12, 18, 22, 26 };
-				s8 lna1A_gain_db_2_rev7[] = {
-					12, 18, 22, 26};
-				s8 lna2A_gain_db_rev7[] = { -1, 6, 10, 14 };
+				rccal_tx20_11n_bcap = 0x13;
+				rccal_tx20_11n_scap = 0x11;
+				rccal_tx40_11n_bcap = 0x13;
+				rccal_tx40_11n_scap = 0x11;
 
-				crsminu_th = 0x41;
-				lna1_gain_db = lna1A_gain_db_rev7;
-				lna1_gain_db_2 = lna1A_gain_db_2_rev7;
-				lna2_gain_db = lna2A_gain_db_rev7;
+				rccal_ovrd = true;
 			}
+		}
 
-			if (freq <= 4920) {
-				nvar_baseline_offset0 = 5;
-				nvar_baseline_offset1 = 5;
-			} else if ((freq > 4920) && (freq <= 5320)) {
-				nvar_baseline_offset0 = 3;
-				nvar_baseline_offset1 = 5;
-			} else if ((freq > 5320) && (freq <= 5700)) {
-				nvar_baseline_offset0 = 3;
-				nvar_baseline_offset1 = 2;
-			} else {
-				nvar_baseline_offset0 = 4;
-				nvar_baseline_offset1 = 0;
+		if (rccal_ovrd) {
+
+			rx2tx_lpf_rc_lut_tx20_11b =
+				(rccal_tx20_11b_bcap << 8) |
+				(rccal_tx20_11b_scap << 3) |
+				tx_lpf_bw_11b;
+			rx2tx_lpf_rc_lut_tx20_11n =
+				(rccal_tx20_11n_bcap << 8) |
+				(rccal_tx20_11n_scap << 3) |
+				tx_lpf_bw_ofdm_20mhz;
+			rx2tx_lpf_rc_lut_tx40_11n =
+				(rccal_tx40_11n_bcap << 8) |
+				(rccal_tx40_11n_scap << 3) |
+				tx_lpf_bw_ofdm_40mhz;
+
+			for (coreNum = 0; coreNum <= 1; coreNum++) {
+				wlc_phy_table_write_nphy(
+					pi, NPHY_TBL_ID_RFSEQ,
+					1,
+					0x152 + coreNum * 0x10,
+					16,
+					&rx2tx_lpf_rc_lut_tx20_11b);
+				wlc_phy_table_write_nphy(
+					pi, NPHY_TBL_ID_RFSEQ,
+					1,
+					0x153 + coreNum * 0x10,
+					16,
+					&rx2tx_lpf_rc_lut_tx20_11n);
+				wlc_phy_table_write_nphy(
+					pi, NPHY_TBL_ID_RFSEQ,
+					1,
+					0x154 + coreNum * 0x10,
+					16,
+					&rx2tx_lpf_rc_lut_tx20_11n);
+				wlc_phy_table_write_nphy(
+					pi, NPHY_TBL_ID_RFSEQ,
+					1,
+					0x155 + coreNum * 0x10,
+					16,
+					&rx2tx_lpf_rc_lut_tx40_11n);
+				wlc_phy_table_write_nphy(
+					pi, NPHY_TBL_ID_RFSEQ,
+					1,
+					0x156 + coreNum * 0x10,
+					16,
+					&rx2tx_lpf_rc_lut_tx40_11n);
+				wlc_phy_table_write_nphy(
+					pi, NPHY_TBL_ID_RFSEQ,
+					1,
+					0x157 + coreNum * 0x10,
+					16,
+					&rx2tx_lpf_rc_lut_tx40_11n);
+				wlc_phy_table_write_nphy(
+					pi, NPHY_TBL_ID_RFSEQ,
+					1,
+					0x158 + coreNum * 0x10,
+					16,
+					&rx2tx_lpf_rc_lut_tx40_11n);
+				wlc_phy_table_write_nphy(
+					pi, NPHY_TBL_ID_RFSEQ,
+					1,
+					0x159 + coreNum * 0x10,
+					16,
+					&rx2tx_lpf_rc_lut_tx40_11n);
 			}
-		} else {
 
-			crsminu_th = 0x3a;
-			crsminl_th = 0x3a;
-			w1clip_th = 20;
-
-			if ((freq >= 4920) && (freq <= 5320)) {
-				nvar_baseline_offset0 = 4;
-				nvar_baseline_offset1 = 5;
-			} else if ((freq > 5320) && (freq <= 5550)) {
-				nvar_baseline_offset0 = 4;
-				nvar_baseline_offset1 = 2;
-			} else {
-				nvar_baseline_offset0 = 5;
-				nvar_baseline_offset1 = 3;
-			}
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 4),
+				1, 0x3, 0,
+				NPHY_REV7_RFCTRLOVERRIDE_ID2);
 		}
 
-		write_phy_reg(pi, 0x20, init_gaincode);
-		write_phy_reg(pi, 0x2a7, init_gaincode);
+		write_phy_reg(pi, 0x32f, 0x3);
 
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ,
-					 pi->pubpi.phy_corenum, 0x106, 16,
-					 rfseq_init_gain);
+		if ((pi->pubpi.radiorev == 4) || (pi->pubpi.radiorev == 6))
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 2),
+				1, 0x3, 0,
+				NPHY_REV7_RFCTRLOVERRIDE_ID0);
 
-		write_phy_reg(pi, 0x22, clip1hi_gaincode);
-		write_phy_reg(pi, 0x2a9, clip1hi_gaincode);
+		if ((pi->pubpi.radiorev == 3) || (pi->pubpi.radiorev == 4) ||
+		    (pi->pubpi.radiorev == 6)) {
+			if ((pi->sh->sromrev >= 8)
+			    && (pi->sh->boardflags2 & BFL2_IPALVLSHIFT_3P3))
+				ipalvlshift_3p3_war_en = 1;
 
-		write_phy_reg(pi, 0x36, clip1md_gaincode_B);
-		write_phy_reg(pi, 0x2ac, clip1md_gaincode_B);
+			if (ipalvlshift_3p3_war_en) {
+				write_radio_reg(pi, RADIO_2057_GPAIO_CONFIG,
+						0x5);
+				write_radio_reg(pi, RADIO_2057_GPAIO_SEL1,
+						0x30);
+				write_radio_reg(pi, RADIO_2057_GPAIO_SEL0, 0x0);
+				or_radio_reg(pi,
+					     RADIO_2057_RXTXBIAS_CONFIG_CORE0,
+					     0x1);
+				or_radio_reg(pi,
+					     RADIO_2057_RXTXBIAS_CONFIG_CORE1,
+					     0x1);
 
-		write_phy_reg(pi, 0x37, clip1lo_gaincode);
-		write_phy_reg(pi, 0x2ad, clip1lo_gaincode);
-		write_phy_reg(pi, 0x38, clip1lo_gaincode_B);
-		write_phy_reg(pi, 0x2ae, clip1lo_gaincode_B);
+				ipa2g_mainbias = 0x1f;
 
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_GAIN1, 10, 0x20, 8,
-					 tia_gain_db);
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_GAIN2, 10, 0x20, 8,
-					 tia_gain_db);
+				ipa2g_casconv = 0x6f;
 
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_GAINBITS1, 10, 0x20, 8,
-					 tia_gainbits);
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_GAINBITS2, 10, 0x20, 8,
-					 tia_gainbits);
+				ipa2g_biasfilt = 0xaa;
+			} else {
 
-		mod_phy_reg(pi, 0x283, (0xff << 0), (crsminu_th << 0));
+				ipa2g_mainbias = 0x2b;
 
-		if (chg_nbclip_th == 1) {
-			write_phy_reg(pi, 0x2b, nbclip_th);
-			write_phy_reg(pi, 0x41, nbclip_th);
+				ipa2g_casconv = 0x7f;
+
+				ipa2g_biasfilt = 0xee;
+			}
+
+			if (CHSPEC_IS2G(pi->radio_chanspec)) {
+				for (coreNum = 0; coreNum <= 1; coreNum++) {
+					WRITE_RADIO_REG4(pi, RADIO_2057, CORE,
+							 coreNum, IPA2G_IMAIN,
+							 ipa2g_mainbias);
+					WRITE_RADIO_REG4(pi, RADIO_2057, CORE,
+							 coreNum, IPA2G_CASCONV,
+							 ipa2g_casconv);
+					WRITE_RADIO_REG4(pi, RADIO_2057, CORE,
+							 coreNum,
+							 IPA2G_BIAS_FILTER,
+							 ipa2g_biasfilt);
+				}
+			}
 		}
 
-		mod_phy_reg(pi, 0x300, (0x3f << 0), (w1clip_th << 0));
-		mod_phy_reg(pi, 0x301, (0x3f << 0), (w1clip_th << 0));
+		if (PHY_IPA(pi)) {
+			if (CHSPEC_IS2G(pi->radio_chanspec)) {
+				if ((pi->pubpi.radiorev == 3)
+				    || (pi->pubpi.radiorev == 4)
+				    || (pi->pubpi.radiorev == 6))
+					txgm_idac_bleed = 0x7f;
 
-		mod_phy_reg(pi, 0x2e4,
-			    (0x3f << 0), (nvar_baseline_offset0 << 0));
+				for (coreNum = 0; coreNum <= 1; coreNum++) {
+					if (txgm_idac_bleed != 0)
+						WRITE_RADIO_REG4(
+							pi, RADIO_2057,
+							CORE, coreNum,
+							TXGM_IDAC_BLEED,
+							txgm_idac_bleed);
+				}
 
-		mod_phy_reg(pi, 0x2e4,
-			    (0x3f << 6), (nvar_baseline_offset1 << 6));
+				if (pi->pubpi.radiorev == 5) {
 
-		if (CHSPEC_IS20(pi->radio_chanspec)) {
+					for (coreNum = 0; coreNum <= 1;
+					     coreNum++) {
+						WRITE_RADIO_REG4(pi, RADIO_2057,
+								 CORE, coreNum,
+								 IPA2G_CASCONV,
+								 0x13);
+						WRITE_RADIO_REG4(pi, RADIO_2057,
+								 CORE, coreNum,
+								 IPA2G_IMAIN,
+								 0x1f);
+						WRITE_RADIO_REG4(
+							pi, RADIO_2057,
+							CORE, coreNum,
+							IPA2G_BIAS_FILTER,
+							0xee);
+						WRITE_RADIO_REG4(pi, RADIO_2057,
+								 CORE, coreNum,
+								 PAD2G_IDACS,
+								 0x8a);
+						WRITE_RADIO_REG4(
+							pi, RADIO_2057,
+							CORE, coreNum,
+							PAD_BIAS_FILTER_BWS,
+							0x3e);
+					}
 
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_GAIN1, 4, 8, 8,
-						 lna1_gain_db);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_GAIN2, 4, 8, 8,
-						 lna1_gain_db_2);
+				} else if ((pi->pubpi.radiorev == 7)
+					   || (pi->pubpi.radiorev == 8)) {
 
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_GAIN1, 4, 0x10,
-						 8, lna2_gain_db);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_GAIN2, 4, 0x10,
-						 8, lna2_gain_db);
+					if (CHSPEC_IS40(pi->radio_chanspec) ==
+					    0) {
+						WRITE_RADIO_REG4(pi, RADIO_2057,
+								 CORE, 0,
+								 IPA2G_IMAIN,
+								 0x14);
+						WRITE_RADIO_REG4(pi, RADIO_2057,
+								 CORE, 1,
+								 IPA2G_IMAIN,
+								 0x12);
+					} else {
+						WRITE_RADIO_REG4(pi, RADIO_2057,
+								 CORE, 0,
+								 IPA2G_IMAIN,
+								 0x16);
+						WRITE_RADIO_REG4(pi, RADIO_2057,
+								 CORE, 1,
+								 IPA2G_IMAIN,
+								 0x16);
+					}
+				}
 
-			write_phy_reg(pi, 0x24, clip1md_gaincode);
-			write_phy_reg(pi, 0x2ab, clip1md_gaincode);
+			} else {
+				freq = CHAN5G_FREQ(CHSPEC_CHANNEL(
+							pi->radio_chanspec));
+				if (((freq >= 5180) && (freq <= 5230))
+				    || ((freq >= 5745) && (freq <= 5805))) {
+					WRITE_RADIO_REG4(pi, RADIO_2057, CORE,
+							 0, IPA5G_BIAS_FILTER,
+							 0xff);
+					WRITE_RADIO_REG4(pi, RADIO_2057, CORE,
+							 1, IPA5G_BIAS_FILTER,
+							 0xff);
+				}
+			}
 		} else {
-			mod_phy_reg(pi, 0x280, (0xff << 0), (crsminl_th << 0));
-		}
-	}
-}
-
-static void wlc_phy_adjust_lnagaintbl_nphy(struct brcms_phy *pi)
-{
-	uint core;
-	int ctr;
-	s16 gain_delta[2];
-	u8 curr_channel;
-	u16 minmax_gain[2];
-	u16 regval[4];
 
-	if (pi->phyhang_avoid)
-		wlc_phy_stay_in_carriersearch_nphy(pi, true);
+			if (pi->pubpi.radiorev != 5) {
+				for (coreNum = 0; coreNum <= 1; coreNum++) {
+					WRITE_RADIO_REG4(pi, RADIO_2057, CORE,
+							 coreNum,
+							 TXMIX2G_TUNE_BOOST_PU,
+							 0x61);
+					WRITE_RADIO_REG4(pi, RADIO_2057, CORE,
+							 coreNum,
+							 TXGM_IDAC_BLEED, 0x70);
+				}
+			}
+		}
 
-	if (pi->nphy_gain_boost) {
-		if ((CHSPEC_IS2G(pi->radio_chanspec))) {
+		if (pi->pubpi.radiorev == 4) {
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1,
+						 0x05, 16,
+						 &afectrl_adc_ctrl1_rev7);
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1,
+						 0x15, 16,
+						 &afectrl_adc_ctrl1_rev7);
 
-			gain_delta[0] = 6;
-			gain_delta[1] = 6;
+			for (coreNum = 0; coreNum <= 1; coreNum++) {
+				WRITE_RADIO_REG4(pi, RADIO_2057, CORE, coreNum,
+						 AFE_VCM_CAL_MASTER, 0x0);
+				WRITE_RADIO_REG4(pi, RADIO_2057, CORE, coreNum,
+						 AFE_SET_VCM_I, 0x3f);
+				WRITE_RADIO_REG4(pi, RADIO_2057, CORE, coreNum,
+						 AFE_SET_VCM_Q, 0x3f);
+			}
 		} else {
+			mod_phy_reg(pi, 0xa6, (0x1 << 2), (0x1 << 2));
+			mod_phy_reg(pi, 0x8f, (0x1 << 2), (0x1 << 2));
+			mod_phy_reg(pi, 0xa7, (0x1 << 2), (0x1 << 2));
+			mod_phy_reg(pi, 0xa5, (0x1 << 2), (0x1 << 2));
 
-			curr_channel = CHSPEC_CHANNEL(pi->radio_chanspec);
-			gain_delta[0] =
-				(s16)
-				PHY_HW_ROUND(((nphy_lnagain_est0[0] *
-					       curr_channel) +
-					      nphy_lnagain_est0[1]), 13);
-			gain_delta[1] =
-				(s16)
-				PHY_HW_ROUND(((nphy_lnagain_est1[0] *
-					       curr_channel) +
-					      nphy_lnagain_est1[1]), 13);
+			mod_phy_reg(pi, 0xa6, (0x1 << 0), 0);
+			mod_phy_reg(pi, 0x8f, (0x1 << 0), (0x1 << 0));
+			mod_phy_reg(pi, 0xa7, (0x1 << 0), 0);
+			mod_phy_reg(pi, 0xa5, (0x1 << 0), (0x1 << 0));
+
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1,
+						 0x05, 16,
+						 &afectrl_adc_ctrl2_rev7);
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1,
+						 0x15, 16,
+						 &afectrl_adc_ctrl2_rev7);
+
+			mod_phy_reg(pi, 0xa6, (0x1 << 2), 0);
+			mod_phy_reg(pi, 0x8f, (0x1 << 2), 0);
+			mod_phy_reg(pi, 0xa7, (0x1 << 2), 0);
+			mod_phy_reg(pi, 0xa5, (0x1 << 2), 0);
 		}
-	} else {
 
-		gain_delta[0] = 0;
-		gain_delta[1] = 0;
-	}
+		write_phy_reg(pi, 0x6a, 0x2);
 
-	for (core = 0; core < pi->pubpi.phy_corenum; core++) {
-		if (pi->nphy_elna_gain_config) {
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1, 256, 32,
+					 &min_nvar_offset_6mbps);
 
-			regval[0] = nphy_def_lnagains[2] + gain_delta[core];
-			regval[1] = nphy_def_lnagains[3] + gain_delta[core];
-			regval[2] = nphy_def_lnagains[3] + gain_delta[core];
-			regval[3] = nphy_def_lnagains[3] + gain_delta[core];
-		} else {
-			for (ctr = 0; ctr < 4; ctr++)
-				regval[ctr] =
-					nphy_def_lnagains[ctr] +
-					gain_delta[core];
-		}
-		wlc_phy_table_write_nphy(pi, core, 4, 8, 16, regval);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x138, 16,
+					 &rfseq_pktgn_lpf_hpc_rev7);
 
-		minmax_gain[core] =
-			(u16) (nphy_def_lnagains[2] + gain_delta[core] + 4);
-	}
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 1, 0x141, 16,
+					 &rfseq_pktgn_lpf_h_hpc_rev7);
 
-	mod_phy_reg(pi, 0x1e, (0xff << 0), (minmax_gain[0] << 0));
-	mod_phy_reg(pi, 0x34, (0xff << 0), (minmax_gain[1] << 0));
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 3, 0x133, 16,
+					 &rfseq_htpktgn_lpf_hpc_rev7);
 
-	if (pi->phyhang_avoid)
-		wlc_phy_stay_in_carriersearch_nphy(pi, false);
-}
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x146, 16,
+					 &rfseq_cckpktgn_lpf_hpc_rev7);
 
-void wlc_phy_switch_radio_nphy(struct brcms_phy *pi, bool on)
-{
-	if (on) {
-		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-			if (!pi->radio_is_on) {
-				wlc_phy_radio_preinit_205x(pi);
-				wlc_phy_radio_init_2057(pi);
-				wlc_phy_radio_postinit_2057(pi);
-			}
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 1, 0x123, 16,
+					 &rfseq_tx2rx_lpf_h_hpc_rev7);
 
-			wlc_phy_chanspec_set((struct brcms_phy_pub *) pi,
-					     pi->radio_chanspec);
-		} else if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-			wlc_phy_radio_preinit_205x(pi);
-			wlc_phy_radio_init_2056(pi);
-			wlc_phy_radio_postinit_2056(pi);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 1, 0x12A, 16,
+					 &rfseq_rx2tx_lpf_h_hpc_rev7);
 
-			wlc_phy_chanspec_set((struct brcms_phy_pub *) pi,
-					     pi->radio_chanspec);
+		if (CHSPEC_IS40(pi->radio_chanspec) == 0) {
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1, 3,
+						 32, &min_nvar_val);
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1,
+						 127, 32, &min_nvar_val);
 		} else {
-			wlc_phy_radio_preinit_2055(pi);
-			wlc_phy_radio_init_2055(pi);
-			wlc_phy_radio_postinit_2055(pi);
+			min_nvar_val = noise_var_tbl_rev7[3];
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1, 3,
+						 32, &min_nvar_val);
+
+			min_nvar_val = noise_var_tbl_rev7[127];
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1,
+						 127, 32, &min_nvar_val);
 		}
 
-		pi->radio_is_on = true;
+		wlc_phy_workarounds_nphy_gainctrl(pi);
 
-	} else {
+		pdetrange =
+			(CHSPEC_IS5G(pi->radio_chanspec)) ? pi->srom_fem5g.
+			pdetrange : pi->srom_fem2g.pdetrange;
 
-		if (NREV_GE(pi->pubpi.phy_rev, 3)
-		    && NREV_LT(pi->pubpi.phy_rev, 7)) {
-			and_phy_reg(pi, 0x78, ~RFCC_CHIP0_PU);
-			mod_radio_reg(pi, RADIO_2056_SYN_COM_PU, 0x2, 0x0);
+		if (pdetrange == 0) {
+			chan_freq_range =
+				wlc_phy_get_chan_freq_range_nphy(pi, 0);
+			if (chan_freq_range != WL_CHAN_FREQ_RANGE_2G) {
+				aux_adc_vmid_rev7_core0[3] = 0x70;
+				aux_adc_vmid_rev7_core1[3] = 0x70;
+				aux_adc_gain_rev7[3] = 2;
+			} else {
+				aux_adc_vmid_rev7_core0[3] = 0x80;
+				aux_adc_vmid_rev7_core1[3] = 0x80;
+				aux_adc_gain_rev7[3] = 3;
+			}
+		} else if (pdetrange == 1) {
+			if (chan_freq_range != WL_CHAN_FREQ_RANGE_2G) {
+				aux_adc_vmid_rev7_core0[3] = 0x7c;
+				aux_adc_vmid_rev7_core1[3] = 0x7c;
+				aux_adc_gain_rev7[3] = 2;
+			} else {
+				aux_adc_vmid_rev7_core0[3] = 0x8c;
+				aux_adc_vmid_rev7_core1[3] = 0x8c;
+				aux_adc_gain_rev7[3] = 1;
+			}
+		} else if (pdetrange == 2) {
+			if (pi->pubpi.radioid == BCM2057_ID) {
+				if ((pi->pubpi.radiorev == 5)
+				    || (pi->pubpi.radiorev == 7)
+				    || (pi->pubpi.radiorev == 8)) {
+					if (chan_freq_range ==
+					    WL_CHAN_FREQ_RANGE_2G) {
+						aux_adc_vmid_rev7_core0[3] =
+							0x8c;
+						aux_adc_vmid_rev7_core1[3] =
+							0x8c;
+						aux_adc_gain_rev7[3] = 0;
+					} else {
+						aux_adc_vmid_rev7_core0[3] =
+							0x96;
+						aux_adc_vmid_rev7_core1[3] =
+							0x96;
+						aux_adc_gain_rev7[3] = 0;
+					}
+				}
+			}
 
-			write_radio_reg(pi,
-					RADIO_2056_TX_PADA_BOOST_TUNE |
-					RADIO_2056_TX0, 0);
-			write_radio_reg(pi,
-					RADIO_2056_TX_PADG_BOOST_TUNE |
-					RADIO_2056_TX0, 0);
-			write_radio_reg(pi,
-					RADIO_2056_TX_PGAA_BOOST_TUNE |
-					RADIO_2056_TX0, 0);
-			write_radio_reg(pi,
-					RADIO_2056_TX_PGAG_BOOST_TUNE |
-					RADIO_2056_TX0, 0);
-			mod_radio_reg(pi,
-				      RADIO_2056_TX_MIXA_BOOST_TUNE |
-				      RADIO_2056_TX0, 0xf0, 0);
-			write_radio_reg(pi,
-					RADIO_2056_TX_MIXG_BOOST_TUNE |
-					RADIO_2056_TX0, 0);
+		} else if (pdetrange == 3) {
+			if (chan_freq_range == WL_CHAN_FREQ_RANGE_2G) {
+				aux_adc_vmid_rev7_core0[3] = 0x89;
+				aux_adc_vmid_rev7_core1[3] = 0x89;
+				aux_adc_gain_rev7[3] = 0;
+			}
 
-			write_radio_reg(pi,
-					RADIO_2056_TX_PADA_BOOST_TUNE |
-					RADIO_2056_TX1, 0);
-			write_radio_reg(pi,
-					RADIO_2056_TX_PADG_BOOST_TUNE |
-					RADIO_2056_TX1, 0);
-			write_radio_reg(pi,
-					RADIO_2056_TX_PGAA_BOOST_TUNE |
-					RADIO_2056_TX1, 0);
-			write_radio_reg(pi,
-					RADIO_2056_TX_PGAG_BOOST_TUNE |
-					RADIO_2056_TX1, 0);
-			mod_radio_reg(pi,
-				      RADIO_2056_TX_MIXA_BOOST_TUNE |
-				      RADIO_2056_TX1, 0xf0, 0);
-			write_radio_reg(pi,
-					RADIO_2056_TX_MIXG_BOOST_TUNE |
-					RADIO_2056_TX1, 0);
+		} else if (pdetrange == 5) {
 
-			pi->radio_is_on = false;
+			if (chan_freq_range != WL_CHAN_FREQ_RANGE_2G) {
+				aux_adc_vmid_rev7_core0[3] = 0x80;
+				aux_adc_vmid_rev7_core1[3] = 0x80;
+				aux_adc_gain_rev7[3] = 3;
+			} else {
+				aux_adc_vmid_rev7_core0[3] = 0x70;
+				aux_adc_vmid_rev7_core1[3] = 0x70;
+				aux_adc_gain_rev7[3] = 2;
+			}
 		}
 
-		if (NREV_GE(pi->pubpi.phy_rev, 8)) {
-			and_phy_reg(pi, 0x78, ~RFCC_CHIP0_PU);
-			pi->radio_is_on = false;
-		}
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4, 0x08, 16,
+					 &aux_adc_vmid_rev7_core0);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4, 0x18, 16,
+					 &aux_adc_vmid_rev7_core1);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4, 0x0c, 16,
+					 &aux_adc_gain_rev7);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4, 0x1c, 16,
+					 &aux_adc_gain_rev7);
 
-	}
-}
+	} else if (NREV_GE(pi->pubpi.phy_rev, 3)) {
 
-static void wlc_phy_radio_preinit_2055(struct brcms_phy *pi)
-{
+		write_phy_reg(pi, 0x23f, 0x1f8);
+		write_phy_reg(pi, 0x240, 0x1f8);
 
-	and_phy_reg(pi, 0x78, ~RFCC_POR_FORCE);
-	or_phy_reg(pi, 0x78, RFCC_CHIP0_PU | RFCC_OE_POR_FORCE);
+		wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_CMPMETRICDATAWEIGHTTBL,
+					1, 0, 32, &leg_data_weights);
+		leg_data_weights = leg_data_weights & 0xffffff;
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_CMPMETRICDATAWEIGHTTBL,
+					 1, 0, 32, &leg_data_weights);
 
-	or_phy_reg(pi, 0x78, RFCC_POR_FORCE);
-}
+		alpha0 = 293;
+		alpha1 = 435;
+		alpha2 = 261;
+		beta0 = 366;
+		beta1 = 205;
+		beta2 = 32;
+		write_phy_reg(pi, 0x145, alpha0);
+		write_phy_reg(pi, 0x146, alpha1);
+		write_phy_reg(pi, 0x147, alpha2);
+		write_phy_reg(pi, 0x148, beta0);
+		write_phy_reg(pi, 0x149, beta1);
+		write_phy_reg(pi, 0x14a, beta2);
 
-static void wlc_phy_radio_init_2055(struct brcms_phy *pi)
-{
-	wlc_phy_init_radio_regs(pi, regs_2055, RADIO_DEFAULT_CORE);
-}
+		write_phy_reg(pi, 0x38, 0xC);
+		write_phy_reg(pi, 0x2ae, 0xC);
 
-static void wlc_phy_radio_postinit_2055(struct brcms_phy *pi)
-{
+		wlc_phy_set_rfseq_nphy(pi, NPHY_RFSEQ_TX2RX,
+				       rfseq_tx2rx_events_rev3,
+				       rfseq_tx2rx_dlys_rev3,
+				       sizeof(rfseq_tx2rx_events_rev3) /
+				       sizeof(rfseq_tx2rx_events_rev3[0]));
+
+		if (PHY_IPA(pi))
+			wlc_phy_set_rfseq_nphy(pi, NPHY_RFSEQ_RX2TX,
+					       rfseq_rx2tx_events_rev3_ipa,
+					       rfseq_rx2tx_dlys_rev3_ipa,
+					       sizeof
+					       (rfseq_rx2tx_events_rev3_ipa) /
+					       sizeof
+					       (rfseq_rx2tx_events_rev3_ipa
+						[0]));
+
+		if ((pi->sh->hw_phyrxchain != 0x3) &&
+		    (pi->sh->hw_phyrxchain != pi->sh->hw_phytxchain)) {
 
-	and_radio_reg(pi, RADIO_2055_MASTER_CNTRL1,
-		      ~(RADIO_2055_JTAGCTRL_MASK | RADIO_2055_JTAGSYNC_MASK));
+			if (PHY_IPA(pi)) {
+				rfseq_rx2tx_dlys_rev3[5] = 59;
+				rfseq_rx2tx_dlys_rev3[6] = 1;
+				rfseq_rx2tx_events_rev3[7] =
+					NPHY_REV3_RFSEQ_CMD_END;
+			}
 
-	if (((pi->sh->sromrev >= 4)
-	     && !(pi->sh->boardflags2 & BFL2_RXBB_INT_REG_DIS))
-	    || ((pi->sh->sromrev < 4))) {
-		and_radio_reg(pi, RADIO_2055_CORE1_RXBB_REGULATOR, 0x7F);
-		and_radio_reg(pi, RADIO_2055_CORE2_RXBB_REGULATOR, 0x7F);
-	}
+			wlc_phy_set_rfseq_nphy(
+				pi, NPHY_RFSEQ_RX2TX,
+				rfseq_rx2tx_events_rev3,
+				rfseq_rx2tx_dlys_rev3,
+				sizeof(rfseq_rx2tx_events_rev3)	/
+				sizeof(rfseq_rx2tx_events_rev3[0]));
+		}
 
-	mod_radio_reg(pi, RADIO_2055_RRCCAL_N_OPT_SEL, 0x3F, 0x2C);
-	write_radio_reg(pi, RADIO_2055_CAL_MISC, 0x3C);
+		if (CHSPEC_IS2G(pi->radio_chanspec))
+			write_phy_reg(pi, 0x6a, 0x2);
+		else
+			write_phy_reg(pi, 0x6a, 0x9c40);
 
-	and_radio_reg(pi, RADIO_2055_CAL_MISC,
-		      ~(RADIO_2055_RRCAL_START | RADIO_2055_RRCAL_RST_N));
+		mod_phy_reg(pi, 0x294, (0xf << 8), (7 << 8));
 
-	or_radio_reg(pi, RADIO_2055_CAL_LPO_CNTRL, RADIO_2055_CAL_LPO_ENABLE);
+		if (CHSPEC_IS40(pi->radio_chanspec) == 0) {
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1, 3,
+						 32, &min_nvar_val);
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1,
+						 127, 32, &min_nvar_val);
+		} else {
+			min_nvar_val = noise_var_tbl_rev3[3];
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1, 3,
+						 32, &min_nvar_val);
 
-	or_radio_reg(pi, RADIO_2055_CAL_MISC, RADIO_2055_RRCAL_RST_N);
+			min_nvar_val = noise_var_tbl_rev3[127];
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1,
+						 127, 32, &min_nvar_val);
+		}
 
-	udelay(1000);
+		wlc_phy_workarounds_nphy_gainctrl(pi);
 
-	or_radio_reg(pi, RADIO_2055_CAL_MISC, RADIO_2055_RRCAL_START);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x00, 16,
+					 &dac_control);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x10, 16,
+					 &dac_control);
 
-	SPINWAIT(((read_radio_reg(pi, RADIO_2055_CAL_COUNTER_OUT2) &
-		   RADIO_2055_RCAL_DONE) != RADIO_2055_RCAL_DONE), 2000);
+		pdetrange =
+			(CHSPEC_IS5G(pi->radio_chanspec)) ? pi->srom_fem5g.
+			pdetrange : pi->srom_fem2g.pdetrange;
 
-	if (WARN((read_radio_reg(pi, RADIO_2055_CAL_COUNTER_OUT2) &
-		  RADIO_2055_RCAL_DONE) != RADIO_2055_RCAL_DONE,
-		 "HW error: radio calibration1\n"))
-		return;
+		if (pdetrange == 0) {
+			if (NREV_GE(pi->pubpi.phy_rev, 4)) {
+				aux_adc_vmid = aux_adc_vmid_rev4;
+				aux_adc_gain = aux_adc_gain_rev4;
+			} else {
+				aux_adc_vmid = aux_adc_vmid_rev3;
+				aux_adc_gain = aux_adc_gain_rev3;
+			}
+			chan_freq_range =
+				wlc_phy_get_chan_freq_range_nphy(pi, 0);
+			if (chan_freq_range != WL_CHAN_FREQ_RANGE_2G) {
+				switch (chan_freq_range) {
+				case WL_CHAN_FREQ_RANGE_5GL:
+					aux_adc_vmid[3] = 0x89;
+					aux_adc_gain[3] = 0;
+					break;
+				case WL_CHAN_FREQ_RANGE_5GM:
+					aux_adc_vmid[3] = 0x89;
+					aux_adc_gain[3] = 0;
+					break;
+				case WL_CHAN_FREQ_RANGE_5GH:
+					aux_adc_vmid[3] = 0x89;
+					aux_adc_gain[3] = 0;
+					break;
+				default:
+					break;
+				}
+			}
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
+						 0x08, 16, aux_adc_vmid);
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
+						 0x18, 16, aux_adc_vmid);
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
+						 0x0c, 16, aux_adc_gain);
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
+						 0x1c, 16, aux_adc_gain);
+		} else if (pdetrange == 1) {
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
+						 0x08, 16, sk_adc_vmid);
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
+						 0x18, 16, sk_adc_vmid);
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
+						 0x0c, 16, sk_adc_gain);
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
+						 0x1c, 16, sk_adc_gain);
+		} else if (pdetrange == 2) {
 
-	and_radio_reg(pi, RADIO_2055_CAL_LPO_CNTRL,
-		      ~(RADIO_2055_CAL_LPO_ENABLE));
+			u16 bcm_adc_vmid[] = { 0xa2, 0xb4, 0xb4, 0x74 };
+			u16 bcm_adc_gain[] = { 0x02, 0x02, 0x02, 0x04 };
 
-	wlc_phy_chanspec_set((struct brcms_phy_pub *) pi, pi->radio_chanspec);
+			if (NREV_GE(pi->pubpi.phy_rev, 6)) {
+				chan_freq_range =
+					wlc_phy_get_chan_freq_range_nphy(pi, 0);
+				if (chan_freq_range != WL_CHAN_FREQ_RANGE_2G) {
+					bcm_adc_vmid[3] = 0x8e;
+					bcm_adc_gain[3] = 0x03;
+				} else {
+					bcm_adc_vmid[3] = 0x94;
+					bcm_adc_gain[3] = 0x03;
+				}
+			} else if (NREV_IS(pi->pubpi.phy_rev, 5)) {
+				bcm_adc_vmid[3] = 0x84;
+				bcm_adc_gain[3] = 0x02;
+			}
 
-	write_radio_reg(pi, RADIO_2055_CORE1_RXBB_LPF, 9);
-	write_radio_reg(pi, RADIO_2055_CORE2_RXBB_LPF, 9);
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
+						 0x08, 16, bcm_adc_vmid);
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
+						 0x18, 16, bcm_adc_vmid);
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
+						 0x0c, 16, bcm_adc_gain);
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
+						 0x1c, 16, bcm_adc_gain);
+		} else if (pdetrange == 3) {
+			chan_freq_range =
+				wlc_phy_get_chan_freq_range_nphy(pi, 0);
+			if ((NREV_GE(pi->pubpi.phy_rev, 4))
+			    && (chan_freq_range == WL_CHAN_FREQ_RANGE_2G)) {
 
-	write_radio_reg(pi, RADIO_2055_CORE1_RXBB_MIDAC_HIPAS, 0x83);
-	write_radio_reg(pi, RADIO_2055_CORE2_RXBB_MIDAC_HIPAS, 0x83);
+				u16 auxadc_vmid[] = {
+					0xa2, 0xb4, 0xb4, 0x270
+				};
+				u16 auxadc_gain[] = {
+					0x02, 0x02, 0x02, 0x00
+				};
 
-	mod_radio_reg(pi, RADIO_2055_CORE1_LNA_GAINBST,
-		      RADIO_2055_GAINBST_VAL_MASK, RADIO_2055_GAINBST_CODE);
-	mod_radio_reg(pi, RADIO_2055_CORE2_LNA_GAINBST,
-		      RADIO_2055_GAINBST_VAL_MASK, RADIO_2055_GAINBST_CODE);
-	if (pi->nphy_gain_boost) {
-		and_radio_reg(pi, RADIO_2055_CORE1_RXRF_SPC1,
-			      ~(RADIO_2055_GAINBST_DISABLE));
-		and_radio_reg(pi, RADIO_2055_CORE2_RXRF_SPC1,
-			      ~(RADIO_2055_GAINBST_DISABLE));
-	} else {
-		or_radio_reg(pi, RADIO_2055_CORE1_RXRF_SPC1,
-			     RADIO_2055_GAINBST_DISABLE);
-		or_radio_reg(pi, RADIO_2055_CORE2_RXRF_SPC1,
-			     RADIO_2055_GAINBST_DISABLE);
-	}
+				wlc_phy_table_write_nphy(pi,
+							 NPHY_TBL_ID_AFECTRL, 4,
+							 0x08, 16, auxadc_vmid);
+				wlc_phy_table_write_nphy(pi,
+							 NPHY_TBL_ID_AFECTRL, 4,
+							 0x18, 16, auxadc_vmid);
+				wlc_phy_table_write_nphy(pi,
+							 NPHY_TBL_ID_AFECTRL, 4,
+							 0x0c, 16, auxadc_gain);
+				wlc_phy_table_write_nphy(pi,
+							 NPHY_TBL_ID_AFECTRL, 4,
+							 0x1c, 16, auxadc_gain);
+			}
+		} else if ((pdetrange == 4) || (pdetrange == 5)) {
+			u16 bcm_adc_vmid[] = { 0xa2, 0xb4, 0xb4, 0x0 };
+			u16 bcm_adc_gain[] = { 0x02, 0x02, 0x02, 0x0 };
+			u16 Vmid[2], Av[2];
 
-	udelay(2);
-}
+			chan_freq_range =
+				wlc_phy_get_chan_freq_range_nphy(pi, 0);
+			if (chan_freq_range != WL_CHAN_FREQ_RANGE_2G) {
+				Vmid[0] = (pdetrange == 4) ? 0x8e : 0x89;
+				Vmid[1] = (pdetrange == 4) ? 0x96 : 0x89;
+				Av[0] = (pdetrange == 4) ? 2 : 0;
+				Av[1] = (pdetrange == 4) ? 2 : 0;
+			} else {
+				Vmid[0] = (pdetrange == 4) ? 0x89 : 0x74;
+				Vmid[1] = (pdetrange == 4) ? 0x8b : 0x70;
+				Av[0] = (pdetrange == 4) ? 2 : 0;
+				Av[1] = (pdetrange == 4) ? 2 : 0;
+			}
 
-static void wlc_phy_radio_preinit_205x(struct brcms_phy *pi)
-{
+			bcm_adc_vmid[3] = Vmid[0];
+			bcm_adc_gain[3] = Av[0];
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
+						 0x08, 16, bcm_adc_vmid);
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
+						 0x0c, 16, bcm_adc_gain);
 
-	and_phy_reg(pi, 0x78, ~RFCC_CHIP0_PU);
-	and_phy_reg(pi, 0x78, RFCC_OE_POR_FORCE);
+			bcm_adc_vmid[3] = Vmid[1];
+			bcm_adc_gain[3] = Av[1];
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
+						 0x18, 16, bcm_adc_vmid);
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 4,
+						 0x1c, 16, bcm_adc_gain);
+		}
 
-	or_phy_reg(pi, 0x78, ~RFCC_OE_POR_FORCE);
-	or_phy_reg(pi, 0x78, RFCC_CHIP0_PU);
+		write_radio_reg(pi,
+				(RADIO_2056_RX_MIXA_MAST_BIAS | RADIO_2056_RX0),
+				0x0);
+		write_radio_reg(pi,
+				(RADIO_2056_RX_MIXA_MAST_BIAS | RADIO_2056_RX1),
+				0x0);
 
-}
+		write_radio_reg(pi,
+				(RADIO_2056_RX_MIXA_BIAS_MAIN | RADIO_2056_RX0),
+				0x6);
+		write_radio_reg(pi,
+				(RADIO_2056_RX_MIXA_BIAS_MAIN | RADIO_2056_RX1),
+				0x6);
 
-static void wlc_phy_radio_init_2056(struct brcms_phy *pi)
-{
-	struct radio_regs *regs_SYN_2056_ptr = NULL;
-	struct radio_regs *regs_TX_2056_ptr = NULL;
-	struct radio_regs *regs_RX_2056_ptr = NULL;
+		write_radio_reg(pi,
+				(RADIO_2056_RX_MIXA_BIAS_AUX | RADIO_2056_RX0),
+				0x7);
+		write_radio_reg(pi,
+				(RADIO_2056_RX_MIXA_BIAS_AUX | RADIO_2056_RX1),
+				0x7);
 
-	if (NREV_IS(pi->pubpi.phy_rev, 3)) {
-		regs_SYN_2056_ptr = regs_SYN_2056;
-		regs_TX_2056_ptr = regs_TX_2056;
-		regs_RX_2056_ptr = regs_RX_2056;
-	} else if (NREV_IS(pi->pubpi.phy_rev, 4)) {
-		regs_SYN_2056_ptr = regs_SYN_2056_A1;
-		regs_TX_2056_ptr = regs_TX_2056_A1;
-		regs_RX_2056_ptr = regs_RX_2056_A1;
-	} else {
-		switch (pi->pubpi.radiorev) {
-		case 5:
-			regs_SYN_2056_ptr = regs_SYN_2056_rev5;
-			regs_TX_2056_ptr = regs_TX_2056_rev5;
-			regs_RX_2056_ptr = regs_RX_2056_rev5;
-			break;
+		write_radio_reg(pi,
+				(RADIO_2056_RX_MIXA_LOB_BIAS | RADIO_2056_RX0),
+				0x88);
+		write_radio_reg(pi,
+				(RADIO_2056_RX_MIXA_LOB_BIAS | RADIO_2056_RX1),
+				0x88);
 
-		case 6:
-			regs_SYN_2056_ptr = regs_SYN_2056_rev6;
-			regs_TX_2056_ptr = regs_TX_2056_rev6;
-			regs_RX_2056_ptr = regs_RX_2056_rev6;
-			break;
+		write_radio_reg(pi,
+				(RADIO_2056_RX_MIXA_CMFB_IDAC | RADIO_2056_RX0),
+				0x0);
+		write_radio_reg(pi,
+				(RADIO_2056_RX_MIXA_CMFB_IDAC | RADIO_2056_RX1),
+				0x0);
 
-		case 7:
-		case 9:
-			regs_SYN_2056_ptr = regs_SYN_2056_rev7;
-			regs_TX_2056_ptr = regs_TX_2056_rev7;
-			regs_RX_2056_ptr = regs_RX_2056_rev7;
-			break;
+		write_radio_reg(pi,
+				(RADIO_2056_RX_MIXG_CMFB_IDAC | RADIO_2056_RX0),
+				0x0);
+		write_radio_reg(pi,
+				(RADIO_2056_RX_MIXG_CMFB_IDAC | RADIO_2056_RX1),
+				0x0);
 
-		case 8:
-			regs_SYN_2056_ptr = regs_SYN_2056_rev8;
-			regs_TX_2056_ptr = regs_TX_2056_rev8;
-			regs_RX_2056_ptr = regs_RX_2056_rev8;
-			break;
+		triso =
+			(CHSPEC_IS5G(pi->radio_chanspec)) ? pi->srom_fem5g.
+			triso : pi->srom_fem2g.triso;
+		if (triso == 7) {
+			wlc_phy_war_force_trsw_to_R_cliplo_nphy(pi, PHY_CORE_0);
+			wlc_phy_war_force_trsw_to_R_cliplo_nphy(pi, PHY_CORE_1);
+		}
 
-		case 11:
-			regs_SYN_2056_ptr = regs_SYN_2056_rev11;
-			regs_TX_2056_ptr = regs_TX_2056_rev11;
-			regs_RX_2056_ptr = regs_RX_2056_rev11;
-			break;
+		wlc_phy_war_txchain_upd_nphy(pi, pi->sh->hw_phytxchain);
 
-		default:
-			break;
+		if (((pi->sh->boardflags2 & BFL2_APLL_WAR) &&
+		     (CHSPEC_IS5G(pi->radio_chanspec))) ||
+		    (((pi->sh->boardflags2 & BFL2_GPLL_WAR) ||
+		      (pi->sh->boardflags2 & BFL2_GPLL_WAR2)) &&
+		     (CHSPEC_IS2G(pi->radio_chanspec)))) {
+			nss1_data_weights = 0x00088888;
+			ht_data_weights = 0x00088888;
+			stbc_data_weights = 0x00088888;
+		} else {
+			nss1_data_weights = 0x88888888;
+			ht_data_weights = 0x88888888;
+			stbc_data_weights = 0x88888888;
 		}
-	}
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_CMPMETRICDATAWEIGHTTBL,
+					 1, 1, 32, &nss1_data_weights);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_CMPMETRICDATAWEIGHTTBL,
+					 1, 2, 32, &ht_data_weights);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_CMPMETRICDATAWEIGHTTBL,
+					 1, 3, 32, &stbc_data_weights);
 
-	wlc_phy_init_radio_regs(pi, regs_SYN_2056_ptr, (u16) RADIO_2056_SYN);
+		if (NREV_IS(pi->pubpi.phy_rev, 4)) {
+			if (CHSPEC_IS5G(pi->radio_chanspec)) {
+				write_radio_reg(pi,
+						RADIO_2056_TX_GMBB_IDAC |
+						RADIO_2056_TX0, 0x70);
+				write_radio_reg(pi,
+						RADIO_2056_TX_GMBB_IDAC |
+						RADIO_2056_TX1, 0x70);
+			}
+		}
 
-	wlc_phy_init_radio_regs(pi, regs_TX_2056_ptr, (u16) RADIO_2056_TX0);
+		if (!pi->edcrs_threshold_lock) {
+			write_phy_reg(pi, 0x224, 0x3eb);
+			write_phy_reg(pi, 0x225, 0x3eb);
+			write_phy_reg(pi, 0x226, 0x341);
+			write_phy_reg(pi, 0x227, 0x341);
+			write_phy_reg(pi, 0x228, 0x42b);
+			write_phy_reg(pi, 0x229, 0x42b);
+			write_phy_reg(pi, 0x22a, 0x381);
+			write_phy_reg(pi, 0x22b, 0x381);
+			write_phy_reg(pi, 0x22c, 0x42b);
+			write_phy_reg(pi, 0x22d, 0x42b);
+			write_phy_reg(pi, 0x22e, 0x381);
+			write_phy_reg(pi, 0x22f, 0x381);
+		}
 
-	wlc_phy_init_radio_regs(pi, regs_TX_2056_ptr, (u16) RADIO_2056_TX1);
+		if (NREV_GE(pi->pubpi.phy_rev, 6)) {
 
-	wlc_phy_init_radio_regs(pi, regs_RX_2056_ptr, (u16) RADIO_2056_RX0);
+			if (pi->sh->boardflags2 & BFL2_SINGLEANT_CCK)
+				wlapi_bmac_mhf(pi->sh->physhim, MHF4,
+					      MHF4_BPHY_TXCORE0,
+					      MHF4_BPHY_TXCORE0, BRCM_BAND_ALL);
+		}
+	} else {
 
-	wlc_phy_init_radio_regs(pi, regs_RX_2056_ptr, (u16) RADIO_2056_RX1);
-}
+		if (pi->sh->boardflags2 & BFL2_SKWRKFEM_BRD ||
+		    (pi->sh->boardtype == 0x8b)) {
+			uint i;
+			u8 war_dlys[] = { 1, 6, 6, 2, 4, 20, 1 };
+			for (i = 0; i < ARRAY_SIZE(rfseq_rx2tx_dlys); i++)
+				rfseq_rx2tx_dlys[i] = war_dlys[i];
+		}
 
-static void wlc_phy_radio_postinit_2056(struct brcms_phy *pi)
-{
-	mod_radio_reg(pi, RADIO_2056_SYN_COM_CTRL, 0xb, 0xb);
+		if (CHSPEC_IS5G(pi->radio_chanspec) && pi->phy_5g_pwrgain) {
+			and_radio_reg(pi, RADIO_2055_CORE1_TX_RF_SPARE, 0xf7);
+			and_radio_reg(pi, RADIO_2055_CORE2_TX_RF_SPARE, 0xf7);
+		} else {
+			or_radio_reg(pi, RADIO_2055_CORE1_TX_RF_SPARE, 0x8);
+			or_radio_reg(pi, RADIO_2055_CORE2_TX_RF_SPARE, 0x8);
+		}
 
-	mod_radio_reg(pi, RADIO_2056_SYN_COM_PU, 0x2, 0x2);
-	mod_radio_reg(pi, RADIO_2056_SYN_COM_RESET, 0x2, 0x2);
-	udelay(1000);
-	mod_radio_reg(pi, RADIO_2056_SYN_COM_RESET, 0x2, 0x0);
+		regval = 0x000a;
+		wlc_phy_table_write_nphy(pi, 8, 1, 0, 16, &regval);
+		wlc_phy_table_write_nphy(pi, 8, 1, 0x10, 16, &regval);
 
-	if ((pi->sh->boardflags2 & BFL2_LEGACY)
-	    || (pi->sh->boardflags2 & BFL2_XTALBUFOUTEN))
-		mod_radio_reg(pi, RADIO_2056_SYN_PLL_MAST2, 0xf4, 0x0);
-	else
-		mod_radio_reg(pi, RADIO_2056_SYN_PLL_MAST2, 0xfc, 0x0);
+		if (NREV_LT(pi->pubpi.phy_rev, 3)) {
+			regval = 0xcdaa;
+			wlc_phy_table_write_nphy(pi, 8, 1, 0x02, 16, &regval);
+			wlc_phy_table_write_nphy(pi, 8, 1, 0x12, 16, &regval);
+		}
 
-	mod_radio_reg(pi, RADIO_2056_SYN_RCCAL_CTRL0, 0x1, 0x0);
+		if (NREV_LT(pi->pubpi.phy_rev, 2)) {
+			regval = 0x0000;
+			wlc_phy_table_write_nphy(pi, 8, 1, 0x08, 16, &regval);
+			wlc_phy_table_write_nphy(pi, 8, 1, 0x18, 16, &regval);
 
-	if (pi->phy_init_por)
-		wlc_phy_radio205x_rcal(pi);
-}
+			regval = 0x7aab;
+			wlc_phy_table_write_nphy(pi, 8, 1, 0x07, 16, &regval);
+			wlc_phy_table_write_nphy(pi, 8, 1, 0x17, 16, &regval);
 
-static void wlc_phy_radio_init_2057(struct brcms_phy *pi)
-{
-	struct radio_20xx_regs *regs_2057_ptr = NULL;
+			regval = 0x0800;
+			wlc_phy_table_write_nphy(pi, 8, 1, 0x06, 16, &regval);
+			wlc_phy_table_write_nphy(pi, 8, 1, 0x16, 16, &regval);
+		}
 
-	if (NREV_IS(pi->pubpi.phy_rev, 7)) {
-		regs_2057_ptr = regs_2057_rev4;
-	} else if (NREV_IS(pi->pubpi.phy_rev, 8)
-		   || NREV_IS(pi->pubpi.phy_rev, 9)) {
-		switch (pi->pubpi.radiorev) {
-		case 5:
+		write_phy_reg(pi, 0xf8, 0x02d8);
+		write_phy_reg(pi, 0xf9, 0x0301);
+		write_phy_reg(pi, 0xfa, 0x02d8);
+		write_phy_reg(pi, 0xfb, 0x0301);
 
-			if (pi->pubpi.radiover == 0x0)
-				regs_2057_ptr = regs_2057_rev5;
-			else if (pi->pubpi.radiover == 0x1)
-				regs_2057_ptr = regs_2057_rev5v1;
-			else
-				break;
+		wlc_phy_set_rfseq_nphy(pi, NPHY_RFSEQ_RX2TX, rfseq_rx2tx_events,
+				       rfseq_rx2tx_dlys,
+				       sizeof(rfseq_rx2tx_events) /
+				       sizeof(rfseq_rx2tx_events[0]));
 
-		case 7:
+		wlc_phy_set_rfseq_nphy(pi, NPHY_RFSEQ_TX2RX, rfseq_tx2rx_events,
+				       rfseq_tx2rx_dlys,
+				       sizeof(rfseq_tx2rx_events) /
+				       sizeof(rfseq_tx2rx_events[0]));
 
-			regs_2057_ptr = regs_2057_rev7;
-			break;
+		wlc_phy_workarounds_nphy_gainctrl(pi);
 
-		case 8:
+		if (NREV_LT(pi->pubpi.phy_rev, 2)) {
 
-			regs_2057_ptr = regs_2057_rev8;
-			break;
+			if (read_phy_reg(pi, 0xa0) & NPHY_MLenable)
+				wlapi_bmac_mhf(pi->sh->physhim, MHF3,
+					       MHF3_NPHY_MLADV_WAR,
+					       MHF3_NPHY_MLADV_WAR,
+					       BRCM_BAND_ALL);
 
-		default:
-			break;
+		} else if (NREV_IS(pi->pubpi.phy_rev, 2)) {
+			write_phy_reg(pi, 0x1e3, 0x0);
+			write_phy_reg(pi, 0x1e4, 0x0);
 		}
-	}
 
-	wlc_phy_init_radio_regs_allbands(pi, regs_2057_ptr);
-}
+		if (NREV_LT(pi->pubpi.phy_rev, 2))
+			mod_phy_reg(pi, 0x90, (0x1 << 7), 0);
 
-static void wlc_phy_radio_postinit_2057(struct brcms_phy *pi)
-{
+		alpha0 = 293;
+		alpha1 = 435;
+		alpha2 = 261;
+		beta0 = 366;
+		beta1 = 205;
+		beta2 = 32;
+		write_phy_reg(pi, 0x145, alpha0);
+		write_phy_reg(pi, 0x146, alpha1);
+		write_phy_reg(pi, 0x147, alpha2);
+		write_phy_reg(pi, 0x148, beta0);
+		write_phy_reg(pi, 0x149, beta1);
+		write_phy_reg(pi, 0x14a, beta2);
 
-	mod_radio_reg(pi, RADIO_2057_XTALPUOVR_PINCTRL, 0x1, 0x1);
+		if (NREV_LT(pi->pubpi.phy_rev, 3)) {
+			mod_phy_reg(pi, 0x142, (0xf << 12), 0);
 
-	mod_radio_reg(pi, RADIO_2057_RFPLL_MISC_CAL_RESETN, 0x78, 0x78);
-	mod_radio_reg(pi, RADIO_2057_XTAL_CONFIG2, 0x80, 0x80);
-	mdelay(2);
-	mod_radio_reg(pi, RADIO_2057_RFPLL_MISC_CAL_RESETN, 0x78, 0x0);
-	mod_radio_reg(pi, RADIO_2057_XTAL_CONFIG2, 0x80, 0x0);
+			write_phy_reg(pi, 0x192, 0xb5);
+			write_phy_reg(pi, 0x193, 0xa4);
+			write_phy_reg(pi, 0x194, 0x0);
+		}
 
-	if (pi->phy_init_por) {
-		wlc_phy_radio205x_rcal(pi);
-		wlc_phy_radio2057_rccal(pi);
+		if (NREV_IS(pi->pubpi.phy_rev, 2))
+			mod_phy_reg(pi, 0x221,
+				    NPHY_FORCESIG_DECODEGATEDCLKS,
+				    NPHY_FORCESIG_DECODEGATEDCLKS);
 	}
 
-	mod_radio_reg(pi, RADIO_2057_RFPLL_MASTER, 0x8, 0x0);
-}
-
-static bool
-wlc_phy_chan2freq_nphy(struct brcms_phy *pi, uint channel, int *f,
-		       struct chan_info_nphy_radio2057 **t0,
-		       struct chan_info_nphy_radio205x **t1,
-		       struct chan_info_nphy_radio2057_rev5 **t2,
-		       struct chan_info_nphy_2055 **t3)
-{
-	uint i;
-	struct chan_info_nphy_radio2057 *chan_info_tbl_p_0 = NULL;
-	struct chan_info_nphy_radio205x *chan_info_tbl_p_1 = NULL;
-	struct chan_info_nphy_radio2057_rev5 *chan_info_tbl_p_2 = NULL;
-	u32 tbl_len = 0;
-
-	int freq = 0;
-
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+	if (pi->phyhang_avoid)
+		wlc_phy_stay_in_carriersearch_nphy(pi, false);
+}
 
-		if (NREV_IS(pi->pubpi.phy_rev, 7)) {
+static void wlc_phy_extpa_set_tx_digi_filts_nphy(struct brcms_phy *pi)
+{
+	int j, type = 2;
+	u16 addr_offset = 0x2c5;
 
-			chan_info_tbl_p_0 = chan_info_nphyrev7_2057_rev4;
-			tbl_len = ARRAY_SIZE(chan_info_nphyrev7_2057_rev4);
+	for (j = 0; j < NPHY_NUM_DIG_FILT_COEFFS; j++)
+		write_phy_reg(pi, addr_offset + j,
+			      NPHY_IPA_REV4_txdigi_filtcoeffs[type][j]);
+}
 
-		} else if (NREV_IS(pi->pubpi.phy_rev, 8)
-			   || NREV_IS(pi->pubpi.phy_rev, 9)) {
-			switch (pi->pubpi.radiorev) {
+static void wlc_phy_clip_det_nphy(struct brcms_phy *pi, u8 write, u16 *vals)
+{
 
-			case 5:
+	if (write == 0) {
+		vals[0] = read_phy_reg(pi, 0x2c);
+		vals[1] = read_phy_reg(pi, 0x42);
+	} else {
+		write_phy_reg(pi, 0x2c, vals[0]);
+		write_phy_reg(pi, 0x42, vals[1]);
+	}
+}
 
-				if (pi->pubpi.radiover == 0x0) {
+static void wlc_phy_ipa_internal_tssi_setup_nphy(struct brcms_phy *pi)
+{
+	u8 core;
 
-					chan_info_tbl_p_2 =
-						chan_info_nphyrev8_2057_rev5;
-					tbl_len = ARRAY_SIZE(
-						  chan_info_nphyrev8_2057_rev5);
+	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+		for (core = 0; core < pi->pubpi.phy_corenum; core++) {
+			if (CHSPEC_IS2G(pi->radio_chanspec)) {
+				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
+						 TX_SSI_MASTER, 0x5);
+				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
+						 TX_SSI_MUX, 0xe);
 
-				} else if (pi->pubpi.radiover == 0x1) {
+				if (pi->pubpi.radiorev != 5)
+					WRITE_RADIO_REG3(pi, RADIO_2057, TX,
+							 core, TSSIA, 0);
 
-					chan_info_tbl_p_2 =
-						chan_info_nphyrev9_2057_rev5v1;
-					tbl_len = ARRAY_SIZE(
-						chan_info_nphyrev9_2057_rev5v1);
+				if (!NREV_IS(pi->pubpi.phy_rev, 7))
+					WRITE_RADIO_REG3(pi, RADIO_2057, TX,
+							 core, TSSIG, 0x1);
+				else
+					WRITE_RADIO_REG3(pi, RADIO_2057, TX,
+							 core, TSSIG, 0x31);
+			} else {
+				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
+						 TX_SSI_MASTER, 0x9);
+				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
+						 TX_SSI_MUX, 0xc);
+				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
+						 TSSIG, 0);
 
+				if (pi->pubpi.radiorev != 5) {
+					if (!NREV_IS(pi->pubpi.phy_rev, 7))
+						WRITE_RADIO_REG3(pi, RADIO_2057,
+								 TX, core,
+								 TSSIA, 0x1);
+					else
+						WRITE_RADIO_REG3(pi, RADIO_2057,
+								 TX, core,
+								 TSSIA, 0x31);
 				}
-				break;
+			}
+			WRITE_RADIO_REG3(pi, RADIO_2057, TX, core, IQCAL_VCM_HG,
+					 0);
+			WRITE_RADIO_REG3(pi, RADIO_2057, TX, core, IQCAL_IDAC,
+					 0);
+			WRITE_RADIO_REG3(pi, RADIO_2057, TX, core, TSSI_VCM,
+					 0x3);
+			WRITE_RADIO_REG3(pi, RADIO_2057, TX, core, TSSI_MISC1,
+					 0x0);
+		}
+	} else {
+		WRITE_RADIO_SYN(pi, RADIO_2056, RESERVED_ADDR31,
+				(CHSPEC_IS2G(pi->radio_chanspec)) ? 0x128 :
+				0x80);
+		WRITE_RADIO_SYN(pi, RADIO_2056, RESERVED_ADDR30, 0x0);
+		WRITE_RADIO_SYN(pi, RADIO_2056, GPIO_MASTER1, 0x29);
 
-			case 7:
-				chan_info_tbl_p_0 =
-					chan_info_nphyrev8_2057_rev7;
-				tbl_len = ARRAY_SIZE(
-						  chan_info_nphyrev8_2057_rev7);
-				break;
+		for (core = 0; core < pi->pubpi.phy_corenum; core++) {
+			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core, IQCAL_VCM_HG,
+					 0x0);
+			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core, IQCAL_IDAC,
+					 0x0);
+			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core, TSSI_VCM,
+					 0x3);
+			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core, TX_AMP_DET,
+					 0x0);
+			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core, TSSI_MISC1,
+					 0x8);
+			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core, TSSI_MISC2,
+					 0x0);
+			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core, TSSI_MISC3,
+					 0x0);
 
-			case 8:
-				chan_info_tbl_p_0 =
-					chan_info_nphyrev8_2057_rev8;
-				tbl_len = ARRAY_SIZE(
-						  chan_info_nphyrev8_2057_rev8);
-				break;
+			if (CHSPEC_IS2G(pi->radio_chanspec)) {
+				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
+						 TX_SSI_MASTER, 0x5);
 
-			default:
-				break;
+				if (pi->pubpi.radiorev != 5)
+					WRITE_RADIO_REG2(pi, RADIO_2056, TX,
+							 core, TSSIA, 0x0);
+				if (NREV_GE(pi->pubpi.phy_rev, 5))
+					WRITE_RADIO_REG2(pi, RADIO_2056, TX,
+							 core, TSSIG, 0x31);
+				else
+					WRITE_RADIO_REG2(pi, RADIO_2056, TX,
+							 core, TSSIG, 0x11);
+				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
+						 TX_SSI_MUX, 0xe);
+			} else {
+				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
+						 TX_SSI_MASTER, 0x9);
+				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
+						 TSSIA, 0x31);
+				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
+						 TSSIG, 0x0);
+				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
+						 TX_SSI_MUX, 0xc);
 			}
-		} else if (NREV_IS(pi->pubpi.phy_rev, 16)) {
-
-			chan_info_tbl_p_0 = chan_info_nphyrev8_2057_rev8;
-			tbl_len = ARRAY_SIZE(chan_info_nphyrev8_2057_rev8);
-		} else {
-			goto fail;
 		}
+	}
+}
 
-		for (i = 0; i < tbl_len; i++) {
-			if (pi->pubpi.radiorev == 5) {
+static void
+wlc_phy_rfctrl_override_nphy(struct brcms_phy *pi, u16 field, u16 value,
+			     u8 core_mask, u8 off)
+{
+	u8 core_num;
+	u16 addr = 0, mask = 0, en_addr = 0, val_addr = 0, en_mask =
+		0, val_mask = 0;
+	u8 shift = 0, val_shift = 0;
 
-				if (chan_info_tbl_p_2[i].chan == channel)
-					break;
-			} else {
+	if (NREV_GE(pi->pubpi.phy_rev, 3) && NREV_LT(pi->pubpi.phy_rev, 7)) {
 
-				if (chan_info_tbl_p_0[i].chan == channel)
-					break;
-			}
-		}
+		en_mask = field;
+		for (core_num = 0; core_num < 2; core_num++) {
 
-		if (i >= tbl_len)
-			goto fail;
+			switch (field) {
+			case (0x1 << 1):
+				en_addr = (core_num == 0) ? 0xe7 : 0xec;
+				val_addr = (core_num == 0) ? 0x7a : 0x7d;
+				val_mask = (0x1 << 0);
+				val_shift = 0;
+				break;
+			case (0x1 << 2):
+				en_addr = (core_num == 0) ? 0xe7 : 0xec;
+				val_addr = (core_num == 0) ? 0x7a : 0x7d;
+				val_mask = (0x1 << 1);
+				val_shift = 1;
+				break;
+			case (0x1 << 3):
+				en_addr = (core_num == 0) ? 0xe7 : 0xec;
+				val_addr = (core_num == 0) ? 0x7a : 0x7d;
+				val_mask = (0x1 << 2);
+				val_shift = 2;
+				break;
+			case (0x1 << 4):
+				en_addr = (core_num == 0) ? 0xe7 : 0xec;
+				val_addr = (core_num == 0) ? 0x7a : 0x7d;
+				val_mask = (0x1 << 4);
+				val_shift = 4;
+				break;
+			case (0x1 << 5):
+				en_addr = (core_num == 0) ? 0xe7 : 0xec;
+				val_addr = (core_num == 0) ? 0x7a : 0x7d;
+				val_mask = (0x1 << 5);
+				val_shift = 5;
+				break;
+			case (0x1 << 6):
+				en_addr = (core_num == 0) ? 0xe7 : 0xec;
+				val_addr = (core_num == 0) ? 0x7a : 0x7d;
+				val_mask = (0x1 << 6);
+				val_shift = 6;
+				break;
+			case (0x1 << 7):
+				en_addr = (core_num == 0) ? 0xe7 : 0xec;
+				val_addr = (core_num == 0) ? 0x7a : 0x7d;
+				val_mask = (0x1 << 7);
+				val_shift = 7;
+				break;
+			case (0x1 << 8):
+				en_addr = (core_num == 0) ? 0xe7 : 0xec;
+				val_addr = (core_num == 0) ? 0x7a : 0x7d;
+				val_mask = (0x7 << 8);
+				val_shift = 8;
+				break;
+			case (0x1 << 11):
+				en_addr = (core_num == 0) ? 0xe7 : 0xec;
+				val_addr = (core_num == 0) ? 0x7a : 0x7d;
+				val_mask = (0x7 << 13);
+				val_shift = 13;
+				break;
 
-		if (pi->pubpi.radiorev == 5) {
-			*t2 = &chan_info_tbl_p_2[i];
-			freq = chan_info_tbl_p_2[i].freq;
-		} else {
-			*t0 = &chan_info_tbl_p_0[i];
-			freq = chan_info_tbl_p_0[i].freq;
-		}
+			case (0x1 << 9):
+				en_addr = (core_num == 0) ? 0xe7 : 0xec;
+				val_addr = (core_num == 0) ? 0xf8 : 0xfa;
+				val_mask = (0x7 << 0);
+				val_shift = 0;
+				break;
 
-	} else if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-		if (NREV_IS(pi->pubpi.phy_rev, 3)) {
-			chan_info_tbl_p_1 = chan_info_nphyrev3_2056;
-			tbl_len = ARRAY_SIZE(chan_info_nphyrev3_2056);
-		} else if (NREV_IS(pi->pubpi.phy_rev, 4)) {
-			chan_info_tbl_p_1 = chan_info_nphyrev4_2056_A1;
-			tbl_len = ARRAY_SIZE(chan_info_nphyrev4_2056_A1);
-		} else if (NREV_IS(pi->pubpi.phy_rev, 5)
-			   || NREV_IS(pi->pubpi.phy_rev, 6)) {
-			switch (pi->pubpi.radiorev) {
-			case 5:
-				chan_info_tbl_p_1 = chan_info_nphyrev5_2056v5;
-				tbl_len = ARRAY_SIZE(chan_info_nphyrev5_2056v5);
+			case (0x1 << 10):
+				en_addr = (core_num == 0) ? 0xe7 : 0xec;
+				val_addr = (core_num == 0) ? 0xf8 : 0xfa;
+				val_mask = (0x7 << 4);
+				val_shift = 4;
 				break;
-			case 6:
-				chan_info_tbl_p_1 = chan_info_nphyrev6_2056v6;
-				tbl_len = ARRAY_SIZE(chan_info_nphyrev6_2056v6);
+
+			case (0x1 << 12):
+				en_addr = (core_num == 0) ? 0xe7 : 0xec;
+				val_addr = (core_num == 0) ? 0x7b : 0x7e;
+				val_mask = (0xffff << 0);
+				val_shift = 0;
 				break;
-			case 7:
-			case 9:
-				chan_info_tbl_p_1 = chan_info_nphyrev5n6_2056v7;
-				tbl_len =
-					ARRAY_SIZE(chan_info_nphyrev5n6_2056v7);
+			case (0x1 << 13):
+				en_addr = (core_num == 0) ? 0xe7 : 0xec;
+				val_addr = (core_num == 0) ? 0x7c : 0x7f;
+				val_mask = (0xffff << 0);
+				val_shift = 0;
 				break;
-			case 8:
-				chan_info_tbl_p_1 = chan_info_nphyrev6_2056v8;
-				tbl_len = ARRAY_SIZE(chan_info_nphyrev6_2056v8);
+			case (0x1 << 14):
+				en_addr = (core_num == 0) ? 0xe7 : 0xec;
+				val_addr = (core_num == 0) ? 0xf9 : 0xfb;
+				val_mask = (0x3 << 6);
+				val_shift = 6;
 				break;
-			case 11:
-				chan_info_tbl_p_1 = chan_info_nphyrev6_2056v11;
-				tbl_len = ARRAY_SIZE(
-						    chan_info_nphyrev6_2056v11);
+			case (0x1 << 0):
+				en_addr = (core_num == 0) ? 0xe5 : 0xe6;
+				val_addr = (core_num == 0) ? 0xf9 : 0xfb;
+				val_mask = (0x1 << 15);
+				val_shift = 15;
 				break;
 			default:
+				addr = 0xffff;
 				break;
 			}
-		}
-
-		for (i = 0; i < tbl_len; i++) {
-			if (chan_info_tbl_p_1[i].chan == channel)
-				break;
-		}
 
-		if (i >= tbl_len)
-			goto fail;
+			if (off) {
+				and_phy_reg(pi, en_addr, ~en_mask);
+				and_phy_reg(pi, val_addr, ~val_mask);
+			} else {
 
-		*t1 = &chan_info_tbl_p_1[i];
-		freq = chan_info_tbl_p_1[i].freq;
+				if ((core_mask == 0)
+				    || (core_mask & (1 << core_num))) {
+					or_phy_reg(pi, en_addr, en_mask);
 
+					if (addr != 0xffff)
+						mod_phy_reg(pi, val_addr,
+							    val_mask,
+							    (value <<
+							     val_shift));
+				}
+			}
+		}
 	} else {
-		for (i = 0; i < ARRAY_SIZE(chan_info_nphy_2055); i++)
-			if (chan_info_nphy_2055[i].chan == channel)
-				break;
-
-		if (i >= ARRAY_SIZE(chan_info_nphy_2055))
-			goto fail;
-
-		*t3 = &chan_info_nphy_2055[i];
-		freq = chan_info_nphy_2055[i].freq;
-	}
-
-	*f = freq;
-	return true;
-
-fail:
-	*f = WL_CHAN_FREQ_RANGE_2G;
-	return false;
-}
-
-u8 wlc_phy_get_chan_freq_range_nphy(struct brcms_phy *pi, uint channel)
-{
-	int freq;
-	struct chan_info_nphy_radio2057 *t0 = NULL;
-	struct chan_info_nphy_radio205x *t1 = NULL;
-	struct chan_info_nphy_radio2057_rev5 *t2 = NULL;
-	struct chan_info_nphy_2055 *t3 = NULL;
-
-	if (channel == 0)
-		channel = CHSPEC_CHANNEL(pi->radio_chanspec);
-
-	wlc_phy_chan2freq_nphy(pi, channel, &freq, &t0, &t1, &t2, &t3);
-
-	if (CHSPEC_IS2G(pi->radio_chanspec))
-		return WL_CHAN_FREQ_RANGE_2G;
-
-	if ((freq >= BASE_LOW_5G_CHAN) && (freq < BASE_MID_5G_CHAN))
-		return WL_CHAN_FREQ_RANGE_5GL;
-	else if ((freq >= BASE_MID_5G_CHAN) && (freq < BASE_HIGH_5G_CHAN))
-		return WL_CHAN_FREQ_RANGE_5GM;
-	else
-		return WL_CHAN_FREQ_RANGE_5GH;
-}
-
-static void
-wlc_phy_chanspec_radio2055_setup(struct brcms_phy *pi,
-				 struct chan_info_nphy_2055 *ci)
-{
-
-	write_radio_reg(pi, RADIO_2055_PLL_REF, ci->RF_pll_ref);
-	write_radio_reg(pi, RADIO_2055_RF_PLL_MOD0, ci->RF_rf_pll_mod0);
-	write_radio_reg(pi, RADIO_2055_RF_PLL_MOD1, ci->RF_rf_pll_mod1);
-	write_radio_reg(pi, RADIO_2055_VCO_CAP_TAIL, ci->RF_vco_cap_tail);
-
-	BRCMS_PHY_WAR_PR51571(pi);
-
-	write_radio_reg(pi, RADIO_2055_VCO_CAL1, ci->RF_vco_cal1);
-	write_radio_reg(pi, RADIO_2055_VCO_CAL2, ci->RF_vco_cal2);
-	write_radio_reg(pi, RADIO_2055_PLL_LF_C1, ci->RF_pll_lf_c1);
-	write_radio_reg(pi, RADIO_2055_PLL_LF_R1, ci->RF_pll_lf_r1);
-
-	BRCMS_PHY_WAR_PR51571(pi);
-
-	write_radio_reg(pi, RADIO_2055_PLL_LF_C2, ci->RF_pll_lf_c2);
-	write_radio_reg(pi, RADIO_2055_LGBUF_CEN_BUF, ci->RF_lgbuf_cen_buf);
-	write_radio_reg(pi, RADIO_2055_LGEN_TUNE1, ci->RF_lgen_tune1);
-	write_radio_reg(pi, RADIO_2055_LGEN_TUNE2, ci->RF_lgen_tune2);
 
-	BRCMS_PHY_WAR_PR51571(pi);
-
-	write_radio_reg(pi, RADIO_2055_CORE1_LGBUF_A_TUNE,
-			ci->RF_core1_lgbuf_a_tune);
-	write_radio_reg(pi, RADIO_2055_CORE1_LGBUF_G_TUNE,
-			ci->RF_core1_lgbuf_g_tune);
-	write_radio_reg(pi, RADIO_2055_CORE1_RXRF_REG1, ci->RF_core1_rxrf_reg1);
-	write_radio_reg(pi, RADIO_2055_CORE1_TX_PGA_PAD_TN,
-			ci->RF_core1_tx_pga_pad_tn);
-
-	BRCMS_PHY_WAR_PR51571(pi);
-
-	write_radio_reg(pi, RADIO_2055_CORE1_TX_MX_BGTRIM,
-			ci->RF_core1_tx_mx_bgtrim);
-	write_radio_reg(pi, RADIO_2055_CORE2_LGBUF_A_TUNE,
-			ci->RF_core2_lgbuf_a_tune);
-	write_radio_reg(pi, RADIO_2055_CORE2_LGBUF_G_TUNE,
-			ci->RF_core2_lgbuf_g_tune);
-	write_radio_reg(pi, RADIO_2055_CORE2_RXRF_REG1, ci->RF_core2_rxrf_reg1);
-
-	BRCMS_PHY_WAR_PR51571(pi);
+		if (off) {
+			and_phy_reg(pi, 0xec, ~field);
+			value = 0x0;
+		} else {
+			or_phy_reg(pi, 0xec, field);
+		}
 
-	write_radio_reg(pi, RADIO_2055_CORE2_TX_PGA_PAD_TN,
-			ci->RF_core2_tx_pga_pad_tn);
-	write_radio_reg(pi, RADIO_2055_CORE2_TX_MX_BGTRIM,
-			ci->RF_core2_tx_mx_bgtrim);
+		for (core_num = 0; core_num < 2; core_num++) {
 
-	udelay(50);
+			switch (field) {
+			case (0x1 << 1):
+			case (0x1 << 9):
+			case (0x1 << 12):
+			case (0x1 << 13):
+			case (0x1 << 14):
+				addr = 0x78;
 
-	write_radio_reg(pi, RADIO_2055_VCO_CAL10, 0x05);
-	write_radio_reg(pi, RADIO_2055_VCO_CAL10, 0x45);
+				core_mask = 0x1;
+				break;
+			case (0x1 << 2):
+			case (0x1 << 3):
+			case (0x1 << 4):
+			case (0x1 << 5):
+			case (0x1 << 6):
+			case (0x1 << 7):
+			case (0x1 << 8):
+				addr = (core_num == 0) ? 0x7a : 0x7d;
+				break;
+			case (0x1 << 10):
+				addr = (core_num == 0) ? 0x7b : 0x7e;
+				break;
+			case (0x1 << 11):
+				addr = (core_num == 0) ? 0x7c : 0x7f;
+				break;
+			default:
+				addr = 0xffff;
+			}
 
-	BRCMS_PHY_WAR_PR51571(pi);
+			switch (field) {
+			case (0x1 << 1):
+				mask = (0x7 << 3);
+				shift = 3;
+				break;
+			case (0x1 << 9):
+				mask = (0x1 << 2);
+				shift = 2;
+				break;
+			case (0x1 << 12):
+				mask = (0x1 << 8);
+				shift = 8;
+				break;
+			case (0x1 << 13):
+				mask = (0x1 << 9);
+				shift = 9;
+				break;
+			case (0x1 << 14):
+				mask = (0xf << 12);
+				shift = 12;
+				break;
+			case (0x1 << 2):
+				mask = (0x1 << 0);
+				shift = 0;
+				break;
+			case (0x1 << 3):
+				mask = (0x1 << 1);
+				shift = 1;
+				break;
+			case (0x1 << 4):
+				mask = (0x1 << 2);
+				shift = 2;
+				break;
+			case (0x1 << 5):
+				mask = (0x3 << 4);
+				shift = 4;
+				break;
+			case (0x1 << 6):
+				mask = (0x3 << 6);
+				shift = 6;
+				break;
+			case (0x1 << 7):
+				mask = (0x1 << 8);
+				shift = 8;
+				break;
+			case (0x1 << 8):
+				mask = (0x1 << 9);
+				shift = 9;
+				break;
+			case (0x1 << 10):
+				mask = 0x1fff;
+				shift = 0x0;
+				break;
+			case (0x1 << 11):
+				mask = 0x1fff;
+				shift = 0x0;
+				break;
+			default:
+				mask = 0x0;
+				shift = 0x0;
+				break;
+			}
 
-	write_radio_reg(pi, RADIO_2055_VCO_CAL10, 0x65);
+			if ((addr != 0xffff) && (core_mask & (1 << core_num)))
+				mod_phy_reg(pi, addr, mask, (value << shift));
+		}
 
-	udelay(300);
+		or_phy_reg(pi, 0xec, (0x1 << 0));
+		or_phy_reg(pi, 0x78, (0x1 << 0));
+		udelay(1);
+		and_phy_reg(pi, 0xec, ~(0x1 << 0));
+	}
 }
 
-static void
-wlc_phy_chanspec_radio2056_setup(struct brcms_phy *pi,
-				 const struct chan_info_nphy_radio205x *ci)
+static void wlc_phy_txpwrctrl_idle_tssi_nphy(struct brcms_phy *pi)
 {
-	struct radio_regs *regs_SYN_2056_ptr = NULL;
-
-	write_radio_reg(pi,
-			RADIO_2056_SYN_PLL_VCOCAL1 | RADIO_2056_SYN,
-			ci->RF_SYN_pll_vcocal1);
-	write_radio_reg(pi, RADIO_2056_SYN_PLL_VCOCAL2 | RADIO_2056_SYN,
-			ci->RF_SYN_pll_vcocal2);
-	write_radio_reg(pi, RADIO_2056_SYN_PLL_REFDIV | RADIO_2056_SYN,
-			ci->RF_SYN_pll_refdiv);
-	write_radio_reg(pi, RADIO_2056_SYN_PLL_MMD2 | RADIO_2056_SYN,
-			ci->RF_SYN_pll_mmd2);
-	write_radio_reg(pi, RADIO_2056_SYN_PLL_MMD1 | RADIO_2056_SYN,
-			ci->RF_SYN_pll_mmd1);
-	write_radio_reg(pi, RADIO_2056_SYN_PLL_LOOPFILTER1 | RADIO_2056_SYN,
-			ci->RF_SYN_pll_loopfilter1);
-	write_radio_reg(pi, RADIO_2056_SYN_PLL_LOOPFILTER2 | RADIO_2056_SYN,
-			ci->RF_SYN_pll_loopfilter2);
-	write_radio_reg(pi, RADIO_2056_SYN_PLL_LOOPFILTER3 | RADIO_2056_SYN,
-			ci->RF_SYN_pll_loopfilter3);
-	write_radio_reg(pi, RADIO_2056_SYN_PLL_LOOPFILTER4 | RADIO_2056_SYN,
-			ci->RF_SYN_pll_loopfilter4);
-	write_radio_reg(pi, RADIO_2056_SYN_PLL_LOOPFILTER5 | RADIO_2056_SYN,
-			ci->RF_SYN_pll_loopfilter5);
-	write_radio_reg(pi, RADIO_2056_SYN_RESERVED_ADDR27 | RADIO_2056_SYN,
-			ci->RF_SYN_reserved_addr27);
-	write_radio_reg(pi, RADIO_2056_SYN_RESERVED_ADDR28 | RADIO_2056_SYN,
-			ci->RF_SYN_reserved_addr28);
-	write_radio_reg(pi, RADIO_2056_SYN_RESERVED_ADDR29 | RADIO_2056_SYN,
-			ci->RF_SYN_reserved_addr29);
-	write_radio_reg(pi, RADIO_2056_SYN_LOGEN_VCOBUF1 | RADIO_2056_SYN,
-			ci->RF_SYN_logen_VCOBUF1);
-	write_radio_reg(pi, RADIO_2056_SYN_LOGEN_MIXER2 | RADIO_2056_SYN,
-			ci->RF_SYN_logen_MIXER2);
-	write_radio_reg(pi, RADIO_2056_SYN_LOGEN_BUF3 | RADIO_2056_SYN,
-			ci->RF_SYN_logen_BUF3);
-	write_radio_reg(pi, RADIO_2056_SYN_LOGEN_BUF4 | RADIO_2056_SYN,
-			ci->RF_SYN_logen_BUF4);
-
-	write_radio_reg(pi,
-			RADIO_2056_RX_LNAA_TUNE | RADIO_2056_RX0,
-			ci->RF_RX0_lnaa_tune);
-	write_radio_reg(pi, RADIO_2056_RX_LNAG_TUNE | RADIO_2056_RX0,
-			ci->RF_RX0_lnag_tune);
-	write_radio_reg(pi, RADIO_2056_TX_INTPAA_BOOST_TUNE | RADIO_2056_TX0,
-			ci->RF_TX0_intpaa_boost_tune);
-	write_radio_reg(pi, RADIO_2056_TX_INTPAG_BOOST_TUNE | RADIO_2056_TX0,
-			ci->RF_TX0_intpag_boost_tune);
-	write_radio_reg(pi, RADIO_2056_TX_PADA_BOOST_TUNE | RADIO_2056_TX0,
-			ci->RF_TX0_pada_boost_tune);
-	write_radio_reg(pi, RADIO_2056_TX_PADG_BOOST_TUNE | RADIO_2056_TX0,
-			ci->RF_TX0_padg_boost_tune);
-	write_radio_reg(pi, RADIO_2056_TX_PGAA_BOOST_TUNE | RADIO_2056_TX0,
-			ci->RF_TX0_pgaa_boost_tune);
-	write_radio_reg(pi, RADIO_2056_TX_PGAG_BOOST_TUNE | RADIO_2056_TX0,
-			ci->RF_TX0_pgag_boost_tune);
-	write_radio_reg(pi, RADIO_2056_TX_MIXA_BOOST_TUNE | RADIO_2056_TX0,
-			ci->RF_TX0_mixa_boost_tune);
-	write_radio_reg(pi, RADIO_2056_TX_MIXG_BOOST_TUNE | RADIO_2056_TX0,
-			ci->RF_TX0_mixg_boost_tune);
+	s32 rssi_buf[4];
+	s32 int_val;
 
-	write_radio_reg(pi,
-			RADIO_2056_RX_LNAA_TUNE | RADIO_2056_RX1,
-			ci->RF_RX1_lnaa_tune);
-	write_radio_reg(pi, RADIO_2056_RX_LNAG_TUNE | RADIO_2056_RX1,
-			ci->RF_RX1_lnag_tune);
-	write_radio_reg(pi, RADIO_2056_TX_INTPAA_BOOST_TUNE | RADIO_2056_TX1,
-			ci->RF_TX1_intpaa_boost_tune);
-	write_radio_reg(pi, RADIO_2056_TX_INTPAG_BOOST_TUNE | RADIO_2056_TX1,
-			ci->RF_TX1_intpag_boost_tune);
-	write_radio_reg(pi, RADIO_2056_TX_PADA_BOOST_TUNE | RADIO_2056_TX1,
-			ci->RF_TX1_pada_boost_tune);
-	write_radio_reg(pi, RADIO_2056_TX_PADG_BOOST_TUNE | RADIO_2056_TX1,
-			ci->RF_TX1_padg_boost_tune);
-	write_radio_reg(pi, RADIO_2056_TX_PGAA_BOOST_TUNE | RADIO_2056_TX1,
-			ci->RF_TX1_pgaa_boost_tune);
-	write_radio_reg(pi, RADIO_2056_TX_PGAG_BOOST_TUNE | RADIO_2056_TX1,
-			ci->RF_TX1_pgag_boost_tune);
-	write_radio_reg(pi, RADIO_2056_TX_MIXA_BOOST_TUNE | RADIO_2056_TX1,
-			ci->RF_TX1_mixa_boost_tune);
-	write_radio_reg(pi, RADIO_2056_TX_MIXG_BOOST_TUNE | RADIO_2056_TX1,
-			ci->RF_TX1_mixg_boost_tune);
+	if (SCAN_RM_IN_PROGRESS(pi) || PLT_INPROG_PHY(pi) || PHY_MUTED(pi))
 
-	if (NREV_IS(pi->pubpi.phy_rev, 3))
-		regs_SYN_2056_ptr = regs_SYN_2056;
-	else if (NREV_IS(pi->pubpi.phy_rev, 4))
-		regs_SYN_2056_ptr = regs_SYN_2056_A1;
-	else {
-		switch (pi->pubpi.radiorev) {
-		case 5:
-			regs_SYN_2056_ptr = regs_SYN_2056_rev5;
-			break;
-		case 6:
-			regs_SYN_2056_ptr = regs_SYN_2056_rev6;
-			break;
-		case 7:
-		case 9:
-			regs_SYN_2056_ptr = regs_SYN_2056_rev7;
-			break;
-		case 8:
-			regs_SYN_2056_ptr = regs_SYN_2056_rev8;
-			break;
-		case 11:
-			regs_SYN_2056_ptr = regs_SYN_2056_rev11;
-			break;
-		}
-	}
-	if (CHSPEC_IS2G(pi->radio_chanspec))
-		write_radio_reg(pi, RADIO_2056_SYN_PLL_CP2 |
-				RADIO_2056_SYN,
-				(u16) regs_SYN_2056_ptr[0x49 - 2].init_g);
-	else
-		write_radio_reg(pi, RADIO_2056_SYN_PLL_CP2 |
-				RADIO_2056_SYN,
-				(u16) regs_SYN_2056_ptr[0x49 - 2].init_a);
+		return;
 
-	if (pi->sh->boardflags2 & BFL2_GPLL_WAR) {
-		if (CHSPEC_IS2G(pi->radio_chanspec)) {
-			write_radio_reg(pi, RADIO_2056_SYN_PLL_LOOPFILTER1 |
-					RADIO_2056_SYN, 0x1f);
-			write_radio_reg(pi, RADIO_2056_SYN_PLL_LOOPFILTER2 |
-					RADIO_2056_SYN, 0x1f);
+	if (PHY_IPA(pi))
+		wlc_phy_ipa_internal_tssi_setup_nphy(pi);
 
-			write_radio_reg(pi,
-					RADIO_2056_SYN_PLL_LOOPFILTER4 |
-					RADIO_2056_SYN, 0xb);
-			write_radio_reg(pi,
-					RADIO_2056_SYN_PLL_CP2 |
-					RADIO_2056_SYN, 0x14);
-		}
-	}
+	if (NREV_GE(pi->pubpi.phy_rev, 7))
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 12),
+						  0, 0x3, 0,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID0);
+	else if (NREV_GE(pi->pubpi.phy_rev, 3))
+		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 13), 0, 3, 0);
 
-	if ((pi->sh->boardflags2 & BFL2_GPLL_WAR2) &&
-	    (CHSPEC_IS2G(pi->radio_chanspec))) {
-		write_radio_reg(pi,
-				RADIO_2056_SYN_PLL_LOOPFILTER1 | RADIO_2056_SYN,
-				0x1f);
-		write_radio_reg(pi,
-				RADIO_2056_SYN_PLL_LOOPFILTER2 | RADIO_2056_SYN,
-				0x1f);
-		write_radio_reg(pi,
-				RADIO_2056_SYN_PLL_LOOPFILTER4 | RADIO_2056_SYN,
-				0xb);
-		write_radio_reg(pi, RADIO_2056_SYN_PLL_CP2 | RADIO_2056_SYN,
-				0x20);
-	}
+	wlc_phy_stopplayback_nphy(pi);
 
-	if (pi->sh->boardflags2 & BFL2_APLL_WAR) {
-		if (CHSPEC_IS5G(pi->radio_chanspec)) {
-			write_radio_reg(pi, RADIO_2056_SYN_PLL_LOOPFILTER1 |
-					RADIO_2056_SYN, 0x1f);
-			write_radio_reg(pi, RADIO_2056_SYN_PLL_LOOPFILTER2 |
-					RADIO_2056_SYN, 0x1f);
-			write_radio_reg(pi, RADIO_2056_SYN_PLL_LOOPFILTER4 |
-					RADIO_2056_SYN, 0x5);
-			write_radio_reg(pi, RADIO_2056_SYN_PLL_CP2 |
-					RADIO_2056_SYN, 0xc);
-		}
-	}
+	wlc_phy_tx_tone_nphy(pi, 4000, 0, 0, 0, false);
 
-	if (PHY_IPA(pi) && CHSPEC_IS2G(pi->radio_chanspec)) {
-		u16 pag_boost_tune;
-		u16 padg_boost_tune;
-		u16 pgag_boost_tune;
-		u16 mixg_boost_tune;
-		u16 bias, cascbias;
-		uint core;
+	udelay(20);
+	int_val =
+		wlc_phy_poll_rssi_nphy(pi, (u8) NPHY_RSSI_SEL_TSSI_2G, rssi_buf,
+				       1);
+	wlc_phy_stopplayback_nphy(pi);
+	wlc_phy_rssisel_nphy(pi, RADIO_MIMO_CORESEL_OFF, 0);
 
-		for (core = 0; core < pi->pubpi.phy_corenum; core++) {
+	if (NREV_GE(pi->pubpi.phy_rev, 7))
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 12),
+						  0, 0x3, 1,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID0);
+	else if (NREV_GE(pi->pubpi.phy_rev, 3))
+		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 13), 0, 3, 1);
 
-			if (NREV_GE(pi->pubpi.phy_rev, 5)) {
+	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
 
-				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
-						 PADG_IDAC, 0xcc);
+		pi->nphy_pwrctrl_info[PHY_CORE_0].idle_tssi_2g =
+			(u8) ((int_val >> 24) & 0xff);
+		pi->nphy_pwrctrl_info[PHY_CORE_0].idle_tssi_5g =
+			(u8) ((int_val >> 24) & 0xff);
 
-				bias = 0x25;
-				cascbias = 0x20;
+		pi->nphy_pwrctrl_info[PHY_CORE_1].idle_tssi_2g =
+			(u8) ((int_val >> 8) & 0xff);
+		pi->nphy_pwrctrl_info[PHY_CORE_1].idle_tssi_5g =
+			(u8) ((int_val >> 8) & 0xff);
+	} else {
+		pi->nphy_pwrctrl_info[PHY_CORE_0].idle_tssi_2g =
+			(u8) ((int_val >> 24) & 0xff);
 
-				if ((pi->sh->chip ==
-				     BCM43224_CHIP_ID)
-				    || (pi->sh->chip ==
-					BCM43225_CHIP_ID)) {
-					if (pi->sh->chippkg ==
-					    BCM43224_FAB_SMIC) {
-						bias = 0x2a;
-						cascbias = 0x38;
-					}
-				}
+		pi->nphy_pwrctrl_info[PHY_CORE_1].idle_tssi_2g =
+			(u8) ((int_val >> 8) & 0xff);
 
-				pag_boost_tune = 0x4;
-				pgag_boost_tune = 0x03;
-				padg_boost_tune = 0x77;
-				mixg_boost_tune = 0x65;
+		pi->nphy_pwrctrl_info[PHY_CORE_0].idle_tssi_5g =
+			(u8) ((int_val >> 16) & 0xff);
+		pi->nphy_pwrctrl_info[PHY_CORE_1].idle_tssi_5g =
+			(u8) ((int_val) & 0xff);
+	}
 
-				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
-						 INTPAG_IMAIN_STAT, bias);
-				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
-						 INTPAG_IAUX_STAT, bias);
-				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
-						 INTPAG_CASCBIAS, cascbias);
+}
 
-				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
-						 INTPAG_BOOST_TUNE,
-						 pag_boost_tune);
-				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
-						 PGAG_BOOST_TUNE,
-						 pgag_boost_tune);
-				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
-						 PADG_BOOST_TUNE,
-						 padg_boost_tune);
-				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
-						 MIXG_BOOST_TUNE,
-						 mixg_boost_tune);
-			} else {
+static void wlc_phy_txpwr_limit_to_tbl_nphy(struct brcms_phy *pi)
+{
+	u8 idx, idx2, i, delta_ind;
 
-				bias = IS40MHZ(pi) ? 0x40 : 0x20;
+	for (idx = TXP_FIRST_CCK; idx <= TXP_LAST_CCK; idx++)
+		pi->adj_pwr_tbl_nphy[idx] = pi->tx_power_offset[idx];
 
-				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
-						 INTPAG_IMAIN_STAT, bias);
-				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
-						 INTPAG_IAUX_STAT, bias);
-				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
-						 INTPAG_CASCBIAS, 0x30);
-			}
-			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core, PA_SPARE1,
-					 0xee);
-		}
-	}
+	for (i = 0; i < 4; i++) {
+		idx2 = 0;
 
-	if (PHY_IPA(pi) && NREV_IS(pi->pubpi.phy_rev, 6)
-	    && CHSPEC_IS5G(pi->radio_chanspec)) {
-		u16 paa_boost_tune;
-		u16 pada_boost_tune;
-		u16 pgaa_boost_tune;
-		u16 mixa_boost_tune;
-		u16 freq, pabias, cascbias;
-		uint core;
+		delta_ind = 0;
 
-		freq = CHAN5G_FREQ(CHSPEC_CHANNEL(pi->radio_chanspec));
+		switch (i) {
+		case 0:
 
-		if (freq < 5150) {
+			if (CHSPEC_IS40(pi->radio_chanspec)
+			    && NPHY_IS_SROM_REINTERPRET) {
+				idx = TXP_FIRST_MCS_40_SISO;
+			} else {
+				idx = (CHSPEC_IS40(pi->radio_chanspec)) ?
+				      TXP_FIRST_OFDM_40_SISO : TXP_FIRST_OFDM;
+				delta_ind = 1;
+			}
+			break;
 
-			paa_boost_tune = 0xa;
-			pada_boost_tune = 0x77;
-			pgaa_boost_tune = 0xf;
-			mixa_boost_tune = 0xf;
-		} else if (freq < 5340) {
+		case 1:
 
-			paa_boost_tune = 0x8;
-			pada_boost_tune = 0x77;
-			pgaa_boost_tune = 0xfb;
-			mixa_boost_tune = 0xf;
-		} else if (freq < 5650) {
+			idx = (CHSPEC_IS40(pi->radio_chanspec)) ?
+			      TXP_FIRST_MCS_40_CDD : TXP_FIRST_MCS_20_CDD;
+			break;
 
-			paa_boost_tune = 0x0;
-			pada_boost_tune = 0x77;
-			pgaa_boost_tune = 0xb;
-			mixa_boost_tune = 0xf;
-		} else {
+		case 2:
 
-			paa_boost_tune = 0x0;
-			pada_boost_tune = 0x77;
-			if (freq != 5825)
-				pgaa_boost_tune = -(int)(freq - 18) / 36 + 168;
-			else
-				pgaa_boost_tune = 6;
+			idx = (CHSPEC_IS40(pi->radio_chanspec)) ?
+			      TXP_FIRST_MCS_40_STBC : TXP_FIRST_MCS_20_STBC;
+			break;
 
-			mixa_boost_tune = 0xf;
+		case 3:
+
+			idx = (CHSPEC_IS40(pi->radio_chanspec)) ?
+			      TXP_FIRST_MCS_40_SDM : TXP_FIRST_MCS_20_SDM;
+			break;
 		}
 
-		for (core = 0; core < pi->pubpi.phy_corenum; core++) {
-			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
-					 INTPAA_BOOST_TUNE, paa_boost_tune);
-			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
-					 PADA_BOOST_TUNE, pada_boost_tune);
-			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
-					 PGAA_BOOST_TUNE, pgaa_boost_tune);
-			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
-					 MIXA_BOOST_TUNE, mixa_boost_tune);
+		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
+			pi->tx_power_offset[idx];
+		idx = idx + delta_ind;
+		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
+			pi->tx_power_offset[idx];
+		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
+			pi->tx_power_offset[idx];
+		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
+			pi->tx_power_offset[idx++];
 
-			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
-					 TXSPARE1, 0x30);
-			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
-					 PA_SPARE2, 0xee);
+		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
+			pi->tx_power_offset[idx++];
+		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
+			pi->tx_power_offset[idx];
+		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
+			pi->tx_power_offset[idx];
+		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
+			pi->tx_power_offset[idx++];
 
-			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
-					 PADA_CASCBIAS, 0x3);
+		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
+			pi->tx_power_offset[idx++];
+		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
+			pi->tx_power_offset[idx];
+		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
+			pi->tx_power_offset[idx];
+		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
+			pi->tx_power_offset[idx++];
 
-			cascbias = 0x30;
+		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
+			pi->tx_power_offset[idx];
+		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
+			pi->tx_power_offset[idx++];
+		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
+			pi->tx_power_offset[idx];
+		idx = idx + 1 - delta_ind;
+		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
+			pi->tx_power_offset[idx];
 
-			if ((pi->sh->chip == BCM43224_CHIP_ID) ||
-			    (pi->sh->chip == BCM43225_CHIP_ID)) {
-				if (pi->sh->chippkg == BCM43224_FAB_SMIC)
-					cascbias = 0x35;
-			}
+		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
+			pi->tx_power_offset[idx];
+		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
+			pi->tx_power_offset[idx];
+		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
+			pi->tx_power_offset[idx];
+		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
+			pi->tx_power_offset[idx];
+	}
+}
 
-			pabias = (pi->phy_pabias == 0) ? 0x30 : pi->phy_pabias;
+static void wlc_phy_txpwrctrl_pwr_setup_nphy(struct brcms_phy *pi)
+{
+	u32 idx;
+	s16 a1[2], b0[2], b1[2];
+	s8 target_pwr_qtrdbm[2];
+	s32 num, den, pwr_est;
+	u8 chan_freq_range;
+	u8 idle_tssi[2];
+	u32 tbl_id, tbl_len, tbl_offset;
+	u32 regval[64];
+	u8 core;
 
-			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
-					 INTPAA_IAUX_STAT, pabias);
-			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
-					 INTPAA_IMAIN_STAT, pabias);
-			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
-					 INTPAA_CASCBIAS, cascbias);
-		}
+	if (D11REV_IS(pi->sh->corerev, 11) || D11REV_IS(pi->sh->corerev, 12)) {
+		wlapi_bmac_mctrl(pi->sh->physhim, MCTL_PHYLOCK, MCTL_PHYLOCK);
+		(void)R_REG(&pi->regs->maccontrol);
+		udelay(1);
 	}
 
-	udelay(50);
+	if (pi->phyhang_avoid)
+		wlc_phy_stay_in_carriersearch_nphy(pi, true);
 
-	wlc_phy_radio205x_vcocal_nphy(pi);
-}
+	or_phy_reg(pi, 0x122, (0x1 << 0));
 
-void wlc_phy_radio205x_vcocal_nphy(struct brcms_phy *pi)
-{
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-		mod_radio_reg(pi, RADIO_2057_RFPLL_MISC_EN, 0x01, 0x0);
-		mod_radio_reg(pi, RADIO_2057_RFPLL_MISC_CAL_RESETN, 0x04, 0x0);
-		mod_radio_reg(pi, RADIO_2057_RFPLL_MISC_CAL_RESETN, 0x04,
-			      (1 << 2));
-		mod_radio_reg(pi, RADIO_2057_RFPLL_MISC_EN, 0x01, 0x01);
-	} else if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-		write_radio_reg(pi, RADIO_2056_SYN_PLL_VCOCAL12, 0x0);
-		write_radio_reg(pi, RADIO_2056_SYN_PLL_MAST3, 0x38);
-		write_radio_reg(pi, RADIO_2056_SYN_PLL_MAST3, 0x18);
-		write_radio_reg(pi, RADIO_2056_SYN_PLL_MAST3, 0x38);
-		write_radio_reg(pi, RADIO_2056_SYN_PLL_MAST3, 0x39);
+	if (NREV_GE(pi->pubpi.phy_rev, 3))
+		and_phy_reg(pi, 0x1e7, (u16) (~(0x1 << 15)));
+	else
+		or_phy_reg(pi, 0x1e7, (0x1 << 15));
+
+	if (D11REV_IS(pi->sh->corerev, 11) || D11REV_IS(pi->sh->corerev, 12))
+		wlapi_bmac_mctrl(pi->sh->physhim, MCTL_PHYLOCK, 0);
+
+	if (pi->sh->sromrev < 4) {
+		idle_tssi[0] = pi->nphy_pwrctrl_info[0].idle_tssi_2g;
+		idle_tssi[1] = pi->nphy_pwrctrl_info[1].idle_tssi_2g;
+		target_pwr_qtrdbm[0] = 13 * 4;
+		target_pwr_qtrdbm[1] = 13 * 4;
+		a1[0] = -424;
+		a1[1] = -424;
+		b0[0] = 5612;
+		b0[1] = 5612;
+		b1[1] = -1393;
+		b1[0] = -1393;
+	} else {
+
+		chan_freq_range = wlc_phy_get_chan_freq_range_nphy(pi, 0);
+		switch (chan_freq_range) {
+		case WL_CHAN_FREQ_RANGE_2G:
+			idle_tssi[0] = pi->nphy_pwrctrl_info[0].idle_tssi_2g;
+			idle_tssi[1] = pi->nphy_pwrctrl_info[1].idle_tssi_2g;
+			target_pwr_qtrdbm[0] =
+				pi->nphy_pwrctrl_info[0].max_pwr_2g;
+			target_pwr_qtrdbm[1] =
+				pi->nphy_pwrctrl_info[1].max_pwr_2g;
+			a1[0] = pi->nphy_pwrctrl_info[0].pwrdet_2g_a1;
+			a1[1] = pi->nphy_pwrctrl_info[1].pwrdet_2g_a1;
+			b0[0] = pi->nphy_pwrctrl_info[0].pwrdet_2g_b0;
+			b0[1] = pi->nphy_pwrctrl_info[1].pwrdet_2g_b0;
+			b1[0] = pi->nphy_pwrctrl_info[0].pwrdet_2g_b1;
+			b1[1] = pi->nphy_pwrctrl_info[1].pwrdet_2g_b1;
+			break;
+		case WL_CHAN_FREQ_RANGE_5GL:
+			idle_tssi[0] = pi->nphy_pwrctrl_info[0].idle_tssi_5g;
+			idle_tssi[1] = pi->nphy_pwrctrl_info[1].idle_tssi_5g;
+			target_pwr_qtrdbm[0] =
+				pi->nphy_pwrctrl_info[0].max_pwr_5gl;
+			target_pwr_qtrdbm[1] =
+				pi->nphy_pwrctrl_info[1].max_pwr_5gl;
+			a1[0] = pi->nphy_pwrctrl_info[0].pwrdet_5gl_a1;
+			a1[1] = pi->nphy_pwrctrl_info[1].pwrdet_5gl_a1;
+			b0[0] = pi->nphy_pwrctrl_info[0].pwrdet_5gl_b0;
+			b0[1] = pi->nphy_pwrctrl_info[1].pwrdet_5gl_b0;
+			b1[0] = pi->nphy_pwrctrl_info[0].pwrdet_5gl_b1;
+			b1[1] = pi->nphy_pwrctrl_info[1].pwrdet_5gl_b1;
+			break;
+		case WL_CHAN_FREQ_RANGE_5GM:
+			idle_tssi[0] = pi->nphy_pwrctrl_info[0].idle_tssi_5g;
+			idle_tssi[1] = pi->nphy_pwrctrl_info[1].idle_tssi_5g;
+			target_pwr_qtrdbm[0] =
+				pi->nphy_pwrctrl_info[0].max_pwr_5gm;
+			target_pwr_qtrdbm[1] =
+				pi->nphy_pwrctrl_info[1].max_pwr_5gm;
+			a1[0] = pi->nphy_pwrctrl_info[0].pwrdet_5gm_a1;
+			a1[1] = pi->nphy_pwrctrl_info[1].pwrdet_5gm_a1;
+			b0[0] = pi->nphy_pwrctrl_info[0].pwrdet_5gm_b0;
+			b0[1] = pi->nphy_pwrctrl_info[1].pwrdet_5gm_b0;
+			b1[0] = pi->nphy_pwrctrl_info[0].pwrdet_5gm_b1;
+			b1[1] = pi->nphy_pwrctrl_info[1].pwrdet_5gm_b1;
+			break;
+		case WL_CHAN_FREQ_RANGE_5GH:
+			idle_tssi[0] = pi->nphy_pwrctrl_info[0].idle_tssi_5g;
+			idle_tssi[1] = pi->nphy_pwrctrl_info[1].idle_tssi_5g;
+			target_pwr_qtrdbm[0] =
+				pi->nphy_pwrctrl_info[0].max_pwr_5gh;
+			target_pwr_qtrdbm[1] =
+				pi->nphy_pwrctrl_info[1].max_pwr_5gh;
+			a1[0] = pi->nphy_pwrctrl_info[0].pwrdet_5gh_a1;
+			a1[1] = pi->nphy_pwrctrl_info[1].pwrdet_5gh_a1;
+			b0[0] = pi->nphy_pwrctrl_info[0].pwrdet_5gh_b0;
+			b0[1] = pi->nphy_pwrctrl_info[1].pwrdet_5gh_b0;
+			b1[0] = pi->nphy_pwrctrl_info[0].pwrdet_5gh_b1;
+			b1[1] = pi->nphy_pwrctrl_info[1].pwrdet_5gh_b1;
+			break;
+		default:
+			idle_tssi[0] = pi->nphy_pwrctrl_info[0].idle_tssi_2g;
+			idle_tssi[1] = pi->nphy_pwrctrl_info[1].idle_tssi_2g;
+			target_pwr_qtrdbm[0] = 13 * 4;
+			target_pwr_qtrdbm[1] = 13 * 4;
+			a1[0] = -424;
+			a1[1] = -424;
+			b0[0] = 5612;
+			b0[1] = 5612;
+			b1[1] = -1393;
+			b1[0] = -1393;
+			break;
+		}
 	}
 
-	udelay(300);
-}
-
-#define MAX_205x_RCAL_WAITLOOPS 10000
-
-static u16 wlc_phy_radio205x_rcal(struct brcms_phy *pi)
-{
-	u16 rcal_reg = 0;
-	int i;
-
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-
-		if (pi->pubpi.radiorev == 5) {
-
-			and_phy_reg(pi, 0x342, ~(0x1 << 1));
-
-			udelay(10);
-
-			mod_radio_reg(pi, RADIO_2057_IQTEST_SEL_PU, 0x1, 0x1);
-			mod_radio_reg(pi, RADIO_2057v7_IQTEST_SEL_PU2, 0x2,
-				      0x1);
-		}
-		mod_radio_reg(pi, RADIO_2057_RCAL_CONFIG, 0x1, 0x1);
+	target_pwr_qtrdbm[0] = (s8) pi->tx_power_max;
+	target_pwr_qtrdbm[1] = (s8) pi->tx_power_max;
 
-		udelay(10);
+	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+		if (pi->srom_fem2g.tssipos)
+			or_phy_reg(pi, 0x1e9, (0x1 << 14));
 
-		mod_radio_reg(pi, RADIO_2057_RCAL_CONFIG, 0x3, 0x3);
+		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+			for (core = 0; core <= 1; core++) {
+				if (PHY_IPA(pi)) {
+					if (CHSPEC_IS2G(pi->radio_chanspec))
+						WRITE_RADIO_REG3(pi, RADIO_2057,
+								 TX, core,
+								 TX_SSI_MUX,
+								 0xe);
+					else
+						WRITE_RADIO_REG3(pi, RADIO_2057,
+								 TX, core,
+								 TX_SSI_MUX,
+								 0xc);
+				}
+			}
+		} else {
+			if (PHY_IPA(pi)) {
 
-		for (i = 0; i < MAX_205x_RCAL_WAITLOOPS; i++) {
-			rcal_reg = read_radio_reg(pi, RADIO_2057_RCAL_STATUS);
-			if (rcal_reg & 0x1)
-				break;
+				write_radio_reg(pi, RADIO_2056_TX_TX_SSI_MUX |
+						RADIO_2056_TX0,
+						(CHSPEC_IS5G
+						 (pi->radio_chanspec)) ?
+						 0xc : 0xe);
+				write_radio_reg(pi,
+						RADIO_2056_TX_TX_SSI_MUX |
+						RADIO_2056_TX1,
+						(CHSPEC_IS5G
+						 (pi->radio_chanspec)) ?
+						 0xc : 0xe);
+			} else {
 
-			udelay(100);
+				write_radio_reg(pi, RADIO_2056_TX_TX_SSI_MUX |
+						RADIO_2056_TX0, 0x11);
+				write_radio_reg(pi, RADIO_2056_TX_TX_SSI_MUX |
+						RADIO_2056_TX1, 0x11);
+			}
 		}
+	}
 
-		if (WARN(i == MAX_205x_RCAL_WAITLOOPS,
-			 "HW error: radio calib2"))
-			return 0;
-
-		mod_radio_reg(pi, RADIO_2057_RCAL_CONFIG, 0x2, 0x0);
-
-		rcal_reg = read_radio_reg(pi, RADIO_2057_RCAL_STATUS) & 0x3e;
-
-		mod_radio_reg(pi, RADIO_2057_RCAL_CONFIG, 0x1, 0x0);
-		if (pi->pubpi.radiorev == 5) {
-
-			mod_radio_reg(pi, RADIO_2057_IQTEST_SEL_PU, 0x1, 0x0);
-			mod_radio_reg(pi, RADIO_2057v7_IQTEST_SEL_PU2, 0x2,
-				      0x0);
-		}
+	if (D11REV_IS(pi->sh->corerev, 11) || D11REV_IS(pi->sh->corerev, 12)) {
+		wlapi_bmac_mctrl(pi->sh->physhim, MCTL_PHYLOCK, MCTL_PHYLOCK);
+		(void)R_REG(&pi->regs->maccontrol);
+		udelay(1);
+	}
 
-		if ((pi->pubpi.radiorev <= 4) || (pi->pubpi.radiorev == 6)) {
+	if (NREV_GE(pi->pubpi.phy_rev, 7))
+		mod_phy_reg(pi, 0x1e7, (0x7f << 0),
+			    (NPHY_TxPwrCtrlCmd_pwrIndex_init_rev7 << 0));
+	else
+		mod_phy_reg(pi, 0x1e7, (0x7f << 0),
+			    (NPHY_TxPwrCtrlCmd_pwrIndex_init << 0));
 
-			mod_radio_reg(pi, RADIO_2057_TEMPSENSE_CONFIG, 0x3c,
-				      rcal_reg);
-			mod_radio_reg(pi, RADIO_2057_BANDGAP_RCAL_TRIM, 0xf0,
-				      rcal_reg << 2);
-		}
+	if (NREV_GE(pi->pubpi.phy_rev, 7))
+		mod_phy_reg(pi, 0x222, (0xff << 0),
+			    (NPHY_TxPwrCtrlCmd_pwrIndex_init_rev7 << 0));
+	else if (NREV_GT(pi->pubpi.phy_rev, 1))
+		mod_phy_reg(pi, 0x222, (0xff << 0),
+			    (NPHY_TxPwrCtrlCmd_pwrIndex_init << 0));
 
-	} else if (NREV_IS(pi->pubpi.phy_rev, 3)) {
-		u16 savereg;
+	if (D11REV_IS(pi->sh->corerev, 11) || D11REV_IS(pi->sh->corerev, 12))
+		wlapi_bmac_mctrl(pi->sh->physhim, MCTL_PHYLOCK, 0);
 
-		savereg =
-			read_radio_reg(
-				pi,
-				RADIO_2056_SYN_PLL_MAST2 |
-				RADIO_2056_SYN);
-		write_radio_reg(pi, RADIO_2056_SYN_PLL_MAST2 | RADIO_2056_SYN,
-				savereg | 0x7);
-		udelay(10);
+	write_phy_reg(pi, 0x1e8, (0x3 << 8) | (240 << 0));
 
-		write_radio_reg(pi, RADIO_2056_SYN_RCAL_MASTER | RADIO_2056_SYN,
-				0x1);
-		udelay(10);
+	write_phy_reg(pi, 0x1e9,
+		      (1 << 15) | (idle_tssi[0] << 0) | (idle_tssi[1] << 8));
 
-		write_radio_reg(pi, RADIO_2056_SYN_RCAL_MASTER | RADIO_2056_SYN,
-				0x9);
+	write_phy_reg(pi, 0x1ea,
+		      (target_pwr_qtrdbm[0] << 0) |
+		      (target_pwr_qtrdbm[1] << 8));
 
-		for (i = 0; i < MAX_205x_RCAL_WAITLOOPS; i++) {
-			rcal_reg = read_radio_reg(
-				pi,
-				RADIO_2056_SYN_RCAL_CODE_OUT |
-				RADIO_2056_SYN);
-			if (rcal_reg & 0x80)
-				break;
+	tbl_len = 64;
+	tbl_offset = 0;
+	for (tbl_id = NPHY_TBL_ID_CORE1TXPWRCTL;
+	     tbl_id <= NPHY_TBL_ID_CORE2TXPWRCTL; tbl_id++) {
 
-			udelay(100);
+		for (idx = 0; idx < tbl_len; idx++) {
+			num = 8 *
+			      (16 * b0[tbl_id - 26] + b1[tbl_id - 26] * idx);
+			den = 32768 + a1[tbl_id - 26] * idx;
+			pwr_est = max(((4 * num + den / 2) / den), -8);
+			if (NREV_LT(pi->pubpi.phy_rev, 3)) {
+				if (idx <=
+				    (uint) (31 - idle_tssi[tbl_id - 26] + 1))
+					pwr_est =
+						max(pwr_est,
+						    target_pwr_qtrdbm
+						    [tbl_id - 26] + 1);
+			}
+			regval[idx] = (u32) pwr_est;
 		}
-
-		if (WARN(i == MAX_205x_RCAL_WAITLOOPS,
-			 "HW error: radio calib3"))
-			return 0;
-
-		write_radio_reg(pi, RADIO_2056_SYN_RCAL_MASTER | RADIO_2056_SYN,
-				0x1);
-
-		rcal_reg =
-			read_radio_reg(pi,
-				       RADIO_2056_SYN_RCAL_CODE_OUT |
-				       RADIO_2056_SYN);
-
-		write_radio_reg(pi, RADIO_2056_SYN_RCAL_MASTER | RADIO_2056_SYN,
-				0x0);
-
-		write_radio_reg(pi, RADIO_2056_SYN_PLL_MAST2 | RADIO_2056_SYN,
-				savereg);
-
-		return rcal_reg & 0x1f;
+		wlc_phy_table_write_nphy(pi, tbl_id, tbl_len, tbl_offset, 32,
+					 regval);
 	}
-	return rcal_reg & 0x3e;
-}
-
-static void
-wlc_phy_chanspec_radio2057_setup(
-	struct brcms_phy *pi,
-	const struct chan_info_nphy_radio2057 *ci,
-	const struct chan_info_nphy_radio2057_rev5 *
-	ci2)
-{
-	int coreNum;
-	u16 txmix2g_tune_boost_pu = 0;
-	u16 pad2g_tune_pus = 0;
-
-	if (pi->pubpi.radiorev == 5) {
-
-		write_radio_reg(pi,
-				RADIO_2057_VCOCAL_COUNTVAL0,
-				ci2->RF_vcocal_countval0);
-		write_radio_reg(pi, RADIO_2057_VCOCAL_COUNTVAL1,
-				ci2->RF_vcocal_countval1);
-		write_radio_reg(pi, RADIO_2057_RFPLL_REFMASTER_SPAREXTALSIZE,
-				ci2->RF_rfpll_refmaster_sparextalsize);
-		write_radio_reg(pi, RADIO_2057_RFPLL_LOOPFILTER_R1,
-				ci2->RF_rfpll_loopfilter_r1);
-		write_radio_reg(pi, RADIO_2057_RFPLL_LOOPFILTER_C2,
-				ci2->RF_rfpll_loopfilter_c2);
-		write_radio_reg(pi, RADIO_2057_RFPLL_LOOPFILTER_C1,
-				ci2->RF_rfpll_loopfilter_c1);
-		write_radio_reg(pi, RADIO_2057_CP_KPD_IDAC,
-				ci2->RF_cp_kpd_idac);
-		write_radio_reg(pi, RADIO_2057_RFPLL_MMD0, ci2->RF_rfpll_mmd0);
-		write_radio_reg(pi, RADIO_2057_RFPLL_MMD1, ci2->RF_rfpll_mmd1);
-		write_radio_reg(pi,
-				RADIO_2057_VCOBUF_TUNE, ci2->RF_vcobuf_tune);
-		write_radio_reg(pi,
-				RADIO_2057_LOGEN_MX2G_TUNE,
-				ci2->RF_logen_mx2g_tune);
-		write_radio_reg(pi, RADIO_2057_LOGEN_INDBUF2G_TUNE,
-				ci2->RF_logen_indbuf2g_tune);
-
-		write_radio_reg(pi,
-				RADIO_2057_TXMIX2G_TUNE_BOOST_PU_CORE0,
-				ci2->RF_txmix2g_tune_boost_pu_core0);
-		write_radio_reg(pi,
-				RADIO_2057_PAD2G_TUNE_PUS_CORE0,
-				ci2->RF_pad2g_tune_pus_core0);
-		write_radio_reg(pi, RADIO_2057_LNA2G_TUNE_CORE0,
-				ci2->RF_lna2g_tune_core0);
 
-		write_radio_reg(pi,
-				RADIO_2057_TXMIX2G_TUNE_BOOST_PU_CORE1,
-				ci2->RF_txmix2g_tune_boost_pu_core1);
-		write_radio_reg(pi,
-				RADIO_2057_PAD2G_TUNE_PUS_CORE1,
-				ci2->RF_pad2g_tune_pus_core1);
-		write_radio_reg(pi, RADIO_2057_LNA2G_TUNE_CORE1,
-				ci2->RF_lna2g_tune_core1);
+	wlc_phy_txpwr_limit_to_tbl_nphy(pi);
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_CORE1TXPWRCTL, 84, 64, 8,
+				 pi->adj_pwr_tbl_nphy);
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_CORE2TXPWRCTL, 84, 64, 8,
+				 pi->adj_pwr_tbl_nphy);
 
-	} else {
+	if (pi->phyhang_avoid)
+		wlc_phy_stay_in_carriersearch_nphy(pi, false);
+}
 
-		write_radio_reg(pi,
-				RADIO_2057_VCOCAL_COUNTVAL0,
-				ci->RF_vcocal_countval0);
-		write_radio_reg(pi, RADIO_2057_VCOCAL_COUNTVAL1,
-				ci->RF_vcocal_countval1);
-		write_radio_reg(pi, RADIO_2057_RFPLL_REFMASTER_SPAREXTALSIZE,
-				ci->RF_rfpll_refmaster_sparextalsize);
-		write_radio_reg(pi, RADIO_2057_RFPLL_LOOPFILTER_R1,
-				ci->RF_rfpll_loopfilter_r1);
-		write_radio_reg(pi, RADIO_2057_RFPLL_LOOPFILTER_C2,
-				ci->RF_rfpll_loopfilter_c2);
-		write_radio_reg(pi, RADIO_2057_RFPLL_LOOPFILTER_C1,
-				ci->RF_rfpll_loopfilter_c1);
-		write_radio_reg(pi, RADIO_2057_CP_KPD_IDAC, ci->RF_cp_kpd_idac);
-		write_radio_reg(pi, RADIO_2057_RFPLL_MMD0, ci->RF_rfpll_mmd0);
-		write_radio_reg(pi, RADIO_2057_RFPLL_MMD1, ci->RF_rfpll_mmd1);
-		write_radio_reg(pi, RADIO_2057_VCOBUF_TUNE, ci->RF_vcobuf_tune);
-		write_radio_reg(pi,
-				RADIO_2057_LOGEN_MX2G_TUNE,
-				ci->RF_logen_mx2g_tune);
-		write_radio_reg(pi, RADIO_2057_LOGEN_MX5G_TUNE,
-				ci->RF_logen_mx5g_tune);
-		write_radio_reg(pi, RADIO_2057_LOGEN_INDBUF2G_TUNE,
-				ci->RF_logen_indbuf2g_tune);
-		write_radio_reg(pi, RADIO_2057_LOGEN_INDBUF5G_TUNE,
-				ci->RF_logen_indbuf5g_tune);
+static u32 *wlc_phy_get_ipa_gaintbl_nphy(struct brcms_phy *pi)
+{
+	u32 *tx_pwrctrl_tbl = NULL;
 
-		write_radio_reg(pi,
-				RADIO_2057_TXMIX2G_TUNE_BOOST_PU_CORE0,
-				ci->RF_txmix2g_tune_boost_pu_core0);
-		write_radio_reg(pi,
-				RADIO_2057_PAD2G_TUNE_PUS_CORE0,
-				ci->RF_pad2g_tune_pus_core0);
-		write_radio_reg(pi, RADIO_2057_PGA_BOOST_TUNE_CORE0,
-				ci->RF_pga_boost_tune_core0);
-		write_radio_reg(pi, RADIO_2057_TXMIX5G_BOOST_TUNE_CORE0,
-				ci->RF_txmix5g_boost_tune_core0);
-		write_radio_reg(pi, RADIO_2057_PAD5G_TUNE_MISC_PUS_CORE0,
-				ci->RF_pad5g_tune_misc_pus_core0);
-		write_radio_reg(pi, RADIO_2057_LNA2G_TUNE_CORE0,
-				ci->RF_lna2g_tune_core0);
-		write_radio_reg(pi, RADIO_2057_LNA5G_TUNE_CORE0,
-				ci->RF_lna5g_tune_core0);
+	if (CHSPEC_IS2G(pi->radio_chanspec)) {
+		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+			if ((pi->pubpi.radiorev == 4)
+			    || (pi->pubpi.radiorev == 6))
+				tx_pwrctrl_tbl =
+					nphy_tpc_txgain_ipa_2g_2057rev4n6;
+			else if (pi->pubpi.radiorev == 3)
+				tx_pwrctrl_tbl =
+					nphy_tpc_txgain_ipa_2g_2057rev3;
+			else if (pi->pubpi.radiorev == 5)
+				tx_pwrctrl_tbl =
+					nphy_tpc_txgain_ipa_2g_2057rev5;
+			else if ((pi->pubpi.radiorev == 7)
+				 || (pi->pubpi.radiorev == 8))
+				tx_pwrctrl_tbl =
+					nphy_tpc_txgain_ipa_2g_2057rev7;
+		} else if (NREV_IS(pi->pubpi.phy_rev, 6)) {
+			tx_pwrctrl_tbl = nphy_tpc_txgain_ipa_rev6;
+		} else if (NREV_IS(pi->pubpi.phy_rev, 5)) {
+			tx_pwrctrl_tbl = nphy_tpc_txgain_ipa_rev5;
+		} else {
+			tx_pwrctrl_tbl = nphy_tpc_txgain_ipa;
+		}
+	} else {
 
-		write_radio_reg(pi,
-				RADIO_2057_TXMIX2G_TUNE_BOOST_PU_CORE1,
-				ci->RF_txmix2g_tune_boost_pu_core1);
-		write_radio_reg(pi,
-				RADIO_2057_PAD2G_TUNE_PUS_CORE1,
-				ci->RF_pad2g_tune_pus_core1);
-		write_radio_reg(pi, RADIO_2057_PGA_BOOST_TUNE_CORE1,
-				ci->RF_pga_boost_tune_core1);
-		write_radio_reg(pi, RADIO_2057_TXMIX5G_BOOST_TUNE_CORE1,
-				ci->RF_txmix5g_boost_tune_core1);
-		write_radio_reg(pi, RADIO_2057_PAD5G_TUNE_MISC_PUS_CORE1,
-				ci->RF_pad5g_tune_misc_pus_core1);
-		write_radio_reg(pi, RADIO_2057_LNA2G_TUNE_CORE1,
-				ci->RF_lna2g_tune_core1);
-		write_radio_reg(pi, RADIO_2057_LNA5G_TUNE_CORE1,
-				ci->RF_lna5g_tune_core1);
+		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+			if ((pi->pubpi.radiorev == 3) ||
+			    (pi->pubpi.radiorev == 4) ||
+			    (pi->pubpi.radiorev == 6))
+				tx_pwrctrl_tbl = nphy_tpc_txgain_ipa_5g_2057;
+			else if ((pi->pubpi.radiorev == 7)
+				 || (pi->pubpi.radiorev == 8))
+				tx_pwrctrl_tbl =
+					nphy_tpc_txgain_ipa_5g_2057rev7;
+		} else {
+			tx_pwrctrl_tbl = nphy_tpc_txgain_ipa_5g;
+		}
 	}
 
-	if ((pi->pubpi.radiorev <= 4) || (pi->pubpi.radiorev == 6)) {
+	return tx_pwrctrl_tbl;
+}
 
-		if (CHSPEC_IS2G(pi->radio_chanspec)) {
-			write_radio_reg(pi, RADIO_2057_RFPLL_LOOPFILTER_R1,
-					0x3f);
-			write_radio_reg(pi, RADIO_2057_CP_KPD_IDAC, 0x3f);
-			write_radio_reg(pi, RADIO_2057_RFPLL_LOOPFILTER_C1,
-					0x8);
-			write_radio_reg(pi, RADIO_2057_RFPLL_LOOPFILTER_C2,
-					0x8);
+static void wlc_phy_restore_rssical_nphy(struct brcms_phy *pi)
+{
+	if (CHSPEC_IS2G(pi->radio_chanspec)) {
+		if (pi->nphy_rssical_chanspec_2G == 0)
+			return;
+
+		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+			mod_radio_reg(pi, RADIO_2057_NB_MASTER_CORE0,
+				      RADIO_2057_VCM_MASK,
+				      pi->rssical_cache.
+				      rssical_radio_regs_2G[0]);
+			mod_radio_reg(pi, RADIO_2057_NB_MASTER_CORE1,
+				      RADIO_2057_VCM_MASK,
+				      pi->rssical_cache.
+				      rssical_radio_regs_2G[1]);
 		} else {
-			write_radio_reg(pi, RADIO_2057_RFPLL_LOOPFILTER_R1,
-					0x1f);
-			write_radio_reg(pi, RADIO_2057_CP_KPD_IDAC, 0x3f);
-			write_radio_reg(pi, RADIO_2057_RFPLL_LOOPFILTER_C1,
-					0x8);
-			write_radio_reg(pi, RADIO_2057_RFPLL_LOOPFILTER_C2,
-					0x8);
+			mod_radio_reg(pi,
+				      RADIO_2056_RX_RSSI_MISC | RADIO_2056_RX0,
+				      RADIO_2056_VCM_MASK,
+				      pi->rssical_cache.
+				      rssical_radio_regs_2G[0]);
+			mod_radio_reg(pi,
+				      RADIO_2056_RX_RSSI_MISC | RADIO_2056_RX1,
+				      RADIO_2056_VCM_MASK,
+				      pi->rssical_cache.
+				      rssical_radio_regs_2G[1]);
 		}
-	} else if ((pi->pubpi.radiorev == 5) || (pi->pubpi.radiorev == 7) ||
-		   (pi->pubpi.radiorev == 8)) {
 
-		if (CHSPEC_IS2G(pi->radio_chanspec)) {
-			write_radio_reg(pi, RADIO_2057_RFPLL_LOOPFILTER_R1,
-					0x1b);
-			write_radio_reg(pi, RADIO_2057_CP_KPD_IDAC, 0x30);
-			write_radio_reg(pi, RADIO_2057_RFPLL_LOOPFILTER_C1,
-					0xa);
-			write_radio_reg(pi, RADIO_2057_RFPLL_LOOPFILTER_C2,
-					0xa);
+		write_phy_reg(pi, 0x1a6,
+			      pi->rssical_cache.rssical_phyregs_2G[0]);
+		write_phy_reg(pi, 0x1ac,
+			      pi->rssical_cache.rssical_phyregs_2G[1]);
+		write_phy_reg(pi, 0x1b2,
+			      pi->rssical_cache.rssical_phyregs_2G[2]);
+		write_phy_reg(pi, 0x1b8,
+			      pi->rssical_cache.rssical_phyregs_2G[3]);
+		write_phy_reg(pi, 0x1a4,
+			      pi->rssical_cache.rssical_phyregs_2G[4]);
+		write_phy_reg(pi, 0x1aa,
+			      pi->rssical_cache.rssical_phyregs_2G[5]);
+		write_phy_reg(pi, 0x1b0,
+			      pi->rssical_cache.rssical_phyregs_2G[6]);
+		write_phy_reg(pi, 0x1b6,
+			      pi->rssical_cache.rssical_phyregs_2G[7]);
+		write_phy_reg(pi, 0x1a5,
+			      pi->rssical_cache.rssical_phyregs_2G[8]);
+		write_phy_reg(pi, 0x1ab,
+			      pi->rssical_cache.rssical_phyregs_2G[9]);
+		write_phy_reg(pi, 0x1b1,
+			      pi->rssical_cache.rssical_phyregs_2G[10]);
+		write_phy_reg(pi, 0x1b7,
+			      pi->rssical_cache.rssical_phyregs_2G[11]);
+
+	} else {
+		if (pi->nphy_rssical_chanspec_5G == 0)
+			return;
+
+		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+			mod_radio_reg(pi, RADIO_2057_NB_MASTER_CORE0,
+				      RADIO_2057_VCM_MASK,
+				      pi->rssical_cache.
+				      rssical_radio_regs_5G[0]);
+			mod_radio_reg(pi, RADIO_2057_NB_MASTER_CORE1,
+				      RADIO_2057_VCM_MASK,
+				      pi->rssical_cache.
+				      rssical_radio_regs_5G[1]);
 		} else {
-			write_radio_reg(pi, RADIO_2057_RFPLL_LOOPFILTER_R1,
-					0x1f);
-			write_radio_reg(pi, RADIO_2057_CP_KPD_IDAC, 0x3f);
-			write_radio_reg(pi, RADIO_2057_RFPLL_LOOPFILTER_C1,
-					0x8);
-			write_radio_reg(pi, RADIO_2057_RFPLL_LOOPFILTER_C2,
-					0x8);
+			mod_radio_reg(pi,
+				      RADIO_2056_RX_RSSI_MISC | RADIO_2056_RX0,
+				      RADIO_2056_VCM_MASK,
+				      pi->rssical_cache.
+				      rssical_radio_regs_5G[0]);
+			mod_radio_reg(pi,
+				      RADIO_2056_RX_RSSI_MISC | RADIO_2056_RX1,
+				      RADIO_2056_VCM_MASK,
+				      pi->rssical_cache.
+				      rssical_radio_regs_5G[1]);
 		}
 
+		write_phy_reg(pi, 0x1a6,
+			      pi->rssical_cache.rssical_phyregs_5G[0]);
+		write_phy_reg(pi, 0x1ac,
+			      pi->rssical_cache.rssical_phyregs_5G[1]);
+		write_phy_reg(pi, 0x1b2,
+			      pi->rssical_cache.rssical_phyregs_5G[2]);
+		write_phy_reg(pi, 0x1b8,
+			      pi->rssical_cache.rssical_phyregs_5G[3]);
+		write_phy_reg(pi, 0x1a4,
+			      pi->rssical_cache.rssical_phyregs_5G[4]);
+		write_phy_reg(pi, 0x1aa,
+			      pi->rssical_cache.rssical_phyregs_5G[5]);
+		write_phy_reg(pi, 0x1b0,
+			      pi->rssical_cache.rssical_phyregs_5G[6]);
+		write_phy_reg(pi, 0x1b6,
+			      pi->rssical_cache.rssical_phyregs_5G[7]);
+		write_phy_reg(pi, 0x1a5,
+			      pi->rssical_cache.rssical_phyregs_5G[8]);
+		write_phy_reg(pi, 0x1ab,
+			      pi->rssical_cache.rssical_phyregs_5G[9]);
+		write_phy_reg(pi, 0x1b1,
+			      pi->rssical_cache.rssical_phyregs_5G[10]);
+		write_phy_reg(pi, 0x1b7,
+			      pi->rssical_cache.rssical_phyregs_5G[11]);
+	}
+}
+
+static void wlc_phy_internal_cal_txgain_nphy(struct brcms_phy *pi)
+{
+	u16 txcal_gain[2];
+
+	pi->nphy_txcal_pwr_idx[0] = pi->nphy_cal_orig_pwr_idx[0];
+	pi->nphy_txcal_pwr_idx[1] = pi->nphy_cal_orig_pwr_idx[0];
+	wlc_phy_txpwr_index_nphy(pi, 1, pi->nphy_cal_orig_pwr_idx[0], true);
+	wlc_phy_txpwr_index_nphy(pi, 2, pi->nphy_cal_orig_pwr_idx[1], true);
+
+	wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x110, 16,
+				txcal_gain);
+
+	if (CHSPEC_IS2G(pi->radio_chanspec)) {
+		txcal_gain[0] = (txcal_gain[0] & 0xF000) | 0x0F40;
+		txcal_gain[1] = (txcal_gain[1] & 0xF000) | 0x0F40;
+	} else {
+		txcal_gain[0] = (txcal_gain[0] & 0xF000) | 0x0F60;
+		txcal_gain[1] = (txcal_gain[1] & 0xF000) | 0x0F60;
 	}
 
-	if (CHSPEC_IS2G(pi->radio_chanspec)) {
-		if (PHY_IPA(pi)) {
-			if (pi->pubpi.radiorev == 3)
-				txmix2g_tune_boost_pu = 0x6b;
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x110, 16,
+				 txcal_gain);
+}
 
-			if (pi->pubpi.radiorev == 5)
-				pad2g_tune_pus = 0x73;
+static void wlc_phy_precal_txgain_nphy(struct brcms_phy *pi)
+{
+	bool save_bbmult = false;
+	u8 txcal_index_2057_rev5n7 = 0;
+	u8 txcal_index_2057_rev3n4n6 = 10;
 
-		} else {
-			if (pi->pubpi.radiorev != 5) {
-				pad2g_tune_pus = 0x3;
+	if (pi->use_int_tx_iqlo_cal_nphy) {
+		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+			if ((pi->pubpi.radiorev == 3) ||
+			    (pi->pubpi.radiorev == 4) ||
+			    (pi->pubpi.radiorev == 6)) {
 
-				txmix2g_tune_boost_pu = 0x61;
+				pi->nphy_txcal_pwr_idx[0] =
+					txcal_index_2057_rev3n4n6;
+				pi->nphy_txcal_pwr_idx[1] =
+					txcal_index_2057_rev3n4n6;
+				wlc_phy_txpwr_index_nphy(
+					pi, 3,
+					txcal_index_2057_rev3n4n6,
+					false);
+			} else {
+
+				pi->nphy_txcal_pwr_idx[0] =
+					txcal_index_2057_rev5n7;
+				pi->nphy_txcal_pwr_idx[1] =
+					txcal_index_2057_rev5n7;
+				wlc_phy_txpwr_index_nphy(
+					pi, 3,
+					txcal_index_2057_rev5n7,
+					false);
 			}
-		}
+			save_bbmult = true;
 
-		for (coreNum = 0; coreNum <= 1; coreNum++) {
+		} else if (NREV_LT(pi->pubpi.phy_rev, 5)) {
+			wlc_phy_cal_txgainctrl_nphy(pi, 11, false);
+			if (pi->sh->hw_phytxchain != 3) {
+				pi->nphy_txcal_pwr_idx[1] =
+					pi->nphy_txcal_pwr_idx[0];
+				wlc_phy_txpwr_index_nphy(pi, 3,
+							 pi->
+							 nphy_txcal_pwr_idx[0],
+							 true);
+				save_bbmult = true;
+			}
 
-			if (txmix2g_tune_boost_pu != 0)
-				WRITE_RADIO_REG4(pi, RADIO_2057, CORE, coreNum,
-						 TXMIX2G_TUNE_BOOST_PU,
-						 txmix2g_tune_boost_pu);
+		} else if (NREV_IS(pi->pubpi.phy_rev, 5)) {
+			if (PHY_IPA(pi)) {
+				if (CHSPEC_IS2G(pi->radio_chanspec)) {
+					wlc_phy_cal_txgainctrl_nphy(pi, 12,
+								    false);
+				} else {
+					pi->nphy_txcal_pwr_idx[0] = 80;
+					pi->nphy_txcal_pwr_idx[1] = 80;
+					wlc_phy_txpwr_index_nphy(pi, 3, 80,
+								 false);
+					save_bbmult = true;
+				}
+			} else {
+				wlc_phy_internal_cal_txgain_nphy(pi);
+				save_bbmult = true;
+			}
 
-			if (pad2g_tune_pus != 0)
-				WRITE_RADIO_REG4(pi, RADIO_2057, CORE, coreNum,
-						 PAD2G_TUNE_PUS,
-						 pad2g_tune_pus);
+		} else if (NREV_IS(pi->pubpi.phy_rev, 6)) {
+			if (PHY_IPA(pi)) {
+				if (CHSPEC_IS2G(pi->radio_chanspec))
+					wlc_phy_cal_txgainctrl_nphy(pi, 12,
+								    false);
+				else
+					wlc_phy_cal_txgainctrl_nphy(pi, 14,
+								    false);
+			} else {
+				wlc_phy_internal_cal_txgain_nphy(pi);
+				save_bbmult = true;
+			}
 		}
-	}
 
-	udelay(50);
+	} else {
+		wlc_phy_cal_txgainctrl_nphy(pi, 10, false);
+	}
 
-	wlc_phy_radio205x_vcocal_nphy(pi);
+	if (save_bbmult)
+		wlc_phy_table_read_nphy(pi, 15, 1, 87, 16,
+					&pi->nphy_txcal_bbmult);
 }
 
-static u16 wlc_phy_radio2057_rccal(struct brcms_phy *pi)
+static void
+wlc_phy_rfctrlintc_override_nphy(struct brcms_phy *pi, u8 field, u16 value,
+				 u8 core_code)
 {
-	u16 rccal_valid;
-	int i;
-	bool chip43226_6362A0;
+	u16 mask;
+	u16 val;
+	u8 core;
 
-	chip43226_6362A0 = ((pi->pubpi.radiorev == 3)
-			    || (pi->pubpi.radiorev == 4)
-			    || (pi->pubpi.radiorev == 6));
+	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+		for (core = 0; core < pi->pubpi.phy_corenum; core++) {
+			if (core_code == RADIO_MIMO_CORESEL_CORE1
+			    && core == PHY_CORE_1)
+				continue;
+			else if (core_code == RADIO_MIMO_CORESEL_CORE2
+				 && core == PHY_CORE_0)
+				continue;
 
-	rccal_valid = 0;
-	if (chip43226_6362A0) {
-		write_radio_reg(pi, RADIO_2057_RCCAL_MASTER, 0x61);
-		write_radio_reg(pi, RADIO_2057_RCCAL_TRC0, 0xc0);
-	} else {
-		write_radio_reg(pi, RADIO_2057v7_RCCAL_MASTER, 0x61);
+			if (NREV_LT(pi->pubpi.phy_rev, 7)) {
 
-		write_radio_reg(pi, RADIO_2057_RCCAL_TRC0, 0xe9);
-	}
-	write_radio_reg(pi, RADIO_2057_RCCAL_X1, 0x6e);
-	write_radio_reg(pi, RADIO_2057_RCCAL_START_R1_Q1_P1, 0x55);
+				mask = (0x1 << 10);
+				val = 1 << 10;
+				mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x91 :
+					    0x92, mask, val);
+			}
 
-	for (i = 0; i < MAX_205x_RCAL_WAITLOOPS; i++) {
-		rccal_valid = read_radio_reg(pi, RADIO_2057_RCCAL_DONE_OSCCAP);
-		if (rccal_valid & 0x2)
-			break;
+			if (field == NPHY_RfctrlIntc_override_OFF) {
 
-		udelay(500);
-	}
+				write_phy_reg(pi, (core == PHY_CORE_0) ? 0x91 :
+					      0x92, 0);
 
-	write_radio_reg(pi, RADIO_2057_RCCAL_START_R1_Q1_P1, 0x15);
+				wlc_phy_force_rfseq_nphy(pi,
+							 NPHY_RFSEQ_RESET2RX);
+			} else if (field == NPHY_RfctrlIntc_override_TRSW) {
 
-	rccal_valid = 0;
-	if (chip43226_6362A0) {
-		write_radio_reg(pi, RADIO_2057_RCCAL_MASTER, 0x69);
-		write_radio_reg(pi, RADIO_2057_RCCAL_TRC0, 0xb0);
-	} else {
-		write_radio_reg(pi, RADIO_2057v7_RCCAL_MASTER, 0x69);
+				if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 
-		write_radio_reg(pi, RADIO_2057_RCCAL_TRC0, 0xd5);
-	}
-	write_radio_reg(pi, RADIO_2057_RCCAL_X1, 0x6e);
-	write_radio_reg(pi, RADIO_2057_RCCAL_START_R1_Q1_P1, 0x55);
+					mask = (0x1 << 6) | (0x1 << 7);
 
-	for (i = 0; i < MAX_205x_RCAL_WAITLOOPS; i++) {
-		rccal_valid = read_radio_reg(pi, RADIO_2057_RCCAL_DONE_OSCCAP);
-		if (rccal_valid & 0x2)
-			break;
+					val = value << 6;
+					mod_phy_reg(pi,
+						    (core ==
+						     PHY_CORE_0) ? 0x91 : 0x92,
+						    mask, val);
 
-		udelay(500);
-	}
+					or_phy_reg(pi,
+						   (core ==
+						    PHY_CORE_0) ? 0x91 : 0x92,
+						   (0x1 << 10));
 
-	write_radio_reg(pi, RADIO_2057_RCCAL_START_R1_Q1_P1, 0x15);
+					and_phy_reg(pi, 0x2ff, (u16)
+						    ~(0x3 << 14));
+					or_phy_reg(pi, 0x2ff, (0x1 << 13));
+					or_phy_reg(pi, 0x2ff, (0x1 << 0));
+				} else {
 
-	rccal_valid = 0;
-	if (chip43226_6362A0) {
-		write_radio_reg(pi, RADIO_2057_RCCAL_MASTER, 0x73);
+					mask = (0x1 << 6) |
+					       (0x1 << 7) |
+					       (0x1 << 8) | (0x1 << 9);
+					val = value << 6;
+					mod_phy_reg(pi,
+						    (core ==
+						     PHY_CORE_0) ? 0x91 : 0x92,
+						    mask, val);
 
-		write_radio_reg(pi, RADIO_2057_RCCAL_X1, 0x28);
-		write_radio_reg(pi, RADIO_2057_RCCAL_TRC0, 0xb0);
-	} else {
-		write_radio_reg(pi, RADIO_2057v7_RCCAL_MASTER, 0x73);
-		write_radio_reg(pi, RADIO_2057_RCCAL_X1, 0x6e);
-		write_radio_reg(pi, RADIO_2057_RCCAL_TRC0, 0x99);
-	}
-	write_radio_reg(pi, RADIO_2057_RCCAL_START_R1_Q1_P1, 0x55);
+					mask = (0x1 << 0);
+					val = 1 << 0;
+					mod_phy_reg(pi,
+						    (core ==
+						     PHY_CORE_0) ? 0xe7 : 0xec,
+						    mask, val);
 
-	for (i = 0; i < MAX_205x_RCAL_WAITLOOPS; i++) {
-		rccal_valid = read_radio_reg(pi, RADIO_2057_RCCAL_DONE_OSCCAP);
-		if (rccal_valid & 0x2)
-			break;
+					mask = (core == PHY_CORE_0) ?
+					       (0x1 << 0) : (0x1 << 1);
+					val = 1 << ((core == PHY_CORE_0) ?
+						    0 : 1);
+					mod_phy_reg(pi, 0x78, mask, val);
+
+					SPINWAIT(((read_phy_reg(pi, 0x78) & val)
+						  != 0), 10000);
+					if (WARN(read_phy_reg(pi, 0x78) & val,
+						 "HW error: override failed"))
+						return;
+
+					mask = (0x1 << 0);
+					val = 0 << 0;
+					mod_phy_reg(pi,
+						    (core ==
+						     PHY_CORE_0) ? 0xe7 : 0xec,
+						    mask, val);
+				}
+			} else if (field == NPHY_RfctrlIntc_override_PA) {
+				if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+
+					mask = (0x1 << 4) | (0x1 << 5);
+
+					if (CHSPEC_IS5G(pi->radio_chanspec))
+						val = value << 5;
+					else
+						val = value << 4;
+
+					mod_phy_reg(pi,
+						    (core ==
+						     PHY_CORE_0) ? 0x91 : 0x92,
+						    mask, val);
+
+					or_phy_reg(pi,
+						   (core ==
+						    PHY_CORE_0) ? 0x91 : 0x92,
+						   (0x1 << 12));
+				} else {
+
+					if (CHSPEC_IS5G(pi->radio_chanspec)) {
+						mask = (0x1 << 5);
+						val = value << 5;
+					} else {
+						mask = (0x1 << 4);
+						val = value << 4;
+					}
+					mod_phy_reg(pi,
+						    (core ==
+						     PHY_CORE_0) ? 0x91 : 0x92,
+						    mask, val);
+				}
+			} else if (field ==
+				   NPHY_RfctrlIntc_override_EXT_LNA_PU) {
+				if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+					if (CHSPEC_IS5G(pi->radio_chanspec)) {
 
-		udelay(500);
-	}
+						mask = (0x1 << 0);
+						val = value << 0;
+						mod_phy_reg(pi,
+							    (core ==
+							     PHY_CORE_0) ? 0x91
+							    : 0x92, mask, val);
 
-	if (WARN(!(rccal_valid & 0x2), "HW error: radio calib4"))
-		return 0;
+						mask = (0x1 << 2);
+						mod_phy_reg(pi,
+							    (core ==
+							     PHY_CORE_0) ? 0x91
+							    : 0x92, mask, 0);
+					} else {
 
-	write_radio_reg(pi, RADIO_2057_RCCAL_START_R1_Q1_P1, 0x15);
+						mask = (0x1 << 2);
+						val = value << 2;
+						mod_phy_reg(pi,
+							    (core ==
+							     PHY_CORE_0) ? 0x91
+							    : 0x92, mask, val);
 
-	return rccal_valid;
-}
+						mask = (0x1 << 0);
+						mod_phy_reg(pi,
+							    (core ==
+							     PHY_CORE_0) ? 0x91
+							    : 0x92, mask, 0);
+					}
 
-static void
-wlc_phy_adjust_rx_analpfbw_nphy(struct brcms_phy *pi, u16 reduction_factr)
-{
-	if (NREV_GE(pi->pubpi.phy_rev, 3) && NREV_LT(pi->pubpi.phy_rev, 7)) {
-		if ((CHSPEC_CHANNEL(pi->radio_chanspec) == 11) &&
-		    CHSPEC_IS40(pi->radio_chanspec)) {
-			if (!pi->nphy_anarxlpf_adjusted) {
-				write_radio_reg(pi,
-						(RADIO_2056_RX_RXLPF_RCCAL_LPC |
-						 RADIO_2056_RX0),
-						((pi->nphy_rccal_value +
-						  reduction_factr) | 0x80));
+					mask = (0x1 << 11);
+					val = 1 << 11;
+					mod_phy_reg(pi,
+						    (core ==
+						     PHY_CORE_0) ? 0x91 : 0x92,
+						    mask, val);
+				} else {
 
-				pi->nphy_anarxlpf_adjusted = true;
-			}
-		} else {
-			if (pi->nphy_anarxlpf_adjusted) {
-				write_radio_reg(pi,
-						(RADIO_2056_RX_RXLPF_RCCAL_LPC |
-						 RADIO_2056_RX0),
-						(pi->nphy_rccal_value | 0x80));
+					if (CHSPEC_IS5G(pi->radio_chanspec)) {
+						mask = (0x1 << 0);
+						val = value << 0;
+					} else {
+						mask = (0x1 << 2);
+						val = value << 2;
+					}
+					mod_phy_reg(pi,
+						    (core ==
+						     PHY_CORE_0) ? 0x91 : 0x92,
+						    mask, val);
+				}
+			} else if (field ==
+				   NPHY_RfctrlIntc_override_EXT_LNA_GAIN) {
+				if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+					if (CHSPEC_IS5G(pi->radio_chanspec)) {
 
-				pi->nphy_anarxlpf_adjusted = false;
-			}
-		}
-	}
-}
+						mask = (0x1 << 1);
+						val = value << 1;
+						mod_phy_reg(pi,
+							    (core ==
+							     PHY_CORE_0) ? 0x91
+							    : 0x92, mask, val);
 
-static void
-wlc_phy_adjust_min_noisevar_nphy(struct brcms_phy *pi, int ntones,
-				 int *tone_id_buf, u32 *noise_var_buf)
-{
-	int i;
-	u32 offset;
-	int tone_id;
-	int tbllen =
-		CHSPEC_IS40(pi->radio_chanspec) ?
-		NPHY_NOISEVAR_TBLLEN40 : NPHY_NOISEVAR_TBLLEN20;
+						mask = (0x1 << 3);
+						mod_phy_reg(pi,
+							    (core ==
+							     PHY_CORE_0) ? 0x91
+							    : 0x92, mask, 0);
+					} else {
 
-	if (pi->nphy_noisevars_adjusted) {
-		for (i = 0; i < pi->nphy_saved_noisevars.bufcount; i++) {
-			tone_id = pi->nphy_saved_noisevars.tone_id[i];
-			offset = (tone_id >= 0) ?
-				 ((tone_id *
-				   2) + 1) : (tbllen + (tone_id * 2) + 1);
-			wlc_phy_table_write_nphy(
-				pi, NPHY_TBL_ID_NOISEVAR, 1,
-				offset, 32,
-				&pi->nphy_saved_noisevars.min_noise_vars[i]);
-		}
+						mask = (0x1 << 3);
+						val = value << 3;
+						mod_phy_reg(pi,
+							    (core ==
+							     PHY_CORE_0) ? 0x91
+							    : 0x92, mask, val);
 
-		pi->nphy_saved_noisevars.bufcount = 0;
-		pi->nphy_noisevars_adjusted = false;
-	}
+						mask = (0x1 << 1);
+						mod_phy_reg(pi,
+							    (core ==
+							     PHY_CORE_0) ? 0x91
+							    : 0x92, mask, 0);
+					}
 
-	if ((noise_var_buf != NULL) && (tone_id_buf != NULL)) {
-		pi->nphy_saved_noisevars.bufcount = 0;
+					mask = (0x1 << 11);
+					val = 1 << 11;
+					mod_phy_reg(pi,
+						    (core ==
+						     PHY_CORE_0) ? 0x91 : 0x92,
+						    mask, val);
+				} else {
 
-		for (i = 0; i < ntones; i++) {
-			tone_id = tone_id_buf[i];
-			offset = (tone_id >= 0) ?
-				 ((tone_id * 2) + 1) :
-				 (tbllen + (tone_id * 2) + 1);
-			pi->nphy_saved_noisevars.tone_id[i] = tone_id;
-			wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1,
-						offset, 32,
-						&pi->nphy_saved_noisevars.
-						min_noise_vars[i]);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1,
-						 offset, 32, &noise_var_buf[i]);
-			pi->nphy_saved_noisevars.bufcount++;
+					if (CHSPEC_IS5G(pi->radio_chanspec)) {
+						mask = (0x1 << 1);
+						val = value << 1;
+					} else {
+						mask = (0x1 << 3);
+						val = value << 3;
+					}
+					mod_phy_reg(pi,
+						    (core ==
+						     PHY_CORE_0) ? 0x91 : 0x92,
+						    mask, val);
+				}
+			}
 		}
-
-		pi->nphy_noisevars_adjusted = true;
 	}
 }
 
-static void wlc_phy_adjust_crsminpwr_nphy(struct brcms_phy *pi, u8 minpwr)
+void
+wlc_phy_cal_txgainctrl_nphy(struct brcms_phy *pi, s32 dBm_targetpower,
+			    bool debug)
 {
-	u16 regval;
-
-	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-		if ((CHSPEC_CHANNEL(pi->radio_chanspec) == 11) &&
-		    CHSPEC_IS40(pi->radio_chanspec)) {
-			if (!pi->nphy_crsminpwr_adjusted) {
-				regval = read_phy_reg(pi, 0x27d);
-				pi->nphy_crsminpwr[0] = regval & 0xff;
-				regval &= 0xff00;
-				regval |= (u16) minpwr;
-				write_phy_reg(pi, 0x27d, regval);
+	int gainctrl_loopidx;
+	uint core;
+	u16 m0m1, curr_m0m1;
+	s32 delta_power;
+	s32 txpwrindex;
+	s32 qdBm_power[2];
+	u16 orig_BBConfig;
+	u16 phy_saveregs[4];
+	u32 freq_test;
+	u16 ampl_test = 250;
+	uint stepsize;
+	bool phyhang_avoid_state = false;
 
-				regval = read_phy_reg(pi, 0x280);
-				pi->nphy_crsminpwr[1] = regval & 0xff;
-				regval &= 0xff00;
-				regval |= (u16) minpwr;
-				write_phy_reg(pi, 0x280, regval);
+	if (NREV_GE(pi->pubpi.phy_rev, 7))
+		stepsize = 2;
+	else
+		stepsize = 1;
 
-				regval = read_phy_reg(pi, 0x283);
-				pi->nphy_crsminpwr[2] = regval & 0xff;
-				regval &= 0xff00;
-				regval |= (u16) minpwr;
-				write_phy_reg(pi, 0x283, regval);
+	if (CHSPEC_IS40(pi->radio_chanspec))
+		freq_test = 5000;
+	else
+		freq_test = 2500;
 
-				pi->nphy_crsminpwr_adjusted = true;
-			}
-		} else {
-			if (pi->nphy_crsminpwr_adjusted) {
-				regval = read_phy_reg(pi, 0x27d);
-				regval &= 0xff00;
-				regval |= pi->nphy_crsminpwr[0];
-				write_phy_reg(pi, 0x27d, regval);
+	wlc_phy_txpwr_index_nphy(pi, 1, pi->nphy_cal_orig_pwr_idx[0], true);
+	wlc_phy_txpwr_index_nphy(pi, 2, pi->nphy_cal_orig_pwr_idx[1], true);
 
-				regval = read_phy_reg(pi, 0x280);
-				regval &= 0xff00;
-				regval |= pi->nphy_crsminpwr[1];
-				write_phy_reg(pi, 0x280, regval);
+	if (pi->phyhang_avoid)
+		wlc_phy_stay_in_carriersearch_nphy(pi, true);
 
-				regval = read_phy_reg(pi, 0x283);
-				regval &= 0xff00;
-				regval |= pi->nphy_crsminpwr[2];
-				write_phy_reg(pi, 0x283, regval);
+	phyhang_avoid_state = pi->phyhang_avoid;
+	pi->phyhang_avoid = false;
 
-				pi->nphy_crsminpwr_adjusted = false;
-			}
-		}
-	}
-}
+	phy_saveregs[0] = read_phy_reg(pi, 0x91);
+	phy_saveregs[1] = read_phy_reg(pi, 0x92);
+	phy_saveregs[2] = read_phy_reg(pi, 0xe7);
+	phy_saveregs[3] = read_phy_reg(pi, 0xec);
+	wlc_phy_rfctrlintc_override_nphy(pi, NPHY_RfctrlIntc_override_PA, 1,
+					 RADIO_MIMO_CORESEL_CORE1 |
+					 RADIO_MIMO_CORESEL_CORE2);
 
-static void wlc_phy_txlpfbw_nphy(struct brcms_phy *pi)
-{
-	u8 tx_lpf_bw = 0;
+	if (!debug) {
+		wlc_phy_rfctrlintc_override_nphy(pi,
+						 NPHY_RfctrlIntc_override_TRSW,
+						 0x2, RADIO_MIMO_CORESEL_CORE1);
+		wlc_phy_rfctrlintc_override_nphy(pi,
+						 NPHY_RfctrlIntc_override_TRSW,
+						 0x8, RADIO_MIMO_CORESEL_CORE2);
+	} else {
+		wlc_phy_rfctrlintc_override_nphy(pi,
+						 NPHY_RfctrlIntc_override_TRSW,
+						 0x1, RADIO_MIMO_CORESEL_CORE1);
+		wlc_phy_rfctrlintc_override_nphy(pi,
+						 NPHY_RfctrlIntc_override_TRSW,
+						 0x7, RADIO_MIMO_CORESEL_CORE2);
+	}
 
-	if (NREV_GE(pi->pubpi.phy_rev, 3) && NREV_LT(pi->pubpi.phy_rev, 7)) {
-		if (CHSPEC_IS40(pi->radio_chanspec))
-			tx_lpf_bw = 3;
-		else
-			tx_lpf_bw = 1;
+	orig_BBConfig = read_phy_reg(pi, 0x01);
+	mod_phy_reg(pi, 0x01, (0x1 << 15), 0);
 
-		if (PHY_IPA(pi)) {
-			if (CHSPEC_IS40(pi->radio_chanspec))
-				tx_lpf_bw = 5;
-			else
-				tx_lpf_bw = 4;
-		}
+	wlc_phy_table_read_nphy(pi, 15, 1, 87, 16, &m0m1);
 
-		write_phy_reg(pi, 0xe8,
-			      (tx_lpf_bw << 0) |
-			      (tx_lpf_bw << 3) |
-			      (tx_lpf_bw << 6) | (tx_lpf_bw << 9));
+	for (core = 0; core < pi->pubpi.phy_corenum; core++) {
+		txpwrindex = (s32) pi->nphy_cal_orig_pwr_idx[core];
 
-		if (PHY_IPA(pi)) {
+		for (gainctrl_loopidx = 0; gainctrl_loopidx < 2;
+		     gainctrl_loopidx++) {
+			wlc_phy_tx_tone_nphy(pi, freq_test, ampl_test, 0, 0,
+					     false);
 
-			if (CHSPEC_IS40(pi->radio_chanspec))
-				tx_lpf_bw = 4;
+			if (core == PHY_CORE_0)
+				curr_m0m1 = m0m1 & 0xff00;
 			else
-				tx_lpf_bw = 1;
+				curr_m0m1 = m0m1 & 0x00ff;
 
-			write_phy_reg(pi, 0xe9,
-				      (tx_lpf_bw << 0) |
-				      (tx_lpf_bw << 3) |
-				      (tx_lpf_bw << 6) | (tx_lpf_bw << 9));
-		}
-	}
-}
+			wlc_phy_table_write_nphy(pi, 15, 1, 87, 16, &curr_m0m1);
+			wlc_phy_table_write_nphy(pi, 15, 1, 95, 16, &curr_m0m1);
 
-static void wlc_phy_spurwar_nphy(struct brcms_phy *pi)
-{
-	u16 cur_channel = 0;
-	int nphy_adj_tone_id_buf[] = { 57, 58 };
-	u32 nphy_adj_noise_var_buf[] = { 0x3ff, 0x3ff };
-	bool isAdjustNoiseVar = false;
-	uint numTonesAdjust = 0;
-	u32 tempval = 0;
+			udelay(50);
 
-	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-		if (pi->phyhang_avoid)
-			wlc_phy_stay_in_carriersearch_nphy(pi, true);
+			wlc_phy_est_tonepwr_nphy(pi, qdBm_power,
+						 NPHY_CAL_TSSISAMPS);
 
-		cur_channel = CHSPEC_CHANNEL(pi->radio_chanspec);
+			pi->nphy_bb_mult_save = 0;
+			wlc_phy_stopplayback_nphy(pi);
 
-		if (pi->nphy_gband_spurwar_en) {
+			delta_power = (dBm_targetpower * 4) - qdBm_power[core];
 
-			wlc_phy_adjust_rx_analpfbw_nphy(
-				pi,
-				NPHY_ANARXLPFBW_REDUCTIONFACT);
+			txpwrindex -= stepsize * delta_power;
+			if (txpwrindex < 0)
+				txpwrindex = 0;
+			else if (txpwrindex > 127)
+				txpwrindex = 127;
 
-			if (CHSPEC_IS2G(pi->radio_chanspec)) {
-				if ((cur_channel == 11)
-				    && CHSPEC_IS40(pi->radio_chanspec))
-					wlc_phy_adjust_min_noisevar_nphy(
-						pi, 2,
-						nphy_adj_tone_id_buf,
-						nphy_adj_noise_var_buf);
-				else
-					wlc_phy_adjust_min_noisevar_nphy(pi, 0,
-									 NULL,
-									 NULL);
+			if (CHSPEC_IS5G(pi->radio_chanspec)) {
+				if (NREV_IS(pi->pubpi.phy_rev, 4) &&
+				    (pi->srom_fem5g.extpagain == 3)) {
+					if (txpwrindex < 30)
+						txpwrindex = 30;
+				}
+			} else {
+				if (NREV_GE(pi->pubpi.phy_rev, 5) &&
+				    (pi->srom_fem2g.extpagain == 3)) {
+					if (txpwrindex < 50)
+						txpwrindex = 50;
+				}
 			}
 
-			wlc_phy_adjust_crsminpwr_nphy(pi,
-						     NPHY_ADJUSTED_MINCRSPOWER);
+			wlc_phy_txpwr_index_nphy(pi, (1 << core),
+						 (u8) txpwrindex, true);
 		}
 
-		if ((pi->nphy_gband_spurwar2_en)
-		    && CHSPEC_IS2G(pi->radio_chanspec)) {
+		pi->nphy_txcal_pwr_idx[core] = (u8) txpwrindex;
 
-			if (CHSPEC_IS40(pi->radio_chanspec)) {
-				switch (cur_channel) {
-				case 3:
-					nphy_adj_tone_id_buf[0] = 57;
-					nphy_adj_tone_id_buf[1] = 58;
-					nphy_adj_noise_var_buf[0] = 0x22f;
-					nphy_adj_noise_var_buf[1] = 0x25f;
-					isAdjustNoiseVar = true;
-					break;
-				case 4:
-					nphy_adj_tone_id_buf[0] = 41;
-					nphy_adj_tone_id_buf[1] = 42;
-					nphy_adj_noise_var_buf[0] = 0x22f;
-					nphy_adj_noise_var_buf[1] = 0x25f;
-					isAdjustNoiseVar = true;
-					break;
-				case 5:
-					nphy_adj_tone_id_buf[0] = 25;
-					nphy_adj_tone_id_buf[1] = 26;
-					nphy_adj_noise_var_buf[0] = 0x24f;
-					nphy_adj_noise_var_buf[1] = 0x25f;
-					isAdjustNoiseVar = true;
-					break;
-				case 6:
-					nphy_adj_tone_id_buf[0] = 9;
-					nphy_adj_tone_id_buf[1] = 10;
-					nphy_adj_noise_var_buf[0] = 0x22f;
-					nphy_adj_noise_var_buf[1] = 0x24f;
-					isAdjustNoiseVar = true;
-					break;
-				case 7:
-					nphy_adj_tone_id_buf[0] = 121;
-					nphy_adj_tone_id_buf[1] = 122;
-					nphy_adj_noise_var_buf[0] = 0x18f;
-					nphy_adj_noise_var_buf[1] = 0x24f;
-					isAdjustNoiseVar = true;
-					break;
-				case 8:
-					nphy_adj_tone_id_buf[0] = 105;
-					nphy_adj_tone_id_buf[1] = 106;
-					nphy_adj_noise_var_buf[0] = 0x22f;
-					nphy_adj_noise_var_buf[1] = 0x25f;
-					isAdjustNoiseVar = true;
-					break;
-				case 9:
-					nphy_adj_tone_id_buf[0] = 89;
-					nphy_adj_tone_id_buf[1] = 90;
-					nphy_adj_noise_var_buf[0] = 0x22f;
-					nphy_adj_noise_var_buf[1] = 0x24f;
-					isAdjustNoiseVar = true;
-					break;
-				case 10:
-					nphy_adj_tone_id_buf[0] = 73;
-					nphy_adj_tone_id_buf[1] = 74;
-					nphy_adj_noise_var_buf[0] = 0x22f;
-					nphy_adj_noise_var_buf[1] = 0x24f;
-					isAdjustNoiseVar = true;
-					break;
-				default:
-					isAdjustNoiseVar = false;
-					break;
-				}
-			}
+		if (debug) {
+			u16 radio_gain;
+			u16 dbg_m0m1;
 
-			if (isAdjustNoiseVar) {
-				numTonesAdjust = sizeof(nphy_adj_tone_id_buf) /
-						sizeof(nphy_adj_tone_id_buf[0]);
+			wlc_phy_table_read_nphy(pi, 15, 1, 87, 16, &dbg_m0m1);
 
-				wlc_phy_adjust_min_noisevar_nphy(
-					pi,
-					numTonesAdjust,
-					nphy_adj_tone_id_buf,
-					nphy_adj_noise_var_buf);
+			wlc_phy_tx_tone_nphy(pi, freq_test, ampl_test, 0, 0,
+					     false);
 
-				tempval = 0;
+			wlc_phy_table_write_nphy(pi, 15, 1, 87, 16, &dbg_m0m1);
+			wlc_phy_table_write_nphy(pi, 15, 1, 95, 16, &dbg_m0m1);
 
-			} else {
-				wlc_phy_adjust_min_noisevar_nphy(pi, 0, NULL,
-								 NULL);
-			}
-		}
+			udelay(100);
 
-		if ((pi->nphy_aband_spurwar_en) &&
-		    (CHSPEC_IS5G(pi->radio_chanspec))) {
-			switch (cur_channel) {
-			case 54:
-				nphy_adj_tone_id_buf[0] = 32;
-				nphy_adj_noise_var_buf[0] = 0x25f;
-				break;
-			case 38:
-			case 102:
-			case 118:
-				nphy_adj_tone_id_buf[0] = 0;
-				nphy_adj_noise_var_buf[0] = 0x0;
-				break;
-			case 134:
-				nphy_adj_tone_id_buf[0] = 32;
-				nphy_adj_noise_var_buf[0] = 0x21f;
-				break;
-			case 151:
-				nphy_adj_tone_id_buf[0] = 16;
-				nphy_adj_noise_var_buf[0] = 0x23f;
-				break;
-			case 153:
-			case 161:
-				nphy_adj_tone_id_buf[0] = 48;
-				nphy_adj_noise_var_buf[0] = 0x23f;
-				break;
-			default:
-				nphy_adj_tone_id_buf[0] = 0;
-				nphy_adj_noise_var_buf[0] = 0x0;
-				break;
-			}
+			wlc_phy_est_tonepwr_nphy(pi, qdBm_power,
+						 NPHY_CAL_TSSISAMPS);
 
-			if (nphy_adj_tone_id_buf[0]
-			    && nphy_adj_noise_var_buf[0])
-				wlc_phy_adjust_min_noisevar_nphy(
-					pi, 1,
-					nphy_adj_tone_id_buf,
-					nphy_adj_noise_var_buf);
-			else
-				wlc_phy_adjust_min_noisevar_nphy(pi, 0, NULL,
-								 NULL);
+			wlc_phy_table_read_nphy(pi, 7, 1, (0x110 + core), 16,
+						&radio_gain);
+
+			mdelay(4000);
+			pi->nphy_bb_mult_save = 0;
+			wlc_phy_stopplayback_nphy(pi);
 		}
+	}
+
+	wlc_phy_txpwr_index_nphy(pi, 1, pi->nphy_txcal_pwr_idx[0], true);
+	wlc_phy_txpwr_index_nphy(pi, 2, pi->nphy_txcal_pwr_idx[1], true);
+
+	wlc_phy_table_read_nphy(pi, 15, 1, 87, 16, &pi->nphy_txcal_bbmult);
 
-		if (pi->phyhang_avoid)
-			wlc_phy_stay_in_carriersearch_nphy(pi, false);
-	}
+	write_phy_reg(pi, 0x01, orig_BBConfig);
+
+	write_phy_reg(pi, 0x91, phy_saveregs[0]);
+	write_phy_reg(pi, 0x92, phy_saveregs[1]);
+	write_phy_reg(pi, 0xe7, phy_saveregs[2]);
+	write_phy_reg(pi, 0xec, phy_saveregs[3]);
+
+	pi->phyhang_avoid = phyhang_avoid_state;
+
+	if (pi->phyhang_avoid)
+		wlc_phy_stay_in_carriersearch_nphy(pi, false);
 }
 
-static void
-wlc_phy_chanspec_nphy_setup(struct brcms_phy *pi, u16 chanspec,
-			    const struct nphy_sfo_cfg *ci)
+static void wlc_phy_savecal_nphy(struct brcms_phy *pi)
 {
-	u16 val;
+	void *tbl_ptr;
+	int coreNum;
+	u16 *txcal_radio_regs = NULL;
 
-	val = read_phy_reg(pi, 0x09) & NPHY_BandControl_currentBand;
-	if (CHSPEC_IS5G(chanspec) && !val) {
+	if (pi->phyhang_avoid)
+		wlc_phy_stay_in_carriersearch_nphy(pi, true);
 
-		val = R_REG(&pi->regs->psm_phy_hdr_param);
-		W_REG(&pi->regs->psm_phy_hdr_param,
-		      (val | MAC_PHY_FORCE_CLK));
+	if (CHSPEC_IS2G(pi->radio_chanspec)) {
 
-		or_phy_reg(pi, (NPHY_TO_BPHY_OFF + BPHY_BB_CONFIG),
-			   (BBCFG_RESETCCA | BBCFG_RESETRX));
+		wlc_phy_rx_iq_coeffs_nphy(pi, 0,
+					  &pi->calibration_cache.
+					  rxcal_coeffs_2G);
 
-		W_REG(&pi->regs->psm_phy_hdr_param, val);
+		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+			txcal_radio_regs =
+				pi->calibration_cache.txcal_radio_regs_2G;
+		} else if (NREV_GE(pi->pubpi.phy_rev, 3)) {
 
-		or_phy_reg(pi, 0x09, NPHY_BandControl_currentBand);
-	} else if (!CHSPEC_IS5G(chanspec) && val) {
+			pi->calibration_cache.txcal_radio_regs_2G[0] =
+				read_radio_reg(pi,
+					       RADIO_2056_TX_LOFT_FINE_I |
+					       RADIO_2056_TX0);
+			pi->calibration_cache.txcal_radio_regs_2G[1] =
+				read_radio_reg(pi,
+					       RADIO_2056_TX_LOFT_FINE_Q |
+					       RADIO_2056_TX0);
+			pi->calibration_cache.txcal_radio_regs_2G[2] =
+				read_radio_reg(pi,
+					       RADIO_2056_TX_LOFT_FINE_I |
+					       RADIO_2056_TX1);
+			pi->calibration_cache.txcal_radio_regs_2G[3] =
+				read_radio_reg(pi,
+					       RADIO_2056_TX_LOFT_FINE_Q |
+					       RADIO_2056_TX1);
 
-		and_phy_reg(pi, 0x09, ~NPHY_BandControl_currentBand);
+			pi->calibration_cache.txcal_radio_regs_2G[4] =
+				read_radio_reg(pi,
+					       RADIO_2056_TX_LOFT_COARSE_I |
+					       RADIO_2056_TX0);
+			pi->calibration_cache.txcal_radio_regs_2G[5] =
+				read_radio_reg(pi,
+					       RADIO_2056_TX_LOFT_COARSE_Q |
+					       RADIO_2056_TX0);
+			pi->calibration_cache.txcal_radio_regs_2G[6] =
+				read_radio_reg(pi,
+					       RADIO_2056_TX_LOFT_COARSE_I |
+					       RADIO_2056_TX1);
+			pi->calibration_cache.txcal_radio_regs_2G[7] =
+				read_radio_reg(pi,
+					       RADIO_2056_TX_LOFT_COARSE_Q |
+					       RADIO_2056_TX1);
+		} else {
+			pi->calibration_cache.txcal_radio_regs_2G[0] =
+			       read_radio_reg(pi, RADIO_2055_CORE1_TX_VOS_CNCL);
+			pi->calibration_cache.txcal_radio_regs_2G[1] =
+			       read_radio_reg(pi, RADIO_2055_CORE2_TX_VOS_CNCL);
+			pi->calibration_cache.txcal_radio_regs_2G[2] =
+			       read_radio_reg(pi, RADIO_2055_CORE1_TX_BB_MXGM);
+			pi->calibration_cache.txcal_radio_regs_2G[3] =
+			       read_radio_reg(pi, RADIO_2055_CORE2_TX_BB_MXGM);
+		}
 
-		val = R_REG(&pi->regs->psm_phy_hdr_param);
-		W_REG(&pi->regs->psm_phy_hdr_param,
-		      (val | MAC_PHY_FORCE_CLK));
+		pi->nphy_iqcal_chanspec_2G = pi->radio_chanspec;
+		tbl_ptr = pi->calibration_cache.txcal_coeffs_2G;
+	} else {
 
-		and_phy_reg(pi, (NPHY_TO_BPHY_OFF + BPHY_BB_CONFIG),
-			    (u16) (~(BBCFG_RESETCCA | BBCFG_RESETRX)));
+		wlc_phy_rx_iq_coeffs_nphy(pi, 0,
+					  &pi->calibration_cache.
+					  rxcal_coeffs_5G);
 
-		W_REG(&pi->regs->psm_phy_hdr_param, val);
-	}
+		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+			txcal_radio_regs =
+				pi->calibration_cache.txcal_radio_regs_5G;
+		} else if (NREV_GE(pi->pubpi.phy_rev, 3)) {
 
-	write_phy_reg(pi, 0x1ce, ci->PHY_BW1a);
-	write_phy_reg(pi, 0x1cf, ci->PHY_BW2);
-	write_phy_reg(pi, 0x1d0, ci->PHY_BW3);
+			pi->calibration_cache.txcal_radio_regs_5G[0] =
+				read_radio_reg(pi,
+					       RADIO_2056_TX_LOFT_FINE_I |
+					       RADIO_2056_TX0);
+			pi->calibration_cache.txcal_radio_regs_5G[1] =
+				read_radio_reg(pi,
+					       RADIO_2056_TX_LOFT_FINE_Q |
+					       RADIO_2056_TX0);
+			pi->calibration_cache.txcal_radio_regs_5G[2] =
+				read_radio_reg(pi,
+					       RADIO_2056_TX_LOFT_FINE_I |
+					       RADIO_2056_TX1);
+			pi->calibration_cache.txcal_radio_regs_5G[3] =
+				read_radio_reg(pi,
+					       RADIO_2056_TX_LOFT_FINE_Q |
+					       RADIO_2056_TX1);
 
-	write_phy_reg(pi, 0x1d1, ci->PHY_BW4);
-	write_phy_reg(pi, 0x1d2, ci->PHY_BW5);
-	write_phy_reg(pi, 0x1d3, ci->PHY_BW6);
+			pi->calibration_cache.txcal_radio_regs_5G[4] =
+				read_radio_reg(pi,
+					       RADIO_2056_TX_LOFT_COARSE_I |
+					       RADIO_2056_TX0);
+			pi->calibration_cache.txcal_radio_regs_5G[5] =
+				read_radio_reg(pi,
+					       RADIO_2056_TX_LOFT_COARSE_Q |
+					       RADIO_2056_TX0);
+			pi->calibration_cache.txcal_radio_regs_5G[6] =
+				read_radio_reg(pi,
+					       RADIO_2056_TX_LOFT_COARSE_I |
+					       RADIO_2056_TX1);
+			pi->calibration_cache.txcal_radio_regs_5G[7] =
+				read_radio_reg(pi,
+					       RADIO_2056_TX_LOFT_COARSE_Q |
+					       RADIO_2056_TX1);
+		} else {
+			pi->calibration_cache.txcal_radio_regs_5G[0] =
+			       read_radio_reg(pi, RADIO_2055_CORE1_TX_VOS_CNCL);
+			pi->calibration_cache.txcal_radio_regs_5G[1] =
+			       read_radio_reg(pi, RADIO_2055_CORE2_TX_VOS_CNCL);
+			pi->calibration_cache.txcal_radio_regs_5G[2] =
+			       read_radio_reg(pi, RADIO_2055_CORE1_TX_BB_MXGM);
+			pi->calibration_cache.txcal_radio_regs_5G[3] =
+			       read_radio_reg(pi, RADIO_2055_CORE2_TX_BB_MXGM);
+		}
 
-	if (CHSPEC_CHANNEL(pi->radio_chanspec) == 14) {
-		wlc_phy_classifier_nphy(pi, NPHY_ClassifierCtrl_ofdm_en, 0);
+		pi->nphy_iqcal_chanspec_5G = pi->radio_chanspec;
+		tbl_ptr = pi->calibration_cache.txcal_coeffs_5G;
+	}
+	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+		for (coreNum = 0; coreNum <= 1; coreNum++) {
 
-		or_phy_reg(pi, NPHY_TO_BPHY_OFF + BPHY_TEST, 0x800);
-	} else {
-		wlc_phy_classifier_nphy(pi, NPHY_ClassifierCtrl_ofdm_en,
-					NPHY_ClassifierCtrl_ofdm_en);
+			txcal_radio_regs[2 * coreNum] =
+				READ_RADIO_REG3(pi, RADIO_2057, TX, coreNum,
+						LOFT_FINE_I);
+			txcal_radio_regs[2 * coreNum + 1] =
+				READ_RADIO_REG3(pi, RADIO_2057, TX, coreNum,
+						LOFT_FINE_Q);
 
-		if (CHSPEC_IS2G(chanspec))
-			and_phy_reg(pi, NPHY_TO_BPHY_OFF + BPHY_TEST, ~0x840);
+			txcal_radio_regs[2 * coreNum + 4] =
+				READ_RADIO_REG3(pi, RADIO_2057, TX, coreNum,
+						LOFT_COARSE_I);
+			txcal_radio_regs[2 * coreNum + 5] =
+				READ_RADIO_REG3(pi, RADIO_2057, TX, coreNum,
+						LOFT_COARSE_Q);
+		}
 	}
 
-	if (pi->nphy_txpwrctrl == PHY_TPC_HW_OFF)
-		wlc_phy_txpwr_fixpower_nphy(pi);
+	wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_IQLOCAL, 8, 80, 16, tbl_ptr);
 
-	if (NREV_LT(pi->pubpi.phy_rev, 3))
-		wlc_phy_adjust_lnagaintbl_nphy(pi);
+	if (pi->phyhang_avoid)
+		wlc_phy_stay_in_carriersearch_nphy(pi, false);
+}
 
-	wlc_phy_txlpfbw_nphy(pi);
+static void wlc_phy_tx_iq_war_nphy(struct brcms_phy *pi)
+{
+	struct nphy_iq_comp tx_comp;
 
-	if (NREV_GE(pi->pubpi.phy_rev, 3)
-	    && (pi->phy_spuravoid != SPURAVOID_DISABLE)) {
-		u8 spuravoid = 0;
+	wlc_phy_table_read_nphy(pi, 15, 4, 0x50, 16, &tx_comp);
 
-		val = CHSPEC_CHANNEL(chanspec);
-		if (!CHSPEC_IS40(pi->radio_chanspec)) {
-			if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-				if ((val == 13) || (val == 14) || (val == 153))
-					spuravoid = 1;
-			} else if (((val >= 5) && (val <= 8)) || (val == 13)
-				   || (val == 14)) {
-				spuravoid = 1;
-			}
-		} else if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-			if (val == 54)
-				spuravoid = 1;
-		} else {
-			if (pi->nphy_aband_spurwar_en &&
-			    ((val == 38) || (val == 102)
-			     || (val == 118)))
-				spuravoid = 1;
-		}
+	wlapi_bmac_write_shm(pi->sh->physhim, M_20IN40_IQ, tx_comp.a0);
+	wlapi_bmac_write_shm(pi->sh->physhim, M_20IN40_IQ + 2, tx_comp.b0);
+	wlapi_bmac_write_shm(pi->sh->physhim, M_20IN40_IQ + 4, tx_comp.a1);
+	wlapi_bmac_write_shm(pi->sh->physhim, M_20IN40_IQ + 6, tx_comp.b1);
+}
 
-		if (pi->phy_spuravoid == SPURAVOID_FORCEON)
-			spuravoid = 1;
+static void wlc_phy_restorecal_nphy(struct brcms_phy *pi)
+{
+	u16 *loft_comp;
+	u16 txcal_coeffs_bphy[4];
+	u16 *tbl_ptr;
+	int coreNum;
+	u16 *txcal_radio_regs = NULL;
+
+	if (CHSPEC_IS2G(pi->radio_chanspec)) {
+		if (pi->nphy_iqcal_chanspec_2G == 0)
+			return;
+
+		tbl_ptr = pi->calibration_cache.txcal_coeffs_2G;
+		loft_comp = &pi->calibration_cache.txcal_coeffs_2G[5];
+	} else {
+		if (pi->nphy_iqcal_chanspec_5G == 0)
+			return;
+
+		tbl_ptr = pi->calibration_cache.txcal_coeffs_5G;
+		loft_comp = &pi->calibration_cache.txcal_coeffs_5G[5];
+	}
+
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, 4, 80, 16, tbl_ptr);
+
+	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+		txcal_coeffs_bphy[0] = tbl_ptr[0];
+		txcal_coeffs_bphy[1] = tbl_ptr[1];
+		txcal_coeffs_bphy[2] = tbl_ptr[2];
+		txcal_coeffs_bphy[3] = tbl_ptr[3];
+	} else {
+		txcal_coeffs_bphy[0] = 0;
+		txcal_coeffs_bphy[1] = 0;
+		txcal_coeffs_bphy[2] = 0;
+		txcal_coeffs_bphy[3] = 0;
+	}
+
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, 4, 88, 16,
+				 txcal_coeffs_bphy);
+
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, 2, 85, 16, loft_comp);
 
-		wlapi_bmac_core_phypll_ctl(pi->sh->physhim, false);
-		si_pmu_spuravoid(pi->sh->sih, spuravoid);
-		wlapi_bmac_core_phypll_ctl(pi->sh->physhim, true);
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, 2, 93, 16, loft_comp);
 
-		if ((pi->sh->chip == BCM43224_CHIP_ID) ||
-		    (pi->sh->chip == BCM43225_CHIP_ID)) {
+	if (NREV_LT(pi->pubpi.phy_rev, 2))
+		wlc_phy_tx_iq_war_nphy(pi);
 
-			if (spuravoid == 1) {
+	if (CHSPEC_IS2G(pi->radio_chanspec)) {
+		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+			txcal_radio_regs =
+				pi->calibration_cache.txcal_radio_regs_2G;
+		} else if (NREV_GE(pi->pubpi.phy_rev, 3)) {
 
-				W_REG(&pi->regs->tsf_clk_frac_l,
-				      0x5341);
-				W_REG(&pi->regs->tsf_clk_frac_h,
-				      0x8);
-			} else {
+			write_radio_reg(pi,
+					RADIO_2056_TX_LOFT_FINE_I |
+					RADIO_2056_TX0,
+					pi->calibration_cache.
+					txcal_radio_regs_2G[0]);
+			write_radio_reg(pi,
+					RADIO_2056_TX_LOFT_FINE_Q |
+					RADIO_2056_TX0,
+					pi->calibration_cache.
+					txcal_radio_regs_2G[1]);
+			write_radio_reg(pi,
+					RADIO_2056_TX_LOFT_FINE_I |
+					RADIO_2056_TX1,
+					pi->calibration_cache.
+					txcal_radio_regs_2G[2]);
+			write_radio_reg(pi,
+					RADIO_2056_TX_LOFT_FINE_Q |
+					RADIO_2056_TX1,
+					pi->calibration_cache.
+					txcal_radio_regs_2G[3]);
 
-				W_REG(&pi->regs->tsf_clk_frac_l,
-				      0x8889);
-				W_REG(&pi->regs->tsf_clk_frac_h,
-				      0x8);
-			}
+			write_radio_reg(pi,
+					RADIO_2056_TX_LOFT_COARSE_I |
+					RADIO_2056_TX0,
+					pi->calibration_cache.
+					txcal_radio_regs_2G[4]);
+			write_radio_reg(pi,
+					RADIO_2056_TX_LOFT_COARSE_Q |
+					RADIO_2056_TX0,
+					pi->calibration_cache.
+					txcal_radio_regs_2G[5]);
+			write_radio_reg(pi,
+					RADIO_2056_TX_LOFT_COARSE_I |
+					RADIO_2056_TX1,
+					pi->calibration_cache.
+					txcal_radio_regs_2G[6]);
+			write_radio_reg(pi,
+					RADIO_2056_TX_LOFT_COARSE_Q |
+					RADIO_2056_TX1,
+					pi->calibration_cache.
+					txcal_radio_regs_2G[7]);
+		} else {
+			write_radio_reg(pi, RADIO_2055_CORE1_TX_VOS_CNCL,
+					pi->calibration_cache.
+					txcal_radio_regs_2G[0]);
+			write_radio_reg(pi, RADIO_2055_CORE2_TX_VOS_CNCL,
+					pi->calibration_cache.
+					txcal_radio_regs_2G[1]);
+			write_radio_reg(pi, RADIO_2055_CORE1_TX_BB_MXGM,
+					pi->calibration_cache.
+					txcal_radio_regs_2G[2]);
+			write_radio_reg(pi, RADIO_2055_CORE2_TX_BB_MXGM,
+					pi->calibration_cache.
+					txcal_radio_regs_2G[3]);
 		}
 
-		wlapi_bmac_core_phypll_reset(pi->sh->physhim);
+		wlc_phy_rx_iq_coeffs_nphy(pi, 1,
+					  &pi->calibration_cache.
+					  rxcal_coeffs_2G);
+	} else {
+		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+			txcal_radio_regs =
+				pi->calibration_cache.txcal_radio_regs_5G;
+		} else if (NREV_GE(pi->pubpi.phy_rev, 3)) {
 
-		mod_phy_reg(pi, 0x01, (0x1 << 15),
-			    ((spuravoid > 0) ? (0x1 << 15) : 0));
+			write_radio_reg(pi,
+					RADIO_2056_TX_LOFT_FINE_I |
+					RADIO_2056_TX0,
+					pi->calibration_cache.
+					txcal_radio_regs_5G[0]);
+			write_radio_reg(pi,
+					RADIO_2056_TX_LOFT_FINE_Q |
+					RADIO_2056_TX0,
+					pi->calibration_cache.
+					txcal_radio_regs_5G[1]);
+			write_radio_reg(pi,
+					RADIO_2056_TX_LOFT_FINE_I |
+					RADIO_2056_TX1,
+					pi->calibration_cache.
+					txcal_radio_regs_5G[2]);
+			write_radio_reg(pi,
+					RADIO_2056_TX_LOFT_FINE_Q |
+					RADIO_2056_TX1,
+					pi->calibration_cache.
+					txcal_radio_regs_5G[3]);
 
-		wlc_phy_resetcca_nphy(pi);
+			write_radio_reg(pi,
+					RADIO_2056_TX_LOFT_COARSE_I |
+					RADIO_2056_TX0,
+					pi->calibration_cache.
+					txcal_radio_regs_5G[4]);
+			write_radio_reg(pi,
+					RADIO_2056_TX_LOFT_COARSE_Q |
+					RADIO_2056_TX0,
+					pi->calibration_cache.
+					txcal_radio_regs_5G[5]);
+			write_radio_reg(pi,
+					RADIO_2056_TX_LOFT_COARSE_I |
+					RADIO_2056_TX1,
+					pi->calibration_cache.
+					txcal_radio_regs_5G[6]);
+			write_radio_reg(pi,
+					RADIO_2056_TX_LOFT_COARSE_Q |
+					RADIO_2056_TX1,
+					pi->calibration_cache.
+					txcal_radio_regs_5G[7]);
+		} else {
+			write_radio_reg(pi, RADIO_2055_CORE1_TX_VOS_CNCL,
+					pi->calibration_cache.
+					txcal_radio_regs_5G[0]);
+			write_radio_reg(pi, RADIO_2055_CORE2_TX_VOS_CNCL,
+					pi->calibration_cache.
+					txcal_radio_regs_5G[1]);
+			write_radio_reg(pi, RADIO_2055_CORE1_TX_BB_MXGM,
+					pi->calibration_cache.
+					txcal_radio_regs_5G[2]);
+			write_radio_reg(pi, RADIO_2055_CORE2_TX_BB_MXGM,
+					pi->calibration_cache.
+					txcal_radio_regs_5G[3]);
+		}
 
-		pi->phy_isspuravoid = (spuravoid > 0);
+		wlc_phy_rx_iq_coeffs_nphy(pi, 1,
+					  &pi->calibration_cache.
+					  rxcal_coeffs_5G);
 	}
 
-	if (NREV_LT(pi->pubpi.phy_rev, 7))
-		write_phy_reg(pi, 0x17e, 0x3830);
+	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+		for (coreNum = 0; coreNum <= 1; coreNum++) {
 
-	wlc_phy_spurwar_nphy(pi);
+			WRITE_RADIO_REG3(pi, RADIO_2057, TX, coreNum,
+					 LOFT_FINE_I,
+					 txcal_radio_regs[2 * coreNum]);
+			WRITE_RADIO_REG3(pi, RADIO_2057, TX, coreNum,
+					 LOFT_FINE_Q,
+					 txcal_radio_regs[2 * coreNum + 1]);
+
+			WRITE_RADIO_REG3(pi, RADIO_2057, TX, coreNum,
+					 LOFT_COARSE_I,
+					 txcal_radio_regs[2 * coreNum + 4]);
+			WRITE_RADIO_REG3(pi, RADIO_2057, TX, coreNum,
+					 LOFT_COARSE_Q,
+					 txcal_radio_regs[2 * coreNum + 5]);
+		}
+	}
 }
 
-void wlc_phy_chanspec_set_nphy(struct brcms_phy *pi, u16 chanspec)
+static void wlc_phy_txpwrctrl_coeff_setup_nphy(struct brcms_phy *pi)
 {
-	int freq;
-	struct chan_info_nphy_radio2057 *t0 = NULL;
-	struct chan_info_nphy_radio205x *t1 = NULL;
-	struct chan_info_nphy_radio2057_rev5 *t2 = NULL;
-	struct chan_info_nphy_2055 *t3 = NULL;
+	u32 idx;
+	u16 iqloCalbuf[7];
+	u32 iqcomp, locomp, curr_locomp;
+	s8 locomp_i, locomp_q;
+	s8 curr_locomp_i, curr_locomp_q;
+	u32 tbl_id, tbl_len, tbl_offset;
+	u32 regval[128];
 
-	if (!wlc_phy_chan2freq_nphy
-		    (pi, CHSPEC_CHANNEL(chanspec), &freq, &t0, &t1, &t2, &t3))
-		return;
+	if (pi->phyhang_avoid)
+		wlc_phy_stay_in_carriersearch_nphy(pi, true);
 
-	wlc_phy_chanspec_radio_set((struct brcms_phy_pub *) pi, chanspec);
+	wlc_phy_table_read_nphy(pi, 15, 7, 80, 16, iqloCalbuf);
 
-	if (CHSPEC_BW(chanspec) != pi->bw)
-		wlapi_bmac_bw_set(pi->sh->physhim, CHSPEC_BW(chanspec));
+	tbl_len = 128;
+	tbl_offset = 320;
+	for (tbl_id = NPHY_TBL_ID_CORE1TXPWRCTL;
+	     tbl_id <= NPHY_TBL_ID_CORE2TXPWRCTL; tbl_id++) {
+		iqcomp =
+			(tbl_id ==
+			 26) ? (((u32) (iqloCalbuf[0] & 0x3ff)) << 10) |
+			(iqloCalbuf[1] & 0x3ff)
+			: (((u32) (iqloCalbuf[2] & 0x3ff)) << 10) |
+			(iqloCalbuf[3] & 0x3ff);
 
-	if (CHSPEC_IS40(chanspec)) {
-		if (CHSPEC_SB_UPPER(chanspec)) {
-			or_phy_reg(pi, 0xa0, BPHY_BAND_SEL_UP20);
-			if (NREV_GE(pi->pubpi.phy_rev, 7))
-				or_phy_reg(pi, 0x310, PRIM_SEL_UP20);
-		} else {
-			and_phy_reg(pi, 0xa0, ~BPHY_BAND_SEL_UP20);
-			if (NREV_GE(pi->pubpi.phy_rev, 7))
-				and_phy_reg(pi, 0x310,
-					    (~PRIM_SEL_UP20 & 0xffff));
-		}
+		for (idx = 0; idx < tbl_len; idx++)
+			regval[idx] = iqcomp;
+		wlc_phy_table_write_nphy(pi, tbl_id, tbl_len, tbl_offset, 32,
+					 regval);
 	}
 
-	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-
-			if ((pi->pubpi.radiorev <= 4)
-			    || (pi->pubpi.radiorev == 6)) {
-				mod_radio_reg(pi, RADIO_2057_TIA_CONFIG_CORE0,
-					      0x2,
-					      (CHSPEC_IS5G(chanspec) ? (1 << 1)
-					       : 0));
-				mod_radio_reg(pi, RADIO_2057_TIA_CONFIG_CORE1,
-					      0x2,
-					      (CHSPEC_IS5G(chanspec) ? (1 << 1)
-					       : 0));
-			}
-
-			wlc_phy_chanspec_radio2057_setup(pi, t0, t2);
-			wlc_phy_chanspec_nphy_setup(pi, chanspec,
-				(pi->pubpi.radiorev == 5) ?
-				(const struct nphy_sfo_cfg *)&(t2->PHY_BW1a) :
-				(const struct nphy_sfo_cfg *)&(t0->PHY_BW1a));
-
-		} else {
-
-			mod_radio_reg(pi,
-				      RADIO_2056_SYN_COM_CTRL | RADIO_2056_SYN,
-				      0x4,
-				      (CHSPEC_IS5G(chanspec) ? (0x1 << 2) : 0));
-			wlc_phy_chanspec_radio2056_setup(pi, t1);
+	tbl_offset = 448;
+	for (tbl_id = NPHY_TBL_ID_CORE1TXPWRCTL;
+	     tbl_id <= NPHY_TBL_ID_CORE2TXPWRCTL; tbl_id++) {
 
-			wlc_phy_chanspec_nphy_setup(pi, chanspec,
-				(const struct nphy_sfo_cfg *) &(t1->PHY_BW1a));
+		locomp =
+			(u32) ((tbl_id == 26) ? iqloCalbuf[5] : iqloCalbuf[6]);
+		locomp_i = (s8) ((locomp >> 8) & 0xff);
+		locomp_q = (s8) ((locomp) & 0xff);
+		for (idx = 0; idx < tbl_len; idx++) {
+			if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+				curr_locomp_i = locomp_i;
+				curr_locomp_q = locomp_q;
+			} else {
+				curr_locomp_i = (s8) ((locomp_i *
+						       nphy_tpc_loscale[idx] +
+						       128) >> 8);
+				curr_locomp_q =
+					(s8) ((locomp_q *
+					       nphy_tpc_loscale[idx] +
+					       128) >> 8);
+			}
+			curr_locomp = (u32) ((curr_locomp_i & 0xff) << 8);
+			curr_locomp |= (u32) (curr_locomp_q & 0xff);
+			regval[idx] = curr_locomp;
 		}
+		wlc_phy_table_write_nphy(pi, tbl_id, tbl_len, tbl_offset, 32,
+					 regval);
+	}
 
-	} else {
-
-		mod_radio_reg(pi, RADIO_2055_MASTER_CNTRL1, 0x70,
-			      (CHSPEC_IS5G(chanspec) ? (0x02 << 4)
-			       : (0x05 << 4)));
+	if (NREV_LT(pi->pubpi.phy_rev, 2)) {
 
-		wlc_phy_chanspec_radio2055_setup(pi, t3);
-		wlc_phy_chanspec_nphy_setup(pi, chanspec,
-					    (const struct nphy_sfo_cfg *)
-					     &(t3->PHY_BW1a));
+		wlapi_bmac_write_shm(pi->sh->physhim, M_CURR_IDX1, 0xFFFF);
+		wlapi_bmac_write_shm(pi->sh->physhim, M_CURR_IDX2, 0xFFFF);
 	}
 
+	if (pi->phyhang_avoid)
+		wlc_phy_stay_in_carriersearch_nphy(pi, false);
 }
 
-static void wlc_phy_savecal_nphy(struct brcms_phy *pi)
+static void wlc_phy_txlpfbw_nphy(struct brcms_phy *pi)
 {
-	void *tbl_ptr;
-	int coreNum;
-	u16 *txcal_radio_regs = NULL;
+	u8 tx_lpf_bw = 0;
 
-	if (pi->phyhang_avoid)
-		wlc_phy_stay_in_carriersearch_nphy(pi, true);
+	if (NREV_GE(pi->pubpi.phy_rev, 3) && NREV_LT(pi->pubpi.phy_rev, 7)) {
+		if (CHSPEC_IS40(pi->radio_chanspec))
+			tx_lpf_bw = 3;
+		else
+			tx_lpf_bw = 1;
 
-	if (CHSPEC_IS2G(pi->radio_chanspec)) {
+		if (PHY_IPA(pi)) {
+			if (CHSPEC_IS40(pi->radio_chanspec))
+				tx_lpf_bw = 5;
+			else
+				tx_lpf_bw = 4;
+		}
 
-		wlc_phy_rx_iq_coeffs_nphy(pi, 0,
-					  &pi->calibration_cache.
-					  rxcal_coeffs_2G);
+		write_phy_reg(pi, 0xe8,
+			      (tx_lpf_bw << 0) |
+			      (tx_lpf_bw << 3) |
+			      (tx_lpf_bw << 6) | (tx_lpf_bw << 9));
 
-		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-			txcal_radio_regs =
-				pi->calibration_cache.txcal_radio_regs_2G;
-		} else if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+		if (PHY_IPA(pi)) {
 
-			pi->calibration_cache.txcal_radio_regs_2G[0] =
-				read_radio_reg(pi,
-					       RADIO_2056_TX_LOFT_FINE_I |
-					       RADIO_2056_TX0);
-			pi->calibration_cache.txcal_radio_regs_2G[1] =
-				read_radio_reg(pi,
-					       RADIO_2056_TX_LOFT_FINE_Q |
-					       RADIO_2056_TX0);
-			pi->calibration_cache.txcal_radio_regs_2G[2] =
-				read_radio_reg(pi,
-					       RADIO_2056_TX_LOFT_FINE_I |
-					       RADIO_2056_TX1);
-			pi->calibration_cache.txcal_radio_regs_2G[3] =
-				read_radio_reg(pi,
-					       RADIO_2056_TX_LOFT_FINE_Q |
-					       RADIO_2056_TX1);
+			if (CHSPEC_IS40(pi->radio_chanspec))
+				tx_lpf_bw = 4;
+			else
+				tx_lpf_bw = 1;
 
-			pi->calibration_cache.txcal_radio_regs_2G[4] =
-				read_radio_reg(pi,
-					       RADIO_2056_TX_LOFT_COARSE_I |
-					       RADIO_2056_TX0);
-			pi->calibration_cache.txcal_radio_regs_2G[5] =
-				read_radio_reg(pi,
-					       RADIO_2056_TX_LOFT_COARSE_Q |
-					       RADIO_2056_TX0);
-			pi->calibration_cache.txcal_radio_regs_2G[6] =
-				read_radio_reg(pi,
-					       RADIO_2056_TX_LOFT_COARSE_I |
-					       RADIO_2056_TX1);
-			pi->calibration_cache.txcal_radio_regs_2G[7] =
-				read_radio_reg(pi,
-					       RADIO_2056_TX_LOFT_COARSE_Q |
-					       RADIO_2056_TX1);
-		} else {
-			pi->calibration_cache.txcal_radio_regs_2G[0] =
-			       read_radio_reg(pi, RADIO_2055_CORE1_TX_VOS_CNCL);
-			pi->calibration_cache.txcal_radio_regs_2G[1] =
-			       read_radio_reg(pi, RADIO_2055_CORE2_TX_VOS_CNCL);
-			pi->calibration_cache.txcal_radio_regs_2G[2] =
-			       read_radio_reg(pi, RADIO_2055_CORE1_TX_BB_MXGM);
-			pi->calibration_cache.txcal_radio_regs_2G[3] =
-			       read_radio_reg(pi, RADIO_2055_CORE2_TX_BB_MXGM);
+			write_phy_reg(pi, 0xe9,
+				      (tx_lpf_bw << 0) |
+				      (tx_lpf_bw << 3) |
+				      (tx_lpf_bw << 6) | (tx_lpf_bw << 9));
 		}
+	}
+}
 
-		pi->nphy_iqcal_chanspec_2G = pi->radio_chanspec;
-		tbl_ptr = pi->calibration_cache.txcal_coeffs_2G;
-	} else {
+static void
+wlc_phy_adjust_rx_analpfbw_nphy(struct brcms_phy *pi, u16 reduction_factr)
+{
+	if (NREV_GE(pi->pubpi.phy_rev, 3) && NREV_LT(pi->pubpi.phy_rev, 7)) {
+		if ((CHSPEC_CHANNEL(pi->radio_chanspec) == 11) &&
+		    CHSPEC_IS40(pi->radio_chanspec)) {
+			if (!pi->nphy_anarxlpf_adjusted) {
+				write_radio_reg(pi,
+						(RADIO_2056_RX_RXLPF_RCCAL_LPC |
+						 RADIO_2056_RX0),
+						((pi->nphy_rccal_value +
+						  reduction_factr) | 0x80));
 
-		wlc_phy_rx_iq_coeffs_nphy(pi, 0,
-					  &pi->calibration_cache.
-					  rxcal_coeffs_5G);
+				pi->nphy_anarxlpf_adjusted = true;
+			}
+		} else {
+			if (pi->nphy_anarxlpf_adjusted) {
+				write_radio_reg(pi,
+						(RADIO_2056_RX_RXLPF_RCCAL_LPC |
+						 RADIO_2056_RX0),
+						(pi->nphy_rccal_value | 0x80));
 
-		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-			txcal_radio_regs =
-				pi->calibration_cache.txcal_radio_regs_5G;
-		} else if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+				pi->nphy_anarxlpf_adjusted = false;
+			}
+		}
+	}
+}
 
-			pi->calibration_cache.txcal_radio_regs_5G[0] =
-				read_radio_reg(pi,
-					       RADIO_2056_TX_LOFT_FINE_I |
-					       RADIO_2056_TX0);
-			pi->calibration_cache.txcal_radio_regs_5G[1] =
-				read_radio_reg(pi,
-					       RADIO_2056_TX_LOFT_FINE_Q |
-					       RADIO_2056_TX0);
-			pi->calibration_cache.txcal_radio_regs_5G[2] =
-				read_radio_reg(pi,
-					       RADIO_2056_TX_LOFT_FINE_I |
-					       RADIO_2056_TX1);
-			pi->calibration_cache.txcal_radio_regs_5G[3] =
-				read_radio_reg(pi,
-					       RADIO_2056_TX_LOFT_FINE_Q |
-					       RADIO_2056_TX1);
+static void
+wlc_phy_adjust_min_noisevar_nphy(struct brcms_phy *pi, int ntones,
+				 int *tone_id_buf, u32 *noise_var_buf)
+{
+	int i;
+	u32 offset;
+	int tone_id;
+	int tbllen =
+		CHSPEC_IS40(pi->radio_chanspec) ?
+		NPHY_NOISEVAR_TBLLEN40 : NPHY_NOISEVAR_TBLLEN20;
 
-			pi->calibration_cache.txcal_radio_regs_5G[4] =
-				read_radio_reg(pi,
-					       RADIO_2056_TX_LOFT_COARSE_I |
-					       RADIO_2056_TX0);
-			pi->calibration_cache.txcal_radio_regs_5G[5] =
-				read_radio_reg(pi,
-					       RADIO_2056_TX_LOFT_COARSE_Q |
-					       RADIO_2056_TX0);
-			pi->calibration_cache.txcal_radio_regs_5G[6] =
-				read_radio_reg(pi,
-					       RADIO_2056_TX_LOFT_COARSE_I |
-					       RADIO_2056_TX1);
-			pi->calibration_cache.txcal_radio_regs_5G[7] =
-				read_radio_reg(pi,
-					       RADIO_2056_TX_LOFT_COARSE_Q |
-					       RADIO_2056_TX1);
-		} else {
-			pi->calibration_cache.txcal_radio_regs_5G[0] =
-			       read_radio_reg(pi, RADIO_2055_CORE1_TX_VOS_CNCL);
-			pi->calibration_cache.txcal_radio_regs_5G[1] =
-			       read_radio_reg(pi, RADIO_2055_CORE2_TX_VOS_CNCL);
-			pi->calibration_cache.txcal_radio_regs_5G[2] =
-			       read_radio_reg(pi, RADIO_2055_CORE1_TX_BB_MXGM);
-			pi->calibration_cache.txcal_radio_regs_5G[3] =
-			       read_radio_reg(pi, RADIO_2055_CORE2_TX_BB_MXGM);
+	if (pi->nphy_noisevars_adjusted) {
+		for (i = 0; i < pi->nphy_saved_noisevars.bufcount; i++) {
+			tone_id = pi->nphy_saved_noisevars.tone_id[i];
+			offset = (tone_id >= 0) ?
+				 ((tone_id *
+				   2) + 1) : (tbllen + (tone_id * 2) + 1);
+			wlc_phy_table_write_nphy(
+				pi, NPHY_TBL_ID_NOISEVAR, 1,
+				offset, 32,
+				&pi->nphy_saved_noisevars.min_noise_vars[i]);
 		}
 
-		pi->nphy_iqcal_chanspec_5G = pi->radio_chanspec;
-		tbl_ptr = pi->calibration_cache.txcal_coeffs_5G;
+		pi->nphy_saved_noisevars.bufcount = 0;
+		pi->nphy_noisevars_adjusted = false;
 	}
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-		for (coreNum = 0; coreNum <= 1; coreNum++) {
 
-			txcal_radio_regs[2 * coreNum] =
-				READ_RADIO_REG3(pi, RADIO_2057, TX, coreNum,
-						LOFT_FINE_I);
-			txcal_radio_regs[2 * coreNum + 1] =
-				READ_RADIO_REG3(pi, RADIO_2057, TX, coreNum,
-						LOFT_FINE_Q);
+	if ((noise_var_buf != NULL) && (tone_id_buf != NULL)) {
+		pi->nphy_saved_noisevars.bufcount = 0;
 
-			txcal_radio_regs[2 * coreNum + 4] =
-				READ_RADIO_REG3(pi, RADIO_2057, TX, coreNum,
-						LOFT_COARSE_I);
-			txcal_radio_regs[2 * coreNum + 5] =
-				READ_RADIO_REG3(pi, RADIO_2057, TX, coreNum,
-						LOFT_COARSE_Q);
+		for (i = 0; i < ntones; i++) {
+			tone_id = tone_id_buf[i];
+			offset = (tone_id >= 0) ?
+				 ((tone_id * 2) + 1) :
+				 (tbllen + (tone_id * 2) + 1);
+			pi->nphy_saved_noisevars.tone_id[i] = tone_id;
+			wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1,
+						offset, 32,
+						&pi->nphy_saved_noisevars.
+						min_noise_vars[i]);
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1,
+						 offset, 32, &noise_var_buf[i]);
+			pi->nphy_saved_noisevars.bufcount++;
 		}
+
+		pi->nphy_noisevars_adjusted = true;
 	}
+}
+
+static void wlc_phy_adjust_crsminpwr_nphy(struct brcms_phy *pi, u8 minpwr)
+{
+	u16 regval;
+
+	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+		if ((CHSPEC_CHANNEL(pi->radio_chanspec) == 11) &&
+		    CHSPEC_IS40(pi->radio_chanspec)) {
+			if (!pi->nphy_crsminpwr_adjusted) {
+				regval = read_phy_reg(pi, 0x27d);
+				pi->nphy_crsminpwr[0] = regval & 0xff;
+				regval &= 0xff00;
+				regval |= (u16) minpwr;
+				write_phy_reg(pi, 0x27d, regval);
 
-	wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_IQLOCAL, 8, 80, 16, tbl_ptr);
+				regval = read_phy_reg(pi, 0x280);
+				pi->nphy_crsminpwr[1] = regval & 0xff;
+				regval &= 0xff00;
+				regval |= (u16) minpwr;
+				write_phy_reg(pi, 0x280, regval);
 
-	if (pi->phyhang_avoid)
-		wlc_phy_stay_in_carriersearch_nphy(pi, false);
-}
+				regval = read_phy_reg(pi, 0x283);
+				pi->nphy_crsminpwr[2] = regval & 0xff;
+				regval &= 0xff00;
+				regval |= (u16) minpwr;
+				write_phy_reg(pi, 0x283, regval);
 
-static void wlc_phy_restorecal_nphy(struct brcms_phy *pi)
-{
-	u16 *loft_comp;
-	u16 txcal_coeffs_bphy[4];
-	u16 *tbl_ptr;
-	int coreNum;
-	u16 *txcal_radio_regs = NULL;
+				pi->nphy_crsminpwr_adjusted = true;
+			}
+		} else {
+			if (pi->nphy_crsminpwr_adjusted) {
+				regval = read_phy_reg(pi, 0x27d);
+				regval &= 0xff00;
+				regval |= pi->nphy_crsminpwr[0];
+				write_phy_reg(pi, 0x27d, regval);
 
-	if (CHSPEC_IS2G(pi->radio_chanspec)) {
-		if (pi->nphy_iqcal_chanspec_2G == 0)
-			return;
+				regval = read_phy_reg(pi, 0x280);
+				regval &= 0xff00;
+				regval |= pi->nphy_crsminpwr[1];
+				write_phy_reg(pi, 0x280, regval);
 
-		tbl_ptr = pi->calibration_cache.txcal_coeffs_2G;
-		loft_comp = &pi->calibration_cache.txcal_coeffs_2G[5];
-	} else {
-		if (pi->nphy_iqcal_chanspec_5G == 0)
-			return;
+				regval = read_phy_reg(pi, 0x283);
+				regval &= 0xff00;
+				regval |= pi->nphy_crsminpwr[2];
+				write_phy_reg(pi, 0x283, regval);
 
-		tbl_ptr = pi->calibration_cache.txcal_coeffs_5G;
-		loft_comp = &pi->calibration_cache.txcal_coeffs_5G[5];
+				pi->nphy_crsminpwr_adjusted = false;
+			}
+		}
 	}
+}
 
-	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, 4, 80, 16, tbl_ptr);
+static void wlc_phy_spurwar_nphy(struct brcms_phy *pi)
+{
+	u16 cur_channel = 0;
+	int nphy_adj_tone_id_buf[] = { 57, 58 };
+	u32 nphy_adj_noise_var_buf[] = { 0x3ff, 0x3ff };
+	bool isAdjustNoiseVar = false;
+	uint numTonesAdjust = 0;
+	u32 tempval = 0;
 
 	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-		txcal_coeffs_bphy[0] = tbl_ptr[0];
-		txcal_coeffs_bphy[1] = tbl_ptr[1];
-		txcal_coeffs_bphy[2] = tbl_ptr[2];
-		txcal_coeffs_bphy[3] = tbl_ptr[3];
-	} else {
-		txcal_coeffs_bphy[0] = 0;
-		txcal_coeffs_bphy[1] = 0;
-		txcal_coeffs_bphy[2] = 0;
-		txcal_coeffs_bphy[3] = 0;
-	}
-
-	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, 4, 88, 16,
-				 txcal_coeffs_bphy);
-
-	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, 2, 85, 16, loft_comp);
+		if (pi->phyhang_avoid)
+			wlc_phy_stay_in_carriersearch_nphy(pi, true);
 
-	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, 2, 93, 16, loft_comp);
+		cur_channel = CHSPEC_CHANNEL(pi->radio_chanspec);
 
-	if (NREV_LT(pi->pubpi.phy_rev, 2))
-		wlc_phy_tx_iq_war_nphy(pi);
+		if (pi->nphy_gband_spurwar_en) {
 
-	if (CHSPEC_IS2G(pi->radio_chanspec)) {
-		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-			txcal_radio_regs =
-				pi->calibration_cache.txcal_radio_regs_2G;
-		} else if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+			wlc_phy_adjust_rx_analpfbw_nphy(
+				pi,
+				NPHY_ANARXLPFBW_REDUCTIONFACT);
 
-			write_radio_reg(pi,
-					RADIO_2056_TX_LOFT_FINE_I |
-					RADIO_2056_TX0,
-					pi->calibration_cache.
-					txcal_radio_regs_2G[0]);
-			write_radio_reg(pi,
-					RADIO_2056_TX_LOFT_FINE_Q |
-					RADIO_2056_TX0,
-					pi->calibration_cache.
-					txcal_radio_regs_2G[1]);
-			write_radio_reg(pi,
-					RADIO_2056_TX_LOFT_FINE_I |
-					RADIO_2056_TX1,
-					pi->calibration_cache.
-					txcal_radio_regs_2G[2]);
-			write_radio_reg(pi,
-					RADIO_2056_TX_LOFT_FINE_Q |
-					RADIO_2056_TX1,
-					pi->calibration_cache.
-					txcal_radio_regs_2G[3]);
+			if (CHSPEC_IS2G(pi->radio_chanspec)) {
+				if ((cur_channel == 11)
+				    && CHSPEC_IS40(pi->radio_chanspec))
+					wlc_phy_adjust_min_noisevar_nphy(
+						pi, 2,
+						nphy_adj_tone_id_buf,
+						nphy_adj_noise_var_buf);
+				else
+					wlc_phy_adjust_min_noisevar_nphy(pi, 0,
+									 NULL,
+									 NULL);
+			}
 
-			write_radio_reg(pi,
-					RADIO_2056_TX_LOFT_COARSE_I |
-					RADIO_2056_TX0,
-					pi->calibration_cache.
-					txcal_radio_regs_2G[4]);
-			write_radio_reg(pi,
-					RADIO_2056_TX_LOFT_COARSE_Q |
-					RADIO_2056_TX0,
-					pi->calibration_cache.
-					txcal_radio_regs_2G[5]);
-			write_radio_reg(pi,
-					RADIO_2056_TX_LOFT_COARSE_I |
-					RADIO_2056_TX1,
-					pi->calibration_cache.
-					txcal_radio_regs_2G[6]);
-			write_radio_reg(pi,
-					RADIO_2056_TX_LOFT_COARSE_Q |
-					RADIO_2056_TX1,
-					pi->calibration_cache.
-					txcal_radio_regs_2G[7]);
-		} else {
-			write_radio_reg(pi, RADIO_2055_CORE1_TX_VOS_CNCL,
-					pi->calibration_cache.
-					txcal_radio_regs_2G[0]);
-			write_radio_reg(pi, RADIO_2055_CORE2_TX_VOS_CNCL,
-					pi->calibration_cache.
-					txcal_radio_regs_2G[1]);
-			write_radio_reg(pi, RADIO_2055_CORE1_TX_BB_MXGM,
-					pi->calibration_cache.
-					txcal_radio_regs_2G[2]);
-			write_radio_reg(pi, RADIO_2055_CORE2_TX_BB_MXGM,
-					pi->calibration_cache.
-					txcal_radio_regs_2G[3]);
+			wlc_phy_adjust_crsminpwr_nphy(pi,
+						     NPHY_ADJUSTED_MINCRSPOWER);
 		}
 
-		wlc_phy_rx_iq_coeffs_nphy(pi, 1,
-					  &pi->calibration_cache.
-					  rxcal_coeffs_2G);
-	} else {
-		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-			txcal_radio_regs =
-				pi->calibration_cache.txcal_radio_regs_5G;
-		} else if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+		if ((pi->nphy_gband_spurwar2_en)
+		    && CHSPEC_IS2G(pi->radio_chanspec)) {
 
-			write_radio_reg(pi,
-					RADIO_2056_TX_LOFT_FINE_I |
-					RADIO_2056_TX0,
-					pi->calibration_cache.
-					txcal_radio_regs_5G[0]);
-			write_radio_reg(pi,
-					RADIO_2056_TX_LOFT_FINE_Q |
-					RADIO_2056_TX0,
-					pi->calibration_cache.
-					txcal_radio_regs_5G[1]);
-			write_radio_reg(pi,
-					RADIO_2056_TX_LOFT_FINE_I |
-					RADIO_2056_TX1,
-					pi->calibration_cache.
-					txcal_radio_regs_5G[2]);
-			write_radio_reg(pi,
-					RADIO_2056_TX_LOFT_FINE_Q |
-					RADIO_2056_TX1,
-					pi->calibration_cache.
-					txcal_radio_regs_5G[3]);
+			if (CHSPEC_IS40(pi->radio_chanspec)) {
+				switch (cur_channel) {
+				case 3:
+					nphy_adj_tone_id_buf[0] = 57;
+					nphy_adj_tone_id_buf[1] = 58;
+					nphy_adj_noise_var_buf[0] = 0x22f;
+					nphy_adj_noise_var_buf[1] = 0x25f;
+					isAdjustNoiseVar = true;
+					break;
+				case 4:
+					nphy_adj_tone_id_buf[0] = 41;
+					nphy_adj_tone_id_buf[1] = 42;
+					nphy_adj_noise_var_buf[0] = 0x22f;
+					nphy_adj_noise_var_buf[1] = 0x25f;
+					isAdjustNoiseVar = true;
+					break;
+				case 5:
+					nphy_adj_tone_id_buf[0] = 25;
+					nphy_adj_tone_id_buf[1] = 26;
+					nphy_adj_noise_var_buf[0] = 0x24f;
+					nphy_adj_noise_var_buf[1] = 0x25f;
+					isAdjustNoiseVar = true;
+					break;
+				case 6:
+					nphy_adj_tone_id_buf[0] = 9;
+					nphy_adj_tone_id_buf[1] = 10;
+					nphy_adj_noise_var_buf[0] = 0x22f;
+					nphy_adj_noise_var_buf[1] = 0x24f;
+					isAdjustNoiseVar = true;
+					break;
+				case 7:
+					nphy_adj_tone_id_buf[0] = 121;
+					nphy_adj_tone_id_buf[1] = 122;
+					nphy_adj_noise_var_buf[0] = 0x18f;
+					nphy_adj_noise_var_buf[1] = 0x24f;
+					isAdjustNoiseVar = true;
+					break;
+				case 8:
+					nphy_adj_tone_id_buf[0] = 105;
+					nphy_adj_tone_id_buf[1] = 106;
+					nphy_adj_noise_var_buf[0] = 0x22f;
+					nphy_adj_noise_var_buf[1] = 0x25f;
+					isAdjustNoiseVar = true;
+					break;
+				case 9:
+					nphy_adj_tone_id_buf[0] = 89;
+					nphy_adj_tone_id_buf[1] = 90;
+					nphy_adj_noise_var_buf[0] = 0x22f;
+					nphy_adj_noise_var_buf[1] = 0x24f;
+					isAdjustNoiseVar = true;
+					break;
+				case 10:
+					nphy_adj_tone_id_buf[0] = 73;
+					nphy_adj_tone_id_buf[1] = 74;
+					nphy_adj_noise_var_buf[0] = 0x22f;
+					nphy_adj_noise_var_buf[1] = 0x24f;
+					isAdjustNoiseVar = true;
+					break;
+				default:
+					isAdjustNoiseVar = false;
+					break;
+				}
+			}
+
+			if (isAdjustNoiseVar) {
+				numTonesAdjust = sizeof(nphy_adj_tone_id_buf) /
+						sizeof(nphy_adj_tone_id_buf[0]);
 
-			write_radio_reg(pi,
-					RADIO_2056_TX_LOFT_COARSE_I |
-					RADIO_2056_TX0,
-					pi->calibration_cache.
-					txcal_radio_regs_5G[4]);
-			write_radio_reg(pi,
-					RADIO_2056_TX_LOFT_COARSE_Q |
-					RADIO_2056_TX0,
-					pi->calibration_cache.
-					txcal_radio_regs_5G[5]);
-			write_radio_reg(pi,
-					RADIO_2056_TX_LOFT_COARSE_I |
-					RADIO_2056_TX1,
-					pi->calibration_cache.
-					txcal_radio_regs_5G[6]);
-			write_radio_reg(pi,
-					RADIO_2056_TX_LOFT_COARSE_Q |
-					RADIO_2056_TX1,
-					pi->calibration_cache.
-					txcal_radio_regs_5G[7]);
-		} else {
-			write_radio_reg(pi, RADIO_2055_CORE1_TX_VOS_CNCL,
-					pi->calibration_cache.
-					txcal_radio_regs_5G[0]);
-			write_radio_reg(pi, RADIO_2055_CORE2_TX_VOS_CNCL,
-					pi->calibration_cache.
-					txcal_radio_regs_5G[1]);
-			write_radio_reg(pi, RADIO_2055_CORE1_TX_BB_MXGM,
-					pi->calibration_cache.
-					txcal_radio_regs_5G[2]);
-			write_radio_reg(pi, RADIO_2055_CORE2_TX_BB_MXGM,
-					pi->calibration_cache.
-					txcal_radio_regs_5G[3]);
-		}
+				wlc_phy_adjust_min_noisevar_nphy(
+					pi,
+					numTonesAdjust,
+					nphy_adj_tone_id_buf,
+					nphy_adj_noise_var_buf);
 
-		wlc_phy_rx_iq_coeffs_nphy(pi, 1,
-					  &pi->calibration_cache.
-					  rxcal_coeffs_5G);
-	}
+				tempval = 0;
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-		for (coreNum = 0; coreNum <= 1; coreNum++) {
+			} else {
+				wlc_phy_adjust_min_noisevar_nphy(pi, 0, NULL,
+								 NULL);
+			}
+		}
 
-			WRITE_RADIO_REG3(pi, RADIO_2057, TX, coreNum,
-					 LOFT_FINE_I,
-					 txcal_radio_regs[2 * coreNum]);
-			WRITE_RADIO_REG3(pi, RADIO_2057, TX, coreNum,
-					 LOFT_FINE_Q,
-					 txcal_radio_regs[2 * coreNum + 1]);
+		if ((pi->nphy_aband_spurwar_en) &&
+		    (CHSPEC_IS5G(pi->radio_chanspec))) {
+			switch (cur_channel) {
+			case 54:
+				nphy_adj_tone_id_buf[0] = 32;
+				nphy_adj_noise_var_buf[0] = 0x25f;
+				break;
+			case 38:
+			case 102:
+			case 118:
+				nphy_adj_tone_id_buf[0] = 0;
+				nphy_adj_noise_var_buf[0] = 0x0;
+				break;
+			case 134:
+				nphy_adj_tone_id_buf[0] = 32;
+				nphy_adj_noise_var_buf[0] = 0x21f;
+				break;
+			case 151:
+				nphy_adj_tone_id_buf[0] = 16;
+				nphy_adj_noise_var_buf[0] = 0x23f;
+				break;
+			case 153:
+			case 161:
+				nphy_adj_tone_id_buf[0] = 48;
+				nphy_adj_noise_var_buf[0] = 0x23f;
+				break;
+			default:
+				nphy_adj_tone_id_buf[0] = 0;
+				nphy_adj_noise_var_buf[0] = 0x0;
+				break;
+			}
 
-			WRITE_RADIO_REG3(pi, RADIO_2057, TX, coreNum,
-					 LOFT_COARSE_I,
-					 txcal_radio_regs[2 * coreNum + 4]);
-			WRITE_RADIO_REG3(pi, RADIO_2057, TX, coreNum,
-					 LOFT_COARSE_Q,
-					 txcal_radio_regs[2 * coreNum + 5]);
+			if (nphy_adj_tone_id_buf[0]
+			    && nphy_adj_noise_var_buf[0])
+				wlc_phy_adjust_min_noisevar_nphy(
+					pi, 1,
+					nphy_adj_tone_id_buf,
+					nphy_adj_noise_var_buf);
+			else
+				wlc_phy_adjust_min_noisevar_nphy(pi, 0, NULL,
+								 NULL);
 		}
+
+		if (pi->phyhang_avoid)
+			wlc_phy_stay_in_carriersearch_nphy(pi, false);
 	}
 }
 
-void wlc_phy_antsel_init(struct brcms_phy_pub *ppi, bool lut_init)
+void wlc_phy_init_nphy(struct brcms_phy *pi)
 {
-	struct brcms_phy *pi = (struct brcms_phy *) ppi;
-	u16 mask = 0xfc00;
-	u32 mc = 0;
+	u16 val;
+	u16 clip1_ths[2];
+	struct nphy_txgains target_gain;
+	u8 tx_pwr_ctrl_state;
+	bool do_nphy_cal = false;
+	uint core;
+	uint origidx, intr_val;
+	struct d11regs *regs;
+	u32 d11_clk_ctl_st;
+	bool do_rssi_cal = false;
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7))
-		return;
+	core = 0;
 
-	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-		u16 v0 = 0x211, v1 = 0x222, v2 = 0x144, v3 = 0x188;
+	if (!(pi->measure_hold & PHY_HOLD_FOR_SCAN))
+		pi->measure_hold |= PHY_HOLD_FOR_NOT_ASSOC;
 
-		if (lut_init == false)
-			return;
+	if ((ISNPHY(pi)) && (NREV_GE(pi->pubpi.phy_rev, 5)) &&
+	    ((pi->sh->chippkg == BCM4717_PKG_ID) ||
+	     (pi->sh->chippkg == BCM4718_PKG_ID))) {
+		if ((pi->sh->boardflags & BFL_EXTLNA) &&
+		    (CHSPEC_IS2G(pi->radio_chanspec)))
+			ai_corereg(pi->sh->sih, SI_CC_IDX,
+				   offsetof(struct chipcregs, chipcontrol),
+				   0x40, 0x40);
+	}
 
-		if (pi->srom_fem2g.antswctrllut == 0) {
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_ANTSWCTRLLUT,
-						 1, 0x02, 16, &v0);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_ANTSWCTRLLUT,
-						 1, 0x03, 16, &v1);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_ANTSWCTRLLUT,
-						 1, 0x08, 16, &v2);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_ANTSWCTRLLUT,
-						 1, 0x0C, 16, &v3);
-		}
+	if ((pi->nphy_gband_spurwar2_en) && CHSPEC_IS2G(pi->radio_chanspec) &&
+	    CHSPEC_IS40(pi->radio_chanspec)) {
 
-		if (pi->srom_fem5g.antswctrllut == 0) {
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_ANTSWCTRLLUT,
-						 1, 0x12, 16, &v0);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_ANTSWCTRLLUT,
-						 1, 0x13, 16, &v1);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_ANTSWCTRLLUT,
-						 1, 0x18, 16, &v2);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_ANTSWCTRLLUT,
-						 1, 0x1C, 16, &v3);
-		}
-	} else {
+		regs = (struct d11regs *) ai_switch_core(pi->sh->sih,
+							 D11_CORE_ID, &origidx,
+							 &intr_val);
+		d11_clk_ctl_st = R_REG(&regs->clk_ctl_st);
+		AND_REG(&regs->clk_ctl_st,
+			~(CCS_FORCEHT | CCS_HTAREQ));
 
-		write_phy_reg(pi, 0xc8, 0x0);
-		write_phy_reg(pi, 0xc9, 0x0);
+		W_REG(&regs->clk_ctl_st, d11_clk_ctl_st);
 
-		ai_gpiocontrol(pi->sh->sih, mask, mask, GPIO_DRV_PRIORITY);
+		ai_restore_core(pi->sh->sih, origidx, intr_val);
+	}
 
-		mc = R_REG(&pi->regs->maccontrol);
-		mc &= ~MCTL_GPOUT_SEL_MASK;
-		W_REG(&pi->regs->maccontrol, mc);
+	pi->use_int_tx_iqlo_cal_nphy =
+		(PHY_IPA(pi) ||
+		 (NREV_GE(pi->pubpi.phy_rev, 7) ||
+		  (NREV_GE(pi->pubpi.phy_rev, 5)
+		   && pi->sh->boardflags2 & BFL2_INTERNDET_TXIQCAL)));
 
-		OR_REG(&pi->regs->psm_gpio_oe, mask);
+	pi->internal_tx_iqlo_cal_tapoff_intpa_nphy = false;
 
-		AND_REG(&pi->regs->psm_gpio_out, ~mask);
+	pi->nphy_deaf_count = 0;
 
-		if (lut_init) {
-			write_phy_reg(pi, 0xf8, 0x02d8);
-			write_phy_reg(pi, 0xf9, 0x0301);
-			write_phy_reg(pi, 0xfa, 0x02d8);
-			write_phy_reg(pi, 0xfb, 0x0301);
+	wlc_phy_tbl_init_nphy(pi);
+
+	pi->nphy_crsminpwr_adjusted = false;
+	pi->nphy_noisevars_adjusted = false;
+
+	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+		write_phy_reg(pi, 0xe7, 0);
+		write_phy_reg(pi, 0xec, 0);
+		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+			write_phy_reg(pi, 0x342, 0);
+			write_phy_reg(pi, 0x343, 0);
+			write_phy_reg(pi, 0x346, 0);
+			write_phy_reg(pi, 0x347, 0);
 		}
+		write_phy_reg(pi, 0xe5, 0);
+		write_phy_reg(pi, 0xe6, 0);
+	} else {
+		write_phy_reg(pi, 0xec, 0);
 	}
-}
 
-u16 wlc_phy_classifier_nphy(struct brcms_phy *pi, u16 mask, u16 val)
-{
-	u16 curr_ctl, new_ctl;
-	bool suspended = false;
+	write_phy_reg(pi, 0x91, 0);
+	write_phy_reg(pi, 0x92, 0);
+	if (NREV_LT(pi->pubpi.phy_rev, 6)) {
+		write_phy_reg(pi, 0x93, 0);
+		write_phy_reg(pi, 0x94, 0);
+	}
 
-	if (D11REV_IS(pi->sh->corerev, 16)) {
-		suspended =
-			(R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC) ?
-			false : true;
-		if (!suspended)
-			wlapi_suspend_mac_and_wait(pi->sh->physhim);
+	and_phy_reg(pi, 0xa1, ~3);
+
+	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+		write_phy_reg(pi, 0x8f, 0);
+		write_phy_reg(pi, 0xa5, 0);
+	} else {
+		write_phy_reg(pi, 0xa5, 0);
 	}
 
-	curr_ctl = read_phy_reg(pi, 0xb0) & (0x7 << 0);
+	if (NREV_IS(pi->pubpi.phy_rev, 2))
+		mod_phy_reg(pi, 0xdc, 0x00ff, 0x3b);
+	else if (NREV_LT(pi->pubpi.phy_rev, 2))
+		mod_phy_reg(pi, 0xdc, 0x00ff, 0x40);
 
-	new_ctl = (curr_ctl & (~mask)) | (val & mask);
+	write_phy_reg(pi, 0x203, 32);
+	write_phy_reg(pi, 0x201, 32);
 
-	mod_phy_reg(pi, 0xb0, (0x7 << 0), new_ctl);
+	if (pi->sh->boardflags2 & BFL2_SKWRKFEM_BRD)
+		write_phy_reg(pi, 0x20d, 160);
+	else
+		write_phy_reg(pi, 0x20d, 184);
 
-	if (D11REV_IS(pi->sh->corerev, 16) && !suspended)
-		wlapi_enable_mac(pi->sh->physhim);
+	write_phy_reg(pi, 0x13a, 200);
 
-	return new_ctl;
-}
+	write_phy_reg(pi, 0x70, 80);
+
+	write_phy_reg(pi, 0x1ff, 48);
+
+	if (NREV_LT(pi->pubpi.phy_rev, 8))
+		wlc_phy_update_mimoconfig_nphy(pi, pi->n_preamble_override);
 
-static void wlc_phy_clip_det_nphy(struct brcms_phy *pi, u8 write, u16 *vals)
-{
+	wlc_phy_stf_chain_upd_nphy(pi);
 
-	if (write == 0) {
-		vals[0] = read_phy_reg(pi, 0x2c);
-		vals[1] = read_phy_reg(pi, 0x42);
-	} else {
-		write_phy_reg(pi, 0x2c, vals[0]);
-		write_phy_reg(pi, 0x42, vals[1]);
+	if (NREV_LT(pi->pubpi.phy_rev, 2)) {
+		write_phy_reg(pi, 0x180, 0xaa8);
+		write_phy_reg(pi, 0x181, 0x9a4);
 	}
-}
 
-void wlc_phy_force_rfseq_nphy(struct brcms_phy *pi, u8 cmd)
-{
-	u16 trigger_mask, status_mask;
-	u16 orig_RfseqCoreActv;
+	if (PHY_IPA(pi)) {
+		for (core = 0; core < pi->pubpi.phy_corenum; core++) {
 
-	switch (cmd) {
-	case NPHY_RFSEQ_RX2TX:
-		trigger_mask = NPHY_RfseqTrigger_rx2tx;
-		status_mask = NPHY_RfseqStatus_rx2tx;
-		break;
-	case NPHY_RFSEQ_TX2RX:
-		trigger_mask = NPHY_RfseqTrigger_tx2rx;
-		status_mask = NPHY_RfseqStatus_tx2rx;
-		break;
-	case NPHY_RFSEQ_RESET2RX:
-		trigger_mask = NPHY_RfseqTrigger_reset2rx;
-		status_mask = NPHY_RfseqStatus_reset2rx;
-		break;
-	case NPHY_RFSEQ_UPDATEGAINH:
-		trigger_mask = NPHY_RfseqTrigger_updategainh;
-		status_mask = NPHY_RfseqStatus_updategainh;
-		break;
-	case NPHY_RFSEQ_UPDATEGAINL:
-		trigger_mask = NPHY_RfseqTrigger_updategainl;
-		status_mask = NPHY_RfseqStatus_updategainl;
-		break;
-	case NPHY_RFSEQ_UPDATEGAINU:
-		trigger_mask = NPHY_RfseqTrigger_updategainu;
-		status_mask = NPHY_RfseqStatus_updategainu;
-		break;
-	default:
-		return;
+			mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x297 :
+				    0x29b, (0x1 << 0), (1) << 0);
+
+			mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x298 :
+				    0x29c, (0x1ff << 7),
+				    (pi->nphy_papd_epsilon_offset[core]) << 7);
+
+		}
+
+		wlc_phy_ipa_set_tx_digi_filts_nphy(pi);
+	} else if (NREV_GE(pi->pubpi.phy_rev, 5)) {
+		wlc_phy_extpa_set_tx_digi_filts_nphy(pi);
 	}
 
-	orig_RfseqCoreActv = read_phy_reg(pi, 0xa1);
-	or_phy_reg(pi, 0xa1,
-		   (NPHY_RfseqMode_CoreActv_override |
-		    NPHY_RfseqMode_Trigger_override));
-	or_phy_reg(pi, 0xa3, trigger_mask);
-	SPINWAIT((read_phy_reg(pi, 0xa4) & status_mask), 200000);
-	write_phy_reg(pi, 0xa1, orig_RfseqCoreActv);
-	WARN(read_phy_reg(pi, 0xa4) & status_mask, "HW error in rf");
-}
+	wlc_phy_workarounds_nphy(pi);
 
-static void
-wlc_phy_set_rfseq_nphy(struct brcms_phy *pi, u8 cmd, u8 *events, u8 *dlys,
-		       u8 len)
-{
-	u32 t1_offset, t2_offset;
-	u8 ctr;
-	u8 end_event =
-		NREV_GE(pi->pubpi.phy_rev,
-			3) ? NPHY_REV3_RFSEQ_CMD_END : NPHY_RFSEQ_CMD_END;
-	u8 end_dly = 1;
+	wlapi_bmac_phyclk_fgc(pi->sh->physhim, ON);
 
-	if (pi->phyhang_avoid)
-		wlc_phy_stay_in_carriersearch_nphy(pi, true);
+	val = read_phy_reg(pi, 0x01);
+	write_phy_reg(pi, 0x01, val | BBCFG_RESETCCA);
+	write_phy_reg(pi, 0x01, val & (~BBCFG_RESETCCA));
+	wlapi_bmac_phyclk_fgc(pi->sh->physhim, OFF);
 
-	t1_offset = cmd << 4;
-	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, len, t1_offset, 8,
-				 events);
-	t2_offset = t1_offset + 0x080;
-	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, len, t2_offset, 8,
-				 dlys);
+	wlapi_bmac_macphyclk_set(pi->sh->physhim, ON);
 
-	for (ctr = len; ctr < 16; ctr++) {
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 1,
-					 t1_offset + ctr, 8, &end_event);
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 1,
-					 t2_offset + ctr, 8, &end_dly);
-	}
+	wlc_phy_pa_override_nphy(pi, OFF);
+	wlc_phy_force_rfseq_nphy(pi, NPHY_RFSEQ_RX2TX);
+	wlc_phy_force_rfseq_nphy(pi, NPHY_RFSEQ_RESET2RX);
+	wlc_phy_pa_override_nphy(pi, ON);
 
-	if (pi->phyhang_avoid)
-		wlc_phy_stay_in_carriersearch_nphy(pi, false);
-}
+	wlc_phy_classifier_nphy(pi, 0, 0);
+	wlc_phy_clip_det_nphy(pi, 0, clip1_ths);
 
-static u16 wlc_phy_read_lpf_bw_ctl_nphy(struct brcms_phy *pi, u16 offset)
-{
-	u16 lpf_bw_ctl_val = 0;
-	u16 rx2tx_lpf_rc_lut_offset = 0;
+	if (CHSPEC_IS2G(pi->radio_chanspec))
+		wlc_phy_bphy_init_nphy(pi);
 
-	if (offset == 0) {
-		if (CHSPEC_IS40(pi->radio_chanspec))
-			rx2tx_lpf_rc_lut_offset = 0x159;
-		else
-			rx2tx_lpf_rc_lut_offset = 0x154;
-	} else {
-		rx2tx_lpf_rc_lut_offset = offset;
-	}
-	wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_RFSEQ, 1,
-				(u32) rx2tx_lpf_rc_lut_offset, 16,
-				&lpf_bw_ctl_val);
+	tx_pwr_ctrl_state = pi->nphy_txpwrctrl;
+	wlc_phy_txpwrctrl_enable_nphy(pi, PHY_TPC_HW_OFF);
 
-	lpf_bw_ctl_val = lpf_bw_ctl_val & 0x7;
+	wlc_phy_txpwr_fixpower_nphy(pi);
 
-	return lpf_bw_ctl_val;
-}
+	wlc_phy_txpwrctrl_idle_tssi_nphy(pi);
 
-static void
-wlc_phy_rfctrl_override_nphy_rev7(struct brcms_phy *pi, u16 field, u16 value,
-				  u8 core_mask, u8 off, u8 override_id)
-{
-	u8 core_num;
-	u16 addr = 0, en_addr = 0, val_addr = 0, en_mask = 0, val_mask = 0;
-	u8 val_shift = 0;
+	wlc_phy_txpwrctrl_pwr_setup_nphy(pi);
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-		en_mask = field;
-		for (core_num = 0; core_num < 2; core_num++) {
-			if (override_id == NPHY_REV7_RFCTRLOVERRIDE_ID0) {
+	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+		u32 *tx_pwrctrl_tbl = NULL;
+		u16 idx;
+		s16 pga_gn = 0;
+		s16 pad_gn = 0;
+		s32 rfpwr_offset;
 
-				switch (field) {
-				case (0x1 << 2):
-					en_addr = (core_num == 0) ? 0xe7 : 0xec;
-					val_addr = (core_num == 0) ? 0x7a :
-						   0x7d;
-					val_mask = (0x1 << 1);
-					val_shift = 1;
-					break;
-				case (0x1 << 3):
-					en_addr = (core_num == 0) ? 0xe7 : 0xec;
-					val_addr = (core_num == 0) ? 0x7a :
-						   0x7d;
-					val_mask = (0x1 << 2);
-					val_shift = 2;
-					break;
-				case (0x1 << 4):
-					en_addr = (core_num == 0) ? 0xe7 : 0xec;
-					val_addr = (core_num == 0) ? 0x7a :
-						   0x7d;
-					val_mask = (0x1 << 4);
-					val_shift = 4;
-					break;
-				case (0x1 << 5):
-					en_addr = (core_num == 0) ? 0xe7 : 0xec;
-					val_addr = (core_num == 0) ? 0x7a :
-						   0x7d;
-					val_mask = (0x1 << 5);
-					val_shift = 5;
-					break;
-				case (0x1 << 6):
-					en_addr = (core_num == 0) ? 0xe7 : 0xec;
-					val_addr = (core_num == 0) ? 0x7a :
-						   0x7d;
-					val_mask = (0x1 << 6);
-					val_shift = 6;
-					break;
-				case (0x1 << 7):
-					en_addr = (core_num == 0) ? 0xe7 : 0xec;
-					val_addr = (core_num == 0) ? 0x7a :
-						   0x7d;
-					val_mask = (0x1 << 7);
-					val_shift = 7;
-					break;
-				case (0x1 << 10):
-					en_addr = (core_num == 0) ? 0xe7 : 0xec;
-					val_addr = (core_num == 0) ? 0xf8 :
-						   0xfa;
-					val_mask = (0x7 << 4);
-					val_shift = 4;
-					break;
-				case (0x1 << 11):
-					en_addr = (core_num == 0) ? 0xe7 : 0xec;
-					val_addr = (core_num == 0) ? 0x7b :
-						   0x7e;
-					val_mask = (0xffff << 0);
-					val_shift = 0;
-					break;
-				case (0x1 << 12):
-					en_addr = (core_num == 0) ? 0xe7 : 0xec;
-					val_addr = (core_num == 0) ? 0x7c :
-						   0x7f;
-					val_mask = (0xffff << 0);
-					val_shift = 0;
-					break;
-				case (0x3 << 13):
-					en_addr = (core_num == 0) ? 0xe7 : 0xec;
-					val_addr = (core_num == 0) ? 0x348 :
-						   0x349;
-					val_mask = (0xff << 0);
-					val_shift = 0;
-					break;
-				case (0x1 << 13):
-					en_addr = (core_num == 0) ? 0xe7 : 0xec;
-					val_addr = (core_num == 0) ? 0x348 :
-						   0x349;
-					val_mask = (0xf << 0);
-					val_shift = 0;
-					break;
-				default:
-					addr = 0xffff;
-					break;
+		if (PHY_IPA(pi)) {
+			tx_pwrctrl_tbl = wlc_phy_get_ipa_gaintbl_nphy(pi);
+		} else {
+			if (CHSPEC_IS5G(pi->radio_chanspec)) {
+				if (NREV_IS(pi->pubpi.phy_rev, 3))
+					tx_pwrctrl_tbl =
+						nphy_tpc_5GHz_txgain_rev3;
+				else if (NREV_IS(pi->pubpi.phy_rev, 4))
+					tx_pwrctrl_tbl =
+						(pi->srom_fem5g.extpagain ==
+						 3) ?
+						nphy_tpc_5GHz_txgain_HiPwrEPA :
+						nphy_tpc_5GHz_txgain_rev4;
+				else
+					tx_pwrctrl_tbl =
+						nphy_tpc_5GHz_txgain_rev5;
+			} else {
+				if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+					if (pi->pubpi.radiorev == 5)
+						tx_pwrctrl_tbl =
+						   nphy_tpc_txgain_epa_2057rev5;
+					else if (pi->pubpi.radiorev == 3)
+						tx_pwrctrl_tbl =
+						   nphy_tpc_txgain_epa_2057rev3;
+				} else {
+					if (NREV_GE(pi->pubpi.phy_rev, 5) &&
+					    (pi->srom_fem2g.extpagain == 3))
+						tx_pwrctrl_tbl =
+						       nphy_tpc_txgain_HiPwrEPA;
+					else
+						tx_pwrctrl_tbl =
+							nphy_tpc_txgain_rev3;
 				}
-			} else if (override_id ==
-				   NPHY_REV7_RFCTRLOVERRIDE_ID1) {
+			}
+		}
 
-				switch (field) {
-				case (0x1 << 1):
-					en_addr = (core_num == 0) ? 0x342 :
-						  0x343;
-					val_addr = (core_num == 0) ? 0x340 :
-						   0x341;
-					val_mask = (0x1 << 1);
-					val_shift = 1;
-					break;
-				case (0x1 << 3):
-					en_addr = (core_num == 0) ? 0x342 :
-						  0x343;
-					val_addr = (core_num == 0) ? 0x340 :
-						   0x341;
-					val_mask = (0x1 << 3);
-					val_shift = 3;
-					break;
-				case (0x1 << 5):
-					en_addr = (core_num == 0) ? 0x342 :
-						  0x343;
-					val_addr = (core_num == 0) ? 0x340 :
-						   0x341;
-					val_mask = (0x1 << 5);
-					val_shift = 5;
-					break;
-				case (0x1 << 4):
-					en_addr = (core_num == 0) ? 0x342 :
-						  0x343;
-					val_addr = (core_num == 0) ? 0x340 :
-						   0x341;
-					val_mask = (0x1 << 4);
-					val_shift = 4;
-					break;
-				case (0x1 << 2):
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_CORE1TXPWRCTL, 128,
+					 192, 32, tx_pwrctrl_tbl);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_CORE2TXPWRCTL, 128,
+					 192, 32, tx_pwrctrl_tbl);
 
-					en_addr = (core_num == 0) ? 0x342 :
-						  0x343;
-					val_addr = (core_num == 0) ? 0x340 :
-						   0x341;
-					val_mask = (0x1 << 2);
-					val_shift = 2;
-					break;
-				case (0x1 << 7):
+		pi->nphy_gmval = (u16) ((*tx_pwrctrl_tbl >> 16) & 0x7000);
 
-					en_addr = (core_num == 0) ? 0x342 :
-						  0x343;
-					val_addr = (core_num == 0) ? 0x340 :
-						   0x341;
-					val_mask = (0x7 << 8);
-					val_shift = 8;
-					break;
-				case (0x1 << 11):
-					en_addr = (core_num == 0) ? 0x342 :
-						  0x343;
-					val_addr = (core_num == 0) ? 0x340 :
-						   0x341;
-					val_mask = (0x1 << 14);
-					val_shift = 14;
-					break;
-				case (0x1 << 10):
-					en_addr = (core_num == 0) ? 0x342 :
-						  0x343;
-					val_addr = (core_num == 0) ? 0x340 :
-						   0x341;
-					val_mask = (0x1 << 13);
-					val_shift = 13;
-					break;
-				case (0x1 << 9):
-					en_addr = (core_num == 0) ? 0x342 :
-						  0x343;
-					val_addr = (core_num == 0) ? 0x340 :
-						   0x341;
-					val_mask = (0x1 << 12);
-					val_shift = 12;
-					break;
-				case (0x1 << 8):
-					en_addr = (core_num == 0) ? 0x342 :
-						  0x343;
-					val_addr = (core_num == 0) ? 0x340 :
-						   0x341;
-					val_mask = (0x1 << 11);
-					val_shift = 11;
-					break;
-				case (0x1 << 6):
-					en_addr = (core_num == 0) ? 0x342 :
-						  0x343;
-					val_addr = (core_num == 0) ? 0x340 :
-						   0x341;
-					val_mask = (0x1 << 6);
-					val_shift = 6;
-					break;
-				case (0x1 << 0):
-					en_addr = (core_num == 0) ? 0x342 :
-						  0x343;
-					val_addr = (core_num == 0) ? 0x340 :
-						   0x341;
-					val_mask = (0x1 << 0);
-					val_shift = 0;
-					break;
-				default:
-					addr = 0xffff;
-					break;
-				}
-			} else if (override_id ==
-				   NPHY_REV7_RFCTRLOVERRIDE_ID2) {
+		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 
-				switch (field) {
-				case (0x1 << 3):
-					en_addr = (core_num == 0) ? 0x346 :
-						  0x347;
-					val_addr = (core_num == 0) ? 0x344 :
-						   0x345;
-					val_mask = (0x1 << 3);
-					val_shift = 3;
-					break;
-				case (0x1 << 1):
-					en_addr = (core_num == 0) ? 0x346 :
-						  0x347;
-					val_addr = (core_num == 0) ? 0x344 :
-						   0x345;
-					val_mask = (0x1 << 1);
-					val_shift = 1;
-					break;
-				case (0x1 << 0):
-					en_addr = (core_num == 0) ? 0x346 :
-						  0x347;
-					val_addr = (core_num == 0) ? 0x344 :
-						   0x345;
-					val_mask = (0x1 << 0);
-					val_shift = 0;
-					break;
-				case (0x1 << 2):
-					en_addr = (core_num == 0) ? 0x346 :
-						  0x347;
-					val_addr = (core_num == 0) ? 0x344 :
-						   0x345;
-					val_mask = (0x1 << 2);
-					val_shift = 2;
-					break;
-				case (0x1 << 4):
-					en_addr = (core_num == 0) ? 0x346 :
-						  0x347;
-					val_addr = (core_num == 0) ? 0x344 :
-						   0x345;
-					val_mask = (0x1 << 4);
-					val_shift = 4;
-					break;
-				default:
-					addr = 0xffff;
-					break;
-				}
+			for (idx = 0; idx < 128; idx++) {
+				pga_gn = (tx_pwrctrl_tbl[idx] >> 24) & 0xf;
+				pad_gn = (tx_pwrctrl_tbl[idx] >> 19) & 0x1f;
+				rfpwr_offset = get_rf_pwr_offset(pi, pga_gn,
+								 pad_gn);
+				wlc_phy_table_write_nphy(
+					pi,
+					NPHY_TBL_ID_CORE1TXPWRCTL,
+					1, 576 + idx, 32,
+					&rfpwr_offset);
+				wlc_phy_table_write_nphy(
+					pi,
+					NPHY_TBL_ID_CORE2TXPWRCTL,
+					1, 576 + idx, 32,
+					&rfpwr_offset);
+			}
+		} else {
+
+			for (idx = 0; idx < 128; idx++) {
+				pga_gn = (tx_pwrctrl_tbl[idx] >> 24) & 0xf;
+				if (CHSPEC_IS2G(pi->radio_chanspec))
+					rfpwr_offset = (s16)
+						 nphy_papd_pga_gain_delta_ipa_2g
+								       [pga_gn];
+				else
+					rfpwr_offset = (s16)
+						 nphy_papd_pga_gain_delta_ipa_5g
+								       [pga_gn];
+
+				wlc_phy_table_write_nphy(
+					pi,
+					NPHY_TBL_ID_CORE1TXPWRCTL,
+					1, 576 + idx, 32,
+					&rfpwr_offset);
+				wlc_phy_table_write_nphy(
+					pi,
+					NPHY_TBL_ID_CORE2TXPWRCTL,
+					1, 576 + idx, 32,
+					&rfpwr_offset);
 			}
 
-			if (off) {
-				and_phy_reg(pi, en_addr, ~en_mask);
-				and_phy_reg(pi, val_addr, ~val_mask);
-			} else {
+		}
+	} else {
+
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_CORE1TXPWRCTL, 128,
+					 192, 32, nphy_tpc_txgain);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_CORE2TXPWRCTL, 128,
+					 192, 32, nphy_tpc_txgain);
+	}
+
+	if (pi->sh->phyrxchain != 0x3)
+		wlc_phy_rxcore_setstate_nphy((struct brcms_phy_pub *) pi,
+					     pi->sh->phyrxchain);
+
+	if (PHY_PERICAL_MPHASE_PENDING(pi))
+		wlc_phy_cal_perical_mphase_restart(pi);
+
+	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+		do_rssi_cal = (CHSPEC_IS2G(pi->radio_chanspec)) ?
+			      (pi->nphy_rssical_chanspec_2G == 0) :
+			      (pi->nphy_rssical_chanspec_5G == 0);
+
+		if (do_rssi_cal)
+			wlc_phy_rssi_cal_nphy(pi);
+		else
+			wlc_phy_restore_rssical_nphy(pi);
+	} else {
+		wlc_phy_rssi_cal_nphy(pi);
+	}
+
+	if (!SCAN_RM_IN_PROGRESS(pi))
+		do_nphy_cal = (CHSPEC_IS2G(pi->radio_chanspec)) ?
+			      (pi->nphy_iqcal_chanspec_2G == 0) :
+			      (pi->nphy_iqcal_chanspec_5G == 0);
+
+	if (!pi->do_initcal)
+		do_nphy_cal = false;
+
+	if (do_nphy_cal) {
+
+		target_gain = wlc_phy_get_tx_gain_nphy(pi);
+
+		if (pi->antsel_type == ANTSEL_2x3)
+			wlc_phy_antsel_init((struct brcms_phy_pub *) pi,
+					    true);
+
+		if (pi->nphy_perical != PHY_PERICAL_MPHASE) {
+			wlc_phy_rssi_cal_nphy(pi);
+
+			if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+				pi->nphy_cal_orig_pwr_idx[0] =
+					pi->nphy_txpwrindex[PHY_CORE_0]
+					.
+					index_internal;
+				pi->nphy_cal_orig_pwr_idx[1] =
+					pi->nphy_txpwrindex[PHY_CORE_1]
+					.
+					index_internal;
+
+				wlc_phy_precal_txgain_nphy(pi);
+				target_gain =
+					wlc_phy_get_tx_gain_nphy(pi);
+			}
 
-				if ((core_mask == 0)
-				    || (core_mask & (1 << core_num))) {
-					or_phy_reg(pi, en_addr, en_mask);
+			if (wlc_phy_cal_txiqlo_nphy
+				    (pi, target_gain, true,
+				    false) == 0) {
+				if (wlc_phy_cal_rxiq_nphy
+					    (pi, target_gain, 2,
+					    false) == 0)
+					wlc_phy_savecal_nphy(pi);
 
-					if (addr != 0xffff)
-						mod_phy_reg(pi, val_addr,
-							    val_mask,
-							    (value <<
-							     val_shift));
-				}
 			}
+		} else if (pi->mphase_cal_phase_id ==
+			   MPHASE_CAL_STATE_IDLE) {
+			wlc_phy_cal_perical((struct brcms_phy_pub *) pi,
+					    PHY_PERICAL_PHYINIT);
 		}
+	} else {
+		wlc_phy_restorecal_nphy(pi);
 	}
+
+	wlc_phy_txpwrctrl_coeff_setup_nphy(pi);
+
+	wlc_phy_txpwrctrl_enable_nphy(pi, tx_pwr_ctrl_state);
+
+	wlc_phy_nphy_tkip_rifs_war(pi, pi->sh->_rifs_phy);
+
+	if (NREV_GE(pi->pubpi.phy_rev, 3) && NREV_LE(pi->pubpi.phy_rev, 6))
+
+		write_phy_reg(pi, 0x70, 50);
+
+	wlc_phy_txlpfbw_nphy(pi);
+
+	wlc_phy_spurwar_nphy(pi);
+
 }
 
-static void
-wlc_phy_rfctrl_override_nphy(struct brcms_phy *pi, u16 field, u16 value,
-			     u8 core_mask, u8 off)
+static void wlc_phy_resetcca_nphy(struct brcms_phy *pi)
 {
-	u8 core_num;
-	u16 addr = 0, mask = 0, en_addr = 0, val_addr = 0, en_mask =
-		0, val_mask = 0;
-	u8 shift = 0, val_shift = 0;
+	u16 val;
 
-	if (NREV_GE(pi->pubpi.phy_rev, 3) && NREV_LT(pi->pubpi.phy_rev, 7)) {
+	wlapi_bmac_phyclk_fgc(pi->sh->physhim, ON);
 
-		en_mask = field;
-		for (core_num = 0; core_num < 2; core_num++) {
+	val = read_phy_reg(pi, 0x01);
+	write_phy_reg(pi, 0x01, val | BBCFG_RESETCCA);
+	udelay(1);
+	write_phy_reg(pi, 0x01, val & (~BBCFG_RESETCCA));
 
-			switch (field) {
-			case (0x1 << 1):
-				en_addr = (core_num == 0) ? 0xe7 : 0xec;
-				val_addr = (core_num == 0) ? 0x7a : 0x7d;
-				val_mask = (0x1 << 0);
-				val_shift = 0;
-				break;
-			case (0x1 << 2):
-				en_addr = (core_num == 0) ? 0xe7 : 0xec;
-				val_addr = (core_num == 0) ? 0x7a : 0x7d;
-				val_mask = (0x1 << 1);
-				val_shift = 1;
-				break;
-			case (0x1 << 3):
-				en_addr = (core_num == 0) ? 0xe7 : 0xec;
-				val_addr = (core_num == 0) ? 0x7a : 0x7d;
-				val_mask = (0x1 << 2);
-				val_shift = 2;
-				break;
-			case (0x1 << 4):
-				en_addr = (core_num == 0) ? 0xe7 : 0xec;
-				val_addr = (core_num == 0) ? 0x7a : 0x7d;
-				val_mask = (0x1 << 4);
-				val_shift = 4;
-				break;
-			case (0x1 << 5):
-				en_addr = (core_num == 0) ? 0xe7 : 0xec;
-				val_addr = (core_num == 0) ? 0x7a : 0x7d;
-				val_mask = (0x1 << 5);
-				val_shift = 5;
-				break;
-			case (0x1 << 6):
-				en_addr = (core_num == 0) ? 0xe7 : 0xec;
-				val_addr = (core_num == 0) ? 0x7a : 0x7d;
-				val_mask = (0x1 << 6);
-				val_shift = 6;
-				break;
-			case (0x1 << 7):
-				en_addr = (core_num == 0) ? 0xe7 : 0xec;
-				val_addr = (core_num == 0) ? 0x7a : 0x7d;
-				val_mask = (0x1 << 7);
-				val_shift = 7;
-				break;
-			case (0x1 << 8):
-				en_addr = (core_num == 0) ? 0xe7 : 0xec;
-				val_addr = (core_num == 0) ? 0x7a : 0x7d;
-				val_mask = (0x7 << 8);
-				val_shift = 8;
-				break;
-			case (0x1 << 11):
-				en_addr = (core_num == 0) ? 0xe7 : 0xec;
-				val_addr = (core_num == 0) ? 0x7a : 0x7d;
-				val_mask = (0x7 << 13);
-				val_shift = 13;
-				break;
+	wlapi_bmac_phyclk_fgc(pi->sh->physhim, OFF);
 
-			case (0x1 << 9):
-				en_addr = (core_num == 0) ? 0xe7 : 0xec;
-				val_addr = (core_num == 0) ? 0xf8 : 0xfa;
-				val_mask = (0x7 << 0);
-				val_shift = 0;
-				break;
+	wlc_phy_force_rfseq_nphy(pi, NPHY_RFSEQ_RESET2RX);
+}
 
-			case (0x1 << 10):
-				en_addr = (core_num == 0) ? 0xe7 : 0xec;
-				val_addr = (core_num == 0) ? 0xf8 : 0xfa;
-				val_mask = (0x7 << 4);
-				val_shift = 4;
-				break;
+void wlc_phy_pa_override_nphy(struct brcms_phy *pi, bool en)
+{
+	u16 rfctrlintc_override_val;
 
-			case (0x1 << 12):
-				en_addr = (core_num == 0) ? 0xe7 : 0xec;
-				val_addr = (core_num == 0) ? 0x7b : 0x7e;
-				val_mask = (0xffff << 0);
-				val_shift = 0;
-				break;
-			case (0x1 << 13):
-				en_addr = (core_num == 0) ? 0xe7 : 0xec;
-				val_addr = (core_num == 0) ? 0x7c : 0x7f;
-				val_mask = (0xffff << 0);
-				val_shift = 0;
-				break;
-			case (0x1 << 14):
-				en_addr = (core_num == 0) ? 0xe7 : 0xec;
-				val_addr = (core_num == 0) ? 0xf9 : 0xfb;
-				val_mask = (0x3 << 6);
-				val_shift = 6;
-				break;
-			case (0x1 << 0):
-				en_addr = (core_num == 0) ? 0xe5 : 0xe6;
-				val_addr = (core_num == 0) ? 0xf9 : 0xfb;
-				val_mask = (0x1 << 15);
-				val_shift = 15;
-				break;
-			default:
-				addr = 0xffff;
-				break;
-			}
+	if (!en) {
 
-			if (off) {
-				and_phy_reg(pi, en_addr, ~en_mask);
-				and_phy_reg(pi, val_addr, ~val_mask);
-			} else {
+		pi->rfctrlIntc1_save = read_phy_reg(pi, 0x91);
+		pi->rfctrlIntc2_save = read_phy_reg(pi, 0x92);
+
+		if (NREV_GE(pi->pubpi.phy_rev, 7))
+			rfctrlintc_override_val = 0x1480;
+		else if (NREV_GE(pi->pubpi.phy_rev, 3))
+			rfctrlintc_override_val =
+				CHSPEC_IS5G(pi->radio_chanspec) ? 0x600 : 0x480;
+		else
+			rfctrlintc_override_val =
+				CHSPEC_IS5G(pi->radio_chanspec) ? 0x180 : 0x120;
+
+		write_phy_reg(pi, 0x91, rfctrlintc_override_val);
+		write_phy_reg(pi, 0x92, rfctrlintc_override_val);
+	} else {
+		write_phy_reg(pi, 0x91, pi->rfctrlIntc1_save);
+		write_phy_reg(pi, 0x92, pi->rfctrlIntc2_save);
+	}
+
+}
+
+void wlc_phy_stf_chain_upd_nphy(struct brcms_phy *pi)
+{
+
+	u16 txrx_chain =
+		(NPHY_RfseqCoreActv_TxRxChain0 | NPHY_RfseqCoreActv_TxRxChain1);
+	bool CoreActv_override = false;
+
+	if (pi->nphy_txrx_chain == BRCMS_N_TXRX_CHAIN0) {
+		txrx_chain = NPHY_RfseqCoreActv_TxRxChain0;
+		CoreActv_override = true;
+
+		if (NREV_LE(pi->pubpi.phy_rev, 2))
+			and_phy_reg(pi, 0xa0, ~0x20);
+	} else if (pi->nphy_txrx_chain == BRCMS_N_TXRX_CHAIN1) {
+		txrx_chain = NPHY_RfseqCoreActv_TxRxChain1;
+		CoreActv_override = true;
+
+		if (NREV_LE(pi->pubpi.phy_rev, 2))
+			or_phy_reg(pi, 0xa0, 0x20);
+	}
+
+	mod_phy_reg(pi, 0xa2, ((0xf << 0) | (0xf << 4)), txrx_chain);
+
+	if (CoreActv_override) {
+		pi->nphy_perical = PHY_PERICAL_DISABLE;
+		or_phy_reg(pi, 0xa1, NPHY_RfseqMode_CoreActv_override);
+	} else {
+		pi->nphy_perical = PHY_PERICAL_MPHASE;
+		and_phy_reg(pi, 0xa1, ~NPHY_RfseqMode_CoreActv_override);
+	}
+}
+
+void wlc_phy_rxcore_setstate_nphy(struct brcms_phy_pub *pih, u8 rxcore_bitmask)
+{
+	u16 regval;
+	u16 tbl_buf[16];
+	uint i;
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
+	u16 tbl_opcode;
+	bool suspend;
+
+	pi->sh->phyrxchain = rxcore_bitmask;
+
+	if (!pi->sh->clk)
+		return;
+
+	suspend = (0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
+	if (!suspend)
+		wlapi_suspend_mac_and_wait(pi->sh->physhim);
+
+	if (pi->phyhang_avoid)
+		wlc_phy_stay_in_carriersearch_nphy(pi, true);
+
+	regval = read_phy_reg(pi, 0xa2);
+	regval &= ~(0xf << 4);
+	regval |= ((u16) (rxcore_bitmask & 0x3)) << 4;
+	write_phy_reg(pi, 0xa2, regval);
+
+	if ((rxcore_bitmask & 0x3) != 0x3) {
+
+		write_phy_reg(pi, 0x20e, 1);
 
-				if ((core_mask == 0)
-				    || (core_mask & (1 << core_num))) {
-					or_phy_reg(pi, en_addr, en_mask);
+		if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+			if (pi->rx2tx_biasentry == -1) {
+				wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_RFSEQ,
+							ARRAY_SIZE(tbl_buf), 80,
+							16, tbl_buf);
 
-					if (addr != 0xffff)
-						mod_phy_reg(pi, val_addr,
-							    val_mask,
-							    (value <<
-							     val_shift));
+				for (i = 0; i < ARRAY_SIZE(tbl_buf); i++) {
+					if (tbl_buf[i] ==
+					    NPHY_REV3_RFSEQ_CMD_CLR_RXRX_BIAS) {
+						pi->rx2tx_biasentry = (u8) i;
+						tbl_opcode =
+							NPHY_REV3_RFSEQ_CMD_NOP;
+						wlc_phy_table_write_nphy(
+							pi,
+							NPHY_TBL_ID_RFSEQ,
+							1, i,
+							16,
+							&tbl_opcode);
+						break;
+					} else if (tbl_buf[i] ==
+						   NPHY_REV3_RFSEQ_CMD_END)
+						break;
 				}
 			}
 		}
 	} else {
 
-		if (off) {
-			and_phy_reg(pi, 0xec, ~field);
-			value = 0x0;
-		} else {
-			or_phy_reg(pi, 0xec, field);
+		write_phy_reg(pi, 0x20e, 30);
+
+		if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+			if (pi->rx2tx_biasentry != -1) {
+				tbl_opcode = NPHY_REV3_RFSEQ_CMD_CLR_RXRX_BIAS;
+				wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ,
+							 1, pi->rx2tx_biasentry,
+							 16, &tbl_opcode);
+				pi->rx2tx_biasentry = -1;
+			}
 		}
+	}
 
-		for (core_num = 0; core_num < 2; core_num++) {
+	wlc_phy_force_rfseq_nphy(pi, NPHY_RFSEQ_RESET2RX);
 
-			switch (field) {
-			case (0x1 << 1):
-			case (0x1 << 9):
-			case (0x1 << 12):
-			case (0x1 << 13):
-			case (0x1 << 14):
-				addr = 0x78;
+	if (pi->phyhang_avoid)
+		wlc_phy_stay_in_carriersearch_nphy(pi, false);
 
-				core_mask = 0x1;
-				break;
-			case (0x1 << 2):
-			case (0x1 << 3):
-			case (0x1 << 4):
-			case (0x1 << 5):
-			case (0x1 << 6):
-			case (0x1 << 7):
-			case (0x1 << 8):
-				addr = (core_num == 0) ? 0x7a : 0x7d;
-				break;
-			case (0x1 << 10):
-				addr = (core_num == 0) ? 0x7b : 0x7e;
-				break;
-			case (0x1 << 11):
-				addr = (core_num == 0) ? 0x7c : 0x7f;
-				break;
-			default:
-				addr = 0xffff;
-			}
+	if (!suspend)
+		wlapi_enable_mac(pi->sh->physhim);
+}
 
-			switch (field) {
-			case (0x1 << 1):
-				mask = (0x7 << 3);
-				shift = 3;
-				break;
-			case (0x1 << 9):
-				mask = (0x1 << 2);
-				shift = 2;
-				break;
-			case (0x1 << 12):
-				mask = (0x1 << 8);
-				shift = 8;
-				break;
-			case (0x1 << 13):
-				mask = (0x1 << 9);
-				shift = 9;
-				break;
-			case (0x1 << 14):
-				mask = (0xf << 12);
-				shift = 12;
-				break;
-			case (0x1 << 2):
-				mask = (0x1 << 0);
-				shift = 0;
-				break;
-			case (0x1 << 3):
-				mask = (0x1 << 1);
-				shift = 1;
-				break;
-			case (0x1 << 4):
-				mask = (0x1 << 2);
-				shift = 2;
-				break;
-			case (0x1 << 5):
-				mask = (0x3 << 4);
-				shift = 4;
-				break;
-			case (0x1 << 6):
-				mask = (0x3 << 6);
-				shift = 6;
-				break;
-			case (0x1 << 7):
-				mask = (0x1 << 8);
-				shift = 8;
-				break;
-			case (0x1 << 8):
-				mask = (0x1 << 9);
-				shift = 9;
-				break;
-			case (0x1 << 10):
-				mask = 0x1fff;
-				shift = 0x0;
-				break;
-			case (0x1 << 11):
-				mask = 0x1fff;
-				shift = 0x0;
-				break;
-			default:
-				mask = 0x0;
-				shift = 0x0;
-				break;
-			}
+u8 wlc_phy_rxcore_getstate_nphy(struct brcms_phy_pub *pih)
+{
+	u16 regval, rxen_bits;
+	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
-			if ((addr != 0xffff) && (core_mask & (1 << core_num)))
-				mod_phy_reg(pi, addr, mask, (value << shift));
-		}
+	regval = read_phy_reg(pi, 0xa2);
+	rxen_bits = (regval >> 4) & 0xf;
 
-		or_phy_reg(pi, 0xec, (0x1 << 0));
-		or_phy_reg(pi, 0x78, (0x1 << 0));
-		udelay(1);
-		and_phy_reg(pi, 0xec, ~(0x1 << 0));
-	}
+	return (u8) rxen_bits;
 }
 
-static void
-wlc_phy_rfctrl_override_1tomany_nphy(struct brcms_phy *pi, u16 cmd, u16 value,
-				     u8 core_mask, u8 off)
+bool wlc_phy_n_txpower_ipa_ison(struct brcms_phy *pi)
 {
-	u16 rfmxgain = 0, lpfgain = 0;
-	u16 tgain = 0;
+	return PHY_IPA(pi);
+}
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+void wlc_phy_cal_init_nphy(struct brcms_phy *pi)
+{
+}
 
-		switch (cmd) {
-		case NPHY_REV7_RfctrlOverride_cmd_rxrf_pu:
-			wlc_phy_rfctrl_override_nphy_rev7(
-				pi, (0x1 << 5),
-				value, core_mask, off,
-				NPHY_REV7_RFCTRLOVERRIDE_ID1);
-			wlc_phy_rfctrl_override_nphy_rev7(
-				pi, (0x1 << 4), value,
-				core_mask, off,
-				NPHY_REV7_RFCTRLOVERRIDE_ID1);
-			wlc_phy_rfctrl_override_nphy_rev7(
-				pi, (0x1 << 3), value,
-				core_mask, off,
-				NPHY_REV7_RFCTRLOVERRIDE_ID1);
-			break;
-		case NPHY_REV7_RfctrlOverride_cmd_rx_pu:
-			wlc_phy_rfctrl_override_nphy_rev7(
-				pi, (0x1 << 2),
-				value, core_mask, off,
-				NPHY_REV7_RFCTRLOVERRIDE_ID1);
-			wlc_phy_rfctrl_override_nphy_rev7(
-				pi, (0x1 << 1), value,
-				core_mask, off,
-				NPHY_REV7_RFCTRLOVERRIDE_ID1);
-			wlc_phy_rfctrl_override_nphy_rev7(
-				pi, (0x1 << 0), value,
-				core_mask, off,
-				NPHY_REV7_RFCTRLOVERRIDE_ID1);
-			wlc_phy_rfctrl_override_nphy_rev7(
-				pi, (0x1 << 1), value,
-				core_mask, off,
-				NPHY_REV7_RFCTRLOVERRIDE_ID2);
-			wlc_phy_rfctrl_override_nphy_rev7(
-				pi, (0x1 << 11), 0,
-				core_mask, off,
-				NPHY_REV7_RFCTRLOVERRIDE_ID1);
-			break;
-		case NPHY_REV7_RfctrlOverride_cmd_tx_pu:
-			wlc_phy_rfctrl_override_nphy_rev7(
-				pi, (0x1 << 2),
-				value, core_mask, off,
-				NPHY_REV7_RFCTRLOVERRIDE_ID0);
-			wlc_phy_rfctrl_override_nphy_rev7(
-				pi, (0x1 << 1), value,
-				core_mask, off,
-				NPHY_REV7_RFCTRLOVERRIDE_ID1);
-			wlc_phy_rfctrl_override_nphy_rev7(
-				pi, (0x1 << 0), value,
-				core_mask, off,
-				NPHY_REV7_RFCTRLOVERRIDE_ID2);
-			wlc_phy_rfctrl_override_nphy_rev7(
-				pi, (0x1 << 2), value,
-				core_mask, off,
-				NPHY_REV7_RFCTRLOVERRIDE_ID2);
-			wlc_phy_rfctrl_override_nphy_rev7(
-				pi, (0x1 << 11), 1,
-				core_mask, off,
-				NPHY_REV7_RFCTRLOVERRIDE_ID1);
+static void wlc_phy_radio_preinit_205x(struct brcms_phy *pi)
+{
+
+	and_phy_reg(pi, 0x78, ~RFCC_CHIP0_PU);
+	and_phy_reg(pi, 0x78, RFCC_OE_POR_FORCE);
+
+	or_phy_reg(pi, 0x78, ~RFCC_OE_POR_FORCE);
+	or_phy_reg(pi, 0x78, RFCC_CHIP0_PU);
+
+}
+
+static void wlc_phy_radio_init_2057(struct brcms_phy *pi)
+{
+	struct radio_20xx_regs *regs_2057_ptr = NULL;
+
+	if (NREV_IS(pi->pubpi.phy_rev, 7)) {
+		regs_2057_ptr = regs_2057_rev4;
+	} else if (NREV_IS(pi->pubpi.phy_rev, 8)
+		   || NREV_IS(pi->pubpi.phy_rev, 9)) {
+		switch (pi->pubpi.radiorev) {
+		case 5:
+
+			if (pi->pubpi.radiover == 0x0)
+				regs_2057_ptr = regs_2057_rev5;
+			else if (pi->pubpi.radiover == 0x1)
+				regs_2057_ptr = regs_2057_rev5v1;
+			else
+				break;
+
+		case 7:
+
+			regs_2057_ptr = regs_2057_rev7;
 			break;
-		case NPHY_REV7_RfctrlOverride_cmd_rxgain:
-			rfmxgain = value & 0x000ff;
-			lpfgain = value & 0x0ff00;
-			lpfgain = lpfgain >> 8;
 
-			wlc_phy_rfctrl_override_nphy_rev7(
-				pi, (0x1 << 11),
-				rfmxgain, core_mask,
-				off,
-				NPHY_REV7_RFCTRLOVERRIDE_ID0);
-			wlc_phy_rfctrl_override_nphy_rev7(
-				pi, (0x3 << 13),
-				lpfgain, core_mask,
-				off,
-				NPHY_REV7_RFCTRLOVERRIDE_ID0);
+		case 8:
+
+			regs_2057_ptr = regs_2057_rev8;
 			break;
-		case NPHY_REV7_RfctrlOverride_cmd_txgain:
-			tgain = value & 0x7fff;
-			lpfgain = value & 0x8000;
-			lpfgain = lpfgain >> 14;
 
-			wlc_phy_rfctrl_override_nphy_rev7(
-				pi, (0x1 << 12),
-				tgain, core_mask, off,
-				NPHY_REV7_RFCTRLOVERRIDE_ID0);
-			wlc_phy_rfctrl_override_nphy_rev7(
-				pi, (0x1 << 13),
-				lpfgain, core_mask,
-				off,
-				NPHY_REV7_RFCTRLOVERRIDE_ID0);
+		default:
 			break;
 		}
 	}
+
+	wlc_phy_init_radio_regs_allbands(pi, regs_2057_ptr);
 }
 
-static void
-wlc_phy_scale_offset_rssi_nphy(struct brcms_phy *pi, u16 scale, s8 offset,
-			       u8 coresel, u8 rail, u8 rssi_type)
+static u16 wlc_phy_radio205x_rcal(struct brcms_phy *pi)
 {
-	u16 valuetostuff;
+	u16 rcal_reg = 0;
+	int i;
 
-	offset = (offset > NPHY_RSSICAL_MAXREAD) ?
-		 NPHY_RSSICAL_MAXREAD : offset;
-	offset = (offset < (-NPHY_RSSICAL_MAXREAD - 1)) ?
-		 -NPHY_RSSICAL_MAXREAD - 1 : offset;
+	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 
-	valuetostuff = ((scale & 0x3f) << 8) | (offset & 0x3f);
+		if (pi->pubpi.radiorev == 5) {
 
-	if (((coresel == RADIO_MIMO_CORESEL_CORE1) ||
-	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_NB))
-		write_phy_reg(pi, 0x1a6, valuetostuff);
+			and_phy_reg(pi, 0x342, ~(0x1 << 1));
 
-	if (((coresel == RADIO_MIMO_CORESEL_CORE1) ||
-	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_NB))
-		write_phy_reg(pi, 0x1ac, valuetostuff);
+			udelay(10);
 
-	if (((coresel == RADIO_MIMO_CORESEL_CORE2) ||
-	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_NB))
-		write_phy_reg(pi, 0x1b2, valuetostuff);
+			mod_radio_reg(pi, RADIO_2057_IQTEST_SEL_PU, 0x1, 0x1);
+			mod_radio_reg(pi, RADIO_2057v7_IQTEST_SEL_PU2, 0x2,
+				      0x1);
+		}
+		mod_radio_reg(pi, RADIO_2057_RCAL_CONFIG, 0x1, 0x1);
 
-	if (((coresel == RADIO_MIMO_CORESEL_CORE2) ||
-	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_NB))
-		write_phy_reg(pi, 0x1b8, valuetostuff);
+		udelay(10);
 
-	if (((coresel == RADIO_MIMO_CORESEL_CORE1) ||
-	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_W1))
-		write_phy_reg(pi, 0x1a4, valuetostuff);
+		mod_radio_reg(pi, RADIO_2057_RCAL_CONFIG, 0x3, 0x3);
 
-	if (((coresel == RADIO_MIMO_CORESEL_CORE1) ||
-	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_W1))
-		write_phy_reg(pi, 0x1aa, valuetostuff);
+		for (i = 0; i < MAX_205x_RCAL_WAITLOOPS; i++) {
+			rcal_reg = read_radio_reg(pi, RADIO_2057_RCAL_STATUS);
+			if (rcal_reg & 0x1)
+				break;
 
-	if (((coresel == RADIO_MIMO_CORESEL_CORE2) ||
-	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_W1))
-		write_phy_reg(pi, 0x1b0, valuetostuff);
+			udelay(100);
+		}
 
-	if (((coresel == RADIO_MIMO_CORESEL_CORE2) ||
-	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_W1))
-		write_phy_reg(pi, 0x1b6, valuetostuff);
+		if (WARN(i == MAX_205x_RCAL_WAITLOOPS,
+			 "HW error: radio calib2"))
+			return 0;
 
-	if (((coresel == RADIO_MIMO_CORESEL_CORE1) ||
-	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_W2))
-		write_phy_reg(pi, 0x1a5, valuetostuff);
-	if (((coresel == RADIO_MIMO_CORESEL_CORE1) ||
-	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_W2))
-		write_phy_reg(pi, 0x1ab, valuetostuff);
+		mod_radio_reg(pi, RADIO_2057_RCAL_CONFIG, 0x2, 0x0);
 
-	if (((coresel == RADIO_MIMO_CORESEL_CORE2) ||
-	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_W2))
-		write_phy_reg(pi, 0x1b1, valuetostuff);
+		rcal_reg = read_radio_reg(pi, RADIO_2057_RCAL_STATUS) & 0x3e;
 
-	if (((coresel == RADIO_MIMO_CORESEL_CORE2) ||
-	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_W2))
-		write_phy_reg(pi, 0x1b7, valuetostuff);
+		mod_radio_reg(pi, RADIO_2057_RCAL_CONFIG, 0x1, 0x0);
+		if (pi->pubpi.radiorev == 5) {
 
-	if (((coresel == RADIO_MIMO_CORESEL_CORE1) ||
-	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_TBD))
-		write_phy_reg(pi, 0x1a7, valuetostuff);
-	if (((coresel == RADIO_MIMO_CORESEL_CORE1) ||
-	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_TBD))
-		write_phy_reg(pi, 0x1ad, valuetostuff);
-	if (((coresel == RADIO_MIMO_CORESEL_CORE2) ||
-	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_TBD))
-		write_phy_reg(pi, 0x1b3, valuetostuff);
-	if (((coresel == RADIO_MIMO_CORESEL_CORE2) ||
-	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_TBD))
-		write_phy_reg(pi, 0x1b9, valuetostuff);
+			mod_radio_reg(pi, RADIO_2057_IQTEST_SEL_PU, 0x1, 0x0);
+			mod_radio_reg(pi, RADIO_2057v7_IQTEST_SEL_PU2, 0x2,
+				      0x0);
+		}
 
-	if (((coresel == RADIO_MIMO_CORESEL_CORE1) ||
-	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_IQ))
-		write_phy_reg(pi, 0x1a8, valuetostuff);
+		if ((pi->pubpi.radiorev <= 4) || (pi->pubpi.radiorev == 6)) {
 
-	if (((coresel == RADIO_MIMO_CORESEL_CORE1) ||
-	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_IQ))
-		write_phy_reg(pi, 0x1ae, valuetostuff);
+			mod_radio_reg(pi, RADIO_2057_TEMPSENSE_CONFIG, 0x3c,
+				      rcal_reg);
+			mod_radio_reg(pi, RADIO_2057_BANDGAP_RCAL_TRIM, 0xf0,
+				      rcal_reg << 2);
+		}
 
-	if (((coresel == RADIO_MIMO_CORESEL_CORE2) ||
-	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_IQ))
-		write_phy_reg(pi, 0x1b4, valuetostuff);
+	} else if (NREV_IS(pi->pubpi.phy_rev, 3)) {
+		u16 savereg;
 
-	if (((coresel == RADIO_MIMO_CORESEL_CORE2) ||
-	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_IQ))
-		write_phy_reg(pi, 0x1ba, valuetostuff);
+		savereg =
+			read_radio_reg(
+				pi,
+				RADIO_2056_SYN_PLL_MAST2 |
+				RADIO_2056_SYN);
+		write_radio_reg(pi, RADIO_2056_SYN_PLL_MAST2 | RADIO_2056_SYN,
+				savereg | 0x7);
+		udelay(10);
+
+		write_radio_reg(pi, RADIO_2056_SYN_RCAL_MASTER | RADIO_2056_SYN,
+				0x1);
+		udelay(10);
+
+		write_radio_reg(pi, RADIO_2056_SYN_RCAL_MASTER | RADIO_2056_SYN,
+				0x9);
+
+		for (i = 0; i < MAX_205x_RCAL_WAITLOOPS; i++) {
+			rcal_reg = read_radio_reg(
+				pi,
+				RADIO_2056_SYN_RCAL_CODE_OUT |
+				RADIO_2056_SYN);
+			if (rcal_reg & 0x80)
+				break;
+
+			udelay(100);
+		}
+
+		if (WARN(i == MAX_205x_RCAL_WAITLOOPS,
+			 "HW error: radio calib3"))
+			return 0;
+
+		write_radio_reg(pi, RADIO_2056_SYN_RCAL_MASTER | RADIO_2056_SYN,
+				0x1);
+
+		rcal_reg =
+			read_radio_reg(pi,
+				       RADIO_2056_SYN_RCAL_CODE_OUT |
+				       RADIO_2056_SYN);
+
+		write_radio_reg(pi, RADIO_2056_SYN_RCAL_MASTER | RADIO_2056_SYN,
+				0x0);
+
+		write_radio_reg(pi, RADIO_2056_SYN_PLL_MAST2 | RADIO_2056_SYN,
+				savereg);
+
+		return rcal_reg & 0x1f;
+	}
+	return rcal_reg & 0x3e;
+}
+
+static u16 wlc_phy_radio2057_rccal(struct brcms_phy *pi)
+{
+	u16 rccal_valid;
+	int i;
+	bool chip43226_6362A0;
+
+	chip43226_6362A0 = ((pi->pubpi.radiorev == 3)
+			    || (pi->pubpi.radiorev == 4)
+			    || (pi->pubpi.radiorev == 6));
+
+	rccal_valid = 0;
+	if (chip43226_6362A0) {
+		write_radio_reg(pi, RADIO_2057_RCCAL_MASTER, 0x61);
+		write_radio_reg(pi, RADIO_2057_RCCAL_TRC0, 0xc0);
+	} else {
+		write_radio_reg(pi, RADIO_2057v7_RCCAL_MASTER, 0x61);
+
+		write_radio_reg(pi, RADIO_2057_RCCAL_TRC0, 0xe9);
+	}
+	write_radio_reg(pi, RADIO_2057_RCCAL_X1, 0x6e);
+	write_radio_reg(pi, RADIO_2057_RCCAL_START_R1_Q1_P1, 0x55);
+
+	for (i = 0; i < MAX_205x_RCAL_WAITLOOPS; i++) {
+		rccal_valid = read_radio_reg(pi, RADIO_2057_RCCAL_DONE_OSCCAP);
+		if (rccal_valid & 0x2)
+			break;
+
+		udelay(500);
+	}
+
+	write_radio_reg(pi, RADIO_2057_RCCAL_START_R1_Q1_P1, 0x15);
+
+	rccal_valid = 0;
+	if (chip43226_6362A0) {
+		write_radio_reg(pi, RADIO_2057_RCCAL_MASTER, 0x69);
+		write_radio_reg(pi, RADIO_2057_RCCAL_TRC0, 0xb0);
+	} else {
+		write_radio_reg(pi, RADIO_2057v7_RCCAL_MASTER, 0x69);
+
+		write_radio_reg(pi, RADIO_2057_RCCAL_TRC0, 0xd5);
+	}
+	write_radio_reg(pi, RADIO_2057_RCCAL_X1, 0x6e);
+	write_radio_reg(pi, RADIO_2057_RCCAL_START_R1_Q1_P1, 0x55);
 
-	if (((coresel == RADIO_MIMO_CORESEL_CORE1) ||
-	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rssi_type == NPHY_RSSI_SEL_TSSI_2G))
-		write_phy_reg(pi, 0x1a9, valuetostuff);
-	if (((coresel == RADIO_MIMO_CORESEL_CORE2) ||
-	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rssi_type == NPHY_RSSI_SEL_TSSI_2G))
-		write_phy_reg(pi, 0x1b5, valuetostuff);
+	for (i = 0; i < MAX_205x_RCAL_WAITLOOPS; i++) {
+		rccal_valid = read_radio_reg(pi, RADIO_2057_RCCAL_DONE_OSCCAP);
+		if (rccal_valid & 0x2)
+			break;
 
-	if (((coresel == RADIO_MIMO_CORESEL_CORE1) ||
-	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rssi_type == NPHY_RSSI_SEL_TSSI_5G))
-		write_phy_reg(pi, 0x1af, valuetostuff);
+		udelay(500);
+	}
 
-	if (((coresel == RADIO_MIMO_CORESEL_CORE2) ||
-	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rssi_type == NPHY_RSSI_SEL_TSSI_5G))
-		write_phy_reg(pi, 0x1bb, valuetostuff);
-}
+	write_radio_reg(pi, RADIO_2057_RCCAL_START_R1_Q1_P1, 0x15);
 
-static void brcms_phy_wr_tx_mux(struct brcms_phy *pi, u8 core)
-{
-	if (PHY_IPA(pi)) {
-		if (NREV_GE(pi->pubpi.phy_rev, 7))
-			write_radio_reg(pi,
-					((core == PHY_CORE_0) ?
-					 RADIO_2057_TX0_TX_SSI_MUX :
-					 RADIO_2057_TX1_TX_SSI_MUX),
-					(CHSPEC_IS5G(pi->radio_chanspec) ?
-					0xc : 0xe));
-		else
-			write_radio_reg(pi,
-					RADIO_2056_TX_TX_SSI_MUX |
-					((core == PHY_CORE_0) ?
-					 RADIO_2056_TX0 : RADIO_2056_TX1),
-					(CHSPEC_IS5G(pi->radio_chanspec) ?
-					0xc : 0xe));
+	rccal_valid = 0;
+	if (chip43226_6362A0) {
+		write_radio_reg(pi, RADIO_2057_RCCAL_MASTER, 0x73);
+
+		write_radio_reg(pi, RADIO_2057_RCCAL_X1, 0x28);
+		write_radio_reg(pi, RADIO_2057_RCCAL_TRC0, 0xb0);
 	} else {
-		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-			write_radio_reg(pi,
-					((core == PHY_CORE_0) ?
-					 RADIO_2057_TX0_TX_SSI_MUX :
-					 RADIO_2057_TX1_TX_SSI_MUX),
-					0x11);
+		write_radio_reg(pi, RADIO_2057v7_RCCAL_MASTER, 0x73);
+		write_radio_reg(pi, RADIO_2057_RCCAL_X1, 0x6e);
+		write_radio_reg(pi, RADIO_2057_RCCAL_TRC0, 0x99);
+	}
+	write_radio_reg(pi, RADIO_2057_RCCAL_START_R1_Q1_P1, 0x55);
 
-			if (pi->pubpi.radioid == BCM2057_ID)
-				write_radio_reg(pi,
-						RADIO_2057_IQTEST_SEL_PU, 0x1);
+	for (i = 0; i < MAX_205x_RCAL_WAITLOOPS; i++) {
+		rccal_valid = read_radio_reg(pi, RADIO_2057_RCCAL_DONE_OSCCAP);
+		if (rccal_valid & 0x2)
+			break;
 
-		} else {
-			write_radio_reg(pi,
-					RADIO_2056_TX_TX_SSI_MUX |
-					((core == PHY_CORE_0) ?
-					 RADIO_2056_TX0 : RADIO_2056_TX1),
-					0x11);
-		}
+		udelay(500);
 	}
+
+	if (WARN(!(rccal_valid & 0x2), "HW error: radio calib4"))
+		return 0;
+
+	write_radio_reg(pi, RADIO_2057_RCCAL_START_R1_Q1_P1, 0x15);
+
+	return rccal_valid;
 }
 
-void wlc_phy_rssisel_nphy(struct brcms_phy *pi, u8 core_code, u8 rssi_type)
+static void wlc_phy_radio_postinit_2057(struct brcms_phy *pi)
 {
-	u16 mask, val;
-	u16 afectrlovr_rssi_val, rfctrlcmd_rxen_val, rfctrlcmd_coresel_val,
-	    startseq;
-	u16 rfctrlovr_rssi_val, rfctrlovr_rxen_val, rfctrlovr_coresel_val,
-	    rfctrlovr_trigger_val;
-	u16 afectrlovr_rssi_mask, rfctrlcmd_mask, rfctrlovr_mask;
-	u16 rfctrlcmd_val, rfctrlovr_val;
-	u8 core;
 
-	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-		if (core_code == RADIO_MIMO_CORESEL_OFF) {
-			mod_phy_reg(pi, 0x8f, (0x1 << 9), 0);
-			mod_phy_reg(pi, 0xa5, (0x1 << 9), 0);
+	mod_radio_reg(pi, RADIO_2057_XTALPUOVR_PINCTRL, 0x1, 0x1);
 
-			mod_phy_reg(pi, 0xa6, (0x3 << 8), 0);
-			mod_phy_reg(pi, 0xa7, (0x3 << 8), 0);
+	mod_radio_reg(pi, RADIO_2057_RFPLL_MISC_CAL_RESETN, 0x78, 0x78);
+	mod_radio_reg(pi, RADIO_2057_XTAL_CONFIG2, 0x80, 0x80);
+	mdelay(2);
+	mod_radio_reg(pi, RADIO_2057_RFPLL_MISC_CAL_RESETN, 0x78, 0x0);
+	mod_radio_reg(pi, RADIO_2057_XTAL_CONFIG2, 0x80, 0x0);
 
-			mod_phy_reg(pi, 0xe5, (0x1 << 5), 0);
-			mod_phy_reg(pi, 0xe6, (0x1 << 5), 0);
+	if (pi->phy_init_por) {
+		wlc_phy_radio205x_rcal(pi);
+		wlc_phy_radio2057_rccal(pi);
+	}
 
-			mask = (0x1 << 2) |
-			       (0x1 << 3) | (0x1 << 4) | (0x1 << 5);
-			mod_phy_reg(pi, 0xf9, mask, 0);
-			mod_phy_reg(pi, 0xfb, mask, 0);
+	mod_radio_reg(pi, RADIO_2057_RFPLL_MASTER, 0x8, 0x0);
+}
 
-		} else {
-			for (core = 0; core < pi->pubpi.phy_corenum; core++) {
-				if (core_code == RADIO_MIMO_CORESEL_CORE1
-				    && core == PHY_CORE_1)
-					continue;
-				else if (core_code == RADIO_MIMO_CORESEL_CORE2
-					 && core == PHY_CORE_0)
-					continue;
+static void wlc_phy_radio_init_2056(struct brcms_phy *pi)
+{
+	struct radio_regs *regs_SYN_2056_ptr = NULL;
+	struct radio_regs *regs_TX_2056_ptr = NULL;
+	struct radio_regs *regs_RX_2056_ptr = NULL;
 
-				mod_phy_reg(pi, (core == PHY_CORE_0) ?
-					    0x8f : 0xa5, (0x1 << 9), 1 << 9);
+	if (NREV_IS(pi->pubpi.phy_rev, 3)) {
+		regs_SYN_2056_ptr = regs_SYN_2056;
+		regs_TX_2056_ptr = regs_TX_2056;
+		regs_RX_2056_ptr = regs_RX_2056;
+	} else if (NREV_IS(pi->pubpi.phy_rev, 4)) {
+		regs_SYN_2056_ptr = regs_SYN_2056_A1;
+		regs_TX_2056_ptr = regs_TX_2056_A1;
+		regs_RX_2056_ptr = regs_RX_2056_A1;
+	} else {
+		switch (pi->pubpi.radiorev) {
+		case 5:
+			regs_SYN_2056_ptr = regs_SYN_2056_rev5;
+			regs_TX_2056_ptr = regs_TX_2056_rev5;
+			regs_RX_2056_ptr = regs_RX_2056_rev5;
+			break;
 
-				if (rssi_type == NPHY_RSSI_SEL_W1 ||
-				    rssi_type == NPHY_RSSI_SEL_W2 ||
-				    rssi_type == NPHY_RSSI_SEL_NB) {
-					mod_phy_reg(pi,
-						    (core ==
-						     PHY_CORE_0) ? 0xa6 : 0xa7,
-						    (0x3 << 8), 0);
+		case 6:
+			regs_SYN_2056_ptr = regs_SYN_2056_rev6;
+			regs_TX_2056_ptr = regs_TX_2056_rev6;
+			regs_RX_2056_ptr = regs_RX_2056_rev6;
+			break;
 
-					mask = (0x1 << 2) |
-					       (0x1 << 3) |
-					       (0x1 << 4) | (0x1 << 5);
-					mod_phy_reg(pi,
-						    (core ==
-						     PHY_CORE_0) ? 0xf9 : 0xfb,
-						    mask, 0);
+		case 7:
+		case 9:
+			regs_SYN_2056_ptr = regs_SYN_2056_rev7;
+			regs_TX_2056_ptr = regs_TX_2056_rev7;
+			regs_RX_2056_ptr = regs_RX_2056_rev7;
+			break;
 
-					if (rssi_type == NPHY_RSSI_SEL_W1) {
-						if (CHSPEC_IS5G(
-							  pi->radio_chanspec)) {
-							mask = (0x1 << 2);
-							val = 1 << 2;
-						} else {
-							mask = (0x1 << 3);
-							val = 1 << 3;
-						}
-					} else if (rssi_type ==
-						   NPHY_RSSI_SEL_W2) {
-						mask = (0x1 << 4);
-						val = 1 << 4;
-					} else {
-						mask = (0x1 << 5);
-						val = 1 << 5;
-					}
-					mod_phy_reg(pi,
-						    (core ==
-						     PHY_CORE_0) ? 0xf9 : 0xfb,
-						    mask, val);
+		case 8:
+			regs_SYN_2056_ptr = regs_SYN_2056_rev8;
+			regs_TX_2056_ptr = regs_TX_2056_rev8;
+			regs_RX_2056_ptr = regs_RX_2056_rev8;
+			break;
 
-					mask = (0x1 << 5);
-					val = 1 << 5;
-					mod_phy_reg(pi, (core == PHY_CORE_0) ?
-						    0xe5 : 0xe6, mask, val);
-				} else {
-					if (rssi_type == NPHY_RSSI_SEL_TBD) {
-						mask = (0x3 << 8);
-						val = 1 << 8;
-						mod_phy_reg(pi,
-							    (core ==
-							     PHY_CORE_0) ? 0xa6
-							    : 0xa7, mask, val);
-						mask = (0x3 << 10);
-						val = 1 << 10;
-						mod_phy_reg(pi,
-							    (core ==
-							     PHY_CORE_0) ? 0xa6
-							    : 0xa7, mask, val);
-					} else if (rssi_type ==
-						   NPHY_RSSI_SEL_IQ) {
-						mask = (0x3 << 8);
-						val = 2 << 8;
-						mod_phy_reg(pi,
-							    (core ==
-							     PHY_CORE_0) ? 0xa6
-							    : 0xa7, mask, val);
-						mask = (0x3 << 10);
-						val = 2 << 10;
-						mod_phy_reg(pi,
-							    (core ==
-							     PHY_CORE_0) ? 0xa6
-							    : 0xa7, mask, val);
-					} else {
-						mask = (0x3 << 8);
-						val = 3 << 8;
-						mod_phy_reg(pi,
-							    (core ==
-							     PHY_CORE_0) ? 0xa6
-							    : 0xa7, mask, val);
-						mask = (0x3 << 10);
-						val = 3 << 10;
-						mod_phy_reg(pi,
-							    (core ==
-							     PHY_CORE_0) ? 0xa6
-							    : 0xa7, mask, val);
-						brcms_phy_wr_tx_mux(pi, core);
-						afectrlovr_rssi_val = 1 << 9;
-						mod_phy_reg(pi,
-							   (core ==
-							    PHY_CORE_0) ? 0x8f
-							   : 0xa5, (0x1 << 9),
-							   afectrlovr_rssi_val);
-					}
-				}
-			}
+		case 11:
+			regs_SYN_2056_ptr = regs_SYN_2056_rev11;
+			regs_TX_2056_ptr = regs_TX_2056_rev11;
+			regs_RX_2056_ptr = regs_RX_2056_rev11;
+			break;
+
+		default:
+			break;
 		}
-	} else {
+	}
 
-		if ((rssi_type == NPHY_RSSI_SEL_W1) ||
-		    (rssi_type == NPHY_RSSI_SEL_W2) ||
-		    (rssi_type == NPHY_RSSI_SEL_NB))
-			val = 0x0;
-		else if (rssi_type == NPHY_RSSI_SEL_TBD)
-			val = 0x1;
-		else if (rssi_type == NPHY_RSSI_SEL_IQ)
-			val = 0x2;
-		else
-			val = 0x3;
+	wlc_phy_init_radio_regs(pi, regs_SYN_2056_ptr, (u16) RADIO_2056_SYN);
 
-		mask = ((0x3 << 12) | (0x3 << 14));
-		val = (val << 12) | (val << 14);
-		mod_phy_reg(pi, 0xa6, mask, val);
-		mod_phy_reg(pi, 0xa7, mask, val);
+	wlc_phy_init_radio_regs(pi, regs_TX_2056_ptr, (u16) RADIO_2056_TX0);
 
-		if ((rssi_type == NPHY_RSSI_SEL_W1) ||
-		    (rssi_type == NPHY_RSSI_SEL_W2) ||
-		    (rssi_type == NPHY_RSSI_SEL_NB)) {
-			if (rssi_type == NPHY_RSSI_SEL_W1)
-				val = 0x1;
-			if (rssi_type == NPHY_RSSI_SEL_W2)
-				val = 0x2;
-			if (rssi_type == NPHY_RSSI_SEL_NB)
-				val = 0x3;
+	wlc_phy_init_radio_regs(pi, regs_TX_2056_ptr, (u16) RADIO_2056_TX1);
 
-			mask = (0x3 << 4);
-			val = (val << 4);
-			mod_phy_reg(pi, 0x7a, mask, val);
-			mod_phy_reg(pi, 0x7d, mask, val);
-		}
+	wlc_phy_init_radio_regs(pi, regs_RX_2056_ptr, (u16) RADIO_2056_RX0);
 
-		if (core_code == RADIO_MIMO_CORESEL_OFF) {
-			afectrlovr_rssi_val = 0;
-			rfctrlcmd_rxen_val = 0;
-			rfctrlcmd_coresel_val = 0;
-			rfctrlovr_rssi_val = 0;
-			rfctrlovr_rxen_val = 0;
-			rfctrlovr_coresel_val = 0;
-			rfctrlovr_trigger_val = 0;
-			startseq = 0;
-		} else {
-			afectrlovr_rssi_val = 1;
-			rfctrlcmd_rxen_val = 1;
-			rfctrlcmd_coresel_val = core_code;
-			rfctrlovr_rssi_val = 1;
-			rfctrlovr_rxen_val = 1;
-			rfctrlovr_coresel_val = 1;
-			rfctrlovr_trigger_val = 1;
-			startseq = 1;
-		}
+	wlc_phy_init_radio_regs(pi, regs_RX_2056_ptr, (u16) RADIO_2056_RX1);
+}
 
-		afectrlovr_rssi_mask = ((0x1 << 12) | (0x1 << 13));
-		afectrlovr_rssi_val = (afectrlovr_rssi_val <<
-				       12) | (afectrlovr_rssi_val << 13);
-		mod_phy_reg(pi, 0xa5, afectrlovr_rssi_mask,
-			    afectrlovr_rssi_val);
+static void wlc_phy_radio_postinit_2056(struct brcms_phy *pi)
+{
+	mod_radio_reg(pi, RADIO_2056_SYN_COM_CTRL, 0xb, 0xb);
 
-		if ((rssi_type == NPHY_RSSI_SEL_W1) ||
-		    (rssi_type == NPHY_RSSI_SEL_W2) ||
-		    (rssi_type == NPHY_RSSI_SEL_NB)) {
-			rfctrlcmd_mask = ((0x1 << 8) | (0x7 << 3));
-			rfctrlcmd_val = (rfctrlcmd_rxen_val << 8) |
-					(rfctrlcmd_coresel_val << 3);
+	mod_radio_reg(pi, RADIO_2056_SYN_COM_PU, 0x2, 0x2);
+	mod_radio_reg(pi, RADIO_2056_SYN_COM_RESET, 0x2, 0x2);
+	udelay(1000);
+	mod_radio_reg(pi, RADIO_2056_SYN_COM_RESET, 0x2, 0x0);
 
-			rfctrlovr_mask = ((0x1 << 5) |
-					  (0x1 << 12) |
-					  (0x1 << 1) | (0x1 << 0));
-			rfctrlovr_val = (rfctrlovr_rssi_val <<
-					 5) |
-					(rfctrlovr_rxen_val << 12) |
-					(rfctrlovr_coresel_val << 1) |
-					(rfctrlovr_trigger_val << 0);
+	if ((pi->sh->boardflags2 & BFL2_LEGACY)
+	    || (pi->sh->boardflags2 & BFL2_XTALBUFOUTEN))
+		mod_radio_reg(pi, RADIO_2056_SYN_PLL_MAST2, 0xf4, 0x0);
+	else
+		mod_radio_reg(pi, RADIO_2056_SYN_PLL_MAST2, 0xfc, 0x0);
 
-			mod_phy_reg(pi, 0x78, rfctrlcmd_mask, rfctrlcmd_val);
-			mod_phy_reg(pi, 0xec, rfctrlovr_mask, rfctrlovr_val);
+	mod_radio_reg(pi, RADIO_2056_SYN_RCCAL_CTRL0, 0x1, 0x0);
 
-			mod_phy_reg(pi, 0x78, (0x1 << 0), (startseq << 0));
-			udelay(20);
+	if (pi->phy_init_por)
+		wlc_phy_radio205x_rcal(pi);
+}
 
-			mod_phy_reg(pi, 0xec, (0x1 << 0), 0);
-		}
-	}
+static void wlc_phy_radio_preinit_2055(struct brcms_phy *pi)
+{
+
+	and_phy_reg(pi, 0x78, ~RFCC_POR_FORCE);
+	or_phy_reg(pi, 0x78, RFCC_CHIP0_PU | RFCC_OE_POR_FORCE);
+
+	or_phy_reg(pi, 0x78, RFCC_POR_FORCE);
 }
 
-int
-wlc_phy_poll_rssi_nphy(struct brcms_phy *pi, u8 rssi_type, s32 *rssi_buf,
-		       u8 nsamps)
+static void wlc_phy_radio_init_2055(struct brcms_phy *pi)
 {
-	s16 rssi0, rssi1;
-	u16 afectrlCore1_save = 0;
-	u16 afectrlCore2_save = 0;
-	u16 afectrlOverride1_save = 0;
-	u16 afectrlOverride2_save = 0;
-	u16 rfctrlOverrideAux0_save = 0;
-	u16 rfctrlOverrideAux1_save = 0;
-	u16 rfctrlMiscReg1_save = 0;
-	u16 rfctrlMiscReg2_save = 0;
-	u16 rfctrlcmd_save = 0;
-	u16 rfctrloverride_save = 0;
-	u16 rfctrlrssiothers1_save = 0;
-	u16 rfctrlrssiothers2_save = 0;
-	s8 tmp_buf[4];
-	u8 ctr = 0, samp = 0;
-	s32 rssi_out_val;
-	u16 gpiosel_orig;
+	wlc_phy_init_radio_regs(pi, regs_2055, RADIO_DEFAULT_CORE);
+}
 
-	afectrlCore1_save = read_phy_reg(pi, 0xa6);
-	afectrlCore2_save = read_phy_reg(pi, 0xa7);
-	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-		rfctrlMiscReg1_save = read_phy_reg(pi, 0xf9);
-		rfctrlMiscReg2_save = read_phy_reg(pi, 0xfb);
-		afectrlOverride1_save = read_phy_reg(pi, 0x8f);
-		afectrlOverride2_save = read_phy_reg(pi, 0xa5);
-		rfctrlOverrideAux0_save = read_phy_reg(pi, 0xe5);
-		rfctrlOverrideAux1_save = read_phy_reg(pi, 0xe6);
-	} else {
-		afectrlOverride1_save = read_phy_reg(pi, 0xa5);
-		rfctrlcmd_save = read_phy_reg(pi, 0x78);
-		rfctrloverride_save = read_phy_reg(pi, 0xec);
-		rfctrlrssiothers1_save = read_phy_reg(pi, 0x7a);
-		rfctrlrssiothers2_save = read_phy_reg(pi, 0x7d);
+static void wlc_phy_radio_postinit_2055(struct brcms_phy *pi)
+{
+
+	and_radio_reg(pi, RADIO_2055_MASTER_CNTRL1,
+		      ~(RADIO_2055_JTAGCTRL_MASK | RADIO_2055_JTAGSYNC_MASK));
+
+	if (((pi->sh->sromrev >= 4)
+	     && !(pi->sh->boardflags2 & BFL2_RXBB_INT_REG_DIS))
+	    || ((pi->sh->sromrev < 4))) {
+		and_radio_reg(pi, RADIO_2055_CORE1_RXBB_REGULATOR, 0x7F);
+		and_radio_reg(pi, RADIO_2055_CORE2_RXBB_REGULATOR, 0x7F);
 	}
 
-	wlc_phy_rssisel_nphy(pi, RADIO_MIMO_CORESEL_ALLRX, rssi_type);
+	mod_radio_reg(pi, RADIO_2055_RRCCAL_N_OPT_SEL, 0x3F, 0x2C);
+	write_radio_reg(pi, RADIO_2055_CAL_MISC, 0x3C);
 
-	gpiosel_orig = read_phy_reg(pi, 0xca);
-	if (NREV_LT(pi->pubpi.phy_rev, 2))
-		write_phy_reg(pi, 0xca, 5);
+	and_radio_reg(pi, RADIO_2055_CAL_MISC,
+		      ~(RADIO_2055_RRCAL_START | RADIO_2055_RRCAL_RST_N));
 
-	for (ctr = 0; ctr < 4; ctr++)
-		rssi_buf[ctr] = 0;
+	or_radio_reg(pi, RADIO_2055_CAL_LPO_CNTRL, RADIO_2055_CAL_LPO_ENABLE);
 
-	for (samp = 0; samp < nsamps; samp++) {
-		if (NREV_LT(pi->pubpi.phy_rev, 2)) {
-			rssi0 = read_phy_reg(pi, 0x1c9);
-			rssi1 = read_phy_reg(pi, 0x1ca);
-		} else {
-			rssi0 = read_phy_reg(pi, 0x219);
-			rssi1 = read_phy_reg(pi, 0x21a);
-		}
+	or_radio_reg(pi, RADIO_2055_CAL_MISC, RADIO_2055_RRCAL_RST_N);
 
-		ctr = 0;
-		tmp_buf[ctr++] = ((s8) ((rssi0 & 0x3f) << 2)) >> 2;
-		tmp_buf[ctr++] = ((s8) (((rssi0 >> 8) & 0x3f) << 2)) >> 2;
-		tmp_buf[ctr++] = ((s8) ((rssi1 & 0x3f) << 2)) >> 2;
-		tmp_buf[ctr++] = ((s8) (((rssi1 >> 8) & 0x3f) << 2)) >> 2;
+	udelay(1000);
 
-		for (ctr = 0; ctr < 4; ctr++)
-			rssi_buf[ctr] += tmp_buf[ctr];
+	or_radio_reg(pi, RADIO_2055_CAL_MISC, RADIO_2055_RRCAL_START);
 
-	}
+	SPINWAIT(((read_radio_reg(pi, RADIO_2055_CAL_COUNTER_OUT2) &
+		   RADIO_2055_RCAL_DONE) != RADIO_2055_RCAL_DONE), 2000);
 
-	rssi_out_val = rssi_buf[3] & 0xff;
-	rssi_out_val |= (rssi_buf[2] & 0xff) << 8;
-	rssi_out_val |= (rssi_buf[1] & 0xff) << 16;
-	rssi_out_val |= (rssi_buf[0] & 0xff) << 24;
+	if (WARN((read_radio_reg(pi, RADIO_2055_CAL_COUNTER_OUT2) &
+		  RADIO_2055_RCAL_DONE) != RADIO_2055_RCAL_DONE,
+		 "HW error: radio calibration1\n"))
+		return;
 
-	if (NREV_LT(pi->pubpi.phy_rev, 2))
-		write_phy_reg(pi, 0xca, gpiosel_orig);
+	and_radio_reg(pi, RADIO_2055_CAL_LPO_CNTRL,
+		      ~(RADIO_2055_CAL_LPO_ENABLE));
 
-	write_phy_reg(pi, 0xa6, afectrlCore1_save);
-	write_phy_reg(pi, 0xa7, afectrlCore2_save);
-	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-		write_phy_reg(pi, 0xf9, rfctrlMiscReg1_save);
-		write_phy_reg(pi, 0xfb, rfctrlMiscReg2_save);
-		write_phy_reg(pi, 0x8f, afectrlOverride1_save);
-		write_phy_reg(pi, 0xa5, afectrlOverride2_save);
-		write_phy_reg(pi, 0xe5, rfctrlOverrideAux0_save);
-		write_phy_reg(pi, 0xe6, rfctrlOverrideAux1_save);
-	} else {
-		write_phy_reg(pi, 0xa5, afectrlOverride1_save);
-		write_phy_reg(pi, 0x78, rfctrlcmd_save);
-		write_phy_reg(pi, 0xec, rfctrloverride_save);
-		write_phy_reg(pi, 0x7a, rfctrlrssiothers1_save);
-		write_phy_reg(pi, 0x7d, rfctrlrssiothers2_save);
-	}
+	wlc_phy_chanspec_set((struct brcms_phy_pub *) pi, pi->radio_chanspec);
 
-	return rssi_out_val;
-}
+	write_radio_reg(pi, RADIO_2055_CORE1_RXBB_LPF, 9);
+	write_radio_reg(pi, RADIO_2055_CORE2_RXBB_LPF, 9);
 
-s16 wlc_phy_tempsense_nphy(struct brcms_phy *pi)
-{
-	u16 core1_txrf_iqcal1_save, core1_txrf_iqcal2_save;
-	u16 core2_txrf_iqcal1_save, core2_txrf_iqcal2_save;
-	u16 pwrdet_rxtx_core1_save;
-	u16 pwrdet_rxtx_core2_save;
-	u16 afectrlCore1_save;
-	u16 afectrlCore2_save;
-	u16 afectrlOverride_save;
-	u16 afectrlOverride2_save;
-	u16 pd_pll_ts_save;
-	u16 gpioSel_save;
-	s32 radio_temp[4];
-	s32 radio_temp2[4];
-	u16 syn_tempprocsense_save;
-	s16 offset = 0;
+	write_radio_reg(pi, RADIO_2055_CORE1_RXBB_MIDAC_HIPAS, 0x83);
+	write_radio_reg(pi, RADIO_2055_CORE2_RXBB_MIDAC_HIPAS, 0x83);
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-		u16 auxADC_Vmid, auxADC_Av, auxADC_Vmid_save, auxADC_Av_save;
-		u16 auxADC_rssi_ctrlL_save, auxADC_rssi_ctrlH_save;
-		u16 auxADC_rssi_ctrlL, auxADC_rssi_ctrlH;
-		s32 auxADC_Vl;
-		u16 RfctrlOverride5_save, RfctrlOverride6_save;
-		u16 RfctrlMiscReg5_save, RfctrlMiscReg6_save;
-		u16 RSSIMultCoef0QPowerDet_save;
-		u16 tempsense_Rcal;
+	mod_radio_reg(pi, RADIO_2055_CORE1_LNA_GAINBST,
+		      RADIO_2055_GAINBST_VAL_MASK, RADIO_2055_GAINBST_CODE);
+	mod_radio_reg(pi, RADIO_2055_CORE2_LNA_GAINBST,
+		      RADIO_2055_GAINBST_VAL_MASK, RADIO_2055_GAINBST_CODE);
+	if (pi->nphy_gain_boost) {
+		and_radio_reg(pi, RADIO_2055_CORE1_RXRF_SPC1,
+			      ~(RADIO_2055_GAINBST_DISABLE));
+		and_radio_reg(pi, RADIO_2055_CORE2_RXRF_SPC1,
+			      ~(RADIO_2055_GAINBST_DISABLE));
+	} else {
+		or_radio_reg(pi, RADIO_2055_CORE1_RXRF_SPC1,
+			     RADIO_2055_GAINBST_DISABLE);
+		or_radio_reg(pi, RADIO_2055_CORE2_RXRF_SPC1,
+			     RADIO_2055_GAINBST_DISABLE);
+	}
 
-		syn_tempprocsense_save =
-			read_radio_reg(pi, RADIO_2057_TEMPSENSE_CONFIG);
+	udelay(2);
+}
 
-		afectrlCore1_save = read_phy_reg(pi, 0xa6);
-		afectrlCore2_save = read_phy_reg(pi, 0xa7);
-		afectrlOverride_save = read_phy_reg(pi, 0x8f);
-		afectrlOverride2_save = read_phy_reg(pi, 0xa5);
-		RSSIMultCoef0QPowerDet_save = read_phy_reg(pi, 0x1ae);
-		RfctrlOverride5_save = read_phy_reg(pi, 0x346);
-		RfctrlOverride6_save = read_phy_reg(pi, 0x347);
-		RfctrlMiscReg5_save = read_phy_reg(pi, 0x344);
-		RfctrlMiscReg6_save = read_phy_reg(pi, 0x345);
+void wlc_phy_switch_radio_nphy(struct brcms_phy *pi, bool on)
+{
+	if (on) {
+		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+			if (!pi->radio_is_on) {
+				wlc_phy_radio_preinit_205x(pi);
+				wlc_phy_radio_init_2057(pi);
+				wlc_phy_radio_postinit_2057(pi);
+			}
 
-		wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x0A, 16,
-					&auxADC_Vmid_save);
-		wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x0E, 16,
-					&auxADC_Av_save);
-		wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x02, 16,
-					&auxADC_rssi_ctrlL_save);
-		wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x03, 16,
-					&auxADC_rssi_ctrlH_save);
+			wlc_phy_chanspec_set((struct brcms_phy_pub *) pi,
+					     pi->radio_chanspec);
+		} else if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+			wlc_phy_radio_preinit_205x(pi);
+			wlc_phy_radio_init_2056(pi);
+			wlc_phy_radio_postinit_2056(pi);
 
-		write_phy_reg(pi, 0x1ae, 0x0);
+			wlc_phy_chanspec_set((struct brcms_phy_pub *) pi,
+					     pi->radio_chanspec);
+		} else {
+			wlc_phy_radio_preinit_2055(pi);
+			wlc_phy_radio_init_2055(pi);
+			wlc_phy_radio_postinit_2055(pi);
+		}
 
-		auxADC_rssi_ctrlL = 0x0;
-		auxADC_rssi_ctrlH = 0x20;
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x02, 16,
-					 &auxADC_rssi_ctrlL);
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x03, 16,
-					 &auxADC_rssi_ctrlH);
+		pi->radio_is_on = true;
 
-		tempsense_Rcal = syn_tempprocsense_save & 0x1c;
+	} else {
 
-		write_radio_reg(pi, RADIO_2057_TEMPSENSE_CONFIG,
-				tempsense_Rcal | 0x01);
+		if (NREV_GE(pi->pubpi.phy_rev, 3)
+		    && NREV_LT(pi->pubpi.phy_rev, 7)) {
+			and_phy_reg(pi, 0x78, ~RFCC_CHIP0_PU);
+			mod_radio_reg(pi, RADIO_2056_SYN_COM_PU, 0x2, 0x0);
 
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 1),
-						  1, 0, 0,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID2);
-		mod_phy_reg(pi, 0xa6, (0x1 << 7), 0);
-		mod_phy_reg(pi, 0xa7, (0x1 << 7), 0);
-		mod_phy_reg(pi, 0x8f, (0x1 << 7), (0x1 << 7));
-		mod_phy_reg(pi, 0xa5, (0x1 << 7), (0x1 << 7));
+			write_radio_reg(pi,
+					RADIO_2056_TX_PADA_BOOST_TUNE |
+					RADIO_2056_TX0, 0);
+			write_radio_reg(pi,
+					RADIO_2056_TX_PADG_BOOST_TUNE |
+					RADIO_2056_TX0, 0);
+			write_radio_reg(pi,
+					RADIO_2056_TX_PGAA_BOOST_TUNE |
+					RADIO_2056_TX0, 0);
+			write_radio_reg(pi,
+					RADIO_2056_TX_PGAG_BOOST_TUNE |
+					RADIO_2056_TX0, 0);
+			mod_radio_reg(pi,
+				      RADIO_2056_TX_MIXA_BOOST_TUNE |
+				      RADIO_2056_TX0, 0xf0, 0);
+			write_radio_reg(pi,
+					RADIO_2056_TX_MIXG_BOOST_TUNE |
+					RADIO_2056_TX0, 0);
 
-		mod_phy_reg(pi, 0xa6, (0x1 << 2), (0x1 << 2));
-		mod_phy_reg(pi, 0xa7, (0x1 << 2), (0x1 << 2));
-		mod_phy_reg(pi, 0x8f, (0x1 << 2), (0x1 << 2));
-		mod_phy_reg(pi, 0xa5, (0x1 << 2), (0x1 << 2));
-		udelay(5);
-		mod_phy_reg(pi, 0xa6, (0x1 << 2), 0);
-		mod_phy_reg(pi, 0xa7, (0x1 << 2), 0);
-		mod_phy_reg(pi, 0xa6, (0x1 << 3), 0);
-		mod_phy_reg(pi, 0xa7, (0x1 << 3), 0);
-		mod_phy_reg(pi, 0x8f, (0x1 << 3), (0x1 << 3));
-		mod_phy_reg(pi, 0xa5, (0x1 << 3), (0x1 << 3));
-		mod_phy_reg(pi, 0xa6, (0x1 << 6), 0);
-		mod_phy_reg(pi, 0xa7, (0x1 << 6), 0);
-		mod_phy_reg(pi, 0x8f, (0x1 << 6), (0x1 << 6));
-		mod_phy_reg(pi, 0xa5, (0x1 << 6), (0x1 << 6));
+			write_radio_reg(pi,
+					RADIO_2056_TX_PADA_BOOST_TUNE |
+					RADIO_2056_TX1, 0);
+			write_radio_reg(pi,
+					RADIO_2056_TX_PADG_BOOST_TUNE |
+					RADIO_2056_TX1, 0);
+			write_radio_reg(pi,
+					RADIO_2056_TX_PGAA_BOOST_TUNE |
+					RADIO_2056_TX1, 0);
+			write_radio_reg(pi,
+					RADIO_2056_TX_PGAG_BOOST_TUNE |
+					RADIO_2056_TX1, 0);
+			mod_radio_reg(pi,
+				      RADIO_2056_TX_MIXA_BOOST_TUNE |
+				      RADIO_2056_TX1, 0xf0, 0);
+			write_radio_reg(pi,
+					RADIO_2056_TX_MIXG_BOOST_TUNE |
+					RADIO_2056_TX1, 0);
 
-		auxADC_Vmid = 0xA3;
-		auxADC_Av = 0x0;
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x0A, 16,
-					 &auxADC_Vmid);
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x0E, 16,
-					 &auxADC_Av);
+			pi->radio_is_on = false;
+		}
 
-		udelay(3);
+		if (NREV_GE(pi->pubpi.phy_rev, 8)) {
+			and_phy_reg(pi, 0x78, ~RFCC_CHIP0_PU);
+			pi->radio_is_on = false;
+		}
 
-		wlc_phy_poll_rssi_nphy(pi, NPHY_RSSI_SEL_IQ, radio_temp, 1);
-		write_radio_reg(pi, RADIO_2057_TEMPSENSE_CONFIG,
-				tempsense_Rcal | 0x03);
+	}
+}
 
-		udelay(5);
-		wlc_phy_poll_rssi_nphy(pi, NPHY_RSSI_SEL_IQ, radio_temp2, 1);
+static bool
+wlc_phy_chan2freq_nphy(struct brcms_phy *pi, uint channel, int *f,
+		       struct chan_info_nphy_radio2057 **t0,
+		       struct chan_info_nphy_radio205x **t1,
+		       struct chan_info_nphy_radio2057_rev5 **t2,
+		       struct chan_info_nphy_2055 **t3)
+{
+	uint i;
+	struct chan_info_nphy_radio2057 *chan_info_tbl_p_0 = NULL;
+	struct chan_info_nphy_radio205x *chan_info_tbl_p_1 = NULL;
+	struct chan_info_nphy_radio2057_rev5 *chan_info_tbl_p_2 = NULL;
+	u32 tbl_len = 0;
 
-		auxADC_Av = 0x7;
-		if (radio_temp[1] + radio_temp2[1] < -30) {
-			auxADC_Vmid = 0x45;
-			auxADC_Vl = 263;
-		} else if (radio_temp[1] + radio_temp2[1] < -9) {
-			auxADC_Vmid = 0x200;
-			auxADC_Vl = 467;
-		} else if (radio_temp[1] + radio_temp2[1] < 11) {
-			auxADC_Vmid = 0x266;
-			auxADC_Vl = 634;
-		} else {
-			auxADC_Vmid = 0x2D5;
-			auxADC_Vl = 816;
-		}
+	int freq = 0;
 
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x0A, 16,
-					 &auxADC_Vmid);
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x0E, 16,
-					 &auxADC_Av);
+	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 
-		udelay(3);
+		if (NREV_IS(pi->pubpi.phy_rev, 7)) {
 
-		wlc_phy_poll_rssi_nphy(pi, NPHY_RSSI_SEL_IQ, radio_temp2, 1);
-		write_radio_reg(pi, RADIO_2057_TEMPSENSE_CONFIG,
-				tempsense_Rcal | 0x01);
+			chan_info_tbl_p_0 = chan_info_nphyrev7_2057_rev4;
+			tbl_len = ARRAY_SIZE(chan_info_nphyrev7_2057_rev4);
 
-		udelay(5);
-		wlc_phy_poll_rssi_nphy(pi, NPHY_RSSI_SEL_IQ, radio_temp, 1);
+		} else if (NREV_IS(pi->pubpi.phy_rev, 8)
+			   || NREV_IS(pi->pubpi.phy_rev, 9)) {
+			switch (pi->pubpi.radiorev) {
 
-		write_radio_reg(pi, RADIO_2057_TEMPSENSE_CONFIG,
-				syn_tempprocsense_save);
+			case 5:
 
-		write_phy_reg(pi, 0xa6, afectrlCore1_save);
-		write_phy_reg(pi, 0xa7, afectrlCore2_save);
-		write_phy_reg(pi, 0x8f, afectrlOverride_save);
-		write_phy_reg(pi, 0xa5, afectrlOverride2_save);
-		write_phy_reg(pi, 0x1ae, RSSIMultCoef0QPowerDet_save);
-		write_phy_reg(pi, 0x346, RfctrlOverride5_save);
-		write_phy_reg(pi, 0x347, RfctrlOverride6_save);
-		write_phy_reg(pi, 0x344, RfctrlMiscReg5_save);
-		write_phy_reg(pi, 0x345, RfctrlMiscReg5_save);
+				if (pi->pubpi.radiover == 0x0) {
 
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x0A, 16,
-					 &auxADC_Vmid_save);
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x0E, 16,
-					 &auxADC_Av_save);
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x02, 16,
-					 &auxADC_rssi_ctrlL_save);
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x03, 16,
-					 &auxADC_rssi_ctrlH_save);
+					chan_info_tbl_p_2 =
+						chan_info_nphyrev8_2057_rev5;
+					tbl_len = ARRAY_SIZE(
+						  chan_info_nphyrev8_2057_rev5);
 
-		radio_temp[0] = (179 * (radio_temp[1] + radio_temp2[1])
-				 + 82 * (auxADC_Vl) - 28861 +
-				 128) / 256;
+				} else if (pi->pubpi.radiover == 0x1) {
 
-		offset = (s16) pi->phy_tempsense_offset;
+					chan_info_tbl_p_2 =
+						chan_info_nphyrev9_2057_rev5v1;
+					tbl_len = ARRAY_SIZE(
+						chan_info_nphyrev9_2057_rev5v1);
 
-	} else if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-		syn_tempprocsense_save =
-			read_radio_reg(pi, RADIO_2056_SYN_TEMPPROCSENSE);
+				}
+				break;
 
-		afectrlCore1_save = read_phy_reg(pi, 0xa6);
-		afectrlCore2_save = read_phy_reg(pi, 0xa7);
-		afectrlOverride_save = read_phy_reg(pi, 0x8f);
-		afectrlOverride2_save = read_phy_reg(pi, 0xa5);
-		gpioSel_save = read_phy_reg(pi, 0xca);
+			case 7:
+				chan_info_tbl_p_0 =
+					chan_info_nphyrev8_2057_rev7;
+				tbl_len = ARRAY_SIZE(
+						  chan_info_nphyrev8_2057_rev7);
+				break;
 
-		write_radio_reg(pi, RADIO_2056_SYN_TEMPPROCSENSE, 0x01);
+			case 8:
+				chan_info_tbl_p_0 =
+					chan_info_nphyrev8_2057_rev8;
+				tbl_len = ARRAY_SIZE(
+						  chan_info_nphyrev8_2057_rev8);
+				break;
 
-		wlc_phy_poll_rssi_nphy(pi, NPHY_RSSI_SEL_IQ, radio_temp, 1);
-		if (NREV_LT(pi->pubpi.phy_rev, 7))
-			write_radio_reg(pi, RADIO_2056_SYN_TEMPPROCSENSE, 0x05);
+			default:
+				break;
+			}
+		} else if (NREV_IS(pi->pubpi.phy_rev, 16)) {
+
+			chan_info_tbl_p_0 = chan_info_nphyrev8_2057_rev8;
+			tbl_len = ARRAY_SIZE(chan_info_nphyrev8_2057_rev8);
+		} else {
+			goto fail;
+		}
 
-		wlc_phy_poll_rssi_nphy(pi, NPHY_RSSI_SEL_IQ, radio_temp2, 1);
-		if (NREV_GE(pi->pubpi.phy_rev, 7))
-			write_radio_reg(pi, RADIO_2057_TEMPSENSE_CONFIG, 0x01);
-		else
-			write_radio_reg(pi, RADIO_2056_SYN_TEMPPROCSENSE, 0x01);
+		for (i = 0; i < tbl_len; i++) {
+			if (pi->pubpi.radiorev == 5) {
 
-		radio_temp[0] =
-			(126 * (radio_temp[1] + radio_temp2[1]) + 3987) / 64;
+				if (chan_info_tbl_p_2[i].chan == channel)
+					break;
+			} else {
 
-		write_radio_reg(pi, RADIO_2056_SYN_TEMPPROCSENSE,
-				syn_tempprocsense_save);
+				if (chan_info_tbl_p_0[i].chan == channel)
+					break;
+			}
+		}
 
-		write_phy_reg(pi, 0xca, gpioSel_save);
-		write_phy_reg(pi, 0xa6, afectrlCore1_save);
-		write_phy_reg(pi, 0xa7, afectrlCore2_save);
-		write_phy_reg(pi, 0x8f, afectrlOverride_save);
-		write_phy_reg(pi, 0xa5, afectrlOverride2_save);
+		if (i >= tbl_len)
+			goto fail;
 
-		offset = (s16) pi->phy_tempsense_offset;
-	} else {
+		if (pi->pubpi.radiorev == 5) {
+			*t2 = &chan_info_tbl_p_2[i];
+			freq = chan_info_tbl_p_2[i].freq;
+		} else {
+			*t0 = &chan_info_tbl_p_0[i];
+			freq = chan_info_tbl_p_0[i].freq;
+		}
 
-		pwrdet_rxtx_core1_save =
-			read_radio_reg(pi, RADIO_2055_PWRDET_RXTX_CORE1);
-		pwrdet_rxtx_core2_save =
-			read_radio_reg(pi, RADIO_2055_PWRDET_RXTX_CORE2);
-		core1_txrf_iqcal1_save =
-			read_radio_reg(pi, RADIO_2055_CORE1_TXRF_IQCAL1);
-		core1_txrf_iqcal2_save =
-			read_radio_reg(pi, RADIO_2055_CORE1_TXRF_IQCAL2);
-		core2_txrf_iqcal1_save =
-			read_radio_reg(pi, RADIO_2055_CORE2_TXRF_IQCAL1);
-		core2_txrf_iqcal2_save =
-			read_radio_reg(pi, RADIO_2055_CORE2_TXRF_IQCAL2);
-		pd_pll_ts_save = read_radio_reg(pi, RADIO_2055_PD_PLL_TS);
+	} else if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+		if (NREV_IS(pi->pubpi.phy_rev, 3)) {
+			chan_info_tbl_p_1 = chan_info_nphyrev3_2056;
+			tbl_len = ARRAY_SIZE(chan_info_nphyrev3_2056);
+		} else if (NREV_IS(pi->pubpi.phy_rev, 4)) {
+			chan_info_tbl_p_1 = chan_info_nphyrev4_2056_A1;
+			tbl_len = ARRAY_SIZE(chan_info_nphyrev4_2056_A1);
+		} else if (NREV_IS(pi->pubpi.phy_rev, 5)
+			   || NREV_IS(pi->pubpi.phy_rev, 6)) {
+			switch (pi->pubpi.radiorev) {
+			case 5:
+				chan_info_tbl_p_1 = chan_info_nphyrev5_2056v5;
+				tbl_len = ARRAY_SIZE(chan_info_nphyrev5_2056v5);
+				break;
+			case 6:
+				chan_info_tbl_p_1 = chan_info_nphyrev6_2056v6;
+				tbl_len = ARRAY_SIZE(chan_info_nphyrev6_2056v6);
+				break;
+			case 7:
+			case 9:
+				chan_info_tbl_p_1 = chan_info_nphyrev5n6_2056v7;
+				tbl_len =
+					ARRAY_SIZE(chan_info_nphyrev5n6_2056v7);
+				break;
+			case 8:
+				chan_info_tbl_p_1 = chan_info_nphyrev6_2056v8;
+				tbl_len = ARRAY_SIZE(chan_info_nphyrev6_2056v8);
+				break;
+			case 11:
+				chan_info_tbl_p_1 = chan_info_nphyrev6_2056v11;
+				tbl_len = ARRAY_SIZE(
+						    chan_info_nphyrev6_2056v11);
+				break;
+			default:
+				break;
+			}
+		}
 
-		afectrlCore1_save = read_phy_reg(pi, 0xa6);
-		afectrlCore2_save = read_phy_reg(pi, 0xa7);
-		afectrlOverride_save = read_phy_reg(pi, 0xa5);
-		gpioSel_save = read_phy_reg(pi, 0xca);
+		for (i = 0; i < tbl_len; i++) {
+			if (chan_info_tbl_p_1[i].chan == channel)
+				break;
+		}
 
-		write_radio_reg(pi, RADIO_2055_CORE1_TXRF_IQCAL1, 0x01);
-		write_radio_reg(pi, RADIO_2055_CORE2_TXRF_IQCAL1, 0x01);
-		write_radio_reg(pi, RADIO_2055_CORE1_TXRF_IQCAL2, 0x08);
-		write_radio_reg(pi, RADIO_2055_CORE2_TXRF_IQCAL2, 0x08);
-		write_radio_reg(pi, RADIO_2055_PWRDET_RXTX_CORE1, 0x04);
-		write_radio_reg(pi, RADIO_2055_PWRDET_RXTX_CORE2, 0x04);
-		write_radio_reg(pi, RADIO_2055_PD_PLL_TS, 0x00);
+		if (i >= tbl_len)
+			goto fail;
 
-		wlc_phy_poll_rssi_nphy(pi, NPHY_RSSI_SEL_IQ, radio_temp, 1);
-		xor_radio_reg(pi, RADIO_2055_CAL_TS, 0x80);
+		*t1 = &chan_info_tbl_p_1[i];
+		freq = chan_info_tbl_p_1[i].freq;
 
-		wlc_phy_poll_rssi_nphy(pi, NPHY_RSSI_SEL_IQ, radio_temp, 1);
-		xor_radio_reg(pi, RADIO_2055_CAL_TS, 0x80);
+	} else {
+		for (i = 0; i < ARRAY_SIZE(chan_info_nphy_2055); i++)
+			if (chan_info_nphy_2055[i].chan == channel)
+				break;
 
-		wlc_phy_poll_rssi_nphy(pi, NPHY_RSSI_SEL_IQ, radio_temp2, 1);
-		xor_radio_reg(pi, RADIO_2055_CAL_TS, 0x80);
+		if (i >= ARRAY_SIZE(chan_info_nphy_2055))
+			goto fail;
 
-		radio_temp[0] = (radio_temp[0] + radio_temp2[0]);
-		radio_temp[1] = (radio_temp[1] + radio_temp2[1]);
-		radio_temp[2] = (radio_temp[2] + radio_temp2[2]);
-		radio_temp[3] = (radio_temp[3] + radio_temp2[3]);
+		*t3 = &chan_info_nphy_2055[i];
+		freq = chan_info_nphy_2055[i].freq;
+	}
 
-		radio_temp[0] =
-			(radio_temp[0] + radio_temp[1] + radio_temp[2] +
-			 radio_temp[3]);
+	*f = freq;
+	return true;
 
-		radio_temp[0] =
-			(radio_temp[0] +
-			 (8 * 32)) * (950 - 350) / 63 + (350 * 8);
+fail:
+	*f = WL_CHAN_FREQ_RANGE_2G;
+	return false;
+}
 
-		radio_temp[0] = (radio_temp[0] - (8 * 420)) / 38;
+u8 wlc_phy_get_chan_freq_range_nphy(struct brcms_phy *pi, uint channel)
+{
+	int freq;
+	struct chan_info_nphy_radio2057 *t0 = NULL;
+	struct chan_info_nphy_radio205x *t1 = NULL;
+	struct chan_info_nphy_radio2057_rev5 *t2 = NULL;
+	struct chan_info_nphy_2055 *t3 = NULL;
 
-		write_radio_reg(pi, RADIO_2055_PWRDET_RXTX_CORE1,
-				pwrdet_rxtx_core1_save);
-		write_radio_reg(pi, RADIO_2055_PWRDET_RXTX_CORE2,
-				pwrdet_rxtx_core2_save);
-		write_radio_reg(pi, RADIO_2055_CORE1_TXRF_IQCAL1,
-				core1_txrf_iqcal1_save);
-		write_radio_reg(pi, RADIO_2055_CORE2_TXRF_IQCAL1,
-				core2_txrf_iqcal1_save);
-		write_radio_reg(pi, RADIO_2055_CORE1_TXRF_IQCAL2,
-				core1_txrf_iqcal2_save);
-		write_radio_reg(pi, RADIO_2055_CORE2_TXRF_IQCAL2,
-				core2_txrf_iqcal2_save);
-		write_radio_reg(pi, RADIO_2055_PD_PLL_TS, pd_pll_ts_save);
+	if (channel == 0)
+		channel = CHSPEC_CHANNEL(pi->radio_chanspec);
 
-		write_phy_reg(pi, 0xca, gpioSel_save);
-		write_phy_reg(pi, 0xa6, afectrlCore1_save);
-		write_phy_reg(pi, 0xa7, afectrlCore2_save);
-		write_phy_reg(pi, 0xa5, afectrlOverride_save);
-	}
+	wlc_phy_chan2freq_nphy(pi, channel, &freq, &t0, &t1, &t2, &t3);
 
-	return (s16) radio_temp[0] + offset;
+	if (CHSPEC_IS2G(pi->radio_chanspec))
+		return WL_CHAN_FREQ_RANGE_2G;
+
+	if ((freq >= BASE_LOW_5G_CHAN) && (freq < BASE_MID_5G_CHAN))
+		return WL_CHAN_FREQ_RANGE_5GL;
+	else if ((freq >= BASE_MID_5G_CHAN) && (freq < BASE_HIGH_5G_CHAN))
+		return WL_CHAN_FREQ_RANGE_5GM;
+	else
+		return WL_CHAN_FREQ_RANGE_5GH;
 }
 
 static void
-wlc_phy_set_rssi_2055_vcm(struct brcms_phy *pi, u8 rssi_type, u8 *vcm_buf)
+wlc_phy_chanspec_radio2055_setup(struct brcms_phy *pi,
+				 struct chan_info_nphy_2055 *ci)
 {
-	u8 core;
 
-	for (core = 0; core < pi->pubpi.phy_corenum; core++) {
-		if (rssi_type == NPHY_RSSI_SEL_NB) {
-			if (core == PHY_CORE_0) {
-				mod_radio_reg(pi,
-					      RADIO_2055_CORE1_B0_NBRSSI_VCM,
-					      RADIO_2055_NBRSSI_VCM_I_MASK,
-					      vcm_buf[2 *
-						      core] <<
-					      RADIO_2055_NBRSSI_VCM_I_SHIFT);
-				mod_radio_reg(pi,
-					      RADIO_2055_CORE1_RXBB_RSSI_CTRL5,
-					      RADIO_2055_NBRSSI_VCM_Q_MASK,
-					      vcm_buf[2 * core +
-						      1] <<
-					      RADIO_2055_NBRSSI_VCM_Q_SHIFT);
-			} else {
-				mod_radio_reg(pi,
-					      RADIO_2055_CORE2_B0_NBRSSI_VCM,
-					      RADIO_2055_NBRSSI_VCM_I_MASK,
-					      vcm_buf[2 *
-						      core] <<
-					      RADIO_2055_NBRSSI_VCM_I_SHIFT);
-				mod_radio_reg(pi,
-					      RADIO_2055_CORE2_RXBB_RSSI_CTRL5,
-					      RADIO_2055_NBRSSI_VCM_Q_MASK,
-					      vcm_buf[2 * core +
-						      1] <<
-					      RADIO_2055_NBRSSI_VCM_Q_SHIFT);
-			}
-		} else {
-			if (core == PHY_CORE_0)
-				mod_radio_reg(pi,
-					      RADIO_2055_CORE1_RXBB_RSSI_CTRL5,
-					      RADIO_2055_WBRSSI_VCM_IQ_MASK,
-					      vcm_buf[2 *
-						      core] <<
-					      RADIO_2055_WBRSSI_VCM_IQ_SHIFT);
-			else
-				mod_radio_reg(pi,
-					      RADIO_2055_CORE2_RXBB_RSSI_CTRL5,
-					      RADIO_2055_WBRSSI_VCM_IQ_MASK,
-					      vcm_buf[2 *
-						      core] <<
-					      RADIO_2055_WBRSSI_VCM_IQ_SHIFT);
-		}
-	}
-}
+	write_radio_reg(pi, RADIO_2055_PLL_REF, ci->RF_pll_ref);
+	write_radio_reg(pi, RADIO_2055_RF_PLL_MOD0, ci->RF_rf_pll_mod0);
+	write_radio_reg(pi, RADIO_2055_RF_PLL_MOD1, ci->RF_rf_pll_mod1);
+	write_radio_reg(pi, RADIO_2055_VCO_CAP_TAIL, ci->RF_vco_cap_tail);
 
-void wlc_phy_rssi_cal_nphy(struct brcms_phy *pi)
-{
-	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-		wlc_phy_rssi_cal_nphy_rev3(pi);
-	} else {
-		wlc_phy_rssi_cal_nphy_rev2(pi, NPHY_RSSI_SEL_NB);
-		wlc_phy_rssi_cal_nphy_rev2(pi, NPHY_RSSI_SEL_W1);
-		wlc_phy_rssi_cal_nphy_rev2(pi, NPHY_RSSI_SEL_W2);
-	}
-}
+	BRCMS_PHY_WAR_PR51571(pi);
+
+	write_radio_reg(pi, RADIO_2055_VCO_CAL1, ci->RF_vco_cal1);
+	write_radio_reg(pi, RADIO_2055_VCO_CAL2, ci->RF_vco_cal2);
+	write_radio_reg(pi, RADIO_2055_PLL_LF_C1, ci->RF_pll_lf_c1);
+	write_radio_reg(pi, RADIO_2055_PLL_LF_R1, ci->RF_pll_lf_r1);
+
+	BRCMS_PHY_WAR_PR51571(pi);
+
+	write_radio_reg(pi, RADIO_2055_PLL_LF_C2, ci->RF_pll_lf_c2);
+	write_radio_reg(pi, RADIO_2055_LGBUF_CEN_BUF, ci->RF_lgbuf_cen_buf);
+	write_radio_reg(pi, RADIO_2055_LGEN_TUNE1, ci->RF_lgen_tune1);
+	write_radio_reg(pi, RADIO_2055_LGEN_TUNE2, ci->RF_lgen_tune2);
+
+	BRCMS_PHY_WAR_PR51571(pi);
+
+	write_radio_reg(pi, RADIO_2055_CORE1_LGBUF_A_TUNE,
+			ci->RF_core1_lgbuf_a_tune);
+	write_radio_reg(pi, RADIO_2055_CORE1_LGBUF_G_TUNE,
+			ci->RF_core1_lgbuf_g_tune);
+	write_radio_reg(pi, RADIO_2055_CORE1_RXRF_REG1, ci->RF_core1_rxrf_reg1);
+	write_radio_reg(pi, RADIO_2055_CORE1_TX_PGA_PAD_TN,
+			ci->RF_core1_tx_pga_pad_tn);
 
-static void wlc_phy_rssi_cal_nphy_rev2(struct brcms_phy *pi, u8 rssi_type)
-{
-	s32 target_code;
-	u16 classif_state;
-	u16 clip_state[2];
-	u16 rssi_ctrl_state[2], pd_state[2];
-	u16 rfctrlintc_state[2], rfpdcorerxtx_state[2];
-	u16 rfctrlintc_override_val;
-	u16 clip_off[] = { 0xffff, 0xffff };
-	u16 rf_pd_val, pd_mask, rssi_ctrl_mask;
-	u8 vcm, min_vcm, vcm_tmp[4];
-	u8 vcm_final[4] = { 0, 0, 0, 0 };
-	u8 result_idx, ctr;
-	s32 poll_results[4][4] = {
-		{0, 0, 0, 0},
-		{0, 0, 0, 0},
-		{0, 0, 0, 0},
-		{0, 0, 0, 0}
-	};
-	s32 poll_miniq[4][2] = {
-		{0, 0},
-		{0, 0},
-		{0, 0},
-		{0, 0}
-	};
-	s32 min_d, curr_d;
-	s32 fine_digital_offset[4];
-	s32 poll_results_min[4] = { 0, 0, 0, 0 };
-	s32 min_poll;
+	BRCMS_PHY_WAR_PR51571(pi);
 
-	switch (rssi_type) {
-	case NPHY_RSSI_SEL_NB:
-		target_code = NPHY_RSSICAL_NB_TARGET;
-		break;
-	case NPHY_RSSI_SEL_W1:
-		target_code = NPHY_RSSICAL_W1_TARGET;
-		break;
-	case NPHY_RSSI_SEL_W2:
-		target_code = NPHY_RSSICAL_W2_TARGET;
-		break;
-	default:
-		return;
-		break;
-	}
+	write_radio_reg(pi, RADIO_2055_CORE1_TX_MX_BGTRIM,
+			ci->RF_core1_tx_mx_bgtrim);
+	write_radio_reg(pi, RADIO_2055_CORE2_LGBUF_A_TUNE,
+			ci->RF_core2_lgbuf_a_tune);
+	write_radio_reg(pi, RADIO_2055_CORE2_LGBUF_G_TUNE,
+			ci->RF_core2_lgbuf_g_tune);
+	write_radio_reg(pi, RADIO_2055_CORE2_RXRF_REG1, ci->RF_core2_rxrf_reg1);
 
-	classif_state = wlc_phy_classifier_nphy(pi, 0, 0);
-	wlc_phy_classifier_nphy(pi, (0x7 << 0), 4);
-	wlc_phy_clip_det_nphy(pi, 0, clip_state);
-	wlc_phy_clip_det_nphy(pi, 1, clip_off);
+	BRCMS_PHY_WAR_PR51571(pi);
 
-	rf_pd_val = (rssi_type == NPHY_RSSI_SEL_NB) ? 0x6 : 0x4;
-	rfctrlintc_override_val =
-		CHSPEC_IS5G(pi->radio_chanspec) ? 0x140 : 0x110;
+	write_radio_reg(pi, RADIO_2055_CORE2_TX_PGA_PAD_TN,
+			ci->RF_core2_tx_pga_pad_tn);
+	write_radio_reg(pi, RADIO_2055_CORE2_TX_MX_BGTRIM,
+			ci->RF_core2_tx_mx_bgtrim);
 
-	rfctrlintc_state[0] = read_phy_reg(pi, 0x91);
-	rfpdcorerxtx_state[0] = read_radio_reg(pi, RADIO_2055_PD_CORE1_RXTX);
-	write_phy_reg(pi, 0x91, rfctrlintc_override_val);
-	write_radio_reg(pi, RADIO_2055_PD_CORE1_RXTX, rf_pd_val);
+	udelay(50);
 
-	rfctrlintc_state[1] = read_phy_reg(pi, 0x92);
-	rfpdcorerxtx_state[1] = read_radio_reg(pi, RADIO_2055_PD_CORE2_RXTX);
-	write_phy_reg(pi, 0x92, rfctrlintc_override_val);
-	write_radio_reg(pi, RADIO_2055_PD_CORE2_RXTX, rf_pd_val);
+	write_radio_reg(pi, RADIO_2055_VCO_CAL10, 0x05);
+	write_radio_reg(pi, RADIO_2055_VCO_CAL10, 0x45);
 
-	pd_mask = RADIO_2055_NBRSSI_PD | RADIO_2055_WBRSSI_G1_PD |
-		  RADIO_2055_WBRSSI_G2_PD;
-	pd_state[0] =
-		read_radio_reg(pi, RADIO_2055_PD_CORE1_RSSI_MISC) & pd_mask;
-	pd_state[1] =
-		read_radio_reg(pi, RADIO_2055_PD_CORE2_RSSI_MISC) & pd_mask;
-	mod_radio_reg(pi, RADIO_2055_PD_CORE1_RSSI_MISC, pd_mask, 0);
-	mod_radio_reg(pi, RADIO_2055_PD_CORE2_RSSI_MISC, pd_mask, 0);
-	rssi_ctrl_mask = RADIO_2055_NBRSSI_SEL | RADIO_2055_WBRSSI_G1_SEL |
-			 RADIO_2055_WBRSSI_G2_SEL;
-	rssi_ctrl_state[0] =
-		read_radio_reg(pi, RADIO_2055_SP_RSSI_CORE1) & rssi_ctrl_mask;
-	rssi_ctrl_state[1] =
-		read_radio_reg(pi, RADIO_2055_SP_RSSI_CORE2) & rssi_ctrl_mask;
-	wlc_phy_rssisel_nphy(pi, RADIO_MIMO_CORESEL_ALLRX, rssi_type);
+	BRCMS_PHY_WAR_PR51571(pi);
 
-	wlc_phy_scale_offset_rssi_nphy(pi, 0x0, 0x0, RADIO_MIMO_CORESEL_ALLRX,
-				       NPHY_RAIL_I, rssi_type);
-	wlc_phy_scale_offset_rssi_nphy(pi, 0x0, 0x0, RADIO_MIMO_CORESEL_ALLRX,
-				       NPHY_RAIL_Q, rssi_type);
+	write_radio_reg(pi, RADIO_2055_VCO_CAL10, 0x65);
 
-	for (vcm = 0; vcm < 4; vcm++) {
+	udelay(300);
+}
 
-		vcm_tmp[0] = vcm_tmp[1] = vcm_tmp[2] = vcm_tmp[3] = vcm;
-		if (rssi_type != NPHY_RSSI_SEL_W2)
-			wlc_phy_set_rssi_2055_vcm(pi, rssi_type, vcm_tmp);
+static void
+wlc_phy_chanspec_radio2056_setup(struct brcms_phy *pi,
+				 const struct chan_info_nphy_radio205x *ci)
+{
+	struct radio_regs *regs_SYN_2056_ptr = NULL;
 
-		wlc_phy_poll_rssi_nphy(pi, rssi_type, &poll_results[vcm][0],
-				       NPHY_RSSICAL_NPOLL);
+	write_radio_reg(pi,
+			RADIO_2056_SYN_PLL_VCOCAL1 | RADIO_2056_SYN,
+			ci->RF_SYN_pll_vcocal1);
+	write_radio_reg(pi, RADIO_2056_SYN_PLL_VCOCAL2 | RADIO_2056_SYN,
+			ci->RF_SYN_pll_vcocal2);
+	write_radio_reg(pi, RADIO_2056_SYN_PLL_REFDIV | RADIO_2056_SYN,
+			ci->RF_SYN_pll_refdiv);
+	write_radio_reg(pi, RADIO_2056_SYN_PLL_MMD2 | RADIO_2056_SYN,
+			ci->RF_SYN_pll_mmd2);
+	write_radio_reg(pi, RADIO_2056_SYN_PLL_MMD1 | RADIO_2056_SYN,
+			ci->RF_SYN_pll_mmd1);
+	write_radio_reg(pi, RADIO_2056_SYN_PLL_LOOPFILTER1 | RADIO_2056_SYN,
+			ci->RF_SYN_pll_loopfilter1);
+	write_radio_reg(pi, RADIO_2056_SYN_PLL_LOOPFILTER2 | RADIO_2056_SYN,
+			ci->RF_SYN_pll_loopfilter2);
+	write_radio_reg(pi, RADIO_2056_SYN_PLL_LOOPFILTER3 | RADIO_2056_SYN,
+			ci->RF_SYN_pll_loopfilter3);
+	write_radio_reg(pi, RADIO_2056_SYN_PLL_LOOPFILTER4 | RADIO_2056_SYN,
+			ci->RF_SYN_pll_loopfilter4);
+	write_radio_reg(pi, RADIO_2056_SYN_PLL_LOOPFILTER5 | RADIO_2056_SYN,
+			ci->RF_SYN_pll_loopfilter5);
+	write_radio_reg(pi, RADIO_2056_SYN_RESERVED_ADDR27 | RADIO_2056_SYN,
+			ci->RF_SYN_reserved_addr27);
+	write_radio_reg(pi, RADIO_2056_SYN_RESERVED_ADDR28 | RADIO_2056_SYN,
+			ci->RF_SYN_reserved_addr28);
+	write_radio_reg(pi, RADIO_2056_SYN_RESERVED_ADDR29 | RADIO_2056_SYN,
+			ci->RF_SYN_reserved_addr29);
+	write_radio_reg(pi, RADIO_2056_SYN_LOGEN_VCOBUF1 | RADIO_2056_SYN,
+			ci->RF_SYN_logen_VCOBUF1);
+	write_radio_reg(pi, RADIO_2056_SYN_LOGEN_MIXER2 | RADIO_2056_SYN,
+			ci->RF_SYN_logen_MIXER2);
+	write_radio_reg(pi, RADIO_2056_SYN_LOGEN_BUF3 | RADIO_2056_SYN,
+			ci->RF_SYN_logen_BUF3);
+	write_radio_reg(pi, RADIO_2056_SYN_LOGEN_BUF4 | RADIO_2056_SYN,
+			ci->RF_SYN_logen_BUF4);
 
-		if ((rssi_type == NPHY_RSSI_SEL_W1)
-		    || (rssi_type == NPHY_RSSI_SEL_W2)) {
-			for (ctr = 0; ctr < 2; ctr++)
-				poll_miniq[vcm][ctr] =
-					min(poll_results[vcm][ctr * 2 + 0],
-					    poll_results[vcm][ctr * 2 + 1]);
+	write_radio_reg(pi,
+			RADIO_2056_RX_LNAA_TUNE | RADIO_2056_RX0,
+			ci->RF_RX0_lnaa_tune);
+	write_radio_reg(pi, RADIO_2056_RX_LNAG_TUNE | RADIO_2056_RX0,
+			ci->RF_RX0_lnag_tune);
+	write_radio_reg(pi, RADIO_2056_TX_INTPAA_BOOST_TUNE | RADIO_2056_TX0,
+			ci->RF_TX0_intpaa_boost_tune);
+	write_radio_reg(pi, RADIO_2056_TX_INTPAG_BOOST_TUNE | RADIO_2056_TX0,
+			ci->RF_TX0_intpag_boost_tune);
+	write_radio_reg(pi, RADIO_2056_TX_PADA_BOOST_TUNE | RADIO_2056_TX0,
+			ci->RF_TX0_pada_boost_tune);
+	write_radio_reg(pi, RADIO_2056_TX_PADG_BOOST_TUNE | RADIO_2056_TX0,
+			ci->RF_TX0_padg_boost_tune);
+	write_radio_reg(pi, RADIO_2056_TX_PGAA_BOOST_TUNE | RADIO_2056_TX0,
+			ci->RF_TX0_pgaa_boost_tune);
+	write_radio_reg(pi, RADIO_2056_TX_PGAG_BOOST_TUNE | RADIO_2056_TX0,
+			ci->RF_TX0_pgag_boost_tune);
+	write_radio_reg(pi, RADIO_2056_TX_MIXA_BOOST_TUNE | RADIO_2056_TX0,
+			ci->RF_TX0_mixa_boost_tune);
+	write_radio_reg(pi, RADIO_2056_TX_MIXG_BOOST_TUNE | RADIO_2056_TX0,
+			ci->RF_TX0_mixg_boost_tune);
+
+	write_radio_reg(pi,
+			RADIO_2056_RX_LNAA_TUNE | RADIO_2056_RX1,
+			ci->RF_RX1_lnaa_tune);
+	write_radio_reg(pi, RADIO_2056_RX_LNAG_TUNE | RADIO_2056_RX1,
+			ci->RF_RX1_lnag_tune);
+	write_radio_reg(pi, RADIO_2056_TX_INTPAA_BOOST_TUNE | RADIO_2056_TX1,
+			ci->RF_TX1_intpaa_boost_tune);
+	write_radio_reg(pi, RADIO_2056_TX_INTPAG_BOOST_TUNE | RADIO_2056_TX1,
+			ci->RF_TX1_intpag_boost_tune);
+	write_radio_reg(pi, RADIO_2056_TX_PADA_BOOST_TUNE | RADIO_2056_TX1,
+			ci->RF_TX1_pada_boost_tune);
+	write_radio_reg(pi, RADIO_2056_TX_PADG_BOOST_TUNE | RADIO_2056_TX1,
+			ci->RF_TX1_padg_boost_tune);
+	write_radio_reg(pi, RADIO_2056_TX_PGAA_BOOST_TUNE | RADIO_2056_TX1,
+			ci->RF_TX1_pgaa_boost_tune);
+	write_radio_reg(pi, RADIO_2056_TX_PGAG_BOOST_TUNE | RADIO_2056_TX1,
+			ci->RF_TX1_pgag_boost_tune);
+	write_radio_reg(pi, RADIO_2056_TX_MIXA_BOOST_TUNE | RADIO_2056_TX1,
+			ci->RF_TX1_mixa_boost_tune);
+	write_radio_reg(pi, RADIO_2056_TX_MIXG_BOOST_TUNE | RADIO_2056_TX1,
+			ci->RF_TX1_mixg_boost_tune);
+
+	if (NREV_IS(pi->pubpi.phy_rev, 3))
+		regs_SYN_2056_ptr = regs_SYN_2056;
+	else if (NREV_IS(pi->pubpi.phy_rev, 4))
+		regs_SYN_2056_ptr = regs_SYN_2056_A1;
+	else {
+		switch (pi->pubpi.radiorev) {
+		case 5:
+			regs_SYN_2056_ptr = regs_SYN_2056_rev5;
+			break;
+		case 6:
+			regs_SYN_2056_ptr = regs_SYN_2056_rev6;
+			break;
+		case 7:
+		case 9:
+			regs_SYN_2056_ptr = regs_SYN_2056_rev7;
+			break;
+		case 8:
+			regs_SYN_2056_ptr = regs_SYN_2056_rev8;
+			break;
+		case 11:
+			regs_SYN_2056_ptr = regs_SYN_2056_rev11;
+			break;
 		}
 	}
+	if (CHSPEC_IS2G(pi->radio_chanspec))
+		write_radio_reg(pi, RADIO_2056_SYN_PLL_CP2 |
+				RADIO_2056_SYN,
+				(u16) regs_SYN_2056_ptr[0x49 - 2].init_g);
+	else
+		write_radio_reg(pi, RADIO_2056_SYN_PLL_CP2 |
+				RADIO_2056_SYN,
+				(u16) regs_SYN_2056_ptr[0x49 - 2].init_a);
 
-	for (result_idx = 0; result_idx < 4; result_idx++) {
-		min_d = NPHY_RSSICAL_MAXD;
-		min_vcm = 0;
-		min_poll = NPHY_RSSICAL_MAXREAD * NPHY_RSSICAL_NPOLL + 1;
-		for (vcm = 0; vcm < 4; vcm++) {
-			curr_d = ABS(((rssi_type == NPHY_RSSI_SEL_NB) ?
-				      poll_results[vcm][result_idx] :
-				      poll_miniq[vcm][result_idx / 2]) -
-				     (target_code * NPHY_RSSICAL_NPOLL));
-			if (curr_d < min_d) {
-				min_d = curr_d;
-				min_vcm = vcm;
-			}
-			if (poll_results[vcm][result_idx] < min_poll)
-				min_poll = poll_results[vcm][result_idx];
+	if (pi->sh->boardflags2 & BFL2_GPLL_WAR) {
+		if (CHSPEC_IS2G(pi->radio_chanspec)) {
+			write_radio_reg(pi, RADIO_2056_SYN_PLL_LOOPFILTER1 |
+					RADIO_2056_SYN, 0x1f);
+			write_radio_reg(pi, RADIO_2056_SYN_PLL_LOOPFILTER2 |
+					RADIO_2056_SYN, 0x1f);
+
+			write_radio_reg(pi,
+					RADIO_2056_SYN_PLL_LOOPFILTER4 |
+					RADIO_2056_SYN, 0xb);
+			write_radio_reg(pi,
+					RADIO_2056_SYN_PLL_CP2 |
+					RADIO_2056_SYN, 0x14);
 		}
-		vcm_final[result_idx] = min_vcm;
-		poll_results_min[result_idx] = min_poll;
 	}
 
-	if (rssi_type != NPHY_RSSI_SEL_W2)
-		wlc_phy_set_rssi_2055_vcm(pi, rssi_type, vcm_final);
+	if ((pi->sh->boardflags2 & BFL2_GPLL_WAR2) &&
+	    (CHSPEC_IS2G(pi->radio_chanspec))) {
+		write_radio_reg(pi,
+				RADIO_2056_SYN_PLL_LOOPFILTER1 | RADIO_2056_SYN,
+				0x1f);
+		write_radio_reg(pi,
+				RADIO_2056_SYN_PLL_LOOPFILTER2 | RADIO_2056_SYN,
+				0x1f);
+		write_radio_reg(pi,
+				RADIO_2056_SYN_PLL_LOOPFILTER4 | RADIO_2056_SYN,
+				0xb);
+		write_radio_reg(pi, RADIO_2056_SYN_PLL_CP2 | RADIO_2056_SYN,
+				0x20);
+	}
 
-	for (result_idx = 0; result_idx < 4; result_idx++) {
-		fine_digital_offset[result_idx] =
-			(target_code * NPHY_RSSICAL_NPOLL) -
-			poll_results[vcm_final[result_idx]][result_idx];
-		if (fine_digital_offset[result_idx] < 0) {
-			fine_digital_offset[result_idx] =
-				ABS(fine_digital_offset[result_idx]);
-			fine_digital_offset[result_idx] +=
-				(NPHY_RSSICAL_NPOLL / 2);
-			fine_digital_offset[result_idx] /= NPHY_RSSICAL_NPOLL;
-			fine_digital_offset[result_idx] =
-				-fine_digital_offset[result_idx];
-		} else {
-			fine_digital_offset[result_idx] +=
-				(NPHY_RSSICAL_NPOLL / 2);
-			fine_digital_offset[result_idx] /= NPHY_RSSICAL_NPOLL;
+	if (pi->sh->boardflags2 & BFL2_APLL_WAR) {
+		if (CHSPEC_IS5G(pi->radio_chanspec)) {
+			write_radio_reg(pi, RADIO_2056_SYN_PLL_LOOPFILTER1 |
+					RADIO_2056_SYN, 0x1f);
+			write_radio_reg(pi, RADIO_2056_SYN_PLL_LOOPFILTER2 |
+					RADIO_2056_SYN, 0x1f);
+			write_radio_reg(pi, RADIO_2056_SYN_PLL_LOOPFILTER4 |
+					RADIO_2056_SYN, 0x5);
+			write_radio_reg(pi, RADIO_2056_SYN_PLL_CP2 |
+					RADIO_2056_SYN, 0xc);
 		}
-
-		if (poll_results_min[result_idx] ==
-		    NPHY_RSSICAL_MAXREAD * NPHY_RSSICAL_NPOLL)
-			fine_digital_offset[result_idx] =
-				(target_code - NPHY_RSSICAL_MAXREAD - 1);
-
-		wlc_phy_scale_offset_rssi_nphy(pi, 0x0,
-					       (s8)
-					       fine_digital_offset[result_idx],
-					       (result_idx / 2 ==
-						0) ? RADIO_MIMO_CORESEL_CORE1 :
-					       RADIO_MIMO_CORESEL_CORE2,
-					       (result_idx % 2 ==
-						0) ? NPHY_RAIL_I : NPHY_RAIL_Q,
-					       rssi_type);
 	}
 
-	mod_radio_reg(pi, RADIO_2055_PD_CORE1_RSSI_MISC, pd_mask, pd_state[0]);
-	mod_radio_reg(pi, RADIO_2055_PD_CORE2_RSSI_MISC, pd_mask, pd_state[1]);
-	if (rssi_ctrl_state[0] == RADIO_2055_NBRSSI_SEL)
-		wlc_phy_rssisel_nphy(pi, RADIO_MIMO_CORESEL_CORE1,
-				     NPHY_RSSI_SEL_NB);
-	else if (rssi_ctrl_state[0] == RADIO_2055_WBRSSI_G1_SEL)
-		wlc_phy_rssisel_nphy(pi, RADIO_MIMO_CORESEL_CORE1,
-				     NPHY_RSSI_SEL_W1);
-	else if (rssi_ctrl_state[0] == RADIO_2055_WBRSSI_G2_SEL)
-		wlc_phy_rssisel_nphy(pi, RADIO_MIMO_CORESEL_CORE1,
-				     NPHY_RSSI_SEL_W2);
-	else
-		wlc_phy_rssisel_nphy(pi, RADIO_MIMO_CORESEL_CORE1,
-				     NPHY_RSSI_SEL_W2);
-	if (rssi_ctrl_state[1] == RADIO_2055_NBRSSI_SEL)
-		wlc_phy_rssisel_nphy(pi, RADIO_MIMO_CORESEL_CORE2,
-				     NPHY_RSSI_SEL_NB);
-	else if (rssi_ctrl_state[1] == RADIO_2055_WBRSSI_G1_SEL)
-		wlc_phy_rssisel_nphy(pi, RADIO_MIMO_CORESEL_CORE2,
-				     NPHY_RSSI_SEL_W1);
-	else if (rssi_ctrl_state[1] == RADIO_2055_WBRSSI_G2_SEL)
-		wlc_phy_rssisel_nphy(pi, RADIO_MIMO_CORESEL_CORE2,
-				     NPHY_RSSI_SEL_W2);
-	else
-		wlc_phy_rssisel_nphy(pi, RADIO_MIMO_CORESEL_CORE2,
-				     NPHY_RSSI_SEL_W2);
+	if (PHY_IPA(pi) && CHSPEC_IS2G(pi->radio_chanspec)) {
+		u16 pag_boost_tune;
+		u16 padg_boost_tune;
+		u16 pgag_boost_tune;
+		u16 mixg_boost_tune;
+		u16 bias, cascbias;
+		uint core;
 
-	wlc_phy_rssisel_nphy(pi, RADIO_MIMO_CORESEL_OFF, rssi_type);
+		for (core = 0; core < pi->pubpi.phy_corenum; core++) {
 
-	write_phy_reg(pi, 0x91, rfctrlintc_state[0]);
-	write_radio_reg(pi, RADIO_2055_PD_CORE1_RXTX, rfpdcorerxtx_state[0]);
-	write_phy_reg(pi, 0x92, rfctrlintc_state[1]);
-	write_radio_reg(pi, RADIO_2055_PD_CORE2_RXTX, rfpdcorerxtx_state[1]);
+			if (NREV_GE(pi->pubpi.phy_rev, 5)) {
 
-	wlc_phy_classifier_nphy(pi, (0x7 << 0), classif_state);
-	wlc_phy_clip_det_nphy(pi, 1, clip_state);
+				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
+						 PADG_IDAC, 0xcc);
 
-	wlc_phy_resetcca_nphy(pi);
-}
+				bias = 0x25;
+				cascbias = 0x20;
 
-int
-wlc_phy_rssi_compute_nphy(struct brcms_phy *pi, struct brcms_d11rxhdr *wlc_rxh)
-{
-	struct d11rxhdr *rxh = &wlc_rxh->rxhdr;
-	s16 rxpwr, rxpwr0, rxpwr1;
-	s16 phyRx0_l, phyRx2_l;
+				if ((pi->sh->chip ==
+				     BCM43224_CHIP_ID)
+				    || (pi->sh->chip ==
+					BCM43225_CHIP_ID)) {
+					if (pi->sh->chippkg ==
+					    BCM43224_FAB_SMIC) {
+						bias = 0x2a;
+						cascbias = 0x38;
+					}
+				}
 
-	rxpwr = 0;
-	rxpwr0 = le16_to_cpu(rxh->PhyRxStatus_1) & PRXS1_nphy_PWR0_MASK;
-	rxpwr1 = (le16_to_cpu(rxh->PhyRxStatus_1) & PRXS1_nphy_PWR1_MASK) >> 8;
+				pag_boost_tune = 0x4;
+				pgag_boost_tune = 0x03;
+				padg_boost_tune = 0x77;
+				mixg_boost_tune = 0x65;
 
-	if (rxpwr0 > 127)
-		rxpwr0 -= 256;
-	if (rxpwr1 > 127)
-		rxpwr1 -= 256;
+				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
+						 INTPAG_IMAIN_STAT, bias);
+				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
+						 INTPAG_IAUX_STAT, bias);
+				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
+						 INTPAG_CASCBIAS, cascbias);
 
-	phyRx0_l = le16_to_cpu(rxh->PhyRxStatus_0) & 0x00ff;
-	phyRx2_l = le16_to_cpu(rxh->PhyRxStatus_2) & 0x00ff;
-	if (phyRx2_l > 127)
-		phyRx2_l -= 256;
+				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
+						 INTPAG_BOOST_TUNE,
+						 pag_boost_tune);
+				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
+						 PGAG_BOOST_TUNE,
+						 pgag_boost_tune);
+				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
+						 PADG_BOOST_TUNE,
+						 padg_boost_tune);
+				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
+						 MIXG_BOOST_TUNE,
+						 mixg_boost_tune);
+			} else {
 
-	if (((rxpwr0 == 16) || (rxpwr0 == 32))) {
-		rxpwr0 = rxpwr1;
-		rxpwr1 = phyRx2_l;
+				bias = IS40MHZ(pi) ? 0x40 : 0x20;
+
+				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
+						 INTPAG_IMAIN_STAT, bias);
+				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
+						 INTPAG_IAUX_STAT, bias);
+				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
+						 INTPAG_CASCBIAS, 0x30);
+			}
+			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core, PA_SPARE1,
+					 0xee);
+		}
 	}
 
-	wlc_rxh->rxpwr[0] = (s8) rxpwr0;
-	wlc_rxh->rxpwr[1] = (s8) rxpwr1;
-	wlc_rxh->do_rssi_ma = 0;
+	if (PHY_IPA(pi) && NREV_IS(pi->pubpi.phy_rev, 6)
+	    && CHSPEC_IS5G(pi->radio_chanspec)) {
+		u16 paa_boost_tune;
+		u16 pada_boost_tune;
+		u16 pgaa_boost_tune;
+		u16 mixa_boost_tune;
+		u16 freq, pabias, cascbias;
+		uint core;
 
-	if (pi->sh->rssi_mode == RSSI_ANT_MERGE_MAX)
-		rxpwr = (rxpwr0 > rxpwr1) ? rxpwr0 : rxpwr1;
-	else if (pi->sh->rssi_mode == RSSI_ANT_MERGE_MIN)
-		rxpwr = (rxpwr0 < rxpwr1) ? rxpwr0 : rxpwr1;
-	else if (pi->sh->rssi_mode == RSSI_ANT_MERGE_AVG)
-		rxpwr = (rxpwr0 + rxpwr1) >> 1;
+		freq = CHAN5G_FREQ(CHSPEC_CHANNEL(pi->radio_chanspec));
 
-	return rxpwr;
-}
+		if (freq < 5150) {
 
-static void
-wlc_phy_rfctrlintc_override_nphy(struct brcms_phy *pi, u8 field, u16 value,
-				 u8 core_code)
-{
-	u16 mask;
-	u16 val;
-	u8 core;
+			paa_boost_tune = 0xa;
+			pada_boost_tune = 0x77;
+			pgaa_boost_tune = 0xf;
+			mixa_boost_tune = 0xf;
+		} else if (freq < 5340) {
 
-	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-		for (core = 0; core < pi->pubpi.phy_corenum; core++) {
-			if (core_code == RADIO_MIMO_CORESEL_CORE1
-			    && core == PHY_CORE_1)
-				continue;
-			else if (core_code == RADIO_MIMO_CORESEL_CORE2
-				 && core == PHY_CORE_0)
-				continue;
+			paa_boost_tune = 0x8;
+			pada_boost_tune = 0x77;
+			pgaa_boost_tune = 0xfb;
+			mixa_boost_tune = 0xf;
+		} else if (freq < 5650) {
 
-			if (NREV_LT(pi->pubpi.phy_rev, 7)) {
+			paa_boost_tune = 0x0;
+			pada_boost_tune = 0x77;
+			pgaa_boost_tune = 0xb;
+			mixa_boost_tune = 0xf;
+		} else {
 
-				mask = (0x1 << 10);
-				val = 1 << 10;
-				mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x91 :
-					    0x92, mask, val);
-			}
+			paa_boost_tune = 0x0;
+			pada_boost_tune = 0x77;
+			if (freq != 5825)
+				pgaa_boost_tune = -(int)(freq - 18) / 36 + 168;
+			else
+				pgaa_boost_tune = 6;
 
-			if (field == NPHY_RfctrlIntc_override_OFF) {
+			mixa_boost_tune = 0xf;
+		}
 
-				write_phy_reg(pi, (core == PHY_CORE_0) ? 0x91 :
-					      0x92, 0);
+		for (core = 0; core < pi->pubpi.phy_corenum; core++) {
+			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
+					 INTPAA_BOOST_TUNE, paa_boost_tune);
+			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
+					 PADA_BOOST_TUNE, pada_boost_tune);
+			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
+					 PGAA_BOOST_TUNE, pgaa_boost_tune);
+			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
+					 MIXA_BOOST_TUNE, mixa_boost_tune);
+
+			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
+					 TXSPARE1, 0x30);
+			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
+					 PA_SPARE2, 0xee);
+
+			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
+					 PADA_CASCBIAS, 0x3);
 
-				wlc_phy_force_rfseq_nphy(pi,
-							 NPHY_RFSEQ_RESET2RX);
-			} else if (field == NPHY_RfctrlIntc_override_TRSW) {
+			cascbias = 0x30;
 
-				if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+			if ((pi->sh->chip == BCM43224_CHIP_ID) ||
+			    (pi->sh->chip == BCM43225_CHIP_ID)) {
+				if (pi->sh->chippkg == BCM43224_FAB_SMIC)
+					cascbias = 0x35;
+			}
 
-					mask = (0x1 << 6) | (0x1 << 7);
+			pabias = (pi->phy_pabias == 0) ? 0x30 : pi->phy_pabias;
 
-					val = value << 6;
-					mod_phy_reg(pi,
-						    (core ==
-						     PHY_CORE_0) ? 0x91 : 0x92,
-						    mask, val);
+			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
+					 INTPAA_IAUX_STAT, pabias);
+			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
+					 INTPAA_IMAIN_STAT, pabias);
+			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
+					 INTPAA_CASCBIAS, cascbias);
+		}
+	}
 
-					or_phy_reg(pi,
-						   (core ==
-						    PHY_CORE_0) ? 0x91 : 0x92,
-						   (0x1 << 10));
+	udelay(50);
 
-					and_phy_reg(pi, 0x2ff, (u16)
-						    ~(0x3 << 14));
-					or_phy_reg(pi, 0x2ff, (0x1 << 13));
-					or_phy_reg(pi, 0x2ff, (0x1 << 0));
-				} else {
+	wlc_phy_radio205x_vcocal_nphy(pi);
+}
 
-					mask = (0x1 << 6) |
-					       (0x1 << 7) |
-					       (0x1 << 8) | (0x1 << 9);
-					val = value << 6;
-					mod_phy_reg(pi,
-						    (core ==
-						     PHY_CORE_0) ? 0x91 : 0x92,
-						    mask, val);
+void wlc_phy_radio205x_vcocal_nphy(struct brcms_phy *pi)
+{
+	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+		mod_radio_reg(pi, RADIO_2057_RFPLL_MISC_EN, 0x01, 0x0);
+		mod_radio_reg(pi, RADIO_2057_RFPLL_MISC_CAL_RESETN, 0x04, 0x0);
+		mod_radio_reg(pi, RADIO_2057_RFPLL_MISC_CAL_RESETN, 0x04,
+			      (1 << 2));
+		mod_radio_reg(pi, RADIO_2057_RFPLL_MISC_EN, 0x01, 0x01);
+	} else if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+		write_radio_reg(pi, RADIO_2056_SYN_PLL_VCOCAL12, 0x0);
+		write_radio_reg(pi, RADIO_2056_SYN_PLL_MAST3, 0x38);
+		write_radio_reg(pi, RADIO_2056_SYN_PLL_MAST3, 0x18);
+		write_radio_reg(pi, RADIO_2056_SYN_PLL_MAST3, 0x38);
+		write_radio_reg(pi, RADIO_2056_SYN_PLL_MAST3, 0x39);
+	}
 
-					mask = (0x1 << 0);
-					val = 1 << 0;
-					mod_phy_reg(pi,
-						    (core ==
-						     PHY_CORE_0) ? 0xe7 : 0xec,
-						    mask, val);
+	udelay(300);
+}
 
-					mask = (core == PHY_CORE_0) ?
-					       (0x1 << 0) : (0x1 << 1);
-					val = 1 << ((core == PHY_CORE_0) ?
-						    0 : 1);
-					mod_phy_reg(pi, 0x78, mask, val);
+static void
+wlc_phy_chanspec_radio2057_setup(
+	struct brcms_phy *pi,
+	const struct chan_info_nphy_radio2057 *ci,
+	const struct chan_info_nphy_radio2057_rev5 *
+	ci2)
+{
+	int coreNum;
+	u16 txmix2g_tune_boost_pu = 0;
+	u16 pad2g_tune_pus = 0;
 
-					SPINWAIT(((read_phy_reg(pi, 0x78) & val)
-						  != 0), 10000);
-					if (WARN(read_phy_reg(pi, 0x78) & val,
-						 "HW error: override failed"))
-						return;
+	if (pi->pubpi.radiorev == 5) {
 
-					mask = (0x1 << 0);
-					val = 0 << 0;
-					mod_phy_reg(pi,
-						    (core ==
-						     PHY_CORE_0) ? 0xe7 : 0xec,
-						    mask, val);
-				}
-			} else if (field == NPHY_RfctrlIntc_override_PA) {
-				if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+		write_radio_reg(pi,
+				RADIO_2057_VCOCAL_COUNTVAL0,
+				ci2->RF_vcocal_countval0);
+		write_radio_reg(pi, RADIO_2057_VCOCAL_COUNTVAL1,
+				ci2->RF_vcocal_countval1);
+		write_radio_reg(pi, RADIO_2057_RFPLL_REFMASTER_SPAREXTALSIZE,
+				ci2->RF_rfpll_refmaster_sparextalsize);
+		write_radio_reg(pi, RADIO_2057_RFPLL_LOOPFILTER_R1,
+				ci2->RF_rfpll_loopfilter_r1);
+		write_radio_reg(pi, RADIO_2057_RFPLL_LOOPFILTER_C2,
+				ci2->RF_rfpll_loopfilter_c2);
+		write_radio_reg(pi, RADIO_2057_RFPLL_LOOPFILTER_C1,
+				ci2->RF_rfpll_loopfilter_c1);
+		write_radio_reg(pi, RADIO_2057_CP_KPD_IDAC,
+				ci2->RF_cp_kpd_idac);
+		write_radio_reg(pi, RADIO_2057_RFPLL_MMD0, ci2->RF_rfpll_mmd0);
+		write_radio_reg(pi, RADIO_2057_RFPLL_MMD1, ci2->RF_rfpll_mmd1);
+		write_radio_reg(pi,
+				RADIO_2057_VCOBUF_TUNE, ci2->RF_vcobuf_tune);
+		write_radio_reg(pi,
+				RADIO_2057_LOGEN_MX2G_TUNE,
+				ci2->RF_logen_mx2g_tune);
+		write_radio_reg(pi, RADIO_2057_LOGEN_INDBUF2G_TUNE,
+				ci2->RF_logen_indbuf2g_tune);
 
-					mask = (0x1 << 4) | (0x1 << 5);
+		write_radio_reg(pi,
+				RADIO_2057_TXMIX2G_TUNE_BOOST_PU_CORE0,
+				ci2->RF_txmix2g_tune_boost_pu_core0);
+		write_radio_reg(pi,
+				RADIO_2057_PAD2G_TUNE_PUS_CORE0,
+				ci2->RF_pad2g_tune_pus_core0);
+		write_radio_reg(pi, RADIO_2057_LNA2G_TUNE_CORE0,
+				ci2->RF_lna2g_tune_core0);
 
-					if (CHSPEC_IS5G(pi->radio_chanspec))
-						val = value << 5;
-					else
-						val = value << 4;
+		write_radio_reg(pi,
+				RADIO_2057_TXMIX2G_TUNE_BOOST_PU_CORE1,
+				ci2->RF_txmix2g_tune_boost_pu_core1);
+		write_radio_reg(pi,
+				RADIO_2057_PAD2G_TUNE_PUS_CORE1,
+				ci2->RF_pad2g_tune_pus_core1);
+		write_radio_reg(pi, RADIO_2057_LNA2G_TUNE_CORE1,
+				ci2->RF_lna2g_tune_core1);
 
-					mod_phy_reg(pi,
-						    (core ==
-						     PHY_CORE_0) ? 0x91 : 0x92,
-						    mask, val);
+	} else {
 
-					or_phy_reg(pi,
-						   (core ==
-						    PHY_CORE_0) ? 0x91 : 0x92,
-						   (0x1 << 12));
-				} else {
+		write_radio_reg(pi,
+				RADIO_2057_VCOCAL_COUNTVAL0,
+				ci->RF_vcocal_countval0);
+		write_radio_reg(pi, RADIO_2057_VCOCAL_COUNTVAL1,
+				ci->RF_vcocal_countval1);
+		write_radio_reg(pi, RADIO_2057_RFPLL_REFMASTER_SPAREXTALSIZE,
+				ci->RF_rfpll_refmaster_sparextalsize);
+		write_radio_reg(pi, RADIO_2057_RFPLL_LOOPFILTER_R1,
+				ci->RF_rfpll_loopfilter_r1);
+		write_radio_reg(pi, RADIO_2057_RFPLL_LOOPFILTER_C2,
+				ci->RF_rfpll_loopfilter_c2);
+		write_radio_reg(pi, RADIO_2057_RFPLL_LOOPFILTER_C1,
+				ci->RF_rfpll_loopfilter_c1);
+		write_radio_reg(pi, RADIO_2057_CP_KPD_IDAC, ci->RF_cp_kpd_idac);
+		write_radio_reg(pi, RADIO_2057_RFPLL_MMD0, ci->RF_rfpll_mmd0);
+		write_radio_reg(pi, RADIO_2057_RFPLL_MMD1, ci->RF_rfpll_mmd1);
+		write_radio_reg(pi, RADIO_2057_VCOBUF_TUNE, ci->RF_vcobuf_tune);
+		write_radio_reg(pi,
+				RADIO_2057_LOGEN_MX2G_TUNE,
+				ci->RF_logen_mx2g_tune);
+		write_radio_reg(pi, RADIO_2057_LOGEN_MX5G_TUNE,
+				ci->RF_logen_mx5g_tune);
+		write_radio_reg(pi, RADIO_2057_LOGEN_INDBUF2G_TUNE,
+				ci->RF_logen_indbuf2g_tune);
+		write_radio_reg(pi, RADIO_2057_LOGEN_INDBUF5G_TUNE,
+				ci->RF_logen_indbuf5g_tune);
 
-					if (CHSPEC_IS5G(pi->radio_chanspec)) {
-						mask = (0x1 << 5);
-						val = value << 5;
-					} else {
-						mask = (0x1 << 4);
-						val = value << 4;
-					}
-					mod_phy_reg(pi,
-						    (core ==
-						     PHY_CORE_0) ? 0x91 : 0x92,
-						    mask, val);
-				}
-			} else if (field ==
-				   NPHY_RfctrlIntc_override_EXT_LNA_PU) {
-				if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-					if (CHSPEC_IS5G(pi->radio_chanspec)) {
+		write_radio_reg(pi,
+				RADIO_2057_TXMIX2G_TUNE_BOOST_PU_CORE0,
+				ci->RF_txmix2g_tune_boost_pu_core0);
+		write_radio_reg(pi,
+				RADIO_2057_PAD2G_TUNE_PUS_CORE0,
+				ci->RF_pad2g_tune_pus_core0);
+		write_radio_reg(pi, RADIO_2057_PGA_BOOST_TUNE_CORE0,
+				ci->RF_pga_boost_tune_core0);
+		write_radio_reg(pi, RADIO_2057_TXMIX5G_BOOST_TUNE_CORE0,
+				ci->RF_txmix5g_boost_tune_core0);
+		write_radio_reg(pi, RADIO_2057_PAD5G_TUNE_MISC_PUS_CORE0,
+				ci->RF_pad5g_tune_misc_pus_core0);
+		write_radio_reg(pi, RADIO_2057_LNA2G_TUNE_CORE0,
+				ci->RF_lna2g_tune_core0);
+		write_radio_reg(pi, RADIO_2057_LNA5G_TUNE_CORE0,
+				ci->RF_lna5g_tune_core0);
 
-						mask = (0x1 << 0);
-						val = value << 0;
-						mod_phy_reg(pi,
-							    (core ==
-							     PHY_CORE_0) ? 0x91
-							    : 0x92, mask, val);
+		write_radio_reg(pi,
+				RADIO_2057_TXMIX2G_TUNE_BOOST_PU_CORE1,
+				ci->RF_txmix2g_tune_boost_pu_core1);
+		write_radio_reg(pi,
+				RADIO_2057_PAD2G_TUNE_PUS_CORE1,
+				ci->RF_pad2g_tune_pus_core1);
+		write_radio_reg(pi, RADIO_2057_PGA_BOOST_TUNE_CORE1,
+				ci->RF_pga_boost_tune_core1);
+		write_radio_reg(pi, RADIO_2057_TXMIX5G_BOOST_TUNE_CORE1,
+				ci->RF_txmix5g_boost_tune_core1);
+		write_radio_reg(pi, RADIO_2057_PAD5G_TUNE_MISC_PUS_CORE1,
+				ci->RF_pad5g_tune_misc_pus_core1);
+		write_radio_reg(pi, RADIO_2057_LNA2G_TUNE_CORE1,
+				ci->RF_lna2g_tune_core1);
+		write_radio_reg(pi, RADIO_2057_LNA5G_TUNE_CORE1,
+				ci->RF_lna5g_tune_core1);
+	}
 
-						mask = (0x1 << 2);
-						mod_phy_reg(pi,
-							    (core ==
-							     PHY_CORE_0) ? 0x91
-							    : 0x92, mask, 0);
-					} else {
+	if ((pi->pubpi.radiorev <= 4) || (pi->pubpi.radiorev == 6)) {
 
-						mask = (0x1 << 2);
-						val = value << 2;
-						mod_phy_reg(pi,
-							    (core ==
-							     PHY_CORE_0) ? 0x91
-							    : 0x92, mask, val);
+		if (CHSPEC_IS2G(pi->radio_chanspec)) {
+			write_radio_reg(pi, RADIO_2057_RFPLL_LOOPFILTER_R1,
+					0x3f);
+			write_radio_reg(pi, RADIO_2057_CP_KPD_IDAC, 0x3f);
+			write_radio_reg(pi, RADIO_2057_RFPLL_LOOPFILTER_C1,
+					0x8);
+			write_radio_reg(pi, RADIO_2057_RFPLL_LOOPFILTER_C2,
+					0x8);
+		} else {
+			write_radio_reg(pi, RADIO_2057_RFPLL_LOOPFILTER_R1,
+					0x1f);
+			write_radio_reg(pi, RADIO_2057_CP_KPD_IDAC, 0x3f);
+			write_radio_reg(pi, RADIO_2057_RFPLL_LOOPFILTER_C1,
+					0x8);
+			write_radio_reg(pi, RADIO_2057_RFPLL_LOOPFILTER_C2,
+					0x8);
+		}
+	} else if ((pi->pubpi.radiorev == 5) || (pi->pubpi.radiorev == 7) ||
+		   (pi->pubpi.radiorev == 8)) {
 
-						mask = (0x1 << 0);
-						mod_phy_reg(pi,
-							    (core ==
-							     PHY_CORE_0) ? 0x91
-							    : 0x92, mask, 0);
-					}
+		if (CHSPEC_IS2G(pi->radio_chanspec)) {
+			write_radio_reg(pi, RADIO_2057_RFPLL_LOOPFILTER_R1,
+					0x1b);
+			write_radio_reg(pi, RADIO_2057_CP_KPD_IDAC, 0x30);
+			write_radio_reg(pi, RADIO_2057_RFPLL_LOOPFILTER_C1,
+					0xa);
+			write_radio_reg(pi, RADIO_2057_RFPLL_LOOPFILTER_C2,
+					0xa);
+		} else {
+			write_radio_reg(pi, RADIO_2057_RFPLL_LOOPFILTER_R1,
+					0x1f);
+			write_radio_reg(pi, RADIO_2057_CP_KPD_IDAC, 0x3f);
+			write_radio_reg(pi, RADIO_2057_RFPLL_LOOPFILTER_C1,
+					0x8);
+			write_radio_reg(pi, RADIO_2057_RFPLL_LOOPFILTER_C2,
+					0x8);
+		}
 
-					mask = (0x1 << 11);
-					val = 1 << 11;
-					mod_phy_reg(pi,
-						    (core ==
-						     PHY_CORE_0) ? 0x91 : 0x92,
-						    mask, val);
-				} else {
+	}
 
-					if (CHSPEC_IS5G(pi->radio_chanspec)) {
-						mask = (0x1 << 0);
-						val = value << 0;
-					} else {
-						mask = (0x1 << 2);
-						val = value << 2;
-					}
-					mod_phy_reg(pi,
-						    (core ==
-						     PHY_CORE_0) ? 0x91 : 0x92,
-						    mask, val);
-				}
-			} else if (field ==
-				   NPHY_RfctrlIntc_override_EXT_LNA_GAIN) {
-				if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-					if (CHSPEC_IS5G(pi->radio_chanspec)) {
+	if (CHSPEC_IS2G(pi->radio_chanspec)) {
+		if (PHY_IPA(pi)) {
+			if (pi->pubpi.radiorev == 3)
+				txmix2g_tune_boost_pu = 0x6b;
 
-						mask = (0x1 << 1);
-						val = value << 1;
-						mod_phy_reg(pi,
-							    (core ==
-							     PHY_CORE_0) ? 0x91
-							    : 0x92, mask, val);
+			if (pi->pubpi.radiorev == 5)
+				pad2g_tune_pus = 0x73;
 
-						mask = (0x1 << 3);
-						mod_phy_reg(pi,
-							    (core ==
-							     PHY_CORE_0) ? 0x91
-							    : 0x92, mask, 0);
-					} else {
+		} else {
+			if (pi->pubpi.radiorev != 5) {
+				pad2g_tune_pus = 0x3;
 
-						mask = (0x1 << 3);
-						val = value << 3;
-						mod_phy_reg(pi,
-							    (core ==
-							     PHY_CORE_0) ? 0x91
-							    : 0x92, mask, val);
+				txmix2g_tune_boost_pu = 0x61;
+			}
+		}
 
-						mask = (0x1 << 1);
-						mod_phy_reg(pi,
-							    (core ==
-							     PHY_CORE_0) ? 0x91
-							    : 0x92, mask, 0);
-					}
+		for (coreNum = 0; coreNum <= 1; coreNum++) {
 
-					mask = (0x1 << 11);
-					val = 1 << 11;
-					mod_phy_reg(pi,
-						    (core ==
-						     PHY_CORE_0) ? 0x91 : 0x92,
-						    mask, val);
-				} else {
+			if (txmix2g_tune_boost_pu != 0)
+				WRITE_RADIO_REG4(pi, RADIO_2057, CORE, coreNum,
+						 TXMIX2G_TUNE_BOOST_PU,
+						 txmix2g_tune_boost_pu);
 
-					if (CHSPEC_IS5G(pi->radio_chanspec)) {
-						mask = (0x1 << 1);
-						val = value << 1;
-					} else {
-						mask = (0x1 << 3);
-						val = value << 3;
-					}
-					mod_phy_reg(pi,
-						    (core ==
-						     PHY_CORE_0) ? 0x91 : 0x92,
-						    mask, val);
-				}
-			}
+			if (pad2g_tune_pus != 0)
+				WRITE_RADIO_REG4(pi, RADIO_2057, CORE, coreNum,
+						 PAD2G_TUNE_PUS,
+						 pad2g_tune_pus);
 		}
 	}
+
+	udelay(50);
+
+	wlc_phy_radio205x_vcocal_nphy(pi);
 }
 
-static void wlc_phy_rssi_cal_nphy_rev3(struct brcms_phy *pi)
+static void
+wlc_phy_chanspec_nphy_setup(struct brcms_phy *pi, u16 chanspec,
+			    const struct nphy_sfo_cfg *ci)
 {
-	u16 classif_state;
-	u16 clip_state[2];
-	u16 clip_off[] = { 0xffff, 0xffff };
-	s32 target_code;
-	u8 vcm, min_vcm;
-	u8 vcm_final = 0;
-	u8 result_idx;
-	s32 poll_results[8][4] = {
-		{0, 0, 0, 0},
-		{0, 0, 0, 0},
-		{0, 0, 0, 0},
-		{0, 0, 0, 0},
-		{0, 0, 0, 0},
-		{0, 0, 0, 0},
-		{0, 0, 0, 0},
-		{0, 0, 0, 0}
-	};
-	s32 poll_result_core[4] = { 0, 0, 0, 0 };
-	s32 min_d = NPHY_RSSICAL_MAXD, curr_d;
-	s32 fine_digital_offset[4];
-	s32 poll_results_min[4] = { 0, 0, 0, 0 };
-	s32 min_poll;
-	u8 vcm_level_max;
-	u8 core;
-	u8 wb_cnt;
-	u8 rssi_type;
-	u16 NPHY_Rfctrlintc1_save, NPHY_Rfctrlintc2_save;
-	u16 NPHY_AfectrlOverride1_save, NPHY_AfectrlOverride2_save;
-	u16 NPHY_AfectrlCore1_save, NPHY_AfectrlCore2_save;
-	u16 NPHY_RfctrlOverride0_save, NPHY_RfctrlOverride1_save;
-	u16 NPHY_RfctrlOverrideAux0_save, NPHY_RfctrlOverrideAux1_save;
-	u16 NPHY_RfctrlCmd_save;
-	u16 NPHY_RfctrlMiscReg1_save, NPHY_RfctrlMiscReg2_save;
-	u16 NPHY_RfctrlRSSIOTHERS1_save, NPHY_RfctrlRSSIOTHERS2_save;
-	u8 rxcore_state;
-	u16 NPHY_REV7_RfctrlOverride3_save, NPHY_REV7_RfctrlOverride4_save;
-	u16 NPHY_REV7_RfctrlOverride5_save, NPHY_REV7_RfctrlOverride6_save;
-	u16 NPHY_REV7_RfctrlMiscReg3_save, NPHY_REV7_RfctrlMiscReg4_save;
-	u16 NPHY_REV7_RfctrlMiscReg5_save, NPHY_REV7_RfctrlMiscReg6_save;
+	u16 val;
 
-	NPHY_REV7_RfctrlOverride3_save =
-		NPHY_REV7_RfctrlOverride4_save =
-		NPHY_REV7_RfctrlOverride5_save =
-		NPHY_REV7_RfctrlOverride6_save =
-		NPHY_REV7_RfctrlMiscReg3_save =
-		NPHY_REV7_RfctrlMiscReg4_save =
-		NPHY_REV7_RfctrlMiscReg5_save =
-		NPHY_REV7_RfctrlMiscReg6_save = 0;
+	val = read_phy_reg(pi, 0x09) & NPHY_BandControl_currentBand;
+	if (CHSPEC_IS5G(chanspec) && !val) {
 
-	classif_state = wlc_phy_classifier_nphy(pi, 0, 0);
-	wlc_phy_classifier_nphy(pi, (0x7 << 0), 4);
-	wlc_phy_clip_det_nphy(pi, 0, clip_state);
-	wlc_phy_clip_det_nphy(pi, 1, clip_off);
+		val = R_REG(&pi->regs->psm_phy_hdr_param);
+		W_REG(&pi->regs->psm_phy_hdr_param,
+		      (val | MAC_PHY_FORCE_CLK));
 
-	NPHY_Rfctrlintc1_save = read_phy_reg(pi, 0x91);
-	NPHY_Rfctrlintc2_save = read_phy_reg(pi, 0x92);
-	NPHY_AfectrlOverride1_save = read_phy_reg(pi, 0x8f);
-	NPHY_AfectrlOverride2_save = read_phy_reg(pi, 0xa5);
-	NPHY_AfectrlCore1_save = read_phy_reg(pi, 0xa6);
-	NPHY_AfectrlCore2_save = read_phy_reg(pi, 0xa7);
-	NPHY_RfctrlOverride0_save = read_phy_reg(pi, 0xe7);
-	NPHY_RfctrlOverride1_save = read_phy_reg(pi, 0xec);
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-		NPHY_REV7_RfctrlOverride3_save = read_phy_reg(pi, 0x342);
-		NPHY_REV7_RfctrlOverride4_save = read_phy_reg(pi, 0x343);
-		NPHY_REV7_RfctrlOverride5_save = read_phy_reg(pi, 0x346);
-		NPHY_REV7_RfctrlOverride6_save = read_phy_reg(pi, 0x347);
-	}
-	NPHY_RfctrlOverrideAux0_save = read_phy_reg(pi, 0xe5);
-	NPHY_RfctrlOverrideAux1_save = read_phy_reg(pi, 0xe6);
-	NPHY_RfctrlCmd_save = read_phy_reg(pi, 0x78);
-	NPHY_RfctrlMiscReg1_save = read_phy_reg(pi, 0xf9);
-	NPHY_RfctrlMiscReg2_save = read_phy_reg(pi, 0xfb);
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-		NPHY_REV7_RfctrlMiscReg3_save = read_phy_reg(pi, 0x340);
-		NPHY_REV7_RfctrlMiscReg4_save = read_phy_reg(pi, 0x341);
-		NPHY_REV7_RfctrlMiscReg5_save = read_phy_reg(pi, 0x344);
-		NPHY_REV7_RfctrlMiscReg6_save = read_phy_reg(pi, 0x345);
-	}
-	NPHY_RfctrlRSSIOTHERS1_save = read_phy_reg(pi, 0x7a);
-	NPHY_RfctrlRSSIOTHERS2_save = read_phy_reg(pi, 0x7d);
+		or_phy_reg(pi, (NPHY_TO_BPHY_OFF + BPHY_BB_CONFIG),
+			   (BBCFG_RESETCCA | BBCFG_RESETRX));
 
-	wlc_phy_rfctrlintc_override_nphy(pi, NPHY_RfctrlIntc_override_OFF, 0,
-					 RADIO_MIMO_CORESEL_ALLRXTX);
-	wlc_phy_rfctrlintc_override_nphy(pi, NPHY_RfctrlIntc_override_TRSW, 1,
-					 RADIO_MIMO_CORESEL_ALLRXTX);
+		W_REG(&pi->regs->psm_phy_hdr_param, val);
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7))
-		wlc_phy_rfctrl_override_1tomany_nphy(
-			pi,
-			NPHY_REV7_RfctrlOverride_cmd_rxrf_pu,
-			0, 0, 0);
-	else
-		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 0), 0, 0, 0);
+		or_phy_reg(pi, 0x09, NPHY_BandControl_currentBand);
+	} else if (!CHSPEC_IS5G(chanspec) && val) {
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7))
-		wlc_phy_rfctrl_override_1tomany_nphy(
-			pi,
-			NPHY_REV7_RfctrlOverride_cmd_rx_pu,
-			1, 0, 0);
-	else
-		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 1), 1, 0, 0);
+		and_phy_reg(pi, 0x09, ~NPHY_BandControl_currentBand);
+
+		val = R_REG(&pi->regs->psm_phy_hdr_param);
+		W_REG(&pi->regs->psm_phy_hdr_param,
+		      (val | MAC_PHY_FORCE_CLK));
+
+		and_phy_reg(pi, (NPHY_TO_BPHY_OFF + BPHY_BB_CONFIG),
+			    (u16) (~(BBCFG_RESETCCA | BBCFG_RESETRX)));
+
+		W_REG(&pi->regs->psm_phy_hdr_param, val);
+	}
+
+	write_phy_reg(pi, 0x1ce, ci->PHY_BW1a);
+	write_phy_reg(pi, 0x1cf, ci->PHY_BW2);
+	write_phy_reg(pi, 0x1d0, ci->PHY_BW3);
+
+	write_phy_reg(pi, 0x1d1, ci->PHY_BW4);
+	write_phy_reg(pi, 0x1d2, ci->PHY_BW5);
+	write_phy_reg(pi, 0x1d3, ci->PHY_BW6);
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 7),
-						  1, 0, 0,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID0);
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 6), 1, 0, 0,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID0);
+	if (CHSPEC_CHANNEL(pi->radio_chanspec) == 14) {
+		wlc_phy_classifier_nphy(pi, NPHY_ClassifierCtrl_ofdm_en, 0);
+
+		or_phy_reg(pi, NPHY_TO_BPHY_OFF + BPHY_TEST, 0x800);
 	} else {
-		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 7), 1, 0, 0);
-		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 6), 1, 0, 0);
+		wlc_phy_classifier_nphy(pi, NPHY_ClassifierCtrl_ofdm_en,
+					NPHY_ClassifierCtrl_ofdm_en);
+
+		if (CHSPEC_IS2G(chanspec))
+			and_phy_reg(pi, NPHY_TO_BPHY_OFF + BPHY_TEST, ~0x840);
 	}
 
-	if (CHSPEC_IS5G(pi->radio_chanspec)) {
-		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-			wlc_phy_rfctrl_override_nphy_rev7(
-				pi, (0x1 << 5),
-				0, 0, 0,
-				NPHY_REV7_RFCTRLOVERRIDE_ID0);
-			wlc_phy_rfctrl_override_nphy_rev7(
-				pi, (0x1 << 4), 1, 0,
-				0,
-				NPHY_REV7_RFCTRLOVERRIDE_ID0);
+	if (pi->nphy_txpwrctrl == PHY_TPC_HW_OFF)
+		wlc_phy_txpwr_fixpower_nphy(pi);
+
+	if (NREV_LT(pi->pubpi.phy_rev, 3))
+		wlc_phy_adjust_lnagaintbl_nphy(pi);
+
+	wlc_phy_txlpfbw_nphy(pi);
+
+	if (NREV_GE(pi->pubpi.phy_rev, 3)
+	    && (pi->phy_spuravoid != SPURAVOID_DISABLE)) {
+		u8 spuravoid = 0;
+
+		val = CHSPEC_CHANNEL(chanspec);
+		if (!CHSPEC_IS40(pi->radio_chanspec)) {
+			if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+				if ((val == 13) || (val == 14) || (val == 153))
+					spuravoid = 1;
+			} else if (((val >= 5) && (val <= 8)) || (val == 13)
+				   || (val == 14)) {
+				spuravoid = 1;
+			}
+		} else if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+			if (val == 54)
+				spuravoid = 1;
 		} else {
-			wlc_phy_rfctrl_override_nphy(pi, (0x1 << 5), 0, 0, 0);
-			wlc_phy_rfctrl_override_nphy(pi, (0x1 << 4), 1, 0, 0);
+			if (pi->nphy_aband_spurwar_en &&
+			    ((val == 38) || (val == 102)
+			     || (val == 118)))
+				spuravoid = 1;
 		}
 
-	} else {
-		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-			wlc_phy_rfctrl_override_nphy_rev7(
-				pi, (0x1 << 4),
-				0, 0, 0,
-				NPHY_REV7_RFCTRLOVERRIDE_ID0);
-			wlc_phy_rfctrl_override_nphy_rev7(
-				pi, (0x1 << 5), 1, 0,
-				0,
-				NPHY_REV7_RFCTRLOVERRIDE_ID0);
-		} else {
-			wlc_phy_rfctrl_override_nphy(pi, (0x1 << 4), 0, 0, 0);
-			wlc_phy_rfctrl_override_nphy(pi, (0x1 << 5), 1, 0, 0);
+		if (pi->phy_spuravoid == SPURAVOID_FORCEON)
+			spuravoid = 1;
+
+		wlapi_bmac_core_phypll_ctl(pi->sh->physhim, false);
+		si_pmu_spuravoid(pi->sh->sih, spuravoid);
+		wlapi_bmac_core_phypll_ctl(pi->sh->physhim, true);
+
+		if ((pi->sh->chip == BCM43224_CHIP_ID) ||
+		    (pi->sh->chip == BCM43225_CHIP_ID)) {
+
+			if (spuravoid == 1) {
+
+				W_REG(&pi->regs->tsf_clk_frac_l,
+				      0x5341);
+				W_REG(&pi->regs->tsf_clk_frac_h,
+				      0x8);
+			} else {
+
+				W_REG(&pi->regs->tsf_clk_frac_l,
+				      0x8889);
+				W_REG(&pi->regs->tsf_clk_frac_h,
+				      0x8);
+			}
 		}
+
+		wlapi_bmac_core_phypll_reset(pi->sh->physhim);
+
+		mod_phy_reg(pi, 0x01, (0x1 << 15),
+			    ((spuravoid > 0) ? (0x1 << 15) : 0));
+
+		wlc_phy_resetcca_nphy(pi);
+
+		pi->phy_isspuravoid = (spuravoid > 0);
 	}
 
-	rxcore_state = wlc_phy_rxcore_getstate_nphy(
-		(struct brcms_phy_pub *) pi);
+	if (NREV_LT(pi->pubpi.phy_rev, 7))
+		write_phy_reg(pi, 0x17e, 0x3830);
 
-	vcm_level_max = 8;
+	wlc_phy_spurwar_nphy(pi);
+}
 
-	for (core = 0; core < pi->pubpi.phy_corenum; core++) {
+void wlc_phy_chanspec_set_nphy(struct brcms_phy *pi, u16 chanspec)
+{
+	int freq;
+	struct chan_info_nphy_radio2057 *t0 = NULL;
+	struct chan_info_nphy_radio205x *t1 = NULL;
+	struct chan_info_nphy_radio2057_rev5 *t2 = NULL;
+	struct chan_info_nphy_2055 *t3 = NULL;
 
-		if ((rxcore_state & (1 << core)) == 0)
-			continue;
+	if (!wlc_phy_chan2freq_nphy
+		    (pi, CHSPEC_CHANNEL(chanspec), &freq, &t0, &t1, &t2, &t3))
+		return;
 
-		wlc_phy_scale_offset_rssi_nphy(pi, 0x0, 0x0,
-					       core ==
-					       PHY_CORE_0 ?
-					       RADIO_MIMO_CORESEL_CORE1 :
-					       RADIO_MIMO_CORESEL_CORE2,
-					       NPHY_RAIL_I, NPHY_RSSI_SEL_NB);
-		wlc_phy_scale_offset_rssi_nphy(pi, 0x0, 0x0,
-					       core ==
-					       PHY_CORE_0 ?
-					       RADIO_MIMO_CORESEL_CORE1 :
-					       RADIO_MIMO_CORESEL_CORE2,
-					       NPHY_RAIL_Q, NPHY_RSSI_SEL_NB);
+	wlc_phy_chanspec_radio_set((struct brcms_phy_pub *) pi, chanspec);
 
-		for (vcm = 0; vcm < vcm_level_max; vcm++) {
-			if (NREV_GE(pi->pubpi.phy_rev, 7))
-				mod_radio_reg(pi, (core == PHY_CORE_0) ?
-					      RADIO_2057_NB_MASTER_CORE0 :
-					      RADIO_2057_NB_MASTER_CORE1,
-					      RADIO_2057_VCM_MASK, vcm);
-			else
-				mod_radio_reg(pi, RADIO_2056_RX_RSSI_MISC |
-					      ((core ==
-						PHY_CORE_0) ? RADIO_2056_RX0 :
-					       RADIO_2056_RX1),
-					      RADIO_2056_VCM_MASK,
-					      vcm << RADIO_2056_RSSI_VCM_SHIFT);
+	if (CHSPEC_BW(chanspec) != pi->bw)
+		wlapi_bmac_bw_set(pi->sh->physhim, CHSPEC_BW(chanspec));
 
-			wlc_phy_poll_rssi_nphy(pi, NPHY_RSSI_SEL_NB,
-					       &poll_results[vcm][0],
-					       NPHY_RSSICAL_NPOLL);
+	if (CHSPEC_IS40(chanspec)) {
+		if (CHSPEC_SB_UPPER(chanspec)) {
+			or_phy_reg(pi, 0xa0, BPHY_BAND_SEL_UP20);
+			if (NREV_GE(pi->pubpi.phy_rev, 7))
+				or_phy_reg(pi, 0x310, PRIM_SEL_UP20);
+		} else {
+			and_phy_reg(pi, 0xa0, ~BPHY_BAND_SEL_UP20);
+			if (NREV_GE(pi->pubpi.phy_rev, 7))
+				and_phy_reg(pi, 0x310,
+					    (~PRIM_SEL_UP20 & 0xffff));
 		}
+	}
 
-		for (result_idx = 0; result_idx < 4; result_idx++) {
-			if ((core == result_idx / 2) &&
-			    (result_idx % 2 == 0)) {
+	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 
-				min_d = NPHY_RSSICAL_MAXD;
-				min_vcm = 0;
-				min_poll =
-					NPHY_RSSICAL_MAXREAD *
-					NPHY_RSSICAL_NPOLL + 1;
-				for (vcm = 0; vcm < vcm_level_max; vcm++) {
-					curr_d =
-						poll_results[vcm][result_idx] *
-						poll_results[vcm][result_idx] +
-						poll_results[vcm][result_idx +
-								  1] *
-						poll_results[vcm][result_idx +
-								  1];
-					if (curr_d < min_d) {
-						min_d = curr_d;
-						min_vcm = vcm;
-					}
-					if (poll_results[vcm][result_idx] <
-					    min_poll)
-						min_poll =
-							poll_results[vcm]
-							[result_idx];
-				}
-				vcm_final = min_vcm;
-				poll_results_min[result_idx] = min_poll;
+			if ((pi->pubpi.radiorev <= 4)
+			    || (pi->pubpi.radiorev == 6)) {
+				mod_radio_reg(pi, RADIO_2057_TIA_CONFIG_CORE0,
+					      0x2,
+					      (CHSPEC_IS5G(chanspec) ? (1 << 1)
+					       : 0));
+				mod_radio_reg(pi, RADIO_2057_TIA_CONFIG_CORE1,
+					      0x2,
+					      (CHSPEC_IS5G(chanspec) ? (1 << 1)
+					       : 0));
 			}
-		}
 
-		if (NREV_GE(pi->pubpi.phy_rev, 7))
-			mod_radio_reg(pi, (core == PHY_CORE_0) ?
-				      RADIO_2057_NB_MASTER_CORE0 :
-				      RADIO_2057_NB_MASTER_CORE1,
-				      RADIO_2057_VCM_MASK, vcm_final);
-		else
-			mod_radio_reg(pi, RADIO_2056_RX_RSSI_MISC |
-				      ((core ==
-					PHY_CORE_0) ? RADIO_2056_RX0 :
-				       RADIO_2056_RX1), RADIO_2056_VCM_MASK,
-				      vcm_final << RADIO_2056_RSSI_VCM_SHIFT);
+			wlc_phy_chanspec_radio2057_setup(pi, t0, t2);
+			wlc_phy_chanspec_nphy_setup(pi, chanspec,
+				(pi->pubpi.radiorev == 5) ?
+				(const struct nphy_sfo_cfg *)&(t2->PHY_BW1a) :
+				(const struct nphy_sfo_cfg *)&(t0->PHY_BW1a));
 
-		for (result_idx = 0; result_idx < 4; result_idx++) {
-			if (core == result_idx / 2) {
-				fine_digital_offset[result_idx] =
-					(NPHY_RSSICAL_NB_TARGET *
-					 NPHY_RSSICAL_NPOLL) -
-					poll_results[vcm_final][result_idx];
-				if (fine_digital_offset[result_idx] < 0) {
-					fine_digital_offset[result_idx] =
-						ABS(fine_digital_offset
-						    [result_idx]);
-					fine_digital_offset[result_idx] +=
-						(NPHY_RSSICAL_NPOLL / 2);
-					fine_digital_offset[result_idx] /=
-						NPHY_RSSICAL_NPOLL;
-					fine_digital_offset[result_idx] =
-						-fine_digital_offset[
-								    result_idx];
-				} else {
-					fine_digital_offset[result_idx] +=
-						(NPHY_RSSICAL_NPOLL / 2);
-					fine_digital_offset[result_idx] /=
-						NPHY_RSSICAL_NPOLL;
-				}
+		} else {
 
-				if (poll_results_min[result_idx] ==
-				    NPHY_RSSICAL_MAXREAD * NPHY_RSSICAL_NPOLL)
-					fine_digital_offset[result_idx] =
-						(NPHY_RSSICAL_NB_TARGET -
-						 NPHY_RSSICAL_MAXREAD - 1);
+			mod_radio_reg(pi,
+				      RADIO_2056_SYN_COM_CTRL | RADIO_2056_SYN,
+				      0x4,
+				      (CHSPEC_IS5G(chanspec) ? (0x1 << 2) : 0));
+			wlc_phy_chanspec_radio2056_setup(pi, t1);
 
-				wlc_phy_scale_offset_rssi_nphy(
-					pi, 0x0,
-					(s8)
-					fine_digital_offset
-					[result_idx],
-					(result_idx / 2 == 0) ?
-					RADIO_MIMO_CORESEL_CORE1 :
-					RADIO_MIMO_CORESEL_CORE2,
-					(result_idx % 2 == 0) ?
-					NPHY_RAIL_I : NPHY_RAIL_Q,
-					NPHY_RSSI_SEL_NB);
-			}
+			wlc_phy_chanspec_nphy_setup(pi, chanspec,
+				(const struct nphy_sfo_cfg *) &(t1->PHY_BW1a));
 		}
 
-	}
+	} else {
 
-	for (core = 0; core < pi->pubpi.phy_corenum; core++) {
+		mod_radio_reg(pi, RADIO_2055_MASTER_CNTRL1, 0x70,
+			      (CHSPEC_IS5G(chanspec) ? (0x02 << 4)
+			       : (0x05 << 4)));
 
-		if ((rxcore_state & (1 << core)) == 0)
-			continue;
+		wlc_phy_chanspec_radio2055_setup(pi, t3);
+		wlc_phy_chanspec_nphy_setup(pi, chanspec,
+					    (const struct nphy_sfo_cfg *)
+					     &(t3->PHY_BW1a));
+	}
 
-		for (wb_cnt = 0; wb_cnt < 2; wb_cnt++) {
-			if (wb_cnt == 0) {
-				rssi_type = NPHY_RSSI_SEL_W1;
-				target_code = NPHY_RSSICAL_W1_TARGET_REV3;
-			} else {
-				rssi_type = NPHY_RSSI_SEL_W2;
-				target_code = NPHY_RSSICAL_W2_TARGET_REV3;
-			}
+}
 
-			wlc_phy_scale_offset_rssi_nphy(pi, 0x0, 0x0,
-						       core ==
-						       PHY_CORE_0 ?
-						       RADIO_MIMO_CORESEL_CORE1
-						       :
-						       RADIO_MIMO_CORESEL_CORE2,
-						       NPHY_RAIL_I, rssi_type);
-			wlc_phy_scale_offset_rssi_nphy(pi, 0x0, 0x0,
-						       core ==
-						       PHY_CORE_0 ?
-						       RADIO_MIMO_CORESEL_CORE1
-						       :
-						       RADIO_MIMO_CORESEL_CORE2,
-						       NPHY_RAIL_Q, rssi_type);
+void wlc_phy_antsel_init(struct brcms_phy_pub *ppi, bool lut_init)
+{
+	struct brcms_phy *pi = (struct brcms_phy *) ppi;
+	u16 mask = 0xfc00;
+	u32 mc = 0;
 
-			wlc_phy_poll_rssi_nphy(pi, rssi_type, poll_result_core,
-					       NPHY_RSSICAL_NPOLL);
+	if (NREV_GE(pi->pubpi.phy_rev, 7))
+		return;
 
-			for (result_idx = 0; result_idx < 4; result_idx++) {
-				if (core == result_idx / 2) {
-					fine_digital_offset[result_idx] =
-						(target_code *
-						 NPHY_RSSICAL_NPOLL) -
-						poll_result_core[result_idx];
-					if (fine_digital_offset[result_idx] <
-					    0) {
-						fine_digital_offset[result_idx]
-							= ABS(
-							    fine_digital_offset
-							    [result_idx]);
-						fine_digital_offset[result_idx]
-							+= (NPHY_RSSICAL_NPOLL
-							    / 2);
-						fine_digital_offset[result_idx]
-							/= NPHY_RSSICAL_NPOLL;
-						fine_digital_offset[result_idx]
-							= -fine_digital_offset
-								[result_idx];
-					} else {
-						fine_digital_offset[result_idx]
-							+= (NPHY_RSSICAL_NPOLL
-							    / 2);
-						fine_digital_offset[result_idx]
-							/= NPHY_RSSICAL_NPOLL;
-					}
+	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+		u16 v0 = 0x211, v1 = 0x222, v2 = 0x144, v3 = 0x188;
 
-					wlc_phy_scale_offset_rssi_nphy(
-						pi, 0x0,
-						(s8)
-						fine_digital_offset
-						[core *
-						 2],
-						(core == PHY_CORE_0) ?
-						RADIO_MIMO_CORESEL_CORE1 :
-						RADIO_MIMO_CORESEL_CORE2,
-						(result_idx % 2 == 0) ?
-						NPHY_RAIL_I :
-						NPHY_RAIL_Q,
-						rssi_type);
-				}
-			}
+		if (lut_init == false)
+			return;
 
+		if (pi->srom_fem2g.antswctrllut == 0) {
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_ANTSWCTRLLUT,
+						 1, 0x02, 16, &v0);
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_ANTSWCTRLLUT,
+						 1, 0x03, 16, &v1);
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_ANTSWCTRLLUT,
+						 1, 0x08, 16, &v2);
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_ANTSWCTRLLUT,
+						 1, 0x0C, 16, &v3);
 		}
-	}
-
-	write_phy_reg(pi, 0x91, NPHY_Rfctrlintc1_save);
-	write_phy_reg(pi, 0x92, NPHY_Rfctrlintc2_save);
-
-	wlc_phy_force_rfseq_nphy(pi, NPHY_RFSEQ_RESET2RX);
 
-	mod_phy_reg(pi, 0xe7, (0x1 << 0), 1 << 0);
-	mod_phy_reg(pi, 0x78, (0x1 << 0), 1 << 0);
-	mod_phy_reg(pi, 0xe7, (0x1 << 0), 0);
+		if (pi->srom_fem5g.antswctrllut == 0) {
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_ANTSWCTRLLUT,
+						 1, 0x12, 16, &v0);
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_ANTSWCTRLLUT,
+						 1, 0x13, 16, &v1);
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_ANTSWCTRLLUT,
+						 1, 0x18, 16, &v2);
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_ANTSWCTRLLUT,
+						 1, 0x1C, 16, &v3);
+		}
+	} else {
 
-	mod_phy_reg(pi, 0xec, (0x1 << 0), 1 << 0);
-	mod_phy_reg(pi, 0x78, (0x1 << 1), 1 << 1);
-	mod_phy_reg(pi, 0xec, (0x1 << 0), 0);
+		write_phy_reg(pi, 0xc8, 0x0);
+		write_phy_reg(pi, 0xc9, 0x0);
 
-	write_phy_reg(pi, 0x8f, NPHY_AfectrlOverride1_save);
-	write_phy_reg(pi, 0xa5, NPHY_AfectrlOverride2_save);
-	write_phy_reg(pi, 0xa6, NPHY_AfectrlCore1_save);
-	write_phy_reg(pi, 0xa7, NPHY_AfectrlCore2_save);
-	write_phy_reg(pi, 0xe7, NPHY_RfctrlOverride0_save);
-	write_phy_reg(pi, 0xec, NPHY_RfctrlOverride1_save);
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-		write_phy_reg(pi, 0x342, NPHY_REV7_RfctrlOverride3_save);
-		write_phy_reg(pi, 0x343, NPHY_REV7_RfctrlOverride4_save);
-		write_phy_reg(pi, 0x346, NPHY_REV7_RfctrlOverride5_save);
-		write_phy_reg(pi, 0x347, NPHY_REV7_RfctrlOverride6_save);
-	}
-	write_phy_reg(pi, 0xe5, NPHY_RfctrlOverrideAux0_save);
-	write_phy_reg(pi, 0xe6, NPHY_RfctrlOverrideAux1_save);
-	write_phy_reg(pi, 0x78, NPHY_RfctrlCmd_save);
-	write_phy_reg(pi, 0xf9, NPHY_RfctrlMiscReg1_save);
-	write_phy_reg(pi, 0xfb, NPHY_RfctrlMiscReg2_save);
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-		write_phy_reg(pi, 0x340, NPHY_REV7_RfctrlMiscReg3_save);
-		write_phy_reg(pi, 0x341, NPHY_REV7_RfctrlMiscReg4_save);
-		write_phy_reg(pi, 0x344, NPHY_REV7_RfctrlMiscReg5_save);
-		write_phy_reg(pi, 0x345, NPHY_REV7_RfctrlMiscReg6_save);
-	}
-	write_phy_reg(pi, 0x7a, NPHY_RfctrlRSSIOTHERS1_save);
-	write_phy_reg(pi, 0x7d, NPHY_RfctrlRSSIOTHERS2_save);
+		ai_gpiocontrol(pi->sh->sih, mask, mask, GPIO_DRV_PRIORITY);
 
-	if (CHSPEC_IS2G(pi->radio_chanspec)) {
-		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-			pi->rssical_cache.rssical_radio_regs_2G[0] =
-				read_radio_reg(pi, RADIO_2057_NB_MASTER_CORE0);
-			pi->rssical_cache.rssical_radio_regs_2G[1] =
-				read_radio_reg(pi, RADIO_2057_NB_MASTER_CORE1);
-		} else {
-			pi->rssical_cache.rssical_radio_regs_2G[0] =
-				read_radio_reg(pi,
-					       RADIO_2056_RX_RSSI_MISC |
-					       RADIO_2056_RX0);
-			pi->rssical_cache.rssical_radio_regs_2G[1] =
-				read_radio_reg(pi,
-					       RADIO_2056_RX_RSSI_MISC |
-					       RADIO_2056_RX1);
-		}
+		mc = R_REG(&pi->regs->maccontrol);
+		mc &= ~MCTL_GPOUT_SEL_MASK;
+		W_REG(&pi->regs->maccontrol, mc);
 
-		pi->rssical_cache.rssical_phyregs_2G[0] =
-			read_phy_reg(pi, 0x1a6);
-		pi->rssical_cache.rssical_phyregs_2G[1] =
-			read_phy_reg(pi, 0x1ac);
-		pi->rssical_cache.rssical_phyregs_2G[2] =
-			read_phy_reg(pi, 0x1b2);
-		pi->rssical_cache.rssical_phyregs_2G[3] =
-			read_phy_reg(pi, 0x1b8);
-		pi->rssical_cache.rssical_phyregs_2G[4] =
-			read_phy_reg(pi, 0x1a4);
-		pi->rssical_cache.rssical_phyregs_2G[5] =
-			read_phy_reg(pi, 0x1aa);
-		pi->rssical_cache.rssical_phyregs_2G[6] =
-			read_phy_reg(pi, 0x1b0);
-		pi->rssical_cache.rssical_phyregs_2G[7] =
-			read_phy_reg(pi, 0x1b6);
-		pi->rssical_cache.rssical_phyregs_2G[8] =
-			read_phy_reg(pi, 0x1a5);
-		pi->rssical_cache.rssical_phyregs_2G[9] =
-			read_phy_reg(pi, 0x1ab);
-		pi->rssical_cache.rssical_phyregs_2G[10] =
-			read_phy_reg(pi, 0x1b1);
-		pi->rssical_cache.rssical_phyregs_2G[11] =
-			read_phy_reg(pi, 0x1b7);
+		OR_REG(&pi->regs->psm_gpio_oe, mask);
 
-		pi->nphy_rssical_chanspec_2G = pi->radio_chanspec;
-	} else {
-		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-			pi->rssical_cache.rssical_radio_regs_5G[0] =
-				read_radio_reg(pi, RADIO_2057_NB_MASTER_CORE0);
-			pi->rssical_cache.rssical_radio_regs_5G[1] =
-				read_radio_reg(pi, RADIO_2057_NB_MASTER_CORE1);
-		} else {
-			pi->rssical_cache.rssical_radio_regs_5G[0] =
-				read_radio_reg(pi,
-					       RADIO_2056_RX_RSSI_MISC |
-					       RADIO_2056_RX0);
-			pi->rssical_cache.rssical_radio_regs_5G[1] =
-				read_radio_reg(pi,
-					       RADIO_2056_RX_RSSI_MISC |
-					       RADIO_2056_RX1);
-		}
+		AND_REG(&pi->regs->psm_gpio_out, ~mask);
 
-		pi->rssical_cache.rssical_phyregs_5G[0] =
-			read_phy_reg(pi, 0x1a6);
-		pi->rssical_cache.rssical_phyregs_5G[1] =
-			read_phy_reg(pi, 0x1ac);
-		pi->rssical_cache.rssical_phyregs_5G[2] =
-			read_phy_reg(pi, 0x1b2);
-		pi->rssical_cache.rssical_phyregs_5G[3] =
-			read_phy_reg(pi, 0x1b8);
-		pi->rssical_cache.rssical_phyregs_5G[4] =
-			read_phy_reg(pi, 0x1a4);
-		pi->rssical_cache.rssical_phyregs_5G[5] =
-			read_phy_reg(pi, 0x1aa);
-		pi->rssical_cache.rssical_phyregs_5G[6] =
-			read_phy_reg(pi, 0x1b0);
-		pi->rssical_cache.rssical_phyregs_5G[7] =
-			read_phy_reg(pi, 0x1b6);
-		pi->rssical_cache.rssical_phyregs_5G[8] =
-			read_phy_reg(pi, 0x1a5);
-		pi->rssical_cache.rssical_phyregs_5G[9] =
-			read_phy_reg(pi, 0x1ab);
-		pi->rssical_cache.rssical_phyregs_5G[10] =
-			read_phy_reg(pi, 0x1b1);
-		pi->rssical_cache.rssical_phyregs_5G[11] =
-			read_phy_reg(pi, 0x1b7);
+		if (lut_init) {
+			write_phy_reg(pi, 0xf8, 0x02d8);
+			write_phy_reg(pi, 0xf9, 0x0301);
+			write_phy_reg(pi, 0xfa, 0x02d8);
+			write_phy_reg(pi, 0xfb, 0x0301);
+		}
+	}
+}
 
-		pi->nphy_rssical_chanspec_5G = pi->radio_chanspec;
+u16 wlc_phy_classifier_nphy(struct brcms_phy *pi, u16 mask, u16 val)
+{
+	u16 curr_ctl, new_ctl;
+	bool suspended = false;
+
+	if (D11REV_IS(pi->sh->corerev, 16)) {
+		suspended =
+			(R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC) ?
+			false : true;
+		if (!suspended)
+			wlapi_suspend_mac_and_wait(pi->sh->physhim);
 	}
 
-	wlc_phy_classifier_nphy(pi, (0x7 << 0), classif_state);
-	wlc_phy_clip_det_nphy(pi, 1, clip_state);
+	curr_ctl = read_phy_reg(pi, 0xb0) & (0x7 << 0);
+
+	new_ctl = (curr_ctl & (~mask)) | (val & mask);
+
+	mod_phy_reg(pi, 0xb0, (0x7 << 0), new_ctl);
+
+	if (D11REV_IS(pi->sh->corerev, 16) && !suspended)
+		wlapi_enable_mac(pi->sh->physhim);
+
+	return new_ctl;
 }
 
-static void wlc_phy_restore_rssical_nphy(struct brcms_phy *pi)
+void wlc_phy_force_rfseq_nphy(struct brcms_phy *pi, u8 cmd)
 {
-	if (CHSPEC_IS2G(pi->radio_chanspec)) {
-		if (pi->nphy_rssical_chanspec_2G == 0)
-			return;
+	u16 trigger_mask, status_mask;
+	u16 orig_RfseqCoreActv;
 
-		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-			mod_radio_reg(pi, RADIO_2057_NB_MASTER_CORE0,
-				      RADIO_2057_VCM_MASK,
-				      pi->rssical_cache.
-				      rssical_radio_regs_2G[0]);
-			mod_radio_reg(pi, RADIO_2057_NB_MASTER_CORE1,
-				      RADIO_2057_VCM_MASK,
-				      pi->rssical_cache.
-				      rssical_radio_regs_2G[1]);
-		} else {
-			mod_radio_reg(pi,
-				      RADIO_2056_RX_RSSI_MISC | RADIO_2056_RX0,
-				      RADIO_2056_VCM_MASK,
-				      pi->rssical_cache.
-				      rssical_radio_regs_2G[0]);
-			mod_radio_reg(pi,
-				      RADIO_2056_RX_RSSI_MISC | RADIO_2056_RX1,
-				      RADIO_2056_VCM_MASK,
-				      pi->rssical_cache.
-				      rssical_radio_regs_2G[1]);
-		}
+	switch (cmd) {
+	case NPHY_RFSEQ_RX2TX:
+		trigger_mask = NPHY_RfseqTrigger_rx2tx;
+		status_mask = NPHY_RfseqStatus_rx2tx;
+		break;
+	case NPHY_RFSEQ_TX2RX:
+		trigger_mask = NPHY_RfseqTrigger_tx2rx;
+		status_mask = NPHY_RfseqStatus_tx2rx;
+		break;
+	case NPHY_RFSEQ_RESET2RX:
+		trigger_mask = NPHY_RfseqTrigger_reset2rx;
+		status_mask = NPHY_RfseqStatus_reset2rx;
+		break;
+	case NPHY_RFSEQ_UPDATEGAINH:
+		trigger_mask = NPHY_RfseqTrigger_updategainh;
+		status_mask = NPHY_RfseqStatus_updategainh;
+		break;
+	case NPHY_RFSEQ_UPDATEGAINL:
+		trigger_mask = NPHY_RfseqTrigger_updategainl;
+		status_mask = NPHY_RfseqStatus_updategainl;
+		break;
+	case NPHY_RFSEQ_UPDATEGAINU:
+		trigger_mask = NPHY_RfseqTrigger_updategainu;
+		status_mask = NPHY_RfseqStatus_updategainu;
+		break;
+	default:
+		return;
+	}
 
-		write_phy_reg(pi, 0x1a6,
-			      pi->rssical_cache.rssical_phyregs_2G[0]);
-		write_phy_reg(pi, 0x1ac,
-			      pi->rssical_cache.rssical_phyregs_2G[1]);
-		write_phy_reg(pi, 0x1b2,
-			      pi->rssical_cache.rssical_phyregs_2G[2]);
-		write_phy_reg(pi, 0x1b8,
-			      pi->rssical_cache.rssical_phyregs_2G[3]);
-		write_phy_reg(pi, 0x1a4,
-			      pi->rssical_cache.rssical_phyregs_2G[4]);
-		write_phy_reg(pi, 0x1aa,
-			      pi->rssical_cache.rssical_phyregs_2G[5]);
-		write_phy_reg(pi, 0x1b0,
-			      pi->rssical_cache.rssical_phyregs_2G[6]);
-		write_phy_reg(pi, 0x1b6,
-			      pi->rssical_cache.rssical_phyregs_2G[7]);
-		write_phy_reg(pi, 0x1a5,
-			      pi->rssical_cache.rssical_phyregs_2G[8]);
-		write_phy_reg(pi, 0x1ab,
-			      pi->rssical_cache.rssical_phyregs_2G[9]);
-		write_phy_reg(pi, 0x1b1,
-			      pi->rssical_cache.rssical_phyregs_2G[10]);
-		write_phy_reg(pi, 0x1b7,
-			      pi->rssical_cache.rssical_phyregs_2G[11]);
+	orig_RfseqCoreActv = read_phy_reg(pi, 0xa1);
+	or_phy_reg(pi, 0xa1,
+		   (NPHY_RfseqMode_CoreActv_override |
+		    NPHY_RfseqMode_Trigger_override));
+	or_phy_reg(pi, 0xa3, trigger_mask);
+	SPINWAIT((read_phy_reg(pi, 0xa4) & status_mask), 200000);
+	write_phy_reg(pi, 0xa1, orig_RfseqCoreActv);
+	WARN(read_phy_reg(pi, 0xa4) & status_mask, "HW error in rf");
+}
 
-	} else {
-		if (pi->nphy_rssical_chanspec_5G == 0)
-			return;
+static void
+wlc_phy_rfctrl_override_1tomany_nphy(struct brcms_phy *pi, u16 cmd, u16 value,
+				     u8 core_mask, u8 off)
+{
+	u16 rfmxgain = 0, lpfgain = 0;
+	u16 tgain = 0;
 
-		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-			mod_radio_reg(pi, RADIO_2057_NB_MASTER_CORE0,
-				      RADIO_2057_VCM_MASK,
-				      pi->rssical_cache.
-				      rssical_radio_regs_5G[0]);
-			mod_radio_reg(pi, RADIO_2057_NB_MASTER_CORE1,
-				      RADIO_2057_VCM_MASK,
-				      pi->rssical_cache.
-				      rssical_radio_regs_5G[1]);
-		} else {
-			mod_radio_reg(pi,
-				      RADIO_2056_RX_RSSI_MISC | RADIO_2056_RX0,
-				      RADIO_2056_VCM_MASK,
-				      pi->rssical_cache.
-				      rssical_radio_regs_5G[0]);
-			mod_radio_reg(pi,
-				      RADIO_2056_RX_RSSI_MISC | RADIO_2056_RX1,
-				      RADIO_2056_VCM_MASK,
-				      pi->rssical_cache.
-				      rssical_radio_regs_5G[1]);
-		}
+	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 
-		write_phy_reg(pi, 0x1a6,
-			      pi->rssical_cache.rssical_phyregs_5G[0]);
-		write_phy_reg(pi, 0x1ac,
-			      pi->rssical_cache.rssical_phyregs_5G[1]);
-		write_phy_reg(pi, 0x1b2,
-			      pi->rssical_cache.rssical_phyregs_5G[2]);
-		write_phy_reg(pi, 0x1b8,
-			      pi->rssical_cache.rssical_phyregs_5G[3]);
-		write_phy_reg(pi, 0x1a4,
-			      pi->rssical_cache.rssical_phyregs_5G[4]);
-		write_phy_reg(pi, 0x1aa,
-			      pi->rssical_cache.rssical_phyregs_5G[5]);
-		write_phy_reg(pi, 0x1b0,
-			      pi->rssical_cache.rssical_phyregs_5G[6]);
-		write_phy_reg(pi, 0x1b6,
-			      pi->rssical_cache.rssical_phyregs_5G[7]);
-		write_phy_reg(pi, 0x1a5,
-			      pi->rssical_cache.rssical_phyregs_5G[8]);
-		write_phy_reg(pi, 0x1ab,
-			      pi->rssical_cache.rssical_phyregs_5G[9]);
-		write_phy_reg(pi, 0x1b1,
-			      pi->rssical_cache.rssical_phyregs_5G[10]);
-		write_phy_reg(pi, 0x1b7,
-			      pi->rssical_cache.rssical_phyregs_5G[11]);
+		switch (cmd) {
+		case NPHY_REV7_RfctrlOverride_cmd_rxrf_pu:
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 5),
+				value, core_mask, off,
+				NPHY_REV7_RFCTRLOVERRIDE_ID1);
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 4), value,
+				core_mask, off,
+				NPHY_REV7_RFCTRLOVERRIDE_ID1);
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 3), value,
+				core_mask, off,
+				NPHY_REV7_RFCTRLOVERRIDE_ID1);
+			break;
+		case NPHY_REV7_RfctrlOverride_cmd_rx_pu:
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 2),
+				value, core_mask, off,
+				NPHY_REV7_RFCTRLOVERRIDE_ID1);
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 1), value,
+				core_mask, off,
+				NPHY_REV7_RFCTRLOVERRIDE_ID1);
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 0), value,
+				core_mask, off,
+				NPHY_REV7_RFCTRLOVERRIDE_ID1);
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 1), value,
+				core_mask, off,
+				NPHY_REV7_RFCTRLOVERRIDE_ID2);
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 11), 0,
+				core_mask, off,
+				NPHY_REV7_RFCTRLOVERRIDE_ID1);
+			break;
+		case NPHY_REV7_RfctrlOverride_cmd_tx_pu:
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 2),
+				value, core_mask, off,
+				NPHY_REV7_RFCTRLOVERRIDE_ID0);
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 1), value,
+				core_mask, off,
+				NPHY_REV7_RFCTRLOVERRIDE_ID1);
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 0), value,
+				core_mask, off,
+				NPHY_REV7_RFCTRLOVERRIDE_ID2);
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 2), value,
+				core_mask, off,
+				NPHY_REV7_RFCTRLOVERRIDE_ID2);
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 11), 1,
+				core_mask, off,
+				NPHY_REV7_RFCTRLOVERRIDE_ID1);
+			break;
+		case NPHY_REV7_RfctrlOverride_cmd_rxgain:
+			rfmxgain = value & 0x000ff;
+			lpfgain = value & 0x0ff00;
+			lpfgain = lpfgain >> 8;
+
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 11),
+				rfmxgain, core_mask,
+				off,
+				NPHY_REV7_RFCTRLOVERRIDE_ID0);
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x3 << 13),
+				lpfgain, core_mask,
+				off,
+				NPHY_REV7_RFCTRLOVERRIDE_ID0);
+			break;
+		case NPHY_REV7_RfctrlOverride_cmd_txgain:
+			tgain = value & 0x7fff;
+			lpfgain = value & 0x8000;
+			lpfgain = lpfgain >> 14;
+
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 12),
+				tgain, core_mask, off,
+				NPHY_REV7_RFCTRLOVERRIDE_ID0);
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 13),
+				lpfgain, core_mask,
+				off,
+				NPHY_REV7_RFCTRLOVERRIDE_ID0);
+			break;
+		}
 	}
 }
 
-static u16
-wlc_phy_gen_load_samples_nphy(struct brcms_phy *pi, u32 f_kHz, u16 max_val,
-			      u8 dac_test_mode)
+static void
+wlc_phy_scale_offset_rssi_nphy(struct brcms_phy *pi, u16 scale, s8 offset,
+			       u8 coresel, u8 rail, u8 rssi_type)
 {
-	u8 phy_bw, is_phybw40;
-	u16 num_samps, t, spur;
-	s32 theta = 0, rot = 0;
-	u32 tbl_len;
-	struct cordic_iq *tone_buf = NULL;
+	u16 valuetostuff;
 
-	is_phybw40 = CHSPEC_IS40(pi->radio_chanspec);
-	phy_bw = (is_phybw40 == 1) ? 40 : 20;
-	tbl_len = (phy_bw << 3);
+	offset = (offset > NPHY_RSSICAL_MAXREAD) ?
+		 NPHY_RSSICAL_MAXREAD : offset;
+	offset = (offset < (-NPHY_RSSICAL_MAXREAD - 1)) ?
+		 -NPHY_RSSICAL_MAXREAD - 1 : offset;
 
-	if (dac_test_mode == 1) {
-		spur = read_phy_reg(pi, 0x01);
-		spur = (spur >> 15) & 1;
-		phy_bw = (spur == 1) ? 82 : 80;
-		phy_bw = (is_phybw40 == 1) ? (phy_bw << 1) : phy_bw;
+	valuetostuff = ((scale & 0x3f) << 8) | (offset & 0x3f);
 
-		tbl_len = (phy_bw << 1);
-	}
+	if (((coresel == RADIO_MIMO_CORESEL_CORE1) ||
+	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
+	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_NB))
+		write_phy_reg(pi, 0x1a6, valuetostuff);
 
-	tone_buf = kmalloc(sizeof(struct cordic_iq) * tbl_len, GFP_ATOMIC);
-	if (tone_buf == NULL)
-		return 0;
+	if (((coresel == RADIO_MIMO_CORESEL_CORE1) ||
+	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
+	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_NB))
+		write_phy_reg(pi, 0x1ac, valuetostuff);
 
-	num_samps = (u16) tbl_len;
-	rot = ((f_kHz * 36) / phy_bw) / 100;
-	theta = 0;
+	if (((coresel == RADIO_MIMO_CORESEL_CORE2) ||
+	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
+	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_NB))
+		write_phy_reg(pi, 0x1b2, valuetostuff);
 
-	for (t = 0; t < num_samps; t++) {
+	if (((coresel == RADIO_MIMO_CORESEL_CORE2) ||
+	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
+	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_NB))
+		write_phy_reg(pi, 0x1b8, valuetostuff);
 
-		tone_buf[t] = cordic_calc_iq(theta);
+	if (((coresel == RADIO_MIMO_CORESEL_CORE1) ||
+	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
+	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_W1))
+		write_phy_reg(pi, 0x1a4, valuetostuff);
 
-		theta += rot;
+	if (((coresel == RADIO_MIMO_CORESEL_CORE1) ||
+	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
+	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_W1))
+		write_phy_reg(pi, 0x1aa, valuetostuff);
 
-		tone_buf[t].q = (s32) FLOAT(tone_buf[t].q * max_val);
-		tone_buf[t].i = (s32) FLOAT(tone_buf[t].i * max_val);
-	}
+	if (((coresel == RADIO_MIMO_CORESEL_CORE2) ||
+	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
+	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_W1))
+		write_phy_reg(pi, 0x1b0, valuetostuff);
 
-	wlc_phy_loadsampletable_nphy(pi, tone_buf, num_samps);
+	if (((coresel == RADIO_MIMO_CORESEL_CORE2) ||
+	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
+	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_W1))
+		write_phy_reg(pi, 0x1b6, valuetostuff);
 
-	kfree(tone_buf);
+	if (((coresel == RADIO_MIMO_CORESEL_CORE1) ||
+	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
+	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_W2))
+		write_phy_reg(pi, 0x1a5, valuetostuff);
+	if (((coresel == RADIO_MIMO_CORESEL_CORE1) ||
+	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
+	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_W2))
+		write_phy_reg(pi, 0x1ab, valuetostuff);
 
-	return num_samps;
+	if (((coresel == RADIO_MIMO_CORESEL_CORE2) ||
+	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
+	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_W2))
+		write_phy_reg(pi, 0x1b1, valuetostuff);
+
+	if (((coresel == RADIO_MIMO_CORESEL_CORE2) ||
+	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
+	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_W2))
+		write_phy_reg(pi, 0x1b7, valuetostuff);
+
+	if (((coresel == RADIO_MIMO_CORESEL_CORE1) ||
+	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
+	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_TBD))
+		write_phy_reg(pi, 0x1a7, valuetostuff);
+	if (((coresel == RADIO_MIMO_CORESEL_CORE1) ||
+	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
+	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_TBD))
+		write_phy_reg(pi, 0x1ad, valuetostuff);
+	if (((coresel == RADIO_MIMO_CORESEL_CORE2) ||
+	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
+	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_TBD))
+		write_phy_reg(pi, 0x1b3, valuetostuff);
+	if (((coresel == RADIO_MIMO_CORESEL_CORE2) ||
+	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
+	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_TBD))
+		write_phy_reg(pi, 0x1b9, valuetostuff);
+
+	if (((coresel == RADIO_MIMO_CORESEL_CORE1) ||
+	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
+	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_IQ))
+		write_phy_reg(pi, 0x1a8, valuetostuff);
+
+	if (((coresel == RADIO_MIMO_CORESEL_CORE1) ||
+	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
+	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_IQ))
+		write_phy_reg(pi, 0x1ae, valuetostuff);
+
+	if (((coresel == RADIO_MIMO_CORESEL_CORE2) ||
+	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
+	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_IQ))
+		write_phy_reg(pi, 0x1b4, valuetostuff);
+
+	if (((coresel == RADIO_MIMO_CORESEL_CORE2) ||
+	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
+	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_IQ))
+		write_phy_reg(pi, 0x1ba, valuetostuff);
+
+	if (((coresel == RADIO_MIMO_CORESEL_CORE1) ||
+	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
+	    (rssi_type == NPHY_RSSI_SEL_TSSI_2G))
+		write_phy_reg(pi, 0x1a9, valuetostuff);
+	if (((coresel == RADIO_MIMO_CORESEL_CORE2) ||
+	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
+	    (rssi_type == NPHY_RSSI_SEL_TSSI_2G))
+		write_phy_reg(pi, 0x1b5, valuetostuff);
+
+	if (((coresel == RADIO_MIMO_CORESEL_CORE1) ||
+	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
+	    (rssi_type == NPHY_RSSI_SEL_TSSI_5G))
+		write_phy_reg(pi, 0x1af, valuetostuff);
+
+	if (((coresel == RADIO_MIMO_CORESEL_CORE2) ||
+	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
+	    (rssi_type == NPHY_RSSI_SEL_TSSI_5G))
+		write_phy_reg(pi, 0x1bb, valuetostuff);
 }
 
-int
-wlc_phy_tx_tone_nphy(struct brcms_phy *pi, u32 f_kHz, u16 max_val,
-		     u8 iqmode, u8 dac_test_mode, bool modify_bbmult)
+static void brcms_phy_wr_tx_mux(struct brcms_phy *pi, u8 core)
 {
-	u16 num_samps;
-	u16 loops = 0xffff;
-	u16 wait = 0;
-
-	num_samps = wlc_phy_gen_load_samples_nphy(pi, f_kHz, max_val,
-						  dac_test_mode);
-	if (num_samps == 0)
-		return -EBADE;
+	if (PHY_IPA(pi)) {
+		if (NREV_GE(pi->pubpi.phy_rev, 7))
+			write_radio_reg(pi,
+					((core == PHY_CORE_0) ?
+					 RADIO_2057_TX0_TX_SSI_MUX :
+					 RADIO_2057_TX1_TX_SSI_MUX),
+					(CHSPEC_IS5G(pi->radio_chanspec) ?
+					0xc : 0xe));
+		else
+			write_radio_reg(pi,
+					RADIO_2056_TX_TX_SSI_MUX |
+					((core == PHY_CORE_0) ?
+					 RADIO_2056_TX0 : RADIO_2056_TX1),
+					(CHSPEC_IS5G(pi->radio_chanspec) ?
+					0xc : 0xe));
+	} else {
+		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+			write_radio_reg(pi,
+					((core == PHY_CORE_0) ?
+					 RADIO_2057_TX0_TX_SSI_MUX :
+					 RADIO_2057_TX1_TX_SSI_MUX),
+					0x11);
 
-	wlc_phy_runsamples_nphy(pi, num_samps, loops, wait, iqmode,
-				dac_test_mode, modify_bbmult);
+			if (pi->pubpi.radioid == BCM2057_ID)
+				write_radio_reg(pi,
+						RADIO_2057_IQTEST_SEL_PU, 0x1);
 
-	return 0;
+		} else {
+			write_radio_reg(pi,
+					RADIO_2056_TX_TX_SSI_MUX |
+					((core == PHY_CORE_0) ?
+					 RADIO_2056_TX0 : RADIO_2056_TX1),
+					0x11);
+		}
+	}
 }
 
-static void
-wlc_phy_loadsampletable_nphy(struct brcms_phy *pi, struct cordic_iq *tone_buf,
-			     u16 num_samps)
+void wlc_phy_rssisel_nphy(struct brcms_phy *pi, u8 core_code, u8 rssi_type)
 {
-	u16 t;
-	u32 *data_buf = NULL;
+	u16 mask, val;
+	u16 afectrlovr_rssi_val, rfctrlcmd_rxen_val, rfctrlcmd_coresel_val,
+	    startseq;
+	u16 rfctrlovr_rssi_val, rfctrlovr_rxen_val, rfctrlovr_coresel_val,
+	    rfctrlovr_trigger_val;
+	u16 afectrlovr_rssi_mask, rfctrlcmd_mask, rfctrlovr_mask;
+	u16 rfctrlcmd_val, rfctrlovr_val;
+	u8 core;
 
-	data_buf = kmalloc(sizeof(u32) * num_samps, GFP_ATOMIC);
-	if (data_buf == NULL)
-		return;
+	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+		if (core_code == RADIO_MIMO_CORESEL_OFF) {
+			mod_phy_reg(pi, 0x8f, (0x1 << 9), 0);
+			mod_phy_reg(pi, 0xa5, (0x1 << 9), 0);
 
-	if (pi->phyhang_avoid)
-		wlc_phy_stay_in_carriersearch_nphy(pi, true);
+			mod_phy_reg(pi, 0xa6, (0x3 << 8), 0);
+			mod_phy_reg(pi, 0xa7, (0x3 << 8), 0);
 
-	for (t = 0; t < num_samps; t++)
-		data_buf[t] = ((((unsigned int)tone_buf[t].i) & 0x3ff) << 10) |
-			      (((unsigned int)tone_buf[t].q) & 0x3ff);
-	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_SAMPLEPLAY, num_samps, 0, 32,
-				 data_buf);
+			mod_phy_reg(pi, 0xe5, (0x1 << 5), 0);
+			mod_phy_reg(pi, 0xe6, (0x1 << 5), 0);
 
-	kfree(data_buf);
+			mask = (0x1 << 2) |
+			       (0x1 << 3) | (0x1 << 4) | (0x1 << 5);
+			mod_phy_reg(pi, 0xf9, mask, 0);
+			mod_phy_reg(pi, 0xfb, mask, 0);
 
-	if (pi->phyhang_avoid)
-		wlc_phy_stay_in_carriersearch_nphy(pi, false);
-}
+		} else {
+			for (core = 0; core < pi->pubpi.phy_corenum; core++) {
+				if (core_code == RADIO_MIMO_CORESEL_CORE1
+				    && core == PHY_CORE_1)
+					continue;
+				else if (core_code == RADIO_MIMO_CORESEL_CORE2
+					 && core == PHY_CORE_0)
+					continue;
+
+				mod_phy_reg(pi, (core == PHY_CORE_0) ?
+					    0x8f : 0xa5, (0x1 << 9), 1 << 9);
+
+				if (rssi_type == NPHY_RSSI_SEL_W1 ||
+				    rssi_type == NPHY_RSSI_SEL_W2 ||
+				    rssi_type == NPHY_RSSI_SEL_NB) {
+					mod_phy_reg(pi,
+						    (core ==
+						     PHY_CORE_0) ? 0xa6 : 0xa7,
+						    (0x3 << 8), 0);
 
-static void
-wlc_phy_runsamples_nphy(struct brcms_phy *pi, u16 num_samps, u16 loops,
-			u16 wait, u8 iqmode, u8 dac_test_mode,
-			bool modify_bbmult)
-{
-	u16 bb_mult;
-	u8 phy_bw, sample_cmd;
-	u16 orig_RfseqCoreActv;
-	u16 lpf_bw_ctl_override3, lpf_bw_ctl_override4, lpf_bw_ctl_miscreg3,
-	    lpf_bw_ctl_miscreg4;
+					mask = (0x1 << 2) |
+					       (0x1 << 3) |
+					       (0x1 << 4) | (0x1 << 5);
+					mod_phy_reg(pi,
+						    (core ==
+						     PHY_CORE_0) ? 0xf9 : 0xfb,
+						    mask, 0);
 
-	if (pi->phyhang_avoid)
-		wlc_phy_stay_in_carriersearch_nphy(pi, true);
+					if (rssi_type == NPHY_RSSI_SEL_W1) {
+						if (CHSPEC_IS5G(
+							  pi->radio_chanspec)) {
+							mask = (0x1 << 2);
+							val = 1 << 2;
+						} else {
+							mask = (0x1 << 3);
+							val = 1 << 3;
+						}
+					} else if (rssi_type ==
+						   NPHY_RSSI_SEL_W2) {
+						mask = (0x1 << 4);
+						val = 1 << 4;
+					} else {
+						mask = (0x1 << 5);
+						val = 1 << 5;
+					}
+					mod_phy_reg(pi,
+						    (core ==
+						     PHY_CORE_0) ? 0xf9 : 0xfb,
+						    mask, val);
 
-	phy_bw = 20;
-	if (CHSPEC_IS40(pi->radio_chanspec))
-		phy_bw = 40;
+					mask = (0x1 << 5);
+					val = 1 << 5;
+					mod_phy_reg(pi, (core == PHY_CORE_0) ?
+						    0xe5 : 0xe6, mask, val);
+				} else {
+					if (rssi_type == NPHY_RSSI_SEL_TBD) {
+						mask = (0x3 << 8);
+						val = 1 << 8;
+						mod_phy_reg(pi,
+							    (core ==
+							     PHY_CORE_0) ? 0xa6
+							    : 0xa7, mask, val);
+						mask = (0x3 << 10);
+						val = 1 << 10;
+						mod_phy_reg(pi,
+							    (core ==
+							     PHY_CORE_0) ? 0xa6
+							    : 0xa7, mask, val);
+					} else if (rssi_type ==
+						   NPHY_RSSI_SEL_IQ) {
+						mask = (0x3 << 8);
+						val = 2 << 8;
+						mod_phy_reg(pi,
+							    (core ==
+							     PHY_CORE_0) ? 0xa6
+							    : 0xa7, mask, val);
+						mask = (0x3 << 10);
+						val = 2 << 10;
+						mod_phy_reg(pi,
+							    (core ==
+							     PHY_CORE_0) ? 0xa6
+							    : 0xa7, mask, val);
+					} else {
+						mask = (0x3 << 8);
+						val = 3 << 8;
+						mod_phy_reg(pi,
+							    (core ==
+							     PHY_CORE_0) ? 0xa6
+							    : 0xa7, mask, val);
+						mask = (0x3 << 10);
+						val = 3 << 10;
+						mod_phy_reg(pi,
+							    (core ==
+							     PHY_CORE_0) ? 0xa6
+							    : 0xa7, mask, val);
+						brcms_phy_wr_tx_mux(pi, core);
+						afectrlovr_rssi_val = 1 << 9;
+						mod_phy_reg(pi,
+							   (core ==
+							    PHY_CORE_0) ? 0x8f
+							   : 0xa5, (0x1 << 9),
+							   afectrlovr_rssi_val);
+					}
+				}
+			}
+		}
+	} else {
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+		if ((rssi_type == NPHY_RSSI_SEL_W1) ||
+		    (rssi_type == NPHY_RSSI_SEL_W2) ||
+		    (rssi_type == NPHY_RSSI_SEL_NB))
+			val = 0x0;
+		else if (rssi_type == NPHY_RSSI_SEL_TBD)
+			val = 0x1;
+		else if (rssi_type == NPHY_RSSI_SEL_IQ)
+			val = 0x2;
+		else
+			val = 0x3;
 
-		lpf_bw_ctl_override3 = read_phy_reg(pi, 0x342) & (0x1 << 7);
-		lpf_bw_ctl_override4 = read_phy_reg(pi, 0x343) & (0x1 << 7);
-		if (lpf_bw_ctl_override3 | lpf_bw_ctl_override4) {
-			lpf_bw_ctl_miscreg3 = read_phy_reg(pi, 0x340) &
-					      (0x7 << 8);
-			lpf_bw_ctl_miscreg4 = read_phy_reg(pi, 0x341) &
-					      (0x7 << 8);
-		} else {
-			wlc_phy_rfctrl_override_nphy_rev7(
-				pi,
-				(0x1 << 7),
-				wlc_phy_read_lpf_bw_ctl_nphy
-					(pi,
-					0), 0, 0,
-				NPHY_REV7_RFCTRLOVERRIDE_ID1);
+		mask = ((0x3 << 12) | (0x3 << 14));
+		val = (val << 12) | (val << 14);
+		mod_phy_reg(pi, 0xa6, mask, val);
+		mod_phy_reg(pi, 0xa7, mask, val);
 
-			pi->nphy_sample_play_lpf_bw_ctl_ovr = true;
+		if ((rssi_type == NPHY_RSSI_SEL_W1) ||
+		    (rssi_type == NPHY_RSSI_SEL_W2) ||
+		    (rssi_type == NPHY_RSSI_SEL_NB)) {
+			if (rssi_type == NPHY_RSSI_SEL_W1)
+				val = 0x1;
+			if (rssi_type == NPHY_RSSI_SEL_W2)
+				val = 0x2;
+			if (rssi_type == NPHY_RSSI_SEL_NB)
+				val = 0x3;
 
-			lpf_bw_ctl_miscreg3 = read_phy_reg(pi, 0x340) &
-					      (0x7 << 8);
-			lpf_bw_ctl_miscreg4 = read_phy_reg(pi, 0x341) &
-					      (0x7 << 8);
+			mask = (0x3 << 4);
+			val = (val << 4);
+			mod_phy_reg(pi, 0x7a, mask, val);
+			mod_phy_reg(pi, 0x7d, mask, val);
 		}
-	}
-
-	if ((pi->nphy_bb_mult_save & BB_MULT_VALID_MASK) == 0) {
 
-		wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_IQLOCAL, 1, 87, 16,
-					&bb_mult);
-		pi->nphy_bb_mult_save =
-			BB_MULT_VALID_MASK | (bb_mult & BB_MULT_MASK);
-	}
+		if (core_code == RADIO_MIMO_CORESEL_OFF) {
+			afectrlovr_rssi_val = 0;
+			rfctrlcmd_rxen_val = 0;
+			rfctrlcmd_coresel_val = 0;
+			rfctrlovr_rssi_val = 0;
+			rfctrlovr_rxen_val = 0;
+			rfctrlovr_coresel_val = 0;
+			rfctrlovr_trigger_val = 0;
+			startseq = 0;
+		} else {
+			afectrlovr_rssi_val = 1;
+			rfctrlcmd_rxen_val = 1;
+			rfctrlcmd_coresel_val = core_code;
+			rfctrlovr_rssi_val = 1;
+			rfctrlovr_rxen_val = 1;
+			rfctrlovr_coresel_val = 1;
+			rfctrlovr_trigger_val = 1;
+			startseq = 1;
+		}
 
-	if (modify_bbmult) {
-		bb_mult = (phy_bw == 20) ? 100 : 71;
-		bb_mult = (bb_mult << 8) + bb_mult;
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, 1, 87, 16,
-					 &bb_mult);
-	}
+		afectrlovr_rssi_mask = ((0x1 << 12) | (0x1 << 13));
+		afectrlovr_rssi_val = (afectrlovr_rssi_val <<
+				       12) | (afectrlovr_rssi_val << 13);
+		mod_phy_reg(pi, 0xa5, afectrlovr_rssi_mask,
+			    afectrlovr_rssi_val);
 
-	if (pi->phyhang_avoid)
-		wlc_phy_stay_in_carriersearch_nphy(pi, false);
+		if ((rssi_type == NPHY_RSSI_SEL_W1) ||
+		    (rssi_type == NPHY_RSSI_SEL_W2) ||
+		    (rssi_type == NPHY_RSSI_SEL_NB)) {
+			rfctrlcmd_mask = ((0x1 << 8) | (0x7 << 3));
+			rfctrlcmd_val = (rfctrlcmd_rxen_val << 8) |
+					(rfctrlcmd_coresel_val << 3);
 
-	write_phy_reg(pi, 0xc6, num_samps - 1);
+			rfctrlovr_mask = ((0x1 << 5) |
+					  (0x1 << 12) |
+					  (0x1 << 1) | (0x1 << 0));
+			rfctrlovr_val = (rfctrlovr_rssi_val <<
+					 5) |
+					(rfctrlovr_rxen_val << 12) |
+					(rfctrlovr_coresel_val << 1) |
+					(rfctrlovr_trigger_val << 0);
 
-	if (loops != 0xffff)
-		write_phy_reg(pi, 0xc4, loops - 1);
-	else
-		write_phy_reg(pi, 0xc4, loops);
+			mod_phy_reg(pi, 0x78, rfctrlcmd_mask, rfctrlcmd_val);
+			mod_phy_reg(pi, 0xec, rfctrlovr_mask, rfctrlovr_val);
 
-	write_phy_reg(pi, 0xc5, wait);
+			mod_phy_reg(pi, 0x78, (0x1 << 0), (startseq << 0));
+			udelay(20);
 
-	orig_RfseqCoreActv = read_phy_reg(pi, 0xa1);
-	or_phy_reg(pi, 0xa1, NPHY_RfseqMode_CoreActv_override);
-	if (iqmode) {
+			mod_phy_reg(pi, 0xec, (0x1 << 0), 0);
+		}
+	}
+}
 
-		and_phy_reg(pi, 0xc2, 0x7FFF);
+int
+wlc_phy_poll_rssi_nphy(struct brcms_phy *pi, u8 rssi_type, s32 *rssi_buf,
+		       u8 nsamps)
+{
+	s16 rssi0, rssi1;
+	u16 afectrlCore1_save = 0;
+	u16 afectrlCore2_save = 0;
+	u16 afectrlOverride1_save = 0;
+	u16 afectrlOverride2_save = 0;
+	u16 rfctrlOverrideAux0_save = 0;
+	u16 rfctrlOverrideAux1_save = 0;
+	u16 rfctrlMiscReg1_save = 0;
+	u16 rfctrlMiscReg2_save = 0;
+	u16 rfctrlcmd_save = 0;
+	u16 rfctrloverride_save = 0;
+	u16 rfctrlrssiothers1_save = 0;
+	u16 rfctrlrssiothers2_save = 0;
+	s8 tmp_buf[4];
+	u8 ctr = 0, samp = 0;
+	s32 rssi_out_val;
+	u16 gpiosel_orig;
 
-		or_phy_reg(pi, 0xc2, 0x8000);
+	afectrlCore1_save = read_phy_reg(pi, 0xa6);
+	afectrlCore2_save = read_phy_reg(pi, 0xa7);
+	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+		rfctrlMiscReg1_save = read_phy_reg(pi, 0xf9);
+		rfctrlMiscReg2_save = read_phy_reg(pi, 0xfb);
+		afectrlOverride1_save = read_phy_reg(pi, 0x8f);
+		afectrlOverride2_save = read_phy_reg(pi, 0xa5);
+		rfctrlOverrideAux0_save = read_phy_reg(pi, 0xe5);
+		rfctrlOverrideAux1_save = read_phy_reg(pi, 0xe6);
 	} else {
-
-		sample_cmd = (dac_test_mode == 1) ? 0x5 : 0x1;
-		write_phy_reg(pi, 0xc3, sample_cmd);
+		afectrlOverride1_save = read_phy_reg(pi, 0xa5);
+		rfctrlcmd_save = read_phy_reg(pi, 0x78);
+		rfctrloverride_save = read_phy_reg(pi, 0xec);
+		rfctrlrssiothers1_save = read_phy_reg(pi, 0x7a);
+		rfctrlrssiothers2_save = read_phy_reg(pi, 0x7d);
 	}
 
-	SPINWAIT(((read_phy_reg(pi, 0xa4) & 0x1) == 1), 1000);
+	wlc_phy_rssisel_nphy(pi, RADIO_MIMO_CORESEL_ALLRX, rssi_type);
 
-	write_phy_reg(pi, 0xa1, orig_RfseqCoreActv);
-}
+	gpiosel_orig = read_phy_reg(pi, 0xca);
+	if (NREV_LT(pi->pubpi.phy_rev, 2))
+		write_phy_reg(pi, 0xca, 5);
 
-void wlc_phy_stopplayback_nphy(struct brcms_phy *pi)
-{
-	u16 playback_status;
-	u16 bb_mult;
+	for (ctr = 0; ctr < 4; ctr++)
+		rssi_buf[ctr] = 0;
 
-	if (pi->phyhang_avoid)
-		wlc_phy_stay_in_carriersearch_nphy(pi, true);
+	for (samp = 0; samp < nsamps; samp++) {
+		if (NREV_LT(pi->pubpi.phy_rev, 2)) {
+			rssi0 = read_phy_reg(pi, 0x1c9);
+			rssi1 = read_phy_reg(pi, 0x1ca);
+		} else {
+			rssi0 = read_phy_reg(pi, 0x219);
+			rssi1 = read_phy_reg(pi, 0x21a);
+		}
 
-	playback_status = read_phy_reg(pi, 0xc7);
-	if (playback_status & 0x1)
-		or_phy_reg(pi, 0xc3, NPHY_sampleCmd_STOP);
-	else if (playback_status & 0x2)
-		and_phy_reg(pi, 0xc2,
-			    (u16) ~NPHY_iqloCalCmdGctl_IQLO_CAL_EN);
+		ctr = 0;
+		tmp_buf[ctr++] = ((s8) ((rssi0 & 0x3f) << 2)) >> 2;
+		tmp_buf[ctr++] = ((s8) (((rssi0 >> 8) & 0x3f) << 2)) >> 2;
+		tmp_buf[ctr++] = ((s8) ((rssi1 & 0x3f) << 2)) >> 2;
+		tmp_buf[ctr++] = ((s8) (((rssi1 >> 8) & 0x3f) << 2)) >> 2;
 
-	and_phy_reg(pi, 0xc3, (u16) ~(0x1 << 2));
+		for (ctr = 0; ctr < 4; ctr++)
+			rssi_buf[ctr] += tmp_buf[ctr];
 
-	if ((pi->nphy_bb_mult_save & BB_MULT_VALID_MASK) != 0) {
+	}
 
-		bb_mult = pi->nphy_bb_mult_save & BB_MULT_MASK;
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, 1, 87, 16,
-					 &bb_mult);
+	rssi_out_val = rssi_buf[3] & 0xff;
+	rssi_out_val |= (rssi_buf[2] & 0xff) << 8;
+	rssi_out_val |= (rssi_buf[1] & 0xff) << 16;
+	rssi_out_val |= (rssi_buf[0] & 0xff) << 24;
 
-		pi->nphy_bb_mult_save = 0;
-	}
+	if (NREV_LT(pi->pubpi.phy_rev, 2))
+		write_phy_reg(pi, 0xca, gpiosel_orig);
 
-	if (NREV_IS(pi->pubpi.phy_rev, 7) || NREV_GE(pi->pubpi.phy_rev, 8)) {
-		if (pi->nphy_sample_play_lpf_bw_ctl_ovr) {
-			wlc_phy_rfctrl_override_nphy_rev7(
-				pi,
-				(0x1 << 7),
-				0, 0, 1,
-				NPHY_REV7_RFCTRLOVERRIDE_ID1);
-			pi->nphy_sample_play_lpf_bw_ctl_ovr = false;
-		}
+	write_phy_reg(pi, 0xa6, afectrlCore1_save);
+	write_phy_reg(pi, 0xa7, afectrlCore2_save);
+	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+		write_phy_reg(pi, 0xf9, rfctrlMiscReg1_save);
+		write_phy_reg(pi, 0xfb, rfctrlMiscReg2_save);
+		write_phy_reg(pi, 0x8f, afectrlOverride1_save);
+		write_phy_reg(pi, 0xa5, afectrlOverride2_save);
+		write_phy_reg(pi, 0xe5, rfctrlOverrideAux0_save);
+		write_phy_reg(pi, 0xe6, rfctrlOverrideAux1_save);
+	} else {
+		write_phy_reg(pi, 0xa5, afectrlOverride1_save);
+		write_phy_reg(pi, 0x78, rfctrlcmd_save);
+		write_phy_reg(pi, 0xec, rfctrloverride_save);
+		write_phy_reg(pi, 0x7a, rfctrlrssiothers1_save);
+		write_phy_reg(pi, 0x7d, rfctrlrssiothers2_save);
 	}
 
-	if (pi->phyhang_avoid)
-		wlc_phy_stay_in_carriersearch_nphy(pi, false);
+	return rssi_out_val;
 }
 
-static u32 *brcms_phy_get_tx_pwrctrl_tbl(struct brcms_phy *pi)
+s16 wlc_phy_tempsense_nphy(struct brcms_phy *pi)
 {
-	u32 *tx_pwrctrl_tbl = NULL;
-	uint phyrev = pi->pubpi.phy_rev;
+	u16 core1_txrf_iqcal1_save, core1_txrf_iqcal2_save;
+	u16 core2_txrf_iqcal1_save, core2_txrf_iqcal2_save;
+	u16 pwrdet_rxtx_core1_save;
+	u16 pwrdet_rxtx_core2_save;
+	u16 afectrlCore1_save;
+	u16 afectrlCore2_save;
+	u16 afectrlOverride_save;
+	u16 afectrlOverride2_save;
+	u16 pd_pll_ts_save;
+	u16 gpioSel_save;
+	s32 radio_temp[4];
+	s32 radio_temp2[4];
+	u16 syn_tempprocsense_save;
+	s16 offset = 0;
 
-	if (PHY_IPA(pi)) {
-		tx_pwrctrl_tbl =
-			wlc_phy_get_ipa_gaintbl_nphy(pi);
-	} else {
-		if (CHSPEC_IS5G(pi->radio_chanspec)) {
-			if (NREV_IS(phyrev, 3))
-				tx_pwrctrl_tbl = nphy_tpc_5GHz_txgain_rev3;
-			else if (NREV_IS(phyrev, 4))
-				tx_pwrctrl_tbl =
-					(pi->srom_fem5g.extpagain == 3) ?
-					nphy_tpc_5GHz_txgain_HiPwrEPA :
-					nphy_tpc_5GHz_txgain_rev4;
-			else
-				tx_pwrctrl_tbl = nphy_tpc_5GHz_txgain_rev5;
-		} else {
-			if (NREV_GE(phyrev, 7)) {
-				if (pi->pubpi.radiorev == 3)
-					tx_pwrctrl_tbl =
-						nphy_tpc_txgain_epa_2057rev3;
-				else if (pi->pubpi.radiorev == 5)
-					tx_pwrctrl_tbl =
-						nphy_tpc_txgain_epa_2057rev5;
-			} else {
-				if (NREV_GE(phyrev, 5) &&
-				   (pi->srom_fem2g.extpagain ==	3))
-					tx_pwrctrl_tbl =
-						nphy_tpc_txgain_HiPwrEPA;
-				else
-					tx_pwrctrl_tbl =
-						nphy_tpc_txgain_rev3;
-			}
-		}
-	}
-	return tx_pwrctrl_tbl;
-}
+	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+		u16 auxADC_Vmid, auxADC_Av, auxADC_Vmid_save, auxADC_Av_save;
+		u16 auxADC_rssi_ctrlL_save, auxADC_rssi_ctrlH_save;
+		u16 auxADC_rssi_ctrlL, auxADC_rssi_ctrlH;
+		s32 auxADC_Vl;
+		u16 RfctrlOverride5_save, RfctrlOverride6_save;
+		u16 RfctrlMiscReg5_save, RfctrlMiscReg6_save;
+		u16 RSSIMultCoef0QPowerDet_save;
+		u16 tempsense_Rcal;
 
-struct nphy_txgains wlc_phy_get_tx_gain_nphy(struct brcms_phy *pi)
-{
-	u16 base_idx[2], curr_gain[2];
-	u8 core_no;
-	struct nphy_txgains target_gain;
-	u32 *tx_pwrctrl_tbl = NULL;
+		syn_tempprocsense_save =
+			read_radio_reg(pi, RADIO_2057_TEMPSENSE_CONFIG);
 
-	if (pi->nphy_txpwrctrl == PHY_TPC_HW_OFF) {
-		if (pi->phyhang_avoid)
-			wlc_phy_stay_in_carriersearch_nphy(pi, true);
+		afectrlCore1_save = read_phy_reg(pi, 0xa6);
+		afectrlCore2_save = read_phy_reg(pi, 0xa7);
+		afectrlOverride_save = read_phy_reg(pi, 0x8f);
+		afectrlOverride2_save = read_phy_reg(pi, 0xa5);
+		RSSIMultCoef0QPowerDet_save = read_phy_reg(pi, 0x1ae);
+		RfctrlOverride5_save = read_phy_reg(pi, 0x346);
+		RfctrlOverride6_save = read_phy_reg(pi, 0x347);
+		RfctrlMiscReg5_save = read_phy_reg(pi, 0x344);
+		RfctrlMiscReg6_save = read_phy_reg(pi, 0x345);
 
-		wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x110, 16,
-					curr_gain);
+		wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x0A, 16,
+					&auxADC_Vmid_save);
+		wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x0E, 16,
+					&auxADC_Av_save);
+		wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x02, 16,
+					&auxADC_rssi_ctrlL_save);
+		wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x03, 16,
+					&auxADC_rssi_ctrlH_save);
 
-		if (pi->phyhang_avoid)
-			wlc_phy_stay_in_carriersearch_nphy(pi, false);
+		write_phy_reg(pi, 0x1ae, 0x0);
 
-		for (core_no = 0; core_no < 2; core_no++) {
-			if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-				target_gain.ipa[core_no] =
-					curr_gain[core_no] & 0x0007;
-				target_gain.pad[core_no] =
-					((curr_gain[core_no] & 0x00F8) >> 3);
-				target_gain.pga[core_no] =
-					((curr_gain[core_no] & 0x0F00) >> 8);
-				target_gain.txgm[core_no] =
-					((curr_gain[core_no] & 0x7000) >> 12);
-				target_gain.txlpf[core_no] =
-					((curr_gain[core_no] & 0x8000) >> 15);
-			} else if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-				target_gain.ipa[core_no] =
-					curr_gain[core_no] & 0x000F;
-				target_gain.pad[core_no] =
-					((curr_gain[core_no] & 0x00F0) >> 4);
-				target_gain.pga[core_no] =
-					((curr_gain[core_no] & 0x0F00) >> 8);
-				target_gain.txgm[core_no] =
-					((curr_gain[core_no] & 0x7000) >> 12);
-			} else {
-				target_gain.ipa[core_no] =
-					curr_gain[core_no] & 0x0003;
-				target_gain.pad[core_no] =
-					((curr_gain[core_no] & 0x000C) >> 2);
-				target_gain.pga[core_no] =
-					((curr_gain[core_no] & 0x0070) >> 4);
-				target_gain.txgm[core_no] =
-					((curr_gain[core_no] & 0x0380) >> 7);
-			}
-		}
-	} else {
-		uint phyrev = pi->pubpi.phy_rev;
+		auxADC_rssi_ctrlL = 0x0;
+		auxADC_rssi_ctrlH = 0x20;
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x02, 16,
+					 &auxADC_rssi_ctrlL);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x03, 16,
+					 &auxADC_rssi_ctrlH);
+
+		tempsense_Rcal = syn_tempprocsense_save & 0x1c;
+
+		write_radio_reg(pi, RADIO_2057_TEMPSENSE_CONFIG,
+				tempsense_Rcal | 0x01);
+
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 1),
+						  1, 0, 0,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID2);
+		mod_phy_reg(pi, 0xa6, (0x1 << 7), 0);
+		mod_phy_reg(pi, 0xa7, (0x1 << 7), 0);
+		mod_phy_reg(pi, 0x8f, (0x1 << 7), (0x1 << 7));
+		mod_phy_reg(pi, 0xa5, (0x1 << 7), (0x1 << 7));
+
+		mod_phy_reg(pi, 0xa6, (0x1 << 2), (0x1 << 2));
+		mod_phy_reg(pi, 0xa7, (0x1 << 2), (0x1 << 2));
+		mod_phy_reg(pi, 0x8f, (0x1 << 2), (0x1 << 2));
+		mod_phy_reg(pi, 0xa5, (0x1 << 2), (0x1 << 2));
+		udelay(5);
+		mod_phy_reg(pi, 0xa6, (0x1 << 2), 0);
+		mod_phy_reg(pi, 0xa7, (0x1 << 2), 0);
+		mod_phy_reg(pi, 0xa6, (0x1 << 3), 0);
+		mod_phy_reg(pi, 0xa7, (0x1 << 3), 0);
+		mod_phy_reg(pi, 0x8f, (0x1 << 3), (0x1 << 3));
+		mod_phy_reg(pi, 0xa5, (0x1 << 3), (0x1 << 3));
+		mod_phy_reg(pi, 0xa6, (0x1 << 6), 0);
+		mod_phy_reg(pi, 0xa7, (0x1 << 6), 0);
+		mod_phy_reg(pi, 0x8f, (0x1 << 6), (0x1 << 6));
+		mod_phy_reg(pi, 0xa5, (0x1 << 6), (0x1 << 6));
+
+		auxADC_Vmid = 0xA3;
+		auxADC_Av = 0x0;
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x0A, 16,
+					 &auxADC_Vmid);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x0E, 16,
+					 &auxADC_Av);
 
-		base_idx[0] = (read_phy_reg(pi, 0x1ed) >> 8) & 0x7f;
-		base_idx[1] = (read_phy_reg(pi, 0x1ee) >> 8) & 0x7f;
-		for (core_no = 0; core_no < 2; core_no++) {
-			if (NREV_GE(phyrev, 3)) {
-				tx_pwrctrl_tbl =
-					brcms_phy_get_tx_pwrctrl_tbl(pi);
-				if (NREV_GE(phyrev, 7)) {
-					target_gain.ipa[core_no] =
-						(tx_pwrctrl_tbl
-						 [base_idx[core_no]]
-						 >> 16) & 0x7;
-					target_gain.pad[core_no] =
-						(tx_pwrctrl_tbl
-						 [base_idx[core_no]]
-						 >> 19) & 0x1f;
-					target_gain.pga[core_no] =
-						(tx_pwrctrl_tbl
-						 [base_idx[core_no]]
-						 >> 24) & 0xf;
-					target_gain.txgm[core_no] =
-						(tx_pwrctrl_tbl
-						 [base_idx[core_no]]
-						 >> 28) & 0x7;
-					target_gain.txlpf[core_no] =
-						(tx_pwrctrl_tbl
-						 [base_idx[core_no]]
-						 >> 31) & 0x1;
-				} else {
-					target_gain.ipa[core_no] =
-						(tx_pwrctrl_tbl
-						 [base_idx[core_no]]
-						 >> 16) & 0xf;
-					target_gain.pad[core_no] =
-						(tx_pwrctrl_tbl
-						 [base_idx[core_no]]
-						 >> 20) & 0xf;
-					target_gain.pga[core_no] =
-						(tx_pwrctrl_tbl
-						 [base_idx[core_no]]
-						 >> 24) & 0xf;
-					target_gain.txgm[core_no] =
-						(tx_pwrctrl_tbl
-						[base_idx[core_no]]
-						 >> 28) & 0x7;
-				}
-			} else {
-				target_gain.ipa[core_no] =
-					(nphy_tpc_txgain[base_idx[core_no]] >>
-					 16) & 0x3;
-				target_gain.pad[core_no] =
-					(nphy_tpc_txgain[base_idx[core_no]] >>
-					 18) & 0x3;
-				target_gain.pga[core_no] =
-					(nphy_tpc_txgain[base_idx[core_no]] >>
-					 20) & 0x7;
-				target_gain.txgm[core_no] =
-					(nphy_tpc_txgain[base_idx[core_no]] >>
-					 23) & 0x7;
-			}
+		udelay(3);
+
+		wlc_phy_poll_rssi_nphy(pi, NPHY_RSSI_SEL_IQ, radio_temp, 1);
+		write_radio_reg(pi, RADIO_2057_TEMPSENSE_CONFIG,
+				tempsense_Rcal | 0x03);
+
+		udelay(5);
+		wlc_phy_poll_rssi_nphy(pi, NPHY_RSSI_SEL_IQ, radio_temp2, 1);
+
+		auxADC_Av = 0x7;
+		if (radio_temp[1] + radio_temp2[1] < -30) {
+			auxADC_Vmid = 0x45;
+			auxADC_Vl = 263;
+		} else if (radio_temp[1] + radio_temp2[1] < -9) {
+			auxADC_Vmid = 0x200;
+			auxADC_Vl = 467;
+		} else if (radio_temp[1] + radio_temp2[1] < 11) {
+			auxADC_Vmid = 0x266;
+			auxADC_Vl = 634;
+		} else {
+			auxADC_Vmid = 0x2D5;
+			auxADC_Vl = 816;
 		}
-	}
 
-	return target_gain;
-}
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x0A, 16,
+					 &auxADC_Vmid);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x0E, 16,
+					 &auxADC_Av);
 
-static void
-wlc_phy_iqcal_gainparams_nphy(struct brcms_phy *pi, u16 core_no,
-			      struct nphy_txgains target_gain,
-			      struct nphy_iqcal_params *params)
-{
-	u8 k;
-	int idx;
-	u16 gain_index;
-	u8 band_idx = (CHSPEC_IS5G(pi->radio_chanspec) ? 1 : 0);
+		udelay(3);
 
-	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-		if (NREV_GE(pi->pubpi.phy_rev, 7))
-			params->txlpf = target_gain.txlpf[core_no];
+		wlc_phy_poll_rssi_nphy(pi, NPHY_RSSI_SEL_IQ, radio_temp2, 1);
+		write_radio_reg(pi, RADIO_2057_TEMPSENSE_CONFIG,
+				tempsense_Rcal | 0x01);
 
-		params->txgm = target_gain.txgm[core_no];
-		params->pga = target_gain.pga[core_no];
-		params->pad = target_gain.pad[core_no];
-		params->ipa = target_gain.ipa[core_no];
-		if (NREV_GE(pi->pubpi.phy_rev, 7))
-			params->cal_gain =
-				((params->txlpf << 15) | (params->txgm << 12) |
-				 (params->pga << 8) |
-				 (params->pad << 3) | (params->ipa));
-		else
-			params->cal_gain =
-				((params->txgm << 12) | (params->pga << 8) |
-				 (params->pad << 4) | (params->ipa));
+		udelay(5);
+		wlc_phy_poll_rssi_nphy(pi, NPHY_RSSI_SEL_IQ, radio_temp, 1);
 
-		params->ncorr[0] = 0x79;
-		params->ncorr[1] = 0x79;
-		params->ncorr[2] = 0x79;
-		params->ncorr[3] = 0x79;
-		params->ncorr[4] = 0x79;
-	} else {
+		write_radio_reg(pi, RADIO_2057_TEMPSENSE_CONFIG,
+				syn_tempprocsense_save);
 
-		gain_index = ((target_gain.pad[core_no] << 0) |
-			      (target_gain.pga[core_no] << 4) |
-			      (target_gain.txgm[core_no] << 8));
+		write_phy_reg(pi, 0xa6, afectrlCore1_save);
+		write_phy_reg(pi, 0xa7, afectrlCore2_save);
+		write_phy_reg(pi, 0x8f, afectrlOverride_save);
+		write_phy_reg(pi, 0xa5, afectrlOverride2_save);
+		write_phy_reg(pi, 0x1ae, RSSIMultCoef0QPowerDet_save);
+		write_phy_reg(pi, 0x346, RfctrlOverride5_save);
+		write_phy_reg(pi, 0x347, RfctrlOverride6_save);
+		write_phy_reg(pi, 0x344, RfctrlMiscReg5_save);
+		write_phy_reg(pi, 0x345, RfctrlMiscReg5_save);
 
-		idx = -1;
-		for (k = 0; k < NPHY_IQCAL_NUMGAINS; k++) {
-			if (tbl_iqcal_gainparams_nphy[band_idx][k][0] ==
-			    gain_index) {
-				idx = k;
-				break;
-			}
-		}
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x0A, 16,
+					 &auxADC_Vmid_save);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x0E, 16,
+					 &auxADC_Av_save);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x02, 16,
+					 &auxADC_rssi_ctrlL_save);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x03, 16,
+					 &auxADC_rssi_ctrlH_save);
 
-		params->txgm = tbl_iqcal_gainparams_nphy[band_idx][k][1];
-		params->pga = tbl_iqcal_gainparams_nphy[band_idx][k][2];
-		params->pad = tbl_iqcal_gainparams_nphy[band_idx][k][3];
-		params->cal_gain = ((params->txgm << 7) | (params->pga << 4) |
-				    (params->pad << 2));
-		params->ncorr[0] = tbl_iqcal_gainparams_nphy[band_idx][k][4];
-		params->ncorr[1] = tbl_iqcal_gainparams_nphy[band_idx][k][5];
-		params->ncorr[2] = tbl_iqcal_gainparams_nphy[band_idx][k][6];
-		params->ncorr[3] = tbl_iqcal_gainparams_nphy[band_idx][k][7];
-	}
-}
+		radio_temp[0] = (179 * (radio_temp[1] + radio_temp2[1])
+				 + 82 * (auxADC_Vl) - 28861 +
+				 128) / 256;
 
-static void wlc_phy_txcal_radio_setup_nphy(struct brcms_phy *pi)
-{
-	u16 jtag_core, core;
+		offset = (s16) pi->phy_tempsense_offset;
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+	} else if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+		syn_tempprocsense_save =
+			read_radio_reg(pi, RADIO_2056_SYN_TEMPPROCSENSE);
 
-		for (core = 0; core <= 1; core++) {
+		afectrlCore1_save = read_phy_reg(pi, 0xa6);
+		afectrlCore2_save = read_phy_reg(pi, 0xa7);
+		afectrlOverride_save = read_phy_reg(pi, 0x8f);
+		afectrlOverride2_save = read_phy_reg(pi, 0xa5);
+		gpioSel_save = read_phy_reg(pi, 0xca);
 
-			pi->tx_rx_cal_radio_saveregs[(core * 11) + 0] =
-				READ_RADIO_REG3(pi, RADIO_2057, TX, core,
-						TX_SSI_MASTER);
+		write_radio_reg(pi, RADIO_2056_SYN_TEMPPROCSENSE, 0x01);
 
-			pi->tx_rx_cal_radio_saveregs[(core * 11) + 1] =
-				READ_RADIO_REG3(pi, RADIO_2057, TX, core,
-						IQCAL_VCM_HG);
+		wlc_phy_poll_rssi_nphy(pi, NPHY_RSSI_SEL_IQ, radio_temp, 1);
+		if (NREV_LT(pi->pubpi.phy_rev, 7))
+			write_radio_reg(pi, RADIO_2056_SYN_TEMPPROCSENSE, 0x05);
 
-			pi->tx_rx_cal_radio_saveregs[(core * 11) + 2] =
-				READ_RADIO_REG3(pi, RADIO_2057, TX, core,
-						IQCAL_IDAC);
+		wlc_phy_poll_rssi_nphy(pi, NPHY_RSSI_SEL_IQ, radio_temp2, 1);
+		if (NREV_GE(pi->pubpi.phy_rev, 7))
+			write_radio_reg(pi, RADIO_2057_TEMPSENSE_CONFIG, 0x01);
+		else
+			write_radio_reg(pi, RADIO_2056_SYN_TEMPPROCSENSE, 0x01);
 
-			pi->tx_rx_cal_radio_saveregs[(core * 11) + 3] =
-				READ_RADIO_REG3(pi, RADIO_2057, TX, core,
-						TSSI_VCM);
+		radio_temp[0] =
+			(126 * (radio_temp[1] + radio_temp2[1]) + 3987) / 64;
 
-			pi->tx_rx_cal_radio_saveregs[(core * 11) + 4] = 0;
+		write_radio_reg(pi, RADIO_2056_SYN_TEMPPROCSENSE,
+				syn_tempprocsense_save);
 
-			pi->tx_rx_cal_radio_saveregs[(core * 11) + 5] =
-				READ_RADIO_REG3(pi, RADIO_2057, TX, core,
-						TX_SSI_MUX);
+		write_phy_reg(pi, 0xca, gpioSel_save);
+		write_phy_reg(pi, 0xa6, afectrlCore1_save);
+		write_phy_reg(pi, 0xa7, afectrlCore2_save);
+		write_phy_reg(pi, 0x8f, afectrlOverride_save);
+		write_phy_reg(pi, 0xa5, afectrlOverride2_save);
 
-			if (pi->pubpi.radiorev != 5)
-				pi->tx_rx_cal_radio_saveregs[(core * 11) + 6] =
-					READ_RADIO_REG3(pi, RADIO_2057, TX,
-							core,
-							TSSIA);
+		offset = (s16) pi->phy_tempsense_offset;
+	} else {
+
+		pwrdet_rxtx_core1_save =
+			read_radio_reg(pi, RADIO_2055_PWRDET_RXTX_CORE1);
+		pwrdet_rxtx_core2_save =
+			read_radio_reg(pi, RADIO_2055_PWRDET_RXTX_CORE2);
+		core1_txrf_iqcal1_save =
+			read_radio_reg(pi, RADIO_2055_CORE1_TXRF_IQCAL1);
+		core1_txrf_iqcal2_save =
+			read_radio_reg(pi, RADIO_2055_CORE1_TXRF_IQCAL2);
+		core2_txrf_iqcal1_save =
+			read_radio_reg(pi, RADIO_2055_CORE2_TXRF_IQCAL1);
+		core2_txrf_iqcal2_save =
+			read_radio_reg(pi, RADIO_2055_CORE2_TXRF_IQCAL2);
+		pd_pll_ts_save = read_radio_reg(pi, RADIO_2055_PD_PLL_TS);
+
+		afectrlCore1_save = read_phy_reg(pi, 0xa6);
+		afectrlCore2_save = read_phy_reg(pi, 0xa7);
+		afectrlOverride_save = read_phy_reg(pi, 0xa5);
+		gpioSel_save = read_phy_reg(pi, 0xca);
+
+		write_radio_reg(pi, RADIO_2055_CORE1_TXRF_IQCAL1, 0x01);
+		write_radio_reg(pi, RADIO_2055_CORE2_TXRF_IQCAL1, 0x01);
+		write_radio_reg(pi, RADIO_2055_CORE1_TXRF_IQCAL2, 0x08);
+		write_radio_reg(pi, RADIO_2055_CORE2_TXRF_IQCAL2, 0x08);
+		write_radio_reg(pi, RADIO_2055_PWRDET_RXTX_CORE1, 0x04);
+		write_radio_reg(pi, RADIO_2055_PWRDET_RXTX_CORE2, 0x04);
+		write_radio_reg(pi, RADIO_2055_PD_PLL_TS, 0x00);
+
+		wlc_phy_poll_rssi_nphy(pi, NPHY_RSSI_SEL_IQ, radio_temp, 1);
+		xor_radio_reg(pi, RADIO_2055_CAL_TS, 0x80);
+
+		wlc_phy_poll_rssi_nphy(pi, NPHY_RSSI_SEL_IQ, radio_temp, 1);
+		xor_radio_reg(pi, RADIO_2055_CAL_TS, 0x80);
 
-			pi->tx_rx_cal_radio_saveregs[(core * 11) + 7] =
-			       READ_RADIO_REG3(pi, RADIO_2057, TX, core, TSSIG);
+		wlc_phy_poll_rssi_nphy(pi, NPHY_RSSI_SEL_IQ, radio_temp2, 1);
+		xor_radio_reg(pi, RADIO_2055_CAL_TS, 0x80);
 
-			pi->tx_rx_cal_radio_saveregs[(core * 11) + 8] =
-				READ_RADIO_REG3(pi, RADIO_2057, TX, core,
-						TSSI_MISC1);
+		radio_temp[0] = (radio_temp[0] + radio_temp2[0]);
+		radio_temp[1] = (radio_temp[1] + radio_temp2[1]);
+		radio_temp[2] = (radio_temp[2] + radio_temp2[2]);
+		radio_temp[3] = (radio_temp[3] + radio_temp2[3]);
 
-			if (CHSPEC_IS5G(pi->radio_chanspec)) {
-				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
-						 TX_SSI_MASTER, 0x0a);
-				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
-						 IQCAL_VCM_HG, 0x43);
-				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
-						 IQCAL_IDAC, 0x55);
-				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
-						 TSSI_VCM, 0x00);
-				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
-						 TSSIG, 0x00);
-				if (pi->use_int_tx_iqlo_cal_nphy) {
-					WRITE_RADIO_REG3(pi, RADIO_2057, TX,
-							 core, TX_SSI_MUX, 0x4);
-					if (!(pi->
-					internal_tx_iqlo_cal_tapoff_intpa_nphy))
-						WRITE_RADIO_REG3(pi, RADIO_2057,
-								 TX, core,
-								 TSSIA, 0x31);
-					else
-						WRITE_RADIO_REG3(pi, RADIO_2057,
-								 TX, core,
-								 TSSIA, 0x21);
-				}
-				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
-						 TSSI_MISC1, 0x00);
-			} else {
-				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
-						 TX_SSI_MASTER, 0x06);
-				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
-						 IQCAL_VCM_HG, 0x43);
-				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
-						 IQCAL_IDAC, 0x55);
-				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
-						 TSSI_VCM, 0x00);
+		radio_temp[0] =
+			(radio_temp[0] + radio_temp[1] + radio_temp[2] +
+			 radio_temp[3]);
 
-				if (pi->pubpi.radiorev != 5)
-					WRITE_RADIO_REG3(pi, RADIO_2057, TX,
-							 core, TSSIA, 0x00);
-				if (pi->use_int_tx_iqlo_cal_nphy) {
-					WRITE_RADIO_REG3(pi, RADIO_2057, TX,
-							 core, TX_SSI_MUX,
-							 0x06);
-					if (!(pi->
-					internal_tx_iqlo_cal_tapoff_intpa_nphy))
-						WRITE_RADIO_REG3(pi, RADIO_2057,
-								 TX, core,
-								 TSSIG, 0x31);
-					else
-						WRITE_RADIO_REG3(pi, RADIO_2057,
-								 TX, core,
-								 TSSIG, 0x21);
-				}
-				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
-						 TSSI_MISC1, 0x00);
-			}
-		}
-	} else if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+		radio_temp[0] =
+			(radio_temp[0] +
+			 (8 * 32)) * (950 - 350) / 63 + (350 * 8);
 
-		for (core = 0; core <= 1; core++) {
-			jtag_core =
-				(core ==
-				 PHY_CORE_0) ? RADIO_2056_TX0 : RADIO_2056_TX1;
+		radio_temp[0] = (radio_temp[0] - (8 * 420)) / 38;
 
-			pi->tx_rx_cal_radio_saveregs[(core * 11) + 0] =
-				read_radio_reg(pi,
-					       RADIO_2056_TX_TX_SSI_MASTER |
-					       jtag_core);
+		write_radio_reg(pi, RADIO_2055_PWRDET_RXTX_CORE1,
+				pwrdet_rxtx_core1_save);
+		write_radio_reg(pi, RADIO_2055_PWRDET_RXTX_CORE2,
+				pwrdet_rxtx_core2_save);
+		write_radio_reg(pi, RADIO_2055_CORE1_TXRF_IQCAL1,
+				core1_txrf_iqcal1_save);
+		write_radio_reg(pi, RADIO_2055_CORE2_TXRF_IQCAL1,
+				core2_txrf_iqcal1_save);
+		write_radio_reg(pi, RADIO_2055_CORE1_TXRF_IQCAL2,
+				core1_txrf_iqcal2_save);
+		write_radio_reg(pi, RADIO_2055_CORE2_TXRF_IQCAL2,
+				core2_txrf_iqcal2_save);
+		write_radio_reg(pi, RADIO_2055_PD_PLL_TS, pd_pll_ts_save);
 
-			pi->tx_rx_cal_radio_saveregs[(core * 11) + 1] =
-				read_radio_reg(pi,
-					       RADIO_2056_TX_IQCAL_VCM_HG |
-					       jtag_core);
+		write_phy_reg(pi, 0xca, gpioSel_save);
+		write_phy_reg(pi, 0xa6, afectrlCore1_save);
+		write_phy_reg(pi, 0xa7, afectrlCore2_save);
+		write_phy_reg(pi, 0xa5, afectrlOverride_save);
+	}
 
-			pi->tx_rx_cal_radio_saveregs[(core * 11) + 2] =
-				read_radio_reg(pi,
-					       RADIO_2056_TX_IQCAL_IDAC |
-					       jtag_core);
+	return (s16) radio_temp[0] + offset;
+}
 
-			pi->tx_rx_cal_radio_saveregs[(core * 11) + 3] =
-				read_radio_reg(
-					pi,
-					RADIO_2056_TX_TSSI_VCM |
-					jtag_core);
+static void
+wlc_phy_set_rssi_2055_vcm(struct brcms_phy *pi, u8 rssi_type, u8 *vcm_buf)
+{
+	u8 core;
 
-			pi->tx_rx_cal_radio_saveregs[(core * 11) + 4] =
-				read_radio_reg(pi,
-					       RADIO_2056_TX_TX_AMP_DET |
-					       jtag_core);
+	for (core = 0; core < pi->pubpi.phy_corenum; core++) {
+		if (rssi_type == NPHY_RSSI_SEL_NB) {
+			if (core == PHY_CORE_0) {
+				mod_radio_reg(pi,
+					      RADIO_2055_CORE1_B0_NBRSSI_VCM,
+					      RADIO_2055_NBRSSI_VCM_I_MASK,
+					      vcm_buf[2 *
+						      core] <<
+					      RADIO_2055_NBRSSI_VCM_I_SHIFT);
+				mod_radio_reg(pi,
+					      RADIO_2055_CORE1_RXBB_RSSI_CTRL5,
+					      RADIO_2055_NBRSSI_VCM_Q_MASK,
+					      vcm_buf[2 * core +
+						      1] <<
+					      RADIO_2055_NBRSSI_VCM_Q_SHIFT);
+			} else {
+				mod_radio_reg(pi,
+					      RADIO_2055_CORE2_B0_NBRSSI_VCM,
+					      RADIO_2055_NBRSSI_VCM_I_MASK,
+					      vcm_buf[2 *
+						      core] <<
+					      RADIO_2055_NBRSSI_VCM_I_SHIFT);
+				mod_radio_reg(pi,
+					      RADIO_2055_CORE2_RXBB_RSSI_CTRL5,
+					      RADIO_2055_NBRSSI_VCM_Q_MASK,
+					      vcm_buf[2 * core +
+						      1] <<
+					      RADIO_2055_NBRSSI_VCM_Q_SHIFT);
+			}
+		} else {
+			if (core == PHY_CORE_0)
+				mod_radio_reg(pi,
+					      RADIO_2055_CORE1_RXBB_RSSI_CTRL5,
+					      RADIO_2055_WBRSSI_VCM_IQ_MASK,
+					      vcm_buf[2 *
+						      core] <<
+					      RADIO_2055_WBRSSI_VCM_IQ_SHIFT);
+			else
+				mod_radio_reg(pi,
+					      RADIO_2055_CORE2_RXBB_RSSI_CTRL5,
+					      RADIO_2055_WBRSSI_VCM_IQ_MASK,
+					      vcm_buf[2 *
+						      core] <<
+					      RADIO_2055_WBRSSI_VCM_IQ_SHIFT);
+		}
+	}
+}
 
-			pi->tx_rx_cal_radio_saveregs[(core * 11) + 5] =
-				read_radio_reg(pi,
-					       RADIO_2056_TX_TX_SSI_MUX |
-					       jtag_core);
+static void wlc_phy_rssi_cal_nphy_rev3(struct brcms_phy *pi)
+{
+	u16 classif_state;
+	u16 clip_state[2];
+	u16 clip_off[] = { 0xffff, 0xffff };
+	s32 target_code;
+	u8 vcm, min_vcm;
+	u8 vcm_final = 0;
+	u8 result_idx;
+	s32 poll_results[8][4] = {
+		{0, 0, 0, 0},
+		{0, 0, 0, 0},
+		{0, 0, 0, 0},
+		{0, 0, 0, 0},
+		{0, 0, 0, 0},
+		{0, 0, 0, 0},
+		{0, 0, 0, 0},
+		{0, 0, 0, 0}
+	};
+	s32 poll_result_core[4] = { 0, 0, 0, 0 };
+	s32 min_d = NPHY_RSSICAL_MAXD, curr_d;
+	s32 fine_digital_offset[4];
+	s32 poll_results_min[4] = { 0, 0, 0, 0 };
+	s32 min_poll;
+	u8 vcm_level_max;
+	u8 core;
+	u8 wb_cnt;
+	u8 rssi_type;
+	u16 NPHY_Rfctrlintc1_save, NPHY_Rfctrlintc2_save;
+	u16 NPHY_AfectrlOverride1_save, NPHY_AfectrlOverride2_save;
+	u16 NPHY_AfectrlCore1_save, NPHY_AfectrlCore2_save;
+	u16 NPHY_RfctrlOverride0_save, NPHY_RfctrlOverride1_save;
+	u16 NPHY_RfctrlOverrideAux0_save, NPHY_RfctrlOverrideAux1_save;
+	u16 NPHY_RfctrlCmd_save;
+	u16 NPHY_RfctrlMiscReg1_save, NPHY_RfctrlMiscReg2_save;
+	u16 NPHY_RfctrlRSSIOTHERS1_save, NPHY_RfctrlRSSIOTHERS2_save;
+	u8 rxcore_state;
+	u16 NPHY_REV7_RfctrlOverride3_save, NPHY_REV7_RfctrlOverride4_save;
+	u16 NPHY_REV7_RfctrlOverride5_save, NPHY_REV7_RfctrlOverride6_save;
+	u16 NPHY_REV7_RfctrlMiscReg3_save, NPHY_REV7_RfctrlMiscReg4_save;
+	u16 NPHY_REV7_RfctrlMiscReg5_save, NPHY_REV7_RfctrlMiscReg6_save;
 
-			pi->tx_rx_cal_radio_saveregs[(core * 11) + 6] =
-				read_radio_reg(pi,
-					       RADIO_2056_TX_TSSIA | jtag_core);
+	NPHY_REV7_RfctrlOverride3_save =
+		NPHY_REV7_RfctrlOverride4_save =
+		NPHY_REV7_RfctrlOverride5_save =
+		NPHY_REV7_RfctrlOverride6_save =
+		NPHY_REV7_RfctrlMiscReg3_save =
+		NPHY_REV7_RfctrlMiscReg4_save =
+		NPHY_REV7_RfctrlMiscReg5_save =
+		NPHY_REV7_RfctrlMiscReg6_save = 0;
 
-			pi->tx_rx_cal_radio_saveregs[(core * 11) + 7] =
-				read_radio_reg(pi,
-					       RADIO_2056_TX_TSSIG | jtag_core);
+	classif_state = wlc_phy_classifier_nphy(pi, 0, 0);
+	wlc_phy_classifier_nphy(pi, (0x7 << 0), 4);
+	wlc_phy_clip_det_nphy(pi, 0, clip_state);
+	wlc_phy_clip_det_nphy(pi, 1, clip_off);
+
+	NPHY_Rfctrlintc1_save = read_phy_reg(pi, 0x91);
+	NPHY_Rfctrlintc2_save = read_phy_reg(pi, 0x92);
+	NPHY_AfectrlOverride1_save = read_phy_reg(pi, 0x8f);
+	NPHY_AfectrlOverride2_save = read_phy_reg(pi, 0xa5);
+	NPHY_AfectrlCore1_save = read_phy_reg(pi, 0xa6);
+	NPHY_AfectrlCore2_save = read_phy_reg(pi, 0xa7);
+	NPHY_RfctrlOverride0_save = read_phy_reg(pi, 0xe7);
+	NPHY_RfctrlOverride1_save = read_phy_reg(pi, 0xec);
+	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+		NPHY_REV7_RfctrlOverride3_save = read_phy_reg(pi, 0x342);
+		NPHY_REV7_RfctrlOverride4_save = read_phy_reg(pi, 0x343);
+		NPHY_REV7_RfctrlOverride5_save = read_phy_reg(pi, 0x346);
+		NPHY_REV7_RfctrlOverride6_save = read_phy_reg(pi, 0x347);
+	}
+	NPHY_RfctrlOverrideAux0_save = read_phy_reg(pi, 0xe5);
+	NPHY_RfctrlOverrideAux1_save = read_phy_reg(pi, 0xe6);
+	NPHY_RfctrlCmd_save = read_phy_reg(pi, 0x78);
+	NPHY_RfctrlMiscReg1_save = read_phy_reg(pi, 0xf9);
+	NPHY_RfctrlMiscReg2_save = read_phy_reg(pi, 0xfb);
+	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+		NPHY_REV7_RfctrlMiscReg3_save = read_phy_reg(pi, 0x340);
+		NPHY_REV7_RfctrlMiscReg4_save = read_phy_reg(pi, 0x341);
+		NPHY_REV7_RfctrlMiscReg5_save = read_phy_reg(pi, 0x344);
+		NPHY_REV7_RfctrlMiscReg6_save = read_phy_reg(pi, 0x345);
+	}
+	NPHY_RfctrlRSSIOTHERS1_save = read_phy_reg(pi, 0x7a);
+	NPHY_RfctrlRSSIOTHERS2_save = read_phy_reg(pi, 0x7d);
 
-			pi->tx_rx_cal_radio_saveregs[(core * 11) + 8] =
-				read_radio_reg(pi,
-					       RADIO_2056_TX_TSSI_MISC1 |
-					       jtag_core);
+	wlc_phy_rfctrlintc_override_nphy(pi, NPHY_RfctrlIntc_override_OFF, 0,
+					 RADIO_MIMO_CORESEL_ALLRXTX);
+	wlc_phy_rfctrlintc_override_nphy(pi, NPHY_RfctrlIntc_override_TRSW, 1,
+					 RADIO_MIMO_CORESEL_ALLRXTX);
 
-			pi->tx_rx_cal_radio_saveregs[(core * 11) + 9] =
-				read_radio_reg(pi,
-					       RADIO_2056_TX_TSSI_MISC2 |
-					       jtag_core);
+	if (NREV_GE(pi->pubpi.phy_rev, 7))
+		wlc_phy_rfctrl_override_1tomany_nphy(
+			pi,
+			NPHY_REV7_RfctrlOverride_cmd_rxrf_pu,
+			0, 0, 0);
+	else
+		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 0), 0, 0, 0);
 
-			pi->tx_rx_cal_radio_saveregs[(core * 11) + 10] =
-				read_radio_reg(pi,
-					       RADIO_2056_TX_TSSI_MISC3 |
-					       jtag_core);
+	if (NREV_GE(pi->pubpi.phy_rev, 7))
+		wlc_phy_rfctrl_override_1tomany_nphy(
+			pi,
+			NPHY_REV7_RfctrlOverride_cmd_rx_pu,
+			1, 0, 0);
+	else
+		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 1), 1, 0, 0);
 
-			if (CHSPEC_IS5G(pi->radio_chanspec)) {
-				write_radio_reg(pi,
-						RADIO_2056_TX_TX_SSI_MASTER |
-						jtag_core, 0x0a);
-				write_radio_reg(pi,
-						RADIO_2056_TX_IQCAL_VCM_HG |
-						jtag_core, 0x40);
-				write_radio_reg(pi,
-						RADIO_2056_TX_IQCAL_IDAC |
-						jtag_core, 0x55);
-				write_radio_reg(pi,
-						RADIO_2056_TX_TSSI_VCM |
-						jtag_core, 0x00);
-				write_radio_reg(pi,
-						RADIO_2056_TX_TX_AMP_DET |
-						jtag_core, 0x00);
+	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 7),
+						  1, 0, 0,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID0);
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 6), 1, 0, 0,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID0);
+	} else {
+		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 7), 1, 0, 0);
+		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 6), 1, 0, 0);
+	}
 
-				if (PHY_IPA(pi)) {
-					write_radio_reg(
-						pi,
-						RADIO_2056_TX_TX_SSI_MUX
-						| jtag_core, 0x4);
-					write_radio_reg(pi,
-							RADIO_2056_TX_TSSIA |
-							jtag_core, 0x1);
-				} else {
-					write_radio_reg(
-						pi,
-						RADIO_2056_TX_TX_SSI_MUX
-						| jtag_core, 0x00);
-					write_radio_reg(pi,
-							RADIO_2056_TX_TSSIA |
-							jtag_core, 0x2f);
-				}
-				write_radio_reg(pi,
-						RADIO_2056_TX_TSSIG | jtag_core,
-						0x00);
-				write_radio_reg(pi,
-						RADIO_2056_TX_TSSI_MISC1 |
-						jtag_core, 0x00);
+	if (CHSPEC_IS5G(pi->radio_chanspec)) {
+		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 5),
+				0, 0, 0,
+				NPHY_REV7_RFCTRLOVERRIDE_ID0);
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 4), 1, 0,
+				0,
+				NPHY_REV7_RFCTRLOVERRIDE_ID0);
+		} else {
+			wlc_phy_rfctrl_override_nphy(pi, (0x1 << 5), 0, 0, 0);
+			wlc_phy_rfctrl_override_nphy(pi, (0x1 << 4), 1, 0, 0);
+		}
 
-				write_radio_reg(pi,
-						RADIO_2056_TX_TSSI_MISC2 |
-						jtag_core, 0x00);
-				write_radio_reg(pi,
-						RADIO_2056_TX_TSSI_MISC3 |
-						jtag_core, 0x00);
-			} else {
-				write_radio_reg(pi,
-						RADIO_2056_TX_TX_SSI_MASTER |
-						jtag_core, 0x06);
-				write_radio_reg(pi,
-						RADIO_2056_TX_IQCAL_VCM_HG |
-						jtag_core, 0x40);
-				write_radio_reg(pi,
-						RADIO_2056_TX_IQCAL_IDAC |
-						jtag_core, 0x55);
-				write_radio_reg(pi,
-						RADIO_2056_TX_TSSI_VCM |
-						jtag_core, 0x00);
-				write_radio_reg(pi,
-						RADIO_2056_TX_TX_AMP_DET |
-						jtag_core, 0x00);
-				write_radio_reg(pi,
-						RADIO_2056_TX_TSSIA | jtag_core,
-						0x00);
+	} else {
+		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 4),
+				0, 0, 0,
+				NPHY_REV7_RFCTRLOVERRIDE_ID0);
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 5), 1, 0,
+				0,
+				NPHY_REV7_RFCTRLOVERRIDE_ID0);
+		} else {
+			wlc_phy_rfctrl_override_nphy(pi, (0x1 << 4), 0, 0, 0);
+			wlc_phy_rfctrl_override_nphy(pi, (0x1 << 5), 1, 0, 0);
+		}
+	}
 
-				if (PHY_IPA(pi)) {
+	rxcore_state = wlc_phy_rxcore_getstate_nphy(
+		(struct brcms_phy_pub *) pi);
 
-					write_radio_reg(
-						pi,
-						RADIO_2056_TX_TX_SSI_MUX
-						| jtag_core, 0x06);
-					if (NREV_LT(pi->pubpi.phy_rev, 5))
-						write_radio_reg(
-							pi,
-							RADIO_2056_TX_TSSIG
-							| jtag_core,
-							0x11);
-					else
-						write_radio_reg(
-							pi,
-							RADIO_2056_TX_TSSIG
-							| jtag_core,
-							0x1);
-				} else {
-					write_radio_reg(
-						pi,
-						RADIO_2056_TX_TX_SSI_MUX
-						| jtag_core, 0x00);
-					write_radio_reg(pi,
-							RADIO_2056_TX_TSSIG |
-							jtag_core, 0x20);
-				}
+	vcm_level_max = 8;
 
-				write_radio_reg(pi,
-						RADIO_2056_TX_TSSI_MISC1 |
-						jtag_core, 0x00);
-				write_radio_reg(pi,
-						RADIO_2056_TX_TSSI_MISC2 |
-						jtag_core, 0x00);
-				write_radio_reg(pi,
-						RADIO_2056_TX_TSSI_MISC3 |
-						jtag_core, 0x00);
-			}
-		}
-	} else {
+	for (core = 0; core < pi->pubpi.phy_corenum; core++) {
 
-		pi->tx_rx_cal_radio_saveregs[0] =
-			read_radio_reg(pi, RADIO_2055_CORE1_TXRF_IQCAL1);
-		write_radio_reg(pi, RADIO_2055_CORE1_TXRF_IQCAL1, 0x29);
-		pi->tx_rx_cal_radio_saveregs[1] =
-			read_radio_reg(pi, RADIO_2055_CORE1_TXRF_IQCAL2);
-		write_radio_reg(pi, RADIO_2055_CORE1_TXRF_IQCAL2, 0x54);
+		if ((rxcore_state & (1 << core)) == 0)
+			continue;
 
-		pi->tx_rx_cal_radio_saveregs[2] =
-			read_radio_reg(pi, RADIO_2055_CORE2_TXRF_IQCAL1);
-		write_radio_reg(pi, RADIO_2055_CORE2_TXRF_IQCAL1, 0x29);
-		pi->tx_rx_cal_radio_saveregs[3] =
-			read_radio_reg(pi, RADIO_2055_CORE2_TXRF_IQCAL2);
-		write_radio_reg(pi, RADIO_2055_CORE2_TXRF_IQCAL2, 0x54);
+		wlc_phy_scale_offset_rssi_nphy(pi, 0x0, 0x0,
+					       core ==
+					       PHY_CORE_0 ?
+					       RADIO_MIMO_CORESEL_CORE1 :
+					       RADIO_MIMO_CORESEL_CORE2,
+					       NPHY_RAIL_I, NPHY_RSSI_SEL_NB);
+		wlc_phy_scale_offset_rssi_nphy(pi, 0x0, 0x0,
+					       core ==
+					       PHY_CORE_0 ?
+					       RADIO_MIMO_CORESEL_CORE1 :
+					       RADIO_MIMO_CORESEL_CORE2,
+					       NPHY_RAIL_Q, NPHY_RSSI_SEL_NB);
 
-		pi->tx_rx_cal_radio_saveregs[4] =
-			read_radio_reg(pi, RADIO_2055_PWRDET_RXTX_CORE1);
-		pi->tx_rx_cal_radio_saveregs[5] =
-			read_radio_reg(pi, RADIO_2055_PWRDET_RXTX_CORE2);
+		for (vcm = 0; vcm < vcm_level_max; vcm++) {
+			if (NREV_GE(pi->pubpi.phy_rev, 7))
+				mod_radio_reg(pi, (core == PHY_CORE_0) ?
+					      RADIO_2057_NB_MASTER_CORE0 :
+					      RADIO_2057_NB_MASTER_CORE1,
+					      RADIO_2057_VCM_MASK, vcm);
+			else
+				mod_radio_reg(pi, RADIO_2056_RX_RSSI_MISC |
+					      ((core ==
+						PHY_CORE_0) ? RADIO_2056_RX0 :
+					       RADIO_2056_RX1),
+					      RADIO_2056_VCM_MASK,
+					      vcm << RADIO_2056_RSSI_VCM_SHIFT);
 
-		if ((read_phy_reg(pi, 0x09) & NPHY_BandControl_currentBand) ==
-		    0) {
+			wlc_phy_poll_rssi_nphy(pi, NPHY_RSSI_SEL_NB,
+					       &poll_results[vcm][0],
+					       NPHY_RSSICAL_NPOLL);
+		}
 
-			write_radio_reg(pi, RADIO_2055_PWRDET_RXTX_CORE1, 0x04);
-			write_radio_reg(pi, RADIO_2055_PWRDET_RXTX_CORE2, 0x04);
-		} else {
+		for (result_idx = 0; result_idx < 4; result_idx++) {
+			if ((core == result_idx / 2) &&
+			    (result_idx % 2 == 0)) {
 
-			write_radio_reg(pi, RADIO_2055_PWRDET_RXTX_CORE1, 0x20);
-			write_radio_reg(pi, RADIO_2055_PWRDET_RXTX_CORE2, 0x20);
+				min_d = NPHY_RSSICAL_MAXD;
+				min_vcm = 0;
+				min_poll =
+					NPHY_RSSICAL_MAXREAD *
+					NPHY_RSSICAL_NPOLL + 1;
+				for (vcm = 0; vcm < vcm_level_max; vcm++) {
+					curr_d =
+						poll_results[vcm][result_idx] *
+						poll_results[vcm][result_idx] +
+						poll_results[vcm][result_idx +
+								  1] *
+						poll_results[vcm][result_idx +
+								  1];
+					if (curr_d < min_d) {
+						min_d = curr_d;
+						min_vcm = vcm;
+					}
+					if (poll_results[vcm][result_idx] <
+					    min_poll)
+						min_poll =
+							poll_results[vcm]
+							[result_idx];
+				}
+				vcm_final = min_vcm;
+				poll_results_min[result_idx] = min_poll;
+			}
 		}
 
-		if (NREV_LT(pi->pubpi.phy_rev, 2)) {
+		if (NREV_GE(pi->pubpi.phy_rev, 7))
+			mod_radio_reg(pi, (core == PHY_CORE_0) ?
+				      RADIO_2057_NB_MASTER_CORE0 :
+				      RADIO_2057_NB_MASTER_CORE1,
+				      RADIO_2057_VCM_MASK, vcm_final);
+		else
+			mod_radio_reg(pi, RADIO_2056_RX_RSSI_MISC |
+				      ((core ==
+					PHY_CORE_0) ? RADIO_2056_RX0 :
+				       RADIO_2056_RX1), RADIO_2056_VCM_MASK,
+				      vcm_final << RADIO_2056_RSSI_VCM_SHIFT);
 
-			or_radio_reg(pi, RADIO_2055_CORE1_TX_BB_MXGM, 0x20);
-			or_radio_reg(pi, RADIO_2055_CORE2_TX_BB_MXGM, 0x20);
-		} else {
+		for (result_idx = 0; result_idx < 4; result_idx++) {
+			if (core == result_idx / 2) {
+				fine_digital_offset[result_idx] =
+					(NPHY_RSSICAL_NB_TARGET *
+					 NPHY_RSSICAL_NPOLL) -
+					poll_results[vcm_final][result_idx];
+				if (fine_digital_offset[result_idx] < 0) {
+					fine_digital_offset[result_idx] =
+						ABS(fine_digital_offset
+						    [result_idx]);
+					fine_digital_offset[result_idx] +=
+						(NPHY_RSSICAL_NPOLL / 2);
+					fine_digital_offset[result_idx] /=
+						NPHY_RSSICAL_NPOLL;
+					fine_digital_offset[result_idx] =
+						-fine_digital_offset[
+								    result_idx];
+				} else {
+					fine_digital_offset[result_idx] +=
+						(NPHY_RSSICAL_NPOLL / 2);
+					fine_digital_offset[result_idx] /=
+						NPHY_RSSICAL_NPOLL;
+				}
 
-			and_radio_reg(pi, RADIO_2055_CORE1_TX_BB_MXGM, 0xdf);
-			and_radio_reg(pi, RADIO_2055_CORE2_TX_BB_MXGM, 0xdf);
-		}
-	}
-}
+				if (poll_results_min[result_idx] ==
+				    NPHY_RSSICAL_MAXREAD * NPHY_RSSICAL_NPOLL)
+					fine_digital_offset[result_idx] =
+						(NPHY_RSSICAL_NB_TARGET -
+						 NPHY_RSSICAL_MAXREAD - 1);
 
-static void wlc_phy_txcal_radio_cleanup_nphy(struct brcms_phy *pi)
-{
-	u16 jtag_core, core;
+				wlc_phy_scale_offset_rssi_nphy(
+					pi, 0x0,
+					(s8)
+					fine_digital_offset
+					[result_idx],
+					(result_idx / 2 == 0) ?
+					RADIO_MIMO_CORESEL_CORE1 :
+					RADIO_MIMO_CORESEL_CORE2,
+					(result_idx % 2 == 0) ?
+					NPHY_RAIL_I : NPHY_RAIL_Q,
+					NPHY_RSSI_SEL_NB);
+			}
+		}
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-		for (core = 0; core <= 1; core++) {
+	}
 
-			WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
-					 TX_SSI_MASTER,
-					 pi->
-					 tx_rx_cal_radio_saveregs[(core * 11) +
-								  0]);
+	for (core = 0; core < pi->pubpi.phy_corenum; core++) {
 
-			WRITE_RADIO_REG3(pi, RADIO_2057, TX, core, IQCAL_VCM_HG,
-					 pi->
-					 tx_rx_cal_radio_saveregs[(core * 11) +
-								  1]);
+		if ((rxcore_state & (1 << core)) == 0)
+			continue;
 
-			WRITE_RADIO_REG3(pi, RADIO_2057, TX, core, IQCAL_IDAC,
-					 pi->
-					 tx_rx_cal_radio_saveregs[(core * 11) +
-								  2]);
+		for (wb_cnt = 0; wb_cnt < 2; wb_cnt++) {
+			if (wb_cnt == 0) {
+				rssi_type = NPHY_RSSI_SEL_W1;
+				target_code = NPHY_RSSICAL_W1_TARGET_REV3;
+			} else {
+				rssi_type = NPHY_RSSI_SEL_W2;
+				target_code = NPHY_RSSICAL_W2_TARGET_REV3;
+			}
 
-			WRITE_RADIO_REG3(pi, RADIO_2057, TX, core, TSSI_VCM,
-					 pi->
-					 tx_rx_cal_radio_saveregs[(core * 11) +
-								  3]);
+			wlc_phy_scale_offset_rssi_nphy(pi, 0x0, 0x0,
+						       core ==
+						       PHY_CORE_0 ?
+						       RADIO_MIMO_CORESEL_CORE1
+						       :
+						       RADIO_MIMO_CORESEL_CORE2,
+						       NPHY_RAIL_I, rssi_type);
+			wlc_phy_scale_offset_rssi_nphy(pi, 0x0, 0x0,
+						       core ==
+						       PHY_CORE_0 ?
+						       RADIO_MIMO_CORESEL_CORE1
+						       :
+						       RADIO_MIMO_CORESEL_CORE2,
+						       NPHY_RAIL_Q, rssi_type);
 
-			WRITE_RADIO_REG3(pi, RADIO_2057, TX, core, TX_SSI_MUX,
-					 pi->
-					 tx_rx_cal_radio_saveregs[(core * 11) +
-								  5]);
+			wlc_phy_poll_rssi_nphy(pi, rssi_type, poll_result_core,
+					       NPHY_RSSICAL_NPOLL);
 
-			if (pi->pubpi.radiorev != 5)
-				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
-						 TSSIA,
-						 pi->tx_rx_cal_radio_saveregs
-							     [(core * 11) + 6]);
+			for (result_idx = 0; result_idx < 4; result_idx++) {
+				if (core == result_idx / 2) {
+					fine_digital_offset[result_idx] =
+						(target_code *
+						 NPHY_RSSICAL_NPOLL) -
+						poll_result_core[result_idx];
+					if (fine_digital_offset[result_idx] <
+					    0) {
+						fine_digital_offset[result_idx]
+							= ABS(
+							    fine_digital_offset
+							    [result_idx]);
+						fine_digital_offset[result_idx]
+							+= (NPHY_RSSICAL_NPOLL
+							    / 2);
+						fine_digital_offset[result_idx]
+							/= NPHY_RSSICAL_NPOLL;
+						fine_digital_offset[result_idx]
+							= -fine_digital_offset
+								[result_idx];
+					} else {
+						fine_digital_offset[result_idx]
+							+= (NPHY_RSSICAL_NPOLL
+							    / 2);
+						fine_digital_offset[result_idx]
+							/= NPHY_RSSICAL_NPOLL;
+					}
 
-			WRITE_RADIO_REG3(pi, RADIO_2057, TX, core, TSSIG,
-					 pi->
-					 tx_rx_cal_radio_saveregs[(core * 11) +
-								  7]);
+					wlc_phy_scale_offset_rssi_nphy(
+						pi, 0x0,
+						(s8)
+						fine_digital_offset
+						[core *
+						 2],
+						(core == PHY_CORE_0) ?
+						RADIO_MIMO_CORESEL_CORE1 :
+						RADIO_MIMO_CORESEL_CORE2,
+						(result_idx % 2 == 0) ?
+						NPHY_RAIL_I :
+						NPHY_RAIL_Q,
+						rssi_type);
+				}
+			}
 
-			WRITE_RADIO_REG3(pi, RADIO_2057, TX, core, TSSI_MISC1,
-					 pi->
-					 tx_rx_cal_radio_saveregs[(core * 11) +
-								  8]);
 		}
-	} else if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-		for (core = 0; core <= 1; core++) {
-			jtag_core = (core == PHY_CORE_0) ?
-				     RADIO_2056_TX0 : RADIO_2056_TX1;
-
-			write_radio_reg(pi,
-					RADIO_2056_TX_TX_SSI_MASTER | jtag_core,
-					pi->
-					tx_rx_cal_radio_saveregs[(core * 11) +
-								 0]);
-
-			write_radio_reg(pi,
-					RADIO_2056_TX_IQCAL_VCM_HG | jtag_core,
-					pi->
-					tx_rx_cal_radio_saveregs[(core * 11) +
-								 1]);
-
-			write_radio_reg(pi,
-					RADIO_2056_TX_IQCAL_IDAC | jtag_core,
-					pi->
-					tx_rx_cal_radio_saveregs[(core * 11) +
-								 2]);
+	}
 
-			write_radio_reg(pi, RADIO_2056_TX_TSSI_VCM | jtag_core,
-					pi->
-					tx_rx_cal_radio_saveregs[(core * 11) +
-								 3]);
+	write_phy_reg(pi, 0x91, NPHY_Rfctrlintc1_save);
+	write_phy_reg(pi, 0x92, NPHY_Rfctrlintc2_save);
 
-			write_radio_reg(pi,
-					RADIO_2056_TX_TX_AMP_DET | jtag_core,
-					pi->
-					tx_rx_cal_radio_saveregs[(core * 11) +
-								 4]);
+	wlc_phy_force_rfseq_nphy(pi, NPHY_RFSEQ_RESET2RX);
 
-			write_radio_reg(pi,
-					RADIO_2056_TX_TX_SSI_MUX | jtag_core,
-					pi->
-					tx_rx_cal_radio_saveregs[(core * 11) +
-								 5]);
+	mod_phy_reg(pi, 0xe7, (0x1 << 0), 1 << 0);
+	mod_phy_reg(pi, 0x78, (0x1 << 0), 1 << 0);
+	mod_phy_reg(pi, 0xe7, (0x1 << 0), 0);
 
-			write_radio_reg(pi, RADIO_2056_TX_TSSIA | jtag_core,
-					pi->
-					tx_rx_cal_radio_saveregs[(core * 11) +
-								 6]);
+	mod_phy_reg(pi, 0xec, (0x1 << 0), 1 << 0);
+	mod_phy_reg(pi, 0x78, (0x1 << 1), 1 << 1);
+	mod_phy_reg(pi, 0xec, (0x1 << 0), 0);
 
-			write_radio_reg(pi, RADIO_2056_TX_TSSIG | jtag_core,
-					pi->
-					tx_rx_cal_radio_saveregs[(core * 11) +
-								 7]);
+	write_phy_reg(pi, 0x8f, NPHY_AfectrlOverride1_save);
+	write_phy_reg(pi, 0xa5, NPHY_AfectrlOverride2_save);
+	write_phy_reg(pi, 0xa6, NPHY_AfectrlCore1_save);
+	write_phy_reg(pi, 0xa7, NPHY_AfectrlCore2_save);
+	write_phy_reg(pi, 0xe7, NPHY_RfctrlOverride0_save);
+	write_phy_reg(pi, 0xec, NPHY_RfctrlOverride1_save);
+	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+		write_phy_reg(pi, 0x342, NPHY_REV7_RfctrlOverride3_save);
+		write_phy_reg(pi, 0x343, NPHY_REV7_RfctrlOverride4_save);
+		write_phy_reg(pi, 0x346, NPHY_REV7_RfctrlOverride5_save);
+		write_phy_reg(pi, 0x347, NPHY_REV7_RfctrlOverride6_save);
+	}
+	write_phy_reg(pi, 0xe5, NPHY_RfctrlOverrideAux0_save);
+	write_phy_reg(pi, 0xe6, NPHY_RfctrlOverrideAux1_save);
+	write_phy_reg(pi, 0x78, NPHY_RfctrlCmd_save);
+	write_phy_reg(pi, 0xf9, NPHY_RfctrlMiscReg1_save);
+	write_phy_reg(pi, 0xfb, NPHY_RfctrlMiscReg2_save);
+	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+		write_phy_reg(pi, 0x340, NPHY_REV7_RfctrlMiscReg3_save);
+		write_phy_reg(pi, 0x341, NPHY_REV7_RfctrlMiscReg4_save);
+		write_phy_reg(pi, 0x344, NPHY_REV7_RfctrlMiscReg5_save);
+		write_phy_reg(pi, 0x345, NPHY_REV7_RfctrlMiscReg6_save);
+	}
+	write_phy_reg(pi, 0x7a, NPHY_RfctrlRSSIOTHERS1_save);
+	write_phy_reg(pi, 0x7d, NPHY_RfctrlRSSIOTHERS2_save);
 
-			write_radio_reg(pi,
-					RADIO_2056_TX_TSSI_MISC1 | jtag_core,
-					pi->
-					tx_rx_cal_radio_saveregs[(core * 11) +
-								 8]);
+	if (CHSPEC_IS2G(pi->radio_chanspec)) {
+		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+			pi->rssical_cache.rssical_radio_regs_2G[0] =
+				read_radio_reg(pi, RADIO_2057_NB_MASTER_CORE0);
+			pi->rssical_cache.rssical_radio_regs_2G[1] =
+				read_radio_reg(pi, RADIO_2057_NB_MASTER_CORE1);
+		} else {
+			pi->rssical_cache.rssical_radio_regs_2G[0] =
+				read_radio_reg(pi,
+					       RADIO_2056_RX_RSSI_MISC |
+					       RADIO_2056_RX0);
+			pi->rssical_cache.rssical_radio_regs_2G[1] =
+				read_radio_reg(pi,
+					       RADIO_2056_RX_RSSI_MISC |
+					       RADIO_2056_RX1);
+		}
 
-			write_radio_reg(pi,
-					RADIO_2056_TX_TSSI_MISC2 | jtag_core,
-					pi->
-					tx_rx_cal_radio_saveregs[(core * 11) +
-								 9]);
+		pi->rssical_cache.rssical_phyregs_2G[0] =
+			read_phy_reg(pi, 0x1a6);
+		pi->rssical_cache.rssical_phyregs_2G[1] =
+			read_phy_reg(pi, 0x1ac);
+		pi->rssical_cache.rssical_phyregs_2G[2] =
+			read_phy_reg(pi, 0x1b2);
+		pi->rssical_cache.rssical_phyregs_2G[3] =
+			read_phy_reg(pi, 0x1b8);
+		pi->rssical_cache.rssical_phyregs_2G[4] =
+			read_phy_reg(pi, 0x1a4);
+		pi->rssical_cache.rssical_phyregs_2G[5] =
+			read_phy_reg(pi, 0x1aa);
+		pi->rssical_cache.rssical_phyregs_2G[6] =
+			read_phy_reg(pi, 0x1b0);
+		pi->rssical_cache.rssical_phyregs_2G[7] =
+			read_phy_reg(pi, 0x1b6);
+		pi->rssical_cache.rssical_phyregs_2G[8] =
+			read_phy_reg(pi, 0x1a5);
+		pi->rssical_cache.rssical_phyregs_2G[9] =
+			read_phy_reg(pi, 0x1ab);
+		pi->rssical_cache.rssical_phyregs_2G[10] =
+			read_phy_reg(pi, 0x1b1);
+		pi->rssical_cache.rssical_phyregs_2G[11] =
+			read_phy_reg(pi, 0x1b7);
 
-			write_radio_reg(pi,
-					RADIO_2056_TX_TSSI_MISC3 | jtag_core,
-					pi->
-					tx_rx_cal_radio_saveregs[(core * 11) +
-								 10]);
-		}
+		pi->nphy_rssical_chanspec_2G = pi->radio_chanspec;
 	} else {
+		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+			pi->rssical_cache.rssical_radio_regs_5G[0] =
+				read_radio_reg(pi, RADIO_2057_NB_MASTER_CORE0);
+			pi->rssical_cache.rssical_radio_regs_5G[1] =
+				read_radio_reg(pi, RADIO_2057_NB_MASTER_CORE1);
+		} else {
+			pi->rssical_cache.rssical_radio_regs_5G[0] =
+				read_radio_reg(pi,
+					       RADIO_2056_RX_RSSI_MISC |
+					       RADIO_2056_RX0);
+			pi->rssical_cache.rssical_radio_regs_5G[1] =
+				read_radio_reg(pi,
+					       RADIO_2056_RX_RSSI_MISC |
+					       RADIO_2056_RX1);
+		}
 
-		write_radio_reg(pi, RADIO_2055_CORE1_TXRF_IQCAL1,
-				pi->tx_rx_cal_radio_saveregs[0]);
-		write_radio_reg(pi, RADIO_2055_CORE1_TXRF_IQCAL2,
-				pi->tx_rx_cal_radio_saveregs[1]);
-		write_radio_reg(pi, RADIO_2055_CORE2_TXRF_IQCAL1,
-				pi->tx_rx_cal_radio_saveregs[2]);
-		write_radio_reg(pi, RADIO_2055_CORE2_TXRF_IQCAL2,
-				pi->tx_rx_cal_radio_saveregs[3]);
-		write_radio_reg(pi, RADIO_2055_PWRDET_RXTX_CORE1,
-				pi->tx_rx_cal_radio_saveregs[4]);
-		write_radio_reg(pi, RADIO_2055_PWRDET_RXTX_CORE2,
-				pi->tx_rx_cal_radio_saveregs[5]);
+		pi->rssical_cache.rssical_phyregs_5G[0] =
+			read_phy_reg(pi, 0x1a6);
+		pi->rssical_cache.rssical_phyregs_5G[1] =
+			read_phy_reg(pi, 0x1ac);
+		pi->rssical_cache.rssical_phyregs_5G[2] =
+			read_phy_reg(pi, 0x1b2);
+		pi->rssical_cache.rssical_phyregs_5G[3] =
+			read_phy_reg(pi, 0x1b8);
+		pi->rssical_cache.rssical_phyregs_5G[4] =
+			read_phy_reg(pi, 0x1a4);
+		pi->rssical_cache.rssical_phyregs_5G[5] =
+			read_phy_reg(pi, 0x1aa);
+		pi->rssical_cache.rssical_phyregs_5G[6] =
+			read_phy_reg(pi, 0x1b0);
+		pi->rssical_cache.rssical_phyregs_5G[7] =
+			read_phy_reg(pi, 0x1b6);
+		pi->rssical_cache.rssical_phyregs_5G[8] =
+			read_phy_reg(pi, 0x1a5);
+		pi->rssical_cache.rssical_phyregs_5G[9] =
+			read_phy_reg(pi, 0x1ab);
+		pi->rssical_cache.rssical_phyregs_5G[10] =
+			read_phy_reg(pi, 0x1b1);
+		pi->rssical_cache.rssical_phyregs_5G[11] =
+			read_phy_reg(pi, 0x1b7);
+
+		pi->nphy_rssical_chanspec_5G = pi->radio_chanspec;
 	}
+
+	wlc_phy_classifier_nphy(pi, (0x7 << 0), classif_state);
+	wlc_phy_clip_det_nphy(pi, 1, clip_state);
 }
 
-static void wlc_phy_txcal_physetup_nphy(struct brcms_phy *pi)
+static void wlc_phy_rssi_cal_nphy_rev2(struct brcms_phy *pi, u8 rssi_type)
 {
-	u16 val, mask;
-
-	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-		pi->tx_rx_cal_phy_saveregs[0] = read_phy_reg(pi, 0xa6);
-		pi->tx_rx_cal_phy_saveregs[1] = read_phy_reg(pi, 0xa7);
-
-		mask = ((0x3 << 8) | (0x3 << 10));
-		val = (0x2 << 8);
-		val |= (0x2 << 10);
-		mod_phy_reg(pi, 0xa6, mask, val);
-		mod_phy_reg(pi, 0xa7, mask, val);
-
-		val = read_phy_reg(pi, 0x8f);
-		pi->tx_rx_cal_phy_saveregs[2] = val;
-		val |= ((0x1 << 9) | (0x1 << 10));
-		write_phy_reg(pi, 0x8f, val);
-
-		val = read_phy_reg(pi, 0xa5);
-		pi->tx_rx_cal_phy_saveregs[3] = val;
-		val |= ((0x1 << 9) | (0x1 << 10));
-		write_phy_reg(pi, 0xa5, val);
-
-		pi->tx_rx_cal_phy_saveregs[4] = read_phy_reg(pi, 0x01);
-		mod_phy_reg(pi, 0x01, (0x1 << 15), 0);
+	s32 target_code;
+	u16 classif_state;
+	u16 clip_state[2];
+	u16 rssi_ctrl_state[2], pd_state[2];
+	u16 rfctrlintc_state[2], rfpdcorerxtx_state[2];
+	u16 rfctrlintc_override_val;
+	u16 clip_off[] = { 0xffff, 0xffff };
+	u16 rf_pd_val, pd_mask, rssi_ctrl_mask;
+	u8 vcm, min_vcm, vcm_tmp[4];
+	u8 vcm_final[4] = { 0, 0, 0, 0 };
+	u8 result_idx, ctr;
+	s32 poll_results[4][4] = {
+		{0, 0, 0, 0},
+		{0, 0, 0, 0},
+		{0, 0, 0, 0},
+		{0, 0, 0, 0}
+	};
+	s32 poll_miniq[4][2] = {
+		{0, 0},
+		{0, 0},
+		{0, 0},
+		{0, 0}
+	};
+	s32 min_d, curr_d;
+	s32 fine_digital_offset[4];
+	s32 poll_results_min[4] = { 0, 0, 0, 0 };
+	s32 min_poll;
 
-		wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 3, 16,
-					&val);
-		pi->tx_rx_cal_phy_saveregs[5] = val;
-		val = 0;
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 3, 16,
-					 &val);
+	switch (rssi_type) {
+	case NPHY_RSSI_SEL_NB:
+		target_code = NPHY_RSSICAL_NB_TARGET;
+		break;
+	case NPHY_RSSI_SEL_W1:
+		target_code = NPHY_RSSICAL_W1_TARGET;
+		break;
+	case NPHY_RSSI_SEL_W2:
+		target_code = NPHY_RSSICAL_W2_TARGET;
+		break;
+	default:
+		return;
+		break;
+	}
 
-		wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 19, 16,
-					&val);
-		pi->tx_rx_cal_phy_saveregs[6] = val;
-		val = 0;
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 19, 16,
-					 &val);
+	classif_state = wlc_phy_classifier_nphy(pi, 0, 0);
+	wlc_phy_classifier_nphy(pi, (0x7 << 0), 4);
+	wlc_phy_clip_det_nphy(pi, 0, clip_state);
+	wlc_phy_clip_det_nphy(pi, 1, clip_off);
 
-		pi->tx_rx_cal_phy_saveregs[7] = read_phy_reg(pi, 0x91);
-		pi->tx_rx_cal_phy_saveregs[8] = read_phy_reg(pi, 0x92);
+	rf_pd_val = (rssi_type == NPHY_RSSI_SEL_NB) ? 0x6 : 0x4;
+	rfctrlintc_override_val =
+		CHSPEC_IS5G(pi->radio_chanspec) ? 0x140 : 0x110;
 
-		if (!(pi->use_int_tx_iqlo_cal_nphy))
-			wlc_phy_rfctrlintc_override_nphy(
-				pi,
-				NPHY_RfctrlIntc_override_PA,
-				1,
-				RADIO_MIMO_CORESEL_CORE1
-				|
-				RADIO_MIMO_CORESEL_CORE2);
-		else
-			wlc_phy_rfctrlintc_override_nphy(
-				pi,
-				NPHY_RfctrlIntc_override_PA,
-				0,
-				RADIO_MIMO_CORESEL_CORE1
-				|
-				RADIO_MIMO_CORESEL_CORE2);
+	rfctrlintc_state[0] = read_phy_reg(pi, 0x91);
+	rfpdcorerxtx_state[0] = read_radio_reg(pi, RADIO_2055_PD_CORE1_RXTX);
+	write_phy_reg(pi, 0x91, rfctrlintc_override_val);
+	write_radio_reg(pi, RADIO_2055_PD_CORE1_RXTX, rf_pd_val);
 
-		wlc_phy_rfctrlintc_override_nphy(pi,
-						 NPHY_RfctrlIntc_override_TRSW,
-						 0x2, RADIO_MIMO_CORESEL_CORE1);
-		wlc_phy_rfctrlintc_override_nphy(pi,
-						 NPHY_RfctrlIntc_override_TRSW,
-						 0x8, RADIO_MIMO_CORESEL_CORE2);
+	rfctrlintc_state[1] = read_phy_reg(pi, 0x92);
+	rfpdcorerxtx_state[1] = read_radio_reg(pi, RADIO_2055_PD_CORE2_RXTX);
+	write_phy_reg(pi, 0x92, rfctrlintc_override_val);
+	write_radio_reg(pi, RADIO_2055_PD_CORE2_RXTX, rf_pd_val);
 
-		pi->tx_rx_cal_phy_saveregs[9] = read_phy_reg(pi, 0x297);
-		pi->tx_rx_cal_phy_saveregs[10] = read_phy_reg(pi, 0x29b);
-		mod_phy_reg(pi, (0 == PHY_CORE_0) ? 0x297 :
-			    0x29b, (0x1 << 0), (0) << 0);
+	pd_mask = RADIO_2055_NBRSSI_PD | RADIO_2055_WBRSSI_G1_PD |
+		  RADIO_2055_WBRSSI_G2_PD;
+	pd_state[0] =
+		read_radio_reg(pi, RADIO_2055_PD_CORE1_RSSI_MISC) & pd_mask;
+	pd_state[1] =
+		read_radio_reg(pi, RADIO_2055_PD_CORE2_RSSI_MISC) & pd_mask;
+	mod_radio_reg(pi, RADIO_2055_PD_CORE1_RSSI_MISC, pd_mask, 0);
+	mod_radio_reg(pi, RADIO_2055_PD_CORE2_RSSI_MISC, pd_mask, 0);
+	rssi_ctrl_mask = RADIO_2055_NBRSSI_SEL | RADIO_2055_WBRSSI_G1_SEL |
+			 RADIO_2055_WBRSSI_G2_SEL;
+	rssi_ctrl_state[0] =
+		read_radio_reg(pi, RADIO_2055_SP_RSSI_CORE1) & rssi_ctrl_mask;
+	rssi_ctrl_state[1] =
+		read_radio_reg(pi, RADIO_2055_SP_RSSI_CORE2) & rssi_ctrl_mask;
+	wlc_phy_rssisel_nphy(pi, RADIO_MIMO_CORESEL_ALLRX, rssi_type);
 
-		mod_phy_reg(pi, (1 == PHY_CORE_0) ? 0x297 :
-			    0x29b, (0x1 << 0), (0) << 0);
+	wlc_phy_scale_offset_rssi_nphy(pi, 0x0, 0x0, RADIO_MIMO_CORESEL_ALLRX,
+				       NPHY_RAIL_I, rssi_type);
+	wlc_phy_scale_offset_rssi_nphy(pi, 0x0, 0x0, RADIO_MIMO_CORESEL_ALLRX,
+				       NPHY_RAIL_Q, rssi_type);
 
-		if (NREV_IS(pi->pubpi.phy_rev, 7)
-		    || NREV_GE(pi->pubpi.phy_rev, 8))
-			wlc_phy_rfctrl_override_nphy_rev7(
-				pi, (0x1 << 7),
-				wlc_phy_read_lpf_bw_ctl_nphy
-					(pi,
-					0), 0, 0,
-				NPHY_REV7_RFCTRLOVERRIDE_ID1);
+	for (vcm = 0; vcm < 4; vcm++) {
 
-		if (pi->use_int_tx_iqlo_cal_nphy
-		    && !(pi->internal_tx_iqlo_cal_tapoff_intpa_nphy)) {
+		vcm_tmp[0] = vcm_tmp[1] = vcm_tmp[2] = vcm_tmp[3] = vcm;
+		if (rssi_type != NPHY_RSSI_SEL_W2)
+			wlc_phy_set_rssi_2055_vcm(pi, rssi_type, vcm_tmp);
 
-			if (NREV_IS(pi->pubpi.phy_rev, 7)) {
+		wlc_phy_poll_rssi_nphy(pi, rssi_type, &poll_results[vcm][0],
+				       NPHY_RSSICAL_NPOLL);
 
-				mod_radio_reg(pi, RADIO_2057_OVR_REG0, 1 << 4,
-					      1 << 4);
+		if ((rssi_type == NPHY_RSSI_SEL_W1)
+		    || (rssi_type == NPHY_RSSI_SEL_W2)) {
+			for (ctr = 0; ctr < 2; ctr++)
+				poll_miniq[vcm][ctr] =
+					min(poll_results[vcm][ctr * 2 + 0],
+					    poll_results[vcm][ctr * 2 + 1]);
+		}
+	}
 
-				if (CHSPEC_IS2G(pi->radio_chanspec)) {
-					mod_radio_reg(
-						pi,
-						RADIO_2057_PAD2G_TUNE_PUS_CORE0,
-						1, 0);
-					mod_radio_reg(
-						pi,
-						RADIO_2057_PAD2G_TUNE_PUS_CORE1,
-						1, 0);
-				} else {
-					mod_radio_reg(
-					     pi,
-					     RADIO_2057_IPA5G_CASCOFFV_PU_CORE0,
-					     1, 0);
-					mod_radio_reg(
-					     pi,
-					     RADIO_2057_IPA5G_CASCOFFV_PU_CORE1,
-					     1, 0);
-				}
-			} else if (NREV_GE(pi->pubpi.phy_rev, 8)) {
-				wlc_phy_rfctrl_override_nphy_rev7(
-					pi,
-					(0x1 << 3), 0,
-					0x3, 0,
-					NPHY_REV7_RFCTRLOVERRIDE_ID0);
+	for (result_idx = 0; result_idx < 4; result_idx++) {
+		min_d = NPHY_RSSICAL_MAXD;
+		min_vcm = 0;
+		min_poll = NPHY_RSSICAL_MAXREAD * NPHY_RSSICAL_NPOLL + 1;
+		for (vcm = 0; vcm < 4; vcm++) {
+			curr_d = ABS(((rssi_type == NPHY_RSSI_SEL_NB) ?
+				      poll_results[vcm][result_idx] :
+				      poll_miniq[vcm][result_idx / 2]) -
+				     (target_code * NPHY_RSSICAL_NPOLL));
+			if (curr_d < min_d) {
+				min_d = curr_d;
+				min_vcm = vcm;
 			}
+			if (poll_results[vcm][result_idx] < min_poll)
+				min_poll = poll_results[vcm][result_idx];
 		}
-	} else {
-		pi->tx_rx_cal_phy_saveregs[0] = read_phy_reg(pi, 0xa6);
-		pi->tx_rx_cal_phy_saveregs[1] = read_phy_reg(pi, 0xa7);
-
-		mask = ((0x3 << 12) | (0x3 << 14));
-		val = (0x2 << 12);
-		val |= (0x2 << 14);
-		mod_phy_reg(pi, 0xa6, mask, val);
-		mod_phy_reg(pi, 0xa7, mask, val);
+		vcm_final[result_idx] = min_vcm;
+		poll_results_min[result_idx] = min_poll;
+	}
 
-		val = read_phy_reg(pi, 0xa5);
-		pi->tx_rx_cal_phy_saveregs[2] = val;
-		val |= ((0x1 << 12) | (0x1 << 13));
-		write_phy_reg(pi, 0xa5, val);
+	if (rssi_type != NPHY_RSSI_SEL_W2)
+		wlc_phy_set_rssi_2055_vcm(pi, rssi_type, vcm_final);
 
-		wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 2, 16,
-					&val);
-		pi->tx_rx_cal_phy_saveregs[3] = val;
-		val |= 0x2000;
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 2, 16,
-					 &val);
+	for (result_idx = 0; result_idx < 4; result_idx++) {
+		fine_digital_offset[result_idx] =
+			(target_code * NPHY_RSSICAL_NPOLL) -
+			poll_results[vcm_final[result_idx]][result_idx];
+		if (fine_digital_offset[result_idx] < 0) {
+			fine_digital_offset[result_idx] =
+				ABS(fine_digital_offset[result_idx]);
+			fine_digital_offset[result_idx] +=
+				(NPHY_RSSICAL_NPOLL / 2);
+			fine_digital_offset[result_idx] /= NPHY_RSSICAL_NPOLL;
+			fine_digital_offset[result_idx] =
+				-fine_digital_offset[result_idx];
+		} else {
+			fine_digital_offset[result_idx] +=
+				(NPHY_RSSICAL_NPOLL / 2);
+			fine_digital_offset[result_idx] /= NPHY_RSSICAL_NPOLL;
+		}
 
-		wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 18, 16,
-					&val);
-		pi->tx_rx_cal_phy_saveregs[4] = val;
-		val |= 0x2000;
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 18, 16,
-					 &val);
+		if (poll_results_min[result_idx] ==
+		    NPHY_RSSICAL_MAXREAD * NPHY_RSSICAL_NPOLL)
+			fine_digital_offset[result_idx] =
+				(target_code - NPHY_RSSICAL_MAXREAD - 1);
 
-		pi->tx_rx_cal_phy_saveregs[5] = read_phy_reg(pi, 0x91);
-		pi->tx_rx_cal_phy_saveregs[6] = read_phy_reg(pi, 0x92);
-		val = CHSPEC_IS5G(pi->radio_chanspec) ? 0x180 : 0x120;
-		write_phy_reg(pi, 0x91, val);
-		write_phy_reg(pi, 0x92, val);
+		wlc_phy_scale_offset_rssi_nphy(pi, 0x0,
+					       (s8)
+					       fine_digital_offset[result_idx],
+					       (result_idx / 2 ==
+						0) ? RADIO_MIMO_CORESEL_CORE1 :
+					       RADIO_MIMO_CORESEL_CORE2,
+					       (result_idx % 2 ==
+						0) ? NPHY_RAIL_I : NPHY_RAIL_Q,
+					       rssi_type);
 	}
-}
-
-static void wlc_phy_txcal_phycleanup_nphy(struct brcms_phy *pi)
-{
-	u16 mask;
-
-	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-		write_phy_reg(pi, 0xa6, pi->tx_rx_cal_phy_saveregs[0]);
-		write_phy_reg(pi, 0xa7, pi->tx_rx_cal_phy_saveregs[1]);
-		write_phy_reg(pi, 0x8f, pi->tx_rx_cal_phy_saveregs[2]);
-		write_phy_reg(pi, 0xa5, pi->tx_rx_cal_phy_saveregs[3]);
-		write_phy_reg(pi, 0x01, pi->tx_rx_cal_phy_saveregs[4]);
 
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 3, 16,
-					 &pi->tx_rx_cal_phy_saveregs[5]);
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 19, 16,
-					 &pi->tx_rx_cal_phy_saveregs[6]);
+	mod_radio_reg(pi, RADIO_2055_PD_CORE1_RSSI_MISC, pd_mask, pd_state[0]);
+	mod_radio_reg(pi, RADIO_2055_PD_CORE2_RSSI_MISC, pd_mask, pd_state[1]);
+	if (rssi_ctrl_state[0] == RADIO_2055_NBRSSI_SEL)
+		wlc_phy_rssisel_nphy(pi, RADIO_MIMO_CORESEL_CORE1,
+				     NPHY_RSSI_SEL_NB);
+	else if (rssi_ctrl_state[0] == RADIO_2055_WBRSSI_G1_SEL)
+		wlc_phy_rssisel_nphy(pi, RADIO_MIMO_CORESEL_CORE1,
+				     NPHY_RSSI_SEL_W1);
+	else if (rssi_ctrl_state[0] == RADIO_2055_WBRSSI_G2_SEL)
+		wlc_phy_rssisel_nphy(pi, RADIO_MIMO_CORESEL_CORE1,
+				     NPHY_RSSI_SEL_W2);
+	else
+		wlc_phy_rssisel_nphy(pi, RADIO_MIMO_CORESEL_CORE1,
+				     NPHY_RSSI_SEL_W2);
+	if (rssi_ctrl_state[1] == RADIO_2055_NBRSSI_SEL)
+		wlc_phy_rssisel_nphy(pi, RADIO_MIMO_CORESEL_CORE2,
+				     NPHY_RSSI_SEL_NB);
+	else if (rssi_ctrl_state[1] == RADIO_2055_WBRSSI_G1_SEL)
+		wlc_phy_rssisel_nphy(pi, RADIO_MIMO_CORESEL_CORE2,
+				     NPHY_RSSI_SEL_W1);
+	else if (rssi_ctrl_state[1] == RADIO_2055_WBRSSI_G2_SEL)
+		wlc_phy_rssisel_nphy(pi, RADIO_MIMO_CORESEL_CORE2,
+				     NPHY_RSSI_SEL_W2);
+	else
+		wlc_phy_rssisel_nphy(pi, RADIO_MIMO_CORESEL_CORE2,
+				     NPHY_RSSI_SEL_W2);
 
-		write_phy_reg(pi, 0x91, pi->tx_rx_cal_phy_saveregs[7]);
-		write_phy_reg(pi, 0x92, pi->tx_rx_cal_phy_saveregs[8]);
+	wlc_phy_rssisel_nphy(pi, RADIO_MIMO_CORESEL_OFF, rssi_type);
 
-		write_phy_reg(pi, 0x297, pi->tx_rx_cal_phy_saveregs[9]);
-		write_phy_reg(pi, 0x29b, pi->tx_rx_cal_phy_saveregs[10]);
+	write_phy_reg(pi, 0x91, rfctrlintc_state[0]);
+	write_radio_reg(pi, RADIO_2055_PD_CORE1_RXTX, rfpdcorerxtx_state[0]);
+	write_phy_reg(pi, 0x92, rfctrlintc_state[1]);
+	write_radio_reg(pi, RADIO_2055_PD_CORE2_RXTX, rfpdcorerxtx_state[1]);
 
-		if (NREV_IS(pi->pubpi.phy_rev, 7)
-		    || NREV_GE(pi->pubpi.phy_rev, 8))
-			wlc_phy_rfctrl_override_nphy_rev7(
-				pi, (0x1 << 7), 0, 0,
-				1,
-				NPHY_REV7_RFCTRLOVERRIDE_ID1);
+	wlc_phy_classifier_nphy(pi, (0x7 << 0), classif_state);
+	wlc_phy_clip_det_nphy(pi, 1, clip_state);
 
-		wlc_phy_resetcca_nphy(pi);
+	wlc_phy_resetcca_nphy(pi);
+}
 
-		if (pi->use_int_tx_iqlo_cal_nphy
-		    && !(pi->internal_tx_iqlo_cal_tapoff_intpa_nphy)) {
+void wlc_phy_rssi_cal_nphy(struct brcms_phy *pi)
+{
+	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+		wlc_phy_rssi_cal_nphy_rev3(pi);
+	} else {
+		wlc_phy_rssi_cal_nphy_rev2(pi, NPHY_RSSI_SEL_NB);
+		wlc_phy_rssi_cal_nphy_rev2(pi, NPHY_RSSI_SEL_W1);
+		wlc_phy_rssi_cal_nphy_rev2(pi, NPHY_RSSI_SEL_W2);
+	}
+}
 
-			if (NREV_IS(pi->pubpi.phy_rev, 7)) {
-				if (CHSPEC_IS2G(pi->radio_chanspec)) {
-					mod_radio_reg(
-						pi,
-						RADIO_2057_PAD2G_TUNE_PUS_CORE0,
-						1, 1);
-					mod_radio_reg(
-						pi,
-						RADIO_2057_PAD2G_TUNE_PUS_CORE1,
-						1, 1);
-				} else {
-					mod_radio_reg(
-					     pi,
-					     RADIO_2057_IPA5G_CASCOFFV_PU_CORE0,
-					     1, 1);
-					mod_radio_reg(
-					     pi,
-					     RADIO_2057_IPA5G_CASCOFFV_PU_CORE1,
-					     1, 1);
-				}
+int
+wlc_phy_rssi_compute_nphy(struct brcms_phy *pi, struct brcms_d11rxhdr *wlc_rxh)
+{
+	struct d11rxhdr *rxh = &wlc_rxh->rxhdr;
+	s16 rxpwr, rxpwr0, rxpwr1;
+	s16 phyRx0_l, phyRx2_l;
 
-				mod_radio_reg(pi, RADIO_2057_OVR_REG0, 1 << 4,
-					      0);
-			} else if (NREV_GE(pi->pubpi.phy_rev, 8)) {
-				wlc_phy_rfctrl_override_nphy_rev7(
-					pi,
-					(0x1 << 3), 0,
-					0x3, 1,
-					NPHY_REV7_RFCTRLOVERRIDE_ID0);
-			}
-		}
-	} else {
-		mask = ((0x3 << 12) | (0x3 << 14));
-		mod_phy_reg(pi, 0xa6, mask, pi->tx_rx_cal_phy_saveregs[0]);
-		mod_phy_reg(pi, 0xa7, mask, pi->tx_rx_cal_phy_saveregs[1]);
-		write_phy_reg(pi, 0xa5, pi->tx_rx_cal_phy_saveregs[2]);
+	rxpwr = 0;
+	rxpwr0 = le16_to_cpu(rxh->PhyRxStatus_1) & PRXS1_nphy_PWR0_MASK;
+	rxpwr1 = (le16_to_cpu(rxh->PhyRxStatus_1) & PRXS1_nphy_PWR1_MASK) >> 8;
 
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 2, 16,
-					 &pi->tx_rx_cal_phy_saveregs[3]);
+	if (rxpwr0 > 127)
+		rxpwr0 -= 256;
+	if (rxpwr1 > 127)
+		rxpwr1 -= 256;
 
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 18, 16,
-					 &pi->tx_rx_cal_phy_saveregs[4]);
+	phyRx0_l = le16_to_cpu(rxh->PhyRxStatus_0) & 0x00ff;
+	phyRx2_l = le16_to_cpu(rxh->PhyRxStatus_2) & 0x00ff;
+	if (phyRx2_l > 127)
+		phyRx2_l -= 256;
 
-		write_phy_reg(pi, 0x91, pi->tx_rx_cal_phy_saveregs[5]);
-		write_phy_reg(pi, 0x92, pi->tx_rx_cal_phy_saveregs[6]);
+	if (((rxpwr0 == 16) || (rxpwr0 == 32))) {
+		rxpwr0 = rxpwr1;
+		rxpwr1 = phyRx2_l;
 	}
+
+	wlc_rxh->rxpwr[0] = (s8) rxpwr0;
+	wlc_rxh->rxpwr[1] = (s8) rxpwr1;
+	wlc_rxh->do_rssi_ma = 0;
+
+	if (pi->sh->rssi_mode == RSSI_ANT_MERGE_MAX)
+		rxpwr = (rxpwr0 > rxpwr1) ? rxpwr0 : rxpwr1;
+	else if (pi->sh->rssi_mode == RSSI_ANT_MERGE_MIN)
+		rxpwr = (rxpwr0 < rxpwr1) ? rxpwr0 : rxpwr1;
+	else if (pi->sh->rssi_mode == RSSI_ANT_MERGE_AVG)
+		rxpwr = (rxpwr0 + rxpwr1) >> 1;
+
+	return rxpwr;
 }
 
-#define NPHY_CAL_TSSISAMPS      64
-#define NPHY_TEST_TONE_FREQ_40MHz 4000
-#define NPHY_TEST_TONE_FREQ_20MHz 2500
+static void
+wlc_phy_loadsampletable_nphy(struct brcms_phy *pi, struct cordic_iq *tone_buf,
+			     u16 num_samps)
+{
+	u16 t;
+	u32 *data_buf = NULL;
 
-void
-wlc_phy_est_tonepwr_nphy(struct brcms_phy *pi, s32 *qdBm_pwrbuf, u8 num_samps)
+	data_buf = kmalloc(sizeof(u32) * num_samps, GFP_ATOMIC);
+	if (data_buf == NULL)
+		return;
+
+	if (pi->phyhang_avoid)
+		wlc_phy_stay_in_carriersearch_nphy(pi, true);
+
+	for (t = 0; t < num_samps; t++)
+		data_buf[t] = ((((unsigned int)tone_buf[t].i) & 0x3ff) << 10) |
+			      (((unsigned int)tone_buf[t].q) & 0x3ff);
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_SAMPLEPLAY, num_samps, 0, 32,
+				 data_buf);
+
+	kfree(data_buf);
+
+	if (pi->phyhang_avoid)
+		wlc_phy_stay_in_carriersearch_nphy(pi, false);
+}
+
+static u16
+wlc_phy_gen_load_samples_nphy(struct brcms_phy *pi, u32 f_kHz, u16 max_val,
+			      u8 dac_test_mode)
 {
-	u16 tssi_reg;
-	s32 temp, pwrindex[2];
-	s32 idle_tssi[2];
-	s32 rssi_buf[4];
-	s32 tssival[2];
-	u8 tssi_type;
+	u8 phy_bw, is_phybw40;
+	u16 num_samps, t, spur;
+	s32 theta = 0, rot = 0;
+	u32 tbl_len;
+	struct cordic_iq *tone_buf = NULL;
 
-	tssi_reg = read_phy_reg(pi, 0x1e9);
+	is_phybw40 = CHSPEC_IS40(pi->radio_chanspec);
+	phy_bw = (is_phybw40 == 1) ? 40 : 20;
+	tbl_len = (phy_bw << 3);
 
-	temp = (s32) (tssi_reg & 0x3f);
-	idle_tssi[0] = (temp <= 31) ? temp : (temp - 64);
+	if (dac_test_mode == 1) {
+		spur = read_phy_reg(pi, 0x01);
+		spur = (spur >> 15) & 1;
+		phy_bw = (spur == 1) ? 82 : 80;
+		phy_bw = (is_phybw40 == 1) ? (phy_bw << 1) : phy_bw;
 
-	temp = (s32) ((tssi_reg >> 8) & 0x3f);
-	idle_tssi[1] = (temp <= 31) ? temp : (temp - 64);
+		tbl_len = (phy_bw << 1);
+	}
 
-	tssi_type =
-		CHSPEC_IS5G(pi->radio_chanspec) ?
-		(u8)NPHY_RSSI_SEL_TSSI_5G : (u8)NPHY_RSSI_SEL_TSSI_2G;
+	tone_buf = kmalloc(sizeof(struct cordic_iq) * tbl_len, GFP_ATOMIC);
+	if (tone_buf == NULL)
+		return 0;
 
-	wlc_phy_poll_rssi_nphy(pi, tssi_type, rssi_buf, num_samps);
+	num_samps = (u16) tbl_len;
+	rot = ((f_kHz * 36) / phy_bw) / 100;
+	theta = 0;
 
-	tssival[0] = rssi_buf[0] / ((s32) num_samps);
-	tssival[1] = rssi_buf[2] / ((s32) num_samps);
+	for (t = 0; t < num_samps; t++) {
 
-	pwrindex[0] = idle_tssi[0] - tssival[0] + 64;
-	pwrindex[1] = idle_tssi[1] - tssival[1] + 64;
+		tone_buf[t] = cordic_calc_iq(theta);
 
-	if (pwrindex[0] < 0)
-		pwrindex[0] = 0;
-	else if (pwrindex[0] > 63)
-		pwrindex[0] = 63;
+		theta += rot;
 
-	if (pwrindex[1] < 0)
-		pwrindex[1] = 0;
-	else if (pwrindex[1] > 63)
-		pwrindex[1] = 63;
+		tone_buf[t].q = (s32) FLOAT(tone_buf[t].q * max_val);
+		tone_buf[t].i = (s32) FLOAT(tone_buf[t].i * max_val);
+	}
 
-	wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_CORE1TXPWRCTL, 1,
-				(u32) pwrindex[0], 32, &qdBm_pwrbuf[0]);
-	wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_CORE2TXPWRCTL, 1,
-				(u32) pwrindex[1], 32, &qdBm_pwrbuf[1]);
+	wlc_phy_loadsampletable_nphy(pi, tone_buf, num_samps);
+
+	kfree(tone_buf);
+
+	return num_samps;
 }
 
-static void wlc_phy_internal_cal_txgain_nphy(struct brcms_phy *pi)
+static void
+wlc_phy_runsamples_nphy(struct brcms_phy *pi, u16 num_samps, u16 loops,
+			u16 wait, u8 iqmode, u8 dac_test_mode,
+			bool modify_bbmult)
 {
-	u16 txcal_gain[2];
+	u16 bb_mult;
+	u8 phy_bw, sample_cmd;
+	u16 orig_RfseqCoreActv;
+	u16 lpf_bw_ctl_override3, lpf_bw_ctl_override4, lpf_bw_ctl_miscreg3,
+	    lpf_bw_ctl_miscreg4;
 
-	pi->nphy_txcal_pwr_idx[0] = pi->nphy_cal_orig_pwr_idx[0];
-	pi->nphy_txcal_pwr_idx[1] = pi->nphy_cal_orig_pwr_idx[0];
-	wlc_phy_txpwr_index_nphy(pi, 1, pi->nphy_cal_orig_pwr_idx[0], true);
-	wlc_phy_txpwr_index_nphy(pi, 2, pi->nphy_cal_orig_pwr_idx[1], true);
+	if (pi->phyhang_avoid)
+		wlc_phy_stay_in_carriersearch_nphy(pi, true);
 
-	wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x110, 16,
-				txcal_gain);
+	phy_bw = 20;
+	if (CHSPEC_IS40(pi->radio_chanspec))
+		phy_bw = 40;
 
-	if (CHSPEC_IS2G(pi->radio_chanspec)) {
-		txcal_gain[0] = (txcal_gain[0] & 0xF000) | 0x0F40;
-		txcal_gain[1] = (txcal_gain[1] & 0xF000) | 0x0F40;
-	} else {
-		txcal_gain[0] = (txcal_gain[0] & 0xF000) | 0x0F60;
-		txcal_gain[1] = (txcal_gain[1] & 0xF000) | 0x0F60;
+	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+
+		lpf_bw_ctl_override3 = read_phy_reg(pi, 0x342) & (0x1 << 7);
+		lpf_bw_ctl_override4 = read_phy_reg(pi, 0x343) & (0x1 << 7);
+		if (lpf_bw_ctl_override3 | lpf_bw_ctl_override4) {
+			lpf_bw_ctl_miscreg3 = read_phy_reg(pi, 0x340) &
+					      (0x7 << 8);
+			lpf_bw_ctl_miscreg4 = read_phy_reg(pi, 0x341) &
+					      (0x7 << 8);
+		} else {
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi,
+				(0x1 << 7),
+				wlc_phy_read_lpf_bw_ctl_nphy
+					(pi,
+					0), 0, 0,
+				NPHY_REV7_RFCTRLOVERRIDE_ID1);
+
+			pi->nphy_sample_play_lpf_bw_ctl_ovr = true;
+
+			lpf_bw_ctl_miscreg3 = read_phy_reg(pi, 0x340) &
+					      (0x7 << 8);
+			lpf_bw_ctl_miscreg4 = read_phy_reg(pi, 0x341) &
+					      (0x7 << 8);
+		}
 	}
 
-	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x110, 16,
-				 txcal_gain);
-}
+	if ((pi->nphy_bb_mult_save & BB_MULT_VALID_MASK) == 0) {
 
-static void wlc_phy_precal_txgain_nphy(struct brcms_phy *pi)
-{
-	bool save_bbmult = false;
-	u8 txcal_index_2057_rev5n7 = 0;
-	u8 txcal_index_2057_rev3n4n6 = 10;
+		wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_IQLOCAL, 1, 87, 16,
+					&bb_mult);
+		pi->nphy_bb_mult_save =
+			BB_MULT_VALID_MASK | (bb_mult & BB_MULT_MASK);
+	}
 
-	if (pi->use_int_tx_iqlo_cal_nphy) {
-		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-			if ((pi->pubpi.radiorev == 3) ||
-			    (pi->pubpi.radiorev == 4) ||
-			    (pi->pubpi.radiorev == 6)) {
+	if (modify_bbmult) {
+		bb_mult = (phy_bw == 20) ? 100 : 71;
+		bb_mult = (bb_mult << 8) + bb_mult;
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, 1, 87, 16,
+					 &bb_mult);
+	}
 
-				pi->nphy_txcal_pwr_idx[0] =
-					txcal_index_2057_rev3n4n6;
-				pi->nphy_txcal_pwr_idx[1] =
-					txcal_index_2057_rev3n4n6;
-				wlc_phy_txpwr_index_nphy(
-					pi, 3,
-					txcal_index_2057_rev3n4n6,
-					false);
-			} else {
+	if (pi->phyhang_avoid)
+		wlc_phy_stay_in_carriersearch_nphy(pi, false);
 
-				pi->nphy_txcal_pwr_idx[0] =
-					txcal_index_2057_rev5n7;
-				pi->nphy_txcal_pwr_idx[1] =
-					txcal_index_2057_rev5n7;
-				wlc_phy_txpwr_index_nphy(
-					pi, 3,
-					txcal_index_2057_rev5n7,
-					false);
-			}
-			save_bbmult = true;
+	write_phy_reg(pi, 0xc6, num_samps - 1);
 
-		} else if (NREV_LT(pi->pubpi.phy_rev, 5)) {
-			wlc_phy_cal_txgainctrl_nphy(pi, 11, false);
-			if (pi->sh->hw_phytxchain != 3) {
-				pi->nphy_txcal_pwr_idx[1] =
-					pi->nphy_txcal_pwr_idx[0];
-				wlc_phy_txpwr_index_nphy(pi, 3,
-							 pi->
-							 nphy_txcal_pwr_idx[0],
-							 true);
-				save_bbmult = true;
-			}
+	if (loops != 0xffff)
+		write_phy_reg(pi, 0xc4, loops - 1);
+	else
+		write_phy_reg(pi, 0xc4, loops);
 
-		} else if (NREV_IS(pi->pubpi.phy_rev, 5)) {
-			if (PHY_IPA(pi)) {
-				if (CHSPEC_IS2G(pi->radio_chanspec)) {
-					wlc_phy_cal_txgainctrl_nphy(pi, 12,
-								    false);
-				} else {
-					pi->nphy_txcal_pwr_idx[0] = 80;
-					pi->nphy_txcal_pwr_idx[1] = 80;
-					wlc_phy_txpwr_index_nphy(pi, 3, 80,
-								 false);
-					save_bbmult = true;
-				}
-			} else {
-				wlc_phy_internal_cal_txgain_nphy(pi);
-				save_bbmult = true;
-			}
+	write_phy_reg(pi, 0xc5, wait);
+
+	orig_RfseqCoreActv = read_phy_reg(pi, 0xa1);
+	or_phy_reg(pi, 0xa1, NPHY_RfseqMode_CoreActv_override);
+	if (iqmode) {
 
-		} else if (NREV_IS(pi->pubpi.phy_rev, 6)) {
-			if (PHY_IPA(pi)) {
-				if (CHSPEC_IS2G(pi->radio_chanspec))
-					wlc_phy_cal_txgainctrl_nphy(pi, 12,
-								    false);
-				else
-					wlc_phy_cal_txgainctrl_nphy(pi, 14,
-								    false);
-			} else {
-				wlc_phy_internal_cal_txgain_nphy(pi);
-				save_bbmult = true;
-			}
-		}
+		and_phy_reg(pi, 0xc2, 0x7FFF);
 
+		or_phy_reg(pi, 0xc2, 0x8000);
 	} else {
-		wlc_phy_cal_txgainctrl_nphy(pi, 10, false);
+
+		sample_cmd = (dac_test_mode == 1) ? 0x5 : 0x1;
+		write_phy_reg(pi, 0xc3, sample_cmd);
 	}
 
-	if (save_bbmult)
-		wlc_phy_table_read_nphy(pi, 15, 1, 87, 16,
-					&pi->nphy_txcal_bbmult);
+	SPINWAIT(((read_phy_reg(pi, 0xa4) & 0x1) == 1), 1000);
+
+	write_phy_reg(pi, 0xa1, orig_RfseqCoreActv);
 }
 
-void
-wlc_phy_cal_txgainctrl_nphy(struct brcms_phy *pi, s32 dBm_targetpower,
-			    bool debug)
+int
+wlc_phy_tx_tone_nphy(struct brcms_phy *pi, u32 f_kHz, u16 max_val,
+		     u8 iqmode, u8 dac_test_mode, bool modify_bbmult)
 {
-	int gainctrl_loopidx;
-	uint core;
-	u16 m0m1, curr_m0m1;
-	s32 delta_power;
-	s32 txpwrindex;
-	s32 qdBm_power[2];
-	u16 orig_BBConfig;
-	u16 phy_saveregs[4];
-	u32 freq_test;
-	u16 ampl_test = 250;
-	uint stepsize;
-	bool phyhang_avoid_state = false;
+	u16 num_samps;
+	u16 loops = 0xffff;
+	u16 wait = 0;
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7))
-		stepsize = 2;
-	else
-		stepsize = 1;
+	num_samps = wlc_phy_gen_load_samples_nphy(pi, f_kHz, max_val,
+						  dac_test_mode);
+	if (num_samps == 0)
+		return -EBADE;
 
-	if (CHSPEC_IS40(pi->radio_chanspec))
-		freq_test = 5000;
-	else
-		freq_test = 2500;
+	wlc_phy_runsamples_nphy(pi, num_samps, loops, wait, iqmode,
+				dac_test_mode, modify_bbmult);
 
-	wlc_phy_txpwr_index_nphy(pi, 1, pi->nphy_cal_orig_pwr_idx[0], true);
-	wlc_phy_txpwr_index_nphy(pi, 2, pi->nphy_cal_orig_pwr_idx[1], true);
+	return 0;
+}
+
+void wlc_phy_stopplayback_nphy(struct brcms_phy *pi)
+{
+	u16 playback_status;
+	u16 bb_mult;
 
 	if (pi->phyhang_avoid)
 		wlc_phy_stay_in_carriersearch_nphy(pi, true);
 
-	phyhang_avoid_state = pi->phyhang_avoid;
-	pi->phyhang_avoid = false;
+	playback_status = read_phy_reg(pi, 0xc7);
+	if (playback_status & 0x1)
+		or_phy_reg(pi, 0xc3, NPHY_sampleCmd_STOP);
+	else if (playback_status & 0x2)
+		and_phy_reg(pi, 0xc2,
+			    (u16) ~NPHY_iqloCalCmdGctl_IQLO_CAL_EN);
 
-	phy_saveregs[0] = read_phy_reg(pi, 0x91);
-	phy_saveregs[1] = read_phy_reg(pi, 0x92);
-	phy_saveregs[2] = read_phy_reg(pi, 0xe7);
-	phy_saveregs[3] = read_phy_reg(pi, 0xec);
-	wlc_phy_rfctrlintc_override_nphy(pi, NPHY_RfctrlIntc_override_PA, 1,
-					 RADIO_MIMO_CORESEL_CORE1 |
-					 RADIO_MIMO_CORESEL_CORE2);
+	and_phy_reg(pi, 0xc3, (u16) ~(0x1 << 2));
 
-	if (!debug) {
-		wlc_phy_rfctrlintc_override_nphy(pi,
-						 NPHY_RfctrlIntc_override_TRSW,
-						 0x2, RADIO_MIMO_CORESEL_CORE1);
-		wlc_phy_rfctrlintc_override_nphy(pi,
-						 NPHY_RfctrlIntc_override_TRSW,
-						 0x8, RADIO_MIMO_CORESEL_CORE2);
-	} else {
-		wlc_phy_rfctrlintc_override_nphy(pi,
-						 NPHY_RfctrlIntc_override_TRSW,
-						 0x1, RADIO_MIMO_CORESEL_CORE1);
-		wlc_phy_rfctrlintc_override_nphy(pi,
-						 NPHY_RfctrlIntc_override_TRSW,
-						 0x7, RADIO_MIMO_CORESEL_CORE2);
-	}
+	if ((pi->nphy_bb_mult_save & BB_MULT_VALID_MASK) != 0) {
 
-	orig_BBConfig = read_phy_reg(pi, 0x01);
-	mod_phy_reg(pi, 0x01, (0x1 << 15), 0);
+		bb_mult = pi->nphy_bb_mult_save & BB_MULT_MASK;
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, 1, 87, 16,
+					 &bb_mult);
 
-	wlc_phy_table_read_nphy(pi, 15, 1, 87, 16, &m0m1);
+		pi->nphy_bb_mult_save = 0;
+	}
 
-	for (core = 0; core < pi->pubpi.phy_corenum; core++) {
-		txpwrindex = (s32) pi->nphy_cal_orig_pwr_idx[core];
+	if (NREV_IS(pi->pubpi.phy_rev, 7) || NREV_GE(pi->pubpi.phy_rev, 8)) {
+		if (pi->nphy_sample_play_lpf_bw_ctl_ovr) {
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi,
+				(0x1 << 7),
+				0, 0, 1,
+				NPHY_REV7_RFCTRLOVERRIDE_ID1);
+			pi->nphy_sample_play_lpf_bw_ctl_ovr = false;
+		}
+	}
 
-		for (gainctrl_loopidx = 0; gainctrl_loopidx < 2;
-		     gainctrl_loopidx++) {
-			wlc_phy_tx_tone_nphy(pi, freq_test, ampl_test, 0, 0,
-					     false);
+	if (pi->phyhang_avoid)
+		wlc_phy_stay_in_carriersearch_nphy(pi, false);
+}
 
-			if (core == PHY_CORE_0)
-				curr_m0m1 = m0m1 & 0xff00;
-			else
-				curr_m0m1 = m0m1 & 0x00ff;
+static u32 *brcms_phy_get_tx_pwrctrl_tbl(struct brcms_phy *pi)
+{
+	u32 *tx_pwrctrl_tbl = NULL;
+	uint phyrev = pi->pubpi.phy_rev;
 
-			wlc_phy_table_write_nphy(pi, 15, 1, 87, 16, &curr_m0m1);
-			wlc_phy_table_write_nphy(pi, 15, 1, 95, 16, &curr_m0m1);
+	if (PHY_IPA(pi)) {
+		tx_pwrctrl_tbl =
+			wlc_phy_get_ipa_gaintbl_nphy(pi);
+	} else {
+		if (CHSPEC_IS5G(pi->radio_chanspec)) {
+			if (NREV_IS(phyrev, 3))
+				tx_pwrctrl_tbl = nphy_tpc_5GHz_txgain_rev3;
+			else if (NREV_IS(phyrev, 4))
+				tx_pwrctrl_tbl =
+					(pi->srom_fem5g.extpagain == 3) ?
+					nphy_tpc_5GHz_txgain_HiPwrEPA :
+					nphy_tpc_5GHz_txgain_rev4;
+			else
+				tx_pwrctrl_tbl = nphy_tpc_5GHz_txgain_rev5;
+		} else {
+			if (NREV_GE(phyrev, 7)) {
+				if (pi->pubpi.radiorev == 3)
+					tx_pwrctrl_tbl =
+						nphy_tpc_txgain_epa_2057rev3;
+				else if (pi->pubpi.radiorev == 5)
+					tx_pwrctrl_tbl =
+						nphy_tpc_txgain_epa_2057rev5;
+			} else {
+				if (NREV_GE(phyrev, 5) &&
+				   (pi->srom_fem2g.extpagain ==	3))
+					tx_pwrctrl_tbl =
+						nphy_tpc_txgain_HiPwrEPA;
+				else
+					tx_pwrctrl_tbl =
+						nphy_tpc_txgain_rev3;
+			}
+		}
+	}
+	return tx_pwrctrl_tbl;
+}
 
-			udelay(50);
+struct nphy_txgains wlc_phy_get_tx_gain_nphy(struct brcms_phy *pi)
+{
+	u16 base_idx[2], curr_gain[2];
+	u8 core_no;
+	struct nphy_txgains target_gain;
+	u32 *tx_pwrctrl_tbl = NULL;
 
-			wlc_phy_est_tonepwr_nphy(pi, qdBm_power,
-						 NPHY_CAL_TSSISAMPS);
+	if (pi->nphy_txpwrctrl == PHY_TPC_HW_OFF) {
+		if (pi->phyhang_avoid)
+			wlc_phy_stay_in_carriersearch_nphy(pi, true);
 
-			pi->nphy_bb_mult_save = 0;
-			wlc_phy_stopplayback_nphy(pi);
+		wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x110, 16,
+					curr_gain);
 
-			delta_power = (dBm_targetpower * 4) - qdBm_power[core];
+		if (pi->phyhang_avoid)
+			wlc_phy_stay_in_carriersearch_nphy(pi, false);
 
-			txpwrindex -= stepsize * delta_power;
-			if (txpwrindex < 0)
-				txpwrindex = 0;
-			else if (txpwrindex > 127)
-				txpwrindex = 127;
+		for (core_no = 0; core_no < 2; core_no++) {
+			if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+				target_gain.ipa[core_no] =
+					curr_gain[core_no] & 0x0007;
+				target_gain.pad[core_no] =
+					((curr_gain[core_no] & 0x00F8) >> 3);
+				target_gain.pga[core_no] =
+					((curr_gain[core_no] & 0x0F00) >> 8);
+				target_gain.txgm[core_no] =
+					((curr_gain[core_no] & 0x7000) >> 12);
+				target_gain.txlpf[core_no] =
+					((curr_gain[core_no] & 0x8000) >> 15);
+			} else if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+				target_gain.ipa[core_no] =
+					curr_gain[core_no] & 0x000F;
+				target_gain.pad[core_no] =
+					((curr_gain[core_no] & 0x00F0) >> 4);
+				target_gain.pga[core_no] =
+					((curr_gain[core_no] & 0x0F00) >> 8);
+				target_gain.txgm[core_no] =
+					((curr_gain[core_no] & 0x7000) >> 12);
+			} else {
+				target_gain.ipa[core_no] =
+					curr_gain[core_no] & 0x0003;
+				target_gain.pad[core_no] =
+					((curr_gain[core_no] & 0x000C) >> 2);
+				target_gain.pga[core_no] =
+					((curr_gain[core_no] & 0x0070) >> 4);
+				target_gain.txgm[core_no] =
+					((curr_gain[core_no] & 0x0380) >> 7);
+			}
+		}
+	} else {
+		uint phyrev = pi->pubpi.phy_rev;
 
-			if (CHSPEC_IS5G(pi->radio_chanspec)) {
-				if (NREV_IS(pi->pubpi.phy_rev, 4) &&
-				    (pi->srom_fem5g.extpagain == 3)) {
-					if (txpwrindex < 30)
-						txpwrindex = 30;
+		base_idx[0] = (read_phy_reg(pi, 0x1ed) >> 8) & 0x7f;
+		base_idx[1] = (read_phy_reg(pi, 0x1ee) >> 8) & 0x7f;
+		for (core_no = 0; core_no < 2; core_no++) {
+			if (NREV_GE(phyrev, 3)) {
+				tx_pwrctrl_tbl =
+					brcms_phy_get_tx_pwrctrl_tbl(pi);
+				if (NREV_GE(phyrev, 7)) {
+					target_gain.ipa[core_no] =
+						(tx_pwrctrl_tbl
+						 [base_idx[core_no]]
+						 >> 16) & 0x7;
+					target_gain.pad[core_no] =
+						(tx_pwrctrl_tbl
+						 [base_idx[core_no]]
+						 >> 19) & 0x1f;
+					target_gain.pga[core_no] =
+						(tx_pwrctrl_tbl
+						 [base_idx[core_no]]
+						 >> 24) & 0xf;
+					target_gain.txgm[core_no] =
+						(tx_pwrctrl_tbl
+						 [base_idx[core_no]]
+						 >> 28) & 0x7;
+					target_gain.txlpf[core_no] =
+						(tx_pwrctrl_tbl
+						 [base_idx[core_no]]
+						 >> 31) & 0x1;
+				} else {
+					target_gain.ipa[core_no] =
+						(tx_pwrctrl_tbl
+						 [base_idx[core_no]]
+						 >> 16) & 0xf;
+					target_gain.pad[core_no] =
+						(tx_pwrctrl_tbl
+						 [base_idx[core_no]]
+						 >> 20) & 0xf;
+					target_gain.pga[core_no] =
+						(tx_pwrctrl_tbl
+						 [base_idx[core_no]]
+						 >> 24) & 0xf;
+					target_gain.txgm[core_no] =
+						(tx_pwrctrl_tbl
+						[base_idx[core_no]]
+						 >> 28) & 0x7;
 				}
 			} else {
-				if (NREV_GE(pi->pubpi.phy_rev, 5) &&
-				    (pi->srom_fem2g.extpagain == 3)) {
-					if (txpwrindex < 50)
-						txpwrindex = 50;
-				}
+				target_gain.ipa[core_no] =
+					(nphy_tpc_txgain[base_idx[core_no]] >>
+					 16) & 0x3;
+				target_gain.pad[core_no] =
+					(nphy_tpc_txgain[base_idx[core_no]] >>
+					 18) & 0x3;
+				target_gain.pga[core_no] =
+					(nphy_tpc_txgain[base_idx[core_no]] >>
+					 20) & 0x7;
+				target_gain.txgm[core_no] =
+					(nphy_tpc_txgain[base_idx[core_no]] >>
+					 23) & 0x7;
 			}
-
-			wlc_phy_txpwr_index_nphy(pi, (1 << core),
-						 (u8) txpwrindex, true);
-		}
-
-		pi->nphy_txcal_pwr_idx[core] = (u8) txpwrindex;
-
-		if (debug) {
-			u16 radio_gain;
-			u16 dbg_m0m1;
-
-			wlc_phy_table_read_nphy(pi, 15, 1, 87, 16, &dbg_m0m1);
-
-			wlc_phy_tx_tone_nphy(pi, freq_test, ampl_test, 0, 0,
-					     false);
-
-			wlc_phy_table_write_nphy(pi, 15, 1, 87, 16, &dbg_m0m1);
-			wlc_phy_table_write_nphy(pi, 15, 1, 95, 16, &dbg_m0m1);
-
-			udelay(100);
-
-			wlc_phy_est_tonepwr_nphy(pi, qdBm_power,
-						 NPHY_CAL_TSSISAMPS);
-
-			wlc_phy_table_read_nphy(pi, 7, 1, (0x110 + core), 16,
-						&radio_gain);
-
-			mdelay(4000);
-			pi->nphy_bb_mult_save = 0;
-			wlc_phy_stopplayback_nphy(pi);
 		}
 	}
 
-	wlc_phy_txpwr_index_nphy(pi, 1, pi->nphy_txcal_pwr_idx[0], true);
-	wlc_phy_txpwr_index_nphy(pi, 2, pi->nphy_txcal_pwr_idx[1], true);
-
-	wlc_phy_table_read_nphy(pi, 15, 1, 87, 16, &pi->nphy_txcal_bbmult);
-
-	write_phy_reg(pi, 0x01, orig_BBConfig);
-
-	write_phy_reg(pi, 0x91, phy_saveregs[0]);
-	write_phy_reg(pi, 0x92, phy_saveregs[1]);
-	write_phy_reg(pi, 0xe7, phy_saveregs[2]);
-	write_phy_reg(pi, 0xec, phy_saveregs[3]);
-
-	pi->phyhang_avoid = phyhang_avoid_state;
-
-	if (pi->phyhang_avoid)
-		wlc_phy_stay_in_carriersearch_nphy(pi, false);
+	return target_gain;
 }
 
-static void wlc_phy_update_txcal_ladder_nphy(struct brcms_phy *pi, u16 core)
+static void
+wlc_phy_iqcal_gainparams_nphy(struct brcms_phy *pi, u16 core_no,
+			      struct nphy_txgains target_gain,
+			      struct nphy_iqcal_params *params)
 {
-	int index;
-	u32 bbmult_scale;
-	u16 bbmult;
-	u16 tblentry;
-
-	struct nphy_txiqcal_ladder ladder_lo[] = {
-		{3, 0}, {4, 0}, {6, 0}, {9, 0}, {13, 0}, {18, 0},
-		{25, 0}, {25, 1}, {25, 2}, {25, 3}, {25, 4}, {25, 5},
-		{25, 6}, {25, 7}, {35, 7}, {50, 7}, {71, 7}, {100, 7}
-	};
+	u8 k;
+	int idx;
+	u16 gain_index;
+	u8 band_idx = (CHSPEC_IS5G(pi->radio_chanspec) ? 1 : 0);
 
-	struct nphy_txiqcal_ladder ladder_iq[] = {
-		{3, 0}, {4, 0}, {6, 0}, {9, 0}, {13, 0}, {18, 0},
-		{25, 0}, {35, 0}, {50, 0}, {71, 0}, {100, 0}, {100, 1},
-		{100, 2}, {100, 3}, {100, 4}, {100, 5}, {100, 6}, {100, 7}
-	};
+	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+		if (NREV_GE(pi->pubpi.phy_rev, 7))
+			params->txlpf = target_gain.txlpf[core_no];
 
-	bbmult = (core == PHY_CORE_0) ?
-		 ((pi->nphy_txcal_bbmult >> 8) & 0xff) :
-		 (pi->nphy_txcal_bbmult & 0xff);
+		params->txgm = target_gain.txgm[core_no];
+		params->pga = target_gain.pga[core_no];
+		params->pad = target_gain.pad[core_no];
+		params->ipa = target_gain.ipa[core_no];
+		if (NREV_GE(pi->pubpi.phy_rev, 7))
+			params->cal_gain =
+				((params->txlpf << 15) | (params->txgm << 12) |
+				 (params->pga << 8) |
+				 (params->pad << 3) | (params->ipa));
+		else
+			params->cal_gain =
+				((params->txgm << 12) | (params->pga << 8) |
+				 (params->pad << 4) | (params->ipa));
 
-	for (index = 0; index < 18; index++) {
-		bbmult_scale = ladder_lo[index].percent * bbmult;
-		bbmult_scale /= 100;
+		params->ncorr[0] = 0x79;
+		params->ncorr[1] = 0x79;
+		params->ncorr[2] = 0x79;
+		params->ncorr[3] = 0x79;
+		params->ncorr[4] = 0x79;
+	} else {
 
-		tblentry =
-			((bbmult_scale & 0xff) << 8) | ladder_lo[index].g_env;
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, 1, index, 16,
-					 &tblentry);
+		gain_index = ((target_gain.pad[core_no] << 0) |
+			      (target_gain.pga[core_no] << 4) |
+			      (target_gain.txgm[core_no] << 8));
 
-		bbmult_scale = ladder_iq[index].percent * bbmult;
-		bbmult_scale /= 100;
+		idx = -1;
+		for (k = 0; k < NPHY_IQCAL_NUMGAINS; k++) {
+			if (tbl_iqcal_gainparams_nphy[band_idx][k][0] ==
+			    gain_index) {
+				idx = k;
+				break;
+			}
+		}
 
-		tblentry =
-			((bbmult_scale & 0xff) << 8) | ladder_iq[index].g_env;
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, 1, index + 32,
-					 16, &tblentry);
+		params->txgm = tbl_iqcal_gainparams_nphy[band_idx][k][1];
+		params->pga = tbl_iqcal_gainparams_nphy[band_idx][k][2];
+		params->pad = tbl_iqcal_gainparams_nphy[band_idx][k][3];
+		params->cal_gain = ((params->txgm << 7) | (params->pga << 4) |
+				    (params->pad << 2));
+		params->ncorr[0] = tbl_iqcal_gainparams_nphy[band_idx][k][4];
+		params->ncorr[1] = tbl_iqcal_gainparams_nphy[band_idx][k][5];
+		params->ncorr[2] = tbl_iqcal_gainparams_nphy[band_idx][k][6];
+		params->ncorr[3] = tbl_iqcal_gainparams_nphy[band_idx][k][7];
 	}
 }
 
-void wlc_phy_cal_perical_nphy_run(struct brcms_phy *pi, u8 caltype)
+static void wlc_phy_txcal_radio_setup_nphy(struct brcms_phy *pi)
 {
-	struct nphy_txgains target_gain;
-	u8 tx_pwr_ctrl_state;
-	bool fullcal = true;
-	bool restore_tx_gain = false;
-	bool mphase;
-
-	if (PHY_MUTED(pi))
-		return;
-
-	if (caltype == PHY_PERICAL_AUTO)
-		fullcal = (pi->radio_chanspec != pi->nphy_txiqlocal_chanspec);
-	else if (caltype == PHY_PERICAL_PARTIAL)
-		fullcal = false;
-
-	if (pi->cal_type_override != PHY_PERICAL_AUTO)
-		fullcal =
-			(pi->cal_type_override ==
-			 PHY_PERICAL_FULL) ? true : false;
-
-	if ((pi->mphase_cal_phase_id > MPHASE_CAL_STATE_INIT)) {
-		if (pi->nphy_txiqlocal_chanspec != pi->radio_chanspec)
-			wlc_phy_cal_perical_mphase_restart(pi);
-	}
+	u16 jtag_core, core;
 
-	if ((pi->mphase_cal_phase_id == MPHASE_CAL_STATE_RXCAL))
-		wlapi_bmac_write_shm(pi->sh->physhim, M_CTS_DURATION, 10000);
+	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 
-	wlapi_suspend_mac_and_wait(pi->sh->physhim);
+		for (core = 0; core <= 1; core++) {
 
-	wlc_phyreg_enter((struct brcms_phy_pub *) pi);
+			pi->tx_rx_cal_radio_saveregs[(core * 11) + 0] =
+				READ_RADIO_REG3(pi, RADIO_2057, TX, core,
+						TX_SSI_MASTER);
 
-	if ((pi->mphase_cal_phase_id == MPHASE_CAL_STATE_IDLE) ||
-	    (pi->mphase_cal_phase_id == MPHASE_CAL_STATE_INIT)) {
-		pi->nphy_cal_orig_pwr_idx[0] =
-			(u8) ((read_phy_reg(pi, 0x1ed) >> 8) & 0x7f);
-		pi->nphy_cal_orig_pwr_idx[1] =
-			(u8) ((read_phy_reg(pi, 0x1ee) >> 8) & 0x7f);
+			pi->tx_rx_cal_radio_saveregs[(core * 11) + 1] =
+				READ_RADIO_REG3(pi, RADIO_2057, TX, core,
+						IQCAL_VCM_HG);
 
-		if (pi->nphy_txpwrctrl != PHY_TPC_HW_OFF) {
-			wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_RFSEQ, 2,
-						0x110, 16,
-						pi->nphy_cal_orig_tx_gain);
-		} else {
-			pi->nphy_cal_orig_tx_gain[0] = 0;
-			pi->nphy_cal_orig_tx_gain[1] = 0;
-		}
-	}
-	target_gain = wlc_phy_get_tx_gain_nphy(pi);
-	tx_pwr_ctrl_state = pi->nphy_txpwrctrl;
-	wlc_phy_txpwrctrl_enable_nphy(pi, PHY_TPC_HW_OFF);
+			pi->tx_rx_cal_radio_saveregs[(core * 11) + 2] =
+				READ_RADIO_REG3(pi, RADIO_2057, TX, core,
+						IQCAL_IDAC);
 
-	if (pi->antsel_type == ANTSEL_2x3)
-		wlc_phy_antsel_init((struct brcms_phy_pub *) pi, true);
+			pi->tx_rx_cal_radio_saveregs[(core * 11) + 3] =
+				READ_RADIO_REG3(pi, RADIO_2057, TX, core,
+						TSSI_VCM);
 
-	mphase = (pi->mphase_cal_phase_id != MPHASE_CAL_STATE_IDLE);
-	if (!mphase) {
+			pi->tx_rx_cal_radio_saveregs[(core * 11) + 4] = 0;
 
-		if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-			wlc_phy_precal_txgain_nphy(pi);
-			pi->nphy_cal_target_gain = wlc_phy_get_tx_gain_nphy(pi);
-			restore_tx_gain = true;
+			pi->tx_rx_cal_radio_saveregs[(core * 11) + 5] =
+				READ_RADIO_REG3(pi, RADIO_2057, TX, core,
+						TX_SSI_MUX);
 
-			target_gain = pi->nphy_cal_target_gain;
-		}
-		if (0 ==
-		    wlc_phy_cal_txiqlo_nphy(pi, target_gain, fullcal,
-					    mphase)) {
-			if (PHY_IPA(pi))
-				wlc_phy_a4(pi, true);
+			if (pi->pubpi.radiorev != 5)
+				pi->tx_rx_cal_radio_saveregs[(core * 11) + 6] =
+					READ_RADIO_REG3(pi, RADIO_2057, TX,
+							core,
+							TSSIA);
 
-			wlc_phyreg_exit((struct brcms_phy_pub *) pi);
-			wlapi_enable_mac(pi->sh->physhim);
-			wlapi_bmac_write_shm(pi->sh->physhim, M_CTS_DURATION,
-					     10000);
-			wlapi_suspend_mac_and_wait(pi->sh->physhim);
-			wlc_phyreg_enter((struct brcms_phy_pub *) pi);
+			pi->tx_rx_cal_radio_saveregs[(core * 11) + 7] =
+			       READ_RADIO_REG3(pi, RADIO_2057, TX, core, TSSIG);
 
-			if (0 == wlc_phy_cal_rxiq_nphy(pi, target_gain,
-					(pi->first_cal_after_assoc ||
-					(pi->cal_type_override ==
-					 PHY_PERICAL_FULL)) ? 2 : 0, false)) {
-				wlc_phy_savecal_nphy(pi);
+			pi->tx_rx_cal_radio_saveregs[(core * 11) + 8] =
+				READ_RADIO_REG3(pi, RADIO_2057, TX, core,
+						TSSI_MISC1);
 
-				wlc_phy_txpwrctrl_coeff_setup_nphy(pi);
+			if (CHSPEC_IS5G(pi->radio_chanspec)) {
+				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
+						 TX_SSI_MASTER, 0x0a);
+				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
+						 IQCAL_VCM_HG, 0x43);
+				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
+						 IQCAL_IDAC, 0x55);
+				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
+						 TSSI_VCM, 0x00);
+				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
+						 TSSIG, 0x00);
+				if (pi->use_int_tx_iqlo_cal_nphy) {
+					WRITE_RADIO_REG3(pi, RADIO_2057, TX,
+							 core, TX_SSI_MUX, 0x4);
+					if (!(pi->
+					internal_tx_iqlo_cal_tapoff_intpa_nphy))
+						WRITE_RADIO_REG3(pi, RADIO_2057,
+								 TX, core,
+								 TSSIA, 0x31);
+					else
+						WRITE_RADIO_REG3(pi, RADIO_2057,
+								 TX, core,
+								 TSSIA, 0x21);
+				}
+				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
+						 TSSI_MISC1, 0x00);
+			} else {
+				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
+						 TX_SSI_MASTER, 0x06);
+				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
+						 IQCAL_VCM_HG, 0x43);
+				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
+						 IQCAL_IDAC, 0x55);
+				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
+						 TSSI_VCM, 0x00);
 
-				pi->nphy_perical_last = pi->sh->now;
+				if (pi->pubpi.radiorev != 5)
+					WRITE_RADIO_REG3(pi, RADIO_2057, TX,
+							 core, TSSIA, 0x00);
+				if (pi->use_int_tx_iqlo_cal_nphy) {
+					WRITE_RADIO_REG3(pi, RADIO_2057, TX,
+							 core, TX_SSI_MUX,
+							 0x06);
+					if (!(pi->
+					internal_tx_iqlo_cal_tapoff_intpa_nphy))
+						WRITE_RADIO_REG3(pi, RADIO_2057,
+								 TX, core,
+								 TSSIG, 0x31);
+					else
+						WRITE_RADIO_REG3(pi, RADIO_2057,
+								 TX, core,
+								 TSSIG, 0x21);
+				}
+				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
+						 TSSI_MISC1, 0x00);
 			}
 		}
-		if (caltype != PHY_PERICAL_AUTO)
-			wlc_phy_rssi_cal_nphy(pi);
+	} else if (NREV_GE(pi->pubpi.phy_rev, 3)) {
 
-		if (pi->first_cal_after_assoc
-		    || (pi->cal_type_override == PHY_PERICAL_FULL)) {
-			pi->first_cal_after_assoc = false;
-			wlc_phy_txpwrctrl_idle_tssi_nphy(pi);
-			wlc_phy_txpwrctrl_pwr_setup_nphy(pi);
-		}
+		for (core = 0; core <= 1; core++) {
+			jtag_core =
+				(core ==
+				 PHY_CORE_0) ? RADIO_2056_TX0 : RADIO_2056_TX1;
 
-		if (NREV_GE(pi->pubpi.phy_rev, 3))
-			wlc_phy_radio205x_vcocal_nphy(pi);
-	} else {
-		switch (pi->mphase_cal_phase_id) {
-		case MPHASE_CAL_STATE_INIT:
-			pi->nphy_perical_last = pi->sh->now;
-			pi->nphy_txiqlocal_chanspec = pi->radio_chanspec;
+			pi->tx_rx_cal_radio_saveregs[(core * 11) + 0] =
+				read_radio_reg(pi,
+					       RADIO_2056_TX_TX_SSI_MASTER |
+					       jtag_core);
 
-			if (NREV_GE(pi->pubpi.phy_rev, 3))
-				wlc_phy_precal_txgain_nphy(pi);
+			pi->tx_rx_cal_radio_saveregs[(core * 11) + 1] =
+				read_radio_reg(pi,
+					       RADIO_2056_TX_IQCAL_VCM_HG |
+					       jtag_core);
 
-			pi->nphy_cal_target_gain = wlc_phy_get_tx_gain_nphy(pi);
-			pi->mphase_cal_phase_id++;
-			break;
+			pi->tx_rx_cal_radio_saveregs[(core * 11) + 2] =
+				read_radio_reg(pi,
+					       RADIO_2056_TX_IQCAL_IDAC |
+					       jtag_core);
 
-		case MPHASE_CAL_STATE_TXPHASE0:
-		case MPHASE_CAL_STATE_TXPHASE1:
-		case MPHASE_CAL_STATE_TXPHASE2:
-		case MPHASE_CAL_STATE_TXPHASE3:
-		case MPHASE_CAL_STATE_TXPHASE4:
-		case MPHASE_CAL_STATE_TXPHASE5:
-			if ((pi->radar_percal_mask & 0x10) != 0)
-				pi->nphy_rxcal_active = true;
+			pi->tx_rx_cal_radio_saveregs[(core * 11) + 3] =
+				read_radio_reg(
+					pi,
+					RADIO_2056_TX_TSSI_VCM |
+					jtag_core);
 
-			if (wlc_phy_cal_txiqlo_nphy
-				    (pi, pi->nphy_cal_target_gain, fullcal,
-				    true) != 0) {
+			pi->tx_rx_cal_radio_saveregs[(core * 11) + 4] =
+				read_radio_reg(pi,
+					       RADIO_2056_TX_TX_AMP_DET |
+					       jtag_core);
 
-				wlc_phy_cal_perical_mphase_reset(pi);
-				break;
-			}
+			pi->tx_rx_cal_radio_saveregs[(core * 11) + 5] =
+				read_radio_reg(pi,
+					       RADIO_2056_TX_TX_SSI_MUX |
+					       jtag_core);
 
-			if (NREV_LE(pi->pubpi.phy_rev, 2) &&
-			    (pi->mphase_cal_phase_id ==
-			     MPHASE_CAL_STATE_TXPHASE4))
-				pi->mphase_cal_phase_id += 2;
-			else
-				pi->mphase_cal_phase_id++;
-			break;
+			pi->tx_rx_cal_radio_saveregs[(core * 11) + 6] =
+				read_radio_reg(pi,
+					       RADIO_2056_TX_TSSIA | jtag_core);
 
-		case MPHASE_CAL_STATE_PAPDCAL:
-			if ((pi->radar_percal_mask & 0x2) != 0)
-				pi->nphy_rxcal_active = true;
+			pi->tx_rx_cal_radio_saveregs[(core * 11) + 7] =
+				read_radio_reg(pi,
+					       RADIO_2056_TX_TSSIG | jtag_core);
 
-			if (PHY_IPA(pi))
-				wlc_phy_a4(pi, true);
+			pi->tx_rx_cal_radio_saveregs[(core * 11) + 8] =
+				read_radio_reg(pi,
+					       RADIO_2056_TX_TSSI_MISC1 |
+					       jtag_core);
 
-			pi->mphase_cal_phase_id++;
-			break;
+			pi->tx_rx_cal_radio_saveregs[(core * 11) + 9] =
+				read_radio_reg(pi,
+					       RADIO_2056_TX_TSSI_MISC2 |
+					       jtag_core);
 
-		case MPHASE_CAL_STATE_RXCAL:
-			if ((pi->radar_percal_mask & 0x1) != 0)
-				pi->nphy_rxcal_active = true;
-			if (wlc_phy_cal_rxiq_nphy(pi, target_gain,
-						  (pi->first_cal_after_assoc ||
-						   (pi->cal_type_override ==
-						    PHY_PERICAL_FULL)) ? 2 : 0,
-						  false) == 0)
-				wlc_phy_savecal_nphy(pi);
+			pi->tx_rx_cal_radio_saveregs[(core * 11) + 10] =
+				read_radio_reg(pi,
+					       RADIO_2056_TX_TSSI_MISC3 |
+					       jtag_core);
 
-			pi->mphase_cal_phase_id++;
-			break;
+			if (CHSPEC_IS5G(pi->radio_chanspec)) {
+				write_radio_reg(pi,
+						RADIO_2056_TX_TX_SSI_MASTER |
+						jtag_core, 0x0a);
+				write_radio_reg(pi,
+						RADIO_2056_TX_IQCAL_VCM_HG |
+						jtag_core, 0x40);
+				write_radio_reg(pi,
+						RADIO_2056_TX_IQCAL_IDAC |
+						jtag_core, 0x55);
+				write_radio_reg(pi,
+						RADIO_2056_TX_TSSI_VCM |
+						jtag_core, 0x00);
+				write_radio_reg(pi,
+						RADIO_2056_TX_TX_AMP_DET |
+						jtag_core, 0x00);
 
-		case MPHASE_CAL_STATE_RSSICAL:
-			if ((pi->radar_percal_mask & 0x4) != 0)
-				pi->nphy_rxcal_active = true;
-			wlc_phy_txpwrctrl_coeff_setup_nphy(pi);
-			wlc_phy_rssi_cal_nphy(pi);
+				if (PHY_IPA(pi)) {
+					write_radio_reg(
+						pi,
+						RADIO_2056_TX_TX_SSI_MUX
+						| jtag_core, 0x4);
+					write_radio_reg(pi,
+							RADIO_2056_TX_TSSIA |
+							jtag_core, 0x1);
+				} else {
+					write_radio_reg(
+						pi,
+						RADIO_2056_TX_TX_SSI_MUX
+						| jtag_core, 0x00);
+					write_radio_reg(pi,
+							RADIO_2056_TX_TSSIA |
+							jtag_core, 0x2f);
+				}
+				write_radio_reg(pi,
+						RADIO_2056_TX_TSSIG | jtag_core,
+						0x00);
+				write_radio_reg(pi,
+						RADIO_2056_TX_TSSI_MISC1 |
+						jtag_core, 0x00);
 
-			if (NREV_GE(pi->pubpi.phy_rev, 3))
-				wlc_phy_radio205x_vcocal_nphy(pi);
+				write_radio_reg(pi,
+						RADIO_2056_TX_TSSI_MISC2 |
+						jtag_core, 0x00);
+				write_radio_reg(pi,
+						RADIO_2056_TX_TSSI_MISC3 |
+						jtag_core, 0x00);
+			} else {
+				write_radio_reg(pi,
+						RADIO_2056_TX_TX_SSI_MASTER |
+						jtag_core, 0x06);
+				write_radio_reg(pi,
+						RADIO_2056_TX_IQCAL_VCM_HG |
+						jtag_core, 0x40);
+				write_radio_reg(pi,
+						RADIO_2056_TX_IQCAL_IDAC |
+						jtag_core, 0x55);
+				write_radio_reg(pi,
+						RADIO_2056_TX_TSSI_VCM |
+						jtag_core, 0x00);
+				write_radio_reg(pi,
+						RADIO_2056_TX_TX_AMP_DET |
+						jtag_core, 0x00);
+				write_radio_reg(pi,
+						RADIO_2056_TX_TSSIA | jtag_core,
+						0x00);
+
+				if (PHY_IPA(pi)) {
+
+					write_radio_reg(
+						pi,
+						RADIO_2056_TX_TX_SSI_MUX
+						| jtag_core, 0x06);
+					if (NREV_LT(pi->pubpi.phy_rev, 5))
+						write_radio_reg(
+							pi,
+							RADIO_2056_TX_TSSIG
+							| jtag_core,
+							0x11);
+					else
+						write_radio_reg(
+							pi,
+							RADIO_2056_TX_TSSIG
+							| jtag_core,
+							0x1);
+				} else {
+					write_radio_reg(
+						pi,
+						RADIO_2056_TX_TX_SSI_MUX
+						| jtag_core, 0x00);
+					write_radio_reg(pi,
+							RADIO_2056_TX_TSSIG |
+							jtag_core, 0x20);
+				}
 
-			restore_tx_gain = true;
+				write_radio_reg(pi,
+						RADIO_2056_TX_TSSI_MISC1 |
+						jtag_core, 0x00);
+				write_radio_reg(pi,
+						RADIO_2056_TX_TSSI_MISC2 |
+						jtag_core, 0x00);
+				write_radio_reg(pi,
+						RADIO_2056_TX_TSSI_MISC3 |
+						jtag_core, 0x00);
+			}
+		}
+	} else {
 
-			if (pi->first_cal_after_assoc)
-				pi->mphase_cal_phase_id++;
-			else
-				wlc_phy_cal_perical_mphase_reset(pi);
+		pi->tx_rx_cal_radio_saveregs[0] =
+			read_radio_reg(pi, RADIO_2055_CORE1_TXRF_IQCAL1);
+		write_radio_reg(pi, RADIO_2055_CORE1_TXRF_IQCAL1, 0x29);
+		pi->tx_rx_cal_radio_saveregs[1] =
+			read_radio_reg(pi, RADIO_2055_CORE1_TXRF_IQCAL2);
+		write_radio_reg(pi, RADIO_2055_CORE1_TXRF_IQCAL2, 0x54);
 
-			break;
+		pi->tx_rx_cal_radio_saveregs[2] =
+			read_radio_reg(pi, RADIO_2055_CORE2_TXRF_IQCAL1);
+		write_radio_reg(pi, RADIO_2055_CORE2_TXRF_IQCAL1, 0x29);
+		pi->tx_rx_cal_radio_saveregs[3] =
+			read_radio_reg(pi, RADIO_2055_CORE2_TXRF_IQCAL2);
+		write_radio_reg(pi, RADIO_2055_CORE2_TXRF_IQCAL2, 0x54);
 
-		case MPHASE_CAL_STATE_IDLETSSI:
-			if ((pi->radar_percal_mask & 0x8) != 0)
-				pi->nphy_rxcal_active = true;
+		pi->tx_rx_cal_radio_saveregs[4] =
+			read_radio_reg(pi, RADIO_2055_PWRDET_RXTX_CORE1);
+		pi->tx_rx_cal_radio_saveregs[5] =
+			read_radio_reg(pi, RADIO_2055_PWRDET_RXTX_CORE2);
 
-			if (pi->first_cal_after_assoc) {
-				pi->first_cal_after_assoc = false;
-				wlc_phy_txpwrctrl_idle_tssi_nphy(pi);
-				wlc_phy_txpwrctrl_pwr_setup_nphy(pi);
-			}
+		if ((read_phy_reg(pi, 0x09) & NPHY_BandControl_currentBand) ==
+		    0) {
 
-			wlc_phy_cal_perical_mphase_reset(pi);
-			break;
+			write_radio_reg(pi, RADIO_2055_PWRDET_RXTX_CORE1, 0x04);
+			write_radio_reg(pi, RADIO_2055_PWRDET_RXTX_CORE2, 0x04);
+		} else {
 
-		default:
-			wlc_phy_cal_perical_mphase_reset(pi);
-			break;
+			write_radio_reg(pi, RADIO_2055_PWRDET_RXTX_CORE1, 0x20);
+			write_radio_reg(pi, RADIO_2055_PWRDET_RXTX_CORE2, 0x20);
 		}
-	}
 
-	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-		if (restore_tx_gain) {
-			if (tx_pwr_ctrl_state != PHY_TPC_HW_OFF) {
+		if (NREV_LT(pi->pubpi.phy_rev, 2)) {
 
-				wlc_phy_txpwr_index_nphy(pi, 1,
-							 pi->
-							 nphy_cal_orig_pwr_idx
-							 [0], false);
-				wlc_phy_txpwr_index_nphy(pi, 2,
-							 pi->
-							 nphy_cal_orig_pwr_idx
-							 [1], false);
+			or_radio_reg(pi, RADIO_2055_CORE1_TX_BB_MXGM, 0x20);
+			or_radio_reg(pi, RADIO_2055_CORE2_TX_BB_MXGM, 0x20);
+		} else {
 
-				pi->nphy_txpwrindex[0].index = -1;
-				pi->nphy_txpwrindex[1].index = -1;
-			} else {
-				wlc_phy_txpwr_index_nphy(pi, (1 << 0),
-							 (s8) (pi->
-							       nphy_txpwrindex
-							       [0].
-							       index_internal),
-							 false);
-				wlc_phy_txpwr_index_nphy(pi, (1 << 1),
-							 (s8) (pi->
-							       nphy_txpwrindex
-							       [1].
-							       index_internal),
-							 false);
-			}
+			and_radio_reg(pi, RADIO_2055_CORE1_TX_BB_MXGM, 0xdf);
+			and_radio_reg(pi, RADIO_2055_CORE2_TX_BB_MXGM, 0xdf);
 		}
 	}
-
-	wlc_phy_txpwrctrl_enable_nphy(pi, tx_pwr_ctrl_state);
-	wlc_phyreg_exit((struct brcms_phy_pub *) pi);
-	wlapi_enable_mac(pi->sh->physhim);
 }
 
-int
-wlc_phy_cal_txiqlo_nphy(struct brcms_phy *pi, struct nphy_txgains target_gain,
-			bool fullcal, bool mphase)
+static void wlc_phy_txcal_radio_cleanup_nphy(struct brcms_phy *pi)
 {
-	u16 val;
-	u16 tbl_buf[11];
-	u8 cal_cnt;
-	u16 cal_cmd;
-	u8 num_cals, max_cal_cmds;
-	u16 core_no, cal_type;
-	u16 diq_start = 0;
-	u8 phy_bw;
-	u16 max_val;
-	u16 tone_freq;
-	u16 gain_save[2];
-	u16 cal_gain[2];
-	struct nphy_iqcal_params cal_params[2];
-	u32 tbl_len;
-	void *tbl_ptr;
-	bool ladder_updated[2];
-	u8 mphase_cal_lastphase = 0;
-	int bcmerror = 0;
-	bool phyhang_avoid_state = false;
-
-	u16 tbl_tx_iqlo_cal_loft_ladder_20[] = {
-		0x0300, 0x0500, 0x0700, 0x0900, 0x0d00, 0x1100, 0x1900, 0x1901,
-		0x1902,
-		0x1903, 0x1904, 0x1905, 0x1906, 0x1907, 0x2407, 0x3207, 0x4607,
-		0x6407
-	};
-
-	u16 tbl_tx_iqlo_cal_iqimb_ladder_20[] = {
-		0x0200, 0x0300, 0x0600, 0x0900, 0x0d00, 0x1100, 0x1900, 0x2400,
-		0x3200,
-		0x4600, 0x6400, 0x6401, 0x6402, 0x6403, 0x6404, 0x6405, 0x6406,
-		0x6407
-	};
-
-	u16 tbl_tx_iqlo_cal_loft_ladder_40[] = {
-		0x0200, 0x0300, 0x0400, 0x0700, 0x0900, 0x0c00, 0x1200, 0x1201,
-		0x1202,
-		0x1203, 0x1204, 0x1205, 0x1206, 0x1207, 0x1907, 0x2307, 0x3207,
-		0x4707
-	};
-
-	u16 tbl_tx_iqlo_cal_iqimb_ladder_40[] = {
-		0x0100, 0x0200, 0x0400, 0x0700, 0x0900, 0x0c00, 0x1200, 0x1900,
-		0x2300,
-		0x3200, 0x4700, 0x4701, 0x4702, 0x4703, 0x4704, 0x4705, 0x4706,
-		0x4707
-	};
-
-	u16 tbl_tx_iqlo_cal_startcoefs[] = {
-		0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
-		0x0000
-	};
-
-	u16 tbl_tx_iqlo_cal_cmds_fullcal[] = {
-		0x8123, 0x8264, 0x8086, 0x8245, 0x8056,
-		0x9123, 0x9264, 0x9086, 0x9245, 0x9056
-	};
-
-	u16 tbl_tx_iqlo_cal_cmds_recal[] = {
-		0x8101, 0x8253, 0x8053, 0x8234, 0x8034,
-		0x9101, 0x9253, 0x9053, 0x9234, 0x9034
-	};
-
-	u16 tbl_tx_iqlo_cal_startcoefs_nphyrev3[] = {
-		0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
-		0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
-		0x0000
-	};
-
-	u16 tbl_tx_iqlo_cal_cmds_fullcal_nphyrev3[] = {
-		0x8434, 0x8334, 0x8084, 0x8267, 0x8056, 0x8234,
-		0x9434, 0x9334, 0x9084, 0x9267, 0x9056, 0x9234
-	};
+	u16 jtag_core, core;
 
-	u16 tbl_tx_iqlo_cal_cmds_recal_nphyrev3[] = {
-		0x8423, 0x8323, 0x8073, 0x8256, 0x8045, 0x8223,
-		0x9423, 0x9323, 0x9073, 0x9256, 0x9045, 0x9223
-	};
+	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+		for (core = 0; core <= 1; core++) {
 
-	wlc_phy_stay_in_carriersearch_nphy(pi, true);
+			WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
+					 TX_SSI_MASTER,
+					 pi->
+					 tx_rx_cal_radio_saveregs[(core * 11) +
+								  0]);
 
-	if (NREV_GE(pi->pubpi.phy_rev, 4)) {
-		phyhang_avoid_state = pi->phyhang_avoid;
-		pi->phyhang_avoid = false;
-	}
+			WRITE_RADIO_REG3(pi, RADIO_2057, TX, core, IQCAL_VCM_HG,
+					 pi->
+					 tx_rx_cal_radio_saveregs[(core * 11) +
+								  1]);
 
-	if (CHSPEC_IS40(pi->radio_chanspec))
-		phy_bw = 40;
-	else
-		phy_bw = 20;
+			WRITE_RADIO_REG3(pi, RADIO_2057, TX, core, IQCAL_IDAC,
+					 pi->
+					 tx_rx_cal_radio_saveregs[(core * 11) +
+								  2]);
 
-	wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x110, 16, gain_save);
+			WRITE_RADIO_REG3(pi, RADIO_2057, TX, core, TSSI_VCM,
+					 pi->
+					 tx_rx_cal_radio_saveregs[(core * 11) +
+								  3]);
 
-	for (core_no = 0; core_no <= 1; core_no++) {
-		wlc_phy_iqcal_gainparams_nphy(pi, core_no, target_gain,
-					      &cal_params[core_no]);
-		cal_gain[core_no] = cal_params[core_no].cal_gain;
-	}
+			WRITE_RADIO_REG3(pi, RADIO_2057, TX, core, TX_SSI_MUX,
+					 pi->
+					 tx_rx_cal_radio_saveregs[(core * 11) +
+								  5]);
 
-	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x110, 16, cal_gain);
+			if (pi->pubpi.radiorev != 5)
+				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
+						 TSSIA,
+						 pi->tx_rx_cal_radio_saveregs
+							     [(core * 11) + 6]);
 
-	wlc_phy_txcal_radio_setup_nphy(pi);
+			WRITE_RADIO_REG3(pi, RADIO_2057, TX, core, TSSIG,
+					 pi->
+					 tx_rx_cal_radio_saveregs[(core * 11) +
+								  7]);
 
-	wlc_phy_txcal_physetup_nphy(pi);
+			WRITE_RADIO_REG3(pi, RADIO_2057, TX, core, TSSI_MISC1,
+					 pi->
+					 tx_rx_cal_radio_saveregs[(core * 11) +
+								  8]);
+		}
+	} else if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+		for (core = 0; core <= 1; core++) {
+			jtag_core = (core == PHY_CORE_0) ?
+				     RADIO_2056_TX0 : RADIO_2056_TX1;
 
-	ladder_updated[0] = ladder_updated[1] = false;
-	if (!(NREV_GE(pi->pubpi.phy_rev, 6) ||
-	      (NREV_IS(pi->pubpi.phy_rev, 5) && PHY_IPA(pi)
-	       && (CHSPEC_IS2G(pi->radio_chanspec))))) {
+			write_radio_reg(pi,
+					RADIO_2056_TX_TX_SSI_MASTER | jtag_core,
+					pi->
+					tx_rx_cal_radio_saveregs[(core * 11) +
+								 0]);
 
-		if (phy_bw == 40) {
-			tbl_ptr = tbl_tx_iqlo_cal_loft_ladder_40;
-			tbl_len = ARRAY_SIZE(tbl_tx_iqlo_cal_loft_ladder_40);
-		} else {
-			tbl_ptr = tbl_tx_iqlo_cal_loft_ladder_20;
-			tbl_len = ARRAY_SIZE(tbl_tx_iqlo_cal_loft_ladder_20);
-		}
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, tbl_len, 0,
-					 16, tbl_ptr);
+			write_radio_reg(pi,
+					RADIO_2056_TX_IQCAL_VCM_HG | jtag_core,
+					pi->
+					tx_rx_cal_radio_saveregs[(core * 11) +
+								 1]);
 
-		if (phy_bw == 40) {
-			tbl_ptr = tbl_tx_iqlo_cal_iqimb_ladder_40;
-			tbl_len = ARRAY_SIZE(tbl_tx_iqlo_cal_iqimb_ladder_40);
-		} else {
-			tbl_ptr = tbl_tx_iqlo_cal_iqimb_ladder_20;
-			tbl_len = ARRAY_SIZE(tbl_tx_iqlo_cal_iqimb_ladder_20);
-		}
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, tbl_len, 32,
-					 16, tbl_ptr);
-	}
+			write_radio_reg(pi,
+					RADIO_2056_TX_IQCAL_IDAC | jtag_core,
+					pi->
+					tx_rx_cal_radio_saveregs[(core * 11) +
+								 2]);
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7))
-		write_phy_reg(pi, 0xc2, 0x8ad9);
-	else
-		write_phy_reg(pi, 0xc2, 0x8aa9);
+			write_radio_reg(pi, RADIO_2056_TX_TSSI_VCM | jtag_core,
+					pi->
+					tx_rx_cal_radio_saveregs[(core * 11) +
+								 3]);
 
-	max_val = 250;
-	tone_freq = (phy_bw == 20) ? 2500 : 5000;
+			write_radio_reg(pi,
+					RADIO_2056_TX_TX_AMP_DET | jtag_core,
+					pi->
+					tx_rx_cal_radio_saveregs[(core * 11) +
+								 4]);
 
-	if (pi->mphase_cal_phase_id > MPHASE_CAL_STATE_TXPHASE0) {
-		wlc_phy_runsamples_nphy(pi, phy_bw * 8, 0xffff, 0, 1, 0, false);
-		bcmerror = 0;
-	} else {
-		bcmerror =
-			wlc_phy_tx_tone_nphy(pi, tone_freq, max_val, 1, 0,
-					     false);
-	}
+			write_radio_reg(pi,
+					RADIO_2056_TX_TX_SSI_MUX | jtag_core,
+					pi->
+					tx_rx_cal_radio_saveregs[(core * 11) +
+								 5]);
 
-	if (bcmerror == 0) {
+			write_radio_reg(pi, RADIO_2056_TX_TSSIA | jtag_core,
+					pi->
+					tx_rx_cal_radio_saveregs[(core * 11) +
+								 6]);
 
-		if (pi->mphase_cal_phase_id > MPHASE_CAL_STATE_TXPHASE0) {
-			tbl_ptr = pi->mphase_txcal_bestcoeffs;
-			tbl_len = ARRAY_SIZE(pi->mphase_txcal_bestcoeffs);
-			if (NREV_LT(pi->pubpi.phy_rev, 3))
-				tbl_len -= 2;
-		} else {
-			if ((!fullcal) && (pi->nphy_txiqlocal_coeffsvalid)) {
+			write_radio_reg(pi, RADIO_2056_TX_TSSIG | jtag_core,
+					pi->
+					tx_rx_cal_radio_saveregs[(core * 11) +
+								 7]);
 
-				tbl_ptr = pi->nphy_txiqlocal_bestc;
-				tbl_len = ARRAY_SIZE(pi->nphy_txiqlocal_bestc);
-				if (NREV_LT(pi->pubpi.phy_rev, 3))
-					tbl_len -= 2;
-			} else {
+			write_radio_reg(pi,
+					RADIO_2056_TX_TSSI_MISC1 | jtag_core,
+					pi->
+					tx_rx_cal_radio_saveregs[(core * 11) +
+								 8]);
 
-				fullcal = true;
+			write_radio_reg(pi,
+					RADIO_2056_TX_TSSI_MISC2 | jtag_core,
+					pi->
+					tx_rx_cal_radio_saveregs[(core * 11) +
+								 9]);
 
-				if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-					tbl_ptr =
-					    tbl_tx_iqlo_cal_startcoefs_nphyrev3;
-					tbl_len = ARRAY_SIZE(
-					   tbl_tx_iqlo_cal_startcoefs_nphyrev3);
-				} else {
-					tbl_ptr = tbl_tx_iqlo_cal_startcoefs;
-					tbl_len = ARRAY_SIZE(
-						    tbl_tx_iqlo_cal_startcoefs);
-				}
-			}
+			write_radio_reg(pi,
+					RADIO_2056_TX_TSSI_MISC3 | jtag_core,
+					pi->
+					tx_rx_cal_radio_saveregs[(core * 11) +
+								 10]);
 		}
-		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, tbl_len, 64,
-					 16, tbl_ptr);
+	} else {
 
-		if (fullcal) {
-			max_cal_cmds = (NREV_GE(pi->pubpi.phy_rev, 3)) ?
-				       ARRAY_SIZE(
-				tbl_tx_iqlo_cal_cmds_fullcal_nphyrev3) :
-				       ARRAY_SIZE(tbl_tx_iqlo_cal_cmds_fullcal);
-		} else {
-			max_cal_cmds = (NREV_GE(pi->pubpi.phy_rev, 3)) ?
-				       ARRAY_SIZE(
-				tbl_tx_iqlo_cal_cmds_recal_nphyrev3) :
-				       ARRAY_SIZE(tbl_tx_iqlo_cal_cmds_recal);
-		}
+		write_radio_reg(pi, RADIO_2055_CORE1_TXRF_IQCAL1,
+				pi->tx_rx_cal_radio_saveregs[0]);
+		write_radio_reg(pi, RADIO_2055_CORE1_TXRF_IQCAL2,
+				pi->tx_rx_cal_radio_saveregs[1]);
+		write_radio_reg(pi, RADIO_2055_CORE2_TXRF_IQCAL1,
+				pi->tx_rx_cal_radio_saveregs[2]);
+		write_radio_reg(pi, RADIO_2055_CORE2_TXRF_IQCAL2,
+				pi->tx_rx_cal_radio_saveregs[3]);
+		write_radio_reg(pi, RADIO_2055_PWRDET_RXTX_CORE1,
+				pi->tx_rx_cal_radio_saveregs[4]);
+		write_radio_reg(pi, RADIO_2055_PWRDET_RXTX_CORE2,
+				pi->tx_rx_cal_radio_saveregs[5]);
+	}
+}
 
-		if (mphase) {
-			cal_cnt = pi->mphase_txcal_cmdidx;
-			if ((cal_cnt + pi->mphase_txcal_numcmds) < max_cal_cmds)
-				num_cals = cal_cnt + pi->mphase_txcal_numcmds;
-			else
-				num_cals = max_cal_cmds;
-		} else {
-			cal_cnt = 0;
-			num_cals = max_cal_cmds;
-		}
+static void wlc_phy_txcal_physetup_nphy(struct brcms_phy *pi)
+{
+	u16 val, mask;
 
-		for (; cal_cnt < num_cals; cal_cnt++) {
+	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+		pi->tx_rx_cal_phy_saveregs[0] = read_phy_reg(pi, 0xa6);
+		pi->tx_rx_cal_phy_saveregs[1] = read_phy_reg(pi, 0xa7);
 
-			if (fullcal) {
-				cal_cmd = (NREV_GE(pi->pubpi.phy_rev, 3)) ?
-					  tbl_tx_iqlo_cal_cmds_fullcal_nphyrev3
-					  [cal_cnt] :
-					  tbl_tx_iqlo_cal_cmds_fullcal[cal_cnt];
-			} else {
-				cal_cmd = (NREV_GE(pi->pubpi.phy_rev, 3)) ?
-					  tbl_tx_iqlo_cal_cmds_recal_nphyrev3[
-					cal_cnt]
-					  : tbl_tx_iqlo_cal_cmds_recal[cal_cnt];
-			}
+		mask = ((0x3 << 8) | (0x3 << 10));
+		val = (0x2 << 8);
+		val |= (0x2 << 10);
+		mod_phy_reg(pi, 0xa6, mask, val);
+		mod_phy_reg(pi, 0xa7, mask, val);
 
-			core_no = ((cal_cmd & 0x3000) >> 12);
-			cal_type = ((cal_cmd & 0x0F00) >> 8);
+		val = read_phy_reg(pi, 0x8f);
+		pi->tx_rx_cal_phy_saveregs[2] = val;
+		val |= ((0x1 << 9) | (0x1 << 10));
+		write_phy_reg(pi, 0x8f, val);
 
-			if (NREV_GE(pi->pubpi.phy_rev, 6) ||
-			    (NREV_IS(pi->pubpi.phy_rev, 5) &&
-			     PHY_IPA(pi)
-			     && (CHSPEC_IS2G(pi->radio_chanspec)))) {
-				if (!ladder_updated[core_no]) {
-					wlc_phy_update_txcal_ladder_nphy(
-						pi,
-						core_no);
-					ladder_updated[core_no] = true;
-				}
-			}
+		val = read_phy_reg(pi, 0xa5);
+		pi->tx_rx_cal_phy_saveregs[3] = val;
+		val |= ((0x1 << 9) | (0x1 << 10));
+		write_phy_reg(pi, 0xa5, val);
 
-			val =
-				(cal_params[core_no].
-				 ncorr[cal_type] << 8) | NPHY_N_GCTL;
-			write_phy_reg(pi, 0xc1, val);
+		pi->tx_rx_cal_phy_saveregs[4] = read_phy_reg(pi, 0x01);
+		mod_phy_reg(pi, 0x01, (0x1 << 15), 0);
 
-			if ((cal_type == 1) || (cal_type == 3)
-			    || (cal_type == 4)) {
+		wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 3, 16,
+					&val);
+		pi->tx_rx_cal_phy_saveregs[5] = val;
+		val = 0;
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 3, 16,
+					 &val);
 
-				wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_IQLOCAL,
-							1, 69 + core_no, 16,
-							tbl_buf);
+		wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 19, 16,
+					&val);
+		pi->tx_rx_cal_phy_saveregs[6] = val;
+		val = 0;
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 19, 16,
+					 &val);
 
-				diq_start = tbl_buf[0];
+		pi->tx_rx_cal_phy_saveregs[7] = read_phy_reg(pi, 0x91);
+		pi->tx_rx_cal_phy_saveregs[8] = read_phy_reg(pi, 0x92);
 
-				tbl_buf[0] = 0;
-				wlc_phy_table_write_nphy(pi,
-							 NPHY_TBL_ID_IQLOCAL, 1,
-							 69 + core_no, 16,
-							 tbl_buf);
-			}
+		if (!(pi->use_int_tx_iqlo_cal_nphy))
+			wlc_phy_rfctrlintc_override_nphy(
+				pi,
+				NPHY_RfctrlIntc_override_PA,
+				1,
+				RADIO_MIMO_CORESEL_CORE1
+				|
+				RADIO_MIMO_CORESEL_CORE2);
+		else
+			wlc_phy_rfctrlintc_override_nphy(
+				pi,
+				NPHY_RfctrlIntc_override_PA,
+				0,
+				RADIO_MIMO_CORESEL_CORE1
+				|
+				RADIO_MIMO_CORESEL_CORE2);
 
-			write_phy_reg(pi, 0xc0, cal_cmd);
+		wlc_phy_rfctrlintc_override_nphy(pi,
+						 NPHY_RfctrlIntc_override_TRSW,
+						 0x2, RADIO_MIMO_CORESEL_CORE1);
+		wlc_phy_rfctrlintc_override_nphy(pi,
+						 NPHY_RfctrlIntc_override_TRSW,
+						 0x8, RADIO_MIMO_CORESEL_CORE2);
 
-			SPINWAIT(((read_phy_reg(pi, 0xc0) & 0xc000) != 0),
-				 20000);
-			if (WARN(read_phy_reg(pi, 0xc0) & 0xc000,
-				 "HW error: txiq calib"))
-				return -EIO;
+		pi->tx_rx_cal_phy_saveregs[9] = read_phy_reg(pi, 0x297);
+		pi->tx_rx_cal_phy_saveregs[10] = read_phy_reg(pi, 0x29b);
+		mod_phy_reg(pi, (0 == PHY_CORE_0) ? 0x297 :
+			    0x29b, (0x1 << 0), (0) << 0);
 
-			wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_IQLOCAL,
-						tbl_len, 96, 16, tbl_buf);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL,
-						 tbl_len, 64, 16, tbl_buf);
+		mod_phy_reg(pi, (1 == PHY_CORE_0) ? 0x297 :
+			    0x29b, (0x1 << 0), (0) << 0);
 
-			if ((cal_type == 1) || (cal_type == 3)
-			    || (cal_type == 4)) {
+		if (NREV_IS(pi->pubpi.phy_rev, 7)
+		    || NREV_GE(pi->pubpi.phy_rev, 8))
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 7),
+				wlc_phy_read_lpf_bw_ctl_nphy
+					(pi,
+					0), 0, 0,
+				NPHY_REV7_RFCTRLOVERRIDE_ID1);
 
-				tbl_buf[0] = diq_start;
+		if (pi->use_int_tx_iqlo_cal_nphy
+		    && !(pi->internal_tx_iqlo_cal_tapoff_intpa_nphy)) {
 
-			}
+			if (NREV_IS(pi->pubpi.phy_rev, 7)) {
 
-		}
+				mod_radio_reg(pi, RADIO_2057_OVR_REG0, 1 << 4,
+					      1 << 4);
 
-		if (mphase) {
-			pi->mphase_txcal_cmdidx = num_cals;
-			if (pi->mphase_txcal_cmdidx >= max_cal_cmds)
-				pi->mphase_txcal_cmdidx = 0;
+				if (CHSPEC_IS2G(pi->radio_chanspec)) {
+					mod_radio_reg(
+						pi,
+						RADIO_2057_PAD2G_TUNE_PUS_CORE0,
+						1, 0);
+					mod_radio_reg(
+						pi,
+						RADIO_2057_PAD2G_TUNE_PUS_CORE1,
+						1, 0);
+				} else {
+					mod_radio_reg(
+					     pi,
+					     RADIO_2057_IPA5G_CASCOFFV_PU_CORE0,
+					     1, 0);
+					mod_radio_reg(
+					     pi,
+					     RADIO_2057_IPA5G_CASCOFFV_PU_CORE1,
+					     1, 0);
+				}
+			} else if (NREV_GE(pi->pubpi.phy_rev, 8)) {
+				wlc_phy_rfctrl_override_nphy_rev7(
+					pi,
+					(0x1 << 3), 0,
+					0x3, 0,
+					NPHY_REV7_RFCTRLOVERRIDE_ID0);
+			}
 		}
+	} else {
+		pi->tx_rx_cal_phy_saveregs[0] = read_phy_reg(pi, 0xa6);
+		pi->tx_rx_cal_phy_saveregs[1] = read_phy_reg(pi, 0xa7);
 
-		mphase_cal_lastphase =
-			(NREV_LE(pi->pubpi.phy_rev, 2)) ?
-			MPHASE_CAL_STATE_TXPHASE4 : MPHASE_CAL_STATE_TXPHASE5;
-
-		if (!mphase
-		    || (pi->mphase_cal_phase_id == mphase_cal_lastphase)) {
+		mask = ((0x3 << 12) | (0x3 << 14));
+		val = (0x2 << 12);
+		val |= (0x2 << 14);
+		mod_phy_reg(pi, 0xa6, mask, val);
+		mod_phy_reg(pi, 0xa7, mask, val);
 
-			wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_IQLOCAL, 4, 96,
-						16, tbl_buf);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, 4, 80,
-						 16, tbl_buf);
+		val = read_phy_reg(pi, 0xa5);
+		pi->tx_rx_cal_phy_saveregs[2] = val;
+		val |= ((0x1 << 12) | (0x1 << 13));
+		write_phy_reg(pi, 0xa5, val);
 
-			if (NREV_LT(pi->pubpi.phy_rev, 2)) {
+		wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 2, 16,
+					&val);
+		pi->tx_rx_cal_phy_saveregs[3] = val;
+		val |= 0x2000;
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 2, 16,
+					 &val);
 
-				tbl_buf[0] = 0;
-				tbl_buf[1] = 0;
-				tbl_buf[2] = 0;
-				tbl_buf[3] = 0;
+		wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 18, 16,
+					&val);
+		pi->tx_rx_cal_phy_saveregs[4] = val;
+		val |= 0x2000;
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 18, 16,
+					 &val);
 
-			}
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, 4, 88,
-						 16, tbl_buf);
+		pi->tx_rx_cal_phy_saveregs[5] = read_phy_reg(pi, 0x91);
+		pi->tx_rx_cal_phy_saveregs[6] = read_phy_reg(pi, 0x92);
+		val = CHSPEC_IS5G(pi->radio_chanspec) ? 0x180 : 0x120;
+		write_phy_reg(pi, 0x91, val);
+		write_phy_reg(pi, 0x92, val);
+	}
+}
 
-			wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_IQLOCAL, 2, 101,
-						16, tbl_buf);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, 2, 85,
-						 16, tbl_buf);
+static void wlc_phy_txcal_phycleanup_nphy(struct brcms_phy *pi)
+{
+	u16 mask;
 
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, 2, 93,
-						 16, tbl_buf);
+	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+		write_phy_reg(pi, 0xa6, pi->tx_rx_cal_phy_saveregs[0]);
+		write_phy_reg(pi, 0xa7, pi->tx_rx_cal_phy_saveregs[1]);
+		write_phy_reg(pi, 0x8f, pi->tx_rx_cal_phy_saveregs[2]);
+		write_phy_reg(pi, 0xa5, pi->tx_rx_cal_phy_saveregs[3]);
+		write_phy_reg(pi, 0x01, pi->tx_rx_cal_phy_saveregs[4]);
 
-			tbl_len = ARRAY_SIZE(pi->nphy_txiqlocal_bestc);
-			if (NREV_LT(pi->pubpi.phy_rev, 3))
-				tbl_len -= 2;
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 3, 16,
+					 &pi->tx_rx_cal_phy_saveregs[5]);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 19, 16,
+					 &pi->tx_rx_cal_phy_saveregs[6]);
 
-			wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_IQLOCAL,
-						tbl_len, 96, 16,
-						pi->nphy_txiqlocal_bestc);
+		write_phy_reg(pi, 0x91, pi->tx_rx_cal_phy_saveregs[7]);
+		write_phy_reg(pi, 0x92, pi->tx_rx_cal_phy_saveregs[8]);
 
-			pi->nphy_txiqlocal_coeffsvalid = true;
-			pi->nphy_txiqlocal_chanspec = pi->radio_chanspec;
-		} else {
-			tbl_len = ARRAY_SIZE(pi->mphase_txcal_bestcoeffs);
-			if (NREV_LT(pi->pubpi.phy_rev, 3))
-				tbl_len -= 2;
+		write_phy_reg(pi, 0x297, pi->tx_rx_cal_phy_saveregs[9]);
+		write_phy_reg(pi, 0x29b, pi->tx_rx_cal_phy_saveregs[10]);
 
-			wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_IQLOCAL,
-						tbl_len, 96, 16,
-						pi->mphase_txcal_bestcoeffs);
-		}
+		if (NREV_IS(pi->pubpi.phy_rev, 7)
+		    || NREV_GE(pi->pubpi.phy_rev, 8))
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 7), 0, 0,
+				1,
+				NPHY_REV7_RFCTRLOVERRIDE_ID1);
 
-		wlc_phy_stopplayback_nphy(pi);
+		wlc_phy_resetcca_nphy(pi);
 
-		write_phy_reg(pi, 0xc2, 0x0000);
+		if (pi->use_int_tx_iqlo_cal_nphy
+		    && !(pi->internal_tx_iqlo_cal_tapoff_intpa_nphy)) {
 
-	}
+			if (NREV_IS(pi->pubpi.phy_rev, 7)) {
+				if (CHSPEC_IS2G(pi->radio_chanspec)) {
+					mod_radio_reg(
+						pi,
+						RADIO_2057_PAD2G_TUNE_PUS_CORE0,
+						1, 1);
+					mod_radio_reg(
+						pi,
+						RADIO_2057_PAD2G_TUNE_PUS_CORE1,
+						1, 1);
+				} else {
+					mod_radio_reg(
+					     pi,
+					     RADIO_2057_IPA5G_CASCOFFV_PU_CORE0,
+					     1, 1);
+					mod_radio_reg(
+					     pi,
+					     RADIO_2057_IPA5G_CASCOFFV_PU_CORE1,
+					     1, 1);
+				}
 
-	wlc_phy_txcal_phycleanup_nphy(pi);
+				mod_radio_reg(pi, RADIO_2057_OVR_REG0, 1 << 4,
+					      0);
+			} else if (NREV_GE(pi->pubpi.phy_rev, 8)) {
+				wlc_phy_rfctrl_override_nphy_rev7(
+					pi,
+					(0x1 << 3), 0,
+					0x3, 1,
+					NPHY_REV7_RFCTRLOVERRIDE_ID0);
+			}
+		}
+	} else {
+		mask = ((0x3 << 12) | (0x3 << 14));
+		mod_phy_reg(pi, 0xa6, mask, pi->tx_rx_cal_phy_saveregs[0]);
+		mod_phy_reg(pi, 0xa7, mask, pi->tx_rx_cal_phy_saveregs[1]);
+		write_phy_reg(pi, 0xa5, pi->tx_rx_cal_phy_saveregs[2]);
 
-	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x110, 16,
-				 gain_save);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 2, 16,
+					 &pi->tx_rx_cal_phy_saveregs[3]);
 
-	wlc_phy_txcal_radio_cleanup_nphy(pi);
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 18, 16,
+					 &pi->tx_rx_cal_phy_saveregs[4]);
 
-	if (NREV_LT(pi->pubpi.phy_rev, 2)) {
-		if (!mphase
-		    || (pi->mphase_cal_phase_id == mphase_cal_lastphase))
-			wlc_phy_tx_iq_war_nphy(pi);
+		write_phy_reg(pi, 0x91, pi->tx_rx_cal_phy_saveregs[5]);
+		write_phy_reg(pi, 0x92, pi->tx_rx_cal_phy_saveregs[6]);
 	}
+}
 
-	if (NREV_GE(pi->pubpi.phy_rev, 4))
-		pi->phyhang_avoid = phyhang_avoid_state;
+void
+wlc_phy_est_tonepwr_nphy(struct brcms_phy *pi, s32 *qdBm_pwrbuf, u8 num_samps)
+{
+	u16 tssi_reg;
+	s32 temp, pwrindex[2];
+	s32 idle_tssi[2];
+	s32 rssi_buf[4];
+	s32 tssival[2];
+	u8 tssi_type;
 
-	wlc_phy_stay_in_carriersearch_nphy(pi, false);
+	tssi_reg = read_phy_reg(pi, 0x1e9);
 
-	return bcmerror;
-}
+	temp = (s32) (tssi_reg & 0x3f);
+	idle_tssi[0] = (temp <= 31) ? temp : (temp - 64);
 
-static void wlc_phy_reapply_txcal_coeffs_nphy(struct brcms_phy *pi)
-{
-	u16 tbl_buf[7];
+	temp = (s32) ((tssi_reg >> 8) & 0x3f);
+	idle_tssi[1] = (temp <= 31) ? temp : (temp - 64);
 
-	if ((pi->nphy_txiqlocal_chanspec == pi->radio_chanspec) &&
-	    (pi->nphy_txiqlocal_coeffsvalid)) {
-		wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_IQLOCAL,
-					ARRAY_SIZE(tbl_buf), 80, 16, tbl_buf);
+	tssi_type =
+		CHSPEC_IS5G(pi->radio_chanspec) ?
+		(u8)NPHY_RSSI_SEL_TSSI_5G : (u8)NPHY_RSSI_SEL_TSSI_2G;
 
-		if ((pi->nphy_txiqlocal_bestc[0] != tbl_buf[0]) ||
-		    (pi->nphy_txiqlocal_bestc[1] != tbl_buf[1]) ||
-		    (pi->nphy_txiqlocal_bestc[2] != tbl_buf[2]) ||
-		    (pi->nphy_txiqlocal_bestc[3] != tbl_buf[3])) {
+	wlc_phy_poll_rssi_nphy(pi, tssi_type, rssi_buf, num_samps);
 
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, 4, 80,
-						 16, pi->nphy_txiqlocal_bestc);
+	tssival[0] = rssi_buf[0] / ((s32) num_samps);
+	tssival[1] = rssi_buf[2] / ((s32) num_samps);
 
-			tbl_buf[0] = 0;
-			tbl_buf[1] = 0;
-			tbl_buf[2] = 0;
-			tbl_buf[3] = 0;
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, 4, 88,
-						 16, tbl_buf);
+	pwrindex[0] = idle_tssi[0] - tssival[0] + 64;
+	pwrindex[1] = idle_tssi[1] - tssival[1] + 64;
+
+	if (pwrindex[0] < 0)
+		pwrindex[0] = 0;
+	else if (pwrindex[0] > 63)
+		pwrindex[0] = 63;
 
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, 2, 85,
-						 16,
-						 &pi->nphy_txiqlocal_bestc[5]);
+	if (pwrindex[1] < 0)
+		pwrindex[1] = 0;
+	else if (pwrindex[1] > 63)
+		pwrindex[1] = 63;
 
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, 2, 93,
-						 16,
-						 &pi->nphy_txiqlocal_bestc[5]);
-		}
-	}
+	wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_CORE1TXPWRCTL, 1,
+				(u32) pwrindex[0], 32, &qdBm_pwrbuf[0]);
+	wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_CORE2TXPWRCTL, 1,
+				(u32) pwrindex[1], 32, &qdBm_pwrbuf[1]);
 }
 
-static void wlc_phy_tx_iq_war_nphy(struct brcms_phy *pi)
+static void wlc_phy_update_txcal_ladder_nphy(struct brcms_phy *pi, u16 core)
 {
-	struct nphy_iq_comp tx_comp;
-
-	wlc_phy_table_read_nphy(pi, 15, 4, 0x50, 16, &tx_comp);
+	int index;
+	u32 bbmult_scale;
+	u16 bbmult;
+	u16 tblentry;
 
-	wlapi_bmac_write_shm(pi->sh->physhim, M_20IN40_IQ, tx_comp.a0);
-	wlapi_bmac_write_shm(pi->sh->physhim, M_20IN40_IQ + 2, tx_comp.b0);
-	wlapi_bmac_write_shm(pi->sh->physhim, M_20IN40_IQ + 4, tx_comp.a1);
-	wlapi_bmac_write_shm(pi->sh->physhim, M_20IN40_IQ + 6, tx_comp.b1);
-}
+	struct nphy_txiqcal_ladder ladder_lo[] = {
+		{3, 0}, {4, 0}, {6, 0}, {9, 0}, {13, 0}, {18, 0},
+		{25, 0}, {25, 1}, {25, 2}, {25, 3}, {25, 4}, {25, 5},
+		{25, 6}, {25, 7}, {35, 7}, {50, 7}, {71, 7}, {100, 7}
+	};
 
-void
-wlc_phy_rx_iq_coeffs_nphy(struct brcms_phy *pi, u8 write,
-			  struct nphy_iq_comp *pcomp)
-{
-	if (write) {
-		write_phy_reg(pi, 0x9a, pcomp->a0);
-		write_phy_reg(pi, 0x9b, pcomp->b0);
-		write_phy_reg(pi, 0x9c, pcomp->a1);
-		write_phy_reg(pi, 0x9d, pcomp->b1);
-	} else {
-		pcomp->a0 = read_phy_reg(pi, 0x9a);
-		pcomp->b0 = read_phy_reg(pi, 0x9b);
-		pcomp->a1 = read_phy_reg(pi, 0x9c);
-		pcomp->b1 = read_phy_reg(pi, 0x9d);
-	}
-}
+	struct nphy_txiqcal_ladder ladder_iq[] = {
+		{3, 0}, {4, 0}, {6, 0}, {9, 0}, {13, 0}, {18, 0},
+		{25, 0}, {35, 0}, {50, 0}, {71, 0}, {100, 0}, {100, 1},
+		{100, 2}, {100, 3}, {100, 4}, {100, 5}, {100, 6}, {100, 7}
+	};
 
-void
-wlc_phy_rx_iq_est_nphy(struct brcms_phy *pi, struct phy_iq_est *est,
-		       u16 num_samps, u8 wait_time, u8 wait_for_crs)
-{
-	u8 core;
+	bbmult = (core == PHY_CORE_0) ?
+		 ((pi->nphy_txcal_bbmult >> 8) & 0xff) :
+		 (pi->nphy_txcal_bbmult & 0xff);
 
-	write_phy_reg(pi, 0x12b, num_samps);
-	mod_phy_reg(pi, 0x12a, (0xff << 0), (wait_time << 0));
-	mod_phy_reg(pi, 0x129, NPHY_IqestCmd_iqMode,
-		    (wait_for_crs) ? NPHY_IqestCmd_iqMode : 0);
+	for (index = 0; index < 18; index++) {
+		bbmult_scale = ladder_lo[index].percent * bbmult;
+		bbmult_scale /= 100;
 
-	mod_phy_reg(pi, 0x129, NPHY_IqestCmd_iqstart, NPHY_IqestCmd_iqstart);
+		tblentry =
+			((bbmult_scale & 0xff) << 8) | ladder_lo[index].g_env;
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, 1, index, 16,
+					 &tblentry);
 
-	SPINWAIT(((read_phy_reg(pi, 0x129) & NPHY_IqestCmd_iqstart) != 0),
-		 10000);
-	if (WARN(read_phy_reg(pi, 0x129) & NPHY_IqestCmd_iqstart,
-		 "HW error: rxiq est"))
-		return;
+		bbmult_scale = ladder_iq[index].percent * bbmult;
+		bbmult_scale /= 100;
 
-	if ((read_phy_reg(pi, 0x129) & NPHY_IqestCmd_iqstart) == 0) {
-		for (core = 0; core < pi->pubpi.phy_corenum; core++) {
-			est[core].i_pwr =
-				(read_phy_reg(pi,
-					      NPHY_IqestipwrAccHi(core)) << 16)
-				| read_phy_reg(pi, NPHY_IqestipwrAccLo(core));
-			est[core].q_pwr =
-				(read_phy_reg(pi,
-					      NPHY_IqestqpwrAccHi(core)) << 16)
-				| read_phy_reg(pi, NPHY_IqestqpwrAccLo(core));
-			est[core].iq_prod =
-				(read_phy_reg(pi,
-					      NPHY_IqestIqAccHi(core)) << 16) |
-				read_phy_reg(pi, NPHY_IqestIqAccLo(core));
-		}
+		tblentry =
+			((bbmult_scale & 0xff) << 8) | ladder_iq[index].g_env;
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, 1, index + 32,
+					 16, &tblentry);
 	}
 }
 
-#define CAL_RETRY_CNT 2
-static void wlc_phy_calc_rx_iq_comp_nphy(struct brcms_phy *pi, u8 core_mask)
+static u8 wlc_phy_txpwr_idx_cur_get_nphy(struct brcms_phy *pi, u8 core)
 {
-	u8 curr_core;
-	struct phy_iq_est est[PHY_CORE_MAX];
-	struct nphy_iq_comp old_comp, new_comp;
-	s32 iq = 0;
-	u32 ii = 0, qq = 0;
-	s16 iq_nbits, qq_nbits, brsh, arsh;
-	s32 a, b, temp;
-	int bcmerror = 0;
-	uint cal_retry = 0;
-
-	if (core_mask == 0x0)
-		return;
-
-	wlc_phy_rx_iq_coeffs_nphy(pi, 0, &old_comp);
-	new_comp.a0 = new_comp.b0 = new_comp.a1 = new_comp.b1 = 0x0;
-	wlc_phy_rx_iq_coeffs_nphy(pi, 1, &new_comp);
+	u16 tmp;
+	tmp = read_phy_reg(pi, ((core == PHY_CORE_0) ? 0x1ed : 0x1ee));
 
-cal_try:
-	wlc_phy_rx_iq_est_nphy(pi, est, 0x4000, 32, 0);
+	tmp = (tmp & (0x7f << 8)) >> 8;
+	return (u8) tmp;
+}
 
-	new_comp = old_comp;
+static void
+wlc_phy_txpwr_idx_cur_set_nphy(struct brcms_phy *pi, u8 idx0, u8 idx1)
+{
+	mod_phy_reg(pi, 0x1e7, (0x7f << 0), idx0);
 
-	for (curr_core = 0; curr_core < pi->pubpi.phy_corenum; curr_core++) {
+	if (NREV_GT(pi->pubpi.phy_rev, 1))
+		mod_phy_reg(pi, 0x222, (0xff << 0), idx1);
+}
 
-		if ((curr_core == PHY_CORE_0) && (core_mask & 0x1)) {
-			iq = est[curr_core].iq_prod;
-			ii = est[curr_core].i_pwr;
-			qq = est[curr_core].q_pwr;
-		} else if ((curr_core == PHY_CORE_1) && (core_mask & 0x2)) {
-			iq = est[curr_core].iq_prod;
-			ii = est[curr_core].i_pwr;
-			qq = est[curr_core].q_pwr;
-		} else {
-			continue;
-		}
+static u16 wlc_phy_ipa_get_bbmult_nphy(struct brcms_phy *pi)
+{
+	u16 m0m1;
 
-		if ((ii + qq) < NPHY_MIN_RXIQ_PWR) {
-			bcmerror = -EBADE;
-			break;
-		}
+	wlc_phy_table_read_nphy(pi, 15, 1, 87, 16, &m0m1);
 
-		iq_nbits = wlc_phy_nbits(iq);
-		qq_nbits = wlc_phy_nbits(qq);
+	return m0m1;
+}
 
-		arsh = 10 - (30 - iq_nbits);
-		if (arsh >= 0) {
-			a = (-(iq << (30 - iq_nbits)) + (ii >> (1 + arsh)));
-			temp = (s32) (ii >> arsh);
-			if (temp == 0) {
-				bcmerror = -EBADE;
-				break;
-			}
-		} else {
-			a = (-(iq << (30 - iq_nbits)) + (ii << (-1 - arsh)));
-			temp = (s32) (ii << -arsh);
-			if (temp == 0) {
-				bcmerror = -EBADE;
-				break;
-			}
-		}
+static void wlc_phy_ipa_set_bbmult_nphy(struct brcms_phy *pi, u8 m0, u8 m1)
+{
+	u16 m0m1 = (u16) ((m0 << 8) | m1);
 
-		a /= temp;
+	wlc_phy_table_write_nphy(pi, 15, 1, 87, 16, &m0m1);
+	wlc_phy_table_write_nphy(pi, 15, 1, 95, 16, &m0m1);
+}
 
-		brsh = qq_nbits - 31 + 20;
-		if (brsh >= 0) {
-			b = (qq << (31 - qq_nbits));
-			temp = (s32) (ii >> brsh);
-			if (temp == 0) {
-				bcmerror = -EBADE;
-				break;
-			}
-		} else {
-			b = (qq << (31 - qq_nbits));
-			temp = (s32) (ii << -brsh);
-			if (temp == 0) {
-				bcmerror = -EBADE;
-				break;
-			}
-		}
-		b /= temp;
-		b -= a * a;
-		b = (s32) int_sqrt((unsigned long) b);
-		b -= (1 << 10);
+static void
+wlc_phy_papd_cal_setup_nphy(struct brcms_phy *pi,
+			    struct nphy_papd_restore_state *state, u8 core)
+{
+	s32 tone_freq;
+	u8 off_core;
+	u16 mixgain = 0;
 
-		if ((curr_core == PHY_CORE_0) && (core_mask & 0x1)) {
-			if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-				new_comp.a0 = (s16) a & 0x3ff;
-				new_comp.b0 = (s16) b & 0x3ff;
-			} else {
+	off_core = core ^ 0x1;
+	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 
-				new_comp.a0 = (s16) b & 0x3ff;
-				new_comp.b0 = (s16) a & 0x3ff;
-			}
-		}
-		if ((curr_core == PHY_CORE_1) && (core_mask & 0x2)) {
-			if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-				new_comp.a1 = (s16) a & 0x3ff;
-				new_comp.b1 = (s16) b & 0x3ff;
-			} else {
+		if (NREV_IS(pi->pubpi.phy_rev, 7)
+		    || NREV_GE(pi->pubpi.phy_rev, 8))
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 7),
+				wlc_phy_read_lpf_bw_ctl_nphy
+					(pi,
+					0), 0, 0,
+				NPHY_REV7_RFCTRLOVERRIDE_ID1);
 
-				new_comp.a1 = (s16) b & 0x3ff;
-				new_comp.b1 = (s16) a & 0x3ff;
-			}
+		if (CHSPEC_IS2G(pi->radio_chanspec)) {
+			if (pi->pubpi.radiorev == 5)
+				mixgain = (core == 0) ? 0x20 : 0x00;
+			else if ((pi->pubpi.radiorev == 7)
+				 || (pi->pubpi.radiorev == 8))
+				mixgain = 0x00;
+			else if ((pi->pubpi.radiorev <= 4)
+				 || (pi->pubpi.radiorev == 6))
+				mixgain = 0x00;
+		} else {
+			if ((pi->pubpi.radiorev == 4) ||
+			    (pi->pubpi.radiorev == 6))
+				mixgain = 0x50;
+			else if ((pi->pubpi.radiorev == 3)
+				 || (pi->pubpi.radiorev == 7)
+				 || (pi->pubpi.radiorev == 8))
+				mixgain = 0x0;
 		}
-	}
-
-	if (bcmerror != 0) {
-		printk(KERN_DEBUG "%s: Failed, cnt = %d\n", __func__,
-		       cal_retry);
 
-		if (cal_retry < CAL_RETRY_CNT) {
-			cal_retry++;
-			goto cal_try;
-		}
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 11),
+						  mixgain, (1 << core), 0,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID0);
 
-		new_comp = old_comp;
-	}
+		wlc_phy_rfctrl_override_1tomany_nphy(
+			pi,
+			NPHY_REV7_RfctrlOverride_cmd_tx_pu,
+			1, (1 << core), 0);
+		wlc_phy_rfctrl_override_1tomany_nphy(
+			pi,
+			NPHY_REV7_RfctrlOverride_cmd_tx_pu,
+			0, (1 << off_core), 0);
 
-	wlc_phy_rx_iq_coeffs_nphy(pi, 1, &new_comp);
-}
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 3),
+						  0, 0x3, 0,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID0);
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 2), 1,
+						  (1 << core), 0,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 0), 0,
+						  (1 << core), 0,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 1), 1,
+						  (1 << core), 0,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID2);
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 8), 0,
+						  (1 << core), 0,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 9), 1,
+						  (1 << core), 0,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 10), 0,
+						  (1 << core), 0,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 3), 1,
+						  (1 << core), 0,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
 
-static void wlc_phy_rxcal_radio_setup_nphy(struct brcms_phy *pi, u8 rx_core)
-{
-	u16 offtune_val;
-	u16 bias_g = 0;
-	u16 bias_a = 0;
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 5),
+						  0, (1 << core), 0,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 4), 0,
+						  (1 << core), 0,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-		if (rx_core == PHY_CORE_0) {
-			if (CHSPEC_IS5G(pi->radio_chanspec)) {
-				pi->tx_rx_cal_radio_saveregs[0] =
-					read_radio_reg(pi,
-					    RADIO_2057_TX0_TXRXCOUPLE_5G_PWRUP);
-				pi->tx_rx_cal_radio_saveregs[1] =
-					read_radio_reg(pi,
-					    RADIO_2057_TX0_TXRXCOUPLE_5G_ATTEN);
+		state->afectrl[core] = read_phy_reg(pi, (core == PHY_CORE_0) ?
+						    0xa6 : 0xa7);
+		state->afeoverride[core] =
+			read_phy_reg(pi, (core == PHY_CORE_0) ? 0x8f : 0xa5);
+		state->afectrl[off_core] =
+			read_phy_reg(pi, (core == PHY_CORE_0) ? 0xa7 : 0xa6);
+		state->afeoverride[off_core] =
+			read_phy_reg(pi, (core == PHY_CORE_0) ? 0xa5 : 0x8f);
 
-				write_radio_reg(pi,
-					RADIO_2057_TX0_TXRXCOUPLE_5G_PWRUP,
-					0x3);
-				write_radio_reg(pi,
-					RADIO_2057_TX0_TXRXCOUPLE_5G_ATTEN,
-					0xaf);
+		mod_phy_reg(pi, ((core == PHY_CORE_0) ? 0xa6 : 0xa7),
+			    (0x1 << 2), 0);
+		mod_phy_reg(pi, ((core == PHY_CORE_0) ? 0x8f :
+				 0xa5), (0x1 << 2), (0x1 << 2));
 
-			} else {
-				pi->tx_rx_cal_radio_saveregs[0] =
-					read_radio_reg(pi,
-					    RADIO_2057_TX0_TXRXCOUPLE_2G_PWRUP);
-				pi->tx_rx_cal_radio_saveregs[1] =
-					read_radio_reg(pi,
-					    RADIO_2057_TX0_TXRXCOUPLE_2G_ATTEN);
+		mod_phy_reg(pi, ((core == PHY_CORE_0) ? 0xa7 : 0xa6),
+			    (0x1 << 2), (0x1 << 2));
+		mod_phy_reg(pi, ((core == PHY_CORE_0) ? 0xa5 :
+				 0x8f), (0x1 << 2), (0x1 << 2));
 
-				write_radio_reg(
-					pi,
-					RADIO_2057_TX0_TXRXCOUPLE_2G_PWRUP,
-					0x3);
-				write_radio_reg(
-					pi,
-					RADIO_2057_TX0_TXRXCOUPLE_2G_ATTEN,
-					0x7f);
-			}
+		if (CHSPEC_IS2G(pi->radio_chanspec)) {
+			state->pwrup[core] =
+				READ_RADIO_REG3(pi, RADIO_2057, TX, core,
+						TXRXCOUPLE_2G_PWRUP);
+			state->atten[core] =
+				READ_RADIO_REG3(pi, RADIO_2057, TX, core,
+						TXRXCOUPLE_2G_ATTEN);
+			state->pwrup[off_core] =
+				READ_RADIO_REG3(pi, RADIO_2057, TX, off_core,
+						TXRXCOUPLE_2G_PWRUP);
+			state->atten[off_core] =
+				READ_RADIO_REG3(pi, RADIO_2057, TX, off_core,
+						TXRXCOUPLE_2G_ATTEN);
 
-		} else {
-			if (CHSPEC_IS5G(pi->radio_chanspec)) {
-				pi->tx_rx_cal_radio_saveregs[0] =
-					read_radio_reg(pi,
-					    RADIO_2057_TX1_TXRXCOUPLE_5G_PWRUP);
-				pi->tx_rx_cal_radio_saveregs[1] =
-					read_radio_reg(pi,
-					    RADIO_2057_TX1_TXRXCOUPLE_5G_ATTEN);
+			WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
+					 TXRXCOUPLE_2G_PWRUP, 0xc);
 
-				write_radio_reg(
-					pi,
-					RADIO_2057_TX1_TXRXCOUPLE_5G_PWRUP,
-					0x3);
-				write_radio_reg(
-					pi,
-					RADIO_2057_TX1_TXRXCOUPLE_5G_ATTEN,
-					0xaf);
+			if ((pi->pubpi.radiorev == 3) ||
+			    (pi->pubpi.radiorev == 4) ||
+			    (pi->pubpi.radiorev == 6))
+				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
+						 TXRXCOUPLE_2G_ATTEN, 0xf0);
+			else if (pi->pubpi.radiorev == 5)
+				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
+						 TXRXCOUPLE_2G_ATTEN,
+						 (core == 0) ? 0xf7 : 0xf2);
+			else if ((pi->pubpi.radiorev == 7)
+				 || (pi->pubpi.radiorev == 8))
+				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
+						 TXRXCOUPLE_2G_ATTEN, 0xf0);
 
-			} else {
-				pi->tx_rx_cal_radio_saveregs[0] =
-					read_radio_reg(pi,
-					    RADIO_2057_TX1_TXRXCOUPLE_2G_PWRUP);
-				pi->tx_rx_cal_radio_saveregs[1] =
-					read_radio_reg(pi,
-					    RADIO_2057_TX1_TXRXCOUPLE_2G_ATTEN);
+			WRITE_RADIO_REG3(pi, RADIO_2057, TX, off_core,
+					 TXRXCOUPLE_2G_PWRUP, 0x0);
+			WRITE_RADIO_REG3(pi, RADIO_2057, TX, off_core,
+					 TXRXCOUPLE_2G_ATTEN, 0xff);
+		} else {
+			state->pwrup[core] =
+				READ_RADIO_REG3(pi, RADIO_2057, TX, core,
+						TXRXCOUPLE_5G_PWRUP);
+			state->atten[core] =
+				READ_RADIO_REG3(pi, RADIO_2057, TX, core,
+						TXRXCOUPLE_5G_ATTEN);
+			state->pwrup[off_core] =
+				READ_RADIO_REG3(pi, RADIO_2057, TX, off_core,
+						TXRXCOUPLE_5G_PWRUP);
+			state->atten[off_core] =
+				READ_RADIO_REG3(pi, RADIO_2057, TX, off_core,
+						TXRXCOUPLE_5G_ATTEN);
 
-				write_radio_reg(pi,
-					RADIO_2057_TX1_TXRXCOUPLE_2G_PWRUP,
-					0x3);
-				write_radio_reg(pi,
-					RADIO_2057_TX1_TXRXCOUPLE_2G_ATTEN,
-					0x7f);
-			}
-		}
+			WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
+					 TXRXCOUPLE_5G_PWRUP, 0xc);
 
-	} else {
-		if (rx_core == PHY_CORE_0) {
-			pi->tx_rx_cal_radio_saveregs[0] =
-				read_radio_reg(pi,
-					       RADIO_2056_TX_RXIQCAL_TXMUX |
-					       RADIO_2056_TX1);
-			pi->tx_rx_cal_radio_saveregs[1] =
-				read_radio_reg(pi,
-					       RADIO_2056_RX_RXIQCAL_RXMUX |
-					       RADIO_2056_RX0);
+			if ((pi->pubpi.radiorev == 7)
+			    || (pi->pubpi.radiorev == 8))
+				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
+						 TXRXCOUPLE_5G_ATTEN, 0xf4);
 
-			if (pi->pubpi.radiorev >= 5) {
-				pi->tx_rx_cal_radio_saveregs[2] =
-					read_radio_reg(pi,
-						       RADIO_2056_RX_RXSPARE2 |
-						       RADIO_2056_RX0);
-				pi->tx_rx_cal_radio_saveregs[3] =
-					read_radio_reg(pi,
-						       RADIO_2056_TX_TXSPARE2 |
-						       RADIO_2056_TX1);
-			}
+			else
+				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
+						 TXRXCOUPLE_5G_ATTEN, 0xf0);
 
-			if (CHSPEC_IS5G(pi->radio_chanspec)) {
+			WRITE_RADIO_REG3(pi, RADIO_2057, TX, off_core,
+					 TXRXCOUPLE_5G_PWRUP, 0x0);
+			WRITE_RADIO_REG3(pi, RADIO_2057, TX, off_core,
+					 TXRXCOUPLE_5G_ATTEN, 0xff);
+		}
 
-				if (pi->pubpi.radiorev >= 5) {
-					pi->tx_rx_cal_radio_saveregs[4] =
-						read_radio_reg(pi,
-						      RADIO_2056_RX_LNAA_MASTER
-						      | RADIO_2056_RX0);
+		tone_freq = 4000;
 
-					write_radio_reg(
-						pi,
-						RADIO_2056_RX_LNAA_MASTER
-						| RADIO_2056_RX0, 0x40);
+		wlc_phy_tx_tone_nphy(pi, tone_freq, 181, 0, 0, false);
 
-					write_radio_reg(pi,
-						RADIO_2056_TX_TXSPARE2 |
-						RADIO_2056_TX1, bias_a);
+		mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x297 :
+			    0x29b, (0x1 << 0), (NPHY_PAPD_COMP_ON) << 0);
 
-					write_radio_reg(pi,
-						RADIO_2056_RX_RXSPARE2 |
-						RADIO_2056_RX0, bias_a);
-				} else {
-					pi->tx_rx_cal_radio_saveregs[4] =
-						read_radio_reg(pi,
-							RADIO_2056_RX_LNAA_TUNE
-							| RADIO_2056_RX0);
+		mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x2a3 :
+			    0x2a4, (0x1 << 13), (1) << 13);
 
-					offtune_val =
-						(pi->tx_rx_cal_radio_saveregs
-						 [2] & 0xF0) >> 8;
-					offtune_val =
-						(offtune_val <= 0x7) ? 0xF : 0;
+		mod_phy_reg(pi, (off_core == PHY_CORE_0) ? 0x297 :
+			    0x29b, (0x1 << 0), (NPHY_PAPD_COMP_OFF) << 0);
 
-					mod_radio_reg(pi,
-						      RADIO_2056_RX_LNAA_TUNE |
-						      RADIO_2056_RX0, 0xF0,
-						      (offtune_val << 8));
-				}
+		mod_phy_reg(pi, (off_core == PHY_CORE_0) ? 0x2a3 :
+			    0x2a4, (0x1 << 13), (0) << 13);
 
-				write_radio_reg(pi,
-						RADIO_2056_TX_RXIQCAL_TXMUX |
-						RADIO_2056_TX1, 0x9);
-				write_radio_reg(pi,
-						RADIO_2056_RX_RXIQCAL_RXMUX |
-						RADIO_2056_RX0, 0x9);
-			} else {
-				if (pi->pubpi.radiorev >= 5) {
-					pi->tx_rx_cal_radio_saveregs[4] =
-						read_radio_reg(
-						      pi,
-						      RADIO_2056_RX_LNAG_MASTER
-						    | RADIO_2056_RX0);
+	} else {
 
-					write_radio_reg(
-						pi,
-						RADIO_2056_RX_LNAG_MASTER
-						| RADIO_2056_RX0, 0x40);
+		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 12), 0, 0x3, 0);
 
-					write_radio_reg(
-						pi,
-						RADIO_2056_TX_TXSPARE2
-						|
-						RADIO_2056_TX1, bias_g);
+		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 3), 1, 0, 0);
 
-					write_radio_reg(
-						pi,
-						RADIO_2056_RX_RXSPARE2
-						|
-						RADIO_2056_RX0, bias_g);
+		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 0), 0, 0x3, 0);
 
-				} else {
-					pi->tx_rx_cal_radio_saveregs[4] =
-						read_radio_reg(
-							pi,
-							RADIO_2056_RX_LNAG_TUNE
-							| RADIO_2056_RX0);
+		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 2), 1, 0x3, 0);
+		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 1), 1, 0x3, 0);
 
-					offtune_val =
-						(pi->
-						 tx_rx_cal_radio_saveregs[2] &
-						 0xF0) >> 8;
-					offtune_val =
-						(offtune_val <= 0x7) ? 0xF : 0;
+		state->afectrl[core] = read_phy_reg(pi, (core == PHY_CORE_0) ?
+						    0xa6 : 0xa7);
+		state->afeoverride[core] =
+			read_phy_reg(pi, (core == PHY_CORE_0) ? 0x8f : 0xa5);
 
-					mod_radio_reg(pi,
-						      RADIO_2056_RX_LNAG_TUNE |
-						      RADIO_2056_RX0, 0xF0,
-						      (offtune_val << 8));
-				}
+		mod_phy_reg(pi, ((core == PHY_CORE_0) ? 0xa6 : 0xa7),
+			    (0x1 << 0) | (0x1 << 1) | (0x1 << 2), 0);
+		mod_phy_reg(pi, ((core == PHY_CORE_0) ? 0x8f :
+				 0xa5),
+			    (0x1 << 0) |
+			    (0x1 << 1) |
+			    (0x1 << 2), (0x1 << 0) | (0x1 << 1) | (0x1 << 2));
 
-				write_radio_reg(pi,
-						RADIO_2056_TX_RXIQCAL_TXMUX |
-						RADIO_2056_TX1, 0x6);
-				write_radio_reg(pi,
-						RADIO_2056_RX_RXIQCAL_RXMUX |
-						RADIO_2056_RX0, 0x6);
-			}
+		state->vga_master[core] =
+			READ_RADIO_REG2(pi, RADIO_2056, RX, core, VGA_MASTER);
+		WRITE_RADIO_REG2(pi, RADIO_2056, RX, core, VGA_MASTER, 0x2b);
+		if (CHSPEC_IS2G(pi->radio_chanspec)) {
+			state->fbmix[core] =
+				READ_RADIO_REG2(pi, RADIO_2056, RX, core,
+						TXFBMIX_G);
+			state->intpa_master[core] =
+				READ_RADIO_REG2(pi, RADIO_2056, TX, core,
+						INTPAG_MASTER);
 
+			WRITE_RADIO_REG2(pi, RADIO_2056, RX, core, TXFBMIX_G,
+					 0x03);
+			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
+					 INTPAG_MASTER, 0x04);
 		} else {
-			pi->tx_rx_cal_radio_saveregs[0] =
-				read_radio_reg(pi,
-					       RADIO_2056_TX_RXIQCAL_TXMUX |
-					       RADIO_2056_TX0);
-			pi->tx_rx_cal_radio_saveregs[1] =
-				read_radio_reg(pi,
-					       RADIO_2056_RX_RXIQCAL_RXMUX |
-					       RADIO_2056_RX1);
+			state->fbmix[core] =
+				READ_RADIO_REG2(pi, RADIO_2056, RX, core,
+						TXFBMIX_A);
+			state->intpa_master[core] =
+				READ_RADIO_REG2(pi, RADIO_2056, TX, core,
+						INTPAA_MASTER);
 
-			if (pi->pubpi.radiorev >= 5) {
-				pi->tx_rx_cal_radio_saveregs[2] =
-					read_radio_reg(pi,
-						       RADIO_2056_RX_RXSPARE2 |
-						       RADIO_2056_RX1);
-				pi->tx_rx_cal_radio_saveregs[3] =
-					read_radio_reg(pi,
-						       RADIO_2056_TX_TXSPARE2 |
-						       RADIO_2056_TX0);
-			}
+			WRITE_RADIO_REG2(pi, RADIO_2056, RX, core, TXFBMIX_A,
+					 0x03);
+			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
+					 INTPAA_MASTER, 0x04);
 
-			if (CHSPEC_IS5G(pi->radio_chanspec)) {
+		}
 
-				if (pi->pubpi.radiorev >= 5) {
-					pi->tx_rx_cal_radio_saveregs[4] =
-						read_radio_reg(
-						       pi,
-						       RADIO_2056_RX_LNAA_MASTER
-						       | RADIO_2056_RX1);
+		tone_freq = 4000;
 
-					write_radio_reg(
-						pi,
-						RADIO_2056_RX_LNAA_MASTER |
-						RADIO_2056_RX1, 0x40);
+		wlc_phy_tx_tone_nphy(pi, tone_freq, 181, 0, 0, false);
 
-					write_radio_reg(
-						pi,
-						RADIO_2056_TX_TXSPARE2
-						|
-						RADIO_2056_TX0, bias_a);
+		mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x297 :
+			    0x29b, (0x1 << 0), (1) << 0);
 
-					write_radio_reg(
-						pi,
-						RADIO_2056_RX_RXSPARE2
-						|
-						RADIO_2056_RX1, bias_a);
-				} else {
-					pi->tx_rx_cal_radio_saveregs[4] =
-						read_radio_reg(
-							pi,
-							RADIO_2056_RX_LNAA_TUNE
-							| RADIO_2056_RX1);
+		mod_phy_reg(pi, (off_core == PHY_CORE_0) ? 0x297 :
+			    0x29b, (0x1 << 0), (0) << 0);
 
-					offtune_val =
-						(pi->
-						 tx_rx_cal_radio_saveregs[2] &
-						 0xF0) >> 8;
-					offtune_val =
-						(offtune_val <= 0x7) ? 0xF : 0;
+		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 3), 0, 0x3, 0);
+	}
+}
 
-					mod_radio_reg(pi,
-						      RADIO_2056_RX_LNAA_TUNE |
-						      RADIO_2056_RX1, 0xF0,
-						      (offtune_val << 8));
-				}
+static void
+wlc_phy_papd_cal_cleanup_nphy(struct brcms_phy *pi,
+			      struct nphy_papd_restore_state *state)
+{
+	u8 core;
 
-				write_radio_reg(pi,
-						RADIO_2056_TX_RXIQCAL_TXMUX |
-						RADIO_2056_TX0, 0x9);
-				write_radio_reg(pi,
-						RADIO_2056_RX_RXIQCAL_RXMUX |
-						RADIO_2056_RX1, 0x9);
-			} else {
-				if (pi->pubpi.radiorev >= 5) {
-					pi->tx_rx_cal_radio_saveregs[4] =
-						read_radio_reg(
-						      pi,
-						      RADIO_2056_RX_LNAG_MASTER
-						    | RADIO_2056_RX1);
+	wlc_phy_stopplayback_nphy(pi);
 
-					write_radio_reg(
-						pi,
-						RADIO_2056_RX_LNAG_MASTER
-						| RADIO_2056_RX1, 0x40);
+	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 
-					write_radio_reg(
-						pi,
-						RADIO_2056_TX_TXSPARE2
-						|
-						RADIO_2056_TX0, bias_g);
+		for (core = 0; core < pi->pubpi.phy_corenum; core++) {
 
-					write_radio_reg(
-						pi,
-						RADIO_2056_RX_RXSPARE2
-						|
-						RADIO_2056_RX1, bias_g);
-				} else {
-					pi->tx_rx_cal_radio_saveregs[4] =
-						read_radio_reg(
-							pi,
-							RADIO_2056_RX_LNAG_TUNE
-							| RADIO_2056_RX1);
+			if (CHSPEC_IS2G(pi->radio_chanspec)) {
+				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
+						 TXRXCOUPLE_2G_PWRUP, 0);
+				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
+						 TXRXCOUPLE_2G_ATTEN,
+						 state->atten[core]);
+			} else {
+				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
+						 TXRXCOUPLE_5G_PWRUP, 0);
+				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
+						 TXRXCOUPLE_5G_ATTEN,
+						 state->atten[core]);
+			}
+		}
 
-					offtune_val =
-						(pi->
-						 tx_rx_cal_radio_saveregs[2] &
-						 0xF0) >> 8;
-					offtune_val =
-						(offtune_val <= 0x7) ? 0xF : 0;
+		if ((pi->pubpi.radiorev == 4) || (pi->pubpi.radiorev == 6))
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 2),
+				1, 0x3, 0,
+				NPHY_REV7_RFCTRLOVERRIDE_ID0);
+		else
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 2),
+				0, 0x3, 1,
+				NPHY_REV7_RFCTRLOVERRIDE_ID0);
+
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 1),
+						  0, 0x3, 1,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 0), 0, 0x3, 1,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID2);
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 2), 0, 0x3, 1,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID2);
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 11), 1, 0x3, 1,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 3), 0, 0x3, 1,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID0);
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 11), 0, 0x3, 1,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID0);
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 12), 0, 0x3, 1,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID0);
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 2), 1, 0x3, 1,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 0), 0, 0x3, 1,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 1), 1, 0x3, 1,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID2);
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 8), 0, 0x3, 1,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 9), 1, 0x3, 1,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 10), 0, 0x3, 1,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 3), 1, 0x3, 1,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 5), 0, 0x3, 1,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 4), 0, 0x3, 1,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
 
-					mod_radio_reg(pi,
-						      RADIO_2056_RX_LNAG_TUNE |
-						      RADIO_2056_RX1, 0xF0,
-						      (offtune_val << 8));
-				}
+		for (core = 0; core < pi->pubpi.phy_corenum; core++) {
 
-				write_radio_reg(pi,
-						RADIO_2056_TX_RXIQCAL_TXMUX |
-						RADIO_2056_TX0, 0x6);
-				write_radio_reg(pi,
-						RADIO_2056_RX_RXIQCAL_RXMUX |
-						RADIO_2056_RX1, 0x6);
-			}
+			write_phy_reg(pi, (core == PHY_CORE_0) ?
+				      0xa6 : 0xa7, state->afectrl[core]);
+			write_phy_reg(pi, (core == PHY_CORE_0) ? 0x8f :
+				      0xa5, state->afeoverride[core]);
 		}
-	}
-}
 
-static void wlc_phy_rxcal_radio_cleanup_nphy(struct brcms_phy *pi, u8 rx_core)
-{
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-		if (rx_core == PHY_CORE_0) {
-			if (CHSPEC_IS5G(pi->radio_chanspec)) {
-				write_radio_reg(
-					pi,
-					RADIO_2057_TX0_TXRXCOUPLE_5G_PWRUP,
-					pi->
-					tx_rx_cal_radio_saveregs[0]);
-				write_radio_reg(
-					pi,
-					RADIO_2057_TX0_TXRXCOUPLE_5G_ATTEN,
-					pi->
-					tx_rx_cal_radio_saveregs[1]);
+		wlc_phy_ipa_set_bbmult_nphy(pi, (state->mm >> 8) & 0xff,
+					    (state->mm & 0xff));
 
-			} else {
-				write_radio_reg(
-					pi,
-					RADIO_2057_TX0_TXRXCOUPLE_2G_PWRUP,
-					pi->
-					tx_rx_cal_radio_saveregs[0]);
-				write_radio_reg(
-					pi,
-					RADIO_2057_TX0_TXRXCOUPLE_2G_ATTEN,
-					pi->
-					tx_rx_cal_radio_saveregs[1]);
-			}
+		if (NREV_IS(pi->pubpi.phy_rev, 7)
+		    || NREV_GE(pi->pubpi.phy_rev, 8))
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 7), 0, 0,
+				1,
+				NPHY_REV7_RFCTRLOVERRIDE_ID1);
+	} else {
+		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 12), 0, 0x3, 1);
+		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 13), 0, 0x3, 1);
+		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 0), 0, 0x3, 1);
 
-		} else {
-			if (CHSPEC_IS5G(pi->radio_chanspec)) {
-				write_radio_reg(
-					pi,
-					RADIO_2057_TX1_TXRXCOUPLE_5G_PWRUP,
-					pi->
-					tx_rx_cal_radio_saveregs[0]);
-				write_radio_reg(
-					pi,
-					RADIO_2057_TX1_TXRXCOUPLE_5G_ATTEN,
-					pi->
-					tx_rx_cal_radio_saveregs[1]);
+		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 2), 0, 0x3, 1);
+		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 1), 0, 0x3, 1);
+
+		for (core = 0; core < pi->pubpi.phy_corenum; core++) {
 
+			WRITE_RADIO_REG2(pi, RADIO_2056, RX, core, VGA_MASTER,
+					 state->vga_master[core]);
+			if (CHSPEC_IS2G(pi->radio_chanspec)) {
+				WRITE_RADIO_REG2(pi, RADIO_2056, RX, core,
+						 TXFBMIX_G, state->fbmix[core]);
+				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
+						 INTPAG_MASTER,
+						 state->intpa_master[core]);
 			} else {
-				write_radio_reg(
-					pi,
-					RADIO_2057_TX1_TXRXCOUPLE_2G_PWRUP,
-					pi->
-					tx_rx_cal_radio_saveregs[0]);
-				write_radio_reg(
-					pi,
-					RADIO_2057_TX1_TXRXCOUPLE_2G_ATTEN,
-					pi->
-					tx_rx_cal_radio_saveregs[1]);
+				WRITE_RADIO_REG2(pi, RADIO_2056, RX, core,
+						 TXFBMIX_A, state->fbmix[core]);
+				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
+						 INTPAA_MASTER,
+						 state->intpa_master[core]);
 			}
-		}
 
-	} else {
-		if (rx_core == PHY_CORE_0) {
-			write_radio_reg(pi,
-					RADIO_2056_TX_RXIQCAL_TXMUX |
-					RADIO_2056_TX1,
-					pi->tx_rx_cal_radio_saveregs[0]);
+			write_phy_reg(pi, (core == PHY_CORE_0) ?
+				      0xa6 : 0xa7, state->afectrl[core]);
+			write_phy_reg(pi, (core == PHY_CORE_0) ? 0x8f :
+				      0xa5, state->afeoverride[core]);
+		}
 
-			write_radio_reg(pi,
-					RADIO_2056_RX_RXIQCAL_RXMUX |
-					RADIO_2056_RX0,
-					pi->tx_rx_cal_radio_saveregs[1]);
+		wlc_phy_ipa_set_bbmult_nphy(pi, (state->mm >> 8) & 0xff,
+					    (state->mm & 0xff));
 
-			if (pi->pubpi.radiorev >= 5) {
-				write_radio_reg(pi,
-						RADIO_2056_RX_RXSPARE2 |
-						RADIO_2056_RX0,
-						pi->
-						tx_rx_cal_radio_saveregs[2]);
+		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 3), 0, 0x3, 1);
+	}
+}
 
-				write_radio_reg(pi,
-						RADIO_2056_TX_TXSPARE2 |
-						RADIO_2056_TX1,
-						pi->
-						tx_rx_cal_radio_saveregs[3]);
-			}
+static void
+wlc_phy_a1_nphy(struct brcms_phy *pi, u8 core, u32 winsz, u32 start,
+		u32 end)
+{
+	u32 *buf, *src, *dst, sz;
 
-			if (CHSPEC_IS5G(pi->radio_chanspec)) {
-				if (pi->pubpi.radiorev >= 5)
-					write_radio_reg(
-						pi,
-						RADIO_2056_RX_LNAA_MASTER
-						| RADIO_2056_RX0,
-						pi->
-						tx_rx_cal_radio_saveregs
-						[4]);
-				else
-					write_radio_reg(
-						pi,
-						RADIO_2056_RX_LNAA_TUNE
-						| RADIO_2056_RX0,
-						pi->
-						tx_rx_cal_radio_saveregs
-						[4]);
-			} else {
-				if (pi->pubpi.radiorev >= 5)
-					write_radio_reg(
-						pi,
-						RADIO_2056_RX_LNAG_MASTER
-						| RADIO_2056_RX0,
-						pi->
-						tx_rx_cal_radio_saveregs
-						[4]);
-				else
-					write_radio_reg(
-						pi,
-						RADIO_2056_RX_LNAG_TUNE
-						| RADIO_2056_RX0,
-						pi->
-						tx_rx_cal_radio_saveregs
-						[4]);
-			}
+	sz = end - start + 1;
 
-		} else {
-			write_radio_reg(pi,
-					RADIO_2056_TX_RXIQCAL_TXMUX |
-					RADIO_2056_TX0,
-					pi->tx_rx_cal_radio_saveregs[0]);
+	buf = kmalloc(2 * sizeof(u32) * NPHY_PAPD_EPS_TBL_SIZE, GFP_ATOMIC);
+	if (NULL == buf)
+		return;
 
-			write_radio_reg(pi,
-					RADIO_2056_RX_RXIQCAL_RXMUX |
-					RADIO_2056_RX1,
-					pi->tx_rx_cal_radio_saveregs[1]);
+	src = buf;
+	dst = buf + NPHY_PAPD_EPS_TBL_SIZE;
 
-			if (pi->pubpi.radiorev >= 5) {
-				write_radio_reg(pi,
-						RADIO_2056_RX_RXSPARE2 |
-						RADIO_2056_RX1,
-						pi->
-						tx_rx_cal_radio_saveregs[2]);
+	wlc_phy_table_read_nphy(pi,
+				(core ==
+				 PHY_CORE_0 ? NPHY_TBL_ID_EPSILONTBL0 :
+				 NPHY_TBL_ID_EPSILONTBL1),
+				NPHY_PAPD_EPS_TBL_SIZE, 0, 32, src);
 
-				write_radio_reg(pi,
-						RADIO_2056_TX_TXSPARE2 |
-						RADIO_2056_TX0,
-						pi->
-						tx_rx_cal_radio_saveregs[3]);
-			}
+	do {
+		u32 phy_a1, phy_a2;
+		s32 phy_a3, phy_a4, phy_a5, phy_a6, phy_a7;
 
-			if (CHSPEC_IS5G(pi->radio_chanspec)) {
-				if (pi->pubpi.radiorev >= 5)
-					write_radio_reg(
-						pi,
-						RADIO_2056_RX_LNAA_MASTER
-						| RADIO_2056_RX1,
-						pi->
-						tx_rx_cal_radio_saveregs
-						[4]);
-				else
-					write_radio_reg(
-						pi,
-						RADIO_2056_RX_LNAA_TUNE
-						| RADIO_2056_RX1,
-						pi->
-						tx_rx_cal_radio_saveregs
-						[4]);
-			} else {
-				if (pi->pubpi.radiorev >= 5)
-					write_radio_reg(
-						pi,
-						RADIO_2056_RX_LNAG_MASTER
-						| RADIO_2056_RX1,
-						pi->
-						tx_rx_cal_radio_saveregs
-						[4]);
-				else
-					write_radio_reg(
-						pi,
-						RADIO_2056_RX_LNAG_TUNE
-						| RADIO_2056_RX1,
-						pi->
-						tx_rx_cal_radio_saveregs
-						[4]);
-			}
-		}
-	}
+		phy_a1 = end - min(end, (winsz >> 1));
+		phy_a2 = min_t(u32, NPHY_PAPD_EPS_TBL_SIZE - 1,
+			       end + (winsz >> 1));
+		phy_a3 = phy_a2 - phy_a1 + 1;
+		phy_a6 = 0;
+		phy_a7 = 0;
+
+		do {
+			wlc_phy_papd_decode_epsilon(src[phy_a2], &phy_a4,
+						    &phy_a5);
+			phy_a6 += phy_a4;
+			phy_a7 += phy_a5;
+		} while (phy_a2-- != phy_a1);
+
+		phy_a6 /= phy_a3;
+		phy_a7 /= phy_a3;
+		dst[end] = ((u32) phy_a7 << 13) | ((u32) phy_a6 & 0x1fff);
+	} while (end-- != start);
+
+	wlc_phy_table_write_nphy(pi,
+				 (core ==
+				  PHY_CORE_0) ? NPHY_TBL_ID_EPSILONTBL0 :
+				 NPHY_TBL_ID_EPSILONTBL1, sz, start, 32, dst);
+
+	kfree(buf);
 }
 
-static void wlc_phy_rxcal_physetup_nphy(struct brcms_phy *pi, u8 rx_core)
+static void
+wlc_phy_a2_nphy(struct brcms_phy *pi, struct nphy_ipa_txcalgains *txgains,
+		enum phy_cal_mode cal_mode, u8 core)
 {
-	u8 tx_core;
-	u16 rx_antval, tx_antval;
+	u16 phy_a1, phy_a2, phy_a3;
+	u16 phy_a4, phy_a5;
+	bool phy_a6;
+	u8 phy_a7, m[2];
+	u32 phy_a8 = 0;
+	struct nphy_txgains phy_a9;
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7))
-		tx_core = rx_core;
-	else
-		tx_core = (rx_core == PHY_CORE_0) ? 1 : 0;
+	if (NREV_LT(pi->pubpi.phy_rev, 3))
+		return;
+
+	phy_a7 = (core == PHY_CORE_0) ? 1 : 0;
+
+	phy_a6 = ((cal_mode == CAL_GCTRL)
+		  || (cal_mode == CAL_SOFT)) ? true : false;
 
-	pi->tx_rx_cal_phy_saveregs[0] = read_phy_reg(pi, 0xa2);
-	pi->tx_rx_cal_phy_saveregs[1] =
-		read_phy_reg(pi, (rx_core == PHY_CORE_0) ? 0xa6 : 0xa7);
-	pi->tx_rx_cal_phy_saveregs[2] =
-		read_phy_reg(pi, (rx_core == PHY_CORE_0) ? 0x8f : 0xa5);
-	pi->tx_rx_cal_phy_saveregs[3] = read_phy_reg(pi, 0x91);
-	pi->tx_rx_cal_phy_saveregs[4] = read_phy_reg(pi, 0x92);
-	pi->tx_rx_cal_phy_saveregs[5] = read_phy_reg(pi, 0x7a);
-	pi->tx_rx_cal_phy_saveregs[6] = read_phy_reg(pi, 0x7d);
-	pi->tx_rx_cal_phy_saveregs[7] = read_phy_reg(pi, 0xe7);
-	pi->tx_rx_cal_phy_saveregs[8] = read_phy_reg(pi, 0xec);
 	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-		pi->tx_rx_cal_phy_saveregs[11] = read_phy_reg(pi, 0x342);
-		pi->tx_rx_cal_phy_saveregs[12] = read_phy_reg(pi, 0x343);
-		pi->tx_rx_cal_phy_saveregs[13] = read_phy_reg(pi, 0x346);
-		pi->tx_rx_cal_phy_saveregs[14] = read_phy_reg(pi, 0x347);
-	}
 
-	pi->tx_rx_cal_phy_saveregs[9] = read_phy_reg(pi, 0x297);
-	pi->tx_rx_cal_phy_saveregs[10] = read_phy_reg(pi, 0x29b);
-	mod_phy_reg(pi, (0 == PHY_CORE_0) ? 0x297 :
-		    0x29b, (0x1 << 0), (0) << 0);
+		phy_a9 = wlc_phy_get_tx_gain_nphy(pi);
 
-	mod_phy_reg(pi, (1 == PHY_CORE_0) ? 0x297 :
-		    0x29b, (0x1 << 0), (0) << 0);
+		if (CHSPEC_IS2G(pi->radio_chanspec))
+			phy_a5 = ((phy_a9.txlpf[core] << 15) |
+				  (phy_a9.txgm[core] << 12) |
+				  (phy_a9.pga[core] << 8) |
+				  (txgains->gains.pad[core] << 3) |
+				  (phy_a9.ipa[core]));
+		else
+			phy_a5 = ((phy_a9.txlpf[core] << 15) |
+				  (phy_a9.txgm[core] << 12) |
+				  (txgains->gains.pga[core] << 8) |
+				  (phy_a9.pad[core] << 3) | (phy_a9.ipa[core]));
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+		wlc_phy_rfctrl_override_1tomany_nphy(
+			pi,
+			NPHY_REV7_RfctrlOverride_cmd_txgain,
+			phy_a5, (1 << core), 0);
 
-		mod_phy_reg(pi, 0xa2, (0xf << 0), (1 << tx_core) << 0);
+		if (CHSPEC_IS2G(pi->radio_chanspec)) {
+			if ((pi->pubpi.radiorev <= 4)
+			    || (pi->pubpi.radiorev == 6))
+				m[core] = IS40MHZ(pi) ? 60 : 79;
+			else
+				m[core] = IS40MHZ(pi) ? 45 : 64;
+		} else {
+			m[core] = IS40MHZ(pi) ? 75 : 107;
+		}
 
-		mod_phy_reg(pi, 0xa2, (0xf << 12), (1 << (1 - rx_core)) << 12);
+		m[phy_a7] = 0;
+		wlc_phy_ipa_set_bbmult_nphy(pi, m[0], m[1]);
 
-	} else {
+		phy_a2 = 63;
 
-		mod_phy_reg(pi, 0xa2, (0xf << 12), (1 << tx_core) << 12);
-		mod_phy_reg(pi, 0xa2, (0xf << 0), (1 << tx_core) << 0);
-		mod_phy_reg(pi, 0xa2, (0xf << 4), (1 << rx_core) << 4);
-		mod_phy_reg(pi, 0xa2, (0xf << 8), (1 << rx_core) << 8);
-	}
+		if (CHSPEC_IS2G(pi->radio_chanspec)) {
+			if ((pi->pubpi.radiorev == 4)
+			    || (pi->pubpi.radiorev == 6)) {
+				phy_a1 = 30;
+				phy_a3 = 30;
+			} else {
+				phy_a1 = 25;
+				phy_a3 = 25;
+			}
+		} else {
+			if ((pi->pubpi.radiorev == 5)
+			    || (pi->pubpi.radiorev == 7)
+			    || (pi->pubpi.radiorev == 8)) {
+				phy_a1 = 25;
+				phy_a3 = 25;
+			} else {
+				phy_a1 = 35;
+				phy_a3 = 35;
+			}
+		}
 
-	mod_phy_reg(pi, ((rx_core == PHY_CORE_0) ? 0xa6 : 0xa7), (0x1 << 2), 0);
-	mod_phy_reg(pi, (rx_core == PHY_CORE_0) ? 0x8f : 0xa5,
-		    (0x1 << 2), (0x1 << 2));
-	if (NREV_LT(pi->pubpi.phy_rev, 7)) {
-		mod_phy_reg(pi, ((rx_core == PHY_CORE_0) ? 0xa6 : 0xa7),
-			    (0x1 << 0) | (0x1 << 1), 0);
-		mod_phy_reg(pi, (rx_core == PHY_CORE_0) ?
-			    0x8f : 0xa5,
-			    (0x1 << 0) | (0x1 << 1), (0x1 << 0) | (0x1 << 1));
-	}
+		if (cal_mode == CAL_GCTRL) {
+			if ((pi->pubpi.radiorev == 5)
+			    && (CHSPEC_IS2G(pi->radio_chanspec)))
+				phy_a1 = 55;
+			else if (((pi->pubpi.radiorev == 7) &&
+				  (CHSPEC_IS2G(pi->radio_chanspec))) ||
+				 ((pi->pubpi.radiorev == 8) &&
+				  (CHSPEC_IS2G(pi->radio_chanspec))))
+				phy_a1 = 60;
+			else
+				phy_a1 = 63;
 
-	wlc_phy_rfctrlintc_override_nphy(pi, NPHY_RfctrlIntc_override_PA, 0,
-					 RADIO_MIMO_CORESEL_CORE1 |
-					 RADIO_MIMO_CORESEL_CORE2);
+		} else if ((cal_mode != CAL_FULL) && (cal_mode != CAL_SOFT)) {
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 3),
-						  0, 0, 0,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID0);
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 9), 0, 0, 0,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 10), 1, 0, 0,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 0), 1, 0, 0,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 1), 1, 0, 0,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID2);
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 11), 0, 0, 0,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
-		if (CHSPEC_IS40(pi->radio_chanspec))
-			wlc_phy_rfctrl_override_nphy_rev7(
-				pi,
-				(0x1 << 7),
-				2, 0, 0,
-				NPHY_REV7_RFCTRLOVERRIDE_ID1);
-		else
-			wlc_phy_rfctrl_override_nphy_rev7(
-				pi,
-				(0x1 << 7),
-				0, 0, 0,
-				NPHY_REV7_RFCTRLOVERRIDE_ID1);
+			phy_a1 = 35;
+			phy_a3 = 35;
+		}
 
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 7),
-						  0, 0, 0,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 5), 0, 0, 0,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
-	} else {
-		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 3), 0, 3, 0);
-	}
+		mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x297 :
+			    0x29b, (0x1 << 0), (1) << 0);
 
-	wlc_phy_force_rfseq_nphy(pi, NPHY_RFSEQ_RX2TX);
+		mod_phy_reg(pi, (phy_a7 == PHY_CORE_0) ? 0x297 :
+			    0x29b, (0x1 << 0), (0) << 0);
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+		mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x2a3 :
+			    0x2a4, (0x1 << 13), (1) << 13);
 
-		wlc_phy_rfctrlintc_override_nphy(pi,
-						 NPHY_RfctrlIntc_override_TRSW,
-						 0x1, rx_core + 1);
-	} else {
+		mod_phy_reg(pi, (phy_a7 == PHY_CORE_0) ? 0x2a3 :
+			    0x2a4, (0x1 << 13), (0) << 13);
 
-		if (rx_core == PHY_CORE_0) {
-			rx_antval = 0x1;
-			tx_antval = 0x8;
-		} else {
-			rx_antval = 0x4;
-			tx_antval = 0x2;
-		}
+		write_phy_reg(pi, 0x2a1, 0x80);
+		write_phy_reg(pi, 0x2a2, 0x100);
 
-		wlc_phy_rfctrlintc_override_nphy(pi,
-						 NPHY_RfctrlIntc_override_TRSW,
-						 rx_antval, rx_core + 1);
-		wlc_phy_rfctrlintc_override_nphy(pi,
-						 NPHY_RfctrlIntc_override_TRSW,
-						 tx_antval, tx_core + 1);
-	}
-}
+		mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x2a3 :
+			    0x2a4, (0x7 << 4), (11) << 4);
 
-static void wlc_phy_rxcal_phycleanup_nphy(struct brcms_phy *pi, u8 rx_core)
-{
+		mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x2a3 :
+			    0x2a4, (0x7 << 8), (11) << 8);
 
-	write_phy_reg(pi, 0xa2, pi->tx_rx_cal_phy_saveregs[0]);
-	write_phy_reg(pi, (rx_core == PHY_CORE_0) ? 0xa6 : 0xa7,
-		      pi->tx_rx_cal_phy_saveregs[1]);
-	write_phy_reg(pi, (rx_core == PHY_CORE_0) ? 0x8f : 0xa5,
-		      pi->tx_rx_cal_phy_saveregs[2]);
-	write_phy_reg(pi, 0x91, pi->tx_rx_cal_phy_saveregs[3]);
-	write_phy_reg(pi, 0x92, pi->tx_rx_cal_phy_saveregs[4]);
+		mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x2a3 :
+			    0x2a4, (0x7 << 0), (0x3) << 0);
 
-	write_phy_reg(pi, 0x7a, pi->tx_rx_cal_phy_saveregs[5]);
-	write_phy_reg(pi, 0x7d, pi->tx_rx_cal_phy_saveregs[6]);
-	write_phy_reg(pi, 0xe7, pi->tx_rx_cal_phy_saveregs[7]);
-	write_phy_reg(pi, 0xec, pi->tx_rx_cal_phy_saveregs[8]);
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-		write_phy_reg(pi, 0x342, pi->tx_rx_cal_phy_saveregs[11]);
-		write_phy_reg(pi, 0x343, pi->tx_rx_cal_phy_saveregs[12]);
-		write_phy_reg(pi, 0x346, pi->tx_rx_cal_phy_saveregs[13]);
-		write_phy_reg(pi, 0x347, pi->tx_rx_cal_phy_saveregs[14]);
-	}
+		write_phy_reg(pi, 0x2e5, 0x20);
 
-	write_phy_reg(pi, 0x297, pi->tx_rx_cal_phy_saveregs[9]);
-	write_phy_reg(pi, 0x29b, pi->tx_rx_cal_phy_saveregs[10]);
-}
+		mod_phy_reg(pi, 0x2a0, (0x3f << 0), (phy_a3) << 0);
+
+		mod_phy_reg(pi, 0x29f, (0x3f << 0), (phy_a1) << 0);
+
+		mod_phy_reg(pi, 0x29f, (0x3f << 8), (phy_a2) << 8);
+
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 3),
+						  1, ((core == 0) ? 1 : 2), 0,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID0);
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 3),
+						  0, ((core == 0) ? 2 : 1), 0,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID0);
 
-static void
-wlc_phy_rxcal_gainctrl_nphy_rev5(struct brcms_phy *pi, u8 rx_core,
-				 u16 *rxgain, u8 cal_type)
-{
+		write_phy_reg(pi, 0x2be, 1);
+		SPINWAIT(read_phy_reg(pi, 0x2be), 10 * 1000 * 1000);
 
-	u16 num_samps;
-	struct phy_iq_est est[PHY_CORE_MAX];
-	u8 tx_core;
-	struct nphy_iq_comp save_comp, zero_comp;
-	u32 i_pwr, q_pwr, curr_pwr, optim_pwr = 0, prev_pwr = 0,
-	    thresh_pwr = 10000;
-	s16 desired_log2_pwr, actual_log2_pwr, delta_pwr;
-	bool gainctrl_done = false;
-	u8 mix_tia_gain = 3;
-	s8 optim_gaintbl_index = 0, prev_gaintbl_index = 0;
-	s8 curr_gaintbl_index = 3;
-	u8 gainctrl_dirn = NPHY_RXCAL_GAIN_INIT;
-	struct nphy_ipa_txrxgain *nphy_rxcal_gaintbl;
-	u16 hpvga, lpf_biq1, lpf_biq0, lna2, lna1;
-	int fine_gain_idx;
-	s8 txpwrindex;
-	u16 nphy_rxcal_txgain[2];
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 3),
+						  0, 0x3, 0,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID0);
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7))
-		tx_core = rx_core;
-	else
-		tx_core = 1 - rx_core;
+		wlc_phy_table_write_nphy(pi,
+					 (core ==
+					  PHY_CORE_0) ? NPHY_TBL_ID_EPSILONTBL0
+					 : NPHY_TBL_ID_EPSILONTBL1, 1, phy_a3,
+					 32, &phy_a8);
 
-	num_samps = 1024;
-	desired_log2_pwr = (cal_type == 0) ? 13 : 13;
+		if (cal_mode != CAL_GCTRL) {
+			if (CHSPEC_IS5G(pi->radio_chanspec))
+				wlc_phy_a1_nphy(pi, core, 5, 0, 35);
+		}
 
-	wlc_phy_rx_iq_coeffs_nphy(pi, 0, &save_comp);
-	zero_comp.a0 = zero_comp.b0 = zero_comp.a1 = zero_comp.b1 = 0x0;
-	wlc_phy_rx_iq_coeffs_nphy(pi, 1, &zero_comp);
+		wlc_phy_rfctrl_override_1tomany_nphy(
+			pi,
+			NPHY_REV7_RfctrlOverride_cmd_txgain,
+			phy_a5, (1 << core), 1);
 
-	if (CHSPEC_IS5G(pi->radio_chanspec)) {
-		if (NREV_GE(pi->pubpi.phy_rev, 7))
-			mix_tia_gain = 3;
-		else if (NREV_GE(pi->pubpi.phy_rev, 4))
-			mix_tia_gain = 4;
-		else
-			mix_tia_gain = 6;
-		if (NREV_GE(pi->pubpi.phy_rev, 7))
-			nphy_rxcal_gaintbl = nphy_ipa_rxcal_gaintbl_5GHz_rev7;
-		else
-			nphy_rxcal_gaintbl = nphy_ipa_rxcal_gaintbl_5GHz;
 	} else {
-		if (NREV_GE(pi->pubpi.phy_rev, 7))
-			nphy_rxcal_gaintbl = nphy_ipa_rxcal_gaintbl_2GHz_rev7;
-		else
-			nphy_rxcal_gaintbl = nphy_ipa_rxcal_gaintbl_2GHz;
-	}
 
-	do {
+		if (txgains) {
+			if (txgains->useindex) {
+				phy_a4 = 15 - ((txgains->index) >> 3);
+				if (CHSPEC_IS2G(pi->radio_chanspec)) {
+					if (NREV_GE(pi->pubpi.phy_rev, 6))
+						phy_a5 = 0x00f7 | (phy_a4 << 8);
 
-		hpvga = (NREV_GE(pi->pubpi.phy_rev, 7)) ?
-			0 : nphy_rxcal_gaintbl[curr_gaintbl_index].hpvga;
-		lpf_biq1 = nphy_rxcal_gaintbl[curr_gaintbl_index].lpf_biq1;
-		lpf_biq0 = nphy_rxcal_gaintbl[curr_gaintbl_index].lpf_biq0;
-		lna2 = nphy_rxcal_gaintbl[curr_gaintbl_index].lna2;
-		lna1 = nphy_rxcal_gaintbl[curr_gaintbl_index].lna1;
-		txpwrindex = nphy_rxcal_gaintbl[curr_gaintbl_index].txpwrindex;
+					else
+					if (NREV_IS(pi->pubpi.phy_rev, 5))
+						phy_a5 = 0x10f7 | (phy_a4 << 8);
+					else
+						phy_a5 = 0x50f7 | (phy_a4 << 8);
+				} else {
+					phy_a5 = 0x70f7 | (phy_a4 << 8);
+				}
+				wlc_phy_rfctrl_override_nphy(pi,
+							     (0x1 << 13),
+							     phy_a5,
+							     (1 << core), 0);
+			} else {
+				wlc_phy_rfctrl_override_nphy(pi,
+							     (0x1 << 13),
+							     0x5bf7,
+							     (1 << core), 0);
+			}
+		}
 
-		if (NREV_GE(pi->pubpi.phy_rev, 7))
-			wlc_phy_rfctrl_override_1tomany_nphy(
-				pi,
-				NPHY_REV7_RfctrlOverride_cmd_rxgain,
-				((lpf_biq1 << 12) |
-				 (lpf_biq0 << 8) |
-				 (mix_tia_gain << 4) | (lna2 << 2)
-				 | lna1), 0x3, 0);
+		if (CHSPEC_IS2G(pi->radio_chanspec))
+			m[core] = IS40MHZ(pi) ? 45 : 64;
 		else
-			wlc_phy_rfctrl_override_nphy(pi, (0x1 << 12),
-						     ((hpvga << 12) |
-						      (lpf_biq1 << 10) |
-						      (lpf_biq0 << 8) |
-						      (mix_tia_gain << 4) |
-						      (lna2 << 2) | lna1), 0x3,
-						     0);
+			m[core] = IS40MHZ(pi) ? 75 : 107;
 
-		pi->nphy_rxcal_pwr_idx[tx_core] = txpwrindex;
+		m[phy_a7] = 0;
+		wlc_phy_ipa_set_bbmult_nphy(pi, m[0], m[1]);
 
-		if (txpwrindex == -1) {
-			nphy_rxcal_txgain[0] = 0x8ff0 | pi->nphy_gmval;
-			nphy_rxcal_txgain[1] = 0x8ff0 | pi->nphy_gmval;
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ,
-						 2, 0x110, 16,
-						 nphy_rxcal_txgain);
+		phy_a2 = 63;
+
+		if (cal_mode == CAL_FULL) {
+			phy_a1 = 25;
+			phy_a3 = 25;
+		} else if (cal_mode == CAL_SOFT) {
+			phy_a1 = 25;
+			phy_a3 = 25;
+		} else if (cal_mode == CAL_GCTRL) {
+			phy_a1 = 63;
+			phy_a3 = 25;
 		} else {
-			wlc_phy_txpwr_index_nphy(pi, tx_core + 1, txpwrindex,
-						 false);
+
+			phy_a1 = 25;
+			phy_a3 = 25;
 		}
 
-		wlc_phy_tx_tone_nphy(pi, (CHSPEC_IS40(pi->radio_chanspec)) ?
-				     NPHY_RXCAL_TONEFREQ_40MHz :
-				     NPHY_RXCAL_TONEFREQ_20MHz,
-				     NPHY_RXCAL_TONEAMP, 0, cal_type, false);
+		mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x297 :
+			    0x29b, (0x1 << 0), (1) << 0);
 
-		wlc_phy_rx_iq_est_nphy(pi, est, num_samps, 32, 0);
-		i_pwr = (est[rx_core].i_pwr + num_samps / 2) / num_samps;
-		q_pwr = (est[rx_core].q_pwr + num_samps / 2) / num_samps;
-		curr_pwr = i_pwr + q_pwr;
+		mod_phy_reg(pi, (phy_a7 == PHY_CORE_0) ? 0x297 :
+			    0x29b, (0x1 << 0), (0) << 0);
 
-		switch (gainctrl_dirn) {
-		case NPHY_RXCAL_GAIN_INIT:
-			if (curr_pwr > thresh_pwr) {
-				gainctrl_dirn = NPHY_RXCAL_GAIN_DOWN;
-				prev_gaintbl_index = curr_gaintbl_index;
-				curr_gaintbl_index--;
-			} else {
-				gainctrl_dirn = NPHY_RXCAL_GAIN_UP;
-				prev_gaintbl_index = curr_gaintbl_index;
-				curr_gaintbl_index++;
-			}
-			break;
+		if (NREV_GE(pi->pubpi.phy_rev, 6)) {
+			mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x2a3 :
+				    0x2a4, (0x1 << 13), (1) << 13);
 
-		case NPHY_RXCAL_GAIN_UP:
-			if (curr_pwr > thresh_pwr) {
-				gainctrl_done = true;
-				optim_pwr = prev_pwr;
-				optim_gaintbl_index = prev_gaintbl_index;
-			} else {
-				prev_gaintbl_index = curr_gaintbl_index;
-				curr_gaintbl_index++;
-			}
-			break;
+			mod_phy_reg(pi, (phy_a7 == PHY_CORE_0) ? 0x2a3 :
+				    0x2a4, (0x1 << 13), (0) << 13);
 
-		case NPHY_RXCAL_GAIN_DOWN:
-			if (curr_pwr > thresh_pwr) {
-				prev_gaintbl_index = curr_gaintbl_index;
-				curr_gaintbl_index--;
-			} else {
-				gainctrl_done = true;
-				optim_pwr = curr_pwr;
-				optim_gaintbl_index = curr_gaintbl_index;
-			}
-			break;
+			write_phy_reg(pi, 0x2a1, 0x20);
+			write_phy_reg(pi, 0x2a2, 0x60);
 
-		default:
-			break;
-		}
+			mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x2a3 :
+				    0x2a4, (0xf << 4), (9) << 4);
 
-		if ((curr_gaintbl_index < 0) ||
-		    (curr_gaintbl_index > NPHY_IPA_RXCAL_MAXGAININDEX)) {
-			gainctrl_done = true;
-			optim_pwr = curr_pwr;
-			optim_gaintbl_index = prev_gaintbl_index;
+			mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x2a3 :
+				    0x2a4, (0xf << 8), (9) << 8);
+
+			mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x2a3 :
+				    0x2a4, (0xf << 0), (0x2) << 0);
+
+			write_phy_reg(pi, 0x2e5, 0x20);
 		} else {
-			prev_pwr = curr_pwr;
-		}
+			mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x2a3 :
+				    0x2a4, (0x1 << 11), (1) << 11);
 
-		wlc_phy_stopplayback_nphy(pi);
-	} while (!gainctrl_done);
+			mod_phy_reg(pi, (phy_a7 == PHY_CORE_0) ? 0x2a3 :
+				    0x2a4, (0x1 << 11), (0) << 11);
 
-	hpvga = nphy_rxcal_gaintbl[optim_gaintbl_index].hpvga;
-	lpf_biq1 = nphy_rxcal_gaintbl[optim_gaintbl_index].lpf_biq1;
-	lpf_biq0 = nphy_rxcal_gaintbl[optim_gaintbl_index].lpf_biq0;
-	lna2 = nphy_rxcal_gaintbl[optim_gaintbl_index].lna2;
-	lna1 = nphy_rxcal_gaintbl[optim_gaintbl_index].lna1;
-	txpwrindex = nphy_rxcal_gaintbl[optim_gaintbl_index].txpwrindex;
+			write_phy_reg(pi, 0x2a1, 0x80);
+			write_phy_reg(pi, 0x2a2, 0x600);
 
-	actual_log2_pwr = wlc_phy_nbits(optim_pwr);
-	delta_pwr = desired_log2_pwr - actual_log2_pwr;
+			mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x2a3 :
+				    0x2a4, (0x7 << 4), (0) << 4);
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-		fine_gain_idx = (int)lpf_biq1 + delta_pwr;
+			mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x2a3 :
+				    0x2a4, (0x7 << 8), (0) << 8);
 
-		if (fine_gain_idx + (int)lpf_biq0 > 10)
-			lpf_biq1 = 10 - lpf_biq0;
-		else
-			lpf_biq1 = (u16) max(fine_gain_idx, 0);
+			mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x2a3 :
+				    0x2a4, (0x7 << 0), (0x3) << 0);
 
-		wlc_phy_rfctrl_override_1tomany_nphy(
-			pi,
-			NPHY_REV7_RfctrlOverride_cmd_rxgain,
-			((lpf_biq1 << 12) |
-			 (lpf_biq0 << 8) |
-			 (mix_tia_gain << 4) |
-			 (lna2 << 2) | lna1), 0x3,
-			0);
-	} else {
-		hpvga = (u16) max(min(((int)hpvga) + delta_pwr, 10), 0);
-		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 12),
-					     ((hpvga << 12) |
-					      (lpf_biq1 << 10) |
-					      (lpf_biq0 << 8) |
-					      (mix_tia_gain << 4) |
-					      (lna2 << 2) |
-					      lna1), 0x3, 0);
-	}
+			mod_phy_reg(pi, 0x2a0, (0x3f << 8), (0x20) << 8);
 
-	if (rxgain != NULL) {
-		*rxgain++ = lna1;
-		*rxgain++ = lna2;
-		*rxgain++ = mix_tia_gain;
-		*rxgain++ = lpf_biq0;
-		*rxgain++ = lpf_biq1;
-		*rxgain = hpvga;
-	}
+		}
 
-	wlc_phy_rx_iq_coeffs_nphy(pi, 1, &save_comp);
-}
+		mod_phy_reg(pi, 0x2a0, (0x3f << 0), (phy_a3) << 0);
 
-static void
-wlc_phy_rxcal_gainctrl_nphy(struct brcms_phy *pi, u8 rx_core, u16 *rxgain,
-			    u8 cal_type)
-{
-	wlc_phy_rxcal_gainctrl_nphy_rev5(pi, rx_core, rxgain, cal_type);
+		mod_phy_reg(pi, 0x29f, (0x3f << 0), (phy_a1) << 0);
+
+		mod_phy_reg(pi, 0x29f, (0x3f << 8), (phy_a2) << 8);
+
+		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 3), 1, 0x3, 0);
+
+		write_phy_reg(pi, 0x2be, 1);
+		SPINWAIT(read_phy_reg(pi, 0x2be), 10 * 1000 * 1000);
+
+		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 3), 0, 0x3, 0);
+
+		wlc_phy_table_write_nphy(pi,
+					 (core ==
+					  PHY_CORE_0) ? NPHY_TBL_ID_EPSILONTBL0
+					 : NPHY_TBL_ID_EPSILONTBL1, 1, phy_a3,
+					 32, &phy_a8);
+
+		if (cal_mode != CAL_GCTRL)
+			wlc_phy_a1_nphy(pi, core, 5, 0, 40);
+	}
 }
 
-static u8
-wlc_phy_rc_sweep_nphy(struct brcms_phy *pi, u8 core_idx, u8 loopback_type)
+static u8 wlc_phy_a3_nphy(struct brcms_phy *pi, u8 start_gain, u8 core)
 {
-	u32 target_bws[2] = { 9500, 21000 };
-	u32 ref_tones[2] = { 3000, 6000 };
-	u32 target_bw, ref_tone;
+	int phy_a1;
+	int phy_a2;
+	bool phy_a3;
+	struct nphy_ipa_txcalgains phy_a4;
+	bool phy_a5 = false;
+	bool phy_a6 = true;
+	s32 phy_a7, phy_a8;
+	u32 phy_a9;
+	int phy_a10;
+	bool phy_a11 = false;
+	int phy_a12;
+	u8 phy_a13 = 0;
+	u8 phy_a14;
+	u8 *phy_a15 = NULL;
 
-	u32 target_pwr_ratios[2] = { 28606, 18468 };
-	u32 target_pwr_ratio, pwr_ratio, last_pwr_ratio = 0;
+	phy_a4.useindex = true;
+	phy_a12 = start_gain;
 
-	u16 start_rccal_ovr_val = 128;
-	u16 txlpf_rccal_lpc_ovr_val = 128;
-	u16 rxlpf_rccal_hpc_ovr_val = 159;
+	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 
-	u16 orig_txlpf_rccal_lpc_ovr_val;
-	u16 orig_rxlpf_rccal_hpc_ovr_val;
-	u16 radio_addr_offset_rx;
-	u16 radio_addr_offset_tx;
-	u16 orig_dcBypass;
-	u16 orig_RxStrnFilt40Num[6];
-	u16 orig_RxStrnFilt40Den[4];
-	u16 orig_rfctrloverride[2];
-	u16 orig_rfctrlauxreg[2];
-	u16 orig_rfctrlrssiothers;
-	u16 tx_lpf_bw = 4;
+		phy_a2 = 20;
+		phy_a1 = 1;
 
-	u16 rx_lpf_bw, rx_lpf_bws[2] = { 2, 4 };
-	u16 lpf_hpc = 7, hpvga_hpc = 7;
+		if (CHSPEC_IS2G(pi->radio_chanspec)) {
+			if (pi->pubpi.radiorev == 5) {
 
-	s8 rccal_stepsize;
-	u16 rccal_val, last_rccal_val = 0, best_rccal_val = 0;
-	u32 ref_iq_vals = 0, target_iq_vals = 0;
-	u16 num_samps, log_num_samps = 10;
-	struct phy_iq_est est[PHY_CORE_MAX];
+				phy_a15 = pad_gain_codes_used_2057rev5;
+				phy_a13 =
+					sizeof(pad_gain_codes_used_2057rev5) /
+					sizeof(pad_gain_codes_used_2057rev5
+						[0]) - 1;
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7))
-		return 0;
+			} else if ((pi->pubpi.radiorev == 7)
+				   || (pi->pubpi.radiorev == 8)) {
 
-	num_samps = (1 << log_num_samps);
+				phy_a15 = pad_gain_codes_used_2057rev7;
+				phy_a13 =
+					sizeof(pad_gain_codes_used_2057rev7) /
+					sizeof(pad_gain_codes_used_2057rev7
+						[0]) - 1;
 
-	if (CHSPEC_IS40(pi->radio_chanspec)) {
-		target_bw = target_bws[1];
-		target_pwr_ratio = target_pwr_ratios[1];
-		ref_tone = ref_tones[1];
-		rx_lpf_bw = rx_lpf_bws[1];
-	} else {
-		target_bw = target_bws[0];
-		target_pwr_ratio = target_pwr_ratios[0];
-		ref_tone = ref_tones[0];
-		rx_lpf_bw = rx_lpf_bws[0];
-	}
+			} else {
 
-	if (core_idx == 0) {
-		radio_addr_offset_rx = RADIO_2056_RX0;
-		radio_addr_offset_tx =
-			(loopback_type == 0) ? RADIO_2056_TX0 : RADIO_2056_TX1;
-	} else {
-		radio_addr_offset_rx = RADIO_2056_RX1;
-		radio_addr_offset_tx =
-			(loopback_type == 0) ? RADIO_2056_TX1 : RADIO_2056_TX0;
-	}
+				phy_a15 = pad_all_gain_codes_2057;
+				phy_a13 = sizeof(pad_all_gain_codes_2057) /
+					  sizeof(pad_all_gain_codes_2057[0]) -
+					  1;
+			}
 
-	orig_txlpf_rccal_lpc_ovr_val =
-		read_radio_reg(pi,
-			       (RADIO_2056_TX_TXLPF_RCCAL |
-				radio_addr_offset_tx));
-	orig_rxlpf_rccal_hpc_ovr_val =
-		read_radio_reg(pi,
-			       (RADIO_2056_RX_RXLPF_RCCAL_HPC |
-				radio_addr_offset_rx));
+		} else {
 
-	orig_dcBypass = ((read_phy_reg(pi, 0x48) >> 8) & 1);
+			phy_a15 = pga_all_gain_codes_2057;
+			phy_a13 = sizeof(pga_all_gain_codes_2057) /
+				  sizeof(pga_all_gain_codes_2057[0]) - 1;
+		}
 
-	orig_RxStrnFilt40Num[0] = read_phy_reg(pi, 0x267);
-	orig_RxStrnFilt40Num[1] = read_phy_reg(pi, 0x268);
-	orig_RxStrnFilt40Num[2] = read_phy_reg(pi, 0x269);
-	orig_RxStrnFilt40Den[0] = read_phy_reg(pi, 0x26a);
-	orig_RxStrnFilt40Den[1] = read_phy_reg(pi, 0x26b);
-	orig_RxStrnFilt40Num[3] = read_phy_reg(pi, 0x26c);
-	orig_RxStrnFilt40Num[4] = read_phy_reg(pi, 0x26d);
-	orig_RxStrnFilt40Num[5] = read_phy_reg(pi, 0x26e);
-	orig_RxStrnFilt40Den[2] = read_phy_reg(pi, 0x26f);
-	orig_RxStrnFilt40Den[3] = read_phy_reg(pi, 0x270);
+		phy_a14 = 0;
 
-	orig_rfctrloverride[0] = read_phy_reg(pi, 0xe7);
-	orig_rfctrloverride[1] = read_phy_reg(pi, 0xec);
-	orig_rfctrlauxreg[0] = read_phy_reg(pi, 0xf8);
-	orig_rfctrlauxreg[1] = read_phy_reg(pi, 0xfa);
-	orig_rfctrlrssiothers = read_phy_reg(pi, (core_idx == 0) ? 0x7a : 0x7d);
+		for (phy_a10 = 0; phy_a10 < phy_a2; phy_a10++) {
+			if (CHSPEC_IS2G(pi->radio_chanspec))
+				phy_a4.gains.pad[core] =
+					(u16) phy_a15[phy_a12];
+			else
+				phy_a4.gains.pga[core] =
+					(u16) phy_a15[phy_a12];
 
-	write_radio_reg(pi, (RADIO_2056_TX_TXLPF_RCCAL | radio_addr_offset_tx),
-			txlpf_rccal_lpc_ovr_val);
+			wlc_phy_a2_nphy(pi, &phy_a4, CAL_GCTRL, core);
 
-	write_radio_reg(pi,
-			(RADIO_2056_RX_RXLPF_RCCAL_HPC | radio_addr_offset_rx),
-			rxlpf_rccal_hpc_ovr_val);
+			wlc_phy_table_read_nphy(pi,
+						(core ==
+						 PHY_CORE_0 ?
+						 NPHY_TBL_ID_EPSILONTBL0 :
+						 NPHY_TBL_ID_EPSILONTBL1), 1,
+						63, 32, &phy_a9);
 
-	mod_phy_reg(pi, 0x48, (0x1 << 8), (0x1 << 8));
+			wlc_phy_papd_decode_epsilon(phy_a9, &phy_a7, &phy_a8);
 
-	write_phy_reg(pi, 0x267, 0x02d4);
-	write_phy_reg(pi, 0x268, 0x0000);
-	write_phy_reg(pi, 0x269, 0x0000);
-	write_phy_reg(pi, 0x26a, 0x0000);
-	write_phy_reg(pi, 0x26b, 0x0000);
-	write_phy_reg(pi, 0x26c, 0x02d4);
-	write_phy_reg(pi, 0x26d, 0x0000);
-	write_phy_reg(pi, 0x26e, 0x0000);
-	write_phy_reg(pi, 0x26f, 0x0000);
-	write_phy_reg(pi, 0x270, 0x0000);
+			phy_a3 = ((phy_a7 == 4095) || (phy_a7 == -4096) ||
+				  (phy_a8 == 4095) || (phy_a8 == -4096));
 
-	or_phy_reg(pi, (core_idx == 0) ? 0xe7 : 0xec, (0x1 << 8));
-	or_phy_reg(pi, (core_idx == 0) ? 0xec : 0xe7, (0x1 << 15));
-	or_phy_reg(pi, (core_idx == 0) ? 0xe7 : 0xec, (0x1 << 9));
-	or_phy_reg(pi, (core_idx == 0) ? 0xe7 : 0xec, (0x1 << 10));
+			if (!phy_a6 && (phy_a3 != phy_a5)) {
+				if (!phy_a3)
+					phy_a12 -= (u8) phy_a1;
 
-	mod_phy_reg(pi, (core_idx == 0) ? 0xfa : 0xf8,
-		    (0x7 << 10), (tx_lpf_bw << 10));
-	mod_phy_reg(pi, (core_idx == 0) ? 0xf8 : 0xfa,
-		    (0x7 << 0), (hpvga_hpc << 0));
-	mod_phy_reg(pi, (core_idx == 0) ? 0xf8 : 0xfa,
-		    (0x7 << 4), (lpf_hpc << 4));
-	mod_phy_reg(pi, (core_idx == 0) ? 0x7a : 0x7d,
-		    (0x7 << 8), (rx_lpf_bw << 8));
+				phy_a11 = true;
+				break;
+			}
 
-	rccal_stepsize = 16;
-	rccal_val = start_rccal_ovr_val + rccal_stepsize;
+			if (phy_a3)
+				phy_a12 += (u8) phy_a1;
+			else
+				phy_a12 -= (u8) phy_a1;
 
-	while (rccal_stepsize >= 0) {
-		write_radio_reg(pi,
-				(RADIO_2056_RX_RXLPF_RCCAL_LPC |
-				 radio_addr_offset_rx), rccal_val);
+			if ((phy_a12 < phy_a14) || (phy_a12 > phy_a13)) {
+				if (phy_a12 < phy_a14)
+					phy_a12 = phy_a14;
+				else
+					phy_a12 = phy_a13;
 
-		if (rccal_stepsize == 16) {
+				phy_a11 = true;
+				break;
+			}
 
-			wlc_phy_tx_tone_nphy(pi, ref_tone, NPHY_RXCAL_TONEAMP,
-					     0, 1, false);
-			udelay(2);
+			phy_a6 = false;
+			phy_a5 = phy_a3;
+		}
 
-			wlc_phy_rx_iq_est_nphy(pi, est, num_samps, 32, 0);
+	} else {
+		phy_a2 = 10;
+		phy_a1 = 8;
+		for (phy_a10 = 0; phy_a10 < phy_a2; phy_a10++) {
+			phy_a4.index = (u8) phy_a12;
+			wlc_phy_a2_nphy(pi, &phy_a4, CAL_GCTRL, core);
 
-			if (core_idx == 0)
-				ref_iq_vals =
-					max_t(u32, (est[0].i_pwr +
-						    est[0].q_pwr) >>
-					      (log_num_samps + 1),
-					      1);
-			else
-				ref_iq_vals =
-					max_t(u32, (est[1].i_pwr +
-						    est[1].q_pwr) >>
-					      (log_num_samps + 1),
-					      1);
+			wlc_phy_table_read_nphy(pi,
+						(core ==
+						 PHY_CORE_0 ?
+						 NPHY_TBL_ID_EPSILONTBL0 :
+						 NPHY_TBL_ID_EPSILONTBL1), 1,
+						63, 32, &phy_a9);
 
-			wlc_phy_tx_tone_nphy(pi, target_bw, NPHY_RXCAL_TONEAMP,
-					     0, 1, false);
-			udelay(2);
-		}
+			wlc_phy_papd_decode_epsilon(phy_a9, &phy_a7, &phy_a8);
 
-		wlc_phy_rx_iq_est_nphy(pi, est, num_samps, 32, 0);
+			phy_a3 = ((phy_a7 == 4095) || (phy_a7 == -4096) ||
+				  (phy_a8 == 4095) || (phy_a8 == -4096));
 
-		if (core_idx == 0)
-			target_iq_vals = (est[0].i_pwr + est[0].q_pwr) >>
-					 (log_num_samps + 1);
-		else
-			target_iq_vals =
-				(est[1].i_pwr +
-				 est[1].q_pwr) >> (log_num_samps + 1);
+			if (!phy_a6 && (phy_a3 != phy_a5)) {
+				if (!phy_a3)
+					phy_a12 -= (u8) phy_a1;
 
-		pwr_ratio = (uint) ((target_iq_vals << 16) / ref_iq_vals);
+				phy_a11 = true;
+				break;
+			}
 
-		if (rccal_stepsize == 0)
-			rccal_stepsize--;
-		else if (rccal_stepsize == 1) {
-			last_rccal_val = rccal_val;
-			rccal_val += (pwr_ratio > target_pwr_ratio) ? 1 : -1;
-			last_pwr_ratio = pwr_ratio;
-			rccal_stepsize--;
-		} else {
-			rccal_stepsize = (rccal_stepsize >> 1);
-			rccal_val += ((pwr_ratio > target_pwr_ratio) ?
-				      rccal_stepsize : (-rccal_stepsize));
-		}
+			if (phy_a3)
+				phy_a12 += (u8) phy_a1;
+			else
+				phy_a12 -= (u8) phy_a1;
 
-		if (rccal_stepsize == -1) {
-			best_rccal_val =
-				(ABS((int)last_pwr_ratio -
-				     (int)target_pwr_ratio) <
-				 ABS((int)pwr_ratio -
-				     (int)target_pwr_ratio)) ? last_rccal_val :
-				rccal_val;
+			if ((phy_a12 < 0) || (phy_a12 > 127)) {
+				if (phy_a12 < 0)
+					phy_a12 = 0;
+				else
+					phy_a12 = 127;
 
-			if (CHSPEC_IS40(pi->radio_chanspec)) {
-				if ((best_rccal_val > 140)
-				    || (best_rccal_val < 135))
-					best_rccal_val = 138;
-			} else {
-				if ((best_rccal_val > 142)
-				    || (best_rccal_val < 137))
-					best_rccal_val = 140;
+				phy_a11 = true;
+				break;
 			}
 
-			write_radio_reg(pi,
-					(RADIO_2056_RX_RXLPF_RCCAL_LPC |
-					 radio_addr_offset_rx), best_rccal_val);
+			phy_a6 = false;
+			phy_a5 = phy_a3;
 		}
+
 	}
 
-	wlc_phy_stopplayback_nphy(pi);
+	if (NREV_GE(pi->pubpi.phy_rev, 7))
+		return (u8) phy_a15[phy_a12];
+	else
+		return (u8) phy_a12;
 
-	write_radio_reg(pi, (RADIO_2056_TX_TXLPF_RCCAL | radio_addr_offset_tx),
-			orig_txlpf_rccal_lpc_ovr_val);
-	write_radio_reg(pi,
-			(RADIO_2056_RX_RXLPF_RCCAL_HPC | radio_addr_offset_rx),
-			orig_rxlpf_rccal_hpc_ovr_val);
+}
 
-	mod_phy_reg(pi, 0x48, (0x1 << 8), (orig_dcBypass << 8));
+static void wlc_phy_a4(struct brcms_phy *pi, bool full_cal)
+{
+	struct nphy_ipa_txcalgains phy_b1[2];
+	struct nphy_papd_restore_state phy_b2;
+	bool phy_b3;
+	u8 phy_b4;
+	u8 phy_b5;
+	s16 phy_b6, phy_b7, phy_b8;
+	u16 phy_b9;
+	s16 phy_b10, phy_b11, phy_b12;
 
-	write_phy_reg(pi, 0x267, orig_RxStrnFilt40Num[0]);
-	write_phy_reg(pi, 0x268, orig_RxStrnFilt40Num[1]);
-	write_phy_reg(pi, 0x269, orig_RxStrnFilt40Num[2]);
-	write_phy_reg(pi, 0x26a, orig_RxStrnFilt40Den[0]);
-	write_phy_reg(pi, 0x26b, orig_RxStrnFilt40Den[1]);
-	write_phy_reg(pi, 0x26c, orig_RxStrnFilt40Num[3]);
-	write_phy_reg(pi, 0x26d, orig_RxStrnFilt40Num[4]);
-	write_phy_reg(pi, 0x26e, orig_RxStrnFilt40Num[5]);
-	write_phy_reg(pi, 0x26f, orig_RxStrnFilt40Den[2]);
-	write_phy_reg(pi, 0x270, orig_RxStrnFilt40Den[3]);
+	phy_b11 = 0;
+	phy_b12 = 0;
+	phy_b7 = 0;
+	phy_b8 = 0;
+	phy_b6 = 0;
 
-	write_phy_reg(pi, 0xe7, orig_rfctrloverride[0]);
-	write_phy_reg(pi, 0xec, orig_rfctrloverride[1]);
-	write_phy_reg(pi, 0xf8, orig_rfctrlauxreg[0]);
-	write_phy_reg(pi, 0xfa, orig_rfctrlauxreg[1]);
-	write_phy_reg(pi, (core_idx == 0) ? 0x7a : 0x7d, orig_rfctrlrssiothers);
+	if (pi->nphy_papd_skip == 1)
+		return;
 
-	pi->nphy_anarxlpf_adjusted = false;
+	phy_b3 = (0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
+	if (!phy_b3)
+		wlapi_suspend_mac_and_wait(pi->sh->physhim);
 
-	return best_rccal_val - 0x80;
-}
+	wlc_phy_stay_in_carriersearch_nphy(pi, true);
 
-#define WAIT_FOR_SCOPE  4000
-static int wlc_phy_cal_rxiq_nphy_rev3(struct brcms_phy *pi,
-				      struct nphy_txgains target_gain,
-				      u8 cal_type, bool debug)
-{
-	u16 orig_BBConfig;
-	u8 core_no, rx_core;
-	u8 best_rccal[2];
-	u16 gain_save[2];
-	u16 cal_gain[2];
-	struct nphy_iqcal_params cal_params[2];
-	u8 rxcore_state;
-	s8 rxlpf_rccal_hpc, txlpf_rccal_lpc;
-	s8 txlpf_idac;
-	bool phyhang_avoid_state = false;
-	bool skip_rxiqcal = false;
+	pi->nphy_force_papd_cal = false;
 
-	orig_BBConfig = read_phy_reg(pi, 0x01);
-	mod_phy_reg(pi, 0x01, (0x1 << 15), 0);
+	for (phy_b5 = 0; phy_b5 < pi->pubpi.phy_corenum; phy_b5++)
+		pi->nphy_papd_tx_gain_at_last_cal[phy_b5] =
+			wlc_phy_txpwr_idx_cur_get_nphy(pi, phy_b5);
 
-	wlc_phy_stay_in_carriersearch_nphy(pi, true);
+	pi->nphy_papd_last_cal = pi->sh->now;
+	pi->nphy_papd_recal_counter++;
 
-	if (NREV_GE(pi->pubpi.phy_rev, 4)) {
-		phyhang_avoid_state = pi->phyhang_avoid;
-		pi->phyhang_avoid = false;
-	}
+	phy_b4 = pi->nphy_txpwrctrl;
+	wlc_phy_txpwrctrl_enable_nphy(pi, PHY_TPC_HW_OFF);
 
-	wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x110, 16, gain_save);
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_SCALARTBL0, 64, 0, 32,
+				 nphy_papd_scaltbl);
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_SCALARTBL1, 64, 0, 32,
+				 nphy_papd_scaltbl);
 
-	for (core_no = 0; core_no <= 1; core_no++) {
-		wlc_phy_iqcal_gainparams_nphy(pi, core_no, target_gain,
-					      &cal_params[core_no]);
-		cal_gain[core_no] = cal_params[core_no].cal_gain;
-	}
+	phy_b9 = read_phy_reg(pi, 0x01);
+	mod_phy_reg(pi, 0x01, (0x1 << 15), 0);
 
-	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x110, 16, cal_gain);
+	for (phy_b5 = 0; phy_b5 < pi->pubpi.phy_corenum; phy_b5++) {
+		s32 i, val = 0;
+		for (i = 0; i < 64; i++)
+			wlc_phy_table_write_nphy(pi,
+						 ((phy_b5 ==
+						   PHY_CORE_0) ?
+						  NPHY_TBL_ID_EPSILONTBL0 :
+						  NPHY_TBL_ID_EPSILONTBL1), 1,
+						 i, 32, &val);
+	}
 
-	rxcore_state = wlc_phy_rxcore_getstate_nphy(
-		(struct brcms_phy_pub *) pi);
+	wlc_phy_ipa_restore_tx_digi_filts_nphy(pi);
 
-	for (rx_core = 0; rx_core < pi->pubpi.phy_corenum; rx_core++) {
+	phy_b2.mm = wlc_phy_ipa_get_bbmult_nphy(pi);
+	for (phy_b5 = 0; phy_b5 < pi->pubpi.phy_corenum; phy_b5++) {
+		wlc_phy_papd_cal_setup_nphy(pi, &phy_b2, phy_b5);
 
-		skip_rxiqcal =
-			((rxcore_state & (1 << rx_core)) == 0) ? true : false;
+		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+			if (CHSPEC_IS2G(pi->radio_chanspec)) {
+				if ((pi->pubpi.radiorev == 3)
+				    || (pi->pubpi.radiorev == 4)
+				    || (pi->pubpi.radiorev == 6)) {
+					pi->nphy_papd_cal_gain_index[phy_b5] =
+						23;
+				} else if (pi->pubpi.radiorev == 5) {
+					pi->nphy_papd_cal_gain_index[phy_b5] =
+						0;
+					pi->nphy_papd_cal_gain_index[phy_b5] =
+						wlc_phy_a3_nphy(
+							pi,
+							pi->
+							nphy_papd_cal_gain_index
+							[phy_b5],
+							phy_b5);
 
-		wlc_phy_rxcal_physetup_nphy(pi, rx_core);
+				} else if ((pi->pubpi.radiorev == 7)
+					   || (pi->pubpi.radiorev == 8)) {
 
-		wlc_phy_rxcal_radio_setup_nphy(pi, rx_core);
+					pi->nphy_papd_cal_gain_index[phy_b5] =
+						0;
+					pi->nphy_papd_cal_gain_index[phy_b5] =
+						wlc_phy_a3_nphy(
+							pi,
+							pi->
+							nphy_papd_cal_gain_index
+							[phy_b5],
+							phy_b5);
 
-		if ((!skip_rxiqcal) && ((cal_type == 0) || (cal_type == 2))) {
+				}
 
-			wlc_phy_rxcal_gainctrl_nphy(pi, rx_core, NULL, 0);
+				phy_b1[phy_b5].gains.pad[phy_b5] =
+					pi->nphy_papd_cal_gain_index[phy_b5];
 
-			wlc_phy_tx_tone_nphy(pi,
-					     (CHSPEC_IS40(
-						      pi->radio_chanspec)) ?
-					     NPHY_RXCAL_TONEFREQ_40MHz :
-					     NPHY_RXCAL_TONEFREQ_20MHz,
-					     NPHY_RXCAL_TONEAMP, 0, cal_type,
-					     false);
+			} else {
+				pi->nphy_papd_cal_gain_index[phy_b5] = 0;
+				pi->nphy_papd_cal_gain_index[phy_b5] =
+					wlc_phy_a3_nphy(
+						pi,
+						pi->
+						nphy_papd_cal_gain_index
+						[phy_b5], phy_b5);
+				phy_b1[phy_b5].gains.pga[phy_b5] =
+					pi->nphy_papd_cal_gain_index[phy_b5];
+			}
+		} else {
+			phy_b1[phy_b5].useindex = true;
+			phy_b1[phy_b5].index = 16;
+			phy_b1[phy_b5].index =
+				wlc_phy_a3_nphy(pi, phy_b1[phy_b5].index,
+						phy_b5);
 
-			if (debug)
-				mdelay(WAIT_FOR_SCOPE);
+			pi->nphy_papd_cal_gain_index[phy_b5] =
+				15 - ((phy_b1[phy_b5].index) >> 3);
+		}
 
-			wlc_phy_calc_rx_iq_comp_nphy(pi, rx_core + 1);
-			wlc_phy_stopplayback_nphy(pi);
+		switch (pi->nphy_papd_cal_type) {
+		case 0:
+			wlc_phy_a2_nphy(pi, &phy_b1[phy_b5], CAL_FULL, phy_b5);
+			break;
+		case 1:
+			wlc_phy_a2_nphy(pi, &phy_b1[phy_b5], CAL_SOFT, phy_b5);
+			break;
 		}
 
-		if (((cal_type == 1) || (cal_type == 2))
-		    && NREV_LT(pi->pubpi.phy_rev, 7)) {
+		if (NREV_GE(pi->pubpi.phy_rev, 7))
+			wlc_phy_papd_cal_cleanup_nphy(pi, &phy_b2);
+	}
 
-			if (rx_core == PHY_CORE_1) {
+	if (NREV_LT(pi->pubpi.phy_rev, 7))
+		wlc_phy_papd_cal_cleanup_nphy(pi, &phy_b2);
 
-				if (rxcore_state == 1)
-					wlc_phy_rxcore_setstate_nphy(
-						(struct brcms_phy_pub *) pi, 3);
+	for (phy_b5 = 0; phy_b5 < pi->pubpi.phy_corenum; phy_b5++) {
+		int eps_offset = 0;
 
-				wlc_phy_rxcal_gainctrl_nphy(pi, rx_core, NULL,
-							    1);
+		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+			if (CHSPEC_IS2G(pi->radio_chanspec)) {
+				if (pi->pubpi.radiorev == 3)
+					eps_offset = -2;
+				else if (pi->pubpi.radiorev == 5)
+					eps_offset = 3;
+				else
+					eps_offset = -1;
+			} else {
+				eps_offset = 2;
+			}
 
-				best_rccal[rx_core] =
-					wlc_phy_rc_sweep_nphy(pi, rx_core, 1);
-				pi->nphy_rccal_value = best_rccal[rx_core];
+			if (CHSPEC_IS2G(pi->radio_chanspec)) {
+				phy_b8 = phy_b1[phy_b5].gains.pad[phy_b5];
+				phy_b10 = 0;
+				if ((pi->pubpi.radiorev == 3) ||
+				    (pi->pubpi.radiorev == 4) ||
+				    (pi->pubpi.radiorev == 6)) {
+					phy_b12 = -(
+					    nphy_papd_padgain_dlt_2g_2057rev3n4
+							     [phy_b8] + 1) / 2;
+					phy_b10 = -1;
+				} else if (pi->pubpi.radiorev == 5) {
+					phy_b12 = -(
+					    nphy_papd_padgain_dlt_2g_2057rev5
+							     [phy_b8] + 1) / 2;
+				} else if ((pi->pubpi.radiorev == 7) ||
+					   (pi->pubpi.radiorev == 8)) {
+					phy_b12 = -(
+					    nphy_papd_padgain_dlt_2g_2057rev7
+							     [phy_b8] + 1) / 2;
+				}
+			} else {
+				phy_b7 = phy_b1[phy_b5].gains.pga[phy_b5];
+				if ((pi->pubpi.radiorev == 3) ||
+				    (pi->pubpi.radiorev == 4) ||
+				    (pi->pubpi.radiorev == 6))
+					phy_b11 =
+						-(nphy_papd_pgagain_dlt_5g_2057
+						  [phy_b7]
+						  + 1) / 2;
+				else if ((pi->pubpi.radiorev == 7)
+					 || (pi->pubpi.radiorev == 8))
+					phy_b11 = -(
+					      nphy_papd_pgagain_dlt_5g_2057rev7
+							     [phy_b7] + 1) / 2;
 
-				if (rxcore_state == 1)
-					wlc_phy_rxcore_setstate_nphy(
-						(struct brcms_phy_pub *) pi,
-						rxcore_state);
+				phy_b10 = -9;
 			}
-		}
-
-		wlc_phy_rxcal_radio_cleanup_nphy(pi, rx_core);
 
-		wlc_phy_rxcal_phycleanup_nphy(pi, rx_core);
-		wlc_phy_force_rfseq_nphy(pi, NPHY_RFSEQ_RESET2RX);
-	}
+			if (CHSPEC_IS2G(pi->radio_chanspec))
+				phy_b6 =
+					-60 + 27 + eps_offset + phy_b12 +
+					phy_b10;
+			else
+				phy_b6 =
+					-60 + 27 + eps_offset + phy_b11 +
+					phy_b10;
 
-	if ((cal_type == 1) || (cal_type == 2)) {
+			mod_phy_reg(pi, (phy_b5 == PHY_CORE_0) ? 0x298 :
+				    0x29c, (0x1ff << 7), (phy_b6) << 7);
 
-		best_rccal[0] = best_rccal[1];
-		write_radio_reg(pi,
-				(RADIO_2056_RX_RXLPF_RCCAL_LPC |
-				 RADIO_2056_RX0), (best_rccal[0] | 0x80));
+			pi->nphy_papd_epsilon_offset[phy_b5] = phy_b6;
+		} else {
+			if (NREV_LT(pi->pubpi.phy_rev, 5))
+				eps_offset = 4;
+			else
+				eps_offset = 2;
 
-		for (rx_core = 0; rx_core < pi->pubpi.phy_corenum; rx_core++) {
-			rxlpf_rccal_hpc =
-				(((int)best_rccal[rx_core] - 12) >> 1) + 10;
-			txlpf_rccal_lpc = ((int)best_rccal[rx_core] - 12) + 10;
+			phy_b7 = 15 - ((phy_b1[phy_b5].index) >> 3);
 
-			if (PHY_IPA(pi)) {
-				txlpf_rccal_lpc += IS40MHZ(pi) ? 24 : 12;
-				txlpf_idac = IS40MHZ(pi) ? 0x0e : 0x13;
-				WRITE_RADIO_REG2(pi, RADIO_2056, TX, rx_core,
-						 TXLPF_IDAC_4, txlpf_idac);
+			if (CHSPEC_IS2G(pi->radio_chanspec)) {
+				phy_b11 =
+					-(nphy_papd_pga_gain_delta_ipa_2g[
+						  phy_b7] +
+					  1) / 2;
+				phy_b10 = 0;
+			} else {
+				phy_b11 =
+					-(nphy_papd_pga_gain_delta_ipa_5g[
+						  phy_b7] +
+					  1) / 2;
+				phy_b10 = -9;
 			}
 
-			rxlpf_rccal_hpc = max(min_t(u8, rxlpf_rccal_hpc, 31),
-					      0);
-			txlpf_rccal_lpc = max(min_t(u8, txlpf_rccal_lpc, 31),
-					      0);
+			phy_b6 = -60 + 27 + eps_offset + phy_b11 + phy_b10;
 
-			write_radio_reg(pi, (RADIO_2056_RX_RXLPF_RCCAL_HPC |
-					     ((rx_core ==
-					       PHY_CORE_0) ? RADIO_2056_RX0 :
-					      RADIO_2056_RX1)),
-					(rxlpf_rccal_hpc | 0x80));
+			mod_phy_reg(pi, (phy_b5 == PHY_CORE_0) ? 0x298 :
+				    0x29c, (0x1ff << 7), (phy_b6) << 7);
 
-			write_radio_reg(pi, (RADIO_2056_TX_TXLPF_RCCAL |
-					     ((rx_core ==
-					       PHY_CORE_0) ? RADIO_2056_TX0 :
-					      RADIO_2056_TX1)),
-					(txlpf_rccal_lpc | 0x80));
+			pi->nphy_papd_epsilon_offset[phy_b5] = phy_b6;
 		}
 	}
 
-	write_phy_reg(pi, 0x01, orig_BBConfig);
+	mod_phy_reg(pi, (0 == PHY_CORE_0) ? 0x297 :
+		    0x29b, (0x1 << 0), (NPHY_PAPD_COMP_ON) << 0);
 
-	wlc_phy_resetcca_nphy(pi);
+	mod_phy_reg(pi, (1 == PHY_CORE_0) ? 0x297 :
+		    0x29b, (0x1 << 0), (NPHY_PAPD_COMP_ON) << 0);
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7))
-		wlc_phy_rfctrl_override_1tomany_nphy(
-			pi,
-			NPHY_REV7_RfctrlOverride_cmd_rxgain,
-			0, 0x3, 1);
-	else
-		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 12), 0, 0x3, 1);
+	if (NREV_GE(pi->pubpi.phy_rev, 6)) {
+		mod_phy_reg(pi, (0 == PHY_CORE_0) ? 0x2a3 :
+			    0x2a4, (0x1 << 13), (0) << 13);
 
-	wlc_phy_force_rfseq_nphy(pi, NPHY_RFSEQ_RESET2RX);
+		mod_phy_reg(pi, (1 == PHY_CORE_0) ? 0x2a3 :
+			    0x2a4, (0x1 << 13), (0) << 13);
 
-	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x110, 16,
-				 gain_save);
+	} else {
+		mod_phy_reg(pi, (0 == PHY_CORE_0) ? 0x2a3 :
+			    0x2a4, (0x1 << 11), (0) << 11);
 
-	if (NREV_GE(pi->pubpi.phy_rev, 4))
-		pi->phyhang_avoid = phyhang_avoid_state;
+		mod_phy_reg(pi, (1 == PHY_CORE_0) ? 0x2a3 :
+			    0x2a4, (0x1 << 11), (0) << 11);
+
+	}
+	pi->nphy_papdcomp = NPHY_PAPD_COMP_ON;
+
+	write_phy_reg(pi, 0x01, phy_b9);
+
+	wlc_phy_ipa_set_tx_digi_filts_nphy(pi);
+
+	wlc_phy_txpwrctrl_enable_nphy(pi, phy_b4);
+	if (phy_b4 == PHY_TPC_HW_OFF) {
+		wlc_phy_txpwr_index_nphy(pi, (1 << 0),
+					 (s8) (pi->nphy_txpwrindex[0].
+					       index_internal), false);
+		wlc_phy_txpwr_index_nphy(pi, (1 << 1),
+					 (s8) (pi->nphy_txpwrindex[1].
+					       index_internal), false);
+	}
 
 	wlc_phy_stay_in_carriersearch_nphy(pi, false);
 
-	return 0;
+	if (!phy_b3)
+		wlapi_enable_mac(pi->sh->physhim);
 }
 
-static int
-wlc_phy_cal_rxiq_nphy_rev2(struct brcms_phy *pi,
-			   struct nphy_txgains target_gain, bool debug)
+void wlc_phy_cal_perical_nphy_run(struct brcms_phy *pi, u8 caltype)
 {
-	struct phy_iq_est est[PHY_CORE_MAX];
-	u8 core_num, rx_core, tx_core;
-	u16 lna_vals[] = { 0x3, 0x3, 0x1 };
-	u16 hpf1_vals[] = { 0x7, 0x2, 0x0 };
-	u16 hpf2_vals[] = { 0x2, 0x0, 0x0 };
-	s16 curr_hpf1, curr_hpf2, curr_hpf, curr_lna;
-	s16 desired_log2_pwr, actual_log2_pwr, hpf_change;
-	u16 orig_RfseqCoreActv, orig_AfectrlCore, orig_AfectrlOverride;
-	u16 orig_RfctrlIntcRx, orig_RfctrlIntcTx;
-	u16 num_samps;
-	u32 i_pwr, q_pwr, tot_pwr[3];
-	u8 gain_pass, use_hpf_num;
-	u16 mask, val1, val2;
-	u16 core_no;
-	u16 gain_save[2];
-	u16 cal_gain[2];
-	struct nphy_iqcal_params cal_params[2];
-	u8 phy_bw;
-	int bcmerror = 0;
-	bool first_playtone = true;
+	struct nphy_txgains target_gain;
+	u8 tx_pwr_ctrl_state;
+	bool fullcal = true;
+	bool restore_tx_gain = false;
+	bool mphase;
 
-	wlc_phy_stay_in_carriersearch_nphy(pi, true);
+	if (PHY_MUTED(pi))
+		return;
 
-	if (NREV_LT(pi->pubpi.phy_rev, 2))
-		wlc_phy_reapply_txcal_coeffs_nphy(pi);
+	if (caltype == PHY_PERICAL_AUTO)
+		fullcal = (pi->radio_chanspec != pi->nphy_txiqlocal_chanspec);
+	else if (caltype == PHY_PERICAL_PARTIAL)
+		fullcal = false;
 
-	wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x110, 16, gain_save);
+	if (pi->cal_type_override != PHY_PERICAL_AUTO)
+		fullcal =
+			(pi->cal_type_override ==
+			 PHY_PERICAL_FULL) ? true : false;
 
-	for (core_no = 0; core_no <= 1; core_no++) {
-		wlc_phy_iqcal_gainparams_nphy(pi, core_no, target_gain,
-					      &cal_params[core_no]);
-		cal_gain[core_no] = cal_params[core_no].cal_gain;
+	if ((pi->mphase_cal_phase_id > MPHASE_CAL_STATE_INIT)) {
+		if (pi->nphy_txiqlocal_chanspec != pi->radio_chanspec)
+			wlc_phy_cal_perical_mphase_restart(pi);
 	}
 
-	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x110, 16, cal_gain);
+	if ((pi->mphase_cal_phase_id == MPHASE_CAL_STATE_RXCAL))
+		wlapi_bmac_write_shm(pi->sh->physhim, M_CTS_DURATION, 10000);
 
-	num_samps = 1024;
-	desired_log2_pwr = 13;
+	wlapi_suspend_mac_and_wait(pi->sh->physhim);
+
+	wlc_phyreg_enter((struct brcms_phy_pub *) pi);
+
+	if ((pi->mphase_cal_phase_id == MPHASE_CAL_STATE_IDLE) ||
+	    (pi->mphase_cal_phase_id == MPHASE_CAL_STATE_INIT)) {
+		pi->nphy_cal_orig_pwr_idx[0] =
+			(u8) ((read_phy_reg(pi, 0x1ed) >> 8) & 0x7f);
+		pi->nphy_cal_orig_pwr_idx[1] =
+			(u8) ((read_phy_reg(pi, 0x1ee) >> 8) & 0x7f);
+
+		if (pi->nphy_txpwrctrl != PHY_TPC_HW_OFF) {
+			wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_RFSEQ, 2,
+						0x110, 16,
+						pi->nphy_cal_orig_tx_gain);
+		} else {
+			pi->nphy_cal_orig_tx_gain[0] = 0;
+			pi->nphy_cal_orig_tx_gain[1] = 0;
+		}
+	}
+	target_gain = wlc_phy_get_tx_gain_nphy(pi);
+	tx_pwr_ctrl_state = pi->nphy_txpwrctrl;
+	wlc_phy_txpwrctrl_enable_nphy(pi, PHY_TPC_HW_OFF);
 
-	for (core_num = 0; core_num < 2; core_num++) {
+	if (pi->antsel_type == ANTSEL_2x3)
+		wlc_phy_antsel_init((struct brcms_phy_pub *) pi, true);
 
-		rx_core = core_num;
-		tx_core = 1 - core_num;
+	mphase = (pi->mphase_cal_phase_id != MPHASE_CAL_STATE_IDLE);
+	if (!mphase) {
 
-		orig_RfseqCoreActv = read_phy_reg(pi, 0xa2);
-		orig_AfectrlCore = read_phy_reg(pi, (rx_core == PHY_CORE_0) ?
-						0xa6 : 0xa7);
-		orig_AfectrlOverride = read_phy_reg(pi, 0xa5);
-		orig_RfctrlIntcRx = read_phy_reg(pi, (rx_core == PHY_CORE_0) ?
-						 0x91 : 0x92);
-		orig_RfctrlIntcTx = read_phy_reg(pi, (tx_core == PHY_CORE_0) ?
-						 0x91 : 0x92);
+		if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+			wlc_phy_precal_txgain_nphy(pi);
+			pi->nphy_cal_target_gain = wlc_phy_get_tx_gain_nphy(pi);
+			restore_tx_gain = true;
 
-		mod_phy_reg(pi, 0xa2, (0xf << 12), (1 << tx_core) << 12);
-		mod_phy_reg(pi, 0xa2, (0xf << 0), (1 << tx_core) << 0);
+			target_gain = pi->nphy_cal_target_gain;
+		}
+		if (0 ==
+		    wlc_phy_cal_txiqlo_nphy(pi, target_gain, fullcal,
+					    mphase)) {
+			if (PHY_IPA(pi))
+				wlc_phy_a4(pi, true);
 
-		or_phy_reg(pi, ((rx_core == PHY_CORE_0) ? 0xa6 : 0xa7),
-			   ((0x1 << 1) | (0x1 << 2)));
-		or_phy_reg(pi, 0xa5, ((0x1 << 1) | (0x1 << 2)));
+			wlc_phyreg_exit((struct brcms_phy_pub *) pi);
+			wlapi_enable_mac(pi->sh->physhim);
+			wlapi_bmac_write_shm(pi->sh->physhim, M_CTS_DURATION,
+					     10000);
+			wlapi_suspend_mac_and_wait(pi->sh->physhim);
+			wlc_phyreg_enter((struct brcms_phy_pub *) pi);
 
-		if (((pi->nphy_rxcalparams) & 0xff000000))
-			write_phy_reg(pi,
-				      (rx_core == PHY_CORE_0) ? 0x91 : 0x92,
-				      (CHSPEC_IS5G(pi->radio_chanspec) ?
-					0x140 : 0x110));
-		else
-			write_phy_reg(pi,
-				      (rx_core == PHY_CORE_0) ? 0x91 : 0x92,
-				      (CHSPEC_IS5G(pi->radio_chanspec) ?
-				       0x180 : 0x120));
+			if (0 == wlc_phy_cal_rxiq_nphy(pi, target_gain,
+					(pi->first_cal_after_assoc ||
+					(pi->cal_type_override ==
+					 PHY_PERICAL_FULL)) ? 2 : 0, false)) {
+				wlc_phy_savecal_nphy(pi);
 
-		write_phy_reg(pi, (tx_core == PHY_CORE_0) ? 0x91 : 0x92,
-			      (CHSPEC_IS5G(pi->radio_chanspec) ? 0x148 :
-			       0x114));
+				wlc_phy_txpwrctrl_coeff_setup_nphy(pi);
 
-		mask = RADIO_2055_COUPLE_RX_MASK | RADIO_2055_COUPLE_TX_MASK;
-		if (rx_core == PHY_CORE_0) {
-			val1 = RADIO_2055_COUPLE_RX_MASK;
-			val2 = RADIO_2055_COUPLE_TX_MASK;
-		} else {
-			val1 = RADIO_2055_COUPLE_TX_MASK;
-			val2 = RADIO_2055_COUPLE_RX_MASK;
+				pi->nphy_perical_last = pi->sh->now;
+			}
 		}
+		if (caltype != PHY_PERICAL_AUTO)
+			wlc_phy_rssi_cal_nphy(pi);
 
-		if ((pi->nphy_rxcalparams & 0x10000)) {
-			mod_radio_reg(pi, RADIO_2055_CORE1_GEN_SPARE2, mask,
-				      val1);
-			mod_radio_reg(pi, RADIO_2055_CORE2_GEN_SPARE2, mask,
-				      val2);
+		if (pi->first_cal_after_assoc
+		    || (pi->cal_type_override == PHY_PERICAL_FULL)) {
+			pi->first_cal_after_assoc = false;
+			wlc_phy_txpwrctrl_idle_tssi_nphy(pi);
+			wlc_phy_txpwrctrl_pwr_setup_nphy(pi);
 		}
 
-		for (gain_pass = 0; gain_pass < 4; gain_pass++) {
+		if (NREV_GE(pi->pubpi.phy_rev, 3))
+			wlc_phy_radio205x_vcocal_nphy(pi);
+	} else {
+		switch (pi->mphase_cal_phase_id) {
+		case MPHASE_CAL_STATE_INIT:
+			pi->nphy_perical_last = pi->sh->now;
+			pi->nphy_txiqlocal_chanspec = pi->radio_chanspec;
 
-			if (debug)
-				mdelay(WAIT_FOR_SCOPE);
+			if (NREV_GE(pi->pubpi.phy_rev, 3))
+				wlc_phy_precal_txgain_nphy(pi);
 
-			if (gain_pass < 3) {
-				curr_lna = lna_vals[gain_pass];
-				curr_hpf1 = hpf1_vals[gain_pass];
-				curr_hpf2 = hpf2_vals[gain_pass];
-			} else {
+			pi->nphy_cal_target_gain = wlc_phy_get_tx_gain_nphy(pi);
+			pi->mphase_cal_phase_id++;
+			break;
 
-				if (tot_pwr[1] > 10000) {
-					curr_lna = lna_vals[2];
-					curr_hpf1 = hpf1_vals[2];
-					curr_hpf2 = hpf2_vals[2];
-					use_hpf_num = 1;
-					curr_hpf = curr_hpf1;
-					actual_log2_pwr =
-						wlc_phy_nbits(tot_pwr[2]);
-				} else {
-					if (tot_pwr[0] > 10000) {
-						curr_lna = lna_vals[1];
-						curr_hpf1 = hpf1_vals[1];
-						curr_hpf2 = hpf2_vals[1];
-						use_hpf_num = 1;
-						curr_hpf = curr_hpf1;
-						actual_log2_pwr =
-							wlc_phy_nbits(
-								tot_pwr[1]);
-					} else {
-						curr_lna = lna_vals[0];
-						curr_hpf1 = hpf1_vals[0];
-						curr_hpf2 = hpf2_vals[0];
-						use_hpf_num = 2;
-						curr_hpf = curr_hpf2;
-						actual_log2_pwr =
-							wlc_phy_nbits(
-								tot_pwr[0]);
-					}
-				}
+		case MPHASE_CAL_STATE_TXPHASE0:
+		case MPHASE_CAL_STATE_TXPHASE1:
+		case MPHASE_CAL_STATE_TXPHASE2:
+		case MPHASE_CAL_STATE_TXPHASE3:
+		case MPHASE_CAL_STATE_TXPHASE4:
+		case MPHASE_CAL_STATE_TXPHASE5:
+			if ((pi->radar_percal_mask & 0x10) != 0)
+				pi->nphy_rxcal_active = true;
 
-				hpf_change = desired_log2_pwr - actual_log2_pwr;
-				curr_hpf += hpf_change;
-				curr_hpf = max(min_t(u16, curr_hpf, 10), 0);
-				if (use_hpf_num == 1)
-					curr_hpf1 = curr_hpf;
-				else
-					curr_hpf2 = curr_hpf;
+			if (wlc_phy_cal_txiqlo_nphy
+				    (pi, pi->nphy_cal_target_gain, fullcal,
+				    true) != 0) {
+
+				wlc_phy_cal_perical_mphase_reset(pi);
+				break;
 			}
 
-			wlc_phy_rfctrl_override_nphy(pi, (0x1 << 10),
-						     ((curr_hpf2 << 8) |
-						      (curr_hpf1 << 4) |
-						      (curr_lna << 2)), 0x3, 0);
-			wlc_phy_force_rfseq_nphy(pi, NPHY_RFSEQ_RESET2RX);
+			if (NREV_LE(pi->pubpi.phy_rev, 2) &&
+			    (pi->mphase_cal_phase_id ==
+			     MPHASE_CAL_STATE_TXPHASE4))
+				pi->mphase_cal_phase_id += 2;
+			else
+				pi->mphase_cal_phase_id++;
+			break;
 
-			wlc_phy_stopplayback_nphy(pi);
+		case MPHASE_CAL_STATE_PAPDCAL:
+			if ((pi->radar_percal_mask & 0x2) != 0)
+				pi->nphy_rxcal_active = true;
 
-			if (first_playtone) {
-				bcmerror = wlc_phy_tx_tone_nphy(pi, 4000,
-						(u16) (pi->nphy_rxcalparams &
-						       0xffff), 0, 0, true);
-				first_playtone = false;
-			} else {
-				phy_bw = (CHSPEC_IS40(pi->radio_chanspec)) ?
-					  40 : 20;
-				wlc_phy_runsamples_nphy(pi, phy_bw * 8, 0xffff,
-							0, 0, 0, true);
-			}
+			if (PHY_IPA(pi))
+				wlc_phy_a4(pi, true);
 
-			if (bcmerror == 0) {
-				if (gain_pass < 3) {
+			pi->mphase_cal_phase_id++;
+			break;
 
-					wlc_phy_rx_iq_est_nphy(pi, est,
-							       num_samps, 32,
-							       0);
-					i_pwr =	(est[rx_core].i_pwr +
-						 num_samps / 2) / num_samps;
-					q_pwr =	(est[rx_core].q_pwr +
-						 num_samps / 2) / num_samps;
-					tot_pwr[gain_pass] = i_pwr + q_pwr;
-				} else {
+		case MPHASE_CAL_STATE_RXCAL:
+			if ((pi->radar_percal_mask & 0x1) != 0)
+				pi->nphy_rxcal_active = true;
+			if (wlc_phy_cal_rxiq_nphy(pi, target_gain,
+						  (pi->first_cal_after_assoc ||
+						   (pi->cal_type_override ==
+						    PHY_PERICAL_FULL)) ? 2 : 0,
+						  false) == 0)
+				wlc_phy_savecal_nphy(pi);
 
-					wlc_phy_calc_rx_iq_comp_nphy(pi,
-								     (1 <<
-								      rx_core));
-				}
+			pi->mphase_cal_phase_id++;
+			break;
 
-				wlc_phy_stopplayback_nphy(pi);
-			}
+		case MPHASE_CAL_STATE_RSSICAL:
+			if ((pi->radar_percal_mask & 0x4) != 0)
+				pi->nphy_rxcal_active = true;
+			wlc_phy_txpwrctrl_coeff_setup_nphy(pi);
+			wlc_phy_rssi_cal_nphy(pi);
 
-			if (bcmerror != 0)
-				break;
-		}
+			if (NREV_GE(pi->pubpi.phy_rev, 3))
+				wlc_phy_radio205x_vcocal_nphy(pi);
 
-		and_radio_reg(pi, RADIO_2055_CORE1_GEN_SPARE2, ~mask);
-		and_radio_reg(pi, RADIO_2055_CORE2_GEN_SPARE2, ~mask);
+			restore_tx_gain = true;
 
-		write_phy_reg(pi, (tx_core == PHY_CORE_0) ? 0x91 :
-			      0x92, orig_RfctrlIntcTx);
-		write_phy_reg(pi, (rx_core == PHY_CORE_0) ? 0x91 :
-			      0x92, orig_RfctrlIntcRx);
-		write_phy_reg(pi, 0xa5, orig_AfectrlOverride);
-		write_phy_reg(pi, (rx_core == PHY_CORE_0) ? 0xa6 :
-			      0xa7, orig_AfectrlCore);
-		write_phy_reg(pi, 0xa2, orig_RfseqCoreActv);
+			if (pi->first_cal_after_assoc)
+				pi->mphase_cal_phase_id++;
+			else
+				wlc_phy_cal_perical_mphase_reset(pi);
 
-		if (bcmerror != 0)
 			break;
+
+		case MPHASE_CAL_STATE_IDLETSSI:
+			if ((pi->radar_percal_mask & 0x8) != 0)
+				pi->nphy_rxcal_active = true;
+
+			if (pi->first_cal_after_assoc) {
+				pi->first_cal_after_assoc = false;
+				wlc_phy_txpwrctrl_idle_tssi_nphy(pi);
+				wlc_phy_txpwrctrl_pwr_setup_nphy(pi);
+			}
+
+			wlc_phy_cal_perical_mphase_reset(pi);
+			break;
+
+		default:
+			wlc_phy_cal_perical_mphase_reset(pi);
+			break;
+		}
 	}
 
-	wlc_phy_rfctrl_override_nphy(pi, (0x1 << 10), 0, 0x3, 1);
-	wlc_phy_force_rfseq_nphy(pi, NPHY_RFSEQ_RESET2RX);
+	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+		if (restore_tx_gain) {
+			if (tx_pwr_ctrl_state != PHY_TPC_HW_OFF) {
 
-	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x110, 16,
-				 gain_save);
+				wlc_phy_txpwr_index_nphy(pi, 1,
+							 pi->
+							 nphy_cal_orig_pwr_idx
+							 [0], false);
+				wlc_phy_txpwr_index_nphy(pi, 2,
+							 pi->
+							 nphy_cal_orig_pwr_idx
+							 [1], false);
 
-	wlc_phy_stay_in_carriersearch_nphy(pi, false);
+				pi->nphy_txpwrindex[0].index = -1;
+				pi->nphy_txpwrindex[1].index = -1;
+			} else {
+				wlc_phy_txpwr_index_nphy(pi, (1 << 0),
+							 (s8) (pi->
+							       nphy_txpwrindex
+							       [0].
+							       index_internal),
+							 false);
+				wlc_phy_txpwr_index_nphy(pi, (1 << 1),
+							 (s8) (pi->
+							       nphy_txpwrindex
+							       [1].
+							       index_internal),
+							 false);
+			}
+		}
+	}
 
-	return bcmerror;
+	wlc_phy_txpwrctrl_enable_nphy(pi, tx_pwr_ctrl_state);
+	wlc_phyreg_exit((struct brcms_phy_pub *) pi);
+	wlapi_enable_mac(pi->sh->physhim);
 }
 
 int
-wlc_phy_cal_rxiq_nphy(struct brcms_phy *pi, struct nphy_txgains target_gain,
-		      u8 cal_type, bool debug)
+wlc_phy_cal_txiqlo_nphy(struct brcms_phy *pi, struct nphy_txgains target_gain,
+			bool fullcal, bool mphase)
 {
-	if (NREV_GE(pi->pubpi.phy_rev, 7))
-		cal_type = 0;
+	u16 val;
+	u16 tbl_buf[11];
+	u8 cal_cnt;
+	u16 cal_cmd;
+	u8 num_cals, max_cal_cmds;
+	u16 core_no, cal_type;
+	u16 diq_start = 0;
+	u8 phy_bw;
+	u16 max_val;
+	u16 tone_freq;
+	u16 gain_save[2];
+	u16 cal_gain[2];
+	struct nphy_iqcal_params cal_params[2];
+	u32 tbl_len;
+	void *tbl_ptr;
+	bool ladder_updated[2];
+	u8 mphase_cal_lastphase = 0;
+	int bcmerror = 0;
+	bool phyhang_avoid_state = false;
 
-	if (NREV_GE(pi->pubpi.phy_rev, 3))
-		return wlc_phy_cal_rxiq_nphy_rev3(pi, target_gain, cal_type,
-						  debug);
-	else
-		return wlc_phy_cal_rxiq_nphy_rev2(pi, target_gain, debug);
-}
+	u16 tbl_tx_iqlo_cal_loft_ladder_20[] = {
+		0x0300, 0x0500, 0x0700, 0x0900, 0x0d00, 0x1100, 0x1900, 0x1901,
+		0x1902,
+		0x1903, 0x1904, 0x1905, 0x1906, 0x1907, 0x2407, 0x3207, 0x4607,
+		0x6407
+	};
 
-static void wlc_phy_extpa_set_tx_digi_filts_nphy(struct brcms_phy *pi)
-{
-	int j, type = 2;
-	u16 addr_offset = 0x2c5;
+	u16 tbl_tx_iqlo_cal_iqimb_ladder_20[] = {
+		0x0200, 0x0300, 0x0600, 0x0900, 0x0d00, 0x1100, 0x1900, 0x2400,
+		0x3200,
+		0x4600, 0x6400, 0x6401, 0x6402, 0x6403, 0x6404, 0x6405, 0x6406,
+		0x6407
+	};
 
-	for (j = 0; j < NPHY_NUM_DIG_FILT_COEFFS; j++)
-		write_phy_reg(pi, addr_offset + j,
-			      NPHY_IPA_REV4_txdigi_filtcoeffs[type][j]);
-}
+	u16 tbl_tx_iqlo_cal_loft_ladder_40[] = {
+		0x0200, 0x0300, 0x0400, 0x0700, 0x0900, 0x0c00, 0x1200, 0x1201,
+		0x1202,
+		0x1203, 0x1204, 0x1205, 0x1206, 0x1207, 0x1907, 0x2307, 0x3207,
+		0x4707
+	};
 
-static void wlc_phy_ipa_set_tx_digi_filts_nphy(struct brcms_phy *pi)
-{
-	int j, type;
-	u16 addr_offset[] = { 0x186, 0x195, 0x2c5};
+	u16 tbl_tx_iqlo_cal_iqimb_ladder_40[] = {
+		0x0100, 0x0200, 0x0400, 0x0700, 0x0900, 0x0c00, 0x1200, 0x1900,
+		0x2300,
+		0x3200, 0x4700, 0x4701, 0x4702, 0x4703, 0x4704, 0x4705, 0x4706,
+		0x4707
+	};
 
-	for (type = 0; type < 3; type++) {
-		for (j = 0; j < NPHY_NUM_DIG_FILT_COEFFS; j++)
-			write_phy_reg(pi, addr_offset[type] + j,
-				      NPHY_IPA_REV4_txdigi_filtcoeffs[type][j]);
-	}
+	u16 tbl_tx_iqlo_cal_startcoefs[] = {
+		0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+		0x0000
+	};
 
-	if (IS40MHZ(pi)) {
-		for (j = 0; j < NPHY_NUM_DIG_FILT_COEFFS; j++)
-			write_phy_reg(pi, 0x186 + j,
-				      NPHY_IPA_REV4_txdigi_filtcoeffs[3][j]);
-	} else {
-		if (CHSPEC_IS5G(pi->radio_chanspec)) {
-			for (j = 0; j < NPHY_NUM_DIG_FILT_COEFFS; j++)
-				write_phy_reg(pi, 0x186 + j,
-					NPHY_IPA_REV4_txdigi_filtcoeffs[5][j]);
-		}
+	u16 tbl_tx_iqlo_cal_cmds_fullcal[] = {
+		0x8123, 0x8264, 0x8086, 0x8245, 0x8056,
+		0x9123, 0x9264, 0x9086, 0x9245, 0x9056
+	};
 
-		if (CHSPEC_CHANNEL(pi->radio_chanspec) == 14) {
-			for (j = 0; j < NPHY_NUM_DIG_FILT_COEFFS; j++)
-				write_phy_reg(pi, 0x2c5 + j,
-					NPHY_IPA_REV4_txdigi_filtcoeffs[6][j]);
-		}
-	}
-}
+	u16 tbl_tx_iqlo_cal_cmds_recal[] = {
+		0x8101, 0x8253, 0x8053, 0x8234, 0x8034,
+		0x9101, 0x9253, 0x9053, 0x9234, 0x9034
+	};
 
-static void wlc_phy_ipa_restore_tx_digi_filts_nphy(struct brcms_phy *pi)
-{
-	int j;
+	u16 tbl_tx_iqlo_cal_startcoefs_nphyrev3[] = {
+		0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+		0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
+		0x0000
+	};
 
-	if (IS40MHZ(pi)) {
-		for (j = 0; j < NPHY_NUM_DIG_FILT_COEFFS; j++)
-			write_phy_reg(pi, 0x195 + j,
-				      NPHY_IPA_REV4_txdigi_filtcoeffs[4][j]);
-	} else {
-		for (j = 0; j < NPHY_NUM_DIG_FILT_COEFFS; j++)
-			write_phy_reg(pi, 0x186 + j,
-				      NPHY_IPA_REV4_txdigi_filtcoeffs[3][j]);
+	u16 tbl_tx_iqlo_cal_cmds_fullcal_nphyrev3[] = {
+		0x8434, 0x8334, 0x8084, 0x8267, 0x8056, 0x8234,
+		0x9434, 0x9334, 0x9084, 0x9267, 0x9056, 0x9234
+	};
+
+	u16 tbl_tx_iqlo_cal_cmds_recal_nphyrev3[] = {
+		0x8423, 0x8323, 0x8073, 0x8256, 0x8045, 0x8223,
+		0x9423, 0x9323, 0x9073, 0x9256, 0x9045, 0x9223
+	};
+
+	wlc_phy_stay_in_carriersearch_nphy(pi, true);
+
+	if (NREV_GE(pi->pubpi.phy_rev, 4)) {
+		phyhang_avoid_state = pi->phyhang_avoid;
+		pi->phyhang_avoid = false;
 	}
-}
 
-static u16 wlc_phy_ipa_get_bbmult_nphy(struct brcms_phy *pi)
-{
-	u16 m0m1;
+	if (CHSPEC_IS40(pi->radio_chanspec))
+		phy_bw = 40;
+	else
+		phy_bw = 20;
 
-	wlc_phy_table_read_nphy(pi, 15, 1, 87, 16, &m0m1);
+	wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x110, 16, gain_save);
 
-	return m0m1;
-}
+	for (core_no = 0; core_no <= 1; core_no++) {
+		wlc_phy_iqcal_gainparams_nphy(pi, core_no, target_gain,
+					      &cal_params[core_no]);
+		cal_gain[core_no] = cal_params[core_no].cal_gain;
+	}
 
-static void wlc_phy_ipa_set_bbmult_nphy(struct brcms_phy *pi, u8 m0, u8 m1)
-{
-	u16 m0m1 = (u16) ((m0 << 8) | m1);
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x110, 16, cal_gain);
 
-	wlc_phy_table_write_nphy(pi, 15, 1, 87, 16, &m0m1);
-	wlc_phy_table_write_nphy(pi, 15, 1, 95, 16, &m0m1);
-}
+	wlc_phy_txcal_radio_setup_nphy(pi);
 
-static u32 *wlc_phy_get_ipa_gaintbl_nphy(struct brcms_phy *pi)
-{
-	u32 *tx_pwrctrl_tbl = NULL;
+	wlc_phy_txcal_physetup_nphy(pi);
 
-	if (CHSPEC_IS2G(pi->radio_chanspec)) {
-		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-			if ((pi->pubpi.radiorev == 4)
-			    || (pi->pubpi.radiorev == 6))
-				tx_pwrctrl_tbl =
-					nphy_tpc_txgain_ipa_2g_2057rev4n6;
-			else if (pi->pubpi.radiorev == 3)
-				tx_pwrctrl_tbl =
-					nphy_tpc_txgain_ipa_2g_2057rev3;
-			else if (pi->pubpi.radiorev == 5)
-				tx_pwrctrl_tbl =
-					nphy_tpc_txgain_ipa_2g_2057rev5;
-			else if ((pi->pubpi.radiorev == 7)
-				 || (pi->pubpi.radiorev == 8))
-				tx_pwrctrl_tbl =
-					nphy_tpc_txgain_ipa_2g_2057rev7;
-		} else if (NREV_IS(pi->pubpi.phy_rev, 6)) {
-			tx_pwrctrl_tbl = nphy_tpc_txgain_ipa_rev6;
-		} else if (NREV_IS(pi->pubpi.phy_rev, 5)) {
-			tx_pwrctrl_tbl = nphy_tpc_txgain_ipa_rev5;
+	ladder_updated[0] = ladder_updated[1] = false;
+	if (!(NREV_GE(pi->pubpi.phy_rev, 6) ||
+	      (NREV_IS(pi->pubpi.phy_rev, 5) && PHY_IPA(pi)
+	       && (CHSPEC_IS2G(pi->radio_chanspec))))) {
+
+		if (phy_bw == 40) {
+			tbl_ptr = tbl_tx_iqlo_cal_loft_ladder_40;
+			tbl_len = ARRAY_SIZE(tbl_tx_iqlo_cal_loft_ladder_40);
 		} else {
-			tx_pwrctrl_tbl = nphy_tpc_txgain_ipa;
+			tbl_ptr = tbl_tx_iqlo_cal_loft_ladder_20;
+			tbl_len = ARRAY_SIZE(tbl_tx_iqlo_cal_loft_ladder_20);
 		}
-	} else {
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, tbl_len, 0,
+					 16, tbl_ptr);
 
-		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-			if ((pi->pubpi.radiorev == 3) ||
-			    (pi->pubpi.radiorev == 4) ||
-			    (pi->pubpi.radiorev == 6))
-				tx_pwrctrl_tbl = nphy_tpc_txgain_ipa_5g_2057;
-			else if ((pi->pubpi.radiorev == 7)
-				 || (pi->pubpi.radiorev == 8))
-				tx_pwrctrl_tbl =
-					nphy_tpc_txgain_ipa_5g_2057rev7;
+		if (phy_bw == 40) {
+			tbl_ptr = tbl_tx_iqlo_cal_iqimb_ladder_40;
+			tbl_len = ARRAY_SIZE(tbl_tx_iqlo_cal_iqimb_ladder_40);
 		} else {
-			tx_pwrctrl_tbl = nphy_tpc_txgain_ipa_5g;
+			tbl_ptr = tbl_tx_iqlo_cal_iqimb_ladder_20;
+			tbl_len = ARRAY_SIZE(tbl_tx_iqlo_cal_iqimb_ladder_20);
 		}
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, tbl_len, 32,
+					 16, tbl_ptr);
+	}
+
+	if (NREV_GE(pi->pubpi.phy_rev, 7))
+		write_phy_reg(pi, 0xc2, 0x8ad9);
+	else
+		write_phy_reg(pi, 0xc2, 0x8aa9);
+
+	max_val = 250;
+	tone_freq = (phy_bw == 20) ? 2500 : 5000;
+
+	if (pi->mphase_cal_phase_id > MPHASE_CAL_STATE_TXPHASE0) {
+		wlc_phy_runsamples_nphy(pi, phy_bw * 8, 0xffff, 0, 1, 0, false);
+		bcmerror = 0;
+	} else {
+		bcmerror =
+			wlc_phy_tx_tone_nphy(pi, tone_freq, max_val, 1, 0,
+					     false);
 	}
 
-	return tx_pwrctrl_tbl;
-}
+	if (bcmerror == 0) {
 
-static void
-wlc_phy_papd_cal_setup_nphy(struct brcms_phy *pi,
-			    struct nphy_papd_restore_state *state, u8 core)
-{
-	s32 tone_freq;
-	u8 off_core;
-	u16 mixgain = 0;
+		if (pi->mphase_cal_phase_id > MPHASE_CAL_STATE_TXPHASE0) {
+			tbl_ptr = pi->mphase_txcal_bestcoeffs;
+			tbl_len = ARRAY_SIZE(pi->mphase_txcal_bestcoeffs);
+			if (NREV_LT(pi->pubpi.phy_rev, 3))
+				tbl_len -= 2;
+		} else {
+			if ((!fullcal) && (pi->nphy_txiqlocal_coeffsvalid)) {
 
-	off_core = core ^ 0x1;
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+				tbl_ptr = pi->nphy_txiqlocal_bestc;
+				tbl_len = ARRAY_SIZE(pi->nphy_txiqlocal_bestc);
+				if (NREV_LT(pi->pubpi.phy_rev, 3))
+					tbl_len -= 2;
+			} else {
 
-		if (NREV_IS(pi->pubpi.phy_rev, 7)
-		    || NREV_GE(pi->pubpi.phy_rev, 8))
-			wlc_phy_rfctrl_override_nphy_rev7(
-				pi, (0x1 << 7),
-				wlc_phy_read_lpf_bw_ctl_nphy
-					(pi,
-					0), 0, 0,
-				NPHY_REV7_RFCTRLOVERRIDE_ID1);
+				fullcal = true;
 
-		if (CHSPEC_IS2G(pi->radio_chanspec)) {
-			if (pi->pubpi.radiorev == 5)
-				mixgain = (core == 0) ? 0x20 : 0x00;
-			else if ((pi->pubpi.radiorev == 7)
-				 || (pi->pubpi.radiorev == 8))
-				mixgain = 0x00;
-			else if ((pi->pubpi.radiorev <= 4)
-				 || (pi->pubpi.radiorev == 6))
-				mixgain = 0x00;
-		} else {
-			if ((pi->pubpi.radiorev == 4) ||
-			    (pi->pubpi.radiorev == 6))
-				mixgain = 0x50;
-			else if ((pi->pubpi.radiorev == 3)
-				 || (pi->pubpi.radiorev == 7)
-				 || (pi->pubpi.radiorev == 8))
-				mixgain = 0x0;
+				if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+					tbl_ptr =
+					    tbl_tx_iqlo_cal_startcoefs_nphyrev3;
+					tbl_len = ARRAY_SIZE(
+					   tbl_tx_iqlo_cal_startcoefs_nphyrev3);
+				} else {
+					tbl_ptr = tbl_tx_iqlo_cal_startcoefs;
+					tbl_len = ARRAY_SIZE(
+						    tbl_tx_iqlo_cal_startcoefs);
+				}
+			}
 		}
+		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, tbl_len, 64,
+					 16, tbl_ptr);
 
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 11),
-						  mixgain, (1 << core), 0,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID0);
+		if (fullcal) {
+			max_cal_cmds = (NREV_GE(pi->pubpi.phy_rev, 3)) ?
+				       ARRAY_SIZE(
+				tbl_tx_iqlo_cal_cmds_fullcal_nphyrev3) :
+				       ARRAY_SIZE(tbl_tx_iqlo_cal_cmds_fullcal);
+		} else {
+			max_cal_cmds = (NREV_GE(pi->pubpi.phy_rev, 3)) ?
+				       ARRAY_SIZE(
+				tbl_tx_iqlo_cal_cmds_recal_nphyrev3) :
+				       ARRAY_SIZE(tbl_tx_iqlo_cal_cmds_recal);
+		}
 
-		wlc_phy_rfctrl_override_1tomany_nphy(
-			pi,
-			NPHY_REV7_RfctrlOverride_cmd_tx_pu,
-			1, (1 << core), 0);
-		wlc_phy_rfctrl_override_1tomany_nphy(
-			pi,
-			NPHY_REV7_RfctrlOverride_cmd_tx_pu,
-			0, (1 << off_core), 0);
+		if (mphase) {
+			cal_cnt = pi->mphase_txcal_cmdidx;
+			if ((cal_cnt + pi->mphase_txcal_numcmds) < max_cal_cmds)
+				num_cals = cal_cnt + pi->mphase_txcal_numcmds;
+			else
+				num_cals = max_cal_cmds;
+		} else {
+			cal_cnt = 0;
+			num_cals = max_cal_cmds;
+		}
 
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 3),
-						  0, 0x3, 0,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID0);
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 2), 1,
-						  (1 << core), 0,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 0), 0,
-						  (1 << core), 0,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 1), 1,
-						  (1 << core), 0,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID2);
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 8), 0,
-						  (1 << core), 0,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 9), 1,
-						  (1 << core), 0,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 10), 0,
-						  (1 << core), 0,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 3), 1,
-						  (1 << core), 0,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
+		for (; cal_cnt < num_cals; cal_cnt++) {
 
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 5),
-						  0, (1 << core), 0,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 4), 0,
-						  (1 << core), 0,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
+			if (fullcal) {
+				cal_cmd = (NREV_GE(pi->pubpi.phy_rev, 3)) ?
+					  tbl_tx_iqlo_cal_cmds_fullcal_nphyrev3
+					  [cal_cnt] :
+					  tbl_tx_iqlo_cal_cmds_fullcal[cal_cnt];
+			} else {
+				cal_cmd = (NREV_GE(pi->pubpi.phy_rev, 3)) ?
+					  tbl_tx_iqlo_cal_cmds_recal_nphyrev3[
+					cal_cnt]
+					  : tbl_tx_iqlo_cal_cmds_recal[cal_cnt];
+			}
 
-		state->afectrl[core] = read_phy_reg(pi, (core == PHY_CORE_0) ?
-						    0xa6 : 0xa7);
-		state->afeoverride[core] =
-			read_phy_reg(pi, (core == PHY_CORE_0) ? 0x8f : 0xa5);
-		state->afectrl[off_core] =
-			read_phy_reg(pi, (core == PHY_CORE_0) ? 0xa7 : 0xa6);
-		state->afeoverride[off_core] =
-			read_phy_reg(pi, (core == PHY_CORE_0) ? 0xa5 : 0x8f);
+			core_no = ((cal_cmd & 0x3000) >> 12);
+			cal_type = ((cal_cmd & 0x0F00) >> 8);
 
-		mod_phy_reg(pi, ((core == PHY_CORE_0) ? 0xa6 : 0xa7),
-			    (0x1 << 2), 0);
-		mod_phy_reg(pi, ((core == PHY_CORE_0) ? 0x8f :
-				 0xa5), (0x1 << 2), (0x1 << 2));
+			if (NREV_GE(pi->pubpi.phy_rev, 6) ||
+			    (NREV_IS(pi->pubpi.phy_rev, 5) &&
+			     PHY_IPA(pi)
+			     && (CHSPEC_IS2G(pi->radio_chanspec)))) {
+				if (!ladder_updated[core_no]) {
+					wlc_phy_update_txcal_ladder_nphy(
+						pi,
+						core_no);
+					ladder_updated[core_no] = true;
+				}
+			}
 
-		mod_phy_reg(pi, ((core == PHY_CORE_0) ? 0xa7 : 0xa6),
-			    (0x1 << 2), (0x1 << 2));
-		mod_phy_reg(pi, ((core == PHY_CORE_0) ? 0xa5 :
-				 0x8f), (0x1 << 2), (0x1 << 2));
+			val =
+				(cal_params[core_no].
+				 ncorr[cal_type] << 8) | NPHY_N_GCTL;
+			write_phy_reg(pi, 0xc1, val);
 
-		if (CHSPEC_IS2G(pi->radio_chanspec)) {
-			state->pwrup[core] =
-				READ_RADIO_REG3(pi, RADIO_2057, TX, core,
-						TXRXCOUPLE_2G_PWRUP);
-			state->atten[core] =
-				READ_RADIO_REG3(pi, RADIO_2057, TX, core,
-						TXRXCOUPLE_2G_ATTEN);
-			state->pwrup[off_core] =
-				READ_RADIO_REG3(pi, RADIO_2057, TX, off_core,
-						TXRXCOUPLE_2G_PWRUP);
-			state->atten[off_core] =
-				READ_RADIO_REG3(pi, RADIO_2057, TX, off_core,
-						TXRXCOUPLE_2G_ATTEN);
+			if ((cal_type == 1) || (cal_type == 3)
+			    || (cal_type == 4)) {
 
-			WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
-					 TXRXCOUPLE_2G_PWRUP, 0xc);
+				wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_IQLOCAL,
+							1, 69 + core_no, 16,
+							tbl_buf);
 
-			if ((pi->pubpi.radiorev == 3) ||
-			    (pi->pubpi.radiorev == 4) ||
-			    (pi->pubpi.radiorev == 6))
-				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
-						 TXRXCOUPLE_2G_ATTEN, 0xf0);
-			else if (pi->pubpi.radiorev == 5)
-				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
-						 TXRXCOUPLE_2G_ATTEN,
-						 (core == 0) ? 0xf7 : 0xf2);
-			else if ((pi->pubpi.radiorev == 7)
-				 || (pi->pubpi.radiorev == 8))
-				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
-						 TXRXCOUPLE_2G_ATTEN, 0xf0);
+				diq_start = tbl_buf[0];
 
-			WRITE_RADIO_REG3(pi, RADIO_2057, TX, off_core,
-					 TXRXCOUPLE_2G_PWRUP, 0x0);
-			WRITE_RADIO_REG3(pi, RADIO_2057, TX, off_core,
-					 TXRXCOUPLE_2G_ATTEN, 0xff);
-		} else {
-			state->pwrup[core] =
-				READ_RADIO_REG3(pi, RADIO_2057, TX, core,
-						TXRXCOUPLE_5G_PWRUP);
-			state->atten[core] =
-				READ_RADIO_REG3(pi, RADIO_2057, TX, core,
-						TXRXCOUPLE_5G_ATTEN);
-			state->pwrup[off_core] =
-				READ_RADIO_REG3(pi, RADIO_2057, TX, off_core,
-						TXRXCOUPLE_5G_PWRUP);
-			state->atten[off_core] =
-				READ_RADIO_REG3(pi, RADIO_2057, TX, off_core,
-						TXRXCOUPLE_5G_ATTEN);
+				tbl_buf[0] = 0;
+				wlc_phy_table_write_nphy(pi,
+							 NPHY_TBL_ID_IQLOCAL, 1,
+							 69 + core_no, 16,
+							 tbl_buf);
+			}
 
-			WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
-					 TXRXCOUPLE_5G_PWRUP, 0xc);
+			write_phy_reg(pi, 0xc0, cal_cmd);
 
-			if ((pi->pubpi.radiorev == 7)
-			    || (pi->pubpi.radiorev == 8))
-				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
-						 TXRXCOUPLE_5G_ATTEN, 0xf4);
+			SPINWAIT(((read_phy_reg(pi, 0xc0) & 0xc000) != 0),
+				 20000);
+			if (WARN(read_phy_reg(pi, 0xc0) & 0xc000,
+				 "HW error: txiq calib"))
+				return -EIO;
 
-			else
-				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
-						 TXRXCOUPLE_5G_ATTEN, 0xf0);
+			wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_IQLOCAL,
+						tbl_len, 96, 16, tbl_buf);
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL,
+						 tbl_len, 64, 16, tbl_buf);
 
-			WRITE_RADIO_REG3(pi, RADIO_2057, TX, off_core,
-					 TXRXCOUPLE_5G_PWRUP, 0x0);
-			WRITE_RADIO_REG3(pi, RADIO_2057, TX, off_core,
-					 TXRXCOUPLE_5G_ATTEN, 0xff);
-		}
+			if ((cal_type == 1) || (cal_type == 3)
+			    || (cal_type == 4)) {
 
-		tone_freq = 4000;
+				tbl_buf[0] = diq_start;
 
-		wlc_phy_tx_tone_nphy(pi, tone_freq, 181, 0, 0, false);
+			}
 
-		mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x297 :
-			    0x29b, (0x1 << 0), (NPHY_PAPD_COMP_ON) << 0);
+		}
 
-		mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x2a3 :
-			    0x2a4, (0x1 << 13), (1) << 13);
+		if (mphase) {
+			pi->mphase_txcal_cmdidx = num_cals;
+			if (pi->mphase_txcal_cmdidx >= max_cal_cmds)
+				pi->mphase_txcal_cmdidx = 0;
+		}
 
-		mod_phy_reg(pi, (off_core == PHY_CORE_0) ? 0x297 :
-			    0x29b, (0x1 << 0), (NPHY_PAPD_COMP_OFF) << 0);
+		mphase_cal_lastphase =
+			(NREV_LE(pi->pubpi.phy_rev, 2)) ?
+			MPHASE_CAL_STATE_TXPHASE4 : MPHASE_CAL_STATE_TXPHASE5;
 
-		mod_phy_reg(pi, (off_core == PHY_CORE_0) ? 0x2a3 :
-			    0x2a4, (0x1 << 13), (0) << 13);
+		if (!mphase
+		    || (pi->mphase_cal_phase_id == mphase_cal_lastphase)) {
 
-	} else {
+			wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_IQLOCAL, 4, 96,
+						16, tbl_buf);
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, 4, 80,
+						 16, tbl_buf);
 
-		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 12), 0, 0x3, 0);
+			if (NREV_LT(pi->pubpi.phy_rev, 2)) {
 
-		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 3), 1, 0, 0);
+				tbl_buf[0] = 0;
+				tbl_buf[1] = 0;
+				tbl_buf[2] = 0;
+				tbl_buf[3] = 0;
 
-		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 0), 0, 0x3, 0);
+			}
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, 4, 88,
+						 16, tbl_buf);
 
-		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 2), 1, 0x3, 0);
-		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 1), 1, 0x3, 0);
+			wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_IQLOCAL, 2, 101,
+						16, tbl_buf);
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, 2, 85,
+						 16, tbl_buf);
 
-		state->afectrl[core] = read_phy_reg(pi, (core == PHY_CORE_0) ?
-						    0xa6 : 0xa7);
-		state->afeoverride[core] =
-			read_phy_reg(pi, (core == PHY_CORE_0) ? 0x8f : 0xa5);
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, 2, 93,
+						 16, tbl_buf);
 
-		mod_phy_reg(pi, ((core == PHY_CORE_0) ? 0xa6 : 0xa7),
-			    (0x1 << 0) | (0x1 << 1) | (0x1 << 2), 0);
-		mod_phy_reg(pi, ((core == PHY_CORE_0) ? 0x8f :
-				 0xa5),
-			    (0x1 << 0) |
-			    (0x1 << 1) |
-			    (0x1 << 2), (0x1 << 0) | (0x1 << 1) | (0x1 << 2));
+			tbl_len = ARRAY_SIZE(pi->nphy_txiqlocal_bestc);
+			if (NREV_LT(pi->pubpi.phy_rev, 3))
+				tbl_len -= 2;
 
-		state->vga_master[core] =
-			READ_RADIO_REG2(pi, RADIO_2056, RX, core, VGA_MASTER);
-		WRITE_RADIO_REG2(pi, RADIO_2056, RX, core, VGA_MASTER, 0x2b);
-		if (CHSPEC_IS2G(pi->radio_chanspec)) {
-			state->fbmix[core] =
-				READ_RADIO_REG2(pi, RADIO_2056, RX, core,
-						TXFBMIX_G);
-			state->intpa_master[core] =
-				READ_RADIO_REG2(pi, RADIO_2056, TX, core,
-						INTPAG_MASTER);
+			wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_IQLOCAL,
+						tbl_len, 96, 16,
+						pi->nphy_txiqlocal_bestc);
 
-			WRITE_RADIO_REG2(pi, RADIO_2056, RX, core, TXFBMIX_G,
-					 0x03);
-			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
-					 INTPAG_MASTER, 0x04);
+			pi->nphy_txiqlocal_coeffsvalid = true;
+			pi->nphy_txiqlocal_chanspec = pi->radio_chanspec;
 		} else {
-			state->fbmix[core] =
-				READ_RADIO_REG2(pi, RADIO_2056, RX, core,
-						TXFBMIX_A);
-			state->intpa_master[core] =
-				READ_RADIO_REG2(pi, RADIO_2056, TX, core,
-						INTPAA_MASTER);
-
-			WRITE_RADIO_REG2(pi, RADIO_2056, RX, core, TXFBMIX_A,
-					 0x03);
-			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
-					 INTPAA_MASTER, 0x04);
+			tbl_len = ARRAY_SIZE(pi->mphase_txcal_bestcoeffs);
+			if (NREV_LT(pi->pubpi.phy_rev, 3))
+				tbl_len -= 2;
 
+			wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_IQLOCAL,
+						tbl_len, 96, 16,
+						pi->mphase_txcal_bestcoeffs);
 		}
 
-		tone_freq = 4000;
-
-		wlc_phy_tx_tone_nphy(pi, tone_freq, 181, 0, 0, false);
-
-		mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x297 :
-			    0x29b, (0x1 << 0), (1) << 0);
+		wlc_phy_stopplayback_nphy(pi);
 
-		mod_phy_reg(pi, (off_core == PHY_CORE_0) ? 0x297 :
-			    0x29b, (0x1 << 0), (0) << 0);
+		write_phy_reg(pi, 0xc2, 0x0000);
 
-		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 3), 0, 0x3, 0);
 	}
-}
-
-static void
-wlc_phy_papd_cal_cleanup_nphy(struct brcms_phy *pi,
-			      struct nphy_papd_restore_state *state)
-{
-	u8 core;
-
-	wlc_phy_stopplayback_nphy(pi);
-
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 
-		for (core = 0; core < pi->pubpi.phy_corenum; core++) {
+	wlc_phy_txcal_phycleanup_nphy(pi);
 
-			if (CHSPEC_IS2G(pi->radio_chanspec)) {
-				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
-						 TXRXCOUPLE_2G_PWRUP, 0);
-				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
-						 TXRXCOUPLE_2G_ATTEN,
-						 state->atten[core]);
-			} else {
-				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
-						 TXRXCOUPLE_5G_PWRUP, 0);
-				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
-						 TXRXCOUPLE_5G_ATTEN,
-						 state->atten[core]);
-			}
-		}
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x110, 16,
+				 gain_save);
 
-		if ((pi->pubpi.radiorev == 4) || (pi->pubpi.radiorev == 6))
-			wlc_phy_rfctrl_override_nphy_rev7(
-				pi, (0x1 << 2),
-				1, 0x3, 0,
-				NPHY_REV7_RFCTRLOVERRIDE_ID0);
-		else
-			wlc_phy_rfctrl_override_nphy_rev7(
-				pi, (0x1 << 2),
-				0, 0x3, 1,
-				NPHY_REV7_RFCTRLOVERRIDE_ID0);
+	wlc_phy_txcal_radio_cleanup_nphy(pi);
 
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 1),
-						  0, 0x3, 1,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 0), 0, 0x3, 1,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID2);
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 2), 0, 0x3, 1,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID2);
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 11), 1, 0x3, 1,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 3), 0, 0x3, 1,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID0);
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 11), 0, 0x3, 1,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID0);
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 12), 0, 0x3, 1,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID0);
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 2), 1, 0x3, 1,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 0), 0, 0x3, 1,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 1), 1, 0x3, 1,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID2);
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 8), 0, 0x3, 1,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 9), 1, 0x3, 1,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 10), 0, 0x3, 1,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 3), 1, 0x3, 1,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 5), 0, 0x3, 1,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 4), 0, 0x3, 1,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
+	if (NREV_LT(pi->pubpi.phy_rev, 2)) {
+		if (!mphase
+		    || (pi->mphase_cal_phase_id == mphase_cal_lastphase))
+			wlc_phy_tx_iq_war_nphy(pi);
+	}
 
-		for (core = 0; core < pi->pubpi.phy_corenum; core++) {
+	if (NREV_GE(pi->pubpi.phy_rev, 4))
+		pi->phyhang_avoid = phyhang_avoid_state;
 
-			write_phy_reg(pi, (core == PHY_CORE_0) ?
-				      0xa6 : 0xa7, state->afectrl[core]);
-			write_phy_reg(pi, (core == PHY_CORE_0) ? 0x8f :
-				      0xa5, state->afeoverride[core]);
-		}
+	wlc_phy_stay_in_carriersearch_nphy(pi, false);
 
-		wlc_phy_ipa_set_bbmult_nphy(pi, (state->mm >> 8) & 0xff,
-					    (state->mm & 0xff));
+	return bcmerror;
+}
 
-		if (NREV_IS(pi->pubpi.phy_rev, 7)
-		    || NREV_GE(pi->pubpi.phy_rev, 8))
-			wlc_phy_rfctrl_override_nphy_rev7(
-				pi, (0x1 << 7), 0, 0,
-				1,
-				NPHY_REV7_RFCTRLOVERRIDE_ID1);
-	} else {
-		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 12), 0, 0x3, 1);
-		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 13), 0, 0x3, 1);
-		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 0), 0, 0x3, 1);
+static void wlc_phy_reapply_txcal_coeffs_nphy(struct brcms_phy *pi)
+{
+	u16 tbl_buf[7];
 
-		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 2), 0, 0x3, 1);
-		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 1), 0, 0x3, 1);
+	if ((pi->nphy_txiqlocal_chanspec == pi->radio_chanspec) &&
+	    (pi->nphy_txiqlocal_coeffsvalid)) {
+		wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_IQLOCAL,
+					ARRAY_SIZE(tbl_buf), 80, 16, tbl_buf);
 
-		for (core = 0; core < pi->pubpi.phy_corenum; core++) {
+		if ((pi->nphy_txiqlocal_bestc[0] != tbl_buf[0]) ||
+		    (pi->nphy_txiqlocal_bestc[1] != tbl_buf[1]) ||
+		    (pi->nphy_txiqlocal_bestc[2] != tbl_buf[2]) ||
+		    (pi->nphy_txiqlocal_bestc[3] != tbl_buf[3])) {
 
-			WRITE_RADIO_REG2(pi, RADIO_2056, RX, core, VGA_MASTER,
-					 state->vga_master[core]);
-			if (CHSPEC_IS2G(pi->radio_chanspec)) {
-				WRITE_RADIO_REG2(pi, RADIO_2056, RX, core,
-						 TXFBMIX_G, state->fbmix[core]);
-				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
-						 INTPAG_MASTER,
-						 state->intpa_master[core]);
-			} else {
-				WRITE_RADIO_REG2(pi, RADIO_2056, RX, core,
-						 TXFBMIX_A, state->fbmix[core]);
-				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
-						 INTPAA_MASTER,
-						 state->intpa_master[core]);
-			}
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, 4, 80,
+						 16, pi->nphy_txiqlocal_bestc);
 
-			write_phy_reg(pi, (core == PHY_CORE_0) ?
-				      0xa6 : 0xa7, state->afectrl[core]);
-			write_phy_reg(pi, (core == PHY_CORE_0) ? 0x8f :
-				      0xa5, state->afeoverride[core]);
-		}
+			tbl_buf[0] = 0;
+			tbl_buf[1] = 0;
+			tbl_buf[2] = 0;
+			tbl_buf[3] = 0;
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, 4, 88,
+						 16, tbl_buf);
 
-		wlc_phy_ipa_set_bbmult_nphy(pi, (state->mm >> 8) & 0xff,
-					    (state->mm & 0xff));
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, 2, 85,
+						 16,
+						 &pi->nphy_txiqlocal_bestc[5]);
 
-		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 3), 0, 0x3, 1);
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, 2, 93,
+						 16,
+						 &pi->nphy_txiqlocal_bestc[5]);
+		}
 	}
 }
 
-static void
-wlc_phy_a1_nphy(struct brcms_phy *pi, u8 core, u32 winsz, u32 start,
-		u32 end)
+void
+wlc_phy_rx_iq_coeffs_nphy(struct brcms_phy *pi, u8 write,
+			  struct nphy_iq_comp *pcomp)
 {
-	u32 *buf, *src, *dst, sz;
-
-	sz = end - start + 1;
-
-	buf = kmalloc(2 * sizeof(u32) * NPHY_PAPD_EPS_TBL_SIZE, GFP_ATOMIC);
-	if (NULL == buf)
-		return;
-
-	src = buf;
-	dst = buf + NPHY_PAPD_EPS_TBL_SIZE;
-
-	wlc_phy_table_read_nphy(pi,
-				(core ==
-				 PHY_CORE_0 ? NPHY_TBL_ID_EPSILONTBL0 :
-				 NPHY_TBL_ID_EPSILONTBL1),
-				NPHY_PAPD_EPS_TBL_SIZE, 0, 32, src);
-
-	do {
-		u32 phy_a1, phy_a2;
-		s32 phy_a3, phy_a4, phy_a5, phy_a6, phy_a7;
+	if (write) {
+		write_phy_reg(pi, 0x9a, pcomp->a0);
+		write_phy_reg(pi, 0x9b, pcomp->b0);
+		write_phy_reg(pi, 0x9c, pcomp->a1);
+		write_phy_reg(pi, 0x9d, pcomp->b1);
+	} else {
+		pcomp->a0 = read_phy_reg(pi, 0x9a);
+		pcomp->b0 = read_phy_reg(pi, 0x9b);
+		pcomp->a1 = read_phy_reg(pi, 0x9c);
+		pcomp->b1 = read_phy_reg(pi, 0x9d);
+	}
+}
 
-		phy_a1 = end - min(end, (winsz >> 1));
-		phy_a2 = min_t(u32, NPHY_PAPD_EPS_TBL_SIZE - 1,
-			       end + (winsz >> 1));
-		phy_a3 = phy_a2 - phy_a1 + 1;
-		phy_a6 = 0;
-		phy_a7 = 0;
+void
+wlc_phy_rx_iq_est_nphy(struct brcms_phy *pi, struct phy_iq_est *est,
+		       u16 num_samps, u8 wait_time, u8 wait_for_crs)
+{
+	u8 core;
 
-		do {
-			wlc_phy_papd_decode_epsilon(src[phy_a2], &phy_a4,
-						    &phy_a5);
-			phy_a6 += phy_a4;
-			phy_a7 += phy_a5;
-		} while (phy_a2-- != phy_a1);
+	write_phy_reg(pi, 0x12b, num_samps);
+	mod_phy_reg(pi, 0x12a, (0xff << 0), (wait_time << 0));
+	mod_phy_reg(pi, 0x129, NPHY_IqestCmd_iqMode,
+		    (wait_for_crs) ? NPHY_IqestCmd_iqMode : 0);
 
-		phy_a6 /= phy_a3;
-		phy_a7 /= phy_a3;
-		dst[end] = ((u32) phy_a7 << 13) | ((u32) phy_a6 & 0x1fff);
-	} while (end-- != start);
+	mod_phy_reg(pi, 0x129, NPHY_IqestCmd_iqstart, NPHY_IqestCmd_iqstart);
 
-	wlc_phy_table_write_nphy(pi,
-				 (core ==
-				  PHY_CORE_0) ? NPHY_TBL_ID_EPSILONTBL0 :
-				 NPHY_TBL_ID_EPSILONTBL1, sz, start, 32, dst);
+	SPINWAIT(((read_phy_reg(pi, 0x129) & NPHY_IqestCmd_iqstart) != 0),
+		 10000);
+	if (WARN(read_phy_reg(pi, 0x129) & NPHY_IqestCmd_iqstart,
+		 "HW error: rxiq est"))
+		return;
 
-	kfree(buf);
+	if ((read_phy_reg(pi, 0x129) & NPHY_IqestCmd_iqstart) == 0) {
+		for (core = 0; core < pi->pubpi.phy_corenum; core++) {
+			est[core].i_pwr =
+				(read_phy_reg(pi,
+					      NPHY_IqestipwrAccHi(core)) << 16)
+				| read_phy_reg(pi, NPHY_IqestipwrAccLo(core));
+			est[core].q_pwr =
+				(read_phy_reg(pi,
+					      NPHY_IqestqpwrAccHi(core)) << 16)
+				| read_phy_reg(pi, NPHY_IqestqpwrAccLo(core));
+			est[core].iq_prod =
+				(read_phy_reg(pi,
+					      NPHY_IqestIqAccHi(core)) << 16) |
+				read_phy_reg(pi, NPHY_IqestIqAccLo(core));
+		}
+	}
 }
 
-static void
-wlc_phy_a2_nphy(struct brcms_phy *pi, struct nphy_ipa_txcalgains *txgains,
-		enum phy_cal_mode cal_mode, u8 core)
+#define CAL_RETRY_CNT 2
+static void wlc_phy_calc_rx_iq_comp_nphy(struct brcms_phy *pi, u8 core_mask)
 {
-	u16 phy_a1, phy_a2, phy_a3;
-	u16 phy_a4, phy_a5;
-	bool phy_a6;
-	u8 phy_a7, m[2];
-	u32 phy_a8 = 0;
-	struct nphy_txgains phy_a9;
+	u8 curr_core;
+	struct phy_iq_est est[PHY_CORE_MAX];
+	struct nphy_iq_comp old_comp, new_comp;
+	s32 iq = 0;
+	u32 ii = 0, qq = 0;
+	s16 iq_nbits, qq_nbits, brsh, arsh;
+	s32 a, b, temp;
+	int bcmerror = 0;
+	uint cal_retry = 0;
 
-	if (NREV_LT(pi->pubpi.phy_rev, 3))
+	if (core_mask == 0x0)
 		return;
 
-	phy_a7 = (core == PHY_CORE_0) ? 1 : 0;
-
-	phy_a6 = ((cal_mode == CAL_GCTRL)
-		  || (cal_mode == CAL_SOFT)) ? true : false;
-
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+	wlc_phy_rx_iq_coeffs_nphy(pi, 0, &old_comp);
+	new_comp.a0 = new_comp.b0 = new_comp.a1 = new_comp.b1 = 0x0;
+	wlc_phy_rx_iq_coeffs_nphy(pi, 1, &new_comp);
 
-		phy_a9 = wlc_phy_get_tx_gain_nphy(pi);
+cal_try:
+	wlc_phy_rx_iq_est_nphy(pi, est, 0x4000, 32, 0);
 
-		if (CHSPEC_IS2G(pi->radio_chanspec))
-			phy_a5 = ((phy_a9.txlpf[core] << 15) |
-				  (phy_a9.txgm[core] << 12) |
-				  (phy_a9.pga[core] << 8) |
-				  (txgains->gains.pad[core] << 3) |
-				  (phy_a9.ipa[core]));
-		else
-			phy_a5 = ((phy_a9.txlpf[core] << 15) |
-				  (phy_a9.txgm[core] << 12) |
-				  (txgains->gains.pga[core] << 8) |
-				  (phy_a9.pad[core] << 3) | (phy_a9.ipa[core]));
+	new_comp = old_comp;
 
-		wlc_phy_rfctrl_override_1tomany_nphy(
-			pi,
-			NPHY_REV7_RfctrlOverride_cmd_txgain,
-			phy_a5, (1 << core), 0);
+	for (curr_core = 0; curr_core < pi->pubpi.phy_corenum; curr_core++) {
 
-		if (CHSPEC_IS2G(pi->radio_chanspec)) {
-			if ((pi->pubpi.radiorev <= 4)
-			    || (pi->pubpi.radiorev == 6))
-				m[core] = IS40MHZ(pi) ? 60 : 79;
-			else
-				m[core] = IS40MHZ(pi) ? 45 : 64;
+		if ((curr_core == PHY_CORE_0) && (core_mask & 0x1)) {
+			iq = est[curr_core].iq_prod;
+			ii = est[curr_core].i_pwr;
+			qq = est[curr_core].q_pwr;
+		} else if ((curr_core == PHY_CORE_1) && (core_mask & 0x2)) {
+			iq = est[curr_core].iq_prod;
+			ii = est[curr_core].i_pwr;
+			qq = est[curr_core].q_pwr;
 		} else {
-			m[core] = IS40MHZ(pi) ? 75 : 107;
+			continue;
 		}
 
-		m[phy_a7] = 0;
-		wlc_phy_ipa_set_bbmult_nphy(pi, m[0], m[1]);
+		if ((ii + qq) < NPHY_MIN_RXIQ_PWR) {
+			bcmerror = -EBADE;
+			break;
+		}
 
-		phy_a2 = 63;
+		iq_nbits = wlc_phy_nbits(iq);
+		qq_nbits = wlc_phy_nbits(qq);
 
-		if (CHSPEC_IS2G(pi->radio_chanspec)) {
-			if ((pi->pubpi.radiorev == 4)
-			    || (pi->pubpi.radiorev == 6)) {
-				phy_a1 = 30;
-				phy_a3 = 30;
-			} else {
-				phy_a1 = 25;
-				phy_a3 = 25;
+		arsh = 10 - (30 - iq_nbits);
+		if (arsh >= 0) {
+			a = (-(iq << (30 - iq_nbits)) + (ii >> (1 + arsh)));
+			temp = (s32) (ii >> arsh);
+			if (temp == 0) {
+				bcmerror = -EBADE;
+				break;
 			}
 		} else {
-			if ((pi->pubpi.radiorev == 5)
-			    || (pi->pubpi.radiorev == 7)
-			    || (pi->pubpi.radiorev == 8)) {
-				phy_a1 = 25;
-				phy_a3 = 25;
-			} else {
-				phy_a1 = 35;
-				phy_a3 = 35;
+			a = (-(iq << (30 - iq_nbits)) + (ii << (-1 - arsh)));
+			temp = (s32) (ii << -arsh);
+			if (temp == 0) {
+				bcmerror = -EBADE;
+				break;
 			}
 		}
 
-		if (cal_mode == CAL_GCTRL) {
-			if ((pi->pubpi.radiorev == 5)
-			    && (CHSPEC_IS2G(pi->radio_chanspec)))
-				phy_a1 = 55;
-			else if (((pi->pubpi.radiorev == 7) &&
-				  (CHSPEC_IS2G(pi->radio_chanspec))) ||
-				 ((pi->pubpi.radiorev == 8) &&
-				  (CHSPEC_IS2G(pi->radio_chanspec))))
-				phy_a1 = 60;
-			else
-				phy_a1 = 63;
-
-		} else if ((cal_mode != CAL_FULL) && (cal_mode != CAL_SOFT)) {
+		a /= temp;
 
-			phy_a1 = 35;
-			phy_a3 = 35;
+		brsh = qq_nbits - 31 + 20;
+		if (brsh >= 0) {
+			b = (qq << (31 - qq_nbits));
+			temp = (s32) (ii >> brsh);
+			if (temp == 0) {
+				bcmerror = -EBADE;
+				break;
+			}
+		} else {
+			b = (qq << (31 - qq_nbits));
+			temp = (s32) (ii << -brsh);
+			if (temp == 0) {
+				bcmerror = -EBADE;
+				break;
+			}
 		}
+		b /= temp;
+		b -= a * a;
+		b = (s32) int_sqrt((unsigned long) b);
+		b -= (1 << 10);
 
-		mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x297 :
-			    0x29b, (0x1 << 0), (1) << 0);
-
-		mod_phy_reg(pi, (phy_a7 == PHY_CORE_0) ? 0x297 :
-			    0x29b, (0x1 << 0), (0) << 0);
+		if ((curr_core == PHY_CORE_0) && (core_mask & 0x1)) {
+			if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+				new_comp.a0 = (s16) a & 0x3ff;
+				new_comp.b0 = (s16) b & 0x3ff;
+			} else {
 
-		mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x2a3 :
-			    0x2a4, (0x1 << 13), (1) << 13);
+				new_comp.a0 = (s16) b & 0x3ff;
+				new_comp.b0 = (s16) a & 0x3ff;
+			}
+		}
+		if ((curr_core == PHY_CORE_1) && (core_mask & 0x2)) {
+			if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+				new_comp.a1 = (s16) a & 0x3ff;
+				new_comp.b1 = (s16) b & 0x3ff;
+			} else {
 
-		mod_phy_reg(pi, (phy_a7 == PHY_CORE_0) ? 0x2a3 :
-			    0x2a4, (0x1 << 13), (0) << 13);
+				new_comp.a1 = (s16) b & 0x3ff;
+				new_comp.b1 = (s16) a & 0x3ff;
+			}
+		}
+	}
 
-		write_phy_reg(pi, 0x2a1, 0x80);
-		write_phy_reg(pi, 0x2a2, 0x100);
+	if (bcmerror != 0) {
+		printk(KERN_DEBUG "%s: Failed, cnt = %d\n", __func__,
+		       cal_retry);
 
-		mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x2a3 :
-			    0x2a4, (0x7 << 4), (11) << 4);
+		if (cal_retry < CAL_RETRY_CNT) {
+			cal_retry++;
+			goto cal_try;
+		}
 
-		mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x2a3 :
-			    0x2a4, (0x7 << 8), (11) << 8);
+		new_comp = old_comp;
+	}
 
-		mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x2a3 :
-			    0x2a4, (0x7 << 0), (0x3) << 0);
+	wlc_phy_rx_iq_coeffs_nphy(pi, 1, &new_comp);
+}
 
-		write_phy_reg(pi, 0x2e5, 0x20);
+static void wlc_phy_rxcal_radio_setup_nphy(struct brcms_phy *pi, u8 rx_core)
+{
+	u16 offtune_val;
+	u16 bias_g = 0;
+	u16 bias_a = 0;
 
-		mod_phy_reg(pi, 0x2a0, (0x3f << 0), (phy_a3) << 0);
+	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+		if (rx_core == PHY_CORE_0) {
+			if (CHSPEC_IS5G(pi->radio_chanspec)) {
+				pi->tx_rx_cal_radio_saveregs[0] =
+					read_radio_reg(pi,
+					    RADIO_2057_TX0_TXRXCOUPLE_5G_PWRUP);
+				pi->tx_rx_cal_radio_saveregs[1] =
+					read_radio_reg(pi,
+					    RADIO_2057_TX0_TXRXCOUPLE_5G_ATTEN);
 
-		mod_phy_reg(pi, 0x29f, (0x3f << 0), (phy_a1) << 0);
+				write_radio_reg(pi,
+					RADIO_2057_TX0_TXRXCOUPLE_5G_PWRUP,
+					0x3);
+				write_radio_reg(pi,
+					RADIO_2057_TX0_TXRXCOUPLE_5G_ATTEN,
+					0xaf);
 
-		mod_phy_reg(pi, 0x29f, (0x3f << 8), (phy_a2) << 8);
+			} else {
+				pi->tx_rx_cal_radio_saveregs[0] =
+					read_radio_reg(pi,
+					    RADIO_2057_TX0_TXRXCOUPLE_2G_PWRUP);
+				pi->tx_rx_cal_radio_saveregs[1] =
+					read_radio_reg(pi,
+					    RADIO_2057_TX0_TXRXCOUPLE_2G_ATTEN);
 
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 3),
-						  1, ((core == 0) ? 1 : 2), 0,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID0);
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 3),
-						  0, ((core == 0) ? 2 : 1), 0,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID0);
+				write_radio_reg(
+					pi,
+					RADIO_2057_TX0_TXRXCOUPLE_2G_PWRUP,
+					0x3);
+				write_radio_reg(
+					pi,
+					RADIO_2057_TX0_TXRXCOUPLE_2G_ATTEN,
+					0x7f);
+			}
 
-		write_phy_reg(pi, 0x2be, 1);
-		SPINWAIT(read_phy_reg(pi, 0x2be), 10 * 1000 * 1000);
+		} else {
+			if (CHSPEC_IS5G(pi->radio_chanspec)) {
+				pi->tx_rx_cal_radio_saveregs[0] =
+					read_radio_reg(pi,
+					    RADIO_2057_TX1_TXRXCOUPLE_5G_PWRUP);
+				pi->tx_rx_cal_radio_saveregs[1] =
+					read_radio_reg(pi,
+					    RADIO_2057_TX1_TXRXCOUPLE_5G_ATTEN);
 
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 3),
-						  0, 0x3, 0,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID0);
+				write_radio_reg(
+					pi,
+					RADIO_2057_TX1_TXRXCOUPLE_5G_PWRUP,
+					0x3);
+				write_radio_reg(
+					pi,
+					RADIO_2057_TX1_TXRXCOUPLE_5G_ATTEN,
+					0xaf);
 
-		wlc_phy_table_write_nphy(pi,
-					 (core ==
-					  PHY_CORE_0) ? NPHY_TBL_ID_EPSILONTBL0
-					 : NPHY_TBL_ID_EPSILONTBL1, 1, phy_a3,
-					 32, &phy_a8);
+			} else {
+				pi->tx_rx_cal_radio_saveregs[0] =
+					read_radio_reg(pi,
+					    RADIO_2057_TX1_TXRXCOUPLE_2G_PWRUP);
+				pi->tx_rx_cal_radio_saveregs[1] =
+					read_radio_reg(pi,
+					    RADIO_2057_TX1_TXRXCOUPLE_2G_ATTEN);
 
-		if (cal_mode != CAL_GCTRL) {
-			if (CHSPEC_IS5G(pi->radio_chanspec))
-				wlc_phy_a1_nphy(pi, core, 5, 0, 35);
+				write_radio_reg(pi,
+					RADIO_2057_TX1_TXRXCOUPLE_2G_PWRUP,
+					0x3);
+				write_radio_reg(pi,
+					RADIO_2057_TX1_TXRXCOUPLE_2G_ATTEN,
+					0x7f);
+			}
 		}
 
-		wlc_phy_rfctrl_override_1tomany_nphy(
-			pi,
-			NPHY_REV7_RfctrlOverride_cmd_txgain,
-			phy_a5, (1 << core), 1);
-
 	} else {
+		if (rx_core == PHY_CORE_0) {
+			pi->tx_rx_cal_radio_saveregs[0] =
+				read_radio_reg(pi,
+					       RADIO_2056_TX_RXIQCAL_TXMUX |
+					       RADIO_2056_TX1);
+			pi->tx_rx_cal_radio_saveregs[1] =
+				read_radio_reg(pi,
+					       RADIO_2056_RX_RXIQCAL_RXMUX |
+					       RADIO_2056_RX0);
 
-		if (txgains) {
-			if (txgains->useindex) {
-				phy_a4 = 15 - ((txgains->index) >> 3);
-				if (CHSPEC_IS2G(pi->radio_chanspec)) {
-					if (NREV_GE(pi->pubpi.phy_rev, 6))
-						phy_a5 = 0x00f7 | (phy_a4 << 8);
-
-					else
-					if (NREV_IS(pi->pubpi.phy_rev, 5))
-						phy_a5 = 0x10f7 | (phy_a4 << 8);
-					else
-						phy_a5 = 0x50f7 | (phy_a4 << 8);
-				} else {
-					phy_a5 = 0x70f7 | (phy_a4 << 8);
-				}
-				wlc_phy_rfctrl_override_nphy(pi,
-							     (0x1 << 13),
-							     phy_a5,
-							     (1 << core), 0);
-			} else {
-				wlc_phy_rfctrl_override_nphy(pi,
-							     (0x1 << 13),
-							     0x5bf7,
-							     (1 << core), 0);
+			if (pi->pubpi.radiorev >= 5) {
+				pi->tx_rx_cal_radio_saveregs[2] =
+					read_radio_reg(pi,
+						       RADIO_2056_RX_RXSPARE2 |
+						       RADIO_2056_RX0);
+				pi->tx_rx_cal_radio_saveregs[3] =
+					read_radio_reg(pi,
+						       RADIO_2056_TX_TXSPARE2 |
+						       RADIO_2056_TX1);
 			}
-		}
 
-		if (CHSPEC_IS2G(pi->radio_chanspec))
-			m[core] = IS40MHZ(pi) ? 45 : 64;
-		else
-			m[core] = IS40MHZ(pi) ? 75 : 107;
+			if (CHSPEC_IS5G(pi->radio_chanspec)) {
 
-		m[phy_a7] = 0;
-		wlc_phy_ipa_set_bbmult_nphy(pi, m[0], m[1]);
+				if (pi->pubpi.radiorev >= 5) {
+					pi->tx_rx_cal_radio_saveregs[4] =
+						read_radio_reg(pi,
+						      RADIO_2056_RX_LNAA_MASTER
+						      | RADIO_2056_RX0);
 
-		phy_a2 = 63;
+					write_radio_reg(
+						pi,
+						RADIO_2056_RX_LNAA_MASTER
+						| RADIO_2056_RX0, 0x40);
 
-		if (cal_mode == CAL_FULL) {
-			phy_a1 = 25;
-			phy_a3 = 25;
-		} else if (cal_mode == CAL_SOFT) {
-			phy_a1 = 25;
-			phy_a3 = 25;
-		} else if (cal_mode == CAL_GCTRL) {
-			phy_a1 = 63;
-			phy_a3 = 25;
-		} else {
+					write_radio_reg(pi,
+						RADIO_2056_TX_TXSPARE2 |
+						RADIO_2056_TX1, bias_a);
 
-			phy_a1 = 25;
-			phy_a3 = 25;
-		}
+					write_radio_reg(pi,
+						RADIO_2056_RX_RXSPARE2 |
+						RADIO_2056_RX0, bias_a);
+				} else {
+					pi->tx_rx_cal_radio_saveregs[4] =
+						read_radio_reg(pi,
+							RADIO_2056_RX_LNAA_TUNE
+							| RADIO_2056_RX0);
 
-		mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x297 :
-			    0x29b, (0x1 << 0), (1) << 0);
+					offtune_val =
+						(pi->tx_rx_cal_radio_saveregs
+						 [2] & 0xF0) >> 8;
+					offtune_val =
+						(offtune_val <= 0x7) ? 0xF : 0;
 
-		mod_phy_reg(pi, (phy_a7 == PHY_CORE_0) ? 0x297 :
-			    0x29b, (0x1 << 0), (0) << 0);
+					mod_radio_reg(pi,
+						      RADIO_2056_RX_LNAA_TUNE |
+						      RADIO_2056_RX0, 0xF0,
+						      (offtune_val << 8));
+				}
 
-		if (NREV_GE(pi->pubpi.phy_rev, 6)) {
-			mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x2a3 :
-				    0x2a4, (0x1 << 13), (1) << 13);
+				write_radio_reg(pi,
+						RADIO_2056_TX_RXIQCAL_TXMUX |
+						RADIO_2056_TX1, 0x9);
+				write_radio_reg(pi,
+						RADIO_2056_RX_RXIQCAL_RXMUX |
+						RADIO_2056_RX0, 0x9);
+			} else {
+				if (pi->pubpi.radiorev >= 5) {
+					pi->tx_rx_cal_radio_saveregs[4] =
+						read_radio_reg(
+						      pi,
+						      RADIO_2056_RX_LNAG_MASTER
+						    | RADIO_2056_RX0);
 
-			mod_phy_reg(pi, (phy_a7 == PHY_CORE_0) ? 0x2a3 :
-				    0x2a4, (0x1 << 13), (0) << 13);
+					write_radio_reg(
+						pi,
+						RADIO_2056_RX_LNAG_MASTER
+						| RADIO_2056_RX0, 0x40);
+
+					write_radio_reg(
+						pi,
+						RADIO_2056_TX_TXSPARE2
+						|
+						RADIO_2056_TX1, bias_g);
+
+					write_radio_reg(
+						pi,
+						RADIO_2056_RX_RXSPARE2
+						|
+						RADIO_2056_RX0, bias_g);
 
-			write_phy_reg(pi, 0x2a1, 0x20);
-			write_phy_reg(pi, 0x2a2, 0x60);
+				} else {
+					pi->tx_rx_cal_radio_saveregs[4] =
+						read_radio_reg(
+							pi,
+							RADIO_2056_RX_LNAG_TUNE
+							| RADIO_2056_RX0);
 
-			mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x2a3 :
-				    0x2a4, (0xf << 4), (9) << 4);
+					offtune_val =
+						(pi->
+						 tx_rx_cal_radio_saveregs[2] &
+						 0xF0) >> 8;
+					offtune_val =
+						(offtune_val <= 0x7) ? 0xF : 0;
 
-			mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x2a3 :
-				    0x2a4, (0xf << 8), (9) << 8);
+					mod_radio_reg(pi,
+						      RADIO_2056_RX_LNAG_TUNE |
+						      RADIO_2056_RX0, 0xF0,
+						      (offtune_val << 8));
+				}
 
-			mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x2a3 :
-				    0x2a4, (0xf << 0), (0x2) << 0);
+				write_radio_reg(pi,
+						RADIO_2056_TX_RXIQCAL_TXMUX |
+						RADIO_2056_TX1, 0x6);
+				write_radio_reg(pi,
+						RADIO_2056_RX_RXIQCAL_RXMUX |
+						RADIO_2056_RX0, 0x6);
+			}
 
-			write_phy_reg(pi, 0x2e5, 0x20);
 		} else {
-			mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x2a3 :
-				    0x2a4, (0x1 << 11), (1) << 11);
+			pi->tx_rx_cal_radio_saveregs[0] =
+				read_radio_reg(pi,
+					       RADIO_2056_TX_RXIQCAL_TXMUX |
+					       RADIO_2056_TX0);
+			pi->tx_rx_cal_radio_saveregs[1] =
+				read_radio_reg(pi,
+					       RADIO_2056_RX_RXIQCAL_RXMUX |
+					       RADIO_2056_RX1);
 
-			mod_phy_reg(pi, (phy_a7 == PHY_CORE_0) ? 0x2a3 :
-				    0x2a4, (0x1 << 11), (0) << 11);
+			if (pi->pubpi.radiorev >= 5) {
+				pi->tx_rx_cal_radio_saveregs[2] =
+					read_radio_reg(pi,
+						       RADIO_2056_RX_RXSPARE2 |
+						       RADIO_2056_RX1);
+				pi->tx_rx_cal_radio_saveregs[3] =
+					read_radio_reg(pi,
+						       RADIO_2056_TX_TXSPARE2 |
+						       RADIO_2056_TX0);
+			}
 
-			write_phy_reg(pi, 0x2a1, 0x80);
-			write_phy_reg(pi, 0x2a2, 0x600);
+			if (CHSPEC_IS5G(pi->radio_chanspec)) {
 
-			mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x2a3 :
-				    0x2a4, (0x7 << 4), (0) << 4);
+				if (pi->pubpi.radiorev >= 5) {
+					pi->tx_rx_cal_radio_saveregs[4] =
+						read_radio_reg(
+						       pi,
+						       RADIO_2056_RX_LNAA_MASTER
+						       | RADIO_2056_RX1);
 
-			mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x2a3 :
-				    0x2a4, (0x7 << 8), (0) << 8);
+					write_radio_reg(
+						pi,
+						RADIO_2056_RX_LNAA_MASTER |
+						RADIO_2056_RX1, 0x40);
 
-			mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x2a3 :
-				    0x2a4, (0x7 << 0), (0x3) << 0);
+					write_radio_reg(
+						pi,
+						RADIO_2056_TX_TXSPARE2
+						|
+						RADIO_2056_TX0, bias_a);
 
-			mod_phy_reg(pi, 0x2a0, (0x3f << 8), (0x20) << 8);
+					write_radio_reg(
+						pi,
+						RADIO_2056_RX_RXSPARE2
+						|
+						RADIO_2056_RX1, bias_a);
+				} else {
+					pi->tx_rx_cal_radio_saveregs[4] =
+						read_radio_reg(
+							pi,
+							RADIO_2056_RX_LNAA_TUNE
+							| RADIO_2056_RX1);
 
-		}
+					offtune_val =
+						(pi->
+						 tx_rx_cal_radio_saveregs[2] &
+						 0xF0) >> 8;
+					offtune_val =
+						(offtune_val <= 0x7) ? 0xF : 0;
 
-		mod_phy_reg(pi, 0x2a0, (0x3f << 0), (phy_a3) << 0);
+					mod_radio_reg(pi,
+						      RADIO_2056_RX_LNAA_TUNE |
+						      RADIO_2056_RX1, 0xF0,
+						      (offtune_val << 8));
+				}
 
-		mod_phy_reg(pi, 0x29f, (0x3f << 0), (phy_a1) << 0);
+				write_radio_reg(pi,
+						RADIO_2056_TX_RXIQCAL_TXMUX |
+						RADIO_2056_TX0, 0x9);
+				write_radio_reg(pi,
+						RADIO_2056_RX_RXIQCAL_RXMUX |
+						RADIO_2056_RX1, 0x9);
+			} else {
+				if (pi->pubpi.radiorev >= 5) {
+					pi->tx_rx_cal_radio_saveregs[4] =
+						read_radio_reg(
+						      pi,
+						      RADIO_2056_RX_LNAG_MASTER
+						    | RADIO_2056_RX1);
 
-		mod_phy_reg(pi, 0x29f, (0x3f << 8), (phy_a2) << 8);
+					write_radio_reg(
+						pi,
+						RADIO_2056_RX_LNAG_MASTER
+						| RADIO_2056_RX1, 0x40);
 
-		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 3), 1, 0x3, 0);
+					write_radio_reg(
+						pi,
+						RADIO_2056_TX_TXSPARE2
+						|
+						RADIO_2056_TX0, bias_g);
 
-		write_phy_reg(pi, 0x2be, 1);
-		SPINWAIT(read_phy_reg(pi, 0x2be), 10 * 1000 * 1000);
+					write_radio_reg(
+						pi,
+						RADIO_2056_RX_RXSPARE2
+						|
+						RADIO_2056_RX1, bias_g);
+				} else {
+					pi->tx_rx_cal_radio_saveregs[4] =
+						read_radio_reg(
+							pi,
+							RADIO_2056_RX_LNAG_TUNE
+							| RADIO_2056_RX1);
 
-		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 3), 0, 0x3, 0);
+					offtune_val =
+						(pi->
+						 tx_rx_cal_radio_saveregs[2] &
+						 0xF0) >> 8;
+					offtune_val =
+						(offtune_val <= 0x7) ? 0xF : 0;
 
-		wlc_phy_table_write_nphy(pi,
-					 (core ==
-					  PHY_CORE_0) ? NPHY_TBL_ID_EPSILONTBL0
-					 : NPHY_TBL_ID_EPSILONTBL1, 1, phy_a3,
-					 32, &phy_a8);
+					mod_radio_reg(pi,
+						      RADIO_2056_RX_LNAG_TUNE |
+						      RADIO_2056_RX1, 0xF0,
+						      (offtune_val << 8));
+				}
 
-		if (cal_mode != CAL_GCTRL)
-			wlc_phy_a1_nphy(pi, core, 5, 0, 40);
+				write_radio_reg(pi,
+						RADIO_2056_TX_RXIQCAL_TXMUX |
+						RADIO_2056_TX0, 0x6);
+				write_radio_reg(pi,
+						RADIO_2056_RX_RXIQCAL_RXMUX |
+						RADIO_2056_RX1, 0x6);
+			}
+		}
 	}
 }
 
-static u8 wlc_phy_a3_nphy(struct brcms_phy *pi, u8 start_gain, u8 core)
+static void wlc_phy_rxcal_radio_cleanup_nphy(struct brcms_phy *pi, u8 rx_core)
 {
-	int phy_a1;
-	int phy_a2;
-	bool phy_a3;
-	struct nphy_ipa_txcalgains phy_a4;
-	bool phy_a5 = false;
-	bool phy_a6 = true;
-	s32 phy_a7, phy_a8;
-	u32 phy_a9;
-	int phy_a10;
-	bool phy_a11 = false;
-	int phy_a12;
-	u8 phy_a13 = 0;
-	u8 phy_a14;
-	u8 *phy_a15 = NULL;
-
-	phy_a4.useindex = true;
-	phy_a12 = start_gain;
-
 	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+		if (rx_core == PHY_CORE_0) {
+			if (CHSPEC_IS5G(pi->radio_chanspec)) {
+				write_radio_reg(
+					pi,
+					RADIO_2057_TX0_TXRXCOUPLE_5G_PWRUP,
+					pi->
+					tx_rx_cal_radio_saveregs[0]);
+				write_radio_reg(
+					pi,
+					RADIO_2057_TX0_TXRXCOUPLE_5G_ATTEN,
+					pi->
+					tx_rx_cal_radio_saveregs[1]);
 
-		phy_a2 = 20;
-		phy_a1 = 1;
+			} else {
+				write_radio_reg(
+					pi,
+					RADIO_2057_TX0_TXRXCOUPLE_2G_PWRUP,
+					pi->
+					tx_rx_cal_radio_saveregs[0]);
+				write_radio_reg(
+					pi,
+					RADIO_2057_TX0_TXRXCOUPLE_2G_ATTEN,
+					pi->
+					tx_rx_cal_radio_saveregs[1]);
+			}
 
-		if (CHSPEC_IS2G(pi->radio_chanspec)) {
-			if (pi->pubpi.radiorev == 5) {
+		} else {
+			if (CHSPEC_IS5G(pi->radio_chanspec)) {
+				write_radio_reg(
+					pi,
+					RADIO_2057_TX1_TXRXCOUPLE_5G_PWRUP,
+					pi->
+					tx_rx_cal_radio_saveregs[0]);
+				write_radio_reg(
+					pi,
+					RADIO_2057_TX1_TXRXCOUPLE_5G_ATTEN,
+					pi->
+					tx_rx_cal_radio_saveregs[1]);
 
-				phy_a15 = pad_gain_codes_used_2057rev5;
-				phy_a13 =
-					sizeof(pad_gain_codes_used_2057rev5) /
-					sizeof(pad_gain_codes_used_2057rev5
-						[0]) - 1;
+			} else {
+				write_radio_reg(
+					pi,
+					RADIO_2057_TX1_TXRXCOUPLE_2G_PWRUP,
+					pi->
+					tx_rx_cal_radio_saveregs[0]);
+				write_radio_reg(
+					pi,
+					RADIO_2057_TX1_TXRXCOUPLE_2G_ATTEN,
+					pi->
+					tx_rx_cal_radio_saveregs[1]);
+			}
+		}
+
+	} else {
+		if (rx_core == PHY_CORE_0) {
+			write_radio_reg(pi,
+					RADIO_2056_TX_RXIQCAL_TXMUX |
+					RADIO_2056_TX1,
+					pi->tx_rx_cal_radio_saveregs[0]);
 
-			} else if ((pi->pubpi.radiorev == 7)
-				   || (pi->pubpi.radiorev == 8)) {
+			write_radio_reg(pi,
+					RADIO_2056_RX_RXIQCAL_RXMUX |
+					RADIO_2056_RX0,
+					pi->tx_rx_cal_radio_saveregs[1]);
 
-				phy_a15 = pad_gain_codes_used_2057rev7;
-				phy_a13 =
-					sizeof(pad_gain_codes_used_2057rev7) /
-					sizeof(pad_gain_codes_used_2057rev7
-						[0]) - 1;
+			if (pi->pubpi.radiorev >= 5) {
+				write_radio_reg(pi,
+						RADIO_2056_RX_RXSPARE2 |
+						RADIO_2056_RX0,
+						pi->
+						tx_rx_cal_radio_saveregs[2]);
 
-			} else {
+				write_radio_reg(pi,
+						RADIO_2056_TX_TXSPARE2 |
+						RADIO_2056_TX1,
+						pi->
+						tx_rx_cal_radio_saveregs[3]);
+			}
 
-				phy_a15 = pad_all_gain_codes_2057;
-				phy_a13 = sizeof(pad_all_gain_codes_2057) /
-					  sizeof(pad_all_gain_codes_2057[0]) -
-					  1;
+			if (CHSPEC_IS5G(pi->radio_chanspec)) {
+				if (pi->pubpi.radiorev >= 5)
+					write_radio_reg(
+						pi,
+						RADIO_2056_RX_LNAA_MASTER
+						| RADIO_2056_RX0,
+						pi->
+						tx_rx_cal_radio_saveregs
+						[4]);
+				else
+					write_radio_reg(
+						pi,
+						RADIO_2056_RX_LNAA_TUNE
+						| RADIO_2056_RX0,
+						pi->
+						tx_rx_cal_radio_saveregs
+						[4]);
+			} else {
+				if (pi->pubpi.radiorev >= 5)
+					write_radio_reg(
+						pi,
+						RADIO_2056_RX_LNAG_MASTER
+						| RADIO_2056_RX0,
+						pi->
+						tx_rx_cal_radio_saveregs
+						[4]);
+				else
+					write_radio_reg(
+						pi,
+						RADIO_2056_RX_LNAG_TUNE
+						| RADIO_2056_RX0,
+						pi->
+						tx_rx_cal_radio_saveregs
+						[4]);
 			}
 
 		} else {
+			write_radio_reg(pi,
+					RADIO_2056_TX_RXIQCAL_TXMUX |
+					RADIO_2056_TX0,
+					pi->tx_rx_cal_radio_saveregs[0]);
 
-			phy_a15 = pga_all_gain_codes_2057;
-			phy_a13 = sizeof(pga_all_gain_codes_2057) /
-				  sizeof(pga_all_gain_codes_2057[0]) - 1;
-		}
-
-		phy_a14 = 0;
+			write_radio_reg(pi,
+					RADIO_2056_RX_RXIQCAL_RXMUX |
+					RADIO_2056_RX1,
+					pi->tx_rx_cal_radio_saveregs[1]);
 
-		for (phy_a10 = 0; phy_a10 < phy_a2; phy_a10++) {
-			if (CHSPEC_IS2G(pi->radio_chanspec))
-				phy_a4.gains.pad[core] =
-					(u16) phy_a15[phy_a12];
-			else
-				phy_a4.gains.pga[core] =
-					(u16) phy_a15[phy_a12];
+			if (pi->pubpi.radiorev >= 5) {
+				write_radio_reg(pi,
+						RADIO_2056_RX_RXSPARE2 |
+						RADIO_2056_RX1,
+						pi->
+						tx_rx_cal_radio_saveregs[2]);
 
-			wlc_phy_a2_nphy(pi, &phy_a4, CAL_GCTRL, core);
+				write_radio_reg(pi,
+						RADIO_2056_TX_TXSPARE2 |
+						RADIO_2056_TX0,
+						pi->
+						tx_rx_cal_radio_saveregs[3]);
+			}
 
-			wlc_phy_table_read_nphy(pi,
-						(core ==
-						 PHY_CORE_0 ?
-						 NPHY_TBL_ID_EPSILONTBL0 :
-						 NPHY_TBL_ID_EPSILONTBL1), 1,
-						63, 32, &phy_a9);
+			if (CHSPEC_IS5G(pi->radio_chanspec)) {
+				if (pi->pubpi.radiorev >= 5)
+					write_radio_reg(
+						pi,
+						RADIO_2056_RX_LNAA_MASTER
+						| RADIO_2056_RX1,
+						pi->
+						tx_rx_cal_radio_saveregs
+						[4]);
+				else
+					write_radio_reg(
+						pi,
+						RADIO_2056_RX_LNAA_TUNE
+						| RADIO_2056_RX1,
+						pi->
+						tx_rx_cal_radio_saveregs
+						[4]);
+			} else {
+				if (pi->pubpi.radiorev >= 5)
+					write_radio_reg(
+						pi,
+						RADIO_2056_RX_LNAG_MASTER
+						| RADIO_2056_RX1,
+						pi->
+						tx_rx_cal_radio_saveregs
+						[4]);
+				else
+					write_radio_reg(
+						pi,
+						RADIO_2056_RX_LNAG_TUNE
+						| RADIO_2056_RX1,
+						pi->
+						tx_rx_cal_radio_saveregs
+						[4]);
+			}
+		}
+	}
+}
 
-			wlc_phy_papd_decode_epsilon(phy_a9, &phy_a7, &phy_a8);
+static void wlc_phy_rxcal_physetup_nphy(struct brcms_phy *pi, u8 rx_core)
+{
+	u8 tx_core;
+	u16 rx_antval, tx_antval;
 
-			phy_a3 = ((phy_a7 == 4095) || (phy_a7 == -4096) ||
-				  (phy_a8 == 4095) || (phy_a8 == -4096));
+	if (NREV_GE(pi->pubpi.phy_rev, 7))
+		tx_core = rx_core;
+	else
+		tx_core = (rx_core == PHY_CORE_0) ? 1 : 0;
 
-			if (!phy_a6 && (phy_a3 != phy_a5)) {
-				if (!phy_a3)
-					phy_a12 -= (u8) phy_a1;
+	pi->tx_rx_cal_phy_saveregs[0] = read_phy_reg(pi, 0xa2);
+	pi->tx_rx_cal_phy_saveregs[1] =
+		read_phy_reg(pi, (rx_core == PHY_CORE_0) ? 0xa6 : 0xa7);
+	pi->tx_rx_cal_phy_saveregs[2] =
+		read_phy_reg(pi, (rx_core == PHY_CORE_0) ? 0x8f : 0xa5);
+	pi->tx_rx_cal_phy_saveregs[3] = read_phy_reg(pi, 0x91);
+	pi->tx_rx_cal_phy_saveregs[4] = read_phy_reg(pi, 0x92);
+	pi->tx_rx_cal_phy_saveregs[5] = read_phy_reg(pi, 0x7a);
+	pi->tx_rx_cal_phy_saveregs[6] = read_phy_reg(pi, 0x7d);
+	pi->tx_rx_cal_phy_saveregs[7] = read_phy_reg(pi, 0xe7);
+	pi->tx_rx_cal_phy_saveregs[8] = read_phy_reg(pi, 0xec);
+	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+		pi->tx_rx_cal_phy_saveregs[11] = read_phy_reg(pi, 0x342);
+		pi->tx_rx_cal_phy_saveregs[12] = read_phy_reg(pi, 0x343);
+		pi->tx_rx_cal_phy_saveregs[13] = read_phy_reg(pi, 0x346);
+		pi->tx_rx_cal_phy_saveregs[14] = read_phy_reg(pi, 0x347);
+	}
 
-				phy_a11 = true;
-				break;
-			}
+	pi->tx_rx_cal_phy_saveregs[9] = read_phy_reg(pi, 0x297);
+	pi->tx_rx_cal_phy_saveregs[10] = read_phy_reg(pi, 0x29b);
+	mod_phy_reg(pi, (0 == PHY_CORE_0) ? 0x297 :
+		    0x29b, (0x1 << 0), (0) << 0);
 
-			if (phy_a3)
-				phy_a12 += (u8) phy_a1;
-			else
-				phy_a12 -= (u8) phy_a1;
+	mod_phy_reg(pi, (1 == PHY_CORE_0) ? 0x297 :
+		    0x29b, (0x1 << 0), (0) << 0);
 
-			if ((phy_a12 < phy_a14) || (phy_a12 > phy_a13)) {
-				if (phy_a12 < phy_a14)
-					phy_a12 = phy_a14;
-				else
-					phy_a12 = phy_a13;
+	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 
-				phy_a11 = true;
-				break;
-			}
+		mod_phy_reg(pi, 0xa2, (0xf << 0), (1 << tx_core) << 0);
 
-			phy_a6 = false;
-			phy_a5 = phy_a3;
-		}
+		mod_phy_reg(pi, 0xa2, (0xf << 12), (1 << (1 - rx_core)) << 12);
 
 	} else {
-		phy_a2 = 10;
-		phy_a1 = 8;
-		for (phy_a10 = 0; phy_a10 < phy_a2; phy_a10++) {
-			phy_a4.index = (u8) phy_a12;
-			wlc_phy_a2_nphy(pi, &phy_a4, CAL_GCTRL, core);
 
-			wlc_phy_table_read_nphy(pi,
-						(core ==
-						 PHY_CORE_0 ?
-						 NPHY_TBL_ID_EPSILONTBL0 :
-						 NPHY_TBL_ID_EPSILONTBL1), 1,
-						63, 32, &phy_a9);
+		mod_phy_reg(pi, 0xa2, (0xf << 12), (1 << tx_core) << 12);
+		mod_phy_reg(pi, 0xa2, (0xf << 0), (1 << tx_core) << 0);
+		mod_phy_reg(pi, 0xa2, (0xf << 4), (1 << rx_core) << 4);
+		mod_phy_reg(pi, 0xa2, (0xf << 8), (1 << rx_core) << 8);
+	}
 
-			wlc_phy_papd_decode_epsilon(phy_a9, &phy_a7, &phy_a8);
+	mod_phy_reg(pi, ((rx_core == PHY_CORE_0) ? 0xa6 : 0xa7), (0x1 << 2), 0);
+	mod_phy_reg(pi, (rx_core == PHY_CORE_0) ? 0x8f : 0xa5,
+		    (0x1 << 2), (0x1 << 2));
+	if (NREV_LT(pi->pubpi.phy_rev, 7)) {
+		mod_phy_reg(pi, ((rx_core == PHY_CORE_0) ? 0xa6 : 0xa7),
+			    (0x1 << 0) | (0x1 << 1), 0);
+		mod_phy_reg(pi, (rx_core == PHY_CORE_0) ?
+			    0x8f : 0xa5,
+			    (0x1 << 0) | (0x1 << 1), (0x1 << 0) | (0x1 << 1));
+	}
 
-			phy_a3 = ((phy_a7 == 4095) || (phy_a7 == -4096) ||
-				  (phy_a8 == 4095) || (phy_a8 == -4096));
+	wlc_phy_rfctrlintc_override_nphy(pi, NPHY_RfctrlIntc_override_PA, 0,
+					 RADIO_MIMO_CORESEL_CORE1 |
+					 RADIO_MIMO_CORESEL_CORE2);
 
-			if (!phy_a6 && (phy_a3 != phy_a5)) {
-				if (!phy_a3)
-					phy_a12 -= (u8) phy_a1;
+	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 3),
+						  0, 0, 0,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID0);
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 9), 0, 0, 0,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 10), 1, 0, 0,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 0), 1, 0, 0,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 1), 1, 0, 0,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID2);
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 11), 0, 0, 0,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
+		if (CHSPEC_IS40(pi->radio_chanspec))
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi,
+				(0x1 << 7),
+				2, 0, 0,
+				NPHY_REV7_RFCTRLOVERRIDE_ID1);
+		else
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi,
+				(0x1 << 7),
+				0, 0, 0,
+				NPHY_REV7_RFCTRLOVERRIDE_ID1);
 
-				phy_a11 = true;
-				break;
-			}
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 7),
+						  0, 0, 0,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
+		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 5), 0, 0, 0,
+						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
+	} else {
+		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 3), 0, 3, 0);
+	}
 
-			if (phy_a3)
-				phy_a12 += (u8) phy_a1;
-			else
-				phy_a12 -= (u8) phy_a1;
+	wlc_phy_force_rfseq_nphy(pi, NPHY_RFSEQ_RX2TX);
 
-			if ((phy_a12 < 0) || (phy_a12 > 127)) {
-				if (phy_a12 < 0)
-					phy_a12 = 0;
-				else
-					phy_a12 = 127;
+	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 
-				phy_a11 = true;
-				break;
-			}
+		wlc_phy_rfctrlintc_override_nphy(pi,
+						 NPHY_RfctrlIntc_override_TRSW,
+						 0x1, rx_core + 1);
+	} else {
 
-			phy_a6 = false;
-			phy_a5 = phy_a3;
+		if (rx_core == PHY_CORE_0) {
+			rx_antval = 0x1;
+			tx_antval = 0x8;
+		} else {
+			rx_antval = 0x4;
+			tx_antval = 0x2;
 		}
 
+		wlc_phy_rfctrlintc_override_nphy(pi,
+						 NPHY_RfctrlIntc_override_TRSW,
+						 rx_antval, rx_core + 1);
+		wlc_phy_rfctrlintc_override_nphy(pi,
+						 NPHY_RfctrlIntc_override_TRSW,
+						 tx_antval, tx_core + 1);
 	}
-
-	if (NREV_GE(pi->pubpi.phy_rev, 7))
-		return (u8) phy_a15[phy_a12];
-	else
-		return (u8) phy_a12;
-
 }
 
-static void wlc_phy_a4(struct brcms_phy *pi, bool full_cal)
+static void wlc_phy_rxcal_phycleanup_nphy(struct brcms_phy *pi, u8 rx_core)
 {
-	struct nphy_ipa_txcalgains phy_b1[2];
-	struct nphy_papd_restore_state phy_b2;
-	bool phy_b3;
-	u8 phy_b4;
-	u8 phy_b5;
-	s16 phy_b6, phy_b7, phy_b8;
-	u16 phy_b9;
-	s16 phy_b10, phy_b11, phy_b12;
-
-	phy_b11 = 0;
-	phy_b12 = 0;
-	phy_b7 = 0;
-	phy_b8 = 0;
-	phy_b6 = 0;
-
-	if (pi->nphy_papd_skip == 1)
-		return;
 
-	phy_b3 = (0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
-	if (!phy_b3)
-		wlapi_suspend_mac_and_wait(pi->sh->physhim);
+	write_phy_reg(pi, 0xa2, pi->tx_rx_cal_phy_saveregs[0]);
+	write_phy_reg(pi, (rx_core == PHY_CORE_0) ? 0xa6 : 0xa7,
+		      pi->tx_rx_cal_phy_saveregs[1]);
+	write_phy_reg(pi, (rx_core == PHY_CORE_0) ? 0x8f : 0xa5,
+		      pi->tx_rx_cal_phy_saveregs[2]);
+	write_phy_reg(pi, 0x91, pi->tx_rx_cal_phy_saveregs[3]);
+	write_phy_reg(pi, 0x92, pi->tx_rx_cal_phy_saveregs[4]);
 
-	wlc_phy_stay_in_carriersearch_nphy(pi, true);
+	write_phy_reg(pi, 0x7a, pi->tx_rx_cal_phy_saveregs[5]);
+	write_phy_reg(pi, 0x7d, pi->tx_rx_cal_phy_saveregs[6]);
+	write_phy_reg(pi, 0xe7, pi->tx_rx_cal_phy_saveregs[7]);
+	write_phy_reg(pi, 0xec, pi->tx_rx_cal_phy_saveregs[8]);
+	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+		write_phy_reg(pi, 0x342, pi->tx_rx_cal_phy_saveregs[11]);
+		write_phy_reg(pi, 0x343, pi->tx_rx_cal_phy_saveregs[12]);
+		write_phy_reg(pi, 0x346, pi->tx_rx_cal_phy_saveregs[13]);
+		write_phy_reg(pi, 0x347, pi->tx_rx_cal_phy_saveregs[14]);
+	}
 
-	pi->nphy_force_papd_cal = false;
+	write_phy_reg(pi, 0x297, pi->tx_rx_cal_phy_saveregs[9]);
+	write_phy_reg(pi, 0x29b, pi->tx_rx_cal_phy_saveregs[10]);
+}
 
-	for (phy_b5 = 0; phy_b5 < pi->pubpi.phy_corenum; phy_b5++)
-		pi->nphy_papd_tx_gain_at_last_cal[phy_b5] =
-			wlc_phy_txpwr_idx_cur_get_nphy(pi, phy_b5);
+static void
+wlc_phy_rxcal_gainctrl_nphy_rev5(struct brcms_phy *pi, u8 rx_core,
+				 u16 *rxgain, u8 cal_type)
+{
 
-	pi->nphy_papd_last_cal = pi->sh->now;
-	pi->nphy_papd_recal_counter++;
+	u16 num_samps;
+	struct phy_iq_est est[PHY_CORE_MAX];
+	u8 tx_core;
+	struct nphy_iq_comp save_comp, zero_comp;
+	u32 i_pwr, q_pwr, curr_pwr, optim_pwr = 0, prev_pwr = 0,
+	    thresh_pwr = 10000;
+	s16 desired_log2_pwr, actual_log2_pwr, delta_pwr;
+	bool gainctrl_done = false;
+	u8 mix_tia_gain = 3;
+	s8 optim_gaintbl_index = 0, prev_gaintbl_index = 0;
+	s8 curr_gaintbl_index = 3;
+	u8 gainctrl_dirn = NPHY_RXCAL_GAIN_INIT;
+	struct nphy_ipa_txrxgain *nphy_rxcal_gaintbl;
+	u16 hpvga, lpf_biq1, lpf_biq0, lna2, lna1;
+	int fine_gain_idx;
+	s8 txpwrindex;
+	u16 nphy_rxcal_txgain[2];
 
-	phy_b4 = pi->nphy_txpwrctrl;
-	wlc_phy_txpwrctrl_enable_nphy(pi, PHY_TPC_HW_OFF);
+	if (NREV_GE(pi->pubpi.phy_rev, 7))
+		tx_core = rx_core;
+	else
+		tx_core = 1 - rx_core;
 
-	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_SCALARTBL0, 64, 0, 32,
-				 nphy_papd_scaltbl);
-	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_SCALARTBL1, 64, 0, 32,
-				 nphy_papd_scaltbl);
+	num_samps = 1024;
+	desired_log2_pwr = (cal_type == 0) ? 13 : 13;
 
-	phy_b9 = read_phy_reg(pi, 0x01);
-	mod_phy_reg(pi, 0x01, (0x1 << 15), 0);
+	wlc_phy_rx_iq_coeffs_nphy(pi, 0, &save_comp);
+	zero_comp.a0 = zero_comp.b0 = zero_comp.a1 = zero_comp.b1 = 0x0;
+	wlc_phy_rx_iq_coeffs_nphy(pi, 1, &zero_comp);
 
-	for (phy_b5 = 0; phy_b5 < pi->pubpi.phy_corenum; phy_b5++) {
-		s32 i, val = 0;
-		for (i = 0; i < 64; i++)
-			wlc_phy_table_write_nphy(pi,
-						 ((phy_b5 ==
-						   PHY_CORE_0) ?
-						  NPHY_TBL_ID_EPSILONTBL0 :
-						  NPHY_TBL_ID_EPSILONTBL1), 1,
-						 i, 32, &val);
+	if (CHSPEC_IS5G(pi->radio_chanspec)) {
+		if (NREV_GE(pi->pubpi.phy_rev, 7))
+			mix_tia_gain = 3;
+		else if (NREV_GE(pi->pubpi.phy_rev, 4))
+			mix_tia_gain = 4;
+		else
+			mix_tia_gain = 6;
+		if (NREV_GE(pi->pubpi.phy_rev, 7))
+			nphy_rxcal_gaintbl = nphy_ipa_rxcal_gaintbl_5GHz_rev7;
+		else
+			nphy_rxcal_gaintbl = nphy_ipa_rxcal_gaintbl_5GHz;
+	} else {
+		if (NREV_GE(pi->pubpi.phy_rev, 7))
+			nphy_rxcal_gaintbl = nphy_ipa_rxcal_gaintbl_2GHz_rev7;
+		else
+			nphy_rxcal_gaintbl = nphy_ipa_rxcal_gaintbl_2GHz;
 	}
 
-	wlc_phy_ipa_restore_tx_digi_filts_nphy(pi);
+	do {
 
-	phy_b2.mm = wlc_phy_ipa_get_bbmult_nphy(pi);
-	for (phy_b5 = 0; phy_b5 < pi->pubpi.phy_corenum; phy_b5++) {
-		wlc_phy_papd_cal_setup_nphy(pi, &phy_b2, phy_b5);
+		hpvga = (NREV_GE(pi->pubpi.phy_rev, 7)) ?
+			0 : nphy_rxcal_gaintbl[curr_gaintbl_index].hpvga;
+		lpf_biq1 = nphy_rxcal_gaintbl[curr_gaintbl_index].lpf_biq1;
+		lpf_biq0 = nphy_rxcal_gaintbl[curr_gaintbl_index].lpf_biq0;
+		lna2 = nphy_rxcal_gaintbl[curr_gaintbl_index].lna2;
+		lna1 = nphy_rxcal_gaintbl[curr_gaintbl_index].lna1;
+		txpwrindex = nphy_rxcal_gaintbl[curr_gaintbl_index].txpwrindex;
 
-		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-			if (CHSPEC_IS2G(pi->radio_chanspec)) {
-				if ((pi->pubpi.radiorev == 3)
-				    || (pi->pubpi.radiorev == 4)
-				    || (pi->pubpi.radiorev == 6)) {
-					pi->nphy_papd_cal_gain_index[phy_b5] =
-						23;
-				} else if (pi->pubpi.radiorev == 5) {
-					pi->nphy_papd_cal_gain_index[phy_b5] =
-						0;
-					pi->nphy_papd_cal_gain_index[phy_b5] =
-						wlc_phy_a3_nphy(
-							pi,
-							pi->
-							nphy_papd_cal_gain_index
-							[phy_b5],
-							phy_b5);
+		if (NREV_GE(pi->pubpi.phy_rev, 7))
+			wlc_phy_rfctrl_override_1tomany_nphy(
+				pi,
+				NPHY_REV7_RfctrlOverride_cmd_rxgain,
+				((lpf_biq1 << 12) |
+				 (lpf_biq0 << 8) |
+				 (mix_tia_gain << 4) | (lna2 << 2)
+				 | lna1), 0x3, 0);
+		else
+			wlc_phy_rfctrl_override_nphy(pi, (0x1 << 12),
+						     ((hpvga << 12) |
+						      (lpf_biq1 << 10) |
+						      (lpf_biq0 << 8) |
+						      (mix_tia_gain << 4) |
+						      (lna2 << 2) | lna1), 0x3,
+						     0);
 
-				} else if ((pi->pubpi.radiorev == 7)
-					   || (pi->pubpi.radiorev == 8)) {
+		pi->nphy_rxcal_pwr_idx[tx_core] = txpwrindex;
 
-					pi->nphy_papd_cal_gain_index[phy_b5] =
-						0;
-					pi->nphy_papd_cal_gain_index[phy_b5] =
-						wlc_phy_a3_nphy(
-							pi,
-							pi->
-							nphy_papd_cal_gain_index
-							[phy_b5],
-							phy_b5);
+		if (txpwrindex == -1) {
+			nphy_rxcal_txgain[0] = 0x8ff0 | pi->nphy_gmval;
+			nphy_rxcal_txgain[1] = 0x8ff0 | pi->nphy_gmval;
+			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ,
+						 2, 0x110, 16,
+						 nphy_rxcal_txgain);
+		} else {
+			wlc_phy_txpwr_index_nphy(pi, tx_core + 1, txpwrindex,
+						 false);
+		}
 
-				}
+		wlc_phy_tx_tone_nphy(pi, (CHSPEC_IS40(pi->radio_chanspec)) ?
+				     NPHY_RXCAL_TONEFREQ_40MHz :
+				     NPHY_RXCAL_TONEFREQ_20MHz,
+				     NPHY_RXCAL_TONEAMP, 0, cal_type, false);
 
-				phy_b1[phy_b5].gains.pad[phy_b5] =
-					pi->nphy_papd_cal_gain_index[phy_b5];
+		wlc_phy_rx_iq_est_nphy(pi, est, num_samps, 32, 0);
+		i_pwr = (est[rx_core].i_pwr + num_samps / 2) / num_samps;
+		q_pwr = (est[rx_core].q_pwr + num_samps / 2) / num_samps;
+		curr_pwr = i_pwr + q_pwr;
+
+		switch (gainctrl_dirn) {
+		case NPHY_RXCAL_GAIN_INIT:
+			if (curr_pwr > thresh_pwr) {
+				gainctrl_dirn = NPHY_RXCAL_GAIN_DOWN;
+				prev_gaintbl_index = curr_gaintbl_index;
+				curr_gaintbl_index--;
+			} else {
+				gainctrl_dirn = NPHY_RXCAL_GAIN_UP;
+				prev_gaintbl_index = curr_gaintbl_index;
+				curr_gaintbl_index++;
+			}
+			break;
 
+		case NPHY_RXCAL_GAIN_UP:
+			if (curr_pwr > thresh_pwr) {
+				gainctrl_done = true;
+				optim_pwr = prev_pwr;
+				optim_gaintbl_index = prev_gaintbl_index;
 			} else {
-				pi->nphy_papd_cal_gain_index[phy_b5] = 0;
-				pi->nphy_papd_cal_gain_index[phy_b5] =
-					wlc_phy_a3_nphy(
-						pi,
-						pi->
-						nphy_papd_cal_gain_index
-						[phy_b5], phy_b5);
-				phy_b1[phy_b5].gains.pga[phy_b5] =
-					pi->nphy_papd_cal_gain_index[phy_b5];
+				prev_gaintbl_index = curr_gaintbl_index;
+				curr_gaintbl_index++;
 			}
-		} else {
-			phy_b1[phy_b5].useindex = true;
-			phy_b1[phy_b5].index = 16;
-			phy_b1[phy_b5].index =
-				wlc_phy_a3_nphy(pi, phy_b1[phy_b5].index,
-						phy_b5);
-
-			pi->nphy_papd_cal_gain_index[phy_b5] =
-				15 - ((phy_b1[phy_b5].index) >> 3);
-		}
+			break;
 
-		switch (pi->nphy_papd_cal_type) {
-		case 0:
-			wlc_phy_a2_nphy(pi, &phy_b1[phy_b5], CAL_FULL, phy_b5);
+		case NPHY_RXCAL_GAIN_DOWN:
+			if (curr_pwr > thresh_pwr) {
+				prev_gaintbl_index = curr_gaintbl_index;
+				curr_gaintbl_index--;
+			} else {
+				gainctrl_done = true;
+				optim_pwr = curr_pwr;
+				optim_gaintbl_index = curr_gaintbl_index;
+			}
 			break;
-		case 1:
-			wlc_phy_a2_nphy(pi, &phy_b1[phy_b5], CAL_SOFT, phy_b5);
+
+		default:
 			break;
 		}
 
-		if (NREV_GE(pi->pubpi.phy_rev, 7))
-			wlc_phy_papd_cal_cleanup_nphy(pi, &phy_b2);
-	}
+		if ((curr_gaintbl_index < 0) ||
+		    (curr_gaintbl_index > NPHY_IPA_RXCAL_MAXGAININDEX)) {
+			gainctrl_done = true;
+			optim_pwr = curr_pwr;
+			optim_gaintbl_index = prev_gaintbl_index;
+		} else {
+			prev_pwr = curr_pwr;
+		}
 
-	if (NREV_LT(pi->pubpi.phy_rev, 7))
-		wlc_phy_papd_cal_cleanup_nphy(pi, &phy_b2);
+		wlc_phy_stopplayback_nphy(pi);
+	} while (!gainctrl_done);
 
-	for (phy_b5 = 0; phy_b5 < pi->pubpi.phy_corenum; phy_b5++) {
-		int eps_offset = 0;
+	hpvga = nphy_rxcal_gaintbl[optim_gaintbl_index].hpvga;
+	lpf_biq1 = nphy_rxcal_gaintbl[optim_gaintbl_index].lpf_biq1;
+	lpf_biq0 = nphy_rxcal_gaintbl[optim_gaintbl_index].lpf_biq0;
+	lna2 = nphy_rxcal_gaintbl[optim_gaintbl_index].lna2;
+	lna1 = nphy_rxcal_gaintbl[optim_gaintbl_index].lna1;
+	txpwrindex = nphy_rxcal_gaintbl[optim_gaintbl_index].txpwrindex;
 
-		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-			if (CHSPEC_IS2G(pi->radio_chanspec)) {
-				if (pi->pubpi.radiorev == 3)
-					eps_offset = -2;
-				else if (pi->pubpi.radiorev == 5)
-					eps_offset = 3;
-				else
-					eps_offset = -1;
-			} else {
-				eps_offset = 2;
-			}
+	actual_log2_pwr = wlc_phy_nbits(optim_pwr);
+	delta_pwr = desired_log2_pwr - actual_log2_pwr;
 
-			if (CHSPEC_IS2G(pi->radio_chanspec)) {
-				phy_b8 = phy_b1[phy_b5].gains.pad[phy_b5];
-				phy_b10 = 0;
-				if ((pi->pubpi.radiorev == 3) ||
-				    (pi->pubpi.radiorev == 4) ||
-				    (pi->pubpi.radiorev == 6)) {
-					phy_b12 = -(
-					    nphy_papd_padgain_dlt_2g_2057rev3n4
-							     [phy_b8] + 1) / 2;
-					phy_b10 = -1;
-				} else if (pi->pubpi.radiorev == 5) {
-					phy_b12 = -(
-					    nphy_papd_padgain_dlt_2g_2057rev5
-							     [phy_b8] + 1) / 2;
-				} else if ((pi->pubpi.radiorev == 7) ||
-					   (pi->pubpi.radiorev == 8)) {
-					phy_b12 = -(
-					    nphy_papd_padgain_dlt_2g_2057rev7
-							     [phy_b8] + 1) / 2;
-				}
-			} else {
-				phy_b7 = phy_b1[phy_b5].gains.pga[phy_b5];
-				if ((pi->pubpi.radiorev == 3) ||
-				    (pi->pubpi.radiorev == 4) ||
-				    (pi->pubpi.radiorev == 6))
-					phy_b11 =
-						-(nphy_papd_pgagain_dlt_5g_2057
-						  [phy_b7]
-						  + 1) / 2;
-				else if ((pi->pubpi.radiorev == 7)
-					 || (pi->pubpi.radiorev == 8))
-					phy_b11 = -(
-					      nphy_papd_pgagain_dlt_5g_2057rev7
-							     [phy_b7] + 1) / 2;
+	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+		fine_gain_idx = (int)lpf_biq1 + delta_pwr;
 
-				phy_b10 = -9;
-			}
+		if (fine_gain_idx + (int)lpf_biq0 > 10)
+			lpf_biq1 = 10 - lpf_biq0;
+		else
+			lpf_biq1 = (u16) max(fine_gain_idx, 0);
 
-			if (CHSPEC_IS2G(pi->radio_chanspec))
-				phy_b6 =
-					-60 + 27 + eps_offset + phy_b12 +
-					phy_b10;
-			else
-				phy_b6 =
-					-60 + 27 + eps_offset + phy_b11 +
-					phy_b10;
+		wlc_phy_rfctrl_override_1tomany_nphy(
+			pi,
+			NPHY_REV7_RfctrlOverride_cmd_rxgain,
+			((lpf_biq1 << 12) |
+			 (lpf_biq0 << 8) |
+			 (mix_tia_gain << 4) |
+			 (lna2 << 2) | lna1), 0x3,
+			0);
+	} else {
+		hpvga = (u16) max(min(((int)hpvga) + delta_pwr, 10), 0);
+		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 12),
+					     ((hpvga << 12) |
+					      (lpf_biq1 << 10) |
+					      (lpf_biq0 << 8) |
+					      (mix_tia_gain << 4) |
+					      (lna2 << 2) |
+					      lna1), 0x3, 0);
+	}
 
-			mod_phy_reg(pi, (phy_b5 == PHY_CORE_0) ? 0x298 :
-				    0x29c, (0x1ff << 7), (phy_b6) << 7);
+	if (rxgain != NULL) {
+		*rxgain++ = lna1;
+		*rxgain++ = lna2;
+		*rxgain++ = mix_tia_gain;
+		*rxgain++ = lpf_biq0;
+		*rxgain++ = lpf_biq1;
+		*rxgain = hpvga;
+	}
 
-			pi->nphy_papd_epsilon_offset[phy_b5] = phy_b6;
-		} else {
-			if (NREV_LT(pi->pubpi.phy_rev, 5))
-				eps_offset = 4;
-			else
-				eps_offset = 2;
+	wlc_phy_rx_iq_coeffs_nphy(pi, 1, &save_comp);
+}
 
-			phy_b7 = 15 - ((phy_b1[phy_b5].index) >> 3);
+static void
+wlc_phy_rxcal_gainctrl_nphy(struct brcms_phy *pi, u8 rx_core, u16 *rxgain,
+			    u8 cal_type)
+{
+	wlc_phy_rxcal_gainctrl_nphy_rev5(pi, rx_core, rxgain, cal_type);
+}
 
-			if (CHSPEC_IS2G(pi->radio_chanspec)) {
-				phy_b11 =
-					-(nphy_papd_pga_gain_delta_ipa_2g[
-						  phy_b7] +
-					  1) / 2;
-				phy_b10 = 0;
-			} else {
-				phy_b11 =
-					-(nphy_papd_pga_gain_delta_ipa_5g[
-						  phy_b7] +
-					  1) / 2;
-				phy_b10 = -9;
-			}
+static u8
+wlc_phy_rc_sweep_nphy(struct brcms_phy *pi, u8 core_idx, u8 loopback_type)
+{
+	u32 target_bws[2] = { 9500, 21000 };
+	u32 ref_tones[2] = { 3000, 6000 };
+	u32 target_bw, ref_tone;
 
-			phy_b6 = -60 + 27 + eps_offset + phy_b11 + phy_b10;
+	u32 target_pwr_ratios[2] = { 28606, 18468 };
+	u32 target_pwr_ratio, pwr_ratio, last_pwr_ratio = 0;
 
-			mod_phy_reg(pi, (phy_b5 == PHY_CORE_0) ? 0x298 :
-				    0x29c, (0x1ff << 7), (phy_b6) << 7);
+	u16 start_rccal_ovr_val = 128;
+	u16 txlpf_rccal_lpc_ovr_val = 128;
+	u16 rxlpf_rccal_hpc_ovr_val = 159;
 
-			pi->nphy_papd_epsilon_offset[phy_b5] = phy_b6;
-		}
-	}
+	u16 orig_txlpf_rccal_lpc_ovr_val;
+	u16 orig_rxlpf_rccal_hpc_ovr_val;
+	u16 radio_addr_offset_rx;
+	u16 radio_addr_offset_tx;
+	u16 orig_dcBypass;
+	u16 orig_RxStrnFilt40Num[6];
+	u16 orig_RxStrnFilt40Den[4];
+	u16 orig_rfctrloverride[2];
+	u16 orig_rfctrlauxreg[2];
+	u16 orig_rfctrlrssiothers;
+	u16 tx_lpf_bw = 4;
 
-	mod_phy_reg(pi, (0 == PHY_CORE_0) ? 0x297 :
-		    0x29b, (0x1 << 0), (NPHY_PAPD_COMP_ON) << 0);
+	u16 rx_lpf_bw, rx_lpf_bws[2] = { 2, 4 };
+	u16 lpf_hpc = 7, hpvga_hpc = 7;
 
-	mod_phy_reg(pi, (1 == PHY_CORE_0) ? 0x297 :
-		    0x29b, (0x1 << 0), (NPHY_PAPD_COMP_ON) << 0);
+	s8 rccal_stepsize;
+	u16 rccal_val, last_rccal_val = 0, best_rccal_val = 0;
+	u32 ref_iq_vals = 0, target_iq_vals = 0;
+	u16 num_samps, log_num_samps = 10;
+	struct phy_iq_est est[PHY_CORE_MAX];
 
-	if (NREV_GE(pi->pubpi.phy_rev, 6)) {
-		mod_phy_reg(pi, (0 == PHY_CORE_0) ? 0x2a3 :
-			    0x2a4, (0x1 << 13), (0) << 13);
+	if (NREV_GE(pi->pubpi.phy_rev, 7))
+		return 0;
 
-		mod_phy_reg(pi, (1 == PHY_CORE_0) ? 0x2a3 :
-			    0x2a4, (0x1 << 13), (0) << 13);
+	num_samps = (1 << log_num_samps);
 
+	if (CHSPEC_IS40(pi->radio_chanspec)) {
+		target_bw = target_bws[1];
+		target_pwr_ratio = target_pwr_ratios[1];
+		ref_tone = ref_tones[1];
+		rx_lpf_bw = rx_lpf_bws[1];
 	} else {
-		mod_phy_reg(pi, (0 == PHY_CORE_0) ? 0x2a3 :
-			    0x2a4, (0x1 << 11), (0) << 11);
-
-		mod_phy_reg(pi, (1 == PHY_CORE_0) ? 0x2a3 :
-			    0x2a4, (0x1 << 11), (0) << 11);
+		target_bw = target_bws[0];
+		target_pwr_ratio = target_pwr_ratios[0];
+		ref_tone = ref_tones[0];
+		rx_lpf_bw = rx_lpf_bws[0];
+	}
 
+	if (core_idx == 0) {
+		radio_addr_offset_rx = RADIO_2056_RX0;
+		radio_addr_offset_tx =
+			(loopback_type == 0) ? RADIO_2056_TX0 : RADIO_2056_TX1;
+	} else {
+		radio_addr_offset_rx = RADIO_2056_RX1;
+		radio_addr_offset_tx =
+			(loopback_type == 0) ? RADIO_2056_TX1 : RADIO_2056_TX0;
 	}
-	pi->nphy_papdcomp = NPHY_PAPD_COMP_ON;
 
-	write_phy_reg(pi, 0x01, phy_b9);
+	orig_txlpf_rccal_lpc_ovr_val =
+		read_radio_reg(pi,
+			       (RADIO_2056_TX_TXLPF_RCCAL |
+				radio_addr_offset_tx));
+	orig_rxlpf_rccal_hpc_ovr_val =
+		read_radio_reg(pi,
+			       (RADIO_2056_RX_RXLPF_RCCAL_HPC |
+				radio_addr_offset_rx));
 
-	wlc_phy_ipa_set_tx_digi_filts_nphy(pi);
+	orig_dcBypass = ((read_phy_reg(pi, 0x48) >> 8) & 1);
 
-	wlc_phy_txpwrctrl_enable_nphy(pi, phy_b4);
-	if (phy_b4 == PHY_TPC_HW_OFF) {
-		wlc_phy_txpwr_index_nphy(pi, (1 << 0),
-					 (s8) (pi->nphy_txpwrindex[0].
-					       index_internal), false);
-		wlc_phy_txpwr_index_nphy(pi, (1 << 1),
-					 (s8) (pi->nphy_txpwrindex[1].
-					       index_internal), false);
-	}
+	orig_RxStrnFilt40Num[0] = read_phy_reg(pi, 0x267);
+	orig_RxStrnFilt40Num[1] = read_phy_reg(pi, 0x268);
+	orig_RxStrnFilt40Num[2] = read_phy_reg(pi, 0x269);
+	orig_RxStrnFilt40Den[0] = read_phy_reg(pi, 0x26a);
+	orig_RxStrnFilt40Den[1] = read_phy_reg(pi, 0x26b);
+	orig_RxStrnFilt40Num[3] = read_phy_reg(pi, 0x26c);
+	orig_RxStrnFilt40Num[4] = read_phy_reg(pi, 0x26d);
+	orig_RxStrnFilt40Num[5] = read_phy_reg(pi, 0x26e);
+	orig_RxStrnFilt40Den[2] = read_phy_reg(pi, 0x26f);
+	orig_RxStrnFilt40Den[3] = read_phy_reg(pi, 0x270);
 
-	wlc_phy_stay_in_carriersearch_nphy(pi, false);
+	orig_rfctrloverride[0] = read_phy_reg(pi, 0xe7);
+	orig_rfctrloverride[1] = read_phy_reg(pi, 0xec);
+	orig_rfctrlauxreg[0] = read_phy_reg(pi, 0xf8);
+	orig_rfctrlauxreg[1] = read_phy_reg(pi, 0xfa);
+	orig_rfctrlrssiothers = read_phy_reg(pi, (core_idx == 0) ? 0x7a : 0x7d);
 
-	if (!phy_b3)
-		wlapi_enable_mac(pi->sh->physhim);
-}
+	write_radio_reg(pi, (RADIO_2056_TX_TXLPF_RCCAL | radio_addr_offset_tx),
+			txlpf_rccal_lpc_ovr_val);
 
-void wlc_phy_txpwr_fixpower_nphy(struct brcms_phy *pi)
-{
-	uint core;
-	u32 txgain;
-	u16 rad_gain, dac_gain, bbmult, m1m2;
-	u8 txpi[2], chan_freq_range;
-	s32 rfpwr_offset;
+	write_radio_reg(pi,
+			(RADIO_2056_RX_RXLPF_RCCAL_HPC | radio_addr_offset_rx),
+			rxlpf_rccal_hpc_ovr_val);
 
-	if (pi->phyhang_avoid)
-		wlc_phy_stay_in_carriersearch_nphy(pi, true);
+	mod_phy_reg(pi, 0x48, (0x1 << 8), (0x1 << 8));
 
-	if (pi->sh->sromrev < 4) {
-		txpi[0] = txpi[1] = 72;
-	} else {
+	write_phy_reg(pi, 0x267, 0x02d4);
+	write_phy_reg(pi, 0x268, 0x0000);
+	write_phy_reg(pi, 0x269, 0x0000);
+	write_phy_reg(pi, 0x26a, 0x0000);
+	write_phy_reg(pi, 0x26b, 0x0000);
+	write_phy_reg(pi, 0x26c, 0x02d4);
+	write_phy_reg(pi, 0x26d, 0x0000);
+	write_phy_reg(pi, 0x26e, 0x0000);
+	write_phy_reg(pi, 0x26f, 0x0000);
+	write_phy_reg(pi, 0x270, 0x0000);
 
-		chan_freq_range = wlc_phy_get_chan_freq_range_nphy(pi, 0);
-		switch (chan_freq_range) {
-		case WL_CHAN_FREQ_RANGE_2G:
-			txpi[0] = pi->nphy_txpid2g[0];
-			txpi[1] = pi->nphy_txpid2g[1];
-			break;
-		case WL_CHAN_FREQ_RANGE_5GL:
-			txpi[0] = pi->nphy_txpid5gl[0];
-			txpi[1] = pi->nphy_txpid5gl[1];
-			break;
-		case WL_CHAN_FREQ_RANGE_5GM:
-			txpi[0] = pi->nphy_txpid5g[0];
-			txpi[1] = pi->nphy_txpid5g[1];
-			break;
-		case WL_CHAN_FREQ_RANGE_5GH:
-			txpi[0] = pi->nphy_txpid5gh[0];
-			txpi[1] = pi->nphy_txpid5gh[1];
-			break;
-		default:
-			txpi[0] = txpi[1] = 91;
-			break;
-		}
-	}
+	or_phy_reg(pi, (core_idx == 0) ? 0xe7 : 0xec, (0x1 << 8));
+	or_phy_reg(pi, (core_idx == 0) ? 0xec : 0xe7, (0x1 << 15));
+	or_phy_reg(pi, (core_idx == 0) ? 0xe7 : 0xec, (0x1 << 9));
+	or_phy_reg(pi, (core_idx == 0) ? 0xe7 : 0xec, (0x1 << 10));
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7))
-		txpi[0] = txpi[1] = 30;
-	else if (NREV_GE(pi->pubpi.phy_rev, 3))
-		txpi[0] = txpi[1] = 40;
+	mod_phy_reg(pi, (core_idx == 0) ? 0xfa : 0xf8,
+		    (0x7 << 10), (tx_lpf_bw << 10));
+	mod_phy_reg(pi, (core_idx == 0) ? 0xf8 : 0xfa,
+		    (0x7 << 0), (hpvga_hpc << 0));
+	mod_phy_reg(pi, (core_idx == 0) ? 0xf8 : 0xfa,
+		    (0x7 << 4), (lpf_hpc << 4));
+	mod_phy_reg(pi, (core_idx == 0) ? 0x7a : 0x7d,
+		    (0x7 << 8), (rx_lpf_bw << 8));
 
-	if (NREV_LT(pi->pubpi.phy_rev, 7)) {
+	rccal_stepsize = 16;
+	rccal_val = start_rccal_ovr_val + rccal_stepsize;
 
-		if ((txpi[0] < 40) || (txpi[0] > 100) ||
-		    (txpi[1] < 40) || (txpi[1] > 100))
-			txpi[0] = txpi[1] = 91;
-	}
+	while (rccal_stepsize >= 0) {
+		write_radio_reg(pi,
+				(RADIO_2056_RX_RXLPF_RCCAL_LPC |
+				 radio_addr_offset_rx), rccal_val);
 
-	pi->nphy_txpwrindex[PHY_CORE_0].index_internal = txpi[0];
-	pi->nphy_txpwrindex[PHY_CORE_1].index_internal = txpi[1];
-	pi->nphy_txpwrindex[PHY_CORE_0].index_internal_save = txpi[0];
-	pi->nphy_txpwrindex[PHY_CORE_1].index_internal_save = txpi[1];
+		if (rccal_stepsize == 16) {
 
-	for (core = 0; core < pi->pubpi.phy_corenum; core++) {
-		uint phyrev = pi->pubpi.phy_rev;
+			wlc_phy_tx_tone_nphy(pi, ref_tone, NPHY_RXCAL_TONEAMP,
+					     0, 1, false);
+			udelay(2);
 
-		if (NREV_GE(phyrev, 3)) {
-			if (PHY_IPA(pi)) {
-				u32 *tx_gaintbl =
-					wlc_phy_get_ipa_gaintbl_nphy(pi);
-				txgain = tx_gaintbl[txpi[core]];
-			} else {
-				if (CHSPEC_IS5G(pi->radio_chanspec)) {
-					if (NREV_IS(phyrev, 3)) {
-						txgain =
-						      nphy_tpc_5GHz_txgain_rev3
-								   [txpi[core]];
-					} else if (NREV_IS(phyrev, 4)) {
-						txgain = (
-						  pi->srom_fem5g.extpagain ==
-						  3) ?
-						  nphy_tpc_5GHz_txgain_HiPwrEPA
-						 [txpi[core]] :
-						 nphy_tpc_5GHz_txgain_rev4
-						 [txpi[core]];
-					} else {
-						txgain =
-						      nphy_tpc_5GHz_txgain_rev5
-								   [txpi[core]];
-					}
-				} else {
-					if (NREV_GE(phyrev, 5) &&
-					    (pi->srom_fem2g.extpagain == 3)) {
-						txgain =
-							nphy_tpc_txgain_HiPwrEPA
-							[txpi[core]];
-					} else {
-						txgain = nphy_tpc_txgain_rev3
-							 [txpi[core]];
-					}
-				}
-			}
-		} else {
-			txgain = nphy_tpc_txgain[txpi[core]];
-		}
+			wlc_phy_rx_iq_est_nphy(pi, est, num_samps, 32, 0);
 
-		if (NREV_GE(phyrev, 3))
-			rad_gain = (txgain >> 16) & ((1 << (32 - 16 + 1)) - 1);
-		else
-			rad_gain = (txgain >> 16) & ((1 << (28 - 16 + 1)) - 1);
+			if (core_idx == 0)
+				ref_iq_vals =
+					max_t(u32, (est[0].i_pwr +
+						    est[0].q_pwr) >>
+					      (log_num_samps + 1),
+					      1);
+			else
+				ref_iq_vals =
+					max_t(u32, (est[1].i_pwr +
+						    est[1].q_pwr) >>
+					      (log_num_samps + 1),
+					      1);
 
-		if (NREV_GE(phyrev, 7))
-			dac_gain = (txgain >> 8) & ((1 << (10 - 8 + 1)) - 1);
-		else
-			dac_gain = (txgain >> 8) & ((1 << (13 - 8 + 1)) - 1);
+			wlc_phy_tx_tone_nphy(pi, target_bw, NPHY_RXCAL_TONEAMP,
+					     0, 1, false);
+			udelay(2);
+		}
 
-		bbmult = (txgain >> 0) & ((1 << (7 - 0 + 1)) - 1);
+		wlc_phy_rx_iq_est_nphy(pi, est, num_samps, 32, 0);
 
-		if (NREV_GE(phyrev, 3))
-			mod_phy_reg(pi, ((core == PHY_CORE_0) ? 0x8f :
-					 0xa5), (0x1 << 8), (0x1 << 8));
+		if (core_idx == 0)
+			target_iq_vals = (est[0].i_pwr + est[0].q_pwr) >>
+					 (log_num_samps + 1);
 		else
-			mod_phy_reg(pi, 0xa5, (0x1 << 14), (0x1 << 14));
-
-		write_phy_reg(pi, (core == PHY_CORE_0) ? 0xaa : 0xab, dac_gain);
-
-		wlc_phy_table_write_nphy(pi, 7, 1, (0x110 + core), 16,
-					 &rad_gain);
+			target_iq_vals =
+				(est[1].i_pwr +
+				 est[1].q_pwr) >> (log_num_samps + 1);
 
-		wlc_phy_table_read_nphy(pi, 15, 1, 87, 16, &m1m2);
-		m1m2 &= ((core == PHY_CORE_0) ? 0x00ff : 0xff00);
-		m1m2 |= ((core == PHY_CORE_0) ? (bbmult << 8) : (bbmult << 0));
-		wlc_phy_table_write_nphy(pi, 15, 1, 87, 16, &m1m2);
+		pwr_ratio = (uint) ((target_iq_vals << 16) / ref_iq_vals);
 
-		if (PHY_IPA(pi)) {
-			wlc_phy_table_read_nphy(pi,
-						(core ==
-						 PHY_CORE_0 ?
-						 NPHY_TBL_ID_CORE1TXPWRCTL :
-						 NPHY_TBL_ID_CORE2TXPWRCTL), 1,
-						576 + txpi[core], 32,
-						&rfpwr_offset);
+		if (rccal_stepsize == 0)
+			rccal_stepsize--;
+		else if (rccal_stepsize == 1) {
+			last_rccal_val = rccal_val;
+			rccal_val += (pwr_ratio > target_pwr_ratio) ? 1 : -1;
+			last_pwr_ratio = pwr_ratio;
+			rccal_stepsize--;
+		} else {
+			rccal_stepsize = (rccal_stepsize >> 1);
+			rccal_val += ((pwr_ratio > target_pwr_ratio) ?
+				      rccal_stepsize : (-rccal_stepsize));
+		}
 
-			mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x297 :
-				    0x29b, (0x1ff << 4),
-				    ((s16) rfpwr_offset) << 4);
+		if (rccal_stepsize == -1) {
+			best_rccal_val =
+				(ABS((int)last_pwr_ratio -
+				     (int)target_pwr_ratio) <
+				 ABS((int)pwr_ratio -
+				     (int)target_pwr_ratio)) ? last_rccal_val :
+				rccal_val;
 
-			mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x297 :
-				    0x29b, (0x1 << 2), (1) << 2);
+			if (CHSPEC_IS40(pi->radio_chanspec)) {
+				if ((best_rccal_val > 140)
+				    || (best_rccal_val < 135))
+					best_rccal_val = 138;
+			} else {
+				if ((best_rccal_val > 142)
+				    || (best_rccal_val < 137))
+					best_rccal_val = 140;
+			}
 
+			write_radio_reg(pi,
+					(RADIO_2056_RX_RXLPF_RCCAL_LPC |
+					 radio_addr_offset_rx), best_rccal_val);
 		}
 	}
 
-	and_phy_reg(pi, 0xbf, (u16) (~(0x1f << 0)));
+	wlc_phy_stopplayback_nphy(pi);
 
-	if (pi->phyhang_avoid)
-		wlc_phy_stay_in_carriersearch_nphy(pi, false);
-}
+	write_radio_reg(pi, (RADIO_2056_TX_TXLPF_RCCAL | radio_addr_offset_tx),
+			orig_txlpf_rccal_lpc_ovr_val);
+	write_radio_reg(pi,
+			(RADIO_2056_RX_RXLPF_RCCAL_HPC | radio_addr_offset_rx),
+			orig_rxlpf_rccal_hpc_ovr_val);
 
-static void
-wlc_phy_txpwr_nphy_srom_convert(u8 *srom_max, u16 *pwr_offset,
-				u8 tmp_max_pwr, u8 rate_start,
-				u8 rate_end)
-{
-	u8 rate;
-	u8 word_num, nibble_num;
-	u8 tmp_nibble;
+	mod_phy_reg(pi, 0x48, (0x1 << 8), (orig_dcBypass << 8));
 
-	for (rate = rate_start; rate <= rate_end; rate++) {
-		word_num = (rate - rate_start) >> 2;
-		nibble_num = (rate - rate_start) & 0x3;
-		tmp_nibble = (pwr_offset[word_num] >> 4 * nibble_num) & 0xf;
+	write_phy_reg(pi, 0x267, orig_RxStrnFilt40Num[0]);
+	write_phy_reg(pi, 0x268, orig_RxStrnFilt40Num[1]);
+	write_phy_reg(pi, 0x269, orig_RxStrnFilt40Num[2]);
+	write_phy_reg(pi, 0x26a, orig_RxStrnFilt40Den[0]);
+	write_phy_reg(pi, 0x26b, orig_RxStrnFilt40Den[1]);
+	write_phy_reg(pi, 0x26c, orig_RxStrnFilt40Num[3]);
+	write_phy_reg(pi, 0x26d, orig_RxStrnFilt40Num[4]);
+	write_phy_reg(pi, 0x26e, orig_RxStrnFilt40Num[5]);
+	write_phy_reg(pi, 0x26f, orig_RxStrnFilt40Den[2]);
+	write_phy_reg(pi, 0x270, orig_RxStrnFilt40Den[3]);
 
-		srom_max[rate] = tmp_max_pwr - 2 * tmp_nibble;
-	}
-}
+	write_phy_reg(pi, 0xe7, orig_rfctrloverride[0]);
+	write_phy_reg(pi, 0xec, orig_rfctrloverride[1]);
+	write_phy_reg(pi, 0xf8, orig_rfctrlauxreg[0]);
+	write_phy_reg(pi, 0xfa, orig_rfctrlauxreg[1]);
+	write_phy_reg(pi, (core_idx == 0) ? 0x7a : 0x7d, orig_rfctrlrssiothers);
 
-static void
-wlc_phy_txpwr_nphy_po_apply(u8 *srom_max, u8 pwr_offset,
-			    u8 rate_start, u8 rate_end)
-{
-	u8 rate;
+	pi->nphy_anarxlpf_adjusted = false;
 
-	for (rate = rate_start; rate <= rate_end; rate++)
-		srom_max[rate] -= 2 * pwr_offset;
+	return best_rccal_val - 0x80;
 }
 
-void
-wlc_phy_ofdm_to_mcs_powers_nphy(u8 *power, u8 rate_mcs_start,
-				u8 rate_mcs_end, u8 rate_ofdm_start)
+#define WAIT_FOR_SCOPE  4000
+static int wlc_phy_cal_rxiq_nphy_rev3(struct brcms_phy *pi,
+				      struct nphy_txgains target_gain,
+				      u8 cal_type, bool debug)
 {
-	u8 rate1, rate2;
+	u16 orig_BBConfig;
+	u8 core_no, rx_core;
+	u8 best_rccal[2];
+	u16 gain_save[2];
+	u16 cal_gain[2];
+	struct nphy_iqcal_params cal_params[2];
+	u8 rxcore_state;
+	s8 rxlpf_rccal_hpc, txlpf_rccal_lpc;
+	s8 txlpf_idac;
+	bool phyhang_avoid_state = false;
+	bool skip_rxiqcal = false;
 
-	rate2 = rate_ofdm_start;
-	for (rate1 = rate_mcs_start; rate1 <= rate_mcs_end - 1; rate1++) {
-		power[rate1] = power[rate2];
-		rate2 += (rate1 == rate_mcs_start) ? 2 : 1;
-	}
-	power[rate_mcs_end] = power[rate_mcs_end - 1];
-}
+	orig_BBConfig = read_phy_reg(pi, 0x01);
+	mod_phy_reg(pi, 0x01, (0x1 << 15), 0);
 
-void
-wlc_phy_mcs_to_ofdm_powers_nphy(u8 *power, u8 rate_ofdm_start,
-				u8 rate_ofdm_end, u8 rate_mcs_start)
-{
-	u8 rate1, rate2;
+	wlc_phy_stay_in_carriersearch_nphy(pi, true);
 
-	for (rate1 = rate_ofdm_start, rate2 = rate_mcs_start;
-	     rate1 <= rate_ofdm_end; rate1++, rate2++) {
-		power[rate1] = power[rate2];
-		if (rate1 == rate_ofdm_start)
-			power[++rate1] = power[rate2];
+	if (NREV_GE(pi->pubpi.phy_rev, 4)) {
+		phyhang_avoid_state = pi->phyhang_avoid;
+		pi->phyhang_avoid = false;
 	}
-}
-
-void wlc_phy_txpwr_apply_nphy(struct brcms_phy *pi)
-{
-	uint rate1, rate2, band_num;
-	u8 tmp_bw40po = 0, tmp_cddpo = 0, tmp_stbcpo = 0;
-	u8 tmp_max_pwr = 0;
-	u16 pwr_offsets1[2], *pwr_offsets2 = NULL;
-	u8 *tx_srom_max_rate = NULL;
-
-	for (band_num = 0; band_num < (CH_2G_GROUP + CH_5G_GROUP);
-	     band_num++) {
-		switch (band_num) {
-		case 0:
-
-			tmp_max_pwr = min(pi->nphy_pwrctrl_info[0].max_pwr_2g,
-					  pi->nphy_pwrctrl_info[1].max_pwr_2g);
-
-			pwr_offsets1[0] = pi->cck2gpo;
-			wlc_phy_txpwr_nphy_srom_convert(pi->tx_srom_max_rate_2g,
-							pwr_offsets1,
-							tmp_max_pwr,
-							TXP_FIRST_CCK,
-							TXP_LAST_CCK);
 
-			pwr_offsets1[0] = (u16) (pi->ofdm2gpo & 0xffff);
-			pwr_offsets1[1] =
-				(u16) (pi->ofdm2gpo >> 16) & 0xffff;
+	wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x110, 16, gain_save);
 
-			pwr_offsets2 = pi->mcs2gpo;
+	for (core_no = 0; core_no <= 1; core_no++) {
+		wlc_phy_iqcal_gainparams_nphy(pi, core_no, target_gain,
+					      &cal_params[core_no]);
+		cal_gain[core_no] = cal_params[core_no].cal_gain;
+	}
 
-			tmp_cddpo = pi->cdd2gpo;
-			tmp_stbcpo = pi->stbc2gpo;
-			tmp_bw40po = pi->bw402gpo;
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x110, 16, cal_gain);
 
-			tx_srom_max_rate = pi->tx_srom_max_rate_2g;
-			break;
-		case 1:
+	rxcore_state = wlc_phy_rxcore_getstate_nphy(
+		(struct brcms_phy_pub *) pi);
 
-			tmp_max_pwr = min(pi->nphy_pwrctrl_info[0].max_pwr_5gm,
-					  pi->nphy_pwrctrl_info[1].max_pwr_5gm);
+	for (rx_core = 0; rx_core < pi->pubpi.phy_corenum; rx_core++) {
 
-			pwr_offsets1[0] = (u16) (pi->ofdm5gpo & 0xffff);
-			pwr_offsets1[1] =
-				(u16) (pi->ofdm5gpo >> 16) & 0xffff;
+		skip_rxiqcal =
+			((rxcore_state & (1 << rx_core)) == 0) ? true : false;
 
-			pwr_offsets2 = pi->mcs5gpo;
+		wlc_phy_rxcal_physetup_nphy(pi, rx_core);
 
-			tmp_cddpo = pi->cdd5gpo;
-			tmp_stbcpo = pi->stbc5gpo;
-			tmp_bw40po = pi->bw405gpo;
+		wlc_phy_rxcal_radio_setup_nphy(pi, rx_core);
 
-			tx_srom_max_rate = pi->tx_srom_max_rate_5g_mid;
-			break;
-		case 2:
+		if ((!skip_rxiqcal) && ((cal_type == 0) || (cal_type == 2))) {
 
-			tmp_max_pwr = min(pi->nphy_pwrctrl_info[0].max_pwr_5gl,
-					  pi->nphy_pwrctrl_info[1].max_pwr_5gl);
+			wlc_phy_rxcal_gainctrl_nphy(pi, rx_core, NULL, 0);
 
-			pwr_offsets1[0] = (u16) (pi->ofdm5glpo & 0xffff);
-			pwr_offsets1[1] =
-				(u16) (pi->ofdm5glpo >> 16) & 0xffff;
+			wlc_phy_tx_tone_nphy(pi,
+					     (CHSPEC_IS40(
+						      pi->radio_chanspec)) ?
+					     NPHY_RXCAL_TONEFREQ_40MHz :
+					     NPHY_RXCAL_TONEFREQ_20MHz,
+					     NPHY_RXCAL_TONEAMP, 0, cal_type,
+					     false);
 
-			pwr_offsets2 = pi->mcs5glpo;
+			if (debug)
+				mdelay(WAIT_FOR_SCOPE);
 
-			tmp_cddpo = pi->cdd5glpo;
-			tmp_stbcpo = pi->stbc5glpo;
-			tmp_bw40po = pi->bw405glpo;
+			wlc_phy_calc_rx_iq_comp_nphy(pi, rx_core + 1);
+			wlc_phy_stopplayback_nphy(pi);
+		}
 
-			tx_srom_max_rate = pi->tx_srom_max_rate_5g_low;
-			break;
-		case 3:
+		if (((cal_type == 1) || (cal_type == 2))
+		    && NREV_LT(pi->pubpi.phy_rev, 7)) {
 
-			tmp_max_pwr = min(pi->nphy_pwrctrl_info[0].max_pwr_5gh,
-					  pi->nphy_pwrctrl_info[1].max_pwr_5gh);
+			if (rx_core == PHY_CORE_1) {
 
-			pwr_offsets1[0] = (u16) (pi->ofdm5ghpo & 0xffff);
-			pwr_offsets1[1] =
-				(u16) (pi->ofdm5ghpo >> 16) & 0xffff;
+				if (rxcore_state == 1)
+					wlc_phy_rxcore_setstate_nphy(
+						(struct brcms_phy_pub *) pi, 3);
 
-			pwr_offsets2 = pi->mcs5ghpo;
+				wlc_phy_rxcal_gainctrl_nphy(pi, rx_core, NULL,
+							    1);
 
-			tmp_cddpo = pi->cdd5ghpo;
-			tmp_stbcpo = pi->stbc5ghpo;
-			tmp_bw40po = pi->bw405ghpo;
+				best_rccal[rx_core] =
+					wlc_phy_rc_sweep_nphy(pi, rx_core, 1);
+				pi->nphy_rccal_value = best_rccal[rx_core];
 
-			tx_srom_max_rate = pi->tx_srom_max_rate_5g_hi;
-			break;
+				if (rxcore_state == 1)
+					wlc_phy_rxcore_setstate_nphy(
+						(struct brcms_phy_pub *) pi,
+						rxcore_state);
+			}
 		}
 
-		wlc_phy_txpwr_nphy_srom_convert(tx_srom_max_rate, pwr_offsets1,
-						tmp_max_pwr, TXP_FIRST_OFDM,
-						TXP_LAST_OFDM);
+		wlc_phy_rxcal_radio_cleanup_nphy(pi, rx_core);
 
-		wlc_phy_ofdm_to_mcs_powers_nphy(tx_srom_max_rate,
-						TXP_FIRST_MCS_20_SISO,
-						TXP_LAST_MCS_20_SISO,
-						TXP_FIRST_OFDM);
+		wlc_phy_rxcal_phycleanup_nphy(pi, rx_core);
+		wlc_phy_force_rfseq_nphy(pi, NPHY_RFSEQ_RESET2RX);
+	}
 
-		wlc_phy_txpwr_nphy_srom_convert(tx_srom_max_rate, pwr_offsets2,
-						tmp_max_pwr,
-						TXP_FIRST_MCS_20_CDD,
-						TXP_LAST_MCS_20_CDD);
+	if ((cal_type == 1) || (cal_type == 2)) {
 
-		if (NREV_GE(pi->pubpi.phy_rev, 3))
-			wlc_phy_txpwr_nphy_po_apply(tx_srom_max_rate, tmp_cddpo,
-						    TXP_FIRST_MCS_20_CDD,
-						    TXP_LAST_MCS_20_CDD);
+		best_rccal[0] = best_rccal[1];
+		write_radio_reg(pi,
+				(RADIO_2056_RX_RXLPF_RCCAL_LPC |
+				 RADIO_2056_RX0), (best_rccal[0] | 0x80));
 
-		wlc_phy_mcs_to_ofdm_powers_nphy(tx_srom_max_rate,
-						TXP_FIRST_OFDM_20_CDD,
-						TXP_LAST_OFDM_20_CDD,
-						TXP_FIRST_MCS_20_CDD);
+		for (rx_core = 0; rx_core < pi->pubpi.phy_corenum; rx_core++) {
+			rxlpf_rccal_hpc =
+				(((int)best_rccal[rx_core] - 12) >> 1) + 10;
+			txlpf_rccal_lpc = ((int)best_rccal[rx_core] - 12) + 10;
 
-		wlc_phy_txpwr_nphy_srom_convert(tx_srom_max_rate, pwr_offsets2,
-						tmp_max_pwr,
-						TXP_FIRST_MCS_20_STBC,
-						TXP_LAST_MCS_20_STBC);
+			if (PHY_IPA(pi)) {
+				txlpf_rccal_lpc += IS40MHZ(pi) ? 24 : 12;
+				txlpf_idac = IS40MHZ(pi) ? 0x0e : 0x13;
+				WRITE_RADIO_REG2(pi, RADIO_2056, TX, rx_core,
+						 TXLPF_IDAC_4, txlpf_idac);
+			}
 
-		if (NREV_GE(pi->pubpi.phy_rev, 3))
-			wlc_phy_txpwr_nphy_po_apply(tx_srom_max_rate,
-						    tmp_stbcpo,
-						    TXP_FIRST_MCS_20_STBC,
-						    TXP_LAST_MCS_20_STBC);
+			rxlpf_rccal_hpc = max(min_t(u8, rxlpf_rccal_hpc, 31),
+					      0);
+			txlpf_rccal_lpc = max(min_t(u8, txlpf_rccal_lpc, 31),
+					      0);
 
-		wlc_phy_txpwr_nphy_srom_convert(tx_srom_max_rate,
-						&pwr_offsets2[2], tmp_max_pwr,
-						TXP_FIRST_MCS_20_SDM,
-						TXP_LAST_MCS_20_SDM);
+			write_radio_reg(pi, (RADIO_2056_RX_RXLPF_RCCAL_HPC |
+					     ((rx_core ==
+					       PHY_CORE_0) ? RADIO_2056_RX0 :
+					      RADIO_2056_RX1)),
+					(rxlpf_rccal_hpc | 0x80));
 
-		if (NPHY_IS_SROM_REINTERPRET) {
+			write_radio_reg(pi, (RADIO_2056_TX_TXLPF_RCCAL |
+					     ((rx_core ==
+					       PHY_CORE_0) ? RADIO_2056_TX0 :
+					      RADIO_2056_TX1)),
+					(txlpf_rccal_lpc | 0x80));
+		}
+	}
 
-			wlc_phy_txpwr_nphy_srom_convert(tx_srom_max_rate,
-							&pwr_offsets2[4],
-							tmp_max_pwr,
-							TXP_FIRST_MCS_40_SISO,
-							TXP_LAST_MCS_40_SISO);
+	write_phy_reg(pi, 0x01, orig_BBConfig);
 
-			wlc_phy_mcs_to_ofdm_powers_nphy(tx_srom_max_rate,
-							TXP_FIRST_OFDM_40_SISO,
-							TXP_LAST_OFDM_40_SISO,
-							TXP_FIRST_MCS_40_SISO);
+	wlc_phy_resetcca_nphy(pi);
 
-			wlc_phy_txpwr_nphy_srom_convert(tx_srom_max_rate,
-							&pwr_offsets2[4],
-							tmp_max_pwr,
-							TXP_FIRST_MCS_40_CDD,
-							TXP_LAST_MCS_40_CDD);
+	if (NREV_GE(pi->pubpi.phy_rev, 7))
+		wlc_phy_rfctrl_override_1tomany_nphy(
+			pi,
+			NPHY_REV7_RfctrlOverride_cmd_rxgain,
+			0, 0x3, 1);
+	else
+		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 12), 0, 0x3, 1);
 
-			wlc_phy_txpwr_nphy_po_apply(tx_srom_max_rate, tmp_cddpo,
-						    TXP_FIRST_MCS_40_CDD,
-						    TXP_LAST_MCS_40_CDD);
+	wlc_phy_force_rfseq_nphy(pi, NPHY_RFSEQ_RESET2RX);
 
-			wlc_phy_mcs_to_ofdm_powers_nphy(tx_srom_max_rate,
-							TXP_FIRST_OFDM_40_CDD,
-							TXP_LAST_OFDM_40_CDD,
-							TXP_FIRST_MCS_40_CDD);
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x110, 16,
+				 gain_save);
 
-			wlc_phy_txpwr_nphy_srom_convert(tx_srom_max_rate,
-							&pwr_offsets2[4],
-							tmp_max_pwr,
-							TXP_FIRST_MCS_40_STBC,
-							TXP_LAST_MCS_40_STBC);
+	if (NREV_GE(pi->pubpi.phy_rev, 4))
+		pi->phyhang_avoid = phyhang_avoid_state;
 
-			wlc_phy_txpwr_nphy_po_apply(tx_srom_max_rate,
-						    tmp_stbcpo,
-						    TXP_FIRST_MCS_40_STBC,
-						    TXP_LAST_MCS_40_STBC);
+	wlc_phy_stay_in_carriersearch_nphy(pi, false);
 
-			wlc_phy_txpwr_nphy_srom_convert(tx_srom_max_rate,
-							&pwr_offsets2[6],
-							tmp_max_pwr,
-							TXP_FIRST_MCS_40_SDM,
-							TXP_LAST_MCS_40_SDM);
-		} else {
+	return 0;
+}
 
-			for (rate1 = TXP_FIRST_OFDM_40_SISO, rate2 =
-				     TXP_FIRST_OFDM;
-			     rate1 <= TXP_LAST_MCS_40_SDM;
-			     rate1++, rate2++)
-				tx_srom_max_rate[rate1] =
-					tx_srom_max_rate[rate2];
-		}
+static int
+wlc_phy_cal_rxiq_nphy_rev2(struct brcms_phy *pi,
+			   struct nphy_txgains target_gain, bool debug)
+{
+	struct phy_iq_est est[PHY_CORE_MAX];
+	u8 core_num, rx_core, tx_core;
+	u16 lna_vals[] = { 0x3, 0x3, 0x1 };
+	u16 hpf1_vals[] = { 0x7, 0x2, 0x0 };
+	u16 hpf2_vals[] = { 0x2, 0x0, 0x0 };
+	s16 curr_hpf1, curr_hpf2, curr_hpf, curr_lna;
+	s16 desired_log2_pwr, actual_log2_pwr, hpf_change;
+	u16 orig_RfseqCoreActv, orig_AfectrlCore, orig_AfectrlOverride;
+	u16 orig_RfctrlIntcRx, orig_RfctrlIntcTx;
+	u16 num_samps;
+	u32 i_pwr, q_pwr, tot_pwr[3];
+	u8 gain_pass, use_hpf_num;
+	u16 mask, val1, val2;
+	u16 core_no;
+	u16 gain_save[2];
+	u16 cal_gain[2];
+	struct nphy_iqcal_params cal_params[2];
+	u8 phy_bw;
+	int bcmerror = 0;
+	bool first_playtone = true;
 
-		if (NREV_GE(pi->pubpi.phy_rev, 3))
-			wlc_phy_txpwr_nphy_po_apply(tx_srom_max_rate,
-						    tmp_bw40po,
-						    TXP_FIRST_OFDM_40_SISO,
-						    TXP_LAST_MCS_40_SDM);
+	wlc_phy_stay_in_carriersearch_nphy(pi, true);
 
-		tx_srom_max_rate[TXP_MCS_32] =
-			tx_srom_max_rate[TXP_FIRST_MCS_40_CDD];
-	}
+	if (NREV_LT(pi->pubpi.phy_rev, 2))
+		wlc_phy_reapply_txcal_coeffs_nphy(pi);
 
-	return;
-}
+	wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x110, 16, gain_save);
 
-static void wlc_phy_txpwr_srom_read_ppr_nphy(struct brcms_phy *pi)
-{
-	u16 bw40po, cddpo, stbcpo, bwduppo;
-	uint band_num;
+	for (core_no = 0; core_no <= 1; core_no++) {
+		wlc_phy_iqcal_gainparams_nphy(pi, core_no, target_gain,
+					      &cal_params[core_no]);
+		cal_gain[core_no] = cal_params[core_no].cal_gain;
+	}
 
-	if (pi->sh->sromrev >= 9)
-		return;
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x110, 16, cal_gain);
 
-	bw40po = (u16) PHY_GETINTVAR(pi, "bw40po");
-	pi->bw402gpo = bw40po & 0xf;
-	pi->bw405gpo = (bw40po & 0xf0) >> 4;
-	pi->bw405glpo = (bw40po & 0xf00) >> 8;
-	pi->bw405ghpo = (bw40po & 0xf000) >> 12;
+	num_samps = 1024;
+	desired_log2_pwr = 13;
 
-	cddpo = (u16) PHY_GETINTVAR(pi, "cddpo");
-	pi->cdd2gpo = cddpo & 0xf;
-	pi->cdd5gpo = (cddpo & 0xf0) >> 4;
-	pi->cdd5glpo = (cddpo & 0xf00) >> 8;
-	pi->cdd5ghpo = (cddpo & 0xf000) >> 12;
+	for (core_num = 0; core_num < 2; core_num++) {
 
-	stbcpo = (u16) PHY_GETINTVAR(pi, "stbcpo");
-	pi->stbc2gpo = stbcpo & 0xf;
-	pi->stbc5gpo = (stbcpo & 0xf0) >> 4;
-	pi->stbc5glpo = (stbcpo & 0xf00) >> 8;
-	pi->stbc5ghpo = (stbcpo & 0xf000) >> 12;
+		rx_core = core_num;
+		tx_core = 1 - core_num;
 
-	bwduppo = (u16) PHY_GETINTVAR(pi, "bwduppo");
-	pi->bwdup2gpo = bwduppo & 0xf;
-	pi->bwdup5gpo = (bwduppo & 0xf0) >> 4;
-	pi->bwdup5glpo = (bwduppo & 0xf00) >> 8;
-	pi->bwdup5ghpo = (bwduppo & 0xf000) >> 12;
+		orig_RfseqCoreActv = read_phy_reg(pi, 0xa2);
+		orig_AfectrlCore = read_phy_reg(pi, (rx_core == PHY_CORE_0) ?
+						0xa6 : 0xa7);
+		orig_AfectrlOverride = read_phy_reg(pi, 0xa5);
+		orig_RfctrlIntcRx = read_phy_reg(pi, (rx_core == PHY_CORE_0) ?
+						 0x91 : 0x92);
+		orig_RfctrlIntcTx = read_phy_reg(pi, (tx_core == PHY_CORE_0) ?
+						 0x91 : 0x92);
 
-	for (band_num = 0; band_num < (CH_2G_GROUP + CH_5G_GROUP);
-	     band_num++) {
-		switch (band_num) {
-		case 0:
+		mod_phy_reg(pi, 0xa2, (0xf << 12), (1 << tx_core) << 12);
+		mod_phy_reg(pi, 0xa2, (0xf << 0), (1 << tx_core) << 0);
 
-			pi->nphy_txpid2g[PHY_CORE_0] =
-				(u8) PHY_GETINTVAR(pi, "txpid2ga0");
-			pi->nphy_txpid2g[PHY_CORE_1] =
-				(u8) PHY_GETINTVAR(pi, "txpid2ga1");
-			pi->nphy_pwrctrl_info[PHY_CORE_0].max_pwr_2g =
-				(s8) PHY_GETINTVAR(pi, "maxp2ga0");
-			pi->nphy_pwrctrl_info[PHY_CORE_1].max_pwr_2g =
-				(s8) PHY_GETINTVAR(pi, "maxp2ga1");
-			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_2g_a1 =
-				(s16) PHY_GETINTVAR(pi, "pa2gw0a0");
-			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_2g_a1 =
-				(s16) PHY_GETINTVAR(pi, "pa2gw0a1");
-			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_2g_b0 =
-				(s16) PHY_GETINTVAR(pi, "pa2gw1a0");
-			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_2g_b0 =
-				(s16) PHY_GETINTVAR(pi, "pa2gw1a1");
-			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_2g_b1 =
-				(s16) PHY_GETINTVAR(pi, "pa2gw2a0");
-			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_2g_b1 =
-				(s16) PHY_GETINTVAR(pi, "pa2gw2a1");
-			pi->nphy_pwrctrl_info[PHY_CORE_0].idle_targ_2g =
-				(s8) PHY_GETINTVAR(pi, "itt2ga0");
-			pi->nphy_pwrctrl_info[PHY_CORE_1].idle_targ_2g =
-				(s8) PHY_GETINTVAR(pi, "itt2ga1");
+		or_phy_reg(pi, ((rx_core == PHY_CORE_0) ? 0xa6 : 0xa7),
+			   ((0x1 << 1) | (0x1 << 2)));
+		or_phy_reg(pi, 0xa5, ((0x1 << 1) | (0x1 << 2)));
 
-			pi->cck2gpo = (u16) PHY_GETINTVAR(pi, "cck2gpo");
+		if (((pi->nphy_rxcalparams) & 0xff000000))
+			write_phy_reg(pi,
+				      (rx_core == PHY_CORE_0) ? 0x91 : 0x92,
+				      (CHSPEC_IS5G(pi->radio_chanspec) ?
+					0x140 : 0x110));
+		else
+			write_phy_reg(pi,
+				      (rx_core == PHY_CORE_0) ? 0x91 : 0x92,
+				      (CHSPEC_IS5G(pi->radio_chanspec) ?
+				       0x180 : 0x120));
 
-			pi->ofdm2gpo = (u32) PHY_GETINTVAR(pi, "ofdm2gpo");
+		write_phy_reg(pi, (tx_core == PHY_CORE_0) ? 0x91 : 0x92,
+			      (CHSPEC_IS5G(pi->radio_chanspec) ? 0x148 :
+			       0x114));
 
-			pi->mcs2gpo[0] = (u16) PHY_GETINTVAR(pi, "mcs2gpo0");
-			pi->mcs2gpo[1] = (u16) PHY_GETINTVAR(pi, "mcs2gpo1");
-			pi->mcs2gpo[2] = (u16) PHY_GETINTVAR(pi, "mcs2gpo2");
-			pi->mcs2gpo[3] = (u16) PHY_GETINTVAR(pi, "mcs2gpo3");
-			pi->mcs2gpo[4] = (u16) PHY_GETINTVAR(pi, "mcs2gpo4");
-			pi->mcs2gpo[5] = (u16) PHY_GETINTVAR(pi, "mcs2gpo5");
-			pi->mcs2gpo[6] = (u16) PHY_GETINTVAR(pi, "mcs2gpo6");
-			pi->mcs2gpo[7] = (u16) PHY_GETINTVAR(pi, "mcs2gpo7");
-			break;
-		case 1:
+		mask = RADIO_2055_COUPLE_RX_MASK | RADIO_2055_COUPLE_TX_MASK;
+		if (rx_core == PHY_CORE_0) {
+			val1 = RADIO_2055_COUPLE_RX_MASK;
+			val2 = RADIO_2055_COUPLE_TX_MASK;
+		} else {
+			val1 = RADIO_2055_COUPLE_TX_MASK;
+			val2 = RADIO_2055_COUPLE_RX_MASK;
+		}
 
-			pi->nphy_txpid5g[PHY_CORE_0] =
-				(u8) PHY_GETINTVAR(pi, "txpid5ga0");
-			pi->nphy_txpid5g[PHY_CORE_1] =
-				(u8) PHY_GETINTVAR(pi, "txpid5ga1");
-			pi->nphy_pwrctrl_info[PHY_CORE_0].max_pwr_5gm =
-				(s8) PHY_GETINTVAR(pi, "maxp5ga0");
-			pi->nphy_pwrctrl_info[PHY_CORE_1].max_pwr_5gm =
-				(s8) PHY_GETINTVAR(pi, "maxp5ga1");
-			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_5gm_a1 =
-				(s16) PHY_GETINTVAR(pi, "pa5gw0a0");
-			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_5gm_a1 =
-				(s16) PHY_GETINTVAR(pi, "pa5gw0a1");
-			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_5gm_b0 =
-				(s16) PHY_GETINTVAR(pi, "pa5gw1a0");
-			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_5gm_b0 =
-				(s16) PHY_GETINTVAR(pi, "pa5gw1a1");
-			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_5gm_b1 =
-				(s16) PHY_GETINTVAR(pi, "pa5gw2a0");
-			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_5gm_b1 =
-				(s16) PHY_GETINTVAR(pi, "pa5gw2a1");
-			pi->nphy_pwrctrl_info[PHY_CORE_0].idle_targ_5gm =
-				(s8) PHY_GETINTVAR(pi, "itt5ga0");
-			pi->nphy_pwrctrl_info[PHY_CORE_1].idle_targ_5gm =
-				(s8) PHY_GETINTVAR(pi, "itt5ga1");
+		if ((pi->nphy_rxcalparams & 0x10000)) {
+			mod_radio_reg(pi, RADIO_2055_CORE1_GEN_SPARE2, mask,
+				      val1);
+			mod_radio_reg(pi, RADIO_2055_CORE2_GEN_SPARE2, mask,
+				      val2);
+		}
 
-			pi->ofdm5gpo = (u32) PHY_GETINTVAR(pi, "ofdm5gpo");
+		for (gain_pass = 0; gain_pass < 4; gain_pass++) {
 
-			pi->mcs5gpo[0] = (u16) PHY_GETINTVAR(pi, "mcs5gpo0");
-			pi->mcs5gpo[1] = (u16) PHY_GETINTVAR(pi, "mcs5gpo1");
-			pi->mcs5gpo[2] = (u16) PHY_GETINTVAR(pi, "mcs5gpo2");
-			pi->mcs5gpo[3] = (u16) PHY_GETINTVAR(pi, "mcs5gpo3");
-			pi->mcs5gpo[4] = (u16) PHY_GETINTVAR(pi, "mcs5gpo4");
-			pi->mcs5gpo[5] = (u16) PHY_GETINTVAR(pi, "mcs5gpo5");
-			pi->mcs5gpo[6] = (u16) PHY_GETINTVAR(pi, "mcs5gpo6");
-			pi->mcs5gpo[7] = (u16) PHY_GETINTVAR(pi, "mcs5gpo7");
-			break;
-		case 2:
+			if (debug)
+				mdelay(WAIT_FOR_SCOPE);
 
-			pi->nphy_txpid5gl[0] =
-				(u8) PHY_GETINTVAR(pi, "txpid5gla0");
-			pi->nphy_txpid5gl[1] =
-				(u8) PHY_GETINTVAR(pi, "txpid5gla1");
-			pi->nphy_pwrctrl_info[0].max_pwr_5gl =
-				(s8) PHY_GETINTVAR(pi, "maxp5gla0");
-			pi->nphy_pwrctrl_info[1].max_pwr_5gl =
-				(s8) PHY_GETINTVAR(pi, "maxp5gla1");
-			pi->nphy_pwrctrl_info[0].pwrdet_5gl_a1 =
-				(s16) PHY_GETINTVAR(pi, "pa5glw0a0");
-			pi->nphy_pwrctrl_info[1].pwrdet_5gl_a1 =
-				(s16) PHY_GETINTVAR(pi, "pa5glw0a1");
-			pi->nphy_pwrctrl_info[0].pwrdet_5gl_b0 =
-				(s16) PHY_GETINTVAR(pi, "pa5glw1a0");
-			pi->nphy_pwrctrl_info[1].pwrdet_5gl_b0 =
-				(s16) PHY_GETINTVAR(pi, "pa5glw1a1");
-			pi->nphy_pwrctrl_info[0].pwrdet_5gl_b1 =
-				(s16) PHY_GETINTVAR(pi, "pa5glw2a0");
-			pi->nphy_pwrctrl_info[1].pwrdet_5gl_b1 =
-				(s16) PHY_GETINTVAR(pi, "pa5glw2a1");
-			pi->nphy_pwrctrl_info[0].idle_targ_5gl = 0;
-			pi->nphy_pwrctrl_info[1].idle_targ_5gl = 0;
+			if (gain_pass < 3) {
+				curr_lna = lna_vals[gain_pass];
+				curr_hpf1 = hpf1_vals[gain_pass];
+				curr_hpf2 = hpf2_vals[gain_pass];
+			} else {
 
-			pi->ofdm5glpo = (u32) PHY_GETINTVAR(pi, "ofdm5glpo");
+				if (tot_pwr[1] > 10000) {
+					curr_lna = lna_vals[2];
+					curr_hpf1 = hpf1_vals[2];
+					curr_hpf2 = hpf2_vals[2];
+					use_hpf_num = 1;
+					curr_hpf = curr_hpf1;
+					actual_log2_pwr =
+						wlc_phy_nbits(tot_pwr[2]);
+				} else {
+					if (tot_pwr[0] > 10000) {
+						curr_lna = lna_vals[1];
+						curr_hpf1 = hpf1_vals[1];
+						curr_hpf2 = hpf2_vals[1];
+						use_hpf_num = 1;
+						curr_hpf = curr_hpf1;
+						actual_log2_pwr =
+							wlc_phy_nbits(
+								tot_pwr[1]);
+					} else {
+						curr_lna = lna_vals[0];
+						curr_hpf1 = hpf1_vals[0];
+						curr_hpf2 = hpf2_vals[0];
+						use_hpf_num = 2;
+						curr_hpf = curr_hpf2;
+						actual_log2_pwr =
+							wlc_phy_nbits(
+								tot_pwr[0]);
+					}
+				}
 
-			pi->mcs5glpo[0] =
-				(u16) PHY_GETINTVAR(pi, "mcs5glpo0");
-			pi->mcs5glpo[1] =
-				(u16) PHY_GETINTVAR(pi, "mcs5glpo1");
-			pi->mcs5glpo[2] =
-				(u16) PHY_GETINTVAR(pi, "mcs5glpo2");
-			pi->mcs5glpo[3] =
-				(u16) PHY_GETINTVAR(pi, "mcs5glpo3");
-			pi->mcs5glpo[4] =
-				(u16) PHY_GETINTVAR(pi, "mcs5glpo4");
-			pi->mcs5glpo[5] =
-				(u16) PHY_GETINTVAR(pi, "mcs5glpo5");
-			pi->mcs5glpo[6] =
-				(u16) PHY_GETINTVAR(pi, "mcs5glpo6");
-			pi->mcs5glpo[7] =
-				(u16) PHY_GETINTVAR(pi, "mcs5glpo7");
-			break;
-		case 3:
+				hpf_change = desired_log2_pwr - actual_log2_pwr;
+				curr_hpf += hpf_change;
+				curr_hpf = max(min_t(u16, curr_hpf, 10), 0);
+				if (use_hpf_num == 1)
+					curr_hpf1 = curr_hpf;
+				else
+					curr_hpf2 = curr_hpf;
+			}
 
-			pi->nphy_txpid5gh[0] =
-				(u8) PHY_GETINTVAR(pi, "txpid5gha0");
-			pi->nphy_txpid5gh[1] =
-				(u8) PHY_GETINTVAR(pi, "txpid5gha1");
-			pi->nphy_pwrctrl_info[0].max_pwr_5gh =
-				(s8) PHY_GETINTVAR(pi, "maxp5gha0");
-			pi->nphy_pwrctrl_info[1].max_pwr_5gh =
-				(s8) PHY_GETINTVAR(pi, "maxp5gha1");
-			pi->nphy_pwrctrl_info[0].pwrdet_5gh_a1 =
-				(s16) PHY_GETINTVAR(pi, "pa5ghw0a0");
-			pi->nphy_pwrctrl_info[1].pwrdet_5gh_a1 =
-				(s16) PHY_GETINTVAR(pi, "pa5ghw0a1");
-			pi->nphy_pwrctrl_info[0].pwrdet_5gh_b0 =
-				(s16) PHY_GETINTVAR(pi, "pa5ghw1a0");
-			pi->nphy_pwrctrl_info[1].pwrdet_5gh_b0 =
-				(s16) PHY_GETINTVAR(pi, "pa5ghw1a1");
-			pi->nphy_pwrctrl_info[0].pwrdet_5gh_b1 =
-				(s16) PHY_GETINTVAR(pi, "pa5ghw2a0");
-			pi->nphy_pwrctrl_info[1].pwrdet_5gh_b1 =
-				(s16) PHY_GETINTVAR(pi, "pa5ghw2a1");
-			pi->nphy_pwrctrl_info[0].idle_targ_5gh = 0;
-			pi->nphy_pwrctrl_info[1].idle_targ_5gh = 0;
+			wlc_phy_rfctrl_override_nphy(pi, (0x1 << 10),
+						     ((curr_hpf2 << 8) |
+						      (curr_hpf1 << 4) |
+						      (curr_lna << 2)), 0x3, 0);
+			wlc_phy_force_rfseq_nphy(pi, NPHY_RFSEQ_RESET2RX);
 
-			pi->ofdm5ghpo = (u32) PHY_GETINTVAR(pi, "ofdm5ghpo");
+			wlc_phy_stopplayback_nphy(pi);
 
-			pi->mcs5ghpo[0] =
-				(u16) PHY_GETINTVAR(pi, "mcs5ghpo0");
-			pi->mcs5ghpo[1] =
-				(u16) PHY_GETINTVAR(pi, "mcs5ghpo1");
-			pi->mcs5ghpo[2] =
-				(u16) PHY_GETINTVAR(pi, "mcs5ghpo2");
-			pi->mcs5ghpo[3] =
-				(u16) PHY_GETINTVAR(pi, "mcs5ghpo3");
-			pi->mcs5ghpo[4] =
-				(u16) PHY_GETINTVAR(pi, "mcs5ghpo4");
-			pi->mcs5ghpo[5] =
-				(u16) PHY_GETINTVAR(pi, "mcs5ghpo5");
-			pi->mcs5ghpo[6] =
-				(u16) PHY_GETINTVAR(pi, "mcs5ghpo6");
-			pi->mcs5ghpo[7] =
-				(u16) PHY_GETINTVAR(pi, "mcs5ghpo7");
-			break;
-		}
-	}
+			if (first_playtone) {
+				bcmerror = wlc_phy_tx_tone_nphy(pi, 4000,
+						(u16) (pi->nphy_rxcalparams &
+						       0xffff), 0, 0, true);
+				first_playtone = false;
+			} else {
+				phy_bw = (CHSPEC_IS40(pi->radio_chanspec)) ?
+					  40 : 20;
+				wlc_phy_runsamples_nphy(pi, phy_bw * 8, 0xffff,
+							0, 0, 0, true);
+			}
 
-	wlc_phy_txpwr_apply_nphy(pi);
-}
+			if (bcmerror == 0) {
+				if (gain_pass < 3) {
 
-static bool wlc_phy_txpwr_srom_read_nphy(struct brcms_phy *pi)
-{
+					wlc_phy_rx_iq_est_nphy(pi, est,
+							       num_samps, 32,
+							       0);
+					i_pwr =	(est[rx_core].i_pwr +
+						 num_samps / 2) / num_samps;
+					q_pwr =	(est[rx_core].q_pwr +
+						 num_samps / 2) / num_samps;
+					tot_pwr[gain_pass] = i_pwr + q_pwr;
+				} else {
 
-	pi->antswitch = (u8) PHY_GETINTVAR(pi, "antswitch");
-	pi->aa2g = (u8) PHY_GETINTVAR(pi, "aa2g");
-	pi->aa5g = (u8) PHY_GETINTVAR(pi, "aa5g");
+					wlc_phy_calc_rx_iq_comp_nphy(pi,
+								     (1 <<
+								      rx_core));
+				}
 
-	pi->srom_fem2g.tssipos = (u8) PHY_GETINTVAR(pi, "tssipos2g");
-	pi->srom_fem2g.extpagain = (u8) PHY_GETINTVAR(pi, "extpagain2g");
-	pi->srom_fem2g.pdetrange = (u8) PHY_GETINTVAR(pi, "pdetrange2g");
-	pi->srom_fem2g.triso = (u8) PHY_GETINTVAR(pi, "triso2g");
-	pi->srom_fem2g.antswctrllut = (u8) PHY_GETINTVAR(pi, "antswctl2g");
+				wlc_phy_stopplayback_nphy(pi);
+			}
 
-	pi->srom_fem5g.tssipos = (u8) PHY_GETINTVAR(pi, "tssipos5g");
-	pi->srom_fem5g.extpagain = (u8) PHY_GETINTVAR(pi, "extpagain5g");
-	pi->srom_fem5g.pdetrange = (u8) PHY_GETINTVAR(pi, "pdetrange5g");
-	pi->srom_fem5g.triso = (u8) PHY_GETINTVAR(pi, "triso5g");
-	if (PHY_GETVAR(pi, "antswctl5g"))
-		pi->srom_fem5g.antswctrllut =
-			(u8) PHY_GETINTVAR(pi, "antswctl5g");
-	else
-		pi->srom_fem5g.antswctrllut =
-			(u8) PHY_GETINTVAR(pi, "antswctl2g");
+			if (bcmerror != 0)
+				break;
+		}
 
-	wlc_phy_txpower_ipa_upd(pi);
+		and_radio_reg(pi, RADIO_2055_CORE1_GEN_SPARE2, ~mask);
+		and_radio_reg(pi, RADIO_2055_CORE2_GEN_SPARE2, ~mask);
 
-	pi->phy_txcore_disable_temp = (s16) PHY_GETINTVAR(pi, "tempthresh");
-	if (pi->phy_txcore_disable_temp == 0)
-		pi->phy_txcore_disable_temp = PHY_CHAIN_TX_DISABLE_TEMP;
+		write_phy_reg(pi, (tx_core == PHY_CORE_0) ? 0x91 :
+			      0x92, orig_RfctrlIntcTx);
+		write_phy_reg(pi, (rx_core == PHY_CORE_0) ? 0x91 :
+			      0x92, orig_RfctrlIntcRx);
+		write_phy_reg(pi, 0xa5, orig_AfectrlOverride);
+		write_phy_reg(pi, (rx_core == PHY_CORE_0) ? 0xa6 :
+			      0xa7, orig_AfectrlCore);
+		write_phy_reg(pi, 0xa2, orig_RfseqCoreActv);
 
-	pi->phy_tempsense_offset = (s8) PHY_GETINTVAR(pi, "tempoffset");
-	if (pi->phy_tempsense_offset != 0) {
-		if (pi->phy_tempsense_offset >
-		    (NPHY_SROM_TEMPSHIFT + NPHY_SROM_MAXTEMPOFFSET))
-			pi->phy_tempsense_offset = NPHY_SROM_MAXTEMPOFFSET;
-		else if (pi->phy_tempsense_offset < (NPHY_SROM_TEMPSHIFT +
-						     NPHY_SROM_MINTEMPOFFSET))
-			pi->phy_tempsense_offset = NPHY_SROM_MINTEMPOFFSET;
-		else
-			pi->phy_tempsense_offset -= NPHY_SROM_TEMPSHIFT;
+		if (bcmerror != 0)
+			break;
 	}
 
-	pi->phy_txcore_enable_temp =
-		pi->phy_txcore_disable_temp - PHY_HYSTERESIS_DELTATEMP;
+	wlc_phy_rfctrl_override_nphy(pi, (0x1 << 10), 0, 0x3, 1);
+	wlc_phy_force_rfseq_nphy(pi, NPHY_RFSEQ_RESET2RX);
 
-	pi->phycal_tempdelta = (u8) PHY_GETINTVAR(pi, "phycal_tempdelta");
-	if (pi->phycal_tempdelta > NPHY_CAL_MAXTEMPDELTA)
-		pi->phycal_tempdelta = 0;
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x110, 16,
+				 gain_save);
 
-	wlc_phy_txpwr_srom_read_ppr_nphy(pi);
+	wlc_phy_stay_in_carriersearch_nphy(pi, false);
 
-	return true;
+	return bcmerror;
 }
 
-void wlc_phy_txpower_recalc_target_nphy(struct brcms_phy *pi)
+int
+wlc_phy_cal_rxiq_nphy(struct brcms_phy *pi, struct nphy_txgains target_gain,
+		      u8 cal_type, bool debug)
 {
-	u8 tx_pwr_ctrl_state;
-	wlc_phy_txpwr_limit_to_tbl_nphy(pi);
-	wlc_phy_txpwrctrl_pwr_setup_nphy(pi);
-
-	tx_pwr_ctrl_state = pi->nphy_txpwrctrl;
-
-	if (D11REV_IS(pi->sh->corerev, 11) || D11REV_IS(pi->sh->corerev, 12)) {
-		wlapi_bmac_mctrl(pi->sh->physhim, MCTL_PHYLOCK, MCTL_PHYLOCK);
-		(void)R_REG(&pi->regs->maccontrol);
-		udelay(1);
-	}
-
-	wlc_phy_txpwrctrl_enable_nphy(pi, tx_pwr_ctrl_state);
+	if (NREV_GE(pi->pubpi.phy_rev, 7))
+		cal_type = 0;
 
-	if (D11REV_IS(pi->sh->corerev, 11) || D11REV_IS(pi->sh->corerev, 12))
-		wlapi_bmac_mctrl(pi->sh->physhim, MCTL_PHYLOCK, 0);
+	if (NREV_GE(pi->pubpi.phy_rev, 3))
+		return wlc_phy_cal_rxiq_nphy_rev3(pi, target_gain, cal_type,
+						  debug);
+	else
+		return wlc_phy_cal_rxiq_nphy_rev2(pi, target_gain, debug);
 }
 
-static void wlc_phy_txpwrctrl_coeff_setup_nphy(struct brcms_phy *pi)
+void wlc_phy_txpwr_fixpower_nphy(struct brcms_phy *pi)
 {
-	u32 idx;
-	u16 iqloCalbuf[7];
-	u32 iqcomp, locomp, curr_locomp;
-	s8 locomp_i, locomp_q;
-	s8 curr_locomp_i, curr_locomp_q;
-	u32 tbl_id, tbl_len, tbl_offset;
-	u32 regval[128];
+	uint core;
+	u32 txgain;
+	u16 rad_gain, dac_gain, bbmult, m1m2;
+	u8 txpi[2], chan_freq_range;
+	s32 rfpwr_offset;
 
 	if (pi->phyhang_avoid)
 		wlc_phy_stay_in_carriersearch_nphy(pi, true);
 
-	wlc_phy_table_read_nphy(pi, 15, 7, 80, 16, iqloCalbuf);
-
-	tbl_len = 128;
-	tbl_offset = 320;
-	for (tbl_id = NPHY_TBL_ID_CORE1TXPWRCTL;
-	     tbl_id <= NPHY_TBL_ID_CORE2TXPWRCTL; tbl_id++) {
-		iqcomp =
-			(tbl_id ==
-			 26) ? (((u32) (iqloCalbuf[0] & 0x3ff)) << 10) |
-			(iqloCalbuf[1] & 0x3ff)
-			: (((u32) (iqloCalbuf[2] & 0x3ff)) << 10) |
-			(iqloCalbuf[3] & 0x3ff);
-
-		for (idx = 0; idx < tbl_len; idx++)
-			regval[idx] = iqcomp;
-		wlc_phy_table_write_nphy(pi, tbl_id, tbl_len, tbl_offset, 32,
-					 regval);
-	}
-
-	tbl_offset = 448;
-	for (tbl_id = NPHY_TBL_ID_CORE1TXPWRCTL;
-	     tbl_id <= NPHY_TBL_ID_CORE2TXPWRCTL; tbl_id++) {
+	if (pi->sh->sromrev < 4) {
+		txpi[0] = txpi[1] = 72;
+	} else {
 
-		locomp =
-			(u32) ((tbl_id == 26) ? iqloCalbuf[5] : iqloCalbuf[6]);
-		locomp_i = (s8) ((locomp >> 8) & 0xff);
-		locomp_q = (s8) ((locomp) & 0xff);
-		for (idx = 0; idx < tbl_len; idx++) {
-			if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-				curr_locomp_i = locomp_i;
-				curr_locomp_q = locomp_q;
-			} else {
-				curr_locomp_i = (s8) ((locomp_i *
-						       nphy_tpc_loscale[idx] +
-						       128) >> 8);
-				curr_locomp_q =
-					(s8) ((locomp_q *
-					       nphy_tpc_loscale[idx] +
-					       128) >> 8);
-			}
-			curr_locomp = (u32) ((curr_locomp_i & 0xff) << 8);
-			curr_locomp |= (u32) (curr_locomp_q & 0xff);
-			regval[idx] = curr_locomp;
+		chan_freq_range = wlc_phy_get_chan_freq_range_nphy(pi, 0);
+		switch (chan_freq_range) {
+		case WL_CHAN_FREQ_RANGE_2G:
+			txpi[0] = pi->nphy_txpid2g[0];
+			txpi[1] = pi->nphy_txpid2g[1];
+			break;
+		case WL_CHAN_FREQ_RANGE_5GL:
+			txpi[0] = pi->nphy_txpid5gl[0];
+			txpi[1] = pi->nphy_txpid5gl[1];
+			break;
+		case WL_CHAN_FREQ_RANGE_5GM:
+			txpi[0] = pi->nphy_txpid5g[0];
+			txpi[1] = pi->nphy_txpid5g[1];
+			break;
+		case WL_CHAN_FREQ_RANGE_5GH:
+			txpi[0] = pi->nphy_txpid5gh[0];
+			txpi[1] = pi->nphy_txpid5gh[1];
+			break;
+		default:
+			txpi[0] = txpi[1] = 91;
+			break;
 		}
-		wlc_phy_table_write_nphy(pi, tbl_id, tbl_len, tbl_offset, 32,
-					 regval);
 	}
 
-	if (NREV_LT(pi->pubpi.phy_rev, 2)) {
-
-		wlapi_bmac_write_shm(pi->sh->physhim, M_CURR_IDX1, 0xFFFF);
-		wlapi_bmac_write_shm(pi->sh->physhim, M_CURR_IDX2, 0xFFFF);
-	}
+	if (NREV_GE(pi->pubpi.phy_rev, 7))
+		txpi[0] = txpi[1] = 30;
+	else if (NREV_GE(pi->pubpi.phy_rev, 3))
+		txpi[0] = txpi[1] = 40;
 
-	if (pi->phyhang_avoid)
-		wlc_phy_stay_in_carriersearch_nphy(pi, false);
-}
+	if (NREV_LT(pi->pubpi.phy_rev, 7)) {
 
-static void wlc_phy_ipa_internal_tssi_setup_nphy(struct brcms_phy *pi)
-{
-	u8 core;
+		if ((txpi[0] < 40) || (txpi[0] > 100) ||
+		    (txpi[1] < 40) || (txpi[1] > 100))
+			txpi[0] = txpi[1] = 91;
+	}
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-		for (core = 0; core < pi->pubpi.phy_corenum; core++) {
-			if (CHSPEC_IS2G(pi->radio_chanspec)) {
-				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
-						 TX_SSI_MASTER, 0x5);
-				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
-						 TX_SSI_MUX, 0xe);
+	pi->nphy_txpwrindex[PHY_CORE_0].index_internal = txpi[0];
+	pi->nphy_txpwrindex[PHY_CORE_1].index_internal = txpi[1];
+	pi->nphy_txpwrindex[PHY_CORE_0].index_internal_save = txpi[0];
+	pi->nphy_txpwrindex[PHY_CORE_1].index_internal_save = txpi[1];
 
-				if (pi->pubpi.radiorev != 5)
-					WRITE_RADIO_REG3(pi, RADIO_2057, TX,
-							 core, TSSIA, 0);
+	for (core = 0; core < pi->pubpi.phy_corenum; core++) {
+		uint phyrev = pi->pubpi.phy_rev;
 
-				if (!NREV_IS(pi->pubpi.phy_rev, 7))
-					WRITE_RADIO_REG3(pi, RADIO_2057, TX,
-							 core, TSSIG, 0x1);
-				else
-					WRITE_RADIO_REG3(pi, RADIO_2057, TX,
-							 core, TSSIG, 0x31);
+		if (NREV_GE(phyrev, 3)) {
+			if (PHY_IPA(pi)) {
+				u32 *tx_gaintbl =
+					wlc_phy_get_ipa_gaintbl_nphy(pi);
+				txgain = tx_gaintbl[txpi[core]];
 			} else {
-				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
-						 TX_SSI_MASTER, 0x9);
-				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
-						 TX_SSI_MUX, 0xc);
-				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
-						 TSSIG, 0);
-
-				if (pi->pubpi.radiorev != 5) {
-					if (!NREV_IS(pi->pubpi.phy_rev, 7))
-						WRITE_RADIO_REG3(pi, RADIO_2057,
-								 TX, core,
-								 TSSIA, 0x1);
-					else
-						WRITE_RADIO_REG3(pi, RADIO_2057,
-								 TX, core,
-								 TSSIA, 0x31);
+				if (CHSPEC_IS5G(pi->radio_chanspec)) {
+					if (NREV_IS(phyrev, 3)) {
+						txgain =
+						      nphy_tpc_5GHz_txgain_rev3
+								   [txpi[core]];
+					} else if (NREV_IS(phyrev, 4)) {
+						txgain = (
+						  pi->srom_fem5g.extpagain ==
+						  3) ?
+						  nphy_tpc_5GHz_txgain_HiPwrEPA
+						 [txpi[core]] :
+						 nphy_tpc_5GHz_txgain_rev4
+						 [txpi[core]];
+					} else {
+						txgain =
+						      nphy_tpc_5GHz_txgain_rev5
+								   [txpi[core]];
+					}
+				} else {
+					if (NREV_GE(phyrev, 5) &&
+					    (pi->srom_fem2g.extpagain == 3)) {
+						txgain =
+							nphy_tpc_txgain_HiPwrEPA
+							[txpi[core]];
+					} else {
+						txgain = nphy_tpc_txgain_rev3
+							 [txpi[core]];
+					}
 				}
 			}
-			WRITE_RADIO_REG3(pi, RADIO_2057, TX, core, IQCAL_VCM_HG,
-					 0);
-			WRITE_RADIO_REG3(pi, RADIO_2057, TX, core, IQCAL_IDAC,
-					 0);
-			WRITE_RADIO_REG3(pi, RADIO_2057, TX, core, TSSI_VCM,
-					 0x3);
-			WRITE_RADIO_REG3(pi, RADIO_2057, TX, core, TSSI_MISC1,
-					 0x0);
+		} else {
+			txgain = nphy_tpc_txgain[txpi[core]];
 		}
-	} else {
-		WRITE_RADIO_SYN(pi, RADIO_2056, RESERVED_ADDR31,
-				(CHSPEC_IS2G(pi->radio_chanspec)) ? 0x128 :
-				0x80);
-		WRITE_RADIO_SYN(pi, RADIO_2056, RESERVED_ADDR30, 0x0);
-		WRITE_RADIO_SYN(pi, RADIO_2056, GPIO_MASTER1, 0x29);
 
-		for (core = 0; core < pi->pubpi.phy_corenum; core++) {
-			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core, IQCAL_VCM_HG,
-					 0x0);
-			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core, IQCAL_IDAC,
-					 0x0);
-			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core, TSSI_VCM,
-					 0x3);
-			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core, TX_AMP_DET,
-					 0x0);
-			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core, TSSI_MISC1,
-					 0x8);
-			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core, TSSI_MISC2,
-					 0x0);
-			WRITE_RADIO_REG2(pi, RADIO_2056, TX, core, TSSI_MISC3,
-					 0x0);
+		if (NREV_GE(phyrev, 3))
+			rad_gain = (txgain >> 16) & ((1 << (32 - 16 + 1)) - 1);
+		else
+			rad_gain = (txgain >> 16) & ((1 << (28 - 16 + 1)) - 1);
 
-			if (CHSPEC_IS2G(pi->radio_chanspec)) {
-				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
-						 TX_SSI_MASTER, 0x5);
+		if (NREV_GE(phyrev, 7))
+			dac_gain = (txgain >> 8) & ((1 << (10 - 8 + 1)) - 1);
+		else
+			dac_gain = (txgain >> 8) & ((1 << (13 - 8 + 1)) - 1);
 
-				if (pi->pubpi.radiorev != 5)
-					WRITE_RADIO_REG2(pi, RADIO_2056, TX,
-							 core, TSSIA, 0x0);
-				if (NREV_GE(pi->pubpi.phy_rev, 5))
-					WRITE_RADIO_REG2(pi, RADIO_2056, TX,
-							 core, TSSIG, 0x31);
-				else
-					WRITE_RADIO_REG2(pi, RADIO_2056, TX,
-							 core, TSSIG, 0x11);
-				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
-						 TX_SSI_MUX, 0xe);
-			} else {
-				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
-						 TX_SSI_MASTER, 0x9);
-				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
-						 TSSIA, 0x31);
-				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
-						 TSSIG, 0x0);
-				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
-						 TX_SSI_MUX, 0xc);
-			}
-		}
-	}
-}
+		bbmult = (txgain >> 0) & ((1 << (7 - 0 + 1)) - 1);
+
+		if (NREV_GE(phyrev, 3))
+			mod_phy_reg(pi, ((core == PHY_CORE_0) ? 0x8f :
+					 0xa5), (0x1 << 8), (0x1 << 8));
+		else
+			mod_phy_reg(pi, 0xa5, (0x1 << 14), (0x1 << 14));
+
+		write_phy_reg(pi, (core == PHY_CORE_0) ? 0xaa : 0xab, dac_gain);
 
-static void wlc_phy_txpwrctrl_idle_tssi_nphy(struct brcms_phy *pi)
-{
-	s32 rssi_buf[4];
-	s32 int_val;
+		wlc_phy_table_write_nphy(pi, 7, 1, (0x110 + core), 16,
+					 &rad_gain);
 
-	if (SCAN_RM_IN_PROGRESS(pi) || PLT_INPROG_PHY(pi) || PHY_MUTED(pi))
+		wlc_phy_table_read_nphy(pi, 15, 1, 87, 16, &m1m2);
+		m1m2 &= ((core == PHY_CORE_0) ? 0x00ff : 0xff00);
+		m1m2 |= ((core == PHY_CORE_0) ? (bbmult << 8) : (bbmult << 0));
+		wlc_phy_table_write_nphy(pi, 15, 1, 87, 16, &m1m2);
 
-		return;
+		if (PHY_IPA(pi)) {
+			wlc_phy_table_read_nphy(pi,
+						(core ==
+						 PHY_CORE_0 ?
+						 NPHY_TBL_ID_CORE1TXPWRCTL :
+						 NPHY_TBL_ID_CORE2TXPWRCTL), 1,
+						576 + txpi[core], 32,
+						&rfpwr_offset);
 
-	if (PHY_IPA(pi))
-		wlc_phy_ipa_internal_tssi_setup_nphy(pi);
+			mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x297 :
+				    0x29b, (0x1ff << 4),
+				    ((s16) rfpwr_offset) << 4);
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7))
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 12),
-						  0, 0x3, 0,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID0);
-	else if (NREV_GE(pi->pubpi.phy_rev, 3))
-		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 13), 0, 3, 0);
+			mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x297 :
+				    0x29b, (0x1 << 2), (1) << 2);
 
-	wlc_phy_stopplayback_nphy(pi);
+		}
+	}
 
-	wlc_phy_tx_tone_nphy(pi, 4000, 0, 0, 0, false);
+	and_phy_reg(pi, 0xbf, (u16) (~(0x1f << 0)));
 
-	udelay(20);
-	int_val =
-		wlc_phy_poll_rssi_nphy(pi, (u8) NPHY_RSSI_SEL_TSSI_2G, rssi_buf,
-				       1);
-	wlc_phy_stopplayback_nphy(pi);
-	wlc_phy_rssisel_nphy(pi, RADIO_MIMO_CORESEL_OFF, 0);
+	if (pi->phyhang_avoid)
+		wlc_phy_stay_in_carriersearch_nphy(pi, false);
+}
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7))
-		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 12),
-						  0, 0x3, 1,
-						  NPHY_REV7_RFCTRLOVERRIDE_ID0);
-	else if (NREV_GE(pi->pubpi.phy_rev, 3))
-		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 13), 0, 3, 1);
+static void
+wlc_phy_txpwr_nphy_srom_convert(u8 *srom_max, u16 *pwr_offset,
+				u8 tmp_max_pwr, u8 rate_start,
+				u8 rate_end)
+{
+	u8 rate;
+	u8 word_num, nibble_num;
+	u8 tmp_nibble;
 
-	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+	for (rate = rate_start; rate <= rate_end; rate++) {
+		word_num = (rate - rate_start) >> 2;
+		nibble_num = (rate - rate_start) & 0x3;
+		tmp_nibble = (pwr_offset[word_num] >> 4 * nibble_num) & 0xf;
 
-		pi->nphy_pwrctrl_info[PHY_CORE_0].idle_tssi_2g =
-			(u8) ((int_val >> 24) & 0xff);
-		pi->nphy_pwrctrl_info[PHY_CORE_0].idle_tssi_5g =
-			(u8) ((int_val >> 24) & 0xff);
+		srom_max[rate] = tmp_max_pwr - 2 * tmp_nibble;
+	}
+}
 
-		pi->nphy_pwrctrl_info[PHY_CORE_1].idle_tssi_2g =
-			(u8) ((int_val >> 8) & 0xff);
-		pi->nphy_pwrctrl_info[PHY_CORE_1].idle_tssi_5g =
-			(u8) ((int_val >> 8) & 0xff);
-	} else {
-		pi->nphy_pwrctrl_info[PHY_CORE_0].idle_tssi_2g =
-			(u8) ((int_val >> 24) & 0xff);
+static void
+wlc_phy_txpwr_nphy_po_apply(u8 *srom_max, u8 pwr_offset,
+			    u8 rate_start, u8 rate_end)
+{
+	u8 rate;
 
-		pi->nphy_pwrctrl_info[PHY_CORE_1].idle_tssi_2g =
-			(u8) ((int_val >> 8) & 0xff);
+	for (rate = rate_start; rate <= rate_end; rate++)
+		srom_max[rate] -= 2 * pwr_offset;
+}
 
-		pi->nphy_pwrctrl_info[PHY_CORE_0].idle_tssi_5g =
-			(u8) ((int_val >> 16) & 0xff);
-		pi->nphy_pwrctrl_info[PHY_CORE_1].idle_tssi_5g =
-			(u8) ((int_val) & 0xff);
-	}
+void
+wlc_phy_ofdm_to_mcs_powers_nphy(u8 *power, u8 rate_mcs_start,
+				u8 rate_mcs_end, u8 rate_ofdm_start)
+{
+	u8 rate1, rate2;
 
+	rate2 = rate_ofdm_start;
+	for (rate1 = rate_mcs_start; rate1 <= rate_mcs_end - 1; rate1++) {
+		power[rate1] = power[rate2];
+		rate2 += (rate1 == rate_mcs_start) ? 2 : 1;
+	}
+	power[rate_mcs_end] = power[rate_mcs_end - 1];
 }
 
-static void wlc_phy_txpwrctrl_pwr_setup_nphy(struct brcms_phy *pi)
+void
+wlc_phy_mcs_to_ofdm_powers_nphy(u8 *power, u8 rate_ofdm_start,
+				u8 rate_ofdm_end, u8 rate_mcs_start)
 {
-	u32 idx;
-	s16 a1[2], b0[2], b1[2];
-	s8 target_pwr_qtrdbm[2];
-	s32 num, den, pwr_est;
-	u8 chan_freq_range;
-	u8 idle_tssi[2];
-	u32 tbl_id, tbl_len, tbl_offset;
-	u32 regval[64];
-	u8 core;
+	u8 rate1, rate2;
 
-	if (D11REV_IS(pi->sh->corerev, 11) || D11REV_IS(pi->sh->corerev, 12)) {
-		wlapi_bmac_mctrl(pi->sh->physhim, MCTL_PHYLOCK, MCTL_PHYLOCK);
-		(void)R_REG(&pi->regs->maccontrol);
-		udelay(1);
+	for (rate1 = rate_ofdm_start, rate2 = rate_mcs_start;
+	     rate1 <= rate_ofdm_end; rate1++, rate2++) {
+		power[rate1] = power[rate2];
+		if (rate1 == rate_ofdm_start)
+			power[++rate1] = power[rate2];
 	}
+}
 
-	if (pi->phyhang_avoid)
-		wlc_phy_stay_in_carriersearch_nphy(pi, true);
+void wlc_phy_txpwr_apply_nphy(struct brcms_phy *pi)
+{
+	uint rate1, rate2, band_num;
+	u8 tmp_bw40po = 0, tmp_cddpo = 0, tmp_stbcpo = 0;
+	u8 tmp_max_pwr = 0;
+	u16 pwr_offsets1[2], *pwr_offsets2 = NULL;
+	u8 *tx_srom_max_rate = NULL;
 
-	or_phy_reg(pi, 0x122, (0x1 << 0));
+	for (band_num = 0; band_num < (CH_2G_GROUP + CH_5G_GROUP);
+	     band_num++) {
+		switch (band_num) {
+		case 0:
 
-	if (NREV_GE(pi->pubpi.phy_rev, 3))
-		and_phy_reg(pi, 0x1e7, (u16) (~(0x1 << 15)));
-	else
-		or_phy_reg(pi, 0x1e7, (0x1 << 15));
+			tmp_max_pwr = min(pi->nphy_pwrctrl_info[0].max_pwr_2g,
+					  pi->nphy_pwrctrl_info[1].max_pwr_2g);
 
-	if (D11REV_IS(pi->sh->corerev, 11) || D11REV_IS(pi->sh->corerev, 12))
-		wlapi_bmac_mctrl(pi->sh->physhim, MCTL_PHYLOCK, 0);
+			pwr_offsets1[0] = pi->cck2gpo;
+			wlc_phy_txpwr_nphy_srom_convert(pi->tx_srom_max_rate_2g,
+							pwr_offsets1,
+							tmp_max_pwr,
+							TXP_FIRST_CCK,
+							TXP_LAST_CCK);
 
-	if (pi->sh->sromrev < 4) {
-		idle_tssi[0] = pi->nphy_pwrctrl_info[0].idle_tssi_2g;
-		idle_tssi[1] = pi->nphy_pwrctrl_info[1].idle_tssi_2g;
-		target_pwr_qtrdbm[0] = 13 * 4;
-		target_pwr_qtrdbm[1] = 13 * 4;
-		a1[0] = -424;
-		a1[1] = -424;
-		b0[0] = 5612;
-		b0[1] = 5612;
-		b1[1] = -1393;
-		b1[0] = -1393;
-	} else {
+			pwr_offsets1[0] = (u16) (pi->ofdm2gpo & 0xffff);
+			pwr_offsets1[1] =
+				(u16) (pi->ofdm2gpo >> 16) & 0xffff;
 
-		chan_freq_range = wlc_phy_get_chan_freq_range_nphy(pi, 0);
-		switch (chan_freq_range) {
-		case WL_CHAN_FREQ_RANGE_2G:
-			idle_tssi[0] = pi->nphy_pwrctrl_info[0].idle_tssi_2g;
-			idle_tssi[1] = pi->nphy_pwrctrl_info[1].idle_tssi_2g;
-			target_pwr_qtrdbm[0] =
-				pi->nphy_pwrctrl_info[0].max_pwr_2g;
-			target_pwr_qtrdbm[1] =
-				pi->nphy_pwrctrl_info[1].max_pwr_2g;
-			a1[0] = pi->nphy_pwrctrl_info[0].pwrdet_2g_a1;
-			a1[1] = pi->nphy_pwrctrl_info[1].pwrdet_2g_a1;
-			b0[0] = pi->nphy_pwrctrl_info[0].pwrdet_2g_b0;
-			b0[1] = pi->nphy_pwrctrl_info[1].pwrdet_2g_b0;
-			b1[0] = pi->nphy_pwrctrl_info[0].pwrdet_2g_b1;
-			b1[1] = pi->nphy_pwrctrl_info[1].pwrdet_2g_b1;
-			break;
-		case WL_CHAN_FREQ_RANGE_5GL:
-			idle_tssi[0] = pi->nphy_pwrctrl_info[0].idle_tssi_5g;
-			idle_tssi[1] = pi->nphy_pwrctrl_info[1].idle_tssi_5g;
-			target_pwr_qtrdbm[0] =
-				pi->nphy_pwrctrl_info[0].max_pwr_5gl;
-			target_pwr_qtrdbm[1] =
-				pi->nphy_pwrctrl_info[1].max_pwr_5gl;
-			a1[0] = pi->nphy_pwrctrl_info[0].pwrdet_5gl_a1;
-			a1[1] = pi->nphy_pwrctrl_info[1].pwrdet_5gl_a1;
-			b0[0] = pi->nphy_pwrctrl_info[0].pwrdet_5gl_b0;
-			b0[1] = pi->nphy_pwrctrl_info[1].pwrdet_5gl_b0;
-			b1[0] = pi->nphy_pwrctrl_info[0].pwrdet_5gl_b1;
-			b1[1] = pi->nphy_pwrctrl_info[1].pwrdet_5gl_b1;
+			pwr_offsets2 = pi->mcs2gpo;
+
+			tmp_cddpo = pi->cdd2gpo;
+			tmp_stbcpo = pi->stbc2gpo;
+			tmp_bw40po = pi->bw402gpo;
+
+			tx_srom_max_rate = pi->tx_srom_max_rate_2g;
 			break;
-		case WL_CHAN_FREQ_RANGE_5GM:
-			idle_tssi[0] = pi->nphy_pwrctrl_info[0].idle_tssi_5g;
-			idle_tssi[1] = pi->nphy_pwrctrl_info[1].idle_tssi_5g;
-			target_pwr_qtrdbm[0] =
-				pi->nphy_pwrctrl_info[0].max_pwr_5gm;
-			target_pwr_qtrdbm[1] =
-				pi->nphy_pwrctrl_info[1].max_pwr_5gm;
-			a1[0] = pi->nphy_pwrctrl_info[0].pwrdet_5gm_a1;
-			a1[1] = pi->nphy_pwrctrl_info[1].pwrdet_5gm_a1;
-			b0[0] = pi->nphy_pwrctrl_info[0].pwrdet_5gm_b0;
-			b0[1] = pi->nphy_pwrctrl_info[1].pwrdet_5gm_b0;
-			b1[0] = pi->nphy_pwrctrl_info[0].pwrdet_5gm_b1;
-			b1[1] = pi->nphy_pwrctrl_info[1].pwrdet_5gm_b1;
+		case 1:
+
+			tmp_max_pwr = min(pi->nphy_pwrctrl_info[0].max_pwr_5gm,
+					  pi->nphy_pwrctrl_info[1].max_pwr_5gm);
+
+			pwr_offsets1[0] = (u16) (pi->ofdm5gpo & 0xffff);
+			pwr_offsets1[1] =
+				(u16) (pi->ofdm5gpo >> 16) & 0xffff;
+
+			pwr_offsets2 = pi->mcs5gpo;
+
+			tmp_cddpo = pi->cdd5gpo;
+			tmp_stbcpo = pi->stbc5gpo;
+			tmp_bw40po = pi->bw405gpo;
+
+			tx_srom_max_rate = pi->tx_srom_max_rate_5g_mid;
 			break;
-		case WL_CHAN_FREQ_RANGE_5GH:
-			idle_tssi[0] = pi->nphy_pwrctrl_info[0].idle_tssi_5g;
-			idle_tssi[1] = pi->nphy_pwrctrl_info[1].idle_tssi_5g;
-			target_pwr_qtrdbm[0] =
-				pi->nphy_pwrctrl_info[0].max_pwr_5gh;
-			target_pwr_qtrdbm[1] =
-				pi->nphy_pwrctrl_info[1].max_pwr_5gh;
-			a1[0] = pi->nphy_pwrctrl_info[0].pwrdet_5gh_a1;
-			a1[1] = pi->nphy_pwrctrl_info[1].pwrdet_5gh_a1;
-			b0[0] = pi->nphy_pwrctrl_info[0].pwrdet_5gh_b0;
-			b0[1] = pi->nphy_pwrctrl_info[1].pwrdet_5gh_b0;
-			b1[0] = pi->nphy_pwrctrl_info[0].pwrdet_5gh_b1;
-			b1[1] = pi->nphy_pwrctrl_info[1].pwrdet_5gh_b1;
+		case 2:
+
+			tmp_max_pwr = min(pi->nphy_pwrctrl_info[0].max_pwr_5gl,
+					  pi->nphy_pwrctrl_info[1].max_pwr_5gl);
+
+			pwr_offsets1[0] = (u16) (pi->ofdm5glpo & 0xffff);
+			pwr_offsets1[1] =
+				(u16) (pi->ofdm5glpo >> 16) & 0xffff;
+
+			pwr_offsets2 = pi->mcs5glpo;
+
+			tmp_cddpo = pi->cdd5glpo;
+			tmp_stbcpo = pi->stbc5glpo;
+			tmp_bw40po = pi->bw405glpo;
+
+			tx_srom_max_rate = pi->tx_srom_max_rate_5g_low;
 			break;
-		default:
-			idle_tssi[0] = pi->nphy_pwrctrl_info[0].idle_tssi_2g;
-			idle_tssi[1] = pi->nphy_pwrctrl_info[1].idle_tssi_2g;
-			target_pwr_qtrdbm[0] = 13 * 4;
-			target_pwr_qtrdbm[1] = 13 * 4;
-			a1[0] = -424;
-			a1[1] = -424;
-			b0[0] = 5612;
-			b0[1] = 5612;
-			b1[1] = -1393;
-			b1[0] = -1393;
+		case 3:
+
+			tmp_max_pwr = min(pi->nphy_pwrctrl_info[0].max_pwr_5gh,
+					  pi->nphy_pwrctrl_info[1].max_pwr_5gh);
+
+			pwr_offsets1[0] = (u16) (pi->ofdm5ghpo & 0xffff);
+			pwr_offsets1[1] =
+				(u16) (pi->ofdm5ghpo >> 16) & 0xffff;
+
+			pwr_offsets2 = pi->mcs5ghpo;
+
+			tmp_cddpo = pi->cdd5ghpo;
+			tmp_stbcpo = pi->stbc5ghpo;
+			tmp_bw40po = pi->bw405ghpo;
+
+			tx_srom_max_rate = pi->tx_srom_max_rate_5g_hi;
 			break;
 		}
-	}
 
-	target_pwr_qtrdbm[0] = (s8) pi->tx_power_max;
-	target_pwr_qtrdbm[1] = (s8) pi->tx_power_max;
+		wlc_phy_txpwr_nphy_srom_convert(tx_srom_max_rate, pwr_offsets1,
+						tmp_max_pwr, TXP_FIRST_OFDM,
+						TXP_LAST_OFDM);
 
-	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-		if (pi->srom_fem2g.tssipos)
-			or_phy_reg(pi, 0x1e9, (0x1 << 14));
+		wlc_phy_ofdm_to_mcs_powers_nphy(tx_srom_max_rate,
+						TXP_FIRST_MCS_20_SISO,
+						TXP_LAST_MCS_20_SISO,
+						TXP_FIRST_OFDM);
 
-		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-			for (core = 0; core <= 1; core++) {
-				if (PHY_IPA(pi)) {
-					if (CHSPEC_IS2G(pi->radio_chanspec))
-						WRITE_RADIO_REG3(pi, RADIO_2057,
-								 TX, core,
-								 TX_SSI_MUX,
-								 0xe);
-					else
-						WRITE_RADIO_REG3(pi, RADIO_2057,
-								 TX, core,
-								 TX_SSI_MUX,
-								 0xc);
-				}
-			}
-		} else {
-			if (PHY_IPA(pi)) {
+		wlc_phy_txpwr_nphy_srom_convert(tx_srom_max_rate, pwr_offsets2,
+						tmp_max_pwr,
+						TXP_FIRST_MCS_20_CDD,
+						TXP_LAST_MCS_20_CDD);
 
-				write_radio_reg(pi, RADIO_2056_TX_TX_SSI_MUX |
-						RADIO_2056_TX0,
-						(CHSPEC_IS5G
-						 (pi->radio_chanspec)) ?
-						 0xc : 0xe);
-				write_radio_reg(pi,
-						RADIO_2056_TX_TX_SSI_MUX |
-						RADIO_2056_TX1,
-						(CHSPEC_IS5G
-						 (pi->radio_chanspec)) ?
-						 0xc : 0xe);
-			} else {
+		if (NREV_GE(pi->pubpi.phy_rev, 3))
+			wlc_phy_txpwr_nphy_po_apply(tx_srom_max_rate, tmp_cddpo,
+						    TXP_FIRST_MCS_20_CDD,
+						    TXP_LAST_MCS_20_CDD);
 
-				write_radio_reg(pi, RADIO_2056_TX_TX_SSI_MUX |
-						RADIO_2056_TX0, 0x11);
-				write_radio_reg(pi, RADIO_2056_TX_TX_SSI_MUX |
-						RADIO_2056_TX1, 0x11);
-			}
-		}
-	}
+		wlc_phy_mcs_to_ofdm_powers_nphy(tx_srom_max_rate,
+						TXP_FIRST_OFDM_20_CDD,
+						TXP_LAST_OFDM_20_CDD,
+						TXP_FIRST_MCS_20_CDD);
 
-	if (D11REV_IS(pi->sh->corerev, 11) || D11REV_IS(pi->sh->corerev, 12)) {
-		wlapi_bmac_mctrl(pi->sh->physhim, MCTL_PHYLOCK, MCTL_PHYLOCK);
-		(void)R_REG(&pi->regs->maccontrol);
-		udelay(1);
-	}
+		wlc_phy_txpwr_nphy_srom_convert(tx_srom_max_rate, pwr_offsets2,
+						tmp_max_pwr,
+						TXP_FIRST_MCS_20_STBC,
+						TXP_LAST_MCS_20_STBC);
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7))
-		mod_phy_reg(pi, 0x1e7, (0x7f << 0),
-			    (NPHY_TxPwrCtrlCmd_pwrIndex_init_rev7 << 0));
-	else
-		mod_phy_reg(pi, 0x1e7, (0x7f << 0),
-			    (NPHY_TxPwrCtrlCmd_pwrIndex_init << 0));
+		if (NREV_GE(pi->pubpi.phy_rev, 3))
+			wlc_phy_txpwr_nphy_po_apply(tx_srom_max_rate,
+						    tmp_stbcpo,
+						    TXP_FIRST_MCS_20_STBC,
+						    TXP_LAST_MCS_20_STBC);
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7))
-		mod_phy_reg(pi, 0x222, (0xff << 0),
-			    (NPHY_TxPwrCtrlCmd_pwrIndex_init_rev7 << 0));
-	else if (NREV_GT(pi->pubpi.phy_rev, 1))
-		mod_phy_reg(pi, 0x222, (0xff << 0),
-			    (NPHY_TxPwrCtrlCmd_pwrIndex_init << 0));
+		wlc_phy_txpwr_nphy_srom_convert(tx_srom_max_rate,
+						&pwr_offsets2[2], tmp_max_pwr,
+						TXP_FIRST_MCS_20_SDM,
+						TXP_LAST_MCS_20_SDM);
 
-	if (D11REV_IS(pi->sh->corerev, 11) || D11REV_IS(pi->sh->corerev, 12))
-		wlapi_bmac_mctrl(pi->sh->physhim, MCTL_PHYLOCK, 0);
+		if (NPHY_IS_SROM_REINTERPRET) {
 
-	write_phy_reg(pi, 0x1e8, (0x3 << 8) | (240 << 0));
+			wlc_phy_txpwr_nphy_srom_convert(tx_srom_max_rate,
+							&pwr_offsets2[4],
+							tmp_max_pwr,
+							TXP_FIRST_MCS_40_SISO,
+							TXP_LAST_MCS_40_SISO);
 
-	write_phy_reg(pi, 0x1e9,
-		      (1 << 15) | (idle_tssi[0] << 0) | (idle_tssi[1] << 8));
+			wlc_phy_mcs_to_ofdm_powers_nphy(tx_srom_max_rate,
+							TXP_FIRST_OFDM_40_SISO,
+							TXP_LAST_OFDM_40_SISO,
+							TXP_FIRST_MCS_40_SISO);
 
-	write_phy_reg(pi, 0x1ea,
-		      (target_pwr_qtrdbm[0] << 0) |
-		      (target_pwr_qtrdbm[1] << 8));
+			wlc_phy_txpwr_nphy_srom_convert(tx_srom_max_rate,
+							&pwr_offsets2[4],
+							tmp_max_pwr,
+							TXP_FIRST_MCS_40_CDD,
+							TXP_LAST_MCS_40_CDD);
 
-	tbl_len = 64;
-	tbl_offset = 0;
-	for (tbl_id = NPHY_TBL_ID_CORE1TXPWRCTL;
-	     tbl_id <= NPHY_TBL_ID_CORE2TXPWRCTL; tbl_id++) {
+			wlc_phy_txpwr_nphy_po_apply(tx_srom_max_rate, tmp_cddpo,
+						    TXP_FIRST_MCS_40_CDD,
+						    TXP_LAST_MCS_40_CDD);
 
-		for (idx = 0; idx < tbl_len; idx++) {
-			num = 8 *
-			      (16 * b0[tbl_id - 26] + b1[tbl_id - 26] * idx);
-			den = 32768 + a1[tbl_id - 26] * idx;
-			pwr_est = max(((4 * num + den / 2) / den), -8);
-			if (NREV_LT(pi->pubpi.phy_rev, 3)) {
-				if (idx <=
-				    (uint) (31 - idle_tssi[tbl_id - 26] + 1))
-					pwr_est =
-						max(pwr_est,
-						    target_pwr_qtrdbm
-						    [tbl_id - 26] + 1);
-			}
-			regval[idx] = (u32) pwr_est;
+			wlc_phy_mcs_to_ofdm_powers_nphy(tx_srom_max_rate,
+							TXP_FIRST_OFDM_40_CDD,
+							TXP_LAST_OFDM_40_CDD,
+							TXP_FIRST_MCS_40_CDD);
+
+			wlc_phy_txpwr_nphy_srom_convert(tx_srom_max_rate,
+							&pwr_offsets2[4],
+							tmp_max_pwr,
+							TXP_FIRST_MCS_40_STBC,
+							TXP_LAST_MCS_40_STBC);
+
+			wlc_phy_txpwr_nphy_po_apply(tx_srom_max_rate,
+						    tmp_stbcpo,
+						    TXP_FIRST_MCS_40_STBC,
+						    TXP_LAST_MCS_40_STBC);
+
+			wlc_phy_txpwr_nphy_srom_convert(tx_srom_max_rate,
+							&pwr_offsets2[6],
+							tmp_max_pwr,
+							TXP_FIRST_MCS_40_SDM,
+							TXP_LAST_MCS_40_SDM);
+		} else {
+
+			for (rate1 = TXP_FIRST_OFDM_40_SISO, rate2 =
+				     TXP_FIRST_OFDM;
+			     rate1 <= TXP_LAST_MCS_40_SDM;
+			     rate1++, rate2++)
+				tx_srom_max_rate[rate1] =
+					tx_srom_max_rate[rate2];
 		}
-		wlc_phy_table_write_nphy(pi, tbl_id, tbl_len, tbl_offset, 32,
-					 regval);
-	}
 
-	wlc_phy_txpwr_limit_to_tbl_nphy(pi);
-	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_CORE1TXPWRCTL, 84, 64, 8,
-				 pi->adj_pwr_tbl_nphy);
-	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_CORE2TXPWRCTL, 84, 64, 8,
-				 pi->adj_pwr_tbl_nphy);
+		if (NREV_GE(pi->pubpi.phy_rev, 3))
+			wlc_phy_txpwr_nphy_po_apply(tx_srom_max_rate,
+						    tmp_bw40po,
+						    TXP_FIRST_OFDM_40_SISO,
+						    TXP_LAST_MCS_40_SDM);
 
-	if (pi->phyhang_avoid)
-		wlc_phy_stay_in_carriersearch_nphy(pi, false);
-}
+		tx_srom_max_rate[TXP_MCS_32] =
+			tx_srom_max_rate[TXP_FIRST_MCS_40_CDD];
+	}
 
-static bool wlc_phy_txpwr_ison_nphy(struct brcms_phy *pi)
-{
-	return read_phy_reg((pi), 0x1e7) & ((0x1 << 15) |
-					    (0x1 << 14) | (0x1 << 13));
+	return;
 }
 
-static u8 wlc_phy_txpwr_idx_cur_get_nphy(struct brcms_phy *pi, u8 core)
+void wlc_phy_txpower_recalc_target_nphy(struct brcms_phy *pi)
 {
-	u16 tmp;
-	tmp = read_phy_reg(pi, ((core == PHY_CORE_0) ? 0x1ed : 0x1ee));
+	u8 tx_pwr_ctrl_state;
+	wlc_phy_txpwr_limit_to_tbl_nphy(pi);
+	wlc_phy_txpwrctrl_pwr_setup_nphy(pi);
 
-	tmp = (tmp & (0x7f << 8)) >> 8;
-	return (u8) tmp;
+	tx_pwr_ctrl_state = pi->nphy_txpwrctrl;
+
+	if (D11REV_IS(pi->sh->corerev, 11) || D11REV_IS(pi->sh->corerev, 12)) {
+		wlapi_bmac_mctrl(pi->sh->physhim, MCTL_PHYLOCK, MCTL_PHYLOCK);
+		(void)R_REG(&pi->regs->maccontrol);
+		udelay(1);
+	}
+
+	wlc_phy_txpwrctrl_enable_nphy(pi, tx_pwr_ctrl_state);
+
+	if (D11REV_IS(pi->sh->corerev, 11) || D11REV_IS(pi->sh->corerev, 12))
+		wlapi_bmac_mctrl(pi->sh->physhim, MCTL_PHYLOCK, 0);
 }
 
-static void
-wlc_phy_txpwr_idx_cur_set_nphy(struct brcms_phy *pi, u8 idx0, u8 idx1)
+static bool wlc_phy_txpwr_ison_nphy(struct brcms_phy *pi)
 {
-	mod_phy_reg(pi, 0x1e7, (0x7f << 0), idx0);
-
-	if (NREV_GT(pi->pubpi.phy_rev, 1))
-		mod_phy_reg(pi, 0x222, (0xff << 0), idx1);
+	return read_phy_reg((pi), 0x1e7) & ((0x1 << 15) |
+					    (0x1 << 14) | (0x1 << 13));
 }
 
 u16 wlc_phy_txpwr_idx_get_nphy(struct brcms_phy *pi)
-- 
1.7.4.1


