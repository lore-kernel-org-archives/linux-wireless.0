Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932281Ab0HaPDf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Aug 2010 11:03:35 -0400
Date: Tue, 31 Aug 2010 17:00:22 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH w-t] iwlwifi: rewrite iwl-scan.c to avoid race conditions
Message-ID: <20100831150021.GA10963@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In this patch I try to avoid hardware scanning race conditions
that may lead to not call ieee80211_scan_completed() (what in
consequences gives "WARNING: at net/wireless/core.c:614
wdev_cleanup_work+0xb7/0xf0"), or call iee80211_scan_completed() more
then once (what gives " WARNING: at net/mac80211/scan.c:312
ieee80211_scan_completed+0x5f/0x1f1").

First problem (warning in wdev_cleanup_work) make any further scan
request from cfg80211 are ignored by mac80211 with EBUSY error,
hence NetworkManager can not perform successful scan and not allow
to establish a new connection. So after suspend/resume (but maybe
not only then) user is not able to connect to wireless network again.

We can not rely on that the commands (start and abort scan) are
successful. Even if they are successfully send to the hardware, we can
not get back notification from firmware (i.e. firmware hung or was
reseted), or we can get notification when we actually perform abort
scan in driver code or after that.

To assure we call ieee80211_scan_completed() only once when scan
was started we use SCAN_SCANNING bit. Code path, which first clear
STATUS_SCANNING bit will call ieee80211_scan_completed().
We do this in many cases, in scan complete notification, scan
abort, device down, etc. Each time we check SCANNING bit.

Cancelling scan when down device is a bit tricky, because
we do not want to drop priv->mutex while holding it. First we
wait for hardware finish scan (STATUS_SCAN_HW bit clear), then
proceed device down. After that wait for all scan workqueues
finish (STATUS_SCANNING bit clear).

Scan works have now custom workqueue to allow scan functions
to run in parallel with other iwlwifi works, which could wait
for scan abort finish.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |   71 +----
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   58 ++--
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.c     |   23 +-
 drivers/net/wireless/iwlwifi/iwl-core.h     |   19 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   18 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c     |  510 ++++++++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-sta.c      |    8 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |  134 ++------
 10 files changed, 406 insertions(+), 439 deletions(-)

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
index a9e69a6..255eac5 100644
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
@@ -1162,7 +1162,6 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		.flags = CMD_SIZE_HUGE,
 	};
 	struct iwl_scan_cmd *scan;
-	struct ieee80211_conf *conf = NULL;
 	u32 rate_flags = 0;
 	u16 cmd_len;
 	u16 rx_chain = 0;
@@ -1174,48 +1173,7 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
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
@@ -1328,7 +1286,8 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 						IWL_GOOD_CRC_TH_NEVER;
 		break;
 	default:
-		IWL_WARN(priv, "Invalid scan band count\n");
+		IWL_WARN(priv, "Invalid scan band\n");
+		ret = -EINVAL;
 		goto done;
 	}
 
@@ -1409,6 +1368,7 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	}
 	if (scan->channel_count == 0) {
 		IWL_DEBUG_SCAN(priv, "channel count %d\n", scan->channel_count);
+		ret = -EIO;
 		goto done;
 	}
 
@@ -1418,24 +1378,11 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
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
index 5e0d0d5..9d8d65e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2806,12 +2806,13 @@ static void iwl_cancel_deferred_work(struct iwl_priv *priv);
 static void __iwl_down(struct iwl_priv *priv)
 {
 	unsigned long flags;
-	int exit_pending = test_bit(STATUS_EXIT_PENDING, &priv->status);
+	int exit_pending, is_initialized;
 
 	IWL_DEBUG_INFO(priv, DRV_NAME " is going down\n");
 
-	if (!exit_pending)
-		set_bit(STATUS_EXIT_PENDING, &priv->status);
+	iwl_scan_cancel_sleep(priv);
+
+	exit_pending = test_and_set_bit(STATUS_EXIT_PENDING, &priv->status);
 
 	/* Stop TX queues watchdog. We need to have STATUS_EXIT_PENDING bit set
 	 * to prevent rearm timer */
@@ -2849,29 +2850,13 @@ static void __iwl_down(struct iwl_priv *priv)
 	if (priv->mac80211_registered)
 		ieee80211_stop_queues(priv->hw);
 
-	/* If we have not previously called iwl_init() then
-	 * clear all bits but the RF Kill bit and return */
-	if (!iwl_is_init(priv)) {
-		priv->status = test_bit(STATUS_RF_KILL_HW, &priv->status) <<
-					STATUS_RF_KILL_HW |
-			       test_bit(STATUS_GEO_CONFIGURED, &priv->status) <<
-					STATUS_GEO_CONFIGURED |
-			       test_bit(STATUS_EXIT_PENDING, &priv->status) <<
-					STATUS_EXIT_PENDING;
+	is_initialized = iwl_is_init(priv);
+	priv->status &= IWL_PRESERVE_STATUS_MASK;
+	if (!is_initialized) {
+		priv->status &= ~BIT(STATUS_RF_KILL_HW);
 		goto exit;
 	}
 
-	/* ...otherwise clear out all the status bits but the RF Kill
-	 * bit and continue taking the NIC down. */
-	priv->status &= test_bit(STATUS_RF_KILL_HW, &priv->status) <<
-				STATUS_RF_KILL_HW |
-			test_bit(STATUS_GEO_CONFIGURED, &priv->status) <<
-				STATUS_GEO_CONFIGURED |
-			test_bit(STATUS_FW_ERROR, &priv->status) <<
-				STATUS_FW_ERROR |
-		       test_bit(STATUS_EXIT_PENDING, &priv->status) <<
-				STATUS_EXIT_PENDING;
-
 	/* device going down, Stop using ICT table */
 	iwl_disable_ict(priv);
 
@@ -3164,6 +3149,7 @@ static void iwl_bg_restart(struct work_struct *data)
 		priv->bt_status = bt_status;
 
 		mutex_unlock(&priv->mutex);
+
 		iwl_cancel_deferred_work(priv);
 		ieee80211_restart_hw(priv->hw);
 	} else {
@@ -3209,7 +3195,7 @@ void iwl_post_associate(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-	iwl_scan_cancel_timeout(priv, 200);
+	iwl_scan_cancel_sleep(priv);
 
 	conf = ieee80211_get_hw_conf(priv->hw);
 
@@ -3401,15 +3387,6 @@ static void iwl_mac_stop(struct ieee80211_hw *hw)
 
 	priv->is_open = 0;
 
-	if (iwl_is_ready_rf(priv) || test_bit(STATUS_SCAN_HW, &priv->status)) {
-		/* stop mac, cancel any scan request and clear
-		 * RXON_FILTER_ASSOC_MSK BIT
-		 */
-		mutex_lock(&priv->mutex);
-		iwl_scan_cancel_timeout(priv, 100);
-		mutex_unlock(&priv->mutex);
-	}
-
 	iwl_down(priv);
 
 	flush_workqueue(priv->workqueue);
@@ -3530,7 +3507,7 @@ static int iwl_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		return -EINVAL;
 
 	mutex_lock(&priv->mutex);
-	iwl_scan_cancel_timeout(priv, 100);
+	iwl_scan_cancel_sleep(priv);
 
 	/*
 	 * If we are getting WEP group key and we didn't receive any key mapping
@@ -3921,7 +3898,7 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 	INIT_DELAYED_WORK(&priv->init_alive_start, iwl_bg_init_alive_start);
 	INIT_DELAYED_WORK(&priv->alive_start, iwl_bg_alive_start);
 
-	iwl_setup_scan_deferred_work(priv);
+	iwl_setup_scan_deferred_work(priv, DRV_NAME "_scan");
 
 	if (priv->cfg->ops->lib->setup_deferred_work)
 		priv->cfg->ops->lib->setup_deferred_work(priv);
@@ -3951,17 +3928,20 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 
 static void iwl_cancel_deferred_work(struct iwl_priv *priv)
 {
+	iwl_wait_for_scan_end(priv);
+
 	if (priv->cfg->ops->lib->cancel_deferred_work)
 		priv->cfg->ops->lib->cancel_deferred_work(priv);
 
 	cancel_delayed_work_sync(&priv->init_alive_start);
-	cancel_delayed_work(&priv->scan_check);
-	cancel_work_sync(&priv->start_internal_scan);
 	cancel_delayed_work(&priv->alive_start);
 	cancel_work_sync(&priv->run_time_calib_work);
 	cancel_work_sync(&priv->beacon_update);
 	cancel_work_sync(&priv->bt_full_concurrency);
 	cancel_work_sync(&priv->bt_runtime_config);
+
+	iwl_cancel_scan_deferred_work(priv);
+
 	del_timer_sync(&priv->statistics_periodic);
 	del_timer_sync(&priv->ucode_trace);
 }
@@ -4335,6 +4315,8 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return 0;
 
  out_destroy_workqueue:
+	destroy_workqueue(priv->scan_workqueue);
+	priv->scan_workqueue = NULL;
 	destroy_workqueue(priv->workqueue);
 	priv->workqueue = NULL;
 	free_irq(priv->pci_dev->irq, priv);
@@ -4422,6 +4404,8 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 	 * until now... */
 	destroy_workqueue(priv->workqueue);
 	priv->workqueue = NULL;
+	destroy_workqueue(priv->scan_workqueue);
+	priv->scan_workqueue = NULL;
 	iwl_free_traffic_mem(priv);
 
 	free_irq(priv->pci_dev->irq, priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 1a7f70f..4691563 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -217,7 +217,7 @@ void iwl_reply_statistics(struct iwl_priv *priv,
 			  struct iwl_rx_mem_buffer *rxb);
 
 /* scan */
-void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif);
+int  iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif);
 
 /* station mgmt */
 int iwlagn_manage_ibss_station(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index c43124c..8dc5d3b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1726,8 +1726,8 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 		 * background then we need to cancel it else the RXON
 		 * below/in post_associate will fail.
 		 */
-		if (iwl_scan_cancel_timeout(priv, 100)) {
-			IWL_WARN(priv, "Aborted scan still in progress after 100ms\n");
+		if (iwl_scan_cancel_sleep(priv)) {
+			IWL_WARN(priv, "Aborted scan still in progress\n");
 			IWL_DEBUG_MAC80211(priv, "leaving - scan abort failed.\n");
 			mutex_unlock(&priv->mutex);
 			return;
@@ -1875,7 +1875,8 @@ int iwl_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 
 	mutex_lock(&priv->mutex);
 
-	if (WARN_ON(!iwl_is_ready_rf(priv))) {
+	if (!iwl_is_ready_rf(priv)) {
+		IWL_WARN(priv, "Can not add vif - device not ready\n");
 		err = -EINVAL;
 		goto out;
 	}
@@ -1920,24 +1921,20 @@ void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif)
 {
 	struct iwl_priv *priv = hw->priv;
-	bool scan_completed = false;
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 
 	mutex_lock(&priv->mutex);
 
+	if (priv->scan_vif == vif)
+		iwl_scan_cancel_sleep(priv);
+
 	if (iwl_is_ready_rf(priv)) {
-		iwl_scan_cancel_timeout(priv, 100);
 		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 		iwlcore_commit_rxon(priv);
 	}
 	if (priv->vif == vif) {
 		priv->vif = NULL;
-		if (priv->scan_vif == vif) {
-			scan_completed = true;
-			priv->scan_vif = NULL;
-			priv->scan_request = NULL;
-		}
 		memset(priv->bssid, 0, ETH_ALEN);
 	}
 
@@ -1953,11 +1950,7 @@ void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 
 	mutex_unlock(&priv->mutex);
 
-	if (scan_completed)
-		ieee80211_scan_completed(priv->hw, true);
-
 	IWL_DEBUG_MAC80211(priv, "leave\n");
-
 }
 EXPORT_SYMBOL(iwl_mac_remove_interface);
 
@@ -2121,6 +2114,7 @@ void iwl_mac_reset_tsf(struct ieee80211_hw *hw)
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
+	iwl_scan_cancel_sleep(priv);
 	if (!iwl_is_ready_rf(priv)) {
 		IWL_DEBUG_MAC80211(priv, "leave - not ready\n");
 		mutex_unlock(&priv->mutex);
@@ -2130,7 +2124,6 @@ void iwl_mac_reset_tsf(struct ieee80211_hw *hw)
 	/* we are restarting association process
 	 * clear RXON_FILTER_ASSOC_MSK bit
 	 */
-	iwl_scan_cancel_timeout(priv, 100);
 	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	iwlcore_commit_rxon(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index de2e39f..e9969df 100644
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
@@ -544,8 +544,9 @@ static inline __le32 iwl_hw_set_rate_n_flags(u8 rate, u32 flags)
  * Scanning
  ******************************************************************************/
 void iwl_init_scan_params(struct iwl_priv *priv);
-int iwl_scan_cancel(struct iwl_priv *priv);
-int iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms);
+void iwl_scan_cancel(struct iwl_priv *priv);
+int iwl_scan_cancel_sleep(struct iwl_priv *priv);
+void iwl_wait_for_scan_end(struct iwl_priv *priv);
 int iwl_mac_hw_scan(struct ieee80211_hw *hw,
 		    struct ieee80211_vif *vif,
 		    struct cfg80211_scan_request *req);
@@ -560,7 +561,8 @@ u16 iwl_get_active_dwell_time(struct iwl_priv *priv,
 u16 iwl_get_passive_dwell_time(struct iwl_priv *priv,
 			       enum ieee80211_band band,
 			       struct ieee80211_vif *vif);
-void iwl_setup_scan_deferred_work(struct iwl_priv *priv);
+void iwl_setup_scan_deferred_work(struct iwl_priv *priv, const char *name);
+void iwl_cancel_scan_deferred_work(struct iwl_priv *priv);
 
 /* For faster active scanning, scan will move to the next channel if fewer than
  * PLCP_QUIET_THRESH packets are heard on this channel within
@@ -571,8 +573,6 @@ void iwl_setup_scan_deferred_work(struct iwl_priv *priv);
 #define IWL_ACTIVE_QUIET_TIME       cpu_to_le16(10)  /* msec */
 #define IWL_PLCP_QUIET_THRESH       cpu_to_le16(1)  /* packets */
 
-#define IWL_SCAN_CHECK_WATCHDOG		(HZ * 7)
-
 /*******************************************************************************
  * Calibrations - implemented in iwl-calib.c
  ******************************************************************************/
@@ -667,6 +667,13 @@ void iwlcore_free_geos(struct iwl_priv *priv);
 #define STATUS_POWER_PMI	16
 #define STATUS_FW_ERROR		17
 
+#define IWL_PRESERVE_STATUS_MASK \
+		(BIT(STATUS_RF_KILL_HW) | \
+		 BIT(STATUS_GEO_CONFIGURED) | \
+		 BIT(STATUS_FW_ERROR) | \
+		 BIT(STATUS_EXIT_PENDING) | \
+		 BIT(STATUS_SCANNING) | \
+		 BIT(STATUS_SCAN_ABORTING))
 
 static inline int iwl_is_ready(struct iwl_priv *priv)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 8d5201a..d20d223 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1392,23 +1392,33 @@ struct iwl_priv {
 	struct workqueue_struct *workqueue;
 
 	struct work_struct restart;
-	struct work_struct scan_completed;
 	struct work_struct rx_replenish;
-	struct work_struct abort_scan;
 	struct work_struct beacon_update;
 	struct work_struct tt_work;
 	struct work_struct ct_enter;
 	struct work_struct ct_exit;
-	struct work_struct start_internal_scan;
 	struct work_struct tx_flush;
 	struct work_struct bt_full_concurrency;
 	struct work_struct bt_runtime_config;
 
+	/* Use separate workqueue for scanning, to allow scan work
+	 * functions run in parallel with other work functions, which
+	 * can call iwl_scan_cancel_sleep() (particularly restart).
+	 * Otherwise scan will not be able to finish and cleanup,
+	 * because we can not run two works in the same workqueue
+	 * at the same time. */
+	struct workqueue_struct *scan_workqueue;
+
+	struct work_struct start_internal_scan;
+	struct work_struct scan_completed;
+	struct work_struct abort_scan;
+	struct delayed_work scan_timeout;
+	struct delayed_work abort_timeout;
+
 	struct tasklet_struct irq_tasklet;
 
 	struct delayed_work init_alive_start;
 	struct delayed_work alive_start;
-	struct delayed_work scan_check;
 
 	/* TX Power */
 	s8 tx_power_user_lmt;
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 2939699..90b55ac 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -54,82 +54,40 @@
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
+/* Timeout for scan command, after that time we assume hardware is not able
+ * to perform scan and we abort it */
+#define IWL_SCAN_TIMEOUT	msecs_to_jiffies(7000)
+/* Time when sleep when waiting for hardware scan to abort */
+#define IWL_SCAN_ABORT_SLEEP	msecs_to_jiffies(200)
+/* Timeout for scan abort command, after that time we assume hardware is
+ * not able to perform scan abort, we stop waiting for firmware notification
+ * and do cleanup by itself (need to be smaller than IWL_SCAN_ABORT_SLEEP) */
+#define IWL_SCAN_ABORT_TIMEOUT	msecs_to_jiffies(150)
+/* Time when waiting for scan related cleanups will finish after down device */
+#define IWL_SCAN_WAIT_END	msecs_to_jiffies(200)
 
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
@@ -140,8 +98,7 @@ static int iwl_send_scan_abort(struct iwl_priv *priv)
 		 * the microcode has notified us that a scan is
 		 * completed. */
 		IWL_DEBUG_INFO(priv, "SCAN_ABORT returned %d.\n", pkt->u.status);
-		clear_bit(STATUS_SCAN_ABORTING, &priv->status);
-		clear_bit(STATUS_SCAN_HW, &priv->status);
+		return -EIO;
 	}
 
 	iwl_free_pages(priv, cmd.reply_page);
@@ -158,7 +115,7 @@ static void iwl_rx_reply_scan(struct iwl_priv *priv,
 	struct iwl_scanreq_notification *notif =
 	    (struct iwl_scanreq_notification *)pkt->u.raw;
 
-	IWL_DEBUG_RX(priv, "Scan request status = 0x%x\n", notif->status);
+	IWL_DEBUG_SCAN(priv, "Scan request status = 0x%x\n", notif->status);
 #endif
 }
 
@@ -222,18 +179,6 @@ static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
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
 	if (priv->iw_mode != NL80211_IFTYPE_ADHOC &&
 	    priv->cfg->advanced_bt_coexist && priv->bt_status !=
 	    scan_notif->bt_status) {
@@ -254,7 +199,8 @@ static void iwl_rx_scan_complete_notif(struct iwl_priv *priv,
 		priv->bt_status = scan_notif->bt_status;
 		queue_work(priv->workqueue, &priv->bt_traffic_change_work);
 	}
-	queue_work(priv->workqueue, &priv->scan_completed);
+
+	queue_work(priv->scan_workqueue, &priv->scan_completed);
 }
 
 void iwl_setup_rx_scan_handlers(struct iwl_priv *priv)
@@ -316,19 +262,51 @@ EXPORT_SYMBOL(iwl_init_scan_params);
 
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
+
+	if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
+		IWL_DEBUG_SCAN(priv, "Scan request while abort pending\n");
+		return false;
+	}
 
-	return 0;
+	if (test_bit(STATUS_SCANNING, &priv->status)) {
+		if (start_internal && priv->is_internal_short_scan) {
+			IWL_DEBUG_SCAN(priv, "Internal scan in progress.\n");
+			return false;
+		} else if (!priv->is_internal_short_scan) {
+			IWL_DEBUG_SCAN(priv, "Scan already in progress.\n");
+			return false;
+		}
+
+		/* mac80211 scan request come during internal scan, that's
+		 * fine, when we finish internal scan we will start new
+		 * scan request */
+	}
+
+	return true;
 }
 
 int iwl_mac_hw_scan(struct ieee80211_hw *hw,
@@ -343,25 +321,14 @@ int iwl_mac_hw_scan(struct ieee80211_hw *hw,
 	if (req->n_channels == 0)
 		return -EINVAL;
 
+	/* Need to assure old work finish if we queue the same work again */
+	cancel_delayed_work_sync(&priv->scan_timeout);
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
-		goto out_unlock;
+		goto out;
 	}
 
 	/* mac80211 will only ask for one band at a time */
@@ -378,11 +345,13 @@ int iwl_mac_hw_scan(struct ieee80211_hw *hw,
 	else
 		ret = iwl_scan_initiate(priv, vif);
 
-	IWL_DEBUG_MAC80211(priv, "leave\n");
-
-out_unlock:
+	if (ret == 0)
+		queue_delayed_work(priv->scan_workqueue, &priv->scan_timeout,
+				   IWL_SCAN_TIMEOUT);
+out:
 	mutex_unlock(&priv->mutex);
 
+	IWL_DEBUG_MAC80211(priv, "leave with ret %d\n", ret);
 	return ret;
 }
 EXPORT_SYMBOL(iwl_mac_hw_scan);
@@ -393,74 +362,253 @@ EXPORT_SYMBOL(iwl_mac_hw_scan);
  */
 void iwl_internal_short_hw_scan(struct iwl_priv *priv)
 {
-	queue_work(priv->workqueue, &priv->start_internal_scan);
+	queue_work(priv->scan_workqueue, &priv->start_internal_scan);
 }
 
 static void iwl_bg_start_internal_scan(struct work_struct *work)
 {
+	int ret;
 	struct iwl_priv *priv =
 		container_of(work, struct iwl_priv, start_internal_scan);
 
-	mutex_lock(&priv->mutex);
+	if (WARN_ON(!priv->cfg->ops->utils->request_scan))
+		return;
 
-	if (priv->is_internal_short_scan == true) {
-		IWL_DEBUG_SCAN(priv, "Internal scan already in progress\n");
+	mutex_lock(&priv->mutex);
+	if (!iwl_can_start_scan(priv, true))
 		goto unlock;
+
+	priv->scan_band = priv->band;
+	priv->scan_request = NULL;
+	priv->scan_vif = NULL;
+
+	IWL_DEBUG_SCAN(priv, "Start internal short scan...\n");
+	set_bit(STATUS_SCANNING, &priv->status);
+	priv->is_internal_short_scan = true;
+	ret = priv->cfg->ops->utils->request_scan(priv, NULL);
+	if (ret) {
+		clear_bit(STATUS_SCANNING, &priv->status);
+		priv->is_internal_short_scan = false;
 	}
+unlock:
+	mutex_unlock(&priv->mutex);
+}
 
-	if (!iwl_is_ready_rf(priv)) {
-		IWL_DEBUG_SCAN(priv, "not ready or exit pending\n");
-		goto unlock;
+static inline void iwl_complete_scan(struct iwl_priv *priv, bool aborted)
+{
+	/* check if scan was requested from mac80211 */
+	if (!priv->is_internal_short_scan || priv->scan_request) {
+		IWL_DEBUG_SCAN(priv, "Complete scan in mac80211\n");
+		ieee80211_scan_completed(priv->hw, aborted);
 	}
 
-	if (test_bit(STATUS_SCANNING, &priv->status)) {
-		IWL_DEBUG_SCAN(priv, "Scan already in progress.\n");
-		goto unlock;
+	/* we need to nulify scan_vif, but clear others as well */
+	priv->is_internal_short_scan = false;
+	priv->scan_vif = NULL;
+	priv->scan_request = NULL;
+}
+
+static inline void iwl_force_scan_abort(struct iwl_priv *priv)
+{
+	IWL_DEBUG_SCAN(priv, "Forcing scan abort\n");
+	clear_bit(STATUS_SCANNING, &priv->status);
+	clear_bit(STATUS_SCAN_HW, &priv->status);
+	clear_bit(STATUS_SCAN_ABORTING, &priv->status);
+	iwl_complete_scan(priv, true);
+}
+
+static void iwl_do_scan_abort(struct iwl_priv *priv)
+{
+	int ret;
+
+	lockdep_assert_held(&priv->mutex);
+
+	if (!test_bit(STATUS_SCANNING, &priv->status)) {
+		IWL_DEBUG_SCAN(priv, "Not performing scan to abort\n");
+		return;
 	}
 
-	if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
-		IWL_DEBUG_SCAN(priv, "Scan request while abort pending\n");
-		goto unlock;
+	if (test_and_set_bit(STATUS_SCAN_ABORTING, &priv->status)) {
+		IWL_DEBUG_SCAN(priv, "Scan abort in progress\n");
+		return;
 	}
 
-	priv->scan_band = priv->band;
+	ret = iwl_send_scan_abort(priv);
+	if (ret)
+		iwl_force_scan_abort(priv);
+	IWL_DEBUG_SCAN(priv, "Send scan abort returned %d\n", ret);
+
+	if (test_bit(STATUS_SCAN_HW, &priv->status)) {
+		/* Even if we successfully send abort command, we can not get
+		 * abort complete notification when firmware hang, so schedule
+		 * watchdog */
+		IWL_DEBUG_SCAN(priv, "Queuing scan abort timeout watchdog\n");
+		queue_delayed_work(priv->scan_workqueue, &priv->abort_timeout,
+				   IWL_SCAN_ABORT_TIMEOUT);
+	}
+}
 
-	IWL_DEBUG_SCAN(priv, "Start internal short scan...\n");
-	set_bit(STATUS_SCANNING, &priv->status);
-	priv->is_internal_short_scan = true;
+/**
+ * iwl_scan_cancel - Cancel any currently executing HW scan
+ */
+void iwl_scan_cancel(struct iwl_priv *priv)
+{
+	IWL_DEBUG_SCAN(priv, "Queuing scan abort.\n");
+	queue_work(priv->scan_workqueue, &priv->abort_scan);
+}
+EXPORT_SYMBOL(iwl_scan_cancel);
 
-	if (WARN_ON(!priv->cfg->ops->utils->request_scan))
-		goto unlock;
+/**
+ * iwl_scan_cancel_sleep - Cancel any currently executing HW scan,
+ *			   wait for hardware/firmware! completion
+ */
+int iwl_scan_cancel_sleep(struct iwl_priv *priv)
+{
+	int ret;
+	unsigned long timeout = jiffies + IWL_SCAN_ABORT_SLEEP;
+
+	IWL_DEBUG_SCAN(priv, "Scan cancel wait\n");
+
+	cancel_delayed_work(&priv->scan_timeout);
+	iwl_do_scan_abort(priv);
+
+	while (time_before_eq(jiffies, timeout)) {
+		if (!test_bit(STATUS_SCAN_HW, &priv->status))
+			break;
+		msleep(20);
+	}
+
+	ret = test_bit(STATUS_SCAN_HW, &priv->status);
+	WARN_ON(ret);
+	return ret;
+}
+EXPORT_SYMBOL(iwl_scan_cancel_sleep);
+
+void iwl_wait_for_scan_end(struct iwl_priv *priv)
+{
+	unsigned long timeout = jiffies + IWL_SCAN_WAIT_END;
+
+	while (time_before_eq(jiffies, timeout)) {
+		if (!test_bit(STATUS_SCANNING, &priv->status))
+			break;
+		msleep(20);
+	}
+	WARN_ON(test_bit(STATUS_SCANNING, &priv->status));
+}
+EXPORT_SYMBOL(iwl_wait_for_scan_end);
+
+static void iwl_bg_abort_scan(struct work_struct *work)
+{
+	struct iwl_priv *priv = container_of(work, struct iwl_priv, abort_scan);
+
+	IWL_DEBUG_SCAN(priv, "Scan abort work\n");
+
+	cancel_delayed_work(&priv->scan_timeout);
 
-	priv->cfg->ops->utils->request_scan(priv, NULL);
- unlock:
+	mutex_lock(&priv->mutex);
+	iwl_do_scan_abort(priv);
 	mutex_unlock(&priv->mutex);
 }
+EXPORT_SYMBOL(iwl_bg_abort_scan);
 
-static void iwl_bg_scan_check(struct work_struct *data)
+static void iwl_bg_scan_timeout(struct work_struct *data)
 {
 	struct iwl_priv *priv =
-	    container_of(data, struct iwl_priv, scan_check.work);
+	    container_of(data, struct iwl_priv, scan_timeout.work);
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
+	IWL_DEBUG_SCAN(priv, "Scan completion timeout\n");
+
+	mutex_lock(&priv->mutex);
+	iwl_do_scan_abort(priv);
+	mutex_unlock(&priv->mutex);
+}
+
+static void iwl_bg_abort_timeout(struct work_struct *data)
+{
+	struct iwl_priv *priv =
+	    container_of(data, struct iwl_priv, abort_timeout.work);
+
+	IWL_DEBUG_SCAN(priv, "Scan abort timeout\n");
+
+	/* Other thread may call iwl_scan_cancel_sleep() to wait for scan
+	 * abort finish with priv->mutex taken. Hardware should finish
+	 * abort before timeout, so we can safety assume it hangs and clear
+	 * HW scan bit here, nothing wrong will happen when we still get
+	 * abort finish notification. */
+	clear_bit(STATUS_SCAN_HW, &priv->status);
+
+	mutex_lock(&priv->mutex);
+	if (test_and_clear_bit(STATUS_SCANNING, &priv->status))
+		iwl_force_scan_abort(priv);
+	mutex_unlock(&priv->mutex);
+}
+
+static void iwl_bg_scan_completed(struct work_struct *work)
+{
+	struct iwl_priv *priv =
+	    container_of(work, struct iwl_priv, scan_completed);
+	bool aborted = false;
+
+	cancel_delayed_work(&priv->scan_timeout);
 
 	mutex_lock(&priv->mutex);
-	if (test_bit(STATUS_SCANNING, &priv->status) &&
-	    !test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
-		IWL_DEBUG_SCAN(priv, "Scan completion watchdog (%dms)\n",
-			       jiffies_to_msecs(IWL_SCAN_CHECK_WATCHDOG));
 
-		if (!test_bit(STATUS_EXIT_PENDING, &priv->status))
-			iwl_send_scan_abort(priv);
+	IWL_DEBUG_SCAN(priv, "Completed%s scan\n",
+		       priv->is_internal_short_scan ? " internal" : "");
+
+	if (test_and_clear_bit(STATUS_SCAN_ABORTING, &priv->status)) {
+		IWL_DEBUG_INFO(priv, "Aborted scan completed\n");
+		aborted = true;
+	}
+
+	if (!test_and_clear_bit(STATUS_SCANNING, &priv->status)) {
+		IWL_DEBUG_INFO(priv, "SCAN already completed\n");
+		goto out;
+	}
+
+	if (priv->is_internal_short_scan && !aborted) {
+		/* Check if mac80211 requested scan during our internal scan */
+		if (priv->scan_request == NULL)
+			goto out_complete;
+
+		/* Check we can request a new scan and try to do this */
+		if (!iwl_can_start_scan(priv, false) ||
+		    iwl_scan_initiate(priv, priv->scan_vif)) {
+			IWL_DEBUG_SCAN(priv, "Can not start new SCAN\n");
+			aborted = true;
+			goto out_complete;
+		}
+
+		/* If successfully lunched the new scan enable watchdog */
+		queue_delayed_work(priv->scan_workqueue, &priv->scan_timeout,
+				   IWL_SCAN_TIMEOUT);
+		goto out;
 	}
+
+out_complete:
+	iwl_complete_scan(priv, aborted);
+
+	/* Can we still talk to firmware ? */
+	if (!iwl_is_ready_rf(priv))
+		goto out;
+
+	/* Since setting the TXPOWER may have been deferred while
+	 * performing the scan, fire one off */
+	iwl_set_tx_power(priv, priv->tx_power_user_lmt, true);
+
+	/* Since setting the RXON may have been deferred while
+	 * performing the scan, fire one off if needed */
+	if (memcmp(&priv->active_rxon,
+		   &priv->staging_rxon, sizeof(priv->staging_rxon)))
+		iwlcore_commit_rxon(priv);
+
+out:
 	mutex_unlock(&priv->mutex);
 }
 
 /**
  * iwl_fill_probe_req - fill in all required fields and IE for probe request
  */
-
 u16 iwl_fill_probe_req(struct iwl_priv *priv, struct ieee80211_mgmt *frame,
 		       const u8 *ta, const u8 *ies, int ie_len, int left)
 {
@@ -505,80 +653,34 @@ u16 iwl_fill_probe_req(struct iwl_priv *priv, struct ieee80211_mgmt *frame,
 }
 EXPORT_SYMBOL(iwl_fill_probe_req);
 
-static void iwl_bg_abort_scan(struct work_struct *work)
-{
-	struct iwl_priv *priv = container_of(work, struct iwl_priv, abort_scan);
-
-	if (!test_bit(STATUS_READY, &priv->status) ||
-	    !test_bit(STATUS_GEO_CONFIGURED, &priv->status))
-		return;
-
-	cancel_delayed_work(&priv->scan_check);
-
-	mutex_lock(&priv->mutex);
-	if (test_bit(STATUS_SCAN_ABORTING, &priv->status))
-		iwl_send_scan_abort(priv);
-	mutex_unlock(&priv->mutex);
-}
-
-static void iwl_bg_scan_completed(struct work_struct *work)
+void iwl_setup_scan_deferred_work(struct iwl_priv *priv, const char *name)
 {
-	struct iwl_priv *priv =
-	    container_of(work, struct iwl_priv, scan_completed);
-	bool internal = false;
-	bool scan_completed = false;
-
-	IWL_DEBUG_SCAN(priv, "SCAN complete scan\n");
+	priv->scan_workqueue = create_singlethread_workqueue(name);
 
-	cancel_delayed_work(&priv->scan_check);
-
-	mutex_lock(&priv->mutex);
-	if (priv->is_internal_short_scan) {
-		priv->is_internal_short_scan = false;
-		IWL_DEBUG_SCAN(priv, "internal short scan completed\n");
-		internal = true;
-	} else if (priv->scan_request) {
-		scan_completed = true;
-		priv->scan_request = NULL;
-		priv->scan_vif = NULL;
-	}
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		goto out;
-
-	if (internal && priv->scan_request)
-		iwl_scan_initiate(priv, priv->scan_vif);
-
-	/* Since setting the TXPOWER may have been deferred while
-	 * performing the scan, fire one off */
-	iwl_set_tx_power(priv, priv->tx_power_user_lmt, true);
-
-	/*
-	 * Since setting the RXON may have been deferred while
-	 * performing the scan, fire one off if needed
-	 */
-	if (memcmp(&priv->active_rxon,
-		   &priv->staging_rxon, sizeof(priv->staging_rxon)))
-		iwlcore_commit_rxon(priv);
-
- out:
-	mutex_unlock(&priv->mutex);
-
-	/*
-	 * Do not hold mutex here since this will cause mac80211 to call
-	 * into driver again into functions that will attempt to take
-	 * mutex.
-	 */
-	if (scan_completed)
-		ieee80211_scan_completed(priv->hw, false);
-}
-
-void iwl_setup_scan_deferred_work(struct iwl_priv *priv)
-{
 	INIT_WORK(&priv->scan_completed, iwl_bg_scan_completed);
 	INIT_WORK(&priv->abort_scan, iwl_bg_abort_scan);
 	INIT_WORK(&priv->start_internal_scan, iwl_bg_start_internal_scan);
-	INIT_DELAYED_WORK(&priv->scan_check, iwl_bg_scan_check);
+	INIT_DELAYED_WORK(&priv->scan_timeout, iwl_bg_scan_timeout);
+	INIT_DELAYED_WORK(&priv->abort_timeout, iwl_bg_abort_timeout);
 }
 EXPORT_SYMBOL(iwl_setup_scan_deferred_work);
 
+void iwl_cancel_scan_deferred_work(struct iwl_priv *priv)
+{
+	/* iwl_scan_cancel_sleep() and iwl_wait_for_scan_end() called before
+	 * that function should prevent any scan work (except abort_timeout)
+	 * to be in pending state */
+	WARN_ON(cancel_work_sync(&priv->start_internal_scan));
+	WARN_ON(cancel_work_sync(&priv->scan_completed));
+	WARN_ON(cancel_work_sync(&priv->abort_scan));
+	WARN_ON(cancel_delayed_work_sync(&priv->scan_timeout));
+
+	if (cancel_delayed_work_sync(&priv->abort_timeout)) {
+		IWL_DEBUG_SCAN(priv, "Abort scan after down device\n");
+		mutex_lock(&priv->mutex);
+		if (test_and_clear_bit(STATUS_SCANNING, &priv->status))
+			iwl_force_scan_abort(priv);
+		mutex_unlock(&priv->mutex);
+	}
+}
+EXPORT_SYMBOL(iwl_cancel_scan_deferred_work);
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index d5e8db3..c7c39ae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -989,11 +989,13 @@ void iwl_update_tkip_key(struct iwl_priv *priv,
 	unsigned long flags;
 	int i;
 
-	if (iwl_scan_cancel(priv)) {
-		/* cancel scan failed, just live w/ bad key and rely
-		   briefly on SW decryption */
+	if (test_bit(STATUS_SCAN_HW, &priv->status)) {
+		/* just live w/ bad key and rely briefly on SW decryption */
 		return;
 	}
+	/* XXX: possible race condition: nothing prevents to start HW scanning
+	 *      right now, however it is not clear if we really can not send
+	 *      update key command to firmware while performing scanning */
 
 	sta_id = iwl_sta_id_or_broadcast(priv, sta);
 	if (sta_id == IWL_INVALID_STATION)
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 53e6cbb..55c5790 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2561,15 +2561,13 @@ static void iwl3945_cancel_deferred_work(struct iwl_priv *priv);
 static void __iwl3945_down(struct iwl_priv *priv)
 {
 	unsigned long flags;
-	int exit_pending = test_bit(STATUS_EXIT_PENDING, &priv->status);
-	struct ieee80211_conf *conf = NULL;
+	int exit_pending, is_initialized;
 
 	IWL_DEBUG_INFO(priv, DRV_NAME " is going down\n");
 
-	conf = ieee80211_get_hw_conf(priv->hw);
+	iwl_scan_cancel_sleep(priv);
 
-	if (!exit_pending)
-		set_bit(STATUS_EXIT_PENDING, &priv->status);
+	exit_pending = test_and_set_bit(STATUS_EXIT_PENDING, &priv->status);
 
 	/* Stop TX queues watchdog. We need to have STATUS_EXIT_PENDING bit set
 	 * to prevent rearm timer */
@@ -2601,29 +2599,13 @@ static void __iwl3945_down(struct iwl_priv *priv)
 	if (priv->mac80211_registered)
 		ieee80211_stop_queues(priv->hw);
 
-	/* If we have not previously called iwl3945_init() then
-	 * clear all bits but the RF Kill bits and return */
-	if (!iwl_is_init(priv)) {
-		priv->status = test_bit(STATUS_RF_KILL_HW, &priv->status) <<
-					STATUS_RF_KILL_HW |
-			       test_bit(STATUS_GEO_CONFIGURED, &priv->status) <<
-					STATUS_GEO_CONFIGURED |
-				test_bit(STATUS_EXIT_PENDING, &priv->status) <<
-					STATUS_EXIT_PENDING;
+	is_initialized = iwl_is_init(priv);
+	priv->status &= IWL_PRESERVE_STATUS_MASK;
+	if (!is_initialized) {
+		priv->status &= ~BIT(STATUS_RF_KILL_HW);
 		goto exit;
 	}
 
-	/* ...otherwise clear out all the status bits but the RF Kill
-	 * bit and continue taking the NIC down. */
-	priv->status &= test_bit(STATUS_RF_KILL_HW, &priv->status) <<
-				STATUS_RF_KILL_HW |
-			test_bit(STATUS_GEO_CONFIGURED, &priv->status) <<
-				STATUS_GEO_CONFIGURED |
-			test_bit(STATUS_FW_ERROR, &priv->status) <<
-				STATUS_FW_ERROR |
-			test_bit(STATUS_EXIT_PENDING, &priv->status) <<
-				STATUS_EXIT_PENDING;
-
 	iwl3945_hw_txq_ctx_stop(priv);
 	iwl3945_hw_rxq_stop(priv);
 
@@ -2812,7 +2794,7 @@ static void iwl3945_rfkill_poll(struct work_struct *data)
 
 }
 
-void iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
+int iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 {
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_SCAN_CMD,
@@ -2820,54 +2802,10 @@ void iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
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
+	int ret = -ENOMEM;
 
 	if (!priv->scan_cmd) {
 		priv->scan_cmd = kmalloc(sizeof(struct iwl3945_scan_cmd) +
@@ -2969,6 +2907,7 @@ void iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 		break;
 	default:
 		IWL_WARN(priv, "Invalid scan band\n");
+		ret = -EINVAL;
 		goto done;
 	}
 
@@ -3004,6 +2943,7 @@ void iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 
 	if (scan->channel_count == 0) {
 		IWL_DEBUG_SCAN(priv, "channel count %d\n", scan->channel_count);
+		ret = -EIO;
 		goto done;
 	}
 
@@ -3012,26 +2952,11 @@ void iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	cmd.data = scan;
 	scan->len = cpu_to_le16(cmd.len);
 
-	set_bit(STATUS_SCAN_HW, &priv->status);
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
@@ -3092,7 +3017,7 @@ void iwl3945_post_associate(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-	iwl_scan_cancel_timeout(priv, 200);
+	iwl_scan_cancel_sleep(priv);
 
 	conf = ieee80211_get_hw_conf(priv->hw);
 
@@ -3222,15 +3147,6 @@ static void iwl3945_mac_stop(struct ieee80211_hw *hw)
 
 	priv->is_open = 0;
 
-	if (iwl_is_ready_rf(priv)) {
-		/* stop mac, cancel any scan request and clear
-		 * RXON_FILTER_ASSOC_MSK BIT
-		 */
-		mutex_lock(&priv->mutex);
-		iwl_scan_cancel_timeout(priv, 100);
-		mutex_unlock(&priv->mutex);
-	}
-
 	iwl3945_down(priv);
 
 	flush_workqueue(priv->workqueue);
@@ -3332,7 +3248,7 @@ static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	}
 
 	mutex_lock(&priv->mutex);
-	iwl_scan_cancel_timeout(priv, 100);
+	iwl_scan_cancel_sleep(priv);
 
 	switch (cmd) {
 	case SET_KEY:
@@ -3553,7 +3469,7 @@ static ssize_t store_flags(struct device *d,
 	mutex_lock(&priv->mutex);
 	if (le32_to_cpu(priv->staging_rxon.flags) != flags) {
 		/* Cancel any currently running scans... */
-		if (iwl_scan_cancel_timeout(priv, 100))
+		if (iwl_scan_cancel_sleep(priv))
 			IWL_WARN(priv, "Could not cancel scan.\n");
 		else {
 			IWL_DEBUG_INFO(priv, "Committing rxon.flags = 0x%04X\n",
@@ -3588,7 +3504,7 @@ static ssize_t store_filter_flags(struct device *d,
 	mutex_lock(&priv->mutex);
 	if (le32_to_cpu(priv->staging_rxon.filter_flags) != filter_flags) {
 		/* Cancel any currently running scans... */
-		if (iwl_scan_cancel_timeout(priv, 100))
+		if (iwl_scan_cancel_sleep(priv))
 			IWL_WARN(priv, "Could not cancel scan.\n");
 		else {
 			IWL_DEBUG_INFO(priv, "Committing rxon.filter_flags = "
@@ -3792,7 +3708,7 @@ static void iwl3945_setup_deferred_work(struct iwl_priv *priv)
 	INIT_DELAYED_WORK(&priv->alive_start, iwl3945_bg_alive_start);
 	INIT_DELAYED_WORK(&priv->_3945.rfkill_poll, iwl3945_rfkill_poll);
 
-	iwl_setup_scan_deferred_work(priv);
+	iwl_setup_scan_deferred_work(priv, DRV_NAME "_scan");
 
 	iwl3945_hw_setup_deferred_work(priv);
 
@@ -3809,13 +3725,15 @@ static void iwl3945_setup_deferred_work(struct iwl_priv *priv)
 
 static void iwl3945_cancel_deferred_work(struct iwl_priv *priv)
 {
+	iwl_wait_for_scan_end(priv);
+
 	iwl3945_hw_cancel_deferred_work(priv);
 
 	cancel_delayed_work_sync(&priv->init_alive_start);
-	cancel_delayed_work(&priv->scan_check);
-	cancel_delayed_work(&priv->alive_start);
 	cancel_work_sync(&priv->start_internal_scan);
 	cancel_work_sync(&priv->beacon_update);
+
+	iwl_cancel_scan_deferred_work(priv);
 }
 
 static struct attribute *iwl3945_sysfs_entries[] = {
@@ -4152,6 +4070,8 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	return 0;
 
  out_remove_sysfs:
+	destroy_workqueue(priv->scan_workqueue);
+	priv->scan_workqueue = NULL;
 	destroy_workqueue(priv->workqueue);
 	priv->workqueue = NULL;
 	sysfs_remove_group(&pdev->dev.kobj, &iwl3945_attribute_group);
@@ -4238,6 +4158,8 @@ static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 	 * until now... */
 	destroy_workqueue(priv->workqueue);
 	priv->workqueue = NULL;
+	destroy_workqueue(priv->scan_workqueue);
+	priv->scan_workqueue = NULL;
 	iwl_free_traffic_mem(priv);
 
 	free_irq(pdev->irq, priv);
-- 
1.7.1

