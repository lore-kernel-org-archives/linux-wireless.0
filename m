Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51628 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbcF0Iov (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2016 04:44:51 -0400
From: <c_traja@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Tamizh chelvam <c_traja@qti.qualcomm.com>
Subject: [PATCH 1/3] ath10k: move firmware_swap_code_seg_info to ath10k_fw_file
Date: Mon, 27 Jun 2016 14:20:10 +0530
Message-ID: <1467017410-32128-1-git-send-email-c_traja@qti.qualcomm.com> (sfid-20160627_104454_307159_2B6382D6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <c_traja@qti.qualcomm.com>

Preparation to make use of firmware_swap_code_seg_info for
UTF binary.

Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |    6 +++---
 drivers/net/wireless/ath/ath10k/core.h |    6 ++----
 drivers/net/wireless/ath/ath10k/swap.c |   26 ++++++++++++++------------
 drivers/net/wireless/ath/ath10k/swap.h |   11 ++++++++---
 4 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index dfb3db0..0a1946b 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -723,7 +723,7 @@ static int ath10k_download_fw(struct ath10k *ar)
 	data = ar->running_fw->fw_file.firmware_data;
 	data_len = ar->running_fw->fw_file.firmware_len;
 
-	ret = ath10k_swap_code_seg_configure(ar);
+	ret = ath10k_swap_code_seg_configure(ar, &ar->running_fw->fw_file);
 	if (ret) {
 		ath10k_err(ar, "failed to configure fw code swap: %d\n",
 			   ret);
@@ -765,7 +765,7 @@ static void ath10k_core_free_firmware_files(struct ath10k *ar)
 	if (!IS_ERR(ar->pre_cal_file))
 		release_firmware(ar->pre_cal_file);
 
-	ath10k_swap_code_seg_release(ar);
+	ath10k_swap_code_seg_release(ar, &ar->normal_mode_fw.fw_file);
 
 	ar->normal_mode_fw.fw_file.otp_data = NULL;
 	ar->normal_mode_fw.fw_file.otp_len = 0;
@@ -2009,7 +2009,7 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 		goto err_free_firmware_files;
 	}
 
-	ret = ath10k_swap_code_seg_init(ar);
+	ret = ath10k_swap_code_seg_init(ar, &ar->normal_mode_fw.fw_file);
 	if (ret) {
 		ath10k_err(ar, "failed to initialize code swap segment: %d\n",
 			   ret);
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 3da18c9..e69e7e7 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -654,6 +654,8 @@ struct ath10k_fw_file {
 
 	const void *codeswap_data;
 	size_t codeswap_len;
+	/* FIXME: add a comment */
+	struct ath10k_swap_code_seg_info *firmware_swap_code_seg_info;
 };
 
 struct ath10k_fw_components {
@@ -765,10 +767,6 @@ struct ath10k {
 	const struct firmware *cal_file;
 
 	struct {
-		struct ath10k_swap_code_seg_info *firmware_swap_code_seg_info;
-	} swap;
-
-	struct {
 		u32 vendor;
 		u32 device;
 		u32 subsystem_vendor;
diff --git a/drivers/net/wireless/ath/ath10k/swap.c b/drivers/net/wireless/ath/ath10k/swap.c
index 0c5f586..c904a41 100644
--- a/drivers/net/wireless/ath/ath10k/swap.c
+++ b/drivers/net/wireless/ath/ath10k/swap.c
@@ -134,17 +134,18 @@ ath10k_swap_code_seg_alloc(struct ath10k *ar, size_t swap_bin_len)
 	return seg_info;
 }
 
-int ath10k_swap_code_seg_configure(struct ath10k *ar)
+int ath10k_swap_code_seg_configure(struct ath10k *ar,
+				   const struct ath10k_fw_file *fw_file)
 {
 	int ret;
 	struct ath10k_swap_code_seg_info *seg_info = NULL;
 
-	if (!ar->swap.firmware_swap_code_seg_info)
+	if (fw_file->firmware_swap_code_seg_info)
 		return 0;
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot found firmware code swap binary\n");
 
-	seg_info = ar->swap.firmware_swap_code_seg_info;
+	seg_info = fw_file->firmware_swap_code_seg_info;
 
 	ret = ath10k_bmi_write_memory(ar, seg_info->target_addr,
 				      &seg_info->seg_hw_info,
@@ -158,28 +159,29 @@ int ath10k_swap_code_seg_configure(struct ath10k *ar)
 	return 0;
 }
 
-void ath10k_swap_code_seg_release(struct ath10k *ar)
+void ath10k_swap_code_seg_release(struct ath10k *ar,
+				  struct ath10k_fw_file *fw_file)
 {
-	ath10k_swap_code_seg_free(ar, ar->swap.firmware_swap_code_seg_info);
+	ath10k_swap_code_seg_free(ar, fw_file->firmware_swap_code_seg_info);
 
 	/* FIXME: these two assignments look to bein wrong place! Shouldn't
 	 * they be in ath10k_core_free_firmware_files() like the rest?
 	 */
-	ar->normal_mode_fw.fw_file.codeswap_data = NULL;
-	ar->normal_mode_fw.fw_file.codeswap_len = 0;
+	fw_file->codeswap_data = NULL;
+	fw_file->codeswap_len = 0;
 
-	ar->swap.firmware_swap_code_seg_info = NULL;
+	fw_file->firmware_swap_code_seg_info = NULL;
 }
 
-int ath10k_swap_code_seg_init(struct ath10k *ar)
+int ath10k_swap_code_seg_init(struct ath10k *ar, struct ath10k_fw_file *fw_file)
 {
 	int ret;
 	struct ath10k_swap_code_seg_info *seg_info;
 	const void *codeswap_data;
 	size_t codeswap_len;
 
-	codeswap_data = ar->normal_mode_fw.fw_file.codeswap_data;
-	codeswap_len = ar->normal_mode_fw.fw_file.codeswap_len;
+	codeswap_data = fw_file->codeswap_data;
+	codeswap_len = fw_file->codeswap_len;
 
 	if (!codeswap_len || !codeswap_data)
 		return 0;
@@ -200,7 +202,7 @@ int ath10k_swap_code_seg_init(struct ath10k *ar)
 		return ret;
 	}
 
-	ar->swap.firmware_swap_code_seg_info = seg_info;
+	fw_file->firmware_swap_code_seg_info = seg_info;
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath10k/swap.h b/drivers/net/wireless/ath/ath10k/swap.h
index 36991c7..f5dc047 100644
--- a/drivers/net/wireless/ath/ath10k/swap.h
+++ b/drivers/net/wireless/ath/ath10k/swap.h
@@ -23,6 +23,8 @@
 /* Currently only one swap segment is supported */
 #define ATH10K_SWAP_CODE_SEG_NUM_SUPPORTED	1
 
+struct ath10k_fw_file;
+
 struct ath10k_swap_code_seg_tlv {
 	__le32 address;
 	__le32 length;
@@ -58,8 +60,11 @@ struct ath10k_swap_code_seg_info {
 	dma_addr_t paddr[ATH10K_SWAP_CODE_SEG_NUM_SUPPORTED];
 };
 
-int ath10k_swap_code_seg_configure(struct ath10k *ar);
-void ath10k_swap_code_seg_release(struct ath10k *ar);
-int ath10k_swap_code_seg_init(struct ath10k *ar);
+int ath10k_swap_code_seg_configure(struct ath10k *ar,
+				   const struct ath10k_fw_file *fw_file);
+void ath10k_swap_code_seg_release(struct ath10k *ar,
+				  struct ath10k_fw_file *fw_file);
+int ath10k_swap_code_seg_init(struct ath10k *ar,
+			      struct ath10k_fw_file *fw_file);
 
 #endif
-- 
1.7.9.5

