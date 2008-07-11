Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61404 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689AbYGKD5J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 23:57:09 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 09/14] iwlwifi: LED use correctly blink table
Date: Fri, 11 Jul 2008 11:53:37 +0800
Message-Id: <1215748422-12672-10-git-send-email-yi.zhu@intel.com> (sfid-20080711_061545_310390_35F40838)
In-Reply-To: <1215748422-12672-9-git-send-email-yi.zhu@intel.com>
References: <1215748422-12672-1-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-2-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-3-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-4-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-5-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-6-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-7-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-8-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-9-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch makes correct usage of the LED blink table.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-led.c      |  125 ++++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl-led.h      |    3 +-
 4 files changed, 61 insertions(+), 71 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 92754ee..3e96df8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2926,7 +2926,7 @@ struct iwl5000_calibration_chain_noise_gain_cmd {
  * For each of 3 possible LEDs (Activity/Link/Tech, selected by "id" field),
  * this command turns it on or off, or sets up a periodic blinking cycle.
  */
-struct iwl4965_led_cmd {
+struct iwl_led_cmd {
 	__le32 interval;	/* "interval" in uSec */
 	u8 id;			/* 1: Activity, 2: Link, 3: Tech */
 	u8 off;			/* # intervals off while blinking;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index bd06e0f..84a3ecf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -282,7 +282,7 @@ struct iwl_cmd {
 	struct iwl_cmd_header hdr;	/* uCode API */
 	union {
 		struct iwl_addsta_cmd addsta;
-		struct iwl4965_led_cmd led;
+		struct iwl_led_cmd led;
 		u32 flags;
 		u8 val8;
 		u16 val16;
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index afd1075..0c09b90 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -44,10 +44,6 @@
 #include "iwl-io.h"
 #include "iwl-helpers.h"
 
-#define IWL_1MB_RATE (128 * 1024)
-#define IWL_LED_THRESHOLD (16)
-#define IWL_MAX_BLINK_TBL (10)
-
 #ifdef CONFIG_IWLWIFI_DEBUG
 static const char *led_type_str[] = {
 	__stringify(IWL_LED_TRG_TX),
@@ -74,26 +70,31 @@ static const struct {
 	{15, 95, 95 },
 	{10, 110, 110},
 	{5, 130, 130},
-	{0, 167, 167}
+	{0, 167, 167},
+/* SOLID_ON */
+	{-1, IWL_LED_SOLID, 0}
 };
 
-static int iwl_led_cmd_callback(struct iwl_priv *priv,
-				struct iwl_cmd *cmd, struct sk_buff *skb)
+#define IWL_1MB_RATE (128 * 1024)
+#define IWL_LED_THRESHOLD (16)
+#define IWL_MAX_BLINK_TBL (ARRAY_SIZE(blink_tbl) - 1) /* exclude SOLID_ON */
+#define IWL_SOLID_BLINK_IDX (ARRAY_SIZE(blink_tbl) - 1)
+
+/*  [0-256] -> [0..8] FIXME: we need [0..10] */
+static inline int iwl_brightness_to_idx(enum led_brightness brightness)
 {
-	return 1;
+	return fls(0x000000FF & (u32)brightness);
 }
 
-
 /* Send led command */
-static int iwl_send_led_cmd(struct iwl_priv *priv,
-			    struct iwl4965_led_cmd *led_cmd)
+static int iwl_send_led_cmd(struct iwl_priv *priv, struct iwl_led_cmd *led_cmd)
 {
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_LEDS_CMD,
-		.len = sizeof(struct iwl4965_led_cmd),
+		.len = sizeof(struct iwl_led_cmd),
 		.data = led_cmd,
 		.meta.flags = CMD_ASYNC,
-		.meta.u.callback = iwl_led_cmd_callback
+		.meta.u.callback = NULL,
 	};
 	u32 reg;
 
@@ -104,33 +105,19 @@ static int iwl_send_led_cmd(struct iwl_priv *priv,
 	return iwl_send_cmd(priv, &cmd);
 }
 
-
-/* Set led on command */
-static int iwl4965_led_on(struct iwl_priv *priv, int led_id)
+/* Set led pattern command */
+static int iwl4965_led_pattern(struct iwl_priv *priv, int led_id, int idx)
 {
-	struct iwl4965_led_cmd led_cmd = {
+	struct iwl_led_cmd led_cmd = {
 		.id = led_id,
-		.on = IWL_LED_SOLID,
-		.off = 0,
 		.interval = IWL_DEF_LED_INTRVL
 	};
-	return iwl_send_led_cmd(priv, &led_cmd);
-}
 
-/* Set led on command */
-static int iwl4965_led_pattern(struct iwl_priv *priv, int led_id,
-			       enum led_brightness brightness)
-{
-	struct iwl4965_led_cmd led_cmd = {
-		.id = led_id,
-		.on = brightness,
-		.off = brightness,
-		.interval = IWL_DEF_LED_INTRVL
-	};
-	if (brightness == LED_FULL) {
-		led_cmd.on = IWL_LED_SOLID;
-		led_cmd.off = 0;
-	}
+	BUG_ON(idx > IWL_MAX_BLINK_TBL);
+
+	led_cmd.on = blink_tbl[idx].on_time;
+	led_cmd.off = blink_tbl[idx].off_time;
+
 	return iwl_send_led_cmd(priv, &led_cmd);
 }
 
@@ -143,10 +130,22 @@ static int iwl4965_led_on_reg(struct iwl_priv *priv, int led_id)
 }
 
 #if 0
+/* Set led on command */
+static int iwl4965_led_on(struct iwl_priv *priv, int led_id)
+{
+	struct iwl_led_cmd led_cmd = {
+		.id = led_id,
+		.on = IWL_LED_SOLID,
+		.off = 0,
+		.interval = IWL_DEF_LED_INTRVL
+	};
+	return iwl_send_led_cmd(priv, &led_cmd);
+}
+
 /* Set led off command */
 int iwl4965_led_off(struct iwl_priv *priv, int led_id)
 {
-	struct iwl4965_led_cmd led_cmd = {
+	struct iwl_led_cmd led_cmd = {
 		.id = led_id,
 		.on = 0,
 		.off = 0,
@@ -169,7 +168,7 @@ static int iwl4965_led_off_reg(struct iwl_priv *priv, int led_id)
 /*
  * brightness call back function for Tx/Rx LED
  */
-static int iwl4965_led_associated(struct iwl_priv *priv, int led_id)
+static int iwl_led_associated(struct iwl_priv *priv, int led_id)
 {
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status) ||
 	    !test_bit(STATUS_READY, &priv->status))
@@ -213,8 +212,10 @@ static void iwl_led_brightness_set(struct led_classdev *led_cdev,
 			led->led_off(priv, IWL_LED_LINK);
 		break;
 	default:
-		if (led->led_pattern)
-			led->led_pattern(priv, IWL_LED_LINK, brightness);
+		if (led->led_pattern) {
+			int idx = iwl_brightness_to_idx(brightness);
+			led->led_pattern(priv, IWL_LED_LINK, idx);
+		}
 		break;
 	}
 }
@@ -256,10 +257,9 @@ static int iwl_leds_register_led(struct iwl_priv *priv, struct iwl_led *led,
 /*
  * calculate blink rate according to last 2 sec Tx/Rx activities
  */
-static inline u8 get_blink_rate(struct iwl_priv *priv)
+static int iwl_get_blink_rate(struct iwl_priv *priv)
 {
 	int i;
-	u8 blink_rate;
 	u64 current_tpt = priv->tx_stats[2].bytes;
 	/* FIXME: + priv->rx_stats[2].bytes; */
 	s64 tpt = current_tpt - priv->led_tpt;
@@ -270,20 +270,15 @@ static inline u8 get_blink_rate(struct iwl_priv *priv)
 	IWL_DEBUG_LED("tpt %lld current_tpt %lld\n", tpt, current_tpt);
 	priv->led_tpt = current_tpt;
 
-	if (tpt < IWL_LED_THRESHOLD) {
+	if (!priv->allow_blinking)
 		i = IWL_MAX_BLINK_TBL;
-	} else {
+	else
 		for (i = 0; i < IWL_MAX_BLINK_TBL; i++)
 			if (tpt  > (blink_tbl[i].tpt * IWL_1MB_RATE))
 				break;
-	}
-	/* if 0 frame is transfered */
-	if ((i == IWL_MAX_BLINK_TBL) || !priv->allow_blinking)
-		blink_rate = IWL_LED_SOLID;
-	else
-		blink_rate = blink_tbl[i].on_time;
 
-	return blink_rate;
+	IWL_DEBUG_LED("LED BLINK IDX=%d", i);
+	return i;
 }
 
 static inline int is_rf_kill(struct iwl_priv *priv)
@@ -299,7 +294,7 @@ static inline int is_rf_kill(struct iwl_priv *priv)
  */
 void iwl_leds_background(struct iwl_priv *priv)
 {
-	u8 blink_rate;
+	u8 blink_idx;
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
 		priv->last_blink_time = 0;
@@ -312,9 +307,10 @@ void iwl_leds_background(struct iwl_priv *priv)
 
 	if (!priv->allow_blinking) {
 		priv->last_blink_time = 0;
-		if (priv->last_blink_rate != IWL_LED_SOLID) {
-			priv->last_blink_rate = IWL_LED_SOLID;
-			iwl4965_led_on(priv, IWL_LED_LINK);
+		if (priv->last_blink_rate != IWL_SOLID_BLINK_IDX) {
+			priv->last_blink_rate = IWL_SOLID_BLINK_IDX;
+			iwl4965_led_pattern(priv, IWL_LED_LINK,
+					    IWL_SOLID_BLINK_IDX);
 		}
 		return;
 	}
@@ -323,19 +319,14 @@ void iwl_leds_background(struct iwl_priv *priv)
 			msecs_to_jiffies(1000)))
 		return;
 
-	blink_rate = get_blink_rate(priv);
+	blink_idx = iwl_get_blink_rate(priv);
 
 	/* call only if blink rate change */
-	if (blink_rate != priv->last_blink_rate) {
-		if (blink_rate != IWL_LED_SOLID) {
-			iwl4965_led_pattern(priv, IWL_LED_LINK, blink_rate);
-		} else {
-			iwl4965_led_on(priv, IWL_LED_LINK);
-		}
-	}
+	if (blink_idx != priv->last_blink_rate)
+		iwl4965_led_pattern(priv, IWL_LED_LINK, blink_idx);
 
 	priv->last_blink_time = jiffies;
-	priv->last_blink_rate = blink_rate;
+	priv->last_blink_rate = blink_idx;
 }
 EXPORT_SYMBOL(iwl_leds_background);
 
@@ -386,8 +377,8 @@ int iwl_leds_register(struct iwl_priv *priv)
 	ret = iwl_leds_register_led(priv, &priv->led[IWL_LED_TRG_RX],
 				   IWL_LED_TRG_RX, 0, name, trigger);
 
-	priv->led[IWL_LED_TRG_RX].led_on = iwl4965_led_associated;
-	priv->led[IWL_LED_TRG_RX].led_off = iwl4965_led_associated;
+	priv->led[IWL_LED_TRG_RX].led_on = iwl_led_associated;
+	priv->led[IWL_LED_TRG_RX].led_off = iwl_led_associated;
 	priv->led[IWL_LED_TRG_RX].led_pattern = iwl4965_led_pattern;
 
 	if (ret)
@@ -398,8 +389,8 @@ int iwl_leds_register(struct iwl_priv *priv)
 	ret = iwl_leds_register_led(priv, &priv->led[IWL_LED_TRG_TX],
 				   IWL_LED_TRG_TX, 0, name, trigger);
 
-	priv->led[IWL_LED_TRG_TX].led_on = iwl4965_led_associated;
-	priv->led[IWL_LED_TRG_TX].led_off = iwl4965_led_associated;
+	priv->led[IWL_LED_TRG_TX].led_on = iwl_led_associated;
+	priv->led[IWL_LED_TRG_TX].led_off = iwl_led_associated;
 	priv->led[IWL_LED_TRG_TX].led_pattern = iwl4965_led_pattern;
 
 	if (ret)
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.h b/drivers/net/wireless/iwlwifi/iwl-led.h
index c9466d5..05e6a61 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.h
+++ b/drivers/net/wireless/iwlwifi/iwl-led.h
@@ -55,8 +55,7 @@ struct iwl_led {
 
 	int (*led_on) (struct iwl_priv *priv, int led_id);
 	int (*led_off) (struct iwl_priv *priv, int led_id);
-	int (*led_pattern) (struct iwl_priv *priv, int led_id,
-			    enum led_brightness brightness);
+	int (*led_pattern) (struct iwl_priv *priv, int led_id, int idx);
 
 	enum led_type type;
 	unsigned int registered;
-- 
1.5.3.6

