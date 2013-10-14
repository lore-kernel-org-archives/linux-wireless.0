Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:53672 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755614Ab3JNUAF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 16:00:05 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 2/3] rt2x00: rt2800lib: use switch statement for RF specific setup
Date: Mon, 14 Oct 2013 21:59:51 +0200
Message-Id: <1381780792-28894-2-git-send-email-juhosg@openwrt.org> (sfid-20131014_220010_418689_0765253A)
In-Reply-To: <1381780792-28894-1-git-send-email-juhosg@openwrt.org>
References: <1381780792-28894-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is much more readable than multiple if-else-if
statements.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   51 ++++++++++++++++++-------------
 1 file changed, 30 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 3ca0d3e..f143075 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -7504,38 +7504,46 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	spec->supported_bands = SUPPORT_BAND_2GHZ;
 	spec->supported_rates = SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
 
-	if (rt2x00_rf(rt2x00dev, RF2820) ||
-	    rt2x00_rf(rt2x00dev, RF2720)) {
+	switch (rt2x00dev->chip.rf) {
+	case RF2720:
+	case RF2820:
 		spec->num_channels = 14;
 		spec->channels = rf_vals;
-	} else if (rt2x00_rf(rt2x00dev, RF2850) ||
-		   rt2x00_rf(rt2x00dev, RF2750)) {
+		break;
+
+	case RF2750:
+	case RF2850:
 		spec->supported_bands |= SUPPORT_BAND_5GHZ;
 		spec->num_channels = ARRAY_SIZE(rf_vals);
 		spec->channels = rf_vals;
-	} else if (rt2x00_rf(rt2x00dev, RF3020) ||
-		   rt2x00_rf(rt2x00dev, RF2020) ||
-		   rt2x00_rf(rt2x00dev, RF3021) ||
-		   rt2x00_rf(rt2x00dev, RF3022) ||
-		   rt2x00_rf(rt2x00dev, RF3070) ||
-		   rt2x00_rf(rt2x00dev, RF3290) ||
-		   rt2x00_rf(rt2x00dev, RF3320) ||
-		   rt2x00_rf(rt2x00dev, RF3322) ||
-		   rt2x00_rf(rt2x00dev, RF5360) ||
-		   rt2x00_rf(rt2x00dev, RF5370) ||
-		   rt2x00_rf(rt2x00dev, RF5372) ||
-		   rt2x00_rf(rt2x00dev, RF5390) ||
-		   rt2x00_rf(rt2x00dev, RF5392)) {
+		break;
+
+	case RF2020:
+	case RF3020:
+	case RF3021:
+	case RF3022:
+	case RF3070:
+	case RF3290:
+	case RF3320:
+	case RF3322:
+	case RF5360:
+	case RF5370:
+	case RF5372:
+	case RF5390:
+	case RF5392:
 		spec->num_channels = 14;
 		spec->channels = rf_vals_3x;
-	} else if (rt2x00_rf(rt2x00dev, RF3052) ||
-		   rt2x00_rf(rt2x00dev, RF3053)) {
+		break;
+
+	case RF3052:
+	case RF3053:
 		spec->supported_bands |= SUPPORT_BAND_5GHZ;
 		spec->num_channels = ARRAY_SIZE(rf_vals_3x);
 		spec->channels = rf_vals_3x;
-	} else if (rt2x00_rf(rt2x00dev, RF5592)) {
-		spec->supported_bands |= SUPPORT_BAND_5GHZ;
+		break;
 
+	case RF5592:
+		spec->supported_bands |= SUPPORT_BAND_5GHZ;
 		rt2800_register_read(rt2x00dev, MAC_DEBUG_INDEX, &reg);
 		if (rt2x00_get_field32(reg, MAC_DEBUG_INDEX_XTAL)) {
 			spec->num_channels = ARRAY_SIZE(rf_vals_5592_xtal40);
@@ -7544,6 +7552,7 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 			spec->num_channels = ARRAY_SIZE(rf_vals_5592_xtal20);
 			spec->channels = rf_vals_5592_xtal20;
 		}
+		break;
 	}
 
 	if (WARN_ON_ONCE(!spec->channels))
-- 
1.7.10
