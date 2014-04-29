Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44979 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757760AbaD2P7v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Apr 2014 11:59:51 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] mac80211: remove BUG_ON usage
Date: Tue, 29 Apr 2014 17:59:40 +0200
Message-Id: <1398787180-6494-2-git-send-email-johannes@sipsolutions.net> (sfid-20140429_175955_616738_BC504869)
In-Reply-To: <1398787180-6494-1-git-send-email-johannes@sipsolutions.net>
References: <1398787180-6494-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

These BUG_ON statements should never trigger, but in the unlikely
event that somebody does manage don't stop everything but simply
exit the code path with an error.

Leave the one BUG_ON where changing it would result in a NULL
pointer dereference.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/key.c          | 7 ++++---
 net/mac80211/mesh_pathtbl.c | 6 ++++--
 net/mac80211/mesh_sync.c    | 2 +-
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 6ff65a1ebaa9..16d97f044a20 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -325,7 +325,8 @@ ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 	struct ieee80211_key *key;
 	int i, j, err;
 
-	BUG_ON(idx < 0 || idx >= NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS);
+	if (WARN_ON(idx < 0 || idx >= NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS))
+		return ERR_PTR(-EINVAL);
 
 	key = kzalloc(sizeof(struct ieee80211_key) + key_len, GFP_KERNEL);
 	if (!key)
@@ -481,8 +482,8 @@ int ieee80211_key_link(struct ieee80211_key *key,
 	int idx, ret;
 	bool pairwise;
 
-	BUG_ON(!sdata);
-	BUG_ON(!key);
+	if (WARN_ON(!sdata || !key))
+		return -EINVAL;
 
 	pairwise = key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE;
 	idx = key->conf.keyidx;
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 7d050ed6fe5a..cf032a8db9d7 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -287,8 +287,10 @@ static void mesh_path_move_to_queue(struct mesh_path *gate_mpath,
 	struct sk_buff_head failq;
 	unsigned long flags;
 
-	BUG_ON(gate_mpath == from_mpath);
-	BUG_ON(!gate_mpath->next_hop);
+	if (WARN_ON(gate_mpath == from_mpath))
+		return;
+	if (WARN_ON(!gate_mpath->next_hop))
+		return;
 
 	__skb_queue_head_init(&failq);
 
diff --git a/net/mac80211/mesh_sync.c b/net/mac80211/mesh_sync.c
index 2bc5dc25d5ad..09625d6205c3 100644
--- a/net/mac80211/mesh_sync.c
+++ b/net/mac80211/mesh_sync.c
@@ -171,7 +171,7 @@ static void mesh_sync_offset_adjust_tbtt(struct ieee80211_sub_if_data *sdata,
 	u8 cap;
 
 	WARN_ON(ifmsh->mesh_sp_id != IEEE80211_SYNC_METHOD_NEIGHBOR_OFFSET);
-	BUG_ON(!rcu_read_lock_held());
+	WARN_ON(!rcu_read_lock_held());
 	cap = beacon->meshconf->meshconf_cap;
 
 	spin_lock_bh(&ifmsh->sync_offset_lock);
-- 
1.9.0

