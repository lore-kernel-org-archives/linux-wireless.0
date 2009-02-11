Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42597 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869AbZBKT2F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 14:28:05 -0500
Subject: [PATCH] mac80211: disallow moving netns
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain
Date: Wed, 11 Feb 2009 20:27:30 +0100
Message-Id: <1234380450.16004.42.camel@johannes.local> (sfid-20090211_202810_877192_DC595C24)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 currently assumes init_net for all interfaces,
so really will not cope well with network namespaces,
at least at this time.

To change this, we would have keep track of the netns
in addition to the ifindex, which is not something I
want to think about right now.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---
 net/mac80211/iface.c |    1 +
 net/mac80211/main.c  |    1 +
 2 files changed, 2 insertions(+)

--- wireless-testing.orig/net/mac80211/iface.c	2009-02-11 20:17:10.000000000 +0100
+++ wireless-testing/net/mac80211/iface.c	2009-02-11 20:18:14.000000000 +0100
@@ -810,6 +810,7 @@ int ieee80211_if_add(struct ieee80211_lo
 
 	memcpy(ndev->dev_addr, local->hw.wiphy->perm_addr, ETH_ALEN);
 	SET_NETDEV_DEV(ndev, wiphy_dev(local->hw.wiphy));
+	ndev->features |= NETIF_F_NETNS_LOCAL;
 
 	/* don't use IEEE80211_DEV_TO_SUB_IF because it checks too much */
 	sdata = netdev_priv(ndev);
--- wireless-testing.orig/net/mac80211/main.c	2009-02-11 20:17:10.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2009-02-11 20:18:15.000000000 +0100
@@ -922,6 +922,7 @@ int ieee80211_register_hw(struct ieee802
 
 	memcpy(local->mdev->dev_addr, local->hw.wiphy->perm_addr, ETH_ALEN);
 	SET_NETDEV_DEV(local->mdev, wiphy_dev(local->hw.wiphy));
+	local->mdev->features |= NETIF_F_NETNS_LOCAL;
 
 	result = register_netdevice(local->mdev);
 	if (result < 0)


