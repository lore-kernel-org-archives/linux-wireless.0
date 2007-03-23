Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:49002 "EHLO silver.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934317AbXCWUno (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 16:43:44 -0400
From: Jiri Benc <jbenc@suse.cz>
To: "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20070323214400.642621638.midnight@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 17/19] mac80211: Properly kill tasklets before shutdown
Message-Id: <20070323204500.356AC48590@silver.suse.cz>
Date: Fri, 23 Mar 2007 21:45:00 +0100 (CET)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Buesch <mb@bu3sch.de>

We need to do tasklet_kill() on any tasklet on unregister
to make sure the tasklet is not running _and_ scheduled anymore.
(tasklet_disable() only ensures it's not running anymore).

This fixes the tasklet related crash that was reported some time ago.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Jiri Benc <jbenc@suse.cz>

---

 net/mac80211/ieee80211.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

baf56723a69d16311ad09db5ecee1f3e4c4d7ca1
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index fccb0fe..fb2ce3d 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -4728,8 +4728,8 @@ void ieee80211_unregister_hw(struct ieee
 	struct ieee80211_sub_if_data *sdata, *tmp;
 	int i;
 
-	tasklet_disable(&local->tasklet);
-	/* TODO: skb_queue should be empty here, no need to do anything? */
+	tasklet_kill(&local->tx_pending_tasklet);
+	tasklet_kill(&local->tasklet);
 
 	rtnl_lock();
 	local->reg_state = IEEE80211_DEV_UNREGISTERED;
-- 
1.3.0

