Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:57207 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754040Ab1IVXBV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 19:01:21 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/12] iwlagn: refactor scan complete
Date: Thu, 22 Sep 2011 15:14:58 -0700
Message-Id: <1316729700-1770-11-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110923_010131_947061_CDEEC955)
In-Reply-To: <1316729700-1770-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316729700-1770-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We'll need to be able to run scan complete
inline, not from the workqueue, so refactor
it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index d9596ba..3010022 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -1013,18 +1013,14 @@ static void iwl_bg_abort_scan(struct work_struct *work)
 	mutex_unlock(&priv->shrd->mutex);
 }
 
-static void iwl_bg_scan_completed(struct work_struct *work)
+static void iwl_process_scan_complete(struct iwl_priv *priv)
 {
-	struct iwl_priv *priv =
-	    container_of(work, struct iwl_priv, scan_completed);
 	bool aborted;
 
 	IWL_DEBUG_SCAN(priv, "Completed scan.\n");
 
 	cancel_delayed_work(&priv->scan_check);
 
-	mutex_lock(&priv->shrd->mutex);
-
 	aborted = test_and_clear_bit(STATUS_SCAN_ABORTING, &priv->shrd->status);
 	if (aborted)
 		IWL_DEBUG_SCAN(priv, "Aborted scan completed.\n");
@@ -1057,7 +1053,7 @@ static void iwl_bg_scan_completed(struct work_struct *work)
 			goto out_complete;
 		}
 
-		goto out;
+		return;
 	}
 
 out_complete:
@@ -1066,11 +1062,18 @@ out_complete:
 out_settings:
 	/* Can we still talk to firmware ? */
 	if (!iwl_is_ready_rf(priv->shrd))
-		goto out;
+		return;
 
 	iwlagn_post_scan(priv);
+}
+
+static void iwl_bg_scan_completed(struct work_struct *work)
+{
+	struct iwl_priv *priv =
+		container_of(work, struct iwl_priv, scan_completed);
 
-out:
+	mutex_lock(&priv->shrd->mutex);
+	iwl_process_scan_complete(priv);
 	mutex_unlock(&priv->shrd->mutex);
 }
 
-- 
1.7.0.4

