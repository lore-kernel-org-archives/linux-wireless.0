Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932101Ab0ICMB4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Sep 2010 08:01:56 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 08/13] iwlwifi: avoid dropping muttex in iwl_scan_cancel_timeout
Date: Fri,  3 Sep 2010 13:57:31 +0200
Message-Id: <1283515056-11523-9-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1283515056-11523-1-git-send-email-sgruszka@redhat.com>
References: <1283515056-11523-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't drop mutex when waiting for scan complete. Use STATUS_HW_SCAN bit
to check if scanning is currency pending, because STATUS_SCANNING will
be cleared only with priv->mutex taken.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 6ab7bb3..7e4faaf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -138,22 +138,21 @@ EXPORT_SYMBOL(iwl_scan_cancel);
  */
 int iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms)
 {
-	unsigned long now = jiffies;
+	unsigned long timeout = jiffies + msecs_to_jiffies(ms);
 
 	lockdep_assert_held(&priv->mutex);
 
-	iwl_do_scan_abort(priv);
+	IWL_DEBUG_SCAN(priv, "Scan cancel timeout\n");
 
-	if (ms) {
-		mutex_unlock(&priv->mutex);
-		while (!time_after(jiffies, now + msecs_to_jiffies(ms)) &&
-				test_bit(STATUS_SCANNING, &priv->status))
-			msleep(20);
-		mutex_lock(&priv->mutex);
+	iwl_do_scan_abort(priv);
 
+	while (time_before_eq(jiffies, timeout)) {
+		if (!test_bit(STATUS_SCAN_HW, &priv->status))
+			break;
+		msleep(20);
 	}
 
-	return test_bit(STATUS_SCANNING, &priv->status);
+	return test_bit(STATUS_SCAN_HW, &priv->status);
 }
 EXPORT_SYMBOL(iwl_scan_cancel_timeout);
 
-- 
1.7.1

