Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34340 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab2LRCtE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2012 21:49:04 -0500
Received: by mail-pa0-f51.google.com with SMTP id fb11so170820pad.38
        for <linux-wireless@vger.kernel.org>; Mon, 17 Dec 2012 18:49:02 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH] mac80211: RMC buckets are just list heads
Date: Mon, 17 Dec 2012 18:41:57 -0800
Message-Id: <1355798517-27063-1-git-send-email-thomas@cozybit.com> (sfid-20121218_034909_453854_DD8ED351)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The array of rmc_entrys is redundant since only the
list_head is used. Make this an array of list_heads
instead and save ~6k per vif at runtime :D

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh.c |    8 ++++----
 net/mac80211/mesh.h |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 1bf03f9..649ad51 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -163,7 +163,7 @@ int mesh_rmc_init(struct ieee80211_sub_if_data *sdata)
 		return -ENOMEM;
 	sdata->u.mesh.rmc->idx_mask = RMC_BUCKETS - 1;
 	for (i = 0; i < RMC_BUCKETS; i++)
-		INIT_LIST_HEAD(&sdata->u.mesh.rmc->bucket[i].list);
+		INIT_LIST_HEAD(&sdata->u.mesh.rmc->bucket[i]);
 	return 0;
 }
 
@@ -177,7 +177,7 @@ void mesh_rmc_free(struct ieee80211_sub_if_data *sdata)
 		return;
 
 	for (i = 0; i < RMC_BUCKETS; i++)
-		list_for_each_entry_safe(p, n, &rmc->bucket[i].list, list) {
+		list_for_each_entry_safe(p, n, &rmc->bucket[i], list) {
 			list_del(&p->list);
 			kmem_cache_free(rm_cache, p);
 		}
@@ -210,7 +210,7 @@ int mesh_rmc_check(u8 *sa, struct ieee80211s_hdr *mesh_hdr,
 	/* Don't care about endianness since only match matters */
 	memcpy(&seqnum, &mesh_hdr->seqnum, sizeof(mesh_hdr->seqnum));
 	idx = le32_to_cpu(mesh_hdr->seqnum) & rmc->idx_mask;
-	list_for_each_entry_safe(p, n, &rmc->bucket[idx].list, list) {
+	list_for_each_entry_safe(p, n, &rmc->bucket[idx], list) {
 		++entries;
 		if (time_after(jiffies, p->exp_time) ||
 				(entries == RMC_QUEUE_MAX_LEN)) {
@@ -229,7 +229,7 @@ int mesh_rmc_check(u8 *sa, struct ieee80211s_hdr *mesh_hdr,
 	p->seqnum = seqnum;
 	p->exp_time = jiffies + RMC_TIMEOUT;
 	memcpy(p->sa, sa, ETH_ALEN);
-	list_add(&p->list, &rmc->bucket[idx].list);
+	list_add(&p->list, &rmc->bucket[idx]);
 	return 0;
 }
 
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 7c9215f..84c28c6 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -184,7 +184,7 @@ struct rmc_entry {
 };
 
 struct mesh_rmc {
-	struct rmc_entry bucket[RMC_BUCKETS];
+	struct list_head bucket[RMC_BUCKETS];
 	u32 idx_mask;
 };
 
-- 
1.7.10.4

