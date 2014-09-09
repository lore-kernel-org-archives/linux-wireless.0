Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:63268 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbaIITSW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2014 15:18:22 -0400
Received: by mail-we0-f170.google.com with SMTP id u57so4351318wes.29
        for <linux-wireless@vger.kernel.org>; Tue, 09 Sep 2014 12:18:21 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/4] b43: HT-PHY: Move radio calibration to separated functions
Date: Tue,  9 Sep 2014 21:17:07 +0200
Message-Id: <1410290229-7033-2-git-send-email-zajec5@gmail.com> (sfid-20140909_211825_168695_A30C7031)
In-Reply-To: <1410290229-7033-1-git-send-email-zajec5@gmail.com>
References: <1410290229-7033-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also use b43_radio_wait_value to simplify the code and usleep_range when
needed.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_ht.c | 93 ++++++++++++++++++++-------------------
 1 file changed, 47 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index 7b44541..ff31c20 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -89,6 +89,50 @@ static void b43_radio_2059_channel_setup(struct b43_wldev *dev,
 	udelay(300);
 }
 
+/* Calibrate resistors in LPF of PLL? */
+static void b43_radio_2059_rcal(struct b43_wldev *dev)
+{
+	b43_radio_set(dev, R2059_C3 | 0x4, 0x1);
+	usleep_range(10, 20);
+	b43_radio_set(dev, R2059_C3 | 0x0BF, 0x1);
+	b43_radio_maskset(dev, R2059_C3 | 0x19B, 0x3, 0x2);
+
+	b43_radio_set(dev, R2059_C3 | 0x4, 0x2);
+	usleep_range(100, 200);
+	b43_radio_mask(dev, R2059_C3 | 0x4, ~0x2);
+
+	if (!b43_radio_wait_value(dev, R2059_C3 | 0x145, 1, 1, 100,
+				  1000000))
+		b43err(dev->wl, "Radio 0x2059 rcal timeout\n");
+
+	b43_radio_mask(dev, R2059_C3 | 0x4, ~0x1);
+	b43_radio_set(dev, 0xa, 0x60);
+}
+
+/* Calibrate the internal RC oscillator? */
+static void b43_radio_2057_rccal(struct b43_wldev *dev)
+{
+	const u16 radio_values[3][2] = {
+		{ 0x61, 0xE9 }, { 0x69, 0xD5 }, { 0x73, 0x99 },
+	};
+	int i;
+
+	for (i = 0; i < 3; i++) {
+		b43_radio_write(dev, 0x17F, radio_values[i][0]);
+		b43_radio_write(dev, 0x13D, 0x6E);
+		b43_radio_write(dev, 0x13E, radio_values[i][1]);
+		b43_radio_write(dev, 0x13C, 0x55);
+
+		if (!b43_radio_wait_value(dev, 0x140, 2, 2,
+					  500, 5000000))
+			b43err(dev->wl, "Radio 0x2059 rccal timeout\n");
+
+		b43_radio_write(dev, 0x13C, 0x15);
+	}
+
+	b43_radio_mask(dev, 0x17F, ~0x1);
+}
+
 static void b43_radio_2059_init_pre(struct b43_wldev *dev)
 {
 	b43_phy_mask(dev, B43_PHY_HT_RF_CTL_CMD, ~B43_PHY_HT_RF_CTL_CMD_CHIP0_PU);
@@ -100,10 +144,7 @@ static void b43_radio_2059_init_pre(struct b43_wldev *dev)
 static void b43_radio_2059_init(struct b43_wldev *dev)
 {
 	const u16 routing[] = { R2059_C1, R2059_C2, R2059_C3 };
-	const u16 radio_values[3][2] = {
-		{ 0x61, 0xE9 }, { 0x69, 0xD5 }, { 0x73, 0x99 },
-	};
-	u16 i, j;
+	int i;
 
 	/* Prepare (reset?) radio */
 	b43_radio_2059_init_pre(dev);
@@ -121,48 +162,8 @@ static void b43_radio_2059_init(struct b43_wldev *dev)
 	b43_radio_mask(dev, 0xc0, ~0x0080);
 
 	if (1) { /* FIXME */
-		b43_radio_set(dev, R2059_C3 | 0x4, 0x1);
-		udelay(10);
-		b43_radio_set(dev, R2059_C3 | 0x0BF, 0x1);
-		b43_radio_maskset(dev, R2059_C3 | 0x19B, 0x3, 0x2);
-
-		b43_radio_set(dev, R2059_C3 | 0x4, 0x2);
-		udelay(100);
-		b43_radio_mask(dev, R2059_C3 | 0x4, ~0x2);
-
-		for (i = 0; i < 10000; i++) {
-			if (b43_radio_read(dev, R2059_C3 | 0x145) & 1) {
-				i = 0;
-				break;
-			}
-			udelay(100);
-		}
-		if (i)
-			b43err(dev->wl, "radio 0x945 timeout\n");
-
-		b43_radio_mask(dev, R2059_C3 | 0x4, ~0x1);
-		b43_radio_set(dev, 0xa, 0x60);
-
-		for (i = 0; i < 3; i++) {
-			b43_radio_write(dev, 0x17F, radio_values[i][0]);
-			b43_radio_write(dev, 0x13D, 0x6E);
-			b43_radio_write(dev, 0x13E, radio_values[i][1]);
-			b43_radio_write(dev, 0x13C, 0x55);
-
-			for (j = 0; j < 10000; j++) {
-				if (b43_radio_read(dev, 0x140) & 2) {
-					j = 0;
-					break;
-				}
-				udelay(500);
-			}
-			if (j)
-				b43err(dev->wl, "radio 0x140 timeout\n");
-
-			b43_radio_write(dev, 0x13C, 0x15);
-		}
-
-		b43_radio_mask(dev, 0x17F, ~0x1);
+		b43_radio_2059_rcal(dev);
+		b43_radio_2057_rccal(dev);
 	}
 
 	b43_radio_mask(dev, 0x11, ~0x0008);
-- 
1.8.4.5

