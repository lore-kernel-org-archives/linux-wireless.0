Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:34121 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873Ab1CFO2K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 09:28:10 -0500
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id p26ES9EA019805
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Sun, 6 Mar 2011 08:28:09 -0600
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>
Subject: [PATCH 01/15] wl12xx: 1281/1283 support - move IRQ polarity
Date: Sun,  6 Mar 2011 16:32:06 +0200
Message-Id: <1299421940-26292-2-git-send-email-shahar_levi@ti.com>
In-Reply-To: <1299421940-26292-1-git-send-email-shahar_levi@ti.com>
References: <1299421940-26292-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to prevent overran of IRQ polarity via FW the polarity setting move after
FW download and before IRQ enable.

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
Reviewed-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/boot.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index 6934dff..69fe870 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -585,13 +585,6 @@ int wl1271_load_firmware(struct wl1271 *wl)
 	/* 6. read the EEPROM parameters */
 	tmp = wl1271_read32(wl, SCR_PAD2);
 
-	ret = wl1271_boot_write_irq_polarity(wl);
-	if (ret < 0)
-		goto out;
-
-	wl1271_write32(wl, ACX_REG_INTERRUPT_MASK,
-		       WL1271_ACX_ALL_EVENTS_VECTOR);
-
 	/* WL1271: The reference driver skips steps 7 to 10 (jumps directly
 	 * to upload_fw) */
 
@@ -618,6 +611,13 @@ int wl1271_boot(struct wl1271 *wl)
 	if (ret < 0)
 		goto out;
 
+	ret = wl1271_boot_write_irq_polarity(wl);
+	if (ret < 0)
+		goto out;
+
+	wl1271_write32(wl, ACX_REG_INTERRUPT_MASK,
+		       WL1271_ACX_ALL_EVENTS_VECTOR);
+
 	/* Enable firmware interrupts now */
 	wl1271_boot_enable_interrupts(wl);
 
-- 
1.7.0.4

