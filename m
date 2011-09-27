Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:47474 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab1I0LbS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 07:31:18 -0400
Subject: [PATCH 3/4] ath6kl: add debug logs for booting
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Sep 2011 14:31:11 +0300
Message-ID: <20110927113111.11592.69554.stgit@localhost6.localdomain6> (sfid-20110927_133121_305286_F25A4E5F)
In-Reply-To: <20110927113045.11592.15974.stgit@localhost6.localdomain6>
References: <20110927113045.11592.15974.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just to make it easier to find out why boot fails.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.h |    1 
 drivers/net/wireless/ath/ath6kl/init.c  |   71 +++++++++++++++++++++++++++----
 2 files changed, 63 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.h b/drivers/net/wireless/ath/ath6kl/debug.h
index 63eb1c1..6288e4c 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.h
+++ b/drivers/net/wireless/ath/ath6kl/debug.h
@@ -38,6 +38,7 @@ enum ATH6K_DEBUG_MASK {
 	ATH6KL_DBG_AGGR		= BIT(15),    /* aggregation */
 	ATH6KL_DBG_SDIO		= BIT(16),
 	ATH6KL_DBG_SDIO_DUMP	= BIT(17),
+	ATH6KL_DBG_BOOT		= BIT(18),    /* driver init and fw boot */
 	ATH6KL_DBG_ANY	        = 0xffffffff  /* enable all logs */
 };
 
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index e9785fe..876b6b2 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -958,6 +958,9 @@ static int ath6kl_fetch_fw_api2(struct ath6kl *ar)
 
 		switch (ie_id) {
 		case ATH6KL_FW_IE_OTP_IMAGE:
+			ath6kl_dbg(ATH6KL_DBG_BOOT, "found otp image ie (%d B)\n",
+				ie_len);
+
 			ar->fw_otp = kmemdup(data, ie_len, GFP_KERNEL);
 
 			if (ar->fw_otp == NULL) {
@@ -968,6 +971,9 @@ static int ath6kl_fetch_fw_api2(struct ath6kl *ar)
 			ar->fw_otp_len = ie_len;
 			break;
 		case ATH6KL_FW_IE_FW_IMAGE:
+			ath6kl_dbg(ATH6KL_DBG_BOOT, "found fw image ie (%d B)\n",
+				ie_len);
+
 			ar->fw = kmemdup(data, ie_len, GFP_KERNEL);
 
 			if (ar->fw == NULL) {
@@ -978,6 +984,9 @@ static int ath6kl_fetch_fw_api2(struct ath6kl *ar)
 			ar->fw_len = ie_len;
 			break;
 		case ATH6KL_FW_IE_PATCH_IMAGE:
+			ath6kl_dbg(ATH6KL_DBG_BOOT, "found patch image ie (%d B)\n",
+				ie_len);
+
 			ar->fw_patch = kmemdup(data, ie_len, GFP_KERNEL);
 
 			if (ar->fw_patch == NULL) {
@@ -990,8 +999,16 @@ static int ath6kl_fetch_fw_api2(struct ath6kl *ar)
 		case ATH6KL_FW_IE_RESERVED_RAM_SIZE:
 			val = (__le32 *) data;
 			ar->hw.reserved_ram_size = le32_to_cpup(val);
+
+			ath6kl_dbg(ATH6KL_DBG_BOOT,
+				   "found reserved ram size ie 0x%d\n",
+				   ar->hw.reserved_ram_size);
 			break;
 		case ATH6KL_FW_IE_CAPABILITIES:
+			ath6kl_dbg(ATH6KL_DBG_BOOT,
+				   "found firmware capabilities ie (%d B)\n",
+				   ie_len);
+
 			for (i = 0; i < ATH6KL_FW_CAPABILITY_MAX; i++) {
 				index = ALIGN(i, 8) / 8;
 				bit = i % 8;
@@ -999,6 +1016,10 @@ static int ath6kl_fetch_fw_api2(struct ath6kl *ar)
 				if (data[index] & (1 << bit))
 					__set_bit(i, ar->fw_capabilities);
 			}
+
+			ath6kl_dbg_dump(ATH6KL_DBG_BOOT, "capabilities", "",
+					ar->fw_capabilities,
+					sizeof(ar->fw_capabilities));
 			break;
 		case ATH6KL_FW_IE_PATCH_ADDR:
 			if (ie_len != sizeof(*val))
@@ -1006,9 +1027,13 @@ static int ath6kl_fetch_fw_api2(struct ath6kl *ar)
 
 			val = (__le32 *) data;
 			ar->hw.dataset_patch_addr = le32_to_cpup(val);
+
+			ath6kl_dbg(ATH6KL_DBG_BOOT,
+				   "found patch address ie 0x%d\n",
+				   ar->hw.dataset_patch_addr);
 			break;
 		default:
-			ath6kl_dbg(ATH6KL_DBG_TRC, "Unknown fw ie: %u\n",
+			ath6kl_dbg(ATH6KL_DBG_BOOT, "Unknown fw ie: %u\n",
 				   le32_to_cpup(&hdr->id));
 			break;
 		}
@@ -1033,14 +1058,17 @@ static int ath6kl_fetch_firmwares(struct ath6kl *ar)
 		return ret;
 
 	ret = ath6kl_fetch_fw_api2(ar);
-	if (ret == 0)
-		/* fw api 2 found, use it */
+	if (ret == 0) {
+		ath6kl_dbg(ATH6KL_DBG_BOOT, "using fw api 2\n");
 		return 0;
+	}
 
 	ret = ath6kl_fetch_fw_api1(ar);
 	if (ret)
 		return ret;
 
+	ath6kl_dbg(ATH6KL_DBG_BOOT, "using fw api 1\n");
+
 	return 0;
 }
 
@@ -1071,18 +1099,12 @@ static int ath6kl_upload_board_file(struct ath6kl *ar)
 				(u8 *) &board_address, 4);
 	}
 
-	ath6kl_dbg(ATH6KL_DBG_TRC, "board data download addr: 0x%x\n",
-		   board_address);
-
 	/* determine where in target ram to write extended board data */
 	ath6kl_bmi_read(ar,
 			ath6kl_get_hi_item_addr(ar,
 			HI_ITEM(hi_board_ext_data)),
 			(u8 *) &board_ext_address, 4);
 
-	ath6kl_dbg(ATH6KL_DBG_TRC, "board file download addr: 0x%x\n",
-		   board_ext_address);
-
 	if (board_ext_address == 0) {
 		ath6kl_err("Failed to get board file target address.\n");
 		return -EINVAL;
@@ -1107,6 +1129,10 @@ static int ath6kl_upload_board_file(struct ath6kl *ar)
 				 board_ext_data_size)) {
 
 		/* write extended board data */
+		ath6kl_dbg(ATH6KL_DBG_BOOT,
+			   "writing extended board data to 0x%x (%d B)\n",
+			   board_ext_address, board_ext_data_size);
+
 		ret = ath6kl_bmi_write(ar, board_ext_address,
 				       ar->fw_board + board_data_size,
 				       board_ext_data_size);
@@ -1131,6 +1157,9 @@ static int ath6kl_upload_board_file(struct ath6kl *ar)
 		return ret;
 	}
 
+	ath6kl_dbg(ATH6KL_DBG_BOOT, "writing board file to 0x%x (%d B)\n",
+		   board_address, board_data_size);
+
 	ret = ath6kl_bmi_write(ar, board_address, ar->fw_board,
 			       board_data_size);
 
@@ -1159,6 +1188,9 @@ static int ath6kl_upload_otp(struct ath6kl *ar)
 
 	address = ar->hw.app_load_addr;
 
+	ath6kl_dbg(ATH6KL_DBG_BOOT, "writing otp to 0x%x (%d B)\n", address,
+		   ar->fw_otp_len);
+
 	ret = ath6kl_bmi_fast_download(ar, address, ar->fw_otp,
 				       ar->fw_otp_len);
 	if (ret) {
@@ -1179,7 +1211,11 @@ static int ath6kl_upload_otp(struct ath6kl *ar)
 
 	ar->hw.app_start_override_addr = address;
 
+	ath6kl_dbg(ATH6KL_DBG_BOOT, "app_start_override_addr 0x%x\n",
+		   ar->hw.app_start_override_addr);
+
 	/* execute the OTP code */
+	ath6kl_dbg(ATH6KL_DBG_BOOT, "executing OTP at 0x%x\n", address);
 	param = 0;
 	ath6kl_bmi_execute(ar, address, &param);
 
@@ -1196,6 +1232,9 @@ static int ath6kl_upload_firmware(struct ath6kl *ar)
 
 	address = ar->hw.app_load_addr;
 
+	ath6kl_dbg(ATH6KL_DBG_BOOT, "writing firmware to 0x%x (%d B)\n",
+		   address, ar->fw_len);
+
 	ret = ath6kl_bmi_fast_download(ar, address, ar->fw, ar->fw_len);
 
 	if (ret) {
@@ -1224,6 +1263,9 @@ static int ath6kl_upload_patch(struct ath6kl *ar)
 
 	address = ar->hw.dataset_patch_addr;
 
+	ath6kl_dbg(ATH6KL_DBG_BOOT, "writing patch to 0x%x (%d B)\n",
+		   address, ar->fw_patch_len);
+
 	ret = ath6kl_bmi_write(ar, address, ar->fw_patch, ar->fw_patch_len);
 	if (ret) {
 		ath6kl_err("Failed to write patch file: %d\n", ret);
@@ -1396,6 +1438,15 @@ static int ath6kl_init_hw_params(struct ath6kl *ar)
 		return -EINVAL;
 	}
 
+	ath6kl_dbg(ATH6KL_DBG_BOOT,
+		   "target_ver 0x%x target_type 0x%x dataset_patch 0x%x app_load_addr 0x%x\n",
+		   ar->version.target_ver, ar->target_type,
+		   ar->hw.dataset_patch_addr, ar->hw.app_load_addr);
+	ath6kl_dbg(ATH6KL_DBG_BOOT,
+		   "app_start_override_addr 0x%x board_ext_data_addr 0x%x reserved_ram_size 0x%x",
+		   ar->hw.app_start_override_addr, ar->hw.board_ext_data_addr,
+		   ar->hw.reserved_ram_size);
+
 	return 0;
 }
 
@@ -1472,6 +1523,8 @@ static int ath6kl_init(struct net_device *dev)
 							     &ar->flag),
 						    WMI_TIMEOUT);
 
+	ath6kl_dbg(ATH6KL_DBG_BOOT, "firmware booted\n");
+
 	if (ar->version.abi_ver != ATH6KL_ABI_VERSION) {
 		ath6kl_err("abi version mismatch: host(0x%x), target(0x%x)\n",
 			   ATH6KL_ABI_VERSION, ar->version.abi_ver);

