Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:33164 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752018Ab2GRMN4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 08:13:56 -0400
Received: by lbol5 with SMTP id l5so2178860lbo.34
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jul 2012 05:13:54 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 08/14] wlcore: add plt_mode including new PLT_FEM_DETECT
Date: Wed, 18 Jul 2012 15:13:27 +0300
Message-Id: <1342613613-917-9-git-send-email-coelho@ti.com> (sfid-20120718_141409_901107_4D3F66BD)
In-Reply-To: <1342613613-917-1-git-send-email-coelho@ti.com>
References: <1342613613-917-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yair Shapira <yair.shapira@ti.com>

add wl->plt_mode that is used to indicate different plt
working modes: this will be used to implement calibrator side
auto fem detection where driver asks firmware to detect
the wlan fem radio type and returns it to calibrator.

this is not implemented yet and plt_modes: PLT_ON and
PLT_FEM_DETECT currently behave the same.

Signed-off-by: Yair Shapira <yair.shapira@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/main.c     |   21 ++++++++++++++++++---
 drivers/net/wireless/ti/wlcore/testmode.c |    7 ++++---
 drivers/net/wireless/ti/wlcore/wlcore.h   |    1 +
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    8 +++++++-
 4 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 05c3912..7254860 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1064,10 +1064,17 @@ out:
 	return ret;
 }
 
-int wl1271_plt_start(struct wl1271 *wl)
+int wl1271_plt_start(struct wl1271 *wl, const enum plt_mode plt_mode)
 {
 	int retries = WL1271_BOOT_RETRIES;
 	struct wiphy *wiphy = wl->hw->wiphy;
+
+	static const char* const PLT_MODE[] = {
+		"PLT_OFF",
+		"PLT_ON",
+		"PLT_FEM_DETECT"
+	};
+
 	int ret;
 
 	mutex_lock(&wl->mutex);
@@ -1081,6 +1088,10 @@ int wl1271_plt_start(struct wl1271 *wl)
 		goto out;
 	}
 
+	/* Indicate to lower levels that we are now in PLT mode */
+	wl->plt = true;
+	wl->plt_mode = plt_mode;
+
 	while (retries) {
 		retries--;
 		ret = wl12xx_chip_wakeup(wl, true);
@@ -1091,9 +1102,9 @@ int wl1271_plt_start(struct wl1271 *wl)
 		if (ret < 0)
 			goto power_off;
 
-		wl->plt = true;
 		wl->state = WL1271_STATE_ON;
-		wl1271_notice("firmware booted in PLT mode (%s)",
+		wl1271_notice("firmware booted in PLT mode %s (%s)",
+			      PLT_MODE[plt_mode],
 			      wl->chip.fw_ver_str);
 
 		/* update hw/fw version info in wiphy struct */
@@ -1107,6 +1118,9 @@ power_off:
 		wl1271_power_off(wl);
 	}
 
+	wl->plt = false;
+	wl->plt_mode = PLT_OFF;
+
 	wl1271_error("firmware boot in PLT mode failed despite %d retries",
 		     WL1271_BOOT_RETRIES);
 out:
@@ -1159,6 +1173,7 @@ int wl1271_plt_stop(struct wl1271 *wl)
 	wl->sleep_auth = WL1271_PSM_ILLEGAL;
 	wl->state = WL1271_STATE_OFF;
 	wl->plt = false;
+	wl->plt_mode = PLT_OFF;
 	wl->rx_counter = 0;
 	mutex_unlock(&wl->mutex);
 
diff --git a/drivers/net/wireless/ti/wlcore/testmode.c b/drivers/net/wireless/ti/wlcore/testmode.c
index d6f57e2..a204c93 100644
--- a/drivers/net/wireless/ti/wlcore/testmode.c
+++ b/drivers/net/wireless/ti/wlcore/testmode.c
@@ -258,11 +258,12 @@ static int wl1271_tm_cmd_set_plt_mode(struct wl1271 *wl, struct nlattr *tb[])
 	val = nla_get_u32(tb[WL1271_TM_ATTR_PLT_MODE]);
 
 	switch (val) {
-	case 0:
+	case PLT_OFF:
 		ret = wl1271_plt_stop(wl);
 		break;
-	case 1:
-		ret = wl1271_plt_start(wl);
+	case PLT_ON:
+	case PLT_FEM_DETECT:
+		ret = wl1271_plt_start(wl, val);
 		break;
 	default:
 		ret = -EINVAL;
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 27ccc27..4f8b419 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -156,6 +156,7 @@ struct wl1271 {
 	enum wl1271_state state;
 	enum wl12xx_fw_type fw_type;
 	bool plt;
+	enum plt_mode plt_mode;
 	u8 last_vif_count;
 	struct mutex mutex;
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index 0187eef..c050563 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -293,6 +293,12 @@ enum rx_filter_action {
 	FILTER_FW_HANDLE = 2
 };
 
+enum plt_mode {
+	PLT_OFF = 0,
+	PLT_ON = 1,
+	PLT_FEM_DETECT = 2,
+};
+
 struct wl12xx_rx_filter_field {
 	__le16 offset;
 	u8 len;
@@ -459,7 +465,7 @@ struct ieee80211_vif *wl12xx_wlvif_to_vif(struct wl12xx_vif *wlvif)
 #define wl12xx_for_each_wlvif_ap(wl, wlvif)	\
 		wl12xx_for_each_wlvif_bss_type(wl, wlvif, BSS_TYPE_AP_BSS)
 
-int wl1271_plt_start(struct wl1271 *wl);
+int wl1271_plt_start(struct wl1271 *wl, const enum plt_mode plt_mode);
 int wl1271_plt_stop(struct wl1271 *wl);
 int wl1271_recalc_rx_streaming(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 void wl12xx_queue_recovery_work(struct wl1271 *wl);
-- 
1.7.10.4

