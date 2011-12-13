Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:48784 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750764Ab1LMJkx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Dec 2011 04:40:53 -0500
Received: by mail-lpp01m010-f41.google.com with SMTP id i5so3061381lah.14
        for <linux-wireless@vger.kernel.org>; Tue, 13 Dec 2011 01:40:52 -0800 (PST)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Subject: [PATCH] wl12xx: call extended radio parameters for wl127x AP mode
Date: Tue, 13 Dec 2011 11:39:50 +0200
Message-Id: <1323769190-20559-1-git-send-email-coelho@ti.com> (sfid-20111213_104055_502669_2A9AE230)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We need to set the extended radio parameters for wl127x only.
Currently, we were only calling this command with wl127x STA mode, but
we should also do it for AP mode.

Move the call to the extended radio paramaters to the common hw_init
and use a single if for the chip type to do everything at once.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/init.c |   31 +++++++++++++++----------------
 1 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index 88891cd..7662514 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -328,12 +328,6 @@ static int wl1271_sta_hw_init(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	int ret;
 
-	if (wl->chip.id != CHIP_ID_1283_PG20) {
-		ret = wl1271_cmd_ext_radio_parms(wl);
-		if (ret < 0)
-			return ret;
-	}
-
 	/* PS config */
 	ret = wl12xx_acx_config_ps(wl, wlvif);
 	if (ret < 0)
@@ -659,19 +653,24 @@ int wl1271_hw_init(struct wl1271 *wl)
 {
 	int ret;
 
-	if (wl->chip.id == CHIP_ID_1283_PG20)
+	if (wl->chip.id == CHIP_ID_1283_PG20) {
 		ret = wl128x_cmd_general_parms(wl);
-	else
-		ret = wl1271_cmd_general_parms(wl);
-	if (ret < 0)
-		return ret;
-
-	if (wl->chip.id == CHIP_ID_1283_PG20)
+		if (ret < 0)
+			return ret;
 		ret = wl128x_cmd_radio_parms(wl);
-	else
+		if (ret < 0)
+			return ret;
+	} else {
+		ret = wl1271_cmd_general_parms(wl);
+		if (ret < 0)
+			return ret;
 		ret = wl1271_cmd_radio_parms(wl);
-	if (ret < 0)
-		return ret;
+		if (ret < 0)
+			return ret;
+		ret = wl1271_cmd_ext_radio_parms(wl);
+		if (ret < 0)
+			return ret;
+	}
 
 	/* Chip-specific init */
 	ret = wl1271_chip_specific_init(wl);
-- 
1.7.4.1

