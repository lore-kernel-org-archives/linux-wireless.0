Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:46620 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbZI3AyH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2009 20:54:07 -0400
Received: by ey-out-2122.google.com with SMTP id 4so393562eyf.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2009 17:54:10 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 30 Sep 2009 02:54:10 +0200
Message-ID: <57b62e7d0909291754x352ae254sa33ee7efb430d497@mail.gmail.com>
Subject: VLAN traffic appearing on the wrong iface
From: =?UTF-8?B?Qmxhxb4gQmHEjW5paw==?= <bacnik@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I use RADIUS-assigned vlans with my AP. Hostapd reports vlan change
during authentication and the station appears on correct vlan
according to "iw dev ... station dump". But actual packets keep coming
in on the default interface (wlan0), not the vlan one (eg. wlan0.2).
Moreover, I am able to ping this interface's (wlan0) IP address from
the station, even though "iw dev wlan0 station dump" does not list it.


I also tried taking RADIUS out of the loop, so I used hostapd's
"accept_mac_file" with specified vlan and I think I might have found
another bug. After applying the patch below (for I believe a rather
obvious typo), kernel started oopsing and I gave up. If needed, I can
provide config files for either hostapd or freeradius server, though
it looks like this is a driver problem.


Best regards,
Blaz



--- hostapd-0.6.9/hostapd/ieee802_11.c	2009-07-05 18:24:47.000000000 +0200
+++ hostapd-new/hostapd/ieee802_11.c	2009-09-30 02:16:56.000000000 +0200
@@ -583,11 +583,11 @@
 		goto fail;
 	}

 	if (vlan_id > 0) {
 		if (hostapd_get_vlan_id_ifname(hapd->conf->vlan,
-					       sta->vlan_id) == NULL) {
+					       vlan_id) == NULL) {
 			hostapd_logger(hapd, sta->addr, HOSTAPD_MODULE_RADIUS,
 				       HOSTAPD_LEVEL_INFO, "Invalid VLAN ID "
 				       "%d received from RADIUS server",
 				       vlan_id);
 			resp = WLAN_STATUS_UNSPECIFIED_FAILURE;
