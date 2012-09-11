Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50784 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932250Ab2IKPPd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2012 11:15:33 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: ralf@linux-mips.org, john@phrozen.org
Cc: linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
	florian@openwrt.org, zajec5@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v4 2/3] bcma: add GPIO driver for SoCs
Date: Tue, 11 Sep 2012 17:15:09 +0200
Message-Id: <1347376511-20953-3-git-send-email-hauke@hauke-m.de> (sfid-20120911_171539_654064_F11343E4)
In-Reply-To: <1347376511-20953-1-git-send-email-hauke@hauke-m.de>
References: <1347376511-20953-1-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The GPIOs are access through some registers in the chip common core.
We need locking around these GPIO accesses, all GPIOs are accessed
through the same registers and parallel writes will cause problems.

CC: Rafał Miłecki <zajec5@gmail.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_chipcommon.c            |   61 ++++++++++++++++++++++++---
 include/linux/bcma/bcma_driver_chipcommon.h |   24 ++++++++---
 2 files changed, 73 insertions(+), 12 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon.c b/drivers/bcma/driver_chipcommon.c
index a4c3ebc..7a7baf1 100644
--- a/drivers/bcma/driver_chipcommon.c
+++ b/drivers/bcma/driver_chipcommon.c
@@ -57,6 +57,8 @@ void bcma_core_chipcommon_init(struct bcma_drv_cc *cc)
 			 (leddc_off << BCMA_CC_GPIOTIMER_OFFTIME_SHIFT)));
 	}
 
+	spin_lock_init(&cc->gpio_lock);
+
 	cc->setup_done = true;
 }
 
@@ -79,34 +81,81 @@ u32 bcma_chipco_irq_status(struct bcma_drv_cc *cc, u32 mask)
 
 u32 bcma_chipco_gpio_in(struct bcma_drv_cc *cc, u32 mask)
 {
-	return bcma_cc_read32(cc, BCMA_CC_GPIOIN) & mask;
+	unsigned long flags;
+	u32 res;
+
+	spin_lock_irqsave(&cc->gpio_lock, flags);
+	res = bcma_cc_read32(cc, BCMA_CC_GPIOIN) & mask;
+	spin_unlock_irqrestore(&cc->gpio_lock, flags);
+
+	return res;
 }
+EXPORT_SYMBOL_GPL(bcma_chipco_gpio_in);
 
 u32 bcma_chipco_gpio_out(struct bcma_drv_cc *cc, u32 mask, u32 value)
 {
-	return bcma_cc_write32_masked(cc, BCMA_CC_GPIOOUT, mask, value);
+	unsigned long flags;
+	u32 res;
+
+	spin_lock_irqsave(&cc->gpio_lock, flags);
+	res = bcma_cc_write32_masked(cc, BCMA_CC_GPIOOUT, mask, value);
+	spin_unlock_irqrestore(&cc->gpio_lock, flags);
+
+	return res;
 }
+EXPORT_SYMBOL_GPL(bcma_chipco_gpio_out);
 
 u32 bcma_chipco_gpio_outen(struct bcma_drv_cc *cc, u32 mask, u32 value)
 {
-	return bcma_cc_write32_masked(cc, BCMA_CC_GPIOOUTEN, mask, value);
+	unsigned long flags;
+	u32 res;
+
+	spin_lock_irqsave(&cc->gpio_lock, flags);
+	res = bcma_cc_write32_masked(cc, BCMA_CC_GPIOOUTEN, mask, value);
+	spin_unlock_irqrestore(&cc->gpio_lock, flags);
+
+	return res;
 }
+EXPORT_SYMBOL_GPL(bcma_chipco_gpio_outen);
 
 u32 bcma_chipco_gpio_control(struct bcma_drv_cc *cc, u32 mask, u32 value)
 {
-	return bcma_cc_write32_masked(cc, BCMA_CC_GPIOCTL, mask, value);
+	unsigned long flags;
+	u32 res;
+
+	spin_lock_irqsave(&cc->gpio_lock, flags);
+	res = bcma_cc_write32_masked(cc, BCMA_CC_GPIOCTL, mask, value);
+	spin_unlock_irqrestore(&cc->gpio_lock, flags);
+
+	return res;
 }
 EXPORT_SYMBOL_GPL(bcma_chipco_gpio_control);
 
 u32 bcma_chipco_gpio_intmask(struct bcma_drv_cc *cc, u32 mask, u32 value)
 {
-	return bcma_cc_write32_masked(cc, BCMA_CC_GPIOIRQ, mask, value);
+	unsigned long flags;
+	u32 res;
+
+	spin_lock_irqsave(&cc->gpio_lock, flags);
+	res = bcma_cc_write32_masked(cc, BCMA_CC_GPIOIRQ, mask, value);
+	spin_unlock_irqrestore(&cc->gpio_lock, flags);
+
+	return res;
 }
+EXPORT_SYMBOL_GPL(bcma_chipco_gpio_intmask);
 
 u32 bcma_chipco_gpio_polarity(struct bcma_drv_cc *cc, u32 mask, u32 value)
 {
-	return bcma_cc_write32_masked(cc, BCMA_CC_GPIOPOL, mask, value);
+	unsigned long flags;
+	u32 res;
+
+	spin_lock_irqsave(&cc->gpio_lock, flags);
+	res = bcma_cc_write32_masked(cc, BCMA_CC_GPIOPOL, mask, value);
+	spin_unlock_irqrestore(&cc->gpio_lock, flags);
+
+	return res;
 }
+EXPORT_SYMBOL_GPL(bcma_chipco_gpio_polarity);
 
 #ifdef CONFIG_BCMA_DRIVER_MIPS
 void bcma_chipco_serial_init(struct bcma_drv_cc *cc)
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index d323a4b..7054d0d 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -454,6 +454,9 @@ struct bcma_drv_cc {
 	int nr_serial_ports;
 	struct bcma_serial_port serial_ports[4];
 #endif /* CONFIG_BCMA_DRIVER_MIPS */
+
+	/* Lock for GPIO register access. */
+	spinlock_t gpio_lock;
 };
 
 /* Register access */
@@ -483,13 +486,22 @@ void bcma_chipco_irq_mask(struct bcma_drv_cc *cc, u32 mask, u32 value);
 
 u32 bcma_chipco_irq_status(struct bcma_drv_cc *cc, u32 mask);
 
+#define BCMA_CC_GPIO_LINES	16
+
 /* Chipcommon GPIO pin access. */
-u32 bcma_chipco_gpio_in(struct bcma_drv_cc *cc, u32 mask);
-u32 bcma_chipco_gpio_out(struct bcma_drv_cc *cc, u32 mask, u32 value);
-u32 bcma_chipco_gpio_outen(struct bcma_drv_cc *cc, u32 mask, u32 value);
-u32 bcma_chipco_gpio_control(struct bcma_drv_cc *cc, u32 mask, u32 value);
-u32 bcma_chipco_gpio_intmask(struct bcma_drv_cc *cc, u32 mask, u32 value);
-u32 bcma_chipco_gpio_polarity(struct bcma_drv_cc *cc, u32 mask, u32 value);
+extern u32 bcma_chipco_gpio_in(struct bcma_drv_cc *cc, u32 mask);
+extern u32 bcma_chipco_gpio_out(struct bcma_drv_cc *cc, u32 mask, u32 value);
+extern u32 bcma_chipco_gpio_outen(struct bcma_drv_cc *cc, u32 mask, u32 value);
+extern u32 bcma_chipco_gpio_control(struct bcma_drv_cc *cc, u32 mask,
+				    u32 value);
+extern u32 bcma_chipco_gpio_intmask(struct bcma_drv_cc *cc, u32 mask,
+				    u32 value);
+extern u32 bcma_chipco_gpio_polarity(struct bcma_drv_cc *cc, u32 mask,
+				     u32 value);
+static inline int bcma_chipco_gpio_count(void)
+{
+	return BCMA_CC_GPIO_LINES;
+}
 
 /* PMU support */
 extern void bcma_pmu_init(struct bcma_drv_cc *cc);
-- 
1.7.9.5

