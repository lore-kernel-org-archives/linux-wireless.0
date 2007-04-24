Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33762 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993163AbXDZJlE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2007 05:41:04 -0400
Message-Id: <20070424180850.595757000@sipsolutions.net>
References: <20070424180732.371620000@sipsolutions.net>
Date: Tue, 24 Apr 2007 20:07:41 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	jt@hpl.hp.com
Subject: [PATCH 9/9] net_device: dont include wext bits if not required
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes the wext bits in struct net_device depend on
CONFIG_WIRELESS_EXT.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/linux/netdevice.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- net-2.6.22.orig/include/linux/netdevice.h	2007-04-24 19:36:59.248804911 +0200
+++ net-2.6.22/include/linux/netdevice.h	2007-04-24 19:37:31.608804911 +0200
@@ -352,12 +352,13 @@ struct net_device
 	struct net_device_stats* (*get_stats)(struct net_device *dev);
 	struct net_device_stats	stats;
 
+#ifdef CONFIG_WIRELESS_EXT
 	/* List of functions to handle Wireless Extensions (instead of ioctl).
 	 * See <net/iw_handler.h> for details. Jean II */
 	const struct iw_handler_def *	wireless_handlers;
 	/* Instance data managed by the core of Wireless Extensions. */
 	struct iw_public_data *	wireless_data;
-
+#endif
 	const struct ethtool_ops *ethtool_ops;
 
 	/*

--

