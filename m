Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:38920 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab2FMOOa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 10:14:30 -0400
Received: from dlelxv30.itg.ti.com ([172.17.2.17])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id q5DEEU94019869
	for <linux-wireless@vger.kernel.org>; Wed, 13 Jun 2012 09:14:30 -0500
Received: from DFLE70.ent.ti.com (dfle70.ent.ti.com [128.247.5.40])
	by dlelxv30.itg.ti.com (8.13.8/8.13.8) with ESMTP id q5DEEUV1022563
	for <linux-wireless@vger.kernel.org>; Wed, 13 Jun 2012 09:14:30 -0500
From: Yair Shapira <yair.shapira@ti.com>
To: <linux-wireless@vger.kernel.org>, <coelho@ti.com>
CC: <yair.shapira@ti.com>
Subject: [PATCH 1/2] wlcore/wl12xx: add suppoprt for HP and SKW FEM radio manufacturers
Date: Wed, 13 Jun 2012 17:14:21 +0300
Message-ID: <1339596862-2488-2-git-send-email-yair.shapira@ti.com> (sfid-20120613_161434_680036_839BFBF8)
In-Reply-To: <1339596862-2488-1-git-send-email-yair.shapira@ti.com>
References: <1339596862-2488-1-git-send-email-yair.shapira@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for HP(High Performance TQS fem type 3) and SKW
(fem type 2). This is done by increasing the number of FEM
manufacturers to 4

Usually FEM parameters from ini file are read from nvs file and
passed to firmware using TEST_CMD_INI_FILE_RADIO_PARAM. Still,
because the nvs file has only place for 2 FEMs, we need to pass the
new FEM types information in one of the available entries

This is done by mapping new fem types 2,3 to entry 0. This solution
works for manual FEM selection. AutoDetect-FEM still support only
fem types 0 and 1

Signed-off-by: Yair Shapira <yair.shapira@ti.com>
---
 drivers/net/wireless/ti/wl12xx/cmd.c |   16 ++++++++++------
 drivers/net/wireless/ti/wlcore/ini.h |   22 +++++++++++++++++-----
 2 files changed, 27 insertions(+), 11 deletions(-)
 mode change 100644 => 100755 drivers/net/wireless/ti/wl12xx/cmd.c
 mode change 100644 => 100755 drivers/net/wireless/ti/wlcore/ini.h

diff --git a/drivers/net/wireless/ti/wl12xx/cmd.c b/drivers/net/wireless/ti/wl12xx/cmd.c
old mode 100644
new mode 100755
index 50ba748..30be784
--- a/drivers/net/wireless/ti/wl12xx/cmd.c
+++ b/drivers/net/wireless/ti/wl12xx/cmd.c
@@ -174,7 +174,7 @@ int wl1271_cmd_radio_parms(struct wl1271 *wl)
 	struct wl1271_nvs_file *nvs = (struct wl1271_nvs_file *)wl->nvs;
 	struct wl1271_radio_parms_cmd *radio_parms;
 	struct wl1271_ini_general_params *gp = &nvs->general_params;
-	int ret;
+	int ret, fem_idx;
 
 	if (!wl->nvs)
 		return -ENODEV;
@@ -185,11 +185,13 @@ int wl1271_cmd_radio_parms(struct wl1271 *wl)
 
 	radio_parms->test.id = TEST_CMD_INI_FILE_RADIO_PARAM;
 
+	fem_idx = WL12XX_FEM_TO_NVS_ENTRY(gp->tx_bip_fem_manufacturer);
+
 	/* 2.4GHz parameters */
 	memcpy(&radio_parms->static_params_2, &nvs->stat_radio_params_2,
 	       sizeof(struct wl1271_ini_band_params_2));
 	memcpy(&radio_parms->dyn_params_2,
-	       &nvs->dyn_radio_params_2[gp->tx_bip_fem_manufacturer].params,
+	       &nvs->dyn_radio_params_2[fem_idx].params,
 	       sizeof(struct wl1271_ini_fem_params_2));
 
 	/* 5GHz parameters */
@@ -197,7 +199,7 @@ int wl1271_cmd_radio_parms(struct wl1271 *wl)
 	       &nvs->stat_radio_params_5,
 	       sizeof(struct wl1271_ini_band_params_5));
 	memcpy(&radio_parms->dyn_params_5,
-	       &nvs->dyn_radio_params_5[gp->tx_bip_fem_manufacturer].params,
+	       &nvs->dyn_radio_params_5[fem_idx].params,
 	       sizeof(struct wl1271_ini_fem_params_5));
 
 	wl1271_dump(DEBUG_CMD, "TEST_CMD_INI_FILE_RADIO_PARAM: ",
@@ -216,7 +218,7 @@ int wl128x_cmd_radio_parms(struct wl1271 *wl)
 	struct wl128x_nvs_file *nvs = (struct wl128x_nvs_file *)wl->nvs;
 	struct wl128x_radio_parms_cmd *radio_parms;
 	struct wl128x_ini_general_params *gp = &nvs->general_params;
-	int ret;
+	int ret, fem_idx;
 
 	if (!wl->nvs)
 		return -ENODEV;
@@ -227,11 +229,13 @@ int wl128x_cmd_radio_parms(struct wl1271 *wl)
 
 	radio_parms->test.id = TEST_CMD_INI_FILE_RADIO_PARAM;
 
+	fem_idx = WL12XX_FEM_TO_NVS_ENTRY(gp->tx_bip_fem_manufacturer);
+
 	/* 2.4GHz parameters */
 	memcpy(&radio_parms->static_params_2, &nvs->stat_radio_params_2,
 	       sizeof(struct wl128x_ini_band_params_2));
 	memcpy(&radio_parms->dyn_params_2,
-	       &nvs->dyn_radio_params_2[gp->tx_bip_fem_manufacturer].params,
+	       &nvs->dyn_radio_params_2[fem_idx].params,
 	       sizeof(struct wl128x_ini_fem_params_2));
 
 	/* 5GHz parameters */
@@ -239,7 +243,7 @@ int wl128x_cmd_radio_parms(struct wl1271 *wl)
 	       &nvs->stat_radio_params_5,
 	       sizeof(struct wl128x_ini_band_params_5));
 	memcpy(&radio_parms->dyn_params_5,
-	       &nvs->dyn_radio_params_5[gp->tx_bip_fem_manufacturer].params,
+	       &nvs->dyn_radio_params_5[fem_idx].params,
 	       sizeof(struct wl128x_ini_fem_params_5));
 
 	radio_parms->fem_vendor_and_options = nvs->fem_vendor_and_options;
diff --git a/drivers/net/wireless/ti/wlcore/ini.h b/drivers/net/wireless/ti/wlcore/ini.h
old mode 100644
new mode 100755
index 4cf9ecc..d24fe3b
--- a/drivers/net/wireless/ti/wlcore/ini.h
+++ b/drivers/net/wireless/ti/wlcore/ini.h
@@ -172,7 +172,19 @@ struct wl128x_ini_fem_params_5 {
 
 /* NVS data structure */
 #define WL1271_INI_NVS_SECTION_SIZE		     468
-#define WL1271_INI_FEM_MODULE_COUNT                  2
+
+/* We have four FEM module types: 0-RFMD, 1-TQS, 2-SKW, 3-TQS_HP */
+#define WL1271_INI_FEM_MODULE_COUNT                  4
+
+/*
+ * In NVS we only store two FEM module entries -
+ *	  FEM modules 0,2,3 are stored in entry 0
+ *	  FEM module 1 is stored in entry 1
+ */
+#define WL12XX_NVS_FEM_MODULE_COUNT                  2
+
+#define WL12XX_FEM_TO_NVS_ENTRY(ini_fem_module)      \
+	((ini_fem_module) == 1 ? 1 : 0)
 
 #define WL1271_INI_LEGACY_NVS_FILE_SIZE              800
 
@@ -188,13 +200,13 @@ struct wl1271_nvs_file {
 	struct {
 		struct wl1271_ini_fem_params_2 params;
 		u8 padding;
-	} dyn_radio_params_2[WL1271_INI_FEM_MODULE_COUNT];
+	} dyn_radio_params_2[WL12XX_NVS_FEM_MODULE_COUNT];
 	struct wl1271_ini_band_params_5 stat_radio_params_5;
 	u8 padding3;
 	struct {
 		struct wl1271_ini_fem_params_5 params;
 		u8 padding;
-	} dyn_radio_params_5[WL1271_INI_FEM_MODULE_COUNT];
+	} dyn_radio_params_5[WL12XX_NVS_FEM_MODULE_COUNT];
 } __packed;
 
 struct wl128x_nvs_file {
@@ -209,12 +221,12 @@ struct wl128x_nvs_file {
 	struct {
 		struct wl128x_ini_fem_params_2 params;
 		u8 padding;
-	} dyn_radio_params_2[WL1271_INI_FEM_MODULE_COUNT];
+	} dyn_radio_params_2[WL12XX_NVS_FEM_MODULE_COUNT];
 	struct wl128x_ini_band_params_5 stat_radio_params_5;
 	u8 padding3;
 	struct {
 		struct wl128x_ini_fem_params_5 params;
 		u8 padding;
-	} dyn_radio_params_5[WL1271_INI_FEM_MODULE_COUNT];
+	} dyn_radio_params_5[WL12XX_NVS_FEM_MODULE_COUNT];
 } __packed;
 #endif
-- 
1.7.9.5

