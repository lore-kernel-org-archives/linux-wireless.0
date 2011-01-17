Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59483 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab1AQRUd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 12:20:33 -0500
Received: by wyb28 with SMTP id 28so5317387wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jan 2011 09:18:52 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: free firmware after booting the chip
Date: Mon, 17 Jan 2011 19:17:55 +0200
Message-Id: <1295284675-30029-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no need to save the fw in memory after it has been
uploaded to the chip.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 8a35491..e1944b1 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -691,7 +691,6 @@ static int wl1271_fetch_firmware(struct wl1271 *wl)
 		goto out;
 	}
 
-	vfree(wl->fw);
 	wl->fw_len = fw->size;
 	wl->fw = vmalloc(wl->fw_len);
 
@@ -891,7 +890,7 @@ int wl1271_plt_start(struct wl1271 *wl)
 		wl->state = WL1271_STATE_PLT;
 		wl1271_notice("firmware booted in PLT mode (%s)",
 			      wl->chip.fw_ver);
-		goto out;
+		goto out_free_fw;
 
 irq_disable:
 		wl1271_disable_interrupts(wl);
@@ -911,6 +910,9 @@ power_off:
 
 	wl1271_error("firmware boot in PLT mode failed despite %d retries",
 		     WL1271_BOOT_RETRIES);
+out_free_fw:
+	vfree(wl->fw);
+	wl->fw = NULL;
 out:
 	mutex_unlock(&wl->mutex);
 
@@ -1126,7 +1128,7 @@ power_off:
 	if (!booted) {
 		wl1271_error("firmware boot failed despite %d retries",
 			     WL1271_BOOT_RETRIES);
-		goto out;
+		goto out_free_fw;
 	}
 
 	wl->vif = vif;
@@ -1148,6 +1150,9 @@ power_off:
 	wl1271_debug(DEBUG_MAC80211, "11a is %ssupported",
 		     wl->enable_11a ? "" : "not ");
 
+out_free_fw:
+	vfree(wl->fw);
+	wl->fw = NULL;
 out:
 	mutex_unlock(&wl->mutex);
 
@@ -3300,8 +3305,6 @@ int wl1271_free_hw(struct wl1271 *wl)
 
 	wl1271_debugfs_exit(wl);
 
-	vfree(wl->fw);
-	wl->fw = NULL;
 	kfree(wl->nvs);
 	wl->nvs = NULL;
 
-- 
1.7.0.4

