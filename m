Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1750 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799AbZHDDkG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 23:40:06 -0400
Date: Mon, 3 Aug 2009 23:39:08 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] wl12xx: make irq handling interface specific
Message-ID: <20090804033908.GA1903@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

In addition to the warning below this patch also fixes oopses
on rmmod due to active irqs after free.  Please consider
including it with the original sdio series.  With this wl1251
is stable, scans, and sends probe requests; association
probably needs resolution of the issue you already identified
with spi.

--------------

From: Bob Copeland <me@bobcopeland.com>
Date: Fri, 17 Jul 2009 23:53:15 -0400
Subject: [PATCH] wl12xx: make irq handling interface specific

In SDIO, the host driver requests the IRQ and invokes a callback to the
card driver.  This differs from SPI, so the relevant code needs to be
interface-specific.  This patch pushes the irq code down into _spi.c
and _sdio.c, and adds enable/disable callbacks.

This fixes the following warning:

[  566.343887] ------------[ cut here ]------------
[  566.349105] WARNING: at kernel/irq/manage.c:222 __enable_irq+0x3c/0x6c()
[  566.356735] Unbalanced enable for IRQ 0
[  566.361099] Modules linked in: msm_wifi wl12xx_sdio wl12xx mac80211 cfg80211 rfkill_backport lib80211_crypt_ccmp lib80211_crypt_wep lib80211_crypt_tkip lib80211
[  566.381240] [<c025acec>] (dump_stack+0x0/0x14) from [<c004b610>] (warn_slowpath+0x70/0x8c)
[  566.391860] [<c004b5a0>] (warn_slowpath+0x0/0x8c) from [<c0077c10>] (__enable_irq+0x3c/0x6c)
[  566.402572]  r3:00000000 r2:c02cad13
[  566.407516]  r7:00001002 r6:00000000 r5:c0310be4 r4:c0310be4
[  566.415786] [<c0077bd4>] (__enable_irq+0x0/0x6c) from [<c0077fd0>] (enable_irq+0x38/0x64)
[  566.425826]  r5:c0310be4 r4:a0000013
[  566.430709] [<c0077f98>] (enable_irq+0x0/0x64) from [<bf0dfa78>] (wl12xx_boot_run_firmware+0xfc/0x170 [wl12xx])
[  566.442947]  r7:00001002 r6:c440a9fc r5:00000072 r4:c440a9e0
[  566.450851] [<bf0df97c>] (wl12xx_boot_run_firmware+0x0/0x170 [wl12xx]) from [<bf0e05f0>] (wl1251_boot+0xd4/0x108 [wl12xx])
[  566.464492]  r5:00000000 r4:c440a9e0
[  566.469466] [<bf0e051c>] (wl1251_boot+0x0/0x108 [wl12xx]) from [<bf0dd27c>] (wl12xx_op_start+0x54/0xb8 [wl12xx])
[  566.482162]  r5:00000000 r4:c440a9e0
[  566.487472] [<bf0dd228>] (wl12xx_op_start+0x0/0xb8 [wl12xx]) from [<bf0b96dc>] (ieee80211_open+0x2dc/0x720 [mac80211])
[  566.500594]  r7:00001002 r6:c4950800 r5:c440a220 r4:00000000
[  566.508865] [<bf0b9400>] (ieee80211_open+0x0/0x720 [mac80211]) from [<c01f1edc>] (dev_open+0x9c/0xfc)
[  566.520705] [<c01f1e40>] (dev_open+0x0/0xfc) from [<c01f17dc>] (dev_change_flags+0x98/0x170)
[  566.531417]  r5:00000041 r4:c4950800
[  566.536330] [<c01f1744>] (dev_change_flags+0x0/0x170) from [<c023041c>] (devinet_ioctl+0x3a8/0x784)
[  566.547683]  r7:c128e380 r6:00000001 r5:00008914 r4:00000000
[  566.555587] [<c0230074>] (devinet_ioctl+0x0/0x784) from [<c02318cc>] (inet_ioctl+0xdc/0x114)
[  566.566299] [<c02317f0>] (inet_ioctl+0x0/0x114) from [<c01e1a60>] (sock_ioctl+0x1f0/0x248)
[  566.576827]  r5:00008914 r4:c572c1a0
[  566.581771] [<c01e1870>] (sock_ioctl+0x0/0x248) from [<c00b23a0>] (vfs_ioctl+0x34/0x94)
[  566.592086]  r7:c572c1a0 r6:bee497e8 r5:00008914 r4:c572c1a0
[  566.599990] [<c00b236c>] (vfs_ioctl+0x0/0x94) from [<c00b2a28>] (do_vfs_ioctl+0x52c/0x584)
[  566.610549]  r7:c572c1a0 r6:00008914 r5:c572c1a0 r4:c3201228
[  566.618453] [<c00b24fc>] (do_vfs_ioctl+0x0/0x584) from [<c00b2ac0>] (sys_ioctl+0x40/0x64)
[  566.628890] [<c00b2a80>] (sys_ioctl+0x0/0x64) from [<c0021da0>] (ret_fast_syscall+0x0/0x2c)
[  566.639541]  r7:00000036 r6:00000000 r5:00000004 r4:001a11f3
[  566.647445] ---[ end trace 15c26ef7dd5e7b03 ]---

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/wl12xx/wl1251.h      |    5 +++-
 drivers/net/wireless/wl12xx/wl1251_boot.c |    7 +----
 drivers/net/wireless/wl12xx/wl1251_main.c |   24 +++++-----------
 drivers/net/wireless/wl12xx/wl1251_sdio.c |   42 ++++++++++++++++++++++------
 drivers/net/wireless/wl12xx/wl1251_spi.c  |   26 ++++++++++++++++++
 5 files changed, 71 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251.h b/drivers/net/wireless/wl12xx/wl1251.h
index ebe2c70..13f0589 100644
--- a/drivers/net/wireless/wl12xx/wl1251.h
+++ b/drivers/net/wireless/wl12xx/wl1251.h
@@ -285,6 +285,8 @@ struct wl1251_if_operations {
 	void (*read)(struct wl1251 *wl, int addr, void *buf, size_t len);
 	void (*write)(struct wl1251 *wl, int addr, void *buf, size_t len);
 	void (*reset)(struct wl1251 *wl);
+	void (*enable_irq)(struct wl1251 *wl);
+	void (*disable_irq)(struct wl1251 *wl);
 };
 
 struct wl1251 {
@@ -404,10 +406,11 @@ struct wl1251 {
 int wl1251_plt_start(struct wl1251 *wl);
 int wl1251_plt_stop(struct wl1251 *wl);
 
-irqreturn_t wl1251_irq(int irq, void *cookie);
 struct ieee80211_hw *wl1251_alloc_hw(void);
 int wl1251_free_hw(struct wl1251 *wl);
 int wl1251_init_ieee80211(struct wl1251 *wl);
+void wl1251_enable_interrupts(struct wl1251 *wl);
+void wl1251_disable_interrupts(struct wl1251 *wl);
 
 #define DEFAULT_HW_GEN_MODULATION_TYPE    CCK_LONG /* Long Preamble */
 #define DEFAULT_HW_GEN_TX_RATE          RATE_2MBPS
diff --git a/drivers/net/wireless/wl12xx/wl1251_boot.c b/drivers/net/wireless/wl12xx/wl1251_boot.c
index 5c6f327..8b50d44 100644
--- a/drivers/net/wireless/wl12xx/wl1251_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1251_boot.c
@@ -29,11 +29,6 @@
 #include "wl1251_spi.h"
 #include "wl1251_event.h"
 
-static void wl1251_boot_enable_interrupts(struct wl1251 *wl)
-{
-	enable_irq(wl->irq);
-}
-
 void wl1251_boot_target_enable_interrupts(struct wl1251 *wl)
 {
 	wl1251_reg_write32(wl, ACX_REG_INTERRUPT_MASK, ~(wl->intr_mask));
@@ -278,7 +273,7 @@ int wl1251_boot_run_firmware(struct wl1251 *wl)
 	 */
 
 	/* enable gpio interrupts */
-	wl1251_boot_enable_interrupts(wl);
+	wl1251_enable_interrupts(wl);
 
 	wl->chip.op_target_enable_interrupts(wl);
 
diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index abe157a..4c1aad3 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -42,9 +42,14 @@
 #include "wl1251_init.h"
 #include "wl1251_debugfs.h"
 
-static void wl1251_disable_interrupts(struct wl1251 *wl)
+void wl1251_enable_interrupts(struct wl1251 *wl)
 {
-	disable_irq(wl->irq);
+	wl->if_ops->enable_irq(wl);
+}
+
+void wl1251_disable_interrupts(struct wl1251 *wl)
+{
+	wl->if_ops->disable_irq(wl);
 }
 
 static void wl1251_power_off(struct wl1251 *wl)
@@ -57,20 +62,6 @@ static void wl1251_power_on(struct wl1251 *wl)
 	wl->set_power(true);
 }
 
-irqreturn_t wl1251_irq(int irq, void *cookie)
-{
-	struct wl1251 *wl;
-
-	wl1251_debug(DEBUG_IRQ, "IRQ");
-
-	wl = cookie;
-
-	schedule_work(&wl->irq_work);
-
-	return IRQ_HANDLED;
-}
-EXPORT_SYMBOL_GPL(wl1251_irq);
-
 static int wl1251_fetch_firmware(struct wl1251 *wl)
 {
 	const struct firmware *fw;
@@ -1280,7 +1271,6 @@ int wl1251_free_hw(struct wl1251 *wl)
 
 	wl1251_debugfs_exit(wl);
 
-	free_irq(wl->irq, wl);
 	kfree(wl->target_mem_map);
 	kfree(wl->data_path);
 	kfree(wl->fw);
diff --git a/drivers/net/wireless/wl12xx/wl1251_sdio.c b/drivers/net/wireless/wl12xx/wl1251_sdio.c
index f1d9e76..a3e3aa9 100644
--- a/drivers/net/wireless/wl12xx/wl1251_sdio.c
+++ b/drivers/net/wireless/wl12xx/wl1251_sdio.c
@@ -50,7 +50,12 @@ static struct sdio_func *wl_to_func(struct wl1251 *wl)
 
 static void wl1251_sdio_interrupt(struct sdio_func *func)
 {
-	wl1251_irq(0, sdio_get_drvdata(func));
+	struct wl1251 *wl = sdio_get_drvdata(func);
+
+	wl1251_debug(DEBUG_IRQ, "IRQ");
+
+	/* FIXME should be synchronous for sdio */
+	schedule_work(&wl->irq_work);
 }
 
 static const struct sdio_device_id wl1251_devices[] = {
@@ -88,6 +93,30 @@ void wl1251_sdio_reset(struct wl1251 *wl)
 {
 }
 
+static int wl1251_sdio_enable_irq(struct wl1251 *wl)
+{
+	struct sdio_func *func = wl_to_func(wl);
+	int ret;
+
+	sdio_claim_host(func);
+	ret = sdio_claim_irq(func, wl1251_sdio_interrupt);
+	sdio_release_host(func);
+
+	return ret;
+}
+
+static int wl1251_sdio_disable_irq(struct wl1251 *wl)
+{
+	struct sdio_func *func = wl_to_func(wl);
+	int ret;
+
+	sdio_claim_host(func);
+	sdio_release_irq(func);
+	sdio_release_host(func);
+
+	return ret;
+}
+
 void wl1251_sdio_set_power(bool enable)
 {
 }
@@ -96,6 +125,8 @@ struct wl1251_if_operations wl1251_sdio_ops = {
 	.read = wl1251_sdio_read,
 	.write = wl1251_sdio_write,
 	.reset = wl1251_sdio_reset,
+	.enable_irq = wl1251_sdio_enable_irq,
+	.disable_irq = wl1251_sdio_disable_irq,
 };
 
 int wl1251_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
@@ -124,21 +155,14 @@ int wl1251_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 
 	sdio_release_host(func);
 	ret = wl1251_init_ieee80211(wl);
-	sdio_claim_host(func);
 	if (ret)
 		goto disable;
 
-	ret = sdio_claim_irq(func, wl1251_sdio_interrupt);
-	if (ret)
-		goto no_irq;
-
-	sdio_release_host(func);
 	sdio_set_drvdata(func, wl);
 	return ret;
 
-no_irq:
-	wl1251_free_hw(wl);
 disable:
+	sdio_claim_host(func);
 	sdio_disable_func(func);
 release:
 	sdio_release_host(func);
diff --git a/drivers/net/wireless/wl12xx/wl1251_spi.c b/drivers/net/wireless/wl12xx/wl1251_spi.c
index 464b802..fffa970 100644
--- a/drivers/net/wireless/wl12xx/wl1251_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1251_spi.c
@@ -31,6 +31,19 @@
 #include "reg.h"
 #include "wl1251_spi.h"
 
+static irqreturn_t wl1251_irq(int irq, void *cookie)
+{
+	struct wl1251 *wl;
+
+	wl1251_debug(DEBUG_IRQ, "IRQ");
+
+	wl = cookie;
+
+	schedule_work(&wl->irq_work);
+
+	return IRQ_HANDLED;
+}
+
 static struct spi_device *wl_to_spi(struct wl1251 *wl)
 {
 	return wl->if_priv;
@@ -193,10 +206,22 @@ static void wl1251_spi_write(struct wl1251 *wl, int addr, void *buf,
 	wl1251_dump(DEBUG_SPI, "spi_write buf -> ", buf, len);
 }
 
+static void wl1251_spi_enable_irq(struct wl1251 *wl)
+{
+	return enable_irq(wl->irq);
+}
+
+static void wl1251_spi_disable_irq(struct wl1251 *wl)
+{
+	return disable_irq(wl->irq);
+}
+
 const struct wl1251_if_operations wl1251_spi_ops = {
 	.read = wl1251_spi_read,
 	.write = wl1251_spi_write,
 	.reset = wl1251_spi_reset_wake,
+	.enable_irq = wl1251_spi_enable_irq,
+	.disable_irq = wl1251_spi_disable_irq,
 };
 
 static int __devinit wl1251_spi_probe(struct spi_device *spi)
@@ -274,6 +299,7 @@ static int __devexit wl1251_spi_remove(struct spi_device *spi)
 {
 	struct wl1251 *wl = dev_get_drvdata(&spi->dev);
 
+	free_irq(wl->irq, wl);
 	wl1251_free_hw(wl);
 
 	return 0;
-- 
1.6.2.5

-- 
Bob Copeland %% www.bobcopeland.com

