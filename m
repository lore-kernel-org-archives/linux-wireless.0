Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:36062 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756970AbdEUUB2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 21 May 2017 16:01:28 -0400
Received: by mail-lf0-f68.google.com with SMTP id h4so3696229lfj.3
        for <linux-wireless@vger.kernel.org>; Sun, 21 May 2017 13:01:27 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC 9/9] ath10k: add QCA9377 sdio hw_param item
Date: Sun, 21 May 2017 21:59:11 +0200
Message-Id: <1495396751-4805-10-git-send-email-erik.stromdahl@gmail.com> (sfid-20170521_220203_029179_D8DE6BDB)
In-Reply-To: <1495396751-4805-1-git-send-email-erik.stromdahl@gmail.com>
References: <1495396751-4805-1-git-send-email-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hardware parameters for QCA9377 sdio devices.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 25 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/hw.h   |  1 +
 2 files changed, 26 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index edf9943..2a9afde 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -322,6 +322,31 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.start_once = true,
 	},
 	{
+		.id = QCA9377_HW_1_1_DEV_VERSION,
+		.dev_id = QCA9377_1_0_DEVICE_ID,
+		.name = "qca9377 hw1.1 sdio",
+		.patch_load_addr = QCA9377_HW_1_0_PATCH_LOAD_ADDR,
+		.uart_pin = 19,
+		.otp_exe_param = 0,
+		.channel_counters_freq_hz = 88000,
+		.max_probe_resp_desc_thres = 0,
+		.cal_data_len = 8124,
+		.fw = {
+			.dir = QCA9377_HW_1_0_FW_DIR,
+			.board = QCA9377_HW_1_0_BOARD_DATA_FILE_SDIO,
+			.board_size = QCA9377_BOARD_DATA_SZ,
+			.board_ext_size = QCA9377_BOARD_EXT_DATA_SZ,
+		},
+		.hw_ops = &qca6174_ops,
+		.hw_clk = qca6174_clk,
+		.target_cpu_freq = 176000000,
+		.decap_align_bytes = 4,
+		.max_num_peers = TARGET_QCA9377_HL_NUM_PEERS,
+		.is_high_latency = true,
+		.bus = ATH10K_BUS_SDIO,
+		.start_once = true,
+	},
+	{
 		.id = QCA4019_HW_1_0_DEV_VERSION,
 		.dev_id = 0,
 		.name = "qca4019 hw1.0",
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index cc3d0eb..676c855 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -128,6 +128,7 @@ enum qca9377_chip_id_rev {
 #define QCA9377_HW_1_0_FW_DIR          ATH10K_FW_DIR "/QCA9377/hw1.0"
 #define QCA9377_HW_1_0_BOARD_DATA_FILE "board.bin"
 #define QCA9377_HW_1_0_BOARD_DATA_FILE_USB "board-usb.bin"
+#define QCA9377_HW_1_0_BOARD_DATA_FILE_SDIO "board-sdio.bin"
 #define QCA9377_HW_1_0_PATCH_LOAD_ADDR	0x1234
 
 /* QCA4019 1.0 definitions */
-- 
2.7.4
