Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34736 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750711AbdAWImF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jan 2017 03:42:05 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: don't try to sleep in rate_control_rate_init()
Date: Mon, 23 Jan 2017 09:41:56 +0100
Message-Id: <20170123084156.7969-1-johannes@sipsolutions.net> (sfid-20170123_094220_104303_EC191570)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In my previous patch, I missed that rate_control_rate_init() is
called from some places that cannot sleep, so it cannot call
ieee80211_recalc_min_chandef(). Remove that call for now to fix
the context bug, we'll have to find a different way to fix the
minimum channel width issue.

Fixes: 96aa2e7cf126 ("mac80211: calculate min channel width correctly")
Reported-by: Xiaolong Ye (via lkp-robot) <xiaolong.ye@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rate.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 9e2641d45587..206698bc93f4 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -40,8 +40,6 @@ void rate_control_rate_init(struct sta_info *sta)
 
 	ieee80211_sta_set_rx_nss(sta);
 
-	ieee80211_recalc_min_chandef(sta->sdata);
-
 	if (!ref)
 		return;
 
-- 
2.9.3
