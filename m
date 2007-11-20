Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37586 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797AbXKTMg1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 07:36:27 -0500
Subject: [RFC] mac80211: always have a valid master device mac address
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 20 Nov 2007 01:17:31 +0100
Message-Id: <1195517851.19479.24.camel@johannes.berg> (sfid-20071120_123645_893727_38226573)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Once a while a driver will give us a bogus MAC address. This can be
remedied by the user by setting the MAC address on the wlanX interface,
but unfortunately one cannot change the address of the wmasterX
interface which results in wlanX going up but wmasterX refusing to. This
is pretty bad. This patch forces wmasterX to have a valid MAC address.
The actual address doesn't matter at all.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Or should we hardcode one and always use that instead of the device
address?

--- everything.orig/net/mac80211/ieee80211.c	2007-11-20 00:25:03.008708602 +0100
+++ everything/net/mac80211/ieee80211.c	2007-11-20 00:27:09.278700356 +0100
@@ -1286,6 +1286,8 @@ int ieee80211_register_hw(struct ieee802
 		goto fail_dev;
 
 	memcpy(local->mdev->dev_addr, local->hw.wiphy->perm_addr, ETH_ALEN);
+	if (!is_valid_ether_addr(local->mdev->dev_addr))
+		random_ether_addr(local->mdev->dev_addr);
 	SET_NETDEV_DEV(local->mdev, wiphy_dev(local->hw.wiphy));
 
 	result = register_netdevice(local->mdev);


