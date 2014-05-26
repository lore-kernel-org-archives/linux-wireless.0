Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509AbaEZHsv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 03:48:51 -0400
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
Subject: [PATCH 02/11] pinctrl: sunxi: add IRQCHIP_SKIP_SET_WAKE flag for pinctrl irq chip
Date: Mon, 26 May 2014 09:47:57 +0200
Message-Id: <1401090486-4414-3-git-send-email-hdegoede@redhat.com> (sfid-20140526_094900_111173_8135EB0C)
In-Reply-To: <1401090486-4414-1-git-send-email-hdegoede@redhat.com>
References: <1401090486-4414-1-git-send-email-hdegoede@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chen-Yu Tsai <wens@csie.org>

The sunxi pinctrl irq chip driver does not support wakeup at the
moment. Adding IRQCHIP_SKIP_SET_WAKE lets the irqs work with drivers
using wakeup.

Also add a name to the irq chip.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/pinctrl/sunxi/pinctrl-sunxi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.c b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
index db9ccd6..ec60c2e 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
@@ -646,6 +646,8 @@ static struct irq_chip sunxi_pinctrl_irq_chip = {
 	.irq_mask_ack	= sunxi_pinctrl_irq_mask_ack,
 	.irq_unmask	= sunxi_pinctrl_irq_unmask,
 	.irq_set_type	= sunxi_pinctrl_irq_set_type,
+	.name		= "sunxi-pio",
+	.flags		= IRQCHIP_SKIP_SET_WAKE,
 };
 
 static void sunxi_pinctrl_irq_handler(unsigned irq, struct irq_desc *desc)
-- 
1.9.3

