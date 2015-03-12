Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:19662 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591AbbCLGxt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 02:53:49 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 7/7] mac80211: Count correctly interface types
Date: Thu, 12 Mar 2015 08:53:30 +0200
Message-Id: <1426143210-25635-7-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_075407_840352_246E6BC4)
In-Reply-To: <1426143210-25635-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1426143210-25635-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Previously, interface combination check in mac80211 considered only
interfaces that have channel context. This wouldn't take P2P device interfaces
into account at all. Also for managed interfaces the channel context is bound
upon association and the combination check is performed when the iface is
brought up.
Fix this by counting the numbers of running interfaces instead of number of
interfaces that have channel context.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index e664b28..36d8cb2 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -3245,7 +3245,7 @@ int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
 		wdev_iter = &sdata_iter->wdev;
 
 		if (sdata_iter == sdata ||
-		    rcu_access_pointer(sdata_iter->vif.chanctx_conf) == NULL ||
+		    !ieee80211_sdata_running(sdata_iter) ||
 		    local->hw.wiphy->software_iftypes & BIT(wdev_iter->iftype))
 			continue;
 
-- 
1.9.1

