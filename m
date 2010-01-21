Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40668 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab0AUCzr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2010 21:55:47 -0500
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat Linux))
	id 1NXnD1-00045e-5u
	for linux-wireless@vger.kernel.org; Thu, 21 Jan 2010 02:55:47 +0000
Date: Wed, 20 Jan 2010 21:55:47 -0500
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: RFC/RFT: compat-wireless for 2.6.32.4 - MQ backport support
Message-ID: <20100121025546.GB8069@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 2.6.32.4 kernel got added MQ support back. I've tried to backport
this and this is what I have so far:

http://bombadil.infradead.org/~mcgrof/tmp/compat-wireless-2.6.32.4-rc1.tar.bz2

Not sure about the select queue stuff yet though. Reports of uses of
ath9k (./scripts/driver-select ath9k) on 2.6.23..2.6.26 would be
appreciated.

  Luis

--- 18-multiqueue.patch ---

The 2.6.23 kernel added multiqueue support. That release
relied on the on the notion of struct net_device_subqueue
attached to the netdevice struct as an array. The 2.6.27
renamed these to struct netdev_queue, amogst other changes.

For kernels 2.6.23..2.6.26 then we backport MQ support by
using the equivalent calls on the struct netdev_queue to
the struct net_device_subqueue.

For older kernels than 2.6.23 we can only stop all the
queues then.

--- a/net/mac80211/util.c	2010-01-20 18:35:04.000000000 -0800
+++ a/net/mac80211/util.c	2010-01-20 18:34:11.000000000 -0800
@@ -287,7 +287,13 @@
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list)
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27))
 		netif_tx_wake_queue(netdev_get_tx_queue(sdata->dev, queue));
+#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23))
+		netif_start_subqueue(sdata->dev, queue);
+#else
+		netif_wake_queue(sdata->dev);
+#endif
 	rcu_read_unlock();
 }
 
@@ -322,7 +328,13 @@
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list)
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27))
 		netif_tx_stop_queue(netdev_get_tx_queue(sdata->dev, queue));
+#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23))
+		netif_stop_subqueue(sdata->dev, queue);
+#else
+		netif_stop_queue(sdata->dev);
+#endif
 	rcu_read_unlock();
 }
 
