Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:1999 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757955Ab1FKOzk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jun 2011 10:55:40 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/18] iwlagn: move no_sleep_autoadjust as part of iwlagn_mod_params
Date: Sat, 11 Jun 2011 07:25:39 -0700
Message-Id: <1307802352-16398-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110611_165550_581861_A129CD62)
In-Reply-To: <1307802352-16398-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1307802352-16398-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move no_sleep_autoadjust module parameter into iwlagn_mod_params structure
along with all the other iwlagn module parameters

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.c     |   10 ++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h    |    1 +
 drivers/net/wireless/iwlwifi/iwl-power.c   |   13 ++-----------
 4 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index f0dacfb..58f6da0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -623,6 +623,7 @@ struct iwl_mod_params iwlagn_mod_params = {
 	.restart_fw = 1,
 	.plcp_check = true,
 	.bt_coex_active = true,
+	.no_sleep_autoadjust = true,
 	/* the rest are 0 by default */
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 3268356..8bed315 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4099,3 +4099,13 @@ MODULE_PARM_DESC(bt_coex_active, "enable wifi/bt co-exist (default: enable)");
 module_param_named(led_mode, iwlagn_mod_params.led_mode, int, S_IRUGO);
 MODULE_PARM_DESC(led_mode, "0=system default, "
 		"1=On(RF On)/Off(RF Off), 2=blinking (default: 0)");
+
+/*
+ * For now, keep using power level 1 instead of automatically
+ * adjusting ...
+ */
+module_param_named(no_sleep_autoadjust, iwlagn_mod_params.no_sleep_autoadjust,
+		bool, S_IRUGO);
+MODULE_PARM_DESC(no_sleep_autoadjust,
+		 "don't automatically adjust sleep level "
+		 "according to maximum network latency (default: true)");
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index f950da0..a16daf7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -175,6 +175,7 @@ struct iwl_mod_params {
 	bool ack_check;		/* def: false = disable ack health check */
 	bool bt_coex_active;	/* def: true = enable bt coex */
 	int led_mode;		/* def: 0 = system default */
+	bool no_sleep_autoadjust; /* def: true = disable autoadjust */
 };
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 595c930..a69b551 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -36,6 +36,7 @@
 
 #include "iwl-eeprom.h"
 #include "iwl-dev.h"
+#include "iwl-agn.h"
 #include "iwl-core.h"
 #include "iwl-io.h"
 #include "iwl-commands.h"
@@ -51,16 +52,6 @@
  */
 
 /*
- * For now, keep using power level 1 instead of automatically
- * adjusting ...
- */
-bool no_sleep_autoadjust = true;
-module_param(no_sleep_autoadjust, bool, S_IRUGO);
-MODULE_PARM_DESC(no_sleep_autoadjust,
-		 "don't automatically adjust sleep level "
-		 "according to maximum network latency");
-
-/*
  * This defines the old power levels. They are still used by default
  * (level 1) and for thermal throttle (levels 3 through 5)
  */
@@ -367,7 +358,7 @@ static void iwl_power_build_cmd(struct iwl_priv *priv,
 		iwl_static_sleep_cmd(priv, cmd,
 				     priv->power_data.debug_sleep_level_override,
 				     dtimper);
-	else if (no_sleep_autoadjust)
+	else if (iwlagn_mod_params.no_sleep_autoadjust)
 		iwl_static_sleep_cmd(priv, cmd, IWL_POWER_INDEX_1, dtimper);
 	else
 		iwl_power_fill_sleep_cmd(priv, cmd,
-- 
1.7.0.4

