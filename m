Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60791 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbcDFOqa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 10:46:30 -0400
Subject: [PATCH 8/8] ath10k: remove enum ath10k_swap_code_seg_bin_type
To: <ath10k@lists.infradead.org>
From: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Date: Wed, 6 Apr 2016 17:46:19 +0300
Message-ID: <20160406144619.28399.18013.stgit@potku.adurom.net> (sfid-20160406_164634_063908_A7DE953B)
In-Reply-To: <20160406144355.28399.23733.stgit@potku.adurom.net>
References: <20160406144355.28399.23733.stgit@potku.adurom.net>
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
index d0cecab5aaec..55f3a80b2884 100644
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
index 8d6dc86799f5..af447a60143b 100644
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
 

