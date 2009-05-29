Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50589 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbZE2Xjz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2009 19:39:55 -0400
Subject: [PATCH] net: introduce pre-up netdev notifier
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 30 May 2009 01:39:53 +0200
Message-Id: <1243640394.13863.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

NETDEV_UP is called after the device is set UP, but sometimes
it is useful to be able to veto the device UP. Introduce a
new NETDEV_PRE_UP notifier that can be used for exactly this.
The first use case will be cfg80211 denying interfaces to be
set UP if the device is known to be rfkill'ed.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
John, please take this patch via your tree, I asked Dave and
he's cool with that.

 include/linux/notifier.h |    1 +
 net/core/dev.c           |    7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

--- wireless-testing.orig/include/linux/notifier.h	2009-05-29 10:28:02.000000000 +0200
+++ wireless-testing/include/linux/notifier.h	2009-05-30 01:38:44.000000000 +0200
@@ -198,6 +198,7 @@ static inline int notifier_to_errno(int 
 #define NETDEV_CHANGENAME	0x000A
 #define NETDEV_FEAT_CHANGE	0x000B
 #define NETDEV_BONDING_FAILOVER 0x000C
+#define NETDEV_PRE_UP		0x000D
 
 #define SYS_DOWN	0x0001	/* Notify of system down */
 #define SYS_RESTART	SYS_DOWN
--- wireless-testing.orig/net/core/dev.c	2009-05-29 10:28:02.000000000 +0200
+++ wireless-testing/net/core/dev.c	2009-05-30 01:38:44.000000000 +0200
@@ -1047,7 +1047,7 @@ void dev_load(struct net *net, const cha
 int dev_open(struct net_device *dev)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
-	int ret = 0;
+	int ret;
 
 	ASSERT_RTNL();
 
@@ -1064,6 +1064,11 @@ int dev_open(struct net_device *dev)
 	if (!netif_device_present(dev))
 		return -ENODEV;
 
+	ret = call_netdevice_notifiers(NETDEV_PRE_UP, dev);
+	ret = notifier_to_errno(ret);
+	if (ret)
+		return ret;
+
 	/*
 	 *	Call device private open method
 	 */


