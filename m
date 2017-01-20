Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55266 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751022AbdATNn2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jan 2017 08:43:28 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Gabor Juhos <juhosg@openwrt.org>,
        Serge Vasilugin <vasilugin@yandex.ru>,
        Mathias Kresin <dev@kresin.me>,
        Michel Stempin <michel.stempin@wanadoo.fr>,
        John Crispin <blogic@openwrt.org>
Subject: [PATCH v4 2/3] rt2x00: rt2800lib: add support for RT3352 with 20MHz crystal
Date: Fri, 20 Jan 2017 14:28:25 +0100
Message-Id: <1484918906-21856-3-git-send-email-sgruszka@redhat.com> (sfid-20170120_144332_949581_D1F7E0FD)
In-Reply-To: <1484918906-21856-1-git-send-email-sgruszka@redhat.com>
References: <1484918906-21856-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Golle <daniel@makrotopia.org>

On Rt3352 the driver needs to know the frequency of an external
crystal which can be either 40 MHz (as on all other WiSoCs until now)
or 20 MHz.
Get the clock attached by ramips WiSoC platform code which probes
SYSC_REG_SYSCFG (added by John Crispin in commit 6ac8579b96e3b) and
introduce a new flag clk_is_20mhz in struct hw_mode_spec to make the
driver aware and use either 40 MHz or 20 MHz specific rf_vals on those
WiSoC platforms.
The introduced support for boards with a 20 MHz crystal is also needed
for RT5350.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Mathias Kresin <dev@kresin.me>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 31 +++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 8ea844d..5ae2950 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -1935,6 +1935,11 @@ static void rt2800_config_lna_gain(struct rt2x00_dev *rt2x00dev,
 	rt2x00dev->lna_gain = lna_gain;
 }
 
+static inline bool rt2800_clk_is_20mhz(struct rt2x00_dev *rt2x00dev)
+{
+	return clk_get_rate(rt2x00dev->clk) == 20000000;
+}
+
 #define FREQ_OFFSET_BOUND	0x5f
 
 static void rt2800_freq_cal_mode1(struct rt2x00_dev *rt2x00dev)
@@ -7426,6 +7431,27 @@ static int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	{173, 0x61, 0, 9},
 };
 
+/*
+ * RF value list for rt3xxx with Xtal20MHz
+ * Supports: 2.4 GHz (all) (RF3322)
+ */
+static const struct rf_channel rf_vals_3x_xtal20[] = {
+	{1,    0xE2,	 2,  0x14},
+	{2,    0xE3,	 2,  0x14},
+	{3,    0xE4,	 2,  0x14},
+	{4,    0xE5,	 2,  0x14},
+	{5,    0xE6,	 2,  0x14},
+	{6,    0xE7,	 2,  0x14},
+	{7,    0xE8,	 2,  0x14},
+	{8,    0xE9,	 2,  0x14},
+	{9,    0xEA,	 2,  0x14},
+	{10,   0xEB,	 2,  0x14},
+	{11,   0xEC,	 2,  0x14},
+	{12,   0xED,	 2,  0x14},
+	{13,   0xEE,	 2,  0x14},
+	{14,   0xF0,	 2,  0x18},
+};
+
 static const struct rf_channel rf_vals_5592_xtal20[] = {
 	/* Channel, N, K, mod, R */
 	{1, 482, 4, 10, 3},
@@ -7654,7 +7680,10 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	case RF5390:
 	case RF5392:
 		spec->num_channels = 14;
-		spec->channels = rf_vals_3x;
+		if (rt2800_clk_is_20mhz(rt2x00dev))
+			spec->channels = rf_vals_3x_xtal20;
+		else
+			spec->channels = rf_vals_3x;
 		break;
 
 	case RF3052:
-- 
1.8.3.1
