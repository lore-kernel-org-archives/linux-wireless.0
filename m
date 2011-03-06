Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:34425 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807Ab1CFO23 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 09:28:29 -0500
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id p26ESSWq005869
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Sun, 6 Mar 2011 08:28:28 -0600
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>
Subject: [PATCH 15/15] wl12xx: 1281/1283 support - enable chip support
Date: Sun,  6 Mar 2011 16:32:20 +0200
Message-Id: <1299421940-26292-16-git-send-email-shahar_levi@ti.com>
In-Reply-To: <1299421940-26292-1-git-send-email-shahar_levi@ti.com>
References: <1299421940-26292-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support to wl128x chip via chip id

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
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
index 8ac3936..af4739d 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1023,6 +1023,15 @@ static int wl1271_chip_wakeup(struct wl1271 *wl)
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
1.7.0.4

