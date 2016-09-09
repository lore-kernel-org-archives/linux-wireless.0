Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33591 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752323AbcIIPC3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Sep 2016 11:02:29 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org, Marcel Holtmann <marcel@holtmann.org>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-bluetooth@vger.kernel.org,
        =?UTF-8?q?=E9=99=86=E6=9C=B1=E4=BC=9F?= <alex_lu@realsil.com.cn>
Subject: [PATCH] rtlbt: Add RTL8822BE Bluetooth device
Date: Fri,  9 Sep 2016 10:02:05 -0500
Message-Id: <1473433325-25311-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160909_170235_594211_EBDF3154)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The RTL8822BE is a new Realtek wifi and BT device. Support for the BT
part is hereby added.

As this device is similar to most of the other Realtek BT devices, the
changes are minimal. The main difference is that the 8822BE needs a
configuration file for enabling and disabling features. Thus code is
added to select and load this configuration file. Although not needed
at the moment, hooks are added for the other devices that might need
such configuration files.

One additional change is to the routine that tests that the project
ID contained in the firmware matches the hardware. As the project IDs
are not sequential, continuing to use the position in the array as the
expected value of the ID would require adding extra unused entries in
the table, and any subsequant rearrangment of the array would break the
code. To fix these problems, the array elements now contain both the
hardware ID and the expected value for the project ID.

Signed-off-by: 陆朱伟 <alex_lu@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/bluetooth/btrtl.c | 104 ++++++++++++++++++++++++++++++++++++++++------
 drivers/bluetooth/btrtl.h |   5 +++
 2 files changed, 97 insertions(+), 12 deletions(-)

diff --git a/drivers/bluetooth/btrtl.c b/drivers/bluetooth/btrtl.c
index 8428893..cb73863 100644
--- a/drivers/bluetooth/btrtl.c
+++ b/drivers/bluetooth/btrtl.c
@@ -33,6 +33,7 @@
 #define RTL_ROM_LMP_8723B	0x8723
 #define RTL_ROM_LMP_8821A	0x8821
 #define RTL_ROM_LMP_8761A	0x8761
+#define RTL_ROM_LMP_8822B	0x8822
 
 static int rtl_read_rom_version(struct hci_dev *hdev, u8 *version)
 {
@@ -78,11 +79,12 @@ static int rtl8723b_parse_firmware(struct hci_dev *hdev, u16 lmp_subver,
 	const unsigned char *patch_length_base, *patch_offset_base;
 	u32 patch_offset = 0;
 	u16 patch_length, num_patches;
-	const u16 project_id_to_lmp_subver[] = {
-		RTL_ROM_LMP_8723A,
-		RTL_ROM_LMP_8723B,
-		RTL_ROM_LMP_8821A,
-		RTL_ROM_LMP_8761A
+	const struct lmp_subver project_id_to_lmp_subver[] = {
+		{RTL_ROM_LMP_8723A, 0},
+		{RTL_ROM_LMP_8723B, 1},
+		{RTL_ROM_LMP_8821A, 2},
+		{RTL_ROM_LMP_8761A, 3},
+		{RTL_ROM_LMP_8822B, 8},
 	};
 
 	ret = rtl_read_rom_version(hdev, &rom_version);
@@ -134,14 +136,20 @@ static int rtl8723b_parse_firmware(struct hci_dev *hdev, u16 lmp_subver,
 		return -EINVAL;
 	}
 
-	if (project_id >= ARRAY_SIZE(project_id_to_lmp_subver)) {
+	/* Find project_id in table */
+	for (i = 0; i < ARRAY_SIZE(project_id_to_lmp_subver); i++) {
+		if (project_id == project_id_to_lmp_subver[i].id)
+			break;
+	}
+
+	if (i >= ARRAY_SIZE(project_id_to_lmp_subver)) {
 		BT_ERR("%s: unknown project id %d", hdev->name, project_id);
 		return -EINVAL;
 	}
 
-	if (lmp_subver != project_id_to_lmp_subver[project_id]) {
+	if (lmp_subver != project_id_to_lmp_subver[i].lmp_subver) {
 		BT_ERR("%s: firmware is for %x but this is a %x", hdev->name,
-		       project_id_to_lmp_subver[project_id], lmp_subver);
+		       project_id_to_lmp_subver[i].lmp_subver, lmp_subver);
 		return -EINVAL;
 	}
 
@@ -257,6 +265,26 @@ out:
 	return ret;
 }
 
+static int rtl_load_config(struct hci_dev *hdev, const char *name, u8 **buff)
+{
+	const struct firmware *fw;
+	int ret;
+
+	BT_INFO("%s: rtl: loading %s", hdev->name, name);
+	ret = request_firmware(&fw, name, &hdev->dev);
+	if (ret < 0) {
+		BT_ERR("%s: Failed to load %s", hdev->name, name);
+		return ret;
+	}
+
+	ret = fw->size;
+	*buff = kmemdup(fw->data, ret, GFP_KERNEL);
+
+	release_firmware(fw);
+
+	return ret;
+}
+
 static int btrtl_setup_rtl8723a(struct hci_dev *hdev)
 {
 	const struct firmware *fw;
@@ -296,25 +324,74 @@ static int btrtl_setup_rtl8723b(struct hci_dev *hdev, u16 lmp_subver,
 	unsigned char *fw_data = NULL;
 	const struct firmware *fw;
 	int ret;
+	int cfg_sz;
+	u8 *cfg_buff = NULL;
+	u8 *tbuff;
+	char *cfg_name = NULL;
+
+	switch (lmp_subver) {
+	case RTL_ROM_LMP_8723B:
+		cfg_name = "rtl_bt/rtl8723b_config.bin";
+		break;
+	case RTL_ROM_LMP_8821A:
+		cfg_name = "rtl_bt/rtl8821a_config.bin";
+		break;
+	case RTL_ROM_LMP_8761A:
+		cfg_name = "rtl_bt/rtl8761a_config.bin";
+		break;
+	case RTL_ROM_LMP_8822B:
+		cfg_name = "rtl_bt/rtl8822b_config.bin";
+		break;
+	default:
+		BT_ERR("%s: rtl: no config according to lmp_subver %04x",
+		       hdev->name, lmp_subver);
+		break;
+	}
+
+	if (cfg_name) {
+		cfg_sz = rtl_load_config(hdev, cfg_name, &cfg_buff);
+		if (cfg_sz < 0)
+			cfg_sz = 0;
+	} else
+		cfg_sz = 0;
 
 	BT_INFO("%s: rtl: loading %s", hdev->name, fw_name);
 	ret = request_firmware(&fw, fw_name, &hdev->dev);
 	if (ret < 0) {
 		BT_ERR("%s: Failed to load %s", hdev->name, fw_name);
-		return ret;
+		goto err_req_fw;
 	}
 
 	ret = rtl8723b_parse_firmware(hdev, lmp_subver, fw, &fw_data);
 	if (ret < 0)
 		goto out;
 
+	if (cfg_sz) {
+		tbuff = kzalloc(ret + cfg_sz, GFP_KERNEL);
+		if (!tbuff) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		memcpy(tbuff, fw_data, ret);
+		kfree(fw_data);
+
+		memcpy(tbuff + ret, cfg_buff, cfg_sz);
+		ret += cfg_sz;
+
+		fw_data = tbuff;
+	}
+
+	BT_INFO("cfg_sz %d, total size %d", cfg_sz, ret);
+
 	ret = rtl_download_firmware(hdev, fw_data, ret);
-	kfree(fw_data);
-	if (ret < 0)
-		goto out;
 
 out:
 	release_firmware(fw);
+	kfree(fw_data);
+err_req_fw:
+	if (cfg_sz)
+		kfree(cfg_buff);
 	return ret;
 }
 
@@ -377,6 +454,9 @@ int btrtl_setup_realtek(struct hci_dev *hdev)
 	case RTL_ROM_LMP_8761A:
 		return btrtl_setup_rtl8723b(hdev, lmp_subver,
 					    "rtl_bt/rtl8761a_fw.bin");
+	case RTL_ROM_LMP_8822B:
+		return btrtl_setup_rtl8723b(hdev, lmp_subver,
+					    "rtl_bt/rtl8822b_fw.bin");
 	default:
 		BT_INFO("rtl: assuming no firmware upload needed.");
 		return 0;
diff --git a/drivers/bluetooth/btrtl.h b/drivers/bluetooth/btrtl.h
index 38ffe48..79f8801 100644
--- a/drivers/bluetooth/btrtl.h
+++ b/drivers/bluetooth/btrtl.h
@@ -38,6 +38,11 @@ struct rtl_epatch_header {
 	__le16 num_patches;
 } __packed;
 
+struct lmp_subver {
+	__u16 lmp_subver;
+	__u8 id;
+};
+
 #if IS_ENABLED(CONFIG_BT_RTL)
 
 int btrtl_setup_realtek(struct hci_dev *hdev);
-- 
2.6.6
