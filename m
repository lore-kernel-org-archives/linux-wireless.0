Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:46521 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226Ab2LLBRt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 20:17:49 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: john@phrozen.org, ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] ssb: add gpio_to_irq again
Date: Wed, 12 Dec 2012 02:17:11 +0100
Message-Id: <1355275031-19297-2-git-send-email-hauke@hauke-m.de> (sfid-20121212_021753_610561_97229013)
In-Reply-To: <1355275031-19297-1-git-send-email-hauke@hauke-m.de>
References: <1355275031-19297-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The old code had support for gpio_to_irq, but the new code did not
provide this function, but returned -ENXIO all the time. This patch
adds the missing function.

arch/mips/bcm47xx/wgt634u.c calls gpio_to_irq() and got the correct irq
number with the old gpio handling code. With this patch the code in
wgt634u.c should work again. I do not have a wgt634u to test this.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/ssb/driver_gpio.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/ssb/driver_gpio.c b/drivers/ssb/driver_gpio.c
index 97ac0a3..accabe3 100644
--- a/drivers/ssb/driver_gpio.c
+++ b/drivers/ssb/driver_gpio.c
@@ -74,6 +74,16 @@ static void ssb_gpio_chipco_free(struct gpio_chip *chip, unsigned gpio)
 	ssb_chipco_gpio_pullup(&bus->chipco, 1 << gpio, 0);
 }
 
+static int ssb_gpio_chipco_to_irq(struct gpio_chip *chip, unsigned gpio)
+{
+	struct ssb_bus *bus = ssb_gpio_get_bus(chip);
+
+	if (bus->bustype == SSB_BUSTYPE_SSB)
+		return ssb_mips_irq(bus->chipco.dev) + 2;
+	else
+		return -EINVAL;
+}
+
 static int ssb_gpio_chipco_init(struct ssb_bus *bus)
 {
 	struct gpio_chip *chip = &bus->gpio;
@@ -86,6 +96,7 @@ static int ssb_gpio_chipco_init(struct ssb_bus *bus)
 	chip->set		= ssb_gpio_chipco_set_value;
 	chip->direction_input	= ssb_gpio_chipco_direction_input;
 	chip->direction_output	= ssb_gpio_chipco_direction_output;
+	chip->to_irq		= ssb_gpio_chipco_to_irq;
 	chip->ngpio		= 16;
 	/* There is just one SoC in one device and its GPIO addresses should be
 	 * deterministic to address them more easily. The other buses could get
@@ -134,6 +145,16 @@ static int ssb_gpio_extif_direction_output(struct gpio_chip *chip,
 	return 0;
 }
 
+static int ssb_gpio_extif_to_irq(struct gpio_chip *chip, unsigned gpio)
+{
+	struct ssb_bus *bus = ssb_gpio_get_bus(chip);
+
+	if (bus->bustype == SSB_BUSTYPE_SSB)
+		return ssb_mips_irq(bus->extif.dev) + 2;
+	else
+		return -EINVAL;
+}
+
 static int ssb_gpio_extif_init(struct ssb_bus *bus)
 {
 	struct gpio_chip *chip = &bus->gpio;
@@ -144,6 +165,7 @@ static int ssb_gpio_extif_init(struct ssb_bus *bus)
 	chip->set		= ssb_gpio_extif_set_value;
 	chip->direction_input	= ssb_gpio_extif_direction_input;
 	chip->direction_output	= ssb_gpio_extif_direction_output;
+	chip->to_irq		= ssb_gpio_extif_to_irq;
 	chip->ngpio		= 5;
 	/* There is just one SoC in one device and its GPIO addresses should be
 	 * deterministic to address them more easily. The other buses could get
-- 
1.7.10.4

