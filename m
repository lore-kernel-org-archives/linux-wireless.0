Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59741 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbZFESTU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 14:19:20 -0400
Date: Fri, 05 Jun 2009 13:19:19 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
Subject: [RFC V2] b43/legacy: port to cfg80211 rfkill
Message-ID: <4a2961a7.RxVbjEA4JdOf01BF%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

This ports the b43/legacy rfkill code to the new API offered
by cfg80211 and thus removes a lot of useless stuff.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>
---

V1 - Original by Johannes.
V2 - Modified in testing by Larry.
     The rfkill polling routine brings the interface back to the initialized
     state if it is found to be uninitialized. This way the rfkill switch
     may be interpreted. In addition, the radio LED is not turned on in the
     initialization routine unless the rfkill switch is on.

 b43/Kconfig           |    7 ---
 b43/Makefile          |    2
 b43/b43.h             |    3 -
 b43/leds.c            |    7 +--
 b43/main.c            |   30 ++++----------
 b43/main.h            |    2
 b43/phy_common.h      |    2
 b43/rfkill.c          |  102 ++++-------------------------------------------
 b43/rfkill.h          |   44 +-------------------
 b43legacy/Kconfig     |    8 ---
 b43legacy/Makefile    |    2
 b43legacy/b43legacy.h |    3 -
 b43legacy/leds.c      |    7 +--
 b43legacy/main.c      |   20 ++-------
 b43legacy/main.h      |    2
 b43legacy/rfkill.c    |  107 ++++----------------------------------------------
 b43legacy/rfkill.h    |   50 +----------------------
 17 files changed, 55 insertions(+), 343 deletions(-)

Index: wireless-testing/drivers/net/wireless/b43/Kconfig
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/Kconfig
+++ wireless-testing/drivers/net/wireless/b43/Kconfig
@@ -98,13 +98,6 @@ config B43_LEDS
 	depends on B43 && MAC80211_LEDS && (LEDS_CLASS = y || LEDS_CLASS = B43)
 	default y
 
-# This config option automatically enables b43 RFKILL support,
-# if it's possible.
-config B43_RFKILL
-	bool
-	depends on B43 && (RFKILL = y || RFKILL = B43)
-	default y
-
 # This config option automatically enables b43 HW-RNG support,
 # if the HW-RNG core is enabled.
 config B43_HWRNG
Index: wireless-testing/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/b43.h
+++ wireless-testing/drivers/net/wireless/b43/b43.h
@@ -631,9 +631,6 @@ struct b43_wl {
 	char rng_name[30 + 1];
 #endif /* CONFIG_B43_HWRNG */
 
-	/* The RF-kill button */
-	struct b43_rfkill rfkill;
-
 	/* List of all wireless devices on this chip */
 	struct list_head devlist;
 	u8 nr_devs;
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c
+++ wireless-testing/drivers/net/wireless/b43/main.c
@@ -285,7 +285,6 @@ static struct ieee80211_supported_band b
 };
 
 static void b43_wireless_core_exit(struct b43_wldev *dev);
-static int b43_wireless_core_init(struct b43_wldev *dev);
 static void b43_wireless_core_stop(struct b43_wldev *dev);
 static int b43_wireless_core_start(struct b43_wldev *dev);
 
@@ -4103,7 +4102,7 @@ static void b43_wireless_core_exit(struc
 }
 
 /* Initialize a wireless core */
-static int b43_wireless_core_init(struct b43_wldev *dev)
+int b43_wireless_core_init(struct b43_wldev *dev)
 {
 	struct b43_wl *wl = dev->wl;
 	struct ssb_bus *bus = dev->dev->bus;
@@ -4298,7 +4297,6 @@ static int b43_op_start(struct ieee80211
 	struct b43_wldev *dev = wl->current_dev;
 	int did_init = 0;
 	int err = 0;
-	bool do_rfkill_exit = 0;
 
 	/* Kill all old instance specific information to make sure
 	 * the card won't use it in the short timeframe between start
@@ -4312,18 +4310,12 @@ static int b43_op_start(struct ieee80211
 	wl->beacon1_uploaded = 0;
 	wl->beacon_templates_virgin = 1;
 
-	/* First register RFkill.
-	 * LEDs that are registered later depend on it. */
-	b43_rfkill_init(dev);
-
 	mutex_lock(&wl->mutex);
 
 	if (b43_status(dev) < B43_STAT_INITIALIZED) {
 		err = b43_wireless_core_init(dev);
-		if (err) {
-			do_rfkill_exit = 1;
+		if (err)
 			goto out_mutex_unlock;
-		}
 		did_init = 1;
 	}
 
@@ -4332,17 +4324,16 @@ static int b43_op_start(struct ieee80211
 		if (err) {
 			if (did_init)
 				b43_wireless_core_exit(dev);
-			do_rfkill_exit = 1;
 			goto out_mutex_unlock;
 		}
 	}
 
+	/* XXX: only do if device doesn't support rfkill irq */
+	wiphy_rfkill_start_polling(hw->wiphy);
+
  out_mutex_unlock:
 	mutex_unlock(&wl->mutex);
 
-	if (do_rfkill_exit)
-		b43_rfkill_exit(dev);
-
 	return err;
 }
 
@@ -4351,7 +4342,6 @@ static void b43_op_stop(struct ieee80211
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev = wl->current_dev;
 
-	b43_rfkill_exit(dev);
 	cancel_work_sync(&(wl->beacon_update_trigger));
 
 	mutex_lock(&wl->mutex);
@@ -4433,6 +4423,7 @@ static const struct ieee80211_ops b43_hw
 	.sta_notify		= b43_op_sta_notify,
 	.sw_scan_start		= b43_op_sw_scan_start_notifier,
 	.sw_scan_complete	= b43_op_sw_scan_complete_notifier,
+	.rfkill_poll		= b43_rfkill_poll,
 };
 
 /* Hard-reset the chip. Do not call this directly.
@@ -4920,7 +4911,7 @@ static struct ssb_driver b43_ssb_driver
 static void b43_print_driverinfo(void)
 {
 	const char *feat_pci = "", *feat_pcmcia = "", *feat_nphy = "",
-		   *feat_leds = "", *feat_rfkill = "";
+		   *feat_leds = "";
 
 #ifdef CONFIG_B43_PCI_AUTOSELECT
 	feat_pci = "P";
@@ -4934,14 +4925,11 @@ static void b43_print_driverinfo(void)
 #ifdef CONFIG_B43_LEDS
 	feat_leds = "L";
 #endif
-#ifdef CONFIG_B43_RFKILL
-	feat_rfkill = "R";
-#endif
 	printk(KERN_INFO "Broadcom 43xx driver loaded "
-	       "[ Features: %s%s%s%s%s, Firmware-ID: "
+	       "[ Features: %s%s%s%s, Firmware-ID: "
 	       B43_SUPPORTED_FIRMWARE_ID " ]\n",
 	       feat_pci, feat_pcmcia, feat_nphy,
-	       feat_leds, feat_rfkill);
+	       feat_leds);
 }
 
 static int __init b43_init(void)
Index: wireless-testing/drivers/net/wireless/b43/rfkill.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/rfkill.c
+++ wireless-testing/drivers/net/wireless/b43/rfkill.c
@@ -22,7 +22,6 @@
 
 */
 
-#include "rfkill.h"
 #include "b43.h"
 #include "phy_common.h"
 
@@ -30,7 +29,7 @@
 
 
 /* Returns TRUE, if the radio is enabled in hardware. */
-static bool b43_is_hw_radio_enabled(struct b43_wldev *dev)
+bool b43_is_hw_radio_enabled(struct b43_wldev *dev)
 {
 	if (dev->phy.rev >= 3) {
 		if (!(b43_read32(dev, B43_MMIO_RADIO_HWENABLED_HI)
@@ -45,110 +44,27 @@ static bool b43_is_hw_radio_enabled(stru
 }
 
 /* The poll callback for the hardware button. */
-static void b43_rfkill_poll(struct rfkill *rfkill, void *data)
+void b43_rfkill_poll(struct ieee80211_hw *hw)
 {
-	struct b43_wldev *dev = data;
-	struct b43_wl *wl = dev->wl;
+	struct b43_wl *wl = hw_to_b43_wl(hw);
+	struct b43_wldev *dev = wl->current_dev;
 	bool enabled;
 
 	mutex_lock(&wl->mutex);
 	if (unlikely(b43_status(dev) < B43_STAT_INITIALIZED)) {
-		mutex_unlock(&wl->mutex);
-		return;
+		if (b43_wireless_core_init(dev)) {
+			mutex_unlock(&wl->mutex);
+			return;
+		}
 	}
 	enabled = b43_is_hw_radio_enabled(dev);
 	if (unlikely(enabled != dev->radio_hw_enable)) {
 		dev->radio_hw_enable = enabled;
 		b43info(wl, "Radio hardware status changed to %s\n",
 			enabled ? "ENABLED" : "DISABLED");
-		enabled = !rfkill_set_hw_state(rfkill, !enabled);
+		wiphy_rfkill_set_hw_state(hw->wiphy, !enabled);
 		if (enabled != dev->phy.radio_on)
 			b43_software_rfkill(dev, !enabled);
 	}
 	mutex_unlock(&wl->mutex);
 }
-
-/* Called when the RFKILL toggled in software. */
-static int b43_rfkill_soft_set(void *data, bool blocked)
-{
-	struct b43_wldev *dev = data;
-	struct b43_wl *wl = dev->wl;
-	int err = -EINVAL;
-
-	if (WARN_ON(!wl->rfkill.registered))
-		return -EINVAL;
-
-	mutex_lock(&wl->mutex);
-
-	if (b43_status(dev) < B43_STAT_INITIALIZED)
-		goto out_unlock;
-
-	if (!dev->radio_hw_enable)
-		goto out_unlock;
-
-	if (!blocked != dev->phy.radio_on)
-		b43_software_rfkill(dev, blocked);
-	err = 0;
-out_unlock:
-	mutex_unlock(&wl->mutex);
-	return err;
-}
-
-const char *b43_rfkill_led_name(struct b43_wldev *dev)
-{
-	struct b43_rfkill *rfk = &(dev->wl->rfkill);
-
-	if (!rfk->registered)
-		return NULL;
-	return rfkill_get_led_trigger_name(rfk->rfkill);
-}
-
-static const struct rfkill_ops b43_rfkill_ops = {
-	.set_block = b43_rfkill_soft_set,
-	.poll = b43_rfkill_poll,
-};
-
-void b43_rfkill_init(struct b43_wldev *dev)
-{
-	struct b43_wl *wl = dev->wl;
-	struct b43_rfkill *rfk = &(wl->rfkill);
-	int err;
-
-	rfk->registered = 0;
-
-	snprintf(rfk->name, sizeof(rfk->name),
-		 "b43-%s", wiphy_name(wl->hw->wiphy));
-
-	rfk->rfkill = rfkill_alloc(rfk->name,
-				   dev->dev->dev,
-				   RFKILL_TYPE_WLAN,
-				   &b43_rfkill_ops, dev);
-	if (!rfk->rfkill)
-		goto out_error;
-
-	err = rfkill_register(rfk->rfkill);
-	if (err)
-		goto err_free;
-
-	rfk->registered = 1;
-
-	return;
- err_free:
-	rfkill_destroy(rfk->rfkill);
- out_error:
-	rfk->registered = 0;
-	b43warn(wl, "RF-kill button init failed\n");
-}
-
-void b43_rfkill_exit(struct b43_wldev *dev)
-{
-	struct b43_rfkill *rfk = &(dev->wl->rfkill);
-
-	if (!rfk->registered)
-		return;
-	rfk->registered = 0;
-
-	rfkill_unregister(rfk->rfkill);
-	rfkill_destroy(rfk->rfkill);
-	rfk->rfkill = NULL;
-}
Index: wireless-testing/drivers/net/wireless/b43/rfkill.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/rfkill.h
+++ wireless-testing/drivers/net/wireless/b43/rfkill.h
@@ -1,49 +1,13 @@
 #ifndef B43_RFKILL_H_
 #define B43_RFKILL_H_
 
+struct ieee80211_hw;
 struct b43_wldev;
 
+void b43_rfkill_poll(struct ieee80211_hw *hw);
 
-#ifdef CONFIG_B43_RFKILL
+int b43_wireless_core_init(struct b43_wldev *dev);
 
-#include <linux/rfkill.h>
-
-
-struct b43_rfkill {
-	/* The RFKILL subsystem data structure */
-	struct rfkill *rfkill;
-	/* Did initialization succeed? Used for freeing. */
-	bool registered;
-	/* The unique name of this rfkill switch */
-	char name[sizeof("b43-phy4294967295")];
-};
-
-/* The init function returns void, because we are not interested
- * in failing the b43 init process when rfkill init failed. */
-void b43_rfkill_init(struct b43_wldev *dev);
-void b43_rfkill_exit(struct b43_wldev *dev);
-
-const char *b43_rfkill_led_name(struct b43_wldev *dev);
-
-
-#else /* CONFIG_B43_RFKILL */
-/* No RFKILL support. */
-
-struct b43_rfkill {
-	/* empty */
-};
-
-static inline void b43_rfkill_init(struct b43_wldev *dev)
-{
-}
-static inline void b43_rfkill_exit(struct b43_wldev *dev)
-{
-}
-static inline char * b43_rfkill_led_name(struct b43_wldev *dev)
-{
-	return NULL;
-}
-
-#endif /* CONFIG_B43_RFKILL */
+bool b43_is_hw_radio_enabled(struct b43_wldev *dev);
 
 #endif /* B43_RFKILL_H_ */
Index: wireless-testing/drivers/net/wireless/b43/Makefile
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/Makefile
+++ wireless-testing/drivers/net/wireless/b43/Makefile
@@ -13,7 +13,7 @@ b43-y				+= lo.o
 b43-y				+= wa.o
 b43-y				+= dma.o
 b43-$(CONFIG_B43_PIO)		+= pio.o
-b43-$(CONFIG_B43_RFKILL)	+= rfkill.o
+b43-y				+= rfkill.o
 b43-$(CONFIG_B43_LEDS)		+= leds.o
 b43-$(CONFIG_B43_PCMCIA)	+= pcmcia.o
 b43-$(CONFIG_B43_DEBUG)		+= debugfs.o
Index: wireless-testing/drivers/net/wireless/b43legacy/Kconfig
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/Kconfig
+++ wireless-testing/drivers/net/wireless/b43legacy/Kconfig
@@ -42,14 +42,6 @@ config B43LEGACY_LEDS
 	depends on B43LEGACY && MAC80211_LEDS && (LEDS_CLASS = y || LEDS_CLASS = B43LEGACY)
 	default y
 
-# RFKILL support
-# This config option automatically enables b43legacy RFKILL support,
-# if it's possible.
-config B43LEGACY_RFKILL
-	bool
-	depends on B43LEGACY && (RFKILL = y || RFKILL = B43LEGACY)
-	default y
-
 # This config option automatically enables b43 HW-RNG support,
 # if the HW-RNG core is enabled.
 config B43LEGACY_HWRNG
Index: wireless-testing/drivers/net/wireless/b43legacy/Makefile
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/Makefile
+++ wireless-testing/drivers/net/wireless/b43legacy/Makefile
@@ -6,7 +6,7 @@ b43legacy-y				+= radio.o
 b43legacy-y				+= sysfs.o
 b43legacy-y				+= xmit.o
 # b43 RFKILL button support
-b43legacy-$(CONFIG_B43LEGACY_RFKILL)	+= rfkill.o
+b43legacy-y				+= rfkill.o
 # b43legacy LED support
 b43legacy-$(CONFIG_B43LEGACY_LEDS)	+= leds.o
 # b43legacy debugging
Index: wireless-testing/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-testing/drivers/net/wireless/b43legacy/main.c
@@ -159,7 +159,6 @@ static struct ieee80211_supported_band b
 };
 
 static void b43legacy_wireless_core_exit(struct b43legacy_wldev *dev);
-static int b43legacy_wireless_core_init(struct b43legacy_wldev *dev);
 static void b43legacy_wireless_core_stop(struct b43legacy_wldev *dev);
 static int b43legacy_wireless_core_start(struct b43legacy_wldev *dev);
 
@@ -3230,7 +3229,7 @@ static void prepare_phy_data_for_init(st
 }
 
 /* Initialize a wireless core */
-static int b43legacy_wireless_core_init(struct b43legacy_wldev *dev)
+int b43legacy_wireless_core_init(struct b43legacy_wldev *dev)
 {
 	struct b43legacy_wl *wl = dev->wl;
 	struct ssb_bus *bus = dev->dev->bus;
@@ -3431,11 +3430,6 @@ static int b43legacy_op_start(struct iee
 	struct b43legacy_wldev *dev = wl->current_dev;
 	int did_init = 0;
 	int err = 0;
-	bool do_rfkill_exit = 0;
-
-	/* First register RFkill.
-	 * LEDs that are registered later depend on it. */
-	b43legacy_rfkill_init(dev);
 
 	/* Kill all old instance specific information to make sure
 	 * the card won't use it in the short timeframe between start
@@ -3451,10 +3445,8 @@ static int b43legacy_op_start(struct iee
 
 	if (b43legacy_status(dev) < B43legacy_STAT_INITIALIZED) {
 		err = b43legacy_wireless_core_init(dev);
-		if (err) {
-			do_rfkill_exit = 1;
+		if (err)
 			goto out_mutex_unlock;
-		}
 		did_init = 1;
 	}
 
@@ -3463,17 +3455,15 @@ static int b43legacy_op_start(struct iee
 		if (err) {
 			if (did_init)
 				b43legacy_wireless_core_exit(dev);
-			do_rfkill_exit = 1;
 			goto out_mutex_unlock;
 		}
 	}
 
+	wiphy_rfkill_start_polling(hw->wiphy);
+
 out_mutex_unlock:
 	mutex_unlock(&wl->mutex);
 
-	if (do_rfkill_exit)
-		b43legacy_rfkill_exit(dev);
-
 	return err;
 }
 
@@ -3482,7 +3472,6 @@ static void b43legacy_op_stop(struct iee
 	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
 	struct b43legacy_wldev *dev = wl->current_dev;
 
-	b43legacy_rfkill_exit(dev);
 	cancel_work_sync(&(wl->beacon_update_trigger));
 
 	mutex_lock(&wl->mutex);
@@ -3518,6 +3507,7 @@ static const struct ieee80211_ops b43leg
 	.start			= b43legacy_op_start,
 	.stop			= b43legacy_op_stop,
 	.set_tim		= b43legacy_op_beacon_set_tim,
+	.rfkill_poll		= b43legacy_rfkill_poll,
 };
 
 /* Hard-reset the chip. Do not call this directly.
Index: wireless-testing/drivers/net/wireless/b43legacy/rfkill.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/rfkill.c
+++ wireless-testing/drivers/net/wireless/b43legacy/rfkill.c
@@ -22,7 +22,6 @@
 
 */
 
-#include "rfkill.h"
 #include "radio.h"
 #include "b43legacy.h"
 
@@ -30,7 +29,7 @@
 
 
 /* Returns TRUE, if the radio is enabled in hardware. */
-static bool b43legacy_is_hw_radio_enabled(struct b43legacy_wldev *dev)
+bool b43legacy_is_hw_radio_enabled(struct b43legacy_wldev *dev)
 {
 	if (dev->phy.rev >= 3) {
 		if (!(b43legacy_read32(dev, B43legacy_MMIO_RADIO_HWENABLED_HI)
@@ -45,23 +44,25 @@ static bool b43legacy_is_hw_radio_enable
 }
 
 /* The poll callback for the hardware button. */
-static void b43legacy_rfkill_poll(struct rfkill *rfkill, void *data)
+void b43legacy_rfkill_poll(struct ieee80211_hw *hw)
 {
-	struct b43legacy_wldev *dev = data;
-	struct b43legacy_wl *wl = dev->wl;
+	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
+	struct b43legacy_wldev *dev = wl->current_dev;
 	bool enabled;
 
 	mutex_lock(&wl->mutex);
 	if (unlikely(b43legacy_status(dev) < B43legacy_STAT_INITIALIZED)) {
-		mutex_unlock(&wl->mutex);
-		return;
+		if (b43legacy_wireless_core_init(dev)) {
+			mutex_unlock(&wl->mutex);
+			return;
+		}
 	}
 	enabled = b43legacy_is_hw_radio_enabled(dev);
 	if (unlikely(enabled != dev->radio_hw_enable)) {
 		dev->radio_hw_enable = enabled;
 		b43legacyinfo(wl, "Radio hardware status changed to %s\n",
 			enabled ? "ENABLED" : "DISABLED");
-		enabled = !rfkill_set_hw_state(rfkill, !enabled);
+		wiphy_rfkill_set_hw_state(hw->wiphy, !enabled);
 		if (enabled != dev->phy.radio_on) {
 			if (enabled)
 				b43legacy_radio_turn_on(dev);
@@ -71,93 +72,3 @@ static void b43legacy_rfkill_poll(struct
 	}
 	mutex_unlock(&wl->mutex);
 }
-
-/* Called when the RFKILL toggled in software.
- * This is called without locking. */
-static int b43legacy_rfkill_soft_set(void *data, bool blocked)
-{
-	struct b43legacy_wldev *dev = data;
-	struct b43legacy_wl *wl = dev->wl;
-	int ret = -EINVAL;
-
-	if (!wl->rfkill.registered)
-		return -EINVAL;
-
-	mutex_lock(&wl->mutex);
-	if (b43legacy_status(dev) < B43legacy_STAT_INITIALIZED)
-		goto out_unlock;
-
-	if (!dev->radio_hw_enable)
-		goto out_unlock;
-
-	if (!blocked != dev->phy.radio_on) {
-		if (!blocked)
-			b43legacy_radio_turn_on(dev);
-		else
-			b43legacy_radio_turn_off(dev, 0);
-	}
-	ret = 0;
-
-out_unlock:
-	mutex_unlock(&wl->mutex);
-	return ret;
-}
-
-const char *b43legacy_rfkill_led_name(struct b43legacy_wldev *dev)
-{
-	struct b43legacy_rfkill *rfk = &(dev->wl->rfkill);
-
-	if (!rfk->registered)
-		return NULL;
-	return rfkill_get_led_trigger_name(rfk->rfkill);
-}
-
-static const struct rfkill_ops b43legacy_rfkill_ops = {
-	.set_block = b43legacy_rfkill_soft_set,
-	.poll = b43legacy_rfkill_poll,
-};
-
-void b43legacy_rfkill_init(struct b43legacy_wldev *dev)
-{
-	struct b43legacy_wl *wl = dev->wl;
-	struct b43legacy_rfkill *rfk = &(wl->rfkill);
-	int err;
-
-	rfk->registered = 0;
-
-	snprintf(rfk->name, sizeof(rfk->name),
-		 "b43legacy-%s", wiphy_name(wl->hw->wiphy));
-	rfk->rfkill = rfkill_alloc(rfk->name,
-				   dev->dev->dev,
-				   RFKILL_TYPE_WLAN,
-				   &b43legacy_rfkill_ops, dev);
-	if (!rfk->rfkill)
-		goto out_error;
-
-	err = rfkill_register(rfk->rfkill);
-	if (err)
-		goto err_free;
-
-	rfk->registered = 1;
-
-	return;
- err_free:
-	rfkill_destroy(rfk->rfkill);
- out_error:
-	rfk->registered = 0;
-	b43legacywarn(wl, "RF-kill button init failed\n");
-}
-
-void b43legacy_rfkill_exit(struct b43legacy_wldev *dev)
-{
-	struct b43legacy_rfkill *rfk = &(dev->wl->rfkill);
-
-	if (!rfk->registered)
-		return;
-	rfk->registered = 0;
-
-	rfkill_unregister(rfk->rfkill);
-	rfkill_destroy(rfk->rfkill);
-	rfk->rfkill = NULL;
-}
-
Index: wireless-testing/drivers/net/wireless/b43legacy/rfkill.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/rfkill.h
+++ wireless-testing/drivers/net/wireless/b43legacy/rfkill.h
@@ -1,55 +1,13 @@
 #ifndef B43legacy_RFKILL_H_
 #define B43legacy_RFKILL_H_
 
+struct ieee80211_hw;
 struct b43legacy_wldev;
 
-#ifdef CONFIG_B43LEGACY_RFKILL
+void b43legacy_rfkill_poll(struct ieee80211_hw *hw);
 
-#include <linux/rfkill.h>
+int b43legacy_wireless_core_init(struct b43legacy_wldev *dev);
 
-
-
-struct b43legacy_rfkill {
-	/* The RFKILL subsystem data structure */
-	struct rfkill *rfkill;
-	/* Did initialization succeed? Used for freeing. */
-	bool registered;
-	/* The unique name of this rfkill switch */
-	char name[sizeof("b43legacy-phy4294967295")];
-};
-
-/* The init function returns void, because we are not interested
- * in failing the b43 init process when rfkill init failed. */
-void b43legacy_rfkill_init(struct b43legacy_wldev *dev);
-void b43legacy_rfkill_exit(struct b43legacy_wldev *dev);
-
-const char *b43legacy_rfkill_led_name(struct b43legacy_wldev *dev);
-
-
-#else /* CONFIG_B43LEGACY_RFKILL */
-/* No RFKILL support. */
-
-struct b43legacy_rfkill {
-	/* empty */
-};
-
-static inline void b43legacy_rfkill_alloc(struct b43legacy_wldev *dev)
-{
-}
-static inline void b43legacy_rfkill_free(struct b43legacy_wldev *dev)
-{
-}
-static inline void b43legacy_rfkill_init(struct b43legacy_wldev *dev)
-{
-}
-static inline void b43legacy_rfkill_exit(struct b43legacy_wldev *dev)
-{
-}
-static inline char *b43legacy_rfkill_led_name(struct b43legacy_wldev *dev)
-{
-	return NULL;
-}
-
-#endif /* CONFIG_B43LEGACY_RFKILL */
+bool b43legacy_is_hw_radio_enabled(struct b43legacy_wldev *dev);
 
 #endif /* B43legacy_RFKILL_H_ */
Index: wireless-testing/drivers/net/wireless/b43legacy/b43legacy.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/b43legacy.h
+++ wireless-testing/drivers/net/wireless/b43legacy/b43legacy.h
@@ -602,9 +602,6 @@ struct b43legacy_wl {
 	char rng_name[30 + 1];
 #endif
 
-	/* The RF-kill button */
-	struct b43legacy_rfkill rfkill;
-
 	/* List of all wireless devices on this chip */
 	struct list_head devlist;
 	u8 nr_devs;
Index: wireless-testing/drivers/net/wireless/b43/phy_common.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_common.h
+++ wireless-testing/drivers/net/wireless/b43/phy_common.h
@@ -1,7 +1,7 @@
 #ifndef LINUX_B43_PHY_COMMON_H_
 #define LINUX_B43_PHY_COMMON_H_
 
-#include <linux/rfkill.h>
+#include <linux/types.h>
 
 struct b43_wldev;
 
Index: wireless-testing/drivers/net/wireless/b43/leds.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/leds.c
+++ wireless-testing/drivers/net/wireless/b43/leds.c
@@ -28,6 +28,7 @@
 
 #include "b43.h"
 #include "leds.h"
+#include "rfkill.h"
 
 
 static void b43_led_turn_on(struct b43_wldev *dev, u8 led_index,
@@ -164,10 +165,10 @@ static void b43_map_led(struct b43_wldev
 		snprintf(name, sizeof(name),
 			 "b43-%s::radio", wiphy_name(hw->wiphy));
 		b43_register_led(dev, &dev->led_radio, name,
-				 b43_rfkill_led_name(dev),
+				 ieee80211_get_radio_led_name(hw),
 				 led_index, activelow);
-		/* Sync the RF-kill LED state with the switch state. */
-		if (dev->radio_hw_enable)
+		/* Sync the RF-kill LED state with radio and switch states. */
+		if (dev->phy.radio_on && b43_is_hw_radio_enabled(dev))
 			b43_led_turn_on(dev, led_index, activelow);
 		break;
 	case B43_LED_WEIRD:
Index: wireless-testing/drivers/net/wireless/b43legacy/leds.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/leds.c
+++ wireless-testing/drivers/net/wireless/b43legacy/leds.c
@@ -28,6 +28,7 @@
 
 #include "b43legacy.h"
 #include "leds.h"
+#include "rfkill.h"
 
 
 static void b43legacy_led_turn_on(struct b43legacy_wldev *dev, u8 led_index,
@@ -164,10 +165,10 @@ static void b43legacy_map_led(struct b43
 		snprintf(name, sizeof(name),
 			 "b43legacy-%s::radio", wiphy_name(hw->wiphy));
 		b43legacy_register_led(dev, &dev->led_radio, name,
-				 b43legacy_rfkill_led_name(dev),
+				 ieee80211_get_radio_led_name(hw),
 				 led_index, activelow);
-		/* Sync the RF-kill LED state with the switch state. */
-		if (dev->radio_hw_enable)
+		/* Sync the RF-kill LED state with radio and switch states. */
+		if (dev->phy.radio_on && b43legacy_is_hw_radio_enabled(dev))
 			b43legacy_led_turn_on(dev, led_index, activelow);
 		break;
 	case B43legacy_LED_WEIRD:
Index: wireless-testing/drivers/net/wireless/b43/main.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.h
+++ wireless-testing/drivers/net/wireless/b43/main.h
@@ -128,6 +128,8 @@ void b43_dummy_transmission(struct b43_w
 
 void b43_wireless_core_reset(struct b43_wldev *dev, u32 flags);
 
+int b43_wireless_core_init(struct b43_wldev *dev);
+
 void b43_controller_restart(struct b43_wldev *dev, const char *reason);
 
 #define B43_PS_ENABLED	(1 << 0)	/* Force enable hardware power saving */
Index: wireless-testing/drivers/net/wireless/b43legacy/main.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/main.h
+++ wireless-testing/drivers/net/wireless/b43legacy/main.h
@@ -118,6 +118,8 @@ void b43legacy_dummy_transmission(struct
 
 void b43legacy_wireless_core_reset(struct b43legacy_wldev *dev, u32 flags);
 
+int b43legacy_wireless_core_init(struct b43legacy_wldev *dev);
+
 void b43legacy_mac_suspend(struct b43legacy_wldev *dev);
 void b43legacy_mac_enable(struct b43legacy_wldev *dev);
 
