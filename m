Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756676Ab3AHPjH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2013 10:39:07 -0500
Date: Tue, 8 Jan 2013 16:38:51 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>,
	Ben Greear <greearb@candelatech.com>,
	=?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
	linux-wireless@vger.kernel.org,
	Ben Hutchings <bhutchings@solarflare.com>,
	=?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirqus@gmail.com>
Subject: [PATCH v2] net: set default_ethtool_ops in register_netdevice
Message-ID: <20130108153850.GA10464@redhat.com> (sfid-20130108_163919_074822_A01C0731)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since:

commit 2c60db037034d27f8c636403355d52872da92f81
Author: Eric Dumazet <edumazet@google.com>
Date:   Sun Sep 16 09:17:26 2012 +0000

    net: provide a default dev->ethtool_ops

wireless core does not correctly assign ethtool_ops. In order to fix
the problem, move assignement of default_ethtool_ops to
register_netdevice(). This is safe because both register_netdevice()
and dev_ethtool() are protected by RTNL lock.

Patch is besed on hint of Michał Mirosław.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: stable@vger.kernel.org # 3.7+
---
v1 -> v2: change order of default_ethtool_ops initialization to avoid
the problem. Change the subject accordingly.

 net/core/dev.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/net/core/dev.c b/net/core/dev.c
index 515473e..3196820 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5710,6 +5710,8 @@ static int netif_alloc_netdev_queues(struct net_device *dev)
 	return 0;
 }
 
+static const struct ethtool_ops default_ethtool_ops;
+
 /**
  *	register_netdevice	- register a network device
  *	@dev: device to register
@@ -5830,6 +5832,8 @@ int register_netdevice(struct net_device *dev)
 	    dev->rtnl_link_state == RTNL_LINK_INITIALIZED)
 		rtmsg_ifinfo(RTM_NEWLINK, dev, ~0U);
 
+	if (!dev->ethtool_ops)
+		dev->ethtool_ops = &default_ethtool_ops;
 out:
 	return ret;
 
@@ -6119,8 +6123,6 @@ struct netdev_queue *dev_ingress_queue_create(struct net_device *dev)
 	return queue;
 }
 
-static const struct ethtool_ops default_ethtool_ops;
-
 /**
  *	alloc_netdev_mqs - allocate network device
  *	@sizeof_priv:	size of private data to allocate space for
@@ -6208,8 +6210,6 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 
 	strcpy(dev->name, name);
 	dev->group = INIT_NETDEV_GROUP;
-	if (!dev->ethtool_ops)
-		dev->ethtool_ops = &default_ethtool_ops;
 	return dev;
 
 free_all:
-- 
1.7.1

