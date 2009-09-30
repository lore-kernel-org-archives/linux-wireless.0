Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:1403 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842AbZI3RAH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2009 13:00:07 -0400
To: linux-wireless@vger.kernel.org
Subject: [PATCH] compat-wireless: Fix b44 build issues.
Cc: lrodriguez@atheros.com
Message-Id: <20090930170000.09582F88DD@sepang.rtg.net>
Date: Wed, 30 Sep 2009 11:00:00 -0600 (MDT)
From: timg@tpi.com (Tim Gardner)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 553180d80860c6090b7d82f809ea7131afca01d6 Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Wed, 30 Sep 2009 10:02:35 -0600
Subject: [PATCH] compat-wireless: Fix b44 build issues.

Even though CONFIG_B44 is defined, there is no Makefile
created in drivers/net. This failure to build allows the
in-kernel version of b44 to get loaded with a compat-wireless
version of ssb.ko, never a good thing.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 Makefile                |    1 +
 scripts/admin-update.sh |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Makefile b/Makefile
index c7333a2..fa9aadc 100644
--- a/Makefile
+++ b/Makefile
@@ -24,6 +24,7 @@ ifeq ($(ONLY_CORE),)
 obj-m += \
 	drivers/ssb/ \
 	drivers/misc/eeprom/ \
+	drivers/net/ \
 	drivers/net/usb/ \
 	drivers/net/wireless/
 endif
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index c65952d..cb42fe7 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -149,6 +149,7 @@ done
 # b44 is dependent on ssb, so its has to be rebuilt as well.
 DIR="drivers/net"
 cp $GIT_TREE/$DIR/b44.[ch] $DIR
+echo "obj-m += b44.o" > $DIR/Makefile
 
 # Misc
 mkdir -p drivers/misc/eeprom/
-- 
1.6.2.4

