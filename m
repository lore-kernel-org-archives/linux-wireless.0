Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:60633 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab0A3TSG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jan 2010 14:18:06 -0500
Received: by fxm20 with SMTP id 20so2964636fxm.21
        for <linux-wireless@vger.kernel.org>; Sat, 30 Jan 2010 11:18:03 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/5] b43: N-PHY: split RSSI selection into two per-PHY-revision functions
Date: Sat, 30 Jan 2010 20:18:03 +0100
Message-Id: <1264879087-14326-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |  101 +++++++++++++++++++------------------
 1 files changed, 52 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index d738d76..c6a4dde 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1316,66 +1316,69 @@ static void b43_nphy_scale_offset_rssi(struct b43_wldev *dev, u16 scale,
 		b43_phy_write(dev, B43_NPHY_RSSIMC_1Q_TSSI, tmp);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RSSISel */
-static void b43_nphy_rssi_select(struct b43_wldev *dev, u8 code, u8 type)
+static void b43_nphy_rev2_rssi_select(struct b43_wldev *dev, u8 code, u8 type)
 {
 	u16 val;
 
-	if (dev->phy.rev >= 3) {
-		/* TODO */
-	} else {
-		if (type < 3)
-			val = 0;
-		else if (type == 6)
-			val = 1;
-		else if (type == 3)
-			val = 2;
-		else
-			val = 3;
+	if (type < 3)
+		val = 0;
+	else if (type == 6)
+		val = 1;
+	else if (type == 3)
+		val = 2;
+	else
+		val = 3;
 
-		val = (val << 12) | (val << 14);
-		b43_phy_maskset(dev, B43_NPHY_AFECTL_C1, 0x0FFF, val);
-		b43_phy_maskset(dev, B43_NPHY_AFECTL_C2, 0x0FFF, val);
+	val = (val << 12) | (val << 14);
+	b43_phy_maskset(dev, B43_NPHY_AFECTL_C1, 0x0FFF, val);
+	b43_phy_maskset(dev, B43_NPHY_AFECTL_C2, 0x0FFF, val);
 
+	if (type < 3) {
+		b43_phy_maskset(dev, B43_NPHY_RFCTL_RSSIO1, 0xFFCF,
+				(type + 1) << 4);
+		b43_phy_maskset(dev, B43_NPHY_RFCTL_RSSIO2, 0xFFCF,
+				(type + 1) << 4);
+	}
+
+	/* TODO use some definitions */
+	if (code == 0) {
+		b43_phy_maskset(dev, B43_NPHY_AFECTL_OVER, 0xCFFF, 0);
 		if (type < 3) {
-			b43_phy_maskset(dev, B43_NPHY_RFCTL_RSSIO1, 0xFFCF,
-					(type + 1) << 4);
-			b43_phy_maskset(dev, B43_NPHY_RFCTL_RSSIO2, 0xFFCF,
-					(type + 1) << 4);
+			b43_phy_maskset(dev, B43_NPHY_RFCTL_CMD, 0xFEC7, 0);
+			b43_phy_maskset(dev, B43_NPHY_RFCTL_OVER, 0xEFDC, 0);
+			b43_phy_maskset(dev, B43_NPHY_RFCTL_CMD, 0xFFFE, 0);
+			udelay(20);
+			b43_phy_maskset(dev, B43_NPHY_RFCTL_OVER, 0xFFFE, 0);
 		}
-
-		/* TODO use some definitions */
-		if (code == 0) {
-			b43_phy_maskset(dev, B43_NPHY_AFECTL_OVER, 0xCFFF, 0);
-			if (type < 3) {
-				b43_phy_maskset(dev, B43_NPHY_RFCTL_CMD,
-						0xFEC7, 0);
-				b43_phy_maskset(dev, B43_NPHY_RFCTL_OVER,
-						0xEFDC, 0);
-				b43_phy_maskset(dev, B43_NPHY_RFCTL_CMD,
-						0xFFFE, 0);
-				udelay(20);
-				b43_phy_maskset(dev, B43_NPHY_RFCTL_OVER,
-						0xFFFE, 0);
-			}
-		} else {
-			b43_phy_maskset(dev, B43_NPHY_AFECTL_OVER, 0xCFFF,
-					0x3000);
-			if (type < 3) {
-				b43_phy_maskset(dev, B43_NPHY_RFCTL_CMD,
-						0xFEC7, 0x0180);
-				b43_phy_maskset(dev, B43_NPHY_RFCTL_OVER,
-						0xEFDC, (code << 1 | 0x1021));
-				b43_phy_maskset(dev, B43_NPHY_RFCTL_CMD,
-						0xFFFE, 0x0001);
-				udelay(20);
-				b43_phy_maskset(dev, B43_NPHY_RFCTL_OVER,
-						0xFFFE, 0);
-			}
+	} else {
+		b43_phy_maskset(dev, B43_NPHY_AFECTL_OVER, 0xCFFF,
+				0x3000);
+		if (type < 3) {
+			b43_phy_maskset(dev, B43_NPHY_RFCTL_CMD, 
+					0xFEC7, 0x0180);
+			b43_phy_maskset(dev, B43_NPHY_RFCTL_OVER,
+					0xEFDC, (code << 1 | 0x1021));
+			b43_phy_maskset(dev, B43_NPHY_RFCTL_CMD, 0xFFFE, 0x1);
+			udelay(20);
+			b43_phy_maskset(dev, B43_NPHY_RFCTL_OVER, 0xFFFE, 0);
 		}
 	}
 }
 
+static void b43_nphy_rev3_rssi_select(struct b43_wldev *dev, u8 code, u8 type)
+{
+	/* TODO */
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
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/SetRssi2055Vcm */
 static void b43_nphy_set_rssi_2055_vcm(struct b43_wldev *dev, u8 type, u8 *buf)
 {
-- 
1.6.4.2

