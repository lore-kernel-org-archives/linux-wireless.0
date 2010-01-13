Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:32956 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755787Ab0AMVUd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2010 16:20:33 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/3] compat: build pccard and pcmcia condituinaly
Date: Wed, 13 Jan 2010 22:20:19 +0100
Message-Id: <1263417619-30261-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1263417619-30261-1-git-send-email-hauke@hauke-m.de>
References: <1263417619-30261-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the kernel does not include pcmcia, compat.o should not relay on
methods provided by it.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-2.6.28.c        |    4 ++++
 compat/compat-2.6.33.c        |    7 +++++++
 include/linux/compat-2.6.28.h |    4 ++++
 include/linux/compat-2.6.33.h |    8 ++++++++
 4 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/compat/compat-2.6.28.c b/compat/compat-2.6.28.c
index 87ad2d5..e3f3a1b 100644
--- a/compat/compat-2.6.28.c
+++ b/compat/compat-2.6.28.c
@@ -85,6 +85,8 @@ void usb_poison_urb(struct urb *urb)
 EXPORT_SYMBOL_GPL(usb_poison_urb);
 #endif
 
+#if defined(CONFIG_PCMCIA) || defined(CONFIG_PCMCIA_MODULE)
+
 #include <pcmcia/ds.h>
 struct pcmcia_cfg_mem {
 	tuple_t tuple;
@@ -160,6 +162,8 @@ next_entry:
 }
 EXPORT_SYMBOL(pcmcia_loop_config);
 
+#endif /* CONFIG_PCMCIA */
+
 void usb_unpoison_urb(struct urb *urb)
 {
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28))
diff --git a/compat/compat-2.6.33.c b/compat/compat-2.6.33.c
index 052c609..055082e 100644
--- a/compat/compat-2.6.33.c
+++ b/compat/compat-2.6.33.c
@@ -12,6 +12,9 @@
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33))
 
+#include <linux/autoconf.h>
+
+#if defined(CONFIG_PCCARD) || defined(CONFIG_PCCARD_MODULE)
 
 /**
  * pccard_loop_tuple() - loop over tuples in the CIS
@@ -73,6 +76,7 @@ next_entry:
 EXPORT_SYMBOL(pccard_loop_tuple);
 /* Source: drivers/pcmcia/cistpl.c */
 
+#if defined(CONFIG_PCMCIA) || defined(CONFIG_PCMCIA_MODULE)
 
 struct pcmcia_loop_mem {
 	struct pcmcia_device *p_dev;
@@ -125,6 +129,9 @@ int pcmcia_loop_tuple(struct pcmcia_device *p_dev, cisdata_t code,
 EXPORT_SYMBOL(pcmcia_loop_tuple);
 /* Source: drivers/pcmcia/pcmcia_resource.c */
 
+#endif /* CONFIG_PCMCIA */
+
+#endif /* CONFIG_PCCARD */
 
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)) */
 
diff --git a/include/linux/compat-2.6.28.h b/include/linux/compat-2.6.28.h
index bc26086..c7dcb79 100644
--- a/include/linux/compat-2.6.28.h
+++ b/include/linux/compat-2.6.28.h
@@ -27,6 +27,8 @@
 })
 #endif /* From include/asm-generic/bug.h */
 
+#if defined(CONFIG_PCMCIA) || defined(CONFIG_PCMCIA_MODULE)
+
 #include <pcmcia/cs_types.h>
 #include <pcmcia/cs.h>
 #include <pcmcia/cistpl.h>
@@ -45,6 +47,8 @@ int pcmcia_loop_config(struct pcmcia_device *p_dev,
 						 void *priv_data),
 		       void *priv_data);
 
+#endif /* CONFIG_PCMCIA */
+
 /* USB anchors were added as of 2.6.23 */
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23))
 #if 0
diff --git a/include/linux/compat-2.6.33.h b/include/linux/compat-2.6.33.h
index 8123914..da5821b 100644
--- a/include/linux/compat-2.6.33.h
+++ b/include/linux/compat-2.6.33.h
@@ -30,6 +30,10 @@ static inline struct sk_buff *netdev_alloc_skb_ip_align(struct net_device *dev,
 	return skb;
 }
 
+#if defined(CONFIG_PCCARD) || defined(CONFIG_PCCARD_MODULE)
+
+#if defined(CONFIG_PCMCIA) || defined(CONFIG_PCMCIA_MODULE)
+
 #define pcmcia_request_window(a, b, c) pcmcia_request_window(&a, b, c)
 
 #define pcmcia_map_mem_page(a, b, c) pcmcia_map_mem_page(b, c)
@@ -41,6 +45,8 @@ int pcmcia_loop_tuple(struct pcmcia_device *p_dev, cisdata_t code,
 					 void *priv_data),
 		      void *priv_data);
 
+#endif /* CONFIG_PCMCIA */
+
 /* loop over CIS entries */
 int pccard_loop_tuple(struct pcmcia_socket *s, unsigned int function,
 		      cisdata_t code, cisparse_t *parse, void *priv_data,
@@ -48,6 +54,8 @@ int pccard_loop_tuple(struct pcmcia_socket *s, unsigned int function,
 					 cisparse_t *parse,
 					 void *priv_data));
 
+#endif /* CONFIG_PCCARD */
+
 /* Backport for kfifo
  * kfifo_alloc and kfifo_free must be backported manually 
  */
-- 
1.6.3.3

