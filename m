Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:46134 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbYGAL30 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 07:29:26 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] mac80211: remove useless tid assignment for management and control frames
Date: Tue,  1 Jul 2008 14:29:20 +0300
Message-Id: <1214911761-8291-1-git-send-email-tomas.winkler@intel.com> (sfid-20080701_132930_164996_B1D4BDBF)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes useless tid assignment for management and control frames

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/wme.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index f23b5a4..30d3b5b 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -210,7 +210,6 @@ static int wme_qdiscop_enqueue(struct sk_buff *skb, struct Qdisc* qd)
 			kfree_skb(skb);
 			err = NET_XMIT_DROP;
 	} else {
-		tid = skb->priority & QOS_CONTROL_TAG1D_MASK;
 		skb_set_queue_mapping(skb, queue);
 		qdisc = q->queues[queue];
 		err = qdisc->enqueue(skb, qdisc);
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

