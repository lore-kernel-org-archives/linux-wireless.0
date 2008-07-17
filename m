Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51688
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758670AbYGQMRn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2008 08:17:43 -0400
Date: Thu, 17 Jul 2008 05:17:43 -0700 (PDT)
Message-Id: <20080717.051743.112915778.davem@davemloft.net> (sfid-20080717_141751_910124_CE484B46)
To: netdev@vger.kernel.org
CC: kaber@trash.net, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Subject: [PATCH 23/31]: pkt_sched: Kill qdisc_lock_tree usage in cls_route.c
From: David Miller <davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


It just wants the qdisc tree to be synchronized, so grabbing
qdisc_root_lock() is sufficient.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/sched/cls_route.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/sched/cls_route.c b/net/sched/cls_route.c
index 5a16ca2..481260a 100644
--- a/net/sched/cls_route.c
+++ b/net/sched/cls_route.c
@@ -73,11 +73,13 @@ static __inline__ int route4_fastmap_hash(u32 id, int iif)
 }
 
 static inline
-void route4_reset_fastmap(struct net_device *dev, struct route4_head *head, u32 id)
+void route4_reset_fastmap(struct Qdisc *q, struct route4_head *head, u32 id)
 {
-	qdisc_lock_tree(dev);
+	spinlock_t *root_lock = qdisc_root_lock(q);
+
+	spin_lock_bh(root_lock);
 	memset(head->fastmap, 0, sizeof(head->fastmap));
-	qdisc_unlock_tree(dev);
+	spin_unlock_bh(root_lock);
 }
 
 static inline void
@@ -302,7 +304,7 @@ static int route4_delete(struct tcf_proto *tp, unsigned long arg)
 			*fp = f->next;
 			tcf_tree_unlock(tp);
 
-			route4_reset_fastmap(qdisc_dev(tp->q), head, f->id);
+			route4_reset_fastmap(tp->q, head, f->id);
 			route4_delete_filter(tp, f);
 
 			/* Strip tree */
@@ -500,7 +502,7 @@ reinsert:
 	}
 	tcf_tree_unlock(tp);
 
-	route4_reset_fastmap(qdisc_dev(tp->q), head, f->id);
+	route4_reset_fastmap(tp->q, head, f->id);
 	*arg = (unsigned long)f;
 	return 0;
 
-- 
1.5.6.2.255.gbed62

