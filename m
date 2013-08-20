Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1399 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213Ab3HTOBA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Aug 2013 10:01:00 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>,
	"Jonas Gorski" <jogo@openwrt.org>
Subject: [PATCH 06/12] brcmsmac: change lcnphy receive i/q calibration
 routine
Date: Tue, 20 Aug 2013 16:00:40 +0200
Message-ID: <1377007246-9957-7-git-send-email-arend@broadcom.com> (sfid-20130820_160203_615676_185B9662)
In-Reply-To: <1377007246-9957-1-git-send-email-arend@broadcom.com>
References: <1377007246-9957-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The gain level control for the test tone has been changed. This
calbration test tone is used to determine the i/q compensation.
The i/q calibration routine has been reworked to accomodate this.

Cc: Jonas Gorski <jogo@openwrt.org>
Tested-by: David Herrmann <dh.herrmann@gmail.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c  |   78 +++++++++++++++-----
 1 file changed, 58 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
index 8dc5d0f..236e8d9 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -1329,6 +1329,43 @@ static u32 wlc_lcnphy_measure_digital_power(struct brcms_phy *pi, u16 nsamples)
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
@@ -1343,8 +1380,8 @@ wlc_lcnphy_rx_iq_cal(struct brcms_phy *pi,
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
@@ -1432,29 +1469,30 @@ wlc_lcnphy_rx_iq_cal(struct brcms_phy *pi,
 	mod_phy_reg(pi, 0x43b, (0x1 << 0), 1 << 0);
 	mod_phy_reg(pi, 0x43c, (0x1 << 0), 0 << 0);
 
-	wlc_lcnphy_start_tx_tone(pi, 2000, 120, 0);
 	write_phy_reg(pi, 0x6da, 0xffff);
 	or_phy_reg(pi, 0x6db, 0x3);
-	wlc_lcnphy_set_trsw_override(pi, tx_switch, rx_switch);
-	wlc_lcnphy_rx_gain_override_enable(pi, true);
-
-	tia_gain = 8;
-	rx_pwr_threshold = 950;
-	while (tia_gain > 0) {
-		tia_gain -= 1;
-		wlc_lcnphy_set_rx_gain_by_distribution(pi,
-						       0, 0, 2, 2,
-						       (u16)
-						       tia_gain, 1, 0);
-		udelay(500);
 
-		received_power =
-			wlc_lcnphy_measure_digital_power(pi, 2000);
-		if (received_power < rx_pwr_threshold)
-			break;
+	wlc_lcnphy_set_trsw_override(pi, tx_switch, rx_switch);
+	for (lna2_gain = 3; lna2_gain >= 0; lna2_gain--) {
+		for (tia_gain = 4; tia_gain >= 0; tia_gain--) {
+			for (biq1_gain = 6; biq1_gain >= 0; biq1_gain--) {
+				set_gain = wlc_lcnphy_rx_iq_cal_gain(pi,
+								     (u16)
+								     biq1_gain,
+								     (u16)
+								     tia_gain,
+								     (u16)
+								     lna2_gain);
+				if (!set_gain)
+					continue;
+
+				result = wlc_lcnphy_calc_rx_iq_comp(pi, 1024);
+				goto stop_tone;
+			}
+		}
 	}
-	result = wlc_lcnphy_calc_rx_iq_comp(pi, 0xffff);
 
+stop_tone:
 	wlc_lcnphy_stop_tx_tone(pi);
 
 	write_phy_reg(pi, 0x631, Core1TxControl_old);
-- 
1.7.10.4


