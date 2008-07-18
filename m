Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:13137 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074AbYGRF4e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 01:56:34 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Esti Kummer <ester.kummer@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 11/13] iwlwifi: set led register in disassociation
Date: Fri, 18 Jul 2008 13:53:07 +0800
Message-Id: <1216360389-5352-12-git-send-email-yi.zhu@intel.com> (sfid-20080718_081543_262845_6D33D64A)
In-Reply-To: <1216360389-5352-11-git-send-email-yi.zhu@intel.com>
References: <1216360389-5352-1-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-2-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-3-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-4-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-5-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-6-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-7-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-8-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-9-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-10-git-send-email-yi.zhu@intel.com>
 <1216360389-5352-11-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Esti Kummer <ester.kummer@intel.com>

This patch sets the led register in disassociation flow according to
rf-kill state : off - in case of rf_kill, on - otherwise.

Signed-off-by: Esti Kummer <ester.kummer@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-led.c |   40 +++++++++++++++++++------------
 1 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 899d7a2..311be39 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -161,12 +161,32 @@ int iwl4965_led_off(struct iwl_priv *priv, int led_id)
 /* Set led register off */
 static int iwl4965_led_off_reg(struct iwl_priv *priv, int led_id)
 {
-	IWL_DEBUG_LED("radio off\n");
+	IWL_DEBUG_LED("LED Reg off\n");
 	iwl_write32(priv, CSR_LED_REG, CSR_LED_REG_TRUN_OFF);
 	return 0;
 }
 
 /*
+ * Set led register in case of disassociation according to rfkill state
+ */
+static int iwl_led_associate(struct iwl_priv *priv, int led_id)
+{
+	IWL_DEBUG_LED("Associated\n");
+	priv->allow_blinking = 1;
+	return iwl4965_led_on_reg(priv, led_id);
+}
+static int iwl_led_disassociate(struct iwl_priv *priv, int led_id)
+{
+	priv->allow_blinking = 0;
+	if (iwl_is_rfkill(priv))
+		iwl4965_led_off_reg(priv, led_id);
+	else
+		iwl4965_led_on_reg(priv, led_id);
+
+	return 0;
+}
+
+/*
  * brightness call back function for Tx/Rx LED
  */
 static int iwl_led_associated(struct iwl_priv *priv, int led_id)
@@ -199,16 +219,10 @@ static void iwl_led_brightness_set(struct led_classdev *led_cdev,
 			led_type_str[led->type], brightness);
 	switch (brightness) {
 	case LED_FULL:
-		if (led->type == IWL_LED_TRG_ASSOC)
-			priv->allow_blinking = 1;
-
 		if (led->led_on)
 			led->led_on(priv, IWL_LED_LINK);
 		break;
 	case LED_OFF:
-		if (led->type == IWL_LED_TRG_ASSOC)
-			priv->allow_blinking = 0;
-
 		if (led->led_off)
 			led->led_off(priv, IWL_LED_LINK);
 		break;
@@ -282,12 +296,6 @@ static int iwl_get_blink_rate(struct iwl_priv *priv)
 	return i;
 }
 
-static inline int is_rf_kill(struct iwl_priv *priv)
-{
-	return test_bit(STATUS_RF_KILL_HW, &priv->status) ||
-		test_bit(STATUS_RF_KILL_SW, &priv->status);
-}
-
 /*
  * this function called from handler. Since setting Led command can
  * happen very frequent we postpone led command to be called from
@@ -301,7 +309,7 @@ void iwl_leds_background(struct iwl_priv *priv)
 		priv->last_blink_time = 0;
 		return;
 	}
-	if (is_rf_kill(priv)) {
+	if (iwl_is_rfkill(priv)) {
 		priv->last_blink_time = 0;
 		return;
 	}
@@ -364,8 +372,8 @@ int iwl_leds_register(struct iwl_priv *priv)
 				   IWL_LED_TRG_ASSOC, 0, name, trigger);
 
 	/* for assoc always turn led on */
-	priv->led[IWL_LED_TRG_ASSOC].led_on = iwl4965_led_on_reg;
-	priv->led[IWL_LED_TRG_ASSOC].led_off = iwl4965_led_on_reg;
+	priv->led[IWL_LED_TRG_ASSOC].led_on = iwl_led_associate;
+	priv->led[IWL_LED_TRG_ASSOC].led_off = iwl_led_disassociate;
 	priv->led[IWL_LED_TRG_ASSOC].led_pattern = NULL;
 
 	if (ret)
-- 
1.5.3.6

