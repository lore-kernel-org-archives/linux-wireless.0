Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47480 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932AbbHLKyv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2015 06:54:51 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH 2/2] ath10k: Add cycle/rx_clear counters frequency to hw_params
Date: Wed, 12 Aug 2015 16:24:05 +0530
Message-ID: <1439376845-17245-2-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20150812_125504_353056_612104CE)
In-Reply-To: <1439376845-17245-1-git-send-email-vthiagar@qti.qualcomm.com>
References: <1439376845-17245-1-git-send-email-vthiagar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The frequency at which cycle/rx_clear counters are running might
change from one target type to another. QCA99X0 is running the
counters at 150Mhz while QCA9888X and QCA6174 are running at 88Mhz.
Add a new entry to hw_params to store the target specific frequency
and use it in msecs conversion. This change fixes inconsistent
channel active/busy time.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 5 +++++
 drivers/net/wireless/ath/ath10k/core.h | 2 ++
 drivers/net/wireless/ath/ath10k/hw.c   | 4 ++--
 drivers/net/wireless/ath/ath10k/hw.h   | 3 +--
 4 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 2551067..2efd4e4 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -53,6 +53,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.uart_pin = 7,
 		.has_shifted_cc_wraparound = true,
 		.otp_exe_param = 0,
+		.channel_counters_freq_hz = 88000,
 		.fw = {
 			.dir = QCA988X_HW_2_0_FW_DIR,
 			.fw = QCA988X_HW_2_0_FW_FILE,
@@ -68,6 +69,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.patch_load_addr = QCA6174_HW_2_1_PATCH_LOAD_ADDR,
 		.uart_pin = 6,
 		.otp_exe_param = 0,
+		.channel_counters_freq_hz = 88000,
 		.fw = {
 			.dir = QCA6174_HW_2_1_FW_DIR,
 			.fw = QCA6174_HW_2_1_FW_FILE,
@@ -83,6 +85,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.patch_load_addr = QCA6174_HW_3_0_PATCH_LOAD_ADDR,
 		.uart_pin = 6,
 		.otp_exe_param = 0,
+		.channel_counters_freq_hz = 88000,
 		.fw = {
 			.dir = QCA6174_HW_3_0_FW_DIR,
 			.fw = QCA6174_HW_3_0_FW_FILE,
@@ -98,6 +101,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.patch_load_addr = QCA6174_HW_3_0_PATCH_LOAD_ADDR,
 		.uart_pin = 6,
 		.otp_exe_param = 0,
+		.channel_counters_freq_hz = 88000,
 		.fw = {
 			/* uses same binaries as hw3.0 */
 			.dir = QCA6174_HW_3_0_FW_DIR,
@@ -115,6 +119,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.uart_pin = 7,
 		.otp_exe_param = 0x00000700,
 		.continuous_frag_desc = true,
+		.channel_counters_freq_hz = 150000,
 		.fw = {
 			.dir = QCA99X0_HW_2_0_FW_DIR,
 			.fw = QCA99X0_HW_2_0_FW_FILE,
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 6a387ba..862f6d0 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -609,6 +609,8 @@ struct ath10k {
 		 */
 		bool continuous_frag_desc;
 
+		u32 channel_counters_freq_hz;
+
 		struct ath10k_hw_params_fw {
 			const char *dir;
 			const char *fw;
diff --git a/drivers/net/wireless/ath/ath10k/hw.c b/drivers/net/wireless/ath/ath10k/hw.c
index fef7ccf..7b84d08 100644
--- a/drivers/net/wireless/ath/ath10k/hw.c
+++ b/drivers/net/wireless/ath/ath10k/hw.c
@@ -152,6 +152,6 @@ void ath10k_hw_fill_survey_time(struct ath10k *ar, struct survey_info *survey,
 	cc -= cc_prev - cc_fix;
 	rcc -= rcc_prev;
 
-	survey->time = CCNT_TO_MSEC(cc);
-	survey->time_busy = CCNT_TO_MSEC(rcc);
+	survey->time = CCNT_TO_MSEC(ar, cc);
+	survey->time_busy = CCNT_TO_MSEC(ar, rcc);
 }
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index d9de4a7..23afcda 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -552,8 +552,7 @@ enum ath10k_hw_rate_cck {
 #define SCRATCH_3_ADDRESS			ar->regs->scratch_3_address
 #define CPU_INTR_ADDRESS			0x0010
 
-/* Cycle counters are running at 88MHz */
-#define CCNT_TO_MSEC(x) ((x) / 88000)
+#define CCNT_TO_MSEC(ar, x) ((x) / ar->hw_params.channel_counters_freq_hz)
 
 /* Firmware indications to the Host via SCRATCH_3 register. */
 #define FW_INDICATOR_ADDRESS			ar->regs->fw_indicator_address
-- 
1.9.1

