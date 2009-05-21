Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:22322 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754597AbZEUUhx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 16:37:53 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/3] iwl3945: improve 3945 leds
Date: Thu, 21 May 2009 13:44:21 -0700
Message-Id: <1242938663-7937-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1242938663-7937-1-git-send-email-reinette.chatre@intel.com>
References: <1242938663-7937-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

'tpt' is a delta throughput (number of packets) and is corelated
to brightness of the LED. We already maintain a delta of packets in
rxtxpackets. There is no need to calculate this delta again which
was affecting the behaviour of LEDS.

Also add two new callback functions for ASSOCIATED/DISASSOCIATED states
where LED's will be *on* for associated state and *off* for disassociated state.

This fixes
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1771.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-led.c |   70 +++++++++++++++++---------
 1 files changed, 46 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.c b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
index ac22f59..bd7e520 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
@@ -44,6 +44,15 @@
 #include "iwl-core.h"
 #include "iwl-dev.h"
 
+#ifdef CONFIG_IWLWIFI_DEBUG
+static const char *led_type_str[] = {
+	__stringify(IWL_LED_TRG_TX),
+	__stringify(IWL_LED_TRG_RX),
+	__stringify(IWL_LED_TRG_ASSOC),
+	__stringify(IWL_LED_TRG_RADIO),
+	NULL
+};
+#endif /* CONFIG_IWLWIFI_DEBUG */
 
 static const struct {
 	u16 brightness;
@@ -61,7 +70,7 @@ static const struct {
 	{10, 110, 110},
 	{5, 130, 130},
 	{0, 167, 167},
-	/*SOLID_ON*/
+	/* SOLID_ON */
 	{-1, IWL_LED_SOLID, 0}
 };
 
@@ -143,6 +152,30 @@ static int iwl3945_led_off(struct iwl_priv *priv, int led_id)
 }
 
 /*
+ *  Set led on in case of association
+ *  */
+static int iwl3945_led_associate(struct iwl_priv *priv, int led_id)
+{
+	IWL_DEBUG_LED(priv, "Associated\n");
+
+	priv->allow_blinking = 1;
+	return iwl3945_led_on(priv, led_id);
+}
+/* Set Led off in case of disassociation */
+static int iwl3945_led_disassociate(struct iwl_priv *priv, int led_id)
+{
+	IWL_DEBUG_LED(priv, "Disassociated\n");
+
+	priv->allow_blinking = 0;
+	if (iwl_is_rfkill(priv))
+		iwl3945_led_off(priv, led_id);
+	else
+		iwl3945_led_on(priv, led_id);
+
+	return 0;
+}
+
+/*
  * brightness call back function for Tx/Rx LED
  */
 static int iwl3945_led_associated(struct iwl_priv *priv, int led_id)
@@ -165,26 +198,21 @@ static void iwl3945_led_brightness_set(struct led_classdev *led_cdev,
 				enum led_brightness brightness)
 {
 	struct iwl_led *led = container_of(led_cdev,
-					       struct iwl_led, led_dev);
+					   struct iwl_led, led_dev);
 	struct iwl_priv *priv = led->priv;
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
+	IWL_DEBUG_LED(priv, "Led type = %s brightness = %d\n",
+			led_type_str[led->type], brightness);
+
 	switch (brightness) {
 	case LED_FULL:
-		if (led->type == IWL_LED_TRG_ASSOC) {
-			priv->allow_blinking = 1;
-			IWL_DEBUG_LED(priv, "MAC is  associated\n");
-		}
 		if (led->led_on)
 			led->led_on(priv, IWL_LED_LINK);
 		break;
 	case LED_OFF:
-		if (led->type == IWL_LED_TRG_ASSOC) {
-			priv->allow_blinking = 0;
-			IWL_DEBUG_LED(priv, "MAC is disassociated\n");
-		}
 		if (led->led_off)
 			led->led_off(priv, IWL_LED_LINK);
 		break;
@@ -197,8 +225,6 @@ static void iwl3945_led_brightness_set(struct led_classdev *led_cdev,
 	}
 }
 
-
-
 /*
  * Register led class with the system
  */
@@ -237,12 +263,12 @@ static int iwl3945_led_register_led(struct iwl_priv *priv,
 static inline u8 get_blink_rate(struct iwl_priv *priv)
 {
 	int index;
-	u64 current_tpt = priv->rxtxpackets;
-	s64 tpt = current_tpt - priv->led_tpt;
+	s64 tpt = priv->rxtxpackets;
 
 	if (tpt < 0)
 		tpt = -tpt;
-	priv->led_tpt = current_tpt;
+
+	IWL_DEBUG_LED(priv, "tpt %lld \n", (long long)tpt);
 
 	if (!priv->allow_blinking)
 		index = IWL_MAX_BLINK_TBL;
@@ -250,13 +276,9 @@ static inline u8 get_blink_rate(struct iwl_priv *priv)
 		for (index = 0; index < IWL_MAX_BLINK_TBL; index++)
 			if (tpt > (blink_tbl[index].brightness * IWL_1MB_RATE))
 				break;
-	return index;
-}
 
-static inline int is_rf_kill(struct iwl_priv *priv)
-{
-	return test_bit(STATUS_RF_KILL_HW, &priv->status) ||
-		test_bit(STATUS_RF_KILL_SW, &priv->status);
+	IWL_DEBUG_LED(priv, "LED BLINK IDX=%d\n", index);
+	return index;
 }
 
 /*
@@ -272,7 +294,7 @@ void iwl3945_led_background(struct iwl_priv *priv)
 		priv->last_blink_time = 0;
 		return;
 	}
-	if (is_rf_kill(priv)) {
+	if (iwl_is_rfkill(priv)) {
 		priv->last_blink_time = 0;
 		return;
 	}
@@ -341,8 +363,8 @@ int iwl3945_led_register(struct iwl_priv *priv)
 				   IWL_LED_TRG_ASSOC, 0, trigger);
 
 	/* for assoc always turn led on */
-	priv->led[IWL_LED_TRG_ASSOC].led_on = iwl3945_led_on;
-	priv->led[IWL_LED_TRG_ASSOC].led_off = iwl3945_led_on;
+	priv->led[IWL_LED_TRG_ASSOC].led_on = iwl3945_led_associate;
+	priv->led[IWL_LED_TRG_ASSOC].led_off = iwl3945_led_disassociate;
 	priv->led[IWL_LED_TRG_ASSOC].led_pattern = NULL;
 
 	if (ret)
-- 
1.5.6.3

