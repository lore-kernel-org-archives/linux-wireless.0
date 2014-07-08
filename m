Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:47598 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbaGHNLg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2014 09:11:36 -0400
Received: by mail-we0-f180.google.com with SMTP id x48so5923140wes.39
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jul 2014 06:11:30 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/7] b43: N-PHY: add placeholders for new devices support
Date: Tue,  8 Jul 2014 15:11:06 +0200
Message-Id: <1404825070-5243-3-git-send-email-zajec5@gmail.com> (sfid-20140708_151140_637467_0DDA4DDB)
In-Reply-To: <1404825070-5243-1-git-send-email-zajec5@gmail.com>
References: <1404825070-5243-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c | 285 +++++++++++++++++++++++++++++++--------
 1 file changed, 231 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 1dba640..4bb4d0a 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -140,11 +140,19 @@ ok:
 	b43_phy_write(dev, B43_NPHY_RFSEQMODE, seq_mode);
 }
 
+static void b43_nphy_rf_ctl_override_rev19(struct b43_wldev *dev, u16 field,
+					   u16 value, u8 core, bool off,
+					   u8 override_id)
+{
+	/* TODO */
+}
+
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RFCtrlOverrideRev7 */
 static void b43_nphy_rf_ctl_override_rev7(struct b43_wldev *dev, u16 field,
 					  u16 value, u8 core, bool off,
 					  u8 override)
 {
+	struct b43_phy *phy = &dev->phy;
 	const struct nphy_rf_control_override_rev7 *e;
 	u16 en_addrs[3][2] = {
 		{ 0x0E7, 0x0EC }, { 0x342, 0x343 }, { 0x346, 0x347 }
@@ -154,6 +162,11 @@ static void b43_nphy_rf_ctl_override_rev7(struct b43_wldev *dev, u16 field,
 	u16 val_addr;
 	u8 i;
 
+	if (phy->rev >= 19 || phy->rev < 3) {
+		B43_WARN_ON(1);
+		return;
+	}
+
 	/* Remember: we can get NULL! */
 	e = b43_nphy_get_rf_ctl_over_rev7(dev, field, override);
 
@@ -264,6 +277,8 @@ static void b43_nphy_rf_ctl_intc_override_rev7(struct b43_wldev *dev,
 	u16 reg, tmp, tmp2, val;
 	int core;
 
+	/* TODO: What about rev19+? Revs 3+ and 7+ are a bit similar */
+
 	for (core = 0; core < 2; core++) {
 		if ((core_sel == 1 && core != 0) ||
 		    (core_sel == 2 && core != 1))
@@ -1386,6 +1401,7 @@ static void b43_nphy_run_samples(struct b43_wldev *dev, u16 samps, u16 loops,
 				 u16 wait, bool iqmode, bool dac_test,
 				 bool modify_bbmult)
 {
+	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_n *nphy = dev->phy.n;
 	int i;
 	u16 seq_mode;
@@ -1393,6 +1409,10 @@ static void b43_nphy_run_samples(struct b43_wldev *dev, u16 samps, u16 loops,
 
 	b43_nphy_stay_in_carrier_search(dev, true);
 
+	if (phy->rev >= 7) {
+		/* TODO */
+	}
+
 	if ((nphy->bb_mult_save & 0x80000000) == 0) {
 		tmp = b43_ntab_read(dev, B43_NTAB16(15, 87));
 		nphy->bb_mult_save = (tmp & 0xFFFF) | 0x80000000;
@@ -1520,6 +1540,12 @@ static void b43_nphy_scale_offset_rssi(struct b43_wldev *dev, u16 scale,
 	}
 }
 
+static void b43_nphy_rssi_select_rev19(struct b43_wldev *dev, u8 code,
+				       enum n_rssi_type rssi_type)
+{
+	/* TODO */
+}
+
 static void b43_nphy_rev3_rssi_select(struct b43_wldev *dev, u8 code,
 				      enum n_rssi_type rssi_type)
 {
@@ -1589,13 +1615,15 @@ static void b43_nphy_rev3_rssi_select(struct b43_wldev *dev, u8 code,
 					enum ieee80211_band band =
 						b43_current_band(dev->wl);
 
-					if (b43_nphy_ipa(dev))
-						val = (band == IEEE80211_BAND_5GHZ) ? 0xC : 0xE;
-					else
-						val = 0x11;
-					reg = (i == 0) ? 0x2000 : 0x3000;
-					reg |= B2055_PADDRV;
-					b43_radio_write(dev, reg, val);
+					if (dev->phy.rev < 7) {
+						if (b43_nphy_ipa(dev))
+							val = (band == IEEE80211_BAND_5GHZ) ? 0xC : 0xE;
+						else
+							val = 0x11;
+						reg = (i == 0) ? B2056_TX0 : B2056_TX1;
+						reg |= B2056_TX_TX_SSI_MUX;
+						b43_radio_write(dev, reg, val);
+					}
 
 					reg = (i == 0) ?
 						B43_NPHY_AFECTL_OVER1 :
@@ -1682,7 +1710,9 @@ static void b43_nphy_rev2_rssi_select(struct b43_wldev *dev, u8 code,
 static void b43_nphy_rssi_select(struct b43_wldev *dev, u8 code,
 				 enum n_rssi_type type)
 {
-	if (dev->phy.rev >= 3)
+	if (dev->phy.rev >= 19)
+		b43_nphy_rssi_select_rev19(dev, code, type);
+	else if (dev->phy.rev >= 3)
 		b43_nphy_rev3_rssi_select(dev, code, type);
 	else
 		b43_nphy_rev2_rssi_select(dev, code, type);
@@ -1726,6 +1756,8 @@ static int b43_nphy_poll_rssi(struct b43_wldev *dev, enum n_rssi_type rssi_type,
 	u16 save_regs_phy[9];
 	u16 s[2];
 
+	/* TODO: rev7+ is treated like rev3+, what about rev19+? */
+
 	if (dev->phy.rev >= 3) {
 		save_regs_phy[0] = b43_phy_read(dev, B43_NPHY_AFECTL_C1);
 		save_regs_phy[1] = b43_phy_read(dev, B43_NPHY_AFECTL_C2);
@@ -2209,7 +2241,9 @@ static void b43_nphy_rev2_rssi_cal(struct b43_wldev *dev, enum n_rssi_type type)
  */
 static void b43_nphy_rssi_cal(struct b43_wldev *dev)
 {
-	if (dev->phy.rev >= 3) {
+	if (dev->phy.rev >= 19) {
+		/* TODO */
+	} else if (dev->phy.rev >= 3) {
 		b43_nphy_rev3_rssi_cal(dev);
 	} else {
 		b43_nphy_rev2_rssi_cal(dev, N_RSSI_NB);
@@ -2222,7 +2256,21 @@ static void b43_nphy_rssi_cal(struct b43_wldev *dev)
  * Workarounds
  **************************************************/
 
-static void b43_nphy_gain_ctl_workarounds_rev3plus(struct b43_wldev *dev)
+static void b43_nphy_gain_ctl_workarounds_rev19(struct b43_wldev *dev)
+{
+	/* TODO */
+}
+
+static void b43_nphy_gain_ctl_workarounds_rev7(struct b43_wldev *dev)
+{
+	struct b43_phy *phy = &dev->phy;
+
+	switch (phy->rev) {
+	/* TODO */
+	}
+}
+
+static void b43_nphy_gain_ctl_workarounds_rev3(struct b43_wldev *dev)
 {
 	struct ssb_sprom *sprom = dev->dev->bus_sprom;
 
@@ -2419,10 +2467,12 @@ static void b43_nphy_gain_ctl_workarounds_rev1_2(struct b43_wldev *dev)
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/WorkaroundsGainCtrl */
 static void b43_nphy_gain_ctl_workarounds(struct b43_wldev *dev)
 {
-	if (dev->phy.rev >= 7)
-		; /* TODO */
+	if (dev->phy.rev >= 19)
+		b43_nphy_gain_ctl_workarounds_rev19(dev);
+	else if (dev->phy.rev >= 7)
+		b43_nphy_gain_ctl_workarounds_rev7(dev);
 	else if (dev->phy.rev >= 3)
-		b43_nphy_gain_ctl_workarounds_rev3plus(dev);
+		b43_nphy_gain_ctl_workarounds_rev3(dev);
 	else
 		b43_nphy_gain_ctl_workarounds_rev1_2(dev);
 }
@@ -3059,6 +3109,7 @@ static void b43_nphy_workarounds(struct b43_wldev *dev)
 	b43_phy_set(dev, B43_NPHY_IQFLIP,
 		    B43_NPHY_IQFLIP_ADC1 | B43_NPHY_IQFLIP_ADC2);
 
+	/* TODO: rev19+ */
 	if (dev->phy.rev >= 7)
 		b43_nphy_workarounds_rev7plus(dev);
 	else if (dev->phy.rev >= 3)
@@ -3140,6 +3191,10 @@ static void b43_nphy_stop_playback(struct b43_wldev *dev)
 		nphy->bb_mult_save = 0;
 	}
 
+	if (dev->phy.rev >= 7) {
+		/* TODO */
+	}
+
 	if (nphy->hang_avoid)
 		b43_nphy_stay_in_carrier_search(dev, 0);
 }
@@ -3149,6 +3204,7 @@ static void b43_nphy_iq_cal_gain_params(struct b43_wldev *dev, u16 core,
 					struct nphy_txgains target,
 					struct nphy_iqcal_params *params)
 {
+	struct b43_phy *phy = &dev->phy;
 	int i, j, indx;
 	u16 gain;
 
@@ -3157,8 +3213,13 @@ static void b43_nphy_iq_cal_gain_params(struct b43_wldev *dev, u16 core,
 		params->pga = target.pga[core];
 		params->pad = target.pad[core];
 		params->ipa = target.ipa[core];
-		params->cal_gain = (params->txgm << 12) | (params->pga << 8) |
-					(params->pad << 4) | (params->ipa);
+		if (phy->rev >= 19) {
+			/* TODO */
+		} else if (phy->rev >= 7) {
+			/* TODO */
+		} else {
+			params->cal_gain = (params->txgm << 12) | (params->pga << 8) | (params->pad << 4) | (params->ipa);
+		}
 		for (j = 0; j < 5; j++)
 			params->ncorr[j] = 0x79;
 	} else {
@@ -3199,6 +3260,7 @@ static enum b43_txpwr_result b43_nphy_op_recalc_txpower(struct b43_wldev *dev,
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxPwrCtrlEnable */
 static void b43_nphy_tx_power_ctrl(struct b43_wldev *dev, bool enable)
 {
+	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_n *nphy = dev->phy.n;
 	u8 i;
 	u16 bmask, val, tmp;
@@ -3268,12 +3330,20 @@ static void b43_nphy_tx_power_ctrl(struct b43_wldev *dev, bool enable)
 		b43_phy_maskset(dev, B43_NPHY_TXPCTL_CMD, ~(bmask), val);
 
 		if (band == IEEE80211_BAND_5GHZ) {
-			b43_phy_maskset(dev, B43_NPHY_TXPCTL_CMD,
-					~B43_NPHY_TXPCTL_CMD_INIT, 0x64);
-			if (dev->phy.rev > 1)
-				b43_phy_maskset(dev, B43_NPHY_TXPCTL_INIT,
-						~B43_NPHY_TXPCTL_INIT_PIDXI1,
+			if (phy->rev >= 19) {
+				/* TODO */
+			} else if (phy->rev >= 7) {
+				/* TODO */
+			} else {
+				b43_phy_maskset(dev, B43_NPHY_TXPCTL_CMD,
+						~B43_NPHY_TXPCTL_CMD_INIT,
 						0x64);
+				if (phy->rev > 1)
+					b43_phy_maskset(dev,
+							B43_NPHY_TXPCTL_INIT,
+							~B43_NPHY_TXPCTL_INIT_PIDXI1,
+							0x64);
+			}
 		}
 
 		if (dev->phy.rev >= 3) {
@@ -3290,6 +3360,10 @@ static void b43_nphy_tx_power_ctrl(struct b43_wldev *dev, bool enable)
 			}
 		}
 
+		if (phy->rev >= 7) {
+			/* TODO */
+		}
+
 		if (dev->phy.rev >= 3) {
 			b43_phy_mask(dev, B43_NPHY_AFECTL_OVER1, ~0x100);
 			b43_phy_mask(dev, B43_NPHY_AFECTL_OVER, ~0x100);
@@ -3331,6 +3405,7 @@ static void b43_nphy_tx_power_fix(struct b43_wldev *dev)
 	if (nphy->hang_avoid)
 		b43_nphy_stay_in_carrier_search(dev, 1);
 
+	/* TODO: rev19+ */
 	if (dev->phy.rev >= 7) {
 		txpi[0] = txpi[1] = 30;
 	} else if (dev->phy.rev >= 3) {
@@ -3433,7 +3508,9 @@ static void b43_nphy_ipa_internal_tssi_setup(struct b43_wldev *dev)
 	u8 core;
 	u16 r; /* routing */
 
-	if (phy->rev >= 7) {
+	if (phy->rev >= 19) {
+		/* TODO */
+	} else if (phy->rev >= 7) {
 		for (core = 0; core < 2; core++) {
 			r = core ? 0x190 : 0x170;
 			if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
@@ -3521,7 +3598,9 @@ static void b43_nphy_tx_power_ctl_idle_tssi(struct b43_wldev *dev)
 	if (b43_nphy_ipa(dev))
 		b43_nphy_ipa_internal_tssi_setup(dev);
 
-	if (phy->rev >= 7)
+	if (phy->rev >= 19)
+		b43_nphy_rf_ctl_override_rev19(dev, 0x2000, 0, 3, false, 0);
+	else if (phy->rev >= 7)
 		b43_nphy_rf_ctl_override_rev7(dev, 0x2000, 0, 3, false, 0);
 	else if (phy->rev >= 3)
 		b43_nphy_rf_ctl_override(dev, 0x2000, 0, 3, false);
@@ -3531,14 +3610,20 @@ static void b43_nphy_tx_power_ctl_idle_tssi(struct b43_wldev *dev)
 	udelay(20);
 	tmp = b43_nphy_poll_rssi(dev, N_RSSI_TSSI_2G, rssi, 1);
 	b43_nphy_stop_playback(dev);
+
 	b43_nphy_rssi_select(dev, 0, N_RSSI_W1);
 
-	if (phy->rev >= 7)
+	if (phy->rev >= 19)
+		b43_nphy_rf_ctl_override_rev19(dev, 0x2000, 0, 3, true, 0);
+	else if (phy->rev >= 7)
 		b43_nphy_rf_ctl_override_rev7(dev, 0x2000, 0, 3, true, 0);
 	else if (phy->rev >= 3)
 		b43_nphy_rf_ctl_override(dev, 0x2000, 0, 3, true);
 
-	if (phy->rev >= 3) {
+	if (phy->rev >= 19) {
+		/* TODO */
+		return;
+	} else if (phy->rev >= 3) {
 		nphy->pwr_ctl_info[0].idle_tssi_5g = (tmp >> 24) & 0xFF;
 		nphy->pwr_ctl_info[1].idle_tssi_5g = (tmp >> 8) & 0xFF;
 	} else {
@@ -3730,7 +3815,9 @@ static void b43_nphy_tx_power_ctl_setup(struct b43_wldev *dev)
 		udelay(1);
 	}
 
-	if (dev->phy.rev >= 7) {
+	if (phy->rev >= 19) {
+		/* TODO */
+	} else if (phy->rev >= 7) {
 		b43_phy_maskset(dev, B43_NPHY_TXPCTL_CMD,
 				~B43_NPHY_TXPCTL_CMD_INIT, 0x19);
 		b43_phy_maskset(dev, B43_NPHY_TXPCTL_INIT,
@@ -3793,24 +3880,30 @@ static void b43_nphy_tx_gain_table_upload(struct b43_wldev *dev)
 	b43_ntab_write_bulk(dev, B43_NTAB32(26, 192), 128, table);
 	b43_ntab_write_bulk(dev, B43_NTAB32(27, 192), 128, table);
 
-	if (phy->rev >= 3) {
+	if (phy->rev < 3)
+		return;
+
 #if 0
-		nphy->gmval = (table[0] >> 16) & 0x7000;
+	nphy->gmval = (table[0] >> 16) & 0x7000;
 #endif
 
-		for (i = 0; i < 128; i++) {
+	for (i = 0; i < 128; i++) {
+		if (phy->rev >= 19) {
+			/* TODO */
+			return;
+		} else if (phy->rev >= 7) {
+			/* TODO */
+			return;
+		} else {
 			pga_gain = (table[i] >> 24) & 0xF;
 			if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
-				rfpwr_offset =
-				 b43_ntab_papd_pga_gain_delta_ipa_2g[pga_gain];
+				rfpwr_offset = b43_ntab_papd_pga_gain_delta_ipa_2g[pga_gain];
 			else
-				rfpwr_offset =
-				 0; /* FIXME */
-			b43_ntab_write(dev, B43_NTAB32(26, 576 + i),
-				       rfpwr_offset);
-			b43_ntab_write(dev, B43_NTAB32(27, 576 + i),
-				       rfpwr_offset);
+				rfpwr_offset = 0; /* FIXME */
 		}
+
+		b43_ntab_write(dev, B43_NTAB32(26, 576 + i), rfpwr_offset);
+		b43_ntab_write(dev, B43_NTAB32(27, 576 + i), rfpwr_offset);
 	}
 }
 
@@ -3827,7 +3920,10 @@ static void b43_nphy_pa_override(struct b43_wldev *dev, bool enable)
 		nphy->rfctrl_intc2_save = b43_phy_read(dev,
 						       B43_NPHY_RFCTL_INTC2);
 		band = b43_current_band(dev->wl);
-		if (dev->phy.rev >= 3) {
+		if (dev->phy.rev >= 7) {
+			/* TODO */
+			return;
+		} else if (dev->phy.rev >= 3) {
 			if (band == IEEE80211_BAND_5GHZ)
 				tmp = 0x600;
 			else
@@ -4274,7 +4370,10 @@ static void b43_nphy_restore_rssi_cal(struct b43_wldev *dev)
 		rssical_phy_regs = nphy->rssical_cache.rssical_phy_regs_5G;
 	}
 
-	if (dev->phy.rev >= 7) {
+	if (dev->phy.rev >= 19) {
+		/* TODO */
+	} else if (dev->phy.rev >= 7) {
+		/* TODO */
 	} else {
 		b43_radio_maskset(dev, B2056_RX0 | B2056_RX_RSSI_MISC, 0xE3,
 				  rssical_radio_regs[0]);
@@ -4298,15 +4397,30 @@ static void b43_nphy_restore_rssi_cal(struct b43_wldev *dev)
 	b43_phy_write(dev, B43_NPHY_RSSIMC_1Q_RSSI_Y, rssical_phy_regs[11]);
 }
 
+static void b43_nphy_tx_cal_radio_setup_rev19(struct b43_wldev *dev)
+{
+	/* TODO */
+}
+
+static void b43_nphy_tx_cal_radio_setup_rev7(struct b43_wldev *dev)
+{
+	/* TODO */
+}
+
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxCalRadioSetup */
 static void b43_nphy_tx_cal_radio_setup(struct b43_wldev *dev)
 {
+	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_n *nphy = dev->phy.n;
 	u16 *save = nphy->tx_rx_cal_radio_saveregs;
 	u16 tmp;
 	u8 offset, i;
 
-	if (dev->phy.rev >= 3) {
+	if (phy->rev >= 19) {
+		b43_nphy_tx_cal_radio_setup_rev19(dev);
+	} else if (phy->rev >= 7) {
+		b43_nphy_tx_cal_radio_setup_rev7(dev);
+	} else if (phy->rev >= 3) {
 	    for (i = 0; i < 2; i++) {
 		tmp = (i == 0) ? 0x2000 : 0x3000;
 		offset = i * 11;
@@ -4547,6 +4661,7 @@ static void b43_nphy_tx_cal_phy_cleanup(struct b43_wldev *dev)
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxCalPhySetup */
 static void b43_nphy_tx_cal_phy_setup(struct b43_wldev *dev)
 {
+	struct b43_phy *phy = &dev->phy;
 	u16 *regs = dev->phy.n->tx_rx_cal_phy_saveregs;
 	u16 tmp;
 
@@ -4586,6 +4701,21 @@ static void b43_nphy_tx_cal_phy_setup(struct b43_wldev *dev)
 		regs[10] = b43_phy_read(dev, B43_NPHY_PAPD_EN1);
 		b43_phy_mask(dev, B43_NPHY_PAPD_EN0, ~0x0001);
 		b43_phy_mask(dev, B43_NPHY_PAPD_EN1, ~0x0001);
+
+		if (phy->rev >= 19)
+			; /* TODO */
+		else if (phy->rev >= 7)
+			; /* TODO */
+
+		if (0 /* FIXME */) {
+			if (phy->rev >= 19) {
+				/* TODO */
+			} else if (phy->rev >= 8) {
+				/* TODO */
+			} else if (phy->rev == 7) {
+				/* TODO */
+			}
+		}
 	} else {
 		b43_phy_maskset(dev, B43_NPHY_AFECTL_C1, 0x0FFF, 0xA000);
 		b43_phy_maskset(dev, B43_NPHY_AFECTL_C2, 0x0FFF, 0xA000);
@@ -4614,6 +4744,7 @@ static void b43_nphy_tx_cal_phy_setup(struct b43_wldev *dev)
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/SaveCal */
 static void b43_nphy_save_cal(struct b43_wldev *dev)
 {
+	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_n *nphy = dev->phy.n;
 
 	struct b43_phy_n_iq_comp *rxcal_coeffs = NULL;
@@ -4638,7 +4769,11 @@ static void b43_nphy_save_cal(struct b43_wldev *dev)
 
 	b43_nphy_rx_iq_coeffs(dev, false, rxcal_coeffs);
 	/* TODO use some definitions */
-	if (dev->phy.rev >= 3) {
+	if (phy->rev >= 19) {
+		/* TODO */
+	} else if (phy->rev >= 7) {
+		/* TODO */
+	} else if (phy->rev >= 3) {
 		txcal_radio_regs[0] = b43_radio_read(dev, 0x2021);
 		txcal_radio_regs[1] = b43_radio_read(dev, 0x2022);
 		txcal_radio_regs[2] = b43_radio_read(dev, 0x3021);
@@ -4665,6 +4800,7 @@ static void b43_nphy_save_cal(struct b43_wldev *dev)
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RestoreCal */
 static void b43_nphy_restore_cal(struct b43_wldev *dev)
 {
+	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_n *nphy = dev->phy.n;
 
 	u16 coef[4];
@@ -4712,7 +4848,11 @@ static void b43_nphy_restore_cal(struct b43_wldev *dev)
 	}
 
 	/* TODO use some definitions */
-	if (dev->phy.rev >= 3) {
+	if (phy->rev >= 19) {
+		/* TODO */
+	} else if (phy->rev >= 7) {
+		/* TODO */
+	} else if (phy->rev >= 3) {
 		b43_radio_write(dev, 0x2021, txcal_radio_regs[0]);
 		b43_radio_write(dev, 0x2022, txcal_radio_regs[1]);
 		b43_radio_write(dev, 0x3021, txcal_radio_regs[2]);
@@ -4789,7 +4929,13 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,
 		}
 	}
 
-	b43_phy_write(dev, B43_NPHY_IQLOCAL_CMDGCTL, 0x8AA9);
+	if (phy->rev >= 19) {
+		/* TODO */
+	} else if (phy->rev >= 7) {
+		/* TODO */
+	} else {
+		b43_phy_write(dev, B43_NPHY_IQLOCAL_CMDGCTL, 0x8AA9);
+	}
 
 	if (!b43_is_40mhz(dev))
 		freq = 2500;
@@ -5183,6 +5329,9 @@ static int b43_nphy_rev3_cal_rx_iq(struct b43_wldev *dev,
 static int b43_nphy_cal_rx_iq(struct b43_wldev *dev,
 			struct nphy_txgains target, u8 type, bool debug)
 {
+	if (dev->phy.rev >= 7)
+		type = 0;
+
 	if (dev->phy.rev >= 3)
 		return b43_nphy_rev3_cal_rx_iq(dev, target, type, debug);
 	else
@@ -5269,6 +5418,9 @@ static void b43_nphy_bphy_init(struct b43_wldev *dev)
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/SuperSwitchInit */
 static void b43_nphy_superswitch_init(struct b43_wldev *dev, bool init)
 {
+	if (dev->phy.rev >= 7)
+		return;
+
 	if (dev->phy.rev >= 3) {
 		if (!init)
 			return;
@@ -5353,6 +5505,13 @@ static int b43_phy_initn(struct b43_wldev *dev)
 	if (dev->phy.rev >= 3) {
 		b43_phy_write(dev, B43_NPHY_TXF_40CO_B1S1, 0);
 		b43_phy_write(dev, B43_NPHY_RFCTL_OVER, 0);
+		if (phy->rev >= 7) {
+			/* TODO */
+		}
+		if (phy->rev >= 19) {
+			/* TODO */
+		}
+
 		b43_phy_write(dev, B43_NPHY_TXF_40CO_B1S0, 0);
 		b43_phy_write(dev, B43_NPHY_TXF_40CO_B32S1, 0);
 	} else {
@@ -5390,7 +5549,9 @@ static int b43_phy_initn(struct b43_wldev *dev)
 	b43_phy_write(dev, B43_NPHY_PLOAD_CSENSE_EXTLEN, 0x50);
 	b43_phy_write(dev, B43_NPHY_TXRIFS_FRDEL, 0x30);
 
-	b43_nphy_update_mimo_config(dev, nphy->preamble_override);
+	if (phy->rev < 8)
+		b43_nphy_update_mimo_config(dev, nphy->preamble_override);
+
 	b43_nphy_update_txrx_chain(dev);
 
 	if (phy->rev < 2) {
@@ -5422,10 +5583,12 @@ static int b43_phy_initn(struct b43_wldev *dev)
 
 	b43_mac_phy_clock_set(dev, true);
 
-	b43_nphy_pa_override(dev, false);
-	b43_nphy_force_rf_sequence(dev, B43_RFSEQ_RX2TX);
-	b43_nphy_force_rf_sequence(dev, B43_RFSEQ_RESET2RX);
-	b43_nphy_pa_override(dev, true);
+	if (phy->rev < 7) {
+		b43_nphy_pa_override(dev, false);
+		b43_nphy_force_rf_sequence(dev, B43_RFSEQ_RX2TX);
+		b43_nphy_force_rf_sequence(dev, B43_RFSEQ_RESET2RX);
+		b43_nphy_pa_override(dev, true);
+	}
 
 	b43_nphy_classifier(dev, 0, 0);
 	b43_nphy_read_clip_detection(dev, clip);
@@ -5644,7 +5807,10 @@ static int b43_nphy_set_channel(struct b43_wldev *dev,
 
 	u8 tmp;
 
-	if (phy->rev >= 7) {
+	if (phy->rev >= 19) {
+		return -ESRCH;
+		/* TODO */
+	} else if (phy->rev >= 7) {
 		r2057_get_chantabent_rev7(dev, channel->center_freq,
 					  &tabent_r7, &tabent_r7_2g);
 		if (!tabent_r7 && !tabent_r7_2g)
@@ -5681,7 +5847,9 @@ static int b43_nphy_set_channel(struct b43_wldev *dev,
 			b43_phy_mask(dev, 0x310, (u16)~0x8000);
 	}
 
-	if (phy->rev >= 7) {
+	if (phy->rev >= 19) {
+		/* TODO */
+	} else if (phy->rev >= 7) {
 		const struct b43_phy_n_sfo_cfg *phy_regs = tabent_r7 ?
 			&(tabent_r7->phy_regs) : &(tabent_r7_2g->phy_regs);
 
@@ -5858,15 +6026,19 @@ static void b43_nphy_op_radio_write(struct b43_wldev *dev, u16 reg, u16 value)
 static void b43_nphy_op_software_rfkill(struct b43_wldev *dev,
 					bool blocked)
 {
+	struct b43_phy *phy = &dev->phy;
+
 	if (b43_read32(dev, B43_MMIO_MACCTL) & B43_MACCTL_ENABLED)
 		b43err(dev->wl, "MAC not suspended\n");
 
 	if (blocked) {
 		b43_phy_mask(dev, B43_NPHY_RFCTL_CMD,
 				~B43_NPHY_RFCTL_CMD_CHIP0PU);
-		if (dev->phy.rev >= 7) {
+		if (phy->rev >= 19) {
 			/* TODO */
-		} else if (dev->phy.rev >= 3) {
+		} else if (phy->rev >= 7) {
+			/* TODO */
+		} else if (phy->rev >= 3) {
 			b43_radio_mask(dev, 0x09, ~0x2);
 
 			b43_radio_write(dev, 0x204D, 0);
@@ -5884,11 +6056,13 @@ static void b43_nphy_op_software_rfkill(struct b43_wldev *dev,
 			b43_radio_write(dev, 0x3064, 0);
 		}
 	} else {
-		if (dev->phy.rev >= 7) {
+		if (phy->rev >= 19) {
+			/* TODO */
+		} else if (phy->rev >= 7) {
 			if (!dev->phy.radio_on)
 				b43_radio_2057_init(dev);
 			b43_switch_channel(dev, dev->phy.channel);
-		} else if (dev->phy.rev >= 3) {
+		} else if (phy->rev >= 3) {
 			if (!dev->phy.radio_on)
 				b43_radio_init2056(dev);
 			b43_switch_channel(dev, dev->phy.channel);
@@ -5901,10 +6075,13 @@ static void b43_nphy_op_software_rfkill(struct b43_wldev *dev,
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/Anacore */
 static void b43_nphy_op_switch_analog(struct b43_wldev *dev, bool on)
 {
+	struct b43_phy *phy = &dev->phy;
 	u16 override = on ? 0x0 : 0x7FFF;
 	u16 core = on ? 0xD : 0x00FD;
 
-	if (dev->phy.rev >= 3) {
+	if (phy->rev >= 19) {
+		/* TODO */
+	} else if (phy->rev >= 3) {
 		if (on) {
 			b43_phy_write(dev, B43_NPHY_AFECTL_C1, core);
 			b43_phy_write(dev, B43_NPHY_AFECTL_OVER1, override);
-- 
1.8.4.5

