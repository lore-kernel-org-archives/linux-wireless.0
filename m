Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:59461 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbaGHNLe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2014 09:11:34 -0400
Received: by mail-wg0-f42.google.com with SMTP id n12so4136156wgh.25
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jul 2014 06:11:33 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 4/7] b43; N-PHY: write most of the missing code for revs 7+
Date: Tue,  8 Jul 2014 15:11:07 +0200
Message-Id: <1404825070-5243-4-git-send-email-zajec5@gmail.com> (sfid-20140708_151138_228433_5FB0F613)
In-Reply-To: <1404825070-5243-1-git-send-email-zajec5@gmail.com>
References: <1404825070-5243-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c       |   2 +-
 drivers/net/wireless/b43/phy_n.c      | 306 +++++++++++++++++++++++++++++-----
 drivers/net/wireless/b43/phy_n.h      |  11 ++
 drivers/net/wireless/b43/radio_2057.h |  10 ++
 4 files changed, 290 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 15aaeb1..6a0c8b6 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4360,7 +4360,7 @@ static int b43_phy_versioning(struct b43_wldev *dev)
 #endif
 #ifdef CONFIG_B43_PHY_N
 	case B43_PHYTYPE_N:
-		if (phy_rev > 9)
+		if (phy_rev >= 19)
 			unsupported = 1;
 		break;
 #endif
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 4bb4d0a..44349f5 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -36,6 +36,7 @@
 #include "main.h"
 
 struct nphy_txgains {
+	u16 tx_lpf[2];
 	u16 txgm[2];
 	u16 pga[2];
 	u16 pad[2];
@@ -43,6 +44,7 @@ struct nphy_txgains {
 };
 
 struct nphy_iqcal_params {
+	u16 tx_lpf;
 	u16 txgm;
 	u16 pga;
 	u16 pad;
@@ -69,6 +71,14 @@ enum b43_nphy_rf_sequence {
 	B43_RFSEQ_UPDATE_GAINU,
 };
 
+enum n_rf_ctl_over_cmd {
+	N_RF_CTL_OVER_CMD_RXRF_PU = 0,
+	N_RF_CTL_OVER_CMD_RX_PU = 1,
+	N_RF_CTL_OVER_CMD_TX_PU = 2,
+	N_RF_CTL_OVER_CMD_RX_GAIN = 3,
+	N_RF_CTL_OVER_CMD_TX_GAIN = 4,
+};
+
 enum n_intc_override {
 	N_INTC_OVERRIDE_OFF = 0,
 	N_INTC_OVERRIDE_TRSW = 1,
@@ -194,6 +204,50 @@ static void b43_nphy_rf_ctl_override_rev7(struct b43_wldev *dev, u16 field,
 	}
 }
 
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RFCtrlOverideOneToMany */
+static void b43_nphy_rf_ctl_override_one_to_many(struct b43_wldev *dev,
+						 enum n_rf_ctl_over_cmd cmd,
+						 u16 value, u8 core, bool off)
+{
+	struct b43_phy *phy = &dev->phy;
+	u16 tmp;
+
+	B43_WARN_ON(phy->rev < 7);
+
+	switch (cmd) {
+	case N_RF_CTL_OVER_CMD_RXRF_PU:
+		b43_nphy_rf_ctl_override_rev7(dev, 0x20, value, core, off, 1);
+		b43_nphy_rf_ctl_override_rev7(dev, 0x10, value, core, off, 1);
+		b43_nphy_rf_ctl_override_rev7(dev, 0x08, value, core, off, 1);
+		break;
+	case N_RF_CTL_OVER_CMD_RX_PU:
+		b43_nphy_rf_ctl_override_rev7(dev, 0x4, value, core, off, 1);
+		b43_nphy_rf_ctl_override_rev7(dev, 0x2, value, core, off, 1);
+		b43_nphy_rf_ctl_override_rev7(dev, 0x1, value, core, off, 1);
+		b43_nphy_rf_ctl_override_rev7(dev, 0x2, value, core, off, 2);
+		b43_nphy_rf_ctl_override_rev7(dev, 0x0800, value, core, off, 1);
+		break;
+	case N_RF_CTL_OVER_CMD_TX_PU:
+		b43_nphy_rf_ctl_override_rev7(dev, 0x4, value, core, off, 0);
+		b43_nphy_rf_ctl_override_rev7(dev, 0x2, value, core, off, 1);
+		b43_nphy_rf_ctl_override_rev7(dev, 0x1, value, core, off, 2);
+		b43_nphy_rf_ctl_override_rev7(dev, 0x0800, value, core, off, 1);
+		break;
+	case N_RF_CTL_OVER_CMD_RX_GAIN:
+		tmp = value & 0xFF;
+		b43_nphy_rf_ctl_override_rev7(dev, 0x0800, tmp, core, off, 0);
+		tmp = value >> 8;
+		b43_nphy_rf_ctl_override_rev7(dev, 0x6000, tmp, core, off, 0);
+		break;
+	case N_RF_CTL_OVER_CMD_TX_GAIN:
+		tmp = value & 0x7FFF;
+		b43_nphy_rf_ctl_override_rev7(dev, 0x1000, tmp, core, off, 0);
+		tmp = value >> 14;
+		b43_nphy_rf_ctl_override_rev7(dev, 0x4000, tmp, core, off, 0);
+		break;
+	}
+}
+
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RFCtrlOverride */
 static void b43_nphy_rf_ctl_override(struct b43_wldev *dev, u16 field,
 				     u16 value, u8 core, bool off)
@@ -520,6 +574,14 @@ static void b43_nphy_stay_in_carrier_search(struct b43_wldev *dev, bool enable)
 	}
 }
 
+/* http://bcm-v4.sipsolutions.net/PHY/N/Read_Lpf_Bw_Ctl */
+static u16 b43_nphy_read_lpf_ctl(struct b43_wldev *dev, u16 offset)
+{
+	if (!offset)
+		offset = b43_is_40mhz(dev) ? 0x159 : 0x154;
+	return b43_ntab_read(dev, B43_NTAB16(7, offset)) & 0x7;
+}
+
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/AdjustLnaGainTbl */
 static void b43_nphy_adjust_lna_gain_table(struct b43_wldev *dev)
 {
@@ -1410,7 +1472,23 @@ static void b43_nphy_run_samples(struct b43_wldev *dev, u16 samps, u16 loops,
 	b43_nphy_stay_in_carrier_search(dev, true);
 
 	if (phy->rev >= 7) {
-		/* TODO */
+		bool lpf_bw3, lpf_bw4;
+
+		lpf_bw3 = b43_phy_read(dev, B43_NPHY_REV7_RF_CTL_OVER3) & 0x80;
+		lpf_bw4 = b43_phy_read(dev, B43_NPHY_REV7_RF_CTL_OVER3) & 0x80;
+
+		if (lpf_bw3 || lpf_bw4) {
+			/* TODO */
+		} else {
+			u16 value = b43_nphy_read_lpf_ctl(dev, 0);
+			if (phy->rev >= 19)
+				b43_nphy_rf_ctl_override_rev19(dev, 0x80, value,
+							       0, false, 1);
+			else
+				b43_nphy_rf_ctl_override_rev7(dev, 0x80, value,
+							      0, false, 1);
+			nphy->lpf_bw_overrode_for_sample_play = true;
+		}
 	}
 
 	if ((nphy->bb_mult_save & 0x80000000) == 0) {
@@ -1857,12 +1935,14 @@ static void b43_nphy_rev3_rssi_cal(struct b43_wldev *dev)
 		B43_NPHY_AFECTL_OVER1, B43_NPHY_AFECTL_OVER,
 		B43_NPHY_AFECTL_C1, B43_NPHY_AFECTL_C2,
 		B43_NPHY_TXF_40CO_B1S1, B43_NPHY_RFCTL_OVER,
-		0x342, 0x343, 0x346, 0x347,
+		B43_NPHY_REV7_RF_CTL_OVER3, B43_NPHY_REV7_RF_CTL_OVER4,
+		B43_NPHY_REV7_RF_CTL_OVER5, B43_NPHY_REV7_RF_CTL_OVER6,
 		0x2ff,
 		B43_NPHY_TXF_40CO_B1S0, B43_NPHY_TXF_40CO_B32S1,
 		B43_NPHY_RFCTL_CMD,
 		B43_NPHY_RFCTL_LUT_TRSW_UP1, B43_NPHY_RFCTL_LUT_TRSW_UP2,
-		0x340, 0x341, 0x344, 0x345,
+		B43_NPHY_REV7_RF_CTL_MISC_REG3, B43_NPHY_REV7_RF_CTL_MISC_REG4,
+		B43_NPHY_REV7_RF_CTL_MISC_REG5, B43_NPHY_REV7_RF_CTL_MISC_REG6,
 		B43_NPHY_RFCTL_RSSIO1, B43_NPHY_RFCTL_RSSIO2
 	};
 	u16 *regs_to_store;
@@ -1909,9 +1989,24 @@ static void b43_nphy_rev3_rssi_cal(struct b43_wldev *dev)
 	b43_nphy_rf_ctl_intc_override(dev, N_INTC_OVERRIDE_TRSW, 1, 7);
 
 	if (dev->phy.rev >= 7) {
-		/* TODO */
+		b43_nphy_rf_ctl_override_one_to_many(dev,
+						     N_RF_CTL_OVER_CMD_RXRF_PU,
+						     0, 0, false);
+		b43_nphy_rf_ctl_override_one_to_many(dev,
+						     N_RF_CTL_OVER_CMD_RX_PU,
+						     1, 0, false);
+		b43_nphy_rf_ctl_override_rev7(dev, 0x80, 1, 0, false, 0);
+		b43_nphy_rf_ctl_override_rev7(dev, 0x80, 1, 0, false, 0);
 		if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
+			b43_nphy_rf_ctl_override_rev7(dev, 0x20, 0, 0, false,
+						      0);
+			b43_nphy_rf_ctl_override_rev7(dev, 0x10, 1, 0, false,
+						      0);
 		} else {
+			b43_nphy_rf_ctl_override_rev7(dev, 0x10, 0, 0, false,
+						      0);
+			b43_nphy_rf_ctl_override_rev7(dev, 0x20, 1, 0, false,
+						      0);
 		}
 	} else {
 		b43_nphy_rf_ctl_override(dev, 0x1, 0, 0, false);
@@ -1940,7 +2035,10 @@ static void b43_nphy_rev3_rssi_cal(struct b43_wldev *dev)
 		/* Grab RSSI results for every possible VCM */
 		for (vcm = 0; vcm < 8; vcm++) {
 			if (dev->phy.rev >= 7)
-				;
+				b43_radio_maskset(dev,
+						  core ? R2057_NB_MASTER_CORE1 :
+							 R2057_NB_MASTER_CORE0,
+						  ~R2057_VCM_MASK, vcm);
 			else
 				b43_radio_maskset(dev, r | B2056_RX_RSSI_MISC,
 						  0xE3, vcm << 2);
@@ -1971,7 +2069,10 @@ static void b43_nphy_rev3_rssi_cal(struct b43_wldev *dev)
 
 		/* Select the best VCM */
 		if (dev->phy.rev >= 7)
-			;
+			b43_radio_maskset(dev,
+					  core ? R2057_NB_MASTER_CORE1 :
+						 R2057_NB_MASTER_CORE0,
+					  ~R2057_VCM_MASK, vcm);
 		else
 			b43_radio_maskset(dev, r | B2056_RX_RSSI_MISC,
 					  0xE3, vcm_final << 2);
@@ -2041,6 +2142,10 @@ static void b43_nphy_rev3_rssi_cal(struct b43_wldev *dev)
 		rssical_phy_regs = nphy->rssical_cache.rssical_phy_regs_5G;
 	}
 	if (dev->phy.rev >= 7) {
+		rssical_radio_regs[0] = b43_radio_read(dev,
+						       R2057_NB_MASTER_CORE0);
+		rssical_radio_regs[1] = b43_radio_read(dev,
+						       R2057_NB_MASTER_CORE1);
 	} else {
 		rssical_radio_regs[0] = b43_radio_read(dev, B2056_RX0 |
 						       B2056_RX_RSSI_MISC);
@@ -2477,14 +2582,6 @@ static void b43_nphy_gain_ctl_workarounds(struct b43_wldev *dev)
 		b43_nphy_gain_ctl_workarounds_rev1_2(dev);
 }
 
-/* http://bcm-v4.sipsolutions.net/PHY/N/Read_Lpf_Bw_Ctl */
-static u16 b43_nphy_read_lpf_ctl(struct b43_wldev *dev, u16 offset)
-{
-	if (!offset)
-		offset = b43_is_40mhz(dev) ? 0x159 : 0x154;
-	return b43_ntab_read(dev, B43_NTAB16(7, offset)) & 0x7;
-}
-
 static void b43_nphy_workarounds_rev7plus(struct b43_wldev *dev)
 {
 	struct ssb_sprom *sprom = dev->dev->bus_sprom;
@@ -3171,6 +3268,7 @@ static void b43_nphy_update_txrx_chain(struct b43_wldev *dev)
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/stop-playback */
 static void b43_nphy_stop_playback(struct b43_wldev *dev)
 {
+	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_n *nphy = dev->phy.n;
 	u16 tmp;
 
@@ -3191,8 +3289,13 @@ static void b43_nphy_stop_playback(struct b43_wldev *dev)
 		nphy->bb_mult_save = 0;
 	}
 
-	if (dev->phy.rev >= 7) {
-		/* TODO */
+	if (phy->rev >= 7) {
+		if (phy->rev >= 19)
+			b43_nphy_rf_ctl_override_rev19(dev, 0x80, 0, 0, true,
+						       1);
+		else
+			b43_nphy_rf_ctl_override_rev7(dev, 0x80, 0, 0, true, 1);
+		nphy->lpf_bw_overrode_for_sample_play = false;
 	}
 
 	if (nphy->hang_avoid)
@@ -3209,6 +3312,7 @@ static void b43_nphy_iq_cal_gain_params(struct b43_wldev *dev, u16 core,
 	u16 gain;
 
 	if (dev->phy.rev >= 3) {
+		params->tx_lpf = target.tx_lpf[core]; /* Rev 7+ */
 		params->txgm = target.txgm[core];
 		params->pga = target.pga[core];
 		params->pad = target.pad[core];
@@ -3216,7 +3320,7 @@ static void b43_nphy_iq_cal_gain_params(struct b43_wldev *dev, u16 core,
 		if (phy->rev >= 19) {
 			/* TODO */
 		} else if (phy->rev >= 7) {
-			/* TODO */
+			params->cal_gain = (params->txgm << 12) | (params->pga << 8) | (params->pad << 3) | (params->ipa) | (params->tx_lpf << 15);
 		} else {
 			params->cal_gain = (params->txgm << 12) | (params->pga << 8) | (params->pad << 4) | (params->ipa);
 		}
@@ -3333,7 +3437,12 @@ static void b43_nphy_tx_power_ctrl(struct b43_wldev *dev, bool enable)
 			if (phy->rev >= 19) {
 				/* TODO */
 			} else if (phy->rev >= 7) {
-				/* TODO */
+				b43_phy_maskset(dev, B43_NPHY_TXPCTL_CMD,
+						~B43_NPHY_TXPCTL_CMD_INIT,
+						0x32);
+				b43_phy_maskset(dev, B43_NPHY_TXPCTL_INIT,
+						~B43_NPHY_TXPCTL_INIT_PIDXI1,
+						0x32);
 			} else {
 				b43_phy_maskset(dev, B43_NPHY_TXPCTL_CMD,
 						~B43_NPHY_TXPCTL_CMD_INIT,
@@ -3921,8 +4030,7 @@ static void b43_nphy_pa_override(struct b43_wldev *dev, bool enable)
 						       B43_NPHY_RFCTL_INTC2);
 		band = b43_current_band(dev->wl);
 		if (dev->phy.rev >= 7) {
-			/* TODO */
-			return;
+			tmp = 0x1480;
 		} else if (dev->phy.rev >= 3) {
 			if (band == IEEE80211_BAND_5GHZ)
 				tmp = 0x600;
@@ -4373,7 +4481,10 @@ static void b43_nphy_restore_rssi_cal(struct b43_wldev *dev)
 	if (dev->phy.rev >= 19) {
 		/* TODO */
 	} else if (dev->phy.rev >= 7) {
-		/* TODO */
+		b43_radio_maskset(dev, R2057_NB_MASTER_CORE0, ~R2057_VCM_MASK,
+				  rssical_radio_regs[0]);
+		b43_radio_maskset(dev, R2057_NB_MASTER_CORE1, ~R2057_VCM_MASK,
+				  rssical_radio_regs[1]);
 	} else {
 		b43_radio_maskset(dev, B2056_RX0 | B2056_RX_RSSI_MISC, 0xE3,
 				  rssical_radio_regs[0]);
@@ -4404,7 +4515,55 @@ static void b43_nphy_tx_cal_radio_setup_rev19(struct b43_wldev *dev)
 
 static void b43_nphy_tx_cal_radio_setup_rev7(struct b43_wldev *dev)
 {
-	/* TODO */
+	struct b43_phy *phy = &dev->phy;
+	struct b43_phy_n *nphy = dev->phy.n;
+	u16 *save = nphy->tx_rx_cal_radio_saveregs;
+	int core, off;
+	u16 r, tmp;
+
+	for (core = 0; core < 2; core++) {
+		r = core ? 0x20 : 0;
+		off = core * 11;
+
+		save[off + 0] = b43_radio_read(dev, r + R2057_TX0_TX_SSI_MASTER);
+		save[off + 1] = b43_radio_read(dev, r + R2057_TX0_IQCAL_VCM_HG);
+		save[off + 2] = b43_radio_read(dev, r + R2057_TX0_IQCAL_IDAC);
+		save[off + 3] = b43_radio_read(dev, r + R2057_TX0_TSSI_VCM);
+		save[off + 4] = 0;
+		save[off + 5] = b43_radio_read(dev, r + R2057_TX0_TX_SSI_MUX);
+		if (phy->radio_rev != 5)
+			save[off + 6] = b43_radio_read(dev, r + R2057_TX0_TSSIA);
+		save[off + 7] = b43_radio_read(dev, r + R2057_TX0_TSSIG);
+		save[off + 8] = b43_radio_read(dev, r + R2057_TX0_TSSI_MISC1);
+
+		if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
+			b43_radio_write(dev, r + R2057_TX0_TX_SSI_MASTER, 0xA);
+			b43_radio_write(dev, r + R2057_TX0_IQCAL_VCM_HG, 0x43);
+			b43_radio_write(dev, r + R2057_TX0_IQCAL_IDAC, 0x55);
+			b43_radio_write(dev, r + R2057_TX0_TSSI_VCM, 0);
+			b43_radio_write(dev, r + R2057_TX0_TSSIG, 0);
+			if (nphy->use_int_tx_iq_lo_cal) {
+				b43_radio_write(dev, r + R2057_TX0_TX_SSI_MUX, 0x4);
+				tmp = true ? 0x31 : 0x21; /* TODO */
+				b43_radio_write(dev, r + R2057_TX0_TSSIA, tmp);
+			}
+			b43_radio_write(dev, r + R2057_TX0_TSSI_MISC1, 0x00);
+		} else {
+			b43_radio_write(dev, r + R2057_TX0_TX_SSI_MASTER, 0x6);
+			b43_radio_write(dev, r + R2057_TX0_IQCAL_VCM_HG, 0x43);
+			b43_radio_write(dev, r + R2057_TX0_IQCAL_IDAC, 0x55);
+			b43_radio_write(dev, r + R2057_TX0_TSSI_VCM, 0);
+
+			if (phy->radio_rev != 5)
+				b43_radio_write(dev, r + R2057_TX0_TSSIA, 0);
+			if (nphy->use_int_tx_iq_lo_cal) {
+				b43_radio_write(dev, r + R2057_TX0_TX_SSI_MUX, 0x6);
+				tmp = true ? 0x31 : 0x21; /* TODO */
+				b43_radio_write(dev, r + R2057_TX0_TSSIG, tmp);
+			}
+			b43_radio_write(dev, r + R2057_TX0_TSSI_MISC1, 0);
+		}
+	}
 }
 
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxCalRadioSetup */
@@ -4585,7 +4744,13 @@ static struct nphy_txgains b43_nphy_get_tx_gains(struct b43_wldev *dev)
 			b43_nphy_stay_in_carrier_search(dev, false);
 
 		for (i = 0; i < 2; ++i) {
-			if (dev->phy.rev >= 3) {
+			if (dev->phy.rev >= 7) {
+				target.ipa[i] = curr_gain[i] & 0x0007;
+				target.pad[i] = (curr_gain[i] & 0x00F8) >> 3;
+				target.pga[i] = (curr_gain[i] & 0x0F00) >> 8;
+				target.txgm[i] = (curr_gain[i] & 0x7000) >> 12;
+				target.tx_lpf[i] = (curr_gain[i] & 0x8000) >> 15;
+			} else if (dev->phy.rev >= 3) {
 				target.ipa[i] = curr_gain[i] & 0x000F;
 				target.pad[i] = (curr_gain[i] & 0x00F0) >> 4;
 				target.pga[i] = (curr_gain[i] & 0x0F00) >> 8;
@@ -4612,7 +4777,13 @@ static struct nphy_txgains b43_nphy_get_tx_gains(struct b43_wldev *dev)
 			if (!table)
 				break;
 
-			if (dev->phy.rev >= 3) {
+			if (dev->phy.rev >= 7) {
+				target.ipa[i] = (table[index[i]] >> 16) & 0x7;
+				target.pad[i] = (table[index[i]] >> 19) & 0x1F;
+				target.pga[i] = (table[index[i]] >> 24) & 0xF;
+				target.txgm[i] = (table[index[i]] >> 28) & 0x7;
+				target.tx_lpf[i] = (table[index[i]] >> 31) & 0x1;
+			} else if (dev->phy.rev >= 3) {
 				target.ipa[i] = (table[index[i]] >> 16) & 0xF;
 				target.pad[i] = (table[index[i]] >> 20) & 0xF;
 				target.pga[i] = (table[index[i]] >> 24) & 0xF;
@@ -4662,6 +4833,7 @@ static void b43_nphy_tx_cal_phy_cleanup(struct b43_wldev *dev)
 static void b43_nphy_tx_cal_phy_setup(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
+	struct b43_phy_n *nphy = dev->phy.n;
 	u16 *regs = dev->phy.n->tx_rx_cal_phy_saveregs;
 	u16 tmp;
 
@@ -4693,7 +4865,12 @@ static void b43_nphy_tx_cal_phy_setup(struct b43_wldev *dev)
 		regs[7] = b43_phy_read(dev, B43_NPHY_RFCTL_INTC1);
 		regs[8] = b43_phy_read(dev, B43_NPHY_RFCTL_INTC2);
 
-		b43_nphy_rf_ctl_intc_override(dev, N_INTC_OVERRIDE_PA, 1, 3);
+		if (!nphy->use_int_tx_iq_lo_cal)
+			b43_nphy_rf_ctl_intc_override(dev, N_INTC_OVERRIDE_PA,
+						      1, 3);
+		else
+			b43_nphy_rf_ctl_intc_override(dev, N_INTC_OVERRIDE_PA,
+						      0, 3);
 		b43_nphy_rf_ctl_intc_override(dev, N_INTC_OVERRIDE_TRSW, 2, 1);
 		b43_nphy_rf_ctl_intc_override(dev, N_INTC_OVERRIDE_TRSW, 8, 2);
 
@@ -4702,18 +4879,30 @@ static void b43_nphy_tx_cal_phy_setup(struct b43_wldev *dev)
 		b43_phy_mask(dev, B43_NPHY_PAPD_EN0, ~0x0001);
 		b43_phy_mask(dev, B43_NPHY_PAPD_EN1, ~0x0001);
 
+		tmp = b43_nphy_read_lpf_ctl(dev, 0);
 		if (phy->rev >= 19)
-			; /* TODO */
+			b43_nphy_rf_ctl_override_rev19(dev, 0x80, tmp, 0, false,
+						       1);
 		else if (phy->rev >= 7)
-			; /* TODO */
+			b43_nphy_rf_ctl_override_rev7(dev, 0x80, tmp, 0, false,
+						      1);
 
-		if (0 /* FIXME */) {
+		if (nphy->use_int_tx_iq_lo_cal && true /* FIXME */) {
 			if (phy->rev >= 19) {
-				/* TODO */
+				b43_nphy_rf_ctl_override_rev19(dev, 0x8, 0, 0x3,
+							       false, 0);
 			} else if (phy->rev >= 8) {
-				/* TODO */
+				b43_nphy_rf_ctl_override_rev7(dev, 0x8, 0, 0x3,
+							      false, 0);
 			} else if (phy->rev == 7) {
-				/* TODO */
+				b43_radio_maskset(dev, R2057_OVR_REG0, 1 << 4, 1 << 4);
+				if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+					b43_radio_maskset(dev, R2057_PAD2G_TUNE_PUS_CORE0, ~1, 0);
+					b43_radio_maskset(dev, R2057_PAD2G_TUNE_PUS_CORE1, ~1, 0);
+				} else {
+					b43_radio_maskset(dev, R2057_IPA5G_CASCOFFV_PU_CORE0, ~1, 0);
+					b43_radio_maskset(dev, R2057_IPA5G_CASCOFFV_PU_CORE1, ~1, 0);
+				}
 			}
 		}
 	} else {
@@ -4772,7 +4961,22 @@ static void b43_nphy_save_cal(struct b43_wldev *dev)
 	if (phy->rev >= 19) {
 		/* TODO */
 	} else if (phy->rev >= 7) {
-		/* TODO */
+		txcal_radio_regs[0] = b43_radio_read(dev,
+						     R2057_TX0_LOFT_FINE_I);
+		txcal_radio_regs[1] = b43_radio_read(dev,
+						     R2057_TX0_LOFT_FINE_Q);
+		txcal_radio_regs[4] = b43_radio_read(dev,
+						     R2057_TX0_LOFT_COARSE_I);
+		txcal_radio_regs[5] = b43_radio_read(dev,
+						     R2057_TX0_LOFT_COARSE_Q);
+		txcal_radio_regs[2] = b43_radio_read(dev,
+						     R2057_TX1_LOFT_FINE_I);
+		txcal_radio_regs[3] = b43_radio_read(dev,
+						     R2057_TX1_LOFT_FINE_Q);
+		txcal_radio_regs[6] = b43_radio_read(dev,
+						     R2057_TX1_LOFT_COARSE_I);
+		txcal_radio_regs[7] = b43_radio_read(dev,
+						     R2057_TX1_LOFT_COARSE_Q);
 	} else if (phy->rev >= 3) {
 		txcal_radio_regs[0] = b43_radio_read(dev, 0x2021);
 		txcal_radio_regs[1] = b43_radio_read(dev, 0x2022);
@@ -4851,7 +5055,22 @@ static void b43_nphy_restore_cal(struct b43_wldev *dev)
 	if (phy->rev >= 19) {
 		/* TODO */
 	} else if (phy->rev >= 7) {
-		/* TODO */
+		b43_radio_write(dev, R2057_TX0_LOFT_FINE_I,
+				txcal_radio_regs[0]);
+		b43_radio_write(dev, R2057_TX0_LOFT_FINE_Q,
+				txcal_radio_regs[1]);
+		b43_radio_write(dev, R2057_TX0_LOFT_COARSE_I,
+				txcal_radio_regs[4]);
+		b43_radio_write(dev, R2057_TX0_LOFT_COARSE_Q,
+				txcal_radio_regs[5]);
+		b43_radio_write(dev, R2057_TX1_LOFT_FINE_I,
+				txcal_radio_regs[2]);
+		b43_radio_write(dev, R2057_TX1_LOFT_FINE_Q,
+				txcal_radio_regs[3]);
+		b43_radio_write(dev, R2057_TX1_LOFT_COARSE_I,
+				txcal_radio_regs[6]);
+		b43_radio_write(dev, R2057_TX1_LOFT_COARSE_Q,
+				txcal_radio_regs[7]);
 	} else if (phy->rev >= 3) {
 		b43_radio_write(dev, 0x2021, txcal_radio_regs[0]);
 		b43_radio_write(dev, 0x2022, txcal_radio_regs[1]);
@@ -4932,7 +5151,7 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,
 	if (phy->rev >= 19) {
 		/* TODO */
 	} else if (phy->rev >= 7) {
-		/* TODO */
+		b43_phy_write(dev, B43_NPHY_IQLOCAL_CMDGCTL, 0x8AD9);
 	} else {
 		b43_phy_write(dev, B43_NPHY_IQLOCAL_CMDGCTL, 0x8AA9);
 	}
@@ -5496,6 +5715,10 @@ static int b43_phy_initn(struct b43_wldev *dev)
 #endif
 		}
 	}
+	nphy->use_int_tx_iq_lo_cal = b43_nphy_ipa(dev) ||
+		phy->rev >= 7 ||
+		(phy->rev >= 5 &&
+		 sprom->boardflags2_hi & B43_BFH2_INTERNDET_TXIQCAL);
 	nphy->deaf_count = 0;
 	b43_nphy_tables_init(dev);
 	nphy->crsminpwr_adjusted = false;
@@ -5506,7 +5729,10 @@ static int b43_phy_initn(struct b43_wldev *dev)
 		b43_phy_write(dev, B43_NPHY_TXF_40CO_B1S1, 0);
 		b43_phy_write(dev, B43_NPHY_RFCTL_OVER, 0);
 		if (phy->rev >= 7) {
-			/* TODO */
+			b43_phy_write(dev, B43_NPHY_REV7_RF_CTL_OVER3, 0);
+			b43_phy_write(dev, B43_NPHY_REV7_RF_CTL_OVER4, 0);
+			b43_phy_write(dev, B43_NPHY_REV7_RF_CTL_OVER5, 0);
+			b43_phy_write(dev, B43_NPHY_REV7_RF_CTL_OVER6, 0);
 		}
 		if (phy->rev >= 19) {
 			/* TODO */
@@ -6032,13 +6258,17 @@ static void b43_nphy_op_software_rfkill(struct b43_wldev *dev,
 		b43err(dev->wl, "MAC not suspended\n");
 
 	if (blocked) {
-		b43_phy_mask(dev, B43_NPHY_RFCTL_CMD,
-				~B43_NPHY_RFCTL_CMD_CHIP0PU);
 		if (phy->rev >= 19) {
 			/* TODO */
+		} else if (phy->rev >= 8) {
+			b43_phy_mask(dev, B43_NPHY_RFCTL_CMD,
+				     ~B43_NPHY_RFCTL_CMD_CHIP0PU);
 		} else if (phy->rev >= 7) {
-			/* TODO */
+			/* Nothing needed */
 		} else if (phy->rev >= 3) {
+			b43_phy_mask(dev, B43_NPHY_RFCTL_CMD,
+				     ~B43_NPHY_RFCTL_CMD_CHIP0PU);
+
 			b43_radio_mask(dev, 0x09, ~0x2);
 
 			b43_radio_write(dev, 0x204D, 0);
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index ecfbf66..7fd5d5f 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -857,6 +857,15 @@
 #define B43_NPHY_REV3_C2_CLIP2_GAIN_A		B43_PHY_N(0x2AF)
 #define B43_NPHY_REV3_C2_CLIP2_GAIN_B		B43_PHY_N(0x2B0)
 
+#define B43_NPHY_REV7_RF_CTL_MISC_REG3		B43_PHY_N(0x340)
+#define B43_NPHY_REV7_RF_CTL_MISC_REG4		B43_PHY_N(0x341)
+#define B43_NPHY_REV7_RF_CTL_OVER3		B43_PHY_N(0x342)
+#define B43_NPHY_REV7_RF_CTL_OVER4		B43_PHY_N(0x343)
+#define B43_NPHY_REV7_RF_CTL_MISC_REG5		B43_PHY_N(0x344)
+#define B43_NPHY_REV7_RF_CTL_MISC_REG6		B43_PHY_N(0x345)
+#define B43_NPHY_REV7_RF_CTL_OVER5		B43_PHY_N(0x346)
+#define B43_NPHY_REV7_RF_CTL_OVER6		B43_PHY_N(0x347)
+
 #define B43_PHY_B_BBCFG				B43_PHY_N_BMODE(0x001) /* BB config */
 #define B43_PHY_B_TEST				B43_PHY_N_BMODE(0x00A)
 
@@ -935,6 +944,8 @@ struct b43_phy_n {
 	bool gain_boost;
 	bool elna_gain_config;
 	bool band5g_pwrgain;
+	bool use_int_tx_iq_lo_cal;
+	bool lpf_bw_overrode_for_sample_play;
 
 	u8 mphase_cal_phase_id;
 	u16 mphase_txcal_cmdidx;
diff --git a/drivers/net/wireless/b43/radio_2057.h b/drivers/net/wireless/b43/radio_2057.h
index 675d1bb..220d080 100644
--- a/drivers/net/wireless/b43/radio_2057.h
+++ b/drivers/net/wireless/b43/radio_2057.h
@@ -84,6 +84,8 @@
 #define R2057_CMOSBUF_RX_RCCR			0x04c
 #define R2057_LOGEN_SEL_PKDET			0x04d
 #define R2057_CMOSBUF_SHAREIQ_PTAT		0x04e
+
+/* MISC core 0 */
 #define R2057_RXTXBIAS_CONFIG_CORE0		0x04f
 #define R2057_TXGM_TXRF_PUS_CORE0		0x050
 #define R2057_TXGM_IDAC_BLEED_CORE0		0x051
@@ -204,6 +206,8 @@
 #define R2057_RXBB_GPAIOSEL_RXLPF_RCCAL_CORE0	0x0d1
 #define R2057_LPF_GAIN_CORE0			0x0d2
 #define R2057_DACBUF_IDACS_BW_CORE0		0x0d3
+
+/* MISC core 1 */
 #define R2057_RXTXBIAS_CONFIG_CORE1		0x0d4
 #define R2057_TXGM_TXRF_PUS_CORE1		0x0d5
 #define R2057_TXGM_IDAC_BLEED_CORE1		0x0d6
@@ -324,6 +328,7 @@
 #define R2057_RXBB_GPAIOSEL_RXLPF_RCCAL_CORE1	0x156
 #define R2057_LPF_GAIN_CORE1			0x157
 #define R2057_DACBUF_IDACS_BW_CORE1		0x158
+
 #define R2057_DACBUF_VINCM_CORE1		0x159
 #define R2057_RCCAL_START_R1_Q1_P1		0x15a
 #define R2057_RCCAL_X1				0x15b
@@ -345,6 +350,8 @@
 #define R2057_RCCAL_BCAP_VAL			0x16b
 #define R2057_RCCAL_HPC_VAL			0x16c
 #define R2057_RCCAL_OVERRIDES			0x16d
+
+/* TX core 0 */
 #define R2057_TX0_IQCAL_GAIN_BW			0x170
 #define R2057_TX0_LOFT_FINE_I			0x171
 #define R2057_TX0_LOFT_FINE_Q			0x172
@@ -362,6 +369,8 @@
 #define R2057_TX0_TXRXCOUPLE_2G_PWRUP		0x17e
 #define R2057_TX0_TXRXCOUPLE_5G_ATTEN		0x17f
 #define R2057_TX0_TXRXCOUPLE_5G_PWRUP		0x180
+
+/* TX core 1 */
 #define R2057_TX1_IQCAL_GAIN_BW			0x190
 #define R2057_TX1_LOFT_FINE_I			0x191
 #define R2057_TX1_LOFT_FINE_Q			0x192
@@ -379,6 +388,7 @@
 #define R2057_TX1_TXRXCOUPLE_2G_PWRUP		0x19e
 #define R2057_TX1_TXRXCOUPLE_5G_ATTEN		0x19f
 #define R2057_TX1_TXRXCOUPLE_5G_PWRUP		0x1a0
+
 #define R2057_AFE_VCM_CAL_MASTER_CORE0		0x1a1
 #define R2057_AFE_SET_VCM_I_CORE0		0x1a2
 #define R2057_AFE_SET_VCM_Q_CORE0		0x1a3
-- 
1.8.4.5

