Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:40185 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab0JKLg7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 07:36:59 -0400
From: Gery Kahn <geryk@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>
Subject: [PATCH] Ability to set reference clock as module parameter
Date: Mon, 11 Oct 2010 13:36:52 +0200
Message-Id: <1286797012-22669-1-git-send-email-geryk@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Gery Kahn <geryk@ti.com>
---
 arch/arm/mach-omap2/board-zoom-peripherals.c |    2 +-
 drivers/net/wireless/wl12xx/wl1271.h         |    3 ++-
 drivers/net/wireless/wl12xx/wl1271_debugfs.c |    5 ++++-
 drivers/net/wireless/wl12xx/wl1271_main.c    |    3 +++
 drivers/net/wireless/wl12xx/wl1271_sdio.c    |    9 ++++++++-
 5 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-omap2/board-zoom-peripherals.c b/arch/arm/mach-omap2/board-zoom-peripherals.c
index 287ffcb..d1a8870 100644
--- a/arch/arm/mach-omap2/board-zoom-peripherals.c
+++ b/arch/arm/mach-omap2/board-zoom-peripherals.c
@@ -190,7 +190,7 @@ static struct platform_device omap_vwlan_device = {
 struct wl12xx_platform_data omap_zoom_wlan_data __initdata = {
 	.irq = OMAP_GPIO_IRQ(OMAP_ZOOM_WLAN_IRQ_GPIO),
 	/* ZOOM ref clock is 26 MHz */
-	.board_ref_clock = 1,
+	.board_ref_clock = WL12XX_REFCLOCK_26,
 };
 
 static struct omap2_hsmmc_info mmc[] __initdata = {
diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 9b8ba82..bb94b95 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -60,7 +60,7 @@ enum {
 	DEBUG_ALL	= ~0,
 };
 
-#define DEBUG_LEVEL (DEBUG_NONE)
+#define DEBUG_LEVEL (DEBUG_ACX)
 
 #define DEBUG_DUMP_LIMIT 1024
 
@@ -273,6 +273,7 @@ struct wl1271_debugfs {
 
 	struct dentry *retry_count;
 	struct dentry *excessive_retries;
+	struct dentry *ref_clk;
 	struct dentry *gpio_power;
 };
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_debugfs.c b/drivers/net/wireless/wl12xx/wl1271_debugfs.c
index c239ef4..db67acc 100644
--- a/drivers/net/wireless/wl12xx/wl1271_debugfs.c
+++ b/drivers/net/wireless/wl12xx/wl1271_debugfs.c
@@ -35,7 +35,6 @@
 #define WL1271_DEBUGFS_STATS_LIFETIME 1000
 
 /* debugfs macros idea from mac80211 */
-
 #define DEBUGFS_READONLY_FILE(name, buflen, fmt, value...)		\
 static ssize_t name## _read(struct file *file, char __user *userbuf,	\
 			    size_t count, loff_t *ppos)			\
@@ -219,6 +218,8 @@ DEBUGFS_FWSTATS_FILE(rxpipe, tx_xfr_host_int_trig_rx_data, 20, "%u");
 DEBUGFS_READONLY_FILE(retry_count, 20, "%u", wl->stats.retry_count);
 DEBUGFS_READONLY_FILE(excessive_retries, 20, "%u",
 		      wl->stats.excessive_retries);
+DEBUGFS_READONLY_FILE(ref_clk, 3, "%d", wl->ref_clock);
+
 
 static ssize_t tx_queue_len_read(struct file *file, char __user *userbuf,
 				 size_t count, loff_t *ppos)
@@ -390,6 +391,7 @@ static void wl1271_debugfs_delete_files(struct wl1271 *wl)
 	DEBUGFS_DEL(tx_queue_len);
 	DEBUGFS_DEL(retry_count);
 	DEBUGFS_DEL(excessive_retries);
+	DEBUGFS_DEL(ref_clk);
 
 	DEBUGFS_DEL(gpio_power);
 }
@@ -492,6 +494,7 @@ static int wl1271_debugfs_add_files(struct wl1271 *wl)
 	DEBUGFS_ADD(tx_queue_len, wl->debugfs.rootdir);
 	DEBUGFS_ADD(retry_count, wl->debugfs.rootdir);
 	DEBUGFS_ADD(excessive_retries, wl->debugfs.rootdir);
+	DEBUGFS_ADD(ref_clk, wl->debugfs.rootdir);
 
 	DEBUGFS_ADD(gpio_power, wl->debugfs.rootdir);
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index adcbffb..c1a111e 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -946,6 +946,9 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 
 	memcpy(wl->mac_addr, vif->addr, ETH_ALEN);
 
+	/* update MAC address in wiphy struct */
+	memcpy(wiphy->perm_addr, vif->addr, ETH_ALEN);
+
 	if (wl->state != WL1271_STATE_OFF) {
 		wl1271_error("cannot start because not in off state: %d",
 			     wl->state);
diff --git a/drivers/net/wireless/wl12xx/wl1271_sdio.c b/drivers/net/wireless/wl12xx/wl1271_sdio.c
index e359cdd..697716e 100644
--- a/drivers/net/wireless/wl12xx/wl1271_sdio.c
+++ b/drivers/net/wireless/wl12xx/wl1271_sdio.c
@@ -44,6 +44,10 @@
 #define SDIO_DEVICE_ID_TI_WL1271	0x4076
 #endif
 
+static int modparam_ref_clk;
+module_param_named(ref_clk, modparam_ref_clk, int, 0444);
+MODULE_PARM_DESC(ref_clk, "Set reference clock");
+
 static const struct sdio_device_id wl1271_devices[] = {
 	{ SDIO_DEVICE(SDIO_VENDOR_ID_TI, SDIO_DEVICE_ID_TI_WL1271) },
 	{}
@@ -237,7 +241,10 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 	}
 
 	wl->irq = wlan_data->irq;
-	wl->ref_clock = wlan_data->board_ref_clock;
+	if (modparam_ref_clk)
+		wl->ref_clock =  modparam_ref_clk;
+	else
+		wl->ref_clock = wlan_data->board_ref_clock;
 
 	ret = request_irq(wl->irq, wl1271_irq, 0, DRIVER_NAME, wl);
 	if (ret < 0) {
-- 
1.7.0.4

