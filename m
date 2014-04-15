Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:36238 "EHLO
	mirror2.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbaDOHWV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2014 03:22:21 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Linus Walleij <linus.walleij@linaro.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Chen-Yu Tsai <wens@csie.org>, Arnd Bergmann <arnd@arndb.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Alexandre Courbot <gnurou@gmail.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	linux-gpio@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-sunxi@googlegroups.com
Subject: [PATCH 6/7] net: rfkill: gpio: add clock-frequency device tree property
Date: Tue, 15 Apr 2014 14:41:40 +0800
Message-Id: <1397544101-18135-7-git-send-email-wens@csie.org> (sfid-20140415_092507_403739_75CAE4FB)
In-Reply-To: <1397544101-18135-1-git-send-email-wens@csie.org>
References: <1397544101-18135-1-git-send-email-wens@csie.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some devices, such as Broadcom Bluetooth devices, require a specific
clock rate for the clock tied to the rfkill device. Add a clock-frequency
property so we can specify this from the device tree.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 Documentation/devicetree/bindings/rfkill/rfkill-gpio.txt | 2 ++
 net/rfkill/rfkill-gpio.c                                 | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/rfkill/rfkill-gpio.txt b/Documentation/devicetree/bindings/rfkill/rfkill-gpio.txt
index a23da65..67b5edb 100644
--- a/Documentation/devicetree/bindings/rfkill/rfkill-gpio.txt
+++ b/Documentation/devicetree/bindings/rfkill/rfkill-gpio.txt
@@ -11,6 +11,7 @@ Required properties:
 
 Optional properties:
 - clocks		: phandle to clock to enable/disable
+- clock-frequency	: desired clock rate for the given clock
 
 Example:
 
@@ -21,4 +22,5 @@ Example:
 		gpios = <&pio 7 18 0>;
 		gpio-names = "reset";
 		clocks = <&clk_out_a>;
+		clock-frequency = <32678>;
 	};
diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index a174359..14ac8c1 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -38,6 +38,7 @@ struct rfkill_gpio_data {
 
 	struct rfkill		*rfkill_dev;
 	struct clk		*clk;
+	uint32_t		clk_frequency;
 
 	bool			clk_enabled;
 };
@@ -90,6 +91,7 @@ static int rfkill_gpio_dt_probe(struct device *dev,
 	rfkill->name = np->name;
 	of_property_read_string(np, "rfkill-name", &rfkill->name);
 	of_property_read_u32(np, "rfkill-type", &rfkill->type);
+	of_property_read_u32(np, "clock-frequency", &rfkill->clk_frequency);
 
 	return 0;
 }
@@ -122,6 +124,9 @@ static int rfkill_gpio_probe(struct platform_device *pdev)
 
 	rfkill->clk = devm_clk_get(&pdev->dev, NULL);
 
+	if (!IS_ERR(rfkill->clk) && rfkill->clk_frequency > 0)
+		clk_set_rate(rfkill->clk, rfkill->clk_frequency);
+
 	gpio = devm_gpiod_get_index(&pdev->dev, "reset", 0);
 	if (!IS_ERR(gpio)) {
 		ret = gpiod_direction_output(gpio, 0);
-- 
1.9.1

