Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756462Ab0ICMBa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Sep 2010 08:01:30 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 02/13] iwlwifi: unify scan start checks
Date: Fri,  3 Sep 2010 13:57:25 +0200
Message-Id: <1283515056-11523-3-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1283515056-11523-1-git-send-email-sgruszka@redhat.com>
References: <1283515056-11523-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Rather than duplicating all the checks and even
in case of errors accepting the scan request
from mac80211, we can push the checks to the
caller and in all error cases reject the scan
request right away (rather than accepting and
then saying it was aborted).

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |   85 ++++--------------
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c     |  127 ++++++++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   74 ++--------------
 6 files changed, 107 insertions(+), 185 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index bb2aeeb..98509c5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -295,7 +295,7 @@ extern const struct iwl_channel_info *iwl3945_get_channel_info(
 extern int iwl3945_rs_next_rate(struct iwl_priv *priv, int rate);
 
 /* scanning */
-void iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif);
+int iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif);
 
 /* Requires full declaration of iwl_priv before including */
 #include "iwl-io.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 51a8d7e..5a2540e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1154,7 +1154,7 @@ static int iwl_get_channels_for_scan(struct iwl_priv *priv,
 	return added;
 }
 
-void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
+int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 {
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_SCAN_CMD,
@@ -1174,57 +1174,20 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	int  chan_mod;
 	u8 active_chains;
 	u8 scan_tx_antennas = priv->hw_params.valid_tx_ant;
+	int ret;
+
+	lockdep_assert_held(&priv->mutex);
 
 	if (vif)
 		ctx = iwl_rxon_ctx_from_vif(vif);
 
-	cancel_delayed_work(&priv->scan_check);
-
-	if (!iwl_is_ready(priv)) {
-		IWL_WARN(priv, "request scan called when driver not ready.\n");
-		goto done;
-	}
-
-	/* Make sure the scan wasn't canceled before this queued work
-	 * was given the chance to run... */
-	if (!test_bit(STATUS_SCANNING, &priv->status))
-		goto done;
-
-	/* This should never be called or scheduled if there is currently
-	 * a scan active in the hardware. */
-	if (test_bit(STATUS_SCAN_HW, &priv->status)) {
-		IWL_DEBUG_INFO(priv, "Multiple concurrent scan requests in parallel. "
-			       "Ignoring second request.\n");
-		goto done;
-	}
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
-		IWL_DEBUG_SCAN(priv, "Aborting scan due to device shutdown\n");
-		goto done;
-	}
-
-	if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
-		IWL_DEBUG_HC(priv, "Scan request while abort pending.  Queuing.\n");
-		goto done;
-	}
-
-	if (iwl_is_rfkill(priv)) {
-		IWL_DEBUG_HC(priv, "Aborting scan due to RF Kill activation\n");
-		goto done;
-	}
-
-	if (!test_bit(STATUS_READY, &priv->status)) {
-		IWL_DEBUG_HC(priv, "Scan request while uninitialized.  Queuing.\n");
-		goto done;
-	}
-
 	if (!priv->scan_cmd) {
 		priv->scan_cmd = kmalloc(sizeof(struct iwl_scan_cmd) +
 					 IWL_MAX_SCAN_SIZE, GFP_KERNEL);
 		if (!priv->scan_cmd) {
 			IWL_DEBUG_SCAN(priv,
 				       "fail to allocate memory for scan\n");
-			goto done;
+			return -ENOMEM;
 		}
 	}
 	scan = priv->scan_cmd;
@@ -1331,8 +1294,8 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 						IWL_GOOD_CRC_TH_NEVER;
 		break;
 	default:
-		IWL_WARN(priv, "Invalid scan band count\n");
-		goto done;
+		IWL_WARN(priv, "Invalid scan band\n");
+		return -EIO;
 	}
 
 	band = priv->scan_band;
@@ -1412,7 +1375,7 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	}
 	if (scan->channel_count == 0) {
 		IWL_DEBUG_SCAN(priv, "channel count %d\n", scan->channel_count);
-		goto done;
+		return -EIO;
 	}
 
 	cmd.len += le16_to_cpu(scan->tx_cmd.len) +
@@ -1422,28 +1385,20 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 
 	set_bit(STATUS_SCAN_HW, &priv->status);
 
-	if (priv->cfg->ops->hcmd->set_pan_params &&
-	    priv->cfg->ops->hcmd->set_pan_params(priv))
-		goto done;
+	if (priv->cfg->ops->hcmd->set_pan_params) {
+		ret = priv->cfg->ops->hcmd->set_pan_params(priv);
+		if (ret)
+			return ret;
+	}
 
-	if (iwl_send_cmd_sync(priv, &cmd))
-		goto done;
+	ret = iwl_send_cmd_sync(priv, &cmd);
+	if (ret) {
+		clear_bit(STATUS_SCAN_HW, &priv->status);
+		if (priv->cfg->ops->hcmd->set_pan_params)
+			priv->cfg->ops->hcmd->set_pan_params(priv);
+	}
 
-	queue_delayed_work(priv->workqueue, &priv->scan_check,
-			   IWL_SCAN_CHECK_WATCHDOG);
-
-	return;
-
- done:
-	/* Cannot perform scan. Make sure we clear scanning
-	* bits from status so next scan request can be performed.
-	* If we don't clear scanning status bit here all next scan
-	* will fail
-	*/
-	clear_bit(STATUS_SCAN_HW, &priv->status);
-	clear_bit(STATUS_SCANNING, &priv->status);
-	/* inform mac80211 scan aborted */
-	queue_work(priv->workqueue, &priv->scan_completed);
+	return ret;
 }
 
 int iwlagn_manage_ibss_station(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 7c542a8..b0fef62 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -217,7 +217,7 @@ void iwl_reply_statistics(struct iwl_priv *priv,
 			  struct iwl_rx_mem_buffer *rxb);
 
 /* scan */
-void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif);
+int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif);
 
 /* station mgmt */
 int iwlagn_manage_ibss_station(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index f7b57ed..8dab074 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -111,7 +111,7 @@ struct iwl_hcmd_utils_ops {
 				  __le16 fc, __le32 *tx_flags);
 	int  (*calc_rssi)(struct iwl_priv *priv,
 			  struct iwl_rx_phy_res *rx_resp);
-	void (*request_scan)(struct iwl_priv *priv, struct ieee80211_vif *vif);
+	int (*request_scan)(struct iwl_priv *priv, struct ieee80211_vif *vif);
 };
 
 struct iwl_apm_ops {
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 7727f09..01a4907 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -324,19 +324,68 @@ void iwl_init_scan_params(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_init_scan_params);
 
-static int iwl_scan_initiate(struct iwl_priv *priv, struct ieee80211_vif *vif)
+static int __must_check iwl_scan_initiate(struct iwl_priv *priv,
+					  struct ieee80211_vif *vif,
+					  bool internal,
+					  enum nl80211_band band)
 {
+	int ret;
+
 	lockdep_assert_held(&priv->mutex);
 
-	IWL_DEBUG_INFO(priv, "Starting scan...\n");
+	if (WARN_ON(!priv->cfg->ops->utils->request_scan))
+		return -EOPNOTSUPP;
+
+	cancel_delayed_work(&priv->scan_check);
+
+	if (!iwl_is_ready(priv)) {
+		IWL_WARN(priv, "request scan called when driver not ready.\n");
+		return -EIO;
+	}
+
+	if (test_bit(STATUS_SCAN_HW, &priv->status)) {
+		IWL_DEBUG_INFO(priv,
+			"Multiple concurrent scan requests in parallel.\n");
+		return -EBUSY;
+	}
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
+		IWL_DEBUG_SCAN(priv, "Aborting scan due to device shutdown\n");
+		return -EIO;
+	}
+
+	if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
+		IWL_DEBUG_HC(priv, "Scan request while abort pending.\n");
+		return -EBUSY;
+	}
+
+	if (iwl_is_rfkill(priv)) {
+		IWL_DEBUG_HC(priv, "Aborting scan due to RF Kill activation\n");
+		return -EIO;
+	}
+
+	if (!test_bit(STATUS_READY, &priv->status)) {
+		IWL_DEBUG_HC(priv, "Scan request while uninitialized.\n");
+		return -EBUSY;
+	}
+
+	IWL_DEBUG_INFO(priv, "Starting %sscan...\n",
+			internal ? "internal short " : "");
+
 	set_bit(STATUS_SCANNING, &priv->status);
-	priv->is_internal_short_scan = false;
+
+	priv->is_internal_short_scan = internal;
 	priv->scan_start = jiffies;
+	priv->scan_band = band;
 
-	if (WARN_ON(!priv->cfg->ops->utils->request_scan))
-		return -EOPNOTSUPP;
+	ret = priv->cfg->ops->utils->request_scan(priv, vif);
+	if (ret) {
+		clear_bit(STATUS_SCANNING, &priv->status);
+		return ret;
+	}
 
-	priv->cfg->ops->utils->request_scan(priv, vif);
+	queue_delayed_work(priv->workqueue, &priv->scan_check,
+			   IWL_SCAN_CHECK_WATCHDOG);
 
 	return 0;
 }
@@ -355,12 +404,6 @@ int iwl_mac_hw_scan(struct ieee80211_hw *hw,
 
 	mutex_lock(&priv->mutex);
 
-	if (!iwl_is_ready_rf(priv)) {
-		ret = -EIO;
-		IWL_DEBUG_MAC80211(priv, "leave - not ready or exit pending\n");
-		goto out_unlock;
-	}
-
 	if (test_bit(STATUS_SCANNING, &priv->status) &&
 	    !priv->is_internal_short_scan) {
 		IWL_DEBUG_SCAN(priv, "Scan already in progress.\n");
@@ -368,14 +411,7 @@ int iwl_mac_hw_scan(struct ieee80211_hw *hw,
 		goto out_unlock;
 	}
 
-	if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
-		IWL_DEBUG_SCAN(priv, "Scan request while abort pending\n");
-		ret = -EAGAIN;
-		goto out_unlock;
-	}
-
 	/* mac80211 will only ask for one band at a time */
-	priv->scan_band = req->channels[0]->band;
 	priv->scan_request = req;
 	priv->scan_vif = vif;
 
@@ -386,7 +422,8 @@ int iwl_mac_hw_scan(struct ieee80211_hw *hw,
 	if (priv->is_internal_short_scan)
 		ret = 0;
 	else
-		ret = iwl_scan_initiate(priv, vif);
+		ret = iwl_scan_initiate(priv, vif, false,
+					req->channels[0]->band);
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 
@@ -418,31 +455,13 @@ static void iwl_bg_start_internal_scan(struct work_struct *work)
 		goto unlock;
 	}
 
-	if (!iwl_is_ready_rf(priv)) {
-		IWL_DEBUG_SCAN(priv, "not ready or exit pending\n");
-		goto unlock;
-	}
-
 	if (test_bit(STATUS_SCANNING, &priv->status)) {
 		IWL_DEBUG_SCAN(priv, "Scan already in progress.\n");
 		goto unlock;
 	}
 
-	if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
-		IWL_DEBUG_SCAN(priv, "Scan request while abort pending\n");
-		goto unlock;
-	}
-
-	priv->scan_band = priv->band;
-
-	IWL_DEBUG_SCAN(priv, "Start internal short scan...\n");
-	set_bit(STATUS_SCANNING, &priv->status);
-	priv->is_internal_short_scan = true;
-
-	if (WARN_ON(!priv->cfg->ops->utils->request_scan))
-		goto unlock;
-
-	priv->cfg->ops->utils->request_scan(priv, NULL);
+	if (iwl_scan_initiate(priv, NULL, true, priv->band))
+		IWL_DEBUG_SCAN(priv, "failed to start internal short scan\n");
  unlock:
 	mutex_unlock(&priv->mutex);
 }
@@ -536,7 +555,6 @@ static void iwl_bg_scan_completed(struct work_struct *work)
 	struct iwl_priv *priv =
 	    container_of(work, struct iwl_priv, scan_completed);
 	bool internal = false;
-	bool scan_completed = false;
 	struct iwl_rxon_context *ctx;
 
 	IWL_DEBUG_SCAN(priv, "SCAN complete scan\n");
@@ -549,16 +567,27 @@ static void iwl_bg_scan_completed(struct work_struct *work)
 		IWL_DEBUG_SCAN(priv, "internal short scan completed\n");
 		internal = true;
 	} else if (priv->scan_request) {
-		scan_completed = true;
 		priv->scan_request = NULL;
 		priv->scan_vif = NULL;
+		ieee80211_scan_completed(priv->hw, false);
 	}
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		goto out;
 
-	if (internal && priv->scan_request)
-		iwl_scan_initiate(priv, priv->scan_vif);
+	if (internal && priv->scan_request) {
+		int err = iwl_scan_initiate(priv, priv->scan_vif, false,
+					priv->scan_request->channels[0]->band);
+
+		if (err) {
+			IWL_DEBUG_SCAN(priv,
+				"failed to initiate pending scan: %d\n", err);
+			priv->scan_request = NULL;
+			priv->scan_vif = NULL;
+			ieee80211_scan_completed(priv->hw, true);
+		} else
+			goto out;
+	}
 
 	/* Since setting the TXPOWER may have been deferred while
 	 * performing the scan, fire one off */
@@ -571,19 +600,11 @@ static void iwl_bg_scan_completed(struct work_struct *work)
 	for_each_context(priv, ctx)
 		iwlcore_commit_rxon(priv, ctx);
 
- out:
 	if (priv->cfg->ops->hcmd->set_pan_params)
 		priv->cfg->ops->hcmd->set_pan_params(priv);
 
+ out:
 	mutex_unlock(&priv->mutex);
-
-	/*
-	 * Do not hold mutex here since this will cause mac80211 to call
-	 * into driver again into functions that will attempt to take
-	 * mutex.
-	 */
-	if (scan_completed)
-		ieee80211_scan_completed(priv->hw, false);
 }
 
 void iwl_setup_scan_deferred_work(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 5b742eb..3b3686b 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2817,7 +2817,7 @@ static void iwl3945_rfkill_poll(struct work_struct *data)
 
 }
 
-void iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
+int iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 {
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_SCAN_CMD,
@@ -2828,55 +2828,16 @@ void iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	u8 n_probes = 0;
 	enum ieee80211_band band;
 	bool is_active = false;
+	int ret;
 
-	cancel_delayed_work(&priv->scan_check);
-
-	if (!iwl_is_ready(priv)) {
-		IWL_WARN(priv, "request scan called when driver not ready.\n");
-		goto done;
-	}
-
-	/* Make sure the scan wasn't canceled before this queued work
-	 * was given the chance to run... */
-	if (!test_bit(STATUS_SCANNING, &priv->status))
-		goto done;
-
-	/* This should never be called or scheduled if there is currently
-	 * a scan active in the hardware. */
-	if (test_bit(STATUS_SCAN_HW, &priv->status)) {
-		IWL_DEBUG_INFO(priv, "Multiple concurrent scan requests  "
-				"Ignoring second request.\n");
-		goto done;
-	}
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
-		IWL_DEBUG_SCAN(priv, "Aborting scan due to device shutdown\n");
-		goto done;
-	}
-
-	if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
-		IWL_DEBUG_HC(priv,
-			"Scan request while abort pending. Queuing.\n");
-		goto done;
-	}
-
-	if (iwl_is_rfkill(priv)) {
-		IWL_DEBUG_HC(priv, "Aborting scan due to RF Kill activation\n");
-		goto done;
-	}
-
-	if (!test_bit(STATUS_READY, &priv->status)) {
-		IWL_DEBUG_HC(priv,
-			"Scan request while uninitialized. Queuing.\n");
-		goto done;
-	}
+	lockdep_assert_held(&priv->mutex);
 
 	if (!priv->scan_cmd) {
 		priv->scan_cmd = kmalloc(sizeof(struct iwl3945_scan_cmd) +
 					 IWL_MAX_SCAN_SIZE, GFP_KERNEL);
 		if (!priv->scan_cmd) {
 			IWL_DEBUG_SCAN(priv, "Fail to allocate scan memory\n");
-			goto done;
+			return -ENOMEM;
 		}
 	}
 	scan = priv->scan_cmd;
@@ -2971,7 +2932,7 @@ void iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		break;
 	default:
 		IWL_WARN(priv, "Invalid scan band\n");
-		goto done;
+		return -EIO;
 	}
 
 	if (!priv->is_internal_short_scan) {
@@ -3006,7 +2967,7 @@ void iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 
 	if (scan->channel_count == 0) {
 		IWL_DEBUG_SCAN(priv, "channel count %d\n", scan->channel_count);
-		goto done;
+		return -EIO;
 	}
 
 	cmd.len += le16_to_cpu(scan->tx_cmd.len) +
@@ -3015,25 +2976,10 @@ void iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	scan->len = cpu_to_le16(cmd.len);
 
 	set_bit(STATUS_SCAN_HW, &priv->status);
-	if (iwl_send_cmd_sync(priv, &cmd))
-		goto done;
-
-	queue_delayed_work(priv->workqueue, &priv->scan_check,
-			   IWL_SCAN_CHECK_WATCHDOG);
-
-	return;
-
- done:
-	/* can not perform scan make sure we clear scanning
-	 * bits from status so next scan request can be performed.
-	 * if we dont clear scanning status bit here all next scan
-	 * will fail
-	*/
-	clear_bit(STATUS_SCAN_HW, &priv->status);
-	clear_bit(STATUS_SCANNING, &priv->status);
-
-	/* inform mac80211 scan aborted */
-	queue_work(priv->workqueue, &priv->scan_completed);
+	ret = iwl_send_cmd_sync(priv, &cmd);
+	if (ret)
+		clear_bit(STATUS_SCAN_HW, &priv->status);
+	return ret;
 }
 
 static void iwl3945_bg_restart(struct work_struct *data)
-- 
1.7.1

