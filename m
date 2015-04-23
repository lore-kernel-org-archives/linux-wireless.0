Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33987 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934298AbbDWM0V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2015 08:26:21 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix rhashtable conversion
Date: Thu, 23 Apr 2015 14:26:09 +0200
Message-Id: <1429791969-16194-1-git-send-email-johannes@sipsolutions.net> (sfid-20150423_142626_637433_88535220)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

My conversion of the mac80211 station hash table to rhashtable
completely broke the lookup in two ways:
 1) sta_info_get() no longer took into account the virtual interface
 2) sta_info_get_bss() no longer compared the MAC address

Fix both these issues.

Fixes: 7bedd0cfad4e1 ("mac80211: use rhashtable for station table")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 737730abba6d..75d71f9f9435 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -157,8 +157,25 @@ struct sta_info *sta_info_get(struct ieee80211_sub_if_data *sdata,
 			      const u8 *addr)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct sta_info *sta;
+	struct rhash_head *tmp;
+	const struct bucket_table *tbl;
+
+	rcu_read_lock();
+	tbl = rht_dereference_rcu(local->sta_hash.tbl, &local->sta_hash);
 
-	return rhashtable_lookup_fast(&local->sta_hash, addr, sta_rht_params);
+	for_each_sta_info(local, tbl, addr, sta, tmp) {
+		if (ether_addr_equal(sta->sta.addr, addr) &&
+		    sta->sdata == sdata) {
+			rcu_read_unlock();
+			/* this is safe as the caller must already hold
+			 * another rcu read section or the mutex
+			 */
+			return sta;
+		}
+	}
+	rcu_read_unlock();
+	return NULL;
 }
 
 /*
@@ -177,8 +194,9 @@ struct sta_info *sta_info_get_bss(struct ieee80211_sub_if_data *sdata,
 	tbl = rht_dereference_rcu(local->sta_hash.tbl, &local->sta_hash);
 
 	for_each_sta_info(local, tbl, addr, sta, tmp) {
-		if (sta->sdata == sdata ||
-		    (sta->sdata->bss && sta->sdata->bss == sdata->bss)) {
+		if (ether_addr_equal(sta->sta.addr, addr) &&
+		    (sta->sdata == sdata ||
+		     (sta->sdata->bss && sta->sdata->bss == sdata->bss))) {
 			rcu_read_unlock();
 			/* this is safe as the caller must already hold
 			 * another rcu read section or the mutex
-- 
2.1.4

