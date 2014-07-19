Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:36412 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761229AbaGSKxQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2014 06:53:16 -0400
Received: by mail-we0-f180.google.com with SMTP id w61so5568822wes.25
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jul 2014 03:53:15 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 5/7] b43: N-PHY: add rev7+ workarounds for radio revs 9 and 14
Date: Sat, 19 Jul 2014 12:52:45 +0200
Message-Id: <1405767167-30315-5-git-send-email-zajec5@gmail.com> (sfid-20140719_125320_131530_AA8C5574)
In-Reply-To: <1405767167-30315-1-git-send-email-zajec5@gmail.com>
References: <1405767167-30315-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c | 79 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 77 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 376dcf9..1052540 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -2722,9 +2722,9 @@ static void b43_nphy_workarounds_rev7plus(struct b43_wldev *dev)
 
 	u16 lpf_ofdm_20mhz[2], lpf_ofdm_40mhz[2], lpf_11b[2];
 	u16 bcap_val;
-	u16 bcap_val_11b[2], bcap_val_11n_20[2], bcap_val_11n_40[2];
+	s16 bcap_val_11b[2], bcap_val_11n_20[2], bcap_val_11n_40[2];
 	u16 scap_val;
-	u16 scap_val_11b[2], scap_val_11n_20[2], scap_val_11n_40[2];
+	s16 scap_val_11b[2], scap_val_11n_20[2], scap_val_11n_40[2];
 	bool rccal_ovrd = false;
 
 	u16 bias, conv, filt;
@@ -2799,6 +2799,8 @@ static void b43_nphy_workarounds_rev7plus(struct b43_wldev *dev)
 	scap_val = b43_radio_read(dev, R2057_RCCAL_SCAP_VAL);
 
 	if (b43_nphy_ipa(dev)) {
+		bool ghz2 = b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ;
+
 		switch (phy->radio_rev) {
 		case 5:
 			/* Check radio version (to be 0) by PHY rev for now */
@@ -2840,6 +2842,58 @@ static void b43_nphy_workarounds_rev7plus(struct b43_wldev *dev)
 
 			rccal_ovrd = true;
 			break;
+		case 9:
+			for (core = 0; core < 2; core++) {
+				bcap_val_11b[core] = bcap_val;
+				scap_val_11b[core] = scap_val;
+				lpf_11b[core] = 1;
+
+				if (ghz2) {
+					bcap_val_11n_20[core] = bcap_val + 13;
+					scap_val_11n_20[core] = scap_val + 15;
+				} else {
+					bcap_val_11n_20[core] = bcap_val + 14;
+					scap_val_11n_20[core] = scap_val + 15;
+				}
+				lpf_ofdm_20mhz[core] = 4;
+
+				if (ghz2) {
+					bcap_val_11n_40[core] = bcap_val - 7;
+					scap_val_11n_40[core] = scap_val - 5;
+				} else {
+					bcap_val_11n_40[core] = bcap_val + 2;
+					scap_val_11n_40[core] = scap_val + 4;
+				}
+				lpf_ofdm_40mhz[core] = 4;
+			}
+
+			rccal_ovrd = true;
+			break;
+		case 14:
+			for (core = 0; core < 2; core++) {
+				bcap_val_11b[core] = bcap_val;
+				scap_val_11b[core] = scap_val;
+				lpf_11b[core] = 1;
+			}
+
+			bcap_val_11n_20[0] = bcap_val + 20;
+			scap_val_11n_20[0] = scap_val + 20;
+			lpf_ofdm_20mhz[0] = 3;
+
+			bcap_val_11n_20[1] = bcap_val + 16;
+			scap_val_11n_20[1] = scap_val + 16;
+			lpf_ofdm_20mhz[1] = 3;
+
+			bcap_val_11n_40[0] = bcap_val + 20;
+			scap_val_11n_40[0] = scap_val + 20;
+			lpf_ofdm_40mhz[0] = 4;
+
+			bcap_val_11n_40[1] = bcap_val + 10;
+			scap_val_11n_40[1] = scap_val + 10;
+			lpf_ofdm_40mhz[1] = 4;
+
+			rccal_ovrd = true;
+			break;
 		}
 	} else {
 		if (phy->radio_rev == 5) {
@@ -2862,6 +2916,13 @@ static void b43_nphy_workarounds_rev7plus(struct b43_wldev *dev)
 		u8 rx2tx_lut_extra = 1;
 
 		for (core = 0; core < 2; core++) {
+			bcap_val_11b[core] = clamp_val(bcap_val_11b[core], 0, 0x1f);
+			scap_val_11b[core] = clamp_val(scap_val_11b[core], 0, 0x1f);
+			bcap_val_11n_20[core] = clamp_val(bcap_val_11n_20[core], 0, 0x1f);
+			scap_val_11n_20[core] = clamp_val(scap_val_11n_20[core], 0, 0x1f);
+			bcap_val_11n_40[core] = clamp_val(bcap_val_11n_40[core], 0, 0x1f);
+			scap_val_11n_40[core] = clamp_val(scap_val_11n_40[core], 0, 0x1f);
+
 			rx2tx_lut_20_11b[core] = (rx2tx_lut_extra << 13) |
 						 (bcap_val_11b[core] << 8) |
 						 (scap_val_11b[core] << 3) |
@@ -2982,6 +3043,20 @@ static void b43_nphy_workarounds_rev7plus(struct b43_wldev *dev)
 					b43_radio_write(dev, 0xE8, 0x16);
 				}
 				break;
+			case 14:
+				for (core = 0; core < 2; core++) {
+					int o = core ? 0x85 : 0;
+
+					b43_radio_write(dev, o + R2057_IPA2G_CASCONV_CORE0, 0x13);
+					b43_radio_write(dev, o + R2057_TXMIX2G_TUNE_BOOST_PU_CORE0, 0x21);
+					b43_radio_write(dev, o + R2057_IPA2G_BIAS_FILTER_CORE0, 0xff);
+					b43_radio_write(dev, o + R2057_PAD2G_IDACS_CORE0, 0x88);
+					b43_radio_write(dev, o + R2057_PAD2G_TUNE_PUS_CORE0, 0x23);
+					b43_radio_write(dev, o + R2057_IPA2G_IMAIN_CORE0, 0x16);
+					b43_radio_write(dev, o + R2057_PAD_BIAS_FILTER_BWS_CORE0, 0x3e);
+					b43_radio_write(dev, o + R2057_BACKUP1_CORE0, 0x10);
+				}
+				break;
 			}
 		} else {
 			u16 freq = phy->chandef->chan->center_freq;
-- 
1.8.4.5

