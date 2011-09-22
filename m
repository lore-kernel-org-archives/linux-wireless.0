Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:45869 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066Ab1IVXBV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 19:01:21 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 12/12] iwlagn: fix scan complete processing
Date: Thu, 22 Sep 2011 15:15:00 -0700
Message-Id: <1316729700-1770-13-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110923_010131_337983_F9973281)
In-Reply-To: <1316729700-1770-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316729700-1770-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When we cancel a scan, the completion runs
only from the workqueue. This can cause the
remain-on-channel scan to fail when another
one was just canceled, because we're still
aborting it.

To fix this, run the completion inline with
the lock still held before returning from
iwl_scan_cancel_timeout().

Also, to avoid the scan complete work from
completing a new scan prematurely, add a
new STATUS_SCAN_COMPLETE bit.

Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Tested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c   |   36 +++++++++++++++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-shared.h |    1 +
 2 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index e50338b..c5c95d5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -118,6 +118,11 @@ static void iwl_process_scan_complete(struct iwl_priv *priv)
 {
 	bool aborted;
 
+	lockdep_assert_held(&priv->shrd->mutex);
+
+	if (!test_and_clear_bit(STATUS_SCAN_COMPLETE, &priv->shrd->status))
+		return;
+
 	IWL_DEBUG_SCAN(priv, "Completed scan.\n");
 
 	cancel_delayed_work(&priv->scan_check);
@@ -181,6 +186,7 @@ void iwl_force_scan_end(struct iwl_priv *priv)
 	clear_bit(STATUS_SCANNING, &priv->shrd->status);
 	clear_bit(STATUS_SCAN_HW, &priv->shrd->status);
 	clear_bit(STATUS_SCAN_ABORTING, &priv->shrd->status);
+	clear_bit(STATUS_SCAN_COMPLETE, &priv->shrd->status);
 	iwl_complete_scan(priv, true);
 }
 
@@ -235,9 +241,24 @@ void iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms)
 
 	while (time_before_eq(jiffies, timeout)) {
 		if (!test_bit(STATUS_SCAN_HW, &priv->shrd->status))
-			break;
+			goto finished;
 		msleep(20);
 	}
+
+	return;
+
+ finished:
+	/*
+	 * Now STATUS_SCAN_HW is clear. This means that the
+	 * device finished, but the background work is going
+	 * to execute at best as soon as we release the mutex.
+	 * Since we need to be able to issue a new scan right
+	 * after this function returns, run the complete here.
+	 * The STATUS_SCAN_COMPLETE bit will then be cleared
+	 * and prevent the background work from "completing"
+	 * a possible new scan.
+	 */
+	iwl_process_scan_complete(priv);
 }
 
 /* Service response to REPLY_SCAN_CMD (0x80) */
@@ -321,13 +342,20 @@ static int iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 		       scan_notif->tsf_low,
 		       scan_notif->tsf_high, scan_notif->status);
 
-	/* The HW is no longer scanning */
-	clear_bit(STATUS_SCAN_HW, &priv->shrd->status);
-
 	IWL_DEBUG_SCAN(priv, "Scan on %sGHz took %dms\n",
 		       (priv->scan_band == IEEE80211_BAND_2GHZ) ? "2.4" : "5.2",
 		       jiffies_to_msecs(jiffies - priv->scan_start));
 
+	/*
+	 * When aborting, we run the scan completed background work inline
+	 * and the background work must then do nothing. The SCAN_COMPLETE
+	 * bit helps implement that logic and thus needs to be set before
+	 * queueing the work. Also, since the scan abort waits for SCAN_HW
+	 * to clear, we need to set SCAN_COMPLETE before clearing SCAN_HW
+	 * to avoid a race there.
+	 */
+	set_bit(STATUS_SCAN_COMPLETE, &priv->shrd->status);
+	clear_bit(STATUS_SCAN_HW, &priv->shrd->status);
 	queue_work(priv->shrd->workqueue, &priv->scan_completed);
 
 	if (priv->iw_mode != NL80211_IFTYPE_ADHOC &&
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 7abafe1..8747bbd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -489,6 +489,7 @@ static inline void iwl_print_rx_config_cmd(struct iwl_priv *priv,
 #define STATUS_FW_ERROR		17
 #define STATUS_DEVICE_ENABLED	18
 #define STATUS_CHANNEL_SWITCH_PENDING 19
+#define STATUS_SCAN_COMPLETE	20
 
 static inline int iwl_is_ready(struct iwl_shared *shrd)
 {
-- 
1.7.0.4

