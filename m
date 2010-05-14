Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:43395 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757587Ab0ENHeh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 03:34:37 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 2/3] wl1271: Add support for NVS files with 5GHz band parameters
Date: Fri, 14 May 2010 10:34:16 +0300
Message-Id: <1273822457-9194-3-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1273822457-9194-1-git-send-email-luciano.coelho@nokia.com>
References: <1273822457-9194-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

This patch adds support for NVS files with 5GHz band parameters. The change
is done in a backward compatible manner - if 11a is not enabled in the driver,
the driver will allow also old NVS files to be loaded.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.c      |    9 ++++++++-
 drivers/net/wireless/wl12xx/wl1271_ini.h      |   11 ++++++++---
 drivers/net/wireless/wl12xx/wl1271_main.c     |   13 ++++++++++---
 drivers/net/wireless/wl12xx/wl1271_testmode.c |   11 +++++++++--
 4 files changed, 35 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 241b477..d7bcce8 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -238,13 +238,20 @@ int wl1271_cmd_radio_parms(struct wl1271 *wl)
 
 	radio_parms->test.id = TEST_CMD_INI_FILE_RADIO_PARAM;
 
+	/* 2.4GHz parameters */
 	memcpy(&radio_parms->static_params_2, &wl->nvs->stat_radio_params_2,
 	       sizeof(struct wl1271_ini_band_params_2));
 	memcpy(&radio_parms->dyn_params_2,
 	       &wl->nvs->dyn_radio_params_2[rparam->fem].params,
 	       sizeof(struct wl1271_ini_fem_params_2));
 
-	/* FIXME: current NVS is missing 5GHz parameters */
+	/* 5GHz parameters */
+	memcpy(&radio_parms->static_params_5,
+	       &wl->nvs->stat_radio_params_5,
+	       sizeof(struct wl1271_ini_band_params_5));
+	memcpy(&radio_parms->dyn_params_5,
+	       &wl->nvs->dyn_radio_params_5[rparam->fem].params,
+	       sizeof(struct wl1271_ini_fem_params_5));
 
 	wl1271_dump(DEBUG_CMD, "TEST_CMD_INI_FILE_RADIO_PARAM: ",
 		    radio_parms, sizeof(*radio_parms));
diff --git a/drivers/net/wireless/wl12xx/wl1271_ini.h b/drivers/net/wireless/wl12xx/wl1271_ini.h
index d1590bc..0fb156a 100644
--- a/drivers/net/wireless/wl12xx/wl1271_ini.h
+++ b/drivers/net/wireless/wl12xx/wl1271_ini.h
@@ -95,9 +95,10 @@ struct wl1271_ini_fem_params_5 {
 
 /* NVS data structure */
 #define WL1271_INI_NVS_SECTION_SIZE		     468
-#define WL1271_INI_SPARE_SIZE			     124
 #define WL1271_INI_FEM_MODULE_COUNT                  2
 
+#define WL1271_INI_LEGACY_NVS_FILE_SIZE              800
+
 struct wl1271_nvs_file {
 	/* NVS section */
 	u8 nvs[WL1271_INI_NVS_SECTION_SIZE];
@@ -111,8 +112,12 @@ struct wl1271_nvs_file {
 		struct wl1271_ini_fem_params_2 params;
 		u8 padding;
 	} dyn_radio_params_2[WL1271_INI_FEM_MODULE_COUNT];
-
-	u8 ini_spare[WL1271_INI_SPARE_SIZE];
+	struct wl1271_ini_band_params_5 stat_radio_params_5;
+	u8 padding3;
+	struct {
+		struct wl1271_ini_fem_params_5 params;
+		u8 padding;
+	} dyn_radio_params_5[WL1271_INI_FEM_MODULE_COUNT];
 } __attribute__ ((packed));
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 933e432..371c394 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -566,14 +566,21 @@ static int wl1271_fetch_nvs(struct wl1271 *wl)
 		return ret;
 	}
 
-	if (fw->size != sizeof(struct wl1271_nvs_file)) {
+	/*
+	 * FIXME: the LEGACY NVS image support (NVS's missing the 5GHz band
+	 * configurations) can be removed when those NVS files stop floating
+	 * around.
+	 */
+	if (fw->size != sizeof(struct wl1271_nvs_file) &&
+	    (fw->size != WL1271_INI_LEGACY_NVS_FILE_SIZE ||
+	     wl1271_11a_enabled())) {
 		wl1271_error("nvs size is not as expected: %zu != %zu",
 			     fw->size, sizeof(struct wl1271_nvs_file));
 		ret = -EILSEQ;
 		goto out;
 	}
 
-	wl->nvs = kmalloc(sizeof(struct wl1271_nvs_file), GFP_KERNEL);
+	wl->nvs = kzalloc(sizeof(struct wl1271_nvs_file), GFP_KERNEL);
 
 	if (!wl->nvs) {
 		wl1271_error("could not allocate memory for the nvs file");
@@ -581,7 +588,7 @@ static int wl1271_fetch_nvs(struct wl1271 *wl)
 		goto out;
 	}
 
-	memcpy(wl->nvs, fw->data, sizeof(struct wl1271_nvs_file));
+	memcpy(wl->nvs, fw->data, fw->size);
 
 out:
 	release_firmware(fw);
diff --git a/drivers/net/wireless/wl12xx/wl1271_testmode.c b/drivers/net/wireless/wl12xx/wl1271_testmode.c
index 554deb4..6e0952f 100644
--- a/drivers/net/wireless/wl12xx/wl1271_testmode.c
+++ b/drivers/net/wireless/wl12xx/wl1271_testmode.c
@@ -199,7 +199,14 @@ static int wl1271_tm_cmd_nvs_push(struct wl1271 *wl, struct nlattr *tb[])
 	buf = nla_data(tb[WL1271_TM_ATTR_DATA]);
 	len = nla_len(tb[WL1271_TM_ATTR_DATA]);
 
-	if (len != sizeof(struct wl1271_nvs_file)) {
+	/*
+	 * FIXME: the LEGACY NVS image support (NVS's missing the 5GHz band
+	 * configurations) can be removed when those NVS files stop floating
+	 * around.
+	 */
+	if (len != sizeof(struct wl1271_nvs_file) &&
+	    (len != WL1271_INI_LEGACY_NVS_FILE_SIZE ||
+	     wl1271_11a_enabled())) {
 		wl1271_error("nvs size is not as expected: %zu != %zu",
 			     len, sizeof(struct wl1271_nvs_file));
 		return -EMSGSIZE;
@@ -209,7 +216,7 @@ static int wl1271_tm_cmd_nvs_push(struct wl1271 *wl, struct nlattr *tb[])
 
 	kfree(wl->nvs);
 
-	wl->nvs = kmalloc(sizeof(struct wl1271_nvs_file), GFP_KERNEL);
+	wl->nvs = kzalloc(sizeof(struct wl1271_nvs_file), GFP_KERNEL);
 	if (!wl->nvs) {
 		wl1271_error("could not allocate memory for the nvs file");
 		ret = -ENOMEM;
-- 
1.6.3.3

