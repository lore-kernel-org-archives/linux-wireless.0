Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14775 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144AbaJVJgp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 05:36:45 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: add stations in order to the station list
Date: Wed, 22 Oct 2014 12:32:16 +0300
Message-Id: <1413970336-5728-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141022_113650_343428_04223CAA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

During reconfig the station list is traversed in order and station are
added back to the driver. Make sure the stations are added to the driver
in the same order they were added to mac80211.

This has a real side effect - some drivers (iwlwifi) require TDLS
stations to be added only after the AP station for the same network.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/sta_info.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index de494df..2cd48ce 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -501,7 +501,7 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
 	/* make the station visible */
 	sta_info_hash_add(local, sta);
 
-	list_add_rcu(&sta->list, &local->sta_list);
+	list_add_tail_rcu(&sta->list, &local->sta_list);
 
 	/* notify driver */
 	err = sta_info_insert_drv_state(local, sdata, sta);
-- 
1.9.1

