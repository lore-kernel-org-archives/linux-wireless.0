Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sender163-mail.zoho.com ([74.201.84.163]:25296 "EHLO
	sender163-mail.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbcBWSnj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 13:43:39 -0500
Date: Tue, 23 Feb 2016 20:43:34 +0200
From: Dima Krasner <dima@dimakrasner.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] iw: add libnl-tiny support
Message-Id: <20160223204334.4a65ab8113dbe31fbffc56ff@dimakrasner.com> (sfid-20160223_194343_135265_7B7CCCFB)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows small static builds, especially when using musl libc.

Signed-off-by: Dima Krasner <dima@dimakrasner.com>
---
 Makefile |  8 ++++++++
 iw.c     | 10 ++++++++--
 iw.h     |  2 +-
 3 files changed, 17 insertions(+), 3 deletions(-)

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
index 0f511d9..f702e92 100644
--- a/iw.c
+++ b/iw.c
@@ -23,8 +23,14 @@
 #include "nl80211.h"
 #include "iw.h"
 
+#ifdef CONFIG_LIBNL_TINY
+#define nl_handle nl_sock
+#define nl_handle_alloc_cb nl_socket_alloc_cb
+#define nl_handle_destroy nl_socket_free
+#endif
+
 /* libnl 1.x compatibility code */
-#if !defined(CONFIG_LIBNL20) && !defined(CONFIG_LIBNL30)
+#if !defined(CONFIG_LIBNL20) && !defined(CONFIG_LIBNL30) && !defined(CONFIG_LIBNL_TINY)
 static inline struct nl_handle *nl_socket_alloc(void)
 {
 	return nl_handle_alloc();
@@ -40,7 +46,7 @@ static inline int nl_socket_set_buffer_size(struct nl_sock *sk,
 {
 	return nl_set_buffer_size(sk, rxbuf, txbuf);
 }
-#endif /* CONFIG_LIBNL20 && CONFIG_LIBNL30 */
+#endif /* CONFIG_LIBNL20 && CONFIG_LIBNL30 && CONFIG_LIBNL_TINY */
 
 int iw_debug = 0;
 
diff --git a/iw.h b/iw.h
index d91a33e..dcac930 100644
--- a/iw.h
+++ b/iw.h
@@ -14,7 +14,7 @@
 #define ETH_ALEN 6
 
 /* libnl 1.x compatibility code */
-#if !defined(CONFIG_LIBNL20) && !defined(CONFIG_LIBNL30)
+#if !defined(CONFIG_LIBNL20) && !defined(CONFIG_LIBNL30) && !defined(CONFIG_LIBNL_TINY)
 #  define nl_sock nl_handle
 #endif
 
-- 
2.1.4


