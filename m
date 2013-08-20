Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3242 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097Ab3HTOA7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Aug 2013 10:00:59 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>,
	"Jonas Gorski" <jogo@openwrt.org>
Subject: [PATCH 01/12] brcmsmac: cosmetic change in phy_lcn.c
Date: Tue, 20 Aug 2013 16:00:35 +0200
Message-ID: <1377007246-9957-2-git-send-email-arend@broadcom.com> (sfid-20130820_160136_586514_25BA83A7)
In-Reply-To: <1377007246-9957-1-git-send-email-arend@broadcom.com>
References: <1377007246-9957-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleaning up some code fragments reducing indentation and uncluttering
some lines. Apart from whitespace there are no actual code changes
made.

Cc: Jonas Gorski <jogo@openwrt.org>
Tested-by: David Herrmann <dh.herrmann@gmail.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c  |  213 ++++++++++----------
 1 file changed, 106 insertions(+), 107 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
index 3d6b16c..e646ba0 100644
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
@@ -1368,126 +1369,124 @@ wlc_lcnphy_rx_iq_cal(struct brcms_phy *pi,
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
-		}
-		result = wlc_lcnphy_calc_rx_iq_comp(pi, 0xffff);
+	mod_phy_reg(pi, 0x43b, (0x1 << 0), 1 << 0);
+	mod_phy_reg(pi, 0x43c, (0x1 << 0), 0 << 0);
 
-		wlc_lcnphy_stop_tx_tone(pi);
+	wlc_lcnphy_start_tx_tone(pi, 2000, 120, 0);
+	write_phy_reg(pi, 0x6da, 0xffff);
+	or_phy_reg(pi, 0x6db, 0x3);
+	wlc_lcnphy_set_trsw_override(pi, tx_switch, rx_switch);
+	wlc_lcnphy_rx_gain_override_enable(pi, true);
 
-		write_phy_reg(pi, 0x631, Core1TxControl_old);
+	tia_gain = 8;
+	rx_pwr_threshold = 950;
+	while (tia_gain > 0) {
+		tia_gain -= 1;
+		wlc_lcnphy_set_rx_gain_by_distribution(pi,
+						       0, 0, 2, 2,
+						       (u16)
+						       tia_gain, 1, 0);
+		udelay(500);
 
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
+		received_power =
+			wlc_lcnphy_measure_digital_power(pi, 2000);
+		if (received_power < rx_pwr_threshold)
+			break;
+	}
+	result = wlc_lcnphy_calc_rx_iq_comp(pi, 0xffff);
 
-		wlc_lcnphy_clear_trsw_override(pi);
+	wlc_lcnphy_stop_tx_tone(pi);
 
-		mod_phy_reg(pi, 0x44c, (0x1 << 2), 0 << 2);
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
 
-		for (i = 0; i < 11; i++)
-			write_radio_reg(pi, rxiq_cal_rf_reg[i],
-					values_to_save[i]);
+	wlc_lcnphy_clear_trsw_override(pi);
 
-		if (tx_gain_override_old)
-			wlc_lcnphy_set_tx_pwr_by_index(pi, tx_gain_index_old);
-		else
-			wlc_lcnphy_disable_tx_gain_override(pi);
+	mod_phy_reg(pi, 0x44c, (0x1 << 2), 0 << 2);
 
-		wlc_lcnphy_set_tx_pwr_ctrl(pi, tx_pwr_ctrl);
-		wlc_lcnphy_rx_gain_override_enable(pi, false);
-	}
+	for (i = 0; i < 11; i++)
+		write_radio_reg(pi, rxiq_cal_rf_reg[i],
+				values_to_save[i]);
+
+	if (tx_gain_override_old)
+		wlc_lcnphy_set_tx_pwr_by_index(pi, tx_gain_index_old);
+	else
+		wlc_lcnphy_disable_tx_gain_override(pi);
+
+	wlc_lcnphy_set_tx_pwr_ctrl(pi, tx_pwr_ctrl);
+	wlc_lcnphy_rx_gain_override_enable(pi, false);
 
 cal_done:
 	kfree(ptr);
-- 
1.7.10.4


