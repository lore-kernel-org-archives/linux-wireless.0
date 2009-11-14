Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:32846 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753700AbZKNC3g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 21:29:36 -0500
Message-ID: <4AFE1612.5070805@openwrt.org>
Date: Sat, 14 Nov 2009 03:29:38 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: reduce the amount of unnecessary traffic on cooked
 monitor interfaces
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to handle association and authentication in AP mode,
hostapd needs access to the tx status info of its own frames
through a cooked monitor interface. Without this patch the
cooked monitor interfaces also passed on tx status information
for packets from other virtual interfaces. This creates a
significant performance issue on embedded system. Hostapd
tries to work around this by installing a Linux Socket Filter
that only captures the frames it's interested in, however
data duplication and socket filter matching still uses up
enough CPU cycles to be very noticeable on small systems.
This patch ensures that tx status information of non-injected
frames does not make it to cooked monitor interfaces.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---

--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -587,6 +587,11 @@ void ieee80211_tx_status(struct ieee8021
 			if (!netif_running(sdata->dev))
 				continue;
 
+			if ((sdata->u.mntr_flags & MONITOR_FLAG_COOK_FRAMES) &&
+			    !(info->flags & IEEE80211_TX_CTL_INJECTED) &&
+			    (type == IEEE80211_FTYPE_DATA))
+				continue;
+
 			if (prev_dev) {
 				skb2 = skb_clone(skb, GFP_ATOMIC);
 				if (skb2) {
