Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sacred.ru ([62.205.161.221]:60463 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757324AbYEFOy1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2008 10:54:27 -0400
Message-ID: <48207073.6010600@openvz.org> (sfid-20080506_165351_957877_EFA66241)
Date: Tue, 06 May 2008 18:51:31 +0400
From: Pavel Emelyanov <xemul@openvz.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
CC: David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
	Linux Netdev List <netdev@vger.kernel.org>
Subject: [PATCH 3/4][MAC80211]: Fix potential scheduling while atomic in mesh_path_add.
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Calling synchronize_rcu() under write-lock-ed pathtbl_resize_lock may
result in this warning (and other side effects).

It looks safe just dropping this lock before calling synchronize_rcu.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---
 net/mac80211/mesh_pathtbl.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 1d2d051..99c2d36 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -220,9 +220,10 @@ endadd:
 			return -ENOMEM;
 		}
 		rcu_assign_pointer(mesh_paths, newtbl);
+		write_unlock(&pathtbl_resize_lock);
+
 		synchronize_rcu();
 		mesh_table_free(oldtbl, false);
-		write_unlock(&pathtbl_resize_lock);
 	}
 endadd2:
 	return err;
-- 
1.5.3.4

