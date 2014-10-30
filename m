Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:58182 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759675AbaJ3LZR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2014 07:25:17 -0400
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: =?UTF-8?q?Canek=20Pel=C3=A1ez=20Vald=C3=A9s?=
	<canek@ciencias.unam.mx>, stable@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: [PATCH -stable] rt2x00: support Ralink 5362.
Date: Thu, 30 Oct 2014 12:18:17 +0100
Message-Id: <1414667897-2277-1-git-send-email-xose.vazquez@gmail.com> (sfid-20141030_122530_568162_BF68B077)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Canek Peláez Valdés <canek@ciencias.unam.mx>

Cc: stable@vger.kernel.org
Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: users@rt2x00.serialmonkey.com
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Canek Peláez Valdés <canek@ciencias.unam.mx>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/rt2x00/rt2800.h    | 4 +++-
 drivers/net/wireless/rt2x00/rt2800lib.c | 6 ++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index a394a9a..b7434df 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -52,6 +52,7 @@
  * RF5592 2.4G/5G 2T2R
  * RF3070 2.4G 1T1R
  * RF5360 2.4G 1T1R
+ * RF5362 2.4G 1T1R
  * RF5370 2.4G 1T1R
  * RF5390 2.4G 1T1R
  */
@@ -72,6 +73,7 @@
 #define RF3070				0x3070
 #define RF3290				0x3290
 #define RF5360				0x5360
+#define RF5362				0x5362
 #define RF5370				0x5370
 #define RF5372				0x5372
 #define RF5390				0x5390
@@ -2145,7 +2147,7 @@ struct mac_iveiv_entry {
 /* Bits [7-4] for RF3320 (RT3370/RT3390), on other chipsets reserved */
 #define RFCSR3_PA1_BIAS_CCK		FIELD8(0x70)
 #define RFCSR3_PA2_CASCODE_BIAS_CCKK	FIELD8(0x80)
-/* Bits for RF3290/RF5360/RF5370/RF5372/RF5390/RF5392 */
+/* Bits for RF3290/RF5360/RF5362/RF5370/RF5372/RF5390/RF5392 */
 #define RFCSR3_VCOCAL_EN		FIELD8(0x80)
 /* Bits for RF3050 */
 #define RFCSR3_BIT1			FIELD8(0x02)
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 893c9d5..9f57a2d 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3186,6 +3186,7 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 		break;
 	case RF3070:
 	case RF5360:
+	case RF5362:
 	case RF5370:
 	case RF5372:
 	case RF5390:
@@ -3203,6 +3204,7 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	    rt2x00_rf(rt2x00dev, RF3290) ||
 	    rt2x00_rf(rt2x00dev, RF3322) ||
 	    rt2x00_rf(rt2x00dev, RF5360) ||
+	    rt2x00_rf(rt2x00dev, RF5362) ||
 	    rt2x00_rf(rt2x00dev, RF5370) ||
 	    rt2x00_rf(rt2x00dev, RF5372) ||
 	    rt2x00_rf(rt2x00dev, RF5390) ||
@@ -4317,6 +4319,7 @@ void rt2800_vco_calibration(struct rt2x00_dev *rt2x00dev)
 	case RF3070:
 	case RF3290:
 	case RF5360:
+	case RF5362:
 	case RF5370:
 	case RF5372:
 	case RF5390:
@@ -7095,6 +7098,7 @@ static int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	case RF3320:
 	case RF3322:
 	case RF5360:
+	case RF5362:
 	case RF5370:
 	case RF5372:
 	case RF5390:
@@ -7551,6 +7555,7 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	case RF3320:
 	case RF3322:
 	case RF5360:
+	case RF5362:
 	case RF5370:
 	case RF5372:
 	case RF5390:
@@ -7680,6 +7685,7 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	case RF3070:
 	case RF3290:
 	case RF5360:
+	case RF5362:
 	case RF5370:
 	case RF5372:
 	case RF5390:
-- 
1.9.3

