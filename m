Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:41516 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab3J2MMJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Oct 2013 08:12:09 -0400
Received: by mail-ee0-f52.google.com with SMTP id e49so1667596eek.39
        for <linux-wireless@vger.kernel.org>; Tue, 29 Oct 2013 05:12:08 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mcgrof@do-not-panic.com,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 2/2] cfg80211: allow beaconing after DFS CAC
Date: Tue, 29 Oct 2013 13:11:56 +0100
Message-Id: <1383048716-5886-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131029_131214_643793_B0BD959A)
In-Reply-To: <1383048716-5886-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1383048716-5886-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After going throught the Channel Availability Check (CAC)
required by DFS enable beaconing. Channels that have
gone through a CAC will be in the NL80211_DFS_AVAILABLE
state. Without this change APs don't start beaconing
after a successful CAC.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/wireless/chan.c |   78 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 73 insertions(+), 5 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 6f2be48..a7168d5 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -426,6 +426,71 @@ bool cfg80211_chandef_dfs_usable(struct wiphy *wiphy,
 }
 
 
+static bool cfg80211_get_chans_dfs_available(struct wiphy *wiphy,
+					     u32 center_freq,
+					     u32 bandwidth)
+{
+	struct ieee80211_channel *c;
+	u32 freq, start_freq, end_freq;
+
+	start_freq = cfg80211_get_start_freq(center_freq, bandwidth);
+	end_freq = cfg80211_get_end_freq(center_freq, bandwidth);
+
+	/* Check entire range of channels for the bandwidth.
+	 * If any channel in between is disabled or has not
+	 * had gone through CAC return false
+	 */
+	for (freq = start_freq; freq <= end_freq; freq += 20) {
+		c = ieee80211_get_channel(wiphy, freq);
+		if (!c)
+			return false;
+
+		if (c->flags & IEEE80211_CHAN_DISABLED)
+			return false;
+
+		if ((c->flags & IEEE80211_CHAN_RADAR)  &&
+		    (c->dfs_state != NL80211_DFS_AVAILABLE))
+			return false;
+	}
+
+	return true;
+}
+
+static bool cfg80211_chandef_dfs_available(struct wiphy *wiphy,
+				const struct cfg80211_chan_def *chandef)
+{
+	int width;
+	int r;
+
+	if (WARN_ON(!cfg80211_chandef_valid(chandef)))
+		return false;
+
+	width = cfg80211_chandef_get_width(chandef);
+	if (width < 0)
+		return false;
+
+	r = cfg80211_get_chans_dfs_available(wiphy, chandef->center_freq1,
+					     width);
+
+	/* If any of channels unavailable for cf1 just return */
+	if (!r)
+		return r;
+
+	switch (chandef->width) {
+	case NL80211_CHAN_WIDTH_80P80:
+		WARN_ON(!chandef->center_freq2);
+		r = cfg80211_get_chans_dfs_available(wiphy,
+						     chandef->center_freq2,
+						     width);
+	default:
+		WARN_ON(chandef->center_freq2);
+		break;
+	}
+
+	return r;
+}
+
+
 static bool cfg80211_secondary_chans_ok(struct wiphy *wiphy,
 					u32 center_freq, u32 bandwidth,
 					u32 prohibited_flags)
@@ -547,11 +612,14 @@ bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
 
 	trace_cfg80211_reg_can_beacon(wiphy, chandef);
 
-	res = cfg80211_chandef_usable(wiphy, chandef,
-				      IEEE80211_CHAN_DISABLED |
-				      IEEE80211_CHAN_PASSIVE_SCAN |
-				      IEEE80211_CHAN_NO_IBSS |
-				      IEEE80211_CHAN_RADAR);
+	if (cfg80211_chandef_dfs_required(wiphy, chandef) > 0)
+		res = cfg80211_chandef_dfs_available(wiphy, chandef);
+	else
+		res = cfg80211_chandef_usable(wiphy, chandef,
+					      IEEE80211_CHAN_DISABLED |
+					      IEEE80211_CHAN_PASSIVE_SCAN |
+					      IEEE80211_CHAN_NO_IBSS |
+					      IEEE80211_CHAN_RADAR);
 
 	trace_cfg80211_return_bool(res);
 	return res;
-- 
1.7.9.5

