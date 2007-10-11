Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:58795 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493AbXJKDoX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 23:44:23 -0400
Date: Wed, 10 Oct 2007 22:44:22 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] b43legacy: RF-kill support
Message-ID: <470d9c16.jsEJ5S7w2qapRrTY%Larry.Finger@lwfinger.net> (sfid-20071011_044428_245495_A960A66B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds full support for the RFKILL button and the RFKILL LED trigger.

This is a port to b43legacy of a patch by Michael Buesch <mb@bu3sch.de>
for b43.

Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
---

John,

This patch is also to be applied to the everything branch of wireless-2.6.

Larry
---

 drivers/net/wireless/b43legacy/Kconfig     |    8 +
 drivers/net/wireless/b43legacy/Makefile    |    2
 drivers/net/wireless/b43legacy/b43legacy.h |    5
 drivers/net/wireless/b43legacy/leds.c      |    8 +
 drivers/net/wireless/b43legacy/main.c      |   18 ++-
 drivers/net/wireless/b43legacy/radio.c     |   13 +-
 drivers/net/wireless/b43legacy/radio.h     |    2
 drivers/net/wireless/b43legacy/rfkill.c    |  158 +++++++++++++++++++++++++++++
 drivers/net/wireless/b43legacy/rfkill.h    |   51 +++++++++
 9 files changed, 250 insertions(+), 15 deletions(-)

Index: wireless-2.6/drivers/net/wireless/b43legacy/Kconfig
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/Kconfig
+++ wireless-2.6/drivers/net/wireless/b43legacy/Kconfig
@@ -37,7 +37,13 @@ config B43LEGACY_PCICORE_AUTOSELECT
 # LED support
 config B43LEGACY_LEDS
 	bool
-	depends on MAC80211_LEDS
+	depends on B43LEGACY && MAC80211_LEDS
+	default y
+
+# RFKILL support
+config B43LEGACY_RFKILL
+	bool
+	depends on B43LEGACY && RFKILL
 	default y
 
 config B43LEGACY_DEBUG
Index: wireless-2.6/drivers/net/wireless/b43legacy/Makefile
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/Makefile
+++ wireless-2.6/drivers/net/wireless/b43legacy/Makefile
@@ -5,6 +5,8 @@ b43legacy-y				+= phy.o
 b43legacy-y				+= radio.o
 b43legacy-y				+= sysfs.o
 b43legacy-y				+= xmit.o
+# b43 RFKILL button support
+b43legacy-$(CONFIG_B43LEGACY_RFKILL)	+= rfkill.o
 # b43legacy LED support
 b43legacy-$(CONFIG_B43LEGACY_LEDS)	+= leds.o
 # b43legacy debugging
Index: wireless-2.6/drivers/net/wireless/b43legacy/b43legacy.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/b43legacy.h
+++ wireless-2.6/drivers/net/wireless/b43legacy/b43legacy.h
@@ -19,6 +19,7 @@
 
 #include "debugfs.h"
 #include "leds.h"
+#include "rfkill.h"
 #include "phy.h"
 
 
@@ -592,6 +593,9 @@ struct b43legacy_wl {
 	u8 rng_initialized;
 	char rng_name[30 + 1];
 
+	/* The RF-kill button */
+	struct b43legacy_rfkill rfkill;
+
 	/* List of all wireless devices on this chip */
 	struct list_head devlist;
 	u8 nr_devs;
@@ -667,6 +671,7 @@ struct b43legacy_wldev {
 	struct b43legacy_led led_tx;
 	struct b43legacy_led led_rx;
 	struct b43legacy_led led_assoc;
+	struct b43legacy_led led_radio;
 
 	/* Reason code of the last interrupt. */
 	u32 irq_reason;
Index: wireless-2.6/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/main.c
@@ -1993,7 +1993,7 @@ static bool b43legacy_is_hw_radio_enable
 /* This is the opposite of b43legacy_chip_init() */
 static void b43legacy_chip_exit(struct b43legacy_wldev *dev)
 {
-	b43legacy_radio_turn_off(dev);
+	b43legacy_radio_turn_off(dev, 1);
 	b43legacy_leds_exit(dev);
 	b43legacy_gpio_cleanup(dev);
 	/* firmware is released later */
@@ -2106,7 +2106,7 @@ out:
 	return err;
 
 err_radio_off:
-	b43legacy_radio_turn_off(dev);
+	b43legacy_radio_turn_off(dev, 1);
 err_leds_exit:
 	b43legacy_leds_exit(dev);
 	b43legacy_gpio_cleanup(dev);
@@ -2154,8 +2154,7 @@ static void b43legacy_periodic_every1sec
 	radio_hw_enable = b43legacy_is_hw_radio_enabled(dev);
 	if (unlikely(dev->radio_hw_enable != radio_hw_enable)) {
 		dev->radio_hw_enable = radio_hw_enable;
-		b43legacyinfo(dev->wl, "Radio hardware status changed to %s\n",
-		       (radio_hw_enable) ? "enabled" : "disabled");
+		b43legacy_rfkill_toggled(dev, radio_hw_enable);
 	}
 }
 
@@ -2647,7 +2646,7 @@ static int b43legacy_dev_config(struct i
 					      " physically off. Press the"
 					      " button to turn it on.\n");
 		} else {
-			b43legacy_radio_turn_off(dev);
+			b43legacy_radio_turn_off(dev, 0);
 			b43legacyinfo(dev->wl, "Radio turned off by"
 				      " software\n");
 		}
@@ -3030,11 +3029,15 @@ static void b43legacy_wireless_core_exit
 	cancel_work_sync(&dev->restart_work);
 	mutex_lock(&wl->mutex);
 
+	mutex_unlock(&dev->wl->mutex);
+	b43legacy_rfkill_exit(dev);
+	mutex_lock(&dev->wl->mutex);
+
 	b43legacy_rng_exit(dev->wl);
 	b43legacy_pio_free(dev);
 	b43legacy_dma_free(dev);
 	b43legacy_chip_exit(dev);
-	b43legacy_radio_turn_off(dev);
+	b43legacy_radio_turn_off(dev, 1);
 	b43legacy_switch_analog(dev, 0);
 	if (phy->dyn_tssi_tbl)
 		kfree(phy->tssi2dbm);
@@ -3202,6 +3205,7 @@ static int b43legacy_wireless_core_init(
 	memset(wl->mac_addr, 0, ETH_ALEN);
 	b43legacy_upload_card_macaddress(dev);
 	b43legacy_security_init(dev);
+	b43legacy_rfkill_init(dev);
 	b43legacy_rng_init(wl);
 
 	b43legacy_set_status(dev, B43legacy_STAT_INITIALIZED);
@@ -3523,7 +3527,7 @@ static int b43legacy_wireless_core_attac
 		wl->current_dev = dev;
 	INIT_WORK(&dev->restart_work, b43legacy_chip_reset);
 
-	b43legacy_radio_turn_off(dev);
+	b43legacy_radio_turn_off(dev, 1);
 	b43legacy_switch_analog(dev, 0);
 	ssb_device_disable(dev->dev, 0);
 	ssb_bus_may_powerdown(bus);
Index: wireless-2.6/drivers/net/wireless/b43legacy/rfkill.c
===================================================================
--- /dev/null
+++ wireless-2.6/drivers/net/wireless/b43legacy/rfkill.c
@@ -0,0 +1,158 @@
+/*
+
+  Broadcom B43legacy wireless driver
+  RFKILL support
+
+  Copyright (c) 2007 Michael Buesch <mb@bu3sch.de>
+
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of the GNU General Public License as published by
+  the Free Software Foundation; either version 2 of the License, or
+  (at your option) any later version.
+
+  This program is distributed in the hope that it will be useful,
+  but WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+  GNU General Public License for more details.
+
+  You should have received a copy of the GNU General Public License
+  along with this program; see the file COPYING.  If not, write to
+  the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
+  Boston, MA 02110-1301, USA.
+
+*/
+
+#include "rfkill.h"
+#include "radio.h"
+#include "b43legacy.h"
+
+
+static void b43legacy_notify_rfkill_press(struct work_struct *work)
+{
+	struct b43legacy_rfkill *rfk = container_of(work,
+						    struct b43legacy_rfkill,
+						    notify_work);
+	struct b43legacy_wl *wl = container_of(rfk, struct b43legacy_wl,
+				  rfkill);
+	struct b43legacy_wldev *dev;
+	enum rfkill_state state;
+
+	mutex_lock(&wl->mutex);
+	dev = wl->current_dev;
+	if (b43legacy_status(dev) < B43legacy_STAT_INITIALIZED) {
+		mutex_unlock(&wl->mutex);
+		return;
+	}
+	if (dev->radio_hw_enable)
+		state = RFKILL_STATE_ON;
+	else
+		state = RFKILL_STATE_OFF;
+	b43legacyinfo(wl, "Radio hardware status changed to %s\n",
+		dev->radio_hw_enable ? "ENABLED" : "DISABLED");
+	mutex_unlock(&wl->mutex);
+
+	if (rfk->rfkill) {
+		/* Be careful. This calls back into the software toggle
+		 * routines. So we must unlock before calling. */
+		rfkill_switch_all(rfk->rfkill->type, state);
+	}
+}
+
+/* Called when the RFKILL toggled in hardware.
+ * This is called with the mutex locked. */
+void b43legacy_rfkill_toggled(struct b43legacy_wldev *dev, bool on)
+{
+	struct b43legacy_wl *wl = dev->wl;
+
+	B43legacy_WARN_ON(b43legacy_status(dev) < B43legacy_STAT_INITIALIZED);
+	/* Update the RF status asynchronously, as rfkill will
+	 * call back into the software toggle handler.
+	 * This would deadlock if done synchronously. */
+	queue_work(wl->hw->workqueue, &wl->rfkill.notify_work);
+}
+
+/* Called when the RFKILL toggled in software.
+ * This is called without locking. */
+static int b43legacy_rfkill_soft_toggle(void *data, enum rfkill_state state)
+{
+	struct b43legacy_wldev *dev = data;
+	struct b43legacy_wl *wl = dev->wl;
+	int err = 0;
+
+	mutex_lock(&wl->mutex);
+	if (b43legacy_status(dev) < B43legacy_STAT_INITIALIZED)
+		goto out_unlock;
+
+	switch (state) {
+	case RFKILL_STATE_ON:
+		if (!dev->radio_hw_enable) {
+			/* No luck. We can't toggle the hardware RF-kill
+			 * button from software. */
+			err = -EBUSY;
+			goto out_unlock;
+		}
+		if (!dev->phy.radio_on)
+			b43legacy_radio_turn_on(dev);
+		break;
+	case RFKILL_STATE_OFF:
+		if (dev->phy.radio_on)
+			b43legacy_radio_turn_off(dev, 0);
+		break;
+	}
+
+out_unlock:
+	mutex_unlock(&wl->mutex);
+
+	return err;
+}
+
+char *b43legacy_rfkill_led_name(struct b43legacy_wldev *dev)
+{
+	struct b43legacy_wl *wl = dev->wl;
+
+	if (!wl->rfkill.rfkill)
+		return NULL;
+	return rfkill_get_led_name(wl->rfkill.rfkill);
+}
+
+void b43legacy_rfkill_init(struct b43legacy_wldev *dev)
+{
+	struct b43legacy_wl *wl = dev->wl;
+	struct b43legacy_rfkill *rfk = &(wl->rfkill);
+	int err;
+
+	snprintf(rfk->name, sizeof(rfk->name),
+		 "b43legacy-%s", wiphy_name(wl->hw->wiphy));
+	rfk->rfkill = rfkill_allocate(dev->dev->dev, RFKILL_TYPE_WLAN);
+	if (!rfk->rfkill)
+		goto error;
+	rfk->rfkill->name = rfk->name;
+	rfk->rfkill->state = RFKILL_STATE_ON;
+	rfk->rfkill->data = dev;
+	rfk->rfkill->toggle_radio = b43legacy_rfkill_soft_toggle;
+	rfk->rfkill->user_claim_unsupported = 1;
+
+	INIT_WORK(&rfk->notify_work, b43legacy_notify_rfkill_press);
+
+	err = rfkill_register(rfk->rfkill);
+	if (err)
+		goto error;
+
+	return;
+error:
+	b43legacywarn(dev->wl, "Failed to initialize the RF-kill button\n");
+	rfkill_free(rfk->rfkill);
+	rfk->rfkill = NULL;
+}
+
+void b43legacy_rfkill_exit(struct b43legacy_wldev *dev)
+{
+	struct b43legacy_rfkill *rfk = &(dev->wl->rfkill);
+
+	if (!rfk->rfkill)
+		return;
+	cancel_work_sync(&rfk->notify_work);
+	rfkill_unregister(rfk->rfkill);
+	rfkill_free(rfk->rfkill);
+	rfk->rfkill = NULL;
+}
Index: wireless-2.6/drivers/net/wireless/b43legacy/rfkill.h
===================================================================
--- /dev/null
+++ wireless-2.6/drivers/net/wireless/b43legacy/rfkill.h
@@ -0,0 +1,51 @@
+#ifndef B43legacy_RFKILL_H_
+#define B43legacy_RFKILL_H_
+
+struct b43legacy_wldev;
+
+#ifdef CONFIG_B43LEGACY_RFKILL
+
+#include <linux/rfkill.h>
+#include <linux/workqueue.h>
+
+
+struct b43legacy_rfkill {
+	/* The RFKILL subsystem data structure */
+	struct rfkill *rfkill;
+	/* The unique name of this rfkill switch */
+	char name[32];
+	/* Workqueue for asynchronous notification. */
+	struct work_struct notify_work;
+};
+
+void b43legacy_rfkill_init(struct b43legacy_wldev *dev);
+void b43legacy_rfkill_exit(struct b43legacy_wldev *dev);
+void b43legacy_rfkill_toggled(struct b43legacy_wldev *dev, bool on);
+char *b43legacy_rfkill_led_name(struct b43legacy_wldev *dev);
+
+
+#else /* CONFIG_B43LEGACY_RFKILL */
+/* No RFKILL support. */
+
+struct b43legacy_rfkill {
+	/* empty */
+};
+
+static inline void b43legacy_rfkill_init(struct b43legacy_wldev *dev)
+{
+}
+static inline void b43legacy_rfkill_exit(struct b43legacy_wldev *dev)
+{
+}
+static inline void b43legacy_rfkill_toggled(struct b43legacy_wldev *dev,
+					    bool on)
+{
+}
+static inline char *b43legacy_rfkill_led_name(struct b43legacy_wldev *dev)
+{
+	return NULL;
+}
+
+#endif /* CONFIG_B43LEGACY_RFKILL */
+
+#endif /* B43legacy_RFKILL_H_ */
Index: wireless-2.6/drivers/net/wireless/b43legacy/leds.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/leds.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/leds.c
@@ -156,12 +156,16 @@ static void b43legacy_map_led(struct b43
 				 ieee80211_get_rx_led_name(hw),
 				 led_index, activelow);
 		break;
-	/*FIXME: We need another trigger for the "radio-on" LEDs below.
-	 *       Wiggle that somehow into the rfkill subsystem. */
 	case B43legacy_LED_RADIO_ALL:
 	case B43legacy_LED_RADIO_A:
 	case B43legacy_LED_RADIO_B:
 	case B43legacy_LED_MODE_BG:
+		snprintf(name, sizeof(name),
+			 "b43legacy-%s:radio", wiphy_name(hw->wiphy));
+		b43legacy_register_led(dev, &dev->led_radio, name,
+				 b43legacy_rfkill_led_name(dev),
+				 led_index, activelow);
+		break;
 	case B43legacy_LED_WEIRD:
 	case B43legacy_LED_ASSOC:
 		snprintf(name, sizeof(name),
Index: wireless-2.6/drivers/net/wireless/b43legacy/radio.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/radio.c
+++ wireless-2.6/drivers/net/wireless/b43legacy/radio.c
@@ -2115,18 +2115,23 @@ void b43legacy_radio_turn_on(struct b43l
 	phy->radio_on = 1;
 }
 
-void b43legacy_radio_turn_off(struct b43legacy_wldev *dev)
+void b43legacy_radio_turn_off(struct b43legacy_wldev *dev, bool force)
 {
 	struct b43legacy_phy *phy = &dev->phy;
 
+	if (!phy->radio_on && !force)
+		return;
+
 	if (phy->type == B43legacy_PHYTYPE_G && dev->dev->id.revision >= 5) {
 		u16 rfover, rfoverval;
 
 		rfover = b43legacy_phy_read(dev, B43legacy_PHY_RFOVER);
 		rfoverval = b43legacy_phy_read(dev, B43legacy_PHY_RFOVERVAL);
-		phy->radio_off_context.rfover = rfover;
-		phy->radio_off_context.rfoverval = rfoverval;
-		phy->radio_off_context.valid = 1;
+		if (!force) {
+			phy->radio_off_context.rfover = rfover;
+			phy->radio_off_context.rfoverval = rfoverval;
+			phy->radio_off_context.valid = 1;
+		}
 		b43legacy_phy_write(dev, B43legacy_PHY_RFOVER, rfover | 0x008C);
 		b43legacy_phy_write(dev, B43legacy_PHY_RFOVERVAL,
 				    rfoverval & 0xFF73);
Index: wireless-2.6/drivers/net/wireless/b43legacy/radio.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43legacy/radio.h
+++ wireless-2.6/drivers/net/wireless/b43legacy/radio.h
@@ -61,7 +61,7 @@ void b43legacy_radio_write16(struct b43l
 u16 b43legacy_radio_init2050(struct b43legacy_wldev *dev);
 
 void b43legacy_radio_turn_on(struct b43legacy_wldev *dev);
-void b43legacy_radio_turn_off(struct b43legacy_wldev *dev);
+void b43legacy_radio_turn_off(struct b43legacy_wldev *dev, bool force);
 
 int b43legacy_radio_selectchannel(struct b43legacy_wldev *dev, u8 channel,
 				  int synthetic_pu_workaround);
