Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50831 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758238Ab2EJJQN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:16:13 -0400
Received: by mail-wi0-f178.google.com with SMTP id hn19so247958wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:16:13 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 47/78] wl18xx: add number of antennas and dc2dc type as module params
Date: Thu, 10 May 2012 12:13:52 +0300
Message-Id: <1336641263-5761-48-git-send-email-arik@wizery.com> (sfid-20120510_112038_488016_C37B808D)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

We need to specify the number of 2.4GHz and 5GHz antennas and whether
the board has an internal or external DC2DC.  Add some module
parameters that allow changing that.

In the future this will come from the "NVS" file.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/conf.h |    3 ---
 drivers/net/wireless/ti/wl18xx/main.c |   21 +++++++++++++++------
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/conf.h b/drivers/net/wireless/ti/wl18xx/conf.h
index d2b097e..a6058fb 100644
--- a/drivers/net/wireless/ti/wl18xx/conf.h
+++ b/drivers/net/wireless/ti/wl18xx/conf.h
@@ -33,9 +33,6 @@ struct wl18xx_conf_phy {
 	u8 low_band_component_type;
 	u8 high_band_component;
 	u8 high_band_component_type;
-	u8 number_of_assembled_ant2_4;
-	u8 number_of_assembled_ant5;
-	u8 external_pa_dc2dc;
 	u8 tcxo_ldo_voltage;
 	u8 xtal_itrim_val;
 	u8 srf_state;
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index f14141b..2f0cbf8 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -44,6 +44,9 @@
 
 static char *ht_mode_param;
 static char *board_type_param;
+static bool dc2dc_param = false;
+static int n_antennas_2_param = 1;
+static int n_antennas_5_param = 1;
 
 static const u8 wl18xx_rate_to_idx_2ghz[] = {
 	/* MCS rates are used only with 11n */
@@ -487,9 +490,6 @@ static struct wl18xx_priv_conf wl18xx_default_priv_conf = {
 		.low_band_component_type	= 0x05,
 		.high_band_component		= COMPONENT_2_WAY_SWITCH,
 		.high_band_component_type	= 0x09,
-		.number_of_assembled_ant2_4	= 0x01,
-		.number_of_assembled_ant5	= 0x01,
-		.external_pa_dc2dc		= 0x00,
 		.tcxo_ldo_voltage		= 0x00,
 		.xtal_itrim_val			= 0x04,
 		.srf_state			= 0x00,
@@ -704,10 +704,10 @@ static void wl18xx_set_mac_and_phy(struct wl1271 *wl)
 	params.high_band_component_type =
 		phy->high_band_component_type;
 	params.number_of_assembled_ant2_4 =
-		phy->number_of_assembled_ant2_4;
+		n_antennas_2_param;
 	params.number_of_assembled_ant5 =
-		phy->number_of_assembled_ant5;
-	params.external_pa_dc2dc = phy->external_pa_dc2dc;
+		n_antennas_5_param;
+	params.external_pa_dc2dc = dc2dc_param;
 	params.tcxo_ldo_voltage = phy->tcxo_ldo_voltage;
 	params.xtal_itrim_val = phy->xtal_itrim_val;
 	params.srf_state = phy->srf_state;
@@ -1105,6 +1105,15 @@ module_param_named(board_type, board_type_param, charp, S_IRUSR);
 MODULE_PARM_DESC(board_type, "Board type: fpga, hdk, evb, com8 or "
 		 "dvp (default)");
 
+module_param_named(dc2dc, dc2dc_param, bool, S_IRUSR);
+MODULE_PARM_DESC(dc2dc, "External DC2DC: boolean (defaults to false)");
+
+module_param_named(n_antennas_2, n_antennas_2_param, uint, S_IRUSR);
+MODULE_PARM_DESC(n_antennas_2, "Number of installed 2.4GHz antennas: 1 (default) or 2");
+
+module_param_named(n_antennas_5, n_antennas_5_param, uint, S_IRUSR);
+MODULE_PARM_DESC(n_antennas_5, "Number of installed 5GHz antennas: 1 (default) or 2");
+
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Luciano Coelho <coelho@ti.com>");
 MODULE_FIRMWARE(WL18XX_FW_NAME);
-- 
1.7.9.5

