Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:51434 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814Ab2LBRe7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Dec 2012 12:34:59 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH] rt2x00: rt2800lib: introduce RFCSR3_VCOCAL_EN
Date: Sun,  2 Dec 2012 18:34:47 +0100
Message-Id: <1354469687-20895-1-git-send-email-juhosg@openwrt.org> (sfid-20121202_183503_864651_0A8B877D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On the RF3290,RF5360,RF5370,RF5372,RF5390,RF5392
radio frontends, the VCO calibration can be
controlled via the RFCSR3 register. The current
code uses the RFCSR30_RF_CALIBRATION constant to
enable the calibration, however that belongs to
the RFCSR30 register. Although the values of the
constant is correct, but using that for another
register is confusing.

Add a new definition for the VCO calibration enable
bit of the RFCSR3 register and use that in the
relevant places in order to avoid confusions.

The patch contains no functional changes.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
This depends on the following patch:
'rt2x00: rt2800lib: remove trailing semicolons from RFCSR3_* defines'

 drivers/net/wireless/rt2x00/rt2800.h    |    2 ++
 drivers/net/wireless/rt2x00/rt2800lib.c |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 1157b06..4db1088 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -1995,6 +1995,8 @@ struct mac_iveiv_entry {
 /* Bits [7-4] for RF3320 (RT3370/RT3390), on other chipsets reserved */
 #define RFCSR3_PA1_BIAS_CCK		FIELD8(0x70)
 #define RFCSR3_PA2_CASCODE_BIAS_CCKK	FIELD8(0x80)
+/* Bits for RF3290/RF5360/RF5370/RF5372/RF5390/RF5392 */
+#define RFCSR3_VCOCAL_EN		FIELD8(0x80)
 
 /*
  * FRCSR 5:
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 1cc6599..d4d0c36 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2243,7 +2243,7 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 		rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
 
 		rt2800_rfcsr_read(rt2x00dev, 3, &rfcsr);
-		rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 1);
+		rt2x00_set_field8(&rfcsr, RFCSR3_VCOCAL_EN, 1);
 		rt2800_rfcsr_write(rt2x00dev, 3, rfcsr);
 	}
 
@@ -2804,7 +2804,7 @@ void rt2800_vco_calibration(struct rt2x00_dev *rt2x00dev)
 	case RF5390:
 	case RF5392:
 		rt2800_rfcsr_read(rt2x00dev, 3, &rfcsr);
-		rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 1);
+		rt2x00_set_field8(&rfcsr, RFCSR3_VCOCAL_EN, 1);
 		rt2800_rfcsr_write(rt2x00dev, 3, rfcsr);
 		break;
 	default:
-- 
1.7.10

