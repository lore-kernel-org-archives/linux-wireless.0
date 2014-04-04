Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:36248 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbaDDLYe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2014 07:24:34 -0400
Received: by mail-we0-f180.google.com with SMTP id p61so3289142wes.11
        for <linux-wireless@vger.kernel.org>; Fri, 04 Apr 2014 04:24:33 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: refactor monitor code
Date: Fri,  4 Apr 2014 13:18:25 +0200
Message-Id: <1396610305-5229-1-git-send-email-michal.kazior@tieto.com> (sfid-20140404_132439_070850_ADEF0B7A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was possible to create/delete/start/stop
monitor vdev from a few places that were not
exclusively protected against each other. This
resulted in monitor vdev being stopped/removed by
one call origin while another one was expecting it
to continue running.

For example if CAC was started and interface's
promiscuous mode was toggled monitor vdev was
removed from the driver meaning no radar would be
detected. In additional a warning would be printed
upon CAC completion complaining it tried to stop
non-running monitor vdev.

The patch simplifies monitor code by removing
IEEE80211_HW_WANT_MONITOR_VIF (which wasn't really
ever needed) and improves state tracking. It also
unifies prints.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h   |   5 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c |   2 +-
 drivers/net/wireless/ath/ath10k/mac.c    | 224 ++++++++++++++++++-------------
 3 files changed, 133 insertions(+), 98 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 8edd6da..3302976 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -428,9 +428,10 @@ struct ath10k {
 	struct cfg80211_chan_def chandef;
 
 	int free_vdev_map;
+	bool promisc;
+	bool monitor;
 	int monitor_vdev_id;
-	bool monitor_enabled;
-	bool monitor_present;
+	bool monitor_started;
 	unsigned int filter_flags;
 	unsigned long dev_flags;
 	u32 dfs_block_radar_events;
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index f7ecc10..f85a3cf 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1120,7 +1120,7 @@ static bool ath10k_htt_rx_amsdu_allowed(struct ath10k_htt *htt,
 	if (status != HTT_RX_IND_MPDU_STATUS_OK &&
 	    status != HTT_RX_IND_MPDU_STATUS_TKIP_MIC_ERR &&
 	    status != HTT_RX_IND_MPDU_STATUS_ERR_INV_PEER &&
-	    !htt->ar->monitor_enabled) {
+	    !htt->ar->monitor_started) {
 		ath10k_dbg(ATH10K_DBG_HTT,
 			   "htt rx ignoring frame w/ status %d\n",
 			   status);
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 58ec5a7..3c99803 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -574,7 +574,20 @@ static int ath10k_vdev_stop(struct ath10k_vif *arvif)
 	return ret;
 }
 
-static int ath10k_monitor_start(struct ath10k *ar, int vdev_id)
+static bool ath10k_monitor_is_enabled(struct ath10k *ar)
+{
+	lockdep_assert_held(&ar->conf_mutex);
+
+	ath10k_dbg(ATH10K_DBG_MAC,
+		   "mac monitor refs: promisc %d monitor %d cac %d\n",
+		   ar->promisc, ar->monitor,
+		   test_bit(ATH10K_CAC_RUNNING, &ar->dev_flags));
+
+	return ar->promisc || ar->monitor ||
+	       test_bit(ATH10K_CAC_RUNNING, &ar->dev_flags);
+}
+
+static int ath10k_monitor_vdev_start(struct ath10k *ar, int vdev_id)
 {
 	struct cfg80211_chan_def *chandef = &ar->chandef;
 	struct ieee80211_channel *channel = chandef->chan;
@@ -583,11 +596,6 @@ static int ath10k_monitor_start(struct ath10k *ar, int vdev_id)
 
 	lockdep_assert_held(&ar->conf_mutex);
 
-	if (!ar->monitor_present) {
-		ath10k_warn("mac monitor stop -- monitor is not present\n");
-		return -EINVAL;
-	}
-
 	arg.vdev_id = vdev_id;
 	arg.channel.freq = channel->center_freq;
 	arg.channel.band_center_freq1 = chandef->center_freq1;
@@ -605,14 +613,14 @@ static int ath10k_monitor_start(struct ath10k *ar, int vdev_id)
 
 	ret = ath10k_wmi_vdev_start(ar, &arg);
 	if (ret) {
-		ath10k_warn("failed to start Monitor vdev %i: %d\n",
+		ath10k_warn("failed to request monitor vdev %i start: %d\n",
 			    vdev_id, ret);
 		return ret;
 	}
 
 	ret = ath10k_vdev_setup_sync(ar);
 	if (ret) {
-		ath10k_warn("failed to syncronise setup for monitor vdev %i: %d\n",
+		ath10k_warn("failed to synchronize setup for monitor vdev %i: %d\n",
 			    vdev_id, ret);
 		return ret;
 	}
@@ -625,8 +633,9 @@ static int ath10k_monitor_start(struct ath10k *ar, int vdev_id)
 	}
 
 	ar->monitor_vdev_id = vdev_id;
-	ar->monitor_enabled = true;
 
+	ath10k_dbg(ATH10K_DBG_MAC, "mac monitor vdev %i started\n",
+		   ar->monitor_vdev_id);
 	return 0;
 
 vdev_stop:
@@ -638,22 +647,12 @@ vdev_stop:
 	return ret;
 }
 
-static int ath10k_monitor_stop(struct ath10k *ar)
+static int ath10k_monitor_vdev_stop(struct ath10k *ar)
 {
 	int ret = 0;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
-	if (!ar->monitor_present) {
-		ath10k_warn("mac monitor stop -- monitor is not present\n");
-		return -EINVAL;
-	}
-
-	if (!ar->monitor_enabled) {
-		ath10k_warn("mac monitor stop -- monitor is not enabled\n");
-		return -EINVAL;
-	}
-
 	ret = ath10k_wmi_vdev_down(ar, ar->monitor_vdev_id);
 	if (ret)
 		ath10k_warn("failed to put down monitor vdev %i: %d\n",
@@ -661,7 +660,7 @@ static int ath10k_monitor_stop(struct ath10k *ar)
 
 	ret = ath10k_wmi_vdev_stop(ar, ar->monitor_vdev_id);
 	if (ret)
-		ath10k_warn("failed to stop monitor vdev %i: %d\n",
+		ath10k_warn("failed to to request monitor vdev %i stop: %d\n",
 			    ar->monitor_vdev_id, ret);
 
 	ret = ath10k_vdev_setup_sync(ar);
@@ -669,24 +668,20 @@ static int ath10k_monitor_stop(struct ath10k *ar)
 		ath10k_warn("failed to synchronise monitor vdev %i: %d\n",
 			    ar->monitor_vdev_id, ret);
 
-	ar->monitor_enabled = false;
+	ath10k_dbg(ATH10K_DBG_MAC, "mac monitor vdev %i stopped\n",
+		   ar->monitor_vdev_id);
 	return ret;
 }
 
-static int ath10k_monitor_create(struct ath10k *ar)
+static int ath10k_monitor_vdev_create(struct ath10k *ar)
 {
 	int bit, ret = 0;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
-	if (ar->monitor_present) {
-		ath10k_warn("monitor mode already enabled\n");
-		return 0;
-	}
-
 	bit = ffs(ar->free_vdev_map);
 	if (bit == 0) {
-		ath10k_warn("no free vdev slots\n");
+		ath10k_warn("failed to find free vdev id for monitor vdev\n");
 		return -ENOMEM;
 	}
 
@@ -697,7 +692,7 @@ static int ath10k_monitor_create(struct ath10k *ar)
 				     WMI_VDEV_TYPE_MONITOR,
 				     0, ar->mac_addr);
 	if (ret) {
-		ath10k_warn("failed to create WMI monitor vdev %i: %d\n",
+		ath10k_warn("failed to request monitor vdev %i creation: %d\n",
 			    ar->monitor_vdev_id, ret);
 		goto vdev_fail;
 	}
@@ -705,7 +700,6 @@ static int ath10k_monitor_create(struct ath10k *ar)
 	ath10k_dbg(ATH10K_DBG_MAC, "mac monitor vdev %d created\n",
 		   ar->monitor_vdev_id);
 
-	ar->monitor_present = true;
 	return 0;
 
 vdev_fail:
@@ -716,30 +710,91 @@ vdev_fail:
 	return ret;
 }
 
-static int ath10k_monitor_destroy(struct ath10k *ar)
+static int ath10k_monitor_vdev_delete(struct ath10k *ar)
 {
 	int ret = 0;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
-	if (!ar->monitor_present)
-		return 0;
-
 	ret = ath10k_wmi_vdev_delete(ar, ar->monitor_vdev_id);
 	if (ret) {
-		ath10k_warn("failed to delete WMI vdev %i: %d\n",
+		ath10k_warn("failed to request wmi monitor vdev %i removal: %d\n",
 			    ar->monitor_vdev_id, ret);
 		return ret;
 	}
 
 	ar->free_vdev_map |= 1 << (ar->monitor_vdev_id);
-	ar->monitor_present = false;
 
 	ath10k_dbg(ATH10K_DBG_MAC, "mac monitor vdev %d deleted\n",
 		   ar->monitor_vdev_id);
 	return ret;
 }
 
+static int ath10k_monitor_start(struct ath10k *ar)
+{
+	int ret;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	if (!ath10k_monitor_is_enabled(ar)) {
+		ath10k_warn("trying to start monitor with no references\n");
+		return 0;
+	}
+
+	if (ar->monitor_started) {
+		ath10k_dbg(ATH10K_DBG_MAC, "mac monitor already started\n");
+		return 0;
+	}
+
+	ret = ath10k_monitor_vdev_create(ar);
+	if (ret) {
+		ath10k_warn("failed to create monitor vdev: %d\n", ret);
+		return ret;
+	}
+
+	ret = ath10k_monitor_vdev_start(ar, ar->monitor_vdev_id);
+	if (ret) {
+		ath10k_warn("failed to start monitor vdev: %d\n", ret);
+		ath10k_monitor_vdev_delete(ar);
+		return ret;
+	}
+
+	ar->monitor_started = true;
+	ath10k_dbg(ATH10K_DBG_MAC, "mac monitor started\n");
+
+	return 0;
+}
+
+static void ath10k_monitor_stop(struct ath10k *ar)
+{
+	int ret;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	if (ath10k_monitor_is_enabled(ar)) {
+		ath10k_dbg(ATH10K_DBG_MAC,
+			   "mac monitor will be stopped later\n");
+		return;
+	}
+
+	if (!ar->monitor_started) {
+		ath10k_dbg(ATH10K_DBG_MAC,
+			   "mac monitor probably failed to start earlier\n");
+		return;
+	}
+
+	ret = ath10k_monitor_vdev_stop(ar);
+	if (ret)
+		ath10k_warn("failed to stop monitor vdev: %d\n", ret);
+
+	ret = ath10k_monitor_vdev_delete(ar);
+	if (ret)
+		ath10k_warn("failed to delete monitor vdev: %d\n", ret);
+
+	ar->monitor_started = false;
+	ath10k_dbg(ATH10K_DBG_MAC, "mac monitor stopped\n");
+}
+
 static int ath10k_recalc_rtscts_prot(struct ath10k_vif *arvif)
 {
 	struct ath10k *ar = arvif->ar;
@@ -768,19 +823,13 @@ static int ath10k_start_cac(struct ath10k *ar)
 
 	set_bit(ATH10K_CAC_RUNNING, &ar->dev_flags);
 
-	ret = ath10k_monitor_create(ar);
+	ret = ath10k_monitor_start(ar);
 	if (ret) {
+		ath10k_warn("failed to start monitor (cac): %d\n", ret);
 		clear_bit(ATH10K_CAC_RUNNING, &ar->dev_flags);
 		return ret;
 	}
 
-	ret = ath10k_monitor_start(ar, ar->monitor_vdev_id);
-	if (ret) {
-		clear_bit(ATH10K_CAC_RUNNING, &ar->dev_flags);
-		ath10k_monitor_destroy(ar);
-		return ret;
-	}
-
 	ath10k_dbg(ATH10K_DBG_MAC, "mac cac start monitor vdev %d\n",
 		   ar->monitor_vdev_id);
 
@@ -795,9 +844,8 @@ static int ath10k_stop_cac(struct ath10k *ar)
 	if (!test_bit(ATH10K_CAC_RUNNING, &ar->dev_flags))
 		return 0;
 
-	ath10k_monitor_stop(ar);
-	ath10k_monitor_destroy(ar);
 	clear_bit(ATH10K_CAC_RUNNING, &ar->dev_flags);
+	ath10k_monitor_stop(ar);
 
 	ath10k_dbg(ATH10K_DBG_MAC, "mac cac finished\n");
 
@@ -1828,7 +1876,7 @@ static u8 ath10k_tx_h_get_vdev_id(struct ath10k *ar,
 	if (info->control.vif)
 		return ath10k_vif_to_arvif(info->control.vif)->vdev_id;
 
-	if (ar->monitor_enabled)
+	if (ar->monitor_started)
 		return ar->monitor_vdev_id;
 
 	ath10k_warn("failed to resolve vdev id\n");
@@ -2266,7 +2314,13 @@ void ath10k_halt(struct ath10k *ar)
 {
 	lockdep_assert_held(&ar->conf_mutex);
 
-	ath10k_stop_cac(ar);
+	if (ath10k_monitor_is_enabled(ar)) {
+		clear_bit(ATH10K_CAC_RUNNING, &ar->dev_flags);
+		ar->promisc = false;
+		ar->monitor = false;
+		ath10k_monitor_stop(ar);
+	}
+
 	del_timer_sync(&ar->scan.timeout);
 	ath10k_offchan_tx_purge(ar);
 	ath10k_mgmt_over_wmi_tx_purge(ar);
@@ -2413,7 +2467,6 @@ static const char *chandef_get_width(enum nl80211_chan_width width)
 static void ath10k_config_chan(struct ath10k *ar)
 {
 	struct ath10k_vif *arvif;
-	bool monitor_was_enabled;
 	int ret;
 
 	lockdep_assert_held(&ar->conf_mutex);
@@ -2427,10 +2480,8 @@ static void ath10k_config_chan(struct ath10k *ar)
 
 	/* First stop monitor interface. Some FW versions crash if there's a
 	 * lone monitor interface. */
-	monitor_was_enabled = ar->monitor_enabled;
-
-	if (ar->monitor_enabled)
-		ath10k_monitor_stop(ar);
+	if (ar->monitor_started)
+		ath10k_monitor_vdev_stop(ar);
 
 	list_for_each_entry(arvif, &ar->arvifs, list) {
 		if (!arvif->is_started)
@@ -2475,8 +2526,8 @@ static void ath10k_config_chan(struct ath10k *ar)
 		}
 	}
 
-	if (monitor_was_enabled)
-		ath10k_monitor_start(ar, ar->monitor_vdev_id);
+	if (ath10k_monitor_is_enabled(ar))
+		ath10k_monitor_vdev_start(ar, ar->monitor_vdev_id);
 }
 
 static int ath10k_config(struct ieee80211_hw *hw, u32 changed)
@@ -2529,10 +2580,18 @@ static int ath10k_config(struct ieee80211_hw *hw, u32 changed)
 		ath10k_config_ps(ar);
 
 	if (changed & IEEE80211_CONF_CHANGE_MONITOR) {
-		if (conf->flags & IEEE80211_CONF_MONITOR)
-			ret = ath10k_monitor_create(ar);
-		else
-			ret = ath10k_monitor_destroy(ar);
+		if (conf->flags & IEEE80211_CONF_MONITOR && !ar->monitor) {
+			ar->monitor = true;
+			ret = ath10k_monitor_start(ar);
+			if (ret) {
+				ath10k_warn("failed to start monitor (config): %d\n", ret);
+				ar->monitor = false;
+			}
+		} else if (!(conf->flags & IEEE80211_CONF_MONITOR) &&
+			   ar->monitor) {
+			ar->monitor = false;
+			ath10k_monitor_stop(ar);
+		}
 	}
 
 	mutex_unlock(&ar->conf_mutex);
@@ -2567,12 +2626,6 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	INIT_WORK(&arvif->wep_key_work, ath10k_tx_wep_key_work);
 	INIT_LIST_HEAD(&arvif->list);
 
-	if ((vif->type == NL80211_IFTYPE_MONITOR) && ar->monitor_present) {
-		ath10k_warn("only one monitor interface allowed\n");
-		ret = -EBUSY;
-		goto err;
-	}
-
 	bit = ffs(ar->free_vdev_map);
 	if (bit == 0) {
 		ret = -EBUSY;
@@ -2704,9 +2757,6 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 		goto err_peer_delete;
 	}
 
-	if (arvif->vdev_type == WMI_VDEV_TYPE_MONITOR)
-		ar->monitor_present = true;
-
 	mutex_unlock(&ar->conf_mutex);
 	return 0;
 
@@ -2763,9 +2813,6 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 		ath10k_warn("failed to delete WMI vdev %i: %d\n",
 			    arvif->vdev_id, ret);
 
-	if (arvif->vdev_type == WMI_VDEV_TYPE_MONITOR)
-		ar->monitor_present = false;
-
 	ath10k_peer_cleanup(ar, arvif->vdev_id);
 
 	mutex_unlock(&ar->conf_mutex);
@@ -2798,28 +2845,16 @@ static void ath10k_configure_filter(struct ieee80211_hw *hw,
 	*total_flags &= SUPPORTED_FILTERS;
 	ar->filter_flags = *total_flags;
 
-	/* Monitor must not be started if it wasn't created first.
-	 * Promiscuous mode may be started on a non-monitor interface - in
-	 * such case the monitor vdev is not created so starting the
-	 * monitor makes no sense. Since ath10k uses no special RX filters
-	 * (only BSS filter in STA mode) there's no need for any special
-	 * action here. */
-	if ((ar->filter_flags & FIF_PROMISC_IN_BSS) &&
-	    !ar->monitor_enabled && ar->monitor_present) {
-		ath10k_dbg(ATH10K_DBG_MAC, "mac monitor %d start\n",
-			   ar->monitor_vdev_id);
-
-		ret = ath10k_monitor_start(ar, ar->monitor_vdev_id);
-		if (ret)
-			ath10k_warn("failed to start monitor mode: %d\n", ret);
-	} else if (!(ar->filter_flags & FIF_PROMISC_IN_BSS) &&
-		   ar->monitor_enabled && ar->monitor_present) {
-		ath10k_dbg(ATH10K_DBG_MAC, "mac monitor %d stop\n",
-			   ar->monitor_vdev_id);
-
-		ret = ath10k_monitor_stop(ar);
-		if (ret)
-			ath10k_warn("failed to stop monitor mode: %d\n", ret);
+	if (ar->filter_flags & FIF_PROMISC_IN_BSS && !ar->promisc) {
+		ar->promisc = true;
+		ret = ath10k_monitor_start(ar);
+		if (ret) {
+			ath10k_warn("failed to start monitor (promisc): %d\n", ret);
+			ar->promisc = false;
+		}
+	} else if (!(ar->filter_flags & FIF_PROMISC_IN_BSS) && ar->promisc) {
+		ar->promisc = false;
+		ath10k_monitor_stop(ar);
 	}
 
 	mutex_unlock(&ar->conf_mutex);
@@ -4579,7 +4614,6 @@ int ath10k_mac_register(struct ath10k *ar)
 			IEEE80211_HW_REPORTS_TX_ACK_STATUS |
 			IEEE80211_HW_HAS_RATE_CONTROL |
 			IEEE80211_HW_SUPPORTS_STATIC_SMPS |
-			IEEE80211_HW_WANT_MONITOR_VIF |
 			IEEE80211_HW_AP_LINK_PS |
 			IEEE80211_HW_SPECTRUM_MGMT;
 
-- 
1.8.5.3

