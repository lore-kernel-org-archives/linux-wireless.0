Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:40716 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbaJFMRF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2014 08:17:05 -0400
Received: by mail-wi0-f173.google.com with SMTP id fb4so4359246wid.6
        for <linux-wireless@vger.kernel.org>; Mon, 06 Oct 2014 05:17:03 -0700 (PDT)
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH] ath10k: advertise all possible firmware(-api) files
Date: Mon,  6 Oct 2014 14:16:41 +0200
Message-Id: <1412597801-19298-1-git-send-email-bartosz.markowski@tieto.com> (sfid-20141006_141711_040774_4C64911C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is required if we take into account possibility to load the driver
from initrd (RAM disk), so in other words: very early in the boot process,
before the file system is visible.

In such case we need to have the firmware files accessible from ram disk too,
and this patch guarantee this.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/hw.h  | 1 -
 drivers/net/wireless/ath/ath10k/pci.c | 4 +++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 006a9cb..6dca960 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -28,7 +28,6 @@
 #define QCA988X_HW_2_0_CHIP_ID_REV	0x2
 #define QCA988X_HW_2_0_FW_DIR		"ath10k/QCA988X/hw2.0"
 #define QCA988X_HW_2_0_FW_FILE		"firmware.bin"
-#define QCA988X_HW_2_0_FW_3_FILE	"firmware-3.bin"
 #define QCA988X_HW_2_0_OTP_FILE		"otp.bin"
 #define QCA988X_HW_2_0_BOARD_DATA_FILE	"board.bin"
 #define QCA988X_HW_2_0_PATCH_LOAD_ADDR	0x1234
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 8a04904..730bb18 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2600,5 +2600,7 @@ module_exit(ath10k_pci_exit);
 MODULE_AUTHOR("Qualcomm Atheros");
 MODULE_DESCRIPTION("Driver support for Atheros QCA988X PCIe devices");
 MODULE_LICENSE("Dual BSD/GPL");
-MODULE_FIRMWARE(QCA988X_HW_2_0_FW_DIR "/" QCA988X_HW_2_0_FW_3_FILE);
+MODULE_FIRMWARE(QCA988X_HW_2_0_FW_DIR "/" QCA988X_HW_2_0_FW_FILE);
+MODULE_FIRMWARE(QCA988X_HW_2_0_FW_DIR "/" ATH10K_FW_API2_FILE);
+MODULE_FIRMWARE(QCA988X_HW_2_0_FW_DIR "/" ATH10K_FW_API3_FILE);
 MODULE_FIRMWARE(QCA988X_HW_2_0_FW_DIR "/" QCA988X_HW_2_0_BOARD_DATA_FILE);
-- 
1.8.2

