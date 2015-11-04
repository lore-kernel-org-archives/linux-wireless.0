Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:37586 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851AbbKDLxt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2015 06:53:49 -0500
Received: by wmff134 with SMTP id f134so39394528wmf.0
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2015 03:53:48 -0800 (PST)
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH 1/4] ath10k: fix the currently supported QCA9377 target version name
Date: Wed,  4 Nov 2015 12:53:32 +0100
Message-Id: <1446638015-23310-2-git-send-email-bartosz.markowski@tieto.com> (sfid-20151104_125354_295906_BD0403D6)
In-Reply-To: <1446638015-23310-1-git-send-email-bartosz.markowski@tieto.com>
References: <1446638015-23310-1-git-send-email-bartosz.markowski@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When introducing the original QCA9377 support, the chip target
version was wrongly picked. The chip advertising itself with
bmi target value equal to 0x05020001 is in fact a 1.1 revision.
I realized this once I got a real 1.1 hw to play with.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 4 ++--
 drivers/net/wireless/ath/ath10k/hw.h   | 8 ++++++--
 drivers/net/wireless/ath/ath10k/pci.c  | 2 +-
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index aa9bd92ac4ed..c8f6ca284b9d 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -138,8 +138,8 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		},
 	},
 	{
-		.id = QCA9377_HW_1_0_DEV_VERSION,
-		.name = "qca9377 hw1.0",
+		.id = QCA9377_HW_1_1_DEV_VERSION,
+		.name = "qca9377 hw1.1",
 		.patch_load_addr = QCA9377_HW_1_0_PATCH_LOAD_ADDR,
 		.uart_pin = 7,
 		.otp_exe_param = 0,
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 39966a05c1cc..01bf2244f54c 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -42,6 +42,8 @@
 #define QCA6174_HW_3_0_VERSION		0x05020000
 #define QCA6174_HW_3_2_VERSION		0x05030000
 
+#define QCA9377_HW_1_1_DEV_VERSION	0x05020001
+
 enum qca6174_pci_rev {
 	QCA6174_PCI_REV_1_1 = 0x11,
 	QCA6174_PCI_REV_1_3 = 0x13,
@@ -60,6 +62,10 @@ enum qca6174_chip_id_rev {
 	QCA6174_HW_3_2_CHIP_ID_REV = 10,
 };
 
+enum qca9377_chip_id_rev {
+	QCA9377_HW_1_1_CHIP_ID_REV = 0x1,
+};
+
 #define QCA6174_HW_2_1_FW_DIR		"ath10k/QCA6174/hw2.1"
 #define QCA6174_HW_2_1_FW_FILE		"firmware.bin"
 #define QCA6174_HW_2_1_OTP_FILE		"otp.bin"
@@ -85,8 +91,6 @@ enum qca6174_chip_id_rev {
 #define QCA99X0_HW_2_0_PATCH_LOAD_ADDR	0x1234
 
 /* QCA9377 1.0 definitions */
-#define QCA9377_HW_1_0_DEV_VERSION     0x05020001
-#define QCA9377_HW_1_0_CHIP_ID_REV     0x1
 #define QCA9377_HW_1_0_FW_DIR          ATH10K_FW_DIR "/QCA9377/hw1.0"
 #define QCA9377_HW_1_0_FW_FILE         "firmware.bin"
 #define QCA9377_HW_1_0_OTP_FILE        "otp.bin"
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 3fca200b986c..c444b43f183d 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -92,7 +92,7 @@ static const struct ath10k_pci_supp_chip ath10k_pci_supp_chips[] = {
 	{ QCA6174_2_1_DEVICE_ID, QCA6174_HW_3_2_CHIP_ID_REV },
 
 	{ QCA99X0_2_0_DEVICE_ID, QCA99X0_HW_2_0_CHIP_ID_REV },
-	{ QCA9377_1_0_DEVICE_ID, QCA9377_HW_1_0_CHIP_ID_REV },
+	{ QCA9377_1_0_DEVICE_ID, QCA9377_HW_1_1_CHIP_ID_REV },
 };
 
 static void ath10k_pci_buffer_cleanup(struct ath10k *ar);
-- 
2.1.2

