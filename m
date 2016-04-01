Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:48256 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbcDAVNg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2016 17:13:36 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] mac80211:  Ensure no limits on station rhashtable.
Date: Fri,  1 Apr 2016 14:13:31 -0700
Message-Id: <1459545211-11517-1-git-send-email-greearb@candelatech.com> (sfid-20160401_231338_647215_603FF368)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

By default, the rhashtable logic will fail to insert
objects if the key-chains are too long and un-balanced.

In the degenerate case where mac80211 is creating many
station vdevs connected to the same peer, this case can
be hit.

So, set insecure_elasticity to true to allow chains to grow
as long as needed.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/mac80211/sta_info.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 38ef0be..c25b945 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -66,6 +66,7 @@
 
 static const struct rhashtable_params sta_rht_params = {
 	.nelem_hint = 3, /* start small */
+	.insecure_elasticity = true, /* Disable chain-length checks. */
 	.automatic_shrinking = true,
 	.head_offset = offsetof(struct sta_info, hash_node),
 	.key_offset = offsetof(struct sta_info, addr),
@@ -322,8 +323,11 @@ static int sta_info_hash_add(struct ieee80211_local *local,
 
 	rv = rhashtable_insert_fast(&local->sta_hash, &sta->hash_node,
 				    sta_rht_params);
-	if (rv != 0)
+	if (rv != 0) {
+		pr_err("Failed to insert sta %pM in rhashtable, idx: %d  err: %d\n",
+		       sta->sta.addr, idx, rv);
 		return rv;
+	}
 
 	sta->vnext = sta->sdata->sta_vhash[idx];
 	rcu_assign_pointer(sta->sdata->sta_vhash[idx], sta);
-- 
2.4.3

