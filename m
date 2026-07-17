Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9C92F28EA
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 06:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784269223; cv=none; b=rHdTd2qQYHmZ64mVaHHc8wGQWQIiTadrUVnTXBzeYFzIB6FNz/Plf3+WrCZ0cpyg2DqPZTXxds83wwfv94y8US0KtUHqFbbyJ/OBIZVPK4fGzoAFd8OP9GycxRtrqIWtOEBjNg8a6ifqVxFP0KwPZf9m+ujlrRb3/Iy8UqReztU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784269223; c=relaxed/simple;
	bh=rEqE0tOkGpje7NTypNbCGm9tq7EKjJP46xw2dPu13Yk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AiuQuNBvKPMlRuUJg+ueVzWcnfDMaII7P/IPY1F+I0kwD7+XArKcBlCYYhMoNoeQJyglXr6z98G8px6ECnc+EykxUbX0CG7RFjxO5S3G/2hNHE1B1VcQbNrJXUbJYEzCQgeGTdFsk4FtdmV7QSyZQTkqD1H1NkHGuPxrK3M5oPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=CZ4FHN/x; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="CZ4FHN/x"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66H6KIId84163379, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784269218; bh=0jMENLpKPyuQQl3JX01DynboMJ4XQ8/eZ33xEzHaO/w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	b=CZ4FHN/xJDwJk+tBJhj+2r2MgPG84rzHmgVPRO9sZrUaxN4BiGYafLGjwJkdGs6qn
	 owRSxi4oVEzZOiCYYX/siEbtchZ/4JZBv0lL5jZMAyVVgII8BhFL9yhUwse+d7NeaJ
	 fLt4PP/fy/hFdRX4P3GJasdybGamLhl4q2PmpAu2vmYOCr6vmxEMvgWsV8nqo4eoS/
	 e+HB41EfRhw/vEjvA5A9ZGMi9u5ktj4c7TcBvvmON4+jOsLisWhcj3W7kltWXehoNj
	 bm03r8+7m5GKpKShdqNFzjBfwgUku5uPQo+8W9iNDr9TZtvOHhg/WjcM51p13qPCmU
	 GRthx/2ZL+ysA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66H6KIId84163379
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 14:20:18 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 14:20:19 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 17 Jul 2026 14:20:19 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>, <sc.lee@realtek.com>, <wenjie.tsai@realtek.com>
Subject: [PATCH rtw-next 1/9] wifi: rtw89: add LED support to reflect the wireless association status
Date: Fri, 17 Jul 2026 14:19:02 +0800
Message-ID: <20260717061910.54466-2-pkshih@realtek.com>
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

Add a new RTW89_LEDS Kconfig option, along with LED structures to describe
flexible GPIO mappings for chip common LED definition. Core LED lifecycle
and registration logic default to the mac80211 association trigger, and
chips are wired up as the first user with a single-GPIO monochrome LED.

Usage:
- Auto-triggered (default):
  ON when connected, OFF when disconnected
- Manual override:
    echo <1|0> > /sys/class/leds/rtw89-phyX/brightness

Signed-off-by: Johnson Tsai <wenjie.tsai@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtw89/Kconfig  |   7 ++
 drivers/net/wireless/realtek/rtw89/Makefile |   1 +
 drivers/net/wireless/realtek/rtw89/core.c   |   3 +
 drivers/net/wireless/realtek/rtw89/core.h   |  22 ++++
 drivers/net/wireless/realtek/rtw89/debug.h  |   1 +
 drivers/net/wireless/realtek/rtw89/led.c    | 123 ++++++++++++++++++++
 drivers/net/wireless/realtek/rtw89/led.h    |  24 ++++
 7 files changed, 181 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtw89/led.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/led.h

diff --git a/drivers/net/wireless/realtek/rtw89/Kconfig b/drivers/net/wireless/realtek/rtw89/Kconfig
index 43e3b0ef44da..be31eaab7621 100644
--- a/drivers/net/wireless/realtek/rtw89/Kconfig
+++ b/drivers/net/wireless/realtek/rtw89/Kconfig
@@ -190,4 +190,11 @@ config RTW89_DEBUGFS
 
 	  If unsure, say Y to simplify debug problems
 
+config RTW89_LEDS
+	bool
+	depends on RTW89_CORE
+	depends on LEDS_CLASS=y || LEDS_CLASS=MAC80211
+	imply MAC80211_LEDS
+	default y
+
 endif
diff --git a/drivers/net/wireless/realtek/rtw89/Makefile b/drivers/net/wireless/realtek/rtw89/Makefile
index 475bad743d75..3d47f13d1e66 100644
--- a/drivers/net/wireless/realtek/rtw89/Makefile
+++ b/drivers/net/wireless/realtek/rtw89/Makefile
@@ -92,6 +92,7 @@ obj-$(CONFIG_RTW89_8922AU) += rtw89_8922au.o
 rtw89_8922au-objs := rtw8922au.o
 
 rtw89_core-$(CONFIG_RTW89_DEBUG) += debug.o
+rtw89_core-$(CONFIG_RTW89_LEDS) += led.o
 
 obj-$(CONFIG_RTW89_PCI) += rtw89_pci.o
 rtw89_pci-y := pci.o pci_be.o
diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index b4b0a451fed7..bb04f649bfb0 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -11,6 +11,7 @@
 #include "core.h"
 #include "efuse.h"
 #include "fw.h"
+#include "led.h"
 #include "mac.h"
 #include "phy.h"
 #include "ps.h"
@@ -7588,6 +7589,7 @@ static int rtw89_core_register_hw(struct rtw89_dev *rtwdev)
 
 	rtw89_rfkill_polling_init(rtwdev);
 	rtw89_btc_init(rtwdev);
+	rtw89_led_init(rtwdev);
 
 	return 0;
 
@@ -7601,6 +7603,7 @@ static void rtw89_core_unregister_hw(struct rtw89_dev *rtwdev)
 {
 	struct ieee80211_hw *hw = rtwdev->hw;
 
+	rtw89_led_deinit(rtwdev);
 	rtw89_rfkill_polling_deinit(rtwdev);
 	ieee80211_unregister_hw(hw);
 }
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index c0795e0d10cd..41cc519317c9 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -10,6 +10,7 @@
 #include <linux/dmi.h>
 #include <linux/firmware.h>
 #include <linux/iopoll.h>
+#include <linux/leds.h>
 #include <linux/workqueue.h>
 #include <net/mac80211.h>
 
@@ -5278,6 +5279,26 @@ struct rtw89_chanctx_listener {
 #define RTW89_NHM_TH_NUM 11
 #define RTW89_NHM_RPT_NUM 12
 
+struct rtw89_led_gpio_entry {
+	u8 pin;
+	struct rtw89_reg3_def pinmux;
+	struct rtw89_reg2_def mode;
+	struct rtw89_reg2_def out;
+};
+
+struct rtw89_led_desc {
+	const struct rtw89_led_gpio_entry *gpios;
+	u8 n_gpio;
+};
+
+struct rtw89_led {
+	bool registered;
+	const struct rtw89_led_desc *desc;
+	struct led_classdev led;
+	enum led_brightness brightness_cache;
+	char name[32];
+};
+
 struct rtw89_chip_info {
 	enum rtw89_core_chip_id chip_id;
 	enum rtw89_chip_gen chip_gen;
@@ -7245,6 +7266,7 @@ struct rtw89_dev {
 
 	struct rtw89_debugfs *debugfs;
 	struct rtw89_vif *pure_monitor_mode_vif;
+	struct rtw89_led led;
 
 	/* HCI related data, keep last */
 	u8 priv[] __aligned(sizeof(void *));
diff --git a/drivers/net/wireless/realtek/rtw89/debug.h b/drivers/net/wireless/realtek/rtw89/debug.h
index 7cdceb24f52d..f53d8acbd0d2 100644
--- a/drivers/net/wireless/realtek/rtw89/debug.h
+++ b/drivers/net/wireless/realtek/rtw89/debug.h
@@ -32,6 +32,7 @@ enum rtw89_debug_mask {
 	RTW89_DBG_ACPI = BIT(21),
 	RTW89_DBG_EDCCA = BIT(22),
 	RTW89_DBG_PS = BIT(23),
+	RTW89_DBG_LED = BIT(24),
 
 	RTW89_DBG_UNEXP = BIT(31),
 };
diff --git a/drivers/net/wireless/realtek/rtw89/led.c b/drivers/net/wireless/realtek/rtw89/led.c
new file mode 100644
index 000000000000..64e7eaa7ee39
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw89/led.c
@@ -0,0 +1,123 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/* Copyright(c) 2026 Realtek Corporation
+ */
+
+#include "core.h"
+#include "debug.h"
+#include "led.h"
+#include "reg.h"
+
+static const struct rtw89_led_gpio_entry rtw89_common_led_gpios[] = {{
+	.pin = 8,
+	.pinmux = {.addr = R_AX_GPIO8_15_FUNC_SEL, .mask = GENMASK(3, 0), .data = 0xf},
+	.mode = {.addr = R_AX_GPIO_EXT_CTRL + 2, .data = BIT(0) | BIT(8)},
+	.out = {.addr = R_AX_GPIO_EXT_CTRL + 1, .data = BIT(0)},
+}};
+
+static const struct rtw89_led_desc rtw89_common_led_desc = {
+	.gpios = rtw89_common_led_gpios,
+	.n_gpio = ARRAY_SIZE(rtw89_common_led_gpios),
+};
+
+void rtw89_led_gpio_config(struct rtw89_dev *rtwdev,
+			   const struct rtw89_led_gpio_entry *e)
+{
+	rtw89_write32_mask(rtwdev, e->pinmux.addr, e->pinmux.mask, e->pinmux.data);
+	rtw89_write16_clr(rtwdev, e->mode.addr, e->mode.data);
+}
+
+void rtw89_led_gpio_set(struct rtw89_dev *rtwdev,
+			const struct rtw89_led_gpio_entry *e,
+			enum led_brightness brightness)
+{
+	if (brightness == LED_OFF) {
+		rtw89_write16_clr(rtwdev, e->mode.addr, e->mode.data);
+	} else {
+		rtw89_write16_set(rtwdev, e->mode.addr, e->mode.data);
+		rtw89_write8_clr(rtwdev, e->out.addr, e->out.data);
+	}
+}
+
+static int rtw89_led_set(struct led_classdev *led, enum led_brightness brightness)
+{
+	struct rtw89_led *rtw_led = container_of(led, struct rtw89_led, led);
+	struct rtw89_dev *rtwdev = container_of(rtw_led, struct rtw89_dev, led);
+	const struct rtw89_led_desc *desc = rtw_led->desc;
+	const struct rtw89_led_gpio_entry *e = &desc->gpios[0];
+
+	if (rtw_led->brightness_cache == brightness) {
+		rtw89_debug(rtwdev, RTW89_DBG_LED, "led_set: pin=%u skip (no change)\n",
+			    e->pin);
+		return 0;
+	}
+
+	wiphy_lock(rtwdev->hw->wiphy);
+
+	rtw89_debug(rtwdev, RTW89_DBG_LED, "led_set: pin=%u brightness=%u\n",
+		    e->pin, brightness);
+	rtw89_led_gpio_set(rtwdev, e, brightness);
+	rtw_led->brightness_cache = brightness;
+
+	wiphy_unlock(rtwdev->hw->wiphy);
+
+	return 0;
+}
+
+static int rtw89_led_sc_init(struct rtw89_dev *rtwdev, const struct rtw89_led_desc *desc)
+{
+	struct rtw89_led *rtw_led = &rtwdev->led;
+	int ret;
+
+	snprintf(rtw_led->name, sizeof(rtw_led->name), "rtw89-%s",
+		 wiphy_name(rtwdev->hw->wiphy));
+	rtw_led->led.name = rtw_led->name;
+	rtw_led->led.brightness_set_blocking = rtw89_led_set;
+	rtw_led->led.max_brightness = LED_ON;
+	rtw_led->led.default_trigger = ieee80211_get_assoc_led_name(rtwdev->hw);
+
+	ret = led_classdev_register(rtwdev->dev, &rtw_led->led);
+	if (ret) {
+		rtw89_warn(rtwdev, "failed to register LED, ret=%d\n", ret);
+		return ret;
+	}
+
+	rtw89_led_gpio_config(rtwdev, &desc->gpios[0]);
+
+	return 0;
+}
+
+static void rtw89_led_sc_deinit(struct rtw89_dev *rtwdev)
+{
+	struct rtw89_led *rtw_led = &rtwdev->led;
+
+	led_classdev_unregister(&rtw_led->led);
+}
+
+void rtw89_led_init(struct rtw89_dev *rtwdev)
+{
+	const struct rtw89_led_desc *desc = &rtw89_common_led_desc;
+	struct rtw89_led *rtw_led = &rtwdev->led;
+	int ret;
+
+	/* single-GPIO monochrome LED is the only supported layout */
+	BUILD_BUG_ON(ARRAY_SIZE(rtw89_common_led_gpios) != 1);
+
+	rtw_led->desc = desc;
+	rtw_led->brightness_cache = LED_OFF;
+
+	ret = rtw89_led_sc_init(rtwdev, desc);
+	if (ret)
+		return;
+
+	rtw_led->registered = true;
+}
+
+void rtw89_led_deinit(struct rtw89_dev *rtwdev)
+{
+	struct rtw89_led *rtw_led = &rtwdev->led;
+
+	if (!rtw_led->registered)
+		return;
+
+	rtw89_led_sc_deinit(rtwdev);
+}
diff --git a/drivers/net/wireless/realtek/rtw89/led.h b/drivers/net/wireless/realtek/rtw89/led.h
new file mode 100644
index 000000000000..27e782cff7c7
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw89/led.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
+/* Copyright(c) 2026 Realtek Corporation
+ */
+
+#ifndef __RTW89_LED_H__
+#define __RTW89_LED_H__
+
+#include "core.h"
+
+void rtw89_led_gpio_config(struct rtw89_dev *rtwdev,
+			   const struct rtw89_led_gpio_entry *e);
+void rtw89_led_gpio_set(struct rtw89_dev *rtwdev,
+			const struct rtw89_led_gpio_entry *e,
+			enum led_brightness brightness);
+
+#ifdef CONFIG_RTW89_LEDS
+void rtw89_led_init(struct rtw89_dev *rtwdev);
+void rtw89_led_deinit(struct rtw89_dev *rtwdev);
+#else
+static inline void rtw89_led_init(struct rtw89_dev *rtwdev) {}
+static inline void rtw89_led_deinit(struct rtw89_dev *rtwdev) {}
+#endif
+
+#endif
-- 
2.25.1

