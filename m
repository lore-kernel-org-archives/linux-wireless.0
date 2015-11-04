Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34681 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515AbbKDLxw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2015 06:53:52 -0500
Received: by wikq8 with SMTP id q8so90576322wik.1
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2015 03:53:51 -0800 (PST)
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH 4/4] ath10k: add QCA9377 hw1.0 support
Date: Wed,  4 Nov 2015 12:53:35 +0100
Message-Id: <1446638015-23310-5-git-send-email-bartosz.markowski@tieto.com> (sfid-20151104_125358_202226_78CC61D9)
In-Reply-To: <1446638015-23310-1-git-send-email-bartosz.markowski@tieto.com>
References: <1446638015-23310-1-git-send-email-bartosz.markowski@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add new BMI target version and chip id revision. Register it
on supported chips list.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 18 ++++++++++++++++++
 drivers/net/wireless/ath/ath10k/hw.h   |  3 +++
 drivers/net/wireless/ath/ath10k/pci.c  |  2 ++
 3 files changed, 23 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index b80b8f372354..f41329617ae4 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -160,6 +160,24 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 			.board_ext_size = QCA99X0_BOARD_EXT_DATA_SZ,
 		},
 	},
+        {
+                .id = QCA9377_HW_1_0_DEV_VERSION,
+                .dev_id = QCA9377_1_0_DEVICE_ID,
+                .name = "qca9377 hw1.0",
+                .patch_load_addr = QCA9377_HW_1_0_PATCH_LOAD_ADDR,
+                .uart_pin = 6,
+                .otp_exe_param = 0,
+                .channel_counters_freq_hz = 88000,
+                .max_probe_resp_desc_thres = 0,
+                .fw = {
+                        .dir = QCA9377_HW_1_0_FW_DIR,
+                        .fw = QCA9377_HW_1_0_FW_FILE,
+                        .otp = QCA9377_HW_1_0_OTP_FILE,
+                        .board = QCA9377_HW_1_0_BOARD_DATA_FILE,
+                        .board_size = QCA9377_BOARD_DATA_SZ,
+                        .board_ext_size = QCA9377_BOARD_EXT_DATA_SZ,
+                },
+        },
 	{
 		.id = QCA9377_HW_1_1_DEV_VERSION,
 		.dev_id = QCA9377_1_0_DEVICE_ID,
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 13aacbdc98e6..713c2bcea178 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -48,6 +48,8 @@
 #define QCA6174_HW_3_0_VERSION		0x05020000
 #define QCA6174_HW_3_2_VERSION		0x05030000
 
+/* QCA9377 target BMI version signatures */
+#define QCA9377_HW_1_0_DEV_VERSION	0x05020000
 #define QCA9377_HW_1_1_DEV_VERSION	0x05020001
 
 enum qca6174_pci_rev {
@@ -69,6 +71,7 @@ enum qca6174_chip_id_rev {
 };
 
 enum qca9377_chip_id_rev {
+	QCA9377_HW_1_0_CHIP_ID_REV = 0x0,
 	QCA9377_HW_1_1_CHIP_ID_REV = 0x1,
 };
 
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 14dce2a1b39f..679a3ebb34af 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -86,6 +86,8 @@ static const struct ath10k_pci_supp_chip ath10k_pci_supp_chips[] = {
 	{ QCA6174_2_1_DEVICE_ID, QCA6174_HW_3_2_CHIP_ID_REV },
 
 	{ QCA99X0_2_0_DEVICE_ID, QCA99X0_HW_2_0_CHIP_ID_REV },
+
+	{ QCA9377_1_0_DEVICE_ID, QCA9377_HW_1_0_CHIP_ID_REV },
 	{ QCA9377_1_0_DEVICE_ID, QCA9377_HW_1_1_CHIP_ID_REV },
 };
 
-- 
2.1.2

