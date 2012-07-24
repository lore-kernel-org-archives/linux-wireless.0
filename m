Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46225 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583Ab2GXQeQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2012 12:34:16 -0400
Received: by wibhm11 with SMTP id hm11so4290261wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jul 2012 09:34:15 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] b43: N-PHY: add PHY rev7+ workarounds
Date: Tue, 24 Jul 2012 19:18:20 +0200
Message-Id: <1343150300-4002-2-git-send-email-zajec5@gmail.com> (sfid-20120724_183917_656212_417CCB0B)
In-Reply-To: <1343150300-4002-1-git-send-email-zajec5@gmail.com>
References: <1343150300-4002-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |  328 +++++++++++++++++++++++++++++++++++++-
 1 files changed, 326 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 40bb63d..e49d847 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1860,12 +1860,334 @@ static void b43_nphy_gain_ctl_workarounds_rev1_2(struct b43_wldev *dev)
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/WorkaroundsGainCtrl */
 static void b43_nphy_gain_ctl_workarounds(struct b43_wldev *dev)
 {
-	if (dev->phy.rev >= 3)
+	if (dev->phy.rev >= 7)
+		; /* TODO */
+	else if (dev->phy.rev >= 3)
 		b43_nphy_gain_ctl_workarounds_rev3plus(dev);
 	else
 		b43_nphy_gain_ctl_workarounds_rev1_2(dev);
 }
 
+/* http://bcm-v4.sipsolutions.net/PHY/N/Read_Lpf_Bw_Ctl */
+static u16 b43_nphy_read_lpf_ctl(struct b43_wldev *dev, u16 offset)
+{
+	if (!offset)
+		offset = (dev->phy.is_40mhz) ? 0x159 : 0x154;
+	return b43_ntab_read(dev, B43_NTAB16(7, offset)) & 0x7;
+}
+
+static void b43_nphy_workarounds_rev7plus(struct b43_wldev *dev)
+{
+	struct ssb_sprom *sprom = dev->dev->bus_sprom;
+	struct b43_phy *phy = &dev->phy;
+
+	u8 rx2tx_events_ipa[9] = { 0x0, 0x1, 0x2, 0x8, 0x5, 0x6, 0xF, 0x3,
+					0x1F };
+	u8 rx2tx_delays_ipa[9] = { 8, 6, 6, 4, 4, 16, 43, 1, 1 };
+
+	u16 ntab7_15e_16e[] = { 0x10f, 0x10f };
+	u8 ntab7_138_146[] = { 0x11, 0x11 };
+	u8 ntab7_133[] = { 0x77, 0x11, 0x11 };
+
+	u16 lpf_20, lpf_40, lpf_11b;
+	u16 bcap_val, bcap_val_11b, bcap_val_11n_20, bcap_val_11n_40;
+	u16 scap_val, scap_val_11b, scap_val_11n_20, scap_val_11n_40;
+	bool rccal_ovrd = false;
+
+	u16 rx2tx_lut_20_11b, rx2tx_lut_20_11n, rx2tx_lut_40_11n;
+	u16 bias, conv, filt;
+
+	u32 tmp32;
+	u8 core;
+
+	if (phy->rev == 7) {
+		b43_phy_set(dev, B43_NPHY_FINERX2_CGC, 0x10);
+		b43_phy_maskset(dev, B43_NPHY_FREQGAIN0, 0xFF80, 0x0020);
+		b43_phy_maskset(dev, B43_NPHY_FREQGAIN0, 0x80FF, 0x2700);
+		b43_phy_maskset(dev, B43_NPHY_FREQGAIN1, 0xFF80, 0x002E);
+		b43_phy_maskset(dev, B43_NPHY_FREQGAIN1, 0x80FF, 0x3300);
+		b43_phy_maskset(dev, B43_NPHY_FREQGAIN2, 0xFF80, 0x0037);
+		b43_phy_maskset(dev, B43_NPHY_FREQGAIN2, 0x80FF, 0x3A00);
+		b43_phy_maskset(dev, B43_NPHY_FREQGAIN3, 0xFF80, 0x003C);
+		b43_phy_maskset(dev, B43_NPHY_FREQGAIN3, 0x80FF, 0x3E00);
+		b43_phy_maskset(dev, B43_NPHY_FREQGAIN4, 0xFF80, 0x003E);
+		b43_phy_maskset(dev, B43_NPHY_FREQGAIN4, 0x80FF, 0x3F00);
+		b43_phy_maskset(dev, B43_NPHY_FREQGAIN5, 0xFF80, 0x0040);
+		b43_phy_maskset(dev, B43_NPHY_FREQGAIN5, 0x80FF, 0x4000);
+		b43_phy_maskset(dev, B43_NPHY_FREQGAIN6, 0xFF80, 0x0040);
+		b43_phy_maskset(dev, B43_NPHY_FREQGAIN6, 0x80FF, 0x4000);
+		b43_phy_maskset(dev, B43_NPHY_FREQGAIN7, 0xFF80, 0x0040);
+		b43_phy_maskset(dev, B43_NPHY_FREQGAIN7, 0x80FF, 0x4000);
+	}
+	if (phy->rev <= 8) {
+		b43_phy_write(dev, 0x23F, 0x1B0);
+		b43_phy_write(dev, 0x240, 0x1B0);
+	}
+	if (phy->rev >= 8)
+		b43_phy_maskset(dev, B43_NPHY_TXTAILCNT, ~0xFF, 0x72);
+
+	b43_ntab_write(dev, B43_NTAB16(8, 0x00), 2);
+	b43_ntab_write(dev, B43_NTAB16(8, 0x10), 2);
+	tmp32 = b43_ntab_read(dev, B43_NTAB32(30, 0));
+	tmp32 &= 0xffffff;
+	b43_ntab_write(dev, B43_NTAB32(30, 0), tmp32);
+	b43_ntab_write_bulk(dev, B43_NTAB16(7, 0x15e), 2, ntab7_15e_16e);
+	b43_ntab_write_bulk(dev, B43_NTAB16(7, 0x16e), 2, ntab7_15e_16e);
+
+	if (b43_nphy_ipa(dev))
+		b43_nphy_set_rf_sequence(dev, 0, rx2tx_events_ipa,
+				rx2tx_delays_ipa, ARRAY_SIZE(rx2tx_events_ipa));
+
+	b43_phy_maskset(dev, 0x299, 0x3FFF, 0x4000);
+	b43_phy_maskset(dev, 0x29D, 0x3FFF, 0x4000);
+
+	lpf_20 = b43_nphy_read_lpf_ctl(dev, 0x154);
+	lpf_40 = b43_nphy_read_lpf_ctl(dev, 0x159);
+	lpf_11b = b43_nphy_read_lpf_ctl(dev, 0x152);
+	if (b43_nphy_ipa(dev)) {
+		if ((phy->radio_rev == 5 && phy->is_40mhz) ||
+		    phy->radio_rev == 7 || phy->radio_rev == 8) {
+			bcap_val = b43_radio_read(dev, 0x16b);
+			scap_val = b43_radio_read(dev, 0x16a);
+			scap_val_11b = scap_val;
+			bcap_val_11b = bcap_val;
+			if (phy->radio_rev == 5 && phy->is_40mhz) {
+				scap_val_11n_20 = scap_val;
+				bcap_val_11n_20 = bcap_val;
+				scap_val_11n_40 = bcap_val_11n_40 = 0xc;
+				rccal_ovrd = true;
+			} else { /* Rev 7/8 */
+				lpf_20 = 4;
+				lpf_11b = 1;
+				if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+					scap_val_11n_20 = 0xc;
+					bcap_val_11n_20 = 0xc;
+					scap_val_11n_40 = 0xa;
+					bcap_val_11n_40 = 0xa;
+				} else {
+					scap_val_11n_20 = 0x14;
+					bcap_val_11n_20 = 0x14;
+					scap_val_11n_40 = 0xf;
+					bcap_val_11n_40 = 0xf;
+				}
+				rccal_ovrd = true;
+			}
+		}
+	} else {
+		if (phy->radio_rev == 5) {
+			lpf_20 = 1;
+			lpf_40 = 3;
+			bcap_val = b43_radio_read(dev, 0x16b);
+			scap_val = b43_radio_read(dev, 0x16a);
+			scap_val_11b = scap_val;
+			bcap_val_11b = bcap_val;
+			scap_val_11n_20 = 0x11;
+			scap_val_11n_40 = 0x11;
+			bcap_val_11n_20 = 0x13;
+			bcap_val_11n_40 = 0x13;
+			rccal_ovrd = true;
+		}
+	}
+	if (rccal_ovrd) {
+		rx2tx_lut_20_11b = (bcap_val_11b << 8) |
+				   (scap_val_11b << 3) |
+				   lpf_11b;
+		rx2tx_lut_20_11n = (bcap_val_11n_20 << 8) |
+				   (scap_val_11n_20 << 3) |
+				   lpf_20;
+		rx2tx_lut_40_11n = (bcap_val_11n_40 << 8) |
+				   (scap_val_11n_40 << 3) |
+				   lpf_40;
+		for (core = 0; core < 2; core++) {
+			b43_ntab_write(dev, B43_NTAB16(7, 0x152 + core * 16),
+				       rx2tx_lut_20_11b);
+			b43_ntab_write(dev, B43_NTAB16(7, 0x153 + core * 16),
+				       rx2tx_lut_20_11n);
+			b43_ntab_write(dev, B43_NTAB16(7, 0x154 + core * 16),
+				       rx2tx_lut_20_11n);
+			b43_ntab_write(dev, B43_NTAB16(7, 0x155 + core * 16),
+				       rx2tx_lut_40_11n);
+			b43_ntab_write(dev, B43_NTAB16(7, 0x156 + core * 16),
+				       rx2tx_lut_40_11n);
+			b43_ntab_write(dev, B43_NTAB16(7, 0x157 + core * 16),
+				       rx2tx_lut_40_11n);
+			b43_ntab_write(dev, B43_NTAB16(7, 0x158 + core * 16),
+				       rx2tx_lut_40_11n);
+			b43_ntab_write(dev, B43_NTAB16(7, 0x159 + core * 16),
+				       rx2tx_lut_40_11n);
+		}
+		/* b43_nphy_rf_control_override_rev7(dev, 16, 1, 3, 0, 2); */
+	}
+	b43_phy_write(dev, 0x32F, 0x3);
+	if (phy->radio_rev == 4 || phy->radio_rev == 6)
+		; /* b43_nphy_rf_control_override_rev7(dev, 4, 1, 3, 0, 0); */
+
+	if (phy->radio_rev == 3 || phy->radio_rev == 4 || phy->radio_rev == 6) {
+		if (sprom->revision &&
+		    sprom->boardflags2_hi & B43_BFH2_IPALVLSHIFT_3P3) {
+			b43_radio_write(dev, 0x5, 0x05);
+			b43_radio_write(dev, 0x6, 0x30);
+			b43_radio_write(dev, 0x7, 0x00);
+			b43_radio_set(dev, 0x4f, 0x1);
+			b43_radio_set(dev, 0xd4, 0x1);
+			bias = 0x1f;
+			conv = 0x6f;
+			filt = 0xaa;
+		} else {
+			bias = 0x2b;
+			conv = 0x7f;
+			filt = 0xee;
+		}
+		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+			for (core = 0; core < 2; core++) {
+				if (core == 0) {
+					b43_radio_write(dev, 0x5F, bias);
+					b43_radio_write(dev, 0x64, conv);
+					b43_radio_write(dev, 0x66, filt);
+				} else {
+					b43_radio_write(dev, 0xE8, bias);
+					b43_radio_write(dev, 0xE9, conv);
+					b43_radio_write(dev, 0xEB, filt);
+				}
+			}
+		}
+	}
+
+	if (b43_nphy_ipa(dev)) {
+		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+			if (phy->radio_rev == 3 || phy->radio_rev == 4 ||
+			    phy->radio_rev == 6) {
+				for (core = 0; core < 2; core++) {
+					if (core == 0)
+						b43_radio_write(dev, 0x51,
+								0x7f);
+					else
+						b43_radio_write(dev, 0xd6,
+								0x7f);
+				}
+			}
+			if (phy->radio_rev == 3) {
+				for (core = 0; core < 2; core++) {
+					if (core == 0) {
+						b43_radio_write(dev, 0x64,
+								0x13);
+						b43_radio_write(dev, 0x5F,
+								0x1F);
+						b43_radio_write(dev, 0x66,
+								0xEE);
+						b43_radio_write(dev, 0x59,
+								0x8A);
+						b43_radio_write(dev, 0x80,
+								0x3E);
+					} else {
+						b43_radio_write(dev, 0x69,
+								0x13);
+						b43_radio_write(dev, 0xE8,
+								0x1F);
+						b43_radio_write(dev, 0xEB,
+								0xEE);
+						b43_radio_write(dev, 0xDE,
+								0x8A);
+						b43_radio_write(dev, 0x105,
+								0x3E);
+					}
+				}
+			} else if (phy->radio_rev == 7 || phy->radio_rev == 8) {
+				if (!phy->is_40mhz) {
+					b43_radio_write(dev, 0x5F, 0x14);
+					b43_radio_write(dev, 0xE8, 0x12);
+				} else {
+					b43_radio_write(dev, 0x5F, 0x16);
+					b43_radio_write(dev, 0xE8, 0x16);
+				}
+			}
+		} else {
+			u16 freq = phy->channel_freq;
+			if ((freq >= 5180 && freq <= 5230) ||
+			    (freq >= 5745 && freq <= 5805)) {
+				b43_radio_write(dev, 0x7D, 0xFF);
+				b43_radio_write(dev, 0xFE, 0xFF);
+			}
+		}
+	} else {
+		if (phy->radio_rev != 5) {
+			for (core = 0; core < 2; core++) {
+				if (core == 0) {
+					b43_radio_write(dev, 0x5c, 0x61);
+					b43_radio_write(dev, 0x51, 0x70);
+				} else {
+					b43_radio_write(dev, 0xe1, 0x61);
+					b43_radio_write(dev, 0xd6, 0x70);
+				}
+			}
+		}
+	}
+
+	if (phy->radio_rev == 4) {
+		b43_ntab_write(dev, B43_NTAB16(8, 0x05), 0x20);
+		b43_ntab_write(dev, B43_NTAB16(8, 0x15), 0x20);
+		for (core = 0; core < 2; core++) {
+			if (core == 0) {
+				b43_radio_write(dev, 0x1a1, 0x00);
+				b43_radio_write(dev, 0x1a2, 0x3f);
+				b43_radio_write(dev, 0x1a6, 0x3f);
+			} else {
+				b43_radio_write(dev, 0x1a7, 0x00);
+				b43_radio_write(dev, 0x1ab, 0x3f);
+				b43_radio_write(dev, 0x1ac, 0x3f);
+			}
+		}
+	} else {
+		b43_phy_set(dev, B43_NPHY_AFECTL_C1, 0x4);
+		b43_phy_set(dev, B43_NPHY_AFECTL_OVER1, 0x4);
+		b43_phy_set(dev, B43_NPHY_AFECTL_C2, 0x4);
+		b43_phy_set(dev, B43_NPHY_AFECTL_OVER, 0x4);
+
+		b43_phy_mask(dev, B43_NPHY_AFECTL_C1, ~0x1);
+		b43_phy_set(dev, B43_NPHY_AFECTL_OVER1, 0x1);
+		b43_phy_mask(dev, B43_NPHY_AFECTL_C2, ~0x1);
+		b43_phy_set(dev, B43_NPHY_AFECTL_OVER, 0x1);
+		b43_ntab_write(dev, B43_NTAB16(8, 0x05), 0x20);
+		b43_ntab_write(dev, B43_NTAB16(8, 0x15), 0x20);
+
+		b43_phy_mask(dev, B43_NPHY_AFECTL_C1, ~0x4);
+		b43_phy_mask(dev, B43_NPHY_AFECTL_OVER1, ~0x4);
+		b43_phy_mask(dev, B43_NPHY_AFECTL_C2, ~0x4);
+		b43_phy_mask(dev, B43_NPHY_AFECTL_OVER, ~0x4);
+	}
+
+	b43_phy_write(dev, B43_NPHY_ENDROP_TLEN, 0x2);
+
+	b43_ntab_write(dev, B43_NTAB32(16, 0x100), 20);
+	b43_ntab_write_bulk(dev, B43_NTAB16(7, 0x138), 2, ntab7_138_146);
+	b43_ntab_write(dev, B43_NTAB16(7, 0x141), 0x77);
+	b43_ntab_write_bulk(dev, B43_NTAB16(7, 0x133), 3, ntab7_133);
+	b43_ntab_write_bulk(dev, B43_NTAB16(7, 0x146), 2, ntab7_138_146);
+	b43_ntab_write(dev, B43_NTAB16(7, 0x123), 0x77);
+	b43_ntab_write(dev, B43_NTAB16(7, 0x12A), 0x77);
+
+	if (!phy->is_40mhz) {
+		b43_ntab_write(dev, B43_NTAB32(16, 0x03), 0x18D);
+		b43_ntab_write(dev, B43_NTAB32(16, 0x7F), 0x18D);
+	} else {
+		b43_ntab_write(dev, B43_NTAB32(16, 0x03), 0x14D);
+		b43_ntab_write(dev, B43_NTAB32(16, 0x7F), 0x14D);
+	}
+
+	b43_nphy_gain_ctl_workarounds(dev);
+
+	/* TODO
+	b43_ntab_write_bulk(dev, B43_NTAB16(8, 0x08), 4,
+			    aux_adc_vmid_rev7_core0);
+	b43_ntab_write_bulk(dev, B43_NTAB16(8, 0x18), 4,
+			    aux_adc_vmid_rev7_core1);
+	b43_ntab_write_bulk(dev, B43_NTAB16(8, 0x0C), 4,
+			    aux_adc_gain_rev7);
+	b43_ntab_write_bulk(dev, B43_NTAB16(8, 0x1C), 4,
+			    aux_adc_gain_rev7);
+	*/
+}
+
 static void b43_nphy_workarounds_rev3plus(struct b43_wldev *dev)
 {
 	struct b43_phy_n *nphy = dev->phy.n;
@@ -2097,7 +2419,9 @@ static void b43_nphy_workarounds(struct b43_wldev *dev)
 	b43_phy_set(dev, B43_NPHY_IQFLIP,
 		    B43_NPHY_IQFLIP_ADC1 | B43_NPHY_IQFLIP_ADC2);
 
-	if (dev->phy.rev >= 3)
+	if (dev->phy.rev >= 7)
+		b43_nphy_workarounds_rev7plus(dev);
+	else if (dev->phy.rev >= 3)
 		b43_nphy_workarounds_rev3plus(dev);
 	else
 		b43_nphy_workarounds_rev1_2(dev);
-- 
1.7.7

