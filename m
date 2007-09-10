Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39151 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756814AbXIJLxm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2007 07:53:42 -0400
Subject: [PATCH] fix sparse warning
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 10 Sep 2007 13:55:08 +0200
Message-Id: <1189425308.4506.71.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wme.c triggers a sparse warning; it wasn't noticed before because until
recently ARRAY_SIZE triggered a sparse error.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/wme.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-dev.orig/net/mac80211/wme.c	2007-09-10 13:34:51.347219618 +0200
+++ wireless-dev/net/mac80211/wme.c	2007-09-10 13:34:55.397214627 +0200
@@ -386,7 +386,7 @@ static int wme_qdiscop_init(struct Qdisc
 		skb_queue_head_init(&q->requeued[i]);
 		q->queues[i] = qdisc_create_dflt(qd->dev, &pfifo_qdisc_ops,
 						 qd->handle);
-		if (q->queues[i] == 0) {
+		if (!q->queues[i]) {
 			q->queues[i] = &noop_qdisc;
 			printk(KERN_ERR "%s child qdisc %i creation failed", dev->name, i);
 		}


