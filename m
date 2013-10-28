Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:49529 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757207Ab3J1S1W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 14:27:22 -0400
Received: by mail-ea0-f173.google.com with SMTP id g10so2427006eak.32
        for <linux-wireless@vger.kernel.org>; Mon, 28 Oct 2013 11:27:21 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 4/5] cfg80211: DFS check chandef usable before CAC
Date: Mon, 28 Oct 2013 19:27:03 +0100
Message-Id: <1382984824-3729-4-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131028_192726_798468_3954BB88)
In-Reply-To: <1382984824-3729-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1382984824-3729-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check chandef we get in CAC request is usable for CAC.
All channels have to be DFS channels. Allow DFS_USABLE
and DFS_AVAILABLE channels mix. At least one channel
has to be DFS_USABLE (require CAC).

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Reviewed-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/chan.c    |   75 ++++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/core.h    |   11 +++++++
 net/wireless/nl80211.c |    2 +-
 3 files changed, 87 insertions(+), 1 deletion(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index f74dae3..a6f5c4c 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -351,6 +351,81 @@ int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
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
+	 * (require CAC).
+	 */
+	for (freq = start_freq; freq <= end_freq; freq += 20) {
+		c = ieee80211_get_channel(wiphy, freq);
+		if (!c)
+			return -EINVAL;
+
+		if (c->flags & IEEE80211_CHAN_DISABLED)
+			return -EINVAL;
+
+		if (!(c->flags & IEEE80211_CHAN_RADAR))
+			return -EINVAL;
+
+		if (c->dfs_state == NL80211_DFS_UNAVAILABLE)
+			return -EINVAL;
+
+		if (c->dfs_state == NL80211_DFS_USABLE)
+			count++;
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
index eb0f7a3..eb24a53 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -382,6 +382,17 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 				 enum cfg80211_chan_mode chanmode,
 				 u8 radar_detect);
 
+/**
+ * cfg80211_chandef_dfs_usable - checks if chandef is usable and we can
+ * start CAC on such chandef.
+ * @wiphy: the wiphy to validate against
+ * @chandef: the channel definition to check
+ * Return: Return true if all channels available and at least
+ * one channel required CAC (NL80211_DFS_USABLE)
+ */
+bool cfg80211_chandef_dfs_usable(struct wiphy *wiphy,
+				 const struct cfg80211_chan_def *chandef);
+
 void cfg80211_set_dfs_state(struct wiphy *wiphy,
 			    const struct cfg80211_chan_def *chandef,
 			    enum nl80211_dfs_state dfs_state);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index cbbef88..1cb1cd9 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5604,7 +5604,7 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	if (err == 0)
 		return -EINVAL;
 
-	if (chandef.chan->dfs_state != NL80211_DFS_USABLE)
+	if (!cfg80211_chandef_dfs_usable(wdev->wiphy, &chandef))
 		return -EINVAL;
 
 	if (!rdev->ops->start_radar_detection)
-- 
1.7.9.5

