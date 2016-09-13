Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36525 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756361AbcIMNkM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Sep 2016 09:40:12 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: remove useless open_count check
Date: Tue, 13 Sep 2016 15:40:07 +0200
Message-Id: <1473774007-29247-1-git-send-email-johannes@sipsolutions.net> (sfid-20160913_154022_015961_8254034B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

__ieee80211_suspend() checks early on if there's anything
to do by checking open_count, so there's no need to check
again later in the function. Remove the useless check.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/pm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 00a43a70e1fc..28a3a0957c9e 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -178,8 +178,7 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 	WARN_ON(!list_empty(&local->chanctx_list));
 
 	/* stop hardware - this must stop RX */
-	if (local->open_count)
-		ieee80211_stop_device(local);
+	ieee80211_stop_device(local);
 
  suspend:
 	local->suspended = true;
-- 
2.8.1
