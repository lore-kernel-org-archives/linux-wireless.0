Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51434 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243Ab2KSW6m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 17:58:42 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: john@phrozen.org, ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
	florian@openwrt.org, zajec5@gmail.com, m@bues.ch,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/8] bcma: add bcma_chipco_gpio_pull{up,down}
Date: Mon, 19 Nov 2012 23:57:51 +0100
Message-Id: <1353365877-11131-3-git-send-email-hauke@hauke-m.de> (sfid-20121119_235848_602556_BA875389)
In-Reply-To: <1353365877-11131-1-git-send-email-hauke@hauke-m.de>
References: <1353365877-11131-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add functions to access the GPIO registers for pullup and pulldown.
These are needed for handling gpio registration.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_chipcommon.c            |   30 +++++++++++++++++++++++++++
 include/linux/bcma/bcma_driver_chipcommon.h |    2 ++
 2 files changed, 32 insertions(+)

diff --git a/drivers/bcma/driver_chipcommon.c b/drivers/bcma/driver_chipcommon.c
index 9b34316..f3c736a 100644
--- a/drivers/bcma/driver_chipcommon.c
+++ b/drivers/bcma/driver_chipcommon.c
@@ -152,6 +152,36 @@ u32 bcma_chipco_gpio_polarity(struct bcma_drv_cc *cc, u32 mask, u32 value)
 	return res;
 }
 
+u32 bcma_chipco_gpio_pullup(struct bcma_drv_cc *cc, u32 mask, u32 value)
+{
+	unsigned long flags;
+	u32 res;
+
+	if (cc->core->id.rev < 20)
+		return 0;
+
+	spin_lock_irqsave(&cc->gpio_lock, flags);
+	res = bcma_cc_write32_masked(cc, BCMA_CC_GPIOPULLUP, mask, value);
+	spin_unlock_irqrestore(&cc->gpio_lock, flags);
+
+	return res;
+}
+
+u32 bcma_chipco_gpio_pulldown(struct bcma_drv_cc *cc, u32 mask, u32 value)
+{
+	unsigned long flags;
+	u32 res;
+
+	if (cc->core->id.rev < 20)
+		return 0;
+
+	spin_lock_irqsave(&cc->gpio_lock, flags);
+	res = bcma_cc_write32_masked(cc, BCMA_CC_GPIOPULLDOWN, mask, value);
+	spin_unlock_irqrestore(&cc->gpio_lock, flags);
+
+	return res;
+}
+
 #ifdef CONFIG_BCMA_DRIVER_MIPS
 void bcma_chipco_serial_init(struct bcma_drv_cc *cc)
 {
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index a085d98..2567026 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -606,6 +606,8 @@ u32 bcma_chipco_gpio_outen(struct bcma_drv_cc *cc, u32 mask, u32 value);
 u32 bcma_chipco_gpio_control(struct bcma_drv_cc *cc, u32 mask, u32 value);
 u32 bcma_chipco_gpio_intmask(struct bcma_drv_cc *cc, u32 mask, u32 value);
 u32 bcma_chipco_gpio_polarity(struct bcma_drv_cc *cc, u32 mask, u32 value);
+u32 bcma_chipco_gpio_pullup(struct bcma_drv_cc *cc, u32 mask, u32 value);
+u32 bcma_chipco_gpio_pulldown(struct bcma_drv_cc *cc, u32 mask, u32 value);
 
 /* PMU support */
 extern void bcma_pmu_init(struct bcma_drv_cc *cc);
-- 
1.7.10.4

