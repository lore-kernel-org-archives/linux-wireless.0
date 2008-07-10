Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45551 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbYGJJRf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 05:17:35 -0400
Subject: [PATCH] wext: make sysfs bits optional and deprecate them
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>, Jean Tourrilhes <jt@hpl.hp.com>
Content-Type: text/plain
Date: Thu, 10 Jul 2008 11:16:47 +0200
Message-Id: <1215681407.3932.10.camel@johannes.berg> (sfid-20080710_111738_825714_DF5C487B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The /sys/class/net/*/wireless/ direcory is, as far as I know, not
used by anyone. Additionally, the same data is available via wext
ioctls. Hence the sysfs files are pretty much useless. This patch
makes them optional and schedules them for removal.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Jean Tourrilhes <jt@hpl.hp.com>
---
The only known user was hal
(http://www.freedesktop.org/wiki/Software/hal) and I have removed those,
the patches are in the git repository for the next release.

 Documentation/feature-removal-schedule.txt |   10 ++++++++++
 net/core/net-sysfs.c                       |    4 ++--
 net/wireless/Kconfig                       |   11 +++++++++++
 3 files changed, 23 insertions(+), 2 deletions(-)

--- everything.orig/net/core/net-sysfs.c	2008-07-10 10:23:08.000000000 +0200
+++ everything/net/core/net-sysfs.c	2008-07-10 10:26:25.000000000 +0200
@@ -318,7 +318,7 @@ static struct attribute_group netstat_gr
 	.attrs  = netstat_attrs,
 };
 
-#ifdef CONFIG_WIRELESS_EXT
+#ifdef CONFIG_WIRELESS_EXT_SYSFS
 /* helper function that does all the locking etc for wireless stats */
 static ssize_t wireless_show(struct device *d, char *buf,
 			     ssize_t (*format)(const struct iw_statistics *,
@@ -460,7 +460,7 @@ int netdev_register_kobject(struct net_d
 	if (net->get_stats)
 		*groups++ = &netstat_group;
 
-#ifdef CONFIG_WIRELESS_EXT
+#ifdef CONFIG_WIRELESS_EXT_SYSFS
 	if (net->wireless_handlers && net->wireless_handlers->get_wireless_stats)
 		*groups++ = &wireless_group;
 #endif
--- everything.orig/net/wireless/Kconfig	2008-07-10 08:47:16.000000000 +0200
+++ everything/net/wireless/Kconfig	2008-07-10 10:26:25.000000000 +0200
@@ -29,3 +29,14 @@ config WIRELESS_EXT
 
 	  Say N (if you can) unless you know you need wireless
 	  extensions for external modules.
+
+config WIRELESS_EXT_SYSFS
+	bool "Wireless extensions sysfs files"
+	default y
+	depends on WIRELESS_EXT && SYSFS
+	help
+	  This option enables the deprecated wireless statistics
+	  files in /sys/class/net/*/wireless/. The same information
+	  is available via the ioctls as well.
+
+	  Say Y if you have programs using it (we don't know of any).
--- everything.orig/Documentation/feature-removal-schedule.txt	2008-07-10 10:23:19.000000000 +0200
+++ everything/Documentation/feature-removal-schedule.txt	2008-07-10 11:15:56.000000000 +0200
@@ -280,6 +280,16 @@ Why:	Not used in-tree. The current out-o
 	out-of-tree driver.
 Who:	Thomas Gleixner <tglx@linutronix.de>
 
+---------------------------
+
+What:	Code that is now under CONFIG_WIRELESS_EXT_SYSFS
+	(in net/core/net-sysfs.c)
+When:	After the only user (hal) has seen a release with the patches
+	for enough time, probably some time in 2010.
+Why:	Over 1K .text/.data size reduction, data is available in other
+	ways (ioctls)
+Who:	Johannes Berg <johannes@sipsolutions.net>
+
 ----------------------------
 
 What:	usedac i386 kernel parameter


