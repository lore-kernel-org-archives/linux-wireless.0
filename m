Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:39504 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab3I0NVC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Sep 2013 09:21:02 -0400
Subject: [PATCH v2 2/3] ath10k: store separate pointers for firmware data
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 27 Sep 2013 16:20:58 +0300
Message-ID: <20130927132058.20789.36466.stgit@localhost6.localdomain6> (sfid-20130927_152106_128386_75FF2BEA)
In-Reply-To: <20130927131812.20789.9941.stgit@localhost6.localdomain6>
References: <20130927131812.20789.9941.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Needed for firmware IE formatted images.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |   43 ++++++++++++++++++++++----------
 drivers/net/wireless/ath/ath10k/core.h |    8 ++++++
 2 files changed, 37 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index e07c487..6a354f7 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -189,8 +189,7 @@ static const struct firmware *ath10k_fetch_fw_file(struct ath10k *ar,
 	return fw;
 }
 
-static int ath10k_push_board_ext_data(struct ath10k *ar,
-				      const struct firmware *fw)
+static int ath10k_push_board_ext_data(struct ath10k *ar)
 {
 	u32 board_data_size = QCA988X_BOARD_DATA_SZ;
 	u32 board_ext_data_size = QCA988X_BOARD_EXT_DATA_SZ;
@@ -210,14 +209,14 @@ static int ath10k_push_board_ext_data(struct ath10k *ar,
 	if (board_ext_data_addr == 0)
 		return 0;
 
-	if (fw->size != (board_data_size + board_ext_data_size)) {
+	if (ar->board_len != (board_data_size + board_ext_data_size)) {
 		ath10k_err("invalid board (ext) data sizes %zu != %d+%d\n",
-			   fw->size, board_data_size, board_ext_data_size);
+			   ar->board_len, board_data_size, board_ext_data_size);
 		return -EINVAL;
 	}
 
 	ret = ath10k_bmi_write_memory(ar, board_ext_data_addr,
-				      fw->data + board_data_size,
+				      ar->board_data + board_data_size,
 				      board_ext_data_size);
 	if (ret) {
 		ath10k_err("could not write board ext data (%d)\n", ret);
@@ -236,12 +235,11 @@ static int ath10k_push_board_ext_data(struct ath10k *ar,
 
 static int ath10k_download_board_data(struct ath10k *ar)
 {
-	const struct firmware *fw = ar->board;
 	u32 board_data_size = QCA988X_BOARD_DATA_SZ;
 	u32 address;
 	int ret;
 
-	ret = ath10k_push_board_ext_data(ar, fw);
+	ret = ath10k_push_board_ext_data(ar);
 	if (ret) {
 		ath10k_err("could not push board ext data (%d)\n", ret);
 		goto exit;
@@ -253,8 +251,9 @@ static int ath10k_download_board_data(struct ath10k *ar)
 		goto exit;
 	}
 
-	ret = ath10k_bmi_write_memory(ar, address, fw->data,
-				      min_t(u32, board_data_size, fw->size));
+	ret = ath10k_bmi_write_memory(ar, address, ar->board_data,
+				      min_t(u32, board_data_size,
+					    ar->board_len));
 	if (ret) {
 		ath10k_err("could not write board data (%d)\n", ret);
 		goto exit;
@@ -272,17 +271,16 @@ exit:
 
 static int ath10k_download_and_run_otp(struct ath10k *ar)
 {
-	const struct firmware *fw = ar->otp;
 	u32 address = ar->hw_params.patch_load_addr;
 	u32 exec_param;
 	int ret;
 
 	/* OTP is optional */
 
-	if (!ar->otp)
+	if (!ar->otp_data || !ar->otp_len)
 		return 0;
 
-	ret = ath10k_bmi_fast_download(ar, address, fw->data, fw->size);
+	ret = ath10k_bmi_fast_download(ar, address, ar->otp_data, ar->otp_len);
 	if (ret) {
 		ath10k_err("could not write otp (%d)\n", ret);
 		goto exit;
@@ -301,13 +299,13 @@ exit:
 
 static int ath10k_download_fw(struct ath10k *ar)
 {
-	const struct firmware *fw = ar->firmware;
 	u32 address;
 	int ret;
 
 	address = ar->hw_params.patch_load_addr;
 
-	ret = ath10k_bmi_fast_download(ar, address, fw->data, fw->size);
+	ret = ath10k_bmi_fast_download(ar, address, ar->firmware_data,
+				       ar->firmware_len);
 	if (ret) {
 		ath10k_err("could not write fw (%d)\n", ret);
 		goto exit;
@@ -329,8 +327,16 @@ static void ath10k_core_free_firmware_files(struct ath10k *ar)
 		release_firmware(ar->firmware);
 
 	ar->board = NULL;
+	ar->board_data = NULL;
+	ar->board_len = 0;
+
 	ar->otp = NULL;
+	ar->otp_data = NULL;
+	ar->otp_len = 0;
+
 	ar->firmware = NULL;
+	ar->firmware_data = NULL;
+	ar->firmware_len = 0;
 }
 
 static int ath10k_core_fetch_firmware_files(struct ath10k *ar)
@@ -356,6 +362,9 @@ static int ath10k_core_fetch_firmware_files(struct ath10k *ar)
 		goto err;
 	}
 
+	ar->board_data = ar->board->data;
+	ar->board_len = ar->board->size;
+
 	ar->firmware = ath10k_fetch_fw_file(ar,
 					    ar->hw_params.fw.dir,
 					    ar->hw_params.fw.fw);
@@ -365,6 +374,9 @@ static int ath10k_core_fetch_firmware_files(struct ath10k *ar)
 		goto err;
 	}
 
+	ar->firmware_data = ar->firmware->data;
+	ar->firmware_len = ar->firmware->size;
+
 	/* OTP may be undefined. If so, don't fetch it at all */
 	if (ar->hw_params.fw.otp == NULL)
 		return 0;
@@ -378,6 +390,9 @@ static int ath10k_core_fetch_firmware_files(struct ath10k *ar)
 		goto err;
 	}
 
+	ar->otp_data = ar->otp->data;
+	ar->otp_len = ar->otp->size;
+
 	return 0;
 
 err:
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 12b03b6..511b20d 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -325,8 +325,16 @@ struct ath10k {
 	} hw_params;
 
 	const struct firmware *board;
+	const void *board_data;
+	size_t board_len;
+
 	const struct firmware *otp;
+	const void *otp_data;
+	size_t otp_len;
+
 	const struct firmware *firmware;
+	const void *firmware_data;
+	size_t firmware_len;
 
 	struct {
 		struct completion started;

