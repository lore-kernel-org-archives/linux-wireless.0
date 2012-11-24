Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:40324 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab2KXOTm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2012 09:19:42 -0500
Received: by mail-wi0-f178.google.com with SMTP id hm6so2253799wib.1
        for <linux-wireless@vger.kernel.org>; Sat, 24 Nov 2012 06:19:41 -0800 (PST)
Message-ID: <1353766774.2318.1.camel@user64-MCP7A> (sfid-20121124_151948_739246_C8CD70B8)
Subject: [PATCH 01/10] staging: vt6656: fix headers and add cfg80211.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sat, 24 Nov 2012 14:19:34 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


 Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

---
 drivers/staging/vt6656/80211mgr.c |    2 +-
 drivers/staging/vt6656/device.h   |   39 ++++++++++++-------------------------
 drivers/staging/vt6656/key.c      |    2 +-
 drivers/staging/vt6656/wpa2.c     |    2 +-
 4 files changed, 15 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/vt6656/80211mgr.c b/drivers/staging/vt6656/80211mgr.c
index 39f9842..e6ced95 100644
--- a/drivers/staging/vt6656/80211mgr.c
+++ b/drivers/staging/vt6656/80211mgr.c
@@ -52,11 +52,11 @@
  *
  */
 
+#include "device.h"
 #include "tmacro.h"
 #include "tether.h"
 #include "80211mgr.h"
 #include "80211hdr.h"
-#include "device.h"
 #include "wpa.h"
 
 /*---------------------  Static Definitions -------------------------*/
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 2595ac5..9a04900 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -30,43 +30,28 @@
 #define __DEVICE_H__
 
 #include <linux/module.h>
-#include <linux/types.h>
-#include <linux/init.h>
-#include <linux/mm.h>
-#include <linux/errno.h>
-#include <linux/ioport.h>
-#include <linux/pci.h>
 #include <linux/kernel.h>
-#include <linux/netdevice.h>
-#include <linux/etherdevice.h>
-#include <linux/skbuff.h>
-#include <linux/delay.h>
-#include <linux/timer.h>
 #include <linux/slab.h>
-#include <linux/interrupt.h>
-#include <linux/string.h>
-#include <linux/wait.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/firmware.h>
+#include <linux/etherdevice.h>
+#include <linux/suspend.h>
 #include <linux/if_arp.h>
-#include <linux/sched.h>
-#include <linux/if.h>
-#include <linux/rtnetlink.h>//James
-#include <linux/proc_fs.h>
-#include <linux/inetdevice.h>
-#include <linux/reboot.h>
+#include <linux/wireless.h>
+#include <net/iw_handler.h>
+#include <net/cfg80211.h>
+#include <linux/timer.h>
 #include <linux/usb.h>
-#include <linux/signal.h>
-#include <linux/firmware.h>
-#include <asm/io.h>
-#include <asm/uaccess.h>
+
+
 #ifdef SIOCETHTOOL
 #define DEVICE_ETHTOOL_IOCTL_SUPPORT
 #include <linux/ethtool.h>
 #else
 #undef DEVICE_ETHTOOL_IOCTL_SUPPORT
 #endif
-/* Include Wireless Extension definition and check version - Jean II */
-#include <linux/wireless.h>
-#include <net/iw_handler.h>	// New driver API
 
 //please copy below macro to driver_event.c for API
 #define RT_INSMOD_EVENT_FLAG                             0x0101
diff --git a/drivers/staging/vt6656/key.c b/drivers/staging/vt6656/key.c
index bf24adb..8c78b86 100644
--- a/drivers/staging/vt6656/key.c
+++ b/drivers/staging/vt6656/key.c
@@ -36,9 +36,9 @@
  *
  */
 
+#include "mac.h"
 #include "tmacro.h"
 #include "key.h"
-#include "mac.h"
 #include "rndis.h"
 #include "control.h"
 
diff --git a/drivers/staging/vt6656/wpa2.c b/drivers/staging/vt6656/wpa2.c
index c092697..616e24d 100644
--- a/drivers/staging/vt6656/wpa2.c
+++ b/drivers/staging/vt6656/wpa2.c
@@ -31,8 +31,8 @@
  *
  */
 
-#include "wpa2.h"
 #include "device.h"
+#include "wpa2.h"
 
 /*---------------------  Static Definitions -------------------------*/
 static int          msglevel                =MSG_LEVEL_INFO;
-- 
1.7.10.4



