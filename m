Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:47018 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015Ab1CFO2P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 09:28:15 -0500
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id p26ESEXE015824
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Sun, 6 Mar 2011 08:28:14 -0600
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>
Subject: [PATCH 05/15] wl12xx: 1281/1283 support - Loading FW & NVS
Date: Sun,  6 Mar 2011 16:32:10 +0200
Message-Id: <1299421940-26292-6-git-send-email-shahar_levi@ti.com>
In-Reply-To: <1299421940-26292-1-git-send-email-shahar_levi@ti.com>
References: <1299421940-26292-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Take care of FW & NVS with the auto-detection between wl127x and
wl128x.

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
 drivers/net/wireless/wl12xx/boot.c      |   86 ++++++++++++++++++++-----------
 drivers/net/wireless/wl12xx/cmd.c       |   11 ++--
 drivers/net/wireless/wl12xx/main.c      |    9 ++-
 drivers/net/wireless/wl12xx/sdio_test.c |    9 +++-
 drivers/net/wireless/wl12xx/testmode.c  |   22 ++++++--
 drivers/net/wireless/wl12xx/wl12xx.h    |    2 +-
 6 files changed, 93 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index 69fe870..7984631 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -240,36 +240,62 @@ static int wl1271_boot_upload_nvs(struct wl1271 *wl)
 	u32 dest_addr, val;
 	u8 *nvs_ptr, *nvs_aligned;
 
-	if (wl->nvs == NULL)
-		return -ENODEV;
+	if (wl->chip.id == CHIP_ID_1283_PG20) {
+		struct wl128x_nvs_file *nvs = (struct wl128x_nvs_file *)wl->nvs;
+
+		if (nvs == NULL)
+			return -ENODEV;
+
+		if (wl->nvs_len == sizeof(struct wl128x_nvs_file)) {
+			if (nvs->general_params.dual_mode_select)
+				wl->enable_11a = true;
+		} else {
+			wl1271_error("nvs size is not as expected: %zu != %zu",
+				     wl->nvs_len,
+				     sizeof(struct wl128x_nvs_file));
+			kfree(nvs);
+			nvs = NULL;
+			wl->nvs_len = 0;
+			return -EILSEQ;
+		}
 
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
+		/* only the first part of the NVS needs to be uploaded */
+		nvs_len = sizeof(nvs->nvs);
+		nvs_ptr = (u8 *)nvs->nvs;
 
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
+	} else {
+		struct wl1271_nvs_file *nvs = (struct wl1271_nvs_file *)wl->nvs;
 
-	/* only the first part of the NVS needs to be uploaded */
-	nvs_len = sizeof(wl->nvs->nvs);
-	nvs_ptr = (u8 *)wl->nvs->nvs;
+		if (nvs == NULL)
+			return -ENODEV;
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
+			kfree(nvs);
+			nvs = NULL;
+			wl->nvs_len = 0;
+			return -EILSEQ;
+		}
+
+		/* only the first part of the NVS needs to be uploaded */
+		nvs_len = sizeof(nvs->nvs);
+		nvs_ptr = (u8 *)nvs->nvs;
+	}
 
 	/* update current MAC address to NVS */
 	nvs_ptr[11] = wl->mac_addr[0];
@@ -320,9 +346,9 @@ static int wl1271_boot_upload_nvs(struct wl1271 *wl)
 	 * We've reached the first zero length, the first NVS table
 	 * is located at an aligned offset which is at least 7 bytes further.
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
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 0a23a9e..4823897 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -813,7 +813,10 @@ static int wl1271_fetch_firmware(struct wl1271 *wl)
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
@@ -869,7 +872,7 @@ static int wl1271_fetch_nvs(struct wl1271 *wl)
 		return ret;
 	}
 
-	wl->nvs = kmemdup(fw->data, sizeof(struct wl1271_nvs_file), GFP_KERNEL);
+	wl->nvs = kmemdup(fw->data, fw->size, GFP_KERNEL);
 
 	if (!wl->nvs) {
 		wl1271_error("could not allocate memory for the nvs file");
@@ -3297,7 +3300,7 @@ int wl1271_register_hw(struct wl1271 *wl)
 
 	ret = wl1271_fetch_nvs(wl);
 	if (ret == 0) {
-		u8 *nvs_ptr = (u8 *)wl->nvs->nvs;
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
index e64403b..7cd5093 100644
--- a/drivers/net/wireless/wl12xx/testmode.c
+++ b/drivers/net/wireless/wl12xx/testmode.c
@@ -27,6 +27,7 @@
 
 #include "wl12xx.h"
 #include "acx.h"
+#include "reg.h"
 
 #define WL1271_TM_MAX_DATA_LENGTH 1024
 
@@ -204,11 +205,22 @@ static int wl1271_tm_cmd_nvs_push(struct wl1271 *wl, struct nlattr *tb[])
 
 	kfree(wl->nvs);
 
-	wl->nvs = kzalloc(sizeof(struct wl1271_nvs_file), GFP_KERNEL);
-	if (!wl->nvs) {
-		wl1271_error("could not allocate memory for the nvs file");
-		ret = -ENOMEM;
-		goto out;
+	if (wl->chip.id == CHIP_ID_1283_PG20) {
+		wl->nvs = kzalloc(sizeof(struct wl128x_nvs_file), GFP_KERNEL);
+		if (!wl->nvs) {
+			wl1271_error("could not allocate memory for the nvs "
+				     "file");
+			ret = -ENOMEM;
+			goto out;
+		}
+	} else {
+		wl->nvs = kzalloc(sizeof(struct wl1271_nvs_file), GFP_KERNEL);
+		if (!wl->nvs) {
+			wl1271_error("could not allocate memory for the nvs "
+				     "file");
+			ret = -ENOMEM;
+			goto out;
+		}
 	}
 
 	memcpy(wl->nvs, buf, len);
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 3c3bde9..cc7f01c 100644
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
1.7.0.4

