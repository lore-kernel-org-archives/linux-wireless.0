Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47669 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab2LEIvt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 03:51:49 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: cancel work instead of waiting for it to do nothing
Date: Wed,  5 Dec 2012 09:52:11 +0100
Message-Id: <1354697531-11174-1-git-send-email-johannes@sipsolutions.net> (sfid-20121205_095152_764242_8CC65446)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the sdata work is pending while the interface is stopped,
we currently flush it. If it's not running this means waiting
for it to run, which could take a while if the workqueue is
backlogged. However, the work exits right away if it starts
to run while the interface is already stopping. There's no
point in waiting for that, so use cancel_work_sync() instead.

Reported-by: Ben Greear <greearb@candelatech.com>
Tested-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 40c36d5..09a80b5 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -862,7 +862,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		rcu_assign_pointer(local->p2p_sdata, NULL);
 		/* fall through */
 	default:
-		flush_work(&sdata->work);
+		cancel_work_sync(&sdata->work);
 		/*
 		 * When we get here, the interface is marked down.
 		 * Call rcu_barrier() to wait both for the RX path
-- 
1.8.0

