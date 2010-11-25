Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:39460 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054Ab0KYHxF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Nov 2010 02:53:05 -0500
Date: Thu, 25 Nov 2010 15:05:39 -0500
From: Youquan Song <youquan.song@linux.intel.com>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, hui.xiao@intel.com,
	youquan.song@intel.com
Subject: [PATCH] compat-wireless:Fix interface redefine when backport to
	2.6.32
Message-ID: <20101125200539.GA31878@linux-youquan.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Netdev_alloc_skb_ip_align already define at 2.6.32 kernel, so only < 2.6.32 
kernel needs it, so when backport latest compat-wirelss to 2.6.32, it report
redefine the interface.

This patch fix the above issue.

Signed-off-by: Youquan Song <youquan.song@intel.com>
Signed-off-by: Hui Xiao <hui.xiao@intel.com>
---


diff --git a/include/linux/compat-2.6.32.h b/include/linux/compat-2.6.32.h
index 321a89a..164aa6c 100644
--- a/include/linux/compat-2.6.32.h
+++ b/include/linux/compat-2.6.32.h
@@ -96,6 +96,16 @@ struct dev_pm_ops name = { \
 
 #define lockdep_assert_held(l)			do { } while (0)
 
+static inline struct sk_buff *netdev_alloc_skb_ip_align(struct net_device *dev,
+		unsigned int length)
+{
+	struct sk_buff *skb = netdev_alloc_skb(dev, length + NET_IP_ALIGN);
+
+	if (NET_IP_ALIGN && skb)
+		skb_reserve(skb, NET_IP_ALIGN);
+	return skb;
+}
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,32)) */
 
 #endif /* LINUX_26_32_COMPAT_H */
diff --git a/include/linux/compat-2.6.33.h b/include/linux/compat-2.6.33.h
index c2dbc1b..4646d28 100644
--- a/include/linux/compat-2.6.33.h
+++ b/include/linux/compat-2.6.33.h
@@ -55,16 +55,6 @@ static inline void compat_release_firmware(const struct firmware *fw)
 /* this will never happen on older kernels */
 #define NETDEV_POST_INIT 0xffff
 
-static inline struct sk_buff *netdev_alloc_skb_ip_align(struct net_device *dev,
-                unsigned int length)
-{
-	struct sk_buff *skb = netdev_alloc_skb(dev, length + NET_IP_ALIGN);
-
-	if (NET_IP_ALIGN && skb)
-		skb_reserve(skb, NET_IP_ALIGN);
-	return skb;
-}
-
 #if defined(CONFIG_PCCARD) || defined(CONFIG_PCCARD_MODULE)
 
 #if defined(CONFIG_PCMCIA) || defined(CONFIG_PCMCIA_MODULE)
