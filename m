Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:37645 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751498AbYGSWb3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2008 18:31:29 -0400
From: Daniel Drake <dsd@gentoo.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH] mac80211: automatic IBSS channel selection
Message-Id: <20080719223118.1506B72C001@zog.reactivated.net> (sfid-20080720_003134_297987_7D1B98C2)
Date: Sat, 19 Jul 2008 23:31:17 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When joining an ad-hoc network, the user is currently required to specify
the channel. The network will not be joined otherwise, unless it happens
to be sitting on the currently active channel.

This patch implements automatic channel selection when the user has not
locked the interface onto a specific channel.

Signed-off-by: Daniel Drake <dsd@gentoo.org>
Acked-by: Johannes Berg <johannes@sipsolutions.net>

Index: linux-2.6/net/mac80211/mlme.c
===================================================================
--- linux-2.6.orig/net/mac80211/mlme.c
+++ linux-2.6/net/mac80211/mlme.c
@@ -3619,6 +3619,7 @@ static int ieee80211_sta_find_ibss(struc
 	int found = 0;
 	u8 bssid[ETH_ALEN];
 	int active_ibss;
+	int search_freq;
 	DECLARE_MAC_BUF(mac);
 	DECLARE_MAC_BUF(mac2);
 
@@ -3653,11 +3654,21 @@ static int ieee80211_sta_find_ibss(struc
 		       "%s\n", print_mac(mac, bssid),
 		       print_mac(mac2, ifsta->bssid));
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
-	if (found && memcmp(ifsta->bssid, bssid, ETH_ALEN) != 0 &&
-	    (bss = ieee80211_rx_bss_get(dev, bssid,
-					local->hw.conf.channel->center_freq,
-					ifsta->ssid, ifsta->ssid_len))) {
+
+	if (found && memcmp(ifsta->bssid, bssid, ETH_ALEN) != 0) {
 		int ret;
+		int search_freq;
+
+		if (ifsta->flags & IEEE80211_STA_AUTO_CHANNEL_SEL)
+			search_freq = bss->freq;
+		else
+			search_freq = local->hw.conf.channel->center_freq;
+
+		bss = ieee80211_rx_bss_get(dev, bssid, search_freq,
+					   ifsta->ssid, ifsta->ssid_len);
+		if (!bss)
+			goto dont_join;
+
 		printk(KERN_DEBUG "%s: Selected IBSS BSSID %s"
 		       " based on configured SSID\n",
 		       dev->name, print_mac(mac, bssid));
@@ -3665,6 +3676,8 @@ static int ieee80211_sta_find_ibss(struc
 		ieee80211_rx_bss_put(local, bss);
 		return ret;
 	}
+
+dont_join:
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 	printk(KERN_DEBUG "   did not try to join ibss\n");
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
