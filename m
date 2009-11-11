Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:55485 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757479AbZKKMRh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2009 07:17:37 -0500
Message-ID: <4AFAAB60.7070002@openwrt.org>
Date: Wed, 11 Nov 2009 13:17:36 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: fix broadcast frame handling for 4-addr AP VLANs
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Without this patch, broadcast frames from the station behind a
4-addr AP VLAN would be reflected back to the source.
Fix this by checking the 4-addr flag before bridging multicast
frames in the cell.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
I hadn't noticed that v2 of my mac80211 4-addr patch had been
merged already, so here's the fix from v3 as a separate patch

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1292,7 +1292,7 @@ ieee80211_deliver_skb(struct ieee80211_r
 	if ((sdata->vif.type == NL80211_IFTYPE_AP ||
 	     sdata->vif.type == NL80211_IFTYPE_AP_VLAN) &&
 	    !(sdata->flags & IEEE80211_SDATA_DONT_BRIDGE_PACKETS) &&
-	    (rx->flags & IEEE80211_RX_RA_MATCH)) {
+	    (rx->flags & IEEE80211_RX_RA_MATCH) && !rx->sdata->use_4addr) {
 		if (is_multicast_ether_addr(ehdr->h_dest)) {
 			/*
 			 * send multicast frames both to higher layers in
