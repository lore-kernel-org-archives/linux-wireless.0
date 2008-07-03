Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47433
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755392AbYGCHCT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2008 03:02:19 -0400
Date: Thu, 03 Jul 2008 00:02:18 -0700 (PDT)
Message-Id: <20080703.000218.65542674.davem@davemloft.net> (sfid-20080703_103139_990991_7F54363D)
To: netdev@vger.kernel.org
CC: vinay@linux.vnet.ibm.com, krkumar2@in.ibm.com, mchan@broadcom.com,
	Matheos.Worku@Sun.COM, linux-wireless@vger.kernel.org
Subject: [PATCH 02/39]: pkt_sched: Remove comment reference to old style TX
 locking.
From: David Miller <davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


We haven't had netdev->tbusy in many years :)

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/sched/sch_api.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index c40773c..365a84c 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -99,7 +99,7 @@ static int tclass_notify(struct sk_buff *oskb, struct nlmsghdr *n,
    ---requeue
 
    requeues once dequeued packet. It is used for non-standard or
-   just buggy devices, which can defer output even if dev->tbusy=0.
+   just buggy devices, which can defer output even if netif_queue_stopped()=0.
 
    ---reset
 
-- 
1.5.6

