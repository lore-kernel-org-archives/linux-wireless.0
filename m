Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57528 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189AbXLTKg7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2007 05:36:59 -0500
Subject: [PATCH] mac80211: don't read ERP information from (re)association
	response
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Daniel Drake <dsd@gentoo.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 19 Dec 2007 23:38:24 +0100
Message-Id: <1198103904.16241.0.camel@johannes.berg> (sfid-20071220_103704_776464_B37E4611)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to the standard, the field cannot be present, so don't
try to interpret it either.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Daniel Drake <dsd@gentoo.org>
---
 net/mac80211/ieee80211_sta.c |   14 --------------
 1 file changed, 14 deletions(-)

--- everything.orig/net/mac80211/ieee80211_sta.c	2007-12-19 23:33:24.662384223 +0100
+++ everything/net/mac80211/ieee80211_sta.c	2007-12-19 23:33:57.072368273 +0100
@@ -1371,20 +1371,6 @@ static void ieee80211_rx_mgmt_assoc_resp
 		return;
 	}
 
-	/* it probably doesn't, but if the frame includes an ERP value then
-	 * update our stored copy */
-	if (elems.erp_info && elems.erp_info_len >= 1) {
-		struct ieee80211_sta_bss *bss
-			= ieee80211_rx_bss_get(dev, ifsta->bssid,
-					       local->hw.conf.channel,
-					       ifsta->ssid, ifsta->ssid_len);
-		if (bss) {
-			bss->erp_value = elems.erp_info[0];
-			bss->has_erp_value = 1;
-			ieee80211_rx_bss_put(dev, bss);
-		}
-	}
-
 	printk(KERN_DEBUG "%s: associated\n", dev->name);
 	ifsta->aid = aid;
 	ifsta->ap_capab = capab_info;


