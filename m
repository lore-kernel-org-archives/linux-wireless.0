Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:62539 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133Ab2A1Rhe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jan 2012 12:37:34 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3/4] iwlwifi: add option to disalbe LED
Date: Sat, 28 Jan 2012 08:30:51 -0800
Message-Id: <1327768252-22742-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120128_183739_700723_4DAE083A)
In-Reply-To: <1327768252-22742-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1327768252-22742-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Led has no use for some platform.
Add additional module parameter option to disable LED

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-led.c    |    4 ++++
 drivers/net/wireless/iwlwifi/iwl-shared.h |    2 ++
 3 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 3e429a3..90315c6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2097,7 +2097,7 @@ MODULE_PARM_DESC(bt_coex_active, "enable wifi/bt co-exist (default: enable)");
 
 module_param_named(led_mode, iwlagn_mod_params.led_mode, int, S_IRUGO);
 MODULE_PARM_DESC(led_mode, "0=system default, "
-		"1=On(RF On)/Off(RF Off), 2=blinking (default: 0)");
+		"1=On(RF On)/Off(RF Off), 2=blinking, 3=Off (default: 0)");
 
 module_param_named(power_save, iwlagn_mod_params.power_save,
 		bool, S_IRUGO);
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index eca7908..8761438 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -177,6 +177,10 @@ void iwl_leds_init(struct iwl_priv *priv)
 	int mode = iwlagn_mod_params.led_mode;
 	int ret;
 
+	if (mode == IWL_LED_DISABLE) {
+		IWL_INFO(priv, "Led disabled\n");
+		return;
+	}
 	if (mode == IWL_LED_DEFAULT)
 		mode = cfg(priv)->led_mode;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index e406d49..04975b7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -264,11 +264,13 @@ enum iwl_pa_type {
  *			LED ON  = RF ON
  *			LED OFF = RF OFF
  *    IWL_LED_BLINK:    adjust led blink rate based on blink table
+ *    IWL_LED_DISABLE:	led disabled
  */
 enum iwl_led_mode {
 	IWL_LED_DEFAULT,
 	IWL_LED_RF_STATE,
 	IWL_LED_BLINK,
+	IWL_LED_DISABLE,
 };
 
 /**
-- 
1.7.0.4

