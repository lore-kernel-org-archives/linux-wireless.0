Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50875 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562AbZGMWi3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 18:38:29 -0400
Message-Id: <20090713223413.628454212@sipsolutions.net>
References: <20090713223333.042733013@sipsolutions.net>
Date: Tue, 14 Jul 2009 00:33:36 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] mac80211: allow using network namespaces
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This finally opens up the ability to put mac80211 devices
into different network namespaces. As long as you don't
have sysfs, that is.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Semantically, this depends on both
  mac80211: cooperate more with network namespaces
and
  cfg80211: make aware of net namespaces

but in the code only the latter dependency is obvious,
so I'm sending it as a separate patch.

 net/mac80211/iface.c |    1 +
 net/mac80211/main.c  |    1 +
 2 files changed, 2 insertions(+)

--- wireless-testing.orig/net/mac80211/main.c	2009-07-14 00:29:34.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2009-07-14 00:30:10.000000000 +0200
@@ -620,6 +620,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	if (!wiphy)
 		return NULL;
 
+	wiphy->netnsok = true;
 	wiphy->privid = mac80211_wiphy_privid;
 
 	/* Yes, putting cfg80211_bss into ieee80211_bss is a hack */
--- wireless-testing.orig/net/mac80211/iface.c	2009-07-14 00:30:05.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2009-07-14 00:30:10.000000000 +0200
@@ -787,6 +787,7 @@ int ieee80211_if_add(struct ieee80211_lo
 			    name, ieee80211_if_setup);
 	if (!ndev)
 		return -ENOMEM;
+	dev_net_set(ndev, wiphy_net(local->hw.wiphy));
 
 	ndev->needed_headroom = local->tx_headroom +
 				4*6 /* four MAC addresses */

-- 

