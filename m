Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:50173 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754687AbZEOXHM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 19:07:12 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH v2.6.30] iwlwifi:  do not cancel delayed work inside spin_lock_irqsave
Date: Fri, 15 May 2009 16:13:46 -0700
Message-Id: <1242429226-8313-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1242429226-8313-4-git-send-email-reinette.chatre@intel.com>
References: <1242429226-8313-1-git-send-email-reinette.chatre@intel.com>
 <1242429226-8313-2-git-send-email-reinette.chatre@intel.com>
 <1242429226-8313-3-git-send-email-reinette.chatre@intel.com>
 <1242429226-8313-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

Calling cancel_delayed_work() from inside
spin_lock_irqsave, introduces a potential deadlock.

As explained by Johannes Berg <johannes@sipsolutions.net>

A - lock
T - timer

phase                   CPU 1           CPU 2
---------------------------------------------

some place that calls
cancel_timer_sync()
(which is the | code)
                                        lock-irq(A)
|                                       "lock-irq"(T)
|                                       "unlock"(T)
|                                       wait(T)
                                        unlock(A)

timer softirq
                        "lock"(T)
                        run(T)
                        "unlock"(T)

irq handler
          lock(A)
          unlock(A)

Now all that again, interleaved, leading to deadlock:

                                        lock-irq(A)
                        "lock"(T)
                         run(T)
IRQ during or maybe
before run(T) -->        lock(A)
                                        "lock-irq"(T)
                                        wait(T)

We fix this by moving the call to cancel_delayed_work() into workqueue.
There are cases where the work may not actually be queued or running
at the time we are trying to cancel it, but cancel_delayed_work() is
able to deal with this.

Also cleanup iwl_set_mode related to this call. This function
(iwl_set_mode) is only called when bringing interface up and there will
thus not be any scanning done. No need to try to cancel scanning.

Fixes http://bugzilla.kernel.org/show_bug.cgi?id=13224, which was also
reported at http://marc.info/?l=linux-wireless&m=124081921903223&w=2 .

Tested-by: Miles Lane <miles.lane@gmail.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Acked-by: Zhu Yi <yi.zhu@intel.com>

---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    7 -------
 drivers/net/wireless/iwlwifi/iwl-scan.c     |    7 ++++---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    9 ++-------
 3 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 1ef4192..0e6e7ff 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -669,13 +669,6 @@ static int iwl_set_mode(struct iwl_priv *priv, int mode)
 	if (!iwl_is_ready_rf(priv))
 		return -EAGAIN;
 
-	cancel_delayed_work(&priv->scan_check);
-	if (iwl_scan_cancel_timeout(priv, 100)) {
-		IWL_WARN(priv, "Aborted scan still in progress after 100ms\n");
-		IWL_DEBUG_MAC80211(priv, "leaving - scan abort failed.\n");
-		return -EAGAIN;
-	}
-
 	iwl_commit_rxon(priv);
 
 	return 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 23644cf..a879e9c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -227,9 +227,6 @@ static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 	/* The HW is no longer scanning */
 	clear_bit(STATUS_SCAN_HW, &priv->status);
 
-	/* The scan completion notification came in, so kill that timer... */
-	cancel_delayed_work(&priv->scan_check);
-
 	IWL_DEBUG_INFO(priv, "Scan pass on %sGHz took %dms\n",
 		       (priv->scan_bands & BIT(IEEE80211_BAND_2GHZ)) ?
 						"2.4" : "5.2",
@@ -712,6 +709,8 @@ static void iwl_bg_request_scan(struct work_struct *data)
 
 	mutex_lock(&priv->mutex);
 
+	cancel_delayed_work(&priv->scan_check);
+
 	if (!iwl_is_ready(priv)) {
 		IWL_WARN(priv, "request scan called when driver not ready.\n");
 		goto done;
@@ -925,6 +924,8 @@ void iwl_bg_scan_completed(struct work_struct *work)
 
 	IWL_DEBUG_SCAN(priv, "SCAN complete scan\n");
 
+	cancel_delayed_work(&priv->scan_check);
+
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 617c423..12a2d35 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -782,13 +782,6 @@ static int iwl3945_set_mode(struct iwl_priv *priv, int mode)
 	if (!iwl_is_ready_rf(priv))
 		return -EAGAIN;
 
-	cancel_delayed_work(&priv->scan_check);
-	if (iwl_scan_cancel_timeout(priv, 100)) {
-		IWL_WARN(priv, "Aborted scan still in progress after 100ms\n");
-		IWL_DEBUG_MAC80211(priv, "leaving - scan abort failed.\n");
-		return -EAGAIN;
-	}
-
 	iwl3945_commit_rxon(priv);
 
 	return 0;
@@ -3300,6 +3293,8 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 
 	mutex_lock(&priv->mutex);
 
+	cancel_delayed_work(&priv->scan_check);
+
 	if (!iwl_is_ready(priv)) {
 		IWL_WARN(priv, "request scan called when driver not ready.\n");
 		goto done;
-- 
1.5.6.3

