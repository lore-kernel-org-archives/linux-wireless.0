Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:43297 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503Ab2HAXFI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 19:05:08 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat-wireless: add patch to make b44 work with < 2.6.36
Date: Thu,  2 Aug 2012 01:04:37 +0200
Message-Id: <1343862277-26004-1-git-send-email-hauke@hauke-m.de> (sfid-20120802_010513_748445_4E66D017)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following commit made b44 use 64 bit stats which are not supported
by kernel version < 2.6.36.

commit eeda8585522bcc173f91d6254dfa63e871087c54
Author: Kevin Groeneveld <kgroeneveld@gmail.com>
Date:   Tue Jul 17 17:46:01 2012 +0000

    b44: add 64 bit stats

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/64-b44-32bit-stats.patch |   54 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)
 create mode 100644 patches/64-b44-32bit-stats.patch

diff --git a/patches/64-b44-32bit-stats.patch b/patches/64-b44-32bit-stats.patch
new file mode 100644
index 0000000..b3138f8
--- /dev/null
+++ b/patches/64-b44-32bit-stats.patch
@@ -0,0 +1,54 @@
+This patch requires a manual backport:
+
+commit eeda8585522bcc173f91d6254dfa63e871087c54
+Author: Kevin Groeneveld <kgroeneveld@gmail.com>
+Date:   Tue Jul 17 17:46:01 2012 +0000
+
+    b44: add 64 bit stats
+    
+    Add support for 64 bit stats to Broadcom b44 ethernet driver.
+    
+    Signed-off-by: Kevin Groeneveld <kgroeneveld@gmail.com>
+    Signed-off-by: Eric Dumazet <edumazet@google.com>
+    Signed-off-by: David S. Miller <davem@davemloft.net>
+
+--- a/drivers/net/ethernet/broadcom/b44.c
++++ b/drivers/net/ethernet/broadcom/b44.c
+@@ -31,6 +31,7 @@
+ #include <linux/dma-mapping.h>
+ #include <linux/ssb/ssb.h>
+ #include <linux/slab.h>
++#include <linux/u64_stats_sync.h>
+ 
+ #include <asm/uaccess.h>
+ #include <asm/io.h>
+@@ -1641,10 +1642,17 @@ static int b44_close(struct net_device *
+ 	return 0;
+ }
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ static struct rtnl_link_stats64 *b44_get_stats64(struct net_device *dev,
+ 					struct rtnl_link_stats64 *nstat)
++#else
++static struct net_device_stats *b44_get_stats(struct net_device *dev)
++#endif
+ {
+ 	struct b44 *bp = netdev_priv(dev);
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36))
++	struct net_device_stats *nstat = &dev->stats;
++#endif
+ 	struct b44_hw_stats *hwstat = &bp->hw_stats;
+ 	unsigned int start;
+ 
+@@ -2135,7 +2143,11 @@ static const struct net_device_ops b44_n
+ 	.ndo_open		= b44_open,
+ 	.ndo_stop		= b44_close,
+ 	.ndo_start_xmit		= b44_start_xmit,
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
+ 	.ndo_get_stats64	= b44_get_stats64,
++#else
++	.ndo_get_stats		= b44_get_stats,
++#endif
+ 	.ndo_set_rx_mode	= b44_set_rx_mode,
+ 	.ndo_set_mac_address	= b44_set_mac_addr,
+ 	.ndo_validate_addr	= eth_validate_addr,
-- 
1.7.9.5

