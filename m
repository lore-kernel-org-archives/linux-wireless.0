Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2F93750A9
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 06:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784269229; cv=none; b=M6lE1u7nNg7wsm0VAchttwoHrh9278WN4mSMWinZDjCn6WTbBmkQFWns1i23rGAls+N0uQBZjcZsQzjjxZSkgQ/4rgRY9DVIpFfEhwtaT8PwYH/y1EYw8AV0qBG/hE+lsCUMai7MrOG8RI2YZA4bZDsp6NTlfV4fXSxaY1U9wic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784269229; c=relaxed/simple;
	bh=XJXSOGr0hivGjZmc/1WNo3ZKKBgYXKDcDd+JHrC/7bg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GSlpodZE8EKVcIIFInf40rR8QXPvc3Wk9KoXnXKlAnoalJKiE1YF46RC6KwXB4dmzP06Alz+2lwBRuopoTi2raD5FSNCfTk4et1FxIzKN1Xu/EAaje2VGlb7EakH5CdoFPIYvt78fUTMjp1A8X/Fnb0QtA+5phVpqLyl2Trelw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Z8EVU8qH; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Z8EVU8qH"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66H6KO1S04163396, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784269224; bh=hi8jGkCsc+YMJhtsLAV36Pq56Z6kkJX08qlOmY+s39s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=Z8EVU8qH9BU9zQg2alAU8RwLBCK26GfglYcIc5ElWV1E+ASCWHOrN+ukX8cnTjWFx
	 OUl09J9BqFkMHpq2UBPhrGqeHGQ/L9VjstgErYONBQKAsnJdS2+rWcZncMcNqSeGvO
	 tQVsfTKF1g61ZR29XoJzieE8cZUd8Q0oBrnlnGM9rbhBdfZZdv07hDQVmz0dL8048Z
	 MUR1GrIxnwtvV0vY0VALgKrnheiSR6WtPh3IeuDAEV1Um3PobFYloOuktLlAA7AoO5
	 oBtuMZ2bslpDNgl2UJB5AmH6DD6x4RoBDmUPD05HXGJkCHDaeWJvcrHAGr1ECPQvgo
	 +Y6ZQQjGMBAWg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66H6KO1S04163396
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 14:20:24 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 14:20:24 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 17 Jul 2026 14:20:24 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>, <sc.lee@realtek.com>, <wenjie.tsai@realtek.com>
Subject: [PATCH rtw-next 2/9] wifi: rtw89: add multicolor LED support for RTL8852CU valve board
Date: Fri, 17 Jul 2026 14:19:03 +0800
Message-ID: <20260717061910.54466-3-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260717061910.54466-1-pkshih@realtek.com>
References: <20260717061910.54466-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Johnson Tsai <wenjie.tsai@realtek.com>

Add multicolor LED support for the RTL8852CU valve board to reflect
wireless connection status (by default, green LED is ON when associated
and OFF when disconnected).

Extend the rtw89 LED subsystem with a multicolor path via led_classdev_mc,
for board-level variants with more than one LED GPIO channel.

Add a new RTW89_LEDS_MC Kconfig option and support multicolor LEDs
through led_classdev_mc, with per-channel caching to minimize
redundant register writes. The RTL8852CU valve board is wired up as
the first user, driving a multicolor WRGB LED over four GPIO channels
(8, 18, 16, and 17) that map to LED_COLOR_ID_WHITE/RED/GREEN/BLUE.

Usage:
- Auto-triggered (default):
  Green LED ON when connected, OFF when disconnected

- Manual override (e.g., set red; channel order: WHITE RED GREEN BLUE):
    echo "0 1 0 0" > /sys/class/leds/rtw89-phyX-multicolor/multi_intensity
    echo 1         > /sys/class/leds/rtw89-phyX-multicolor/brightness

Signed-off-by: Johnson Tsai <wenjie.tsai@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/Kconfig    |  7 ++
 drivers/net/wireless/realtek/rtw89/Makefile   |  1 +
 drivers/net/wireless/realtek/rtw89/core.c     |  1 +
 drivers/net/wireless/realtek/rtw89/core.h     | 15 +++-
 drivers/net/wireless/realtek/rtw89/led.c      | 26 ++++--
 drivers/net/wireless/realtek/rtw89/led.h      | 13 +++
 drivers/net/wireless/realtek/rtw89/led_mc.c   | 81 +++++++++++++++++++
 drivers/net/wireless/realtek/rtw89/reg.h      |  2 +
 .../net/wireless/realtek/rtw89/rtw8851be.c    |  1 +
 .../net/wireless/realtek/rtw89/rtw8851bu.c    |  1 +
 .../net/wireless/realtek/rtw89/rtw8852ae.c    |  1 +
 .../net/wireless/realtek/rtw89/rtw8852au.c    |  1 +
 .../net/wireless/realtek/rtw89/rtw8852be.c    |  1 +
 .../net/wireless/realtek/rtw89/rtw8852bte.c   |  1 +
 .../net/wireless/realtek/rtw89/rtw8852bu.c    |  1 +
 .../net/wireless/realtek/rtw89/rtw8852ce.c    |  1 +
 .../net/wireless/realtek/rtw89/rtw8852cu.c    | 54 +++++++++++++
 .../net/wireless/realtek/rtw89/rtw8922ae.c    |  2 +
 .../net/wireless/realtek/rtw89/rtw8922au.c    |  1 +
 .../net/wireless/realtek/rtw89/rtw8922de.c    |  2 +
 20 files changed, 207 insertions(+), 6 deletions(-)
 create mode 100644 drivers/net/wireless/realtek/rtw89/led_mc.c

diff --git a/drivers/net/wireless/realtek/rtw89/Kconfig b/drivers/net/wireless/realtek/rtw89/Kconfig
index be31eaab7621..7200a944260f 100644
--- a/drivers/net/wireless/realtek/rtw89/Kconfig
+++ b/drivers/net/wireless/realtek/rtw89/Kconfig
@@ -197,4 +197,11 @@ config RTW89_LEDS
 	imply MAC80211_LEDS
 	default y
 
+config RTW89_LEDS_MC
+	bool
+	depends on RTW89_LEDS
+	depends on LEDS_CLASS_MULTICOLOR
+	imply LEDS_TRIGGER_TIMER
+	default y
+
 endif
diff --git a/drivers/net/wireless/realtek/rtw89/Makefile b/drivers/net/wireless/realtek/rtw89/Makefile
index 3d47f13d1e66..5536714e0268 100644
--- a/drivers/net/wireless/realtek/rtw89/Makefile
+++ b/drivers/net/wireless/realtek/rtw89/Makefile
@@ -93,6 +93,7 @@ rtw89_8922au-objs := rtw8922au.o
 
 rtw89_core-$(CONFIG_RTW89_DEBUG) += debug.o
 rtw89_core-$(CONFIG_RTW89_LEDS) += led.o
+rtw89_core-$(CONFIG_RTW89_LEDS_MC) += led_mc.o
 
 obj-$(CONFIG_RTW89_PCI) += rtw89_pci.o
 rtw89_pci-y := pci.o pci_be.o
diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index bb04f649bfb0..b87a72700b99 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -7701,6 +7701,7 @@ struct rtw89_dev *rtw89_alloc_ieee80211_hw(struct device *device,
 	rtwdev->ops = ops;
 	rtwdev->chip = chip;
 	rtwdev->variant = variant;
+	rtwdev->board = info->board;
 	rtwdev->fw.req.firmware = firmware;
 	rtwdev->fw.fw_format = fw_format;
 	rtwdev->support_mlo = support_mlo;
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 41cc519317c9..70cf6cbf4e8a 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -11,6 +11,7 @@
 #include <linux/firmware.h>
 #include <linux/iopoll.h>
 #include <linux/leds.h>
+#include <linux/led-class-multicolor.h>
 #include <linux/workqueue.h>
 #include <net/mac80211.h>
 
@@ -5279,8 +5280,12 @@ struct rtw89_chanctx_listener {
 #define RTW89_NHM_TH_NUM 11
 #define RTW89_NHM_RPT_NUM 12
 
+#define RTW89_LED_MAX_NUM  4
+
 struct rtw89_led_gpio_entry {
 	u8 pin;
+	unsigned int color;
+	u8 intensity;
 	struct rtw89_reg3_def pinmux;
 	struct rtw89_reg2_def mode;
 	struct rtw89_reg2_def out;
@@ -5295,7 +5300,9 @@ struct rtw89_led {
 	bool registered;
 	const struct rtw89_led_desc *desc;
 	struct led_classdev led;
-	enum led_brightness brightness_cache;
+	struct led_classdev_mc led_mc;
+	struct mc_subled subled[RTW89_LED_MAX_NUM];
+	enum led_brightness brightness_cache[RTW89_LED_MAX_NUM];
 	char name[32];
 };
 
@@ -5454,6 +5461,10 @@ struct rtw89_chip_variant {
 	const struct rtw89_qta_def *qta_def_override;
 };
 
+struct rtw89_board_variant {
+	const struct rtw89_led_desc *led_desc;
+};
+
 union rtw89_bus_info {
 	const struct rtw89_pci_info *pci;
 	const struct rtw89_usb_info *usb;
@@ -5462,6 +5473,7 @@ union rtw89_bus_info {
 struct rtw89_driver_info {
 	const struct rtw89_chip_info *chip;
 	const struct rtw89_chip_variant *variant;
+	const struct rtw89_board_variant *board;
 	const struct dmi_system_id *quirks;
 	unsigned long dev_id_quirks; /* bitmap of rtw89_quirks */
 	union rtw89_bus_info bus;
@@ -7136,6 +7148,7 @@ struct rtw89_dev {
 	struct rtw89_hw_scan_info scan_info;
 	const struct rtw89_chip_info *chip;
 	const struct rtw89_chip_variant *variant;
+	const struct rtw89_board_variant *board;
 	const struct rtw89_pci_info *pci_info;
 	const struct rtw89_rfe_parms *rfe_parms;
 	struct rtw89_hal hal;
diff --git a/drivers/net/wireless/realtek/rtw89/led.c b/drivers/net/wireless/realtek/rtw89/led.c
index 64e7eaa7ee39..ae74b7075d7c 100644
--- a/drivers/net/wireless/realtek/rtw89/led.c
+++ b/drivers/net/wireless/realtek/rtw89/led.c
@@ -45,7 +45,7 @@ static int rtw89_led_set(struct led_classdev *led, enum led_brightness brightnes
 	const struct rtw89_led_desc *desc = rtw_led->desc;
 	const struct rtw89_led_gpio_entry *e = &desc->gpios[0];
 
-	if (rtw_led->brightness_cache == brightness) {
+	if (rtw_led->brightness_cache[0] == brightness) {
 		rtw89_debug(rtwdev, RTW89_DBG_LED, "led_set: pin=%u skip (no change)\n",
 			    e->pin);
 		return 0;
@@ -56,7 +56,7 @@ static int rtw89_led_set(struct led_classdev *led, enum led_brightness brightnes
 	rtw89_debug(rtwdev, RTW89_DBG_LED, "led_set: pin=%u brightness=%u\n",
 		    e->pin, brightness);
 	rtw89_led_gpio_set(rtwdev, e, brightness);
-	rtw_led->brightness_cache = brightness;
+	rtw_led->brightness_cache[0] = brightness;
 
 	wiphy_unlock(rtwdev->hw->wiphy);
 
@@ -97,15 +97,27 @@ void rtw89_led_init(struct rtw89_dev *rtwdev)
 {
 	const struct rtw89_led_desc *desc = &rtw89_common_led_desc;
 	struct rtw89_led *rtw_led = &rtwdev->led;
+	const struct rtw89_board_variant *board = rtwdev->board;
 	int ret;
+	int i;
 
 	/* single-GPIO monochrome LED is the only supported layout */
 	BUILD_BUG_ON(ARRAY_SIZE(rtw89_common_led_gpios) != 1);
 
+	if (board)
+		desc = board->led_desc;
+	if (!desc->n_gpio || desc->n_gpio > RTW89_LED_MAX_NUM)
+		return;
+
 	rtw_led->desc = desc;
-	rtw_led->brightness_cache = LED_OFF;
+	for (i = 0; i < ARRAY_SIZE(rtw_led->brightness_cache); i++)
+		rtw_led->brightness_cache[i] = LED_OFF;
+
+	if (desc->n_gpio == 1)
+		ret = rtw89_led_sc_init(rtwdev, desc);
+	else
+		ret = rtw89_led_mc_init(rtwdev, desc);
 
-	ret = rtw89_led_sc_init(rtwdev, desc);
 	if (ret)
 		return;
 
@@ -115,9 +127,13 @@ void rtw89_led_init(struct rtw89_dev *rtwdev)
 void rtw89_led_deinit(struct rtw89_dev *rtwdev)
 {
 	struct rtw89_led *rtw_led = &rtwdev->led;
+	const struct rtw89_led_desc *desc = rtw_led->desc;
 
 	if (!rtw_led->registered)
 		return;
 
-	rtw89_led_sc_deinit(rtwdev);
+	if (desc->n_gpio == 1)
+		rtw89_led_sc_deinit(rtwdev);
+	else
+		rtw89_led_mc_deinit(rtwdev);
 }
diff --git a/drivers/net/wireless/realtek/rtw89/led.h b/drivers/net/wireless/realtek/rtw89/led.h
index 27e782cff7c7..f5ccfe1d1752 100644
--- a/drivers/net/wireless/realtek/rtw89/led.h
+++ b/drivers/net/wireless/realtek/rtw89/led.h
@@ -21,4 +21,17 @@ static inline void rtw89_led_init(struct rtw89_dev *rtwdev) {}
 static inline void rtw89_led_deinit(struct rtw89_dev *rtwdev) {}
 #endif
 
+#ifdef CONFIG_RTW89_LEDS_MC
+int rtw89_led_mc_init(struct rtw89_dev *rtwdev, const struct rtw89_led_desc *desc);
+void rtw89_led_mc_deinit(struct rtw89_dev *rtwdev);
+#else
+static inline int rtw89_led_mc_init(struct rtw89_dev *rtwdev,
+				    const struct rtw89_led_desc *desc)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void rtw89_led_mc_deinit(struct rtw89_dev *rtwdev) {}
+#endif
+
 #endif
diff --git a/drivers/net/wireless/realtek/rtw89/led_mc.c b/drivers/net/wireless/realtek/rtw89/led_mc.c
new file mode 100644
index 000000000000..7e9243baef68
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw89/led_mc.c
@@ -0,0 +1,81 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/* Copyright(c) 2026 Realtek Corporation
+ */
+
+#include "core.h"
+#include "debug.h"
+#include "led.h"
+
+static int rtw89_led_mc_brightness_set(struct led_classdev *led,
+				       enum led_brightness brightness)
+{
+	struct led_classdev_mc *mcdev = lcdev_to_mccdev(led);
+	struct rtw89_led *rtw_led = container_of(mcdev, struct rtw89_led, led_mc);
+	struct rtw89_dev *rtwdev = container_of(rtw_led, struct rtw89_dev, led);
+	const struct rtw89_led_desc *desc = rtw_led->desc;
+	const struct rtw89_led_gpio_entry *e;
+	unsigned int i;
+
+	led_mc_calc_color_components(mcdev, brightness);
+
+	wiphy_lock(rtwdev->hw->wiphy);
+
+	for (i = 0; i < mcdev->num_colors; i++) {
+		e = &desc->gpios[i];
+		if (rtw_led->brightness_cache[i] == mcdev->subled_info[i].brightness) {
+			rtw89_debug(rtwdev, RTW89_DBG_LED,
+				    "led_mc_set: pin=%u skip (no change)\n", e->pin);
+			continue;
+		}
+
+		rtw89_debug(rtwdev, RTW89_DBG_LED, "led_mc_set: pin=%u brightness=%u\n",
+			    e->pin, mcdev->subled_info[i].brightness);
+		rtw89_led_gpio_set(rtwdev, e, mcdev->subled_info[i].brightness);
+		rtw_led->brightness_cache[i] = mcdev->subled_info[i].brightness;
+	}
+
+	wiphy_unlock(rtwdev->hw->wiphy);
+
+	return 0;
+}
+
+int rtw89_led_mc_init(struct rtw89_dev *rtwdev, const struct rtw89_led_desc *desc)
+{
+	struct rtw89_led *rtw_led = &rtwdev->led;
+	struct led_classdev_mc *led_mc = &rtw_led->led_mc;
+	int i, ret;
+
+	led_mc->num_colors = desc->n_gpio;
+	led_mc->subled_info = rtw_led->subled;
+
+	for (i = 0; i < desc->n_gpio; i++) {
+		const struct rtw89_led_gpio_entry *e = &desc->gpios[i];
+
+		rtw_led->subled[i].color_index = e->color;
+		rtw_led->subled[i].intensity = e->intensity;
+		rtw_led->subled[i].brightness = 0;
+		rtw_led->subled[i].channel = i;
+
+		rtw89_led_gpio_config(rtwdev, e);
+	}
+
+	snprintf(rtw_led->name, sizeof(rtw_led->name), "rtw89-%s-multicolor",
+		 wiphy_name(rtwdev->hw->wiphy));
+	led_mc->led_cdev.name = rtw_led->name;
+	led_mc->led_cdev.brightness_set_blocking = rtw89_led_mc_brightness_set;
+	led_mc->led_cdev.max_brightness = LED_ON;
+	led_mc->led_cdev.default_trigger = ieee80211_get_assoc_led_name(rtwdev->hw);
+
+	ret = led_classdev_multicolor_register(rtwdev->dev, led_mc);
+	if (ret)
+		rtw89_warn(rtwdev, "failed to register multicolor LED, ret=%d\n", ret);
+
+	return ret;
+}
+
+void rtw89_led_mc_deinit(struct rtw89_dev *rtwdev)
+{
+	struct rtw89_led *rtw_led = &rtwdev->led;
+
+	led_classdev_multicolor_unregister(&rtw_led->led_mc);
+}
diff --git a/drivers/net/wireless/realtek/rtw89/reg.h b/drivers/net/wireless/realtek/rtw89/reg.h
index 3bf2865b81ab..053028b9ef16 100644
--- a/drivers/net/wireless/realtek/rtw89/reg.h
+++ b/drivers/net/wireless/realtek/rtw89/reg.h
@@ -205,6 +205,8 @@
 #define MAC_AX_HCI_SEL_PCIE_USB 3
 #define MAC_AX_HCI_SEL_MULTI_SDIO 4
 
+#define R_AX_GPIO_16_TO_18_EXT_CTRL 0x0150
+
 #define R_AX_HALT_H2C_CTRL 0x0160
 #define R_AX_HALT_H2C 0x0168
 #define B_AX_HALT_H2C_TRIGGER BIT(0)
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8851be.c b/drivers/net/wireless/realtek/rtw89/rtw8851be.c
index 640672eb0d26..459d2e778b83 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8851be.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8851be.c
@@ -72,6 +72,7 @@ static const struct rtw89_pci_info rtw8851b_pci_info = {
 static const struct rtw89_driver_info rtw89_8851be_info = {
 	.chip = &rtw8851b_chip_info,
 	.variant = NULL,
+	.board = NULL,
 	.quirks = NULL,
 	.dev_id_quirks = 0,
 	.bus = {
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8851bu.c b/drivers/net/wireless/realtek/rtw89/rtw8851bu.c
index 34ba5661d771..1e827205f254 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8851bu.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8851bu.c
@@ -30,6 +30,7 @@ static const struct rtw89_usb_info rtw8851b_usb_info = {
 static const struct rtw89_driver_info rtw89_8851bu_info = {
 	.chip = &rtw8851b_chip_info,
 	.variant = NULL,
+	.board = NULL,
 	.quirks = NULL,
 	.dev_id_quirks = 0,
 	.bus = {
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852ae.c b/drivers/net/wireless/realtek/rtw89/rtw8852ae.c
index 64306cdc1ee4..142a45a2e718 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852ae.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852ae.c
@@ -70,6 +70,7 @@ static const struct rtw89_pci_info rtw8852a_pci_info = {
 static const struct rtw89_driver_info rtw89_8852ae_info = {
 	.chip = &rtw8852a_chip_info,
 	.variant = NULL,
+	.board = NULL,
 	.quirks = NULL,
 	.dev_id_quirks = 0,
 	.bus = {
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852au.c b/drivers/net/wireless/realtek/rtw89/rtw8852au.c
index 29b7f7769370..065f4e5b17af 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852au.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852au.c
@@ -32,6 +32,7 @@ static const struct rtw89_usb_info rtw8852a_usb_info = {
 static const struct rtw89_driver_info rtw89_8852au_info = {
 	.chip = &rtw8852a_chip_info,
 	.variant = NULL,
+	.board = NULL,
 	.quirks = NULL,
 	.dev_id_quirks = 0,
 	.bus = {
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852be.c b/drivers/net/wireless/realtek/rtw89/rtw8852be.c
index 5bc0a6a99d1d..1c622a99c070 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852be.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852be.c
@@ -72,6 +72,7 @@ static const struct rtw89_pci_info rtw8852b_pci_info = {
 static const struct rtw89_driver_info rtw89_8852be_info = {
 	.chip = &rtw8852b_chip_info,
 	.variant = NULL,
+	.board = NULL,
 	.quirks = NULL,
 	.dev_id_quirks = 0,
 	.bus = {
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852bte.c b/drivers/net/wireless/realtek/rtw89/rtw8852bte.c
index 49a72ca835ac..73c7ebd33ab4 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852bte.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852bte.c
@@ -78,6 +78,7 @@ static const struct rtw89_pci_info rtw8852bt_pci_info = {
 static const struct rtw89_driver_info rtw89_8852bte_info = {
 	.chip = &rtw8852bt_chip_info,
 	.variant = NULL,
+	.board = NULL,
 	.quirks = NULL,
 	.dev_id_quirks = 0,
 	.bus = {
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852bu.c b/drivers/net/wireless/realtek/rtw89/rtw8852bu.c
index 308d3d570ff3..de79a19a2824 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852bu.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852bu.c
@@ -30,6 +30,7 @@ static const struct rtw89_usb_info rtw8852b_usb_info = {
 static const struct rtw89_driver_info rtw89_8852bu_info = {
 	.chip = &rtw8852b_chip_info,
 	.variant = NULL,
+	.board = NULL,
 	.quirks = NULL,
 	.dev_id_quirks = 0,
 	.bus = {
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852ce.c b/drivers/net/wireless/realtek/rtw89/rtw8852ce.c
index 3c64c0539205..bb5d5745aa62 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852ce.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852ce.c
@@ -101,6 +101,7 @@ static const struct dmi_system_id rtw8852c_pci_quirks[] = {
 static const struct rtw89_driver_info rtw89_8852ce_info = {
 	.chip = &rtw8852c_chip_info,
 	.variant = NULL,
+	.board = NULL,
 	.quirks = rtw8852c_pci_quirks,
 	.dev_id_quirks = 0,
 	.bus = {
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852cu.c b/drivers/net/wireless/realtek/rtw89/rtw8852cu.c
index 81ee96b0a048..51dd8fb05366 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852cu.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852cu.c
@@ -32,6 +32,7 @@ static const struct rtw89_usb_info rtw8852c_usb_info = {
 static const struct rtw89_driver_info rtw89_8852cu_info = {
 	.chip = &rtw8852c_chip_info,
 	.variant = NULL,
+	.board = NULL,
 	.quirks = NULL,
 	.dev_id_quirks = 0,
 	.bus = {
@@ -39,9 +40,62 @@ static const struct rtw89_driver_info rtw89_8852cu_info = {
 	},
 };
 
+static const struct rtw89_led_gpio_entry rtw8852cu_valve_led_gpios[] = {
+	{
+		.pin = 8,
+		.color = LED_COLOR_ID_WHITE,
+		.intensity = 0,
+		.pinmux = {.addr = R_AX_GPIO8_15_FUNC_SEL,
+			   .mask = GENMASK(3, 0),
+			   .data = 0xf},
+		.mode = {.addr = R_AX_GPIO_EXT_CTRL + 2, .data = BIT(0) | BIT(8)},
+		.out = {.addr = R_AX_GPIO_EXT_CTRL + 1, .data = BIT(0)},
+	}, {
+		.pin = 18,
+		.color = LED_COLOR_ID_RED,
+		.intensity = 0,
+		.pinmux = {.addr = R_AX_GPIO16_23_FUNC_SEL,
+			   .mask = GENMASK(11, 8),
+			   .data = 0xf},
+		.mode = {.addr = R_AX_GPIO_16_TO_18_EXT_CTRL + 2,
+			 .data = BIT(2) | BIT(10)},
+		.out = {.addr = R_AX_GPIO_16_TO_18_EXT_CTRL + 1, .data = BIT(2)},
+	}, {
+		.pin = 16,
+		.color = LED_COLOR_ID_GREEN,
+		.intensity = 1,
+		.pinmux = {.addr = R_AX_GPIO16_23_FUNC_SEL,
+			   .mask = GENMASK(3, 0),
+			   .data = 0xf},
+		.mode = {.addr = R_AX_GPIO_16_TO_18_EXT_CTRL + 2,
+			 .data = BIT(0) | BIT(8)},
+		.out = {.addr = R_AX_GPIO_16_TO_18_EXT_CTRL + 1, .data = BIT(0)},
+	}, {
+		.pin = 17,
+		.color = LED_COLOR_ID_BLUE,
+		.intensity = 0,
+		.pinmux = {.addr = R_AX_GPIO16_23_FUNC_SEL,
+			   .mask = GENMASK(7, 4),
+			   .data = 0xf},
+		.mode = {.addr = R_AX_GPIO_16_TO_18_EXT_CTRL + 2,
+			 .data = BIT(1) | BIT(9)},
+		.out = {.addr = R_AX_GPIO_16_TO_18_EXT_CTRL + 1, .data = BIT(1)},
+	},
+};
+
+static const struct rtw89_led_desc rtw8852cu_valve_led_desc = {
+	.gpios = rtw8852cu_valve_led_gpios,
+	.n_gpio = ARRAY_SIZE(rtw8852cu_valve_led_gpios),
+};
+
+static const struct rtw89_board_variant rtw89_8852cu_valve_board = {
+	.led_desc = &rtw8852cu_valve_led_desc,
+};
+
 static const struct rtw89_driver_info rtw89_8852cu_valve_info = {
 	.chip = &rtw8852c_chip_info,
 	.variant = NULL,
+	.board = &rtw89_8852cu_valve_board,
 	.quirks = NULL,
 	.dev_id_quirks = BIT(RTW89_QUIRK_HW_INFO_SYSFS),
 	.bus = {
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922ae.c b/drivers/net/wireless/realtek/rtw89/rtw8922ae.c
index 5527a8db393b..8f3a1cd463d9 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922ae.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922ae.c
@@ -76,6 +76,7 @@ static const struct rtw89_pci_info rtw8922a_pci_info = {
 static const struct rtw89_driver_info rtw89_8922ae_info = {
 	.chip = &rtw8922a_chip_info,
 	.variant = NULL,
+	.board = NULL,
 	.quirks = NULL,
 	.dev_id_quirks = 0,
 	.bus = {
@@ -86,6 +87,7 @@ static const struct rtw89_driver_info rtw89_8922ae_info = {
 static const struct rtw89_driver_info rtw89_8922ae_vs_info = {
 	.chip = &rtw8922a_chip_info,
 	.variant = &rtw8922ae_vs_variant,
+	.board = NULL,
 	.quirks = NULL,
 	.dev_id_quirks = 0,
 	.bus = {
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922au.c b/drivers/net/wireless/realtek/rtw89/rtw8922au.c
index 2b81de501d62..56c79b1ec865 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922au.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922au.c
@@ -31,6 +31,7 @@ static const struct rtw89_usb_info rtw8922a_usb_info = {
 static const struct rtw89_driver_info rtw89_8922au_info = {
 	.chip = &rtw8922a_chip_info,
 	.variant = NULL,
+	.board = NULL,
 	.quirks = NULL,
 	.dev_id_quirks = 0,
 	.bus = {
diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922de.c b/drivers/net/wireless/realtek/rtw89/rtw8922de.c
index a1a81c338be3..09400a0efcfd 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922de.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922de.c
@@ -72,6 +72,7 @@ static const struct rtw89_pci_info rtw8922d_pci_info = {
 static const struct rtw89_driver_info rtw89_8922de_vs_info = {
 	.chip = &rtw8922d_chip_info,
 	.variant = &rtw8922de_vs_variant,
+	.board = NULL,
 	.quirks = NULL,
 	.dev_id_quirks = 0,
 	.bus = {
@@ -82,6 +83,7 @@ static const struct rtw89_driver_info rtw89_8922de_vs_info = {
 static const struct rtw89_driver_info rtw89_8922de_info = {
 	.chip = &rtw8922d_chip_info,
 	.variant = NULL,
+	.board = NULL,
 	.quirks = NULL,
 	.dev_id_quirks = 0,
 	.bus = {
-- 
2.25.1

