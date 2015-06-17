Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:33260 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447AbbFQREg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 13:04:36 -0400
Received: by iebgx4 with SMTP id gx4so38080347ieb.0
        for <linux-wireless@vger.kernel.org>; Wed, 17 Jun 2015 10:04:35 -0700 (PDT)
Message-ID: <5581A896.6020207@cococorp.com> (sfid-20150617_190439_711425_EB98A14F)
Date: Wed, 17 Jun 2015 10:04:22 -0700
From: Alexis Green <agreen@cococorp.com>
Reply-To: agreen@cococorp.com
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Jesse Jones <jjones@cococorp.com>, linux-wireless@vger.kernel.org,
	"A. Riley Eller" <reller@cococorp.com>
Subject: [PATCH] mac80211: mesh - don't special case routing to transmitter
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jesse Jones <jjones@cococorp.com>

Updating the path to the transmitter of a path message is optional
according to section 13.10.8.4 of the standard. Doing so can lead to
better performance since we can adjust the route to the transmitter based
on the freshest possible information. However it can also cause routing
loops with more than four or five nodes. Trading off routing correctness
for a marginal performance improvement seems like a bad idea so this patch
removes that feature.

Signed-off-by: Alexis Green <agreen@cococorp.com>
Signed-off-by: A. Riley Eller <reller@cococorp.com>

---

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index be63534..5042f48
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -369,7 +369,7 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 	struct mesh_path *mpath;
 	struct sta_info *sta;
 	bool fresh_info;
-	const u8 *orig_addr, *ta;
+	const u8 *orig_addr;
 	u32 orig_sn, orig_metric;
 	unsigned long orig_lifetime, exp_time;
 	u32 last_hop_metric, new_metric;
@@ -480,41 +480,6 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 			spin_unlock_bh(&mpath->state_lock);
 	}
 
-	/* Update and check transmitter routing info */
-	ta = mgmt->sa;
-	if (ether_addr_equal(orig_addr, ta))
-		fresh_info = false;
-	else {
-		fresh_info = true;
-
-		mpath = mesh_path_lookup(sdata, ta);
-		if (mpath) {
-			spin_lock_bh(&mpath->state_lock);
-			if ((mpath->flags & MESH_PATH_FIXED) ||
-				((mpath->flags & MESH_PATH_ACTIVE) &&
-					(last_hop_metric > mpath->metric)))
-				fresh_info = false;
-		} else {
-			mpath = mesh_path_add(sdata, ta);
-			if (IS_ERR(mpath)) {
-				rcu_read_unlock();
-				return 0;
-			}
-			spin_lock_bh(&mpath->state_lock);
-		}
-
-		if (fresh_info) {
-			mesh_path_assign_nexthop(mpath, sta);
-			mpath->metric = last_hop_metric;
-			mpath->exp_time = time_after(mpath->exp_time, exp_time)
-					  ?  mpath->exp_time : exp_time;
-			mesh_path_activate(mpath);
-			spin_unlock_bh(&mpath->state_lock);
-			mesh_path_tx_pending(mpath);
-		} else
-			spin_unlock_bh(&mpath->state_lock);
-	}
-
 	rcu_read_unlock();
 
 	return process ? new_metric : 0;
