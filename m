Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:16142 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753725Ab0IQAIM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 20:08:12 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 16 Sep 2010 17:08:05 -0700
From: Vipin Mehta <vmehta@atheros.com>
To: <greg@kroah.com>
CC: <linux-wireless@vger.kernel.org>, <vmehta@atheros.com>,
	<devel@driverdev.osuosl.org>
Subject: [PATCH] staging: ath6kl: Including a header file to fix a compilation error
Date: Thu, 16 Sep 2010 17:08:07 -0700
Message-ID: <1284682087-19351-1-git-send-email-vmehta@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit fixes a compilation error that was encountered while using a specific kernel configuration file. The problem was the use of some fuunctions defined in <linux/semaphore.h> without including the header file explicitly. It was probably working before because of the dependency getting implicitly satisfied via some other header file. Also, eliminating the inclusion of the same header file more than once. The code needs additional cleanup and may be addressed by a subsequent commit.

Signed-off-by: Vipin Mehta <vmehta@atheros.com>
---
 .../staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h   |    4 ----
 drivers/staging/ath6kl/os/linux/cfg80211.c         |    2 --
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |    8 --------
 .../staging/ath6kl/os/linux/include/osapi_linux.h  |    1 +
 drivers/staging/ath6kl/os/linux/netbuf.c           |    2 --
 5 files changed, 1 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h
index 4358834..4e5b7bf 100644
--- a/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h
+++ b/drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsconfig.h
@@ -36,15 +36,11 @@
 
 #include <linux/fs.h>
 #include <linux/errno.h>
-#include <linux/string.h>
 #include <linux/signal.h>
-#include <linux/timer.h>
 
 
 #include <linux/ioctl.h>
-#include <linux/skbuff.h>
 #include <linux/firmware.h>
-#include <linux/wait.h>
 
 
 #include <net/bluetooth/bluetooth.h>
diff --git a/drivers/staging/ath6kl/os/linux/cfg80211.c b/drivers/staging/ath6kl/os/linux/cfg80211.c
index 7a3784d..f51c5e1 100644
--- a/drivers/staging/ath6kl/os/linux/cfg80211.c
+++ b/drivers/staging/ath6kl/os/linux/cfg80211.c
@@ -21,8 +21,6 @@
 // Author(s): ="Atheros"
 //------------------------------------------------------------------------------
 
-#include <linux/kernel.h>
-#include <linux/netdevice.h>
 #include <linux/wireless.h>
 #include <linux/ieee80211.h>
 #include <net/cfg80211.h>
diff --git a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
index 8be4f55..e624883 100644
--- a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
+++ b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
@@ -24,22 +24,14 @@
 #ifndef _AR6000_H_
 #define _AR6000_H_
 
-#include <linux/version.h>
-
-
-#include <generated/autoconf.h>
 #include <linux/init.h>
-#include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/spinlock.h>
-#include <linux/skbuff.h>
 #include <linux/if_ether.h>
-#include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <net/iw_handler.h>
 #include <linux/if_arp.h>
 #include <linux/ip.h>
-#include <linux/semaphore.h>
 #include <linux/wireless.h>
 #ifdef ATH6K_CONFIG_CFG80211
 #include <net/cfg80211.h>
diff --git a/drivers/staging/ath6kl/os/linux/include/osapi_linux.h b/drivers/staging/ath6kl/os/linux/include/osapi_linux.h
index ef7cc82..9892dfc 100644
--- a/drivers/staging/ath6kl/os/linux/include/osapi_linux.h
+++ b/drivers/staging/ath6kl/os/linux/include/osapi_linux.h
@@ -39,6 +39,7 @@
 #include <linux/timer.h>
 #include <linux/delay.h>
 #include <linux/wait.h>
+#include <linux/semaphore.h>
 
 #include <linux/cache.h>
 
diff --git a/drivers/staging/ath6kl/os/linux/netbuf.c b/drivers/staging/ath6kl/os/linux/netbuf.c
index 63fa49c..15e5d04 100644
--- a/drivers/staging/ath6kl/os/linux/netbuf.c
+++ b/drivers/staging/ath6kl/os/linux/netbuf.c
@@ -20,8 +20,6 @@
 //
 // Author(s): ="Atheros"
 //------------------------------------------------------------------------------
-#include <linux/kernel.h>
-#include <linux/skbuff.h>
 #include <a_config.h>
 #include "athdefs.h"
 #include "a_types.h"
-- 
1.6.3.3

