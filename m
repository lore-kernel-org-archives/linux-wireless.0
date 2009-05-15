Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caiajhbdcaid.dreamhost.com ([208.97.132.83]:54311 "EHLO
	spunkymail-a9.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757530AbZEOKgW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 06:36:22 -0400
From: Karl Hiramoto <karl@hiramoto.org>
To: j@w1.fi
Cc: hostap@lists.shmoo.com, linux-wireless@vger.kernel.org,
	Karl Hiramoto <karl@hiramoto.org>
Subject: [PATCH] hostapd: nl80211 retry creating a interface if it fails the first time.
Date: Fri, 15 May 2009 12:36:08 +0200
Message-Id: <1242383768-21030-1-git-send-email-karl@hiramoto.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If hostapd segfaults, or is killed with -9, or the interface already exists, when the interface is created, it will fail.

A normal case with hostapd runing:

1: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast qlen 1000
    link/ether 00:01:02:03:04:05 brd ff:ff:ff:ff:ff:ff
3: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast qlen 100
    link/ether 8a:cb:b3:76:b0:5d brd ff:ff:ff:ff:ff:ff
4: eth2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop qlen 100
    link/ether d6:07:19:ee:b5:8d brd ff:ff:ff:ff:ff:ff
5: wmaster0: <UP,LOWER_UP> mtu 0 qdisc pfifo_fast qlen 1000
    link/ieee802.11 00:0e:8e:15:6e:0b brd 00:00:00:00:00:00
7: wlan0_0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast qlen 1000
    link/ether 00:13:01:01:08:0a brd ff:ff:ff:ff:ff:ff
9: br0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue
    link/ether 00:13:01:01:08:0a brd ff:ff:ff:ff:ff:ff
11: br1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue
    link/ether 00:01:02:03:04:05 brd ff:ff:ff:ff:ff:ff
14: mon.wlan0_0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast qlen 1000
    link/[803] 00:0e:8e:15:6e:0b brd ff:ff:ff:ff:ff:ff
15: wlan0_1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast qlen 1000
    link/ether 00:13:01:01:08:0b brd ff:ff:ff:ff:ff:ff

Then rudely kill hostapd.

Mon interface still exists, as well as second ap created by hostapd

1: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast qlen 1000
    link/ether 00:01:02:03:04:05 brd ff:ff:ff:ff:ff:ff
3: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast qlen 100
    link/ether 8a:cb:b3:76:b0:5d brd ff:ff:ff:ff:ff:ff
4: eth2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop qlen 100
    link/ether d6:07:19:ee:b5:8d brd ff:ff:ff:ff:ff:ff
5: wmaster0: <UP,LOWER_UP> mtu 0 qdisc pfifo_fast qlen 1000
    link/ieee802.11 00:0e:8e:15:6e:0b brd 00:00:00:00:00:00
7: wlan0_0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast qlen 1000
    link/ether 00:13:01:01:08:0a brd ff:ff:ff:ff:ff:ff
9: br0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue
    link/ether 00:13:01:01:08:0a brd ff:ff:ff:ff:ff:ff
11: br1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue
    link/ether 00:01:02:03:04:05 brd ff:ff:ff:ff:ff:ff
14: mon.wlan0_0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast qlen 1000
    link/[803] 00:0e:8e:15:6e:0b brd ff:ff:ff:ff:ff:ff
15: wlan0_1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast qlen 1000
    link/ether 00:13:01:01:08:0b brd ff:ff:ff:ff:ff:ff

Hostapd will fail on startup.

Configuration file: /tmp/hostapd/hostapd.conf
Failed to create interface mon.wlan0_0.
Using interface wlan0_0 with hwaddr 00:13:01:01:08:0a and ssid 'IG_0405_LAN'
Failed to set beacon head/tail or DTIM period
Failed to create interface wlan0_1.

This patch solves this issue.

Signed-off-by: Karl Hiramoto <karl@hiramoto.org>
---
 src/drivers/driver_nl80211.c |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/src/drivers/driver_nl80211.c b/src/drivers/driver_nl80211.c
index 79c7889..6e5f48e 100644
--- a/src/drivers/driver_nl80211.c
+++ b/src/drivers/driver_nl80211.c
@@ -2468,7 +2468,7 @@ static void nl80211_remove_iface(struct wpa_driver_nl80211_data *drv,
 }
 
 
-static int nl80211_create_iface(struct wpa_driver_nl80211_data *drv,
+static int nl80211_create_iface_once(struct wpa_driver_nl80211_data *drv,
 				const char *ifname, enum nl80211_iftype iftype,
 				const u8 *addr)
 {
@@ -2529,6 +2529,27 @@ static int nl80211_create_iface(struct wpa_driver_nl80211_data *drv,
 
 	return ifidx;
 }
+static int nl80211_create_iface(struct wpa_driver_nl80211_data *drv,
+				const char *ifname, enum nl80211_iftype iftype,
+				const u8 *addr)
+{
+	int ret;
+
+	ret = nl80211_create_iface_once(drv, ifname, iftype, addr);
+
+	/*if error occured and iterface already exists */
+	if (ret < 0 && if_nametoindex(ifname)) {
+		wpa_printf(MSG_INFO, "Retrying to create %s.", ifname);
+
+		/*remove iface that was already there. */
+		nl80211_remove_iface(drv, if_nametoindex(ifname));
+
+		/* retry to create iface*/
+		ret = nl80211_create_iface_once(drv, ifname, iftype, addr);
+	}
+
+	return ret;
+}
 
 #endif /* CONFIG_AP || HOSTAPD */
 
-- 
1.6.0.6

