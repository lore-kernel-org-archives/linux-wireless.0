Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45453 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab1HBHY3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 03:24:29 -0400
Received: by wwe5 with SMTP id 5so6423351wwe.1
        for <linux-wireless@vger.kernel.org>; Tue, 02 Aug 2011 00:24:27 -0700 (PDT)
From: Ido Yariv <ido@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, Ido Yariv <ido@wizery.com>
Subject: [PATCH 1/2] wl12xx: Remove obsolete testmode NVS push command
Date: Tue,  2 Aug 2011 10:24:17 +0300
Message-Id: <1312269858-30434-1-git-send-email-ido@wizery.com> (sfid-20110802_092433_385625_A94F3D61)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The testmode NVS push command is no longer in use. In addition, it has
several implementation issues that prevent it from working correctly:

1. wl1271_tm_cmd_configure relies on wl->chip.id being set. However,
   since the device was not necessarily booted by the time the function
   is called, wl->chip.id will be initialized to 0.
2. The NVS file is fetched by calling request_firmware() before it is
   possible to push an NVS file.
3. The maximum allowed size of nl binary payloads is not sufficient for
   pushing NVS files.
4. Pushing 128x NVS files will always fail due to a bug in the
   validation code.
5. In case the pushed NVS file is found invalid, the mutex will be kept
   locked and the nvs member will become a dangling pointer.

Since this feature is not being used, remove it completely instead of
fixing it.

Signed-off-by: Ido Yariv <ido@wizery.com>
---
 drivers/net/wireless/wl12xx/testmode.c |   45 --------------------------------
 1 files changed, 0 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/testmode.c b/drivers/net/wireless/wl12xx/testmode.c
index 5d5e1ef..6e6fd56 100644
--- a/drivers/net/wireless/wl12xx/testmode.c
+++ b/drivers/net/wireless/wl12xx/testmode.c
@@ -36,7 +36,6 @@ enum wl1271_tm_commands {
 	WL1271_TM_CMD_TEST,
 	WL1271_TM_CMD_INTERROGATE,
 	WL1271_TM_CMD_CONFIGURE,
-	WL1271_TM_CMD_NVS_PUSH,
 	WL1271_TM_CMD_SET_PLT_MODE,
 	WL1271_TM_CMD_RECOVER,
 
@@ -187,48 +186,6 @@ static int wl1271_tm_cmd_configure(struct wl1271 *wl, struct nlattr *tb[])
 	return 0;
 }
 
-static int wl1271_tm_cmd_nvs_push(struct wl1271 *wl, struct nlattr *tb[])
-{
-	int ret = 0;
-	size_t len;
-	void *buf;
-
-	wl1271_debug(DEBUG_TESTMODE, "testmode cmd nvs push");
-
-	if (!tb[WL1271_TM_ATTR_DATA])
-		return -EINVAL;
-
-	buf = nla_data(tb[WL1271_TM_ATTR_DATA]);
-	len = nla_len(tb[WL1271_TM_ATTR_DATA]);
-
-	mutex_lock(&wl->mutex);
-
-	kfree(wl->nvs);
-
-	if ((wl->chip.id == CHIP_ID_1283_PG20) &&
-	    (len != sizeof(struct wl128x_nvs_file)))
-		return -EINVAL;
-	else if (len != sizeof(struct wl1271_nvs_file))
-		return -EINVAL;
-
-	wl->nvs = kzalloc(len, GFP_KERNEL);
-	if (!wl->nvs) {
-		wl1271_error("could not allocate memory for the nvs file");
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	memcpy(wl->nvs, buf, len);
-	wl->nvs_len = len;
-
-	wl1271_debug(DEBUG_TESTMODE, "testmode pushed nvs");
-
-out:
-	mutex_unlock(&wl->mutex);
-
-	return ret;
-}
-
 static int wl1271_tm_cmd_set_plt_mode(struct wl1271 *wl, struct nlattr *tb[])
 {
 	u32 val;
@@ -285,8 +242,6 @@ int wl1271_tm_cmd(struct ieee80211_hw *hw, void *data, int len)
 		return wl1271_tm_cmd_interrogate(wl, tb);
 	case WL1271_TM_CMD_CONFIGURE:
 		return wl1271_tm_cmd_configure(wl, tb);
-	case WL1271_TM_CMD_NVS_PUSH:
-		return wl1271_tm_cmd_nvs_push(wl, tb);
 	case WL1271_TM_CMD_SET_PLT_MODE:
 		return wl1271_tm_cmd_set_plt_mode(wl, tb);
 	case WL1271_TM_CMD_RECOVER:
-- 
1.7.4.1

