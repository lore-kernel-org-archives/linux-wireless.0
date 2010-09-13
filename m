Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224Ab0IMMqt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Sep 2010 08:46:49 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 10/14] iwlwifi: do not force complete scan too early
Date: Mon, 13 Sep 2010 14:46:41 +0200
Message-Id: <1284382005-3246-11-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1284382005-3246-1-git-send-email-sgruszka@redhat.com>
References: <1284382005-3246-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently we force scan complete at the end of iwl_scan_cancel_timeout
function. This cause race condition when we can get a new scan request
from mac80211 and complete it by iwl_bg_complete from older scan. Change
code to force scan complete only when really needed: device goes down,
interface is removed or scan timeout occurs.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi W Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    6 +++-
 drivers/net/wireless/iwlwifi/iwl-core.c     |    6 +++-
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +
 drivers/net/wireless/iwlwifi/iwl-scan.c     |   38 ++++++++++++++++++++------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 +-
 5 files changed, 41 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 25b3540..4f31f36 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4070,13 +4070,15 @@ static void iwl_cancel_deferred_work(struct iwl_priv *priv)
 		priv->cfg->ops->lib->cancel_deferred_work(priv);
 
 	cancel_delayed_work_sync(&priv->init_alive_start);
-	cancel_delayed_work(&priv->scan_check);
-	cancel_work_sync(&priv->start_internal_scan);
 	cancel_delayed_work(&priv->alive_start);
 	cancel_work_sync(&priv->run_time_calib_work);
 	cancel_work_sync(&priv->beacon_update);
+
+	iwl_cancel_scan_deferred_work(priv);
+
 	cancel_work_sync(&priv->bt_full_concurrency);
 	cancel_work_sync(&priv->bt_runtime_config);
+
 	del_timer_sync(&priv->statistics_periodic);
 	del_timer_sync(&priv->ucode_trace);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 7c1819f..57d157f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2049,8 +2049,10 @@ void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 	WARN_ON(ctx->vif != vif);
 	ctx->vif = NULL;
 
-	if (priv->scan_vif == vif)
-		iwl_scan_cancel_timeout(priv, 100);
+	if (priv->scan_vif == vif) {
+		iwl_scan_cancel_timeout(priv, 200);
+		iwl_force_scan_end(priv);
+	}
 	iwl_set_mode(priv, vif);
 
 	/*
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 8dab074..f1d40c6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -553,6 +553,7 @@ static inline __le32 iwl_hw_set_rate_n_flags(u8 rate, u32 flags)
 void iwl_init_scan_params(struct iwl_priv *priv);
 int iwl_scan_cancel(struct iwl_priv *priv);
 int iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms);
+void iwl_force_scan_end(struct iwl_priv *priv);
 int iwl_mac_hw_scan(struct ieee80211_hw *hw,
 		    struct ieee80211_vif *vif,
 		    struct cfg80211_scan_request *req);
@@ -568,6 +569,7 @@ u16 iwl_get_passive_dwell_time(struct iwl_priv *priv,
 			       enum ieee80211_band band,
 			       struct ieee80211_vif *vif);
 void iwl_setup_scan_deferred_work(struct iwl_priv *priv);
+void iwl_cancel_scan_deferred_work(struct iwl_priv *priv);
 
 /* For faster active scanning, scan will move to the next channel if fewer than
  * PLCP_QUIET_THRESH packets are heard on this channel within
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index da037b2..af9a836 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -106,14 +106,22 @@ static void iwl_complete_scan(struct iwl_priv *priv, bool aborted)
 	priv->scan_request = NULL;
 }
 
-static void iwl_force_scan_end(struct iwl_priv *priv)
+void iwl_force_scan_end(struct iwl_priv *priv)
 {
+	lockdep_assert_held(&priv->mutex);
+
+	if (!test_bit(STATUS_SCANNING, &priv->status)) {
+		IWL_DEBUG_SCAN(priv, "Forcing scan end while not scanning\n");
+		return;
+	}
+
 	IWL_DEBUG_SCAN(priv, "Forcing scan end\n");
 	clear_bit(STATUS_SCANNING, &priv->status);
 	clear_bit(STATUS_SCAN_HW, &priv->status);
 	clear_bit(STATUS_SCAN_ABORTING, &priv->status);
 	iwl_complete_scan(priv, true);
 }
+EXPORT_SYMBOL(iwl_force_scan_end);
 
 static void iwl_do_scan_abort(struct iwl_priv *priv)
 {
@@ -157,7 +165,6 @@ EXPORT_SYMBOL(iwl_scan_cancel);
  */
 int iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms)
 {
-	int ret;
 	unsigned long timeout = jiffies + msecs_to_jiffies(ms);
 
 	lockdep_assert_held(&priv->mutex);
@@ -172,10 +179,7 @@ int iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms)
 		msleep(20);
 	}
 
-	ret = test_bit(STATUS_SCAN_HW, &priv->status);
-	if (ret)
-		iwl_force_scan_end(priv);
-	return ret;
+	return test_bit(STATUS_SCAN_HW, &priv->status);
 }
 EXPORT_SYMBOL(iwl_scan_cancel_timeout);
 
@@ -490,8 +494,11 @@ static void iwl_bg_scan_check(struct work_struct *data)
 	struct iwl_priv *priv =
 	    container_of(data, struct iwl_priv, scan_check.work);
 
+	/* Since we are here firmware does not finish scan and
+	 * most likely is in bad shape, so we don't bother to
+	 * send abort command, just force scan complete to mac80211 */
 	mutex_lock(&priv->mutex);
-	iwl_scan_cancel_timeout(priv, 200);
+	iwl_force_scan_end(priv);
 	mutex_unlock(&priv->mutex);
 }
 
@@ -547,8 +554,8 @@ static void iwl_bg_abort_scan(struct work_struct *work)
 {
 	struct iwl_priv *priv = container_of(work, struct iwl_priv, abort_scan);
 
-	cancel_delayed_work(&priv->scan_check);
-
+	/* We keep scan_check work queued in case when firmware will not
+	 * report back scan completed notification */
 	mutex_lock(&priv->mutex);
 	iwl_scan_cancel_timeout(priv, 200);
 	mutex_unlock(&priv->mutex);
@@ -631,3 +638,16 @@ void iwl_setup_scan_deferred_work(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_setup_scan_deferred_work);
 
+void iwl_cancel_scan_deferred_work(struct iwl_priv *priv)
+{
+	cancel_work_sync(&priv->start_internal_scan);
+	cancel_work_sync(&priv->abort_scan);
+	cancel_work_sync(&priv->scan_completed);
+
+	if (cancel_delayed_work_sync(&priv->scan_check)) {
+		mutex_lock(&priv->mutex);
+		iwl_force_scan_end(priv);
+		mutex_unlock(&priv->mutex);
+	}
+}
+EXPORT_SYMBOL(iwl_cancel_scan_deferred_work);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index fb894d8..6b8f654 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3763,10 +3763,10 @@ static void iwl3945_cancel_deferred_work(struct iwl_priv *priv)
 	iwl3945_hw_cancel_deferred_work(priv);
 
 	cancel_delayed_work_sync(&priv->init_alive_start);
-	cancel_delayed_work(&priv->scan_check);
 	cancel_delayed_work(&priv->alive_start);
-	cancel_work_sync(&priv->start_internal_scan);
 	cancel_work_sync(&priv->beacon_update);
+
+	iwl_cancel_scan_deferred_work(priv);
 }
 
 static struct attribute *iwl3945_sysfs_entries[] = {
-- 
1.7.1

