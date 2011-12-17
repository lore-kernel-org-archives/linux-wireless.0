Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:65171 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab1LQM4f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Dec 2011 07:56:35 -0500
Received: by eekc4 with SMTP id c4so4011157eek.19
        for <linux-wireless@vger.kernel.org>; Sat, 17 Dec 2011 04:56:34 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 4/8] b43: N-PHY: reorder functions: collect RSSI selects
Date: Sat, 17 Dec 2011 13:57:23 +0100
Message-Id: <1324126647-22425-5-git-send-email-zajec5@gmail.com> (sfid-20111217_135641_007957_80E98F7D)
In-Reply-To: <1324126647-22425-1-git-send-email-zajec5@gmail.com>
References: <1324126647-22425-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |  446 +++++++++++++++++++-------------------
 1 files changed, 225 insertions(+), 221 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 3140b60..0e4a364 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -913,6 +913,231 @@ static void b43_nphy_run_samples(struct b43_wldev *dev, u16 samps, u16 loops,
 }
 
 /**************************************************
+ * RSSI
+ **************************************************/
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/ScaleOffsetRssi */
+static void b43_nphy_scale_offset_rssi(struct b43_wldev *dev, u16 scale,
+					s8 offset, u8 core, u8 rail,
+					enum b43_nphy_rssi_type type)
+{
+	u16 tmp;
+	bool core1or5 = (core == 1) || (core == 5);
+	bool core2or5 = (core == 2) || (core == 5);
+
+	offset = clamp_val(offset, -32, 31);
+	tmp = ((scale & 0x3F) << 8) | (offset & 0x3F);
+
+	if (core1or5 && (rail == 0) && (type == B43_NPHY_RSSI_Z))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_0I_RSSI_Z, tmp);
+	if (core1or5 && (rail == 1) && (type == B43_NPHY_RSSI_Z))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_0Q_RSSI_Z, tmp);
+	if (core2or5 && (rail == 0) && (type == B43_NPHY_RSSI_Z))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_1I_RSSI_Z, tmp);
+	if (core2or5 && (rail == 1) && (type == B43_NPHY_RSSI_Z))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_1Q_RSSI_Z, tmp);
+
+	if (core1or5 && (rail == 0) && (type == B43_NPHY_RSSI_X))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_0I_RSSI_X, tmp);
+	if (core1or5 && (rail == 1) && (type == B43_NPHY_RSSI_X))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_0Q_RSSI_X, tmp);
+	if (core2or5 && (rail == 0) && (type == B43_NPHY_RSSI_X))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_1I_RSSI_X, tmp);
+	if (core2or5 && (rail == 1) && (type == B43_NPHY_RSSI_X))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_1Q_RSSI_X, tmp);
+
+	if (core1or5 && (rail == 0) && (type == B43_NPHY_RSSI_Y))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_0I_RSSI_Y, tmp);
+	if (core1or5 && (rail == 1) && (type == B43_NPHY_RSSI_Y))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_0Q_RSSI_Y, tmp);
+	if (core2or5 && (rail == 0) && (type == B43_NPHY_RSSI_Y))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_1I_RSSI_Y, tmp);
+	if (core2or5 && (rail == 1) && (type == B43_NPHY_RSSI_Y))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_1Q_RSSI_Y, tmp);
+
+	if (core1or5 && (rail == 0) && (type == B43_NPHY_RSSI_TBD))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_0I_TBD, tmp);
+	if (core1or5 && (rail == 1) && (type == B43_NPHY_RSSI_TBD))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_0Q_TBD, tmp);
+	if (core2or5 && (rail == 0) && (type == B43_NPHY_RSSI_TBD))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_1I_TBD, tmp);
+	if (core2or5 && (rail == 1) && (type == B43_NPHY_RSSI_TBD))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_1Q_TBD, tmp);
+
+	if (core1or5 && (rail == 0) && (type == B43_NPHY_RSSI_PWRDET))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_0I_PWRDET, tmp);
+	if (core1or5 && (rail == 1) && (type == B43_NPHY_RSSI_PWRDET))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_0Q_PWRDET, tmp);
+	if (core2or5 && (rail == 0) && (type == B43_NPHY_RSSI_PWRDET))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_1I_PWRDET, tmp);
+	if (core2or5 && (rail == 1) && (type == B43_NPHY_RSSI_PWRDET))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_1Q_PWRDET, tmp);
+
+	if (core1or5 && (type == B43_NPHY_RSSI_TSSI_I))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_0I_TSSI, tmp);
+	if (core2or5 && (type == B43_NPHY_RSSI_TSSI_I))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_1I_TSSI, tmp);
+
+	if (core1or5 && (type == B43_NPHY_RSSI_TSSI_Q))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_0Q_TSSI, tmp);
+	if (core2or5 && (type == B43_NPHY_RSSI_TSSI_Q))
+		b43_phy_write(dev, B43_NPHY_RSSIMC_1Q_TSSI, tmp);
+}
+
+static void b43_nphy_rev3_rssi_select(struct b43_wldev *dev, u8 code, u8 type)
+{
+	u8 i;
+	u16 reg, val;
+
+	if (code == 0) {
+		b43_phy_mask(dev, B43_NPHY_AFECTL_OVER1, 0xFDFF);
+		b43_phy_mask(dev, B43_NPHY_AFECTL_OVER, 0xFDFF);
+		b43_phy_mask(dev, B43_NPHY_AFECTL_C1, 0xFCFF);
+		b43_phy_mask(dev, B43_NPHY_AFECTL_C2, 0xFCFF);
+		b43_phy_mask(dev, B43_NPHY_TXF_40CO_B1S0, 0xFFDF);
+		b43_phy_mask(dev, B43_NPHY_TXF_40CO_B32S1, 0xFFDF);
+		b43_phy_mask(dev, B43_NPHY_RFCTL_LUT_TRSW_UP1, 0xFFC3);
+		b43_phy_mask(dev, B43_NPHY_RFCTL_LUT_TRSW_UP2, 0xFFC3);
+	} else {
+		for (i = 0; i < 2; i++) {
+			if ((code == 1 && i == 1) || (code == 2 && !i))
+				continue;
+
+			reg = (i == 0) ?
+				B43_NPHY_AFECTL_OVER1 : B43_NPHY_AFECTL_OVER;
+			b43_phy_maskset(dev, reg, 0xFDFF, 0x0200);
+
+			if (type < 3) {
+				reg = (i == 0) ?
+					B43_NPHY_AFECTL_C1 :
+					B43_NPHY_AFECTL_C2;
+				b43_phy_maskset(dev, reg, 0xFCFF, 0);
+
+				reg = (i == 0) ?
+					B43_NPHY_RFCTL_LUT_TRSW_UP1 :
+					B43_NPHY_RFCTL_LUT_TRSW_UP2;
+				b43_phy_maskset(dev, reg, 0xFFC3, 0);
+
+				if (type == 0)
+					val = (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) ? 4 : 8;
+				else if (type == 1)
+					val = 16;
+				else
+					val = 32;
+				b43_phy_set(dev, reg, val);
+
+				reg = (i == 0) ?
+					B43_NPHY_TXF_40CO_B1S0 :
+					B43_NPHY_TXF_40CO_B32S1;
+				b43_phy_set(dev, reg, 0x0020);
+			} else {
+				if (type == 6)
+					val = 0x0100;
+				else if (type == 3)
+					val = 0x0200;
+				else
+					val = 0x0300;
+
+				reg = (i == 0) ?
+					B43_NPHY_AFECTL_C1 :
+					B43_NPHY_AFECTL_C2;
+
+				b43_phy_maskset(dev, reg, 0xFCFF, val);
+				b43_phy_maskset(dev, reg, 0xF3FF, val << 2);
+
+				if (type != 3 && type != 6) {
+					enum ieee80211_band band =
+						b43_current_band(dev->wl);
+
+					if (b43_nphy_ipa(dev))
+						val = (band == IEEE80211_BAND_5GHZ) ? 0xC : 0xE;
+					else
+						val = 0x11;
+					reg = (i == 0) ? 0x2000 : 0x3000;
+					reg |= B2055_PADDRV;
+					b43_radio_write16(dev, reg, val);
+
+					reg = (i == 0) ?
+						B43_NPHY_AFECTL_OVER1 :
+						B43_NPHY_AFECTL_OVER;
+					b43_phy_set(dev, reg, 0x0200);
+				}
+			}
+		}
+	}
+}
+
+static void b43_nphy_rev2_rssi_select(struct b43_wldev *dev, u8 code, u8 type)
+{
+	u16 val;
+
+	if (type < 3)
+		val = 0;
+	else if (type == 6)
+		val = 1;
+	else if (type == 3)
+		val = 2;
+	else
+		val = 3;
+
+	val = (val << 12) | (val << 14);
+	b43_phy_maskset(dev, B43_NPHY_AFECTL_C1, 0x0FFF, val);
+	b43_phy_maskset(dev, B43_NPHY_AFECTL_C2, 0x0FFF, val);
+
+	if (type < 3) {
+		b43_phy_maskset(dev, B43_NPHY_RFCTL_RSSIO1, 0xFFCF,
+				(type + 1) << 4);
+		b43_phy_maskset(dev, B43_NPHY_RFCTL_RSSIO2, 0xFFCF,
+				(type + 1) << 4);
+	}
+
+	if (code == 0) {
+		b43_phy_mask(dev, B43_NPHY_AFECTL_OVER, ~0x3000);
+		if (type < 3) {
+			b43_phy_mask(dev, B43_NPHY_RFCTL_CMD,
+				~(B43_NPHY_RFCTL_CMD_RXEN |
+				  B43_NPHY_RFCTL_CMD_CORESEL));
+			b43_phy_mask(dev, B43_NPHY_RFCTL_OVER,
+				~(0x1 << 12 |
+				  0x1 << 5 |
+				  0x1 << 1 |
+				  0x1));
+			b43_phy_mask(dev, B43_NPHY_RFCTL_CMD,
+				~B43_NPHY_RFCTL_CMD_START);
+			udelay(20);
+			b43_phy_mask(dev, B43_NPHY_RFCTL_OVER, ~0x1);
+		}
+	} else {
+		b43_phy_set(dev, B43_NPHY_AFECTL_OVER, 0x3000);
+		if (type < 3) {
+			b43_phy_maskset(dev, B43_NPHY_RFCTL_CMD,
+				~(B43_NPHY_RFCTL_CMD_RXEN |
+				  B43_NPHY_RFCTL_CMD_CORESEL),
+				(B43_NPHY_RFCTL_CMD_RXEN |
+				 code << B43_NPHY_RFCTL_CMD_CORESEL_SHIFT));
+			b43_phy_set(dev, B43_NPHY_RFCTL_OVER,
+				(0x1 << 12 |
+				  0x1 << 5 |
+				  0x1 << 1 |
+				  0x1));
+			b43_phy_set(dev, B43_NPHY_RFCTL_CMD,
+				B43_NPHY_RFCTL_CMD_START);
+			udelay(20);
+			b43_phy_mask(dev, B43_NPHY_RFCTL_OVER, ~0x1);
+		}
+	}
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RSSISel */
+static void b43_nphy_rssi_select(struct b43_wldev *dev, u8 code, u8 type)
+{
+	if (dev->phy.rev >= 3)
+		b43_nphy_rev3_rssi_select(dev, code, type);
+	else
+		b43_nphy_rev2_rssi_select(dev, code, type);
+}
+
+/**************************************************
  * Others
  **************************************************/
 
@@ -2311,227 +2536,6 @@ static void b43_nphy_bphy_init(struct b43_wldev *dev)
 	b43_phy_write(dev, B43_PHY_N_BMODE(0x38), 0x668);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/ScaleOffsetRssi */
-static void b43_nphy_scale_offset_rssi(struct b43_wldev *dev, u16 scale,
-					s8 offset, u8 core, u8 rail,
-					enum b43_nphy_rssi_type type)
-{
-	u16 tmp;
-	bool core1or5 = (core == 1) || (core == 5);
-	bool core2or5 = (core == 2) || (core == 5);
-
-	offset = clamp_val(offset, -32, 31);
-	tmp = ((scale & 0x3F) << 8) | (offset & 0x3F);
-
-	if (core1or5 && (rail == 0) && (type == B43_NPHY_RSSI_Z))
-		b43_phy_write(dev, B43_NPHY_RSSIMC_0I_RSSI_Z, tmp);
-	if (core1or5 && (rail == 1) && (type == B43_NPHY_RSSI_Z))
-		b43_phy_write(dev, B43_NPHY_RSSIMC_0Q_RSSI_Z, tmp);
-	if (core2or5 && (rail == 0) && (type == B43_NPHY_RSSI_Z))
-		b43_phy_write(dev, B43_NPHY_RSSIMC_1I_RSSI_Z, tmp);
-	if (core2or5 && (rail == 1) && (type == B43_NPHY_RSSI_Z))
-		b43_phy_write(dev, B43_NPHY_RSSIMC_1Q_RSSI_Z, tmp);
-
-	if (core1or5 && (rail == 0) && (type == B43_NPHY_RSSI_X))
-		b43_phy_write(dev, B43_NPHY_RSSIMC_0I_RSSI_X, tmp);
-	if (core1or5 && (rail == 1) && (type == B43_NPHY_RSSI_X))
-		b43_phy_write(dev, B43_NPHY_RSSIMC_0Q_RSSI_X, tmp);
-	if (core2or5 && (rail == 0) && (type == B43_NPHY_RSSI_X))
-		b43_phy_write(dev, B43_NPHY_RSSIMC_1I_RSSI_X, tmp);
-	if (core2or5 && (rail == 1) && (type == B43_NPHY_RSSI_X))
-		b43_phy_write(dev, B43_NPHY_RSSIMC_1Q_RSSI_X, tmp);
-
-	if (core1or5 && (rail == 0) && (type == B43_NPHY_RSSI_Y))
-		b43_phy_write(dev, B43_NPHY_RSSIMC_0I_RSSI_Y, tmp);
-	if (core1or5 && (rail == 1) && (type == B43_NPHY_RSSI_Y))
-		b43_phy_write(dev, B43_NPHY_RSSIMC_0Q_RSSI_Y, tmp);
-	if (core2or5 && (rail == 0) && (type == B43_NPHY_RSSI_Y))
-		b43_phy_write(dev, B43_NPHY_RSSIMC_1I_RSSI_Y, tmp);
-	if (core2or5 && (rail == 1) && (type == B43_NPHY_RSSI_Y))
-		b43_phy_write(dev, B43_NPHY_RSSIMC_1Q_RSSI_Y, tmp);
-
-	if (core1or5 && (rail == 0) && (type == B43_NPHY_RSSI_TBD))
-		b43_phy_write(dev, B43_NPHY_RSSIMC_0I_TBD, tmp);
-	if (core1or5 && (rail == 1) && (type == B43_NPHY_RSSI_TBD))
-		b43_phy_write(dev, B43_NPHY_RSSIMC_0Q_TBD, tmp);
-	if (core2or5 && (rail == 0) && (type == B43_NPHY_RSSI_TBD))
-		b43_phy_write(dev, B43_NPHY_RSSIMC_1I_TBD, tmp);
-	if (core2or5 && (rail == 1) && (type == B43_NPHY_RSSI_TBD))
-		b43_phy_write(dev, B43_NPHY_RSSIMC_1Q_TBD, tmp);
-
-	if (core1or5 && (rail == 0) && (type == B43_NPHY_RSSI_PWRDET))
-		b43_phy_write(dev, B43_NPHY_RSSIMC_0I_PWRDET, tmp);
-	if (core1or5 && (rail == 1) && (type == B43_NPHY_RSSI_PWRDET))
-		b43_phy_write(dev, B43_NPHY_RSSIMC_0Q_PWRDET, tmp);
-	if (core2or5 && (rail == 0) && (type == B43_NPHY_RSSI_PWRDET))
-		b43_phy_write(dev, B43_NPHY_RSSIMC_1I_PWRDET, tmp);
-	if (core2or5 && (rail == 1) && (type == B43_NPHY_RSSI_PWRDET))
-		b43_phy_write(dev, B43_NPHY_RSSIMC_1Q_PWRDET, tmp);
-
-	if (core1or5 && (type == B43_NPHY_RSSI_TSSI_I))
-		b43_phy_write(dev, B43_NPHY_RSSIMC_0I_TSSI, tmp);
-	if (core2or5 && (type == B43_NPHY_RSSI_TSSI_I))
-		b43_phy_write(dev, B43_NPHY_RSSIMC_1I_TSSI, tmp);
-
-	if (core1or5 && (type == B43_NPHY_RSSI_TSSI_Q))
-		b43_phy_write(dev, B43_NPHY_RSSIMC_0Q_TSSI, tmp);
-	if (core2or5 && (type == B43_NPHY_RSSI_TSSI_Q))
-		b43_phy_write(dev, B43_NPHY_RSSIMC_1Q_TSSI, tmp);
-}
-
-static void b43_nphy_rev2_rssi_select(struct b43_wldev *dev, u8 code, u8 type)
-{
-	u16 val;
-
-	if (type < 3)
-		val = 0;
-	else if (type == 6)
-		val = 1;
-	else if (type == 3)
-		val = 2;
-	else
-		val = 3;
-
-	val = (val << 12) | (val << 14);
-	b43_phy_maskset(dev, B43_NPHY_AFECTL_C1, 0x0FFF, val);
-	b43_phy_maskset(dev, B43_NPHY_AFECTL_C2, 0x0FFF, val);
-
-	if (type < 3) {
-		b43_phy_maskset(dev, B43_NPHY_RFCTL_RSSIO1, 0xFFCF,
-				(type + 1) << 4);
-		b43_phy_maskset(dev, B43_NPHY_RFCTL_RSSIO2, 0xFFCF,
-				(type + 1) << 4);
-	}
-
-	if (code == 0) {
-		b43_phy_mask(dev, B43_NPHY_AFECTL_OVER, ~0x3000);
-		if (type < 3) {
-			b43_phy_mask(dev, B43_NPHY_RFCTL_CMD,
-				~(B43_NPHY_RFCTL_CMD_RXEN |
-				  B43_NPHY_RFCTL_CMD_CORESEL));
-			b43_phy_mask(dev, B43_NPHY_RFCTL_OVER,
-				~(0x1 << 12 |
-				  0x1 << 5 |
-				  0x1 << 1 |
-				  0x1));
-			b43_phy_mask(dev, B43_NPHY_RFCTL_CMD,
-				~B43_NPHY_RFCTL_CMD_START);
-			udelay(20);
-			b43_phy_mask(dev, B43_NPHY_RFCTL_OVER, ~0x1);
-		}
-	} else {
-		b43_phy_set(dev, B43_NPHY_AFECTL_OVER, 0x3000);
-		if (type < 3) {
-			b43_phy_maskset(dev, B43_NPHY_RFCTL_CMD,
-				~(B43_NPHY_RFCTL_CMD_RXEN |
-				  B43_NPHY_RFCTL_CMD_CORESEL),
-				(B43_NPHY_RFCTL_CMD_RXEN |
-				 code << B43_NPHY_RFCTL_CMD_CORESEL_SHIFT));
-			b43_phy_set(dev, B43_NPHY_RFCTL_OVER,
-				(0x1 << 12 |
-				  0x1 << 5 |
-				  0x1 << 1 |
-				  0x1));
-			b43_phy_set(dev, B43_NPHY_RFCTL_CMD,
-				B43_NPHY_RFCTL_CMD_START);
-			udelay(20);
-			b43_phy_mask(dev, B43_NPHY_RFCTL_OVER, ~0x1);
-		}
-	}
-}
-
-static void b43_nphy_rev3_rssi_select(struct b43_wldev *dev, u8 code, u8 type)
-{
-	u8 i;
-	u16 reg, val;
-
-	if (code == 0) {
-		b43_phy_mask(dev, B43_NPHY_AFECTL_OVER1, 0xFDFF);
-		b43_phy_mask(dev, B43_NPHY_AFECTL_OVER, 0xFDFF);
-		b43_phy_mask(dev, B43_NPHY_AFECTL_C1, 0xFCFF);
-		b43_phy_mask(dev, B43_NPHY_AFECTL_C2, 0xFCFF);
-		b43_phy_mask(dev, B43_NPHY_TXF_40CO_B1S0, 0xFFDF);
-		b43_phy_mask(dev, B43_NPHY_TXF_40CO_B32S1, 0xFFDF);
-		b43_phy_mask(dev, B43_NPHY_RFCTL_LUT_TRSW_UP1, 0xFFC3);
-		b43_phy_mask(dev, B43_NPHY_RFCTL_LUT_TRSW_UP2, 0xFFC3);
-	} else {
-		for (i = 0; i < 2; i++) {
-			if ((code == 1 && i == 1) || (code == 2 && !i))
-				continue;
-
-			reg = (i == 0) ?
-				B43_NPHY_AFECTL_OVER1 : B43_NPHY_AFECTL_OVER;
-			b43_phy_maskset(dev, reg, 0xFDFF, 0x0200);
-
-			if (type < 3) {
-				reg = (i == 0) ?
-					B43_NPHY_AFECTL_C1 :
-					B43_NPHY_AFECTL_C2;
-				b43_phy_maskset(dev, reg, 0xFCFF, 0);
-
-				reg = (i == 0) ?
-					B43_NPHY_RFCTL_LUT_TRSW_UP1 :
-					B43_NPHY_RFCTL_LUT_TRSW_UP2;
-				b43_phy_maskset(dev, reg, 0xFFC3, 0);
-
-				if (type == 0)
-					val = (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) ? 4 : 8;
-				else if (type == 1)
-					val = 16;
-				else
-					val = 32;
-				b43_phy_set(dev, reg, val);
-
-				reg = (i == 0) ?
-					B43_NPHY_TXF_40CO_B1S0 :
-					B43_NPHY_TXF_40CO_B32S1;
-				b43_phy_set(dev, reg, 0x0020);
-			} else {
-				if (type == 6)
-					val = 0x0100;
-				else if (type == 3)
-					val = 0x0200;
-				else
-					val = 0x0300;
-
-				reg = (i == 0) ?
-					B43_NPHY_AFECTL_C1 :
-					B43_NPHY_AFECTL_C2;
-
-				b43_phy_maskset(dev, reg, 0xFCFF, val);
-				b43_phy_maskset(dev, reg, 0xF3FF, val << 2);
-
-				if (type != 3 && type != 6) {
-					enum ieee80211_band band =
-						b43_current_band(dev->wl);
-
-					if (b43_nphy_ipa(dev))
-						val = (band == IEEE80211_BAND_5GHZ) ? 0xC : 0xE;
-					else
-						val = 0x11;
-					reg = (i == 0) ? 0x2000 : 0x3000;
-					reg |= B2055_PADDRV;
-					b43_radio_write16(dev, reg, val);
-
-					reg = (i == 0) ?
-						B43_NPHY_AFECTL_OVER1 :
-						B43_NPHY_AFECTL_OVER;
-					b43_phy_set(dev, reg, 0x0200);
-				}
-			}
-		}
-	}
-}
-
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RSSISel */
-static void b43_nphy_rssi_select(struct b43_wldev *dev, u8 code, u8 type)
-{
-	if (dev->phy.rev >= 3)
-		b43_nphy_rev3_rssi_select(dev, code, type);
-	else
-		b43_nphy_rev2_rssi_select(dev, code, type);
-}
-
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/SetRssi2055Vcm */
 static void b43_nphy_set_rssi_2055_vcm(struct b43_wldev *dev, u8 type, u8 *buf)
 {
-- 
1.7.7

