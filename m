Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:39370 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab3J2GPx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Oct 2013 02:15:53 -0400
Received: by mail-ee0-f43.google.com with SMTP id b47so2402461eek.30
        for <linux-wireless@vger.kernel.org>; Mon, 28 Oct 2013 23:15:52 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] cfg80211: allow beaconing after CAC
Date: Tue, 29 Oct 2013 07:15:26 +0100
Message-Id: <1383027326-2635-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131029_071607_699909_BC43CFDD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After going throught the Channel Availability Check (CAC)
required by DFS enable beaconing. Channels that have gone
through a CAC will be in the NL80211_DFS_AVAILABLE.
Without this change APs don't start beaconing after
successful CAC.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
One flag could be used in the future IEEE80211_CHAN_NO_IR.

 net/wireless/chan.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index a6f5c4c..205acf2 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -432,6 +432,7 @@ static bool cfg80211_secondary_chans_ok(struct wiphy *wiphy,
 {
 	struct ieee80211_channel *c;
 	u32 freq, start_freq, end_freq;
+	u32 ignore_flags;
 
 	start_freq = cfg80211_get_start_freq(center_freq, bandwidth);
 	end_freq = cfg80211_get_end_freq(center_freq, bandwidth);
@@ -441,13 +442,24 @@ static bool cfg80211_secondary_chans_ok(struct wiphy *wiphy,
 		if (!c)
 			return false;
 
+		ignore_flags = IEEE80211_CHAN_RADAR;
+
 		/* check for radar flags */
-		if ((prohibited_flags & c->flags & IEEE80211_CHAN_RADAR) &&
-		    (c->dfs_state != NL80211_DFS_AVAILABLE))
-			return false;
+		if (prohibited_flags & c->flags & IEEE80211_CHAN_RADAR) {
+			if (c->dfs_state != NL80211_DFS_AVAILABLE)
+				return false;
+			/*
+			 * If DFS is required we should check only
+			 * c->dfs_state == NL80211_DFS_AVAILABLE and
+			 * ignore IEEE80211_CHAN_NO_IBSS and
+			 * IEEE80211_CHAN_PASSIVE_SCAN flags
+			 */
+			ignore_flags |= IEEE80211_CHAN_NO_IBSS |
+					IEEE80211_CHAN_PASSIVE_SCAN;
+		}
 
 		/* check for the other flags */
-		if (c->flags & prohibited_flags & ~IEEE80211_CHAN_RADAR)
+		if (c->flags & prohibited_flags & ~ignore_flags)
 			return false;
 	}
 
-- 
1.7.9.5

