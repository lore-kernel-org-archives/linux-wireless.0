Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sacred.ru ([62.205.161.221]:36894 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755913AbYEGPym (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2008 11:54:42 -0400
Message-ID: <4821D017.9050606@openvz.org> (sfid-20080507_175349_045593_D65BBDDD)
Date: Wed, 07 May 2008 19:51:51 +0400
From: Pavel Emelyanov <xemul@openvz.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org,
	Linux Netdev List <netdev@vger.kernel.org>
Subject: [PATCH 4/7][MAC80211]: Fix sleeping allocation under lock in mesh_path_node_copy.
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mesh_path_node_copy() can be called like this:
mesh_path_add
 `- write_lock(&pathtbl_resize_lock); /* ! */
 `- mesh_table_grow
     `- ->copy_node
           `- mesh_path_node_copy

thus, the GFP_KERNEL is not suitable here.

The acceptable fix, I suppose, is make this allocation GPF_ATOMIC -
the mpath_node being allocated is 4 pointers, i.e. this allocation
is small enough to survive even under a moderate memory pressure.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---
 net/mac80211/mesh_pathtbl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index fe1ceee..1154398 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -469,7 +469,7 @@ static int mesh_path_node_copy(struct hlist_node *p, struct mesh_table *newtbl)
 	struct mpath_node *node, *new_node;
 	u32 hash_idx;
 
-	new_node = kmalloc(sizeof(struct mpath_node), GFP_KERNEL);
+	new_node = kmalloc(sizeof(struct mpath_node), GFP_ATOMIC);
 	if (new_node == NULL)
 		return -ENOMEM;
 
-- 
1.5.3.4

