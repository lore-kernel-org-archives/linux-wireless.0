Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:36017 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab3J2MMI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Oct 2013 08:12:08 -0400
Received: by mail-ea0-f177.google.com with SMTP id f15so2821671eak.8
        for <linux-wireless@vger.kernel.org>; Tue, 29 Oct 2013 05:12:07 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mcgrof@do-not-panic.com,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 1/2] cfg80211: handle correctly prohibited flags
Date: Tue, 29 Oct 2013 13:11:55 +0100
Message-Id: <1383048716-5886-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131029_131212_600108_2E0E36A0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Handle correctly prohibited flags in cfg80211_secondary_chans_ok()
function. Before, we ignore IEEE80211_CHAN_RADAR flag even
caller put the flag as prohibited one.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/wireless/chan.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index a6f5c4c..6f2be48 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -438,16 +438,7 @@ static bool cfg80211_secondary_chans_ok(struct wiphy *wiphy,
 
 	for (freq = start_freq; freq <= end_freq; freq += 20) {
 		c = ieee80211_get_channel(wiphy, freq);
-		if (!c)
-			return false;
-
-		/* check for radar flags */
-		if ((prohibited_flags & c->flags & IEEE80211_CHAN_RADAR) &&
-		    (c->dfs_state != NL80211_DFS_AVAILABLE))
-			return false;
-
-		/* check for the other flags */
-		if (c->flags & prohibited_flags & ~IEEE80211_CHAN_RADAR)
+		if (!c || c->flags & prohibited_flags)
 			return false;
 	}
 
-- 
1.7.9.5

