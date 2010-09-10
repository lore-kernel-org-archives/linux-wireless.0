Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941Ab0IJO2p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Sep 2010 10:28:45 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 13/14] iwlwifi: use IWL_DEBUG_SCAN for debug scanning
Date: Fri, 10 Sep 2010 16:26:46 +0200
Message-Id: <1284128807-11436-14-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1284128807-11436-1-git-send-email-sgruszka@redhat.com>
References: <1284128807-11436-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |   31 +++++++++++++++++++------------
 1 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 26dd8f3..65b7cb4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -85,7 +85,7 @@ static int iwl_send_scan_abort(struct iwl_priv *priv)
 		 * can occur if we send the scan abort before we
 		 * the microcode has notified us that a scan is
 		 * completed. */
-		IWL_DEBUG_INFO(priv, "SCAN_ABORT ret %d.\n", pkt->u.status);
+		IWL_DEBUG_SCAN(priv, "SCAN_ABORT ret %d.\n", pkt->u.status);
 		ret = -EIO;
 	}
 
@@ -192,7 +192,7 @@ static void iwl_rx_reply_scan(struct iwl_priv *priv,
 	struct iwl_scanreq_notification *notif =
 	    (struct iwl_scanreq_notification *)pkt->u.raw;
 
-	IWL_DEBUG_RX(priv, "Scan request status = 0x%x\n", notif->status);
+	IWL_DEBUG_SCAN(priv, "Scan request status = 0x%x\n", notif->status);
 #endif
 }
 
@@ -251,7 +251,7 @@ static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 	/* The HW is no longer scanning */
 	clear_bit(STATUS_SCAN_HW, &priv->status);
 
-	IWL_DEBUG_INFO(priv, "Scan on %sGHz took %dms\n",
+	IWL_DEBUG_SCAN(priv, "Scan on %sGHz took %dms\n",
 		       (priv->scan_band == IEEE80211_BAND_2GHZ) ? "2.4" : "5.2",
 		       jiffies_to_msecs(elapsed_jiffies
 					(priv->scan_start, jiffies)));
@@ -362,22 +362,22 @@ static int __must_check iwl_scan_initiate(struct iwl_priv *priv,
 	cancel_delayed_work(&priv->scan_check);
 
 	if (!iwl_is_ready_rf(priv)) {
-		IWL_WARN(priv, "request scan called when driver not ready.\n");
+		IWL_WARN(priv, "Request scan called when driver not ready.\n");
 		return -EIO;
 	}
 
 	if (test_bit(STATUS_SCAN_HW, &priv->status)) {
-		IWL_DEBUG_INFO(priv,
+		IWL_DEBUG_SCAN(priv,
 			"Multiple concurrent scan requests in parallel.\n");
 		return -EBUSY;
 	}
 
 	if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
-		IWL_DEBUG_HC(priv, "Scan request while abort pending.\n");
+		IWL_DEBUG_SCAN(priv, "Scan request while abort pending.\n");
 		return -EBUSY;
 	}
 
-	IWL_DEBUG_INFO(priv, "Starting %sscan...\n",
+	IWL_DEBUG_SCAN(priv, "Starting %sscan...\n",
 			internal ? "internal short " : "");
 
 	set_bit(STATUS_SCANNING, &priv->status);
@@ -427,9 +427,10 @@ int iwl_mac_hw_scan(struct ieee80211_hw *hw,
 	 * If an internal scan is in progress, just set
 	 * up the scan_request as per above.
 	 */
-	if (priv->is_internal_short_scan)
+	if (priv->is_internal_short_scan) {
+		IWL_DEBUG_SCAN(priv, "SCAN request during internal scan\n");
 		ret = 0;
-	else
+	} else
 		ret = iwl_scan_initiate(priv, vif, false,
 					req->channels[0]->band);
 
@@ -456,6 +457,8 @@ static void iwl_bg_start_internal_scan(struct work_struct *work)
 	struct iwl_priv *priv =
 		container_of(work, struct iwl_priv, start_internal_scan);
 
+	IWL_DEBUG_SCAN(priv, "Start internal scan\n");
+
 	mutex_lock(&priv->mutex);
 
 	if (priv->is_internal_short_scan == true) {
@@ -479,6 +482,8 @@ static void iwl_bg_scan_check(struct work_struct *data)
 	struct iwl_priv *priv =
 	    container_of(data, struct iwl_priv, scan_check.work);
 
+	IWL_DEBUG_SCAN(priv, "Scan check work\n");
+
 	/* Since we are here firmware does not finish scan and
 	 * most likely is in bad shape, so we don't bother to
 	 * send abort command, just force scan complete to mac80211 */
@@ -539,6 +544,8 @@ static void iwl_bg_abort_scan(struct work_struct *work)
 {
 	struct iwl_priv *priv = container_of(work, struct iwl_priv, abort_scan);
 
+	IWL_DEBUG_SCAN(priv, "Abort scan work\n");
+
 	/* We keep scan_check work queued in case when firmware will not
 	 * report back scan completed notification */
 	mutex_lock(&priv->mutex);
@@ -553,7 +560,7 @@ static void iwl_bg_scan_completed(struct work_struct *work)
 	bool aborted;
 	struct iwl_rxon_context *ctx;
 
-	IWL_DEBUG_INFO(priv, "Completed %sscan.\n",
+	IWL_DEBUG_SCAN(priv, "Completed %sscan.\n",
 		       priv->is_internal_short_scan ? "internal short " : "");
 
 	cancel_delayed_work(&priv->scan_check);
@@ -562,10 +569,10 @@ static void iwl_bg_scan_completed(struct work_struct *work)
 
 	aborted = test_and_clear_bit(STATUS_SCAN_ABORTING, &priv->status);
 	if (aborted)
-		IWL_DEBUG_INFO(priv, "Aborted scan completed.\n");
+		IWL_DEBUG_SCAN(priv, "Aborted scan completed.\n");
 
 	if (!test_and_clear_bit(STATUS_SCANNING, &priv->status)) {
-		IWL_DEBUG_INFO(priv, "Scan already completed.\n");
+		IWL_DEBUG_SCAN(priv, "Scan already completed.\n");
 		goto out;
 	}
 
-- 
1.7.1

