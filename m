Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:57978 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966330Ab0B0MES (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 07:04:18 -0500
Received: by mail-fx0-f219.google.com with SMTP id 19so915402fxm.21
        for <linux-wireless@vger.kernel.org>; Sat, 27 Feb 2010 04:04:17 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V2 07/10] b43: N-PHY: adjust gain table
Date: Sat, 27 Feb 2010 13:03:38 +0100
Message-Id: <1267272221-1873-8-git-send-email-zajec5@gmail.com>
In-Reply-To: <1267272221-1873-1-git-send-email-zajec5@gmail.com>
References: <1267272221-1873-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |   58 +++++++++++++++++++++++++++++++++++++-
 1 files changed, 57 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 1952acc..30f8bf2 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -837,6 +837,62 @@ static void b43_nphy_spur_workaround(struct b43_wldev *dev)
 		b43_nphy_stay_in_carrier_search(dev, 0);
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
+	u16 lna_gain[4] = { -2, 10, 19, 25 };
+
+	if (nphy->hang_avoid)
+		b43_nphy_stay_in_carrier_search(dev, 1);
+
+	if (nphy->gain_boost) {
+		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+			gain[0] = 6;
+			gain[1] = 6;
+		} else {
+			tmp = 40370 - 315 * nphy->radio_chanspec.channel;
+			gain[0] = ((tmp >> 13) + ((tmp >> 12) & 1));
+			tmp = 23242 - 224 * nphy->radio_chanspec.channel;
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
+		b43_ntab_write_bulk(dev, B43_NTAB16(10, 8), 4, data);
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
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/WorkaroundsGainCtrl */
 static void b43_nphy_gain_crtl_workarounds(struct b43_wldev *dev)
 {
@@ -921,7 +977,7 @@ static void b43_nphy_gain_crtl_workarounds(struct b43_wldev *dev)
 		b43_phy_write(dev, B43_NPHY_TABLE_DATALO,
 					(code << 8 | 0x7C));
 
-		/* TODO: b43_nphy_adjust_lna_gain_table(dev); */
+		b43_nphy_adjust_lna_gain_table(dev);
 
 		if (nphy->elna_gain_config) {
 			b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x0808);
-- 
1.6.4.2

