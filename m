Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10818 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbbFRHEd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2015 03:04:33 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH V2 10/10] ath10k: Add BMI param value to execute otp to hw_param
Date: Thu, 18 Jun 2015 12:31:10 +0530
Message-ID: <1434610870-5505-11-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20150618_090436_761650_180C521C)
In-Reply-To: <1434610870-5505-1-git-send-email-vthiagar@qti.qualcomm.com>
References: <1434610870-5505-1-git-send-email-vthiagar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

BMI parameter value to execute downloaded otp binary
is different for QCA99X0. Have a member in hw_params
to hold hw specific BMI param.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 8 +++++++-
 drivers/net/wireless/ath/ath10k/core.h | 1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index c5f5d16..80f38b5 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -49,6 +49,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.patch_load_addr = QCA988X_HW_2_0_PATCH_LOAD_ADDR,
 		.uart_pin = 7,
 		.has_shifted_cc_wraparound = true,
+		.otp_exe_param = 0,
 		.fw = {
 			.dir = QCA988X_HW_2_0_FW_DIR,
 			.fw = QCA988X_HW_2_0_FW_FILE,
@@ -63,6 +64,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.name = "qca6174 hw2.1",
 		.patch_load_addr = QCA6174_HW_2_1_PATCH_LOAD_ADDR,
 		.uart_pin = 6,
+		.otp_exe_param = 0,
 		.fw = {
 			.dir = QCA6174_HW_2_1_FW_DIR,
 			.fw = QCA6174_HW_2_1_FW_FILE,
@@ -77,6 +79,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.name = "qca6174 hw3.0",
 		.patch_load_addr = QCA6174_HW_3_0_PATCH_LOAD_ADDR,
 		.uart_pin = 6,
+		.otp_exe_param = 0,
 		.fw = {
 			.dir = QCA6174_HW_3_0_FW_DIR,
 			.fw = QCA6174_HW_3_0_FW_FILE,
@@ -91,6 +94,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.name = "qca6174 hw3.2",
 		.patch_load_addr = QCA6174_HW_3_0_PATCH_LOAD_ADDR,
 		.uart_pin = 6,
+		.otp_exe_param = 0,
 		.fw = {
 			/* uses same binaries as hw3.0 */
 			.dir = QCA6174_HW_3_0_FW_DIR,
@@ -106,6 +110,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.name = "qca99x0 hw2.0",
 		.patch_load_addr = QCA99X0_HW_2_0_PATCH_LOAD_ADDR,
 		.uart_pin = 7,
+		.otp_exe_param = 0x00000700,
 		.fw = {
 			.dir = QCA99X0_HW_2_0_FW_DIR,
 			.fw = QCA99X0_HW_2_0_FW_FILE,
@@ -413,6 +418,7 @@ out:
 static int ath10k_download_and_run_otp(struct ath10k *ar)
 {
 	u32 result, address = ar->hw_params.patch_load_addr;
+	u32 bmi_otp_exe_param = ar->hw_params.otp_exe_param;
 	int ret;
 
 	ret = ath10k_download_board_data(ar, ar->board_data, ar->board_len);
@@ -438,7 +444,7 @@ static int ath10k_download_and_run_otp(struct ath10k *ar)
 		return ret;
 	}
 
-	ret = ath10k_bmi_execute(ar, address, 0, &result);
+	ret = ath10k_bmi_execute(ar, address, bmi_otp_exe_param, &result);
 	if (ret) {
 		ath10k_err(ar, "could not execute otp (%d)\n", ret);
 		return ret;
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index b9145f5..afd21d5 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -572,6 +572,7 @@ struct ath10k {
 		const char *name;
 		u32 patch_load_addr;
 		int uart_pin;
+		u32 otp_exe_param;
 
 		/* This is true if given HW chip has a quirky Cycle Counter
 		 * wraparound which resets to 0x7fffffff instead of 0. All
-- 
1.9.1

