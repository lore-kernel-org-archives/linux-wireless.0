Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:32932 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbYIKVXr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 17:23:47 -0400
Subject: [PATCH] mac80211: fix build failure
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Davide Pesavento <davidepesa@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 11 Sep 2008 23:23:11 +0200
Message-Id: <1221168191.3742.2.camel@johannes.berg> (sfid-20080911_232350_621932_A8CC383F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The two patches
	mac80211: share sta->supp_rates
and
	mac80211: share STA information with driver

caused a build failure in some debugging code, this fixes it.
Thanks to Davide Pesavento for bringing the issue to my attention.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Davide Pesavento <davidepesa@gmail.com>
---
 net/mac80211/mlme.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- everything.orig/net/mac80211/mlme.c	2008-09-11 23:20:53.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-11 23:21:11.000000000 +0200
@@ -1534,14 +1534,15 @@ static void ieee80211_rx_bss_info(struct
 				ieee80211_mandatory_rates(local, band);
 
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
-			if (sta->supp_rates[band] != prev_rates)
+			if (sta->sta.supp_rates[band] != prev_rates)
 				printk(KERN_DEBUG "%s: updated supp_rates set "
 				    "for %s based on beacon info (0x%llx | "
 				    "0x%llx -> 0x%llx)\n",
-				    sdata->dev->name, print_mac(mac, sta->addr),
+				    sdata->dev->name,
+				    print_mac(mac, sta->sta.addr),
 				    (unsigned long long) prev_rates,
 				    (unsigned long long) supp_rates,
-				    (unsigned long long) sta->supp_rates[band]);
+				    (unsigned long long) sta->sta.supp_rates[band]);
 #endif
 		} else {
 			ieee80211_ibss_add_sta(sdata, NULL, mgmt->bssid,


