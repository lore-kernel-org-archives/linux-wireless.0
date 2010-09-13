Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754783Ab0IMMq1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Sep 2010 08:46:27 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 04/14] iwlwifi: cancel scan when down the device
Date: Mon, 13 Sep 2010 14:46:35 +0200
Message-Id: <1284382005-3246-5-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1284382005-3246-1-git-send-email-sgruszka@redhat.com>
References: <1284382005-3246-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Always cancel scan when stooping device and scan is currently pending,
we should newer have scan running after down device.

To assure we start scan cancel from restart work we have to schedule
abort_scan to different workqueue than priv->workqueue.

Patch fix not cancel scanning when restarting firmware, what is
one of the causes of wdev_cleanup_work warning (together with permanent
network connection lost) reported at
https://bugzilla.redhat.com/show_bug.cgi?id=593566

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi W Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   14 +++-----------
 drivers/net/wireless/iwlwifi/iwl-scan.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   16 ++++------------
 3 files changed, 8 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c8a2ec8..25b3540 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2891,8 +2891,9 @@ static void __iwl_down(struct iwl_priv *priv)
 
 	IWL_DEBUG_INFO(priv, DRV_NAME " is going down\n");
 
-	if (!exit_pending)
-		set_bit(STATUS_EXIT_PENDING, &priv->status);
+	iwl_scan_cancel_timeout(priv, 200);
+
+	exit_pending = test_and_set_bit(STATUS_EXIT_PENDING, &priv->status);
 
 	/* Stop TX queues watchdog. We need to have STATUS_EXIT_PENDING bit set
 	 * to prevent rearm timer */
@@ -3502,15 +3503,6 @@ static void iwl_mac_stop(struct ieee80211_hw *hw)
 
 	priv->is_open = 0;
 
-	if (iwl_is_ready_rf(priv) || test_bit(STATUS_SCAN_HW, &priv->status)) {
-		/* stop mac, cancel any scan request and clear
-		 * RXON_FILTER_ASSOC_MSK BIT
-		 */
-		mutex_lock(&priv->mutex);
-		iwl_scan_cancel_timeout(priv, 100);
-		mutex_unlock(&priv->mutex);
-	}
-
 	iwl_down(priv);
 
 	flush_workqueue(priv->workqueue);
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 22bdc98..ea33849 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -71,7 +71,7 @@ int iwl_scan_cancel(struct iwl_priv *priv)
 	if (test_bit(STATUS_SCANNING, &priv->status)) {
 		if (!test_and_set_bit(STATUS_SCAN_ABORTING, &priv->status)) {
 			IWL_DEBUG_SCAN(priv, "Queuing scan abort.\n");
-			queue_work(priv->workqueue, &priv->abort_scan);
+			schedule_work(&priv->abort_scan);
 
 		} else
 			IWL_DEBUG_SCAN(priv, "Scan abort already in progress.\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 3b3686b..fb894d8 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2568,12 +2568,13 @@ static void iwl3945_cancel_deferred_work(struct iwl_priv *priv);
 static void __iwl3945_down(struct iwl_priv *priv)
 {
 	unsigned long flags;
-	int exit_pending = test_bit(STATUS_EXIT_PENDING, &priv->status);
+	int exit_pending;
 
 	IWL_DEBUG_INFO(priv, DRV_NAME " is going down\n");
 
-	if (!exit_pending)
-		set_bit(STATUS_EXIT_PENDING, &priv->status);
+	iwl_scan_cancel_timeout(priv, 200);
+
+	exit_pending = test_and_set_bit(STATUS_EXIT_PENDING, &priv->status);
 
 	/* Stop TX queues watchdog. We need to have STATUS_EXIT_PENDING bit set
 	 * to prevent rearm timer */
@@ -3173,15 +3174,6 @@ static void iwl3945_mac_stop(struct ieee80211_hw *hw)
 
 	priv->is_open = 0;
 
-	if (iwl_is_ready_rf(priv)) {
-		/* stop mac, cancel any scan request and clear
-		 * RXON_FILTER_ASSOC_MSK BIT
-		 */
-		mutex_lock(&priv->mutex);
-		iwl_scan_cancel_timeout(priv, 100);
-		mutex_unlock(&priv->mutex);
-	}
-
 	iwl3945_down(priv);
 
 	flush_workqueue(priv->workqueue);
-- 
1.7.1

