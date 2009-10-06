Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44321 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933053AbZJFUbm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 16:31:42 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: support ETHTOOL_GPERMADDR
Date: Tue,  6 Oct 2009 16:29:36 -0400
Message-Id: <1254860976-7336-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/iface.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index b8295cb..3004492 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -184,10 +184,12 @@ static int ieee80211_open(struct net_device *dev)
 		 * No need to check netif_running since we do not allow
 		 * it to start up with this invalid address.
 		 */
-		if (compare_ether_addr(null_addr, ndev->dev_addr) == 0)
+		if (compare_ether_addr(null_addr, ndev->dev_addr) == 0) {
 			memcpy(ndev->dev_addr,
 			       local->hw.wiphy->perm_addr,
 			       ETH_ALEN);
+			memcpy(ndev->perm_addr, ndev->dev_addr, ETH_ALEN);
+		}
 	}
 
 	/*
@@ -788,6 +790,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 		goto fail;
 
 	memcpy(ndev->dev_addr, local->hw.wiphy->perm_addr, ETH_ALEN);
+	memcpy(ndev->perm_addr, ndev->dev_addr, ETH_ALEN);
 	SET_NETDEV_DEV(ndev, wiphy_dev(local->hw.wiphy));
 	SET_NETDEV_DEVTYPE(ndev, &wiphy_type);
 
-- 
1.6.2.5

