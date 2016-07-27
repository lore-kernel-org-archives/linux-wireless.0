Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10312 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771AbcG0MiD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2016 08:38:03 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH 4/4] ath10k: Remove 4-addr padding related hw_param configuration
Date: Wed, 27 Jul 2016 18:06:46 +0530
Message-ID: <1469623006-13178-5-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20160727_143806_896674_3EB887B3)
In-Reply-To: <1469623006-13178-1-git-send-email-vthiagar@qti.qualcomm.com>
References: <1469623006-13178-1-git-send-email-vthiagar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hw_4addr_pad was added to handle different types of padding
in 4-address rx frame. But this padding is not very specific
to 4-address, it can happen even with three address + ethernet
decap mode. Since the  padding information can be obtained
through Rx desc for QCA99X0 and newer chips, this hw_param
is not needed any more.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 9 ---------
 drivers/net/wireless/ath/ath10k/hw.h   | 8 --------
 2 files changed, 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 9c5e93b..74d0ace 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -60,7 +60,6 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.otp_exe_param = 0,
 		.channel_counters_freq_hz = 88000,
 		.max_probe_resp_desc_thres = 0,
-		.hw_4addr_pad = ATH10K_HW_4ADDR_PAD_AFTER,
 		.cal_data_len = 2116,
 		.fw = {
 			.dir = QCA988X_HW_2_0_FW_DIR,
@@ -80,7 +79,6 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.otp_exe_param = 0,
 		.channel_counters_freq_hz = 88000,
 		.max_probe_resp_desc_thres = 0,
-		.hw_4addr_pad = ATH10K_HW_4ADDR_PAD_AFTER,
 		.cal_data_len = 2116,
 		.fw = {
 			.dir = QCA9887_HW_1_0_FW_DIR,
@@ -117,7 +115,6 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.otp_exe_param = 0,
 		.channel_counters_freq_hz = 88000,
 		.max_probe_resp_desc_thres = 0,
-		.hw_4addr_pad = ATH10K_HW_4ADDR_PAD_AFTER,
 		.cal_data_len = 8124,
 		.fw = {
 			.dir = QCA6174_HW_2_1_FW_DIR,
@@ -136,7 +133,6 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.otp_exe_param = 0,
 		.channel_counters_freq_hz = 88000,
 		.max_probe_resp_desc_thres = 0,
-		.hw_4addr_pad = ATH10K_HW_4ADDR_PAD_AFTER,
 		.cal_data_len = 8124,
 		.fw = {
 			.dir = QCA6174_HW_3_0_FW_DIR,
@@ -155,7 +151,6 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.otp_exe_param = 0,
 		.channel_counters_freq_hz = 88000,
 		.max_probe_resp_desc_thres = 0,
-		.hw_4addr_pad = ATH10K_HW_4ADDR_PAD_AFTER,
 		.cal_data_len = 8124,
 		.fw = {
 			/* uses same binaries as hw3.0 */
@@ -177,7 +172,6 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.cck_rate_map_rev2 = true,
 		.channel_counters_freq_hz = 150000,
 		.max_probe_resp_desc_thres = 24,
-		.hw_4addr_pad = ATH10K_HW_4ADDR_PAD_BEFORE,
 		.tx_chain_mask = 0xf,
 		.rx_chain_mask = 0xf,
 		.max_spatial_stream = 4,
@@ -201,7 +195,6 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.cck_rate_map_rev2 = true,
 		.channel_counters_freq_hz = 150000,
 		.max_probe_resp_desc_thres = 24,
-		.hw_4addr_pad = ATH10K_HW_4ADDR_PAD_BEFORE,
 		.tx_chain_mask = 0xf,
 		.rx_chain_mask = 0xf,
 		.max_spatial_stream = 4,
@@ -224,7 +217,6 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.continuous_frag_desc = true,
 		.channel_counters_freq_hz = 150000,
 		.max_probe_resp_desc_thres = 24,
-		.hw_4addr_pad = ATH10K_HW_4ADDR_PAD_BEFORE,
 		.tx_chain_mask = 3,
 		.rx_chain_mask = 3,
 		.max_spatial_stream = 2,
@@ -285,7 +277,6 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.cck_rate_map_rev2 = true,
 		.channel_counters_freq_hz = 125000,
 		.max_probe_resp_desc_thres = 24,
-		.hw_4addr_pad = ATH10K_HW_4ADDR_PAD_BEFORE,
 		.tx_chain_mask = 0x3,
 		.rx_chain_mask = 0x3,
 		.max_spatial_stream = 2,
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index cdd2ce4..1620e76 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -338,11 +338,6 @@ enum ath10k_hw_rate_rev2_cck {
 	ATH10K_HW_RATE_REV2_CCK_SP_11M,
 };
 
-enum ath10k_hw_4addr_pad {
-	ATH10K_HW_4ADDR_PAD_AFTER,
-	ATH10K_HW_4ADDR_PAD_BEFORE,
-};
-
 enum ath10k_hw_cc_wraparound_type {
 	ATH10K_HW_CC_WRAP_DISABLED = 0,
 
@@ -395,9 +390,6 @@ struct ath10k_hw_params {
 	 */
 	u32 max_probe_resp_desc_thres;
 
-	/* The padding bytes's location is different on various chips */
-	enum ath10k_hw_4addr_pad hw_4addr_pad;
-
 	u32 tx_chain_mask;
 	u32 rx_chain_mask;
 	u32 max_spatial_stream;
-- 
1.9.1

