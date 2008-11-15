Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54918 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbYKOLUa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Nov 2008 06:20:30 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1L1JCV-0000mg-Bv
	for linux-wireless@vger.kernel.org; Sat, 15 Nov 2008 12:20:27 +0100
Subject: Re: [RFC] ar9170: add LED handling
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1226745636.4120.48.camel@johannes.berg> (sfid-20081115_114058_317000_BACFDBB8)
References: <1226745636.4120.48.camel@johannes.berg>
	 (sfid-20081115_114058_317000_BACFDBB8)
Content-Type: text/plain
Date: Sat, 15 Nov 2008 12:20:23 +0100
Message-Id: <1226748023.4120.52.camel@johannes.berg> (sfid-20081115_122033_886427_E18FBEE7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Without any default triggers, for now.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 Makefile |    2 -
 ar9170.h |   17 ++++++++++
 hw.h     |    2 +
 led.c    |  104 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 main.c   |   16 ++++++++-
 5 files changed, 138 insertions(+), 3 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -11,7 +11,7 @@ MODPROBE := /sbin/modprobe
 
 # In kernel, only this is required
 # vvvvv
-ar9170-objs += main.o cmd.o mac.o phy.o
+ar9170-objs += main.o cmd.o mac.o phy.o led.o
 
 obj-$(CONFIG_AR9170) += ar9170.o
 
--- a/ar9170.h
+++ b/ar9170.h
@@ -41,6 +41,7 @@
 #include <linux/usb.h>
 #include <linux/completion.h>
 #include <linux/spinlock.h>
+#include <linux/leds.h>
 #include <net/wireless.h>
 #include <net/mac80211.h>
 #include "eeprom.h"
@@ -69,6 +70,14 @@ enum ar9170_rf_init_mode {
 #define AR9170_MAX_RX_BUFFER_SIZE		8192
 #define AR9170_NUM_RX_URBS			16
 
+struct ar9170;
+
+struct ar9170_led {
+	struct ar9170 *ar;
+	struct led_classdev l;
+	char name[32];
+};
+
 struct ar9170 {
 	struct ieee80211_hw *hw;
 	struct usb_device *udev;
@@ -100,6 +109,9 @@ struct ar9170 {
 	u8 power_2G_ht20[8];
 	u8 power_2G_ht40[8];
 
+	struct work_struct led_work;
+	struct ar9170_led leds[AR9170_NUM_LEDS];
+
 	struct urb *iurb;
 	u8 ibuf[64];
 
@@ -163,6 +175,11 @@ int ar9170_upload_key(struct ar9170 *ar, u8 id, const u8 *mac, u8 ktype,
 		      u8 keyidx, u8 *keydata, int keylen);
 int ar9170_disable_key(struct ar9170 *ar, u8 id);
 
+/* LEDs */
+int ar9170_init_leds(struct ar9170 *ar);
+void ar9170_exit_leds(struct ar9170 *ar);
+void ar9170_update_leds(struct work_struct *work);
+
 /* PHY / RF */
 int ar9170_init_phy(struct ar9170 *ar, enum ieee80211_band band);
 int ar9170_init_rf(struct ar9170 *ar);
diff --git a/hw.h b/hw.h
index 18fc2d7..f523d22 100644
--- a/hw.h
+++ b/hw.h
@@ -82,6 +82,8 @@ enum ar9170_cmd {
 #define AR9170_GPIO_REG_BASE			0x1d0100
 #define AR9170_GPIO_REG_PORT_TYPE		AR9170_GPIO_REG_BASE
 #define AR9170_GPIO_REG_DATA			(AR9170_GPIO_REG_BASE + 4)
+#define AR9170_NUM_LEDS				2
+
 
 #define AR9170_USB_REG_BASE			0x1e1000
 #define AR9170_USB_REG_DMA_CTL			(AR9170_USB_REG_BASE + 0x108)
--- /dev/null
+++ b/led.c
@@ -0,0 +1,104 @@
+/*
+ * Atheros 11n USB driver
+ *
+ * LED handling
+ *
+ * Copyright 2008, Johannes Berg <johannes@sipsolutions.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; see the file COPYING.  If not, see
+ * http://www.gnu.org/licenses/.
+ *
+ * This file incorporates work covered by the following copyright and
+ * permission notice:
+ *    Copyright (c) 2007-2008 Atheros Communications, Inc.
+ *
+ *    Permission to use, copy, modify, and/or distribute this software for any
+ *    purpose with or without fee is hereby granted, provided that the above
+ *    copyright notice and this permission notice appear in all copies.
+ *
+ *    THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ *    WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ *    MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ *    ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ *    WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ *    ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ *    OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#include "ar9170.h"
+
+void ar9170_update_leds(struct work_struct *work)
+{
+        struct ar9170 *ar = container_of(work, struct ar9170,
+        				 led_work);
+	u32 ledval = 0;
+	int i;
+
+	mutex_lock(&ar->mutex);
+
+	for (i = 0; i < AR9170_NUM_LEDS; i++)
+		if (ar->leds[i].l.brightness)
+			ledval |= 1<<i;
+
+	ar9170_write_reg(ar, AR9170_GPIO_REG_DATA, ledval);
+
+	mutex_unlock(&ar->mutex);
+}
+
+static void ar9170_led_brightness_set(struct led_classdev *led,
+				      enum led_brightness brightness)
+{
+	struct ar9170_led *arl = container_of(led, struct ar9170_led, l);
+	struct ar9170 *ar = arl->ar;
+
+	queue_work(ar->hw->workqueue, &ar->led_work);
+}
+
+int ar9170_init_leds(struct ar9170 *ar)
+{
+	int err, i;
+
+	for (i = 0; i < AR9170_NUM_LEDS; i++) {
+		snprintf(ar->leds[i].name, sizeof(ar->leds[i].name),
+			 "%s-led%d", wiphy_name(ar->hw->wiphy), i + 1);
+
+		ar->leds[i].ar = ar;
+		ar->leds[i].l.name = ar->leds[i].name;
+		ar->leds[i].l.brightness_set = ar9170_led_brightness_set;
+		ar->leds[i].l.brightness = 0;
+
+		err = led_classdev_register(wiphy_dev(ar->hw->wiphy),
+					    &ar->leds[i].l);
+		if (err)
+			goto fail;
+	}
+
+	
+
+	return 0;
+
+ fail:
+	i--;
+	for (; i >= 0; i--)
+		led_classdev_unregister(&ar->leds[i].l);
+
+	return err;
+}
+
+void ar9170_exit_leds(struct ar9170 *ar)
+{
+	int i;
+
+	for (i = 0; i < AR9170_NUM_LEDS; i++)
+		led_classdev_unregister(&ar->leds[i].l);
+}
diff --git a/main.c b/main.c
index 4874875..de5e5e2 100644
--- a/main.c
+++ b/main.c
@@ -840,6 +840,7 @@ static struct ar9170 *ar9170_alloc(struct usb_interface *intf)
 	spin_lock_init(&ar->cmdlock);
 	spin_lock_init(&ar->tx_status_lock);
 	INIT_WORK(&ar->filter_config_work, ar9170_set_filters);
+	INIT_WORK(&ar->led_work, ar9170_update_leds);
 
 	/* all hw supports 2.4 GHz, so set channel to 1 by default */
 	ar->channel = &ar9170_2ghz_chantable[0];
@@ -1442,9 +1443,18 @@ static int ar9170_probe(struct usb_interface *intf,
 
 	/* disable LEDs */
 	/* GPIO 0/1 mode: output, 2/3: input */
-	ar9170_write_reg(ar, AR9170_GPIO_REG_PORT_TYPE, 3);
+	err = ar9170_write_reg(ar, AR9170_GPIO_REG_PORT_TYPE, 3);
+	if (err)
+		goto err_unirq;
+
 	/* GPIO 0/1 value: off */
-	ar9170_write_reg(ar, AR9170_GPIO_REG_DATA, 0);
+	err = ar9170_write_reg(ar, AR9170_GPIO_REG_DATA, 0);
+	if (err)
+		goto err_unirq;
+
+	err = ar9170_init_leds(ar);
+	if (err)
+		goto err_unirq;
 
 	/* try to read EEPROM, init MAC addr */
 	err = ar9170_read_eeprom(intf, ar);
@@ -1472,6 +1482,8 @@ static void ar9170_disconnect(struct usb_interface *intf)
 {
 	struct ar9170 *ar = usb_get_intfdata(intf);
 
+	ar9170_exit_leds(ar);
+
 	ieee80211_unregister_hw(ar->hw);
 
 	mutex_lock(&ar->mutex);


