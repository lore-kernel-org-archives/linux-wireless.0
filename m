Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1545 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810Ab3CCLpw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Mar 2013 06:45:52 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Piotr Haber" <phaber@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 01/13] brcmsmac: radio on led support
Date: Sun, 3 Mar 2013 12:45:20 +0100
Message-ID: <1362311132-29561-2-git-send-email-arend@broadcom.com> (sfid-20130303_124559_939782_9CC13B2F)
In-Reply-To: <1362311132-29561-1-git-send-email-arend@broadcom.com>
References: <1362311132-29561-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Piotr Haber <phaber@broadcom.com>

Add support for radio on led indicator.
Control led via BCMA gpio driver.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Piotr Haber <phaber@broadcom.com>
[arend@broadcom.com: modify Makefile for conditional compile led.c]
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/Kconfig             |    5 +-
 drivers/net/wireless/brcm80211/brcmsmac/Makefile   |    4 +
 drivers/net/wireless/brcm80211/brcmsmac/led.c      |  127 ++++++++++++++++++++
 drivers/net/wireless/brcm80211/brcmsmac/led.h      |   36 ++++++
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    4 +
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.h  |    4 +
 6 files changed, 178 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/led.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/led.h

diff --git a/drivers/net/wireless/brcm80211/Kconfig b/drivers/net/wireless/brcm80211/Kconfig
index 1d92d87..747e931 100644
--- a/drivers/net/wireless/brcm80211/Kconfig
+++ b/drivers/net/wireless/brcm80211/Kconfig
@@ -12,8 +12,9 @@ config BRCMSMAC
 	select CORDIC
 	---help---
 	  This module adds support for PCIe wireless adapters based on Broadcom
-	  IEEE802.11n SoftMAC chipsets.  If you choose to build a module, it'll
-	  be called brcmsmac.ko.
+	  IEEE802.11n SoftMAC chipsets. It also has WLAN led support, which will
+	  be available if you select BCMA_DRIVER_GPIO. If you choose to build a
+	  module, the driver will be called brcmsmac.ko.
 
 config BRCMFMAC
 	tristate "Broadcom IEEE802.11n embedded FullMAC WLAN driver"
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/Makefile b/drivers/net/wireless/brcm80211/brcmsmac/Makefile
index d3d4151..cba19d8 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/Makefile
+++ b/drivers/net/wireless/brcm80211/brcmsmac/Makefile
@@ -43,6 +43,10 @@ BRCMSMAC_OFILES := \
 	brcms_trace_events.o \
 	debug.o
 
+ifdef CONFIG_BCMA_DRIVER_GPIO
+BRCMSMAC_OFILES += led.o
+endif
+
 MODULEPFX := brcmsmac
 
 obj-$(CONFIG_BRCMSMAC)	+= $(MODULEPFX).o
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/led.c b/drivers/net/wireless/brcm80211/brcmsmac/led.c
new file mode 100644
index 0000000..43e1806
--- /dev/null
+++ b/drivers/net/wireless/brcm80211/brcmsmac/led.c
@@ -0,0 +1,127 @@
+#include <net/mac80211.h>
+#include <linux/bcma/bcma_driver_chipcommon.h>
+#include <linux/gpio.h>
+
+#include "mac80211_if.h"
+#include "pub.h"
+#include "main.h"
+#include "led.h"
+
+	/* number of leds */
+#define  BRCMS_LED_NO		4
+	/* behavior mask */
+#define  BRCMS_LED_BEH_MASK	0x7f
+	/* activelow (polarity) bit */
+#define  BRCMS_LED_AL_MASK	0x80
+	/* radio enabled */
+#define  BRCMS_LED_RADIO	3
+
+static void brcms_radio_led_ctrl(struct brcms_info *wl, bool state)
+{
+	if (wl->radio_led.gpio == -1)
+		return;
+
+	if (wl->radio_led.active_low)
+		state = !state;
+
+	if (state)
+		gpio_set_value(wl->radio_led.gpio, 1);
+	else
+		gpio_set_value(wl->radio_led.gpio, 0);
+}
+
+
+/* Callback from the LED subsystem. */
+static void brcms_led_brightness_set(struct led_classdev *led_dev,
+				   enum led_brightness brightness)
+{
+	struct brcms_info *wl = container_of(led_dev,
+		struct brcms_info, led_dev);
+	brcms_radio_led_ctrl(wl, brightness);
+}
+
+void brcms_led_unregister(struct brcms_info *wl)
+{
+	if (wl->led_dev.dev)
+		led_classdev_unregister(&wl->led_dev);
+	if (wl->radio_led.gpio != -1)
+		gpio_free(wl->radio_led.gpio);
+}
+
+int brcms_led_register(struct brcms_info *wl)
+{
+	int i, err;
+	struct brcms_led *radio_led = &wl->radio_led;
+	/* get CC core */
+	struct bcma_drv_cc *cc_drv  = &wl->wlc->hw->d11core->bus->drv_cc;
+	struct gpio_chip *bcma_gpio = &cc_drv->gpio;
+	struct ssb_sprom *sprom = &wl->wlc->hw->d11core->bus->sprom;
+	u8 *leds[] = { &sprom->gpio0,
+		&sprom->gpio1,
+		&sprom->gpio2,
+		&sprom->gpio3 };
+	unsigned gpio = -1;
+	bool active_low = false;
+
+	/* none by default */
+	radio_led->gpio = -1;
+	radio_led->active_low = false;
+
+	if (!bcma_gpio || !gpio_is_valid(bcma_gpio->base))
+		return -ENODEV;
+
+	/* find radio enabled LED */
+	for (i = 0; i < BRCMS_LED_NO; i++) {
+		u8 led = *leds[i];
+		if ((led & BRCMS_LED_BEH_MASK) == BRCMS_LED_RADIO) {
+			gpio = bcma_gpio->base + i;
+			if (led & BRCMS_LED_AL_MASK)
+				active_low = true;
+			break;
+		}
+	}
+
+	if (gpio == -1 || !gpio_is_valid(gpio))
+		return -ENODEV;
+
+	/* request and configure LED gpio */
+	err = gpio_request_one(gpio,
+				active_low ? GPIOF_OUT_INIT_HIGH
+					: GPIOF_OUT_INIT_LOW,
+				"radio on");
+	if (err) {
+		wiphy_err(wl->wiphy, "requesting led gpio %d failed (err: %d)\n",
+			  gpio, err);
+		return err;
+	}
+	err = gpio_direction_output(gpio, 1);
+	if (err) {
+		wiphy_err(wl->wiphy, "cannot set led gpio %d to output (err: %d)\n",
+			  gpio, err);
+		return err;
+	}
+
+	snprintf(wl->radio_led.name, sizeof(wl->radio_led.name),
+		 "brcmsmac-%s:radio", wiphy_name(wl->wiphy));
+
+	wl->led_dev.name = wl->radio_led.name;
+	wl->led_dev.default_trigger =
+		ieee80211_get_radio_led_name(wl->pub->ieee_hw);
+	wl->led_dev.brightness_set = brcms_led_brightness_set;
+	err = led_classdev_register(wiphy_dev(wl->wiphy), &wl->led_dev);
+
+	if (err) {
+		wiphy_err(wl->wiphy, "cannot register led device: %s (err: %d)\n",
+			  wl->radio_led.name, err);
+		return err;
+	}
+
+	wiphy_info(wl->wiphy, "registered radio enabled led device: %s gpio: %d\n",
+		   wl->radio_led.name,
+		   gpio);
+	radio_led->gpio = gpio;
+	radio_led->active_low = active_low;
+
+	return 0;
+}
+
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/led.h b/drivers/net/wireless/brcm80211/brcmsmac/led.h
new file mode 100644
index 0000000..17a0b1f
--- /dev/null
+++ b/drivers/net/wireless/brcm80211/brcmsmac/led.h
@@ -0,0 +1,36 @@
+/*
+ * Copyright (c) 2012 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef _BRCM_LED_H_
+#define _BRCM_LED_H_
+struct brcms_led {
+	char name[32];
+	unsigned gpio;
+	bool active_low;
+};
+
+#ifdef CONFIG_BCMA_DRIVER_GPIO
+void brcms_led_unregister(struct brcms_info *wl);
+int brcms_led_register(struct brcms_info *wl);
+#else
+static inline void brcms_led_unregister(struct brcms_info *wl) {};
+static inline int brcms_led_register(struct brcms_info *wl)
+{
+	return -ENOTSUPP;
+};
+#endif
+
+#endif /* _BRCM_LED_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index c6451c6..c70cf7b 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -34,6 +34,7 @@
 #include "mac80211_if.h"
 #include "main.h"
 #include "debug.h"
+#include "led.h"
 
 #define N_TX_QUEUES	4 /* #tx queues on mac80211<->driver interface */
 #define BRCMS_FLUSH_TIMEOUT	500 /* msec */
@@ -904,6 +905,7 @@ static void brcms_remove(struct bcma_device *pdev)
 	struct brcms_info *wl = hw->priv;
 
 	if (wl->wlc) {
+		brcms_led_unregister(wl);
 		wiphy_rfkill_set_hw_state(wl->pub->ieee_hw->wiphy, false);
 		wiphy_rfkill_stop_polling(wl->pub->ieee_hw->wiphy);
 		ieee80211_unregister_hw(hw);
@@ -1151,6 +1153,8 @@ static int brcms_bcma_probe(struct bcma_device *pdev)
 		pr_err("%s: brcms_attach failed!\n", __func__);
 		return -ENODEV;
 	}
+	brcms_led_register(wl);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.h b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.h
index 947ccac..4090032 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.h
@@ -20,8 +20,10 @@
 #include <linux/timer.h>
 #include <linux/interrupt.h>
 #include <linux/workqueue.h>
+#include <linux/leds.h>
 
 #include "ucode_loader.h"
+#include "led.h"
 /*
  * Starting index for 5G rates in the
  * legacy rate table.
@@ -81,6 +83,8 @@ struct brcms_info {
 	struct wiphy *wiphy;
 	struct brcms_ucode ucode;
 	bool mute_tx;
+	struct brcms_led radio_led;
+	struct led_classdev led_dev;
 };
 
 /* misc callbacks */
-- 
1.7.6


