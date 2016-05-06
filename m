Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44598 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758126AbcEFMIU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2016 08:08:20 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH 2/2] ath10k: Fix survey reporting with QCA4019
Date: Fri, 6 May 2016 17:37:03 +0530
Message-ID: <1462536423-9903-2-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20160506_140823_594864_9ADD98A9)
In-Reply-To: <1462536423-9903-1-git-send-email-vthiagar@qti.qualcomm.com>
References: <1462536423-9903-1-git-send-email-vthiagar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In QCA4019, cycle counter wraparound in same fashion
as QCA988X. When the cycle counter wraparound it
resets to 0x7fffffff. Set has_shifted_cc_wraparound to
true for QCA4019 to enable the code path to handle cycle
counter wraparound for consistent survey report.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index e94cb87..f6018be 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -202,6 +202,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.name = "qca4019 hw1.0",
 		.patch_load_addr = QCA4019_HW_1_0_PATCH_LOAD_ADDR,
 		.uart_pin = 7,
+		.has_shifted_cc_wraparound = true,
 		.otp_exe_param = 0x0010000,
 		.continuous_frag_desc = true,
 		.channel_counters_freq_hz = 125000,
-- 
1.9.1

