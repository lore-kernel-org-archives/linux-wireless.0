Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hhlx01.visionsystems.de ([62.145.30.242]:56647 "EHLO
	mail.visionsystems.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab1GUPG2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 11:06:28 -0400
Message-ID: <4E284069.7070603@visionsystems.de> (sfid-20110721_170631_876796_485C6C1D)
Date: Thu, 21 Jul 2011 17:06:17 +0200
From: Yegor Yefremov <yegor_sub1@visionsystems.de>
Reply-To: yegor_sub1@visionsystems.de
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2] iw: add libnl-3.0 support
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
---
Changes from v1:
- CONFIG_LIBNL30 added

 Makefile |   10 ++++++++++
 iw.c     |    7 +++----
 iw.h     |    3 ++-
 3 files changed, 15 insertions(+), 5 deletions(-)

Index: b/Makefile
===================================================================
--- a/Makefile
+++ b/Makefile
@@ -24,6 +24,7 @@
 
 NL1FOUND := $(shell $(PKG_CONFIG) --atleast-version=1 libnl-1 && echo Y)
 NL2FOUND := $(shell $(PKG_CONFIG) --atleast-version=2 libnl-2.0 && echo Y)
+NL3FOUND := $(shell $(PKG_CONFIG) --atleast-version=3 libnl-3.0 && echo Y)
 
 ifeq ($(NL1FOUND),Y)
 NLLIBNAME = libnl-1
@@ -35,6 +36,12 @@
 NLLIBNAME = libnl-2.0
 endif
 
+ifeq ($(NL3FOUND),Y)
+CFLAGS += -DCONFIG_LIBNL30
+LIBS += -lnl-genl
+NLLIBNAME = libnl-3.0
+endif
+
 ifeq ($(NLLIBNAME),)
 $(error Cannot find development files for any supported version of libnl)
 endif
@@ -53,6 +60,8 @@
 all: version_check $(ALL)
 
 version_check:
+ifeq ($(NL3FOUND),Y)
+else
 ifeq ($(NL2FOUND),Y)
 else
 ifeq ($(NL1FOUND),Y)
@@ -60,6 +69,7 @@
 	$(error No libnl found)
 endif
 endif
+endif
 
 
 VERSION_OBJS := $(filter-out version.o, $(OBJS))
Index: b/iw.c
===================================================================
--- a/iw.c
+++ b/iw.c
@@ -23,9 +23,8 @@
 #include "nl80211.h"
 #include "iw.h"
 
-#ifndef CONFIG_LIBNL20
-/* libnl 2.0 compatibility code */
-
+/* libnl 1.x compatibility code */
+#if !defined(CONFIG_LIBNL20) && !defined(CONFIG_LIBNL30)
 static inline struct nl_handle *nl_socket_alloc(void)
 {
 	return nl_handle_alloc();
@@ -45,7 +44,7 @@
 	return 0;
 }
 #define genl_ctrl_alloc_cache __genl_ctrl_alloc_cache
-#endif /* CONFIG_LIBNL20 */
+#endif /* CONFIG_LIBNL20 && CONFIG_LIBNL30 */
 
 int iw_debug = 0;
 
Index: b/iw.h
===================================================================
--- a/iw.h
+++ b/iw.h
@@ -11,7 +11,8 @@
 
 #define ETH_ALEN 6
 
-#ifndef CONFIG_LIBNL20
+/* libnl 1.x compatibility code */
+#if !defined(CONFIG_LIBNL20) && !defined(CONFIG_LIBNL30)
 #  define nl_sock nl_handle
 #endif
 

