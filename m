Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab0G1Npg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 09:45:36 -0400
Date: Wed, 28 Jul 2010 15:45:09 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC] iwlwifi: fix scan abort
Message-ID: <20100728154509.77e8e85b@dhcp-lab-109.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We can not call cancel_delayed_work_sync(&priv->scan_check) with 
priv->mutex locked because workqueue function iwl_bg_scan_check()
take that lock internally.

We do not need to synchronize when canceling priv->scan_check work. 
We can avoid races (sending double abort command or send no
command at all) using STATUS_SCAN_ABORT bit. Moreover
current iwl_bg_scan_check() code seems to be broken, as
we should not send abort commands when currently aborting.

I did not test patch yet, just want to know if it is theoretically
correct. Except obvious circular priv->mutex locking fix, maybe it
can help with warning in ieee80211_scan_completed, which is still
reported by the users from time to time.

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 2a7c399..b0c6b04 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -429,11 +429,10 @@ void iwl_bg_scan_check(struct work_struct *data)
 		return;
 
 	mutex_lock(&priv->mutex);
-	if (test_bit(STATUS_SCANNING, &priv->status) ||
-	    test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
-		IWL_DEBUG_SCAN(priv, "Scan completion watchdog resetting "
-			"adapter (%dms)\n",
-			jiffies_to_msecs(IWL_SCAN_CHECK_WATCHDOG));
+	if (test_bit(STATUS_SCANNING, &priv->status) &&
+	    !test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
+		IWL_DEBUG_SCAN(priv, "Scan completion watchdog (%dms)\n",
+			       jiffies_to_msecs(IWL_SCAN_CHECK_WATCHDOG));
 
 		if (!test_bit(STATUS_EXIT_PENDING, &priv->status))
 			iwl_send_scan_abort(priv);
@@ -498,12 +497,11 @@ void iwl_bg_abort_scan(struct work_struct *work)
 	    !test_bit(STATUS_GEO_CONFIGURED, &priv->status))
 		return;
 
-	mutex_lock(&priv->mutex);
-
-	cancel_delayed_work_sync(&priv->scan_check);
-	set_bit(STATUS_SCAN_ABORTING, &priv->status);
-	iwl_send_scan_abort(priv);
+	cancel_delayed_work(&priv->scan_check);
 
+	mutex_lock(&priv->mutex);
+	if (test_bit(STATUS_SCAN_ABORTING, &priv->status))
+		iwl_send_scan_abort(priv);
 	mutex_unlock(&priv->mutex);
 }
 EXPORT_SYMBOL(iwl_bg_abort_scan);
