Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:45464 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758571Ab1FKOzk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jun 2011 10:55:40 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/18] iwlagn: move led_mode as part of iwlagn_mod_params
Date: Sat, 11 Jun 2011 07:25:38 -0700
Message-Id: <1307802352-16398-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110611_165603_784097_D1E07E74)
In-Reply-To: <1307802352-16398-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1307802352-16398-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move led_mode module parameter into iwlagn_mod_params structure
along with all the other iwlagn module parameters

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    4 ++++
 drivers/net/wireless/iwlwifi/iwl-core.h |    1 +
 drivers/net/wireless/iwlwifi/iwl-led.c  |    9 ++-------
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 6ecee3c..3268356 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4095,3 +4095,7 @@ MODULE_PARM_DESC(ack_check, "Check ack health (default: 0 [disabled])");
 module_param_named(bt_coex_active, iwlagn_mod_params.bt_coex_active,
 		bool, S_IRUGO);
 MODULE_PARM_DESC(bt_coex_active, "enable wifi/bt co-exist (default: enable)");
+
+module_param_named(led_mode, iwlagn_mod_params.led_mode, int, S_IRUGO);
+MODULE_PARM_DESC(led_mode, "0=system default, "
+		"1=On(RF On)/Off(RF Off), 2=blinking (default: 0)");
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 1a43a62..f950da0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -174,6 +174,7 @@ struct iwl_mod_params {
 	bool plcp_check;	/* def: true = enable plcp health check */
 	bool ack_check;		/* def: false = disable ack health check */
 	bool bt_coex_active;	/* def: true = enable bt coex */
+	int led_mode;		/* def: 0 = system default */
 };
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 7c23beb..1a8ce4a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -40,14 +40,9 @@
 
 #include "iwl-dev.h"
 #include "iwl-core.h"
+#include "iwl-agn.h"
 #include "iwl-io.h"
 
-/* default: IWL_LED_BLINK(0) using blinking index table */
-static int led_mode;
-module_param(led_mode, int, S_IRUGO);
-MODULE_PARM_DESC(led_mode, "0=system default, "
-		"1=On(RF On)/Off(RF Off), 2=blinking");
-
 /* Throughput		OFF time(ms)	ON time (ms)
  *	>300			25		25
  *	>200 to 300		40		40
@@ -181,7 +176,7 @@ static int iwl_led_blink_set(struct led_classdev *led_cdev,
 
 void iwl_leds_init(struct iwl_priv *priv)
 {
-	int mode = led_mode;
+	int mode = iwlagn_mod_params.led_mode;
 	int ret;
 
 	if (mode == IWL_LED_DEFAULT)
-- 
1.7.0.4

