Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:34770
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673AbXI0TgK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2007 15:36:10 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: RF-kill support
Date: Thu, 27 Sep 2007 21:35:34 +0200
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200709272135.35686.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds full support for the RFKILL button and
the RFKILL LED trigger.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-2.6/drivers/net/wireless/b43/Kconfig
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/Kconfig	2007-09-27 20:53:39.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/b43/Kconfig	2007-09-27 20:56:53.000000000 +0200
@@ -64,7 +64,13 @@ config B43_PCMCIA
 # LED support
 config B43_LEDS
 	bool
-	depends on MAC80211_LEDS
+	depends on B43 && MAC80211_LEDS
+	default y
+
+# RFKILL support
+config B43_RFKILL
+	bool
+	depends on B43 && RFKILL
 	default y
 
 config B43_DEBUG
Index: wireless-2.6/drivers/net/wireless/b43/Makefile
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/Makefile	2007-09-27 20:53:39.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/b43/Makefile	2007-09-27 20:56:53.000000000 +0200
@@ -5,6 +5,8 @@ b43-y				+= phy.o
 b43-y				+= sysfs.o
 b43-y				+= xmit.o
 b43-y				+= lo.o
+# b43 RFKILL button support
+b43-$(CONFIG_B43_RFKILL)	+= rfkill.o
 # b43 LED support
 b43-$(CONFIG_B43_LEDS)		+= leds.o
 # b43 PCMCIA support
Index: wireless-2.6/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/b43.h	2007-09-27 20:53:39.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/b43/b43.h	2007-09-27 20:56:53.000000000 +0200
@@ -10,6 +10,7 @@
 
 #include "debugfs.h"
 #include "leds.h"
+#include "rfkill.h"
 #include "lo.h"
 #include "phy.h"
 
@@ -636,6 +637,9 @@ struct b43_wl {
 	u8 rng_initialized;
 	char rng_name[30 + 1];
 
+	/* The RF-kill button */
+	struct b43_rfkill rfkill;
+
 	/* List of all wireless devices on this chip */
 	struct list_head devlist;
 	u8 nr_devs;
@@ -711,6 +715,7 @@ struct b43_wldev {
 	struct b43_led led_tx;
 	struct b43_led led_rx;
 	struct b43_led led_assoc;
+	struct b43_led led_radio;
 
 	/* Reason code of the last interrupt. */
 	u32 irq_reason;
Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c	2007-09-27 20:53:39.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/b43/main.c	2007-09-27 20:56:53.000000000 +0200
@@ -2201,7 +2201,7 @@ static bool b43_is_hw_radio_enabled(stru
 /* This is the opposite of b43_chip_init() */
 static void b43_chip_exit(struct b43_wldev *dev)
 {
-	b43_radio_turn_off(dev);
+	b43_radio_turn_off(dev, 1);
 	b43_leds_exit(dev);
 	b43_gpio_cleanup(dev);
 	/* firmware is released later */
@@ -2312,7 +2312,7 @@ out:
 	return err;
 
 err_radio_off:
-	b43_radio_turn_off(dev);
+	b43_radio_turn_off(dev, 1);
 err_leds_exit:
 	b43_leds_exit(dev);
 	b43_gpio_cleanup(dev);
@@ -2401,8 +2401,7 @@ static void b43_periodic_every1sec(struc
 	radio_hw_enable = b43_is_hw_radio_enabled(dev);
 	if (unlikely(dev->radio_hw_enable != radio_hw_enable)) {
 		dev->radio_hw_enable = radio_hw_enable;
-		b43info(dev->wl, "Radio hardware status changed to %s\n",
-			radio_hw_enable ? "ENABLED" : "DISABLED");
+		b43_rfkill_toggled(dev, radio_hw_enable);
 	}
 }
 
@@ -2893,7 +2892,7 @@ static int b43_dev_config(struct ieee802
 					"Press the button to turn it on.\n");
 			}
 		} else {
-			b43_radio_turn_off(dev);
+			b43_radio_turn_off(dev, 0);
 			b43info(dev->wl, "Radio turned off by software\n");
 		}
 	}
@@ -3355,11 +3354,15 @@ static void b43_wireless_core_exit(struc
 		return;
 	b43_set_status(dev, B43_STAT_UNINIT);
 
+	mutex_unlock(&dev->wl->mutex);
+	b43_rfkill_exit(dev);
+	mutex_lock(&dev->wl->mutex);
+
 	b43_rng_exit(dev->wl);
 	b43_pio_free(dev);
 	b43_dma_free(dev);
 	b43_chip_exit(dev);
-	b43_radio_turn_off(dev);
+	b43_radio_turn_off(dev, 1);
 	b43_switch_analog(dev, 0);
 	if (phy->dyn_tssi_tbl)
 		kfree(phy->tssi2dbm);
@@ -3482,6 +3485,7 @@ static int b43_wireless_core_init(struct
 	memset(wl->bssid, 0, ETH_ALEN);
 	b43_upload_card_macaddress(dev, NULL);
 	b43_security_init(dev);
+	b43_rfkill_init(dev);
 	b43_rng_init(wl);
 
 	b43_set_status(dev, B43_STAT_INITIALIZED);
@@ -3803,7 +3807,7 @@ static int b43_wireless_core_attach(stru
 		wl->current_dev = dev;
 	INIT_WORK(&dev->restart_work, b43_chip_reset);
 
-	b43_radio_turn_off(dev);
+	b43_radio_turn_off(dev, 1);
 	b43_switch_analog(dev, 0);
 	ssb_device_disable(dev->dev, 0);
 	ssb_bus_may_powerdown(bus);
Index: wireless-2.6/drivers/net/wireless/b43/rfkill.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-2.6/drivers/net/wireless/b43/rfkill.c	2007-09-27 21:04:07.000000000 +0200
@@ -0,0 +1,155 @@
+/*
+
+  Broadcom B43 wireless driver
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
+#include "b43.h"
+
+
+static void b43_notify_rfkill_press(struct work_struct *work)
+{
+	struct b43_rfkill *rfk = container_of(work, struct b43_rfkill,
+					      notify_work);
+	struct b43_wl *wl = container_of(rfk, struct b43_wl, rfkill);
+	struct b43_wldev *dev;
+	enum rfkill_state state;
+
+	mutex_lock(&wl->mutex);
+	dev = wl->current_dev;
+	if (b43_status(dev) < B43_STAT_INITIALIZED) {
+		mutex_unlock(&wl->mutex);
+		return;
+	}
+	if (dev->radio_hw_enable)
+		state = RFKILL_STATE_ON;
+	else
+		state = RFKILL_STATE_OFF;
+	b43info(wl, "Radio hardware status changed to %s\n",
+		dev->radio_hw_enable ? "ENABLED" : "DISABLED");
+	mutex_unlock(&wl->mutex);
+
+	if (rfk->rfkill) {
+		/* Be careful. This calls back into the software toggle routines.
+		 * So we must unlock before calling. */
+		rfkill_switch_all(rfk->rfkill->type, state);
+	}
+}
+
+/* Called when the RFKILL toggled in hardware.
+ * This is called with the mutex locked. */
+void b43_rfkill_toggled(struct b43_wldev *dev, bool on)
+{
+	struct b43_wl *wl = dev->wl;
+
+	B43_WARN_ON(b43_status(dev) < B43_STAT_INITIALIZED);
+	/* Update the RF status asynchronously, as rfkill will
+	 * call back into the software toggle handler.
+	 * This would deadlock if done synchronously. */
+	queue_work(wl->hw->workqueue, &wl->rfkill.notify_work);
+}
+
+/* Called when the RFKILL toggled in software.
+ * This is called without locking. */
+static int b43_rfkill_soft_toggle(void *data, enum rfkill_state state)
+{
+	struct b43_wldev *dev = data;
+	struct b43_wl *wl = dev->wl;
+	int err = 0;
+
+	mutex_lock(&wl->mutex);
+	if (b43_status(dev) < B43_STAT_INITIALIZED)
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
+			b43_radio_turn_on(dev);
+		break;
+	case RFKILL_STATE_OFF:
+		if (dev->phy.radio_on)
+			b43_radio_turn_off(dev, 0);
+		break;
+	}
+
+out_unlock:
+	mutex_unlock(&wl->mutex);
+
+	return err;
+}
+
+char * b43_rfkill_led_name(struct b43_wldev *dev)
+{
+	struct b43_wl *wl = dev->wl;
+
+	if (!wl->rfkill.rfkill)
+		return NULL;
+	return rfkill_get_led_name(wl->rfkill.rfkill);
+}
+
+void b43_rfkill_init(struct b43_wldev *dev)
+{
+	struct b43_wl *wl = dev->wl;
+	struct b43_rfkill *rfk = &(wl->rfkill);
+	int err;
+
+	snprintf(rfk->name, sizeof(rfk->name),
+		 "b43-%s", wiphy_name(wl->hw->wiphy));
+	rfk->rfkill = rfkill_allocate(dev->dev->dev, RFKILL_TYPE_WLAN);
+	if (!rfk->rfkill)
+		goto error;
+	rfk->rfkill->name = rfk->name;
+	rfk->rfkill->state = RFKILL_STATE_ON;
+	rfk->rfkill->data = dev;
+	rfk->rfkill->toggle_radio = b43_rfkill_soft_toggle;
+	rfk->rfkill->user_claim_unsupported = 1;
+
+	INIT_WORK(&rfk->notify_work, b43_notify_rfkill_press);
+
+	err = rfkill_register(rfk->rfkill);
+	if (err)
+		goto error;
+
+	return;
+error:
+	b43warn(dev->wl, "Failed to initialize the RF-kill button\n");
+	rfkill_free(rfk->rfkill);
+	rfk->rfkill = NULL;
+}
+
+void b43_rfkill_exit(struct b43_wldev *dev)
+{
+	struct b43_rfkill *rfk = &(dev->wl->rfkill);
+
+	if (!rfk->rfkill)
+		return;
+	cancel_work_sync(&rfk->notify_work);
+	rfkill_unregister(rfk->rfkill);
+	rfkill_free(rfk->rfkill);
+	rfk->rfkill = NULL;
+}
Index: wireless-2.6/drivers/net/wireless/b43/rfkill.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-2.6/drivers/net/wireless/b43/rfkill.h	2007-09-27 20:56:53.000000000 +0200
@@ -0,0 +1,49 @@
+#ifndef B43_RFKILL_H_
+#define B43_RFKILL_H_
+
+struct b43_wldev;
+
+
+#ifdef CONFIG_B43_RFKILL
+
+#include <linux/rfkill.h>
+
+struct b43_rfkill {
+	/* The RFKILL subsystem data structure */
+	struct rfkill *rfkill;
+	/* The unique name of this rfkill switch */
+	char name[32];
+	/* Workqueue for asynchronous notification. */
+	struct work_struct notify_work;
+};
+
+void b43_rfkill_init(struct b43_wldev *dev);
+void b43_rfkill_exit(struct b43_wldev *dev);
+void b43_rfkill_toggled(struct b43_wldev *dev, bool on);
+char * b43_rfkill_led_name(struct b43_wldev *dev);
+
+
+#else /* CONFIG_B43_RFKILL */
+/* No RFKILL support. */
+
+struct b43_rfkill {
+	/* empty */
+};
+
+static inline void b43_rfkill_init(struct b43_wldev *dev)
+{
+}
+static inline void b43_rfkill_exit(struct b43_wldev *dev)
+{
+}
+static inline void b43_rfkill_toggled(struct b43_wldev *dev, bool on)
+{
+}
+static inline char * b43_rfkill_led_name(struct b43_wldev *dev)
+{
+	return NULL;
+}
+
+#endif /* CONFIG_B43_RFKILL */
+
+#endif /* B43_RFKILL_H_ */
Index: wireless-2.6/drivers/net/wireless/b43/leds.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/leds.c	2007-09-27 20:53:39.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/b43/leds.c	2007-09-27 20:56:53.000000000 +0200
@@ -154,12 +154,16 @@ static void b43_map_led(struct b43_wldev
 				 ieee80211_get_rx_led_name(hw),
 				 led_index, activelow);
 		break;
-	/*FIXME: We need another trigger for the "radio-on" LEDs below.
-	 *       Wiggle that somehow into the rfkill subsystem. */
 	case B43_LED_RADIO_ALL:
 	case B43_LED_RADIO_A:
 	case B43_LED_RADIO_B:
 	case B43_LED_MODE_BG:
+		snprintf(name, sizeof(name),
+			 "b43-%s:radio", wiphy_name(hw->wiphy));
+		b43_register_led(dev, &dev->led_radio, name,
+				 b43_rfkill_led_name(dev),
+				 led_index, activelow);
+		break;
 	case B43_LED_WEIRD:
 	case B43_LED_ASSOC:
 		snprintf(name, sizeof(name),
Index: wireless-2.6/drivers/net/wireless/b43/phy.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/phy.c	2007-09-27 20:53:39.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/b43/phy.c	2007-09-27 20:56:53.000000000 +0200
@@ -4349,10 +4349,13 @@ void b43_radio_turn_on(struct b43_wldev 
 	phy->radio_on = 1;
 }
 
-void b43_radio_turn_off(struct b43_wldev *dev)
+void b43_radio_turn_off(struct b43_wldev *dev, bool force)
 {
 	struct b43_phy *phy = &dev->phy;
 
+	if (!phy->radio_on && !force)
+		return;
+
 	if (phy->type == B43_PHYTYPE_A) {
 		b43_radio_write16(dev, 0x0004, 0x00FF);
 		b43_radio_write16(dev, 0x0005, 0x00FB);
@@ -4364,9 +4367,11 @@ void b43_radio_turn_off(struct b43_wldev
 
 		rfover = b43_phy_read(dev, B43_PHY_RFOVER);
 		rfoverval = b43_phy_read(dev, B43_PHY_RFOVERVAL);
-		phy->radio_off_context.rfover = rfover;
-		phy->radio_off_context.rfoverval = rfoverval;
-		phy->radio_off_context.valid = 1;
+		if (!force) {
+			phy->radio_off_context.rfover = rfover;
+			phy->radio_off_context.rfoverval = rfoverval;
+			phy->radio_off_context.valid = 1;
+		}
 		b43_phy_write(dev, B43_PHY_RFOVER, rfover | 0x008C);
 		b43_phy_write(dev, B43_PHY_RFOVERVAL, rfoverval & 0xFF73);
 	} else
Index: wireless-2.6/drivers/net/wireless/b43/phy.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/phy.h	2007-09-27 20:53:39.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/b43/phy.h	2007-09-27 20:56:53.000000000 +0200
@@ -267,7 +267,7 @@ u16 b43_radio_init2050(struct b43_wldev 
 void b43_radio_init2060(struct b43_wldev *dev);
 
 void b43_radio_turn_on(struct b43_wldev *dev);
-void b43_radio_turn_off(struct b43_wldev *dev);
+void b43_radio_turn_off(struct b43_wldev *dev, bool force);
 
 int b43_radio_selectchannel(struct b43_wldev *dev, u8 channel,
 			    int synthetic_pu_workaround);
