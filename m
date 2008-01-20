Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from a.mail.sonic.net ([64.142.16.245]:34619 "EHLO a.mail.sonic.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208AbYATNmA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jan 2008 08:42:00 -0500
Date: Sun, 20 Jan 2008 05:09:06 -0800
Message-Id: <200801201309.m0KD96QV022222@bolt.sonic.net> (sfid-20080120_134208_377496_DCED4EB3)
To: linux-wireless@vger.kernel.org
from: Brad Allen <ulmo+linux-wireless@sonic.net>
reply-to: ulmo+linux-wireless@sonic.net
Subject: bug in compat-wireless-2.6/net/ieee80211/ieee80211_module.c
         in release kernels
cc: ulmo+linux-wireless@sonic.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm running latest release kernel (2.6.23.14, not mm, not rc, not
anything weird), and got latest compat-wireless-2.6 (couldn't figure
out how to build git quickly enough), and ran into only one compile
problem:

compat-wireless-2.6:8354$0 make
make -C /lib/modules/2.6.23.14ulmo-i/build M=/w/src/broadcom/wireless-dev/compat-wireless-2.6 modules
make[1]: Entering directory `/mnt/src/linux-2.6.23.14'
  CC [M]  /w/src/broadcom/wireless-dev/compat-wireless-2.6/net/ieee80211/ieee80211_module.o
/w/src/broadcom/wireless-dev/compat-wireless-2.6/net/ieee80211/ieee80211_module.c: In function 'ieee80211_init':
/w/src/broadcom/wireless-dev/compat-wireless-2.6/net/ieee80211/ieee80211_module.c:270: error: 'init_net' undeclared (first use in this function)
/w/src/broadcom/wireless-dev/compat-wireless-2.6/net/ieee80211/ieee80211_module.c:270: error: (Each undeclared identifier is reported only once
/w/src/broadcom/wireless-dev/compat-wireless-2.6/net/ieee80211/ieee80211_module.c:270: error: for each function it appears in.)
/w/src/broadcom/wireless-dev/compat-wireless-2.6/net/ieee80211/ieee80211_module.c: In function 'ieee80211_exit':
/w/src/broadcom/wireless-dev/compat-wireless-2.6/net/ieee80211/ieee80211_module.c:299: error: 'init_net' undeclared (first use in this function)
make[3]: *** [/w/src/broadcom/wireless-dev/compat-wireless-2.6/net/ieee80211/ieee80211_module.o] Error 1
make[2]: *** [/w/src/broadcom/wireless-dev/compat-wireless-2.6/net/ieee80211] Error 2
make[1]: *** [_module_/w/src/broadcom/wireless-dev/compat-wireless-2.6] Error 2
make[1]: Leaving directory `/mnt/src/linux-2.6.23.14'
make: *** [modules] Error 2
compat-wireless-2.6:8355$2 

I noticed it is defined in the latest GIT thing, so I figured it is a
too-new item.  Here's a small patch that worked around that, since it
was just debugging anyway:

--- compat-wireless-2.6/net/ieee80211/ieee80211_module.c.~1~	2008-01-19 21:10:45.000000000 -0800
+++ compat-wireless-2.6/net/ieee80211/ieee80211_module.c	2008-01-20 05:02:07.000000000 -0800
@@ -264,6 +264,7 @@
 static int __init ieee80211_init(void)
 {
 #ifdef CONFIG_IEEE80211_DEBUG
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,24))
 	struct proc_dir_entry *e;
 
 	ieee80211_debug_level = debug;
@@ -283,6 +284,7 @@
 	e->read_proc = show_debug_level;
 	e->write_proc = store_debug_level;
 	e->data = NULL;
+#endif				/* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,24)) */
 #endif				/* CONFIG_IEEE80211_DEBUG */
 
 	printk(KERN_INFO DRV_NAME ": " DRV_DESCRIPTION ", " DRV_VERSION "\n");
@@ -294,11 +296,13 @@
 static void __exit ieee80211_exit(void)
 {
 #ifdef CONFIG_IEEE80211_DEBUG
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,24))
 	if (ieee80211_proc) {
 		remove_proc_entry("debug_level", ieee80211_proc);
 		remove_proc_entry(DRV_NAME, init_net.proc_net);
 		ieee80211_proc = NULL;
 	}
+#endif				/* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,24)) */
 #endif				/* CONFIG_IEEE80211_DEBUG */
 }
 
