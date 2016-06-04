Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35344 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbcFDLuO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2016 07:50:14 -0400
From: =?UTF-8?q?Hugh=20Sipi=C3=A8re?= <hgsipiere@gmail.com>
To: m@bues.ch
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	=?UTF-8?q?Hugh=20Sipi=C3=A8re?= <hgsipiere@gmail.com>
Subject: [PATCH] drivers: ssb: Change bare unsigned to unsigned int to suit coding style
Date: Sat,  4 Jun 2016 12:50:05 +0100
Message-Id: <1465041005-5511-1-git-send-email-hgsipiere@gmail.com> (sfid-20160604_135019_486591_002B240D)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These lines just have unsigned gpio rather than unsigned int gpio.
I changed it to suit the coding style.

Signed-off-by: Hugh Sipière <hgsipiere@gmail.com>
---
 drivers/ssb/driver_gpio.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/ssb/driver_gpio.c b/drivers/ssb/driver_gpio.c
index 180e027..796e220 100644
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
 
@@ -256,14 +256,14 @@ static int ssb_gpio_chipco_init(struct ssb_bus *bus)
 
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
@@ -272,7 +272,7 @@ static void ssb_gpio_extif_set_value(struct gpio_chip *chip, unsigned gpio,
 }
 
 static int ssb_gpio_extif_direction_input(struct gpio_chip *chip,
-					  unsigned gpio)
+					  unsigned int gpio)
 {
 	struct ssb_bus *bus = gpiochip_get_data(chip);
 
@@ -281,7 +281,7 @@ static int ssb_gpio_extif_direction_input(struct gpio_chip *chip,
 }
 
 static int ssb_gpio_extif_direction_output(struct gpio_chip *chip,
-					   unsigned gpio, int value)
+					   unsigned int gpio, int value)
 {
 	struct ssb_bus *bus = gpiochip_get_data(chip);
 
-- 
2.5.5

