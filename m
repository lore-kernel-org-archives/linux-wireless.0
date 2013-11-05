Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:34654 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765Ab3KENtG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 08:49:06 -0500
Received: by mail-ee0-f43.google.com with SMTP id b47so1802692eek.2
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 05:49:05 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 5/5] cfg80211: allow beaconing after DFS CAC
Date: Tue,  5 Nov 2013 14:48:49 +0100
Message-Id: <1383659329-11023-5-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131105_144914_558977_A74E4259)
In-Reply-To: <1383659329-11023-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1383659329-11023-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After going throught the Channel Availability Check (CAC)
required by DFS enable beaconing. Channels that have
gone through a CAC will be in the NL80211_DFS_AVAILABLE
state. Without this change APs don't start beaconing
after a successful CAC.
Change also cfg80211_secondary_chans_ok() where handle
prohibited_flags as prohibited.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/wireless/chan.c |   85 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 74 insertions(+), 11 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 96c9780..64f8d58 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -425,9 +425,9 @@ bool cfg80211_chandef_dfs_usable(struct wiphy *wiphy,
 }
 
 
-static bool cfg80211_secondary_chans_ok(struct wiphy *wiphy,
-					u32 center_freq, u32 bandwidth,
-					u32 prohibited_flags)
+static bool cfg80211_get_chans_dfs_available(struct wiphy *wiphy,
+					     u32 center_freq,
+					     u32 bandwidth)
 {
 	struct ieee80211_channel *c;
 	u32 freq, start_freq, end_freq;
@@ -435,18 +435,75 @@ static bool cfg80211_secondary_chans_ok(struct wiphy *wiphy,
 	start_freq = cfg80211_get_start_freq(center_freq, bandwidth);
 	end_freq = cfg80211_get_end_freq(center_freq, bandwidth);
 
+	/*
+	 * Check entire range of channels for the bandwidth.
+	 * If any channel in between is disabled or has not
+	 * had gone through CAC return false
+	 */
 	for (freq = start_freq; freq <= end_freq; freq += 20) {
 		c = ieee80211_get_channel(wiphy, freq);
 		if (!c)
 			return false;
 
-		/* check for radar flags */
-		if ((prohibited_flags & c->flags & IEEE80211_CHAN_RADAR) &&
+		if (c->flags & IEEE80211_CHAN_DISABLED)
+			return false;
+
+		if ((c->flags & IEEE80211_CHAN_RADAR)  &&
 		    (c->dfs_state != NL80211_DFS_AVAILABLE))
 			return false;
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
+static bool cfg80211_secondary_chans_ok(struct wiphy *wiphy,
+					u32 center_freq, u32 bandwidth,
+					u32 prohibited_flags)
+{
+	struct ieee80211_channel *c;
+	u32 freq, start_freq, end_freq;
 
-		/* check for the other flags */
-		if (c->flags & prohibited_flags & ~IEEE80211_CHAN_RADAR)
+	start_freq = cfg80211_get_start_freq(center_freq, bandwidth);
+	end_freq = cfg80211_get_end_freq(center_freq, bandwidth);
+
+	for (freq = start_freq; freq <= end_freq; freq += 20) {
+		c = ieee80211_get_channel(wiphy, freq);
+		if (!c || c->flags & prohibited_flags)
 			return false;
 	}
 
@@ -552,13 +609,19 @@ bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
 			     struct cfg80211_chan_def *chandef)
 {
 	bool res;
+	u32 prohibited_flags = IEEE80211_CHAN_DISABLED |
+			       IEEE80211_CHAN_NO_IR |
+			       IEEE80211_CHAN_RADAR;
 
 	trace_cfg80211_reg_can_beacon(wiphy, chandef);
 
-	res = cfg80211_chandef_usable(wiphy, chandef,
-				      IEEE80211_CHAN_DISABLED |
-				      IEEE80211_CHAN_NO_IR |
-				      IEEE80211_CHAN_RADAR);
+	if (cfg80211_chandef_dfs_required(wiphy, chandef) > 0 &&
+	    cfg80211_chandef_dfs_available(wiphy, chandef)) {
+		/* We can skip IEEE80211_CHAN_NO_IR if chandef dfs available */
+		prohibited_flags = IEEE80211_CHAN_DISABLED;
+	}
+
+	res = cfg80211_chandef_usable(wiphy, chandef, prohibited_flags);
 
 	trace_cfg80211_return_bool(res);
 	return res;
-- 
1.7.9.5

