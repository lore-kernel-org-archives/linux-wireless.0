Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59447 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab2BFKoS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 05:44:18 -0500
Received: by wgbdt10 with SMTP id dt10so6076080wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 06 Feb 2012 02:44:17 -0800 (PST)
MIME-Version: 1.0
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/4] wl12xx: dynamically change fw according to number of active roles
Date: Mon,  6 Feb 2012 12:47:55 +0200
Message-Id: <1328525277-25334-3-git-send-email-eliad@wizery.com> (sfid-20120206_114420_987742_E8C5897E)
In-Reply-To: <1328525277-25334-1-git-send-email-eliad@wizery.com>
References: <1328525277-25334-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wl12xx uses different fw for single-role and multi-role
scenarios (due to lack of space, some of the fw advanced
features are disabled in the multi-role fw).

Add checks on add_interfae and remove_interface in order
to determine whether a fw switch is needed (and initiate
recovery in this case).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |  115 +++++++++++++++++++++++++++++++--
 drivers/net/wireless/wl12xx/sdio.c   |    6 +-
 drivers/net/wireless/wl12xx/spi.c    |    6 +-
 drivers/net/wireless/wl12xx/wl12xx.h |   11 +++-
 4 files changed, 125 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 591a3d7..a3c464f 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -993,6 +993,35 @@ out:
 	return IRQ_HANDLED;
 }
 
+struct vif_counter_data {
+	u8 counter;
+
+	struct ieee80211_vif *cur_vif;
+	bool cur_vif_running;
+};
+
+static void wl12xx_vif_count_iter(void *data, u8 *mac,
+				  struct ieee80211_vif *vif)
+{
+	struct vif_counter_data *counter = data;
+
+	counter->counter++;
+	if (counter->cur_vif == vif)
+		counter->cur_vif_running = true;
+}
+
+/* caller must not hold wl->mutex, as it might deadlock */
+static void wl12xx_get_vif_count(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *cur_vif,
+			       struct vif_counter_data *data)
+{
+	memset(data, 0, sizeof(*data));
+	data->cur_vif = cur_vif;
+
+	ieee80211_iterate_active_interfaces(hw,
+					    wl12xx_vif_count_iter, data);
+}
+
 static int wl12xx_fetch_firmware(struct wl1271 *wl, bool plt)
 {
 	const struct firmware *fw;
@@ -1007,11 +1036,23 @@ static int wl12xx_fetch_firmware(struct wl1271 *wl, bool plt)
 		else
 			fw_name	= WL127X_PLT_FW_NAME;
 	} else {
-		fw_type = WL12XX_FW_TYPE_NORMAL;
-		if (wl->chip.id == CHIP_ID_1283_PG20)
-			fw_name = WL128X_FW_NAME;
-		else
-			fw_name	= WL127X_FW_NAME;
+		/*
+		 * we can't call wl12xx_get_vif_count() here because
+		 * wl->mutex is taken, so use the cached last_vif_count value
+		 */
+		if (wl->last_vif_count > 1) {
+			fw_type = WL12XX_FW_TYPE_MULTI;
+			if (wl->chip.id == CHIP_ID_1283_PG20)
+				fw_name = WL128X_FW_NAME_MULTI;
+			else
+				fw_name = WL127X_FW_NAME_MULTI;
+		} else {
+			fw_type = WL12XX_FW_TYPE_NORMAL;
+			if (wl->chip.id == CHIP_ID_1283_PG20)
+				fw_name = WL128X_FW_NAME_SINGLE;
+			else
+				fw_name = WL127X_FW_NAME_SINGLE;
+		}
 	}
 
 	if (wl->fw_type == fw_type)
@@ -2051,11 +2092,47 @@ static bool wl12xx_dev_role_started(struct wl12xx_vif *wlvif)
 	return wlvif->dev_hlid != WL12XX_INVALID_LINK_ID;
 }
 
+/*
+ * Check whether a fw switch (i.e. moving from one loaded
+ * fw to another) is needed. This function is also responsible
+ * for updating wl->last_vif_count, so it must be called before
+ * loading a non-plt fw (so the correct fw (single-role/multi-role)
+ * will be used).
+ */
+static bool wl12xx_need_fw_change(struct wl1271 *wl,
+				  struct vif_counter_data vif_counter_data,
+				  bool add)
+{
+	enum wl12xx_fw_type current_fw = wl->fw_type;
+	u8 vif_count = vif_counter_data.counter;
+
+	if (test_bit(WL1271_FLAG_VIF_CHANGE_IN_PROGRESS, &wl->flags))
+		return false;
+
+	/* increase the vif count if this is a new vif */
+	if (add && !vif_counter_data.cur_vif_running)
+		vif_count++;
+
+	wl->last_vif_count = vif_count;
+
+	/* no need for fw change if the device is OFF */
+	if (wl->state == WL1271_STATE_OFF)
+		return false;
+
+	if (vif_count > 1 && current_fw == WL12XX_FW_TYPE_NORMAL)
+		return true;
+	if (vif_count <= 1 && current_fw == WL12XX_FW_TYPE_MULTI)
+		return true;
+
+	return false;
+}
+
 static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif)
 {
 	struct wl1271 *wl = hw->priv;
 	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
+	struct vif_counter_data vif_count;
 	int ret = 0;
 	u8 role_type;
 	bool booted = false;
@@ -2063,6 +2140,8 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 	wl1271_debug(DEBUG_MAC80211, "mac80211 add interface type %d mac %pM",
 		     ieee80211_vif_type_p2p(vif), vif->addr);
 
+	wl12xx_get_vif_count(hw, vif, &vif_count);
+
 	mutex_lock(&wl->mutex);
 	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
@@ -2098,10 +2177,17 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 		goto out;
 	}
 
+	if (wl12xx_need_fw_change(wl, vif_count, true)) {
+		mutex_unlock(&wl->mutex);
+		wl1271_recovery_work(&wl->recovery_work);
+		return 0;
+	}
+
 	/*
 	 * TODO: after the nvs issue will be solved, move this block
 	 * to start(), and make sure here the driver is ON.
 	 */
+	wl1271_info("state: %d", wl->state);
 	if (wl->state == WL1271_STATE_OFF) {
 		/*
 		 * we still need this in order to configure the fw
@@ -2261,7 +2347,10 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 	struct wl1271 *wl = hw->priv;
 	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	struct wl12xx_vif *iter;
+	struct vif_counter_data vif_count;
+	bool cancel_recovery = true;
 
+	wl12xx_get_vif_count(hw, vif, &vif_count);
 	mutex_lock(&wl->mutex);
 
 	if (wl->state == WL1271_STATE_OFF ||
@@ -2280,20 +2369,32 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 		break;
 	}
 	WARN_ON(iter != wlvif);
+	if (wl12xx_need_fw_change(wl, vif_count, false)) {
+		wl12xx_queue_recovery_work(wl);
+		cancel_recovery = false;
+	}
 out:
 	mutex_unlock(&wl->mutex);
-	cancel_work_sync(&wl->recovery_work);
+	if (cancel_recovery)
+		cancel_work_sync(&wl->recovery_work);
 }
 
 static int wl12xx_op_change_interface(struct ieee80211_hw *hw,
 				      struct ieee80211_vif *vif,
 				      enum nl80211_iftype new_type, bool p2p)
 {
+	struct wl1271 *wl = hw->priv;
+	int ret;
+
+	set_bit(WL1271_FLAG_VIF_CHANGE_IN_PROGRESS, &wl->flags);
 	wl1271_op_remove_interface(hw, vif);
 
 	vif->type = ieee80211_iftype_p2p(new_type, p2p);
 	vif->p2p = p2p;
-	return wl1271_op_add_interface(hw, vif);
+	ret = wl1271_op_add_interface(hw, vif);
+
+	clear_bit(WL1271_FLAG_VIF_CHANGE_IN_PROGRESS, &wl->flags);
+	return ret;
 }
 
 static int wl1271_join(struct wl1271 *wl, struct wl12xx_vif *wlvif,
diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index 1c0264c..4b3c327 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -370,7 +370,9 @@ module_exit(wl1271_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Luciano Coelho <coelho@ti.com>");
 MODULE_AUTHOR("Juuso Oikarinen <juuso.oikarinen@nokia.com>");
-MODULE_FIRMWARE(WL127X_FW_NAME);
-MODULE_FIRMWARE(WL128X_FW_NAME);
+MODULE_FIRMWARE(WL127X_FW_NAME_SINGLE);
+MODULE_FIRMWARE(WL127X_FW_NAME_MULTI);
 MODULE_FIRMWARE(WL127X_PLT_FW_NAME);
+MODULE_FIRMWARE(WL128X_FW_NAME_SINGLE);
+MODULE_FIRMWARE(WL128X_FW_NAME_MULTI);
 MODULE_FIRMWARE(WL128X_PLT_FW_NAME);
diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
index 5c2d4a0..2fc18a8 100644
--- a/drivers/net/wireless/wl12xx/spi.c
+++ b/drivers/net/wireless/wl12xx/spi.c
@@ -433,8 +433,10 @@ module_exit(wl1271_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Luciano Coelho <coelho@ti.com>");
 MODULE_AUTHOR("Juuso Oikarinen <juuso.oikarinen@nokia.com>");
-MODULE_FIRMWARE(WL127X_FW_NAME);
-MODULE_FIRMWARE(WL128X_FW_NAME);
+MODULE_FIRMWARE(WL127X_FW_NAME_SINGLE);
+MODULE_FIRMWARE(WL127X_FW_NAME_MULTI);
 MODULE_FIRMWARE(WL127X_PLT_FW_NAME);
+MODULE_FIRMWARE(WL128X_FW_NAME_SINGLE);
+MODULE_FIRMWARE(WL128X_FW_NAME_MULTI);
 MODULE_FIRMWARE(WL128X_PLT_FW_NAME);
 MODULE_ALIAS("spi:wl1271");
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 348d1f6..021d84f 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -35,8 +35,12 @@
 #include "conf.h"
 #include "ini.h"
 
-#define WL127X_FW_NAME "ti-connectivity/wl127x-fw-4-sr.bin"
-#define WL128X_FW_NAME "ti-connectivity/wl128x-fw-4-sr.bin"
+#define WL127X_FW_NAME_MULTI "ti-connectivity/wl127x-fw-4-mr.bin"
+#define WL127X_FW_NAME_SINGLE "ti-connectivity/wl127x-fw-4-sr.bin"
+
+#define WL128X_FW_NAME_MULTI "ti-connectivity/wl128x-fw-4-mr.bin"
+#define WL128X_FW_NAME_SINGLE "ti-connectivity/wl128x-fw-4-sr.bin"
+
 #define WL127X_PLT_FW_NAME "ti-connectivity/wl127x-fw-4-plt.bin"
 #define WL128X_PLT_FW_NAME "ti-connectivity/wl128x-fw-4-plt.bin"
 
@@ -97,6 +101,7 @@ enum wl1271_state {
 enum wl12xx_fw_type {
 	WL12XX_FW_TYPE_NONE,
 	WL12XX_FW_TYPE_NORMAL,
+	WL12XX_FW_TYPE_MULTI,
 	WL12XX_FW_TYPE_PLT,
 };
 
@@ -254,6 +259,7 @@ enum wl12xx_flags {
 	WL1271_FLAG_PENDING_WORK,
 	WL1271_FLAG_SOFT_GEMINI,
 	WL1271_FLAG_RECOVERY_IN_PROGRESS,
+	WL1271_FLAG_VIF_CHANGE_IN_PROGRESS,
 };
 
 enum wl12xx_vif_flags {
@@ -303,6 +309,7 @@ struct wl1271 {
 	enum wl1271_state state;
 	enum wl12xx_fw_type fw_type;
 	bool plt;
+	u8 last_vif_count;
 	struct mutex mutex;
 
 	unsigned long flags;
-- 
1.7.6.401.g6a319

