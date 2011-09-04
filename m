Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39760 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751Ab1IDVVx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Sep 2011 17:21:53 -0400
Received: by mail-bw0-f46.google.com with SMTP id 11so4036793bke.19
        for <linux-wireless@vger.kernel.org>; Sun, 04 Sep 2011 14:21:52 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 4/4] b43: N-PHY: implement few random missing ops
Date: Sun,  4 Sep 2011 23:23:53 +0200
Message-Id: <1315171433-26625-4-git-send-email-zajec5@gmail.com> (sfid-20110904_232155_136206_60886FE1)
In-Reply-To: <1315171433-26625-2-git-send-email-zajec5@gmail.com>
References: <1315171433-26625-2-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |  111 ++++++++++++++++++++++++++++++++------
 drivers/net/wireless/b43/phy_n.h |    2 +
 2 files changed, 96 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 8647933..b17d9b6 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -78,6 +78,7 @@ enum b43_nphy_rssi_type {
 	B43_NPHY_RSSI_TBD,
 };
 
+/* TODO: reorder functions */
 static void b43_nphy_stay_in_carrier_search(struct b43_wldev *dev,
 						bool enable);
 static void b43_nphy_set_rf_sequence(struct b43_wldev *dev, u8 cmd,
@@ -88,6 +89,7 @@ static void b43_nphy_rf_control_override(struct b43_wldev *dev, u16 field,
 						u16 value, u8 core, bool off);
 static void b43_nphy_rf_control_intc_override(struct b43_wldev *dev, u8 field,
 						u16 value, u8 core);
+static const u32 *b43_nphy_get_ipa_gain_table(struct b43_wldev *dev);
 
 static inline bool b43_nphy_ipa(struct b43_wldev *dev)
 {
@@ -453,8 +455,14 @@ static void b43_nphy_tx_power_fix(struct b43_wldev *dev)
 			tmp = (tmp & 0xFF00) | bbmult;
 		b43_ntab_write(dev, B43_NTAB16(0xF, 0x57), tmp);
 
-		if (0)
-			; /* TODO */
+		if (b43_nphy_ipa(dev)) {
+			u32 tmp32;
+			u16 reg = (i == 0) ?
+				B43_NPHY_PAPD_EN0 : B43_NPHY_PAPD_EN1;
+			tmp32 = b43_ntab_read(dev, B43_NTAB32(26 + i, txpi[i]));
+			b43_phy_maskset(dev, reg, 0xE00F, (u32) tmp32 << 4);
+			b43_phy_set(dev, reg, 0x4);
+		}
 	}
 
 	b43_phy_mask(dev, B43_NPHY_BPHY_CTL2, ~B43_NPHY_BPHY_CTL2_LUT);
@@ -463,6 +471,57 @@ static void b43_nphy_tx_power_fix(struct b43_wldev *dev)
 		b43_nphy_stay_in_carrier_search(dev, 0);
 }
 
+static void b43_nphy_tx_gain_table_upload(struct b43_wldev *dev)
+{
+	struct b43_phy *phy = &dev->phy;
+
+	const u32 *table = NULL;
+#if 0
+	TODO: b43_ntab_papd_pga_gain_delta_ipa_2*
+	u32 rfpwr_offset;
+	u8 pga_gain;
+	int i;
+#endif
+
+	if (phy->rev >= 3) {
+		if (b43_nphy_ipa(dev)) {
+			table = b43_nphy_get_ipa_gain_table(dev);
+		} else {
+			if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
+				if (phy->rev == 3)
+					table = b43_ntab_tx_gain_rev3_5ghz;
+				if (phy->rev == 4)
+					table = b43_ntab_tx_gain_rev4_5ghz;
+				else
+					table = b43_ntab_tx_gain_rev5plus_5ghz;
+			} else {
+				table = b43_ntab_tx_gain_rev3plus_2ghz;
+			}
+		}
+	} else {
+		table = b43_ntab_tx_gain_rev0_1_2;
+	}
+	b43_ntab_write_bulk(dev, B43_NTAB32(26, 192), 128, table);
+	b43_ntab_write_bulk(dev, B43_NTAB32(27, 192), 128, table);
+
+	if (phy->rev >= 3) {
+#if 0
+		nphy->gmval = (table[0] >> 16) & 0x7000;
+
+		for (i = 0; i < 128; i++) {
+			pga_gain = (table[i] >> 24) & 0xF;
+			if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+				rfpwr_offset = b43_ntab_papd_pga_gain_delta_ipa_2g[pga_gain];
+			else
+				rfpwr_offset = b43_ntab_papd_pga_gain_delta_ipa_5g[pga_gain];
+			b43_ntab_write(dev, B43_NTAB32(26, 576 + i),
+				       rfpwr_offset);
+			b43_ntab_write(dev, B43_NTAB32(27, 576 + i),
+				       rfpwr_offset);
+		}
+#endif
+	}
+}
 
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/Radio/2055Setup */
 static void b43_radio_2055_setup(struct b43_wldev *dev,
@@ -1430,8 +1489,19 @@ static void b43_nphy_gain_ctrl_workarounds(struct b43_wldev *dev)
 
 static void b43_nphy_workarounds_rev3plus(struct b43_wldev *dev)
 {
+	struct b43_phy_n *nphy = dev->phy.n;
 	struct ssb_sprom *sprom = dev->dev->bus_sprom;
 
+	/* TX to RX */
+	u8 tx2rx_events[9] = { 0x4, 0x3, 0x6, 0x5, 0x2, 0x1, 0x8, 0x1F };
+	u8 tx2rx_delays[9] = { 8, 4, 2, 2, 4, 4, 6, 1 };
+	/* RX to TX */
+	u8 rx2tx_events_ipa[9] = { 0x0, 0x1, 0x2, 0x8, 0x5, 0x6, 0xF, 0x3,
+					0x1F };
+	u8 rx2tx_delays_ipa[9] = { 8, 6, 6, 4, 4, 16, 43, 1, 1 };
+	u8 rx2tx_events[9] = { 0x0, 0x1, 0x2, 0x8, 0x5, 0x6, 0x3, 0x4, 0x1F };
+	u8 rx2tx_delays[9] = { 8, 6, 6, 4, 4, 18, 42, 1, 1 };
+
 	u16 tmp16;
 	u32 tmp32;
 
@@ -1449,7 +1519,22 @@ static void b43_nphy_workarounds_rev3plus(struct b43_wldev *dev)
 	b43_phy_write(dev, B43_NPHY_C2_CLIP1_MEDGAIN, 0x000C);
 	b43_phy_write(dev, 0x2AE, 0x000C);
 
-	/* TODO */
+	/* TX to RX */
+	b43_nphy_set_rf_sequence(dev, 1, tx2rx_events, tx2rx_delays, 9);
+
+	/* RX to TX */
+	if (b43_nphy_ipa(dev))
+		b43_nphy_set_rf_sequence(dev, 1, rx2tx_events_ipa,
+					 rx2tx_delays_ipa, 9);
+	if (nphy->hw_phyrxchain != 3 &&
+	    nphy->hw_phyrxchain != nphy->hw_phytxchain) {
+		if (b43_nphy_ipa(dev)) {
+			rx2tx_delays[5] = 59;
+			rx2tx_delays[6] = 1;
+			rx2tx_events[7] = 0x1F;
+		}
+		b43_nphy_set_rf_sequence(dev, 1, rx2tx_events, rx2tx_delays, 9);
+	}
 
 	tmp16 = (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) ?
 		0x2 : 0x9C40;
@@ -1553,8 +1638,8 @@ static void b43_nphy_workarounds_rev1_2(struct b43_wldev *dev)
 	b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_LO2, 0x2D8);
 	b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_UP2, 0x301);
 
-	if (sprom->boardflags2_lo & 0x100 &&
-		dev->dev->board_type == 0x8B) {
+	if (sprom->boardflags2_lo & B43_BFL2_SKWRKFEM_BRD &&
+	    dev->dev->board_type == 0x8B) {
 		delays1[0] = 0x1;
 		delays1[5] = 0x14;
 	}
@@ -2649,8 +2734,8 @@ static const u32 *b43_nphy_get_ipa_gain_table(struct b43_wldev *dev)
 {
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
 		if (dev->phy.rev >= 6) {
-			/* TODO If the chip is 47162
-				return txpwrctrl_tx_gain_ipa_rev5 */
+			if (dev->dev->chip_id == 47162)
+				return txpwrctrl_tx_gain_ipa_rev5;
 			return txpwrctrl_tx_gain_ipa_rev6;
 		} else if (dev->phy.rev >= 5) {
 			return txpwrctrl_tx_gain_ipa_rev5;
@@ -3717,7 +3802,7 @@ int b43_phy_initn(struct b43_wldev *dev)
 	b43_phy_write(dev, B43_NPHY_AFESEQ_TX2RX_PUD_20M, 0x20);
 	b43_phy_write(dev, B43_NPHY_AFESEQ_TX2RX_PUD_40M, 0x20);
 
-	if (sprom->boardflags2_lo & 0x100 ||
+	if (sprom->boardflags2_lo & B43_BFL2_SKWRKFEM_BRD ||
 	    (dev->dev->board_vendor == PCI_VENDOR_ID_APPLE &&
 	     dev->dev->board_type == 0x8B))
 		b43_phy_write(dev, B43_NPHY_TXREALFD, 0xA0);
@@ -3774,15 +3859,7 @@ int b43_phy_initn(struct b43_wldev *dev)
 	b43_nphy_tx_power_fix(dev);
 	/* TODO N PHY TX Power Control Idle TSSI */
 	/* TODO N PHY TX Power Control Setup */
-
-	if (phy->rev >= 3) {
-		/* TODO */
-	} else {
-		b43_ntab_write_bulk(dev, B43_NTAB32(26, 192), 128,
-					b43_ntab_tx_gain_rev0_1_2);
-		b43_ntab_write_bulk(dev, B43_NTAB32(27, 192), 128,
-					b43_ntab_tx_gain_rev0_1_2);
-	}
+	b43_nphy_tx_gain_table_upload(dev);
 
 	if (nphy->phyrxchain != 3)
 		b43_nphy_set_rx_core_state(dev, nphy->phyrxchain);
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index cd84989..fbf5202 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -764,6 +764,8 @@ struct b43_phy_n {
 	u8 cal_orig_pwr_idx[2];
 	u8 measure_hold;
 	u8 phyrxchain;
+	u8 hw_phyrxchain;
+	u8 hw_phytxchain;
 	u8 perical;
 	u32 deaf_count;
 	u32 rxcalparams;
-- 
1.7.3.4

