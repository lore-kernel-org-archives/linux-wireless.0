Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:60146 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753039Ab1LSU1g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 15:27:36 -0500
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: [PATCH] crda: add nested support for libnl-3.2
Date: Mon, 19 Dec 2011 21:27:15 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201112192127.25032.s.L-H@gmx.de> (sfid-20111219_212745_220505_443972B7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Skip libnl-3.1 due to broken .pc files.

Tested to work with:
- libnl-3.2.3 (Debian 3.2.3-1)

Changes-licensed-under: ISC
Signed-off-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
---
 Makefile |   25 ++++++++++++++++---------
 crda.c   |    4 ++--
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/Makefile b/Makefile
index 084d8e5..5a8ed46 100644
--- a/Makefile
+++ b/Makefile
@@ -48,19 +48,26 @@ INSTALL ?= install
 NL1FOUND := $(shell pkg-config --atleast-version=1 libnl-1 && echo Y)
 NL2FOUND := $(shell pkg-config --atleast-version=2 libnl-2.0 && echo Y)
 NL3FOUND := $(shell pkg-config --atleast-version=3 libnl-3.0 && echo Y)
+NL32FOUND := $(shell pkg-config --atleast-version=3 libnl-3.2 && echo Y)
 
-ifeq ($(NL3FOUND),Y)
+ifeq ($(NL32FOUND),Y)
 CFLAGS += -DCONFIG_LIBNL30
-NLLIBS += -lnl-genl
-NLLIBNAME = libnl-3.0
+NLLIBS += $(shell pkg-config --libs libnl-genl-3.2)
+NLLIBNAME = libnl-3.2
 else
-	ifeq ($(NL2FOUND),Y)
-	CFLAGS += -DCONFIG_LIBNL20
-	NLLIBS += -lnl-genl
-	NLLIBNAME = libnl-2.0
+	ifeq ($(NL3FOUND),Y)
+	CFLAGS += -DCONFIG_LIBNL30
+	NLLIBS += $(shell pkg-config --libs libnl-genl-3.0)
+	NLLIBNAME = libnl-3.0
 	else
-		ifeq ($(NL1FOUND),Y)
-		NLLIBNAME = libnl-1
+		ifeq ($(NL2FOUND),Y)
+		CFLAGS += -DCONFIG_LIBNL20
+		NLLIBS += -lnl-genl
+		NLLIBNAME = libnl-2.0
+		else
+			ifeq ($(NL1FOUND),Y)
+			NLLIBNAME = libnl-1
+			endif
 		endif
 	endif
 endif
diff --git a/crda.c b/crda.c
index 1e2ff22..1db54a5 100644
--- a/crda.c
+++ b/crda.c
@@ -21,7 +21,7 @@
 #include "regdb.h"
 #include "reglib.h"
 
-#if !defined(CONFIG_LIBNL20) && !defined(CONFIG_LIBNL30)
+#if !defined(CONFIG_LIBNL20) && !defined(CONFIG_LIBNL30) && !defined(CONFIG_LIBNL32)
 /* libnl 2.0 compatibility code */
 static inline struct nl_handle *nl_socket_alloc(void)
 {
@@ -44,7 +44,7 @@ static inline int __genl_ctrl_alloc_cache(struct nl_handle *h, struct nl_cache *
 
 #define genl_ctrl_alloc_cache __genl_ctrl_alloc_cache
 #define nl_sock nl_handle
-#endif /* CONFIG_LIBNL20 && CONFIG_LIBNL30 */
+#endif /* CONFIG_LIBNL20 && CONFIG_LIBNL30 && CONFIG_LIBNL32 */
 
 struct nl80211_state {
 	struct nl_sock *nl_sock;
-- 
1.7.7.3

