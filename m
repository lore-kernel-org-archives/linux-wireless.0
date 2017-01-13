Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:56544 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750908AbdAMVd3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 16:33:29 -0500
Date: Fri, 13 Jan 2017 22:33:20 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 37/40] rt2x00: add support for RT3352 with 20MHz crystal
Message-ID: <20170113213315.GA3656@makrotopia.org> (sfid-20170113_223331_677609_597031CE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Mathias Kresin <dev@kresin.me>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 50 +++++++++++++++++++++++++-
 drivers/net/wireless/ralink/rt2x00/rt2x00.h    |  2 ++
 2 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 320fdb90be84..6a24892476c3 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -36,6 +36,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/clk.h>
 
 #include "rt2x00.h"
 #include "rt2800lib.h"
@@ -8227,6 +8228,27 @@ static const struct rf_channel rf_vals_5592_xtal40[] = {
 	{196, 83, 0, 12, 1},
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
 static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 {
 	struct hw_mode_spec *spec = &rt2x00dev->spec;
@@ -8316,7 +8338,10 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
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
@@ -8504,6 +8529,20 @@ static int rt2800_probe_rt(struct rt2x00_dev *rt2x00dev)
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
 	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
@@ -8546,6 +8585,15 @@ int rt2800_probe_hw(struct rt2x00_dev *rt2x00dev)
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
index cfbf414c2627..b1eec49b0dac 100644
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
