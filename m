Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37580 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423070AbbD2OuP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2015 10:50:15 -0400
Received: by widdi4 with SMTP id di4so68895223wid.0
        for <linux-wireless@vger.kernel.org>; Wed, 29 Apr 2015 07:50:13 -0700 (PDT)
From: Eyal Reizer <eyalreizer@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Reizer <eyalr@ti.com>
Subject: [PATCH] wl18xx: wlan_irq: support platform dependent interrupt types
Date: Wed, 29 Apr 2015 17:50:03 +0300
Message-Id: <1430319003-13123-1-git-send-email-eyalr@ti.com> (sfid-20150429_165020_257889_B4D15717)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Interrupt request need to happen when the wilink chip is powered on and
  driving the wlan_irq line. This avoids spurious interrupt issues that
  are a result of different external pulls configuration on different
  platforms
* Allow working with wl18xx level-low and falling edge irqs by configuring
  wl18xx to invert the device interrupt

Signed-off-by: Eyal Reizer <eyalr@ti.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |   26 +++++++++++++++++++++++++-
 drivers/net/wireless/ti/wl18xx/reg.h  |    1 +
 drivers/net/wireless/ti/wlcore/main.c |   26 ++++++++++++++------------
 3 files changed, 40 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 11bd64a..ca2200b 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -24,6 +24,7 @@
 #include <linux/ip.h>
 #include <linux/firmware.h>
 #include <linux/etherdevice.h>
+#include <linux/irq.h>
 
 #include "../wlcore/wlcore.h"
 #include "../wlcore/debug.h"
@@ -580,7 +581,7 @@ static struct wl18xx_priv_conf wl18xx_default_priv_conf = {
 
 static const struct wlcore_partition_set wl18xx_ptable[PART_TABLE_LEN] = {
 	[PART_TOP_PRCM_ELP_SOC] = {
-		.mem  = { .start = 0x00A02000, .size  = 0x00010000 },
+		.mem  = { .start = 0x00A00000, .size  = 0x00012000 },
 		.reg  = { .start = 0x00807000, .size  = 0x00005000 },
 		.mem2 = { .start = 0x00800000, .size  = 0x0000B000 },
 		.mem3 = { .start = 0x00000000, .size  = 0x00000000 },
@@ -864,6 +865,7 @@ static int wl18xx_pre_upload(struct wl1271 *wl)
 {
 	u32 tmp;
 	int ret;
+	u16 irq_invert;
 
 	BUILD_BUG_ON(sizeof(struct wl18xx_mac_and_phy_params) >
 		WL18XX_PHY_INIT_MEM_SIZE);
@@ -913,6 +915,28 @@ static int wl18xx_pre_upload(struct wl1271 *wl)
 	/* re-enable FDSP clock */
 	ret = wlcore_write32(wl, WL18XX_PHY_FPGA_SPARE_1,
 			     MEM_FDSP_CLK_120_ENABLE);
+	if (ret < 0)
+		goto out;
+
+	ret = irq_get_trigger_type(wl->irq);
+	if ((ret == IRQ_TYPE_LEVEL_LOW) || (ret == IRQ_TYPE_EDGE_FALLING)) {
+		wl1271_info("using inverted interrupt logic: %d", ret);
+		ret = wlcore_set_partition(wl,
+					   &wl->ptable[PART_TOP_PRCM_ELP_SOC]);
+		if (ret < 0)
+			goto out;
+
+		ret = wl18xx_top_reg_read(wl, TOP_FN0_CCCR_REG_32, &irq_invert);
+		if (ret < 0)
+			goto out;
+
+		irq_invert |= BIT(1);
+		ret = wl18xx_top_reg_write(wl, TOP_FN0_CCCR_REG_32, irq_invert);
+		if (ret < 0)
+			goto out;
+
+		ret = wlcore_set_partition(wl, &wl->ptable[PART_PHY_INIT]);
+	}
 
 out:
 	return ret;
diff --git a/drivers/net/wireless/ti/wl18xx/reg.h b/drivers/net/wireless/ti/wl18xx/reg.h
index a433a75..bac2364 100644
--- a/drivers/net/wireless/ti/wl18xx/reg.h
+++ b/drivers/net/wireless/ti/wl18xx/reg.h
@@ -109,6 +109,7 @@
 
 #define WL18XX_WELP_ARM_COMMAND		(WL18XX_REGISTERS_BASE + 0x7100)
 #define WL18XX_ENABLE			(WL18XX_REGISTERS_BASE + 0x01543C)
+#define TOP_FN0_CCCR_REG_32		(WL18XX_TOP_OCP_BASE + 0x64)
 
 /* PRCM registers */
 #define PLATFORM_DETECTION		0xA0E3E0
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index f0286a9..f4d6301 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5991,10 +5991,6 @@ static int wl12xx_get_hw_info(struct wl1271 *wl)
 {
 	int ret;
 
-	ret = wl12xx_set_power_on(wl);
-	if (ret < 0)
-		return ret;
-
 	ret = wlcore_read_reg(wl, REG_CHIP_ID_B, &wl->chip.id);
 	if (ret < 0)
 		goto out;
@@ -6010,7 +6006,6 @@ static int wl12xx_get_hw_info(struct wl1271 *wl)
 		ret = wl->ops->get_mac(wl);
 
 out:
-	wl1271_power_off(wl);
 	return ret;
 }
 
@@ -6473,10 +6468,22 @@ static void wlcore_nvs_cb(const struct firmware *fw, void *context)
 	else
 		wl->irq_flags |= IRQF_ONESHOT;
 
+	ret = wl12xx_set_power_on(wl);
+	if (ret < 0)
+		goto out_free_nvs;
+
+	ret = wl12xx_get_hw_info(wl);
+	if (ret < 0) {
+		wl1271_error("couldn't get hw info");
+		wl1271_power_off(wl);
+		goto out_free_nvs;
+	}
+
 	ret = request_threaded_irq(wl->irq, hardirq_fn, wlcore_irq,
 				   wl->irq_flags, pdev->name, wl);
 	if (ret < 0) {
-		wl1271_error("request_irq() failed: %d", ret);
+		wl1271_error("interrupt configuration failed");
+		wl1271_power_off(wl);
 		goto out_free_nvs;
 	}
 
@@ -6490,12 +6497,7 @@ static void wlcore_nvs_cb(const struct firmware *fw, void *context)
 	}
 #endif
 	disable_irq(wl->irq);
-
-	ret = wl12xx_get_hw_info(wl);
-	if (ret < 0) {
-		wl1271_error("couldn't get hw info");
-		goto out_irq;
-	}
+	wl1271_power_off(wl);
 
 	ret = wl->ops->identify_chip(wl);
 	if (ret < 0)
-- 
1.7.9.5

