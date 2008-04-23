Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.246]:54203 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbYDWTut (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 15:50:49 -0400
Received: by an-out-0708.google.com with SMTP id d31so746758and.103
        for <linux-wireless@vger.kernel.org>; Wed, 23 Apr 2008 12:50:49 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Wed, 23 Apr 2008 12:15:29 -0700
Subject: [PATCH] mac80211: use 4-byte mesh sequence number
Message-ID: <480f9318.0b35640a.0a3f.ffffc3eb@mx.google.com> (sfid-20080423_215126_615548_B37D1180)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This follows the new 802.11s/D2.0 draft.

Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 include/linux/ieee80211.h  |    2 +-
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/mesh.c        |   17 +++++------------
 net/mac80211/mesh.h        |    2 +-
 4 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index f27d11a..c840bd1 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -113,7 +113,7 @@ struct ieee80211_hdr {
 struct ieee80211s_hdr {
 	u8 flags;
 	u8 ttl;
-	u8 seqnum[3];
+	__le32 seqnum;
 	u8 eaddr1[6];
 	u8 eaddr2[6];
 	u8 eaddr3[6];
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 8e53ce7..c7314bf 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -354,7 +354,7 @@ struct ieee80211_if_sta {
 	int preq_queue_len;
 	struct mesh_stats mshstats;
 	struct mesh_config mshcfg;
-	u8 mesh_seqnum[3];
+	u32 mesh_seqnum;
 	bool accepting_plinks;
 #endif
 	u16 aid;
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 594a335..f76bc26 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -8,6 +8,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <asm/unaligned.h>
 #include "ieee80211_i.h"
 #include "mesh.h"
 
@@ -167,8 +168,8 @@ int mesh_rmc_check(u8 *sa, struct ieee80211s_hdr *mesh_hdr,
 	struct rmc_entry *p, *n;
 
 	/* Don't care about endianness since only match matters */
-	memcpy(&seqnum, mesh_hdr->seqnum, sizeof(mesh_hdr->seqnum));
-	idx = mesh_hdr->seqnum[0] & rmc->idx_mask;
+	memcpy(&seqnum, &mesh_hdr->seqnum, sizeof(mesh_hdr->seqnum));
+	idx = le32_to_cpu(mesh_hdr->seqnum) & rmc->idx_mask;
 	list_for_each_entry_safe(p, n, &rmc->bucket[idx].list, list) {
 		++entries;
 		if (time_after(jiffies, p->exp_time) ||
@@ -393,16 +394,8 @@ int ieee80211_new_mesh_header(struct ieee80211s_hdr *meshhdr,
 {
 	meshhdr->flags = 0;
 	meshhdr->ttl = sdata->u.sta.mshcfg.dot11MeshTTL;
-
-	meshhdr->seqnum[0] = sdata->u.sta.mesh_seqnum[0]++;
-	meshhdr->seqnum[1] = sdata->u.sta.mesh_seqnum[1];
-	meshhdr->seqnum[2] = sdata->u.sta.mesh_seqnum[2];
-
-	if (sdata->u.sta.mesh_seqnum[0] == 0) {
-		sdata->u.sta.mesh_seqnum[1]++;
-		if (sdata->u.sta.mesh_seqnum[1] == 0)
-			sdata->u.sta.mesh_seqnum[2]++;
-	}
+	put_unaligned(cpu_to_le32(sdata->u.sta.mesh_seqnum), &meshhdr->seqnum);
+	sdata->u.sta.mesh_seqnum++;
 
 	return 5;
 }
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 742003d..9f8cb76 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -139,7 +139,7 @@ struct rmc_entry {
 
 struct mesh_rmc {
 	struct rmc_entry bucket[RMC_BUCKETS];
-	u8 idx_mask;
+	u32 idx_mask;
 };
 
 
-- 
1.5.4.3



