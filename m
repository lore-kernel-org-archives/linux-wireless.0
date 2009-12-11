Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:50887 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933693AbZLKLmh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 06:42:37 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 22/31] wl1271: Implement chipset boot retry
Date: Fri, 11 Dec 2009 13:41:13 +0200
Message-Id: <1260531682-4695-23-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1260531682-4695-1-git-send-email-luciano.coelho@nokia.com>
References: <1260531682-4695-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

The wl1271 has a hardware bug which causes it to randomly (very infrequently)
to fail powering up properly. This patch implements retry for the chipset boot
sequence, to work around the hardware problem.

Fixes: NB#127565 - wl1271: cannot read chip ID after multiple on/off cycles

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |  130 +++++++++++++++++------------
 1 files changed, 77 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 47f6e17..9eba54f 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -47,6 +47,8 @@
 #include "wl1271_cmd.h"
 #include "wl1271_boot.h"
 
+#define WL1271_BOOT_RETRIES 3
+
 static struct conf_drv_settings default_conf = {
 	.sg = {
 		.per_threshold               = 7500,
@@ -645,7 +647,7 @@ static int wl1271_chip_wakeup(struct wl1271 *wl)
 
 		ret = wl1271_setup(wl);
 		if (ret < 0)
-			goto out_power_off;
+			goto out;
 		break;
 	case CHIP_ID_1271_PG20:
 		wl1271_debug(DEBUG_BOOT, "chip id 0x%x (1271 PG20)",
@@ -653,38 +655,34 @@ static int wl1271_chip_wakeup(struct wl1271 *wl)
 
 		ret = wl1271_setup(wl);
 		if (ret < 0)
-			goto out_power_off;
+			goto out;
 		break;
 	default:
-		wl1271_error("unsupported chip id: 0x%x", wl->chip.id);
+		wl1271_warning("unsupported chip id: 0x%x", wl->chip.id);
 		ret = -ENODEV;
-		goto out_power_off;
+		goto out;
 	}
 
 	if (wl->fw == NULL) {
 		ret = wl1271_fetch_firmware(wl);
 		if (ret < 0)
-			goto out_power_off;
+			goto out;
 	}
 
 	/* No NVS from netlink, try to get it from the filesystem */
 	if (wl->nvs == NULL) {
 		ret = wl1271_fetch_nvs(wl);
 		if (ret < 0)
-			goto out_power_off;
+			goto out;
 	}
 
-	goto out;
-
-out_power_off:
-	wl1271_power_off(wl);
-
 out:
 	return ret;
 }
 
 int wl1271_plt_start(struct wl1271 *wl)
 {
+	int retries = WL1271_BOOT_RETRIES;
 	int ret;
 
 	mutex_lock(&wl->mutex);
@@ -698,35 +696,48 @@ int wl1271_plt_start(struct wl1271 *wl)
 		goto out;
 	}
 
-	wl->state = WL1271_STATE_PLT;
-
-	ret = wl1271_chip_wakeup(wl);
-	if (ret < 0)
-		goto out;
-
-	ret = wl1271_boot(wl);
-	if (ret < 0)
-		goto out_power_off;
-
-	wl1271_notice("firmware booted in PLT mode (%s)", wl->chip.fw_ver);
+	while (retries) {
+		retries--;
+		ret = wl1271_chip_wakeup(wl);
+		if (ret < 0)
+			goto power_off;
 
-	ret = wl1271_plt_init(wl);
-	if (ret < 0)
-		goto out_irq_disable;
+		ret = wl1271_boot(wl);
+		if (ret < 0)
+			goto power_off;
 
-	/* Make sure power saving is disabled */
-	ret = wl1271_acx_sleep_auth(wl, WL1271_PSM_CAM);
-	if (ret < 0)
-		goto out_irq_disable;
+		ret = wl1271_plt_init(wl);
+		if (ret < 0)
+			goto irq_disable;
 
-	goto out;
+		/* Make sure power saving is disabled */
+		ret = wl1271_acx_sleep_auth(wl, WL1271_PSM_CAM);
+		if (ret < 0)
+			goto irq_disable;
 
-out_irq_disable:
-	wl1271_disable_interrupts(wl);
+		wl->state = WL1271_STATE_PLT;
+		wl1271_notice("firmware booted in PLT mode (%s)",
+			      wl->chip.fw_ver);
+		goto out;
 
-out_power_off:
-	wl1271_power_off(wl);
+irq_disable:
+		wl1271_disable_interrupts(wl);
+		mutex_unlock(&wl->mutex);
+		/* Unlocking the mutex in the middle of handling is
+		   inherently unsafe. In this case we deem it safe to do,
+		   because we need to let any possibly pending IRQ out of
+		   the system (and while we are WL1271_STATE_OFF the IRQ
+		   work function will not do anything.) Also, any other
+		   possible concurrent operations will fail due to the
+		   current state, hence the wl1271 struct should be safe. */
+		cancel_work_sync(&wl->irq_work);
+		mutex_lock(&wl->mutex);
+power_off:
+		wl1271_power_off(wl);
+	}
 
+	wl1271_error("firmware boot in PLT mode failed despite %d retries",
+		     WL1271_BOOT_RETRIES);
 out:
 	mutex_unlock(&wl->mutex);
 
@@ -882,6 +893,7 @@ static struct notifier_block wl1271_dev_notifier = {
 static int wl1271_op_start(struct ieee80211_hw *hw)
 {
 	struct wl1271 *wl = hw->priv;
+	int retries = WL1271_BOOT_RETRIES;
 	int ret = 0;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 start");
@@ -895,30 +907,42 @@ static int wl1271_op_start(struct ieee80211_hw *hw)
 		goto out;
 	}
 
-	ret = wl1271_chip_wakeup(wl);
-	if (ret < 0)
-		goto out;
-
-	ret = wl1271_boot(wl);
-	if (ret < 0)
-		goto out_power_off;
-
-	ret = wl1271_hw_init(wl);
-	if (ret < 0)
-		goto out_irq_disable;
-
-	wl->state = WL1271_STATE_ON;
+	while (retries) {
+		retries--;
+		ret = wl1271_chip_wakeup(wl);
+		if (ret < 0)
+			goto power_off;
 
-	wl1271_info("firmware booted (%s)", wl->chip.fw_ver);
+		ret = wl1271_boot(wl);
+		if (ret < 0)
+			goto power_off;
 
-	goto out;
+		ret = wl1271_hw_init(wl);
+		if (ret < 0)
+			goto irq_disable;
 
-out_irq_disable:
-	wl1271_disable_interrupts(wl);
+		wl->state = WL1271_STATE_ON;
+		wl1271_info("firmware booted (%s)", wl->chip.fw_ver);
+		goto out;
 
-out_power_off:
-	wl1271_power_off(wl);
+irq_disable:
+		wl1271_disable_interrupts(wl);
+		mutex_unlock(&wl->mutex);
+		/* Unlocking the mutex in the middle of handling is
+		   inherently unsafe. In this case we deem it safe to do,
+		   because we need to let any possibly pending IRQ out of
+		   the system (and while we are WL1271_STATE_OFF the IRQ
+		   work function will not do anything.) Also, any other
+		   possible concurrent operations will fail due to the
+		   current state, hence the wl1271 struct should be safe. */
+		cancel_work_sync(&wl->irq_work);
+		mutex_lock(&wl->mutex);
+power_off:
+		wl1271_power_off(wl);
+	}
 
+	wl1271_error("firmware boot failed despite %d retries",
+		     WL1271_BOOT_RETRIES);
 out:
 	mutex_unlock(&wl->mutex);
 
-- 
1.6.3.3

