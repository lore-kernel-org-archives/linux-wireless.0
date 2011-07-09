Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38357 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351Ab1GINjT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jul 2011 09:39:19 -0400
Subject: [PATCH] mac80211: allocate only one RX queue
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 09 Jul 2011 15:39:16 +0200
Message-ID: <1310218756.3901.3.camel@jlt3.sipsolutions.net> (sfid-20110709_153926_321163_0732FAE2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We don't have multiple RX queues, so there's no use
in allocating multiple, use alloc_netdev_mqs() to
allocate multiple TX but only one RX queue.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/mac80211/iface.c	2011-07-09 15:26:56.000000000 +0200
+++ b/net/mac80211/iface.c	2011-07-09 15:27:09.000000000 +0200
@@ -1130,8 +1130,8 @@ int ieee80211_if_add(struct ieee80211_lo
 
 	ASSERT_RTNL();
 
-	ndev = alloc_netdev_mq(sizeof(*sdata) + local->hw.vif_data_size,
-			       name, ieee80211_if_setup, local->hw.queues);
+	ndev = alloc_netdev_mqs(sizeof(*sdata) + local->hw.vif_data_size,
+				name, ieee80211_if_setup, local->hw.queues, 1);
 	if (!ndev)
 		return -ENOMEM;
 	dev_net_set(ndev, wiphy_net(local->hw.wiphy));


