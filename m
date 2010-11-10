Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58629 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab0KJCUw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:20:52 -0500
Received: by mail-qw0-f46.google.com with SMTP id 5so5541qwh.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:20:52 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 04/44] compat/2.6.18: add compat inline for netdev_alloc_skb()
Date: Tue,  9 Nov 2010 21:19:46 -0500
Message-Id: <1289355626-25373-5-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/compat-2.6.18.h |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.18.h b/include/linux/compat-2.6.18.h
index a45cfc7..4a7034a 100644
--- a/include/linux/compat-2.6.18.h
+++ b/include/linux/compat-2.6.18.h
@@ -6,8 +6,29 @@
 /* Compat work for 2.6.18 */
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,18))
 
+#include <linux/gfp.h>
+#include <linux/netdevice.h>
+#include <linux/skbuff.h>
+
 #define roundup(x, y)	((((x) + ((y) - 1)) / (y)) * (y))
 
+#ifndef NET_SKB_PAD
+#define NET_SKB_PAD	16
+#endif
+
+static inline struct sk_buff *
+netdev_alloc_skb(struct net_device *dev, unsigned int length)
+{
+	struct sk_buff *skb;
+
+	skb = alloc_skb(length + NET_SKB_PAD, GFP_ATOMIC);
+	if (likely(skb)) {
+		skb_reserve(skb, NET_SKB_PAD);
+		skb->dev = dev;
+	}
+	return skb;
+}
+
 struct hwrng
 {
 	const char *name;
-- 
1.7.2.30.gc37d7.dirty

