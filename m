Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121Ab0HTNdq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Aug 2010 09:33:46 -0400
Date: Fri, 20 Aug 2010 15:32:27 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC] iwlwifi: rewrite iwl-scan.c to avoid race conditions
Message-ID: <20100820133226.GB4725@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In this patch I'm trying to avoid hardware scanning race conditions
that may lead to not call ieee80211_scan_completed() (what in
consequences gives "WARNING: at net/wireless/core.c:614
wdev_cleanup_work+0xb7/0xf0"), or call iee80211_scan_completed() more
then once (what gives " WARNING: at net/mac80211/scan.c:312
ieee80211_scan_completed+0x5f/0x1f1").

First problem (warning in wdev_cleanup_work) make any further scan
request from cfg80211 are ignored by mac80211 with EBUSY error,
hence Networkmanager can not perform successful scan and not allow
to establish new connection. So after suspend/resume (but maybe
not only then) user is not able to connect to wireless network again.

We can not relay on that the commands (start and abort scan) are
successful. Even if they are successfully send to the hardware, we can
not get back notification from firmware (i.e. firmware hung or it was
reseted), or we can get notification when we actually perform abort
scan in driver code or after that.

To assure we call ieee80211_scan_completed() only once when scan
was started we use SCAN_SCANNING bit. Code path, which first clear
STATUS_SCANNING bit will call ieee80211_scan_completed().
We do this in many cases, in scan complete notification, scan
abort and timeout, firmware reset, etc. each time we check SCANNING bit.

Note: there are still some race conditions. I commented them in code,
I'm still working on that problems.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |   70 +----
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   14 +
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.c     |   16 +-
 drivers/net/wireless/iwlwifi/iwl-core.h     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c     |  453 +++++++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-sta.c      |    6 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   87 ++----
 9 files changed, 322 insertions(+), 332 deletions(-)

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
index eedd71f..29a5e8f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1147,7 +1147,7 @@ static int iwl_get_channels_for_scan(struct iwl_priv *priv,
 	return added;
 }
 
-void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
+int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 {
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_SCAN_CMD,
@@ -1155,7 +1155,6 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		.flags = CMD_SIZE_HUGE,
 	};
 	struct iwl_scan_cmd *scan;
-	struct ieee80211_conf *conf = NULL;
 	u32 rate_flags = 0;
 	u16 cmd_len;
 	u16 rx_chain = 0;
@@ -1167,48 +1166,7 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	int  chan_mod;
 	u8 active_chains;
 	u8 scan_tx_antennas = priv->hw_params.valid_tx_ant;
-
-	conf = ieee80211_get_hw_conf(priv->hw);
-
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
+	int ret = -ENOMEM;
 
 	if (!priv->scan_cmd) {
 		priv->scan_cmd = kmalloc(sizeof(struct iwl_scan_cmd) +
@@ -1315,7 +1273,8 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 						IWL_GOOD_CRC_TH_NEVER;
 		break;
 	default:
-		IWL_WARN(priv, "Invalid scan band count\n");
+		IWL_WARN(priv, "Invalid scan band\n");
+		ret = -EINVAL;
 		goto done;
 	}
 
@@ -1385,6 +1344,7 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	}
 	if (scan->channel_count == 0) {
 		IWL_DEBUG_SCAN(priv, "channel count %d\n", scan->channel_count);
+		ret = -EIO;
 		goto done;
 	}
 
@@ -1394,24 +1354,12 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	scan->len = cpu_to_le16(cmd.len);
 
 	set_bit(STATUS_SCAN_HW, &priv->status);
-	if (iwl_send_cmd_sync(priv, &cmd))
-		goto done;
-
-	queue_delayed_work(priv->workqueue, &priv->scan_check,
-			   IWL_SCAN_CHECK_WATCHDOG);
-
-	return;
+	ret = iwl_send_cmd_sync(priv, &cmd);
+	if (ret)
+		clear_bit(STATUS_SCAN_HW, &priv->status);
 
  done:
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
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 26bc048..7602765 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3075,13 +3075,27 @@ static void iwl_bg_restart(struct work_struct *data)
 		return;
 
 	if (test_and_clear_bit(STATUS_FW_ERROR, &priv->status)) {
+		bool scan_pending = false;
+
 		mutex_lock(&priv->mutex);
 		priv->vif = NULL;
 		priv->is_open = 0;
+		if (test_bit(STATUS_SCANNING, &priv->status) &&
+		    !priv->is_internal_short_scan) {
+			scan_pending = true;
+			clear_bit(STATUS_SCAN_HW, &priv->status);
+			clear_bit(STATUS_SCAN_ABORTING, &priv->status);
+		}
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
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index cc6464d..4d51c85 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -216,7 +216,7 @@ void iwl_reply_statistics(struct iwl_priv *priv,
 			  struct iwl_rx_mem_buffer *rxb);
 
 /* scan */
-void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif);
+int  iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif);
 
 /* station mgmt */
 int iwlagn_manage_ibss_station(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 3d9443b..11a7ebd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1704,8 +1704,8 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 		 * background then we need to cancel it else the RXON
 		 * below/in post_associate will fail.
 		 */
-		if (iwl_scan_cancel_timeout(priv, 100)) {
-			IWL_WARN(priv, "Aborted scan still in progress after 100ms\n");
+		if (iwl_scan_cancel_timeout(priv, 200)) {
+			IWL_WARN(priv, "Aborted scan still in progress after 200ms\n");
 			IWL_DEBUG_MAC80211(priv, "leaving - scan abort failed.\n");
 			mutex_unlock(&priv->mutex);
 			return;
@@ -1894,20 +1894,20 @@ void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 
 	mutex_lock(&priv->mutex);
 
+	iwl_scan_cancel_timeout(priv, 100);
+	if (test_and_clear_bit(STATUS_SCANNING, &priv->status))
+		scan_completed = true;
+
 	if (iwl_is_ready_rf(priv)) {
-		iwl_scan_cancel_timeout(priv, 100);
 		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 		iwlcore_commit_rxon(priv);
 	}
+
 	if (priv->vif == vif) {
 		priv->vif = NULL;
-		if (priv->scan_vif == vif) {
-			scan_completed = true;
-			priv->scan_vif = NULL;
-			priv->scan_request = NULL;
-		}
 		memset(priv->bssid, 0, ETH_ALEN);
 	}
+
 	mutex_unlock(&priv->mutex);
 
 	if (scan_completed)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 7b1e832..cc7375b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -109,7 +109,7 @@ struct iwl_hcmd_utils_ops {
 				  __le16 fc, __le32 *tx_flags);
 	int  (*calc_rssi)(struct iwl_priv *priv,
 			  struct iwl_rx_phy_res *rx_resp);
-	void (*request_scan)(struct iwl_priv *priv, struct ieee80211_vif *vif);
+	int (*request_scan)(struct iwl_priv *priv, struct ieee80211_vif *vif);
 };
 
 struct iwl_apm_ops {
@@ -538,7 +538,7 @@ static inline __le32 iwl_hw_set_rate_n_flags(u8 rate, u32 flags)
  * Scanning
  ******************************************************************************/
 void iwl_init_scan_params(struct iwl_priv *priv);
-int iwl_scan_cancel(struct iwl_priv *priv);
+void iwl_scan_cancel(struct iwl_priv *priv);
 int iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms);
 int iwl_mac_hw_scan(struct ieee80211_hw *hw,
 		    struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 8d7fa59..8cc64dc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -54,82 +54,28 @@
 #define IWL_PASSIVE_DWELL_BASE      (100)
 #define IWL_CHANNEL_TUNE_TIME       5
 
-
-
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
-	}
-
-	if (test_bit(STATUS_SCANNING, &priv->status)) {
-		if (!test_and_set_bit(STATUS_SCAN_ABORTING, &priv->status)) {
-			IWL_DEBUG_SCAN(priv, "Queuing scan abort.\n");
-			queue_work(priv->workqueue, &priv->abort_scan);
-
-		} else
-			IWL_DEBUG_SCAN(priv, "Scan abort already in progress.\n");
-
-		return test_bit(STATUS_SCANNING, &priv->status);
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL(iwl_scan_cancel);
-/**
- * iwl_scan_cancel_timeout - Cancel any currently executing HW scan
- * @ms: amount of time to wait (in milliseconds) for scan to abort
- *
- * NOTE: priv->mutex must be held before calling this function
- */
-int iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms)
-{
-	unsigned long now = jiffies;
-	int ret;
-
-	ret = iwl_scan_cancel(priv);
-	if (ret && ms) {
-		mutex_unlock(&priv->mutex);
-		while (!time_after(jiffies, now + msecs_to_jiffies(ms)) &&
-				test_bit(STATUS_SCANNING, &priv->status))
-			msleep(1);
-		mutex_lock(&priv->mutex);
-
-		return test_bit(STATUS_SCANNING, &priv->status);
-	}
-
-	return ret;
-}
-EXPORT_SYMBOL(iwl_scan_cancel_timeout);
-
 static int iwl_send_scan_abort(struct iwl_priv *priv)
 {
-	int ret = 0;
+	int ret;
 	struct iwl_rx_packet *pkt;
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_SCAN_ABORT_CMD,
 		.flags = CMD_WANT_SKB,
 	};
 
-	/* If there isn't a scan actively going on in the hardware
-	 * then we are in between scan bands and not actually
-	 * actively scanning, so don't send the abort command */
-	if (!test_bit(STATUS_SCAN_HW, &priv->status)) {
-		clear_bit(STATUS_SCAN_ABORTING, &priv->status);
-		return 0;
-	}
+	/* Exit instantly with error when device is not ready
+	 * to receive scan abort command or it does not perform
+	 * hardware scan currently */
+	if (!test_bit(STATUS_READY, &priv->status) ||
+	    !test_bit(STATUS_GEO_CONFIGURED, &priv->status) ||
+	    !test_bit(STATUS_SCAN_HW, &priv->status) ||
+	    test_bit(STATUS_FW_ERROR, &priv->status) ||
+	    test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return -EIO;
 
 	ret = iwl_send_cmd_sync(priv, &cmd);
-	if (ret) {
-		clear_bit(STATUS_SCAN_ABORTING, &priv->status);
+	if (ret)
 		return ret;
-	}
 
 	pkt = (struct iwl_rx_packet *)cmd.reply_page;
 	if (pkt->u.status != CAN_ABORT_STATUS) {
@@ -140,8 +86,7 @@ static int iwl_send_scan_abort(struct iwl_priv *priv)
 		 * the microcode has notified us that a scan is
 		 * completed. */
 		IWL_DEBUG_INFO(priv, "SCAN_ABORT returned %d.\n", pkt->u.status);
-		clear_bit(STATUS_SCAN_ABORTING, &priv->status);
-		clear_bit(STATUS_SCAN_HW, &priv->status);
+		ret = -EIO;
 	}
 
 	iwl_free_pages(priv, cmd.reply_page);
@@ -158,7 +103,7 @@ static void iwl_rx_reply_scan(struct iwl_priv *priv,
 	struct iwl_scanreq_notification *notif =
 	    (struct iwl_scanreq_notification *)pkt->u.raw;
 
-	IWL_DEBUG_RX(priv, "Scan request status = 0x%x\n", notif->status);
+	IWL_DEBUG_SCAN(priv, "Scan request status = 0x%x\n", notif->status);
 #endif
 }
 
@@ -224,18 +169,6 @@ static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 		       jiffies_to_msecs(elapsed_jiffies
 					(priv->scan_start, jiffies)));
 
-	/*
-	 * If a request to abort was given, or the scan did not succeed
-	 * then we reset the scan state machine and terminate,
-	 * re-queuing another scan if one has been requested
-	 */
-	if (test_and_clear_bit(STATUS_SCAN_ABORTING, &priv->status))
-		IWL_DEBUG_INFO(priv, "Aborted scan completed.\n");
-
-	IWL_DEBUG_INFO(priv, "Setting scan to off\n");
-
-	clear_bit(STATUS_SCANNING, &priv->status);
-
 	queue_work(priv->workqueue, &priv->scan_completed);
 }
 
@@ -298,19 +231,51 @@ EXPORT_SYMBOL(iwl_init_scan_params);
 
 static int iwl_scan_initiate(struct iwl_priv *priv, struct ieee80211_vif *vif)
 {
+	int ret;
+
 	lockdep_assert_held(&priv->mutex);
 
+	if (WARN_ON(!priv->cfg->ops->utils->request_scan))
+		return -EOPNOTSUPP;
+
 	IWL_DEBUG_INFO(priv, "Starting scan...\n");
 	set_bit(STATUS_SCANNING, &priv->status);
 	priv->is_internal_short_scan = false;
 	priv->scan_start = jiffies;
 
-	if (WARN_ON(!priv->cfg->ops->utils->request_scan))
-		return -EOPNOTSUPP;
+	ret = priv->cfg->ops->utils->request_scan(priv, vif);
+	if (ret)
+		clear_bit(STATUS_SCANNING, &priv->status);
+	return ret;
+}
 
-	priv->cfg->ops->utils->request_scan(priv, vif);
+static bool iwl_can_start_scan(struct iwl_priv *priv, bool start_internal)
+{
+	if (!iwl_is_ready_rf(priv)) {
+		IWL_WARN(priv, "Request scan called when driver not ready.\n");
+		return false;
+	}
 
-	return 0;
+	if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
+		IWL_DEBUG_SCAN(priv, "Scan request while abort pending\n");
+		return false;
+	}
+
+	if (test_bit(STATUS_SCANNING, &priv->status)) {
+		if (start_internal && priv->is_internal_short_scan) {
+			IWL_DEBUG_SCAN(priv, "Internal scan in progress.\n");
+			return false;
+		} else if (!priv->is_internal_short_scan) {
+			IWL_DEBUG_SCAN(priv, "Scan already in progress.\n");
+			return false;
+		}
+
+		/* Mac80211 scan request come during internal scan, that's
+		 * fine, when we finish internal scan we will start new
+		 * scan request */
+	}
+
+	return true;
 }
 
 int iwl_mac_hw_scan(struct ieee80211_hw *hw,
@@ -325,24 +290,13 @@ int iwl_mac_hw_scan(struct ieee80211_hw *hw,
 	if (req->n_channels == 0)
 		return -EINVAL;
 
+	/* Need to assure old work finish if we queue the same work again */
+	cancel_delayed_work_sync(&priv->scan_check);
+
 	mutex_lock(&priv->mutex);
 
-	if (!iwl_is_ready_rf(priv)) {
+	if (!iwl_can_start_scan(priv, false)) {
 		ret = -EIO;
-		IWL_DEBUG_MAC80211(priv, "leave - not ready or exit pending\n");
-		goto out_unlock;
-	}
-
-	if (test_bit(STATUS_SCANNING, &priv->status) &&
-	    !priv->is_internal_short_scan) {
-		IWL_DEBUG_SCAN(priv, "Scan already in progress.\n");
-		ret = -EAGAIN;
-		goto out_unlock;
-	}
-
-	if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
-		IWL_DEBUG_SCAN(priv, "Scan request while abort pending\n");
-		ret = -EAGAIN;
 		goto out_unlock;
 	}
 
@@ -360,6 +314,10 @@ int iwl_mac_hw_scan(struct ieee80211_hw *hw,
 	else
 		ret = iwl_scan_initiate(priv, vif);
 
+	if (ret == 0)
+		queue_delayed_work(priv->workqueue, &priv->scan_check,
+				   IWL_SCAN_CHECK_WATCHDOG);
+
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 
 out_unlock:
@@ -380,127 +338,162 @@ void iwl_internal_short_hw_scan(struct iwl_priv *priv)
 
 static void iwl_bg_start_internal_scan(struct work_struct *work)
 {
+	int ret;
 	struct iwl_priv *priv =
 		container_of(work, struct iwl_priv, start_internal_scan);
 
-	mutex_lock(&priv->mutex);
-
-	if (priv->is_internal_short_scan == true) {
-		IWL_DEBUG_SCAN(priv, "Internal scan already in progress\n");
-		goto unlock;
-	}
-
-	if (!iwl_is_ready_rf(priv)) {
-		IWL_DEBUG_SCAN(priv, "not ready or exit pending\n");
-		goto unlock;
-	}
-
-	if (test_bit(STATUS_SCANNING, &priv->status)) {
-		IWL_DEBUG_SCAN(priv, "Scan already in progress.\n");
-		goto unlock;
-	}
+	if (WARN_ON(!priv->cfg->ops->utils->request_scan))
+		return;
 
-	if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
-		IWL_DEBUG_SCAN(priv, "Scan request while abort pending\n");
+	mutex_lock(&priv->mutex);
+	if (!iwl_can_start_scan(priv, true))
 		goto unlock;
-	}
 
 	priv->scan_band = priv->band;
+	priv->scan_request = NULL;
+	priv->scan_vif = NULL;
 
 	IWL_DEBUG_SCAN(priv, "Start internal short scan...\n");
 	set_bit(STATUS_SCANNING, &priv->status);
 	priv->is_internal_short_scan = true;
 
-	if (WARN_ON(!priv->cfg->ops->utils->request_scan))
-		goto unlock;
+	ret = priv->cfg->ops->utils->request_scan(priv, NULL);
+	if (ret) {
+		clear_bit(STATUS_SCANNING, &priv->status);
+		priv->is_internal_short_scan = false;
+	}
 
-	priv->cfg->ops->utils->request_scan(priv, NULL);
  unlock:
 	mutex_unlock(&priv->mutex);
 }
+EXPORT_SYMBOL(iwl_bg_start_internal_scan);
 
-static void iwl_bg_scan_check(struct work_struct *data)
+/* NOTE: priv->mutex is required before calling this function */
+static int iwl_do_scan_abort(struct iwl_priv *priv)
 {
-	struct iwl_priv *priv =
-	    container_of(data, struct iwl_priv, scan_check.work);
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
+	int ret = 0;
 
-	mutex_lock(&priv->mutex);
-	if (test_bit(STATUS_SCANNING, &priv->status) &&
-	    !test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
-		IWL_DEBUG_SCAN(priv, "Scan completion watchdog (%dms)\n",
-			       jiffies_to_msecs(IWL_SCAN_CHECK_WATCHDOG));
+	if (test_bit(STATUS_SCANNING, &priv->status)) {
+		if (test_and_set_bit(STATUS_SCAN_ABORTING, &priv->status))
+			IWL_DEBUG_SCAN(priv, "Scan abort in progress.\n");
+		else {
+			ret = iwl_send_scan_abort(priv);
+			if (ret) {
+				clear_bit(STATUS_SCANNING, &priv->status);
+				clear_bit(STATUS_SCAN_HW, &priv->status);
+				clear_bit(STATUS_SCAN_ABORTING, &priv->status);
+
+				/* If we did internal scan and mac80211 does
+				 * not schedule scan by itself we do not
+				 * have to complete it */
+				if (priv->is_internal_short_scan &&
+				    priv->scan_request == NULL)
+					ret = 0;
+			}
+			IWL_DEBUG_SCAN(priv, "Send scan abort ret %d\n", ret);
+		}
+	} else
+		IWL_DEBUG_SCAN(priv, "Not performing scan to abort.\n");
 
-		if (!test_bit(STATUS_EXIT_PENDING, &priv->status))
-			iwl_send_scan_abort(priv);
-	}
-	mutex_unlock(&priv->mutex);
+	return ret;
 }
 
 /**
- * iwl_fill_probe_req - fill in all required fields and IE for probe request
+ * iwl_scan_cancel - Cancel any currently executing HW scan
  */
+void iwl_scan_cancel(struct iwl_priv *priv)
+{
+	IWL_DEBUG_SCAN(priv, "Queuing scan abort.\n");
+	schedule_work(&priv->abort_scan);
+}
+EXPORT_SYMBOL(iwl_scan_cancel);
 
-u16 iwl_fill_probe_req(struct iwl_priv *priv, struct ieee80211_mgmt *frame,
-		       const u8 *ta, const u8 *ies, int ie_len, int left)
+/**
+ * iwl_scan_cancel_timeout - Cancel any currently executing HW scan
+ * @ms: amount of time to wait (in milliseconds) for scan to abort
+ *
+ * NOTE: priv->mutex must be held before calling this function
+ */
+int iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms)
 {
-	int len = 0;
-	u8 *pos = NULL;
+	int ret;
+	unsigned long now = jiffies;
 
-	/* Make sure there is enough space for the probe request,
-	 * two mandatory IEs and the data */
-	left -= 24;
-	if (left < 0)
-		return 0;
+	ret = iwl_do_scan_abort(priv);
+	mutex_unlock(&priv->mutex);
 
-	frame->frame_control = cpu_to_le16(IEEE80211_STYPE_PROBE_REQ);
-	memcpy(frame->da, iwl_bcast_addr, ETH_ALEN);
-	memcpy(frame->sa, ta, ETH_ALEN);
-	memcpy(frame->bssid, iwl_bcast_addr, ETH_ALEN);
-	frame->seq_ctrl = 0;
+	if (ret) {
+		ieee80211_scan_completed(priv->hw, true);
+		goto out;
+	}
 
-	len += 24;
+	while (time_before(jiffies, now + msecs_to_jiffies(ms))) {
+		if (!test_bit(STATUS_SCANNING, &priv->status))
+			break;
+		msleep(20);
+	}
 
-	/* ...next IE... */
-	pos = &frame->u.probe_req.variable[0];
+	/* XXX: race condtion: we can sucessufly cancel scan, but
+	 *	a new scan request could arrive, so we can still
+	 *	have scanning pending */ 
+out:
+	mutex_lock(&priv->mutex);
+	ret = test_bit(STATUS_SCANNING, &priv->status);
+	if (ret)
+		IWL_WARN(priv, "Could not cancel scan after %lu ms", ms);
+	return ret;
+}
+EXPORT_SYMBOL(iwl_scan_cancel_timeout);
 
-	/* fill in our indirect SSID IE */
-	left -= 2;
-	if (left < 0)
-		return 0;
-	*pos++ = WLAN_EID_SSID;
-	*pos++ = 0;
+static void iwl_bg_abort_scan(struct work_struct *work)
+{
+	struct iwl_priv *priv = container_of(work, struct iwl_priv, abort_scan);
+	int ret;
 
-	len += 2;
+	IWL_DEBUG_SCAN(priv, "Scan abort work\n");
 
-	if (WARN_ON(left < ie_len))
-		return len;
+	mutex_lock(&priv->mutex);
+	ret = iwl_do_scan_abort(priv);
+	mutex_unlock(&priv->mutex);
 
-	if (ies && ie_len) {
-		memcpy(pos, ies, ie_len);
-		len += ie_len;
+	if (ret) {
+		cancel_delayed_work(&priv->scan_check);
+		ieee80211_scan_completed(priv->hw, true);
 	}
 
-	return (u16)len;
+	/* If successfully send abort command, we can still not get
+	 * notification from firmware, so we keep scan watchdog running */
 }
-EXPORT_SYMBOL(iwl_fill_probe_req);
+EXPORT_SYMBOL(iwl_bg_abort_scan);
 
-static void iwl_bg_abort_scan(struct work_struct *work)
+static void iwl_bg_scan_check(struct work_struct *data)
 {
-	struct iwl_priv *priv = container_of(work, struct iwl_priv, abort_scan);
+	struct iwl_priv *priv =
+	    container_of(data, struct iwl_priv, scan_check.work);
+	bool complete_scan = false;
 
-	if (!test_bit(STATUS_READY, &priv->status) ||
-	    !test_bit(STATUS_GEO_CONFIGURED, &priv->status))
-		return;
+	IWL_DEBUG_SCAN(priv, "Scan completion watchdog (%dms)\n",
+		       jiffies_to_msecs(IWL_SCAN_CHECK_WATCHDOG));
 
-	cancel_delayed_work(&priv->scan_check);
+	/* When scanning is marked as pending, we will send abort command,
+	 * but do not care if it will be successful or not. Just cancel
+	 * bits and do cleanups here, we can not relay that we get
+	 * abort notification from hardware. */
 
 	mutex_lock(&priv->mutex);
-	if (test_bit(STATUS_SCAN_ABORTING, &priv->status))
-		iwl_send_scan_abort(priv);
+	if (test_and_clear_bit(STATUS_SCANNING, &priv->status)) {
+		iwl_do_scan_abort(priv);
+		clear_bit(STATUS_SCAN_HW, &priv->status);
+		clear_bit(STATUS_SCAN_ABORTING, &priv->status);
+
+		/* Check if scan was requested from mac80211 */
+		if (!priv->is_internal_short_scan || priv->scan_request != NULL)
+			complete_scan = true;
+	}
 	mutex_unlock(&priv->mutex);
+
+	if (complete_scan)
+		ieee80211_scan_completed(priv->hw, true);
 }
 
 static void iwl_bg_scan_completed(struct work_struct *work)
@@ -508,42 +501,70 @@ static void iwl_bg_scan_completed(struct work_struct *work)
 	struct iwl_priv *priv =
 	    container_of(work, struct iwl_priv, scan_completed);
 	bool internal = false;
-	bool scan_completed = false;
+	bool aborted = false;
+	bool completed = false;
+	bool start_new_scan = false;
 
 	IWL_DEBUG_SCAN(priv, "SCAN complete scan\n");
 
-	cancel_delayed_work(&priv->scan_check);
+	/* Need to assure old work finish if we queue the same work again */
+	cancel_delayed_work_sync(&priv->scan_check);
 
 	mutex_lock(&priv->mutex);
+
 	if (priv->is_internal_short_scan) {
-		priv->is_internal_short_scan = false;
 		IWL_DEBUG_SCAN(priv, "internal short scan completed\n");
+
+		/* mac80211 could requested scan during our internal scan */
+		if (priv->scan_request && iwl_can_start_scan(priv, false))
+			start_new_scan = true;
+
 		internal = true;
-	} else if (priv->scan_request) {
-		scan_completed = true;
-		priv->scan_request = NULL;
-		priv->scan_vif = NULL;
+		priv->is_internal_short_scan = false;
 	}
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		goto out;
 
-	if (internal && priv->scan_request)
-		iwl_scan_initiate(priv, priv->scan_vif);
+	if (start_new_scan) {
+		if (iwl_scan_initiate(priv, priv->scan_vif)) {
+			IWL_DEBUG_INFO(priv, "Failed to start SCAN after "
+					     "internal scan.\n");
+			completed = true;
+			aborted = true;
+			clear_bit(STATUS_SCAN_ABORTING, &priv->status);
+			/* STATUS_SCANNING bit is cleared */
+		} else
+			queue_delayed_work(priv->workqueue, &priv->scan_check,
+					   IWL_SCAN_CHECK_WATCHDOG);
+		goto out_unlock;
+	}
 
 	/* Since setting the TXPOWER may have been deferred while
 	 * performing the scan, fire one off */
 	iwl_set_tx_power(priv, priv->tx_power_user_lmt, true);
 
-	/*
-	 * Since setting the RXON may have been deferred while
-	 * performing the scan, fire one off if needed
-	 */
+	/* Since setting the RXON may have been deferred while
+	 * performing the scan, fire one off if needed */
 	if (memcmp(&priv->active_rxon,
 		   &priv->staging_rxon, sizeof(priv->staging_rxon)))
 		iwlcore_commit_rxon(priv);
 
- out:
+out:
+	/* Scan was aborted */
+	if (test_and_clear_bit(STATUS_SCAN_ABORTING, &priv->status)) {
+		aborted = true;
+		IWL_DEBUG_INFO(priv, "Aborted scan completed.\n");
+	}
+
+	/* We report scan completion to mac8011 only if external scan was
+	 * actually performed and nobody else report the completion */
+	if (test_and_clear_bit(STATUS_SCANNING, &priv->status) && !internal) {
+		completed = true;
+		IWL_DEBUG_INFO(priv, "SCAN completed.\n");
+	}
+
+out_unlock:
 	mutex_unlock(&priv->mutex);
 
 	/*
@@ -551,8 +572,8 @@ static void iwl_bg_scan_completed(struct work_struct *work)
 	 * into driver again into functions that will attempt to take
 	 * mutex.
 	 */
-	if (scan_completed)
-		ieee80211_scan_completed(priv->hw, false);
+	if (completed)
+		ieee80211_scan_completed(priv->hw, aborted);
 }
 
 void iwl_setup_scan_deferred_work(struct iwl_priv *priv)
@@ -564,3 +585,51 @@ void iwl_setup_scan_deferred_work(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_setup_scan_deferred_work);
 
+/**
+ * iwl_fill_probe_req - fill in all required fields and IE for probe request
+ */
+
+u16 iwl_fill_probe_req(struct iwl_priv *priv, struct ieee80211_mgmt *frame,
+		       const u8 *ta, const u8 *ies, int ie_len, int left)
+{
+	int len = 0;
+	u8 *pos = NULL;
+
+	/* Make sure there is enough space for the probe request,
+	 * two mandatory IEs and the data */
+	left -= 24;
+	if (left < 0)
+		return 0;
+
+	frame->frame_control = cpu_to_le16(IEEE80211_STYPE_PROBE_REQ);
+	memcpy(frame->da, iwl_bcast_addr, ETH_ALEN);
+	memcpy(frame->sa, ta, ETH_ALEN);
+	memcpy(frame->bssid, iwl_bcast_addr, ETH_ALEN);
+	frame->seq_ctrl = 0;
+
+	len += 24;
+
+	/* ...next IE... */
+	pos = &frame->u.probe_req.variable[0];
+
+	/* fill in our indirect SSID IE */
+	left -= 2;
+	if (left < 0)
+		return 0;
+	*pos++ = WLAN_EID_SSID;
+	*pos++ = 0;
+
+	len += 2;
+
+	if (WARN_ON(left < ie_len))
+		return len;
+
+	if (ies && ie_len) {
+		memcpy(pos, ies, ie_len);
+		len += ie_len;
+	}
+
+	return (u16)len;
+}
+EXPORT_SYMBOL(iwl_fill_probe_req);
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index d5e8db3..a2d0ffe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -989,11 +989,11 @@ void iwl_update_tkip_key(struct iwl_priv *priv,
 	unsigned long flags;
 	int i;
 
-	if (iwl_scan_cancel(priv)) {
-		/* cancel scan failed, just live w/ bad key and rely
-		   briefly on SW decryption */
+	if (test_bit(STATUS_SCAN_HW, &priv->status)) {
+		/* just live w/ bad key and rely briefly on SW decryption */
 		return;
 	}
+	/* XXX: race condition: nothing prevent to start HW scanning now */
 
 	sta_id = iwl_sta_id_or_broadcast(priv, sta);
 	if (sta_id == IWL_INVALID_STATION)
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 53e6cbb..dcd35b0 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2812,7 +2812,7 @@ static void iwl3945_rfkill_poll(struct work_struct *data)
 
 }
 
-void iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
+int iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 {
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_SCAN_CMD,
@@ -2820,60 +2820,17 @@ void iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		.flags = CMD_SIZE_HUGE,
 	};
 	struct iwl3945_scan_cmd *scan;
-	struct ieee80211_conf *conf = NULL;
 	u8 n_probes = 0;
 	enum ieee80211_band band;
 	bool is_active = false;
-
-	conf = ieee80211_get_hw_conf(priv->hw);
-
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
+	int ret;
 
 	if (!priv->scan_cmd) {
 		priv->scan_cmd = kmalloc(sizeof(struct iwl3945_scan_cmd) +
 					 IWL_MAX_SCAN_SIZE, GFP_KERNEL);
 		if (!priv->scan_cmd) {
 			IWL_DEBUG_SCAN(priv, "Fail to allocate scan memory\n");
+			ret = -ENOMEM;
 			goto done;
 		}
 	}
@@ -2969,6 +2926,7 @@ void iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		break;
 	default:
 		IWL_WARN(priv, "Invalid scan band\n");
+		ret = -EINVAL;
 		goto done;
 	}
 
@@ -3004,6 +2962,7 @@ void iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 
 	if (scan->channel_count == 0) {
 		IWL_DEBUG_SCAN(priv, "channel count %d\n", scan->channel_count);
+		ret = -EIO;
 		goto done;
 	}
 
@@ -3013,25 +2972,11 @@ void iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
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
+	ret = iwl_send_cmd_sync(priv, &cmd);
+	if (ret)
+		clear_bit(STATUS_SCAN_HW, &priv->status);
  done:
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
+	return ret;
 }
 
 static void iwl3945_bg_restart(struct work_struct *data)
@@ -3042,13 +2987,27 @@ static void iwl3945_bg_restart(struct work_struct *data)
 		return;
 
 	if (test_and_clear_bit(STATUS_FW_ERROR, &priv->status)) {
+		bool scan_pending = false;
+
 		mutex_lock(&priv->mutex);
 		priv->vif = NULL;
 		priv->is_open = 0;
+		if (test_and_clear_bit(STATUS_SCANNING, &priv->status) &&
+		    !priv->is_internal_short_scan) {
+			scan_pending = true;
+			clear_bit(STATUS_SCAN_HW, &priv->status);
+			clear_bit(STATUS_SCAN_ABORTING, &priv->status);
+		}
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
1.7.1

