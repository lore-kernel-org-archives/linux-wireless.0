Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42484 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbaBDPzv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Feb 2014 10:55:51 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.14] mac80211: fix virtual monitor interface iteration
Date: Tue,  4 Feb 2014 16:55:48 +0100
Message-Id: <1391529348-26807-1-git-send-email-johannes@sipsolutions.net> (sfid-20140204_165555_050785_B19147CB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

During channel context assignment, the interface should
be found by interface iteration, so we need to assign the
pointer before the channel context.

Reported-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Tested-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index ae2eb14..d6d1f1d 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -418,20 +418,24 @@ int ieee80211_add_virtual_monitor(struct ieee80211_local *local)
 		return ret;
 	}
 
+	mutex_lock(&local->iflist_mtx);
+	rcu_assign_pointer(local->monitor_sdata, sdata);
+	mutex_unlock(&local->iflist_mtx);
+
 	mutex_lock(&local->mtx);
 	ret = ieee80211_vif_use_channel(sdata, &local->monitor_chandef,
 					IEEE80211_CHANCTX_EXCLUSIVE);
 	mutex_unlock(&local->mtx);
 	if (ret) {
+		mutex_lock(&local->iflist_mtx);
+		rcu_assign_pointer(local->monitor_sdata, NULL);
+		mutex_unlock(&local->iflist_mtx);
+		synchronize_net();
 		drv_remove_interface(local, sdata);
 		kfree(sdata);
 		return ret;
 	}
 
-	mutex_lock(&local->iflist_mtx);
-	rcu_assign_pointer(local->monitor_sdata, sdata);
-	mutex_unlock(&local->iflist_mtx);
-
 	return 0;
 }
 
-- 
1.8.5.3

