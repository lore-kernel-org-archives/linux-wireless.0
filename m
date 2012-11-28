Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:52264 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab2K1JnM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 04:43:12 -0500
Received: by mail-wi0-f178.google.com with SMTP id hm6so5186649wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 01:43:11 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Yair Shapira <yair.shapira@ti.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 08/20] wlcore: add new plt power-mode: CHIP_AWAKE
Date: Wed, 28 Nov 2012 11:42:37 +0200
Message-Id: <1354095769-8724-9-git-send-email-arik@wizery.com> (sfid-20121128_104354_034598_1428A59F)
In-Reply-To: <1354095769-8724-1-git-send-email-arik@wizery.com>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
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
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c     |   16 ++++++++++++----
 drivers/net/wireless/ti/wlcore/testmode.c |   13 +++++++++++--
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    1 +
 3 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 6ad9fc5..37575d7 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1080,7 +1080,8 @@ int wl1271_plt_start(struct wl1271 *wl, const enum plt_mode plt_mode)
 	static const char* const PLT_MODE[] = {
 		"PLT_OFF",
 		"PLT_ON",
-		"PLT_FEM_DETECT"
+		"PLT_FEM_DETECT",
+		"PLT_CHIP_AWAKE"
 	};
 
 	int ret;
@@ -1106,9 +1107,11 @@ int wl1271_plt_start(struct wl1271 *wl, const enum plt_mode plt_mode)
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
@@ -2320,6 +2323,11 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 	u8 role_type;
 	bool booted = false;
 
+	if (wl->plt) {
+		wl1271_error("Adding Interface not allowed while in PLT mode");
+		return -EBUSY;
+	}
+
 	vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER |
 			     IEEE80211_VIF_SUPPORTS_CQM_RSSI;
 
diff --git a/drivers/net/wireless/ti/wlcore/testmode.c b/drivers/net/wireless/ti/wlcore/testmode.c
index f344276..7f71d12 100644
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
@@ -360,6 +361,7 @@ int wl1271_tm_cmd(struct ieee80211_hw *hw, void *data, int len)
 {
 	struct wl1271 *wl = hw->priv;
 	struct nlattr *tb[WL1271_TM_ATTR_MAX + 1];
+	u32 nla_cmd;
 	int err;
 
 	err = nla_parse(tb, WL1271_TM_ATTR_MAX, data, len, wl1271_tm_policy);
@@ -369,7 +371,14 @@ int wl1271_tm_cmd(struct ieee80211_hw *hw, void *data, int len)
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
index ba59879..41a58ff 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -306,6 +306,7 @@ enum plt_mode {
 	PLT_OFF = 0,
 	PLT_ON = 1,
 	PLT_FEM_DETECT = 2,
+	PLT_CHIP_AWAKE = 3
 };
 
 struct wl12xx_rx_filter_field {
-- 
1.7.9.5

