Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:52647 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756815Ab3KYT40 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 14:56:26 -0500
Received: by mail-ea0-f182.google.com with SMTP id o10so3867888eaj.13
        for <linux-wireless@vger.kernel.org>; Mon, 25 Nov 2013 11:56:24 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v3 4/4] cfg80211: DFS use 10 minutes CAC when weather channels
Date: Mon, 25 Nov 2013 20:56:12 +0100
Message-Id: <1385409372-4229-4-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131125_205631_961886_6AB8C498)
In-Reply-To: <1385409372-4229-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1385409372-4229-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When nominal bandwidth falls completely or partly
within the band 5600MHz to 5650MHz the CAC time shall
be 10 minutes.
This is ETSI requirement. FCC forbids weather channels usage.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 include/net/cfg80211.h |    7 ++++-
 net/wireless/chan.c    |   74 ++++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/core.h    |    4 +++
 net/wireless/mlme.c    |    2 +-
 net/wireless/nl80211.c |    7 ++++-
 5 files changed, 91 insertions(+), 3 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ce6bf12..027c907 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -125,9 +125,12 @@ enum ieee80211_channel_flags {
 #define IEEE80211_CHAN_NO_HT40 \
 	(IEEE80211_CHAN_NO_HT40PLUS | IEEE80211_CHAN_NO_HT40MINUS)
 
-#define IEEE80211_DFS_MIN_CAC_TIME_MS		60000
+#define IEEE80211_DFS_MIN_CAC_TIME_MS		(60 * 1000)
 #define IEEE80211_DFS_MIN_NOP_TIME_MS		(30 * 60 * 1000)
 
+/* ETSI EN 301 893 V1.7.0 - Table D.1 */
+#define IEEE80211_DFS_WEATHER_MIN_CAC_TIME_MS	(10 * 60 * 1000)
+
 /**
  * struct ieee80211_channel - channel definition
  *
@@ -3061,6 +3064,7 @@ struct cfg80211_cached_keys;
  * @p2p_started: true if this is a P2P Device that has been started
  * @cac_started: true if DFS channel availability check has been started
  * @cac_start_time: timestamp (jiffies) when the dfs state was entered.
+ * @cac_time_ms: CAC time in ms
  * @ps: powersave mode is enabled
  * @ps_timeout: dynamic powersave timeout
  * @ap_unexpected_nlportid: (private) netlink port ID of application
@@ -3118,6 +3122,7 @@ struct wireless_dev {
 
 	bool cac_started;
 	unsigned long cac_start_time;
+	unsigned int cac_time_ms;
 
 #ifdef CONFIG_CFG80211_WEXT
 	/* wext data */
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 78559b5..680f469 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -490,6 +490,80 @@ static bool cfg80211_chandef_dfs_available(struct wiphy *wiphy,
 	return r;
 }
 
+static int cfg80211_get_chans_dfs_is_weather(struct wiphy *wiphy,
+					     u32 center_freq,
+					     u32 bandwidth)
+{
+	struct ieee80211_channel *c;
+	u32 start_freq, end_freq, freq;
+
+	start_freq = cfg80211_get_start_freq(center_freq, bandwidth);
+	end_freq = cfg80211_get_end_freq(center_freq, bandwidth);
+
+	/*
+	 * ETSI EN 301 893 V1.7.0 Table D.1
+	 * 5600 - 5650MHz - weather radar channels
+	 */
+	for (freq = start_freq; freq <= end_freq; freq += 20) {
+		c = ieee80211_get_channel(wiphy, freq);
+		if (!c)
+			return -EINVAL;
+		if (c->center_freq >= 5600 && c->center_freq <= 5650)
+			return 1;
+	}
+	return 0;
+}
+
+static int
+cfg80211_chandef_dfs_is_weather(struct wiphy *wiphy,
+				const struct cfg80211_chan_def *chandef)
+{
+	int width;
+	int r;
+
+	if (WARN_ON(!cfg80211_chandef_valid(chandef)))
+		return -EINVAL;
+
+	width = cfg80211_chandef_get_width(chandef);
+	if (width < 0)
+		return -EINVAL;
+
+	r = cfg80211_get_chans_dfs_is_weather(wiphy, chandef->center_freq1,
+					      width);
+
+	if (r)
+		return r;
+
+	if (!chandef->center_freq2)
+		return 0;
+
+	return cfg80211_get_chans_dfs_is_weather(wiphy, chandef->center_freq2,
+						 width);
+}
+
+unsigned int
+cfg80211_chandef_dfs_cac_time(struct wiphy *wiphy,
+			      const struct cfg80211_chan_def *chandef,
+			      enum nl80211_dfs_regions dfs_region)
+{
+	unsigned int timeout_ms = IEEE80211_DFS_MIN_CAC_TIME_MS;
+
+	switch (dfs_region) {
+	case NL80211_DFS_ETSI:
+		if (cfg80211_chandef_dfs_is_weather(wiphy, chandef) > 0)
+			timeout_ms = IEEE80211_DFS_WEATHER_MIN_CAC_TIME_MS;
+		break;
+	/* TODO check JP CAC time */
+	case NL80211_DFS_JP:
+		break;
+	/* FCC don't allow weather channels */
+	case NL80211_DFS_FCC:
+	default:
+		break;
+	}
+
+	return timeout_ms;
+}
 
 static bool cfg80211_secondary_chans_ok(struct wiphy *wiphy,
 					u32 center_freq, u32 bandwidth,
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 0a277c3..88d9d0f 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -400,6 +400,10 @@ void cfg80211_set_dfs_state(struct wiphy *wiphy,
 
 void cfg80211_dfs_channels_update_work(struct work_struct *work);
 
+unsigned int
+cfg80211_chandef_dfs_cac_time(struct wiphy *wiphy,
+			      const struct cfg80211_chan_def *chandef,
+			      enum nl80211_dfs_regions dfs_region);
 
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
index b705640..94fea18 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5651,6 +5651,7 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_chan_def chandef;
 	enum nl80211_dfs_regions dfs_region;
+	unsigned int cac_time_ms;
 	int err;
 
 	dfs_region = reg_get_dfs_region(wdev->wiphy);
@@ -5686,12 +5687,16 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	if (err)
 		return err;
 
+	cac_time_ms = cfg80211_chandef_dfs_cac_time(&rdev->wiphy, &chandef,
+						    dfs_region);
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

