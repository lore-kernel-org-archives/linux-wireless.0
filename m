Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sender163-mail.zoho.com ([74.201.84.163]:25974 "EHLO
	sender163-mail.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbcCEPL2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Mar 2016 10:11:28 -0500
Date: Sat, 5 Mar 2016 17:11:22 +0200
From: Dima Krasner <dima@dimakrasner.com>
To: linux-wireless@vger.kernel.org
Cc: Dima Krasner <dima@dimakrasner.com>
Subject: [PATCH] iw: add libnl-tiny support, reimplemented
Message-Id: <20160305171122.80c2d9a224a4b9632f40585e@dimakrasner.com> (sfid-20160305_161132_233778_7EAE0343)
In-Reply-To: <20160223204334.4a65ab8113dbe31fbffc56ff@dimakrasner.com>
References: <20160223204334.4a65ab8113dbe31fbffc56ff@dimakrasner.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows small static builds, especially when using musl libc.

Signed-off-by: Dima Krasner <dima@dimakrasner.com>
---
 Makefile | 8 ++++++++
 iw.c     | 4 ++--
 iw.h     | 2 +-
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index e61825e..4077020 100644
--- a/Makefile
+++ b/Makefile
@@ -27,6 +27,8 @@ OBJS += $(OBJS-y) $(OBJS-Y)
 ALL = iw
 
 ifeq ($(NO_PKG_CONFIG),)
+NLTINYFOUND := $(shell $(PKG_CONFIG) libnl-tiny && echo Y)
+ifneq ($(NLTINYFOUND),Y)
 NL3xFOUND := $(shell $(PKG_CONFIG) --atleast-version=3.2 libnl-3.0 && echo Y)
 ifneq ($(NL3xFOUND),Y)
 NL31FOUND := $(shell $(PKG_CONFIG) --exact-version=3.1 libnl-3.1 && echo Y)
@@ -40,6 +42,12 @@ endif
 endif
 endif
 endif
+endif
+
+ifeq ($(NLTINYFOUND),Y)
+CFLAGS += -DCONFIG_LIBNL_TINY
+NLLIBNAME = libnl-tiny
+endif
 
 ifeq ($(NL1FOUND),Y)
 NLLIBNAME = libnl-1
diff --git a/iw.c b/iw.c
index 0f511d9..c52d7ba 100644
--- a/iw.c
+++ b/iw.c
@@ -24,7 +24,7 @@
 #include "iw.h"
 
 /* libnl 1.x compatibility code */
-#if !defined(CONFIG_LIBNL20) && !defined(CONFIG_LIBNL30)
+#if !defined(CONFIG_LIBNL20) && !defined(CONFIG_LIBNL30) && !defined(CONFIG_LIBNL_TINY)
 static inline struct nl_handle *nl_socket_alloc(void)
 {
 	return nl_handle_alloc();
@@ -40,7 +40,7 @@ static inline int nl_socket_set_buffer_size(struct nl_sock *sk,
 {
 	return nl_set_buffer_size(sk, rxbuf, txbuf);
 }
-#endif /* CONFIG_LIBNL20 && CONFIG_LIBNL30 */
+#endif /* CONFIG_LIBNL20 && CONFIG_LIBNL30 && CONFIG_LIBNL_TINY */
 
 int iw_debug = 0;
 
diff --git a/iw.h b/iw.h
index d91a33e..37757d4 100644
--- a/iw.h
+++ b/iw.h
@@ -13,7 +13,7 @@
 
 #define ETH_ALEN 6
 
-/* libnl 1.x compatibility code */
+/* libnl 1.x and libnl-tiny compatibility code */
 #if !defined(CONFIG_LIBNL20) && !defined(CONFIG_LIBNL30)
 #  define nl_sock nl_handle
 #endif
-- 
2.1.4

-- 
Dima Krasner <dima@dimakrasner.com>

