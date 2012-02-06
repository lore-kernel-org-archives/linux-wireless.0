Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34898 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab2BFKoQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 05:44:16 -0500
Received: by mail-wi0-f174.google.com with SMTP id s10so4057049wic.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Feb 2012 02:44:15 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>, Gery Kahn <geryk@ti.com>
Subject: [PATCH 1/4] wl12xx: Use a dedicated fw for PLT
Date: Mon,  6 Feb 2012 12:47:54 +0200
Message-Id: <1328525277-25334-2-git-send-email-eliad@wizery.com> (sfid-20120206_114420_413138_7DDA565A)
In-Reply-To: <1328525277-25334-1-git-send-email-eliad@wizery.com>
References: <1328525277-25334-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A special PLT firmware is used for calibration.

Add multiple fw support by introducing a new fw_type member,
representing the currently saved fw (the actual fw state
can be determined by wl->state).

Signed-off-by: Gery Kahn <geryk@ti.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/debugfs.c |    2 +-
 drivers/net/wireless/wl12xx/main.c    |   53 +++++++++++++++++++++-----------
 drivers/net/wireless/wl12xx/rx.c      |    2 +-
 drivers/net/wireless/wl12xx/sdio.c    |    2 +
 drivers/net/wireless/wl12xx/spi.c     |    2 +
 drivers/net/wireless/wl12xx/wl12xx.h  |   11 ++++++-
 6 files changed, 51 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index 00dbe15..e1cf727 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -113,7 +113,7 @@ static void wl1271_debugfs_update_stats(struct wl1271 *wl)
 	if (ret < 0)
 		goto out;
 
-	if (wl->state == WL1271_STATE_ON &&
+	if (wl->state == WL1271_STATE_ON && !wl->plt &&
 	    time_after(jiffies, wl->stats.fw_stats_update +
 		       msecs_to_jiffies(WL1271_DEBUGFS_STATS_LIFETIME))) {
 		wl1271_acx_statistics(wl, wl->stats.fw_stats);
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 52efe7d..591a3d7 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -993,16 +993,29 @@ out:
 	return IRQ_HANDLED;
 }
 
-static int wl1271_fetch_firmware(struct wl1271 *wl)
+static int wl12xx_fetch_firmware(struct wl1271 *wl, bool plt)
 {
 	const struct firmware *fw;
 	const char *fw_name;
+	enum wl12xx_fw_type fw_type;
 	int ret;
 
-	if (wl->chip.id == CHIP_ID_1283_PG20)
-		fw_name = WL128X_FW_NAME;
-	else
-		fw_name	= WL127X_FW_NAME;
+	if (plt) {
+		fw_type = WL12XX_FW_TYPE_PLT;
+		if (wl->chip.id == CHIP_ID_1283_PG20)
+			fw_name = WL128X_PLT_FW_NAME;
+		else
+			fw_name	= WL127X_PLT_FW_NAME;
+	} else {
+		fw_type = WL12XX_FW_TYPE_NORMAL;
+		if (wl->chip.id == CHIP_ID_1283_PG20)
+			fw_name = WL128X_FW_NAME;
+		else
+			fw_name	= WL127X_FW_NAME;
+	}
+
+	if (wl->fw_type == fw_type)
+		return 0;
 
 	wl1271_debug(DEBUG_BOOT, "booting firmware %s", fw_name);
 
@@ -1021,6 +1034,7 @@ static int wl1271_fetch_firmware(struct wl1271 *wl)
 	}
 
 	vfree(wl->fw);
+	wl->fw_type = WL12XX_FW_TYPE_NONE;
 	wl->fw_len = fw->size;
 	wl->fw = vmalloc(wl->fw_len);
 
@@ -1032,7 +1046,7 @@ static int wl1271_fetch_firmware(struct wl1271 *wl)
 
 	memcpy(wl->fw, fw->data, wl->fw_len);
 	ret = 0;
-
+	wl->fw_type = fw_type;
 out:
 	release_firmware(fw);
 
@@ -1160,7 +1174,7 @@ static void wl1271_recovery_work(struct work_struct *work)
 
 	mutex_lock(&wl->mutex);
 
-	if (wl->state != WL1271_STATE_ON)
+	if (wl->state != WL1271_STATE_ON || wl->plt)
 		goto out_unlock;
 
 	/* Avoid a recursive recovery */
@@ -1240,7 +1254,7 @@ static int wl1271_setup(struct wl1271 *wl)
 	return 0;
 }
 
-static int wl1271_chip_wakeup(struct wl1271 *wl)
+static int wl12xx_chip_wakeup(struct wl1271 *wl, bool plt)
 {
 	struct wl1271_partition_set partition;
 	int ret = 0;
@@ -1315,11 +1329,9 @@ static int wl1271_chip_wakeup(struct wl1271 *wl)
 		goto out;
 	}
 
-	if (wl->fw == NULL) {
-		ret = wl1271_fetch_firmware(wl);
-		if (ret < 0)
-			goto out;
-	}
+	ret = wl12xx_fetch_firmware(wl, plt);
+	if (ret < 0)
+		goto out;
 
 	/* No NVS from netlink, try to get it from the filesystem */
 	if (wl->nvs == NULL) {
@@ -1351,7 +1363,7 @@ int wl1271_plt_start(struct wl1271 *wl)
 
 	while (retries) {
 		retries--;
-		ret = wl1271_chip_wakeup(wl);
+		ret = wl12xx_chip_wakeup(wl, true);
 		if (ret < 0)
 			goto power_off;
 
@@ -1363,7 +1375,8 @@ int wl1271_plt_start(struct wl1271 *wl)
 		if (ret < 0)
 			goto irq_disable;
 
-		wl->state = WL1271_STATE_PLT;
+		wl->plt = true;
+		wl->state = WL1271_STATE_ON;
 		wl1271_notice("firmware booted in PLT mode (%s)",
 			      wl->chip.fw_ver_str);
 
@@ -1405,7 +1418,7 @@ static int __wl1271_plt_stop(struct wl1271 *wl)
 
 	wl1271_notice("power down");
 
-	if (wl->state != WL1271_STATE_PLT) {
+	if (!wl->plt) {
 		wl1271_error("cannot power down because not in PLT "
 			     "state: %d", wl->state);
 		ret = -EBUSY;
@@ -1415,6 +1428,7 @@ static int __wl1271_plt_stop(struct wl1271 *wl)
 	wl1271_power_off(wl);
 
 	wl->state = WL1271_STATE_OFF;
+	wl->plt = false;
 	wl->rx_counter = 0;
 
 	mutex_unlock(&wl->mutex);
@@ -1972,7 +1986,7 @@ static bool wl12xx_init_fw(struct wl1271 *wl)
 
 	while (retries) {
 		retries--;
-		ret = wl1271_chip_wakeup(wl);
+		ret = wl12xx_chip_wakeup(wl, false);
 		if (ret < 0)
 			goto power_off;
 
@@ -2072,6 +2086,7 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 		goto out;
 	}
 
+
 	ret = wl12xx_init_vif_data(wl, vif);
 	if (ret < 0)
 		goto out;
@@ -4870,7 +4885,7 @@ static int wl1271_register_hw(struct wl1271 *wl)
 
 static void wl1271_unregister_hw(struct wl1271 *wl)
 {
-	if (wl->state == WL1271_STATE_PLT)
+	if (wl->plt)
 		__wl1271_plt_stop(wl);
 
 	unregister_netdevice_notifier(&wl1271_dev_notifier);
@@ -5049,6 +5064,7 @@ static struct ieee80211_hw *wl1271_alloc_hw(void)
 	spin_lock_init(&wl->wl_lock);
 
 	wl->state = WL1271_STATE_OFF;
+	wl->fw_type = WL12XX_FW_TYPE_NONE;
 	mutex_init(&wl->mutex);
 
 	/* Apply default driver configuration. */
@@ -5116,6 +5132,7 @@ static int wl1271_free_hw(struct wl1271 *wl)
 
 	vfree(wl->fw);
 	wl->fw = NULL;
+	wl->fw_type = WL12XX_FW_TYPE_NONE;
 	kfree(wl->nvs);
 	wl->nvs = NULL;
 
diff --git a/drivers/net/wireless/wl12xx/rx.c b/drivers/net/wireless/wl12xx/rx.c
index 4fbd2a7..cfa6071 100644
--- a/drivers/net/wireless/wl12xx/rx.c
+++ b/drivers/net/wireless/wl12xx/rx.c
@@ -113,7 +113,7 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length,
 	 * In PLT mode we seem to get frames and mac80211 warns about them,
 	 * workaround this by not retrieving them at all.
 	 */
-	if (unlikely(wl->state == WL1271_STATE_PLT))
+	if (unlikely(wl->plt))
 		return -EINVAL;
 
 	/* the data read starts with the descriptor */
diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index ce3b9a9..1c0264c 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -372,3 +372,5 @@ MODULE_AUTHOR("Luciano Coelho <coelho@ti.com>");
 MODULE_AUTHOR("Juuso Oikarinen <juuso.oikarinen@nokia.com>");
 MODULE_FIRMWARE(WL127X_FW_NAME);
 MODULE_FIRMWARE(WL128X_FW_NAME);
+MODULE_FIRMWARE(WL127X_PLT_FW_NAME);
+MODULE_FIRMWARE(WL128X_PLT_FW_NAME);
diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
index 92caa7c..5c2d4a0 100644
--- a/drivers/net/wireless/wl12xx/spi.c
+++ b/drivers/net/wireless/wl12xx/spi.c
@@ -435,4 +435,6 @@ MODULE_AUTHOR("Luciano Coelho <coelho@ti.com>");
 MODULE_AUTHOR("Juuso Oikarinen <juuso.oikarinen@nokia.com>");
 MODULE_FIRMWARE(WL127X_FW_NAME);
 MODULE_FIRMWARE(WL128X_FW_NAME);
+MODULE_FIRMWARE(WL127X_PLT_FW_NAME);
+MODULE_FIRMWARE(WL128X_PLT_FW_NAME);
 MODULE_ALIAS("spi:wl1271");
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 70b15b5..348d1f6 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -37,6 +37,8 @@
 
 #define WL127X_FW_NAME "ti-connectivity/wl127x-fw-4-sr.bin"
 #define WL128X_FW_NAME "ti-connectivity/wl128x-fw-4-sr.bin"
+#define WL127X_PLT_FW_NAME "ti-connectivity/wl127x-fw-4-plt.bin"
+#define WL128X_PLT_FW_NAME "ti-connectivity/wl128x-fw-4-plt.bin"
 
 /*
  * wl127x and wl128x are using the same NVS file name. However, the
@@ -90,7 +92,12 @@
 enum wl1271_state {
 	WL1271_STATE_OFF,
 	WL1271_STATE_ON,
-	WL1271_STATE_PLT,
+};
+
+enum wl12xx_fw_type {
+	WL12XX_FW_TYPE_NONE,
+	WL12XX_FW_TYPE_NORMAL,
+	WL12XX_FW_TYPE_PLT,
 };
 
 enum wl1271_partition_type {
@@ -294,6 +301,8 @@ struct wl1271 {
 	spinlock_t wl_lock;
 
 	enum wl1271_state state;
+	enum wl12xx_fw_type fw_type;
+	bool plt;
 	struct mutex mutex;
 
 	unsigned long flags;
-- 
1.7.6.401.g6a319

