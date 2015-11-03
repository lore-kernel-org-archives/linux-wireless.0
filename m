Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sender163-mail.zoho.com ([74.201.84.163]:25067 "EHLO
	sender163-mail.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932711AbbKCWOJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 17:14:09 -0500
Date: Wed, 4 Nov 2015 00:14:03 +0200
From: Dima Krasner <dima@dimakrasner.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] iw: Add libnl-tiny support
Message-Id: <20151104001403.b089ac337e3d7b719e01d501@dimakrasner.com> (sfid-20151103_231417_950461_E1764E2E)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Wed__4_Nov_2015_00_14_03_+0200_SVuheWIh3ew=N86i"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.

--Multipart=_Wed__4_Nov_2015_00_14_03_+0200_SVuheWIh3ew=N86i
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi,

I'd like to upstream this patch, which adds libnl-tiny support to iw, as a smaller alternative to libnl 2.0. It's great for static builds against musl.

Cheers,
Dima 

>From 88ad01745f6f8b2d5fcc066d18dba9dce21609fd Mon Sep 17 00:00:00 2001
From: Dima Krasner <dima@dimakrasner.com>
Date: Wed, 4 Nov 2015 00:04:44 +0200
Subject: [PATCH] Added libnl-tiny support

---
 Makefile |  8 ++++++++
 iw.c     | 10 ++++++++--
 iw.h     |  2 +-
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index e61825e..63169a3 100644
--- a/Makefile
+++ b/Makefile
@@ -27,6 +27,8 @@ OBJS += $(OBJS-y) $(OBJS-Y)
 ALL = iw
 
 ifeq ($(NO_PKG_CONFIG),)
+NLTINYFOUND := $(shell $(PKG_CONFIG) --atleast-version=1 libnl-tiny && echo Y)
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
index 263e8b1..93813be 100644
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
1.9.1



-- 
Dima Krasner <dima@dimakrasner.com>

--Multipart=_Wed__4_Nov_2015_00_14_03_+0200_SVuheWIh3ew=N86i
Content-Type: text/x-diff;
 name="0001-Added-libnl-tiny-support.patch"
Content-Disposition: attachment;
 filename="0001-Added-libnl-tiny-support.patch"
Content-Transfer-Encoding: 7bit

>From 88ad01745f6f8b2d5fcc066d18dba9dce21609fd Mon Sep 17 00:00:00 2001
From: Dima Krasner <dima@dimakrasner.com>
Date: Wed, 4 Nov 2015 00:04:44 +0200
Subject: [PATCH] Added libnl-tiny support

---
 Makefile |  8 ++++++++
 iw.c     | 10 ++++++++--
 iw.h     |  2 +-
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index e61825e..63169a3 100644
--- a/Makefile
+++ b/Makefile
@@ -27,6 +27,8 @@ OBJS += $(OBJS-y) $(OBJS-Y)
 ALL = iw
 
 ifeq ($(NO_PKG_CONFIG),)
+NLTINYFOUND := $(shell $(PKG_CONFIG) --atleast-version=1 libnl-tiny && echo Y)
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
index 263e8b1..93813be 100644
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
1.9.1


--Multipart=_Wed__4_Nov_2015_00_14_03_+0200_SVuheWIh3ew=N86i--

