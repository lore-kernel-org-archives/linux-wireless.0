Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51697
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758810AbYGQMSB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2008 08:18:01 -0400
Date: Thu, 17 Jul 2008 05:18:00 -0700 (PDT)
Message-Id: <20080717.051800.100673230.davem@davemloft.net> (sfid-20080717_141807_402004_AF976035)
To: netdev@vger.kernel.org
CC: kaber@trash.net, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Subject: [PATCH 26/31]: pkt_sched: Rework {sch,tbf}_tree_lock().
From: David Miller <davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Make sch_tree_lock() lock the qdisc's root.  All of the
users hold the RTNL semaphore and the root qdisc is not
changing.

Implement tbf_tree_{lock,unlock}() simply in terms of
sch_tree_{lock,unlock}().

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 include/net/sch_generic.h |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 3cc4b5c..60e1e9f 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -183,10 +183,18 @@ static inline struct net_device *qdisc_dev(struct Qdisc *qdisc)
 extern void qdisc_lock_tree(struct net_device *dev);
 extern void qdisc_unlock_tree(struct net_device *dev);
 
-#define sch_tree_lock(q)	qdisc_lock_tree(qdisc_dev(q))
-#define sch_tree_unlock(q)	qdisc_unlock_tree(qdisc_dev(q))
-#define tcf_tree_lock(tp)	qdisc_lock_tree(qdisc_dev((tp)->q))
-#define tcf_tree_unlock(tp)	qdisc_unlock_tree(qdisc_dev((tp)->q))
+static inline void sch_tree_lock(struct Qdisc *q)
+{
+	spin_lock_bh(qdisc_root_lock(q));
+}
+
+static inline void sch_tree_unlock(struct Qdisc *q)
+{
+	spin_unlock_bh(qdisc_root_lock(q));
+}
+
+#define tcf_tree_lock(tp)	sch_tree_lock((tp)->q)
+#define tcf_tree_unlock(tp)	sch_tree_unlock((tp)->q)
 
 extern struct Qdisc noop_qdisc;
 extern struct Qdisc_ops noop_qdisc_ops;
-- 
1.5.6.2.255.gbed62

