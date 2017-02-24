Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:33648 "EHLO
        mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751301AbdBXWay (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Feb 2017 17:30:54 -0500
Received: by mail-lf0-f41.google.com with SMTP id l12so14438869lfe.0
        for <linux-wireless@vger.kernel.org>; Fri, 24 Feb 2017 14:30:10 -0800 (PST)
From: Waldemar Rymarkiewicz <ext.waldemar.rymarkiewicz@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@qca.qualcomm.com, jouni@qca.qualcomm.com,
        Waldemar Rymarkiewicz <ext.waldemar.rymarkiewicz@tieto.com>
Subject: [PATCH v4] ath10k: search SMBIOS for OEM board file extension
Date: Fri, 24 Feb 2017 23:30:03 +0100
Message-Id: <20170224223003.32156-1-ext.waldemar.rymarkiewicz@tieto.com> (sfid-20170224_233058_784389_50302969)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Board Data File (BDF) is loaded upon driver boot-up procedure. The right
board data file is identified, among others, by device and sybsystem ids.

The problem, however, can occur when the (default) board data file cannot
fulfill with the vendor requirements and it is necessary to use a different
board data file.

To solve the issue QCA uses SMBIOS type 0xF8 to store Board Data File Name
Extension to specify the extension/variant name. The driver will take the
extension suffix into consideration and will load the right (non-default)
board data file if necessary.

If it is unnecessary to use extension board data file, please leave the
SMBIOS field blank and default configuration will be used.

Example:
If a default board data file for a specific board is identified by a string
      "bus=pci,vendor=168c,device=003e,subsystem-vendor=1028,
       subsystem-device=0310"
then the OEM specific data file, if used, could be identified by variant
suffix:
      "bus=pci,vendor=168c,device=003e,subsystem-vendor=1028,
       subsystem-device=0310,variant=DE_1AB"

If board data file name extension is set but board-2.bin does not contain
board data file for the variant, the driver will fallback to the default
board data file not to break backward compatibility.

Signed-off-by: Waldemar Rymarkiewicz <ext.waldemar.rymarkiewicz@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 101 ++++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/core.h |  19 +++++++
 2 files changed, 117 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index dd902b43f8f7..0a8e29e9a0eb 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -18,6 +18,8 @@
 #include <linux/module.h>
 #include <linux/firmware.h>
 #include <linux/of.h>
+#include <linux/dmi.h>
+#include <linux/ctype.h>
 #include <asm/byteorder.h>
 
 #include "core.h"
@@ -711,6 +713,72 @@ static int ath10k_core_get_board_id_from_otp(struct ath10k *ar)
 	return 0;
 }
 
+static void ath10k_core_check_bdfext(const struct dmi_header *hdr, void *data)
+{
+	struct ath10k *ar = data;
+	const char *bdf_ext;
+	const char *magic = ATH10K_SMBIOS_BDF_EXT_MAGIC;
+	u8 bdf_enabled;
+	int i;
+
+	if (hdr->type != ATH10K_SMBIOS_BDF_EXT_TYPE)
+		return;
+
+	if (hdr->length != ATH10K_SMBIOS_BDF_EXT_LENGTH) {
+		ath10k_dbg(ar, ATH10K_DBG_BOOT,
+			   "wrong smbios bdf ext type length (%d).\n",
+			   hdr->length);
+		return;
+	}
+
+	bdf_enabled = *((u8 *)hdr + ATH10K_SMBIOS_BDF_EXT_OFFSET);
+	if (!bdf_enabled) {
+		ath10k_dbg(ar, ATH10K_DBG_BOOT, "bdf variant name not found.\n");
+		return;
+	}
+
+	/* Only one string exists (per spec) */
+	bdf_ext = (char *)hdr + hdr->length;
+
+	if (memcmp(bdf_ext, magic, strlen(magic)) != 0) {
+		ath10k_dbg(ar, ATH10K_DBG_BOOT,
+			   "bdf variant magic does not match.\n");
+		return;
+	}
+
+	for (i = 0; i < strlen(bdf_ext); i++) {
+		if (!isascii(bdf_ext[i]) || !isprint(bdf_ext[i])) {
+			ath10k_dbg(ar, ATH10K_DBG_BOOT,
+				   "bdf variant name contains non ascii chars.\n");
+			return;
+		}
+	}
+
+	/* Copy extension name without magic suffix */
+	if (strscpy(ar->id.bdf_ext, bdf_ext + strlen(magic),
+		    sizeof(ar->id.bdf_ext)) < 0) {
+		ath10k_dbg(ar, ATH10K_DBG_BOOT,
+			   "bdf variant string is longer than the buffer can accommodate (variant: %s)\n",
+			    bdf_ext);
+		return;
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_BOOT,
+		   "found and validated bdf variant smbios_type 0x%x bdf %s\n",
+		   ATH10K_SMBIOS_BDF_EXT_TYPE, bdf_ext);
+}
+
+static int ath10k_core_check_smbios(struct ath10k *ar)
+{
+	ar->id.bdf_ext[0] = '\0';
+	dmi_walk(ath10k_core_check_bdfext, ar);
+
+	if (ar->id.bdf_ext[0] == '\0')
+		return -ENODATA;
+
+	return 0;
+}
+
 static int ath10k_download_and_run_otp(struct ath10k *ar)
 {
 	u32 result, address = ar->hw_params.patch_load_addr;
@@ -1020,6 +1088,23 @@ static int ath10k_core_fetch_board_data_api_n(struct ath10k *ar,
 		case ATH10K_BD_IE_BOARD:
 			ret = ath10k_core_parse_bd_ie_board(ar, data, ie_len,
 							    boardname);
+			if (ret == -ENOENT && ar->id.bdf_ext[0] != '\0') {
+				/* try default bdf if variant was not found */
+				char *s, *v = ",variant=";
+				char boardname2[100];
+
+				strlcpy(boardname2, boardname,
+					sizeof(boardname2));
+
+				s = strstr(boardname2, v);
+				if (s)
+					*s = '\0';  /* strip ",variant=%s" */
+
+				ret = ath10k_core_parse_bd_ie_board(ar, data,
+								    ie_len,
+								    boardname2);
+			}
+
 			if (ret == -ENOENT)
 				/* no match found, continue */
 				break;
@@ -1057,6 +1142,9 @@ static int ath10k_core_fetch_board_data_api_n(struct ath10k *ar,
 static int ath10k_core_create_board_name(struct ath10k *ar, char *name,
 					 size_t name_len)
 {
+	/* strlen(',variant=') + strlen(ar->id.bdf_ext) */
+	char variant[9 + ATH10K_SMBIOS_BDF_EXT_STR_LENGTH] = { 0 };
+
 	if (ar->id.bmi_ids_valid) {
 		scnprintf(name, name_len,
 			  "bus=%s,bmi-chip-id=%d,bmi-board-id=%d",
@@ -1066,12 +1154,15 @@ static int ath10k_core_create_board_name(struct ath10k *ar, char *name,
 		goto out;
 	}
 
+	if (ar->id.bdf_ext[0] != '\0')
+		scnprintf(variant, sizeof(variant), ",variant=%s",
+			  ar->id.bdf_ext);
+
 	scnprintf(name, name_len,
-		  "bus=%s,vendor=%04x,device=%04x,subsystem-vendor=%04x,subsystem-device=%04x",
+		  "bus=%s,vendor=%04x,device=%04x,subsystem-vendor=%04x,subsystem-device=%04x%s",
 		  ath10k_bus_str(ar->hif.bus),
 		  ar->id.vendor, ar->id.device,
-		  ar->id.subsystem_vendor, ar->id.subsystem_device);
-
+		  ar->id.subsystem_vendor, ar->id.subsystem_device, variant);
 out:
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot using board name '%s'\n", name);
 
@@ -2128,6 +2219,10 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 		goto err_free_firmware_files;
 	}
 
+	ret = ath10k_core_check_smbios(ar);
+	if (ret)
+		ath10k_dbg(ar, ATH10K_DBG_BOOT, "bdf variant name not set.\n");
+
 	ret = ath10k_core_fetch_board_file(ar);
 	if (ret) {
 		ath10k_err(ar, "failed to fetch board file: %d\n", ret);
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 757242ef52ac..88d14be7fcce 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -69,6 +69,23 @@
 #define ATH10K_NAPI_BUDGET      64
 #define ATH10K_NAPI_QUOTA_LIMIT 60
 
+/* SMBIOS type containing Board Data File Name Extension */
+#define ATH10K_SMBIOS_BDF_EXT_TYPE 0xF8
+
+/* SMBIOS type structure length (excluding strings-set) */
+#define ATH10K_SMBIOS_BDF_EXT_LENGTH 0x9
+
+/* Offset pointing to Board Data File Name Extension */
+#define ATH10K_SMBIOS_BDF_EXT_OFFSET 0x8
+
+/* Board Data File Name Extension string length.
+ * String format: BDF_<Customer ID>_<Extension>\0
+ */
+#define ATH10K_SMBIOS_BDF_EXT_STR_LENGTH 0x20
+
+/* The magic used by QCA spec */
+#define ATH10K_SMBIOS_BDF_EXT_MAGIC "BDF_"
+
 struct ath10k;
 
 enum ath10k_bus {
@@ -798,6 +815,8 @@ struct ath10k {
 		bool bmi_ids_valid;
 		u8 bmi_board_id;
 		u8 bmi_chip_id;
+
+		char bdf_ext[ATH10K_SMBIOS_BDF_EXT_STR_LENGTH];
 	} id;
 
 	int fw_api;
-- 
2.11.0
