Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:43885 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756494Ab1CROUb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 10:20:31 -0400
Received: by mail-wy0-f169.google.com with SMTP id 19so4196239wyf.28
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 07:20:30 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: shahar_levi@ti.com, ruthyz@ti.com
Subject: [PATCH v2 13/14] wl12xx: 1281/1283 support - enable chip support
Date: Fri, 18 Mar 2011 16:19:28 +0200
Message-Id: <1300457969-19601-14-git-send-email-coelho@ti.com>
In-Reply-To: <1300457969-19601-1-git-send-email-coelho@ti.com>
References: <1300457969-19601-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shahar Levi <shahar_levi@ti.com>

Add support to wl128x chip via chip id

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
Reviewed-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/Kconfig     |    2 +-
 drivers/net/wireless/wl12xx/main.c      |    9 +++++++++
 drivers/net/wireless/wl12xx/sdio_test.c |    5 +++++
 3 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
index 692ebff..35ce7b0 100644
--- a/drivers/net/wireless/wl12xx/Kconfig
+++ b/drivers/net/wireless/wl12xx/Kconfig
@@ -3,7 +3,7 @@ menuconfig WL12XX_MENU
 	depends on MAC80211 && EXPERIMENTAL
 	---help---
 	  This will enable TI wl12xx driver support for the following chips:
-	  wl1271 and wl1273.
+	  wl1271, wl1273, wl1281 and wl1283.
 	  The drivers make use of the mac80211 stack.
 
 config WL12XX
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 9a7ca65..0b9d41f 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1007,6 +1007,15 @@ static int wl1271_chip_wakeup(struct wl1271 *wl)
 		if (ret < 0)
 			goto out;
 		break;
+	case CHIP_ID_1283_PG20:
+		wl1271_debug(DEBUG_BOOT, "chip id 0x%x (1283 PG20)",
+			     wl->chip.id);
+
+		ret = wl1271_setup(wl);
+		if (ret < 0)
+			goto out;
+		break;
+	case CHIP_ID_1283_PG10:
 	default:
 		wl1271_warning("unsupported chip id: 0x%x", wl->chip.id);
 		ret = -ENODEV;
diff --git a/drivers/net/wireless/wl12xx/sdio_test.c b/drivers/net/wireless/wl12xx/sdio_test.c
index c02c870..968249a 100644
--- a/drivers/net/wireless/wl12xx/sdio_test.c
+++ b/drivers/net/wireless/wl12xx/sdio_test.c
@@ -293,6 +293,11 @@ static int wl1271_chip_wakeup(struct wl1271 *wl)
 		wl1271_notice("chip id 0x%x (1271 PG20)",
 				wl->chip.id);
 		break;
+	case CHIP_ID_1283_PG20:
+		wl1271_notice("chip id 0x%x (1283 PG20)",
+				wl->chip.id);
+		break;
+	case CHIP_ID_1283_PG10:
 	default:
 		wl1271_warning("unsupported chip id: 0x%x", wl->chip.id);
 		return -ENODEV;
-- 
1.7.1

