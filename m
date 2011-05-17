Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50022 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932595Ab1EQXN6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 19:13:58 -0400
Received: by pzk9 with SMTP id 9so452429pzk.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2011 16:13:58 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH] mac80211: Don't sleep when growing the mesh path
Date: Tue, 17 May 2011 16:13:34 -0700
Message-Id: <1305674014-24136-1-git-send-email-javier@cozybit.com> (sfid-20110518_011402_689203_A938EACA)
In-Reply-To: <BANLkTikyymbnXHANmB3N0ecJWdkY9xCG=Q@mail.gmail.com>
References: <BANLkTikyymbnXHANmB3N0ecJWdkY9xCG=Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After commit 1928ecab620907a0953f811316d05f367f3f4dba (mac80211: fix and
simplify mesh locking) mesh table allocation is performed with the
pathtbl_resize_lock taken.  Under those conditions one should not sleep.
This patch makes the allocations GFP_ATOMIC to prevent that.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh_pathtbl.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 6abe25d..0d2faac 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -76,12 +76,12 @@ static struct mesh_table *mesh_table_alloc(int size_order)
 	int i;
 	struct mesh_table *newtbl;
 
-	newtbl = kmalloc(sizeof(struct mesh_table), GFP_KERNEL);
+	newtbl = kmalloc(sizeof(struct mesh_table), GFP_ATOMIC);
 	if (!newtbl)
 		return NULL;
 
 	newtbl->hash_buckets = kzalloc(sizeof(struct hlist_head) *
-			(1 << size_order), GFP_KERNEL);
+			(1 << size_order), GFP_ATOMIC);
 
 	if (!newtbl->hash_buckets) {
 		kfree(newtbl);
@@ -89,7 +89,7 @@ static struct mesh_table *mesh_table_alloc(int size_order)
 	}
 
 	newtbl->hashwlock = kmalloc(sizeof(spinlock_t) *
-			(1 << size_order), GFP_KERNEL);
+			(1 << size_order), GFP_ATOMIC);
 	if (!newtbl->hashwlock) {
 		kfree(newtbl->hash_buckets);
 		kfree(newtbl);
-- 
1.7.1

