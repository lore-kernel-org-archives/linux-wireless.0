Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38812 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756970Ab2K0GpS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 01:45:18 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr13so2666942wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 22:45:17 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Eliad Peller <eliad@wizery.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 06/20] wlcore: remove WLCORE_QUIRK_NO_ELP
Date: Tue, 27 Nov 2012 08:44:47 +0200
Message-Id: <1353998701-18171-7-git-send-email-arik@wizery.com> (sfid-20121127_074526_829850_625F054B)
In-Reply-To: <1353998701-18171-1-git-send-email-arik@wizery.com>
References: <1353998701-18171-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

all the current firmwares support elp, so
we can safely remove WLCORE_QUIRK_NO_ELP.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c   |    3 +--
 drivers/net/wireless/ti/wlcore/init.c   |    3 ---
 drivers/net/wireless/ti/wlcore/main.c   |    3 ---
 drivers/net/wireless/ti/wlcore/wlcore.h |    3 ---
 4 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 617e8d1..635f8b7 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -639,8 +639,7 @@ static int wl18xx_identify_chip(struct wl1271 *wl)
 		wl->sr_fw_name = WL18XX_FW_NAME;
 		/* wl18xx uses the same firmware for PLT */
 		wl->plt_fw_name = WL18XX_FW_NAME;
-		wl->quirks |= WLCORE_QUIRK_NO_ELP |
-			      WLCORE_QUIRK_RX_BLOCKSIZE_ALIGN |
+		wl->quirks |= WLCORE_QUIRK_RX_BLOCKSIZE_ALIGN |
 			      WLCORE_QUIRK_TX_BLOCKSIZE_ALIGN |
 			      WLCORE_QUIRK_NO_SCHED_SCAN_WHILE_CONN |
 			      WLCORE_QUIRK_TX_PAD_LAST_FRAME |
diff --git a/drivers/net/wireless/ti/wlcore/init.c b/drivers/net/wireless/ti/wlcore/init.c
index 68828b4..5c6f11e 100644
--- a/drivers/net/wireless/ti/wlcore/init.c
+++ b/drivers/net/wireless/ti/wlcore/init.c
@@ -577,9 +577,6 @@ int wl1271_init_vif_specific(struct wl1271 *wl, struct ieee80211_vif *vif)
 		/* Configure for power according to debugfs */
 		if (sta_auth != WL1271_PSM_ILLEGAL)
 			ret = wl1271_acx_sleep_auth(wl, sta_auth);
-		/* Configure for power always on */
-		else if (wl->quirks & WLCORE_QUIRK_NO_ELP)
-			ret = wl1271_acx_sleep_auth(wl, WL1271_PSM_CAM);
 		/* Configure for ELP power saving */
 		else
 			ret = wl1271_acx_sleep_auth(wl, WL1271_PSM_ELP);
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 56f20d6..05ba72a 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -2484,9 +2484,6 @@ deinit:
 		/* Configure for power according to debugfs */
 		if (sta_auth != WL1271_PSM_ILLEGAL)
 			wl1271_acx_sleep_auth(wl, sta_auth);
-		/* Configure for power always on */
-		else if (wl->quirks & WLCORE_QUIRK_NO_ELP)
-			wl1271_acx_sleep_auth(wl, WL1271_PSM_CAM);
 		/* Configure for ELP power saving */
 		else
 			wl1271_acx_sleep_auth(wl, WL1271_PSM_ELP);
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 4d5c69e..07898de 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -501,9 +501,6 @@ wlcore_set_min_fw_ver(struct wl1271 *wl, unsigned int chip,
 /* Older firmwares use an old NVS format */
 #define WLCORE_QUIRK_LEGACY_NVS			BIT(5)
 
-/* Some firmwares may not support ELP */
-#define WLCORE_QUIRK_NO_ELP			BIT(6)
-
 /* pad only the last frame in the aggregate buffer */
 #define WLCORE_QUIRK_TX_PAD_LAST_FRAME		BIT(7)
 
-- 
1.7.9.5

