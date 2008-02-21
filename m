Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36988 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbYBUKIm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2008 05:08:42 -0500
Subject: [PATCH] mac80211: fix IBSS code
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: bruno randolf <br1@einfach.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 21 Feb 2008 11:08:33 +0100
Message-Id: <1203588513.17534.138.camel@johannes.berg> (sfid-20080221_100844_845488_E4C168AE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes two errors introduced by

    commit 19d35612f3cd7f60dd9174c0100584e21f5a1025
    Author: Bruno Randolf <bruno@thinktube.com>
    Date:   Mon Feb 18 11:21:36 2008 +0900

        mac80211: enable IBSS merging

The first error is an endianness problem that sparse found and
the second is a build failure when CONFIG_MAC80211_IBSS_DEBUG
is not set.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Bruno Randolf <bruno@thinktube.com>
---
 net/mac80211/ieee80211_sta.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- everything.orig/net/mac80211/ieee80211_sta.c	2008-02-21 11:04:18.000000000 +0100
+++ everything/net/mac80211/ieee80211_sta.c	2008-02-21 11:04:32.000000000 +0100
@@ -2412,7 +2412,7 @@ static void ieee80211_rx_bss_info(struct
 	/* check if we need to merge IBSS */
 	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS && beacon &&
 	    !local->sta_sw_scanning && !local->sta_hw_scanning &&
-	    mgmt->u.beacon.capab_info & WLAN_CAPABILITY_IBSS &&
+	    bss->capability & WLAN_CAPABILITY_IBSS &&
 	    bss->freq == local->oper_channel->center_freq &&
 	    elems.ssid_len == sdata->u.sta.ssid_len &&
 	    memcmp(elems.ssid, sdata->u.sta.ssid, sdata->u.sta.ssid_len) == 0) {
@@ -2452,7 +2452,9 @@ static void ieee80211_rx_bss_info(struct
 		       jiffies);
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
 		if (beacon_timestamp > rx_timestamp) {
-			if (CONFIG_MAC80211_IBSS_DEBUG || net_ratelimit())
+#ifndef CONFIG_MAC80211_IBSS_DEBUG
+			if (net_ratelimit())
+#endif
 				printk(KERN_DEBUG "%s: beacon TSF higher than "
 				       "local TSF - IBSS merge with BSSID %s\n",
 				       dev->name, print_mac(mac, mgmt->bssid));


