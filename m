Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34871 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733Ab3KENtF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 08:49:05 -0500
Received: by mail-ee0-f46.google.com with SMTP id b57so1424995eek.5
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 05:49:04 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 4/5] cfg80211: DFS check chandef usable before CAC
Date: Tue,  5 Nov 2013 14:48:48 +0100
Message-Id: <1383659329-11023-4-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131105_144911_590124_C20EABC6)
In-Reply-To: <1383659329-11023-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1383659329-11023-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check chandef we get in CAC request is usable for CAC.
All channels have to be DFS channels. Allow DFS_USABLE
and DFS_AVAILABLE channels mix. At least one channel
has to be DFS_USABLE (require CAC).

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Reviewed-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/chan.c    |   74 ++++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/core.h    |   13 +++++++++
 net/wireless/nl80211.c |    2 +-
 3 files changed, 88 insertions(+), 1 deletion(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 1d25a46..96c9780 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -351,6 +351,80 @@ int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
 }
 EXPORT_SYMBOL(cfg80211_chandef_dfs_required);
 
+static int cfg80211_get_chans_dfs_usable(struct wiphy *wiphy,
+					 u32 center_freq,
+					 u32 bandwidth)
+{
+	struct ieee80211_channel *c;
+	u32 freq, start_freq, end_freq;
+	int count = 0;
+
+	start_freq = cfg80211_get_start_freq(center_freq, bandwidth);
+	end_freq = cfg80211_get_end_freq(center_freq, bandwidth);
+
+	/*
+	 * Check entire range of channels for the bandwidth.
+	 * Check all channels are DFS channels (DFS_USABLE or
+	 * DFS_AVAILABLE). Return number of usable channels
+	 * (require CAC). Allow DFS and non-DFS channel mix.
+	 */
+	for (freq = start_freq; freq <= end_freq; freq += 20) {
+		c = ieee80211_get_channel(wiphy, freq);
+		if (!c)
+			return -EINVAL;
+
+		if (c->flags & IEEE80211_CHAN_DISABLED)
+			return -EINVAL;
+
+		if (c->flags & IEEE80211_CHAN_RADAR) {
+			if (c->dfs_state == NL80211_DFS_UNAVAILABLE)
+				return -EINVAL;
+
+			if (c->dfs_state == NL80211_DFS_USABLE)
+				count++;
+		}
+	}
+
+	return count;
+}
+
+bool cfg80211_chandef_dfs_usable(struct wiphy *wiphy,
+				 const struct cfg80211_chan_def *chandef)
+{
+	int width;
+	int r1, r2 = 0;
+
+	if (WARN_ON(!cfg80211_chandef_valid(chandef)))
+		return false;
+
+	width = cfg80211_chandef_get_width(chandef);
+	if (width < 0)
+		return false;
+
+	r1 = cfg80211_get_chans_dfs_usable(wiphy, chandef->center_freq1,
+					  width);
+
+	if (r1 < 0)
+		return false;
+
+	switch (chandef->width) {
+	case NL80211_CHAN_WIDTH_80P80:
+		WARN_ON(!chandef->center_freq2);
+		r2 = cfg80211_get_chans_dfs_usable(wiphy,
+						   chandef->center_freq2,
+						   width);
+		if (r2 < 0)
+			return false;
+		break;
+	default:
+		WARN_ON(chandef->center_freq2);
+		break;
+	}
+
+	return (r1 + r2 > 0);
+}
+
+
 static bool cfg80211_secondary_chans_ok(struct wiphy *wiphy,
 					u32 center_freq, u32 bandwidth,
 					u32 prohibited_flags)
diff --git a/net/wireless/core.h b/net/wireless/core.h
index b43efac..5390aeb 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -382,6 +382,19 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 				 enum cfg80211_chan_mode chanmode,
 				 u8 radar_detect);
 
+/**
+ * cfg80211_chandef_dfs_usable - checks if chandef is DFS usable
+ * @wiphy: the wiphy to validate against
+ * @chandef: the channel definition to check
+ *
+ * Checks if chandef is usable and we can/need start CAC on such channel.
+ *
+ * Return: Return true if all channels available and at least
+ *	   one channel require CAC (NL80211_DFS_USABLE)
+ */
+bool cfg80211_chandef_dfs_usable(struct wiphy *wiphy,
+				 const struct cfg80211_chan_def *chandef);
+
 void cfg80211_set_dfs_state(struct wiphy *wiphy,
 			    const struct cfg80211_chan_def *chandef,
 			    enum nl80211_dfs_state dfs_state);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index fdac22c..0a862f1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5651,7 +5651,7 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	if (err == 0)
 		return -EINVAL;
 
-	if (chandef.chan->dfs_state != NL80211_DFS_USABLE)
+	if (!cfg80211_chandef_dfs_usable(wdev->wiphy, &chandef))
 		return -EINVAL;
 
 	if (!rdev->ops->start_radar_detection)
-- 
1.7.9.5

