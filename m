Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4203 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169Ab1GROaZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2011 10:30:25 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 01/19] staging: brcm80211: fix for checkpatch warnings
 in phy directory
Date: Mon, 18 Jul 2011 16:29:47 +0200
Message-ID: <1310999405-10062-2-git-send-email-arend@broadcom.com> (sfid-20110718_163040_840065_F8931335)
In-Reply-To: <1310999405-10062-1-git-send-email-arend@broadcom.com>
References: <1310999405-10062-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Most of them being 'line exceeds 80 chars'. Still checkpatch warnings
for the phy dir left, these will be resolved in the subsequent commits.

Cc: linux-wireless@vger.kernel.org
Cc: devel@linuxdriverproject.org
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c   |  237 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h   |   51 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h   |  138 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c   |  407 ++-
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c     | 3687 +++++++++++---------
 drivers/staging/brcm80211/brcmsmac/phy/phy_qmath.c |  136 +-
 .../staging/brcm80211/brcmsmac/phy/phytbl_lcn.c    | 1168 +++----
 drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.c  |    3 +-
 drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.h  |   24 +-
 9 files changed, 2897 insertions(+), 2954 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index 2636114..582df4a 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -119,7 +119,7 @@ const u8 ofdm_rate_lookup[] = {
 	BRCM_RATE_9M
 };
 
-#define PHY_WREG_LIMIT	24
+#define PHY_WREG_LIMIT  24
 
 static void wlc_set_phy_uninitted(struct brcms_phy *pi);
 static u32 wlc_phy_get_radio_ver(struct brcms_phy *pi);
@@ -142,7 +142,7 @@ static void wlc_phy_txpower_reg_limit_calc(struct brcms_phy *pi,
 static bool wlc_phy_cal_txpower_recalc_sw(struct brcms_phy *pi);
 
 static s8 wlc_user_txpwr_antport_to_rfport(struct brcms_phy *pi, uint chan,
-					     u32 band, u8 rate);
+					   u32 band, u8 rate);
 static void wlc_phy_upd_env_txpwr_rate_limits(struct brcms_phy *pi, u32 band);
 static s8 wlc_phy_env_measure_vbat(struct brcms_phy *pi);
 static s8 wlc_phy_env_measure_temperature(struct brcms_phy *pi);
@@ -581,11 +581,11 @@ wlc_phy_attach(struct shared_phy *sh, void *regs, int bandtype,
 
 	idcode = wlc_phy_get_radio_ver(pi);
 	pi->pubpi.radioid =
-	    (idcode & IDCODE_ID_MASK) >> IDCODE_ID_SHIFT;
+		(idcode & IDCODE_ID_MASK) >> IDCODE_ID_SHIFT;
 	pi->pubpi.radiorev =
-	    (idcode & IDCODE_REV_MASK) >> IDCODE_REV_SHIFT;
+		(idcode & IDCODE_REV_MASK) >> IDCODE_REV_SHIFT;
 	pi->pubpi.radiover =
-	    (idcode & IDCODE_VER_MASK) >> IDCODE_VER_SHIFT;
+		(idcode & IDCODE_VER_MASK) >> IDCODE_VER_SHIFT;
 	if (!VALID_RADIO(pi, pi->pubpi.radioid))
 		goto err;
 
@@ -595,7 +595,7 @@ wlc_phy_attach(struct shared_phy *sh, void *regs, int bandtype,
 
 	pi->bw = WL_CHANSPEC_BW_20;
 	pi->radio_chanspec =
-	    BAND_2G(bandtype) ? CH20MHZ_CHSPEC(1) : CH20MHZ_CHSPEC(36);
+		BAND_2G(bandtype) ? CH20MHZ_CHSPEC(1) : CH20MHZ_CHSPEC(36);
 
 	pi->rxiq_samps = PHY_NOISE_SAMPLE_LOG_NUM_NPHY;
 	pi->rxiq_antsel = ANT_RX_DIV_DEF;
@@ -617,7 +617,7 @@ wlc_phy_attach(struct shared_phy *sh, void *regs, int bandtype,
 
 	pi->phy_txcore_disable_temp = PHY_CHAIN_TX_DISABLE_TEMP;
 	pi->phy_txcore_enable_temp =
-	    PHY_CHAIN_TX_DISABLE_TEMP - PHY_HYSTERESIS_DELTATEMP;
+		PHY_CHAIN_TX_DISABLE_TEMP - PHY_HYSTERESIS_DELTATEMP;
 	pi->phy_tempsense_offset = 0;
 	pi->phy_txcore_heatedup = false;
 
@@ -640,8 +640,8 @@ wlc_phy_attach(struct shared_phy *sh, void *regs, int bandtype,
 	if (ISNPHY(pi)) {
 
 		pi->phycal_timer = wlapi_init_timer(pi->sh->physhim,
-							  wlc_phy_timercb_phycal,
-							  pi, "phycal");
+						    wlc_phy_timercb_phycal,
+						    pi, "phycal");
 		if (!pi->phycal_timer)
 			goto err;
 
@@ -664,7 +664,7 @@ wlc_phy_attach(struct shared_phy *sh, void *regs, int bandtype,
 
 	return &pi->pubpi_ro;
 
- err:
+err:
 	kfree(pi);
 	return NULL;
 }
@@ -688,7 +688,7 @@ void wlc_phy_detach(struct brcms_phy_pub *pih)
 			pi->sh->phy_head->next = NULL;
 
 		if (pi->pi_fptr.detach)
-			(pi->pi_fptr.detach) (pi);
+			(pi->pi_fptr.detach)(pi);
 
 		kfree(pi);
 	}
@@ -853,7 +853,7 @@ void wlc_phy_hw_state_upd(struct brcms_phy_pub *pih, bool newstate)
 void wlc_phy_init(struct brcms_phy_pub *pih, u16 chanspec)
 {
 	u32 mc;
-	void (*phy_init) (struct brcms_phy *) = NULL;
+	void (*phy_init)(struct brcms_phy *) = NULL;
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
 	if (pi->init_in_progress)
@@ -889,7 +889,7 @@ void wlc_phy_init(struct brcms_phy_pub *pih, u16 chanspec)
 
 	wlc_phy_switch_radio((struct brcms_phy_pub *) pi, ON);
 
-	(*phy_init) (pi);
+	(*phy_init)(pi);
 
 	pi->phy_init_por = false;
 
@@ -916,7 +916,7 @@ void wlc_phy_cal_init(struct brcms_phy_pub *pih)
 	if (!pi->initialized) {
 		cal_init = pi->pi_fptr.calinit;
 		if (cal_init)
-			(*cal_init) (pi);
+			(*cal_init)(pi);
 
 		pi->initialized = true;
 	}
@@ -1108,7 +1108,7 @@ wlc_phy_init_radio_regs(struct brcms_phy *pi, struct radio_regs *radioregs,
 
 void wlc_phy_do_dummy_tx(struct brcms_phy *pi, bool ofdm, bool pa_on)
 {
-#define	DUMMY_PKT_LEN	20
+#define DUMMY_PKT_LEN   20
 	struct d11regs *regs = pi->regs;
 	int i, count;
 	u8 ofdmpkt[DUMMY_PKT_LEN] = {
@@ -1300,7 +1300,7 @@ void wlc_phy_chanspec_set(struct brcms_phy_pub *ppi, u16 chanspec)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 	u16 m_cur_channel;
-	void (*chanspec_set) (struct brcms_phy *, u16) = NULL;
+	void (*chanspec_set)(struct brcms_phy *, u16) = NULL;
 	m_cur_channel = CHSPEC_CHANNEL(chanspec);
 	if (CHSPEC_IS5G(chanspec))
 		m_cur_channel |= D11_CURCHANNEL_5G;
@@ -1310,7 +1310,7 @@ void wlc_phy_chanspec_set(struct brcms_phy_pub *ppi, u16 chanspec)
 
 	chanspec_set = pi->pi_fptr.chanset;
 	if (chanspec_set)
-		(*chanspec_set) (pi, chanspec);
+		(*chanspec_set)(pi, chanspec);
 
 }
 
@@ -1409,9 +1409,8 @@ u16 wlc_phy_chanspec_band_firstch(struct brcms_phy_pub *ppi, uint band)
 				continue;
 
 			channel = UPPER_20_SB(channel);
-			chspec =
-			    channel | WL_CHANSPEC_BW_40 |
-			    WL_CHANSPEC_CTL_SB_LOWER;
+			chspec =  channel | WL_CHANSPEC_BW_40 |
+				  WL_CHANSPEC_CTL_SB_LOWER;
 			if (band == BRCM_BAND_2G)
 				chspec |= WL_CHANSPEC_BAND_2G;
 			else
@@ -1508,10 +1507,8 @@ int wlc_phy_txpower_set(struct brcms_phy_pub *ppi, uint qdbm, bool override)
 		if (!SCAN_INPROG_PHY(pi)) {
 			bool suspend;
 
-			suspend =
-			    (0 ==
-			     (R_REG(&pi->regs->maccontrol) &
-			      MCTL_EN_MAC));
+			suspend = (0 == (R_REG(&pi->regs->maccontrol) &
+					 MCTL_EN_MAC));
 
 			if (!suspend)
 				wlapi_suspend_mac_and_wait(pi->sh->physhim);
@@ -1588,7 +1585,8 @@ wlc_phy_txpower_sromlimit_max_get(struct brcms_phy_pub *ppi, uint chan,
 	pactrl = 0;
 
 	max_num_rate = ISNPHY(pi) ? TXP_NUM_RATES :
-	    ISLCNPHY(pi) ? (TXP_LAST_SISO_MCS_20 + 1) : (TXP_LAST_OFDM + 1);
+		       ISLCNPHY(pi) ? (TXP_LAST_SISO_MCS_20 +
+				       1) : (TXP_LAST_OFDM + 1);
 
 	for (rate = 0; rate < max_num_rate; rate++) {
 
@@ -1658,8 +1656,8 @@ void wlc_phy_txpower_recalc_target(struct brcms_phy *pi)
 			for (i = TXP_FIRST_SISO_MCS_20;
 			     i <= TXP_LAST_SISO_MCS_20; i++) {
 				pi->tx_srom_max_rate_2g[i - 8] =
-				    pi->tx_srom_max_2g -
-				    ((offset_mcs & 0xf) * 2);
+					pi->tx_srom_max_2g -
+					((offset_mcs & 0xf) * 2);
 				offset_mcs >>= 4;
 			}
 		} else {
@@ -1667,8 +1665,8 @@ void wlc_phy_txpower_recalc_target(struct brcms_phy *pi)
 			for (i = TXP_FIRST_SISO_MCS_20;
 			     i <= TXP_LAST_SISO_MCS_20; i++) {
 				pi->tx_srom_max_rate_2g[i - 8] =
-				    pi->tx_srom_max_2g -
-				    ((offset_mcs & 0xf) * 2);
+					pi->tx_srom_max_2g -
+					((offset_mcs & 0xf) * 2);
 				offset_mcs >>= 4;
 			}
 		}
@@ -1689,8 +1687,10 @@ void wlc_phy_txpower_recalc_target(struct brcms_phy *pi)
 
 		if (pi->user_txpwr_at_rfport)
 			tx_pwr_target[rate] +=
-			    wlc_user_txpwr_antport_to_rfport(pi, target_chan,
-							     band, rate);
+				wlc_user_txpwr_antport_to_rfport(pi,
+								 target_chan,
+								 band,
+								 rate);
 
 		{
 
@@ -1701,7 +1701,7 @@ void wlc_phy_txpower_recalc_target(struct brcms_phy *pi)
 			maxtxpwr = min(maxtxpwr, pi->txpwr_limit[rate]);
 
 			maxtxpwr =
-			    (maxtxpwr > pactrl) ? (maxtxpwr - pactrl) : 0;
+				(maxtxpwr > pactrl) ? (maxtxpwr - pactrl) : 0;
 
 			maxtxpwr = (maxtxpwr > 6) ? (maxtxpwr - 6) : 0;
 
@@ -1714,7 +1714,7 @@ void wlc_phy_txpower_recalc_target(struct brcms_phy *pi)
 		}
 
 		tx_pwr_target[rate] =
-		    min(tx_pwr_target[rate], pi->txpwr_env_limit[rate]);
+			min(tx_pwr_target[rate], pi->txpwr_env_limit[rate]);
 
 		if (tx_pwr_target[rate] > tx_pwr_max)
 			tx_pwr_max_rate_ind = rate;
@@ -1733,15 +1733,15 @@ void wlc_phy_txpower_recalc_target(struct brcms_phy *pi)
 
 		if (!pi->hwpwrctrl || ISNPHY(pi))
 			pi->tx_power_offset[rate] =
-			    pi->tx_power_max - pi->tx_power_target[rate];
+				pi->tx_power_max - pi->tx_power_target[rate];
 		else
 			pi->tx_power_offset[rate] =
-			    pi->tx_power_target[rate] - pi->tx_power_min;
+				pi->tx_power_target[rate] - pi->tx_power_min;
 	}
 
 	txpwr_recalc_fn = pi->pi_fptr.txpwrrecalc;
 	if (txpwr_recalc_fn)
-		(*txpwr_recalc_fn) (pi);
+		(*txpwr_recalc_fn)(pi);
 }
 
 void
@@ -1781,7 +1781,7 @@ wlc_phy_txpower_reg_limit_calc(struct brcms_phy *pi, struct txpwr_limits *txpwr,
 				txpwr_ptr1 = txpwr->mcs_40_siso;
 				txpwr_ptr2 = txpwr->ofdm_40_siso;
 				rate_start_index =
-				    WL_TX_POWER_OFDM40_SISO_FIRST;
+					WL_TX_POWER_OFDM40_SISO_FIRST;
 				break;
 			case 3:
 
@@ -1791,18 +1791,21 @@ wlc_phy_txpower_reg_limit_calc(struct brcms_phy *pi, struct txpwr_limits *txpwr,
 				break;
 			}
 
-			for (rate2 = 0; rate2 < BRCMS_NUM_RATES_OFDM; rate2++) {
+			for (rate2 = 0; rate2 < BRCMS_NUM_RATES_OFDM;
+			     rate2++) {
 				tmp_txpwr_limit[rate2] = 0;
 				tmp_txpwr_limit[BRCMS_NUM_RATES_OFDM + rate2] =
-				    txpwr_ptr1[rate2];
+					txpwr_ptr1[rate2];
 			}
-			wlc_phy_mcs_to_ofdm_powers_nphy(tmp_txpwr_limit, 0,
-				BRCMS_NUM_RATES_OFDM - 1, BRCMS_NUM_RATES_OFDM);
+			wlc_phy_mcs_to_ofdm_powers_nphy(
+				tmp_txpwr_limit, 0,
+				BRCMS_NUM_RATES_OFDM -
+				1, BRCMS_NUM_RATES_OFDM);
 			for (rate1 = rate_start_index, rate2 = 0;
 			     rate2 < BRCMS_NUM_RATES_OFDM; rate1++, rate2++)
 				pi->txpwr_limit[rate1] =
-				    min(txpwr_ptr2[rate2],
-					tmp_txpwr_limit[rate2]);
+					min(txpwr_ptr2[rate2],
+					    tmp_txpwr_limit[rate2]);
 		}
 
 		for (k = 0; k < 4; k++) {
@@ -1832,19 +1835,22 @@ wlc_phy_txpower_reg_limit_calc(struct brcms_phy *pi, struct txpwr_limits *txpwr,
 				rate_start_index = WL_TX_POWER_MCS40_CDD_FIRST;
 				break;
 			}
-			for (rate2 = 0; rate2 < BRCMS_NUM_RATES_OFDM; rate2++) {
+			for (rate2 = 0; rate2 < BRCMS_NUM_RATES_OFDM;
+			     rate2++) {
 				tmp_txpwr_limit[rate2] = 0;
 				tmp_txpwr_limit[BRCMS_NUM_RATES_OFDM + rate2] =
-				    txpwr_ptr1[rate2];
+					txpwr_ptr1[rate2];
 			}
-			wlc_phy_ofdm_to_mcs_powers_nphy(tmp_txpwr_limit, 0,
-				BRCMS_NUM_RATES_OFDM - 1, BRCMS_NUM_RATES_OFDM);
+			wlc_phy_ofdm_to_mcs_powers_nphy(
+				tmp_txpwr_limit, 0,
+				BRCMS_NUM_RATES_OFDM -
+				1, BRCMS_NUM_RATES_OFDM);
 			for (rate1 = rate_start_index, rate2 = 0;
 			     rate2 < BRCMS_NUM_RATES_MCS_1_STREAM;
 			     rate1++, rate2++)
 				pi->txpwr_limit[rate1] =
-				    min(txpwr_ptr2[rate2],
-					tmp_txpwr_limit[rate2]);
+					min(txpwr_ptr2[rate2],
+					    tmp_txpwr_limit[rate2]);
 		}
 
 		for (k = 0; k < 2; k++) {
@@ -1888,10 +1894,10 @@ wlc_phy_txpower_reg_limit_calc(struct brcms_phy *pi, struct txpwr_limits *txpwr,
 		pi->txpwr_limit[WL_TX_POWER_MCS_32] = txpwr->mcs32;
 
 		pi->txpwr_limit[WL_TX_POWER_MCS40_CDD_FIRST] =
-		    min(pi->txpwr_limit[WL_TX_POWER_MCS40_CDD_FIRST],
-			pi->txpwr_limit[WL_TX_POWER_MCS_32]);
+			min(pi->txpwr_limit[WL_TX_POWER_MCS40_CDD_FIRST],
+			    pi->txpwr_limit[WL_TX_POWER_MCS_32]);
 		pi->txpwr_limit[WL_TX_POWER_MCS_32] =
-		    pi->txpwr_limit[WL_TX_POWER_MCS40_CDD_FIRST];
+			pi->txpwr_limit[WL_TX_POWER_MCS40_CDD_FIRST];
 	}
 }
 
@@ -2005,9 +2011,9 @@ void wlc_phy_txpower_update_shm(struct brcms_phy *pi)
 			const u8 ucode_ofdm_rates[] = {
 				0x0c, 0x12, 0x18, 0x24, 0x30, 0x48, 0x60, 0x6c
 			};
-			offset = wlapi_bmac_rate_shm_offset(pi->sh->physhim,
-							    ucode_ofdm_rates[j -
-									     TXP_FIRST_OFDM]);
+			offset = wlapi_bmac_rate_shm_offset(
+				pi->sh->physhim,
+				ucode_ofdm_rates[j - TXP_FIRST_OFDM]);
 			wlapi_bmac_write_shm(pi->sh->physhim, offset + 6,
 					     pi->tx_power_offset[j]);
 			wlapi_bmac_write_shm(pi->sh->physhim, offset + 14,
@@ -2021,11 +2027,11 @@ void wlc_phy_txpower_update_shm(struct brcms_phy *pi)
 
 		for (i = TXP_FIRST_OFDM; i <= TXP_LAST_OFDM; i++)
 			pi->tx_power_offset[i] =
-			    (u8) roundup(pi->tx_power_offset[i], 8);
+				(u8) roundup(pi->tx_power_offset[i], 8);
 		wlapi_bmac_write_shm(pi->sh->physhim, M_OFDM_OFFSET,
-				     (u16) ((pi->
-						tx_power_offset[TXP_FIRST_OFDM]
-						+ 7) >> 3));
+				     (u16)
+				     ((pi->tx_power_offset[TXP_FIRST_OFDM]
+				       + 7) >> 3));
 	}
 }
 
@@ -2052,9 +2058,7 @@ void wlc_phy_txpower_hw_ctrl_set(struct brcms_phy_pub *ppi, bool hwpwrctrl)
 	pi->txpwrctrl = hwpwrctrl;
 
 	if (ISNPHY(pi)) {
-		suspend =
-		    (0 ==
-		     (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
+		suspend = (0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
 		if (!suspend)
 			wlapi_suspend_mac_and_wait(pi->sh->physhim);
 
@@ -2092,38 +2096,31 @@ static u32 wlc_phy_txpower_est_power_nphy(struct brcms_phy *pi)
 	estPower1 = read_phy_reg(pi, 0x118);
 	estPower2 = read_phy_reg(pi, 0x119);
 
-	if ((estPower1 & (0x1 << 8))
-	    == (0x1 << 8))
-		pwr0 = (u8) (estPower1 & (0xff << 0))
-		    >> 0;
+	if ((estPower1 & (0x1 << 8)) == (0x1 << 8))
+		pwr0 = (u8) (estPower1 & (0xff << 0)) >> 0;
 	else
 		pwr0 = 0x80;
 
-	if ((estPower2 & (0x1 << 8))
-	    == (0x1 << 8))
-		pwr1 = (u8) (estPower2 & (0xff << 0))
-		    >> 0;
+	if ((estPower2 & (0x1 << 8)) == (0x1 << 8))
+		pwr1 = (u8) (estPower2 & (0xff << 0)) >> 0;
 	else
 		pwr1 = 0x80;
 
 	tx0_status = read_phy_reg(pi, 0x1ed);
 	tx1_status = read_phy_reg(pi, 0x1ee);
 
-	if ((tx0_status & (0x1 << 15))
-	    == (0x1 << 15))
-		adj_pwr0 = (u8) (tx0_status & (0xff << 0))
-		    >> 0;
+	if ((tx0_status & (0x1 << 15)) == (0x1 << 15))
+		adj_pwr0 = (u8) (tx0_status & (0xff << 0)) >> 0;
 	else
 		adj_pwr0 = 0x80;
-	if ((tx1_status & (0x1 << 15))
-	    == (0x1 << 15))
-		adj_pwr1 = (u8) (tx1_status & (0xff << 0))
-		    >> 0;
+	if ((tx1_status & (0x1 << 15)) == (0x1 << 15))
+		adj_pwr1 = (u8) (tx1_status & (0xff << 0)) >> 0;
 	else
 		adj_pwr1 = 0x80;
 
-	est_pwr =
-	    (u32) ((pwr0 << 24) | (pwr1 << 16) | (adj_pwr0 << 8) | adj_pwr1);
+	est_pwr = (u32) ((pwr0 << 24) | (pwr1 << 16) | (adj_pwr0 << 8) |
+			 adj_pwr1);
+
 	return est_pwr;
 }
 
@@ -2144,7 +2141,7 @@ wlc_phy_txpower_get_current(struct brcms_phy_pub *ppi, struct tx_power *power,
 		power->flags |= (WL_TX_POWER_F_MIMO);
 		if (pi->nphy_txpwrctrl == PHY_TPC_HW_ON)
 			power->flags |=
-			    (WL_TX_POWER_F_ENABLED | WL_TX_POWER_F_HW);
+				(WL_TX_POWER_F_ENABLED | WL_TX_POWER_F_HW);
 	} else if (ISLCNPHY(pi)) {
 		power->rf_cores = 1;
 		power->flags |= (WL_TX_POWER_F_SISO);
@@ -2207,16 +2204,18 @@ wlc_phy_txpower_get_current(struct brcms_phy_pub *ppi, struct tx_power *power,
 			power->tx_power_max[1] = pi->tx_power_max;
 
 			power->tx_power_max_rate_ind[0] =
-			    pi->tx_power_max_rate_ind;
+				pi->tx_power_max_rate_ind;
 			power->tx_power_max_rate_ind[1] =
-			    pi->tx_power_max_rate_ind;
+				pi->tx_power_max_rate_ind;
 
 			if (wlc_phy_tpc_isenabled_lcnphy(pi))
 				power->flags |=
-				    (WL_TX_POWER_F_HW | WL_TX_POWER_F_ENABLED);
+					(WL_TX_POWER_F_HW |
+					 WL_TX_POWER_F_ENABLED);
 			else
 				power->flags &=
-				    ~(WL_TX_POWER_F_HW | WL_TX_POWER_F_ENABLED);
+					~(WL_TX_POWER_F_HW |
+					  WL_TX_POWER_F_ENABLED);
 
 			wlc_lcnphy_get_tssi(pi, (s8 *) &power->est_Pout[0],
 					    (s8 *) &power->est_Pout_cck);
@@ -2261,8 +2260,7 @@ void wlc_phy_ant_rxdiv_set(struct brcms_phy_pub *ppi, u8 val)
 	if (!pi->sh->clk)
 		return;
 
-	suspend =
-	    (0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
+	suspend = (0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
 	if (!suspend)
 		wlapi_suspend_mac_and_wait(pi->sh->physhim);
 
@@ -2306,7 +2304,7 @@ wlc_phy_noise_calc_phy(struct brcms_phy *pi, u32 *cmplx_pwr, s8 *pwr_ant)
 		pwr_ant[i] = cmplx_pwr_dbm[i];
 	}
 	pi->nphy_noise_index =
-	    MODINC_POW2(pi->nphy_noise_index, PHY_NOISE_WINDOW_SZ);
+		MODINC_POW2(pi->nphy_noise_index, PHY_NOISE_WINDOW_SZ);
 	return true;
 }
 
@@ -2343,12 +2341,11 @@ wlc_phy_noise_sample_request(struct brcms_phy_pub *pih, u8 reason, u8 ch)
 	if (pi->phy_fixed_noise) {
 		if (ISNPHY(pi)) {
 			pi->nphy_noise_win[WL_ANT_IDX_1][pi->nphy_noise_index] =
-			    PHY_NOISE_FIXED_VAL_NPHY;
+				PHY_NOISE_FIXED_VAL_NPHY;
 			pi->nphy_noise_win[WL_ANT_IDX_2][pi->nphy_noise_index] =
-			    PHY_NOISE_FIXED_VAL_NPHY;
+				PHY_NOISE_FIXED_VAL_NPHY;
 			pi->nphy_noise_index = MODINC_POW2(pi->nphy_noise_index,
 							   PHY_NOISE_WINDOW_SZ);
-
 			noise_dbm = PHY_NOISE_FIXED_VAL_NPHY;
 		} else {
 			noise_dbm = PHY_NOISE_FIXED_VAL;
@@ -2413,15 +2410,14 @@ wlc_phy_noise_sample_request(struct brcms_phy_pub *pih, u8 reason, u8 ch)
 			wlapi_enable_mac(pi->sh->physhim);
 
 			for (i = 0; i < pi->pubpi.phy_corenum; i++)
-				cmplx_pwr[i] =
-				    (est[i].i_pwr +
-				     est[i].q_pwr) >> log_num_samps;
+				cmplx_pwr[i] = (est[i].i_pwr + est[i].q_pwr) >>
+					       log_num_samps;
 
 			wlc_phy_noise_calc_phy(pi, cmplx_pwr, noise_dbm_ant);
 
 			for (i = 0; i < pi->pubpi.phy_corenum; i++) {
 				pi->nphy_noise_win[i][pi->nphy_noise_index] =
-				    noise_dbm_ant[i];
+					noise_dbm_ant[i];
 
 				if (noise_dbm_ant[i] > noise_dbm)
 					noise_dbm = noise_dbm_ant[i];
@@ -2433,7 +2429,7 @@ wlc_phy_noise_sample_request(struct brcms_phy_pub *pih, u8 reason, u8 ch)
 		}
 	}
 
- done:
+done:
 
 	if (!wait_for_intr)
 		wlc_phy_noise_cb(pi, ch, noise_dbm);
@@ -2457,9 +2453,9 @@ static void wlc_phy_noise_cb(struct brcms_phy *pi, u8 channel, s8 noise_dbm)
 	if (pi->phynoise_state & PHY_NOISE_STATE_MON) {
 		if (pi->phynoise_chan_watchdog == channel) {
 			pi->sh->phy_noise_window[pi->sh->phy_noise_index] =
-			    noise_dbm;
+				noise_dbm;
 			pi->sh->phy_noise_index =
-			    MODINC(pi->sh->phy_noise_index, MA_WINDOW_SZ);
+				MODINC(pi->sh->phy_noise_index, MA_WINDOW_SZ);
 		}
 		pi->phynoise_state &= ~PHY_NOISE_STATE_MON;
 	}
@@ -2481,7 +2477,8 @@ static s8 wlc_phy_noise_read_shmem(struct brcms_phy *pi)
 	memset((u8 *) cmplx_pwr, 0, sizeof(cmplx_pwr));
 	memset((u8 *) noise_dbm_ant, 0, sizeof(noise_dbm_ant));
 
-	for (idx = 0, core = 0; core < pi->pubpi.phy_corenum; idx += 2, core++) {
+	for (idx = 0, core = 0; core < pi->pubpi.phy_corenum; idx += 2,
+	     core++) {
 		lo = wlapi_bmac_read_shm(pi->sh->physhim, M_PWRIND_MAP(idx));
 		hi = wlapi_bmac_read_shm(pi->sh->physhim,
 					 M_PWRIND_MAP(idx + 1));
@@ -2498,13 +2495,13 @@ static s8 wlc_phy_noise_read_shmem(struct brcms_phy *pi)
 
 	for (core = 0; core < pi->pubpi.phy_corenum; core++) {
 		pi->nphy_noise_win[core][pi->nphy_noise_index] =
-		    noise_dbm_ant[core];
+			noise_dbm_ant[core];
 
 		if (noise_dbm_ant[core] > noise_dbm)
 			noise_dbm = noise_dbm_ant[core];
 	}
 	pi->nphy_noise_index =
-	    MODINC_POW2(pi->nphy_noise_index, PHY_NOISE_WINDOW_SZ);
+		MODINC_POW2(pi->nphy_noise_index, PHY_NOISE_WINDOW_SZ);
 
 	return noise_dbm;
 
@@ -2665,7 +2662,7 @@ void wlc_phy_rssi_compute(struct brcms_phy_pub *pih, void *ctx)
 		rssi = wlc_phy_rssi_compute_nphy(pi, wlc_rxhdr);
 	}
 
- end:
+end:
 	wlc_rxhdr->rssi = (s8) rssi;
 }
 
@@ -2739,8 +2736,9 @@ void wlc_phy_watchdog(struct brcms_phy_pub *pih)
 		    ((pi->sh->now - pi->phy_lastcal) >=
 		     pi->sh->glacial_timer)) {
 			if (!(SCAN_RM_IN_PROGRESS(pi) || ASSOC_INPROG_PHY(pi)))
-				wlc_lcnphy_calib_modes(pi,
-						       LCNPHY_PERICAL_TEMPBASED_TXPWRCTRL);
+				wlc_lcnphy_calib_modes(
+					pi,
+					LCNPHY_PERICAL_TEMPBASED_TXPWRCTRL);
 			if (!
 			    (SCAN_RM_IN_PROGRESS(pi) || PLT_INPROG_PHY(pi)
 			     || ASSOC_INPROG_PHY(pi)
@@ -2763,7 +2761,7 @@ void wlc_phy_BSSinit(struct brcms_phy_pub *pih, bool bonlyap, int rssi)
 	if (ISLCNPHY(pi)) {
 		for (i = 0; i < MA_WINDOW_SZ; i++)
 			pi->sh->phy_noise_window[i] =
-			    PHY_NOISE_FIXED_VAL_LCNPHY;
+				PHY_NOISE_FIXED_VAL_LCNPHY;
 	}
 	pi->sh->phy_noise_index = 0;
 
@@ -2819,9 +2817,8 @@ void wlc_phy_cordic(s32 theta, struct cs32 *val)
 	angle = 0;
 
 	signtheta = (theta < 0) ? -1 : 1;
-	theta =
-	    ((theta + FIXED(180) * signtheta) % FIXED(360)) -
-	    FIXED(180) * signtheta;
+	theta =	((theta + FIXED(180) * signtheta) % FIXED(360)) -
+		FIXED(180) * signtheta;
 
 	if (FLOAT(theta) > 90) {
 		theta -= FIXED(180);
@@ -2895,8 +2892,9 @@ void wlc_phy_cal_perical(struct brcms_phy_pub *pih, u8 reason)
 			if (PHY_PERICAL_MPHASE_PENDING(pi))
 				wlc_phy_cal_perical_mphase_reset(pi);
 
-			wlc_phy_cal_perical_mphase_schedule(pi,
-							    PHY_PERICAL_INIT_DELAY);
+			wlc_phy_cal_perical_mphase_schedule(
+				pi,
+				PHY_PERICAL_INIT_DELAY);
 		}
 		break;
 
@@ -2921,9 +2919,9 @@ void wlc_phy_cal_perical(struct brcms_phy_pub *pih, u8 reason)
 		if (pi->phycal_tempdelta) {
 			nphy_currtemp = wlc_phy_tempsense_nphy(pi);
 			delta_temp =
-			    (nphy_currtemp > pi->nphy_lastcal_temp) ?
-			    nphy_currtemp - pi->nphy_lastcal_temp :
-			    pi->nphy_lastcal_temp - nphy_currtemp;
+				(nphy_currtemp > pi->nphy_lastcal_temp) ?
+				nphy_currtemp - pi->nphy_lastcal_temp :
+				pi->nphy_lastcal_temp - nphy_currtemp;
 
 			if ((delta_temp < (s16) pi->phycal_tempdelta) &&
 			    (pi->nphy_txiqlocal_chanspec ==
@@ -2936,8 +2934,9 @@ void wlc_phy_cal_perical(struct brcms_phy_pub *pih, u8 reason)
 		if (do_periodic_cal) {
 			if (pi->nphy_perical == PHY_PERICAL_MPHASE) {
 				if (!PHY_PERICAL_MPHASE_PENDING(pi))
-					wlc_phy_cal_perical_mphase_schedule(pi,
-									    PHY_PERICAL_WDOG_DELAY);
+					wlc_phy_cal_perical_mphase_schedule(
+						pi,
+						PHY_PERICAL_WDOG_DELAY);
 			} else if (pi->nphy_perical == PHY_PERICAL_SPHASE)
 				wlc_phy_cal_perical_nphy_run(pi,
 							     PHY_PERICAL_AUTO);
@@ -3035,11 +3034,11 @@ s8 wlc_phy_stf_ssmode_get(struct brcms_phy_pub *pih, u16 chanspec)
 	u8 siso_mcs_id, cdd_mcs_id;
 
 	siso_mcs_id =
-	    (CHSPEC_IS40(chanspec)) ? TXP_FIRST_MCS_40_SISO :
-	    TXP_FIRST_MCS_20_SISO;
+		(CHSPEC_IS40(chanspec)) ? TXP_FIRST_MCS_40_SISO :
+		TXP_FIRST_MCS_20_SISO;
 	cdd_mcs_id =
-	    (CHSPEC_IS40(chanspec)) ? TXP_FIRST_MCS_40_CDD :
-	    TXP_FIRST_MCS_20_CDD;
+		(CHSPEC_IS40(chanspec)) ? TXP_FIRST_MCS_40_CDD :
+		TXP_FIRST_MCS_20_CDD;
 
 	if (pi->tx_power_target[siso_mcs_id] >
 	    (pi->tx_power_target[cdd_mcs_id] + 12))
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
index bc0cc59..d2faba2 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
@@ -126,28 +126,32 @@ struct txpwr_limits {
 
 struct tx_power {
 	u32 flags;
-	u16 chanspec;	/* txpwr report for this channel */
-	u16 local_chanspec;	/* channel on which we are associated */
-	u8 local_max;	/* local max according to the AP */
-	u8 local_constraint;	/* local constraint according to the AP */
-	s8 antgain[2];	/* Ant gain for each band - from SROM */
-	u8 rf_cores;		/* count of RF Cores being reported */
-	u8 est_Pout[4];	/* Latest tx power out estimate per RF chain */
-	u8 est_Pout_act[4];	/* Latest tx power out estimate per RF chain
-				 * without adjustment
-				 */
-	u8 est_Pout_cck;	/* Latest CCK tx power out estimate */
-	u8 tx_power_max[4];	/* Maximum target power among all rates */
-	u8 tx_power_max_rate_ind[4];	/* Index of the rate with the max target power */
-	u8 user_limit[WL_TX_POWER_RATES];	/* User limit */
-	u8 reg_limit[WL_TX_POWER_RATES];	/* Regulatory power limit */
-	u8 board_limit[WL_TX_POWER_RATES];	/* Max power board can support (SROM) */
-	u8 target[WL_TX_POWER_RATES];	/* Latest target power */
+	u16 chanspec;   /* txpwr report for this channel */
+	u16 local_chanspec;     /* channel on which we are associated */
+	u8 local_max;   /* local max according to the AP */
+	u8 local_constraint;    /* local constraint according to the AP */
+	s8 antgain[2];  /* Ant gain for each band - from SROM */
+	u8 rf_cores;            /* count of RF Cores being reported */
+	u8 est_Pout[4]; /* Latest tx power out estimate per RF chain */
+	u8 est_Pout_act[4];     /* Latest tx power out estimate per RF chain
+				 * without adjustment */
+	u8 est_Pout_cck;        /* Latest CCK tx power out estimate */
+	u8 tx_power_max[4];     /* Maximum target power among all rates */
+	/* Index of the rate with the max target power */
+	u8 tx_power_max_rate_ind[4];
+	/* User limit */
+	u8 user_limit[WL_TX_POWER_RATES];
+	/* Regulatory power limit */
+	u8 reg_limit[WL_TX_POWER_RATES];
+	/* Max power board can support (SROM) */
+	u8 board_limit[WL_TX_POWER_RATES];
+	/* Latest target power */
+	u8 target[WL_TX_POWER_RATES];
 };
 
 struct tx_inst_power {
-	u8 txpwr_est_Pout[2];	/* Latest estimate for 2.4 and 5 Ghz */
-	u8 txpwr_est_Pout_gofdm;	/* Pwr estimate for 2.4 OFDM */
+	u8 txpwr_est_Pout[2];   /* Latest estimate for 2.4 and 5 Ghz */
+	u8 txpwr_est_Pout_gofdm;        /* Pwr estimate for 2.4 OFDM */
 };
 
 struct brcms_chanvec {
@@ -178,7 +182,8 @@ struct shared_phy_params {
 
 extern struct shared_phy *wlc_phy_shared_attach(struct shared_phy_params *shp);
 extern struct brcms_phy_pub *wlc_phy_attach(struct shared_phy *sh, void *regs,
-				 int bandtype, char *vars, struct wiphy *wiphy);
+					    int bandtype, char *vars,
+					    struct wiphy *wiphy);
 extern void wlc_phy_detach(struct brcms_phy_pub *ppi);
 
 extern bool wlc_phy_get_phyversion(struct brcms_phy_pub *pih, u16 *phytype,
@@ -222,7 +227,7 @@ extern void wlc_phy_chanspec_ch14_widefilter_set(struct brcms_phy_pub *ppi,
 extern void wlc_phy_chanspec_band_validch(struct brcms_phy_pub *ppi, uint band,
 					  struct brcms_chanvec *channels);
 extern u16 wlc_phy_chanspec_band_firstch(struct brcms_phy_pub *ppi,
-						uint band);
+					 uint band);
 
 extern void wlc_phy_txpower_sromlimit(struct brcms_phy_pub *ppi, uint chan,
 				      u8 *_min_, u8 *_max_, int rate);
@@ -289,6 +294,6 @@ extern void wlc_phy_freqtrack_end(struct brcms_phy_pub *ppi);
 extern const u8 *wlc_phy_get_ofdm_rate_lookup(void);
 
 extern s8 wlc_phy_get_tx_power_offset_by_mcs(struct brcms_phy_pub *ppi,
-					       u8 mcs_offset);
+					     u8 mcs_offset);
 extern s8 wlc_phy_get_tx_power_offset(struct brcms_phy_pub *ppi, u8 tbl_offset);
-#endif				/* _BRCM_PHY_HAL_H_ */
+#endif                          /* _BRCM_PHY_HAL_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
index e580420..25ea003 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
@@ -42,11 +42,16 @@ extern u32 phyhal_msg_level;
 #define LCNXN_BASEREV		16
 
 struct brcms_phy_srom_fem {
-	u8 tssipos;		/* TSSI positive slope, 1: positive, 0: negative */
-	u8 extpagain;	/* Ext PA gain-type: full-gain: 0, pa-lite: 1, no_pa: 2 */
-	u8 pdetrange;	/* support 32 combinations of different Pdet dynamic ranges */
-	u8 triso;		/* TR switch isolation */
-	u8 antswctrllut;	/* antswctrl lookup table configuration: 32 possible choices */
+	/* TSSI positive slope, 1: positive, 0: negative */
+	u8 tssipos;
+	/* Ext PA gain-type: full-gain: 0, pa-lite: 1, no_pa: 2 */
+	u8 extpagain;
+	/* support 32 combinations of different Pdet dynamic ranges */
+	u8 pdetrange;
+	/* TR switch isolation */
+	u8 triso;
+	/* antswctrl lookup table configuration: 32 possible choices */
+	u8 antswctrllut;
 };
 
 #undef ISNPHY
@@ -192,7 +197,9 @@ struct brcms_phy_srom_fem {
 #define PHY_PERICAL_WDOG_DELAY	5
 
 #define MPHASE_TXCAL_NUMCMDS	2
-#define PHY_PERICAL_MPHASE_PENDING(pi)	(pi->mphase_cal_phase_id > MPHASE_CAL_STATE_IDLE)
+
+#define PHY_PERICAL_MPHASE_PENDING(pi) \
+	(pi->mphase_cal_phase_id > MPHASE_CAL_STATE_IDLE)
 
 enum {
 	MPHASE_CAL_STATE_IDLE = 0,
@@ -237,7 +244,9 @@ enum phy_cal_mode {
 #define CORDIC_AG	39797
 #define	CORDIC_NI	18
 #define	FIXED(X)	((s32)((X) << 16))
-#define	FLOAT(X)	(((X) >= 0) ? ((((X) >> 15) + 1) >> 1) : -((((-(X)) >> 15) + 1) >> 1))
+
+#define	FLOAT(X) \
+	(((X) >= 0) ? ((((X) >> 15) + 1) >> 1) : -((((-(X)) >> 15) + 1) >> 1))
 
 #define PHY_CHAIN_TX_DISABLE_TEMP	115
 #define PHY_HYSTERESIS_DELTATEMP	5
@@ -245,30 +254,46 @@ enum phy_cal_mode {
 #define PHY_BITSCNT(x)	brcmu_bitcount((u8 *)&(x), sizeof(u8))
 
 #define MOD_PHY_REG(pi, phy_type, reg_name, field, value) \
-	mod_phy_reg(pi, phy_type##_##reg_name, phy_type##_##reg_name##_##field##_MASK, \
-	(value) << phy_type##_##reg_name##_##field##_##SHIFT)
+	mod_phy_reg(pi, phy_type##_##reg_name, \
+		    phy_type##_##reg_name##_##field##_MASK, \
+		    (value) << phy_type##_##reg_name##_##field##_##SHIFT)
+
 #define READ_PHY_REG(pi, phy_type, reg_name, field) \
-	((read_phy_reg(pi, phy_type##_##reg_name) & phy_type##_##reg_name##_##field##_##MASK)\
-	>> phy_type##_##reg_name##_##field##_##SHIFT)
+	((read_phy_reg(pi, phy_type##_##reg_name) & \
+	  phy_type##_##reg_name##_##field##_##MASK) \
+	 >> phy_type##_##reg_name##_##field##_##SHIFT)
 
 #define	VALID_PHYTYPE(phytype)	(((uint)phytype == PHY_TYPE_N) || \
 				((uint)phytype == PHY_TYPE_LCN))
 
-#define VALID_N_RADIO(radioid)	((radioid == BCM2055_ID) || (radioid == BCM2056_ID) || \
-				(radioid == BCM2057_ID))
+#define VALID_N_RADIO(radioid) ((radioid == BCM2055_ID) || \
+				 (radioid == BCM2056_ID) || \
+				 (radioid == BCM2057_ID))
+
 #define VALID_LCN_RADIO(radioid)	(radioid == BCM2064_ID)
 
-#define	VALID_RADIO(pi, radioid)	(\
-	(ISNPHY(pi) ? VALID_N_RADIO(radioid) : false) || \
-	(ISLCNPHY(pi) ? VALID_LCN_RADIO(radioid) : false))
+#define VALID_RADIO(pi, radioid)        ( \
+		(ISNPHY(pi) ? VALID_N_RADIO(radioid) : false) || \
+		(ISLCNPHY(pi) ? VALID_LCN_RADIO(radioid) : false))
+
+#define SCAN_INPROG_PHY(pi) \
+	(mboolisset(pi->measure_hold, PHY_HOLD_FOR_SCAN))
+
+#define RM_INPROG_PHY(pi)       (mboolisset(pi->measure_hold, PHY_HOLD_FOR_RM))
+
+#define PLT_INPROG_PHY(pi)      (mboolisset(pi->measure_hold, PHY_HOLD_FOR_PLT))
+
+#define ASSOC_INPROG_PHY(pi) \
+	(mboolisset(pi->measure_hold, PHY_HOLD_FOR_ASSOC))
 
-#define SCAN_INPROG_PHY(pi)	(mboolisset(pi->measure_hold, PHY_HOLD_FOR_SCAN))
-#define RM_INPROG_PHY(pi)	(mboolisset(pi->measure_hold, PHY_HOLD_FOR_RM))
-#define PLT_INPROG_PHY(pi)	(mboolisset(pi->measure_hold, PHY_HOLD_FOR_PLT))
-#define ASSOC_INPROG_PHY(pi)	(mboolisset(pi->measure_hold, PHY_HOLD_FOR_ASSOC))
-#define SCAN_RM_IN_PROGRESS(pi) (mboolisset(pi->measure_hold, PHY_HOLD_FOR_SCAN | PHY_HOLD_FOR_RM))
-#define PHY_MUTED(pi)		(mboolisset(pi->measure_hold, PHY_HOLD_FOR_MUTE))
-#define PUB_NOT_ASSOC(pi)	(mboolisset(pi->measure_hold, PHY_HOLD_FOR_NOT_ASSOC))
+#define SCAN_RM_IN_PROGRESS(pi) \
+	(mboolisset(pi->measure_hold, PHY_HOLD_FOR_SCAN | PHY_HOLD_FOR_RM))
+
+#define PHY_MUTED(pi) \
+	(mboolisset(pi->measure_hold, PHY_HOLD_FOR_MUTE))
+
+#define PUB_NOT_ASSOC(pi) \
+	(mboolisset(pi->measure_hold, PHY_HOLD_FOR_NOT_ASSOC))
 
 #if defined(EXT_CBALL)
 #define NORADIO_ENAB(pub) ((pub).radioid == NORADIO_ID)
@@ -568,18 +593,18 @@ struct brcms_phy_pub {
 };
 
 struct phy_func_ptr {
-	void (*init) (struct brcms_phy *);
-	void (*calinit) (struct brcms_phy *);
-	void (*chanset) (struct brcms_phy *, u16 chanspec);
-	void (*txpwrrecalc) (struct brcms_phy *);
-	int (*longtrn) (struct brcms_phy *, int);
-	void (*txiqccget) (struct brcms_phy *, u16 *, u16 *);
-	void (*txiqccset) (struct brcms_phy *, u16, u16);
-	u16(*txloccget) (struct brcms_phy *);
-	void (*radioloftget) (struct brcms_phy *, u8 *, u8 *, u8 *, u8 *);
-	void (*carrsuppr) (struct brcms_phy *);
-	s32(*rxsigpwr) (struct brcms_phy *, s32);
-	void (*detach) (struct brcms_phy *);
+	void (*init)(struct brcms_phy *);
+	void (*calinit)(struct brcms_phy *);
+	void (*chanset)(struct brcms_phy *, u16 chanspec);
+	void (*txpwrrecalc)(struct brcms_phy *);
+	int (*longtrn)(struct brcms_phy *, int);
+	void (*txiqccget)(struct brcms_phy *, u16 *, u16 *);
+	void (*txiqccset)(struct brcms_phy *, u16, u16);
+	u16 (*txloccget)(struct brcms_phy *);
+	void (*radioloftget)(struct brcms_phy *, u8 *, u8 *, u8 *, u8 *);
+	void (*carrsuppr)(struct brcms_phy *);
+	s32 (*rxsigpwr)(struct brcms_phy *, s32);
+	void (*detach)(struct brcms_phy *);
 };
 
 struct brcms_phy {
@@ -712,7 +737,7 @@ struct brcms_phy {
 	u16 mintxbias;
 	u16 mintxmag;
 	struct lo_complex_abgphy_info gphy_locomp_iq
-					[STATIC_NUM_RF][STATIC_NUM_BB];
+			[STATIC_NUM_RF][STATIC_NUM_BB];
 	s8 stats_11b_txpower[STATIC_NUM_RF][STATIC_NUM_BB];
 	u16 gain_table[TX_GAIN_TABLE_LENGTH];
 	bool loopback_gain;
@@ -955,26 +980,29 @@ struct lcnphy_radio_regs {
 
 extern struct lcnphy_radio_regs lcnphy_radio_regs_2064[];
 extern struct lcnphy_radio_regs lcnphy_radio_regs_2066[];
+
 extern struct radio_regs regs_2055[], regs_SYN_2056[], regs_TX_2056[],
-	regs_RX_2056[];
+			 regs_RX_2056[];
 extern struct radio_regs regs_SYN_2056_A1[], regs_TX_2056_A1[],
-	      regs_RX_2056_A1[];
+			 regs_RX_2056_A1[];
 extern struct radio_regs regs_SYN_2056_rev5[], regs_TX_2056_rev5[],
-	regs_RX_2056_rev5[];
+			 regs_RX_2056_rev5[];
 extern struct radio_regs regs_SYN_2056_rev6[], regs_TX_2056_rev6[],
-	regs_RX_2056_rev6[];
+			 regs_RX_2056_rev6[];
 extern struct radio_regs regs_SYN_2056_rev7[], regs_TX_2056_rev7[],
-	regs_RX_2056_rev7[];
+			 regs_RX_2056_rev7[];
 extern struct radio_regs regs_SYN_2056_rev8[], regs_TX_2056_rev8[],
-	regs_RX_2056_rev8[];
+			 regs_RX_2056_rev8[];
+
 extern struct radio_20xx_regs regs_2057_rev4[], regs_2057_rev5[],
-	      regs_2057_rev5v1[];
+			      regs_2057_rev5v1[];
 extern struct radio_20xx_regs regs_2057_rev7[], regs_2057_rev8[];
 
 extern char *phy_getvar(struct brcms_phy *pi, const char *name);
 extern int phy_getintvar(struct brcms_phy *pi, const char *name);
-#define PHY_GETVAR(pi, name)	phy_getvar(pi, name)
-#define PHY_GETINTVAR(pi, name)	phy_getintvar(pi, name)
+
+#define PHY_GETVAR(pi, name)    phy_getvar(pi, name)
+#define PHY_GETINTVAR(pi, name) phy_getintvar(pi, name)
 
 extern u16 read_phy_reg(struct brcms_phy *pi, u16 addr);
 extern void write_phy_reg(struct brcms_phy *pi, u16 addr, u16 val);
@@ -1131,13 +1159,17 @@ extern void wlc_phy_stay_in_carriersearch_nphy(struct brcms_phy *pi,
 					       bool enable);
 extern void wlc_nphy_deaf_mode(struct brcms_phy *pi, bool mode);
 
-#define wlc_phy_write_table_nphy(pi, pti)	wlc_phy_write_table(pi, pti, 0x72, \
-	0x74, 0x73)
-#define wlc_phy_read_table_nphy(pi, pti)	wlc_phy_read_table(pi, pti, 0x72, \
-	0x74, 0x73)
-#define wlc_nphy_table_addr(pi, id, off)	wlc_phy_table_addr((pi), (id), (off), \
-	0x72, 0x74, 0x73)
-#define wlc_nphy_table_data_write(pi, w, v)	wlc_phy_table_data_write((pi), (w), (v))
+#define wlc_phy_write_table_nphy(pi, pti) \
+	wlc_phy_write_table(pi, pti, 0x72, 0x74, 0x73)
+
+#define wlc_phy_read_table_nphy(pi, pti) \
+	wlc_phy_read_table(pi, pti, 0x72, 0x74, 0x73)
+
+#define wlc_nphy_table_addr(pi, id, off) \
+	wlc_phy_table_addr((pi), (id), (off), 0x72, 0x74, 0x73)
+
+#define wlc_nphy_table_data_write(pi, w, v) \
+	wlc_phy_table_data_write((pi), (w), (v))
 
 extern void wlc_phy_table_read_nphy(struct brcms_phy *pi, u32, u32 l, u32 o,
 				    u32 w, void *d);
@@ -1218,7 +1250,7 @@ extern void wlc_phy_nphy_tkip_rifs_war(struct brcms_phy *pi, u8 rifs);
 void wlc_phy_get_pwrdet_offsets(struct brcms_phy *pi, s8 *cckoffset,
 				s8 *ofdmoffset);
 extern s8 wlc_phy_upd_rssi_offset(struct brcms_phy *pi, s8 rssi,
-				    u16 chanspec);
+				  u16 chanspec);
 
 extern bool wlc_phy_n_txpower_ipa_ison(struct brcms_phy *pih);
 #endif				/* _BRCM_PHY_INT_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
index d64a98f..a109866 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -79,15 +79,15 @@
 
 #define wlc_lcnphy_enable_tx_gain_override(pi) \
 	wlc_lcnphy_set_tx_gain_override(pi, true)
-#define wlc_lcnphy_disable_tx_gain_override(pi) \
+#define wlc_lcnphy_disable_tx_gain_override(pi)	\
 	wlc_lcnphy_set_tx_gain_override(pi, false)
 
 #define wlc_lcnphy_iqcal_active(pi)	\
 	(read_phy_reg((pi), 0x451) & \
-	((0x1 << 15) | (0x1 << 14)))
+	 ((0x1 << 15) | (0x1 << 14)))
 
 #define txpwrctrl_off(pi) (0x7 != ((read_phy_reg(pi, 0x4a4) & 0xE000) >> 13))
-#define wlc_lcnphy_tempsense_based_pwr_ctrl_enabled(pi) \
+#define wlc_lcnphy_tempsense_based_pwr_ctrl_enabled(pi)	\
 	(pi->temppwrctrl_capable)
 #define wlc_lcnphy_tssi_based_pwr_ctrl_enabled(pi) \
 	(pi->hwpwrctrl_capable)
@@ -132,12 +132,12 @@
 #define LCNPHY_ACI_DETECT_TIMEOUT  2
 #define LCNPHY_ACI_START_DELAY 0
 
-#define wlc_lcnphy_tx_gain_override_enabled(pi) \
+#define wlc_lcnphy_tx_gain_override_enabled(pi)	\
 	(0 != (read_phy_reg((pi), 0x43b) & (0x1 << 6)))
 
 #define wlc_lcnphy_total_tx_frames(pi) \
-	wlapi_bmac_read_shm((pi)->sh->physhim, \
-		M_UCODE_MACSTAT + offsetof(struct macstat, txallfrm))
+	wlapi_bmac_read_shm((pi)->sh->physhim, M_UCODE_MACSTAT + \
+			    offsetof(struct macstat, txallfrm))
 
 struct lcnphy_txgains {
 	u16 gm_gain;
@@ -198,7 +198,7 @@ static const iqcal_gain_params_lcnphy *tbl_iqcal_gainparams_lcnphy[1] = {
 
 static const u16 iqcal_gainparams_numgains_lcnphy[1] = {
 	sizeof(tbl_iqcal_gainparams_lcnphy_2G) /
-	    sizeof(*tbl_iqcal_gainparams_lcnphy_2G),
+	sizeof(*tbl_iqcal_gainparams_lcnphy_2G),
 };
 
 static const struct lcnphy_sfo_cfg lcnphy_sfo_cfg[] = {
@@ -920,47 +920,52 @@ u16 LCNPHY_txdigfiltcoeffs_ofdm[LCNPHY_NUM_TX_DIG_FILTERS_OFDM]
 
 #define wlc_lcnphy_set_start_tx_pwr_idx(pi, idx) \
 	mod_phy_reg(pi, 0x4a4, \
-		(0x1ff << 0), \
-		(u16)(idx) << 0)
+		    (0x1ff << 0), \
+		    (u16)(idx) << 0)
 
 #define wlc_lcnphy_set_tx_pwr_npt(pi, npt) \
 	mod_phy_reg(pi, 0x4a5, \
-		(0x7 << 8), \
-		(u16)(npt) << 8)
+		    (0x7 << 8),	\
+		    (u16)(npt) << 8)
 
 #define wlc_lcnphy_get_tx_pwr_ctrl(pi) \
 	(read_phy_reg((pi), 0x4a4) & \
-			((0x1 << 15) | \
-			(0x1 << 14) | \
-			(0x1 << 13)))
+	 ((0x1 << 15) |	\
+	  (0x1 << 14) |	\
+	  (0x1 << 13)))
 
 #define wlc_lcnphy_get_tx_pwr_npt(pi) \
 	((read_phy_reg(pi, 0x4a5) & \
-		(0x7 << 8)) >> \
-		8)
+	  (0x7 << 8)) >> \
+	 8)
 
 #define wlc_lcnphy_get_current_tx_pwr_idx_if_pwrctrl_on(pi) \
 	(read_phy_reg(pi, 0x473) & 0x1ff)
 
 #define wlc_lcnphy_get_target_tx_pwr(pi) \
 	((read_phy_reg(pi, 0x4a7) & \
-		(0xff << 0)) >> \
-		0)
+	  (0xff << 0)) >> \
+	 0)
 
 #define wlc_lcnphy_set_target_tx_pwr(pi, target) \
 	mod_phy_reg(pi, 0x4a7, \
-		(0xff << 0), \
-		(u16)(target) << 0)
+		    (0xff << 0), \
+		    (u16)(target) << 0)
 
-#define wlc_radio_2064_rcal_done(pi) (0 != (read_radio_reg(pi, RADIO_2064_REG05C) & 0x20))
-#define tempsense_done(pi) (0x8000 == (read_phy_reg(pi, 0x476) & 0x8000))
+#define wlc_radio_2064_rcal_done(pi) \
+	(0 != (read_radio_reg(pi, RADIO_2064_REG05C) & 0x20))
+
+#define tempsense_done(pi) \
+	(0x8000 == (read_phy_reg(pi, 0x476) & 0x8000))
+
+#define LCNPHY_IQLOCC_READ(val) \
+	((u8)(-(s8)(((val) & 0xf0) >> 4) + (s8)((val) & 0x0f)))
 
-#define LCNPHY_IQLOCC_READ(val) ((u8)(-(s8)(((val) & 0xf0) >> 4) + (s8)((val) & 0x0f)))
 #define FIXED_TXPWR 78
 #define LCNPHY_TEMPSENSE(val) ((s16)((val > 255) ? (val - 512) : val))
 
 static u32 wlc_lcnphy_qdiv_roundup(u32 divident, u32 divisor,
-				      u8 precision);
+				   u8 precision);
 static void wlc_lcnphy_set_rx_gain_by_distribution(struct brcms_phy *pi,
 						   u16 ext_lna, u16 trsw,
 						   u16 biq2, u16 biq1,
@@ -989,8 +994,10 @@ static void wlc_lcnphy_tx_pwr_ctrl_init(struct brcms_phy_pub *ppi);
 static void wlc_lcnphy_radio_2064_channel_tune_4313(struct brcms_phy *pi,
 						    u8 channel);
 
-static void wlc_lcnphy_load_tx_gain_table(struct brcms_phy *pi,
-				  const struct lcnphy_tx_gain_tbl_entry *g);
+static void wlc_lcnphy_load_tx_gain_table(
+	struct brcms_phy *pi,
+	const struct lcnphy_tx_gain_tbl_entry
+	*g);
 
 static void wlc_lcnphy_samp_cap(struct brcms_phy *pi, int clip_detect_algo,
 				u16 thresh, s16 *ptr, int mode);
@@ -1115,9 +1122,8 @@ s8 wlc_lcnphy_get_current_tx_pwr_idx(struct brcms_phy *pi)
 	if (txpwrctrl_off(pi))
 		index = pi_lcn->lcnphy_current_index;
 	else if (wlc_lcnphy_tssi_based_pwr_ctrl_enabled(pi))
-		index =
-		    (s8) (wlc_lcnphy_get_current_tx_pwr_idx_if_pwrctrl_on(pi)
-			    / 2);
+		index =	(s8) (wlc_lcnphy_get_current_tx_pwr_idx_if_pwrctrl_on(
+			      pi) / 2);
 	else
 		index = pi_lcn->lcnphy_current_index;
 	return index;
@@ -1265,7 +1271,7 @@ static u16 wlc_lcnphy_get_pa_gain(struct brcms_phy *pi)
 
 	pa_gain = (read_phy_reg(pi, 0x4fb) &
 		   LCNPHY_txgainctrlovrval1_pagain_ovr_val1_MASK) >>
-	    LCNPHY_txgainctrlovrval1_pagain_ovr_val1_SHIFT;
+		  LCNPHY_txgainctrlovrval1_pagain_ovr_val1_SHIFT;
 
 	return pa_gain;
 }
@@ -1275,18 +1281,22 @@ static void wlc_lcnphy_set_tx_gain(struct brcms_phy *pi,
 {
 	u16 pa_gain = wlc_lcnphy_get_pa_gain(pi);
 
-	mod_phy_reg(pi, 0x4b5,
-		    (0xffff << 0),
-		    ((target_gains->gm_gain) | (target_gains->pga_gain << 8)) <<
-		    0);
+	mod_phy_reg(
+		pi, 0x4b5,
+		(0xffff << 0),
+		((target_gains->gm_gain) |
+		 (target_gains->pga_gain << 8)) <<
+		0);
 	mod_phy_reg(pi, 0x4fb,
 		    (0x7fff << 0),
 		    ((target_gains->pad_gain) | (pa_gain << 8)) << 0);
 
-	mod_phy_reg(pi, 0x4fc,
-		    (0xffff << 0),
-		    ((target_gains->gm_gain) | (target_gains->pga_gain << 8)) <<
-		    0);
+	mod_phy_reg(
+		pi, 0x4fc,
+		(0xffff << 0),
+		((target_gains->gm_gain) |
+		 (target_gains->pga_gain << 8)) <<
+		0);
 	mod_phy_reg(pi, 0x4fd,
 		    (0x7fff << 0),
 		    ((target_gains->pad_gain) | (pa_gain << 8)) << 0);
@@ -1404,8 +1414,8 @@ static void wlc_lcnphy_pwrctrl_rssiparams(struct brcms_phy *pi)
 	u16 auxpga_vmid, auxpga_vmid_temp, auxpga_gain_temp;
 	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
-	auxpga_vmid =
-	    (2 << 8) | (pi_lcn->lcnphy_rssi_vc << 4) | pi_lcn->lcnphy_rssi_vf;
+	auxpga_vmid = (2 << 8) |
+		      (pi_lcn->lcnphy_rssi_vc << 4) | pi_lcn->lcnphy_rssi_vf;
 	auxpga_vmid_temp = (2 << 8) | (8 << 4) | 4;
 	auxpga_gain_temp = 2;
 
@@ -1600,7 +1610,7 @@ void wlc_lcnphy_txpower_recalc_target(struct brcms_phy *pi)
 {
 	struct phytbl_info tab;
 	u32 rate_table[BRCMS_NUM_RATES_CCK + BRCMS_NUM_RATES_OFDM +
-			  BRCMS_NUM_RATES_MCS_1_STREAM];
+		       BRCMS_NUM_RATES_MCS_1_STREAM];
 	uint i, j;
 	if (wlc_lcnphy_tempsense_based_pwr_ctrl_enabled(pi))
 		return;
@@ -1715,9 +1725,9 @@ static s8 wlc_lcnphy_tempcompensated_txpwrctrl(struct brcms_phy *pi)
 	}
 
 	delta_temp = (s8) wlc_lcnphy_qdiv_roundup((u32) (temp_diff * 192),
-						    (u32) (pi_lcn->
-							      lcnphy_tempsense_slope
-							      * 10), 0);
+						  (u32) (pi_lcn->
+							 lcnphy_tempsense_slope
+							 * 10), 0);
 	if (neg)
 		delta_temp = -delta_temp;
 
@@ -1731,7 +1741,7 @@ static s8 wlc_lcnphy_tempcompensated_txpwrctrl(struct brcms_phy *pi)
 	if (LCNREV_IS(pi->pubpi.phy_rev, 1))
 		tempcorrx = 4;
 	new_index =
-	    index + delta_brd + delta_temp - pi_lcn->lcnphy_bandedge_corr;
+		index + delta_brd + delta_temp - pi_lcn->lcnphy_bandedge_corr;
 	new_index += tempcorrx;
 
 	if (LCNREV_IS(pi->pubpi.phy_rev, 1))
@@ -1789,7 +1799,7 @@ void wlc_lcnphy_set_tx_pwr_ctrl(struct brcms_phy *pi, u16 mode)
 			mod_radio_reg(pi, RADIO_2064_REG11F, 0x4, 0);
 
 			pi_lcn->lcnphy_tssi_tx_cnt =
-			    wlc_lcnphy_total_tx_frames(pi);
+				wlc_lcnphy_total_tx_frames(pi);
 
 			wlc_lcnphy_disable_tx_gain_override(pi);
 			pi_lcn->lcnphy_tx_power_idx_override = -1;
@@ -1802,7 +1812,9 @@ void wlc_lcnphy_set_tx_pwr_ctrl(struct brcms_phy *pi, u16 mode)
 			index = wlc_lcnphy_tempcompensated_txpwrctrl(pi);
 			wlc_lcnphy_set_tx_pwr_soft_ctrl(pi, index);
 			pi_lcn->lcnphy_current_index = (s8)
-			    ((read_phy_reg(pi, 0x4a9) & 0xFF) / 2);
+						       ((read_phy_reg(pi,
+								      0x4a9) &
+							 0xFF) / 2);
 		}
 	}
 }
@@ -1834,20 +1846,23 @@ wlc_lcnphy_tx_iqlo_cal(struct brcms_phy *pi,
 	int j;
 	u16 ncorr_override[5];
 	u16 syst_coeffs[] = { 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
-		0x0000, 0x0000, 0x0000, 0x0000, 0x0000
-	};
+			      0x0000, 0x0000, 0x0000, 0x0000, 0x0000};
 
 	u16 commands_fullcal[] = {
-		0x8434, 0x8334, 0x8084, 0x8267, 0x8056, 0x8234 };
+		0x8434, 0x8334, 0x8084, 0x8267, 0x8056, 0x8234
+	};
 
 	u16 commands_recal[] = {
-		0x8434, 0x8334, 0x8084, 0x8267, 0x8056, 0x8234 };
+		0x8434, 0x8334, 0x8084, 0x8267, 0x8056, 0x8234
+	};
 
 	u16 command_nums_fullcal[] = {
-		0x7a97, 0x7a97, 0x7a97, 0x7a87, 0x7a87, 0x7b97 };
+		0x7a97, 0x7a97, 0x7a97, 0x7a87, 0x7a87, 0x7b97
+	};
 
 	u16 command_nums_recal[] = {
-		0x7a97, 0x7a97, 0x7a97, 0x7a87, 0x7a87, 0x7b97 };
+		0x7a97, 0x7a97, 0x7a97, 0x7a87, 0x7a87, 0x7b97
+	};
 	u16 *command_nums = command_nums_fullcal;
 
 	u16 *start_coeffs = NULL, *cal_cmds = NULL, cal_type, diq_start;
@@ -1923,7 +1938,7 @@ wlc_lcnphy_tx_iqlo_cal(struct brcms_phy *pi,
 	}
 
 	hash = (target_gains->gm_gain << 8) |
-	    (target_gains->pga_gain << 4) | (target_gains->pad_gain);
+	       (target_gains->pga_gain << 4) | (target_gains->pad_gain);
 
 	band_idx = (CHSPEC_IS5G(pi->radio_chanspec) ? 1 : 0);
 
@@ -1932,11 +1947,11 @@ wlc_lcnphy_tx_iqlo_cal(struct brcms_phy *pi,
 	for (j = 0; j < iqcal_gainparams_numgains_lcnphy[band_idx]; j++) {
 		if (hash == tbl_iqcal_gainparams_lcnphy[band_idx][j][0]) {
 			cal_gains.gm_gain =
-			    tbl_iqcal_gainparams_lcnphy[band_idx][j][1];
+				tbl_iqcal_gainparams_lcnphy[band_idx][j][1];
 			cal_gains.pga_gain =
-			    tbl_iqcal_gainparams_lcnphy[band_idx][j][2];
+				tbl_iqcal_gainparams_lcnphy[band_idx][j][2];
 			cal_gains.pad_gain =
-			    tbl_iqcal_gainparams_lcnphy[band_idx][j][3];
+				tbl_iqcal_gainparams_lcnphy[band_idx][j][3];
 			memcpy(ncorr_override,
 			       &tbl_iqcal_gainparams_lcnphy[band_idx][j][3],
 			       sizeof(ncorr_override));
@@ -1957,7 +1972,8 @@ wlc_lcnphy_tx_iqlo_cal(struct brcms_phy *pi,
 
 	wlc_lcnphy_common_write_table(pi, LCNPHY_TBL_ID_IQLOCAL,
 				      (const void *)lcnphy_iqcal_ir_gainladder,
-				      ARRAY_SIZE(lcnphy_iqcal_ir_gainladder), 16,
+				      ARRAY_SIZE(
+					      lcnphy_iqcal_ir_gainladder), 16,
 				      32);
 
 	if (pi->phy_tx_tone_freq) {
@@ -1981,8 +1997,8 @@ wlc_lcnphy_tx_iqlo_cal(struct brcms_phy *pi,
 		command_num = command_nums[i];
 		if (ncorr_override[cal_type])
 			command_num =
-			    ncorr_override[cal_type] << 8 | (command_num &
-							     0xff);
+				ncorr_override[cal_type] << 8 | (command_num &
+								 0xff);
 
 		write_phy_reg(pi, 0x452, command_num);
 
@@ -2013,8 +2029,8 @@ wlc_lcnphy_tx_iqlo_cal(struct brcms_phy *pi,
 					     pi_lcn->lcnphy_cal_results.
 					     txiqlocal_bestcoeffs,
 					     ARRAY_SIZE(pi_lcn->
-						       lcnphy_cal_results.
-						       txiqlocal_bestcoeffs),
+							lcnphy_cal_results.
+							txiqlocal_bestcoeffs),
 					     16, 96);
 	}
 
@@ -2022,7 +2038,7 @@ wlc_lcnphy_tx_iqlo_cal(struct brcms_phy *pi,
 				     pi_lcn->lcnphy_cal_results.
 				     txiqlocal_bestcoeffs,
 				     ARRAY_SIZE(pi_lcn->lcnphy_cal_results.
-					       txiqlocal_bestcoeffs), 16, 96);
+						txiqlocal_bestcoeffs), 16, 96);
 	pi_lcn->lcnphy_cal_results.txiqlocal_bestcoeffs_valid = true;
 
 	wlc_lcnphy_common_write_table(pi, LCNPHY_TBL_ID_IQLOCAL,
@@ -2033,7 +2049,7 @@ wlc_lcnphy_tx_iqlo_cal(struct brcms_phy *pi,
 				      &pi_lcn->lcnphy_cal_results.
 				      txiqlocal_bestcoeffs[5], 2, 16, 85);
 
- cleanup:
+cleanup:
 	wlc_lcnphy_tx_iqlo_loopback_cleanup(pi, values_to_save);
 	kfree(values_to_save);
 
@@ -2063,14 +2079,14 @@ static void wlc_lcnphy_idle_tssi_est(struct brcms_phy_pub *ppi)
 	u16 SAVE_txpwrctrl = wlc_lcnphy_get_tx_pwr_ctrl(pi);
 	u16 SAVE_lpfgain = read_radio_reg(pi, RADIO_2064_REG112);
 	u16 SAVE_jtag_bb_afe_switch =
-	    read_radio_reg(pi, RADIO_2064_REG007) & 1;
+		read_radio_reg(pi, RADIO_2064_REG007) & 1;
 	u16 SAVE_jtag_auxpga = read_radio_reg(pi, RADIO_2064_REG0FF) & 0x10;
 	u16 SAVE_iqadc_aux_en = read_radio_reg(pi, RADIO_2064_REG11F) & 4;
 	idleTssi = read_phy_reg(pi, 0x4ab);
 	suspend =
-	    (0 ==
-	     (R_REG(&((struct brcms_phy *) pi)->regs->maccontrol) &
-	      MCTL_EN_MAC));
+		(0 ==
+		 (R_REG(&((struct brcms_phy *) pi)->regs->maccontrol) &
+		  MCTL_EN_MAC));
 	if (!suspend)
 		wlapi_suspend_mac_and_wait(pi->sh->physhim);
 	wlc_lcnphy_set_tx_pwr_ctrl(pi, LCNPHY_TX_PWR_CTRL_OFF);
@@ -2128,7 +2144,7 @@ static void wlc_lcnphy_vbat_temp_sense_setup(struct brcms_phy *pi, u8 mode)
 	struct phytbl_info tab;
 	u32 val;
 	u8 save_reg007, save_reg0FF, save_reg11F, save_reg005, save_reg025,
-	    save_reg112;
+	   save_reg112;
 	u16 values_to_save[14];
 	s8 index;
 	int i;
@@ -2144,8 +2160,7 @@ static void wlc_lcnphy_vbat_temp_sense_setup(struct brcms_phy *pi, u8 mode)
 
 	for (i = 0; i < 14; i++)
 		values_to_save[i] = read_phy_reg(pi, tempsense_phy_regs[i]);
-	suspend =
-	    (0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
+	suspend = (0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
 	if (!suspend)
 		wlapi_suspend_mac_and_wait(pi->sh->physhim);
 	save_txpwrCtrlEn = read_radio_reg(pi, 0x4a4);
@@ -2228,7 +2243,7 @@ static void wlc_lcnphy_vbat_temp_sense_setup(struct brcms_phy *pi, u8 mode)
 		auxpga_gain = 2;
 	}
 	auxpga_vmid =
-	    (u16) ((2 << 8) | (auxpga_vmidcourse << 4) | auxpga_vmidfine);
+		(u16) ((2 << 8) | (auxpga_vmidcourse << 4) | auxpga_vmidfine);
 	mod_phy_reg(pi, 0x4d8, (0x1 << 0), (1) << 0);
 
 	mod_phy_reg(pi, 0x4d8, (0x3ff << 2), (auxpga_vmid) << 2);
@@ -2272,7 +2287,7 @@ static void wlc_lcnphy_tx_pwr_ctrl_init(struct brcms_phy_pub *ppi)
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
 	suspend =
-	    (0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
+		(0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
 	if (!suspend)
 		wlapi_suspend_mac_and_wait(pi->sh->physhim);
 
@@ -2522,9 +2537,10 @@ wlc_lcnphy_set_rx_gain_by_distribution(struct brcms_phy *pi,
 
 	gain16_19 = biq2 & 0xf;
 	gain0_15 = ((biq1 & 0xf) << 12) |
-	    ((tia & 0xf) << 8) |
-	    ((lna2 & 0x3) << 6) |
-	    ((lna2 & 0x3) << 4) | ((lna1 & 0x3) << 2) | ((lna1 & 0x3) << 0);
+		   ((tia & 0xf) << 8) |
+		   ((lna2 & 0x3) << 6) |
+		   ((lna2 &
+		     0x3) << 4) | ((lna1 & 0x3) << 2) | ((lna1 & 0x3) << 0);
 
 	mod_phy_reg(pi, 0x4b6, (0xffff << 0), gain0_15 << 0);
 	mod_phy_reg(pi, 0x4b7, (0xf << 0), gain16_19 << 0);
@@ -2581,9 +2597,9 @@ void wlc_lcnphy_tx_pu(struct brcms_phy *pi, bool bEnable)
 
 		and_phy_reg(pi, 0x44c,
 			    ~(u16) ((0x1 << 3) |
-				       (0x1 << 5) |
-				       (0x1 << 12) |
-				       (0x1 << 0) | (0x1 << 1) | (0x1 << 2)));
+				    (0x1 << 5) |
+				    (0x1 << 12) |
+				    (0x1 << 0) | (0x1 << 1) | (0x1 << 2)));
 
 		and_phy_reg(pi, 0x44d,
 			    ~(u16) ((0x1 << 3) | (0x1 << 5) | (0x1 << 14)));
@@ -2693,7 +2709,8 @@ void wlc_lcnphy_deaf_mode(struct brcms_phy *pi, bool mode)
 		mod_phy_reg((pi), 0x410,
 			    (0x1 << 6) |
 			    (0x1 << 5),
-			    ((CHSPEC_IS2G(pi->radio_chanspec)) ? (!mode) : 0) <<
+			    ((CHSPEC_IS2G(
+				      pi->radio_chanspec)) ? (!mode) : 0) <<
 			    6 | (!mode) << 5);
 		mod_phy_reg(pi, 0x410, (0x1 << 7), (mode) << 7);
 	}
@@ -2916,7 +2933,7 @@ static void wlc_lcnphy_txpwrtbl_iqlo_cal(struct brcms_phy *pi)
 
 		wlc_lcnphy_read_table(pi, &tab);
 		val = (val & 0xfff00000) |
-		    ((u32) (a & 0x3FF) << 10) | (b & 0x3ff);
+		      ((u32) (a & 0x3FF) << 10) | (b & 0x3ff);
 		wlc_lcnphy_write_table(pi, &tab);
 
 		val = didq;
@@ -2953,8 +2970,8 @@ s16 wlc_lcnphy_tempsense_new(struct brcms_phy *pi, bool mode)
 
 	if (mode == 1) {
 		suspend =
-		    (0 ==
-		     (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
+			(0 ==
+			 (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
 		if (!suspend)
 			wlapi_suspend_mac_and_wait(pi->sh->physhim);
 		wlc_lcnphy_vbat_temp_sense_setup(pi, TEMPSENSE);
@@ -3000,8 +3017,8 @@ u16 wlc_lcnphy_tempsense(struct brcms_phy *pi, bool mode)
 
 	if (mode == 1) {
 		suspend =
-		    (0 ==
-		     (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
+			(0 ==
+			 (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
 		if (!suspend)
 			wlapi_suspend_mac_and_wait(pi->sh->physhim);
 		wlc_lcnphy_vbat_temp_sense_setup(pi, TEMPSENSE);
@@ -3052,8 +3069,9 @@ s8 wlc_lcnphy_tempsense_degree(struct brcms_phy *pi, bool mode)
 {
 	s32 degree = wlc_lcnphy_tempsense_new(pi, mode);
 	degree =
-	    ((degree << 10) + LCN_TEMPSENSE_OFFSET + (LCN_TEMPSENSE_DEN >> 1))
-	    / LCN_TEMPSENSE_DEN;
+		((degree <<
+		  10) + LCN_TEMPSENSE_OFFSET + (LCN_TEMPSENSE_DEN >> 1))
+		/ LCN_TEMPSENSE_DEN;
 	return (s8) degree;
 }
 
@@ -3068,8 +3086,8 @@ s8 wlc_lcnphy_vbatsense(struct brcms_phy *pi, bool mode)
 
 	if (mode == 1) {
 		suspend =
-		    (0 ==
-		     (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
+			(0 ==
+			 (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
 		if (!suspend)
 			wlapi_suspend_mac_and_wait(pi->sh->physhim);
 		wlc_lcnphy_vbat_temp_sense_setup(pi, VBATSENSE);
@@ -3082,9 +3100,8 @@ s8 wlc_lcnphy_vbatsense(struct brcms_phy *pi, bool mode)
 	else
 		avg = (s32) vbatsenseval;
 
-	avg =
-	    (avg * LCN_VBAT_SCALE_NOM +
-	     (LCN_VBAT_SCALE_DEN >> 1)) / LCN_VBAT_SCALE_DEN;
+	avg =	(avg * LCN_VBAT_SCALE_NOM +
+		 (LCN_VBAT_SCALE_DEN >> 1)) / LCN_VBAT_SCALE_DEN;
 
 	if (mode == 1) {
 		if (!suspend)
@@ -3140,13 +3157,13 @@ wlc_lcnphy_rx_iq_est(struct brcms_phy *pi,
 	}
 
 	iq_est->iq_prod = ((u32) read_phy_reg(pi, 0x483) << 16) |
-	    (u32) read_phy_reg(pi, 0x484);
+			  (u32) read_phy_reg(pi, 0x484);
 	iq_est->i_pwr = ((u32) read_phy_reg(pi, 0x485) << 16) |
-	    (u32) read_phy_reg(pi, 0x486);
+			(u32) read_phy_reg(pi, 0x486);
 	iq_est->q_pwr = ((u32) read_phy_reg(pi, 0x487) << 16) |
-	    (u32) read_phy_reg(pi, 0x488);
+			(u32) read_phy_reg(pi, 0x488);
 
- cleanup:
+cleanup:
 	mod_phy_reg(pi, 0x410, (0x1 << 3), (1) << 3);
 
 	mod_phy_reg(pi, 0x6da, (0x1 << 5), (0) << 5);
@@ -3221,7 +3238,7 @@ static bool wlc_lcnphy_calc_rx_iq_comp(struct brcms_phy *pi, u16 num_samps)
 	b -= (1 << 10);
 	a0_new = (u16) (a & 0x3ff);
 	b0_new = (u16) (b & 0x3ff);
- cleanup:
+cleanup:
 
 	wlc_lcnphy_set_rx_iq_comp(pi, a0_new, b0_new);
 
@@ -3282,7 +3299,7 @@ wlc_lcnphy_rx_iq_cal(struct brcms_phy *pi,
 
 		for (i = 0; i < 11; i++)
 			values_to_save[i] =
-			    read_radio_reg(pi, rxiq_cal_rf_reg[i]);
+				read_radio_reg(pi, rxiq_cal_rf_reg[i]);
 		Core1TxControl_old = read_phy_reg(pi, 0x631);
 
 		or_phy_reg(pi, 0x631, 0x0015);
@@ -3356,7 +3373,7 @@ wlc_lcnphy_rx_iq_cal(struct brcms_phy *pi,
 			udelay(500);
 
 			received_power =
-			    wlc_lcnphy_measure_digital_power(pi, 2000);
+				wlc_lcnphy_measure_digital_power(pi, 2000);
 			if (received_power < rx_pwr_threshold)
 				break;
 		}
@@ -3396,7 +3413,7 @@ wlc_lcnphy_rx_iq_cal(struct brcms_phy *pi,
 		wlc_lcnphy_rx_gain_override_enable(pi, false);
 	}
 
- cal_done:
+cal_done:
 	kfree(ptr);
 	return result;
 }
@@ -3414,7 +3431,7 @@ static void wlc_lcnphy_glacial_timer_based_cal(struct brcms_phy *pi)
 	u16 SAVE_pwrctrl = wlc_lcnphy_get_tx_pwr_ctrl(pi);
 	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 	suspend =
-	    (0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
+		(0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
 	if (!suspend)
 		wlapi_suspend_mac_and_wait(pi->sh->physhim);
 	wlc_lcnphy_deaf_mode(pi, true);
@@ -3450,13 +3467,13 @@ static void wlc_lcnphy_periodic_cal(struct brcms_phy *pi)
 	pi->phy_lastcal = pi->sh->now;
 	pi->phy_forcecal = false;
 	full_cal =
-	    (pi_lcn->lcnphy_full_cal_channel !=
-	     CHSPEC_CHANNEL(pi->radio_chanspec));
+		(pi_lcn->lcnphy_full_cal_channel !=
+		 CHSPEC_CHANNEL(pi->radio_chanspec));
 	pi_lcn->lcnphy_full_cal_channel = CHSPEC_CHANNEL(pi->radio_chanspec);
 	index = pi_lcn->lcnphy_current_index;
 
 	suspend =
-	    (0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
+		(0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
 	if (!suspend) {
 		wlapi_bmac_write_shm(pi->sh->physhim, M_CTS_DURATION, 10000);
 		wlapi_suspend_mac_and_wait(pi->sh->physhim);
@@ -3538,7 +3555,7 @@ void wlc_lcnphy_calib_modes(struct brcms_phy *pi, uint mode)
 	case LCNPHY_PERICAL_TEMPBASED_TXPWRCTRL:
 		if (wlc_lcnphy_tempsense_based_pwr_ctrl_enabled(pi))
 			wlc_lcnphy_tx_power_adjustment(
-						(struct brcms_phy_pub *) pi);
+				(struct brcms_phy_pub *) pi);
 		break;
 	}
 }
@@ -3551,7 +3568,7 @@ void wlc_lcnphy_get_tssi(struct brcms_phy *pi, s8 *ofdm_pwr, s8 *cck_pwr)
 	if (wlc_lcnphy_tssi_based_pwr_ctrl_enabled(pi) &&
 	    (status  & (0x1 << 15))) {
 		*ofdm_pwr = (s8) (((read_phy_reg(pi, 0x4ab) & (0x1ff << 0))
-				     >> 0) >> 1);
+				   >> 0) >> 1);
 
 		if (wlc_phy_tpc_isenabled_lcnphy(pi))
 			cck_offset = pi->tx_power_offset[TXP_FIRST_CCK];
@@ -3629,13 +3646,14 @@ void wlc_lcnphy_tx_power_adjustment(struct brcms_phy_pub *ppi)
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 	u16 SAVE_txpwrctrl = wlc_lcnphy_get_tx_pwr_ctrl(pi);
-	if (wlc_lcnphy_tempsense_based_pwr_ctrl_enabled(pi) && SAVE_txpwrctrl) {
+	if (wlc_lcnphy_tempsense_based_pwr_ctrl_enabled(pi) &&
+	    SAVE_txpwrctrl) {
 		index = wlc_lcnphy_tempcompensated_txpwrctrl(pi);
 		index2 = (u16) (index * 2);
 		mod_phy_reg(pi, 0x4a9, (0x1ff << 0), (index2) << 0);
 
-		pi_lcn->lcnphy_current_index = (s8)
-		    ((read_phy_reg(pi, 0x4a9) & 0xFF) / 2);
+		pi_lcn->lcnphy_current_index =
+			(s8)((read_phy_reg(pi, 0x4a9) & 0xFF) / 2);
 	}
 }
 
@@ -3711,7 +3729,7 @@ wlc_lcnphy_tx_iqlo_loopback(struct brcms_phy *pi, u16 *values_to_save)
 	int i;
 	for (i = 0; i < 20; i++)
 		values_to_save[i] =
-		    read_radio_reg(pi, iqlo_loopback_rf_regs[i]);
+			read_radio_reg(pi, iqlo_loopback_rf_regs[i]);
 
 	mod_phy_reg(pi, 0x44c, (0x1 << 12), 1 << 12);
 	mod_phy_reg(pi, 0x44d, (0x1 << 14), 1 << 14);
@@ -4140,8 +4158,8 @@ wlc_lcnphy_a1(struct brcms_phy *pi, int cal_type, int num_levels,
 
 				phy_c18 = phy_c18 >> 10;
 				phy_c19 = phy_c19 >> 10;
-				phy_c20 =
-				    ((phy_c18 * phy_c18) + (phy_c19 * phy_c19));
+				phy_c20 = ((phy_c18 * phy_c18) +
+					   (phy_c19 * phy_c19));
 
 				if (phy_c23 || phy_c20 < phy_c21) {
 					phy_c21 = phy_c20;
@@ -4159,7 +4177,7 @@ wlc_lcnphy_a1(struct brcms_phy *pi, int cal_type, int num_levels,
 		udelay(20);
 	}
 	goto cleanup;
- cleanup:
+cleanup:
 	wlc_lcnphy_tx_iqlo_loopback_cleanup(pi, phy_c32);
 	wlc_lcnphy_stop_tx_tone(pi);
 	write_phy_reg(pi, 0x6da, phy_c26);
@@ -4189,7 +4207,8 @@ wlc_lcnphy_tx_iqlo_loopback_cleanup(struct brcms_phy *pi, u16 *values_to_save)
 
 static void
 wlc_lcnphy_load_tx_gain_table(struct brcms_phy *pi,
-			const struct lcnphy_tx_gain_tbl_entry *gain_table) {
+			      const struct lcnphy_tx_gain_tbl_entry *gain_table)
+{
 	u32 j;
 	struct phytbl_info tab;
 	u32 val;
@@ -4313,11 +4332,13 @@ static void wlc_lcnphy_tbl_init(struct brcms_phy *pi)
 
 	if (CHSPEC_IS2G(pi->radio_chanspec)) {
 		if (pi->sh->boardflags & BFL_FEM)
-			wlc_lcnphy_load_tx_gain_table(pi,
-						      dot11lcnphy_2GHz_extPA_gaintable_rev0);
+			wlc_lcnphy_load_tx_gain_table(
+				pi,
+				dot11lcnphy_2GHz_extPA_gaintable_rev0);
 		else
-			wlc_lcnphy_load_tx_gain_table(pi,
-						      dot11lcnphy_2GHz_gaintable_rev0);
+			wlc_lcnphy_load_tx_gain_table(
+				pi,
+				dot11lcnphy_2GHz_gaintable_rev0);
 	}
 
 	if (LCNREV_IS(pi->pubpi.phy_rev, 2)) {
@@ -4326,25 +4347,33 @@ static void wlc_lcnphy_tbl_init(struct brcms_phy *pi)
 			     idx < dot11lcnphytbl_rx_gain_info_2G_rev2_sz;
 			     idx++)
 				if (pi->sh->boardflags & BFL_EXTLNA)
-					wlc_lcnphy_write_table(pi,
-							       &dot11lcnphytbl_rx_gain_info_extlna_2G_rev2
-							       [idx]);
+					wlc_lcnphy_write_table(
+						pi,
+						&
+						dot11lcnphytbl_rx_gain_info_extlna_2G_rev2
+						[idx]);
 				else
-					wlc_lcnphy_write_table(pi,
-							       &dot11lcnphytbl_rx_gain_info_2G_rev2
-							       [idx]);
+					wlc_lcnphy_write_table(
+						pi,
+						&
+						dot11lcnphytbl_rx_gain_info_2G_rev2
+						[idx]);
 		} else {
 			for (idx = 0;
 			     idx < dot11lcnphytbl_rx_gain_info_5G_rev2_sz;
 			     idx++)
 				if (pi->sh->boardflags & BFL_EXTLNA_5GHz)
-					wlc_lcnphy_write_table(pi,
-							       &dot11lcnphytbl_rx_gain_info_extlna_5G_rev2
-							       [idx]);
+					wlc_lcnphy_write_table(
+						pi,
+						&
+						dot11lcnphytbl_rx_gain_info_extlna_5G_rev2
+						[idx]);
 				else
-					wlc_lcnphy_write_table(pi,
-							       &dot11lcnphytbl_rx_gain_info_5G_rev2
-							       [idx]);
+					wlc_lcnphy_write_table(
+						pi,
+						&
+						dot11lcnphytbl_rx_gain_info_5G_rev2
+						[idx]);
 		}
 	}
 
@@ -4353,11 +4382,13 @@ static void wlc_lcnphy_tbl_init(struct brcms_phy *pi)
 		wlc_lcnphy_write_table(pi, &dot11lcn_sw_ctrl_tbl_info_4313_epa);
 	else if (pi->sh->boardflags & BFL_FEM_BT) {
 		if (pi->sh->boardrev < 0x1250)
-			wlc_lcnphy_write_table(pi,
-					       &dot11lcn_sw_ctrl_tbl_info_4313_bt_epa);
+			wlc_lcnphy_write_table(
+				pi,
+				&dot11lcn_sw_ctrl_tbl_info_4313_bt_epa);
 		else
-			wlc_lcnphy_write_table(pi,
-					       &dot11lcn_sw_ctrl_tbl_info_4313_bt_epa_p250);
+			wlc_lcnphy_write_table(
+				pi,
+				&dot11lcn_sw_ctrl_tbl_info_4313_bt_epa_p250);
 	} else
 		wlc_lcnphy_write_table(pi, &dot11lcn_sw_ctrl_tbl_info_4313);
 
@@ -4394,9 +4425,8 @@ static void wlc_lcnphy_rev0_baseband_init(struct brcms_phy *pi)
 	if (0) {
 		afectrl1 = 0;
 		afectrl1 = (u16) ((pi_lcn->lcnphy_rssi_vf) |
-				     (pi_lcn->lcnphy_rssi_vc << 4) | (pi_lcn->
-								      lcnphy_rssi_gs
-								      << 10));
+				  (pi_lcn->lcnphy_rssi_vc << 4) |
+				  (pi_lcn->lcnphy_rssi_gs << 10));
 		write_phy_reg(pi, 0x43e, afectrl1);
 	}
 
@@ -4457,18 +4487,15 @@ static void wlc_lcnphy_agc_temp_init(struct brcms_phy *pi)
 		tableBuffer[1] -= 128;
 	pi_lcn->lcnphy_tr_T_gain_val = tableBuffer[1];
 
-	temp = (s16) (read_phy_reg(pi, 0x434)
-			& (0xff << 0));
+	temp = (s16) (read_phy_reg(pi, 0x434) & (0xff << 0));
 	if (temp > 127)
 		temp -= 256;
 	pi_lcn->lcnphy_input_pwr_offset_db = (s8) temp;
 
-	pi_lcn->lcnphy_Med_Low_Gain_db = (read_phy_reg(pi, 0x424)
-					  & (0xff << 8))
-	    >> 8;
-	pi_lcn->lcnphy_Very_Low_Gain_db = (read_phy_reg(pi, 0x425)
-					   & (0xff << 0))
-	    >> 0;
+	pi_lcn->lcnphy_Med_Low_Gain_db =
+		(read_phy_reg(pi, 0x424) & (0xff << 8)) >> 8;
+	pi_lcn->lcnphy_Very_Low_Gain_db =
+		(read_phy_reg(pi, 0x425) & (0xff << 0)) >> 0;
 
 	tab.tbl_ptr = tableBuffer;
 	tab.tbl_len = 2;
@@ -4659,8 +4686,8 @@ static void wlc_lcnphy_rc_cal(struct brcms_phy *pi)
 	if (LCNREV_IS(pi->pubpi.phy_rev, 1))
 		dflt_rc_cal_val = 11;
 	flt_val =
-	    (dflt_rc_cal_val << 10) | (dflt_rc_cal_val << 5) |
-	    (dflt_rc_cal_val);
+		(dflt_rc_cal_val << 10) | (dflt_rc_cal_val << 5) |
+		(dflt_rc_cal_val);
 	write_phy_reg(pi, 0x933, flt_val);
 	write_phy_reg(pi, 0x934, flt_val);
 	write_phy_reg(pi, 0x935, flt_val);
@@ -4681,10 +4708,10 @@ static bool wlc_phy_txpwr_srom_read_lcnphy(struct brcms_phy *pi)
 		u32 offset_ofdm, offset_mcs;
 
 		pi_lcn->lcnphy_tr_isolation_mid =
-		    (u8) PHY_GETINTVAR(pi, "triso2g");
+			(u8) PHY_GETINTVAR(pi, "triso2g");
 
 		pi_lcn->lcnphy_rx_power_offset =
-		    (u8) PHY_GETINTVAR(pi, "rxpo2g");
+			(u8) PHY_GETINTVAR(pi, "rxpo2g");
 
 		pi->txpa_2g[0] = (s16) PHY_GETINTVAR(pi, "pa0b0");
 		pi->txpa_2g[1] = (s16) PHY_GETINTVAR(pi, "pa0b1");
@@ -4700,11 +4727,11 @@ static bool wlc_phy_txpwr_srom_read_lcnphy(struct brcms_phy *pi)
 			pi_lcn->lcnphy_rssi_gs_lowtemp = pi_lcn->lcnphy_rssi_gs;
 
 			pi_lcn->lcnphy_rssi_vf_hightemp =
-			    pi_lcn->lcnphy_rssi_vf;
+				pi_lcn->lcnphy_rssi_vf;
 			pi_lcn->lcnphy_rssi_vc_hightemp =
-			    pi_lcn->lcnphy_rssi_vc;
+				pi_lcn->lcnphy_rssi_vc;
 			pi_lcn->lcnphy_rssi_gs_hightemp =
-			    pi_lcn->lcnphy_rssi_gs;
+				pi_lcn->lcnphy_rssi_gs;
 		}
 
 		txpwr = (s8) PHY_GETINTVAR(pi, "maxp2ga0");
@@ -4720,15 +4747,16 @@ static bool wlc_phy_txpwr_srom_read_lcnphy(struct brcms_phy *pi)
 			uint max_pwr_chan = txpwr;
 
 			for (i = TXP_FIRST_CCK; i <= TXP_LAST_CCK; i++) {
-				pi->tx_srom_max_rate_2g[i] = max_pwr_chan -
-				    ((cckpo & 0xf) * 2);
+				pi->tx_srom_max_rate_2g[i] =
+					max_pwr_chan - ((cckpo & 0xf) * 2);
 				cckpo >>= 4;
 			}
 
 			offset_ofdm = (u32) PHY_GETINTVAR(pi, "ofdm2gpo");
 			for (i = TXP_FIRST_OFDM; i <= TXP_LAST_OFDM; i++) {
-				pi->tx_srom_max_rate_2g[i] = max_pwr_chan -
-				    ((offset_ofdm & 0xf) * 2);
+				pi->tx_srom_max_rate_2g[i] =
+					max_pwr_chan -
+					((offset_ofdm & 0xf) * 2);
 				offset_ofdm >>= 4;
 			}
 		} else {
@@ -4743,41 +4771,41 @@ static bool wlc_phy_txpwr_srom_read_lcnphy(struct brcms_phy *pi)
 
 			for (i = TXP_FIRST_OFDM; i <= TXP_LAST_OFDM; i++) {
 				pi->tx_srom_max_rate_2g[i] = txpwr -
-				    ((offset_ofdm & 0xf) * 2);
+						((offset_ofdm & 0xf) * 2);
 				offset_ofdm >>= 4;
 			}
 			offset_mcs =
-			    ((u16) PHY_GETINTVAR(pi, "mcs2gpo1") << 16) |
-			    (u16) PHY_GETINTVAR(pi, "mcs2gpo0");
+				((u16) PHY_GETINTVAR(pi, "mcs2gpo1") << 16) |
+				(u16) PHY_GETINTVAR(pi, "mcs2gpo0");
 			pi_lcn->lcnphy_mcs20_po = offset_mcs;
 			for (i = TXP_FIRST_SISO_MCS_20;
 			     i <= TXP_LAST_SISO_MCS_20; i++) {
 				pi->tx_srom_max_rate_2g[i] =
-				    txpwr - ((offset_mcs & 0xf) * 2);
+					txpwr - ((offset_mcs & 0xf) * 2);
 				offset_mcs >>= 4;
 			}
 		}
 
 		pi_lcn->lcnphy_rawtempsense =
-		    (u16) PHY_GETINTVAR(pi, "rawtempsense");
+			(u16) PHY_GETINTVAR(pi, "rawtempsense");
 		pi_lcn->lcnphy_measPower =
-		    (u8) PHY_GETINTVAR(pi, "measpower");
+			(u8) PHY_GETINTVAR(pi, "measpower");
 		pi_lcn->lcnphy_tempsense_slope =
-		    (u8) PHY_GETINTVAR(pi, "tempsense_slope");
+			(u8) PHY_GETINTVAR(pi, "tempsense_slope");
 		pi_lcn->lcnphy_hw_iqcal_en =
-		    (bool) PHY_GETINTVAR(pi, "hw_iqcal_en");
+			(bool) PHY_GETINTVAR(pi, "hw_iqcal_en");
 		pi_lcn->lcnphy_iqcal_swp_dis =
-		    (bool) PHY_GETINTVAR(pi, "iqcal_swp_dis");
+			(bool) PHY_GETINTVAR(pi, "iqcal_swp_dis");
 		pi_lcn->lcnphy_tempcorrx =
-		    (u8) PHY_GETINTVAR(pi, "tempcorrx");
+			(u8) PHY_GETINTVAR(pi, "tempcorrx");
 		pi_lcn->lcnphy_tempsense_option =
-		    (u8) PHY_GETINTVAR(pi, "tempsense_option");
+			(u8) PHY_GETINTVAR(pi, "tempsense_option");
 		pi_lcn->lcnphy_freqoffset_corr =
-		    (u8) PHY_GETINTVAR(pi, "freqoffset_corr");
+			(u8) PHY_GETINTVAR(pi, "freqoffset_corr");
 		if ((u8) getintvar(pi->vars, "aa2g") > 1)
 			wlc_phy_ant_rxdiv_set((struct brcms_phy_pub *) pi,
 					      (u8) getintvar(pi->vars,
-								"aa2g"));
+							     "aa2g"));
 	}
 	pi_lcn->lcnphy_cck_dig_filt_type = -1;
 	if (PHY_GETVAR(pi, "cckdigfilttype")) {
@@ -4942,7 +4970,7 @@ wlc_lcnphy_radio_2064_channel_tune_4313(struct brcms_phy *pi, u8 channel)
 		d28 = (((PLL_2064_HIGH_END_KVCO - PLL_2064_LOW_END_KVCO) *
 			(fvco3 / 2 - PLL_2064_LOW_END_VCO)) /
 		       (PLL_2064_HIGH_END_VCO - PLL_2064_LOW_END_VCO))
-		    + PLL_2064_LOW_END_KVCO;
+		      + PLL_2064_LOW_END_KVCO;
 		h28_ten = (d28 * 10) / c28;
 		c30 = 2640;
 		e30 = (d30 - 680) / 490;
@@ -5007,7 +5035,8 @@ bool wlc_phy_attach_lcnphy(struct brcms_phy *pi)
 
 	pi_lcn = pi->u.pi_lcnphy;
 
-	if ((0 == (pi->sh->boardflags & BFL_NOPA)) && !NORADIO_ENAB(pi->pubpi)) {
+	if ((0 == (pi->sh->boardflags & BFL_NOPA)) &&
+	    !NORADIO_ENAB(pi->pubpi)) {
 		pi->hwpwrctrl = true;
 		pi->hwpwrctrl_capable = true;
 	}
@@ -5028,7 +5057,8 @@ bool wlc_phy_attach_lcnphy(struct brcms_phy *pi)
 	if (!wlc_phy_txpwr_srom_read_lcnphy(pi))
 		return false;
 
-	if ((pi->sh->boardflags & BFL_FEM) && (LCNREV_IS(pi->pubpi.phy_rev, 1))) {
+	if ((pi->sh->boardflags & BFL_FEM) &&
+	    (LCNREV_IS(pi->pubpi.phy_rev, 1))) {
 		if (pi_lcn->lcnphy_tempsense_option == 3) {
 			pi->hwpwrctrl = true;
 			pi->hwpwrctrl_capable = true;
@@ -5056,8 +5086,8 @@ static void wlc_lcnphy_set_rx_gain(struct brcms_phy *pi, u32 gain)
 	biq1 = (u16) (gain >> 16) & 0xf;
 
 	gain0_15 = (u16) ((lna1 & 0x3) | ((lna1 & 0x3) << 2) |
-			     ((lna2 & 0x3) << 4) | ((lna2 & 0x3) << 6) |
-			     ((tia & 0xf) << 8) | ((biq0 & 0xf) << 12));
+			  ((lna2 & 0x3) << 4) | ((lna2 & 0x3) << 6) |
+			  ((tia & 0xf) << 8) | ((biq0 & 0xf) << 12));
 	gain16_19 = biq1;
 
 	mod_phy_reg(pi, 0x44d, (0x1 << 0), trsw << 0);
@@ -5092,18 +5122,19 @@ static u32 wlc_lcnphy_get_receive_power(struct brcms_phy *pi, s32 *gain_index)
 					       lcnphy_23bitgaincode_table
 					       [*gain_index]);
 			received_power =
-			    wlc_lcnphy_measure_digital_power(pi,
-							     pi_lcn->
-							     lcnphy_noise_samples);
+				wlc_lcnphy_measure_digital_power(
+					pi,
+					pi_lcn->
+					lcnphy_noise_samples);
 			(*gain_index)++;
 		}
 		(*gain_index)--;
 	} else {
 		wlc_lcnphy_set_rx_gain(pi, gain_code);
 		received_power =
-		    wlc_lcnphy_measure_digital_power(pi,
-						     pi_lcn->
-						     lcnphy_noise_samples);
+			wlc_lcnphy_measure_digital_power(pi,
+							 pi_lcn->
+							 lcnphy_noise_samples);
 	}
 
 	return received_power;
@@ -5154,7 +5185,7 @@ s32 wlc_lcnphy_rx_signal_power(struct brcms_phy *pi, s32 gain_index)
 	input_power_db = input_power_offset_db - desired_gain;
 
 	input_power_db =
-	    input_power_db + lcnphy_gain_index_offset_for_rssi[gain_index];
+		input_power_db + lcnphy_gain_index_offset_for_rssi[gain_index];
 
 	freq = wlc_phy_channel2freq(CHSPEC_CHANNEL(pi->radio_chanspec));
 	if ((freq > 2427) && (freq <= 2467))
@@ -5164,15 +5195,17 @@ s32 wlc_lcnphy_rx_signal_power(struct brcms_phy *pi, s32 gain_index)
 
 	if ((temperature - 15) < -30)
 		input_power_db =
-		    input_power_db + (((temperature - 10 - 25) * 286) >> 12) -
-		    7;
+			input_power_db +
+			(((temperature - 10 - 25) * 286) >> 12) -
+			7;
 	else if ((temperature - 15) < 4)
 		input_power_db =
-		    input_power_db + (((temperature - 10 - 25) * 286) >> 12) -
-		    3;
+			input_power_db +
+			(((temperature - 10 - 25) * 286) >> 12) -
+			3;
 	else
-		input_power_db =
-		    input_power_db + (((temperature - 10 - 25) * 286) >> 12);
+		input_power_db = input_power_db +
+					(((temperature - 10 - 25) * 286) >> 12);
 
 	wlc_lcnphy_rx_gain_override_enable(pi, 0);
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
index ee1fe58..ca6f749 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
@@ -28,28 +28,42 @@
 #include "phyreg_n.h"
 #include "phytbl_n.h"
 
-#define	READ_RADIO_REG2(pi, radio_type, jspace, core, reg_name) \
-	read_radio_reg(pi, radio_type##_##jspace##_##reg_name | \
-	((core == PHY_CORE_0) ? radio_type##_##jspace##0 : radio_type##_##jspace##1))
-#define	WRITE_RADIO_REG2(pi, radio_type, jspace, core, reg_name, value) \
+#define READ_RADIO_REG2(pi, radio_type, jspace, core, reg_name)	\
+	read_radio_reg(pi, radio_type##_##jspace##_##reg_name |	\
+		       ((core == PHY_CORE_0) ? \
+			radio_type##_##jspace##0 : \
+			radio_type##_##jspace##1))
+
+#define WRITE_RADIO_REG2(pi, radio_type, jspace, core, reg_name, value)	\
 	write_radio_reg(pi, radio_type##_##jspace##_##reg_name | \
-	((core == PHY_CORE_0) ? radio_type##_##jspace##0 : \
-	radio_type##_##jspace##1), value)
-#define	WRITE_RADIO_SYN(pi, radio_type, reg_name, value) \
+			((core ==  PHY_CORE_0) ? \
+			 radio_type##_##jspace##0 : \
+			 radio_type##_##jspace##1), value)
+
+#define WRITE_RADIO_SYN(pi, radio_type, reg_name, value) \
 	write_radio_reg(pi, radio_type##_##SYN##_##reg_name, value)
 
-#define	READ_RADIO_REG3(pi, radio_type, jspace, core, reg_name) \
-	read_radio_reg(pi, ((core == PHY_CORE_0) ? radio_type##_##jspace##0##_##reg_name : \
-	radio_type##_##jspace##1##_##reg_name))
-#define	WRITE_RADIO_REG3(pi, radio_type, jspace, core, reg_name, value) \
-	write_radio_reg(pi, ((core == PHY_CORE_0) ? radio_type##_##jspace##0##_##reg_name : \
-	radio_type##_##jspace##1##_##reg_name), value)
-#define	READ_RADIO_REG4(pi, radio_type, jspace, core, reg_name) \
-	read_radio_reg(pi, ((core == PHY_CORE_0) ? radio_type##_##reg_name##_##jspace##0 : \
-	radio_type##_##reg_name##_##jspace##1))
-#define	WRITE_RADIO_REG4(pi, radio_type, jspace, core, reg_name, value) \
-	write_radio_reg(pi, ((core == PHY_CORE_0) ? radio_type##_##reg_name##_##jspace##0 : \
-	radio_type##_##reg_name##_##jspace##1), value)
+#define READ_RADIO_REG3(pi, radio_type, jspace, core, reg_name)	\
+	read_radio_reg(pi, ((core == PHY_CORE_0) ? \
+			    radio_type##_##jspace##0##_##reg_name : \
+			    radio_type##_##jspace##1##_##reg_name))
+
+#define WRITE_RADIO_REG3(pi, radio_type, jspace, core, reg_name, value)	\
+	write_radio_reg(pi, ((core ==  PHY_CORE_0) ? \
+			     radio_type##_##jspace##0##_##reg_name : \
+			     radio_type##_##jspace##1##_##reg_name), \
+			value)
+
+#define READ_RADIO_REG4(pi, radio_type, jspace, core, reg_name)	\
+	read_radio_reg(pi, ((core == PHY_CORE_0) ? \
+			     radio_type##_##reg_name##_##jspace##0 : \
+			     radio_type##_##reg_name##_##jspace##1))
+
+#define WRITE_RADIO_REG4(pi, radio_type, jspace, core, reg_name, value)	\
+	write_radio_reg(pi, ((core == PHY_CORE_0) ? \
+			radio_type##_##reg_name##_##jspace##0 : \
+			radio_type##_##reg_name##_##jspace##1), \
+			value)
 
 #define NPHY_ACI_MAX_UNDETECT_WINDOW_SZ 40
 #define NPHY_ACI_CHANNEL_DELTA 5
@@ -104,9 +118,11 @@
 #define NPHY_CALSANITY_RSSI_NB_MAX_POS  9
 #define NPHY_CALSANITY_RSSI_NB_MAX_NEG -9
 #define NPHY_CALSANITY_RSSI_W1_MAX_POS  12
-#define NPHY_CALSANITY_RSSI_W1_MAX_NEG (NPHY_RSSICAL_W1_TARGET - NPHY_RSSICAL_MAXREAD)
+#define NPHY_CALSANITY_RSSI_W1_MAX_NEG (NPHY_RSSICAL_W1_TARGET - \
+					NPHY_RSSICAL_MAXREAD)
 #define NPHY_CALSANITY_RSSI_W2_MAX_POS  NPHY_CALSANITY_RSSI_W1_MAX_POS
-#define NPHY_CALSANITY_RSSI_W2_MAX_NEG (NPHY_RSSICAL_W2_TARGET - NPHY_RSSICAL_MAXREAD)
+#define NPHY_CALSANITY_RSSI_W2_MAX_NEG (NPHY_RSSICAL_W2_TARGET - \
+					NPHY_RSSICAL_MAXREAD)
 #define NPHY_RSSI_SXT(x) ((s8) (-((x) & 0x20) + ((x) & 0x1f)))
 #define NPHY_RSSI_NB_VIOL(x)  (((x) > NPHY_CALSANITY_RSSI_NB_MAX_POS) || \
 			       ((x) < NPHY_CALSANITY_RSSI_NB_MAX_NEG))
@@ -125,11 +141,11 @@
 #define NPHY_PAPD_COMP_OFF 0
 #define NPHY_PAPD_COMP_ON  1
 
-#define NPHY_SROM_TEMPSHIFT		32
-#define NPHY_SROM_MAXTEMPOFFSET		16
-#define NPHY_SROM_MINTEMPOFFSET		-16
+#define NPHY_SROM_TEMPSHIFT             32
+#define NPHY_SROM_MAXTEMPOFFSET         16
+#define NPHY_SROM_MINTEMPOFFSET         -16
 
-#define NPHY_CAL_MAXTEMPDELTA		64
+#define NPHY_CAL_MAXTEMPDELTA           64
 
 #define NPHY_NOISEVAR_TBLLEN40 256
 #define NPHY_NOISEVAR_TBLLEN20 128
@@ -139,8 +155,8 @@
 #define NPHY_ADJUSTED_MINCRSPOWER 0x1e
 
 /* 5357 Chip specific ChipControl register bits */
-#define CCTRL5357_EXTPA                 (1<<14)	/* extPA in ChipControl 1, bit 14 */
-#define CCTRL5357_ANT_MUX_2o3		(1<<15)	/* 2o3 in ChipControl 1, bit 15 */
+#define CCTRL5357_EXTPA            (1<<14) /* extPA in ChipControl 1, bit 14 */
+#define CCTRL5357_ANT_MUX_2o3      (1<<15) /* 2o3 in ChipControl 1, bit 15 */
 
 struct nphy_iqcal_params {
 	u16 txlpf;
@@ -185,38 +201,40 @@ struct nphy_ipa_txrxgain {
 
 #define NPHY_IPA_RXCAL_MAXGAININDEX (6 - 1)
 
-struct nphy_ipa_txrxgain nphy_ipa_rxcal_gaintbl_5GHz[] = { {0, 0, 0, 0, 0, 100},
-{0, 0, 0, 0, 0, 50},
-{0, 0, 0, 0, 0, -1},
-{0, 0, 0, 3, 0, -1},
-{0, 0, 3, 3, 0, -1},
-{0, 2, 3, 3, 0, -1}
+struct nphy_ipa_txrxgain nphy_ipa_rxcal_gaintbl_5GHz[] = {
+	{0, 0, 0, 0, 0, 100},
+	{0, 0, 0, 0, 0, 50},
+	{0, 0, 0, 0, 0, -1},
+	{0, 0, 0, 3, 0, -1},
+	{0, 0, 3, 3, 0, -1},
+	{0, 2, 3, 3, 0, -1}
 };
 
-struct nphy_ipa_txrxgain nphy_ipa_rxcal_gaintbl_2GHz[] = { {0, 0, 0, 0, 0, 128},
-{0, 0, 0, 0, 0, 70},
-{0, 0, 0, 0, 0, 20},
-{0, 0, 0, 3, 0, 20},
-{0, 0, 3, 3, 0, 20},
-{0, 2, 3, 3, 0, 20}
+struct nphy_ipa_txrxgain nphy_ipa_rxcal_gaintbl_2GHz[] = {
+	{0, 0, 0, 0, 0, 128},
+	{0, 0, 0, 0, 0, 70},
+	{0, 0, 0, 0, 0, 20},
+	{0, 0, 0, 3, 0, 20},
+	{0, 0, 3, 3, 0, 20},
+	{0, 2, 3, 3, 0, 20}
 };
 
 struct nphy_ipa_txrxgain nphy_ipa_rxcal_gaintbl_5GHz_rev7[] = {
-{0, 0, 0, 0, 0, 100},
-{0, 0, 0, 0, 0, 50},
-{0, 0, 0, 0, 0, -1},
-{0, 0, 0, 3, 0, -1},
-{0, 0, 3, 3, 0, -1},
-{0, 0, 5, 3, 0, -1}
+	{0, 0, 0, 0, 0, 100},
+	{0, 0, 0, 0, 0, 50},
+	{0, 0, 0, 0, 0, -1},
+	{0, 0, 0, 3, 0, -1},
+	{0, 0, 3, 3, 0, -1},
+	{0, 0, 5, 3, 0, -1}
 };
 
 struct nphy_ipa_txrxgain nphy_ipa_rxcal_gaintbl_2GHz_rev7[] = {
-{0, 0, 0, 0, 0, 10},
-{0, 0, 0, 1, 0, 10},
-{0, 0, 1, 2, 0, 10},
-{0, 0, 1, 3, 0, 10},
-{0, 0, 4, 3, 0, 10},
-{0, 0, 6, 3, 0, 10}
+	{0, 0, 0, 0, 0, 10},
+	{0, 0, 0, 1, 0, 10},
+	{0, 0, 1, 2, 0, 10},
+	{0, 0, 1, 3, 0, 10},
+	{0, 0, 4, 3, 0, 10},
+	{0, 0, 6, 3, 0, 10}
 };
 
 #define NPHY_RXCAL_TONEAMP 181
@@ -231,9 +249,9 @@ enum {
 
 #define wlc_phy_get_papd_nphy(pi) \
 	(read_phy_reg((pi), 0x1e7) & \
-			((0x1 << 15) | \
-			(0x1 << 14) | \
-			(0x1 << 13)))
+	 ((0x1 << 15) |	\
+	  (0x1 << 14) |	\
+	  (0x1 << 13)))
 
 #define TXFILT_SHAPING_OFDM20   0
 #define TXFILT_SHAPING_OFDM40   1
@@ -13291,27 +13309,27 @@ static s32 nphy_lnagain_est1[] = { -224, 23242 };
 
 static const u16 tbl_iqcal_gainparams_nphy[2][NPHY_IQCAL_NUMGAINS][8] = {
 	{
-	 {0x000, 0, 0, 2, 0x69, 0x69, 0x69, 0x69},
-	 {0x700, 7, 0, 0, 0x69, 0x69, 0x69, 0x69},
-	 {0x710, 7, 1, 0, 0x68, 0x68, 0x68, 0x68},
-	 {0x720, 7, 2, 0, 0x67, 0x67, 0x67, 0x67},
-	 {0x730, 7, 3, 0, 0x66, 0x66, 0x66, 0x66},
-	 {0x740, 7, 4, 0, 0x65, 0x65, 0x65, 0x65},
-	 {0x741, 7, 4, 1, 0x65, 0x65, 0x65, 0x65},
-	 {0x742, 7, 4, 2, 0x65, 0x65, 0x65, 0x65},
-	 {0x743, 7, 4, 3, 0x65, 0x65, 0x65, 0x65}
-	 },
-	{
-	 {0x000, 7, 0, 0, 0x79, 0x79, 0x79, 0x79},
-	 {0x700, 7, 0, 0, 0x79, 0x79, 0x79, 0x79},
-	 {0x710, 7, 1, 0, 0x79, 0x79, 0x79, 0x79},
-	 {0x720, 7, 2, 0, 0x78, 0x78, 0x78, 0x78},
-	 {0x730, 7, 3, 0, 0x78, 0x78, 0x78, 0x78},
-	 {0x740, 7, 4, 0, 0x78, 0x78, 0x78, 0x78},
-	 {0x741, 7, 4, 1, 0x78, 0x78, 0x78, 0x78},
-	 {0x742, 7, 4, 2, 0x78, 0x78, 0x78, 0x78},
-	 {0x743, 7, 4, 3, 0x78, 0x78, 0x78, 0x78}
-	 }
+		{0x000, 0, 0, 2, 0x69, 0x69, 0x69, 0x69},
+		{0x700, 7, 0, 0, 0x69, 0x69, 0x69, 0x69},
+		{0x710, 7, 1, 0, 0x68, 0x68, 0x68, 0x68},
+		{0x720, 7, 2, 0, 0x67, 0x67, 0x67, 0x67},
+		{0x730, 7, 3, 0, 0x66, 0x66, 0x66, 0x66},
+		{0x740, 7, 4, 0, 0x65, 0x65, 0x65, 0x65},
+		{0x741, 7, 4, 1, 0x65, 0x65, 0x65, 0x65},
+		{0x742, 7, 4, 2, 0x65, 0x65, 0x65, 0x65},
+		{0x743, 7, 4, 3, 0x65, 0x65, 0x65, 0x65}
+	},
+	{
+		{0x000, 7, 0, 0, 0x79, 0x79, 0x79, 0x79},
+		{0x700, 7, 0, 0, 0x79, 0x79, 0x79, 0x79},
+		{0x710, 7, 1, 0, 0x79, 0x79, 0x79, 0x79},
+		{0x720, 7, 2, 0, 0x78, 0x78, 0x78, 0x78},
+		{0x730, 7, 3, 0, 0x78, 0x78, 0x78, 0x78},
+		{0x740, 7, 4, 0, 0x78, 0x78, 0x78, 0x78},
+		{0x741, 7, 4, 1, 0x78, 0x78, 0x78, 0x78},
+		{0x742, 7, 4, 2, 0x78, 0x78, 0x78, 0x78},
+		{0x743, 7, 4, 3, 0x78, 0x78, 0x78, 0x78}
+	}
 };
 
 static const u32 nphy_tpc_txgain[] = {
@@ -14082,9 +14100,11 @@ static u32 nphy_tpc_5GHz_txgain_HiPwrEPA[] = {
 static u8 ant_sw_ctrl_tbl_rev8_2o3[] = { 0x14, 0x18 };
 static u8 ant_sw_ctrl_tbl_rev8[] = { 0x4, 0x8, 0x4, 0x8, 0x11, 0x12 };
 static u8 ant_sw_ctrl_tbl_rev8_2057v7_core0[] = {
-	0x09, 0x0a, 0x15, 0x16, 0x09, 0x0a };
+	0x09, 0x0a, 0x15, 0x16, 0x09, 0x0a
+};
 static u8 ant_sw_ctrl_tbl_rev8_2057v7_core1[] = {
-	0x09, 0x0a, 0x09, 0x0a, 0x15, 0x16 };
+	0x09, 0x0a, 0x09, 0x0a, 0x15, 0x16
+};
 
 static bool wlc_phy_chan2freq_nphy(struct brcms_phy *pi, uint channel, int *f,
 				   struct chan_info_nphy_radio2057 **t0,
@@ -14145,10 +14165,14 @@ static void wlc_phy_a1_nphy(struct brcms_phy *pi, u8 core, u32 winsz, u32,
 static u8 wlc_phy_a3_nphy(struct brcms_phy *pi, u8 start_gain, u8 core);
 static void wlc_phy_a2_nphy(struct brcms_phy *pi, struct nphy_ipa_txcalgains *,
 			    enum phy_cal_mode, u8);
-static void wlc_phy_papd_cal_cleanup_nphy(struct brcms_phy *pi,
-				struct nphy_papd_restore_state *state);
+
+static void
+wlc_phy_papd_cal_cleanup_nphy(struct brcms_phy *pi,
+			      struct nphy_papd_restore_state *state);
+
 static void wlc_phy_papd_cal_setup_nphy(struct brcms_phy *pi,
-				struct nphy_papd_restore_state *state, u8);
+					struct nphy_papd_restore_state *state,
+					u8);
 
 static void wlc_phy_clip_det_nphy(struct brcms_phy *pi, u8 write, u16 *vals);
 
@@ -14187,8 +14211,8 @@ static u16 wlc_phy_radio205x_rcal(struct brcms_phy *pi);
 static u16 wlc_phy_radio2057_rccal(struct brcms_phy *pi);
 
 static u16 wlc_phy_gen_load_samples_nphy(struct brcms_phy *pi, u32 f_kHz,
-					    u16 max_val,
-					    u8 dac_test_mode);
+					 u16 max_val,
+					 u8 dac_test_mode);
 static void wlc_phy_loadsampletable_nphy(struct brcms_phy *pi,
 					 struct cs32 *tone_buf, u16 num_samps);
 static void wlc_phy_runsamples_nphy(struct brcms_phy *pi, u16 n, u16 lps,
@@ -14306,7 +14330,8 @@ static void wlc_phy_tbl_init_nphy(struct brcms_phy *pi)
 	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 
 		antswctrllut = CHSPEC_IS2G(pi->radio_chanspec) ?
-		    pi->srom_fem2g.antswctrllut : pi->srom_fem5g.antswctrllut;
+			       pi->srom_fem2g.antswctrllut : pi->srom_fem5g.
+			       antswctrllut;
 
 		switch (antswctrllut) {
 		case 0:
@@ -14316,17 +14341,18 @@ static void wlc_phy_tbl_init_nphy(struct brcms_phy *pi)
 		case 1:
 
 			if (pi->aa2g == 7)
-				wlc_phy_table_write_nphy(pi,
-							 NPHY_TBL_ID_ANTSWCTRLLUT,
-							 2, 0x21, 8,
-							 &ant_sw_ctrl_tbl_rev8_2o3
-							 [0]);
+				wlc_phy_table_write_nphy(
+					pi,
+					NPHY_TBL_ID_ANTSWCTRLLUT,
+					2, 0x21, 8,
+					&ant_sw_ctrl_tbl_rev8_2o3[0]);
 			else
-				wlc_phy_table_write_nphy(pi,
-							 NPHY_TBL_ID_ANTSWCTRLLUT,
-							 2, 0x21, 8,
-							 &ant_sw_ctrl_tbl_rev8
-							 [0]);
+				wlc_phy_table_write_nphy(
+					pi,
+					NPHY_TBL_ID_ANTSWCTRLLUT,
+					2, 0x21, 8,
+					&ant_sw_ctrl_tbl_rev8
+					[0]);
 
 			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_ANTSWCTRLLUT,
 						 2, 0x25, 8,
@@ -14338,31 +14364,31 @@ static void wlc_phy_tbl_init_nphy(struct brcms_phy *pi)
 
 		case 2:
 
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_ANTSWCTRLLUT,
-						 2, 0x1, 8,
-						 &ant_sw_ctrl_tbl_rev8_2057v7_core0
-						 [0]);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_ANTSWCTRLLUT,
-						 2, 0x5, 8,
-						 &ant_sw_ctrl_tbl_rev8_2057v7_core0
-						 [2]);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_ANTSWCTRLLUT,
-						 2, 0x9, 8,
-						 &ant_sw_ctrl_tbl_rev8_2057v7_core0
-						 [4]);
-
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_ANTSWCTRLLUT,
-						 2, 0x21, 8,
-						 &ant_sw_ctrl_tbl_rev8_2057v7_core1
-						 [0]);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_ANTSWCTRLLUT,
-						 2, 0x25, 8,
-						 &ant_sw_ctrl_tbl_rev8_2057v7_core1
-						 [2]);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_ANTSWCTRLLUT,
-						 2, 0x29, 8,
-						 &ant_sw_ctrl_tbl_rev8_2057v7_core1
-						 [4]);
+			wlc_phy_table_write_nphy(
+				pi, NPHY_TBL_ID_ANTSWCTRLLUT,
+				2, 0x1, 8,
+				&ant_sw_ctrl_tbl_rev8_2057v7_core0[0]);
+			wlc_phy_table_write_nphy(
+				pi, NPHY_TBL_ID_ANTSWCTRLLUT,
+				2, 0x5, 8,
+				&ant_sw_ctrl_tbl_rev8_2057v7_core0[2]);
+			wlc_phy_table_write_nphy(
+				pi, NPHY_TBL_ID_ANTSWCTRLLUT,
+				2, 0x9, 8,
+				&ant_sw_ctrl_tbl_rev8_2057v7_core0[4]);
+
+			wlc_phy_table_write_nphy(
+				pi, NPHY_TBL_ID_ANTSWCTRLLUT,
+				2, 0x21, 8,
+				&ant_sw_ctrl_tbl_rev8_2057v7_core1[0]);
+			wlc_phy_table_write_nphy(
+				pi, NPHY_TBL_ID_ANTSWCTRLLUT,
+				2, 0x25, 8,
+				&ant_sw_ctrl_tbl_rev8_2057v7_core1[2]);
+			wlc_phy_table_write_nphy(
+				pi, NPHY_TBL_ID_ANTSWCTRLLUT,
+				2, 0x29, 8,
+				&ant_sw_ctrl_tbl_rev8_2057v7_core1[4]);
 			break;
 
 		default:
@@ -14373,37 +14399,42 @@ static void wlc_phy_tbl_init_nphy(struct brcms_phy *pi)
 		for (idx = 0; idx < mimophytbl_info_sz_rev3_volatile; idx++) {
 
 			if (idx == ANT_SWCTRL_TBL_REV3_IDX) {
-				antswctrllut = CHSPEC_IS2G(pi->radio_chanspec) ?
-				    pi->srom_fem2g.antswctrllut : pi->
-				    srom_fem5g.antswctrllut;
+				antswctrllut =
+					CHSPEC_IS2G(pi->radio_chanspec) ?
+					pi->srom_fem2g.antswctrllut :
+					pi->srom_fem5g.antswctrllut;
 				switch (antswctrllut) {
 				case 0:
-					wlc_phy_write_table_nphy(pi,
-								 &mimophytbl_info_rev3_volatile
-								 [idx]);
+					wlc_phy_write_table_nphy(
+						pi,
+						&mimophytbl_info_rev3_volatile
+						[idx]);
 					break;
 				case 1:
-					wlc_phy_write_table_nphy(pi,
-								 &mimophytbl_info_rev3_volatile1
-								 [idx]);
+					wlc_phy_write_table_nphy(
+						pi,
+						&mimophytbl_info_rev3_volatile1
+						[idx]);
 					break;
 				case 2:
-					wlc_phy_write_table_nphy(pi,
-								 &mimophytbl_info_rev3_volatile2
-								 [idx]);
+					wlc_phy_write_table_nphy(
+						pi,
+						&mimophytbl_info_rev3_volatile2
+						[idx]);
 					break;
 				case 3:
-					wlc_phy_write_table_nphy(pi,
-								 &mimophytbl_info_rev3_volatile3
-								 [idx]);
+					wlc_phy_write_table_nphy(
+						pi,
+						&mimophytbl_info_rev3_volatile3
+						[idx]);
 					break;
 				default:
 					break;
 				}
 			} else {
-				wlc_phy_write_table_nphy(pi,
-							 &mimophytbl_info_rev3_volatile
-							 [idx]);
+				wlc_phy_write_table_nphy(
+					pi,
+					&mimophytbl_info_rev3_volatile[idx]);
 			}
 		}
 	} else {
@@ -14544,7 +14575,8 @@ void wlc_phy_init_nphy(struct brcms_phy *pi)
 	    CHSPEC_IS40(pi->radio_chanspec)) {
 
 		regs = (struct d11regs *) ai_switch_core(pi->sh->sih,
-					D11_CORE_ID, &origidx, &intr_val);
+							 D11_CORE_ID, &origidx,
+							 &intr_val);
 		d11_clk_ctl_st = R_REG(&regs->clk_ctl_st);
 		AND_REG(&regs->clk_ctl_st,
 			~(CCS_FORCEHT | CCS_HTAREQ));
@@ -14555,10 +14587,10 @@ void wlc_phy_init_nphy(struct brcms_phy *pi)
 	}
 
 	pi->use_int_tx_iqlo_cal_nphy =
-	    (PHY_IPA(pi) ||
-	     (NREV_GE(pi->pubpi.phy_rev, 7) ||
-	      (NREV_GE(pi->pubpi.phy_rev, 5)
-	       && pi->sh->boardflags2 & BFL2_INTERNDET_TXIQCAL)));
+		(PHY_IPA(pi) ||
+		 (NREV_GE(pi->pubpi.phy_rev, 7) ||
+		  (NREV_GE(pi->pubpi.phy_rev, 5)
+		   && pi->sh->boardflags2 & BFL2_INTERNDET_TXIQCAL)));
 
 	pi->internal_tx_iqlo_cal_tapoff_intpa_nphy = false;
 
@@ -14690,31 +14722,32 @@ void wlc_phy_init_nphy(struct brcms_phy *pi)
 			if (CHSPEC_IS5G(pi->radio_chanspec)) {
 				if (NREV_IS(pi->pubpi.phy_rev, 3))
 					tx_pwrctrl_tbl =
-					    nphy_tpc_5GHz_txgain_rev3;
+						nphy_tpc_5GHz_txgain_rev3;
 				else if (NREV_IS(pi->pubpi.phy_rev, 4))
 					tx_pwrctrl_tbl =
-					    (pi->srom_fem5g.extpagain == 3) ?
-					    nphy_tpc_5GHz_txgain_HiPwrEPA :
-					    nphy_tpc_5GHz_txgain_rev4;
+						(pi->srom_fem5g.extpagain ==
+						 3) ?
+						nphy_tpc_5GHz_txgain_HiPwrEPA :
+						nphy_tpc_5GHz_txgain_rev4;
 				else
 					tx_pwrctrl_tbl =
-					    nphy_tpc_5GHz_txgain_rev5;
+						nphy_tpc_5GHz_txgain_rev5;
 			} else {
 				if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 					if (pi->pubpi.radiorev == 5)
 						tx_pwrctrl_tbl =
-						    nphy_tpc_txgain_epa_2057rev5;
+						   nphy_tpc_txgain_epa_2057rev5;
 					else if (pi->pubpi.radiorev == 3)
 						tx_pwrctrl_tbl =
-						    nphy_tpc_txgain_epa_2057rev3;
+						   nphy_tpc_txgain_epa_2057rev3;
 				} else {
 					if (NREV_GE(pi->pubpi.phy_rev, 5) &&
 					    (pi->srom_fem2g.extpagain == 3))
 						tx_pwrctrl_tbl =
-						    nphy_tpc_txgain_HiPwrEPA;
+						       nphy_tpc_txgain_HiPwrEPA;
 					else
 						tx_pwrctrl_tbl =
-						    nphy_tpc_txgain_rev3;
+							nphy_tpc_txgain_rev3;
 				}
 			}
 		}
@@ -14737,40 +14770,42 @@ void wlc_phy_init_nphy(struct brcms_phy *pi)
 					    (pi->pubpi.radiorev == 4) ||
 					    (pi->pubpi.radiorev == 6))
 						rfpwr_offset = (s16)
-						    nphy_papd_padgain_dlt_2g_2057rev3n4
-						    [pad_gn];
+							       nphy_papd_padgain_dlt_2g_2057rev3n4
+							       [pad_gn];
 					else if (pi->pubpi.radiorev == 5)
 						rfpwr_offset = (s16)
-						    nphy_papd_padgain_dlt_2g_2057rev5
-						    [pad_gn];
+							       nphy_papd_padgain_dlt_2g_2057rev5
+							       [pad_gn];
 					else if ((pi->pubpi.radiorev == 7)
-						   || (pi->pubpi.radiorev ==
-						       8))
+						 || (pi->pubpi.radiorev ==
+						     8))
 						rfpwr_offset = (s16)
-						    nphy_papd_padgain_dlt_2g_2057rev7
-						    [pad_gn];
+							       nphy_papd_padgain_dlt_2g_2057rev7
+							       [pad_gn];
 				} else {
 					if ((pi->pubpi.radiorev == 3) ||
 					    (pi->pubpi.radiorev == 4) ||
 					    (pi->pubpi.radiorev == 6))
 						rfpwr_offset = (s16)
-						    nphy_papd_pgagain_dlt_5g_2057
-						    [pga_gn];
+							       nphy_papd_pgagain_dlt_5g_2057
+							       [pga_gn];
 					else if ((pi->pubpi.radiorev == 7)
-						   || (pi->pubpi.radiorev ==
-						       8))
+						 || (pi->pubpi.radiorev ==
+						     8))
 						rfpwr_offset = (s16)
-						    nphy_papd_pgagain_dlt_5g_2057rev7
-						    [pga_gn];
+							       nphy_papd_pgagain_dlt_5g_2057rev7
+							       [pga_gn];
 				}
-				wlc_phy_table_write_nphy(pi,
-							 NPHY_TBL_ID_CORE1TXPWRCTL,
-							 1, 576 + idx, 32,
-							 &rfpwr_offset);
-				wlc_phy_table_write_nphy(pi,
-							 NPHY_TBL_ID_CORE2TXPWRCTL,
-							 1, 576 + idx, 32,
-							 &rfpwr_offset);
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
 		} else {
 
@@ -14778,21 +14813,23 @@ void wlc_phy_init_nphy(struct brcms_phy *pi)
 				pga_gn = (tx_pwrctrl_tbl[idx] >> 24) & 0xf;
 				if (CHSPEC_IS2G(pi->radio_chanspec))
 					rfpwr_offset = (s16)
-					    nphy_papd_pga_gain_delta_ipa_2g
-					    [pga_gn];
+						 nphy_papd_pga_gain_delta_ipa_2g
+								       [pga_gn];
 				else
 					rfpwr_offset = (s16)
-					    nphy_papd_pga_gain_delta_ipa_5g
-					    [pga_gn];
-
-				wlc_phy_table_write_nphy(pi,
-							 NPHY_TBL_ID_CORE1TXPWRCTL,
-							 1, 576 + idx, 32,
-							 &rfpwr_offset);
-				wlc_phy_table_write_nphy(pi,
-							 NPHY_TBL_ID_CORE2TXPWRCTL,
-							 1, 576 + idx, 32,
-							 &rfpwr_offset);
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
 
 		}
@@ -14816,8 +14853,8 @@ void wlc_phy_init_nphy(struct brcms_phy *pi)
 
 		if (NREV_GE(pi->pubpi.phy_rev, 3)) {
 			do_rssi_cal = (CHSPEC_IS2G(pi->radio_chanspec)) ?
-			    (pi->nphy_rssical_chanspec_2G == 0) :
-			    (pi->nphy_rssical_chanspec_5G == 0);
+				      (pi->nphy_rssical_chanspec_2G == 0) :
+				      (pi->nphy_rssical_chanspec_5G == 0);
 
 			if (do_rssi_cal)
 				wlc_phy_rssi_cal_nphy(pi);
@@ -14829,8 +14866,8 @@ void wlc_phy_init_nphy(struct brcms_phy *pi)
 
 		if (!SCAN_RM_IN_PROGRESS(pi))
 			do_nphy_cal = (CHSPEC_IS2G(pi->radio_chanspec)) ?
-			    (pi->nphy_iqcal_chanspec_2G == 0) :
-			    (pi->nphy_iqcal_chanspec_5G == 0);
+				      (pi->nphy_iqcal_chanspec_2G == 0) :
+				      (pi->nphy_iqcal_chanspec_5G == 0);
 
 		if (!pi->do_initcal)
 			do_nphy_cal = false;
@@ -14848,22 +14885,25 @@ void wlc_phy_init_nphy(struct brcms_phy *pi)
 
 				if (NREV_GE(pi->pubpi.phy_rev, 3)) {
 					pi->nphy_cal_orig_pwr_idx[0] =
-					    pi->nphy_txpwrindex[PHY_CORE_0].
-					    index_internal;
+						pi->nphy_txpwrindex[PHY_CORE_0]
+						.
+						index_internal;
 					pi->nphy_cal_orig_pwr_idx[1] =
-					    pi->nphy_txpwrindex[PHY_CORE_1].
-					    index_internal;
+						pi->nphy_txpwrindex[PHY_CORE_1]
+						.
+						index_internal;
 
 					wlc_phy_precal_txgain_nphy(pi);
 					target_gain =
-					    wlc_phy_get_tx_gain_nphy(pi);
+						wlc_phy_get_tx_gain_nphy(pi);
 				}
 
 				if (wlc_phy_cal_txiqlo_nphy
-				    (pi, target_gain, true, false) == 0) {
+					    (pi, target_gain, true,
+					    false) == 0) {
 					if (wlc_phy_cal_rxiq_nphy
-					    (pi, target_gain, 2,
-					    false) == 0)
+						    (pi, target_gain, 2,
+						    false) == 0)
 						wlc_phy_savecal_nphy(pi);
 
 				}
@@ -14940,10 +14980,10 @@ void wlc_phy_pa_override_nphy(struct brcms_phy *pi, bool en)
 			rfctrlintc_override_val = 0x1480;
 		else if (NREV_GE(pi->pubpi.phy_rev, 3))
 			rfctrlintc_override_val =
-			    CHSPEC_IS5G(pi->radio_chanspec) ? 0x600 : 0x480;
+				CHSPEC_IS5G(pi->radio_chanspec) ? 0x600 : 0x480;
 		else
 			rfctrlintc_override_val =
-			    CHSPEC_IS5G(pi->radio_chanspec) ? 0x180 : 0x120;
+				CHSPEC_IS5G(pi->radio_chanspec) ? 0x180 : 0x120;
 
 		write_phy_reg(pi, 0x91, rfctrlintc_override_val);
 		write_phy_reg(pi, 0x92, rfctrlintc_override_val);
@@ -14958,7 +14998,7 @@ void wlc_phy_stf_chain_upd_nphy(struct brcms_phy *pi)
 {
 
 	u16 txrx_chain =
-	    (NPHY_RfseqCoreActv_TxRxChain0 | NPHY_RfseqCoreActv_TxRxChain1);
+		(NPHY_RfseqCoreActv_TxRxChain0 | NPHY_RfseqCoreActv_TxRxChain1);
 	bool CoreActv_override = false;
 
 	if (pi->nphy_txrx_chain == BRCMS_N_TXRX_CHAIN0) {
@@ -15000,8 +15040,7 @@ void wlc_phy_rxcore_setstate_nphy(struct brcms_phy_pub *pih, u8 rxcore_bitmask)
 	if (!pi->sh->clk)
 		return;
 
-	suspend =
-	    (0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
+	suspend = (0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
 	if (!suspend)
 		wlapi_suspend_mac_and_wait(pi->sh->physhim);
 
@@ -15026,15 +15065,15 @@ void wlc_phy_rxcore_setstate_nphy(struct brcms_phy_pub *pih, u8 rxcore_bitmask)
 				for (i = 0; i < ARRAY_SIZE(tbl_buf); i++) {
 					if (tbl_buf[i] ==
 					    NPHY_REV3_RFSEQ_CMD_CLR_RXRX_BIAS) {
-
 						pi->rx2tx_biasentry = (u8) i;
 						tbl_opcode =
-						    NPHY_REV3_RFSEQ_CMD_NOP;
-						wlc_phy_table_write_nphy(pi,
-									 NPHY_TBL_ID_RFSEQ,
-									 1, i,
-									 16,
-									 &tbl_opcode);
+							NPHY_REV3_RFSEQ_CMD_NOP;
+						wlc_phy_table_write_nphy(
+							pi,
+							NPHY_TBL_ID_RFSEQ,
+							1, i,
+							16,
+							&tbl_opcode);
 						break;
 					} else if (tbl_buf[i] ==
 						   NPHY_REV3_RFSEQ_CMD_END)
@@ -15102,7 +15141,7 @@ static void wlc_phy_txpwr_limit_to_tbl_nphy(struct brcms_phy *pi)
 				idx = TXP_FIRST_MCS_40_SISO;
 			} else {
 				idx = (CHSPEC_IS40(pi->radio_chanspec)) ?
-				    TXP_FIRST_OFDM_40_SISO : TXP_FIRST_OFDM;
+				      TXP_FIRST_OFDM_40_SISO : TXP_FIRST_OFDM;
 				delta_ind = 1;
 			}
 			break;
@@ -15110,68 +15149,68 @@ static void wlc_phy_txpwr_limit_to_tbl_nphy(struct brcms_phy *pi)
 		case 1:
 
 			idx = (CHSPEC_IS40(pi->radio_chanspec)) ?
-			    TXP_FIRST_MCS_40_CDD : TXP_FIRST_MCS_20_CDD;
+			      TXP_FIRST_MCS_40_CDD : TXP_FIRST_MCS_20_CDD;
 			break;
 
 		case 2:
 
 			idx = (CHSPEC_IS40(pi->radio_chanspec)) ?
-			    TXP_FIRST_MCS_40_STBC : TXP_FIRST_MCS_20_STBC;
+			      TXP_FIRST_MCS_40_STBC : TXP_FIRST_MCS_20_STBC;
 			break;
 
 		case 3:
 
 			idx = (CHSPEC_IS40(pi->radio_chanspec)) ?
-			    TXP_FIRST_MCS_40_SDM : TXP_FIRST_MCS_20_SDM;
+			      TXP_FIRST_MCS_40_SDM : TXP_FIRST_MCS_20_SDM;
 			break;
 		}
 
 		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-		    pi->tx_power_offset[idx];
+			pi->tx_power_offset[idx];
 		idx = idx + delta_ind;
 		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-		    pi->tx_power_offset[idx];
+			pi->tx_power_offset[idx];
 		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-		    pi->tx_power_offset[idx];
+			pi->tx_power_offset[idx];
 		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-		    pi->tx_power_offset[idx++];
+			pi->tx_power_offset[idx++];
 
 		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-		    pi->tx_power_offset[idx++];
+			pi->tx_power_offset[idx++];
 		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-		    pi->tx_power_offset[idx];
+			pi->tx_power_offset[idx];
 		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-		    pi->tx_power_offset[idx];
+			pi->tx_power_offset[idx];
 		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-		    pi->tx_power_offset[idx++];
+			pi->tx_power_offset[idx++];
 
 		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-		    pi->tx_power_offset[idx++];
+			pi->tx_power_offset[idx++];
 		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-		    pi->tx_power_offset[idx];
+			pi->tx_power_offset[idx];
 		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-		    pi->tx_power_offset[idx];
+			pi->tx_power_offset[idx];
 		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-		    pi->tx_power_offset[idx++];
+			pi->tx_power_offset[idx++];
 
 		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-		    pi->tx_power_offset[idx];
+			pi->tx_power_offset[idx];
 		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-		    pi->tx_power_offset[idx++];
+			pi->tx_power_offset[idx++];
 		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-		    pi->tx_power_offset[idx];
+			pi->tx_power_offset[idx];
 		idx = idx + 1 - delta_ind;
 		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-		    pi->tx_power_offset[idx];
+			pi->tx_power_offset[idx];
 
 		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-		    pi->tx_power_offset[idx];
+			pi->tx_power_offset[idx];
 		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-		    pi->tx_power_offset[idx];
+			pi->tx_power_offset[idx];
 		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-		    pi->tx_power_offset[idx];
+			pi->tx_power_offset[idx];
 		pi->adj_pwr_tbl_nphy[4 + 4 * (idx2++) + i] =
-		    pi->tx_power_offset[idx];
+			pi->tx_power_offset[idx];
 	}
 }
 
@@ -15403,11 +15442,13 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 			    || (pi->pubpi.radiorev == 8)) {
 
 				rccal_bcap_val =
-				    read_radio_reg(pi,
-						   RADIO_2057_RCCAL_BCAP_VAL);
+					read_radio_reg(
+						pi,
+						RADIO_2057_RCCAL_BCAP_VAL);
 				rccal_scap_val =
-				    read_radio_reg(pi,
-						   RADIO_2057_RCCAL_SCAP_VAL);
+					read_radio_reg(
+						pi,
+						RADIO_2057_RCCAL_SCAP_VAL);
 
 				rccal_tx20_11b_bcap = rccal_bcap_val;
 				rccal_tx20_11b_scap = rccal_scap_val;
@@ -15452,11 +15493,13 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 				tx_lpf_bw_ofdm_40mhz = 3;
 
 				rccal_bcap_val =
-				    read_radio_reg(pi,
-						   RADIO_2057_RCCAL_BCAP_VAL);
+					read_radio_reg(
+						pi,
+						RADIO_2057_RCCAL_BCAP_VAL);
 				rccal_scap_val =
-				    read_radio_reg(pi,
-						   RADIO_2057_RCCAL_SCAP_VAL);
+					read_radio_reg(
+						pi,
+						RADIO_2057_RCCAL_SCAP_VAL);
 
 				rccal_tx20_11b_bcap = rccal_bcap_val;
 				rccal_tx20_11b_scap = rccal_scap_val;
@@ -15472,68 +15515,84 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 
 		if (rccal_ovrd) {
 
-			rx2tx_lpf_rc_lut_tx20_11b = (rccal_tx20_11b_bcap << 8) |
-			    (rccal_tx20_11b_scap << 3) | tx_lpf_bw_11b;
-			rx2tx_lpf_rc_lut_tx20_11n = (rccal_tx20_11n_bcap << 8) |
-			    (rccal_tx20_11n_scap << 3) | tx_lpf_bw_ofdm_20mhz;
-			rx2tx_lpf_rc_lut_tx40_11n = (rccal_tx40_11n_bcap << 8) |
-			    (rccal_tx40_11n_scap << 3) | tx_lpf_bw_ofdm_40mhz;
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
 
 			for (coreNum = 0; coreNum <= 1; coreNum++) {
-				wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ,
-							 1,
-							 0x152 + coreNum * 0x10,
-							 16,
-							 &rx2tx_lpf_rc_lut_tx20_11b);
-				wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ,
-							 1,
-							 0x153 + coreNum * 0x10,
-							 16,
-							 &rx2tx_lpf_rc_lut_tx20_11n);
-				wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ,
-							 1,
-							 0x154 + coreNum * 0x10,
-							 16,
-							 &rx2tx_lpf_rc_lut_tx20_11n);
-				wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ,
-							 1,
-							 0x155 + coreNum * 0x10,
-							 16,
-							 &rx2tx_lpf_rc_lut_tx40_11n);
-				wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ,
-							 1,
-							 0x156 + coreNum * 0x10,
-							 16,
-							 &rx2tx_lpf_rc_lut_tx40_11n);
-				wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ,
-							 1,
-							 0x157 + coreNum * 0x10,
-							 16,
-							 &rx2tx_lpf_rc_lut_tx40_11n);
-				wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ,
-							 1,
-							 0x158 + coreNum * 0x10,
-							 16,
-							 &rx2tx_lpf_rc_lut_tx40_11n);
-				wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ,
-							 1,
-							 0x159 + coreNum * 0x10,
-							 16,
-							 &rx2tx_lpf_rc_lut_tx40_11n);
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
 
-			wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 4),
-							  1, 0x3, 0,
-							  NPHY_REV7_RFCTRLOVERRIDE_ID2);
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 4),
+				1, 0x3, 0,
+				NPHY_REV7_RFCTRLOVERRIDE_ID2);
 		}
 
 		if (!NORADIO_ENAB(pi->pubpi))
 			write_phy_reg(pi, 0x32f, 0x3);
 
 		if ((pi->pubpi.radiorev == 4) || (pi->pubpi.radiorev == 6))
-			wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 2),
-							  1, 0x3, 0,
-							  NPHY_REV7_RFCTRLOVERRIDE_ID0);
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 2),
+				1, 0x3, 0,
+				NPHY_REV7_RFCTRLOVERRIDE_ID0);
 
 		if ((pi->pubpi.radiorev == 3) || (pi->pubpi.radiorev == 4) ||
 		    (pi->pubpi.radiorev == 6)) {
@@ -15593,10 +15652,11 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 
 				for (coreNum = 0; coreNum <= 1; coreNum++) {
 					if (txgm_idac_bleed != 0)
-						WRITE_RADIO_REG4(pi, RADIO_2057,
-								 CORE, coreNum,
-								 TXGM_IDAC_BLEED,
-								 txgm_idac_bleed);
+						WRITE_RADIO_REG4(
+							pi, RADIO_2057,
+							CORE, coreNum,
+							TXGM_IDAC_BLEED,
+							txgm_idac_bleed);
 				}
 
 				if (pi->pubpi.radiorev == 5) {
@@ -15611,18 +15671,20 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 								 CORE, coreNum,
 								 IPA2G_IMAIN,
 								 0x1f);
-						WRITE_RADIO_REG4(pi, RADIO_2057,
-								 CORE, coreNum,
-								 IPA2G_BIAS_FILTER,
-								 0xee);
+						WRITE_RADIO_REG4(
+							pi, RADIO_2057,
+							CORE, coreNum,
+							IPA2G_BIAS_FILTER,
+							0xee);
 						WRITE_RADIO_REG4(pi, RADIO_2057,
 								 CORE, coreNum,
 								 PAD2G_IDACS,
 								 0x8a);
-						WRITE_RADIO_REG4(pi, RADIO_2057,
-								 CORE, coreNum,
-								 PAD_BIAS_FILTER_BWS,
-								 0x3e);
+						WRITE_RADIO_REG4(
+							pi, RADIO_2057,
+							CORE, coreNum,
+							PAD_BIAS_FILTER_BWS,
+							0x3e);
 					}
 
 				} else if ((pi->pubpi.radiorev == 7)
@@ -15651,9 +15713,8 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 				}
 
 			} else {
-				freq =
-				    CHAN5G_FREQ(CHSPEC_CHANNEL
-						(pi->radio_chanspec));
+				freq = CHAN5G_FREQ(CHSPEC_CHANNEL(
+							pi->radio_chanspec));
 				if (((freq >= 5180) && (freq <= 5230))
 				    || ((freq >= 5745) && (freq <= 5805))) {
 					WRITE_RADIO_REG4(pi, RADIO_2057, CORE,
@@ -15760,12 +15821,12 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 		wlc_phy_workarounds_nphy_gainctrl(pi);
 
 		pdetrange =
-		    (CHSPEC_IS5G(pi->radio_chanspec)) ? pi->srom_fem5g.
-		    pdetrange : pi->srom_fem2g.pdetrange;
+			(CHSPEC_IS5G(pi->radio_chanspec)) ? pi->srom_fem5g.
+			pdetrange : pi->srom_fem2g.pdetrange;
 
 		if (pdetrange == 0) {
 			chan_freq_range =
-			    wlc_phy_get_chan_freq_range_nphy(pi, 0);
+				wlc_phy_get_chan_freq_range_nphy(pi, 0);
 			if (chan_freq_range != WL_CHAN_FREQ_RANGE_2G) {
 				aux_adc_vmid_rev7_core0[3] = 0x70;
 				aux_adc_vmid_rev7_core1[3] = 0x70;
@@ -15793,15 +15854,15 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 					if (chan_freq_range ==
 					    WL_CHAN_FREQ_RANGE_2G) {
 						aux_adc_vmid_rev7_core0[3] =
-						    0x8c;
+							0x8c;
 						aux_adc_vmid_rev7_core1[3] =
-						    0x8c;
+							0x8c;
 						aux_adc_gain_rev7[3] = 0;
 					} else {
 						aux_adc_vmid_rev7_core0[3] =
-						    0x96;
+							0x96;
 						aux_adc_vmid_rev7_core1[3] =
-						    0x96;
+							0x96;
 						aux_adc_gain_rev7[3] = 0;
 					}
 				}
@@ -15886,15 +15947,15 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 				rfseq_rx2tx_dlys_rev3[5] = 59;
 				rfseq_rx2tx_dlys_rev3[6] = 1;
 				rfseq_rx2tx_events_rev3[7] =
-				    NPHY_REV3_RFSEQ_CMD_END;
+					NPHY_REV3_RFSEQ_CMD_END;
 			}
 
-			wlc_phy_set_rfseq_nphy(pi, NPHY_RFSEQ_RX2TX,
-					       rfseq_rx2tx_events_rev3,
-					       rfseq_rx2tx_dlys_rev3,
-					       sizeof(rfseq_rx2tx_events_rev3) /
-					       sizeof(rfseq_rx2tx_events_rev3
-						      [0]));
+			wlc_phy_set_rfseq_nphy(
+				pi, NPHY_RFSEQ_RX2TX,
+				rfseq_rx2tx_events_rev3,
+				rfseq_rx2tx_dlys_rev3,
+				sizeof(rfseq_rx2tx_events_rev3)	/
+				sizeof(rfseq_rx2tx_events_rev3[0]));
 		}
 
 		if (CHSPEC_IS2G(pi->radio_chanspec))
@@ -15927,8 +15988,8 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 					 &dac_control);
 
 		pdetrange =
-		    (CHSPEC_IS5G(pi->radio_chanspec)) ? pi->srom_fem5g.
-		    pdetrange : pi->srom_fem2g.pdetrange;
+			(CHSPEC_IS5G(pi->radio_chanspec)) ? pi->srom_fem5g.
+			pdetrange : pi->srom_fem2g.pdetrange;
 
 		if (pdetrange == 0) {
 			if (NREV_GE(pi->pubpi.phy_rev, 4)) {
@@ -15939,7 +16000,7 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 				aux_adc_gain = aux_adc_gain_rev3;
 			}
 			chan_freq_range =
-			    wlc_phy_get_chan_freq_range_nphy(pi, 0);
+				wlc_phy_get_chan_freq_range_nphy(pi, 0);
 			if (chan_freq_range != WL_CHAN_FREQ_RANGE_2G) {
 				switch (chan_freq_range) {
 				case WL_CHAN_FREQ_RANGE_5GL:
@@ -15982,7 +16043,7 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 
 			if (NREV_GE(pi->pubpi.phy_rev, 6)) {
 				chan_freq_range =
-				    wlc_phy_get_chan_freq_range_nphy(pi, 0);
+					wlc_phy_get_chan_freq_range_nphy(pi, 0);
 				if (chan_freq_range != WL_CHAN_FREQ_RANGE_2G) {
 					bcm_adc_vmid[3] = 0x8e;
 					bcm_adc_gain[3] = 0x03;
@@ -16005,14 +16066,16 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 						 0x1c, 16, bcm_adc_gain);
 		} else if (pdetrange == 3) {
 			chan_freq_range =
-			    wlc_phy_get_chan_freq_range_nphy(pi, 0);
+				wlc_phy_get_chan_freq_range_nphy(pi, 0);
 			if ((NREV_GE(pi->pubpi.phy_rev, 4))
 			    && (chan_freq_range == WL_CHAN_FREQ_RANGE_2G)) {
 
 				u16 auxadc_vmid[] = {
-					0xa2, 0xb4, 0xb4, 0x270 };
+					0xa2, 0xb4, 0xb4, 0x270
+				};
 				u16 auxadc_gain[] = {
-					0x02, 0x02, 0x02, 0x00 };
+					0x02, 0x02, 0x02, 0x00
+				};
 
 				wlc_phy_table_write_nphy(pi,
 							 NPHY_TBL_ID_AFECTRL, 4,
@@ -16033,7 +16096,7 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 			u16 Vmid[2], Av[2];
 
 			chan_freq_range =
-			    wlc_phy_get_chan_freq_range_nphy(pi, 0);
+				wlc_phy_get_chan_freq_range_nphy(pi, 0);
 			if (chan_freq_range != WL_CHAN_FREQ_RANGE_2G) {
 				Vmid[0] = (pdetrange == 4) ? 0x8e : 0x89;
 				Vmid[1] = (pdetrange == 4) ? 0x96 : 0x89;
@@ -16104,8 +16167,8 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 				0x0);
 
 		triso =
-		    (CHSPEC_IS5G(pi->radio_chanspec)) ? pi->srom_fem5g.
-		    triso : pi->srom_fem2g.triso;
+			(CHSPEC_IS5G(pi->radio_chanspec)) ? pi->srom_fem5g.
+			triso : pi->srom_fem2g.triso;
 		if (triso == 7) {
 			wlc_phy_war_force_trsw_to_R_cliplo_nphy(pi, PHY_CORE_0);
 			wlc_phy_war_force_trsw_to_R_cliplo_nphy(pi, PHY_CORE_1);
@@ -16163,8 +16226,8 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 
 			if (pi->sh->boardflags2 & BFL2_SINGLEANT_CCK)
 				wlapi_bmac_mhf(pi->sh->physhim, MHF4,
-					MHF4_BPHY_TXCORE0,
-					MHF4_BPHY_TXCORE0, BRCM_BAND_ALL);
+					      MHF4_BPHY_TXCORE0,
+					      MHF4_BPHY_TXCORE0, BRCM_BAND_ALL);
 		}
 	} else {
 
@@ -16428,7 +16491,7 @@ static void wlc_phy_workarounds_nphy_gainctrl(struct brcms_phy *pi)
 	u8 triso;
 
 	triso = (CHSPEC_IS5G(pi->radio_chanspec)) ? pi->srom_fem5g.triso :
-	    pi->srom_fem2g.triso;
+		pi->srom_fem2g.triso;
 
 	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 		if (pi->pubpi.radiorev == 5) {
@@ -16460,20 +16523,20 @@ static void wlc_phy_workarounds_nphy_gainctrl(struct brcms_phy *pi)
 		mod_phy_reg(pi, 0x32, (0x1 << 13), (1 << 13));
 
 		currband =
-		    read_phy_reg(pi, 0x09) & NPHY_BandControl_currentBand;
+			read_phy_reg(pi, 0x09) & NPHY_BandControl_currentBand;
 		if (currband == 0) {
 			if (NREV_GE(pi->pubpi.phy_rev, 6)) {
 				if (pi->pubpi.radiorev == 11) {
 					lna1_gain_db = lna1G_gain_db_rev6_224B0;
 					lna2_gain_db = lna2G_gain_db_rev6_224B0;
 					rfseq_init_gain =
-					    rfseqG_init_gain_rev6_224B0;
+						rfseqG_init_gain_rev6_224B0;
 					init_gaincode =
-					    initG_gaincode_rev6_224B0;
+						initG_gaincode_rev6_224B0;
 					clip1hi_gaincode =
-					    clip1hiG_gaincode_rev6;
+						clip1hiG_gaincode_rev6;
 					clip1lo_gaincode =
-					    clip1loG_gaincode_rev6_224B0;
+						clip1loG_gaincode_rev6_224B0;
 					nbclip_th = nbclipG_th_rev6;
 					w1clip_th = w1clipG_th_rev6;
 					crsmin_th = crsminG_th_rev6;
@@ -16486,51 +16549,59 @@ static void wlc_phy_workarounds_nphy_gainctrl(struct brcms_phy *pi)
 					if (pi->sh->boardflags & BFL_EXTLNA) {
 
 						rfseq_init_gain =
-						    rfseqG_init_gain_rev6_elna;
+						     rfseqG_init_gain_rev6_elna;
 						init_gaincode =
-						    initG_gaincode_rev6_elna;
+						       initG_gaincode_rev6_elna;
 					} else {
 						rfseq_init_gain =
-						    rfseqG_init_gain_rev6;
+							rfseqG_init_gain_rev6;
 						init_gaincode =
-						    initG_gaincode_rev6;
+							initG_gaincode_rev6;
 					}
 					clip1hi_gaincode =
-					    clip1hiG_gaincode_rev6;
+						clip1hiG_gaincode_rev6;
 					switch (triso) {
 					case 0:
 						clip1lo_gaincode =
-						    clip1loG_gaincode_rev6[0];
+							clip1loG_gaincode_rev6
+							[0];
 						break;
 					case 1:
 						clip1lo_gaincode =
-						    clip1loG_gaincode_rev6[1];
+							clip1loG_gaincode_rev6
+							[1];
 						break;
 					case 2:
 						clip1lo_gaincode =
-						    clip1loG_gaincode_rev6[2];
+							clip1loG_gaincode_rev6
+							[2];
 						break;
 					case 3:
 					default:
 
 						clip1lo_gaincode =
-						    clip1loG_gaincode_rev6[3];
+							clip1loG_gaincode_rev6
+							[3];
 						break;
 					case 4:
 						clip1lo_gaincode =
-						    clip1loG_gaincode_rev6[4];
+							clip1loG_gaincode_rev6
+							[4];
 						break;
 					case 5:
 						clip1lo_gaincode =
-						    clip1loG_gaincode_rev6[5];
+							clip1loG_gaincode_rev6
+							[5];
 						break;
 					case 6:
 						clip1lo_gaincode =
-						    clip1loG_gaincode_rev6[6];
+							clip1loG_gaincode_rev6
+							[6];
 						break;
 					case 7:
 						clip1lo_gaincode =
-						    clip1loG_gaincode_rev6[7];
+							clip1loG_gaincode_rev6
+							[7];
 						break;
 					}
 					nbclip_th = nbclipG_th_rev6;
@@ -16546,9 +16617,9 @@ static void wlc_phy_workarounds_nphy_gainctrl(struct brcms_phy *pi)
 				if (pi->sh->boardflags & BFL_EXTLNA) {
 
 					rfseq_init_gain =
-					    rfseqG_init_gain_rev5_elna;
+						rfseqG_init_gain_rev5_elna;
 					init_gaincode =
-					    initG_gaincode_rev5_elna;
+						initG_gaincode_rev5_elna;
 				} else {
 					rfseq_init_gain = rfseqG_init_gain_rev5;
 					init_gaincode = initG_gaincode_rev5;
@@ -16557,40 +16628,40 @@ static void wlc_phy_workarounds_nphy_gainctrl(struct brcms_phy *pi)
 				switch (triso) {
 				case 0:
 					clip1lo_gaincode =
-					    clip1loG_gaincode_rev5[0];
+						clip1loG_gaincode_rev5[0];
 					break;
 				case 1:
 					clip1lo_gaincode =
-					    clip1loG_gaincode_rev5[1];
+						clip1loG_gaincode_rev5[1];
 					break;
 				case 2:
 					clip1lo_gaincode =
-					    clip1loG_gaincode_rev5[2];
+						clip1loG_gaincode_rev5[2];
 					break;
 				case 3:
 
 					clip1lo_gaincode =
-					    clip1loG_gaincode_rev5[3];
+						clip1loG_gaincode_rev5[3];
 					break;
 				case 4:
 					clip1lo_gaincode =
-					    clip1loG_gaincode_rev5[4];
+						clip1loG_gaincode_rev5[4];
 					break;
 				case 5:
 					clip1lo_gaincode =
-					    clip1loG_gaincode_rev5[5];
+						clip1loG_gaincode_rev5[5];
 					break;
 				case 6:
 					clip1lo_gaincode =
-					    clip1loG_gaincode_rev5[6];
+						clip1loG_gaincode_rev5[6];
 					break;
 				case 7:
 					clip1lo_gaincode =
-					    clip1loG_gaincode_rev5[7];
+						clip1loG_gaincode_rev5[7];
 					break;
 				default:
 					clip1lo_gaincode =
-					    clip1loG_gaincode_rev5[3];
+						clip1loG_gaincode_rev5[3];
 					break;
 				}
 				nbclip_th = nbclipG_th_rev5;
@@ -16673,9 +16744,9 @@ static void wlc_phy_workarounds_nphy_gainctrl(struct brcms_phy *pi)
 				if (pi->sh->boardflags & BFL_EXTLNA_5GHz) {
 
 					rfseq_init_gain =
-					    rfseqA_init_gain_rev4_elna;
+						rfseqA_init_gain_rev4_elna;
 					init_gaincode =
-					    initA_gaincode_rev4_elna;
+						initA_gaincode_rev4_elna;
 				} else {
 					rfseq_init_gain = rfseqA_init_gain_rev4;
 					init_gaincode = initA_gaincode_rev4;
@@ -17017,7 +17088,7 @@ static void wlc_phy_workarounds_nphy_gainctrl_2057_rev6(struct brcms_phy *pi)
 
 				s8 lna1A_gain_db_rev7[] = { 11, 16, 20, 24 };
 				s8 lna1A_gain_db_2_rev7[] = {
-					11, 17, 22, 25 };
+					11, 17, 22, 25};
 				s8 lna2A_gain_db_rev7[] = { -1, 6, 10, 14 };
 
 				crsminu_th = 0x3e;
@@ -17028,7 +17099,7 @@ static void wlc_phy_workarounds_nphy_gainctrl_2057_rev6(struct brcms_phy *pi)
 
 				s8 lna1A_gain_db_rev7[] = { 11, 17, 21, 25 };
 				s8 lna1A_gain_db_2_rev7[] = {
-					12, 18, 22, 26 };
+					12, 18, 22, 26};
 				s8 lna2A_gain_db_rev7[] = { 1, 8, 12, 16 };
 
 				crsminu_th = 0x45;
@@ -17042,7 +17113,7 @@ static void wlc_phy_workarounds_nphy_gainctrl_2057_rev6(struct brcms_phy *pi)
 
 				s8 lna1A_gain_db_rev7[] = { 12, 18, 22, 26 };
 				s8 lna1A_gain_db_2_rev7[] = {
-					12, 18, 22, 26 };
+					12, 18, 22, 26};
 				s8 lna2A_gain_db_rev7[] = { -1, 6, 10, 14 };
 
 				crsminu_th = 0x41;
@@ -17167,15 +17238,15 @@ static void wlc_phy_adjust_lnagaintbl_nphy(struct brcms_phy *pi)
 
 			curr_channel = CHSPEC_CHANNEL(pi->radio_chanspec);
 			gain_delta[0] =
-			    (s16)
-			    PHY_HW_ROUND(((nphy_lnagain_est0[0] *
-					   curr_channel) +
-					  nphy_lnagain_est0[1]), 13);
+				(s16)
+				PHY_HW_ROUND(((nphy_lnagain_est0[0] *
+					       curr_channel) +
+					      nphy_lnagain_est0[1]), 13);
 			gain_delta[1] =
-			    (s16)
-			    PHY_HW_ROUND(((nphy_lnagain_est1[0] *
-					   curr_channel) +
-					  nphy_lnagain_est1[1]), 13);
+				(s16)
+				PHY_HW_ROUND(((nphy_lnagain_est1[0] *
+					       curr_channel) +
+					      nphy_lnagain_est1[1]), 13);
 		}
 	} else {
 
@@ -17193,12 +17264,13 @@ static void wlc_phy_adjust_lnagaintbl_nphy(struct brcms_phy *pi)
 		} else {
 			for (ctr = 0; ctr < 4; ctr++)
 				regval[ctr] =
-				    nphy_def_lnagains[ctr] + gain_delta[core];
+					nphy_def_lnagains[ctr] +
+					gain_delta[core];
 		}
 		wlc_phy_table_write_nphy(pi, core, 4, 8, 16, regval);
 
 		minmax_gain[core] =
-		    (u16) (nphy_def_lnagains[2] + gain_delta[core] + 4);
+			(u16) (nphy_def_lnagains[2] + gain_delta[core] + 4);
 	}
 
 	mod_phy_reg(pi, 0x1e, (0xff << 0), (minmax_gain[0] << 0));
@@ -17336,7 +17408,7 @@ static void wlc_phy_radio_postinit_2055(struct brcms_phy *pi)
 		   RADIO_2055_RCAL_DONE) != RADIO_2055_RCAL_DONE), 2000);
 
 	if (WARN((read_radio_reg(pi, RADIO_2055_CAL_COUNTER_OUT2) &
-		 RADIO_2055_RCAL_DONE) != RADIO_2055_RCAL_DONE,
+		  RADIO_2055_RCAL_DONE) != RADIO_2055_RCAL_DONE,
 		 "HW error: radio calibration1\n"))
 		return;
 
@@ -17551,34 +17623,32 @@ wlc_phy_chan2freq_nphy(struct brcms_phy *pi, uint channel, int *f,
 				if (pi->pubpi.radiover == 0x0) {
 
 					chan_info_tbl_p_2 =
-					    chan_info_nphyrev8_2057_rev5;
-					tbl_len =
-					    ARRAY_SIZE
-					    (chan_info_nphyrev8_2057_rev5);
+						chan_info_nphyrev8_2057_rev5;
+					tbl_len = ARRAY_SIZE(
+						  chan_info_nphyrev8_2057_rev5);
 
 				} else if (pi->pubpi.radiover == 0x1) {
 
 					chan_info_tbl_p_2 =
-					    chan_info_nphyrev9_2057_rev5v1;
-					tbl_len =
-					    ARRAY_SIZE
-					    (chan_info_nphyrev9_2057_rev5v1);
+						chan_info_nphyrev9_2057_rev5v1;
+					tbl_len = ARRAY_SIZE(
+						chan_info_nphyrev9_2057_rev5v1);
 
 				}
 				break;
 
 			case 7:
 				chan_info_tbl_p_0 =
-				    chan_info_nphyrev8_2057_rev7;
-				tbl_len =
-				    ARRAY_SIZE(chan_info_nphyrev8_2057_rev7);
+					chan_info_nphyrev8_2057_rev7;
+				tbl_len = ARRAY_SIZE(
+						  chan_info_nphyrev8_2057_rev7);
 				break;
 
 			case 8:
 				chan_info_tbl_p_0 =
-				    chan_info_nphyrev8_2057_rev8;
-				tbl_len =
-				    ARRAY_SIZE(chan_info_nphyrev8_2057_rev8);
+					chan_info_nphyrev8_2057_rev8;
+				tbl_len = ARRAY_SIZE(
+						  chan_info_nphyrev8_2057_rev8);
 				break;
 
 			default:
@@ -17640,7 +17710,7 @@ wlc_phy_chan2freq_nphy(struct brcms_phy *pi, uint channel, int *f,
 			case 9:
 				chan_info_tbl_p_1 = chan_info_nphyrev5n6_2056v7;
 				tbl_len =
-				    ARRAY_SIZE(chan_info_nphyrev5n6_2056v7);
+					ARRAY_SIZE(chan_info_nphyrev5n6_2056v7);
 				break;
 			case 8:
 				chan_info_tbl_p_1 = chan_info_nphyrev6_2056v8;
@@ -17648,7 +17718,8 @@ wlc_phy_chan2freq_nphy(struct brcms_phy *pi, uint channel, int *f,
 				break;
 			case 11:
 				chan_info_tbl_p_1 = chan_info_nphyrev6_2056v11;
-				tbl_len = ARRAY_SIZE(chan_info_nphyrev6_2056v11);
+				tbl_len = ARRAY_SIZE(
+						    chan_info_nphyrev6_2056v11);
 				break;
 			default:
 				if (NORADIO_ENAB(pi->pubpi))
@@ -17684,7 +17755,7 @@ wlc_phy_chan2freq_nphy(struct brcms_phy *pi, uint channel, int *f,
 	*f = freq;
 	return true;
 
- fail:
+fail:
 	*f = WL_CHAN_FREQ_RANGE_2G;
 	return false;
 }
@@ -18174,8 +18245,10 @@ static u16 wlc_phy_radio205x_rcal(struct brcms_phy *pi)
 		u16 savereg;
 
 		savereg =
-		    read_radio_reg(pi,
-				   RADIO_2056_SYN_PLL_MAST2 | RADIO_2056_SYN);
+			read_radio_reg(
+				pi,
+				RADIO_2056_SYN_PLL_MAST2 |
+				RADIO_2056_SYN);
 		write_radio_reg(pi, RADIO_2056_SYN_PLL_MAST2 | RADIO_2056_SYN,
 				savereg | 0x7);
 		udelay(10);
@@ -18188,9 +18261,10 @@ static u16 wlc_phy_radio205x_rcal(struct brcms_phy *pi)
 				0x9);
 
 		for (i = 0; i < MAX_205x_RCAL_WAITLOOPS; i++) {
-			rcal_reg = read_radio_reg(pi,
-						  RADIO_2056_SYN_RCAL_CODE_OUT |
-						  RADIO_2056_SYN);
+			rcal_reg = read_radio_reg(
+				pi,
+				RADIO_2056_SYN_RCAL_CODE_OUT |
+				RADIO_2056_SYN);
 			if (rcal_reg & 0x80)
 				break;
 
@@ -18205,9 +18279,9 @@ static u16 wlc_phy_radio205x_rcal(struct brcms_phy *pi)
 				0x1);
 
 		rcal_reg =
-		    read_radio_reg(pi,
-				   RADIO_2056_SYN_RCAL_CODE_OUT |
-				   RADIO_2056_SYN);
+			read_radio_reg(pi,
+				       RADIO_2056_SYN_RCAL_CODE_OUT |
+				       RADIO_2056_SYN);
 
 		write_radio_reg(pi, RADIO_2056_SYN_RCAL_MASTER | RADIO_2056_SYN,
 				0x0);
@@ -18221,9 +18295,11 @@ static u16 wlc_phy_radio205x_rcal(struct brcms_phy *pi)
 }
 
 static void
-wlc_phy_chanspec_radio2057_setup(struct brcms_phy *pi,
-			const struct chan_info_nphy_radio2057 *ci,
-			const struct chan_info_nphy_radio2057_rev5 *ci2)
+wlc_phy_chanspec_radio2057_setup(
+	struct brcms_phy *pi,
+	const struct chan_info_nphy_radio2057 *ci,
+	const struct chan_info_nphy_radio2057_rev5 *
+	ci2)
 {
 	int coreNum;
 	u16 txmix2g_tune_boost_pu = 0;
@@ -18534,15 +18610,15 @@ wlc_phy_adjust_min_noisevar_nphy(struct brcms_phy *pi, int ntones,
 	u32 offset;
 	int tone_id;
 	int tbllen =
-	    CHSPEC_IS40(pi->
-			radio_chanspec) ? NPHY_NOISEVAR_TBLLEN40 :
-	    NPHY_NOISEVAR_TBLLEN20;
+		CHSPEC_IS40(pi->radio_chanspec) ?
+		NPHY_NOISEVAR_TBLLEN40 : NPHY_NOISEVAR_TBLLEN20;
 
 	if (pi->nphy_noisevars_adjusted) {
 		for (i = 0; i < pi->nphy_saved_noisevars.bufcount; i++) {
 			tone_id = pi->nphy_saved_noisevars.tone_id[i];
 			offset = (tone_id >= 0) ?
-			    ((tone_id * 2) + 1) : (tbllen + (tone_id * 2) + 1);
+				 ((tone_id *
+				   2) + 1) : (tbllen + (tone_id * 2) + 1);
 			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1,
 						 offset, 32,
 						 (void *)&pi->
@@ -18560,7 +18636,8 @@ wlc_phy_adjust_min_noisevar_nphy(struct brcms_phy *pi, int ntones,
 		for (i = 0; i < ntones; i++) {
 			tone_id = tone_id_buf[i];
 			offset = (tone_id >= 0) ?
-			    ((tone_id * 2) + 1) : (tbllen + (tone_id * 2) + 1);
+				 ((tone_id * 2) + 1) :
+				 (tbllen + (tone_id * 2) + 1);
 			pi->nphy_saved_noisevars.tone_id[i] = tone_id;
 			wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1,
 						offset, 32,
@@ -18681,15 +18758,17 @@ static void wlc_phy_spurwar_nphy(struct brcms_phy *pi)
 
 		if (pi->nphy_gband_spurwar_en) {
 
-			wlc_phy_adjust_rx_analpfbw_nphy(pi,
-							NPHY_ANARXLPFBW_REDUCTIONFACT);
+			wlc_phy_adjust_rx_analpfbw_nphy(
+				pi,
+				NPHY_ANARXLPFBW_REDUCTIONFACT);
 
 			if (CHSPEC_IS2G(pi->radio_chanspec)) {
 				if ((cur_channel == 11)
 				    && CHSPEC_IS40(pi->radio_chanspec))
-					wlc_phy_adjust_min_noisevar_nphy(pi, 2,
-									 nphy_adj_tone_id_buf,
-									 nphy_adj_noise_var_buf);
+					wlc_phy_adjust_min_noisevar_nphy(
+						pi, 2,
+						nphy_adj_tone_id_buf,
+						nphy_adj_noise_var_buf);
 				else
 					wlc_phy_adjust_min_noisevar_nphy(pi, 0,
 									 NULL,
@@ -18697,7 +18776,7 @@ static void wlc_phy_spurwar_nphy(struct brcms_phy *pi)
 			}
 
 			wlc_phy_adjust_crsminpwr_nphy(pi,
-						      NPHY_ADJUSTED_MINCRSPOWER);
+						     NPHY_ADJUSTED_MINCRSPOWER);
 		}
 
 		if ((pi->nphy_gband_spurwar2_en)
@@ -18769,12 +18848,13 @@ static void wlc_phy_spurwar_nphy(struct brcms_phy *pi)
 
 			if (isAdjustNoiseVar) {
 				numTonesAdjust = sizeof(nphy_adj_tone_id_buf) /
-				    sizeof(nphy_adj_tone_id_buf[0]);
+						sizeof(nphy_adj_tone_id_buf[0]);
 
-				wlc_phy_adjust_min_noisevar_nphy(pi,
-								 numTonesAdjust,
-								 nphy_adj_tone_id_buf,
-								 nphy_adj_noise_var_buf);
+				wlc_phy_adjust_min_noisevar_nphy(
+					pi,
+					numTonesAdjust,
+					nphy_adj_tone_id_buf,
+					nphy_adj_noise_var_buf);
 
 				tempval = 0;
 
@@ -18818,9 +18898,10 @@ static void wlc_phy_spurwar_nphy(struct brcms_phy *pi)
 
 			if (nphy_adj_tone_id_buf[0]
 			    && nphy_adj_noise_var_buf[0])
-				wlc_phy_adjust_min_noisevar_nphy(pi, 1,
-								 nphy_adj_tone_id_buf,
-								 nphy_adj_noise_var_buf);
+				wlc_phy_adjust_min_noisevar_nphy(
+					pi, 1,
+					nphy_adj_tone_id_buf,
+					nphy_adj_noise_var_buf);
 			else
 				wlc_phy_adjust_min_noisevar_nphy(pi, 0, NULL,
 								 NULL);
@@ -18902,8 +18983,8 @@ wlc_phy_chanspec_nphy_setup(struct brcms_phy *pi, u16 chanspec,
 				if ((val == 13) || (val == 14) || (val == 153))
 					spuravoid = 1;
 			} else if (((val >= 5) && (val <= 8)) || (val == 13)
-				    || (val == 14)) {
-					spuravoid = 1;
+				   || (val == 14)) {
+				spuravoid = 1;
 			}
 		} else if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 			if (val == 54)
@@ -18968,7 +19049,7 @@ void wlc_phy_chanspec_set_nphy(struct brcms_phy *pi, u16 chanspec)
 		return;
 
 	if (!wlc_phy_chan2freq_nphy
-	    (pi, CHSPEC_CHANNEL(chanspec), &freq, &t0, &t1, &t2, &t3))
+		    (pi, CHSPEC_CHANNEL(chanspec), &freq, &t0, &t1, &t2, &t3))
 		return;
 
 	wlc_phy_chanspec_radio_set((struct brcms_phy_pub *) pi, chanspec);
@@ -19030,8 +19111,8 @@ void wlc_phy_chanspec_set_nphy(struct brcms_phy *pi, u16 chanspec)
 
 		wlc_phy_chanspec_radio2055_setup(pi, t3);
 		wlc_phy_chanspec_nphy_setup(pi, chanspec,
-					    (const struct nphy_sfo_cfg *)&(t3->
-								      PHY_BW1a));
+					    (const struct nphy_sfo_cfg *)
+					     &(t3->PHY_BW1a));
 	}
 
 }
@@ -19053,51 +19134,51 @@ static void wlc_phy_savecal_nphy(struct brcms_phy *pi)
 
 		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 			txcal_radio_regs =
-			    pi->calibration_cache.txcal_radio_regs_2G;
+				pi->calibration_cache.txcal_radio_regs_2G;
 		} else if (NREV_GE(pi->pubpi.phy_rev, 3)) {
 
 			pi->calibration_cache.txcal_radio_regs_2G[0] =
-			    read_radio_reg(pi,
-					   RADIO_2056_TX_LOFT_FINE_I |
-					   RADIO_2056_TX0);
+				read_radio_reg(pi,
+					       RADIO_2056_TX_LOFT_FINE_I |
+					       RADIO_2056_TX0);
 			pi->calibration_cache.txcal_radio_regs_2G[1] =
-			    read_radio_reg(pi,
-					   RADIO_2056_TX_LOFT_FINE_Q |
-					   RADIO_2056_TX0);
+				read_radio_reg(pi,
+					       RADIO_2056_TX_LOFT_FINE_Q |
+					       RADIO_2056_TX0);
 			pi->calibration_cache.txcal_radio_regs_2G[2] =
-			    read_radio_reg(pi,
-					   RADIO_2056_TX_LOFT_FINE_I |
-					   RADIO_2056_TX1);
+				read_radio_reg(pi,
+					       RADIO_2056_TX_LOFT_FINE_I |
+					       RADIO_2056_TX1);
 			pi->calibration_cache.txcal_radio_regs_2G[3] =
-			    read_radio_reg(pi,
-					   RADIO_2056_TX_LOFT_FINE_Q |
-					   RADIO_2056_TX1);
+				read_radio_reg(pi,
+					       RADIO_2056_TX_LOFT_FINE_Q |
+					       RADIO_2056_TX1);
 
 			pi->calibration_cache.txcal_radio_regs_2G[4] =
-			    read_radio_reg(pi,
-					   RADIO_2056_TX_LOFT_COARSE_I |
-					   RADIO_2056_TX0);
+				read_radio_reg(pi,
+					       RADIO_2056_TX_LOFT_COARSE_I |
+					       RADIO_2056_TX0);
 			pi->calibration_cache.txcal_radio_regs_2G[5] =
-			    read_radio_reg(pi,
-					   RADIO_2056_TX_LOFT_COARSE_Q |
-					   RADIO_2056_TX0);
+				read_radio_reg(pi,
+					       RADIO_2056_TX_LOFT_COARSE_Q |
+					       RADIO_2056_TX0);
 			pi->calibration_cache.txcal_radio_regs_2G[6] =
-			    read_radio_reg(pi,
-					   RADIO_2056_TX_LOFT_COARSE_I |
-					   RADIO_2056_TX1);
+				read_radio_reg(pi,
+					       RADIO_2056_TX_LOFT_COARSE_I |
+					       RADIO_2056_TX1);
 			pi->calibration_cache.txcal_radio_regs_2G[7] =
-			    read_radio_reg(pi,
-					   RADIO_2056_TX_LOFT_COARSE_Q |
-					   RADIO_2056_TX1);
+				read_radio_reg(pi,
+					       RADIO_2056_TX_LOFT_COARSE_Q |
+					       RADIO_2056_TX1);
 		} else {
 			pi->calibration_cache.txcal_radio_regs_2G[0] =
-			    read_radio_reg(pi, RADIO_2055_CORE1_TX_VOS_CNCL);
+			       read_radio_reg(pi, RADIO_2055_CORE1_TX_VOS_CNCL);
 			pi->calibration_cache.txcal_radio_regs_2G[1] =
-			    read_radio_reg(pi, RADIO_2055_CORE2_TX_VOS_CNCL);
+			       read_radio_reg(pi, RADIO_2055_CORE2_TX_VOS_CNCL);
 			pi->calibration_cache.txcal_radio_regs_2G[2] =
-			    read_radio_reg(pi, RADIO_2055_CORE1_TX_BB_MXGM);
+			       read_radio_reg(pi, RADIO_2055_CORE1_TX_BB_MXGM);
 			pi->calibration_cache.txcal_radio_regs_2G[3] =
-			    read_radio_reg(pi, RADIO_2055_CORE2_TX_BB_MXGM);
+			       read_radio_reg(pi, RADIO_2055_CORE2_TX_BB_MXGM);
 		}
 
 		pi->nphy_iqcal_chanspec_2G = pi->radio_chanspec;
@@ -19110,51 +19191,51 @@ static void wlc_phy_savecal_nphy(struct brcms_phy *pi)
 
 		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 			txcal_radio_regs =
-			    pi->calibration_cache.txcal_radio_regs_5G;
+				pi->calibration_cache.txcal_radio_regs_5G;
 		} else if (NREV_GE(pi->pubpi.phy_rev, 3)) {
 
 			pi->calibration_cache.txcal_radio_regs_5G[0] =
-			    read_radio_reg(pi,
-					   RADIO_2056_TX_LOFT_FINE_I |
-					   RADIO_2056_TX0);
+				read_radio_reg(pi,
+					       RADIO_2056_TX_LOFT_FINE_I |
+					       RADIO_2056_TX0);
 			pi->calibration_cache.txcal_radio_regs_5G[1] =
-			    read_radio_reg(pi,
-					   RADIO_2056_TX_LOFT_FINE_Q |
-					   RADIO_2056_TX0);
+				read_radio_reg(pi,
+					       RADIO_2056_TX_LOFT_FINE_Q |
+					       RADIO_2056_TX0);
 			pi->calibration_cache.txcal_radio_regs_5G[2] =
-			    read_radio_reg(pi,
-					   RADIO_2056_TX_LOFT_FINE_I |
-					   RADIO_2056_TX1);
+				read_radio_reg(pi,
+					       RADIO_2056_TX_LOFT_FINE_I |
+					       RADIO_2056_TX1);
 			pi->calibration_cache.txcal_radio_regs_5G[3] =
-			    read_radio_reg(pi,
-					   RADIO_2056_TX_LOFT_FINE_Q |
-					   RADIO_2056_TX1);
+				read_radio_reg(pi,
+					       RADIO_2056_TX_LOFT_FINE_Q |
+					       RADIO_2056_TX1);
 
 			pi->calibration_cache.txcal_radio_regs_5G[4] =
-			    read_radio_reg(pi,
-					   RADIO_2056_TX_LOFT_COARSE_I |
-					   RADIO_2056_TX0);
+				read_radio_reg(pi,
+					       RADIO_2056_TX_LOFT_COARSE_I |
+					       RADIO_2056_TX0);
 			pi->calibration_cache.txcal_radio_regs_5G[5] =
-			    read_radio_reg(pi,
-					   RADIO_2056_TX_LOFT_COARSE_Q |
-					   RADIO_2056_TX0);
+				read_radio_reg(pi,
+					       RADIO_2056_TX_LOFT_COARSE_Q |
+					       RADIO_2056_TX0);
 			pi->calibration_cache.txcal_radio_regs_5G[6] =
-			    read_radio_reg(pi,
-					   RADIO_2056_TX_LOFT_COARSE_I |
-					   RADIO_2056_TX1);
+				read_radio_reg(pi,
+					       RADIO_2056_TX_LOFT_COARSE_I |
+					       RADIO_2056_TX1);
 			pi->calibration_cache.txcal_radio_regs_5G[7] =
-			    read_radio_reg(pi,
-					   RADIO_2056_TX_LOFT_COARSE_Q |
-					   RADIO_2056_TX1);
+				read_radio_reg(pi,
+					       RADIO_2056_TX_LOFT_COARSE_Q |
+					       RADIO_2056_TX1);
 		} else {
 			pi->calibration_cache.txcal_radio_regs_5G[0] =
-			    read_radio_reg(pi, RADIO_2055_CORE1_TX_VOS_CNCL);
+			       read_radio_reg(pi, RADIO_2055_CORE1_TX_VOS_CNCL);
 			pi->calibration_cache.txcal_radio_regs_5G[1] =
-			    read_radio_reg(pi, RADIO_2055_CORE2_TX_VOS_CNCL);
+			       read_radio_reg(pi, RADIO_2055_CORE2_TX_VOS_CNCL);
 			pi->calibration_cache.txcal_radio_regs_5G[2] =
-			    read_radio_reg(pi, RADIO_2055_CORE1_TX_BB_MXGM);
+			       read_radio_reg(pi, RADIO_2055_CORE1_TX_BB_MXGM);
 			pi->calibration_cache.txcal_radio_regs_5G[3] =
-			    read_radio_reg(pi, RADIO_2055_CORE2_TX_BB_MXGM);
+			       read_radio_reg(pi, RADIO_2055_CORE2_TX_BB_MXGM);
 		}
 
 		pi->nphy_iqcal_chanspec_5G = pi->radio_chanspec;
@@ -19164,18 +19245,18 @@ static void wlc_phy_savecal_nphy(struct brcms_phy *pi)
 		for (coreNum = 0; coreNum <= 1; coreNum++) {
 
 			txcal_radio_regs[2 * coreNum] =
-			    READ_RADIO_REG3(pi, RADIO_2057, TX, coreNum,
-					    LOFT_FINE_I);
+				READ_RADIO_REG3(pi, RADIO_2057, TX, coreNum,
+						LOFT_FINE_I);
 			txcal_radio_regs[2 * coreNum + 1] =
-			    READ_RADIO_REG3(pi, RADIO_2057, TX, coreNum,
-					    LOFT_FINE_Q);
+				READ_RADIO_REG3(pi, RADIO_2057, TX, coreNum,
+						LOFT_FINE_Q);
 
 			txcal_radio_regs[2 * coreNum + 4] =
-			    READ_RADIO_REG3(pi, RADIO_2057, TX, coreNum,
-					    LOFT_COARSE_I);
+				READ_RADIO_REG3(pi, RADIO_2057, TX, coreNum,
+						LOFT_COARSE_I);
 			txcal_radio_regs[2 * coreNum + 5] =
-			    READ_RADIO_REG3(pi, RADIO_2057, TX, coreNum,
-					    LOFT_COARSE_Q);
+				READ_RADIO_REG3(pi, RADIO_2057, TX, coreNum,
+						LOFT_COARSE_Q);
 		}
 	}
 
@@ -19235,7 +19316,7 @@ static void wlc_phy_restorecal_nphy(struct brcms_phy *pi)
 	if (CHSPEC_IS2G(pi->radio_chanspec)) {
 		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 			txcal_radio_regs =
-			    pi->calibration_cache.txcal_radio_regs_2G;
+				pi->calibration_cache.txcal_radio_regs_2G;
 		} else if (NREV_GE(pi->pubpi.phy_rev, 3)) {
 
 			write_radio_reg(pi,
@@ -19300,7 +19381,7 @@ static void wlc_phy_restorecal_nphy(struct brcms_phy *pi)
 	} else {
 		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 			txcal_radio_regs =
-			    pi->calibration_cache.txcal_radio_regs_5G;
+				pi->calibration_cache.txcal_radio_regs_5G;
 		} else if (NREV_GE(pi->pubpi.phy_rev, 3)) {
 
 			write_radio_reg(pi,
@@ -19451,8 +19532,8 @@ u16 wlc_phy_classifier_nphy(struct brcms_phy *pi, u16 mask, u16 val)
 
 	if (D11REV_IS(pi->sh->corerev, 16)) {
 		suspended =
-		    (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC) ?
-		    false : true;
+			(R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC) ?
+			false : true;
 		if (!suspended)
 			wlapi_suspend_mac_and_wait(pi->sh->physhim);
 	}
@@ -19532,8 +19613,8 @@ wlc_phy_set_rfseq_nphy(struct brcms_phy *pi, u8 cmd, u8 *events, u8 *dlys,
 	u32 t1_offset, t2_offset;
 	u8 ctr;
 	u8 end_event =
-	    NREV_GE(pi->pubpi.phy_rev,
-		    3) ? NPHY_REV3_RFSEQ_CMD_END : NPHY_RFSEQ_CMD_END;
+		NREV_GE(pi->pubpi.phy_rev,
+			3) ? NPHY_REV3_RFSEQ_CMD_END : NPHY_RFSEQ_CMD_END;
 	u8 end_dly = 1;
 
 	if (pi->phyhang_avoid)
@@ -19596,77 +19677,77 @@ wlc_phy_rfctrl_override_nphy_rev7(struct brcms_phy *pi, u16 field, u16 value,
 				case (0x1 << 2):
 					en_addr = (core_num == 0) ? 0xe7 : 0xec;
 					val_addr = (core_num == 0) ? 0x7a :
-					    0x7d;
+						   0x7d;
 					val_mask = (0x1 << 1);
 					val_shift = 1;
 					break;
 				case (0x1 << 3):
 					en_addr = (core_num == 0) ? 0xe7 : 0xec;
 					val_addr = (core_num == 0) ? 0x7a :
-					    0x7d;
+						   0x7d;
 					val_mask = (0x1 << 2);
 					val_shift = 2;
 					break;
 				case (0x1 << 4):
 					en_addr = (core_num == 0) ? 0xe7 : 0xec;
 					val_addr = (core_num == 0) ? 0x7a :
-					    0x7d;
+						   0x7d;
 					val_mask = (0x1 << 4);
 					val_shift = 4;
 					break;
 				case (0x1 << 5):
 					en_addr = (core_num == 0) ? 0xe7 : 0xec;
 					val_addr = (core_num == 0) ? 0x7a :
-					    0x7d;
+						   0x7d;
 					val_mask = (0x1 << 5);
 					val_shift = 5;
 					break;
 				case (0x1 << 6):
 					en_addr = (core_num == 0) ? 0xe7 : 0xec;
 					val_addr = (core_num == 0) ? 0x7a :
-					    0x7d;
+						   0x7d;
 					val_mask = (0x1 << 6);
 					val_shift = 6;
 					break;
 				case (0x1 << 7):
 					en_addr = (core_num == 0) ? 0xe7 : 0xec;
 					val_addr = (core_num == 0) ? 0x7a :
-					    0x7d;
+						   0x7d;
 					val_mask = (0x1 << 7);
 					val_shift = 7;
 					break;
 				case (0x1 << 10):
 					en_addr = (core_num == 0) ? 0xe7 : 0xec;
 					val_addr = (core_num == 0) ? 0xf8 :
-					    0xfa;
+						   0xfa;
 					val_mask = (0x7 << 4);
 					val_shift = 4;
 					break;
 				case (0x1 << 11):
 					en_addr = (core_num == 0) ? 0xe7 : 0xec;
 					val_addr = (core_num == 0) ? 0x7b :
-					    0x7e;
+						   0x7e;
 					val_mask = (0xffff << 0);
 					val_shift = 0;
 					break;
 				case (0x1 << 12):
 					en_addr = (core_num == 0) ? 0xe7 : 0xec;
 					val_addr = (core_num == 0) ? 0x7c :
-					    0x7f;
+						   0x7f;
 					val_mask = (0xffff << 0);
 					val_shift = 0;
 					break;
 				case (0x3 << 13):
 					en_addr = (core_num == 0) ? 0xe7 : 0xec;
 					val_addr = (core_num == 0) ? 0x348 :
-					    0x349;
+						   0x349;
 					val_mask = (0xff << 0);
 					val_shift = 0;
 					break;
 				case (0x1 << 13):
 					en_addr = (core_num == 0) ? 0xe7 : 0xec;
 					val_addr = (core_num == 0) ? 0x348 :
-					    0x349;
+						   0x349;
 					val_mask = (0xf << 0);
 					val_shift = 0;
 					break;
@@ -19674,104 +19755,105 @@ wlc_phy_rfctrl_override_nphy_rev7(struct brcms_phy *pi, u16 field, u16 value,
 					addr = 0xffff;
 					break;
 				}
-			} else if (override_id == NPHY_REV7_RFCTRLOVERRIDE_ID1) {
+			} else if (override_id ==
+				   NPHY_REV7_RFCTRLOVERRIDE_ID1) {
 
 				switch (field) {
 				case (0x1 << 1):
 					en_addr = (core_num == 0) ? 0x342 :
-					    0x343;
+						  0x343;
 					val_addr = (core_num == 0) ? 0x340 :
-					    0x341;
+						   0x341;
 					val_mask = (0x1 << 1);
 					val_shift = 1;
 					break;
 				case (0x1 << 3):
 					en_addr = (core_num == 0) ? 0x342 :
-					    0x343;
+						  0x343;
 					val_addr = (core_num == 0) ? 0x340 :
-					    0x341;
+						   0x341;
 					val_mask = (0x1 << 3);
 					val_shift = 3;
 					break;
 				case (0x1 << 5):
 					en_addr = (core_num == 0) ? 0x342 :
-					    0x343;
+						  0x343;
 					val_addr = (core_num == 0) ? 0x340 :
-					    0x341;
+						   0x341;
 					val_mask = (0x1 << 5);
 					val_shift = 5;
 					break;
 				case (0x1 << 4):
 					en_addr = (core_num == 0) ? 0x342 :
-					    0x343;
+						  0x343;
 					val_addr = (core_num == 0) ? 0x340 :
-					    0x341;
+						   0x341;
 					val_mask = (0x1 << 4);
 					val_shift = 4;
 					break;
 				case (0x1 << 2):
 
 					en_addr = (core_num == 0) ? 0x342 :
-					    0x343;
+						  0x343;
 					val_addr = (core_num == 0) ? 0x340 :
-					    0x341;
+						   0x341;
 					val_mask = (0x1 << 2);
 					val_shift = 2;
 					break;
 				case (0x1 << 7):
 
 					en_addr = (core_num == 0) ? 0x342 :
-					    0x343;
+						  0x343;
 					val_addr = (core_num == 0) ? 0x340 :
-					    0x341;
+						   0x341;
 					val_mask = (0x7 << 8);
 					val_shift = 8;
 					break;
 				case (0x1 << 11):
 					en_addr = (core_num == 0) ? 0x342 :
-					    0x343;
+						  0x343;
 					val_addr = (core_num == 0) ? 0x340 :
-					    0x341;
+						   0x341;
 					val_mask = (0x1 << 14);
 					val_shift = 14;
 					break;
 				case (0x1 << 10):
 					en_addr = (core_num == 0) ? 0x342 :
-					    0x343;
+						  0x343;
 					val_addr = (core_num == 0) ? 0x340 :
-					    0x341;
+						   0x341;
 					val_mask = (0x1 << 13);
 					val_shift = 13;
 					break;
 				case (0x1 << 9):
 					en_addr = (core_num == 0) ? 0x342 :
-					    0x343;
+						  0x343;
 					val_addr = (core_num == 0) ? 0x340 :
-					    0x341;
+						   0x341;
 					val_mask = (0x1 << 12);
 					val_shift = 12;
 					break;
 				case (0x1 << 8):
 					en_addr = (core_num == 0) ? 0x342 :
-					    0x343;
+						  0x343;
 					val_addr = (core_num == 0) ? 0x340 :
-					    0x341;
+						   0x341;
 					val_mask = (0x1 << 11);
 					val_shift = 11;
 					break;
 				case (0x1 << 6):
 					en_addr = (core_num == 0) ? 0x342 :
-					    0x343;
+						  0x343;
 					val_addr = (core_num == 0) ? 0x340 :
-					    0x341;
+						   0x341;
 					val_mask = (0x1 << 6);
 					val_shift = 6;
 					break;
 				case (0x1 << 0):
 					en_addr = (core_num == 0) ? 0x342 :
-					    0x343;
+						  0x343;
 					val_addr = (core_num == 0) ? 0x340 :
-					    0x341;
+						   0x341;
 					val_mask = (0x1 << 0);
 					val_shift = 0;
 					break;
@@ -19779,46 +19861,47 @@ wlc_phy_rfctrl_override_nphy_rev7(struct brcms_phy *pi, u16 field, u16 value,
 					addr = 0xffff;
 					break;
 				}
-			} else if (override_id == NPHY_REV7_RFCTRLOVERRIDE_ID2) {
+			} else if (override_id ==
+				   NPHY_REV7_RFCTRLOVERRIDE_ID2) {
 
 				switch (field) {
 				case (0x1 << 3):
 					en_addr = (core_num == 0) ? 0x346 :
-					    0x347;
+						  0x347;
 					val_addr = (core_num == 0) ? 0x344 :
-					    0x345;
+						   0x345;
 					val_mask = (0x1 << 3);
 					val_shift = 3;
 					break;
 				case (0x1 << 1):
 					en_addr = (core_num == 0) ? 0x346 :
-					    0x347;
+						  0x347;
 					val_addr = (core_num == 0) ? 0x344 :
-					    0x345;
+						   0x345;
 					val_mask = (0x1 << 1);
 					val_shift = 1;
 					break;
 				case (0x1 << 0):
 					en_addr = (core_num == 0) ? 0x346 :
-					    0x347;
+						  0x347;
 					val_addr = (core_num == 0) ? 0x344 :
-					    0x345;
+						   0x345;
 					val_mask = (0x1 << 0);
 					val_shift = 0;
 					break;
 				case (0x1 << 2):
 					en_addr = (core_num == 0) ? 0x346 :
-					    0x347;
+						  0x347;
 					val_addr = (core_num == 0) ? 0x344 :
-					    0x345;
+						   0x345;
 					val_mask = (0x1 << 2);
 					val_shift = 2;
 					break;
 				case (0x1 << 4):
 					en_addr = (core_num == 0) ? 0x346 :
-					    0x347;
+						  0x347;
 					val_addr = (core_num == 0) ? 0x344 :
-					    0x345;
+						   0x345;
 					val_mask = (0x1 << 4);
 					val_shift = 4;
 					break;
@@ -19854,7 +19937,7 @@ wlc_phy_rfctrl_override_nphy(struct brcms_phy *pi, u16 field, u16 value,
 {
 	u8 core_num;
 	u16 addr = 0, mask = 0, en_addr = 0, val_addr = 0, en_mask =
-	    0, val_mask = 0;
+		0, val_mask = 0;
 	u8 shift = 0, val_shift = 0;
 
 	if (NREV_GE(pi->pubpi.phy_rev, 3) && NREV_LT(pi->pubpi.phy_rev, 7)) {
@@ -20103,76 +20186,93 @@ wlc_phy_rfctrl_override_1tomany_nphy(struct brcms_phy *pi, u16 cmd, u16 value,
 
 		switch (cmd) {
 		case NPHY_REV7_RfctrlOverride_cmd_rxrf_pu:
-			wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 5),
-							  value, core_mask, off,
-							  NPHY_REV7_RFCTRLOVERRIDE_ID1);
-			wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 4), value,
-							  core_mask, off,
-							  NPHY_REV7_RFCTRLOVERRIDE_ID1);
-			wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 3), value,
-							  core_mask, off,
-							  NPHY_REV7_RFCTRLOVERRIDE_ID1);
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
 			break;
 		case NPHY_REV7_RfctrlOverride_cmd_rx_pu:
-			wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 2),
-							  value, core_mask, off,
-							  NPHY_REV7_RFCTRLOVERRIDE_ID1);
-			wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 1), value,
-							  core_mask, off,
-							  NPHY_REV7_RFCTRLOVERRIDE_ID1);
-			wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 0), value,
-							  core_mask, off,
-							  NPHY_REV7_RFCTRLOVERRIDE_ID1);
-			wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 1), value,
-							  core_mask, off,
-							  NPHY_REV7_RFCTRLOVERRIDE_ID2);
-			wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 11), 0,
-							  core_mask, off,
-							  NPHY_REV7_RFCTRLOVERRIDE_ID1);
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
 			break;
 		case NPHY_REV7_RfctrlOverride_cmd_tx_pu:
-			wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 2),
-							  value, core_mask, off,
-							  NPHY_REV7_RFCTRLOVERRIDE_ID0);
-			wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 1), value,
-							  core_mask, off,
-							  NPHY_REV7_RFCTRLOVERRIDE_ID1);
-			wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 0), value,
-							  core_mask, off,
-							  NPHY_REV7_RFCTRLOVERRIDE_ID2);
-			wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 2), value,
-							  core_mask, off,
-							  NPHY_REV7_RFCTRLOVERRIDE_ID2);
-			wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 11), 1,
-							  core_mask, off,
-							  NPHY_REV7_RFCTRLOVERRIDE_ID1);
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
 			break;
 		case NPHY_REV7_RfctrlOverride_cmd_rxgain:
 			rfmxgain = value & 0x000ff;
 			lpfgain = value & 0x0ff00;
 			lpfgain = lpfgain >> 8;
 
-			wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 11),
-							  rfmxgain, core_mask,
-							  off,
-							  NPHY_REV7_RFCTRLOVERRIDE_ID0);
-			wlc_phy_rfctrl_override_nphy_rev7(pi, (0x3 << 13),
-							  lpfgain, core_mask,
-							  off,
-							  NPHY_REV7_RFCTRLOVERRIDE_ID0);
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
 			break;
 		case NPHY_REV7_RfctrlOverride_cmd_txgain:
 			tgain = value & 0x7fff;
 			lpfgain = value & 0x8000;
 			lpfgain = lpfgain >> 14;
 
-			wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 12),
-							  tgain, core_mask, off,
-							  NPHY_REV7_RFCTRLOVERRIDE_ID0);
-			wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 13),
-							  lpfgain, core_mask,
-							  off,
-							  NPHY_REV7_RFCTRLOVERRIDE_ID0);
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 12),
+				tgain, core_mask, off,
+				NPHY_REV7_RFCTRLOVERRIDE_ID0);
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 13),
+				lpfgain, core_mask,
+				off,
+				NPHY_REV7_RFCTRLOVERRIDE_ID0);
 			break;
 		}
 	}
@@ -20185,9 +20285,9 @@ wlc_phy_scale_offset_rssi_nphy(struct brcms_phy *pi, u16 scale, s8 offset,
 	u16 valuetostuff;
 
 	offset = (offset > NPHY_RSSICAL_MAXREAD) ?
-	    NPHY_RSSICAL_MAXREAD : offset;
+		 NPHY_RSSICAL_MAXREAD : offset;
 	offset = (offset < (-NPHY_RSSICAL_MAXREAD - 1)) ?
-	    -NPHY_RSSICAL_MAXREAD - 1 : offset;
+		 -NPHY_RSSICAL_MAXREAD - 1 : offset;
 
 	valuetostuff = ((scale & 0x3f) << 8) | (offset & 0x3f);
 
@@ -20330,7 +20430,7 @@ void wlc_phy_rssisel_nphy(struct brcms_phy *pi, u8 core_code, u8 rssi_type)
 			mod_phy_reg(pi, 0xe6, (0x1 << 5), 0);
 
 			mask = (0x1 << 2) |
-			    (0x1 << 3) | (0x1 << 4) | (0x1 << 5);
+			       (0x1 << 3) | (0x1 << 4) | (0x1 << 5);
 			mod_phy_reg(pi, 0xf9, mask, 0);
 			mod_phy_reg(pi, 0xfb, mask, 0);
 
@@ -20355,16 +20455,16 @@ void wlc_phy_rssisel_nphy(struct brcms_phy *pi, u8 core_code, u8 rssi_type)
 						    (0x3 << 8), 0);
 
 					mask = (0x1 << 2) |
-					    (0x1 << 3) |
-					    (0x1 << 4) | (0x1 << 5);
+					       (0x1 << 3) |
+					       (0x1 << 4) | (0x1 << 5);
 					mod_phy_reg(pi,
 						    (core ==
 						     PHY_CORE_0) ? 0xf9 : 0xfb,
 						    mask, 0);
 
 					if (rssi_type == NPHY_RSSI_SEL_W1) {
-						if (CHSPEC_IS5G
-						    (pi->radio_chanspec)) {
+						if (CHSPEC_IS5G(
+							  pi->radio_chanspec)) {
 							mask = (0x1 << 2);
 							val = 1 << 2;
 						} else {
@@ -20432,72 +20532,91 @@ void wlc_phy_rssisel_nphy(struct brcms_phy *pi, u8 core_code, u8 rssi_type)
 
 						if (PHY_IPA(pi)) {
 							if (NREV_GE
-							    (pi->pubpi.phy_rev,
-							     7))
+								    (pi->pubpi.
+								    phy_rev,
+								    7))
 								write_radio_reg
-								    (pi,
-								     ((core ==
-								       PHY_CORE_0)
-								      ?
-								      RADIO_2057_TX0_TX_SSI_MUX
-								      :
-								      RADIO_2057_TX1_TX_SSI_MUX),
-								     (CHSPEC_IS5G
-								      (pi->
-								       radio_chanspec)
-								      ? 0xc :
-								      0xe));
+									(pi,
+									((core
+									  ==
+									  PHY_CORE_0)
+									 ?
+									 RADIO_2057_TX0_TX_SSI_MUX
+									 :
+									 RADIO_2057_TX1_TX_SSI_MUX),
+									(
+										CHSPEC_IS5G
+										(
+											pi
+											->
+											radio_chanspec)
+										?
+										0xc
+										:
+										0xe));
 							else
 								write_radio_reg
-								    (pi,
-								     RADIO_2056_TX_TX_SSI_MUX
-								     |
-								     ((core ==
-								       PHY_CORE_0)
-								      ?
-								      RADIO_2056_TX0
-								      :
-								      RADIO_2056_TX1),
-								     (CHSPEC_IS5G
-								      (pi->
-								       radio_chanspec)
-								      ? 0xc :
-								      0xe));
+								(
+									pi,
+									RADIO_2056_TX_TX_SSI_MUX
+									|
+									((core
+									  ==
+									  PHY_CORE_0)
+									 ?
+									 RADIO_2056_TX0
+									 :
+									 RADIO_2056_TX1),
+									(
+										CHSPEC_IS5G
+										(
+											pi
+											->
+											radio_chanspec)
+										?
+										0xc
+										:
+										0xe));
 						} else {
 
 							if (NREV_GE
-							    (pi->pubpi.phy_rev,
-							     7)) {
+								    (pi->pubpi.
+								    phy_rev,
+								    7)) {
 								write_radio_reg
-								    (pi,
-								     ((core ==
-								       PHY_CORE_0)
-								      ?
-								      RADIO_2057_TX0_TX_SSI_MUX
-								      :
-								      RADIO_2057_TX1_TX_SSI_MUX),
-								     0x11);
+									(pi,
+									((core
+									  ==
+									  PHY_CORE_0)
+									 ?
+									 RADIO_2057_TX0_TX_SSI_MUX
+									 :
+									 RADIO_2057_TX1_TX_SSI_MUX),
+									0x11);
 
 								if (pi->pubpi.
 								    radioid ==
 								    BCM2057_ID)
 									write_radio_reg
-									    (pi,
-									     RADIO_2057_IQTEST_SEL_PU,
-									     0x1);
+									(
+										pi,
+										RADIO_2057_IQTEST_SEL_PU,
+										0x1);
 
 							} else {
 								write_radio_reg
-								    (pi,
-								     RADIO_2056_TX_TX_SSI_MUX
-								     |
-								     ((core ==
-								       PHY_CORE_0)
-								      ?
-								      RADIO_2056_TX0
-								      :
-								      RADIO_2056_TX1),
-								     0x11);
+								(
+									pi,
+									RADIO_2056_TX_TX_SSI_MUX
+									|
+									((core
+									  ==
+									  PHY_CORE_0)
+									 ?
+									 RADIO_2056_TX0
+									 :
+									 RADIO_2056_TX1),
+									0x11);
 							}
 						}
 
@@ -20576,16 +20695,16 @@ void wlc_phy_rssisel_nphy(struct brcms_phy *pi, u8 core_code, u8 rssi_type)
 		    (rssi_type == NPHY_RSSI_SEL_NB)) {
 			rfctrlcmd_mask = ((0x1 << 8) | (0x7 << 3));
 			rfctrlcmd_val = (rfctrlcmd_rxen_val << 8) |
-			    (rfctrlcmd_coresel_val << 3);
+					(rfctrlcmd_coresel_val << 3);
 
 			rfctrlovr_mask = ((0x1 << 5) |
 					  (0x1 << 12) |
 					  (0x1 << 1) | (0x1 << 0));
 			rfctrlovr_val = (rfctrlovr_rssi_val <<
 					 5) |
-			    (rfctrlovr_rxen_val << 12) |
-			    (rfctrlovr_coresel_val << 1) |
-			    (rfctrlovr_trigger_val << 0);
+					(rfctrlovr_rxen_val << 12) |
+					(rfctrlovr_coresel_val << 1) |
+					(rfctrlovr_trigger_val << 0);
 
 			mod_phy_reg(pi, 0x78, rfctrlcmd_mask, rfctrlcmd_val);
 			mod_phy_reg(pi, 0xec, rfctrlovr_mask, rfctrlovr_val);
@@ -20722,7 +20841,7 @@ s16 wlc_phy_tempsense_nphy(struct brcms_phy *pi)
 		u16 tempsense_Rcal;
 
 		syn_tempprocsense_save =
-		    read_radio_reg(pi, RADIO_2057_TEMPSENSE_CONFIG);
+			read_radio_reg(pi, RADIO_2057_TEMPSENSE_CONFIG);
 
 		afectrlCore1_save = read_phy_reg(pi, 0xa6);
 		afectrlCore2_save = read_phy_reg(pi, 0xa7);
@@ -20856,7 +20975,7 @@ s16 wlc_phy_tempsense_nphy(struct brcms_phy *pi)
 
 	} else if (NREV_GE(pi->pubpi.phy_rev, 3)) {
 		syn_tempprocsense_save =
-		    read_radio_reg(pi, RADIO_2056_SYN_TEMPPROCSENSE);
+			read_radio_reg(pi, RADIO_2056_SYN_TEMPPROCSENSE);
 
 		afectrlCore1_save = read_phy_reg(pi, 0xa6);
 		afectrlCore2_save = read_phy_reg(pi, 0xa7);
@@ -20877,7 +20996,7 @@ s16 wlc_phy_tempsense_nphy(struct brcms_phy *pi)
 			write_radio_reg(pi, RADIO_2056_SYN_TEMPPROCSENSE, 0x01);
 
 		radio_temp[0] =
-		    (126 * (radio_temp[1] + radio_temp2[1]) + 3987) / 64;
+			(126 * (radio_temp[1] + radio_temp2[1]) + 3987) / 64;
 
 		write_radio_reg(pi, RADIO_2056_SYN_TEMPPROCSENSE,
 				syn_tempprocsense_save);
@@ -20892,17 +21011,17 @@ s16 wlc_phy_tempsense_nphy(struct brcms_phy *pi)
 	} else {
 
 		pwrdet_rxtx_core1_save =
-		    read_radio_reg(pi, RADIO_2055_PWRDET_RXTX_CORE1);
+			read_radio_reg(pi, RADIO_2055_PWRDET_RXTX_CORE1);
 		pwrdet_rxtx_core2_save =
-		    read_radio_reg(pi, RADIO_2055_PWRDET_RXTX_CORE2);
+			read_radio_reg(pi, RADIO_2055_PWRDET_RXTX_CORE2);
 		core1_txrf_iqcal1_save =
-		    read_radio_reg(pi, RADIO_2055_CORE1_TXRF_IQCAL1);
+			read_radio_reg(pi, RADIO_2055_CORE1_TXRF_IQCAL1);
 		core1_txrf_iqcal2_save =
-		    read_radio_reg(pi, RADIO_2055_CORE1_TXRF_IQCAL2);
+			read_radio_reg(pi, RADIO_2055_CORE1_TXRF_IQCAL2);
 		core2_txrf_iqcal1_save =
-		    read_radio_reg(pi, RADIO_2055_CORE2_TXRF_IQCAL1);
+			read_radio_reg(pi, RADIO_2055_CORE2_TXRF_IQCAL1);
 		core2_txrf_iqcal2_save =
-		    read_radio_reg(pi, RADIO_2055_CORE2_TXRF_IQCAL2);
+			read_radio_reg(pi, RADIO_2055_CORE2_TXRF_IQCAL2);
 		pd_pll_ts_save = read_radio_reg(pi, RADIO_2055_PD_PLL_TS);
 
 		afectrlCore1_save = read_phy_reg(pi, 0xa6);
@@ -20933,11 +21052,12 @@ s16 wlc_phy_tempsense_nphy(struct brcms_phy *pi)
 		radio_temp[3] = (radio_temp[3] + radio_temp2[3]);
 
 		radio_temp[0] =
-		    (radio_temp[0] + radio_temp[1] + radio_temp[2] +
-		     radio_temp[3]);
+			(radio_temp[0] + radio_temp[1] + radio_temp[2] +
+			 radio_temp[3]);
 
 		radio_temp[0] =
-		    (radio_temp[0] + (8 * 32)) * (950 - 350) / 63 + (350 * 8);
+			(radio_temp[0] +
+			 (8 * 32)) * (950 - 350) / 63 + (350 * 8);
 
 		radio_temp[0] = (radio_temp[0] - (8 * 420)) / 38;
 
@@ -21080,7 +21200,7 @@ static void wlc_phy_rssi_cal_nphy_rev2(struct brcms_phy *pi, u8 rssi_type)
 
 	rf_pd_val = (rssi_type == NPHY_RSSI_SEL_NB) ? 0x6 : 0x4;
 	rfctrlintc_override_val =
-	    CHSPEC_IS5G(pi->radio_chanspec) ? 0x140 : 0x110;
+		CHSPEC_IS5G(pi->radio_chanspec) ? 0x140 : 0x110;
 
 	rfctrlintc_state[0] = read_phy_reg(pi, 0x91);
 	rfpdcorerxtx_state[0] = read_radio_reg(pi, RADIO_2055_PD_CORE1_RXTX);
@@ -21093,19 +21213,19 @@ static void wlc_phy_rssi_cal_nphy_rev2(struct brcms_phy *pi, u8 rssi_type)
 	write_radio_reg(pi, RADIO_2055_PD_CORE2_RXTX, rf_pd_val);
 
 	pd_mask = RADIO_2055_NBRSSI_PD | RADIO_2055_WBRSSI_G1_PD |
-	    RADIO_2055_WBRSSI_G2_PD;
+		  RADIO_2055_WBRSSI_G2_PD;
 	pd_state[0] =
-	    read_radio_reg(pi, RADIO_2055_PD_CORE1_RSSI_MISC) & pd_mask;
+		read_radio_reg(pi, RADIO_2055_PD_CORE1_RSSI_MISC) & pd_mask;
 	pd_state[1] =
-	    read_radio_reg(pi, RADIO_2055_PD_CORE2_RSSI_MISC) & pd_mask;
+		read_radio_reg(pi, RADIO_2055_PD_CORE2_RSSI_MISC) & pd_mask;
 	mod_radio_reg(pi, RADIO_2055_PD_CORE1_RSSI_MISC, pd_mask, 0);
 	mod_radio_reg(pi, RADIO_2055_PD_CORE2_RSSI_MISC, pd_mask, 0);
 	rssi_ctrl_mask = RADIO_2055_NBRSSI_SEL | RADIO_2055_WBRSSI_G1_SEL |
-	    RADIO_2055_WBRSSI_G2_SEL;
+			 RADIO_2055_WBRSSI_G2_SEL;
 	rssi_ctrl_state[0] =
-	    read_radio_reg(pi, RADIO_2055_SP_RSSI_CORE1) & rssi_ctrl_mask;
+		read_radio_reg(pi, RADIO_2055_SP_RSSI_CORE1) & rssi_ctrl_mask;
 	rssi_ctrl_state[1] =
-	    read_radio_reg(pi, RADIO_2055_SP_RSSI_CORE2) & rssi_ctrl_mask;
+		read_radio_reg(pi, RADIO_2055_SP_RSSI_CORE2) & rssi_ctrl_mask;
 	wlc_phy_rssisel_nphy(pi, RADIO_MIMO_CORESEL_ALLRX, rssi_type);
 
 	wlc_phy_scale_offset_rssi_nphy(pi, 0x0, 0x0, RADIO_MIMO_CORESEL_ALLRX,
@@ -21126,8 +21246,8 @@ static void wlc_phy_rssi_cal_nphy_rev2(struct brcms_phy *pi, u8 rssi_type)
 		    || (rssi_type == NPHY_RSSI_SEL_W2)) {
 			for (ctr = 0; ctr < 2; ctr++)
 				poll_miniq[vcm][ctr] =
-				    min(poll_results[vcm][ctr * 2 + 0],
-					poll_results[vcm][ctr * 2 + 1]);
+					min(poll_results[vcm][ctr * 2 + 0],
+					    poll_results[vcm][ctr * 2 + 1]);
 		}
 	}
 
@@ -21156,26 +21276,26 @@ static void wlc_phy_rssi_cal_nphy_rev2(struct brcms_phy *pi, u8 rssi_type)
 
 	for (result_idx = 0; result_idx < 4; result_idx++) {
 		fine_digital_offset[result_idx] =
-		    (target_code * NPHY_RSSICAL_NPOLL) -
-		    poll_results[vcm_final[result_idx]][result_idx];
+			(target_code * NPHY_RSSICAL_NPOLL) -
+			poll_results[vcm_final[result_idx]][result_idx];
 		if (fine_digital_offset[result_idx] < 0) {
 			fine_digital_offset[result_idx] =
-			    ABS(fine_digital_offset[result_idx]);
+				ABS(fine_digital_offset[result_idx]);
 			fine_digital_offset[result_idx] +=
-			    (NPHY_RSSICAL_NPOLL / 2);
+				(NPHY_RSSICAL_NPOLL / 2);
 			fine_digital_offset[result_idx] /= NPHY_RSSICAL_NPOLL;
 			fine_digital_offset[result_idx] =
-			    -fine_digital_offset[result_idx];
+				-fine_digital_offset[result_idx];
 		} else {
 			fine_digital_offset[result_idx] +=
-			    (NPHY_RSSICAL_NPOLL / 2);
+				(NPHY_RSSICAL_NPOLL / 2);
 			fine_digital_offset[result_idx] /= NPHY_RSSICAL_NPOLL;
 		}
 
 		if (poll_results_min[result_idx] ==
 		    NPHY_RSSICAL_MAXREAD * NPHY_RSSICAL_NPOLL)
 			fine_digital_offset[result_idx] =
-			    (target_code - NPHY_RSSICAL_MAXREAD - 1);
+				(target_code - NPHY_RSSICAL_MAXREAD - 1);
 
 		wlc_phy_scale_offset_rssi_nphy(pi, 0x0,
 					       (s8)
@@ -21324,8 +21444,8 @@ wlc_phy_rfctrlintc_override_nphy(struct brcms_phy *pi, u8 field, u16 value,
 				} else {
 
 					mask = (0x1 << 6) |
-					    (0x1 << 7) |
-					    (0x1 << 8) | (0x1 << 9);
+					       (0x1 << 7) |
+					       (0x1 << 8) | (0x1 << 9);
 					val = value << 6;
 					mod_phy_reg(pi,
 						    (core ==
@@ -21339,8 +21459,8 @@ wlc_phy_rfctrlintc_override_nphy(struct brcms_phy *pi, u8 field, u16 value,
 						     PHY_CORE_0) ? 0xe7 : 0xec,
 						    mask, val);
 
-					mask = (core == PHY_CORE_0) ? (0x1 << 0)
-					    : (0x1 << 1);
+					mask = (core == PHY_CORE_0) ?
+					       (0x1 << 0) : (0x1 << 1);
 					val = 1 << ((core == PHY_CORE_0) ?
 						    0 : 1);
 					mod_phy_reg(pi, 0x78, mask, val);
@@ -21348,7 +21468,7 @@ wlc_phy_rfctrlintc_override_nphy(struct brcms_phy *pi, u8 field, u16 value,
 					SPINWAIT(((read_phy_reg(pi, 0x78) & val)
 						  != 0), 10000);
 					if (WARN(read_phy_reg(pi, 0x78) & val,
-						"HW error: override failed"))
+						 "HW error: override failed"))
 						return;
 
 					mask = (0x1 << 0);
@@ -21391,7 +21511,8 @@ wlc_phy_rfctrlintc_override_nphy(struct brcms_phy *pi, u8 field, u16 value,
 						     PHY_CORE_0) ? 0x91 : 0x92,
 						    mask, val);
 				}
-			} else if (field == NPHY_RfctrlIntc_override_EXT_LNA_PU) {
+			} else if (field ==
+				   NPHY_RfctrlIntc_override_EXT_LNA_PU) {
 				if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 					if (CHSPEC_IS5G(pi->radio_chanspec)) {
 
@@ -21543,10 +21664,14 @@ static void wlc_phy_rssi_cal_nphy_rev3(struct brcms_phy *pi)
 	u16 NPHY_REV7_RfctrlMiscReg3_save, NPHY_REV7_RfctrlMiscReg4_save;
 	u16 NPHY_REV7_RfctrlMiscReg5_save, NPHY_REV7_RfctrlMiscReg6_save;
 
-	NPHY_REV7_RfctrlOverride3_save = NPHY_REV7_RfctrlOverride4_save =
-	    NPHY_REV7_RfctrlOverride5_save = NPHY_REV7_RfctrlOverride6_save =
-	    NPHY_REV7_RfctrlMiscReg3_save = NPHY_REV7_RfctrlMiscReg4_save =
-	    NPHY_REV7_RfctrlMiscReg5_save = NPHY_REV7_RfctrlMiscReg6_save = 0;
+	NPHY_REV7_RfctrlOverride3_save =
+		NPHY_REV7_RfctrlOverride4_save =
+		NPHY_REV7_RfctrlOverride5_save =
+		NPHY_REV7_RfctrlOverride6_save =
+		NPHY_REV7_RfctrlMiscReg3_save =
+		NPHY_REV7_RfctrlMiscReg4_save =
+		NPHY_REV7_RfctrlMiscReg5_save =
+		NPHY_REV7_RfctrlMiscReg6_save = 0;
 
 	classif_state = wlc_phy_classifier_nphy(pi, 0, 0);
 	wlc_phy_classifier_nphy(pi, (0x7 << 0), 4);
@@ -21587,16 +21712,18 @@ static void wlc_phy_rssi_cal_nphy_rev3(struct brcms_phy *pi)
 					 RADIO_MIMO_CORESEL_ALLRXTX);
 
 	if (NREV_GE(pi->pubpi.phy_rev, 7))
-		wlc_phy_rfctrl_override_1tomany_nphy(pi,
-						     NPHY_REV7_RfctrlOverride_cmd_rxrf_pu,
-						     0, 0, 0);
+		wlc_phy_rfctrl_override_1tomany_nphy(
+			pi,
+			NPHY_REV7_RfctrlOverride_cmd_rxrf_pu,
+			0, 0, 0);
 	else
 		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 0), 0, 0, 0);
 
 	if (NREV_GE(pi->pubpi.phy_rev, 7))
-		wlc_phy_rfctrl_override_1tomany_nphy(pi,
-						     NPHY_REV7_RfctrlOverride_cmd_rx_pu,
-						     1, 0, 0);
+		wlc_phy_rfctrl_override_1tomany_nphy(
+			pi,
+			NPHY_REV7_RfctrlOverride_cmd_rx_pu,
+			1, 0, 0);
 	else
 		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 1), 1, 0, 0);
 
@@ -21613,12 +21740,14 @@ static void wlc_phy_rssi_cal_nphy_rev3(struct brcms_phy *pi)
 
 	if (CHSPEC_IS5G(pi->radio_chanspec)) {
 		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-			wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 5),
-							  0, 0, 0,
-							  NPHY_REV7_RFCTRLOVERRIDE_ID0);
-			wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 4), 1, 0,
-							  0,
-							  NPHY_REV7_RFCTRLOVERRIDE_ID0);
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 5),
+				0, 0, 0,
+				NPHY_REV7_RFCTRLOVERRIDE_ID0);
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 4), 1, 0,
+				0,
+				NPHY_REV7_RFCTRLOVERRIDE_ID0);
 		} else {
 			wlc_phy_rfctrl_override_nphy(pi, (0x1 << 5), 0, 0, 0);
 			wlc_phy_rfctrl_override_nphy(pi, (0x1 << 4), 1, 0, 0);
@@ -21626,12 +21755,14 @@ static void wlc_phy_rssi_cal_nphy_rev3(struct brcms_phy *pi)
 
 	} else {
 		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-			wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 4),
-							  0, 0, 0,
-							  NPHY_REV7_RFCTRLOVERRIDE_ID0);
-			wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 5), 1, 0,
-							  0,
-							  NPHY_REV7_RFCTRLOVERRIDE_ID0);
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 4),
+				0, 0, 0,
+				NPHY_REV7_RFCTRLOVERRIDE_ID0);
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 5), 1, 0,
+				0,
+				NPHY_REV7_RFCTRLOVERRIDE_ID0);
 		} else {
 			wlc_phy_rfctrl_override_nphy(pi, (0x1 << 4), 0, 0, 0);
 			wlc_phy_rfctrl_override_nphy(pi, (0x1 << 5), 1, 0, 0);
@@ -21639,7 +21770,7 @@ static void wlc_phy_rssi_cal_nphy_rev3(struct brcms_phy *pi)
 	}
 
 	rxcore_state = wlc_phy_rxcore_getstate_nphy(
-						(struct brcms_phy_pub *) pi);
+		(struct brcms_phy_pub *) pi);
 
 	vcm_level_max = 8;
 
@@ -21681,18 +21812,22 @@ static void wlc_phy_rssi_cal_nphy_rev3(struct brcms_phy *pi)
 		}
 
 		for (result_idx = 0; result_idx < 4; result_idx++) {
-			if ((core == result_idx / 2) && (result_idx % 2 == 0)) {
+			if ((core == result_idx / 2) &&
+			    (result_idx % 2 == 0)) {
 
 				min_d = NPHY_RSSICAL_MAXD;
 				min_vcm = 0;
 				min_poll =
-				    NPHY_RSSICAL_MAXREAD * NPHY_RSSICAL_NPOLL +
-				    1;
+					NPHY_RSSICAL_MAXREAD *
+					NPHY_RSSICAL_NPOLL + 1;
 				for (vcm = 0; vcm < vcm_level_max; vcm++) {
-					curr_d = poll_results[vcm][result_idx] *
-					    poll_results[vcm][result_idx] +
-					    poll_results[vcm][result_idx + 1] *
-					    poll_results[vcm][result_idx + 1];
+					curr_d =
+						poll_results[vcm][result_idx] *
+						poll_results[vcm][result_idx] +
+						poll_results[vcm][result_idx +
+								  1] *
+						poll_results[vcm][result_idx +
+								  1];
 					if (curr_d < min_d) {
 						min_d = curr_d;
 						min_vcm = vcm;
@@ -21700,8 +21835,8 @@ static void wlc_phy_rssi_cal_nphy_rev3(struct brcms_phy *pi)
 					if (poll_results[vcm][result_idx] <
 					    min_poll)
 						min_poll =
-						    poll_results[vcm]
-						    [result_idx];
+							poll_results[vcm]
+							[result_idx];
 				}
 				vcm_final = min_vcm;
 				poll_results_min[result_idx] = min_poll;
@@ -21723,47 +21858,44 @@ static void wlc_phy_rssi_cal_nphy_rev3(struct brcms_phy *pi)
 		for (result_idx = 0; result_idx < 4; result_idx++) {
 			if (core == result_idx / 2) {
 				fine_digital_offset[result_idx] =
-				    (NPHY_RSSICAL_NB_TARGET *
-				     NPHY_RSSICAL_NPOLL) -
-				    poll_results[vcm_final][result_idx];
+					(NPHY_RSSICAL_NB_TARGET *
+					 NPHY_RSSICAL_NPOLL) -
+					poll_results[vcm_final][result_idx];
 				if (fine_digital_offset[result_idx] < 0) {
 					fine_digital_offset[result_idx] =
-					    ABS(fine_digital_offset
-						[result_idx]);
+						ABS(fine_digital_offset
+						    [result_idx]);
 					fine_digital_offset[result_idx] +=
-					    (NPHY_RSSICAL_NPOLL / 2);
+						(NPHY_RSSICAL_NPOLL / 2);
 					fine_digital_offset[result_idx] /=
-					    NPHY_RSSICAL_NPOLL;
+						NPHY_RSSICAL_NPOLL;
 					fine_digital_offset[result_idx] =
-					    -fine_digital_offset[result_idx];
+						-fine_digital_offset[
+								    result_idx];
 				} else {
 					fine_digital_offset[result_idx] +=
-					    (NPHY_RSSICAL_NPOLL / 2);
+						(NPHY_RSSICAL_NPOLL / 2);
 					fine_digital_offset[result_idx] /=
-					    NPHY_RSSICAL_NPOLL;
+						NPHY_RSSICAL_NPOLL;
 				}
 
 				if (poll_results_min[result_idx] ==
 				    NPHY_RSSICAL_MAXREAD * NPHY_RSSICAL_NPOLL)
 					fine_digital_offset[result_idx] =
-					    (NPHY_RSSICAL_NB_TARGET -
-					     NPHY_RSSICAL_MAXREAD - 1);
-
-				wlc_phy_scale_offset_rssi_nphy(pi, 0x0,
-							       (s8)
-							       fine_digital_offset
-							       [result_idx],
-							       (result_idx /
-								2 ==
-								0) ?
-							       RADIO_MIMO_CORESEL_CORE1
-							       :
-							       RADIO_MIMO_CORESEL_CORE2,
-							       (result_idx %
-								2 ==
-								0) ? NPHY_RAIL_I
-							       : NPHY_RAIL_Q,
-							       NPHY_RSSI_SEL_NB);
+						(NPHY_RSSICAL_NB_TARGET -
+						 NPHY_RSSICAL_MAXREAD - 1);
+
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
 			}
 		}
 
@@ -21804,46 +21936,44 @@ static void wlc_phy_rssi_cal_nphy_rev3(struct brcms_phy *pi)
 			for (result_idx = 0; result_idx < 4; result_idx++) {
 				if (core == result_idx / 2) {
 					fine_digital_offset[result_idx] =
-					    (target_code * NPHY_RSSICAL_NPOLL) -
-					    poll_result_core[result_idx];
-					if (fine_digital_offset[result_idx] < 0) {
+						(target_code *
+						 NPHY_RSSICAL_NPOLL) -
+						poll_result_core[result_idx];
+					if (fine_digital_offset[result_idx] <
+					    0) {
 						fine_digital_offset[result_idx]
-						    =
-						    ABS(fine_digital_offset
-							[result_idx]);
+							= ABS(
+							    fine_digital_offset
+							    [result_idx]);
 						fine_digital_offset[result_idx]
-						    += (NPHY_RSSICAL_NPOLL / 2);
+							+= (NPHY_RSSICAL_NPOLL
+							    / 2);
 						fine_digital_offset[result_idx]
-						    /= NPHY_RSSICAL_NPOLL;
+							/= NPHY_RSSICAL_NPOLL;
 						fine_digital_offset[result_idx]
-						    =
-						    -fine_digital_offset
-						    [result_idx];
+							= -fine_digital_offset
+								[result_idx];
 					} else {
 						fine_digital_offset[result_idx]
-						    += (NPHY_RSSICAL_NPOLL / 2);
+							+= (NPHY_RSSICAL_NPOLL
+							    / 2);
 						fine_digital_offset[result_idx]
-						    /= NPHY_RSSICAL_NPOLL;
+							/= NPHY_RSSICAL_NPOLL;
 					}
 
-					wlc_phy_scale_offset_rssi_nphy(pi, 0x0,
-								       (s8)
-								       fine_digital_offset
-								       [core *
-									2],
-								       (core ==
-									PHY_CORE_0)
-								       ?
-								       RADIO_MIMO_CORESEL_CORE1
-								       :
-								       RADIO_MIMO_CORESEL_CORE2,
-								       (result_idx
-									% 2 ==
-									0) ?
-								       NPHY_RAIL_I
-								       :
-								       NPHY_RAIL_Q,
-								       rssi_type);
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
 				}
 			}
 
@@ -21892,87 +22022,87 @@ static void wlc_phy_rssi_cal_nphy_rev3(struct brcms_phy *pi)
 	if (CHSPEC_IS2G(pi->radio_chanspec)) {
 		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 			pi->rssical_cache.rssical_radio_regs_2G[0] =
-			    read_radio_reg(pi, RADIO_2057_NB_MASTER_CORE0);
+				read_radio_reg(pi, RADIO_2057_NB_MASTER_CORE0);
 			pi->rssical_cache.rssical_radio_regs_2G[1] =
-			    read_radio_reg(pi, RADIO_2057_NB_MASTER_CORE1);
+				read_radio_reg(pi, RADIO_2057_NB_MASTER_CORE1);
 		} else {
 			pi->rssical_cache.rssical_radio_regs_2G[0] =
-			    read_radio_reg(pi,
-					   RADIO_2056_RX_RSSI_MISC |
-					   RADIO_2056_RX0);
+				read_radio_reg(pi,
+					       RADIO_2056_RX_RSSI_MISC |
+					       RADIO_2056_RX0);
 			pi->rssical_cache.rssical_radio_regs_2G[1] =
-			    read_radio_reg(pi,
-					   RADIO_2056_RX_RSSI_MISC |
-					   RADIO_2056_RX1);
+				read_radio_reg(pi,
+					       RADIO_2056_RX_RSSI_MISC |
+					       RADIO_2056_RX1);
 		}
 
 		pi->rssical_cache.rssical_phyregs_2G[0] =
-		    read_phy_reg(pi, 0x1a6);
+			read_phy_reg(pi, 0x1a6);
 		pi->rssical_cache.rssical_phyregs_2G[1] =
-		    read_phy_reg(pi, 0x1ac);
+			read_phy_reg(pi, 0x1ac);
 		pi->rssical_cache.rssical_phyregs_2G[2] =
-		    read_phy_reg(pi, 0x1b2);
+			read_phy_reg(pi, 0x1b2);
 		pi->rssical_cache.rssical_phyregs_2G[3] =
-		    read_phy_reg(pi, 0x1b8);
+			read_phy_reg(pi, 0x1b8);
 		pi->rssical_cache.rssical_phyregs_2G[4] =
-		    read_phy_reg(pi, 0x1a4);
+			read_phy_reg(pi, 0x1a4);
 		pi->rssical_cache.rssical_phyregs_2G[5] =
-		    read_phy_reg(pi, 0x1aa);
+			read_phy_reg(pi, 0x1aa);
 		pi->rssical_cache.rssical_phyregs_2G[6] =
-		    read_phy_reg(pi, 0x1b0);
+			read_phy_reg(pi, 0x1b0);
 		pi->rssical_cache.rssical_phyregs_2G[7] =
-		    read_phy_reg(pi, 0x1b6);
+			read_phy_reg(pi, 0x1b6);
 		pi->rssical_cache.rssical_phyregs_2G[8] =
-		    read_phy_reg(pi, 0x1a5);
+			read_phy_reg(pi, 0x1a5);
 		pi->rssical_cache.rssical_phyregs_2G[9] =
-		    read_phy_reg(pi, 0x1ab);
+			read_phy_reg(pi, 0x1ab);
 		pi->rssical_cache.rssical_phyregs_2G[10] =
-		    read_phy_reg(pi, 0x1b1);
+			read_phy_reg(pi, 0x1b1);
 		pi->rssical_cache.rssical_phyregs_2G[11] =
-		    read_phy_reg(pi, 0x1b7);
+			read_phy_reg(pi, 0x1b7);
 
 		pi->nphy_rssical_chanspec_2G = pi->radio_chanspec;
 	} else {
 		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 			pi->rssical_cache.rssical_radio_regs_5G[0] =
-			    read_radio_reg(pi, RADIO_2057_NB_MASTER_CORE0);
+				read_radio_reg(pi, RADIO_2057_NB_MASTER_CORE0);
 			pi->rssical_cache.rssical_radio_regs_5G[1] =
-			    read_radio_reg(pi, RADIO_2057_NB_MASTER_CORE1);
+				read_radio_reg(pi, RADIO_2057_NB_MASTER_CORE1);
 		} else {
 			pi->rssical_cache.rssical_radio_regs_5G[0] =
-			    read_radio_reg(pi,
-					   RADIO_2056_RX_RSSI_MISC |
-					   RADIO_2056_RX0);
+				read_radio_reg(pi,
+					       RADIO_2056_RX_RSSI_MISC |
+					       RADIO_2056_RX0);
 			pi->rssical_cache.rssical_radio_regs_5G[1] =
-			    read_radio_reg(pi,
-					   RADIO_2056_RX_RSSI_MISC |
-					   RADIO_2056_RX1);
+				read_radio_reg(pi,
+					       RADIO_2056_RX_RSSI_MISC |
+					       RADIO_2056_RX1);
 		}
 
 		pi->rssical_cache.rssical_phyregs_5G[0] =
-		    read_phy_reg(pi, 0x1a6);
+			read_phy_reg(pi, 0x1a6);
 		pi->rssical_cache.rssical_phyregs_5G[1] =
-		    read_phy_reg(pi, 0x1ac);
+			read_phy_reg(pi, 0x1ac);
 		pi->rssical_cache.rssical_phyregs_5G[2] =
-		    read_phy_reg(pi, 0x1b2);
+			read_phy_reg(pi, 0x1b2);
 		pi->rssical_cache.rssical_phyregs_5G[3] =
-		    read_phy_reg(pi, 0x1b8);
+			read_phy_reg(pi, 0x1b8);
 		pi->rssical_cache.rssical_phyregs_5G[4] =
-		    read_phy_reg(pi, 0x1a4);
+			read_phy_reg(pi, 0x1a4);
 		pi->rssical_cache.rssical_phyregs_5G[5] =
-		    read_phy_reg(pi, 0x1aa);
+			read_phy_reg(pi, 0x1aa);
 		pi->rssical_cache.rssical_phyregs_5G[6] =
-		    read_phy_reg(pi, 0x1b0);
+			read_phy_reg(pi, 0x1b0);
 		pi->rssical_cache.rssical_phyregs_5G[7] =
-		    read_phy_reg(pi, 0x1b6);
+			read_phy_reg(pi, 0x1b6);
 		pi->rssical_cache.rssical_phyregs_5G[8] =
-		    read_phy_reg(pi, 0x1a5);
+			read_phy_reg(pi, 0x1a5);
 		pi->rssical_cache.rssical_phyregs_5G[9] =
-		    read_phy_reg(pi, 0x1ab);
+			read_phy_reg(pi, 0x1ab);
 		pi->rssical_cache.rssical_phyregs_5G[10] =
-		    read_phy_reg(pi, 0x1b1);
+			read_phy_reg(pi, 0x1b1);
 		pi->rssical_cache.rssical_phyregs_5G[11] =
-		    read_phy_reg(pi, 0x1b7);
+			read_phy_reg(pi, 0x1b7);
 
 		pi->nphy_rssical_chanspec_5G = pi->radio_chanspec;
 	}
@@ -22143,8 +22273,8 @@ wlc_phy_tx_tone_nphy(struct brcms_phy *pi, u32 f_kHz, u16 max_val,
 	u16 loops = 0xffff;
 	u16 wait = 0;
 
-	num_samps =
-		wlc_phy_gen_load_samples_nphy(pi, f_kHz, max_val, dac_test_mode);
+	num_samps = wlc_phy_gen_load_samples_nphy(pi, f_kHz, max_val,
+						  dac_test_mode);
 	if (num_samps == 0)
 		return -EBADE;
 
@@ -22170,7 +22300,7 @@ wlc_phy_loadsampletable_nphy(struct brcms_phy *pi, struct cs32 *tone_buf,
 
 	for (t = 0; t < num_samps; t++)
 		data_buf[t] = ((((unsigned int)tone_buf[t].i) & 0x3ff) << 10) |
-		    (((unsigned int)tone_buf[t].q) & 0x3ff);
+			      (((unsigned int)tone_buf[t].q) & 0x3ff);
 	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_SAMPLEPLAY, num_samps, 0, 32,
 				 data_buf);
 
@@ -22204,22 +22334,24 @@ wlc_phy_runsamples_nphy(struct brcms_phy *pi, u16 num_samps, u16 loops,
 		lpf_bw_ctl_override4 = read_phy_reg(pi, 0x343) & (0x1 << 7);
 		if (lpf_bw_ctl_override3 | lpf_bw_ctl_override4) {
 			lpf_bw_ctl_miscreg3 = read_phy_reg(pi, 0x340) &
-			    (0x7 << 8);
+					      (0x7 << 8);
 			lpf_bw_ctl_miscreg4 = read_phy_reg(pi, 0x341) &
-			    (0x7 << 8);
+					      (0x7 << 8);
 		} else {
-			wlc_phy_rfctrl_override_nphy_rev7(pi,
-							  (0x1 << 7),
-							  wlc_phy_read_lpf_bw_ctl_nphy
-							  (pi, 0), 0, 0,
-							  NPHY_REV7_RFCTRLOVERRIDE_ID1);
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi,
+				(0x1 << 7),
+				wlc_phy_read_lpf_bw_ctl_nphy
+					(pi,
+					0), 0, 0,
+				NPHY_REV7_RFCTRLOVERRIDE_ID1);
 
 			pi->nphy_sample_play_lpf_bw_ctl_ovr = true;
 
 			lpf_bw_ctl_miscreg3 = read_phy_reg(pi, 0x340) &
-			    (0x7 << 8);
+					      (0x7 << 8);
 			lpf_bw_ctl_miscreg4 = read_phy_reg(pi, 0x341) &
-			    (0x7 << 8);
+					      (0x7 << 8);
 		}
 	}
 
@@ -22228,7 +22360,7 @@ wlc_phy_runsamples_nphy(struct brcms_phy *pi, u16 num_samps, u16 loops,
 		wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_IQLOCAL, 1, 87, 16,
 					&bb_mult);
 		pi->nphy_bb_mult_save =
-		    BB_MULT_VALID_MASK | (bb_mult & BB_MULT_MASK);
+			BB_MULT_VALID_MASK | (bb_mult & BB_MULT_MASK);
 	}
 
 	if (modify_bbmult) {
@@ -22296,10 +22428,11 @@ void wlc_phy_stopplayback_nphy(struct brcms_phy *pi)
 
 	if (NREV_IS(pi->pubpi.phy_rev, 7) || NREV_GE(pi->pubpi.phy_rev, 8)) {
 		if (pi->nphy_sample_play_lpf_bw_ctl_ovr) {
-			wlc_phy_rfctrl_override_nphy_rev7(pi,
-							  (0x1 << 7),
-							  0, 0, 1,
-							  NPHY_REV7_RFCTRLOVERRIDE_ID1);
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi,
+				(0x1 << 7),
+				0, 0, 1,
+				NPHY_REV7_RFCTRLOVERRIDE_ID1);
 			pi->nphy_sample_play_lpf_bw_ctl_ovr = false;
 		}
 	}
@@ -22328,33 +22461,33 @@ struct nphy_txgains wlc_phy_get_tx_gain_nphy(struct brcms_phy *pi)
 		for (core_no = 0; core_no < 2; core_no++) {
 			if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 				target_gain.ipa[core_no] =
-				    curr_gain[core_no] & 0x0007;
+					curr_gain[core_no] & 0x0007;
 				target_gain.pad[core_no] =
-				    ((curr_gain[core_no] & 0x00F8) >> 3);
+					((curr_gain[core_no] & 0x00F8) >> 3);
 				target_gain.pga[core_no] =
-				    ((curr_gain[core_no] & 0x0F00) >> 8);
+					((curr_gain[core_no] & 0x0F00) >> 8);
 				target_gain.txgm[core_no] =
-				    ((curr_gain[core_no] & 0x7000) >> 12);
+					((curr_gain[core_no] & 0x7000) >> 12);
 				target_gain.txlpf[core_no] =
-				    ((curr_gain[core_no] & 0x8000) >> 15);
+					((curr_gain[core_no] & 0x8000) >> 15);
 			} else if (NREV_GE(pi->pubpi.phy_rev, 3)) {
 				target_gain.ipa[core_no] =
-				    curr_gain[core_no] & 0x000F;
+					curr_gain[core_no] & 0x000F;
 				target_gain.pad[core_no] =
-				    ((curr_gain[core_no] & 0x00F0) >> 4);
+					((curr_gain[core_no] & 0x00F0) >> 4);
 				target_gain.pga[core_no] =
-				    ((curr_gain[core_no] & 0x0F00) >> 8);
+					((curr_gain[core_no] & 0x0F00) >> 8);
 				target_gain.txgm[core_no] =
-				    ((curr_gain[core_no] & 0x7000) >> 12);
+					((curr_gain[core_no] & 0x7000) >> 12);
 			} else {
 				target_gain.ipa[core_no] =
-				    curr_gain[core_no] & 0x0003;
+					curr_gain[core_no] & 0x0003;
 				target_gain.pad[core_no] =
-				    ((curr_gain[core_no] & 0x000C) >> 2);
+					((curr_gain[core_no] & 0x000C) >> 2);
 				target_gain.pga[core_no] =
-				    ((curr_gain[core_no] & 0x0070) >> 4);
+					((curr_gain[core_no] & 0x0070) >> 4);
 				target_gain.txgm[core_no] =
-				    ((curr_gain[core_no] & 0x0380) >> 7);
+					((curr_gain[core_no] & 0x0380) >> 7);
 			}
 		}
 	} else {
@@ -22366,90 +22499,104 @@ struct nphy_txgains wlc_phy_get_tx_gain_nphy(struct brcms_phy *pi)
 			if (NREV_GE(phyrev, 3)) {
 				if (PHY_IPA(pi)) {
 					tx_pwrctrl_tbl =
-					    wlc_phy_get_ipa_gaintbl_nphy(pi);
+						wlc_phy_get_ipa_gaintbl_nphy(pi);
 				} else {
 					if (CHSPEC_IS5G(pi->radio_chanspec)) {
 						if (NREV_IS(phyrev, 3))
 							tx_pwrctrl_tbl =
-							    nphy_tpc_5GHz_txgain_rev3;
+								nphy_tpc_5GHz_txgain_rev3;
 						else if (NREV_IS(phyrev, 4))
 							tx_pwrctrl_tbl =
-							    (pi->srom_fem5g.
-							     extpagain ==
-							     3) ?
-							    nphy_tpc_5GHz_txgain_HiPwrEPA
-							    :
-							    nphy_tpc_5GHz_txgain_rev4;
+								(pi->srom_fem5g
+								 .
+								 extpagain ==
+								 3) ?
+								nphy_tpc_5GHz_txgain_HiPwrEPA
+								:
+								nphy_tpc_5GHz_txgain_rev4;
 						else
 							tx_pwrctrl_tbl =
-							    nphy_tpc_5GHz_txgain_rev5;
+								nphy_tpc_5GHz_txgain_rev5;
 					} else {
 						if (NREV_GE(phyrev, 7)) {
 							if (pi->pubpi.
 							    radiorev == 3)
-								tx_pwrctrl_tbl =
-								    nphy_tpc_txgain_epa_2057rev3;
+								tx_pwrctrl_tbl
+									=
+										nphy_tpc_txgain_epa_2057rev3;
 							else if (pi->pubpi.
-								   radiorev ==
+								 radiorev ==
 								 5)
-								tx_pwrctrl_tbl =
-								    nphy_tpc_txgain_epa_2057rev5;
+								tx_pwrctrl_tbl
+									=
+										nphy_tpc_txgain_epa_2057rev5;
 						} else {
 							if (NREV_GE(phyrev, 5)
 							    && (pi->srom_fem2g.
 								extpagain ==
 								3))
-								tx_pwrctrl_tbl =
-								    nphy_tpc_txgain_HiPwrEPA;
+								tx_pwrctrl_tbl
+									=
+										nphy_tpc_txgain_HiPwrEPA;
 							else
-								tx_pwrctrl_tbl =
-								    nphy_tpc_txgain_rev3;
+								tx_pwrctrl_tbl
+									=
+										nphy_tpc_txgain_rev3;
 						}
 					}
 				}
 				if (NREV_GE(phyrev, 7)) {
 					target_gain.ipa[core_no] =
-					    (tx_pwrctrl_tbl[base_idx[core_no]]
-					     >> 16) & 0x7;
+						(tx_pwrctrl_tbl
+						 [base_idx[core_no]]
+						 >> 16) & 0x7;
 					target_gain.pad[core_no] =
-					    (tx_pwrctrl_tbl[base_idx[core_no]]
-					     >> 19) & 0x1f;
+						(tx_pwrctrl_tbl
+						 [base_idx[core_no]]
+						 >> 19) & 0x1f;
 					target_gain.pga[core_no] =
-					    (tx_pwrctrl_tbl[base_idx[core_no]]
-					     >> 24) & 0xf;
+						(tx_pwrctrl_tbl
+						 [base_idx[core_no]]
+						 >> 24) & 0xf;
 					target_gain.txgm[core_no] =
-					    (tx_pwrctrl_tbl[base_idx[core_no]]
-					     >> 28) & 0x7;
+						(tx_pwrctrl_tbl
+						 [base_idx[core_no]]
+						 >> 28) & 0x7;
 					target_gain.txlpf[core_no] =
-					    (tx_pwrctrl_tbl[base_idx[core_no]]
-					     >> 31) & 0x1;
+						(tx_pwrctrl_tbl
+						 [base_idx[core_no]]
+						 >> 31) & 0x1;
 				} else {
 					target_gain.ipa[core_no] =
-					    (tx_pwrctrl_tbl[base_idx[core_no]]
-					     >> 16) & 0xf;
+						(tx_pwrctrl_tbl
+						 [base_idx[core_no]]
+						 >> 16) & 0xf;
 					target_gain.pad[core_no] =
-					    (tx_pwrctrl_tbl[base_idx[core_no]]
-					     >> 20) & 0xf;
+						(tx_pwrctrl_tbl
+						 [base_idx[core_no]]
+						 >> 20) & 0xf;
 					target_gain.pga[core_no] =
-					    (tx_pwrctrl_tbl[base_idx[core_no]]
-					     >> 24) & 0xf;
+						(tx_pwrctrl_tbl
+						 [base_idx[core_no]]
+						 >> 24) & 0xf;
 					target_gain.txgm[core_no] =
-					    (tx_pwrctrl_tbl[base_idx[core_no]]
-					     >> 28) & 0x7;
+						(tx_pwrctrl_tbl
+						[base_idx[core_no]]
+						 >> 28) & 0x7;
 				}
 			} else {
 				target_gain.ipa[core_no] =
-				    (nphy_tpc_txgain[base_idx[core_no]] >> 16) &
-				    0x3;
+					(nphy_tpc_txgain[base_idx[core_no]] >>
+					 16) & 0x3;
 				target_gain.pad[core_no] =
-				    (nphy_tpc_txgain[base_idx[core_no]] >> 18) &
-				    0x3;
+					(nphy_tpc_txgain[base_idx[core_no]] >>
+					 18) & 0x3;
 				target_gain.pga[core_no] =
-				    (nphy_tpc_txgain[base_idx[core_no]] >> 20) &
-				    0x7;
+					(nphy_tpc_txgain[base_idx[core_no]] >>
+					 20) & 0x7;
 				target_gain.txgm[core_no] =
-				    (nphy_tpc_txgain[base_idx[core_no]] >> 23) &
-				    0x7;
+					(nphy_tpc_txgain[base_idx[core_no]] >>
+					 23) & 0x7;
 			}
 		}
 	}
@@ -22477,16 +22624,13 @@ wlc_phy_iqcal_gainparams_nphy(struct brcms_phy *pi, u16 core_no,
 		params->ipa = target_gain.ipa[core_no];
 		if (NREV_GE(pi->pubpi.phy_rev, 7))
 			params->cal_gain =
-			    ((params->txlpf << 15) | (params->
-						      txgm << 12) | (params->
-								     pga << 8) |
-			     (params->pad << 3) | (params->ipa));
+				((params->txlpf << 15) | (params->txgm << 12) |
+				 (params->pga << 8) |
+				 (params->pad << 3) | (params->ipa));
 		else
 			params->cal_gain =
-			    ((params->txgm << 12) | (params->
-						     pga << 8) | (params->
-								  pad << 4) |
-			     (params->ipa));
+				((params->txgm << 12) | (params->pga << 8) |
+				 (params->pad << 4) | (params->ipa));
 
 		params->ncorr[0] = 0x79;
 		params->ncorr[1] = 0x79;
@@ -22496,9 +22640,8 @@ wlc_phy_iqcal_gainparams_nphy(struct brcms_phy *pi, u16 core_no,
 	} else {
 
 		gain_index = ((target_gain.pad[core_no] << 0) |
-			      (target_gain.pga[core_no] << 4) | (target_gain.
-								 txgm[core_no]
-								 << 8));
+			      (target_gain.pga[core_no] << 4) |
+			      (target_gain.txgm[core_no] << 8));
 
 		idx = -1;
 		for (k = 0; k < NPHY_IQCAL_NUMGAINS; k++) {
@@ -22530,37 +22673,39 @@ static void wlc_phy_txcal_radio_setup_nphy(struct brcms_phy *pi)
 		for (core = 0; core <= 1; core++) {
 
 			pi->tx_rx_cal_radio_saveregs[(core * 11) + 0] =
-			    READ_RADIO_REG3(pi, RADIO_2057, TX, core,
-					    TX_SSI_MASTER);
+				READ_RADIO_REG3(pi, RADIO_2057, TX, core,
+						TX_SSI_MASTER);
 
 			pi->tx_rx_cal_radio_saveregs[(core * 11) + 1] =
-			    READ_RADIO_REG3(pi, RADIO_2057, TX, core,
-					    IQCAL_VCM_HG);
+				READ_RADIO_REG3(pi, RADIO_2057, TX, core,
+						IQCAL_VCM_HG);
 
 			pi->tx_rx_cal_radio_saveregs[(core * 11) + 2] =
-			    READ_RADIO_REG3(pi, RADIO_2057, TX, core,
-					    IQCAL_IDAC);
+				READ_RADIO_REG3(pi, RADIO_2057, TX, core,
+						IQCAL_IDAC);
 
 			pi->tx_rx_cal_radio_saveregs[(core * 11) + 3] =
-			    READ_RADIO_REG3(pi, RADIO_2057, TX, core, TSSI_VCM);
+				READ_RADIO_REG3(pi, RADIO_2057, TX, core,
+						TSSI_VCM);
 
 			pi->tx_rx_cal_radio_saveregs[(core * 11) + 4] = 0;
 
 			pi->tx_rx_cal_radio_saveregs[(core * 11) + 5] =
-			    READ_RADIO_REG3(pi, RADIO_2057, TX, core,
-					    TX_SSI_MUX);
+				READ_RADIO_REG3(pi, RADIO_2057, TX, core,
+						TX_SSI_MUX);
 
 			if (pi->pubpi.radiorev != 5)
 				pi->tx_rx_cal_radio_saveregs[(core * 11) + 6] =
-				    READ_RADIO_REG3(pi, RADIO_2057, TX, core,
-						    TSSIA);
+					READ_RADIO_REG3(pi, RADIO_2057, TX,
+							core,
+							TSSIA);
 
 			pi->tx_rx_cal_radio_saveregs[(core * 11) + 7] =
-			    READ_RADIO_REG3(pi, RADIO_2057, TX, core, TSSIG);
+			       READ_RADIO_REG3(pi, RADIO_2057, TX, core, TSSIG);
 
 			pi->tx_rx_cal_radio_saveregs[(core * 11) + 8] =
-			    READ_RADIO_REG3(pi, RADIO_2057, TX, core,
-					    TSSI_MISC1);
+				READ_RADIO_REG3(pi, RADIO_2057, TX, core,
+						TSSI_MISC1);
 
 			if (CHSPEC_IS5G(pi->radio_chanspec)) {
 				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
@@ -22623,58 +22768,62 @@ static void wlc_phy_txcal_radio_setup_nphy(struct brcms_phy *pi)
 
 		for (core = 0; core <= 1; core++) {
 			jtag_core =
-			    (core ==
-			     PHY_CORE_0) ? RADIO_2056_TX0 : RADIO_2056_TX1;
+				(core ==
+				 PHY_CORE_0) ? RADIO_2056_TX0 : RADIO_2056_TX1;
 
 			pi->tx_rx_cal_radio_saveregs[(core * 11) + 0] =
-			    read_radio_reg(pi,
-					   RADIO_2056_TX_TX_SSI_MASTER |
-					   jtag_core);
+				read_radio_reg(pi,
+					       RADIO_2056_TX_TX_SSI_MASTER |
+					       jtag_core);
 
 			pi->tx_rx_cal_radio_saveregs[(core * 11) + 1] =
-			    read_radio_reg(pi,
-					   RADIO_2056_TX_IQCAL_VCM_HG |
-					   jtag_core);
+				read_radio_reg(pi,
+					       RADIO_2056_TX_IQCAL_VCM_HG |
+					       jtag_core);
 
 			pi->tx_rx_cal_radio_saveregs[(core * 11) + 2] =
-			    read_radio_reg(pi,
-					   RADIO_2056_TX_IQCAL_IDAC |
-					   jtag_core);
+				read_radio_reg(pi,
+					       RADIO_2056_TX_IQCAL_IDAC |
+					       jtag_core);
 
 			pi->tx_rx_cal_radio_saveregs[(core * 11) + 3] =
-			    read_radio_reg(pi,
-					   RADIO_2056_TX_TSSI_VCM | jtag_core);
+				read_radio_reg(
+					pi,
+					RADIO_2056_TX_TSSI_VCM |
+					jtag_core);
 
 			pi->tx_rx_cal_radio_saveregs[(core * 11) + 4] =
-			    read_radio_reg(pi,
-					   RADIO_2056_TX_TX_AMP_DET |
-					   jtag_core);
+				read_radio_reg(pi,
+					       RADIO_2056_TX_TX_AMP_DET |
+					       jtag_core);
 
 			pi->tx_rx_cal_radio_saveregs[(core * 11) + 5] =
-			    read_radio_reg(pi,
-					   RADIO_2056_TX_TX_SSI_MUX |
-					   jtag_core);
+				read_radio_reg(pi,
+					       RADIO_2056_TX_TX_SSI_MUX |
+					       jtag_core);
 
 			pi->tx_rx_cal_radio_saveregs[(core * 11) + 6] =
-			    read_radio_reg(pi, RADIO_2056_TX_TSSIA | jtag_core);
+				read_radio_reg(pi,
+					       RADIO_2056_TX_TSSIA | jtag_core);
 
 			pi->tx_rx_cal_radio_saveregs[(core * 11) + 7] =
-			    read_radio_reg(pi, RADIO_2056_TX_TSSIG | jtag_core);
+				read_radio_reg(pi,
+					       RADIO_2056_TX_TSSIG | jtag_core);
 
 			pi->tx_rx_cal_radio_saveregs[(core * 11) + 8] =
-			    read_radio_reg(pi,
-					   RADIO_2056_TX_TSSI_MISC1 |
-					   jtag_core);
+				read_radio_reg(pi,
+					       RADIO_2056_TX_TSSI_MISC1 |
+					       jtag_core);
 
 			pi->tx_rx_cal_radio_saveregs[(core * 11) + 9] =
-			    read_radio_reg(pi,
-					   RADIO_2056_TX_TSSI_MISC2 |
-					   jtag_core);
+				read_radio_reg(pi,
+					       RADIO_2056_TX_TSSI_MISC2 |
+					       jtag_core);
 
 			pi->tx_rx_cal_radio_saveregs[(core * 11) + 10] =
-			    read_radio_reg(pi,
-					   RADIO_2056_TX_TSSI_MISC3 |
-					   jtag_core);
+				read_radio_reg(pi,
+					       RADIO_2056_TX_TSSI_MISC3 |
+					       jtag_core);
 
 			if (CHSPEC_IS5G(pi->radio_chanspec)) {
 				write_radio_reg(pi,
@@ -22694,16 +22843,18 @@ static void wlc_phy_txcal_radio_setup_nphy(struct brcms_phy *pi)
 						jtag_core, 0x00);
 
 				if (PHY_IPA(pi)) {
-					write_radio_reg(pi,
-							RADIO_2056_TX_TX_SSI_MUX
-							| jtag_core, 0x4);
+					write_radio_reg(
+						pi,
+						RADIO_2056_TX_TX_SSI_MUX
+						| jtag_core, 0x4);
 					write_radio_reg(pi,
 							RADIO_2056_TX_TSSIA |
 							jtag_core, 0x1);
 				} else {
-					write_radio_reg(pi,
-							RADIO_2056_TX_TX_SSI_MUX
-							| jtag_core, 0x00);
+					write_radio_reg(
+						pi,
+						RADIO_2056_TX_TX_SSI_MUX
+						| jtag_core, 0x00);
 					write_radio_reg(pi,
 							RADIO_2056_TX_TSSIA |
 							jtag_core, 0x2f);
@@ -22743,23 +22894,27 @@ static void wlc_phy_txcal_radio_setup_nphy(struct brcms_phy *pi)
 
 				if (PHY_IPA(pi)) {
 
-					write_radio_reg(pi,
-							RADIO_2056_TX_TX_SSI_MUX
-							| jtag_core, 0x06);
+					write_radio_reg(
+						pi,
+						RADIO_2056_TX_TX_SSI_MUX
+						| jtag_core, 0x06);
 					if (NREV_LT(pi->pubpi.phy_rev, 5))
-						write_radio_reg(pi,
-								RADIO_2056_TX_TSSIG
-								| jtag_core,
-								0x11);
+						write_radio_reg(
+							pi,
+							RADIO_2056_TX_TSSIG
+							| jtag_core,
+							0x11);
 					else
-						write_radio_reg(pi,
-								RADIO_2056_TX_TSSIG
-								| jtag_core,
-								0x1);
+						write_radio_reg(
+							pi,
+							RADIO_2056_TX_TSSIG
+							| jtag_core,
+							0x1);
 				} else {
-					write_radio_reg(pi,
-							RADIO_2056_TX_TX_SSI_MUX
-							| jtag_core, 0x00);
+					write_radio_reg(
+						pi,
+						RADIO_2056_TX_TX_SSI_MUX
+						| jtag_core, 0x00);
 					write_radio_reg(pi,
 							RADIO_2056_TX_TSSIG |
 							jtag_core, 0x20);
@@ -22779,23 +22934,23 @@ static void wlc_phy_txcal_radio_setup_nphy(struct brcms_phy *pi)
 	} else {
 
 		pi->tx_rx_cal_radio_saveregs[0] =
-		    read_radio_reg(pi, RADIO_2055_CORE1_TXRF_IQCAL1);
+			read_radio_reg(pi, RADIO_2055_CORE1_TXRF_IQCAL1);
 		write_radio_reg(pi, RADIO_2055_CORE1_TXRF_IQCAL1, 0x29);
 		pi->tx_rx_cal_radio_saveregs[1] =
-		    read_radio_reg(pi, RADIO_2055_CORE1_TXRF_IQCAL2);
+			read_radio_reg(pi, RADIO_2055_CORE1_TXRF_IQCAL2);
 		write_radio_reg(pi, RADIO_2055_CORE1_TXRF_IQCAL2, 0x54);
 
 		pi->tx_rx_cal_radio_saveregs[2] =
-		    read_radio_reg(pi, RADIO_2055_CORE2_TXRF_IQCAL1);
+			read_radio_reg(pi, RADIO_2055_CORE2_TXRF_IQCAL1);
 		write_radio_reg(pi, RADIO_2055_CORE2_TXRF_IQCAL1, 0x29);
 		pi->tx_rx_cal_radio_saveregs[3] =
-		    read_radio_reg(pi, RADIO_2055_CORE2_TXRF_IQCAL2);
+			read_radio_reg(pi, RADIO_2055_CORE2_TXRF_IQCAL2);
 		write_radio_reg(pi, RADIO_2055_CORE2_TXRF_IQCAL2, 0x54);
 
 		pi->tx_rx_cal_radio_saveregs[4] =
-		    read_radio_reg(pi, RADIO_2055_PWRDET_RXTX_CORE1);
+			read_radio_reg(pi, RADIO_2055_PWRDET_RXTX_CORE1);
 		pi->tx_rx_cal_radio_saveregs[5] =
-		    read_radio_reg(pi, RADIO_2055_PWRDET_RXTX_CORE2);
+			read_radio_reg(pi, RADIO_2055_PWRDET_RXTX_CORE2);
 
 		if ((read_phy_reg(pi, 0x09) & NPHY_BandControl_currentBand) ==
 		    0) {
@@ -22856,11 +23011,8 @@ static void wlc_phy_txcal_radio_cleanup_nphy(struct brcms_phy *pi)
 			if (pi->pubpi.radiorev != 5)
 				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
 						 TSSIA,
-						 pi->
-						 tx_rx_cal_radio_saveregs[(core
-									   *
-									   11) +
-									  6]);
+						 pi->tx_rx_cal_radio_saveregs
+							     [(core * 11) + 6]);
 
 			WRITE_RADIO_REG3(pi, RADIO_2057, TX, core, TSSIG,
 					 pi->
@@ -22874,9 +23026,8 @@ static void wlc_phy_txcal_radio_cleanup_nphy(struct brcms_phy *pi)
 		}
 	} else if (NREV_GE(pi->pubpi.phy_rev, 3)) {
 		for (core = 0; core <= 1; core++) {
-			jtag_core =
-			    (core ==
-			     PHY_CORE_0) ? RADIO_2056_TX0 : RADIO_2056_TX1;
+			jtag_core = (core == PHY_CORE_0) ?
+				     RADIO_2056_TX0 : RADIO_2056_TX1;
 
 			write_radio_reg(pi,
 					RADIO_2056_TX_TX_SSI_MASTER | jtag_core,
@@ -23003,19 +23154,21 @@ static void wlc_phy_txcal_physetup_nphy(struct brcms_phy *pi)
 		pi->tx_rx_cal_phy_saveregs[8] = read_phy_reg(pi, 0x92);
 
 		if (!(pi->use_int_tx_iqlo_cal_nphy))
-			wlc_phy_rfctrlintc_override_nphy(pi,
-							 NPHY_RfctrlIntc_override_PA,
-							 1,
-							 RADIO_MIMO_CORESEL_CORE1
-							 |
-							 RADIO_MIMO_CORESEL_CORE2);
+			wlc_phy_rfctrlintc_override_nphy(
+				pi,
+				NPHY_RfctrlIntc_override_PA,
+				1,
+				RADIO_MIMO_CORESEL_CORE1
+				|
+				RADIO_MIMO_CORESEL_CORE2);
 		else
-			wlc_phy_rfctrlintc_override_nphy(pi,
-							 NPHY_RfctrlIntc_override_PA,
-							 0,
-							 RADIO_MIMO_CORESEL_CORE1
-							 |
-							 RADIO_MIMO_CORESEL_CORE2);
+			wlc_phy_rfctrlintc_override_nphy(
+				pi,
+				NPHY_RfctrlIntc_override_PA,
+				0,
+				RADIO_MIMO_CORESEL_CORE1
+				|
+				RADIO_MIMO_CORESEL_CORE2);
 
 		wlc_phy_rfctrlintc_override_nphy(pi,
 						 NPHY_RfctrlIntc_override_TRSW,
@@ -23034,10 +23187,12 @@ static void wlc_phy_txcal_physetup_nphy(struct brcms_phy *pi)
 
 		if (NREV_IS(pi->pubpi.phy_rev, 7)
 		    || NREV_GE(pi->pubpi.phy_rev, 8))
-			wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 7),
-							  wlc_phy_read_lpf_bw_ctl_nphy
-							  (pi, 0), 0, 0,
-							  NPHY_REV7_RFCTRLOVERRIDE_ID1);
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 7),
+				wlc_phy_read_lpf_bw_ctl_nphy
+					(pi,
+					0), 0, 0,
+				NPHY_REV7_RFCTRLOVERRIDE_ID1);
 
 		if (pi->use_int_tx_iqlo_cal_nphy
 		    && !(pi->internal_tx_iqlo_cal_tapoff_intpa_nphy)) {
@@ -23048,25 +23203,30 @@ static void wlc_phy_txcal_physetup_nphy(struct brcms_phy *pi)
 					      1 << 4);
 
 				if (CHSPEC_IS2G(pi->radio_chanspec)) {
-					mod_radio_reg(pi,
-						      RADIO_2057_PAD2G_TUNE_PUS_CORE0,
-						      1, 0);
-					mod_radio_reg(pi,
-						      RADIO_2057_PAD2G_TUNE_PUS_CORE1,
-						      1, 0);
+					mod_radio_reg(
+						pi,
+						RADIO_2057_PAD2G_TUNE_PUS_CORE0,
+						1, 0);
+					mod_radio_reg(
+						pi,
+						RADIO_2057_PAD2G_TUNE_PUS_CORE1,
+						1, 0);
 				} else {
-					mod_radio_reg(pi,
-						      RADIO_2057_IPA5G_CASCOFFV_PU_CORE0,
-						      1, 0);
-					mod_radio_reg(pi,
-						      RADIO_2057_IPA5G_CASCOFFV_PU_CORE1,
-						      1, 0);
+					mod_radio_reg(
+					     pi,
+					     RADIO_2057_IPA5G_CASCOFFV_PU_CORE0,
+					     1, 0);
+					mod_radio_reg(
+					     pi,
+					     RADIO_2057_IPA5G_CASCOFFV_PU_CORE1,
+					     1, 0);
 				}
 			} else if (NREV_GE(pi->pubpi.phy_rev, 8)) {
-				wlc_phy_rfctrl_override_nphy_rev7(pi,
-								  (0x1 << 3), 0,
-								  0x3, 0,
-								  NPHY_REV7_RFCTRLOVERRIDE_ID0);
+				wlc_phy_rfctrl_override_nphy_rev7(
+					pi,
+					(0x1 << 3), 0,
+					0x3, 0,
+					NPHY_REV7_RFCTRLOVERRIDE_ID0);
 			}
 		}
 	} else {
@@ -23130,9 +23290,10 @@ static void wlc_phy_txcal_phycleanup_nphy(struct brcms_phy *pi)
 
 		if (NREV_IS(pi->pubpi.phy_rev, 7)
 		    || NREV_GE(pi->pubpi.phy_rev, 8))
-			wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 7), 0, 0,
-							  1,
-							  NPHY_REV7_RFCTRLOVERRIDE_ID1);
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 7), 0, 0,
+				1,
+				NPHY_REV7_RFCTRLOVERRIDE_ID1);
 
 		wlc_phy_resetcca_nphy(pi);
 
@@ -23141,28 +23302,33 @@ static void wlc_phy_txcal_phycleanup_nphy(struct brcms_phy *pi)
 
 			if (NREV_IS(pi->pubpi.phy_rev, 7)) {
 				if (CHSPEC_IS2G(pi->radio_chanspec)) {
-					mod_radio_reg(pi,
-						      RADIO_2057_PAD2G_TUNE_PUS_CORE0,
-						      1, 1);
-					mod_radio_reg(pi,
-						      RADIO_2057_PAD2G_TUNE_PUS_CORE1,
-						      1, 1);
+					mod_radio_reg(
+						pi,
+						RADIO_2057_PAD2G_TUNE_PUS_CORE0,
+						1, 1);
+					mod_radio_reg(
+						pi,
+						RADIO_2057_PAD2G_TUNE_PUS_CORE1,
+						1, 1);
 				} else {
-					mod_radio_reg(pi,
-						      RADIO_2057_IPA5G_CASCOFFV_PU_CORE0,
-						      1, 1);
-					mod_radio_reg(pi,
-						      RADIO_2057_IPA5G_CASCOFFV_PU_CORE1,
-						      1, 1);
+					mod_radio_reg(
+					     pi,
+					     RADIO_2057_IPA5G_CASCOFFV_PU_CORE0,
+					     1, 1);
+					mod_radio_reg(
+					     pi,
+					     RADIO_2057_IPA5G_CASCOFFV_PU_CORE1,
+					     1, 1);
 				}
 
 				mod_radio_reg(pi, RADIO_2057_OVR_REG0, 1 << 4,
 					      0);
 			} else if (NREV_GE(pi->pubpi.phy_rev, 8)) {
-				wlc_phy_rfctrl_override_nphy_rev7(pi,
-								  (0x1 << 3), 0,
-								  0x3, 1,
-								  NPHY_REV7_RFCTRLOVERRIDE_ID0);
+				wlc_phy_rfctrl_override_nphy_rev7(
+					pi,
+					(0x1 << 3), 0,
+					0x3, 1,
+					NPHY_REV7_RFCTRLOVERRIDE_ID0);
 			}
 		}
 	} else {
@@ -23182,7 +23348,7 @@ static void wlc_phy_txcal_phycleanup_nphy(struct brcms_phy *pi)
 	}
 }
 
-#define NPHY_CAL_TSSISAMPS	64
+#define NPHY_CAL_TSSISAMPS      64
 #define NPHY_TEST_TONE_FREQ_40MHz 4000
 #define NPHY_TEST_TONE_FREQ_20MHz 2500
 
@@ -23205,8 +23371,8 @@ wlc_phy_est_tonepwr_nphy(struct brcms_phy *pi, s32 *qdBm_pwrbuf, u8 num_samps)
 	idle_tssi[1] = (temp <= 31) ? temp : (temp - 64);
 
 	tssi_type =
-	    CHSPEC_IS5G(pi->radio_chanspec) ?
-	    (u8)NPHY_RSSI_SEL_TSSI_5G : (u8)NPHY_RSSI_SEL_TSSI_2G;
+		CHSPEC_IS5G(pi->radio_chanspec) ?
+		(u8)NPHY_RSSI_SEL_TSSI_5G : (u8)NPHY_RSSI_SEL_TSSI_2G;
 
 	wlc_phy_poll_rssi_nphy(pi, tssi_type, rssi_buf, num_samps);
 
@@ -23269,21 +23435,23 @@ static void wlc_phy_precal_txgain_nphy(struct brcms_phy *pi)
 			    (pi->pubpi.radiorev == 6)) {
 
 				pi->nphy_txcal_pwr_idx[0] =
-				    txcal_index_2057_rev3n4n6;
+					txcal_index_2057_rev3n4n6;
 				pi->nphy_txcal_pwr_idx[1] =
-				    txcal_index_2057_rev3n4n6;
-				wlc_phy_txpwr_index_nphy(pi, 3,
-							 txcal_index_2057_rev3n4n6,
-							 false);
+					txcal_index_2057_rev3n4n6;
+				wlc_phy_txpwr_index_nphy(
+					pi, 3,
+					txcal_index_2057_rev3n4n6,
+					false);
 			} else {
 
 				pi->nphy_txcal_pwr_idx[0] =
-				    txcal_index_2057_rev5n7;
+					txcal_index_2057_rev5n7;
 				pi->nphy_txcal_pwr_idx[1] =
-				    txcal_index_2057_rev5n7;
-				wlc_phy_txpwr_index_nphy(pi, 3,
-							 txcal_index_2057_rev5n7,
-							 false);
+					txcal_index_2057_rev5n7;
+				wlc_phy_txpwr_index_nphy(
+					pi, 3,
+					txcal_index_2057_rev5n7,
+					false);
 			}
 			save_bbmult = true;
 
@@ -23291,7 +23459,7 @@ static void wlc_phy_precal_txgain_nphy(struct brcms_phy *pi)
 			wlc_phy_cal_txgainctrl_nphy(pi, 11, false);
 			if (pi->sh->hw_phytxchain != 3) {
 				pi->nphy_txcal_pwr_idx[1] =
-				    pi->nphy_txcal_pwr_idx[0];
+					pi->nphy_txcal_pwr_idx[0];
 				wlc_phy_txpwr_index_nphy(pi, 3,
 							 pi->
 							 nphy_txcal_pwr_idx[0],
@@ -23520,15 +23688,15 @@ static void wlc_phy_update_txcal_ladder_nphy(struct brcms_phy *pi, u16 core)
 	};
 
 	bbmult = (core == PHY_CORE_0) ?
-	    ((pi->nphy_txcal_bbmult >> 8) & 0xff) : (pi->
-						     nphy_txcal_bbmult & 0xff);
+		 ((pi->nphy_txcal_bbmult >> 8) & 0xff) :
+		 (pi->nphy_txcal_bbmult & 0xff);
 
 	for (index = 0; index < 18; index++) {
 		bbmult_scale = ladder_lo[index].percent * bbmult;
 		bbmult_scale /= 100;
 
 		tblentry =
-		    ((bbmult_scale & 0xff) << 8) | ladder_lo[index].g_env;
+			((bbmult_scale & 0xff) << 8) | ladder_lo[index].g_env;
 		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, 1, index, 16,
 					 &tblentry);
 
@@ -23536,7 +23704,7 @@ static void wlc_phy_update_txcal_ladder_nphy(struct brcms_phy *pi, u16 core)
 		bbmult_scale /= 100;
 
 		tblentry =
-		    ((bbmult_scale & 0xff) << 8) | ladder_iq[index].g_env;
+			((bbmult_scale & 0xff) << 8) | ladder_iq[index].g_env;
 		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, 1, index + 32,
 					 16, &tblentry);
 	}
@@ -23565,7 +23733,8 @@ void wlc_phy_cal_perical_nphy_run(struct brcms_phy *pi, u8 caltype)
 
 	if (pi->cal_type_override != PHY_PERICAL_AUTO)
 		fullcal =
-		    (pi->cal_type_override == PHY_PERICAL_FULL) ? true : false;
+			(pi->cal_type_override ==
+			 PHY_PERICAL_FULL) ? true : false;
 
 	if ((pi->mphase_cal_phase_id > MPHASE_CAL_STATE_INIT)) {
 		if (pi->nphy_txiqlocal_chanspec != pi->radio_chanspec)
@@ -23582,9 +23751,9 @@ void wlc_phy_cal_perical_nphy_run(struct brcms_phy *pi, u8 caltype)
 	if ((pi->mphase_cal_phase_id == MPHASE_CAL_STATE_IDLE) ||
 	    (pi->mphase_cal_phase_id == MPHASE_CAL_STATE_INIT)) {
 		pi->nphy_cal_orig_pwr_idx[0] =
-		    (u8) ((read_phy_reg(pi, 0x1ed) >> 8) & 0x7f);
+			(u8) ((read_phy_reg(pi, 0x1ed) >> 8) & 0x7f);
 		pi->nphy_cal_orig_pwr_idx[1] =
-		    (u8) ((read_phy_reg(pi, 0x1ee) >> 8) & 0x7f);
+			(u8) ((read_phy_reg(pi, 0x1ee) >> 8) & 0x7f);
 
 		if (pi->nphy_txpwrctrl != PHY_TPC_HW_OFF) {
 			wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_RFSEQ, 2,
@@ -23613,7 +23782,8 @@ void wlc_phy_cal_perical_nphy_run(struct brcms_phy *pi, u8 caltype)
 			target_gain = pi->nphy_cal_target_gain;
 		}
 		if (0 ==
-		    wlc_phy_cal_txiqlo_nphy(pi, target_gain, fullcal, mphase)) {
+		    wlc_phy_cal_txiqlo_nphy(pi, target_gain, fullcal,
+					    mphase)) {
 			if (PHY_IPA(pi))
 				wlc_phy_a4(pi, true);
 
@@ -23625,13 +23795,9 @@ void wlc_phy_cal_perical_nphy_run(struct brcms_phy *pi, u8 caltype)
 			wlc_phyreg_enter((struct brcms_phy_pub *) pi);
 
 			if (0 == wlc_phy_cal_rxiq_nphy(pi, target_gain,
-							     (pi->
-							      first_cal_after_assoc
-							      || (pi->
-								  cal_type_override
-								  ==
-								  PHY_PERICAL_FULL))
-							     ? 2 : 0, false)) {
+					(pi->first_cal_after_assoc ||
+					(pi->cal_type_override ==
+					 PHY_PERICAL_FULL)) ? 2 : 0, false)) {
 				wlc_phy_savecal_nphy(pi);
 
 				wlc_phy_txpwrctrl_coeff_setup_nphy(pi);
@@ -23674,8 +23840,8 @@ void wlc_phy_cal_perical_nphy_run(struct brcms_phy *pi, u8 caltype)
 				pi->nphy_rxcal_active = true;
 
 			if (wlc_phy_cal_txiqlo_nphy
-			    (pi, pi->nphy_cal_target_gain, fullcal,
-			     true) != 0) {
+				    (pi, pi->nphy_cal_target_gain, fullcal,
+				    true) != 0) {
 
 				wlc_phy_cal_perical_mphase_reset(pi);
 				break;
@@ -23767,15 +23933,15 @@ void wlc_phy_cal_perical_nphy_run(struct brcms_phy *pi, u8 caltype)
 			} else {
 				wlc_phy_txpwr_index_nphy(pi, (1 << 0),
 							 (s8) (pi->
-								 nphy_txpwrindex
-								 [0].
-								 index_internal),
+							       nphy_txpwrindex
+							       [0].
+							       index_internal),
 							 false);
 				wlc_phy_txpwr_index_nphy(pi, (1 << 1),
 							 (s8) (pi->
-								 nphy_txpwrindex
-								 [1].
-								 index_internal),
+							       nphy_txpwrindex
+							       [1].
+							       index_internal),
 							 false);
 			}
 		}
@@ -23812,35 +23978,35 @@ wlc_phy_cal_txiqlo_nphy(struct brcms_phy *pi, struct nphy_txgains target_gain,
 
 	u16 tbl_tx_iqlo_cal_loft_ladder_20[] = {
 		0x0300, 0x0500, 0x0700, 0x0900, 0x0d00, 0x1100, 0x1900, 0x1901,
-		    0x1902,
+		0x1902,
 		0x1903, 0x1904, 0x1905, 0x1906, 0x1907, 0x2407, 0x3207, 0x4607,
-		    0x6407
+		0x6407
 	};
 
 	u16 tbl_tx_iqlo_cal_iqimb_ladder_20[] = {
 		0x0200, 0x0300, 0x0600, 0x0900, 0x0d00, 0x1100, 0x1900, 0x2400,
-		    0x3200,
+		0x3200,
 		0x4600, 0x6400, 0x6401, 0x6402, 0x6403, 0x6404, 0x6405, 0x6406,
-		    0x6407
+		0x6407
 	};
 
 	u16 tbl_tx_iqlo_cal_loft_ladder_40[] = {
 		0x0200, 0x0300, 0x0400, 0x0700, 0x0900, 0x0c00, 0x1200, 0x1201,
-		    0x1202,
+		0x1202,
 		0x1203, 0x1204, 0x1205, 0x1206, 0x1207, 0x1907, 0x2307, 0x3207,
-		    0x4707
+		0x4707
 	};
 
 	u16 tbl_tx_iqlo_cal_iqimb_ladder_40[] = {
 		0x0100, 0x0200, 0x0400, 0x0700, 0x0900, 0x0c00, 0x1200, 0x1900,
-		    0x2300,
+		0x2300,
 		0x3200, 0x4700, 0x4701, 0x4702, 0x4703, 0x4704, 0x4705, 0x4706,
-		    0x4707
+		0x4707
 	};
 
 	u16 tbl_tx_iqlo_cal_startcoefs[] = {
 		0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
-		    0x0000
+		0x0000
 	};
 
 	u16 tbl_tx_iqlo_cal_cmds_fullcal[] = {
@@ -23934,7 +24100,8 @@ wlc_phy_cal_txiqlo_nphy(struct brcms_phy *pi, struct nphy_txgains target_gain,
 		bcmerror = 0;
 	} else {
 		bcmerror =
-		    wlc_phy_tx_tone_nphy(pi, tone_freq, max_val, 1, 0, false);
+			wlc_phy_tx_tone_nphy(pi, tone_freq, max_val, 1, 0,
+					     false);
 	}
 
 	if (bcmerror == 0) {
@@ -23958,14 +24125,12 @@ wlc_phy_cal_txiqlo_nphy(struct brcms_phy *pi, struct nphy_txgains target_gain,
 				if (NREV_GE(pi->pubpi.phy_rev, 3)) {
 					tbl_ptr =
 					    tbl_tx_iqlo_cal_startcoefs_nphyrev3;
-					tbl_len =
-					    ARRAY_SIZE
-					    (tbl_tx_iqlo_cal_startcoefs_nphyrev3);
+					tbl_len = ARRAY_SIZE(
+					   tbl_tx_iqlo_cal_startcoefs_nphyrev3);
 				} else {
 					tbl_ptr = tbl_tx_iqlo_cal_startcoefs;
-					tbl_len =
-					    ARRAY_SIZE
-					    (tbl_tx_iqlo_cal_startcoefs);
+					tbl_len = ARRAY_SIZE(
+						    tbl_tx_iqlo_cal_startcoefs);
 				}
 			}
 		}
@@ -23974,12 +24139,14 @@ wlc_phy_cal_txiqlo_nphy(struct brcms_phy *pi, struct nphy_txgains target_gain,
 
 		if (fullcal) {
 			max_cal_cmds = (NREV_GE(pi->pubpi.phy_rev, 3)) ?
-			    ARRAY_SIZE(tbl_tx_iqlo_cal_cmds_fullcal_nphyrev3) :
-			    ARRAY_SIZE(tbl_tx_iqlo_cal_cmds_fullcal);
+				       ARRAY_SIZE(
+				tbl_tx_iqlo_cal_cmds_fullcal_nphyrev3) :
+				       ARRAY_SIZE(tbl_tx_iqlo_cal_cmds_fullcal);
 		} else {
 			max_cal_cmds = (NREV_GE(pi->pubpi.phy_rev, 3)) ?
-			    ARRAY_SIZE(tbl_tx_iqlo_cal_cmds_recal_nphyrev3) :
-			    ARRAY_SIZE(tbl_tx_iqlo_cal_cmds_recal);
+				       ARRAY_SIZE(
+				tbl_tx_iqlo_cal_cmds_recal_nphyrev3) :
+				       ARRAY_SIZE(tbl_tx_iqlo_cal_cmds_recal);
 		}
 
 		if (mphase) {
@@ -23997,13 +24164,14 @@ wlc_phy_cal_txiqlo_nphy(struct brcms_phy *pi, struct nphy_txgains target_gain,
 
 			if (fullcal) {
 				cal_cmd = (NREV_GE(pi->pubpi.phy_rev, 3)) ?
-				    tbl_tx_iqlo_cal_cmds_fullcal_nphyrev3
-				    [cal_cnt] :
-				    tbl_tx_iqlo_cal_cmds_fullcal[cal_cnt];
+					  tbl_tx_iqlo_cal_cmds_fullcal_nphyrev3
+					  [cal_cnt] :
+					  tbl_tx_iqlo_cal_cmds_fullcal[cal_cnt];
 			} else {
 				cal_cmd = (NREV_GE(pi->pubpi.phy_rev, 3)) ?
-				    tbl_tx_iqlo_cal_cmds_recal_nphyrev3[cal_cnt]
-				    : tbl_tx_iqlo_cal_cmds_recal[cal_cnt];
+					  tbl_tx_iqlo_cal_cmds_recal_nphyrev3[
+					cal_cnt]
+					  : tbl_tx_iqlo_cal_cmds_recal[cal_cnt];
 			}
 
 			core_no = ((cal_cmd & 0x3000) >> 12);
@@ -24014,15 +24182,16 @@ wlc_phy_cal_txiqlo_nphy(struct brcms_phy *pi, struct nphy_txgains target_gain,
 			     PHY_IPA(pi)
 			     && (CHSPEC_IS2G(pi->radio_chanspec)))) {
 				if (!ladder_updated[core_no]) {
-					wlc_phy_update_txcal_ladder_nphy(pi,
-									 core_no);
+					wlc_phy_update_txcal_ladder_nphy(
+						pi,
+						core_no);
 					ladder_updated[core_no] = true;
 				}
 			}
 
 			val =
-			    (cal_params[core_no].
-			     ncorr[cal_type] << 8) | NPHY_N_GCTL;
+				(cal_params[core_no].
+				 ncorr[cal_type] << 8) | NPHY_N_GCTL;
 			write_phy_reg(pi, 0xc1, val);
 
 			if ((cal_type == 1) || (cal_type == 3)
@@ -24070,8 +24239,8 @@ wlc_phy_cal_txiqlo_nphy(struct brcms_phy *pi, struct nphy_txgains target_gain,
 		}
 
 		mphase_cal_lastphase =
-		    (NREV_LE(pi->pubpi.phy_rev, 2)) ?
-		    MPHASE_CAL_STATE_TXPHASE4 : MPHASE_CAL_STATE_TXPHASE5;
+			(NREV_LE(pi->pubpi.phy_rev, 2)) ?
+			MPHASE_CAL_STATE_TXPHASE4 : MPHASE_CAL_STATE_TXPHASE5;
 
 		if (!mphase
 		    || (pi->mphase_cal_phase_id == mphase_cal_lastphase)) {
@@ -24233,14 +24402,17 @@ wlc_phy_rx_iq_est_nphy(struct brcms_phy *pi, struct phy_iq_est *est,
 	if ((read_phy_reg(pi, 0x129) & NPHY_IqestCmd_iqstart) == 0) {
 		for (core = 0; core < pi->pubpi.phy_corenum; core++) {
 			est[core].i_pwr =
-			    (read_phy_reg(pi, NPHY_IqestipwrAccHi(core)) << 16)
-			    | read_phy_reg(pi, NPHY_IqestipwrAccLo(core));
+				(read_phy_reg(pi,
+					      NPHY_IqestipwrAccHi(core)) << 16)
+				| read_phy_reg(pi, NPHY_IqestipwrAccLo(core));
 			est[core].q_pwr =
-			    (read_phy_reg(pi, NPHY_IqestqpwrAccHi(core)) << 16)
-			    | read_phy_reg(pi, NPHY_IqestqpwrAccLo(core));
+				(read_phy_reg(pi,
+					      NPHY_IqestqpwrAccHi(core)) << 16)
+				| read_phy_reg(pi, NPHY_IqestqpwrAccLo(core));
 			est[core].iq_prod =
-			    (read_phy_reg(pi, NPHY_IqestIqAccHi(core)) << 16) |
-			    read_phy_reg(pi, NPHY_IqestIqAccLo(core));
+				(read_phy_reg(pi,
+					      NPHY_IqestIqAccHi(core)) << 16) |
+				read_phy_reg(pi, NPHY_IqestIqAccLo(core));
 		}
 	}
 }
@@ -24265,7 +24437,7 @@ static void wlc_phy_calc_rx_iq_comp_nphy(struct brcms_phy *pi, u8 core_mask)
 	new_comp.a0 = new_comp.b0 = new_comp.a1 = new_comp.b1 = 0x0;
 	wlc_phy_rx_iq_coeffs_nphy(pi, 1, &new_comp);
 
- cal_try:
+cal_try:
 	wlc_phy_rx_iq_est_nphy(pi, est, 0x4000, 32, 0);
 
 	new_comp = old_comp;
@@ -24356,7 +24528,7 @@ static void wlc_phy_calc_rx_iq_comp_nphy(struct brcms_phy *pi, u8 core_mask)
 
 	if (bcmerror != 0) {
 		printk(KERN_DEBUG "%s: Failed, cnt = %d\n", __func__,
-			cal_retry);
+		       cal_retry);
 
 		if (cal_retry < CAL_RETRY_CNT) {
 			cal_retry++;
@@ -24379,121 +24551,125 @@ static void wlc_phy_rxcal_radio_setup_nphy(struct brcms_phy *pi, u8 rx_core)
 		if (rx_core == PHY_CORE_0) {
 			if (CHSPEC_IS5G(pi->radio_chanspec)) {
 				pi->tx_rx_cal_radio_saveregs[0] =
-				    read_radio_reg(pi,
-						   RADIO_2057_TX0_TXRXCOUPLE_5G_PWRUP);
+					read_radio_reg(pi,
+					    RADIO_2057_TX0_TXRXCOUPLE_5G_PWRUP);
 				pi->tx_rx_cal_radio_saveregs[1] =
-				    read_radio_reg(pi,
-						   RADIO_2057_TX0_TXRXCOUPLE_5G_ATTEN);
+					read_radio_reg(pi,
+					    RADIO_2057_TX0_TXRXCOUPLE_5G_ATTEN);
 
 				write_radio_reg(pi,
-						RADIO_2057_TX0_TXRXCOUPLE_5G_PWRUP,
-						0x3);
+					RADIO_2057_TX0_TXRXCOUPLE_5G_PWRUP,
+					0x3);
 				write_radio_reg(pi,
-						RADIO_2057_TX0_TXRXCOUPLE_5G_ATTEN,
-						0xaf);
+					RADIO_2057_TX0_TXRXCOUPLE_5G_ATTEN,
+					0xaf);
 
 			} else {
 				pi->tx_rx_cal_radio_saveregs[0] =
-				    read_radio_reg(pi,
-						   RADIO_2057_TX0_TXRXCOUPLE_2G_PWRUP);
+					read_radio_reg(pi,
+					    RADIO_2057_TX0_TXRXCOUPLE_2G_PWRUP);
 				pi->tx_rx_cal_radio_saveregs[1] =
-				    read_radio_reg(pi,
-						   RADIO_2057_TX0_TXRXCOUPLE_2G_ATTEN);
-
-				write_radio_reg(pi,
-						RADIO_2057_TX0_TXRXCOUPLE_2G_PWRUP,
-						0x3);
-				write_radio_reg(pi,
-						RADIO_2057_TX0_TXRXCOUPLE_2G_ATTEN,
-						0x7f);
+					read_radio_reg(pi,
+					    RADIO_2057_TX0_TXRXCOUPLE_2G_ATTEN);
+
+				write_radio_reg(
+					pi,
+					RADIO_2057_TX0_TXRXCOUPLE_2G_PWRUP,
+					0x3);
+				write_radio_reg(
+					pi,
+					RADIO_2057_TX0_TXRXCOUPLE_2G_ATTEN,
+					0x7f);
 			}
 
 		} else {
 			if (CHSPEC_IS5G(pi->radio_chanspec)) {
 				pi->tx_rx_cal_radio_saveregs[0] =
-				    read_radio_reg(pi,
-						   RADIO_2057_TX1_TXRXCOUPLE_5G_PWRUP);
+					read_radio_reg(pi,
+					    RADIO_2057_TX1_TXRXCOUPLE_5G_PWRUP);
 				pi->tx_rx_cal_radio_saveregs[1] =
-				    read_radio_reg(pi,
-						   RADIO_2057_TX1_TXRXCOUPLE_5G_ATTEN);
-
-				write_radio_reg(pi,
-						RADIO_2057_TX1_TXRXCOUPLE_5G_PWRUP,
-						0x3);
-				write_radio_reg(pi,
-						RADIO_2057_TX1_TXRXCOUPLE_5G_ATTEN,
-						0xaf);
+					read_radio_reg(pi,
+					    RADIO_2057_TX1_TXRXCOUPLE_5G_ATTEN);
+
+				write_radio_reg(
+					pi,
+					RADIO_2057_TX1_TXRXCOUPLE_5G_PWRUP,
+					0x3);
+				write_radio_reg(
+					pi,
+					RADIO_2057_TX1_TXRXCOUPLE_5G_ATTEN,
+					0xaf);
 
 			} else {
 				pi->tx_rx_cal_radio_saveregs[0] =
-				    read_radio_reg(pi,
-						   RADIO_2057_TX1_TXRXCOUPLE_2G_PWRUP);
+					read_radio_reg(pi,
+					    RADIO_2057_TX1_TXRXCOUPLE_2G_PWRUP);
 				pi->tx_rx_cal_radio_saveregs[1] =
-				    read_radio_reg(pi,
-						   RADIO_2057_TX1_TXRXCOUPLE_2G_ATTEN);
+					read_radio_reg(pi,
+					    RADIO_2057_TX1_TXRXCOUPLE_2G_ATTEN);
 
 				write_radio_reg(pi,
-						RADIO_2057_TX1_TXRXCOUPLE_2G_PWRUP,
-						0x3);
+					RADIO_2057_TX1_TXRXCOUPLE_2G_PWRUP,
+					0x3);
 				write_radio_reg(pi,
-						RADIO_2057_TX1_TXRXCOUPLE_2G_ATTEN,
-						0x7f);
+					RADIO_2057_TX1_TXRXCOUPLE_2G_ATTEN,
+					0x7f);
 			}
 		}
 
 	} else {
 		if (rx_core == PHY_CORE_0) {
 			pi->tx_rx_cal_radio_saveregs[0] =
-			    read_radio_reg(pi,
-					   RADIO_2056_TX_RXIQCAL_TXMUX |
-					   RADIO_2056_TX1);
+				read_radio_reg(pi,
+					       RADIO_2056_TX_RXIQCAL_TXMUX |
+					       RADIO_2056_TX1);
 			pi->tx_rx_cal_radio_saveregs[1] =
-			    read_radio_reg(pi,
-					   RADIO_2056_RX_RXIQCAL_RXMUX |
-					   RADIO_2056_RX0);
+				read_radio_reg(pi,
+					       RADIO_2056_RX_RXIQCAL_RXMUX |
+					       RADIO_2056_RX0);
 
 			if (pi->pubpi.radiorev >= 5) {
 				pi->tx_rx_cal_radio_saveregs[2] =
-				    read_radio_reg(pi,
-						   RADIO_2056_RX_RXSPARE2 |
-						   RADIO_2056_RX0);
+					read_radio_reg(pi,
+						       RADIO_2056_RX_RXSPARE2 |
+						       RADIO_2056_RX0);
 				pi->tx_rx_cal_radio_saveregs[3] =
-				    read_radio_reg(pi,
-						   RADIO_2056_TX_TXSPARE2 |
-						   RADIO_2056_TX1);
+					read_radio_reg(pi,
+						       RADIO_2056_TX_TXSPARE2 |
+						       RADIO_2056_TX1);
 			}
 
 			if (CHSPEC_IS5G(pi->radio_chanspec)) {
 
 				if (pi->pubpi.radiorev >= 5) {
 					pi->tx_rx_cal_radio_saveregs[4] =
-					    read_radio_reg(pi,
-							   RADIO_2056_RX_LNAA_MASTER
-							   | RADIO_2056_RX0);
+						read_radio_reg(pi,
+						      RADIO_2056_RX_LNAA_MASTER
+						      | RADIO_2056_RX0);
 
-					write_radio_reg(pi,
-							RADIO_2056_RX_LNAA_MASTER
-							| RADIO_2056_RX0, 0x40);
+					write_radio_reg(
+						pi,
+						RADIO_2056_RX_LNAA_MASTER
+						| RADIO_2056_RX0, 0x40);
 
 					write_radio_reg(pi,
-							RADIO_2056_TX_TXSPARE2 |
-							RADIO_2056_TX1, bias_a);
+						RADIO_2056_TX_TXSPARE2 |
+						RADIO_2056_TX1, bias_a);
 
 					write_radio_reg(pi,
-							RADIO_2056_RX_RXSPARE2 |
-							RADIO_2056_RX0, bias_a);
+						RADIO_2056_RX_RXSPARE2 |
+						RADIO_2056_RX0, bias_a);
 				} else {
 					pi->tx_rx_cal_radio_saveregs[4] =
-					    read_radio_reg(pi,
-							   RADIO_2056_RX_LNAA_TUNE
-							   | RADIO_2056_RX0);
+						read_radio_reg(pi,
+							RADIO_2056_RX_LNAA_TUNE
+							| RADIO_2056_RX0);
 
 					offtune_val =
-					    (pi->
-					     tx_rx_cal_radio_saveregs[2] & 0xF0)
-					    >> 8;
+						(pi->tx_rx_cal_radio_saveregs
+						 [2] & 0xF0) >> 8;
 					offtune_val =
-					    (offtune_val <= 0x7) ? 0xF : 0;
+						(offtune_val <= 0x7) ? 0xF : 0;
 
 					mod_radio_reg(pi,
 						      RADIO_2056_RX_LNAA_TUNE |
@@ -24510,34 +24686,41 @@ static void wlc_phy_rxcal_radio_setup_nphy(struct brcms_phy *pi, u8 rx_core)
 			} else {
 				if (pi->pubpi.radiorev >= 5) {
 					pi->tx_rx_cal_radio_saveregs[4] =
-					    read_radio_reg(pi,
-							   RADIO_2056_RX_LNAG_MASTER
-							   | RADIO_2056_RX0);
-
-					write_radio_reg(pi,
-							RADIO_2056_RX_LNAG_MASTER
-							| RADIO_2056_RX0, 0x40);
-
-					write_radio_reg(pi,
-							RADIO_2056_TX_TXSPARE2 |
-							RADIO_2056_TX1, bias_g);
-
-					write_radio_reg(pi,
-							RADIO_2056_RX_RXSPARE2 |
-							RADIO_2056_RX0, bias_g);
+						read_radio_reg(
+						      pi,
+						      RADIO_2056_RX_LNAG_MASTER
+						    | RADIO_2056_RX0);
+
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
 
 				} else {
 					pi->tx_rx_cal_radio_saveregs[4] =
-					    read_radio_reg(pi,
-							   RADIO_2056_RX_LNAG_TUNE
-							   | RADIO_2056_RX0);
+						read_radio_reg(
+							pi,
+							RADIO_2056_RX_LNAG_TUNE
+							| RADIO_2056_RX0);
 
 					offtune_val =
-					    (pi->
-					     tx_rx_cal_radio_saveregs[2] & 0xF0)
-					    >> 8;
+						(pi->
+						 tx_rx_cal_radio_saveregs[2] &
+						 0xF0) >> 8;
 					offtune_val =
-					    (offtune_val <= 0x7) ? 0xF : 0;
+						(offtune_val <= 0x7) ? 0xF : 0;
 
 					mod_radio_reg(pi,
 						      RADIO_2056_RX_LNAG_TUNE |
@@ -24555,56 +24738,63 @@ static void wlc_phy_rxcal_radio_setup_nphy(struct brcms_phy *pi, u8 rx_core)
 
 		} else {
 			pi->tx_rx_cal_radio_saveregs[0] =
-			    read_radio_reg(pi,
-					   RADIO_2056_TX_RXIQCAL_TXMUX |
-					   RADIO_2056_TX0);
+				read_radio_reg(pi,
+					       RADIO_2056_TX_RXIQCAL_TXMUX |
+					       RADIO_2056_TX0);
 			pi->tx_rx_cal_radio_saveregs[1] =
-			    read_radio_reg(pi,
-					   RADIO_2056_RX_RXIQCAL_RXMUX |
-					   RADIO_2056_RX1);
+				read_radio_reg(pi,
+					       RADIO_2056_RX_RXIQCAL_RXMUX |
+					       RADIO_2056_RX1);
 
 			if (pi->pubpi.radiorev >= 5) {
 				pi->tx_rx_cal_radio_saveregs[2] =
-				    read_radio_reg(pi,
-						   RADIO_2056_RX_RXSPARE2 |
-						   RADIO_2056_RX1);
+					read_radio_reg(pi,
+						       RADIO_2056_RX_RXSPARE2 |
+						       RADIO_2056_RX1);
 				pi->tx_rx_cal_radio_saveregs[3] =
-				    read_radio_reg(pi,
-						   RADIO_2056_TX_TXSPARE2 |
-						   RADIO_2056_TX0);
+					read_radio_reg(pi,
+						       RADIO_2056_TX_TXSPARE2 |
+						       RADIO_2056_TX0);
 			}
 
 			if (CHSPEC_IS5G(pi->radio_chanspec)) {
 
 				if (pi->pubpi.radiorev >= 5) {
 					pi->tx_rx_cal_radio_saveregs[4] =
-					    read_radio_reg(pi,
-							   RADIO_2056_RX_LNAA_MASTER
-							   | RADIO_2056_RX1);
-
-					write_radio_reg(pi,
-							RADIO_2056_RX_LNAA_MASTER
-							| RADIO_2056_RX1, 0x40);
-
-					write_radio_reg(pi,
-							RADIO_2056_TX_TXSPARE2 |
-							RADIO_2056_TX0, bias_a);
-
-					write_radio_reg(pi,
-							RADIO_2056_RX_RXSPARE2 |
-							RADIO_2056_RX1, bias_a);
+						read_radio_reg(
+						       pi,
+						       RADIO_2056_RX_LNAA_MASTER
+						       | RADIO_2056_RX1);
+
+					write_radio_reg(
+						pi,
+						RADIO_2056_RX_LNAA_MASTER |
+						RADIO_2056_RX1, 0x40);
+
+					write_radio_reg(
+						pi,
+						RADIO_2056_TX_TXSPARE2
+						|
+						RADIO_2056_TX0, bias_a);
+
+					write_radio_reg(
+						pi,
+						RADIO_2056_RX_RXSPARE2
+						|
+						RADIO_2056_RX1, bias_a);
 				} else {
 					pi->tx_rx_cal_radio_saveregs[4] =
-					    read_radio_reg(pi,
-							   RADIO_2056_RX_LNAA_TUNE
-							   | RADIO_2056_RX1);
+						read_radio_reg(
+							pi,
+							RADIO_2056_RX_LNAA_TUNE
+							| RADIO_2056_RX1);
 
 					offtune_val =
-					    (pi->
-					     tx_rx_cal_radio_saveregs[2] & 0xF0)
-					    >> 8;
+						(pi->
+						 tx_rx_cal_radio_saveregs[2] &
+						 0xF0) >> 8;
 					offtune_val =
-					    (offtune_val <= 0x7) ? 0xF : 0;
+						(offtune_val <= 0x7) ? 0xF : 0;
 
 					mod_radio_reg(pi,
 						      RADIO_2056_RX_LNAA_TUNE |
@@ -24621,33 +24811,40 @@ static void wlc_phy_rxcal_radio_setup_nphy(struct brcms_phy *pi, u8 rx_core)
 			} else {
 				if (pi->pubpi.radiorev >= 5) {
 					pi->tx_rx_cal_radio_saveregs[4] =
-					    read_radio_reg(pi,
-							   RADIO_2056_RX_LNAG_MASTER
-							   | RADIO_2056_RX1);
-
-					write_radio_reg(pi,
-							RADIO_2056_RX_LNAG_MASTER
-							| RADIO_2056_RX1, 0x40);
-
-					write_radio_reg(pi,
-							RADIO_2056_TX_TXSPARE2 |
-							RADIO_2056_TX0, bias_g);
-
-					write_radio_reg(pi,
-							RADIO_2056_RX_RXSPARE2 |
-							RADIO_2056_RX1, bias_g);
+						read_radio_reg(
+						      pi,
+						      RADIO_2056_RX_LNAG_MASTER
+						    | RADIO_2056_RX1);
+
+					write_radio_reg(
+						pi,
+						RADIO_2056_RX_LNAG_MASTER
+						| RADIO_2056_RX1, 0x40);
+
+					write_radio_reg(
+						pi,
+						RADIO_2056_TX_TXSPARE2
+						|
+						RADIO_2056_TX0, bias_g);
+
+					write_radio_reg(
+						pi,
+						RADIO_2056_RX_RXSPARE2
+						|
+						RADIO_2056_RX1, bias_g);
 				} else {
 					pi->tx_rx_cal_radio_saveregs[4] =
-					    read_radio_reg(pi,
-							   RADIO_2056_RX_LNAG_TUNE
-							   | RADIO_2056_RX1);
+						read_radio_reg(
+							pi,
+							RADIO_2056_RX_LNAG_TUNE
+							| RADIO_2056_RX1);
 
 					offtune_val =
-					    (pi->
-					     tx_rx_cal_radio_saveregs[2] & 0xF0)
-					    >> 8;
+						(pi->
+						 tx_rx_cal_radio_saveregs[2] &
+						 0xF0) >> 8;
 					offtune_val =
-					    (offtune_val <= 0x7) ? 0xF : 0;
+						(offtune_val <= 0x7) ? 0xF : 0;
 
 					mod_radio_reg(pi,
 						      RADIO_2056_RX_LNAG_TUNE |
@@ -24671,46 +24868,54 @@ static void wlc_phy_rxcal_radio_cleanup_nphy(struct brcms_phy *pi, u8 rx_core)
 	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 		if (rx_core == PHY_CORE_0) {
 			if (CHSPEC_IS5G(pi->radio_chanspec)) {
-				write_radio_reg(pi,
-						RADIO_2057_TX0_TXRXCOUPLE_5G_PWRUP,
-						pi->
-						tx_rx_cal_radio_saveregs[0]);
-				write_radio_reg(pi,
-						RADIO_2057_TX0_TXRXCOUPLE_5G_ATTEN,
-						pi->
-						tx_rx_cal_radio_saveregs[1]);
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
 
 			} else {
-				write_radio_reg(pi,
-						RADIO_2057_TX0_TXRXCOUPLE_2G_PWRUP,
-						pi->
-						tx_rx_cal_radio_saveregs[0]);
-				write_radio_reg(pi,
-						RADIO_2057_TX0_TXRXCOUPLE_2G_ATTEN,
-						pi->
-						tx_rx_cal_radio_saveregs[1]);
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
 			}
 
 		} else {
 			if (CHSPEC_IS5G(pi->radio_chanspec)) {
-				write_radio_reg(pi,
-						RADIO_2057_TX1_TXRXCOUPLE_5G_PWRUP,
-						pi->
-						tx_rx_cal_radio_saveregs[0]);
-				write_radio_reg(pi,
-						RADIO_2057_TX1_TXRXCOUPLE_5G_ATTEN,
-						pi->
-						tx_rx_cal_radio_saveregs[1]);
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
 
 			} else {
-				write_radio_reg(pi,
-						RADIO_2057_TX1_TXRXCOUPLE_2G_PWRUP,
-						pi->
-						tx_rx_cal_radio_saveregs[0]);
-				write_radio_reg(pi,
-						RADIO_2057_TX1_TXRXCOUPLE_2G_ATTEN,
-						pi->
-						tx_rx_cal_radio_saveregs[1]);
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
 			}
 		}
 
@@ -24742,34 +24947,38 @@ static void wlc_phy_rxcal_radio_cleanup_nphy(struct brcms_phy *pi, u8 rx_core)
 
 			if (CHSPEC_IS5G(pi->radio_chanspec)) {
 				if (pi->pubpi.radiorev >= 5)
-					write_radio_reg(pi,
-							RADIO_2056_RX_LNAA_MASTER
-							| RADIO_2056_RX0,
-							pi->
-							tx_rx_cal_radio_saveregs
-							[4]);
+					write_radio_reg(
+						pi,
+						RADIO_2056_RX_LNAA_MASTER
+						| RADIO_2056_RX0,
+						pi->
+						tx_rx_cal_radio_saveregs
+						[4]);
 				else
-					write_radio_reg(pi,
-							RADIO_2056_RX_LNAA_TUNE
-							| RADIO_2056_RX0,
-							pi->
-							tx_rx_cal_radio_saveregs
-							[4]);
+					write_radio_reg(
+						pi,
+						RADIO_2056_RX_LNAA_TUNE
+						| RADIO_2056_RX0,
+						pi->
+						tx_rx_cal_radio_saveregs
+						[4]);
 			} else {
 				if (pi->pubpi.radiorev >= 5)
-					write_radio_reg(pi,
-							RADIO_2056_RX_LNAG_MASTER
-							| RADIO_2056_RX0,
-							pi->
-							tx_rx_cal_radio_saveregs
-							[4]);
+					write_radio_reg(
+						pi,
+						RADIO_2056_RX_LNAG_MASTER
+						| RADIO_2056_RX0,
+						pi->
+						tx_rx_cal_radio_saveregs
+						[4]);
 				else
-					write_radio_reg(pi,
-							RADIO_2056_RX_LNAG_TUNE
-							| RADIO_2056_RX0,
-							pi->
-							tx_rx_cal_radio_saveregs
-							[4]);
+					write_radio_reg(
+						pi,
+						RADIO_2056_RX_LNAG_TUNE
+						| RADIO_2056_RX0,
+						pi->
+						tx_rx_cal_radio_saveregs
+						[4]);
 			}
 
 		} else {
@@ -24799,34 +25008,38 @@ static void wlc_phy_rxcal_radio_cleanup_nphy(struct brcms_phy *pi, u8 rx_core)
 
 			if (CHSPEC_IS5G(pi->radio_chanspec)) {
 				if (pi->pubpi.radiorev >= 5)
-					write_radio_reg(pi,
-							RADIO_2056_RX_LNAA_MASTER
-							| RADIO_2056_RX1,
-							pi->
-							tx_rx_cal_radio_saveregs
-							[4]);
+					write_radio_reg(
+						pi,
+						RADIO_2056_RX_LNAA_MASTER
+						| RADIO_2056_RX1,
+						pi->
+						tx_rx_cal_radio_saveregs
+						[4]);
 				else
-					write_radio_reg(pi,
-							RADIO_2056_RX_LNAA_TUNE
-							| RADIO_2056_RX1,
-							pi->
-							tx_rx_cal_radio_saveregs
-							[4]);
+					write_radio_reg(
+						pi,
+						RADIO_2056_RX_LNAA_TUNE
+						| RADIO_2056_RX1,
+						pi->
+						tx_rx_cal_radio_saveregs
+						[4]);
 			} else {
 				if (pi->pubpi.radiorev >= 5)
-					write_radio_reg(pi,
-							RADIO_2056_RX_LNAG_MASTER
-							| RADIO_2056_RX1,
-							pi->
-							tx_rx_cal_radio_saveregs
-							[4]);
+					write_radio_reg(
+						pi,
+						RADIO_2056_RX_LNAG_MASTER
+						| RADIO_2056_RX1,
+						pi->
+						tx_rx_cal_radio_saveregs
+						[4]);
 				else
-					write_radio_reg(pi,
-							RADIO_2056_RX_LNAG_TUNE
-							| RADIO_2056_RX1,
-							pi->
-							tx_rx_cal_radio_saveregs
-							[4]);
+					write_radio_reg(
+						pi,
+						RADIO_2056_RX_LNAG_TUNE
+						| RADIO_2056_RX1,
+						pi->
+						tx_rx_cal_radio_saveregs
+						[4]);
 			}
 		}
 	}
@@ -24844,9 +25057,9 @@ static void wlc_phy_rxcal_physetup_nphy(struct brcms_phy *pi, u8 rx_core)
 
 	pi->tx_rx_cal_phy_saveregs[0] = read_phy_reg(pi, 0xa2);
 	pi->tx_rx_cal_phy_saveregs[1] =
-	    read_phy_reg(pi, (rx_core == PHY_CORE_0) ? 0xa6 : 0xa7);
+		read_phy_reg(pi, (rx_core == PHY_CORE_0) ? 0xa6 : 0xa7);
 	pi->tx_rx_cal_phy_saveregs[2] =
-	    read_phy_reg(pi, (rx_core == PHY_CORE_0) ? 0x8f : 0xa5);
+		read_phy_reg(pi, (rx_core == PHY_CORE_0) ? 0x8f : 0xa5);
 	pi->tx_rx_cal_phy_saveregs[3] = read_phy_reg(pi, 0x91);
 	pi->tx_rx_cal_phy_saveregs[4] = read_phy_reg(pi, 0x92);
 	pi->tx_rx_cal_phy_saveregs[5] = read_phy_reg(pi, 0x7a);
@@ -24912,15 +25125,17 @@ static void wlc_phy_rxcal_physetup_nphy(struct brcms_phy *pi, u8 rx_core)
 		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 11), 0, 0, 0,
 						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
 		if (CHSPEC_IS40(pi->radio_chanspec))
-			wlc_phy_rfctrl_override_nphy_rev7(pi,
-							  (0x1 << 7),
-							  2, 0, 0,
-							  NPHY_REV7_RFCTRLOVERRIDE_ID1);
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi,
+				(0x1 << 7),
+				2, 0, 0,
+				NPHY_REV7_RFCTRLOVERRIDE_ID1);
 		else
-			wlc_phy_rfctrl_override_nphy_rev7(pi,
-							  (0x1 << 7),
-							  0, 0, 0,
-							  NPHY_REV7_RFCTRLOVERRIDE_ID1);
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi,
+				(0x1 << 7),
+				0, 0, 0,
+				NPHY_REV7_RFCTRLOVERRIDE_ID1);
 
 		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 7),
 						  0, 0, 0,
@@ -24992,8 +25207,8 @@ wlc_phy_rxcal_gainctrl_nphy_rev5(struct brcms_phy *pi, u8 rx_core,
 	struct phy_iq_est est[PHY_CORE_MAX];
 	u8 tx_core;
 	struct nphy_iq_comp save_comp, zero_comp;
-	u32 i_pwr, q_pwr, curr_pwr, optim_pwr = 0, prev_pwr = 0, thresh_pwr =
-	    10000;
+	u32 i_pwr, q_pwr, curr_pwr, optim_pwr = 0, prev_pwr = 0,
+	    thresh_pwr = 10000;
 	s16 desired_log2_pwr, actual_log2_pwr, delta_pwr;
 	bool gainctrl_done = false;
 	u8 mix_tia_gain = 3;
@@ -25039,7 +25254,7 @@ wlc_phy_rxcal_gainctrl_nphy_rev5(struct brcms_phy *pi, u8 rx_core,
 	do {
 
 		hpvga = (NREV_GE(pi->pubpi.phy_rev, 7)) ?
-		    0 : nphy_rxcal_gaintbl[curr_gaintbl_index].hpvga;
+			0 : nphy_rxcal_gaintbl[curr_gaintbl_index].hpvga;
 		lpf_biq1 = nphy_rxcal_gaintbl[curr_gaintbl_index].lpf_biq1;
 		lpf_biq0 = nphy_rxcal_gaintbl[curr_gaintbl_index].lpf_biq0;
 		lna2 = nphy_rxcal_gaintbl[curr_gaintbl_index].lna2;
@@ -25047,13 +25262,13 @@ wlc_phy_rxcal_gainctrl_nphy_rev5(struct brcms_phy *pi, u8 rx_core,
 		txpwrindex = nphy_rxcal_gaintbl[curr_gaintbl_index].txpwrindex;
 
 		if (NREV_GE(pi->pubpi.phy_rev, 7))
-			wlc_phy_rfctrl_override_1tomany_nphy(pi,
-							     NPHY_REV7_RfctrlOverride_cmd_rxgain,
-							     ((lpf_biq1 << 12) |
-							      (lpf_biq0 << 8) |
-							      (mix_tia_gain <<
-							       4) | (lna2 << 2)
-							      | lna1), 0x3, 0);
+			wlc_phy_rfctrl_override_1tomany_nphy(
+				pi,
+				NPHY_REV7_RfctrlOverride_cmd_rxgain,
+				((lpf_biq1 << 12) |
+				 (lpf_biq0 << 8) |
+				 (mix_tia_gain << 4) | (lna2 << 2)
+				 | lna1), 0x3, 0);
 		else
 			wlc_phy_rfctrl_override_nphy(pi, (0x1 << 12),
 						     ((hpvga << 12) |
@@ -25155,22 +25370,23 @@ wlc_phy_rxcal_gainctrl_nphy_rev5(struct brcms_phy *pi, u8 rx_core,
 		else
 			lpf_biq1 = (u16) max(fine_gain_idx, 0);
 
-		wlc_phy_rfctrl_override_1tomany_nphy(pi,
-						     NPHY_REV7_RfctrlOverride_cmd_rxgain,
-						     ((lpf_biq1 << 12) |
-						      (lpf_biq0 << 8) |
-						      (mix_tia_gain << 4) |
-						      (lna2 << 2) | lna1), 0x3,
-						     0);
+		wlc_phy_rfctrl_override_1tomany_nphy(
+			pi,
+			NPHY_REV7_RfctrlOverride_cmd_rxgain,
+			((lpf_biq1 << 12) |
+			 (lpf_biq0 << 8) |
+			 (mix_tia_gain << 4) |
+			 (lna2 << 2) | lna1), 0x3,
+			0);
 	} else {
 		hpvga = (u16) max(min(((int)hpvga) + delta_pwr, 10), 0);
 		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 12),
-					     ((hpvga << 12) | (lpf_biq1 << 10) |
-					      (lpf_biq0 << 8) | (mix_tia_gain <<
-								 4) | (lna2 <<
-								       2) |
+					     ((hpvga << 12) |
+					      (lpf_biq1 << 10) |
+					      (lpf_biq0 << 8) |
+					      (mix_tia_gain << 4) |
+					      (lna2 << 2) |
 					      lna1), 0x3, 0);
-
 	}
 
 	if (rxgain != NULL) {
@@ -25247,20 +25463,21 @@ wlc_phy_rc_sweep_nphy(struct brcms_phy *pi, u8 core_idx, u8 loopback_type)
 	if (core_idx == 0) {
 		radio_addr_offset_rx = RADIO_2056_RX0;
 		radio_addr_offset_tx =
-		    (loopback_type == 0) ? RADIO_2056_TX0 : RADIO_2056_TX1;
+			(loopback_type == 0) ? RADIO_2056_TX0 : RADIO_2056_TX1;
 	} else {
 		radio_addr_offset_rx = RADIO_2056_RX1;
 		radio_addr_offset_tx =
-		    (loopback_type == 0) ? RADIO_2056_TX1 : RADIO_2056_TX0;
+			(loopback_type == 0) ? RADIO_2056_TX1 : RADIO_2056_TX0;
 	}
 
 	orig_txlpf_rccal_lpc_ovr_val =
-	    read_radio_reg(pi,
-			   (RADIO_2056_TX_TXLPF_RCCAL | radio_addr_offset_tx));
+		read_radio_reg(pi,
+			       (RADIO_2056_TX_TXLPF_RCCAL |
+				radio_addr_offset_tx));
 	orig_rxlpf_rccal_hpc_ovr_val =
-	    read_radio_reg(pi,
-			   (RADIO_2056_RX_RXLPF_RCCAL_HPC |
-			    radio_addr_offset_rx));
+		read_radio_reg(pi,
+			       (RADIO_2056_RX_RXLPF_RCCAL_HPC |
+				radio_addr_offset_rx));
 
 	orig_dcBypass = ((read_phy_reg(pi, 0x48) >> 8) & 1);
 
@@ -25333,14 +25550,16 @@ wlc_phy_rc_sweep_nphy(struct brcms_phy *pi, u8 core_idx, u8 loopback_type)
 
 			if (core_idx == 0)
 				ref_iq_vals =
-				    max_t(u32, (est[0].i_pwr +
-					 est[0].q_pwr) >> (log_num_samps + 1),
-					1);
+					max_t(u32, (est[0].i_pwr +
+						    est[0].q_pwr) >>
+					      (log_num_samps + 1),
+					      1);
 			else
 				ref_iq_vals =
-				    max_t(u32, (est[1].i_pwr +
-					 est[1].q_pwr) >> (log_num_samps + 1),
-					1);
+					max_t(u32, (est[1].i_pwr +
+						    est[1].q_pwr) >>
+					      (log_num_samps + 1),
+					      1);
 
 			wlc_phy_tx_tone_nphy(pi, target_bw, NPHY_RXCAL_TONEAMP,
 					     0, 1, false);
@@ -25350,13 +25569,12 @@ wlc_phy_rc_sweep_nphy(struct brcms_phy *pi, u8 core_idx, u8 loopback_type)
 		wlc_phy_rx_iq_est_nphy(pi, est, num_samps, 32, 0);
 
 		if (core_idx == 0)
-			target_iq_vals =
-			    (est[0].i_pwr + est[0].q_pwr) >> (log_num_samps +
-							      1);
+			target_iq_vals = (est[0].i_pwr + est[0].q_pwr) >>
+					 (log_num_samps + 1);
 		else
 			target_iq_vals =
-			    (est[1].i_pwr + est[1].q_pwr) >> (log_num_samps +
-							      1);
+				(est[1].i_pwr +
+				 est[1].q_pwr) >> (log_num_samps + 1);
 
 		pwr_ratio = (uint) ((target_iq_vals << 16) / ref_iq_vals);
 
@@ -25375,10 +25593,11 @@ wlc_phy_rc_sweep_nphy(struct brcms_phy *pi, u8 core_idx, u8 loopback_type)
 
 		if (rccal_stepsize == -1) {
 			best_rccal_val =
-			    (ABS((int)last_pwr_ratio - (int)target_pwr_ratio) <
-			     ABS((int)pwr_ratio -
-				 (int)target_pwr_ratio)) ? last_rccal_val :
-			    rccal_val;
+				(ABS((int)last_pwr_ratio -
+				     (int)target_pwr_ratio) <
+				 ABS((int)pwr_ratio -
+				     (int)target_pwr_ratio)) ? last_rccal_val :
+				rccal_val;
 
 			if (CHSPEC_IS40(pi->radio_chanspec)) {
 				if ((best_rccal_val > 140)
@@ -25428,7 +25647,7 @@ wlc_phy_rc_sweep_nphy(struct brcms_phy *pi, u8 core_idx, u8 loopback_type)
 	return best_rccal_val - 0x80;
 }
 
-#define WAIT_FOR_SCOPE	4000
+#define WAIT_FOR_SCOPE  4000
 static int wlc_phy_cal_rxiq_nphy_rev3(struct brcms_phy *pi,
 				      struct nphy_txgains target_gain,
 				      u8 cal_type, bool debug)
@@ -25466,12 +25685,12 @@ static int wlc_phy_cal_rxiq_nphy_rev3(struct brcms_phy *pi,
 	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x110, 16, cal_gain);
 
 	rxcore_state = wlc_phy_rxcore_getstate_nphy(
-						(struct brcms_phy_pub *) pi);
+		(struct brcms_phy_pub *) pi);
 
 	for (rx_core = 0; rx_core < pi->pubpi.phy_corenum; rx_core++) {
 
 		skip_rxiqcal =
-		    ((rxcore_state & (1 << rx_core)) == 0) ? true : false;
+			((rxcore_state & (1 << rx_core)) == 0) ? true : false;
 
 		wlc_phy_rxcal_physetup_nphy(pi, rx_core);
 
@@ -25482,7 +25701,8 @@ static int wlc_phy_cal_rxiq_nphy_rev3(struct brcms_phy *pi,
 			wlc_phy_rxcal_gainctrl_nphy(pi, rx_core, NULL, 0);
 
 			wlc_phy_tx_tone_nphy(pi,
-					     (CHSPEC_IS40(pi->radio_chanspec)) ?
+					     (CHSPEC_IS40(
+						      pi->radio_chanspec)) ?
 					     NPHY_RXCAL_TONEFREQ_40MHz :
 					     NPHY_RXCAL_TONEFREQ_20MHz,
 					     NPHY_RXCAL_TONEAMP, 0, cal_type,
@@ -25508,7 +25728,7 @@ static int wlc_phy_cal_rxiq_nphy_rev3(struct brcms_phy *pi,
 							    1);
 
 				best_rccal[rx_core] =
-				    wlc_phy_rc_sweep_nphy(pi, rx_core, 1);
+					wlc_phy_rc_sweep_nphy(pi, rx_core, 1);
 				pi->nphy_rccal_value = best_rccal[rx_core];
 
 				if (rxcore_state == 1)
@@ -25533,7 +25753,7 @@ static int wlc_phy_cal_rxiq_nphy_rev3(struct brcms_phy *pi,
 
 		for (rx_core = 0; rx_core < pi->pubpi.phy_corenum; rx_core++) {
 			rxlpf_rccal_hpc =
-			    (((int)best_rccal[rx_core] - 12) >> 1) + 10;
+				(((int)best_rccal[rx_core] - 12) >> 1) + 10;
 			txlpf_rccal_lpc = ((int)best_rccal[rx_core] - 12) + 10;
 
 			if (PHY_IPA(pi)) {
@@ -25543,8 +25763,10 @@ static int wlc_phy_cal_rxiq_nphy_rev3(struct brcms_phy *pi,
 						 TXLPF_IDAC_4, txlpf_idac);
 			}
 
-			rxlpf_rccal_hpc = max(min_t(u8, rxlpf_rccal_hpc, 31), 0);
-			txlpf_rccal_lpc = max(min_t(u8, txlpf_rccal_lpc, 31), 0);
+			rxlpf_rccal_hpc = max(min_t(u8, rxlpf_rccal_hpc, 31),
+					      0);
+			txlpf_rccal_lpc = max(min_t(u8, txlpf_rccal_lpc, 31),
+					      0);
 
 			write_radio_reg(pi, (RADIO_2056_RX_RXLPF_RCCAL_HPC |
 					     ((rx_core ==
@@ -25565,9 +25787,10 @@ static int wlc_phy_cal_rxiq_nphy_rev3(struct brcms_phy *pi,
 	wlc_phy_resetcca_nphy(pi);
 
 	if (NREV_GE(pi->pubpi.phy_rev, 7))
-		wlc_phy_rfctrl_override_1tomany_nphy(pi,
-						     NPHY_REV7_RfctrlOverride_cmd_rxgain,
-						     0, 0x3, 1);
+		wlc_phy_rfctrl_override_1tomany_nphy(
+			pi,
+			NPHY_REV7_RfctrlOverride_cmd_rxgain,
+			0, 0x3, 1);
 	else
 		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 12), 0, 0x3, 1);
 
@@ -25651,13 +25874,13 @@ wlc_phy_cal_rxiq_nphy_rev2(struct brcms_phy *pi,
 		if (((pi->nphy_rxcalparams) & 0xff000000))
 			write_phy_reg(pi,
 				      (rx_core == PHY_CORE_0) ? 0x91 : 0x92,
-				      (CHSPEC_IS5G(pi->radio_chanspec) ? 0x140 :
-				       0x110));
+				      (CHSPEC_IS5G(pi->radio_chanspec) ?
+					0x140 : 0x110));
 		else
 			write_phy_reg(pi,
 				      (rx_core == PHY_CORE_0) ? 0x91 : 0x92,
-				      (CHSPEC_IS5G(pi->radio_chanspec) ? 0x180 :
-				       0x120));
+				      (CHSPEC_IS5G(pi->radio_chanspec) ?
+				       0x180 : 0x120));
 
 		write_phy_reg(pi, (tx_core == PHY_CORE_0) ? 0x91 : 0x92,
 			      (CHSPEC_IS5G(pi->radio_chanspec) ? 0x148 :
@@ -25697,7 +25920,7 @@ wlc_phy_cal_rxiq_nphy_rev2(struct brcms_phy *pi,
 					use_hpf_num = 1;
 					curr_hpf = curr_hpf1;
 					actual_log2_pwr =
-					    wlc_phy_nbits(tot_pwr[2]);
+						wlc_phy_nbits(tot_pwr[2]);
 				} else {
 					if (tot_pwr[0] > 10000) {
 						curr_lna = lna_vals[1];
@@ -25706,7 +25929,8 @@ wlc_phy_cal_rxiq_nphy_rev2(struct brcms_phy *pi,
 						use_hpf_num = 1;
 						curr_hpf = curr_hpf1;
 						actual_log2_pwr =
-						    wlc_phy_nbits(tot_pwr[1]);
+							wlc_phy_nbits(
+								tot_pwr[1]);
 					} else {
 						curr_lna = lna_vals[0];
 						curr_hpf1 = hpf1_vals[0];
@@ -25714,7 +25938,8 @@ wlc_phy_cal_rxiq_nphy_rev2(struct brcms_phy *pi,
 						use_hpf_num = 2;
 						curr_hpf = curr_hpf2;
 						actual_log2_pwr =
-						    wlc_phy_nbits(tot_pwr[0]);
+							wlc_phy_nbits(
+								tot_pwr[0]);
 					}
 				}
 
@@ -25737,15 +25962,12 @@ wlc_phy_cal_rxiq_nphy_rev2(struct brcms_phy *pi,
 
 			if (first_playtone) {
 				bcmerror = wlc_phy_tx_tone_nphy(pi, 4000,
-								(u16) (pi->
-									  nphy_rxcalparams
-									  &
-									  0xffff),
-								0, 0, true);
+						(u16) (pi->nphy_rxcalparams &
+						       0xffff), 0, 0, true);
 				first_playtone = false;
 			} else {
-				phy_bw =
-				    (CHSPEC_IS40(pi->radio_chanspec)) ? 40 : 20;
+				phy_bw = (CHSPEC_IS40(pi->radio_chanspec)) ?
+					  40 : 20;
 				wlc_phy_runsamples_nphy(pi, phy_bw * 8, 0xffff,
 							0, 0, 0, true);
 			}
@@ -25756,12 +25978,10 @@ wlc_phy_cal_rxiq_nphy_rev2(struct brcms_phy *pi,
 					wlc_phy_rx_iq_est_nphy(pi, est,
 							       num_samps, 32,
 							       0);
-					i_pwr =
-					    (est[rx_core].i_pwr +
-					     num_samps / 2) / num_samps;
-					q_pwr =
-					    (est[rx_core].q_pwr +
-					     num_samps / 2) / num_samps;
+					i_pwr =	(est[rx_core].i_pwr +
+						 num_samps / 2) / num_samps;
+					q_pwr =	(est[rx_core].q_pwr +
+						 num_samps / 2) / num_samps;
 					tot_pwr[gain_pass] = i_pwr + q_pwr;
 				} else {
 
@@ -25847,15 +26067,13 @@ static void wlc_phy_ipa_set_tx_digi_filts_nphy(struct brcms_phy *pi)
 		if (CHSPEC_IS5G(pi->radio_chanspec)) {
 			for (j = 0; j < NPHY_NUM_DIG_FILT_COEFFS; j++)
 				write_phy_reg(pi, 0x186 + j,
-					      NPHY_IPA_REV4_txdigi_filtcoeffs[5]
-					      [j]);
+					NPHY_IPA_REV4_txdigi_filtcoeffs[5][j]);
 		}
 
 		if (CHSPEC_CHANNEL(pi->radio_chanspec) == 14) {
 			for (j = 0; j < NPHY_NUM_DIG_FILT_COEFFS; j++)
 				write_phy_reg(pi, 0x2c5 + j,
-					      NPHY_IPA_REV4_txdigi_filtcoeffs[6]
-					      [j]);
+					NPHY_IPA_REV4_txdigi_filtcoeffs[6][j]);
 		}
 	}
 }
@@ -25901,17 +26119,17 @@ static u32 *wlc_phy_get_ipa_gaintbl_nphy(struct brcms_phy *pi)
 			if ((pi->pubpi.radiorev == 4)
 			    || (pi->pubpi.radiorev == 6))
 				tx_pwrctrl_tbl =
-				    nphy_tpc_txgain_ipa_2g_2057rev4n6;
+					nphy_tpc_txgain_ipa_2g_2057rev4n6;
 			else if (pi->pubpi.radiorev == 3)
 				tx_pwrctrl_tbl =
-				    nphy_tpc_txgain_ipa_2g_2057rev3;
+					nphy_tpc_txgain_ipa_2g_2057rev3;
 			else if (pi->pubpi.radiorev == 5)
 				tx_pwrctrl_tbl =
-				    nphy_tpc_txgain_ipa_2g_2057rev5;
+					nphy_tpc_txgain_ipa_2g_2057rev5;
 			else if ((pi->pubpi.radiorev == 7)
-				   || (pi->pubpi.radiorev == 8))
+				 || (pi->pubpi.radiorev == 8))
 				tx_pwrctrl_tbl =
-				    nphy_tpc_txgain_ipa_2g_2057rev7;
+					nphy_tpc_txgain_ipa_2g_2057rev7;
 		} else if (NREV_IS(pi->pubpi.phy_rev, 6)) {
 			tx_pwrctrl_tbl = nphy_tpc_txgain_ipa_rev6;
 		} else if (NREV_IS(pi->pubpi.phy_rev, 5)) {
@@ -25927,9 +26145,9 @@ static u32 *wlc_phy_get_ipa_gaintbl_nphy(struct brcms_phy *pi)
 			    (pi->pubpi.radiorev == 6))
 				tx_pwrctrl_tbl = nphy_tpc_txgain_ipa_5g_2057;
 			else if ((pi->pubpi.radiorev == 7)
-				   || (pi->pubpi.radiorev == 8))
+				 || (pi->pubpi.radiorev == 8))
 				tx_pwrctrl_tbl =
-				    nphy_tpc_txgain_ipa_5g_2057rev7;
+					nphy_tpc_txgain_ipa_5g_2057rev7;
 		} else {
 			tx_pwrctrl_tbl = nphy_tpc_txgain_ipa_5g;
 		}
@@ -25951,27 +26169,29 @@ wlc_phy_papd_cal_setup_nphy(struct brcms_phy *pi,
 
 		if (NREV_IS(pi->pubpi.phy_rev, 7)
 		    || NREV_GE(pi->pubpi.phy_rev, 8))
-			wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 7),
-							  wlc_phy_read_lpf_bw_ctl_nphy
-							  (pi, 0), 0, 0,
-							  NPHY_REV7_RFCTRLOVERRIDE_ID1);
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 7),
+				wlc_phy_read_lpf_bw_ctl_nphy
+					(pi,
+					0), 0, 0,
+				NPHY_REV7_RFCTRLOVERRIDE_ID1);
 
 		if (CHSPEC_IS2G(pi->radio_chanspec)) {
 			if (pi->pubpi.radiorev == 5)
 				mixgain = (core == 0) ? 0x20 : 0x00;
 			else if ((pi->pubpi.radiorev == 7)
-				   || (pi->pubpi.radiorev == 8))
+				 || (pi->pubpi.radiorev == 8))
 				mixgain = 0x00;
 			else if ((pi->pubpi.radiorev <= 4)
-				   || (pi->pubpi.radiorev == 6))
+				 || (pi->pubpi.radiorev == 6))
 				mixgain = 0x00;
 		} else {
 			if ((pi->pubpi.radiorev == 4) ||
 			    (pi->pubpi.radiorev == 6))
 				mixgain = 0x50;
 			else if ((pi->pubpi.radiorev == 3)
-				  || (pi->pubpi.radiorev == 7)
-				  || (pi->pubpi.radiorev == 8))
+				 || (pi->pubpi.radiorev == 7)
+				 || (pi->pubpi.radiorev == 8))
 				mixgain = 0x0;
 		}
 
@@ -25979,12 +26199,14 @@ wlc_phy_papd_cal_setup_nphy(struct brcms_phy *pi,
 						  mixgain, (1 << core), 0,
 						  NPHY_REV7_RFCTRLOVERRIDE_ID0);
 
-		wlc_phy_rfctrl_override_1tomany_nphy(pi,
-						     NPHY_REV7_RfctrlOverride_cmd_tx_pu,
-						     1, (1 << core), 0);
-		wlc_phy_rfctrl_override_1tomany_nphy(pi,
-						     NPHY_REV7_RfctrlOverride_cmd_tx_pu,
-						     0, (1 << off_core), 0);
+		wlc_phy_rfctrl_override_1tomany_nphy(
+			pi,
+			NPHY_REV7_RfctrlOverride_cmd_tx_pu,
+			1, (1 << core), 0);
+		wlc_phy_rfctrl_override_1tomany_nphy(
+			pi,
+			NPHY_REV7_RfctrlOverride_cmd_tx_pu,
+			0, (1 << off_core), 0);
 
 		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 3),
 						  0, 0x3, 0,
@@ -26021,11 +26243,11 @@ wlc_phy_papd_cal_setup_nphy(struct brcms_phy *pi,
 		state->afectrl[core] = read_phy_reg(pi, (core == PHY_CORE_0) ?
 						    0xa6 : 0xa7);
 		state->afeoverride[core] =
-		    read_phy_reg(pi, (core == PHY_CORE_0) ? 0x8f : 0xa5);
+			read_phy_reg(pi, (core == PHY_CORE_0) ? 0x8f : 0xa5);
 		state->afectrl[off_core] =
-		    read_phy_reg(pi, (core == PHY_CORE_0) ? 0xa7 : 0xa6);
+			read_phy_reg(pi, (core == PHY_CORE_0) ? 0xa7 : 0xa6);
 		state->afeoverride[off_core] =
-		    read_phy_reg(pi, (core == PHY_CORE_0) ? 0xa5 : 0x8f);
+			read_phy_reg(pi, (core == PHY_CORE_0) ? 0xa5 : 0x8f);
 
 		mod_phy_reg(pi, ((core == PHY_CORE_0) ? 0xa6 : 0xa7),
 			    (0x1 << 2), 0);
@@ -26039,17 +26261,17 @@ wlc_phy_papd_cal_setup_nphy(struct brcms_phy *pi,
 
 		if (CHSPEC_IS2G(pi->radio_chanspec)) {
 			state->pwrup[core] =
-			    READ_RADIO_REG3(pi, RADIO_2057, TX, core,
-					    TXRXCOUPLE_2G_PWRUP);
+				READ_RADIO_REG3(pi, RADIO_2057, TX, core,
+						TXRXCOUPLE_2G_PWRUP);
 			state->atten[core] =
-			    READ_RADIO_REG3(pi, RADIO_2057, TX, core,
-					    TXRXCOUPLE_2G_ATTEN);
+				READ_RADIO_REG3(pi, RADIO_2057, TX, core,
+						TXRXCOUPLE_2G_ATTEN);
 			state->pwrup[off_core] =
-			    READ_RADIO_REG3(pi, RADIO_2057, TX, off_core,
-					    TXRXCOUPLE_2G_PWRUP);
+				READ_RADIO_REG3(pi, RADIO_2057, TX, off_core,
+						TXRXCOUPLE_2G_PWRUP);
 			state->atten[off_core] =
-			    READ_RADIO_REG3(pi, RADIO_2057, TX, off_core,
-					    TXRXCOUPLE_2G_ATTEN);
+				READ_RADIO_REG3(pi, RADIO_2057, TX, off_core,
+						TXRXCOUPLE_2G_ATTEN);
 
 			WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
 					 TXRXCOUPLE_2G_PWRUP, 0xc);
@@ -26064,7 +26286,7 @@ wlc_phy_papd_cal_setup_nphy(struct brcms_phy *pi,
 						 TXRXCOUPLE_2G_ATTEN,
 						 (core == 0) ? 0xf7 : 0xf2);
 			else if ((pi->pubpi.radiorev == 7)
-				   || (pi->pubpi.radiorev == 8))
+				 || (pi->pubpi.radiorev == 8))
 				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
 						 TXRXCOUPLE_2G_ATTEN, 0xf0);
 
@@ -26074,17 +26296,17 @@ wlc_phy_papd_cal_setup_nphy(struct brcms_phy *pi,
 					 TXRXCOUPLE_2G_ATTEN, 0xff);
 		} else {
 			state->pwrup[core] =
-			    READ_RADIO_REG3(pi, RADIO_2057, TX, core,
-					    TXRXCOUPLE_5G_PWRUP);
+				READ_RADIO_REG3(pi, RADIO_2057, TX, core,
+						TXRXCOUPLE_5G_PWRUP);
 			state->atten[core] =
-			    READ_RADIO_REG3(pi, RADIO_2057, TX, core,
-					    TXRXCOUPLE_5G_ATTEN);
+				READ_RADIO_REG3(pi, RADIO_2057, TX, core,
+						TXRXCOUPLE_5G_ATTEN);
 			state->pwrup[off_core] =
-			    READ_RADIO_REG3(pi, RADIO_2057, TX, off_core,
-					    TXRXCOUPLE_5G_PWRUP);
+				READ_RADIO_REG3(pi, RADIO_2057, TX, off_core,
+						TXRXCOUPLE_5G_PWRUP);
 			state->atten[off_core] =
-			    READ_RADIO_REG3(pi, RADIO_2057, TX, off_core,
-					    TXRXCOUPLE_5G_ATTEN);
+				READ_RADIO_REG3(pi, RADIO_2057, TX, off_core,
+						TXRXCOUPLE_5G_ATTEN);
 
 			WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
 					 TXRXCOUPLE_5G_PWRUP, 0xc);
@@ -26134,7 +26356,7 @@ wlc_phy_papd_cal_setup_nphy(struct brcms_phy *pi,
 		state->afectrl[core] = read_phy_reg(pi, (core == PHY_CORE_0) ?
 						    0xa6 : 0xa7);
 		state->afeoverride[core] =
-		    read_phy_reg(pi, (core == PHY_CORE_0) ? 0x8f : 0xa5);
+			read_phy_reg(pi, (core == PHY_CORE_0) ? 0x8f : 0xa5);
 
 		mod_phy_reg(pi, ((core == PHY_CORE_0) ? 0xa6 : 0xa7),
 			    (0x1 << 0) | (0x1 << 1) | (0x1 << 2), 0);
@@ -26145,15 +26367,15 @@ wlc_phy_papd_cal_setup_nphy(struct brcms_phy *pi,
 			    (0x1 << 2), (0x1 << 0) | (0x1 << 1) | (0x1 << 2));
 
 		state->vga_master[core] =
-		    READ_RADIO_REG2(pi, RADIO_2056, RX, core, VGA_MASTER);
+			READ_RADIO_REG2(pi, RADIO_2056, RX, core, VGA_MASTER);
 		WRITE_RADIO_REG2(pi, RADIO_2056, RX, core, VGA_MASTER, 0x2b);
 		if (CHSPEC_IS2G(pi->radio_chanspec)) {
 			state->fbmix[core] =
-			    READ_RADIO_REG2(pi, RADIO_2056, RX, core,
-					    TXFBMIX_G);
+				READ_RADIO_REG2(pi, RADIO_2056, RX, core,
+						TXFBMIX_G);
 			state->intpa_master[core] =
-			    READ_RADIO_REG2(pi, RADIO_2056, TX, core,
-					    INTPAG_MASTER);
+				READ_RADIO_REG2(pi, RADIO_2056, TX, core,
+						INTPAG_MASTER);
 
 			WRITE_RADIO_REG2(pi, RADIO_2056, RX, core, TXFBMIX_G,
 					 0x03);
@@ -26161,11 +26383,11 @@ wlc_phy_papd_cal_setup_nphy(struct brcms_phy *pi,
 					 INTPAG_MASTER, 0x04);
 		} else {
 			state->fbmix[core] =
-			    READ_RADIO_REG2(pi, RADIO_2056, RX, core,
-					    TXFBMIX_A);
+				READ_RADIO_REG2(pi, RADIO_2056, RX, core,
+						TXFBMIX_A);
 			state->intpa_master[core] =
-			    READ_RADIO_REG2(pi, RADIO_2056, TX, core,
-					    INTPAA_MASTER);
+				READ_RADIO_REG2(pi, RADIO_2056, TX, core,
+						INTPAA_MASTER);
 
 			WRITE_RADIO_REG2(pi, RADIO_2056, RX, core, TXFBMIX_A,
 					 0x03);
@@ -26216,13 +26438,15 @@ wlc_phy_papd_cal_cleanup_nphy(struct brcms_phy *pi,
 		}
 
 		if ((pi->pubpi.radiorev == 4) || (pi->pubpi.radiorev == 6))
-			wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 2),
-							  1, 0x3, 0,
-							  NPHY_REV7_RFCTRLOVERRIDE_ID0);
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 2),
+				1, 0x3, 0,
+				NPHY_REV7_RFCTRLOVERRIDE_ID0);
 		else
-			wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 2),
-							  0, 0x3, 1,
-							  NPHY_REV7_RFCTRLOVERRIDE_ID0);
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 2),
+				0, 0x3, 1,
+				NPHY_REV7_RFCTRLOVERRIDE_ID0);
 
 		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 1),
 						  0, 0x3, 1,
@@ -26271,9 +26495,10 @@ wlc_phy_papd_cal_cleanup_nphy(struct brcms_phy *pi,
 
 		if (NREV_IS(pi->pubpi.phy_rev, 7)
 		    || NREV_GE(pi->pubpi.phy_rev, 8))
-			wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 7), 0, 0,
-							  1,
-							  NPHY_REV7_RFCTRLOVERRIDE_ID1);
+			wlc_phy_rfctrl_override_nphy_rev7(
+				pi, (0x1 << 7), 0, 0,
+				1,
+				NPHY_REV7_RFCTRLOVERRIDE_ID1);
 	} else {
 		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 12), 0, 0x3, 1);
 		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 13), 0, 0x3, 1);
@@ -26339,7 +26564,8 @@ wlc_phy_a1_nphy(struct brcms_phy *pi, u8 core, u32 winsz, u32 start,
 		s32 phy_a3, phy_a4, phy_a5, phy_a6, phy_a7;
 
 		phy_a1 = end - min(end, (winsz >> 1));
-		phy_a2 = min_t(u32, NPHY_PAPD_EPS_TBL_SIZE - 1, end + (winsz >> 1));
+		phy_a2 = min_t(u32, NPHY_PAPD_EPS_TBL_SIZE - 1,
+			       end + (winsz >> 1));
 		phy_a3 = phy_a2 - phy_a1 + 1;
 		phy_a6 = 0;
 		phy_a7 = 0;
@@ -26399,9 +26625,10 @@ wlc_phy_a2_nphy(struct brcms_phy *pi, struct nphy_ipa_txcalgains *txgains,
 				  (txgains->gains.pga[core] << 8) |
 				  (phy_a9.pad[core] << 3) | (phy_a9.ipa[core]));
 
-		wlc_phy_rfctrl_override_1tomany_nphy(pi,
-						     NPHY_REV7_RfctrlOverride_cmd_txgain,
-						     phy_a5, (1 << core), 0);
+		wlc_phy_rfctrl_override_1tomany_nphy(
+			pi,
+			NPHY_REV7_RfctrlOverride_cmd_txgain,
+			phy_a5, (1 << core), 0);
 
 		if (CHSPEC_IS2G(pi->radio_chanspec)) {
 			if ((pi->pubpi.radiorev <= 4)
@@ -26444,8 +26671,8 @@ wlc_phy_a2_nphy(struct brcms_phy *pi, struct nphy_ipa_txcalgains *txgains,
 			    && (CHSPEC_IS2G(pi->radio_chanspec)))
 				phy_a1 = 55;
 			else if (((pi->pubpi.radiorev == 7) &&
-				    (CHSPEC_IS2G(pi->radio_chanspec))) ||
-				   ((pi->pubpi.radiorev == 8) &&
+				  (CHSPEC_IS2G(pi->radio_chanspec))) ||
+				 ((pi->pubpi.radiorev == 8) &&
 				  (CHSPEC_IS2G(pi->radio_chanspec))))
 				phy_a1 = 60;
 			else
@@ -26514,9 +26741,10 @@ wlc_phy_a2_nphy(struct brcms_phy *pi, struct nphy_ipa_txcalgains *txgains,
 				wlc_phy_a1_nphy(pi, core, 5, 0, 35);
 		}
 
-		wlc_phy_rfctrl_override_1tomany_nphy(pi,
-						     NPHY_REV7_RfctrlOverride_cmd_txgain,
-						     phy_a5, (1 << core), 1);
+		wlc_phy_rfctrl_override_1tomany_nphy(
+			pi,
+			NPHY_REV7_RfctrlOverride_cmd_txgain,
+			phy_a5, (1 << core), 1);
 
 	} else {
 
@@ -26528,7 +26756,7 @@ wlc_phy_a2_nphy(struct brcms_phy *pi, struct nphy_ipa_txcalgains *txgains,
 						phy_a5 = 0x00f7 | (phy_a4 << 8);
 
 					else
-					    if (NREV_IS(pi->pubpi.phy_rev, 5))
+					if (NREV_IS(pi->pubpi.phy_rev, 5))
 						phy_a5 = 0x10f7 | (phy_a4 << 8);
 					else
 						phy_a5 = 0x50f7 | (phy_a4 << 8);
@@ -26674,28 +26902,33 @@ static u8 wlc_phy_a3_nphy(struct brcms_phy *pi, u8 start_gain, u8 core)
 			if (pi->pubpi.radiorev == 5) {
 
 				phy_a15 = pad_gain_codes_used_2057rev5;
-				phy_a13 = sizeof(pad_gain_codes_used_2057rev5) /
-				    sizeof(pad_gain_codes_used_2057rev5[0]) - 1;
+				phy_a13 =
+					sizeof(pad_gain_codes_used_2057rev5) /
+					sizeof(pad_gain_codes_used_2057rev5
+						[0]) - 1;
 
 			} else if ((pi->pubpi.radiorev == 7)
 				   || (pi->pubpi.radiorev == 8)) {
 
 				phy_a15 = pad_gain_codes_used_2057rev7;
-				phy_a13 = sizeof(pad_gain_codes_used_2057rev7) /
-				    sizeof(pad_gain_codes_used_2057rev7[0]) - 1;
+				phy_a13 =
+					sizeof(pad_gain_codes_used_2057rev7) /
+					sizeof(pad_gain_codes_used_2057rev7
+						[0]) - 1;
 
 			} else {
 
 				phy_a15 = pad_all_gain_codes_2057;
 				phy_a13 = sizeof(pad_all_gain_codes_2057) /
-				    sizeof(pad_all_gain_codes_2057[0]) - 1;
+					  sizeof(pad_all_gain_codes_2057[0]) -
+					  1;
 			}
 
 		} else {
 
 			phy_a15 = pga_all_gain_codes_2057;
 			phy_a13 = sizeof(pga_all_gain_codes_2057) /
-			    sizeof(pga_all_gain_codes_2057[0]) - 1;
+				  sizeof(pga_all_gain_codes_2057[0]) - 1;
 		}
 
 		phy_a14 = 0;
@@ -26703,10 +26936,10 @@ static u8 wlc_phy_a3_nphy(struct brcms_phy *pi, u8 start_gain, u8 core)
 		for (phy_a10 = 0; phy_a10 < phy_a2; phy_a10++) {
 			if (CHSPEC_IS2G(pi->radio_chanspec))
 				phy_a4.gains.pad[core] =
-				    (u16) phy_a15[phy_a12];
+					(u16) phy_a15[phy_a12];
 			else
 				phy_a4.gains.pga[core] =
-				    (u16) phy_a15[phy_a12];
+					(u16) phy_a15[phy_a12];
 
 			wlc_phy_a2_nphy(pi, &phy_a4, CAL_GCTRL, core);
 
@@ -26824,8 +27057,7 @@ static void wlc_phy_a4(struct brcms_phy *pi, bool full_cal)
 	if (pi->nphy_papd_skip == 1)
 		return;
 
-	phy_b3 =
-	    (0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
+	phy_b3 = (0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
 	if (!phy_b3)
 		wlapi_suspend_mac_and_wait(pi->sh->physhim);
 
@@ -26835,7 +27067,7 @@ static void wlc_phy_a4(struct brcms_phy *pi, bool full_cal)
 
 	for (phy_b5 = 0; phy_b5 < pi->pubpi.phy_corenum; phy_b5++)
 		pi->nphy_papd_tx_gain_at_last_cal[phy_b5] =
-		    wlc_phy_txpwr_idx_cur_get_nphy(pi, phy_b5);
+			wlc_phy_txpwr_idx_cur_get_nphy(pi, phy_b5);
 
 	pi->nphy_papd_last_cal = pi->sh->now;
 	pi->nphy_papd_recal_counter++;
@@ -26877,50 +27109,56 @@ static void wlc_phy_a4(struct brcms_phy *pi, bool full_cal)
 				    || (pi->pubpi.radiorev == 4)
 				    || (pi->pubpi.radiorev == 6)) {
 					pi->nphy_papd_cal_gain_index[phy_b5] =
-					    23;
+						23;
 				} else if (pi->pubpi.radiorev == 5) {
 					pi->nphy_papd_cal_gain_index[phy_b5] =
-					    0;
+						0;
 					pi->nphy_papd_cal_gain_index[phy_b5] =
-					    wlc_phy_a3_nphy(pi,
-							    pi->
-							    nphy_papd_cal_gain_index
-							    [phy_b5], phy_b5);
+						wlc_phy_a3_nphy(
+							pi,
+							pi->
+							nphy_papd_cal_gain_index
+							[phy_b5],
+							phy_b5);
 
 				} else if ((pi->pubpi.radiorev == 7)
 					   || (pi->pubpi.radiorev == 8)) {
 
 					pi->nphy_papd_cal_gain_index[phy_b5] =
-					    0;
+						0;
 					pi->nphy_papd_cal_gain_index[phy_b5] =
-					    wlc_phy_a3_nphy(pi,
-							    pi->
-							    nphy_papd_cal_gain_index
-							    [phy_b5], phy_b5);
+						wlc_phy_a3_nphy(
+							pi,
+							pi->
+							nphy_papd_cal_gain_index
+							[phy_b5],
+							phy_b5);
 
 				}
 
 				phy_b1[phy_b5].gains.pad[phy_b5] =
-				    pi->nphy_papd_cal_gain_index[phy_b5];
+					pi->nphy_papd_cal_gain_index[phy_b5];
 
 			} else {
 				pi->nphy_papd_cal_gain_index[phy_b5] = 0;
 				pi->nphy_papd_cal_gain_index[phy_b5] =
-				    wlc_phy_a3_nphy(pi,
-						    pi->
-						    nphy_papd_cal_gain_index
-						    [phy_b5], phy_b5);
+					wlc_phy_a3_nphy(
+						pi,
+						pi->
+						nphy_papd_cal_gain_index
+						[phy_b5], phy_b5);
 				phy_b1[phy_b5].gains.pga[phy_b5] =
-				    pi->nphy_papd_cal_gain_index[phy_b5];
+					pi->nphy_papd_cal_gain_index[phy_b5];
 			}
 		} else {
 			phy_b1[phy_b5].useindex = true;
 			phy_b1[phy_b5].index = 16;
 			phy_b1[phy_b5].index =
-			    wlc_phy_a3_nphy(pi, phy_b1[phy_b5].index, phy_b5);
+				wlc_phy_a3_nphy(pi, phy_b1[phy_b5].index,
+						phy_b5);
 
 			pi->nphy_papd_cal_gain_index[phy_b5] =
-			    15 - ((phy_b1[phy_b5].index) >> 3);
+				15 - ((phy_b1[phy_b5].index) >> 3);
 		}
 
 		switch (pi->nphy_papd_cal_type) {
@@ -26960,23 +27198,19 @@ static void wlc_phy_a4(struct brcms_phy *pi, bool full_cal)
 				if ((pi->pubpi.radiorev == 3) ||
 				    (pi->pubpi.radiorev == 4) ||
 				    (pi->pubpi.radiorev == 6)) {
-					phy_b12 =
-					    -
-					    (nphy_papd_padgain_dlt_2g_2057rev3n4
-					     [phy_b8]
-					     + 1) / 2;
+					phy_b12 = -(
+					    nphy_papd_padgain_dlt_2g_2057rev3n4
+							     [phy_b8] + 1) / 2;
 					phy_b10 = -1;
 				} else if (pi->pubpi.radiorev == 5) {
-					phy_b12 =
-					    -(nphy_papd_padgain_dlt_2g_2057rev5
-					      [phy_b8]
-					      + 1) / 2;
+					phy_b12 = -(
+					    nphy_papd_padgain_dlt_2g_2057rev5
+							     [phy_b8] + 1) / 2;
 				} else if ((pi->pubpi.radiorev == 7) ||
 					   (pi->pubpi.radiorev == 8)) {
-					phy_b12 =
-					    -(nphy_papd_padgain_dlt_2g_2057rev7
-					      [phy_b8]
-					      + 1) / 2;
+					phy_b12 = -(
+					    nphy_papd_padgain_dlt_2g_2057rev7
+							     [phy_b8] + 1) / 2;
 				}
 			} else {
 				phy_b7 = phy_b1[phy_b5].gains.pga[phy_b5];
@@ -26984,25 +27218,26 @@ static void wlc_phy_a4(struct brcms_phy *pi, bool full_cal)
 				    (pi->pubpi.radiorev == 4) ||
 				    (pi->pubpi.radiorev == 6))
 					phy_b11 =
-					    -(nphy_papd_pgagain_dlt_5g_2057
-					      [phy_b7]
-					      + 1) / 2;
+						-(nphy_papd_pgagain_dlt_5g_2057
+						  [phy_b7]
+						  + 1) / 2;
 				else if ((pi->pubpi.radiorev == 7)
-					   || (pi->pubpi.radiorev == 8))
-					phy_b11 =
-					    -(nphy_papd_pgagain_dlt_5g_2057rev7
-					      [phy_b7]
-					      + 1) / 2;
+					 || (pi->pubpi.radiorev == 8))
+					phy_b11 = -(
+					      nphy_papd_pgagain_dlt_5g_2057rev7
+							     [phy_b7] + 1) / 2;
 
 				phy_b10 = -9;
 			}
 
 			if (CHSPEC_IS2G(pi->radio_chanspec))
 				phy_b6 =
-				    -60 + 27 + eps_offset + phy_b12 + phy_b10;
+					-60 + 27 + eps_offset + phy_b12 +
+					phy_b10;
 			else
 				phy_b6 =
-				    -60 + 27 + eps_offset + phy_b11 + phy_b10;
+					-60 + 27 + eps_offset + phy_b11 +
+					phy_b10;
 
 			mod_phy_reg(pi, (phy_b5 == PHY_CORE_0) ? 0x298 :
 				    0x29c, (0x1ff << 7), (phy_b6) << 7);
@@ -27018,13 +27253,15 @@ static void wlc_phy_a4(struct brcms_phy *pi, bool full_cal)
 
 			if (CHSPEC_IS2G(pi->radio_chanspec)) {
 				phy_b11 =
-				    -(nphy_papd_pga_gain_delta_ipa_2g[phy_b7] +
-				      1) / 2;
+					-(nphy_papd_pga_gain_delta_ipa_2g[
+						  phy_b7] +
+					  1) / 2;
 				phy_b10 = 0;
 			} else {
 				phy_b11 =
-				    -(nphy_papd_pga_gain_delta_ipa_5g[phy_b7] +
-				      1) / 2;
+					-(nphy_papd_pga_gain_delta_ipa_5g[
+						  phy_b7] +
+					  1) / 2;
 				phy_b10 = -9;
 			}
 
@@ -27068,10 +27305,10 @@ static void wlc_phy_a4(struct brcms_phy *pi, bool full_cal)
 	if (phy_b4 == PHY_TPC_HW_OFF) {
 		wlc_phy_txpwr_index_nphy(pi, (1 << 0),
 					 (s8) (pi->nphy_txpwrindex[0].
-						 index_internal), false);
+					       index_internal), false);
 		wlc_phy_txpwr_index_nphy(pi, (1 << 1),
 					 (s8) (pi->nphy_txpwrindex[1].
-						 index_internal), false);
+					       index_internal), false);
 	}
 
 	wlc_phy_stay_in_carriersearch_nphy(pi, false);
@@ -27142,37 +27379,36 @@ void wlc_phy_txpwr_fixpower_nphy(struct brcms_phy *pi)
 		if (NREV_GE(phyrev, 3)) {
 			if (PHY_IPA(pi)) {
 				u32 *tx_gaintbl =
-				    wlc_phy_get_ipa_gaintbl_nphy(pi);
+					wlc_phy_get_ipa_gaintbl_nphy(pi);
 				txgain = tx_gaintbl[txpi[core]];
 			} else {
 				if (CHSPEC_IS5G(pi->radio_chanspec)) {
 					if (NREV_IS(phyrev, 3)) {
 						txgain =
-						    nphy_tpc_5GHz_txgain_rev3
-						    [txpi[core]];
+						      nphy_tpc_5GHz_txgain_rev3
+								   [txpi[core]];
 					} else if (NREV_IS(phyrev, 4)) {
-						txgain =
-						    (pi->srom_fem5g.extpagain ==
-						     3) ?
-						    nphy_tpc_5GHz_txgain_HiPwrEPA
-						    [txpi[core]] :
-						    nphy_tpc_5GHz_txgain_rev4
-						    [txpi[core]];
+						txgain = (
+						  pi->srom_fem5g.extpagain ==
+						  3) ?
+						  nphy_tpc_5GHz_txgain_HiPwrEPA
+						 [txpi[core]] :
+						 nphy_tpc_5GHz_txgain_rev4
+						 [txpi[core]];
 					} else {
 						txgain =
-						    nphy_tpc_5GHz_txgain_rev5
-						    [txpi[core]];
+						      nphy_tpc_5GHz_txgain_rev5
+								   [txpi[core]];
 					}
 				} else {
 					if (NREV_GE(phyrev, 5) &&
 					    (pi->srom_fem2g.extpagain == 3)) {
 						txgain =
-						    nphy_tpc_txgain_HiPwrEPA
-						    [txpi[core]];
+							nphy_tpc_txgain_HiPwrEPA
+							[txpi[core]];
 					} else {
-						txgain =
-						    nphy_tpc_txgain_rev3[txpi
-									 [core]];
+						txgain = nphy_tpc_txgain_rev3
+							 [txpi[core]];
 					}
 				}
 			}
@@ -27297,7 +27533,8 @@ void wlc_phy_txpwr_apply_nphy(struct brcms_phy *pi)
 	u16 pwr_offsets1[2], *pwr_offsets2 = NULL;
 	u8 *tx_srom_max_rate = NULL;
 
-	for (band_num = 0; band_num < (CH_2G_GROUP + CH_5G_GROUP); band_num++) {
+	for (band_num = 0; band_num < (CH_2G_GROUP + CH_5G_GROUP);
+	     band_num++) {
 		switch (band_num) {
 		case 0:
 
@@ -27313,7 +27550,7 @@ void wlc_phy_txpwr_apply_nphy(struct brcms_phy *pi)
 
 			pwr_offsets1[0] = (u16) (pi->ofdm2gpo & 0xffff);
 			pwr_offsets1[1] =
-			    (u16) (pi->ofdm2gpo >> 16) & 0xffff;
+				(u16) (pi->ofdm2gpo >> 16) & 0xffff;
 
 			pwr_offsets2 = pi->mcs2gpo;
 
@@ -27330,7 +27567,7 @@ void wlc_phy_txpwr_apply_nphy(struct brcms_phy *pi)
 
 			pwr_offsets1[0] = (u16) (pi->ofdm5gpo & 0xffff);
 			pwr_offsets1[1] =
-			    (u16) (pi->ofdm5gpo >> 16) & 0xffff;
+				(u16) (pi->ofdm5gpo >> 16) & 0xffff;
 
 			pwr_offsets2 = pi->mcs5gpo;
 
@@ -27347,7 +27584,7 @@ void wlc_phy_txpwr_apply_nphy(struct brcms_phy *pi)
 
 			pwr_offsets1[0] = (u16) (pi->ofdm5glpo & 0xffff);
 			pwr_offsets1[1] =
-			    (u16) (pi->ofdm5glpo >> 16) & 0xffff;
+				(u16) (pi->ofdm5glpo >> 16) & 0xffff;
 
 			pwr_offsets2 = pi->mcs5glpo;
 
@@ -27364,7 +27601,7 @@ void wlc_phy_txpwr_apply_nphy(struct brcms_phy *pi)
 
 			pwr_offsets1[0] = (u16) (pi->ofdm5ghpo & 0xffff);
 			pwr_offsets1[1] =
-			    (u16) (pi->ofdm5ghpo >> 16) & 0xffff;
+				(u16) (pi->ofdm5ghpo >> 16) & 0xffff;
 
 			pwr_offsets2 = pi->mcs5ghpo;
 
@@ -27463,10 +27700,11 @@ void wlc_phy_txpwr_apply_nphy(struct brcms_phy *pi)
 		} else {
 
 			for (rate1 = TXP_FIRST_OFDM_40_SISO, rate2 =
-			     TXP_FIRST_OFDM; rate1 <= TXP_LAST_MCS_40_SDM;
+				     TXP_FIRST_OFDM;
+			     rate1 <= TXP_LAST_MCS_40_SDM;
 			     rate1++, rate2++)
 				tx_srom_max_rate[rate1] =
-				    tx_srom_max_rate[rate2];
+					tx_srom_max_rate[rate2];
 		}
 
 		if (NREV_GE(pi->pubpi.phy_rev, 3))
@@ -27476,7 +27714,7 @@ void wlc_phy_txpwr_apply_nphy(struct brcms_phy *pi)
 						    TXP_LAST_MCS_40_SDM);
 
 		tx_srom_max_rate[TXP_MCS_32] =
-		    tx_srom_max_rate[TXP_FIRST_MCS_40_CDD];
+			tx_srom_max_rate[TXP_FIRST_MCS_40_CDD];
 	}
 
 	return;
@@ -27514,34 +27752,35 @@ static void wlc_phy_txpwr_srom_read_ppr_nphy(struct brcms_phy *pi)
 	pi->bwdup5glpo = (bwduppo & 0xf00) >> 8;
 	pi->bwdup5ghpo = (bwduppo & 0xf000) >> 12;
 
-	for (band_num = 0; band_num < (CH_2G_GROUP + CH_5G_GROUP); band_num++) {
+	for (band_num = 0; band_num < (CH_2G_GROUP + CH_5G_GROUP);
+	     band_num++) {
 		switch (band_num) {
 		case 0:
 
 			pi->nphy_txpid2g[PHY_CORE_0] =
-			    (u8) PHY_GETINTVAR(pi, "txpid2ga0");
+				(u8) PHY_GETINTVAR(pi, "txpid2ga0");
 			pi->nphy_txpid2g[PHY_CORE_1] =
-			    (u8) PHY_GETINTVAR(pi, "txpid2ga1");
+				(u8) PHY_GETINTVAR(pi, "txpid2ga1");
 			pi->nphy_pwrctrl_info[PHY_CORE_0].max_pwr_2g =
-			    (s8) PHY_GETINTVAR(pi, "maxp2ga0");
+				(s8) PHY_GETINTVAR(pi, "maxp2ga0");
 			pi->nphy_pwrctrl_info[PHY_CORE_1].max_pwr_2g =
-			    (s8) PHY_GETINTVAR(pi, "maxp2ga1");
+				(s8) PHY_GETINTVAR(pi, "maxp2ga1");
 			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_2g_a1 =
-			    (s16) PHY_GETINTVAR(pi, "pa2gw0a0");
+				(s16) PHY_GETINTVAR(pi, "pa2gw0a0");
 			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_2g_a1 =
-			    (s16) PHY_GETINTVAR(pi, "pa2gw0a1");
+				(s16) PHY_GETINTVAR(pi, "pa2gw0a1");
 			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_2g_b0 =
-			    (s16) PHY_GETINTVAR(pi, "pa2gw1a0");
+				(s16) PHY_GETINTVAR(pi, "pa2gw1a0");
 			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_2g_b0 =
-			    (s16) PHY_GETINTVAR(pi, "pa2gw1a1");
+				(s16) PHY_GETINTVAR(pi, "pa2gw1a1");
 			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_2g_b1 =
-			    (s16) PHY_GETINTVAR(pi, "pa2gw2a0");
+				(s16) PHY_GETINTVAR(pi, "pa2gw2a0");
 			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_2g_b1 =
-			    (s16) PHY_GETINTVAR(pi, "pa2gw2a1");
+				(s16) PHY_GETINTVAR(pi, "pa2gw2a1");
 			pi->nphy_pwrctrl_info[PHY_CORE_0].idle_targ_2g =
-			    (s8) PHY_GETINTVAR(pi, "itt2ga0");
+				(s8) PHY_GETINTVAR(pi, "itt2ga0");
 			pi->nphy_pwrctrl_info[PHY_CORE_1].idle_targ_2g =
-			    (s8) PHY_GETINTVAR(pi, "itt2ga1");
+				(s8) PHY_GETINTVAR(pi, "itt2ga1");
 
 			pi->cck2gpo = (u16) PHY_GETINTVAR(pi, "cck2gpo");
 
@@ -27559,29 +27798,29 @@ static void wlc_phy_txpwr_srom_read_ppr_nphy(struct brcms_phy *pi)
 		case 1:
 
 			pi->nphy_txpid5g[PHY_CORE_0] =
-			    (u8) PHY_GETINTVAR(pi, "txpid5ga0");
+				(u8) PHY_GETINTVAR(pi, "txpid5ga0");
 			pi->nphy_txpid5g[PHY_CORE_1] =
-			    (u8) PHY_GETINTVAR(pi, "txpid5ga1");
+				(u8) PHY_GETINTVAR(pi, "txpid5ga1");
 			pi->nphy_pwrctrl_info[PHY_CORE_0].max_pwr_5gm =
-			    (s8) PHY_GETINTVAR(pi, "maxp5ga0");
+				(s8) PHY_GETINTVAR(pi, "maxp5ga0");
 			pi->nphy_pwrctrl_info[PHY_CORE_1].max_pwr_5gm =
-			    (s8) PHY_GETINTVAR(pi, "maxp5ga1");
+				(s8) PHY_GETINTVAR(pi, "maxp5ga1");
 			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_5gm_a1 =
-			    (s16) PHY_GETINTVAR(pi, "pa5gw0a0");
+				(s16) PHY_GETINTVAR(pi, "pa5gw0a0");
 			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_5gm_a1 =
-			    (s16) PHY_GETINTVAR(pi, "pa5gw0a1");
+				(s16) PHY_GETINTVAR(pi, "pa5gw0a1");
 			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_5gm_b0 =
-			    (s16) PHY_GETINTVAR(pi, "pa5gw1a0");
+				(s16) PHY_GETINTVAR(pi, "pa5gw1a0");
 			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_5gm_b0 =
-			    (s16) PHY_GETINTVAR(pi, "pa5gw1a1");
+				(s16) PHY_GETINTVAR(pi, "pa5gw1a1");
 			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_5gm_b1 =
-			    (s16) PHY_GETINTVAR(pi, "pa5gw2a0");
+				(s16) PHY_GETINTVAR(pi, "pa5gw2a0");
 			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_5gm_b1 =
-			    (s16) PHY_GETINTVAR(pi, "pa5gw2a1");
+				(s16) PHY_GETINTVAR(pi, "pa5gw2a1");
 			pi->nphy_pwrctrl_info[PHY_CORE_0].idle_targ_5gm =
-			    (s8) PHY_GETINTVAR(pi, "itt5ga0");
+				(s8) PHY_GETINTVAR(pi, "itt5ga0");
 			pi->nphy_pwrctrl_info[PHY_CORE_1].idle_targ_5gm =
-			    (s8) PHY_GETINTVAR(pi, "itt5ga1");
+				(s8) PHY_GETINTVAR(pi, "itt5ga1");
 
 			pi->ofdm5gpo = (u32) PHY_GETINTVAR(pi, "ofdm5gpo");
 
@@ -27597,90 +27836,90 @@ static void wlc_phy_txpwr_srom_read_ppr_nphy(struct brcms_phy *pi)
 		case 2:
 
 			pi->nphy_txpid5gl[0] =
-			    (u8) PHY_GETINTVAR(pi, "txpid5gla0");
+				(u8) PHY_GETINTVAR(pi, "txpid5gla0");
 			pi->nphy_txpid5gl[1] =
-			    (u8) PHY_GETINTVAR(pi, "txpid5gla1");
+				(u8) PHY_GETINTVAR(pi, "txpid5gla1");
 			pi->nphy_pwrctrl_info[0].max_pwr_5gl =
-			    (s8) PHY_GETINTVAR(pi, "maxp5gla0");
+				(s8) PHY_GETINTVAR(pi, "maxp5gla0");
 			pi->nphy_pwrctrl_info[1].max_pwr_5gl =
-			    (s8) PHY_GETINTVAR(pi, "maxp5gla1");
+				(s8) PHY_GETINTVAR(pi, "maxp5gla1");
 			pi->nphy_pwrctrl_info[0].pwrdet_5gl_a1 =
-			    (s16) PHY_GETINTVAR(pi, "pa5glw0a0");
+				(s16) PHY_GETINTVAR(pi, "pa5glw0a0");
 			pi->nphy_pwrctrl_info[1].pwrdet_5gl_a1 =
-			    (s16) PHY_GETINTVAR(pi, "pa5glw0a1");
+				(s16) PHY_GETINTVAR(pi, "pa5glw0a1");
 			pi->nphy_pwrctrl_info[0].pwrdet_5gl_b0 =
-			    (s16) PHY_GETINTVAR(pi, "pa5glw1a0");
+				(s16) PHY_GETINTVAR(pi, "pa5glw1a0");
 			pi->nphy_pwrctrl_info[1].pwrdet_5gl_b0 =
-			    (s16) PHY_GETINTVAR(pi, "pa5glw1a1");
+				(s16) PHY_GETINTVAR(pi, "pa5glw1a1");
 			pi->nphy_pwrctrl_info[0].pwrdet_5gl_b1 =
-			    (s16) PHY_GETINTVAR(pi, "pa5glw2a0");
+				(s16) PHY_GETINTVAR(pi, "pa5glw2a0");
 			pi->nphy_pwrctrl_info[1].pwrdet_5gl_b1 =
-			    (s16) PHY_GETINTVAR(pi, "pa5glw2a1");
+				(s16) PHY_GETINTVAR(pi, "pa5glw2a1");
 			pi->nphy_pwrctrl_info[0].idle_targ_5gl = 0;
 			pi->nphy_pwrctrl_info[1].idle_targ_5gl = 0;
 
 			pi->ofdm5glpo = (u32) PHY_GETINTVAR(pi, "ofdm5glpo");
 
 			pi->mcs5glpo[0] =
-			    (u16) PHY_GETINTVAR(pi, "mcs5glpo0");
+				(u16) PHY_GETINTVAR(pi, "mcs5glpo0");
 			pi->mcs5glpo[1] =
-			    (u16) PHY_GETINTVAR(pi, "mcs5glpo1");
+				(u16) PHY_GETINTVAR(pi, "mcs5glpo1");
 			pi->mcs5glpo[2] =
-			    (u16) PHY_GETINTVAR(pi, "mcs5glpo2");
+				(u16) PHY_GETINTVAR(pi, "mcs5glpo2");
 			pi->mcs5glpo[3] =
-			    (u16) PHY_GETINTVAR(pi, "mcs5glpo3");
+				(u16) PHY_GETINTVAR(pi, "mcs5glpo3");
 			pi->mcs5glpo[4] =
-			    (u16) PHY_GETINTVAR(pi, "mcs5glpo4");
+				(u16) PHY_GETINTVAR(pi, "mcs5glpo4");
 			pi->mcs5glpo[5] =
-			    (u16) PHY_GETINTVAR(pi, "mcs5glpo5");
+				(u16) PHY_GETINTVAR(pi, "mcs5glpo5");
 			pi->mcs5glpo[6] =
-			    (u16) PHY_GETINTVAR(pi, "mcs5glpo6");
+				(u16) PHY_GETINTVAR(pi, "mcs5glpo6");
 			pi->mcs5glpo[7] =
-			    (u16) PHY_GETINTVAR(pi, "mcs5glpo7");
+				(u16) PHY_GETINTVAR(pi, "mcs5glpo7");
 			break;
 		case 3:
 
 			pi->nphy_txpid5gh[0] =
-			    (u8) PHY_GETINTVAR(pi, "txpid5gha0");
+				(u8) PHY_GETINTVAR(pi, "txpid5gha0");
 			pi->nphy_txpid5gh[1] =
-			    (u8) PHY_GETINTVAR(pi, "txpid5gha1");
+				(u8) PHY_GETINTVAR(pi, "txpid5gha1");
 			pi->nphy_pwrctrl_info[0].max_pwr_5gh =
-			    (s8) PHY_GETINTVAR(pi, "maxp5gha0");
+				(s8) PHY_GETINTVAR(pi, "maxp5gha0");
 			pi->nphy_pwrctrl_info[1].max_pwr_5gh =
-			    (s8) PHY_GETINTVAR(pi, "maxp5gha1");
+				(s8) PHY_GETINTVAR(pi, "maxp5gha1");
 			pi->nphy_pwrctrl_info[0].pwrdet_5gh_a1 =
-			    (s16) PHY_GETINTVAR(pi, "pa5ghw0a0");
+				(s16) PHY_GETINTVAR(pi, "pa5ghw0a0");
 			pi->nphy_pwrctrl_info[1].pwrdet_5gh_a1 =
-			    (s16) PHY_GETINTVAR(pi, "pa5ghw0a1");
+				(s16) PHY_GETINTVAR(pi, "pa5ghw0a1");
 			pi->nphy_pwrctrl_info[0].pwrdet_5gh_b0 =
-			    (s16) PHY_GETINTVAR(pi, "pa5ghw1a0");
+				(s16) PHY_GETINTVAR(pi, "pa5ghw1a0");
 			pi->nphy_pwrctrl_info[1].pwrdet_5gh_b0 =
-			    (s16) PHY_GETINTVAR(pi, "pa5ghw1a1");
+				(s16) PHY_GETINTVAR(pi, "pa5ghw1a1");
 			pi->nphy_pwrctrl_info[0].pwrdet_5gh_b1 =
-			    (s16) PHY_GETINTVAR(pi, "pa5ghw2a0");
+				(s16) PHY_GETINTVAR(pi, "pa5ghw2a0");
 			pi->nphy_pwrctrl_info[1].pwrdet_5gh_b1 =
-			    (s16) PHY_GETINTVAR(pi, "pa5ghw2a1");
+				(s16) PHY_GETINTVAR(pi, "pa5ghw2a1");
 			pi->nphy_pwrctrl_info[0].idle_targ_5gh = 0;
 			pi->nphy_pwrctrl_info[1].idle_targ_5gh = 0;
 
 			pi->ofdm5ghpo = (u32) PHY_GETINTVAR(pi, "ofdm5ghpo");
 
 			pi->mcs5ghpo[0] =
-			    (u16) PHY_GETINTVAR(pi, "mcs5ghpo0");
+				(u16) PHY_GETINTVAR(pi, "mcs5ghpo0");
 			pi->mcs5ghpo[1] =
-			    (u16) PHY_GETINTVAR(pi, "mcs5ghpo1");
+				(u16) PHY_GETINTVAR(pi, "mcs5ghpo1");
 			pi->mcs5ghpo[2] =
-			    (u16) PHY_GETINTVAR(pi, "mcs5ghpo2");
+				(u16) PHY_GETINTVAR(pi, "mcs5ghpo2");
 			pi->mcs5ghpo[3] =
-			    (u16) PHY_GETINTVAR(pi, "mcs5ghpo3");
+				(u16) PHY_GETINTVAR(pi, "mcs5ghpo3");
 			pi->mcs5ghpo[4] =
-			    (u16) PHY_GETINTVAR(pi, "mcs5ghpo4");
+				(u16) PHY_GETINTVAR(pi, "mcs5ghpo4");
 			pi->mcs5ghpo[5] =
-			    (u16) PHY_GETINTVAR(pi, "mcs5ghpo5");
+				(u16) PHY_GETINTVAR(pi, "mcs5ghpo5");
 			pi->mcs5ghpo[6] =
-			    (u16) PHY_GETINTVAR(pi, "mcs5ghpo6");
+				(u16) PHY_GETINTVAR(pi, "mcs5ghpo6");
 			pi->mcs5ghpo[7] =
-			    (u16) PHY_GETINTVAR(pi, "mcs5ghpo7");
+				(u16) PHY_GETINTVAR(pi, "mcs5ghpo7");
 			break;
 		}
 	}
@@ -27707,10 +27946,10 @@ static bool wlc_phy_txpwr_srom_read_nphy(struct brcms_phy *pi)
 	pi->srom_fem5g.triso = (u8) PHY_GETINTVAR(pi, "triso5g");
 	if (PHY_GETVAR(pi, "antswctl5g"))
 		pi->srom_fem5g.antswctrllut =
-		    (u8) PHY_GETINTVAR(pi, "antswctl5g");
+			(u8) PHY_GETINTVAR(pi, "antswctl5g");
 	else
 		pi->srom_fem5g.antswctrllut =
-		    (u8) PHY_GETINTVAR(pi, "antswctl2g");
+			(u8) PHY_GETINTVAR(pi, "antswctl2g");
 
 	wlc_phy_txpower_ipa_upd(pi);
 
@@ -27731,7 +27970,7 @@ static bool wlc_phy_txpwr_srom_read_nphy(struct brcms_phy *pi)
 	}
 
 	pi->phy_txcore_enable_temp =
-	    pi->phy_txcore_disable_temp - PHY_HYSTERESIS_DELTATEMP;
+		pi->phy_txcore_disable_temp - PHY_HYSTERESIS_DELTATEMP;
 
 	pi->phycal_tempdelta = (u8) PHY_GETINTVAR(pi, "phycal_tempdelta");
 	if (pi->phycal_tempdelta > NPHY_CAL_MAXTEMPDELTA)
@@ -27782,11 +28021,11 @@ static void wlc_phy_txpwrctrl_coeff_setup_nphy(struct brcms_phy *pi)
 	for (tbl_id = NPHY_TBL_ID_CORE1TXPWRCTL;
 	     tbl_id <= NPHY_TBL_ID_CORE2TXPWRCTL; tbl_id++) {
 		iqcomp =
-		    (tbl_id ==
-		     26) ? (((u32) (iqloCalbuf[0] & 0x3ff)) << 10) |
-		    (iqloCalbuf[1] & 0x3ff)
-		    : (((u32) (iqloCalbuf[2] & 0x3ff)) << 10) |
-		    (iqloCalbuf[3] & 0x3ff);
+			(tbl_id ==
+			 26) ? (((u32) (iqloCalbuf[0] & 0x3ff)) << 10) |
+			(iqloCalbuf[1] & 0x3ff)
+			: (((u32) (iqloCalbuf[2] & 0x3ff)) << 10) |
+			(iqloCalbuf[3] & 0x3ff);
 
 		for (idx = 0; idx < tbl_len; idx++)
 			regval[idx] = iqcomp;
@@ -27799,7 +28038,7 @@ static void wlc_phy_txpwrctrl_coeff_setup_nphy(struct brcms_phy *pi)
 	     tbl_id <= NPHY_TBL_ID_CORE2TXPWRCTL; tbl_id++) {
 
 		locomp =
-		    (u32) ((tbl_id == 26) ? iqloCalbuf[5] : iqloCalbuf[6]);
+			(u32) ((tbl_id == 26) ? iqloCalbuf[5] : iqloCalbuf[6]);
 		locomp_i = (s8) ((locomp >> 8) & 0xff);
 		locomp_q = (s8) ((locomp) & 0xff);
 		for (idx = 0; idx < tbl_len; idx++) {
@@ -27808,11 +28047,12 @@ static void wlc_phy_txpwrctrl_coeff_setup_nphy(struct brcms_phy *pi)
 				curr_locomp_q = locomp_q;
 			} else {
 				curr_locomp_i = (s8) ((locomp_i *
-							 nphy_tpc_loscale[idx] +
-							 128) >> 8);
+						       nphy_tpc_loscale[idx] +
+						       128) >> 8);
 				curr_locomp_q =
-				    (s8) ((locomp_q * nphy_tpc_loscale[idx] +
-					     128) >> 8);
+					(s8) ((locomp_q *
+					       nphy_tpc_loscale[idx] +
+					       128) >> 8);
 			}
 			curr_locomp = (u32) ((curr_locomp_i & 0xff) << 8);
 			curr_locomp |= (u32) (curr_locomp_q & 0xff);
@@ -27959,8 +28199,8 @@ static void wlc_phy_txpwrctrl_idle_tssi_nphy(struct brcms_phy *pi)
 
 	udelay(20);
 	int_val =
-	    wlc_phy_poll_rssi_nphy(pi, (u8) NPHY_RSSI_SEL_TSSI_2G, rssi_buf,
-				   1);
+		wlc_phy_poll_rssi_nphy(pi, (u8) NPHY_RSSI_SEL_TSSI_2G, rssi_buf,
+				       1);
 	wlc_phy_stopplayback_nphy(pi);
 	wlc_phy_rssisel_nphy(pi, RADIO_MIMO_CORESEL_OFF, 0);
 
@@ -27974,25 +28214,25 @@ static void wlc_phy_txpwrctrl_idle_tssi_nphy(struct brcms_phy *pi)
 	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
 
 		pi->nphy_pwrctrl_info[PHY_CORE_0].idle_tssi_2g =
-		    (u8) ((int_val >> 24) & 0xff);
+			(u8) ((int_val >> 24) & 0xff);
 		pi->nphy_pwrctrl_info[PHY_CORE_0].idle_tssi_5g =
-		    (u8) ((int_val >> 24) & 0xff);
+			(u8) ((int_val >> 24) & 0xff);
 
 		pi->nphy_pwrctrl_info[PHY_CORE_1].idle_tssi_2g =
-		    (u8) ((int_val >> 8) & 0xff);
+			(u8) ((int_val >> 8) & 0xff);
 		pi->nphy_pwrctrl_info[PHY_CORE_1].idle_tssi_5g =
-		    (u8) ((int_val >> 8) & 0xff);
+			(u8) ((int_val >> 8) & 0xff);
 	} else {
 		pi->nphy_pwrctrl_info[PHY_CORE_0].idle_tssi_2g =
-		    (u8) ((int_val >> 24) & 0xff);
+			(u8) ((int_val >> 24) & 0xff);
 
 		pi->nphy_pwrctrl_info[PHY_CORE_1].idle_tssi_2g =
-		    (u8) ((int_val >> 8) & 0xff);
+			(u8) ((int_val >> 8) & 0xff);
 
 		pi->nphy_pwrctrl_info[PHY_CORE_0].idle_tssi_5g =
-		    (u8) ((int_val >> 16) & 0xff);
+			(u8) ((int_val >> 16) & 0xff);
 		pi->nphy_pwrctrl_info[PHY_CORE_1].idle_tssi_5g =
-		    (u8) ((int_val) & 0xff);
+			(u8) ((int_val) & 0xff);
 	}
 
 }
@@ -28047,9 +28287,9 @@ static void wlc_phy_txpwrctrl_pwr_setup_nphy(struct brcms_phy *pi)
 			idle_tssi[0] = pi->nphy_pwrctrl_info[0].idle_tssi_2g;
 			idle_tssi[1] = pi->nphy_pwrctrl_info[1].idle_tssi_2g;
 			target_pwr_qtrdbm[0] =
-			    pi->nphy_pwrctrl_info[0].max_pwr_2g;
+				pi->nphy_pwrctrl_info[0].max_pwr_2g;
 			target_pwr_qtrdbm[1] =
-			    pi->nphy_pwrctrl_info[1].max_pwr_2g;
+				pi->nphy_pwrctrl_info[1].max_pwr_2g;
 			a1[0] = pi->nphy_pwrctrl_info[0].pwrdet_2g_a1;
 			a1[1] = pi->nphy_pwrctrl_info[1].pwrdet_2g_a1;
 			b0[0] = pi->nphy_pwrctrl_info[0].pwrdet_2g_b0;
@@ -28061,9 +28301,9 @@ static void wlc_phy_txpwrctrl_pwr_setup_nphy(struct brcms_phy *pi)
 			idle_tssi[0] = pi->nphy_pwrctrl_info[0].idle_tssi_5g;
 			idle_tssi[1] = pi->nphy_pwrctrl_info[1].idle_tssi_5g;
 			target_pwr_qtrdbm[0] =
-			    pi->nphy_pwrctrl_info[0].max_pwr_5gl;
+				pi->nphy_pwrctrl_info[0].max_pwr_5gl;
 			target_pwr_qtrdbm[1] =
-			    pi->nphy_pwrctrl_info[1].max_pwr_5gl;
+				pi->nphy_pwrctrl_info[1].max_pwr_5gl;
 			a1[0] = pi->nphy_pwrctrl_info[0].pwrdet_5gl_a1;
 			a1[1] = pi->nphy_pwrctrl_info[1].pwrdet_5gl_a1;
 			b0[0] = pi->nphy_pwrctrl_info[0].pwrdet_5gl_b0;
@@ -28075,9 +28315,9 @@ static void wlc_phy_txpwrctrl_pwr_setup_nphy(struct brcms_phy *pi)
 			idle_tssi[0] = pi->nphy_pwrctrl_info[0].idle_tssi_5g;
 			idle_tssi[1] = pi->nphy_pwrctrl_info[1].idle_tssi_5g;
 			target_pwr_qtrdbm[0] =
-			    pi->nphy_pwrctrl_info[0].max_pwr_5gm;
+				pi->nphy_pwrctrl_info[0].max_pwr_5gm;
 			target_pwr_qtrdbm[1] =
-			    pi->nphy_pwrctrl_info[1].max_pwr_5gm;
+				pi->nphy_pwrctrl_info[1].max_pwr_5gm;
 			a1[0] = pi->nphy_pwrctrl_info[0].pwrdet_5gm_a1;
 			a1[1] = pi->nphy_pwrctrl_info[1].pwrdet_5gm_a1;
 			b0[0] = pi->nphy_pwrctrl_info[0].pwrdet_5gm_b0;
@@ -28089,9 +28329,9 @@ static void wlc_phy_txpwrctrl_pwr_setup_nphy(struct brcms_phy *pi)
 			idle_tssi[0] = pi->nphy_pwrctrl_info[0].idle_tssi_5g;
 			idle_tssi[1] = pi->nphy_pwrctrl_info[1].idle_tssi_5g;
 			target_pwr_qtrdbm[0] =
-			    pi->nphy_pwrctrl_info[0].max_pwr_5gh;
+				pi->nphy_pwrctrl_info[0].max_pwr_5gh;
 			target_pwr_qtrdbm[1] =
-			    pi->nphy_pwrctrl_info[1].max_pwr_5gh;
+				pi->nphy_pwrctrl_info[1].max_pwr_5gh;
 			a1[0] = pi->nphy_pwrctrl_info[0].pwrdet_5gh_a1;
 			a1[1] = pi->nphy_pwrctrl_info[1].pwrdet_5gh_a1;
 			b0[0] = pi->nphy_pwrctrl_info[0].pwrdet_5gh_b0;
@@ -28142,14 +28382,14 @@ static void wlc_phy_txpwrctrl_pwr_setup_nphy(struct brcms_phy *pi)
 				write_radio_reg(pi, RADIO_2056_TX_TX_SSI_MUX |
 						RADIO_2056_TX0,
 						(CHSPEC_IS5G
-						 (pi->
-						  radio_chanspec)) ? 0xc : 0xe);
+						 (pi->radio_chanspec)) ?
+						 0xc : 0xe);
 				write_radio_reg(pi,
 						RADIO_2056_TX_TX_SSI_MUX |
 						RADIO_2056_TX1,
 						(CHSPEC_IS5G
-						 (pi->
-						  radio_chanspec)) ? 0xc : 0xe);
+						 (pi->radio_chanspec)) ?
+						 0xc : 0xe);
 			} else {
 
 				write_radio_reg(pi, RADIO_2056_TX_TX_SSI_MUX |
@@ -28198,17 +28438,17 @@ static void wlc_phy_txpwrctrl_pwr_setup_nphy(struct brcms_phy *pi)
 	     tbl_id <= NPHY_TBL_ID_CORE2TXPWRCTL; tbl_id++) {
 
 		for (idx = 0; idx < tbl_len; idx++) {
-			num =
-			    8 * (16 * b0[tbl_id - 26] + b1[tbl_id - 26] * idx);
+			num = 8 *
+			      (16 * b0[tbl_id - 26] + b1[tbl_id - 26] * idx);
 			den = 32768 + a1[tbl_id - 26] * idx;
 			pwr_est = max(((4 * num + den / 2) / den), -8);
 			if (NREV_LT(pi->pubpi.phy_rev, 3)) {
 				if (idx <=
 				    (uint) (31 - idle_tssi[tbl_id - 26] + 1))
 					pwr_est =
-					    max(pwr_est,
-						target_pwr_qtrdbm[tbl_id - 26] +
-						1);
+						max(pwr_est,
+						    target_pwr_qtrdbm
+						    [tbl_id - 26] + 1);
 			}
 			regval[idx] = (u32) pwr_est;
 		}
@@ -28229,7 +28469,7 @@ static void wlc_phy_txpwrctrl_pwr_setup_nphy(struct brcms_phy *pi)
 static bool wlc_phy_txpwr_ison_nphy(struct brcms_phy *pi)
 {
 	return read_phy_reg((pi), 0x1e7) & ((0x1 << 15) |
-					     (0x1 << 14) | (0x1 << 13));
+					    (0x1 << 14) | (0x1 << 13));
 }
 
 static u8 wlc_phy_txpwr_idx_cur_get_nphy(struct brcms_phy *pi, u8 core)
@@ -28261,12 +28501,9 @@ u16 wlc_phy_txpwr_idx_get_nphy(struct brcms_phy *pi)
 
 		tmp = (pwr_idx[0] << 8) | pwr_idx[1];
 	} else {
-		tmp =
-		    ((pi->nphy_txpwrindex[PHY_CORE_0].
-		      index_internal & 0xff) << 8) | (pi->
-						      nphy_txpwrindex
-						      [PHY_CORE_1].
-						      index_internal & 0xff);
+		tmp = ((pi->nphy_txpwrindex[PHY_CORE_0].index_internal & 0xff)
+			<< 8) |
+			(pi->nphy_txpwrindex[PHY_CORE_1].index_internal & 0xff);
 	}
 
 	return tmp;
@@ -28315,9 +28552,9 @@ void wlc_phy_txpwrctrl_enable_nphy(struct brcms_phy *pi, u8 ctrl_type)
 				for (core = 0; core < pi->pubpi.phy_corenum;
 				     core++)
 					pi->nphy_txpwr_idx[core] =
-					    wlc_phy_txpwr_idx_cur_get_nphy(pi,
-									   (u8)
-									   core);
+						wlc_phy_txpwr_idx_cur_get_nphy(
+							pi,
+							(u8) core);
 			}
 
 		}
@@ -28334,7 +28571,7 @@ void wlc_phy_txpwrctrl_enable_nphy(struct brcms_phy *pi, u8 ctrl_type)
 		if (NREV_GE(pi->pubpi.phy_rev, 3))
 			and_phy_reg(pi, 0x1e7,
 				    (u16) (~((0x1 << 15) |
-						(0x1 << 14) | (0x1 << 13))));
+					     (0x1 << 14) | (0x1 << 13))));
 		else
 			and_phy_reg(pi, 0x1e7,
 				    (u16) (~((0x1 << 14) | (0x1 << 13))));
@@ -28517,7 +28754,7 @@ wlc_phy_txpwr_index_nphy(struct brcms_phy *pi, u8 core_mask, s8 txpwrindex,
 			wlc_phy_txpwrctrl_enable_nphy(pi, pi->nphy_txpwrctrl);
 
 			pi->nphy_txpwrindex[core].index_internal =
-			    pi->nphy_txpwrindex[core].index_internal_save;
+				pi->nphy_txpwrindex[core].index_internal_save;
 		} else {
 
 			if (pi->nphy_txpwrindex[core].index < 0) {
@@ -28532,14 +28769,13 @@ wlc_phy_txpwr_index_nphy(struct brcms_phy *pi, u8 core_mask, s8 txpwrindex,
 						    AfectrlOverride);
 				} else {
 					pi->nphy_txpwrindex[core].
-					    AfectrlOverride =
-					    read_phy_reg(pi, 0xa5);
+					AfectrlOverride =
+						read_phy_reg(pi, 0xa5);
 				}
 
 				pi->nphy_txpwrindex[core].AfeCtrlDacGain =
-				    read_phy_reg(pi,
-						 (core ==
-						  PHY_CORE_0) ? 0xaa : 0xab);
+					read_phy_reg(pi, (core == PHY_CORE_0) ?
+							 0xaa : 0xab);
 
 				wlc_phy_table_read_nphy(pi, 7, 1,
 							(0x110 + core), 16,
@@ -28551,8 +28787,7 @@ wlc_phy_txpwr_index_nphy(struct brcms_phy *pi, u8 core_mask, s8 txpwrindex,
 							&tmpval);
 				tmpval >>= ((core == PHY_CORE_0) ? 8 : 0);
 				tmpval &= 0xff;
-				pi->nphy_txpwrindex[core].bbmult =
-				    (u8) tmpval;
+				pi->nphy_txpwrindex[core].bbmult = (u8) tmpval;
 
 				wlc_phy_table_read_nphy(pi, 15, 2,
 							(80 + 2 * core), 16,
@@ -28567,7 +28802,8 @@ wlc_phy_txpwr_index_nphy(struct brcms_phy *pi, u8 core_mask, s8 txpwrindex,
 							locomp);
 
 				pi->nphy_txpwrindex[core].index_internal_save =
-				    pi->nphy_txpwrindex[core].index_internal;
+					pi->nphy_txpwrindex[core].
+					index_internal;
 			}
 
 			tx_pwr_ctrl_state = pi->nphy_txpwrctrl;
@@ -28581,11 +28817,11 @@ wlc_phy_txpwr_index_nphy(struct brcms_phy *pi, u8 core_mask, s8 txpwrindex,
 						&txgain);
 
 			if (NREV_GE(pi->pubpi.phy_rev, 3))
-				rad_gain =
-				    (txgain >> 16) & ((1 << (32 - 16 + 1)) - 1);
+				rad_gain = (txgain >> 16) &
+					   ((1 << (32 - 16 + 1)) - 1);
 			else
-				rad_gain =
-				    (txgain >> 16) & ((1 << (28 - 16 + 1)) - 1);
+				rad_gain = (txgain >> 16) &
+					   ((1 << (28 - 16 + 1)) - 1);
 
 			dac_gain = (txgain >> 8) & ((1 << (13 - 8 + 1)) - 1);
 			bbmult = (txgain >> 0) & ((1 << (7 - 0 + 1)) - 1);
@@ -28604,9 +28840,8 @@ wlc_phy_txpwr_index_nphy(struct brcms_phy *pi, u8 core_mask, s8 txpwrindex,
 
 			wlc_phy_table_read_nphy(pi, 15, 1, 87, 16, &m1m2);
 			m1m2 &= ((core == PHY_CORE_0) ? 0x00ff : 0xff00);
-			m1m2 |=
-			    ((core ==
-			      PHY_CORE_0) ? (bbmult << 8) : (bbmult << 0));
+			m1m2 |= ((core == PHY_CORE_0) ?
+				(bbmult << 8) : (bbmult << 0));
 
 			wlc_phy_table_write_nphy(pi, 15, 1, 87, 16, &m1m2);
 
@@ -28636,13 +28871,11 @@ wlc_phy_txpwr_index_nphy(struct brcms_phy *pi, u8 core_mask, s8 txpwrindex,
 
 			if (PHY_IPA(pi)) {
 				wlc_phy_table_read_nphy(pi,
-							(core ==
-							 PHY_CORE_0 ?
-							 NPHY_TBL_ID_CORE1TXPWRCTL
-							 :
-							 NPHY_TBL_ID_CORE2TXPWRCTL),
-							1, 576 + txpwrindex, 32,
-							&rfpwr_offset);
+						(core == PHY_CORE_0 ?
+						 NPHY_TBL_ID_CORE1TXPWRCTL :
+						 NPHY_TBL_ID_CORE2TXPWRCTL),
+						1, 576 + txpwrindex, 32,
+						&rfpwr_offset);
 
 				mod_phy_reg(pi, (core == PHY_CORE_0) ? 0x297 :
 					    0x29b, (0x1ff << 4),
@@ -28698,7 +28931,7 @@ void wlc_phy_stay_in_carriersearch_nphy(struct brcms_phy *pi, bool enable)
 	if (enable) {
 		if (pi->nphy_deaf_count == 0) {
 			pi->classifier_state =
-			    wlc_phy_classifier_nphy(pi, 0, 0);
+				wlc_phy_classifier_nphy(pi, 0, 0);
 			wlc_phy_classifier_nphy(pi, (0x7 << 0), 4);
 			wlc_phy_clip_det_nphy(pi, 0, pi->clip_state);
 			wlc_phy_clip_det_nphy(pi, 1, clip_off);
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_qmath.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_qmath.c
index 7ff2850..faf1ebe 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_qmath.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_qmath.c
@@ -17,21 +17,23 @@
 #include "phy_qmath.h"
 
 /*
-Description: This function make 16 bit unsigned multiplication. To fit the output into
-16 bits the 32 bit multiplication result is right shifted by 16 bits.
-*/
+ * Description: This function make 16 bit unsigned multiplication.
+ * To fit the output into 16 bits the 32 bit multiplication result is right
+ * shifted by 16 bits.
+ */
 u16 qm_mulu16(u16 op1, u16 op2)
 {
 	return (u16) (((u32) op1 * (u32) op2) >> 16);
 }
 
 /*
-Description: This function make 16 bit multiplication and return the result in 16 bits.
-To fit the multiplication result into 16 bits the multiplication result is right shifted by
-15 bits. Right shifting 15 bits instead of 16 bits is done to remove the extra sign bit formed
-due to the multiplication.
-When both the 16bit inputs are 0x8000 then the output is saturated to 0x7fffffff.
-*/
+ * Description: This function make 16 bit multiplication and return the result
+ * in 16 bits. To fit the multiplication result into 16 bits the multiplication
+ * result is right shifted by 15 bits. Right shifting 15 bits instead of 16 bits
+ * is done to remove the extra sign bit formed due to the multiplication.
+ * When both the 16bit inputs are 0x8000 then the output is saturated to
+ * 0x7fffffff.
+ */
 s16 qm_muls16(s16 op1, s16 op2)
 {
 	s32 result;
@@ -44,9 +46,10 @@ s16 qm_muls16(s16 op1, s16 op2)
 }
 
 /*
-Description: This function add two 32 bit numbers and return the 32bit result.
-If the result overflow 32 bits, the output will be saturated to 32bits.
-*/
+ * Description: This function add two 32 bit numbers and return the 32bit
+ * result. If the result overflow 32 bits, the output will be saturated to
+ * 32bits.
+ */
 s32 qm_add32(s32 op1, s32 op2)
 {
 	s32 result;
@@ -60,9 +63,10 @@ s32 qm_add32(s32 op1, s32 op2)
 }
 
 /*
-Description: This function add two 16 bit numbers and return the 16bit result.
-If the result overflow 16 bits, the output will be saturated to 16bits.
-*/
+ * Description: This function add two 16 bit numbers and return the 16bit
+ * result. If the result overflow 16 bits, the output will be saturated to
+ * 16bits.
+ */
 s16 qm_add16(s16 op1, s16 op2)
 {
 	s16 result;
@@ -78,9 +82,10 @@ s16 qm_add16(s16 op1, s16 op2)
 }
 
 /*
-Description: This function make 16 bit subtraction and return the 16bit result.
-If the result overflow 16 bits, the output will be saturated to 16bits.
-*/
+ * Description: This function make 16 bit subtraction and return the 16bit
+ * result. If the result overflow 16 bits, the output will be saturated to
+ * 16bits.
+ */
 s16 qm_sub16(s16 op1, s16 op2)
 {
 	s16 result;
@@ -96,10 +101,11 @@ s16 qm_sub16(s16 op1, s16 op2)
 }
 
 /*
-Description: This function make a 32 bit saturated left shift when the specified shift
-is +ve. This function will make a 32 bit right shift when the specified shift is -ve.
-This function return the result after shifting operation.
-*/
+ * Description: This function make a 32 bit saturated left shift when the
+ * specified shift is +ve. This function will make a 32 bit right shift when
+ * the specified shift is -ve. This function return the result after shifting
+ * operation.
+ */
 s32 qm_shl32(s32 op, int shift)
 {
 	int i;
@@ -120,10 +126,11 @@ s32 qm_shl32(s32 op, int shift)
 }
 
 /*
-Description: This function make a 16 bit saturated left shift when the specified shift
-is +ve. This function will make a 16 bit right shift when the specified shift is -ve.
-This function return the result after shifting operation.
-*/
+ * Description: This function make a 16 bit saturated left shift when the
+ * specified shift is +ve. This function will make a 16 bit right shift when
+ * the specified shift is -ve. This function return the result after shifting
+ * operation.
+ */
 s16 qm_shl16(s16 op, int shift)
 {
 	int i;
@@ -144,19 +151,19 @@ s16 qm_shl16(s16 op, int shift)
 }
 
 /*
-Description: This function make a 16 bit right shift when shift is +ve.
-This function make a 16 bit saturated left shift when shift is -ve. This function
-return the result of the shift operation.
-*/
+ * Description: This function make a 16 bit right shift when shift is +ve.
+ * This function make a 16 bit saturated left shift when shift is -ve. This
+ * function return the result of the shift operation.
+ */
 s16 qm_shr16(s16 op, int shift)
 {
 	return qm_shl16(op, -shift);
 }
 
 /*
-Description: This function return the number of redundant sign bits in a 32 bit number.
-Example: qm_norm32(0x00000080) = 23
-*/
+ * Description: This function return the number of redundant sign bits in a
+ * 32 bit number. Example: qm_norm32(0x00000080) = 23
+ */
 s16 qm_norm32(s32 op)
 {
 	u16 u16extraSignBits;
@@ -208,28 +215,30 @@ static const s16 log_table[] = {
 	32024
 };
 
-#define LOG_TABLE_SIZE 32	/* log_table size */
-#define LOG2_LOG_TABLE_SIZE 5	/* log2(log_table size) */
-#define Q_LOG_TABLE 15		/* qformat of log_table */
-#define LOG10_2		19728	/* log10(2) in q.16 */
+#define LOG_TABLE_SIZE 32       /* log_table size */
+#define LOG2_LOG_TABLE_SIZE 5   /* log2(log_table size) */
+#define Q_LOG_TABLE 15          /* qformat of log_table */
+#define LOG10_2         19728   /* log10(2) in q.16 */
 
 /*
-Description:
-This routine takes the input number N and its q format qN and compute
-the log10(N). This routine first normalizes the input no N.	Then N is in mag*(2^x) format.
-mag is any number in the range 2^30-(2^31 - 1). Then log2(mag * 2^x) = log2(mag) + x is computed.
-From that log10(mag * 2^x) = log2(mag * 2^x) * log10(2) is computed.
-This routine looks the log2 value in the table considering LOG2_LOG_TABLE_SIZE+1 MSBs.
-As the MSB is always 1, only next LOG2_OF_LOG_TABLE_SIZE MSBs are used for table lookup.
-Next 16 MSBs are used for interpolation.
-Inputs:
-N - number to which log10 has to be found.
-qN - q format of N
-log10N - address where log10(N) will be written.
-qLog10N - address where log10N qformat will be written.
-Note/Problem:
-For accurate results input should be in normalized or near normalized form.
-*/
+ * Description:
+ * This routine takes the input number N and its q format qN and compute
+ * the log10(N). This routine first normalizes the input no N.	Then N is in
+ * mag*(2^x) format. mag is any number in the range 2^30-(2^31 - 1).
+ * Then log2(mag * 2^x) = log2(mag) + x is computed. From that
+ * log10(mag * 2^x) = log2(mag * 2^x) * log10(2) is computed.
+ * This routine looks the log2 value in the table considering
+ * LOG2_LOG_TABLE_SIZE+1 MSBs. As the MSB is always 1, only next
+ * LOG2_OF_LOG_TABLE_SIZE MSBs are used for table lookup. Next 16 MSBs are used
+ * for interpolation.
+ * Inputs:
+ * N - number to which log10 has to be found.
+ * qN - q format of N
+ * log10N - address where log10(N) will be written.
+ * qLog10N - address where log10N qformat will be written.
+ * Note/Problem:
+ * For accurate results input should be in normalized or near normalized form.
+ */
 void qm_log10(s32 N, s16 qN, s16 *log10N, s16 *qLog10N)
 {
 	s16 s16norm, s16tableIndex, s16errorApproximation;
@@ -248,12 +257,13 @@ void qm_log10(s32 N, s16 qN, s16 *log10N, s16 *qLog10N)
 	 */
 	qN = qN + s16norm - 30;
 
-	/* take the table index as the LOG2_OF_LOG_TABLE_SIZE bits right of the MSB */
+	/* take the table index as the LOG2_OF_LOG_TABLE_SIZE bits right of the
+	 * MSB */
 	s16tableIndex = (s16) (N >> (32 - (2 + LOG2_LOG_TABLE_SIZE)));
 
 	/* remove the MSB. the MSB is always 1 after normalization. */
 	s16tableIndex =
-	    s16tableIndex & (s16) ((1 << LOG2_LOG_TABLE_SIZE) - 1);
+		s16tableIndex & (s16) ((1 << LOG2_LOG_TABLE_SIZE) - 1);
 
 	/* remove the (1+LOG2_OF_LOG_TABLE_SIZE) MSBs in the N. */
 	N = N & ((1 << (32 - (2 + LOG2_LOG_TABLE_SIZE))) - 1);
@@ -263,23 +273,27 @@ void qm_log10(s32 N, s16 qN, s16 *log10N, s16 *qLog10N)
 	u16offset = (u16) (N >> (32 - (2 + LOG2_LOG_TABLE_SIZE + 16)));
 
 	/* look the log value in the table. */
-	s32log = log_table[s16tableIndex];	/* q.15 format */
+	s32log = log_table[s16tableIndex];      /* q.15 format */
 
-	/* interpolate using the offset. */
-	s16errorApproximation = (s16) qm_mulu16(u16offset, (u16) (log_table[s16tableIndex + 1] - log_table[s16tableIndex]));	/* q.15 */
+	/* interpolate using the offset. q.15 format. */
+	s16errorApproximation = (s16) qm_mulu16(u16offset,
+				(u16) (log_table[s16tableIndex + 1] -
+				       log_table[s16tableIndex]));
 
-	s32log = qm_add16((s16) s32log, s16errorApproximation);	/* q.15 format */
+	 /* q.15 format */
+	s32log = qm_add16((s16) s32log, s16errorApproximation);
 
 	/* adjust for the qformat of the N as
 	 * log2(mag * 2^x) = log2(mag) + x
 	 */
-	s32log = qm_add32(s32log, ((s32) -qN) << 15);	/* q.15 format */
+	s32log = qm_add32(s32log, ((s32) -qN) << 15);   /* q.15 format */
 
 	/* normalize the result. */
 	s16norm = qm_norm32(s32log);
 
 	/* bring all the important bits into lower 16 bits */
-	s32log = qm_shl32(s32log, s16norm - 16);	/* q.15+s16norm-16 format */
+	/* q.15+s16norm-16 format */
+	s32log = qm_shl32(s32log, s16norm - 16);
 
 	/* compute the log10(N) by multiplying log2(N) with log10(2).
 	 * as log10(mag * 2^x) = log2(mag * 2^x) * log10(2)
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c
index 023d05a..c354496 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c
@@ -2834,26 +2834,26 @@ const struct phytbl_info dot11lcnphytbl_info_rev0[] = {
 
 const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313 = {
 	&dot11lcn_sw_ctrl_tbl_4313_rev0,
-	    sizeof(dot11lcn_sw_ctrl_tbl_4313_rev0) /
-	    sizeof(dot11lcn_sw_ctrl_tbl_4313_rev0[0]), 15, 0, 16
+	sizeof(dot11lcn_sw_ctrl_tbl_4313_rev0) /
+	sizeof(dot11lcn_sw_ctrl_tbl_4313_rev0[0]), 15, 0, 16
 };
 
 const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313_epa = {
 	&dot11lcn_sw_ctrl_tbl_4313_epa_rev0,
-	    sizeof(dot11lcn_sw_ctrl_tbl_4313_epa_rev0) /
-	    sizeof(dot11lcn_sw_ctrl_tbl_4313_epa_rev0[0]), 15, 0, 16
+	sizeof(dot11lcn_sw_ctrl_tbl_4313_epa_rev0) /
+	sizeof(dot11lcn_sw_ctrl_tbl_4313_epa_rev0[0]), 15, 0, 16
 };
 
 const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313_bt_epa = {
 	&dot11lcn_sw_ctrl_tbl_4313_epa_rev0_combo,
-	    sizeof(dot11lcn_sw_ctrl_tbl_4313_epa_rev0_combo) /
-	    sizeof(dot11lcn_sw_ctrl_tbl_4313_epa_rev0_combo[0]), 15, 0, 16
+	sizeof(dot11lcn_sw_ctrl_tbl_4313_epa_rev0_combo) /
+	sizeof(dot11lcn_sw_ctrl_tbl_4313_epa_rev0_combo[0]), 15, 0, 16
 };
 
 const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313_bt_epa_p250 = {
 	&dot11lcn_sw_ctrl_tbl_4313_bt_epa_p250_rev0,
-	    sizeof(dot11lcn_sw_ctrl_tbl_4313_bt_epa_p250_rev0) /
-	    sizeof(dot11lcn_sw_ctrl_tbl_4313_bt_epa_p250_rev0[0]), 15, 0, 16
+	sizeof(dot11lcn_sw_ctrl_tbl_4313_bt_epa_p250_rev0) /
+	sizeof(dot11lcn_sw_ctrl_tbl_4313_bt_epa_p250_rev0[0]), 15, 0, 16
 };
 
 const u32 dot11lcnphytbl_info_sz_rev0 =
@@ -2861,778 +2861,394 @@ const u32 dot11lcnphytbl_info_sz_rev0 =
 
 const struct lcnphy_tx_gain_tbl_entry
 dot11lcnphy_2GHz_extPA_gaintable_rev0[128] = {
-	{3, 0, 31, 0, 72,}
-	,
-	{3, 0, 31, 0, 70,}
-	,
-	{3, 0, 31, 0, 68,}
-	,
-	{3, 0, 30, 0, 67,}
-	,
-	{3, 0, 29, 0, 68,}
-	,
-	{3, 0, 28, 0, 68,}
-	,
-	{3, 0, 27, 0, 69,}
-	,
-	{3, 0, 26, 0, 70,}
-	,
-	{3, 0, 25, 0, 70,}
-	,
-	{3, 0, 24, 0, 71,}
-	,
-	{3, 0, 23, 0, 72,}
-	,
-	{3, 0, 23, 0, 70,}
-	,
-	{3, 0, 22, 0, 71,}
-	,
-	{3, 0, 21, 0, 72,}
-	,
-	{3, 0, 21, 0, 70,}
-	,
-	{3, 0, 21, 0, 68,}
-	,
-	{3, 0, 21, 0, 66,}
-	,
-	{3, 0, 21, 0, 64,}
-	,
-	{3, 0, 21, 0, 63,}
-	,
-	{3, 0, 20, 0, 64,}
-	,
-	{3, 0, 19, 0, 65,}
-	,
-	{3, 0, 19, 0, 64,}
-	,
-	{3, 0, 18, 0, 65,}
-	,
-	{3, 0, 18, 0, 64,}
-	,
-	{3, 0, 17, 0, 65,}
-	,
-	{3, 0, 17, 0, 64,}
-	,
-	{3, 0, 16, 0, 65,}
-	,
-	{3, 0, 16, 0, 64,}
-	,
-	{3, 0, 16, 0, 62,}
-	,
-	{3, 0, 16, 0, 60,}
-	,
-	{3, 0, 16, 0, 58,}
-	,
-	{3, 0, 15, 0, 61,}
-	,
-	{3, 0, 15, 0, 59,}
-	,
-	{3, 0, 14, 0, 61,}
-	,
-	{3, 0, 14, 0, 60,}
-	,
-	{3, 0, 14, 0, 58,}
-	,
-	{3, 0, 13, 0, 60,}
-	,
-	{3, 0, 13, 0, 59,}
-	,
-	{3, 0, 12, 0, 62,}
-	,
-	{3, 0, 12, 0, 60,}
-	,
-	{3, 0, 12, 0, 58,}
-	,
-	{3, 0, 11, 0, 62,}
-	,
-	{3, 0, 11, 0, 60,}
-	,
-	{3, 0, 11, 0, 59,}
-	,
-	{3, 0, 11, 0, 57,}
-	,
-	{3, 0, 10, 0, 61,}
-	,
-	{3, 0, 10, 0, 59,}
-	,
-	{3, 0, 10, 0, 57,}
-	,
-	{3, 0, 9, 0, 62,}
-	,
-	{3, 0, 9, 0, 60,}
-	,
-	{3, 0, 9, 0, 58,}
-	,
-	{3, 0, 9, 0, 57,}
-	,
-	{3, 0, 8, 0, 62,}
-	,
-	{3, 0, 8, 0, 60,}
-	,
-	{3, 0, 8, 0, 58,}
-	,
-	{3, 0, 8, 0, 57,}
-	,
-	{3, 0, 8, 0, 55,}
-	,
-	{3, 0, 7, 0, 61,}
-	,
-	{3, 0, 7, 0, 60,}
-	,
-	{3, 0, 7, 0, 58,}
-	,
-	{3, 0, 7, 0, 56,}
-	,
-	{3, 0, 7, 0, 55,}
-	,
-	{3, 0, 6, 0, 62,}
-	,
-	{3, 0, 6, 0, 60,}
-	,
-	{3, 0, 6, 0, 58,}
-	,
-	{3, 0, 6, 0, 57,}
-	,
-	{3, 0, 6, 0, 55,}
-	,
-	{3, 0, 6, 0, 54,}
-	,
-	{3, 0, 6, 0, 52,}
-	,
-	{3, 0, 5, 0, 61,}
-	,
-	{3, 0, 5, 0, 59,}
-	,
-	{3, 0, 5, 0, 57,}
-	,
-	{3, 0, 5, 0, 56,}
-	,
-	{3, 0, 5, 0, 54,}
-	,
-	{3, 0, 5, 0, 53,}
-	,
-	{3, 0, 5, 0, 51,}
-	,
-	{3, 0, 4, 0, 62,}
-	,
-	{3, 0, 4, 0, 60,}
-	,
-	{3, 0, 4, 0, 58,}
-	,
-	{3, 0, 4, 0, 57,}
-	,
-	{3, 0, 4, 0, 55,}
-	,
-	{3, 0, 4, 0, 54,}
-	,
-	{3, 0, 4, 0, 52,}
-	,
-	{3, 0, 4, 0, 51,}
-	,
-	{3, 0, 4, 0, 49,}
-	,
-	{3, 0, 4, 0, 48,}
-	,
-	{3, 0, 4, 0, 46,}
-	,
-	{3, 0, 3, 0, 60,}
-	,
-	{3, 0, 3, 0, 58,}
-	,
-	{3, 0, 3, 0, 57,}
-	,
-	{3, 0, 3, 0, 55,}
-	,
-	{3, 0, 3, 0, 54,}
-	,
-	{3, 0, 3, 0, 52,}
-	,
-	{3, 0, 3, 0, 51,}
-	,
-	{3, 0, 3, 0, 49,}
-	,
-	{3, 0, 3, 0, 48,}
-	,
-	{3, 0, 3, 0, 46,}
-	,
-	{3, 0, 3, 0, 45,}
-	,
-	{3, 0, 3, 0, 44,}
-	,
-	{3, 0, 3, 0, 43,}
-	,
-	{3, 0, 3, 0, 41,}
-	,
-	{3, 0, 2, 0, 61,}
-	,
-	{3, 0, 2, 0, 59,}
-	,
-	{3, 0, 2, 0, 57,}
-	,
-	{3, 0, 2, 0, 56,}
-	,
-	{3, 0, 2, 0, 54,}
-	,
-	{3, 0, 2, 0, 53,}
-	,
-	{3, 0, 2, 0, 51,}
-	,
-	{3, 0, 2, 0, 50,}
-	,
-	{3, 0, 2, 0, 48,}
-	,
-	{3, 0, 2, 0, 47,}
-	,
-	{3, 0, 2, 0, 46,}
-	,
-	{3, 0, 2, 0, 44,}
-	,
-	{3, 0, 2, 0, 43,}
-	,
-	{3, 0, 2, 0, 42,}
-	,
-	{3, 0, 2, 0, 41,}
-	,
-	{3, 0, 2, 0, 39,}
-	,
-	{3, 0, 2, 0, 38,}
-	,
-	{3, 0, 2, 0, 37,}
-	,
-	{3, 0, 2, 0, 36,}
-	,
-	{3, 0, 2, 0, 35,}
-	,
-	{3, 0, 2, 0, 34,}
-	,
-	{3, 0, 2, 0, 33,}
-	,
-	{3, 0, 2, 0, 32,}
-	,
-	{3, 0, 1, 0, 63,}
-	,
-	{3, 0, 1, 0, 61,}
-	,
-	{3, 0, 1, 0, 59,}
-	,
-	{3, 0, 1, 0, 57,}
-	,
+	{3, 0, 31, 0, 72},
+	{3, 0, 31, 0, 70},
+	{3, 0, 31, 0, 68},
+	{3, 0, 30, 0, 67},
+	{3, 0, 29, 0, 68},
+	{3, 0, 28, 0, 68},
+	{3, 0, 27, 0, 69},
+	{3, 0, 26, 0, 70},
+	{3, 0, 25, 0, 70},
+	{3, 0, 24, 0, 71},
+	{3, 0, 23, 0, 72},
+	{3, 0, 23, 0, 70},
+	{3, 0, 22, 0, 71},
+	{3, 0, 21, 0, 72},
+	{3, 0, 21, 0, 70},
+	{3, 0, 21, 0, 68},
+	{3, 0, 21, 0, 66},
+	{3, 0, 21, 0, 64},
+	{3, 0, 21, 0, 63},
+	{3, 0, 20, 0, 64},
+	{3, 0, 19, 0, 65},
+	{3, 0, 19, 0, 64},
+	{3, 0, 18, 0, 65},
+	{3, 0, 18, 0, 64},
+	{3, 0, 17, 0, 65},
+	{3, 0, 17, 0, 64},
+	{3, 0, 16, 0, 65},
+	{3, 0, 16, 0, 64},
+	{3, 0, 16, 0, 62},
+	{3, 0, 16, 0, 60},
+	{3, 0, 16, 0, 58},
+	{3, 0, 15, 0, 61},
+	{3, 0, 15, 0, 59},
+	{3, 0, 14, 0, 61},
+	{3, 0, 14, 0, 60},
+	{3, 0, 14, 0, 58},
+	{3, 0, 13, 0, 60},
+	{3, 0, 13, 0, 59},
+	{3, 0, 12, 0, 62},
+	{3, 0, 12, 0, 60},
+	{3, 0, 12, 0, 58},
+	{3, 0, 11, 0, 62},
+	{3, 0, 11, 0, 60},
+	{3, 0, 11, 0, 59},
+	{3, 0, 11, 0, 57},
+	{3, 0, 10, 0, 61},
+	{3, 0, 10, 0, 59},
+	{3, 0, 10, 0, 57},
+	{3, 0, 9, 0, 62},
+	{3, 0, 9, 0, 60},
+	{3, 0, 9, 0, 58},
+	{3, 0, 9, 0, 57},
+	{3, 0, 8, 0, 62},
+	{3, 0, 8, 0, 60},
+	{3, 0, 8, 0, 58},
+	{3, 0, 8, 0, 57},
+	{3, 0, 8, 0, 55},
+	{3, 0, 7, 0, 61},
+	{3, 0, 7, 0, 60},
+	{3, 0, 7, 0, 58},
+	{3, 0, 7, 0, 56},
+	{3, 0, 7, 0, 55},
+	{3, 0, 6, 0, 62},
+	{3, 0, 6, 0, 60},
+	{3, 0, 6, 0, 58},
+	{3, 0, 6, 0, 57},
+	{3, 0, 6, 0, 55},
+	{3, 0, 6, 0, 54},
+	{3, 0, 6, 0, 52},
+	{3, 0, 5, 0, 61},
+	{3, 0, 5, 0, 59},
+	{3, 0, 5, 0, 57},
+	{3, 0, 5, 0, 56},
+	{3, 0, 5, 0, 54},
+	{3, 0, 5, 0, 53},
+	{3, 0, 5, 0, 51},
+	{3, 0, 4, 0, 62},
+	{3, 0, 4, 0, 60},
+	{3, 0, 4, 0, 58},
+	{3, 0, 4, 0, 57},
+	{3, 0, 4, 0, 55},
+	{3, 0, 4, 0, 54},
+	{3, 0, 4, 0, 52},
+	{3, 0, 4, 0, 51},
+	{3, 0, 4, 0, 49},
+	{3, 0, 4, 0, 48},
+	{3, 0, 4, 0, 46},
+	{3, 0, 3, 0, 60},
+	{3, 0, 3, 0, 58},
+	{3, 0, 3, 0, 57},
+	{3, 0, 3, 0, 55},
+	{3, 0, 3, 0, 54},
+	{3, 0, 3, 0, 52},
+	{3, 0, 3, 0, 51},
+	{3, 0, 3, 0, 49},
+	{3, 0, 3, 0, 48},
+	{3, 0, 3, 0, 46},
+	{3, 0, 3, 0, 45},
+	{3, 0, 3, 0, 44},
+	{3, 0, 3, 0, 43},
+	{3, 0, 3, 0, 41},
+	{3, 0, 2, 0, 61},
+	{3, 0, 2, 0, 59},
+	{3, 0, 2, 0, 57},
+	{3, 0, 2, 0, 56},
+	{3, 0, 2, 0, 54},
+	{3, 0, 2, 0, 53},
+	{3, 0, 2, 0, 51},
+	{3, 0, 2, 0, 50},
+	{3, 0, 2, 0, 48},
+	{3, 0, 2, 0, 47},
+	{3, 0, 2, 0, 46},
+	{3, 0, 2, 0, 44},
+	{3, 0, 2, 0, 43},
+	{3, 0, 2, 0, 42},
+	{3, 0, 2, 0, 41},
+	{3, 0, 2, 0, 39},
+	{3, 0, 2, 0, 38},
+	{3, 0, 2, 0, 37},
+	{3, 0, 2, 0, 36},
+	{3, 0, 2, 0, 35},
+	{3, 0, 2, 0, 34},
+	{3, 0, 2, 0, 33},
+	{3, 0, 2, 0, 32},
+	{3, 0, 1, 0, 63},
+	{3, 0, 1, 0, 61},
+	{3, 0, 1, 0, 59},
+	{3, 0, 1, 0, 57},
 };
 
 const struct lcnphy_tx_gain_tbl_entry dot11lcnphy_2GHz_gaintable_rev0[128] = {
-	{7, 0, 31, 0, 72,}
-	,
-	{7, 0, 31, 0, 70,}
-	,
-	{7, 0, 31, 0, 68,}
-	,
-	{7, 0, 30, 0, 67,}
-	,
-	{7, 0, 29, 0, 68,}
-	,
-	{7, 0, 28, 0, 68,}
-	,
-	{7, 0, 27, 0, 69,}
-	,
-	{7, 0, 26, 0, 70,}
-	,
-	{7, 0, 25, 0, 70,}
-	,
-	{7, 0, 24, 0, 71,}
-	,
-	{7, 0, 23, 0, 72,}
-	,
-	{7, 0, 23, 0, 70,}
-	,
-	{7, 0, 22, 0, 71,}
-	,
-	{7, 0, 21, 0, 72,}
-	,
-	{7, 0, 21, 0, 70,}
-	,
-	{7, 0, 21, 0, 68,}
-	,
-	{7, 0, 21, 0, 66,}
-	,
-	{7, 0, 21, 0, 64,}
-	,
-	{7, 0, 21, 0, 63,}
-	,
-	{7, 0, 20, 0, 64,}
-	,
-	{7, 0, 19, 0, 65,}
-	,
-	{7, 0, 19, 0, 64,}
-	,
-	{7, 0, 18, 0, 65,}
-	,
-	{7, 0, 18, 0, 64,}
-	,
-	{7, 0, 17, 0, 65,}
-	,
-	{7, 0, 17, 0, 64,}
-	,
-	{7, 0, 16, 0, 65,}
-	,
-	{7, 0, 16, 0, 64,}
-	,
-	{7, 0, 16, 0, 62,}
-	,
-	{7, 0, 16, 0, 60,}
-	,
-	{7, 0, 16, 0, 58,}
-	,
-	{7, 0, 15, 0, 61,}
-	,
-	{7, 0, 15, 0, 59,}
-	,
-	{7, 0, 14, 0, 61,}
-	,
-	{7, 0, 14, 0, 60,}
-	,
-	{7, 0, 14, 0, 58,}
-	,
-	{7, 0, 13, 0, 60,}
-	,
-	{7, 0, 13, 0, 59,}
-	,
-	{7, 0, 12, 0, 62,}
-	,
-	{7, 0, 12, 0, 60,}
-	,
-	{7, 0, 12, 0, 58,}
-	,
-	{7, 0, 11, 0, 62,}
-	,
-	{7, 0, 11, 0, 60,}
-	,
-	{7, 0, 11, 0, 59,}
-	,
-	{7, 0, 11, 0, 57,}
-	,
-	{7, 0, 10, 0, 61,}
-	,
-	{7, 0, 10, 0, 59,}
-	,
-	{7, 0, 10, 0, 57,}
-	,
-	{7, 0, 9, 0, 62,}
-	,
-	{7, 0, 9, 0, 60,}
-	,
-	{7, 0, 9, 0, 58,}
-	,
-	{7, 0, 9, 0, 57,}
-	,
-	{7, 0, 8, 0, 62,}
-	,
-	{7, 0, 8, 0, 60,}
-	,
-	{7, 0, 8, 0, 58,}
-	,
-	{7, 0, 8, 0, 57,}
-	,
-	{7, 0, 8, 0, 55,}
-	,
-	{7, 0, 7, 0, 61,}
-	,
-	{7, 0, 7, 0, 60,}
-	,
-	{7, 0, 7, 0, 58,}
-	,
-	{7, 0, 7, 0, 56,}
-	,
-	{7, 0, 7, 0, 55,}
-	,
-	{7, 0, 6, 0, 62,}
-	,
-	{7, 0, 6, 0, 60,}
-	,
-	{7, 0, 6, 0, 58,}
-	,
-	{7, 0, 6, 0, 57,}
-	,
-	{7, 0, 6, 0, 55,}
-	,
-	{7, 0, 6, 0, 54,}
-	,
-	{7, 0, 6, 0, 52,}
-	,
-	{7, 0, 5, 0, 61,}
-	,
-	{7, 0, 5, 0, 59,}
-	,
-	{7, 0, 5, 0, 57,}
-	,
-	{7, 0, 5, 0, 56,}
-	,
-	{7, 0, 5, 0, 54,}
-	,
-	{7, 0, 5, 0, 53,}
-	,
-	{7, 0, 5, 0, 51,}
-	,
-	{7, 0, 4, 0, 62,}
-	,
-	{7, 0, 4, 0, 60,}
-	,
-	{7, 0, 4, 0, 58,}
-	,
-	{7, 0, 4, 0, 57,}
-	,
-	{7, 0, 4, 0, 55,}
-	,
-	{7, 0, 4, 0, 54,}
-	,
-	{7, 0, 4, 0, 52,}
-	,
-	{7, 0, 4, 0, 51,}
-	,
-	{7, 0, 4, 0, 49,}
-	,
-	{7, 0, 4, 0, 48,}
-	,
-	{7, 0, 4, 0, 46,}
-	,
-	{7, 0, 3, 0, 60,}
-	,
-	{7, 0, 3, 0, 58,}
-	,
-	{7, 0, 3, 0, 57,}
-	,
-	{7, 0, 3, 0, 55,}
-	,
-	{7, 0, 3, 0, 54,}
-	,
-	{7, 0, 3, 0, 52,}
-	,
-	{7, 0, 3, 0, 51,}
-	,
-	{7, 0, 3, 0, 49,}
-	,
-	{7, 0, 3, 0, 48,}
-	,
-	{7, 0, 3, 0, 46,}
-	,
-	{7, 0, 3, 0, 45,}
-	,
-	{7, 0, 3, 0, 44,}
-	,
-	{7, 0, 3, 0, 43,}
-	,
-	{7, 0, 3, 0, 41,}
-	,
-	{7, 0, 2, 0, 61,}
-	,
-	{7, 0, 2, 0, 59,}
-	,
-	{7, 0, 2, 0, 57,}
-	,
-	{7, 0, 2, 0, 56,}
-	,
-	{7, 0, 2, 0, 54,}
-	,
-	{7, 0, 2, 0, 53,}
-	,
-	{7, 0, 2, 0, 51,}
-	,
-	{7, 0, 2, 0, 50,}
-	,
-	{7, 0, 2, 0, 48,}
-	,
-	{7, 0, 2, 0, 47,}
-	,
-	{7, 0, 2, 0, 46,}
-	,
-	{7, 0, 2, 0, 44,}
-	,
-	{7, 0, 2, 0, 43,}
-	,
-	{7, 0, 2, 0, 42,}
-	,
-	{7, 0, 2, 0, 41,}
-	,
-	{7, 0, 2, 0, 39,}
-	,
-	{7, 0, 2, 0, 38,}
-	,
-	{7, 0, 2, 0, 37,}
-	,
-	{7, 0, 2, 0, 36,}
-	,
-	{7, 0, 2, 0, 35,}
-	,
-	{7, 0, 2, 0, 34,}
-	,
-	{7, 0, 2, 0, 33,}
-	,
-	{7, 0, 2, 0, 32,}
-	,
-	{7, 0, 1, 0, 63,}
-	,
-	{7, 0, 1, 0, 61,}
-	,
-	{7, 0, 1, 0, 59,}
-	,
-	{7, 0, 1, 0, 57,}
-	,
+	{7, 0, 31, 0, 72},
+	{7, 0, 31, 0, 70},
+	{7, 0, 31, 0, 68},
+	{7, 0, 30, 0, 67},
+	{7, 0, 29, 0, 68},
+	{7, 0, 28, 0, 68},
+	{7, 0, 27, 0, 69},
+	{7, 0, 26, 0, 70},
+	{7, 0, 25, 0, 70},
+	{7, 0, 24, 0, 71},
+	{7, 0, 23, 0, 72},
+	{7, 0, 23, 0, 70},
+	{7, 0, 22, 0, 71},
+	{7, 0, 21, 0, 72},
+	{7, 0, 21, 0, 70},
+	{7, 0, 21, 0, 68},
+	{7, 0, 21, 0, 66},
+	{7, 0, 21, 0, 64},
+	{7, 0, 21, 0, 63},
+	{7, 0, 20, 0, 64},
+	{7, 0, 19, 0, 65},
+	{7, 0, 19, 0, 64},
+	{7, 0, 18, 0, 65},
+	{7, 0, 18, 0, 64},
+	{7, 0, 17, 0, 65},
+	{7, 0, 17, 0, 64},
+	{7, 0, 16, 0, 65},
+	{7, 0, 16, 0, 64},
+	{7, 0, 16, 0, 62},
+	{7, 0, 16, 0, 60},
+	{7, 0, 16, 0, 58},
+	{7, 0, 15, 0, 61},
+	{7, 0, 15, 0, 59},
+	{7, 0, 14, 0, 61},
+	{7, 0, 14, 0, 60},
+	{7, 0, 14, 0, 58},
+	{7, 0, 13, 0, 60},
+	{7, 0, 13, 0, 59},
+	{7, 0, 12, 0, 62},
+	{7, 0, 12, 0, 60},
+	{7, 0, 12, 0, 58},
+	{7, 0, 11, 0, 62},
+	{7, 0, 11, 0, 60},
+	{7, 0, 11, 0, 59},
+	{7, 0, 11, 0, 57},
+	{7, 0, 10, 0, 61},
+	{7, 0, 10, 0, 59},
+	{7, 0, 10, 0, 57},
+	{7, 0, 9, 0, 62},
+	{7, 0, 9, 0, 60},
+	{7, 0, 9, 0, 58},
+	{7, 0, 9, 0, 57},
+	{7, 0, 8, 0, 62},
+	{7, 0, 8, 0, 60},
+	{7, 0, 8, 0, 58},
+	{7, 0, 8, 0, 57},
+	{7, 0, 8, 0, 55},
+	{7, 0, 7, 0, 61},
+	{7, 0, 7, 0, 60},
+	{7, 0, 7, 0, 58},
+	{7, 0, 7, 0, 56},
+	{7, 0, 7, 0, 55},
+	{7, 0, 6, 0, 62},
+	{7, 0, 6, 0, 60},
+	{7, 0, 6, 0, 58},
+	{7, 0, 6, 0, 57},
+	{7, 0, 6, 0, 55},
+	{7, 0, 6, 0, 54},
+	{7, 0, 6, 0, 52},
+	{7, 0, 5, 0, 61},
+	{7, 0, 5, 0, 59},
+	{7, 0, 5, 0, 57},
+	{7, 0, 5, 0, 56},
+	{7, 0, 5, 0, 54},
+	{7, 0, 5, 0, 53},
+	{7, 0, 5, 0, 51},
+	{7, 0, 4, 0, 62},
+	{7, 0, 4, 0, 60},
+	{7, 0, 4, 0, 58},
+	{7, 0, 4, 0, 57},
+	{7, 0, 4, 0, 55},
+	{7, 0, 4, 0, 54},
+	{7, 0, 4, 0, 52},
+	{7, 0, 4, 0, 51},
+	{7, 0, 4, 0, 49},
+	{7, 0, 4, 0, 48},
+	{7, 0, 4, 0, 46},
+	{7, 0, 3, 0, 60},
+	{7, 0, 3, 0, 58},
+	{7, 0, 3, 0, 57},
+	{7, 0, 3, 0, 55},
+	{7, 0, 3, 0, 54},
+	{7, 0, 3, 0, 52},
+	{7, 0, 3, 0, 51},
+	{7, 0, 3, 0, 49},
+	{7, 0, 3, 0, 48},
+	{7, 0, 3, 0, 46},
+	{7, 0, 3, 0, 45},
+	{7, 0, 3, 0, 44},
+	{7, 0, 3, 0, 43},
+	{7, 0, 3, 0, 41},
+	{7, 0, 2, 0, 61},
+	{7, 0, 2, 0, 59},
+	{7, 0, 2, 0, 57},
+	{7, 0, 2, 0, 56},
+	{7, 0, 2, 0, 54},
+	{7, 0, 2, 0, 53},
+	{7, 0, 2, 0, 51},
+	{7, 0, 2, 0, 50},
+	{7, 0, 2, 0, 48},
+	{7, 0, 2, 0, 47},
+	{7, 0, 2, 0, 46},
+	{7, 0, 2, 0, 44},
+	{7, 0, 2, 0, 43},
+	{7, 0, 2, 0, 42},
+	{7, 0, 2, 0, 41},
+	{7, 0, 2, 0, 39},
+	{7, 0, 2, 0, 38},
+	{7, 0, 2, 0, 37},
+	{7, 0, 2, 0, 36},
+	{7, 0, 2, 0, 35},
+	{7, 0, 2, 0, 34},
+	{7, 0, 2, 0, 33},
+	{7, 0, 2, 0, 32},
+	{7, 0, 1, 0, 63},
+	{7, 0, 1, 0, 61},
+	{7, 0, 1, 0, 59},
+	{7, 0, 1, 0, 57},
 };
 
 const struct lcnphy_tx_gain_tbl_entry dot11lcnphy_5GHz_gaintable_rev0[128] = {
-	{255, 255, 0xf0, 0, 152,}
-	,
-	{255, 255, 0xf0, 0, 147,}
-	,
-	{255, 255, 0xf0, 0, 143,}
-	,
-	{255, 255, 0xf0, 0, 139,}
-	,
-	{255, 255, 0xf0, 0, 135,}
-	,
-	{255, 255, 0xf0, 0, 131,}
-	,
-	{255, 255, 0xf0, 0, 128,}
-	,
-	{255, 255, 0xf0, 0, 124,}
-	,
-	{255, 255, 0xf0, 0, 121,}
-	,
-	{255, 255, 0xf0, 0, 117,}
-	,
-	{255, 255, 0xf0, 0, 114,}
-	,
-	{255, 255, 0xf0, 0, 111,}
-	,
-	{255, 255, 0xf0, 0, 107,}
-	,
-	{255, 255, 0xf0, 0, 104,}
-	,
-	{255, 255, 0xf0, 0, 101,}
-	,
-	{255, 255, 0xf0, 0, 99,}
-	,
-	{255, 255, 0xf0, 0, 96,}
-	,
-	{255, 255, 0xf0, 0, 93,}
-	,
-	{255, 255, 0xf0, 0, 90,}
-	,
-	{255, 255, 0xf0, 0, 88,}
-	,
-	{255, 255, 0xf0, 0, 85,}
-	,
-	{255, 255, 0xf0, 0, 83,}
-	,
-	{255, 255, 0xf0, 0, 81,}
-	,
-	{255, 255, 0xf0, 0, 78,}
-	,
-	{255, 255, 0xf0, 0, 76,}
-	,
-	{255, 255, 0xf0, 0, 74,}
-	,
-	{255, 255, 0xf0, 0, 72,}
-	,
-	{255, 255, 0xf0, 0, 70,}
-	,
-	{255, 255, 0xf0, 0, 68,}
-	,
-	{255, 255, 0xf0, 0, 66,}
-	,
-	{255, 255, 0xf0, 0, 64,}
-	,
-	{255, 248, 0xf0, 0, 64,}
-	,
-	{255, 241, 0xf0, 0, 64,}
-	,
-	{255, 251, 0xe0, 0, 64,}
-	,
-	{255, 244, 0xe0, 0, 64,}
-	,
-	{255, 254, 0xd0, 0, 64,}
-	,
-	{255, 246, 0xd0, 0, 64,}
-	,
-	{255, 239, 0xd0, 0, 64,}
-	,
-	{255, 249, 0xc0, 0, 64,}
-	,
-	{255, 242, 0xc0, 0, 64,}
-	,
-	{255, 255, 0xb0, 0, 64,}
-	,
-	{255, 248, 0xb0, 0, 64,}
-	,
-	{255, 241, 0xb0, 0, 64,}
-	,
-	{255, 254, 0xa0, 0, 64,}
-	,
-	{255, 246, 0xa0, 0, 64,}
-	,
-	{255, 239, 0xa0, 0, 64,}
-	,
-	{255, 255, 0x90, 0, 64,}
-	,
-	{255, 248, 0x90, 0, 64,}
-	,
-	{255, 241, 0x90, 0, 64,}
-	,
-	{255, 234, 0x90, 0, 64,}
-	,
-	{255, 255, 0x80, 0, 64,}
-	,
-	{255, 248, 0x80, 0, 64,}
-	,
-	{255, 241, 0x80, 0, 64,}
-	,
-	{255, 234, 0x80, 0, 64,}
-	,
-	{255, 255, 0x70, 0, 64,}
-	,
-	{255, 248, 0x70, 0, 64,}
-	,
-	{255, 241, 0x70, 0, 64,}
-	,
-	{255, 234, 0x70, 0, 64,}
-	,
-	{255, 227, 0x70, 0, 64,}
-	,
-	{255, 221, 0x70, 0, 64,}
-	,
-	{255, 215, 0x70, 0, 64,}
-	,
-	{255, 208, 0x70, 0, 64,}
-	,
-	{255, 203, 0x70, 0, 64,}
-	,
-	{255, 197, 0x70, 0, 64,}
-	,
-	{255, 255, 0x60, 0, 64,}
-	,
-	{255, 248, 0x60, 0, 64,}
-	,
-	{255, 241, 0x60, 0, 64,}
-	,
-	{255, 234, 0x60, 0, 64,}
-	,
-	{255, 227, 0x60, 0, 64,}
-	,
-	{255, 221, 0x60, 0, 64,}
-	,
-	{255, 255, 0x50, 0, 64,}
-	,
-	{255, 248, 0x50, 0, 64,}
-	,
-	{255, 241, 0x50, 0, 64,}
-	,
-	{255, 234, 0x50, 0, 64,}
-	,
-	{255, 227, 0x50, 0, 64,}
-	,
-	{255, 221, 0x50, 0, 64,}
-	,
-	{255, 215, 0x50, 0, 64,}
-	,
-	{255, 208, 0x50, 0, 64,}
-	,
-	{255, 255, 0x40, 0, 64,}
-	,
-	{255, 248, 0x40, 0, 64,}
-	,
-	{255, 241, 0x40, 0, 64,}
-	,
-	{255, 234, 0x40, 0, 64,}
-	,
-	{255, 227, 0x40, 0, 64,}
-	,
-	{255, 221, 0x40, 0, 64,}
-	,
-	{255, 215, 0x40, 0, 64,}
-	,
-	{255, 208, 0x40, 0, 64,}
-	,
-	{255, 203, 0x40, 0, 64,}
-	,
-	{255, 197, 0x40, 0, 64,}
-	,
-	{255, 255, 0x30, 0, 64,}
-	,
-	{255, 248, 0x30, 0, 64,}
-	,
-	{255, 241, 0x30, 0, 64,}
-	,
-	{255, 234, 0x30, 0, 64,}
-	,
-	{255, 227, 0x30, 0, 64,}
-	,
-	{255, 221, 0x30, 0, 64,}
-	,
-	{255, 215, 0x30, 0, 64,}
-	,
-	{255, 208, 0x30, 0, 64,}
-	,
-	{255, 203, 0x30, 0, 64,}
-	,
-	{255, 197, 0x30, 0, 64,}
-	,
-	{255, 191, 0x30, 0, 64,}
-	,
-	{255, 186, 0x30, 0, 64,}
-	,
-	{255, 181, 0x30, 0, 64,}
-	,
-	{255, 175, 0x30, 0, 64,}
-	,
-	{255, 255, 0x20, 0, 64,}
-	,
-	{255, 248, 0x20, 0, 64,}
-	,
-	{255, 241, 0x20, 0, 64,}
-	,
-	{255, 234, 0x20, 0, 64,}
-	,
-	{255, 227, 0x20, 0, 64,}
-	,
-	{255, 221, 0x20, 0, 64,}
-	,
-	{255, 215, 0x20, 0, 64,}
-	,
-	{255, 208, 0x20, 0, 64,}
-	,
-	{255, 203, 0x20, 0, 64,}
-	,
-	{255, 197, 0x20, 0, 64,}
-	,
-	{255, 191, 0x20, 0, 64,}
-	,
-	{255, 186, 0x20, 0, 64,}
-	,
-	{255, 181, 0x20, 0, 64,}
-	,
-	{255, 175, 0x20, 0, 64,}
-	,
-	{255, 170, 0x20, 0, 64,}
-	,
-	{255, 166, 0x20, 0, 64,}
-	,
-	{255, 161, 0x20, 0, 64,}
-	,
-	{255, 156, 0x20, 0, 64,}
-	,
-	{255, 152, 0x20, 0, 64,}
-	,
-	{255, 148, 0x20, 0, 64,}
-	,
-	{255, 143, 0x20, 0, 64,}
-	,
-	{255, 139, 0x20, 0, 64,}
-	,
-	{255, 135, 0x20, 0, 64,}
-	,
-	{255, 132, 0x20, 0, 64,}
-	,
-	{255, 255, 0x10, 0, 64,}
-	,
-	{255, 248, 0x10, 0, 64,}
-	,
+	{255, 255, 0xf0, 0, 152},
+	{255, 255, 0xf0, 0, 147},
+	{255, 255, 0xf0, 0, 143},
+	{255, 255, 0xf0, 0, 139},
+	{255, 255, 0xf0, 0, 135},
+	{255, 255, 0xf0, 0, 131},
+	{255, 255, 0xf0, 0, 128},
+	{255, 255, 0xf0, 0, 124},
+	{255, 255, 0xf0, 0, 121},
+	{255, 255, 0xf0, 0, 117},
+	{255, 255, 0xf0, 0, 114},
+	{255, 255, 0xf0, 0, 111},
+	{255, 255, 0xf0, 0, 107},
+	{255, 255, 0xf0, 0, 104},
+	{255, 255, 0xf0, 0, 101},
+	{255, 255, 0xf0, 0, 99},
+	{255, 255, 0xf0, 0, 96},
+	{255, 255, 0xf0, 0, 93},
+	{255, 255, 0xf0, 0, 90},
+	{255, 255, 0xf0, 0, 88},
+	{255, 255, 0xf0, 0, 85},
+	{255, 255, 0xf0, 0, 83},
+	{255, 255, 0xf0, 0, 81},
+	{255, 255, 0xf0, 0, 78},
+	{255, 255, 0xf0, 0, 76},
+	{255, 255, 0xf0, 0, 74},
+	{255, 255, 0xf0, 0, 72},
+	{255, 255, 0xf0, 0, 70},
+	{255, 255, 0xf0, 0, 68},
+	{255, 255, 0xf0, 0, 66},
+	{255, 255, 0xf0, 0, 64},
+	{255, 248, 0xf0, 0, 64},
+	{255, 241, 0xf0, 0, 64},
+	{255, 251, 0xe0, 0, 64},
+	{255, 244, 0xe0, 0, 64},
+	{255, 254, 0xd0, 0, 64},
+	{255, 246, 0xd0, 0, 64},
+	{255, 239, 0xd0, 0, 64},
+	{255, 249, 0xc0, 0, 64},
+	{255, 242, 0xc0, 0, 64},
+	{255, 255, 0xb0, 0, 64},
+	{255, 248, 0xb0, 0, 64},
+	{255, 241, 0xb0, 0, 64},
+	{255, 254, 0xa0, 0, 64},
+	{255, 246, 0xa0, 0, 64},
+	{255, 239, 0xa0, 0, 64},
+	{255, 255, 0x90, 0, 64},
+	{255, 248, 0x90, 0, 64},
+	{255, 241, 0x90, 0, 64},
+	{255, 234, 0x90, 0, 64},
+	{255, 255, 0x80, 0, 64},
+	{255, 248, 0x80, 0, 64},
+	{255, 241, 0x80, 0, 64},
+	{255, 234, 0x80, 0, 64},
+	{255, 255, 0x70, 0, 64},
+	{255, 248, 0x70, 0, 64},
+	{255, 241, 0x70, 0, 64},
+	{255, 234, 0x70, 0, 64},
+	{255, 227, 0x70, 0, 64},
+	{255, 221, 0x70, 0, 64},
+	{255, 215, 0x70, 0, 64},
+	{255, 208, 0x70, 0, 64},
+	{255, 203, 0x70, 0, 64},
+	{255, 197, 0x70, 0, 64},
+	{255, 255, 0x60, 0, 64},
+	{255, 248, 0x60, 0, 64},
+	{255, 241, 0x60, 0, 64},
+	{255, 234, 0x60, 0, 64},
+	{255, 227, 0x60, 0, 64},
+	{255, 221, 0x60, 0, 64},
+	{255, 255, 0x50, 0, 64},
+	{255, 248, 0x50, 0, 64},
+	{255, 241, 0x50, 0, 64},
+	{255, 234, 0x50, 0, 64},
+	{255, 227, 0x50, 0, 64},
+	{255, 221, 0x50, 0, 64},
+	{255, 215, 0x50, 0, 64},
+	{255, 208, 0x50, 0, 64},
+	{255, 255, 0x40, 0, 64},
+	{255, 248, 0x40, 0, 64},
+	{255, 241, 0x40, 0, 64},
+	{255, 234, 0x40, 0, 64},
+	{255, 227, 0x40, 0, 64},
+	{255, 221, 0x40, 0, 64},
+	{255, 215, 0x40, 0, 64},
+	{255, 208, 0x40, 0, 64},
+	{255, 203, 0x40, 0, 64},
+	{255, 197, 0x40, 0, 64},
+	{255, 255, 0x30, 0, 64},
+	{255, 248, 0x30, 0, 64},
+	{255, 241, 0x30, 0, 64},
+	{255, 234, 0x30, 0, 64},
+	{255, 227, 0x30, 0, 64},
+	{255, 221, 0x30, 0, 64},
+	{255, 215, 0x30, 0, 64},
+	{255, 208, 0x30, 0, 64},
+	{255, 203, 0x30, 0, 64},
+	{255, 197, 0x30, 0, 64},
+	{255, 191, 0x30, 0, 64},
+	{255, 186, 0x30, 0, 64},
+	{255, 181, 0x30, 0, 64},
+	{255, 175, 0x30, 0, 64},
+	{255, 255, 0x20, 0, 64},
+	{255, 248, 0x20, 0, 64},
+	{255, 241, 0x20, 0, 64},
+	{255, 234, 0x20, 0, 64},
+	{255, 227, 0x20, 0, 64},
+	{255, 221, 0x20, 0, 64},
+	{255, 215, 0x20, 0, 64},
+	{255, 208, 0x20, 0, 64},
+	{255, 203, 0x20, 0, 64},
+	{255, 197, 0x20, 0, 64},
+	{255, 191, 0x20, 0, 64},
+	{255, 186, 0x20, 0, 64},
+	{255, 181, 0x20, 0, 64},
+	{255, 175, 0x20, 0, 64},
+	{255, 170, 0x20, 0, 64},
+	{255, 166, 0x20, 0, 64},
+	{255, 161, 0x20, 0, 64},
+	{255, 156, 0x20, 0, 64},
+	{255, 152, 0x20, 0, 64},
+	{255, 148, 0x20, 0, 64},
+	{255, 143, 0x20, 0, 64},
+	{255, 139, 0x20, 0, 64},
+	{255, 135, 0x20, 0, 64},
+	{255, 132, 0x20, 0, 64},
+	{255, 255, 0x10, 0, 64},
+	{255, 248, 0x10, 0, 64},
 };
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.c
index 7f741f4..d1455ae 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.c
@@ -4522,7 +4522,8 @@ const struct phytbl_info mimophytbl_info_rev0[] = {
 	{&chanest_tbl_rev0,
 	 sizeof(chanest_tbl_rev0) / sizeof(chanest_tbl_rev0[0]), 22, 0, 32}
 	,
-	{&mcs_tbl_rev0, sizeof(mcs_tbl_rev0) / sizeof(mcs_tbl_rev0[0]), 18, 0, 8}
+	{&mcs_tbl_rev0, sizeof(mcs_tbl_rev0) / sizeof(mcs_tbl_rev0[0]), 18, 0,
+	 8}
 	,
 	{&noise_var_tbl0_rev0,
 	 sizeof(noise_var_tbl0_rev0) / sizeof(noise_var_tbl0_rev0[0]), 16, 0,
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.h b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.h
index c5266cf..dc8a84e 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.h
@@ -20,21 +20,31 @@
 #include "phy_int.h"
 
 extern const struct phytbl_info mimophytbl_info_rev0[],
-	mimophytbl_info_rev0_volatile[];
-extern const u32 mimophytbl_info_sz_rev0, mimophytbl_info_sz_rev0_volatile;
+				mimophytbl_info_rev0_volatile[];
+
+extern const u32 mimophytbl_info_sz_rev0,
+		 mimophytbl_info_sz_rev0_volatile;
 
 extern const struct phytbl_info mimophytbl_info_rev3[],
-	mimophytbl_info_rev3_volatile[], mimophytbl_info_rev3_volatile1[],
-	mimophytbl_info_rev3_volatile2[], mimophytbl_info_rev3_volatile3[];
-extern const u32 mimophytbl_info_sz_rev3, mimophytbl_info_sz_rev3_volatile,
-	mimophytbl_info_sz_rev3_volatile1, mimophytbl_info_sz_rev3_volatile2,
-	mimophytbl_info_sz_rev3_volatile3;
+				mimophytbl_info_rev3_volatile[],
+				mimophytbl_info_rev3_volatile1[],
+				mimophytbl_info_rev3_volatile2[],
+				mimophytbl_info_rev3_volatile3[];
+
+extern const u32 mimophytbl_info_sz_rev3,
+		 mimophytbl_info_sz_rev3_volatile,
+		 mimophytbl_info_sz_rev3_volatile1,
+		 mimophytbl_info_sz_rev3_volatile2,
+		 mimophytbl_info_sz_rev3_volatile3;
 
 extern const u32 noise_var_tbl_rev3[];
 
 extern const struct phytbl_info mimophytbl_info_rev7[];
+
 extern const u32 mimophytbl_info_sz_rev7;
+
 extern const u32 noise_var_tbl_rev7[];
 
 extern const struct phytbl_info mimophytbl_info_rev16[];
+
 extern const u32 mimophytbl_info_sz_rev16;
-- 
1.7.4.1


