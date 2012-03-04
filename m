Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:17699 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755178Ab2CDUnK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:10 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 076/101] iwlwifi: move BT/HT params to shared
Date: Sun,  4 Mar 2012 11:29:30 -0800
Message-Id: <1330889395-533-77-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214506_166529_BE8CC919)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Hardware parameters will be shared, so
move the definitions into the shared
header file.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.h   |   24 ------------------------
 drivers/net/wireless/iwlwifi/iwl-shared.h |   24 ++++++++++++++++++++++++
 2 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 95f6b7b..635eb68 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -89,30 +89,6 @@ struct iwl_lib_ops {
 	void (*temperature)(struct iwl_priv *priv);
 };
 
-/*
- * @advanced_bt_coexist: support advanced bt coexist
- * @bt_init_traffic_load: specify initial bt traffic load
- * @bt_prio_boost: default bt priority boost value
- * @agg_time_limit: maximum number of uSec in aggregation
- * @bt_sco_disable: uCode should not response to BT in SCO/ESCO mode
- */
-struct iwl_bt_params {
-	bool advanced_bt_coexist;
-	u8 bt_init_traffic_load;
-	u8 bt_prio_boost;
-	u16 agg_time_limit;
-	bool bt_sco_disable;
-	bool bt_session_2;
-};
-/*
- * @use_rts_for_aggregation: use rts/cts protection for HT traffic
- */
-struct iwl_ht_params {
-	const bool ht_greenfield_support; /* if used set to true */
-	bool use_rts_for_aggregation;
-	enum ieee80211_smps_mode smps_mode;
-};
-
 /***************************
  *   L i b                 *
  ***************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 2ab7462..0e24803 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -268,6 +268,30 @@ struct iwl_base_params {
 	const bool wd_disable;
 };
 
+/*
+ * @advanced_bt_coexist: support advanced bt coexist
+ * @bt_init_traffic_load: specify initial bt traffic load
+ * @bt_prio_boost: default bt priority boost value
+ * @agg_time_limit: maximum number of uSec in aggregation
+ * @bt_sco_disable: uCode should not response to BT in SCO/ESCO mode
+ */
+struct iwl_bt_params {
+	bool advanced_bt_coexist;
+	u8 bt_init_traffic_load;
+	u8 bt_prio_boost;
+	u16 agg_time_limit;
+	bool bt_sco_disable;
+	bool bt_session_2;
+};
+/*
+ * @use_rts_for_aggregation: use rts/cts protection for HT traffic
+ */
+struct iwl_ht_params {
+	const bool ht_greenfield_support; /* if used set to true */
+	bool use_rts_for_aggregation;
+	enum ieee80211_smps_mode smps_mode;
+};
+
 /**
  * struct iwl_cfg
  * @name: Offical name of the device
-- 
1.7.0.4

