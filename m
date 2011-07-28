Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tango.tkos.co.il ([62.219.50.35]:54774 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197Ab1G1Gl5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2011 02:41:57 -0400
From: Baruch Siach <baruch@tkos.co.il>
To: linux-wireless@vger.kernel.org
Cc: Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH] mac80211/mesh: make the preq queue lock consistent
Date: Thu, 28 Jul 2011 08:51:05 +0300
Message-Id: <52f0e75d7b2308f8ede85362ed96e6af71e39dd3.1311832184.git.baruch@tkos.co.il> (sfid-20110728_084207_631300_93471EAC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make mesh_preq_queue_lock locking consistent with mesh_queue_preq() using
spin_lock_bh().

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 net/mac80211/mesh_hwmp.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 2b18053..fc8cb1a 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -792,9 +792,9 @@ static void mesh_queue_preq(struct mesh_path *mpath, u8 flags)
 		return;
 	}
 
-	spin_lock(&ifmsh->mesh_preq_queue_lock);
+	spin_lock_bh(&ifmsh->mesh_preq_queue_lock);
 	if (ifmsh->preq_queue_len == MAX_PREQ_QUEUE_LEN) {
-		spin_unlock(&ifmsh->mesh_preq_queue_lock);
+		spin_unlock_bh(&ifmsh->mesh_preq_queue_lock);
 		kfree(preq_node);
 		if (printk_ratelimit())
 			mhwmp_dbg("PREQ node queue full\n");
@@ -806,7 +806,7 @@ static void mesh_queue_preq(struct mesh_path *mpath, u8 flags)
 
 	list_add_tail(&preq_node->list, &ifmsh->preq_queue.list);
 	++ifmsh->preq_queue_len;
-	spin_unlock(&ifmsh->mesh_preq_queue_lock);
+	spin_unlock_bh(&ifmsh->mesh_preq_queue_lock);
 
 	if (time_after(jiffies, ifmsh->last_preq + min_preq_int_jiff(sdata)))
 		ieee80211_queue_work(&sdata->local->hw, &sdata->work);
-- 
1.7.5.4

