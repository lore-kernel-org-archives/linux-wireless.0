Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61669 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758060Ab2EJJPm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:15:42 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1110716wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:15:41 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 33/78] wl18xx: translate and write the board type to SCR_PAD2
Date: Thu, 10 May 2012 12:13:38 +0300
Message-Id: <1336641263-5761-34-git-send-email-arik@wizery.com> (sfid-20120510_111555_399325_086291E9)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

The firmware uses the SCR_PAD2 register to read the board type passed
from the driver.  The values don't match the ones used in the mac and
phy configuration, so we need to map them before writing.  This commit
adds a translation table that is used when writing the board type to
SCR_PAD2.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |   16 +++++++++++-----
 drivers/net/wireless/ti/wl18xx/reg.h  |    9 +++++++++
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index e5ebf4a..5214334 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -44,6 +44,12 @@
 static char *ht_mode_param;
 static char *board_type_param;
 
+static const u32 wl18xx_board_type_to_scrpad2[NUM_BOARD_TYPES] = {
+	[BOARD_TYPE_FPGA_18XX]		= SCR_PAD2_BOARD_TYPE_FPGA,
+	[BOARD_TYPE_HDK_18XX]		= SCR_PAD2_BOARD_TYPE_HDK,
+	[BOARD_TYPE_DVP_EVB_18XX]	= SCR_PAD2_BOARD_TYPE_DVP_EVB,
+};
+
 static const u8 wl18xx_rate_to_idx_2ghz[] = {
 	/* MCS rates are used only with 11n */
 	15,                            /* WL18XX_CONF_HW_RXTX_RATE_MCS15 */
@@ -584,11 +590,11 @@ out:
 
 static void wl18xx_set_clk(struct wl1271 *wl)
 {
-	/*
-	 * TODO: this is hardcoded just for DVP/EVB, fix according to
-	 * new unified_drv.
-	 */
-	wl1271_write32(wl, WL18XX_SCR_PAD2, 0xB3);
+	struct wl18xx_priv *priv = wl->priv;
+
+	/* write the translated board type to SCR_PAD2 */
+	wl1271_write32(wl, WL18XX_SCR_PAD2,
+		       wl18xx_board_type_to_scrpad2[priv->board_type]);
 
 	wlcore_set_partition(wl, &wl->ptable[PART_TOP_PRCM_ELP_SOC]);
 	wl1271_write32(wl, 0x00A02360, 0xD0078);
diff --git a/drivers/net/wireless/ti/wl18xx/reg.h b/drivers/net/wireless/ti/wl18xx/reg.h
index 5398799..e0170ae 100644
--- a/drivers/net/wireless/ti/wl18xx/reg.h
+++ b/drivers/net/wireless/ti/wl18xx/reg.h
@@ -154,6 +154,15 @@ enum {
 	BOARD_TYPE_FPGA_18XX	= 0,
 	BOARD_TYPE_HDK_18XX	= 1,
 	BOARD_TYPE_DVP_EVB_18XX	= 2,
+
+	NUM_BOARD_TYPES,
+};
+
+/* board type values used by the firmware in the SCR_PAD2 register */
+enum {
+	SCR_PAD2_BOARD_TYPE_FPGA	= 0xB1,
+	SCR_PAD2_BOARD_TYPE_HDK		= 0xB2,
+	SCR_PAD2_BOARD_TYPE_DVP_EVB	= 0xB3,
 };
 
 struct wl18xx_mac_and_phy_params {
-- 
1.7.9.5

