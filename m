Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:49641 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075Ab2GXQeP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2012 12:34:15 -0400
Received: by wibhm11 with SMTP id hm11so4290223wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jul 2012 09:34:13 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] b43: N-PHY: update workarounds
Date: Tue, 24 Jul 2012 19:18:19 +0200
Message-Id: <1343150300-4002-1-git-send-email-zajec5@gmail.com> (sfid-20120724_183909_242791_E5BA802C)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |   46 ++++++++++++++++++++++++-------------
 1 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index b92bb9c..40bb63d 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1916,7 +1916,7 @@ static void b43_nphy_workarounds_rev3plus(struct b43_wldev *dev)
 			rx2tx_delays[6] = 1;
 			rx2tx_events[7] = 0x1F;
 		}
-		b43_nphy_set_rf_sequence(dev, 1, rx2tx_events, rx2tx_delays,
+		b43_nphy_set_rf_sequence(dev, 0, rx2tx_events, rx2tx_delays,
 					 ARRAY_SIZE(rx2tx_events));
 	}
 
@@ -1926,8 +1926,13 @@ static void b43_nphy_workarounds_rev3plus(struct b43_wldev *dev)
 
 	b43_phy_maskset(dev, 0x294, 0xF0FF, 0x0700);
 
-	b43_ntab_write(dev, B43_NTAB32(16, 3), 0x18D);
-	b43_ntab_write(dev, B43_NTAB32(16, 127), 0x18D);
+	if (!dev->phy.is_40mhz) {
+		b43_ntab_write(dev, B43_NTAB32(16, 3), 0x18D);
+		b43_ntab_write(dev, B43_NTAB32(16, 127), 0x18D);
+	} else {
+		b43_ntab_write(dev, B43_NTAB32(16, 3), 0x14D);
+		b43_ntab_write(dev, B43_NTAB32(16, 127), 0x14D);
+	}
 
 	b43_nphy_gain_ctl_workarounds(dev);
 
@@ -1963,13 +1968,14 @@ static void b43_nphy_workarounds_rev3plus(struct b43_wldev *dev)
 	b43_ntab_write(dev, B43_NTAB32(30, 3), tmp32);
 
 	if (dev->phy.rev == 4 &&
-		b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
+	    b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
 		b43_radio_write(dev, B2056_TX0 | B2056_TX_GMBB_IDAC,
 				0x70);
 		b43_radio_write(dev, B2056_TX1 | B2056_TX_GMBB_IDAC,
 				0x70);
 	}
 
+	/* Dropped probably-always-true condition */
 	b43_phy_write(dev, 0x224, 0x03eb);
 	b43_phy_write(dev, 0x225, 0x03eb);
 	b43_phy_write(dev, 0x226, 0x0341);
@@ -1982,6 +1988,9 @@ static void b43_nphy_workarounds_rev3plus(struct b43_wldev *dev)
 	b43_phy_write(dev, 0x22d, 0x042b);
 	b43_phy_write(dev, 0x22e, 0x0381);
 	b43_phy_write(dev, 0x22f, 0x0381);
+
+	if (dev->phy.rev >= 6 && sprom->boardflags2_lo & B43_BFL2_SINGLEANT_CCK)
+		; /* TODO: 0x0080000000000000 HF */
 }
 
 static void b43_nphy_workarounds_rev1_2(struct b43_wldev *dev)
@@ -1996,6 +2005,12 @@ static void b43_nphy_workarounds_rev1_2(struct b43_wldev *dev)
 	u8 events2[7] = { 0x0, 0x3, 0x5, 0x4, 0x2, 0x1, 0x8 };
 	u8 delays2[7] = { 0x8, 0x6, 0x2, 0x4, 0x4, 0x6, 0x1 };
 
+	if (sprom->boardflags2_lo & B43_BFL2_SKWRKFEM_BRD ||
+	    dev->dev->board_type == 0x8B) {
+		delays1[0] = 0x1;
+		delays1[5] = 0x14;
+	}
+
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ &&
 	    nphy->band5g_pwrgain) {
 		b43_radio_mask(dev, B2055_C1_TX_RF_SPARE, ~0x8);
@@ -2007,8 +2022,10 @@ static void b43_nphy_workarounds_rev1_2(struct b43_wldev *dev)
 
 	b43_ntab_write(dev, B43_NTAB16(8, 0x00), 0x000A);
 	b43_ntab_write(dev, B43_NTAB16(8, 0x10), 0x000A);
-	b43_ntab_write(dev, B43_NTAB16(8, 0x02), 0xCDAA);
-	b43_ntab_write(dev, B43_NTAB16(8, 0x12), 0xCDAA);
+	if (dev->phy.rev < 3) {
+		b43_ntab_write(dev, B43_NTAB16(8, 0x02), 0xCDAA);
+		b43_ntab_write(dev, B43_NTAB16(8, 0x12), 0xCDAA);
+	}
 
 	if (dev->phy.rev < 2) {
 		b43_ntab_write(dev, B43_NTAB16(8, 0x08), 0x0000);
@@ -2024,11 +2041,6 @@ static void b43_nphy_workarounds_rev1_2(struct b43_wldev *dev)
 	b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_LO2, 0x2D8);
 	b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_UP2, 0x301);
 
-	if (sprom->boardflags2_lo & B43_BFL2_SKWRKFEM_BRD &&
-	    dev->dev->board_type == 0x8B) {
-		delays1[0] = 0x1;
-		delays1[5] = 0x14;
-	}
 	b43_nphy_set_rf_sequence(dev, 0, events1, delays1, 7);
 	b43_nphy_set_rf_sequence(dev, 1, events2, delays2, 7);
 
@@ -2055,11 +2067,13 @@ static void b43_nphy_workarounds_rev1_2(struct b43_wldev *dev)
 	b43_phy_write(dev, B43_NPHY_PHASETR_B1, 0xCD);
 	b43_phy_write(dev, B43_NPHY_PHASETR_B2, 0x20);
 
-	b43_phy_mask(dev, B43_NPHY_PIL_DW1,
-			~B43_NPHY_PIL_DW_64QAM & 0xFFFF);
-	b43_phy_write(dev, B43_NPHY_TXF_20CO_S2B1, 0xB5);
-	b43_phy_write(dev, B43_NPHY_TXF_20CO_S2B2, 0xA4);
-	b43_phy_write(dev, B43_NPHY_TXF_20CO_S2B3, 0x00);
+	if (dev->phy.rev < 3) {
+		b43_phy_mask(dev, B43_NPHY_PIL_DW1,
+			     ~B43_NPHY_PIL_DW_64QAM & 0xFFFF);
+		b43_phy_write(dev, B43_NPHY_TXF_20CO_S2B1, 0xB5);
+		b43_phy_write(dev, B43_NPHY_TXF_20CO_S2B2, 0xA4);
+		b43_phy_write(dev, B43_NPHY_TXF_20CO_S2B3, 0x00);
+	}
 
 	if (dev->phy.rev == 2)
 		b43_phy_set(dev, B43_NPHY_FINERX2_CGC,
-- 
1.7.7

