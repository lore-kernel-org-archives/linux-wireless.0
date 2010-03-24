Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:33023 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019Ab0CXV5o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Mar 2010 17:57:44 -0400
Subject: [PATCH] compat: add qdisc_all_tx_empty for Linux 2.6.26 and older
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
From: Pavel Roskin <proski@gnu.org>
Date: Wed, 24 Mar 2010 17:57:43 -0400
Message-ID: <20100324215743.24859.80517.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


---
 include/linux/compat-2.6.27.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.27.h b/include/linux/compat-2.6.27.h
index a690e2c..e27115b 100644
--- a/include/linux/compat-2.6.27.h
+++ b/include/linux/compat-2.6.27.h
@@ -18,6 +18,8 @@
 #include <net/iw_handler.h>
 #include <asm-generic/bug.h>
 #include <linux/wireless.h>
+#include <linux/skbuff.h>
+#include <net/sch_generic.h>
 
 #define PCI_PM_CAP_PME_SHIFT	11
 
@@ -49,6 +51,12 @@ static inline void netif_tx_stop_all_queues(struct net_device *dev)
 	netif_stop_queue(dev);
 }
 
+/* Are all TX queues of the device empty?  */
+static inline bool qdisc_all_tx_empty(const struct net_device *dev)
+{
+	return skb_queue_empty(&dev->qdisc->q);
+}
+
 bool pci_pme_capable(struct pci_dev *dev, pci_power_t state);
 
 /*
