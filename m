Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:7986 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063Ab1IVXBV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 19:01:21 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 11/12] iwlagn: move iwl_process_scan_complete up
Date: Thu, 22 Sep 2011 15:14:59 -0700
Message-Id: <1316729700-1770-12-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110923_010132_512742_97FBAF23)
In-Reply-To: <1316729700-1770-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316729700-1770-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

To make the next patch easier to read, move
the function up, it'll be needed earlier in
this file in the next patch.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |  108 +++++++++++++++---------------
 1 files changed, 54 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 3010022..e50338b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -114,6 +114,60 @@ static void iwl_complete_scan(struct iwl_priv *priv, bool aborted)
 	priv->scan_request = NULL;
 }
 
+static void iwl_process_scan_complete(struct iwl_priv *priv)
+{
+	bool aborted;
+
+	IWL_DEBUG_SCAN(priv, "Completed scan.\n");
+
+	cancel_delayed_work(&priv->scan_check);
+
+	aborted = test_and_clear_bit(STATUS_SCAN_ABORTING, &priv->shrd->status);
+	if (aborted)
+		IWL_DEBUG_SCAN(priv, "Aborted scan completed.\n");
+
+	if (!test_and_clear_bit(STATUS_SCANNING, &priv->shrd->status)) {
+		IWL_DEBUG_SCAN(priv, "Scan already completed.\n");
+		goto out_settings;
+	}
+
+	if (priv->scan_type == IWL_SCAN_ROC) {
+		ieee80211_remain_on_channel_expired(priv->hw);
+		priv->hw_roc_channel = NULL;
+		schedule_delayed_work(&priv->hw_roc_disable_work, 10 * HZ);
+	}
+
+	if (priv->scan_type != IWL_SCAN_NORMAL && !aborted) {
+		int err;
+
+		/* Check if mac80211 requested scan during our internal scan */
+		if (priv->scan_request == NULL)
+			goto out_complete;
+
+		/* If so request a new scan */
+		err = iwl_scan_initiate(priv, priv->scan_vif, IWL_SCAN_NORMAL,
+					priv->scan_request->channels[0]->band);
+		if (err) {
+			IWL_DEBUG_SCAN(priv,
+				"failed to initiate pending scan: %d\n", err);
+			aborted = true;
+			goto out_complete;
+		}
+
+		return;
+	}
+
+out_complete:
+	iwl_complete_scan(priv, aborted);
+
+out_settings:
+	/* Can we still talk to firmware ? */
+	if (!iwl_is_ready_rf(priv->shrd))
+		return;
+
+	iwlagn_post_scan(priv);
+}
+
 void iwl_force_scan_end(struct iwl_priv *priv)
 {
 	lockdep_assert_held(&priv->shrd->mutex);
@@ -1013,60 +1067,6 @@ static void iwl_bg_abort_scan(struct work_struct *work)
 	mutex_unlock(&priv->shrd->mutex);
 }
 
-static void iwl_process_scan_complete(struct iwl_priv *priv)
-{
-	bool aborted;
-
-	IWL_DEBUG_SCAN(priv, "Completed scan.\n");
-
-	cancel_delayed_work(&priv->scan_check);
-
-	aborted = test_and_clear_bit(STATUS_SCAN_ABORTING, &priv->shrd->status);
-	if (aborted)
-		IWL_DEBUG_SCAN(priv, "Aborted scan completed.\n");
-
-	if (!test_and_clear_bit(STATUS_SCANNING, &priv->shrd->status)) {
-		IWL_DEBUG_SCAN(priv, "Scan already completed.\n");
-		goto out_settings;
-	}
-
-	if (priv->scan_type == IWL_SCAN_ROC) {
-		ieee80211_remain_on_channel_expired(priv->hw);
-		priv->hw_roc_channel = NULL;
-		schedule_delayed_work(&priv->hw_roc_disable_work, 10 * HZ);
-	}
-
-	if (priv->scan_type != IWL_SCAN_NORMAL && !aborted) {
-		int err;
-
-		/* Check if mac80211 requested scan during our internal scan */
-		if (priv->scan_request == NULL)
-			goto out_complete;
-
-		/* If so request a new scan */
-		err = iwl_scan_initiate(priv, priv->scan_vif, IWL_SCAN_NORMAL,
-					priv->scan_request->channels[0]->band);
-		if (err) {
-			IWL_DEBUG_SCAN(priv,
-				"failed to initiate pending scan: %d\n", err);
-			aborted = true;
-			goto out_complete;
-		}
-
-		return;
-	}
-
-out_complete:
-	iwl_complete_scan(priv, aborted);
-
-out_settings:
-	/* Can we still talk to firmware ? */
-	if (!iwl_is_ready_rf(priv->shrd))
-		return;
-
-	iwlagn_post_scan(priv);
-}
-
 static void iwl_bg_scan_completed(struct work_struct *work)
 {
 	struct iwl_priv *priv =
-- 
1.7.0.4

