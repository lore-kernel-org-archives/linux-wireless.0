Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33082 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754809Ab0IYLWc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Sep 2010 07:22:32 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>,
	philipp_subx@redfish-solutions.com
Subject: [PATCH] compat: fix build error in init_dummy_netdev
Date: Sat, 25 Sep 2010 13:22:17 +0200
Message-Id: <1285413737-782-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In kernel <= 2.6.28 the member napi_list in struct net_device is only
availabe if CONFIG_NETPOLL is set. We should initialize it only if it
is available.

This should fix the problem reported by Philip.

This should also go into stable.

CC: philipp_subx@redfish-solutions.com
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-2.6.29.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/compat/compat-2.6.29.c b/compat/compat-2.6.29.c
index bc4288f..cded3cc 100644
--- a/compat/compat-2.6.29.c
+++ b/compat/compat-2.6.29.c
@@ -153,8 +153,10 @@ int init_dummy_netdev(struct net_device *dev)
 	/* initialize the ref count */
 	atomic_set(&dev->refcnt, 1);
 
+#ifdef CONFIG_NETPOLL
 	/* NAPI wants this */
 	INIT_LIST_HEAD(&dev->napi_list);
+#endif
 
 	/* a dummy interface is started by default */
 	set_bit(__LINK_STATE_PRESENT, &dev->state);
-- 
1.7.0.4

