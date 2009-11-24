Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.211.182]:46844 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757794AbZKXC0d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 21:26:33 -0500
Received: by mail-yw0-f182.google.com with SMTP id 12so5947609ywh.21
        for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2009 18:26:39 -0800 (PST)
Message-ID: <4B0B4414.2030401@gmail.com>
Date: Mon, 23 Nov 2009 21:25:24 -0500
From: Arnaud Lacombe <lacombar@gmail.com>
MIME-Version: 1.0
To: mcgrof@bombadil.infradead.org
CC: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Subject: [PATCH 10/13] Add compatibility call for dev_get_stats()
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added on commit eeda3fd6 by Stephen Hemminger in include/linux/netdevice.h.

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 compat-2.6.29.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/compat-2.6.29.h b/compat-2.6.29.h
index ff97b37..cad5e6b 100644
--- a/compat-2.6.29.h
+++ b/compat-2.6.29.h
@@ -6,6 +6,7 @@

 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))

+#include <linux/netdevice.h>
 #include <linux/skbuff.h>
 #include <linux/usb.h>

@@ -40,6 +41,12 @@ static inline struct sk_buff *skb_queue_prev(const
struct sk_buff_head *list,
 	return skb->prev;
 }

+
+static inline struct net_device_stats *dev_get_stats(struct net_device
*dev)
+{
+	return dev->get_stats(dev);
+}
+
 extern void usb_unpoison_anchored_urbs(struct usb_anchor *anchor);

 #define DIV_ROUND_CLOSEST(x, divisor)(			\
-- 
1.6.3.3.385.g60647.dirty


