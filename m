Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54007 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965108Ab1GMIlc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 04:41:32 -0400
Message-Id: <20110713084033.380526262@sipsolutions.net> (sfid-20110713_104142_508332_BF74CCB7)
Date: Wed, 13 Jul 2011 10:39:14 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 06/11] b43legacy: remove wireless extensions inclusions
References: <20110713083908.713123063@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

linux/wireless.h and net/iw_handler.h headers are
for wireless extensions only, so mac80211 drivers
shouldn't be including them.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/b43legacy/b43legacy.h |    1 -
 drivers/net/wireless/b43legacy/main.c      |    1 -
 2 files changed, 2 deletions(-)

--- a/drivers/net/wireless/b43legacy/b43legacy.h	2011-07-13 10:10:08.000000000 +0200
+++ b/drivers/net/wireless/b43legacy/b43legacy.h	2011-07-13 10:10:12.000000000 +0200
@@ -14,7 +14,6 @@
 #include <linux/ssb/ssb.h>
 #include <linux/ssb/ssb_driver_chipcommon.h>
 
-#include <linux/wireless.h>
 #include <net/mac80211.h>
 
 #include "debugfs.h"
--- a/drivers/net/wireless/b43legacy/main.c	2011-07-13 10:10:08.000000000 +0200
+++ b/drivers/net/wireless/b43legacy/main.c	2011-07-13 10:10:14.000000000 +0200
@@ -35,7 +35,6 @@
 #include <linux/if_arp.h>
 #include <linux/etherdevice.h>
 #include <linux/firmware.h>
-#include <linux/wireless.h>
 #include <linux/workqueue.h>
 #include <linux/sched.h>
 #include <linux/skbuff.h>


