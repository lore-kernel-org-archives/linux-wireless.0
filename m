Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56412 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab2E2ILe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 04:11:34 -0400
Received: by dady13 with SMTP id y13so5099160dad.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 May 2012 01:11:33 -0700 (PDT)
From: Zero Lin <zero.lin.0203@gmail.com>
To: users@rt2x00.serialmonkey.com
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	"Zero.Lin" <Zero.Lin@mediatek.com>
Subject: [PATCH] rt2x00:Add RT5392 chipset support
Date: Tue, 29 May 2012 16:11:09 +0800
Message-Id: <1338279069-5630-1-git-send-email-zero.lin.0203@gmail.com> (sfid-20120529_101251_201088_0ED55E4D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Zero.Lin" <Zero.Lin@mediatek.com>

Signed-off-by: Zero.Lin <Zero.Lin@mediatek.com>
---
 drivers/net/wireless/rt2x00/rt2800.h    |    6 ++++++
 drivers/net/wireless/rt2x00/rt2800lib.c |   22 +++++++++++++++++++++-
 2 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 9348521..e5d8d25 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -70,6 +70,7 @@
 #define RF5370				0x5370
 #define RF5372				0x5372
 #define RF5390				0x5390
+#define RF5392				0x5392
 
 /*
  * Chipset revisions.
@@ -1944,6 +1945,11 @@ struct mac_iveiv_entry {
 #define RFCSR49_TX			FIELD8(0x3f)
 
 /*
+ * RFCSR 50:
+ */
+#define RFCSR50_TX			FIELD8(0x3f)
+
+/*
  * RF registers
  */
 
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index dfc90d3..7d49d6f 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1958,7 +1958,22 @@ static void rt2800_config_channel_rf53xx(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field8(&rfcsr, RFCSR49_TX, info->default_power1);
 	rt2800_rfcsr_write(rt2x00dev, 49, rfcsr);
 
+	if (rt2x00_rt(rt2x00dev, RT5392)) {
+		rt2800_rfcsr_read(rt2x00dev, 50, &rfcsr);
+		if (info->default_power1 > RT5390_POWER_BOUND)
+			rt2x00_set_field8(&rfcsr, RFCSR50_TX,
+					  RT5390_POWER_BOUND);
+		else
+			rt2x00_set_field8(&rfcsr, RFCSR50_TX,
+					  info->default_power2);
+		rt2800_rfcsr_write(rt2x00dev, 50, rfcsr);
+	}
+
 	rt2800_rfcsr_read(rt2x00dev, 1, &rfcsr);
+	if (rt2x00_rt(rt2x00dev, RT5392)) {
+		rt2x00_set_field8(&rfcsr, RFCSR1_RX1_PD, 1);
+		rt2x00_set_field8(&rfcsr, RFCSR1_TX1_PD, 1);
+	}
 	rt2x00_set_field8(&rfcsr, RFCSR1_RF_BLOCK_EN, 1);
 	rt2x00_set_field8(&rfcsr, RFCSR1_PLL_PD, 1);
 	rt2x00_set_field8(&rfcsr, RFCSR1_RX0_PD, 1);
@@ -2063,6 +2078,7 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	case RF5370:
 	case RF5372:
 	case RF5390:
+	case RF5392:
 		rt2800_config_channel_rf53xx(rt2x00dev, conf, rf, info);
 		break;
 	default:
@@ -2552,6 +2568,7 @@ void rt2800_vco_calibration(struct rt2x00_dev *rt2x00dev)
 	case RF5370:
 	case RF5372:
 	case RF5390:
+	case RF5392:
 		rt2800_rfcsr_read(rt2x00dev, 3, &rfcsr);
 		rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 1);
 		rt2800_rfcsr_write(rt2x00dev, 3, rfcsr);
@@ -4266,6 +4283,7 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	case RF5370:
 	case RF5372:
 	case RF5390:
+	case RF5392:
 		break;
 	default:
 		ERROR(rt2x00dev, "Invalid RF chipset 0x%04x detected.\n",
@@ -4579,7 +4597,8 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 		   rt2x00_rf(rt2x00dev, RF3320) ||
 		   rt2x00_rf(rt2x00dev, RF5370) ||
 		   rt2x00_rf(rt2x00dev, RF5372) ||
-		   rt2x00_rf(rt2x00dev, RF5390)) {
+		   rt2x00_rf(rt2x00dev, RF5390) ||
+		   rt2x00_rf(rt2x00dev, RF5392)) {
 		spec->num_channels = 14;
 		spec->channels = rf_vals_3x;
 	} else if (rt2x00_rf(rt2x00dev, RF3052)) {
@@ -4665,6 +4684,7 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	case RF5370:
 	case RF5372:
 	case RF5390:
+	case RF5392:
 		__set_bit(CAPABILITY_VCO_RECALIBRATION, &rt2x00dev->cap_flags);
 		break;
 	}
-- 
1.7.5.4

