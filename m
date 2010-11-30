Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48155 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab0K3Vde (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 16:33:34 -0500
Received: by mail-ww0-f44.google.com with SMTP id 36so6559095wwa.1
        for <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 13:33:34 -0800 (PST)
From: =?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/3] b43: N-PHY: use defines for RSSI types
Date: Tue, 30 Nov 2010 22:33:15 +0100
Message-Id: <1291152796-18700-2-git-send-email-zajec5@gmail.com>
In-Reply-To: <1291152796-18700-1-git-send-email-zajec5@gmail.com>
References: <1291152796-18700-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |   73 +++++++++++++++++++++++--------------
 1 files changed, 45 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 1d08476..f26b60b 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -67,6 +67,16 @@ enum b43_nphy_rf_sequence {
 	B43_RFSEQ_UPDATE_GAINU,
 };
 
+enum b43_nphy_rssi_type {
+	B43_NPHY_RSSI_X = 0,
+	B43_NPHY_RSSI_Y,
+	B43_NPHY_RSSI_Z,
+	B43_NPHY_RSSI_PWRDET,
+	B43_NPHY_RSSI_TSSI_I,
+	B43_NPHY_RSSI_TSSI_Q,
+	B43_NPHY_RSSI_TBD,
+};
+
 static void b43_nphy_stay_in_carrier_search(struct b43_wldev *dev,
 						bool enable);
 static void b43_nphy_set_rf_sequence(struct b43_wldev *dev, u8 cmd,
@@ -1739,7 +1749,8 @@ static void b43_nphy_bphy_init(struct b43_wldev *dev)
 
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/ScaleOffsetRssi */
 static void b43_nphy_scale_offset_rssi(struct b43_wldev *dev, u16 scale,
-				       s8 offset, u8 core, u8 rail, u8 type)
+					s8 offset, u8 core, u8 rail,
+					enum b43_nphy_rssi_type type)
 {
 	u16 tmp;
 	bool core1or5 = (core == 1) || (core == 5);
@@ -1748,53 +1759,59 @@ static void b43_nphy_scale_offset_rssi(struct b43_wldev *dev, u16 scale,
 	offset = clamp_val(offset, -32, 31);
 	tmp = ((scale & 0x3F) << 8) | (offset & 0x3F);
 
-	if (core1or5 && (rail == 0) && (type == 2))
+	if (core1or5 && (rail == 0) && (type == B43_NPHY_RSSI_Z))
 		b43_phy_write(dev, B43_NPHY_RSSIMC_0I_RSSI_Z, tmp);
-	if (core1or5 && (rail == 1) && (type == 2))
+	if (core1or5 && (rail == 1) && (type == B43_NPHY_RSSI_Z))
 		b43_phy_write(dev, B43_NPHY_RSSIMC_0Q_RSSI_Z, tmp);
-	if (core2or5 && (rail == 0) && (type == 2))
+	if (core2or5 && (rail == 0) && (type == B43_NPHY_RSSI_Z))
 		b43_phy_write(dev, B43_NPHY_RSSIMC_1I_RSSI_Z, tmp);
-	if (core2or5 && (rail == 1) && (type == 2))
+	if (core2or5 && (rail == 1) && (type == B43_NPHY_RSSI_Z))
 		b43_phy_write(dev, B43_NPHY_RSSIMC_1Q_RSSI_Z, tmp);
-	if (core1or5 && (rail == 0) && (type == 0))
+
+	if (core1or5 && (rail == 0) && (type == B43_NPHY_RSSI_X))
 		b43_phy_write(dev, B43_NPHY_RSSIMC_0I_RSSI_X, tmp);
-	if (core1or5 && (rail == 1) && (type == 0))
+	if (core1or5 && (rail == 1) && (type == B43_NPHY_RSSI_X))
 		b43_phy_write(dev, B43_NPHY_RSSIMC_0Q_RSSI_X, tmp);
-	if (core2or5 && (rail == 0) && (type == 0))
+	if (core2or5 && (rail == 0) && (type == B43_NPHY_RSSI_X))
 		b43_phy_write(dev, B43_NPHY_RSSIMC_1I_RSSI_X, tmp);
-	if (core2or5 && (rail == 1) && (type == 0))
+	if (core2or5 && (rail == 1) && (type == B43_NPHY_RSSI_X))
 		b43_phy_write(dev, B43_NPHY_RSSIMC_1Q_RSSI_X, tmp);
-	if (core1or5 && (rail == 0) && (type == 1))
+
+	if (core1or5 && (rail == 0) && (type == B43_NPHY_RSSI_Y))
 		b43_phy_write(dev, B43_NPHY_RSSIMC_0I_RSSI_Y, tmp);
-	if (core1or5 && (rail == 1) && (type == 1))
+	if (core1or5 && (rail == 1) && (type == B43_NPHY_RSSI_Y))
 		b43_phy_write(dev, B43_NPHY_RSSIMC_0Q_RSSI_Y, tmp);
-	if (core2or5 && (rail == 0) && (type == 1))
+	if (core2or5 && (rail == 0) && (type == B43_NPHY_RSSI_Y))
 		b43_phy_write(dev, B43_NPHY_RSSIMC_1I_RSSI_Y, tmp);
-	if (core2or5 && (rail == 1) && (type == 1))
+	if (core2or5 && (rail == 1) && (type == B43_NPHY_RSSI_Y))
 		b43_phy_write(dev, B43_NPHY_RSSIMC_1Q_RSSI_Y, tmp);
-	if (core1or5 && (rail == 0) && (type == 6))
+
+	if (core1or5 && (rail == 0) && (type == B43_NPHY_RSSI_TBD))
 		b43_phy_write(dev, B43_NPHY_RSSIMC_0I_TBD, tmp);
-	if (core1or5 && (rail == 1) && (type == 6))
+	if (core1or5 && (rail == 1) && (type == B43_NPHY_RSSI_TBD))
 		b43_phy_write(dev, B43_NPHY_RSSIMC_0Q_TBD, tmp);
-	if (core2or5 && (rail == 0) && (type == 6))
+	if (core2or5 && (rail == 0) && (type == B43_NPHY_RSSI_TBD))
 		b43_phy_write(dev, B43_NPHY_RSSIMC_1I_TBD, tmp);
-	if (core2or5 && (rail == 1) && (type == 6))
+	if (core2or5 && (rail == 1) && (type == B43_NPHY_RSSI_TBD))
 		b43_phy_write(dev, B43_NPHY_RSSIMC_1Q_TBD, tmp);
-	if (core1or5 && (rail == 0) && (type == 3))
+
+	if (core1or5 && (rail == 0) && (type == B43_NPHY_RSSI_PWRDET))
 		b43_phy_write(dev, B43_NPHY_RSSIMC_0I_PWRDET, tmp);
-	if (core1or5 && (rail == 1) && (type == 3))
+	if (core1or5 && (rail == 1) && (type == B43_NPHY_RSSI_PWRDET))
 		b43_phy_write(dev, B43_NPHY_RSSIMC_0Q_PWRDET, tmp);
-	if (core2or5 && (rail == 0) && (type == 3))
+	if (core2or5 && (rail == 0) && (type == B43_NPHY_RSSI_PWRDET))
 		b43_phy_write(dev, B43_NPHY_RSSIMC_1I_PWRDET, tmp);
-	if (core2or5 && (rail == 1) && (type == 3))
+	if (core2or5 && (rail == 1) && (type == B43_NPHY_RSSI_PWRDET))
 		b43_phy_write(dev, B43_NPHY_RSSIMC_1Q_PWRDET, tmp);
-	if (core1or5 && (type == 4))
+
+	if (core1or5 && (type == B43_NPHY_RSSI_TSSI_I))
 		b43_phy_write(dev, B43_NPHY_RSSIMC_0I_TSSI, tmp);
-	if (core2or5 && (type == 4))
+	if (core2or5 && (type == B43_NPHY_RSSI_TSSI_I))
 		b43_phy_write(dev, B43_NPHY_RSSIMC_1I_TSSI, tmp);
-	if (core1or5 && (type == 5))
+
+	if (core1or5 && (type == B43_NPHY_RSSI_TSSI_Q))
 		b43_phy_write(dev, B43_NPHY_RSSIMC_0Q_TSSI, tmp);
-	if (core2or5 && (type == 5))
+	if (core2or5 && (type == B43_NPHY_RSSI_TSSI_Q))
 		b43_phy_write(dev, B43_NPHY_RSSIMC_1Q_TSSI, tmp);
 }
 
@@ -2246,9 +2263,9 @@ static void b43_nphy_rssi_cal(struct b43_wldev *dev)
 	if (dev->phy.rev >= 3) {
 		b43_nphy_rev3_rssi_cal(dev);
 	} else {
-		b43_nphy_rev2_rssi_cal(dev, 2);
-		b43_nphy_rev2_rssi_cal(dev, 0);
-		b43_nphy_rev2_rssi_cal(dev, 1);
+		b43_nphy_rev2_rssi_cal(dev, B43_NPHY_RSSI_Z);
+		b43_nphy_rev2_rssi_cal(dev, B43_NPHY_RSSI_X);
+		b43_nphy_rev2_rssi_cal(dev, B43_NPHY_RSSI_Y);
 	}
 }
 
-- 
1.6.3.3

