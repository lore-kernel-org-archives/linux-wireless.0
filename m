Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:41901 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513AbaLIWa4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2014 17:30:56 -0500
Received: by mail-la0-f42.google.com with SMTP id gd6so1425376lab.15
        for <linux-wireless@vger.kernel.org>; Tue, 09 Dec 2014 14:30:55 -0800 (PST)
From: Vadim Kochan <vadim4j@gmail.com>
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Vadim Kochan <vadim4j@gmail.com>
Subject: [PATCH v3] wireless: Supporting of IFLA_INFO_KIND rtnl attribute
Date: Wed, 10 Dec 2014 00:21:06 +0200
Message-Id: <1418163666-9206-1-git-send-email-vadim4j@gmail.com> (sfid-20141209_233059_981907_431B13F1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It allows to identify the wlan kind of device for the user application,
e.g.:

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
 net/wireless/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index f52a4cd..eb7c088 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -21,6 +21,7 @@
 #include <linux/sched.h>
 #include <net/genetlink.h>
 #include <net/cfg80211.h>
+#include <net/rtnetlink.h>
 #include "nl80211.h"
 #include "core.h"
 #include "sysfs.h"
@@ -866,6 +867,10 @@ void cfg80211_stop_iface(struct wiphy *wiphy, struct wireless_dev *wdev,
 }
 EXPORT_SYMBOL(cfg80211_stop_iface);
 
+static struct rtnl_link_ops wireless_link_ops __read_mostly = {
+	.kind = "wlan",
+};
+
 static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 					 unsigned long state, void *ptr)
 {
@@ -883,6 +888,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 	switch (state) {
 	case NETDEV_POST_INIT:
 		SET_NETDEV_DEVTYPE(dev, &wiphy_type);
+		dev->rtnl_link_ops = &wireless_link_ops;
 		break;
 	case NETDEV_REGISTER:
 		/*
-- 
2.1.3

