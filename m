Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:38955 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaDZS4O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Apr 2014 14:56:14 -0400
Received: by mail-ee0-f45.google.com with SMTP id d17so3652771eek.32
        for <linux-wireless@vger.kernel.org>; Sat, 26 Apr 2014 11:56:13 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: N-PHY: complete radio 0x2056 setup
Date: Sat, 26 Apr 2014 20:56:05 +0200
Message-Id: <1398538565-28188-1-git-send-email-zajec5@gmail.com> (sfid-20140426_205619_985664_E246C0F5)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c | 32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 482b312..41dab89 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -807,9 +807,16 @@ static void b43_radio_2056_setup(struct b43_wldev *dev,
 	u16 bias, cbias;
 	u16 pag_boost, padg_boost, pgag_boost, mixg_boost;
 	u16 paa_boost, pada_boost, pgaa_boost, mixa_boost;
+	bool is_pkg_fab_smic;
 
 	B43_WARN_ON(dev->phy.rev < 3);
 
+	is_pkg_fab_smic =
+		((dev->dev->chip_id == BCMA_CHIP_ID_BCM43224 ||
+		  dev->dev->chip_id == BCMA_CHIP_ID_BCM43225 ||
+		  dev->dev->chip_id == BCMA_CHIP_ID_BCM43421) &&
+		 dev->dev->chip_pkg == BCMA_PKG_ID_BCM43224_FAB_SMIC);
+
 	b43_chantab_radio_2056_upload(dev, e);
 	b2056_upload_syn_pll_cp2(dev, band == IEEE80211_BAND_5GHZ);
 
@@ -817,7 +824,8 @@ static void b43_radio_2056_setup(struct b43_wldev *dev,
 	    b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
 		b43_radio_write(dev, B2056_SYN_PLL_LOOPFILTER1, 0x1F);
 		b43_radio_write(dev, B2056_SYN_PLL_LOOPFILTER2, 0x1F);
-		if (dev->dev->chip_id == 0x4716) {
+		if (dev->dev->chip_id == BCMA_CHIP_ID_BCM4716 ||
+		    dev->dev->chip_id == BCMA_CHIP_ID_BCM47162) {
 			b43_radio_write(dev, B2056_SYN_PLL_LOOPFILTER4, 0x14);
 			b43_radio_write(dev, B2056_SYN_PLL_CP2, 0);
 		} else {
@@ -825,6 +833,13 @@ static void b43_radio_2056_setup(struct b43_wldev *dev,
 			b43_radio_write(dev, B2056_SYN_PLL_CP2, 0x14);
 		}
 	}
+	if (sprom->boardflags2_hi & B43_BFH2_GPLL_WAR2 &&
+	    b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+		b43_radio_write(dev, B2056_SYN_PLL_LOOPFILTER1, 0x1f);
+		b43_radio_write(dev, B2056_SYN_PLL_LOOPFILTER2, 0x1f);
+		b43_radio_write(dev, B2056_SYN_PLL_LOOPFILTER4, 0x0b);
+		b43_radio_write(dev, B2056_SYN_PLL_CP2, 0x20);
+	}
 	if (sprom->boardflags2_lo & B43_BFL2_APLL_WAR &&
 	    b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
 		b43_radio_write(dev, B2056_SYN_PLL_LOOPFILTER1, 0x1F);
@@ -840,7 +855,8 @@ static void b43_radio_2056_setup(struct b43_wldev *dev,
 				b43_radio_write(dev,
 					offset | B2056_TX_PADG_IDAC, 0xcc);
 
-				if (dev->dev->chip_id == 0x4716) {
+				if (dev->dev->chip_id == BCMA_CHIP_ID_BCM4716 ||
+				    dev->dev->chip_id == BCMA_CHIP_ID_BCM47162) {
 					bias = 0x40;
 					cbias = 0x45;
 					pag_boost = 0x5;
@@ -849,6 +865,10 @@ static void b43_radio_2056_setup(struct b43_wldev *dev,
 				} else {
 					bias = 0x25;
 					cbias = 0x20;
+					if (is_pkg_fab_smic) {
+						bias = 0x2a;
+						cbias = 0x38;
+					}
 					pag_boost = 0x4;
 					pgag_boost = 0x03;
 					mixg_boost = 0x65;
@@ -917,6 +937,8 @@ static void b43_radio_2056_setup(struct b43_wldev *dev,
 			mixa_boost = 0xF;
 		}
 
+		cbias = is_pkg_fab_smic ? 0x35 : 0x30;
+
 		for (i = 0; i < 2; i++) {
 			offset = i ? B2056_TX1 : B2056_TX0;
 
@@ -935,11 +957,11 @@ static void b43_radio_2056_setup(struct b43_wldev *dev,
 			b43_radio_write(dev,
 				offset | B2056_TX_PADA_CASCBIAS, 0x03);
 			b43_radio_write(dev,
-				offset | B2056_TX_INTPAA_IAUX_STAT, 0x50);
+				offset | B2056_TX_INTPAA_IAUX_STAT, 0x30);
 			b43_radio_write(dev,
-				offset | B2056_TX_INTPAA_IMAIN_STAT, 0x50);
+				offset | B2056_TX_INTPAA_IMAIN_STAT, 0x30);
 			b43_radio_write(dev,
-				offset | B2056_TX_INTPAA_CASCBIAS, 0x30);
+				offset | B2056_TX_INTPAA_CASCBIAS, cbias);
 		}
 	}
 
-- 
1.8.4.5

