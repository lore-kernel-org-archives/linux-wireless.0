Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755006Ab1FHN2x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2011 09:28:53 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 3/6] iwlegacy: remove reset rf infrastructure
Date: Wed,  8 Jun 2011 15:28:26 +0200
Message-Id: <1307539709-11320-3-git-send-email-sgruszka@redhat.com> (sfid-20110608_152856_871007_5346F80F)
In-Reply-To: <1307539709-11320-1-git-send-email-sgruszka@redhat.com>
References: <1307539709-11320-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We do not reset radio anymore, hence don't need that code too.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-3945.c     |    1 -
 drivers/net/wireless/iwlegacy/iwl-4965-lib.c |   79 ++-------------------
 drivers/net/wireless/iwlegacy/iwl-4965.c     |    1 -
 drivers/net/wireless/iwlegacy/iwl-core.c     |   90 ++++++++----------------
 drivers/net/wireless/iwlegacy/iwl-core.h     |    5 +-
 drivers/net/wireless/iwlegacy/iwl-debugfs.c  |   95 +++++--------------------
 drivers/net/wireless/iwlegacy/iwl-dev.h      |   25 +-------
 drivers/net/wireless/iwlegacy/iwl-scan.c     |   92 ++-----------------------
 drivers/net/wireless/iwlegacy/iwl3945-base.c |   95 ++++----------------------
 drivers/net/wireless/iwlegacy/iwl4965-base.c |    5 +-
 10 files changed, 81 insertions(+), 407 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-3945.c b/drivers/net/wireless/iwlegacy/iwl-3945.c
index 5e99584..8aa018d 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945.c
@@ -2697,7 +2697,6 @@ static struct iwl_base_params iwl3945_base_params = {
 	.set_l0s = false,
 	.use_bsm = true,
 	.led_compensation = 64,
-	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.wd_timeout = IWL_DEF_WD_TIMEOUT,
 	.max_event_log_size = 512,
 };
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-lib.c b/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
index a7a4739..2be6d9e 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
@@ -694,47 +694,6 @@ void iwl4965_rx_reply_rx_phy(struct iwl_priv *priv,
 	       sizeof(struct iwl_rx_phy_res));
 }
 
-static int iwl4965_get_single_channel_for_scan(struct iwl_priv *priv,
-					   struct ieee80211_vif *vif,
-					   enum ieee80211_band band,
-					   struct iwl_scan_channel *scan_ch)
-{
-	const struct ieee80211_supported_band *sband;
-	u16 passive_dwell = 0;
-	u16 active_dwell = 0;
-	int added = 0;
-	u16 channel = 0;
-
-	sband = iwl_get_hw_mode(priv, band);
-	if (!sband) {
-		IWL_ERR(priv, "invalid band\n");
-		return added;
-	}
-
-	active_dwell = iwl_legacy_get_active_dwell_time(priv, band, 0);
-	passive_dwell = iwl_legacy_get_passive_dwell_time(priv, band, vif);
-
-	if (passive_dwell <= active_dwell)
-		passive_dwell = active_dwell + 1;
-
-	channel = iwl_legacy_get_single_channel_number(priv, band);
-	if (channel) {
-		scan_ch->channel = cpu_to_le16(channel);
-		scan_ch->type = SCAN_CHANNEL_TYPE_PASSIVE;
-		scan_ch->active_dwell = cpu_to_le16(active_dwell);
-		scan_ch->passive_dwell = cpu_to_le16(passive_dwell);
-		/* Set txpower levels to defaults */
-		scan_ch->dsp_atten = 110;
-		if (band == IEEE80211_BAND_5GHZ)
-			scan_ch->tx_gain = ((1 << 5) | (3 << 3)) | 3;
-		else
-			scan_ch->tx_gain = ((1 << 5) | (5 << 3));
-		added++;
-	} else
-		IWL_ERR(priv, "no valid channel found\n");
-	return added;
-}
-
 static int iwl4965_get_channels_for_scan(struct iwl_priv *priv,
 				     struct ieee80211_vif *vif,
 				     enum ieee80211_band band,
@@ -858,16 +817,13 @@ int iwl4965_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	scan->quiet_time = IWL_ACTIVE_QUIET_TIME;
 
 	if (iwl_legacy_is_any_associated(priv)) {
-		u16 interval = 0;
+		u16 interval;
 		u32 extra;
 		u32 suspend_time = 100;
 		u32 scan_suspend_time = 100;
 
 		IWL_DEBUG_INFO(priv, "Scanning while associated...\n");
-		if (priv->is_internal_short_scan)
-			interval = 0;
-		else
-			interval = vif->bss_conf.beacon_int;
+		interval = vif->bss_conf.beacon_int;
 
 		scan->suspend_time = 0;
 		scan->max_out_time = cpu_to_le32(200 * 1024);
@@ -882,9 +838,7 @@ int iwl4965_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 			       scan_suspend_time, interval);
 	}
 
-	if (priv->is_internal_short_scan) {
-		IWL_DEBUG_SCAN(priv, "Start internal passive scan.\n");
-	} else if (priv->scan_request->n_ssids) {
+	if (priv->scan_request->n_ssids) {
 		int i, p = 0;
 		IWL_DEBUG_SCAN(priv, "Kicking off active scan\n");
 		for (i = 0; i < priv->scan_request->n_ssids; i++) {
@@ -981,38 +935,21 @@ int iwl4965_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	rx_chain |= rx_ant << RXON_RX_CHAIN_FORCE_SEL_POS;
 	rx_chain |= 0x1 << RXON_RX_CHAIN_DRIVER_FORCE_POS;
 	scan->rx_chain = cpu_to_le16(rx_chain);
-	if (!priv->is_internal_short_scan) {
-		cmd_len = iwl_legacy_fill_probe_req(priv,
+
+	cmd_len = iwl_legacy_fill_probe_req(priv,
 					(struct ieee80211_mgmt *)scan->data,
 					vif->addr,
 					priv->scan_request->ie,
 					priv->scan_request->ie_len,
 					IWL_MAX_SCAN_SIZE - sizeof(*scan));
-	} else {
-		/* use bcast addr, will not be transmitted but must be valid */
-		cmd_len = iwl_legacy_fill_probe_req(priv,
-					(struct ieee80211_mgmt *)scan->data,
-					iwlegacy_bcast_addr, NULL, 0,
-					IWL_MAX_SCAN_SIZE - sizeof(*scan));
-
-	}
 	scan->tx_cmd.len = cpu_to_le16(cmd_len);
 
 	scan->filter_flags |= (RXON_FILTER_ACCEPT_GRP_MSK |
 			       RXON_FILTER_BCON_AWARE_MSK);
 
-	if (priv->is_internal_short_scan) {
-		scan->channel_count =
-			iwl4965_get_single_channel_for_scan(priv, vif, band,
-				(void *)&scan->data[le16_to_cpu(
-				scan->tx_cmd.len)]);
-	} else {
-		scan->channel_count =
-			iwl4965_get_channels_for_scan(priv, vif, band,
-				is_active, n_probes,
-				(void *)&scan->data[le16_to_cpu(
-				scan->tx_cmd.len)]);
-	}
+	scan->channel_count = iwl4965_get_channels_for_scan(priv, vif, band,
+						is_active, n_probes,
+						(void *)&scan->data[cmd_len]);
 	if (scan->channel_count == 0) {
 		IWL_DEBUG_SCAN(priv, "channel count %d\n", scan->channel_count);
 		return -EIO;
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965.c b/drivers/net/wireless/iwlegacy/iwl-4965.c
index f59f588..59a4b53 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965.c
@@ -2149,7 +2149,6 @@ static struct iwl_base_params iwl4965_base_params = {
 	.use_bsm = true,
 	.led_compensation = 61,
 	.chain_noise_num_beacons = IWL4965_CAL_NUM_BEACONS,
-	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.wd_timeout = IWL_DEF_WD_TIMEOUT,
 	.temperature_kelvin = true,
 	.max_event_log_size = 512,
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.c b/drivers/net/wireless/iwlegacy/iwl-core.c
index 3be76bd..240d3a8 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.c
+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
@@ -1707,41 +1707,14 @@ iwl_legacy_update_stats(struct iwl_priv *priv, bool is_tx, __le16 fc, u16 len)
 EXPORT_SYMBOL(iwl_legacy_update_stats);
 #endif
 
-static void _iwl_legacy_force_rf_reset(struct iwl_priv *priv)
-{
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
-
-	if (!iwl_legacy_is_any_associated(priv)) {
-		IWL_DEBUG_SCAN(priv, "force reset rejected: not associated\n");
-		return;
-	}
-	/*
-	 * There is no easy and better way to force reset the radio,
-	 * the only known method is switching channel which will force to
-	 * reset and tune the radio.
-	 * Use internal short scan (single channel) operation to should
-	 * achieve this objective.
-	 * Driver should reset the radio when number of consecutive missed
-	 * beacon, or any other uCode error condition detected.
-	 */
-	IWL_DEBUG_INFO(priv, "perform radio reset.\n");
-	iwl_legacy_internal_short_hw_scan(priv);
-}
-
-
-int iwl_legacy_force_reset(struct iwl_priv *priv, int mode, bool external)
+int iwl_legacy_force_reset(struct iwl_priv *priv, bool external)
 {
 	struct iwl_force_reset *force_reset;
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return -EINVAL;
 
-	if (mode >= IWL_MAX_FORCE_RESET) {
-		IWL_DEBUG_INFO(priv, "invalid reset request.\n");
-		return -EINVAL;
-	}
-	force_reset = &priv->force_reset[mode];
+	force_reset = &priv->force_reset;
 	force_reset->reset_request_count++;
 	if (!external) {
 		if (force_reset->last_force_reset_jiffies &&
@@ -1754,37 +1727,34 @@ int iwl_legacy_force_reset(struct iwl_priv *priv, int mode, bool external)
 	}
 	force_reset->reset_success_count++;
 	force_reset->last_force_reset_jiffies = jiffies;
-	IWL_DEBUG_INFO(priv, "perform force reset (%d)\n", mode);
-	switch (mode) {
-	case IWL_RF_RESET:
-		_iwl_legacy_force_rf_reset(priv);
-		break;
-	case IWL_FW_RESET:
-		/*
-		 * if the request is from external(ex: debugfs),
-		 * then always perform the request in regardless the module
-		 * parameter setting
-		 * if the request is from internal (uCode error or driver
-		 * detect failure), then fw_restart module parameter
-		 * need to be check before performing firmware reload
-		 */
-		if (!external && !priv->cfg->mod_params->restart_fw) {
-			IWL_DEBUG_INFO(priv, "Cancel firmware reload based on "
-				       "module parameter setting\n");
-			break;
-		}
-		IWL_ERR(priv, "On demand firmware reload\n");
-		/* Set the FW error flag -- cleared on iwl_down */
-		set_bit(STATUS_FW_ERROR, &priv->status);
-		wake_up_interruptible(&priv->wait_command_queue);
-		/*
-		 * Keep the restart process from trying to send host
-		 * commands by clearing the INIT status bit
-		 */
-		clear_bit(STATUS_READY, &priv->status);
-		queue_work(priv->workqueue, &priv->restart);
-		break;
+
+	/*
+	 * if the request is from external(ex: debugfs),
+	 * then always perform the request in regardless the module
+	 * parameter setting
+	 * if the request is from internal (uCode error or driver
+	 * detect failure), then fw_restart module parameter
+	 * need to be check before performing firmware reload
+	 */
+
+	if (!external && !priv->cfg->mod_params->restart_fw) {
+		IWL_DEBUG_INFO(priv, "Cancel firmware reload based on "
+			       "module parameter setting\n");
+		return 0;
 	}
+
+	IWL_ERR(priv, "On demand firmware reload\n");
+
+	/* Set the FW error flag -- cleared on iwl_down */
+	set_bit(STATUS_FW_ERROR, &priv->status);
+	wake_up_interruptible(&priv->wait_command_queue);
+	/*
+	 * Keep the restart process from trying to send host
+	 * commands by clearing the INIT status bit
+	 */
+	clear_bit(STATUS_READY, &priv->status);
+	queue_work(priv->workqueue, &priv->restart);
+
 	return 0;
 }
 
@@ -1879,7 +1849,7 @@ static int iwl_legacy_check_stuck_queue(struct iwl_priv *priv, int cnt)
 	if (time_after(jiffies, timeout)) {
 		IWL_ERR(priv, "Queue %d stuck for %u ms.\n",
 				q->id, priv->cfg->base_params->wd_timeout);
-		ret = iwl_legacy_force_reset(priv, IWL_FW_RESET, false);
+		ret = iwl_legacy_force_reset(priv, false);
 		return (ret == -EAGAIN) ? 0 : 1;
 	}
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.h b/drivers/net/wireless/iwlegacy/iwl-core.h
index a821bdb..8f766e9 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.h
+++ b/drivers/net/wireless/iwlegacy/iwl-core.h
@@ -204,8 +204,6 @@ struct iwl_mod_params {
  *	to the deviation to achieve the desired led frequency.
  *	The detail algorithm is described in iwl-led.c
  * @chain_noise_num_beacons: number of beacons used to compute chain noise
- * @plcp_delta_threshold: plcp error rate threshold used to trigger
- *	radio tuning when there is a high receiving plcp error rate
  * @wd_timeout: TX queues watchdog timeout
  * @temperature_kelvin: temperature report by uCode in kelvin
  * @max_event_log_size: size of event log buffer size for ucode event logging
@@ -226,7 +224,6 @@ struct iwl_base_params {
 
 	u16 led_compensation;
 	int chain_noise_num_beacons;
-	u8 plcp_delta_threshold;
 	unsigned int wd_timeout;
 	bool temperature_kelvin;
 	u32 max_event_log_size;
@@ -438,7 +435,7 @@ int iwl_legacy_mac_hw_scan(struct ieee80211_hw *hw,
 		    struct ieee80211_vif *vif,
 		    struct cfg80211_scan_request *req);
 void iwl_legacy_internal_short_hw_scan(struct iwl_priv *priv);
-int iwl_legacy_force_reset(struct iwl_priv *priv, int mode, bool external);
+int iwl_legacy_force_reset(struct iwl_priv *priv, bool external);
 u16 iwl_legacy_fill_probe_req(struct iwl_priv *priv,
 			struct ieee80211_mgmt *frame,
 		       const u8 *ta, const u8 *ie, int ie_len, int left);
diff --git a/drivers/net/wireless/iwlegacy/iwl-debugfs.c b/drivers/net/wireless/iwlegacy/iwl-debugfs.c
index 2d32438..88ffc92 100644
--- a/drivers/net/wireless/iwlegacy/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-debugfs.c
@@ -1236,72 +1236,31 @@ static ssize_t iwl_legacy_dbgfs_missed_beacon_write(struct file *file,
 	return count;
 }
 
-static ssize_t iwl_legacy_dbgfs_plcp_delta_read(struct file *file,
-					char __user *user_buf,
-					size_t count, loff_t *ppos) {
-
-	struct iwl_priv *priv = file->private_data;
-	int pos = 0;
-	char buf[12];
-	const size_t bufsz = sizeof(buf);
-
-	pos += scnprintf(buf + pos, bufsz - pos, "%u\n",
-			priv->cfg->base_params->plcp_delta_threshold);
-
-	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-}
-
-static ssize_t iwl_legacy_dbgfs_plcp_delta_write(struct file *file,
-					const char __user *user_buf,
-					size_t count, loff_t *ppos) {
-
-	struct iwl_priv *priv = file->private_data;
-	char buf[8];
-	int buf_size;
-	int plcp;
-
-	memset(buf, 0, sizeof(buf));
-	buf_size = min(count, sizeof(buf) -  1);
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-	if (sscanf(buf, "%d", &plcp) != 1)
-		return -EINVAL;
-	if ((plcp < IWL_MAX_PLCP_ERR_THRESHOLD_MIN) ||
-		(plcp > IWL_MAX_PLCP_ERR_THRESHOLD_MAX))
-		priv->cfg->base_params->plcp_delta_threshold =
-			IWL_MAX_PLCP_ERR_THRESHOLD_DISABLE;
-	else
-		priv->cfg->base_params->plcp_delta_threshold = plcp;
-	return count;
-}
-
 static ssize_t iwl_legacy_dbgfs_force_reset_read(struct file *file,
 					char __user *user_buf,
 					size_t count, loff_t *ppos) {
 
 	struct iwl_priv *priv = file->private_data;
-	int i, pos = 0;
+	int pos = 0;
 	char buf[300];
 	const size_t bufsz = sizeof(buf);
 	struct iwl_force_reset *force_reset;
 
-	for (i = 0; i < IWL_MAX_FORCE_RESET; i++) {
-		force_reset = &priv->force_reset[i];
-		pos += scnprintf(buf + pos, bufsz - pos,
-				"Force reset method %d\n", i);
-		pos += scnprintf(buf + pos, bufsz - pos,
-				"\tnumber of reset request: %d\n",
-				force_reset->reset_request_count);
-		pos += scnprintf(buf + pos, bufsz - pos,
-				"\tnumber of reset request success: %d\n",
-				force_reset->reset_success_count);
-		pos += scnprintf(buf + pos, bufsz - pos,
-				"\tnumber of reset request reject: %d\n",
-				force_reset->reset_reject_count);
-		pos += scnprintf(buf + pos, bufsz - pos,
-				"\treset duration: %lu\n",
-				force_reset->reset_duration);
-	}
+	force_reset = &priv->force_reset;
+
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"\tnumber of reset request: %d\n",
+			force_reset->reset_request_count);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"\tnumber of reset request success: %d\n",
+			force_reset->reset_success_count);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"\tnumber of reset request reject: %d\n",
+			force_reset->reset_reject_count);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"\treset duration: %lu\n",
+			force_reset->reset_duration);
+
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
@@ -1309,25 +1268,11 @@ static ssize_t iwl_legacy_dbgfs_force_reset_write(struct file *file,
 					const char __user *user_buf,
 					size_t count, loff_t *ppos) {
 
+	int ret;
 	struct iwl_priv *priv = file->private_data;
-	char buf[8];
-	int buf_size;
-	int reset, ret;
 
-	memset(buf, 0, sizeof(buf));
-	buf_size = min(count, sizeof(buf) -  1);
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-	if (sscanf(buf, "%d", &reset) != 1)
-		return -EINVAL;
-	switch (reset) {
-	case IWL_RF_RESET:
-	case IWL_FW_RESET:
-		ret = iwl_legacy_force_reset(priv, reset, true);
-		break;
-	default:
-		return -EINVAL;
-	}
+	ret = iwl_legacy_force_reset(priv, true);
+
 	return ret ? ret : count;
 }
 
@@ -1370,7 +1315,6 @@ DEBUGFS_WRITE_FILE_OPS(clear_traffic_statistics);
 DEBUGFS_READ_WRITE_FILE_OPS(ucode_tracing);
 DEBUGFS_READ_FILE_OPS(fh_reg);
 DEBUGFS_READ_WRITE_FILE_OPS(missed_beacon);
-DEBUGFS_READ_WRITE_FILE_OPS(plcp_delta);
 DEBUGFS_READ_WRITE_FILE_OPS(force_reset);
 DEBUGFS_READ_FILE_OPS(rxon_flags);
 DEBUGFS_READ_FILE_OPS(rxon_filter_flags);
@@ -1420,7 +1364,6 @@ int iwl_legacy_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(clear_traffic_statistics, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(fh_reg, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(missed_beacon, dir_debug, S_IWUSR);
-	DEBUGFS_ADD_FILE(plcp_delta, dir_debug, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(force_reset, dir_debug, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(ucode_rx_stats, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(ucode_tx_stats, dir_debug, S_IRUSR);
diff --git a/drivers/net/wireless/iwlegacy/iwl-dev.h b/drivers/net/wireless/iwlegacy/iwl-dev.h
index ea30122..c5a135a 100644
--- a/drivers/net/wireless/iwlegacy/iwl-dev.h
+++ b/drivers/net/wireless/iwlegacy/iwl-dev.h
@@ -895,18 +895,6 @@ struct iwl_event_log {
 #define IWL_HOST_INT_CALIB_TIMEOUT_DEF	(0x10)
 #define IWL_HOST_INT_CALIB_TIMEOUT_MIN	(0x0)
 
-/*
- * This is the threshold value of plcp error rate per 100mSecs.  It is
- * used to set and check for the validity of plcp_delta.
- */
-#define IWL_MAX_PLCP_ERR_THRESHOLD_MIN	(1)
-#define IWL_MAX_PLCP_ERR_THRESHOLD_DEF	(50)
-#define IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF	(100)
-#define IWL_MAX_PLCP_ERR_EXT_LONG_THRESHOLD_DEF	(200)
-#define IWL_MAX_PLCP_ERR_THRESHOLD_MAX	(255)
-#define IWL_MAX_PLCP_ERR_THRESHOLD_DISABLE	(0)
-
-#define IWL_DELAY_NEXT_FORCE_RF_RESET  (HZ*3)
 #define IWL_DELAY_NEXT_FORCE_FW_RELOAD (HZ*5)
 
 /* TX queue watchdog timeouts in mSecs */
@@ -914,12 +902,6 @@ struct iwl_event_log {
 #define IWL_LONG_WD_TIMEOUT	(10000)
 #define IWL_MAX_WD_TIMEOUT	(120000)
 
-enum iwl_reset {
-	IWL_RF_RESET = 0,
-	IWL_FW_RESET,
-	IWL_MAX_FORCE_RESET,
-};
-
 struct iwl_force_reset {
 	int reset_request_count;
 	int reset_success_count;
@@ -1032,11 +1014,8 @@ struct iwl_priv {
 	/* track IBSS manager (last beacon) status */
 	u32 ibss_manager;
 
-	/* storing the jiffies when the plcp error rate is received */
-	unsigned long plcp_jiffies;
-
 	/* force reset */
-	struct iwl_force_reset force_reset[IWL_MAX_FORCE_RESET];
+	struct iwl_force_reset force_reset;
 
 	/* we allocate array of iwl_channel_info for NIC's valid channels.
 	 *    Access via channel # using indirect index array */
@@ -1057,7 +1036,6 @@ struct iwl_priv {
 	enum ieee80211_band scan_band;
 	struct cfg80211_scan_request *scan_request;
 	struct ieee80211_vif *scan_vif;
-	bool is_internal_short_scan;
 	u8 scan_tx_ant[IEEE80211_NUM_BANDS];
 	u8 mgmt_tx_ant;
 
@@ -1256,7 +1234,6 @@ struct iwl_priv {
 	struct iwl_rxon_context *beacon_ctx;
 	struct sk_buff *beacon_skb;
 
-	struct work_struct start_internal_scan;
 	struct work_struct tx_flush;
 
 	struct tasklet_struct irq_tasklet;
diff --git a/drivers/net/wireless/iwlegacy/iwl-scan.c b/drivers/net/wireless/iwlegacy/iwl-scan.c
index 353234a..a6b5222 100644
--- a/drivers/net/wireless/iwlegacy/iwl-scan.c
+++ b/drivers/net/wireless/iwlegacy/iwl-scan.c
@@ -101,7 +101,6 @@ static void iwl_legacy_complete_scan(struct iwl_priv *priv, bool aborted)
 		ieee80211_scan_completed(priv->hw, aborted);
 	}
 
-	priv->is_internal_short_scan = false;
 	priv->scan_vif = NULL;
 	priv->scan_request = NULL;
 }
@@ -329,10 +328,8 @@ void iwl_legacy_init_scan_params(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_legacy_init_scan_params);
 
-static int __must_check iwl_legacy_scan_initiate(struct iwl_priv *priv,
-					  struct ieee80211_vif *vif,
-					  bool internal,
-					  enum ieee80211_band band)
+static int iwl_legacy_scan_initiate(struct iwl_priv *priv,
+				    struct ieee80211_vif *vif)
 {
 	int ret;
 
@@ -359,18 +356,14 @@ static int __must_check iwl_legacy_scan_initiate(struct iwl_priv *priv,
 		return -EBUSY;
 	}
 
-	IWL_DEBUG_SCAN(priv, "Starting %sscan...\n",
-			internal ? "internal short " : "");
+	IWL_DEBUG_SCAN(priv, "Starting scan...\n");
 
 	set_bit(STATUS_SCANNING, &priv->status);
-	priv->is_internal_short_scan = internal;
 	priv->scan_start = jiffies;
-	priv->scan_band = band;
 
 	ret = priv->cfg->ops->utils->request_scan(priv, vif);
 	if (ret) {
 		clear_bit(STATUS_SCANNING, &priv->status);
-		priv->is_internal_short_scan = false;
 		return ret;
 	}
 
@@ -394,8 +387,7 @@ int iwl_legacy_mac_hw_scan(struct ieee80211_hw *hw,
 
 	mutex_lock(&priv->mutex);
 
-	if (test_bit(STATUS_SCANNING, &priv->status) &&
-	    !priv->is_internal_short_scan) {
+	if (test_bit(STATUS_SCANNING, &priv->status)) {
 		IWL_DEBUG_SCAN(priv, "Scan already in progress.\n");
 		ret = -EAGAIN;
 		goto out_unlock;
@@ -404,17 +396,9 @@ int iwl_legacy_mac_hw_scan(struct ieee80211_hw *hw,
 	/* mac80211 will only ask for one band at a time */
 	priv->scan_request = req;
 	priv->scan_vif = vif;
+	priv->scan_band = req->channels[0]->band;
 
-	/*
-	 * If an internal scan is in progress, just set
-	 * up the scan_request as per above.
-	 */
-	if (priv->is_internal_short_scan) {
-		IWL_DEBUG_SCAN(priv, "SCAN request during internal scan\n");
-		ret = 0;
-	} else
-		ret = iwl_legacy_scan_initiate(priv, vif, false,
-					req->channels[0]->band);
+	ret = iwl_legacy_scan_initiate(priv, vif);
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 
@@ -425,40 +409,6 @@ out_unlock:
 }
 EXPORT_SYMBOL(iwl_legacy_mac_hw_scan);
 
-/*
- * internal short scan, this function should only been called while associated.
- * It will reset and tune the radio to prevent possible RF related problem
- */
-void iwl_legacy_internal_short_hw_scan(struct iwl_priv *priv)
-{
-	queue_work(priv->workqueue, &priv->start_internal_scan);
-}
-
-static void iwl_legacy_bg_start_internal_scan(struct work_struct *work)
-{
-	struct iwl_priv *priv =
-		container_of(work, struct iwl_priv, start_internal_scan);
-
-	IWL_DEBUG_SCAN(priv, "Start internal scan\n");
-
-	mutex_lock(&priv->mutex);
-
-	if (priv->is_internal_short_scan == true) {
-		IWL_DEBUG_SCAN(priv, "Internal scan already in progress\n");
-		goto unlock;
-	}
-
-	if (test_bit(STATUS_SCANNING, &priv->status)) {
-		IWL_DEBUG_SCAN(priv, "Scan already in progress.\n");
-		goto unlock;
-	}
-
-	if (iwl_legacy_scan_initiate(priv, NULL, true, priv->band))
-		IWL_DEBUG_SCAN(priv, "failed to start internal short scan\n");
- unlock:
-	mutex_unlock(&priv->mutex);
-}
-
 static void iwl_legacy_bg_scan_check(struct work_struct *data)
 {
 	struct iwl_priv *priv =
@@ -542,8 +492,7 @@ static void iwl_legacy_bg_scan_completed(struct work_struct *work)
 	    container_of(work, struct iwl_priv, scan_completed);
 	bool aborted;
 
-	IWL_DEBUG_SCAN(priv, "Completed %sscan.\n",
-		       priv->is_internal_short_scan ? "internal short " : "");
+	IWL_DEBUG_SCAN(priv, "Completed scan.\n");
 
 	cancel_delayed_work(&priv->scan_check);
 
@@ -558,27 +507,6 @@ static void iwl_legacy_bg_scan_completed(struct work_struct *work)
 		goto out_settings;
 	}
 
-	if (priv->is_internal_short_scan && !aborted) {
-		int err;
-
-		/* Check if mac80211 requested scan during our internal scan */
-		if (priv->scan_request == NULL)
-			goto out_complete;
-
-		/* If so request a new scan */
-		err = iwl_legacy_scan_initiate(priv, priv->scan_vif, false,
-					priv->scan_request->channels[0]->band);
-		if (err) {
-			IWL_DEBUG_SCAN(priv,
-				"failed to initiate pending scan: %d\n", err);
-			aborted = true;
-			goto out_complete;
-		}
-
-		goto out;
-	}
-
-out_complete:
 	iwl_legacy_complete_scan(priv, aborted);
 
 out_settings:
@@ -590,8 +518,7 @@ out_settings:
 	 * We do not commit power settings while scan is pending,
 	 * do it now if the settings changed.
 	 */
-	iwl_legacy_power_set_mode(priv, &priv->power_data.sleep_cmd_next,
-								false);
+	iwl_legacy_power_set_mode(priv, &priv->power_data.sleep_cmd_next, false);
 	iwl_legacy_set_tx_power(priv, priv->tx_power_next, false);
 
 	priv->cfg->ops->utils->post_scan(priv);
@@ -604,15 +531,12 @@ void iwl_legacy_setup_scan_deferred_work(struct iwl_priv *priv)
 {
 	INIT_WORK(&priv->scan_completed, iwl_legacy_bg_scan_completed);
 	INIT_WORK(&priv->abort_scan, iwl_legacy_bg_abort_scan);
-	INIT_WORK(&priv->start_internal_scan,
-				iwl_legacy_bg_start_internal_scan);
 	INIT_DELAYED_WORK(&priv->scan_check, iwl_legacy_bg_scan_check);
 }
 EXPORT_SYMBOL(iwl_legacy_setup_scan_deferred_work);
 
 void iwl_legacy_cancel_scan_deferred_work(struct iwl_priv *priv)
 {
-	cancel_work_sync(&priv->start_internal_scan);
 	cancel_work_sync(&priv->abort_scan);
 	cancel_work_sync(&priv->scan_completed);
 
diff --git a/drivers/net/wireless/iwlegacy/iwl3945-base.c b/drivers/net/wireless/iwlegacy/iwl3945-base.c
index 0ee6be6..da42442 100644
--- a/drivers/net/wireless/iwlegacy/iwl3945-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl3945-base.c
@@ -1762,49 +1762,6 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 #endif
 }
 
-static int iwl3945_get_single_channel_for_scan(struct iwl_priv *priv,
-					       struct ieee80211_vif *vif,
-					       enum ieee80211_band band,
-					       struct iwl3945_scan_channel *scan_ch)
-{
-	const struct ieee80211_supported_band *sband;
-	u16 passive_dwell = 0;
-	u16 active_dwell = 0;
-	int added = 0;
-	u8 channel = 0;
-
-	sband = iwl_get_hw_mode(priv, band);
-	if (!sband) {
-		IWL_ERR(priv, "invalid band\n");
-		return added;
-	}
-
-	active_dwell = iwl_legacy_get_active_dwell_time(priv, band, 0);
-	passive_dwell = iwl_legacy_get_passive_dwell_time(priv, band, vif);
-
-	if (passive_dwell <= active_dwell)
-		passive_dwell = active_dwell + 1;
-
-
-	channel = iwl_legacy_get_single_channel_number(priv, band);
-
-	if (channel) {
-		scan_ch->channel = channel;
-		scan_ch->type = 0;	/* passive */
-		scan_ch->active_dwell = cpu_to_le16(active_dwell);
-		scan_ch->passive_dwell = cpu_to_le16(passive_dwell);
-		/* Set txpower levels to defaults */
-		scan_ch->tpc.dsp_atten = 110;
-		if (band == IEEE80211_BAND_5GHZ)
-			scan_ch->tpc.tx_gain = ((1 << 5) | (3 << 3)) | 3;
-		else
-			scan_ch->tpc.tx_gain = ((1 << 5) | (5 << 3));
-		added++;
-	} else
-		IWL_ERR(priv, "no valid channel found\n");
-	return added;
-}
-
 static int iwl3945_get_channels_for_scan(struct iwl_priv *priv,
 					 enum ieee80211_band band,
 				     u8 is_active, u8 n_probes,
@@ -2816,6 +2773,7 @@ int iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	enum ieee80211_band band;
 	bool is_active = false;
 	int ret;
+	u16 len;
 
 	lockdep_assert_held(&priv->mutex);
 
@@ -2834,17 +2792,14 @@ int iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	scan->quiet_time = IWL_ACTIVE_QUIET_TIME;
 
 	if (iwl_legacy_is_associated(priv, IWL_RXON_CTX_BSS)) {
-		u16 interval = 0;
+		u16 interval;
 		u32 extra;
 		u32 suspend_time = 100;
 		u32 scan_suspend_time = 100;
 
 		IWL_DEBUG_INFO(priv, "Scanning while associated...\n");
 
-		if (priv->is_internal_short_scan)
-			interval = 0;
-		else
-			interval = vif->bss_conf.beacon_int;
+		interval = vif->bss_conf.beacon_int;
 
 		scan->suspend_time = 0;
 		scan->max_out_time = cpu_to_le32(200 * 1024);
@@ -2866,9 +2821,7 @@ int iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 			       scan_suspend_time, interval);
 	}
 
-	if (priv->is_internal_short_scan) {
-		IWL_DEBUG_SCAN(priv, "Start internal passive scan.\n");
-	} else if (priv->scan_request->n_ssids) {
+	if (priv->scan_request->n_ssids) {
 		int i, p = 0;
 		IWL_DEBUG_SCAN(priv, "Kicking off active scan\n");
 		for (i = 0; i < priv->scan_request->n_ssids; i++) {
@@ -2919,36 +2872,17 @@ int iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	scan->good_CRC_th = is_active ? IWL_GOOD_CRC_TH_DEFAULT :
 					IWL_GOOD_CRC_TH_DISABLED;
 
-	if (!priv->is_internal_short_scan) {
-		scan->tx_cmd.len = cpu_to_le16(
-			iwl_legacy_fill_probe_req(priv,
-				(struct ieee80211_mgmt *)scan->data,
-				vif->addr,
-				priv->scan_request->ie,
-				priv->scan_request->ie_len,
-				IWL_MAX_SCAN_SIZE - sizeof(*scan)));
-	} else {
-		/* use bcast addr, will not be transmitted but must be valid */
-		scan->tx_cmd.len = cpu_to_le16(
-			iwl_legacy_fill_probe_req(priv,
-				(struct ieee80211_mgmt *)scan->data,
-				iwlegacy_bcast_addr, NULL, 0,
-				IWL_MAX_SCAN_SIZE - sizeof(*scan)));
-	}
+	len = iwl_legacy_fill_probe_req(priv, (struct ieee80211_mgmt *)scan->data,
+					vif->addr, priv->scan_request->ie,
+					priv->scan_request->ie_len,
+					IWL_MAX_SCAN_SIZE - sizeof(*scan));
+	scan->tx_cmd.len = cpu_to_le16(len);
+
 	/* select Rx antennas */
 	scan->flags |= iwl3945_get_antenna_flags(priv);
 
-	if (priv->is_internal_short_scan) {
-		scan->channel_count =
-			iwl3945_get_single_channel_for_scan(priv, vif, band,
-				(void *)&scan->data[le16_to_cpu(
-				scan->tx_cmd.len)]);
-	} else {
-		scan->channel_count =
-			iwl3945_get_channels_for_scan(priv, band, is_active, n_probes,
-				(void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)], vif);
-	}
-
+	scan->channel_count = iwl3945_get_channels_for_scan(priv, band, is_active, n_probes,
+							    (void *)&scan->data[len], vif);
 	if (scan->channel_count == 0) {
 		IWL_DEBUG_SCAN(priv, "channel count %d\n", scan->channel_count);
 		return -EIO;
@@ -3824,10 +3758,7 @@ static int iwl3945_init_drv(struct iwl_priv *priv)
 	priv->missed_beacon_threshold = IWL_MISSED_BEACON_THRESHOLD_DEF;
 
 	/* initialize force reset */
-	priv->force_reset[IWL_RF_RESET].reset_duration =
-		IWL_DELAY_NEXT_FORCE_RF_RESET;
-	priv->force_reset[IWL_FW_RESET].reset_duration =
-		IWL_DELAY_NEXT_FORCE_FW_RELOAD;
+	priv->force_reset.reset_duration = IWL_DELAY_NEXT_FORCE_FW_RELOAD;
 
 	if (eeprom->version < EEPROM_3945_EEPROM_VERSION) {
 		IWL_WARN(priv, "Unsupported EEPROM version: 0x%04X\n",
diff --git a/drivers/net/wireless/iwlegacy/iwl4965-base.c b/drivers/net/wireless/iwlegacy/iwl4965-base.c
index 7157ba5..ed86b22 100644
--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -3135,10 +3135,7 @@ static int iwl4965_init_drv(struct iwl_priv *priv)
 	priv->_4965.agg_tids_count = 0;
 
 	/* initialize force reset */
-	priv->force_reset[IWL_RF_RESET].reset_duration =
-		IWL_DELAY_NEXT_FORCE_RF_RESET;
-	priv->force_reset[IWL_FW_RESET].reset_duration =
-		IWL_DELAY_NEXT_FORCE_FW_RELOAD;
+	priv->force_reset.reset_duration = IWL_DELAY_NEXT_FORCE_FW_RELOAD;
 
 	/* Choose which receivers/antennas to use */
 	if (priv->cfg->ops->hcmd->set_rxon_chain)
-- 
1.7.1

