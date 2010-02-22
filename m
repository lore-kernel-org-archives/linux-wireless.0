Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:20495 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672Ab0BVGlX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2010 01:41:23 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 16/22] wl1271: Don't mask interrupts while handling interrupt
Date: Mon, 22 Feb 2010 08:38:36 +0200
Message-Id: <1266820722-20202-17-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't mask firmware interrupts while processing interrupts. This allows the
interrupt handler looping to work efficiently thus reducing interrupt
processing latency.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 4d091eb..a46d323 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -424,8 +424,6 @@ static void wl1271_irq_work(struct work_struct *work)
 	if (ret < 0)
 		goto out;
 
-	wl1271_write32(wl, ACX_REG_INTERRUPT_MASK, WL1271_ACX_INTR_ALL);
-
 	wl1271_fw_status(wl, wl->fw_status);
 	intr = le32_to_cpu(wl->fw_status->intr);
 	if (!intr) {
@@ -464,8 +462,6 @@ static void wl1271_irq_work(struct work_struct *work)
 	}
 
 out_sleep:
-	wl1271_write32(wl, ACX_REG_INTERRUPT_MASK,
-		       WL1271_ACX_INTR_ALL & ~(WL1271_INTR_MASK));
 	wl1271_ps_elp_sleep(wl);
 
 out:
-- 
1.6.3.3

