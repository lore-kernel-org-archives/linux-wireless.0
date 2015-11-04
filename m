Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:34604 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbbKDLxu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2015 06:53:50 -0500
Received: by wmff134 with SMTP id f134so108245414wmf.1
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2015 03:53:49 -0800 (PST)
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH 2/4] ath10k: update missing hw_params of QCA9377 hw1.1
Date: Wed,  4 Nov 2015 12:53:33 +0100
Message-Id: <1446638015-23310-3-git-send-email-bartosz.markowski@tieto.com> (sfid-20151104_125355_598565_A83E6AA1)
In-Reply-To: <1446638015-23310-1-git-send-email-bartosz.markowski@tieto.com>
References: <1446638015-23310-1-git-send-email-bartosz.markowski@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The uart_pin was incorrectly configured for QCA9377
and the recently added hw_params were omitted.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index c8f6ca284b9d..a30d41559134 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -141,8 +141,10 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.id = QCA9377_HW_1_1_DEV_VERSION,
 		.name = "qca9377 hw1.1",
 		.patch_load_addr = QCA9377_HW_1_0_PATCH_LOAD_ADDR,
-		.uart_pin = 7,
+		.uart_pin = 6,
 		.otp_exe_param = 0,
+		.channel_counters_freq_hz = 88000,
+		.max_probe_resp_desc_thres = 0,
 		.fw = {
 			.dir = QCA9377_HW_1_0_FW_DIR,
 			.fw = QCA9377_HW_1_0_FW_FILE,
-- 
2.1.2

