Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:55517 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756959Ab3KHKlt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Nov 2013 05:41:49 -0500
Received: by mail-ea0-f174.google.com with SMTP id n15so809733ead.5
        for <linux-wireless@vger.kernel.org>; Fri, 08 Nov 2013 02:41:48 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mcgrof@do-not-panic.com,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 3/3] cfg80211: DFS use 10 minutes CAC when weather channels
Date: Fri,  8 Nov 2013 11:41:27 +0100
Message-Id: <1383907287-2925-3-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131108_114153_549124_153F9E9A)
In-Reply-To: <1383907287-2925-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1383907287-2925-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When nominal bandwidth falls completely or partly
within the band 5600MHz to 5650MHz the CAC time shall
be 10 minutes.
This is ETSI requirement. FCC forbids weather channels usage.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 include/net/cfg80211.h |    5 +++-
 net/wireless/chan.c    |   73 ++++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/core.h    |    4 +++
 net/wireless/nl80211.c |    6 +++-
 4 files changed, 86 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d43fa0a..c40847e 100644
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
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 78559b5..aa691d3 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -490,6 +490,79 @@ static bool cfg80211_chandef_dfs_available(struct wiphy *wiphy,
 	return r;
 }
 
+static int cfg80211_get_chans_dfs_is_weather(struct wiphy *wiphy,
+					     u32 center_freq,
+					     u32 bandwidth)
+{
+	u32 start_freq, end_freq;
+
+	start_freq = cfg80211_get_start_freq(center_freq, bandwidth) - 10;
+	end_freq = cfg80211_get_end_freq(center_freq, bandwidth) + 10;
+
+	/*
+	 * ETSI EN 301 893 V1.7.0 Table D.1
+	 * TODO In the future we can get this from regdb eg. channel flag
+	 * IEEE80211_CHAN_TDWR.
+	 */
+	if ((start_freq >= 5600 && start_freq < 5650) ||
+	    (end_freq > 5600 && end_freq <= 5650))
+		return 1;
+
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
+	r = cfg80211_get_chans_dfs_is_weather(wiphy,
+					      chandef->center_freq1,
+					      width);
+
+	if (r)
+		return r;
+
+	if (!chandef->center_freq2)
+		return 0;
+
+	return cfg80211_get_chans_dfs_is_weather(wiphy,
+						 chandef->center_freq2,
+						 width);
+}
+
+unsigned int
+cfg80211_chandef_dfs_cac_time(struct wiphy *wiphy,
+			      const struct cfg80211_chan_def *chandef,
+			      u8 dfs_region)
+{
+	unsigned int timeout_ms = IEEE80211_DFS_MIN_CAC_TIME_MS;
+
+	switch (dfs_region) {
+	case NL80211_DFS_ETSI:
+		if (cfg80211_chandef_dfs_is_weather(wiphy, chandef))
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
index 5390aeb..67d70c1 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -401,6 +401,10 @@ void cfg80211_set_dfs_state(struct wiphy *wiphy,
 
 void cfg80211_dfs_channels_update_work(struct work_struct *work);
 
+unsigned int
+cfg80211_chandef_dfs_cac_time(struct wiphy *wiphy,
+			      const struct cfg80211_chan_def *chandef,
+			      u8 dfs_region);
 
 static inline int
 cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 689a335..9421bc7 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5629,6 +5629,7 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_chan_def chandef;
 	const struct ieee80211_regdomain *regdom;
+	unsigned int cac_time_ms;
 	u8 dfs_region;
 	int err;
 
@@ -5672,8 +5673,11 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
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
-- 
1.7.9.5

