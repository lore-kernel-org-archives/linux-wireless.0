Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61669 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758320Ab2EJJQL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:16:11 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1110716wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:16:11 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 46/78] wl18xx: change the low_band_component_type for HDK boards
Date: Thu, 10 May 2012 12:13:51 +0300
Message-Id: <1336641263-5761-47-git-send-email-arik@wizery.com> (sfid-20120510_112050_971477_D0C66436)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

Currently, all HDK boards use low_band_component_type 0x06.  In the
future this may change, but for now, we hardcode this value when the
board_type is set to HDK.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 5940829..f14141b 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1051,6 +1051,8 @@ int __devinit wl18xx_probe(struct platform_device *pdev)
 		priv->board_type = BOARD_TYPE_FPGA_18XX;
 	} else if (!strcmp(board_type_param, "hdk")) {
 		priv->board_type = BOARD_TYPE_HDK_18XX;
+		/* HACK! Just for now we hardcode HDK to 0x06 */
+		priv->conf.phy.low_band_component_type = 0x06;
 	} else if (!strcmp(board_type_param, "dvp")) {
 		priv->board_type = BOARD_TYPE_DVP_18XX;
 	} else if (!strcmp(board_type_param, "evb")) {
-- 
1.7.9.5

