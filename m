Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:4900 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079Ab1HHRbY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 13:31:24 -0400
Message-ID: <4E401D62.80800@canonical.com> (sfid-20110808_193127_241996_1C940441)
Date: Mon, 08 Aug 2011 11:31:14 -0600
From: Tim Gardner <tim.gardner@canonical.com>
MIME-Version: 1.0
To: mcgrof@gmail.com
CC: linux-wireless@vger.kernel.org
Subject: [PATCH] crda - Add nested support for libnl-1, libnl-2.0, and libnl-3.0
Content-Type: multipart/mixed;
 boundary="------------070608090609070308020903"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070608090609070308020903
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

libnl-3.0 is the version used for Ubuntu Oneiric.
-- 
Tim Gardner tim.gardner@canonical.com

--------------070608090609070308020903
Content-Type: text/x-patch;
 name="0001-Add-nested-support-for-libnl-1-libnl-2.0-and-libnl-3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Add-nested-support-for-libnl-1-libnl-2.0-and-libnl-3.pa";
 filename*1="tch"

>From 339e3811bbb140253fc7c8225322a51420046df6 Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Mon, 8 Aug 2011 10:49:49 -0600
Subject: [PATCH] Add nested support for libnl-1, libnl-2.0, and libnl-3.0

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 Makefile |   21 ++++++++++++++-------
 crda.c   |    4 ++--
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/Makefile b/Makefile
index b8bc7d3..084d8e5 100644
--- a/Makefile
+++ b/Makefile
@@ -47,15 +47,22 @@ INSTALL ?= install
 
 NL1FOUND := $(shell pkg-config --atleast-version=1 libnl-1 && echo Y)
 NL2FOUND := $(shell pkg-config --atleast-version=2 libnl-2.0 && echo Y)
+NL3FOUND := $(shell pkg-config --atleast-version=3 libnl-3.0 && echo Y)
 
-ifeq ($(NL1FOUND),Y)
-NLLIBNAME = libnl-1
-endif
-
-ifeq ($(NL2FOUND),Y)
-CFLAGS += -DCONFIG_LIBNL20
+ifeq ($(NL3FOUND),Y)
+CFLAGS += -DCONFIG_LIBNL30
 NLLIBS += -lnl-genl
-NLLIBNAME = libnl-2.0
+NLLIBNAME = libnl-3.0
+else
+	ifeq ($(NL2FOUND),Y)
+	CFLAGS += -DCONFIG_LIBNL20
+	NLLIBS += -lnl-genl
+	NLLIBNAME = libnl-2.0
+	else
+		ifeq ($(NL1FOUND),Y)
+		NLLIBNAME = libnl-1
+		endif
+	endif
 endif
 
 ifeq ($(NLLIBNAME),)
diff --git a/crda.c b/crda.c
index d2ba29a..6857e3f 100644
--- a/crda.c
+++ b/crda.c
@@ -21,7 +21,7 @@
 #include "regdb.h"
 #include "reglib.h"
 
-#ifndef CONFIG_LIBNL20
+#if !defined(CONFIG_LIBNL20) && !defined(CONFIG_LIBNL30)
 /* libnl 2.0 compatibility code */
 static inline struct nl_handle *nl_socket_alloc(void)
 {
@@ -44,7 +44,7 @@ static inline int __genl_ctrl_alloc_cache(struct nl_handle *h, struct nl_cache *
 
 #define genl_ctrl_alloc_cache __genl_ctrl_alloc_cache
 #define nl_sock nl_handle
-#endif /* CONFIG_LIBNL20 */
+#endif /* CONFIG_LIBNL20 && CONFIG_LIBNL30 */
 
 struct nl80211_state {
 	struct nl_sock *nl_sock;
-- 
1.7.0.4


--------------070608090609070308020903--
