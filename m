Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:49654 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752965Ab2EHLH2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 07:07:28 -0400
Received: by obbwd18 with SMTP id wd18so13248853obb.14
        for <linux-wireless@vger.kernel.org>; Tue, 08 May 2012 04:07:27 -0700 (PDT)
From: Yoni Divinsky <yoni.divinsky@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <arik@wizery.com>, <coelho@ti.com>
Subject: [PATCH 2/4] wl12xx: set the irq polarity before loading the fw
Date: Tue,  8 May 2012 14:02:12 +0300
Message-Id: <1336474934-22069-2-git-send-email-yoni.divinsky@ti.com> (sfid-20120508_130733_044083_83A9ACC0)
In-Reply-To: <1336474934-22069-1-git-send-email-yoni.divinsky@ti.com>
References: <1336474934-22069-1-git-send-email-yoni.divinsky@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The polarity should be set before the firmware is loaded
since the firmware touches the same register. Access
of the firmware and driver to the same register will
cause a collision since there is no exclusion scheme.

Signed-off-by: Yoni Divinsky <yoni.divinsky@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index d7dd3de..d2ea424 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -989,7 +989,7 @@ out:
 
 static void wl12xx_pre_upload(struct wl1271 *wl)
 {
-	u32 tmp;
+	u32 tmp, polarity;
 
 	/* write firmware's last address (ie. it's length) to
 	 * ACX_EEPROMLESS_IND_REG */
@@ -1009,18 +1009,18 @@ static void wl12xx_pre_upload(struct wl1271 *wl)
 
 	if (wl->chip.id == CHIP_ID_1283_PG20)
 		wl12xx_top_reg_write(wl, SDIO_IO_DS, HCI_IO_DS_6MA);
-}
-
-static void wl12xx_enable_interrupts(struct wl1271 *wl)
-{
-	u32 polarity;
 
+	/* polarity must be set before the firmware is loaded */
 	polarity = wl12xx_top_reg_read(wl, OCP_REG_POLARITY);
 
 	/* We use HIGH polarity, so unset the LOW bit */
 	polarity &= ~POLARITY_LOW;
 	wl12xx_top_reg_write(wl, OCP_REG_POLARITY, polarity);
 
+}
+
+static void wl12xx_enable_interrupts(struct wl1271 *wl)
+{
 	wlcore_write_reg(wl, REG_INTERRUPT_MASK, WL1271_ACX_ALL_EVENTS_VECTOR);
 
 	wlcore_enable_interrupts(wl);
-- 
1.7.0.4

