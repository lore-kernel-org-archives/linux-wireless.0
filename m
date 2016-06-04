Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35372 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbcFDAjg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2016 20:39:36 -0400
From: Hugh Sipiere <hgsipiere@gmail.com>
To: m@bues.ch
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Hugh Sipiere <hgsipiere@gmail.com>
Subject: [PATCH] Drivers: ssb: Fix bare unsigned and changed to trailing comments
Date: Sat,  4 Jun 2016 01:39:32 +0100
Message-Id: <1465000772-1447-1-git-send-email-hgsipiere@gmail.com> (sfid-20160604_023954_277820_F6A671CF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I changed drivers/ssb/driver_gpio.c to better fit the coding style.
I changed unsigned to unsigned int
Two comments were changed to not end on a line with the text.

Signed-off-by: Hugh Sipiere <hgsipiere@gmail.com>
---
 drivers/ssb/driver_gpio.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/ssb/driver_gpio.c b/drivers/ssb/driver_gpio.c
index 180e027..49f858c 100644
--- a/drivers/ssb/driver_gpio.c
+++ b/drivers/ssb/driver_gpio.c
@@ -23,7 +23,7 @@
  **************************************************/
 
 #if IS_ENABLED(CONFIG_SSB_EMBEDDED)
-static int ssb_gpio_to_irq(struct gpio_chip *chip, unsigned gpio)
+static int ssb_gpio_to_irq(struct gpio_chip *chip, unsigned int gpio)
 {
 	struct ssb_bus *bus = gpiochip_get_data(chip);
 
@@ -38,14 +38,14 @@ static int ssb_gpio_to_irq(struct gpio_chip *chip, unsigned gpio)
  * ChipCommon
  **************************************************/
 
-static int ssb_gpio_chipco_get_value(struct gpio_chip *chip, unsigned gpio)
+static int ssb_gpio_chipco_get_value(struct gpio_chip *chip, unsigned int gpio)
 {
 	struct ssb_bus *bus = gpiochip_get_data(chip);
 
 	return !!ssb_chipco_gpio_in(&bus->chipco, 1 << gpio);
 }
 
-static void ssb_gpio_chipco_set_value(struct gpio_chip *chip, unsigned gpio,
+static void ssb_gpio_chipco_set_value(struct gpio_chip *chip, unsigned int gpio,
 				      int value)
 {
 	struct ssb_bus *bus = gpiochip_get_data(chip);
@@ -54,7 +54,7 @@ static void ssb_gpio_chipco_set_value(struct gpio_chip *chip, unsigned gpio,
 }
 
 static int ssb_gpio_chipco_direction_input(struct gpio_chip *chip,
-					   unsigned gpio)
+					   unsigned int gpio)
 {
 	struct ssb_bus *bus = gpiochip_get_data(chip);
 
@@ -63,7 +63,7 @@ static int ssb_gpio_chipco_direction_input(struct gpio_chip *chip,
 }
 
 static int ssb_gpio_chipco_direction_output(struct gpio_chip *chip,
-					    unsigned gpio, int value)
+					    unsigned int gpio, int value)
 {
 	struct ssb_bus *bus = gpiochip_get_data(chip);
 
@@ -72,7 +72,7 @@ static int ssb_gpio_chipco_direction_output(struct gpio_chip *chip,
 	return 0;
 }
 
-static int ssb_gpio_chipco_request(struct gpio_chip *chip, unsigned gpio)
+static int ssb_gpio_chipco_request(struct gpio_chip *chip, unsigned int gpio)
 {
 	struct ssb_bus *bus = gpiochip_get_data(chip);
 
@@ -85,7 +85,7 @@ static int ssb_gpio_chipco_request(struct gpio_chip *chip, unsigned gpio)
 	return 0;
 }
 
-static void ssb_gpio_chipco_free(struct gpio_chip *chip, unsigned gpio)
+static void ssb_gpio_chipco_free(struct gpio_chip *chip, unsigned int gpio)
 {
 	struct ssb_bus *bus = gpiochip_get_data(chip);
 
@@ -231,7 +231,8 @@ static int ssb_gpio_chipco_init(struct ssb_bus *bus)
 	chip->ngpio		= 16;
 	/* There is just one SoC in one device and its GPIO addresses should be
 	 * deterministic to address them more easily. The other buses could get
-	 * a random base number. */
+	 * a random base number.
+	 */
 	if (bus->bustype == SSB_BUSTYPE_SSB)
 		chip->base		= 0;
 	else
@@ -256,14 +257,14 @@ static int ssb_gpio_chipco_init(struct ssb_bus *bus)
 
 #ifdef CONFIG_SSB_DRIVER_EXTIF
 
-static int ssb_gpio_extif_get_value(struct gpio_chip *chip, unsigned gpio)
+static int ssb_gpio_extif_get_value(struct gpio_chip *chip, unsigned int gpio)
 {
 	struct ssb_bus *bus = gpiochip_get_data(chip);
 
 	return !!ssb_extif_gpio_in(&bus->extif, 1 << gpio);
 }
 
-static void ssb_gpio_extif_set_value(struct gpio_chip *chip, unsigned gpio,
+static void ssb_gpio_extif_set_value(struct gpio_chip *chip, unsigned int gpio,
 				     int value)
 {
 	struct ssb_bus *bus = gpiochip_get_data(chip);
@@ -281,7 +282,7 @@ static int ssb_gpio_extif_direction_input(struct gpio_chip *chip,
 }
 
 static int ssb_gpio_extif_direction_output(struct gpio_chip *chip,
-					   unsigned gpio, int value)
+					   unsigned int gpio, int value)
 {
 	struct ssb_bus *bus = gpiochip_get_data(chip);
 
@@ -424,7 +425,8 @@ static int ssb_gpio_extif_init(struct ssb_bus *bus)
 	chip->ngpio		= 5;
 	/* There is just one SoC in one device and its GPIO addresses should be
 	 * deterministic to address them more easily. The other buses could get
-	 * a random base number. */
+	 * a random base number.
+	 */
 	if (bus->bustype == SSB_BUSTYPE_SSB)
 		chip->base		= 0;
 	else
-- 
2.5.5

