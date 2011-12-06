Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59668 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab1LFToi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Dec 2011 14:44:38 -0500
Subject: [PATCH] wireless: disable wext sysfs by default
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Dec 2011 20:44:35 +0100
Message-ID: <1323200675.4696.24.camel@jlt3.sipsolutions.net> (sfid-20111206_204442_206189_FE3FFABF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This code has been on the list to remove for a long
time, so disable it by default, add a warning to its
Kconfig, and schedule it for removal in 3.5.

The only known dependency, hal, has not required it
since its 0.5.12 release, which was in early 2009
and hal has since been deprecated completely.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 Documentation/feature-removal-schedule.txt |    3 +--
 net/wireless/Kconfig                       |    7 ++++---
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/net/wireless/Kconfig	2011-12-06 17:06:18.000000000 +0100
+++ b/net/wireless/Kconfig	2011-12-06 20:41:08.000000000 +0100
@@ -121,15 +121,16 @@ config CFG80211_WEXT
 
 config WIRELESS_EXT_SYSFS
 	bool "Wireless extensions sysfs files"
-	default y
 	depends on WEXT_CORE && SYSFS
 	help
 	  This option enables the deprecated wireless statistics
 	  files in /sys/class/net/*/wireless/. The same information
 	  is available via the ioctls as well.
 
-	  Say Y if you have programs using it, like old versions of
-	  hal.
+	  Say N. If you know you have ancient tools requiring it,
+	  like very old versions of hal (prior to 0.5.12 release),
+	  say Y and update the tools as soon as possible as this
+	  option will be removed soon.
 
 config LIB80211
 	tristate "Common routines for IEEE802.11 drivers"
--- a/Documentation/feature-removal-schedule.txt	2011-12-06 17:06:18.000000000 +0100
+++ b/Documentation/feature-removal-schedule.txt	2011-12-06 20:41:35.000000000 +0100
@@ -263,8 +263,7 @@ Who:	Ravikiran Thirumalai <kiran@scalex8
 
 What:	Code that is now under CONFIG_WIRELESS_EXT_SYSFS
 	(in net/core/net-sysfs.c)
-When:	After the only user (hal) has seen a release with the patches
-	for enough time, probably some time in 2010.
+When:	3.4
 Why:	Over 1K .text/.data size reduction, data is available in other
 	ways (ioctls)
 Who:	Johannes Berg <johannes@sipsolutions.net>


