Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:7939 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751657AbcLZOT2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Dec 2016 09:19:28 -0500
From: Ilan Peer <ilan.peer@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, masashi.honma@gmail.com,
        Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH] mac80211: Fix addition of mesh configuration element
Date: Mon, 26 Dec 2016 18:17:36 +0200
Message-Id: <1482769056-28577-1-git-send-email-ilan.peer@intel.com> (sfid-20161226_151931_342648_794604E1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The code was setting the capabilities byte to zero,
after it was already properly set previously. Fix it.

The bug was found while debugging hwsim mesh tests failures
that happened in commit 76f43b4 (mac80211: Remove invalid flag
operations in mesh TSF synchronization).

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
---
 net/mac80211/mesh.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index cc2a63b..9c23172 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -279,8 +279,6 @@ int mesh_add_meshconf_ie(struct ieee80211_sub_if_data *sdata,
 	/* Mesh PS mode. See IEEE802.11-2012 8.4.2.100.8 */
 	*pos |= ifmsh->ps_peers_deep_sleep ?
 			IEEE80211_MESHCONF_CAPAB_POWER_SAVE_LEVEL : 0x00;
-	*pos++ = 0x00;
-
 	return 0;
 }
 
-- 
1.9.1
