Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46090 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbeHXRr5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 13:47:57 -0400
From: Sathishkumar Muruganandam <murugana@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Sathishkumar Muruganandam <murugana@codeaurora.org>
Subject: [PATCH 2/2] ath10k: Support extended board data download for dual-band QCA9984
Date: Fri, 24 Aug 2018 19:42:21 +0530
Message-Id: <20180824141221.3661-2-murugana@codeaurora.org> (sfid-20180824_161317_164058_E081D610)
In-Reply-To: <20180824141221.3661-1-murugana@codeaurora.org>
References: <20180824141221.3661-1-murugana@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To support dual-band variant of QCA9984, new extended board data (eBDF)
is introduced since existing board data ran out of space.

Below is the brief implementation & design detail,
----------------------------------------------------

1. New OTP changes to inform eBDF support in existing OTP download to
fetch board ID and chip ID. This is backward compatible and older
card sends 0 by default for eBDF support bit (bit 18 of OTP response) we
check in ath10k driver.

2. If eBDF is supported, then we need to fetch eBDF ID which is bundled
in downloaded board data. So again OTP is executed for knowing the eBDF ID.
This is done once we set 'board_data_initialized' bit. If eBDF ID
returned is zero, we continue booting with previous board data downloaded.

3. Based on the eBDF ID fetched, ath10k driver tries to download the
extended board data to a new offset ahead of already downloaded board
data address.

4. A new BD IE type, ATH10K_BD_IE_BOARD_EXT is added to differentiate in
bundling eBDF separately in board-2.bin and also to parse through
board bundle for eBDF download in ath10k boot.

5. If eBDF is not present in the board-2.bin bundle or when board ID is
zero, we do a fallback boot to "eboard.bin" in the same QCA9984/hw1.0 dir.
This is same as done to existing "board.bin" if board ID is not present
in board-2.bin bundle.

Current design is that eBDF size will be 2KB and eBDF ID will be
byte value.

Tested the above changes with dual-band variant of QCA9984 card. OTP
update needed for the test will be part of next FW release 10.4-3.6-xxxx.

Below are the logs with ath10k BOOT debugs enabled.

First OTP response :
---------------------
..
boot upload otp to 0x1234 len 9478 for board id                                               
boot get otp board id result 0x00040400 board_id 1 chip_id 0 ext_bid_support 1                    
..

Second OTP response :
---------------------
..
boot upload otp to 0x1234 len 9478 for ext board id                                             
boot get otp ext board id result 0x00000005 ext_board_id 5                                         
boot using eboard name 'bus=pci,bmi-chip-id=0,bmi-eboard-id=5'                                            
..

Extended board data download:
------------------------------
..
board name
00000000: 62 75 73 3d 70 63 69 2c 62 6d 69 2d 63 68 69 70  bus=pci,bmi-chip
00000010: 2d 69 64 3d 30 2c 62 6d 69 2d 65 62 6f 61 72 64  -id=0,bmi-eboard
00000020: 2d 69 64 3d 35                                   -id=5
boot found match for name 'bus=pci,bmi-chip-id=0,bmi-eboard-id=5'
boot found eboard data for 'bus=pci,bmi-chip-id=0,bmi-eboard-id=5'
using board api 2
boot writing ext board data to addr 0xc3000                                                               
..

Fallback Extended board data download from "eboard.bin":
---------------------------------------------------------
..
board name
00000000: 62 75 73 3d 70 63 69 2c 62 6d 69 2d 63 68 69 70  bus=pci,bmi-chip
00000010: 2d 69 64 3d 30 2c 62 6d 69 2d 62 6f 61 72 64 2d  -id=0,bmi-board-
00000020: 69 64 3d 31 30                                   id=10
failed to fetch board data for bus=pci,bmi-chip-id=0,bmi-eboard-id=5 from ath10k/QCA9984/hw1.0/board-2.bin      
boot fw request 'ath10k/QCA9984/hw1.0/eboard.bin': 0                                           
using board api 1                                                                          
boot writing ext board data to addr 0xc3000                                                
..

Signed-off-by: Sathishkumar Muruganandam <murugana@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/bmi.h       |   5 +
 drivers/net/wireless/ath/ath10k/core.c      | 244 ++++++++++++++++----
 drivers/net/wireless/ath/ath10k/core.h      |   5 +
 drivers/net/wireless/ath/ath10k/hw.h        |   4 +
 drivers/net/wireless/ath/ath10k/targaddrs.h |   4 +
 5 files changed, 221 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/bmi.h b/drivers/net/wireless/ath/ath10k/bmi.h
index 9a396817aa55..28f49441ba46 100644
--- a/drivers/net/wireless/ath/ath10k/bmi.h
+++ b/drivers/net/wireless/ath/ath10k/bmi.h
@@ -86,6 +86,10 @@ enum bmi_cmd_id {
 #define BMI_PARAM_GET_FLASH_BOARD_ID 0x8000
 #define BMI_PARAM_FLASH_SECTION_ALL 0x10000
 
+/* Dual-band Extended Board ID */
+#define BMI_PARAM_GET_EXT_BOARD_ID 0x40000
+#define ATH10K_BMI_EXT_BOARD_ID_SUPPORT 0x40000
+
 #define ATH10K_BMI_BOARD_ID_FROM_OTP_MASK   0x7c00
 #define ATH10K_BMI_BOARD_ID_FROM_OTP_LSB    10
 
@@ -93,6 +97,7 @@ enum bmi_cmd_id {
 #define ATH10K_BMI_CHIP_ID_FROM_OTP_LSB     15
 
 #define ATH10K_BMI_BOARD_ID_STATUS_MASK 0xff
+#define ATH10K_BMI_EBOARD_ID_STATUS_MASK 0xff
 
 struct bmi_cmd {
 	__le32 id; /* enum bmi_cmd_id */
diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 28c2fecc0a56..0889a832ab7e 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -346,8 +346,10 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.fw = {
 			.dir = QCA9984_HW_1_0_FW_DIR,
 			.board = QCA9984_HW_1_0_BOARD_DATA_FILE,
+			.eboard = QCA9984_HW_1_0_EBOARD_DATA_FILE,
 			.board_size = QCA99X0_BOARD_DATA_SZ,
 			.board_ext_size = QCA99X0_BOARD_EXT_DATA_SZ,
+			.ext_board_size = QCA99X0_EXT_BOARD_DATA_SZ,
 		},
 		.sw_decrypt_mcast_mgmt = true,
 		.hw_ops = &qca99x0_ops,
@@ -766,6 +768,7 @@ static int ath10k_core_get_board_id_from_otp(struct ath10k *ar)
 {
 	u32 result, address;
 	u8 board_id, chip_id;
+	bool ext_bid_support;
 	int ret, bmi_board_id_param;
 
 	address = ar->hw_params.patch_load_addr;
@@ -805,10 +808,13 @@ static int ath10k_core_get_board_id_from_otp(struct ath10k *ar)
 
 	board_id = MS(result, ATH10K_BMI_BOARD_ID_FROM_OTP);
 	chip_id = MS(result, ATH10K_BMI_CHIP_ID_FROM_OTP);
+	ext_bid_support = (result & ATH10K_BMI_EXT_BOARD_ID_SUPPORT);
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT,
-		   "boot get otp board id result 0x%08x board_id %d chip_id %d\n",
-		   result, board_id, chip_id);
+		   "boot get otp board id result 0x%08x board_id %d chip_id %d ext_bid_support %d\n",
+		   result, board_id, chip_id, ext_bid_support);
+
+	ar->id.ext_bid_supported = ext_bid_support;
 
 	if ((result & ATH10K_BMI_BOARD_ID_STATUS_MASK) != 0 ||
 	    (board_id == 0)) {
@@ -949,9 +955,15 @@ static void ath10k_core_free_board_files(struct ath10k *ar)
 	if (!IS_ERR(ar->normal_mode_fw.board))
 		release_firmware(ar->normal_mode_fw.board);
 
+	if (!IS_ERR(ar->normal_mode_fw.ext_board))
+		release_firmware(ar->normal_mode_fw.ext_board);
+
 	ar->normal_mode_fw.board = NULL;
 	ar->normal_mode_fw.board_data = NULL;
 	ar->normal_mode_fw.board_len = 0;
+	ar->normal_mode_fw.ext_board = NULL;
+	ar->normal_mode_fw.ext_board_data = NULL;
+	ar->normal_mode_fw.ext_board_len = 0;
 }
 
 static void ath10k_core_free_firmware_files(struct ath10k *ar)
@@ -1005,28 +1017,45 @@ static int ath10k_fetch_cal_file(struct ath10k *ar)
 	return 0;
 }
 
-static int ath10k_core_fetch_board_data_api_1(struct ath10k *ar)
+static int ath10k_core_fetch_board_data_api_1(struct ath10k *ar, int bd_ie_type)
 {
-	if (!ar->hw_params.fw.board) {
-		ath10k_err(ar, "failed to find board file fw entry\n");
-		return -EINVAL;
-	}
+	if (bd_ie_type == ATH10K_BD_IE_BOARD) {
+		if (!ar->hw_params.fw.board) {
+			ath10k_err(ar, "failed to find board file fw entry\n");
+			return -EINVAL;
+		}
 
-	ar->normal_mode_fw.board = ath10k_fetch_fw_file(ar,
-							ar->hw_params.fw.dir,
-							ar->hw_params.fw.board);
-	if (IS_ERR(ar->normal_mode_fw.board))
-		return PTR_ERR(ar->normal_mode_fw.board);
+		ar->normal_mode_fw.board = ath10k_fetch_fw_file(ar,
+								ar->hw_params.fw.dir,
+								ar->hw_params.fw.board);
+		if (IS_ERR(ar->normal_mode_fw.board))
+			return PTR_ERR(ar->normal_mode_fw.board);
+
+		ar->normal_mode_fw.board_data = ar->normal_mode_fw.board->data;
+		ar->normal_mode_fw.board_len = ar->normal_mode_fw.board->size;
+	} else if (bd_ie_type == ATH10K_BD_IE_BOARD_EXT) {
+		if (!ar->hw_params.fw.eboard) {
+			ath10k_err(ar, "failed to find eboard file fw entry\n");
+			return -EINVAL;
+		}
+
+		ar->normal_mode_fw.ext_board = ath10k_fetch_fw_file(ar,
+								    ar->hw_params.fw.dir,
+								    ar->hw_params.fw.eboard);
+		if (IS_ERR(ar->normal_mode_fw.ext_board))
+			return PTR_ERR(ar->normal_mode_fw.ext_board);
 
-	ar->normal_mode_fw.board_data = ar->normal_mode_fw.board->data;
-	ar->normal_mode_fw.board_len = ar->normal_mode_fw.board->size;
+		ar->normal_mode_fw.ext_board_data = ar->normal_mode_fw.ext_board->data;
+		ar->normal_mode_fw.ext_board_len = ar->normal_mode_fw.ext_board->size;
+	}
 
 	return 0;
 }
 
 static int ath10k_core_parse_bd_ie_board(struct ath10k *ar,
 					 const void *buf, size_t buf_len,
-					 const char *boardname)
+					 const char *boardname,
+					 int bd_ie_type)
 {
 	const struct ath10k_fw_ie *hdr;
 	bool name_match_found;
@@ -1075,12 +1104,21 @@ static int ath10k_core_parse_bd_ie_board(struct ath10k *ar,
 				/* no match found */
 				break;
 
-			ath10k_dbg(ar, ATH10K_DBG_BOOT,
-				   "boot found board data for '%s'",
-				   boardname);
+			if (bd_ie_type == ATH10K_BD_IE_BOARD) {
+				ath10k_dbg(ar, ATH10K_DBG_BOOT,
+					   "boot found board data for '%s'",
+						boardname);
+
+				ar->normal_mode_fw.board_data = board_ie_data;
+				ar->normal_mode_fw.board_len = board_ie_len;
+			} else if (bd_ie_type == ATH10K_BD_IE_BOARD_EXT) {
+				ath10k_dbg(ar, ATH10K_DBG_BOOT,
+					   "boot found eboard data for '%s'",
+						boardname);
 
-			ar->normal_mode_fw.board_data = board_ie_data;
-			ar->normal_mode_fw.board_len = board_ie_len;
+				ar->normal_mode_fw.ext_board_data = board_ie_data;
+				ar->normal_mode_fw.ext_board_len = board_ie_len;
+			}
 
 			ret = 0;
 			goto out;
@@ -1130,7 +1168,18 @@ static int ath10k_core_search_bd(struct ath10k *ar,
 		switch (ie_id) {
 		case ATH10K_BD_IE_BOARD:
 			ret = ath10k_core_parse_bd_ie_board(ar, data, ie_len,
-							    boardname);
+							    boardname,
+							    ATH10K_BD_IE_BOARD);
+			if (ret == -ENOENT)
+				/* no match found, continue */
+				break;
+
+			/* either found or error, so stop searching */
+			goto out;
+		case ATH10K_BD_IE_BOARD_EXT:
+			ret = ath10k_core_parse_bd_ie_board(ar, data, ie_len,
+							    boardname,
+							    ATH10K_BD_IE_BOARD_EXT);
 			if (ret == -ENOENT)
 				/* no match found, continue */
 				break;
@@ -1160,9 +1209,11 @@ static int ath10k_core_fetch_board_data_api_n(struct ath10k *ar,
 	const u8 *data;
 	int ret;
 
-	ar->normal_mode_fw.board = ath10k_fetch_fw_file(ar,
-							ar->hw_params.fw.dir,
-							filename);
+	/* Skip if already fetched during board data download */
+	if (!ar->normal_mode_fw.board)
+		ar->normal_mode_fw.board = ath10k_fetch_fw_file(ar,
+								ar->hw_params.fw.dir,
+								filename);
 	if (IS_ERR(ar->normal_mode_fw.board))
 		return PTR_ERR(ar->normal_mode_fw.board);
 
@@ -1250,23 +1301,49 @@ static int ath10k_core_create_board_name(struct ath10k *ar, char *name,
 	return 0;
 }
 
-static int ath10k_core_fetch_board_file(struct ath10k *ar)
+static int ath10k_core_create_eboard_name(struct ath10k *ar, char *name,
+					  size_t name_len)
+{
+	if (ar->id.bmi_ids_valid) {
+		scnprintf(name, name_len,
+			  "bus=%s,bmi-chip-id=%d,bmi-eboard-id=%d",
+			  ath10k_bus_str(ar->hif.bus),
+			  ar->id.bmi_chip_id,
+			  ar->id.bmi_eboard_id);
+
+		ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot using eboard name '%s'\n", name);
+		return 0;
+	}
+	/* Fallback if returned board id is zero */
+	return -1;
+}
+
+static int ath10k_core_fetch_board_file(struct ath10k *ar, int bd_ie_type)
 {
 	char boardname[100], fallback_boardname[100];
 	int ret;
 
-	ret = ath10k_core_create_board_name(ar, boardname,
-					    sizeof(boardname), true);
-	if (ret) {
-		ath10k_err(ar, "failed to create board name: %d", ret);
-		return ret;
-	}
+	if (bd_ie_type == ATH10K_BD_IE_BOARD) {
+		ret = ath10k_core_create_board_name(ar, boardname,
+						    sizeof(boardname), true);
+		if (ret) {
+			ath10k_err(ar, "failed to create board name: %d", ret);
+			return ret;
+		}
 
-	ret = ath10k_core_create_board_name(ar, fallback_boardname,
-					    sizeof(boardname), false);
-	if (ret) {
-		ath10k_err(ar, "failed to create fallback board name: %d", ret);
-		return ret;
+		ret = ath10k_core_create_board_name(ar, fallback_boardname,
+						    sizeof(boardname), false);
+		if (ret) {
+			ath10k_err(ar, "failed to create fallback board name: %d", ret);
+			return ret;
+		}
+	} else if (bd_ie_type == ATH10K_BD_IE_BOARD_EXT) {
+		ret = ath10k_core_create_eboard_name(ar, boardname,
+						     sizeof(boardname));
+		if (ret) {
+			ath10k_err(ar, "fallback to eboard.bin since board id 0");
+			goto fallback;
+		}
 	}
 
 	ar->bd_api = 2;
@@ -1276,8 +1353,9 @@ static int ath10k_core_fetch_board_file(struct ath10k *ar)
 	if (!ret)
 		goto success;
 
+fallback:
 	ar->bd_api = 1;
-	ret = ath10k_core_fetch_board_data_api_1(ar);
+	ret = ath10k_core_fetch_board_data_api_1(ar, bd_ie_type);
 	if (ret) {
 		ath10k_err(ar, "failed to fetch board-2.bin or board.bin from %s\n",
 			   ar->hw_params.fw.dir);
@@ -1289,11 +1367,65 @@ static int ath10k_core_fetch_board_file(struct ath10k *ar)
 	return 0;
 }
 
+static int ath10k_core_get_ext_board_id_from_otp(struct ath10k *ar)
+{
+	u32 result, address;
+	u8 ext_board_id;
+	int ret;
+
+	address = ar->hw_params.patch_load_addr;
+
+	if (!ar->normal_mode_fw.fw_file.otp_data ||
+	    !ar->normal_mode_fw.fw_file.otp_len) {
+		ath10k_warn(ar,
+			    "failed to retrieve extended board id due to otp binary missing\n");
+		return -ENODATA;
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_BOOT,
+		   "boot upload otp to 0x%x len %zd for ext board id\n",
+		   address, ar->normal_mode_fw.fw_file.otp_len);
+
+	ret = ath10k_bmi_fast_download(ar, address,
+				       ar->normal_mode_fw.fw_file.otp_data,
+				       ar->normal_mode_fw.fw_file.otp_len);
+	if (ret) {
+		ath10k_err(ar, "could not write otp for ext board id check: %d\n",
+			   ret);
+		return ret;
+	}
+
+	ret = ath10k_bmi_execute(ar, address, BMI_PARAM_GET_EXT_BOARD_ID, &result);
+	if (ret) {
+		ath10k_err(ar, "could not execute otp for ext board id check: %d\n",
+			   ret);
+		return ret;
+	}
+
+	if (!result) {
+		ath10k_dbg(ar, ATH10K_DBG_BOOT,
+			   "ext board id does not exist in otp, ignore it\n");
+		return -EOPNOTSUPP;
+	}
+
+	ext_board_id = result & ATH10K_BMI_EBOARD_ID_STATUS_MASK;
+
+	ath10k_dbg(ar, ATH10K_DBG_BOOT,
+		   "boot get otp ext board id result 0x%08x ext_board_id %d\n",
+		   result, ext_board_id);
+
+	ar->id.bmi_eboard_id = ext_board_id;
+
+	return 0;
+}
+
 static int ath10k_download_board_data(struct ath10k *ar, const void *data,
 				      size_t data_len)
 {
 	u32 board_data_size = ar->hw_params.fw.board_size;
-	u32 address;
+	u32 eboard_data_size = ar->hw_params.fw.ext_board_size;
+	u32 board_address;
+	u32 ext_board_address;
 	int ret;
 
 	ret = ath10k_push_board_ext_data(ar, data, data_len);
@@ -1302,13 +1434,13 @@ static int ath10k_download_board_data(struct ath10k *ar, const void *data,
 		goto exit;
 	}
 
-	ret = ath10k_bmi_read32(ar, hi_board_data, &address);
+	ret = ath10k_bmi_read32(ar, hi_board_data, &board_address);
 	if (ret) {
 		ath10k_err(ar, "could not read board data addr (%d)\n", ret);
 		goto exit;
 	}
 
-	ret = ath10k_bmi_write_memory(ar, address, data,
+	ret = ath10k_bmi_write_memory(ar, board_address, data,
 				      min_t(u32, board_data_size,
 					    data_len));
 	if (ret) {
@@ -1322,6 +1454,36 @@ static int ath10k_download_board_data(struct ath10k *ar, const void *data,
 		goto exit;
 	}
 
+	if (!ar->id.ext_bid_supported)
+		goto exit;
+
+	/* Extended board data download */
+	ret = ath10k_core_get_ext_board_id_from_otp(ar);
+	if (ret == -EOPNOTSUPP) {
+		/* Not fetching ext_board_data if ext board id is 0 */
+		ath10k_dbg(ar, ATH10K_DBG_BOOT, "otp returned ext board id 0\n");
+		return 0;
+	} else if (ret) {
+		ath10k_err(ar, "failed to get extended board id: %d\n", ret);
+		goto exit;
+	}
+
+	ret = ath10k_core_fetch_board_file(ar, ATH10K_BD_IE_BOARD_EXT);
+	if (ret)
+		goto exit;
+
+	if (ar->normal_mode_fw.ext_board_data) {
+		ext_board_address = board_address + EXT_BOARD_ADDRESS_OFFSET;
+		ath10k_dbg(ar, ATH10K_DBG_BOOT,
+			   "boot writing ext board data to addr 0x%x",
+			   ext_board_address);
+		ret = ath10k_bmi_write_memory(ar, ext_board_address,
+					      ar->normal_mode_fw.ext_board_data,
+					      min_t(u32, eboard_data_size, data_len));
+		if (ret)
+			ath10k_err(ar, "failed to write ext board data: %d\n", ret);
+	}
+
 exit:
 	return ret;
 }
@@ -2593,7 +2755,7 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 		if (ret)
 			ath10k_dbg(ar, ATH10K_DBG_BOOT, "DT bdf variant name not set.\n");
 
-		ret = ath10k_core_fetch_board_file(ar);
+		ret = ath10k_core_fetch_board_file(ar, ATH10K_BD_IE_BOARD);
 		if (ret) {
 			ath10k_err(ar, "failed to fetch board file: %d\n", ret);
 			goto err_free_firmware_files;
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 9feea02e7d37..f6f5b51848df 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -861,6 +861,9 @@ struct ath10k_fw_components {
 	const struct firmware *board;
 	const void *board_data;
 	size_t board_len;
+	const struct firmware *ext_board;
+	const void *ext_board_data;
+	size_t ext_board_len;
 
 	struct ath10k_fw_file fw_file;
 };
@@ -947,7 +950,9 @@ struct ath10k {
 
 		bool bmi_ids_valid;
 		u8 bmi_board_id;
+		u8 bmi_eboard_id;
 		u8 bmi_chip_id;
+		bool ext_bid_supported;
 
 		char bdf_ext[ATH10K_SMBIOS_BDF_EXT_STR_LENGTH];
 	} id;
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 977f79ebb4fd..3a23e6b3414d 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -109,6 +109,7 @@ enum qca9377_chip_id_rev {
 #define QCA9984_HW_1_0_CHIP_ID_REV	0x0
 #define QCA9984_HW_1_0_FW_DIR		ATH10K_FW_DIR "/QCA9984/hw1.0"
 #define QCA9984_HW_1_0_BOARD_DATA_FILE "board.bin"
+#define QCA9984_HW_1_0_EBOARD_DATA_FILE "eboard.bin"
 #define QCA9984_HW_1_0_PATCH_LOAD_ADDR	0x1234
 
 /* QCA9888 2.0 defines */
@@ -221,6 +222,7 @@ enum ath10k_fw_htt_op_version {
 enum ath10k_bd_ie_type {
 	/* contains sub IEs of enum ath10k_bd_ie_board_type */
 	ATH10K_BD_IE_BOARD = 0,
+	ATH10K_BD_IE_BOARD_EXT = 1,
 };
 
 enum ath10k_bd_ie_board_type {
@@ -539,6 +541,8 @@ struct ath10k_hw_params {
 		const char *dir;
 		const char *board;
 		size_t board_size;
+		const char *eboard;
+		size_t ext_board_size;
 		size_t board_ext_size;
 	} fw;
 
diff --git a/drivers/net/wireless/ath/ath10k/targaddrs.h b/drivers/net/wireless/ath/ath10k/targaddrs.h
index c2b5bad0459b..b11a1c3d87b4 100644
--- a/drivers/net/wireless/ath/ath10k/targaddrs.h
+++ b/drivers/net/wireless/ath/ath10k/targaddrs.h
@@ -484,6 +484,10 @@ struct host_interest {
 #define QCA99X0_BOARD_DATA_SZ	  12288
 #define QCA99X0_BOARD_EXT_DATA_SZ 0
 
+/* Dual band extended board data */
+#define QCA99X0_EXT_BOARD_DATA_SZ 2048
+#define EXT_BOARD_ADDRESS_OFFSET 0x3000
+
 #define QCA4019_BOARD_DATA_SZ	  12064
 #define QCA4019_BOARD_EXT_DATA_SZ 0
 
-- 
2.17.1
