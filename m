Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:34154 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754120Ab3AZUk1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2013 15:40:27 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, m@bues.ch,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2] ssb: add gpio_to_irq
Date: Sat, 26 Jan 2013 21:38:35 +0100
Message-Id: <1359232716-15774-1-git-send-email-hauke@hauke-m.de> (sfid-20130126_214032_892979_CA0A1C0A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The old bcm47xx gpio code had support for gpio_to_irq, but the new
code did not provide this function, but returned -ENXIO all the time.
This patch adds the missing function.

arch/mips/bcm47xx/wgt634u.c calls gpio_to_irq() and got the correct irq
number with the old gpio handling code. With this patch the code in
wgt634u.c should work again. I do not have a wgt634u to test this.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/ssb/driver_gpio.c           |   22 ++++++++++++++++++++++
 include/linux/ssb/ssb_driver_mips.h |    5 +++++
 2 files changed, 27 insertions(+)

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
diff --git a/include/linux/ssb/ssb_driver_mips.h b/include/linux/ssb/ssb_driver_mips.h
index 07a9c7a..afe79d4 100644
--- a/include/linux/ssb/ssb_driver_mips.h
+++ b/include/linux/ssb/ssb_driver_mips.h
@@ -45,6 +45,11 @@ void ssb_mipscore_init(struct ssb_mipscore *mcore)
 {
 }
 
+static inline unsigned int ssb_mips_irq(struct ssb_device *dev)
+{
+	return 0;
+}
+
 #endif /* CONFIG_SSB_DRIVER_MIPS */
 
 #endif /* LINUX_SSB_MIPSCORE_H_ */
-- 
1.7.10.4

