Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:51858 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaDAHb0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2014 03:31:26 -0400
Received: by mail-wg0-f42.google.com with SMTP id y10so6830999wgg.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Apr 2014 00:31:24 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: fix initial radar detection logic
Date: Tue,  1 Apr 2014 09:25:23 +0200
Message-Id: <1396337123-12622-1-git-send-email-michal.kazior@tieto.com> (sfid-20140401_093130_998921_D0C4F918)
In-Reply-To: <1396015934-7723-1-git-send-email-michal.kazior@tieto.com>
References: <1396015934-7723-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a problem of initial radar detection
(CAC) being stuck and blocking Rx in some cases
until all interfaces were brought down.

For userspace this meant first run of hostapd
would perform CAC but due to filtered Rx no
clients would associate. Subsequent runs of
hostapd would not perform CAC (as it was already
done) and would associate clients.

This also makes sure radar detection is performed
when bandwidth is widened. Before if 20MHz CAC was
performed then 40MHz CAC wouldn't start monitor
vdev effectively disabling initial radar
detection.

A driver should just start/stop radar detection
based on hw->conf.radar_enabled. However, since
ath10k needs to start a monitor vdev for the
initial radar detection special care needs to be
applied.

While at it cleanup the code a bit.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h |  2 ++
 drivers/net/wireless/ath/ath10k/mac.c  | 56 ++++++++++++----------------------
 2 files changed, 21 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 8edd6da..ca2abe2 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -434,6 +434,8 @@ struct ath10k {
 	unsigned int filter_flags;
 	unsigned long dev_flags;
 	u32 dfs_block_radar_events;
+	bool radar_enabled; /* protected by conf_mutex */
+	int num_started_vdevs; /* protected by conf_mutex */
 
 	struct wmi_pdev_set_wmm_params_arg wmm_params;
 	struct completion install_key_done;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 58ec5a7..024fce4 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -489,6 +489,8 @@ static inline int ath10k_vdev_setup_sync(struct ath10k *ar)
 	return 0;
 }
 
+static void ath10k_recalc_radar_detection(struct ath10k *ar);
+
 static int ath10k_vdev_start(struct ath10k_vif *arvif)
 {
 	struct ath10k *ar = arvif->ar;
@@ -545,6 +547,9 @@ static int ath10k_vdev_start(struct ath10k_vif *arvif)
 		return ret;
 	}
 
+	ar->num_started_vdevs++;
+	ath10k_recalc_radar_detection(ar);
+
 	return ret;
 }
 
@@ -571,6 +576,11 @@ static int ath10k_vdev_stop(struct ath10k_vif *arvif)
 		return ret;
 	}
 
+	if (WARN_ON(ar->num_started_vdevs == 0)) {
+		ar->num_started_vdevs--;
+		ath10k_recalc_radar_detection(ar);
+	}
+
 	return ret;
 }
 
@@ -804,49 +814,18 @@ static int ath10k_stop_cac(struct ath10k *ar)
 	return 0;
 }
 
-static const char *ath10k_dfs_state(enum nl80211_dfs_state dfs_state)
-{
-	switch (dfs_state) {
-	case NL80211_DFS_USABLE:
-		return "USABLE";
-	case NL80211_DFS_UNAVAILABLE:
-		return "UNAVAILABLE";
-	case NL80211_DFS_AVAILABLE:
-		return "AVAILABLE";
-	default:
-		WARN_ON(1);
-		return "bug";
-	}
-}
-
-static void ath10k_config_radar_detection(struct ath10k *ar)
+static void ath10k_recalc_radar_detection(struct ath10k *ar)
 {
-	struct ieee80211_channel *chan = ar->hw->conf.chandef.chan;
-	bool radar = ar->hw->conf.radar_enabled;
-	bool chan_radar = !!(chan->flags & IEEE80211_CHAN_RADAR);
-	enum nl80211_dfs_state dfs_state = chan->dfs_state;
 	int ret;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
-	ath10k_dbg(ATH10K_DBG_MAC,
-		   "mac radar config update: chan %dMHz radar %d chan radar %d chan state %s\n",
-		   chan->center_freq, radar, chan_radar,
-		   ath10k_dfs_state(dfs_state));
-
-	/*
-	 * It's safe to call it even if CAC is not started.
-	 * This call here guarantees changing channel, etc. will stop CAC.
-	 */
 	ath10k_stop_cac(ar);
 
-	if (!radar)
-		return;
-
-	if (!chan_radar)
+	if (!ar->radar_enabled)
 		return;
 
-	if (dfs_state != NL80211_DFS_USABLE)
+	if (ar->num_started_vdevs > 0)
 		return;
 
 	ret = ath10k_start_cac(ar);
@@ -2341,6 +2320,7 @@ static int ath10k_start(struct ieee80211_hw *hw)
 		goto exit;
 	}
 
+	ar->num_started_vdevs = 0;
 	ath10k_regd_update(ar);
 	ret = 0;
 
@@ -2490,15 +2470,17 @@ static int ath10k_config(struct ieee80211_hw *hw, u32 changed)
 
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
 		ath10k_dbg(ATH10K_DBG_MAC,
-			   "mac config channel %d mhz flags 0x%x\n",
+			   "mac config channel %dMHz flags 0x%x radar %d\n",
 			   conf->chandef.chan->center_freq,
-			   conf->chandef.chan->flags);
+			   conf->chandef.chan->flags,
+			   conf->radar_enabled);
 
 		spin_lock_bh(&ar->data_lock);
 		ar->rx_channel = conf->chandef.chan;
 		spin_unlock_bh(&ar->data_lock);
 
-		ath10k_config_radar_detection(ar);
+		ar->radar_enabled = conf->radar_enabled;
+		ath10k_recalc_radar_detection(ar);
 
 		if (!cfg80211_chandef_identical(&ar->chandef, &conf->chandef)) {
 			ar->chandef = conf->chandef;
-- 
1.8.5.3

