Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbaEZHsw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 03:48:52 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linus Walleij <linus.walleij@linaro.org>,
	Chris Ball <chris@printf.net>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
	linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 01/11] pinctrl: sunxi: create irq/pin mapping during init
Date: Mon, 26 May 2014 09:47:56 +0200
Message-Id: <1401090486-4414-2-git-send-email-hdegoede@redhat.com> (sfid-20140526_094900_820179_ECFF60C7)
In-Reply-To: <1401090486-4414-1-git-send-email-hdegoede@redhat.com>
References: <1401090486-4414-1-git-send-email-hdegoede@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chen-Yu Tsai <wens@csie.org>

The irq/pin mapping is used to lookup the pin to mux to the irq
function when the irq is enabled. It is created when gpio_to_irq
is called. Creating the mapping during init allows us to map the
interrupts directly from the device tree.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/pinctrl/sunxi/pinctrl-sunxi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.c b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
index f6522b5..db9ccd6 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
@@ -529,8 +529,6 @@ static int sunxi_pinctrl_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 	if (!desc)
 		return -EINVAL;
 
-	pctl->irq_array[desc->irqnum] = offset;
-
 	dev_dbg(chip->dev, "%s: request IRQ for GPIO %d, return %d\n",
 		chip->label, offset + chip->base, desc->irqnum);
 
@@ -731,6 +729,9 @@ static int sunxi_pinctrl_build_state(struct platform_device *pdev)
 		struct sunxi_desc_function *func = pin->functions;
 
 		while (func->name) {
+			/* Create interrupt mapping while we're at it */
+			if (!strcmp(func->name, "irq"))
+				pctl->irq_array[func->irqnum] = pin->pin.number;
 			sunxi_pinctrl_add_function(pctl, func->name);
 			func++;
 		}
-- 
1.9.3

