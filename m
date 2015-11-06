Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45213 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032984AbbKFKav (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 05:30:51 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Bob Copeland <me@bobcopeland.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: mesh: print MAC address instead of pointer
Date: Fri,  6 Nov 2015 11:30:46 +0100
Message-Id: <1446805846-5210-1-git-send-email-johannes@sipsolutions.net> (sfid-20151106_113054_589294_3FBDA105)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no point in printing the mpath pointer since it can't
be used for anything - print the MAC address instead (like in
the forwarding case.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mesh_pathtbl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index b890e225a8f1..778fdfc7f14a 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -968,8 +968,8 @@ int mesh_path_send_to_gates(struct mesh_path *mpath)
 			copy = true;
 		} else {
 			mpath_dbg(sdata,
-				  "Not forwarding %p (flags %#x)\n",
-				  gate->mpath, gate->mpath->flags);
+				  "Not forwarding to %pM (flags %#x)\n",
+				  gate->mpath->dst, gate->mpath->flags);
 		}
 	}
 
-- 
2.6.2

