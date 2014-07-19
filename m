Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:55297 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760682AbaGSKxJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2014 06:53:09 -0400
Received: by mail-we0-f176.google.com with SMTP id q58so5568129wes.21
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jul 2014 03:53:07 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/7] b43: N-PHY: update generic rev7+ workarounds
Date: Sat, 19 Jul 2014 12:52:43 +0200
Message-Id: <1405767167-30315-3-git-send-email-zajec5@gmail.com> (sfid-20140719_125312_868226_7A81DDBA)
In-Reply-To: <1405767167-30315-1-git-send-email-zajec5@gmail.com>
References: <1405767167-30315-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add some missing ops and prepare for new devices support. This patch is
a great stability improvement for BCM43217. Earlier Tenda W322E used to
disconnect every 2 minutes (16 times over 30 minutes). With this fix I
got it running for 4 hours (with iperf) without any disconnection.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c | 120 ++++++++++++++++++++++++++-------------
 1 file changed, 79 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 1293f51..448c676 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -2708,15 +2708,19 @@ static void b43_nphy_workarounds_rev7plus(struct b43_wldev *dev)
 	struct ssb_sprom *sprom = dev->dev->bus_sprom;
 	struct b43_phy *phy = &dev->phy;
 
+	/* TX to RX */
+	u8 tx2rx_events[7] = { 4, 3, 5, 2, 1, 8, 31, };
+	u8 tx2rx_delays[7] = { 8, 4, 4, 4, 4, 6, 1, };
+	/* RX to TX */
 	u8 rx2tx_events_ipa[9] = { 0x0, 0x1, 0x2, 0x8, 0x5, 0x6, 0xF, 0x3,
 					0x1F };
 	u8 rx2tx_delays_ipa[9] = { 8, 6, 6, 4, 4, 16, 43, 1, 1 };
 
-	u16 ntab7_15e_16e[] = { 0x10f, 0x10f };
+	static const u16 ntab7_15e_16e[] = { 0, 0x10f, 0x10f };
 	u8 ntab7_138_146[] = { 0x11, 0x11 };
 	u8 ntab7_133[] = { 0x77, 0x11, 0x11 };
 
-	u16 lpf_20, lpf_40, lpf_11b;
+	u16 lpf_ofdm_20mhz, lpf_ofdm_40mhz, lpf_11b;
 	u16 bcap_val, bcap_val_11b, bcap_val_11n_20, bcap_val_11n_40;
 	u16 scap_val, scap_val_11b, scap_val_11n_20, scap_val_11n_40;
 	bool rccal_ovrd = false;
@@ -2727,6 +2731,13 @@ static void b43_nphy_workarounds_rev7plus(struct b43_wldev *dev)
 	u32 tmp32;
 	u8 core;
 
+	b43_phy_write(dev, B43_NPHY_PHASETR_A0, 0x0125);
+	b43_phy_write(dev, B43_NPHY_PHASETR_A1, 0x01b3);
+	b43_phy_write(dev, B43_NPHY_PHASETR_A2, 0x0105);
+	b43_phy_write(dev, B43_NPHY_PHASETR_B0, 0x016e);
+	b43_phy_write(dev, B43_NPHY_PHASETR_B1, 0x00cd);
+	b43_phy_write(dev, B43_NPHY_PHASETR_B2, 0x0020);
+
 	if (phy->rev == 7) {
 		b43_phy_set(dev, B43_NPHY_FINERX2_CGC, 0x10);
 		b43_phy_maskset(dev, B43_NPHY_FREQGAIN0, 0xFF80, 0x0020);
@@ -2746,11 +2757,18 @@ static void b43_nphy_workarounds_rev7plus(struct b43_wldev *dev)
 		b43_phy_maskset(dev, B43_NPHY_FREQGAIN7, 0xFF80, 0x0040);
 		b43_phy_maskset(dev, B43_NPHY_FREQGAIN7, 0x80FF, 0x4000);
 	}
-	if (phy->rev <= 8) {
+
+	if (phy->rev >= 16) {
+		b43_phy_write(dev, B43_NPHY_FORCEFRONT0, 0x7ff);
+		b43_phy_write(dev, B43_NPHY_FORCEFRONT1, 0x7ff);
+	} else if (phy->rev <= 8) {
 		b43_phy_write(dev, B43_NPHY_FORCEFRONT0, 0x1B0);
 		b43_phy_write(dev, B43_NPHY_FORCEFRONT1, 0x1B0);
 	}
-	if (phy->rev >= 8)
+
+	if (phy->rev >= 16)
+		b43_phy_maskset(dev, B43_NPHY_TXTAILCNT, ~0xFF, 0xa0);
+	else if (phy->rev >= 8)
 		b43_phy_maskset(dev, B43_NPHY_TXTAILCNT, ~0xFF, 0x72);
 
 	b43_ntab_write(dev, B43_NTAB16(8, 0x00), 2);
@@ -2758,9 +2776,11 @@ static void b43_nphy_workarounds_rev7plus(struct b43_wldev *dev)
 	tmp32 = b43_ntab_read(dev, B43_NTAB32(30, 0));
 	tmp32 &= 0xffffff;
 	b43_ntab_write(dev, B43_NTAB32(30, 0), tmp32);
-	b43_ntab_write_bulk(dev, B43_NTAB16(7, 0x15e), 2, ntab7_15e_16e);
-	b43_ntab_write_bulk(dev, B43_NTAB16(7, 0x16e), 2, ntab7_15e_16e);
+	b43_ntab_write_bulk(dev, B43_NTAB16(7, 0x15d), 3, ntab7_15e_16e);
+	b43_ntab_write_bulk(dev, B43_NTAB16(7, 0x16d), 3, ntab7_15e_16e);
 
+	b43_nphy_set_rf_sequence(dev, 1, tx2rx_events, tx2rx_delays,
+				 ARRAY_SIZE(tx2rx_events));
 	if (b43_nphy_ipa(dev))
 		b43_nphy_set_rf_sequence(dev, 0, rx2tx_events_ipa,
 				rx2tx_delays_ipa, ARRAY_SIZE(rx2tx_events_ipa));
@@ -2768,44 +2788,53 @@ static void b43_nphy_workarounds_rev7plus(struct b43_wldev *dev)
 	b43_phy_maskset(dev, B43_NPHY_EPS_OVERRIDEI_0, 0x3FFF, 0x4000);
 	b43_phy_maskset(dev, B43_NPHY_EPS_OVERRIDEI_1, 0x3FFF, 0x4000);
 
-	lpf_20 = b43_nphy_read_lpf_ctl(dev, 0x154);
-	lpf_40 = b43_nphy_read_lpf_ctl(dev, 0x159);
+	lpf_ofdm_20mhz = b43_nphy_read_lpf_ctl(dev, 0x154);
+	lpf_ofdm_40mhz = b43_nphy_read_lpf_ctl(dev, 0x159);
 	lpf_11b = b43_nphy_read_lpf_ctl(dev, 0x152);
+
+	bcap_val = b43_radio_read(dev, R2057_RCCAL_BCAP_VAL);
+	scap_val = b43_radio_read(dev, R2057_RCCAL_SCAP_VAL);
+
 	if (b43_nphy_ipa(dev)) {
-		if ((phy->radio_rev == 5 && b43_is_40mhz(dev)) ||
-		    phy->radio_rev == 7 || phy->radio_rev == 8) {
-			bcap_val = b43_radio_read(dev, 0x16b);
-			scap_val = b43_radio_read(dev, 0x16a);
-			scap_val_11b = scap_val;
-			bcap_val_11b = bcap_val;
-			if (phy->radio_rev == 5 && b43_is_40mhz(dev)) {
+		switch (phy->radio_rev) {
+		case 5:
+			/* Check radio version (to be 0) by PHY rev for now */
+			if (phy->rev == 8 && b43_is_40mhz(dev)) {
+				scap_val_11b = scap_val;
+				bcap_val_11b = bcap_val;
 				scap_val_11n_20 = scap_val;
 				bcap_val_11n_20 = bcap_val;
 				scap_val_11n_40 = bcap_val_11n_40 = 0xc;
 				rccal_ovrd = true;
-			} else { /* Rev 7/8 */
-				lpf_20 = 4;
-				lpf_11b = 1;
-				if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
-					scap_val_11n_20 = 0xc;
-					bcap_val_11n_20 = 0xc;
-					scap_val_11n_40 = 0xa;
-					bcap_val_11n_40 = 0xa;
-				} else {
-					scap_val_11n_20 = 0x14;
-					bcap_val_11n_20 = 0x14;
-					scap_val_11n_40 = 0xf;
-					bcap_val_11n_40 = 0xf;
-				}
-				rccal_ovrd = true;
 			}
+			if (phy->rev == 9) {
+				/* TODO: Radio version 1 (e.g. BCM5357B0) */
+			}
+			break;
+		case 7:
+		case 8:
+			scap_val_11b = scap_val;
+			bcap_val_11b = bcap_val;
+			lpf_ofdm_20mhz = 4;
+			lpf_11b = 1;
+			if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+				scap_val_11n_20 = 0xc;
+				bcap_val_11n_20 = 0xc;
+				scap_val_11n_40 = 0xa;
+				bcap_val_11n_40 = 0xa;
+			} else {
+				scap_val_11n_20 = 0x14;
+				bcap_val_11n_20 = 0x14;
+				scap_val_11n_40 = 0xf;
+				bcap_val_11n_40 = 0xf;
+			}
+			rccal_ovrd = true;
+			break;
 		}
 	} else {
 		if (phy->radio_rev == 5) {
-			lpf_20 = 1;
-			lpf_40 = 3;
-			bcap_val = b43_radio_read(dev, 0x16b);
-			scap_val = b43_radio_read(dev, 0x16a);
+			lpf_ofdm_20mhz = 1;
+			lpf_ofdm_40mhz = 3;
 			scap_val_11b = scap_val;
 			bcap_val_11b = bcap_val;
 			scap_val_11n_20 = 0x11;
@@ -2816,15 +2845,20 @@ static void b43_nphy_workarounds_rev7plus(struct b43_wldev *dev)
 		}
 	}
 	if (rccal_ovrd) {
-		rx2tx_lut_20_11b = (bcap_val_11b << 8) |
+		u8 rx2tx_lut_extra = 1;
+
+		rx2tx_lut_20_11b = (rx2tx_lut_extra << 13) |
+				   (bcap_val_11b << 8) |
 				   (scap_val_11b << 3) |
 				   lpf_11b;
-		rx2tx_lut_20_11n = (bcap_val_11n_20 << 8) |
+		rx2tx_lut_20_11n = (rx2tx_lut_extra << 13) |
+				   (bcap_val_11n_20 << 8) |
 				   (scap_val_11n_20 << 3) |
-				   lpf_20;
-		rx2tx_lut_40_11n = (bcap_val_11n_40 << 8) |
+				   lpf_ofdm_20mhz;
+		rx2tx_lut_40_11n = (rx2tx_lut_extra << 13) |
+				   (bcap_val_11n_40 << 8) |
 				   (scap_val_11n_40 << 3) |
-				   lpf_40;
+				   lpf_ofdm_40mhz;
 		for (core = 0; core < 2; core++) {
 			b43_ntab_write(dev, B43_NTAB16(7, 0x152 + core * 16),
 				       rx2tx_lut_20_11b);
@@ -2893,7 +2927,8 @@ static void b43_nphy_workarounds_rev7plus(struct b43_wldev *dev)
 								0x7f);
 				}
 			}
-			if (phy->radio_rev == 3) {
+			switch (phy->radio_rev) {
+			case 3:
 				for (core = 0; core < 2; core++) {
 					if (core == 0) {
 						b43_radio_write(dev, 0x64,
@@ -2919,7 +2954,9 @@ static void b43_nphy_workarounds_rev7plus(struct b43_wldev *dev)
 								0x3E);
 					}
 				}
-			} else if (phy->radio_rev == 7 || phy->radio_rev == 8) {
+				break;
+			case 7:
+			case 8:
 				if (!b43_is_40mhz(dev)) {
 					b43_radio_write(dev, 0x5F, 0x14);
 					b43_radio_write(dev, 0xE8, 0x12);
@@ -2927,6 +2964,7 @@ static void b43_nphy_workarounds_rev7plus(struct b43_wldev *dev)
 					b43_radio_write(dev, 0x5F, 0x16);
 					b43_radio_write(dev, 0xE8, 0x16);
 				}
+				break;
 			}
 		} else {
 			u16 freq = phy->chandef->chan->center_freq;
-- 
1.8.4.5

