Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:60074 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbYIHQqg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 12:46:36 -0400
Received: by nf-out-0910.google.com with SMTP id d3so437734nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 08 Sep 2008 09:46:34 -0700 (PDT)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Make RFKILL enabled by default
Date: Mon, 8 Sep 2008 18:46:29 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200809081846.30096.IvDoorn@gmail.com> (sfid-20080908_184639_885494_50BF0975)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RFKILL should be enabled for _all_ hardware whether
or not they feature a rfkill button or not.

Remove driver specific RFKILL configuration options
and make the rt2x00lib version depend on CONFIG_RFKILL
and defaulting to 'y' to make sure it will always
be enabled when RFKILL was enabled.

This also fixes some bugs where RFKILL wasn't initialized
and didn't respond to RFKILL key presses.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/Kconfig        |   30 +---------------
 drivers/net/wireless/rt2x00/rt2400pci.c    |    8 ++--
 drivers/net/wireless/rt2x00/rt2500pci.c    |    8 ++--
 drivers/net/wireless/rt2x00/rt2x00rfkill.c |   50 +++++++++++++++------------
 drivers/net/wireless/rt2x00/rt61pci.c      |    8 ++--
 5 files changed, 42 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index 11f590d..c896c99 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -40,7 +40,8 @@ config RT2X00_LIB_CRYPTO
 config RT2X00_LIB_RFKILL
 	boolean
 	depends on RT2X00_LIB
-	select RFKILL
+	depends on RFKILL
+	default y
 
 config RT2X00_LIB_LEDS
 	boolean
@@ -57,15 +58,6 @@ config RT2400PCI
 
 	  When compiled as a module, this driver will be called "rt2400pci.ko".
 
-config RT2400PCI_RFKILL
-	bool "Ralink rt2400 rfkill support"
-	depends on RT2400PCI
-	select RT2X00_LIB_RFKILL
-	---help---
-	  This adds support for integrated rt2400 hardware that features a
-	  hardware button to control the radio state.
-	  This feature depends on the RF switch subsystem rfkill.
-
 config RT2400PCI_LEDS
 	bool "Ralink rt2400 leds support"
 	depends on RT2400PCI && NEW_LEDS
@@ -85,15 +77,6 @@ config RT2500PCI
 
 	  When compiled as a module, this driver will be called "rt2500pci.ko".
 
-config RT2500PCI_RFKILL
-	bool "Ralink rt2500 rfkill support"
-	depends on RT2500PCI
-	select RT2X00_LIB_RFKILL
-	---help---
-	  This adds support for integrated rt2500 hardware that features a
-	  hardware button to control the radio state.
-	  This feature depends on the RF switch subsystem rfkill.
-
 config RT2500PCI_LEDS
 	bool "Ralink rt2500 leds support"
 	depends on RT2500PCI && NEW_LEDS
@@ -116,15 +99,6 @@ config RT61PCI
 
 	  When compiled as a module, this driver will be called "rt61pci.ko".
 
-config RT61PCI_RFKILL
-	bool "Ralink rt2501/rt61 rfkill support"
-	depends on RT61PCI
-	select RT2X00_LIB_RFKILL
-	---help---
-	  This adds support for integrated rt61 hardware that features a
-	  hardware button to control the radio state.
-	  This feature depends on the RF switch subsystem rfkill.
-
 config RT61PCI_LEDS
 	bool "Ralink rt2501/rt61 leds support"
 	depends on RT61PCI && NEW_LEDS
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 18b703c..0083e7e 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -231,7 +231,7 @@ static const struct rt2x00debug rt2400pci_rt2x00debug = {
 };
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 
-#ifdef CONFIG_RT2400PCI_RFKILL
+#ifdef CONFIG_RT2X00_LIB_RFKILL
 static int rt2400pci_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
@@ -241,7 +241,7 @@ static int rt2400pci_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 }
 #else
 #define rt2400pci_rfkill_poll	NULL
-#endif /* CONFIG_RT2400PCI_RFKILL */
+#endif /* CONFIG_RT2X00_LIB_RFKILL */
 
 #ifdef CONFIG_RT2400PCI_LEDS
 static void rt2400pci_brightness_set(struct led_classdev *led_cdev,
@@ -1386,10 +1386,10 @@ static int rt2400pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Detect if this device has an hardware controlled radio.
 	 */
-#ifdef CONFIG_RT2400PCI_RFKILL
+#ifdef CONFIG_RT2X00_LIB_RFKILL
 	if (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_HARDWARE_RADIO))
 		__set_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags);
-#endif /* CONFIG_RT2400PCI_RFKILL */
+#endif /* CONFIG_RT2X00_LIB_RFKILL */
 
 	/*
 	 * Check if the BBP tuning should be enabled.
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 2a96a01..d8c9d67 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -231,7 +231,7 @@ static const struct rt2x00debug rt2500pci_rt2x00debug = {
 };
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 
-#ifdef CONFIG_RT2500PCI_RFKILL
+#ifdef CONFIG_RT2X00_LIB_RFKILL
 static int rt2500pci_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
@@ -241,7 +241,7 @@ static int rt2500pci_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 }
 #else
 #define rt2500pci_rfkill_poll	NULL
-#endif /* CONFIG_RT2500PCI_RFKILL */
+#endif /* CONFIG_RT2X00_LIB_RFKILL */
 
 #ifdef CONFIG_RT2500PCI_LEDS
 static void rt2500pci_brightness_set(struct led_classdev *led_cdev,
@@ -1545,10 +1545,10 @@ static int rt2500pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Detect if this device has an hardware controlled radio.
 	 */
-#ifdef CONFIG_RT2500PCI_RFKILL
+#ifdef CONFIG_RT2X00_LIB_RFKILL
 	if (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_HARDWARE_RADIO))
 		__set_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags);
-#endif /* CONFIG_RT2500PCI_RFKILL */
+#endif /* CONFIG_RT2X00_LIB_RFKILL */
 
 	/*
 	 * Check if the BBP tuning should be enabled.
diff --git a/drivers/net/wireless/rt2x00/rt2x00rfkill.c b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
index 8a2fefb..55eff58 100644
--- a/drivers/net/wireless/rt2x00/rt2x00rfkill.c
+++ b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
@@ -45,16 +45,15 @@ static int rt2x00rfkill_toggle_radio(void *data, enum rfkill_state state)
 		return 0;
 
 	if (state == RFKILL_STATE_UNBLOCKED) {
-		INFO(rt2x00dev, "Hardware button pressed, enabling radio.\n");
+		INFO(rt2x00dev, "RFKILL event: enabling radio.\n");
 		clear_bit(DEVICE_STATE_DISABLED_RADIO_HW, &rt2x00dev->flags);
 		retval = rt2x00lib_enable_radio(rt2x00dev);
 	} else if (state == RFKILL_STATE_SOFT_BLOCKED) {
-		INFO(rt2x00dev, "Hardware button pressed, disabling radio.\n");
+		INFO(rt2x00dev, "RFKILL event: disabling radio.\n");
 		set_bit(DEVICE_STATE_DISABLED_RADIO_HW, &rt2x00dev->flags);
 		rt2x00lib_disable_radio(rt2x00dev);
 	} else {
-		WARNING(rt2x00dev, "Received unexpected rfkill state %d.\n",
-			state);
+		WARNING(rt2x00dev, "RFKILL event: unknown state %d.\n", state);
 	}
 
 	return retval;
@@ -64,7 +63,12 @@ static int rt2x00rfkill_get_state(void *data, enum rfkill_state *state)
 {
 	struct rt2x00_dev *rt2x00dev = data;
 
-	*state = rt2x00dev->rfkill->state;
+	/*
+	 * rfkill_poll reports 1 when the key has been pressed and the
+	 * radio should be blocked.
+	 */
+	*state = rt2x00dev->ops->lib->rfkill_poll(rt2x00dev) ?
+	    RFKILL_STATE_SOFT_BLOCKED : RFKILL_STATE_UNBLOCKED;
 
 	return 0;
 }
@@ -73,19 +77,18 @@ static void rt2x00rfkill_poll(struct work_struct *work)
 {
 	struct rt2x00_dev *rt2x00dev =
 	    container_of(work, struct rt2x00_dev, rfkill_work.work);
-	int state;
+	enum rfkill_state state;
 
-	if (!test_bit(RFKILL_STATE_REGISTERED, &rt2x00dev->rfkill_state))
+	if (!test_bit(RFKILL_STATE_REGISTERED, &rt2x00dev->rfkill_state) ||
+	    !test_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags))
 		return;
 
 	/*
-	 * rfkill_poll reports 1 when the key has been pressed and the
-	 * radio should be blocked.
+	 * Poll latest state and report it to rfkill who should sort
+	 * out if the state should be toggled or not.
 	 */
-	state = !rt2x00dev->ops->lib->rfkill_poll(rt2x00dev) ?
-	    RFKILL_STATE_UNBLOCKED : RFKILL_STATE_SOFT_BLOCKED;
-
-	rfkill_force_state(rt2x00dev->rfkill, state);
+	if (!rt2x00rfkill_get_state(rt2x00dev, &state))
+		rfkill_force_state(rt2x00dev->rfkill, state);
 
 	queue_delayed_work(rt2x00dev->hw->workqueue,
 			   &rt2x00dev->rfkill_work, RFKILL_POLL_INTERVAL);
@@ -93,8 +96,8 @@ static void rt2x00rfkill_poll(struct work_struct *work)
 
 void rt2x00rfkill_register(struct rt2x00_dev *rt2x00dev)
 {
-	if (!test_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags) ||
-	    !test_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->rfkill_state))
+	if (!test_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->rfkill_state) ||
+	    test_bit(RFKILL_STATE_REGISTERED, &rt2x00dev->rfkill_state))
 		return;
 
 	if (rfkill_register(rt2x00dev->rfkill)) {
@@ -114,7 +117,7 @@ void rt2x00rfkill_register(struct rt2x00_dev *rt2x00dev)
 
 void rt2x00rfkill_unregister(struct rt2x00_dev *rt2x00dev)
 {
-	if (!test_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags) ||
+	if (!test_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->rfkill_state) ||
 	    !test_bit(RFKILL_STATE_REGISTERED, &rt2x00dev->rfkill_state))
 		return;
 
@@ -127,21 +130,25 @@ void rt2x00rfkill_unregister(struct rt2x00_dev *rt2x00dev)
 
 void rt2x00rfkill_allocate(struct rt2x00_dev *rt2x00dev)
 {
-	if (!test_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags))
+	struct device *dev = wiphy_dev(rt2x00dev->hw->wiphy);
+
+	if (test_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->rfkill_state))
 		return;
 
-	rt2x00dev->rfkill =
-	    rfkill_allocate(wiphy_dev(rt2x00dev->hw->wiphy), RFKILL_TYPE_WLAN);
+	rt2x00dev->rfkill = rfkill_allocate(dev, RFKILL_TYPE_WLAN);
 	if (!rt2x00dev->rfkill) {
 		ERROR(rt2x00dev, "Failed to allocate rfkill handler.\n");
 		return;
 	}
 
+	__set_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->rfkill_state);
+
 	rt2x00dev->rfkill->name = rt2x00dev->ops->name;
 	rt2x00dev->rfkill->data = rt2x00dev;
 	rt2x00dev->rfkill->state = -1;
 	rt2x00dev->rfkill->toggle_radio = rt2x00rfkill_toggle_radio;
-	rt2x00dev->rfkill->get_state = rt2x00rfkill_get_state;
+	if (test_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags))
+		rt2x00dev->rfkill->get_state = rt2x00rfkill_get_state;
 
 	INIT_DELAYED_WORK(&rt2x00dev->rfkill_work, rt2x00rfkill_poll);
 
@@ -150,8 +157,7 @@ void rt2x00rfkill_allocate(struct rt2x00_dev *rt2x00dev)
 
 void rt2x00rfkill_free(struct rt2x00_dev *rt2x00dev)
 {
-	if (!test_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags) ||
-	    !test_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->rfkill_state))
+	if (!test_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->flags))
 		return;
 
 	cancel_delayed_work_sync(&rt2x00dev->rfkill_work);
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index d740f56..a5c9352 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -271,7 +271,7 @@ static const struct rt2x00debug rt61pci_rt2x00debug = {
 };
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 
-#ifdef CONFIG_RT61PCI_RFKILL
+#ifdef CONFIG_RT2X00_LIB_RFKILL
 static int rt61pci_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
@@ -281,7 +281,7 @@ static int rt61pci_rfkill_poll(struct rt2x00_dev *rt2x00dev)
 }
 #else
 #define rt61pci_rfkill_poll	NULL
-#endif /* CONFIG_RT61PCI_RFKILL */
+#endif /* CONFIG_RT2X00_LIB_RFKILL */
 
 #ifdef CONFIG_RT61PCI_LEDS
 static void rt61pci_brightness_set(struct led_classdev *led_cdev,
@@ -2313,10 +2313,10 @@ static int rt61pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Detect if this device has an hardware controlled radio.
 	 */
-#ifdef CONFIG_RT61PCI_RFKILL
+#ifdef CONFIG_RT2X00_LIB_RFKILL
 	if (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_HARDWARE_RADIO))
 		__set_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags);
-#endif /* CONFIG_RT61PCI_RFKILL */
+#endif /* CONFIG_RT2X00_LIB_RFKILL */
 
 	/*
 	 * Read frequency offset and RF programming sequence.
-- 
1.5.6.1

