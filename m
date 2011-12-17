Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44617 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab1LQM4g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Dec 2011 07:56:36 -0500
Received: by mail-ey0-f174.google.com with SMTP id j10so3614415eaa.19
        for <linux-wireless@vger.kernel.org>; Sat, 17 Dec 2011 04:56:35 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 5/8] b43: N-PHY: split gain control workarounds
Date: Sat, 17 Dec 2011 13:57:24 +0100
Message-Id: <1324126647-22425-6-git-send-email-zajec5@gmail.com> (sfid-20111217_135643_108543_6CC11087)
In-Reply-To: <1324126647-22425-1-git-send-email-zajec5@gmail.com>
References: <1324126647-22425-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |  531 +++++++++++++++++++-------------------
 1 files changed, 267 insertions(+), 264 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 0e4a364..620d278 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -388,6 +388,62 @@ static void b43_nphy_stay_in_carrier_search(struct b43_wldev *dev, bool enable)
 	}
 }
 
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/AdjustLnaGainTbl */
+static void b43_nphy_adjust_lna_gain_table(struct b43_wldev *dev)
+{
+	struct b43_phy_n *nphy = dev->phy.n;
+
+	u8 i;
+	s16 tmp;
+	u16 data[4];
+	s16 gain[2];
+	u16 minmax[2];
+	static const u16 lna_gain[4] = { -2, 10, 19, 25 };
+
+	if (nphy->hang_avoid)
+		b43_nphy_stay_in_carrier_search(dev, 1);
+
+	if (nphy->gain_boost) {
+		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+			gain[0] = 6;
+			gain[1] = 6;
+		} else {
+			tmp = 40370 - 315 * dev->phy.channel;
+			gain[0] = ((tmp >> 13) + ((tmp >> 12) & 1));
+			tmp = 23242 - 224 * dev->phy.channel;
+			gain[1] = ((tmp >> 13) + ((tmp >> 12) & 1));
+		}
+	} else {
+		gain[0] = 0;
+		gain[1] = 0;
+	}
+
+	for (i = 0; i < 2; i++) {
+		if (nphy->elna_gain_config) {
+			data[0] = 19 + gain[i];
+			data[1] = 25 + gain[i];
+			data[2] = 25 + gain[i];
+			data[3] = 25 + gain[i];
+		} else {
+			data[0] = lna_gain[0] + gain[i];
+			data[1] = lna_gain[1] + gain[i];
+			data[2] = lna_gain[2] + gain[i];
+			data[3] = lna_gain[3] + gain[i];
+		}
+		b43_ntab_write_bulk(dev, B43_NTAB16(i, 8), 4, data);
+
+		minmax[i] = 23 + gain[i];
+	}
+
+	b43_phy_maskset(dev, B43_NPHY_C1_MINMAX_GAIN, ~B43_NPHY_C1_MINGAIN,
+				minmax[0] << B43_NPHY_C1_MINGAIN_SHIFT);
+	b43_phy_maskset(dev, B43_NPHY_C2_MINMAX_GAIN, ~B43_NPHY_C2_MINGAIN,
+				minmax[1] << B43_NPHY_C2_MINGAIN_SHIFT);
+
+	if (nphy->hang_avoid)
+		b43_nphy_stay_in_carrier_search(dev, 0);
+}
+
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/SetRfSeq */
 static void b43_nphy_set_rf_sequence(struct b43_wldev *dev, u8 cmd,
 					u8 *events, u8 *delays, u8 length)
@@ -1138,6 +1194,215 @@ static void b43_nphy_rssi_select(struct b43_wldev *dev, u8 code, u8 type)
 }
 
 /**************************************************
+ * Workarounds
+ **************************************************/
+
+static void b43_nphy_gain_ctl_workarounds_rev3plus(struct b43_wldev *dev)
+{
+	struct ssb_sprom *sprom = dev->dev->bus_sprom;
+
+	bool ghz5;
+	bool ext_lna;
+	u16 rssi_gain;
+	struct nphy_gain_ctl_workaround_entry *e;
+	u8 lpf_gain[6] = { 0x00, 0x06, 0x0C, 0x12, 0x12, 0x12 };
+	u8 lpf_bits[6] = { 0, 1, 2, 3, 3, 3 };
+
+	/* Prepare values */
+	ghz5 = b43_phy_read(dev, B43_NPHY_BANDCTL)
+		& B43_NPHY_BANDCTL_5GHZ;
+	ext_lna = sprom->boardflags_lo & B43_BFL_EXTLNA;
+	e = b43_nphy_get_gain_ctl_workaround_ent(dev, ghz5, ext_lna);
+	if (ghz5 && dev->phy.rev >= 5)
+		rssi_gain = 0x90;
+	else
+		rssi_gain = 0x50;
+
+	b43_phy_set(dev, B43_NPHY_RXCTL, 0x0040);
+
+	/* Set Clip 2 detect */
+	b43_phy_set(dev, B43_NPHY_C1_CGAINI,
+			B43_NPHY_C1_CGAINI_CL2DETECT);
+	b43_phy_set(dev, B43_NPHY_C2_CGAINI,
+			B43_NPHY_C2_CGAINI_CL2DETECT);
+
+	b43_radio_write(dev, B2056_RX0 | B2056_RX_BIASPOLE_LNAG1_IDAC,
+			0x17);
+	b43_radio_write(dev, B2056_RX1 | B2056_RX_BIASPOLE_LNAG1_IDAC,
+			0x17);
+	b43_radio_write(dev, B2056_RX0 | B2056_RX_LNAG2_IDAC, 0xF0);
+	b43_radio_write(dev, B2056_RX1 | B2056_RX_LNAG2_IDAC, 0xF0);
+	b43_radio_write(dev, B2056_RX0 | B2056_RX_RSSI_POLE, 0x00);
+	b43_radio_write(dev, B2056_RX1 | B2056_RX_RSSI_POLE, 0x00);
+	b43_radio_write(dev, B2056_RX0 | B2056_RX_RSSI_GAIN,
+			rssi_gain);
+	b43_radio_write(dev, B2056_RX1 | B2056_RX_RSSI_GAIN,
+			rssi_gain);
+	b43_radio_write(dev, B2056_RX0 | B2056_RX_BIASPOLE_LNAA1_IDAC,
+			0x17);
+	b43_radio_write(dev, B2056_RX1 | B2056_RX_BIASPOLE_LNAA1_IDAC,
+			0x17);
+	b43_radio_write(dev, B2056_RX0 | B2056_RX_LNAA2_IDAC, 0xFF);
+	b43_radio_write(dev, B2056_RX1 | B2056_RX_LNAA2_IDAC, 0xFF);
+
+	b43_ntab_write_bulk(dev, B43_NTAB8(0, 8), 4, e->lna1_gain);
+	b43_ntab_write_bulk(dev, B43_NTAB8(1, 8), 4, e->lna1_gain);
+	b43_ntab_write_bulk(dev, B43_NTAB8(0, 16), 4, e->lna2_gain);
+	b43_ntab_write_bulk(dev, B43_NTAB8(1, 16), 4, e->lna2_gain);
+	b43_ntab_write_bulk(dev, B43_NTAB8(0, 32), 10, e->gain_db);
+	b43_ntab_write_bulk(dev, B43_NTAB8(1, 32), 10, e->gain_db);
+	b43_ntab_write_bulk(dev, B43_NTAB8(2, 32), 10, e->gain_bits);
+	b43_ntab_write_bulk(dev, B43_NTAB8(3, 32), 10, e->gain_bits);
+	b43_ntab_write_bulk(dev, B43_NTAB8(0, 0x40), 6, lpf_gain);
+	b43_ntab_write_bulk(dev, B43_NTAB8(1, 0x40), 6, lpf_gain);
+	b43_ntab_write_bulk(dev, B43_NTAB8(2, 0x40), 6, lpf_bits);
+	b43_ntab_write_bulk(dev, B43_NTAB8(3, 0x40), 6, lpf_bits);
+
+	b43_phy_write(dev, B43_NPHY_C1_INITGAIN, e->init_gain);
+	b43_phy_write(dev, 0x2A7, e->init_gain);
+	b43_ntab_write_bulk(dev, B43_NTAB16(7, 0x106), 2,
+				e->rfseq_init);
+	b43_phy_write(dev, B43_NPHY_C1_INITGAIN, e->init_gain);
+
+	/* TODO: check defines. Do not match variables names */
+	b43_phy_write(dev, B43_NPHY_C1_CLIP1_MEDGAIN, e->cliphi_gain);
+	b43_phy_write(dev, 0x2A9, e->cliphi_gain);
+	b43_phy_write(dev, B43_NPHY_C1_CLIP2_GAIN, e->clipmd_gain);
+	b43_phy_write(dev, 0x2AB, e->clipmd_gain);
+	b43_phy_write(dev, B43_NPHY_C2_CLIP1_HIGAIN, e->cliplo_gain);
+	b43_phy_write(dev, 0x2AD, e->cliplo_gain);
+
+	b43_phy_maskset(dev, 0x27D, 0xFF00, e->crsmin);
+	b43_phy_maskset(dev, 0x280, 0xFF00, e->crsminl);
+	b43_phy_maskset(dev, 0x283, 0xFF00, e->crsminu);
+	b43_phy_write(dev, B43_NPHY_C1_NBCLIPTHRES, e->nbclip);
+	b43_phy_write(dev, B43_NPHY_C2_NBCLIPTHRES, e->nbclip);
+	b43_phy_maskset(dev, B43_NPHY_C1_CLIPWBTHRES,
+			~B43_NPHY_C1_CLIPWBTHRES_CLIP2, e->wlclip);
+	b43_phy_maskset(dev, B43_NPHY_C2_CLIPWBTHRES,
+			~B43_NPHY_C2_CLIPWBTHRES_CLIP2, e->wlclip);
+	b43_phy_write(dev, B43_NPHY_CCK_SHIFTB_REF, 0x809C);
+}
+
+static void b43_nphy_gain_ctl_workarounds_rev1_2(struct b43_wldev *dev)
+{
+	struct b43_phy_n *nphy = dev->phy.n;
+
+	u8 i, j;
+	u8 code;
+	u16 tmp;
+	u8 rfseq_events[3] = { 6, 8, 7 };
+	u8 rfseq_delays[3] = { 10, 30, 1 };
+
+	/* Set Clip 2 detect */
+	b43_phy_set(dev, B43_NPHY_C1_CGAINI, B43_NPHY_C1_CGAINI_CL2DETECT);
+	b43_phy_set(dev, B43_NPHY_C2_CGAINI, B43_NPHY_C2_CGAINI_CL2DETECT);
+
+	/* Set narrowband clip threshold */
+	b43_phy_write(dev, B43_NPHY_C1_NBCLIPTHRES, 0x84);
+	b43_phy_write(dev, B43_NPHY_C2_NBCLIPTHRES, 0x84);
+
+	if (!dev->phy.is_40mhz) {
+		/* Set dwell lengths */
+		b43_phy_write(dev, B43_NPHY_CLIP1_NBDWELL_LEN, 0x002B);
+		b43_phy_write(dev, B43_NPHY_CLIP2_NBDWELL_LEN, 0x002B);
+		b43_phy_write(dev, B43_NPHY_W1CLIP1_DWELL_LEN, 0x0009);
+		b43_phy_write(dev, B43_NPHY_W1CLIP2_DWELL_LEN, 0x0009);
+	}
+
+	/* Set wideband clip 2 threshold */
+	b43_phy_maskset(dev, B43_NPHY_C1_CLIPWBTHRES,
+			~B43_NPHY_C1_CLIPWBTHRES_CLIP2, 21);
+	b43_phy_maskset(dev, B43_NPHY_C2_CLIPWBTHRES,
+			~B43_NPHY_C2_CLIPWBTHRES_CLIP2, 21);
+
+	if (!dev->phy.is_40mhz) {
+		b43_phy_maskset(dev, B43_NPHY_C1_CGAINI,
+			~B43_NPHY_C1_CGAINI_GAINBKOFF, 0x1);
+		b43_phy_maskset(dev, B43_NPHY_C2_CGAINI,
+			~B43_NPHY_C2_CGAINI_GAINBKOFF, 0x1);
+		b43_phy_maskset(dev, B43_NPHY_C1_CCK_CGAINI,
+			~B43_NPHY_C1_CCK_CGAINI_GAINBKOFF, 0x1);
+		b43_phy_maskset(dev, B43_NPHY_C2_CCK_CGAINI,
+			~B43_NPHY_C2_CCK_CGAINI_GAINBKOFF, 0x1);
+	}
+
+	b43_phy_write(dev, B43_NPHY_CCK_SHIFTB_REF, 0x809C);
+
+	if (nphy->gain_boost) {
+		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ &&
+			dev->phy.is_40mhz)
+			code = 4;
+		else
+			code = 5;
+	} else {
+		code = dev->phy.is_40mhz ? 6 : 7;
+	}
+
+	/* Set HPVGA2 index */
+	b43_phy_maskset(dev, B43_NPHY_C1_INITGAIN, ~B43_NPHY_C1_INITGAIN_HPVGA2,
+			code << B43_NPHY_C1_INITGAIN_HPVGA2_SHIFT);
+	b43_phy_maskset(dev, B43_NPHY_C2_INITGAIN, ~B43_NPHY_C2_INITGAIN_HPVGA2,
+			code << B43_NPHY_C2_INITGAIN_HPVGA2_SHIFT);
+
+	b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x1D06);
+	/* specs say about 2 loops, but wl does 4 */
+	for (i = 0; i < 4; i++)
+		b43_phy_write(dev, B43_NPHY_TABLE_DATALO, (code << 8 | 0x7C));
+
+	b43_nphy_adjust_lna_gain_table(dev);
+
+	if (nphy->elna_gain_config) {
+		b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x0808);
+		b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x0);
+		b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x1);
+		b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x1);
+		b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x1);
+
+		b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x0C08);
+		b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x0);
+		b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x1);
+		b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x1);
+		b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x1);
+
+		b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x1D06);
+		/* specs say about 2 loops, but wl does 4 */
+		for (i = 0; i < 4; i++)
+			b43_phy_write(dev, B43_NPHY_TABLE_DATALO,
+						(code << 8 | 0x74));
+	}
+
+	if (dev->phy.rev == 2) {
+		for (i = 0; i < 4; i++) {
+			b43_phy_write(dev, B43_NPHY_TABLE_ADDR,
+					(0x0400 * i) + 0x0020);
+			for (j = 0; j < 21; j++) {
+				tmp = j * (i < 2 ? 3 : 1);
+				b43_phy_write(dev,
+					B43_NPHY_TABLE_DATALO, tmp);
+			}
+		}
+	}
+
+	b43_nphy_set_rf_sequence(dev, 5, rfseq_events, rfseq_delays, 3);
+	b43_phy_maskset(dev, B43_NPHY_OVER_DGAIN1,
+		~B43_NPHY_OVER_DGAIN_CCKDGECV & 0xFFFF,
+		0x5A << B43_NPHY_OVER_DGAIN_CCKDGECV_SHIFT);
+
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+		b43_phy_maskset(dev, B43_PHY_N(0xC5D), 0xFF80, 4);
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/WorkaroundsGainCtrl */
+static void b43_nphy_gain_ctl_workarounds(struct b43_wldev *dev)
+{
+	if (dev->phy.rev >= 3)
+		b43_nphy_gain_ctl_workarounds_rev3plus(dev);
+	else
+		b43_nphy_gain_ctl_workarounds_rev1_2(dev);
+}
+
+/**************************************************
  * Others
  **************************************************/
 
@@ -1949,268 +2214,6 @@ static void b43_nphy_spur_workaround(struct b43_wldev *dev)
 		b43_nphy_stay_in_carrier_search(dev, 0);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/AdjustLnaGainTbl */
-static void b43_nphy_adjust_lna_gain_table(struct b43_wldev *dev)
-{
-	struct b43_phy_n *nphy = dev->phy.n;
-
-	u8 i;
-	s16 tmp;
-	u16 data[4];
-	s16 gain[2];
-	u16 minmax[2];
-	static const u16 lna_gain[4] = { -2, 10, 19, 25 };
-
-	if (nphy->hang_avoid)
-		b43_nphy_stay_in_carrier_search(dev, 1);
-
-	if (nphy->gain_boost) {
-		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
-			gain[0] = 6;
-			gain[1] = 6;
-		} else {
-			tmp = 40370 - 315 * dev->phy.channel;
-			gain[0] = ((tmp >> 13) + ((tmp >> 12) & 1));
-			tmp = 23242 - 224 * dev->phy.channel;
-			gain[1] = ((tmp >> 13) + ((tmp >> 12) & 1));
-		}
-	} else {
-		gain[0] = 0;
-		gain[1] = 0;
-	}
-
-	for (i = 0; i < 2; i++) {
-		if (nphy->elna_gain_config) {
-			data[0] = 19 + gain[i];
-			data[1] = 25 + gain[i];
-			data[2] = 25 + gain[i];
-			data[3] = 25 + gain[i];
-		} else {
-			data[0] = lna_gain[0] + gain[i];
-			data[1] = lna_gain[1] + gain[i];
-			data[2] = lna_gain[2] + gain[i];
-			data[3] = lna_gain[3] + gain[i];
-		}
-		b43_ntab_write_bulk(dev, B43_NTAB16(i, 8), 4, data);
-
-		minmax[i] = 23 + gain[i];
-	}
-
-	b43_phy_maskset(dev, B43_NPHY_C1_MINMAX_GAIN, ~B43_NPHY_C1_MINGAIN,
-				minmax[0] << B43_NPHY_C1_MINGAIN_SHIFT);
-	b43_phy_maskset(dev, B43_NPHY_C2_MINMAX_GAIN, ~B43_NPHY_C2_MINGAIN,
-				minmax[1] << B43_NPHY_C2_MINGAIN_SHIFT);
-
-	if (nphy->hang_avoid)
-		b43_nphy_stay_in_carrier_search(dev, 0);
-}
-
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/WorkaroundsGainCtrl */
-static void b43_nphy_gain_ctrl_workarounds(struct b43_wldev *dev)
-{
-	struct b43_phy_n *nphy = dev->phy.n;
-	struct ssb_sprom *sprom = dev->dev->bus_sprom;
-
-	/* PHY rev 0, 1, 2 */
-	u8 i, j;
-	u8 code;
-	u16 tmp;
-	u8 rfseq_events[3] = { 6, 8, 7 };
-	u8 rfseq_delays[3] = { 10, 30, 1 };
-
-	/* PHY rev >= 3 */
-	bool ghz5;
-	bool ext_lna;
-	u16 rssi_gain;
-	struct nphy_gain_ctl_workaround_entry *e;
-	u8 lpf_gain[6] = { 0x00, 0x06, 0x0C, 0x12, 0x12, 0x12 };
-	u8 lpf_bits[6] = { 0, 1, 2, 3, 3, 3 };
-
-	if (dev->phy.rev >= 3) {
-		/* Prepare values */
-		ghz5 = b43_phy_read(dev, B43_NPHY_BANDCTL)
-			& B43_NPHY_BANDCTL_5GHZ;
-		ext_lna = sprom->boardflags_lo & B43_BFL_EXTLNA;
-		e = b43_nphy_get_gain_ctl_workaround_ent(dev, ghz5, ext_lna);
-		if (ghz5 && dev->phy.rev >= 5)
-			rssi_gain = 0x90;
-		else
-			rssi_gain = 0x50;
-
-		b43_phy_set(dev, B43_NPHY_RXCTL, 0x0040);
-
-		/* Set Clip 2 detect */
-		b43_phy_set(dev, B43_NPHY_C1_CGAINI,
-				B43_NPHY_C1_CGAINI_CL2DETECT);
-		b43_phy_set(dev, B43_NPHY_C2_CGAINI,
-				B43_NPHY_C2_CGAINI_CL2DETECT);
-
-		b43_radio_write(dev, B2056_RX0 | B2056_RX_BIASPOLE_LNAG1_IDAC,
-				0x17);
-		b43_radio_write(dev, B2056_RX1 | B2056_RX_BIASPOLE_LNAG1_IDAC,
-				0x17);
-		b43_radio_write(dev, B2056_RX0 | B2056_RX_LNAG2_IDAC, 0xF0);
-		b43_radio_write(dev, B2056_RX1 | B2056_RX_LNAG2_IDAC, 0xF0);
-		b43_radio_write(dev, B2056_RX0 | B2056_RX_RSSI_POLE, 0x00);
-		b43_radio_write(dev, B2056_RX1 | B2056_RX_RSSI_POLE, 0x00);
-		b43_radio_write(dev, B2056_RX0 | B2056_RX_RSSI_GAIN,
-				rssi_gain);
-		b43_radio_write(dev, B2056_RX1 | B2056_RX_RSSI_GAIN,
-				rssi_gain);
-		b43_radio_write(dev, B2056_RX0 | B2056_RX_BIASPOLE_LNAA1_IDAC,
-				0x17);
-		b43_radio_write(dev, B2056_RX1 | B2056_RX_BIASPOLE_LNAA1_IDAC,
-				0x17);
-		b43_radio_write(dev, B2056_RX0 | B2056_RX_LNAA2_IDAC, 0xFF);
-		b43_radio_write(dev, B2056_RX1 | B2056_RX_LNAA2_IDAC, 0xFF);
-
-		b43_ntab_write_bulk(dev, B43_NTAB8(0, 8), 4, e->lna1_gain);
-		b43_ntab_write_bulk(dev, B43_NTAB8(1, 8), 4, e->lna1_gain);
-		b43_ntab_write_bulk(dev, B43_NTAB8(0, 16), 4, e->lna2_gain);
-		b43_ntab_write_bulk(dev, B43_NTAB8(1, 16), 4, e->lna2_gain);
-		b43_ntab_write_bulk(dev, B43_NTAB8(0, 32), 10, e->gain_db);
-		b43_ntab_write_bulk(dev, B43_NTAB8(1, 32), 10, e->gain_db);
-		b43_ntab_write_bulk(dev, B43_NTAB8(2, 32), 10, e->gain_bits);
-		b43_ntab_write_bulk(dev, B43_NTAB8(3, 32), 10, e->gain_bits);
-		b43_ntab_write_bulk(dev, B43_NTAB8(0, 0x40), 6, lpf_gain);
-		b43_ntab_write_bulk(dev, B43_NTAB8(1, 0x40), 6, lpf_gain);
-		b43_ntab_write_bulk(dev, B43_NTAB8(2, 0x40), 6, lpf_bits);
-		b43_ntab_write_bulk(dev, B43_NTAB8(3, 0x40), 6, lpf_bits);
-
-		b43_phy_write(dev, B43_NPHY_C1_INITGAIN, e->init_gain);
-		b43_phy_write(dev, 0x2A7, e->init_gain);
-		b43_ntab_write_bulk(dev, B43_NTAB16(7, 0x106), 2,
-					e->rfseq_init);
-		b43_phy_write(dev, B43_NPHY_C1_INITGAIN, e->init_gain);
-
-		/* TODO: check defines. Do not match variables names */
-		b43_phy_write(dev, B43_NPHY_C1_CLIP1_MEDGAIN, e->cliphi_gain);
-		b43_phy_write(dev, 0x2A9, e->cliphi_gain);
-		b43_phy_write(dev, B43_NPHY_C1_CLIP2_GAIN, e->clipmd_gain);
-		b43_phy_write(dev, 0x2AB, e->clipmd_gain);
-		b43_phy_write(dev, B43_NPHY_C2_CLIP1_HIGAIN, e->cliplo_gain);
-		b43_phy_write(dev, 0x2AD, e->cliplo_gain);
-
-		b43_phy_maskset(dev, 0x27D, 0xFF00, e->crsmin);
-		b43_phy_maskset(dev, 0x280, 0xFF00, e->crsminl);
-		b43_phy_maskset(dev, 0x283, 0xFF00, e->crsminu);
-		b43_phy_write(dev, B43_NPHY_C1_NBCLIPTHRES, e->nbclip);
-		b43_phy_write(dev, B43_NPHY_C2_NBCLIPTHRES, e->nbclip);
-		b43_phy_maskset(dev, B43_NPHY_C1_CLIPWBTHRES,
-				~B43_NPHY_C1_CLIPWBTHRES_CLIP2, e->wlclip);
-		b43_phy_maskset(dev, B43_NPHY_C2_CLIPWBTHRES,
-				~B43_NPHY_C2_CLIPWBTHRES_CLIP2, e->wlclip);
-		b43_phy_write(dev, B43_NPHY_CCK_SHIFTB_REF, 0x809C);
-	} else {
-		/* Set Clip 2 detect */
-		b43_phy_set(dev, B43_NPHY_C1_CGAINI,
-				B43_NPHY_C1_CGAINI_CL2DETECT);
-		b43_phy_set(dev, B43_NPHY_C2_CGAINI,
-				B43_NPHY_C2_CGAINI_CL2DETECT);
-
-		/* Set narrowband clip threshold */
-		b43_phy_write(dev, B43_NPHY_C1_NBCLIPTHRES, 0x84);
-		b43_phy_write(dev, B43_NPHY_C2_NBCLIPTHRES, 0x84);
-
-		if (!dev->phy.is_40mhz) {
-			/* Set dwell lengths */
-			b43_phy_write(dev, B43_NPHY_CLIP1_NBDWELL_LEN, 0x002B);
-			b43_phy_write(dev, B43_NPHY_CLIP2_NBDWELL_LEN, 0x002B);
-			b43_phy_write(dev, B43_NPHY_W1CLIP1_DWELL_LEN, 0x0009);
-			b43_phy_write(dev, B43_NPHY_W1CLIP2_DWELL_LEN, 0x0009);
-		}
-
-		/* Set wideband clip 2 threshold */
-		b43_phy_maskset(dev, B43_NPHY_C1_CLIPWBTHRES,
-				~B43_NPHY_C1_CLIPWBTHRES_CLIP2,
-				21);
-		b43_phy_maskset(dev, B43_NPHY_C2_CLIPWBTHRES,
-				~B43_NPHY_C2_CLIPWBTHRES_CLIP2,
-				21);
-
-		if (!dev->phy.is_40mhz) {
-			b43_phy_maskset(dev, B43_NPHY_C1_CGAINI,
-				~B43_NPHY_C1_CGAINI_GAINBKOFF, 0x1);
-			b43_phy_maskset(dev, B43_NPHY_C2_CGAINI,
-				~B43_NPHY_C2_CGAINI_GAINBKOFF, 0x1);
-			b43_phy_maskset(dev, B43_NPHY_C1_CCK_CGAINI,
-				~B43_NPHY_C1_CCK_CGAINI_GAINBKOFF, 0x1);
-			b43_phy_maskset(dev, B43_NPHY_C2_CCK_CGAINI,
-				~B43_NPHY_C2_CCK_CGAINI_GAINBKOFF, 0x1);
-		}
-
-		b43_phy_write(dev, B43_NPHY_CCK_SHIFTB_REF, 0x809C);
-
-		if (nphy->gain_boost) {
-			if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ &&
-			    dev->phy.is_40mhz)
-				code = 4;
-			else
-				code = 5;
-		} else {
-			code = dev->phy.is_40mhz ? 6 : 7;
-		}
-
-		/* Set HPVGA2 index */
-		b43_phy_maskset(dev, B43_NPHY_C1_INITGAIN,
-				~B43_NPHY_C1_INITGAIN_HPVGA2,
-				code << B43_NPHY_C1_INITGAIN_HPVGA2_SHIFT);
-		b43_phy_maskset(dev, B43_NPHY_C2_INITGAIN,
-				~B43_NPHY_C2_INITGAIN_HPVGA2,
-				code << B43_NPHY_C2_INITGAIN_HPVGA2_SHIFT);
-
-		b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x1D06);
-		/* specs say about 2 loops, but wl does 4 */
-		for (i = 0; i < 4; i++)
-			b43_phy_write(dev, B43_NPHY_TABLE_DATALO,
-							(code << 8 | 0x7C));
-
-		b43_nphy_adjust_lna_gain_table(dev);
-
-		if (nphy->elna_gain_config) {
-			b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x0808);
-			b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x0);
-			b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x1);
-			b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x1);
-			b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x1);
-
-			b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x0C08);
-			b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x0);
-			b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x1);
-			b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x1);
-			b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x1);
-
-			b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x1D06);
-			/* specs say about 2 loops, but wl does 4 */
-			for (i = 0; i < 4; i++)
-				b43_phy_write(dev, B43_NPHY_TABLE_DATALO,
-							(code << 8 | 0x74));
-		}
-
-		if (dev->phy.rev == 2) {
-			for (i = 0; i < 4; i++) {
-				b43_phy_write(dev, B43_NPHY_TABLE_ADDR,
-						(0x0400 * i) + 0x0020);
-				for (j = 0; j < 21; j++) {
-					tmp = j * (i < 2 ? 3 : 1);
-					b43_phy_write(dev,
-						B43_NPHY_TABLE_DATALO, tmp);
-				}
-			}
-		}
-
-		b43_nphy_set_rf_sequence(dev, 5,
-				rfseq_events, rfseq_delays, 3);
-		b43_phy_maskset(dev, B43_NPHY_OVER_DGAIN1,
-			~B43_NPHY_OVER_DGAIN_CCKDGECV & 0xFFFF,
-			0x5A << B43_NPHY_OVER_DGAIN_CCKDGECV_SHIFT);
-
-		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
-			b43_phy_maskset(dev, B43_PHY_N(0xC5D),
-					0xFF80, 4);
-	}
-}
-
 static void b43_nphy_workarounds_rev3plus(struct b43_wldev *dev)
 {
 	struct b43_phy_n *nphy = dev->phy.n;
@@ -2274,7 +2277,7 @@ static void b43_nphy_workarounds_rev3plus(struct b43_wldev *dev)
 	b43_ntab_write(dev, B43_NTAB32(16, 3), 0x18D);
 	b43_ntab_write(dev, B43_NTAB32(16, 127), 0x18D);
 
-	b43_nphy_gain_ctrl_workarounds(dev);
+	b43_nphy_gain_ctl_workarounds(dev);
 
 	b43_ntab_write(dev, B43_NTAB16(8, 0), 2);
 	b43_ntab_write(dev, B43_NTAB16(8, 16), 2);
@@ -2377,7 +2380,7 @@ static void b43_nphy_workarounds_rev1_2(struct b43_wldev *dev)
 	b43_nphy_set_rf_sequence(dev, 0, events1, delays1, 7);
 	b43_nphy_set_rf_sequence(dev, 1, events2, delays2, 7);
 
-	b43_nphy_gain_ctrl_workarounds(dev);
+	b43_nphy_gain_ctl_workarounds(dev);
 
 	if (dev->phy.rev < 2) {
 		if (b43_phy_read(dev, B43_NPHY_RXCTL) & 0x2)
-- 
1.7.7

