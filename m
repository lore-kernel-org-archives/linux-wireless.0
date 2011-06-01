Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4830 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758869Ab1FALqv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:51 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 01/83] staging: brcm80211: removed unused Broadcom
 specific ioctls codes
Date: Wed, 1 Jun 2011 13:44:46 +0200
Message-ID: <1306928768-7501-1-git-send-email-rvossen@broadcom.com> (sfid-20110601_134831_472412_7E55C698)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. Removal of code that is not invoked.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c   |   21 -
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h   |    1 -
 drivers/staging/brcm80211/brcmsmac/wlc_main.c      | 1184 +-------------------
 drivers/staging/brcm80211/brcmsmac/wlc_main.h      |    5 -
 drivers/staging/brcm80211/brcmsmac/wlc_pub.h       |    9 -
 drivers/staging/brcm80211/brcmsmac/wlc_stf.c       |   33 -
 drivers/staging/brcm80211/brcmsmac/wlc_stf.h       |    2 -
 7 files changed, 5 insertions(+), 1250 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
index 6cba4df..f45628a 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
@@ -2350,27 +2350,6 @@ bool wlc_phy_test_ison(wlc_phy_t *ppi)
 	return pi->phytest_on;
 }
 
-bool wlc_phy_ant_rxdiv_get(wlc_phy_t *ppi, u8 *pval)
-{
-	phy_info_t *pi = (phy_info_t *) ppi;
-	bool ret = true;
-
-	wlc_phyreg_enter(ppi);
-
-	if (ISNPHY(pi)) {
-
-		ret = false;
-	} else if (ISLCNPHY(pi)) {
-		u16 crsctrl = read_phy_reg(pi, 0x410);
-		u16 div = crsctrl & (0x1 << 1);
-		*pval = (div | ((crsctrl & (0x1 << 0)) ^ (div >> 1)));
-	}
-
-	wlc_phyreg_exit(ppi);
-
-	return ret;
-}
-
 void wlc_phy_ant_rxdiv_set(wlc_phy_t *ppi, u8 val)
 {
 	phy_info_t *pi = (phy_info_t *) ppi;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h
index 8939153..1ef96c7 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h
@@ -226,7 +226,6 @@ extern void wlc_phy_edcrs_lock(wlc_phy_t *pih, bool lock);
 extern void wlc_phy_cal_papd_recal(wlc_phy_t *ppi);
 
 extern void wlc_phy_ant_rxdiv_set(wlc_phy_t *ppi, u8 val);
-extern bool wlc_phy_ant_rxdiv_get(wlc_phy_t *ppi, u8 *pval);
 extern void wlc_phy_clear_tssi(wlc_phy_t *ppi);
 extern void wlc_phy_hold_upd(wlc_phy_t *ppi, mbool id, bool val);
 extern void wlc_phy_mute_upd(wlc_phy_t *ppi, bool val, mbool flags);
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index 4b4a31e..2425fda 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -71,7 +71,6 @@
 #define ALLPRIO		-1
 
 /*
- * buffer length needed for wlc_format_ssid
  * 32 SSID chars, max of 4 chars for each SSID char "\xFF", plus NULL.
  */
 #define SSID_FMT_BUF_LEN	((4 * IEEE80211_MAX_SSID_LEN) + 1)
@@ -774,176 +773,6 @@ void wlc_set_chanspec(struct wlc_info *wlc, chanspec_t chanspec)
 	wlc_ucode_mac_upd(wlc);
 }
 
-#if defined(BCMDBG)
-static int wlc_get_current_txpwr(struct wlc_info *wlc, void *pwr, uint len)
-{
-	txpwr_limits_t txpwr;
-	tx_power_t power;
-	tx_power_legacy_t *old_power = NULL;
-	int r, c;
-	uint qdbm;
-	bool override;
-
-	if (len == sizeof(tx_power_legacy_t))
-		old_power = (tx_power_legacy_t *) pwr;
-	else if (len < sizeof(tx_power_t))
-		return -EOVERFLOW;
-
-	memset(&power, 0, sizeof(tx_power_t));
-
-	power.chanspec = WLC_BAND_PI_RADIO_CHANSPEC;
-	if (wlc->pub->associated)
-		power.local_chanspec = wlc->home_chanspec;
-
-	/* Return the user target tx power limits for the various rates.  Note  wlc_phy.c's
-	 * public interface only implements getting and setting a single value for all of
-	 * rates, so we need to fill the array ourselves.
-	 */
-	wlc_phy_txpower_get(wlc->band->pi, &qdbm, &override);
-	for (r = 0; r < WL_TX_POWER_RATES; r++) {
-		power.user_limit[r] = (u8) qdbm;
-	}
-
-	power.local_max = wlc->txpwr_local_max * WLC_TXPWR_DB_FACTOR;
-	power.local_constraint =
-	    wlc->txpwr_local_constraint * WLC_TXPWR_DB_FACTOR;
-
-	power.antgain[0] = wlc->bandstate[BAND_2G_INDEX]->antgain;
-	power.antgain[1] = wlc->bandstate[BAND_5G_INDEX]->antgain;
-
-	wlc_channel_reg_limits(wlc->cmi, power.chanspec, &txpwr);
-
-#if WL_TX_POWER_CCK_NUM != WLC_NUM_RATES_CCK
-#error "WL_TX_POWER_CCK_NUM != WLC_NUM_RATES_CCK"
-#endif
-
-	/* CCK tx power limits */
-	for (c = 0, r = WL_TX_POWER_CCK_FIRST; c < WL_TX_POWER_CCK_NUM;
-	     c++, r++)
-		power.reg_limit[r] = txpwr.cck[c];
-
-#if WL_TX_POWER_OFDM_NUM != WLC_NUM_RATES_OFDM
-#error "WL_TX_POWER_OFDM_NUM != WLC_NUM_RATES_OFDM"
-#endif
-
-	/* 20 MHz OFDM SISO tx power limits */
-	for (c = 0, r = WL_TX_POWER_OFDM_FIRST; c < WL_TX_POWER_OFDM_NUM;
-	     c++, r++)
-		power.reg_limit[r] = txpwr.ofdm[c];
-
-	if (WLC_PHY_11N_CAP(wlc->band)) {
-
-		/* 20 MHz OFDM CDD tx power limits */
-		for (c = 0, r = WL_TX_POWER_OFDM20_CDD_FIRST;
-		     c < WL_TX_POWER_OFDM_NUM; c++, r++)
-			power.reg_limit[r] = txpwr.ofdm_cdd[c];
-
-		/* 40 MHz OFDM SISO tx power limits */
-		for (c = 0, r = WL_TX_POWER_OFDM40_SISO_FIRST;
-		     c < WL_TX_POWER_OFDM_NUM; c++, r++)
-			power.reg_limit[r] = txpwr.ofdm_40_siso[c];
-
-		/* 40 MHz OFDM CDD tx power limits */
-		for (c = 0, r = WL_TX_POWER_OFDM40_CDD_FIRST;
-		     c < WL_TX_POWER_OFDM_NUM; c++, r++)
-			power.reg_limit[r] = txpwr.ofdm_40_cdd[c];
-
-#if WL_TX_POWER_MCS_1_STREAM_NUM != WLC_NUM_RATES_MCS_1_STREAM
-#error "WL_TX_POWER_MCS_1_STREAM_NUM != WLC_NUM_RATES_MCS_1_STREAM"
-#endif
-
-		/* 20MHz MCS0-7 SISO tx power limits */
-		for (c = 0, r = WL_TX_POWER_MCS20_SISO_FIRST;
-		     c < WLC_NUM_RATES_MCS_1_STREAM; c++, r++)
-			power.reg_limit[r] = txpwr.mcs_20_siso[c];
-
-		/* 20MHz MCS0-7 CDD tx power limits */
-		for (c = 0, r = WL_TX_POWER_MCS20_CDD_FIRST;
-		     c < WLC_NUM_RATES_MCS_1_STREAM; c++, r++)
-			power.reg_limit[r] = txpwr.mcs_20_cdd[c];
-
-		/* 20MHz MCS0-7 STBC tx power limits */
-		for (c = 0, r = WL_TX_POWER_MCS20_STBC_FIRST;
-		     c < WLC_NUM_RATES_MCS_1_STREAM; c++, r++)
-			power.reg_limit[r] = txpwr.mcs_20_stbc[c];
-
-		/* 40MHz MCS0-7 SISO tx power limits */
-		for (c = 0, r = WL_TX_POWER_MCS40_SISO_FIRST;
-		     c < WLC_NUM_RATES_MCS_1_STREAM; c++, r++)
-			power.reg_limit[r] = txpwr.mcs_40_siso[c];
-
-		/* 40MHz MCS0-7 CDD tx power limits */
-		for (c = 0, r = WL_TX_POWER_MCS40_CDD_FIRST;
-		     c < WLC_NUM_RATES_MCS_1_STREAM; c++, r++)
-			power.reg_limit[r] = txpwr.mcs_40_cdd[c];
-
-		/* 40MHz MCS0-7 STBC tx power limits */
-		for (c = 0, r = WL_TX_POWER_MCS40_STBC_FIRST;
-		     c < WLC_NUM_RATES_MCS_1_STREAM; c++, r++)
-			power.reg_limit[r] = txpwr.mcs_40_stbc[c];
-
-#if WL_TX_POWER_MCS_2_STREAM_NUM != WLC_NUM_RATES_MCS_2_STREAM
-#error "WL_TX_POWER_MCS_2_STREAM_NUM != WLC_NUM_RATES_MCS_2_STREAM"
-#endif
-
-		/* 20MHz MCS8-15 SDM tx power limits */
-		for (c = 0, r = WL_TX_POWER_MCS20_SDM_FIRST;
-		     c < WLC_NUM_RATES_MCS_2_STREAM; c++, r++)
-			power.reg_limit[r] = txpwr.mcs_20_mimo[c];
-
-		/* 40MHz MCS8-15 SDM tx power limits */
-		for (c = 0, r = WL_TX_POWER_MCS40_SDM_FIRST;
-		     c < WLC_NUM_RATES_MCS_2_STREAM; c++, r++)
-			power.reg_limit[r] = txpwr.mcs_40_mimo[c];
-
-		/* MCS 32 */
-		power.reg_limit[WL_TX_POWER_MCS_32] = txpwr.mcs32;
-	}
-
-	wlc_phy_txpower_get_current(wlc->band->pi, &power,
-				    CHSPEC_CHANNEL(power.chanspec));
-
-	/* copy the tx_power_t struct to the return buffer,
-	 * or convert to a tx_power_legacy_t struct
-	 */
-	if (!old_power) {
-		memcpy(pwr, &power, sizeof(tx_power_t));
-	} else {
-		int band_idx = CHSPEC_IS2G(power.chanspec) ? 0 : 1;
-
-		memset(old_power, 0, sizeof(tx_power_legacy_t));
-
-		old_power->txpwr_local_max = power.local_max;
-		old_power->txpwr_local_constraint = power.local_constraint;
-		if (CHSPEC_IS2G(power.chanspec)) {
-			old_power->txpwr_chan_reg_max = txpwr.cck[0];
-			old_power->txpwr_est_Pout[band_idx] =
-			    power.est_Pout_cck;
-			old_power->txpwr_est_Pout_gofdm = power.est_Pout[0];
-		} else {
-			old_power->txpwr_chan_reg_max = txpwr.ofdm[0];
-			old_power->txpwr_est_Pout[band_idx] = power.est_Pout[0];
-		}
-		old_power->txpwr_antgain[0] = power.antgain[0];
-		old_power->txpwr_antgain[1] = power.antgain[1];
-
-		for (r = 0; r < NUM_PWRCTRL_RATES; r++) {
-			old_power->txpwr_band_max[r] = power.user_limit[r];
-			old_power->txpwr_limit[r] = power.reg_limit[r];
-			old_power->txpwr_target[band_idx][r] = power.target[r];
-			if (CHSPEC_IS2G(power.chanspec))
-				old_power->txpwr_bphy_cck_max[r] =
-				    power.board_limit[r];
-			else
-				old_power->txpwr_aphy_max[r] =
-				    power.board_limit[r];
-		}
-	}
-
-	return 0;
-}
-#endif				/* defined(BCMDBG) */
-
 static u32 wlc_watchdog_backup_bi(struct wlc_info *wlc)
 {
 	u32 bi;
@@ -960,38 +789,6 @@ static u32 wlc_watchdog_backup_bi(struct wlc_info *wlc)
 	return bi;
 }
 
-/* Change to run the watchdog either from a periodic timer or from tbtt handler.
- * Call watchdog from tbtt handler if tbtt is true, watchdog timer otherwise.
- */
-void wlc_watchdog_upd(struct wlc_info *wlc, bool tbtt)
-{
-	/* make sure changing watchdog driver is allowed */
-	if (!wlc->pub->up || !wlc->pub->align_wd_tbtt)
-		return;
-	if (!tbtt && wlc->WDarmed) {
-		wl_del_timer(wlc->wl, wlc->wdtimer);
-		wlc->WDarmed = false;
-	}
-
-	/* stop watchdog timer and use tbtt interrupt to drive watchdog */
-	if (tbtt && wlc->WDarmed) {
-		wl_del_timer(wlc->wl, wlc->wdtimer);
-		wlc->WDarmed = false;
-		wlc->WDlast = OSL_SYSUPTIME();
-	}
-	/* arm watchdog timer and drive the watchdog there */
-	else if (!tbtt && !wlc->WDarmed) {
-		wl_add_timer(wlc->wl, wlc->wdtimer, TIMER_INTERVAL_WATCHDOG,
-			     true);
-		wlc->WDarmed = true;
-	}
-	if (tbtt && !wlc->WDarmed) {
-		wl_add_timer(wlc->wl, wlc->wdtimer, wlc_watchdog_backup_bi(wlc),
-			     true);
-		wlc->WDarmed = true;
-	}
-}
-
 ratespec_t wlc_lowest_basic_rspec(struct wlc_info *wlc, wlc_rateset_t *rs)
 {
 	ratespec_t lowest_basic_rspec;
@@ -2781,7 +2578,6 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 	bool bool_val;
 	int bcmerror;
 	d11regs_t *regs;
-	uint i;
 	struct scb *nextscb;
 	bool ta_ok;
 	uint band;
@@ -2821,61 +2617,15 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 	bcmerror = 0;
 	regs = wlc->regs;
 
-	/* A few commands don't need any arguments; all the others do. */
-	switch (cmd) {
-	case WLC_UP:
-	case WLC_OUT:
-	case WLC_DOWN:
-	case WLC_DISASSOC:
-	case WLC_RESTART:
-	case WLC_REBOOT:
-	case WLC_START_CHANNEL_QA:
-	case WLC_INIT:
-		break;
-
-	default:
-		if ((arg == NULL) || (len <= 0)) {
-			wiphy_err(wlc->wiphy, "wl%d: %s: Command %d needs "
-				  "arguments\n",
-				  wlc->pub->unit, __func__, cmd);
-			bcmerror = -EINVAL;
-			goto done;
-		}
+	if ((arg == NULL) || (len <= 0)) {
+		wiphy_err(wlc->wiphy, "wl%d: %s: Command %d needs arguments\n",
+			  wlc->pub->unit, __func__, cmd);
+		bcmerror = -EINVAL;
+		goto done;
 	}
 
 	switch (cmd) {
 
-#if defined(BCMDBG)
-	case WLC_GET_MSGLEVEL:
-		*pval = wl_msg_level;
-		break;
-
-	case WLC_SET_MSGLEVEL:
-		wl_msg_level = val;
-		break;
-#endif
-
-	case WLC_GET_INSTANCE:
-		*pval = wlc->pub->unit;
-		break;
-
-	case WLC_GET_CHANNEL:{
-			channel_info_t *ci = (channel_info_t *) arg;
-
-			if (len <= (int)sizeof(ci)) {
-				bcmerror = EOVERFLOW;
-				goto done;
-			}
-
-			ci->hw_channel =
-			    CHSPEC_CHANNEL(WLC_BAND_PI_RADIO_CHANSPEC);
-			ci->target_channel =
-			    CHSPEC_CHANNEL(wlc->default_bss->chanspec);
-			ci->scan_channel = 0;
-
-			break;
-		}
-
 	case WLC_SET_CHANNEL:{
 			chanspec_t chspec = CH20MHZ_CHSPEC(val);
 
@@ -2909,273 +2659,6 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			break;
 		}
 
-#if defined(BCMDBG)
-	case WLC_GET_UCFLAGS:
-		if (!wlc->pub->up) {
-			bcmerror = -ENOLINK;
-			break;
-		}
-
-		/* optional band is stored in the second integer of incoming buffer */
-		band =
-		    (len <
-		     (int)(2 * sizeof(int))) ? WLC_BAND_AUTO : ((int *)arg)[1];
-
-		/* bcmerror checking */
-		bcmerror = wlc_iocregchk(wlc, band);
-		if (bcmerror)
-			break;
-
-		if (val >= MHFMAX) {
-			bcmerror = -EINVAL;
-			break;
-		}
-
-		*pval = wlc_bmac_mhf_get(wlc->hw, (u8) val, WLC_BAND_AUTO);
-		break;
-
-	case WLC_SET_UCFLAGS:
-		if (!wlc->pub->up) {
-			bcmerror = -ENOLINK;
-			break;
-		}
-
-		/* optional band is stored in the second integer of incoming buffer */
-		band =
-		    (len <
-		     (int)(2 * sizeof(int))) ? WLC_BAND_AUTO : ((int *)arg)[1];
-
-		/* bcmerror checking */
-		bcmerror = wlc_iocregchk(wlc, band);
-		if (bcmerror)
-			break;
-
-		i = (u16) val;
-		if (i >= MHFMAX) {
-			bcmerror = -EINVAL;
-			break;
-		}
-
-		wlc_mhf(wlc, (u8) i, 0xffff, (u16) (val >> NBITS(u16)),
-			WLC_BAND_AUTO);
-		break;
-
-	case WLC_GET_SHMEM:
-		ta_ok = true;
-
-		/* optional band is stored in the second integer of incoming buffer */
-		band =
-		    (len <
-		     (int)(2 * sizeof(int))) ? WLC_BAND_AUTO : ((int *)arg)[1];
-
-		/* bcmerror checking */
-		bcmerror = wlc_iocregchk(wlc, band);
-		if (bcmerror)
-			break;
-
-		if (val & 1) {
-			bcmerror = -EINVAL;
-			break;
-		}
-
-		*pval = wlc_read_shm(wlc, (u16) val);
-		break;
-
-	case WLC_SET_SHMEM:
-		ta_ok = true;
-
-		/* optional band is stored in the second integer of incoming buffer */
-		band =
-		    (len <
-		     (int)(2 * sizeof(int))) ? WLC_BAND_AUTO : ((int *)arg)[1];
-
-		/* bcmerror checking */
-		bcmerror = wlc_iocregchk(wlc, band);
-		if (bcmerror)
-			break;
-
-		if (val & 1) {
-			bcmerror = -EINVAL;
-			break;
-		}
-
-		wlc_write_shm(wlc, (u16) val,
-			      (u16) (val >> NBITS(u16)));
-		break;
-
-	case WLC_R_REG:	/* MAC registers */
-		ta_ok = true;
-		r = (rw_reg_t *) arg;
-		band = WLC_BAND_AUTO;
-
-		if (len < (int)(sizeof(rw_reg_t) - sizeof(uint))) {
-			bcmerror = -EOVERFLOW;
-			break;
-		}
-
-		if (len >= (int)sizeof(rw_reg_t))
-			band = r->band;
-
-		/* bcmerror checking */
-		bcmerror = wlc_iocregchk(wlc, band);
-		if (bcmerror)
-			break;
-
-		if ((r->byteoff + r->size) > sizeof(d11regs_t)) {
-			bcmerror = -EINVAL;
-			break;
-		}
-		if (r->size == sizeof(u32))
-			r->val =
-			    R_REG((u32 *)((unsigned char *)(unsigned long)regs +
-					      r->byteoff));
-		else if (r->size == sizeof(u16))
-			r->val =
-			    R_REG((u16 *)((unsigned char *)(unsigned long)regs +
-					      r->byteoff));
-		else
-			bcmerror = -EINVAL;
-		break;
-
-	case WLC_W_REG:
-		ta_ok = true;
-		r = (rw_reg_t *) arg;
-		band = WLC_BAND_AUTO;
-
-		if (len < (int)(sizeof(rw_reg_t) - sizeof(uint))) {
-			bcmerror = -EOVERFLOW;
-			break;
-		}
-
-		if (len >= (int)sizeof(rw_reg_t))
-			band = r->band;
-
-		/* bcmerror checking */
-		bcmerror = wlc_iocregchk(wlc, band);
-		if (bcmerror)
-			break;
-
-		if (r->byteoff + r->size > sizeof(d11regs_t)) {
-			bcmerror = -EINVAL;
-			break;
-		}
-		if (r->size == sizeof(u32))
-			W_REG((u32 *)((unsigned char *)(unsigned long) regs +
-					  r->byteoff), r->val);
-		else if (r->size == sizeof(u16))
-			W_REG((u16 *)((unsigned char *)(unsigned long) regs +
-					  r->byteoff), r->val);
-		else
-			bcmerror = -EINVAL;
-		break;
-#endif				/* BCMDBG */
-
-	case WLC_GET_TXANT:
-		*pval = wlc->stf->txant;
-		break;
-
-	case WLC_SET_TXANT:
-		bcmerror = wlc_stf_ant_txant_validate(wlc, (s8) val);
-		if (bcmerror < 0)
-			break;
-
-		wlc->stf->txant = (s8) val;
-
-		/* if down, we are done */
-		if (!wlc->pub->up)
-			break;
-
-		wlc_suspend_mac_and_wait(wlc);
-
-		wlc_stf_phy_txant_upd(wlc);
-		wlc_beacon_phytxctl_txant_upd(wlc, wlc->bcn_rspec);
-
-		wlc_enable_mac(wlc);
-
-		break;
-
-	case WLC_GET_ANTDIV:{
-			u8 phy_antdiv;
-
-			/* return configured value if core is down */
-			if (!wlc->pub->up) {
-				*pval = wlc->stf->ant_rx_ovr;
-
-			} else {
-				if (wlc_phy_ant_rxdiv_get
-				    (wlc->band->pi, &phy_antdiv))
-					*pval = (int)phy_antdiv;
-				else
-					*pval = (int)wlc->stf->ant_rx_ovr;
-			}
-
-			break;
-		}
-	case WLC_SET_ANTDIV:
-		/* values are -1=driver default, 0=force0, 1=force1, 2=start1, 3=start0 */
-		if ((val < -1) || (val > 3)) {
-			bcmerror = -EINVAL;
-			break;
-		}
-
-		if (val == -1)
-			val = ANT_RX_DIV_DEF;
-
-		wlc->stf->ant_rx_ovr = (u8) val;
-		wlc_phy_ant_rxdiv_set(wlc->band->pi, (u8) val);
-		break;
-
-	case WLC_GET_RX_ANT:{	/* get latest used rx antenna */
-			u16 rxstatus;
-
-			if (!wlc->pub->up) {
-				bcmerror = -ENOLINK;
-				break;
-			}
-
-			rxstatus = R_REG(&wlc->regs->phyrxstatus0);
-			if (rxstatus == 0xdead || rxstatus == (u16) -1) {
-				bcmerror = -EBADE;
-				break;
-			}
-			*pval = (rxstatus & PRXS0_RXANT_UPSUBBAND) ? 1 : 0;
-			break;
-		}
-
-#if defined(BCMDBG)
-	case WLC_GET_UCANTDIV:
-		if (!wlc->clk) {
-			bcmerror = -EIO;
-			break;
-		}
-
-		*pval =
-		    (wlc_bmac_mhf_get(wlc->hw, MHF1, WLC_BAND_AUTO) &
-		     MHF1_ANTDIV);
-		break;
-
-	case WLC_SET_UCANTDIV:{
-			if (!wlc->pub->up) {
-				bcmerror = -ENOLINK;
-				break;
-			}
-
-			/* if multiband, band must be locked */
-			if (IS_MBAND_UNLOCKED(wlc)) {
-				bcmerror = -ENOMEDIUM;
-				break;
-			}
-
-			wlc_mhf(wlc, MHF1, MHF1_ANTDIV,
-				(val ? MHF1_ANTDIV : 0), WLC_BAND_AUTO);
-			break;
-		}
-#endif				/* defined(BCMDBG) */
-
-	case WLC_GET_SRL:
-		*pval = wlc->SRL;
-		break;
-
 	case WLC_SET_SRL:
 		if (val >= 1 && val <= RETRY_SHORT_MAX) {
 			int ac;
@@ -3191,10 +2674,6 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			bcmerror = -EINVAL;
 		break;
 
-	case WLC_GET_LRL:
-		*pval = wlc->LRL;
-		break;
-
 	case WLC_SET_LRL:
 		if (val >= 1 && val <= 255) {
 			int ac;
@@ -3210,159 +2689,6 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			bcmerror = -EINVAL;
 		break;
 
-	case WLC_GET_CWMIN:
-		*pval = wlc->band->CWmin;
-		break;
-
-	case WLC_SET_CWMIN:
-		if (!wlc->clk) {
-			bcmerror = -EIO;
-			break;
-		}
-
-		if (val >= 1 && val <= 255) {
-			wlc_set_cwmin(wlc, (u16) val);
-		} else
-			bcmerror = -EINVAL;
-		break;
-
-	case WLC_GET_CWMAX:
-		*pval = wlc->band->CWmax;
-		break;
-
-	case WLC_SET_CWMAX:
-		if (!wlc->clk) {
-			bcmerror = -EIO;
-			break;
-		}
-
-		if (val >= 255 && val <= 2047) {
-			wlc_set_cwmax(wlc, (u16) val);
-		} else
-			bcmerror = -EINVAL;
-		break;
-
-	case WLC_GET_RADIO:	/* use mask if don't want to expose some internal bits */
-		*pval = wlc->pub->radio_disabled;
-		break;
-
-	case WLC_SET_RADIO:{	/* 32 bits input, higher 16 bits are mask, lower 16 bits are value to
-				 * set
-				 */
-			u16 radiomask, radioval;
-			uint validbits =
-			    WL_RADIO_SW_DISABLE | WL_RADIO_HW_DISABLE;
-			mbool new = 0;
-
-			radiomask = (val & 0xffff0000) >> 16;
-			radioval = val & 0x0000ffff;
-
-			if ((radiomask == 0) || (radiomask & ~validbits)
-			    || (radioval & ~validbits)
-			    || ((radioval & ~radiomask) != 0)) {
-				wiphy_err(wlc->wiphy, "SET_RADIO with wrong "
-					  "bits 0x%x\n", val);
-				bcmerror = -EINVAL;
-				break;
-			}
-
-			new =
-			    (wlc->pub->radio_disabled & ~radiomask) | radioval;
-			wlc->pub->radio_disabled = new;
-
-			wlc_radio_hwdisable_upd(wlc);
-			wlc_radio_upd(wlc);
-			break;
-		}
-
-	case WLC_GET_PHYTYPE:
-		*pval = WLC_PHYTYPE(wlc->band->phytype);
-		break;
-
-#if defined(BCMDBG)
-	case WLC_GET_KEY:
-		if ((val >= 0) && (val < WLC_MAX_WSEC_KEYS(wlc))) {
-			wl_wsec_key_t key;
-
-			wsec_key_t *src_key = wlc->wsec_keys[val];
-
-			if (len < (int)sizeof(key)) {
-				bcmerror = -EOVERFLOW;
-				break;
-			}
-
-			memset((char *)&key, 0, sizeof(key));
-			if (src_key) {
-				key.index = src_key->id;
-				key.len = src_key->len;
-				memcpy(key.data, src_key->data, key.len);
-				key.algo = src_key->algo;
-				if (WSEC_SOFTKEY(wlc, src_key, bsscfg))
-					key.flags |= WL_SOFT_KEY;
-				if (src_key->flags & WSEC_PRIMARY_KEY)
-					key.flags |= WL_PRIMARY_KEY;
-
-				memcpy(key.ea, src_key->ea, ETH_ALEN);
-			}
-
-			memcpy(arg, &key, sizeof(key));
-		} else
-			bcmerror = -EINVAL;
-		break;
-#endif				/* defined(BCMDBG) */
-
-	case WLC_SET_KEY:
-		bcmerror =
-		    wlc_iovar_op(wlc, "wsec_key", NULL, 0, arg, len, IOV_SET,
-				 wlcif);
-		break;
-
-	case WLC_GET_KEY_SEQ:{
-			wsec_key_t *key;
-
-			if (len < DOT11_WPA_KEY_RSC_LEN) {
-				bcmerror = -EOVERFLOW;
-				break;
-			}
-
-			/* Return the key's tx iv as an EAPOL sequence counter.
-			 * This will be used to supply the RSC value to a supplicant.
-			 * The format is 8 bytes, with least significant in seq[0].
-			 */
-
-			key = WSEC_KEY(wlc, val);
-			if ((val >= 0) && (val < WLC_MAX_WSEC_KEYS(wlc)) &&
-				(key != NULL)) {
-				u8 seq[DOT11_WPA_KEY_RSC_LEN];
-				u16 lo;
-				u32 hi;
-				/* group keys in WPA-NONE (IBSS only, AES and TKIP) use a global TXIV */
-				if ((bsscfg->WPA_auth & WPA_AUTH_NONE) &&
-				    is_zero_ether_addr(key->ea)) {
-					lo = bsscfg->wpa_none_txiv.lo;
-					hi = bsscfg->wpa_none_txiv.hi;
-				} else {
-					lo = key->txiv.lo;
-					hi = key->txiv.hi;
-				}
-
-				/* format the buffer, low to high */
-				seq[0] = lo & 0xff;
-				seq[1] = (lo >> 8) & 0xff;
-				seq[2] = hi & 0xff;
-				seq[3] = (hi >> 8) & 0xff;
-				seq[4] = (hi >> 16) & 0xff;
-				seq[5] = (hi >> 24) & 0xff;
-				seq[6] = 0;
-				seq[7] = 0;
-
-				memcpy(arg, seq, sizeof(seq));
-			} else {
-				bcmerror = -EINVAL;
-			}
-			break;
-		}
-
 	case WLC_GET_CURR_RATESET:{
 			wl_rateset_t *ret_rs = (wl_rateset_t *) arg;
 			wlc_rateset_t *rs;
@@ -3383,24 +2709,6 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			break;
 		}
 
-	case WLC_GET_RATESET:{
-			wlc_rateset_t rs;
-			wl_rateset_t *ret_rs = (wl_rateset_t *) arg;
-
-			memset(&rs, 0, sizeof(wlc_rateset_t));
-			wlc_default_rateset(wlc, (wlc_rateset_t *) &rs);
-
-			if (len < (int)(rs.count + sizeof(rs.count))) {
-				bcmerror = -EOVERFLOW;
-				break;
-			}
-
-			/* Copy only legacy rateset section */
-			ret_rs->count = rs.count;
-			memcpy(&ret_rs->rates, &rs.rates, rs.count);
-			break;
-		}
-
 	case WLC_SET_RATESET:{
 			wlc_rateset_t rs;
 			wl_rateset_t *in_rs = (wl_rateset_t *) arg;
@@ -3441,13 +2749,6 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			break;
 		}
 
-	case WLC_GET_BCNPRD:
-		if (BSSCFG_STA(bsscfg) && bsscfg->BSS && bsscfg->associated)
-			*pval = current_bss->beacon_period;
-		else
-			*pval = wlc->default_bss->beacon_period;
-		break;
-
 	case WLC_SET_BCNPRD:
 		/* range [1, 0xffff] */
 		if (val >= DOT11_MIN_BEACON_PERIOD
@@ -3457,124 +2758,6 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			bcmerror = -EINVAL;
 		break;
 
-	case WLC_GET_DTIMPRD:
-		if (BSSCFG_STA(bsscfg) && bsscfg->BSS && bsscfg->associated)
-			*pval = current_bss->dtim_period;
-		else
-			*pval = wlc->default_bss->dtim_period;
-		break;
-
-	case WLC_SET_DTIMPRD:
-		/* range [1, 0xff] */
-		if (val >= DOT11_MIN_DTIM_PERIOD
-		    && val <= DOT11_MAX_DTIM_PERIOD) {
-			wlc->default_bss->dtim_period = (u8) val;
-		} else
-			bcmerror = -EINVAL;
-		break;
-
-#ifdef SUPPORT_PS
-	case WLC_GET_PM:
-		*pval = wlc->PM;
-		break;
-
-	case WLC_SET_PM:
-		if ((val >= PM_OFF) && (val <= PM_MAX)) {
-			wlc->PM = (u8) val;
-			if (wlc->pub->up) {
-			}
-			/* Change watchdog driver to align watchdog with tbtt if possible */
-			wlc_watchdog_upd(wlc, PS_ALLOWED(wlc));
-		} else
-			bcmerror = -EBADE;
-		break;
-#endif				/* SUPPORT_PS */
-
-#ifdef SUPPORT_PS
-#ifdef BCMDBG
-	case WLC_GET_WAKE:
-		if (AP_ENAB(wlc->pub)) {
-			bcmerror = -BCME_NOTSTA;
-			break;
-		}
-		*pval = wlc->wake;
-		break;
-
-	case WLC_SET_WAKE:
-		if (AP_ENAB(wlc->pub)) {
-			bcmerror = -BCME_NOTSTA;
-			break;
-		}
-
-		wlc->wake = val ? true : false;
-
-		/* if down, we're done */
-		if (!wlc->pub->up)
-			break;
-
-		/* apply to the mac */
-		wlc_set_ps_ctrl(wlc);
-		break;
-#endif				/* BCMDBG */
-#endif				/* SUPPORT_PS */
-
-	case WLC_GET_REVINFO:
-		bcmerror = wlc_get_revision_info(wlc, arg, (uint) len);
-		break;
-
-	case WLC_GET_AP:
-		*pval = (int)AP_ENAB(wlc->pub);
-		break;
-
-	case WLC_GET_ATIM:
-		if (bsscfg->associated)
-			*pval = (int)current_bss->atim_window;
-		else
-			*pval = (int)wlc->default_bss->atim_window;
-		break;
-
-	case WLC_SET_ATIM:
-		wlc->default_bss->atim_window = (u32) val;
-		break;
-
-#ifdef SUPPORT_HWKEY
-	case WLC_GET_WSEC:
-		bcmerror =
-		    wlc_iovar_op(wlc, "wsec", NULL, 0, arg, len, IOV_GET,
-				 wlcif);
-		break;
-
-	case WLC_SET_WSEC:
-		bcmerror =
-		    wlc_iovar_op(wlc, "wsec", NULL, 0, arg, len, IOV_SET,
-				 wlcif);
-		break;
-
-	case WLC_GET_WPA_AUTH:
-		*pval = (int)bsscfg->WPA_auth;
-		break;
-
-	case WLC_SET_WPA_AUTH:
-		/* change of WPA_Auth modifies the PS_ALLOWED state */
-		if (BSSCFG_STA(bsscfg)) {
-			bsscfg->WPA_auth = (u16) val;
-		} else
-			bsscfg->WPA_auth = (u16) val;
-		break;
-#endif				/* SUPPORT_HWKEY */
-
-	case WLC_GET_BANDLIST:
-		/* count of number of bands, followed by each band type */
-		*pval++ = NBANDS(wlc);
-		*pval++ = wlc->band->bandtype;
-		if (NBANDS(wlc) > 1)
-			*pval++ = wlc->bandstate[OTHERBANDUNIT(wlc)]->bandtype;
-		break;
-
-	case WLC_GET_BAND:
-		*pval = wlc->bandlocked ? wlc->band->bandtype : WLC_BAND_AUTO;
-		break;
-
 	case WLC_GET_PHYLIST:
 		{
 			unsigned char *cp = arg;
@@ -3594,14 +2777,6 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			break;
 		}
 
-	case WLC_GET_SHORTSLOT:
-		*pval = wlc->shortslot;
-		break;
-
-	case WLC_GET_SHORTSLOT_OVERRIDE:
-		*pval = wlc->shortslot_override;
-		break;
-
 	case WLC_SET_SHORTSLOT_OVERRIDE:
 		if ((val != WLC_SHORTSLOT_AUTO) &&
 		    (val != WLC_SHORTSLOT_OFF) && (val != WLC_SHORTSLOT_ON)) {
@@ -3635,256 +2810,6 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 
 		break;
 
-	case WLC_GET_LEGACY_ERP:
-		*pval = wlc->include_legacy_erp;
-		break;
-
-	case WLC_SET_LEGACY_ERP:
-		if (wlc->include_legacy_erp == bool_val)
-			break;
-
-		wlc->include_legacy_erp = bool_val;
-
-		if (AP_ENAB(wlc->pub) && wlc->clk) {
-			wlc_update_beacon(wlc);
-			wlc_update_probe_resp(wlc, true);
-		}
-		break;
-
-	case WLC_GET_GMODE:
-		if (wlc->band->bandtype == WLC_BAND_2G)
-			*pval = wlc->band->gmode;
-		else if (NBANDS(wlc) > 1)
-			*pval = wlc->bandstate[OTHERBANDUNIT(wlc)]->gmode;
-		break;
-
-	case WLC_SET_GMODE:
-		if (!wlc->pub->associated)
-			bcmerror = wlc_set_gmode(wlc, (u8) val, true);
-		else {
-			bcmerror = -EISCONN;
-			break;
-		}
-		break;
-
-	case WLC_GET_GMODE_PROTECTION:
-		*pval = wlc->protection->_g;
-		break;
-
-	case WLC_GET_PROTECTION_CONTROL:
-		*pval = wlc->protection->overlap;
-		break;
-
-	case WLC_SET_PROTECTION_CONTROL:
-		if ((val != WLC_PROTECTION_CTL_OFF) &&
-		    (val != WLC_PROTECTION_CTL_LOCAL) &&
-		    (val != WLC_PROTECTION_CTL_OVERLAP)) {
-			bcmerror = -EINVAL;
-			break;
-		}
-
-		wlc_protection_upd(wlc, WLC_PROT_OVERLAP, (s8) val);
-
-		/* Current g_protection will sync up to the specified control alg in watchdog
-		 * if the driver is up and associated.
-		 * If the driver is down or not associated, the control setting has no effect.
-		 */
-		break;
-
-	case WLC_GET_GMODE_PROTECTION_OVERRIDE:
-		*pval = wlc->protection->g_override;
-		break;
-
-	case WLC_SET_GMODE_PROTECTION_OVERRIDE:
-		if ((val != WLC_PROTECTION_AUTO) &&
-		    (val != WLC_PROTECTION_OFF) && (val != WLC_PROTECTION_ON)) {
-			bcmerror = -EINVAL;
-			break;
-		}
-
-		wlc_protection_upd(wlc, WLC_PROT_G_OVR, (s8) val);
-
-		break;
-
-	case WLC_SET_SUP_RATESET_OVERRIDE:{
-			wlc_rateset_t rs, new;
-
-			/* copyin */
-			if (len < (int)sizeof(wlc_rateset_t)) {
-				bcmerror = -EOVERFLOW;
-				break;
-			}
-			memcpy(&rs, arg, sizeof(wlc_rateset_t));
-
-			/* check for bad count value */
-			if (rs.count > WLC_NUMRATES) {
-				bcmerror = -EINVAL;
-				break;
-			}
-
-			/* this command is only appropriate for gmode operation */
-			if (!(wlc->band->gmode ||
-			      ((NBANDS(wlc) > 1)
-			       && wlc->bandstate[OTHERBANDUNIT(wlc)]->gmode))) {
-				/* gmode only command when not in gmode */
-				bcmerror = -EINVAL;
-				break;
-			}
-
-			/* check for an empty rateset to clear the override */
-			if (rs.count == 0) {
-				memset(&wlc->sup_rates_override, 0,
-				      sizeof(wlc_rateset_t));
-				break;
-			}
-
-			/*
-			 * validate rateset by comparing pre and
-			 * post sorted against 11g hw rates
-			 */
-			wlc_rateset_filter(&rs, &new, false,
-					   WLC_RATES_CCK_OFDM, WLC_RATE_MASK,
-					   BSS_N_ENAB(wlc, bsscfg));
-			wlc_rate_hwrs_filter_sort_validate(&new,
-							   &cck_ofdm_rates,
-							   false,
-							   wlc->stf->txstreams);
-			if (rs.count != new.count) {
-				bcmerror = -EINVAL;
-				break;
-			}
-
-			/* apply new rateset to the override */
-			memcpy(&wlc->sup_rates_override, &new,
-			      sizeof(wlc_rateset_t));
-
-			/* update bcn and probe resp if needed */
-			if (wlc->pub->up && AP_ENAB(wlc->pub)
-			    && wlc->pub->associated) {
-				wlc_update_beacon(wlc);
-				wlc_update_probe_resp(wlc, true);
-			}
-			break;
-		}
-
-	case WLC_GET_SUP_RATESET_OVERRIDE:
-		/* this command is only appropriate for gmode operation */
-		if (!(wlc->band->gmode ||
-		      ((NBANDS(wlc) > 1)
-		       && wlc->bandstate[OTHERBANDUNIT(wlc)]->gmode))) {
-			/* gmode only command when not in gmode */
-			bcmerror = -EINVAL;
-			break;
-		}
-		if (len < (int)sizeof(wlc_rateset_t)) {
-			bcmerror = -EOVERFLOW;
-			break;
-		}
-		memcpy(arg, &wlc->sup_rates_override, sizeof(wlc_rateset_t));
-
-		break;
-
-	case WLC_GET_PRB_RESP_TIMEOUT:
-		*pval = wlc->prb_resp_timeout;
-		break;
-
-	case WLC_SET_PRB_RESP_TIMEOUT:
-		if (wlc->pub->up) {
-			bcmerror = -EISCONN;
-			break;
-		}
-		if (val < 0 || val >= 0xFFFF) {
-			bcmerror = -EINVAL;	/* bad value */
-			break;
-		}
-		wlc->prb_resp_timeout = (u16) val;
-		break;
-
-	case WLC_GET_KEY_PRIMARY:{
-			wsec_key_t *key;
-
-			/* treat the 'val' parm as the key id */
-			key = WSEC_BSS_DEFAULT_KEY(bsscfg);
-			if (key != NULL) {
-				*pval = key->id == val ? true : false;
-			} else {
-				bcmerror = -EINVAL;
-			}
-			break;
-		}
-
-	case WLC_SET_KEY_PRIMARY:{
-			wsec_key_t *key, *old_key;
-
-			bcmerror = -EINVAL;
-
-			/* treat the 'val' parm as the key id */
-			for (i = 0; i < WSEC_MAX_DEFAULT_KEYS; i++) {
-				key = bsscfg->bss_def_keys[i];
-				if (key != NULL && key->id == val) {
-					old_key = WSEC_BSS_DEFAULT_KEY(bsscfg);
-					if (old_key != NULL)
-						old_key->flags &=
-						    ~WSEC_PRIMARY_KEY;
-					key->flags |= WSEC_PRIMARY_KEY;
-					bsscfg->wsec_index = i;
-					bcmerror = 0;
-				}
-			}
-			break;
-		}
-
-#ifdef BCMDBG
-	case WLC_INIT:
-		wl_init(wlc->wl);
-		break;
-#endif
-
-	case WLC_SET_VAR:
-	case WLC_GET_VAR:{
-			char *name;
-			/* validate the name value */
-			name = (char *)arg;
-			for (i = 0; i < (uint) len && *name != '\0';
-			     i++, name++)
-				;
-
-			if (i == (uint) len) {
-				bcmerror = -EOVERFLOW;
-				break;
-			}
-			i++;	/* include the null in the string length */
-
-			if (cmd == WLC_GET_VAR) {
-				bcmerror =
-				    wlc_iovar_op(wlc, arg,
-						 (void *)((s8 *) arg + i),
-						 len - i, arg, len, IOV_GET,
-						 wlcif);
-			} else
-				bcmerror =
-				    wlc_iovar_op(wlc, arg, NULL, 0,
-						 (void *)((s8 *) arg + i),
-						 len - i, IOV_SET, wlcif);
-
-			break;
-		}
-
-	case WLC_SET_WSEC_PMK:
-		bcmerror = -ENOTSUPP;
-		break;
-
-#if defined(BCMDBG)
-	case WLC_CURRENT_PWR:
-		if (!wlc->pub->up)
-			bcmerror = -ENOLINK;
-		else
-			bcmerror = wlc_get_current_txpwr(wlc, arg, len);
-		break;
-#endif
-
-	case WLC_LAST:
-		wiphy_err(wlc->wiphy, "%s: WLC_LAST\n", __func__);
 	}
  done:
 
@@ -3894,26 +2819,6 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 	return bcmerror;
 }
 
-#if defined(BCMDBG)
-/* consolidated register access ioctl error checking */
-int wlc_iocregchk(struct wlc_info *wlc, uint band)
-{
-	/* if band is specified, it must be the current band */
-	if ((band != WLC_BAND_AUTO) && (band != (uint) wlc->band->bandtype))
-		return -EINVAL;
-
-	/* if multiband and band is not specified, band must be locked */
-	if ((band == WLC_BAND_AUTO) && IS_MBAND_UNLOCKED(wlc))
-		return -ENOMEDIUM;
-
-	/* must have core clocks */
-	if (!wlc->clk)
-		return -EIO;
-
-	return 0;
-}
-#endif				/* defined(BCMDBG) */
-
 /* Look up the given var name in the given table */
 static const bcm_iovar_t *wlc_iovar_lookup(const bcm_iovar_t *table,
 					   const char *name)
@@ -3937,14 +2842,12 @@ static const bcm_iovar_t *wlc_iovar_lookup(const bcm_iovar_t *table,
 	return NULL;		/* var name not found */
 }
 
-/* simplified integer get interface for common WLC_GET_VAR ioctl handler */
 int wlc_iovar_getint(struct wlc_info *wlc, const char *name, int *arg)
 {
 	return wlc_iovar_op(wlc, name, NULL, 0, arg, sizeof(s32), IOV_GET,
 			    NULL);
 }
 
-/* simplified integer set interface for common WLC_SET_VAR ioctl handler */
 int wlc_iovar_setint(struct wlc_info *wlc, const char *name, int arg)
 {
 	return wlc_iovar_op(wlc, name, NULL, 0, (void *)&arg, sizeof(arg),
@@ -4554,32 +3457,6 @@ void wlc_print_rxh(d11rxhdr_t *rxh)
 }
 #endif				/* defined(BCMDBG) */
 
-#if defined(BCMDBG)
-int wlc_format_ssid(char *buf, const unsigned char ssid[], uint ssid_len)
-{
-	uint i, c;
-	char *p = buf;
-	char *endp = buf + SSID_FMT_BUF_LEN;
-
-	if (ssid_len > IEEE80211_MAX_SSID_LEN)
-		ssid_len = IEEE80211_MAX_SSID_LEN;
-
-	for (i = 0; i < ssid_len; i++) {
-		c = (uint) ssid[i];
-		if (c == '\\') {
-			*p++ = '\\';
-			*p++ = '\\';
-		} else if (isprint((unsigned char) c)) {
-			*p++ = (char)c;
-		} else {
-			p += snprintf(p, (endp - p), "\\x%02X", c);
-		}
-	}
-	*p = '\0';
-	return (int)(p - buf);
-}
-#endif				/* defined(BCMDBG) */
-
 static u16 wlc_rate_shm_offset(struct wlc_info *wlc, u8 rate)
 {
 	return wlc_bmac_rate_shm_offset(wlc->hw, rate);
@@ -6985,43 +5862,6 @@ void wlc_bsscfg_reprate_init(struct wlc_bsscfg *bsscfg)
 	memset((char *)bsscfg->txrspec, 0, sizeof(bsscfg->txrspec));
 }
 
-/* Retrieve a consolidated set of revision information,
- * typically for the WLC_GET_REVINFO ioctl
- */
-int wlc_get_revision_info(struct wlc_info *wlc, void *buf, uint len)
-{
-	wlc_rev_info_t *rinfo = (wlc_rev_info_t *) buf;
-
-	if (len < WL_REV_INFO_LEGACY_LENGTH)
-		return -EOVERFLOW;
-
-	rinfo->vendorid = wlc->vendorid;
-	rinfo->deviceid = wlc->deviceid;
-	rinfo->radiorev = (wlc->band->radiorev << IDCODE_REV_SHIFT) |
-	    (wlc->band->radioid << IDCODE_ID_SHIFT);
-	rinfo->chiprev = wlc->pub->sih->chiprev;
-	rinfo->corerev = wlc->pub->corerev;
-	rinfo->boardid = wlc->pub->sih->boardtype;
-	rinfo->boardvendor = wlc->pub->sih->boardvendor;
-	rinfo->boardrev = wlc->pub->boardrev;
-	rinfo->ucoderev = wlc->ucode_rev;
-	rinfo->driverrev = EPI_VERSION_NUM;
-	rinfo->bus = wlc->pub->sih->bustype;
-	rinfo->chipnum = wlc->pub->sih->chip;
-
-	if (len >= (offsetof(wlc_rev_info_t, chippkg))) {
-		rinfo->phytype = wlc->band->phytype;
-		rinfo->phyrev = wlc->band->phyrev;
-		rinfo->anarev = 0;	/* obsolete stuff, suppress */
-	}
-
-	if (len >= sizeof(*rinfo)) {
-		rinfo->chippkg = wlc->pub->sih->chippkg;
-	}
-
-	return 0;
-}
-
 void wlc_default_rateset(struct wlc_info *wlc, wlc_rateset_t *rs)
 {
 	wlc_rateset_default(rs, NULL, wlc->band->phytype, wlc->band->bandtype,
@@ -7273,20 +6113,6 @@ wlc_set_addrmatch(struct wlc_info *wlc, int match_reg_offset,
 		memcpy(wlc->cfg->BSSID, addr, ETH_ALEN);
 }
 
-void wlc_set_cwmin(struct wlc_info *wlc, u16 newmin)
-{
-	wlc->band->CWmin = newmin;
-	wlc_bmac_set_cwmin(wlc->hw, newmin);
-}
-
-void wlc_set_cwmax(struct wlc_info *wlc, u16 newmax)
-{
-	wlc->band->CWmax = newmax;
-	wlc_bmac_set_cwmax(wlc->hw, newmax);
-}
-
-/* Search mem rw utilities */
-
 void wlc_pllreq(struct wlc_info *wlc, bool set, mbool req_bit)
 {
 	wlc_bmac_pllreq(wlc->hw, set, req_bit);
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.h b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
index fb48dfc..0bb3784 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
@@ -805,8 +805,6 @@ extern void wlc_write_template_ram(struct wlc_info *wlc, int offset, int len,
 				   void *buf);
 extern void wlc_write_hw_bcntemplates(struct wlc_info *wlc, void *bcn, int len,
 				      bool both);
-extern void wlc_set_cwmin(struct wlc_info *wlc, u16 newmin);
-extern void wlc_set_cwmax(struct wlc_info *wlc, u16 newmax);
 extern void wlc_pllreq(struct wlc_info *wlc, bool set, mbool req_bit);
 extern void wlc_reset_bmac_done(struct wlc_info *wlc);
 
@@ -928,10 +926,7 @@ extern ratespec_t wlc_lowest_basic_rspec(struct wlc_info *wlc,
 					 wlc_rateset_t *rs);
 extern void wlc_radio_disable(struct wlc_info *wlc);
 extern void wlc_bcn_li_upd(struct wlc_info *wlc);
-
-extern int wlc_get_revision_info(struct wlc_info *wlc, void *buf, uint len);
 extern void wlc_set_home_chanspec(struct wlc_info *wlc, chanspec_t chanspec);
-extern void wlc_watchdog_upd(struct wlc_info *wlc, bool tbtt);
 extern bool wlc_ps_allowed(struct wlc_info *wlc);
 extern bool wlc_stay_awake(struct wlc_info *wlc);
 extern void wlc_wme_initparams_sta(struct wlc_info *wlc, wme_param_ie_t *pe);
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h b/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
index 9334dea..88b0967 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
@@ -134,7 +134,6 @@ struct rsn_parms {
 };
 
 /*
- * buffer length needed for wlc_format_ssid
  * 32 SSID chars, max of 4 chars for each SSID char "\xFF", plus NULL.
  */
 #define SSID_FMT_BUF_LEN	((4 * IEEE80211_MAX_SSID_LEN) + 1)
@@ -558,18 +557,10 @@ extern void wlc_scan_stop(struct wlc_info *wlc);
 extern int wlc_get_curband(struct wlc_info *wlc);
 extern void wlc_wait_for_tx_completion(struct wlc_info *wlc, bool drop);
 
-#if defined(BCMDBG)
-extern int wlc_iocregchk(struct wlc_info *wlc, uint band);
-#endif
-
 /* helper functions */
 extern bool wlc_check_radio_disabled(struct wlc_info *wlc);
 extern bool wlc_radio_monitor_stop(struct wlc_info *wlc);
 
-#if defined(BCMDBG)
-extern int wlc_format_ssid(char *buf, const unsigned char ssid[], uint ssid_len);
-#endif
-
 #define	MAXBANDS		2	/* Maximum #of bands */
 /* bandstate array indices */
 #define BAND_2G_INDEX		0	/* wlc->bandstate[x] index */
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_stf.c b/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
index c4f5817..544d883 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
@@ -364,39 +364,6 @@ void wlc_stf_detach(struct wlc_info *wlc)
 {
 }
 
-int wlc_stf_ant_txant_validate(struct wlc_info *wlc, s8 val)
-{
-	int bcmerror = 0;
-
-	/* when there is only 1 tx_streams, don't allow to change the txant */
-	if (WLCISNPHY(wlc->band) && (wlc->stf->txstreams == 1))
-		return ((val == wlc->stf->txant) ? bcmerror : -EINVAL);
-
-	switch (val) {
-	case -1:
-		val = ANT_TX_DEF;
-		break;
-	case 0:
-		val = ANT_TX_FORCE_0;
-		break;
-	case 1:
-		val = ANT_TX_FORCE_1;
-		break;
-	case 3:
-		val = ANT_TX_LAST_RX;
-		break;
-	default:
-		bcmerror = -EINVAL;
-		break;
-	}
-
-	if (bcmerror == 0)
-		wlc->stf->txant = (s8) val;
-
-	return bcmerror;
-
-}
-
 /*
  * Centralized txant update function. call it whenever wlc->stf->txant and/or wlc->stf->txchain
  *  change
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_stf.h b/drivers/staging/brcm80211/brcmsmac/wlc_stf.h
index 2b1180b..eedd9da 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_stf.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_stf.h
@@ -28,8 +28,6 @@ extern int wlc_stf_ss_update(struct wlc_info *wlc, struct wlcband *band);
 extern void wlc_stf_phy_txant_upd(struct wlc_info *wlc);
 extern int wlc_stf_txchain_set(struct wlc_info *wlc, s32 int_val, bool force);
 extern bool wlc_stf_stbc_rx_set(struct wlc_info *wlc, s32 int_val);
-
-extern int wlc_stf_ant_txant_validate(struct wlc_info *wlc, s8 val);
 extern void wlc_stf_phy_txant_upd(struct wlc_info *wlc);
 extern void wlc_stf_phy_chain_calc(struct wlc_info *wlc);
 extern u16 wlc_stf_phytxchain_sel(struct wlc_info *wlc, ratespec_t rspec);
-- 
1.7.4.1


