Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:33508 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab0A2XMU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2010 18:12:20 -0500
Received: by fxm20 with SMTP id 20so2434775fxm.21
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jan 2010 15:12:19 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] b43: N-PHY: update general workarounds
Date: Sat, 30 Jan 2010 00:12:19 +0100
Message-Id: <1264806740-691-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |  215 ++++++++++++++++++++------------------
 drivers/net/wireless/b43/phy_n.h |    4 +
 2 files changed, 115 insertions(+), 104 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 8c39fb1..60e730a 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -246,110 +246,6 @@ static void b43_nphy_tables_init(struct b43_wldev *dev)
 		b43_nphy_rev3plus_tables_init(dev);
 }
 
-static void b43_nphy_workarounds(struct b43_wldev *dev)
-{
-	struct b43_phy *phy = &dev->phy;
-	unsigned int i;
-
-	b43_phy_set(dev, B43_NPHY_IQFLIP,
-		    B43_NPHY_IQFLIP_ADC1 | B43_NPHY_IQFLIP_ADC2);
-	if (1 /* FIXME band is 2.4GHz */) {
-		b43_phy_set(dev, B43_NPHY_CLASSCTL,
-			    B43_NPHY_CLASSCTL_CCKEN);
-	} else {
-		b43_phy_mask(dev, B43_NPHY_CLASSCTL,
-			     ~B43_NPHY_CLASSCTL_CCKEN);
-	}
-	b43_radio_set(dev, B2055_C1_TX_RF_SPARE, 0x8);
-	b43_phy_write(dev, B43_NPHY_TXFRAMEDELAY, 8);
-
-	/* Fixup some tables */
-	b43_ntab_write(dev, B43_NTAB16(8, 0x00), 0xA);
-	b43_ntab_write(dev, B43_NTAB16(8, 0x10), 0xA);
-	b43_ntab_write(dev, B43_NTAB16(8, 0x02), 0xCDAA);
-	b43_ntab_write(dev, B43_NTAB16(8, 0x12), 0xCDAA);
-	b43_ntab_write(dev, B43_NTAB16(8, 0x08), 0);
-	b43_ntab_write(dev, B43_NTAB16(8, 0x18), 0);
-	b43_ntab_write(dev, B43_NTAB16(8, 0x07), 0x7AAB);
-	b43_ntab_write(dev, B43_NTAB16(8, 0x17), 0x7AAB);
-	b43_ntab_write(dev, B43_NTAB16(8, 0x06), 0x800);
-	b43_ntab_write(dev, B43_NTAB16(8, 0x16), 0x800);
-
-	b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_LO1, 0x2D8);
-	b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_UP1, 0x301);
-	b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_LO2, 0x2D8);
-	b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_UP2, 0x301);
-
-	//TODO set RF sequence
-
-	/* Set narrowband clip threshold */
-	b43_phy_write(dev, B43_NPHY_C1_NBCLIPTHRES, 66);
-	b43_phy_write(dev, B43_NPHY_C2_NBCLIPTHRES, 66);
-
-	/* Set wideband clip 2 threshold */
-	b43_phy_maskset(dev, B43_NPHY_C1_CLIPWBTHRES,
-			~B43_NPHY_C1_CLIPWBTHRES_CLIP2,
-			21 << B43_NPHY_C1_CLIPWBTHRES_CLIP2_SHIFT);
-	b43_phy_maskset(dev, B43_NPHY_C2_CLIPWBTHRES,
-			~B43_NPHY_C2_CLIPWBTHRES_CLIP2,
-			21 << B43_NPHY_C2_CLIPWBTHRES_CLIP2_SHIFT);
-
-	/* Set Clip 2 detect */
-	b43_phy_set(dev, B43_NPHY_C1_CGAINI,
-		    B43_NPHY_C1_CGAINI_CL2DETECT);
-	b43_phy_set(dev, B43_NPHY_C2_CGAINI,
-		    B43_NPHY_C2_CGAINI_CL2DETECT);
-
-	if (0 /*FIXME*/) {
-		/* Set dwell lengths */
-		b43_phy_write(dev, B43_NPHY_CLIP1_NBDWELL_LEN, 43);
-		b43_phy_write(dev, B43_NPHY_CLIP2_NBDWELL_LEN, 43);
-		b43_phy_write(dev, B43_NPHY_W1CLIP1_DWELL_LEN, 9);
-		b43_phy_write(dev, B43_NPHY_W1CLIP2_DWELL_LEN, 9);
-
-		/* Set gain backoff */
-		b43_phy_maskset(dev, B43_NPHY_C1_CGAINI,
-				~B43_NPHY_C1_CGAINI_GAINBKOFF,
-				1 << B43_NPHY_C1_CGAINI_GAINBKOFF_SHIFT);
-		b43_phy_maskset(dev, B43_NPHY_C2_CGAINI,
-				~B43_NPHY_C2_CGAINI_GAINBKOFF,
-				1 << B43_NPHY_C2_CGAINI_GAINBKOFF_SHIFT);
-
-		/* Set HPVGA2 index */
-		b43_phy_maskset(dev, B43_NPHY_C1_INITGAIN,
-				~B43_NPHY_C1_INITGAIN_HPVGA2,
-				6 << B43_NPHY_C1_INITGAIN_HPVGA2_SHIFT);
-		b43_phy_maskset(dev, B43_NPHY_C2_INITGAIN,
-				~B43_NPHY_C2_INITGAIN_HPVGA2,
-				6 << B43_NPHY_C2_INITGAIN_HPVGA2_SHIFT);
-
-		//FIXME verify that the specs really mean to use autoinc here.
-		for (i = 0; i < 3; i++)
-			b43_ntab_write(dev, B43_NTAB16(7, 0x106) + i, 0x673);
-	}
-
-	/* Set minimum gain value */
-	b43_phy_maskset(dev, B43_NPHY_C1_MINMAX_GAIN,
-			~B43_NPHY_C1_MINGAIN,
-			23 << B43_NPHY_C1_MINGAIN_SHIFT);
-	b43_phy_maskset(dev, B43_NPHY_C2_MINMAX_GAIN,
-			~B43_NPHY_C2_MINGAIN,
-			23 << B43_NPHY_C2_MINGAIN_SHIFT);
-
-	if (phy->rev < 2) {
-		b43_phy_mask(dev, B43_NPHY_SCRAM_SIGCTL,
-			     ~B43_NPHY_SCRAM_SIGCTL_SCM);
-	}
-
-	/* Set phase track alpha and beta */
-	b43_phy_write(dev, B43_NPHY_PHASETR_A0, 0x125);
-	b43_phy_write(dev, B43_NPHY_PHASETR_A1, 0x1B3);
-	b43_phy_write(dev, B43_NPHY_PHASETR_A2, 0x105);
-	b43_phy_write(dev, B43_NPHY_PHASETR_B0, 0x16E);
-	b43_phy_write(dev, B43_NPHY_PHASETR_B1, 0xCD);
-	b43_phy_write(dev, B43_NPHY_PHASETR_B2, 0x20);
-}
-
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/PA%20override */
 static void b43_nphy_pa_override(struct b43_wldev *dev, bool enable)
 {
@@ -816,6 +712,117 @@ static void b43_nphy_stop_playback(struct b43_wldev *dev)
 		b43_nphy_stay_in_carrier_search(dev, 0);
 }
 
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/Workarounds */
+static void b43_nphy_workarounds(struct b43_wldev *dev)
+{
+	struct ssb_bus *bus = dev->dev->bus;
+	struct b43_phy *phy = &dev->phy;
+	struct b43_phy_n *nphy = phy->n;
+
+	u8 events1[7] = { 0x0, 0x1, 0x2, 0x8, 0x4, 0x5, 0x3 };
+	u8 delays1[7] = { 0x8, 0x6, 0x6, 0x2, 0x4, 0x3C, 0x1 };
+
+	u8 events2[7] = { 0x0, 0x3, 0x5, 0x4, 0x2, 0x1, 0x8 };
+	u8 delays2[7] = { 0x8, 0x6, 0x2, 0x4, 0x4, 0x6, 0x1 };
+
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
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
+	if (dev->phy.rev >= 3) {
+		/* TODO */
+	} else {
+		if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ &&
+		    nphy->band5g_pwrgain) {
+			b43_radio_mask(dev, B2055_C1_TX_RF_SPARE, ~0x8);
+			b43_radio_mask(dev, B2055_C2_TX_RF_SPARE, ~0x8);
+		} else {
+			b43_radio_set(dev, B2055_C1_TX_RF_SPARE, 0x8);
+			b43_radio_set(dev, B2055_C2_TX_RF_SPARE, 0x8);
+		}
+
+		/* TODO: convert to b43_ntab_write? */
+		b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x2000);
+		b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x000A);
+		b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x2010);
+		b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x000A);
+		b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x2002);
+		b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0xCDAA);
+		b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x2012);
+		b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0xCDAA);
+
+		if (dev->phy.rev < 2) {
+			b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x2008);
+			b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x0000);
+			b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x2018);
+			b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x0000);
+			b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x2007);
+			b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x7AAB);
+			b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x2017);
+			b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x7AAB);
+			b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x2006);
+			b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x0800);
+			b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x2016);
+			b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x0800);
+		}
+
+		b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_LO1, 0x2D8);
+		b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_UP1, 0x301);
+		b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_LO2, 0x2D8);
+		b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_UP2, 0x301);
+
+		if (bus->sprom.boardflags2_lo & 0x100 &&
+		    bus->boardinfo.type == 0x8B) {
+			delays1[0] = 0x1;
+			delays1[5] = 0x14;
+		}
+		/*TODO:b43_nphy_set_rf_sequence(dev, 0, events1, delays1, 7);*/
+		/*TODO:b43_nphy_set_rf_sequence(dev, 1, events2, delays2, 7);*/
+
+		/*TODO:b43_nphy_gain_crtl_workarounds(dev);*/
+
+		if (dev->phy.rev < 2) {
+			if (b43_phy_read(dev, B43_NPHY_RXCTL) & 0x2)
+				; /*TODO: b43_mhf(dev, 2, 0x0010, 0x0010, 3);*/
+		} else if (dev->phy.rev == 2) {
+			b43_phy_write(dev, B43_NPHY_CRSCHECK2, 0);
+			b43_phy_write(dev, B43_NPHY_CRSCHECK3, 0);
+		}
+
+		if (dev->phy.rev < 2)
+			b43_phy_mask(dev, B43_NPHY_SCRAM_SIGCTL,
+					~B43_NPHY_SCRAM_SIGCTL_SCM);
+
+		/* Set phase track alpha and beta */
+		b43_phy_write(dev, B43_NPHY_PHASETR_A0, 0x125);
+		b43_phy_write(dev, B43_NPHY_PHASETR_A1, 0x1B3);
+		b43_phy_write(dev, B43_NPHY_PHASETR_A2, 0x105);
+		b43_phy_write(dev, B43_NPHY_PHASETR_B0, 0x16E);
+		b43_phy_write(dev, B43_NPHY_PHASETR_B1, 0xCD);
+		b43_phy_write(dev, B43_NPHY_PHASETR_B2, 0x20);
+
+		b43_phy_mask(dev, B43_NPHY_PIL_DW1,
+				(u16)~B43_NPHY_PIL_DW_64QAM);
+		b43_phy_write(dev, B43_NPHY_TXF_20CO_S2B1, 0xB5);
+		b43_phy_write(dev, B43_NPHY_TXF_20CO_S2B2, 0xA4);
+		b43_phy_write(dev, B43_NPHY_TXF_20CO_S2B3, 0x00);
+
+		if (dev->phy.rev == 2)
+			b43_phy_set(dev, B43_NPHY_FINERX2_CGC,
+					B43_NPHY_FINERX2_CGC_DECGC);
+	}
+
+	if (nphy->hang_avoid)
+		b43_nphy_stay_in_carrier_search(dev, 0);
+}
+
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/GenLoadSamples */
 static u16 b43_nphy_gen_load_samples(struct b43_wldev *dev, u32 freq, u16 max,
 					bool test)
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index f5a2766..ae82f0f 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -976,6 +976,10 @@ struct b43_phy_n {
 	s32 preamble_override;
 	u32 bb_mult_save;
 
+	bool gain_boost;
+	bool elna_gain_config;
+	bool band5g_pwrgain;
+
 	u8 mphase_cal_phase_id;
 	u16 mphase_txcal_cmdidx;
 	u16 mphase_txcal_numcmds;
-- 
1.6.4.2

