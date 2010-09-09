Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194Ab0IINxL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Sep 2010 09:53:11 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 07/12] iwlwifi: rework iwl_scan_cancel_timeout
Date: Thu,  9 Sep 2010 15:52:25 +0200
Message-Id: <1284040354-31703-8-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1284040354-31703-1-git-send-email-sgruszka@redhat.com>
References: <1284040354-31703-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since on timeout version of iwl_scan_cancel procedure we can sleep,
do not have to schedule abort_scan work to begin and perform scanning,
can do this directly. Also now, as we do not queue abort_scan from
restart work anymore, we can queue abort_scan to priv->workqueue.

Don't drop mutex when waiting for scan complete. Use STATUS_HW_SCAN bit
to check if scanning is currently pending, because STATUS_SCANNING will
be cleared only with priv->mutex taken.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 4d2a09b..7e4faaf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -126,7 +126,7 @@ static void iwl_do_scan_abort(struct iwl_priv *priv)
 int iwl_scan_cancel(struct iwl_priv *priv)
 {
 	IWL_DEBUG_SCAN(priv, "Queuing abort scan\n");
-	schedule_work(&priv->abort_scan);
+	queue_work(priv->workqueue, &priv->abort_scan);
 	return 0;
 }
 EXPORT_SYMBOL(iwl_scan_cancel);
@@ -135,25 +135,24 @@ EXPORT_SYMBOL(iwl_scan_cancel);
  * iwl_scan_cancel_timeout - Cancel any currently executing HW scan
  * @ms: amount of time to wait (in milliseconds) for scan to abort
  *
- * NOTE: priv->mutex must be held before calling this function
  */
 int iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms)
 {
-	unsigned long now = jiffies;
-	int ret;
+	unsigned long timeout = jiffies + msecs_to_jiffies(ms);
+
+	lockdep_assert_held(&priv->mutex);
 
-	ret = iwl_scan_cancel(priv);
-	if (ret && ms) {
-		mutex_unlock(&priv->mutex);
-		while (!time_after(jiffies, now + msecs_to_jiffies(ms)) &&
-				test_bit(STATUS_SCANNING, &priv->status))
-			msleep(1);
-		mutex_lock(&priv->mutex);
+	IWL_DEBUG_SCAN(priv, "Scan cancel timeout\n");
 
-		return test_bit(STATUS_SCANNING, &priv->status);
+	iwl_do_scan_abort(priv);
+
+	while (time_before_eq(jiffies, timeout)) {
+		if (!test_bit(STATUS_SCAN_HW, &priv->status))
+			break;
+		msleep(20);
 	}
 
-	return ret;
+	return test_bit(STATUS_SCAN_HW, &priv->status);
 }
 EXPORT_SYMBOL(iwl_scan_cancel_timeout);
 
-- 
1.7.1

