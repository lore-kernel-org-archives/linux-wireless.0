Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:57710 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788Ab1C2No2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 09:44:28 -0400
From: juuso.oikarinen@nokia.com
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] wl12xx: Handle duplicate calling of remove interface
Date: Tue, 29 Mar 2011 16:43:50 +0300
Message-Id: <1301406230-18630-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Because of the hardware recovery mechanism, its possible the
__wl1271_op_remove_interface is called twice. Currently, this leads to a
kernel crash even before a kernel WARNing can be issued.

Fix this.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/main.c   |   29 ++++++++++++++++++++++++++---
 drivers/net/wireless/wl12xx/wl12xx.h |    3 ++-
 2 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 85cb4da..b2bd353 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1304,6 +1304,16 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 		goto out;
 	}
 
+	/*
+	 * in some very corner case HW recovery scenarios its possible to
+	 * get here before __wl1271_op_remove_interface is complete, so
+	 * opt out if that is the case.
+	 */
+	if (test_bit(WL1271_FLAG_IF_INITIALIZED, &wl->flags)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
 		wl->bss_type = BSS_TYPE_STA_BSS;
@@ -1372,6 +1382,7 @@ power_off:
 
 	wl->vif = vif;
 	wl->state = WL1271_STATE_ON;
+	set_bit(WL1271_FLAG_IF_INITIALIZED, &wl->flags);
 	wl1271_info("firmware booted (%s)", wl->chip.fw_ver_str);
 
 	/* update hw/fw version info in wiphy struct */
@@ -1409,14 +1420,16 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl)
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 remove interface");
 
+	/* because of hardware recovery, we may get here twice */
+	if (wl->state != WL1271_STATE_ON)
+		return;
+
 	wl1271_info("down");
 
 	mutex_lock(&wl_list_mutex);
 	list_del(&wl->list);
 	mutex_unlock(&wl_list_mutex);
 
-	WARN_ON(wl->state != WL1271_STATE_ON);
-
 	/* enable dyn ps just in case (if left on due to fw crash etc) */
 	if (wl->bss_type == BSS_TYPE_STA_BSS)
 		ieee80211_enable_dyn_ps(wl->vif);
@@ -1429,6 +1442,10 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl)
 		ieee80211_scan_completed(wl->hw, true);
 	}
 
+	/*
+	 * this must be before the cancel_work calls below, so that the work
+	 * functions don't perform further work.
+	 */
 	wl->state = WL1271_STATE_OFF;
 
 	mutex_unlock(&wl->mutex);
@@ -1465,7 +1482,6 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl)
 	wl->time_offset = 0;
 	wl->session_counter = 0;
 	wl->rate_set = CONF_TX_RATE_MASK_BASIC;
-	wl->flags = 0;
 	wl->vif = NULL;
 	wl->filters = 0;
 	wl1271_free_ap_keys(wl);
@@ -1474,6 +1490,13 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl)
 	wl->ap_ps_map = 0;
 	wl->block_size = 0;
 
+	/*
+	 * this is performed after the cancel_work calls and the associated
+	 * mutex_lock, so that wl1271_op_add_interface does not accidentally
+	 * get executed before all these vars have been reset.
+	 */
+	wl->flags = 0;
+
 	for (i = 0; i < NUM_TX_QUEUES; i++)
 		wl->tx_blocks_freed[i] = 0;
 
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index b04481a..a38b130 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -353,7 +353,8 @@ enum wl12xx_flags {
 	WL1271_FLAG_PSPOLL_FAILURE,
 	WL1271_FLAG_STA_STATE_SENT,
 	WL1271_FLAG_FW_TX_BUSY,
-	WL1271_FLAG_AP_STARTED
+	WL1271_FLAG_AP_STARTED,
+	WL1271_FLAG_IF_INITIALIZED,
 };
 
 struct wl1271_link {
-- 
1.7.1

