Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:13162 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264Ab1DXRRz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Apr 2011 13:17:55 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/1 RFC] mac80211: add ratio to led blinking trigger
Date: Sun, 24 Apr 2011 10:15:00 -0700
Message-Id: <1303665300-1775-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110424_191812_851726_8A7D5FAA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current led blink trigger implementaion assume on/off time are equal,
it works but not have any flexbile for different blink pattern.

Add "ratio" parameter in the trigger table and give driver more control
on how the on/off blink time behavior should be.

 ratio = 100: blink off time = blink on time
 ratio = 80: blink off time = 80% of blink on time
 ratio = 0: blink off time = 0% of blink on time 

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/ath/ath9k/init.c   |   20 ++++++++++----------
 drivers/net/wireless/iwlegacy/iwl-led.c |   28 +++++++++++-----------------
 drivers/net/wireless/iwlwifi/iwl-led.c  |   28 +++++++++++-----------------
 include/net/mac80211.h                  |   10 +++++++---
 net/mac80211/led.c                      |    4 ++--
 5 files changed, 41 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 1ac8318..a691992 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -143,16 +143,16 @@ static struct ieee80211_rate ath9k_legacy_rates[] = {
 
 #ifdef CONFIG_MAC80211_LEDS
 static const struct ieee80211_tpt_blink ath9k_tpt_blink[] = {
-	{ .throughput = 0 * 1024, .blink_time = 334 },
-	{ .throughput = 1 * 1024, .blink_time = 260 },
-	{ .throughput = 5 * 1024, .blink_time = 220 },
-	{ .throughput = 10 * 1024, .blink_time = 190 },
-	{ .throughput = 20 * 1024, .blink_time = 170 },
-	{ .throughput = 50 * 1024, .blink_time = 150 },
-	{ .throughput = 70 * 1024, .blink_time = 130 },
-	{ .throughput = 100 * 1024, .blink_time = 110 },
-	{ .throughput = 200 * 1024, .blink_time = 80 },
-	{ .throughput = 300 * 1024, .blink_time = 50 },
+	{ .throughput = 0 * 1024, .blink_on_time = 167, .ratio = 100 },
+	{ .throughput = 1 * 1024, .blink_on_time = 130, .ratio = 100 },
+	{ .throughput = 5 * 1024, .blink_on_time = 110, .ratio = 100 },
+	{ .throughput = 10 * 1024, .blink_on_time = 95, .ratio = 100 },
+	{ .throughput = 20 * 1024, .blink_on_time = 85, .ratio = 100 },
+	{ .throughput = 50 * 1024, .blink_on_time = 75, .ratio = 100 },
+	{ .throughput = 70 * 1024, .blink_on_time = 65, .ratio = 100 },
+	{ .throughput = 100 * 1024, .blink_on_time = 55, .ratio = 100 },
+	{ .throughput = 200 * 1024, .blink_on_time = 40, .ratio = 100 },
+	{ .throughput = 300 * 1024, .blink_on_time = 25, .ratio = 100 },
 };
 #endif
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-led.c b/drivers/net/wireless/iwlegacy/iwl-led.c
index b226a3c..3ebfdae 100644
--- a/drivers/net/wireless/iwlegacy/iwl-led.c
+++ b/drivers/net/wireless/iwlegacy/iwl-led.c
@@ -62,17 +62,17 @@ MODULE_PARM_DESC(led_mode, "0=system default, "
  *	<=0					SOLID ON
  */
 static const struct ieee80211_tpt_blink iwl_blink[] = {
-	{ .throughput = 0 * 1024 - 1, .blink_time = 0 },
-	{ .throughput = 0 * 1024, .blink_time = 334 },
-	{ .throughput = 1 * 1024 - 1, .blink_time = 260 },
-	{ .throughput = 5 * 1024 - 1, .blink_time = 220 },
-	{ .throughput = 10 * 1024 - 1, .blink_time = 190 },
-	{ .throughput = 20 * 1024 - 1, .blink_time = 170 },
-	{ .throughput = 50 * 1024 - 1, .blink_time = 150 },
-	{ .throughput = 70 * 1024 - 1, .blink_time = 130 },
-	{ .throughput = 100 * 1024 - 1, .blink_time = 110 },
-	{ .throughput = 200 * 1024 - 1, .blink_time = 80 },
-	{ .throughput = 300 * 1024 - 1, .blink_time = 50 },
+	{ .throughput = 0 * 1024 - 1, .blink_on_time = IWL_LED_SOLID, .ratio = 0 },
+	{ .throughput = 0 * 1024, .blink_on_time = 167, .ratio = 100 },
+	{ .throughput = 1 * 1024 - 1, .blink_on_time = 130, .ratio = 100 },
+	{ .throughput = 5 * 1024 - 1, .blink_on_time = 110, .ratio = 100 },
+	{ .throughput = 10 * 1024 - 1, .blink_on_time = 95, .ratio = 100 },
+	{ .throughput = 20 * 1024 - 1, .blink_on_time = 85, .ratio = 100 },
+	{ .throughput = 50 * 1024 - 1, .blink_on_time = 75, .ratio = 100 },
+	{ .throughput = 70 * 1024 - 1, .blink_on_time = 65, .ratio = 100 },
+	{ .throughput = 100 * 1024 - 1, .blink_on_time = 55, .ratio = 100 },
+	{ .throughput = 200 * 1024 - 1, .blink_on_time = 40, .ratio = 100 },
+	{ .throughput = 300 * 1024 - 1, .blink_on_time = 25, .ratio = 100 },
 };
 
 /*
@@ -115,12 +115,6 @@ static int iwl_legacy_led_cmd(struct iwl_priv *priv,
 	if (priv->blink_on == on && priv->blink_off == off)
 		return 0;
 
-	if (on == 0) {
-		/* led is SOLID_ON */
-		on = IWL_LED_SOLID;
-		off = 0;
-	}
-
 	IWL_DEBUG_LED(priv, "Led blink time compensation=%u\n",
 			priv->cfg->base_params->led_compensation);
 	led_cmd.on = iwl_legacy_blink_compensation(priv, on,
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 0dde793..efbb0fe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -62,17 +62,17 @@ MODULE_PARM_DESC(led_mode, "0=system default, "
  *	<=0					SOLID ON
  */
 static const struct ieee80211_tpt_blink iwl_blink[] = {
-	{ .throughput = 0 * 1024 - 1, .blink_time = 0 },
-	{ .throughput = 0 * 1024, .blink_time = 334 },
-	{ .throughput = 1 * 1024 - 1, .blink_time = 260 },
-	{ .throughput = 5 * 1024 - 1, .blink_time = 220 },
-	{ .throughput = 10 * 1024 - 1, .blink_time = 190 },
-	{ .throughput = 20 * 1024 - 1, .blink_time = 170 },
-	{ .throughput = 50 * 1024 - 1, .blink_time = 150 },
-	{ .throughput = 70 * 1024 - 1, .blink_time = 130 },
-	{ .throughput = 100 * 1024 - 1, .blink_time = 110 },
-	{ .throughput = 200 * 1024 - 1, .blink_time = 80 },
-	{ .throughput = 300 * 1024 - 1, .blink_time = 50 },
+	{ .throughput = 0 * 1024 - 1, .blink_on_time = IWL_LED_SOLID, .ratio = 0 },
+	{ .throughput = 0 * 1024, .blink_on_time = 167, .ratio = 100 },
+	{ .throughput = 1 * 1024 - 1, .blink_on_time = 130, .ratio = 100 },
+	{ .throughput = 5 * 1024 - 1, .blink_on_time = 110, .ratio = 100 },
+	{ .throughput = 10 * 1024 - 1, .blink_on_time = 95, .ratio = 100 },
+	{ .throughput = 20 * 1024 - 1, .blink_on_time = 85, .ratio = 100 },
+	{ .throughput = 50 * 1024 - 1, .blink_on_time = 75, .ratio = 100 },
+	{ .throughput = 70 * 1024 - 1, .blink_on_time = 65, .ratio = 100 },
+	{ .throughput = 100 * 1024 - 1, .blink_on_time = 55, .ratio = 100 },
+	{ .throughput = 200 * 1024 - 1, .blink_on_time = 40, .ratio = 100 },
+	{ .throughput = 300 * 1024 - 1, .blink_on_time = 25, .ratio = 100 },
 };
 
 /* Set led register off */
@@ -139,12 +139,6 @@ static int iwl_led_cmd(struct iwl_priv *priv,
 	if (priv->blink_on == on && priv->blink_off == off)
 		return 0;
 
-	if (on == 0) {
-		/* led is SOLID_ON */
-		on = IWL_LED_SOLID;
-		off = 0;
-	}
-
 	IWL_DEBUG_LED(priv, "Led blink time compensation=%u\n",
 			priv->cfg->base_params->led_compensation);
 	led_cmd.on = iwl_blink_compensation(priv, on,
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d23dd6c..838c37c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1941,12 +1941,16 @@ int ieee80211_register_hw(struct ieee80211_hw *hw);
 /**
  * struct ieee80211_tpt_blink - throughput blink description
  * @throughput: throughput in Kbit/sec
- * @blink_time: blink time in milliseconds
- *	(full cycle, ie. one off + one on period)
+ * @blink_on_time: blink on time in milliseconds
+ * @ratio: ratio between blink on and off
+ *	ratio = 100: blink off time = blink on time
+ *	ratio = 80: blink off time = 80% of blink on time
+ *	ratio = 0: blink off time = 0% of blink on time 
  */
 struct ieee80211_tpt_blink {
 	int throughput;
-	int blink_time;
+	int blink_on_time;
+	int ratio;
 };
 
 /**
diff --git a/net/mac80211/led.c b/net/mac80211/led.c
index 1459033..474be05 100644
--- a/net/mac80211/led.c
+++ b/net/mac80211/led.c
@@ -203,8 +203,8 @@ static void tpt_trig_timer(unsigned long data)
 	for (i = tpt_trig->blink_table_len - 1; i >= 0; i--) {
 		if (tpt_trig->blink_table[i].throughput < 0 ||
 		    tpt > tpt_trig->blink_table[i].throughput) {
-			off = tpt_trig->blink_table[i].blink_time / 2;
-			on = tpt_trig->blink_table[i].blink_time - off;
+			on = tpt_trig->blink_table[i].blink_on_time;
+			off = on * tpt_trig->blink_table[i].ratio / 100;
 			break;
 		}
 	}
-- 
1.7.0.4

