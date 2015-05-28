Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58761 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbbE1JqW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 05:46:22 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
	<u.kleine-koenig@pengutronix.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH RFC next 2/2] net: rfkill: gpio: simplify code flow
Date: Thu, 28 May 2015 11:46:13 +0200
Message-Id: <1432806373-17372-3-git-send-email-u.kleine-koenig@pengutronix.de> (sfid-20150528_114627_091483_F37B31CA)
In-Reply-To: <1432806373-17372-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1432806373-17372-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When assigning directly to the pointer contained in the driver data the
local variable can be dropped together with the extra assignment to it.

The downside is that davem doesn't like writing error pointers to
dynamically allocated memory as this might result in bugs like:

	if (driverdata->gpio)
		free_resources(driverdata->gpio);

which is probably wrong for error values. In this case however there is
no cleanup code for the gpios as everything is managed by devm_* and
furthermore already without this change there is an error path further
down in rfkill_gpio_probe that potentially keeps a valid gpio descriptor
in driver data which must not be used. For this eventually calling some
cleanup function is hardly better than on an error pointer.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 net/rfkill/rfkill-gpio.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index d5d58d919552..fd540024c506 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -92,7 +92,6 @@ static int rfkill_gpio_probe(struct platform_device *pdev)
 {
 	struct rfkill_gpio_platform_data *pdata = pdev->dev.platform_data;
 	struct rfkill_gpio_data *rfkill;
-	struct gpio_desc *gpio;
 	int ret;
 
 	rfkill = devm_kzalloc(&pdev->dev, sizeof(*rfkill), GFP_KERNEL);
@@ -112,17 +111,15 @@ static int rfkill_gpio_probe(struct platform_device *pdev)
 
 	rfkill->clk = devm_clk_get(&pdev->dev, NULL);
 
-	gpio = devm_gpiod_get_optional(&pdev->dev, "reset", GPIOD_OUT_LOW);
-	if (IS_ERR(gpio))
-		return PTR_ERR(gpio);
+	rfkill->reset_gpio = devm_gpiod_get_optional(&pdev->dev, "reset",
+						     GPIOD_OUT_LOW);
+	if (IS_ERR(rfkill->reset_gpio))
+		return PTR_ERR(rfkill->reset_gpio);
 
-	rfkill->reset_gpio = gpio;
-
-	gpio = devm_gpiod_get_optional(&pdev->dev, "shutdown", GPIOD_OUT_LOW);
-	if (IS_ERR(gpio))
-		return PTR_ERR(gpio);
-
-	rfkill->shutdown_gpio = gpio;
+	rfkill->shutdown_gpio = devm_gpiod_get_optional(&pdev->dev, "shutdown",
+							GPIOD_OUT_LOW);
+	if (IS_ERR(rfkill->shutdown_gpio))
+		return PTR_ERR(rfkill->shutdown_gpio);
 
 	/* Make sure at-least one of the GPIO is defined and that
 	 * a name is specified for this instance
-- 
2.1.4

