Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:3125 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755838AbYDCXPG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 19:15:06 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH] mac80211: notify upper layers after lower
Date: Thu,  3 Apr 2008 16:08:49 -0700
Message-Id: <1207264130-25437-1-git-send-email-reinette.chatre@intel.com> (sfid-20080404_001527_229447_A3319517)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When drivers receive change notification they may do work that
will enable the changes to take effect. For example, if new association
the device needs to be programmed with this information.
Give the driver chance to make the changes before notifying the
upper layer - thus preventing race condition where upper layer
attempts to utilize state that may not be configured yet.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 net/mac80211/ieee80211_sta.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index be2ce24..f3c8a21 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -545,13 +545,13 @@ static void ieee80211_set_associated(struct net_device *dev,
 
 		memset(wrqu.ap_addr.sa_data, 0, ETH_ALEN);
 	}
-	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
-	wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
 	ifsta->last_probe = jiffies;
 	ieee80211_led_assoc(local, assoc);
 
 	sdata->bss_conf.assoc = assoc;
 	ieee80211_bss_info_change_notify(sdata, changed);
+	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
+	wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
 }
 
 static void ieee80211_set_disassoc(struct net_device *dev,
-- 
1.5.3.4

