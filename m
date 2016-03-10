Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2318 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965658AbcCJKNa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2016 05:13:30 -0500
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH 2/3] ath10k: move cal data len to hw_params
Date: Thu, 10 Mar 2016 15:42:37 +0530
Message-ID: <1457604758-14454-3-git-send-email-rmani@qti.qualcomm.com> (sfid-20160310_111357_089939_7915EFC8)
In-Reply-To: <1457604758-14454-1-git-send-email-rmani@qti.qualcomm.com>
References: <1457604758-14454-1-git-send-email-rmani@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath10k_download_cal_dt() compares obtained cal data content length
against QCA988X_CAL_DATA_LEN (2116 bytes). It was written by keeping
qca988x in mind. In fact, cal data length is more chip specific.
To make ath10k_download_cal_dt() more generic and reusable for other
chipsets (like qca4019), cal data length is moved to hw_params.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c  | 11 ++++++++++-
 drivers/net/wireless/ath/ath10k/core.h  |  1 +
 drivers/net/wireless/ath/ath10k/debug.c |  7 ++++---
 drivers/net/wireless/ath/ath10k/hw.h    |  2 --
 4 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 4ec4d72..2a901c6 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -60,6 +60,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.channel_counters_freq_hz = 88000,
 		.max_probe_resp_desc_thres = 0,
 		.hw_4addr_pad = ATH10K_HW_4ADDR_PAD_AFTER,
+		.cal_data_len = 2116,
 		.fw = {
 			.dir = QCA988X_HW_2_0_FW_DIR,
 			.fw = QCA988X_HW_2_0_FW_FILE,
@@ -78,6 +79,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.otp_exe_param = 0,
 		.channel_counters_freq_hz = 88000,
 		.max_probe_resp_desc_thres = 0,
+		.cal_data_len = 8124,
 		.fw = {
 			.dir = QCA6174_HW_2_1_FW_DIR,
 			.fw = QCA6174_HW_2_1_FW_FILE,
@@ -97,6 +99,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.channel_counters_freq_hz = 88000,
 		.max_probe_resp_desc_thres = 0,
 		.hw_4addr_pad = ATH10K_HW_4ADDR_PAD_AFTER,
+		.cal_data_len = 8124,
 		.fw = {
 			.dir = QCA6174_HW_2_1_FW_DIR,
 			.fw = QCA6174_HW_2_1_FW_FILE,
@@ -116,6 +119,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.channel_counters_freq_hz = 88000,
 		.max_probe_resp_desc_thres = 0,
 		.hw_4addr_pad = ATH10K_HW_4ADDR_PAD_AFTER,
+		.cal_data_len = 8124,
 		.fw = {
 			.dir = QCA6174_HW_3_0_FW_DIR,
 			.fw = QCA6174_HW_3_0_FW_FILE,
@@ -135,6 +139,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.channel_counters_freq_hz = 88000,
 		.max_probe_resp_desc_thres = 0,
 		.hw_4addr_pad = ATH10K_HW_4ADDR_PAD_AFTER,
+		.cal_data_len = 8124,
 		.fw = {
 			/* uses same binaries as hw3.0 */
 			.dir = QCA6174_HW_3_0_FW_DIR,
@@ -159,6 +164,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.tx_chain_mask = 0xf,
 		.rx_chain_mask = 0xf,
 		.max_spatial_stream = 4,
+		.cal_data_len = 12064,
 		.fw = {
 			.dir = QCA99X0_HW_2_0_FW_DIR,
 			.fw = QCA99X0_HW_2_0_FW_FILE,
@@ -177,6 +183,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.otp_exe_param = 0,
 		.channel_counters_freq_hz = 88000,
 		.max_probe_resp_desc_thres = 0,
+		.cal_data_len = 8124,
 		.fw = {
 			.dir = QCA9377_HW_1_0_FW_DIR,
 			.fw = QCA9377_HW_1_0_FW_FILE,
@@ -195,6 +202,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.otp_exe_param = 0,
 		.channel_counters_freq_hz = 88000,
 		.max_probe_resp_desc_thres = 0,
+		.cal_data_len = 8124,
 		.fw = {
 			.dir = QCA9377_HW_1_0_FW_DIR,
 			.fw = QCA9377_HW_1_0_FW_FILE,
@@ -218,6 +226,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.tx_chain_mask = 0x3,
 		.rx_chain_mask = 0x3,
 		.max_spatial_stream = 2,
+		.cal_data_len = 12064,
 		.fw = {
 			.dir = QCA4019_HW_1_0_FW_DIR,
 			.fw = QCA4019_HW_1_0_FW_FILE,
@@ -503,7 +512,7 @@ static int ath10k_download_cal_dt(struct ath10k *ar, const char *dt_name)
 		return -ENOENT;
 	}
 
-	if (data_len != QCA988X_CAL_DATA_LEN) {
+	if (data_len != ar->hw_params.cal_data_len) {
 		ath10k_warn(ar, "invalid calibration data length in DT: %d\n",
 			    data_len);
 		ret = -EMSGSIZE;
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 23ba03f..322a9eb 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -695,6 +695,7 @@ struct ath10k {
 		u32 tx_chain_mask;
 		u32 rx_chain_mask;
 		u32 max_spatial_stream;
+		u32 cal_data_len;
 
 		struct ath10k_hw_params_fw {
 			const char *dir;
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 076d29b..48f2835 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1447,7 +1447,7 @@ static int ath10k_debug_cal_data_open(struct inode *inode, struct file *file)
 		goto err;
 	}
 
-	buf = vmalloc(QCA988X_CAL_DATA_LEN);
+	buf = vmalloc(ar->hw_params.cal_data_len);
 	if (!buf) {
 		ret = -ENOMEM;
 		goto err;
@@ -1462,7 +1462,7 @@ static int ath10k_debug_cal_data_open(struct inode *inode, struct file *file)
 	}
 
 	ret = ath10k_hif_diag_read(ar, le32_to_cpu(addr), buf,
-				   QCA988X_CAL_DATA_LEN);
+				   ar->hw_params.cal_data_len);
 	if (ret) {
 		ath10k_warn(ar, "failed to read calibration data: %d\n", ret);
 		goto err_vfree;
@@ -1487,10 +1487,11 @@ static ssize_t ath10k_debug_cal_data_read(struct file *file,
 					  char __user *user_buf,
 					  size_t count, loff_t *ppos)
 {
+	struct ath10k *ar = file->private_data;
 	void *buf = file->private_data;
 
 	return simple_read_from_buffer(user_buf, count, ppos,
-				       buf, QCA988X_CAL_DATA_LEN);
+				       buf, ar->hw_params.cal_data_len);
 }
 
 static int ath10k_debug_cal_data_release(struct inode *inode,
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 1ff617b..c0179bc 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -134,8 +134,6 @@ enum qca9377_chip_id_rev {
 
 #define REG_DUMP_COUNT_QCA988X 60
 
-#define QCA988X_CAL_DATA_LEN		2116
-
 struct ath10k_fw_ie {
 	__le32 id;
 	__le32 len;
-- 
1.8.1.2

