Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998Ab0HIQCK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Aug 2010 12:02:10 -0400
Date: Mon, 9 Aug 2010 18:02:03 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC PATCH] iwlwifi: abort scan when restarting
Message-ID: <20100809160203.GA22569@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have to cancel hw scan when restarting device, otherwise we can get
WARNING: at net/wireless/core.c:614 wdev_cleanup_work+0xb7/0xf0
After warning, any further scan request from cfg80211 are ignored by
mac80211 with EBUSY error, because from mac80211 perspective we still
are performing scanning. This looks like wireless device hung, as
NetworkManager can not perform successful scan and not allow to
establish a new connection.

When firmware die we can not send any new command to device, in
such case we just call ieee80211_scan_completed(priv->hw, true)
to finish scanning in mac80211.

iwl_scan_cancel_timeout() will not success if we are performing it
from work handler, because workqueue can not fire new work when
still other one is performed. To prevent such situation
schedule priv->abort_scan to generic workqueue. Also increase
sleep time to have better change abort_scan work complete.

Additionally print message when iwl_scan_cancel_timeout() fail.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
Patch was compile tested only on wireless-testing tree as this
tree hangs on my machine (without the patch, and I did not
have time to investigate that hang). I tested a bit modified 
patch on older kernel.
 
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   11 +++++++++++
 drivers/net/wireless/iwlwifi/iwl-scan.c     |    9 +++++----
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   11 +++++++++++
 3 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 35337b1..b6dfeaf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3047,13 +3047,24 @@ static void iwl_bg_restart(struct work_struct *data)
 		return;
 
 	if (test_and_clear_bit(STATUS_FW_ERROR, &priv->status)) {
+		bool scan_pending = false;
+
 		mutex_lock(&priv->mutex);
 		priv->vif = NULL;
 		priv->is_open = 0;
+		if (test_bit(STATUS_SCANNING, &priv->status) &&
+		    !priv->is_internal_short_scan)
+			scan_pending = true;
 		mutex_unlock(&priv->mutex);
+
+		if (scan_pending)
+			ieee80211_scan_completed(priv->hw, true);
 		iwl_down(priv);
 		ieee80211_restart_hw(priv->hw);
 	} else {
+		mutex_lock(&priv->mutex);
+		iwl_scan_cancel_timeout(priv, 200);
+		mutex_unlock(&priv->mutex);
 		iwl_down(priv);
 
 		if (test_bit(STATUS_EXIT_PENDING, &priv->status))
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index a4b3663..33ed3c8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -71,8 +71,7 @@ int iwl_scan_cancel(struct iwl_priv *priv)
 	if (test_bit(STATUS_SCANNING, &priv->status)) {
 		if (!test_and_set_bit(STATUS_SCAN_ABORTING, &priv->status)) {
 			IWL_DEBUG_SCAN(priv, "Queuing scan abort.\n");
-			queue_work(priv->workqueue, &priv->abort_scan);
-
+ 			schedule_work(&priv->abort_scan);
 		} else
 			IWL_DEBUG_SCAN(priv, "Scan abort already in progress.\n");
 
@@ -98,12 +97,14 @@ int iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms)
 		mutex_unlock(&priv->mutex);
 		while (!time_after(jiffies, now + msecs_to_jiffies(ms)) &&
 				test_bit(STATUS_SCANNING, &priv->status))
-			msleep(1);
+			msleep(10);
 		mutex_lock(&priv->mutex);
 
-		return test_bit(STATUS_SCANNING, &priv->status);
+		ret = test_bit(STATUS_SCANNING, &priv->status);
 	}
 
+	if (ret)
+		IWL_WARN(priv, "Could not cancel scan after %lu ms\n", ms);
 	return ret;
 }
 EXPORT_SYMBOL(iwl_scan_cancel_timeout);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index d24eb47..22e3738 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3032,13 +3032,24 @@ static void iwl3945_bg_restart(struct work_struct *data)
 		return;
 
 	if (test_and_clear_bit(STATUS_FW_ERROR, &priv->status)) {
+		bool scan_pending = false;
+
 		mutex_lock(&priv->mutex);
 		priv->vif = NULL;
 		priv->is_open = 0;
+		if (test_bit(STATUS_SCANNING, &priv->status) &&
+		    !priv->is_internal_short_scan)
+			scan_pending = true;
 		mutex_unlock(&priv->mutex);
+
+		if (scan_pending)
+			ieee80211_scan_completed(priv->hw, true);
 		iwl3945_down(priv);
 		ieee80211_restart_hw(priv->hw);
 	} else {
+		mutex_lock(&priv->mutex);
+		iwl_scan_cancel_timeout(priv, 200);
+		mutex_unlock(&priv->mutex);
 		iwl3945_down(priv);
 
 		if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-- 
1.5.5.6

