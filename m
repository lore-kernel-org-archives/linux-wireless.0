Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:47681 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbaLGKaP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Dec 2014 05:30:15 -0500
Received: by mail-lb0-f178.google.com with SMTP id f15so2787483lbj.9
        for <linux-wireless@vger.kernel.org>; Sun, 07 Dec 2014 02:30:13 -0800 (PST)
From: Vadim Kochan <vadim4j@gmail.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Cc: Vadim Kochan <vadim4j@gmail.com>
Subject: [PATCH v2] mac80211: Supporting of IFLA_INFO_KIND rtnl attribute
Date: Sun,  7 Dec 2014 12:20:27 +0200
Message-Id: <1417947627-2329-1-git-send-email-vadim4j@gmail.com> (sfid-20141207_113019_533467_65EC6AAA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It allows to identify the wlan kind of device for
the user application, e.g.:

    # ip -d link

    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00 promiscuity 0
    2: enp0s25: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc pfifo_fast state DOWN mode DEFAULT group default qlen 1000
        link/ether XX:XX:XX:XX:XX:XX brd ff:ff:ff:ff:ff:ff promiscuity 0
    3: wlp3s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
        link/ether XX:XX:XX:XX:XX:XX brd ff:ff:ff:ff:ff:ff promiscuity 0
        wlan

Signed-off-by: Vadim Kochan <vadim4j@gmail.com>
---
 net/mac80211/iface.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 653f5eb..e48372b 100644
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
+	.kind = "wlan",
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

