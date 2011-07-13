Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54001 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965029Ab1GMIl2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 04:41:28 -0400
Message-Id: <20110713084032.135463902@sipsolutions.net> (sfid-20110713_104132_512955_53891287)
Date: Wed, 13 Jul 2011 10:39:11 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 03/11] iwlegacy: remove wireless extensions inclusions
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
 drivers/net/wireless/iwlegacy/iwl-3945-led.c |    1 -
 drivers/net/wireless/iwlegacy/iwl-3945-rs.c  |    1 -
 drivers/net/wireless/iwlegacy/iwl-3945.c     |    1 -
 drivers/net/wireless/iwlegacy/iwl-4965-led.c |    1 -
 drivers/net/wireless/iwlegacy/iwl-4965-rs.c  |    1 -
 drivers/net/wireless/iwlegacy/iwl-4965.c     |    1 -
 drivers/net/wireless/iwlegacy/iwl-led.c      |    1 -
 drivers/net/wireless/iwlegacy/iwl3945-base.c |    1 -
 drivers/net/wireless/iwlegacy/iwl4965-base.c |    1 -
 9 files changed, 9 deletions(-)

--- a/drivers/net/wireless/iwlegacy/iwl-3945-led.c	2011-07-13 10:03:26.000000000 +0200
+++ b/drivers/net/wireless/iwlegacy/iwl-3945-led.c	2011-07-13 10:03:29.000000000 +0200
@@ -32,7 +32,6 @@
 #include <linux/delay.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
-#include <linux/wireless.h>
 #include <net/mac80211.h>
 #include <linux/etherdevice.h>
 #include <asm/unaligned.h>
--- a/drivers/net/wireless/iwlegacy/iwl-3945-rs.c	2011-07-13 10:03:26.000000000 +0200
+++ b/drivers/net/wireless/iwlegacy/iwl-3945-rs.c	2011-07-13 10:03:30.000000000 +0200
@@ -28,7 +28,6 @@
 #include <linux/init.h>
 #include <linux/skbuff.h>
 #include <linux/slab.h>
-#include <linux/wireless.h>
 #include <net/mac80211.h>
 
 #include <linux/netdevice.h>
--- a/drivers/net/wireless/iwlegacy/iwl-3945.c	2011-07-13 10:03:26.000000000 +0200
+++ b/drivers/net/wireless/iwlegacy/iwl-3945.c	2011-07-13 10:03:31.000000000 +0200
@@ -34,7 +34,6 @@
 #include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
-#include <linux/wireless.h>
 #include <linux/firmware.h>
 #include <linux/etherdevice.h>
 #include <asm/unaligned.h>
--- a/drivers/net/wireless/iwlegacy/iwl-4965-led.c	2011-07-13 10:03:26.000000000 +0200
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-led.c	2011-07-13 10:03:32.000000000 +0200
@@ -32,7 +32,6 @@
 #include <linux/delay.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
-#include <linux/wireless.h>
 #include <net/mac80211.h>
 #include <linux/etherdevice.h>
 #include <asm/unaligned.h>
--- a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c	2011-07-13 10:03:26.000000000 +0200
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c	2011-07-13 10:03:33.000000000 +0200
@@ -27,7 +27,6 @@
 #include <linux/init.h>
 #include <linux/skbuff.h>
 #include <linux/slab.h>
-#include <linux/wireless.h>
 #include <net/mac80211.h>
 
 #include <linux/netdevice.h>
--- a/drivers/net/wireless/iwlegacy/iwl-4965.c	2011-07-13 10:03:26.000000000 +0200
+++ b/drivers/net/wireless/iwlegacy/iwl-4965.c	2011-07-13 10:03:34.000000000 +0200
@@ -33,7 +33,6 @@
 #include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
-#include <linux/wireless.h>
 #include <net/mac80211.h>
 #include <linux/etherdevice.h>
 #include <asm/unaligned.h>
--- a/drivers/net/wireless/iwlegacy/iwl-led.c	2011-07-13 10:03:26.000000000 +0200
+++ b/drivers/net/wireless/iwlegacy/iwl-led.c	2011-07-13 10:03:35.000000000 +0200
@@ -33,7 +33,6 @@
 #include <linux/delay.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
-#include <linux/wireless.h>
 #include <net/mac80211.h>
 #include <linux/etherdevice.h>
 #include <asm/unaligned.h>
--- a/drivers/net/wireless/iwlegacy/iwl3945-base.c	2011-07-13 10:03:26.000000000 +0200
+++ b/drivers/net/wireless/iwlegacy/iwl3945-base.c	2011-07-13 10:03:36.000000000 +0200
@@ -40,7 +40,6 @@
 #include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
-#include <linux/wireless.h>
 #include <linux/firmware.h>
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c	2011-07-13 10:03:26.000000000 +0200
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c	2011-07-13 10:03:37.000000000 +0200
@@ -40,7 +40,6 @@
 #include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
-#include <linux/wireless.h>
 #include <linux/firmware.h>
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>


