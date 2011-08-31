Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:45246 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756740Ab1HaWUZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 18:20:25 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/3] compat: add skb_frag_dma_map
Date: Thu,  1 Sep 2011 00:20:11 +0200
Message-Id: <1314829212-27365-2-git-send-email-hauke@hauke-m.de> (sfid-20110901_002029_030724_CEE2597C)
In-Reply-To: <1314829212-27365-1-git-send-email-hauke@hauke-m.de>
References: <1314829212-27365-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-3.2.h |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-3.2.h b/include/linux/compat-3.2.h
index d10495c..009e341 100644
--- a/include/linux/compat-3.2.h
+++ b/include/linux/compat-3.2.h
@@ -5,6 +5,9 @@
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(3,2,0))
 
+#include <linux/skbuff.h>
+#include <linux/dma-mapping.h>
+
 /*
  * This is not part of The 2.6.37 kernel yet but we
  * we use it to optimize the backport code we
@@ -24,6 +27,37 @@
 
 #define PMSG_IS_AUTO(msg)	(((msg).event & PM_EVENT_AUTO) != 0)
 
+/**
+ * skb_frag_page - retrieve the page refered to by a paged fragment
+ * @frag: the paged fragment
+ *
+ * Returns the &struct page associated with @frag.
+ */
+static inline struct page *skb_frag_page(const skb_frag_t *frag)
+{
+	return frag->page;
+}
+
+/**
+ * skb_frag_dma_map - maps a paged fragment via the DMA API
+ * @device: the device to map the fragment to
+ * @frag: the paged fragment to map
+ * @offset: the offset within the fragment (starting at the
+ *          fragment's own offset)
+ * @size: the number of bytes to map
+ * @direction: the direction of the mapping (%PCI_DMA_*)
+ *
+ * Maps the page associated with @frag to @device.
+ */
+static inline dma_addr_t skb_frag_dma_map(struct device *dev,
+					  const skb_frag_t *frag,
+					  size_t offset, size_t size,
+					  enum dma_data_direction dir)
+{
+	return dma_map_page(dev, skb_frag_page(frag),
+			    frag->page_offset + offset, size, dir);
+}
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,2,0)) */
 
 #endif /* LINUX_3_2_COMPAT_H */
-- 
1.7.4.1

