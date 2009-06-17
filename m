Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34851 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbZFQSYt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 14:24:49 -0400
Subject: [PATCH] wireless extensions: play with netns
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Eric W. Biederman" <ebiederm@aristanetworks.com>,
	Alexey Dobriyan <adobriyan@gmail.com>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 20:24:18 +0200
Message-Id: <1245263058.31588.38.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes wireless extensions netns aware.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Is this ok, or is this racy? I guess what I'm asking is -- will
for_each_net() stop iterating over a netns that is going away before the
pernet exit op is called? If yes, this should be fine.

 include/net/net_namespace.h |    3 +++
 net/wireless/wext.c         |   30 ++++++++++++++++++++++--------
 2 files changed, 25 insertions(+), 8 deletions(-)

--- wireless-testing.orig/include/net/net_namespace.h	2009-06-17 20:20:47.000000000 +0200
+++ wireless-testing/include/net/net_namespace.h	2009-06-17 20:20:51.000000000 +0200
@@ -78,6 +78,9 @@ struct net {
 #ifdef CONFIG_XFRM
 	struct netns_xfrm	xfrm;
 #endif
+#ifdef CONFIG_WIRELESS_EXT
+	struct sk_buff_head	wext_nlevents;
+#endif
 	struct net_generic	*gen;
 };
 
--- wireless-testing.orig/net/wireless/wext.c	2009-06-17 20:20:47.000000000 +0200
+++ wireless-testing/net/wireless/wext.c	2009-06-17 20:20:51.000000000 +0200
@@ -1273,11 +1273,25 @@ int compat_wext_handle_ioctl(struct net 
  * Jean II
  */
 
-static struct sk_buff_head wireless_nlevent_queue;
+static int __net_init wext_pernet_init(struct net *net)
+{
+	skb_queue_head_init(&net->wext_nlevents);
+	return 0;
+}
+
+static void __net_exit wext_pernet_exit(struct net *net)
+{
+	skb_queue_purge(&net->wext_nlevents);
+}
+
+static struct pernet_operations wext_pernet_ops = {
+	.init = wext_pernet_init,
+	.exit = wext_pernet_exit,
+};
 
 static int __init wireless_nlevent_init(void)
 {
-	skb_queue_head_init(&wireless_nlevent_queue);
+	return register_pernet_subsys(&wext_pernet_ops);
 	return 0;
 }
 
@@ -1286,9 +1300,12 @@ subsys_initcall(wireless_nlevent_init);
 static void wireless_nlevent_process(unsigned long data)
 {
 	struct sk_buff *skb;
+	struct net *net;
 
-	while ((skb = skb_dequeue(&wireless_nlevent_queue)))
-		rtnl_notify(skb, &init_net, 0, RTNLGRP_LINK, NULL, GFP_ATOMIC);
+	for_each_net(net)
+		while ((skb = skb_dequeue(&net->wext_nlevents)))
+			rtnl_notify(skb, net, 0, RTNLGRP_LINK, NULL,
+				    GFP_ATOMIC);
 }
 
 static DECLARE_TASKLET(wireless_nlevent_tasklet, wireless_nlevent_process, 0);
@@ -1341,9 +1358,6 @@ static void rtmsg_iwinfo(struct net_devi
 	struct sk_buff *skb;
 	int err;
 
-	if (!net_eq(dev_net(dev), &init_net))
-		return;
-
 	skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
 	if (!skb)
 		return;
@@ -1356,7 +1370,7 @@ static void rtmsg_iwinfo(struct net_devi
 	}
 
 	NETLINK_CB(skb).dst_group = RTNLGRP_LINK;
-	skb_queue_tail(&wireless_nlevent_queue, skb);
+	skb_queue_tail(&dev_net(dev)->wext_nlevents, skb);
 	tasklet_schedule(&wireless_nlevent_tasklet);
 }
 


