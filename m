Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:65429 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590Ab3ICOeU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 10:34:20 -0400
Received: by mail-wg0-f52.google.com with SMTP id m14so3335096wgh.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 Sep 2013 07:34:19 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luca@coelho.fi>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 02/12] wlcore: add new plt power-mode: CHIP_AWAKE
Date: Tue,  3 Sep 2013 17:33:58 +0300
Message-Id: <1378218848-7853-2-git-send-email-eliad@wizery.com> (sfid-20130903_163433_081220_1AA60E57)
In-Reply-To: <1378218848-7853-1-git-send-email-eliad@wizery.com>
References: <1378218848-7853-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yair Shapira <yair.shapira@ti.com>

Under this mode the chip is powered on including sdio
but no FW is downloaded and run, interrupts are not enabled, etc...

This mode is intended to allow RTTT to bridge sdio as a transport
to the chip.

Driver only provides sdio access using the dev_mem debugfs file.

Some fixes done to the code that ensures that PLT mode and normal
driver power mode (ifconfig/add_interface) are mutually excluded.

Signed-off-by: Yair Shapira <yair.shapira@ti.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c     | 16 ++++++++++++----
 drivers/net/wireless/ti/wlcore/testmode.c | 13 +++++++++++--
 drivers/net/wireless/ti/wlcore/wlcore_i.h |  1 +
 3 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index b64b465..611e81d 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1062,7 +1062,8 @@ int wl1271_plt_start(struct wl1271 *wl, const enum plt_mode plt_mode)
 	static const char* const PLT_MODE[] = {
 		"PLT_OFF",
 		"PLT_ON",
-		"PLT_FEM_DETECT"
+		"PLT_FEM_DETECT",
+		"PLT_CHIP_AWAKE"
 	};
 
 	int ret;
@@ -1088,9 +1089,11 @@ int wl1271_plt_start(struct wl1271 *wl, const enum plt_mode plt_mode)
 		if (ret < 0)
 			goto power_off;
 
-		ret = wl->ops->plt_init(wl);
-		if (ret < 0)
-			goto power_off;
+		if (plt_mode != PLT_CHIP_AWAKE) {
+			ret = wl->ops->plt_init(wl);
+			if (ret < 0)
+				goto power_off;
+		}
 
 		wl->state = WLCORE_STATE_ON;
 		wl1271_notice("firmware booted in PLT mode %s (%s)",
@@ -2419,6 +2422,11 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 	int ret = 0;
 	u8 role_type;
 
+	if (wl->plt) {
+		wl1271_error("Adding Interface not allowed while in PLT mode");
+		return -EBUSY;
+	}
+
 	vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER |
 			     IEEE80211_VIF_SUPPORTS_CQM_RSSI;
 
diff --git a/drivers/net/wireless/ti/wlcore/testmode.c b/drivers/net/wireless/ti/wlcore/testmode.c
index 527590f..a3b7d95 100644
--- a/drivers/net/wireless/ti/wlcore/testmode.c
+++ b/drivers/net/wireless/ti/wlcore/testmode.c
@@ -297,7 +297,8 @@ static int wl1271_tm_cmd_set_plt_mode(struct wl1271 *wl, struct nlattr *tb[])
 		ret = wl1271_plt_stop(wl);
 		break;
 	case PLT_ON:
-		ret = wl1271_plt_start(wl, PLT_ON);
+	case PLT_CHIP_AWAKE:
+		ret = wl1271_plt_start(wl, val);
 		break;
 	case PLT_FEM_DETECT:
 		ret = wl1271_tm_detect_fem(wl, tb);
@@ -361,6 +362,7 @@ int wl1271_tm_cmd(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 {
 	struct wl1271 *wl = hw->priv;
 	struct nlattr *tb[WL1271_TM_ATTR_MAX + 1];
+	u32 nla_cmd;
 	int err;
 
 	err = nla_parse(tb, WL1271_TM_ATTR_MAX, data, len, wl1271_tm_policy);
@@ -370,7 +372,14 @@ int wl1271_tm_cmd(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	if (!tb[WL1271_TM_ATTR_CMD_ID])
 		return -EINVAL;
 
-	switch (nla_get_u32(tb[WL1271_TM_ATTR_CMD_ID])) {
+	nla_cmd = nla_get_u32(tb[WL1271_TM_ATTR_CMD_ID]);
+
+	/* Only SET_PLT_MODE is allowed in case of mode PLT_CHIP_AWAKE */
+	if (wl->plt_mode == PLT_CHIP_AWAKE &&
+	    nla_cmd != WL1271_TM_CMD_SET_PLT_MODE)
+		return -EOPNOTSUPP;
+
+	switch (nla_cmd) {
 	case WL1271_TM_CMD_TEST:
 		return wl1271_tm_cmd_test(wl, tb);
 	case WL1271_TM_CMD_INTERROGATE:
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index 14fd111..3f4f08b 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -307,6 +307,7 @@ enum plt_mode {
 	PLT_OFF = 0,
 	PLT_ON = 1,
 	PLT_FEM_DETECT = 2,
+	PLT_CHIP_AWAKE = 3
 };
 
 struct wl12xx_rx_filter_field {
-- 
1.8.3.rc1.35.g9b79519

