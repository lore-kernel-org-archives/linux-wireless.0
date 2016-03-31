Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45718 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbcCaP2u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2016 11:28:50 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: properly deal with station hashtable insert errors
Date: Thu, 31 Mar 2016 17:28:46 +0200
Message-Id: <1459438126-7349-1-git-send-email-johannes@sipsolutions.net> (sfid-20160331_172853_594379_A12D14D5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The original hand-implemented hash-table in mac80211 couldn't result
in insertion errors, and while converting to rhashtable I evidently
forgot to check the errors.

This surfaced now only because Ben is adding many identical keys and
that resulted in hidden insertion errors.

Cc: stable@vger.kernel.org
Fixes: 7bedd0cfad4e1 ("mac80211: use rhashtable for station table")
Reported-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 00c82fb152c0..92f44bbc2719 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -258,11 +258,11 @@ void sta_info_free(struct ieee80211_local *local, struct sta_info *sta)
 }
 
 /* Caller must hold local->sta_mtx */
-static void sta_info_hash_add(struct ieee80211_local *local,
-			      struct sta_info *sta)
+static int sta_info_hash_add(struct ieee80211_local *local,
+			     struct sta_info *sta)
 {
-	rhashtable_insert_fast(&local->sta_hash, &sta->hash_node,
-			       sta_rht_params);
+	return rhashtable_insert_fast(&local->sta_hash, &sta->hash_node,
+				      sta_rht_params);
 }
 
 static void sta_deliver_ps_frames(struct work_struct *wk)
@@ -524,7 +524,9 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
 	set_sta_flag(sta, WLAN_STA_BLOCK_BA);
 
 	/* make the station visible */
-	sta_info_hash_add(local, sta);
+	err = sta_info_hash_add(local, sta);
+	if (err)
+		goto out_drop_sta;
 
 	list_add_tail_rcu(&sta->list, &local->sta_list);
 
@@ -557,6 +559,7 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
  out_remove:
 	sta_info_hash_del(local, sta);
 	list_del_rcu(&sta->list);
+ out_drop_sta:
 	local->num_sta--;
 	synchronize_net();
 	__cleanup_single_sta(sta);
-- 
2.7.0

