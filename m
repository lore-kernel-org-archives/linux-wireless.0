Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55550 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab1FFL5T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 07:57:19 -0400
Received: by wya21 with SMTP id 21so2719203wya.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2011 04:57:17 -0700 (PDT)
From: Ido Yariv <ido@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, Ido Yariv <ido@wizery.com>
Subject: [PATCH 1/3] wl12xx: Check for FW quirks as soon as the FW boots
Date: Mon,  6 Jun 2011 14:57:04 +0300
Message-Id: <1307361426-7573-1-git-send-email-ido@wizery.com> (sfid-20110606_135722_983030_68267E2F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The FW initialization might depend on the FW revision, so check for any
FW quirks right after booting it.

Signed-off-by: Ido Yariv <ido@wizery.com>
---
 drivers/net/wireless/wl12xx/boot.c |   21 +++++++++++++++++++++
 drivers/net/wireless/wl12xx/main.c |   23 -----------------------
 2 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index b07f8b7..b9d8fa9 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -102,6 +102,24 @@ static void wl1271_boot_set_ecpu_ctrl(struct wl1271 *wl, u32 flag)
 	wl1271_write32(wl, ACX_REG_ECPU_CONTROL, cpu_ctrl);
 }
 
+static unsigned int wl12xx_get_fw_ver_quirks(struct wl1271 *wl)
+{
+	unsigned int quirks = 0;
+	unsigned int *fw_ver = wl->chip.fw_ver;
+
+	/* Only for wl127x */
+	if ((fw_ver[FW_VER_CHIP] == FW_VER_CHIP_WL127X) &&
+	    /* Check STA version */
+	    (((fw_ver[FW_VER_IF_TYPE] == FW_VER_IF_TYPE_STA) &&
+	      (fw_ver[FW_VER_MINOR] < FW_VER_MINOR_1_SPARE_STA_MIN)) ||
+	     /* Check AP version */
+	     ((fw_ver[FW_VER_IF_TYPE] == FW_VER_IF_TYPE_AP) &&
+	      (fw_ver[FW_VER_MINOR] < FW_VER_MINOR_1_SPARE_AP_MIN))))
+		quirks |= WL12XX_QUIRK_USE_2_SPARE_BLOCKS;
+
+	return quirks;
+}
+
 static void wl1271_parse_fw_ver(struct wl1271 *wl)
 {
 	int ret;
@@ -116,6 +134,9 @@ static void wl1271_parse_fw_ver(struct wl1271 *wl)
 		memset(wl->chip.fw_ver, 0, sizeof(wl->chip.fw_ver));
 		return;
 	}
+
+	/* Check if any quirks are needed with older fw versions */
+	wl->quirks |= wl12xx_get_fw_ver_quirks(wl);
 }
 
 static void wl1271_boot_fw_version(struct wl1271 *wl)
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index fb0f764..ab435c7 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1233,24 +1233,6 @@ out:
 	return ret;
 }
 
-static unsigned int wl1271_get_fw_ver_quirks(struct wl1271 *wl)
-{
-	unsigned int quirks = 0;
-	unsigned int *fw_ver = wl->chip.fw_ver;
-
-	/* Only for wl127x */
-	if ((fw_ver[FW_VER_CHIP] == FW_VER_CHIP_WL127X) &&
-	    /* Check STA version */
-	    (((fw_ver[FW_VER_IF_TYPE] == FW_VER_IF_TYPE_STA) &&
-	      (fw_ver[FW_VER_MINOR] < FW_VER_MINOR_1_SPARE_STA_MIN)) ||
-	     /* Check AP version */
-	     ((fw_ver[FW_VER_IF_TYPE] == FW_VER_IF_TYPE_AP) &&
-	      (fw_ver[FW_VER_MINOR] < FW_VER_MINOR_1_SPARE_AP_MIN))))
-		quirks |= WL12XX_QUIRK_USE_2_SPARE_BLOCKS;
-
-	return quirks;
-}
-
 int wl1271_plt_start(struct wl1271 *wl)
 {
 	int retries = WL1271_BOOT_RETRIES;
@@ -1287,8 +1269,6 @@ int wl1271_plt_start(struct wl1271 *wl)
 		wl1271_notice("firmware booted in PLT mode (%s)",
 			      wl->chip.fw_ver_str);
 
-		/* Check if any quirks are needed with older fw versions */
-		wl->quirks |= wl1271_get_fw_ver_quirks(wl);
 		goto out;
 
 irq_disable:
@@ -1743,9 +1723,6 @@ power_off:
 	strncpy(wiphy->fw_version, wl->chip.fw_ver_str,
 		sizeof(wiphy->fw_version));
 
-	/* Check if any quirks are needed with older fw versions */
-	wl->quirks |= wl1271_get_fw_ver_quirks(wl);
-
 	/*
 	 * Now we know if 11a is supported (info from the NVS), so disable
 	 * 11a channels if not supported
-- 
1.7.4.1

