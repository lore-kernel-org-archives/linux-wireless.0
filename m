Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51780 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376AbZBJUb3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 15:31:29 -0500
Message-Id: <20090210202553.064447802@sipsolutions.net> (sfid-20090210_213133_175432_E8DBCC67)
References: <20090210202536.425266119@sipsolutions.net>
Date: Tue, 10 Feb 2009 21:25:39 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 03/27] zd1211rw: honour enable_beacon conf
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

--- wireless-testing.orig/drivers/net/wireless/zd1211rw/zd_mac.c	2009-02-10 20:59:27.000000000 +0100
+++ wireless-testing/drivers/net/wireless/zd1211rw/zd_mac.c	2009-02-10 20:59:29.000000000 +0100
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

-- 

