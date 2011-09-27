Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4735 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240Ab1I0Rpw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 13:45:52 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH v2 01/26] staging: brcm80211: remove uncoditional code
 blocks from brcmsmac
Date: Tue, 27 Sep 2011 10:45:05 -0700
Message-ID: <1317145530-18839-2-git-send-email-frankyl@broadcom.com> (sfid-20110927_194601_087355_938A785B)
In-Reply-To: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>
References: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Using a block statement to scope function variables is not
common in linux kernel development. Browsed through the brcmsmac
to remove those.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c        |    9 +--
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |   31 +++----
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c |  106 ++++++++++------------
 3 files changed, 63 insertions(+), 83 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 2c9ac6d..d6b43ff 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -5076,7 +5076,7 @@ brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 {
 	struct brcms_c_info *wlc;
 	uint err = 0;
-	uint j;
+	uint i, j;
 	struct brcms_pub *pub;
 	uint n_disabled;
 
@@ -5149,11 +5149,8 @@ brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 			       wlc->stf->hw_rxchain);
 
 	/* pull up some info resulting from the low attach */
-	{
-		int i;
-		for (i = 0; i < NFIFO; i++)
-			wlc->core->txavail[i] = wlc->hw->txavail[i];
-	}
+	for (i = 0; i < NFIFO; i++)
+		wlc->core->txavail[i] = wlc->hw->txavail[i];
 
 	brcms_b_hw_etheraddr(wlc->hw, wlc->perm_etheraddr);
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index 196a595..a26c682 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -1199,12 +1199,7 @@ static bool wlc_phy_cal_txpower_recalc_sw(struct brcms_phy *pi)
 void wlc_phy_switch_radio(struct brcms_phy_pub *pih, bool on)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
-
-	{
-		uint mc;
-
-		mc = R_REG(&pi->regs->maccontrol);
-	}
+	(void)R_REG(&pi->regs->maccontrol);
 
 	if (ISNPHY(pi)) {
 		wlc_phy_switch_radio_nphy(pi, on);
@@ -1696,26 +1691,22 @@ void wlc_phy_txpower_recalc_target(struct brcms_phy *pi)
 								 band,
 								 rate);
 
-		{
-
-			wlc_phy_txpower_sromlimit((struct brcms_phy_pub *) pi,
-						  target_chan,
-						  &mintxpwr, &maxtxpwr, rate);
+		wlc_phy_txpower_sromlimit((struct brcms_phy_pub *) pi,
+					  target_chan,
+					  &mintxpwr, &maxtxpwr, rate);
 
-			maxtxpwr = min(maxtxpwr, pi->txpwr_limit[rate]);
+		maxtxpwr = min(maxtxpwr, pi->txpwr_limit[rate]);
 
-			maxtxpwr =
-				(maxtxpwr > pactrl) ? (maxtxpwr - pactrl) : 0;
+		maxtxpwr = (maxtxpwr > pactrl) ? (maxtxpwr - pactrl) : 0;
 
-			maxtxpwr = (maxtxpwr > 6) ? (maxtxpwr - 6) : 0;
+		maxtxpwr = (maxtxpwr > 6) ? (maxtxpwr - 6) : 0;
 
-			maxtxpwr = min(maxtxpwr, tx_pwr_target[rate]);
+		maxtxpwr = min(maxtxpwr, tx_pwr_target[rate]);
 
-			if (pi->txpwr_percent <= 100)
-				maxtxpwr = (maxtxpwr * pi->txpwr_percent) / 100;
+		if (pi->txpwr_percent <= 100)
+			maxtxpwr = (maxtxpwr * pi->txpwr_percent) / 100;
 
-			tx_pwr_target[rate] = max(maxtxpwr, mintxpwr);
-		}
+		tx_pwr_target[rate] = max(maxtxpwr, mintxpwr);
 
 		tx_pwr_target[rate] =
 			min(tx_pwr_target[rate], pi->txpwr_env_limit[rate]);
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
index 46661b8..fdcea56 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -69,6 +69,14 @@
 #define LCN_TEMPSENSE_OFFSET  80812
 #define LCN_TEMPSENSE_DEN  2647
 
+#define LCN_BW_LMT	200
+#define LCN_CUR_LMT	1250
+#define LCN_MULT	1
+#define LCN_VCO_DIV	30
+#define LCN_OFFSET	680
+#define LCN_FACT	490
+#define LCN_CUR_DIV	2640
+
 #define LCNPHY_txgainctrlovrval1_pagain_ovr_val1_SHIFT \
 	(0 + 8)
 #define LCNPHY_txgainctrlovrval1_pagain_ovr_val1_MASK \
@@ -1054,21 +1062,17 @@ static int wlc_lcnphy_calc_floor(s16 coeff_x, int type)
 static void
 wlc_lcnphy_get_tx_gain(struct brcms_phy *pi, struct lcnphy_txgains *gains)
 {
-	u16 dac_gain;
+	u16 dac_gain, rfgain0, rfgain1;
 
 	dac_gain = read_phy_reg(pi, 0x439) >> 0;
 	gains->dac_gain = (dac_gain & 0x380) >> 7;
 
-	{
-		u16 rfgain0, rfgain1;
-
-		rfgain0 = (read_phy_reg(pi, 0x4b5) & (0xffff << 0)) >> 0;
-		rfgain1 = (read_phy_reg(pi, 0x4fb) & (0x7fff << 0)) >> 0;
+	rfgain0 = (read_phy_reg(pi, 0x4b5) & (0xffff << 0)) >> 0;
+	rfgain1 = (read_phy_reg(pi, 0x4fb) & (0x7fff << 0)) >> 0;
 
-		gains->gm_gain = rfgain0 & 0xff;
-		gains->pga_gain = (rfgain0 >> 8) & 0xff;
-		gains->pad_gain = rfgain1 & 0xff;
-	}
+	gains->gm_gain = rfgain0 & 0xff;
+	gains->pga_gain = (rfgain0 >> 8) & 0xff;
+	gains->pad_gain = rfgain1 & 0xff;
 }
 
 
@@ -1634,6 +1638,9 @@ wlc_lcnphy_radio_2064_channel_tune_4313(struct brcms_phy *pi, u8 channel)
 	u32 div_int, div_frac, fvco3, fpfd, fref3, fcal_div;
 	u16 loop_bw, d30, setCount;
 
+	u8 h29, h28_ten, e30, h30_ten, cp_current;
+	u16 g30, d28;
+
 	ci = &chan_info_2064_lcnphy[0];
 	rfpll_doubler = 1;
 
@@ -1746,27 +1753,18 @@ wlc_lcnphy_radio_2064_channel_tune_4313(struct brcms_phy *pi, u8 channel)
 	write_radio_reg(pi, RADIO_2064_REG042, 0xA3);
 	write_radio_reg(pi, RADIO_2064_REG043, 0x0C);
 
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
+	h29 = LCN_BW_LMT / loop_bw;
+	d28 = (((PLL_2064_HIGH_END_KVCO - PLL_2064_LOW_END_KVCO) *
+		(fvco3 / 2 - PLL_2064_LOW_END_VCO)) /
+	       (PLL_2064_HIGH_END_VCO - PLL_2064_LOW_END_VCO))
+	      + PLL_2064_LOW_END_KVCO;
+	h28_ten = (d28 * 10) / LCN_VCO_DIV;
+	e30 = (d30 - LCN_OFFSET) / LCN_FACT;
+	g30 = LCN_OFFSET + (e30 * LCN_FACT);
+	h30_ten = (g30 * 10) / LCN_CUR_DIV;
+	cp_current = ((LCN_CUR_LMT * h29 * LCN_MULT * 100) / h28_ten) / h30_ten;
+	mod_radio_reg(pi, RADIO_2064_REG03C, 0x3f, cp_current);
+
 	if (channel >= 1 && channel <= 5)
 		write_radio_reg(pi, RADIO_2064_REG03C, 0x8);
 	else
@@ -4838,18 +4836,13 @@ static bool wlc_phy_txpwr_srom_read_lcnphy(struct brcms_phy *pi)
 		pi_lcn->lcnphy_rssi_vc = (u8) PHY_GETINTVAR(pi, "rssismc2g");
 		pi_lcn->lcnphy_rssi_gs = (u8) PHY_GETINTVAR(pi, "rssisav2g");
 
-		{
-			pi_lcn->lcnphy_rssi_vf_lowtemp = pi_lcn->lcnphy_rssi_vf;
-			pi_lcn->lcnphy_rssi_vc_lowtemp = pi_lcn->lcnphy_rssi_vc;
-			pi_lcn->lcnphy_rssi_gs_lowtemp = pi_lcn->lcnphy_rssi_gs;
-
-			pi_lcn->lcnphy_rssi_vf_hightemp =
-				pi_lcn->lcnphy_rssi_vf;
-			pi_lcn->lcnphy_rssi_vc_hightemp =
-				pi_lcn->lcnphy_rssi_vc;
-			pi_lcn->lcnphy_rssi_gs_hightemp =
-				pi_lcn->lcnphy_rssi_gs;
-		}
+		pi_lcn->lcnphy_rssi_vf_lowtemp = pi_lcn->lcnphy_rssi_vf;
+		pi_lcn->lcnphy_rssi_vc_lowtemp = pi_lcn->lcnphy_rssi_vc;
+		pi_lcn->lcnphy_rssi_gs_lowtemp = pi_lcn->lcnphy_rssi_gs;
+
+		pi_lcn->lcnphy_rssi_vf_hightemp = pi_lcn->lcnphy_rssi_vf;
+		pi_lcn->lcnphy_rssi_vc_hightemp = pi_lcn->lcnphy_rssi_vc;
+		pi_lcn->lcnphy_rssi_gs_hightemp = pi_lcn->lcnphy_rssi_gs;
 
 		txpwr = (s8) PHY_GETINTVAR(pi, "maxp2ga0");
 		pi->tx_srom_max_2g = txpwr;
@@ -5098,6 +5091,8 @@ s32 wlc_lcnphy_rx_signal_power(struct brcms_phy *pi, s32 gain_index)
 	s32 log_val, gain_mismatch, desired_gain, input_power_offset_db,
 	    input_power_db;
 	s32 received_power, temperature;
+	u32 power;
+	u32 msb1, msb2, val1, val2, diff1, diff2;
 	uint freq;
 	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
@@ -5107,20 +5102,17 @@ s32 wlc_lcnphy_rx_signal_power(struct brcms_phy *pi, s32 gain_index)
 
 	nominal_power_db = read_phy_reg(pi, 0x425) >> 8;
 
-	{
-		u32 power = (received_power * 16);
-		u32 msb1, msb2, val1, val2, diff1, diff2;
-		msb1 = ffs(power) - 1;
-		msb2 = msb1 + 1;
-		val1 = 1 << msb1;
-		val2 = 1 << msb2;
-		diff1 = (power - val1);
-		diff2 = (val2 - power);
-		if (diff1 < diff2)
-			log_val = msb1;
-		else
-			log_val = msb2;
-	}
+	power = (received_power * 16);
+	msb1 = ffs(power) - 1;
+	msb2 = msb1 + 1;
+	val1 = 1 << msb1;
+	val2 = 1 << msb2;
+	diff1 = (power - val1);
+	diff2 = (val2 - power);
+	if (diff1 < diff2)
+		log_val = msb1;
+	else
+		log_val = msb2;
 
 	log_val = log_val * 3;
 
-- 
1.7.1


