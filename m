Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:47318 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964876AbZGQQaa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 12:30:30 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 04/14] iwlwifi: make led functions generic
Date: Fri, 17 Jul 2009 09:30:17 -0700
Message-Id: <1247848227-24031-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1247848227-24031-4-git-send-email-reinette.chatre@intel.com>
References: <1247848227-24031-1-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-2-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-3-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Led functions are generic for all the devices except 3945, so remove the
reference to 4965

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-led.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 5e64252..36d88a0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -104,7 +104,7 @@ static int iwl_send_led_cmd(struct iwl_priv *priv, struct iwl_led_cmd *led_cmd)
 }
 
 /* Set led pattern command */
-static int iwl4965_led_pattern(struct iwl_priv *priv, int led_id,
+static int iwl_led_pattern(struct iwl_priv *priv, int led_id,
 			       unsigned int idx)
 {
 	struct iwl_led_cmd led_cmd = {
@@ -121,7 +121,7 @@ static int iwl4965_led_pattern(struct iwl_priv *priv, int led_id,
 }
 
 /* Set led register off */
-static int iwl4965_led_on_reg(struct iwl_priv *priv, int led_id)
+static int iwl_led_on_reg(struct iwl_priv *priv, int led_id)
 {
 	IWL_DEBUG_LED(priv, "led on %d\n", led_id);
 	iwl_write32(priv, CSR_LED_REG, CSR_LED_REG_TRUN_ON);
@@ -130,7 +130,7 @@ static int iwl4965_led_on_reg(struct iwl_priv *priv, int led_id)
 
 #if 0
 /* Set led on command */
-static int iwl4965_led_on(struct iwl_priv *priv, int led_id)
+static int iwl_led_on(struct iwl_priv *priv, int led_id)
 {
 	struct iwl_led_cmd led_cmd = {
 		.id = led_id,
@@ -142,7 +142,7 @@ static int iwl4965_led_on(struct iwl_priv *priv, int led_id)
 }
 
 /* Set led off command */
-int iwl4965_led_off(struct iwl_priv *priv, int led_id)
+int iwl_led_off(struct iwl_priv *priv, int led_id)
 {
 	struct iwl_led_cmd led_cmd = {
 		.id = led_id,
@@ -157,7 +157,7 @@ int iwl4965_led_off(struct iwl_priv *priv, int led_id)
 
 
 /* Set led register off */
-static int iwl4965_led_off_reg(struct iwl_priv *priv, int led_id)
+static int iwl_led_off_reg(struct iwl_priv *priv, int led_id)
 {
 	IWL_DEBUG_LED(priv, "LED Reg off\n");
 	iwl_write32(priv, CSR_LED_REG, CSR_LED_REG_TRUN_OFF);
@@ -171,7 +171,7 @@ static int iwl_led_associate(struct iwl_priv *priv, int led_id)
 {
 	IWL_DEBUG_LED(priv, "Associated\n");
 	priv->allow_blinking = 1;
-	return iwl4965_led_on_reg(priv, led_id);
+	return iwl_led_on_reg(priv, led_id);
 }
 static int iwl_led_disassociate(struct iwl_priv *priv, int led_id)
 {
@@ -314,7 +314,7 @@ void iwl_leds_background(struct iwl_priv *priv)
 		priv->last_blink_time = 0;
 		if (priv->last_blink_rate != IWL_SOLID_BLINK_IDX) {
 			priv->last_blink_rate = IWL_SOLID_BLINK_IDX;
-			iwl4965_led_pattern(priv, IWL_LED_LINK,
+			iwl_led_pattern(priv, IWL_LED_LINK,
 					    IWL_SOLID_BLINK_IDX);
 		}
 		return;
@@ -328,7 +328,7 @@ void iwl_leds_background(struct iwl_priv *priv)
 
 	/* call only if blink rate change */
 	if (blink_idx != priv->last_blink_rate)
-		iwl4965_led_pattern(priv, IWL_LED_LINK, blink_idx);
+		iwl_led_pattern(priv, IWL_LED_LINK, blink_idx);
 
 	priv->last_blink_time = jiffies;
 	priv->last_blink_rate = blink_idx;
@@ -351,8 +351,8 @@ int iwl_leds_register(struct iwl_priv *priv)
 		 sizeof(priv->led[IWL_LED_TRG_RADIO].name), "iwl-%s::radio",
 		 wiphy_name(priv->hw->wiphy));
 
-	priv->led[IWL_LED_TRG_RADIO].led_on = iwl4965_led_on_reg;
-	priv->led[IWL_LED_TRG_RADIO].led_off = iwl4965_led_off_reg;
+	priv->led[IWL_LED_TRG_RADIO].led_on = iwl_led_on_reg;
+	priv->led[IWL_LED_TRG_RADIO].led_off = iwl_led_off_reg;
 	priv->led[IWL_LED_TRG_RADIO].led_pattern = NULL;
 
 	ret = iwl_leds_register_led(priv, &priv->led[IWL_LED_TRG_RADIO],
@@ -386,7 +386,7 @@ int iwl_leds_register(struct iwl_priv *priv)
 
 	priv->led[IWL_LED_TRG_RX].led_on = iwl_led_associated;
 	priv->led[IWL_LED_TRG_RX].led_off = iwl_led_associated;
-	priv->led[IWL_LED_TRG_RX].led_pattern = iwl4965_led_pattern;
+	priv->led[IWL_LED_TRG_RX].led_pattern = iwl_led_pattern;
 
 	if (ret)
 		goto exit_fail;
@@ -401,7 +401,7 @@ int iwl_leds_register(struct iwl_priv *priv)
 
 	priv->led[IWL_LED_TRG_TX].led_on = iwl_led_associated;
 	priv->led[IWL_LED_TRG_TX].led_off = iwl_led_associated;
-	priv->led[IWL_LED_TRG_TX].led_pattern = iwl4965_led_pattern;
+	priv->led[IWL_LED_TRG_TX].led_pattern = iwl_led_pattern;
 
 	if (ret)
 		goto exit_fail;
-- 
1.5.6.3

