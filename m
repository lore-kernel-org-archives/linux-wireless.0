Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59008 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab0KDToB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 15:44:01 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so1320245eye.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Nov 2010 12:44:00 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 12/13] rt2x00: Fix hw crypto in AP mode for some devices
Date: Thu, 4 Nov 2010 20:42:36 +0100
Cc: Helmut Schaa <helmut.schaa@googlemail.com>, stable@kernel.org
References: <201011042037.00178.IvDoorn@gmail.com> <201011042040.47235.IvDoorn@gmail.com> <201011042041.06812.IvDoorn@gmail.com>
In-Reply-To: <201011042041.06812.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <201011042042.37240.IvDoorn@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

The BSSID register shouldn't be set in AP mode on some older devices (like
rt73usb) as it breaks hw crypto on these. However, rt2800 devices explicitly
need the BSSID register set to the same value as our own MAC address (only
in AP mode).

Hence, don't set the BSSID from rt2x00lib but move it down into rt2800 to
avoid problems on older devices.

This fixes a regression (at least for rt73usb) and avoids a new regression
for rt2800 devices in 2.6.36.

Reported-by: Johannes Stezenbach <js@sig21.net>
Reported-by: Lee <lee-in-berlin@web.de>
Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   13 ++++++++++++-
 drivers/net/wireless/rt2x00/rt2x00mac.c |   10 ++--------
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 6fa6549..a53536d 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1148,6 +1148,7 @@ void rt2800_config_intf(struct rt2x00_dev *rt2x00dev, struct rt2x00_intf *intf,
 			struct rt2x00intf_conf *conf, const unsigned int flags)
 {
 	u32 reg;
+	bool update_bssid = false;
 
 	if (flags & CONFIG_UPDATE_TYPE) {
 		/*
@@ -1177,6 +1178,16 @@ void rt2800_config_intf(struct rt2x00_dev *rt2x00dev, struct rt2x00_intf *intf,
 	}
 
 	if (flags & CONFIG_UPDATE_MAC) {
+		if (flags & CONFIG_UPDATE_TYPE &&
+		    conf->sync == TSF_SYNC_AP_NONE) {
+			/*
+			 * The BSSID register has to be set to our own mac
+			 * address in AP mode.
+			 */
+			memcpy(conf->bssid, conf->mac, sizeof(conf->mac));
+			update_bssid = true;
+		}
+
 		if (!is_zero_ether_addr((const u8 *)conf->mac)) {
 			reg = le32_to_cpu(conf->mac[1]);
 			rt2x00_set_field32(&reg, MAC_ADDR_DW1_UNICAST_TO_ME_MASK, 0xff);
@@ -1187,7 +1198,7 @@ void rt2800_config_intf(struct rt2x00_dev *rt2x00dev, struct rt2x00_intf *intf,
 					      conf->mac, sizeof(conf->mac));
 	}
 
-	if (flags & CONFIG_UPDATE_BSSID) {
+	if ((flags & CONFIG_UPDATE_BSSID) || update_bssid) {
 		if (!is_zero_ether_addr((const u8 *)conf->bssid)) {
 			reg = le32_to_cpu(conf->bssid[1]);
 			rt2x00_set_field32(&reg, MAC_BSSID_DW1_BSS_ID_MASK, 3);
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 283a8d9..36ddee8 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -283,14 +283,8 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 	 * invalid behavior in the device.
 	 */
 	memcpy(&intf->mac, vif->addr, ETH_ALEN);
-	if (vif->type == NL80211_IFTYPE_AP) {
-		memcpy(&intf->bssid, vif->addr, ETH_ALEN);
-		rt2x00lib_config_intf(rt2x00dev, intf, vif->type,
-				      intf->mac, intf->bssid);
-	} else {
-		rt2x00lib_config_intf(rt2x00dev, intf, vif->type,
-				      intf->mac, NULL);
-	}
+	rt2x00lib_config_intf(rt2x00dev, intf, vif->type,
+			      intf->mac, NULL);
 
 	/*
 	 * Some filters depend on the current working mode. We can force
-- 
1.7.2.3

