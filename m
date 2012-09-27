Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:47741 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756466Ab2I0Kin (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 06:38:43 -0400
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Yair Shapira <yair.shapira@ti.com>,
	Igal Chernobelsky <igalc@ti.com>
Subject: [PATCH 19/31] wl18xx: number_of_assembled_ant5 indicates if A band is enabled
Date: Thu, 27 Sep 2012 13:37:57 +0300
Message-Id: <1348742289-6587-20-git-send-email-luca@coelho.fi> (sfid-20120927_123944_351339_AB0EC748)
In-Reply-To: <1348742289-6587-1-git-send-email-luca@coelho.fi>
References: <1348742289-6587-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yair Shapira <yair.shapira@ti.com>

Use number_of_assembled_ant5 phy param to indicate if A band is enabled:
if number_of_assembled_ant5 != 0 then it is enabled otherwise it is
disabled.

This aligns with phy implementation that uses this param both to indicate
if band is active and the number of antennas.

This parameter replaces enable_11a module param that was removed.

User-Space applications can use wlconf and/or INI files to disable A band
using this parameter.

Signed-off-by: Yair Shapira <yair.shapira@ti.com>
Signed-off-by: Igal Chernobelsky <igalc@ti.com>
Signed-off-by: Luciano Coelho <luca@coelho.fi>
---
 drivers/net/wireless/ti/wl18xx/main.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 93b148f..ae6920b 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -45,7 +45,6 @@
 static char *ht_mode_param = NULL;
 static char *board_type_param = NULL;
 static bool checksum_param = false;
-static bool enable_11a_param = true;
 static int num_rx_desc_param = -1;
 
 /* phy paramters */
@@ -1502,7 +1501,8 @@ static int __devinit wl18xx_probe(struct platform_device *pdev)
 		wl18xx_ops.init_vif = NULL;
 	}
 
-	wl->enable_11a = enable_11a_param;
+	/* Enable 11a Band only if we have 5G antennas */
+	wl->enable_11a = (priv->conf.phy.number_of_assembled_ant5 != 0);
 
 	return wlcore_probe(wl, pdev);
 
@@ -1539,9 +1539,6 @@ MODULE_PARM_DESC(board_type, "Board type: fpga, hdk (default), evb, com8 or "
 module_param_named(checksum, checksum_param, bool, S_IRUSR);
 MODULE_PARM_DESC(checksum, "Enable TCP checksum: boolean (defaults to false)");
 
-module_param_named(enable_11a, enable_11a_param, bool, S_IRUSR);
-MODULE_PARM_DESC(enable_11a, "Enable 11a (5GHz): boolean (defaults to true)");
-
 module_param_named(dc2dc, dc2dc_param, int, S_IRUSR);
 MODULE_PARM_DESC(dc2dc, "External DC2DC: u8 (defaults to 0)");
 
-- 
1.7.10.4

