Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:36111 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933734AbZJMJt6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 05:49:58 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 08/22] wl1271: Fix IRQ enable handling on FW init failure
Date: Tue, 13 Oct 2009 12:47:45 +0300
Message-Id: <1255427279-1224-9-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
References: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Disable IRQ's after FW initialization failure - originally this was not
done in all cases, and it resulted in a kernel warning if firmware
initialization was tried again without reboot.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_boot.c |    6 ++--
 drivers/net/wireless/wl12xx/wl1271_init.c |    4 +-
 drivers/net/wireless/wl12xx/wl1271_main.c |   42 ++++++++++++++++++++--------
 3 files changed, 35 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.c b/drivers/net/wireless/wl12xx/wl1271_boot.c
index a27601d..b8a37a8 100644
--- a/drivers/net/wireless/wl12xx/wl1271_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
@@ -400,9 +400,6 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 	 * ready to receive event from the command mailbox
 	 */
 
-	/* enable gpio interrupts */
-	wl1271_boot_enable_interrupts(wl);
-
 	/* unmask required mbox events  */
 	wl->event_mask = BSS_LOSE_EVENT_ID |
 		SCAN_COMPLETE_EVENT_ID;
@@ -540,6 +537,9 @@ int wl1271_boot(struct wl1271 *wl)
 	if (ret < 0)
 		goto out;
 
+	/* Enable firmware interrupts now */
+	wl1271_boot_enable_interrupts(wl);
+
 	/* set the wl1271 default filters */
 	wl->rx_config = WL1271_DEFAULT_RX_CONFIG;
 	wl->rx_filter = WL1271_DEFAULT_RX_FILTER;
diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c b/drivers/net/wireless/wl12xx/wl1271_init.c
index 5c2cf1e..6f21eea 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.c
+++ b/drivers/net/wireless/wl12xx/wl1271_init.c
@@ -315,8 +315,8 @@ int wl1271_hw_init(struct wl1271 *wl)
 
 	/* RX config */
 	ret = wl1271_init_rx_config(wl,
-				       RX_CFG_PROMISCUOUS | RX_CFG_TSF,
-				       RX_FILTER_OPTION_DEF);
+				    RX_CFG_PROMISCUOUS | RX_CFG_TSF,
+				    RX_FILTER_OPTION_DEF);
 	/* RX_CONFIG_OPTION_ANY_DST_ANY_BSS,
 	   RX_FILTER_OPTION_FILTER_ALL); */
 	if (ret < 0)
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index eba38df..7f1093c 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -625,7 +625,7 @@ static int wl1271_chip_wakeup(struct wl1271 *wl)
 
 		ret = wl1271_setup(wl);
 		if (ret < 0)
-			goto out;
+			goto out_power_off;
 		break;
 	case CHIP_ID_1271_PG20:
 		wl1271_debug(DEBUG_BOOT, "chip id 0x%x (1271 PG20)",
@@ -633,27 +633,32 @@ static int wl1271_chip_wakeup(struct wl1271 *wl)
 
 		ret = wl1271_setup(wl);
 		if (ret < 0)
-			goto out;
+			goto out_power_off;
 		break;
 	default:
 		wl1271_error("unsupported chip id: 0x%x", wl->chip.id);
 		ret = -ENODEV;
-		goto out;
+		goto out_power_off;
 	}
 
 	if (wl->fw == NULL) {
 		ret = wl1271_fetch_firmware(wl);
 		if (ret < 0)
-			goto out;
+			goto out_power_off;
 	}
 
 	/* No NVS from netlink, try to get it from the filesystem */
 	if (wl->nvs == NULL) {
 		ret = wl1271_fetch_nvs(wl);
 		if (ret < 0)
-			goto out;
+			goto out_power_off;
 	}
 
+	goto out;
+
+out_power_off:
+	wl1271_power_off(wl);
+
 out:
 	return ret;
 }
@@ -749,13 +754,21 @@ int wl1271_plt_start(struct wl1271 *wl)
 
 	ret = wl1271_boot(wl);
 	if (ret < 0)
-		goto out;
+		goto out_power_off;
 
 	wl1271_notice("firmware booted in PLT mode (%s)", wl->chip.fw_ver);
 
 	ret = wl1271_plt_init(wl);
 	if (ret < 0)
-		goto out;
+		goto out_irq_disable;
+
+	goto out;
+
+out_irq_disable:
+	wl1271_disable_interrupts(wl);
+
+out_power_off:
+	wl1271_power_off(wl);
 
 out:
 	mutex_unlock(&wl->mutex);
@@ -843,20 +856,25 @@ static int wl1271_op_start(struct ieee80211_hw *hw)
 
 	ret = wl1271_boot(wl);
 	if (ret < 0)
-		goto out;
+		goto out_power_off;
 
 	ret = wl1271_hw_init(wl);
 	if (ret < 0)
-		goto out;
+		goto out_irq_disable;
 
 	wl->state = WL1271_STATE_ON;
 
 	wl1271_info("firmware booted (%s)", wl->chip.fw_ver);
 
-out:
-	if (ret < 0)
-		wl1271_power_off(wl);
+	goto out;
+
+out_irq_disable:
+	wl1271_disable_interrupts(wl);
 
+out_power_off:
+	wl1271_power_off(wl);
+
+out:
 	mutex_unlock(&wl->mutex);
 
 	return ret;
-- 
1.5.6.5

