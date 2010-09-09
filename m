Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754331Ab0IINxY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Sep 2010 09:53:24 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 10/12] iwlwifi: assure we complete scan in scan_abort and scan_check works
Date: Thu,  9 Sep 2010 15:52:28 +0200
Message-Id: <1284040354-31703-11-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1284040354-31703-1-git-send-email-sgruszka@redhat.com>
References: <1284040354-31703-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |   14 ++------------
 1 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index fcc826e..df61273 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -490,18 +490,8 @@ static void iwl_bg_scan_check(struct work_struct *data)
 	struct iwl_priv *priv =
 	    container_of(data, struct iwl_priv, scan_check.work);
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
-
 	mutex_lock(&priv->mutex);
-	if (test_bit(STATUS_SCANNING, &priv->status) &&
-	    !test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
-		IWL_DEBUG_SCAN(priv, "Scan completion watchdog (%dms)\n",
-			       jiffies_to_msecs(IWL_SCAN_CHECK_WATCHDOG));
-
-		if (!test_bit(STATUS_EXIT_PENDING, &priv->status))
-			iwl_send_scan_abort(priv);
-	}
+	iwl_scan_cancel_timeout(priv, 200);
 	mutex_unlock(&priv->mutex);
 }
 
@@ -560,7 +550,7 @@ static void iwl_bg_abort_scan(struct work_struct *work)
 	cancel_delayed_work(&priv->scan_check);
 
 	mutex_lock(&priv->mutex);
-	iwl_do_scan_abort(priv);
+	iwl_scan_cancel_timeout(priv, 200);
 	mutex_unlock(&priv->mutex);
 }
 
-- 
1.7.1

