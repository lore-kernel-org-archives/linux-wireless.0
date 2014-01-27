Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:35829 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbaA0JJ3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jan 2014 04:09:29 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: release the channel in error path in start_ap
Date: Mon, 27 Jan 2014 11:07:42 +0200
Message-Id: <1390813662-19032-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140127_100951_428869_8F6023AA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the driver cannot start the AP or when the assignement
of the beacon goes wrong, we need to unassign the vif.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/cfg.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 53917b7..e410dff 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1021,8 +1021,10 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 					IEEE80211_P2P_OPPPS_ENABLE_BIT;
 
 	err = ieee80211_assign_beacon(sdata, &params->beacon);
-	if (err < 0)
+	if (err < 0) {
+		ieee80211_vif_release_channel(sdata);
 		return err;
+	}
 	changed |= err;
 
 	err = drv_start_ap(sdata->local, sdata);
@@ -1032,6 +1034,7 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 		if (old)
 			kfree_rcu(old, rcu_head);
 		RCU_INIT_POINTER(sdata->u.ap.beacon, NULL);
+		ieee80211_vif_release_channel(sdata);
 		return err;
 	}
 
-- 
1.8.3.2

