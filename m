Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754783Ab0IMMqW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Sep 2010 08:46:22 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 03/14] iwlwifi: move scan completed flags handling
Date: Mon, 13 Sep 2010 14:46:34 +0200
Message-Id: <1284382005-3246-4-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1284382005-3246-1-git-send-email-sgruszka@redhat.com>
References: <1284382005-3246-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Move the scan completed flags handling so that we
can notify mac80211 about aborted scans with the
correct status. Also queue the scan_completed work
before the BT status update so that it won't see
the bits still set (unless a new scan was started
in which case that's fine.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi W Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |   30 ++++++++++++++----------------
 1 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 6bd14bc..22bdc98 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -222,21 +222,11 @@ static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 		       jiffies_to_msecs(elapsed_jiffies
 					(priv->scan_start, jiffies)));
 
-	/*
-	 * If a request to abort was given, or the scan did not succeed
-	 * then we reset the scan state machine and terminate,
-	 * re-queuing another scan if one has been requested
-	 */
-	if (test_and_clear_bit(STATUS_SCAN_ABORTING, &priv->status))
-		IWL_DEBUG_INFO(priv, "Aborted scan completed.\n");
-
-	IWL_DEBUG_INFO(priv, "Setting scan to off\n");
-
-	clear_bit(STATUS_SCANNING, &priv->status);
+	queue_work(priv->workqueue, &priv->scan_completed);
 
 	if (priv->iw_mode != NL80211_IFTYPE_ADHOC &&
-	    priv->cfg->advanced_bt_coexist && priv->bt_status !=
-	    scan_notif->bt_status) {
+	    priv->cfg->advanced_bt_coexist &&
+	    priv->bt_status != scan_notif->bt_status) {
 		if (scan_notif->bt_status) {
 			/* BT on */
 			if (!priv->bt_ch_announce)
@@ -254,7 +244,6 @@ static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 		priv->bt_status = scan_notif->bt_status;
 		queue_work(priv->workqueue, &priv->bt_traffic_change_work);
 	}
-	queue_work(priv->workqueue, &priv->scan_completed);
 }
 
 void iwl_setup_rx_scan_handlers(struct iwl_priv *priv)
@@ -554,7 +543,7 @@ static void iwl_bg_scan_completed(struct work_struct *work)
 {
 	struct iwl_priv *priv =
 	    container_of(work, struct iwl_priv, scan_completed);
-	bool internal = false;
+	bool internal = false, aborted;
 	struct iwl_rxon_context *ctx;
 
 	IWL_DEBUG_SCAN(priv, "SCAN complete scan\n");
@@ -562,6 +551,15 @@ static void iwl_bg_scan_completed(struct work_struct *work)
 	cancel_delayed_work(&priv->scan_check);
 
 	mutex_lock(&priv->mutex);
+
+	aborted = test_and_clear_bit(STATUS_SCAN_ABORTING, &priv->status);
+	if (aborted)
+		IWL_DEBUG_INFO(priv, "Aborted scan completed.\n");
+
+	IWL_DEBUG_INFO(priv, "Setting scan to off\n");
+
+	clear_bit(STATUS_SCANNING, &priv->status);
+
 	if (priv->is_internal_short_scan) {
 		priv->is_internal_short_scan = false;
 		IWL_DEBUG_SCAN(priv, "internal short scan completed\n");
@@ -569,7 +567,7 @@ static void iwl_bg_scan_completed(struct work_struct *work)
 	} else if (priv->scan_request) {
 		priv->scan_request = NULL;
 		priv->scan_vif = NULL;
-		ieee80211_scan_completed(priv->hw, false);
+		ieee80211_scan_completed(priv->hw, aborted);
 	}
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-- 
1.7.1

