Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:42629 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751086AbdAMVX3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 16:23:29 -0500
Date: Fri, 13 Jan 2017 22:23:21 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 10/40] rt2x00: rt2800lib: add rf_vals for RF3853
Message-ID: <20170113212315.GA3419@makrotopia.org> (sfid-20170113_222331_814024_7F738D10)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gabor Juhos <juhosg@openwrt.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800.h    |  4 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 65 ++++++++++++++++++++++++++
 2 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800.h b/drivers/net/wireless/ralink/rt2x00/rt2800.h
index 02ed0d512734..2190bf07d004 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800.h
@@ -48,7 +48,8 @@
  * RF2853 2.4G/5G 3T3R
  * RF3320 2.4G 1T1R(RT3350/RT3370/RT3390)
  * RF3322 2.4G 2T2R(RT3352/RT3371/RT3372/RT3391/RT3392)
- * RF3053 2.4G/5G 3T3R(RT3883/RT3563/RT3573/RT3593/RT3662)
+ * RF3053 2.4G/5G 3T3R(RT3563/RT3573/RT3593)
+ * RF3853 2.4G/5G 3T3R(RT3883/RT3662)
  * RF5592 2.4G/5G 2T2R
  * RF3070 2.4G 1T1R
  * RF5360 2.4G 1T1R
@@ -72,6 +73,7 @@
 #define RF5592				0x000f
 #define RF3070				0x3070
 #define RF3290				0x3290
+#define RF3853				0x3853
 #define RF5360				0x5360
 #define RF5362				0x5362
 #define RF5370				0x5370
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index efac8a320054..a1f8ca9a788b 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -7482,6 +7482,66 @@ static const struct rf_channel rf_vals_3x[] = {
 	{173, 0x61, 0, 9},
 };
 
+static const struct rf_channel rf_vals_3853[] = {
+	{1,  241, 6, 2},
+	{2,  241, 6, 7},
+	{3,  242, 6, 2},
+	{4,  242, 6, 7},
+	{5,  243, 6, 2},
+	{6,  243, 6, 7},
+	{7,  244, 6, 2},
+	{8,  244, 6, 7},
+	{9,  245, 6, 2},
+	{10, 245, 6, 7},
+	{11, 246, 6, 2},
+	{12, 246, 6, 7},
+	{13, 247, 6, 2},
+	{14, 248, 6, 4},
+
+	{36, 0x56, 8, 4},
+	{38, 0x56, 8, 6},
+	{40, 0x56, 8, 8},
+	{44, 0x57, 8, 0},
+	{46, 0x57, 8, 2},
+	{48, 0x57, 8, 4},
+	{52, 0x57, 8, 8},
+	{54, 0x57, 8, 10},
+	{56, 0x58, 8, 0},
+	{60, 0x58, 8, 4},
+	{62, 0x58, 8, 6},
+	{64, 0x58, 8, 8},
+
+	{100, 0x5b, 8, 8},
+	{102, 0x5b, 8, 10},
+	{104, 0x5c, 8, 0},
+	{108, 0x5c, 8, 4},
+	{110, 0x5c, 8, 6},
+	{112, 0x5c, 8, 8},
+	{114, 0x5c, 8, 10},
+	{116, 0x5d, 8, 0},
+	{118, 0x5d, 8, 2},
+	{120, 0x5d, 8, 4},
+	{124, 0x5d, 8, 8},
+	{126, 0x5d, 8, 10},
+	{128, 0x5e, 8, 0},
+	{132, 0x5e, 8, 4},
+	{134, 0x5e, 8, 6},
+	{136, 0x5e, 8, 8},
+	{140, 0x5f, 8, 0},
+
+	{149, 0x5f, 8, 9},
+	{151, 0x5f, 8, 11},
+	{153, 0x60, 8, 1},
+	{157, 0x60, 8, 5},
+	{159, 0x60, 8, 7},
+	{161, 0x60, 8, 9},
+	{165, 0x61, 8, 1},
+	{167, 0x61, 8, 3},
+	{169, 0x61, 8, 5},
+	{171, 0x61, 8, 7},
+	{173, 0x61, 8, 9},
+};
+
 static const struct rf_channel rf_vals_5592_xtal20[] = {
 	/* Channel, N, K, mod, R */
 	{1, 482, 4, 10, 3},
@@ -7712,6 +7772,11 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 		spec->channels = rf_vals_3x;
 		break;
 
+	case RF3853:
+		spec->num_channels = ARRAY_SIZE(rf_vals_3853);
+		spec->channels = rf_vals_3853;
+		break;
+
 	case RF5592:
 		rt2800_register_read(rt2x00dev, MAC_DEBUG_INDEX, &reg);
 		if (rt2x00_get_field32(reg, MAC_DEBUG_INDEX_XTAL)) {
-- 
2.11.0
