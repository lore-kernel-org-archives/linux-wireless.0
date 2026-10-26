Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792993070;
	b=jMmlowZMvnXdBttjpjieJkSQ8TLrTMqBACAwRwAa0AeD/fjPl8JacwdYjd/nipvVZZWL
	 p+tXnOw1YL0OqGUWV7K7epcSQFfNo0PQQ5742ExHQR6DPWqiHGovsalKI3Y4bYSv0Ap8Q
	 OvtYpGfIPl/YMymOe1BlIyz8fjZqGGA6D4qp0CpH6aWU+uLGV6d5pyKyL9Dut3hX6pV5R
	 ISQSSy/cjo9G37JtwcthILb6WQFqkIr3j/kUKAtanBqnrfxDnj5Gcc3RM7pNo56Q/iiAy
	 ekbN0IzHt3rikeC8Fr9XZkkzPDsMzWBclMGdINkSx04bUf79T0UlzVv8gjgXKsSzFQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993070;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=8kuEF305mgmhfOFfrSSCJwWnKZJ/wlYLVihQ93IuQWk=;
	b=zY2PVcGVxUoHVmCVh3BmvCg5Vgbhn5s/XDhENxtc8GQHS6i65HVQnqVBhdub3GiW7o4G
	 jEBT44JdbCTxhn6S+POZiGYdAbwom7jYvp8AutEKu1IlIPMmkplR2/A4r57ZsZ7+uUVhp
	 Pmgg5rTp0ZcIWTjdhV7eX97+erGVtgmWQuO1YHuFo1OCB9Q7WWyXtsIlh/4mb0n4aYliG
	 xsu11/sOL9vaULONfnFLJlyE8qfz/0QHLbl0GFV3YmeqqnBCjYTEEl4Uprehog68nC5vB
	 pV5TFBU2inV6UyrUYfJahLZ5NBr6rcBknnL8Q7Jg0O2X8cBn9aGMsLmCj/WOtuSe8YA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=hQXdA8yE;
	arc=none smtp.remote-ip=209.85.210.172
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A9160A263F
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 05:37:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 66A9160A263F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=hQXdA8yE
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8a05f2d5cd3so980374b3a.0
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 22:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792993070; x=1793597870; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8kuEF305mgmhfOFfrSSCJwWnKZJ/wlYLVihQ93IuQWk=;
        b=hQXdA8yELM3zE2D9CgHl5dNfh76azxSBxOKOcjxP7JSPrBVe7Rl+MlSEqlFMU7RS+u
         6lodGTfFDvotLp/5bA4vfoGH3/6UP+Pd5i41730aFMfbAt/YZxrhI7zKOE4/nMUiu6AQ
         ZdZ/0UtwmQnlKZkg+4UrxG+0VxJ+W5bAse0eKHXIacfqONnuaslS0rCCw3MiJWUGZtAq
         oTR6kFXL1jm46ehawHE9cHhs1gDoYfrf3T4tSturfVpPwMM3uRrtmhV/p/5ZZD481XGa
         zmUD5l4O8kvot3c1ozAwSH/VSYPB8frU+W6d0FGofPRsl+kUJ0avyB8/1GAUMFx7vhVv
         ribw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792993070; x=1793597870;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8kuEF305mgmhfOFfrSSCJwWnKZJ/wlYLVihQ93IuQWk=;
        b=BXyjAKbsl0gfJvP4GvoHjEpIQRFVl5T5DYhXSq2o5RA7N41O8RWmqz4azTq2Qn5mdn
         78Fxm2M6JEirLVcjgMahKs6GsALcyjCQgHhVnkTTgfgt965merb7X63Rvxz0jiaiRF09
         KXPp27fykyYTvdb12N/kLxBo7SgwQSpLCUVdaR38CEdKtC70h1Fp/l/M4CaluASgp09e
         J9u3C6fYnRgA9mGEVnfc3x/ssd+ZlRCszvAL9LfBfTVAJIjuQScyg98Rqi43adxYHr3N
         BtpavXIRvv2fiKz0j3bHdgK/dWE2pBGpaMJPliMT7UXSrZI07N1oVNfv/75+wR+7xZHR
         HSUg==
X-Gm-Message-State: AFq9FYKIabZ5PWPdvCSHdTdKL+mbT5tJL1d4cOXuZwIZvX2kR5uWadZa
	FUgeIsTQkeChIPet/gmoq0/9Di2it54N8wNgnOhyB6YEA1RSiX1kKpZFkCbwyCwo2UKd0A==
X-Gm-Gg: AYBFou1IU5rsOF/eS704Ww4c4h2yo2UhUwdcNdBQG6aRKoM+lKYfl4KHh0To3uBls3F
	w7sOHJAb9BbSeKeGlAlVCa1l+dRWCmG8xyY6lGCgc1s8cGneIsnVM0eEKxuqddeNJ6TUStRu0LK
	G3uxNvkTSVy9y0XCUJGOUujVlVY3UtaBI/w12Poagdz7zgtIJczOSoPEf22Lvfjm8FqNGhg7i9c
	dbh8U+IIhfTAuw/A23pMaVUt2fwL1ysbljwjneReho75vn0hXu4HfT3YjpisSb9r1+L22wimco8
	e+MMw/yFAosh4LSCv2MvndLhCylZU+9xpVrZ+j+ZugKOC6UL/NNFcDo7ZjCm2yO4sKgWb8sLRBa
	SvybndNn7pSouzHbrehX7b35RX7ITsYeqhW6kFl64n2jXN9KVHmCGPxrdJQOCSRzMnTWcDG2WOS
	cm0qC8DfhqjM04cIjn6uiNfl6NapWsB7UizKQ2mvoSdfnOhsFxh6aYhV/CLTegRJyOi0kr6mBtS
	cJqKPmS3tEGpT2m/0A2EAqaEv7bYrauSFxGMfHODpS33wyityFUitBrRYg+vf8IcOmN4LQDBOHu
	x7iNXhxc7FpYrU/lGchgPEDd3Jg=
X-Received: by 2002:a05:6a00:3926:b0:891:6721:370a with SMTP id d2e1a72fcca58-8a3669948cdmr4037320b3a.29.1792993069761;
        Sun, 25 Oct 2026 22:37:49 -0700 (PDT)
Received: from acemagic-m1.tail4fb79.ts.net ([2401:7400:c804:b668:673b:a930:e065:eca])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a368d867a0sm927851b3a.2.2026.10.25.22.37.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 22:37:49 -0700 (PDT)
From: Ragul Balaji <ragulbaby@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	brcm80211@lists.linux.dev,
	Ragul Balaji <ragulbaby@gmail.com>,
	Ho Jie Feng <hjf3108@gmail.com>,
	linux-kernel@vger.kernel.org,
	brcm80211-dev-list.pdl@broadcom.com
Subject: [RFC PATCH wireless-next 16/17] wifi: bcm4323x: add LED and WPS button support
Date: Mon, 26 Oct 2026 13:36:22 +0800
Message-ID: <20261026053633.361454-17-ragulbaby@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261026053633.361454-1-ragulbaby@gmail.com>
References: <20261026053633.361454-1-ragulbaby@gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the LED and WPS button to the device driver.
Currently the GPIOs are hardcoded to values in specific devices.

Signed-off-by: Ragul Balaji <ragulbaby@gmail.com>
Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 .../brcm80211/bcm4323x/bcm4323x_led.c         | 221 ++++++++++++++++++
 1 file changed, 221 insertions(+)
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/bcm4323x/bcm4323x_led.c

diff --git a/drivers/net/wireless/broadcom/brcm80211/bcm4323x/bcm4323x_led.c b/drivers/net/wireless/broadcom/brcm80211/bcm4323x/bcm4323x_led.c
new file mode 100644
index 000000000..8d2aa459a
--- /dev/null
+++ b/drivers/net/wireless/broadcom/brcm80211/bcm4323x/bcm4323x_led.c
@@ -0,0 +1,221 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/bits.h>
+#include <linux/input.h>
+#include <linux/led-class-multicolor.h>
+#include <linux/leds.h>
+#include <linux/usb/input.h>
+
+#include "bcm4323x.h"
+
+/* Power/Activity LED */
+#define BCM4323X_LED_GPIO 1
+#define BCM4323X_LED_BLINK_MS 500
+/* TODO: This is Belkin F9L1101 specific*/
+#define BCM4323X_WPS_GREEN_GPIO 2
+#define BCM4323X_WPS_RED_GPIO 3
+/* TODO: this is Belkin F9L1101 and WNA3100 specific */
+#define BCM4323X_WPS_BUTTON_GPIO 10
+#define BCM4323X_WPS_BUTTON_POLL_MS 200
+
+static const struct ieee80211_tpt_blink bcm4323x_tpt_blink[] = {
+	{ .throughput = 0 * 1024, .blink_time = 334 },
+	{ .throughput = 1 * 1024, .blink_time = 260 },
+	{ .throughput = 5 * 1024, .blink_time = 220 },
+	{ .throughput = 10 * 1024, .blink_time = 190 },
+	{ .throughput = 20 * 1024, .blink_time = 170 },
+	{ .throughput = 50 * 1024, .blink_time = 150 },
+	{ .throughput = 70 * 1024, .blink_time = 130 },
+	{ .throughput = 100 * 1024, .blink_time = 110 },
+	{ .throughput = 200 * 1024, .blink_time = 80 },
+	{ .throughput = 300 * 1024, .blink_time = 50 },
+};
+
+static int bcm4323x_led_blink(struct bcm4323x *dev, unsigned long on_ms, unsigned long off_ms)
+{
+	int ret = bcm4323x_rpc_send_u32(dev, BCM4323X_RPC_PROC_LED_BLINK, BCM4323X_LED_GPIO, on_ms,
+					off_ms);
+
+	return ret == -ENODEV ? 0 : ret;
+}
+
+static int bcm4323x_led_gpio_out(struct bcm4323x *dev, u32 mask, u32 value)
+{
+	int ret = bcm4323x_rpc_send_u32(dev, BCM4323X_RPC_PROC_GPIO_OUT, mask, value, 1);
+
+	return ret == -ENODEV ? 0 : ret;
+}
+
+static int bcm4323x_led_set(struct bcm4323x *dev, bool on)
+{
+	int ret;
+
+	ret = bcm4323x_led_blink(dev, 0, 0);
+	if (ret)
+		return ret;
+	return bcm4323x_led_gpio_out(dev, BIT(BCM4323X_LED_GPIO),
+				     on ? BIT(BCM4323X_LED_GPIO) : 0);
+}
+
+static int bcm4323x_led_brightness_set(struct led_classdev *led, enum led_brightness brightness)
+{
+	return bcm4323x_led_set(container_of(led, struct bcm4323x, led), brightness);
+}
+
+static int bcm4323x_led_blink_set(struct led_classdev *led, unsigned long *delay_on,
+				  unsigned long *delay_off)
+{
+	struct bcm4323x *dev = container_of(led, struct bcm4323x, led);
+
+	if (!*delay_on && !*delay_off)
+		*delay_on = *delay_off = BCM4323X_LED_BLINK_MS;
+	if (!*delay_on || !*delay_off)
+		return bcm4323x_led_set(dev, *delay_on);
+	return bcm4323x_led_blink(dev, *delay_on, *delay_off);
+}
+
+#if IS_REACHABLE(CONFIG_LEDS_CLASS_MULTICOLOR)
+static int bcm4323x_wps_led_brightness_set(struct led_classdev *led,
+					   enum led_brightness brightness)
+{
+	struct led_classdev_mc *mc = lcdev_to_mccdev(led);
+	struct bcm4323x *dev = container_of(mc, struct bcm4323x, wps_led);
+	u32 value = 0;
+	unsigned int i;
+
+	led_mc_calc_color_components(mc, brightness);
+	for (i = 0; i < mc->num_colors; i++) {
+		if (mc->subled_info[i].brightness)
+			value |= BIT(mc->subled_info[i].channel);
+	}
+	return bcm4323x_led_gpio_out(dev, BIT(BCM4323X_WPS_GREEN_GPIO) | BIT(BCM4323X_WPS_RED_GPIO),
+				     value);
+}
+
+/* F9L1101 v1 specific */
+static void bcm4323x_wps_led_register(struct bcm4323x *dev)
+{
+	struct led_classdev *led = &dev->wps_led.led_cdev;
+	int ret;
+
+	if (!dev->chip->has_wps_led)
+		return;
+	dev->wps_subleds[0] = (struct mc_subled) {
+		.color_index = LED_COLOR_ID_GREEN,
+		.intensity = 1,
+		.max_intensity = 1,
+		.channel = BCM4323X_WPS_GREEN_GPIO,
+	};
+	dev->wps_subleds[1] = (struct mc_subled) {
+		.color_index = LED_COLOR_ID_RED,
+		.intensity = 1,
+		.max_intensity = 1,
+		.channel = BCM4323X_WPS_RED_GPIO,
+	};
+	dev->wps_led.subled_info = dev->wps_subleds;
+	dev->wps_led.num_colors = ARRAY_SIZE(dev->wps_subleds);
+	snprintf(dev->wps_led_name, sizeof(dev->wps_led_name), "bcm4323x-%s:multicolor:wps",
+		 wiphy_name(dev->hw->wiphy));
+	led->name = dev->wps_led_name;
+	led->max_brightness = 1;
+	led->brightness_set_blocking = bcm4323x_wps_led_brightness_set;
+	ret = bcm4323x_wps_led_brightness_set(led, LED_OFF);
+	if (!ret)
+		ret = led_classdev_multicolor_register(&dev->intf->dev, &dev->wps_led);
+	if (ret) {
+		led->dev = NULL;
+		wiphy_warn(dev->hw->wiphy, "cannot register the WPS LED: %d\n", ret);
+	}
+}
+
+static void bcm4323x_wps_led_unregister(struct bcm4323x *dev)
+{
+	if (dev->wps_led.led_cdev.dev)
+		led_classdev_multicolor_unregister(&dev->wps_led);
+}
+#else
+static void bcm4323x_wps_led_register(struct bcm4323x *dev) {}
+static void bcm4323x_wps_led_unregister(struct bcm4323x *dev) {}
+#endif
+
+static void bcm4323x_wps_button_poll(struct input_dev *input)
+{
+	struct bcm4323x *dev = input_get_drvdata(input);
+	__le32 value;
+
+	if (bcm4323x_rpc_call_u32(dev, BCM4323X_RPC_PROC_REG_READ, &value,
+				  D11REGOFFS(psm_gpio_in), sizeof(u16)))
+		return;
+	input_report_key(input, KEY_WPS_BUTTON,
+			 !(le32_to_cpu(value) & BIT(BCM4323X_WPS_BUTTON_GPIO)));
+	input_sync(input);
+}
+
+static void bcm4323x_wps_button_register(struct bcm4323x *dev)
+{
+	struct input_dev *input;
+	int ret;
+
+	if (!dev->chip->has_wps_button)
+		return;
+	input = input_allocate_device();
+	if (!input)
+		return;
+	input->name = "BCM4323x WPS button";
+	snprintf(dev->wps_button_phys, sizeof(dev->wps_button_phys), "ieee80211/%s/input0",
+		 wiphy_name(dev->hw->wiphy));
+	input->phys = dev->wps_button_phys;
+	usb_to_input_id(dev->udev, &input->id);
+	input->dev.parent = &dev->hw->wiphy->dev;
+	input_set_capability(input, EV_KEY, KEY_WPS_BUTTON);
+	input_set_drvdata(input, dev);
+	ret = input_setup_polling(input, bcm4323x_wps_button_poll);
+	if (!ret) {
+		input_set_poll_interval(input, BCM4323X_WPS_BUTTON_POLL_MS);
+		ret = input_register_device(input);
+	}
+	if (ret) {
+		input_free_device(input);
+		wiphy_warn(dev->hw->wiphy, "cannot register the WPS button: %d\n", ret);
+		return;
+	}
+	dev->wps_button = input;
+}
+
+void bcm4323x_led_init(struct bcm4323x *dev)
+{
+	dev->led.default_trigger =
+		ieee80211_create_tpt_led_trigger(dev->hw, IEEE80211_TPT_LEDTRIG_FL_RADIO,
+						 bcm4323x_tpt_blink,
+						 ARRAY_SIZE(bcm4323x_tpt_blink));
+}
+
+void bcm4323x_led_register(struct bcm4323x *dev)
+{
+	struct wiphy *wiphy = dev->hw->wiphy;
+	int ret;
+
+	snprintf(dev->led_name, sizeof(dev->led_name), "bcm4323x-%s:radio", wiphy_name(wiphy));
+	dev->led.name = dev->led_name;
+	dev->led.max_brightness = 1;
+	dev->led.brightness_set_blocking = bcm4323x_led_brightness_set;
+	dev->led.blink_set = bcm4323x_led_blink_set;
+	ret = bcm4323x_led_set(dev, false);
+	if (!ret)
+		ret = led_classdev_register(&dev->intf->dev, &dev->led);
+	if (ret) {
+		dev->led.dev = NULL;
+		wiphy_warn(wiphy, "cannot register the LED: %d\n", ret);
+	}
+	bcm4323x_wps_led_register(dev);
+	bcm4323x_wps_button_register(dev);
+}
+
+void bcm4323x_led_unregister(struct bcm4323x *dev)
+{
+	if (dev->wps_button)
+		input_unregister_device(dev->wps_button);
+	bcm4323x_wps_led_unregister(dev);
+	if (dev->led.dev)
+		led_classdev_unregister(&dev->led);
+}
-- 
2.53.0

