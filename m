Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55736 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbZLVPVZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2009 10:21:25 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat: Backport pcmcia from 2.6.33
Date: Tue, 22 Dec 2009 16:20:00 +0100
Message-Id: <1261495204-28966-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1261495204-28966-1-git-send-email-hauke@hauke-m.de>
References: <1261495204-28966-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This backports the pcmcia_loop_tuple function and change the signature
of pcmcia_request_window and pcmcia_map_mem_page as needed for older
kernels.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/Makefile               |    1 +
 compat/compat-2.6.33.c        |  130 +++++++++++++++++++++++++++++++++++++++++
 include/linux/compat-2.6.33.h |   21 +++++++
 3 files changed, 152 insertions(+), 0 deletions(-)
 create mode 100644 compat/compat-2.6.33.c

diff --git a/compat/Makefile b/compat/Makefile
index 20d80e2..fd2f99f 100644
--- a/compat/Makefile
+++ b/compat/Makefile
@@ -19,3 +19,4 @@ compat-$(CONFIG_COMPAT_KERNEL_29) += compat-2.6.29.o
 compat-$(CONFIG_COMPAT_KERNEL_30) += compat-2.6.30.o
 compat-$(CONFIG_COMPAT_KERNEL_31) += compat-2.6.31.o
 compat-$(CONFIG_COMPAT_KERNEL_32) += compat-2.6.32.o
+compat-$(CONFIG_COMPAT_KERNEL_33) += compat-2.6.33.o
diff --git a/compat/compat-2.6.33.c b/compat/compat-2.6.33.c
new file mode 100644
index 0000000..052c609
--- /dev/null
+++ b/compat/compat-2.6.33.c
@@ -0,0 +1,130 @@
+/*
+ * Copyright 2009	Hauke Mehrtens <hauke@hauke-m.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Compatibility file for Linux wireless for kernels 2.6.33.
+ */
+
+#include <linux/compat.h>
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33))
+
+
+/**
+ * pccard_loop_tuple() - loop over tuples in the CIS
+ * @s:		the struct pcmcia_socket where the card is inserted
+ * @function:	the device function we loop for
+ * @code:	which CIS code shall we look for?
+ * @parse:	buffer where the tuple shall be parsed (or NULL, if no parse)
+ * @priv_data:	private data to be passed to the loop_tuple function.
+ * @loop_tuple:	function to call for each CIS entry of type @function. IT
+ *		gets passed the raw tuple, the paresed tuple (if @parse is
+ *		set) and @priv_data.
+ *
+ * pccard_loop_tuple() loops over all CIS entries of type @function, and
+ * calls the @loop_tuple function for each entry. If the call to @loop_tuple
+ * returns 0, the loop exits. Returns 0 on success or errorcode otherwise.
+ */
+int pccard_loop_tuple(struct pcmcia_socket *s, unsigned int function,
+		      cisdata_t code, cisparse_t *parse, void *priv_data,
+		      int (*loop_tuple) (tuple_t *tuple,
+					 cisparse_t *parse,
+					 void *priv_data))
+{
+	tuple_t tuple;
+	cisdata_t *buf;
+	int ret;
+
+	buf = kzalloc(256, GFP_KERNEL);
+	if (buf == NULL) {
+		dev_printk(KERN_WARNING, &s->dev, "no memory to read tuple\n");
+		return -ENOMEM;
+	}
+
+	tuple.TupleData = buf;
+	tuple.TupleDataMax = 255;
+	tuple.TupleOffset = 0;
+	tuple.DesiredTuple = code;
+	tuple.Attributes = 0;
+
+	ret = pccard_get_first_tuple(s, function, &tuple);
+	while (!ret) {
+		if (pccard_get_tuple_data(s, &tuple))
+			goto next_entry;
+
+		if (parse)
+			if (pcmcia_parse_tuple(&tuple, parse))
+				goto next_entry;
+
+		ret = loop_tuple(&tuple, parse, priv_data);
+		if (!ret)
+			break;
+
+next_entry:
+		ret = pccard_get_next_tuple(s, function, &tuple);
+	}
+
+	kfree(buf);
+	return ret;
+}
+EXPORT_SYMBOL(pccard_loop_tuple);
+/* Source: drivers/pcmcia/cistpl.c */
+
+
+struct pcmcia_loop_mem {
+	struct pcmcia_device *p_dev;
+	void *priv_data;
+	int (*loop_tuple) (struct pcmcia_device *p_dev,
+			   tuple_t *tuple,
+			   void *priv_data);
+};
+
+/**
+ * pcmcia_do_loop_tuple() - internal helper for pcmcia_loop_config()
+ *
+ * pcmcia_do_loop_tuple() is the internal callback for the call from
+ * pcmcia_loop_tuple() to pccard_loop_tuple(). Data is transferred
+ * by a struct pcmcia_cfg_mem.
+ */
+static int pcmcia_do_loop_tuple(tuple_t *tuple, cisparse_t *parse, void *priv)
+{
+	struct pcmcia_loop_mem *loop = priv;
+
+	return loop->loop_tuple(loop->p_dev, tuple, loop->priv_data);
+};
+
+/**
+ * pcmcia_loop_tuple() - loop over tuples in the CIS
+ * @p_dev:	the struct pcmcia_device which we need to loop for.
+ * @code:	which CIS code shall we look for?
+ * @priv_data:	private data to be passed to the loop_tuple function.
+ * @loop_tuple:	function to call for each CIS entry of type @function. IT
+ *		gets passed the raw tuple and @priv_data.
+ *
+ * pcmcia_loop_tuple() loops over all CIS entries of type @function, and
+ * calls the @loop_tuple function for each entry. If the call to @loop_tuple
+ * returns 0, the loop exits. Returns 0 on success or errorcode otherwise.
+ */
+int pcmcia_loop_tuple(struct pcmcia_device *p_dev, cisdata_t code,
+		      int (*loop_tuple) (struct pcmcia_device *p_dev,
+					 tuple_t *tuple,
+					 void *priv_data),
+		      void *priv_data)
+{
+	struct pcmcia_loop_mem loop = {
+		.p_dev = p_dev,
+		.loop_tuple = loop_tuple,
+		.priv_data = priv_data};
+
+	return pccard_loop_tuple(p_dev->socket, p_dev->func, code, NULL,
+				 &loop, pcmcia_do_loop_tuple);
+}
+EXPORT_SYMBOL(pcmcia_loop_tuple);
+/* Source: drivers/pcmcia/pcmcia_resource.c */
+
+
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)) */
+
diff --git a/include/linux/compat-2.6.33.h b/include/linux/compat-2.6.33.h
index 0942baf..5367cd9 100644
--- a/include/linux/compat-2.6.33.h
+++ b/include/linux/compat-2.6.33.h
@@ -8,6 +8,9 @@
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33))
 
 #include <linux/skbuff.h>
+#include <pcmcia/cs_types.h>
+#include <pcmcia/cistpl.h>
+#include <pcmcia/ds.h>
 
 #define IFF_DONT_BRIDGE 0x800		/* disallow bridging this ether dev */
 /* source: include/linux/if.h */
@@ -28,6 +31,24 @@ static inline struct sk_buff *netdev_alloc_skb_ip_align(struct net_device *dev,
 	return skb;
 }
 
+#define pcmcia_request_window(a, b, c) pcmcia_request_window(&a, b, c)
+
+#define pcmcia_map_mem_page(a, b, c) pcmcia_map_mem_page(b, c)
+
+/* loop over CIS entries */
+int pcmcia_loop_tuple(struct pcmcia_device *p_dev, cisdata_t code,
+		      int (*loop_tuple) (struct pcmcia_device *p_dev,
+					 tuple_t *tuple,
+					 void *priv_data),
+		      void *priv_data);
+
+/* loop over CIS entries */
+int pccard_loop_tuple(struct pcmcia_socket *s, unsigned int function,
+		      cisdata_t code, cisparse_t *parse, void *priv_data,
+		      int (*loop_tuple) (tuple_t *tuple,
+					 cisparse_t *parse,
+					 void *priv_data));
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)) */
 
 #endif /* LINUX_26_33_COMPAT_H */
-- 
1.6.3.3

