Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f228.google.com ([209.85.220.228]:43353 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbZHLSlz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 14:41:55 -0400
Received: by fxm28 with SMTP id 28so185732fxm.17
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2009 11:41:55 -0700 (PDT)
Message-ID: <4A830CF1.3020907@gmail.com>
Date: Wed, 12 Aug 2009 20:41:53 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>
CC: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] b43: Implement RC calibration for rev.0/1 LP-PHYs
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also implement get/set BB mult, get/set TX gain, set RX gain,
disable/restore CRS, run/stop DDFS, RX IQ est and QDIV roundup
in the process.

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
Changes from v1->v2:
-Coding style fixes as suggested by Michael.
-Added missing static to lpphy_qdiv_roundup.
-Moved set_tx_power_control & related functions before rev0/1 RC calibration,
 and removed forward declaration
-Reordered variable declarations at the start of rev0_1_rc_calib.
-The ideal power table is now static const.

Interdiff v1->v2 available @ http://b43.pastebin.com/f5fe6ba3c for easier review.

 drivers/net/wireless/b43/phy_lp.c |  508 +++++++++++++++++++++++++++++++++----
 1 files changed, 461 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index 689c932..e05981b 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -605,6 +605,8 @@ static void lpphy_radio_init(struct b43_wldev *dev)
 	}
 }
 
+struct lpphy_iq_est { u32 iq_prod, i_pwr, q_pwr; };
+
 static void lpphy_set_rc_cap(struct b43_wldev *dev)
 {
 	u8 rc_cap = dev->phy.lp->rc_cap;
@@ -614,79 +616,327 @@ static void lpphy_set_rc_cap(struct b43_wldev *dev)
 	b43_radio_write(dev, B2062_S_RXG_CNT16, ((rc_cap & 0x1F) >> 2) | 0x80);
 }
 
-static void lpphy_rev0_1_rc_calib(struct b43_wldev *dev)
+static u8 lpphy_get_bb_mult(struct b43_wldev *dev)
 {
-	//TODO and SPEC FIXME
+	return (b43_lptab_read(dev, B43_LPTAB16(0, 87)) & 0xFF00) >> 8;
 }
 
-static void lpphy_rev2plus_rc_calib(struct b43_wldev *dev)
+static void lpphy_set_bb_mult(struct b43_wldev *dev, u8 bb_mult)
 {
-	struct ssb_bus *bus = dev->dev->bus;
-	u32 crystal_freq = bus->chipco.pmu.crystalfreq * 1000;
-	u8 tmp = b43_radio_read(dev, B2063_RX_BB_SP8) & 0xFF;
-	int i;
+	b43_lptab_write(dev, B43_LPTAB16(0, 87), (u16)bb_mult << 8);
+}
 
-	b43_radio_write(dev, B2063_RX_BB_SP8, 0x0);
-	b43_radio_write(dev, B2063_RC_CALIB_CTL1, 0x7E);
-	b43_radio_mask(dev, B2063_PLL_SP1, 0xF7);
-	b43_radio_write(dev, B2063_RC_CALIB_CTL1, 0x7C);
-	b43_radio_write(dev, B2063_RC_CALIB_CTL2, 0x15);
-	b43_radio_write(dev, B2063_RC_CALIB_CTL3, 0x70);
-	b43_radio_write(dev, B2063_RC_CALIB_CTL4, 0x52);
-	b43_radio_write(dev, B2063_RC_CALIB_CTL5, 0x1);
-	b43_radio_write(dev, B2063_RC_CALIB_CTL1, 0x7D);
+static void lpphy_disable_crs(struct b43_wldev *dev)
+{
+	b43_phy_maskset(dev, B43_LPPHY_CRSGAIN_CTL, 0xFF1F, 0x80);
+	b43_phy_maskset(dev, B43_LPPHY_RF_OVERRIDE_VAL_0, 0xFFFC, 0x1);
+	b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_0, 0x3);
+	b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_VAL_0, 0xFFFB);
+	b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_0, 0x4);
+	b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_0, 0xFFF7);
+	b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_0, 0x8);
+	b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_VAL_0, 0x10);
+	b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_0, 0x10);
+	b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_VAL_0, 0xFFDF);
+	b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_0, 0x20);
+	b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_VAL_0, 0xFFBF);
+	b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_0, 0x40);
+	b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_2_VAL, 0x7);
+	b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_2_VAL, 0x38);
+	b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_2_VAL, 0xFF3F);
+	b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_2_VAL, 0x100);
+	b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_2_VAL, 0xFDFF);
+	b43_phy_write(dev, B43_LPPHY_PS_CTL_OVERRIDE_VAL0, 0);
+	b43_phy_write(dev, B43_LPPHY_PS_CTL_OVERRIDE_VAL1, 1);
+	b43_phy_write(dev, B43_LPPHY_PS_CTL_OVERRIDE_VAL2, 0x20);
+	b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_2_VAL, 0xFBFF);
+	b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_2_VAL, 0xF7FF);
+	b43_phy_write(dev, B43_LPPHY_TX_GAIN_CTL_OVERRIDE_VAL, 0);
+	b43_phy_write(dev, B43_LPPHY_RX_GAIN_CTL_OVERRIDE_VAL, 0x45AF);
+	b43_phy_write(dev, B43_LPPHY_RF_OVERRIDE_2, 0x3FF);
+}
 
-	for (i = 0; i < 10000; i++) {
-		if (b43_radio_read(dev, B2063_RC_CALIB_CTL6) & 0x2)
-			break;
-		msleep(1);
+static void lpphy_restore_crs(struct b43_wldev *dev)
+{
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+		b43_phy_maskset(dev, B43_LPPHY_CRSGAIN_CTL, 0xFF1F, 0x60);
+	else
+		b43_phy_maskset(dev, B43_LPPHY_CRSGAIN_CTL, 0xFF1F, 0x20);
+	b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_0, 0xFF80);
+	b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_2, 0xFC00);
+}
+
+struct lpphy_tx_gains { u16 gm, pga, pad, dac; };
+
+static struct lpphy_tx_gains lpphy_get_tx_gains(struct b43_wldev *dev)
+{
+	struct lpphy_tx_gains gains;
+	u16 tmp;
+
+	gains.dac = (b43_phy_read(dev, B43_LPPHY_AFE_DAC_CTL) & 0x380) >> 7;
+	if (dev->phy.rev < 2) {
+		tmp = b43_phy_read(dev,
+				   B43_LPPHY_TX_GAIN_CTL_OVERRIDE_VAL) & 0x7FF;
+		gains.gm = tmp & 0x0007;
+		gains.pga = (tmp & 0x0078) >> 3;
+		gains.pad = (tmp & 0x780) >> 7;
+	} else {
+		tmp = b43_phy_read(dev, B43_LPPHY_TX_GAIN_CTL_OVERRIDE_VAL);
+		gains.pad = b43_phy_read(dev, B43_PHY_OFDM(0xFB)) & 0xFF;
+		gains.gm = tmp & 0xFF;
+		gains.pga = (tmp >> 8) & 0xFF;
 	}
 
-	if (!(b43_radio_read(dev, B2063_RC_CALIB_CTL6) & 0x2))
-		b43_radio_write(dev, B2063_RX_BB_SP8, tmp);
+	return gains;
+}
 
-	tmp = b43_radio_read(dev, B2063_TX_BB_SP3) & 0xFF;
+static void lpphy_set_dac_gain(struct b43_wldev *dev, u16 dac)
+{
+	u16 ctl = b43_phy_read(dev, B43_LPPHY_AFE_DAC_CTL) & 0xC7F;
+	ctl |= dac << 7;
+	b43_phy_maskset(dev, B43_LPPHY_AFE_DAC_CTL, 0xF000, ctl);
+}
 
-	b43_radio_write(dev, B2063_TX_BB_SP3, 0x0);
-	b43_radio_write(dev, B2063_RC_CALIB_CTL1, 0x7E);
-	b43_radio_write(dev, B2063_RC_CALIB_CTL1, 0x7C);
-	b43_radio_write(dev, B2063_RC_CALIB_CTL2, 0x55);
-	b43_radio_write(dev, B2063_RC_CALIB_CTL3, 0x76);
+static void lpphy_set_tx_gains(struct b43_wldev *dev,
+			       struct lpphy_tx_gains gains)
+{
+	u16 rf_gain, pa_gain;
 
-	if (crystal_freq == 24000000) {
-		b43_radio_write(dev, B2063_RC_CALIB_CTL4, 0xFC);
-		b43_radio_write(dev, B2063_RC_CALIB_CTL5, 0x0);
+	if (dev->phy.rev < 2) {
+		rf_gain = (gains.pad << 7) | (gains.pga << 3) | gains.gm;
+		b43_phy_maskset(dev, B43_LPPHY_TX_GAIN_CTL_OVERRIDE_VAL,
+				0xF800, rf_gain);
 	} else {
-		b43_radio_write(dev, B2063_RC_CALIB_CTL4, 0x13);
-		b43_radio_write(dev, B2063_RC_CALIB_CTL5, 0x1);
+		pa_gain = b43_phy_read(dev, B43_PHY_OFDM(0xFB)) & 0x7F00;
+		b43_phy_write(dev, B43_LPPHY_TX_GAIN_CTL_OVERRIDE_VAL,
+			      (gains.pga << 8) | gains.gm);
+		b43_phy_maskset(dev, B43_LPPHY_TX_GAIN_CTL_OVERRIDE_VAL,
+				0x8000, gains.pad | pa_gain);
+		b43_phy_write(dev, B43_PHY_OFDM(0xFC),
+			      (gains.pga << 8) | gains.gm);
+		b43_phy_maskset(dev, B43_PHY_OFDM(0xFD),
+				0x8000, gains.pad | pa_gain);
+	}
+	lpphy_set_dac_gain(dev, gains.dac);
+	if (dev->phy.rev < 2) {
+		b43_phy_maskset(dev, B43_LPPHY_RF_OVERRIDE_2, 0xFEFF, 1 << 8);
+	} else {
+		b43_phy_maskset(dev, B43_LPPHY_RF_OVERRIDE_2, 0xFF7F, 1 << 7);
+		b43_phy_maskset(dev, B43_LPPHY_RF_OVERRIDE_2, 0xBFFF, 1 << 14);
 	}
+	b43_phy_maskset(dev, B43_LPPHY_RF_OVERRIDE_2, 0xFFBF, 1 << 4);
+}
 
-	b43_radio_write(dev, B2063_PA_SP7, 0x7D);
+static void lpphy_rev0_1_set_rx_gain(struct b43_wldev *dev, u32 gain)
+{
+	u16 trsw = gain & 0x1;
+	u16 lna = (gain & 0xFFFC) | ((gain & 0xC) >> 2);
+	u16 ext_lna = (gain & 2) >> 1;
+
+	b43_phy_maskset(dev, B43_LPPHY_RF_OVERRIDE_VAL_0, 0xFFFE, trsw);
+	b43_phy_maskset(dev, B43_LPPHY_RF_OVERRIDE_2_VAL,
+			0xFBFF, ext_lna << 10);
+	b43_phy_maskset(dev, B43_LPPHY_RF_OVERRIDE_2_VAL,
+			0xF7FF, ext_lna << 11);
+	b43_phy_write(dev, B43_LPPHY_RX_GAIN_CTL_OVERRIDE_VAL, lna);
+}
 
-	for (i = 0; i < 10000; i++) {
-		if (b43_radio_read(dev, B2063_RC_CALIB_CTL6) & 0x2)
+static void lpphy_rev2plus_set_rx_gain(struct b43_wldev *dev, u32 gain)
+{
+	u16 low_gain = gain & 0xFFFF;
+	u16 high_gain = (gain >> 16) & 0xF;
+	u16 ext_lna = (gain >> 21) & 0x1;
+	u16 trsw = ~(gain >> 21) & 0x1;
+	u16 tmp;
+	//SPEC FIXME is trsw really just ~(bool)ext_lna for rev2+?
+
+	b43_phy_maskset(dev, B43_LPPHY_RF_OVERRIDE_VAL_0, 0xFFFE, trsw);
+	b43_phy_maskset(dev, B43_LPPHY_RF_OVERRIDE_2_VAL,
+			0xFDFF, ext_lna << 9);
+	b43_phy_maskset(dev, B43_LPPHY_RF_OVERRIDE_2_VAL, 
+			0xFBFF, ext_lna << 10);
+	b43_phy_write(dev, B43_LPPHY_RX_GAIN_CTL_OVERRIDE_VAL, low_gain);
+	b43_phy_maskset(dev, B43_LPPHY_AFE_DDFS, 0xFFF0, high_gain);
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+		tmp = (gain >> 2) & 0x3;
+		b43_phy_maskset(dev, B43_LPPHY_RF_OVERRIDE_2_VAL,
+				0xE7FF, tmp<<11);
+		b43_phy_maskset(dev, B43_PHY_OFDM(0xE6), 0xFFE7, tmp << 3);
+	}
+}
+
+static void lpphy_enable_rx_gain_override(struct b43_wldev *dev)
+{
+	b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_0, 0xFFFE);
+	b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_0, 0xFFEF);
+	b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_0, 0xFFBF);
+	if (dev->phy.rev >= 2) {
+		b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_2, 0xFEFF);
+		if (b43_current_band(dev->wl) != IEEE80211_BAND_2GHZ)
+			return;
+		b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_2, 0xFBFF);
+		b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_2, 0xFFF7);
+	} else {
+		b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_2, 0xFDFF);
+	}
+}
+
+static void lpphy_disable_rx_gain_override(struct b43_wldev *dev)
+{
+	b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_0, 0x1);
+	b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_0, 0x10);
+	b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_0, 0x40);
+	if (dev->phy.rev >= 2) {
+		b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_2, 0x100);
+		if (b43_current_band(dev->wl) != IEEE80211_BAND_2GHZ)
+			return;
+		b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_2, 0x400);
+		b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_2, 0x8);
+	} else {
+		b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_2, 0x200);
+	}
+}
+
+static void lpphy_set_rx_gain(struct b43_wldev *dev, u32 gain)
+{
+	if (dev->phy.rev < 2)
+		lpphy_rev0_1_set_rx_gain(dev, gain);
+	else
+		lpphy_rev2plus_set_rx_gain(dev, gain);
+	lpphy_enable_rx_gain_override(dev);
+}
+
+static void lpphy_set_rx_gain_by_index(struct b43_wldev *dev, u16 idx)
+{
+	u32 gain = b43_lptab_read(dev, B43_LPTAB16(12, idx));
+	lpphy_set_rx_gain(dev, gain);
+}
+
+static void lpphy_stop_ddfs(struct b43_wldev *dev)
+{
+	b43_phy_mask(dev, B43_LPPHY_AFE_DDFS, 0xFFFD);
+	b43_phy_mask(dev, B43_LPPHY_LP_PHY_CTL, 0xFFDF);
+}
+
+static void lpphy_run_ddfs(struct b43_wldev *dev, int i_on, int q_on,
+			   int incr1, int incr2, int scale_idx)
+{
+	lpphy_stop_ddfs(dev);
+	b43_phy_mask(dev, B43_LPPHY_AFE_DDFS_POINTER_INIT, 0xFF80);
+	b43_phy_mask(dev, B43_LPPHY_AFE_DDFS_POINTER_INIT, 0x80FF);
+	b43_phy_maskset(dev, B43_LPPHY_AFE_DDFS_INCR_INIT, 0xFF80, incr1);
+	b43_phy_maskset(dev, B43_LPPHY_AFE_DDFS_INCR_INIT, 0x80FF, incr2 << 3);
+	b43_phy_maskset(dev, B43_LPPHY_AFE_DDFS, 0xFFF7, i_on << 3);
+	b43_phy_maskset(dev, B43_LPPHY_AFE_DDFS, 0xFFEF, q_on << 4);
+	b43_phy_maskset(dev, B43_LPPHY_AFE_DDFS, 0xFF9F, scale_idx << 5);
+	b43_phy_mask(dev, B43_LPPHY_AFE_DDFS, 0xFFFB);
+	b43_phy_set(dev, B43_LPPHY_AFE_DDFS, 0x2);
+	b43_phy_set(dev, B43_LPPHY_AFE_DDFS, 0x20);
+}
+
+static bool lpphy_rx_iq_est(struct b43_wldev *dev, u16 samples, u8 time,
+			   struct lpphy_iq_est *iq_est)
+{
+	int i;
+
+	b43_phy_mask(dev, B43_LPPHY_CRSGAIN_CTL, 0xFFF7);
+	b43_phy_write(dev, B43_LPPHY_IQ_NUM_SMPLS_ADDR, samples);
+	b43_phy_maskset(dev, B43_LPPHY_IQ_ENABLE_WAIT_TIME_ADDR, 0xFF00, time);
+	b43_phy_mask(dev, B43_LPPHY_IQ_ENABLE_WAIT_TIME_ADDR, 0xFEFF);
+	b43_phy_set(dev, B43_LPPHY_IQ_ENABLE_WAIT_TIME_ADDR, 0xFDFF);
+
+	for (i = 0; i < 500; i++) {
+		if (!(b43_phy_read(dev,
+				B43_LPPHY_IQ_ENABLE_WAIT_TIME_ADDR) & 0x200))
 			break;
 		msleep(1);
 	}
 
-	if (!(b43_radio_read(dev, B2063_RC_CALIB_CTL6) & 0x2))
-		b43_radio_write(dev, B2063_TX_BB_SP3, tmp);
+	if ((b43_phy_read(dev, B43_LPPHY_IQ_ENABLE_WAIT_TIME_ADDR) & 0x200)) {
+		b43_phy_set(dev, B43_LPPHY_CRSGAIN_CTL, 0x8);
+		return false;
+	}
 
-	b43_radio_write(dev, B2063_RC_CALIB_CTL1, 0x7E);
+	iq_est->iq_prod = b43_phy_read(dev, B43_LPPHY_IQ_ACC_HI_ADDR);
+	iq_est->iq_prod <<= 16;
+	iq_est->iq_prod |= b43_phy_read(dev, B43_LPPHY_IQ_ACC_LO_ADDR);
+
+	iq_est->i_pwr = b43_phy_read(dev, B43_LPPHY_IQ_I_PWR_ACC_HI_ADDR);
+	iq_est->i_pwr <<= 16;
+	iq_est->i_pwr |= b43_phy_read(dev, B43_LPPHY_IQ_I_PWR_ACC_LO_ADDR);
+
+	iq_est->q_pwr = b43_phy_read(dev, B43_LPPHY_IQ_Q_PWR_ACC_HI_ADDR);
+	iq_est->q_pwr <<= 16;
+	iq_est->q_pwr |= b43_phy_read(dev, B43_LPPHY_IQ_Q_PWR_ACC_LO_ADDR);
+
+	b43_phy_set(dev, B43_LPPHY_CRSGAIN_CTL, 0x8);
+	return true;
 }
 
-static void lpphy_calibrate_rc(struct b43_wldev *dev)
+static int lpphy_loopback(struct b43_wldev *dev)
 {
-	struct b43_phy_lp *lpphy = dev->phy.lp;
+	struct lpphy_iq_est iq_est;
+	int i, index = -1;
+	u32 tmp;
+
+	memset(&iq_est, 0, sizeof(iq_est));
+
+	b43_phy_maskset(dev, B43_LPPHY_RF_OVERRIDE_VAL_0, 0xFFFC, 0x3);
+	b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_0, 0x3);
+	b43_phy_mask(dev, B43_LPPHY_AFE_CTL_OVRVAL, 0xFFFE);
+	b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_0, 0x800);
+	b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_VAL_0, 0x800);
+	b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_0, 0x8);
+	b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_VAL_0, 0x8);
+	b43_radio_write(dev, B2062_N_TX_CTL_A, 0x80);
+	b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_0, 0x80);
+	b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_VAL_0, 0x80);
+	for (i = 0; i < 32; i++) {
+		lpphy_set_rx_gain_by_index(dev, i);
+		lpphy_run_ddfs(dev, 1, 1, 5, 5, 0);
+		if (!(lpphy_rx_iq_est(dev, 1000, 32, &iq_est)))
+			continue;
+		tmp = (iq_est.i_pwr + iq_est.q_pwr) / 1000;
+		if ((tmp > 4000) && (tmp < 10000)) {
+			index = i;
+			break;
+		}
+	}
+	lpphy_stop_ddfs(dev);
+	return index;
+}
 
-	if (dev->phy.rev >= 2) {
-		lpphy_rev2plus_rc_calib(dev);
-	} else if (!lpphy->rc_cap) {
-		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
-			lpphy_rev0_1_rc_calib(dev);
+static u32 lpphy_qdiv_roundup(u32 dividend, u32 divisor, u8 precision)
+{
+	u32 quotient, remainder, rbit, roundup, tmp;
+
+	if (divisor == 0) {
+		quotient = 0;
+		remainder = 0;
 	} else {
-		lpphy_set_rc_cap(dev);
+		quotient = dividend / divisor;
+		remainder = dividend % divisor;
 	}
+
+	rbit = divisor & 0x1;
+	roundup = (divisor >> 1) + rbit;
+	precision--;
+
+	while (precision != 0xFF) {
+		tmp = remainder - roundup;
+		quotient <<= 1;
+		remainder <<= 1;
+		if (remainder >= roundup) {
+			remainder = (tmp << 1) + rbit;
+			quotient--;
+		}
+		precision--;
+	}
+
+	if (remainder >= roundup)
+		quotient++;
+
+	return quotient;
 }
 
 /* Read the TX power control mode from hardware. */
@@ -773,6 +1023,170 @@ static void lpphy_set_tx_power_control(struct b43_wldev *dev,
 	lpphy_write_tx_pctl_mode_to_hardware(dev);
 }
 
+static void lpphy_rev0_1_rc_calib(struct b43_wldev *dev)
+{
+	struct b43_phy_lp *lpphy = dev->phy.lp;
+	struct lpphy_iq_est iq_est;
+	struct lpphy_tx_gains tx_gains;
+	static const u32 ideal_pwr_table[22] = {
+		0x10000, 0x10557, 0x10e2d, 0x113e0, 0x10f22, 0x0ff64,
+		0x0eda2, 0x0e5d4, 0x0efd1, 0x0fbe8, 0x0b7b8, 0x04b35,
+		0x01a5e, 0x00a0b, 0x00444, 0x001fd, 0x000ff, 0x00088,
+		0x0004c, 0x0002c, 0x0001a, 0xc0006,
+	};
+	bool old_txg_ovr;
+	u8 old_bbmult;
+	u16 old_rf_ovr, old_rf_ovrval, old_afe_ovr, old_afe_ovrval,
+	    old_rf2_ovr, old_rf2_ovrval, old_phy_ctl, old_txpctl;
+	u32 normal_pwr, ideal_pwr, mean_sq_pwr, tmp = 0, mean_sq_pwr_min = 0;
+	int loopback, i, j, inner_sum;
+
+	memset(&iq_est, 0, sizeof(iq_est));
+
+	b43_switch_channel(dev, 7);
+	old_txg_ovr = (b43_phy_read(dev, B43_LPPHY_AFE_CTL_OVR) >> 6) & 1;
+	old_bbmult = lpphy_get_bb_mult(dev);
+	if (old_txg_ovr)
+		tx_gains = lpphy_get_tx_gains(dev);
+	old_rf_ovr = b43_phy_read(dev, B43_LPPHY_RF_OVERRIDE_0);
+	old_rf_ovrval = b43_phy_read(dev, B43_LPPHY_RF_OVERRIDE_VAL_0);
+	old_afe_ovr = b43_phy_read(dev, B43_LPPHY_AFE_CTL_OVR);
+	old_afe_ovrval = b43_phy_read(dev, B43_LPPHY_AFE_CTL_OVRVAL);
+	old_rf2_ovr = b43_phy_read(dev, B43_LPPHY_RF_OVERRIDE_2);
+	old_rf2_ovrval = b43_phy_read(dev, B43_LPPHY_RF_OVERRIDE_2_VAL);
+	old_phy_ctl = b43_phy_read(dev, B43_LPPHY_LP_PHY_CTL);
+	old_txpctl = b43_phy_read(dev, B43_LPPHY_TX_PWR_CTL_CMD) &
+					B43_LPPHY_TX_PWR_CTL_CMD_MODE;
+ 
+ 	lpphy_set_tx_power_control(dev, B43_LPPHY_TX_PWR_CTL_CMD_MODE_OFF);
+	lpphy_disable_crs(dev);
+	loopback = lpphy_loopback(dev);
+	if (loopback == -1)
+		goto finish;
+	lpphy_set_rx_gain_by_index(dev, loopback);
+	b43_phy_maskset(dev, B43_LPPHY_LP_PHY_CTL, 0xFFBF, 0x40);
+	b43_phy_maskset(dev, B43_LPPHY_RF_OVERRIDE_2_VAL, 0xFFF8, 0x1);
+	b43_phy_maskset(dev, B43_LPPHY_RF_OVERRIDE_2_VAL, 0xFFC7, 0x8);
+	b43_phy_maskset(dev, B43_LPPHY_RF_OVERRIDE_2_VAL, 0xFF3F, 0xC0);
+	for (i = 128; i <= 159; i++) {
+		b43_radio_write(dev, B2062_N_RXBB_CALIB2, i);
+  		inner_sum = 0;
+		for (j = 5; j <= 25; j++) {
+			lpphy_run_ddfs(dev, 1, 1, j, j, 0);
+			if (!(lpphy_rx_iq_est(dev, 1000, 32, &iq_est)))
+				goto finish;
+			mean_sq_pwr = iq_est.i_pwr + iq_est.q_pwr;
+			if (j == 5)
+				tmp = mean_sq_pwr;
+			ideal_pwr = ((ideal_pwr_table[j-5] >> 3) + 1) >> 1;
+			normal_pwr = lpphy_qdiv_roundup(mean_sq_pwr, tmp, 12);
+			mean_sq_pwr = ideal_pwr - normal_pwr;
+			mean_sq_pwr *= mean_sq_pwr;
+			inner_sum += mean_sq_pwr;
+			if ((i = 128) || (inner_sum < mean_sq_pwr_min)) {
+				lpphy->rc_cap = i;
+				mean_sq_pwr_min = inner_sum;
+			}
+		}
+	}
+	lpphy_stop_ddfs(dev);
+
+finish:
+	lpphy_restore_crs(dev);
+	b43_phy_write(dev, B43_LPPHY_RF_OVERRIDE_VAL_0, old_rf_ovrval);
+	b43_phy_write(dev, B43_LPPHY_RF_OVERRIDE_0, old_rf_ovr);
+	b43_phy_write(dev, B43_LPPHY_AFE_CTL_OVRVAL, old_afe_ovrval);
+	b43_phy_write(dev, B43_LPPHY_AFE_CTL_OVR, old_afe_ovr);
+	b43_phy_write(dev, B43_LPPHY_RF_OVERRIDE_2_VAL, old_rf2_ovrval);
+	b43_phy_write(dev, B43_LPPHY_RF_OVERRIDE_2, old_rf2_ovr);
+	b43_phy_write(dev, B43_LPPHY_LP_PHY_CTL, old_phy_ctl);
+
+	lpphy_set_bb_mult(dev, old_bbmult);
+	if (old_txg_ovr) {
+		/*
+		 * SPEC FIXME: The specs say "get_tx_gains" here, which is
+		 * illogical. According to lwfinger, vendor driver v4.150.10.5
+		 * has a Set here, while v4.174.64.19 has a Get - regression in
+		 * the vendor driver? This should be tested this once the code
+		 * is testable.
+		 */
+		lpphy_set_tx_gains(dev, tx_gains);
+	}
+	lpphy_set_tx_power_control(dev, old_txpctl);
+	if (lpphy->rc_cap)
+		lpphy_set_rc_cap(dev);
+}
+
+static void lpphy_rev2plus_rc_calib(struct b43_wldev *dev)
+{
+	struct ssb_bus *bus = dev->dev->bus;
+	u32 crystal_freq = bus->chipco.pmu.crystalfreq * 1000;
+	u8 tmp = b43_radio_read(dev, B2063_RX_BB_SP8) & 0xFF;
+	int i;
+
+	b43_radio_write(dev, B2063_RX_BB_SP8, 0x0);
+	b43_radio_write(dev, B2063_RC_CALIB_CTL1, 0x7E);
+	b43_radio_mask(dev, B2063_PLL_SP1, 0xF7);
+	b43_radio_write(dev, B2063_RC_CALIB_CTL1, 0x7C);
+	b43_radio_write(dev, B2063_RC_CALIB_CTL2, 0x15);
+	b43_radio_write(dev, B2063_RC_CALIB_CTL3, 0x70);
+	b43_radio_write(dev, B2063_RC_CALIB_CTL4, 0x52);
+	b43_radio_write(dev, B2063_RC_CALIB_CTL5, 0x1);
+	b43_radio_write(dev, B2063_RC_CALIB_CTL1, 0x7D);
+
+	for (i = 0; i < 10000; i++) {
+		if (b43_radio_read(dev, B2063_RC_CALIB_CTL6) & 0x2)
+			break;
+		msleep(1);
+	}
+
+	if (!(b43_radio_read(dev, B2063_RC_CALIB_CTL6) & 0x2))
+		b43_radio_write(dev, B2063_RX_BB_SP8, tmp);
+
+	tmp = b43_radio_read(dev, B2063_TX_BB_SP3) & 0xFF;
+
+	b43_radio_write(dev, B2063_TX_BB_SP3, 0x0);
+	b43_radio_write(dev, B2063_RC_CALIB_CTL1, 0x7E);
+	b43_radio_write(dev, B2063_RC_CALIB_CTL1, 0x7C);
+	b43_radio_write(dev, B2063_RC_CALIB_CTL2, 0x55);
+	b43_radio_write(dev, B2063_RC_CALIB_CTL3, 0x76);
+
+	if (crystal_freq == 24000000) {
+		b43_radio_write(dev, B2063_RC_CALIB_CTL4, 0xFC);
+		b43_radio_write(dev, B2063_RC_CALIB_CTL5, 0x0);
+	} else {
+		b43_radio_write(dev, B2063_RC_CALIB_CTL4, 0x13);
+		b43_radio_write(dev, B2063_RC_CALIB_CTL5, 0x1);
+	}
+
+	b43_radio_write(dev, B2063_PA_SP7, 0x7D);
+
+	for (i = 0; i < 10000; i++) {
+		if (b43_radio_read(dev, B2063_RC_CALIB_CTL6) & 0x2)
+			break;
+		msleep(1);
+	}
+
+	if (!(b43_radio_read(dev, B2063_RC_CALIB_CTL6) & 0x2))
+		b43_radio_write(dev, B2063_TX_BB_SP3, tmp);
+
+	b43_radio_write(dev, B2063_RC_CALIB_CTL1, 0x7E);
+}
+
+static void lpphy_calibrate_rc(struct b43_wldev *dev)
+{
+	struct b43_phy_lp *lpphy = dev->phy.lp;
+
+	if (dev->phy.rev >= 2) {
+		lpphy_rev2plus_rc_calib(dev);
+	} else if (!lpphy->rc_cap) {
+		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+			lpphy_rev0_1_rc_calib(dev);
+	} else {
+		lpphy_set_rc_cap(dev);
+	}
+}
+
 static void lpphy_set_tx_power_by_index(struct b43_wldev *dev, u8 index)
 {
 	struct b43_phy_lp *lpphy = dev->phy.lp;
-- 
1.6.2.4



