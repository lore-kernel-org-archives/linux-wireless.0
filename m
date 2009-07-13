Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46891 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517AbZGMWkN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 18:40:13 -0400
Subject: [HACK] mac80211: don't set netdev parent pointer
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090713223333.042733013@sipsolutions.net>
References: <20090713223333.042733013@sipsolutions.net>
Content-Type: text/plain
Date: Tue, 14 Jul 2009 00:39:42 +0200
Message-Id: <1247524782.7178.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To allow playing with network namespaces even if you
have sysfs configured... don't try this on your normal
kernel, it will probably confuse userspace.

NOT-signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/iface.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/iface.c	2009-07-14 00:30:10.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2009-07-14 00:30:14.000000000 +0200
@@ -803,7 +803,7 @@ int ieee80211_if_add(struct ieee80211_lo
 		goto fail;
 
 	memcpy(ndev->dev_addr, local->hw.wiphy->perm_addr, ETH_ALEN);
-	SET_NETDEV_DEV(ndev, wiphy_dev(local->hw.wiphy));
+//	SET_NETDEV_DEV(ndev, wiphy_dev(local->hw.wiphy));
 
 	/* don't use IEEE80211_DEV_TO_SUB_IF because it checks too much */
 	sdata = netdev_priv(ndev);


