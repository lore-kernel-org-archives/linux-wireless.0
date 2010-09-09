Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473Ab0IINxV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Sep 2010 09:53:21 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 08/12] iwlwifi: rewrite scan completion
Date: Thu,  9 Sep 2010 15:52:26 +0200
Message-Id: <1284040354-31703-9-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1284040354-31703-1-git-send-email-sgruszka@redhat.com>
References: <1284040354-31703-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Assure (partially) we call ieee80211_scan_completed() only once when
scan was requested from mac80211.

Code path that first clear STATUS_SCANNING bit is responsible to call
ieee80211_scan_completed(). Before the call, we check if mac80211
really request the scan.

Still persist some cases when we behave wrong, that will be addressed
in the next patches.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |   65 +++++++++++++++++++------------
 1 files changed, 40 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 7e4faaf..f79fb3e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -93,6 +93,19 @@ static int iwl_send_scan_abort(struct iwl_priv *priv)
 	return ret;
 }
 
+static void iwl_complete_scan(struct iwl_priv *priv, bool aborted)
+{
+	/* check if scan was requested from mac80211 */
+	if (priv->scan_request) {
+		IWL_DEBUG_SCAN(priv, "Complete scan in mac80211\n");
+		ieee80211_scan_completed(priv->hw, aborted);
+	}
+
+	priv->is_internal_short_scan = false;
+	priv->scan_vif = NULL;
+	priv->scan_request = NULL;
+}
+
 static void iwl_do_scan_abort(struct iwl_priv *priv)
 {
 	int ret;
@@ -115,7 +128,7 @@ static void iwl_do_scan_abort(struct iwl_priv *priv)
 		clear_bit(STATUS_SCANNING, &priv->status);
 		clear_bit(STATUS_SCAN_HW, &priv->status);
 		clear_bit(STATUS_SCAN_ABORTING, &priv->status);
-		ieee80211_scan_completed(priv->hw, true);
+		iwl_complete_scan(priv, true);
 	} else
 		IWL_DEBUG_SCAN(priv, "Sucessfully send scan abort\n");
 }
@@ -545,10 +558,11 @@ static void iwl_bg_scan_completed(struct work_struct *work)
 {
 	struct iwl_priv *priv =
 	    container_of(work, struct iwl_priv, scan_completed);
-	bool internal = false, aborted;
+	bool aborted;
 	struct iwl_rxon_context *ctx;
 
-	IWL_DEBUG_SCAN(priv, "SCAN complete scan\n");
+	IWL_DEBUG_INFO(priv, "Completed %sscan.\n",
+		       priv->is_internal_short_scan ? "internal short " : "");
 
 	cancel_delayed_work(&priv->scan_check);
 
@@ -558,37 +572,38 @@ static void iwl_bg_scan_completed(struct work_struct *work)
 	if (aborted)
 		IWL_DEBUG_INFO(priv, "Aborted scan completed.\n");
 
-	IWL_DEBUG_INFO(priv, "Setting scan to off\n");
-
-	clear_bit(STATUS_SCANNING, &priv->status);
-
-	if (priv->is_internal_short_scan) {
-		priv->is_internal_short_scan = false;
-		IWL_DEBUG_SCAN(priv, "internal short scan completed\n");
-		internal = true;
-	} else if (priv->scan_request) {
-		priv->scan_request = NULL;
-		priv->scan_vif = NULL;
-		ieee80211_scan_completed(priv->hw, aborted);
+	if (!test_and_clear_bit(STATUS_SCANNING, &priv->status)) {
+		IWL_DEBUG_INFO(priv, "Scan already completed.\n");
+		goto out;
 	}
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		goto out;
+	if (priv->is_internal_short_scan && !aborted) {
+		int err;
 
-	if (internal && priv->scan_request) {
-		int err = iwl_scan_initiate(priv, priv->scan_vif, false,
-					priv->scan_request->channels[0]->band);
+		/* Check if mac80211 requested scan during our internal scan */
+		if (priv->scan_request == NULL)
+			goto out_complete;
 
+		/* If so request a new scan */
+		err = iwl_scan_initiate(priv, priv->scan_vif, false,
+					priv->scan_request->channels[0]->band);
 		if (err) {
 			IWL_DEBUG_SCAN(priv,
 				"failed to initiate pending scan: %d\n", err);
-			priv->scan_request = NULL;
-			priv->scan_vif = NULL;
-			ieee80211_scan_completed(priv->hw, true);
-		} else
-			goto out;
+			aborted = true;
+			goto out_complete;
+		}
+
+		goto out;
 	}
 
+out_complete:
+	iwl_complete_scan(priv, aborted);
+
+	/* Can we still talk to firmware ? */
+	if (!iwl_is_ready_rf(priv))
+		goto out;
+
 	/* Since setting the TXPOWER may have been deferred while
 	 * performing the scan, fire one off */
 	iwl_set_tx_power(priv, priv->tx_power_user_lmt, true);
-- 
1.7.1

