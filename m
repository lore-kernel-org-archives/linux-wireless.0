Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:39485 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbZHRRSM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 13:18:12 -0400
Received: by fxm11 with SMTP id 11so419845fxm.39
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2009 10:18:12 -0700 (PDT)
Message-ID: <4A8AE255.9030102@gmail.com>
Date: Tue, 18 Aug 2009 19:18:13 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>
CC: Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] b43: LP-PHY: Implement spec updates and remove resolved FIXMEs
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry has started re-checking all current routines against a new
version of the Broadcom MIPS driver. This patch implements the first
round of changes he documented on the specs wiki.

Also remove a few FIXMEs regarding missing initial values for variables
with dynamic initial values where reading the values has been implemented.

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
 drivers/net/wireless/b43/phy_lp.c       |   98 +++++++++++++++++++------------
 drivers/net/wireless/b43/phy_lp.h       |   18 +++---
 drivers/net/wireless/b43/tables_lpphy.c |   12 ++++-
 3 files changed, 82 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index 242338f..6c69cdb 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -719,9 +719,39 @@ static void lpphy_set_bb_mult(struct b43_wldev *dev, u8 bb_mult)
 	b43_lptab_write(dev, B43_LPTAB16(0, 87), (u16)bb_mult << 8);
 }
 
-static void lpphy_disable_crs(struct b43_wldev *dev)
+static void lpphy_set_deaf(struct b43_wldev *dev, bool user)
 {
+	struct b43_phy_lp *lpphy = dev->phy.lp;
+
+	if (user)
+		lpphy->crs_usr_disable = 1;
+	else
+		lpphy->crs_sys_disable = 1;
 	b43_phy_maskset(dev, B43_LPPHY_CRSGAIN_CTL, 0xFF1F, 0x80);
+}
+
+static void lpphy_clear_deaf(struct b43_wldev *dev, bool user)
+{
+	struct b43_phy_lp *lpphy = dev->phy.lp;
+
+	if (user)
+		lpphy->crs_usr_disable = 0;
+	else
+		lpphy->crs_sys_disable = 0;
+
+	if (!lpphy->crs_usr_disable && !lpphy->crs_sys_disable) {
+		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+			b43_phy_maskset(dev, B43_LPPHY_CRSGAIN_CTL,
+					0xFF1F, 0x60);
+		else
+			b43_phy_maskset(dev, B43_LPPHY_CRSGAIN_CTL,
+					0xFF1F, 0x20);
+	}
+}
+
+static void lpphy_disable_crs(struct b43_wldev *dev, bool user)
+{
+	lpphy_set_deaf(dev, user);
 	b43_phy_maskset(dev, B43_LPPHY_RF_OVERRIDE_VAL_0, 0xFFFC, 0x1);
 	b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_0, 0x3);
 	b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_VAL_0, 0xFFFB);
@@ -749,12 +779,9 @@ static void lpphy_disable_crs(struct b43_wldev *dev)
 	b43_phy_write(dev, B43_LPPHY_RF_OVERRIDE_2, 0x3FF);
 }
 
-static void lpphy_restore_crs(struct b43_wldev *dev)
+static void lpphy_restore_crs(struct b43_wldev *dev, bool user)
 {
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
-		b43_phy_maskset(dev, B43_LPPHY_CRSGAIN_CTL, 0xFF1F, 0x60);
-	else
-		b43_phy_maskset(dev, B43_LPPHY_CRSGAIN_CTL, 0xFF1F, 0x20);
+	lpphy_clear_deaf(dev, user);
 	b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_0, 0xFF80);
 	b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_2, 0xFC00);
 }
@@ -800,10 +827,11 @@ static void lpphy_set_tx_gains(struct b43_wldev *dev,
 		b43_phy_maskset(dev, B43_LPPHY_TX_GAIN_CTL_OVERRIDE_VAL,
 				0xF800, rf_gain);
 	} else {
-		pa_gain = b43_phy_read(dev, B43_PHY_OFDM(0xFB)) & 0x7F00;
+		pa_gain = b43_phy_read(dev, B43_PHY_OFDM(0xFB)) & 0x1FC0;
+		pa_gain <<= 2;
 		b43_phy_write(dev, B43_LPPHY_TX_GAIN_CTL_OVERRIDE_VAL,
 			      (gains.pga << 8) | gains.gm);
-		b43_phy_maskset(dev, B43_LPPHY_TX_GAIN_CTL_OVERRIDE_VAL,
+		b43_phy_maskset(dev, B43_PHY_OFDM(0xFB),
 				0x8000, gains.pad | pa_gain);
 		b43_phy_write(dev, B43_PHY_OFDM(0xFC),
 			      (gains.pga << 8) | gains.gm);
@@ -817,7 +845,7 @@ static void lpphy_set_tx_gains(struct b43_wldev *dev,
 		b43_phy_maskset(dev, B43_LPPHY_RF_OVERRIDE_2, 0xFF7F, 1 << 7);
 		b43_phy_maskset(dev, B43_LPPHY_RF_OVERRIDE_2, 0xBFFF, 1 << 14);
 	}
-	b43_phy_maskset(dev, B43_LPPHY_RF_OVERRIDE_2, 0xFFBF, 1 << 6);
+	b43_phy_maskset(dev, B43_LPPHY_AFE_CTL_OVR, 0xFFBF, 1 << 6);
 }
 
 static void lpphy_rev0_1_set_rx_gain(struct b43_wldev *dev, u32 gain)
@@ -857,33 +885,33 @@ static void lpphy_rev2plus_set_rx_gain(struct b43_wldev *dev, u32 gain)
 	}
 }
 
-static void lpphy_enable_rx_gain_override(struct b43_wldev *dev)
+static void lpphy_disable_rx_gain_override(struct b43_wldev *dev)
 {
 	b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_0, 0xFFFE);
 	b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_0, 0xFFEF);
 	b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_0, 0xFFBF);
 	if (dev->phy.rev >= 2) {
 		b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_2, 0xFEFF);
-		if (b43_current_band(dev->wl) != IEEE80211_BAND_2GHZ)
-			return;
-		b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_2, 0xFBFF);
-		b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_2, 0xFFF7);
+		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+			b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_2, 0xFBFF);
+			b43_phy_mask(dev, B43_PHY_OFDM(0xE5), 0xFFF7);
+		}
 	} else {
 		b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_2, 0xFDFF);
 	}
 }
 
-static void lpphy_disable_rx_gain_override(struct b43_wldev *dev)
+static void lpphy_enable_rx_gain_override(struct b43_wldev *dev)
 {
 	b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_0, 0x1);
 	b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_0, 0x10);
 	b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_0, 0x40);
 	if (dev->phy.rev >= 2) {
 		b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_2, 0x100);
-		if (b43_current_band(dev->wl) != IEEE80211_BAND_2GHZ)
-			return;
-		b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_2, 0x400);
-		b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_2, 0x8);
+		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+			b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_2, 0x400);
+			b43_phy_set(dev, B43_PHY_OFDM(0xE5), 0x8);
+		}
 	} else {
 		b43_phy_set(dev, B43_LPPHY_RF_OVERRIDE_2, 0x200);
 	}
@@ -1002,26 +1030,22 @@ static u32 lpphy_qdiv_roundup(u32 dividend, u32 divisor, u8 precision)
 {
 	u32 quotient, remainder, rbit, roundup, tmp;
 
-	if (divisor == 0) {
-		quotient = 0;
-		remainder = 0;
-	} else {
-		quotient = dividend / divisor;
-		remainder = dividend % divisor;
-	}
+	if (divisor == 0)
+		return 0;
+
+	quotient = dividend / divisor;
+	remainder = dividend % divisor;
 
 	rbit = divisor & 0x1;
 	roundup = (divisor >> 1) + rbit;
-	precision--;
 
-	while (precision != 0xFF) {
+	while (precision != 0) {
 		tmp = remainder - roundup;
 		quotient <<= 1;
-		remainder <<= 1;
-		if (remainder >= roundup) {
+		if (remainder >= roundup)
 			remainder = (tmp << 1) + rbit;
-			quotient--;
-		}
+		else
+			remainder <<= 1;
 		precision--;
 	}
 
@@ -1123,11 +1147,11 @@ static void lpphy_rev0_1_rc_calib(struct b43_wldev *dev)
 	struct b43_phy_lp *lpphy = dev->phy.lp;
 	struct lpphy_iq_est iq_est;
 	struct lpphy_tx_gains tx_gains;
-	static const u32 ideal_pwr_table[22] = {
+	static const u32 ideal_pwr_table[21] = {
 		0x10000, 0x10557, 0x10e2d, 0x113e0, 0x10f22, 0x0ff64,
 		0x0eda2, 0x0e5d4, 0x0efd1, 0x0fbe8, 0x0b7b8, 0x04b35,
 		0x01a5e, 0x00a0b, 0x00444, 0x001fd, 0x000ff, 0x00088,
-		0x0004c, 0x0002c, 0x0001a, 0xc0006,
+		0x0004c, 0x0002c, 0x0001a,
 	};
 	bool old_txg_ovr;
 	u8 old_bbmult;
@@ -1145,7 +1169,7 @@ static void lpphy_rev0_1_rc_calib(struct b43_wldev *dev)
 		       "RC calib: Failed to switch to channel 7, error = %d",
 		       err);
 	}
-	old_txg_ovr = (b43_phy_read(dev, B43_LPPHY_AFE_CTL_OVR) >> 6) & 1;
+	old_txg_ovr = !!(b43_phy_read(dev, B43_LPPHY_AFE_CTL_OVR) & 0x40);
 	old_bbmult = lpphy_get_bb_mult(dev);
 	if (old_txg_ovr)
 		tx_gains = lpphy_get_tx_gains(dev);
@@ -1160,7 +1184,7 @@ static void lpphy_rev0_1_rc_calib(struct b43_wldev *dev)
 	old_txpctl = lpphy->txpctl_mode;
 
 	lpphy_set_tx_power_control(dev, B43_LPPHY_TXPCTL_OFF);
-	lpphy_disable_crs(dev);
+	lpphy_disable_crs(dev, true);
 	loopback = lpphy_loopback(dev);
 	if (loopback == -1)
 		goto finish;
@@ -1193,7 +1217,7 @@ static void lpphy_rev0_1_rc_calib(struct b43_wldev *dev)
 	lpphy_stop_ddfs(dev);
 
 finish:
-	lpphy_restore_crs(dev);
+	lpphy_restore_crs(dev, true);
 	b43_phy_write(dev, B43_LPPHY_RF_OVERRIDE_VAL_0, old_rf_ovrval);
 	b43_phy_write(dev, B43_LPPHY_RF_OVERRIDE_0, old_rf_ovr);
 	b43_phy_write(dev, B43_LPPHY_AFE_CTL_OVRVAL, old_afe_ovrval);
diff --git a/drivers/net/wireless/b43/phy_lp.h b/drivers/net/wireless/b43/phy_lp.h
index 99cb038..e158d1f 100644
--- a/drivers/net/wireless/b43/phy_lp.h
+++ b/drivers/net/wireless/b43/phy_lp.h
@@ -825,11 +825,11 @@ struct b43_phy_lp {
 	enum b43_lpphy_txpctl_mode txpctl_mode;
 
 	/* Transmit isolation medium band */
-	u8 tx_isolation_med_band; /* FIXME initial value? */
+	u8 tx_isolation_med_band;
 	/* Transmit isolation low band */
-	u8 tx_isolation_low_band; /* FIXME initial value? */
+	u8 tx_isolation_low_band;
 	/* Transmit isolation high band */
-	u8 tx_isolation_hi_band; /* FIXME initial value? */
+	u8 tx_isolation_hi_band;
 
 	/* Max transmit power medium band */
 	u16 max_tx_pwr_med_band;
@@ -848,7 +848,7 @@ struct b43_phy_lp {
 	s16 txpa[3], txpal[3], txpah[3];
 
 	/* Receive power offset */
-	u8 rx_pwr_offset; /* FIXME initial value? */
+	u8 rx_pwr_offset;
 
 	/* TSSI transmit count */
 	u16 tssi_tx_count;
@@ -864,16 +864,16 @@ struct b43_phy_lp {
 	s8 tx_pwr_idx_over; /* FIXME initial value? */
 
 	/* RSSI vf */
-	u8 rssi_vf; /* FIXME initial value? */
+	u8 rssi_vf;
 	/* RSSI vc */
-	u8 rssi_vc; /* FIXME initial value? */
+	u8 rssi_vc;
 	/* RSSI gs */
-	u8 rssi_gs; /* FIXME initial value? */
+	u8 rssi_gs;
 
 	/* RC cap */
 	u8 rc_cap; /* FIXME initial value? */
 	/* BX arch */
-	u8 bx_arch; /* FIXME initial value? */
+	u8 bx_arch;
 
 	/* Full calibration channel */
 	u8 full_calib_chan; /* FIXME initial value? */
@@ -885,6 +885,8 @@ struct b43_phy_lp {
 	/* Used for "Save/Restore Dig Filt State" */
 	u16 dig_flt_state[9];
 
+	bool crs_usr_disable, crs_sys_disable;
+
 	unsigned int pdiv;
 };
 
diff --git a/drivers/net/wireless/b43/tables_lpphy.c b/drivers/net/wireless/b43/tables_lpphy.c
index 2721310..60d472f 100644
--- a/drivers/net/wireless/b43/tables_lpphy.c
+++ b/drivers/net/wireless/b43/tables_lpphy.c
@@ -2367,7 +2367,17 @@ static void lpphy_rev2plus_write_gain_table(struct b43_wldev *dev, int offset,
 	tmp  = data.pad << 16;
 	tmp |= data.pga << 8;
 	tmp |= data.gm;
-	tmp |= 0x7f000000;
+	if (dev->phy.rev >= 3) {
+		if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ)
+			tmp |= 0x10 << 24;
+		else
+			tmp |= 0x70 << 24;
+	} else {
+		if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ)
+			tmp |= 0x14 << 24;
+		else
+			tmp |= 0x7F << 24;
+	}
 	b43_lptab_write(dev, B43_LPTAB32(7, 0xC0 + offset), tmp);
 	tmp  = data.bb_mult << 20;
 	tmp |= data.dac << 28;
-- 
1.6.2.4



