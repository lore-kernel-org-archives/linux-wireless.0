Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:47294 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997AbZIQVXN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2009 17:23:13 -0400
Date: Thu, 17 Sep 2009 14:17:56 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] wl12xx: fix kconfig/link errors
Message-Id: <20090917141756.fdef2914.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

"boolean" converts a module dependency (MAC80211=m) to YES,
then the WL12XX driver can be built-in instead of only
modular, which leads to linker errors:

wl1271_main.c:(.text+0x11177d): undefined reference to `ieee80211_frequency_to_channel'
wl1271_main.c:(.text+0x111adc): undefined reference to `ieee80211_stop_queues'
wl1271_main.c:(.text+0x112005): undefined reference to `ieee80211_scan_completed'
(.text+0x1139c8): undefined reference to `ieee80211_scan_completed'
(.text+0x113bb0): undefined reference to `ieee80211_tx_status'
(.text+0x113e53): undefined reference to `ieee80211_stop_queues'
(.text+0x113e8d): undefined reference to `ieee80211_wake_queues'
(.text+0x113f3b): undefined reference to `ieee80211_tx_status'
(.text+0x113f60): undefined reference to `ieee80211_tx_status'
(.text+0x1140f0): undefined reference to `ieee80211_channel_to_frequency'
(.text+0x114153): undefined reference to `ieee80211_rx'
wl1271_main.c:(.devinit.text+0xca08): undefined reference to `ieee80211_alloc_hw'
wl1271_main.c:(.devinit.text+0xccf5): undefined reference to `ieee80211_register_hw'
wl1271_main.c:(.devinit.text+0xcd6b): undefined reference to `ieee80211_free_hw'
wl1271_main.c:(.devexit.text+0x1353): undefined reference to `ieee80211_unregister_hw'
wl1271_main.c:(.devexit.text+0x13c9): undefined reference to `ieee80211_free_hw'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/net/wireless/wl12xx/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20090917.orig/drivers/net/wireless/wl12xx/Kconfig
+++ linux-next-20090917/drivers/net/wireless/wl12xx/Kconfig
@@ -1,5 +1,5 @@
 menuconfig WL12XX
-	boolean "TI wl12xx driver support"
+	tristate "TI wl12xx driver support"
 	depends on MAC80211 && WLAN_80211 && EXPERIMENTAL
 	---help---
 	  This will enable TI wl12xx driver support. The drivers make



---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
