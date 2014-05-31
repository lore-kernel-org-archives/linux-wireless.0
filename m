Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:53863 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbaEaSuO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 14:50:14 -0400
Received: by mail-we0-f178.google.com with SMTP id u56so3368062wes.37
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2014 11:50:12 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 8/9] b43: PHY: drop is_40mhz (get width info from chandef)
Date: Sat, 31 May 2014 20:49:40 +0200
Message-Id: <1401562181-14608-9-git-send-email-zajec5@gmail.com> (sfid-20140531_205023_735259_FDBBBDCA)
In-Reply-To: <1401562181-14608-1-git-send-email-zajec5@gmail.com>
References: <1401562181-14608-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c       |  5 ----
 drivers/net/wireless/b43/phy_common.c |  5 ++++
 drivers/net/wireless/b43/phy_common.h |  5 ++--
 drivers/net/wireless/b43/phy_n.c      | 53 +++++++++++++++++------------------
 4 files changed, 33 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 2b99ed3..4b662d0 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -3810,11 +3810,6 @@ static int b43_op_config(struct ieee80211_hw *hw, u32 changed)
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
 		phy->chandef = &conf->chandef;
 		phy->channel = conf->chandef.chan->hw_value;
-		if (conf_is_ht(conf))
-			phy->is_40mhz = conf_is_ht40_minus(conf) ||
-					conf_is_ht40_plus(conf);
-		else
-			phy->is_40mhz = false;
 
 		/* Switch the band (if necessary). */
 		err = b43_switch_band(dev, conf->chandef.chan);
diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index 9aa6c9c..e7e8383 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -553,6 +553,11 @@ bool b43_channel_type_is_40mhz(enum nl80211_channel_type channel_type)
 		channel_type == NL80211_CHAN_HT40PLUS);
 }
 
+bool b43_is_40mhz(struct b43_wldev *dev)
+{
+	return dev->phy.chandef->width == NL80211_CHAN_WIDTH_40;
+}
+
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/BmacPhyClkFgc */
 void b43_phy_force_clock(struct b43_wldev *dev, bool force)
 {
diff --git a/drivers/net/wireless/b43/phy_common.h b/drivers/net/wireless/b43/phy_common.h
index 3990820..674422f 100644
--- a/drivers/net/wireless/b43/phy_common.h
+++ b/drivers/net/wireless/b43/phy_common.h
@@ -228,9 +228,6 @@ struct b43_phy {
 	bool supports_2ghz;
 	bool supports_5ghz;
 
-	/* HT info */
-	bool is_40mhz;
-
 	/* Is GMODE (2 GHz mode) bit enabled? */
 	bool gmode;
 
@@ -452,6 +449,8 @@ void b43_phyop_switch_analog_generic(struct b43_wldev *dev, bool on);
 
 bool b43_channel_type_is_40mhz(enum nl80211_channel_type channel_type);
 
+bool b43_is_40mhz(struct b43_wldev *dev);
+
 void b43_phy_force_clock(struct b43_wldev *dev, bool force);
 
 struct b43_c32 b43_cordic(int theta);
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index dc62f02..dc12493 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -896,7 +896,7 @@ static void b43_radio_2056_setup(struct b43_wldev *dev,
 					offset | B2056_TX_MIXG_BOOST_TUNE,
 					mixg_boost);
 			} else {
-				bias = dev->phy.is_40mhz ? 0x40 : 0x20;
+				bias = b43_is_40mhz(dev) ? 0x40 : 0x20;
 				b43_radio_write(dev,
 					offset | B2056_TX_INTPAG_IMAIN_STAT,
 					bias);
@@ -1211,8 +1211,7 @@ static u16 b43_nphy_gen_load_samples(struct b43_wldev *dev, u32 freq, u16 max,
 	u16 bw, len, rot, angle;
 	struct b43_c32 *samples;
 
-
-	bw = (dev->phy.is_40mhz) ? 40 : 20;
+	bw = b43_is_40mhz(dev) ? 40 : 20;
 	len = bw << 3;
 
 	if (test) {
@@ -1221,7 +1220,7 @@ static u16 b43_nphy_gen_load_samples(struct b43_wldev *dev, u32 freq, u16 max,
 		else
 			bw = 80;
 
-		if (dev->phy.is_40mhz)
+		if (b43_is_40mhz(dev))
 			bw <<= 1;
 
 		len = bw << 1;
@@ -1264,7 +1263,7 @@ static void b43_nphy_run_samples(struct b43_wldev *dev, u16 samps, u16 loops,
 	}
 
 	/* TODO: add modify_bbmult argument */
-	if (!dev->phy.is_40mhz)
+	if (!b43_is_40mhz(dev))
 		tmp = 0x6464;
 	else
 		tmp = 0x4747;
@@ -2194,7 +2193,7 @@ static void b43_nphy_gain_ctl_workarounds_rev1_2(struct b43_wldev *dev)
 	b43_phy_write(dev, B43_NPHY_C1_NBCLIPTHRES, 0x84);
 	b43_phy_write(dev, B43_NPHY_C2_NBCLIPTHRES, 0x84);
 
-	if (!dev->phy.is_40mhz) {
+	if (!b43_is_40mhz(dev)) {
 		/* Set dwell lengths */
 		b43_phy_write(dev, B43_NPHY_CLIP1_NBDWELL_LEN, 0x002B);
 		b43_phy_write(dev, B43_NPHY_CLIP2_NBDWELL_LEN, 0x002B);
@@ -2208,7 +2207,7 @@ static void b43_nphy_gain_ctl_workarounds_rev1_2(struct b43_wldev *dev)
 	b43_phy_maskset(dev, B43_NPHY_C2_CLIPWBTHRES,
 			~B43_NPHY_C2_CLIPWBTHRES_CLIP2, 21);
 
-	if (!dev->phy.is_40mhz) {
+	if (!b43_is_40mhz(dev)) {
 		b43_phy_maskset(dev, B43_NPHY_C1_CGAINI,
 			~B43_NPHY_C1_CGAINI_GAINBKOFF, 0x1);
 		b43_phy_maskset(dev, B43_NPHY_C2_CGAINI,
@@ -2223,12 +2222,12 @@ static void b43_nphy_gain_ctl_workarounds_rev1_2(struct b43_wldev *dev)
 
 	if (nphy->gain_boost) {
 		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ &&
-			dev->phy.is_40mhz)
+		    b43_is_40mhz(dev))
 			code = 4;
 		else
 			code = 5;
 	} else {
-		code = dev->phy.is_40mhz ? 6 : 7;
+		code = b43_is_40mhz(dev) ? 6 : 7;
 	}
 
 	/* Set HPVGA2 index */
@@ -2300,7 +2299,7 @@ static void b43_nphy_gain_ctl_workarounds(struct b43_wldev *dev)
 static u16 b43_nphy_read_lpf_ctl(struct b43_wldev *dev, u16 offset)
 {
 	if (!offset)
-		offset = (dev->phy.is_40mhz) ? 0x159 : 0x154;
+		offset = b43_is_40mhz(dev) ? 0x159 : 0x154;
 	return b43_ntab_read(dev, B43_NTAB16(7, offset)) & 0x7;
 }
 
@@ -2373,13 +2372,13 @@ static void b43_nphy_workarounds_rev7plus(struct b43_wldev *dev)
 	lpf_40 = b43_nphy_read_lpf_ctl(dev, 0x159);
 	lpf_11b = b43_nphy_read_lpf_ctl(dev, 0x152);
 	if (b43_nphy_ipa(dev)) {
-		if ((phy->radio_rev == 5 && phy->is_40mhz) ||
+		if ((phy->radio_rev == 5 && b43_is_40mhz(dev)) ||
 		    phy->radio_rev == 7 || phy->radio_rev == 8) {
 			bcap_val = b43_radio_read(dev, 0x16b);
 			scap_val = b43_radio_read(dev, 0x16a);
 			scap_val_11b = scap_val;
 			bcap_val_11b = bcap_val;
-			if (phy->radio_rev == 5 && phy->is_40mhz) {
+			if (phy->radio_rev == 5 && b43_is_40mhz(dev)) {
 				scap_val_11n_20 = scap_val;
 				bcap_val_11n_20 = bcap_val;
 				scap_val_11n_40 = bcap_val_11n_40 = 0xc;
@@ -2521,7 +2520,7 @@ static void b43_nphy_workarounds_rev7plus(struct b43_wldev *dev)
 					}
 				}
 			} else if (phy->radio_rev == 7 || phy->radio_rev == 8) {
-				if (!phy->is_40mhz) {
+				if (!b43_is_40mhz(dev)) {
 					b43_radio_write(dev, 0x5F, 0x14);
 					b43_radio_write(dev, 0xE8, 0x12);
 				} else {
@@ -2594,7 +2593,7 @@ static void b43_nphy_workarounds_rev7plus(struct b43_wldev *dev)
 	b43_ntab_write(dev, B43_NTAB16(7, 0x123), 0x77);
 	b43_ntab_write(dev, B43_NTAB16(7, 0x12A), 0x77);
 
-	if (!phy->is_40mhz) {
+	if (!b43_is_40mhz(dev)) {
 		b43_ntab_write(dev, B43_NTAB32(16, 0x03), 0x18D);
 		b43_ntab_write(dev, B43_NTAB32(16, 0x7F), 0x18D);
 	} else {
@@ -2693,7 +2692,7 @@ static void b43_nphy_workarounds_rev3plus(struct b43_wldev *dev)
 
 	b43_phy_maskset(dev, B43_NPHY_SGILTRNOFFSET, 0xF0FF, 0x0700);
 
-	if (!dev->phy.is_40mhz) {
+	if (!b43_is_40mhz(dev)) {
 		b43_ntab_write(dev, B43_NTAB32(16, 3), 0x18D);
 		b43_ntab_write(dev, B43_NTAB32(16, 127), 0x18D);
 	} else {
@@ -3116,7 +3115,7 @@ static void b43_nphy_tx_power_ctrl(struct b43_wldev *dev, bool enable)
 			b43_phy_maskset(dev, B43_NPHY_BPHY_CTL3,
 				~B43_NPHY_BPHY_CTL3_SCALE, 0x5A);
 
-		if (dev->phy.rev < 2 && dev->phy.is_40mhz)
+		if (dev->phy.rev < 2 && b43_is_40mhz(dev))
 			b43_hf_write(dev, b43_hf_read(dev) | B43_HF_TSSIRPSMW);
 	} else {
 		b43_ntab_write_bulk(dev, B43_NTAB16(26, 64), 84,
@@ -3170,7 +3169,7 @@ static void b43_nphy_tx_power_ctrl(struct b43_wldev *dev, bool enable)
 		else if (dev->phy.rev < 2)
 			b43_phy_maskset(dev, B43_NPHY_BPHY_CTL3, ~0xFF, 0x40);
 
-		if (dev->phy.rev < 2 && dev->phy.is_40mhz)
+		if (dev->phy.rev < 2 && b43_is_40mhz(dev))
 			b43_hf_write(dev, b43_hf_read(dev) & ~B43_HF_TSSIRPSMW);
 
 		if (b43_nphy_ipa(dev)) {
@@ -3442,21 +3441,21 @@ static void b43_nphy_tx_prepare_adjusted_power_table(struct b43_wldev *dev)
 		delta = 0;
 		switch (stf_mode) {
 		case 0:
-			if (dev->phy.is_40mhz && dev->phy.rev >= 5) {
+			if (b43_is_40mhz(dev) && dev->phy.rev >= 5) {
 				idx = 68;
 			} else {
 				delta = 1;
-				idx = dev->phy.is_40mhz ? 52 : 4;
+				idx = b43_is_40mhz(dev) ? 52 : 4;
 			}
 			break;
 		case 1:
-			idx = dev->phy.is_40mhz ? 76 : 28;
+			idx = b43_is_40mhz(dev) ? 76 : 28;
 			break;
 		case 2:
-			idx = dev->phy.is_40mhz ? 84 : 36;
+			idx = b43_is_40mhz(dev) ? 84 : 36;
 			break;
 		case 3:
-			idx = dev->phy.is_40mhz ? 92 : 44;
+			idx = b43_is_40mhz(dev) ? 92 : 44;
 			break;
 		}
 
@@ -3996,7 +3995,7 @@ static void b43_nphy_spur_workaround(struct b43_wldev *dev)
 
 	if (nphy->gband_spurwar_en) {
 		/* TODO: N PHY Adjust Analog Pfbw (7) */
-		if (channel == 11 && dev->phy.is_40mhz)
+		if (channel == 11 && b43_is_40mhz(dev))
 			; /* TODO: N PHY Adjust Min Noise Var(2, tone, noise)*/
 		else
 			; /* TODO: N PHY Adjust Min Noise Var(0, NULL, NULL)*/
@@ -4290,7 +4289,7 @@ static void b43_nphy_int_pa_set_tx_dig_filters(struct b43_wldev *dev)
 			b43_phy_write(dev, B43_PHY_N(offset[i] + j),
 					tbl_tx_filter_coef_rev4[i][j]);
 
-	if (dev->phy.is_40mhz) {
+	if (b43_is_40mhz(dev)) {
 		for (j = 0; j < 15; j++)
 			b43_phy_write(dev, B43_PHY_N(offset[0] + j),
 					tbl_tx_filter_coef_rev4[3][j]);
@@ -4626,7 +4625,7 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,
 		(dev->phy.rev == 5 && nphy->ipa2g_on &&
 		b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ);
 	if (phy6or5x) {
-		if (dev->phy.is_40mhz) {
+		if (b43_is_40mhz(dev)) {
 			b43_ntab_write_bulk(dev, B43_NTAB16(15, 0), 18,
 					tbl_tx_iqlo_cal_loft_ladder_40);
 			b43_ntab_write_bulk(dev, B43_NTAB16(15, 32), 18,
@@ -4641,13 +4640,13 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,
 
 	b43_phy_write(dev, B43_NPHY_IQLOCAL_CMDGCTL, 0x8AA9);
 
-	if (!dev->phy.is_40mhz)
+	if (!b43_is_40mhz(dev))
 		freq = 2500;
 	else
 		freq = 5000;
 
 	if (nphy->mphase_cal_phase_id > 2)
-		b43_nphy_run_samples(dev, (dev->phy.is_40mhz ? 40 : 20) * 8,
+		b43_nphy_run_samples(dev, (b43_is_40mhz(dev) ? 40 : 20) * 8,
 					0xFFFF, 0, true, false);
 	else
 		error = b43_nphy_tx_tone(dev, freq, 250, true, false);
-- 
1.8.4.5

