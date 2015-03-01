Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:49636 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbbCAHKk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 02:10:40 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/16] mac80211: remove useless double check for open_count in __ieee80211_suspend()
Date: Sun,  1 Mar 2015 09:10:07 +0200
Message-Id: <1425193815-17785-9-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_081048_545911_F432C7A7)
In-Reply-To: <1425193815-17785-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1425193815-17785-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

We check local->open_count at the top of the __ieee80211_suspend(), so
there's no need to check for it again.  open_count is protected by the
rtnl, so there's no chance for it to have change between the two
calls.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/pm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index bd185f3..46ffe3a 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -59,7 +59,7 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 	cancel_work_sync(&local->dynamic_ps_enable_work);
 	del_timer_sync(&local->dynamic_ps_timer);
 
-	local->wowlan = wowlan && local->open_count;
+	local->wowlan = wowlan;
 	if (local->wowlan) {
 		int err;
 
-- 
1.9.1

