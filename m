Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51777 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934198AbYEBWoR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 May 2008 18:44:17 -0400
Subject: [PATCH v2] mac80211: fix wme code
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1209767749.3608.23.camel@johannes.berg> (sfid-20080503_003536_334347_3B50118C)
References: <1209767749.3608.23.camel@johannes.berg>
	 (sfid-20080503_003536_334347_3B50118C)
Content-Type: text/plain
Date: Sat, 03 May 2008 00:44:09 +0200
Message-Id: <1209768249.3608.25.camel@johannes.berg> (sfid-20080503_004354_206661_FC39EF9A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In commit 31ccc476b77234f6afb3 (mac80211: QoS related cleanups) I
accidentally changed a variable from int to u16 causing a warning
that a comparison for < 0 was always false. John thought this was
a missing deletion of code and removed the warning by deleting the
never executed branch of code in commit 13e5f0888caddf7a020dcd918
(wireless: fix warning introduced by "mac80211: QoS related cleanups")
but the problem really was my mistake of using a u16 variable for
the queue variable when that variable can also contain an error
code. This patch restores the original code and variable type.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
No functional change, just give it a subject...

 net/mac80211/wme.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

--- everything.orig/net/mac80211/wme.c	2008-05-03 00:29:07.000000000 +0200
+++ everything/net/mac80211/wme.c	2008-05-03 00:32:01.000000000 +0200
@@ -155,8 +155,7 @@ static int wme_qdiscop_enqueue(struct sk
 	unsigned short fc = le16_to_cpu(hdr->frame_control);
 	struct Qdisc *qdisc;
 	struct sta_info *sta;
-	int err;
-	u16 queue;
+	int err, queue;
 	u8 tid;
 
 	if (pkt_data->flags & IEEE80211_TXPD_REQUEUE) {
@@ -216,15 +215,20 @@ static int wme_qdiscop_enqueue(struct sk
 		rcu_read_unlock();
 	}
 
-	tid = skb->priority & QOS_CONTROL_TAG1D_MASK;
-	pkt_data->queue = (unsigned int) queue;
-	qdisc = q->queues[queue];
-	err = qdisc->enqueue(skb, qdisc);
-	if (err == NET_XMIT_SUCCESS) {
-		qd->q.qlen++;
-		qd->bstats.bytes += skb->len;
-		qd->bstats.packets++;
-		return NET_XMIT_SUCCESS;
+	if (unlikely(queue < 0)) {
+			kfree_skb(skb);
+			err = NET_XMIT_DROP;
+	} else {
+		tid = skb->priority & QOS_CONTROL_TAG1D_MASK;
+		pkt_data->queue = (unsigned int) queue;
+		qdisc = q->queues[queue];
+		err = qdisc->enqueue(skb, qdisc);
+		if (err == NET_XMIT_SUCCESS) {
+			qd->q.qlen++;
+			qd->bstats.bytes += skb->len;
+			qd->bstats.packets++;
+			return NET_XMIT_SUCCESS;
+		}
 	}
 	qd->qstats.drops++;
 	return err;


