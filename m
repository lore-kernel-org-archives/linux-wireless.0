Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40505 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757822Ab2EJJQF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:16:05 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1111470wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:16:04 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 43/78] wl18xx: change board type enum according to new FW
Date: Thu, 10 May 2012 12:13:48 +0300
Message-Id: <1336641263-5761-44-git-send-email-arik@wizery.com> (sfid-20120510_111620_649246_1E8C9438)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add more board types and remove a now unneeded write to SCR_PAD2 setting
the board type.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |   43 +++++++++++++--------------------
 drivers/net/wireless/ti/wl18xx/reg.h  |   15 ++++--------
 2 files changed, 22 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index ddd11d0..f892d37 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -45,12 +45,6 @@
 static char *ht_mode_param;
 static char *board_type_param;
 
-static const u32 wl18xx_board_type_to_scrpad2[NUM_BOARD_TYPES] = {
-	[BOARD_TYPE_FPGA_18XX]		= SCR_PAD2_BOARD_TYPE_FPGA,
-	[BOARD_TYPE_HDK_18XX]		= SCR_PAD2_BOARD_TYPE_HDK,
-	[BOARD_TYPE_DVP_EVB_18XX]	= SCR_PAD2_BOARD_TYPE_DVP_EVB,
-};
-
 static const u8 wl18xx_rate_to_idx_2ghz[] = {
 	/* MCS rates are used only with 11n */
 	15,                            /* WL18XX_CONF_HW_RXTX_RATE_MCS15 */
@@ -604,13 +598,8 @@ out:
 
 static void wl18xx_set_clk(struct wl1271 *wl)
 {
-	struct wl18xx_priv *priv = wl->priv;
 	u32 clk_freq;
 
-	/* write the translated board type to SCR_PAD2 */
-	wl1271_write32(wl, WL18XX_SCR_PAD2,
-		       wl18xx_board_type_to_scrpad2[priv->board_type]);
-
 	wlcore_set_partition(wl, &wl->ptable[PART_TOP_PRCM_ELP_SOC]);
 
 	/* TODO: PG2: apparently we need to read the clk type */
@@ -1046,21 +1035,22 @@ int __devinit wl18xx_probe(struct platform_device *pdev)
 		       sizeof(wl18xx_mimo_ht_cap));
 
 	if (!board_type_param) {
-		board_type_param = kstrdup("dvp_evb", GFP_KERNEL);
-		priv->board_type = BOARD_TYPE_DVP_EVB_18XX;
+		board_type_param = kstrdup("dvp", GFP_KERNEL);
+		priv->board_type = BOARD_TYPE_DVP_18XX;
+	} else if (!strcmp(board_type_param, "fpga")) {
+		priv->board_type = BOARD_TYPE_FPGA_18XX;
+	} else if (!strcmp(board_type_param, "hdk")) {
+		priv->board_type = BOARD_TYPE_HDK_18XX;
+	} else if (!strcmp(board_type_param, "dvp")) {
+		priv->board_type = BOARD_TYPE_DVP_18XX;
+	} else if (!strcmp(board_type_param, "evb")) {
+		priv->board_type = BOARD_TYPE_EVB_18XX;
+	} else if (!strcmp(board_type_param, "com8")) {
+		priv->board_type = BOARD_TYPE_COM8_18XX;
 	} else {
-		if (!strcmp(board_type_param, "fpga"))
-			priv->board_type = BOARD_TYPE_FPGA_18XX;
-		else if (!strcmp(board_type_param, "hdk"))
-			priv->board_type = BOARD_TYPE_HDK_18XX;
-		else if (!strcmp(board_type_param, "dvp_evb"))
-			priv->board_type = BOARD_TYPE_DVP_EVB_18XX;
-		else {
-			wl1271_error("invalid board type '%s'",
-				     board_type_param);
-			wlcore_free_hw(wl);
-			return -EINVAL;
-		}
+		wl1271_error("invalid board type '%s'", board_type_param);
+		wlcore_free_hw(wl);
+		return -EINVAL;
 	}
 
 	wl18xx_conf_init(wl);
@@ -1100,7 +1090,8 @@ module_param_named(ht_mode, ht_mode_param, charp, S_IRUSR);
 MODULE_PARM_DESC(ht_mode, "Force HT mode: wide or mimo");
 
 module_param_named(board_type, board_type_param, charp, S_IRUSR);
-MODULE_PARM_DESC(board_type, "Board type: fpga, hdk or dvp_evb (default)");
+MODULE_PARM_DESC(board_type, "Board type: fpga, hdk, evb, com8 or "
+		 "dvp (default)");
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Luciano Coelho <coelho@ti.com>");
diff --git a/drivers/net/wireless/ti/wl18xx/reg.h b/drivers/net/wireless/ti/wl18xx/reg.h
index 43c480f..1674c1a 100644
--- a/drivers/net/wireless/ti/wl18xx/reg.h
+++ b/drivers/net/wireless/ti/wl18xx/reg.h
@@ -176,20 +176,15 @@ enum {
 };
 
 enum {
-	BOARD_TYPE_FPGA_18XX	= 0,
-	BOARD_TYPE_HDK_18XX	= 1,
-	BOARD_TYPE_DVP_EVB_18XX	= 2,
+	BOARD_TYPE_EVB_18XX     = 0,
+	BOARD_TYPE_DVP_18XX     = 1,
+	BOARD_TYPE_HDK_18XX     = 2,
+	BOARD_TYPE_FPGA_18XX    = 3,
+	BOARD_TYPE_COM8_18XX    = 4,
 
 	NUM_BOARD_TYPES,
 };
 
-/* board type values used by the firmware in the SCR_PAD2 register */
-enum {
-	SCR_PAD2_BOARD_TYPE_FPGA	= 0xB1,
-	SCR_PAD2_BOARD_TYPE_HDK		= 0xB2,
-	SCR_PAD2_BOARD_TYPE_DVP_EVB	= 0xB3,
-};
-
 struct wl18xx_mac_and_phy_params {
 	u8 phy_standalone;
 	u8 rdl;
-- 
1.7.9.5

