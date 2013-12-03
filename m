Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:49841 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab3LCMYq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 07:24:46 -0500
Received: by mail-ee0-f45.google.com with SMTP id d49so1436934eek.32
        for <linux-wireless@vger.kernel.org>; Tue, 03 Dec 2013 04:24:44 -0800 (PST)
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Marek Puzyniak <marek.puzyniak@tieto.com>
Subject: [PATCH v3] cfg80211: fix dfs channel state after stopping AP
Date: Tue,  3 Dec 2013 13:24:26 +0100
Message-Id: <1386073466-2641-1-git-send-email-marek.puzyniak@tieto.com> (sfid-20131203_132455_955722_A28383DA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In AP mode DFS channel state is changed to DFS_AVAILABLE
after successful CAC and remains as such until a radar
signal is detected during the In-Service Monitoring.
When AP is stopped it is no longer monitoring current channel
for radar signals. DFS channel state should be changed back
to DFS_USABLE. Starting AP again on that channel will start CAC
instead of starting radiation.

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
index 78559b5..f0cf780 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -490,6 +490,45 @@ static bool cfg80211_chandef_dfs_available(struct wiphy *wiphy,
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
index 6716c5c..ca230a2 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -400,6 +400,17 @@ void cfg80211_set_dfs_state(struct wiphy *wiphy,
 
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

