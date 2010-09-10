Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244Ab0IJO23 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Sep 2010 10:28:29 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 05/14] iwlwifi: report scan completion when abort fail
Date: Fri, 10 Sep 2010 16:26:38 +0200
Message-Id: <1284128807-11436-6-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1284128807-11436-1-git-send-email-sgruszka@redhat.com>
References: <1284128807-11436-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we are not able to send abort command to firmware, notify mac80211
that we complete scan, as we will newer do it lately. Check for all
possible errors that low level sending command procedure does not check,
to assure we catch all failures cases.

Patch fix one of the causes of wdev_cleanup_work warning reported at
https://bugzilla.redhat.com/show_bug.cgi?id=593566

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |  131 ++++++++++++++++---------------
 1 files changed, 67 insertions(+), 64 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index ea33849..dbb07e8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -54,34 +54,83 @@
 #define IWL_PASSIVE_DWELL_BASE      (100)
 #define IWL_CHANNEL_TUNE_TIME       5
 
+static int iwl_send_scan_abort(struct iwl_priv *priv)
+{
+	int ret;
+	struct iwl_rx_packet *pkt;
+	struct iwl_host_cmd cmd = {
+		.id = REPLY_SCAN_ABORT_CMD,
+		.flags = CMD_WANT_SKB,
+	};
 
+	/* Exit instantly with error when device is not ready
+	 * to receive scan abort command or it does not perform
+	 * hardware scan currently */
+	if (!test_bit(STATUS_READY, &priv->status) ||
+	    !test_bit(STATUS_GEO_CONFIGURED, &priv->status) ||
+	    !test_bit(STATUS_SCAN_HW, &priv->status) ||
+	    test_bit(STATUS_FW_ERROR, &priv->status) ||
+	    test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return -EIO;
 
-/**
- * iwl_scan_cancel - Cancel any currently executing HW scan
- *
- * NOTE: priv->mutex is not required before calling this function
- */
-int iwl_scan_cancel(struct iwl_priv *priv)
-{
-	if (!test_bit(STATUS_SCAN_HW, &priv->status)) {
-		clear_bit(STATUS_SCANNING, &priv->status);
-		return 0;
+	ret = iwl_send_cmd_sync(priv, &cmd);
+	if (ret)
+		return ret;
+
+	pkt = (struct iwl_rx_packet *)cmd.reply_page;
+	if (pkt->u.status != CAN_ABORT_STATUS) {
+		/* The scan abort will return 1 for success or
+		 * 2 for "failure".  A failure condition can be
+		 * due to simply not being in an active scan which
+		 * can occur if we send the scan abort before we
+		 * the microcode has notified us that a scan is
+		 * completed. */
+		IWL_DEBUG_INFO(priv, "SCAN_ABORT ret %d.\n", pkt->u.status);
+		ret = -EIO;
 	}
 
-	if (test_bit(STATUS_SCANNING, &priv->status)) {
-		if (!test_and_set_bit(STATUS_SCAN_ABORTING, &priv->status)) {
-			IWL_DEBUG_SCAN(priv, "Queuing scan abort.\n");
-			schedule_work(&priv->abort_scan);
+	iwl_free_pages(priv, cmd.reply_page);
+	return ret;
+}
 
-		} else
-			IWL_DEBUG_SCAN(priv, "Scan abort already in progress.\n");
+static void iwl_do_scan_abort(struct iwl_priv *priv)
+{
+	int ret;
 
-		return test_bit(STATUS_SCANNING, &priv->status);
+	lockdep_assert_held(&priv->mutex);
+
+	if (!test_bit(STATUS_SCANNING, &priv->status)) {
+		IWL_DEBUG_SCAN(priv, "Not performing scan to abort\n");
+		return;
 	}
 
+	if (test_and_set_bit(STATUS_SCAN_ABORTING, &priv->status)) {
+		IWL_DEBUG_SCAN(priv, "Scan abort in progress\n");
+		return;
+	}
+
+	ret = iwl_send_scan_abort(priv);
+	if (ret) {
+		IWL_DEBUG_SCAN(priv, "Send scan abort failed %d\n", ret);
+		clear_bit(STATUS_SCANNING, &priv->status);
+		clear_bit(STATUS_SCAN_HW, &priv->status);
+		clear_bit(STATUS_SCAN_ABORTING, &priv->status);
+		ieee80211_scan_completed(priv->hw, true);
+	} else
+		IWL_DEBUG_SCAN(priv, "Sucessfully send scan abort\n");
+}
+
+/**
+ * iwl_scan_cancel - Cancel any currently executing HW scan
+ */
+int iwl_scan_cancel(struct iwl_priv *priv)
+{
+	IWL_DEBUG_SCAN(priv, "Queuing abort scan\n");
+	schedule_work(&priv->abort_scan);
 	return 0;
 }
 EXPORT_SYMBOL(iwl_scan_cancel);
+
 /**
  * iwl_scan_cancel_timeout - Cancel any currently executing HW scan
  * @ms: amount of time to wait (in milliseconds) for scan to abort
@@ -108,47 +157,6 @@ int iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms)
 }
 EXPORT_SYMBOL(iwl_scan_cancel_timeout);
 
-static int iwl_send_scan_abort(struct iwl_priv *priv)
-{
-	int ret = 0;
-	struct iwl_rx_packet *pkt;
-	struct iwl_host_cmd cmd = {
-		.id = REPLY_SCAN_ABORT_CMD,
-		.flags = CMD_WANT_SKB,
-	};
-
-	/* If there isn't a scan actively going on in the hardware
-	 * then we are in between scan bands and not actually
-	 * actively scanning, so don't send the abort command */
-	if (!test_bit(STATUS_SCAN_HW, &priv->status)) {
-		clear_bit(STATUS_SCAN_ABORTING, &priv->status);
-		return 0;
-	}
-
-	ret = iwl_send_cmd_sync(priv, &cmd);
-	if (ret) {
-		clear_bit(STATUS_SCAN_ABORTING, &priv->status);
-		return ret;
-	}
-
-	pkt = (struct iwl_rx_packet *)cmd.reply_page;
-	if (pkt->u.status != CAN_ABORT_STATUS) {
-		/* The scan abort will return 1 for success or
-		 * 2 for "failure".  A failure condition can be
-		 * due to simply not being in an active scan which
-		 * can occur if we send the scan abort before we
-		 * the microcode has notified us that a scan is
-		 * completed. */
-		IWL_DEBUG_INFO(priv, "SCAN_ABORT returned %d.\n", pkt->u.status);
-		clear_bit(STATUS_SCAN_ABORTING, &priv->status);
-		clear_bit(STATUS_SCAN_HW, &priv->status);
-	}
-
-	iwl_free_pages(priv, cmd.reply_page);
-
-	return ret;
-}
-
 /* Service response to REPLY_SCAN_CMD (0x80) */
 static void iwl_rx_reply_scan(struct iwl_priv *priv,
 			      struct iwl_rx_mem_buffer *rxb)
@@ -527,15 +535,10 @@ static void iwl_bg_abort_scan(struct work_struct *work)
 {
 	struct iwl_priv *priv = container_of(work, struct iwl_priv, abort_scan);
 
-	if (!test_bit(STATUS_READY, &priv->status) ||
-	    !test_bit(STATUS_GEO_CONFIGURED, &priv->status))
-		return;
-
 	cancel_delayed_work(&priv->scan_check);
 
 	mutex_lock(&priv->mutex);
-	if (test_bit(STATUS_SCAN_ABORTING, &priv->status))
-		iwl_send_scan_abort(priv);
+	iwl_do_scan_abort(priv);
 	mutex_unlock(&priv->mutex);
 }
 
-- 
1.7.1

