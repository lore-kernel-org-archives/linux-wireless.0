Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:56957 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756723Ab1CROUR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 10:20:17 -0400
Received: by mail-ww0-f41.google.com with SMTP id 18so1186781wwi.2
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 07:20:12 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: shahar_levi@ti.com, ruthyz@ti.com
Subject: [PATCH v2 07/14] wl12xx: 1281/1283 support - Loading FW & NVS
Date: Fri, 18 Mar 2011 16:19:22 +0200
Message-Id: <1300457969-19601-8-git-send-email-coelho@ti.com>
In-Reply-To: <1300457969-19601-1-git-send-email-coelho@ti.com>
References: <1300457969-19601-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shahar Levi <shahar_levi@ti.com>

Take care of FW & NVS with the auto-detection between wl127x and
wl128x.

[Moved some common code outside if statements and added notes about
NVS structure assumptions; Fixed a bug when checking the nvs size: if
the size was incorrect, the local nvs variable was set to NULL, it
should be wl->nvs instead. -- Luca]

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
Reviewed-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/boot.c      |   83 ++++++++++++++++++++----------
 drivers/net/wireless/wl12xx/cmd.c       |   11 ++--
 drivers/net/wireless/wl12xx/ini.h       |    4 +-
 drivers/net/wireless/wl12xx/main.c      |   13 ++++-
 drivers/net/wireless/wl12xx/sdio_test.c |    9 +++-
 drivers/net/wireless/wl12xx/testmode.c  |   10 +++-
 drivers/net/wireless/wl12xx/wl12xx.h    |    2 +-
 7 files changed, 89 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index 69fe870..38f3e8b 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -243,33 +243,57 @@ static int wl1271_boot_upload_nvs(struct wl1271 *wl)
 	if (wl->nvs == NULL)
 		return -ENODEV;
 
-	/*
-	 * FIXME: the LEGACY NVS image support (NVS's missing the 5GHz band
-	 * configurations) can be removed when those NVS files stop floating
-	 * around.
-	 */
-	if (wl->nvs_len == sizeof(struct wl1271_nvs_file) ||
-	    wl->nvs_len == WL1271_INI_LEGACY_NVS_FILE_SIZE) {
-		/* for now 11a is unsupported in AP mode */
-		if (wl->bss_type != BSS_TYPE_AP_BSS &&
-		    wl->nvs->general_params.dual_mode_select)
-			wl->enable_11a = true;
-	}
+	if (wl->chip.id == CHIP_ID_1283_PG20) {
+		struct wl128x_nvs_file *nvs = (struct wl128x_nvs_file *)wl->nvs;
+
+		if (wl->nvs_len == sizeof(struct wl128x_nvs_file)) {
+			if (nvs->general_params.dual_mode_select)
+				wl->enable_11a = true;
+		} else {
+			wl1271_error("nvs size is not as expected: %zu != %zu",
+				     wl->nvs_len,
+				     sizeof(struct wl128x_nvs_file));
+			kfree(wl->nvs);
+			wl->nvs = NULL;
+			wl->nvs_len = 0;
+			return -EILSEQ;
+		}
 
-	if (wl->nvs_len != sizeof(struct wl1271_nvs_file) &&
-	    (wl->nvs_len != WL1271_INI_LEGACY_NVS_FILE_SIZE ||
-	     wl->enable_11a)) {
-		wl1271_error("nvs size is not as expected: %zu != %zu",
-			     wl->nvs_len, sizeof(struct wl1271_nvs_file));
-		kfree(wl->nvs);
-		wl->nvs = NULL;
-		wl->nvs_len = 0;
-		return -EILSEQ;
-	}
+		/* only the first part of the NVS needs to be uploaded */
+		nvs_len = sizeof(nvs->nvs);
+		nvs_ptr = (u8 *)nvs->nvs;
 
-	/* only the first part of the NVS needs to be uploaded */
-	nvs_len = sizeof(wl->nvs->nvs);
-	nvs_ptr = (u8 *)wl->nvs->nvs;
+	} else {
+		struct wl1271_nvs_file *nvs =
+			(struct wl1271_nvs_file *)wl->nvs;
+		/*
+		 * FIXME: the LEGACY NVS image support (NVS's missing the 5GHz
+		 * band configurations) can be removed when those NVS files stop
+		 * floating around.
+		 */
+		if (wl->nvs_len == sizeof(struct wl1271_nvs_file) ||
+		    wl->nvs_len == WL1271_INI_LEGACY_NVS_FILE_SIZE) {
+			/* for now 11a is unsupported in AP mode */
+			if (wl->bss_type != BSS_TYPE_AP_BSS &&
+			    nvs->general_params.dual_mode_select)
+				wl->enable_11a = true;
+		}
+
+		if (wl->nvs_len != sizeof(struct wl1271_nvs_file) &&
+		    (wl->nvs_len != WL1271_INI_LEGACY_NVS_FILE_SIZE ||
+		     wl->enable_11a)) {
+			wl1271_error("nvs size is not as expected: %zu != %zu",
+				wl->nvs_len, sizeof(struct wl1271_nvs_file));
+			kfree(wl->nvs);
+			wl->nvs = NULL;
+			wl->nvs_len = 0;
+			return -EILSEQ;
+		}
+
+		/* only the first part of the NVS needs to be uploaded */
+		nvs_len = sizeof(nvs->nvs);
+		nvs_ptr = (u8 *) nvs->nvs;
+	}
 
 	/* update current MAC address to NVS */
 	nvs_ptr[11] = wl->mac_addr[0];
@@ -319,10 +343,13 @@ static int wl1271_boot_upload_nvs(struct wl1271 *wl)
 	/*
 	 * We've reached the first zero length, the first NVS table
 	 * is located at an aligned offset which is at least 7 bytes further.
+	 * NOTE: The wl->nvs->nvs element must be first, in order to
+	 * simplify the casting, we assume it is at the beginning of
+	 * the wl->nvs structure.
 	 */
-	nvs_ptr = (u8 *)wl->nvs->nvs +
-			ALIGN(nvs_ptr - (u8 *)wl->nvs->nvs + 7, 4);
-	nvs_len -= nvs_ptr - (u8 *)wl->nvs->nvs;
+	nvs_ptr = (u8 *)wl->nvs +
+			ALIGN(nvs_ptr - (u8 *)wl->nvs + 7, 4);
+	nvs_len -= nvs_ptr - (u8 *)wl->nvs;
 
 	/* Now we must set the partition correctly */
 	wl1271_set_partition(wl, &part_table[PART_WORK]);
diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 37eb9f3..2468044 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -187,8 +187,9 @@ out:
 
 int wl1271_cmd_radio_parms(struct wl1271 *wl)
 {
+	struct wl1271_nvs_file *nvs = (struct wl1271_nvs_file *)wl->nvs;
 	struct wl1271_radio_parms_cmd *radio_parms;
-	struct wl1271_ini_general_params *gp = &wl->nvs->general_params;
+	struct wl1271_ini_general_params *gp = &nvs->general_params;
 	int ret;
 
 	if (!wl->nvs)
@@ -201,18 +202,18 @@ int wl1271_cmd_radio_parms(struct wl1271 *wl)
 	radio_parms->test.id = TEST_CMD_INI_FILE_RADIO_PARAM;
 
 	/* 2.4GHz parameters */
-	memcpy(&radio_parms->static_params_2, &wl->nvs->stat_radio_params_2,
+	memcpy(&radio_parms->static_params_2, &nvs->stat_radio_params_2,
 	       sizeof(struct wl1271_ini_band_params_2));
 	memcpy(&radio_parms->dyn_params_2,
-	       &wl->nvs->dyn_radio_params_2[gp->tx_bip_fem_manufacturer].params,
+	       &nvs->dyn_radio_params_2[gp->tx_bip_fem_manufacturer].params,
 	       sizeof(struct wl1271_ini_fem_params_2));
 
 	/* 5GHz parameters */
 	memcpy(&radio_parms->static_params_5,
-	       &wl->nvs->stat_radio_params_5,
+	       &nvs->stat_radio_params_5,
 	       sizeof(struct wl1271_ini_band_params_5));
 	memcpy(&radio_parms->dyn_params_5,
-	       &wl->nvs->dyn_radio_params_5[gp->tx_bip_fem_manufacturer].params,
+	       &nvs->dyn_radio_params_5[gp->tx_bip_fem_manufacturer].params,
 	       sizeof(struct wl1271_ini_fem_params_5));
 
 	wl1271_dump(DEBUG_CMD, "TEST_CMD_INI_FILE_RADIO_PARAM: ",
diff --git a/drivers/net/wireless/wl12xx/ini.h b/drivers/net/wireless/wl12xx/ini.h
index 30efcd6..1420c84 100644
--- a/drivers/net/wireless/wl12xx/ini.h
+++ b/drivers/net/wireless/wl12xx/ini.h
@@ -174,7 +174,7 @@ struct wl128x_ini_fem_params_5 {
 #define WL1271_INI_LEGACY_NVS_FILE_SIZE              800
 
 struct wl1271_nvs_file {
-	/* NVS section */
+	/* NVS section - must be first! */
 	u8 nvs[WL1271_INI_NVS_SECTION_SIZE];
 
 	/* INI section */
@@ -195,7 +195,7 @@ struct wl1271_nvs_file {
 } __packed;
 
 struct wl128x_nvs_file {
-	/* NVS section */
+	/* NVS section - must be first! */
 	u8 nvs[WL1271_INI_NVS_SECTION_SIZE];
 
 	/* INI section */
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index e1fd005..fe0cf47 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -804,7 +804,10 @@ static int wl1271_fetch_firmware(struct wl1271 *wl)
 		break;
 	case BSS_TYPE_IBSS:
 	case BSS_TYPE_STA_BSS:
-		fw_name = WL1271_FW_NAME;
+		if (wl->chip.id == CHIP_ID_1283_PG20)
+			fw_name = WL128X_FW_NAME;
+		else
+			fw_name	= WL1271_FW_NAME;
 		break;
 	default:
 		wl1271_error("no compatible firmware for bss_type %d",
@@ -860,7 +863,7 @@ static int wl1271_fetch_nvs(struct wl1271 *wl)
 		return ret;
 	}
 
-	wl->nvs = kmemdup(fw->data, sizeof(struct wl1271_nvs_file), GFP_KERNEL);
+	wl->nvs = kmemdup(fw->data, fw->size, GFP_KERNEL);
 
 	if (!wl->nvs) {
 		wl1271_error("could not allocate memory for the nvs file");
@@ -3289,7 +3292,11 @@ int wl1271_register_hw(struct wl1271 *wl)
 
 	ret = wl1271_fetch_nvs(wl);
 	if (ret == 0) {
-		u8 *nvs_ptr = (u8 *)wl->nvs->nvs;
+		/* NOTE: The wl->nvs->nvs element must be first, in
+		 * order to simplify the casting, we assume it is at
+		 * the beginning of the wl->nvs structure.
+		 */
+		u8 *nvs_ptr = (u8 *)wl->nvs;
 
 		wl->mac_addr[0] = nvs_ptr[11];
 		wl->mac_addr[1] = nvs_ptr[10];
diff --git a/drivers/net/wireless/wl12xx/sdio_test.c b/drivers/net/wireless/wl12xx/sdio_test.c
index 01adf1b..e6e2ad6 100644
--- a/drivers/net/wireless/wl12xx/sdio_test.c
+++ b/drivers/net/wireless/wl12xx/sdio_test.c
@@ -189,7 +189,12 @@ static int wl1271_fetch_firmware(struct wl1271 *wl)
 	const struct firmware *fw;
 	int ret;
 
-	ret = request_firmware(&fw, WL1271_FW_NAME, wl1271_wl_to_dev(wl));
+	if (wl->chip.id == CHIP_ID_1283_PG20)
+		ret = request_firmware(&fw, WL128X_FW_NAME,
+				       wl1271_wl_to_dev(wl));
+	else
+		ret = request_firmware(&fw, WL1271_FW_NAME,
+				       wl1271_wl_to_dev(wl));
 
 	if (ret < 0) {
 		wl1271_error("could not get firmware: %d", ret);
@@ -234,7 +239,7 @@ static int wl1271_fetch_nvs(struct wl1271 *wl)
 		return ret;
 	}
 
-	wl->nvs = kmemdup(fw->data, sizeof(struct wl1271_nvs_file), GFP_KERNEL);
+	wl->nvs = kmemdup(fw->data, fw->size, GFP_KERNEL);
 
 	if (!wl->nvs) {
 		wl1271_error("could not allocate memory for the nvs file");
diff --git a/drivers/net/wireless/wl12xx/testmode.c b/drivers/net/wireless/wl12xx/testmode.c
index e64403b..0863859 100644
--- a/drivers/net/wireless/wl12xx/testmode.c
+++ b/drivers/net/wireless/wl12xx/testmode.c
@@ -27,6 +27,7 @@
 
 #include "wl12xx.h"
 #include "acx.h"
+#include "reg.h"
 
 #define WL1271_TM_MAX_DATA_LENGTH 1024
 
@@ -204,9 +205,14 @@ static int wl1271_tm_cmd_nvs_push(struct wl1271 *wl, struct nlattr *tb[])
 
 	kfree(wl->nvs);
 
-	wl->nvs = kzalloc(sizeof(struct wl1271_nvs_file), GFP_KERNEL);
+	if (wl->chip.id == CHIP_ID_1283_PG20)
+		wl->nvs = kzalloc(sizeof(struct wl128x_nvs_file), GFP_KERNEL);
+	else
+		wl->nvs = kzalloc(sizeof(struct wl1271_nvs_file), GFP_KERNEL);
+
 	if (!wl->nvs) {
-		wl1271_error("could not allocate memory for the nvs file");
+		wl1271_error("could not allocate memory for the nvs "
+			     "file");
 		ret = -ENOMEM;
 		goto out;
 	}
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 959b338..e59f539 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -378,7 +378,7 @@ struct wl1271 {
 	u8 *fw;
 	size_t fw_len;
 	u8 fw_bss_type;
-	struct wl1271_nvs_file *nvs;
+	void *nvs;
 	size_t nvs_len;
 
 	s8 hw_pg_ver;
-- 
1.7.1

