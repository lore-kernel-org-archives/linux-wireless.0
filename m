Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50435 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab1LQM4k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Dec 2011 07:56:40 -0500
Received: by eaaj10 with SMTP id j10so3614499eaa.19
        for <linux-wireless@vger.kernel.org>; Sat, 17 Dec 2011 04:56:38 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 7/8] b43: N-PHY: reorder functions: move rest of workarounds
Date: Sat, 17 Dec 2011 13:57:26 +0100
Message-Id: <1324126647-22425-8-git-send-email-zajec5@gmail.com> (sfid-20111217_135647_869282_FE1F73D1)
In-Reply-To: <1324126647-22425-1-git-send-email-zajec5@gmail.com>
References: <1324126647-22425-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |  452 +++++++++++++++++++-------------------
 1 files changed, 226 insertions(+), 226 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index f027909..17440a9 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1702,6 +1702,232 @@ static void b43_nphy_gain_ctl_workarounds(struct b43_wldev *dev)
 		b43_nphy_gain_ctl_workarounds_rev1_2(dev);
 }
 
+static void b43_nphy_workarounds_rev3plus(struct b43_wldev *dev)
+{
+	struct b43_phy_n *nphy = dev->phy.n;
+	struct ssb_sprom *sprom = dev->dev->bus_sprom;
+
+	/* TX to RX */
+	u8 tx2rx_events[8] = { 0x4, 0x3, 0x6, 0x5, 0x2, 0x1, 0x8, 0x1F };
+	u8 tx2rx_delays[8] = { 8, 4, 2, 2, 4, 4, 6, 1 };
+	/* RX to TX */
+	u8 rx2tx_events_ipa[9] = { 0x0, 0x1, 0x2, 0x8, 0x5, 0x6, 0xF, 0x3,
+					0x1F };
+	u8 rx2tx_delays_ipa[9] = { 8, 6, 6, 4, 4, 16, 43, 1, 1 };
+	u8 rx2tx_events[9] = { 0x0, 0x1, 0x2, 0x8, 0x5, 0x6, 0x3, 0x4, 0x1F };
+	u8 rx2tx_delays[9] = { 8, 6, 6, 4, 4, 18, 42, 1, 1 };
+
+	u16 tmp16;
+	u32 tmp32;
+
+	b43_phy_write(dev, 0x23f, 0x1f8);
+	b43_phy_write(dev, 0x240, 0x1f8);
+
+	tmp32 = b43_ntab_read(dev, B43_NTAB32(30, 0));
+	tmp32 &= 0xffffff;
+	b43_ntab_write(dev, B43_NTAB32(30, 0), tmp32);
+
+	b43_phy_write(dev, B43_NPHY_PHASETR_A0, 0x0125);
+	b43_phy_write(dev, B43_NPHY_PHASETR_A1, 0x01B3);
+	b43_phy_write(dev, B43_NPHY_PHASETR_A2, 0x0105);
+	b43_phy_write(dev, B43_NPHY_PHASETR_B0, 0x016E);
+	b43_phy_write(dev, B43_NPHY_PHASETR_B1, 0x00CD);
+	b43_phy_write(dev, B43_NPHY_PHASETR_B2, 0x0020);
+
+	b43_phy_write(dev, B43_NPHY_C2_CLIP1_MEDGAIN, 0x000C);
+	b43_phy_write(dev, 0x2AE, 0x000C);
+
+	/* TX to RX */
+	b43_nphy_set_rf_sequence(dev, 1, tx2rx_events, tx2rx_delays,
+				 ARRAY_SIZE(tx2rx_events));
+
+	/* RX to TX */
+	if (b43_nphy_ipa(dev))
+		b43_nphy_set_rf_sequence(dev, 0, rx2tx_events_ipa,
+				rx2tx_delays_ipa, ARRAY_SIZE(rx2tx_events_ipa));
+	if (nphy->hw_phyrxchain != 3 &&
+	    nphy->hw_phyrxchain != nphy->hw_phytxchain) {
+		if (b43_nphy_ipa(dev)) {
+			rx2tx_delays[5] = 59;
+			rx2tx_delays[6] = 1;
+			rx2tx_events[7] = 0x1F;
+		}
+		b43_nphy_set_rf_sequence(dev, 1, rx2tx_events, rx2tx_delays,
+					 ARRAY_SIZE(rx2tx_events));
+	}
+
+	tmp16 = (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) ?
+		0x2 : 0x9C40;
+	b43_phy_write(dev, B43_NPHY_ENDROP_TLEN, tmp16);
+
+	b43_phy_maskset(dev, 0x294, 0xF0FF, 0x0700);
+
+	b43_ntab_write(dev, B43_NTAB32(16, 3), 0x18D);
+	b43_ntab_write(dev, B43_NTAB32(16, 127), 0x18D);
+
+	b43_nphy_gain_ctl_workarounds(dev);
+
+	b43_ntab_write(dev, B43_NTAB16(8, 0), 2);
+	b43_ntab_write(dev, B43_NTAB16(8, 16), 2);
+
+	/* TODO */
+
+	b43_radio_write(dev, B2056_RX0 | B2056_RX_MIXA_MAST_BIAS, 0x00);
+	b43_radio_write(dev, B2056_RX1 | B2056_RX_MIXA_MAST_BIAS, 0x00);
+	b43_radio_write(dev, B2056_RX0 | B2056_RX_MIXA_BIAS_MAIN, 0x06);
+	b43_radio_write(dev, B2056_RX1 | B2056_RX_MIXA_BIAS_MAIN, 0x06);
+	b43_radio_write(dev, B2056_RX0 | B2056_RX_MIXA_BIAS_AUX, 0x07);
+	b43_radio_write(dev, B2056_RX1 | B2056_RX_MIXA_BIAS_AUX, 0x07);
+	b43_radio_write(dev, B2056_RX0 | B2056_RX_MIXA_LOB_BIAS, 0x88);
+	b43_radio_write(dev, B2056_RX1 | B2056_RX_MIXA_LOB_BIAS, 0x88);
+	b43_radio_write(dev, B2056_RX0 | B2056_RX_MIXA_CMFB_IDAC, 0x00);
+	b43_radio_write(dev, B2056_RX1 | B2056_RX_MIXA_CMFB_IDAC, 0x00);
+	b43_radio_write(dev, B2056_RX0 | B2056_RX_MIXG_CMFB_IDAC, 0x00);
+	b43_radio_write(dev, B2056_RX1 | B2056_RX_MIXG_CMFB_IDAC, 0x00);
+
+	/* N PHY WAR TX Chain Update with hw_phytxchain as argument */
+
+	if ((sprom->boardflags2_lo & B43_BFL2_APLL_WAR &&
+	     b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) ||
+	    (sprom->boardflags2_lo & B43_BFL2_GPLL_WAR &&
+	     b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ))
+		tmp32 = 0x00088888;
+	else
+		tmp32 = 0x88888888;
+	b43_ntab_write(dev, B43_NTAB32(30, 1), tmp32);
+	b43_ntab_write(dev, B43_NTAB32(30, 2), tmp32);
+	b43_ntab_write(dev, B43_NTAB32(30, 3), tmp32);
+
+	if (dev->phy.rev == 4 &&
+		b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
+		b43_radio_write(dev, B2056_TX0 | B2056_TX_GMBB_IDAC,
+				0x70);
+		b43_radio_write(dev, B2056_TX1 | B2056_TX_GMBB_IDAC,
+				0x70);
+	}
+
+	b43_phy_write(dev, 0x224, 0x03eb);
+	b43_phy_write(dev, 0x225, 0x03eb);
+	b43_phy_write(dev, 0x226, 0x0341);
+	b43_phy_write(dev, 0x227, 0x0341);
+	b43_phy_write(dev, 0x228, 0x042b);
+	b43_phy_write(dev, 0x229, 0x042b);
+	b43_phy_write(dev, 0x22a, 0x0381);
+	b43_phy_write(dev, 0x22b, 0x0381);
+	b43_phy_write(dev, 0x22c, 0x042b);
+	b43_phy_write(dev, 0x22d, 0x042b);
+	b43_phy_write(dev, 0x22e, 0x0381);
+	b43_phy_write(dev, 0x22f, 0x0381);
+}
+
+static void b43_nphy_workarounds_rev1_2(struct b43_wldev *dev)
+{
+	struct ssb_sprom *sprom = dev->dev->bus_sprom;
+	struct b43_phy *phy = &dev->phy;
+	struct b43_phy_n *nphy = phy->n;
+
+	u8 events1[7] = { 0x0, 0x1, 0x2, 0x8, 0x4, 0x5, 0x3 };
+	u8 delays1[7] = { 0x8, 0x6, 0x6, 0x2, 0x4, 0x3C, 0x1 };
+
+	u8 events2[7] = { 0x0, 0x3, 0x5, 0x4, 0x2, 0x1, 0x8 };
+	u8 delays2[7] = { 0x8, 0x6, 0x2, 0x4, 0x4, 0x6, 0x1 };
+
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ &&
+	    nphy->band5g_pwrgain) {
+		b43_radio_mask(dev, B2055_C1_TX_RF_SPARE, ~0x8);
+		b43_radio_mask(dev, B2055_C2_TX_RF_SPARE, ~0x8);
+	} else {
+		b43_radio_set(dev, B2055_C1_TX_RF_SPARE, 0x8);
+		b43_radio_set(dev, B2055_C2_TX_RF_SPARE, 0x8);
+	}
+
+	b43_ntab_write(dev, B43_NTAB16(8, 0x00), 0x000A);
+	b43_ntab_write(dev, B43_NTAB16(8, 0x10), 0x000A);
+	b43_ntab_write(dev, B43_NTAB16(8, 0x02), 0xCDAA);
+	b43_ntab_write(dev, B43_NTAB16(8, 0x12), 0xCDAA);
+
+	if (dev->phy.rev < 2) {
+		b43_ntab_write(dev, B43_NTAB16(8, 0x08), 0x0000);
+		b43_ntab_write(dev, B43_NTAB16(8, 0x18), 0x0000);
+		b43_ntab_write(dev, B43_NTAB16(8, 0x07), 0x7AAB);
+		b43_ntab_write(dev, B43_NTAB16(8, 0x17), 0x7AAB);
+		b43_ntab_write(dev, B43_NTAB16(8, 0x06), 0x0800);
+		b43_ntab_write(dev, B43_NTAB16(8, 0x16), 0x0800);
+	}
+
+	b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_LO1, 0x2D8);
+	b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_UP1, 0x301);
+	b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_LO2, 0x2D8);
+	b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_UP2, 0x301);
+
+	if (sprom->boardflags2_lo & B43_BFL2_SKWRKFEM_BRD &&
+	    dev->dev->board_type == 0x8B) {
+		delays1[0] = 0x1;
+		delays1[5] = 0x14;
+	}
+	b43_nphy_set_rf_sequence(dev, 0, events1, delays1, 7);
+	b43_nphy_set_rf_sequence(dev, 1, events2, delays2, 7);
+
+	b43_nphy_gain_ctl_workarounds(dev);
+
+	if (dev->phy.rev < 2) {
+		if (b43_phy_read(dev, B43_NPHY_RXCTL) & 0x2)
+			b43_hf_write(dev, b43_hf_read(dev) |
+					B43_HF_MLADVW);
+	} else if (dev->phy.rev == 2) {
+		b43_phy_write(dev, B43_NPHY_CRSCHECK2, 0);
+		b43_phy_write(dev, B43_NPHY_CRSCHECK3, 0);
+	}
+
+	if (dev->phy.rev < 2)
+		b43_phy_mask(dev, B43_NPHY_SCRAM_SIGCTL,
+				~B43_NPHY_SCRAM_SIGCTL_SCM);
+
+	/* Set phase track alpha and beta */
+	b43_phy_write(dev, B43_NPHY_PHASETR_A0, 0x125);
+	b43_phy_write(dev, B43_NPHY_PHASETR_A1, 0x1B3);
+	b43_phy_write(dev, B43_NPHY_PHASETR_A2, 0x105);
+	b43_phy_write(dev, B43_NPHY_PHASETR_B0, 0x16E);
+	b43_phy_write(dev, B43_NPHY_PHASETR_B1, 0xCD);
+	b43_phy_write(dev, B43_NPHY_PHASETR_B2, 0x20);
+
+	b43_phy_mask(dev, B43_NPHY_PIL_DW1,
+			~B43_NPHY_PIL_DW_64QAM & 0xFFFF);
+	b43_phy_write(dev, B43_NPHY_TXF_20CO_S2B1, 0xB5);
+	b43_phy_write(dev, B43_NPHY_TXF_20CO_S2B2, 0xA4);
+	b43_phy_write(dev, B43_NPHY_TXF_20CO_S2B3, 0x00);
+
+	if (dev->phy.rev == 2)
+		b43_phy_set(dev, B43_NPHY_FINERX2_CGC,
+				B43_NPHY_FINERX2_CGC_DECGC);
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/Workarounds */
+static void b43_nphy_workarounds(struct b43_wldev *dev)
+{
+	struct b43_phy *phy = &dev->phy;
+	struct b43_phy_n *nphy = phy->n;
+
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ)
+		b43_nphy_classifier(dev, 1, 0);
+	else
+		b43_nphy_classifier(dev, 1, 1);
+
+	if (nphy->hang_avoid)
+		b43_nphy_stay_in_carrier_search(dev, 1);
+
+	b43_phy_set(dev, B43_NPHY_IQFLIP,
+		    B43_NPHY_IQFLIP_ADC1 | B43_NPHY_IQFLIP_ADC2);
+
+	if (dev->phy.rev >= 3)
+		b43_nphy_workarounds_rev3plus(dev);
+	else
+		b43_nphy_workarounds_rev1_2(dev);
+
+	if (nphy->hang_avoid)
+		b43_nphy_stay_in_carrier_search(dev, 0);
+}
+
 /**************************************************
  * Others
  **************************************************/
@@ -2514,232 +2740,6 @@ static void b43_nphy_spur_workaround(struct b43_wldev *dev)
 		b43_nphy_stay_in_carrier_search(dev, 0);
 }
 
-static void b43_nphy_workarounds_rev3plus(struct b43_wldev *dev)
-{
-	struct b43_phy_n *nphy = dev->phy.n;
-	struct ssb_sprom *sprom = dev->dev->bus_sprom;
-
-	/* TX to RX */
-	u8 tx2rx_events[8] = { 0x4, 0x3, 0x6, 0x5, 0x2, 0x1, 0x8, 0x1F };
-	u8 tx2rx_delays[8] = { 8, 4, 2, 2, 4, 4, 6, 1 };
-	/* RX to TX */
-	u8 rx2tx_events_ipa[9] = { 0x0, 0x1, 0x2, 0x8, 0x5, 0x6, 0xF, 0x3,
-					0x1F };
-	u8 rx2tx_delays_ipa[9] = { 8, 6, 6, 4, 4, 16, 43, 1, 1 };
-	u8 rx2tx_events[9] = { 0x0, 0x1, 0x2, 0x8, 0x5, 0x6, 0x3, 0x4, 0x1F };
-	u8 rx2tx_delays[9] = { 8, 6, 6, 4, 4, 18, 42, 1, 1 };
-
-	u16 tmp16;
-	u32 tmp32;
-
-	b43_phy_write(dev, 0x23f, 0x1f8);
-	b43_phy_write(dev, 0x240, 0x1f8);
-
-	tmp32 = b43_ntab_read(dev, B43_NTAB32(30, 0));
-	tmp32 &= 0xffffff;
-	b43_ntab_write(dev, B43_NTAB32(30, 0), tmp32);
-
-	b43_phy_write(dev, B43_NPHY_PHASETR_A0, 0x0125);
-	b43_phy_write(dev, B43_NPHY_PHASETR_A1, 0x01B3);
-	b43_phy_write(dev, B43_NPHY_PHASETR_A2, 0x0105);
-	b43_phy_write(dev, B43_NPHY_PHASETR_B0, 0x016E);
-	b43_phy_write(dev, B43_NPHY_PHASETR_B1, 0x00CD);
-	b43_phy_write(dev, B43_NPHY_PHASETR_B2, 0x0020);
-
-	b43_phy_write(dev, B43_NPHY_C2_CLIP1_MEDGAIN, 0x000C);
-	b43_phy_write(dev, 0x2AE, 0x000C);
-
-	/* TX to RX */
-	b43_nphy_set_rf_sequence(dev, 1, tx2rx_events, tx2rx_delays,
-				 ARRAY_SIZE(tx2rx_events));
-
-	/* RX to TX */
-	if (b43_nphy_ipa(dev))
-		b43_nphy_set_rf_sequence(dev, 0, rx2tx_events_ipa,
-				rx2tx_delays_ipa, ARRAY_SIZE(rx2tx_events_ipa));
-	if (nphy->hw_phyrxchain != 3 &&
-	    nphy->hw_phyrxchain != nphy->hw_phytxchain) {
-		if (b43_nphy_ipa(dev)) {
-			rx2tx_delays[5] = 59;
-			rx2tx_delays[6] = 1;
-			rx2tx_events[7] = 0x1F;
-		}
-		b43_nphy_set_rf_sequence(dev, 1, rx2tx_events, rx2tx_delays,
-					 ARRAY_SIZE(rx2tx_events));
-	}
-
-	tmp16 = (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) ?
-		0x2 : 0x9C40;
-	b43_phy_write(dev, B43_NPHY_ENDROP_TLEN, tmp16);
-
-	b43_phy_maskset(dev, 0x294, 0xF0FF, 0x0700);
-
-	b43_ntab_write(dev, B43_NTAB32(16, 3), 0x18D);
-	b43_ntab_write(dev, B43_NTAB32(16, 127), 0x18D);
-
-	b43_nphy_gain_ctl_workarounds(dev);
-
-	b43_ntab_write(dev, B43_NTAB16(8, 0), 2);
-	b43_ntab_write(dev, B43_NTAB16(8, 16), 2);
-
-	/* TODO */
-
-	b43_radio_write(dev, B2056_RX0 | B2056_RX_MIXA_MAST_BIAS, 0x00);
-	b43_radio_write(dev, B2056_RX1 | B2056_RX_MIXA_MAST_BIAS, 0x00);
-	b43_radio_write(dev, B2056_RX0 | B2056_RX_MIXA_BIAS_MAIN, 0x06);
-	b43_radio_write(dev, B2056_RX1 | B2056_RX_MIXA_BIAS_MAIN, 0x06);
-	b43_radio_write(dev, B2056_RX0 | B2056_RX_MIXA_BIAS_AUX, 0x07);
-	b43_radio_write(dev, B2056_RX1 | B2056_RX_MIXA_BIAS_AUX, 0x07);
-	b43_radio_write(dev, B2056_RX0 | B2056_RX_MIXA_LOB_BIAS, 0x88);
-	b43_radio_write(dev, B2056_RX1 | B2056_RX_MIXA_LOB_BIAS, 0x88);
-	b43_radio_write(dev, B2056_RX0 | B2056_RX_MIXA_CMFB_IDAC, 0x00);
-	b43_radio_write(dev, B2056_RX1 | B2056_RX_MIXA_CMFB_IDAC, 0x00);
-	b43_radio_write(dev, B2056_RX0 | B2056_RX_MIXG_CMFB_IDAC, 0x00);
-	b43_radio_write(dev, B2056_RX1 | B2056_RX_MIXG_CMFB_IDAC, 0x00);
-
-	/* N PHY WAR TX Chain Update with hw_phytxchain as argument */
-
-	if ((sprom->boardflags2_lo & B43_BFL2_APLL_WAR &&
-	     b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) ||
-	    (sprom->boardflags2_lo & B43_BFL2_GPLL_WAR &&
-	     b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ))
-		tmp32 = 0x00088888;
-	else
-		tmp32 = 0x88888888;
-	b43_ntab_write(dev, B43_NTAB32(30, 1), tmp32);
-	b43_ntab_write(dev, B43_NTAB32(30, 2), tmp32);
-	b43_ntab_write(dev, B43_NTAB32(30, 3), tmp32);
-
-	if (dev->phy.rev == 4 &&
-		b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
-		b43_radio_write(dev, B2056_TX0 | B2056_TX_GMBB_IDAC,
-				0x70);
-		b43_radio_write(dev, B2056_TX1 | B2056_TX_GMBB_IDAC,
-				0x70);
-	}
-
-	b43_phy_write(dev, 0x224, 0x03eb);
-	b43_phy_write(dev, 0x225, 0x03eb);
-	b43_phy_write(dev, 0x226, 0x0341);
-	b43_phy_write(dev, 0x227, 0x0341);
-	b43_phy_write(dev, 0x228, 0x042b);
-	b43_phy_write(dev, 0x229, 0x042b);
-	b43_phy_write(dev, 0x22a, 0x0381);
-	b43_phy_write(dev, 0x22b, 0x0381);
-	b43_phy_write(dev, 0x22c, 0x042b);
-	b43_phy_write(dev, 0x22d, 0x042b);
-	b43_phy_write(dev, 0x22e, 0x0381);
-	b43_phy_write(dev, 0x22f, 0x0381);
-}
-
-static void b43_nphy_workarounds_rev1_2(struct b43_wldev *dev)
-{
-	struct ssb_sprom *sprom = dev->dev->bus_sprom;
-	struct b43_phy *phy = &dev->phy;
-	struct b43_phy_n *nphy = phy->n;
-
-	u8 events1[7] = { 0x0, 0x1, 0x2, 0x8, 0x4, 0x5, 0x3 };
-	u8 delays1[7] = { 0x8, 0x6, 0x6, 0x2, 0x4, 0x3C, 0x1 };
-
-	u8 events2[7] = { 0x0, 0x3, 0x5, 0x4, 0x2, 0x1, 0x8 };
-	u8 delays2[7] = { 0x8, 0x6, 0x2, 0x4, 0x4, 0x6, 0x1 };
-
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ &&
-	    nphy->band5g_pwrgain) {
-		b43_radio_mask(dev, B2055_C1_TX_RF_SPARE, ~0x8);
-		b43_radio_mask(dev, B2055_C2_TX_RF_SPARE, ~0x8);
-	} else {
-		b43_radio_set(dev, B2055_C1_TX_RF_SPARE, 0x8);
-		b43_radio_set(dev, B2055_C2_TX_RF_SPARE, 0x8);
-	}
-
-	b43_ntab_write(dev, B43_NTAB16(8, 0x00), 0x000A);
-	b43_ntab_write(dev, B43_NTAB16(8, 0x10), 0x000A);
-	b43_ntab_write(dev, B43_NTAB16(8, 0x02), 0xCDAA);
-	b43_ntab_write(dev, B43_NTAB16(8, 0x12), 0xCDAA);
-
-	if (dev->phy.rev < 2) {
-		b43_ntab_write(dev, B43_NTAB16(8, 0x08), 0x0000);
-		b43_ntab_write(dev, B43_NTAB16(8, 0x18), 0x0000);
-		b43_ntab_write(dev, B43_NTAB16(8, 0x07), 0x7AAB);
-		b43_ntab_write(dev, B43_NTAB16(8, 0x17), 0x7AAB);
-		b43_ntab_write(dev, B43_NTAB16(8, 0x06), 0x0800);
-		b43_ntab_write(dev, B43_NTAB16(8, 0x16), 0x0800);
-	}
-
-	b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_LO1, 0x2D8);
-	b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_UP1, 0x301);
-	b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_LO2, 0x2D8);
-	b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_UP2, 0x301);
-
-	if (sprom->boardflags2_lo & B43_BFL2_SKWRKFEM_BRD &&
-	    dev->dev->board_type == 0x8B) {
-		delays1[0] = 0x1;
-		delays1[5] = 0x14;
-	}
-	b43_nphy_set_rf_sequence(dev, 0, events1, delays1, 7);
-	b43_nphy_set_rf_sequence(dev, 1, events2, delays2, 7);
-
-	b43_nphy_gain_ctl_workarounds(dev);
-
-	if (dev->phy.rev < 2) {
-		if (b43_phy_read(dev, B43_NPHY_RXCTL) & 0x2)
-			b43_hf_write(dev, b43_hf_read(dev) |
-					B43_HF_MLADVW);
-	} else if (dev->phy.rev == 2) {
-		b43_phy_write(dev, B43_NPHY_CRSCHECK2, 0);
-		b43_phy_write(dev, B43_NPHY_CRSCHECK3, 0);
-	}
-
-	if (dev->phy.rev < 2)
-		b43_phy_mask(dev, B43_NPHY_SCRAM_SIGCTL,
-				~B43_NPHY_SCRAM_SIGCTL_SCM);
-
-	/* Set phase track alpha and beta */
-	b43_phy_write(dev, B43_NPHY_PHASETR_A0, 0x125);
-	b43_phy_write(dev, B43_NPHY_PHASETR_A1, 0x1B3);
-	b43_phy_write(dev, B43_NPHY_PHASETR_A2, 0x105);
-	b43_phy_write(dev, B43_NPHY_PHASETR_B0, 0x16E);
-	b43_phy_write(dev, B43_NPHY_PHASETR_B1, 0xCD);
-	b43_phy_write(dev, B43_NPHY_PHASETR_B2, 0x20);
-
-	b43_phy_mask(dev, B43_NPHY_PIL_DW1,
-			~B43_NPHY_PIL_DW_64QAM & 0xFFFF);
-	b43_phy_write(dev, B43_NPHY_TXF_20CO_S2B1, 0xB5);
-	b43_phy_write(dev, B43_NPHY_TXF_20CO_S2B2, 0xA4);
-	b43_phy_write(dev, B43_NPHY_TXF_20CO_S2B3, 0x00);
-
-	if (dev->phy.rev == 2)
-		b43_phy_set(dev, B43_NPHY_FINERX2_CGC,
-				B43_NPHY_FINERX2_CGC_DECGC);
-}
-
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/Workarounds */
-static void b43_nphy_workarounds(struct b43_wldev *dev)
-{
-	struct b43_phy *phy = &dev->phy;
-	struct b43_phy_n *nphy = phy->n;
-
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ)
-		b43_nphy_classifier(dev, 1, 0);
-	else
-		b43_nphy_classifier(dev, 1, 1);
-
-	if (nphy->hang_avoid)
-		b43_nphy_stay_in_carrier_search(dev, 1);
-
-	b43_phy_set(dev, B43_NPHY_IQFLIP,
-		    B43_NPHY_IQFLIP_ADC1 | B43_NPHY_IQFLIP_ADC2);
-
-	if (dev->phy.rev >= 3)
-		b43_nphy_workarounds_rev3plus(dev);
-	else
-		b43_nphy_workarounds_rev1_2(dev);
-
-	if (nphy->hang_avoid)
-		b43_nphy_stay_in_carrier_search(dev, 0);
-}
-
 /*
  * Transmits a known value for LO calibration
  * http://bcm-v4.sipsolutions.net/802.11/PHY/N/TXTone
-- 
1.7.7

