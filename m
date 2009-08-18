Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:53122 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbZHRSdP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 14:33:15 -0400
Received: by ey-out-2122.google.com with SMTP id 22so816143eye.37
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2009 11:33:15 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: bss_info_changed() callback is allowed to sleep
Date: Tue, 18 Aug 2009 20:33:12 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908182033.12934.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The bss_info_changed() callback function no longer needs
to be atomic. Remove the scheduled work structure and
call into the driver directly.

Additionaly this makes the DRIVER_REQUIRE_SCHEDULED
flag redundant so it can be removed.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |    1 -
 drivers/net/wireless/rt2x00/rt2800usb.c |    1 -
 drivers/net/wireless/rt2x00/rt2x00.h    |    3 ---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    8 --------
 drivers/net/wireless/rt2x00/rt2x00mac.c |   14 +++-----------
 drivers/net/wireless/rt2x00/rt73usb.c   |    1 -
 6 files changed, 3 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 09a5894..b04f59b 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1874,7 +1874,6 @@ static int rt2500usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	 */
 	__set_bit(DRIVER_REQUIRE_ATIM_QUEUE, &rt2x00dev->flags);
 	__set_bit(DRIVER_REQUIRE_BEACON_GUARD, &rt2x00dev->flags);
-	__set_bit(DRIVER_REQUIRE_SCHEDULED, &rt2x00dev->flags);
 	if (!modparam_nohwcrypt) {
 		__set_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags);
 		__set_bit(DRIVER_REQUIRE_COPY_IV, &rt2x00dev->flags);
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 45e02f1..639dc6c 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -2634,7 +2634,6 @@ static int rt2800usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	 * This device requires firmware.
 	 */
 	__set_bit(DRIVER_REQUIRE_FIRMWARE, &rt2x00dev->flags);
-	__set_bit(DRIVER_REQUIRE_SCHEDULED, &rt2x00dev->flags);
 	__set_bit(DRIVER_REQUIRE_L2PAD, &rt2x00dev->flags);
 	if (!modparam_nohwcrypt)
 		__set_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags);
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 2d0b6b0..f5978a6 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -356,8 +356,6 @@ struct rt2x00_intf {
 	 */
 	unsigned int delayed_flags;
 #define DELAYED_UPDATE_BEACON		0x00000001
-#define DELAYED_CONFIG_ERP		0x00000002
-#define DELAYED_LED_ASSOC		0x00000004
 
 	/*
 	 * Software sequence counter, this is only required
@@ -620,7 +618,6 @@ enum rt2x00_flags {
 	DRIVER_REQUIRE_FIRMWARE,
 	DRIVER_REQUIRE_BEACON_GUARD,
 	DRIVER_REQUIRE_ATIM_QUEUE,
-	DRIVER_REQUIRE_SCHEDULED,
 	DRIVER_REQUIRE_DMA,
 	DRIVER_REQUIRE_COPY_IV,
 	DRIVER_REQUIRE_L2PAD,
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 16b560a..3f8c70e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -123,7 +123,6 @@ static void rt2x00lib_intf_scheduled_iter(void *data, u8 *mac,
 {
 	struct rt2x00_dev *rt2x00dev = data;
 	struct rt2x00_intf *intf = vif_to_intf(vif);
-	struct ieee80211_bss_conf conf;
 	int delayed_flags;
 
 	/*
@@ -133,7 +132,6 @@ static void rt2x00lib_intf_scheduled_iter(void *data, u8 *mac,
 	 */
 	spin_lock(&intf->lock);
 
-	memcpy(&conf, &vif->bss_conf, sizeof(conf));
 	delayed_flags = intf->delayed_flags;
 	intf->delayed_flags = 0;
 
@@ -150,12 +148,6 @@ static void rt2x00lib_intf_scheduled_iter(void *data, u8 *mac,
 
 	if (delayed_flags & DELAYED_UPDATE_BEACON)
 		rt2x00queue_update_beacon(rt2x00dev, vif, true);
-
-	if (delayed_flags & DELAYED_CONFIG_ERP)
-		rt2x00lib_config_erp(rt2x00dev, intf, &conf);
-
-	if (delayed_flags & DELAYED_LED_ASSOC)
-		rt2x00leds_led_assoc(rt2x00dev, !!rt2x00dev->intf_associated);
 }
 
 static void rt2x00lib_intf_scheduled(struct work_struct *work)
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 967d3b5..a91f316 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -636,23 +636,15 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 		else
 			rt2x00dev->intf_associated--;
 
-		if (!test_bit(DRIVER_REQUIRE_SCHEDULED, &rt2x00dev->flags))
-			rt2x00leds_led_assoc(rt2x00dev,
-					     !!rt2x00dev->intf_associated);
-		else
-			delayed |= DELAYED_LED_ASSOC;
+		rt2x00leds_led_assoc(rt2x00dev, !!rt2x00dev->intf_associated);
 	}
 
 	/*
 	 * When the erp information has changed, we should perform
 	 * additional configuration steps. For all other changes we are done.
 	 */
-	if (changes & ~(BSS_CHANGED_ASSOC | BSS_CHANGED_HT)) {
-		if (!test_bit(DRIVER_REQUIRE_SCHEDULED, &rt2x00dev->flags))
-			rt2x00lib_config_erp(rt2x00dev, intf, bss_conf);
-		else
-			delayed |= DELAYED_CONFIG_ERP;
-	}
+	if (changes & ~(BSS_CHANGED_ASSOC | BSS_CHANGED_HT))
+		rt2x00lib_config_erp(rt2x00dev, intf, bss_conf);
 
 	spin_lock(&intf->lock);
 	if (delayed) {
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 4d94b65..90e1172 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2151,7 +2151,6 @@ static int rt73usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	 * This device requires firmware.
 	 */
 	__set_bit(DRIVER_REQUIRE_FIRMWARE, &rt2x00dev->flags);
-	__set_bit(DRIVER_REQUIRE_SCHEDULED, &rt2x00dev->flags);
 	if (!modparam_nohwcrypt)
 		__set_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags);
 
-- 
1.6.4

