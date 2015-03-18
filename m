Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:36136 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920AbbCRQik (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 12:38:40 -0400
Received: by wgra20 with SMTP id a20so40043028wgr.3
        for <linux-wireless@vger.kernel.org>; Wed, 18 Mar 2015 09:38:38 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<linux-omap@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	=?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
	Tony Lindgren <tony@atomide.com>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Javier Martinez Canillas <javier@dowhile0.org>,
	Sekhar Nori <nsekhar@ti.com>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	Luciano Coelho <luca@coelho.fi>
Subject: [PATCH v7 1/6] wlcore: set irq_trigger in board files instead of hiding behind a quirk
Date: Wed, 18 Mar 2015 18:38:25 +0200
Message-Id: <1426696710-6891-2-git-send-email-eliad@wizery.com> (sfid-20150318_173846_356989_3085191C)
In-Reply-To: <1426696710-6891-1-git-send-email-eliad@wizery.com>
References: <1426696710-6891-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luca@coelho.fi>

The platform_quirk element in the platform data was used
to change the way the IRQ is triggered.  When set,
the EDGE_IRQ quirk would change the irqflags used
and treat edge trigger differently from the rest.

Instead of hiding this irq flag setting behind the quirk,
have the board files set the irq_trigger explicitly.

This will allow us to use standard irq DT definitions
later on.

Signed-off-by: Luciano Coelho <luca@coelho.fi>
[Eliad - rebase, add irq_trigger field and pass it,
update board file changes]
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 arch/arm/mach-davinci/board-da850-evm.c  |  2 +-
 arch/arm/mach-omap2/pdata-quirks.c       |  1 +
 drivers/net/wireless/ti/wlcore/debugfs.c |  2 +-
 drivers/net/wireless/ti/wlcore/main.c    | 27 ++++++++++++++++-----------
 drivers/net/wireless/ti/wlcore/sdio.c    |  2 +-
 drivers/net/wireless/ti/wlcore/wlcore.h  |  5 ++---
 include/linux/wl12xx.h                   |  5 +----
 7 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index 6b5a97d..916589c 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -1385,8 +1385,8 @@ static const short da850_wl12xx_pins[] __initconst = {
 
 static struct wl12xx_platform_data da850_wl12xx_wlan_data __initdata = {
 	.irq			= -1,
+	.irq_trigger		= IRQ_TYPE_EDGE_RISING,
 	.board_ref_clock	= WL12XX_REFCLOCK_38,
-	.platform_quirks	= WL12XX_PLATFORM_QUIRK_EDGE_IRQ,
 };
 
 static __init int da850_wl12xx_init(void)
diff --git a/arch/arm/mach-omap2/pdata-quirks.c b/arch/arm/mach-omap2/pdata-quirks.c
index e642b07..e86fb0d 100644
--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -48,6 +48,7 @@ static void __init __used legacy_init_wl12xx(unsigned ref_clock,
 	wl12xx.board_ref_clock = ref_clock;
 	wl12xx.board_tcxo_clock = tcxo_clock;
 	wl12xx.irq = gpio_to_irq(gpio);
+	wl12xx.irq_trigger = IRQ_TYPE_LEVEL_HIGH;
 
 	res = wl12xx_set_platform_data(&wl12xx);
 	if (res) {
diff --git a/drivers/net/wireless/ti/wlcore/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
index 68f3bf2..eb43f94 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.c
+++ b/drivers/net/wireless/ti/wlcore/debugfs.c
@@ -502,7 +502,7 @@ static ssize_t driver_state_read(struct file *file, char __user *user_buf,
 	DRIVER_STATE_PRINT_HEX(irq);
 	/* TODO: ref_clock and tcxo_clock were moved to wl12xx priv */
 	DRIVER_STATE_PRINT_HEX(hw_pg_ver);
-	DRIVER_STATE_PRINT_HEX(platform_quirks);
+	DRIVER_STATE_PRINT_HEX(irq_flags);
 	DRIVER_STATE_PRINT_HEX(chip.id);
 	DRIVER_STATE_PRINT_STR(chip.fw_ver_str);
 	DRIVER_STATE_PRINT_STR(chip.phy_fw_ver_str);
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 1e13699..67518f6 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -27,6 +27,7 @@
 #include <linux/vmalloc.h>
 #include <linux/wl12xx.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 
 #include "wlcore.h"
 #include "debug.h"
@@ -538,7 +539,7 @@ static int wlcore_irq_locked(struct wl1271 *wl)
 	 * In case edge triggered interrupt must be used, we cannot iterate
 	 * more than once without introducing race conditions with the hardirq.
 	 */
-	if (wl->platform_quirks & WL12XX_PLATFORM_QUIRK_EDGE_IRQ)
+	if (wl->irq_flags & (IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING))
 		loopcount = 1;
 
 	wl1271_debug(DEBUG_IRQ, "IRQ work");
@@ -6249,7 +6250,6 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size,
 	wl->ap_ps_map = 0;
 	wl->ap_fw_ps_map = 0;
 	wl->quirks = 0;
-	wl->platform_quirks = 0;
 	wl->system_hlid = WL12XX_SYSTEM_HLID;
 	wl->active_sta_count = 0;
 	wl->active_link_count = 0;
@@ -6391,7 +6391,8 @@ static void wlcore_nvs_cb(const struct firmware *fw, void *context)
 	struct platform_device *pdev = wl->pdev;
 	struct wlcore_platdev_data *pdev_data = dev_get_platdata(&pdev->dev);
 	struct wl12xx_platform_data *pdata = pdev_data->pdata;
-	unsigned long irqflags;
+	struct resource *res;
+
 	int ret;
 	irq_handler_t hardirq_fn = NULL;
 
@@ -6418,19 +6419,23 @@ static void wlcore_nvs_cb(const struct firmware *fw, void *context)
 	/* adjust some runtime configuration parameters */
 	wlcore_adjust_conf(wl);
 
-	wl->irq = platform_get_irq(pdev, 0);
-	wl->platform_quirks = pdata->platform_quirks;
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res) {
+		wl1271_error("Could not get IRQ resource");
+		goto out_free_nvs;
+	}
+
+	wl->irq = res->start;
+	wl->irq_flags = res->flags & IRQF_TRIGGER_MASK;
 	wl->if_ops = pdev_data->if_ops;
 
-	if (wl->platform_quirks & WL12XX_PLATFORM_QUIRK_EDGE_IRQ) {
-		irqflags = IRQF_TRIGGER_RISING;
+	if (wl->irq_flags & (IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING))
 		hardirq_fn = wlcore_hardirq;
-	} else {
-		irqflags = IRQF_TRIGGER_HIGH | IRQF_ONESHOT;
-	}
+	else
+		wl->irq_flags |= IRQF_ONESHOT;
 
 	ret = request_threaded_irq(wl->irq, hardirq_fn, wlcore_irq,
-				   irqflags, pdev->name, wl);
+				   wl->irq_flags, pdev->name, wl);
 	if (ret < 0) {
 		wl1271_error("request_irq() failed: %d", ret);
 		goto out_free_nvs;
diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index d3dd7bf..2bce00a 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -287,7 +287,7 @@ static int wl1271_probe(struct sdio_func *func,
 	memset(res, 0x00, sizeof(res));
 
 	res[0].start = pdev_data.pdata->irq;
-	res[0].flags = IORESOURCE_IRQ;
+	res[0].flags = IORESOURCE_IRQ | pdev_data.pdata->irq_trigger;
 	res[0].name = "irq";
 
 	ret = platform_device_add_resources(glue->core, res, ARRAY_SIZE(res));
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index d599c86..7f363fa 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -197,6 +197,8 @@ struct wl1271 {
 
 	int irq;
 
+	int irq_flags;
+
 	spinlock_t wl_lock;
 
 	enum wlcore_state state;
@@ -404,9 +406,6 @@ struct wl1271 {
 	/* Quirks of specific hardware revisions */
 	unsigned int quirks;
 
-	/* Platform limitations */
-	unsigned int platform_quirks;
-
 	/* number of currently active RX BA sessions */
 	int ba_rx_session_count;
 
diff --git a/include/linux/wl12xx.h b/include/linux/wl12xx.h
index a9c723b..3876b67 100644
--- a/include/linux/wl12xx.h
+++ b/include/linux/wl12xx.h
@@ -57,15 +57,12 @@ struct wl1251_platform_data {
 
 struct wl12xx_platform_data {
 	int irq;
+	u32 irq_trigger;
 	int board_ref_clock;
 	int board_tcxo_clock;
-	unsigned long platform_quirks;
 	bool pwr_in_suspend;
 };
 
-/* Platform does not support level trigger interrupts */
-#define WL12XX_PLATFORM_QUIRK_EDGE_IRQ	BIT(0)
-
 #ifdef CONFIG_WILINK_PLATFORM_DATA
 
 int wl12xx_set_platform_data(const struct wl12xx_platform_data *data);
-- 
1.8.5.2.229.g4448466.dirty

