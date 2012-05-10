Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51169 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758745Ab2EJJRK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:17:10 -0400
Received: by mail-wi0-f172.google.com with SMTP id hr2so244170wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:17:09 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 72/78] wl18xx: export low/high band component values as module params
Date: Thu, 10 May 2012 12:14:17 +0300
Message-Id: <1336641263-5761-73-git-send-email-arik@wizery.com> (sfid-20120510_111740_939653_9EF1E92B)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

We use hardcoded values for the different board types.  In some cases
we may need to override the defaults, so export the values as module
params.  If not defined, the defaults for the specified board type
will be used.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |   46 +++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index ab3dd11..6baeb26b 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -49,6 +49,10 @@ static int n_antennas_2_param = 1;
 static int n_antennas_5_param = 1;
 static bool checksum_param = true;
 static bool enable_11a_param = true;
+static int low_band_component = -1;
+static int low_band_component_type = -1;
+static int high_band_component = -1;
+static int high_band_component_type = -1;
 
 static const u8 wl18xx_rate_to_idx_2ghz[] = {
 	/* MCS rates are used only with 11n */
@@ -1160,6 +1164,32 @@ int __devinit wl18xx_probe(struct platform_device *pdev)
 		goto out_free;
 	}
 
+	/*
+	 * If the module param is not set, update it with the one from
+	 * conf.  If it is set, overwrite conf with it.
+	 */
+	if (low_band_component == -1)
+		low_band_component = priv->conf.phy.low_band_component;
+	else
+		priv->conf.phy.low_band_component = low_band_component;
+	if (low_band_component_type == -1)
+		low_band_component_type =
+			priv->conf.phy.low_band_component_type;
+	else
+		priv->conf.phy.low_band_component_type =
+			low_band_component_type;
+
+	if (high_band_component == -1)
+		high_band_component = priv->conf.phy.high_band_component;
+	else
+		priv->conf.phy.high_band_component = high_band_component;
+	if (high_band_component_type == -1)
+		high_band_component_type =
+			priv->conf.phy.high_band_component_type;
+	else
+		priv->conf.phy.high_band_component_type =
+			high_band_component_type;
+
 	if (!checksum_param) {
 		wl18xx_ops.set_rx_csum = NULL;
 		wl18xx_ops.init_vif = NULL;
@@ -1224,6 +1254,22 @@ MODULE_PARM_DESC(checksum, "Enable TCP checksum: boolean (defaults to true)");
 module_param_named(enable_11a, enable_11a_param, bool, S_IRUSR);
 MODULE_PARM_DESC(enable_11a, "Enable 11a (5GHz): boolean (defaults to true)");
 
+module_param(low_band_component, uint, S_IRUSR);
+MODULE_PARM_DESC(low_band_component, "Low band component: u8 "
+		 "(default is 0x01)");
+
+module_param(low_band_component_type, uint, S_IRUSR);
+MODULE_PARM_DESC(low_band_component_type, "Low band component type: u8 "
+		 "(default is 0x05 or 0x06 depending on the board_type)");
+
+module_param(high_band_component, uint, S_IRUSR);
+MODULE_PARM_DESC(high_band_component, "High band component: u8, "
+		 "(default is 0x01)");
+
+module_param(high_band_component_type, uint, S_IRUSR);
+MODULE_PARM_DESC(high_band_component_type, "High band component type: u8 "
+		 "(default is 0x09)");
+
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Luciano Coelho <coelho@ti.com>");
 MODULE_FIRMWARE(WL18XX_FW_NAME);
-- 
1.7.9.5

