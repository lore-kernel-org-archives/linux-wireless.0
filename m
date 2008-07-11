Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61401 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753598AbYGKD5J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 23:57:09 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 08/14] iwlwifi: fix LED stall
Date: Fri, 11 Jul 2008 11:53:36 +0800
Message-Id: <1215748422-12672-9-git-send-email-yi.zhu@intel.com> (sfid-20080711_061542_552422_38BD0744)
In-Reply-To: <1215748422-12672-8-git-send-email-yi.zhu@intel.com>
References: <1215748422-12672-1-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-2-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-3-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-4-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-5-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-6-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-7-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-8-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch fixes LED stall. last_blink_time was updated only if LED command
was sent, causing wrong computation of the througput.
Some code cleanup comes with this patch as well

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-led.c |   85 ++++++++++++++------------------
 drivers/net/wireless/iwlwifi/iwl-led.h |    2 +-
 3 files changed, 39 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 92a3766..bd06e0f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -933,7 +933,7 @@ struct iwl_priv {
 #endif
 
 #ifdef CONFIG_IWLWIFI_LEDS
-	struct iwl4965_led led[IWL_LED_TRG_MAX];
+	struct iwl_led led[IWL_LED_TRG_MAX];
 	unsigned long last_blink_time;
 	u8 last_blink_rate;
 	u8 allow_blinking;
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index aa6ad18..afd1075 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -48,10 +48,21 @@
 #define IWL_LED_THRESHOLD (16)
 #define IWL_MAX_BLINK_TBL (10)
 
+#ifdef CONFIG_IWLWIFI_DEBUG
+static const char *led_type_str[] = {
+	__stringify(IWL_LED_TRG_TX),
+	__stringify(IWL_LED_TRG_RX),
+	__stringify(IWL_LED_TRG_ASSOC),
+	__stringify(IWL_LED_TRG_RADIO),
+	NULL
+};
+#endif /* CONFIG_IWLWIFI_DEBUG */
+
+
 static const struct {
 	u16 tpt;
 	u8 on_time;
-	u8 of_time;
+	u8 off_time;
 } blink_tbl[] =
 {
 	{300, 25, 25},
@@ -155,21 +166,6 @@ static int iwl4965_led_off_reg(struct iwl_priv *priv, int led_id)
 	return 0;
 }
 
-/* Set led blink command */
-static int iwl4965_led_not_solid(struct iwl_priv *priv, int led_id,
-			       u8 brightness)
-{
-	struct iwl4965_led_cmd led_cmd = {
-		.id = led_id,
-		.on = brightness,
-		.off = brightness,
-		.interval = IWL_DEF_LED_INTRVL
-	};
-
-	return iwl_send_led_cmd(priv, &led_cmd);
-}
-
-
 /*
  * brightness call back function for Tx/Rx LED
  */
@@ -189,16 +185,18 @@ static int iwl4965_led_associated(struct iwl_priv *priv, int led_id)
 /*
  * brightness call back for association and radio
  */
-static void iwl4965_led_brightness_set(struct led_classdev *led_cdev,
+static void iwl_led_brightness_set(struct led_classdev *led_cdev,
 				       enum led_brightness brightness)
 {
-	struct iwl4965_led *led = container_of(led_cdev,
-					       struct iwl4965_led, led_dev);
+	struct iwl_led *led = container_of(led_cdev, struct iwl_led, led_dev);
 	struct iwl_priv *priv = led->priv;
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
+
+	IWL_DEBUG_LED("Led type = %s brightness = %d\n",
+			led_type_str[led->type], brightness);
 	switch (brightness) {
 	case LED_FULL:
 		if (led->type == IWL_LED_TRG_ASSOC)
@@ -226,8 +224,7 @@ static void iwl4965_led_brightness_set(struct led_classdev *led_cdev,
 /*
  * Register led class with the system
  */
-static int iwl_leds_register_led(struct iwl_priv *priv,
-				   struct iwl4965_led *led,
+static int iwl_leds_register_led(struct iwl_priv *priv, struct iwl_led *led,
 				   enum led_type type, u8 set_led,
 				   const char *name, char *trigger)
 {
@@ -235,7 +232,7 @@ static int iwl_leds_register_led(struct iwl_priv *priv,
 	int ret;
 
 	led->led_dev.name = name;
-	led->led_dev.brightness_set = iwl4965_led_brightness_set;
+	led->led_dev.brightness_set = iwl_led_brightness_set;
 	led->led_dev.default_trigger = trigger;
 
 	led->priv = priv;
@@ -263,12 +260,14 @@ static inline u8 get_blink_rate(struct iwl_priv *priv)
 {
 	int i;
 	u8 blink_rate;
-	u64 current_tpt = priv->tx_stats[2].bytes + priv->rx_stats[2].bytes;
+	u64 current_tpt = priv->tx_stats[2].bytes;
+	/* FIXME: + priv->rx_stats[2].bytes; */
 	s64 tpt = current_tpt - priv->led_tpt;
 
 	if (tpt < 0) /* wrapparound */
 		tpt = -tpt;
 
+	IWL_DEBUG_LED("tpt %lld current_tpt %lld\n", tpt, current_tpt);
 	priv->led_tpt = current_tpt;
 
 	if (tpt < IWL_LED_THRESHOLD) {
@@ -329,15 +328,13 @@ void iwl_leds_background(struct iwl_priv *priv)
 	/* call only if blink rate change */
 	if (blink_rate != priv->last_blink_rate) {
 		if (blink_rate != IWL_LED_SOLID) {
-			priv->last_blink_time = jiffies +
-						msecs_to_jiffies(1000);
-			iwl4965_led_not_solid(priv, IWL_LED_LINK, blink_rate);
+			iwl4965_led_pattern(priv, IWL_LED_LINK, blink_rate);
 		} else {
-			priv->last_blink_time = 0;
 			iwl4965_led_on(priv, IWL_LED_LINK);
 		}
 	}
 
+	priv->last_blink_time = jiffies;
 	priv->last_blink_rate = blink_rate;
 }
 EXPORT_SYMBOL(iwl_leds_background);
@@ -362,10 +359,8 @@ int iwl_leds_register(struct iwl_priv *priv)
 	priv->led[IWL_LED_TRG_RADIO].led_off = iwl4965_led_off_reg;
 	priv->led[IWL_LED_TRG_RADIO].led_pattern = NULL;
 
-	ret = iwl_leds_register_led(priv,
-				   &priv->led[IWL_LED_TRG_RADIO],
-				   IWL_LED_TRG_RADIO, 1,
-				   name, trigger);
+	ret = iwl_leds_register_led(priv, &priv->led[IWL_LED_TRG_RADIO],
+				   IWL_LED_TRG_RADIO, 1, name, trigger);
 	if (ret)
 		goto exit_fail;
 
@@ -373,10 +368,9 @@ int iwl_leds_register(struct iwl_priv *priv)
 	snprintf(name, sizeof(name), "iwl-%s:assoc",
 		 wiphy_name(priv->hw->wiphy));
 
-	ret = iwl_leds_register_led(priv,
-				   &priv->led[IWL_LED_TRG_ASSOC],
-				   IWL_LED_TRG_ASSOC, 0,
-				   name, trigger);
+	ret = iwl_leds_register_led(priv, &priv->led[IWL_LED_TRG_ASSOC],
+				   IWL_LED_TRG_ASSOC, 0, name, trigger);
+
 	/* for assoc always turn led on */
 	priv->led[IWL_LED_TRG_ASSOC].led_on = iwl4965_led_on_reg;
 	priv->led[IWL_LED_TRG_ASSOC].led_off = iwl4965_led_on_reg;
@@ -386,14 +380,11 @@ int iwl_leds_register(struct iwl_priv *priv)
 		goto exit_fail;
 
 	trigger = ieee80211_get_rx_led_name(priv->hw);
-	snprintf(name, sizeof(name), "iwl-%s:RX",
-		 wiphy_name(priv->hw->wiphy));
+	snprintf(name, sizeof(name), "iwl-%s:RX", wiphy_name(priv->hw->wiphy));
 
 
-	ret = iwl_leds_register_led(priv,
-				   &priv->led[IWL_LED_TRG_RX],
-				   IWL_LED_TRG_RX, 0,
-				   name, trigger);
+	ret = iwl_leds_register_led(priv, &priv->led[IWL_LED_TRG_RX],
+				   IWL_LED_TRG_RX, 0, name, trigger);
 
 	priv->led[IWL_LED_TRG_RX].led_on = iwl4965_led_associated;
 	priv->led[IWL_LED_TRG_RX].led_off = iwl4965_led_associated;
@@ -403,12 +394,10 @@ int iwl_leds_register(struct iwl_priv *priv)
 		goto exit_fail;
 
 	trigger = ieee80211_get_tx_led_name(priv->hw);
-	snprintf(name, sizeof(name), "iwl-%s:TX",
-		 wiphy_name(priv->hw->wiphy));
-	ret = iwl_leds_register_led(priv,
-				   &priv->led[IWL_LED_TRG_TX],
-				   IWL_LED_TRG_TX, 0,
-				   name, trigger);
+	snprintf(name, sizeof(name), "iwl-%s:TX", wiphy_name(priv->hw->wiphy));
+	ret = iwl_leds_register_led(priv, &priv->led[IWL_LED_TRG_TX],
+				   IWL_LED_TRG_TX, 0, name, trigger);
+
 	priv->led[IWL_LED_TRG_TX].led_on = iwl4965_led_associated;
 	priv->led[IWL_LED_TRG_TX].led_off = iwl4965_led_associated;
 	priv->led[IWL_LED_TRG_TX].led_pattern = iwl4965_led_pattern;
@@ -425,7 +414,7 @@ exit_fail:
 EXPORT_SYMBOL(iwl_leds_register);
 
 /* unregister led class */
-static void iwl_leds_unregister_led(struct iwl4965_led *led, u8 set_led)
+static void iwl_leds_unregister_led(struct iwl_led *led, u8 set_led)
 {
 	if (!led->registered)
 		return;
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.h b/drivers/net/wireless/iwlwifi/iwl-led.h
index 5bb0412..c9466d5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.h
+++ b/drivers/net/wireless/iwlwifi/iwl-led.h
@@ -49,7 +49,7 @@ enum led_type {
 };
 
 
-struct iwl4965_led {
+struct iwl_led {
 	struct iwl_priv *priv;
 	struct led_classdev led_dev;
 
-- 
1.5.3.6

