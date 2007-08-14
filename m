Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60908 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbXHOKgK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 06:36:10 -0400
Subject: [PATCH] hostapd: remove vlan stuff
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 15 Aug 2007 00:41:09 +0200
Message-Id: <1187131269.31200.3.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This removes the VLAN stuff from hostapd.

The VLAN stuff in mac80211 cannot possibly work, it doesn't actually do
anything with those VLAN type interfaces. Also, when I added the VLAN
type to cfg80211 I must have been rather convinced of the idea; I no
longer am in favour of doing it in the wireless stack. The recently
added "macvlan" "driver" shows how you can do VLANs based on destination
address, what we will need is something like "smacvlan" that does VLANs
based on source address.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 hostapd/ChangeLog            |    2 ++
 hostapd/driver_devicescape.c |   16 ----------------
 2 files changed, 2 insertions(+), 16 deletions(-)

--- hostap.orig/hostapd/driver_devicescape.c	2007-08-15 00:36:51.000000000 +0200
+++ hostap/hostapd/driver_devicescape.c	2007-08-15 00:36:56.000000000 +0200
@@ -1135,21 +1135,6 @@ static struct hostapd_hw_modes * i802_ge
 }
 
 
-static int i802_set_sta_vlan(void *priv, const u8 *addr, const char *ifname,
-			     int vlan_id)
-{
-	struct i802_driver_data *drv = priv;
-	struct prism2_hostapd_param param;
-
-	memset(&param, 0, sizeof(param));
-	param.cmd = PRISM2_HOSTAPD_SET_STA_VLAN;
-	memcpy(param.sta_addr, addr, ETH_ALEN);
-	os_strlcpy(param.u.set_sta_vlan.vlan_name, ifname, IFNAMSIZ);
-	param.u.set_sta_vlan.vlan_id = vlan_id;
-	return hostapd_ioctl(drv, &param, sizeof(param));
-}
-
-
 static void handle_data(struct hostapd_data *hapd, u8 *buf, size_t len,
 			u16 stype)
 {
@@ -2170,5 +2155,4 @@ const struct wpa_driver_ops wpa_driver_d
 	.if_update = i802_if_update,
 	.if_remove = i802_if_remove,
 	.get_hw_feature_data = i802_get_hw_feature_data,
-	.set_sta_vlan = i802_set_sta_vlan,
 };
--- hostap.orig/hostapd/ChangeLog	2007-08-15 00:40:25.000000000 +0200
+++ hostap/hostapd/ChangeLog	2007-08-15 00:40:55.000000000 +0200
@@ -16,6 +16,8 @@ ChangeLog for hostapd
 	  either need to support this or will have to use the WPA/RSN IEs from
 	  hostapd; currently, the included madwifi and bsd driver interfaces do
 	  not have support for this)
+	* removed VLAN support from devicescape driver, the kernel isn't up
+	  to it and it need not live in the wireless stack at all.
 
 2007-05-28 - v0.6.0
 	* added experimental IEEE 802.11r/D6.0 support


