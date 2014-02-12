Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:33467 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbaBLSyl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 13:54:41 -0500
Received: by mail-ee0-f41.google.com with SMTP id e51so3970759eek.0
        for <linux-wireless@vger.kernel.org>; Wed, 12 Feb 2014 10:54:40 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mcgrof@do-not-panic.com,
	linville@tuxdriver.com, Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 4/4] cfg80211: DFS get CAC time from regulatory
Date: Wed, 12 Feb 2014 19:54:23 +0100
Message-Id: <1392231266-28479-4-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140212_195455_447285_1944C02B)
In-Reply-To: <1392231266-28479-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1392231266-28479-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Get CAC time from regulatory database.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 include/net/cfg80211.h |    2 ++
 net/wireless/chan.c    |   59 ++++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/core.h    |    3 +++
 net/wireless/mlme.c    |    2 +-
 net/wireless/nl80211.c |    8 ++++++-
 5 files changed, 72 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 14e2671..03951c2 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3173,6 +3173,7 @@ struct cfg80211_cached_keys;
  * @p2p_started: true if this is a P2P Device that has been started
  * @cac_started: true if DFS channel availability check has been started
  * @cac_start_time: timestamp (jiffies) when the dfs state was entered.
+ * @cac_time_ms: CAC time in ms
  * @ps: powersave mode is enabled
  * @ps_timeout: dynamic powersave timeout
  * @ap_unexpected_nlportid: (private) netlink port ID of application
@@ -3228,6 +3229,7 @@ struct wireless_dev {
 
 	bool cac_started;
 	unsigned long cac_start_time;
+	unsigned int cac_time_ms;
 
 #ifdef CONFIG_CFG80211_WEXT
 	/* wext data */
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 5946450..78ba96d 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -490,6 +490,65 @@ static bool cfg80211_chandef_dfs_available(struct wiphy *wiphy,
 	return r;
 }
 
+static unsigned int cfg80211_get_chans_dfs_cac_time(struct wiphy *wiphy,
+						    u32 center_freq,
+						    u32 bandwidth)
+{
+	struct ieee80211_channel *c;
+	u32 start_freq, end_freq, freq;
+	unsigned int dfs_cac_ms = 0;
+
+	start_freq = cfg80211_get_start_freq(center_freq, bandwidth);
+	end_freq = cfg80211_get_end_freq(center_freq, bandwidth);
+
+	for (freq = start_freq; freq <= end_freq; freq += 20) {
+		c = ieee80211_get_channel(wiphy, freq);
+		if (!c)
+			return 0;
+
+		if (c->flags & IEEE80211_CHAN_DISABLED)
+			return 0;
+
+		if (!(c->flags & IEEE80211_CHAN_RADAR))
+			continue;
+
+		if (c->dfs_cac_ms > dfs_cac_ms)
+			dfs_cac_ms = c->dfs_cac_ms;
+	}
+
+	return dfs_cac_ms;
+}
+
+unsigned int
+cfg80211_chandef_dfs_cac_time(struct wiphy *wiphy,
+			      const struct cfg80211_chan_def *chandef)
+{
+	int width;
+	unsigned int t1 = 0, t2 = 0;
+
+	if (WARN_ON(!cfg80211_chandef_valid(chandef)))
+		return 0;
+
+	width = cfg80211_chandef_get_width(chandef);
+	if (width < 0)
+		return 0;
+
+	t1 = cfg80211_get_chans_dfs_cac_time(wiphy,
+					     chandef->center_freq1,
+					     width);
+
+	if (!chandef->center_freq2)
+		return t1;
+
+	t2 = cfg80211_get_chans_dfs_cac_time(wiphy,
+					     chandef->center_freq2,
+					     width);
+
+	if (t2 > t1)
+		t1 = t2;
+
+	return t1;
+}
 
 static bool cfg80211_secondary_chans_ok(struct wiphy *wiphy,
 					u32 center_freq, u32 bandwidth,
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 9895ab1..78be8cd 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -400,6 +400,9 @@ void cfg80211_set_dfs_state(struct wiphy *wiphy,
 
 void cfg80211_dfs_channels_update_work(struct work_struct *work);
 
+unsigned int
+cfg80211_chandef_dfs_cac_time(struct wiphy *wiphy,
+			      const struct cfg80211_chan_def *chandef);
 
 static inline int
 cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index d47c9d1..c52ff59 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -778,7 +778,7 @@ void cfg80211_cac_event(struct net_device *netdev,
 	switch (event) {
 	case NL80211_RADAR_CAC_FINISHED:
 		timeout = wdev->cac_start_time +
-			  msecs_to_jiffies(IEEE80211_DFS_MIN_CAC_TIME_MS);
+			  msecs_to_jiffies(wdev->cac_time_ms);
 		WARN_ON(!time_after_eq(jiffies, timeout));
 		cfg80211_set_dfs_state(wiphy, chandef, NL80211_DFS_AVAILABLE);
 		break;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4a4c988..6d28cc2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5776,6 +5776,7 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_chan_def chandef;
 	enum nl80211_dfs_regions dfs_region;
+	unsigned int cac_time_ms;
 	int err;
 
 	dfs_region = reg_get_dfs_region(wdev->wiphy);
@@ -5811,12 +5812,17 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	if (err)
 		return err;
 
+	cac_time_ms = cfg80211_chandef_dfs_cac_time(&rdev->wiphy, &chandef);
+	if (WARN_ON(!cac_time_ms))
+		cac_time_ms = IEEE80211_DFS_MIN_CAC_TIME_MS;
+
 	err = rdev->ops->start_radar_detection(&rdev->wiphy, dev, &chandef,
-					       IEEE80211_DFS_MIN_CAC_TIME_MS);
+					       cac_time_ms);
 	if (!err) {
 		wdev->chandef = chandef;
 		wdev->cac_started = true;
 		wdev->cac_start_time = jiffies;
+		wdev->cac_time_ms = cac_time_ms;
 	}
 	return err;
 }
-- 
1.7.9.5

