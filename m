Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f212.google.com ([209.85.217.212]:57613 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbZLAIj6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 03:39:58 -0500
Received: by gxk4 with SMTP id 4so3477390gxk.8
        for <linux-wireless@vger.kernel.org>; Tue, 01 Dec 2009 00:40:05 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: mcgrof@bombadil.infradead.org, linux-wireless@vger.kernel.org,
	Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 2/5] Add compatibility call for dev_get_stats()
Date: Tue,  1 Dec 2009 03:38:18 -0500
Message-Id: <1259656701-12329-2-git-send-email-lacombar@gmail.com>
In-Reply-To: <1259656701-12329-1-git-send-email-lacombar@gmail.com>
References: <4B0B4405.4050605@gmail.com>
 <1259656701-12329-1-git-send-email-lacombar@gmail.com>
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
 
@@ -40,6 +41,12 @@ static inline struct sk_buff *skb_queue_prev(const struct sk_buff_head *list,
 	return skb->prev;
 }
 
+
+static inline struct net_device_stats *dev_get_stats(struct net_device *dev)
+{
+	return dev->get_stats(dev);
+}
+
 extern void usb_unpoison_anchored_urbs(struct usb_anchor *anchor);
 
 #define DIV_ROUND_CLOSEST(x, divisor)(			\
-- 
1.6.3.3.385.g60647.dirty

