Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:17013 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932875Ab0I0Ii7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 04:38:59 -0400
Received: from esebh105.NOE.Nokia.com (esebh105.ntc.nokia.com [172.21.138.211])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o8R8cJPw025709
	for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 03:38:58 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 21/25] wl1271: Separate interface removal to another function
Date: Mon, 27 Sep 2010 11:37:45 +0300
Message-Id: <1285576669-8070-22-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
References: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Do this so the interface removal can be triggered from an upcoming hardware
failure recovery mechanism.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |   17 +++++++++++------
 drivers/net/wireless/wl12xx/wl1271_scan.c |    6 ++++++
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 2c03cb1..00da982 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -960,15 +960,10 @@ out:
 	return ret;
 }
 
-static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
-				       struct ieee80211_vif *vif)
+static void __wl1271_op_remove_interface(struct wl1271 *wl)
 {
-	struct wl1271 *wl = hw->priv;
 	int i;
 
-	cancel_work_sync(&wl->scan_complete_work);
-
-	mutex_lock(&wl->mutex);
 	wl1271_debug(DEBUG_MAC80211, "mac80211 remove interface");
 
 	wl1271_info("down");
@@ -994,6 +989,7 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 
 	mutex_unlock(&wl->mutex);
 
+	cancel_work_sync(&wl->scan_complete_work);
 	cancel_work_sync(&wl->irq_work);
 	cancel_work_sync(&wl->tx_work);
 	cancel_delayed_work_sync(&wl->pspoll_work);
@@ -1039,7 +1035,16 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 	wl->tx_res_if = NULL;
 	kfree(wl->target_mem_map);
 	wl->target_mem_map = NULL;
+}
 
+static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
+				       struct ieee80211_vif *vif)
+{
+	struct wl1271 *wl = hw->priv;
+
+	mutex_lock(&wl->mutex);
+	WARN_ON(wl->vif != vif);
+	__wl1271_op_remove_interface(wl);
 	mutex_unlock(&wl->mutex);
 }
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_scan.c b/drivers/net/wireless/wl12xx/wl1271_scan.c
index 9f1da82..20caceb 100644
--- a/drivers/net/wireless/wl12xx/wl1271_scan.c
+++ b/drivers/net/wireless/wl12xx/wl1271_scan.c
@@ -36,6 +36,12 @@ void wl1271_scan_complete_work(struct work_struct *work)
 	wl1271_debug(DEBUG_SCAN, "Scanning complete");
 
 	mutex_lock(&wl->mutex);
+
+	if (wl->scan.state == WL1271_SCAN_STATE_IDLE) {
+		mutex_unlock(&wl->mutex);
+		return;
+	}
+
 	wl->scan.state = WL1271_SCAN_STATE_IDLE;
 	kfree(wl->scan.scanned_ch);
 	wl->scan.scanned_ch = NULL;
-- 
1.6.3.3

