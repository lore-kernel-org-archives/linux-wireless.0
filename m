Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:34212 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754175Ab2DKJia (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 05:38:30 -0400
Received: by lagy4 with SMTP id y4so618004lag.36
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 02:38:27 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, linville@tuxdriver.com, coelho@ti.com
Subject: [PATCH 13/16] wlcore/wl12xx: add quirk for legacy NVS support
Date: Wed, 11 Apr 2012 12:38:00 +0300
Message-Id: <1334137083-13490-14-git-send-email-coelho@ti.com> (sfid-20120411_113836_677536_ED190E86)
In-Reply-To: <1334137083-13490-1-git-send-email-coelho@ti.com>
References: <1334137083-13490-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of checking the chip ID directly in the wlcore code to decide
whether to use the new or the old NVS format, we now use a quirk that
should be set by the low level driver to say that it needs to use the
old format.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |    6 +++-
 drivers/net/wireless/ti/wlcore/boot.c   |   41 +++++++++++++++----------------
 drivers/net/wireless/ti/wlcore/wlcore.h |    3 ++
 3 files changed, 27 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 8d82203..d24e49a 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -151,7 +151,8 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 		wl1271_warning("chip id 0x%x (1271 PG10) support is obsolete",
 			       wl->chip.id);
 
-		wl->quirks |= WLCORE_QUIRK_NO_BLOCKSIZE_ALIGNMENT;
+		wl->quirks |= WLCORE_QUIRK_NO_BLOCKSIZE_ALIGNMENT |
+			WLCORE_QUIRK_LEGACY_NVS;
 		wl->plt_fw_name = WL127X_PLT_FW_NAME;
 		wl->sr_fw_name = WL127X_FW_NAME_SINGLE;
 		wl->mr_fw_name = WL127X_FW_NAME_MULTI;
@@ -161,7 +162,8 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 		wl1271_debug(DEBUG_BOOT, "chip id 0x%x (1271 PG20)",
 			     wl->chip.id);
 
-		wl->quirks |= WLCORE_QUIRK_NO_BLOCKSIZE_ALIGNMENT;
+		wl->quirks |= WLCORE_QUIRK_NO_BLOCKSIZE_ALIGNMENT |
+			WLCORE_QUIRK_LEGACY_NVS;
 		wl->plt_fw_name = WL127X_PLT_FW_NAME;
 		wl->sr_fw_name = WL127X_FW_NAME_SINGLE;
 		wl->mr_fw_name = WL127X_FW_NAME_MULTI;
diff --git a/drivers/net/wireless/ti/wlcore/boot.c b/drivers/net/wireless/ti/wlcore/boot.c
index 7d49870..9520073 100644
--- a/drivers/net/wireless/ti/wlcore/boot.c
+++ b/drivers/net/wireless/ti/wlcore/boot.c
@@ -215,27 +215,7 @@ int wlcore_boot_upload_nvs(struct wl1271 *wl)
 	if (wl->nvs == NULL)
 		return -ENODEV;
 
-	if (wl->chip.id == CHIP_ID_1283_PG20) {
-		struct wl128x_nvs_file *nvs = (struct wl128x_nvs_file *)wl->nvs;
-
-		if (wl->nvs_len == sizeof(struct wl128x_nvs_file)) {
-			if (nvs->general_params.dual_mode_select)
-				wl->enable_11a = true;
-		} else {
-			wl1271_error("nvs size is not as expected: %zu != %zu",
-				     wl->nvs_len,
-				     sizeof(struct wl128x_nvs_file));
-			kfree(wl->nvs);
-			wl->nvs = NULL;
-			wl->nvs_len = 0;
-			return -EILSEQ;
-		}
-
-		/* only the first part of the NVS needs to be uploaded */
-		nvs_len = sizeof(nvs->nvs);
-		nvs_ptr = (u8 *)nvs->nvs;
-
-	} else {
+	if (wl->quirks & WLCORE_QUIRK_LEGACY_NVS) {
 		struct wl1271_nvs_file *nvs =
 			(struct wl1271_nvs_file *)wl->nvs;
 		/*
@@ -263,6 +243,25 @@ int wlcore_boot_upload_nvs(struct wl1271 *wl)
 		/* only the first part of the NVS needs to be uploaded */
 		nvs_len = sizeof(nvs->nvs);
 		nvs_ptr = (u8 *) nvs->nvs;
+	} else {
+		struct wl128x_nvs_file *nvs = (struct wl128x_nvs_file *)wl->nvs;
+
+		if (wl->nvs_len == sizeof(struct wl128x_nvs_file)) {
+			if (nvs->general_params.dual_mode_select)
+				wl->enable_11a = true;
+		} else {
+			wl1271_error("nvs size is not as expected: %zu != %zu",
+				     wl->nvs_len,
+				     sizeof(struct wl128x_nvs_file));
+			kfree(wl->nvs);
+			wl->nvs = NULL;
+			wl->nvs_len = 0;
+			return -EILSEQ;
+		}
+
+		/* only the first part of the NVS needs to be uploaded */
+		nvs_len = sizeof(nvs->nvs);
+		nvs_ptr = (u8 *)nvs->nvs;
 	}
 
 	/* update current MAC address to NVS */
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 76c27dd..5f5dadb 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -322,6 +322,9 @@ int wlcore_free_hw(struct wl1271 *wl);
 /* Older firmwares did not implement the FW logger over bus feature */
 #define WLCORE_QUIRK_FWLOG_NOT_IMPLEMENTED	BIT(4)
 
+/* Older firmwares use an old NVS format */
+#define WLCORE_QUIRK_LEGACY_NVS			BIT(5)
+
 /* TODO: move to the lower drivers when all usages are abstracted */
 #define CHIP_ID_1271_PG10              (0x4030101)
 #define CHIP_ID_1271_PG20              (0x4030111)
-- 
1.7.5.4

