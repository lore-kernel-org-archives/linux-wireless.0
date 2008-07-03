Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47515
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757200AbYGCHDj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2008 03:03:39 -0400
Date: Thu, 03 Jul 2008 00:03:38 -0700 (PDT)
Message-Id: <20080703.000338.01412664.davem@davemloft.net> (sfid-20080703_103230_153819_17082F19)
To: netdev@vger.kernel.org
CC: vinay@linux.vnet.ibm.com, krkumar2@in.ibm.com, mchan@broadcom.com,
	Matheos.Worku@Sun.COM, linux-wireless@vger.kernel.org
Subject: [PATCH 12/39]: pkt_sched: Add qdisc_reset_all_tx().
From: David Miller <davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Isolate callers that want to simply reset all the TX
qdiscs from the details of TX queues.

Use this in the ISDN code.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/isdn/i4l/isdn_net.c |    2 +-
 include/net/sch_generic.h   |    6 ++++++
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/i4l/isdn_net.c b/drivers/isdn/i4l/isdn_net.c
index 457bbd1..bb904a0 100644
--- a/drivers/isdn/i4l/isdn_net.c
+++ b/drivers/isdn/i4l/isdn_net.c
@@ -287,7 +287,7 @@ isdn_net_unbind_channel(isdn_net_local * lp)
 		   BEWARE! This chunk of code cannot be called from hardware
 		   interrupt handler. I hope it is true. --ANK
 		 */
-		qdisc_reset(lp->netdev->dev->tx_queue.qdisc);
+		qdisc_reset_all_tx(lp->netdev->dev);
 	}
 	lp->dialstate = 0;
 	dev->rx_netdev[isdn_dc2minor(lp->isdn_device, lp->isdn_channel)] = NULL;
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 6bf63d9..a71994b 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -185,6 +185,12 @@ extern struct Qdisc *qdisc_create_dflt(struct net_device *dev,
 extern void tcf_destroy(struct tcf_proto *tp);
 extern void tcf_destroy_chain(struct tcf_proto *fl);
 
+/* Reset all TX qdiscs of a device.  */
+static inline void qdisc_reset_all_tx(struct net_device *dev)
+{
+	qdisc_reset(dev->tx_queue.qdisc);
+}
+
 static inline int __qdisc_enqueue_tail(struct sk_buff *skb, struct Qdisc *sch,
 				       struct sk_buff_head *list)
 {
-- 
1.5.6

