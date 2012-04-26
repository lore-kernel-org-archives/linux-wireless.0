Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39368 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758337Ab2DZSIm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 14:08:42 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC c 9/9] compat: do not include compat-2.6.h
Date: Thu, 26 Apr 2012 20:07:54 +0200
Message-Id: <1335463674-13003-14-git-send-email-hauke@hauke-m.de> (sfid-20120426_200847_825511_542B6C92)
In-Reply-To: <1335463674-13003-1-git-send-email-hauke@hauke-m.de>
References: <1335463674-13003-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 Makefile               |    1 -
 include/linux/rfkill.h |    2 --
 2 files changed, 3 deletions(-)

diff --git a/Makefile b/Makefile
index 8775294..d67356a 100644
--- a/Makefile
+++ b/Makefile
@@ -31,7 +31,6 @@ else
 # when building our compat modules. Your own makefile would look
 # the same.
 NOSTDINC_FLAGS := -I$(M)/include/ \
-	-include $(M)/include/linux/compat-2.6.h \
 	$(CFLAGS) \
 	-DCOMPAT_BASE_TREE="\"$(COMPAT_BASE_TREE)\"" \
 	-DCOMPAT_BASE_TREE_VERSION="\"$(COMPAT_BASE_TREE_VERSION)\"" \
diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
index d615ac9..d31b22c 100644
--- a/include/linux/rfkill.h
+++ b/include/linux/rfkill.h
@@ -7,8 +7,6 @@
 
 #else
 
-#include <linux/compat-2.6.h>
-
 #undef CONFIG_RFKILL
 #undef CONFIG_RFKILL_INPUT
 #undef CONFIG_RFKILL_LEDS
-- 
1.7.9.5

