Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42782 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760414AbcINIMD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 04:12:03 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/5] mac80211: remove pointless chanctx NULL check
Date: Wed, 14 Sep 2016 10:11:57 +0200
Message-Id: <1473840718-5605-4-git-send-email-johannes@sipsolutions.net> (sfid-20160914_101215_087643_F24F2AB9)
In-Reply-To: <1473840718-5605-1-git-send-email-johannes@sipsolutions.net>
References: <1473840718-5605-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If chanctx is derived as container_of() from a non-NULL pointer,
it can't ever be NULL. Since we checked conf before, that's true
here, so remove the useless NULL check.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 5d4afead804e..e29ff5749944 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2961,10 +2961,6 @@ __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	chanctx = container_of(conf, struct ieee80211_chanctx, conf);
-	if (!chanctx) {
-		err = -EBUSY;
-		goto out;
-	}
 
 	ch_switch.timestamp = 0;
 	ch_switch.device_timestamp = 0;
-- 
2.8.1
