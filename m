Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51469 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473Ab2KSW66 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 17:58:58 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: john@phrozen.org, ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
	florian@openwrt.org, zajec5@gmail.com, m@bues.ch,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 6/8] ssb: add locking around gpio register accesses
Date: Mon, 19 Nov 2012 23:57:55 +0100
Message-Id: <1353365877-11131-7-git-send-email-hauke@hauke-m.de> (sfid-20121119_235901_622276_9C30AF23)
In-Reply-To: <1353365877-11131-1-git-send-email-hauke@hauke-m.de>
References: <1353365877-11131-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The GPIOs are access through some registers in the chip common core or
over extif. We need locking around these GPIO accesses, all GPIOs are
accessed through the same registers and parallel writes will cause
problems.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/ssb/driver_chipcommon.c           |   75 ++++++++++++++++++++++++++---
 drivers/ssb/driver_extif.c                |   52 ++++++++++++++++++--
 drivers/ssb/main.c                        |    1 +
 drivers/ssb/ssb_private.h                 |    8 +++
 include/linux/ssb/ssb_driver_chipcommon.h |    1 +
 include/linux/ssb/ssb_driver_extif.h      |    1 +
 6 files changed, 125 insertions(+), 13 deletions(-)

diff --git a/drivers/ssb/driver_chipcommon.c b/drivers/ssb/driver_chipcommon.c
index 4df4926..3b1c5c7 100644
--- a/drivers/ssb/driver_chipcommon.c
+++ b/drivers/ssb/driver_chipcommon.c
@@ -284,6 +284,9 @@ void ssb_chipcommon_init(struct ssb_chipcommon *cc)
 {
 	if (!cc->dev)
 		return; /* We don't have a ChipCommon */
+
+	spin_lock_init(&cc->gpio_lock);
+
 	if (cc->dev->id.revision >= 11)
 		cc->status = chipco_read32(cc, SSB_CHIPCO_CHIPSTAT);
 	ssb_dprintk(KERN_INFO PFX "chipcommon status is 0x%x\n", cc->status);
@@ -413,49 +416,105 @@ u32 ssb_chipco_irq_status(struct ssb_chipcommon *cc, u32 mask)
 
 u32 ssb_chipco_gpio_in(struct ssb_chipcommon *cc, u32 mask)
 {
-	return chipco_read32(cc, SSB_CHIPCO_GPIOIN) & mask;
+	unsigned long flags;
+	u32 res = 0;
+
+	spin_lock_irqsave(&cc->gpio_lock, flags);
+	res = chipco_read32(cc, SSB_CHIPCO_GPIOIN) & mask;
+	spin_unlock_irqrestore(&cc->gpio_lock, flags);
+
+	return res;
 }
 
 u32 ssb_chipco_gpio_out(struct ssb_chipcommon *cc, u32 mask, u32 value)
 {
-	return chipco_write32_masked(cc, SSB_CHIPCO_GPIOOUT, mask, value);
+	unsigned long flags;
+	u32 res = 0;
+
+	spin_lock_irqsave(&cc->gpio_lock, flags);
+	res = chipco_write32_masked(cc, SSB_CHIPCO_GPIOOUT, mask, value);
+	spin_unlock_irqrestore(&cc->gpio_lock, flags);
+
+	return res;
 }
 
 u32 ssb_chipco_gpio_outen(struct ssb_chipcommon *cc, u32 mask, u32 value)
 {
-	return chipco_write32_masked(cc, SSB_CHIPCO_GPIOOUTEN, mask, value);
+	unsigned long flags;
+	u32 res = 0;
+
+	spin_lock_irqsave(&cc->gpio_lock, flags);
+	res = chipco_write32_masked(cc, SSB_CHIPCO_GPIOOUTEN, mask, value);
+	spin_unlock_irqrestore(&cc->gpio_lock, flags);
+
+	return res;
 }
 
 u32 ssb_chipco_gpio_control(struct ssb_chipcommon *cc, u32 mask, u32 value)
 {
-	return chipco_write32_masked(cc, SSB_CHIPCO_GPIOCTL, mask, value);
+	unsigned long flags;
+	u32 res = 0;
+
+	spin_lock_irqsave(&cc->gpio_lock, flags);
+	res = chipco_write32_masked(cc, SSB_CHIPCO_GPIOCTL, mask, value);
+	spin_unlock_irqrestore(&cc->gpio_lock, flags);
+
+	return res;
 }
 EXPORT_SYMBOL(ssb_chipco_gpio_control);
 
 u32 ssb_chipco_gpio_intmask(struct ssb_chipcommon *cc, u32 mask, u32 value)
 {
-	return chipco_write32_masked(cc, SSB_CHIPCO_GPIOIRQ, mask, value);
+	unsigned long flags;
+	u32 res = 0;
+
+	spin_lock_irqsave(&cc->gpio_lock, flags);
+	res = chipco_write32_masked(cc, SSB_CHIPCO_GPIOIRQ, mask, value);
+	spin_unlock_irqrestore(&cc->gpio_lock, flags);
+
+	return res;
 }
 
 u32 ssb_chipco_gpio_polarity(struct ssb_chipcommon *cc, u32 mask, u32 value)
 {
-	return chipco_write32_masked(cc, SSB_CHIPCO_GPIOPOL, mask, value);
+	unsigned long flags;
+	u32 res = 0;
+
+	spin_lock_irqsave(&cc->gpio_lock, flags);
+	res = chipco_write32_masked(cc, SSB_CHIPCO_GPIOPOL, mask, value);
+	spin_unlock_irqrestore(&cc->gpio_lock, flags);
+
+	return res;
 }
 
 u32 ssb_chipco_gpio_pullup(struct ssb_chipcommon *cc, u32 mask, u32 value)
 {
+	unsigned long flags;
+	u32 res = 0;
+
 	if (cc->dev->id.revision < 20)
 		return 0xffffffff;
 
-	return chipco_write32_masked(cc, SSB_CHIPCO_GPIOPULLUP, mask, value);
+	spin_lock_irqsave(&cc->gpio_lock, flags);
+	res = chipco_write32_masked(cc, SSB_CHIPCO_GPIOPULLUP, mask, value);
+	spin_unlock_irqrestore(&cc->gpio_lock, flags);
+
+	return res;
 }
 
 u32 ssb_chipco_gpio_pulldown(struct ssb_chipcommon *cc, u32 mask, u32 value)
 {
+	unsigned long flags;
+	u32 res = 0;
+
 	if (cc->dev->id.revision < 20)
 		return 0xffffffff;
 
-	return chipco_write32_masked(cc, SSB_CHIPCO_GPIOPULLDOWN, mask, value);
+	spin_lock_irqsave(&cc->gpio_lock, flags);
+	res = chipco_write32_masked(cc, SSB_CHIPCO_GPIOPULLDOWN, mask, value);
+	spin_unlock_irqrestore(&cc->gpio_lock, flags);
+
+	return res;
 }
 
 #ifdef CONFIG_SSB_SERIAL
diff --git a/drivers/ssb/driver_extif.c b/drivers/ssb/driver_extif.c
index dc47f30..c323579 100644
--- a/drivers/ssb/driver_extif.c
+++ b/drivers/ssb/driver_extif.c
@@ -118,29 +118,71 @@ void ssb_extif_watchdog_timer_set(struct ssb_extif *extif,
 	extif_write32(extif, SSB_EXTIF_WATCHDOG, ticks);
 }
 
+void ssb_extif_init(struct ssb_extif *extif)
+{
+	if (!extif->dev)
+		return; /* We don't have a Extif core */
+	spin_lock_init(&extif->gpio_lock);
+}
+
 u32 ssb_extif_gpio_in(struct ssb_extif *extif, u32 mask)
 {
-	return extif_read32(extif, SSB_EXTIF_GPIO_IN) & mask;
+	unsigned long flags;
+	u32 res = 0;
+
+	spin_lock_irqsave(&extif->gpio_lock, flags);
+	res = extif_read32(extif, SSB_EXTIF_GPIO_IN) & mask;
+	spin_unlock_irqrestore(&extif->gpio_lock, flags);
+
+	return res;
 }
 
 u32 ssb_extif_gpio_out(struct ssb_extif *extif, u32 mask, u32 value)
 {
-	return extif_write32_masked(extif, SSB_EXTIF_GPIO_OUT(0),
+	unsigned long flags;
+	u32 res = 0;
+
+	spin_lock_irqsave(&extif->gpio_lock, flags);
+	res = extif_write32_masked(extif, SSB_EXTIF_GPIO_OUT(0),
 				   mask, value);
+	spin_unlock_irqrestore(&extif->gpio_lock, flags);
+
+	return res;
 }
 
 u32 ssb_extif_gpio_outen(struct ssb_extif *extif, u32 mask, u32 value)
 {
-	return extif_write32_masked(extif, SSB_EXTIF_GPIO_OUTEN(0),
+	unsigned long flags;
+	u32 res = 0;
+
+	spin_lock_irqsave(&extif->gpio_lock, flags);
+	res = extif_write32_masked(extif, SSB_EXTIF_GPIO_OUTEN(0),
 				   mask, value);
+	spin_unlock_irqrestore(&extif->gpio_lock, flags);
+
+	return res;
 }
 
 u32 ssb_extif_gpio_polarity(struct ssb_extif *extif, u32 mask, u32 value)
 {
-	return extif_write32_masked(extif, SSB_EXTIF_GPIO_INTPOL, mask, value);
+	unsigned long flags;
+	u32 res = 0;
+
+	spin_lock_irqsave(&extif->gpio_lock, flags);
+	res = extif_write32_masked(extif, SSB_EXTIF_GPIO_INTPOL, mask, value);
+	spin_unlock_irqrestore(&extif->gpio_lock, flags);
+
+	return res;
 }
 
 u32 ssb_extif_gpio_intmask(struct ssb_extif *extif, u32 mask, u32 value)
 {
-	return extif_write32_masked(extif, SSB_EXTIF_GPIO_INTMASK, mask, value);
+	unsigned long flags;
+	u32 res = 0;
+
+	spin_lock_irqsave(&extif->gpio_lock, flags);
+	res = extif_write32_masked(extif, SSB_EXTIF_GPIO_INTMASK, mask, value);
+	spin_unlock_irqrestore(&extif->gpio_lock, flags);
+
+	return res;
 }
diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index df0f145..6fe2d10 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -796,6 +796,7 @@ static int __devinit ssb_bus_register(struct ssb_bus *bus,
 	if (err)
 		goto err_pcmcia_exit;
 	ssb_chipcommon_init(&bus->chipco);
+	ssb_extif_init(&bus->extif);
 	ssb_mipscore_init(&bus->mipscore);
 	err = ssb_fetch_invariants(bus, get_invariants);
 	if (err) {
diff --git a/drivers/ssb/ssb_private.h b/drivers/ssb/ssb_private.h
index a305550..d6a1ba9 100644
--- a/drivers/ssb/ssb_private.h
+++ b/drivers/ssb/ssb_private.h
@@ -211,4 +211,12 @@ static inline void b43_pci_ssb_bridge_exit(void)
 extern u32 ssb_pmu_get_cpu_clock(struct ssb_chipcommon *cc);
 extern u32 ssb_pmu_get_controlclock(struct ssb_chipcommon *cc);
 
+#ifdef CONFIG_SSB_DRIVER_EXTIF
+extern void ssb_extif_init(struct ssb_extif *extif);
+#else
+static inline void ssb_extif_init(struct ssb_extif *extif)
+{
+}
+#endif
+
 #endif /* LINUX_SSB_PRIVATE_H_ */
diff --git a/include/linux/ssb/ssb_driver_chipcommon.h b/include/linux/ssb/ssb_driver_chipcommon.h
index c8d07c9..30b6943 100644
--- a/include/linux/ssb/ssb_driver_chipcommon.h
+++ b/include/linux/ssb/ssb_driver_chipcommon.h
@@ -590,6 +590,7 @@ struct ssb_chipcommon {
 	u32 status;
 	/* Fast Powerup Delay constant */
 	u16 fast_pwrup_delay;
+	spinlock_t gpio_lock;
 	struct ssb_chipcommon_pmu pmu;
 };
 
diff --git a/include/linux/ssb/ssb_driver_extif.h b/include/linux/ssb/ssb_driver_extif.h
index 91161f0..bd23068 100644
--- a/include/linux/ssb/ssb_driver_extif.h
+++ b/include/linux/ssb/ssb_driver_extif.h
@@ -158,6 +158,7 @@
 
 struct ssb_extif {
 	struct ssb_device *dev;
+	spinlock_t gpio_lock;
 };
 
 static inline bool ssb_extif_available(struct ssb_extif *extif)
-- 
1.7.10.4

