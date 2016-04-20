Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40041 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbcDTQqa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2016 12:46:30 -0400
Subject: [PATCH v2 8/8] ath10k: remove enum ath10k_swap_code_seg_bin_type
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Wed, 20 Apr 2016 19:46:16 +0300
Message-ID: <20160420164616.8801.45530.stgit@potku.adurom.net> (sfid-20160420_184633_465566_BAD44E1F)
In-Reply-To: <20160420164301.8801.12099.stgit@potku.adurom.net>
References: <20160420164301.8801.12099.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's not needed for anything so just get rid of it.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |    3 +--
 drivers/net/wireless/ath/ath10k/swap.c |   22 ++++++----------------
 drivers/net/wireless/ath/ath10k/swap.h |    9 +--------
 3 files changed, 8 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index db9437a72ba4..e94cb87380d2 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -647,8 +647,7 @@ static int ath10k_download_fw(struct ath10k *ar)
 	data = ar->running_fw->fw_file.firmware_data;
 	data_len = ar->running_fw->fw_file.firmware_len;
 
-	ret = ath10k_swap_code_seg_configure(ar,
-					     ATH10K_SWAP_CODE_SEG_BIN_TYPE_FW);
+	ret = ath10k_swap_code_seg_configure(ar);
 	if (ret) {
 		ath10k_err(ar, "failed to configure fw code swap: %d\n",
 			   ret);
diff --git a/drivers/net/wireless/ath/ath10k/swap.c b/drivers/net/wireless/ath/ath10k/swap.c
index 47d449bac86d..0c5f5863dac8 100644
--- a/drivers/net/wireless/ath/ath10k/swap.c
+++ b/drivers/net/wireless/ath/ath10k/swap.c
@@ -134,27 +134,17 @@ ath10k_swap_code_seg_alloc(struct ath10k *ar, size_t swap_bin_len)
 	return seg_info;
 }
 
-int ath10k_swap_code_seg_configure(struct ath10k *ar,
-				   enum ath10k_swap_code_seg_bin_type type)
+int ath10k_swap_code_seg_configure(struct ath10k *ar)
 {
 	int ret;
 	struct ath10k_swap_code_seg_info *seg_info = NULL;
 
-	switch (type) {
-	case ATH10K_SWAP_CODE_SEG_BIN_TYPE_FW:
-		if (!ar->swap.firmware_swap_code_seg_info)
-			return 0;
-
-		ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot found firmware code swap binary\n");
-		seg_info = ar->swap.firmware_swap_code_seg_info;
-		break;
-	default:
-	case ATH10K_SWAP_CODE_SEG_BIN_TYPE_OTP:
-	case ATH10K_SWAP_CODE_SEG_BIN_TYPE_UTF:
-		ath10k_warn(ar, "ignoring unknown code swap binary type %d\n",
-			    type);
+	if (!ar->swap.firmware_swap_code_seg_info)
 		return 0;
-	}
+
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot found firmware code swap binary\n");
+
+	seg_info = ar->swap.firmware_swap_code_seg_info;
 
 	ret = ath10k_bmi_write_memory(ar, seg_info->target_addr,
 				      &seg_info->seg_hw_info,
diff --git a/drivers/net/wireless/ath/ath10k/swap.h b/drivers/net/wireless/ath/ath10k/swap.h
index 5c89952dd20f..36991c7b07a0 100644
--- a/drivers/net/wireless/ath/ath10k/swap.h
+++ b/drivers/net/wireless/ath/ath10k/swap.h
@@ -39,12 +39,6 @@ union ath10k_swap_code_seg_item {
 	struct ath10k_swap_code_seg_tail tail;
 } __packed;
 
-enum ath10k_swap_code_seg_bin_type {
-	 ATH10K_SWAP_CODE_SEG_BIN_TYPE_OTP,
-	 ATH10K_SWAP_CODE_SEG_BIN_TYPE_FW,
-	 ATH10K_SWAP_CODE_SEG_BIN_TYPE_UTF,
-};
-
 struct ath10k_swap_code_seg_hw_info {
 	/* Swap binary image size */
 	__le32 swap_size;
@@ -64,8 +58,7 @@ struct ath10k_swap_code_seg_info {
 	dma_addr_t paddr[ATH10K_SWAP_CODE_SEG_NUM_SUPPORTED];
 };
 
-int ath10k_swap_code_seg_configure(struct ath10k *ar,
-				   enum ath10k_swap_code_seg_bin_type type);
+int ath10k_swap_code_seg_configure(struct ath10k *ar);
 void ath10k_swap_code_seg_release(struct ath10k *ar);
 int ath10k_swap_code_seg_init(struct ath10k *ar);
 

