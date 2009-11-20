Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53675 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbZKTJJQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 04:09:16 -0500
Subject: [PATCH] mac80211: fix rcu locking
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Nov 2009 10:09:14 +0100
Message-ID: <1258708154.7094.41.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a missing rcu_read_unlock() before jumping out
of the ieee80211_change_station() function in the
error case.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
*points finger at*

  commit fed1557d868e3a15b8a10700f79353e1f362e3a1
  Author: Felix Fietkau <nbd@openwrt.org>
  Date:   Tue Nov 10 20:10:05 2009 +0100

      mac80211: implement support for 4-address frames for AP and client mode

 net/mac80211/cfg.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/cfg.c	2009-11-20 10:04:21.000000000 +0100
+++ wireless-testing/net/mac80211/cfg.c	2009-11-20 10:04:37.000000000 +0100
@@ -818,8 +818,10 @@ static int ieee80211_change_station(stru
 		}
 
 		if (params->vlan->ieee80211_ptr->use_4addr) {
-			if (vlansdata->u.vlan.sta)
+			if (vlansdata->u.vlan.sta) {
+				rcu_read_unlock();
 				return -EBUSY;
+			}
 
 			rcu_assign_pointer(vlansdata->u.vlan.sta, sta);
 		}


