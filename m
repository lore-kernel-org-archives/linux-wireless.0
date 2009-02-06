Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36923 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbZBFOZy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2009 09:25:54 -0500
Subject: [PATCH] zd1211rw: honour enable_beacon conf
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Daniel Drake <dsd@gentoo.org>
Content-Type: text/plain
Date: Fri, 06 Feb 2009 14:50:34 +0100
Message-Id: <1233928234.4175.6.camel@johannes.local> (sfid-20090206_152557_120620_4B410E59)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes zd1211rw honour enable_beacon, as well as fixing
a memory leak: the beacon skb is leaked when configuring it
to the hardware fails.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/zd1211rw/zd_mac.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/zd1211rw/zd_mac.c	2009-02-06 14:43:37.000000000 +0100
+++ wireless-testing/drivers/net/wireless/zd1211rw/zd_mac.c	2009-02-06 14:48:48.000000000 +0100
@@ -768,13 +768,23 @@ static int zd_op_config_interface(struct
 			if (!beacon)
 				return -ENOMEM;
 			r = zd_mac_config_beacon(hw, beacon);
+			kfree_skb(beacon);
+
 			if (r < 0)
 				return r;
-			r = zd_set_beacon_interval(&mac->chip, BCN_MODE_IBSS |
-					hw->conf.beacon_int);
+		}
+
+		if (conf->changed & IEEE80211_IFCC_BEACON_ENABLED) {
+			u32 interval;
+
+			if (conf->enable_beacon)
+				interval = BCN_MODE_IBSS | hw->conf.beacon_int;
+			else
+				interval = 0;
+
+			r = zd_set_beacon_interval(&mac->chip, interval);
 			if (r < 0)
 				return r;
-			kfree_skb(beacon);
 		}
 	} else
 		associated = is_valid_ether_addr(conf->bssid);


