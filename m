Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47877 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbZFQXmM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 19:42:12 -0400
Subject: Re: [PATCH] wireless extensions: play with netns
From: Johannes Berg <johannes@sipsolutions.net>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: John Linville <linville@tuxdriver.com>,
	Netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Eric W. Biederman" <ebiederm@aristanetworks.com>,
	Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <m1r5xitpdh.fsf@fess.ebiederm.org>
References: <1245263058.31588.38.camel@johannes.local>
	 <m1y6rqwpur.fsf@fess.ebiederm.org>
	 <1245276899.31588.57.camel@johannes.local>
	 <m1r5xitpdh.fsf@fess.ebiederm.org>
Content-Type: text/plain
Date: Thu, 18 Jun 2009 01:41:38 +0200
Message-Id: <1245282099.31588.69.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-06-17 at 16:24 -0700, Eric W. Biederman wrote:

> > So it looks like I can also use rcu_read_lock(), but there's no
> > for_each_net_rcu(), should there be?
> 
> I'm not using rcu safe list manipulation.  What makes it look like
> rcu_read_lock() is safe?

Indeed. I was looking at rcu_barrier() only. How about the patch below?

johannes

Subject: net: make namespace iteration possible under RCU

We already call rcu_barrier(), so all we need to take
care of is using proper RCU list add/del primitives.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/net_namespace.h |    3 +++
 net/core/net_namespace.c    |    7 ++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

--- wireless-testing.orig/include/net/net_namespace.h	2009-06-18 01:36:26.000000000 +0200
+++ wireless-testing/include/net/net_namespace.h	2009-06-18 01:39:35.000000000 +0200
@@ -211,6 +211,9 @@ static inline struct net *read_pnet(stru
 #define for_each_net(VAR)				\
 	list_for_each_entry(VAR, &net_namespace_list, list)
 
+#define for_each_net_rcu(VAR)				\
+	list_for_each_entry_rcu(VAR, &net_namespace_list, list)
+
 #ifdef CONFIG_NET_NS
 #define __net_init
 #define __net_exit
--- wireless-testing.orig/net/core/net_namespace.c	2009-06-18 01:36:39.000000000 +0200
+++ wireless-testing/net/core/net_namespace.c	2009-06-18 01:38:36.000000000 +0200
@@ -6,6 +6,7 @@
 #include <linux/delay.h>
 #include <linux/sched.h>
 #include <linux/idr.h>
+#include <linux/rculist.h>
 #include <net/net_namespace.h>
 #include <net/netns/generic.h>
 
@@ -134,7 +135,7 @@ struct net *copy_net_ns(unsigned long fl
 	err = setup_net(new_net);
 	if (!err) {
 		rtnl_lock();
-		list_add_tail(&new_net->list, &net_namespace_list);
+		list_add_tail_rcu(&new_net->list, &net_namespace_list);
 		rtnl_unlock();
 	}
 	mutex_unlock(&net_mutex);
@@ -163,7 +164,7 @@ static void cleanup_net(struct work_stru
 
 	/* Don't let anyone else find us. */
 	rtnl_lock();
-	list_del(&net->list);
+	list_del_rcu(&net->list);
 	rtnl_unlock();
 
 	/* Run all of the network namespace exit methods */
@@ -227,7 +228,7 @@ static int __init net_ns_init(void)
 	err = setup_net(&init_net);
 
 	rtnl_lock();
-	list_add_tail(&init_net.list, &net_namespace_list);
+	list_add_tail_rcu(&init_net.list, &net_namespace_list);
 	rtnl_unlock();
 
 	mutex_unlock(&net_mutex);


