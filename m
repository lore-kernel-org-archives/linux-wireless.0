Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2905 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbZGRFdW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jul 2009 01:33:22 -0400
Date: Sat, 18 Jul 2009 01:32:57 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/8] wl1251 sdio interface
Message-ID: <20090718053257.GB5826@hash.localnet>
References: <20090717184643.25883.95065.stgit@tikku> <87r5wfp1v4.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87r5wfp1v4.fsf@litku.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 17, 2009 at 10:04:47PM +0300, Kalle Valo wrote:
> Kalle Valo <kalle.valo@iki.fi> writes:
> 
> > Here is v2 of Bob's wl1251 sdio patches. I have now rebased them on
> > top of wl1251/wl1271 split patches. Only compile-tested because I
> > don't have working test setup right now (neither spi or sdio), but I
> > should have access to one in two weeks.

Ok, my first tests with this have mixed results -- wpa_supplicant
didn't associate, but I could do a scan.  There were a few sdio
transfer errors.  So I'll try going back to the earlier version and see
how they compare.

Meanwhile, this patch (or something like it) would be good:

>From 742f257a955fa9e637f7bcb62a73a110718fb247 Mon Sep 17 00:00:00 2001
From: Bob Copeland <me@bobcopeland.com>
Date: Fri, 17 Jul 2009 23:53:15 -0400
Subject: [PATCH] wl12xx: make irq handling interface specific

Due to the differences in interrupt handling between SPI and SDIO, the
relevant code needs to be interface specific.  This patch pushes
the irq code down into _spi.c and _sdio.c, and adds enable/disable
callbacks (no-ops for the SDIO case, but not needed there).

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
 drivers/net/wireless/wl12xx/wl1251.h      |    5 ++++-
 drivers/net/wireless/wl12xx/wl1251_boot.c |    7 +------
 drivers/net/wireless/wl12xx/wl1251_main.c |   26 +++++++++-----------------
 drivers/net/wireless/wl12xx/wl1251_sdio.c |    7 ++++++-
 drivers/net/wireless/wl12xx/wl1251_spi.c  |   17 +++++++++++++++++
 5 files changed, 37 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251.h b/drivers/net/wireless/wl12xx/wl1251.h
index ebe2c70..20d77fe 100644
--- a/drivers/net/wireless/wl12xx/wl1251.h
+++ b/drivers/net/wireless/wl12xx/wl1251.h
@@ -295,6 +295,8 @@ struct wl1251 {
 	const struct wl1251_if_operations *if_ops;
 
 	void (*set_power)(bool enable);
+	void (*enable_irq)(int irq);
+	void (*disable_irq)(int irq);
 	int irq;
 
 	enum wl1251_state state;
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
index c5c94b2..094247c 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -42,9 +42,16 @@
 #include "wl1251_init.h"
 #include "wl1251_debugfs.h"
 
-static void wl1251_disable_interrupts(struct wl1251 *wl)
+void wl1251_enable_interrupts(struct wl1251 *wl)
 {
-	disable_irq(wl->irq);
+	if (wl->enable_irq)
+		wl->enable_irq(wl->irq);
+}
+
+void wl1251_disable_interrupts(struct wl1251 *wl)
+{
+	if (wl->disable_irq)
+		wl->disable_irq(wl->irq);
 }
 
 static void wl1251_power_off(struct wl1251 *wl)
@@ -57,20 +64,6 @@ static void wl1251_power_on(struct wl1251 *wl)
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
@@ -1335,7 +1328,6 @@ int wl1251_free_hw(struct wl1251 *wl)
 
 	wl1251_debugfs_exit(wl);
 
-	free_irq(wl->irq, wl);
 	kfree(wl->target_mem_map);
 	kfree(wl->data_path);
 	kfree(wl->fw);
diff --git a/drivers/net/wireless/wl12xx/wl1251_sdio.c b/drivers/net/wireless/wl12xx/wl1251_sdio.c
index f1d9e76..66961e3 100644
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
diff --git a/drivers/net/wireless/wl12xx/wl1251_spi.c b/drivers/net/wireless/wl12xx/wl1251_spi.c
index 464b802..a835d56 100644
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
@@ -255,6 +268,9 @@ static int __devinit wl1251_spi_probe(struct spi_device *spi)
 
 	disable_irq(wl->irq);
 
+	wl->enable_irq = enable_irq;
+	wl->disable_irq = disable_irq;
+
 	ret = wl1251_init_ieee80211(wl);
 	if (ret)
 		goto out_irq;
@@ -274,6 +290,7 @@ static int __devexit wl1251_spi_remove(struct spi_device *spi)
 {
 	struct wl1251 *wl = dev_get_drvdata(&spi->dev);
 
+	free_irq(wl->irq, wl);
 	wl1251_free_hw(wl);
 
 	return 0;
-- 
1.6.2.5


-- 
Bob Copeland %% www.bobcopeland.com

