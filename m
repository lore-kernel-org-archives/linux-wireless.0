Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:34521 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab0AYSAT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 13:00:19 -0500
Received: by mail-ew0-f219.google.com with SMTP id 19so12782ewy.21
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jan 2010 10:00:19 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/4] b43: make cordic common (LP-PHY and N-PHY need it)
Date: Mon, 25 Jan 2010 18:59:59 +0100
Message-Id: <1264442401-6364-3-git-send-email-zajec5@gmail.com>
In-Reply-To: <1264442401-6364-1-git-send-email-zajec5@gmail.com>
References: <1264442401-6364-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_common.c |   38 +++++++++++++++++++++++++++
 drivers/net/wireless/b43/phy_common.h |    3 ++
 drivers/net/wireless/b43/phy_lp.c     |   45 +-------------------------------
 3 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index 75b26e1..348a78f 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -421,3 +421,41 @@ void b43_phyop_switch_analog_generic(struct b43_wldev *dev, bool on)
 {
 	b43_write16(dev, B43_MMIO_PHY0, on ? 0 : 0xF4);
 }
+
+b43_c32 b43_cordic(int theta)
+{
+	u32 arctg[] = { 2949120, 1740967, 919879, 466945, 234379, 117304,
+		      58666, 29335, 14668, 7334, 3667, 1833, 917, 458,
+		      229, 115, 57, 29, };
+	int i, tmp, signx = 1, angle = 0;
+	b43_c32 ret = { .i = 39797, .q = 0, };
+
+	theta = clamp_t(int, theta, -180, 180);
+
+	if (theta > 90) {
+		theta -= 180;
+		signx = -1;
+	} else if (theta < -90) {
+		theta += 180;
+		signx = -1;
+	}
+
+	for (i = 0; i <= 17; i++) {
+		if (theta > angle) {
+			tmp = ret.i - (ret.q >> i);
+			ret.q += ret.i >> i;
+			ret.i = tmp;
+			angle += arctg[i];
+		} else {
+			tmp = ret.i + (ret.q >> i);
+			ret.q -= ret.i >> i;
+			ret.i = tmp;
+			angle -= arctg[i];
+		}
+	}
+
+	ret.i *= signx;
+	ret.q *= signx;
+
+	return ret;
+}
diff --git a/drivers/net/wireless/b43/phy_common.h b/drivers/net/wireless/b43/phy_common.h
index f635f9e..7a38226 100644
--- a/drivers/net/wireless/b43/phy_common.h
+++ b/drivers/net/wireless/b43/phy_common.h
@@ -5,6 +5,8 @@
 
 struct b43_wldev;
 
+/* Complex number using 2 32-bit signed integers */
+typedef struct { s32 i, q; } b43_c32;
 
 /* PHY register routing bits */
 #define B43_PHYROUTE			0x0C00 /* PHY register routing bits mask */
@@ -421,5 +423,6 @@ int b43_phy_shm_tssi_read(struct b43_wldev *dev, u16 shm_offset);
  */
 void b43_phyop_switch_analog_generic(struct b43_wldev *dev, bool on);
 
+b43_c32 b43_cordic(int theta);
 
 #endif /* LINUX_B43_PHY_COMMON_H_ */
diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index b58d6cf..a142804 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -1767,47 +1767,6 @@ out:
 	return ret;
 }
 
-/* Complex number using 2 32-bit signed integers */
-typedef struct {s32 i, q;} lpphy_c32;
-
-static lpphy_c32 lpphy_cordic(int theta)
-{
-	u32 arctg[] = { 2949120, 1740967, 919879, 466945, 234379, 117304,
-		      58666, 29335, 14668, 7334, 3667, 1833, 917, 458,
-		      229, 115, 57, 29, };
-	int i, tmp, signx = 1, angle = 0;
-	lpphy_c32 ret = { .i = 39797, .q = 0, };
-
-	theta = clamp_t(int, theta, -180, 180);
-
-	if (theta > 90) {
-		theta -= 180;
-		signx = -1;
-	} else if (theta < -90) {
-		theta += 180;
-		signx = -1;
-	}
-
-	for (i = 0; i <= 17; i++) {
-		if (theta > angle) {
-			tmp = ret.i - (ret.q >> i);
-			ret.q += ret.i >> i;
-			ret.i = tmp;
-			angle += arctg[i];
-		} else {
-			tmp = ret.i + (ret.q >> i);
-			ret.q -= ret.i >> i;
-			ret.i = tmp;
-			angle -= arctg[i];
-		}
-	}
-
-	ret.i *= signx;
-	ret.q *= signx;
-
-	return ret;
-}
-
 static void lpphy_run_samples(struct b43_wldev *dev, u16 samples, u16 loops,
 			      u16 wait)
 {
@@ -1826,7 +1785,7 @@ static void lpphy_start_tx_tone(struct b43_wldev *dev, s32 freq, u16 max)
 	struct b43_phy_lp *lpphy = dev->phy.lp;
 	u16 buf[64];
 	int i, samples = 0, angle = 0, rotation = (9 * freq) / 500;
-	lpphy_c32 sample;
+	b43_c32 sample;
 
 	lpphy->tx_tone_freq = freq;
 
@@ -1842,7 +1801,7 @@ static void lpphy_start_tx_tone(struct b43_wldev *dev, s32 freq, u16 max)
 	}
 
 	for (i = 0; i < samples; i++) {
-		sample = lpphy_cordic(angle);
+		sample = b43_cordic(angle);
 		angle += rotation;
 		buf[i] = ((sample.i * max) & 0xFF) << 8;
 		buf[i] |= (sample.q * max) & 0xFF;
-- 
1.6.4.2

