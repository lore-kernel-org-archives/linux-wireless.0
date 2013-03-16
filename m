Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:36895 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756016Ab3CPSTg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Mar 2013 14:19:36 -0400
From: stf_xl@wp.pl
To: "John W. Linville\"" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 03/25] rt2800: 5592: add channels table
Date: Sat, 16 Mar 2013 19:19:31 +0100
Message-Id: <1363457993-15541-4-git-send-email-stf_xl@wp.pl> (sfid-20130316_191938_855245_81E10584)
In-Reply-To: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
References: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Based on:
RT5592_ChipSwitchChannel()
RT5592_Frequency_Plan_Xtal20M[]
RT5592_Frequency_Plan_Xtal40M[]

from:
DPO_RT5572_LinuxSTA_2.6.1.3_20121022/chips/rt5592.c

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800.h    |    6 ++
 drivers/net/wireless/rt2x00/rt2800lib.c |  144 +++++++++++++++++++++++++++++++
 2 files changed, 150 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 58c0164..b72f71d 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -692,6 +692,12 @@
 #define GPIO_SWITCH_7			FIELD32(0x00000080)
 
 /*
+ * FIXME: where the DEBUG_INDEX name come from?
+ */
+#define MAC_DEBUG_INDEX			0x05e8
+#define MAC_DEBUG_INDEX_XTAL		FIELD32(0x80000000)
+
+/*
  * MAC Control/Status Registers(CSR).
  * Some values are set in TU, whereas 1 TU == 1024 us.
  */
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 45f58c9..45f0338 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -5124,6 +5124,138 @@ static const struct rf_channel rf_vals_3x[] = {
 	{173, 0x61, 0, 9},
 };
 
+static const struct rf_channel rf_vals_5592_xtal20[] = {
+	/* Channel, N, K, mod, R */
+	{1, 482, 4, 10, 3},
+	{2, 483, 4, 10, 3},
+	{3, 484, 4, 10, 3},
+	{4, 485, 4, 10, 3},
+	{5, 486, 4, 10, 3},
+	{6, 487, 4, 10, 3},
+	{7, 488, 4, 10, 3},
+	{8, 489, 4, 10, 3},
+	{9, 490, 4, 10, 3},
+	{10, 491, 4, 10, 3},
+	{11, 492, 4, 10, 3},
+	{12, 493, 4, 10, 3},
+	{13, 494, 4, 10, 3},
+	{14, 496, 8, 10, 3},
+	{36, 172, 8, 12, 1},
+	{38, 173, 0, 12, 1},
+	{40, 173, 4, 12, 1},
+	{42, 173, 8, 12, 1},
+	{44, 174, 0, 12, 1},
+	{46, 174, 4, 12, 1},
+	{48, 174, 8, 12, 1},
+	{50, 175, 0, 12, 1},
+	{52, 175, 4, 12, 1},
+	{54, 175, 8, 12, 1},
+	{56, 176, 0, 12, 1},
+	{58, 176, 4, 12, 1},
+	{60, 176, 8, 12, 1},
+	{62, 177, 0, 12, 1},
+	{64, 177, 4, 12, 1},
+	{100, 183, 4, 12, 1},
+	{102, 183, 8, 12, 1},
+	{104, 184, 0, 12, 1},
+	{106, 184, 4, 12, 1},
+	{108, 184, 8, 12, 1},
+	{110, 185, 0, 12, 1},
+	{112, 185, 4, 12, 1},
+	{114, 185, 8, 12, 1},
+	{116, 186, 0, 12, 1},
+	{118, 186, 4, 12, 1},
+	{120, 186, 8, 12, 1},
+	{122, 187, 0, 12, 1},
+	{124, 187, 4, 12, 1},
+	{126, 187, 8, 12, 1},
+	{128, 188, 0, 12, 1},
+	{130, 188, 4, 12, 1},
+	{132, 188, 8, 12, 1},
+	{134, 189, 0, 12, 1},
+	{136, 189, 4, 12, 1},
+	{138, 189, 8, 12, 1},
+	{140, 190, 0, 12, 1},
+	{149, 191, 6, 12, 1},
+	{151, 191, 10, 12, 1},
+	{153, 192, 2, 12, 1},
+	{155, 192, 6, 12, 1},
+	{157, 192, 10, 12, 1},
+	{159, 193, 2, 12, 1},
+	{161, 193, 6, 12, 1},
+	{165, 194, 2, 12, 1},
+	{184, 164, 0, 12, 1},
+	{188, 164, 4, 12, 1},
+	{192, 165, 8, 12, 1},
+	{196, 166, 0, 12, 1},
+};
+
+static const struct rf_channel rf_vals_5592_xtal40[] = {
+	/* Channel, N, K, mod, R */
+	{1, 241, 2, 10, 3},
+	{2, 241, 7, 10, 3},
+	{3, 242, 2, 10, 3},
+	{4, 242, 7, 10, 3},
+	{5, 243, 2, 10, 3},
+	{6, 243, 7, 10, 3},
+	{7, 244, 2, 10, 3},
+	{8, 244, 7, 10, 3},
+	{9, 245, 2, 10, 3},
+	{10, 245, 7, 10, 3},
+	{11, 246, 2, 10, 3},
+	{12, 246, 7, 10, 3},
+	{13, 247, 2, 10, 3},
+	{14, 248, 4, 10, 3},
+	{36, 86, 4, 12, 1},
+	{38, 86, 6, 12, 1},
+	{40, 86, 8, 12, 1},
+	{42, 86, 10, 12, 1},
+	{44, 87, 0, 12, 1},
+	{46, 87, 2, 12, 1},
+	{48, 87, 4, 12, 1},
+	{50, 87, 6, 12, 1},
+	{52, 87, 8, 12, 1},
+	{54, 87, 10, 12, 1},
+	{56, 88, 0, 12, 1},
+	{58, 88, 2, 12, 1},
+	{60, 88, 4, 12, 1},
+	{62, 88, 6, 12, 1},
+	{64, 88, 8, 12, 1},
+	{100, 91, 8, 12, 1},
+	{102, 91, 10, 12, 1},
+	{104, 92, 0, 12, 1},
+	{106, 92, 2, 12, 1},
+	{108, 92, 4, 12, 1},
+	{110, 92, 6, 12, 1},
+	{112, 92, 8, 12, 1},
+	{114, 92, 10, 12, 1},
+	{116, 93, 0, 12, 1},
+	{118, 93, 2, 12, 1},
+	{120, 93, 4, 12, 1},
+	{122, 93, 6, 12, 1},
+	{124, 93, 8, 12, 1},
+	{126, 93, 10, 12, 1},
+	{128, 94, 0, 12, 1},
+	{130, 94, 2, 12, 1},
+	{132, 94, 4, 12, 1},
+	{134, 94, 6, 12, 1},
+	{136, 94, 8, 12, 1},
+	{138, 94, 10, 12, 1},
+	{140, 95, 0, 12, 1},
+	{149, 95, 9, 12, 1},
+	{151, 95, 11, 12, 1},
+	{153, 96, 1, 12, 1},
+	{155, 96, 3, 12, 1},
+	{157, 96, 5, 12, 1},
+	{159, 96, 7, 12, 1},
+	{161, 96, 9, 12, 1},
+	{165, 97, 1, 12, 1},
+	{184, 82, 0, 12, 1},
+	{188, 82, 4, 12, 1},
+	{192, 82, 8, 12, 1},
+	{196, 83, 0, 12, 1},
+};
+
 static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 {
 	struct hw_mode_spec *spec = &rt2x00dev->spec;
@@ -5132,6 +5264,7 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	char *default_power2;
 	unsigned int i;
 	u16 eeprom;
+	u32 reg;
 
 	/*
 	 * Disable powersaving as default on PCI devices.
@@ -5213,6 +5346,17 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 		spec->supported_bands |= SUPPORT_BAND_5GHZ;
 		spec->num_channels = ARRAY_SIZE(rf_vals_3x);
 		spec->channels = rf_vals_3x;
+	} else if (rt2x00_rf(rt2x00dev, RF5592)) {
+		spec->supported_bands |= SUPPORT_BAND_5GHZ;
+
+		rt2800_register_read(rt2x00dev, MAC_DEBUG_INDEX, &reg);
+		if (rt2x00_get_field32(reg, MAC_DEBUG_INDEX_XTAL)) {
+			spec->num_channels = ARRAY_SIZE(rf_vals_5592_xtal40);
+			spec->channels = rf_vals_5592_xtal40;
+		} else {
+			spec->num_channels = ARRAY_SIZE(rf_vals_5592_xtal20);
+			spec->channels = rf_vals_5592_xtal20;
+		}
 	}
 
 	if (WARN_ON_ONCE(!spec->channels))
-- 
1.7.4.4

