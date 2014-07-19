Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:49938 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760682AbaGSKxM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2014 06:53:12 -0400
Received: by mail-we0-f179.google.com with SMTP id u57so5536025wes.10
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jul 2014 03:53:11 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 4/7] b43: N-PHY: allow applying separated workarounds per core
Date: Sat, 19 Jul 2014 12:52:44 +0200
Message-Id: <1405767167-30315-4-git-send-email-zajec5@gmail.com> (sfid-20140719_125316_052067_A4D61835)
In-Reply-To: <1405767167-30315-1-git-send-email-zajec5@gmail.com>
References: <1405767167-30315-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Newer devices need different workarounds for cores 0 and 1.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c | 125 ++++++++++++++++++++++-----------------
 1 file changed, 71 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 448c676..376dcf9 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -2720,12 +2720,13 @@ static void b43_nphy_workarounds_rev7plus(struct b43_wldev *dev)
 	u8 ntab7_138_146[] = { 0x11, 0x11 };
 	u8 ntab7_133[] = { 0x77, 0x11, 0x11 };
 
-	u16 lpf_ofdm_20mhz, lpf_ofdm_40mhz, lpf_11b;
-	u16 bcap_val, bcap_val_11b, bcap_val_11n_20, bcap_val_11n_40;
-	u16 scap_val, scap_val_11b, scap_val_11n_20, scap_val_11n_40;
+	u16 lpf_ofdm_20mhz[2], lpf_ofdm_40mhz[2], lpf_11b[2];
+	u16 bcap_val;
+	u16 bcap_val_11b[2], bcap_val_11n_20[2], bcap_val_11n_40[2];
+	u16 scap_val;
+	u16 scap_val_11b[2], scap_val_11n_20[2], scap_val_11n_40[2];
 	bool rccal_ovrd = false;
 
-	u16 rx2tx_lut_20_11b, rx2tx_lut_20_11n, rx2tx_lut_40_11n;
 	u16 bias, conv, filt;
 
 	u32 tmp32;
@@ -2788,9 +2789,11 @@ static void b43_nphy_workarounds_rev7plus(struct b43_wldev *dev)
 	b43_phy_maskset(dev, B43_NPHY_EPS_OVERRIDEI_0, 0x3FFF, 0x4000);
 	b43_phy_maskset(dev, B43_NPHY_EPS_OVERRIDEI_1, 0x3FFF, 0x4000);
 
-	lpf_ofdm_20mhz = b43_nphy_read_lpf_ctl(dev, 0x154);
-	lpf_ofdm_40mhz = b43_nphy_read_lpf_ctl(dev, 0x159);
-	lpf_11b = b43_nphy_read_lpf_ctl(dev, 0x152);
+	for (core = 0; core < 2; core++) {
+		lpf_ofdm_20mhz[core] = b43_nphy_read_lpf_ctl(dev, 0x154 + core * 0x10);
+		lpf_ofdm_40mhz[core] = b43_nphy_read_lpf_ctl(dev, 0x159 + core * 0x10);
+		lpf_11b[core] = b43_nphy_read_lpf_ctl(dev, 0x152 + core * 0x10);
+	}
 
 	bcap_val = b43_radio_read(dev, R2057_RCCAL_BCAP_VAL);
 	scap_val = b43_radio_read(dev, R2057_RCCAL_SCAP_VAL);
@@ -2800,11 +2803,15 @@ static void b43_nphy_workarounds_rev7plus(struct b43_wldev *dev)
 		case 5:
 			/* Check radio version (to be 0) by PHY rev for now */
 			if (phy->rev == 8 && b43_is_40mhz(dev)) {
-				scap_val_11b = scap_val;
-				bcap_val_11b = bcap_val;
-				scap_val_11n_20 = scap_val;
-				bcap_val_11n_20 = bcap_val;
-				scap_val_11n_40 = bcap_val_11n_40 = 0xc;
+				for (core = 0; core < 2; core++) {
+					scap_val_11b[core] = scap_val;
+					bcap_val_11b[core] = bcap_val;
+					scap_val_11n_20[core] = scap_val;
+					bcap_val_11n_20[core] = bcap_val;
+					scap_val_11n_40[core] = 0xc;
+					bcap_val_11n_40[core] = 0xc;
+				}
+
 				rccal_ovrd = true;
 			}
 			if (phy->rev == 9) {
@@ -2813,69 +2820,79 @@ static void b43_nphy_workarounds_rev7plus(struct b43_wldev *dev)
 			break;
 		case 7:
 		case 8:
-			scap_val_11b = scap_val;
-			bcap_val_11b = bcap_val;
-			lpf_ofdm_20mhz = 4;
-			lpf_11b = 1;
-			if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
-				scap_val_11n_20 = 0xc;
-				bcap_val_11n_20 = 0xc;
-				scap_val_11n_40 = 0xa;
-				bcap_val_11n_40 = 0xa;
-			} else {
-				scap_val_11n_20 = 0x14;
-				bcap_val_11n_20 = 0x14;
-				scap_val_11n_40 = 0xf;
-				bcap_val_11n_40 = 0xf;
+			for (core = 0; core < 2; core++) {
+				scap_val_11b[core] = scap_val;
+				bcap_val_11b[core] = bcap_val;
+				lpf_ofdm_20mhz[core] = 4;
+				lpf_11b[core] = 1;
+				if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+					scap_val_11n_20[core] = 0xc;
+					bcap_val_11n_20[core] = 0xc;
+					scap_val_11n_40[core] = 0xa;
+					bcap_val_11n_40[core] = 0xa;
+				} else {
+					scap_val_11n_20[core] = 0x14;
+					bcap_val_11n_20[core] = 0x14;
+					scap_val_11n_40[core] = 0xf;
+					bcap_val_11n_40[core] = 0xf;
+				}
 			}
+
 			rccal_ovrd = true;
 			break;
 		}
 	} else {
 		if (phy->radio_rev == 5) {
-			lpf_ofdm_20mhz = 1;
-			lpf_ofdm_40mhz = 3;
-			scap_val_11b = scap_val;
-			bcap_val_11b = bcap_val;
-			scap_val_11n_20 = 0x11;
-			scap_val_11n_40 = 0x11;
-			bcap_val_11n_20 = 0x13;
-			bcap_val_11n_40 = 0x13;
+			for (core = 0; core < 2; core++) {
+				lpf_ofdm_20mhz[core] = 1;
+				lpf_ofdm_40mhz[core] = 3;
+				scap_val_11b[core] = scap_val;
+				bcap_val_11b[core] = bcap_val;
+				scap_val_11n_20[core] = 0x11;
+				scap_val_11n_40[core] = 0x11;
+				bcap_val_11n_20[core] = 0x13;
+				bcap_val_11n_40[core] = 0x13;
+			}
+
 			rccal_ovrd = true;
 		}
 	}
 	if (rccal_ovrd) {
+		u16 rx2tx_lut_20_11b[2], rx2tx_lut_20_11n[2], rx2tx_lut_40_11n[2];
 		u8 rx2tx_lut_extra = 1;
 
-		rx2tx_lut_20_11b = (rx2tx_lut_extra << 13) |
-				   (bcap_val_11b << 8) |
-				   (scap_val_11b << 3) |
-				   lpf_11b;
-		rx2tx_lut_20_11n = (rx2tx_lut_extra << 13) |
-				   (bcap_val_11n_20 << 8) |
-				   (scap_val_11n_20 << 3) |
-				   lpf_ofdm_20mhz;
-		rx2tx_lut_40_11n = (rx2tx_lut_extra << 13) |
-				   (bcap_val_11n_40 << 8) |
-				   (scap_val_11n_40 << 3) |
-				   lpf_ofdm_40mhz;
+		for (core = 0; core < 2; core++) {
+			rx2tx_lut_20_11b[core] = (rx2tx_lut_extra << 13) |
+						 (bcap_val_11b[core] << 8) |
+						 (scap_val_11b[core] << 3) |
+						 lpf_11b[core];
+			rx2tx_lut_20_11n[core] = (rx2tx_lut_extra << 13) |
+						 (bcap_val_11n_20[core] << 8) |
+						 (scap_val_11n_20[core] << 3) |
+						 lpf_ofdm_20mhz[core];
+			rx2tx_lut_40_11n[core] = (rx2tx_lut_extra << 13) |
+						 (bcap_val_11n_40[core] << 8) |
+						 (scap_val_11n_40[core] << 3) |
+						 lpf_ofdm_40mhz[core];
+		}
+
 		for (core = 0; core < 2; core++) {
 			b43_ntab_write(dev, B43_NTAB16(7, 0x152 + core * 16),
-				       rx2tx_lut_20_11b);
+				       rx2tx_lut_20_11b[core]);
 			b43_ntab_write(dev, B43_NTAB16(7, 0x153 + core * 16),
-				       rx2tx_lut_20_11n);
+				       rx2tx_lut_20_11n[core]);
 			b43_ntab_write(dev, B43_NTAB16(7, 0x154 + core * 16),
-				       rx2tx_lut_20_11n);
+				       rx2tx_lut_20_11n[core]);
 			b43_ntab_write(dev, B43_NTAB16(7, 0x155 + core * 16),
-				       rx2tx_lut_40_11n);
+				       rx2tx_lut_40_11n[core]);
 			b43_ntab_write(dev, B43_NTAB16(7, 0x156 + core * 16),
-				       rx2tx_lut_40_11n);
+				       rx2tx_lut_40_11n[core]);
 			b43_ntab_write(dev, B43_NTAB16(7, 0x157 + core * 16),
-				       rx2tx_lut_40_11n);
+				       rx2tx_lut_40_11n[core]);
 			b43_ntab_write(dev, B43_NTAB16(7, 0x158 + core * 16),
-				       rx2tx_lut_40_11n);
+				       rx2tx_lut_40_11n[core]);
 			b43_ntab_write(dev, B43_NTAB16(7, 0x159 + core * 16),
-				       rx2tx_lut_40_11n);
+				       rx2tx_lut_40_11n[core]);
 		}
 		b43_nphy_rf_ctl_override_rev7(dev, 16, 1, 3, false, 2);
 	}
-- 
1.8.4.5

