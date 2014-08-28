Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:45920 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936498AbaH1LIf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2014 07:08:35 -0400
Received: by mail-la0-f54.google.com with SMTP id b17so711675lan.13
        for <linux-wireless@vger.kernel.org>; Thu, 28 Aug 2014 04:08:33 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/2] ath10k: fix monitor start/stop sequences
Date: Thu, 28 Aug 2014 12:58:16 +0200
Message-Id: <1409223497-19946-2-git-send-email-michal.kazior@tieto.com> (sfid-20140828_130838_992586_4F4A87B7)
In-Reply-To: <1409223497-19946-1-git-send-email-michal.kazior@tieto.com>
References: <1409223497-19946-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix some cases where monitor start failure left
the driver in a confused state.

This also makes the monitor code simpler.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h |   1 -
 drivers/net/wireless/ath/ath10k/mac.c  | 121 +++++++++++++--------------------
 2 files changed, 49 insertions(+), 73 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 4ef4760..797741d 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -472,7 +472,6 @@ struct ath10k {
 	struct cfg80211_chan_def chandef;
 
 	int free_vdev_map;
-	bool promisc;
 	bool monitor;
 	int monitor_vdev_id;
 	bool monitor_started;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index b858c82..19562a7 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -493,19 +493,6 @@ static inline int ath10k_vdev_setup_sync(struct ath10k *ar)
 	return 0;
 }
 
-static bool ath10k_monitor_is_enabled(struct ath10k *ar)
-{
-	lockdep_assert_held(&ar->conf_mutex);
-
-	ath10k_dbg(ar, ATH10K_DBG_MAC,
-		   "mac monitor refs: promisc %d monitor %d cac %d\n",
-		   ar->promisc, ar->monitor,
-		   test_bit(ATH10K_CAC_RUNNING, &ar->dev_flags));
-
-	return ar->promisc || ar->monitor ||
-	       test_bit(ATH10K_CAC_RUNNING, &ar->dev_flags);
-}
-
 static int ath10k_monitor_vdev_start(struct ath10k *ar, int vdev_id)
 {
 	struct cfg80211_chan_def *chandef = &ar->chandef;
@@ -649,16 +636,6 @@ static int ath10k_monitor_start(struct ath10k *ar)
 
 	lockdep_assert_held(&ar->conf_mutex);
 
-	if (!ath10k_monitor_is_enabled(ar)) {
-		ath10k_warn(ar, "trying to start monitor with no references\n");
-		return 0;
-	}
-
-	if (ar->monitor_started) {
-		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac monitor already started\n");
-		return 0;
-	}
-
 	ret = ath10k_monitor_vdev_create(ar);
 	if (ret) {
 		ath10k_warn(ar, "failed to create monitor vdev: %d\n", ret);
@@ -678,34 +655,51 @@ static int ath10k_monitor_start(struct ath10k *ar)
 	return 0;
 }
 
-static void ath10k_monitor_stop(struct ath10k *ar)
+static int ath10k_monitor_stop(struct ath10k *ar)
 {
 	int ret;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
-	if (ath10k_monitor_is_enabled(ar)) {
-		ath10k_dbg(ar, ATH10K_DBG_MAC,
-			   "mac monitor will be stopped later\n");
-		return;
-	}
-
-	if (!ar->monitor_started) {
-		ath10k_dbg(ar, ATH10K_DBG_MAC,
-			   "mac monitor probably failed to start earlier\n");
-		return;
-	}
-
 	ret = ath10k_monitor_vdev_stop(ar);
-	if (ret)
+	if (ret) {
 		ath10k_warn(ar, "failed to stop monitor vdev: %d\n", ret);
+		return ret;
+	}
 
 	ret = ath10k_monitor_vdev_delete(ar);
-	if (ret)
+	if (ret) {
 		ath10k_warn(ar, "failed to delete monitor vdev: %d\n", ret);
+		return ret;
+	}
 
 	ar->monitor_started = false;
 	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac monitor stopped\n");
+
+	return 0;
+}
+
+static int ath10k_monitor_recalc(struct ath10k *ar)
+{
+	bool should_start;
+
+	lockdep_assert_held(&ar->conf_mutex);
+
+	should_start = ar->monitor ||
+		       ar->filter_flags & FIF_PROMISC_IN_BSS ||
+		       test_bit(ATH10K_CAC_RUNNING, &ar->dev_flags);
+
+	ath10k_dbg(ar, ATH10K_DBG_MAC,
+		   "mac monitor recalc started? %d should? %d\n",
+		   ar->monitor_started, should_start);
+
+	if (should_start == ar->monitor_started)
+		return 0;
+
+	if (should_start)
+		return ath10k_monitor_start(ar);
+	else
+		return ath10k_monitor_stop(ar);
 }
 
 static int ath10k_recalc_rtscts_prot(struct ath10k_vif *arvif)
@@ -736,7 +730,7 @@ static int ath10k_start_cac(struct ath10k *ar)
 
 	set_bit(ATH10K_CAC_RUNNING, &ar->dev_flags);
 
-	ret = ath10k_monitor_start(ar);
+	ret = ath10k_monitor_recalc(ar);
 	if (ret) {
 		ath10k_warn(ar, "failed to start monitor (cac): %d\n", ret);
 		clear_bit(ATH10K_CAC_RUNNING, &ar->dev_flags);
@@ -2369,12 +2363,14 @@ void ath10k_halt(struct ath10k *ar)
 
 	lockdep_assert_held(&ar->conf_mutex);
 
-	if (ath10k_monitor_is_enabled(ar)) {
-		clear_bit(ATH10K_CAC_RUNNING, &ar->dev_flags);
-		ar->promisc = false;
-		ar->monitor = false;
+	clear_bit(ATH10K_CAC_RUNNING, &ar->dev_flags);
+	ar->filter_flags = 0;
+	ar->monitor = false;
+
+	if (ar->monitor_started)
 		ath10k_monitor_stop(ar);
-	}
+
+	ar->monitor_started = false;
 
 	ath10k_scan_finish(ar);
 	ath10k_peer_cleanup_all(ar);
@@ -2629,7 +2625,7 @@ static void ath10k_config_chan(struct ath10k *ar)
 	/* First stop monitor interface. Some FW versions crash if there's a
 	 * lone monitor interface. */
 	if (ar->monitor_started)
-		ath10k_monitor_vdev_stop(ar);
+		ath10k_monitor_stop(ar);
 
 	list_for_each_entry(arvif, &ar->arvifs, list) {
 		if (!arvif->is_started)
@@ -2677,8 +2673,7 @@ static void ath10k_config_chan(struct ath10k *ar)
 		}
 	}
 
-	if (ath10k_monitor_is_enabled(ar))
-		ath10k_monitor_vdev_start(ar, ar->monitor_vdev_id);
+	ath10k_monitor_recalc(ar);
 }
 
 static int ath10k_config(struct ieee80211_hw *hw, u32 changed)
@@ -2733,19 +2728,10 @@ static int ath10k_config(struct ieee80211_hw *hw, u32 changed)
 		ath10k_config_ps(ar);
 
 	if (changed & IEEE80211_CONF_CHANGE_MONITOR) {
-		if (conf->flags & IEEE80211_CONF_MONITOR && !ar->monitor) {
-			ar->monitor = true;
-			ret = ath10k_monitor_start(ar);
-			if (ret) {
-				ath10k_warn(ar, "failed to start monitor (config): %d\n",
-					    ret);
-				ar->monitor = false;
-			}
-		} else if (!(conf->flags & IEEE80211_CONF_MONITOR) &&
-			   ar->monitor) {
-			ar->monitor = false;
-			ath10k_monitor_stop(ar);
-		}
+		ar->monitor = conf->flags & IEEE80211_CONF_MONITOR;
+		ret = ath10k_monitor_recalc(ar);
+		if (ret)
+			ath10k_warn(ar, "failed to recalc monitor: %d\n", ret);
 	}
 
 	mutex_unlock(&ar->conf_mutex);
@@ -3009,18 +2995,9 @@ static void ath10k_configure_filter(struct ieee80211_hw *hw,
 	*total_flags &= SUPPORTED_FILTERS;
 	ar->filter_flags = *total_flags;
 
-	if (ar->filter_flags & FIF_PROMISC_IN_BSS && !ar->promisc) {
-		ar->promisc = true;
-		ret = ath10k_monitor_start(ar);
-		if (ret) {
-			ath10k_warn(ar, "failed to start monitor (promisc): %d\n",
-				    ret);
-			ar->promisc = false;
-		}
-	} else if (!(ar->filter_flags & FIF_PROMISC_IN_BSS) && ar->promisc) {
-		ar->promisc = false;
-		ath10k_monitor_stop(ar);
-	}
+	ret = ath10k_monitor_recalc(ar);
+	if (ret)
+		ath10k_warn(ar, "failed to recalc montior: %d\n", ret);
 
 	mutex_unlock(&ar->conf_mutex);
 }
-- 
1.8.5.3

