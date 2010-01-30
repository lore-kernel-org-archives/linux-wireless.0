Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:60633 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263Ab0A3TSO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jan 2010 14:18:14 -0500
Received: by mail-fx0-f220.google.com with SMTP id 20so2964636fxm.21
        for <linux-wireless@vger.kernel.org>; Sat, 30 Jan 2010 11:18:14 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/5] b43: N-PHY: add RSSI selection for newer PHYs
Date: Sat, 30 Jan 2010 20:18:04 +0100
Message-Id: <1264879087-14326-2-git-send-email-zajec5@gmail.com>
In-Reply-To: <1264879087-14326-1-git-send-email-zajec5@gmail.com>
References: <1264879087-14326-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |   84 +++++++++++++++++++++++++++++++++++++-
 1 files changed, 83 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index c6a4dde..690aaad 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1367,7 +1367,89 @@ static void b43_nphy_rev2_rssi_select(struct b43_wldev *dev, u8 code, u8 type)
 
 static void b43_nphy_rev3_rssi_select(struct b43_wldev *dev, u8 code, u8 type)
 {
-	/* TODO */
+	struct b43_phy_n *nphy = dev->phy.n;
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
+					if ((nphy->ipa2g_on &&
+						band == IEEE80211_BAND_2GHZ) ||
+						(nphy->ipa5g_on &&
+						band == IEEE80211_BAND_5GHZ))
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
 }
 
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RSSISel */
-- 
1.6.4.2

