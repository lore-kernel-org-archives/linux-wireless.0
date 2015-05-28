Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58759 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637AbbE1JqV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 05:46:21 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
	<u.kleine-koenig@pengutronix.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH next 1/2] net: rfkill: gpio: make better use of gpiod API
Date: Thu, 28 May 2015 11:46:12 +0200
Message-Id: <1432806373-17372-2-git-send-email-u.kleine-koenig@pengutronix.de> (sfid-20150528_114625_069540_03515732)
In-Reply-To: <1432806373-17372-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1432806373-17372-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since 39b2bbe3d715 (gpio: add flags argument to gpiod_get*() functions)
which appeared in v3.17-rc1, the gpiod_get* functions take an additional
parameter that allows to specify direction and initial value for output.

Furthermore there is devm_gpiod_get_optional which is designed to get
optional gpios.

Simplify driver accordingly.

Note this makes error checking more strict because only -ENOENT is
ignored when searching for the GPIOs which is good.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 net/rfkill/rfkill-gpio.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index d978f2f46ff3..d5d58d919552 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -112,21 +112,17 @@ static int rfkill_gpio_probe(struct platform_device *pdev)
 
 	rfkill->clk = devm_clk_get(&pdev->dev, NULL);
 
-	gpio = devm_gpiod_get(&pdev->dev, "reset");
-	if (!IS_ERR(gpio)) {
-		ret = gpiod_direction_output(gpio, 0);
-		if (ret)
-			return ret;
-		rfkill->reset_gpio = gpio;
-	}
+	gpio = devm_gpiod_get_optional(&pdev->dev, "reset", GPIOD_OUT_LOW);
+	if (IS_ERR(gpio))
+		return PTR_ERR(gpio);
 
-	gpio = devm_gpiod_get(&pdev->dev, "shutdown");
-	if (!IS_ERR(gpio)) {
-		ret = gpiod_direction_output(gpio, 0);
-		if (ret)
-			return ret;
-		rfkill->shutdown_gpio = gpio;
-	}
+	rfkill->reset_gpio = gpio;
+
+	gpio = devm_gpiod_get_optional(&pdev->dev, "shutdown", GPIOD_OUT_LOW);
+	if (IS_ERR(gpio))
+		return PTR_ERR(gpio);
+
+	rfkill->shutdown_gpio = gpio;
 
 	/* Make sure at-least one of the GPIO is defined and that
 	 * a name is specified for this instance
-- 
2.1.4

