Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:47672 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084Ab0KJCWB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:22:01 -0500
Received: by mail-qy0-f174.google.com with SMTP id 12so2500227qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:22:00 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 40/44] compat/2.6.29: don't waste space around DIV_ROUND_CLOSEST()
Date: Tue,  9 Nov 2010 21:20:22 -0500
Message-Id: <1289355626-25373-41-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/compat-2.6.29.h |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/linux/compat-2.6.29.h b/include/linux/compat-2.6.29.h
index b83aca0..0c20c9e 100644
--- a/include/linux/compat-2.6.29.h
+++ b/include/linux/compat-2.6.29.h
@@ -242,12 +242,10 @@ extern void usb_unpoison_anchored_urbs(struct usb_anchor *anchor);
 #endif /* CONFIG_USB */
 #endif
 
-#define DIV_ROUND_CLOSEST(x, divisor)(			\
-{							\
+#define DIV_ROUND_CLOSEST(x, divisor)	({		\
 	typeof(divisor) __divisor = divisor;		\
 	(((x) + ((__divisor) / 2)) / (__divisor));	\
-}							\
-)
+})
 
 extern int eth_mac_addr(struct net_device *dev, void *p);
 extern int eth_change_mtu(struct net_device *dev, int new_mtu);
-- 
1.7.2.30.gc37d7.dirty

