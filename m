Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sacred.ru ([62.205.161.221]:37394 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755913AbYEGP47 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2008 11:56:59 -0400
Message-ID: <4821D09C.2010100@openvz.org> (sfid-20080507_175609_334079_41967C00)
Date: Wed, 07 May 2008 19:54:04 +0400
From: Pavel Emelyanov <xemul@openvz.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org,
	Linux Netdev List <netdev@vger.kernel.org>
Subject: [PATCH 5/7][MAC80211]: Do not report false error from mesh_path_add.
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case the hash grow failed, it is not fair to return error -
the new node _was_ _actually_ added in this case.

Besides, after my previous patch, this grow is more likely
to fail on large hashes.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---
 net/mac80211/mesh_pathtbl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 1154398..947b13b 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -206,7 +206,7 @@ int mesh_path_add(u8 *dst, struct net_device *dev)
 		newtbl = mesh_table_grow(mesh_paths);
 		if (!newtbl) {
 			write_unlock(&pathtbl_resize_lock);
-			return -ENOMEM;
+			return 0;
 		}
 		rcu_assign_pointer(mesh_paths, newtbl);
 		write_unlock(&pathtbl_resize_lock);
-- 
1.5.3.4

