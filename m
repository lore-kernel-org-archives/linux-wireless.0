Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:53864 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756651Ab1CROUF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 10:20:05 -0400
Received: by wyj26 with SMTP id 26so4744881wyj.39
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 07:20:02 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: shahar_levi@ti.com, ruthyz@ti.com
Subject: [PATCH v2 02/14] wl12xx: 1281/1283 support - move IRQ polarity
Date: Fri, 18 Mar 2011 16:19:17 +0200
Message-Id: <1300457969-19601-3-git-send-email-coelho@ti.com>
In-Reply-To: <1300457969-19601-1-git-send-email-coelho@ti.com>
References: <1300457969-19601-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shahar Levi <shahar_levi@ti.com>

In order to prevent overran of IRQ polarity via FW the polarity setting move after
FW download and before IRQ enable.

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
Reviewed-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
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
1.7.1

