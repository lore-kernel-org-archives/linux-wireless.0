Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:11717 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757655Ab1D3Qkq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Apr 2011 12:40:46 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/14] iwlagn: refactor restart
Date: Sat, 30 Apr 2011 09:17:29 -0700
Message-Id: <1304180260-13875-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110430_184052_143785_BEA68BB9)
In-Reply-To: <1304180260-13875-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1304180260-13875-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The WoWLAN resume code will have to essentially
do a restart, but without going through the work
struct. To support that, refactor the restart by
splitting out the preparation code into a new
function.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   68 +++++++++++++++++--------------
 1 files changed, 37 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index a4ec524..c27147c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2493,6 +2493,42 @@ static void iwl_bg_run_time_calib_work(struct work_struct *work)
 	mutex_unlock(&priv->mutex);
 }
 
+static void iwlagn_prepare_restart(struct iwl_priv *priv)
+{
+	struct iwl_rxon_context *ctx;
+	bool bt_full_concurrent;
+	u8 bt_ci_compliance;
+	u8 bt_load;
+	u8 bt_status;
+
+	lockdep_assert_held(&priv->mutex);
+
+	for_each_context(priv, ctx)
+		ctx->vif = NULL;
+	priv->is_open = 0;
+
+	/*
+	 * __iwl_down() will clear the BT status variables,
+	 * which is correct, but when we restart we really
+	 * want to keep them so restore them afterwards.
+	 *
+	 * The restart process will later pick them up and
+	 * re-configure the hw when we reconfigure the BT
+	 * command.
+	 */
+	bt_full_concurrent = priv->bt_full_concurrent;
+	bt_ci_compliance = priv->bt_ci_compliance;
+	bt_load = priv->bt_traffic_load;
+	bt_status = priv->bt_status;
+
+	__iwl_down(priv);
+
+	priv->bt_full_concurrent = bt_full_concurrent;
+	priv->bt_ci_compliance = bt_ci_compliance;
+	priv->bt_traffic_load = bt_load;
+	priv->bt_status = bt_status;
+}
+
 static void iwl_bg_restart(struct work_struct *data)
 {
 	struct iwl_priv *priv = container_of(data, struct iwl_priv, restart);
@@ -2501,38 +2537,8 @@ static void iwl_bg_restart(struct work_struct *data)
 		return;
 
 	if (test_and_clear_bit(STATUS_FW_ERROR, &priv->status)) {
-		struct iwl_rxon_context *ctx;
-		bool bt_full_concurrent;
-		u8 bt_ci_compliance;
-		u8 bt_load;
-		u8 bt_status;
-
 		mutex_lock(&priv->mutex);
-		for_each_context(priv, ctx)
-			ctx->vif = NULL;
-		priv->is_open = 0;
-
-		/*
-		 * __iwl_down() will clear the BT status variables,
-		 * which is correct, but when we restart we really
-		 * want to keep them so restore them afterwards.
-		 *
-		 * The restart process will later pick them up and
-		 * re-configure the hw when we reconfigure the BT
-		 * command.
-		 */
-		bt_full_concurrent = priv->bt_full_concurrent;
-		bt_ci_compliance = priv->bt_ci_compliance;
-		bt_load = priv->bt_traffic_load;
-		bt_status = priv->bt_status;
-
-		__iwl_down(priv);
-
-		priv->bt_full_concurrent = bt_full_concurrent;
-		priv->bt_ci_compliance = bt_ci_compliance;
-		priv->bt_traffic_load = bt_load;
-		priv->bt_status = bt_status;
-
+		iwlagn_prepare_restart(priv);
 		mutex_unlock(&priv->mutex);
 		iwl_cancel_deferred_work(priv);
 		ieee80211_restart_hw(priv->hw);
-- 
1.7.0.4

