Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f65.google.com ([209.85.192.65]:35162 "EHLO
	mail-qg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348AbcCSCLn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2016 22:11:43 -0400
Received: by mail-qg0-f65.google.com with SMTP id 51so2132780qgy.2
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2016 19:11:42 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 4/5] mac80211: mesh: reorder structure members
Date: Fri, 18 Mar 2016 22:11:31 -0400
Message-Id: <1458353492-8654-5-git-send-email-me@bobcopeland.com> (sfid-20160319_031156_849543_38D318F2)
In-Reply-To: <1458353492-8654-1-git-send-email-me@bobcopeland.com>
References: <1458353492-8654-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reduce padding waste in struct mesh_table and struct rmc_entry by
moving the smaller fields to the end.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 net/mac80211/mesh.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 46b540a25d9d..4a59c034cc6d 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -133,11 +133,10 @@ struct mesh_path {
  * @rhash: the rhashtable containing struct mesh_paths, keyed by dest addr
  */
 struct mesh_table {
-	atomic_t entries;		/* Up to MAX_MESH_NEIGHBOURS */
 	struct hlist_head known_gates;
 	spinlock_t gates_lock;
-
 	struct rhashtable rhead;
+	atomic_t entries;		/* Up to MAX_MESH_NEIGHBOURS */
 };
 
 /* Recent multicast cache */
@@ -159,8 +158,8 @@ struct mesh_table {
  */
 struct rmc_entry {
 	struct hlist_node list;
-	u32 seqnum;
 	unsigned long exp_time;
+	u32 seqnum;
 	u8 sa[ETH_ALEN];
 };
 
-- 
2.6.1

