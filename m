Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:35155 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422Ab1KHUqg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 15:46:36 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat: add some workarounds for Debian squeeze
Date: Tue,  8 Nov 2011 21:46:31 +0100
Message-Id: <1320785191-8052-1-git-send-email-hauke@hauke-m.de> (sfid-20111108_214640_817448_75A6411B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Debian squeeze also backports some stuff and this conflicts with compat
wireless stuff. This is a nice way of making compat work with debian
squeeze without breaking normal kernels.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.33.h |    9 +++++++++
 include/linux/compat-2.6.34.h |    6 ++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.33.h b/include/linux/compat-2.6.33.h
index 386ee4c..539b469 100644
--- a/include/linux/compat-2.6.33.h
+++ b/include/linux/compat-2.6.33.h
@@ -55,6 +55,9 @@ static inline void compat_release_firmware(const struct firmware *fw)
 /* this will never happen on older kernels */
 #define NETDEV_POST_INIT 0xffff
 
+/* mask netdev_alloc_skb_ip_align as debian squeeze also backports this */
+#define netdev_alloc_skb_ip_align(a, b) compat_netdev_alloc_skb_ip_align(a, b)
+
 static inline struct sk_buff *netdev_alloc_skb_ip_align(struct net_device *dev,
                 unsigned int length)
 {
@@ -107,6 +110,9 @@ int pccard_loop_tuple(struct pcmcia_socket *s, unsigned int function,
 
 #define sock_recv_ts_and_drops(msg, sk, skb) sock_recv_timestamp(msg, sk, skb)
 
+/* mask pci_pcie_cap as debian squeeze also backports this */
+#define pci_pcie_cap(a) compat_pci_pcie_cap(a)
+
 /**
  * pci_pcie_cap - get the saved PCIe capability offset
  * @dev: PCI device
@@ -144,6 +150,9 @@ static inline bool pci_is_pcie(struct pci_dev *dev)
 #define __always_unused			/* unimplemented */
 #endif
 
+/* mask IS_ERR_OR_NULL as debian squeeze also backports this */
+#define IS_ERR_OR_NULL(a) compat_IS_ERR_OR_NULL(a)
+
 static inline long __must_check IS_ERR_OR_NULL(const void *ptr)
 {
 	return !ptr || IS_ERR_VALUE((unsigned long)ptr);
diff --git a/include/linux/compat-2.6.34.h b/include/linux/compat-2.6.34.h
index 0ab344c..562ccf7 100644
--- a/include/linux/compat-2.6.34.h
+++ b/include/linux/compat-2.6.34.h
@@ -212,6 +212,8 @@ do {							\
 #define usb_alloc_coherent(dev, size, mem_flags, dma) usb_buffer_alloc(dev, size, mem_flags, dma)
 #define usb_free_coherent(dev, size, addr, dma) usb_buffer_free(dev, size, addr, dma)
 
+/* only include this if DEFINE_DMA_UNMAP_ADDR is not set as debian squeeze also backports this  */
+#ifndef DEFINE_DMA_UNMAP_ADDR
 #ifdef CONFIG_NEED_DMA_MAP_STATE
 #define DEFINE_DMA_UNMAP_ADDR(ADDR_NAME)        dma_addr_t ADDR_NAME
 #define DEFINE_DMA_UNMAP_LEN(LEN_NAME)          __u32 LEN_NAME
@@ -227,6 +229,10 @@ do {							\
 #define dma_unmap_len(PTR, LEN_NAME)             (0)
 #define dma_unmap_len_set(PTR, LEN_NAME, VAL)    do { } while (0)
 #endif
+#endif
+
+/* mask dma_set_coherent_mask as debian squeeze also backports this */
+#define dma_set_coherent_mask(a, b) compat_dma_set_coherent_mask(a, b)
 
 static inline int dma_set_coherent_mask(struct device *dev, u64 mask)
 {
-- 
1.7.4.1

