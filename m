Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37294 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab3GHIqs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 04:46:48 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: greearb@candelatech.com
Subject: [PATCH] mac80211: fix ethtool stats for non-station interfaces
Date: Mon,  8 Jul 2013 10:46:31 +0200
Message-Id: <1373273191-16251-1-git-send-email-johannes@sipsolutions.net> (sfid-20130708_104651_360974_B06BF0D5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As reported in https://bugzilla.kernel.org/show_bug.cgi?id=60514,
the station loop never initialises 'sinfo' and therefore adds up
a stack values, leaking stack information (the number of times it
adds values is easily obtained another way.)

Fix this by initialising the sinfo for each station to add.

Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/cfg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 8184d12..43dd752 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -666,6 +666,8 @@ static void ieee80211_get_et_stats(struct wiphy *wiphy,
 			if (sta->sdata->dev != dev)
 				continue;
 
+			sinfo.filled = 0;
+			sta_set_sinfo(sta, &sinfo);
 			i = 0;
 			ADD_STA_STATS(sta);
 		}
-- 
1.8.0

