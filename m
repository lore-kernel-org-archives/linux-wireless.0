Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54384 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097Ab2LMW7T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 17:59:19 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>,
	Eliad Peller <eliad@wizery.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/5] mac80211: use del_timer_sync for final sta cleanup timer deletion
Date: Thu, 13 Dec 2012 23:59:30 +0100
Message-Id: <1355439573-13206-3-git-send-email-johannes@sipsolutions.net> (sfid-20121213_235927_069921_DDF2F57A)
In-Reply-To: <1355439573-13206-1-git-send-email-johannes@sipsolutions.net>
References: <1355439573-13206-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is a very old bug, but there's nothing that prevents the
timer from running while the module is being removed when we
only do del_timer() instead of del_timer_sync().

The timer should normally not be running at this point, but
it's not clearly impossible (or we could just remove this.)

Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 0f709d54..527453d 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -884,7 +884,7 @@ void sta_info_init(struct ieee80211_local *local)
 
 void sta_info_stop(struct ieee80211_local *local)
 {
-	del_timer(&local->sta_cleanup);
+	del_timer_sync(&local->sta_cleanup);
 	sta_info_flush(local, NULL);
 }
 
-- 
1.8.0

