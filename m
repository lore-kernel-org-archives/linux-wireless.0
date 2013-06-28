Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:49968 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041Ab3F1TN0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jun 2013 15:13:26 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 13/19] rt2x00: rt2800lib: add rf_vals for RF3053
Date: Fri, 28 Jun 2013 21:12:27 +0200
Message-Id: <1372446753-11408-14-git-send-email-juhosg@openwrt.org> (sfid-20130628_211332_799950_FD3087B8)
In-Reply-To: <1372446753-11408-1-git-send-email-juhosg@openwrt.org>
References: <1372446753-11408-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Based on the Ralink DPO_RT5572_LinuxSTA_2.6.0.1_20120629
driver.

References:
  FreqItems3053 in chips/rt3593.c

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   70 +++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index bc21a57..6dcf03a 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -6962,6 +6962,72 @@ static const struct rf_channel rf_vals_5592_xtal40[] = {
 	{196, 83, 0, 12, 1},
 };
 
+static const struct rf_channel rf_vals_3053[] = {
+	/* Channel, N, R, K */
+	{1, 241, 2, 2},
+	{2, 241, 2, 7},
+	{3, 242, 2, 2},
+	{4, 242, 2, 7},
+	{5, 243, 2, 2},
+	{6, 243, 2, 7},
+	{7, 244, 2, 2},
+	{8, 244, 2, 7},
+	{9, 245, 2, 2},
+	{10, 245, 2, 7},
+	{11, 246, 2, 2},
+	{12, 246, 2, 7},
+	{13, 247, 2, 2},
+	{14, 248, 2, 4},
+
+	{36, 0x56, 0, 4},
+	{38, 0x56, 0, 6},
+	{40, 0x56, 0, 8},
+	{44, 0x57, 0, 0},
+	{46, 0x57, 0, 2},
+	{48, 0x57, 0, 4},
+	{52, 0x57, 0, 8},
+	{54, 0x57, 0, 10},
+	{56, 0x58, 0, 0},
+	{60, 0x58, 0, 4},
+	{62, 0x58, 0, 6},
+	{64, 0x58, 0, 8},
+
+	{100, 0x5B, 0, 8},
+	{102, 0x5B, 0, 10},
+	{104, 0x5C, 0, 0},
+	{108, 0x5C, 0, 4},
+	{110, 0x5C, 0, 6},
+	{112, 0x5C, 0, 8},
+
+	/* NOTE: Channel 114 has been removed intentionally.
+	 * The EEPROM contains no TX power values for that,
+	 * and it is disabled in the vendor driver as well.
+	 */
+
+	{116, 0x5D, 0, 0},
+	{118, 0x5D, 0, 2},
+	{120, 0x5D, 0, 4},
+	{124, 0x5D, 0, 8},
+	{126, 0x5D, 0, 10},
+	{128, 0x5E, 0, 0},
+	{132, 0x5E, 0, 4},
+	{134, 0x5E, 0, 6},
+	{136, 0x5E, 0, 8},
+	{140, 0x5F, 0, 0},
+
+	{149, 0x5F, 0, 9},
+	{151, 0x5F, 0, 11},
+	{153, 0x60, 0, 1},
+	{157, 0x60, 0, 5},
+	{159, 0x60, 0, 7},
+	{161, 0x60, 0, 9},
+	{165, 0x61, 0, 1},
+	{167, 0x61, 0, 3},
+	{169, 0x61, 0, 5},
+	{171, 0x61, 0, 7},
+	{173, 0x61, 0, 9},
+};
+
 static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 {
 	struct hw_mode_spec *spec = &rt2x00dev->spec;
@@ -7053,6 +7119,10 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 		spec->supported_bands |= SUPPORT_BAND_5GHZ;
 		spec->num_channels = ARRAY_SIZE(rf_vals_3x);
 		spec->channels = rf_vals_3x;
+	} else if (rt2x00_rf(rt2x00dev, RF3053)) {
+		spec->supported_bands |= SUPPORT_BAND_5GHZ;
+		spec->num_channels = ARRAY_SIZE(rf_vals_3053);
+		spec->channels = rf_vals_3053;
 	} else if (rt2x00_rf(rt2x00dev, RF5592)) {
 		spec->supported_bands |= SUPPORT_BAND_5GHZ;
 
-- 
1.7.10

