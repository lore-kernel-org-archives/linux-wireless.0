Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40740 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090AbZEUWCa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 18:02:30 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1M7GLO-0006gk-M8
	for linux-wireless@vger.kernel.org; Fri, 22 May 2009 00:02:30 +0200
Message-Id: <20090521220104.755267733@sipsolutions.net>
References: <20090521215940.344214804@sipsolutions.net>
Date: Thu, 21 May 2009 23:59:41 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFT 1/4] net: introduce pre-up netdev notifier
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

--- wireless-testing.orig/include/linux/notifier.h	2009-05-21 21:17:29.000000000 +0200
+++ wireless-testing/include/linux/notifier.h	2009-05-21 21:17:44.000000000 +0200
@@ -198,6 +198,7 @@ static inline int notifier_to_errno(int 
 #define NETDEV_CHANGENAME	0x000A
 #define NETDEV_FEAT_CHANGE	0x000B
 #define NETDEV_BONDING_FAILOVER 0x000C
+#define NETDEV_PRE_UP		0x000D
 
 #define SYS_DOWN	0x0001	/* Notify of system down */
 #define SYS_RESTART	SYS_DOWN
--- wireless-testing.orig/net/core/dev.c	2009-05-21 21:17:48.000000000 +0200
+++ wireless-testing/net/core/dev.c	2009-05-21 21:18:51.000000000 +0200
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

-- 

