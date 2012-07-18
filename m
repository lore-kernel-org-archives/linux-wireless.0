Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:54327 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751800Ab2GRMNv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 08:13:51 -0400
Received: by lbgc1 with SMTP id c1so2282323lbg.29
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jul 2012 05:13:48 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 03/14] wl18xx: add support for ht_mode in conf.h
Date: Wed, 18 Jul 2012 15:13:22 +0300
Message-Id: <1342613613-917-4-git-send-email-coelho@ti.com> (sfid-20120718_141401_716276_40CBAB89)
In-Reply-To: <1342613613-917-1-git-send-email-coelho@ti.com>
References: <1342613613-917-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yair Shapira <yair.shapira@ti.com>

ht_mode added to wl18xx conf struct in order to support different modes
from the configuration file, as well as module params, and by default
(working without a conf file and/or no module params).
the hack regarding conf.phy.low_band_component_type for each board
is now explicitly handled after parsing module params.
missing default values to wl18xx config added.
fix string module params not to have defaults (so if empty, param
can be taken from conf file).
update conf version to 3.

Signed-off-by: Yair Shapira <yair.shapira@ti.com>
Signed-off-by: Ido Reis <idor@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl18xx/conf.h |   21 ++++++++-
 drivers/net/wireless/ti/wl18xx/main.c |   83 ++++++++++++++++++++++-----------
 2 files changed, 77 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/conf.h b/drivers/net/wireless/ti/wl18xx/conf.h
index fac0b7e..4d426cc 100644
--- a/drivers/net/wireless/ti/wl18xx/conf.h
+++ b/drivers/net/wireless/ti/wl18xx/conf.h
@@ -23,7 +23,7 @@
 #define __WL18XX_CONF_H__
 
 #define WL18XX_CONF_MAGIC	0x10e100ca
-#define WL18XX_CONF_VERSION	(WLCORE_CONF_VERSION | 0x0002)
+#define WL18XX_CONF_VERSION	(WLCORE_CONF_VERSION | 0x0003)
 #define WL18XX_CONF_MASK	0x0000ffff
 #define WL18XX_CONF_SIZE	(WLCORE_CONF_SIZE + \
 				 sizeof(struct wl18xx_priv_conf))
@@ -84,7 +84,26 @@ struct wl18xx_mac_and_phy_params {
 	u8 padding[1];
 } __packed;
 
+enum wl18xx_ht_mode {
+	/* Default - use MIMO, fallback to SISO20 */
+	HT_MODE_DEFAULT = 0,
+
+	/* Wide - use SISO40 */
+	HT_MODE_WIDE = 1,
+
+	/* Use SISO20 */
+	HT_MODE_SISO20 = 2,
+};
+
+struct wl18xx_ht_settings {
+	/* DEFAULT / WIDE / SISO20 */
+	u8 mode;
+} __packed;
+
 struct wl18xx_priv_conf {
+	/* Module params structures */
+	struct wl18xx_ht_settings ht;
+
 	/* this structure is copied wholesale to FW */
 	struct wl18xx_mac_and_phy_params phy;
 } __packed;
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 8bb21b6..fb284de 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -43,8 +43,8 @@
 
 #define WL18XX_RX_CHECKSUM_MASK      0x40
 
-static char *ht_mode_param = "default";
-static char *board_type_param = "hdk";
+static char *ht_mode_param = NULL;
+static char *board_type_param = NULL;
 static bool checksum_param = false;
 static bool enable_11a_param = true;
 static int num_rx_desc_param = -1;
@@ -494,16 +494,20 @@ static struct wlcore_conf wl18xx_conf = {
 };
 
 static struct wl18xx_priv_conf wl18xx_default_priv_conf = {
+	.ht = {
+		.mode				= HT_MODE_DEFAULT,
+	},
 	.phy = {
 		.phy_standalone			= 0x00,
 		.primary_clock_setting_time	= 0x05,
 		.clock_valid_on_wake_up		= 0x00,
 		.secondary_clock_setting_time	= 0x05,
+		.board_type 			= BOARD_TYPE_HDK_18XX,
 		.rdl				= 0x01,
 		.auto_detect			= 0x00,
 		.dedicated_fem			= FEM_NONE,
 		.low_band_component		= COMPONENT_2_WAY_SWITCH,
-		.low_band_component_type	= 0x05,
+		.low_band_component_type	= 0x06,
 		.high_band_component		= COMPONENT_2_WAY_SWITCH,
 		.high_band_component_type	= 0x09,
 		.tcxo_ldo_voltage		= 0x00,
@@ -1391,27 +1395,44 @@ static int __devinit wl18xx_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto out_free;
 
-	if (!strcmp(board_type_param, "fpga")) {
-		priv->conf.phy.board_type = BOARD_TYPE_FPGA_18XX;
-	} else if (!strcmp(board_type_param, "hdk")) {
-		priv->conf.phy.board_type = BOARD_TYPE_HDK_18XX;
-		/* HACK! Just for now we hardcode HDK to 0x06 */
-		priv->conf.phy.low_band_component_type = 0x06;
-	} else if (!strcmp(board_type_param, "dvp")) {
-		priv->conf.phy.board_type = BOARD_TYPE_DVP_18XX;
-	} else if (!strcmp(board_type_param, "evb")) {
-		priv->conf.phy.board_type = BOARD_TYPE_EVB_18XX;
-	} else if (!strcmp(board_type_param, "com8")) {
-		priv->conf.phy.board_type = BOARD_TYPE_COM8_18XX;
-		/* HACK! Just for now we hardcode COM8 to 0x06 */
+	/* If the module param is set, update it in conf */
+	if (board_type_param) {
+		if (!strcmp(board_type_param, "fpga")) {
+			priv->conf.phy.board_type = BOARD_TYPE_FPGA_18XX;
+		} else if (!strcmp(board_type_param, "hdk")) {
+			priv->conf.phy.board_type = BOARD_TYPE_HDK_18XX;
+		} else if (!strcmp(board_type_param, "dvp")) {
+			priv->conf.phy.board_type = BOARD_TYPE_DVP_18XX;
+		} else if (!strcmp(board_type_param, "evb")) {
+			priv->conf.phy.board_type = BOARD_TYPE_EVB_18XX;
+		} else if (!strcmp(board_type_param, "com8")) {
+			priv->conf.phy.board_type = BOARD_TYPE_COM8_18XX;
+		} else {
+			wl1271_error("invalid board type '%s'",
+				board_type_param);
+			ret = -EINVAL;
+			goto out_free;
+		}
+	}
+
+	/* HACK! Just for now we hardcode COM8 and HDK to 0x06 */
+	switch (priv->conf.phy.board_type) {
+	case BOARD_TYPE_HDK_18XX:
+	case BOARD_TYPE_COM8_18XX:
 		priv->conf.phy.low_band_component_type = 0x06;
-	} else {
-		wl1271_error("invalid board type '%s'", board_type_param);
+		break;
+	case BOARD_TYPE_FPGA_18XX:
+	case BOARD_TYPE_DVP_18XX:
+	case BOARD_TYPE_EVB_18XX:
+		priv->conf.phy.low_band_component_type = 0x05;
+		break;
+	default:
+		wl1271_error("invalid board type '%d'",
+			priv->conf.phy.board_type);
 		ret = -EINVAL;
 		goto out_free;
 	}
 
-	/* If the module param is set, update it in conf */
 	if (low_band_component_param != -1)
 		priv->conf.phy.low_band_component = low_band_component_param;
 	if (low_band_component_type_param != -1)
@@ -1432,7 +1453,21 @@ static int __devinit wl18xx_probe(struct platform_device *pdev)
 	if (dc2dc_param != -1)
 		priv->conf.phy.external_pa_dc2dc = dc2dc_param;
 
-	if (!strcmp(ht_mode_param, "default")) {
+	if (ht_mode_param) {
+		if (!strcmp(ht_mode_param, "default"))
+			priv->conf.ht.mode = HT_MODE_DEFAULT;
+		else if (!strcmp(ht_mode_param, "wide"))
+			priv->conf.ht.mode = HT_MODE_WIDE;
+		else if (!strcmp(ht_mode_param, "siso20"))
+			priv->conf.ht.mode = HT_MODE_SISO20;
+		else {
+			wl1271_error("invalid ht_mode '%s'", ht_mode_param);
+			ret = -EINVAL;
+			goto out_free;
+		}
+	}
+
+	if (priv->conf.ht.mode == HT_MODE_DEFAULT) {
 		/*
 		 * Only support mimo with multiple antennas. Fall back to
 		 * siso20.
@@ -1447,20 +1482,16 @@ static int __devinit wl18xx_probe(struct platform_device *pdev)
 		/* 5Ghz is always wide */
 		wlcore_set_ht_cap(wl, IEEE80211_BAND_5GHZ,
 				  &wl18xx_siso40_ht_cap_5ghz);
-	} else if (!strcmp(ht_mode_param, "wide")) {
+	} else if (priv->conf.ht.mode == HT_MODE_WIDE) {
 		wlcore_set_ht_cap(wl, IEEE80211_BAND_2GHZ,
 				  &wl18xx_siso40_ht_cap_2ghz);
 		wlcore_set_ht_cap(wl, IEEE80211_BAND_5GHZ,
 				  &wl18xx_siso40_ht_cap_5ghz);
-	} else if (!strcmp(ht_mode_param, "siso20")) {
+	} else if (priv->conf.ht.mode == HT_MODE_SISO20) {
 		wlcore_set_ht_cap(wl, IEEE80211_BAND_2GHZ,
 				  &wl18xx_siso20_ht_cap);
 		wlcore_set_ht_cap(wl, IEEE80211_BAND_5GHZ,
 				  &wl18xx_siso20_ht_cap);
-	} else {
-		wl1271_error("invalid ht_mode '%s'", ht_mode_param);
-		ret = -EINVAL;
-		goto out_free;
 	}
 
 	if (!checksum_param) {
-- 
1.7.10.4

