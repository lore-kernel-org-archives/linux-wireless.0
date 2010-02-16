Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42745 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933335Ab0BPVDJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 16:03:09 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat: backport genlmsg_unicast
Date: Tue, 16 Feb 2010 22:03:00 +0100
Message-Id: <1266354181-5317-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.32.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.32.h b/include/linux/compat-2.6.32.h
index 11060d8..2f5013f 100644
--- a/include/linux/compat-2.6.32.h
+++ b/include/linux/compat-2.6.32.h
@@ -9,6 +9,7 @@
 #include <linux/compat.h>
 #include <net/iw_handler.h>
 #include <linux/workqueue.h>
+#include <net/genetlink.h>
 
 #define SDIO_VENDOR_ID_INTEL			0x0089
 #define SDIO_DEVICE_ID_INTEL_IWMC3200WIMAX	0x1402
@@ -47,6 +48,7 @@ static inline void flush_delayed_work(struct delayed_work *dwork)
 /* net namespace is lost */
 #define genlmsg_multicast_netns(a, b, c, d, e)	genlmsg_multicast(b, c, d, e)
 #define genlmsg_multicast_allns(a, b, c, d)	genlmsg_multicast(a, b, c, d)
+#define genlmsg_unicast(net, skb, pid)	genlmsg_unicast(skb, pid)
 
 #define dev_change_net_namespace(a, b, c) (-EOPNOTSUPP)
 
-- 
1.6.3.3

