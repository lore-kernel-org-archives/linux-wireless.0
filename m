Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40505 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758434Ab2EJJQ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:16:29 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1111470wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:16:29 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 54/78] wl18xx: changed default board_type to HDK
Date: Thu, 10 May 2012 12:13:59 +0300
Message-Id: <1336641263-5761-55-git-send-email-arik@wizery.com> (sfid-20120510_111943_905380_3AB421D9)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

Since the most common board we're using now is an HDK board, change
the default board_type to hdk.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index f5ec6f6..aa227a1 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -43,7 +43,7 @@
 #define WL18XX_RX_CHECKSUM_MASK      0x40
 
 static char *ht_mode_param;
-static char *board_type_param;
+static char *board_type_param = "hdk";
 static bool dc2dc_param = false;
 static int n_antennas_2_param = 1;
 static int n_antennas_5_param = 1;
@@ -1074,10 +1074,7 @@ int __devinit wl18xx_probe(struct platform_device *pdev)
 
 	wl18xx_conf_init(wl);
 
-	if (!board_type_param) {
-		board_type_param = kstrdup("dvp", GFP_KERNEL);
-		priv->board_type = BOARD_TYPE_DVP_18XX;
-	} else if (!strcmp(board_type_param, "fpga")) {
+	if (!strcmp(board_type_param, "fpga")) {
 		priv->board_type = BOARD_TYPE_FPGA_18XX;
 	} else if (!strcmp(board_type_param, "hdk")) {
 		priv->board_type = BOARD_TYPE_HDK_18XX;
@@ -1137,8 +1134,8 @@ module_param_named(ht_mode, ht_mode_param, charp, S_IRUSR);
 MODULE_PARM_DESC(ht_mode, "Force HT mode: wide or mimo");
 
 module_param_named(board_type, board_type_param, charp, S_IRUSR);
-MODULE_PARM_DESC(board_type, "Board type: fpga, hdk, evb, com8 or "
-		 "dvp (default)");
+MODULE_PARM_DESC(board_type, "Board type: fpga, hdk (default), evb, com8 or "
+		 "dvp");
 
 module_param_named(dc2dc, dc2dc_param, bool, S_IRUSR);
 MODULE_PARM_DESC(dc2dc, "External DC2DC: boolean (defaults to false)");
-- 
1.7.9.5

