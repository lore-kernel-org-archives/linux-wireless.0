Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34807 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753433AbbDWOmL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2015 10:42:11 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2] mac80211: fix rhashtable conversion
Date: Thu, 23 Apr 2015 16:42:08 +0200
Message-Id: <1429800128-1333-1-git-send-email-johannes@sipsolutions.net> (sfid-20150423_164215_935901_52574FF6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

My conversion of the mac80211 station hash table to rhashtable
completely broke the lookup in sta_info_get() as it no longer
took into account the virtual interface. Fix that.

Fixes: 7bedd0cfad4e1 ("mac80211: use rhashtable for station table")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 12971b71d0fa..39893178a1a9 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -157,8 +157,24 @@ struct sta_info *sta_info_get(struct ieee80211_sub_if_data *sdata,
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
+		if (sta->sdata == sdata) {
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
-- 
2.1.4

