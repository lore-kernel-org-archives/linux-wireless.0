Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40505 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758738Ab2EJJRM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:17:12 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1111470wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:17:11 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 73/78] wl18xx: export pwr_limit_reference_11_abg value as a module parameter
Date: Thu, 10 May 2012 12:14:18 +0300
Message-Id: <1336641263-5761-74-git-send-email-arik@wizery.com> (sfid-20120510_111720_529406_D6BF22FA)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

Yet another temporary module parameter requested by the firmware team.
This will be replaced by the conf binary.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 6baeb26b..524f44c 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -53,6 +53,7 @@ static int low_band_component = -1;
 static int low_band_component_type = -1;
 static int high_band_component = -1;
 static int high_band_component_type = -1;
+static int pwr_limit_reference_11_abg = -1;
 
 static const u8 wl18xx_rate_to_idx_2ghz[] = {
 	/* MCS rates are used only with 11n */
@@ -1190,6 +1191,13 @@ int __devinit wl18xx_probe(struct platform_device *pdev)
 		priv->conf.phy.high_band_component_type =
 			high_band_component_type;
 
+	if (pwr_limit_reference_11_abg == -1)
+		pwr_limit_reference_11_abg =
+			priv->conf.phy.pwr_limit_reference_11_abg;
+	else
+		priv->conf.phy.pwr_limit_reference_11_abg =
+			pwr_limit_reference_11_abg;
+
 	if (!checksum_param) {
 		wl18xx_ops.set_rx_csum = NULL;
 		wl18xx_ops.init_vif = NULL;
@@ -1270,6 +1278,10 @@ module_param(high_band_component_type, uint, S_IRUSR);
 MODULE_PARM_DESC(high_band_component_type, "High band component type: u8 "
 		 "(default is 0x09)");
 
+module_param(pwr_limit_reference_11_abg, uint, S_IRUSR);
+MODULE_PARM_DESC(pwr_limit_reference_11_abg, "Power limit reference: u8 "
+		 "(default is 0xc8)");
+
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Luciano Coelho <coelho@ti.com>");
 MODULE_FIRMWARE(WL18XX_FW_NAME);
-- 
1.7.9.5

