Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39302 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758247Ab2DZSIP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 14:08:15 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC c-w 1/4] compat-wireless: fix header of compat-autoconf.h
Date: Thu, 26 Apr 2012 20:07:43 +0200
Message-Id: <1335463674-13003-3-git-send-email-hauke@hauke-m.de> (sfid-20120426_200819_626472_95863FD1)
In-Reply-To: <1335463674-13003-1-git-send-email-hauke@hauke-m.de>
References: <1335463674-13003-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 scripts/gen-compat-autoconf.sh |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/scripts/gen-compat-autoconf.sh b/scripts/gen-compat-autoconf.sh
index c7bdd38..3b49565 100755
--- a/scripts/gen-compat-autoconf.sh
+++ b/scripts/gen-compat-autoconf.sh
@@ -130,14 +130,13 @@ function kernel_version_req {
 }
 
 cat <<EOF
-#ifndef COMPAT_AUTOCONF_INCLUDED
-#define COMPAT_AUTOCONF_INCLUDED
 /*
  * Automatically generated C config: don't edit
  * $DATE 
  * compat-wireless-2.6: $CREL
  * linux-2.6: $KREL
  */
+#include <linux/version.h>
 #define COMPAT_RELEASE "$CREL"
 #define COMPAT_KERNEL_RELEASE "$KREL"
 EOF
@@ -201,4 +200,3 @@ if [ -f $KLIB_BUILD/Makefile ]; then
 		rm -f $MULT_DEP_FILE
 	fi
 fi
-echo "#endif /* COMPAT_AUTOCONF_INCLUDED */"
-- 
1.7.9.5

