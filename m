Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:33508 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab0A2XMa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2010 18:12:30 -0500
Received: by mail-fx0-f220.google.com with SMTP id 20so2434775fxm.21
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jan 2010 15:12:29 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] b43: N-PHY: add workarounds for gain control
Date: Sat, 30 Jan 2010 00:12:20 +0100
Message-Id: <1264806740-691-2-git-send-email-zajec5@gmail.com>
In-Reply-To: <1264806740-691-1-git-send-email-zajec5@gmail.com>
References: <1264806740-691-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |  130 +++++++++++++++++++++++++++++++++++++-
 1 files changed, 129 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 60e730a..d738d76 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -712,6 +712,134 @@ static void b43_nphy_stop_playback(struct b43_wldev *dev)
 		b43_nphy_stay_in_carrier_search(dev, 0);
 }
 
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/WorkaroundsGainCtrl */
+static void b43_nphy_gain_crtl_workarounds(struct b43_wldev *dev)
+{
+	struct b43_phy_n *nphy = dev->phy.n;
+	u8 i, j;
+	u8 code;
+
+	/* TODO: for PHY >= 3
+	s8 *lna1_gain, *lna2_gain;
+	u8 *gain_db, *gain_bits;
+	u16 *rfseq_init;
+	u8 lpf_gain[6] = { 0x00, 0x06, 0x0C, 0x12, 0x12, 0x12 };
+	u8 lpf_bits[6] = { 0, 1, 2, 3, 3, 3 };
+	*/
+
+	u8 rfseq_events[3] = { 6, 8, 7 };
+	u8 rfseq_delays[3] = { 10, 30, 1 };
+
+	if (dev->phy.rev >= 3) {
+		/* TODO */
+	} else {
+		/* Set Clip 2 detect */
+		b43_phy_set(dev, B43_NPHY_C1_CGAINI,
+				B43_NPHY_C1_CGAINI_CL2DETECT);
+		b43_phy_set(dev, B43_NPHY_C2_CGAINI,
+				B43_NPHY_C2_CGAINI_CL2DETECT);
+
+		/* Set narrowband clip threshold */
+		b43_phy_set(dev, B43_NPHY_C1_NBCLIPTHRES, 0x84);
+		b43_phy_set(dev, B43_NPHY_C2_NBCLIPTHRES, 0x84);
+
+		if (!dev->phy.is_40mhz) {
+			/* Set dwell lengths */
+			b43_phy_set(dev, B43_NPHY_CLIP1_NBDWELL_LEN, 0x002B);
+			b43_phy_set(dev, B43_NPHY_CLIP2_NBDWELL_LEN, 0x002B);
+			b43_phy_set(dev, B43_NPHY_W1CLIP1_DWELL_LEN, 0x0009);
+			b43_phy_set(dev, B43_NPHY_W1CLIP2_DWELL_LEN, 0x0009);
+		}
+
+		/* Set wideband clip 2 threshold */
+		b43_phy_maskset(dev, B43_NPHY_C1_CLIPWBTHRES,
+				~B43_NPHY_C1_CLIPWBTHRES_CLIP2,
+				21);
+		b43_phy_maskset(dev, B43_NPHY_C2_CLIPWBTHRES,
+				~B43_NPHY_C2_CLIPWBTHRES_CLIP2,
+				21);
+
+		if (!dev->phy.is_40mhz) {
+			b43_phy_maskset(dev, B43_NPHY_C1_CGAINI,
+				~B43_NPHY_C1_CGAINI_GAINBKOFF, 0x1);
+			b43_phy_maskset(dev, B43_NPHY_C2_CGAINI,
+				~B43_NPHY_C2_CGAINI_GAINBKOFF, 0x1);
+			b43_phy_maskset(dev, B43_NPHY_C1_CCK_CGAINI,
+				~B43_NPHY_C1_CCK_CGAINI_GAINBKOFF, 0x1);
+			b43_phy_maskset(dev, B43_NPHY_C2_CCK_CGAINI,
+				~B43_NPHY_C2_CCK_CGAINI_GAINBKOFF, 0x1);
+		}
+
+		b43_phy_set(dev, B43_NPHY_CCK_SHIFTB_REF, 0x809C);
+
+		if (nphy->gain_boost) {
+			if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ &&
+			    dev->phy.is_40mhz)
+				code = 4;
+			else
+				code = 5;
+		} else {
+			code = dev->phy.is_40mhz ? 6 : 7;
+		}
+
+		/* Set HPVGA2 index */
+		b43_phy_maskset(dev, B43_NPHY_C1_INITGAIN,
+				~B43_NPHY_C1_INITGAIN_HPVGA2,
+				code << B43_NPHY_C1_INITGAIN_HPVGA2_SHIFT);
+		b43_phy_maskset(dev, B43_NPHY_C2_INITGAIN,
+				~B43_NPHY_C2_INITGAIN_HPVGA2,
+				code << B43_NPHY_C2_INITGAIN_HPVGA2_SHIFT);
+
+		b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x1D06);
+		b43_phy_write(dev, B43_NPHY_TABLE_DATALO,
+					(code << 8 | 0x7C));
+		b43_phy_write(dev, B43_NPHY_TABLE_DATALO,
+					(code << 8 | 0x7C));
+
+		/* TODO: b43_nphy_adjust_lna_gain_table(dev); */
+
+		if (nphy->elna_gain_config) {
+			b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x0808);
+			b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x0);
+			b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x1);
+			b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x1);
+			b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x1);
+
+			b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x0C08);
+			b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x0);
+			b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x1);
+			b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x1);
+			b43_phy_write(dev, B43_NPHY_TABLE_DATALO, 0x1);
+
+			b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x1D06);
+			b43_phy_write(dev, B43_NPHY_TABLE_DATALO,
+					(code << 8 | 0x74));
+			b43_phy_write(dev, B43_NPHY_TABLE_DATALO,
+					(code << 8 | 0x74));
+		}
+
+		if (dev->phy.rev == 2) {
+			for (i = 0; i < 4; i++) {
+				b43_phy_write(dev, B43_NPHY_TABLE_ADDR,
+						(0x0400 * i) + 0x0020);
+				for (j = 0; j < 21; j++)
+					b43_phy_write(dev,
+						B43_NPHY_TABLE_DATALO, 3 * j);
+			}
+
+			/* TODO: b43_nphy_set_rf_sequence(dev, 5,
+					rfseq_events, rfseq_delays, 3);*/
+			b43_phy_maskset(dev, B43_NPHY_OVER_DGAIN1,
+				(u16)~B43_NPHY_OVER_DGAIN_CCKDGECV,
+				0x5A << B43_NPHY_OVER_DGAIN_CCKDGECV_SHIFT);
+
+			if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+				b43_phy_maskset(dev, B43_PHY_N(0xC5D),
+						0xFF80, 4);
+		}
+	}
+}
+
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/Workarounds */
 static void b43_nphy_workarounds(struct b43_wldev *dev)
 {
@@ -786,7 +914,7 @@ static void b43_nphy_workarounds(struct b43_wldev *dev)
 		/*TODO:b43_nphy_set_rf_sequence(dev, 0, events1, delays1, 7);*/
 		/*TODO:b43_nphy_set_rf_sequence(dev, 1, events2, delays2, 7);*/
 
-		/*TODO:b43_nphy_gain_crtl_workarounds(dev);*/
+		b43_nphy_gain_crtl_workarounds(dev);
 
 		if (dev->phy.rev < 2) {
 			if (b43_phy_read(dev, B43_NPHY_RXCTL) & 0x2)
-- 
1.6.4.2

