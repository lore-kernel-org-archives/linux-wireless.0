Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:58066 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760880Ab2FHGbN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 02:31:13 -0400
Received: by lbok6 with SMTP id k6so1459241lbo.18
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 23:31:09 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 4/5] wl18xx: clean up phy module parameters
Date: Fri,  8 Jun 2012 09:30:54 +0300
Message-Id: <1339137055-30095-5-git-send-email-coelho@ti.com> (sfid-20120608_083121_656222_678ED6AA)
In-Reply-To: <1339137055-30095-1-git-send-email-coelho@ti.com>
References: <1339137055-30095-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Give all wl18xx phy module paramters -1 as a default value, indicating
the paramter was not set. Add previous default values to the default
18xx priv conf structure.

Remove the board_type field from wl18xx priv. The field with the same
name inside the phy conf is good enough for our purposes.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl18xx/main.c   |  112 +++++++++++++++----------------
 drivers/net/wireless/ti/wl18xx/wl18xx.h |    2 -
 2 files changed, 56 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 78b2e54..b2ccff7 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -45,16 +45,18 @@
 
 static char *ht_mode_param = "wide";
 static char *board_type_param = "hdk";
-static bool dc2dc_param = false;
-static int n_antennas_2_param = 1;
-static int n_antennas_5_param = 1;
 static bool checksum_param = false;
 static bool enable_11a_param = true;
-static int low_band_component = -1;
-static int low_band_component_type = -1;
-static int high_band_component = -1;
-static int high_band_component_type = -1;
-static int pwr_limit_reference_11_abg = -1;
+
+/* phy paramters */
+static int dc2dc_param = -1;
+static int n_antennas_2_param = -1;
+static int n_antennas_5_param = -1;
+static int low_band_component_param = -1;
+static int low_band_component_type_param = -1;
+static int high_band_component_param = -1;
+static int high_band_component_type_param = -1;
+static int pwr_limit_reference_11_abg_param = -1;
 
 static const u8 wl18xx_rate_to_idx_2ghz[] = {
 	/* MCS rates are used only with 11n */
@@ -516,6 +518,9 @@ static struct wl18xx_priv_conf wl18xx_default_priv_conf = {
 		.low_power_val			= 0x00,
 		.med_power_val			= 0x0a,
 		.high_power_val			= 0x1e,
+		.external_pa_dc2dc		= 0,
+		.number_of_assembled_ant2_4	= 1,
+		.number_of_assembled_ant5	= 1,
 	},
 };
 
@@ -1320,17 +1325,17 @@ static int __devinit wl18xx_probe(struct platform_device *pdev)
 		goto out_free;
 
 	if (!strcmp(board_type_param, "fpga")) {
-		priv->board_type = BOARD_TYPE_FPGA_18XX;
+		priv->conf.phy.board_type = BOARD_TYPE_FPGA_18XX;
 	} else if (!strcmp(board_type_param, "hdk")) {
-		priv->board_type = BOARD_TYPE_HDK_18XX;
+		priv->conf.phy.board_type = BOARD_TYPE_HDK_18XX;
 		/* HACK! Just for now we hardcode HDK to 0x06 */
 		priv->conf.phy.low_band_component_type = 0x06;
 	} else if (!strcmp(board_type_param, "dvp")) {
-		priv->board_type = BOARD_TYPE_DVP_18XX;
+		priv->conf.phy.board_type = BOARD_TYPE_DVP_18XX;
 	} else if (!strcmp(board_type_param, "evb")) {
-		priv->board_type = BOARD_TYPE_EVB_18XX;
+		priv->conf.phy.board_type = BOARD_TYPE_EVB_18XX;
 	} else if (!strcmp(board_type_param, "com8")) {
-		priv->board_type = BOARD_TYPE_COM8_18XX;
+		priv->conf.phy.board_type = BOARD_TYPE_COM8_18XX;
 		/* HACK! Just for now we hardcode COM8 to 0x06 */
 		priv->conf.phy.low_band_component_type = 0x06;
 	} else {
@@ -1339,38 +1344,26 @@ static int __devinit wl18xx_probe(struct platform_device *pdev)
 		goto out_free;
 	}
 
-	/*
-	 * If the module param is not set, update it with the one from
-	 * conf.  If it is set, overwrite conf with it.
-	 */
-	if (low_band_component == -1)
-		low_band_component = priv->conf.phy.low_band_component;
-	else
-		priv->conf.phy.low_band_component = low_band_component;
-	if (low_band_component_type == -1)
-		low_band_component_type =
-			priv->conf.phy.low_band_component_type;
-	else
+	/* If the module param is set, update it in conf */
+	if (low_band_component_param != -1)
+		priv->conf.phy.low_band_component = low_band_component_param;
+	if (low_band_component_type_param != -1)
 		priv->conf.phy.low_band_component_type =
-			low_band_component_type;
-
-	if (high_band_component == -1)
-		high_band_component = priv->conf.phy.high_band_component;
-	else
-		priv->conf.phy.high_band_component = high_band_component;
-	if (high_band_component_type == -1)
-		high_band_component_type =
-			priv->conf.phy.high_band_component_type;
-	else
+			low_band_component_type_param;
+	if (high_band_component_param != -1)
+		priv->conf.phy.high_band_component = high_band_component_param;
+	if (high_band_component_type_param != -1)
 		priv->conf.phy.high_band_component_type =
-			high_band_component_type;
-
-	if (pwr_limit_reference_11_abg == -1)
-		pwr_limit_reference_11_abg =
-			priv->conf.phy.pwr_limit_reference_11_abg;
-	else
+			high_band_component_type_param;
+	if (pwr_limit_reference_11_abg_param != -1)
 		priv->conf.phy.pwr_limit_reference_11_abg =
-			pwr_limit_reference_11_abg;
+			pwr_limit_reference_11_abg_param;
+	if (n_antennas_2_param != -1)
+		priv->conf.phy.number_of_assembled_ant2_4 = n_antennas_2_param;
+	if (n_antennas_5_param != -1)
+		priv->conf.phy.number_of_assembled_ant5 = n_antennas_5_param;
+	if (dc2dc_param != -1)
+		priv->conf.phy.external_pa_dc2dc = dc2dc_param;
 
 	if (!checksum_param) {
 		wl18xx_ops.set_rx_csum = NULL;
@@ -1422,38 +1415,45 @@ module_param_named(board_type, board_type_param, charp, S_IRUSR);
 MODULE_PARM_DESC(board_type, "Board type: fpga, hdk (default), evb, com8 or "
 		 "dvp");
 
-module_param_named(dc2dc, dc2dc_param, bool, S_IRUSR);
-MODULE_PARM_DESC(dc2dc, "External DC2DC: boolean (defaults to false)");
-
-module_param_named(n_antennas_2, n_antennas_2_param, uint, S_IRUSR);
-MODULE_PARM_DESC(n_antennas_2, "Number of installed 2.4GHz antennas: 1 (default) or 2");
-
-module_param_named(n_antennas_5, n_antennas_5_param, uint, S_IRUSR);
-MODULE_PARM_DESC(n_antennas_5, "Number of installed 5GHz antennas: 1 (default) or 2");
-
 module_param_named(checksum, checksum_param, bool, S_IRUSR);
 MODULE_PARM_DESC(checksum, "Enable TCP checksum: boolean (defaults to false)");
 
 module_param_named(enable_11a, enable_11a_param, bool, S_IRUSR);
 MODULE_PARM_DESC(enable_11a, "Enable 11a (5GHz): boolean (defaults to true)");
 
-module_param(low_band_component, uint, S_IRUSR);
+module_param_named(dc2dc, dc2dc_param, int, S_IRUSR);
+MODULE_PARM_DESC(dc2dc, "External DC2DC: u8 (defaults to 0)");
+
+module_param_named(n_antennas_2, n_antennas_2_param, int, S_IRUSR);
+MODULE_PARM_DESC(n_antennas_2,
+		 "Number of installed 2.4GHz antennas: 1 (default) or 2");
+
+module_param_named(n_antennas_5, n_antennas_5_param, int, S_IRUSR);
+MODULE_PARM_DESC(n_antennas_5,
+		 "Number of installed 5GHz antennas: 1 (default) or 2");
+
+module_param_named(low_band_component, low_band_component_param, int,
+		   S_IRUSR);
 MODULE_PARM_DESC(low_band_component, "Low band component: u8 "
 		 "(default is 0x01)");
 
-module_param(low_band_component_type, uint, S_IRUSR);
+module_param_named(low_band_component_type, low_band_component_type_param,
+		   int, S_IRUSR);
 MODULE_PARM_DESC(low_band_component_type, "Low band component type: u8 "
 		 "(default is 0x05 or 0x06 depending on the board_type)");
 
-module_param(high_band_component, uint, S_IRUSR);
+module_param_named(high_band_component, high_band_component_param, int,
+		   S_IRUSR);
 MODULE_PARM_DESC(high_band_component, "High band component: u8, "
 		 "(default is 0x01)");
 
-module_param(high_band_component_type, uint, S_IRUSR);
+module_param_named(high_band_component_type, high_band_component_type_param,
+		   int, S_IRUSR);
 MODULE_PARM_DESC(high_band_component_type, "High band component type: u8 "
 		 "(default is 0x09)");
 
-module_param(pwr_limit_reference_11_abg, uint, S_IRUSR);
+module_param_named(pwr_limit_reference_11_abg,
+		   pwr_limit_reference_11_abg_param, int, S_IRUSR);
 MODULE_PARM_DESC(pwr_limit_reference_11_abg, "Power limit reference: u8 "
 		 "(default is 0xc8)");
 
diff --git a/drivers/net/wireless/ti/wl18xx/wl18xx.h b/drivers/net/wireless/ti/wl18xx/wl18xx.h
index b9c4309..bc67a47 100644
--- a/drivers/net/wireless/ti/wl18xx/wl18xx.h
+++ b/drivers/net/wireless/ti/wl18xx/wl18xx.h
@@ -35,8 +35,6 @@ struct wl18xx_priv {
 	/* Index of last released Tx desc in FW */
 	u8 last_fw_rls_idx;
 
-	u8 board_type;
-
 	/* number of VIFs requiring extra spare mem-blocks */
 	int extra_spare_vif_count;
 };
-- 
1.7.10

