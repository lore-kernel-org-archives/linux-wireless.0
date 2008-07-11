Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61394 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753548AbYGKD5H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 23:57:07 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 13/14] iwlwifi: Fix LEDs for 3945
Date: Fri, 11 Jul 2008 11:53:41 +0800
Message-Id: <1215748422-12672-14-git-send-email-yi.zhu@intel.com> (sfid-20080711_055711_953917_04C4575A)
In-Reply-To: <1215748422-12672-13-git-send-email-yi.zhu@intel.com>
References: <1215748422-12672-1-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-2-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-3-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-4-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-5-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-6-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-7-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-8-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-9-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-10-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-11-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-12-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-13-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

The patch fixes LEDs problem for 3945.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-led.c |  146 +++++++++++---------------
 drivers/net/wireless/iwlwifi/iwl-3945-led.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    1 +
 3 files changed, 64 insertions(+), 85 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.c b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
index 8b1528e..6be1fe1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
@@ -42,14 +42,11 @@
 #include "iwl-3945.h"
 #include "iwl-helpers.h"
 
-#define IWL_1MB_RATE (128 * 1024)
-#define IWL_LED_THRESHOLD (16)
-#define IWL_MAX_BLINK_TBL (10)
 
 static const struct {
 	u16 brightness;
 	u8 on_time;
-	u8 of_time;
+	u8 off_time;
 } blink_tbl[] =
 {
 	{300, 25, 25},
@@ -61,9 +58,16 @@ static const struct {
 	{15, 95, 95 },
 	{10, 110, 110},
 	{5, 130, 130},
-	{0, 167, 167}
+	{0, 167, 167},
+	/*SOLID_ON*/
+	{-1, IWL_LED_SOLID, 0}
 };
 
+#define IWL_1MB_RATE (128 * 1024)
+#define IWL_LED_THRESHOLD (16)
+#define IWL_MAX_BLINK_TBL (ARRAY_SIZE(blink_tbl) - 1) /*Exclude Solid on*/
+#define IWL_SOLID_BLINK_IDX (ARRAY_SIZE(blink_tbl) - 1)
+
 static int iwl3945_led_cmd_callback(struct iwl3945_priv *priv,
 				    struct iwl3945_cmd *cmd,
 				    struct sk_buff *skb)
@@ -71,6 +75,10 @@ static int iwl3945_led_cmd_callback(struct iwl3945_priv *priv,
 	return 1;
 }
 
+static inline int iwl3945_brightness_to_idx(enum led_brightness brightness)
+{
+	return fls(0x000000FF & (u32)brightness);
+}
 
 /* Send led command */
 static int iwl_send_led_cmd(struct iwl3945_priv *priv,
@@ -81,49 +89,45 @@ static int iwl_send_led_cmd(struct iwl3945_priv *priv,
 		.len = sizeof(struct iwl3945_led_cmd),
 		.data = led_cmd,
 		.meta.flags = CMD_ASYNC,
-		.meta.u.callback = iwl3945_led_cmd_callback
+		.meta.u.callback = iwl3945_led_cmd_callback,
 	};
 
 	return iwl3945_send_cmd(priv, &cmd);
 }
 
 
+
 /* Set led on command */
-static int iwl3945_led_on(struct iwl3945_priv *priv, int led_id)
+static int iwl3945_led_pattern(struct iwl3945_priv *priv, int led_id,
+			       unsigned int idx)
 {
 	struct iwl3945_led_cmd led_cmd = {
 		.id = led_id,
-		.on = IWL_LED_SOLID,
-		.off = 0,
 		.interval = IWL_DEF_LED_INTRVL
 	};
+
+	BUG_ON(idx > IWL_MAX_BLINK_TBL);
+
+	led_cmd.on = blink_tbl[idx].on_time;
+	led_cmd.off = blink_tbl[idx].off_time;
+
 	return iwl_send_led_cmd(priv, &led_cmd);
 }
 
+
+#if 1
 /* Set led on command */
-static int iwl3945_led_pattern(struct iwl3945_priv *priv, int led_id,
-			       enum led_brightness brightness)
+static int iwl3945_led_on(struct iwl3945_priv *priv, int led_id)
 {
 	struct iwl3945_led_cmd led_cmd = {
 		.id = led_id,
-		.on = brightness,
-		.off = brightness,
+		.on = IWL_LED_SOLID,
+		.off = 0,
 		.interval = IWL_DEF_LED_INTRVL
 	};
-	if (brightness == LED_FULL) {
-		led_cmd.on = IWL_LED_SOLID;
-		led_cmd.off = 0;
-	}
 	return iwl_send_led_cmd(priv, &led_cmd);
 }
 
-/* Set led register off */
-static int iwl3945_led_on_reg(struct iwl3945_priv *priv, int led_id)
-{
-	IWL_DEBUG_LED("led on %d\n", led_id);
-	return iwl3945_led_on(priv, led_id);
-}
-
 /* Set led off command */
 static int iwl3945_led_off(struct iwl3945_priv *priv, int led_id)
 {
@@ -136,27 +140,7 @@ static int iwl3945_led_off(struct iwl3945_priv *priv, int led_id)
 	IWL_DEBUG_LED("led off %d\n", led_id);
 	return iwl_send_led_cmd(priv, &led_cmd);
 }
-
-/* Set led register off */
-static int iwl3945_led_off_reg(struct iwl3945_priv *priv, int led_id)
-{
-	iwl3945_led_off(priv, led_id);
-	return 0;
-}
-
-/* Set led blink command */
-static int iwl3945_led_not_solid(struct iwl3945_priv *priv, int led_id,
-			       u8 brightness)
-{
-	struct iwl3945_led_cmd led_cmd = {
-		.id = led_id,
-		.on = brightness,
-		.off = brightness,
-		.interval = IWL_DEF_LED_INTRVL
-	};
-
-	return iwl_send_led_cmd(priv, &led_cmd);
-}
+#endif
 
 
 /*
@@ -206,8 +190,10 @@ static void iwl3945_led_brightness_set(struct led_classdev *led_cdev,
 			led->led_off(priv, IWL_LED_LINK);
 		break;
 	default:
-		if (led->led_pattern)
-			led->led_pattern(priv, IWL_LED_LINK, brightness);
+		if (led->led_pattern) {
+			int idx = iwl3945_brightness_to_idx(brightness);
+			led->led_pattern(priv, IWL_LED_LINK, idx);
+		}
 		break;
 	}
 }
@@ -252,24 +238,20 @@ static int iwl3945_led_register_led(struct iwl3945_priv *priv,
 static inline u8 get_blink_rate(struct iwl3945_priv *priv)
 {
 	int index;
-	u8 blink_rate;
-
-	if (priv->rxtxpackets < IWL_LED_THRESHOLD)
-		index = 10;
-	else {
-		for (index = 0; index < IWL_MAX_BLINK_TBL; index++) {
-			if (priv->rxtxpackets > (blink_tbl[index].brightness *
-						 IWL_1MB_RATE))
-				break;
-		}
-	}
-	/* if 0 frame is transfered */
-	if ((index == IWL_MAX_BLINK_TBL) || !priv->allow_blinking)
-		blink_rate = IWL_LED_SOLID;
-	else
-		blink_rate = blink_tbl[index].on_time;
+	u64 current_tpt = priv->rxtxpackets;
+	s64 tpt = current_tpt - priv->led_tpt;
 
-	return blink_rate;
+	if (tpt < 0)
+		tpt = -tpt;
+	priv->led_tpt = current_tpt;
+
+	if (!priv->allow_blinking)
+		index = IWL_MAX_BLINK_TBL;
+	else
+		for (index = 0; index < IWL_MAX_BLINK_TBL; index++)
+			if (tpt > (blink_tbl[index].brightness * IWL_1MB_RATE))
+				break;
+	return index;
 }
 
 static inline int is_rf_kill(struct iwl3945_priv *priv)
@@ -285,7 +267,7 @@ static inline int is_rf_kill(struct iwl3945_priv *priv)
  */
 void iwl3945_led_background(struct iwl3945_priv *priv)
 {
-	u8 blink_rate;
+	u8 blink_idx;
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
 		priv->last_blink_time = 0;
@@ -298,9 +280,10 @@ void iwl3945_led_background(struct iwl3945_priv *priv)
 
 	if (!priv->allow_blinking) {
 		priv->last_blink_time = 0;
-		if (priv->last_blink_rate != IWL_LED_SOLID) {
-			priv->last_blink_rate = IWL_LED_SOLID;
-			iwl3945_led_on(priv, IWL_LED_LINK);
+		if (priv->last_blink_rate != IWL_SOLID_BLINK_IDX) {
+			priv->last_blink_rate = IWL_SOLID_BLINK_IDX;
+			iwl3945_led_pattern(priv, IWL_LED_LINK,
+					    IWL_SOLID_BLINK_IDX);
 		}
 		return;
 	}
@@ -309,21 +292,14 @@ void iwl3945_led_background(struct iwl3945_priv *priv)
 			msecs_to_jiffies(1000)))
 		return;
 
-	blink_rate = get_blink_rate(priv);
+	blink_idx = get_blink_rate(priv);
 
 	/* call only if blink rate change */
-	if (blink_rate != priv->last_blink_rate) {
-		if (blink_rate != IWL_LED_SOLID) {
-			priv->last_blink_time = jiffies +
-						msecs_to_jiffies(1000);
-			iwl3945_led_not_solid(priv, IWL_LED_LINK, blink_rate);
-		} else {
-			priv->last_blink_time = 0;
-			iwl3945_led_on(priv, IWL_LED_LINK);
-		}
-	}
+	if (blink_idx != priv->last_blink_rate)
+		iwl3945_led_pattern(priv, IWL_LED_LINK, blink_idx);
 
-	priv->last_blink_rate = blink_rate;
+	priv->last_blink_time = jiffies;
+	priv->last_blink_rate = blink_idx;
 	priv->rxtxpackets = 0;
 }
 
@@ -337,6 +313,7 @@ int iwl3945_led_register(struct iwl3945_priv *priv)
 
 	priv->last_blink_rate = 0;
 	priv->rxtxpackets = 0;
+	priv->led_tpt = 0;
 	priv->last_blink_time = 0;
 	priv->allow_blinking = 0;
 
@@ -344,8 +321,8 @@ int iwl3945_led_register(struct iwl3945_priv *priv)
 	snprintf(name, sizeof(name), "iwl-%s:radio",
 		 wiphy_name(priv->hw->wiphy));
 
-	priv->led[IWL_LED_TRG_RADIO].led_on = iwl3945_led_on_reg;
-	priv->led[IWL_LED_TRG_RADIO].led_off = iwl3945_led_off_reg;
+	priv->led[IWL_LED_TRG_RADIO].led_on = iwl3945_led_on;
+	priv->led[IWL_LED_TRG_RADIO].led_off = iwl3945_led_off;
 	priv->led[IWL_LED_TRG_RADIO].led_pattern = NULL;
 
 	ret = iwl3945_led_register_led(priv,
@@ -364,8 +341,8 @@ int iwl3945_led_register(struct iwl3945_priv *priv)
 				   IWL_LED_TRG_ASSOC, 0,
 				   name, trigger);
 	/* for assoc always turn led on */
-	priv->led[IWL_LED_TRG_ASSOC].led_on = iwl3945_led_on_reg;
-	priv->led[IWL_LED_TRG_ASSOC].led_off = iwl3945_led_on_reg;
+	priv->led[IWL_LED_TRG_ASSOC].led_on = iwl3945_led_on;
+	priv->led[IWL_LED_TRG_ASSOC].led_off = iwl3945_led_on;
 	priv->led[IWL_LED_TRG_ASSOC].led_pattern = NULL;
 
 	if (ret)
@@ -391,6 +368,7 @@ int iwl3945_led_register(struct iwl3945_priv *priv)
 	trigger = ieee80211_get_tx_led_name(priv->hw);
 	snprintf(name, sizeof(name), "iwl-%s:TX",
 		 wiphy_name(priv->hw->wiphy));
+
 	ret = iwl3945_led_register_led(priv,
 				   &priv->led[IWL_LED_TRG_TX],
 				   IWL_LED_TRG_TX, 0,
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.h b/drivers/net/wireless/iwlwifi/iwl-3945-led.h
index b1d2f6b..6463e6e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.h
@@ -54,7 +54,7 @@ struct iwl3945_led {
 	int (*led_on) (struct iwl3945_priv *priv, int led_id);
 	int (*led_off) (struct iwl3945_priv *priv, int led_id);
 	int (*led_pattern) (struct iwl3945_priv *priv, int led_id,
-			    enum led_brightness brightness);
+			    int idx);
 
 	enum led_type type;
 	unsigned int registered;
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index a7ef59b..fa81ba1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -794,6 +794,7 @@ struct iwl3945_priv {
 	u8 last_blink_rate;
 	u8 allow_blinking;
 	unsigned int rxtxpackets;
+	u64 led_tpt;
 #endif
 
 
-- 
1.5.3.6

