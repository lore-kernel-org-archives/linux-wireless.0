Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:1999 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758553Ab1FKOzj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jun 2011 10:55:39 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/18] iwlagn: move bt_coex_active as part of iwlagn_mod_params
Date: Sat, 11 Jun 2011 07:25:37 -0700
Message-Id: <1307802352-16398-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110611_165605_350584_ACA3AF23)
In-Reply-To: <1307802352-16398-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1307802352-16398-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move bt_coex_active module parameter into iwlagn_mod_params structure
along with all the other iwlagn module parameters

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    4 +++-
 drivers/net/wireless/iwlwifi/iwl-agn.c     |   20 ++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.c    |   23 +----------------------
 drivers/net/wireless/iwlwifi/iwl-core.h    |    2 +-
 4 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 677f73c..f0dacfb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -622,6 +622,7 @@ struct iwl_mod_params iwlagn_mod_params = {
 	.amsdu_size_8K = 1,
 	.restart_fw = 1,
 	.plcp_check = true,
+	.bt_coex_active = true,
 	/* the rest are 0 by default */
 };
 
@@ -1699,7 +1700,8 @@ void iwlagn_send_advance_bt_config(struct iwl_priv *priv)
 	 * (might be in monitor mode), or the interface is in
 	 * IBSS mode (no proper uCode support for coex then).
 	 */
-	if (!bt_coex_active || priv->iw_mode == NL80211_IFTYPE_ADHOC) {
+	if (!iwlagn_mod_params.bt_coex_active ||
+	    priv->iw_mode == NL80211_IFTYPE_ADHOC) {
 		basic.flags = IWLAGN_BT_FLAG_COEX_MODE_DISABLED;
 	} else {
 		basic.flags = IWLAGN_BT_FLAG_COEX_MODE_3W <<
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 6f1edb4..6ecee3c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4075,3 +4075,23 @@ MODULE_PARM_DESC(plcp_check, "Check plcp health (default: 1 [enabled])");
 
 module_param_named(ack_check, iwlagn_mod_params.ack_check, bool, S_IRUGO);
 MODULE_PARM_DESC(ack_check, "Check ack health (default: 0 [disabled])");
+
+/*
+ * set bt_coex_active to true, uCode will do kill/defer
+ * every time the priority line is asserted (BT is sending signals on the
+ * priority line in the PCIx).
+ * set bt_coex_active to false, uCode will ignore the BT activity and
+ * perform the normal operation
+ *
+ * User might experience transmit issue on some platform due to WiFi/BT
+ * co-exist problem. The possible behaviors are:
+ *   Able to scan and finding all the available AP
+ *   Not able to associate with any AP
+ * On those platforms, WiFi communication can be restored by set
+ * "bt_coex_active" module parameter to "false"
+ *
+ * default: bt_coex_active = true (BT_COEX_ENABLE)
+ */
+module_param_named(bt_coex_active, iwlagn_mod_params.bt_coex_active,
+		bool, S_IRUGO);
+MODULE_PARM_DESC(bt_coex_active, "enable wifi/bt co-exist (default: enable)");
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 5416b12..ad54f82 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -43,27 +43,6 @@
 #include "iwl-helpers.h"
 #include "iwl-agn.h"
 
-
-/*
- * set bt_coex_active to true, uCode will do kill/defer
- * every time the priority line is asserted (BT is sending signals on the
- * priority line in the PCIx).
- * set bt_coex_active to false, uCode will ignore the BT activity and
- * perform the normal operation
- *
- * User might experience transmit issue on some platform due to WiFi/BT
- * co-exist problem. The possible behaviors are:
- *   Able to scan and finding all the available AP
- *   Not able to associate with any AP
- * On those platforms, WiFi communication can be restored by set
- * "bt_coex_active" module parameter to "false"
- *
- * default: bt_coex_active = true (BT_COEX_ENABLE)
- */
-bool bt_coex_active = true;
-module_param(bt_coex_active, bool, S_IRUGO);
-MODULE_PARM_DESC(bt_coex_active, "enable wifi/bluetooth co-exist");
-
 u32 iwl_debug_level;
 
 const u8 iwl_bcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
@@ -1179,7 +1158,7 @@ void iwl_send_bt_config(struct iwl_priv *priv)
 		.kill_cts_mask = 0,
 	};
 
-	if (!bt_coex_active)
+	if (!iwlagn_mod_params.bt_coex_active)
 		bt_cmd.flags = BT_COEX_DISABLE;
 	else
 		bt_cmd.flags = BT_COEX_ENABLE;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 05ea88a..1a43a62 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -173,6 +173,7 @@ struct iwl_mod_params {
 	int restart_fw;		/* def: 1 = restart firmware */
 	bool plcp_check;	/* def: true = enable plcp health check */
 	bool ack_check;		/* def: false = disable ack health check */
+	bool bt_coex_active;	/* def: true = enable bt coex */
 };
 
 /*
@@ -624,7 +625,6 @@ static inline bool iwl_advanced_bt_coexist(struct iwl_priv *priv)
 	       priv->cfg->bt_params->advanced_bt_coexist;
 }
 
-extern bool bt_coex_active;
 extern bool bt_siso_mode;
 
 
-- 
1.7.0.4

