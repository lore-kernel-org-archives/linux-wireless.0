Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54570 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825Ab0FFJMk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jun 2010 05:12:40 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/4] compat: backport small functions and defines
Date: Sun,  6 Jun 2010 11:12:26 +0200
Message-Id: <1275815547-30313-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1275815547-30313-1-git-send-email-hauke@hauke-m.de>
References: <1275815547-30313-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Backport of some functions and defines needed by compat-wireless.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.29.h |   25 +++++++++++++++++++++++++
 include/linux/compat-2.6.32.h |    2 ++
 include/linux/compat-2.6.34.h |   16 ++++++++++++++++
 3 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.29.h b/include/linux/compat-2.6.29.h
index f063e24..a1a989c 100644
--- a/include/linux/compat-2.6.29.h
+++ b/include/linux/compat-2.6.29.h
@@ -249,6 +249,31 @@ extern int eth_mac_addr(struct net_device *dev, void *p);
 extern int eth_change_mtu(struct net_device *dev, int new_mtu);
 extern int eth_validate_addr(struct net_device *dev);
 
+#ifdef CONFIG_NET_NS
+
+static inline void write_pnet(struct net **pnet, struct net *net)
+{
+	*pnet = net;
+}
+
+static inline struct net *read_pnet(struct net * const *pnet)
+{
+	return *pnet;
+}
+
+#else
+
+#define write_pnet(pnet, net)	do { (void)(net);} while (0)
+#define read_pnet(pnet)		(&init_net)
+
+/*
+ * swap - swap value of @a and @b
+ */
+#define swap(a, b) \
+	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
+
+#endif
+
 #else
 
 static inline void netdev_attach_ops(struct net_device *dev,
diff --git a/include/linux/compat-2.6.32.h b/include/linux/compat-2.6.32.h
index 2f5013f..3a41bd6 100644
--- a/include/linux/compat-2.6.32.h
+++ b/include/linux/compat-2.6.32.h
@@ -92,6 +92,8 @@ struct dev_pm_ops name = { \
 /* The export symbol in changed in compat/patches/15-symbol-export-conflicts.patch */
 #define ieee80211_rx(hw, skb) mac80211_ieee80211_rx(hw, skb)
 
+#define dev_to_sdio_func(d)	container_of(d, struct sdio_func, dev)
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,32)) */
 
 #endif /* LINUX_26_32_COMPAT_H */
diff --git a/include/linux/compat-2.6.34.h b/include/linux/compat-2.6.34.h
index 2870a3b..b1c15a7 100644
--- a/include/linux/compat-2.6.34.h
+++ b/include/linux/compat-2.6.34.h
@@ -200,6 +200,22 @@ do {							\
 #define usb_alloc_coherent(dev, size, mem_flags, dma) usb_buffer_alloc(dev, size, mem_flags, dma)
 #define usb_free_coherent(dev, size, addr, dma) usb_buffer_free(dev, size, addr, dma)
 
+#ifdef CONFIG_NEED_DMA_MAP_STATE
+#define DEFINE_DMA_UNMAP_ADDR(ADDR_NAME)        dma_addr_t ADDR_NAME
+#define DEFINE_DMA_UNMAP_LEN(LEN_NAME)          __u32 LEN_NAME
+#define dma_unmap_addr(PTR, ADDR_NAME)           ((PTR)->ADDR_NAME)
+#define dma_unmap_addr_set(PTR, ADDR_NAME, VAL)  (((PTR)->ADDR_NAME) = (VAL))
+#define dma_unmap_len(PTR, LEN_NAME)             ((PTR)->LEN_NAME)
+#define dma_unmap_len_set(PTR, LEN_NAME, VAL)    (((PTR)->LEN_NAME) = (VAL))
+#else
+#define DEFINE_DMA_UNMAP_ADDR(ADDR_NAME)
+#define DEFINE_DMA_UNMAP_LEN(LEN_NAME)
+#define dma_unmap_addr(PTR, ADDR_NAME)           (0)
+#define dma_unmap_addr_set(PTR, ADDR_NAME, VAL)  do { } while (0)
+#define dma_unmap_len(PTR, LEN_NAME)             (0)
+#define dma_unmap_len_set(PTR, LEN_NAME, VAL)    do { } while (0)
+#endif
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,34)) */
 
 #endif /* LINUX_26_34_COMPAT_H */
-- 
1.7.0.4

