Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:44830 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752734AbdASXnL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jan 2017 18:43:11 -0500
Date: Fri, 20 Jan 2017 00:42:44 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v3] rt2x00: rt2800lib: add support for RT3352 with 20MHz
 crystal
Message-ID: <20170119234239.GA22196@makrotopia.org> (sfid-20170120_004319_771813_E2C3496C)
References: <20170118142958.GA14573@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170118142958.GA14573@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Mathias Kresin <dev@kresin.me>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 50 +++++++++++++++++++++++++-
 drivers/net/wireless/ralink/rt2x00/rt2x00.h    |  2 ++
 2 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 8ea844d35ecb..c33298baecc3 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -36,6 +36,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/clk.h>
 
 #include "rt2x00.h"
 #include "rt2800lib.h"
@@ -7426,6 +7427,27 @@ static const struct rf_channel rf_vals_3x[] = {
 	{173, 0x61, 0, 9},
 };
 
+/*
+ * RF value list for rt3xxx with Xtal20MHz
+ * Supports: 2.4 GHz (all) (RF3322)
+ */
+static const struct rf_channel rf_vals_xtal20mhz_3x[] = {
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
@@ -7654,7 +7676,10 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	case RF5390:
 	case RF5392:
 		spec->num_channels = 14;
-		spec->channels = rf_vals_3x;
+		if (spec->clk_is_20mhz)
+			spec->channels = rf_vals_xtal20mhz_3x;
+		else
+			spec->channels = rf_vals_3x;
 		break;
 
 	case RF3052:
@@ -7835,6 +7860,20 @@ static int rt2800_probe_rt(struct rt2x00_dev *rt2x00dev)
 	return 0;
 }
 
+int rt2800_probe_clk(struct rt2x00_dev *rt2x00dev)
+{
+	struct hw_mode_spec *spec = &rt2x00dev->spec;
+	struct clk *clk = clk_get(rt2x00dev->dev, NULL);
+
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
+	if (clk_get_rate(clk) == 20000000)
+		spec->clk_is_20mhz = 1;
+
+	return 0;
+}
+
 int rt2800_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
@@ -7864,6 +7903,15 @@ int rt2800_probe_hw(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_write(rt2x00dev, GPIO_CTRL, reg);
 
 	/*
+	 * Probe SoC clock.
+	 */
+	if (rt2x00_is_soc(rt2x00dev)) {
+		retval = rt2800_probe_clk(rt2x00dev);
+		if (retval)
+			return retval;
+	}
+
+	/*
 	 * Initialize hw specifications.
 	 */
 	retval = rt2800_probe_hw_mode(rt2x00dev);
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
index bea7ac30522f..4b3dd1163653 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
@@ -400,6 +400,7 @@ static inline struct rt2x00_intf* vif_to_intf(struct ieee80211_vif *vif)
  * @channels: Device/chipset specific channel values (See &struct rf_channel).
  * @channels_info: Additional information for channels (See &struct channel_info).
  * @ht: Driver HT Capabilities (See &ieee80211_sta_ht_cap).
+ * @clk_is_20mhz: External crystal of WiSoC is 20MHz instead of 40MHz
  */
 struct hw_mode_spec {
 	unsigned int supported_bands;
@@ -415,6 +416,7 @@ struct hw_mode_spec {
 	const struct channel_info *channels_info;
 
 	struct ieee80211_sta_ht_cap ht;
+	int clk_is_20mhz;
 };
 
 /*
-- 
2.11.0
