Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932438Ab0ICMB6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Sep 2010 08:01:58 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 07/13] iwlwifi: do not queue abort_scan work if can sleep
Date: Fri,  3 Sep 2010 13:57:30 +0200
Message-Id: <1283515056-11523-8-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1283515056-11523-1-git-send-email-sgruszka@redhat.com>
References: <1283515056-11523-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since on timeout version of iwl_scan_cancel procedure we can sleep,
do not have to schedule abort_scan work to begin and perform scanning,
can do this directly. Also now, as we do not queue abort_scan from
restart work anymore, we can queue abort_scan to priv->workqueue.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 4d2a09b..6ab7bb3 100644
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
@@ -135,25 +135,25 @@ EXPORT_SYMBOL(iwl_scan_cancel);
  * iwl_scan_cancel_timeout - Cancel any currently executing HW scan
  * @ms: amount of time to wait (in milliseconds) for scan to abort
  *
- * NOTE: priv->mutex must be held before calling this function
  */
 int iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms)
 {
 	unsigned long now = jiffies;
-	int ret;
 
-	ret = iwl_scan_cancel(priv);
-	if (ret && ms) {
+	lockdep_assert_held(&priv->mutex);
+
+	iwl_do_scan_abort(priv);
+
+	if (ms) {
 		mutex_unlock(&priv->mutex);
 		while (!time_after(jiffies, now + msecs_to_jiffies(ms)) &&
 				test_bit(STATUS_SCANNING, &priv->status))
-			msleep(1);
+			msleep(20);
 		mutex_lock(&priv->mutex);
 
-		return test_bit(STATUS_SCANNING, &priv->status);
 	}
 
-	return ret;
+	return test_bit(STATUS_SCANNING, &priv->status);
 }
 EXPORT_SYMBOL(iwl_scan_cancel_timeout);
 
-- 
1.7.1

