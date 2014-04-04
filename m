Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:44579 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbaDDLfB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2014 07:35:01 -0400
Received: by mail-we0-f176.google.com with SMTP id x48so3180398wes.7
        for <linux-wireless@vger.kernel.org>; Fri, 04 Apr 2014 04:34:59 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 2/2] ath10k: refactor radar detection code
Date: Fri,  4 Apr 2014 13:28:46 +0200
Message-Id: <1396610926-5787-3-git-send-email-michal.kazior@tieto.com> (sfid-20140404_134046_234067_2B5C8256)
In-Reply-To: <1396610926-5787-1-git-send-email-michal.kazior@tieto.com>
References: <1396337123-12622-1-git-send-email-michal.kazior@tieto.com>
 <1396610926-5787-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If 20MHz CAC completed successfully then
subsequent CAC with wider bandwidth (40Mhz, 80Mhz)
with identical control frequency did not start
monitor vdev making it impossible to detect any
radar pulses during intended CAC.

It also was incorrect to assume ath10k_config() will
be called after CAC is finished. Theoretically for
non-HT channels nothing changes between CAC and
start_ap() (albeit in practice this can be
different). The incorrect assumption led to CAC
not being stopped on non-HT chandefs leading to
all Rx being drooped making it impossible for
clients to associate.

While at it clean up the code a bit.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
v2:
 * change locking comment style [Kalle]
 * get rid of forward declaration [Kalle]
 * fix vdev_stop / WARN_ON (missing !) [Kalle]
 * change commit message
   (the original issue found was CAC not being
    stopped for non-HT channels but this was a
    side-effect of a mac80211 bug, although the
    use of hw->conf.radar_enabled in ath10k was
    also incorrect either way)

 drivers/net/wireless/ath/ath10k/core.h |  4 +++
 drivers/net/wireless/ath/ath10k/mac.c  | 54 +++++++++++-----------------------
 2 files changed, 21 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 8edd6da..5cb9903 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -435,6 +435,10 @@ struct ath10k {
 	unsigned long dev_flags;
 	u32 dfs_block_radar_events;
 
+	/* protected by conf_mutex */
+	bool radar_enabled;
+	int num_started_vdevs;
+
 	struct wmi_pdev_set_wmm_params_arg wmm_params;
 	struct completion install_key_done;
 
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index e1f4227..3333b1f 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -719,49 +719,18 @@ static int ath10k_stop_cac(struct ath10k *ar)
 	return 0;
 }
 
-static const char *ath10k_dfs_state(enum nl80211_dfs_state dfs_state)
+static void ath10k_recalc_radar_detection(struct ath10k *ar)
 {
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
-{
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
@@ -832,6 +801,9 @@ static int ath10k_vdev_start(struct ath10k_vif *arvif)
 		return ret;
 	}
 
+	ar->num_started_vdevs++;
+	ath10k_recalc_radar_detection(ar);
+
 	return ret;
 }
 
@@ -858,6 +830,11 @@ static int ath10k_vdev_stop(struct ath10k_vif *arvif)
 		return ret;
 	}
 
+	if (!WARN_ON(ar->num_started_vdevs == 0)) {
+		ar->num_started_vdevs--;
+		ath10k_recalc_radar_detection(ar);
+	}
+
 	return ret;
 }
 
@@ -2341,6 +2318,7 @@ static int ath10k_start(struct ieee80211_hw *hw)
 		goto exit;
 	}
 
+	ar->num_started_vdevs = 0;
 	ath10k_regd_update(ar);
 	ret = 0;
 
@@ -2490,15 +2468,17 @@ static int ath10k_config(struct ieee80211_hw *hw, u32 changed)
 
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

