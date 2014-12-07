Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:64710 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaLGAOl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Dec 2014 19:14:41 -0500
From: Vadim Kochan <vadim4j@gmail.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com,
	davem@davemloft.net, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Vadim Kochan <vadim4j@gmail.com>
Subject: [PATCH] mac80211: Supporting of IFLA_INFO_KIND rtnl attribute
Date: Sun,  7 Dec 2014 02:04:50 +0200
Message-Id: <1417910690-2021-1-git-send-email-vadim4j@gmail.com> (sfid-20141207_011516_082777_A8C18A8F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It allows to identify the wireless kind of device for
the user application, e.g.:

    # ip -d link

    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00 promiscuity 0
    2: enp0s25: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc pfifo_fast state DOWN mode DEFAULT group default qlen 1000
        link/ether XX:XX:XX:XX:XX:XX brd ff:ff:ff:ff:ff:ff promiscuity 0
    3: wlp3s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
        link/ether XX:XX:XX:XX:XX:XX brd ff:ff:ff:ff:ff:ff promiscuity 0
        wireless
    4: wlp0s26u1u2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
        link/ether XX:XX:XX:XX:XX:XX brd ff:ff:ff:ff:ff:ff promiscuity 0 
        wireless 

Signed-off-by: Vadim Kochan <vadim4j@gmail.com>
---
 net/mac80211/iface.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 653f5eb..b993c7d 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -18,6 +18,7 @@
 #include <linux/rtnetlink.h>
 #include <net/mac80211.h>
 #include <net/ieee80211_radiotap.h>
+#include <net/rtnetlink.h>
 #include "ieee80211_i.h"
 #include "sta_info.h"
 #include "debugfs_netdev.h"
@@ -1624,6 +1625,10 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
 	mutex_unlock(&local->iflist_mtx);
 }
 
+static struct rtnl_link_ops wireless_link_ops __read_mostly = {
+	.kind = "wireless",
+};
+
 int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 		     struct wireless_dev **new_wdev, enum nl80211_iftype type,
 		     struct vif_params *params)
@@ -1684,6 +1689,8 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 		memcpy(sdata->vif.addr, ndev->dev_addr, ETH_ALEN);
 		memcpy(sdata->name, ndev->name, IFNAMSIZ);
 
+		ndev->rtnl_link_ops = &wireless_link_ops;
+
 		sdata->dev = ndev;
 	}
 
-- 
2.1.3

