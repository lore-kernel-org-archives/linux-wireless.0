Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:54421 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148Ab0AaUuS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2010 15:50:18 -0500
Message-ID: <4B65ED04.1060506@openwrt.org>
Date: Sun, 31 Jan 2010 21:50:12 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: fix sta lookup for received action frames on an
 AP VLAN
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When looking for a matching interface, __ieee80211_rx_handle_packet
loops over all active interfaces, looking for matching stations.
Because AP VLAN interfaces are not processed as part of this loop, it
needs to use sta_info_get_bss instead of sta_info_get in order to find
a STA that has been moved to a VLAN.
This fixes issues with aggregation setup/teardown.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2359,7 +2359,7 @@ static void __ieee80211_rx_handle_packet
 				continue;
 			}
 
-			rx.sta = sta_info_get(prev, hdr->addr2);
+			rx.sta = sta_info_get_bss(prev, hdr->addr2);
 
 			rx.flags |= IEEE80211_RX_RA_MATCH;
 			prepares = prepare_for_handlers(prev, &rx, hdr);
@@ -2395,7 +2395,7 @@ next:
 		}
 
 		if (prev) {
-			rx.sta = sta_info_get(prev, hdr->addr2);
+			rx.sta = sta_info_get_bss(prev, hdr->addr2);
 
 			rx.flags |= IEEE80211_RX_RA_MATCH;
 			prepares = prepare_for_handlers(prev, &rx, hdr);
