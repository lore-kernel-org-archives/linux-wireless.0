Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:41502 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaAOMRF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 07:17:05 -0500
Received: by mail-ee0-f41.google.com with SMTP id e49so835620eek.0
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jan 2014 04:17:03 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mcgrof@do-not-panic.com,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFC 2/2] cfg80211: DFS get CAC time from regulatory
Date: Wed, 15 Jan 2014 13:16:50 +0100
Message-Id: <1389788210-7246-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140115_131710_263614_6DF7634F)
In-Reply-To: <1389788210-7246-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1389788210-7246-1-git-send-email-janusz.dziedzic@tieto.com>
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
index 71ca782..8fff253ed 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3154,6 +3154,7 @@ struct cfg80211_cached_keys;
  * @p2p_started: true if this is a P2P Device that has been started
  * @cac_started: true if DFS channel availability check has been started
  * @cac_start_time: timestamp (jiffies) when the dfs state was entered.
+ * @cac_time_ms: CAC time in ms
  * @ps: powersave mode is enabled
  * @ps_timeout: dynamic powersave timeout
  * @ap_unexpected_nlportid: (private) netlink port ID of application
@@ -3211,6 +3212,7 @@ struct wireless_dev {
 
 	bool cac_started;
 	unsigned long cac_start_time;
+	unsigned int cac_time_ms;
 
 #ifdef CONFIG_CFG80211_WEXT
 	/* wext data */
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 78559b5..ac35bf3 100644
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
+		if (c->flag & IEEE80211_CHAN_DISABLED)
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
index 37ec16d..aa77277 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -398,6 +398,9 @@ void cfg80211_set_dfs_state(struct wiphy *wiphy,
 
 void cfg80211_dfs_channels_update_work(struct work_struct *work);
 
+unsigned int
+cfg80211_chandef_dfs_cac_time(struct wiphy *wiphy,
+			      const struct cfg80211_chan_def *chandef);
 
 static inline int
 cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 52cca05..6601e81 100644
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
index 8bb2064..112f240 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5729,6 +5729,7 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_chan_def chandef;
 	enum nl80211_dfs_regions dfs_region;
+	unsigned int cac_time_ms;
 	int err;
 
 	dfs_region = reg_get_dfs_region(wdev->wiphy);
@@ -5764,12 +5765,17 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
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
 		wdev->channel = chandef.chan;
 		wdev->cac_started = true;
 		wdev->cac_start_time = jiffies;
+		wdev->cac_time_ms = cac_time_ms;
 	}
 	return err;
 }
-- 
1.7.9.5

