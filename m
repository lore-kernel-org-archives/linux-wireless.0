Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40556 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757148Ab1CAUfl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 15:35:41 -0500
Received: by ewy6 with SMTP id 6so1803019ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2011 12:35:39 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/3] b43: N-PHY: rev3+: implement gain ctl workarounds
Date: Tue,  1 Mar 2011 21:40:41 +0100
Message-Id: <1299012041-7937-3-git-send-email-zajec5@gmail.com>
In-Reply-To: <1299012041-7937-1-git-send-email-zajec5@gmail.com>
References: <1299012041-7937-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |  171 ++++++++++++++++++++++++++++++++++++--
 1 files changed, 162 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index b8e2b2a..60c30e6 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1168,23 +1168,98 @@ static void b43_nphy_adjust_lna_gain_table(struct b43_wldev *dev)
 static void b43_nphy_gain_ctrl_workarounds(struct b43_wldev *dev)
 {
 	struct b43_phy_n *nphy = dev->phy.n;
+	struct ssb_sprom *sprom = &(dev->dev->bus->sprom);
+
+	/* PHY rev 0, 1, 2 */
 	u8 i, j;
 	u8 code;
 	u16 tmp;
+	u8 rfseq_events[3] = { 6, 8, 7 };
+	u8 rfseq_delays[3] = { 10, 30, 1 };
 
-	/* TODO: for PHY >= 3
-	s8 *lna1_gain, *lna2_gain;
-	u8 *gain_db, *gain_bits;
-	u16 *rfseq_init;
+	/* PHY rev >= 3 */
+	bool ghz5;
+	bool ext_lna;
+	u16 rssi_gain;
+	struct nphy_gain_ctl_workaround_entry *e;
 	u8 lpf_gain[6] = { 0x00, 0x06, 0x0C, 0x12, 0x12, 0x12 };
 	u8 lpf_bits[6] = { 0, 1, 2, 3, 3, 3 };
-	*/
-
-	u8 rfseq_events[3] = { 6, 8, 7 };
-	u8 rfseq_delays[3] = { 10, 30, 1 };
 
 	if (dev->phy.rev >= 3) {
-		/* TODO */
+		/* Prepare values */
+		ghz5 = b43_phy_read(dev, B43_NPHY_BANDCTL)
+			& B43_NPHY_BANDCTL_5GHZ;
+		ext_lna = sprom->boardflags_lo & B43_BFL_EXTLNA;
+		e = b43_nphy_get_gain_ctl_workaround_ent(dev, ghz5, ext_lna);
+		if (ghz5 && dev->phy.rev >= 5)
+			rssi_gain = 0x90;
+		else
+			rssi_gain = 0x50;
+
+		b43_phy_set(dev, B43_NPHY_RXCTL, 0x0040);
+
+		/* Set Clip 2 detect */
+		b43_phy_set(dev, B43_NPHY_C1_CGAINI,
+				B43_NPHY_C1_CGAINI_CL2DETECT);
+		b43_phy_set(dev, B43_NPHY_C2_CGAINI,
+				B43_NPHY_C2_CGAINI_CL2DETECT);
+
+		b43_radio_write(dev, B2056_RX0 | B2056_RX_BIASPOLE_LNAG1_IDAC,
+				0x17);
+		b43_radio_write(dev, B2056_RX1 | B2056_RX_BIASPOLE_LNAG1_IDAC,
+				0x17);
+		b43_radio_write(dev, B2056_RX0 | B2056_RX_LNAG2_IDAC, 0xF0);
+		b43_radio_write(dev, B2056_RX1 | B2056_RX_LNAG2_IDAC, 0xF0);
+		b43_radio_write(dev, B2056_RX0 | B2056_RX_RSSI_POLE, 0x00);
+		b43_radio_write(dev, B2056_RX1 | B2056_RX_RSSI_POLE, 0x00);
+		b43_radio_write(dev, B2056_RX0 | B2056_RX_RSSI_GAIN,
+				rssi_gain);
+		b43_radio_write(dev, B2056_RX1 | B2056_RX_RSSI_GAIN,
+				rssi_gain);
+		b43_radio_write(dev, B2056_RX0 | B2056_RX_BIASPOLE_LNAA1_IDAC,
+				0x17);
+		b43_radio_write(dev, B2056_RX1 | B2056_RX_BIASPOLE_LNAA1_IDAC,
+				0x17);
+		b43_radio_write(dev, B2056_RX0 | B2056_RX_LNAA2_IDAC, 0xFF);
+		b43_radio_write(dev, B2056_RX1 | B2056_RX_LNAA2_IDAC, 0xFF);
+
+		b43_ntab_write_bulk(dev, B43_NTAB8(0, 8), 4, e->lna1_gain);
+		b43_ntab_write_bulk(dev, B43_NTAB8(1, 8), 4, e->lna1_gain);
+		b43_ntab_write_bulk(dev, B43_NTAB8(0, 16), 4, e->lna2_gain);
+		b43_ntab_write_bulk(dev, B43_NTAB8(1, 16), 4, e->lna2_gain);
+		b43_ntab_write_bulk(dev, B43_NTAB8(0, 32), 10, e->gain_db);
+		b43_ntab_write_bulk(dev, B43_NTAB8(1, 32), 10, e->gain_db);
+		b43_ntab_write_bulk(dev, B43_NTAB8(2, 32), 10, e->gain_bits);
+		b43_ntab_write_bulk(dev, B43_NTAB8(3, 32), 10, e->gain_bits);
+		b43_ntab_write_bulk(dev, B43_NTAB8(0, 0x40), 6, lpf_gain);
+		b43_ntab_write_bulk(dev, B43_NTAB8(1, 0x40), 6, lpf_gain);
+		b43_ntab_write_bulk(dev, B43_NTAB8(2, 0x40), 6, lpf_bits);
+		b43_ntab_write_bulk(dev, B43_NTAB8(3, 0x40), 6, lpf_bits);
+
+		b43_phy_write(dev, B43_NPHY_C1_INITGAIN, e->init_gain);
+		b43_phy_write(dev, 0x2A7, e->init_gain);
+		b43_ntab_write_bulk(dev, B43_NTAB16(7, 0x106), 2,
+					e->rfseq_init);
+		b43_phy_write(dev, B43_NPHY_C1_INITGAIN, e->init_gain);
+
+		/* TODO: check defines. Do not match variables names */
+		b43_phy_write(dev, B43_NPHY_C1_CLIP1_MEDGAIN, e->cliphi_gain);
+		b43_phy_write(dev, 0x2A9, e->cliphi_gain);
+		b43_phy_write(dev, B43_NPHY_C1_CLIP2_GAIN, e->clipmd_gain);
+		b43_phy_write(dev, 0x2AB, e->clipmd_gain);
+		b43_phy_write(dev, B43_NPHY_C2_CLIP1_HIGAIN, e->cliplo_gain);
+		b43_phy_write(dev, 0x2AD, e->cliplo_gain);
+
+		b43_phy_maskset(dev, 0x27D, 0xFF00, e->crsmin);
+		b43_phy_maskset(dev, 0x280, 0xFF00, e->crsminl);
+		b43_phy_maskset(dev, 0x283, 0xFF00, e->crsminu);
+		b43_phy_write(dev, B43_NPHY_C1_NBCLIPTHRES, e->nbclip);
+		b43_phy_write(dev, B43_NPHY_C2_NBCLIPTHRES, e->nbclip);
+		b43_phy_maskset(dev, B43_NPHY_C1_CLIPWBTHRES,
+				~B43_NPHY_C1_CLIPWBTHRES_CLIP2, e->wlclip);
+		b43_phy_maskset(dev, B43_NPHY_C2_CLIPWBTHRES,
+				~B43_NPHY_C2_CLIPWBTHRES_CLIP2, e->wlclip);
+		b43_phy_write(dev, B43_NPHY_CCK_SHIFTB_REF, 0x809C);
 	} else {
 		/* Set Clip 2 detect */
 		b43_phy_set(dev, B43_NPHY_C1_CGAINI,
@@ -1308,6 +1383,9 @@ static void b43_nphy_workarounds(struct b43_wldev *dev)
 	u8 events2[7] = { 0x0, 0x3, 0x5, 0x4, 0x2, 0x1, 0x8 };
 	u8 delays2[7] = { 0x8, 0x6, 0x2, 0x4, 0x4, 0x6, 0x1 };
 
+	u16 tmp16;
+	u32 tmp32;
+
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ)
 		b43_nphy_classifier(dev, 1, 0);
 	else
@@ -1320,7 +1398,82 @@ static void b43_nphy_workarounds(struct b43_wldev *dev)
 		    B43_NPHY_IQFLIP_ADC1 | B43_NPHY_IQFLIP_ADC2);
 
 	if (dev->phy.rev >= 3) {
+		tmp32 = b43_ntab_read(dev, B43_NTAB32(30, 0));
+		tmp32 &= 0xffffff;
+		b43_ntab_write(dev, B43_NTAB32(30, 0), tmp32);
+
+		b43_phy_write(dev, B43_NPHY_PHASETR_A0, 0x0125);
+		b43_phy_write(dev, B43_NPHY_PHASETR_A1, 0x01B3);
+		b43_phy_write(dev, B43_NPHY_PHASETR_A2, 0x0105);
+		b43_phy_write(dev, B43_NPHY_PHASETR_B0, 0x016E);
+		b43_phy_write(dev, B43_NPHY_PHASETR_B1, 0x00CD);
+		b43_phy_write(dev, B43_NPHY_PHASETR_B2, 0x0020);
+
+		b43_phy_write(dev, B43_NPHY_C2_CLIP1_MEDGAIN, 0x000C);
+		b43_phy_write(dev, 0x2AE, 0x000C);
+
+		/* TODO */
+
+		tmp16 = (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) ?
+			0x2 : 0x9C40;
+		b43_phy_write(dev, B43_NPHY_ENDROP_TLEN, tmp16);
+
+		b43_phy_maskset(dev, 0x294, 0xF0FF, 0x0700);
+
+		b43_ntab_write(dev, B43_NTAB32(16, 3), 0x18D);
+		b43_ntab_write(dev, B43_NTAB32(16, 127), 0x18D);
+
+		b43_nphy_gain_ctrl_workarounds(dev);
+
+		b43_ntab_write(dev, B43_NTAB32(8, 0), 2);
+		b43_ntab_write(dev, B43_NTAB32(8, 16), 2);
+
 		/* TODO */
+
+		b43_radio_write(dev, B2056_RX0 | B2056_RX_MIXA_MAST_BIAS, 0x00);
+		b43_radio_write(dev, B2056_RX1 | B2056_RX_MIXA_MAST_BIAS, 0x00);
+		b43_radio_write(dev, B2056_RX0 | B2056_RX_MIXA_BIAS_MAIN, 0x06);
+		b43_radio_write(dev, B2056_RX1 | B2056_RX_MIXA_BIAS_MAIN, 0x06);
+		b43_radio_write(dev, B2056_RX0 | B2056_RX_MIXA_BIAS_AUX, 0x07);
+		b43_radio_write(dev, B2056_RX1 | B2056_RX_MIXA_BIAS_AUX, 0x07);
+		b43_radio_write(dev, B2056_RX0 | B2056_RX_MIXA_LOB_BIAS, 0x88);
+		b43_radio_write(dev, B2056_RX1 | B2056_RX_MIXA_LOB_BIAS, 0x88);
+		b43_radio_write(dev, B2056_RX0 | B2056_RX_MIXG_CMFB_IDAC, 0x00);
+		b43_radio_write(dev, B2056_RX1 | B2056_RX_MIXG_CMFB_IDAC, 0x00);
+
+		/* N PHY WAR TX Chain Update with hw_phytxchain as argument */
+
+		if ((bus->sprom.boardflags2_lo & B43_BFL2_APLL_WAR &&
+		    b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) ||
+		    (bus->sprom.boardflags2_lo & B43_BFL2_GPLL_WAR &&
+		    b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ))
+			tmp32 = 0x00088888;
+		else
+			tmp32 = 0x88888888;
+		b43_ntab_write(dev, B43_NTAB32(30, 1), tmp32);
+		b43_ntab_write(dev, B43_NTAB32(30, 2), tmp32);
+		b43_ntab_write(dev, B43_NTAB32(30, 3), tmp32);
+
+		if (dev->phy.rev == 4 &&
+		    b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
+			b43_radio_write(dev, B2056_TX0 | B2056_TX_GMBB_IDAC,
+					0x70);
+			b43_radio_write(dev, B2056_TX1 | B2056_TX_GMBB_IDAC,
+					0x70);
+		}
+
+		b43_phy_write(dev, 0x224, 0x039C);
+		b43_phy_write(dev, 0x225, 0x0357);
+		b43_phy_write(dev, 0x226, 0x0317);
+		b43_phy_write(dev, 0x227, 0x02D7);
+		b43_phy_write(dev, 0x228, 0x039C);
+		b43_phy_write(dev, 0x229, 0x0357);
+		b43_phy_write(dev, 0x22A, 0x0317);
+		b43_phy_write(dev, 0x22B, 0x02D7);
+		b43_phy_write(dev, 0x22C, 0x039C);
+		b43_phy_write(dev, 0x22D, 0x0357);
+		b43_phy_write(dev, 0x22E, 0x0317);
+		b43_phy_write(dev, 0x22F, 0x02D7);
 	} else {
 		if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ &&
 		    nphy->band5g_pwrgain) {
-- 
1.7.3.4

