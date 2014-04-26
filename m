Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:41120 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaDZBn4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Apr 2014 21:43:56 -0400
Received: by mail-pa0-f49.google.com with SMTP id lj1so3699184pab.8
        for <linux-wireless@vger.kernel.org>; Fri, 25 Apr 2014 18:43:55 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 1/2] mac80211: beautify the code
Date: Sat, 26 Apr 2014 09:43:40 +0800
Message-Id: <2c511530891bb91f1898a9ae09fed1628043192c.1398476191.git.gamerh2o@gmail.com> (sfid-20140426_034359_786976_7056D980)
In-Reply-To: <1398440262.4152.21.camel@jlt4.sipsolutions.net>
References: <1398440262.4152.21.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_assign_chanctx() checks if local->use_chanctx is true, so
the two code block related to ieee80211_assign_chanctx() can be moved
into above if clause, emphasize that these code are executed only if
local->use_chanctx is true.

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 net/mac80211/util.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 7a376f8..cafbae7 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1565,17 +1565,17 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		list_for_each_entry(ctx, &local->chanctx_list, list)
 			WARN_ON(drv_add_chanctx(local, ctx));
 		mutex_unlock(&local->chanctx_mtx);
-	}
 
-	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (!ieee80211_sdata_running(sdata))
-			continue;
-		ieee80211_assign_chanctx(local, sdata);
-	}
+		list_for_each_entry(sdata, &local->interfaces, list) {
+			if (!ieee80211_sdata_running(sdata))
+				continue;
+			ieee80211_assign_chanctx(local, sdata);
+		}
 
-	sdata = rtnl_dereference(local->monitor_sdata);
-	if (sdata && ieee80211_sdata_running(sdata))
-		ieee80211_assign_chanctx(local, sdata);
+		sdata = rtnl_dereference(local->monitor_sdata);
+		if (sdata && ieee80211_sdata_running(sdata))
+			ieee80211_assign_chanctx(local, sdata);
+	}
 
 	/* add STAs back */
 	mutex_lock(&local->sta_mtx);
-- 
1.9.0

