Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:47575 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932622AbaGPNaJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2014 09:30:09 -0400
Received: by mail-we0-f175.google.com with SMTP id t60so939859wes.34
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2014 06:30:07 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, svens@stackframe.org,
	vh.nguyen@actiasodielec.fr, Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC/RFT 1/2] ath10k: fix monitor start/stop sequences
Date: Wed, 16 Jul 2014 15:21:12 +0200
Message-Id: <1405516873-26411-1-git-send-email-michal.kazior@tieto.com> (sfid-20140716_153018_837169_E04F5B92)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix some cases where monitor start failure left
the driver in a confused state.

This also makes the monitor code simpler.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 117 +++++++++++++---------------------
 1 file changed, 45 insertions(+), 72 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index b8314a5..2a1c710 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -492,19 +492,6 @@ static inline int ath10k_vdev_setup_sync(struct ath10k *ar)
 	return 0;
 }
 
-static bool ath10k_monitor_is_enabled(struct ath10k *ar)
-{
-	lockdep_assert_held(&ar->conf_mutex);
-
-	ath10k_dbg(ATH10K_DBG_MAC,
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
@@ -654,16 +641,6 @@ static int ath10k_monitor_start(struct ath10k *ar)
 
 	lockdep_assert_held(&ar->conf_mutex);
 
-	if (!ath10k_monitor_is_enabled(ar)) {
-		ath10k_warn("trying to start monitor with no references\n");
-		return 0;
-	}
-
-	if (ar->monitor_started) {
-		ath10k_dbg(ATH10K_DBG_MAC, "mac monitor already started\n");
-		return 0;
-	}
-
 	ret = ath10k_monitor_vdev_create(ar);
 	if (ret) {
 		ath10k_warn("failed to create monitor vdev: %d\n", ret);
@@ -683,34 +660,48 @@ static int ath10k_monitor_start(struct ath10k *ar)
 	return 0;
 }
 
-static void ath10k_monitor_stop(struct ath10k *ar)
+static int ath10k_monitor_stop(struct ath10k *ar)
 {
 	int ret;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
-	if (ath10k_monitor_is_enabled(ar)) {
-		ath10k_dbg(ATH10K_DBG_MAC,
-			   "mac monitor will be stopped later\n");
-		return;
-	}
-
-	if (!ar->monitor_started) {
-		ath10k_dbg(ATH10K_DBG_MAC,
-			   "mac monitor probably failed to start earlier\n");
-		return;
-	}
-
 	ret = ath10k_monitor_vdev_stop(ar);
-	if (ret)
+	if (ret) {
 		ath10k_warn("failed to stop monitor vdev: %d\n", ret);
+		return ret;
+	}
 
 	ret = ath10k_monitor_vdev_delete(ar);
-	if (ret)
+	if (ret) {
 		ath10k_warn("failed to delete monitor vdev: %d\n", ret);
+		return ret;
+	}
 
 	ar->monitor_started = false;
 	ath10k_dbg(ATH10K_DBG_MAC, "mac monitor stopped\n");
+
+	return 0;
+}
+
+static int ath10k_monitor_recalc(struct ath10k *ar)
+{
+	bool should_start;
+
+	should_start = ar->promisc || ar->monitor ||
+		       test_bit(ATH10K_CAC_RUNNING, &ar->dev_flags);
+
+	ath10k_dbg(ATH10K_DBG_MAC,
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
@@ -741,7 +732,7 @@ static int ath10k_start_cac(struct ath10k *ar)
 
 	set_bit(ATH10K_CAC_RUNNING, &ar->dev_flags);
 
-	ret = ath10k_monitor_start(ar);
+	ret = ath10k_monitor_recalc(ar);
 	if (ret) {
 		ath10k_warn("failed to start monitor (cac): %d\n", ret);
 		clear_bit(ATH10K_CAC_RUNNING, &ar->dev_flags);
@@ -2316,12 +2307,12 @@ void ath10k_halt(struct ath10k *ar)
 
 	lockdep_assert_held(&ar->conf_mutex);
 
-	if (ath10k_monitor_is_enabled(ar)) {
-		clear_bit(ATH10K_CAC_RUNNING, &ar->dev_flags);
-		ar->promisc = false;
-		ar->monitor = false;
+	clear_bit(ATH10K_CAC_RUNNING, &ar->dev_flags);
+	ar->promisc = false;
+	ar->monitor = false;
+
+	if (ar->monitor_started)
 		ath10k_monitor_stop(ar);
-	}
 
 	del_timer_sync(&ar->scan.timeout);
 	ath10k_reset_scan((unsigned long)ar);
@@ -2574,7 +2565,7 @@ static void ath10k_config_chan(struct ath10k *ar)
 	/* First stop monitor interface. Some FW versions crash if there's a
 	 * lone monitor interface. */
 	if (ar->monitor_started)
-		ath10k_monitor_vdev_stop(ar);
+		ath10k_monitor_stop(ar);
 
 	list_for_each_entry(arvif, &ar->arvifs, list) {
 		if (!arvif->is_started)
@@ -2619,8 +2610,7 @@ static void ath10k_config_chan(struct ath10k *ar)
 		}
 	}
 
-	if (ath10k_monitor_is_enabled(ar))
-		ath10k_monitor_vdev_start(ar, ar->monitor_vdev_id);
+	ath10k_monitor_recalc(ar);
 }
 
 static int ath10k_config(struct ieee80211_hw *hw, u32 changed)
@@ -2675,19 +2665,10 @@ static int ath10k_config(struct ieee80211_hw *hw, u32 changed)
 		ath10k_config_ps(ar);
 
 	if (changed & IEEE80211_CONF_CHANGE_MONITOR) {
-		if (conf->flags & IEEE80211_CONF_MONITOR && !ar->monitor) {
-			ar->monitor = true;
-			ret = ath10k_monitor_start(ar);
-			if (ret) {
-				ath10k_warn("failed to start monitor (config): %d\n",
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
+			ath10k_warn("failed to recalc monitor: %d\n", ret);
 	}
 
 	mutex_unlock(&ar->conf_mutex);
@@ -2944,18 +2925,10 @@ static void ath10k_configure_filter(struct ieee80211_hw *hw,
 	*total_flags &= SUPPORTED_FILTERS;
 	ar->filter_flags = *total_flags;
 
-	if (ar->filter_flags & FIF_PROMISC_IN_BSS && !ar->promisc) {
-		ar->promisc = true;
-		ret = ath10k_monitor_start(ar);
-		if (ret) {
-			ath10k_warn("failed to start monitor (promisc): %d\n",
-				    ret);
-			ar->promisc = false;
-		}
-	} else if (!(ar->filter_flags & FIF_PROMISC_IN_BSS) && ar->promisc) {
-		ar->promisc = false;
-		ath10k_monitor_stop(ar);
-	}
+	ar->promisc = !!(ar->filter_flags & FIF_PROMISC_IN_BSS);
+	ret = ath10k_monitor_recalc(ar);
+	if (ret)
+		ath10k_warn("failed to recalc montior: %d\n", ret);
 
 	mutex_unlock(&ar->conf_mutex);
 }
-- 
1.8.5.3

