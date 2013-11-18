Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:59868 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab3KRJhI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Nov 2013 04:37:08 -0500
Received: by mail-ee0-f51.google.com with SMTP id d41so1633047eek.24
        for <linux-wireless@vger.kernel.org>; Mon, 18 Nov 2013 01:37:06 -0800 (PST)
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Marek Puzyniak <marek.puzyniak@tieto.com>
Subject: [PATCH v2] cfg80211: fix dfs channel state after stopping AP
Date: Mon, 18 Nov 2013 10:36:53 +0100
Message-Id: <1384767413-5648-1-git-send-email-marek.puzyniak@tieto.com> (sfid-20131118_103712_798737_6B9652F3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This can be called when a mode of operation that can supports
initiating radiation on a DFS channel leaves that channel to
ensure that if the mode of operation is started again on it
that it will require a new channel availability check.

Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
---
 net/wireless/ap.c   |  3 +++
 net/wireless/chan.c | 39 +++++++++++++++++++++++++++++++++++++++
 net/wireless/core.h | 11 +++++++++++
 3 files changed, 53 insertions(+)

diff --git a/net/wireless/ap.c b/net/wireless/ap.c
index 324e8d8..9349773 100644
--- a/net/wireless/ap.c
+++ b/net/wireless/ap.c
@@ -26,6 +26,9 @@ static int __cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
 
 	err = rdev_stop_ap(rdev, dev);
 	if (!err) {
+		if (cfg80211_chandef_dfs_required(wdev->wiphy, &wdev->preset_chandef))
+			cfg80211_leave_dfs_chandef(wdev->wiphy, &wdev->preset_chandef);
+
 		wdev->beacon_interval = 0;
 		wdev->channel = NULL;
 		wdev->ssid_len = 0;
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 2ac4cac..bf85247 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -489,6 +489,45 @@ static bool cfg80211_chandef_dfs_available(struct wiphy *wiphy,
 	return r;
 }
 
+static void cfg80211_leave_dfs_chans(struct wiphy *wiphy,
+				     u32 center_freq,
+				     u32 bandwidth)
+{
+	struct ieee80211_channel *c;
+	u32 freq, start_freq, end_freq;
+
+	start_freq = cfg80211_get_start_freq(center_freq, bandwidth);
+	end_freq = cfg80211_get_end_freq(center_freq, bandwidth);
+
+	for (freq = start_freq; freq <= end_freq; freq += 20) {
+		c = ieee80211_get_channel(wiphy, freq);
+		if (!c)
+			continue;
+		if (!(c->flags & IEEE80211_CHAN_RADAR))
+			continue;
+		if (c->dfs_state != NL80211_DFS_AVAILABLE)
+			continue;
+
+		cfg80211_set_chans_dfs_state(wiphy, freq, 20, NL80211_DFS_USABLE);
+	}
+}
+
+void cfg80211_leave_dfs_chandef(struct wiphy *wiphy,
+				struct cfg80211_chan_def *chandef)
+{
+	int width;
+
+	if (WARN_ON(!cfg80211_chandef_valid(chandef)))
+		return;
+
+	width = cfg80211_chandef_get_width(chandef);
+	cfg80211_leave_dfs_chans(wiphy, chandef->center_freq1, width);
+
+	if (!chandef->center_freq2)
+		return;
+
+	cfg80211_leave_dfs_chans(wiphy, chandef->center_freq2, width);
+}
 
 static bool cfg80211_secondary_chans_ok(struct wiphy *wiphy,
 					u32 center_freq, u32 bandwidth,
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 2888867..76dfe6b 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -401,6 +401,17 @@ void cfg80211_set_dfs_state(struct wiphy *wiphy,
 
 void cfg80211_dfs_channels_update_work(struct work_struct *work);
 
+/**
+ * cfg80211_leave_dfs_chandef - Leaving dfs chandef
+ * @wiphy: the wiphy
+ * @chandef: chandef for the current channel
+ *
+ * This function is called when dfs chandef is being not used for different
+ * reasons. Change channels DFS_AVAILABLE to DFS_USABLE again. Leave channels
+ * DFS_UNAVAILABLE untouched.
+ */
+void cfg80211_leave_dfs_chandef(struct wiphy *wiphy,
+				struct cfg80211_chan_def *chandef);
 
 static inline int
 cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
-- 
1.8.1.2

