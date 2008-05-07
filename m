Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sacred.ru ([62.205.161.221]:46581 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752660AbYEGPrL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2008 11:47:11 -0400
Message-ID: <4821CE54.9000401@openvz.org> (sfid-20080507_174621_508311_97499CA1)
Date: Wed, 07 May 2008 19:44:20 +0400
From: Pavel Emelyanov <xemul@openvz.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org,
	Linux Netdev List <netdev@vger.kernel.org>
Subject: [PATCH 1/7][MAC8021]: Fix one more call to synchronize_rcu in atomic
 context.
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(This set applies OK without the previous one of 4 patches,
 but with some fuzz in the 7th one)


The mesh_path_node_free() does so under hashwlock.

But, this one is called
1. from mesh_path_add() after an old hash is hidden and
   synchronize_rcu() is calld
2. mesh_pathtbl_unregister(), when the module is being
   unloaded and no devices exist to mess with this hash.

So, it seems to me, that simply removing the call is OK.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---
 net/mac80211/mesh_pathtbl.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 7097ef9..0b6c4bf 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -458,7 +458,6 @@ static void mesh_path_node_free(struct hlist_node *p, bool free_leafs)
 	struct mpath_node *node = hlist_entry(p, struct mpath_node, list);
 	mpath = node->mpath;
 	hlist_del_rcu(p);
-	synchronize_rcu();
 	if (free_leafs)
 		kfree(mpath);
 	kfree(node);
-- 
1.5.3.4

