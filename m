Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f66.google.com ([209.85.192.66]:33481 "EHLO
	mail-qg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470AbcCSCLu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2016 22:11:50 -0400
Received: by mail-qg0-f66.google.com with SMTP id y89so8715941qge.0
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2016 19:11:49 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 2/5] mac80211: mesh: use hlist for rmc cache
Date: Fri, 18 Mar 2016 22:11:29 -0400
Message-Id: <1458353492-8654-3-git-send-email-me@bobcopeland.com> (sfid-20160319_031157_962544_03BEA0D6)
In-Reply-To: <1458353492-8654-1-git-send-email-me@bobcopeland.com>
References: <1458353492-8654-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The RMC cache has 256 list heads plus a u32, which puts it at the
unfortunate size of 4104 bytes with padding.  kmalloc() will then
round this up to the next power-of-two, so we wind up actually
using two pages here where most of the second is wasted.

Switch to hlist heads here to reduce the structure size down to
fit within a page.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 net/mac80211/mesh.c | 18 ++++++++++--------
 net/mac80211/mesh.h |  4 ++--
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index d0d8eeaa8129..1a2aaf461e98 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -174,22 +174,23 @@ int mesh_rmc_init(struct ieee80211_sub_if_data *sdata)
 		return -ENOMEM;
 	sdata->u.mesh.rmc->idx_mask = RMC_BUCKETS - 1;
 	for (i = 0; i < RMC_BUCKETS; i++)
-		INIT_LIST_HEAD(&sdata->u.mesh.rmc->bucket[i]);
+		INIT_HLIST_HEAD(&sdata->u.mesh.rmc->bucket[i]);
 	return 0;
 }
 
 void mesh_rmc_free(struct ieee80211_sub_if_data *sdata)
 {
 	struct mesh_rmc *rmc = sdata->u.mesh.rmc;
-	struct rmc_entry *p, *n;
+	struct rmc_entry *p;
+	struct hlist_node *n;
 	int i;
 
 	if (!sdata->u.mesh.rmc)
 		return;
 
 	for (i = 0; i < RMC_BUCKETS; i++) {
-		list_for_each_entry_safe(p, n, &rmc->bucket[i], list) {
-			list_del(&p->list);
+		hlist_for_each_entry_safe(p, n, &rmc->bucket[i], list) {
+			hlist_del(&p->list);
 			kmem_cache_free(rm_cache, p);
 		}
 	}
@@ -218,7 +219,8 @@ int mesh_rmc_check(struct ieee80211_sub_if_data *sdata,
 	u32 seqnum = 0;
 	int entries = 0;
 	u8 idx;
-	struct rmc_entry *p, *n;
+	struct rmc_entry *p;
+	struct hlist_node *n;
 
 	if (!rmc)
 		return -1;
@@ -226,11 +228,11 @@ int mesh_rmc_check(struct ieee80211_sub_if_data *sdata,
 	/* Don't care about endianness since only match matters */
 	memcpy(&seqnum, &mesh_hdr->seqnum, sizeof(mesh_hdr->seqnum));
 	idx = le32_to_cpu(mesh_hdr->seqnum) & rmc->idx_mask;
-	list_for_each_entry_safe(p, n, &rmc->bucket[idx], list) {
+	hlist_for_each_entry_safe(p, n, &rmc->bucket[idx], list) {
 		++entries;
 		if (time_after(jiffies, p->exp_time) ||
 		    entries == RMC_QUEUE_MAX_LEN) {
-			list_del(&p->list);
+			hlist_del(&p->list);
 			kmem_cache_free(rm_cache, p);
 			--entries;
 		} else if ((seqnum == p->seqnum) && ether_addr_equal(sa, p->sa))
@@ -244,7 +246,7 @@ int mesh_rmc_check(struct ieee80211_sub_if_data *sdata,
 	p->seqnum = seqnum;
 	p->exp_time = jiffies + RMC_TIMEOUT;
 	memcpy(p->sa, sa, ETH_ALEN);
-	list_add(&p->list, &rmc->bucket[idx]);
+	hlist_add_head(&p->list, &rmc->bucket[idx]);
 	return 0;
 }
 
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index e1415c952e9c..bc3f9a32b5a4 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -158,14 +158,14 @@ struct mesh_table {
  * that are found in the cache.
  */
 struct rmc_entry {
-	struct list_head list;
+	struct hlist_node list;
 	u32 seqnum;
 	unsigned long exp_time;
 	u8 sa[ETH_ALEN];
 };
 
 struct mesh_rmc {
-	struct list_head bucket[RMC_BUCKETS];
+	struct hlist_head bucket[RMC_BUCKETS];
 	u32 idx_mask;
 };
 
-- 
2.6.1

