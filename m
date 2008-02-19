Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:52216 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbYBSNx7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2008 08:53:59 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] ssb: Fix the GPIO API
Date: Tue, 19 Feb 2008 14:53:35 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200802191453.35300.mb@bu3sch.de> (sfid-20080219_135418_185581_BC5A7279)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes the GPIO API to be usable.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

For 2.6.25

Index: wireless-testing/drivers/ssb/driver_chipcommon.c
===================================================================
--- wireless-testing.orig/drivers/ssb/driver_chipcommon.c	2008-02-19 13:20:45.000000000 +0100
+++ wireless-testing/drivers/ssb/driver_chipcommon.c	2008-02-19 14:23:30.000000000 +0100
@@ -39,12 +39,14 @@ static inline void chipco_write32(struct
 	ssb_write32(cc->dev, offset, value);
 }
 
-static inline void chipco_write32_masked(struct ssb_chipcommon *cc, u16 offset,
-					 u32 mask, u32 value)
+static inline u32 chipco_write32_masked(struct ssb_chipcommon *cc, u16 offset,
+					u32 mask, u32 value)
 {
 	value &= mask;
 	value |= chipco_read32(cc, offset) & ~mask;
 	chipco_write32(cc, offset, value);
+
+	return value;
 }
 
 void ssb_chipco_set_clockmode(struct ssb_chipcommon *cc,
@@ -355,16 +357,37 @@ u32 ssb_chipco_gpio_in(struct ssb_chipco
 {
 	return chipco_read32(cc, SSB_CHIPCO_GPIOIN) & mask;
 }
+EXPORT_SYMBOL(ssb_chipco_gpio_in);
+
+u32 ssb_chipco_gpio_out(struct ssb_chipcommon *cc, u32 mask, u32 value)
+{
+	return chipco_write32_masked(cc, SSB_CHIPCO_GPIOOUT, mask, value);
+}
+EXPORT_SYMBOL(ssb_chipco_gpio_out);
+
+u32 ssb_chipco_gpio_outen(struct ssb_chipcommon *cc, u32 mask, u32 value)
+{
+	return chipco_write32_masked(cc, SSB_CHIPCO_GPIOOUTEN, mask, value);
+}
+EXPORT_SYMBOL(ssb_chipco_gpio_outen);
+
+u32 ssb_chipco_gpio_control(struct ssb_chipcommon *cc, u32 mask, u32 value)
+{
+	return chipco_write32_masked(cc, SSB_CHIPCO_GPIOCTL, mask, value);
+}
+EXPORT_SYMBOL(ssb_chipco_gpio_control);
 
-void ssb_chipco_gpio_out(struct ssb_chipcommon *cc, u32 mask, u32 value)
+u32 ssb_chipco_gpio_intmask(struct ssb_chipcommon *cc, u32 mask, u32 value)
 {
-	chipco_write32_masked(cc, SSB_CHIPCO_GPIOOUT, mask, value);
+	return chipco_write32_masked(cc, SSB_CHIPCO_GPIOIRQ, mask, value);
 }
+EXPORT_SYMBOL(ssb_chipco_gpio_intmask);
 
-void ssb_chipco_gpio_outen(struct ssb_chipcommon *cc, u32 mask, u32 value)
+u32 ssb_chipco_gpio_polarity(struct ssb_chipcommon *cc, u32 mask, u32 value)
 {
-	chipco_write32_masked(cc, SSB_CHIPCO_GPIOOUTEN, mask, value);
+	return chipco_write32_masked(cc, SSB_CHIPCO_GPIOPOL, mask, value);
 }
+EXPORT_SYMBOL(ssb_chipco_gpio_polarity);
 
 #ifdef CONFIG_SSB_SERIAL
 int ssb_chipco_serial_init(struct ssb_chipcommon *cc,
Index: wireless-testing/drivers/ssb/driver_extif.c
===================================================================
--- wireless-testing.orig/drivers/ssb/driver_extif.c	2008-02-19 12:38:55.000000000 +0100
+++ wireless-testing/drivers/ssb/driver_extif.c	2008-02-19 14:35:09.000000000 +0100
@@ -27,12 +27,14 @@ static inline void extif_write32(struct 
 	ssb_write32(extif->dev, offset, value);
 }
 
-static inline void extif_write32_masked(struct ssb_extif *extif, u16 offset,
-					u32 mask, u32 value)
+static inline u32 extif_write32_masked(struct ssb_extif *extif, u16 offset,
+				       u32 mask, u32 value)
 {
 	value &= mask;
 	value |= extif_read32(extif, offset) & ~mask;
 	extif_write32(extif, offset, value);
+
+	return value;
 }
 
 #ifdef CONFIG_SSB_SERIAL
@@ -120,16 +122,30 @@ u32 ssb_extif_gpio_in(struct ssb_extif *
 {
 	return extif_read32(extif, SSB_EXTIF_GPIO_IN) & mask;
 }
+EXPORT_SYMBOL(ssb_extif_gpio_in);
 
-void ssb_extif_gpio_out(struct ssb_extif *extif, u32 mask, u32 value)
+u32 ssb_extif_gpio_out(struct ssb_extif *extif, u32 mask, u32 value)
 {
 	return extif_write32_masked(extif, SSB_EXTIF_GPIO_OUT(0),
 				   mask, value);
 }
+EXPORT_SYMBOL(ssb_extif_gpio_out);
 
-void ssb_extif_gpio_outen(struct ssb_extif *extif, u32 mask, u32 value)
+u32 ssb_extif_gpio_outen(struct ssb_extif *extif, u32 mask, u32 value)
 {
 	return extif_write32_masked(extif, SSB_EXTIF_GPIO_OUTEN(0),
 				   mask, value);
 }
+EXPORT_SYMBOL(ssb_extif_gpio_outen);
+
+u32 ssb_extif_gpio_polarity(struct ssb_extif *extif, u32 mask, u32 value)
+{
+	return extif_write32_masked(extif, SSB_EXTIF_GPIO_INTPOL, mask, value);
+}
+EXPORT_SYMBOL(ssb_extif_gpio_polarity);
 
+u32 ssb_extif_gpio_intmask(struct ssb_extif *extif, u32 mask, u32 value)
+{
+	return extif_write32_masked(extif, SSB_EXTIF_GPIO_INTMASK, mask, value);
+}
+EXPORT_SYMBOL(ssb_extif_gpio_intmask);
Index: wireless-testing/include/linux/ssb/ssb_driver_chipcommon.h
===================================================================
--- wireless-testing.orig/include/linux/ssb/ssb_driver_chipcommon.h	2008-02-19 12:38:55.000000000 +0100
+++ wireless-testing/include/linux/ssb/ssb_driver_chipcommon.h	2008-02-19 13:29:32.000000000 +0100
@@ -387,11 +387,13 @@ extern void ssb_chipco_set_clockmode(str
 extern void ssb_chipco_watchdog_timer_set(struct ssb_chipcommon *cc,
 					  u32 ticks);
 
+/* Chipcommon GPIO pin access. */
 u32 ssb_chipco_gpio_in(struct ssb_chipcommon *cc, u32 mask);
-
-void ssb_chipco_gpio_out(struct ssb_chipcommon *cc, u32 mask, u32 value);
-
-void ssb_chipco_gpio_outen(struct ssb_chipcommon *cc, u32 mask, u32 value);
+u32 ssb_chipco_gpio_out(struct ssb_chipcommon *cc, u32 mask, u32 value);
+u32 ssb_chipco_gpio_outen(struct ssb_chipcommon *cc, u32 mask, u32 value);
+u32 ssb_chipco_gpio_control(struct ssb_chipcommon *cc, u32 mask, u32 value);
+u32 ssb_chipco_gpio_intmask(struct ssb_chipcommon *cc, u32 mask, u32 value);
+u32 ssb_chipco_gpio_polarity(struct ssb_chipcommon *cc, u32 mask, u32 value);
 
 #ifdef CONFIG_SSB_SERIAL
 extern int ssb_chipco_serial_init(struct ssb_chipcommon *cc,
Index: wireless-testing/include/linux/ssb/ssb_driver_extif.h
===================================================================
--- wireless-testing.orig/include/linux/ssb/ssb_driver_extif.h	2008-02-19 12:38:55.000000000 +0100
+++ wireless-testing/include/linux/ssb/ssb_driver_extif.h	2008-02-19 13:31:19.000000000 +0100
@@ -174,11 +174,12 @@ extern void ssb_extif_timing_init(struct
 extern void ssb_extif_watchdog_timer_set(struct ssb_extif *extif,
 					 u32 ticks);
 
+/* Extif GPIO pin access */
 u32 ssb_extif_gpio_in(struct ssb_extif *extif, u32 mask);
-
-void ssb_extif_gpio_out(struct ssb_extif *extif, u32 mask, u32 value);
-
-void ssb_extif_gpio_outen(struct ssb_extif *extif, u32 mask, u32 value);
+u32 ssb_extif_gpio_out(struct ssb_extif *extif, u32 mask, u32 value);
+u32 ssb_extif_gpio_outen(struct ssb_extif *extif, u32 mask, u32 value);
+u32 ssb_extif_gpio_polarity(struct ssb_extif *extif, u32 mask, u32 value);
+u32 ssb_extif_gpio_intmask(struct ssb_extif *extif, u32 mask, u32 value);
 
 #ifdef CONFIG_SSB_SERIAL
 extern int ssb_extif_serial_init(struct ssb_extif *extif,

-- 
Greetings Michael.
