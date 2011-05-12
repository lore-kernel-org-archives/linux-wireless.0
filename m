Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43856 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab1ELNLi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 09:11:38 -0400
Subject: [PATCH] mac80211: fix a few RCU issues
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 15:11:37 +0200
Message-ID: <1305205897.3461.29.camel@jlt3.sipsolutions.net> (sfid-20110512_151148_842962_1DCDD9AF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

A few configuration functions correctly do
rcu_read_lock() but don't correctly reference
some pointers protected by RCU. Fix that.

Cc: stable@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/net/mac80211/cfg.c	2011-05-12 15:10:47.000000000 +0200
+++ b/net/mac80211/cfg.c	2011-05-12 15:10:48.000000000 +0200
@@ -228,11 +228,11 @@ static int ieee80211_get_key(struct wiph
 			goto out;
 
 		if (pairwise)
-			key = sta->ptk;
+			key = rcu_dereference(sta->ptk);
 		else if (key_idx < NUM_DEFAULT_KEYS)
-			key = sta->gtk[key_idx];
+			key = rcu_dereference(sta->gtk[key_idx]);
 	} else
-		key = sdata->keys[key_idx];
+		key = rcu_dereference(sdata->keys[key_idx]);
 
 	if (!key)
 		goto out;
@@ -943,8 +943,10 @@ static int ieee80211_change_mpath(struct
 static void mpath_set_pinfo(struct mesh_path *mpath, u8 *next_hop,
 			    struct mpath_info *pinfo)
 {
-	if (mpath->next_hop)
-		memcpy(next_hop, mpath->next_hop->sta.addr, ETH_ALEN);
+	struct sta_info *next_hop_sta = rcu_dereference(mpath->next_hop);
+
+	if (next_hop_sta)
+		memcpy(next_hop, next_hop_sta->sta.addr, ETH_ALEN);
 	else
 		memset(next_hop, 0, ETH_ALEN);
 


