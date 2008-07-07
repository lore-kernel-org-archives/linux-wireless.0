Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from element.ksp.sk ([158.195.16.154]:51119 "EHLO element.ksp.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356AbYGGMXG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2008 08:23:06 -0400
Message-ID: <48720AA5.9070303@work.ksp.sk> (sfid-20080707_142311_242341_C2D5E3D4)
Date: Mon, 07 Jul 2008 14:23:01 +0200
From: Vladimir Koutny <vlado@work.ksp.sk>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	bruno randolf <bruno@thinktube.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] mac80211: don't report selected IBSS when not found
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't report a 'selected' IBSS in sta_find_ibss when none was found.

Signed-off-by: Vladimir Koutny <vlado@ksp.sk>

---

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3694,8 +3694,10 @@ static int ieee80211_sta_find_ibss(struct net_device *dev,
 	spin_unlock_bh(&local->sta_bss_lock);

 #ifdef CONFIG_MAC80211_IBSS_DEBUG
-	printk(KERN_DEBUG "   sta_find_ibss: selected %s current "
-	       "%s\n", print_mac(mac, bssid), print_mac(mac2, ifsta->bssid));
+	if (found)
+		printk(KERN_DEBUG "   sta_find_ibss: selected %s current "
+		       "%s\n", print_mac(mac, bssid),
+		       print_mac(mac2, ifsta->bssid));
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
 	if (found && memcmp(ifsta->bssid, bssid, ETH_ALEN) != 0 &&
 	    (bss = ieee80211_rx_bss_get(dev, bssid,
