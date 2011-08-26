Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4815 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194Ab1HZNT5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 09:19:57 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 10/13] staging: brcm80211: removed NORADIO_ENAB() macro
 from softmac phy code
Date: Fri, 26 Aug 2011 15:19:37 +0200
Message-ID: <1314364780-9462-11-git-send-email-rvossen@broadcom.com> (sfid-20110826_152018_398133_B702871A)
In-Reply-To: <1314364780-9462-1-git-send-email-rvossen@broadcom.com>
References: <1314364780-9462-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. Preprocessor constant EXT_CBALL was never defined so removed
related code.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |   35 ------
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h |    6 -
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c |   57 +--------
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c   |  140 ++++++++-------------
 4 files changed, 57 insertions(+), 181 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index cbb0bde..3d54a39 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -220,9 +220,6 @@ u16 read_radio_reg(struct brcms_phy *pi, u16 addr)
 	if ((addr == RADIO_IDCODE))
 		return 0xffff;
 
-	if (NORADIO_ENAB(pi->pubpi))
-		return NORADIO_IDCODE & 0xffff;
-
 	switch (pi->pubpi.phy_type) {
 	case PHY_TYPE_N:
 		CASECHECK(PHYTYPE, PHY_TYPE_N);
@@ -265,9 +262,6 @@ u16 read_radio_reg(struct brcms_phy *pi, u16 addr)
 
 void write_radio_reg(struct brcms_phy *pi, u16 addr, u16 val)
 {
-	if (NORADIO_ENAB(pi->pubpi))
-		return;
-
 	if ((D11REV_GE(pi->sh->corerev, 24)) ||
 	    (D11REV_IS(pi->sh->corerev, 22)
 	     && (pi->pubpi.phy_type != PHY_TYPE_SSN))) {
@@ -289,9 +283,6 @@ static u32 read_radio_id(struct brcms_phy *pi)
 {
 	u32 id;
 
-	if (NORADIO_ENAB(pi->pubpi))
-		return NORADIO_IDCODE;
-
 	if (D11REV_GE(pi->sh->corerev, 24)) {
 		u32 b0, b1, b2;
 
@@ -317,9 +308,6 @@ void and_radio_reg(struct brcms_phy *pi, u16 addr, u16 val)
 {
 	u16 rval;
 
-	if (NORADIO_ENAB(pi->pubpi))
-		return;
-
 	rval = read_radio_reg(pi, addr);
 	write_radio_reg(pi, addr, (rval & val));
 }
@@ -328,9 +316,6 @@ void or_radio_reg(struct brcms_phy *pi, u16 addr, u16 val)
 {
 	u16 rval;
 
-	if (NORADIO_ENAB(pi->pubpi))
-		return;
-
 	rval = read_radio_reg(pi, addr);
 	write_radio_reg(pi, addr, (rval | val));
 }
@@ -339,9 +324,6 @@ void xor_radio_reg(struct brcms_phy *pi, u16 addr, u16 mask)
 {
 	u16 rval;
 
-	if (NORADIO_ENAB(pi->pubpi))
-		return;
-
 	rval = read_radio_reg(pi, addr);
 	write_radio_reg(pi, addr, (rval ^ mask));
 }
@@ -350,9 +332,6 @@ void mod_radio_reg(struct brcms_phy *pi, u16 addr, u16 mask, u16 val)
 {
 	u16 rval;
 
-	if (NORADIO_ENAB(pi->pubpi))
-		return;
-
 	rval = read_radio_reg(pi, addr);
 	write_radio_reg(pi, addr, (rval & ~mask) | (val & mask));
 }
@@ -1225,9 +1204,6 @@ void wlc_phy_switch_radio(struct brcms_phy_pub *pih, bool on)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
-	if (NORADIO_ENAB(pi->pubpi))
-		return;
-
 	{
 		uint mc;
 
@@ -2308,9 +2284,6 @@ wlc_phy_noise_sample_request(struct brcms_phy_pub *pih, u8 reason, u8 ch)
 	bool sampling_in_progress = (pi->phynoise_state != 0);
 	bool wait_for_intr = true;
 
-	if (NORADIO_ENAB(pi->pubpi))
-		return;
-
 	switch (reason) {
 	case PHY_NOISE_SAMPLE_MON:
 		pi->phynoise_chan_watchdog = ch;
@@ -2618,11 +2591,6 @@ void wlc_phy_rssi_compute(struct brcms_phy_pub *pih,
 	uint radioid = pih->radioid;
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
-	if (NORADIO_ENAB(pi->pubpi)) {
-		rssi = BRCMS_RSSI_INVALID;
-		goto end;
-	}
-
 	if ((pi->sh->corerev >= 11)
 	    && !(le16_to_cpu(rxh->RxStatus2) & RXS_PHYRXST_VALID)) {
 		rssi = BRCMS_RSSI_INVALID;
@@ -2704,9 +2672,6 @@ void wlc_phy_watchdog(struct brcms_phy_pub *pih)
 			pi->phycal_txpower = pi->sh->now;
 	}
 
-	if (NORADIO_ENAB(pi->pubpi))
-		return;
-
 	if ((SCAN_RM_IN_PROGRESS(pi) || PLT_INPROG_PHY(pi)
 	     || ASSOC_INPROG_PHY(pi)))
 		return;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
index 0594a08..7ec2ad2 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
@@ -297,12 +297,6 @@ enum phy_cal_mode {
 #define PUB_NOT_ASSOC(pi) \
 	(mboolisset(pi->measure_hold, PHY_HOLD_FOR_NOT_ASSOC))
 
-#if defined(EXT_CBALL)
-#define NORADIO_ENAB(pub) ((pub).radioid == NORADIO_ID)
-#else
-#define NORADIO_ENAB(pub) 0
-#endif
-
 #define PHY_LTRN_LIST_LEN	64
 extern u16 ltrn_list[PHY_LTRN_LIST_LEN];
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
index 269346e..47f96a9 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -1218,10 +1218,8 @@ void wlc_phy_chanspec_set_lcnphy(struct brcms_phy *pi, u16 chanspec)
 	or_phy_reg(pi, 0x44a, 0x44);
 	write_phy_reg(pi, 0x44a, 0x80);
 
-	if (!NORADIO_ENAB(pi->pubpi)) {
-		wlc_lcnphy_radio_2064_channel_tune_4313(pi, channel);
-		udelay(1000);
-	}
+	wlc_lcnphy_radio_2064_channel_tune_4313(pi, channel);
+	udelay(1000);
 
 	wlc_lcnphy_toggle_afe_pwdn(pi);
 
@@ -1704,9 +1702,6 @@ static s8 wlc_lcnphy_tempcompensated_txpwrctrl(struct brcms_phy *pi)
 
 	index = FIXED_TXPWR;
 
-	if (NORADIO_ENAB(pi->pubpi))
-		return index;
-
 	if (pi_lcn->lcnphy_tempsense_slope == 0)
 		return index;
 
@@ -1875,9 +1870,6 @@ wlc_lcnphy_tx_iqlo_cal(struct brcms_phy *pi,
 	u16 *values_to_save;
 	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
-	if (NORADIO_ENAB(pi->pubpi))
-		return;
-
 	values_to_save = kmalloc(sizeof(u16) * 20, GFP_ATOMIC);
 	if (NULL == values_to_save)
 		return;
@@ -2291,13 +2283,6 @@ static void wlc_lcnphy_tx_pwr_ctrl_init(struct brcms_phy_pub *ppi)
 	if (!suspend)
 		wlapi_suspend_mac_and_wait(pi->sh->physhim);
 
-	if (NORADIO_ENAB(pi->pubpi)) {
-		wlc_lcnphy_set_bbmult(pi, 0x30);
-		if (!suspend)
-			wlapi_enable_mac(pi->sh->physhim);
-		return;
-	}
-
 	if (!pi->hwpwrctrl_capable) {
 		if (CHSPEC_IS2G(pi->radio_chanspec)) {
 			tx_gains.gm_gain = 4;
@@ -2965,9 +2950,6 @@ s16 wlc_lcnphy_tempsense_new(struct brcms_phy *pi, bool mode)
 	s16 avg = 0;
 	bool suspend = 0;
 
-	if (NORADIO_ENAB(pi->pubpi))
-		return -1;
-
 	if (mode == 1) {
 		suspend =
 			(0 ==
@@ -3012,9 +2994,6 @@ u16 wlc_lcnphy_tempsense(struct brcms_phy *pi, bool mode)
 	u16 SAVE_txpwrctrl = wlc_lcnphy_get_tx_pwr_ctrl(pi);
 	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
-	if (NORADIO_ENAB(pi->pubpi))
-		return -1;
-
 	if (mode == 1) {
 		suspend =
 			(0 ==
@@ -3081,9 +3060,6 @@ s8 wlc_lcnphy_vbatsense(struct brcms_phy *pi, bool mode)
 	s32 avg = 0;
 	bool suspend = 0;
 
-	if (NORADIO_ENAB(pi->pubpi))
-		return -1;
-
 	if (mode == 1) {
 		suspend =
 			(0 ==
@@ -3420,8 +3396,6 @@ cal_done:
 
 static void wlc_lcnphy_temp_adj(struct brcms_phy *pi)
 {
-	if (NORADIO_ENAB(pi->pubpi))
-		return;
 }
 
 static void wlc_lcnphy_glacial_timer_based_cal(struct brcms_phy *pi)
@@ -3461,9 +3435,6 @@ static void wlc_lcnphy_periodic_cal(struct brcms_phy *pi)
 	s32 tssi, pwr, maxtargetpwr, mintargetpwr;
 	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
-	if (NORADIO_ENAB(pi->pubpi))
-		return;
-
 	pi->phy_lastcal = pi->sh->now;
 	pi->phy_forcecal = false;
 	full_cal =
@@ -3594,9 +3565,6 @@ wlc_lcnphy_set_chanspec_tweaks(struct brcms_phy *pi, u16 chanspec)
 	u8 channel = CHSPEC_CHANNEL(chanspec);
 	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
-	if (NORADIO_ENAB(pi->pubpi))
-		return;
-
 	if (channel == 14)
 		mod_phy_reg(pi, 0x448, (0x3 << 8), (2) << 8);
 	else
@@ -4444,9 +4412,6 @@ static void wlc_lcnphy_agc_temp_init(struct brcms_phy *pi)
 	u32 tableBuffer[2];
 	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
-	if (NORADIO_ENAB(pi->pubpi))
-		return;
-
 	temp = (s16) read_phy_reg(pi, 0x4df);
 	pi_lcn->lcnphy_ofdmgainidxtableoffset = (temp & (0xff << 0)) >> 0;
 
@@ -4497,9 +4462,6 @@ static void wlc_lcnphy_agc_temp_init(struct brcms_phy *pi)
 
 static void wlc_lcnphy_bu_tweaks(struct brcms_phy *pi)
 {
-	if (NORADIO_ENAB(pi->pubpi))
-		return;
-
 	or_phy_reg(pi, 0x805, 0x1);
 
 	mod_phy_reg(pi, 0x42f, (0x7 << 0), (0x3) << 0);
@@ -4623,9 +4585,6 @@ static void wlc_radio_2064_init(struct brcms_phy *pi)
 
 static void wlc_lcnphy_radio_init(struct brcms_phy *pi)
 {
-	if (NORADIO_ENAB(pi->pubpi))
-		return;
-
 	wlc_radio_2064_init(pi);
 }
 
@@ -4633,9 +4592,6 @@ static void wlc_lcnphy_rcal(struct brcms_phy *pi)
 {
 	u8 rcal_value;
 
-	if (NORADIO_ENAB(pi->pubpi))
-		return;
-
 	and_radio_reg(pi, RADIO_2064_REG05B, 0xfD);
 
 	or_radio_reg(pi, RADIO_2064_REG004, 0x40);
@@ -4665,9 +4621,6 @@ static void wlc_lcnphy_rc_cal(struct brcms_phy *pi)
 	u8 dflt_rc_cal_val;
 	u16 flt_val;
 
-	if (NORADIO_ENAB(pi->pubpi))
-		return;
-
 	dflt_rc_cal_val = 7;
 	if (LCNREV_IS(pi->pubpi.phy_rev, 1))
 		dflt_rc_cal_val = 11;
@@ -4830,8 +4783,7 @@ wlc_lcnphy_radio_2064_channel_tune_4313(struct brcms_phy *pi, u8 channel)
 	u8 d15, d16, f16, e44, e45;
 	u32 div_int, div_frac, fvco3, fpfd, fref3, fcal_div;
 	u16 loop_bw, d30, setCount;
-	if (NORADIO_ENAB(pi->pubpi))
-		return;
+
 	ci = &chan_info_2064_lcnphy[0];
 	rfpll_doubler = 1;
 
@@ -5021,8 +4973,7 @@ bool wlc_phy_attach_lcnphy(struct brcms_phy *pi)
 
 	pi_lcn = pi->u.pi_lcnphy;
 
-	if ((0 == (pi->sh->boardflags & BFL_NOPA)) &&
-	    !NORADIO_ENAB(pi->pubpi)) {
+	if (0 == (pi->sh->boardflags & BFL_NOPA)) {
 		pi->hwpwrctrl = true;
 		pi->hwpwrctrl_capable = true;
 	}
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
index 2d90f09..c5b7ad4 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
@@ -14256,17 +14256,7 @@ static void wlc_phy_bphy_init_nphy(struct brcms_phy *pi)
 			val -= 0x0202;
 	}
 
-	if (NORADIO_ENAB(pi->pubpi)) {
-
-		write_phy_reg(pi, NPHY_TO_BPHY_OFF + BPHY_PHYCRSTH, 0x3206);
-
-		write_phy_reg(pi, NPHY_TO_BPHY_OFF + BPHY_RSSI_TRESH, 0x281e);
-
-		or_phy_reg(pi, NPHY_TO_BPHY_OFF + BPHY_LNA_GAIN_RANGE, 0x1a);
-
-	} else {
-		write_phy_reg(pi, NPHY_TO_BPHY_OFF + BPHY_STEP, 0x668);
-	}
+	write_phy_reg(pi, NPHY_TO_BPHY_OFF + BPHY_STEP, 0x668);
 }
 
 void
@@ -14595,6 +14585,7 @@ void wlc_phy_init_nphy(struct brcms_phy *pi)
 	uint origidx, intr_val;
 	struct d11regs *regs;
 	u32 d11_clk_ctl_st;
+	bool do_rssi_cal = false;
 
 	core = 0;
 
@@ -14858,73 +14849,69 @@ void wlc_phy_init_nphy(struct brcms_phy *pi)
 	if (PHY_PERICAL_MPHASE_PENDING(pi))
 		wlc_phy_cal_perical_mphase_restart(pi);
 
-	if (!NORADIO_ENAB(pi->pubpi)) {
-		bool do_rssi_cal = false;
-
-		if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-			do_rssi_cal = (CHSPEC_IS2G(pi->radio_chanspec)) ?
-				      (pi->nphy_rssical_chanspec_2G == 0) :
-				      (pi->nphy_rssical_chanspec_5G == 0);
+	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+		do_rssi_cal = (CHSPEC_IS2G(pi->radio_chanspec)) ?
+			      (pi->nphy_rssical_chanspec_2G == 0) :
+			      (pi->nphy_rssical_chanspec_5G == 0);
 
-			if (do_rssi_cal)
-				wlc_phy_rssi_cal_nphy(pi);
-			else
-				wlc_phy_restore_rssical_nphy(pi);
-		} else {
+		if (do_rssi_cal)
 			wlc_phy_rssi_cal_nphy(pi);
-		}
+		else
+			wlc_phy_restore_rssical_nphy(pi);
+	} else {
+		wlc_phy_rssi_cal_nphy(pi);
+	}
 
-		if (!SCAN_RM_IN_PROGRESS(pi))
-			do_nphy_cal = (CHSPEC_IS2G(pi->radio_chanspec)) ?
-				      (pi->nphy_iqcal_chanspec_2G == 0) :
-				      (pi->nphy_iqcal_chanspec_5G == 0);
+	if (!SCAN_RM_IN_PROGRESS(pi))
+		do_nphy_cal = (CHSPEC_IS2G(pi->radio_chanspec)) ?
+			      (pi->nphy_iqcal_chanspec_2G == 0) :
+			      (pi->nphy_iqcal_chanspec_5G == 0);
 
-		if (!pi->do_initcal)
-			do_nphy_cal = false;
+	if (!pi->do_initcal)
+		do_nphy_cal = false;
 
-		if (do_nphy_cal) {
+	if (do_nphy_cal) {
 
-			target_gain = wlc_phy_get_tx_gain_nphy(pi);
+		target_gain = wlc_phy_get_tx_gain_nphy(pi);
 
-			if (pi->antsel_type == ANTSEL_2x3)
-				wlc_phy_antsel_init((struct brcms_phy_pub *) pi,
-						    true);
+		if (pi->antsel_type == ANTSEL_2x3)
+			wlc_phy_antsel_init((struct brcms_phy_pub *) pi,
+					    true);
 
-			if (pi->nphy_perical != PHY_PERICAL_MPHASE) {
-				wlc_phy_rssi_cal_nphy(pi);
+		if (pi->nphy_perical != PHY_PERICAL_MPHASE) {
+			wlc_phy_rssi_cal_nphy(pi);
 
-				if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-					pi->nphy_cal_orig_pwr_idx[0] =
-						pi->nphy_txpwrindex[PHY_CORE_0]
-						.
-						index_internal;
-					pi->nphy_cal_orig_pwr_idx[1] =
-						pi->nphy_txpwrindex[PHY_CORE_1]
-						.
-						index_internal;
-
-					wlc_phy_precal_txgain_nphy(pi);
-					target_gain =
-						wlc_phy_get_tx_gain_nphy(pi);
-				}
+			if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+				pi->nphy_cal_orig_pwr_idx[0] =
+					pi->nphy_txpwrindex[PHY_CORE_0]
+					.
+					index_internal;
+				pi->nphy_cal_orig_pwr_idx[1] =
+					pi->nphy_txpwrindex[PHY_CORE_1]
+					.
+					index_internal;
 
-				if (wlc_phy_cal_txiqlo_nphy
-					    (pi, target_gain, true,
-					    false) == 0) {
-					if (wlc_phy_cal_rxiq_nphy
-						    (pi, target_gain, 2,
-						    false) == 0)
-						wlc_phy_savecal_nphy(pi);
+				wlc_phy_precal_txgain_nphy(pi);
+				target_gain =
+					wlc_phy_get_tx_gain_nphy(pi);
+			}
+
+			if (wlc_phy_cal_txiqlo_nphy
+				    (pi, target_gain, true,
+				    false) == 0) {
+				if (wlc_phy_cal_rxiq_nphy
+					    (pi, target_gain, 2,
+					    false) == 0)
+					wlc_phy_savecal_nphy(pi);
 
-				}
-			} else if (pi->mphase_cal_phase_id ==
-				   MPHASE_CAL_STATE_IDLE) {
-				wlc_phy_cal_perical((struct brcms_phy_pub *) pi,
-						    PHY_PERICAL_PHYINIT);
 			}
-		} else {
-			wlc_phy_restorecal_nphy(pi);
+		} else if (pi->mphase_cal_phase_id ==
+			   MPHASE_CAL_STATE_IDLE) {
+			wlc_phy_cal_perical((struct brcms_phy_pub *) pi,
+					    PHY_PERICAL_PHYINIT);
 		}
+	} else {
+		wlc_phy_restorecal_nphy(pi);
 	}
 
 	wlc_phy_txpwrctrl_coeff_setup_nphy(pi);
@@ -15595,8 +15582,7 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 				NPHY_REV7_RFCTRLOVERRIDE_ID2);
 		}
 
-		if (!NORADIO_ENAB(pi->pubpi))
-			write_phy_reg(pi, 0x32f, 0x3);
+		write_phy_reg(pi, 0x32f, 0x3);
 
 		if ((pi->pubpi.radiorev == 4) || (pi->pubpi.radiorev == 6))
 			wlc_phy_rfctrl_override_nphy_rev7(
@@ -17662,9 +17648,6 @@ wlc_phy_chan2freq_nphy(struct brcms_phy *pi, uint channel, int *f,
 				break;
 
 			default:
-				if (NORADIO_ENAB(pi->pubpi))
-					goto fail;
-
 				break;
 			}
 		} else if (NREV_IS(pi->pubpi.phy_rev, 16)) {
@@ -17732,9 +17715,6 @@ wlc_phy_chan2freq_nphy(struct brcms_phy *pi, uint channel, int *f,
 						    chan_info_nphyrev6_2056v11);
 				break;
 			default:
-				if (NORADIO_ENAB(pi->pubpi))
-					goto fail;
-
 				break;
 			}
 		}
@@ -17778,9 +17758,6 @@ u8 wlc_phy_get_chan_freq_range_nphy(struct brcms_phy *pi, uint channel)
 	struct chan_info_nphy_radio2057_rev5 *t2 = NULL;
 	struct chan_info_nphy_2055 *t3 = NULL;
 
-	if (NORADIO_ENAB(pi->pubpi))
-		return WL_CHAN_FREQ_RANGE_2G;
-
 	if (channel == 0)
 		channel = CHSPEC_CHANNEL(pi->radio_chanspec);
 
@@ -19053,9 +19030,6 @@ void wlc_phy_chanspec_set_nphy(struct brcms_phy *pi, u16 chanspec)
 	struct chan_info_nphy_radio2057_rev5 *t2 = NULL;
 	struct chan_info_nphy_2055 *t3 = NULL;
 
-	if (NORADIO_ENAB(pi->pubpi))
-		return;
-
 	if (!wlc_phy_chan2freq_nphy
 		    (pi, CHSPEC_CHANNEL(chanspec), &freq, &t0, &t1, &t2, &t3))
 		return;
@@ -23669,11 +23643,6 @@ void wlc_phy_cal_perical_nphy_run(struct brcms_phy *pi, u8 caltype)
 	bool restore_tx_gain = false;
 	bool mphase;
 
-	if (NORADIO_ENAB(pi->pubpi)) {
-		wlc_phy_cal_perical_mphase_reset(pi);
-		return;
-	}
-
 	if (PHY_MUTED(pi))
 		return;
 
@@ -27023,9 +26992,6 @@ static void wlc_phy_a4(struct brcms_phy *pi, bool full_cal)
 	pi->nphy_papd_last_cal = pi->sh->now;
 	pi->nphy_papd_recal_counter++;
 
-	if (NORADIO_ENAB(pi->pubpi))
-		return;
-
 	phy_b4 = pi->nphy_txpwrctrl;
 	wlc_phy_txpwrctrl_enable_nphy(pi, PHY_TPC_HW_OFF);
 
-- 
1.7.4.1


