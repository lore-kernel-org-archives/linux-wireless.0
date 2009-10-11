Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:60117 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756005AbZJKDm2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Oct 2009 23:42:28 -0400
Message-ID: <4AD14F26.6030304@openwrt.org>
Date: Sun, 11 Oct 2009 05:21:10 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: fix logic error ibss merge bssid check
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>

--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -544,7 +544,7 @@ static void ieee80211_sta_find_ibss(stru
 		       "%pM\n", bss->cbss.bssid, ifibss->bssid);
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */

-	if (bss && memcmp(ifibss->bssid, bss->cbss.bssid, ETH_ALEN)) {
+	if (bss && !memcmp(ifibss->bssid, bss->cbss.bssid, ETH_ALEN)) {
 		printk(KERN_DEBUG "%s: Selected IBSS BSSID %pM"
 		       " based on configured SSID\n",
 		       sdata->dev->name, bss->cbss.bssid);
