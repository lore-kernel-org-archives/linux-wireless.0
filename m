Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-da01.ext.nokia.com ([147.243.128.24]:32163 "EHLO
	mgw-da01.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab1ANLsy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jan 2011 06:48:54 -0500
From: juuso.oikarinen@nokia.com
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] wl12xx: Cleanup PLT mode when module is removed
Date: Fri, 14 Jan 2011 13:48:46 +0200
Message-Id: <1295005726-10323-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

PLT mode start/stop is controlled from userspace. When removing module, the
PLT mode state is however not checked, and not cleared. There is the possibility
of some unwanted state to left linger and there is even the possiblity of a
kernel crash if for instance IRQ work is running when the module is removed.

Fix this by stopping PLT mode on module removal, if still running.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/main.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 9076555..863e660 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -917,12 +917,10 @@ out:
 	return ret;
 }
 
-int wl1271_plt_stop(struct wl1271 *wl)
+int __wl1271_plt_stop(struct wl1271 *wl)
 {
 	int ret = 0;
 
-	mutex_lock(&wl->mutex);
-
 	wl1271_notice("power down");
 
 	if (wl->state != WL1271_STATE_PLT) {
@@ -938,12 +936,21 @@ int wl1271_plt_stop(struct wl1271 *wl)
 	wl->state = WL1271_STATE_OFF;
 	wl->rx_counter = 0;
 
-out:
 	mutex_unlock(&wl->mutex);
-
 	cancel_work_sync(&wl->irq_work);
 	cancel_work_sync(&wl->recovery_work);
+	mutex_lock(&wl->mutex);
+out:
+	return ret;
+}
+
+int wl1271_plt_stop(struct wl1271 *wl)
+{
+	int ret;
 
+	mutex_lock(&wl->mutex);
+	ret = __wl1271_plt_stop(wl);
+	mutex_unlock(&wl->mutex);
 	return ret;
 }
 
@@ -3109,6 +3116,9 @@ EXPORT_SYMBOL_GPL(wl1271_register_hw);
 
 void wl1271_unregister_hw(struct wl1271 *wl)
 {
+	if (wl->state == WL1271_STATE_PLT)
+		__wl1271_plt_stop(wl);
+
 	unregister_netdevice_notifier(&wl1271_dev_notifier);
 	ieee80211_unregister_hw(wl->hw);
 	wl->mac80211_registered = false;
-- 
1.7.1

