Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:9689 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758639AbZIQRn5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2009 13:43:57 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 11/13] iwlwifi: add LED mode to support different LED behavior
Date: Thu, 17 Sep 2009 10:43:54 -0700
Message-Id: <1253209436-2309-12-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1253209436-2309-1-git-send-email-reinette.chatre@intel.com>
References: <1253209436-2309-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Today's implementation allow LED to blink based on the traffic
condition. We introduce an additional LED mode that reflects the RF
state.

The supported LED modes after this are:
  IWL_LED_BLINK (current/default) - blink rate based on current Tx/Rx
                                    traffic
  IWL_LED_RF_STATE (new) -
    LED OFF: No power/RF disabled, the LED is emitting no light
    LED ON:  Powered/RF enabled, the LED is emitting light
             in a stable non-flashing state.

In order to provide the flexibility to support different LED
behavior per user/system preference we add "led_mode" iwlcore module
parameter.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-led.c |    9 ++++++++-
 drivers/net/wireless/iwlwifi/iwl-led.h |   12 ++++++++++++
 2 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index f547233..685ba9d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -42,6 +42,12 @@
 #include "iwl-core.h"
 #include "iwl-io.h"
 
+/* default: IWL_LED_BLINK(0) using blinking index table */
+static int led_mode;
+module_param(led_mode, int, S_IRUGO);
+MODULE_PARM_DESC(led_mode, "led mode: 0=blinking, 1=On(RF On)/Off(RF Off), "
+			   "(default 0)\n");
+
 #ifdef CONFIG_IWLWIFI_DEBUG
 static const char *led_type_str[] = {
 	__stringify(IWL_LED_TRG_TX),
@@ -199,7 +205,8 @@ static int iwl_led_off_reg(struct iwl_priv *priv, int led_id)
 static int iwl_led_associate(struct iwl_priv *priv, int led_id)
 {
 	IWL_DEBUG_LED(priv, "Associated\n");
-	priv->allow_blinking = 1;
+	if (led_mode == IWL_LED_BLINK)
+		priv->allow_blinking = 1;
 	return iwl_led_on_reg(priv, led_id);
 }
 static int iwl_led_disassociate(struct iwl_priv *priv, int led_id)
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.h b/drivers/net/wireless/iwlwifi/iwl-led.h
index ef9b174..dd76b26 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.h
+++ b/drivers/net/wireless/iwlwifi/iwl-led.h
@@ -47,6 +47,18 @@ enum led_type {
 	IWL_LED_TRG_RADIO,
 	IWL_LED_TRG_MAX,
 };
+
+/*
+ * LED mode
+ *    IWL_LED_BLINK:    adjust led blink rate based on blink table
+ *    IWL_LED_RF_STATE: turn LED on/off based on RF state
+ *			LED ON  = RF ON
+ *			LED OFF = RF OFF
+ */
+enum iwl_led_mode {
+	IWL_LED_BLINK,
+	IWL_LED_RF_STATE,
+};
 #endif
 
 #ifdef CONFIG_IWLWIFI_LEDS
-- 
1.5.6.3

