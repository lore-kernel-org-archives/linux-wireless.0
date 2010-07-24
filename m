Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34437 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab0GXRcg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jul 2010 13:32:36 -0400
Received: by ewy23 with SMTP id 23so467032ewy.19
        for <linux-wireless@vger.kernel.org>; Sat, 24 Jul 2010 10:32:34 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Fix regression for rt2500pci
Date: Sat, 24 Jul 2010 19:32:25 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201007241932.27268.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since commit:
     commit f1aa4c541e98afa8b770a75ccaa8504d0bff44a7
     Author: Ivo van Doorn <ivdoorn@gmail.com>
     Date:   Tue Jun 29 21:38:55 2010 +0200

     rt2x00: Write the BSSID to register when interface is added

mananged mode in rt2500pci was broken, due to intf->bssid containing
random data rather then the expected 00:00:00:00:00:00

This is corrected by sending the BSSID to rt2x00lib_config_intf
only in AP mode where the bssid is set to a valid value.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 4d8d232..235e037 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -273,17 +273,24 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 	mutex_init(&intf->beacon_skb_mutex);
 	intf->beacon = entry;
 
-	if (vif->type == NL80211_IFTYPE_AP)
-		memcpy(&intf->bssid, vif->addr, ETH_ALEN);
-	memcpy(&intf->mac, vif->addr, ETH_ALEN);
-
 	/*
 	 * The MAC adddress must be configured after the device
 	 * has been initialized. Otherwise the device can reset
 	 * the MAC registers.
+	 * The BSSID address must only be configured in AP mode,
+	 * however we should not send an empty BSSID address for
+	 * STA interfaces at this time, since this can cause
+	 * invalid behavior in the device.
 	 */
-	rt2x00lib_config_intf(rt2x00dev, intf, vif->type,
-			      intf->mac, intf->bssid);
+	memcpy(&intf->mac, vif->addr, ETH_ALEN);
+	if (vif->type == NL80211_IFTYPE_AP) {
+		memcpy(&intf->bssid, vif->addr, ETH_ALEN);
+		rt2x00lib_config_intf(rt2x00dev, intf, vif->type,
+				      intf->mac, intf->bssid);
+	} else {
+		rt2x00lib_config_intf(rt2x00dev, intf, vif->type,
+				      intf->mac, NULL);
+	}
 
 	/*
 	 * Some filters depend on the current working mode. We can force
-- 
1.7.1.1

