Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:55730 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758568AbXGYUsi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 16:48:38 -0400
Received: by ug-out-1314.google.com with SMTP id j3so420021ugf
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2007 13:48:38 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 07/11] rt2x00: Don't toggle promisc mode in link_tuner
Date: Wed, 25 Jul 2007 22:50:18 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707252250.18745.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 582bd822ff4318911ba7f676efbed573d11de339 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Tue, 24 Jul 2007 18:02:37 +0200
Subject: [PATCH 07/11] rt2x00: Don't toggle promisc mode in link_tuner

We shouldn't abuse the link tuner by using it
for scheduled promisc mode toggling.
Add a new flag that indicates if promisc mode
can be toggled atomically or not. For
non-atomic promisc mode toggling we leave
the task to the config() handler the next
time that is run.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/mac80211/rt2x00/rt2500usb.c |    2 ++
 drivers/net/wireless/mac80211/rt2x00/rt2x00.h    |    3 ++-
 drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c |    6 ------
 drivers/net/wireless/mac80211/rt2x00/rt2x00mac.c |   21 +++++++++++++--------
 drivers/net/wireless/mac80211/rt2x00/rt61pci.c   |    2 +-
 drivers/net/wireless/mac80211/rt2x00/rt73usb.c   |    4 +++-
 6 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
index 77e7a95..aa63b6d 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
@@ -1418,8 +1418,10 @@ static int rt2500usb_init_hw(struct rt2x00_dev *rt2x00dev)
 	rt2500usb_init_hw_mode(rt2x00dev);
 
 	/*
+	 * USB devices require scheduled promisc mode toggling
 	 * This device supports ATIM
 	 */
+	__set_bit(REQUIRE_SCHEDULE_PROMISC, &rt2x00dev->flags);
 	__set_bit(DEVICE_SUPPORT_ATIM, &rt2x00dev->flags);
 
 	/*
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
index 4a71a96..bae34f9 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
@@ -777,7 +777,8 @@ struct rt2x00_dev {
 #define DEVICE_ENABLED_RADIO_HW		2
 #define DEVICE_INITIALIZED		3
 #define DEVICE_INITIALIZED_HW		4
-#define FIRMWARE_REQUIRED		5
+#define REQUIRE_FIRMWARE		5
+#define REQUIRE_SCHEDULE_PROMISC	6
 /* Gap: New flags can be inserted here */
 #define INTERFACE_ENABLED		8
 #define INTERFACE_ENABLED_MONITOR	9
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c b/drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c
index b8c3f7b..43a606f 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c
@@ -106,12 +106,6 @@ static void rt2x00lib_link_tuner(struct work_struct *work)
 		container_of(work, struct rt2x00_dev, link.work.work);
 
 	/*
-	 * Update promisc mode (this function will first check
-	 * if updating is really required).
-	 */
-	rt2x00lib_config_promisc(rt2x00dev, rt2x00dev->interface.promisc);
-
-	/*
 	 * Cancel all link tuning if the eeprom has indicated
 	 * it is not required.
 	 */
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00mac.c b/drivers/net/wireless/mac80211/rt2x00/rt2x00mac.c
index 447c55c..247ea4e 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00mac.c
@@ -166,7 +166,7 @@ int rt2x00lib_add_interface(struct ieee80211_hw *hw,
 		/*
 		 * We must load firmware before we can safely continue.
 		 */
-		if (test_bit(FIRMWARE_REQUIRED, &rt2x00dev->flags)) {
+		if (test_bit(REQUIRE_FIRMWARE, &rt2x00dev->flags)) {
 			status = rt2x00lib_load_firmware(rt2x00dev);
 			if (status)
 				return status;
@@ -266,6 +266,14 @@ int rt2x00lib_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
 		conf->beacon_int);
 
 	/*
+	 * If promisc mode cannot be configured in irq context,
+	 * then it is now the time to configure it.
+	 */
+	if (test_bit(REQUIRE_SCHEDULE_PROMISC, &rt2x00dev->flags))
+		rt2x00lib_config_promisc(rt2x00dev,
+			rt2x00dev->interface.promisc);
+
+	/*
 	 * Reenable RX only if the radio should be on.
 	 */
 	if (test_bit(DEVICE_ENABLED_RADIO, &rt2x00dev->flags))
@@ -345,13 +353,10 @@ void rt2x00lib_set_multicast_list(struct ieee80211_hw *hw,
 
 	rt2x00dev->interface.promisc = !!(flags & IFF_PROMISC);
 
-	/*
-	 * Schedule the link tuner if this does not run
-	 * automatically. The link tuner will be automatically
-	 * switched off when it is not required.
-	 */
-	if (!work_pending(&rt2x00dev->link.work.work))
-		queue_work(rt2x00dev->hw->workqueue, &rt2x00dev->link.work.work);
+	if (!test_bit(REQUIRE_SCHEDULE_PROMISC, &rt2x00dev->flags) ||
+	    !in_atomic())
+		rt2x00lib_config_promisc(rt2x00dev,
+			rt2x00dev->interface.promisc);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_set_multicast_list);
 
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
index 3999cc8..937b120 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
@@ -2222,7 +2222,7 @@ static int rt61pci_init_hw(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * This device requires firmware
 	 */
-	__set_bit(FIRMWARE_REQUIRED, &rt2x00dev->flags);
+	__set_bit(REQUIRE_FIRMWARE, &rt2x00dev->flags);
 
 	/*
 	 * Set the rssi offset.
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
index 0188c72..3505bf6 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
@@ -1667,9 +1667,11 @@ static int rt73usb_init_hw(struct rt2x00_dev *rt2x00dev)
 	rt73usb_init_hw_mode(rt2x00dev);
 
 	/*
+	 * USB devices require scheduled promisc mode toggling
 	 * This device requires firmware
 	 */
-	__set_bit(FIRMWARE_REQUIRED, &rt2x00dev->flags);
+	__set_bit(REQUIRE_FIRMWARE, &rt2x00dev->flags);
+	__set_bit(REQUIRE_SCHEDULE_PROMISC, &rt2x00dev->flags);
 
 	/*
 	 * Set the rssi offset.
-- 
1.5.2.2

