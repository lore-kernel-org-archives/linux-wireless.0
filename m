Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3811 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161014Ab3HJK2H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Aug 2013 06:28:07 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Piotr Haber" <phaber@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 12/12] brcmsmac: support 4313iPA
Date: Sat, 10 Aug 2013 12:27:30 +0200
Message-ID: <1376130450-29746-13-git-send-email-arend@broadcom.com> (sfid-20130810_122824_804598_4EFA9A40)
In-Reply-To: <1376130450-29746-1-git-send-email-arend@broadcom.com>
References: <1376130450-29746-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Piotr Haber <phaber@broadcom.com>

Add support for 4313 iPA variant.
It is a variant of already supported 4313 ePA,
so this patch adds the required PHY changes to
support it properly including an updated switch
control table for BT-combo card variants.

Tested-by: Maximilian Engelhardt <maxi@daemonizer.de>
Tested-by: David Costa <david@zarel.net>
Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c  | 399 +++++++++++++--------
 .../wireless/brcm80211/brcmsmac/phy/phytbl_lcn.c   | 289 +++++++++------
 .../wireless/brcm80211/brcmsmac/phy/phytbl_lcn.h   |   1 +
 3 files changed, 436 insertions(+), 253 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
index 3d6b16c..b8ddaad 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -1137,8 +1137,9 @@ wlc_lcnphy_set_rx_gain_by_distribution(struct brcms_phy *pi,
 	gain0_15 = ((biq1 & 0xf) << 12) |
 		   ((tia & 0xf) << 8) |
 		   ((lna2 & 0x3) << 6) |
-		   ((lna2 &
-		     0x3) << 4) | ((lna1 & 0x3) << 2) | ((lna1 & 0x3) << 0);
+		   ((lna2 & 0x3) << 4) |
+		   ((lna1 & 0x3) << 2) |
+		   ((lna1 & 0x3) << 0);
 
 	mod_phy_reg(pi, 0x4b6, (0xffff << 0), gain0_15 << 0);
 	mod_phy_reg(pi, 0x4b7, (0xf << 0), gain16_19 << 0);
@@ -1328,6 +1329,43 @@ static u32 wlc_lcnphy_measure_digital_power(struct brcms_phy *pi, u16 nsamples)
 	return (iq_est.i_pwr + iq_est.q_pwr) / nsamples;
 }
 
+static bool wlc_lcnphy_rx_iq_cal_gain(struct brcms_phy *pi, u16 biq1_gain,
+				      u16 tia_gain, u16 lna2_gain)
+{
+	u32 i_thresh_l, q_thresh_l;
+	u32 i_thresh_h, q_thresh_h;
+	struct lcnphy_iq_est iq_est_h, iq_est_l;
+
+	wlc_lcnphy_set_rx_gain_by_distribution(pi, 0, 0, 0, biq1_gain, tia_gain,
+					       lna2_gain, 0);
+
+	wlc_lcnphy_rx_gain_override_enable(pi, true);
+	wlc_lcnphy_start_tx_tone(pi, 2000, (40 >> 1), 0);
+	udelay(500);
+	write_radio_reg(pi, RADIO_2064_REG112, 0);
+	if (!wlc_lcnphy_rx_iq_est(pi, 1024, 32, &iq_est_l))
+		return false;
+
+	wlc_lcnphy_start_tx_tone(pi, 2000, 40, 0);
+	udelay(500);
+	write_radio_reg(pi, RADIO_2064_REG112, 0);
+	if (!wlc_lcnphy_rx_iq_est(pi, 1024, 32, &iq_est_h))
+		return false;
+
+	i_thresh_l = (iq_est_l.i_pwr << 1);
+	i_thresh_h = (iq_est_l.i_pwr << 2) + iq_est_l.i_pwr;
+
+	q_thresh_l = (iq_est_l.q_pwr << 1);
+	q_thresh_h = (iq_est_l.q_pwr << 2) + iq_est_l.q_pwr;
+	if ((iq_est_h.i_pwr > i_thresh_l) &&
+	    (iq_est_h.i_pwr < i_thresh_h) &&
+	    (iq_est_h.q_pwr > q_thresh_l) &&
+	    (iq_est_h.q_pwr < q_thresh_h))
+		return true;
+
+	return false;
+}
+
 static bool
 wlc_lcnphy_rx_iq_cal(struct brcms_phy *pi,
 		     const struct lcnphy_rx_iqcomp *iqcomp,
@@ -1342,8 +1380,8 @@ wlc_lcnphy_rx_iq_cal(struct brcms_phy *pi,
 	    RFOverrideVal0_old, rfoverride2_old, rfoverride2val_old,
 	    rfoverride3_old, rfoverride3val_old, rfoverride4_old,
 	    rfoverride4val_old, afectrlovr_old, afectrlovrval_old;
-	int tia_gain;
-	u32 received_power, rx_pwr_threshold;
+	int tia_gain, lna2_gain, biq1_gain;
+	bool set_gain;
 	u16 old_sslpnCalibClkEnCtrl, old_sslpnRxFeClkEnCtrl;
 	u16 values_to_save[11];
 	s16 *ptr;
@@ -1368,126 +1406,134 @@ wlc_lcnphy_rx_iq_cal(struct brcms_phy *pi,
 		goto cal_done;
 	}
 
-	if (module == 1) {
+	WARN_ON(module != 1);
+	tx_pwr_ctrl = wlc_lcnphy_get_tx_pwr_ctrl(pi);
+	wlc_lcnphy_set_tx_pwr_ctrl(pi, LCNPHY_TX_PWR_CTRL_OFF);
 
-		tx_pwr_ctrl = wlc_lcnphy_get_tx_pwr_ctrl(pi);
-		wlc_lcnphy_set_tx_pwr_ctrl(pi, LCNPHY_TX_PWR_CTRL_OFF);
+	for (i = 0; i < 11; i++)
+		values_to_save[i] =
+			read_radio_reg(pi, rxiq_cal_rf_reg[i]);
+	Core1TxControl_old = read_phy_reg(pi, 0x631);
+
+	or_phy_reg(pi, 0x631, 0x0015);
+
+	RFOverride0_old = read_phy_reg(pi, 0x44c);
+	RFOverrideVal0_old = read_phy_reg(pi, 0x44d);
+	rfoverride2_old = read_phy_reg(pi, 0x4b0);
+	rfoverride2val_old = read_phy_reg(pi, 0x4b1);
+	rfoverride3_old = read_phy_reg(pi, 0x4f9);
+	rfoverride3val_old = read_phy_reg(pi, 0x4fa);
+	rfoverride4_old = read_phy_reg(pi, 0x938);
+	rfoverride4val_old = read_phy_reg(pi, 0x939);
+	afectrlovr_old = read_phy_reg(pi, 0x43b);
+	afectrlovrval_old = read_phy_reg(pi, 0x43c);
+	old_sslpnCalibClkEnCtrl = read_phy_reg(pi, 0x6da);
+	old_sslpnRxFeClkEnCtrl = read_phy_reg(pi, 0x6db);
 
-		for (i = 0; i < 11; i++)
-			values_to_save[i] =
-				read_radio_reg(pi, rxiq_cal_rf_reg[i]);
-		Core1TxControl_old = read_phy_reg(pi, 0x631);
-
-		or_phy_reg(pi, 0x631, 0x0015);
-
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
-
-		tx_gain_override_old = wlc_lcnphy_tx_gain_override_enabled(pi);
-		if (tx_gain_override_old) {
-			wlc_lcnphy_get_tx_gain(pi, &old_gains);
-			tx_gain_index_old = pi_lcn->lcnphy_current_index;
-		}
+	tx_gain_override_old = wlc_lcnphy_tx_gain_override_enabled(pi);
+	if (tx_gain_override_old) {
+		wlc_lcnphy_get_tx_gain(pi, &old_gains);
+		tx_gain_index_old = pi_lcn->lcnphy_current_index;
+	}
 
-		wlc_lcnphy_set_tx_pwr_by_index(pi, tx_gain_idx);
+	wlc_lcnphy_set_tx_pwr_by_index(pi, tx_gain_idx);
 
-		mod_phy_reg(pi, 0x4f9, (0x1 << 0), 1 << 0);
-		mod_phy_reg(pi, 0x4fa, (0x1 << 0), 0 << 0);
+	mod_phy_reg(pi, 0x4f9, (0x1 << 0), 1 << 0);
+	mod_phy_reg(pi, 0x4fa, (0x1 << 0), 0 << 0);
 
-		mod_phy_reg(pi, 0x43b, (0x1 << 1), 1 << 1);
-		mod_phy_reg(pi, 0x43c, (0x1 << 1), 0 << 1);
+	mod_phy_reg(pi, 0x43b, (0x1 << 1), 1 << 1);
+	mod_phy_reg(pi, 0x43c, (0x1 << 1), 0 << 1);
 
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
-
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
-
-		mod_phy_reg(pi, 0x43b, (0x1 << 0), 1 << 0);
-		mod_phy_reg(pi, 0x43c, (0x1 << 0), 0 << 0);
-
-		wlc_lcnphy_start_tx_tone(pi, 2000, 120, 0);
-		write_phy_reg(pi, 0x6da, 0xffff);
-		or_phy_reg(pi, 0x6db, 0x3);
-		wlc_lcnphy_set_trsw_override(pi, tx_switch, rx_switch);
-		wlc_lcnphy_rx_gain_override_enable(pi, true);
-
-		tia_gain = 8;
-		rx_pwr_threshold = 950;
-		while (tia_gain > 0) {
-			tia_gain -= 1;
-			wlc_lcnphy_set_rx_gain_by_distribution(pi,
-							       0, 0, 2, 2,
-							       (u16)
-							       tia_gain, 1, 0);
-			udelay(500);
+	write_radio_reg(pi, RADIO_2064_REG116, 0x06);
+	write_radio_reg(pi, RADIO_2064_REG12C, 0x07);
+	write_radio_reg(pi, RADIO_2064_REG06A, 0xd3);
+	write_radio_reg(pi, RADIO_2064_REG098, 0x03);
+	write_radio_reg(pi, RADIO_2064_REG00B, 0x7);
+	mod_radio_reg(pi, RADIO_2064_REG113, 1 << 4, 1 << 4);
+	write_radio_reg(pi, RADIO_2064_REG01D, 0x01);
+	write_radio_reg(pi, RADIO_2064_REG114, 0x01);
+	write_radio_reg(pi, RADIO_2064_REG02E, 0x10);
+	write_radio_reg(pi, RADIO_2064_REG12A, 0x08);
+
+	mod_phy_reg(pi, 0x938, (0x1 << 0), 1 << 0);
+	mod_phy_reg(pi, 0x939, (0x1 << 0), 0 << 0);
+	mod_phy_reg(pi, 0x938, (0x1 << 1), 1 << 1);
+	mod_phy_reg(pi, 0x939, (0x1 << 1), 1 << 1);
+	mod_phy_reg(pi, 0x938, (0x1 << 2), 1 << 2);
+	mod_phy_reg(pi, 0x939, (0x1 << 2), 1 << 2);
+	mod_phy_reg(pi, 0x938, (0x1 << 3), 1 << 3);
+	mod_phy_reg(pi, 0x939, (0x1 << 3), 1 << 3);
+	mod_phy_reg(pi, 0x938, (0x1 << 5), 1 << 5);
+	mod_phy_reg(pi, 0x939, (0x1 << 5), 0 << 5);
 
-			received_power =
-				wlc_lcnphy_measure_digital_power(pi, 2000);
-			if (received_power < rx_pwr_threshold)
-				break;
+	mod_phy_reg(pi, 0x43b, (0x1 << 0), 1 << 0);
+	mod_phy_reg(pi, 0x43c, (0x1 << 0), 0 << 0);
+
+	write_phy_reg(pi, 0x6da, 0xffff);
+	or_phy_reg(pi, 0x6db, 0x3);
+
+	wlc_lcnphy_set_trsw_override(pi, tx_switch, rx_switch);
+	set_gain = false;
+
+	lna2_gain = 3;
+	while ((lna2_gain >= 0) && !set_gain) {
+		tia_gain = 4;
+
+		while ((tia_gain >= 0) && !set_gain) {
+			biq1_gain = 6;
+
+			while ((biq1_gain >= 0) && !set_gain) {
+				set_gain = wlc_lcnphy_rx_iq_cal_gain(pi,
+								     (u16)
+								     biq1_gain,
+								     (u16)
+								     tia_gain,
+								     (u16)
+								     lna2_gain);
+				biq1_gain -= 1;
+			}
+			tia_gain -= 1;
 		}
-		result = wlc_lcnphy_calc_rx_iq_comp(pi, 0xffff);
+		lna2_gain -= 1;
+	}
 
-		wlc_lcnphy_stop_tx_tone(pi);
+	if (set_gain)
+		result = wlc_lcnphy_calc_rx_iq_comp(pi, 1024);
+	else
+		result = false;
 
-		write_phy_reg(pi, 0x631, Core1TxControl_old);
+	wlc_lcnphy_stop_tx_tone(pi);
 
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
+	write_phy_reg(pi, 0x631, Core1TxControl_old);
+
+	write_phy_reg(pi, 0x44c, RFOverrideVal0_old);
+	write_phy_reg(pi, 0x44d, RFOverrideVal0_old);
+	write_phy_reg(pi, 0x4b0, rfoverride2_old);
+	write_phy_reg(pi, 0x4b1, rfoverride2val_old);
+	write_phy_reg(pi, 0x4f9, rfoverride3_old);
+	write_phy_reg(pi, 0x4fa, rfoverride3val_old);
+	write_phy_reg(pi, 0x938, rfoverride4_old);
+	write_phy_reg(pi, 0x939, rfoverride4val_old);
+	write_phy_reg(pi, 0x43b, afectrlovr_old);
+	write_phy_reg(pi, 0x43c, afectrlovrval_old);
+	write_phy_reg(pi, 0x6da, old_sslpnCalibClkEnCtrl);
+	write_phy_reg(pi, 0x6db, old_sslpnRxFeClkEnCtrl);
 
-		wlc_lcnphy_clear_trsw_override(pi);
+	wlc_lcnphy_clear_trsw_override(pi);
 
-		mod_phy_reg(pi, 0x44c, (0x1 << 2), 0 << 2);
+	mod_phy_reg(pi, 0x44c, (0x1 << 2), 0 << 2);
 
-		for (i = 0; i < 11; i++)
-			write_radio_reg(pi, rxiq_cal_rf_reg[i],
-					values_to_save[i]);
+	for (i = 0; i < 11; i++)
+		write_radio_reg(pi, rxiq_cal_rf_reg[i],
+				values_to_save[i]);
 
-		if (tx_gain_override_old)
-			wlc_lcnphy_set_tx_pwr_by_index(pi, tx_gain_index_old);
-		else
-			wlc_lcnphy_disable_tx_gain_override(pi);
+	if (tx_gain_override_old)
+		wlc_lcnphy_set_tx_pwr_by_index(pi, tx_gain_index_old);
+	else
+		wlc_lcnphy_disable_tx_gain_override(pi);
 
-		wlc_lcnphy_set_tx_pwr_ctrl(pi, tx_pwr_ctrl);
-		wlc_lcnphy_rx_gain_override_enable(pi, false);
-	}
+	wlc_lcnphy_set_tx_pwr_ctrl(pi, tx_pwr_ctrl);
+	wlc_lcnphy_rx_gain_override_enable(pi, false);
 
 cal_done:
 	kfree(ptr);
@@ -1789,6 +1835,17 @@ wlc_lcnphy_radio_2064_channel_tune_4313(struct brcms_phy *pi, u8 channel)
 		write_radio_reg(pi, RADIO_2064_REG038, 3);
 		write_radio_reg(pi, RADIO_2064_REG091, 7);
 	}
+
+	if (!(pi->sh->boardflags & BFL_FEM)) {
+		u8 reg038[14] = {0xd, 0xe, 0xd, 0xd, 0xd, 0xc,
+			0xa, 0xb, 0xb, 0x3, 0x3, 0x2, 0x0, 0x0};
+
+		write_radio_reg(pi, RADIO_2064_REG02A, 0xf);
+		write_radio_reg(pi, RADIO_2064_REG091, 0x3);
+		write_radio_reg(pi, RADIO_2064_REG038, 0x3);
+
+		write_radio_reg(pi, RADIO_2064_REG038, reg038[channel - 1]);
+	}
 }
 
 static int
@@ -1983,6 +2040,16 @@ wlc_lcnphy_set_tssi_mux(struct brcms_phy *pi, enum lcnphy_tssi_mode pos)
 		} else {
 			mod_radio_reg(pi, RADIO_2064_REG03A, 1, 0x1);
 			mod_radio_reg(pi, RADIO_2064_REG11A, 0x8, 0x8);
+			mod_radio_reg(pi, RADIO_2064_REG028, 0x1, 0x0);
+			mod_radio_reg(pi, RADIO_2064_REG11A, 0x4, 1<<2);
+			mod_radio_reg(pi, RADIO_2064_REG036, 0x10, 0x0);
+			mod_radio_reg(pi, RADIO_2064_REG11A, 0x10, 1<<4);
+			mod_radio_reg(pi, RADIO_2064_REG036, 0x3, 0x0);
+			mod_radio_reg(pi, RADIO_2064_REG035, 0xff, 0x77);
+			mod_radio_reg(pi, RADIO_2064_REG028, 0x1e, 0xe<<1);
+			mod_radio_reg(pi, RADIO_2064_REG112, 0x80, 1<<7);
+			mod_radio_reg(pi, RADIO_2064_REG005, 0x7, 1<<1);
+			mod_radio_reg(pi, RADIO_2064_REG029, 0xf0, 0<<4);
 		}
 	} else {
 		mod_phy_reg(pi, 0x4d9, (0x1 << 2), (0x1) << 2);
@@ -2069,12 +2136,14 @@ static void wlc_lcnphy_pwrctrl_rssiparams(struct brcms_phy *pi)
 		    (auxpga_vmid_temp << 0) | (auxpga_gain_temp << 12));
 
 	mod_radio_reg(pi, RADIO_2064_REG082, (1 << 5), (1 << 5));
+	mod_radio_reg(pi, RADIO_2064_REG07C, (1 << 0), (1 << 0));
 }
 
 static void wlc_lcnphy_tssi_setup(struct brcms_phy *pi)
 {
 	struct phytbl_info tab;
 	u32 rfseq, ind;
+	u8 tssi_sel;
 
 	tab.tbl_id = LCNPHY_TBL_ID_TXPWRCTL;
 	tab.tbl_width = 32;
@@ -2096,7 +2165,13 @@ static void wlc_lcnphy_tssi_setup(struct brcms_phy *pi)
 
 	mod_phy_reg(pi, 0x503, (0x1 << 4), (1) << 4);
 
-	wlc_lcnphy_set_tssi_mux(pi, LCNPHY_TSSI_EXT);
+	if (pi->sh->boardflags & BFL_FEM) {
+		tssi_sel = 0x1;
+		wlc_lcnphy_set_tssi_mux(pi, LCNPHY_TSSI_EXT);
+	} else {
+		tssi_sel = 0xe;
+		wlc_lcnphy_set_tssi_mux(pi, LCNPHY_TSSI_POST_PA);
+	}
 	mod_phy_reg(pi, 0x4a4, (0x1 << 14), (0) << 14);
 
 	mod_phy_reg(pi, 0x4a4, (0x1 << 15), (1) << 15);
@@ -2132,9 +2207,10 @@ static void wlc_lcnphy_tssi_setup(struct brcms_phy *pi)
 	mod_phy_reg(pi, 0x49a, (0x1ff << 0), (0xff) << 0);
 
 	if (LCNREV_IS(pi->pubpi.phy_rev, 2)) {
-		mod_radio_reg(pi, RADIO_2064_REG028, 0xf, 0xe);
+		mod_radio_reg(pi, RADIO_2064_REG028, 0xf, tssi_sel);
 		mod_radio_reg(pi, RADIO_2064_REG086, 0x4, 0x4);
 	} else {
+		mod_radio_reg(pi, RADIO_2064_REG028, 0x1e, tssi_sel << 1);
 		mod_radio_reg(pi, RADIO_2064_REG03A, 0x1, 1);
 		mod_radio_reg(pi, RADIO_2064_REG11A, 0x8, 1 << 3);
 	}
@@ -2181,6 +2257,10 @@ static void wlc_lcnphy_tssi_setup(struct brcms_phy *pi)
 
 	mod_phy_reg(pi, 0x4d7, (0xf << 8), (0) << 8);
 
+	mod_radio_reg(pi, RADIO_2064_REG035, 0xff, 0x0);
+	mod_radio_reg(pi, RADIO_2064_REG036, 0x3, 0x0);
+	mod_radio_reg(pi, RADIO_2064_REG11A, 0x8, 0x8);
+
 	wlc_lcnphy_pwrctrl_rssiparams(pi);
 }
 
@@ -2799,6 +2879,8 @@ static void wlc_lcnphy_idle_tssi_est(struct brcms_phy_pub *ppi)
 		read_radio_reg(pi, RADIO_2064_REG007) & 1;
 	u16 SAVE_jtag_auxpga = read_radio_reg(pi, RADIO_2064_REG0FF) & 0x10;
 	u16 SAVE_iqadc_aux_en = read_radio_reg(pi, RADIO_2064_REG11F) & 4;
+	u8 SAVE_bbmult = wlc_lcnphy_get_bbmult(pi);
+
 	idleTssi = read_phy_reg(pi, 0x4ab);
 	suspend = (0 == (bcma_read32(pi->d11core, D11REGOFFS(maccontrol)) &
 			 MCTL_EN_MAC));
@@ -2816,6 +2898,12 @@ static void wlc_lcnphy_idle_tssi_est(struct brcms_phy_pub *ppi)
 	mod_radio_reg(pi, RADIO_2064_REG0FF, 0x10, 1 << 4);
 	mod_radio_reg(pi, RADIO_2064_REG11F, 0x4, 1 << 2);
 	wlc_lcnphy_tssi_setup(pi);
+
+	mod_phy_reg(pi, 0x4d7, (0x1 << 0), (1 << 0));
+	mod_phy_reg(pi, 0x4d7, (0x1 << 6), (1 << 6));
+
+	wlc_lcnphy_set_bbmult(pi, 0x0);
+
 	wlc_phy_do_dummy_tx(pi, true, OFF);
 	idleTssi = ((read_phy_reg(pi, 0x4ab) & (0x1ff << 0))
 		    >> 0);
@@ -2837,6 +2925,7 @@ static void wlc_lcnphy_idle_tssi_est(struct brcms_phy_pub *ppi)
 
 	mod_phy_reg(pi, 0x44c, (0x1 << 12), (0) << 12);
 
+	wlc_lcnphy_set_bbmult(pi, SAVE_bbmult);
 	wlc_lcnphy_set_tx_gain_override(pi, tx_gain_override_old);
 	wlc_lcnphy_set_tx_gain(pi, &old_gains);
 	wlc_lcnphy_set_tx_pwr_ctrl(pi, SAVE_txpwrctrl);
@@ -3050,6 +3139,11 @@ static void wlc_lcnphy_tx_pwr_ctrl_init(struct brcms_phy_pub *ppi)
 			wlc_lcnphy_write_table(pi, &tab);
 			tab.tbl_offset++;
 		}
+		mod_phy_reg(pi, 0x4d0, (0x1 << 0), (0) << 0);
+		mod_phy_reg(pi, 0x4d3, (0xff << 0), (0) << 0);
+		mod_phy_reg(pi, 0x4d3, (0xff << 8), (0) << 8);
+		mod_phy_reg(pi, 0x4d0, (0x1 << 4), (0) << 4);
+		mod_phy_reg(pi, 0x4d0, (0x1 << 2), (0) << 2);
 
 		mod_phy_reg(pi, 0x410, (0x1 << 7), (0) << 7);
 
@@ -3851,7 +3945,6 @@ static void wlc_lcnphy_txpwrtbl_iqlo_cal(struct brcms_phy *pi)
 	target_gains.pad_gain = 21;
 	target_gains.dac_gain = 0;
 	wlc_lcnphy_set_tx_gain(pi, &target_gains);
-	wlc_lcnphy_set_tx_pwr_by_index(pi, 16);
 
 	if (LCNREV_IS(pi->pubpi.phy_rev, 1) || pi_lcn->lcnphy_hw_iqcal_en) {
 
@@ -3862,6 +3955,7 @@ static void wlc_lcnphy_txpwrtbl_iqlo_cal(struct brcms_phy *pi)
 					lcnphy_recal ? LCNPHY_CAL_RECAL :
 					LCNPHY_CAL_FULL), false);
 	} else {
+		wlc_lcnphy_set_tx_pwr_by_index(pi, 16);
 		wlc_lcnphy_tx_iqlo_soft_cal_full(pi);
 	}
 
@@ -4286,17 +4380,22 @@ wlc_lcnphy_load_tx_gain_table(struct brcms_phy *pi,
 	if (CHSPEC_IS5G(pi->radio_chanspec))
 		pa_gain = 0x70;
 	else
-		pa_gain = 0x70;
+		pa_gain = 0x60;
 
 	if (pi->sh->boardflags & BFL_FEM)
 		pa_gain = 0x10;
+
 	tab.tbl_id = LCNPHY_TBL_ID_TXPWRCTL;
 	tab.tbl_width = 32;
 	tab.tbl_len = 1;
 	tab.tbl_ptr = &val;
 
 	for (j = 0; j < 128; j++) {
-		gm_gain = gain_table[j].gm;
+		if (pi->sh->boardflags & BFL_FEM)
+			gm_gain = gain_table[j].gm;
+		else
+			gm_gain = 15;
+
 		val = (((u32) pa_gain << 24) |
 		       (gain_table[j].pad << 16) |
 		       (gain_table[j].pga << 8) | gm_gain);
@@ -4507,7 +4606,10 @@ static void wlc_radio_2064_init(struct brcms_phy *pi)
 
 	write_phy_reg(pi, 0x4ea, 0x4688);
 
-	mod_phy_reg(pi, 0x4eb, (0x7 << 0), 2 << 0);
+	if (pi->sh->boardflags & BFL_FEM)
+		mod_phy_reg(pi, 0x4eb, (0x7 << 0), 2 << 0);
+	else
+		mod_phy_reg(pi, 0x4eb, (0x7 << 0), 3 << 0);
 
 	mod_phy_reg(pi, 0x4eb, (0x7 << 6), 0 << 6);
 
@@ -4518,6 +4620,13 @@ static void wlc_radio_2064_init(struct brcms_phy *pi)
 	wlc_lcnphy_rcal(pi);
 
 	wlc_lcnphy_rc_cal(pi);
+
+	if (!(pi->sh->boardflags & BFL_FEM)) {
+		write_radio_reg(pi, RADIO_2064_REG032, 0x6f);
+		write_radio_reg(pi, RADIO_2064_REG033, 0x19);
+		write_radio_reg(pi, RADIO_2064_REG039, 0xe);
+	}
+
 }
 
 static void wlc_lcnphy_radio_init(struct brcms_phy *pi)
@@ -4530,6 +4639,7 @@ static void wlc_lcnphy_tbl_init(struct brcms_phy *pi)
 	uint idx;
 	u8 phybw40;
 	struct phytbl_info tab;
+	const struct phytbl_info *tb;
 	u32 val;
 
 	phybw40 = CHSPEC_IS40(pi->radio_chanspec);
@@ -4547,22 +4657,20 @@ static void wlc_lcnphy_tbl_init(struct brcms_phy *pi)
 		wlc_lcnphy_write_table(pi, &tab);
 	}
 
-	tab.tbl_id = LCNPHY_TBL_ID_RFSEQ;
-	tab.tbl_width = 16;
-	tab.tbl_ptr = &val;
-	tab.tbl_len = 1;
-
-	val = 114;
-	tab.tbl_offset = 0;
-	wlc_lcnphy_write_table(pi, &tab);
+	if (!(pi->sh->boardflags & BFL_FEM)) {
+		tab.tbl_id = LCNPHY_TBL_ID_RFSEQ;
+		tab.tbl_width = 16;
+		tab.tbl_ptr = &val;
+		tab.tbl_len = 1;
 
-	val = 130;
-	tab.tbl_offset = 1;
-	wlc_lcnphy_write_table(pi, &tab);
+		val = 150;
+		tab.tbl_offset = 0;
+		wlc_lcnphy_write_table(pi, &tab);
 
-	val = 6;
-	tab.tbl_offset = 8;
-	wlc_lcnphy_write_table(pi, &tab);
+		val = 220;
+		tab.tbl_offset = 1;
+		wlc_lcnphy_write_table(pi, &tab);
+	}
 
 	if (CHSPEC_IS2G(pi->radio_chanspec)) {
 		if (pi->sh->boardflags & BFL_FEM)
@@ -4576,7 +4684,6 @@ static void wlc_lcnphy_tbl_init(struct brcms_phy *pi)
 	}
 
 	if (LCNREV_IS(pi->pubpi.phy_rev, 2)) {
-		const struct phytbl_info *tb;
 		int l;
 
 		if (CHSPEC_IS2G(pi->radio_chanspec)) {
@@ -4597,21 +4704,22 @@ static void wlc_lcnphy_tbl_init(struct brcms_phy *pi)
 			wlc_lcnphy_write_table(pi, &tb[idx]);
 	}
 
-	if ((pi->sh->boardflags & BFL_FEM)
-	    && !(pi->sh->boardflags & BFL_FEM_BT))
-		wlc_lcnphy_write_table(pi, &dot11lcn_sw_ctrl_tbl_info_4313_epa);
-	else if (pi->sh->boardflags & BFL_FEM_BT) {
-		if (pi->sh->boardrev < 0x1250)
-			wlc_lcnphy_write_table(
-				pi,
-				&dot11lcn_sw_ctrl_tbl_info_4313_bt_epa);
+	if (pi->sh->boardflags & BFL_FEM) {
+		if (pi->sh->boardflags & BFL_FEM_BT) {
+			if (pi->sh->boardrev < 0x1250)
+				tb = &dot11lcn_sw_ctrl_tbl_info_4313_bt_epa;
+			else
+				tb = &dot11lcn_sw_ctrl_tbl_info_4313_bt_epa_p250;
+		} else {
+			tb = &dot11lcn_sw_ctrl_tbl_info_4313_epa;
+		}
+	} else {
+		if (pi->sh->boardflags & BFL_FEM_BT)
+			tb = &dot11lcn_sw_ctrl_tbl_info_4313_bt_ipa;
 		else
-			wlc_lcnphy_write_table(
-				pi,
-				&dot11lcn_sw_ctrl_tbl_info_4313_bt_epa_p250);
-	} else
-		wlc_lcnphy_write_table(pi, &dot11lcn_sw_ctrl_tbl_info_4313);
-
+			tb = &dot11lcn_sw_ctrl_tbl_info_4313;
+	}
+	wlc_lcnphy_write_table(pi, tb);
 	wlc_lcnphy_load_rfpower(pi);
 
 	wlc_lcnphy_clear_papd_comptable(pi);
@@ -4955,6 +5063,8 @@ void wlc_phy_chanspec_set_lcnphy(struct brcms_phy *pi, u16 chanspec)
 		wlc_lcnphy_load_tx_iir_filter(pi, true, 3);
 
 	mod_phy_reg(pi, 0x4eb, (0x7 << 3), (1) << 3);
+	if (wlc_lcnphy_tssi_based_pwr_ctrl_enabled(pi))
+		wlc_lcnphy_tssi_setup(pi);
 }
 
 void wlc_phy_detach_lcnphy(struct brcms_phy *pi)
@@ -4993,8 +5103,7 @@ bool wlc_phy_attach_lcnphy(struct brcms_phy *pi)
 	if (!wlc_phy_txpwr_srom_read_lcnphy(pi))
 		return false;
 
-	if ((pi->sh->boardflags & BFL_FEM) &&
-	    (LCNREV_IS(pi->pubpi.phy_rev, 1))) {
+	if (LCNREV_IS(pi->pubpi.phy_rev, 1)) {
 		if (pi_lcn->lcnphy_tempsense_option == 3) {
 			pi->hwpwrctrl = true;
 			pi->hwpwrctrl_capable = true;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_lcn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_lcn.c
index 622c01c..9fb0ca2 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_lcn.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_lcn.c
@@ -2058,6 +2058,73 @@ static const u16 dot11lcn_sw_ctrl_tbl_4313_rev0[] = {
 	0x0005,
 };
 
+static const u16 dot11lcn_sw_ctrl_tbl_4313_ipa_rev0_combo[] = {
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+	0x0005,
+	0x0006,
+	0x0009,
+	0x000a,
+};
+
 static const u16 dot11lcn_sw_ctrl_tbl_rev0[] = {
 	0x0004,
 	0x0004,
@@ -2834,6 +2901,12 @@ const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313 = {
 	sizeof(dot11lcn_sw_ctrl_tbl_4313_rev0[0]), 15, 0, 16
 };
 
+const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313_bt_ipa = {
+	&dot11lcn_sw_ctrl_tbl_4313_ipa_rev0_combo,
+	sizeof(dot11lcn_sw_ctrl_tbl_4313_ipa_rev0_combo) /
+	sizeof(dot11lcn_sw_ctrl_tbl_4313_ipa_rev0_combo[0]), 15, 0, 16
+};
+
 const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313_epa = {
 	&dot11lcn_sw_ctrl_tbl_4313_epa_rev0,
 	sizeof(dot11lcn_sw_ctrl_tbl_4313_epa_rev0) /
@@ -2988,134 +3061,134 @@ dot11lcnphy_2GHz_extPA_gaintable_rev0[128] = {
 };
 
 const struct lcnphy_tx_gain_tbl_entry dot11lcnphy_2GHz_gaintable_rev0[128] = {
-	{7, 0, 31, 0, 72},
-	{7, 0, 31, 0, 70},
-	{7, 0, 31, 0, 68},
-	{7, 0, 30, 0, 67},
-	{7, 0, 29, 0, 68},
-	{7, 0, 28, 0, 68},
-	{7, 0, 27, 0, 69},
-	{7, 0, 26, 0, 70},
-	{7, 0, 25, 0, 70},
-	{7, 0, 24, 0, 71},
-	{7, 0, 23, 0, 72},
-	{7, 0, 23, 0, 70},
-	{7, 0, 22, 0, 71},
-	{7, 0, 21, 0, 72},
-	{7, 0, 21, 0, 70},
-	{7, 0, 21, 0, 68},
-	{7, 0, 21, 0, 66},
-	{7, 0, 21, 0, 64},
-	{7, 0, 21, 0, 63},
-	{7, 0, 20, 0, 64},
-	{7, 0, 19, 0, 65},
-	{7, 0, 19, 0, 64},
-	{7, 0, 18, 0, 65},
-	{7, 0, 18, 0, 64},
-	{7, 0, 17, 0, 65},
-	{7, 0, 17, 0, 64},
-	{7, 0, 16, 0, 65},
-	{7, 0, 16, 0, 64},
-	{7, 0, 16, 0, 62},
-	{7, 0, 16, 0, 60},
-	{7, 0, 16, 0, 58},
-	{7, 0, 15, 0, 61},
-	{7, 0, 15, 0, 59},
-	{7, 0, 14, 0, 61},
-	{7, 0, 14, 0, 60},
-	{7, 0, 14, 0, 58},
-	{7, 0, 13, 0, 60},
-	{7, 0, 13, 0, 59},
-	{7, 0, 12, 0, 62},
-	{7, 0, 12, 0, 60},
-	{7, 0, 12, 0, 58},
-	{7, 0, 11, 0, 62},
-	{7, 0, 11, 0, 60},
-	{7, 0, 11, 0, 59},
-	{7, 0, 11, 0, 57},
-	{7, 0, 10, 0, 61},
-	{7, 0, 10, 0, 59},
-	{7, 0, 10, 0, 57},
-	{7, 0, 9, 0, 62},
-	{7, 0, 9, 0, 60},
-	{7, 0, 9, 0, 58},
-	{7, 0, 9, 0, 57},
-	{7, 0, 8, 0, 62},
-	{7, 0, 8, 0, 60},
-	{7, 0, 8, 0, 58},
-	{7, 0, 8, 0, 57},
-	{7, 0, 8, 0, 55},
-	{7, 0, 7, 0, 61},
+	{15, 0, 31, 0, 72},
+	{15, 0, 31, 0, 70},
+	{15, 0, 31, 0, 68},
+	{15, 0, 30, 0, 68},
+	{15, 0, 29, 0, 69},
+	{15, 0, 28, 0, 69},
+	{15, 0, 27, 0, 70},
+	{15, 0, 26, 0, 70},
+	{15, 0, 25, 0, 71},
+	{15, 0, 24, 0, 72},
+	{15, 0, 23, 0, 73},
+	{15, 0, 23, 0, 71},
+	{15, 0, 22, 0, 72},
+	{15, 0, 21, 0, 73},
+	{15, 0, 21, 0, 71},
+	{15, 0, 21, 0, 69},
+	{15, 0, 21, 0, 67},
+	{15, 0, 21, 0, 65},
+	{15, 0, 21, 0, 63},
+	{15, 0, 20, 0, 65},
+	{15, 0, 19, 0, 66},
+	{15, 0, 19, 0, 64},
+	{15, 0, 18, 0, 66},
+	{15, 0, 18, 0, 64},
+	{15, 0, 17, 0, 66},
+	{15, 0, 17, 0, 64},
+	{15, 0, 16, 0, 66},
+	{15, 0, 16, 0, 64},
+	{15, 0, 16, 0, 62},
+	{15, 0, 16, 0, 61},
+	{15, 0, 16, 0, 59},
+	{15, 0, 15, 0, 61},
+	{15, 0, 15, 0, 59},
+	{15, 0, 14, 0, 62},
+	{15, 0, 14, 0, 60},
+	{15, 0, 14, 0, 58},
+	{15, 0, 13, 0, 61},
+	{15, 0, 13, 0, 59},
+	{15, 0, 12, 0, 62},
+	{15, 0, 12, 0, 61},
+	{15, 0, 12, 0, 59},
+	{15, 0, 11, 0, 62},
+	{15, 0, 11, 0, 61},
+	{15, 0, 11, 0, 59},
+	{15, 0, 11, 0, 57},
+	{15, 0, 10, 0, 61},
+	{15, 0, 10, 0, 59},
+	{15, 0, 10, 0, 58},
+	{15, 0, 9, 0, 62},
+	{15, 0, 9, 0, 61},
+	{15, 0, 9, 0, 59},
+	{15, 0, 9, 0, 57},
+	{15, 0, 8, 0, 62},
+	{15, 0, 8, 0, 61},
+	{15, 0, 8, 0, 59},
+	{15, 0, 8, 0, 57},
+	{15, 0, 8, 0, 56},
+	{15, 0, 8, 0, 54},
+	{15, 0, 8, 0, 53},
+	{15, 0, 8, 0, 51},
+	{15, 0, 8, 0, 50},
+	{7, 0, 7, 0, 69},
+	{7, 0, 7, 0, 67},
+	{7, 0, 7, 0, 65},
+	{7, 0, 7, 0, 64},
+	{7, 0, 7, 0, 62},
 	{7, 0, 7, 0, 60},
 	{7, 0, 7, 0, 58},
-	{7, 0, 7, 0, 56},
+	{7, 0, 7, 0, 57},
 	{7, 0, 7, 0, 55},
 	{7, 0, 6, 0, 62},
-	{7, 0, 6, 0, 60},
-	{7, 0, 6, 0, 58},
+	{7, 0, 6, 0, 61},
+	{7, 0, 6, 0, 59},
 	{7, 0, 6, 0, 57},
-	{7, 0, 6, 0, 55},
+	{7, 0, 6, 0, 56},
 	{7, 0, 6, 0, 54},
-	{7, 0, 6, 0, 52},
+	{7, 0, 6, 0, 53},
 	{7, 0, 5, 0, 61},
-	{7, 0, 5, 0, 59},
-	{7, 0, 5, 0, 57},
+	{7, 0, 5, 0, 60},
+	{7, 0, 5, 0, 58},
 	{7, 0, 5, 0, 56},
-	{7, 0, 5, 0, 54},
+	{7, 0, 5, 0, 55},
 	{7, 0, 5, 0, 53},
-	{7, 0, 5, 0, 51},
-	{7, 0, 4, 0, 62},
-	{7, 0, 4, 0, 60},
-	{7, 0, 4, 0, 58},
+	{7, 0, 5, 0, 52},
+	{7, 0, 5, 0, 50},
+	{7, 0, 5, 0, 49},
+	{7, 0, 5, 0, 47},
 	{7, 0, 4, 0, 57},
-	{7, 0, 4, 0, 55},
+	{7, 0, 4, 0, 56},
 	{7, 0, 4, 0, 54},
-	{7, 0, 4, 0, 52},
+	{7, 0, 4, 0, 53},
 	{7, 0, 4, 0, 51},
-	{7, 0, 4, 0, 49},
+	{7, 0, 4, 0, 50},
 	{7, 0, 4, 0, 48},
+	{7, 0, 4, 0, 47},
 	{7, 0, 4, 0, 46},
-	{7, 0, 3, 0, 60},
-	{7, 0, 3, 0, 58},
-	{7, 0, 3, 0, 57},
-	{7, 0, 3, 0, 55},
-	{7, 0, 3, 0, 54},
-	{7, 0, 3, 0, 52},
+	{7, 0, 4, 0, 44},
+	{7, 0, 4, 0, 43},
+	{7, 0, 4, 0, 42},
+	{7, 0, 4, 0, 41},
+	{7, 0, 4, 0, 40},
 	{7, 0, 3, 0, 51},
-	{7, 0, 3, 0, 49},
+	{7, 0, 3, 0, 50},
 	{7, 0, 3, 0, 48},
+	{7, 0, 3, 0, 47},
 	{7, 0, 3, 0, 46},
-	{7, 0, 3, 0, 45},
 	{7, 0, 3, 0, 44},
 	{7, 0, 3, 0, 43},
+	{7, 0, 3, 0, 42},
 	{7, 0, 3, 0, 41},
-	{7, 0, 2, 0, 61},
-	{7, 0, 2, 0, 59},
-	{7, 0, 2, 0, 57},
-	{7, 0, 2, 0, 56},
-	{7, 0, 2, 0, 54},
-	{7, 0, 2, 0, 53},
-	{7, 0, 2, 0, 51},
-	{7, 0, 2, 0, 50},
-	{7, 0, 2, 0, 48},
-	{7, 0, 2, 0, 47},
-	{7, 0, 2, 0, 46},
-	{7, 0, 2, 0, 44},
-	{7, 0, 2, 0, 43},
-	{7, 0, 2, 0, 42},
-	{7, 0, 2, 0, 41},
-	{7, 0, 2, 0, 39},
-	{7, 0, 2, 0, 38},
-	{7, 0, 2, 0, 37},
-	{7, 0, 2, 0, 36},
-	{7, 0, 2, 0, 35},
-	{7, 0, 2, 0, 34},
-	{7, 0, 2, 0, 33},
-	{7, 0, 2, 0, 32},
-	{7, 0, 1, 0, 63},
-	{7, 0, 1, 0, 61},
-	{7, 0, 1, 0, 59},
-	{7, 0, 1, 0, 57},
+	{3, 0, 3, 0, 56},
+	{3, 0, 3, 0, 54},
+	{3, 0, 3, 0, 53},
+	{3, 0, 3, 0, 51},
+	{3, 0, 3, 0, 50},
+	{3, 0, 3, 0, 48},
+	{3, 0, 3, 0, 47},
+	{3, 0, 3, 0, 46},
+	{3, 0, 3, 0, 44},
+	{3, 0, 3, 0, 43},
+	{3, 0, 3, 0, 42},
+	{3, 0, 3, 0, 41},
+	{3, 0, 3, 0, 39},
+	{3, 0, 3, 0, 38},
+	{3, 0, 3, 0, 37},
+	{3, 0, 3, 0, 36},
+	{3, 0, 3, 0, 35},
+	{3, 0, 3, 0, 34},
 };
 
 const struct lcnphy_tx_gain_tbl_entry dot11lcnphy_5GHz_gaintable_rev0[128] = {
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_lcn.h b/drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_lcn.h
index 5f75e16..489422a 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_lcn.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_lcn.h
@@ -20,6 +20,7 @@
 extern const struct phytbl_info dot11lcnphytbl_rx_gain_info_rev0[];
 extern const u32 dot11lcnphytbl_rx_gain_info_sz_rev0;
 extern const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313;
+extern const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313_bt_ipa;
 extern const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313_epa;
 extern const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313_epa_combo;
 extern const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313_bt_epa;
-- 
1.8.1.3


