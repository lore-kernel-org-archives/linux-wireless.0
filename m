Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:4035 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444AbZAXEMg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 23:12:36 -0500
Date: Fri, 23 Jan 2009 23:12:29 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: [PATCH] mac80211: change workqueue back to non-freezeable
Message-ID: <20090124041229.GA13712@hash.localnet> (sfid-20090124_051242_523910_5511026E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[apologies for resend, forgot to cc wireless]

Commit 59959a6150c8af737898e83f727e824dbed7b0fa made the mac80211
workqueue freezeable to prevent us from doing any work after the 
driver went away.  This was fine before mac80211 had any suspend 
support.

However, now we want to flush this workqueue in suspend().  Because
the thread for a freezeable workqueue is stopped before the device
class suspend() is called, flush_workqueue() will hang in the
suspend-to-disk case.

Converting it back to a non-freezeable queue will keep suspend from
hanging.  Moreover, since we flush the workqueue under RTNL and
userspace is stopped, there won't be any new work in the workqueue
until after resume.  Thus we still don't have to worry about pinging
the AP without hardware.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 net/mac80211/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index a100793..a109c06 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -859,7 +859,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	mdev->set_multicast_list = ieee80211_master_set_multicast_list;
 
 	local->hw.workqueue =
-		create_freezeable_workqueue(wiphy_name(local->hw.wiphy));
+		create_singlethread_workqueue(wiphy_name(local->hw.wiphy));
 	if (!local->hw.workqueue) {
 		result = -ENOMEM;
 		goto fail_workqueue;
-- 
1.6.0.6

-- 
Bob Copeland %% www.bobcopeland.com

