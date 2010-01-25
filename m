Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:34521 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab0AYSAZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 13:00:25 -0500
Received: by mail-ew0-f219.google.com with SMTP id 19so12782ewy.21
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jan 2010 10:00:25 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/4] b43: update cordic code to match current specs
Date: Mon, 25 Jan 2010 19:00:00 +0100
Message-Id: <1264442401-6364-4-git-send-email-zajec5@gmail.com>
In-Reply-To: <1264442401-6364-1-git-send-email-zajec5@gmail.com>
References: <1264442401-6364-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/b43/phy_common.c |   19 +++++++++++++------
 drivers/net/wireless/b43/phy_common.h |    4 ++++
 drivers/net/wireless/b43/phy_lp.c     |    7 ++++---
 3 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index 348a78f..868b829 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -422,21 +422,28 @@ void b43_phyop_switch_analog_generic(struct b43_wldev *dev, bool on)
 	b43_write16(dev, B43_MMIO_PHY0, on ? 0 : 0xF4);
 }
 
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/Cordic */
 b43_c32 b43_cordic(int theta)
 {
 	u32 arctg[] = { 2949120, 1740967, 919879, 466945, 234379, 117304,
 		      58666, 29335, 14668, 7334, 3667, 1833, 917, 458,
 		      229, 115, 57, 29, };
-	int i, tmp, signx = 1, angle = 0;
+	u8 i;
+	s32 tmp;
+	s8 signx = 1;
+	u32 angle = 0;
 	b43_c32 ret = { .i = 39797, .q = 0, };
 
-	theta = clamp_t(int, theta, -180, 180);
+	while (theta > (180 << 16))
+		theta -= (360 << 16);
+	while (theta < -(180 << 16))
+		theta += (360 << 16);
 
-	if (theta > 90) {
-		theta -= 180;
+	if (theta > (90 << 16)) {
+		theta -= (180 << 16);
 		signx = -1;
-	} else if (theta < -90) {
-		theta += 180;
+	} else if (theta < -(90 << 16)) {
+		theta += (180 << 16);
 		signx = -1;
 	}
 
diff --git a/drivers/net/wireless/b43/phy_common.h b/drivers/net/wireless/b43/phy_common.h
index 7a38226..0716f07 100644
--- a/drivers/net/wireless/b43/phy_common.h
+++ b/drivers/net/wireless/b43/phy_common.h
@@ -8,6 +8,10 @@ struct b43_wldev;
 /* Complex number using 2 32-bit signed integers */
 typedef struct { s32 i, q; } b43_c32;
 
+#define CORDIC_CONVERT(value)	(((value) >= 0) ? \
+				 ((((value) >> 15) + 1) >> 1) : \
+				 -((((-(value)) >> 15) + 1) >> 1))
+
 /* PHY register routing bits */
 #define B43_PHYROUTE			0x0C00 /* PHY register routing bits mask */
 #define  B43_PHYROUTE_BASE		0x0000 /* Base registers */
diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index a142804..e770aad 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -1784,7 +1784,8 @@ static void lpphy_start_tx_tone(struct b43_wldev *dev, s32 freq, u16 max)
 {
 	struct b43_phy_lp *lpphy = dev->phy.lp;
 	u16 buf[64];
-	int i, samples = 0, angle = 0, rotation = (9 * freq) / 500;
+	int i, samples = 0, angle = 0;
+	int rotation = (((36 * freq) / 20) << 16) / 100;
 	b43_c32 sample;
 
 	lpphy->tx_tone_freq = freq;
@@ -1803,8 +1804,8 @@ static void lpphy_start_tx_tone(struct b43_wldev *dev, s32 freq, u16 max)
 	for (i = 0; i < samples; i++) {
 		sample = b43_cordic(angle);
 		angle += rotation;
-		buf[i] = ((sample.i * max) & 0xFF) << 8;
-		buf[i] |= (sample.q * max) & 0xFF;
+		buf[i] = CORDIC_CONVERT((sample.i * max) & 0xFF) << 8;
+		buf[i] |= CORDIC_CONVERT((sample.q * max) & 0xFF);
 	}
 
 	b43_lptab_write_bulk(dev, B43_LPTAB16(5, 0), samples, buf);
-- 
1.6.4.2

