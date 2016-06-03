Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:40672 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932411AbcFCPng (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2016 11:43:36 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH 1/2] ath10k: Define an enum to enable cycle counter wraparound logic
Date: Fri, 3 Jun 2016 21:13:15 +0530
Message-ID: <1464968596-19834-1-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20160603_174340_808282_1D8B0B6C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

QCA988X hw implements a different cycle counter wraparound
behaviour when compared to QCA4019. To properly handle different
wraparound logic for these chipsets replace already available
bool hw_params member, has_shifted_cc_wraparound, with an
enum which could be extended to handle different wraparound
behaviour. This patch keeps the existing logic functionally
same and a prepares cycle counter wraparound handling to
extend for other chips.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |  4 ++--
 drivers/net/wireless/ath/ath10k/core.h |  8 +++-----
 drivers/net/wireless/ath/ath10k/hw.c   |  4 +++-
 drivers/net/wireless/ath/ath10k/hw.h   | 11 +++++++++++
 4 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index cedf127..8f66653 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -55,7 +55,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.name = "qca988x hw2.0",
 		.patch_load_addr = QCA988X_HW_2_0_PATCH_LOAD_ADDR,
 		.uart_pin = 7,
-		.has_shifted_cc_wraparound = true,
+		.cc_wraparound_type = ATH10K_HW_CC_WRAP_SHIFTED_ALL,
 		.otp_exe_param = 0,
 		.channel_counters_freq_hz = 88000,
 		.max_probe_resp_desc_thres = 0,
@@ -224,7 +224,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.name = "qca4019 hw1.0",
 		.patch_load_addr = QCA4019_HW_1_0_PATCH_LOAD_ADDR,
 		.uart_pin = 7,
-		.has_shifted_cc_wraparound = true,
+		.cc_wraparound_type = ATH10K_HW_CC_WRAP_SHIFTED_ALL,
 		.otp_exe_param = 0x0010000,
 		.continuous_frag_desc = true,
 		.channel_counters_freq_hz = 125000,
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 4462c3f..b42b21f 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -710,12 +710,10 @@ struct ath10k {
 		int uart_pin;
 		u32 otp_exe_param;
 
-		/* This is true if given HW chip has a quirky Cycle Counter
-		 * wraparound which resets to 0x7fffffff instead of 0. All
-		 * other CC related counters (e.g. Rx Clear Count) are divided
-		 * by 2 so they never wraparound themselves.
+		/* Type of hw cycle counter wraparound logic, for more info
+		 * refer enum ath10k_hw_cc_wraparound_type.
 		 */
-		bool has_shifted_cc_wraparound;
+		enum ath10k_hw_cc_wraparound_type cc_wraparound_type;
 
 		/* Some of chip expects fragment descriptor to be continuous
 		 * memory for any TX operation. Set continuous_frag_desc flag
diff --git a/drivers/net/wireless/ath/ath10k/hw.c b/drivers/net/wireless/ath/ath10k/hw.c
index f544d48..31ec164 100644
--- a/drivers/net/wireless/ath/ath10k/hw.c
+++ b/drivers/net/wireless/ath/ath10k/hw.c
@@ -179,11 +179,13 @@ void ath10k_hw_fill_survey_time(struct ath10k *ar, struct survey_info *survey,
 				u32 cc, u32 rcc, u32 cc_prev, u32 rcc_prev)
 {
 	u32 cc_fix = 0;
+	enum ath10k_hw_cc_wraparound_type wraparound_type;
 
 	survey->filled |= SURVEY_INFO_TIME |
 			  SURVEY_INFO_TIME_BUSY;
 
-	if (ar->hw_params.has_shifted_cc_wraparound && cc < cc_prev) {
+	wraparound_type = ar->hw_params.cc_wraparound_type;
+	if (wraparound_type == ATH10K_HW_CC_WRAP_SHIFTED_ALL && cc < cc_prev) {
 		cc_fix = 0x7fffffff;
 		survey->filled &= ~SURVEY_INFO_TIME_BUSY;
 	}
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index f41c91c..64e45b2 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -331,6 +331,17 @@ enum ath10k_hw_4addr_pad {
 	ATH10K_HW_4ADDR_PAD_BEFORE,
 };
 
+enum ath10k_hw_cc_wraparound_type {
+	ATH10K_HW_CC_WRAP_DISABLED = 0,
+
+	/* This type is when the HW chip has a quirky Cycle Counter
+	 * wraparound which resets to 0x7fffffff instead of 0. All
+	 * other CC related counters (e.g. Rx Clear Count) are divided
+	 * by 2 so they never wraparound themselves.
+	 */
+	ATH10K_HW_CC_WRAP_SHIFTED_ALL = 1,
+};
+
 /* Target specific defines for MAIN firmware */
 #define TARGET_NUM_VDEVS			8
 #define TARGET_NUM_PEER_AST			2
-- 
1.9.1

