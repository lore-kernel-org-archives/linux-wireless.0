Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23164 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab1HKGsu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 02:48:50 -0400
From: Kevin Fang <chienf@qca.qualcomm.com>
Cc: <linux-wireless@vger.kernel.org>, <kvalo@qca.qualcomm.com>,
	Kevin Fang <chienf@qca.qualcomm.com>
To: <linville@tuxdriver.com>
Subject: [PATCH 1/7] ath6kl: Add beginning of AR6004 initialisation support
Date: Thu, 11 Aug 2011 14:48:09 +0800
Message-ID: <1313045295-16202-1-git-send-email-kevin.fang@qca.qualcomm.com> (sfid-20110811_084854_696352_5B9F7596)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add AR6004 support on the ath6kl driver.
There are two different kinds of interface on the AR6004, sdio and usb.
Add board data, firmware and corresponding hw address for the AR6004

Signed-off-by: Kevin Fang <kevin.fang@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/bmi.h    |    2 +-
 drivers/net/wireless/ath/ath6kl/core.h   |    7 ++
 drivers/net/wireless/ath/ath6kl/init.c   |  136 ++++++++++++++++++++++--------
 drivers/net/wireless/ath/ath6kl/main.c   |    3 +-
 drivers/net/wireless/ath/ath6kl/target.h |   16 +++-
 5 files changed, 123 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/bmi.h b/drivers/net/wireless/ath/ath6kl/bmi.h
index 83546d7..3d55c9a 100644
--- a/drivers/net/wireless/ath/ath6kl/bmi.h
+++ b/drivers/net/wireless/ath/ath6kl/bmi.h
@@ -140,7 +140,7 @@
 
 #define TARGET_VERSION_SENTINAL 0xffffffff
 #define TARGET_TYPE_AR6003	3
-
+#define TARGET_TYPE_AR6004      5
 #define BMI_ROMPATCH_INSTALL               9
 /*
  * Semantics: Install a ROM Patch.
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 7417022..214d114 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -74,6 +74,13 @@
 #define AR6003_REV3_DEFAULT_BOARD_DATA_FILE	\
 	"ath6k/AR6003/hw2.1.1/bdata.SD31.bin"
 
+/* AR6004 1.0 definitions */
+#define AR6004_REV1_VERSION                 0x30000623
+#define AR6004_REV1_FIRMWARE_FILE           "ath6k/AR6004/hw6.1/fw.ram.bin"
+#define AR6004_REV1_BOARD_DATA_FILE         "ath6k/AR6004/hw6.1/bdata.bin"
+#define AR6004_REV1_DEFAULT_BOARD_DATA_FILE "ath6k/AR6004/hw6.1/bdata.DB132.bin"
+#define AR6004_REV1_EPPING_FIRMWARE_FILE "ath6k/AR6004/hw6.1/endpointping.bin"
+
 /* Per STA data, used in AP mode */
 #define STA_PS_AWAKE		BIT(0)
 #define	STA_PS_SLEEP		BIT(1)
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 9d10322..df15bfa 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -114,7 +114,9 @@ static inline u32 ath6kl_get_hi_item_addr(struct ath6kl *ar,
 	u32 addr = 0;
 
 	if (ar->target_type == TARGET_TYPE_AR6003)
-		addr = ATH6KL_HI_START_ADDR + item_offset;
+		addr = ATH6KL_AR6003_HI_START_ADDR + item_offset;
+	else if (ar->target_type == TARGET_TYPE_AR6004)
+		addr = ATH6KL_AR6004_HI_START_ADDR + item_offset;
 
 	return addr;
 }
@@ -127,12 +129,12 @@ static int ath6kl_set_host_app_area(struct ath6kl *ar)
 	/* Fetch the address of the host_app_area_s
 	 * instance in the host interest area */
 	address = ath6kl_get_hi_item_addr(ar, HI_ITEM(hi_app_host_interest));
-	address = TARG_VTOP(address);
+	address = TARG_VTOP(ar->target_type, address);
 
 	if (ath6kl_read_reg_diag(ar, &address, &data))
 		return -EIO;
 
-	address = TARG_VTOP(data);
+	address = TARG_VTOP(ar->target_type, data);
 	host_app_area.wmi_protocol_ver = WMI_PROTOCOL_VERSION;
 	if (ath6kl_access_datadiag(ar, address,
 				(u8 *)&host_app_area,
@@ -370,7 +372,7 @@ static void ath6kl_dump_target_assert_info(struct ath6kl *ar)
 
 	/* the reg dump pointer is copied to the host interest area */
 	address = ath6kl_get_hi_item_addr(ar, HI_ITEM(hi_failure_state));
-	address = TARG_VTOP(address);
+	address = TARG_VTOP(ar->target_type, address);
 
 	/* read RAM location through diagnostic window */
 	status = ath6kl_read_reg_diag(ar, &address, &regdump_loc);
@@ -382,8 +384,7 @@ static void ath6kl_dump_target_assert_info(struct ath6kl *ar)
 
 	ath6kl_dbg(ATH6KL_DBG_TRC, "location of register dump data: 0x%X\n",
 		regdump_loc);
-
-	regdump_loc = TARG_VTOP(regdump_loc);
+	regdump_loc = TARG_VTOP(ar->target_type, regdump_loc);
 
 	/* fetch register dump data */
 	status = ath6kl_access_datadiag(ar,
@@ -518,10 +519,14 @@ int ath6kl_configure_target(struct ath6kl *ar)
 	 * but possible in theory.
 	 */
 
-	if (ar->target_type == TARGET_TYPE_AR6003) {
+	if (ar->target_type == TARGET_TYPE_AR6003 ||
+	    ar->target_type == TARGET_TYPE_AR6004) {
 		if (ar->version.target_ver == AR6003_REV2_VERSION) {
 			param = AR6003_REV2_BOARD_EXT_DATA_ADDRESS;
 			ram_reserved_size =  AR6003_REV2_RAM_RESERVE_SIZE;
+		} else if (ar->version.target_ver == AR6004_REV1_VERSION) {
+			param = AR6004_REV1_BOARD_EXT_DATA_ADDRESS;
+			ram_reserved_size =  AR6004_REV1_RAM_RESERVE_SIZE;
 		} else {
 			param = AR6003_REV3_BOARD_EXT_DATA_ADDRESS;
 			ram_reserved_size =  AR6003_REV3_RAM_RESERVE_SIZE;
@@ -614,7 +619,8 @@ int ath6kl_unavail_ev(struct ath6kl *ar)
 static u32 ath6kl_get_load_address(u32 target_ver, enum addr_type type)
 {
 	WARN_ON(target_ver != AR6003_REV2_VERSION &&
-		target_ver != AR6003_REV3_VERSION);
+		target_ver != AR6003_REV3_VERSION &&
+		target_ver != AR6004_REV1_VERSION);
 
 	switch (type) {
 	case DATASET_PATCH_ADDR:
@@ -664,6 +670,9 @@ static int ath6kl_fetch_board_file(struct ath6kl *ar)
 	case AR6003_REV2_VERSION:
 		filename = AR6003_REV2_BOARD_DATA_FILE;
 		break;
+	case AR6004_REV1_VERSION:
+		filename = AR6004_REV1_BOARD_DATA_FILE;
+		break;
 	default:
 		filename = AR6003_REV3_BOARD_DATA_FILE;
 		break;
@@ -684,6 +693,9 @@ static int ath6kl_fetch_board_file(struct ath6kl *ar)
 	case AR6003_REV2_VERSION:
 		filename = AR6003_REV2_DEFAULT_BOARD_DATA_FILE;
 		break;
+	case AR6004_REV1_VERSION:
+		filename = AR6004_REV1_DEFAULT_BOARD_DATA_FILE;
+		break;
 	default:
 		filename = AR6003_REV3_DEFAULT_BOARD_DATA_FILE;
 		break;
@@ -707,6 +719,7 @@ static int ath6kl_fetch_board_file(struct ath6kl *ar)
 static int ath6kl_upload_board_file(struct ath6kl *ar)
 {
 	u32 board_address, board_ext_address, param;
+	u32 board_data_size, board_ext_data_size;
 	int ret;
 
 	if (ar->fw_board == NULL) {
@@ -715,11 +728,24 @@ static int ath6kl_upload_board_file(struct ath6kl *ar)
 			return ret;
 	}
 
-	/* Determine where in Target RAM to write Board Data */
-	ath6kl_bmi_read(ar,
-			ath6kl_get_hi_item_addr(ar,
-			HI_ITEM(hi_board_data)),
-			(u8 *) &board_address, 4);
+	/*
+	 * Determine where in Target RAM to write Board Data.
+	 * For AR6004, host determine Target RAM address for
+	 * writing board data.
+	 */
+	if (ar->target_type == TARGET_TYPE_AR6004) {
+		board_address = AR6004_REV1_BOARD_DATA_ADDRESS;
+		ath6kl_bmi_write(ar,
+				ath6kl_get_hi_item_addr(ar,
+				HI_ITEM(hi_board_data)),
+				(u8 *) &board_address, 4);
+	} else {
+		ath6kl_bmi_read(ar,
+				ath6kl_get_hi_item_addr(ar,
+				HI_ITEM(hi_board_data)),
+				(u8 *) &board_address, 4);
+	}
+
 	ath6kl_dbg(ATH6KL_DBG_TRC, "board data download addr: 0x%x\n",
 		   board_address);
 
@@ -737,13 +763,28 @@ static int ath6kl_upload_board_file(struct ath6kl *ar)
 		return -EINVAL;
 	}
 
-	if (ar->fw_board_len == (AR6003_BOARD_DATA_SZ +
-				 AR6003_BOARD_EXT_DATA_SZ)) {
+	switch (ar->target_type) {
+	case TARGET_TYPE_AR6003:
+		board_data_size = AR6003_BOARD_DATA_SZ;
+		board_ext_data_size = AR6003_BOARD_EXT_DATA_SZ;
+		break;
+	case TARGET_TYPE_AR6004:
+		board_data_size = AR6004_BOARD_DATA_SZ;
+		board_ext_data_size = AR6004_BOARD_EXT_DATA_SZ;
+		break;
+	default:
+		WARN_ON(1);
+		return -EINVAL;
+		break;
+	}
+
+	if (ar->fw_board_len == (board_data_size +
+				 board_ext_data_size)) {
+
 		/* write extended board data */
 		ret = ath6kl_bmi_write(ar, board_ext_address,
-				       ar->fw_board + AR6003_BOARD_DATA_SZ,
-				       AR6003_BOARD_EXT_DATA_SZ);
-
+				       ar->fw_board + board_data_size,
+				       board_ext_data_size);
 		if (ret) {
 			ath6kl_err("Failed to write extended board data: %d\n",
 				   ret);
@@ -751,21 +792,22 @@ static int ath6kl_upload_board_file(struct ath6kl *ar)
 		}
 
 		/* record that extended board data is initialized */
-		param = (AR6003_BOARD_EXT_DATA_SZ << 16) | 1;
+		param = (board_ext_data_size << 16) | 1;
+
 		ath6kl_bmi_write(ar,
 				 ath6kl_get_hi_item_addr(ar,
 				 HI_ITEM(hi_board_ext_data_config)),
 				 (unsigned char *) &param, 4);
 	}
 
-	if (ar->fw_board_len < AR6003_BOARD_DATA_SZ) {
+	if (ar->fw_board_len < board_data_size) {
 		ath6kl_err("Too small board file: %zu\n", ar->fw_board_len);
 		ret = -EINVAL;
 		return ret;
 	}
 
 	ret = ath6kl_bmi_write(ar, board_address, ar->fw_board,
-			       AR6003_BOARD_DATA_SZ);
+			       board_data_size);
 
 	if (ret) {
 		ath6kl_err("Board file bmi write failed: %d\n", ret);
@@ -792,6 +834,10 @@ static int ath6kl_upload_otp(struct ath6kl *ar)
 	case AR6003_REV2_VERSION:
 		filename = AR6003_REV2_OTP_FILE;
 		break;
+	case AR6004_REV1_VERSION:
+		ath6kl_dbg(ATH6KL_DBG_TRC, "AR6004 doesn't need OTP file\n");
+		return 0;
+		break;
 	default:
 		filename = AR6003_REV3_OTP_FILE;
 		break;
@@ -836,6 +882,9 @@ static int ath6kl_upload_firmware(struct ath6kl *ar)
 	case AR6003_REV2_VERSION:
 		filename = AR6003_REV2_FIRMWARE_FILE;
 		break;
+	case AR6004_REV1_VERSION:
+		filename = AR6004_REV1_FIRMWARE_FILE;
+		break;
 	default:
 		filename = AR6003_REV3_FIRMWARE_FILE;
 		break;
@@ -860,11 +909,15 @@ static int ath6kl_upload_firmware(struct ath6kl *ar)
 		return ret;
 	}
 
-	/* Set starting address for firmware */
-	address = ath6kl_get_load_address(ar->version.target_ver,
-					  APP_START_OVERRIDE_ADDR);
-	ath6kl_bmi_set_app_start(ar, address);
-
+	/*
+	 * Set starting address for firmware
+	 * Don't need to setup app_start override addr on AR6004
+	 */
+	if (ar->target_type != TARGET_TYPE_AR6004) {
+		address = ath6kl_get_load_address(ar->version.target_ver,
+						  APP_START_OVERRIDE_ADDR);
+		ath6kl_bmi_set_app_start(ar, address);
+	}
 	return ret;
 }
 
@@ -878,6 +931,10 @@ static int ath6kl_upload_patch(struct ath6kl *ar)
 	case AR6003_REV2_VERSION:
 		filename = AR6003_REV2_PATCH_FILE;
 		break;
+	case AR6004_REV1_VERSION:
+		/* FIXME: implement for AR6004 */
+		return 0;
+		break;
 	default:
 		filename = AR6003_REV3_PATCH_FILE;
 		break;
@@ -916,7 +973,8 @@ static int ath6kl_init_upload(struct ath6kl *ar)
 	u32 param, options, sleep, address;
 	int status = 0;
 
-	if (ar->target_type != TARGET_TYPE_AR6003)
+	if (ar->target_type != TARGET_TYPE_AR6003 &&
+		ar->target_type != TARGET_TYPE_AR6004)
 		return -EINVAL;
 
 	/* temporarily disable system sleep */
@@ -948,18 +1006,22 @@ static int ath6kl_init_upload(struct ath6kl *ar)
 		   options, sleep);
 
 	/* program analog PLL register */
-	status = ath6kl_bmi_reg_write(ar, ATH6KL_ANALOG_PLL_REGISTER,
-				      0xF9104001);
-	if (status)
-		return status;
+	/* no need to control 40/44MHz clock on AR6004 */
+	if (ar->target_type != TARGET_TYPE_AR6004) {
+		status = ath6kl_bmi_reg_write(ar, ATH6KL_ANALOG_PLL_REGISTER,
+					      0xF9104001);
 
-	/* Run at 80/88MHz by default */
-	param = SM(CPU_CLOCK_STANDARD, 1);
+		if (status)
+			return status;
 
-	address = RTC_BASE_ADDRESS + CPU_CLOCK_ADDRESS;
-	status = ath6kl_bmi_reg_write(ar, address, param);
-	if (status)
-		return status;
+		/* Run at 80/88MHz by default */
+		param = SM(CPU_CLOCK_STANDARD, 1);
+
+		address = RTC_BASE_ADDRESS + CPU_CLOCK_ADDRESS;
+		status = ath6kl_bmi_reg_write(ar, address, param);
+		if (status)
+			return status;
+	}
 
 	param = 0;
 	address = RTC_BASE_ADDRESS + LPO_CAL_ADDRESS;
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index c336eae..3cee0e3 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -305,7 +305,8 @@ static void ath6kl_reset_device(struct ath6kl *ar, u32 target_type,
 	u32 address;
 	u32 data;
 
-	if (target_type != TARGET_TYPE_AR6003)
+	if (target_type != TARGET_TYPE_AR6003 &&
+		target_type != TARGET_TYPE_AR6004)
 		return;
 
 	data = cold_reset ? RESET_CONTROL_COLD_RST : RESET_CONTROL_MBOX_RST;
diff --git a/drivers/net/wireless/ath/ath6kl/target.h b/drivers/net/wireless/ath/ath6kl/target.h
index 519a013..53e2c78 100644
--- a/drivers/net/wireless/ath/ath6kl/target.h
+++ b/drivers/net/wireless/ath/ath6kl/target.h
@@ -20,6 +20,9 @@
 #define AR6003_BOARD_DATA_SZ		1024
 #define AR6003_BOARD_EXT_DATA_SZ	768
 
+#define AR6004_BOARD_DATA_SZ     7168
+#define AR6004_BOARD_EXT_DATA_SZ 0
+
 #define RESET_CONTROL_ADDRESS		0x00000000
 #define RESET_CONTROL_COLD_RST		0x00000100
 #define RESET_CONTROL_MBOX_RST		0x00000004
@@ -135,7 +138,8 @@
  * between the two, and is intended to remain constant (with additions only
  * at the end).
  */
-#define ATH6KL_HI_START_ADDR           0x00540600
+#define ATH6KL_AR6003_HI_START_ADDR           0x00540600
+#define ATH6KL_AR6004_HI_START_ADDR           0x00400800
 
 /*
  * These are items that the Host may need to access
@@ -314,7 +318,12 @@ struct host_interest {
 #define HI_OPTION_FW_MODE_SHIFT        0xC
 
 /* Convert a Target virtual address into a Target physical address */
-#define TARG_VTOP(vaddr)   (vaddr & 0x001fffff)
+#define AR6003_VTOP(vaddr) ((vaddr) & 0x001fffff)
+#define AR6004_VTOP(vaddr) (vaddr)
+
+#define TARG_VTOP(target_type, vaddr) \
+	(((target_type) == TARGET_TYPE_AR6003) ? AR6003_VTOP(vaddr) : \
+	(((target_type) == TARGET_TYPE_AR6004) ? AR6004_VTOP(vaddr) : 0))
 
 #define AR6003_REV2_APP_START_OVERRIDE          0x944C00
 #define AR6003_REV2_APP_LOAD_ADDRESS            0x543180
@@ -328,4 +337,7 @@ struct host_interest {
 #define AR6003_REV3_DATASET_PATCH_ADDRESS       0x57FF74
 #define AR6003_REV3_RAM_RESERVE_SIZE            512
 
+#define AR6004_REV1_BOARD_DATA_ADDRESS          0x435400
+#define AR6004_REV1_BOARD_EXT_DATA_ADDRESS      0x437000
+#define AR6004_REV1_RAM_RESERVE_SIZE            11264
 #endif
-- 
1.7.0.4

