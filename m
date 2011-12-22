Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55546 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951Ab1LVUrz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Dec 2011 15:47:55 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 6/6] compat-wireless: no trans_start on netdev_queue
Date: Thu, 22 Dec 2011 21:47:30 +0100
Message-Id: <1324586850-5212-7-git-send-email-hauke@hauke-m.de> (sfid-20111222_214759_484984_DCC29AED)
In-Reply-To: <1324586850-5212-1-git-send-email-hauke@hauke-m.de>
References: <1324586850-5212-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

struct netdev_queue does not have the attribute trans_start in kernel <
2.6.31. trans_start on struct net_device does the same on older kernels.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/47-no_trans_start_on_netdev_queue.patch |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)
 create mode 100644 patches/47-no_trans_start_on_netdev_queue.patch

diff --git a/patches/47-no_trans_start_on_netdev_queue.patch b/patches/47-no_trans_start_on_netdev_queue.patch
new file mode 100644
index 0000000..c9e3345
--- /dev/null
+++ b/patches/47-no_trans_start_on_netdev_queue.patch
@@ -0,0 +1,13 @@
+--- a/drivers/net/wireless/mwifiex/init.c
++++ b/drivers/net/wireless/mwifiex/init.c
+@@ -289,8 +289,10 @@ void mwifiex_set_trans_start(struct net_
+ {
+ 	int i;
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31))
+ 	for (i = 0; i < dev->num_tx_queues; i++)
+ 		netdev_get_tx_queue(dev, i)->trans_start = jiffies;
++#endif
+ 
+ 	dev->trans_start = jiffies;
+ }
-- 
1.7.5.4

