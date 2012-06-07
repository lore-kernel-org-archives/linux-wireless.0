Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:58453 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751488Ab2FGJRh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 05:17:37 -0400
Received: by lbbgh12 with SMTP id gh12so427965lbb.11
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 02:17:34 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Ido Reis <idor@ti.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 2/5] wl18xx: support PG2 version of the chip
Date: Thu,  7 Jun 2012 12:17:22 +0300
Message-Id: <1339060645-3574-3-git-send-email-coelho@ti.com> (sfid-20120607_111741_691270_BFC94783)
In-Reply-To: <1339060645-3574-1-git-send-email-coelho@ti.com>
References: <1339060645-3574-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Reis <idor@ti.com>

PG2 has a unique chip id. It supports similar HW quirks.

Signed-off-by: Ido Reis <idor@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |   12 +++++++++++-
 drivers/net/wireless/ti/wl18xx/reg.h  |    1 +
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index e030b12..57b4a10 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -588,6 +588,17 @@ static int wl18xx_identify_chip(struct wl1271 *wl)
 	int ret = 0;
 
 	switch (wl->chip.id) {
+	case CHIP_ID_185x_PG20:
+		wl1271_debug(DEBUG_BOOT, "chip id 0x%x (185x PG20)",
+				 wl->chip.id);
+		wl->sr_fw_name = WL18XX_FW_NAME;
+		/* wl18xx uses the same firmware for PLT */
+		wl->plt_fw_name = WL18XX_FW_NAME;
+		wl->quirks |= WLCORE_QUIRK_NO_ELP |
+			      WLCORE_QUIRK_FWLOG_NOT_IMPLEMENTED |
+			      WLCORE_QUIRK_RX_BLOCKSIZE_ALIGN;
+
+		break;
 	case CHIP_ID_185x_PG10:
 		wl1271_debug(DEBUG_BOOT, "chip id 0x%x (185x PG10)",
 			     wl->chip.id);
@@ -602,7 +613,6 @@ static int wl18xx_identify_chip(struct wl1271 *wl)
 		/* PG 1.0 has some problems with MCS_13, so disable it */
 		wl->ht_cap[IEEE80211_BAND_2GHZ].mcs.rx_mask[1] &= ~BIT(5);
 
-		/* TODO: need to blocksize alignment for RX/TX separately? */
 		break;
 	default:
 		wl1271_warning("unsupported chip id: 0x%x", wl->chip.id);
diff --git a/drivers/net/wireless/ti/wl18xx/reg.h b/drivers/net/wireless/ti/wl18xx/reg.h
index 43863d3..e81f609 100644
--- a/drivers/net/wireless/ti/wl18xx/reg.h
+++ b/drivers/net/wireless/ti/wl18xx/reg.h
@@ -140,6 +140,7 @@
 #define WL18XX_FW_STATUS_ADDR		0x50F8
 
 #define CHIP_ID_185x_PG10              (0x06030101)
+#define CHIP_ID_185x_PG20              (0x06030111)
 
 /*
  * Host Command Interrupt. Setting this bit masks
-- 
1.7.10

