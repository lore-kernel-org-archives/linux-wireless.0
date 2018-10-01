Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D47EC43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 21:41:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BC202089A
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 21:41:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5BC202089A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=atomide.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbeJBEVT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 00:21:19 -0400
Received: from muru.com ([72.249.23.125]:58054 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726027AbeJBEVT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 00:21:19 -0400
Received: from hillo.muru.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTP id 787DB80F0;
        Mon,  1 Oct 2018 21:45:54 +0000 (UTC)
From:   Tony Lindgren <tony@atomide.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Eyal Reizer <eyalr@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Guy Mishol <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH] wlcore: Add support for optional wakeirq
Date:   Mon,  1 Oct 2018 14:41:10 -0700
Message-Id: <20181001214110.86774-1-tony@atomide.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Now with wlcore using PM runtime, we can also add support for Linux
generic wakeirq handling for it if configured in the dts file.

The wakeirq can be configured as the second interrupt in the dts file
with interrupts-extended property where it is the padconf irq of the OOB
GPIO pin used for wlcore interrupt.

Note that eventually we should also allow configuring wlcore to use the
SDIO dat1 IRQ for wake-up, and in that case the the wakeirq should be
configured to be the padconf interrupt of the dat1 pin and not the
padconf interrupt of the OOB GPIO pin.

Cc: Eyal Reizer <eyalr@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/net/wireless/ti/wlcore/main.c   | 30 +++++++++++++++++++++----
 drivers/net/wireless/ti/wlcore/sdio.c   | 17 +++++++++-----
 drivers/net/wireless/ti/wlcore/wlcore.h |  2 ++
 3 files changed, 40 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -27,6 +27,7 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/pm_runtime.h>
+#include <linux/pm_wakeirq.h>
 
 #include "wlcore.h"
 #include "debug.h"
@@ -6627,13 +6628,25 @@ static void wlcore_nvs_cb(const struct firmware *fw, void *context)
 	}
 
 #ifdef CONFIG_PM
+	device_init_wakeup(wl->dev, true);
+
 	ret = enable_irq_wake(wl->irq);
 	if (!ret) {
 		wl->irq_wake_enabled = true;
-		device_init_wakeup(wl->dev, 1);
 		if (pdev_data->pwr_in_suspend)
 			wl->hw->wiphy->wowlan = &wlcore_wowlan_support;
 	}
+
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 1);
+	if (res) {
+		wl->wakeirq = res->start;
+		wl->wakeirq_flags = res->flags & IRQF_TRIGGER_MASK;
+		ret = dev_pm_set_dedicated_wake_irq(wl->dev, wl->wakeirq);
+		if (ret)
+			wl->wakeirq = -ENODEV;
+	} else {
+		wl->wakeirq = -ENODEV;
+	}
 #endif
 	disable_irq(wl->irq);
 	wl1271_power_off(wl);
@@ -6661,6 +6674,9 @@ static void wlcore_nvs_cb(const struct firmware *fw, void *context)
 	wl1271_unregister_hw(wl);
 
 out_irq:
+	if (wl->wakeirq >= 0)
+		dev_pm_clear_wake_irq(wl->dev);
+	device_init_wakeup(wl->dev, false);
 	free_irq(wl->irq, wl);
 
 out_free_nvs:
@@ -6825,10 +6841,16 @@ int wlcore_remove(struct platform_device *pdev)
 	if (!wl->initialized)
 		return 0;
 
-	if (wl->irq_wake_enabled) {
-		device_init_wakeup(wl->dev, 0);
-		disable_irq_wake(wl->irq);
+	if (wl->wakeirq >= 0) {
+		dev_pm_clear_wake_irq(wl->dev);
+		wl->wakeirq = -ENODEV;
 	}
+
+	device_init_wakeup(wl->dev, false);
+
+	if (wl->irq_wake_enabled)
+		disable_irq_wake(wl->irq);
+
 	wl1271_unregister_hw(wl);
 
 	pm_runtime_put_sync(wl->dev);
diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -241,7 +241,7 @@ static const struct of_device_id wlcore_sdio_of_match_table[] = {
 	{ }
 };
 
-static int wlcore_probe_of(struct device *dev, int *irq,
+static int wlcore_probe_of(struct device *dev, int *irq, int *wakeirq,
 			   struct wlcore_platdev_data *pdev_data)
 {
 	struct device_node *np = dev->of_node;
@@ -259,6 +259,8 @@ static int wlcore_probe_of(struct device *dev, int *irq,
 		return -EINVAL;
 	}
 
+	*wakeirq = irq_of_parse_and_map(np, 1);
+
 	/* optional clock frequency params */
 	of_property_read_u32(np, "ref-clock-frequency",
 			     &pdev_data->ref_clock_freq);
@@ -268,7 +270,7 @@ static int wlcore_probe_of(struct device *dev, int *irq,
 	return 0;
 }
 #else
-static int wlcore_probe_of(struct device *dev, int *irq,
+static int wlcore_probe_of(struct device *dev, int *irq, int *wakeirq,
 			   struct wlcore_platdev_data *pdev_data)
 {
 	return -ENODATA;
@@ -280,10 +282,10 @@ static int wl1271_probe(struct sdio_func *func,
 {
 	struct wlcore_platdev_data *pdev_data;
 	struct wl12xx_sdio_glue *glue;
-	struct resource res[1];
+	struct resource res[2];
 	mmc_pm_flag_t mmcflags;
 	int ret = -ENOMEM;
-	int irq;
+	int irq, wakeirq;
 	const char *chip_family;
 
 	/* We are only able to handle the wlan function */
@@ -308,7 +310,7 @@ static int wl1271_probe(struct sdio_func *func,
 	/* Use block mode for transferring over one block size of data */
 	func->card->quirks |= MMC_QUIRK_BLKSZ_FOR_BYTE_MODE;
 
-	ret = wlcore_probe_of(&func->dev, &irq, pdev_data);
+	ret = wlcore_probe_of(&func->dev, &irq, &wakeirq, pdev_data);
 	if (ret)
 		goto out;
 
@@ -351,6 +353,11 @@ static int wl1271_probe(struct sdio_func *func,
 		       irqd_get_trigger_type(irq_get_irq_data(irq));
 	res[0].name = "irq";
 
+	res[1].start = wakeirq;
+	res[1].flags = IORESOURCE_IRQ |
+		       irqd_get_trigger_type(irq_get_irq_data(wakeirq));
+	res[1].name = "wakeirq";
+
 	ret = platform_device_add_resources(glue->core, res, ARRAY_SIZE(res));
 	if (ret) {
 		dev_err(glue->dev, "can't add resources\n");
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -199,8 +199,10 @@ struct wl1271 {
 	struct wl1271_if_operations *if_ops;
 
 	int irq;
+	int wakeirq;
 
 	int irq_flags;
+	int wakeirq_flags;
 
 	spinlock_t wl_lock;
 
-- 
2.19.0
