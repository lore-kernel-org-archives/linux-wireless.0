Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:54766 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762683AbXGYUsk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 16:48:40 -0400
Received: by ug-out-1314.google.com with SMTP id j3so420027ugf
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2007 13:48:39 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 08/11] rt2x00: Fix MAC address initialization for multiple interfaces
Date: Wed, 25 Jul 2007 22:50:22 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707252250.22190.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From cd95761f3c7ad82d4759ffc8b431e9220e360226 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Tue, 24 Jul 2007 19:46:22 +0200
Subject: [PATCH 08/11] rt2x00: Fix MAC address initialization for multiple interfaces

MAC address initialization was broken when the first
interface which was loaded was a monitor interface and a
real interface was loaded after that.

Only configure the MAC address when a non-monitor interface
is being added. This required splitting the initialization
steps in add_interface up.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/mac80211/rt2x00/rt2x00mac.c |   38 ++++++++++++----------
 1 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00mac.c b/drivers/net/wireless/mac80211/rt2x00/rt2x00mac.c
index 247ea4e..c39c1f2 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00mac.c
@@ -145,6 +145,17 @@ int rt2x00lib_add_interface(struct ieee80211_hw *hw,
 		return -ENOBUFS;
 
 	/*
+	 * If this is the first interface which is added,
+	 * we should load the firmware now.
+	 */
+	if (!test_bit(DEVICE_INITIALIZED, &rt2x00dev->flags) &&
+	    test_bit(REQUIRE_FIRMWARE, &rt2x00dev->flags)) {
+		status = rt2x00lib_load_firmware(rt2x00dev);
+		if (status)
+			return status;
+	}
+
+	/*
 	 * We support muliple monitor mode interfaces.
 	 * All we need to do is increase the monitor_count.
 	 */
@@ -156,29 +167,22 @@ int rt2x00lib_add_interface(struct ieee80211_hw *hw,
 		if (conf->type == IEEE80211_IF_TYPE_AP)
 			memcpy(&intf->bssid, conf->mac_addr, ETH_ALEN);
 		intf->promisc = 0;
-	}
 
-	/*
-	 * Initialize interface, and enable the radio when this
-	 * is the first interface that is brought up.
-	 */
-	if (!test_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags)) {
 		/*
-		 * We must load firmware before we can safely continue.
-		 */
-		if (test_bit(REQUIRE_FIRMWARE, &rt2x00dev->flags)) {
-			status = rt2x00lib_load_firmware(rt2x00dev);
-			if (status)
-				return status;
-		}
-
-		/*
-		 * Before initialization, the mac address should
-		 * be configured.
+		 * We should configure the MAC address before
+		 * the initialization starts. Note that the mac_addr
+		 * field is NULL when adding a monitor interface,
+		 * so we can only set the mac address here.
 		 */
 		rt2x00dev->ops->lib->config_mac_addr(rt2x00dev,
 			conf->mac_addr);
+	}
 
+	/*
+	 * Initialize interface, and enable the radio when this
+	 * is the first interface that is brought up.
+	 */
+	if (!test_bit(DEVICE_INITIALIZED, &rt2x00dev->flags)) {
 		/*
 		 * Initialize the device.
 		 */
-- 
1.5.2.2

